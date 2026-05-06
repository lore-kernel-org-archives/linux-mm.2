Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CD6CD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF106B009F; Wed,  6 May 2026 05:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7556B00A0; Wed,  6 May 2026 05:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC6B6B00A1; Wed,  6 May 2026 05:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1A56B009F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F6988C2B0
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:30 +0000 (UTC)
X-FDA: 84736514940.13.7B96CF3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 730A92000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rvvWJNYU;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aUmN/Cs8HCUpRqoFgWfzM35aOL5ATeFyTzsd6j8qQs=;
	b=LFyPUc+awhPBGtS/lDz+smvCsjgZMpLSmI5VNKgqvLoVR+NQmczpa5xgFgHk1Fdh057wPn
	pd9bwoyQQ60swuoblz3Ykt9vBIbSCRjy6FBi8qbp2bABkxFBDfONe/hkwa7T+TsC6blSsP
	wCk8LV9/qmQEMDGVhsxHWGvIQ46rl28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060788; a=rsa-sha256;
	cv=none;
	b=MBUA2/je/8ICdlr64W2WY68C366xKEvZZ0Q3CAPQtxJjztPLkuVUn8TVH2OmD9aVacYNrZ
	y2xzqFb5Uq4eWDOjY0+yYKstGWgte3iingnzoXzK6vqGwYgQoMOPu2D97Bi4axXYOy2Bqc
	H74/dpii6cmY4ft0SYKcvb7znr85tzk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rvvWJNYU;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 100673431;
	Wed,  6 May 2026 02:46:22 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7DC943F7B4;
	Wed,  6 May 2026 02:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060787; bh=rRadP4CewtOg+NLpdIedWh+LQBtmo+8t4s4Kk/x+lvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rvvWJNYU7UtaKk/kGo1sO5YIZ3/7LDMqea+nc650FI4VCfVzkS+QB8r6aZglH59+6
	 z9iU/lgJZPoPFEEhw/NtHs3NjoKnkVOQk/mJFm5YGJYimMBOGF3Mw42QkP663hVQH8
	 uHUoYsVn21kBE2BEXf0jHtEy6A5THPyZaEwIvv7E=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 8/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Wed,  6 May 2026 15:15:03 +0530
Message-Id: <20260506094504.2588857-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 730A92000A
X-Rspam-User: 
X-Stat-Signature: ob8b9b6gmzjhy5jjiscwibj15x8iqdi5
X-HE-Tag: 1778060788-838668
X-HE-Meta: U2FsdGVkX1/KnGr16hoHhdNFERV3YzZmY6QwxVBoYwxSaNpvHQJ/EOfNfBKvGXJ9J/3oHmaxsIgS0mn5PVsKS1fapnix9m1p11imRvt8EzCTakRo2a9GnG/B8XtjulxAQvkw40Zdcgknnamn+MPxe7PGr7+QtXiwVcqhvvcbIoB9MjywAuJSXJXV5k9bQmo8hggRPOPqATf42yZztc2oqNd2BcrwdBVGZMfDJc6HkaOtKza86zbkTK0p9TEpT4eKIGejxAn+ehfgSTfIy6lC2TnSmw8wW8en7z7PR6tBVOxanD74v2loiouL8VL/Un/dic/tA32+Rwyv+7Y6a1IbLvQR71cItZAyHQtDwwnZ0mknmYSbZ94rXnri/3q/RbAbpzG+a4PnqoKMhUuetiCJMm6rvAajXkD4DzafQ8zvZMrE8nst4GrHab+EntdGy/037NLY9GK85JyslZsKOWvHKuKZD7esYY3DWJEvXi5dJP/UMKWlyEPitcErI9ihwgrh/aK2hUhcyQXYoCIfM3Xpavfd1gHWV+65XvSjYM9kc2//iIqFagh4BqcOKGLJ1+8+5/qMkjwjuloXli/Jo/4m9DKHT6V24mtiYHyrsxH1ZwgryeXuCudpU+9O2LtQtm0T0tIiXjvPe1JtqlyHBeMOgKkJPq/jbMWdDvDvbr/L0RHmP+PxPzuX03XjQZWSh3PqrR1h0CJKtKB/3vdJbpz0uqtLRN1w4qVVovIq5tINYRI/Iaexjh3HX9t6NZWLSdlirUqoZbqQwN9mxbieDwOhUpgFTMYkuhkjs4GPZKZMIZZ4hOFM+rMGlxg122kzXafOfnoaVP7WYq8mZj2k0cMRnWUiRMA0vly3fdc+UCmkOTb/ezxuWNFkFA9Smvr+tD4qWrP19ixt5lcg5L1t012iBrvgxncMhZNwox33PQ+XRQdt05oej1tujRmGv5QLrOeFMVGMNdkT4IsIoPPxGzW
 LhuaVDgC
 lQetADC7seQT2ztrjIzzETJLXtw69jIDGRuQwT+2GiigjtRhMLroD88kZv5kCbh+BdR7Cvv7hD6QqzYlgMalbhI26RI9XLuOsfRQ0FVeIYXC/EJfD4hW8NzAUL/yDz0T0Miwi9C7MKPpiuvGlWEwF+cEhS8gU1iuIe+5SJWU6rAA+lSCgsOHIRvGH2C0UaUU/kTdNAV7cDJHTce4OHZikjn0b/4FoiDUg0osbPYi1QGwebYmeMAhNrk1OdwOfhT76zo5u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Add helpers to clear the PageAnonExclusive
bit on a batch of nr_pages. Note that __folio_try_share_anon_rmap can
receive nr_pages == HPAGE_PMD_NR from the PMD path, but currently we only
clear the bit on the head page. Retain this behaviour by setting
nr_pages = 1 in case the caller is folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm.h   | 11 +++++++++++
 include/linux/rmap.h | 27 ++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 31e27ff6a35fa..0b77329cf57a4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -243,6 +243,17 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
 	return page - &folio->page;
 }
 
+static __always_inline void folio_clear_pages_anon_exclusive(struct page *page,
+		unsigned long nr_pages)
+{
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		++page;
+	}
+}
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f001..f3b3ee3955afc 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,15 +706,19 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
+	/* We only clear anon-exclusive from head page of PMD folio */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
 	/* device private folios cannot get pinned via GUP. */
 	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
+		folio_clear_pages_anon_exclusive(page, nr_pages);
 		return 0;
 	}
 
@@ -766,7 +770,7 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 
 	if (unlikely(folio_maybe_dma_pinned(folio)))
 		return -EBUSY;
-	ClearPageAnonExclusive(page);
+	folio_clear_pages_anon_exclusive(page, nr_pages);
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
@@ -778,11 +782,12 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -797,11 +802,19 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  *
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
+ *
+ * The caller needs to hold the page table lock.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages, PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.34.1


