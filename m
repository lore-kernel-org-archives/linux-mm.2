Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39DC106F2F4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAD16B0095; Thu, 26 Mar 2026 04:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D266B0096; Thu, 26 Mar 2026 04:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825996B0098; Thu, 26 Mar 2026 04:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8556B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 39330E0DD5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:53 +0000 (UTC)
X-FDA: 84587488146.29.92B226C
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47A7040002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fjtAn8K3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3kenEaQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3kenEaQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUqdYCoBg/kEy42eZkJV8irdcP7MA2fDPdgYAg1G1X4=;
	b=Gaw0Q4KXByuSpbv+UH5Wy71WyfJG0GAQQfHPstJHPIpWwthaEo5+SsS1r5Cb5AIes3coCh
	ToVtV94GX4s4ARzgnPQbPIcpe/+3SRS0+zdONDgM7wqgqmAItKBb9ytzJ0WhAJP9o23toJ
	zv/A9BLy9+3L2+o/mRNI/6b20yp9nzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512531; a=rsa-sha256;
	cv=none;
	b=VyFxFIkk3Nn4PHU7zhcbIkjZLJpNbeRhrgm2Wpre65KFX2szTUVV6Qd9/ZjpWfrV8XQycv
	rCWxdSzrJedli2vrWg99h/CzZtGh1tpPiA19igb5wGJt5zlG733WGibN78lDdpVYYoqmJt
	Km2CPCgStHzMyBcM6UNDoBFPQcbz7ik=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fjtAn8K3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3kenEaQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3kenEaQYKCMwAC9w5ty66y3w.u64305CF-442Dsu2.69y@flex--surenb.bounces.google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12711ec96fbso3104827c88.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512530; x=1775117330; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PUqdYCoBg/kEy42eZkJV8irdcP7MA2fDPdgYAg1G1X4=;
        b=fjtAn8K3BdRfSioZtUZ6HzyU3M65uZOgC0iPPoI5aWdAwxpHO3R1emEC7EUhdgGE9e
         NLXmEeqiBB1WOgiJyxJ7z/pCGZSqYaUB5RjhtjxnW/Vn3g4dUq//ZjvcaGcXqAkbofGr
         3CtX6bruUg+0IQr8xbPrJeNvl0ko27BqSczjdQJjcps89/GrxN7DcmxDkc0QWZK9VX58
         omGMftM4oByNgYVLqxTbOVdkytE9t7ow9bXVuxxhZm57D1e4P/jn2L9Vc2F54W0NC5FV
         OfNW8Z+uK0IKeEIQ4x9RQMxl5o6ju2btxqHwdjP3QefuKxCT2XnaFGVWxUT3Fyc9ZB1T
         slNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512530; x=1775117330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PUqdYCoBg/kEy42eZkJV8irdcP7MA2fDPdgYAg1G1X4=;
        b=fOxi/ba8dwQalV+Eqd8J1A8BopqxI4m8xVW+CjWIkug6OgGC+pGz0sU69TAw8xDkyA
         VwSRE5BeRPch7P+gT8jOXjWJ5GzbSBZ+zrFOyYRcv0cuCiIq/5n91x2Ddnlrk6HcH8Er
         pOd2f9W4HgIl0Pn268MaImI5z1gphosM/LZRqfUp0fjb7pgmLSkcZaUBqFMs/hRQNyfr
         HYpy/pLXunwyftXCwnC9xRQRjsP60d4RK9Yj+ahA2W8xyTMG2HA7gDOYHSusZSQjuy4a
         ig19c9Kv/QfHQ2bXMssQBT/HOo9uLCNU3avGgVzjA2q5jrSc9pTuz1DdmS08SUWb/J9p
         iSSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsf17gqbEFS5aIUkiVNSggTEdRP8zSX4Et+uMH+1JOMFAYcoXfUHhK26B1aXhrSzTrtPSLLH6+Rw==@kvack.org
X-Gm-Message-State: AOJu0YzVHmn1ii8CtuVx/fZtBXojFgM1ahcOL6EjA31pB60DWiP0ldE2
	2PmLmYQd/uD/b8sZyqH711f7DcKy6J9RTtXiBRouOqNs/Qn412VLSsB+coc1xirlB8W3fNt5D++
	FyUvqAw==
X-Received: from dlx24.prod.google.com ([2002:a05:7022:98:b0:12a:6ccc:6d06])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:4387:b0:128:d107:da0f
 with SMTP id a92af1059eb24-12a96e5405cmr4138769c88.10.1774512529879; Thu, 26
 Mar 2026 01:08:49 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:34 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-5-surenb@google.com>
Subject: [PATCH v5 4/6] mm/vma: use vma_start_write_killable() in vma operations
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 47A7040002
X-Stat-Signature: bq56os5t3ksghjusmqa5abqaae9qg7tc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774512531-483052
X-HE-Meta: U2FsdGVkX1/bOwDhmc0Syr9qo94Tu09+YH4yB733hgIHb63iZUdxjVxxYzGsZDHlU0E5glfc9gZEoPNMtinng3N5sfSAKDpIwWk7E1VNviAUSdZeE13kuysAKdRld5cR8KNt8NvgPkrkl2taKud7+4NtdUyaWI4h8buwhq12974adQmMBCybrO457YOmQjG3tz0kCpJG6JXDJK8qy8w2oAUos4ytMaUJ0DPlcw0tWz1rshOGr3C4YoNVGs3Ci0meeEhMaO6RRyuullB6yCKis2QKsItLORi4gyTeTsGNdeYVld30vF3MrnLEkavQRb0c2/2mLBfPfNaRlBiVnc3XOOjjdoOFT/gYLj19IL5ijs7Zcr+HUIvpKKoeCATLA7zgp7WcKz6hVrM/nddrGnpvNxn6U2sy4kjX1Ea3fXKBoDS1MJYCoQkFnGteqaYwZc0LnA0MtFJ6zkm4Da/T2Y+ErH6lLMK5VLzPP+pLV+yUAP7Jqzb+/IfCwK/lDnIEYBuRPTD7rOcY1ifRNXeHR3/IfpkFdMx8sWfUIORkeVZ3W69fHv4BK8hCdEX89VCgClURHkYDybgNHIvsTMT0m6d1Vtk6pFKkHmt4gXqruvBdXdFNvNKsXMp6qOu5pM5CZ2A9hiG2Bc7U5sco8VpwYnYvw8K4m1PCZhVKcXvV5NNg3lfbWD2SZi+C0kBGMpZGJYOwPU26DxVMszNl0rrvF171BZr+UNyhf7G7Ol9aWwSYawe2VD8Ve+ealFyTvnE+Szlv03d7pULbI760j0/jOzAccjhW/yhsIwUdAKpH5Ee9RMwIKBIw8bBey3imvSLAnSbRI1gbbh3xf7bcXvPfJ+2zEc66uDOvcBs+6wMJmLPACItoJu8hF246FjhlSmgskOpkS1udX/NSigRH8AFesXMV71+Mcky5pWq5n6+kWmjU2b/De31C2v8kmYKKXXo24bDsoAM0hZX4TshHqholJMP
 4bHzZeJv
 mEaIZSrP0fz/5Tt0HImvxP3rgEpUVTAPMmvOkoypEiIurXQP1rcXHrGT6qP6+ZAAWn3fexcmhiBLPlYQL6yZ14Kp7HfZXEDWojng4qqZwUHlJeVsHhpCHeewTVrOjqLuGE6WMsPMBqN0Me7eTtIOI57N3rhLLYFpkgynphGOb9SISKdxqd9ovcGD+Ya05zKss0kYEKzL21Yulp2sJTrGU+O5XGMygqRZsFuT+Tmz4+yLeJWtah7AUUEtSmi1RF+z5cMlOpFwGOzqqWK2JhFDXJPj71h+pcQZXsnG8LRkrIYlppvb1qbilVAAbUTlYpg4IrNIq1g3/KKTG4tBV5mBya6Zv8nkhmoClxTfnSjUK+kz+0uSRdfZfoAO1SDzfrEgg44ysPCcCMjbD/Kqld136/r6KMrpYI/0YF0qCZUhUP05uoV0Uz8a3D99eKIq7Hkjh28Kq9yVkpXLLWHC9i8sqJBBBs3kUxdwqAvkFmzwu1RhXuR7ya0D2QoPd5rEdeuSthu0XtmNZ6vAjQvO507jz9Kle1Jmz9YZ73O713CL9KHK51kGn7/qLt/4GX04Z0+/nFQ6zrZgMwHgjUd5jzilhVtRcdRX0JTxknUSfQhvYugiRJci1vzTCr8RcEtFu3dkTRArC3c1fCyU70Q5WW7Lb4mEXOglwMouWRL0Z+dKio5tUTDfM1jfcI1+IdR/oOQDOO3JZpfn/K8D0tWMAj+qzCv3rWu7RMben0giAL+PkslzO5G83GHFXAvmUuXIN1mK2uKE/ZjY2Es8oA5lOi9xsVJ3+bbLpTmRY7HF03tiKY9NWHuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() calls when we operate on VMAs.

In a number of places we now lock VMA earlier than before to avoid
doing work and undoing it later if a fatal signal is pending. This
is safe because the moves are happening within sections where we
already hold the mmap_write_lock, so the moves do not change the
locking order relative to other kernel locks.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vma.c      | 130 +++++++++++++++++++++++++++++++++++++-------------
 mm/vma_exec.c |   6 ++-
 2 files changed, 101 insertions(+), 35 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index ba78ab1f397a..7ee68fbfea03 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -524,6 +524,17 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
+	/*
+	 * Lock VMAs before cloning to avoid extra work if fatal signal
+	 * is pending.
+	 */
+	err = vma_start_write_killable(vma);
+	if (err)
+		goto out_free_vma;
+	err = vma_start_write_killable(new);
+	if (err)
+		goto out_free_vma;
+
 	err = -ENOMEM;
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
 	if (vma_iter_prealloc(vmi, new))
@@ -543,9 +554,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
-	vma_start_write(new);
-
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
@@ -900,12 +908,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	}
 
 	/* No matter what happens, we will be adjusting middle. */
-	vma_start_write(middle);
+	err = vma_start_write_killable(middle);
+	if (err) {
+		/* Ensure error propagates. */
+		vmg->give_up_on_oom = false;
+		goto abort;
+	}
 
 	if (merge_right) {
 		vma_flags_t next_sticky;
 
-		vma_start_write(next);
+		err = vma_start_write_killable(next);
+		if (err) {
+			/* Ensure error propagates. */
+			vmg->give_up_on_oom = false;
+			goto abort;
+		}
 		vmg->target = next;
 		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
 		vma_flags_set_mask(&sticky_flags, next_sticky);
@@ -914,7 +932,12 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (merge_left) {
 		vma_flags_t prev_sticky;
 
-		vma_start_write(prev);
+		err = vma_start_write_killable(prev);
+		if (err) {
+			/* Ensure error propagates. */
+			vmg->give_up_on_oom = false;
+			goto abort;
+		}
 		vmg->target = prev;
 
 		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
@@ -1170,10 +1193,12 @@ int vma_expand(struct vma_merge_struct *vmg)
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
 	vma_flags_t target_sticky;
-	int err = 0;
+	int err;
 
 	mmap_assert_write_locked(vmg->mm);
-	vma_start_write(target);
+	err = vma_start_write_killable(target);
+	if (err)
+		return err;
 
 	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
 
@@ -1201,6 +1226,13 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
 	if (remove_next) {
+		/*
+		 * Lock the VMA early to avoid extra work if fatal signal
+		 * is pending.
+		 */
+		err = vma_start_write_killable(next);
+		if (err)
+			return err;
 		err = dup_anon_vma(target, next, &anon_dup);
 		if (err)
 			return err;
@@ -1214,7 +1246,6 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (remove_next) {
 		vma_flags_t next_sticky;
 
-		vma_start_write(next);
 		vmg->__remove_next = true;
 
 		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
@@ -1252,9 +1283,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
+	err = vma_start_write_killable(vma);
+	if (err)
+		return err;
+
 	if (vma->vm_start < start)
 		vma_iter_config(vmi, vma->vm_start, start);
 	else
@@ -1263,8 +1299,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
-	vma_start_write(vma);
-
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, NULL);
@@ -1453,7 +1487,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			if (error)
 				goto end_split_failed;
 		}
-		vma_start_write(next);
+		error = vma_start_write_killable(next);
+		if (error)
+			goto munmap_gather_failed;
 		mas_set(mas_detach, vms->vma_count++);
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -1848,12 +1884,16 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
+	int err;
+
+	err = vma_start_write_killable(vma);
+	if (err)
+		return err;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_start_write(vma);
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
 	mm->map_count++;
@@ -2239,9 +2279,8 @@ int mm_take_all_locks(struct mm_struct *mm)
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (signal_pending(current) || vma_start_write_killable(vma))
 			goto out_unlock;
-		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
@@ -2540,8 +2579,8 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
 	struct vma_iterator *vmi = map->vmi;
-	int error = 0;
 	struct vm_area_struct *vma;
+	int error;
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -2552,6 +2591,14 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	if (!vma)
 		return -ENOMEM;
 
+	/*
+	 * Lock the VMA early to avoid extra work if fatal signal
+	 * is pending.
+	 */
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free_vma;
+
 	vma_iter_config(vmi, map->addr, map->end);
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
 	vma->flags = map->vma_flags;
@@ -2582,8 +2629,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
 #endif
 
-	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma, action->hide_from_rmap_until_complete);
@@ -2878,6 +2923,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
+	int err;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2910,24 +2956,33 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 		if (vma_merge_new_range(&vmg))
 			goto out;
-		else if (vmg_nomem(&vmg))
+		if (vmg_nomem(&vmg)) {
+			err = -ENOMEM;
 			goto unacct_fail;
+		}
 	}
 
 	if (vma)
 		vma_iter_next_range(vmi);
 	/* create a vma struct for an anonymous mapping */
 	vma = vm_area_alloc(mm);
-	if (!vma)
+	if (!vma) {
+		err = -ENOMEM;
 		goto unacct_fail;
+	}
 
 	vma_set_anonymous(vma);
 	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vma->flags = vma_flags;
 	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
-	vma_start_write(vma);
-	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
+	if (vma_start_write_killable(vma)) {
+		err = -EINTR;
+		goto vma_lock_fail;
+	}
+	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL)) {
+		err = -ENOMEM;
 		goto mas_store_fail;
+	}
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -2942,10 +2997,11 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	return 0;
 
 mas_store_fail:
+vma_lock_fail:
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -3112,8 +3168,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
-	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
+	int error;
 
 	if (!vma_test(vma, VMA_GROWSUP_BIT))
 		return -EFAULT;
@@ -3149,12 +3205,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto vma_prep_fail;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto vma_lock_fail;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3183,8 +3241,10 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
 	validate_mm(mm);
+vma_lock_fail:
+vma_prep_fail:
+	vma_iter_free(&vmi);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP */
@@ -3197,8 +3257,8 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
+	int error;
 
 	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 		return -EFAULT;
@@ -3228,12 +3288,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto vma_prep_fail;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto vma_lock_fail;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3263,8 +3325,10 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
 	validate_mm(mm);
+vma_lock_fail:
+vma_prep_fail:
+	vma_iter_free(&vmi);
 	return error;
 }
 
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 5cee8b7efa0f..8ddcc791d828 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -41,6 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -56,8 +57,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * cover the whole range: [new_start, old_end)
 	 */
 	vmg.target = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
+	err = vma_expand(&vmg);
+	if (err)
+		return err;
 
 	/*
 	 * move the page tables downwards, on failure we rely on
-- 
2.53.0.1018.g2bb0e51243-goog


