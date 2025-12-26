Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C7FE8FDB5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95156B0005; Fri, 26 Dec 2025 15:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D430B6B0089; Fri, 26 Dec 2025 15:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25496B008A; Fri, 26 Dec 2025 15:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AABEB6B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:24:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59CBF1A03DD
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:24:39 +0000 (UTC)
X-FDA: 84262750278.20.E87924F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id CAF29180005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:24:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GqGfQRKl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766780677; a=rsa-sha256;
	cv=none;
	b=IygZ0oUuBB7LAX2IE5pP8WamFpsEvKCQu1vregnW2tvdPxP8UfbqxNkYdjUq/CL07VtGHE
	YsBnKt0mW5J2v8eTbanCBQmpb2kKZcnfvYi2LDa+nvtbl7td4JKkploDN+ojf3b8Vh8K14
	W0pc4RTaRws7q2+y/YAtPhW4XEmcQes=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GqGfQRKl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766780677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVoo0z1EjeMhpmoJpAmiOascZOJ5Tgl2Hkp1d1X4DT8=;
	b=33RiGCcqIyCIZYt50sd702dfKst+0iwd51hO6UszvQWLcpXO+C4zsrmD3IhlM+WIS2dq1e
	mwH+xIPUjislew6KNGr3CRgBujZtj9pkADebTs9K4tFfM5M8GBk5FtqL+AO/ecg3CbUPC3
	F1gosKAC9vLuuCsQHr/ocII/DkgVjfE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766780676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YVoo0z1EjeMhpmoJpAmiOascZOJ5Tgl2Hkp1d1X4DT8=;
	b=GqGfQRKloU1nY21aIbvz0nYxLty2+dk/7c5zah3cxcn6in4WQnf1rshpuMVSM5Zqs1oobi
	NxU8Ex6YfmeYON6XDIoRh4JMmTHj1pxIga000OZmwqENB7M/o5FgLCc2iXJVVMHKXwuhul
	u/jlnOAAfkXC5CiGhk+R9DdJU57mvh0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-pVBkpX6BMCChwBTQCI5XRw-1; Fri, 26 Dec 2025 15:24:34 -0500
X-MC-Unique: pVBkpX6BMCChwBTQCI5XRw-1
X-Mimecast-MFC-AGG-ID: pVBkpX6BMCChwBTQCI5XRw_1766780673
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b19a112b75so1662335185a.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:24:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766780673; x=1767385473;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVoo0z1EjeMhpmoJpAmiOascZOJ5Tgl2Hkp1d1X4DT8=;
        b=kTMsrYHEMYc4I2O8MIrySBnqbfEIFAFTZnroTFbTNWAt8z7GRzEIo5LCZfVWar3rfU
         je3Om0z9OYmhoMIZ/yJNAj8crtsf4xSG173wB51iA9MkHQmI+k6y0DazcUTz6c0oEVwJ
         NgJi1RSwsPtm6HfaCcuGseLKfYq8xxaxcNGm6t2kmUNmAmls29VN60bU4EKq25olqBiB
         AoBPKFVHgt5tuYrXFUwkZjgPNke+QcGHnRlzLnAhfwX1o+r4SI4iCxGqG1FjSMCUiQib
         BktBx0nUQBm0uCZE4FzPd6Ltwd8NFjCETI1k8GKPe71idymFYfnQEdJ+Sb+peX1+SCLQ
         dJlA==
X-Forwarded-Encrypted: i=1; AJvYcCV5l3HM3Xa2WjFoOWKz9wC15dYvoN3D4djlH6R62/K1XadQI2Zhaqh3PVMVAOfnb6qsUy3fHv/ofw==@kvack.org
X-Gm-Message-State: AOJu0YxUmAW9fMHXJ/Quw4bg0qVPv5HyCOurG9g6gfoonCGI4oWamVc4
	dnQiHFJ2LZ3gOxpLsPBULhm/eF6JF872VW3ZnAoQ5F2BotFhBXM3MzrwJbLY4kNI510sOx7BON4
	J3W/cPW/qHSFV2Hi8suwBSEv0Vd0lL5h4vdfqPDHuBRP1UNWiY9J7
X-Gm-Gg: AY/fxX7PCfNlMaO54VugWqmOq8AInrtb4M87oxun1uNd9EP8XQrJ6V20y2ZzHA3VO4j
	KwKleqswaWoU7KkCqFncjtoDhy/KBT/vAAPeIV4eBKFnYdzbq4YAZI9NucONnSqgPpohZAoqExb
	guxBh5Z+llIKhupF9Zg6tTvOL/M3y3EVagcpZDycH3+2mBw8+iI+MeHVmLSlq7X6qB61VJrPLv9
	pFeAYBkMGYuHuPiK04A2FcYXg3z6RMp/+VluyAfOQ0hDmVsyFVPZ13KjH8ukS+j0Q3XN2NKs81b
	8LBdVJFmKiw9IdV+9xGLBQcMb0GtYiZxT4v1hA0gWf2xZvrLI5W2hBuK1lqnXjueJdnmxTMQafb
	ASzefm0F+/v7w+ApfzdrMiM6UGKNODegm5yAfv2Oyw2cRfckDslCT92sE
X-Received: by 2002:a05:620a:454d:b0:8b2:63ed:dd10 with SMTP id af79cd13be357-8c08fbc55a8mr3698251985a.78.1766780673518;
        Fri, 26 Dec 2025 12:24:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhqIf/jULtsdNL08BWEMGPL/DvVfrN+61SrOaEkqG9ajbsq4/twwSZpVmwA+gRdm04CGZ7hg==
X-Received: by 2002:a05:620a:454d:b0:8b2:63ed:dd10 with SMTP id af79cd13be357-8c08fbc55a8mr3698248685a.78.1766780673098;
        Fri, 26 Dec 2025 12:24:33 -0800 (PST)
Received: from ?IPV6:2601:600:947f:f020:85dc:d2b2:c5ee:e3c4? ([2601:600:947f:f020:85dc:d2b2:c5ee:e3c4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0970f8572sm1742247785a.25.2025.12.26.12.24.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Dec 2025 12:24:32 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <84ed9b5d-41d5-44a1-a1ad-2b3de8b50a50@redhat.com>
Date: Fri, 26 Dec 2025 15:24:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 gourry@gourry.net, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 tj@kernel.org, mkoutny@suse.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, chenridong@huaweicloud.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
In-Reply-To: <20251223212032.665731-1-bingjiao@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _aYZfns9shKBGzOY8dqqCtjJufJRp1h9PSRJZj0qtc4_1766780673
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CAF29180005
X-Rspamd-Server: rspam10
X-Stat-Signature: g81o6nd6qg8rufm7jd76pyifefojs3pz
X-HE-Tag: 1766780676-264899
X-HE-Meta: U2FsdGVkX1/a0rkDmDvQN7nOakvLAFK3+VU1xmWVRndZJMQi5hdUpxyWW1yU6LXsuCRlTWHarnR4tjVU1S583jsJkN26lkLyFH06IDNowQo/SsTbFgoFqnlV0Icg+9Yj64RWNG/P0NVapmwba0nldO0aybX75LTRoHc2aIGbY+ZOMa1Vt5GLfNmUgMutALROQ2omAa3v9RYE3ZwxqqG6utKEQYgmHpJOQWV9Sj4bRKQ/B4lWReOdwFzPJ6ogXPNjLvBlxhP0rnO0YzTaSdyerOEQpNzfF3hpzSVU084omi/S2LhlNU2g7gldjcSeFx+vIgy29zyXQBPSLqvZH0UtzaS3m8l94M0vKqEkMDZunW72TOYHOBEp4DLboBZYxVdjp0hXEvntZiWBI1Ep0duzWZ+S3Z4xKvGdglfARi9HbrSaaSuqS2vYtxND7zul3FhKLagtB5ZUPrRmDU/BTQnHoUggDdzDQ2OGP06bzie6HSzg5WhwDWpkk6sO2UfrHrYg8k8+yCblVVsxfxk86oYRKVtm4ARGoqm5hdf27kbVc3VcFqgzJSKBoWJ0EWxeXbN4DmiUp4V95boRyohtMEABldbGGFxoXwJqhwZygdFVgzeh21gESoRlsESgOH6D1C+ISb3Kp6fqWzgM5JDoBhWOLjLQUpuPoCgbzogFZQng3vaXqNgE9vXaA7WwVuyKGu4zEm17LSqPWEbWDJZAmlrzI9hZB/Ok+6p5zPBn4ts2QMDIVIhc8CiY3ZD/iM2OE3Y5EWIE4Z9HnnzLemfH7R8GVDjFvQOIgBAqh5hOoM4E2LEwSzO7gqAevoA/0BMWddoO0bQ7hYU6PUeV4DTg01ADQRf344vJHO8Z1l+FeY7HWLjQT7qhn751/AbbM80aKuVBR05klTrbneDWyWGPziArMoMO1GlcNXQRaulJm+V355TAYSEOdJdE4VlrHl5rdWinTAgbkLoviV0yzaOUps1
 98W68YKd
 aJesxcBHkCkTWmgcpkxP/cijDIL2yOgV5A8o1ZAGcY02vwOlQwrZJXI/13OiiRzKpUecTPez+anl4dDA8AovY24+FOVKInYyTxv54WOlzWs1IenwRJlh+zytSIYK7tciq4Izpgi2B4WwsqHTrlDwX0ougPVyvwrtPggxudfy9HuibFVFjss7AcgrJP8AXiiZvTmiV8+gFKnO7DDELAJsPFOmsO2oy6Q6rHGMzNEpM9+0SOX52WRG4kbaDWUNv0DYDyEVZLQPOW6HP5sLpVQcBu+40EGB3kI0OwwxQRE+EHpJRJg4Dd+xeDqHdQvZpTLnEx4dhK7NDxLy2hviz5ZGtd8/fFTZA18wBNSlohiRizLC9jezIpKvOhmkhQT03m9Wud5fHw3IH8WUbbO8nf3+UHqbWIRyaQFF/4ckPlrDgkhP6gmUVMsuCI1PhnzKFoL8SO8X/O6hMQDQYpvY58qm1LyUTTKVT+E4c3fb8xAnLlq/hxuUyvZmpR+c2CfKNJQaIIQXPdvYgW5btrp+F+Ja6IJSEzXBi9d88sbjithxdSpidOTDpGW5d3u7RBb8E1eiggseA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 4:19 PM, Bing Jiao wrote:
> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.
>
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However:
>
>    1. It does not apply this check in demote_folio_list(), which leads
>       to situations where pages are demoted to nodes that are
>       explicitly excluded from the task's cpuset.mems.
>
>    2. It checks only the nodes in the immediate next demotion hierarchy
>       and does not check all allowed demotion targets in can_demote().
>       This can cause pages to never be demoted if the nodes in the next
>       demotion hierarchy are not set in mems_effective.
>
> These bugs break resource isolation provided by cpuset.mems.
> This is visible from userspace because pages can either fail to be
> demoted entirely or are demoted to nodes that are not allowed
> in multi-tier memory systems.
>
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets. Also update can_demote()
> and demote_folio_list() accordingly.
>
> Reproduct Bug 1:
>    Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>    nodes 2-3 are far-tier memory. All nodes have equal capacity.
>
>    Test script:
>      echo 1 > /sys/kernel/mm/numa/demotion_enabled
>      mkdir /sys/fs/cgroup/test
>      echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>      echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>      echo $$ > /sys/fs/cgroup/test/cgroup.procs
>      swapoff -a
>      # Expectation: Should respect node 0-2 limit.
>      # Observation: Node 3 shows significant allocation (MemFree drops)
>      stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
>
> Reproduct Bug 2:
>    Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>    node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>    All nodes have equal capacity.
>
>    Test script:
>      echo 1 > /sys/kernel/mm/numa/demotion_enabled
>      mkdir /sys/fs/cgroup/test
>      echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>      echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>      echo $$ > /sys/fs/cgroup/test/cgroup.procs
>      swapoff -a
>      # Expectation: Pages are demoted to Nodes 4-5
>      # Observation: No pages are demoted before oom.
>      stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2
>
> Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>   include/linux/cpuset.h     |  6 +++---
>   include/linux/memcontrol.h |  6 +++---
>   kernel/cgroup/cpuset.c     | 16 ++++++++--------
>   mm/memcontrol.c            |  6 ++++--
>   mm/vmscan.c                | 35 +++++++++++++++++++++++------------
>   5 files changed, 41 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index a98d3330385c..eb358c3aa9c0 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>   	task_unlock(current);
>   }
>
> -extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
> +extern nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup);
>   #else /* !CONFIG_CPUSETS */
>
>   static inline bool cpusets_enabled(void) { return false; }
> @@ -301,9 +301,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>   	return false;
>   }
>
> -static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
> +static inline nodemask_t cpuset_node_get_allowed(struct cgroup *cgroup)
>   {
> -	return true;
> +	return node_possible_map;
>   }

The nodemask_t type can be large depending on the setting of 
CONFIG_NODES_SHIFT. Passing a large data structure on stack may not be a 
good idea. You can return a pointer to nodemask_t instead. In that case, 
you will have a add a "const" qualifier to the return type to make sure 
that the node mask won't get accidentally modified. Alternatively, you 
can pass a nodemask_t pointer as an output parameter and copy out the 
nodemask_t data.

The name "cpuset_node_get_allowed" doesn't fit the cpuset naming 
convention. There is a "cpuset_mems_allowed(struct task_struct *)" to 
return "mems_allowed" of a task. This new helper is for returning the 
mems_allowed defined in the cpuset. Perhaps we could just use 
"cpuset_nodes_allowed(struct cgroup *)".

Cheers,
Longman


