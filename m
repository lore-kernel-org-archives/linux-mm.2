Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C874EC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FF56B013E; Thu, 16 Jul 2026 11:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9956B0143; Thu, 16 Jul 2026 11:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD196B013E; Thu, 16 Jul 2026 11:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 159B96B013E
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:32:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E34D5120118
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:38 +0000 (UTC)
X-FDA: 84994311276.12.9C08642
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6B0CA000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j51R/kiM";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784198797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8dvsppUCclol6edmZSY/pkLFvmywa1k8Hyk3xrw9tY=;
	b=R7byqAHVq38H7ELgoIyxeBDq2QC2iTNS0TR+1Vc/ubB5dBhPwHd+NQQpfxZYKtPG/MoyGm
	mQJQXngXpd6j494Gh5Of6F3CojzEW+IrgNCY4Ow7Ww/t2mB0bMu5FVDqYOcIfqWQAx1j2d
	+HxQloQ5vvPHMcHbi01e7Q53cqsaq8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="j51R/kiM";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784198797;
	b=idJZhTCyjCFQBPM1MjoJIojwBZSuEm2tJe009DCfKNpiszDOfjjoVyuqBawdXTppvUMdVa
	9J0iU/pgeDfworq+FaZVleGUZcJKx/8/YmgXE2MgoAwb3TGIDIlz33320g53FMU7tQiY+0
	AJv/9/FUQMFym/rfjps0Urdrwa3/avA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784198791; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Y8dvsppUCclol6edmZSY/pkLFvmywa1k8Hyk3xrw9tY=;
	b=j51R/kiMoovbkMwu6kO7e6jHxV/WembdYi8x7HfJoGZ3CPaGOpcN1XWXV6cQ6HzEfob+FBCoSZfmN1wi2CcV44JJ8LiJT4F4rMxvc24hjgUEItJXJ1WCCJLj3+0Hd/snw62LrOGoudLYUIVBjtyUMZ6GubGvzAsIknk+frNU4hQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7E4pTJ_1784198790;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7E4pTJ_1784198790 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 18:46:30 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm: mglru: promote mapped executable folios after first usage
Date: Thu, 16 Jul 2026 18:46:19 +0800
Message-ID: <7e3a5f6bdf70e0237027025f4593a3874d411f65.1784197559.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
References: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6B0CA000D
X-Stat-Signature: yw4wdeguqi1rnhdtfiuufg51198yuudw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784198794-236729
X-HE-Meta: U2FsdGVkX1/2/Sb5D7/ChkvALlUosts/qp1LdZID1SAeAmGHy5EsuatG/Cfq9Zd7fmWNSc2lM7j8fIwl7ZvuHqQ7doVcVmXml3zulWJZJaOHUpnbixwNOLCE6R/bYHdB9h66vKKQI7miQr6wSB5WxmahvjCKUDsQ0E6esVEFdO6lrOFi2kWsbto15uhdVoBa1ZqDydcxgNyZ5oCwkI5LtFtZQZt07wkIF7lJ8cmqflVAzbk9mj6Ag3YowluTSNEuaCAidOdyDQYggHDYLMNinmnUsgHkTH9NPtmPG+I5BSboglvMNHBQf7TFCh+AHRFv3grRjYJ/QS/quXlbEwKr2EUUdtH29pVzvc4/AO5kJVhni4EEuokEPmRY2pGLSQepF9R/gi0yH/GlnhSvfHXEnGLSkJsJqla4dm7S3T9EHxek9bLTx09ccKFGGmWJ38SkgxGMvE2f5X7d7dBj6NQFWuy+xO9XprtYYDdcEO8tZ/CIk1smsuGyMv8HQw7zy7GjSlBlKOEpyMqNOZ4VPgaN/Tp7o2Lal84h31VOa2rCh7UFzJwkFiVggLz4+vDNbp1pXWC1M0SuVVALRLISVzR11WHDIDAjyuqoxbt4cKLaDo64qeQJ+PiFZelow62/u4cOaS4sVlfg6LABHV8FwcAOYzwr0bOolLS6oENmhL7gxg2nW6PQcZg9+HBELY8jRH1PahBMBsgde8VwbYUAuZQuxsvRp+3nIktpMnA3szhCMvcbjAUtvjPDuAnXIYow6UBrwW867G7xvw96H69RAVC3a+k07cd3NbZY61SiGRvqtTWt/uGFiCQq84O0+m8Fkjy4V2BJb/CN/FcgYy11vlMpsXxtKApZMwAB/yUD6iOcYtDJ/lM3A5Q3pkeqZ53RQGfN8eOj2XZFfb7RzL1t+TpNldShxY1Yye97bkulqaC6l/QMfZvsZ+RvFlyog9zRgTo2HkVFvsHg7BQshkdb0S9
 wijCtP2g
 AL6h5eSCdzv196AXynfA/OFJs1YTQ7pu424seD2liwzq3xKRDOATqANzRNF6sJRgKgfcUYuX0GgAYb8RiDWYpl/Fb3KSKBr3GdLf4ZxaAOnVzBDTEiBB+yGHXZ1ESMcm6Yqa6GjzR+OsntOLC0L/KOgJaQRbpivm/xQ/c9G7RZoYbLEfuDYsjh2YtctydgVQJbnhFQne8mwUNO5PHnMb2IFcjFiIjUZcWaTSWQiq/089EWsKX7PZVEpTsdqWQf2KIQqIN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Classical LRU protects mapped executable file folios through commit
8cab4754d24a0 ("vmscan: make mapped executable pages the first class
citizen") and commit c909e99364c8 ("vmscan: activate executable pages
after first usage"), giving executable code a better chance to stay in
memory, avoiding IO thrashing and improving workload performance.

However, MGLRU's protection of mapped executable file folios is less
reliable. Although shrink_folio_list() checks references, the access flag
of mapped executable file folios may have already been checked and
cleared by lru_gen_look_around() or walk_mm(). Additionally,
folio_update_gen() or lru_gen_set_refs() only sets the 'PG_referenced'
flag for mapped executable file folios, which causes shrink_folio_list()
to ignore the first usage of these mapped executable file folios and
reclaim them easily.

Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage in folio_update_gen() and lru_gen_set_refs(),
giving executable code a better chance to stay in memory.

On my 32-core Arm machine, with the memcg limit set to 2G, running
'make -j32' to build kernel showed some improvement in sys time.

base			patched
9248.543s		7861.579s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mm_inline.h |  6 ++++++
 mm/vmscan.c               | 41 ++++++++++++++++++++++++---------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b5c4dc0f3fe3..30fdf1056312 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -30,6 +30,12 @@ static inline int folio_is_file_lru(const struct folio *folio)
 	return !folio_test_swapbacked(folio);
 }
 
+static inline bool folio_is_exec_file(const struct folio *folio,
+		const vma_flags_t *vma_flags)
+{
+	return vma_flags_test(vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio);
+}
+
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index de62899c108d..fa808721b64d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -835,11 +835,15 @@ enum folio_references {
  * with PG_active set. In contrast, the aging (page table walk) path uses
  * folio_update_gen().
  */
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
+		/* Activate file-backed executable folios after first usage. */
+		if (folio_is_exec_file(folio, vma_flags))
+			return true;
+
 		return false;
 	}
 
@@ -851,7 +855,7 @@ static bool lru_gen_set_refs(struct folio *folio)
 	return true;
 }
 #else
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	return false;
 }
@@ -886,7 +890,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
-		return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
+		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
 	referenced_folio = folio_test_clear_referenced(folio);
@@ -914,7 +918,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		/*
 		 * Activate file-backed executable folios after first usage.
 		 */
-		if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio))
+		if (folio_is_exec_file(folio, &vma_flags))
 			return FOLIOREF_ACTIVATE;
 
 		return FOLIOREF_KEEP;
@@ -2119,7 +2123,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if (vma_flags_test(&vma_flags, VMA_EXEC_BIT) && folio_is_file_lru(folio)) {
+			if (folio_is_exec_file(folio, &vma_flags)) {
 				nr_rotated += folio_nr_pages(folio);
 				list_add(&folio->lru, &l_active);
 				continue;
@@ -3188,7 +3192,7 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen)
+static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
@@ -3196,10 +3200,15 @@ static int folio_update_gen(struct folio *folio, int gen)
 
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+		/* Activate file-backed executable folios after first usage. */
+		if (folio_is_exec_file(folio, vma_flags))
+			goto promote;
+
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return -1;
 	}
 
+promote:
 	do {
 		/* lru_gen_del_folio() has isolated this page? */
 		if (!(old_flags & LRU_GEN_MASK))
@@ -3428,8 +3437,8 @@ static bool suitable_to_scan(int total, int young)
 	return young * n >= total;
 }
 
-static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int new_gen, bool dirty)
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
+		struct folio *folio, int new_gen, bool dirty)
 {
 	int old_gen;
 
@@ -3442,10 +3451,10 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen);
+		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
 			update_batch_size(walk, folio, old_gen, new_gen);
-	} else if (lru_gen_set_refs(folio)) {
+	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)
 			folio_activate(folio);
@@ -3518,7 +3527,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, args->vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3531,7 +3540,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, args->vma, last, gen, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3609,7 +3618,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3623,7 +3632,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4258,7 +4267,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4270,7 +4279,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 
-- 
2.47.3


