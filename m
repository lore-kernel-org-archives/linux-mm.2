Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450A3CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBFD6B0098; Thu, 28 May 2026 09:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACEB6B009B; Thu, 28 May 2026 09:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674136B009D; Thu, 28 May 2026 09:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF176B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:31:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8AC0CC2984
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:31:09 +0000 (UTC)
X-FDA: 84816914658.25.56B9CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C2300180011
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:31:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXU606BI;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhXiBf+O7T5aPY633KPfCzBwz2LzPoL8tTWNGFtRuzc=;
	b=Oo4SxXzM6p+EkRaiDHVZ/I4XhLTJ6jJPJCMmy5JJeusik/nQurhNXYGlpjE75ChTchNtZV
	8EmKi8vDCk38l+MpYnW3Yijmdmyf54Ji971R3IXKT/AsCpyF/zcJQAt22+brdJpt0fpOAg
	NnJxn0RDyN/QQI5SWpbGGTIszanjOPs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXU606BI;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975067; a=rsa-sha256;
	cv=none;
	b=pmpKLMmNA1VQf57doLi6o6Biuch2xoc/WG88fyxL3GDwfLmN2R+0095RRaH4u+JgIR8D9h
	jp5MN3uC3xYNrr84OKl35GKNSol8rKCQdGPf6TBSNpWMnC917SII4T2DqAh3QAtT3PT8ZO
	jvu3xStrUIOvWAuOPUO6KVprA6S9g7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE2A5400F7;
	Thu, 28 May 2026 13:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B12A1F000E9;
	Thu, 28 May 2026 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779975066;
	bh=JhXiBf+O7T5aPY633KPfCzBwz2LzPoL8tTWNGFtRuzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aXU606BIRfidIdFQV8dcq6jyRlyghIcQQSCfe8VTGM5kU/a6xdpkMPVNI90FoXm4n
	 xjUb7J3wB9pAs+j59mubjzRigHk+eMXjf4VOyCiJJ/MSoPoRSdmlfUfKsz4WbP+yOP
	 uz5UixRLIngrGl2ZwgXrOkcqk8Qt2L0D1q6EahG7bxXDUqDVmGaYJNun6Ekz4KwQfY
	 R/tt43ahvcbclUXYVV6w/v7IZ5jtv9E68qPAWZPHcCQntUJ39WToWpExpyBp7ZGSQ9
	 JCC4EYUp5qEX4vcIrvxJsDDxp3pRPwZpN4/7xb/styrhv5Rx4p5dJDeBSb2eL0s+5A
	 QcP3XVYvvPJ7w==
Date: Thu, 28 May 2026 14:31:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] userfaultfd: verify VMA state across UFFDIO_COPY
 retry
Message-ID: <ahhAHNSZOeW49ms2@lucifer>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527184751.4147364-2-rppt@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 86fmybudt9hosor7ofyx79mapcrxkpc6
X-Rspam-User: 
X-Rspamd-Queue-Id: C2300180011
X-HE-Tag: 1779975067-752336
X-HE-Meta: U2FsdGVkX1/trkVPEZ5p2+xRRkfGxW2GdrdZchFZkOpeVXdFYi881ZCGd9OmTA/ciwwvD5Nxn/zagecwXByXcJyMfxtNTfuCb6axFXnThlVEJW2A2FKdxc5s4mlRIapZ0XkjgCkTK9pEli5S6ioJ7235MzkZsT5MaNG+34wWKKKPmjTaAzxGMrzmT949KzbRLo6zuwys3qKDTVDs/SlXkqXZLt+HWd8m/gbjbGEoAJjUpsyOGsTzf5f/MxwhVWSjkZ1ZSwbDEJTv5jAcvG0cYHVmLXGH9bxm6uy+6wazetE6mZ8VmM1wkqSmRpnG/DuIbE8Yw+vH/dyx3zQE970N/QmA3gaYU+K8LMPhDnaFWLLmdp6HRDD9Su+Jyq0tVvyvkkF1Uv0g/tJhmUdHd4ZFT3DlQQTpp3oaMA0oMK60+R++TcBfnfcO+85raJVmLnFUB0w6DsKhc5kL0/n5StzH9tniXKn0VlE6/q0g0yetJat1liACxfJ8Esn5AC45RS4FRt89oZWsoibENVOpjONOGWdlEfYgvKxKur+0Q1HzRg/j4LRsrgqpK6VOKmuNd4uGNW12kg8YLbrztiDDiPze8Xn3MLCLWRaBhF/ehjJx9BamDfq8iDyG8xDTWyNCnWXHkGlaGCAmkR/lm6c75yYQwU3f/RoKiQhm/HSMyyQJ2uhYG9fKDXeDgYLkG9U2onzuk0ea0hjPO1DaMQIhYB9Vhvd17WW5zOrdtu8Ta+xSO/lVHpcz+3+mfTyrZDx5Bb5j2OSB1ELWboY+gYgRMy0h0ooOvjlZbxg3+1bj6VVglNkghVDk1RPJfIdpWzrgzrXuxXIcVab5jwYXgVp9Jup/Q1ttUY5SKBGBsSbM+VmktTH+s9AvUHMFsI0W0p6zR/p/CfTgyajq+dtJotoIg2DvZHE6jkOJwWP4Y8iIvw/M897TbjJzaqIIoMnTVLFQFddn4zfwUMCQQjRg+cL8nxd
 3y++BNiK
 3YuIsYJkgwykQBej7+wwkycusweCeIkNOnuFAcVTbpChK5aEoeUITU1tjrTC3SNbYt+hHCb/S/vXz42kTh1a8xNzHeak8UHkLhmvT7r63C4mJccp15I/VL+v7tq/91PgbCxWZSfKediGtAUbM5o3qfnvfQAlWxQyUwXaI4uxP01f1z8Rh0WaMgJLsuLZtACYH3c9tfl6lQ0J1bKB+hQLiLidUd4/tCJQ9Yep/xkxFQafZrC7YnUkT14kwI/FHgg8KYZ6H9CInqkO6o2MWSHRTkEvCQv86gRhHOmVSGWMRpv0Wles8ZqY3i8WzWtELZo3mMsogNgFMstURYHUAue3Gcu9ppexq7No1lrb8MXBi9ApwLL1/Hlw8Ym5m+x4TK63jwcJ7N2XsQ7UIikS0pbWHSltD8/QGa3VVoU0EP5Rc7DG2Ne+rvFK421f2PAlgojmH6nLFsf7uljdRd32CpIV5U+vEUXF5qb+DwlKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:47:49PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> reacquires it afterwards. The destination VMA can be replaced during that
> window.
>
> The existing check compares vma_uffd_ops() before and after the retry, but
> if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> MAP_PRIVATE (or vice versa) the replacement goes undetected.
>
> The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> with shmem_alloc_folio() as anonymous and this will cause BUG() when
> mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
>
> The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> the page cache of the original VMA.
>
> There is no need to change for hugetlb because it never uses
> mfill_copy_folio_retry().
>
> Introduce helpers for more comprehensive comparison of VMA state:
> - mfill_retry_state_save() to save the relevant VMA state into a struct
>   mfill_retry_state (original uffd_ops, relevant VMA flags, vm_file and
>   pgoff) before dropping the lock
> - mfill_retry_state_changed() to compare the saved state with the state
>   of the VMA acquired after retaking the locks
> - mfill_retry_state_put() to release vm_file pinning.
>
> Use DEFINE_FREE() cleanup to wrap mfill_retry_state_put() to avoid
> complicating error handling paths in mfill_copy_folio_retry().
>
> Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")

Did we want a Cc: Stable?

> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: David Carlier <devnexen@gmail.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

OK the logic here looks good, thanks for the changes. I have one comment below
re: a redundant check, with that addressed feel free to add:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 85 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 12 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..e5d2fb3ce2c1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -14,6 +14,8 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/hugetlb.h>
> +#include <linux/file.h>
> +#include <linux/cleanup.h>
>  #include <asm/tlbflush.h>
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -443,16 +445,80 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>
> -static int mfill_copy_folio_retry(struct mfill_state *state,
> +#define MFILL_RETRY_STATE_VMA_FLAGS \
> +	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
> +
> +/*
> + * VMA state saved before dropping the locks in mfill_copy_folio_retry().
> + * Used to detect VMA replacement or incompatible changes after reacquiring the
> + * locks.
> + */
> +struct mfill_retry_state {
> +	const struct vm_uffd_ops *ops;
> +	struct file *file;
> +	vma_flags_t flags;
> +	pgoff_t pgoff;
> +};

Much better thanks!

> +
> +static void mfill_retry_state_save(struct mfill_retry_state *s,
> +				   struct vm_area_struct *vma)
> +{
> +	s->flags = vma_flags_and_mask(&vma->flags, MFILL_RETRY_STATE_VMA_FLAGS);
> +	s->ops = vma_uffd_ops(vma);
> +	s->pgoff = vma->vm_pgoff;
> +
> +	if (vma->vm_file)
> +		s->file = get_file(vma->vm_file);
> +}

Yeah can live with the s here :)

> +
> +static bool mfill_retry_state_changed(struct mfill_retry_state *state,
> +				      struct vm_area_struct *vma)
> +{
> +	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
> +					       MFILL_RETRY_STATE_VMA_FLAGS);
> +
> +	/* Have any UFFD flags (missing, WP, minor) changed? */
> +	if (!vma_flags_same_pair(&state->flags, &flags))
> +		return true;
> +
> +	/* VMA type or effective uffd_ops changed while the lock was dropped */
> +	if (state->ops != vma_uffd_ops(vma))
> +		return true;
> +
> +	/* VMA was anonymous before; changed only if it no longer is */
> +	if (!state->file)
> +		return !vma_is_anonymous(vma);
> +
> +	/* VMA was file backed, but file, inode or offset has changed */
> +	if (!vma->vm_file || vma->vm_file->f_inode != state->file->f_inode ||
> +	    state->file != vma->vm_file || vma->vm_pgoff != state->pgoff)
> +		return true;

Doesn't state->file != vma->vm_file render the inode check redundant?

> +
> +	return false;
> +}
> +
> +static void mfill_retry_state_put(struct mfill_retry_state *s)
> +{
> +	if (s->file)
> +		fput(s->file);
> +}
> +
> +DEFINE_FREE(retry_put, struct mfill_retry_state *,
> +	    if (_T) mfill_retry_state_put(_T));
> +
> +static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
>  				  struct folio *folio)
>  {
> -	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
> -	unsigned long src_addr = state->src_addr;
> +	struct mfill_retry_state retry_state = { 0 };
> +	struct mfill_retry_state *for_free __free(retry_put) = &retry_state;
> +	unsigned long src_addr = mfill_state->src_addr;
>  	void *kaddr;
>  	int err;
>
> +	mfill_retry_state_save(&retry_state, mfill_state->vma);
> +
>  	/* retry copying with mm_lock dropped */
> -	mfill_put_vma(state);
> +	mfill_put_vma(mfill_state);
>
>  	kaddr = kmap_local_folio(folio, 0);
>  	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
> @@ -463,19 +529,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
>  	flush_dcache_folio(folio);
>
>  	/* reget VMA and PMD, they could change underneath us */
> -	err = mfill_get_vma(state);
> +	err = mfill_get_vma(mfill_state);
>  	if (err)
>  		return err;
>
> -	/*
> -	 * The VMA type may have changed while the lock was dropped
> -	 * (e.g. replaced with a hugetlb mapping), making the caller's
> -	 * ops pointer stale.
> -	 */
> -	if (vma_uffd_ops(state->vma) != orig_ops)
> +	if (mfill_retry_state_changed(&retry_state, mfill_state->vma))
>  		return -EAGAIN;
>
> -	err = mfill_establish_pmd(state);
> +	err = mfill_establish_pmd(mfill_state);
>  	if (err)
>  		return err;
>
> --
> 2.53.0
>

