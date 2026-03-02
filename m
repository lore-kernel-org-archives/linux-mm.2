Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B04BE9B36A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750FD6B0092; Mon,  2 Mar 2026 07:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704B06B0093; Mon,  2 Mar 2026 07:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603F66B0095; Mon,  2 Mar 2026 07:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 498B76B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:16:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 043E3C3721
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:16:33 +0000 (UTC)
X-FDA: 84501021108.25.D0ABF31
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id BBA164000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:16:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="F/miWOZI";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772453792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ACTRy9m9DGTE1uM5/GGdszxPz1+1eryLvgjpWOtGUc=;
	b=RPvVtZjUqBWmb7ky9eiliM2dGtzXaKr5hK/J2ppKlx/dviWpyHZWvOQLMJpbZUIJ3sZeab
	0Rqf36TiTVjYsEzOl5+ixo196LYUeJZTFA2dpQ4lmWIcCcDvZrpsbqq4Yf2VutI9jN4UlD
	7fyFG6cNuG7zTMPJpbgnZaxi9n/Pys8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772453792; a=rsa-sha256;
	cv=none;
	b=Lf9YCQAvbIcGi63QYvCp7NH2JhNQS5qcBGt2BsG8Hxgwk7kakdaVmBm2XqLDzY8ut8B9zZ
	7w61ny5D+moaRdCvKv75UdkoFN6ytDa09Frtk1L7LDzw8zLRoHc/Z969jBGwhDdAlCV5Pg
	qzA9Wha5YNK2SyC+dpmXPYNYmYovfBk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="F/miWOZI";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43992e06b9eso215495f8f.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 04:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772453790; x=1773058590; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3ACTRy9m9DGTE1uM5/GGdszxPz1+1eryLvgjpWOtGUc=;
        b=F/miWOZIDaiyZ/c/7Bf4fBt/SBeqtHddrAgIVR5qiw5icQLh47a/XIPwcaGS0GiY8b
         iK6FKgDFcEq3ugJqUcITtX7sBbNp4jmbIvAjDuXY9uzt3qg7JJCwgDL0803Nft8jR9LI
         rPlDvlQUJuWRLNLQfe0pf3EPKb5lKxV160p5s2yoW8qg/jefU9YALX8bEQ8fyJYAWa8g
         nHp0gVg6lA5yWjN2BB8nj4tJuG5UWQsAXIvRg2u92RYmh3tqQZ12B2KjIm2doJrXdNxR
         bYraCSG+pT+V3WJgWK8mRlmDC0Dy9O1zu5aBUvBFmldVs70z+Aule690t3BvbJabNP2C
         h+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772453790; x=1773058590;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ACTRy9m9DGTE1uM5/GGdszxPz1+1eryLvgjpWOtGUc=;
        b=qOsGI43bv2aSfRq3Tel/9pnzAhe3RZxwWuF5qvDQiQ/N6kmICN5xxrxdhwMBzRc/+4
         Yf9HsBNVZ53ctLdiwQDtl6CMWG2sLYCFcsrtkB+jX2Wp2LirYiXOlkOv3glZUdGE7qEt
         YWP4JcOFZh4/pbv4nYdA3TFuGi0yjw8yNpnYCuZmdj5m5Ml9hkJOXIibi9FBY4noCQ3+
         C/gMGuCQ3o0g5c642Xa/qv+vgBQR2bQ0m4Vy3nzinD2tjGrWKEr0Gp8WWM1QUq4dze1f
         GFQU7UK0Mr0AIs8fJ/SjztvOT6JMWiAZCmxXeHHreOEknwXxdEbcdKxPl++jfk4HpKmQ
         bK+A==
X-Forwarded-Encrypted: i=1; AJvYcCVCBAaLZAcffbzeuYnF46KE6DLLGQdrZuPx9GLMEhlGNAQPYrTUxo922CWzQAlOhYqkCitPosvsIg==@kvack.org
X-Gm-Message-State: AOJu0YySujDtbApsN6a8n7Gc9zIPoCFRPBJ/9a8Tn2mtUxI3wCmjpLVX
	3xvC5bk8yaTB4MfHpiCqUyESnO8DPjvzigmEdQ781J2vv0uHhlO2qBToMFtE+6sdbKY=
X-Gm-Gg: ATEYQzwAMow5gMous8j8TOaWmuSJOr7oyGrhhV99kVU2jKgMOzzqjAE+gSURUCYBDSF
	dQ4vQ+byTNxumeeTt2Uxz7Pe7w8230Yv07dwS56q61fpUVPO2rk5+wue9bXvDzvXBXtc09HNX+7
	4EUwwKPg3rWqIZYhLGG4qVKQ11U9lE0OkkxUMJ9Ow3+GK36xZ+9q77sA9EoDaMC2teYiCkzHBHF
	AQWEk/pgwVBd114U5DugL5dRBgHn5qBQOPy7znS+lOvc1Z88Kv5WlvhZQepzuRyBURRGmL916cM
	cbFoxS/jU6xBLiQTp4cq96ctJksNcVM0ACmYr+d5RKD8PCtaX6sTsU/5++2Y+w045oYVGQ1WIBR
	kiWpNG2J4dLkToPKXXGg3x6xYRQo8hnQZobGjZqG9iMXieJi42zUpzdD7d5osH/I69SotxUgMXt
	33u6+lMGCJgzwJTTB25/UFNmGOZ0tg3Y6XoFQUwbtzZ2v1TyzB5dSr9FiUEg==
X-Received: by 2002:a05:6000:4012:b0:439:bdd7:4258 with SMTP id ffacd0b85a97d-439bdd743a8mr626841f8f.7.1772453789875;
        Mon, 02 Mar 2026 04:16:29 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b130abfasm11790112f8f.34.2026.03.02.04.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 04:16:29 -0800 (PST)
Message-ID: <9b0ae03c-8e93-422d-835c-3d4148a7550f@suse.com>
Date: Mon, 2 Mar 2026 13:16:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/22] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
To: "D, Suneeth" <Suneeth.D@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
 <df5a0dfd-01b7-48a9-8936-4d5e271e68e6@amd.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <df5a0dfd-01b7-48a9-8936-4d5e271e68e6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBA164000F
X-Stat-Signature: hqfjrj9pxsw593966bhb77gdtg7aowkb
X-Rspam-User: 
X-HE-Tag: 1772453791-326497
X-HE-Meta: U2FsdGVkX18u+HTYR4mwTLVXFI/DpShTsaYbuy/vCczj0zeY/niIYKU09w5h+35Mw8/zRxo3q0pYZFPLerA/7/2nu1wkE4jKTCo+GZGK+H9saZg4lzFnqSfXu1ZS8Tjoagqg6RxAphgHP/43QQDI7LuZcwYxcpoyE3oCAEwz6/mOyvuBoQ4xOuhK6njMtD+KVWRaJq/b+4HxsLn7V0OQUdGsc7wBul/FrpwckQcwUWJxj7QKecLlrJwDjivM625fIjDZ82+ho1zt83lwICCz0dTOd/3iUzKlv8Uq0pCaRLZUzZeXdm99psIn1xGDgSIup1RhiWwbUyxg3Y8SjoqDy/oW6B3B97G3rdcCW2cnxPbjioAHNazwaQRDIbH6OR1Lls8AZSdJiPcvjBggw+jWIv4YZ0P3yWGDLckqHaOYuDF+ymz1r7Y2HwMqw649yV8Tsav0/bCcB42paLgM5oq8M3Ag4RfKetlJGplpUJdFb2bih7VsbDt/aty+4fcc9Dle3GBWKtfQtO5uxsN+fD202U7VBwfa3KOOlTLwFv54Fp3drWmZqO//a7gp12tqJbs8evIBnh/agoPfayujK+u3SibV6891ZhtYcjPx46Oe3t1ZAgvA4MJE5/9xa14n2cDbb723i3GOcb5scnlbhgxO04Pz4hy4Pi11JoH+C4v9Q5h9MIDxvDGXM9Iy3ZSvUYEtFPxwti7ABw8aOhaxNPYyWZ5S/pTGAM8/ZhaHvKa1ifALrgaxMNSyQJaj1ffjHYpw7+dYEoeOs425aa/em3+R9VgSokJ3x/LDIZitSmzOS5tTFCUT6AqzT9u/eH+vYnEYsaeTjTNe6hKO7EMUP9BKmy2himvbSKQhlgGveVsx6uww+CReqrFIJSVg6t4me7A6RSotLYfTRHQIRaeqS0SMpk9hEz9Hwj+sEPefC5q9GFtlU/NZlgJ0a5VpIncqYfiKFVVCXvlz6gxbtwsB7pO
 A4qv+nPx
 75AD1Waz4YCEJLmLOGLJE+vRPxZDVAzjM5RAn92Vj8t/EfJX+eF1RVHWlGxVxiHnTmGvJRTOtNYt5r25hYx1WHCksGL4qNqyAh4pHJ6GfCKo4bgG2kOSWuEg9NPQuqbl1wzJ9Rk4LO7cBHKUL4NZcnZMEQSaGAICErJQb/R/Cqi52NC1wRaVHB4G6HnD/VYQR84NZGmfk+Fk7UWjix5oyPF3WOveUOG31CvSLntmgUBy4LsqDeOEiqS7kR5fdBp6ataoQwCBfYGTfmhN+s3SiYrniEkfy7Ri95aI71GlBbJ27WIir2PPUtg2d8iKznhCqRIvuGlsDTGGs5iJ1WrIm6o1hiiaLyvwBdGgSVjhLWHiMn1xqhYodG9DD0WGo8BHfzg4q3Sxc2dz4rKSBGvT3NBVvLWZSHqfk/olPkLidXngntNKgEENV3Nc99cCIr1VsRX2A8e3sY7YBeeKTR1e+BG0aSWt1p0nVrDW+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:56, D, Suneeth wrote:
> Hi Vlastimil Babka,

Hi Suneeth!

> On 1/23/2026 12:22 PM, Vlastimil Babka wrote:
>> Before we enable percpu sheaves for kmalloc caches, we need to make sure
>> kmalloc_nolock() and kfree_nolock() will continue working properly and
>> not spin when not allowed to.
>> 
>> Percpu sheaves themselves use local_trylock() so they are already
>> compatible. We just need to be careful with the barn->lock spin_lock.
>> Pass a new allow_spin parameter where necessary to use
>> spin_trylock_irqsave().
>> 
>> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
>> for now it will always fail until we enable sheaves for kmalloc caches
>> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>> 
> 
> We run will-it-scale micro-benchmark as part of our weekly CI for Kernel 
> Performance Regression testing between a stable vs rc kernel. We 

Great!

> observed will-it-scale-thread-page_fault3 variant was regressing with 
> 9-11% on AMD platforms (Turin and Bergamo)between the kernels v6.19 and 
> v7.0-rc1. Bisecting further landed me onto this commit
> f1427a1d64156bb88d84f364855c364af6f67a3b (slab: make percpu sheaves 
> compatible with kmalloc_nolock()/kfree_nolock()) as the first bad 
> commit. The following were the machines' configuration and test 
> parameters used:-
> 
> Model name:           AMD EPYC 128-Core Processor [Bergamo]
> Thread(s) per core:   2
> Core(s) per socket:   64
> Socket(s):            1
> Total online memory:  256G
> 
> Model name:           AMD EPYC 64-Core Processor [Turin]
> Thread(s) per core:   2
> Core(s) per socket:   64
> Socket(s):            2
> Total online memory:  258G
> 
> Test params:
> ------------
>       nr_task: [1 8 64 128 192 256]
>       mode: thread
>       test: page_fault3
>       kpi: per_thread_ops
>       cpufreq_governor: performance
> 
> The following are the stats after bisection:-
> (the KPI used here is per_thread_ops)
> 
> kernel_versions      					 per_thread_ops
> ---------------      					 ---------------
> v6.19.0 (baseline)                                     - 2410188
> v7.0-rc1 	                                       - 2151474
> v6.19-rc5-f1427a1d6415                                 - 2263974
> v6.19-rc5-f3421f8d154c (one commit before culprit)     - 2323263

I suspect the bisection gave a wrong result here due to noise. The commit
f1427a1d6415 should not affect anything in this benchmark. The values for
the commit and its parent are rather close to each other, and in the middle
of the range between v6.19.0 and v7.0-rc1 numbers.

What I rather suspect is something we noticed recently - v7.0-rc1 enables
sheaves for all caches, but also removes cpu (partial) slabs. In v6.19 only
two caches (vma and maple nodes) have sheaves, but also cpu (partial) slabs
still behind them, effectively caching many more objects than with either
mechanism alone. will-it-scale-thread-page_fault3 is a benchmark that is
very sensitive to vma and maple nodes allocation performance and notice this.

So unfortunately we now see it as a regression between 6.19 and v7, but it
should be just offsetting an improvement in 6.18 when sheaves were
introduced for vma and maple nodes with this unintended ~double caching.

> Recreation steps:
> -----------------
> 1) git clone https://github.com/antonblanchard/will-it-scale.git
> 2) git clone https://github.com/intel/lkp-tests.git
> 3) cd will-it-scale && git apply
> lkp-tests/programs/will-it-scale/pkg/will-it-scale.patch
> 4) make
> 5) python3 runtest.py page_fault3 25 thread 0 0 1 8 64 128 192 256
> 
> NOTE: [5] is specific to machine's architecture. starting from 1 is the
> array of no.of tasks that you'd wish to run the testcase which here is
> no.cores per CCX, per NUMA node/ per Socket, nr_threads.
> 
> I also ran the micro-benchmark with ./tools/testing/perf record and
> following is the diff collected:-
> 
> # ./perf diff perf.data.old perf.data
> Warning:
> 4 out of order events recorded.
> # Event 'cpu/cycles/P'
> #
> # Baseline  Delta Abs  Shared Object          Symbol
> # ........  .........  ..................... 
> ...................................................
> #
>                +11.95%  [kernel.kallsyms]      [k] folio_pte_batch
>                +10.30%  [kernel.kallsyms]      [k] 
> native_queued_spin_lock_slowpath
>                 +9.91%  [kernel.kallsyms]      [k] __block_write_begin_int
>       0.00%     +8.56%  [kernel.kallsyms]      [k] clear_page_erms
>       7.71%     -7.71%  [kernel.kallsyms]      [k] delay_halt
>                 +6.84%  [kernel.kallsyms]      [k] block_dirty_folio
>       1.58%     +4.90%  [kernel.kallsyms]      [k] unmap_page_range
>       0.00%     +4.78%  [kernel.kallsyms]      [k] folio_remove_rmap_ptes
>       3.17%     -3.17%  [kernel.kallsyms]      [k] __vmf_anon_prepare
>       0.00%     +3.09%  [kernel.kallsyms]      [k] ext4_page_mkwrite
>                 +2.32%  [kernel.kallsyms]      [k] ext4_dirty_folio
>       0.00%     +2.01%  [kernel.kallsyms]      [k] vm_normal_page
>       0.00%     +1.93%  [kernel.kallsyms]      [k] set_pte_range
>                 +1.84%  [kernel.kallsyms]      [k] block_commit_write
>                 +1.82%  [kernel.kallsyms]      [k] mod_node_page_state
>                 +1.68%  [kernel.kallsyms]      [k] lruvec_stat_mod_folio
>                 +1.56%  [kernel.kallsyms]      [k] mod_memcg_lruvec_state
>       1.40%     -1.39%  [kernel.kallsyms]      [k] mod_memcg_state
>                 +1.38%  [kernel.kallsyms]      [k] folio_add_file_rmap_ptes
>       5.01%     -0.87%  page_fault3_threads    [.] testcase
>                 +0.84%  [kernel.kallsyms]      [k] tlb_flush_rmap_batch
>                 +0.83%  [kernel.kallsyms]      [k] mark_buffer_dirty
>       1.66%     -0.75%  [kernel.kallsyms]      [k] flush_tlb_mm_range
>                 +0.72%  [kernel.kallsyms]      [k] css_rstat_updated
>       0.60%     -0.60%  [kernel.kallsyms]      [k] osq_unlock
>                 +0.57%  [kernel.kallsyms]      [k] _raw_spin_unlock
>                 +0.55%  [kernel.kallsyms]      [k] perf_iterate_ctx
>                 +0.54%  [kernel.kallsyms]      [k] __rcu_read_lock
>       0.11%     +0.53%  [kernel.kallsyms]      [k] osq_lock
>                 +0.46%  [kernel.kallsyms]      [k] finish_fault
>       0.46%     -0.46%  [kernel.kallsyms]      [k] do_wp_page
>                 +0.45%  [kernel.kallsyms]      [k] pte_val
>       1.10%     -0.41%  [kernel.kallsyms]      [k] filemap_fault
>                 +0.39%  [kernel.kallsyms]      [k] native_set_pte
>                 +0.36%  [kernel.kallsyms]      [k] rwsem_spin_on_owner
>       0.28%     -0.28%  [kernel.kallsyms]      [k] mas_topiary_replace
>                 +0.28%  [kernel.kallsyms]      [k] _raw_spin_lock_irqsave
>                 +0.27%  [kernel.kallsyms]      [k] percpu_counter_add_batch
>                 +0.27%  [kernel.kallsyms]      [k] memset
>       0.00%     +0.24%  [kernel.kallsyms]      [k] mas_walk
>       0.23%     -0.23%  [kernel.kallsyms]      [k] __pmd_alloc
>       0.23%     -0.22%  [kernel.kallsyms]      [k] rcu_core
>                 +0.21%  [kernel.kallsyms]      [k] __rcu_read_unlock
>       0.04%     +0.19%  [kernel.kallsyms]      [k] ext4_da_get_block_prep
>                 +0.19%  [kernel.kallsyms]      [k] lock_vma_under_rcu
>       0.01%     +0.19%  [kernel.kallsyms]      [k] prep_compound_page
>                 +0.18%  [kernel.kallsyms]      [k] filemap_get_entry
>                 +0.17%  [kernel.kallsyms]      [k] folio_mark_dirty
> 
> Would be happy to help with further testing and providing additional 
> data if required.
> 
> Thanks,
> Suneeth D
> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>   mm/slub.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 60 insertions(+), 22 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 41e1bf35707c..4ca6bd944854 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2889,7 +2889,8 @@ static void pcs_destroy(struct kmem_cache *s)
>>   	s->cpu_sheaves = NULL;
>>   }
>>   
>> -static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
>> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
>> +					       bool allow_spin)
>>   {
>>   	struct slab_sheaf *empty = NULL;
>>   	unsigned long flags;
>> @@ -2897,7 +2898,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
>>   	if (!data_race(barn->nr_empty))
>>   		return NULL;
>>   
>> -	spin_lock_irqsave(&barn->lock, flags);
>> +	if (likely(allow_spin))
>> +		spin_lock_irqsave(&barn->lock, flags);
>> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
>> +		return NULL;
>>   
>>   	if (likely(barn->nr_empty)) {
>>   		empty = list_first_entry(&barn->sheaves_empty,
>> @@ -2974,7 +2978,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
>>    * change.
>>    */
>>   static struct slab_sheaf *
>> -barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
>> +			 bool allow_spin)
>>   {
>>   	struct slab_sheaf *full = NULL;
>>   	unsigned long flags;
>> @@ -2982,7 +2987,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>>   	if (!data_race(barn->nr_full))
>>   		return NULL;
>>   
>> -	spin_lock_irqsave(&barn->lock, flags);
>> +	if (likely(allow_spin))
>> +		spin_lock_irqsave(&barn->lock, flags);
>> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
>> +		return NULL;
>>   
>>   	if (likely(barn->nr_full)) {
>>   		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
>> @@ -3003,7 +3011,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>>    * barn. But if there are too many full sheaves, reject this with -E2BIG.
>>    */
>>   static struct slab_sheaf *
>> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
>> +			bool allow_spin)
>>   {
>>   	struct slab_sheaf *empty;
>>   	unsigned long flags;
>> @@ -3014,7 +3023,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>>   	if (!data_race(barn->nr_empty))
>>   		return ERR_PTR(-ENOMEM);
>>   
>> -	spin_lock_irqsave(&barn->lock, flags);
>> +	if (likely(allow_spin))
>> +		spin_lock_irqsave(&barn->lock, flags);
>> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
>> +		return ERR_PTR(-EBUSY);
>>   
>>   	if (likely(barn->nr_empty)) {
>>   		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
>> @@ -5008,7 +5020,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>   		return NULL;
>>   	}
>>   
>> -	full = barn_replace_empty_sheaf(barn, pcs->main);
>> +	full = barn_replace_empty_sheaf(barn, pcs->main,
>> +					gfpflags_allow_spinning(gfp));
>>   
>>   	if (full) {
>>   		stat(s, BARN_GET);
>> @@ -5025,7 +5038,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>   			empty = pcs->spare;
>>   			pcs->spare = NULL;
>>   		} else {
>> -			empty = barn_get_empty_sheaf(barn);
>> +			empty = barn_get_empty_sheaf(barn, true);
>>   		}
>>   	}
>>   
>> @@ -5165,7 +5178,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>>   }
>>   
>>   static __fastpath_inline
>> -unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
>> +				 void **p)
>>   {
>>   	struct slub_percpu_sheaves *pcs;
>>   	struct slab_sheaf *main;
>> @@ -5199,7 +5213,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>>   			return allocated;
>>   		}
>>   
>> -		full = barn_replace_empty_sheaf(barn, pcs->main);
>> +		full = barn_replace_empty_sheaf(barn, pcs->main,
>> +						gfpflags_allow_spinning(gfp));
>>   
>>   		if (full) {
>>   			stat(s, BARN_GET);
>> @@ -5700,7 +5715,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>   	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>>   	struct kmem_cache *s;
>>   	bool can_retry = true;
>> -	void *ret = ERR_PTR(-EBUSY);
>> +	void *ret;
>>   
>>   	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>>   				      __GFP_NO_OBJ_EXT));
>> @@ -5731,6 +5746,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>   		 */
>>   		return NULL;
>>   
>> +	ret = alloc_from_pcs(s, alloc_gfp, node);
>> +	if (ret)
>> +		goto success;
>> +
>> +	ret = ERR_PTR(-EBUSY);
>> +
>>   	/*
>>   	 * Do not call slab_alloc_node(), since trylock mode isn't
>>   	 * compatible with slab_pre_alloc_hook/should_failslab and
>> @@ -5767,6 +5788,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>>   		ret = NULL;
>>   	}
>>   
>> +success:
>>   	maybe_wipe_obj_freeptr(s, ret);
>>   	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
>>   			     slab_want_init_on_alloc(alloc_gfp, s), size);
>> @@ -6087,7 +6109,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
>>    * unlocked.
>>    */
>>   static struct slub_percpu_sheaves *
>> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>> +			bool allow_spin)
>>   {
>>   	struct slab_sheaf *empty;
>>   	struct node_barn *barn;
>> @@ -6111,7 +6134,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>   	put_fail = false;
>>   
>>   	if (!pcs->spare) {
>> -		empty = barn_get_empty_sheaf(barn);
>> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>>   		if (empty) {
>>   			pcs->spare = pcs->main;
>>   			pcs->main = empty;
>> @@ -6125,7 +6148,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>   		return pcs;
>>   	}
>>   
>> -	empty = barn_replace_full_sheaf(barn, pcs->main);
>> +	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>>   
>>   	if (!IS_ERR(empty)) {
>>   		stat(s, BARN_PUT);
>> @@ -6133,7 +6156,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>   		return pcs;
>>   	}
>>   
>> -	if (PTR_ERR(empty) == -E2BIG) {
>> +	/* sheaf_flush_unused() doesn't support !allow_spin */
>> +	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
>>   		/* Since we got here, spare exists and is full */
>>   		struct slab_sheaf *to_flush = pcs->spare;
>>   
>> @@ -6158,6 +6182,14 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>   alloc_empty:
>>   	local_unlock(&s->cpu_sheaves->lock);
>>   
>> +	/*
>> +	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
>> +	 * easier to fall back to freeing directly without sheaves
>> +	 * than add the support (and to sheaf_flush_unused() above)
>> +	 */
>> +	if (!allow_spin)
>> +		return NULL;
>> +
>>   	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>>   	if (empty)
>>   		goto got_empty;
>> @@ -6200,7 +6232,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>>    * The object is expected to have passed slab_free_hook() already.
>>    */
>>   static __fastpath_inline
>> -bool free_to_pcs(struct kmem_cache *s, void *object)
>> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>>   {
>>   	struct slub_percpu_sheaves *pcs;
>>   
>> @@ -6211,7 +6243,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
>>   
>>   	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
>>   
>> -		pcs = __pcs_replace_full_main(s, pcs);
>> +		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
>>   		if (unlikely(!pcs))
>>   			return false;
>>   	}
>> @@ -6333,7 +6365,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>>   			goto fail;
>>   		}
>>   
>> -		empty = barn_get_empty_sheaf(barn);
>> +		empty = barn_get_empty_sheaf(barn, true);
>>   
>>   		if (empty) {
>>   			pcs->rcu_free = empty;
>> @@ -6453,7 +6485,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>>   		goto no_empty;
>>   
>>   	if (!pcs->spare) {
>> -		empty = barn_get_empty_sheaf(barn);
>> +		empty = barn_get_empty_sheaf(barn, true);
>>   		if (!empty)
>>   			goto no_empty;
>>   
>> @@ -6467,7 +6499,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>>   		goto do_free;
>>   	}
>>   
>> -	empty = barn_replace_full_sheaf(barn, pcs->main);
>> +	empty = barn_replace_full_sheaf(barn, pcs->main, true);
>>   	if (IS_ERR(empty)) {
>>   		stat(s, BARN_PUT_FAIL);
>>   		goto no_empty;
>> @@ -6719,7 +6751,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>>   
>>   	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
>>   	    && likely(!slab_test_pfmemalloc(slab))) {
>> -		if (likely(free_to_pcs(s, object)))
>> +		if (likely(free_to_pcs(s, object, true)))
>>   			return;
>>   	}
>>   
>> @@ -6980,6 +7012,12 @@ void kfree_nolock(const void *object)
>>   	 * since kasan quarantine takes locks and not supported from NMI.
>>   	 */
>>   	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
>> +
>> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())) {
>> +		if (likely(free_to_pcs(s, x, false)))
>> +			return;
>> +	}
>> +
>>   	do_slab_free(s, slab, x, x, 0, _RET_IP_);
>>   }
>>   EXPORT_SYMBOL_GPL(kfree_nolock);
>> @@ -7532,7 +7570,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>>   		size--;
>>   	}
>>   
>> -	i = alloc_from_pcs_bulk(s, size, p);
>> +	i = alloc_from_pcs_bulk(s, flags, size, p);
>>   
>>   	if (i < size) {
>>   		/*
>>


