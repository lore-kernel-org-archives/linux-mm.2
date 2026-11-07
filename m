Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F5CE606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 12:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kZwFvEHm
Received: by kanga.kvack.org (Postfix)
	id 9D1E56B05B0; Sat,  7 Nov 2026 07:23:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9824A6B05B1; Sat,  7 Nov 2026 07:23:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878E66B05B2; Sat,  7 Nov 2026 07:23:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D76F6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:23:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCED9C031A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:23:02 +0000 (UTC)
X-FDA: 85408237404.14.1DEA80D
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf01.hostedemail.com (Postfix) with ESMTP id 28F304000A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:22:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kZwFvEHm;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794054179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBEFW26Kc/QyTcxgmba5XzRa43zG6gzVhqlbzSDo17M=;
	b=X+7CSaIerf4PRVUQiUMutIYB8GEqmVWKw4ZNWzvi4Jcb6gApEMHCG++F7igakJEZo+TCHN
	zLcYSt7kEHZmR2FdSxTlz93u70aZsfCcsxmhiLlZ4lVG+d52ovQzlZwibqXWixvK+f3eWJ
	/ODe99gh1esTit0a4rKBTZnzH5FA9fw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794054179;
	b=R3BBqwXKnv7U732hd00vM/rx9XULmoIS3sYJi4JBFlJwsOE6Qr/6bLMvP1w0SryH2G4Wwd
	xHe04vHoOCp8Ko7rtEy4fXV3B0LDbpjthraQY2CLOpmWvUOCCNzm3Kx0FKr4v4BChUZImm
	Rb3OhY2xeV/bw2u6+o4R/WeC+E7PIlE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kZwFvEHm;
	spf=pass (imf01.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794054173; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=TBEFW26Kc/QyTcxgmba5XzRa43zG6gzVhqlbzSDo17M=;
	b=kZwFvEHmLBEVjNqObY2i1FK03R8EbPnyLe26aRQRW13+nZP6srgyEvVlJlqSMoO0uRy3ZWMYKUrHzvnkRFEMkboi5TNm6rKxQy3diivusrUgov5g4Cx01uujSw0mHy25GTZqsZ8FUdSmvGjxR2fVjC2waqMhQJVtCwwQ0Ma+py4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEEWiqy_1794054171;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEEWiqy_1794054171 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Nov 2026 20:22:52 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Xin Hao <xhao@linux.alibaba.com>,
  Dave Hansen <dave.hansen@linux.intel.com>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
In-Reply-To: <20261107190737.1538200-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Sat, 7 Nov 2026 19:07:37 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
	<87zevmwbaj.fsf@DESKTOP-5N7EMDA>
	<179395975709.1235605.1971486611419119070@hygon.cn>
	<20261107015057.1328227-1-qiuzhiteng@hygon.cn>
	<87qzgxw2qx.fsf@DESKTOP-5N7EMDA>
	<20261107190737.1538200-1-qiuzhiteng@hygon.cn>
Date: Sat, 07 Nov 2026 20:22:50 +0800
Message-ID: <87ld74x23p.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28F304000A
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: h3i1438wtaqcmzt8gyjcu8ptihnw1zak
X-Rspam-User: 
X-HE-Tag: 1794054177-73988
X-HE-Meta: U2FsdGVkX1/1ZFehHJKo2r0bOZ5RMFWNZY6CGfcdzpUXYXNwjcZ2gjABmUcTuHUN3AmluN1kwEPzWMSl2eDvPJBX5nY0b2KPn/zlxc4w+uxD3qK4/LivB6GBvbV3hDvliLBU6cQae5X1t/tuU73mOTLvzwzX/8A5KMWdrWAbQlk+UfocfPqkd3aLT2e848n31G4WeqmtUO1vxs0ap8DwY3Ao1PtHsUafXnIMmlTcs39MKHhgtjefCji0UI6e8xJikvB8P8gMQapb5Q5wYCRvUrxUkLWFRno6iiMI/DKlpA0KNVF0zTf7KQUpcANIKHNi262xNbEIIITV7i3uzYbI94QGl/3YEsvoDjCaVr/rkiwHWpwtI5kbeCeM6HUdY3+CpKu0U/gGlBTNKwoiMaGknG12/e/r8HV2nXM3MaUnQXPKqVr9RrptuDw+E+ni2MX24eAZH7KRfBeGZoGswD6HVw7TzqSgBtZFCeg/koroHL6UOs9MvGdN+UGl7i76aKyJhva6PuiYAQksu5UHHaEQEvEo/TTWttlHy//2nOZ4hMdssBAU1UwvFwPtph0zoo8rNsZPxjPVsQ4vaKf7yHvqHmkcGkhqAap8cXsuqU8dc+WNFEnfLhn3MtbFewW0kDgYdssnXWyJAgcRXTaGlQn7wR3E6ddIleWEVcAdBBZfiorHSFn/o3bFpz7Vd2sDIDMfy5Lfpc4pH23EHt8zjmT+gyqwZJ30lm0MXTR5N5VkaSba6usE2BZ8AC4GQNoRkNTYAJUsoIH0tBwDOW4Mf/0YnlfREBVsfOWgLx5tKQFV8GtnHqzntLbumKwDxT7QsM+wLRVeksoX3vULXbnsR7817scy8KGprZQDE9bihbl5s7qMBG8u1rKtu+3NAPEF0cQ0HJ6GR7rlFxD3yWXeucsYkV3mEJhouo5rRY5ZSnueKmvgG8MdBuFq4w9tE7mP2Y4mCPIGri1JLz5OSf3TISu
 987jVqiE
 yUeXMgX6jnNG6GxqDoIOtd+D1Ed2HDqVJ+MlPZrCxOjulkQk1muQwOnTGUFdl9XLL8/uPHLcW0tWk9H3GuuXDh8YItIKCGaFLQyYjFUVaVWyxx0bxfDqOfVOk5jAcyyF8N/q59SSjdolRpUrOLLEAvAEwEvaTPmrBLdwzv2H81Rvn5ooAOeIowbx5fZsvlIXL9+ftaV27lSao+TWHjZm1sQl2EtjR2YlasWvmGXM05T2vrLKAhEMUhlQqSziCMSkTDT+y6718uuV4IMqgstWEaT9YBVT295UbrntsZAM+bo5QwDUGtZKUaCsxd0bW9H5FRwP5Zx9daFG5UZfMuf9igv1z3s34DJRccLJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> Hi Ying,
>
>> Have you adjusted the NUMA scanning parameters?
>
> No.  All NUMA balancing tunables are at their defaults
> (scan_delay_ms=1000, scan_period_min_ms=1000,
> scan_period_max_ms=60000, scan_size_mb=256).
>
> The scan is indeed slow: 58 passes of 256 MB in 55 s, 89 ms each,
> about 9% of wall time.  But the hint faults are not spread evenly
> between passes: those 9% carry 33% of all migrations.
>
> The faults come from the scan, just not from the pass that happens
> to be running at that instant.  Of the migrations that happen
> during a pass, 60% are for pages in the 256 MB chunk being scanned
> right now; nearly all the rest are for pages scanned one or two
> chunks earlier (lower addresses, within 512 MB).  None are from
> addresses the scanner has not reached yet.  So the scan makes the
> pages PROT_NONE and the workload touches them again within a second
> or two, while this or the next pass is running.  The collision is
> not a coincidence between two independent events.
>
> Here is the sequence, one pass on the unpatched kernel:
>
>   CPU A (task_numa_work)          CPU B..N (workload threads)
>   ----------------------          ---------------------------
>   tlb_gather_mmu()
>     tlb_flush_pending++
>   change_pte_range(table 1)
>     PTEs -> PROT_NONE
>                                   access page in table 1
>                                   do_numa_page()
>                                    migrate_misplaced_folio()
>                                     try_to_migrate_one()
>                                      PROT_NONE, but pending set:
>                                      pte_accessible() == true
>                                      tlb_flush_batched++
>                                     try_to_unmap_flush()
>                                      full flush, IPI to ~380 CPUs
>   change_pte_range(table 2)
>     flush_tlb_batched_pending()
>       pending != flushed:
>       flush_tlb_mm(), IPI to ~380 CPUs
>     PTEs -> PROT_NONE
>                                   (same for pages in table 2)
>   ... 128 PTE tables, ~0.7 ms each ...
>   tlb_finish_mmu()                    pass took ~89 ms, not ~7 ms
>     tlb_flush_pending--

This looks much more clear!  Thanks!

> Each table flush makes the pass longer, and a longer pass lets more
> faults happen while tlb_flush_pending is set.  With the patch the
> migration takes the direct path: it may still flush while the pass
> is running, but it does not bump tlb_flush_batched, so the scan does
> not pay per table and the pass stays at ~7 ms.
>
>> That appear too complex.
>
> Agreed.  I'll keep the change in migrate_folio_unmap() and put the
> sequence above into the v2 changelog.

Sounds good to me.

---
Best Regards,
Huang, Ying

