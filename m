Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C94ADCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A456B009E; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351DD6B00A2; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4846B00A3; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6BD56B009E
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BBF8A7880
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:24 +0000 (UTC)
X-FDA: 85281310968.21.CB7449F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B0E8100007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlVwh9Go;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDZQDX9izQ5z+k3j6hkmB5YnVtj4xz36Z7iMHYJr/HY=;
	b=lpuvYpOKE2J0UeWyi51EgQOSpguRKS347kQNxsa/t8JsQqsv5C6rTUgPVn5kMFjwRS+9Ds
	z7Edoo8hfF2NtBhOw9EItrnFkOiDOs9OmdG3TNFLxLbRZ0+r3mHv+gtn/MuXE6g+c50oOM
	X8VIFyP0KQJS/7uzWEdFt9VYLk2rkek=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=DxW4Bx+oUCq/nPAQCe6UjY5wg9D1tSSWim+GgX4UUtSlE7Rhc9vs9xkq3j9aF/2Q5YmyQj
	gjlff6NkvkEc8azG+AnVTt99fL3wKisYAr+Py97cKOWVajODjIMkj0hkF6V9SZo+uE8IGq
	WylVanV5TinoPOH9TIKLZN4o8oYXFqY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RlVwh9Go;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D9354487E;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DAEBC4AF50;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=5IsVFkNq+4qTFpmrmDf0zF42W4H0CCb+aPvxF0RPcO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RlVwh9Gob7bDKg7Ci8JcAI7m5JCv6INC68ybBnW/uagcAerypXOJvHvzFvcWVaTjE
	 qjt/wz02rjK1+5wKZEh3rpggCChs887r6cjyieXZgFCs4whQZ80mmSpI+p5y8XobDR
	 wx3Rwq6cc4giu7qO+PWW/e9LwzEpvJ9OplkmxJNk8Q+lMCKQRb10TwihE7tgQGdTQm
	 j/addYjiZ1VgS0TxO0BLm056MLADlgqcYYpMEmDlLvJzbOiaf/tG9gMIE559yRfkFh
	 edHcOMEgzlwoU/Mkx4ykc6goQE0hQ71BPKpXyN1y7L0u+Hg2v2vuF6zjOtVdZ+ZgDC
	 JTzqCPcIGoVsw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F8FCA5FEE;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:24 +0800
Subject: [PATCH RFC v3 13/17] mm/mglru: make folio_inc_lru_refs lruvec
 lockless
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-13-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
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
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=7761;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lOPNCXuistPvZKvrlG2GxtDhXxq4I5HtD+Ez17oO4AY=;
 b=GiUPh0NwLsWhbpr2hXSXzEbUghuXijoTS6/s8loEhMaayfcYrXRecZXmoVxV8W2ojKnf/ITkQ
 1yHKiVSRi0ICwKZjcj6Gk7ZwRxUv2tbxsDPcGTaRVbwKL3s/mENPJ4P
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B0E8100007
X-Stat-Signature: ynqxp341y7wi7xqfr67kisqb3bcwpqcu
X-Rspam-User: 
X-HE-Tag: 1791032122-130869
X-HE-Meta: U2FsdGVkX18IPLQzteenUinetUQwAHvTifSFMsgUrDtLmm4+J1fjE1eoUt3nmztIXAljYN+09YlBvqZU/szEQswI2vDDYKHVzlGoay9qxj44ddpdEsIw/8q5nTALfGSqwXi2ZjRLqUAfP/RUT6i0zPYiM3UlM3li095RhXWS5qBwJxeYauP5z1AL86uMHNx4DaySHzqcECGbY8ljsGoNmPRoECXSE6uKXbaFnQVn0AllPwTLVh7aW7fLyybXne1PXQDYe50REq83O0XCyfYFuZQFkKlrFACdEYZ6OE9z7n+ox2F96AqeFCm7o9xdYNkhLb7aEhcRC1G9mnOPCTXupgLHvzNE1JY1b31nB4ibfRou4ksGF6vK9V6LSMDaV+E/9Jx3wQCcJ31cmmbVU+PnS064nVQGTbWtL78sMW9R0RgZHZMd0EIWBblgEXNbe3dpwvZ8JE484v+3B2PmLFnkUhxLMFUPR2knTnxUrlaYqnQcktmK3LW7jka/FQ/20u8qtHfotstAeZvc8c0OOX3i5fQmjJ2UU+DUsCzD7TLeZsF94NnFewVQEJ8IhF/9YmO0IqXPl4jYfmu5IldmdstmMrbVd4uqm9SHJfuEKZtbp2wADj4BBwkeHKUFVkgewp1W6pVLVZfS6j0nI5r+ewiMAN7mYAWsdmhdw/7YPBTMR3yk80aIVb9qVe8EJpfy2yROBlESLbE0LEruRWSPJ0+LuAfY1H4F8iM3N6+U7wXxSOkEVtXzTeyAKaTnX/P7hwRp/LJ0Ze2g+AOk5z1k/e+zvz4SaG7mN7AQXu92eNRdkJE1L+QCt0b0JlD2IXOMBGikr9tbM08VxJNles8pZV5Ea3bo8rtwn7ogpEpd9X7HxHeq/YnisaP2+mlKxmzcgrrAG3Um8RtqM69QlEgVd3BNWLpnu1VQ1ksx1P8q1KBAa0GfAbkJz4c4augKqlD4OMMTR+hohCPACi16LGOher/
 ahklvw27
 xlwjDC3851X3iwfhtod0GeSMhGLDQOoU3jRyFT0ilzB77WU67EpWfH1twDOsVPoNxxSqENxqLnpIJYVwTwqbaZlLtxX4bColQuGubCziEc7qah76UsSGJACSayh2GKdE9bjSv7u5FKGB15ktw9rE+qvyhGqaSuCEFche5PmgsEI+vEeyyoTtBWRhQ/KrtfES/jxZDE4LuPIp5F25N3GqAZyaGaon4MJq+rFYGjaU+fq+xfDgviPSYwFLT2vS+QUdWLRn/ruunKVwtRxuMXLH9CFXOHQAEIL0pomu3sR8tHAwvFEbJ7pnuG5BSJKGjhgwW+g4gdKXx2JvRk+6VSQRi8IELjP2dAeBVBwTRd71KKLkKp6vf1CPdYWm5bFlZSOn+MrD76KhCpKCrFX9md+F9sVxCDcVN9LZdCS1WI07zhooJw76iNudgrGdBPVry142bO5nMC/3YT/8cQDxRKDKKr3HIRfXMnBG0kqP9smeygxlxTk55MZjtyyWj7w==
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
 include/linux/mm_inline.h | 10 +++++-----
 include/linux/mmzone.h    |  3 ++-
 mm/vmscan.c               | 47 ++++++++++++++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ee7fcbe2366b..b68d68101248 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -293,10 +293,9 @@ static inline int folio_lru_gen(const struct folio *folio)
 	return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)));
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
@@ -371,7 +370,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	/* use the refs from the atomic snapshot to avoid raced update */
 	refs = lru_get_refs_flags(flags);
 
-	lru_gen_update_size(lruvec, folio, -1, gen);
+	lru_gen_update_size(lruvec, type, folio, -1, gen);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, delta);
@@ -389,6 +388,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 {
 	unsigned long flags;
 	int gen, refs;
+	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
 	int delta = folio_nr_pages(folio);
 	enum lru_list lru = folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
@@ -411,7 +411,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
 		folio_set_active(folio);
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	lru_gen_update_size(lruvec, type, folio, gen, -1);
 	if (lru_refs_is_active(refs))
 		lru += LRU_ACTIVE;
 	__update_lru_size(lruvec, lru, zone, -delta);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e096fd0a5047..d78e3f97423e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -558,9 +558,10 @@ enum lruvec_flags {
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
index ae4a0522a8d5..9cc06a95d931 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -982,38 +982,33 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
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
+		/* Failed cmpxchg() does not order old_flags before max_seq. */
+		smp_rmb();
 		max_seq = READ_ONCE(lrugen->max_seq);
 		max_gen = lru_gen_from_seq(max_seq);
 		min_gen = lru_gen_from_seq(READ_ONCE(lrugen->min_seq[file]));
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
 			/* First access only defers eviction from the oldest gen */
 			else if (old_gen == min_gen)
@@ -1037,9 +1032,19 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
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
@@ -1047,8 +1052,12 @@ void folio_inc_lru_refs(struct folio *folio, unsigned int flags)
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
@@ -3648,7 +3657,7 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 
 	new_gen = __folio_inc_gen(lruvec, folio, old_gen, &gen_increased);
 	if (gen_increased)
-		lru_gen_update_size(lruvec, folio, old_gen, new_gen);
+		lru_gen_update_size(lruvec, type, folio, old_gen, new_gen);
 
 	return new_gen;
 }

-- 
2.55.0



