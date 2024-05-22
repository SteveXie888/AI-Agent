#!/bin/bash

#先安裝docker ollama 和 open web ui
# sudo curl -fsSL https://ollama.com/install.sh | sh
# sudo docker run -d --network=host --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
# yum install jq -y
# sudo yum install epel-release
# touch .@@.sh in ~/

#用llama3 並建立modelfile 名稱為 aiagent

# FROM llama3
# # sets the temperature to 1 [higher is more creative, lower is more coherent]
# PARAMETER temperature 1
# # sets the context window size to 4096, this controls how many tokens the LLM can use as context to generate the next token
# PARAMETER num_ctx 4096
# PARAMETER num_thread 8
# # sets a custom system message to specify the behavior of the chat assistant
# SYSTEM '''
# 1. You are a linux professional expert that knows python and other programming language commands very well especially in bash script.
# 2. All you generated commands should be able to execute directly in bash command line environment without prompting a yes or no confirming infomation.
# 3. Your recommand linux instruction outputs or code must be embedded between  |output| and |/output| for my code to be able to interpret.
# 4. Do not generate any description and program output sample.
# '''

# FROM llama3
# SYSTEM """1. You are a linux professional expert that knows python and other programming language commands very well especially in bash script.
# 2. All you generated commands should be able to execute directly in bash command line environment without prompting a yes or no confirming infomation.
# 3. Your recommand linux instruction outputs or code must be embedded between  |output| and |/output| for my code to be able to interpret.
# 4. Do not generate any description and program output sample."""
# PARAMETER mirostat 2
# PARAMETER mirostat_tau 3
# PARAMETER temperature 0.5
# PARAMETER num_ctx 4096
# PARAMETER num_thread 8
# PARAMETER num_predict 100
# PARAMETER num_keep 24
# PARAMETER stop "<|start_header_id|>"
# PARAMETER stop "<|end_header_id|>"
# PARAMETER stop "<|eot_id|>"

# 完成後，在指令行下@ 指令，例如 @ give me current listening port

# Function that takes one parameter and prints it
function aiagent() {
    # Initialize an empty string to store concatenated arguments
    args_string=""

    # Iterate over all arguments passed to the script
    for arg in "$*"; do
        # Append each argument to the string, separated by a space
        args_string="$args_string $arg"
    done
    #echo "The message is: $args_string"

    if [ ! -f \"~/.ollamahis.txt\" ]; then
        # echo ".ollamahis.txt not found create one"
        touch ~/.ollamahis.txt
    fi

    # parameter_curl='{
    #     "model": "aiagent",
    #     "messages": [
    #         {
    #             "role": "user",
    #             "content": "ZmbLuZw45ZLbnBg8"
    #         }
    #     ],
    #     "stream": false
    # }'

    parameter_prefix='{
        "model": "aiagent",
        "messages": ['

    parameter_body=' {
                "role": "user",
                "content": "ZmbLuZw45ZLbnBg8"
            }'
    parameter_body="${parameter_body//\"ZmbLuZw45ZLbnBg8\"/\"$args_string\"}"
    parameter_body="$(cat ~/.ollamahis.txt) ${parameter_body}"
    # echo $parameter_body >>~/.ollamahis.txt
    parameter_suffix='],
        "stream": false
    }'
    parameter_curl="$parameter_prefix $parameter_body $parameter_suffix"

    # {
    #   "role": "assistant",
    #   "content": "why is the sky blue?"
    # }

    agentrespond=$(curl -s http://localhost:11434/api/chat -d "${parameter_curl}" | jq .message.content)
    echo ${parameter_body} >~/.ollamahis.txt
    echo ",{ \"role\":\"assistant\", \"content\": ${agentrespond} }, " >>~/.ollamahis.txt
    echo $agentrespond | xargs -0 echo -e
}

# Check if a parameter is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <message>"
    exit 1
fi

# Call the function with the first argument
aiagent "$*"

# add hot key to home folder's .bashrc
if [ $(cat ~/.bashrc | grep @@.sh | wc -l) -eq 0 ]; then
    echo alias @=\'~/.@@.sh\' >>~/.bashrc
fi
