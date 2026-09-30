Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6A1CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 18:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118A76B0096; Wed, 30 Sep 2026 14:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9C56B0098; Wed, 30 Sep 2026 14:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA8B6B0099; Wed, 30 Sep 2026 14:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1CC26B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:47:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 487AD401B9
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:47:38 +0000 (UTC)
X-FDA: 85271312196.23.9558A35
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 957D3A0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:47:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAsmU2wD;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790794056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ov7QGq/mg3vaAJFg5WEdif+xuhC9RlGRRbBlN0+Yz4E=;
	b=ILHviWdZW1Ndg3s445WSS3wfGgD9Tiae8ExYf9pBp5Wnguv5MT/ceyLpxmUdCZdQoAUeSs
	ddWvqnoyLrN/trn5/vXLA6V8wqv7k7kRlCgKO/B9g7RoPJd4kV2XrfoDxMs9vOHEy9S1xg
	8MrRizsgXgCSY2gwC7oEFgcOG2Mg2C0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790794056;
	b=s2j1nt7OQTeWL6AhOtKNGjyQBgyr0h5L57IQXDQWQ5IotSRGkZ0mc6cmkdK42j9tUYAPiY
	dg9WlRFungYMMSmpFM+7FN+Bnuow0wLAavfeGR8Xc+8351SzQQcMPx7pNAHY09ryuvqwtC
	Sl8CLUYICqhXFqEvQCwiVzliaXS0QSA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAsmU2wD;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D111601F0;
	Wed, 30 Sep 2026 18:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E441F00898;
	Wed, 30 Sep 2026 18:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790794055;
	bh=Ov7QGq/mg3vaAJFg5WEdif+xuhC9RlGRRbBlN0+Yz4E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HAsmU2wDDyXvYLWdQkCs2SKv++4dtZzC6ttYPsOxim2ODSpAPm/tvz4cBav4SCZnF
	 14wmk3ZcgpeX5iONBzg5+pHrEEjuozGfNqNPqXbYveMfSG4tZNgRAyqm30+iAmsvyy
	 myAovp8cVTdm2ZcBonTQh3qv9OISAHdGJWnHRLzXF/2+E2EXNHkv7W44jPFS28oJug
	 AbWIKoXO4pgwic6C1Gl8/QnYGenkMoqlxp9soTbO4VjBTKVx1moqUrJ7qzZHeJKlJu
	 F+Fqroie8Yzns0L+fsAeJWRfSSfxiyGW+iYkP+2a129i3F8ppNcgo/ePpXbKANhbH5
	 FtyiTfDYpwxyQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 30 Sep 2026 19:47:10 +0100
Subject: [PATCH v2 2/2] mm/mremap: fix locked_vm leak by splitting VMA for
 MREMAP_DONTUNMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-fix-dontunmap-partial-self-merge-v2-2-f388985a0f0a@kernel.org>
References: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
In-Reply-To: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8051; i=ljs@kernel.org;
 h=from:subject:message-id; bh=RmPHKL0hFSVoI5I9q2hu/CMtvlH0NAiHKpfeInjxFEs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL2RtpmdbavnbRkzbMJTmeKG6qfX2555Oa0ViQ0OPRv0
 O9Z61M5OkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR+1WMDP8WRjrdr3jKt276
 0bOCU1w57jukVASsTFh2q0Hv46yQ9qmMDAcfWNlqvvQ7WsrAJcSSullzQQuXUulP3ufrTTwFdx1
 dyAcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: pmq15ytuf9amte1iibfm5azutchqeztt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 957D3A0005
X-HE-Tag: 1790794056-846672
X-HE-Meta: U2FsdGVkX1+sIwcwUB5SwneM7z8oHCzSpJYPU0LXVmzvk2g89+GL7wBk8MljD+Hu25HMFDF19MmXkcvtG7GxBQiw3zez1H2MavDeUo0hlxIpqrutG6RSWgyWlc/xvJsrMsL6zdpsf/H5siC9Ncqnb4mxZM5hciAT92OZYocthiPBQTWA38JqYvgHbaxEz1VyNhuk6Kz57azrjC+PW7lpbQhEVU9E/z14akRleZWJ3dX4oXf58UIRLQlAhDzHt6zS5mSf/VFBy/3xnKeATRhhOFJFUXLa9G+qHlErU+p44ZNrU0nRDHjMWGWriTeGfR6dgvyAIniAqIostIQF72EQJ9AzZ2Nn2JU1mxzttb+mxSLDIpmhwSSet1xjHh9nm+ABcExaECK8cIqTqg/rXs9jJDvL98eUlTsMkq1sEaZik58OsqkKB7Bt2RYoHM5HX4UGOK/KORtuWv6bTQVNvKhyZ1IWVbFgbS9F0h7rEBZIqbWy8nj2XkLjDjHYRJLKm5BxIiDFf46q2AE9/SkNB/t8F3d3A1qlubRzYI2GU+G4oESEsW+KhC8amP+2e1Up3P3sI/Og2YD/upxopiKC81gTMfg5j9sTFjImYmvSqhkNDXtoo5Vop7kihUGnoFXudv9UES9UtdhwdoPkVz7KxO7hcoo3F2VoOaB/R4Dvsl1pviluyr4+UuAfgEQhO1xcm0X0VNUXZ+D4N+7BUUS1BiTjsCZ0Wj1VeeSGKdO2VdWWfEoEUYdoWbHPYP6YJFxmCCGlAEcxtF/ZkPD16hkuX4kpEPfPuf3b8S60d+FvG0ehfdtQMJaoyQEaGInRHvyDbMnHK1xMQmMCrVnllvCbbtZJm3CqAwxgzY0aEdj4kQb9PZX/xViNei9UqSQhPsXfstlvogLAnnCg9v8V3ePFjVqFpNKt900HSQpi9ztHJSoekeOuw3xGW+qb+odaBdhtLuDt4IuCvSsV/52ORUjtMBk
 l06Gkdgl
 DQQcPqibFFaAtU6f9El/SerVQg3Lwr+RTUlMYQaH4PrRjaumJD/SMMc70Ec6a8sDaQK4bfJlTrsbh9EtkXZPu4hE9rhYoaiVluieK02MDNJwmTzDKiY4qh4JcFEpmslTDP+ZWSULkoe8thDdMcCutr5KKVdm6FZ6XhPVByvc2+pRA8lUZX4/jnuYEw5q7Rjj173f/kqXP34oomJiYS8IwU7D5WKHrGkuSNaFn+o3182CVFvb6XCs2an38kZcAs6YW1icsbln7WMhjRMK8LHI3lMN+Rqcu9P80mzLbrUkkNMZ6Dpn1ujq8adV4hNOxtftw45ly
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - partial copies.

The long-standing mremap() partial VMA logic has the baked-in assumption
that the originating VMA is unmapped and thus moved.

However MREMAP_DONTUNMAP defeats this by performing a partial copy
instead since it keeps the source VMA around.

An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
but the operation can be performed partially:

                           |-----------------|
                           |                 |
                           |                 v
                        <------>          <------>
                        .new_sz.           new_sz
                     |--.------.--|       |------|
                     |  .source.  |       | dest |
                     |--.------.--|       |------|
                     <------------>
                         old_sz

The page tables in the specified range are moved, but the original VMA is
kept intact.

This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
cleared for the entire source VMA and set for the entire destination VMA.

This results in an mm->locked_vm leak as the change is therefore not
accounted correctly.

The clear solution here is to make the portion of the source VMA which is
mremap()'d distinct from the rest of it, a.k.a. split it.

Therefore resolve this issue by splitting it ahead of the rest of the
mremap() operation if the VMA is mlock()'d.

This is valid, as the source VMA will lose its VMA_LOCKED_BIT flag, so if a
partial remap it will become distinct from the rest of the VMA.

In order to make this change re-expose split_vma() in vma.h for
CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
instead).

Finally, update the sys_map_count check to account for this case.

Note that the early check does not use needs_pre_split() - this is because
the VMA has not been looked up by this point, so be conservative and assume
that the VMA is mlock()'d in this case for the purposes of the
sys_map_count check.

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Cc: stable@vger.kernel.org
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----------------
 mm/vma.c    |  4 ++--
 mm/vma.h    |  5 +++++
 3 files changed, 53 insertions(+), 18 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 73f52c45705c..5c72545db175 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1037,6 +1037,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool pre_split,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1088,26 +1089,42 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
 	 * Therefore we must check to ensure we have headroom of 2 additional
 	 * VMAs.
 	 */
-	return map_count + 2 <= sys_map_count;
+	map_count += 2;
+
+	/* If pre-split, the -1 observed above doesn't apply. */
+	if (pre_split)
+		map_count++;
+
+	return map_count <= sys_map_count;
+}
+
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
+	 * source VMA, so split in this case.
+	 */
+	return (vrm->flags & MREMAP_DONTUNMAP) &&
+		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
-static bool check_map_count_against_split(void)
+static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/false);
+		needs_pre_split(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
-static bool check_map_count_against_split_early(void)
+static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/true);
+		vrm->flags & MREMAP_DONTUNMAP, /*before_unmaps=*/true);
 }
 
 /*
- * Perform checks before attempting to write a VMA prior to it being
- * moved.
+ * Perform checks and preparation before attempting to write a VMA prior to it
+ * being moved.
  */
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
@@ -1116,19 +1133,17 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
 	vm_flags_t dummy = vma->vm_flags;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
-	/*
-	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
-	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
-	 * source, which may split, causing a net increase of 2 mappings.
-	 */
-	if (!check_map_count_against_split())
+	/* Avoid failure later on. */
+	if (!check_map_count_against_split(vrm))
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -1146,6 +1161,21 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if (needs_pre_split(vrm)) {
+		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
+
+		if (split_before)
+			err = split_vma(&vmi, vma, old_addr, 1);
+		if (!err && split_after)
+			err = split_vma(&vmi, vma, old_addr + old_len, 0);
+		vrm->vmi_needs_invalidate = true;
+		return err;
+	}
+
 	return 0;
 }
 
@@ -2005,7 +2035,7 @@ static unsigned long do_mremap(struct vma_remap_struct *vrm)
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	if (!check_map_count_against_split_early()) {
+	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
 		return -ENOMEM;
 	}
diff --git a/mm/vma.c b/mm/vma.c
index 55d4d0939129..c8f3d2de6052 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -634,8 +634,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		     unsigned long addr, int new_below)
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index 03ed8afd0c1f..b9b99fa02a86 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -555,6 +555,11 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 unsigned long unmapped_area(struct vm_unmapped_area_info *info);
 unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
 
+#ifdef CONFIG_MMU
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below);
+#endif
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*

-- 
2.55.0


