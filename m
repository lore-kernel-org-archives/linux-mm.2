Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC26CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFA06B0098; Tue, 26 May 2026 11:13:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8406B00D6; Tue, 26 May 2026 11:13:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4A96B00D7; Tue, 26 May 2026 11:13:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2DB6B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:13:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0647C120394
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:13:05 +0000 (UTC)
X-FDA: 84809913930.12.065FDC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D13D180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:13:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbndi1YR;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tAeTomVFLvaL8g0ZiijkKbb5HG6kEMQ+E305FlR0s84=;
	b=x9hwNqBaGgSn+1kAE5h0fN8c4ZfCK++hR/ki7ac0gIVSMpB4sxm7vsCD3deCNzzY2r+cJp
	zmIM2+itkP7K58uHmpMDBQbWzloOOz1cUb0M2owiIkf79AQJNsP/JvWe+QevkDUT1kCfvL
	2nmH+MixPmB6OxYskI58XaHjwc+OdOE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mbndi1YR;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808383; a=rsa-sha256;
	cv=none;
	b=eYJxhAbVBC2jXe3WfgZNtFxp4QQERElZz/CWN2ny0iopMCpgk7S3VxTD4Efdx6MFAIy1xM
	QAl+ScQiiJ3LG/6aTqR7WwmJD4X0Z2UlvIgEPNtYx/LxkdBQUj1GHor31R0+s8slXxBw/P
	umt+UNUwKsrGB6oHqW0XgLBhPLExMrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 172A343CCE;
	Tue, 26 May 2026 15:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF881F000E9;
	Tue, 26 May 2026 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808382;
	bh=tAeTomVFLvaL8g0ZiijkKbb5HG6kEMQ+E305FlR0s84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mbndi1YReIhQOgyWQoaOMp6BhZdQRqejlhsukgvhOvkoIENwlY/luCIu6ZReYth4e
	 WgugQqh4sOd1cMI5ZVvUFXfJS87skqy+B/JChWii0BCMRsGzVOPt41Kfn6cuQ51Vk7
	 nGDCF4QzU6DW72IHKcjPQbNtt2DdEzlrTzUzZVisTuVDpjYvGS3d5VVZbhWRDnQIed
	 a6QdIaRGV+lzPCuDowL9cGeY0UpzOHU8goL/37MLvugwZPTsc5dDhPhxznt+DP0RSB
	 yVi7z+jBcXOecvpWUx5viv6Uw/9N3zxe2uN2eUWgyuyQEdBqiIE1eU5dZlqA4rqH5I
	 p25KgiKs2CyfQ==
Date: Tue, 26 May 2026 16:12:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ahWh7jsmLfY5awPR@lucifer>
References: <20260519052516.3315196-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519052516.3315196-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D13D180005
X-Stat-Signature: 8fp9x9njui5qsjktwtrosp69ucg53akd
X-HE-Tag: 1779808382-807200
X-HE-Meta: U2FsdGVkX1+TYF70UTO7rXZ66YP4rWIb752HHH1YKsZuOgZ5owg1wLBUpCyjakmOr0DJdMa3sVRY0m8gq0eR6Je4dH+VjLjmlHdPAQp4H8pDNIXdB9/BOJh5MH6WyBi0YpHWta/v6jK+dYFQoPK8fpBTejXuEAgCvULJA5ksidegrlR/S5pDeZls78tNC6TJwLgkYRoqE/WQUls/Xyh+VVACsCsCXd2uuvZh/nbX1a4SByUTsL+sataGsfm2v/Rej1HbClNB6Htw/b2UKcW3CSzgM0/V2Xcb6o46uF3dFaFvHced0X0JzmW62B1InhYKKk3sXyAWLvHIpHtVUCjsBFKF0PfSuRNj8TXy+rEwlhIuhcBMuIRF836N8R0008qhZbPe3oFaRjNV4svXYIZ85f2+Y/kaXfmNem3Md7pa1nYVjk1VyED1xZ4yHnUVsXFoKMXt6ibicdraGmIjEwEa7+kDklCp9OYMdiiPLN1cntVWme6vlZ1bq9Sx0PE0NeAazrT2/OTcg2mjFjCbFPhl3vorRvfYe+VPQR6nkYB5ZKmFdF5VrtZpfxO32hNEHyrgnGvaTE3BuqtdRxEtoxyFuaeioj9+nLZk0oquZ7RowV8fd6wPrqCaC8oj9JKgn3WZCpgIhVoTDAQVvkCT13ip6bLRkT6NPizW8LlFd0xugxiG/DonAddhuF/lqo851dXTiURLZD6LOnUIsz1Mwb+UIbzvZEA/63xanL0iMBxaSStrTe14t8GDR0XlxXPFCXKADGmmC1cyPzKEeI4dXln5Gh08j7M28yhS+SYE+kiAzH5gBTJZas3jaLRdosSBspCYaKVW797xrRq4OXbtSNpGWO9YoesEOpKZ1hUb9osKtGugOjnxUT6Fvtuq2Y8gINgkugwCV4cPnCTCsxKVJ6s+zh0DscXGo6/inCG2xrINrHVURZte7/EdMJKZTitkpvaiVw0cKrHGpeeexEbDqtS
 hjGoIyv3
 /Utuffb5rpjNrkD5GyZcBePBKNp7zOsQihlWSXJ6IfvH12OlsvNxHVr0rxu4LAoidV+saI6aCiEVNHvxDkvr4DjUmEaQ2ke86wmr5aOjECHlyWYhrqaHiedUMtKJfW26eBlGR82LoWC1TUEznMBnhSsKKHnwxzyq0B/dLmBZzgVi2fAMqQOqD4jAz/+QICyZ+0niFyZ3CUWyEZhAbajN4Ev7T4E3ZJa3vSmrqGl6+MKkEywqeOFHAShPkMl++tEulsj78eXxiXChQq+Ae/hWpWEYE5sIFqey6t5XsSVRAoYurBsI3PgVBtRl4zPIlwCQtVZEMd7G0Qtoij3IcMB5KnyMe4G6vmBm8ayaq7ZrAUWupR+D6lXcqvC7ROMlUmek3s799uHdwCFtvq8ct4ZDxTr4wj9hZP2U26NJ0zGCFAWIpz9rK6x0rSkRL28pcxALJFJCyIDPn0s0aF+pFLIkwrfzqWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 08:25:16AM +0300, Mike Rapoport wrote:
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

OK this seems like a sensible subset of things to check - we are looking to
check what might materially impact _this particular operation_, and working
to the absolute minimum we need to check.

>
> Introduce helpers for more comprehensive comparison of VMA state:
> - vma_snapshot_get() to save the relevant VMA state into a struct
>   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
>   vm_file and pgoff) before dropping the lock
> - vma_snapshot_changed() to compare the saved state with the state of the
>   VMA acquired after retaking the locks
> - vma_snapshot_put() to release vm_file pinning.

I feel like this is possibly a little misleading, it sort of implies that
this is a broader kind of snapshot rather than some uffd-specific thing.

This is more of a naming thing, yes things being defined in
mm/userfaultfd.c tells you it's uffd-specific, but people are easily
confused by stuff like this.

Will comment inline.

>
> Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> error handling paths in mfill_copy_folio_retry().

That's nice!

>
> Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.

I think this is a bit overly brief. And is it only shmem where this might
happen? Is MAP_PRIVATE hugetlbfs not also possible?

>
> Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")

Hmm this is the second multiple-fixes patch I've seen, maybe that is OK to
do :) I guess if this one, indivisble change fixes both then that's valid.

> Tested-by: Heechan Kang <gganji11@naver.com>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: David Carlier <devnexen@gmail.com>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 79 insertions(+), 20 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 180bad42fc79..b70b84776a79 100644
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
> @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>  	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
>  }
>
> +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)

I find this a bit confusing, these are the uffd ops for... copy? Or you're
copying uffd ops?

I'd maybe rename it to vma_uffd_ops_on_copy() to make it clear which it is,
and add a comment like:

/*
 * Determine the ops to use when performing a UFFDIO_COPY operation - this
 * specifically handles the case of a MAP_PRIVATE file-backed mapping,
 * which, upon copy, is CoW'd into anonymous memory.
 */

From the snapshot point of view, I have been pondering if this was the
clearest way of checking things because you are, in effect checking a
specific case

it, but after much back and forth, perhaps it's not too crazy... you are in
most cases doing a duplicate check to the ops check



> +{
> +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> +
> +	if (!ops)
> +		return NULL;

Is this correct? The code you removed from mfill_atomic_pte_copy()
unconditionally replaces the ops with &anon_uffd_ops, regardless of whether
any operations were specified, but now not providing ops avoids that?

I mean it's correct if we can never have !ops, and presumably we can't
because __mfill_atomic_pte() unconditionally calls ops->alloc_folio() right
at the top of the logic?

Doesn't uffd only support shmem, anon + hugetlbfs? So why are we adding
!ops checks at all?

Actually claude (:>) tells me that async-WP memory mode (ugh god) can be
used for _anything_:

	/*
	 * If WP is the only mode enabled and context is wp async, allow any
	 * memory type.
	 */
	if (wp_async && (vm_flags == VM_UFFD_WP))
		return true;

But. This function is never called in anything but a copy context?

I'm not sure if you were protecting against a possible future usage? But in
that case surely you'd just want to VM_WARN_ON_ONCE(!ops)?

We should also have a comment describing the situation like:

	/*
	 * Only async WP allows arbitrary file-backed mappings for UFFD,
	 * which is the only case in which ops can be NULL. However,
	 * we are copying here which is not permitted for these
         * mappings, so this will never be the case here.
	 */
	 VM_WARN_ON_ONCE(!ops);

Also in:

static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
{
	if (vma_is_anonymous(vma))
		return &anon_uffd_ops;
	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
}

This is doing a redundant check _and_ making life confusing, as if
!vma->vm_ops is a condition that can be reached there, it can't, as
vma_is_anonymous() is literally a !vma->vm_ops check :)

So surely that should be:

static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
{
	if (vma_is_anonymous(vma))
		return &anon_uffd_ops;

	return vma->vm_ops->uffd_ops;
}

I mean obviously that can be a separate patch, but that's not helped
make things clear here! :)

> +
> +	/*
> +	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> +	 * memory. This is an effective ops override, so retry validation must
> +	 * compare the override result, not just vma->vm_ops->uffd_ops.
> +	 */

The wording here is super confusing. 'This is an effective ops override'
and 'retry validation' and also the 'not just'.

Also it makes zero reference to the invocation of this function from
mfill_atomic_pte_copy() - this function is pulling double-duty so this
comment isn't really quite correct.

I'd maybe pull up the comment from mfill_atomic_pte_copy() (and adapt it to
suit the changes, also mentioning the snapshot use case).

> +	if (!(vma->vm_flags & VM_SHARED))
> +		return &anon_uffd_ops;

This is inconsistent with the rest of the VMA flags API usage, you want:

	if (!vma_test(vma, VMA_SHARED_BIT))
		return &anon_uffd_ops;

> +
> +	return ops;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>
> +#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)

Hm it's a bit weird to have a VMA flags define outside of mm.h.

But I definitely appreciate you using the new VMA flags stuff :)

Probably just renaming to VMA_UFFD_COPY_STATE_FLAGS or something?

> +

I'm a bit of a broken record I know :) but a comment here would be helpful
describing what this is for.

> +struct vma_snapshot {
> +	const struct vm_uffd_ops *copy_ops;
> +	const struct vm_uffd_ops *ops;
> +	struct file *file;
> +	vma_flags_t flags;
> +	pgoff_t pgoff;
> +};

Yeah I don't love this naming, you're not snapshotting the VMA at all in
any real sense, you're comparing a subset of things specifically for the
UFFDIO_COPY case.

Which is fine - but I think we should just make that clear here, because
perhaps in the future we'll want a generic version of something like this
and this is going to be super confusing if we do...

vma_uffdio_copy_snapshot maybe ?

Maybe ok to leave the functions the same name to avoid a mouthful, the type
name should make it clear what's going on.

> +
> +static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)

No single letter var please! This isn't plan9 :)

> +{
> +	s->flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> +	s->copy_ops = vma_uffd_copy_ops(vma);
> +	s->ops = vma_uffd_ops(vma);
> +	s->pgoff = vma->vm_pgoff;
> +
> +	if (vma->vm_file)
> +		s->file = get_file(vma->vm_file);
> +}
> +
> +static bool vma_snapshot_changed(struct vma_snapshot *s,

> +				 struct vm_area_struct *vma)

Can the VMA potentially be any arbitrary VMA that might now be remapped in
place? Like anon vs. file and same file and offset?


> +{
> +	vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> +

You have a comment for each of the other cases, so one here is useful I
think, e.g.:

	/* Have any UFFD flags (missing, WP, minor) changed? */

> +	if (!vma_flags_same_pair(&s->flags, &flags))
> +		return true;

> +
> +	/* VMA type or effective uffd_ops changed while the lock was dropped */

Can the 'effective' (probably better to say copy or use effective
throughout) uffd_ops change though? You already check that VMA_SHARED_BIT
is either set or unset across the lock drop above so is the copy_ops check
even meaningful here?

> +	if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
> +		return true;

Surely we should also check that the UFFD context matches (accounting for
NULL cases)?

Could we not otherwise have weird situations across UFFD contexts if both
VMAs happen to contain identitical properties otherwise?

This seems to be a canonical part of identifying a UFFD VMA so strange to
not see it here?

> +
> +	/* VMA was anonymous before; changed only if it no longer is */
> +	if (!s->file)
> +		return !vma_is_anonymous(vma);
> +
> +	/* VMA was file backed, but inode or offset has changed */
> +	if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
> +	    vma->vm_pgoff != s->pgoff)
> +		return true;

Hm so are we OK with a VMA where the file has been closed, then the same
inode re-opened at the exact same offset? (e.g. vma->vm_file differs)

Would this be problematic with hugetlbfs or shmem?

I guess we pin the inode so the f_inode check _should_ be valid, from that
side.

> +
> +	return false;
> +}
> +
> +static void vma_snapshot_put(struct vma_snapshot *s)
> +{
> +	if (s->file)
> +		fput(s->file);
> +}
> +
> +DEFINE_FREE(snapshot_put, struct vma_snapshot *, if (_T) vma_snapshot_put(_T));
> +
>  static int mfill_copy_folio_retry(struct mfill_state *state,
>  				  struct folio *folio)
>  {
> -	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
> +	struct vma_snapshot s = { 0 };
> +	struct vma_snapshot *p __free(snapshot_put) = &s;

Could we avoid these single letter var names?

>  	unsigned long src_addr = state->src_addr;
>  	void *kaddr;
>  	int err;
>
> +	vma_snapshot_get(&s, state->vma);
> +
>  	/* retry copying with mm_lock dropped */
>  	mfill_put_vma(state);
>
> @@ -467,12 +543,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
>  	if (err)
>  		return err;
>
> -	/*
> -	 * The VMA type may have changed while the lock was dropped
> -	 * (e.g. replaced with a hugetlb mapping), making the caller's
> -	 * ops pointer stale.
> -	 */

This comment we can lose given we are explicitly comparing snapshots, but I
think it's not great to explicitly point out that we're doing this because
of the lock being dropped, we should say that somewhere.

> -	if (vma_uffd_ops(state->vma) != orig_ops)
> +	if (vma_snapshot_changed(&s, state->vma))
>  		return -EAGAIN;
>
>  	err = mfill_establish_pmd(state);
> @@ -545,19 +616,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>
>  static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> -
> -	/*
> -	 * The normal page fault path for a MAP_PRIVATE mapping in a
> -	 * file-backed VMA will invoke the fault, fill the hole in the file and
> -	 * COW it right away. The result generates plain anonymous memory.
> -	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> -	 * generate anonymous memory directly without actually filling the
> -	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> -	 * the pagetable (to verify it's still none) and not in the page cache.
> -	 */

(As mentioned above) I hate that we lose this comment (or the gist of it at
least), can we please move it up to the copy ops function?

> -	if (!(state->vma->vm_flags & VM_SHARED))
> -		ops = &anon_uffd_ops;

A comment here would maybe be useful. But with a function rename and a
comment at the function itself maybe OK without.

> +	const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);

Can we please have a:

	/* Only async W/P can have missing ops, and that can't copy. */
	VM_WARN_ON_ONCE(!ops);

Check here to make it absolutely clear you're not running straight into a
NULL pointer deref in __mfill_atomic_pte()? Maybe worth putting a similar
assert there too.

>
>  	return __mfill_atomic_pte(state, ops);
>  }
>
> base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
> --
> 2.53.0
>

Thanks, Lorenzo

