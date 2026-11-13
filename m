Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AA9606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vHzNBiDo
Received: by kanga.kvack.org (Postfix)
	id C5CE36B0617; Fri, 13 Nov 2026 03:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C349D6B0618; Fri, 13 Nov 2026 03:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B719B6B061A; Fri, 13 Nov 2026 03:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9BF6B0617
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:50:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07B1EA7FE2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:38 +0000 (UTC)
X-FDA: 85429474956.17.5279AE5
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf13.hostedemail.com (Postfix) with ESMTP id E262520003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:50:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHzNBiDo;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eav5kyje92g21GwxFUl8GjTnmUnP4vZtJeShxpAtoVs=;
	b=biDHM2o1bK0FUeIGldy/XpR+ng2ugvq0rimYN6W8RCHpcyZAXh8A2MOKfSSjqJB6+mhowF
	G6pL0TSwsnWEKuo9DHJv5rAYrJ+9MoXjYENs2kGpPYlKiOuMV0UbANF8uvMJBl7L28kYH1
	EaW/E5qIbyYh7uW3AFAMFiwZjP7v51c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHzNBiDo;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559836;
	b=HkWWmJoLWLa6VhP1BLLs1OpU82+/Vvv1PDw+Shy5u8/JLUFjTe83UI1vvEB3hkRfGu8gje
	QFvtuTADOdwuEnXZ0BHsrRfLHPNY7/+2RADHPVztXM7UsNN+xxEG1zZgi+yM7uM74I85zr
	fxzXykOH9dYyMaGfmZK0GI6yQISrCKQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1JILv/z6o3UPLx3z9/o5/EHXKasu4GhmRsDkH9/WOUY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794559833; v=1; x=1795164633;
 b=vHzNBiDoO5ykIr5uGoyaYRw1Op5S+6EgROpNzJ5d5T4c4b6B629EKSWIv6w3lvW2TE9StH7s
 U9BHJ3FD/wPP1r6osrFB5WzKKOMdLlknq1Cm8oVighhjv71pLdBRc5M0zsJas1mrZ/a9aLPlLQF
 2AjL3fTT4uik/WM/cyDnWTLc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 435f3ebaac992ddd;
	Fri, 13 Nov 2026 08:50:33 +0000
X-Mizu-Trace-ID: 435f3ebaac992ddd
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>,
	Kairui Song <ryncsn@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 3/4] mm/mglru: skip cold PUD subtrees during aging
Date: Fri, 13 Nov 2026 16:49:52 +0800
Message-ID: <20261113084953.412919-4-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261113084953.412919-1-baoquan.he@linux.dev>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bjagm7xojo5qtcqqimn5386h3oyyokxm
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E262520003
X-HE-Tag: 1794559835-332129
X-HE-Meta: U2FsdGVkX19Xc9tE6JGX/DnaGYa2pJgAhjuyq34GyB7bwoWwrlg7G3vPnc/Q/5vKAgsP+67FCSMF1MB4YxtEBWzrfL9/VJX6ZW8XmrWJh94ERuSIrw4S/N8/2j3BAsWxrp8WtJ9nwBDapJ/hALdjFOCU9pP2M1HWyfR/SyTpVLYNwWaOFXH2yi80pBZ/Pa0oV+n8BsbYwAolGr4pIz3B95lPnqHDCpDqhRu/sExE40Y6V30t/xZy5meeJM88179Mn/L0Gfa1p+McLhPWnwDDzx2E5lm4sdi+x+vFKCDGXUcr/yyYrFQxdIahV2n6Vs1N6gpCaDUzd29eOa/WyCSmHWmppaEra/Y5K40PgkNjPuB1krcltdhiuksqzgoSoAXsdFH+YOdx1HI59ZCwxNltlXHJ1gYTiRYE1OnQFFvjnOqkRM+qoLOl6TLj6wtrz0N7xAXILy1UHP7P2TlXkRTgULZdQxcVNA3dDdeDU48cQzG4VGMtAKdLJx9ANBlWNKzsstf0AW7qUjywXE1afifi+XdaShsPQLhKs7w5UHHMRbbrGJPy3ZAfQxce2yQO0Y4MjFvQP7xQ1Ar0Hdks73YbWAzJu2Ie4hHRoTNhW0Iw7RiOYKynX7fPf67d1rnwD/FJenJ56hWTj4Qk607K2XfnFgZdEXsc4SWnV7WZGhw3jbEBs/nKME/sx6YPm1M4ya6kSVCOPuEL8rvCS0HIGZa3YokTuHP89EWVr5LCbC4zViGvEZ1rwHwddNonqXki5DAGtOPdiWZfzFJGsTnv42vBQEDL8i83MKN7kKoGVrKFZCUiFx5+n3cykti8UwjklFAOOrj79dVNBsyqAKI3lS2q8ZprKQ3l/WEFtRbcl/X5HDnsdKrVzR4mm/q0Ddwoi/BvUXmxfIpl7raAkzkPKnNMCVjBAbyRH6SyNThANPxyuwkA9bhcr9PLsZCgQxws5v/QGWBWJLrkYdiw2m9nn6F
 QUpO8Guv
 APf/6x+z8tQuT7aOLW18w+GtmLfbwQdXYuGr/c23AtVyKPFZJFJQkq5XdGDWXYnl0Oj3PSsvjJTaywMJ59oNRWT9JzREAcA+Gt8Y/Wjx70OxzMf2y0vuMhpEX2rhXjokD5tsnJwLm6KvbEVB4/KIg10L14ePjPT9dgcxTnP+3q3uBUVhc4kLkpHsJ96pwR58wLc61Y8nA5R9sbdxCcM4H92VwFKPH9X+SjTH4RW/JQCntu0+s2koPYMZnhrYaWSKztfcC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

The aging walks into every PUD and runs the PMD-level Bloom filter on
each PMD. Add a coarser PUD-level filter one level up:

 - walk_pmd_range() reports whether the subtree held anything young for
   this lruvec. That is the same condition which already carries a PMD
   over into the next generation: a young PMD entry, a huge page owned by
   this lruvec, or PTEs with enough young ones to pass suitable_to_scan().
 - walk_pud_range() records that in the PUD filter, and
 - on subsequent generations, skips the whole PUD subtree when the filter
   says it had nothing young last generation.

Use (mm, PUD-aligned address) as the filter key rather than the PUD page
table pointer. It is a stable identity for the range being walked, is
available without walking the page tables in lru_gen_look_around(), and
does not depend on the lifetime of a page table page.

The double-buffered filter flips with each new iteration, so newly hot or
migrated-in pages are re-checked promptly rather than suppressed
indefinitely. force_scan walks bypass the PUD test, so manual aging and
newly added mms always rescan and re-populate the filter.

To keep hot regions marked, also report the covering PUD from the rmap
feedback path (lru_gen_look_around()), so regions whose hotness is only
observed by eviction will be re-scanned.

Suggested-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9dbb3f477d7d..d12934f2fbb3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3133,8 +3133,10 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	spin_unlock(&mm_list->lock);
 
-	if (mm && first)
+	if (mm && first) {
 		reset_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1);
+		reset_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1);
+	}
 
 	if (*iter)
 		mmdrop(*iter);
@@ -3738,10 +3740,11 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	*first = -1;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static bool walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
+	bool young = false;
 	pmd_t *pmd;
 	unsigned long next;
 	unsigned long addr;
@@ -3778,8 +3781,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
-			if (pfn != -1)
+			if (pfn != -1) {
 				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				young = true;
+			}
 			continue;
 		}
 
@@ -3789,6 +3794,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 				continue;
 
 			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			young = true;
 		}
 
 		if (!walk->force_scan &&
@@ -3801,6 +3807,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
+		young = true;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, walk->seq + 1, pmd + i);
@@ -3810,6 +3817,8 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return young;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
@@ -3820,6 +3829,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	unsigned long addr;
 	unsigned long next;
 	struct lru_gen_mm_walk *walk = args->private;
+	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
 
 	VM_WARN_ON_ONCE(p4d_leaf(*p4d));
 
@@ -3827,13 +3837,29 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 restart:
 	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
 		pud_t val = pudp_get(pud + i);
+		void *pud_key;
 
 		next = pud_addr_end(addr, end);
 
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(pud + i, addr, next, args);
+		/*
+		 * Use (mm, PUD-aligned address) as the filter key instead of
+		 * the page table pointer. It is stable across the aging walk
+		 * and the rmap feedback path, and avoids walking the page
+		 * tables in lru_gen_look_around().
+		 */
+		pud_key = (void *)((unsigned long)args->mm ^ (addr & PUD_MASK));
+
+		/* Skip a subtree that had nothing young for this lruvec last gen */
+		if (!walk->force_scan &&
+		    !test_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq, pud_key))
+			continue;
+
+		if (walk_pmd_range(pud + i, addr, next, args))
+			update_bloom_filter(mm_state, BLOOM_FILTER_PUD, walk->seq + 1,
+					    pud_key);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -4437,9 +4463,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, BLOOM_FILTER_PMD,
-				    READ_ONCE(lruvec->lrugen.max_seq), pvmw->pmd);
+	if (mm_state && suitable_to_scan(i, young)) {
+		unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
+		void *pud_key = (void *)((unsigned long)vma->vm_mm ^
+					 (pvmw->address & PUD_MASK));
+
+		update_bloom_filter(mm_state, BLOOM_FILTER_PMD, max_seq, pvmw->pmd);
+		update_bloom_filter(mm_state, BLOOM_FILTER_PUD, max_seq, pud_key);
+	}
 
 	mem_cgroup_put(memcg);
 
-- 
2.52.0


