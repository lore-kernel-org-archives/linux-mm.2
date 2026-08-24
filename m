Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47E2C61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1B86B00A3; Mon, 24 Aug 2026 11:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9C56B00A4; Mon, 24 Aug 2026 11:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDEF6B00A5; Mon, 24 Aug 2026 11:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6826B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE7D780193
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:37 +0000 (UTC)
X-FDA: 85136540034.16.4CD22B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3CB1A0013
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rlvEUG6n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585195;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=674iHzZPNBCbHVP2H9xAu6k3kKQnVOHT03fkle6bOJU=;
	b=yT2V2439zd7nV5opu19XJV/jout6S+JH16FOEYW1h05G8zhyTDKyv89UpebgXkA1o2Aluu
	oQyeGxdsOxynn+WfThTS9sPM84IgLSzJFm8g424TNkLO7DCIzUD0TgYJCqWV7T5viOs3Cl
	2fOkej/djh3Y8ZSN3KvMSfUQR0Hk85A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rlvEUG6n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585195;
	b=aPbiS7qO5rrT7pr1h1JC1A6DWtcTJuyEVjNRGMgSz/GoAmqpAAsGMSa33GK2IotIjGi4j4
	dTlZMiE5Hg/eD1Y2kIMpls3pVAa6Arv9t5ZtaxRtgW9xAB6I0OafZ+zuaghAeWkh44opxR
	Nyzg9QGhjNHAZKjD7YPGjG5NXFJuIV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B297440B7;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3DA26C2BCF7;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585192;
	bh=LSpVtO/hFU1Y8AvNZfXAsZKiYVFMAqKDVGjSAMR2uhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rlvEUG6n2HLPgiYttJSI/+dUdKAgxBeCajSAeASepWPCeBrBFb1Y9jS0CVOI5IhKk
	 ig/sxzNQtpoGjmYfs0OIn177KdCUqmmfSd9a8onlzsNiQJpHHOQWNIjaxW+f0iSTLl
	 b/yTp+P4ZHPZDiC09W44ZLEX4yXD7kW0Xvs1+GtbX/KR+wkq5YGhrtX9+3k+lJHhhO
	 P7xh3RBgBiDYOArM8RyBy9adfysVWoPC4G2TwVH25hzf4pS/kUVi6f7Xc5rCGZNenc
	 TYLMzul863RpYWQwtzje4zXqtcVcFYelWKUnEmMRmYCKVopvm6Tat7fKfYm4ROgThz
	 zJCZdUZ0RTBdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D67C5DF81;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:33 +0800
Subject: [PATCH v2 6/6] mm/mglru: fix potential generation folio number
 leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-6-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=5305;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tj/12DD/VSfeSYVO143tuBTxpcfyZNrpYVNaXEBtCkk=;
 b=NRrbduhTkXP/HPCS8wsMxUmN6w34FdFo5lTlwiaKmyEXifN5Dfy7gXCfbo7nXlcrTNCXaHypS
 nEP9/yGzheFDNojvLfL0GGdDREFejku+i3WMu1uWQ9y/W65UzFGOI2P
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: B3CB1A0013
X-Stat-Signature: ghigqiwqom1r39ddr38gj45hxytiituz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787585195-400869
X-HE-Meta: U2FsdGVkX19CqcAoze61bPVJ3htKNNOCaKow7goz1ATy8j83IAfycdeMzpeg94NagfSRrGVWxVwd/+XeIQusS/BSnmISsGDTnktNbxpkEofiZzxpUg+3BAcESYqVeZp83g7EF/1igKaDwpZPOTithObwnKjm6vLoh2J6Bcd76V+Wjjn1khMVGTbf+hHF877L3g+u1Tx791g4HpPuy6mXAOcTc+w4Zd7z8Yt855ND+TAQtzWgP3K/gCsYlLgVtRqJ1V0E3q6osxYyNDoKvMP2KzjFZhdqORatAPNvJ+XqkH4OuwOM8BjwxQZjvzFumDy9OuGNbbvPRWQbBQROq8M6AtkUW750bFqvt33g2BrXiB5Fq1Gx6iHi6e+Ne4NMDj02xwFUBN48ZEnFgnfA1t79bWigIoOBZMK2CHUj4xjzWRzZj74zu35a41rBj1GwqQa431KtbaGi5A7iYVGfuYCy3rd/kV+uqDS9O/x69Kzmo6JNP/d6FSSoW1lIwGh2nxwaHNknNDLFju3xrlFb/Lmt0WpE7Fchhm5zfN1eruB1HDJe1MAT8Me1fySI5U/NrHaaZSpuhkICd7mgI5Js+9PQj2OLTcm6GEodWN3DXXgKBK9s4/cG8gDXO6UpXEHULYseb+78upPsk3ObKunFmJHx0KicRPrzxvcrmAAgH6oI2EohijO05QXqTOgwQPYCCYDawluxdnaeYu/sJd07Wtoh1b8bH5PRtqk3zELIxyL87wUvUf/mcnbjVj592/MhqAbcm4m0vimjOohubWY5ftekIUeXUhRxEQs1rVNdZmoThcGKWpAgbVK4eCTreR1HAdXEgKv7Z1F/2z0b4a0SUBIkUzR7vQ8Km/dQDq22AhkXh6uT1HTxrh4kKpxmEFjq7AR3DlgewhHWd/IC2UbNq57qMtQ8KmcQvKwYM1ouR54MtwhmPtfOPZOD4tg6lwQQjknB2CcIj1YR6Cbaww4vL5n
 A7Vs/agU
 Rgmr2WUh79pw2pF8WDTkVo5SiHKDbNAyOJyx1Wsqxw3ZDWHZ80NYrwgmZrQ1lHZ8x8c/eu+Dk48uIuFTJvW/1seDnCVgRE4xTv4oaVR9G9Y7A8QYpyY1WVm9p06PXh1WNPSbMHBD0DTP3qXDjgMNX1TtVYolBgqj5LcNEc3R1/HWpgvnvo6XX/dSq2B5ZRhaeFEN09dCnYh8jNsmBgRzNQKkZOU2Mh+wnL94kqgtpCXOXmr0+y8u/LUEGKeZ3wbYtpWCPZcgES6bUDXEAEnpkEzTc3HCWoYoKRakMMt0Vfc2iOZeI98NClPgRVL7bPfYKY8hT+JX3/xQtvdAGsWsXPxaENSM/xP5LyEg+6o3uVUvF+lR12iN0ehNXdgPuNNJf7j36PlCH5eWuhSjcHNf3Uz2ZxVaKARcvNHi3uNZQ0GW5sl3//MrWXkJ3ieKVIx0zJs6k
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
index f8e291968342..a1497ad61ad7 100644
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



