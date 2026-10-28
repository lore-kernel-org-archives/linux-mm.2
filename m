Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CE7606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FBiuLYqr
Received: by kanga.kvack.org (Postfix)
	id D1E596B05B5; Wed, 28 Oct 2026 06:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDC76B05B6; Wed, 28 Oct 2026 06:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BFA6B05B7; Wed, 28 Oct 2026 06:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7CF6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:30:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1975DC0BFF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:30:22 +0000 (UTC)
X-FDA: 85371665484.13.2AF91B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FC4D4000C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:30:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FBiuLYqr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793183420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLbLynrkimEjQQfsH9TxXqFTM1rChVGZCPkVrmOFKSA=;
	b=xMQ8wdkWABwwpMZ0VTFoLGxLjLNrq30qbb/cOEm+EvB9v7BRJFRfslKt+Lvy6QtCXH/Bm/
	+CcoxAQoM3osO8Z1uP1Fy2TdzKVJ3kcGmzjFA/8yw8F8RuJdCQ7M79rzsgKo8O1kd7TqI2
	mE7aJ0pAu4v4XtPU1k/9z9mpO99GAOM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FBiuLYqr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793183420;
	b=p2ozD6L/MVrnmpYrdDfDr51d0MAQj7Y4qAiMKoobHemwZTKi2CBXm2GMM+MmkXCnsXsk+C
	f+z4m03wRqlw9s55ieFAGNt2ZePFMzhx5OYTmKP3AuqFBGOqp1ew5/DlHIuSWEPeN6nRF1
	7p3sSFwNKeTJlg+mJMW+NqEQRHj7LbU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF050175D;
	Wed, 28 Oct 2026 03:30:15 -0700 (PDT)
Received: from [10.163.164.200] (unknown [10.163.164.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81C393F59E;
	Wed, 28 Oct 2026 03:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793183419; bh=4MPiUYIxNyXc9vdvNkcXtM4ldkByD+QE/ChrMGrmtr8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FBiuLYqrxiroBhoNhvYFwAqEEixEavtD4GF9fQEEuBsgIYNK7ccNRyIHehsRitv2v
	 c7Ie6wpU/TIvS32s88hsMi8OOGhNHkL3dJD0JTsASD7JzIIuB5gi14CJtk8TLR0F5Q
	 8jaLwajorqSLSDcmuPKnrRX7q/Gh/tw06UEgT+NY=
Message-ID: <548d9950-cc77-4c1b-b78a-34e304adb989@arm.com>
Date: Wed, 28 Oct 2026 16:00:12 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: annotate data race for
 zone->free_area[order].nr_free
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
References: <20261028090747.68086-1-hui.zhu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261028090747.68086-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FC4D4000C
X-Stat-Signature: cm34c8448cirkcdesb5iurhfczw7nwpu
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793183419-681952
X-HE-Meta: U2FsdGVkX1/rIM/OKcXaaNEliRtZac/6tX/ayNfgCTG6YUO9Jog0mvIgqgDE3asFBx7ZMxNblvqT4Vz8bjxeqsRsFDLg3bbWarSLdc2+ZAwm4BnM+XS5YExHdrNfe0B1l8FzjP+/lQcyPE6RsOGKK295CqPtznp7p2o2x+kFNJ33XuuPDxNlERdOi4oqIXmrcXYDZwpiongmBif0tjKMRK4n2399h5rXQS7VnMo1F1FSYbmyrrU1N0dRxlnQV59wMFPENEmk3dnYhyxZaR54HHprn1PKniwPFyLZImZfxnn/tnZ6njayVNy8uT4pE0YhSGGufvt7Qe9LQHO7NkuK9IUDDNmdmR+MbrSW9wWIFuWj3d5dNtc+ZGB/IcyVLHiEIa3KmQgQ02KBbaccaC7g5+UkZzjQ60FFQjpqBVKDmvAZcH8apHcv/w0RzFAg382FpOSl+ol5M51SNUgd7ekvka1FykCUmt51DeWhfeANWb5b5UrETeAg6w7gAJLhthUuXJcnBkD5t7ok/TeqGtmTAw2HDg75oJQDz+F4YhRifnYhgnlq9vCcP/5MMwEJ+NG+Q0AtR3bxl/S6tmJU5jBzgShSTYVW3/V5GlqSn0cnhvu+fAGwFOeObweHzstAjh0Fl4vKgTGtosWtfoSQLvmG3eS28/VN4MiYBwWMiL2hsTqCjRsjTQiu+sBNgyV8gi2hxcTP8AYYX2wMaWAk604RobeOxxdboK7F3d3nsuNh2wAzT9rDdFKkWAaYqtiVCXFsf1i6Jb8+vETtlLCLvH6trjS2UHpUm7K9K0B9gHr5mbRHCuuQxgasZpekW19/yA21OM2w2OgSIO8qDvKqwsPZ8F2P1htn/TAzW/8OBSvxVe6YlVaJ5X8ANzVGXqEMlENvl2R7KMf873CUtp8c9Xn6WuA6ga3nGmuqaeUb4kewuWPzzT5trowXFoMwjncIqfDd/kALfBwSriL6STfCYmk
 fDaKMoxk
 2xU6LaFEVs9P9YLxl7upgDU5x6LC4wPo5ErVEinWXt7xZuPMFHJyYstaQJpEcvasHntZpXZ8jAnAIbKKF5fAIS7Egtm9/3E2/luxhc3vz+Duxsc81Xe3SKfU6RRjxNcsm1pYVENkOQk7IaoUW7Vof4ZslRrPJAs95QWaNU0QIL5BgtfsJopuPtXuoHrOACJwOHcxXd2dg0VEqoqHW3z9y0AWkeJrV6Sa4dol61vZquZyEHTWpPVmsUctW9Fy5aAFE28iSTrAb7gmjBf261caIJSaxYgbqnfgkM9y4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 28/10/26 2:37 pm, Hui Zhu wrote:
> From: teawater <zhuhui@kylinos.cn>
> 
> KCSAN reports a data-race on nr_free which also exists on mainline:
> 
>   BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
> 
>   race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
>    fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
>    isolate_freepages+0x52/0x650 mm/compaction.c:1722
>    compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
>    compaction_alloc+0x21/0x30 mm/compaction.c:1880
>    migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
>    migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
>    migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
>    migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
>    compact_zone+0x539/0x10b0 mm/compaction.c:2660
>    compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
>    try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
>    __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
>    __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
>    __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
>    alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
>    alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
>    io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
>    io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
>    io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
>    io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
>    io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
>    __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
>    __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
>    __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
>    x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
>    do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>    do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
>    entry_SYSCALL_64_after_hwframe+0x76/0xe0
> 
>   value changed: 0x00000000000002f4 -> 0x00000000000002f5
> 
> nr_free is only updated with zone->lock held, but fast_isolate_freepages()
> and fast_find_migrateblock() read it locklessly to skip an order that has
> no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
> instrumented and the report is of unknown origin.
> 
> The race is benign: a stale zero only skips the order for this round, and
> a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
> lock.  Annotate both reads with data_race(), following commit
> af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free").
> 
> No functional change intended.
> 
> Signed-off-by: teawater <zhuhui@kylinos.cn>

teawater? What?


> ---
>  mm/compaction.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb2016..499ec7ceaa3ed 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1601,7 +1601,11 @@ static void fast_isolate_freepages(struct compact_control *cc)
>  		unsigned int order_scanned = 0;
>  		unsigned long high_pfn = 0;
>  
> -		if (!area->nr_free)
> +		/*
> +		 * Access to nr_free is lockless as it is only a hint; a stale
> +		 * value is harmless. Use data_race to avoid KCSAN warning.
> +		 */

The comment is noise, the reason of using data_race() is a well-known fact.

Apart from that, do we have the same problem with zone_watermark_ok? It also
uses area->nr_free without zone lock.

> +		if (!data_race(area->nr_free))
>  			continue;
>  
>  		spin_lock_irqsave(&cc->zone->lock, flags);
> @@ -2031,7 +2035,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  		unsigned long flags;
>  		struct page *freepage;
>  
> -		if (!area->nr_free)
> +		/*
> +		 * Access to nr_free is lockless as it is only a hint; a stale
> +		 * value is harmless. Use data_race to avoid KCSAN warning.
> +		 */
> +		if (!data_race(area->nr_free))
>  			continue;
>  
>  		spin_lock_irqsave(&cc->zone->lock, flags);


