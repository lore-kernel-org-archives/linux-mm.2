Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB72606D80A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=uHZj4cG2
Received: by kanga.kvack.org (Postfix)
	id D08F96B05BA; Fri,  6 Nov 2026 04:37:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9C96B05BB; Fri,  6 Nov 2026 04:37:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFEC6B05BC; Fri,  6 Nov 2026 04:37:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94A2F6B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:37:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2365E140CBA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:37:34 +0000 (UTC)
X-FDA: 85404191628.26.F1ABF2D
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6EC04180002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:37:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uHZj4cG2;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793957852;
	b=QCOxr8BcNq+ZP5WD9O7uAvBF5pf+CYJXRAFbyfdSqXPzvdvPvkax/iCUIbg8mNxDxoXUj1
	ffkfjOFBKqSdUzuBv7zo66c5uIg0YWH/XMQP4lo+lL4I4N8Sk2UVyyLkoGpCcINDG1xBRB
	RzV3qxfaF9a58r+ZkxX/8djvXTKybZo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uHZj4cG2;
	spf=pass (imf16.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793957852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLYAAogcGzOh2NI4d9WLpdaFRZuIFqV2eJZI8IGdoW8=;
	b=j8ZWdX2FO79t8M9XOczESLOxlE1FuGvQTF8XrM7QPAYQlINS+AZMX9qrgYY2mf0jxsD2/J
	R8ANtHmu5X1bAXcpxGbZ3D6PrHz4x7EFWFd10hruf0Wy+dLx8PDLKy41+cIogtZppEV3gP
	AHVodLi3xSpNvKO2H3i+DlOd2zFf7yM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793957847; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=PLYAAogcGzOh2NI4d9WLpdaFRZuIFqV2eJZI8IGdoW8=;
	b=uHZj4cG2y/o/E78mRISRMtIm0ORPO+jnqh7rUD//u/FF4q9yPzp5meszZytP3Vc//CZ14GYqdPW3y+mqjEd9QkEbpOEavWS8M+eqM+3fqWvJDMumngcErUz2pV4TaZ45MMYl2slnbav+3L23r+cXH/ag/JU+etaJVFLNmuSi22c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEBH0Tu_1793957845;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEBH0Tu_1793957845 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 17:37:27 +0800
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
In-Reply-To: <20261106041628.1177963-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Fri, 6 Nov 2026 12:16:28 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Fri, 06 Nov 2026 17:37:24 +0800
Message-ID: <87zevmwbaj.fsf@DESKTOP-5N7EMDA>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: 8zrqrw3onwiqztxk8zdz4jpce398ud8d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6EC04180002
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793957850-842800
X-HE-Meta: U2FsdGVkX1+vBzDv1AvsxMLrlz28ySS9hbZ0HQ14L47+pSvCIi6j8KzUTFwPE7BE9kkDjqbZXlec2CCanG7oR9rR1PdjcYSBh1xJU/oSlLAw/WVh+RkkndMwfuy5CqU7Rw9vZRmB/W00T/w97ZrYoNiNs6SX003CB3wRgne12VOPGgv09iD/bmofFezv69GVNjdNEO6TU9WvAUfXxVAmc6VWZJFg3nHjH6Z2sIJPfz2vzFmRkLX738/gCnq37gap87ffFisMfiBeJ/tktQWggZf+zgz5AFzZVgiojilMxs7bIiHM5AH0z0FVVhKft6RhyNxLXDDGZhxCKaW1LGlPvGxgZiF2jSF92gW7/RmJJFbmpl/N20cC4JiP47eaEx0/YuIUl/fkcCOkASJX85071bOLg/zcQHUVWmfwQsIAJI7QHryfT7rk6yJ7NE+Pk1k+atB83Pb/+PwV8hUPsaMeaIQ3gLastxp61mRqlZLzPzcyk2lVRhDjJb4zn220pLL+6l4m26ZL0+cF9aVlMuwlj/t0QL1lGxIZTHuM2W10jYIIovNQeQyYcPfmqZ8ssRAA722GRJ2rtvwsFfICPB+2W9V4/ykbzVnuhnU1X6HECiw1Ytfa+ZL/MezvFl4WuTwQ98rPEObcNSiMWwb/I0IRuq5WuVMJO8Cpaes8OQj39cWhZWCnSvWCmFgFQ+OuD8ZDH1+piB8HfKRcSMX0tdil9oEg/tudHe5cMS49vrf2s5imqVKmoPHEht7cWKft0OblVmER9TeaF46QrWmCCM4A61IR3DNZkYt6ekDNJ7aUXsqPANFyvI6nDgZ5jaDZKtUkqrGVvYP8ECH+qmTVZTdJp53KeIiDFtKBjlWtpTzmpHRPd2zFvPIIgJgs4O+HWshgBGAeewbQIxWO+hlPPETZ66Aqq32GVOzZ8/jsRwpJq08MRDZk7ZapINvDCZyg16XGvrHmAvrh0/foOpNPuT2
 Hl0LGlUM
 tsZslsVmSFi3zHiZOjsP6bmV4Z6zfEB0yGVPFUWUG6do5oo0pPefBAxzyRNzKJYV/N74ck1WCWGM2E6BUHh/e+Pvf/GRbr/OsmsUtgPwfragE/W8Mqd1iX32KYU5SczNyUC+fjvrFaM2btlJickzF7z7IBdBwcCD/CZk/46qM9E9hc86c6Ep2pU2cxa084jn2pnA3w22WPMvNkHSY3g9OZvldO7dnbPVR+zh30/bdeSRO8c+JVOaVMvk39J8FS8h39wE4DJvRR8smWmusBaY0mFVU1obrZReGwIYw9bxPcDuWg8owuR9xUsf1FsZUk/pu3hWXpRYkVyNZNt/T2MYMbM0OFahNAKL7iqed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> Since commit 7e12beb8ca2a ("migrate_pages: batch flushing TLB"), every
> MIGRATE_ASYNC migration unmaps with TTU_BATCH_FLUSH.  That includes NUMA
> balancing and memory-tiering promotion, which migrate one folio per call
> through migrate_misplaced_folio().  For an order-0 folio with a single
> mapping the batch holds one PTE and there is nothing to merge, but the
> flush still changes: on x86, arch_tlbbatch_flush() sends a full TLB
> flush to every CPU in mm_cpumask() instead of invalidating that one page.
>
> On a 2-socket, 384-CPU x86 server without INVLPGB, a 4 KiB-page,
> memory-heavy multithreaded workload takes about 200 TLB shootdown
> interrupts per page migrated by NUMA balancing (v5.15 on the same machine
> takes about 11), and balancing costs it 13-16% of its throughput.
>
> Skip the batched flush only when the batch cannot merge anything: the
> folio is the only one in this migrate_pages_batch() call, it is not a
> large folio, and it is mapped only once.  The rmap walk then meets at
> most one PTE, and ptep_clear_flush() invalidates just that page.
> Everything else keeps the batched flush, including PTE-mapped large
> folios, folios mapped more than once, and the batch of sub-folios
> produced when a partially mapped large folio is split during migration.
>
> PMD-mapped THPs already invalidate their mappings through
> set_pmd_migration_entry(), independently of TTU_BATCH_FLUSH, so their
> flush behaviour is unchanged.  On arm64 the batched path only defers the
> final DSB, so a one-PTE batch should cost about the same either way.
>
> migrate_folio_unmap() cannot see how many folios its caller is
> migrating, so migrate_pages_batch() passes that down.
>
> Measured on v7.3: 120 GiB anonymous working set, 384 threads, 180 s per
> run, three A/B pairs (numa_balancing on vs. off, same boot) per kernel.
>
>                                     v7.3            patched
>   throughput loss from balancing   13.0-16.5%      0.5-6.3%
>   kernel cycles per hinting PTE    1.18-1.22M      0.28-0.31M
>   TLB interrupts / migrated page   202-210         12.7-13.6

IIRC, after commit b99a342d4f11 ("NUMA balancing: reduce TLB flush via
delaying mapping on hint page fault"), we can avoid most TLB flushing
caused by do_numa_page().  Could you check why it does not work?

> Signed-off-by: Zhiteng Qiu <qiuzhiteng@hygon.cn>

[snip]

---
Best Regards,
Huang, Ying

