Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F18C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9726B0096; Tue, 25 Aug 2026 13:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA0E6B009B; Tue, 25 Aug 2026 13:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A1B6B0099; Tue, 25 Aug 2026 13:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD9FA6B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42596A23D0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:44 +0000 (UTC)
X-FDA: 85140539568.04.854116C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4A335C0008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOprSh0L;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680422;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0KwR0mouCHrvY5jpxQUqELI3S0TSCS5Gep/xV9rE0A=;
	b=PEdR6S9gTxkSy4T5rxkpit4j1vRJR/z1l6fcwwTcmqxSt3yj9vG3cWH0yfu+tuh98lYR2v
	T/gGFqgqfLRUpRrt9C2zYU1vl15joW+YIEEgYFD2JJhzXbH21rSor7YLpQE0QgptrxpLNz
	9WqtaWtnjGzf1JHjIok+OXG+/4bsnVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680422;
	b=R5GIFFcx9ekY3VI/9Yaw85748uq8QlTBKuicvvzB0BOUKQEREtruWOXdvbilDXGHfxhq66
	NKekAzieXUF8PqTal+2y2WyVY1rFixx/NkonndSX7njeCy0Jh20lBqYzsYTz8VWBJgHhCz
	he9LX/+eTFQ9Gv0ZvYDaknnVC5FGnNw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aOprSh0L;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B91440BA5;
	Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 022F0C4AF09;
	Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680419;
	bh=44fcJB1GAGM863zI2kF8HQbZ3J3Y4TWDrV3HTL0mUO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aOprSh0LRluLPNXP+tv/SGGfD2lF4VlnVl7aKQTiZxk4fAfXTKUOyjNw0u2Z/PAgI
	 FnnTkyUre74XKp5KQSeNYONL7IvESdvM2w6/PZBCERDUm5ji0jkKXL5immG9Xi7rqE
	 LucZ0/YJEBBjTm63lKnm2384rYkAWcXTf39fPWX9UJnmUdm0Zw9Q7F+9qn8/eg/mCb
	 RnDhMU2tS/oNijInZFGZHTKxUvbO5QKqBBdZXHXycKtH4Up3goOp6BO8YVRYvciRMz
	 H+PmpcWbQ6qhujq2nOPv2ngqpYSjuMTFy+Tkpdth2DPwrlHe7urw0xrbZ8wWJmpXbU
	 JHfHkccviaENQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C70C61DBE;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 26 Aug 2026 01:53:39 +0800
Subject: [PATCH v3 6/6] mm/mglru: fix potential generation folio number
 leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-mglru-flags-cleanup-v3-6-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=5305;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=100BN63Qk6wpTXHzIP+LZWC/nFv6HG+IQJ3POMrMtTo=;
 b=pkXtD/trrADDPFghgG1C14MnZoGcjG3viYChFQ701qoMLKWuWnnanZr9Csqw6aw4cj7J+yzBR
 M+bha0hrPzfC6wJ1v3kHvCIUwez9fs0a0JiR6nEWDneIZdqIAwmyOPK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A335C0008
X-Stat-Signature: t7mx8o6ipty5qbgndywp88z4e6oz36u7
X-HE-Tag: 1787680422-391112
X-HE-Meta: U2FsdGVkX19EzrEjcCrhQYuJ97smdirrFIa9221K8G0l8ugTnmqkM14Tstd4b69INMIJ1IOpQNA/RTRyEMfjz+6iJU+G0DE7dUIxRMmPebJIQwD5vwFuZF5uyrG/XY9oSQgj2NGnozxEODQ9gTWrEjnoFVqzkUlVC8VXjCZpoldsSHwTJjcO+dU2oD39XdoINXAzyvOdPyVoJlTSrr4EQ200ESYHj9ou6EUjoXUfM1rBAGGGSoPTmYdPrBSEGOknj7SVNsUS8pIxjNlRqMH0FN6TRR8qNeTVubyOczn1/EAIaukpHX8Zi/+m4WEyUhHr+tPtmobi3012ga6krcyQTj5rve2Y59Qy+Yd1rul418iGVjVLW9RLs5Rn27WEi7KV6W8O2p2yyG6TomzmoAOnnsfOKYs7Sa2kjEmLmIVc0NuWa7ofVPO+uLuJVtr9hTWbUuz7766yiPUDnD/vZPRH/4GuWLnP4+i/6bG4/XQrYeyF6daiUTqGWRu07kugMRviLb95KJY7t4ZZqInapzhW9/MoonA/6CkolRUYpdhBocJlluEClfHUjS+8iOvR/kEYrynHw1pBGxhMuwLo52JeUA0PrmzDhf/5FI64bL0Fqnu66kfC647evDolZAhQI7ZUWgMh8P13TgVZquJ0zDMfIgqBNsoYXg+L9MEr7nkHQWxTK782+m5GmpQoZeHFkVN4qOfjh+KenwBbPexawusqipVXOniJPI8hxwz2z4W0B1xy82h3dq5FWAPNpxOLz8ArS0Nf70HqrhV/41d5J1FNnfUb3RjrJWykNL7CjZQ9oR/ARA9xi229tttKgqPAkgIYig9FiWqgK6NY5CH8nH5kO63GqKMlZxf0tyq4BivN18sE90sbbMZybh89+TAXLXagAHdvKvI0ttK1oFZy4+3sggMZSMAS0LOQM3URHQdvKwVxWzAc5I5ePFJFCPjFtr6mFFKHp9QfqfxpEhq4ltW
 fpezobJV
 T4ms8NTajSX92xI5DtyTm8ywMgmd6XE3k9C04kklDJ5mtzVvedztNCWy5E9jFSU/+Gr9JOTeejhnfdSIYngHhdAoJQKUAyrGoY2TSvEQ0umza9HLkA2TYR4Lmfpm7eLVrxT3SG3Q64Q7z2ofF4+3BpGUEuKb/RKqFva4jkkcScDDvovApcpdjYmFxFq0nynXWyBx5LJNsVu2vLY1X/p67WyuS5cE9Ku+LBUnz4UUky1ttwscGmo8IX5BDuT4WLfoX4ZheFWOxNAjqVz4fZn/0zu5GbKV40NvPC6qw3rI7bFI6qDreBvpqeAl3FYlDlPtv+oMMi6LW8RCHLVFj3zF5dGQGglKnCOGwv3bDE0MAmbt/Y2QMW4ohiG6QtfPTKBwhFiu3gPxUVbTDImULPwV7zxRHNfzEEQRJwvxc1tdW6Q0MNDelEIVZ/Y/GyGQUZ+ByjRs6
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
index 7f91a89b5ba3..8cf82989ec26 100644
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
index cdc2e44875da..6fda948aecf2 100644
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



