Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC45CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCED8E0088; Wed, 15 Oct 2025 16:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3FF8E0057; Wed, 15 Oct 2025 16:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B106D8E0088; Wed, 15 Oct 2025 16:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A09708E0057
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:46:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39DA41DFAE1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:46:16 +0000 (UTC)
X-FDA: 84001531152.18.8A5F230
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB5B94001C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:46:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lc/RRzVh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760561174; a=rsa-sha256;
	cv=none;
	b=4kkpK9JyQ/EpZKRgNDBXfekHn+Au6d+fxlqWrActGarsyPyFzUdkSu5YYRf5BFauXndG6y
	IzreyjEQN36a9WUbFEF8CnDVc8JNbfyUW9YyCBSFuy0c1+AqdG4Zj4ilXPqVBmVcF+k53q
	LP8kWur69Y17t7VUiYQAccUDpg3Bkzs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Lc/RRzVh";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760561174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLsontaXNMVQKPHfGbAAEY3guiak8DJs9osRf8Re/hc=;
	b=C8GVjwFGguqnIGT9YsxrMUL5pKiBJWCosKME7Zi3c9CsHr6I6w2o2jXyybT2Ftoh41N8Cb
	aHUFnc3cjFKO9Tz0x+FUPr+BinZs0oywi+nT+ZRicdE/61eKE5keH6qtbvtvio6CPLGrDI
	57XONaPpN1INoN7pigikweZWOz8neUQ=
Date: Wed, 15 Oct 2025 13:46:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760561170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLsontaXNMVQKPHfGbAAEY3guiak8DJs9osRf8Re/hc=;
	b=Lc/RRzVhCca2HURiHaH2zb+dCgSPEKV4/LU3ySTM6zRMTXik4BlvlJOQgpkx5pojkqUQG/
	Vj6JrSoHjsKYJJE5sJMq4B1LSX6kS0GBA/nd8e+3vAkHKUu7E7udLhUnGX8XjyG9N1xVTT
	MHgR6FS8Y2uD2FLBqZQYxc3OTdpbIiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: andrii@kernel.org, ast@kernel.org, mkoutny@suse.com, 
	yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	kernel-team@meta.com, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev
Subject: Re: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
Message-ID: <uxpsukgoj5y4ex2sj57ujxxcnu7siez2hslf7ftoy6liifv6v5@jzehpby6h2ps>
References: <20251015190813.80163-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015190813.80163-1-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kxrnnqzzrjc48aniojju7x5cibdd3njc
X-Rspamd-Queue-Id: AB5B94001C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760561172-164029
X-HE-Meta: U2FsdGVkX18tho1m2XX3n4y0eT0DiA1kpgsm7CweH9Wd1/n2Sm64TwhkFxdWUTzKFKFZvb//Ps1J4RiTwDJbp9lHyRftQHW8YI1l0zTQxaJ4C3YkLynsykCSNhRVQwPkikLM5tPlemDZhuxYtP8kzV8cLpmwgjwFn+9m4XuADzlEzEqeF8WRPpy/eOdkiydwD6ZJoNVeGUzdj2Sb8zj0AHlYR7zwqfYISO2I92e5kvUzrJzj3ciGkcHSD4a4XmLLCGsxGo7PTTbkk+GD9K7tW87/QiMvMEnuBZYDuPHoVdYEi6VznvqOZJ7u77lrr1M13+UZv2PyZdiUGNn2qXyhJZMNEMR/Hq+bXB6G52+wqp6VFa1+q0t4dCfpZoD3tcy+b19KIiPcPvtCEMGwHX6okrkhj/FWTuBaMklj1VLV3FzmIwY6GdXvU/txgRYH2FKpZX+EzMR68qWvtbMEVvYPaYy5t7log7CJ/x5C4hdDbBlcdVlPYEypzYu83Tzr3fH3L9vkpNiOkSDfOoTJNcB3/eqeLrRfAWOgggS3WkRzwwWMTFmdA0Qu/UJQ8YSqJ8AhUNUqVGQ3ALCdjrrk9wbQMGw2o9EkAUYBh+MBNTW995rZ/Z1bzLYuj9AUIrXjdkWi+Tb2JSAiuRReGl4iOeA5kUyH+uUoIqiInfmFBbLB50UqGhgWCoEaJul+HXxxxLSNpQf31RaSFrBaILK3QmY/AUT1QbvTipIQRpn647E/6hN6LaAAh36uO5AV9RD081HewUk8kIUt2Epx5/bVWhkT5vt+V6VsZ6y1A7NMDXx1D9VBXSjgJh6Mrb1oVRU0/KBjXxZMOYtoQYft/nYA1CDULL8TflOh7138L4cqQkCUDRX6/DI9vmyKlR3DBn6EhjEvleIHy2Pbk/Le0YxOJcRi/qYTVmlw05f9nagF8GrhDny39wj3D0j+EZV9+gmvrO+GET936aizm6WcZs1GaC2
 CWCtA0c3
 KNvh6d44eNzKA9ZXudKv3af5BfRTQ6tCOPwUHMKvfCKID3H4WvMfDmnoLZqylO3o6ousoiYiEknf+A9Ohvt6UGtkIRw/JO74gv8R4ZVys1XVbkaRuD5yoWEe1HNr04OEkktaH5aLe89okLRrL9TBtP0guxiASF9YEvwbyOnZcXnYPbSG00LzOfPIEQL3Ji5+SwjQ1ZmDyyj8NaxvEoCm4RPk3z10EVnaQJ0UZJ2NTbDAbzUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc memcg maintainers.

On Wed, Oct 15, 2025 at 12:08:11PM -0700, JP Kobryn wrote:
> When reading cgroup memory.stat files there is significant kernel overhead
> in the formatting and encoding of numeric data into a string buffer. Beyond
> that, the given user mode program must decode this data and possibly
> perform filtering to obtain the desired stats. This process can be
> expensive for programs that periodically sample this data over a large
> enough fleet.
> 
> As an alternative to reading memory.stat, introduce new kfuncs that allow
> fetching specific memcg stats from within cgroup iterator based bpf
> programs. This approach allows for numeric values to be transferred
> directly from the kernel to user mode via the mapped memory of the bpf
> program's elf data section. Reading stats this way effectively eliminates
> the numeric conversion work needed to be performed in both kernel and user
> mode. It also eliminates the need for filtering in a user mode program.
> i.e. where reading memory.stat returns all stats, this new approach allows
> returning only select stats.
> 
> An experiment was setup to compare the performance of a program using these
> new kfuncs vs a program that uses the traditional method of reading
> memory.stat. On the experimental side, a libbpf based program was written
> which sets up a link to the bpf program once in advance and then reuses
> this link to create and read from a bpf iterator program for 1M iterations.

I am getting a bit confused on the terminology. You mentioned libbpf
program, bpf program, link. Can you describe each of them? Think of
explaining this to someone with no bpf background.

(BTW Yonghong already explained to me these details but I wanted the
commit message to be self explanatory).

> Meanwhile on the control side, a program was written to open the root
> memory.stat file

How much activity was on the system? I imagine none because I don't see
flushing in the perf profile. This experiment focuses on the
non-flushing part of the memcg stats which is fine.

> and repeatedly read 1M times from the associated file
> descriptor (while seeking back to zero before each subsequent read). Note
> that the program does not bother to decode or filter any data in user mode.
> The reason for this is because the experimental program completely removes
> the need for this work.

Hmm in your experiment is the control program doing the decode and/or
filter or no? The last sentence in above para is confusing. Yes, the
experiment program does not need to do the parsing or decoding in
userspace but the control program needs to do that. If your control
program is not doing it then you are under-selling your work.

> 
> The results showed a significant perf benefit on the experimental side,
> outperforming the control side by a margin of 80% elapsed time in kernel
> mode. The kernel overhead of numeric conversion on the control side is
> eliminated on the experimental side since the values are read directly
> through mapped memory of the bpf program. The experiment data is shown
> here:
> 
> control: elapsed time
> real    0m13.062s
> user    0m0.147s
> sys     0m12.876s
> 
> experiment: elapsed time
> real    0m2.717s
> user    0m0.175s
> sys     0m2.451s

These numbers are really awesome.

> 
> control: perf data
> 22.23% a.out [kernel.kallsyms] [k] vsnprintf
> 18.83% a.out [kernel.kallsyms] [k] format_decode
> 12.05% a.out [kernel.kallsyms] [k] string
> 11.56% a.out [kernel.kallsyms] [k] number
>  7.71% a.out [kernel.kallsyms] [k] strlen
>  4.80% a.out [kernel.kallsyms] [k] memcpy_orig
>  4.67% a.out [kernel.kallsyms] [k] memory_stat_format
>  4.63% a.out [kernel.kallsyms] [k] seq_buf_printf
>  2.22% a.out [kernel.kallsyms] [k] widen_string
>  1.65% a.out [kernel.kallsyms] [k] put_dec_trunc8
>  0.95% a.out [kernel.kallsyms] [k] put_dec_full8
>  0.69% a.out [kernel.kallsyms] [k] put_dec
>  0.69% a.out [kernel.kallsyms] [k] memcpy
> 
> experiment: perf data
> 10.04% memcgstat bpf_prog_.._query [k] bpf_prog_527781c811d5b45c_query
>  7.85% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
>  4.03% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
>  3.47% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
>  2.58% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
>  2.58% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
>  2.32% memcgstat [kernel.kallsyms] [k] kmem_cache_free
>  2.19% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
>  2.13% memcgstat [kernel.kallsyms] [k] mutex_lock
>  2.12% memcgstat [kernel.kallsyms] [k] get_page_from_freelist
> 
> Aside from the perf gain, the kfunc/bpf approach provides flexibility in
> how memcg data can be delivered to a user mode program. As seen in the
> second patch which contains the selftests, it is possible to use a struct
> with select memory stat fields. But it is completely up to the programmer
> on how to lay out the data.

I remember you plan to convert couple of open source program to use this
new feature. I think below [1] and oomd [2]. Adding that information
would further make your case strong. cAdvisor[3] is another open source
tool which can take benefit from this work.

[1] https://github.com/facebookincubator/below
[2] https://github.com/facebookincubator/oomd
[3] https://github.com/google/cadvisor


