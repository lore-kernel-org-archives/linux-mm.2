Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A123D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 00:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7847F6B0006; Sun, 14 Dec 2025 19:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735E96B0007; Sun, 14 Dec 2025 19:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623B96B0008; Sun, 14 Dec 2025 19:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4886A6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:37:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD67DC0DA9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:37:06 +0000 (UTC)
X-FDA: 84219840852.23.664153C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98961160017
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:37:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHyZ6Tpz;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765759024;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01c1Eyca54SO/v/1MXDWGw5Jnrjz545vqPN+IjgLmN4=;
	b=eZxlqlyMoE7FV8knLLFfmhLbdaPkTbwd71uddeRBt2f/cbBcMO2B9PIN5aWrGe7V6dlmLW
	QUPywQBxr1WOhFJdt3yHsVyOw1QyTtw2muGni4axShFaA7WrX7OvgRbt2uo+f6dogpLfnL
	WW6OtGwkvuvSyM9WA0qas8NuIOr/1O4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XHyZ6Tpz;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765759024; a=rsa-sha256;
	cv=none;
	b=WEnFadxD3vfHc/81BgFnh+q1suMM+7c6Ni7Y4ZmZeM8UYTmAvGaZEBfBeU8Y1U+wk9rtWL
	+l3z1ztqfcIBgMwHLKPd01Z/D07UFCiJzWY3F7lobBhO7KvxTUCF9N9NwHMh3a3wDeFF5S
	LX3zCHzDqn/TRQFf1ut7mz5ockAzkbA=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b725ead5800so438467266b.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 16:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765759023; x=1766363823; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01c1Eyca54SO/v/1MXDWGw5Jnrjz545vqPN+IjgLmN4=;
        b=XHyZ6TpzruJaVC8lF4Z03OJnBaa5yrhvoP0cZVzyRqp3ECK/zgajGowgeKT3BKpYlz
         WQewJ8ShCTFlm0FpA3Ru1p7AMPRTNmrHA/XUmXAMCK9jG1udgT3ks8WuREDeqk5ZT/Ox
         77qOM923B8rqn9U+t+SpcXNXczkvG2h598wLB32uH22GpTlQyvZfPIFLb/YI0fZbayvb
         AUOTmuFgz2rU/wLZMymgmA1J8VtJC8YnjBG7E49zIdtF3MFVqRWG92qSBpGa2FJZzrqC
         th93uMzkLnJkmRWgoh4fuhfktJF5zTjA4yrj9NCqp9rheMlVdS2QeoMZIsGceHQ4PuUR
         Sxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765759023; x=1766363823;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01c1Eyca54SO/v/1MXDWGw5Jnrjz545vqPN+IjgLmN4=;
        b=rpwiHRD0zWgaz1NOvXZT9AZVp8W5Ye6uJgWMwzHOl6Mn89e1vDTqL2Uyr7GW5XAeIV
         r2KfWV32Ea4/5/PvNOLfXhWOlaQmccnhUbYp0m5le0hy/uhDDc+97hzV+S1MZ33svG40
         ZXZbffg04RVtDWc99ApQzMQCGdCSl1w6ZqzJ4jKGStxZuWGj4z3UbcfRv0BBgNfdAFXk
         o1ZZPfIvg8eDzSqjqb+ZLZKN90yBEpo3PHp6srAxaJnKbHarskH4XCVdH0RjKW72g4HF
         Riypka0yXyp6burTCLrdPT92HHYEkr5a1XMUnLzG3sabpqRqDZ9dSNjF9oImav+MOGa7
         HIIg==
X-Forwarded-Encrypted: i=1; AJvYcCWJ57ivFhBhBmEsQSk0EzXbA9hYC9DYcxkBGwyfWFl15pgaUFb90dL3QeUjOZaitieWdlfQfaISDQ==@kvack.org
X-Gm-Message-State: AOJu0YzecC/8jtK94D2U6Mk88tVIedi7GlmXw4jJ+ilFN50/gbglOBCa
	j8ykNrXJJcHEbqPV7Wj2JUxua17msrlBF3oz0V7UbJEJXXEg0r9WlEHK
X-Gm-Gg: AY/fxX6nyBUaTkkv7lHEGawg24m1/Q/gYCtHBX566Q7KKFLK+1ketWLWeysZ9af14p0
	4NT1FvfTTxDGey4nN0nn3TcvuVF+kxOIPgv8cUdD7kAlK3xTNWKGUEXCzuA7T4LN4ti9lV0VRwl
	7UcWUxvluERV4fAD2cCKKXsISZ5GyYdi7lY/ETXeARtjxL2ES+mGgR4mtl0cEpbFta5ePkBculM
	iSuEe+SqxJjVtZDCZvjmxBuw4WPyJa5w29J7bVneLY7yMXEWN5rtupf9Taf0x6ufgM87bKdY6h+
	UqIO0Ko2s/jNeZqmhLTztAIp3HHNiGl3h5WkKN9Yju8LEdXJReooOQcSK9f6oBBiybSeV6XlNtU
	GQDxFWpMhr3Gr65zNSH8y7IkCQLwjboR+09dopWuzoihiT7/u2xw6WPFqPuMj9cQQ7ba6IU3KPz
	vo/KxoxakDsA==
X-Google-Smtp-Source: AGHT+IH0cFWDPVnijrKIfLVxRliw9r2cCnAauHXHCDZRevXAedYHSMh5sss3KDU4xmdbjDkTXpHV+g==
X-Received: by 2002:a17:907:6eac:b0:b76:f57f:a2c3 with SMTP id a640c23a62f3a-b7d236f781cmr1012657766b.12.1765759022662;
        Sun, 14 Dec 2025 16:37:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa517558sm1224469866b.34.2025.12.14.16.37.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Dec 2025 16:37:01 -0800 (PST)
Date: Mon, 15 Dec 2025 00:37:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Marc Hartmayer <mhartmay@linux.ibm.com>, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: change all pageblocks migrate type on
 coalescing
Message-ID: <20251215003701.2fdyuxvwquin4ovk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251212151457.3898073Add-agordeev@linux.ibm.com>
 <5e79bed1-598d-4e34-8f1e-87b6dba52bf8@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e79bed1-598d-4e34-8f1e-87b6dba52bf8@suse.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98961160017
X-Stat-Signature: 4xtf91558c7a673mo1dj83fkt1g8ku85
X-Rspam-User: 
X-HE-Tag: 1765759024-570026
X-HE-Meta: U2FsdGVkX19fC0nhUHry+5YxpjyemRriIUACG8IsuCyXE2mE3s/v5PinSv1NJe2Bn/f1LWZaieggb8GCjiSmlubOZD8YLG0XdfNK+QCLWRXw6+kMKBEASKrsrjmM+ZBcsf8d+tAwMexLXsolP2eh6oX15kSuXvvljGOjQz293reni0vwVjgaNJBxC+9G8ULnFTVTc/KZ13HHO6HovU1/hmEZtqH67U4R/OE+/+uFF3BlX7i/JLvCeW7DYroUPghZxrsyVTBUlaW3NRUdrLOniOwYJ3Ee5Gsr4uOlT+nZrcLvpCmutQiAtpUPe0FJzYPSoG8uOSetmMlznxnbXJ/QiCBVCb7stp1YbAr2n7fxfjf9Zto9Ggd/Dii200winLV/lL9i4yfjrrZAhYGB9f8GYvwNmUVtDwUfuOpRPStXkALRkDEogtXFe2fEtbt1pJq+upftb7QWrS70q1354gje2T9glBalHHhw8ZIQJAB8tcYCSFAbjKRoe+b9zDp+rw15ZE2VzAEwpto3/MZqqrb6Mxu0EMk7fnPI84HRl6B1DPeB9opfH1yUQTdy1+ZoCtRVt4ywn7ziU82oj8qxyio0igjn2tr6HsieHda9Bn+V25dk5CKbw4ZTEfFYZZ6AK6NlUJMROGGxutWjk5WkEI+S/MN25XHf7S4np9eBB+6ryRrvp2Eurxh3UxLWNU6CDPyWZBpr5tHgFJh8egF0l0tNC6Qcvd+FJ73k1wVWm2NB9AiCKupZfkrefUeBPwrD+ku/lW0tH9AQHM3qMfcwZG76L1RlBFEdSPSKavyl62pcJbLcmDxpNE+Rs4TUtqhzx5jJrFAEeLyo8uoevLWUlLGo4RPJrP9LRsd2xIZpdALTTOJgPtJweMWyhFemXRKtuceYy3aJcEohROMQjLXBWfUnvV+mHOVUJoM/G/Ihm9acqKcucb4VlRaoewPwL2Ir8GUkF+8uLXyjLEGEq147hOI
 2sCV+Y2y
 28Ie3//eozFt9jW1ZYN2kAfsJVhcwSYOwJ8viUyLwQvS7P1fQzBCmqNxKGmch/f1TX3qetjk50JwNLni69mHNxoDrlCA74xR28wSE/KwxjqqRvoSfPBIxgzlzTgN4Ct4diScf5tGHOz0qLmEB4pFBGchUQKlE2z8q3RaVbzavRv/Xx7tnARGZ9WCf83REvncRf98yaBzO7dliMqeA/rv6exR6rtz1I0OXHk/W7r5QKRyM2ysBOoCMWrgiagapTZNCOwlzm3dyr75AHTZxHULJ4YSyvVZWZvQJRALIp72DfwCNPAXUFB3eaxmbToihU2Yei1wZfUiOz+7rLCLRjGvoPkvSZYxway0hz/dixPVuZBcrCj02mRjqZw0pGcR5U9AqcHV8VRJ1THMeUFsgnRYruFt6jbHzMvMHqIIIz3+C+t6V1CfXQMLdZK+Ww66AdDAN6xkyduB1Oa14fYsn6cR8iYX5vxINsJdBR9UHOc6yBgl42gcX63AoyhLX4GMFNPSv55pq6/CCvK+O9stnB2AGb4mo0J/DFTWP8FDQXSj+j9Eac3GPCEd/g3roNNKZpsMV/7ly9/nmMUkg4qPwYbDC7yW/Lt2x8hq3f6Yz6gX+1dnn3HctCgDij9z2DNZJ7s2NR7ZQGsV2QjlzuBxH5LfDvHELQUkxLijaGBPdICH/MTs+AfjRa0H+9UYndkrXCRgJwwozkrtEU6aIYDLR6gzpPfU3Fg0TIHeOMHnEw6f4+BR+H1Fv5tunSi2Trw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 04:46:46PM +0100, Vlastimil Babka wrote:
>On 12/12/25 16:14, Alexander Gordeev wrote:
>> When a page is freed it coalesces with a buddy into a higher
>> order page while possible. When the buddy page migrate type
>> differs, it is expected to be updated to match the one of the
>> page being freed.
>> 
>> However, only the first pageblock of the buddy page is updated,
>> while the rest of the pageblocks are left unchanged.
>> 
>> That causes warnings in later expand() and other code paths
>> (like below), since an inconsistency between migration type
>> of the list containing the page and the page-owned pageblocks
>> migration types is introduced.
>> 
>> The issue is first exposed with commit e0932b6c1f94 ("mm:
>> page_alloc: consolidate free page accounting"), where the
>> warnings were introduced, but it is observed in earlier
>> versions if similar warnings are added.
>> 
>> [  308.986589] ------------[ cut here ]------------
>> [  308.987227] page type is 0, passed migratetype is 1 (nr=256)
>> [  308.987275] WARNING: CPU: 1 PID: 5224 at mm/page_alloc.c:812 expand+0x23c/0x270
>> [  308.987293] Modules linked in: algif_hash(E) af_alg(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) nf_tables(E) s390_trng(E) vfio_ccw(E) mdev(E) vfio_iommu_type1(E) vfio(E) sch_fq_codel(E) drm(E) i2c_core(E) drm_panel_orientation_quirks(E) loop(E) nfnetlink(E) vsock_loopback(E) vmw_vsock_virtio_transport_common(E) vsock(E) ctcm(E) fsm(E) diag288_wdt(E) watchdog(E) zfcp(E) scsi_transport_fc(E) ghash_s390(E) prng(E) aes_s390(E) des_generic(E) des_s390(E) libdes(E) sha3_512_s390(E) sha3_256_s390(E) sha_common(E) paes_s390(E) crypto_engine(E) pkey_cca(E) pkey_ep11(E) zcrypt(E) rng_core(E) pkey_pckmo(E) pkey(E) autofs4(E)
>> [  308.987439] Unloaded tainted modules: hmac_s390(E):2
>> [  308.987650] CPU: 1 UID: 0 PID: 5224 Comm: mempig_verify Kdump: loaded Tainted: G            E       6.18.0-gcc-bpf-debug #431 PREEMPT
>> [  308.987657] Tainted: [E]=UNSIGNED_MODULE
>> [  308.987661] Hardware name: IBM 3906 M04 704 (z/VM 7.3.0)
>> [  308.987666] Krnl PSW : 0404f00180000000 00000349976fa600 (expand+0x240/0x270)
>> [  308.987676]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 RI:0 EA:3
>> [  308.987682] Krnl GPRS: 0000034980000004 0000000000000005 0000000000000030 000003499a0e6d88
>> [  308.987688]            0000000000000005 0000034980000005 000002be803ac000 0000023efe6c8300
>> [  308.987692]            0000000000000008 0000034998d57290 000002be00000100 0000023e00000008
>> [  308.987696]            0000000000000000 0000000000000000 00000349976fa5fc 000002c99b1eb6f0
>> [  308.987708] Krnl Code: 00000349976fa5f0: c020008a02f2	larl	%r2,000003499883abd4
>>                           00000349976fa5f6: c0e5ffe3f4b5	brasl	%r14,0000034997378f60
>>                          #00000349976fa5fc: af000000		mc	0,0
>>                          >00000349976fa600: a7f4ff4c		brc	15,00000349976fa498
>>                           00000349976fa604: b9040026		lgr	%r2,%r6
>>                           00000349976fa608: c0300088317f	larl	%r3,0000034998800906
>>                           00000349976fa60e: c0e5fffdb6e1	brasl	%r14,00000349976b13d0
>>                           00000349976fa614: af000000		mc	0,0
>> [  308.987734] Call Trace:
>> [  308.987738]  [<00000349976fa600>] expand+0x240/0x270
>> [  308.987744] ([<00000349976fa5fc>] expand+0x23c/0x270)
>> [  308.987749]  [<00000349976ff95e>] rmqueue_bulk+0x71e/0x940
>> [  308.987754]  [<00000349976ffd7e>] __rmqueue_pcplist+0x1fe/0x2a0
>> [  308.987759]  [<0000034997700966>] rmqueue.isra.0+0xb46/0xf40
>> [  308.987763]  [<0000034997703ec8>] get_page_from_freelist+0x198/0x8d0
>> [  308.987768]  [<0000034997706fa8>] __alloc_frozen_pages_noprof+0x198/0x400
>> [  308.987774]  [<00000349977536f8>] alloc_pages_mpol+0xb8/0x220
>> [  308.987781]  [<0000034997753bf6>] folio_alloc_mpol_noprof+0x26/0xc0
>> [  308.987786]  [<0000034997753e4c>] vma_alloc_folio_noprof+0x6c/0xa0
>> [  308.987791]  [<0000034997775b22>] vma_alloc_anon_folio_pmd+0x42/0x240
>> [  308.987799]  [<000003499777bfea>] __do_huge_pmd_anonymous_page+0x3a/0x210
>> [  308.987804]  [<00000349976cb08e>] __handle_mm_fault+0x4de/0x500
>> [  308.987809]  [<00000349976cb14c>] handle_mm_fault+0x9c/0x3a0
>> [  308.987813]  [<000003499734d70e>] do_exception+0x1de/0x540
>> [  308.987822]  [<0000034998387390>] __do_pgm_check+0x130/0x220
>> [  308.987830]  [<000003499839a934>] pgm_check_handler+0x114/0x160
>> [  308.987838] 3 locks held by mempig_verify/5224:
>> [  308.987842]  #0: 0000023ea44c1e08 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0xb2/0x2a0
>> [  308.987859]  #1: 0000023ee4d41b18 (&pcp->lock){+.+.}-{2:2}, at: rmqueue.isra.0+0xad6/0xf40
>> [  308.987871]  #2: 0000023efe6c8998 (&zone->lock){..-.}-{2:2}, at: rmqueue_bulk+0x5a/0x940
>> [  308.987886] Last Breaking-Event-Address:
>> [  308.987890]  [<0000034997379096>] __warn_printk+0x136/0x140
>> [  308.987897] irq event stamp: 52330356
>> [  308.987901] hardirqs last  enabled at (52330355): [<000003499838742e>] __do_pgm_check+0x1ce/0x220
>> [  308.987907] hardirqs last disabled at (52330356): [<000003499839932e>] _raw_spin_lock_irqsave+0x9e/0xe0
>> [  308.987913] softirqs last  enabled at (52329882): [<0000034997383786>] handle_softirqs+0x2c6/0x530
>> [  308.987922] softirqs last disabled at (52329859): [<0000034997382f86>] __irq_exit_rcu+0x126/0x140
>> [  308.987929] ---[ end trace 0000000000000000 ]---
>> [  308.987936] ------------[ cut here ]------------
>> [  308.987940] page type is 0, passed migratetype is 1 (nr=256)
>> [  308.987951] WARNING: CPU: 1 PID: 5224 at mm/page_alloc.c:860 __del_page_from_free_list+0x1be/0x1e0
>> [  308.987960] Modules linked in: algif_hash(E) af_alg(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) nf_tables(E) s390_trng(E) vfio_ccw(E) mdev(E) vfio_iommu_type1(E) vfio(E) sch_fq_codel(E) drm(E) i2c_core(E) drm_panel_orientation_quirks(E) loop(E) nfnetlink(E) vsock_loopback(E) vmw_vsock_virtio_transport_common(E) vsock(E) ctcm(E) fsm(E) diag288_wdt(E) watchdog(E) zfcp(E) scsi_transport_fc(E) ghash_s390(E) prng(E) aes_s390(E) des_generic(E) des_s390(E) libdes(E) sha3_512_s390(E) sha3_256_s390(E) sha_common(E) paes_s390(E) crypto_engine(E) pkey_cca(E) pkey_ep11(E) zcrypt(E) rng_core(E) pkey_pckmo(E) pkey(E) autofs4(E)
>> [  308.988070] Unloaded tainted modules: hmac_s390(E):2
>> [  308.988087] CPU: 1 UID: 0 PID: 5224 Comm: mempig_verify Kdump: loaded Tainted: G        W   E       6.18.0-gcc-bpf-debug #431 PREEMPT
>> [  308.988095] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
>> [  308.988100] Hardware name: IBM 3906 M04 704 (z/VM 7.3.0)
>> [  308.988105] Krnl PSW : 0404f00180000000 00000349976f9e32 (__del_page_from_free_list+0x1c2/0x1e0)
>> [  308.988118]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:3 PM:0 RI:0 EA:3
>> [  308.988127] Krnl GPRS: 0000034980000004 0000000000000005 0000000000000030 000003499a0e6d88
>> [  308.988133]            0000000000000005 0000034980000005 0000034998d57290 0000023efe6c8300
>> [  308.988139]            0000000000000001 0000000000000008 000002be00000100 000002be803ac000
>> [  308.988144]            0000000000000000 0000000000000001 00000349976f9e2e 000002c99b1eb728
>> [  308.988153] Krnl Code: 00000349976f9e22: c020008a06d9	larl	%r2,000003499883abd4
>>                           00000349976f9e28: c0e5ffe3f89c	brasl	%r14,0000034997378f60
>>                          #00000349976f9e2e: af000000		mc	0,0
>>                          >00000349976f9e32: a7f4ff4e		brc	15,00000349976f9cce
>>                           00000349976f9e36: b904002b		lgr	%r2,%r11
>>                           00000349976f9e3a: c030008a06e7	larl	%r3,000003499883ac08
>>                           00000349976f9e40: c0e5fffdbac8	brasl	%r14,00000349976b13d0
>>                           00000349976f9e46: af000000		mc	0,0
>> [  308.988184] Call Trace:
>> [  308.988188]  [<00000349976f9e32>] __del_page_from_free_list+0x1c2/0x1e0
>> [  308.988195] ([<00000349976f9e2e>] __del_page_from_free_list+0x1be/0x1e0)
>> [  308.988202]  [<00000349976ff946>] rmqueue_bulk+0x706/0x940
>> [  308.988208]  [<00000349976ffd7e>] __rmqueue_pcplist+0x1fe/0x2a0
>> [  308.988214]  [<0000034997700966>] rmqueue.isra.0+0xb46/0xf40
>> [  308.988221]  [<0000034997703ec8>] get_page_from_freelist+0x198/0x8d0
>> [  308.988227]  [<0000034997706fa8>] __alloc_frozen_pages_noprof+0x198/0x400
>> [  308.988233]  [<00000349977536f8>] alloc_pages_mpol+0xb8/0x220
>> [  308.988240]  [<0000034997753bf6>] folio_alloc_mpol_noprof+0x26/0xc0
>> [  308.988247]  [<0000034997753e4c>] vma_alloc_folio_noprof+0x6c/0xa0
>> [  308.988253]  [<0000034997775b22>] vma_alloc_anon_folio_pmd+0x42/0x240
>> [  308.988260]  [<000003499777bfea>] __do_huge_pmd_anonymous_page+0x3a/0x210
>> [  308.988267]  [<00000349976cb08e>] __handle_mm_fault+0x4de/0x500
>> [  308.988273]  [<00000349976cb14c>] handle_mm_fault+0x9c/0x3a0
>> [  308.988279]  [<000003499734d70e>] do_exception+0x1de/0x540
>> [  308.988286]  [<0000034998387390>] __do_pgm_check+0x130/0x220
>> [  308.988293]  [<000003499839a934>] pgm_check_handler+0x114/0x160
>> [  308.988300] 3 locks held by mempig_verify/5224:
>> [  308.988305]  #0: 0000023ea44c1e08 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0xb2/0x2a0
>> [  308.988322]  #1: 0000023ee4d41b18 (&pcp->lock){+.+.}-{2:2}, at: rmqueue.isra.0+0xad6/0xf40
>> [  308.988334]  #2: 0000023efe6c8998 (&zone->lock){..-.}-{2:2}, at: rmqueue_bulk+0x5a/0x940
>> [  308.988346] Last Breaking-Event-Address:
>> [  308.988350]  [<0000034997379096>] __warn_printk+0x136/0x140
>> [  308.988356] irq event stamp: 52330356
>> [  308.988360] hardirqs last  enabled at (52330355): [<000003499838742e>] __do_pgm_check+0x1ce/0x220
>> [  308.988366] hardirqs last disabled at (52330356): [<000003499839932e>] _raw_spin_lock_irqsave+0x9e/0xe0
>> [  308.988373] softirqs last  enabled at (52329882): [<0000034997383786>] handle_softirqs+0x2c6/0x530
>> [  308.988380] softirqs last disabled at (52329859): [<0000034997382f86>] __irq_exit_rcu+0x126/0x140
>> [  308.988388] ---[ end trace 0000000000000000 ]---
>> 
>> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> Closes: https://lore.kernel.org/linux-mm/87wmalyktd.fsf@linux.ibm.com/
>> Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
>> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>
>Hm I guess we haven't seen this before because it's common that
>pageblock_order is just one below MAX_ORDER so we're only merging two
>pageblocks. But your arch/config must be different to expose it. In any case
>LGTM, thanks.

Deep hiding. I didn't spot it when reading the code.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

>
>Acked-by: Vlastimil Babka <vbabka@suse.cz>
>
>> ---
>>  mm/page_alloc.c | 24 ++++++++++++------------
>>  1 file changed, 12 insertions(+), 12 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index ed82ee55e66a..6e644f2744c2 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -913,6 +913,17 @@ buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
>>  			NULL) != NULL;
>>  }
>>  
>> +static void change_pageblock_range(struct page *pageblock_page,
>> +				   int start_order, int migratetype)
>> +{
>> +	int nr_pageblocks = 1 << (start_order - pageblock_order);
>> +
>> +	while (nr_pageblocks--) {
>> +		set_pageblock_migratetype(pageblock_page, migratetype);
>> +		pageblock_page += pageblock_nr_pages;
>> +	}
>> +}
>> +
>>  /*
>>   * Freeing function for a buddy system allocator.
>>   *
>> @@ -999,7 +1010,7 @@ static inline void __free_one_page(struct page *page,
>>  			 * expand() down the line puts the sub-blocks
>>  			 * on the right freelists.
>>  			 */
>> -			set_pageblock_migratetype(buddy, migratetype);
>> +			change_pageblock_range(buddy, order, migratetype);
>>  		}
>>  
>>  		combined_pfn = buddy_pfn & pfn;
>> @@ -2146,17 +2157,6 @@ bool pageblock_unisolate_and_move_free_pages(struct zone *zone, struct page *pag
>>  
>>  #endif /* CONFIG_MEMORY_ISOLATION */
>>  
>> -static void change_pageblock_range(struct page *pageblock_page,
>> -					int start_order, int migratetype)
>> -{
>> -	int nr_pageblocks = 1 << (start_order - pageblock_order);
>> -
>> -	while (nr_pageblocks--) {
>> -		set_pageblock_migratetype(pageblock_page, migratetype);
>> -		pageblock_page += pageblock_nr_pages;
>> -	}
>> -}
>> -
>>  static inline bool boost_watermark(struct zone *zone)
>>  {
>>  	unsigned long max_boost;
>

-- 
Wei Yang
Help you, Help me

