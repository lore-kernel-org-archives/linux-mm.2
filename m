Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A29FC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714806B00B3; Mon, 20 Jul 2026 07:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EA26B00B5; Mon, 20 Jul 2026 07:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58D266B00B6; Mon, 20 Jul 2026 07:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8C76B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:12:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8011C160133
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:19 +0000 (UTC)
X-FDA: 85008891198.26.C2FC30E
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf13.hostedemail.com (Postfix) with ESMTP id AC6F820007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:12:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TA0Lm8FR;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bszNFZM6om9ILDWnNHRZxsFQwjm6KW0clbRXih7h2aE=;
	b=NK9XlFiWx2MR+dk0+xG36iNTwRVv+hBs0JQdmXWP7yhd51r+frvx+F4NIzlvRH9OGqz41p
	Mjw9Zb0pcWUXBbdYOda2Ie9XR3ke92bAJ8YQXVZMQ8rFbu6a5gV4BMOXHiBssiYVfk++Et
	FZfX4PpaIz6jxPBYk7qiy6nCFNzzRFI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545937;
	b=JEa8tngIZC/acFDgYjJ6cW0p2lmgWRkU5PzF/WNQ6otcJbW92eyvtHKluxuZFVAO8pTik8
	aORgVaOPf12rz5DnUgp4RcJf+oaI37vN95NXMkfS0aBbxyaRCfMoYFOyGGshEe3nLMdUvx
	YCks7VsCQa4lUJOhK1+E80Q1GNQ5plk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TA0Lm8FR;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784545933; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=bszNFZM6om9ILDWnNHRZxsFQwjm6KW0clbRXih7h2aE=;
	b=TA0Lm8FREzu/7PX1Av0X+GYQJCyBiG5lUCgqLCBW4BAaq83b68POCUO71zlSLbbxtp3H1pfrOT2RVAF1J6KdAh7iIk0ag6+4DFyzZzSW/s+UNCWowwNbqbA0LefaV26TUeDEQSNktH/wefzqq3w+UG9Dt+Xomw89Z4EplreswGc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7TBAGP_1784545931;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7TBAGP_1784545931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Jul 2026 19:12:12 +0800
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
Subject: [PATCH v4 3/3] mm: mglru: promote mapped executable folios after first usage
Date: Mon, 20 Jul 2026 19:12:02 +0800
Message-ID: <f57d94b1d85bb3d620d89bb739128f0d929bf9c6.1784509721.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hx8ogngbcjui9g87pjdzzbitrmrpqkkp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC6F820007
X-HE-Tag: 1784545935-371703
X-HE-Meta: U2FsdGVkX19eeTHdkibY2V4LC9Lh6UBr+o50elWkCzVOV9vJc3Mpr5oASelBdQlio6tTWgM1FhjAvm/mInuELbihGUc5AGqC+eAdPDeE04k78LibgbeCVyRClIAkjl8ihbQQjuOPcg73LOOlwA6dAS375+yGaxW4MMZnXQ3XFx8+P9DLWy/Su6nlJ8lqmby4Dg9tuBgYOAW/eiftyP3oXVHH3hqoD14eAiVI+8YEXjo60AylgIgWEj5QrrziVNcu7WK09loMnvAdG+M7BrzjvOm8CXt7sb5a9odGJLPyh3k3m0nOvO9bw+3Czd0TX6vyZGISktUjVzy2rls6rOZqDx564pJioCE0xPzcMyDh5EqRnqHl1vHfB9j2KSPfhaEsZXSacWQXu5iG6ARaAVGdlQeuOdVtzz/h40aUZ92smWb+y3L7TAdvYZ9CuCKxz/49amfhRYkEztw8pVZI/QNpYYaMi5pIHlrLrrVmdPgyTX30zJ79y/duJD+O7s9Mex5Wszj+DtS0X1gCJgsEV/FQ+mpurQv/qCAuT0OxVFhnmz6qT4DeyCBek7aZsYdYZI5DFY/C23nrRSTadSajF0gC0ECPL8taNAmdH4+6T2+YJsfond3FAF++y8Vd+q/z8gs3leJkjHhV3UfUtt0ZOKCLRrFz4IuVbkaD2DzrgKWJvrPsrU89TD3TBwaTEzIG9EdOdzsTfrFonqvaLaTTWB1QixkVYguBg6SbRQn6StKC6Ho5fWdFfRNXOfAcBfPuStuhre2RIY7dwJnqUGFqSwhUoMuaej6Mc9ocAokb5xC2LTrWAreO/RNkyHZ6QJT7VgRrPZnar9bOUCLey46J3zyZoxfNEz8kdNny7efw6d25mM+DiNNRtmopzJowVinb07nifNoXS6l7wAotpV9MWZubx0jzpYQyZKe+AtKd9pOgrFXIz0F+w4k7YXTLts+fVxPit5lgi75c2JJ5fmyr9oO
 UFYTZsPb
 umb48SnOZTRqTvnQsIjcUauO2gaEtEU9O0ISvGKdrIv40tqASTfF87FVOxYrMuJlJyCXFz/g/63hG/ooAjbEUFcewsHop16yeF1YzOo5KaIBMzcXAHWygcBmLwUJaU+C8vUg3QiWEW+4C4FLqvS0T5O13wxjtgEBCK+GGtIFFVyu9I1fGpA5P4bfffjh5w4RWrhTErIIU3IafPvUL+XvZCVDJF7N43MpM9ZkjvnBVvJUBV087Vr52IS2ikNkPL1jkiZffQQ4paqlw0v52A8bd+R0M6JIzTqZNnYT4qAXFe8CroJxyiX8sgVkfGTsWfdeIwcy8W0QC6+RcNblf2EfY9Ol0dg==
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8f0c31a4848e..b1ec65fb8947 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -841,10 +841,16 @@ enum folio_references {
  * with PG_active set. In contrast, the aging (page table walk) path uses
  * folio_update_gen().
  */
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	/* see the comment on LRU_REFS_FLAGS */
 	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+		/* Activate file-backed executable folios after first usage. */
+		if (is_exec_file_folio(folio, vma_flags)) {
+			set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+			return true;
+		}
+
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return false;
 	}
@@ -857,7 +863,7 @@ static bool lru_gen_set_refs(struct folio *folio)
 	return true;
 }
 #else
-static bool lru_gen_set_refs(struct folio *folio)
+static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 {
 	return false;
 }
@@ -892,7 +898,7 @@ static enum folio_references folio_check_references(struct folio *folio,
 		if (!referenced_ptes)
 			return FOLIOREF_RECLAIM;
 
-		return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
+		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
 	}
 
 	referenced_folio = folio_test_clear_referenced(folio);
@@ -3192,14 +3198,19 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int gen)
+static int folio_update_gen(struct folio *folio, int gen, const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
 
-	/* see the comment on LRU_REFS_FLAGS */
-	if (!folio_test_referenced(folio) && !folio_test_workingset(folio)) {
+	/*
+	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
+	 * executable folios after first usage to avoid typical IO
+	 * thrashing from reclaiming.
+	 */
+	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
+	    !is_exec_file_folio(folio, vma_flags)) {
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
 		return -1;
 	}
@@ -3432,8 +3443,8 @@ static bool suitable_to_scan(int total, int young)
 	return young * n >= total;
 }
 
-static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int new_gen, bool dirty)
+static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
+		struct folio *folio, int new_gen, bool dirty)
 {
 	int old_gen;
 
@@ -3446,10 +3457,10 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
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
@@ -3522,7 +3533,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, args->vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3535,7 +3546,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, args->vma, last, gen, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3613,7 +3624,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3627,7 +3638,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4262,7 +4273,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, last, gen, dirty);
+			walk_update_folio(walk, vma, last, gen, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4274,7 +4285,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, last, gen, dirty);
+	walk_update_folio(walk, vma, last, gen, dirty);
 
 	lazy_mmu_mode_disable();
 
-- 
2.47.3


