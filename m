Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98B5C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A806B0096; Wed,  2 Sep 2026 05:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6311E6B0099; Wed,  2 Sep 2026 05:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519686B009B; Wed,  2 Sep 2026 05:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 248086B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8915E1C0166
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:05 +0000 (UTC)
X-FDA: 85168353690.23.35993BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A3AE1C000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guhwg4Zz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342663;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzU44z4AZFeAWuZJCgtjXVCslMaavo1XbKuEqnrZiQM=;
	b=FdAhK8lDtT2ksr9tthf536aZ3Tz+Aiu6VZwvYkLC0/GF6YCrv0S+Iw6dsfuvnqyIgKk2dH
	lxZ2xxDZv56RL4BzETjN1O1QA02V/lxcQThUGdrPK2LFQF+wADiu5oWPH4dmIuVflXTYCg
	42dbnplcBSv70EmoV5R+p1REcQxZusE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=guhwg4Zz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342663;
	b=Q0QgeW4IS1oUCd1H3bnZuPyvtsE4K0Zznj5e9g0B+nY3nXiunc6UjZg2Nnuup+SoqsG10T
	A5a2taX9izLhMGt5nP5I+9gdESaYnA195YgOHyxCmg5kAesZySoN7t95isXQLGMtouCive
	A7WZjeO7fas9RPeLgaDj9AyNk3G9UeU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6553C447D9;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45C3CC2BCFC;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=ENRV4v6WgSczjFoQPgCJiVLJfabo2qU5Lymw9U16Hos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=guhwg4ZzUREQFbNhN1zYAYuwejMCSgQdNE+tf28bJpEV7u4X5chlzR85mDuMtpVHt
	 sMfpHf3VdOGEYa85xriA1NyTB9ZeJIxBdi0YGLWLtVZxKqHME1sLgJ1cWsG7MqHHzc
	 JOTPtI3Vw1hHhcb1N7jRfFte2OB58/cRpKERMMxnv+uf1BWxEDtKa1HzSyHd9V9auV
	 Q1a3NgEgYNOTTHxO3xVG9iBW93BIbzECEzrwg+9luRC7LhD0+L+08wiX9FmO0M7uMz
	 lo0+mhceUhHkU2SaOmNCRSsHGpPQVwkC3KElxruH4qJIotFmjRXEGLHE8kxa2MAm8A
	 od+yi+mBimLAg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D578C624D6;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:59 +0800
Subject: [PATCH v5 6/6] mm/mglru: fix potential generation folio number
 leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-6-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=5300;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=BeFRtTv2DUVCnBDdSk2xGGeIVNwza5FMggB+YkSlaTk=;
 b=WKortzZwxgU1YkMCpiMgIJayfIQsa7teb+grctu7+vTppe/6UAmFcu5HnWG/tveeH6BpxNbyq
 4h3I9AloIQiAPCNj/AL/+unCXwYy8KCX1/IJJTmhLHESJl3BqpwQucE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A3AE1C000A
X-Stat-Signature: y4yspfpgw59kyo343o39if7gqzbs17ki
X-Rspam-User: 
X-HE-Tag: 1788342663-796912
X-HE-Meta: U2FsdGVkX1+mHmL5cho1fE1AXUMOyFBT6D7aSeqSSSMSDhQlBpUsEYV9hNQ9haseqnEe+cmb3AWXBp6/LqkDdlU3kp3UZt9fS3ByUwtKlKhTaBkW6vTtvLfEarVc3dZUWKXCb1jEFO6ysH3YGS0nENKlSCz0WBJ/rXG4Xu74amKL1Xm0S3uRJ2OI27lpyuQYM/31n12S0xvxnZlsLXVYwMkgGU1VDMH+AGO40qldrV+HPpAMpa/gYucCpgqOdTMfHivAKquMmTSeIRf/Z8OTC3t6OS5t09oJieMAnd8cI/cX432uQSiNAMMPgMe3mrGj7FQ2AgRGnaF6xdvxE+V6/APo3srbXEbySqEY0YKDiqnlwpPtUvDOqsxSJBgVHa5cgtA8Nq2/XUc/QM71U1sBQelpNOv72W9Q/ibsiKd7Fx7ALpjtvWeVm6LmrMj1R3Ggmobhc1QiOXCpAD1aEUztX/prtBoKNyu5Ga9sqUzQ/R4D6DLeC/ie1zxZbZ+JoZ7/iEx0WKmTKuOYkTYPM6tA+haKJ3SmQbwtLQ2HVxEtO/Cf+wqgzaU5/eRbH6V7c7S4QvyASo5GlNH3DKycUgyuu9RZGQSv1OFMu0ogBQHFR+es0Bo/2UlHnEfzI5gGM5pl+Su3FmVySGQDsuJQMls97QegRSj2Q9UTQzmnMFuK7xFAFTXpHsUe0usJdGbFqvwSDRv3m88h6y3dVeTdYaUsuNHWh35ZvqsR4KRB5w9bLfYCzYSRmpjiOhA0ExpmRt1b4hgRioThUHnuPvFb5ih7IYxD5E8LjPvIgHLygYeUIoB2ElkwUGq0lYJJshSQjaN2BcFiOncpLSm6l5yBjLcsudgXCDB9qbRc/yeCw2rlLQ73oXjpMoVRoGqHHDSpOWYL8VfxBVmlQqGxvcWZtNZ0VnFrcjeNTlaiA+SbWipTGaA8ivsfGfN3kLYsJFsnPf7aQKPNS4MyK7FQObXq5UG
 lljjhBus
 GIvNGPFgj37Qnz0un3AvZ43617WelH0PxiVpMytz3MoXenHaX4YQqipVNbI3UAh7Ky69mSDXQQbADyaTpZTsZoj4j7rg+1xQ8zimtZdLgCV5a2wJkzfjHGtBLmQYh7t0vmu7HEASJGZy03IHMbYrm5BQtIPktPZMAJSvkfNEhc5qdElfnjfmrJUs5TwjSRws+S5wQkNQOakWZ0CEo3mnwhugVMSmyk5p1+8aqvFL22+0ZlKOOZidEduw1Cr90jdBp5BBEYQJruWLbmnk6EipXDMd/bwXVEW5Q6OsczQippa7IwoKdUkvyIVSpfIQKGK0Krmes5Sfl2lQBKz6ALSFX0ucdv+PShUC02yFNuylUtc/ORnio4msYy47Nu+e/asmLOG5HAp3L0h+8yp1OjVenJzwmL9GVjaamH0/LaG6S25t968vF7yJ4Hc4aLI6qQ18TsuQu
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
index 714a3f273f49..e7d379c6e703 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
  ******************************************************************************/
 
 /* promote pages accessed through page tables */
-static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
+static int folio_update_gen(struct folio *folio, int new_gen, int *type,
+			    const vma_flags_t *vma_flags)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
 	int old_gen;
@@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t
 		new_flags |= BIT(PG_workingset);
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
+	*type = folio_flags_is_file_lru(&old_flags);
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
+	int new_gen, old_gen, type;
 
 	if (!folio)
 		return;
@@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
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



