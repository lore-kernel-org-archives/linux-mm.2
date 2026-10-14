Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B762ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA5A6B009D; Wed, 14 Oct 2026 14:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1FA6B009E; Wed, 14 Oct 2026 14:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C316B009F; Wed, 14 Oct 2026 14:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1B16B009D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A35D6A0277
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:34 +0000 (UTC)
X-FDA: 85322072388.07.45A308A
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1242C0010
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AzrW607s;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002632;
	b=1ZW71Hh+BplvKlWvGioab/+fBnofFhrivppO8e8cFmnlrLvKzy7YqCdDFbj/6uamMml9hU
	JAln2mvxZCXkowGjoZUv4e/xlc7I3PhJCn6XtptTuPpPr2WWn7er0ESHBeTfzmj4kGWRyT
	FfVhbzd+SmAdvUvSF6r4IF9GnifstUs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AzrW607s;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z7efmS/WkGms6FvbaOcZAe3VwQpzr0tTSUWGVsu8Kk=;
	b=l4INIDa9qJsoKemwObxxtmJz211s9h39L1q/nuGPNKGaHNbMe04uls6A3TKHHY6oqmrvOz
	peWH43qgDzbkfq7DyC3TewZqoDQmykBEgKcO9dAORosrRK+ukohzP7eObBUg1xoKqd0/q2
	eaM6DZrchV4A3AUkskEVXmr8WT1Fc+4=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e55db58cfso72127985a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002632; x=1792607432; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/z7efmS/WkGms6FvbaOcZAe3VwQpzr0tTSUWGVsu8Kk=;
        b=AzrW607s2i9z3h/RJjMCt2PW3os+z3OCSx5vKylHRDL3ZPuorO3VoQ/EAjHvY0SrsI
         wRoVwB/+GUAv5upcgxaXM9Ge43oVfmrYmUNEta+relGDGpiiFlSuwUJqc0egp4ltO9C8
         bUKHfGM5g9mBAJ4RK47i/4pdNIkocBP/VN7CCD9bZRCLhe8rt2l6UvCuq6FUSp/fcuMF
         RIuTo9FuInreBqI/Wwtt4V3MQibC2zJT7p5ZLseKiRxagdNn7UsjpW+tRR8jv8u2DNEQ
         2GY2vLqHuZm9Ni3NobqimnHzAHPhv/cabf/+pj6oUFy1KwdIUsD+sQY9SvcHO91iw37s
         DzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002632; x=1792607432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/z7efmS/WkGms6FvbaOcZAe3VwQpzr0tTSUWGVsu8Kk=;
        b=OCBkyj6N/UbAJU7opWQAae6L4YueT4XHImU1ixFrFAI3RqRhHBVogHYBCQJlET4l15
         M/IQrhuD67C4jHW8j+qAJ2HJlZCRL/s9cm5FlbAmt9hJLTsp4c8udJ7g4iQq/127tXJZ
         ROp9dOtfecxMUYHwzw+LhhBvnPIcx0O6YRxLuE9hhdysgOJaMMJG2QT4QQ2KSI3LO7pp
         yZd7i6dydVc5fbnsdMRwcav/aJtW+yL0aXKetwMaiGOAiRhiFGXufDGzdhMfwK6I+gaD
         Df5xAkevJ+TyqWPLq9XdZjUMdCN1czJiARMmb6oyaSBPrI5RTdszC61SMaXBbPm3f0uW
         2UvA==
X-Gm-Message-State: AFq9FYLMXagzgxlVJCw1IH5jVMu0oOvOpqRlHcC7fXbWvUgs1sPBloCy
	D84PnhbLj1nqIpjBAkpn2k0Eer/vxXiEp5E6kdYGKHL2xULGVSnRMAhdWI4NNh/S5C/P/BqAf9b
	EGBhR9/c=
X-Gm-Gg: AYBFou1Yv3fr6j2AzCZpkEoaHh1VctBxUWYVCxSvQiQe8V2/4EVl0q8QBa03VOzzADT
	nf7F4Kh49vRv4XH+A2nyLb28Ea4F6tn2moOLFY+yVlW7CgiQn1r+PNrLl8t3e0bJP4rLM/gcOai
	mo1dFznWMoZl5ipMxOFJhYmpozR/g/9oTTt2HOS/9/uxORcaOTslpv03YQrudrl5wXUR2d78+T1
	8pESCnxn2Ny6hHt12O1hYOaOKCadUNDEhps6ldqu51A5tvY9QG5o5nJ70LUqkzcSMhUwJmQcIoV
	BeuqjBiyFgqkoOZ4vnUXX2kF0Q6E3xoABhjGSFe4NVrwi5/r7XKqYJEacPEKGaoiEM/DR5q+04P
	Rl+8yjlEgji7SXI8LJeCg/sak6ibpcem7EB0yvQ2myjPrAw1bYNgQJ2sKScWEet1ffPAoEaD2wK
	6s0M/0XKVVytsSKoN6Gl1v9WQfZQ67lDoZ2EVTn+97Hcmy4iRsRFvgwVdPBMa7ZOfcWjJuoQEKv
	Hf5sEHnFBnME3iK3rKM1PT08amK5Z2eO+vDSQDEYjfzn2JN1zcCeNhbILVN
X-Received: by 2002:a05:620a:890d:b0:939:6c9a:8f8d with SMTP id af79cd13be357-93ebd1b7bf1mr2679860385a.28.1792002629963;
        Wed, 14 Oct 2026 11:30:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:29 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 02/10] mm/madvise: factor shared LRU folio handling
Date: Wed, 14 Oct 2026 14:30:16 -0400
Message-ID: <20261014183024.2075709-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qbdt75kdodm5r6oqbcf14ztafbp6yq3o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1242C0010
X-HE-Tag: 1792002632-738530
X-HE-Meta: U2FsdGVkX18MfQKryIybKcjQG6v8Ok+m1CeC+EJ9JO+7KDyTAgIwZg5TEuFHH0JNqWCU5Vw5roANnxtzcSfjbZUsSjDVvUiFV82pcjg+dAEYs8eTkTzOZbUSCeIFZ1Kwi2AgrVR/9xCNAYPe2qfOCM2IkjIj63w3usinOlQqIg9z6WCwsDcxhzQWPqLkO51YuzKXY0NhqUzer+IQkzd+xlDU8daDamRIdkkR6SWBut8VZUmcTZ9kx7224MAgDEoW72h4qiYzCfliKVWvzGNlGenJosN78d8EeX5GINi4Z4Q/giEudbwwS7VoHKkAoLtFPohw6N5MKeMSyfuDnvvSk6+vF+Xw+M8JwaFvLk5oBPHoBvEsM5QziRjMQ9ziKLm0KTUg5EH7WN/vxHAESq43VuUkoWuauwLF1ZMXB/vRNmGMUlYE3WquphXhQQi0LkpA6U4N2HxkxQQGn5pyRcaB90Rs62xqNehw8O8eC0H0+l3fXna80KMOs+dXpn/6pZ+n4KEQc4kxRIMnoqKk3JRftQ6qhzMEfkyt6EnbqSyZLVG0BWTm1rl0Y4K3qFHqTjxT3lj84QenxuWuFTC84VPVFtpgtVDOq6ncs8clYrC8YiENbRUGhKGF4TYAulGfAxq+YS0xjXI7qHxUXsiTFLQBAELUpLDTOFkcJcPliO/iuX+Bn54uwIFGxlrtA5dSI9VfqJfrpMV/fdxVvU6Lk8g7YnQPcM02XcqHxWiIE0Ax6f7BncgnYo5G0w3Fvp90d5xtVgzJYXb+U9LU8MTmQp1I22gAxN4fFvDhcpIfJSKvALsZqqpMQkSYHqXmkoty5WZAVKygLa8aIdshqGriEWh//WA6LvMgX2amWYGkmPVOLXwa/mF/fyjYMJRr6w+iBUJyt32myMbKGWn4jjc1DJHLvAthvLYJRsNHVEiGdBAIMw5JJhI3+0TXBmshafhCTgCJfJOXBwBBzJxgJhBHBDA
 EyIF/Pts
 ueMt9JxLAzVd0Dab1spRT/1Vo1awXIeHkVfED7VnU2fISnhPUN3h+SzXwDOyeWUowJ5fVxcAsMedOwDjaSXoLcuQDpH5JXYoC68R8aeV6KCaQrkgitmvYjokIG16Q0l5JQRg2Qxe9ZCFQxm8YZbKB9FL7MRkgW3s0eLvLn24kkUG4pY3SWTsZ25Ekq1K1sJZ7Q14hr7ETjwQ3MyJyxrJmf81QKJI+ksEPMRdHXu7FlwHQZzLAY9YkywANGsEcXlyO2fr0PYIZyGDecEyY0hJpU8PuVSUijkBk/pePsNokStakMJ4JnRRTbaB24ocs5stGqvyLyKzeU5LLj98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge-PMD and PTE paths duplicate folio filtering, reference clearing,
deactivation and pageout isolation. Keeping both copies synchronized
obscures the page-table-specific control flow.

Factor the common filtering and LRU operation into helpers. Keep the
lock-before-reference sequence visible at each split site because an early
reference can prevent split_folio() from succeeding.

Also rename pageout_anon_only_filter to pageout_anon_only to match the
helper's parameter, and drop redundant parentheses from the file pageout
check in madvise_pageout().

No functional change intended.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 94 ++++++++++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index f15cac3faf61..b0ce4ececba0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -360,6 +360,43 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_lru_folio(struct folio *folio, bool pageout,
+		struct list_head *folio_list)
+{
+	/*
+	 * Reclaim keeps a recently referenced folio, so clear its references
+	 * before deactivating or reclaiming it. As a side effect, idle page
+	 * tracking misses those accesses.
+	 */
+	folio_clear_referenced(folio);
+	folio_test_clear_young(folio);
+	if (folio_test_active(folio))
+		folio_set_workingset(folio);
+
+	if (!pageout) {
+		folio_deactivate(folio);
+		return;
+	}
+
+	if (!folio_isolate_lru(folio))
+		return;
+	if (folio_test_unevictable(folio))
+		folio_putback_lru(folio);
+	else
+		list_add(&folio->lru, folio_list);
+}
+
+/*
+ * Do not interfere with other mappings of the folio, and skip file folios
+ * when only anonymous folios may be paged out.
+ */
+static bool madvise_lru_folio_is_filtered(struct folio *folio,
+		bool pageout_anon_only)
+{
+	return folio_maybe_mapped_shared(folio) ||
+	       (pageout_anon_only && !folio_test_anon(folio));
+}
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -372,15 +409,14 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
-	bool pageout_anon_only_filter;
 	unsigned int batch_count = 0;
+	bool pageout_anon_only;
 	int nr;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
-
-	pageout_anon_only_filter = pageout && !vma_is_anonymous(vma) &&
-					!can_do_file_pageout(vma);
+	pageout_anon_only = pageout && !vma_is_anonymous(vma) &&
+			    !can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(*pmd)) {
@@ -406,11 +442,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
 
-		/* Do not interfere with other mappings of this folio */
-		if (folio_maybe_mapped_shared(folio))
-			goto huge_unlock;
-
-		if (pageout_anon_only_filter && !folio_test_anon(folio))
+		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
 			goto huge_unlock;
 
 		if (next - addr != HPAGE_PMD_SIZE) {
@@ -433,19 +465,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
-		if (pageout) {
-			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
-					folio_putback_lru(folio);
-				else
-					list_add(&folio->lru, &folio_list);
-			}
-		} else
-			folio_deactivate(folio);
+		madvise_lru_folio(folio, pageout, &folio_list);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
@@ -499,9 +519,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			if (nr < folio_nr_pages(folio)) {
 				int err;
 
-				if (folio_maybe_mapped_shared(folio))
-					continue;
-				if (pageout_anon_only_filter && !folio_test_anon(folio))
+				if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
 					continue;
 				if (!folio_trylock(folio))
 					continue;
@@ -534,7 +552,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		    folio_mapcount(folio) != folio_nr_pages(folio))
 			continue;
 
-		if (pageout_anon_only_filter && !folio_test_anon(folio))
+		if (pageout_anon_only && !folio_test_anon(folio))
 			continue;
 
 		if (!pageout && pte_young(ptent)) {
@@ -543,25 +561,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			tlb_remove_tlb_entries(tlb, pte, nr, addr);
 		}
 
-		/*
-		 * We are deactivating a folio for accelerating reclaiming.
-		 * VM couldn't reclaim the folio unless we clear PG_young.
-		 * As a side effect, it makes confuse idle-page tracking
-		 * because they will miss recent referenced history.
-		 */
-		folio_clear_referenced(folio);
-		folio_test_clear_young(folio);
-		if (folio_test_active(folio))
-			folio_set_workingset(folio);
-		if (pageout) {
-			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
-					folio_putback_lru(folio);
-				else
-					list_add(&folio->lru, &folio_list);
-			}
-		} else
-			folio_deactivate(folio);
+		madvise_lru_folio(folio, pageout, &folio_list);
 	}
 
 out:
@@ -648,8 +648,8 @@ static long madvise_pageout(struct madvise_behavior *madv_behavior)
 	 * owner nor write capable of the file. We allow private file mappings
 	 * further to pageout dirty anon pages.
 	 */
-	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
-				(vma->vm_flags & VM_MAYSHARE)))
+	if (!vma_is_anonymous(vma) && !can_do_file_pageout(vma) &&
+	    (vma->vm_flags & VM_MAYSHARE))
 		return 0;
 
 	lru_add_drain();
-- 
2.56.0


