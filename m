Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0508FCCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561A98E00BB; Fri, 31 Oct 2025 05:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539B58E0042; Fri, 31 Oct 2025 05:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428398E00BB; Fri, 31 Oct 2025 05:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3808E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:08:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6409B946E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:08:30 +0000 (UTC)
X-FDA: 84057833580.29.9A1F8BC
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA134C0004
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:08:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CqQ1fICL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761901709; a=rsa-sha256;
	cv=none;
	b=5zn1U/5EjixgwCwHXOLRbh/zzU3mjTMS68a2bObPX8PkfOocNXgntKk6CYNhGqTlf1Ax/M
	9M6GKAsrMPFgsEe/kAwh3gSvNem6vVrnxi9KOEtWJUKRafXr84PFC9TSQ8ds3X/pAYXMt2
	zv8+lnXTRQ9UCvkjHCdrR2JoqbRpLZI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CqQ1fICL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761901709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4ZSMG2AuU/ZGT4Jo1L6qr4nQw/AKzOrQurRx1abInc=;
	b=oCkCR9xxopX3DOEm8jTmo/FC+b80zBqAnCYME7AVabtuzw8CgITQ4KvG5u6d19UKUmsADu
	l1zCETxz/KjZNk7GLxDI0HNFUXiOBC80dlCw7ra2CqF8cHaobBLd+E11dFR4jcU3Y+tGa0
	wFEVktkeBsJNqk9cGAopsisAwJejVWQ=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-429bf011e6cso631799f8f.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761901707; x=1762506507; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s4ZSMG2AuU/ZGT4Jo1L6qr4nQw/AKzOrQurRx1abInc=;
        b=CqQ1fICLcUEvX27SaGVdqjNt02Mh6/qcmKRQolfnBXNngsOkFuo7MvTOap2Rtkhazv
         5LycbT4whg4Rrwl5ok3ooa7DS1+Fe+9OFkKYPGcSsBuJnPWD8iGlqPqFIlvh7GCqoHEV
         WCSPQIp59tnaTIUv8gSjeABr5YVJ0Ura1/INA0SApqAiKJWjM20yLRY4WjrviDA7nkzS
         miOGqD5C/cpFQ+Rn78gViwAGXJNaYzXYWeGCFEeEGPF7wJ5JZFnEIlVhMZ0PSwvBzXS8
         tjL3JqgfOsy12unIVY6Guhm9zGCGqm41cVHUcES+HVt4BE74F0PctFLI3LGjhGv+94dw
         X15A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761901707; x=1762506507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4ZSMG2AuU/ZGT4Jo1L6qr4nQw/AKzOrQurRx1abInc=;
        b=j/7Z9k0IMvFV3ePdadz8b7RsrWERdNij8VJKGC5+Pv0Rr/8VoMkUuFeR+ZeB/Brc05
         dd48Tj2LSVzEs6iW5PRBa7qcHosWtg5FTByVMlIjoJMuS4JJE8uXgFH+spbXp2SidMam
         KcuCEk5u7G+Aj7Xkex+XG7BQIzUhkt67BEvRN6ksXPB3UjSTuByMer8G4nN3RgH9Rm2k
         MhHAv64Atwj0Q6Cq9GvzHAaLnBidNR6H/jlO4ah0HuyiehLhm0nEQxuxVc8+fOXRdGdK
         cavjq0mpP9unakyATvlwVI1KdHcSyoenHSe+4hwC7Zr0UqCwDmcMIfpWFxfAs8kt51sj
         7ilw==
X-Forwarded-Encrypted: i=1; AJvYcCX8H3WHOALpFlByzulwyiB26xabyo7YgGC6C6U39ebsD4QifHLxPMlj1uX0Pc8/mKJKvQqnYQ+z+Q==@kvack.org
X-Gm-Message-State: AOJu0YxU7I/2XhSmT9PpU3VAxxi0x6nWbSdi7QNtFAFZfjJPbTCaM1Fl
	5a6aI8AxUarxmCs9T+zZAgxb2jkY7lzQwv78jKLs5TOLgOwOu3FvK8IIIYXqWT5EqnM=
X-Gm-Gg: ASbGnctbrUKq+H97hezMMtm8QrgAY3bteN0XVKRwR6EwgiEL0YsFPampmyzY5tZSisj
	abFXnnSt2puhbfAyHQhu104oN3P+onmrORIyCzCp6ENy1ig0vqvy+/dyAzo255H1mPq5L8pwoga
	MOQj7CbbcQW/cH5uwTalK2mfIvSVM8e4M1XNVClBYIRoY/RzlOhs8IQjzY2T65/asD6UvrqYrYT
	N3mvvn3hJzVerf2wu0U/R0FOys5EECLbA1KJJP9bRODyH/+LIU2CL70AbxvUuwbLzLqKPiagxsW
	lB8qeT78GVDW/F/+A5G/CpqUggCyE0SJwOdHmSbfdeH/IhyXBm+GljIu9xHNwkVa07Gr/YX75Ha
	ZvLwXgl+FNgn3IQfvGUj4VB8+4xrQfuEEVsQeT3HnARvLD3xjuNtK/se4A+c5faM0BB4W6Pg6wT
	tCIwWEp63y9fMo76FPTwUVCA3Q
X-Google-Smtp-Source: AGHT+IEIajU1J4qwwHCSAhYY1Y0QbJUQjFbzl13BM1lB02XFV9NpxNKRXT5AUnkNlCIE5mpOdA1/sQ==
X-Received: by 2002:a05:6000:41d8:b0:429:be56:e508 with SMTP id ffacd0b85a97d-429be56e6e4mr1870640f8f.58.1761901707235;
        Fri, 31 Oct 2025 02:08:27 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13f4732sm2429798f8f.43.2025.10.31.02.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:08:26 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:08:25 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 10/23] mm: introduce BPF kfuncs to access memcg
 statistics and events
Message-ID: <aQR8if0cpQQ5Am36@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-11-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-11-roman.gushchin@linux.dev>
X-Stat-Signature: b5crtkpcnoeob7ygx5ja9pcw3msct5iy
X-Rspamd-Queue-Id: DA134C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761901708-119771
X-HE-Meta: U2FsdGVkX18AxKPAFKLtc5xMK3Of36SHiX5sfaElvnJrnhx5YEHt7sf+cuH0LaKcigrR5eQblqUG14wwe/QyRxofL3zxJXEflacKJqfmJ3Y+ofIIWGiShYo7hwcMSy+/t8t317USpAh8p9ahN4e8EdUBU2mdFIdhQsT0eHYCbg8N5nBy9VQLV0uSs/g4pT/E98OBAgsKTVPbaW2yYkNl7KvVlqj60xdx+fsdX1ylp3OiXtKts8gOVWXgHiTufAUU1LM3T7lPBi+UDYxuBz99JF1Vqldmk8y6h4b365u58ve7kUwP8R5WFKTVzg3dRxRMygOTWQSkJwajGh9a6k2CO8D37jGnAtxC5n2IISf8w1FFVLqmm9mcC6T3nkBGi+P2EUEJ02vQifLR7aD2H8QtJP+ClpVU7+s5f4uWA/UwSYkMoR3rnHCLC9/++TY5ThJob8WDL7eP8SAPdsNmKDpSVsMBXcenrzEwig1L13eh9vl7MTI/hak7TjNUv1vkrbO6r1e09ZeD9zP8u8FMuto4EBDvMhvUtNwiGPR1g1fC2OuSIFtePi0w0niw9pEZ1Gt1Cz4uS1GaBBn4AZq6D1u4lzjE+sqYA72tlNlwiHTflotTQHqMc2jLnXj50bKcUYl6brXECG0pi09G2lqadY83uymH0CuR8I/vmIyLk6snRw7jCahJ+w5Y64pvEfZo4cT71T0pDJmvKiq6yNLd4D3QrOGZ/cq5gRZP/FGblE9QkVK4I74e9fvCdcyD2Mzgj/LzubbXbpHZvDYGChlTkmPlTmfl+BKbD+umx6MSV7Oq9bKyKfFekYbi80kGBqxLIFPFi4Rk3F6lK2TEFRVD3BHAUEtkAdJlCUThU8CGiMyxKhedE3G5E9wUhLLrWglimPAxyJkIYIuSpwLJkZpBaDDorrFHeZhH+Vpu2fbrFmM5xLUW2x5k2syKT4PTXwI+YaON43DNPVcl/mzlDgTCAhE
 fCuInG/q
 9oziJSEf+6hwpXd2kpaLcIJ+GnK0xGJ+JGsAQ32MYTVsUddCy0/HE4uvPbq9TfV66JZZFGXPyCnVy9nHz1ga5FE4JkhTHZAIynPq23j67aovBGspFIRMfLGJJl57A3mH7SPhqHou/vsEn71112CQdtd06XqQQ61Foe/MIBefVxpGr6zx+sdcysf0aGkNCYc3XVk67/bFdwj+Jowc7Vzd7DCXigyd3HUFSwBccMsdfNVtSWTtdRApAzJVcnPbU3ovNNnwu+C1vIJMbOoS0bDvB82uzw9NOt/zlbl9+tQhEOCmukmfWgMCkZwqilGs/iGdpebYr7RIUDaybLf4F80+KbwpAM7OzY7ePsr4PwmoMwnVwkZzvpWPoVrFU/U/qgRlSTEVAo03+A7cm17COmeWN7C0z+gcZU8wcVAi+eVHem/pAsCu2WKdFM63kZzvNNXDdfRjq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:13, Roman Gushchin wrote:
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

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h |  2 ++
>  mm/bpf_memcontrol.c        | 57 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 39a6c7c8735b..b9e08dddd7ad 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -953,6 +953,8 @@ static inline void mod_memcg_page_state(struct page *page,
>  	rcu_read_unlock();
>  }
>  
> +unsigned long memcg_events(struct mem_cgroup *memcg, int event);
> +unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
>  unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
>  unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 76c342318256..387255b8ab88 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -75,6 +75,56 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>  	css_put(&memcg->css);
>  }
>  
> +/**
> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
> + * @memcg: memory cgroup
> + * @event: event id
> + *
> + * Allows to read memory cgroup event counters.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
> +						enum vm_event_item event)
> +{
> +	return memcg_events(memcg, event);
> +}
> +
> +/**
> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
> + * @memcg: memory cgroup
> + *
> + * Returns current memory cgroup size in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
> +{
> +	return page_counter_read(&memcg->memory);
> +}
> +
> +/**
> + * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
> + * @memcg: memory cgroup
> + * @idx: counter idx
> + *
> + * Allows to read memory cgroup statistics. The output is in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> +{
> +	if (idx < 0 || idx >= MEMCG_NR_STAT)
> +		return (unsigned long)-1;
> +
> +	return memcg_page_state_output(memcg, idx);
> +}
> +
> +/**
> + * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
> + * @memcg: memory cgroup
> + *
> + * Propagate memory cgroup's statistics up the cgroup tree.
> + */
> +__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> +{
> +	mem_cgroup_flush_stats(memcg);
> +}
> +
>  __bpf_kfunc_end_defs();
>  
>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> @@ -82,6 +132,11 @@ BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>  BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
>  BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
>  
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
> +
>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>  
>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> @@ -93,7 +148,7 @@ static int __init bpf_memcontrol_init(void)
>  {
>  	int err;
>  
> -	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
>  					&bpf_memcontrol_kfunc_set);
>  	if (err)
>  		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
> -- 
> 2.51.0

-- 
Michal Hocko
SUSE Labs

