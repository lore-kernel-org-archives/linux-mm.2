Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B765CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B626B00CD; Wed, 13 May 2026 09:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E335D6B00CF; Wed, 13 May 2026 09:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22516B00D0; Wed, 13 May 2026 09:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEC5F6B00CD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F28C1C0019
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:16 +0000 (UTC)
X-FDA: 84762430032.26.5E94710
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 857B6100004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=avYwTvOR;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3uLkZc/zeI4wWlYRCnYJNtlEmmCl6e0Ymtz/E5HBFc=;
	b=HixqUyUiVzRjA5LioSBi2Fmcaz9TTZGgV+jsH8T3jeC15uZXFKh6yHC5/NsVg3sXHnodML
	x1kNwXDkDMRLX2BX8L9lluRg5fYXWaQomcibGGqXkd9bkP7Uu9CpOEo7IAK/YCXC8nRDRI
	GC1+ieZVkcdka9VbPaYPGlIYPUOkXMQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=avYwTvOR;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677814; a=rsa-sha256;
	cv=none;
	b=t4FU83LLu2SH0OKiC3KzKvusoQre5w7EldMmL2sA5sKo1ZzlR70FDfXiPOaB+k42UoyoBr
	wxfBAAqYX2Yn4FniRYPPakKU75whD4HzOvG9WkA4GzE6jeIG7ay37dTqR6ufvk7cWp8Rmp
	kkj+kIpQAiFzmR7GMDFZI2U/UigfawA=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c80167f5716so2961323a12.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677813; x=1779282613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3uLkZc/zeI4wWlYRCnYJNtlEmmCl6e0Ymtz/E5HBFc=;
        b=avYwTvOR6cViO9VB9+9fFhPFIKFvQdqdlswk9dwGqsnLbXqVgTQET94+CHhMoQDdpy
         HHDv+1GQ+8xkC5gRpLQ3xWYKuBWyQ5fbdkYEeF5iI9usWD978ofgB+zEnnlNUVs4wcjn
         wlRPYzcWml5YhXRIsS5ldSz2tTeKHMOqJM3qQKx7DHpzjWsk73AgfvwMpebyV4FL97Qn
         +lELh1PmIaKrUXi5LT6Za3ASskvqGfYgr6RtID+P8wZ2MGKw/c1LANUfag6J00fuF2YZ
         3L1M3ABI5eU97KDTz52t4j8ayBgCea4eL2ELVTt8bXZ/vW2r7FLFwtO1Zc27nZjfHk7z
         OoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677813; x=1779282613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y3uLkZc/zeI4wWlYRCnYJNtlEmmCl6e0Ymtz/E5HBFc=;
        b=Pqmd849i6KPHSoOkBuv7pD/oxpICKlRASOWQsiP8yGun5I9PkwJiR3Ky2NnuCM5wQZ
         gna4uwqBA9SA9IXmAGGzRZ9zSZnj9Zczbp+km8F4XPObDhZyiaQq2uPqW0dRlqVr9f02
         z/4y/0MM9vTfLl7nthJU+SKiSLK3MhJvHt+ktexHTnNgWZwZiD6RSuYJPuPo4g+u/v+g
         pBxcaEoCflaDzht+bQde7repl/kJ92EyhHFs/OS1uQnEmDtct8XZWbQsTbU8gF5sqKOV
         X4AwfchC9+dt91ll0pvTgVDE+GEH+cj8mX8xPOXwp4z/94yhoHGMD7Lth4NEbk8lqTIT
         Nkng==
X-Forwarded-Encrypted: i=1; AFNElJ/UCZzYjBhr/p3J8sMrgGHF/wqghWO0wQmwhcMRbrvTnVddPZXCAUz0hqpZsEQiVHamu80pF9anhg==@kvack.org
X-Gm-Message-State: AOJu0YyLsggC3IdKU+9EDoADTFS+KpzuNYlysXQUT+72WwwTwfKs9A3z
	Lcw5be5m9sGZePSYWtlOYLZ81e1TCB1kwp0yuGzJ0RMOVH4CFb/fHRVETHqedWeG3nI=
X-Gm-Gg: Acq92OH20FvmfIbmeBhcJ1NxKQaxYJjWGFLcdOPmdmxTc7Up90IL7XdCHJJMis10XYL
	di8KS+vdRFM7FApDb4oxhLMbfl+VJJsd4HtFpNty0LC8Wzieiz1IuAo0YkzVIHxRkShG9hPuf47
	yeF/mIA1lzAbv9JiBCmSHeN5Maoio304ZJ1FaHrwzCTiVmDtgO9LBer5N9jUIivZoZRAAA/6PyD
	7RsG9d4jy8061k7eKRN23KakaW9jDVaz28bnpWOmiI7TSGFFJj1Y0SXQMxQ36636MUvW+SA7O06
	gLFp8Iaqb+6HhqY161DoXoc/9/i4+XIc/fJ45cWtYLoe0XBLVvFM+PblAHPjx9qQJFZ+czrdix3
	QYrvyTedn1Wf6ZE7Ayn5wAwBFDD/VIbdp0rpBVoenJ2+E5Ej+pS6t73VtcYnEsliQNQ6IEkNpul
	OTSjnQQZV8e2QjEoosAm+VgWC25jQFiQsXJe9fdmVElZ/iWD3R1zCSx1jGe1c=
X-Received: by 2002:a17:902:e54f:b0:2bd:4b8c:fd30 with SMTP id d9443c01a7336-2bd4b8cff82mr5004355ad.41.1778677813243;
        Wed, 13 May 2026 06:10:13 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 29/69] mm/sparse: Mark memblocks present earlier
Date: Wed, 13 May 2026 21:04:57 +0800
Message-ID: <20260513130542.35604-30-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 857B6100004
X-Rspam-User: 
X-Stat-Signature: kzjjrmt1ruuscou6rar1p9hprkw8waxw
X-HE-Tag: 1778677814-445777
X-HE-Meta: U2FsdGVkX19HsCZpptJP+KNZPcJWpL0PlPSkWAE0+K6WrGCsfRDSB/oUubGPZqEbfwPSGRyWaZ0ABO2uoz7jic5usaD54CbejcfWiYtppj+F//m+z/xptlkRBKk1JJhLTqKriYByoBICnJf5hJgU45cntBieCfn/JT43Ri/2GVYOpIaOLfgCRO9EGAN1gqWdJu3trRWGeOil3LUOEciSsnrn3pie41ksEBleP4wxzHdUSGEdjzb1ooQQmPsiks+if7iKLXy6wBoPEplePwa249Jhf6hvu6YJ4fH42oN2MjdAFwTshF2xzZzEq9B/rOIhvMzVSr0w+pYaSe4D9B4KgPOcTCAoQl6MjUTyXpSOupIS6mnw6XkPkLCK+HDkBOEnBucZxssmoxHMkgg/vZ5Rpoq8QLBKlKt5NP0YY/KAR1Inbva1IRthbNBRkNRSqjjMQQqIzjhln0mFCsvgd6F4wBYbFzCPHga9RCq7pWanLCjnB3bzBsQ3ZrCTJ9cEFxg8x9uvoWhg8UGVEJcj3Z7Y+/ORibyn2um3CZhCxOKtdZhqDEI8M8BIWhJftuOpt6OrOEGxDs4w8nCkEfLYHHOWtkNZuPVc7oua2kxGIfP1eWOexCq1TzmkEwYbTZufH+OCH7531DdieK3ZhPnec0FHlZFGF//Q4b7z80o9Qi4Jtv670sJYk2nN7VDiX/iiqOwASU71CVNMY6sdRfZxQQLGP4ZDnU0ozYxMQnTA7nZItxTA/j2iXFUR2gw1jfT3QtoBT41Ztjfo55flgQBPmAU/rAhmDfuPwwrdJHO19Jyu5kGIApdHpalBXhSiIn91okHvp6ntHx4xOChj77d8TuCADU7/ZLb69mHAu4k97r+Wf4/chfF6k4GthCYGxEQ0EdsXaP8zH5AeBFBT4cfaGoGXNch8oR8SVKbrE0ArxvoPZ3THOF6MySyQ4ZJuEgy3c00gtaWBEpCesDwQiGAVgjs
 VjXDaet+
 smnn/S44RzzZjJJdgVkr8FqwEv0rwfYk0WF779oNF/fASGRPdHgAS+2Sz1Y6TROtYJ+FfIGku8PyUl2p9BSvHdKQG/vZTfkgz5KqfjIbk3Lc62gy3/8bMqaWXFN+ei5zXJ9idxDC959KtLB3iyllGEVwKdZ/qZDWfsHt8t7MZlb0M/FB4Isu5XTln7BQbUlxFBncGdKH2CD4yiO/rOLnchkMJ74eOvNdI9VJt1hPOyPcsFhQitKBaWjqWQCLj7bkBjaWse3lHUe3OVN/UhSHApYfttLsYPiKSFSUqrmp+/QVkJj3WyQtXZ2OZJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later patches need struct mem_section entries to be available before
HugeTLB bootmem allocation starts, so the section metadata can be set up
at that stage.

Move the memblock-based section present marking out of sparse_init() and
call it earlier from mm_core_init_early().  Rename the helper to
sparse_memblocks_present() while doing so.

This prepares sparsemem section metadata before the early HugeTLB setup
path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 2 ++
 mm/mm_init.c  | 1 +
 mm/sparse.c   | 4 +---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 2defdef1aedf..bf30617c78d8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -962,6 +962,7 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
  * mm/sparse.c
  */
 #ifdef CONFIG_SPARSEMEM
+void sparse_memblocks_present(void);
 void sparse_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
@@ -999,6 +1000,7 @@ static inline void __section_mark_present(struct mem_section *ms,
 int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
+static inline void sparse_memblocks_present(void) {}
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3aaee1cf7bf0..6723c604eefd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2693,6 +2693,7 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
+	sparse_memblocks_present();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index 3e96478a63e0..33e89bf1ec0c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -195,7 +195,7 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
  * This is a convenience function that is useful to mark all of the systems
  * memory as present during initialization.
  */
-static void __init memblocks_present(void)
+void __init sparse_memblocks_present(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -361,8 +361,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
-- 
2.54.0


