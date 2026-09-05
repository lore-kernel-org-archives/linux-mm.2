Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4382CC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1906B0096; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9983C6B0099; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADDF6B009B; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 629F26B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2AF012039C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:19 +0000 (UTC)
X-FDA: 85180299078.21.D7A6C91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DC593100003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=arXUyjWI;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627078;
	b=VbBNgjJmT5r9EN8+IMcaE0kVcty9XyUex/ecUmAu1la14Un1oxAFD5v5Tm/QQ6dq48zJ9q
	R5qoz2roaHjzhNv6UpLmux/AutqBT7ASD39/jpbgS2TVoBgck8feoS+2WEWlK+h3wwsaQz
	XSY5DzMQ5/XpaVrKcX052uT6CE2Z8uw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=arXUyjWI;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627078;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVZJCbZd7SKrRBmkaPaWAXgPHlJH5u6x32BC51sCpxI=;
	b=QdD6nV/Wf9XUQiDIkE3+sa04oyXwImwY0d/j0vZcu/9V/rl3yb2kpkgoSMIAdqs8GgCAJJ
	LJZ0epCkgRvvj94WKj8MNX59CKQSZHow9gQCfNVmDjumBjW4rE2FK2qcrCFSYOTVfp+afP
	ej4D9lrCL9aISC/R3VIxc8tSri3qaWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D90CE447D0;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA711C2BCB3;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=8E6ECgqk9jbzeKH7VgrO1c1D3JazW9qbEm+L/2eKeQE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=arXUyjWIEWDXBWfKJy1dBE/65/Dff+ugZVNxdXc0p88l7nkCgIwyyGxqf6+OHW3wm
	 Gx2kIju7wqhWOzAGaItGf20SGtAuN+BWskxDDn8Q+mP3mkDy6nRf/NyHBlTVA3UYZ6
	 ge8MM9St0UErsdpJnqe784MNhQ14e9DXq4uzbVhg0rXHkyB3/4P40lzLxtVqCufevv
	 A0pguX51MlpQOLYU1GGH7WL77rHwkarkgLPZUCt/jTt+8QuLv5pf0T74xx+vHa83c0
	 SkKulIH99pZnyNldHFOwTAeN2/Z3sSgyD9kwdlTXWj3MSvH97iGEidr1R1JgdUrLmO
	 mOGat7scYWfVw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5619C624D6;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:11 +0800
Subject: [PATCH v6 6/6] mm/mglru: fix potential generation folio number
 leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-6-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627072; l=5345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BszP81PgRTBhE2JUIBp3b0zvUwogDjQzP4kQOvW4z5Q=;
 b=COU4XzMMF4/bP+d3BBOGlqBbUw/B8cXR4ESkPoHM4EsQvt1aN1TnK2/RgGeWTHudo0zyJFBiw
 +YM3N6CHPuZDoNN5waXdGEPU/w0/rvEe6UuykFuMvPY5wjjnb1HA/Nb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: qp9bk19ydowtmqfp3hgpeqz8ka8gcek7
X-Rspamd-Queue-Id: DC593100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788627077-740980
X-HE-Meta: U2FsdGVkX19iwSrjzeRNB/tLcsK065koW6HZ3kxFGOMyhtTUl3gtxjEKBDgzT9+KZLgS47t0Dc1IcYqQD/kIixNBqF8SyM6/yAFG3sZEbkGqYbk4rZ3c+29aI20ezxdsWRSvg9gowAdBGxRzXsuIAT5XhZNa+Tmo8Ru/T+HGYAgZx1MuzSZ8HHvmFTPiIm3RlklzbHuUCn+LVPYYWy+M23N28VNwvJy+HwwMHb/fY1FFO/kBiQybCTbEJ7rVQj6kGij6eacekqcPiLCMs9KscvXWXYNAJXd3aIvgXG6J5XqjQ+lB7y7wlxApWwCCIA4X7OvncI61oDamz5lblqbE7OijawAy8k6f4ngJq3vWTKXjNL8u65K/S448oF6BYgYU557ySQDj2MrYKf42YurJd5/jOldglPfigQgZ4WkTUU57HCsbdTE9WUxCaA8BAbvFbLQF14qeoasKPzyI+ncp3O3j2/gC0JvnnCbEiX/fGDWS9uUANdtp1xlzRF4gXTstE1C5RdFkEvHTac+txgj2pUivp9ydIwE0wCYPwHAu4sEt+RbUh6VlG+t/gGXgMqhQD1Kq1JKf/lq6GGDPAErfxIvP6sQGtJC2AW90a93wr0DK/ZfIdCiMTDfcrny7IZacfg2ksZLVDaYaSrsDs6ZXWKKsHsXbnangNEkFF1Pu+psC23eCjpUR7y28pqR//KkUdJpvODqgrl20Q1rdNH+B1GoSVDyryeSYx6gm8ZirrlDi885vJH3BUG0rRttkIfsKav+6T96IggA0WGe9qtNe/fXWaO0AEHaOY7PWKf55sJZPf7BTX0Aaye0R+m3CqczDAXnIeuiY1vKnqnaTYrtV0bUItfxNPSz3+5Uqp2n6rsBUHDofS/6Y6VdVS2lzfqncFeB9RMDXIJyv2RL3n4zvZp9NchssHsrV45sgIa7BHBiF2L22lIq0QYcqBLTON0FV6Yq3caGpQBO6FH/LWzA
 fNxm34TB
 BRS4GxW5bWh8FPWRJriISNutLk/r5UYFXOL6W3HXg/78Vir+8DjpoSTUoDqDSMcGY7dl6WWaqlJhJEHzc24OCAJL+SOZs+pOReg2J66npOQdQPXJUYRJ9lgcvLgMvvPKUvRBtl/0YITwnGLZf+qcS2E0IRSh/ODKkijStqHsgLabaPRwFYOtKoAm2/Vlv5u2PdUXyxSr31/t5GE5bRJKiZRlPFKWM1Z1u09SaF9BoQsV1RuTOCWp9QKmuyDus3NzjygWGIhls9R6YaNjMebAF/eK/U4gZsVL20kXhSDs6CFoVr6nOnKpMo5nxeRl979PIXmnOetVy9ld1V/uZmfwGFNSlxNDWeGdhZ8iW0ShBHKG3acXMwCeB7ODkCNct5/8FD1ooPBs68qUb9wyOy3dDK7ayhodCppNm7GvIs7dWIjxxt8tokyttsBW1akhB0TwEI6Wcx9+VJtxDMapdC00+ZpnTZQ==
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

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 11 +++++++++++
 mm/vmscan.c               | 13 +++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 047295ae6e8a..ab69b9930893 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -30,6 +30,17 @@ static inline int folio_is_file_lru(const struct folio *folio)
 	return !folio_test_swapbacked(folio);
 }
 
+/**
+ * folio_flags_is_file_lru - Should the folio be on a file LRU or anon LRU?
+ * @flags: The folio's flags.
+ *
+ * Just like folio_is_file_lru but take the folio flags directly instead.
+ */
+static inline int folio_flags_is_file_lru(const unsigned long *flags)
+{
+	return !test_bit(PG_swapbacked, flags);
+}
+
 static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ec5832b0d867..40d3f1b48a74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3294,7 +3294,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, int *type,
+			    const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int old_gen;
@@ -3323,6 +3324,7 @@ static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t
 		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
+	*type = folio_flags_is_file_lru(&old_flags);
 	return old_gen;
 }
 
@@ -3368,9 +3370,8 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 }
 
 static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
-			      int old_gen, int new_gen)
+			      int old_gen, int new_gen, int type)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 
@@ -3559,7 +3560,7 @@ static bool suitable_to_scan(int total, int young)
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
 		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int new_gen, old_gen;
+	int new_gen, old_gen, type;
 
 	if (!folio)
 		return;
@@ -3572,9 +3573,9 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
 		folio_mark_dirty(folio);
 
 	if (walk) {
-		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
+		old_gen = folio_update_gen(folio, new_gen, &type, &vma->flags);
 		if (old_gen >= 0 && old_gen != new_gen)
-			update_batch_size(walk, folio, old_gen, new_gen);
+			update_batch_size(walk, folio, old_gen, new_gen, type);
 	} else if (lru_gen_set_refs(folio, &vma->flags)) {
 		old_gen = folio_lru_gen(folio);
 		if (old_gen >= 0 && old_gen != new_gen)

-- 
2.55.0



