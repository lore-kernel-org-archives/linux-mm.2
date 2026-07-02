Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F71C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA9F6B00BB; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8316B00BE; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7717C6B00BD; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34E166B00B9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D97E140196
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:07:37 +0000 (UTC)
X-FDA: 84944316954.30.97EC1DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1EF4340003;
	Thu,  2 Jul 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZKUR0qn;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783008455;
	b=oNEvYvijPvPJC4R43bcchO9r4BFNUVoguh3XM0PJaSdpZjLiY06YU0I0xYtdx45Yz5MiHN
	+3bPn9x1HRyQswsZ8prD+ausbxyirchIVwhKrD7oGcJuueMEFH1ZQM9qNglcEg4nVMxXy0
	WG+JXohr+QOoHuSyo/2TGjmY+13OOl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783008455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfvR3Muaq7o+afYbXjsDSvqRy7FxUVckvz1k4Hxbez0=;
	b=yug90fv/5N9XKDdlFc75K62LiIASKqN4TUzhdtAOoqEh351le/e8m4AM7ZX0MCbbdbyUzR
	ZDWznvDwg4k90NpWjySUuAhNS/9L/0FCvB0pGSga9ZRHGM6SUnBYtlqp0U3iaBbK4Oh8I1
	OfNQuWuarv+/KhFBEkQhiGG3k5uvj8s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RZKUR0qn;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E840C43BB8;
	Thu,  2 Jul 2026 16:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8A31F000E9;
	Thu,  2 Jul 2026 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783008453;
	bh=TfvR3Muaq7o+afYbXjsDSvqRy7FxUVckvz1k4Hxbez0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RZKUR0qnMCX1lVPMLegWDJwvMR3XwPOjgqmuDlY8+1sNyGBX6G0WNkOyriJ+PtG6y
	 WoL1rkJ4u0k6Z/pcI27Q9cfN5qit8W5zrOm26I9VdyLr6cW2bUvNsdF/9cAdED/TO5
	 AhCJxe7BVGNUURRd3IeizZOkboEYr9oFtXUUDXIMY549O+sfZleE5cdwLHHY1Mnd5w
	 fUEwk8w3Bqh1uArvHx8Wkw0ChPSb59uuaQpmYgj0hIESSw8+X4zGBfFv8Mg5ixvDOI
	 z8XtFU+Dq4mFlmkaOHGXh7hbxcLj3TzRDApEJrIOyiLSNEjyj9JwDrdlVKeNPP3pCm
	 r9BU9h8EBQzqg==
Date: Thu, 2 Jul 2026 17:07:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com, 
	kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org, 
	jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
	tursulin@ursulin.net, robin.clark@oss.qualcomm.com, lumag@kernel.org, lyude@redhat.com, 
	dakr@kernel.org, tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, 
	heiko@sntech.de, andy.yan@rock-chips.com, thierry.reding@kernel.org, 
	mperttunen@nvidia.com, jonathanh@nvidia.com, kraxel@redhat.com, 
	dmitry.osipenko@collabora.com, zack.rusin@broadcom.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com, deller@gmx.de, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, hughd@google.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de, 
	kees@kernel.org, perex@perex.cz, tiwai@suse.com, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
	etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 13/13] mm/mremap: convert mremap code to use vma_flags_t
Message-ID: <akaJx8Zt8kazlrjq@lucifer>
References: <380f761d35a3faa4370f8b3f92e3d4af3d4c7110.1782760670.git.ljs@kernel.org>
 <20260702134947.25189-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702134947.25189-1-lance.yang@linux.dev>
X-Stat-Signature: njiqr3wi5sk6h7f7e65eo45uou1upjuu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EF4340003
X-HE-Tag: 1783008454-611177
X-HE-Meta: U2FsdGVkX1+EEb63z/fAuTmhwcz+AG1z5CFONSpbp9SU9hZSTDgY4dEc83EjJzQkmZZKTWYEQwDRwnM4K7+zZiyAfphnHpjEsQ1fmMYHjhhPpkiTX9/MPYLzq8OtJfquWpznsQL9V80qTL1NDOfbxOPiN9Urs0MZe72cFITh0RVkfHCsvMdtYMLOg2dVeTIofkP8XByANfSh660IRX7wr89fwvZb2nJ3EPbo65SAU72fh/mb7gaEUKYFrQeD5VQ7ghHipvK1o/f/J59IaorAm+isFhjHkTw+qPydMpCx1i6LCeC4y0kOtdgf3CJWCxKnv1ZOCjf4iZBBFho1QI1rnQZmbhq22bH1caBUo+hGh6pO5kShdi7Dm/0rW1T3vxX0R43JgLYMf3ChxRM6cJP0k7cy7ULlMuum6ruN50SvY8J++b7Q+hUHaMj0eab668qywDpjdHA9Ur2eXPufm73b+A/2nlzE4ycjFm0L5ph+WZXxrJT+46oLkZoQrhylut0yay/+hcSNgvENkGOmyiHQPqm9G89sgJp9GLseMj8T5LWKnQkWhZeLRQLVSOWNBCgb3m5KOtbZ5hT2P4flnCN+0BXtdQk7fe2ttZ6EVVlNEujxRxVK1pKdi8fHNes4tcIedX6t68nr1fXSbnTYLrk8qi0YK08f+RR69GOnCO4dBjly7FW1E43aOHcQ/Zjp1BbpxAeZ9w7Dw217cmhGO1oQCZEd6dDexIw3A7r/3jLD10It7vF5dzulr+5QmNszBBkHf45cwNbaLN4u66BXYw8RwPUVIM11UW27qNEk5jUVv2dUx1bAR52Yoc+3P6LthTpV9KqhSPl8cPG9RtzCmAUnmexMW8+AjOMk+DXwcWeD8EECwpvRi4lUGUtL2I3tI4nQzaZ0cJOJarjuZ1EFLa93mjd0tLp7YphAPnwbCFF4zT8u+vuJJPw6r3MUJP3gdcBHBruJBjw0g4UWhSJTwBt
 23SYFW6O
 ab3gMZ99KXjs9vGYO3JAwiWH3sOPYp3BCOvSG/aOnlEOvIXHgIcQmkJJC78lvJk2NadefMFdZ/6NgugZ7qRSobtjqTebyTm2vdq5caT5i3kTewCHOTNJXjdo+LfSA0H8p2KR3r51Ykl8j/zJCIyG7axA8RJotGSR7MNtyVOvY18wC5/qDRtBseWY4M/YT8vD6z95QUMIHAwN2+lhxlHggxzwj+l8OAtw9DUF3n1cKUFju2rxY2w0Uly49FesFC2UP1X65nUQSRgz6o275yMXGFPW72mHeahyPgVDLlCwbWrmqfUvUbjUxLo3m0CiuMnPmiF0v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:49:47PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:36PM +0100, Lorenzo Stoakes wrote:
> >Replace use of the legacy vm_flags_t flags with vma_flags_t values
> >throughout the mremap logic.
> >
> >Additionally update comments to reflect the changes to be consistent.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
>
> The vm_flags_set() cases below spell out vma_start_write(), but the
> vm_flags_clear() cases don't?

Yep as I said elsewhere, implicitly taking the lock is terrible and me doing
this is completely on purpose to get rid of that :)

But I haven't been clear enough clearly, so I should put the argument as to why
that's ok in the commit message.

Will do so on respin.

>
> Thanks, Lance
>
> > mm/mremap.c | 38 ++++++++++++++++++++------------------
> > 1 file changed, 20 insertions(+), 18 deletions(-)
> >
> >diff --git a/mm/mremap.c b/mm/mremap.c
> >index 079a0ba0c4a7..0ea43302b7ed 100644
> >--- a/mm/mremap.c
> >+++ b/mm/mremap.c
> >@@ -68,7 +68,7 @@ struct vma_remap_struct {
> > 	bool populate_expand;		/* mlock()'d expanded, must populate. */
> > 	enum mremap_type remap_type;	/* expand, shrink, etc. */
> > 	bool mmap_locked;		/* Is mm currently write-locked? */
> >-	unsigned long charged;		/* If VM_ACCOUNT, # pages to account. */
> >+	unsigned long charged;		/* If VMA_ACCOUNT_BIT, # pgs to account */
> > 	bool vmi_needs_invalidate;	/* Is the VMA iterator invalidated? */
> > };
> >
> >@@ -954,7 +954,7 @@ static unsigned long vrm_set_new_addr(struct vma_remap_struct *vrm)
> >
> > 	if (vrm->flags & MREMAP_FIXED)
> > 		map_flags |= MAP_FIXED;
> >-	if (vma->vm_flags & VM_MAYSHARE)
> >+	if (vma_test(vma, VMA_MAYSHARE_BIT))
> > 		map_flags |= MAP_SHARED;
> >
> > 	res = get_unmapped_area(vma->vm_file, new_addr, vrm->new_len, pgoff,
> >@@ -976,7 +976,7 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
> > {
> > 	unsigned long charged;
> >
> >-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
> >+	if (!vma_test(vrm->vma, VMA_ACCOUNT_BIT))
> > 		return true;
> >
> > 	/*
> >@@ -1003,7 +1003,7 @@ static bool vrm_calc_charge(struct vma_remap_struct *vrm)
> >  */
> > static void vrm_uncharge(struct vma_remap_struct *vrm)
> > {
> >-	if (!(vrm->vma->vm_flags & VM_ACCOUNT))
> >+	if (!vma_test(vrm->vma, VMA_ACCOUNT_BIT))
> > 		return;
> >
> > 	vm_unacct_memory(vrm->charged);
> >@@ -1023,7 +1023,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
> > 	struct vm_area_struct *vma = vrm->vma;
> >
> > 	vm_stat_account(mm, vma->vm_flags, pages);
> >-	if (vma->vm_flags & VM_LOCKED)
> >+	if (vma_test(vma, VMA_LOCKED_BIT))
> > 		mm->locked_vm += pages;
> > }
> >
> >@@ -1167,7 +1167,7 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
> > 	 * arose, in which case we _do_ wish to unmap the _new_ VMA, which means
> > 	 * we actually _do_ want it be unaccounted.
> > 	 */
> >-	bool accountable_move = (vma->vm_flags & VM_ACCOUNT) &&
> >+	bool accountable_move = vma_test(vma, VMA_ACCOUNT_BIT) &&
> > 		!(vrm->flags & MREMAP_DONTUNMAP);
> >
> > 	/*
> >@@ -1186,7 +1186,7 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
> > 	 * portions of the original VMA that remain.
> > 	 */
> > 	if (accountable_move) {
> >-		vm_flags_clear(vma, VM_ACCOUNT);
> >+		vma_clear_flags(vma, VMA_ACCOUNT_BIT);

This is called from move_vma() which holds the VMA write lock on vma.

> > 		/* We are about to split vma, so store the start/end. */
> > 		vm_start = vma->vm_start;
> > 		vm_end = vma->vm_end;
> >@@ -1211,8 +1211,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
> > 	 * |             |
> > 	 * |-------------|
> > 	 *
> >-	 * Having cleared VM_ACCOUNT from the whole VMA, after we unmap above
> >-	 * we'll end up with:
> >+	 * Having cleared VMA_ACCOUNT_BIT from the whole VMA, after we unmap
> >+	 * above we'll end up with:
> > 	 *
> > 	 *    addr  end
> > 	 *     |     |
> >@@ -1232,13 +1232,15 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
> > 		if (vm_start < addr) {
> > 			struct vm_area_struct *prev = vma_prev(&vmi);
> >
> >-			vm_flags_set(prev, VM_ACCOUNT); /* Acquires VMA lock. */
> >+			vma_start_write(prev);
> >+			vma_set_flags(prev, VMA_ACCOUNT_BIT);
> > 		}
> >
> > 		if (vm_end > end) {
> > 			struct vm_area_struct *next = vma_next(&vmi);
> >
> >-			vm_flags_set(next, VM_ACCOUNT); /* Acquires VMA lock. */
> >+			vma_start_write(next);
> >+			vma_set_flags(next, VMA_ACCOUNT_BIT);

These need vma_start_write() as referencing other, unlocked VMAs.

> > 		}
> > 	}
> > }
> >@@ -1321,8 +1323,8 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
> > 	unsigned long old_start = vrm->vma->vm_start;
> > 	unsigned long old_end = vrm->vma->vm_end;
> >
> >-	/* We always clear VM_LOCKED[ONFAULT] on the old VMA. */
> >-	vm_flags_clear(vrm->vma, VM_LOCKED_MASK);
> >+	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> >+	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
-
Same as above, called from move_vma() with VMA write lock held.

> >
> > 	/*
> > 	 * anon_vma links of the old vma is no longer needed after its page
> >@@ -1758,14 +1760,14 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
> > 	 * based on the original.  There are no known use cases for this
> > 	 * behavior.  As a result, fail such attempts.
> > 	 */
> >-	if (!old_len && !(vma->vm_flags & (VM_SHARED | VM_MAYSHARE))) {
> >+	if (!old_len && !vma_test_any(vma, VMA_SHARED_BIT, VMA_MAYSHARE_BIT)) {
> > 		pr_warn_once("%s (%d): attempted to duplicate a private mapping with mremap.  This is not supported.\n",
> > 			     current->comm, current->pid);
> > 		return -EINVAL;
> > 	}
> >
> > 	if ((vrm->flags & MREMAP_DONTUNMAP) &&
> >-			(vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)))
> >+	    vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
> > 		return -EINVAL;
> >
> > 	/*
> >@@ -1795,7 +1797,7 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
> > 		return 0;
> >
> > 	/* We are expanding and the VMA is mlock()'d so we need to populate. */
> >-	if (vma->vm_flags & VM_LOCKED)
> >+	if (vma_test(vma, VMA_LOCKED_BIT))
> > 		vrm->populate_expand = true;
> >
> > 	/* Need to be careful about a growing mapping */
> >@@ -1803,10 +1805,10 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
> > 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
> > 		return -EINVAL;
> >
> >-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> >+	if (vma_test_any(vma, VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT))
> > 		return -EFAULT;
> >
> >-	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, vrm->delta))
> >+	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT), vrm->delta))
> > 		return -EAGAIN;
> >
> > 	if (!may_expand_vm(mm, &vma->flags, vrm->delta >> PAGE_SHIFT))
> >--
> >2.54.0
> >
> >

Cheers, Lorenzo

