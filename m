Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB15CD98D6
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3E86B00A7; Fri, 12 Jun 2026 00:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAC36B00A9; Fri, 12 Jun 2026 00:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E14B6B00AA; Fri, 12 Jun 2026 00:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D65F6B00A7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D83A01A0408
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:04 +0000 (UTC)
X-FDA: 84869907528.10.58A6CA9
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id EABF620003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cXq0BPnV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yo9t8lKmmaXZlPvADJP1ElnBLtvvFqj3ytBwR1urti0=;
	b=SeVRGEEmKhV57a1oIYHgmcQOTqzyuOqITkBD+ktm9WmOobu79jjoVywpLNZF5ZXVrKdN+J
	QVeOffrHqqBFTEF+6bRBT5RiznLsf7n/Jl3L4DyTYTSR8hObRoEfCEOFf5ichMjyYEln3O
	JX6lnHP3Ko6N2FJkDwm9RBa+gQUlK9Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cXq0BPnV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236803;
	b=Vb+amwxMalnCeggWvoFvzhfMtGyHLFeR6lgMYPxVZmFf3oRrIezo8HSdCMKGDYq9AaVcSU
	RlcFFlUH2OOud0W6mmlan/mpcPvvoftfKMM8Y+XTMjQbXTRbYBZ/bP21S2MPc6shvXzzq6
	qUdB545mZ5aFOT616FzSnbj2QamXZ4E=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-842307473b5so455061b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236802; x=1781841602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yo9t8lKmmaXZlPvADJP1ElnBLtvvFqj3ytBwR1urti0=;
        b=cXq0BPnVT3O6NzOpJL1bZJQrEVGZAMR4TZa/fgPbCzXqYaSWkvFwucy8y3jvEeQDsh
         QEIPzcl9kKQSP5Yefko9mFf+geZwtRtXiyNUFK4WpMOytM93s+GYpfN+TlCMS+pcbNzM
         FqA+F10VTbAermjuRdYIxMKnOfBgQUVeGCMQR5s8ZX4Wx+5QwfTobVjs6ph7hEBgMb5M
         2Yoe9vr8Q4Dsb7SP1N2WW0ZAKHoF4OAS1UdtI2XrtB1GkWYevPxxcnWys85Wvs/HSlrU
         56PggsoeAelqR5IPvumILFq/d3rcfAEow8lF63oDP4BuA3L3d8Zyq3Lsh8BwTOLo4b9I
         2GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236802; x=1781841602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yo9t8lKmmaXZlPvADJP1ElnBLtvvFqj3ytBwR1urti0=;
        b=RzKCwJlvl+L6CrCy91J6yL2wLnyarjccdwmb/vwJg9w4JL9s+RyhQ2kDeFFz+RS9sC
         aLuk4ZakSXoP+jbeMsIRaF0k/cYWMCp/O4PT5zuAdIET9O6eKz2S+lx66JvMShNFYJgv
         jx6Su0pukF24uGqC1GN+OXkZ1HyWi8XCosHCOl9LMFkxypHyRWZXJa+uTzlCZYWUB+I6
         YBlDTaDcRedf+7ONti5VyXKtSptkz0L9m2ezRSg3SulanSYQInOOdCf+pC+ws6dQgufy
         vhZ8eopszuT1aIv8Un8qvnADZVJVFm1pM2yk+llvZZhzwBjUwtLqWSHk0NAJ6zpQ7mL/
         7cxw==
X-Forwarded-Encrypted: i=1; AFNElJ8hZ/yZoFF9yHSwnAkBAV49BGYlRXyqETHt3CyK2kIoVXVUZAVcrZ4g/9JkDPR5FzfAijUFQlG05Q==@kvack.org
X-Gm-Message-State: AOJu0Yxpyda/kti5dcHp0uCaq68p5fzSLfuvp78qTjmmYoSryDH9CT+m
	toqK51ob+msbmgRibpUhDDAbp28zPb3DxgVsSb66hdJFsG095iS/ueugnIQ5uazN8gk=
X-Gm-Gg: Acq92OEhZGpPOwfcyY5SYIiUuyF6+zTtGUIGImsKZlDL0rvjpVV8wCSlTrrHQ6m4uMX
	2eZYxnuPf0x2M2/4lpN+fClzk2ivNYBTQHdGKFhwNdh9v2ObEp8ltucd2lTqUSkzNaLkKXNJVMP
	6xGcLQ5tonmSXHVTjJbgeRdIXTPUGVRYnRovK4xJmiei3Q8/4SwnYOjBETenvvk1xnopmfHxysG
	dEpDeeMqJ58ABm+3kNEw/XRPQaeym+gdCOGWTYF/ydgxD093mURtaCHEjQxOgP0m2tr5FL8Gk7+
	ZaSmx2ZI3nGJvLCi1kuRKdqcPH1auKgdWQVZq0Z0/bdpu+OGJChITgSEhBijdEywTIw+BsyeQIl
	y2BbaFhRK453hCtf/nvI12962FH1ECziQjtI1FBWDlNpgCf9cNIIDZT6EN0ascIyKtq+wm0eksX
	o7sQKdqnxJ3WPLzXlNh7Oe7L8ArBkWceDyamQJIE95xHY=
X-Received: by 2002:a05:6a00:2396:b0:842:68d3:e29d with SMTP id d2e1a72fcca58-8434ce8a80dmr1047898b3a.36.1781236801769;
        Thu, 11 Jun 2026 21:00:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:01 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 10/19] mm/mm_init: Remove set_pageblock_order() call from sparse_init()
Date: Fri, 12 Jun 2026 11:58:54 +0800
Message-ID: <20260612035903.2468601-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4ny46qqoe6ms6dzxst7tywuwf8ymieeg
X-Rspamd-Queue-Id: EABF620003
X-HE-Tag: 1781236802-774245
X-HE-Meta: U2FsdGVkX19f9qwfld2qMd92qK7c8X/f9U4s55iG4PPIaWGNvcxtmEB4d2HKYe9ipxsJm0Mm6QoJarnk+7YSqYvfJmoJPQ8/Nta7cnBYS+ET0yGrQFOePRxmkyUCj6neQQqIzbMeNfC3gWK9tTNw5LZ417EgkeX6YzrvhTHr+mVy8bgPsSbOmGpVZBqA8fIxYXuUD3cmFlo1zWZFHD+CohOYZds09cEGOwy+VOt/7ijCg5j51BJY6L7yHIFx5PIEvgWNsidae5jSWC2YE7jSwzlc/vApgjjNKZOUsaMM/7qLnICYbBXsziHdkxcoqiT6mun+IyWSj8ETq2e4tsGCBU/+8bhPmoQ/cPLgaPgPz6iTYrGVjvCY2xl06wFgNKavgaIusmsZQ01uDUoL7gIpTL6fSI2QkjOylRaX0lLyWpQzcEO3+4SuF2rULAiRWp6Z2Y0SbDhqHxv5T8VEL6mwfXh8wAlaog5oUZhTvYXlSiXNSpaWOC/npJYCs8vxSpA1pgLjpty+UeM8UuqjCGS3v3AOUTy71wsluTdXsZgZxsMqkURHDFdP7ZFfn+NOe4EqwT9QuT4UbeQcPJbqX5DqwPBfcFPVu36D3RptsZ9W+XameRmxvv5zaceAjtAYd+PgG8tkJ/a2J/ngLLij2HRAVy5q5G066d8T6GrZC1wIKWwF8wQhQ6rB5uSFWpcMIe1DbRdI/f7lTZEgdUrdT1J/ECMpc1BE42zyTpZrrSPyv1m5slYpCr/lII8RqwjBPYHVeRRE+QDJ4eDA/JHx4dag/cwvpPSOqdjETIetf+q1qagXblfLpiEpiuRz95zPDmu5dVprLU7i37AlyJxKxnZIYL1saMJu/Xb/Yf+F+aSxwANeS3ySJW3jk1OcpLgKH57pUpcKgpufkQbe5FmAwTlWmzv32EOs+JwwSXSqXvu762z2aoUJ3DCsEKbcnhyRsZt1jXK2eaSjztVAEUOXnPQ
 frux74MK
 GZzDd/FnFl3tHMUmfcGICRddBD4yLIfpHoBVR4NpA4kc0WekUQHH870TD5xNpt4hWCv0Sa4dpXO7589c0LU0i6KdDWTKJtdc8tEDzGAabeucyJbDeGxIxCYDDCpwtilDH2ATUVTOr0vU7bEYKyUXKbD97e8cO+HqwbQVMxgr7ETjgshgmTb/I5u0Q4uy9AxtZSDMvGnnboYKgu1W/0ctCJb1bB38PxgttMN3gpVIRPwWYfQ9zeqirccE50kpAcpYrIfLux0lC6vkb1TniSks1/OofnsfRqCM9lkXW/qX04hg6JxlcAGC1iRm+m3oqVJG13WLgJ2p9FsVRvjUUylGtLq67gtjSZy4GhDudhte8ln20me/CypLgK8qfFUUkQkb9yiPK9h2/UAVjKD68IdGMg9ItFta2nf7DVXGSpOoETOGjyiZYKd34m81ea6gbYkCPnZ6tER4EmAZuQc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init() already sets pageblock_order before sparse_init() runs
for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
call set_pageblock_order() again.

With that call removed, set_pageblock_order() is only used in mm/mm_init.c.
Make it static.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@suse.de>
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 mm/sparse.c   | 3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index dccd4727de46..09efb9f4d126 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1435,7 +1435,6 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ccf494fa7586..a0eb61f9f55a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1496,7 +1496,7 @@ static inline void setup_usemap(struct zone *zone) {}
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1522,7 +1522,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 85557ef387c7..324213d8bdcb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -343,9 +343,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
-- 
2.54.0


