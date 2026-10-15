Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3492CCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017896B00B0; Thu, 15 Oct 2026 14:16:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09C76B00B3; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA5E6B00B4; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5EC56B00B0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3939C160111
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:04 +0000 (UTC)
X-FDA: 85325664648.14.8B323B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2979140008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3oZNbx3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088162;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEv7FuHJPnCBfpLiXt+SnK7Vu0g4AAl2oTnxUgVcwHU=;
	b=CQdezAl8zQl47c2k4x7FYHgUPUGRLzZPdtYJAme0I4qinOL+rgHfjoqYvoEamEuGfQkzB1
	9fGF0fDIZ22dw0EVHizG9igwQfZf6Rf7eejW+SeXe7gtrBVbhr5B1XU7GZPj/0yxZLEDM5
	yAcxAtwtdUujSYk7f2EGmisiVtNGKDs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c3oZNbx3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088162;
	b=rsABbxpCVWbElic6YFkvVz1s2iNG8hHKqiIFeUBmLheNAog1rkmAoC4L1GGFI26OckLuu8
	t8aBUkhBBN7+orjL5/0LnmgYirVO0IFZh2EwUzvTsweQXd9X8/YdBXyktbv3V78mML55El
	MTAj259/MatEzjQ1awolCtkAnP7Y7mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7357044817;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 512DBC32782;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088156;
	bh=rFRURW/PYDXky6uYP0rMZlZedhJeCXhr2ivNXilJ7Dg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c3oZNbx35iFJaJYyQQzfTVwfSGyS6ZmAWVL5L22BTt1nigZ3j5j2Bak2YZddPKajk
	 AUBTSEjXvry+IT/HzjjwtgpwoymrZYVYUiHN9aZyDao+x1Y87YI99bx5Dkl+MqLfTR
	 asM5RByEamNtlrAYd659OQuFhP3cECgnSihEolkvEsBzT1Q84WSMRby9vHdti5giJT
	 AsKECMG7SnYDLXfEsLBLb6KXrtxR/dG4qCU6gGxSTkVKSNE04t2+9wjnC5FtSh0wWY
	 zK3pCgZAEGLSMDne44XqlQCVPJIhfVgIoDyT1oStoGdgmn8NlYumM1zirlcYsCyHSn
	 rUGwQCI/xxLhQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA4CCCA464;
	Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:16:04 +0800
Subject: [PATCH v4 15/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=8176;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=OP0akykE/qzlFerevSA96IrPzDmEgd2usDkP1ftKRMM=;
 b=orSajrE9bbuxD//LSvEthgkATHbgp1nA0A44mNSIzqup47QSbfW8puy/w5H7buxcJScuNX5St
 9sHzgmv0w4NAp65DSJmbKz7VLv8d1/gTNaUlmmJ7K5CfygKrmXm2Mo6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 2979140008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: bsbgz7u6omrgdjpb5cn3x53j8adag7fo
X-HE-Tag: 1792088162-213463
X-HE-Meta: U2FsdGVkX19LKwrvExYt+FgvJwaaMxNC0ntgVVgWPnyUjw4x5miG3q3YElXtZlcukk3s48MSkTAvsE7jVXggyhdVudzm+nZnWFVplll6LYghcDIxuo4ieqQB9YeHtzcqh6Y4yrlA0HJ2GN09Lv1jTypww3WolZa6KlgnCjqw2w/YmxpiRxHxwNj0QvDMOhWXA0wpbkhLjT4WDTZiqq08vdBPlZ6AI99qBSA/Vh3zdbQazkGeEnagIzj7jIaEAEaXWyzCOZXVYZTy8dIVjgGZuO6a4HZi2Sh9AllXUnlU6TexUTlhuJiGhcgc6+SMty8Xnhgj/vK6Ke7mTYFAlB57zLQWiogFyFKLevOzN7WdmbXpQb8mUygQHOJRmgVSxhhUcF3wsgHeV/V6AQvF5qNoaapwmHvtyijv3RhmvgivSJc0itFBYbxqSjAMw5Jkx9OOkW2LccTXO+QVUUhMtSDumUUYqza7bm784dm+l2o9wvaD6wHwHB/jT22xwTq+5JEOBHIkeiO5Exl9s+iduhq0cF4yIDMM6dsjTp4U8tLU+swAd6ydjPTR6uYbBjo7L8vVwIZFx/i9xG6EcnLwKHomGPTj180EMHT84kKghrKUiEB6GIgjUSxsqsqJrxrmrw2cIr0NlPPgBB0EciH9olYQUuFY8abDtlIjh6nmDp4VWKJGzFSrcAYWO9C5QNqtK4Vt2ZiFVu8u1JTZKniBbN+N2Gz6gBreZSMvCThkv9w2N2ENhNTuoMuotEw19AjGbC82gRgnxE+SLPRXTKTKfFHut/hC8pwcIuJ+qi8dudH/QZkNq1iEHDai67qwVNXLOMyZzTB0VxSu2qi4DjcLby4kevBfTYszVDLWq0JkQoSwX7+dP/R/EfGAvSGz2lGOzEtzcHib13g07pxodePLAvGcM9Sr29QVMHViDtMhXpBprA29Xw4QVlrMiqEtg/zuBFmasX7iDiGy0q695vVjcds
 +ghGBtTQ
 NbSlwytHOermBr0XUSdjJbjcu7NH5/7L/iqX/Qo91nawZAS2k4hwyRa6tR+4SMifp8DkXIxYgWit14c/A/Dl1lbSxOWlDcGZRQH8oecFsIewpDRrhQLtuqlEqAt1UIf+HdDCodhg39RiFZPtaX8z/HTCcoQRsigSR+2go3eVoR/4/NEHKYH24aIW5ZDIETfZOY/SiDqyb0Z/K2S5IRtr44+DL9WOYGwYvHrjk6DCJmyZiD2y9fa3WZZz9dKtvhcIMKN6G6XgWfq4jEqA2SkiEaE596yLNGj03SpGQx5f7UECrBWZMK+inagfUWUeNQ9rsEC2FjH1/00O7wSGEOU6eEffhQANULMCwRHrLSLCBn1qTpr85VpkAV1mVkS233LijiImMYRpWUqtMAdVKcHTG1aZpycM7Uhreu1zaThdHbWzUR0VoZxGnRq0twkzl0C69+udBUfc7/0mkTWgxlx3lfL3RpPjG8ttKVAjOkeMOZ+9QE38JH4vMbemTsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The lruvec spinlock in folio_inc_lru_refs was only taken to keep
concurrent aging from corrupting the size counters.  This is no
longer needed: the per-generation counters are atomic, and the
active/inactive ABI counters are updated per folio and linearized by
the CAS on the folio flags, so concurrent aging can no longer corrupt
them.  The same argument already allowed folio_reset_lru_refs() to
drop the lock.

Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
read lock around the lruvec lookup, and drop the spinlock entirely.

Without the lock, aging can advance max_seq while a promotion is in
flight.  Generations are indexed by seq % MAX_NR_GENS, so the folio
flags can return to the value read earlier and the cmpxchg succeeds
with a target gen computed from a stale max_seq.  Recheck max_seq after
a gen-changing cmpxchg: if it moved, account the committed update and
retry with LRU_REF_FORCE, which promotes the folio to the newest gen.
The retry may count the access twice, which is acceptable and avoids
folio_activate(), whose LRU lock causes latency jitter.  smp_rmb()
orders the flags read, including the one returned by a failed
cmpxchg(), before the max_seq read.

Also simplify the post-CAS accounting guards: gen is only assigned
non-negative values after the old_gen < 0 early exit, so gen != old_gen
implies gen >= 0, and lru_gen_update_size() needs no explicit guard.
The active/inactive ABI update keeps its gen >= 0 check because an
off-LRU folio has no lruvec to update.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 10 ++++-----
 include/linux/mmzone.h    |  3 ++-
 mm/vmscan.c               | 53 ++++++++++++++++++++++++++++++-----------------
 3 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 41c2e9150c70..fd77dbfdaf70 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -308,10 +308,9 @@ static inline bool lru_gen_at_tail(struct lruvec *lruvec, int type, int gen)
 	       gen == lru_gen_from_seq(min_seq + 1);
 }
 
-static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *folio,
-				       int old_gen, int new_gen)
+static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
+		struct folio *folio, int old_gen, int new_gen)
 {
-	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -386,7 +385,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -404,6 +403,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen, refs;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -426,7 +426,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index dacf066b499e..f50449d10242 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -559,9 +559,10 @@ enum lruvec_flags {
 #define LRU_TIER_MIN		0U
 #define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
-/* Access source flags for folio_inc_lru_refs() */
+/* Flags for folio_inc_lru_refs() */
 #define LRU_REF_MAPPED		0x1U
 #define LRU_REF_EXEC		0x2U
+#define LRU_REF_FORCE		0x4U
 
 #define LRU_REFS_REFERENCED	0x1
 #define LRU_REFS_WORKINGSET	0x2
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c224377234..e604b0893847 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -966,6 +966,9 @@ enum folio_references {
  * LRU_REFS_PROTECTED, so it starts at or below the protected tier regardless
  * of its old-generation access history.  PID protection (folio_inc_gen) caps
  * at LRU_REFS_WORKINGSET independently.
+ *
+ * folio_inc_lru_refs() retries with LRU_REF_FORCE if the aging recycled the
+ * gen index it was about to store: newest gen and an extra reference.
  */
 
 /*
@@ -982,37 +985,35 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 	long nr_pages = folio_nr_pages(folio);
 	struct lru_gen_folio *lrugen;
 	struct lruvec *lruvec = NULL;
+	bool aged = false;
 
+retry:
 	old_flags = READ_ONCE(*folio_flags(folio, 0));
 	do {
 		new_flags = old_flags;
 		old_gen = lru_get_gen_flags(old_flags);
 		old_refs = lru_get_refs_flags(old_flags);
-		file = folio_flags_is_file_lru(&old_flags);
 		refs = old_refs + 1;
 		gen = old_gen;
+		file = folio_flags_is_file_lru(&old_flags);
 		if (old_gen < 0)
 			goto out;
-		/*
-		 * Lock the lruvec if the folio is on-list. We are already
-		 * doing lazy promotion so in theory we don't need this,
-		 * but for now, concurrent aging would still corrupt the
-		 * size counters.  This is a temporary limitation and
-		 * will be lifted very soon, so the lock here is not a
-		 * performance concern.
-		 */
 		if (!lruvec) {
-			lruvec = lruvec_live_lock_irq(folio_lruvec(folio));
+			lruvec = folio_lruvec_live_get(folio);
 			lrugen = &lruvec->lrugen;
 		}
+		/*
+		 * Read the flags before max_seq, paired with the store of a
+		 * gen, which samples max_seq first.
+		 */
+		smp_rmb();
 		max_seq = READ_ONCE(lrugen->max_seq);
 		max_gen = lru_gen_from_seq(max_seq);
 		if (old_gen == max_gen)
 			goto out;
-
-		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC)) {
-			/* Promote second page table access or executable */
-			if (refs > LRU_REFS_REFERENCED || flags & LRU_REF_EXEC)
+		if (flags & (LRU_REF_MAPPED | LRU_REF_EXEC | LRU_REF_FORCE)) {
+			if (refs > LRU_REFS_REFERENCED ||
+			    flags & (LRU_REF_EXEC | LRU_REF_FORCE))
 				gen = max_gen;
 			/* First access only defers eviction of a tail gen */
 			else if (lru_gen_at_tail(lruvec, file, old_gen))
@@ -1036,9 +1037,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
-	if (gen != old_gen)
-		lru_gen_update_size(lruvec, folio, old_gen, gen);
-	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && old_gen >= 0) {
+	if (gen != old_gen) {
+		/*
+		 * Gen-index reuse can fool cmpxchg(). Retry locklessly, accepting
+		 * an extra reference to avoid folio_activate() latency.
+		 */
+		if (unlikely(READ_ONCE(lrugen->max_seq) != max_seq)) {
+			flags = LRU_REF_FORCE;
+			aged = true;
+		}
+		lru_gen_update_size(lruvec, file, folio, old_gen, gen);
+	}
+
+	if (lru_refs_is_active(old_refs) != lru_refs_is_active(refs) && gen >= 0) {
 		enum lru_list lru = file * LRU_INACTIVE_FILE;
 
 		__update_lru_size(lruvec, lru + lru_refs_is_active(old_refs),
@@ -1046,8 +1057,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
 		__update_lru_size(lruvec, lru + lru_refs_is_active(refs),
 				  folio_zonenum(folio), nr_pages);
 	}
+	if (aged) {
+		aged = false;
+		goto retry;
+	}
 	if (lruvec)
-		lruvec_unlock_irq(lruvec);
+		folio_lruvec_live_put(lruvec);
 }
 
 /*
@@ -3647,7 +3662,7 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 
 	new_gen = __folio_inc_gen(lruvec, folio, old_gen, &gen_increased);
 	if (gen_increased)
-		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+		lru_gen_update_size(lruvec, type, folio, old_gen, new_gen);
 
 	return new_gen;
 }

-- 
2.56.0



