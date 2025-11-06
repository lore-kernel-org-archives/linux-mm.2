Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307D2CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 17:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911978E0010; Thu,  6 Nov 2025 12:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA1B8E0002; Thu,  6 Nov 2025 12:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8263A8E0010; Thu,  6 Nov 2025 12:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 705808E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 12:02:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 232F51401F2
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:02:48 +0000 (UTC)
X-FDA: 84080801616.10.069109A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1999C1C001F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:02:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bNFJN8cb;
	spf=pass (imf21.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762448566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPpU0awjnKN/G6+KlazEDar1/1ZBM2a+Pz44QPC0Ujg=;
	b=zUaRv1mEdv44NR20WMV35i7TQoAYiI1juYeffkamUKjwrfo7u+kSW1EIlZZ34YKx4bZFOa
	ljJW2BhZ07J8a0jkMaesViZKBU8U5Ba3UKH9P1Wnt72BaPhdE0WA69z82OhXS6eWWFlKOc
	xdCEG9oUix34Qz1zs1H7Lv4j7QY07ZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762448566; a=rsa-sha256;
	cv=none;
	b=n41jV4K0qBz1FIjmmVftoc5y25Tcgf/tecocFG5lEKdRQ3ptgit2mBPrujiulDBbh92L+z
	4B+L7n0X/x//fhrzRIgtXvYYAxmCCV1vwDukJE3a6ADja/eFmgv37NlEsA5WXy7QP/YlxU
	OYhhT2qnkbhpt5gsEkBTFAL8OhOATIA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bNFJN8cb;
	spf=pass (imf21.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-330b4739538so1203847a91.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 09:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448565; x=1763053365; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YPpU0awjnKN/G6+KlazEDar1/1ZBM2a+Pz44QPC0Ujg=;
        b=bNFJN8cbp7JNRVxl8pjxM7faDDnDt70UjfkfXwf/z9jNNnN1ewro6v1e20E/5hcw9N
         cDFTDtdhzqBqbapWDiE/W1/F4SfE5FPsdOAo5fLecFfT+DYv50Wi1x+cQIvtijviADmo
         3Rfeis/JQ1BgHDdXlBCB3OvHH73Aa9ZEZqpsVYibJUdSXT15CloyF2THnAFS+Zs5ATo6
         9s/wYuXrIiBlNFB1VHYrXpjdQ169i8L+R0ajVzYox+1WIy2rCbT5aPTI1Cu4rnEpTzDd
         Tdy3tdfOpzgwNGki/rknRjrdQF9U60rBn1Mn88lfga8d8F/VfPiiZiSL/GJrjZxWhA2Q
         MBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448565; x=1763053365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPpU0awjnKN/G6+KlazEDar1/1ZBM2a+Pz44QPC0Ujg=;
        b=dvmAIZnh4Hzb5mKIjATprRbBjNTfgUURevKjyp0tSL5gyen9ATvmWjsaBrJG9TZZyz
         VPwxsWjoXB9mtToAIzlXgNhHj4u7BdmwVpjuRXUxdu7vnPGcdglqAq9soZ041bG+eo8e
         ARV4/46zSlPhHVCubbe0P57lN9JmGMliinaPU0zv0yxbHRE68VRsE7ja43pnyteyNCrW
         1CdTNiu3X5HsAHzDamqjt9FgqCRPtCi/l0DTSLnB9bkZ/NP+jGA0mp/EXaH+VdeBWXnh
         JLCNwJ6oZiUZpSVjTN73OXDa2LDmmnvOSrsHFwWPwgbo4rokrNNCJCHkKlVxxTH2BXJz
         +v7w==
X-Forwarded-Encrypted: i=1; AJvYcCWrktVnkH99aBvcZqI3M7eXnVOC9TpUs/rIrSPHSkMXZjzegoYAZwppb+OlfC9lkbSRGL4sla4FtA==@kvack.org
X-Gm-Message-State: AOJu0YygPgTOv7EwbtFBXK/g7sp4npfo5o+sd/QaZaHzrD06sTb0GxBr
	j5TQWS8aQk+RjIPakdBnwlx/GlqDOjUKrBdrnFd68QaNff2Jvy58RZXA
X-Gm-Gg: ASbGncssxvuWT6SRacqTtagH9ptVT83ApRRrrYO3WF26LEz54lexLhE5Z7OyyumFzxL
	CUtDwR8OSl1KKipZvjZ9rMxekOn+vqrO2dcheJScvx/nmYivB6uK3ZlmYhKHhJ7vvZE4yZXtr0r
	1SqVi+IEMZCbYyd5hw8zFMokn3hvdr8k3NYQngWYEg1e5Yu5zBXS9oHKYH/6hmWD1QLGkcSh1qY
	b13GNzsE3AbJ88nCQfY9LDkpVb9LVuOqICIZGzFwPXPR9SP92+Sekls+NRwbglUVMi68VOBzdl1
	OhnImxjYm5Vnbjg/oomjwQbIo+YLmabNiBVy3JUbI16hkL2X0aaGr00O7IQdXDP31xyetjXQS4+
	5L4T6daISRHNRkjYQwsGHOrjp1EYG20wAedeeOs0V3dnR59DEiXxQ476KLrXSkj1//OSpjL6L1/
	Ray1Hvplg9ztqEgdyQXjCb
X-Google-Smtp-Source: AGHT+IF+6Xuvm4wgSMuStjeXOxmAX8A3ViGGV9aMWlq3E5tLch0rpxg/9QHMKCn3GRSTdg/WUL+Q6Q==
X-Received: by 2002:a17:90b:2f87:b0:330:6d5e:f17b with SMTP id 98e67ed59e1d1-341a6dc4b6emr10139367a91.21.1762448564481;
        Thu, 06 Nov 2025 09:02:44 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d0456b34sm3029537a91.3.2025.11.06.09.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 09:02:43 -0800 (PST)
Message-ID: <37aa86c5-2659-4626-a80b-b3d07c2512c9@gmail.com>
Date: Thu, 6 Nov 2025 09:02:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
To: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org,
 joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com,
 mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net,
 lance.yang@linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20251105074917.94531-1-leon.huangfu@shopee.com>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20251105074917.94531-1-leon.huangfu@shopee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hff9t35auyzm36f31osy71xapzfrzu81
X-Rspam-User: 
X-Rspamd-Queue-Id: 1999C1C001F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762448565-729688
X-HE-Meta: U2FsdGVkX1+zjvQd5EWm75ol7LeY57/+vjFyasq9V9abCeG2HdU6qlk0PIqUbOUJykjZPMLOBNjc42SBB9svXykFC6EWqkNaAo/wZJCuoiZ5Tg6HJKf0amLILgxJfN2ZFBOLZqT4jXnsaqMLAiln5b+WctPNaC6xgGrIHqD4ZusxpAHiH0fwmK+JneB9vKFkSLQLnM4M5dZ30IP/RqL+e4ivhINwwLQVVv+onvDyuuK/pA6hMXfFeRn9TIoau6xZCcucQvVV4GfmPQLQh1C/XUn6cICDYIReS2fFs2I0GW9xgXZvFZxDbQmqUgtUQlxMHtcF6l1QLj2Bqf3xY5V9YsZ4YBXWYJsMpl3//0E+yQmG4xUey/WOg3gr592OR7+KoEzo5Yd+gEMRwnpDy9a2wEwi//oVSFcAMr4XpIDex/kpnj3Fu7UzaGeh8eEH6FjFT/qzueteuQzmUCTd1aUGu3ioK3l/ac2wt5GjvbuEXBB1qltuKIcXZij907wy2g+F3LRfGW/EounAb7zqPc1usmeUBF7n7Y/n9vZTRTwfZz25HGwupLzD9WNug/UpP/0y3mE+Zejbaq7CKtw8oyA5FwnLUdUNCXzB+TB6oyq2CHdVzzEbXpoIcfXv8/PhPfAKQ1dCZxs9YIKh8s4UwYmKYtDIXPmRRQeh/aV/ouBCIAU0F9xLvpqbUlxRB6RKybPkLhA3+dWdZpUalBIXkioESkywVb98XtozmQabJTPCAPjV7cZuFX4vXNxV3ybCGUCYEw+abXYAqe0mMvrCVu29cCpzoNUe90Y4V74zYGSFfMqJvYx5cMApy/PeFQW5rZfOJFZNpMBOu3nj4jY0HrWxIY86tyba6MoGpboty0P7WUdjHdlvjzkMQ1mkTcx5wJ3vTU1zdmD8E7DOQzJbmxbEwl1kMAFJcL5HmgQ5C2w3hIWbGA1431NJTnnro7ALoOrMJMCahzhCX90GPmBI7UJ
 OcVToydJ
 DQGcfWgeimWPm1oPBxlsmChnzvdeiSZIlYagFYFrSNWLb4J1bWZGDSULqwPus6AzRkq0GEolAx55CYmUsE1yk5PpesG5bFvaDD4NgzUtn6j+nIsb3mexsYJfPoDjZcXhFiWnf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/4/25 11:49 PM, Leon Huang Fu wrote:
> On high-core count systems, memory cgroup statistics can become stale
> due to per-CPU caching and deferred aggregation. Monitoring tools and
> management applications sometimes need guaranteed up-to-date statistics
> at specific points in time to make accurate decisions.
> 
> This patch adds write handlers to both memory.stat and memory.numa_stat
> files to allow userspace to explicitly force an immediate flush of
> memory statistics. When "1" is written to either file, it triggers
> __mem_cgroup_flush_stats(memcg, true), which unconditionally flushes
> all pending statistics for the cgroup and its descendants.
> 
> The write operation validates the input and only accepts the value "1",
> returning -EINVAL for any other input.
> 
> Usage example:
>    # Force immediate flush before reading critical statistics
>    echo 1 > /sys/fs/cgroup/mygroup/memory.stat
>    cat /sys/fs/cgroup/mygroup/memory.stat
> 
> This provides several benefits:
> 
> 1. On-demand accuracy: Tools can flush only when needed, avoiding
>     continuous overhead
> 
> 2. Targeted flushing: Allows flushing specific cgroups when precision
>     is required for particular workloads

I'm curious about your use case. Since you mention required precision,
are you planning on manually flushing before every read?

> 
> 3. Integration flexibility: Monitoring scripts can decide when to pay
>     the flush cost based on their specific accuracy requirements

[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c34029e92bab..d6a5d872fbcb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4531,6 +4531,17 @@ int memory_stat_show(struct seq_file *m, void *v)
>   	return 0;
>   }
> 
> +int memory_stat_write(struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
> +{
> +	if (val != 1)
> +		return -EINVAL;
> +
> +	if (css)
> +		css_rstat_flush(css);

This is a kfunc. You can do this right now from a bpf program without
any kernel changes.


