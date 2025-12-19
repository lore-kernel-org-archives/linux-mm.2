Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F4EE66891
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 22:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40756B008A; Fri, 19 Dec 2025 17:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE6B6B008C; Fri, 19 Dec 2025 17:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD03E6B0092; Fri, 19 Dec 2025 17:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB8EF6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:45:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7BDE6B91AF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:45:20 +0000 (UTC)
X-FDA: 84237703200.08.D35855B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA3AB20010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:45:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YPUYRXXP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766184318; a=rsa-sha256;
	cv=none;
	b=FuHH7IGhiCTZ2PyHMjarTFSvf8QaUdMmFDp03eKrm8tl6gqzIhCqTviqfJW4uf3JiRp8gH
	BNY90P02iODdhD3cQLIrqPJSlv/gMh+fOEzG9AdD7zDWBWX9we9Rvz6a9d5KCOJOd4NQBs
	+DAkRXwvRSKDjlCJvACq+K/L+uZ8nR4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YPUYRXXP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766184318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UniB5eMA4EcJXd/xsTyPTDbGbOW+40NeusGvhwuHw8=;
	b=kgsEZGHoqeupWkB7eGDBp/utTMUFH6ZV6O1gF52X/S1Z7iow6EouEShuHL9wALh/LwQLJQ
	tAieXvTY/fdQBFcYBQ3n1c0Gcn9pV9qZ+NLEJmAC3+gmwwOXrS1u3oEk1QxGaU9FQSn0wR
	XFyO3Zm+3JKH7edHZC8tLLFASjEfawo=
Date: Fri, 19 Dec 2025 14:45:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766184311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UniB5eMA4EcJXd/xsTyPTDbGbOW+40NeusGvhwuHw8=;
	b=YPUYRXXPmSuKe9cVyjuN/qHSAhFN4LbSWpEkyvMzEq10uj7Oe0u4K60gUxi/JL68uznkXF
	R7VLj5dHc9PHgBQvOYj8m2aI1CeXVqZbr7D2nd1JRn6iYwH3aAhusaEvYmUOn5LapAXITH
	2d4u9ImvwpvgLQEANXJAmBXTmK1TN5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v1 4/6] mm: introduce BPF kfuncs to access memcg
 statistics and events
Message-ID: <ijmcfjaq5fomm7khxov6riqsf2jlnyugbdkxu72jq7cd7g32kd@t3ytxm5qtywx>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-5-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-5-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AA3AB20010
X-Rspamd-Server: rspam03
X-Stat-Signature: meqef5u7tn876syna44en3nnib6s3e34
X-Rspam-User: 
X-HE-Tag: 1766184318-451192
X-HE-Meta: U2FsdGVkX181PBi27rJ5LpySOFD3a+H9BMTdEKfgZ6V4G/rPZ8Ld3BG8vJK3Hfyfcu598DwV+pP1ztclTDCIDHGMq2cLq8ix5NT5BY8PhS0zZnVONaoy8fEx3B7kpZQd+bWTdefcoIGLuLKJkhpbwmUb4FIfaLpDIEijvyl/Ied+rxdCs9VeRAsEUilXU5LJ7IfIOKeFLzRD3/lOOhM1EG5yBIRgewwXKvoOc+l/GiwSPoVOFcVufeehQVMaAzkINtxBouCb3vluQSpaR80L9o+Y3ZhtCQq24Uknox1U0xQm3rIJpCak5qBA8D6Rh8WW0+3OERxiD/e5/1C9SD4L8p7/zf2MQJg9zM53O+Ya1tnViU7G3P5uQLyBEkbjA1/kUIXLJD+enQM3B7bMSqWOdM1wFE+mpL7AMsz84lBCdtx/EIxqHe9CPgtIYAMS5b6qiaPkABuLsgy/P3LPjieUQFCLHtZKQq4j7MWh3cYL/QLxccF70jv2jq+D02dBX/e6b84aODCdx4udwjno//J5hgfDSrCZL8sMzPb+6PSivEJWjKXUd/N/MU+z7ZZsINd60N+Bv7VM72zTR4k+ta0RsVwZKOYo8OPLccYhSlWICBwveS5AwgltDn3oa1C4KVVEWfLW/5CToRhmNxOxkN7b9DaQDjXoDTC6IcbpZq1p7zM5H6/gPT+xbgLeRv/YkwBhen+n6NZeYb/GysNUDM1xCMI45Zphtr2uNMEFoAAlUPDv86TbDFbae6/S2xzKdYZiLyXj6ZGD3KsnthM+fK9Ti7ObTXR+712DdCcxdElbVcatLCS9NCaxFIGtbQXlg963HHsee6bIWV151N0twdG4DFrvM45+NgBLC6HafZrpOm3FJ3R6NHVQwts2XTN1c0Vli3gfjCmap1BpMNeiGlsNl0ngDBwfltCz06D3fnILCzRaIPIVrutrJ6AajJ3G9ybmZ32rekq1s+e27lTpyfJ
 zeT+ksog
 6OyD5DxC8FuvpjAwyxRQuTtGntYrfQLeJqIJbw7cUuJBjd2okZ5+ADQnBHpWHeSI3CL2D000hqYXxFu0MciBZ+9C99DlT5gO05j+mxVgYUiqviTtYH1SizKyWRatqpVIShZICY8PSVRA2ziiknq+AmpQd0J7k82E6o2kdL+0J/qL7BfNTBjtp8gBBBL5APgYF7Ls2a593RU61cdSQZH2/l9saiRXIFh3m603Yh/x4z8yjCP4hmLyMIaCaW7bXdYYH3B1gDBfvRxys0N+rK3JoQKe36YQ/jB9hVQu3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:48PM -0800, Roman Gushchin wrote:
> Introduce BPF kfuncs to conveniently access memcg data:
>   - bpf_mem_cgroup_vm_events(),
>   - bpf_mem_cgroup_usage(),
>   - bpf_mem_cgroup_page_state(),
>   - bpf_mem_cgroup_flush_stats().
> 
> These functions are useful for implementing BPF OOM policies, but
> also can be used to accelerate access to the memcg data. Reading
> it through cgroupfs is much more expensive, roughly 5x, mostly
> because of the need to convert the data into the text and back.
> 
> JP Kobryn:
> An experiment was setup to compare the performance of a program that
> uses the traditional method of reading memory.stat vs a program using
> the new kfuncs. The control program opens up the root memory.stat file
> and for 1M iterations reads, converts the string values to numeric data,
> then seeks back to the beginning. The experimental program sets up the
> requisite libbpf objects and for 1M iterations invokes a bpf program
> which uses the kfuncs to fetch all available stats for node_stat_item,
> memcg_stat_item, and vm_event_item types.
> 
> The results showed a significant perf benefit on the experimental side,
> outperforming the control side by a margin of 93%. In kernel mode,
> elapsed time was reduced by 80%, while in user mode, over 99% of time
> was saved.
> 
> control: elapsed time
> real    0m38.318s
> user    0m25.131s
> sys     0m13.070s
> 
> experiment: elapsed time
> real    0m2.789s
> user    0m0.187s
> sys     0m2.512s
> 
> control: perf data
> 33.43% a.out libc.so.6         [.] __vfscanf_internal
>  6.88% a.out [kernel.kallsyms] [k] vsnprintf
>  6.33% a.out libc.so.6         [.] _IO_fgets
>  5.51% a.out [kernel.kallsyms] [k] format_decode
>  4.31% a.out libc.so.6         [.] __GI_____strtoull_l_internal
>  3.78% a.out [kernel.kallsyms] [k] string
>  3.53% a.out [kernel.kallsyms] [k] number
>  2.71% a.out libc.so.6         [.] _IO_sputbackc
>  2.41% a.out [kernel.kallsyms] [k] strlen
>  1.98% a.out a.out             [.] main
>  1.70% a.out libc.so.6         [.] _IO_getline_info
>  1.51% a.out libc.so.6         [.] __isoc99_sscanf
>  1.47% a.out [kernel.kallsyms] [k] memory_stat_format
>  1.47% a.out [kernel.kallsyms] [k] memcpy_orig
>  1.41% a.out [kernel.kallsyms] [k] seq_buf_printf
> 
> experiment: perf data
> 10.55% memcgstat bpf_prog_..._query [k] bpf_prog_16aab2f19fa982a7_query
>  6.90% memcgstat [kernel.kallsyms]  [k] memcg_page_state_output
>  3.55% memcgstat [kernel.kallsyms]  [k] _raw_spin_lock
>  3.12% memcgstat [kernel.kallsyms]  [k] memcg_events
>  2.87% memcgstat [kernel.kallsyms]  [k] __memcg_slab_post_alloc_hook
>  2.73% memcgstat [kernel.kallsyms]  [k] kmem_cache_free
>  2.70% memcgstat [kernel.kallsyms]  [k] entry_SYSRETQ_unsafe_stack
>  2.25% memcgstat [kernel.kallsyms]  [k] __memcg_slab_free_hook
>  2.06% memcgstat [kernel.kallsyms]  [k] get_page_from_freelist
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Co-developed-by: JP Kobryn <inwardvessel@gmail.com>
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> ---

[...]

> +
> +/**
> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
> + * @memcg: memory cgroup
> + *
> + * Returns current memory cgroup size in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
> +{
> +	return page_counter_read(&memcg->memory) * PAGE_SIZE;

Similar to mem_cgroup_usage() should we special handle root memcg?

Otherwise looks good to me.


