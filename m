Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D59CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 19:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69D88E000A; Mon, 10 Nov 2025 14:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41808E0002; Mon, 10 Nov 2025 14:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E318E000A; Mon, 10 Nov 2025 14:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0BA78E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:24:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 770BFB7A15
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:24:12 +0000 (UTC)
X-FDA: 84095673144.18.A90F55A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 75BD2100006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:24:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ap/Tglz5";
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762802650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aZiAriaFpcSO4WwPdL0RMujLkTEysUvR5KxZIxL0hk=;
	b=aOtCCmYqmnl9+aqec52QGrQSehrduuXABo3YvPPCA5duL3s86Np4M6ON9XvYntXY2a8POV
	DnnAz5Eq+sQJJP4Hv5XIfNVVPw+W9t0gLXAK/3+MZaIQDarCVlcjESknm5ws+E8Zd/K1jP
	HMAwM4Dpdc8DU4uph2aToJsL+tnWN28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762802650; a=rsa-sha256;
	cv=none;
	b=RShnsWdzGOlt1Tg/0xnGtn9MKZsrUpzTIRp2jQPSceEnCir7r/Ludgffp16Q6Rtpvs3N62
	sfWJfcBviTXjMkmxXkvB/prziIcUWOv7s3DfKzpe9WjrZ8JMQdhD1BLtiJyI4d+Qgfk0L2
	WoD1BBr1xEqXbuxi8Y1tQFNZmqc+RX0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ap/Tglz5";
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-297e264528aso22799955ad.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762802649; x=1763407449; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6aZiAriaFpcSO4WwPdL0RMujLkTEysUvR5KxZIxL0hk=;
        b=Ap/Tglz5I0CQZLF0gaSsDcRLL3nGNMW9V42ncvEVY4stIDEu2vBLRgdSt6u3kFQ6tB
         BrB6mrP2L5M6paHQskJPnlO0mfRMzC1m5sJEVuQQ+1fxmuxRB2YCd7ylTW4uc0gV/I2m
         3u7NaIRRHGza8FT0+T5jL1x7CcuhTWOJHtvdflmBIt09PvetA/rtkSP3LvCi53/fKY/8
         xKluY27oVV7gtqEeX4BANB7skcEa0ychvdj1k1ZJol0qmusbmU7fgQzzuma/D58GzQIl
         2aXrWS85YulVy1tsuGUF3EKXIe3rdiMSAqcJPjr0VRzBI5QipJiHlCVaOe211LiwSOM0
         vkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762802649; x=1763407449;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aZiAriaFpcSO4WwPdL0RMujLkTEysUvR5KxZIxL0hk=;
        b=j39LroyLJctVbAd9RzJJsy/6/O9EHFv5FSPg/E4tNv6lkTuGXX1eLzY0sEIO7e9dy3
         rt+Iy4DkzDE5WlCEo7TFAAGc6SRgbQpHQL8sJRdUQNZJTroWzDeWufHn40J39NzGHddN
         os0qC3yuAnwE2Qm5jesAnhy1r526dWtxLcrW/1ze4XT6F38C2HxA5KMSsLGbTK0e8qDf
         DeNAGJJZWQsV7I6busD0aByUM9k+USf6NL0hCMv/5LPQKwtgK1RL2IZgybGGOmYrAtbu
         wjktDZnRPO+oizbQrjezbVRHy/ZTugmADuFbXK8imoooVffD6fo4/YsWEhJIa4/W8GaW
         P9pA==
X-Forwarded-Encrypted: i=1; AJvYcCVxZ7dYJmaWa9riB0yB9WgMZmuB3PoPPfo/D70NLoHt9Z4y2pjFJpAPrJ7nbSZLVXJEP2zGGqtbmA==@kvack.org
X-Gm-Message-State: AOJu0Yz4qEfZGTm0hIRveia7w/89S5nwAi9ukdtJNMFCNZH04LD8OGNk
	bClllfH8tAnaLZCUZINZJUi2i9MXEv9/LDh3ghHZzXJsBaRyuilu2qdK
X-Gm-Gg: ASbGncs6NCZ3oBEN5W+Ho66dlKV5X66zFjeiU2w7Y5Y88DtIAOm4eKAZWhl76PowiES
	MR0AIBJMSoPuVlXh45iSQkE7h7MafBkqa4mW8jMKbO3QIzespGHmndIKvlvKAzhDDCtwq0xc4Ey
	iLv+1C0pDc+XfCtiyC39N58sjSMOifvfVZdw7Lp1BuYR2Jvgc3s5/+D88ha8XuDNXU+eYpsuOBc
	G+L4FhVkxpth+CkaCl3v3RMy7GqO1lui7GF06yHg8qhUJF2ZR++fmMVn4kroqwGkUpnWi0BzlMM
	4jeiwiFeUbL5S3QLbgbGtJVy6p51Z77efSihZCUHLCr2tl2pjUtoEauvb1XE7uxpA39ud1Bhj4D
	+oMZUuv6/LSNK9QUo2JVtzGs2lBJDTccfotI1nPQTrJjWNis0ViaRCeQ7ZojHnUUNqymOTAllxD
	zCrAOg1dfklD4E6saMd5205PH51bTbQVJgLUxFOVaPYvTI
X-Google-Smtp-Source: AGHT+IEfAMgWyE3Ndc3ssUFwIgGkinkSWPsXOWikHUjdgiJLp2PdUMQ1cJ8E1GKkTroGDK1oj6VzdA==
X-Received: by 2002:a17:903:fad:b0:295:9b9a:6a7f with SMTP id d9443c01a7336-297e571290cmr120832745ad.49.1762802649165;
        Mon, 10 Nov 2025 11:24:09 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1151:15:9ac6:a0c2:ad3d:6884? ([2620:10d:c090:500::6:8ce7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-296509680e5sm159021765ad.1.2025.11.10.11.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 11:24:08 -0800 (PST)
Message-ID: <51f1f343-c29f-49b5-8016-bbda4bc778a2@gmail.com>
Date: Mon, 10 Nov 2025 11:24:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 kyle.meyer@hpe.com, lance.yang@linux.dev, laoar.shao@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mclapinski@google.com, mhocko@kernel.org, muchun.song@linux.dev,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev
References: <37aa86c5-2659-4626-a80b-b3d07c2512c9@gmail.com>
 <20251110062053.83754-1-leon.huangfu@shopee.com>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20251110062053.83754-1-leon.huangfu@shopee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yhbwt4ykpkpjx3mpy73pjgdw8b65rht9
X-Rspam-User: 
X-Rspamd-Queue-Id: 75BD2100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1762802650-296650
X-HE-Meta: U2FsdGVkX18Im9Mu3MJJFnjLGje9TZKH2nrDaX/Y0ZUaFgD9eEUPmQPbMB5ihOmZrvbkFm+qhDRYHrseKQowscWbueB77g2j59owmpdM3zV4w5ERdTwzuhYb2pgOae1jXBNpV72DnAM2N+W3uIVH26YfSmphepMq5KfqePetah7LnINT3XeaUWdkwe84AxRve614ynbRrG3uUuHNHal9710tnv4LqX7VYhjB2NWb59zWSJHWjz5vmr7McoZU/lwkwk0y7qifwMiZup4usr5F+PKsGihfPuuoE1w7FchiFqdN1du/cFA7L2ddf/RGY5KHSW4+63iq2IWPRrFTquVNoJRHjshwazB9/DX/dU1xG+LesR+RkpUQYDIUSOa9si227p4/6j5bS1Z8+SWzIK6Bo/Q1bzUSQe8OhmtXpp584j1IOAPNEQl6G1z0dWT5n9rrDyK+kGfvLlQspJ4/soE9nuAi56VIPUjv+EKCnLFBm7BlfWyBPm4FIjKli+jtunuFeqFIlfqPBvCHrRR23see8B2SzBC0tJ0o02qA3ZIiSsD7UWGhZ/cxjm/1HFkjRqV4fyhqtjH6n908oyqO8ua98cp+4H2zArGGqeo/BlfwB5632e6rl0YRLKSd2Q7Y3CAf7GNUy+INQEvAZ4RBrHkXVh7ROgiBPhAN4CzP9HjJyNvuWO/1O1oa3eSia9enexSNi/rNeHtuGTMfLoRO2RymXb3ArE5cshvKLhupPIEU0yKXi2QLRBB2JyRmYXuHHfGYbwj7kNnXI+hA8Bln9EXfQSzNAeTIvNYlFzhhZosXKpP2rXv1AWq9HIwzAyVOr90HKl/mpNCYgmZfly0yxYTKYcm+WjhozFkEXYwCqF/hOoIpiacIXCWkfSwlJM89TaNCYPyu+vOHYOv3aCelHwMk1k23psI2AhfoPM95J+EAv8M/r8ltBtYYXkaSKToykYRH7x1dbtiC4RLoGTHx/tc
 DjzAHog5
 nWZvxDzTuvRz96t1Ff4R5VdXzJU9dytuL0tVx+jfTzWOipeXVNDMa9SWwZ7PMojvX1j88UeeOjK7iQwmcBA7w3VnmwO3go68cJWQtjAw/kbCk19HPgGUPxN+WgEXl+dciWrmYRbal8BaIDC9XkFg1X9cbKZ1QDm2y5HnF8NICgbOF5btT1V1+XRumfph4Ba1VapL8zLAOdhE4IfYgTmlhSkPrnvVsDqcKKyDIkwLxQ4I8ohfY5HHOmrVyHTCKz5UUOwT/fcD3fHOfD0BY8vwp7s0zg6sGQhS45ue12SeSxjiy2+svDhAXmTOSKKfO6YfOlP/rdDp8crlr+ZS/AAK2uEPv6tHmgtUYGepf4JNUNzIZIMATkvPF1L/vMU+KzZJKKsz8zbwM5m9nnce4hmAdS78Xvgrnz//JIj4a7O/ZlSihjZi9HrIi9WvIsT2RhgH0xqBS5+o2QaVb+LOTlSPxxaKaF9uIpyqyZAiKWUvP8KxaGnT7lJWFb6Nw9zz2M7Vl8Ji56ORWWusvITIvDSY2L9jm7OrIhCkZJ5EQvtkUlLXo3PEYFGvtzBqKvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/9/25 10:20 PM, Leon Huang Fu wrote:
> On Fri, Nov 7, 2025 at 1:02 AM JP Kobryn <inwardvessel@gmail.com> wrote:
>>
>> On 11/4/25 11:49 PM, Leon Huang Fu wrote:
>>> On high-core count systems, memory cgroup statistics can become stale
>>> due to per-CPU caching and deferred aggregation. Monitoring tools and
>>> management applications sometimes need guaranteed up-to-date statistics
>>> at specific points in time to make accurate decisions.
>>>
>>> This patch adds write handlers to both memory.stat and memory.numa_stat
>>> files to allow userspace to explicitly force an immediate flush of
>>> memory statistics. When "1" is written to either file, it triggers
>>> __mem_cgroup_flush_stats(memcg, true), which unconditionally flushes
>>> all pending statistics for the cgroup and its descendants.
>>>
>>> The write operation validates the input and only accepts the value "1",
>>> returning -EINVAL for any other input.
>>>
>>> Usage example:
>>>     # Force immediate flush before reading critical statistics
>>>     echo 1 > /sys/fs/cgroup/mygroup/memory.stat
>>>     cat /sys/fs/cgroup/mygroup/memory.stat
>>>
>>> This provides several benefits:
>>>
>>> 1. On-demand accuracy: Tools can flush only when needed, avoiding
>>>      continuous overhead
>>>
>>> 2. Targeted flushing: Allows flushing specific cgroups when precision
>>>      is required for particular workloads
>>
>> I'm curious about your use case. Since you mention required precision,
>> are you planning on manually flushing before every read?
>>
> 
> Yes, for our use case, manual flushing before critical reads is necessary.
> We're going to run on high-core count servers (224-256 cores), where the
> per-CPU batching threshold (MEMCG_CHARGE_BATCH * num_online_cpus) can
> accumulate up to 16,384 events (on 256 cores) before an automatic flush is
> triggered. This means memory statistics can be likely stale, often exceeding
> acceptable tolerance for critical memory management decisions.
> 
> Our monitoring tools don't need to flush on every read - only when making
> critical decisions like OOM adjustments, container placement, or resource
> limit enforcement. The opt-in nature of this mechanism allows us to pay the
> flush cost only when precision is truly required.
> 
>>>
>>> 3. Integration flexibility: Monitoring scripts can decide when to pay
>>>      the flush cost based on their specific accuracy requirements
>>
>> [...]
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index c34029e92bab..d6a5d872fbcb 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -4531,6 +4531,17 @@ int memory_stat_show(struct seq_file *m, void *v)
>>>        return 0;
>>>    }
>>>
>>> +int memory_stat_write(struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
>>> +{
>>> +     if (val != 1)
>>> +             return -EINVAL;
>>> +
>>> +     if (css)
>>> +             css_rstat_flush(css);
>>
>> This is a kfunc. You can do this right now from a bpf program without
>> any kernel changes.
>>
> 
> While css_rstat_flush() is indeed available as a BPF kfunc, the practical
> challenge is determining when to call it. The natural hook point would be
> memory_stat_show() using fentry, but this runs into a BPF verifier
> limitation: the function's 'struct seq_file *' argument doesn't provide a
> trusted path to obtain the 'struct cgroup_subsys_state *css' pointer
> required by css_rstat_flush().

Ok, I see this would only work on the css for base stats.

SEC("iter.s/cgroup")
int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
{
     struct cgroup *cgrp = ctx->cgroup;
     struct cgroup_subsys_state *css;

     if (!cgrp)
         return 1;

     /* example of flushing css for base cpu stats
      * css = container_of(cgrp, struct cgroup_subsys_state, cgroup);
      * if (!css)
      *     return 1;
      * css_rstat_flush(css);
      */

     /* get css for memcg stats */
     css = cgrp->subsys[memory_cgrp_id];
     if (!css)
         return 1;
     css_rstat_flush(css); <- confirm untrusted pointer arg error
     ...

> 
> I attempted to implement this via BPF (code below), but it fails
> verification because deriving the css pointer through
> seq->private->kn->parent->priv results in an untrusted scalar that the
> verifier rejects for the kfunc call:
> 
>      R1 invalid mem access 'scalar'
> 
> The verifier error occurs because:
> 1. seq->private is rdonly_untrusted_mem
> 2. Dereferencing through kernfs_node internals produces untracked pointers
> 3. css_rstat_flush() requires a trusted css pointer per its kfunc definition
> 
> A direct userspace interface (memory.stat_refresh) avoids these verifier
> limitations and provides a cleaner, more maintainable solution that doesn't
> require BPF expertise or complex workarounds.

This is subjective. After hearing more about your use case and how you
mention making critical decisions, you should have a look at the work
being done on BPF OOM [0][1]. I think you would benefit from this
series. Specifically for your case it provides the ability to flush
memcg on demand and also fetch stats.

[0] 
https://lore.kernel.org/all/20251027231727.472628-1-roman.gushchin@linux.dev/
[1] 
https://lore.kernel.org/all/20251027232206.473085-2-roman.gushchin@linux.dev/

