Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25568CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 22:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EEC6B0088; Wed, 30 Sep 2026 18:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA326B008A; Wed, 30 Sep 2026 18:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA35E6B008C; Wed, 30 Sep 2026 18:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABCE76B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 18:21:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 760A11C22D3
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 22:21:43 +0000 (UTC)
X-FDA: 85271851686.26.8733855
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4A4AC0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 22:21:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KuVGLKbx;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790806901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKOEly26QwsjTOxELJ9kv4BjxWIGBNW52EqhkHZYQvo=;
	b=heprMFizC+DFL5t1zdAOQThjCWyBYOmtKsT1vDy8DCXbYf3Wnywt+tUGrNs99q2tzKnnyL
	KQuakYk5ODknKHQ8CauJvADSAufM+l2VoZjcF8v4D5Tb5js1qgdef7j07TKxzVTwjyTiAm
	oWmmaoSly8SRJ5UB0FMW3LUEC6L7J0A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KuVGLKbx;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790806901;
	b=nfHEyCS/lnVtPy5GTNFaXx0iOYdYouyFqY9dyxiI2Ybqxyja5TWflfaoZUkP/2VsLeddRQ
	iIO/9EZG6Wiq+kDDIUgY3ADXe8RYaNUBZ3voiDgKoG6XggFud81HVZOSxGoM2mKE4R1HJO
	++AkxAYA3NjtCGiKVhMMJChJEPPVYm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 236BE43A8F;
	Wed, 30 Sep 2026 22:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8DA1F000FF;
	Wed, 30 Sep 2026 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790806900;
	bh=IKOEly26QwsjTOxELJ9kv4BjxWIGBNW52EqhkHZYQvo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KuVGLKbxKkvwypB/qMaVW0IqYJBeq7a3q8gHRIRZWTVgA4JjsbVFTHP3C1+i7LCza
	 ur+WSQvchGa6gu5sKk812nUMfWKZugQavpocZ8NjjkxUbdqYK9jbo3DLZJXX6cWkwO
	 7jXENUVygR56Og/yTSUQ/bJh5VLuunvUAsTvwTlo=
Date: Wed, 30 Sep 2026 15:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Brian Geffon <bgeffon@google.com>, Minchan Kim
 <minchan@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Anirudh Srinivasan
 <asrinivasan@oss.tenstorrent.com>, stable@vger.kernel.org,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-Id: <20260930152139.e8fc193b9c2880b625fda814@linux-foundation.org>
In-Reply-To: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
References: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A4A4AC0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: od1n86ycucu8k9j3ezgfnta4eyaxuztt
X-HE-Tag: 1790806901-386932
X-HE-Meta: U2FsdGVkX1/a9zqkAeFoG5VFpSsb6M+MZBXq4wSFie4LtRbTBtZre5QpY0g3eP3KhzitimjbcFFPktGNGVKQIoJ9m29I+S7zR8b0VEZny53EK8TE5pRCKV8UyJbXWlKf20Mbu2/ypKAaGqvYRbxianrcz2yyejac8zRr6m3K362VuyIG+LjaJ71yX1lrBYxL/l1xSR7VZ0rrWHvLXWtMbxMczyugQA5rwwyMjZzSdCAAaGyupnzkCxprmTE92x9gSxxy+ZpVnuUyoQ/2efQTV7hcqHCnLH0CBcZSzfv/LiQ6zjooUk8WFmhwe13gWnV4NJ4q4ZUCE3PJ7DZJi5MUuka8aqvo+yJVN7R6n37IyKuMX8G3aBFNeXEkXfqHMAhfa/6KqkjjS9/YOa6/D2QYdEbtmdge+pLrFb4WT0hZXPXG1wUuGMjFhXoV5gg82ryU8lztogAXvjR/wMNggaVMtxKnJ3/z1qFCF7iBs6ZhdQKEd9WcXZuspbgKbaCwxRWpZEBRwNQ5PdXLzLFsnKTFl0y11H6RBiFl+/1Ggi3jw2v2NbIdb7L7gcq/cZGL7ck6qrkMwgH8a/GB6igLstTGnL6XcEGvo60l3BrgXMPKmQcywDX0QqnbYJ6173qV0YWKc2iqHjygtzHxqGxh0uIZCg6w0kbsyHFmV3CJx1rQkd7xcuAt2T2thnjmiz4U3+GEfCHYhhdajvdP0O1b4JhMWPEce3FvQoOJh/w5KSKOYkFQwd/3kN+cv85da2WBFHSdBVELJBbuPqohnJl3JMsg9J8Uf+er8FDrN7ZuvMMhL95VmgIklRSIZrSk3POcw7F5tgkDsj1Y7bKM2wtcIQr4ZTaMqaFLcy9mr44f8JCw0JUpZRhKobuK6iMNge4L9m/JhfTmqnuq+D1tJCEiNn0Ul3+K2hb0mdV1sm2gMGSCsU+H4qzjj9SdArC0hXKILYJOGvc6Q6rEF6+WKx9Q6z6
 OxZJgjtT
 HzGDAdMvxGDexqQ8uCLhRHLfeNGK7Z2x5LU69qOi23nQQTnMem+zBSR92A+T3M2fuhs9XZjbCdQhJc6/8Ca6m5oOHZ0maW5zO87IjW4iO1W9uBMca17yLHXe6mapkLKkefPOmvK0ZWR3lPFy0kgdgpEFov2WZy2gAKsfpXBRgiWM/GQWatWdm/VINW+LFyHqU3wZQd5tln58jNXiwgiHSx/NX3tP3NqmPcI7+SHqirAia/xbJQ4Qj2q3XtjFQB1VPmJ71BkGkU/JpUUR5W8bF1bVY4JUXYC2yfcviH/ugM3nGf5Trru2khr0ErL4C/XoNbcgst0q34xkezhWYGXEET8ZHCsZh6uSfG1jwMMr8hRykb1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 19:47:08 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> Commit 397432cab17b ("mm/mremap: account mm->locked_vm correctly for
> MREMAP_DONTUNMAP") fixed an accidentally introduced bug around
> mm->locked_vm accounting, but this wasn't the only issue.
> 
> And thus history repeats itself, as it turns out that mm->locked_vm
> accounting is broken by MREMAP_DONTUNMAP yet again by two further cases,
> and has been broken ever since the feature was introduced.
> 
> Both relate to the fact that VMA_LOCKED_BIT is cleared on the source
> VMA (it has to be as all page tables are moved):
> 
> 1. If an unfaulted VMA_LOCKONFAULT_BIT anonymous VMA self-merges it
>    clears the VMA_LOCKED_BIT flag and permanently leaks mm->locked_vm
>    pages.
> 
> 2. If a partial mremap() is performed on a locked VMA there is a leak equal
>    to the number of pages not copied.
> 
> (Both for MREMAP_DONTUNMAP operations only)
> 
> Both issues can be fixed by treating the source range as distinct from the
> destination range, which is the definition of what MREMAP_DONTUNMAP does so
> is appropriate.

Thanks, updated.

> v2:
> * Added tags (thanks everybody!)
> * Updated 2/2 to avoid splitting the VMA if the VMA was not mlock()'d. It
>   is only meaningful and necessary to perform the split in this case. This
>   also fixes the proc_maps_race selftests that broke, as reported by
>   Anirudh.

Here's how v2 altered mm.git's mm-hotfixes-unstable branch.  Quite a
large change - are you sure that retaining the tags was appropriate?


 mm/mremap.c |   57 +++++++++++++++++++++++++++++---------------------
 mm/vma.c    |    2 -
 2 files changed, 35 insertions(+), 24 deletions(-)

--- a/mm/mremap.c~b
+++ a/mm/mremap.c
@@ -1037,7 +1037,7 @@ static void vrm_stat_account(struct vma_
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
-					    bool is_dontunmap,
+					    bool pre_split,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1091,31 +1091,35 @@ static bool __check_map_count_against_sp
 	 */
 	map_count += 2;
 
-	/*
-	 * If MREMAP_DONTUNMAP is set and a partial operation is performed,
-	 * the VMA is split ahead of time and the -1 observed above doesn't
-	 * apply.
-	 */
-	if (is_dontunmap)
+	/* If pre-split, the -1 observed above doesn't apply. */
+	if (pre_split)
 		map_count++;
 
 	return map_count <= sys_map_count;
 }
 
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
+	 * source VMA, so split in this case.
+	 */
+	return (vrm->flags & MREMAP_DONTUNMAP) &&
+		vma_test(vrm->vma, VMA_LOCKED_BIT);
+}
+
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
 static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       vrm->flags & MREMAP_DONTUNMAP,
-					       /*before_unmaps=*/false);
+		needs_pre_split(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
 static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       vrm->flags & MREMAP_DONTUNMAP,
-					       /*before_unmaps=*/true);
+		vrm->flags & MREMAP_DONTUNMAP, /*before_unmaps=*/true);
 }
 
 /*
@@ -1159,9 +1163,9 @@ static unsigned long prep_move_vma(struc
 
 	/*
 	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
-	 * case perform any split ahead of time.
+	 * case perform any split ahead of time for an mlock()'d VMA.
 	 */
-	if (vrm->flags & MREMAP_DONTUNMAP) {
+	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 
 		if (split_before)
@@ -1356,8 +1360,11 @@ static int copy_vma_and_data(struct vma_
 static void dontunmap_complete(struct vma_remap_struct *vrm,
 			       struct vm_area_struct *new_vma)
 {
+	unsigned long start = vrm->addr;
+	unsigned long end = vrm->addr + vrm->old_len;
 	struct vm_area_struct *vma = vrm->vma;
-	const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+	unsigned long old_start = vma->vm_start;
+	unsigned long old_end = vma->vm_end;
 
 	/* Self-merge is disallowed. */
 	VM_WARN_ON_ONCE(new_vma == vma);
@@ -1369,15 +1376,19 @@ static void dontunmap_complete(struct vm
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	unlink_anon_vmas(vma);
-	/*
-	 * The VMA is now unfaulted and it is an invariant that
-	 * unfaulted anonymous VMAs have page offset equal to
-	 * vma->vm_start >> PAGE_SHIFT.
-	 */
-	vma_set_anon_pgoff(vma, pgoff_unfaulted);
-	if (vma_is_anonymous(vma) && !vma->vm_file)
-		vma_set_pgoff(vma, pgoff_unfaulted);
+	if (start == old_start && end == old_end) {
+		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
+		unlink_anon_vmas(vma);
+		/*
+		 * The VMA is now unfaulted and it is an invariant that
+		 * unfaulted anonymous VMAs have page offset equal to
+		 * vma->vm_start >> PAGE_SHIFT.
+		 */
+		vma_set_anon_pgoff(vma, pgoff_unfaulted);
+		if (vma_is_anonymous(vma) && !vma->vm_file)
+			vma_set_pgoff(vma, pgoff_unfaulted);
+	}
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -635,7 +635,7 @@ out_free_vma:
  * either for the first part or the tail.
  */
 int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		     unsigned long addr, int new_below)
+	      unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
_


