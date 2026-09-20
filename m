Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B261C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEBFC6B008C; Sun, 20 Sep 2026 10:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E526B0092; Sun, 20 Sep 2026 10:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C3C6B0093; Sun, 20 Sep 2026 10:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD876B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:13:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F08E316048B
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:41 +0000 (UTC)
X-FDA: 85234333842.11.68BCB70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 43C37C0002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxvZxroO;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789913620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSrOUEQX5cEdTjwoeayswD1PWITxAREjqOm5wmTNA7M=;
	b=aE31RnDhZVS0gCcl3PaqEC8rYDHaG7r8BxM+EgWxVmF2OF+qUQwVGf06sVzTO7zEbjP/bV
	nOhMfqjIEd8+eoMIXyvuZv5qnpsCqMOjyZ1P8YD/4rlK7wX1g7uvIlOj06vfhxJU4CS0BI
	Obwp2Es4NyQuly6COad2HukDqoKWM2o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxvZxroO;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789913620;
	b=aXBU+4mQGf/+UDZ1tvmjin3zLf7IAmoPo+pLIJcmFCEEgysSCLQ0dRLoe4cZ8jvAAa2LG2
	ZZdOrYE1O2w7bVDFM5lHfQlTNkq8OqjoWoo2YnjW1zx9kd2cfy2N/mfKhPtrM/b/zFvJmf
	O8ep3PB2CmOkDqbjBtEKARJsDpPtQyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5A3601DB;
	Sun, 20 Sep 2026 14:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D269B1F000FF;
	Sun, 20 Sep 2026 14:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913619;
	bh=xSrOUEQX5cEdTjwoeayswD1PWITxAREjqOm5wmTNA7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nxvZxroOyGkQt3BsmWkXQQ4iPfEvmKakF2Otjj/Ox9xSBb43pEpVMox31SBQ7zzum
	 mcKVc0L3CDb0QcAruI7IS+MsABquxtd8G6hJPEJufUUMsgu69/ebD/uBnwl8OiTz/8
	 1h2cFLuRySdRSGjaCdVOFdQAP4GNAAZsH57aSr7RTCRXILJJgzUUJ9WP4JZbYznSZ6
	 blIuihj6jAMYeN9YmjBEc4/ENED/gRqYflUJXVClt/08zDf/e2nwhIPxBwZci7RRh8
	 75TsGgJhfnf99HugZ77WYn2N1//b98AqHlk/0FazP7KtnzzRHdQR9Z3H6eSsYtgngR
	 7KLL8wWmzWBCg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sun, 20 Sep 2026 15:13:11 +0100
Subject: [PATCH 2/2] mm/mremap: fix locked_vm leak by splitting VMA for
 MREMAP_DONTUNMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9174; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yjmLeTXCkk2mbYGvT4Wqq1IUIfo5bp3zlxd9nUSq81E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWv+JS/l1vKVYZsvrnI4XsS0/faV54flr875Xv3Wv6P
 F53ikfs7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEUu4w/I/Jyjz03GxiTfVu
 zd7ncx5wCVZFnp9d93/RN5X/pQfEE6cw/K/2mpi8wfufQ2KYSeizogbT1C9uvSXOJQ/uFd1U7PR
 sYwAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: c97z77zd86fm5xxo7p1gy9oauhy9z7tp
X-Rspamd-Queue-Id: 43C37C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789913620-944123
X-HE-Meta: U2FsdGVkX18lQ/KvKzk/88rgLTxsHxer+ezlw2w+SjvjJNioiRoSVX8hW+MFNQDLznguSXjNHog+eHHXbQnpQ/AD1d0D99g0Y47qmvBoJ6vhrLgbwwsij3nckOqZWLNMtIfcWqDtIorcoZQOthhHZeoommRbwKPYH4waKqUiX2BcPo/9E/u6GAnEyYnDR8vCyV/+C4xV50mVD3on2sF/zGUklE39Y0jfVhKeTjNF/Cfm2u6c4CNYrKVGd+9+x58q3hYQ8vvogLtJaWOHH9NW7EENlVU9WWwQEEPWVOcoduE8EH0vO3BOQiD0oX6BcWHtE0Nrn0VhBp+iM7D/dhGYoItNoiMM18/5JIMuwUEZg7/YlO2DOt1mLjWSgQPtBeaFlS4W/z7u0TB0KIt8e3Kv6Z+uuUDZjV+g/Oxk/kTUs56yC7w0sMWEwlTfpnkcwKdBdaBTBMftzhik06lOLwTzHW37hwUkbliHASpATkZ8uGF9+Uk0whAJXelnBHFhIiyiSe9pglpe6FbjH9IJTCKiN+z1ZTa+9OcWcUlbe5mOSVxCtzArcw9/M2ImnuFPED1CTi75orZ4nDkr7A8J/HKZ1dG07XI7eWXOzMZQjbHMuLPC0JYgDa1CV+aU/1f6kwQDmijBMuMxrU9WItE4ViDRa4jOHTYKEevKCIcQ0hfVZiqvx12m8IOZ22xXHGAmf3M6tM4vVSZoKGOngsmIma6O1YxThHt8kHRD0LC45ay37Em+2CUW3Jefmz+mpO0oyM+iC5x6LnZaapNLkEKrD+1Vyvoiqjzc3r9aUX7vqCRUE9ASHmvDjtmgYWZg1sAnChPpyC4HpuJB88U7ah4ipqaNvqz86eDwDxN//ro/yo+rxU3jpuEOpKYbB8uZCJCWun5tJ0y1P8G3VEv1YeugSWkHvtX3MwFIwWZo3K4/iA5nrmSIIx5/rspQ+KeTGjj+SNp8WVqNszcl/TXWh166Fcy
 247ZVctm
 aq6QlCeZf3SkwRCZNTZFazVdY0hMwV5qAqaX5quXcpaZC366BDLIhDZATHLA1/cPlOjiqHdCggMWvIbkV/wzOSSRzCYd+EahTbl6uTCzImPfL3G5k1OjPej/0P2+Reu/2IHlLlMJVSdXn667NxEGMe4UMSv9UXtxC4qvFbBC3/PeMopX7sx/Izg7bZZMK/mebrTjKK9AUbeJpYdTs7/z2oTChjqmHOl+bTXrnpLMv9Z4215rcrfgHIdTwPgneo7reh/KgZZJqRRdYhj6md3002zTAIiinPg4jU+rOeaB0fqFBDb4=
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
mremap() operation.

In order to make this change re-expose split_vma() in vma.h for
CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
instead).

A quick search of how MREMAP_DONTUNMAP is used in the wild suggests that
the partial case is either unused or rarely used, so this should not result
in unreasonable VMA proliferation.

Since this makes every mremap() MREMAP_DONTUNMAP operation operate across
an entire, distinct, VMA, also eliminate now-redundant code checking for
this in dontunmap_complete().

Finally, update the sys_map_count check to account for this case.

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 81 ++++++++++++++++++++++++++++++++++++++-----------------------
 mm/vma.c    |  2 +-
 mm/vma.h    |  5 ++++
 3 files changed, 56 insertions(+), 32 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 73f52c45705c..49dc25d8a34d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1037,6 +1037,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool is_dontunmap,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1088,26 +1089,38 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
 	 * Therefore we must check to ensure we have headroom of 2 additional
 	 * VMAs.
 	 */
-	return map_count + 2 <= sys_map_count;
+	map_count += 2;
+
+	/*
+	 * If MREMAP_DONTUNMAP is set and a partial operation is performed,
+	 * the VMA is split ahead of time and the -1 observed above doesn't
+	 * apply.
+	 */
+	if (is_dontunmap)
+		map_count++;
+
+	return map_count <= sys_map_count;
 }
 
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
-static bool check_map_count_against_split(void)
+static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
+					       vrm->flags & MREMAP_DONTUNMAP,
 					       /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
-static bool check_map_count_against_split_early(void)
+static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
+					       vrm->flags & MREMAP_DONTUNMAP,
 					       /*before_unmaps=*/true);
 }
 
 /*
- * Perform checks before attempting to write a VMA prior to it being
- * moved.
+ * Perform checks and preparation before attempting to write a VMA prior to it
+ * being moved.
  */
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
@@ -1116,19 +1129,17 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
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
@@ -1146,6 +1157,21 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time.
+	 */
+	if (vrm->flags & MREMAP_DONTUNMAP) {
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
 
@@ -1330,11 +1356,8 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 static void dontunmap_complete(struct vma_remap_struct *vrm,
 			       struct vm_area_struct *new_vma)
 {
-	unsigned long start = vrm->addr;
-	unsigned long end = vrm->addr + vrm->old_len;
 	struct vm_area_struct *vma = vrm->vma;
-	unsigned long old_start = vma->vm_start;
-	unsigned long old_end = vma->vm_end;
+	const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
 	/* Self-merge is disallowed. */
 	VM_WARN_ON_ONCE(new_vma == vma);
@@ -1346,19 +1369,15 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (start == old_start && end == old_end) {
-		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
-
-		unlink_anon_vmas(vma);
-		/*
-		 * The VMA is now unfaulted and it is an invariant that
-		 * unfaulted anonymous VMAs have page offset equal to
-		 * vma->vm_start >> PAGE_SHIFT.
-		 */
-		vma_set_anon_pgoff(vma, pgoff_unfaulted);
-		if (vma_is_anonymous(vma) && !vma->vm_file)
-			vma_set_pgoff(vma, pgoff_unfaulted);
-	}
+	unlink_anon_vmas(vma);
+	/*
+	 * The VMA is now unfaulted and it is an invariant that
+	 * unfaulted anonymous VMAs have page offset equal to
+	 * vma->vm_start >> PAGE_SHIFT.
+	 */
+	vma_set_anon_pgoff(vma, pgoff_unfaulted);
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		vma_set_pgoff(vma, pgoff_unfaulted);
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
@@ -2005,7 +2024,7 @@ static unsigned long do_mremap(struct vma_remap_struct *vrm)
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	if (!check_map_count_against_split_early()) {
+	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
 		return -ENOMEM;
 	}
diff --git a/mm/vma.c b/mm/vma.c
index 55d4d0939129..92a2fafd66ae 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -634,7 +634,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
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


