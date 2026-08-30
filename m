Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FD1C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C92B6B0098; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0896B0096; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD316B009B; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD1836B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61D0DC0325
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:43 +0000 (UTC)
X-FDA: 85158809526.07.481D620
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67D28A0006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhhKTrs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115421;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwDXCSABjsTL7Aa7UxIBX6J6N5yJJ8RLBeVYDMqGGwQ=;
	b=jynmMd7S3hwta0+0xu1KyjL4pAS3lhlH1i8oPmFkLa39bVgfmmZcb6o9CQjBjsuBoNApxK
	1VrUbvSy3SYEf9bs7T9p2DSXyE7gTQAPkaRPBKKFT0/jQGhze5PiMdW+g+1NiSwYxN5qOe
	KUvHVYy9vFCGhI8j97ibNZURx9cc2uY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mhhKTrs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115421;
	b=cW6A2L8NQwGK8uFGRGp2vgsyQMdyu9CSwF3orLGoy7Ojp9B4plXl7q4F1nmlC5eVs3nHUt
	09nb749dJhRzcF9LZEBPNVcHxuhZlD9SAXj/amIPizcWj3z8G59zDssw0HkIdibaDh9E2w
	bt8uF8/rmejnlwXJwmP9WA5X30kmfDs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 479D243B3B;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 276FEC2BD01;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115418;
	bh=spyvUXst4fUCAIZ0m+QJ4vENQfhFkGWKQfmvYUD3ZzQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mhhKTrs3i+PPC9sd4Kcn6L8dCzynom7LL6TgEvgJqpMoYE9yHSLfpXPiV3e6ph8HH
	 qRz50dDocsS2n0L4zMtbmBLeamqr4RcSZCoGwg0bYkjLETcyaYjZ31kXX7L6dnUM5w
	 gXOe7Sx5PnoCWu5+DtUF+3TNtKR2eu2x6t5kyPgKUqTWVposz3NKWWCuTbcmRxxY09
	 jrEJS86hmCFhZai4uMaLiz58F0bsy0c9CI70bCM+xKN77vCkCZIKFR+bKGNEiXu8f2
	 IAr788FjVTtHHC394YAJXaUjb6s9lzb9LNYA/WLR6sxUYNNy0YqTNItbQVHKAtaPSJ
	 2ByEtKCNOMlQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E70C61DB9;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:36 +0800
Subject: [PATCH v4 6/6] mm/mglru: fix potential generation folio number
 leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-6-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=5305;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Z2J6CC3Ye9renPiwGZhbUdZHuoUS/IyRTK+jViwM/8c=;
 b=z+rZLYptLZpoPbh9exaTA303vLangU8/qr4wFS5iTEHnCVR9t9TxpRlGMDO/sY2UI6BoAE/88
 Kr/Z1J5HZyTB/ek9655augLaRbqwYrilnoLKRiOj9xE7eilBE5I/EmA
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: jjijonjm9om3wxkdpdmjxdy9yrjbszr7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67D28A0006
X-Rspam-User: 
X-HE-Tag: 1788115421-544873
X-HE-Meta: U2FsdGVkX1+RGiItVSQgsoQzwtL4MLOEOG3SWU6F4PqbMbI18U+2HHg3mcyTKMC8NQZTUcV+gm7aU7/cGsDAUNeZvY31d33GUA9UzQVQzXsxsCE3BxjMVib7fC+4UWlMt/z4y0te8h8ZFUsFSxrE/GBvBCXleL+RBymav09Lh76DaJrYLb50LhUWUb+qFhJYKNYVuSNqepQ2kn3YCQALQndgpAOQ8eaEZxb+8kNDBe839X1lSaNwrTwf+QfsAmP17BrJ2UaUAjqhsA8oie6pJnV2euVb2byftDT1Ly4kya6AfQENaRuAnNntZw/x0Nj/tZ81RWuoQ7Ewof8/VeCetbwPTprjzRxN9eRvcMpG8y2+9cMjuop4K3GGnHZzE9ZW44TDRRbvWI5IWjRHX6t2YqkuZt2+AE2EhC4sESP4z74KwrE7cln1U+d7KrEax4nlqMJhWzhW1lFvJhUJ2KHptt27c6wvlUEOSG2J6UAo98fFkyNUp0tZ7TVzl0eTnG4s/iZ3g5l0APiEON1co5tG43RxYOWfBCyo5vhaDZpqRd20f01/YlKKO3qrZy2dRK5fFQMnutgIgl8qQm5ubdrVJBw47nu8jdkSN4OmKJZztdF7JaQfnBkQoOWFZeNuWszkqw5K27pSJOzBZ4cgm3Fv8723QCuxPzmtn3dKxa5oDdUJcjMyDtTBHgvrMAVd6XTvUZrySDE2dvGhjeReORX2/E2JNnSKh2IrvNQCN4tw//tlm4vyX1dEn6enwc+dhEe5mt2+GNjdwMzp9A46mGow2dqXEDcuJXpUqCKGDQmSC7Ujo6qbyF6ow2x371iLVQ8VAhVQ5CujWo+J3BR9UbG1KQ0aitFEnH7xjvIsytTFgwqsH6ni/z9ABpZnF5R7nWn4BDuGjwwOoV8PIE4qRDpFeCMi7lsHZWCP2MdcvMYUQGKCBejQYXPzfAqKdyhVohHIbhvmJtGeuuIFhy8h689
 AvaoFVYc
 IKlv83xLGHBbb6Vbub8VNbDQ7Pggro1K/tFmnOchytsTZ58c7LUp0D5L9mLc62KnCGBwuOmp143aiFUyBK/NzEdyjL3LP6qGO5apqd8qtryRnNTPE/EFB5jtTeFlx38cgWXRsYaxDVywt+uozczrUCSzo2dVHD2mIjpvvYPpbiCfX6XMNBULxSB3xblIP6zOasJAuwt7mhc5bVhk4fS/HLovY4kVYL5gd+YtcyaQwX5BVJ1P1Nt2k7fe64EDZQuNEwM21Fi6ImDJQl6ootmRGDgI0TwTNtoZc80Qn+RrO5vcjvMfKibnDEDjQ4UZNVCqeqpsFSGCZDZcWZwfybZFQvxxsCcAyHkVXmqIsNjURRZlFASaLzSYpTLDwJQXdkYB3a0yETnBrVJmHGZFTSvUsCkGnzqFtR8Xg9Cd/l9k6WwYnQuLRh/Ljj4SD68ArIyrKVMyiVKVL0edHyl/PS7whLfFhad/xBApGzFNV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Each generation of MGLRU accounts anon and file folio numbers
separately, and the page table walker updates each generation's
counters in batch once the walk is done. The walker promotes a
folio's generation with a cmpxchg on folio->flags, and
update_batch_size() then reads the live flags again to pick the
anon/file column to charge. The walk holds neither the lruvec lock nor
the folio lock, so the type can flip between the cmpxchg and that
read: the lazyfree path clears PG_swapbacked, and reclaim sets it back
on a dirty lazyfree folio. The batched delta pair is then recorded in
the wrong type column. Nothing reconciles it afterwards, permanently
skewing lrugen->nr_pages and the reclaim budgets derived from it.

Fix it by capturing the type from the flags snapshot the cmpxchg
linearized against: folio_update_gen() returns the type of the state
it transitioned from, and update_batch_size() accounts with that.

A folio's type only changes while it is off the LRU list, inside a
del/add pair under the lruvec lock, with the gen bits cleared in
between. The generation and PG_swapbacked sit in the same
folio->flags word, so the cmpxchg snapshot captures them together.
Let G be the generation that snapshot captured (old_gen) and G' the
one it wrote (new_gen); the CAS can land in only three places:

  - before the del: the folio is anon at G; the batch records anon
    G -> G', and the del later removes the folio from the anon
    counters;
  - between del and add: gen == -1, so folio_update_gen() returns -1
    without touching the flags and no batch is recorded; the del/add
    pair accounts for the move alone;
  - after the add: the folio is file at the fresh generation the add
    charged; the batch records file, that gen -> G', matching that
    charge.

Unlike the drift of lazy promotions, which sort_folio() repairs under
the lruvec lock, the phantom deltas from before this fix land in a
column the folio never occupies again, so nothing ever repairs them.

Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h |  7 ++++++-
 mm/vmscan.c               | 13 +++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 047295ae6e8a..7e487c23aff7 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -10,6 +10,11 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/leafops.h>
 
+static inline int folio_flags_is_file_lru(const unsigned long *flags)
+{
+	return !test_bit(PG_swapbacked, flags);
+}
+
 /**
  * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
  * @folio: The folio to test.
@@ -27,7 +32,7 @@
  */
 static inline int folio_is_file_lru(const struct folio *folio)
 {
-	return !folio_test_swapbacked(folio);
+	return folio_flags_is_file_lru(const_folio_flags(folio, 0));
 }
 
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 724b6e034e69..87e667c410ed 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, int *is_file,
+			    const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int old_gen;
@@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t
 		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
+	*is_file = folio_flags_is_file_lru(&old_flags);
 	return old_gen;
 }
 
@@ -3328,9 +3330,8 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 }
 
 static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int old_gen, int new_gen)
+			      int old_gen, int new_gen, int type)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 
@@ -3519,7 +3520,7 @@ static bool suitable_to_scan(int total, int young)
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
 		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int new_gen, old_gen;
+	int new_gen, old_gen, file;
 
 	if (!folio)
 		return;
@@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
+		old_gen = folio_update_gen(folio, new_gen, &file, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+			update_batch_size(walk, folio, old_gen, new_gen, file);
 	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)

-- 
2.55.0



