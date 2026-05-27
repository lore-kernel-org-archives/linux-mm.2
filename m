Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B25CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 19:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AC46B0088; Wed, 27 May 2026 15:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB166B008C; Wed, 27 May 2026 15:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300AE6B0092; Wed, 27 May 2026 15:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE596B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:01:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B422D40635
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:01:40 +0000 (UTC)
X-FDA: 84814118760.05.960999C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA63A160010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:01:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7FVQIjQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779908499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TNjpY/WsPE+UHI5iIs+b+z9jGepi9dt/PL3KCRFcQXw=;
	b=EEtrfCMvFovBdPRTSGDxuidbLSqh/hoNvV20Yb8BSZ96VeQMMvCi7FlmOIymffyukHq/gA
	paFKJI031gesoi39JUBan9+Mi3Bn6rnHrDTDznyNsAUNN581yKIYNLP1plx5cG8/uG8tMk
	dJ7a8YEfizysa+1WjR6ZL12MiVGFfzk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7FVQIjQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779908499; a=rsa-sha256;
	cv=none;
	b=hOtcub/n29VV+9Qou28mFu7wqEHfFVe+rLDCoAnO3sGzlTM6feZbHG7NtOWa4rpkyVLsm1
	aq64K6zs1mhnCHcAcCM+zXLQig+BtfM9IrcoH6OydTfYPHxdFXsEGEBqcEEak8zu9vNt4F
	p5kOgLKdV3rSK4yD8/pRNEyrZA6m+OM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2A5A40A2E;
	Wed, 27 May 2026 19:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905F01F000E9;
	Wed, 27 May 2026 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779908497;
	bh=TNjpY/WsPE+UHI5iIs+b+z9jGepi9dt/PL3KCRFcQXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S7FVQIjQZGxJ72R6LU3UINFpbx0vk02yGI3vwnEav5fHSp7jgxdoqLpbI+CoRulXc
	 hqPP4dCG7gJPx8F0XfAWDTCmpEXu24yfZb053mdDJXLqHbUCCBmodgVJkhi+0DjJxr
	 lYZEtuATGYKutsKANjWl5flfTPLmDnhyeNv1qC6oSPfZCFU4d8Rexgbq2BSVG/jxqZ
	 tbclD1aL6RnV97PpR+VNZLRgBxdRoGEWbz9/qD7XB03ly07eoPfomLkOuQS4aw9acQ
	 sFrIEyD0wFF2p+Eb/gf6o41FWyAV4EGrWgOrpvXAxBJqJegSzemE4vMuYXN4iySWwg
	 f8A1fHjxIs9ZA==
Date: Wed, 27 May 2026 22:01:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ahc_iuhFIiGph0D5@kernel.org>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <ahWh7jsmLfY5awPR@lucifer>
 <ahXYuNSxe7FaDHE-@kernel.org>
 <ahcUDJ-eZP2GRwOJ@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahcUDJ-eZP2GRwOJ@lucifer>
X-Stat-Signature: y4odbpbfr18itdujyczed9pup3ysu1rt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA63A160010
X-Rspam-User: 
X-HE-Tag: 1779908498-437678
X-HE-Meta: U2FsdGVkX1+fXqeFh/NwPwHZDkuThmJitVppkfUh3bka6sTHFmGqnZMIbFeEZtJWfrB8KK8DknTeDCOeh3GNhDHB+nWMYDFxtMURkvtoofR2lEC4p4hWNdkKiQ9uOrxaajy8uT7+Scihd92TCeGW66HWSh4xje4TF4yRal6y4KIENSc9j4b9lpcXASrvtvg6RTrT0qe1kF2HcaVXa+BHhNuNC7q0t+d86FW//47jA2VfuvKgdPikp8zUTVvwq7zEd7DKFvH1GTJIdIwZqlEkiwrTQCTrr7+xoVjWiJVIezvmoFtzdwDADn61DMqFw1p0dYHNp1oMOGxgVHYPzccvTNZovzkYF1LGYLVQeb6WbuELfPdOQ7JTATGRSWSs4Mnge3DGcS4vh78xdWDs9dTXVxAXsCGDRNLd7AihmZ2jeehOrPypUtcgnQA5HhubcwRhLV1xswADyG/GDW16rNXA4F5bDapBojrNsdyhjz+NQXRkCjqqVOxLdyI3vVy5kvj64I4teVVpSP+KQUuIaXBjMmk3yPCuzAqH3ROfE6PTZEqfFPCFYaYb3+KdV07pgNrWuVEv7QkPrNNRdmS4gd95mMPw3oPlxJNrmGQzJorb3OrOyw+GX8fBwXe20lMIJxi3CwUZtx5ZQ7LvqyT7Ds/PgnwPeeHdHGtCiAFQE7PKf6L+Os8wLiUkwENzy8VzbNN++YntJ8XLE66av1QixspNIUPWZmZQRClqBwanxcbxnwpJhPFCWRcZjJVy/ybNEghVULoJnuYwb/2BlVKPHr9l0t1L7Wuyx50sAYuuFKr4g0BWLW8SFD3cWoMou2M5rPO0qJ7I2KiIU1F+aOAG9GRE+LiXWW5maFbGKBzVw2KjbLxs+AVBqVHVlKmU1b7wr+JrREn97CDn5fjFSEFaCZXalzX4tFwpfLmmq58+znkAvSMX/R0ijp33NJqBwIAY3ZM9FqP2XlHAJVv6205MUTs
 WGE7IUUf
 JQX+bEapK3E2nLu8gi4+/ds/Y8ldKKZ+LhP5n28CuCWXw5iQ8QonIP6/kvWgB66TXdrhNZmX0Gg4wdCjPDbn7acHnPMfElEkjKRg26FUrslr7uh197i1XGPJxpwj6dCJrHQlGLKYXOQ5baAUACNa19yTwFTXS2atwEQ2z61/dlOsTtPL8j1pUv5usKxInQR7MQPKPqf40OFYiCohh0JojWec4p4IhdC9pjkhNygriK4KrD1kZC4LxK057t3/Dl6uoPCjRtBWgMBIczgnnMfeiJBJSEGtnXm78jRbIIsDk6K/q3XOpljMB3/mbzxeGcXxJKY5izUAfigxv5SMvrHF/6NArmU/HFnLB7oaOtgNZ6htjdzCRsh5a0FYRpfnIrBx4P+xm6Bc6rcGHUVHIqg/4nnReTsCl7A+lviBQQB+fvH5bjbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 05:08:23PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 26, 2026 at 08:30:32PM +0300, Mike Rapoport wrote:
> > On Tue, May 26, 2026 at 04:12:56PM +0100, Lorenzo Stoakes wrote:
> > > On Tue, May 19, 2026 at 08:25:16AM +0300, Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > >
> > > > mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> > > > reacquires it afterwards. The destination VMA can be replaced during that
> > > > window.
> > > >
> > > > The existing check compares vma_uffd_ops() before and after the retry, but
> > > > if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> > > > MAP_PRIVATE (or vice versa) the replacement goes undetected.
> > > >
> > > > The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> > > > with shmem_alloc_folio() as anonymous and this will cause BUG() when
> > > > mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
> > > >
> > > > The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> > > > the page cache of the original VMA.
> > >
> > > OK this seems like a sensible subset of things to check - we are looking to
> > > check what might materially impact _this particular operation_, and working
> > > to the absolute minimum we need to check.
> > >
> > > >
> > > > Introduce helpers for more comprehensive comparison of VMA state:
> > > > - vma_snapshot_get() to save the relevant VMA state into a struct
> > > >   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
> > > >   vm_file and pgoff) before dropping the lock
> > > > - vma_snapshot_changed() to compare the saved state with the state of the
> > > >   VMA acquired after retaking the locks
> > > > - vma_snapshot_put() to release vm_file pinning.
> > >
> > > I feel like this is possibly a little misleading, it sort of implies that
> > > this is a broader kind of snapshot rather than some uffd-specific thing.
> > >
> > > This is more of a naming thing, yes things being defined in
> > > mm/userfaultfd.c tells you it's uffd-specific, but people are easily
> > > confused by stuff like this.
> > >
> > > Will comment inline.
> >
> > tl;dr:
> > * will update comments
> > * will rename vma_uffd_copy_ops() and replace NULL checks with VM_WARN
> > * will change some of single letter variable names.
> 
> Ack, thanks!
> 
> >
> > > >
> > > > Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> > > > error handling paths in mfill_copy_folio_retry().
> > >
> > > That's nice!
> > >
> > > >
> > > > Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> > > > shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
> > >
> > > I think this is a bit overly brief. And is it only shmem where this might
> > > happen? Is MAP_PRIVATE hugetlbfs not also possible?
> >
> > No, hugetlb is not applicabe here, it was not changed to use
> > mfill_copy_folio_retry().
> 
> OK, maybe worth a mention?

Ok.
 
> > > > +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
> > >
> > > I find this a bit confusing, these are the uffd ops for... copy? Or you're
> > > copying uffd ops?
> > >
> > > I'd maybe rename it to vma_uffd_ops_on_copy() to make it clear which it is,
> > > and add a comment like:
> >
> > vma_uffd_ops_for_copy()?
> 
> Works for me!

It's not needed actually, so I dropped it completely.

> > > /*
> > >  * Determine the ops to use when performing a UFFDIO_COPY operation - this
> > >  * specifically handles the case of a MAP_PRIVATE file-backed mapping,
> > >  * which, upon copy, is CoW'd into anonymous memory.
> > >  */
> >
> > I'll pick the large comment that got dropped and stick it here.
> 
> Ack thanks.

And that remains in place.

> > > I'm not sure if you were protecting against a possible future usage? But in
> > > that case surely you'd just want to VM_WARN_ON_ONCE(!ops)?
> > >
> > > We should also have a comment describing the situation like:
> > >
> > > 	/*
> > > 	 * Only async WP allows arbitrary file-backed mappings for UFFD,
> > > 	 * which is the only case in which ops can be NULL. However,
> > > 	 * we are copying here which is not permitted for these
> > >          * mappings, so this will never be the case here.
> > > 	 */
> >
> > I can live with one sentence tops here ;-)
> 
> It took me a _long_ time to understand what you were doing here, there's a
> balance to be had in commenting, but right now it's tilted towards 'nobody but
> Mike understands this'.

That's job security isn't it? ;-P
 
> I can tell, because nobody else bothered to review this in detail ;)

Were you on strike? ;-)
 
> > > Also in:
> > >
> > > static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> > > {
> > > 	if (vma_is_anonymous(vma))
> > > 		return &anon_uffd_ops;
> > > 	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> > > }
> > >
> > > This is doing a redundant check _and_ making life confusing, as if
> > > !vma->vm_ops is a condition that can be reached there, it can't, as
> > > vma_is_anonymous() is literally a !vma->vm_ops check :)
> > >
> > > So surely that should be:
> > >
> > > static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> > > {
> > > 	if (vma_is_anonymous(vma))
> > > 		return &anon_uffd_ops;
> > >
> > > 	return vma->vm_ops->uffd_ops;
> > > }
> > >
> > > I mean obviously that can be a separate patch, but that's not helped
> > > make things clear here! :)
> >
> > You are welcome to send it ;-)
> 
> Well you asked for it ;)

Did it myself.
 
> > > > +struct vma_snapshot {
> > > > +	const struct vm_uffd_ops *copy_ops;
> > > > +	const struct vm_uffd_ops *ops;
> > > > +	struct file *file;
> > > > +	vma_flags_t flags;
> > > > +	pgoff_t pgoff;
> > > > +};
> > >
> > > Yeah I don't love this naming, you're not snapshotting the VMA at all in
> > > any real sense, you're comparing a subset of things specifically for the
> > > UFFDIO_COPY case.
> > >
> > > Which is fine - but I think we should just make that clear here, because
> > > perhaps in the future we'll want a generic version of something like this
> > > and this is going to be super confusing if we do...
> >
> > Let's deal with it in the future then. This is a local structure, used by a
> > few local functions.
> 
> I'd really rather we rename it. This is asking for confusion...

Renamed everything to mfill_retry_state. 

> > > vma_uffdio_copy_snapshot maybe ?
> > >
> > > Maybe ok to leave the functions the same name to avoid a mouthful, the type
> > > name should make it clear what's going on.
> > >
> > > > +
> > > > +static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)
> > >
> > > No single letter var please! This isn't plan9 :)
> >
> > "C is a Spartan language, and your naming conventions should follow suit"
> > https://docs.kernel.org/process/coding-style.html#naming
> >
> > Here it's perfectly understandable what 's' means.
> 
> That very document goes on to give suggestions that aren't single letter :)

There's 'i' there a paragraph below ;)
 
> > > > +static bool vma_snapshot_changed(struct vma_snapshot *s,
> > >
> > > > +				 struct vm_area_struct *vma)
> > >
> > > Can the VMA potentially be any arbitrary VMA that might now be remapped in
> > > place? Like anon vs. file and same file and offset?
> > >
> > >
> > > > +{
> > > > +	vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> > > > +
> > >
> > > You have a comment for each of the other cases, so one here is useful I
> > > think, e.g.:
> > >
> > > 	/* Have any UFFD flags (missing, WP, minor) changed? */

Added it, although the flags are just one line above.

> > >
> > > > +	if (!vma_flags_same_pair(&s->flags, &flags))
> > > > +		return true;
> > >
> > > > +
> > > > +	/* VMA type or effective uffd_ops changed while the lock was dropped */
> > >
> > > Can the 'effective' (probably better to say copy or use effective
> > > throughout) uffd_ops change though? You already check that VMA_SHARED_BIT
> > > is either set or unset across the lock drop above so is the copy_ops check
> > > even meaningful here?
> >
> > Yes, it can change if a shmem VMA changes from SHARED to PRIVATE or vice
> > versa.
> 
> How?
> 
> 	if (!vma_flags_same_pair(&s->flags, &flags))
> 		return true;
> 
> Checks against VMA_SNAPSHOT_FLAGS which includes VMA_SHARED_BIT. So that would
> catch it already no?
 
Yes, you are right. It's enough to check for flags and the original ops.
And with the copy_ops check dropped there is no need in
vma_uffd_copy_ops().

> > > > +	if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
> > > > +		return true;
> > > Surely we should also check that the UFFD context matches (accounting for
> > > NULL cases)?
> >
> > It's checked in mfill_get_vma().
> 
> Yeah it's a bit strange not to do that on a validation step though, would prefer
> we live with the duplication or at least add a comment saying it's checked.
 
There's a bunch of validation checks on mfill_get_vma() path, let's leave
them there. 

> > > > +	/* VMA was file backed, but inode or offset has changed */
> > > > +	if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
> > > > +	    vma->vm_pgoff != s->pgoff)
> > > > +		return true;
> > >
> > > Hm so are we OK with a VMA where the file has been closed, then the same
> > > inode re-opened at the exact same offset? (e.g. vma->vm_file differs)
> >
> > The copy will go to exactly the same place in that case.
> 
> I mean OK, but maybe it's better to be conserative? Is just a bit weird to
> tolerate that when we pin the file we could just check file equality?

Yes, we could :) 

> > > >  static int mfill_copy_folio_retry(struct mfill_state *state,
> > > >  				  struct folio *folio)
> > > >  {
> > > > -	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
> > > > +	struct vma_snapshot s = { 0 };
> > > > +	struct vma_snapshot *p __free(snapshot_put) = &s;
> > >
> > > Could we avoid these single letter var names?
> >
> > You suggest to call it a_dummy_pointer_to_allow_use_of_free_cleanup? ;-P
> 
> Or, and I know it's _crazy_, but like 'snapshot' and 'prev'(or whatever p is
> supposed to be - see the problem??), or something vaguely greppable? :)

p is pointer, prev has nothing to do with it.
But renamed anyway.
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

