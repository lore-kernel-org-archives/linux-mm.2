Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74795CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613776B00A4; Tue, 26 May 2026 13:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5666B00A5; Tue, 26 May 2026 13:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2D56B00A7; Tue, 26 May 2026 13:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 388CE6B00A4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:30:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBCB7A03DD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:30:41 +0000 (UTC)
X-FDA: 84810260682.26.5A159C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 158B2140012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:30:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXgXeAPK;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779816640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmRnqVAPglH5epsPkKcLyvEqDn5xMZHGS6B8mOKN2vU=;
	b=fbrEqq2pcNGgYkUKlvPni0yM5LrmMGCgeJqoWVXY5CDMzbelbtU9pJ82HziYkDf30agJVf
	4pI4dKzBqguDOjkussOEfsgXmvz5k8sWF7kyTUmKUYjuwxEzQZ986nD4hFNvMjo5DmfrBz
	bihhS2nQFwW0rHVbuO1s+RohTafUZAE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXgXeAPK;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779816640; a=rsa-sha256;
	cv=none;
	b=GC+/PsztjyzGwkSsiQ2oVePotUDWAl3HeZ9iAOxvDxnu5ci6R7V16I1cr4QaXplduLAEAA
	yv2d2vvYTSIuK27ITZc96Ev++fq5vzFPuJy/haWPtwG0bXdqY8+fCS+Ia3KqS8wanXvyyK
	T8wBoMcjPmvugx7XmsvmjUtNkvA9PIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 840F560018;
	Tue, 26 May 2026 17:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF6C1F000E9;
	Tue, 26 May 2026 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779816639;
	bh=UmRnqVAPglH5epsPkKcLyvEqDn5xMZHGS6B8mOKN2vU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WXgXeAPKazqFCYuCGdIpbWzBW6a7tSDp1BcotWbAnj1fpQYZRtMUqQ/jTIk5Y4iXJ
	 eZm1PzNw4JH3XUpp+SJ0iGtUz0CzGe17srjTXTWoHXpn3apx0BCDscYiDaxWTek/sG
	 N7omDIr5yb8S/eZavF8CuM/4sailIHFYd1bPEglfHCVvzD0BjLKr4hBNeA+nPjAdDS
	 iTYDVcsk7kzphGtrEDUJQsMtB9XQdnxKN9lfIvgjTmwDqCOIJ9r1DZ13KouK0z408E
	 pFfyoAr9L6LwpIvB4VTJ6h2M3JF+cWOZmsJtms2uvgA7v2GYqm9e69b9P2rDnd7gnl
	 a9LheAKoh3SGw==
Date: Tue, 26 May 2026 20:30:32 +0300
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
Message-ID: <ahXYuNSxe7FaDHE-@kernel.org>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <ahWh7jsmLfY5awPR@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahWh7jsmLfY5awPR@lucifer>
X-Stat-Signature: itxkwdbhuu1tqynrw7yi1u9536h8w53e
X-Rspamd-Queue-Id: 158B2140012
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779816639-147097
X-HE-Meta: U2FsdGVkX1+ldvSTJWPLrxNiYWVN3HPBv2wG8Rq/AXoPQTvifSnZuohb7WEEyZceXmbsqxaLRhgGBldEV5bQxvkJFJrwhOJBh0CThq47EFPtAiuwKgncKUR+44xIyTHRDUJJpsmEqwcCCcRF8HurGXuvIzlTLUumAuDkCDr39KxH1Z+VpPOBdbvSmrcaJaJfSyxArz6neJe/HfPfVhAUQaufIE3y1EYbYRUbKdI2Aubu1Blw+nKqJ6P/ozVI7TM1QfwcGeFl9DMOJscU4wjmh5DRpniYznpTR0+U381CwHomPWRWC0jcnlAZHhG3Ec7Df85SU75Wsggai88TQEwZdxa/CplZekpICKCKu5Ze6AYJLuWZZ+d18bQnqZ9XuaWhQOp8UPc+zzZHJu9P4cN21r/6hIrAE0ZhOvKIdBjOY8+A64R30t4kfyDjgQx8afTezAGtkQWdLZz6tTUh6q4XNBFrA8CiSGqj2ILmaVgdpAfvKLdrx42UlT79Gl6736hEcLF6IxjE+cY623XNM9VB3TaR9d0G1NFB9bBH1f+CsxyLsgAbLHyd7KOOyuHS3wktjB6/nlZc6JdhsxWNIqHOcLc77Zhw87RHU8cdAl4H2ZGp0qqZBpGIs/mlTvWcrG2DEWZxNh92Xe3XFPwTH2f/J68XwhZBh2OlOJSVN8X3wrHb45pU/9SGIvcdwZk/wa09I16SbkA9jB53Q5BdxKKQ+keaDp+X94fTDKkzO1g1XMrBtnSZdZG5LDlDPSJ9SSjDPnGAIBPiVrZP08r2fKmbUkevz7rbxYG0IGCmrVcy84zupNfy++8igb8r0TcFIoNTlGn/l11Uv5mcb4NB5pT3N/N1yC6hNB5MfhCi9jXBWVpsd1Fuv+4OAztM+3b7uOkfiMAKHKUsxRbK4M3HjHbbosUJU6ppvZDF3hmMfcber8BR1nljfRj8aNoAcgDo9pf0MqghEfSHuFxBs72ywAG
 zjwncgIK
 z1c+VxmVaHfeOfD+qkYtn2k3G9TzGdRQe5OlySrEEktLJ4gLLavD5RCehqLkhfVmGmGP3G27PkPkXzl1w+GVMJXfPQFtsDodZITW+XAyqwPjjYL5i8FhsV4WXjgSU8MC/L3RaDVO406DdoE2f47QUxQVh7OG9Z70pjWSkPQGXoywrLzgp6OnPnKYq7Nqt/yqPxr5ffHH/vNvxYXTJoIDZ0sfdvACsfD8SEckcIRAIwtGF6hNebKlYgWWSPOzW1TSAldWpQ9c3T1QAqPMnBO6HbMFdkuNtTBJhJNdjUt0HdKBUJJ+u/AodeZORVh7JKs/gCxz+rMGngwiRj8/h/CnYw0AMTj7njJuWdHreDLagq8qYW2OWC4ztTaqYoeL4C4YwQwLb7mQkSFyn59pK8TXeiuAh9Xn7w3TKkWMdiF71DzvRoPVELf1D/iheTknHV+q1LoSC2Qxh77UBvqWoTztDXu8YrV3Kn0A+VIncoOwNktdp4WA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 04:12:56PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 19, 2026 at 08:25:16AM +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
> > reacquires it afterwards. The destination VMA can be replaced during that
> > window.
> >
> > The existing check compares vma_uffd_ops() before and after the retry, but
> > if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
> > MAP_PRIVATE (or vice versa) the replacement goes undetected.
> >
> > The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
> > with shmem_alloc_folio() as anonymous and this will cause BUG() when
> > mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().
> >
> > The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
> > the page cache of the original VMA.
> 
> OK this seems like a sensible subset of things to check - we are looking to
> check what might materially impact _this particular operation_, and working
> to the absolute minimum we need to check.
> 
> >
> > Introduce helpers for more comprehensive comparison of VMA state:
> > - vma_snapshot_get() to save the relevant VMA state into a struct
> >   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
> >   vm_file and pgoff) before dropping the lock
> > - vma_snapshot_changed() to compare the saved state with the state of the
> >   VMA acquired after retaking the locks
> > - vma_snapshot_put() to release vm_file pinning.
> 
> I feel like this is possibly a little misleading, it sort of implies that
> this is a broader kind of snapshot rather than some uffd-specific thing.
> 
> This is more of a naming thing, yes things being defined in
> mm/userfaultfd.c tells you it's uffd-specific, but people are easily
> confused by stuff like this.
> 
> Will comment inline.

tl;dr:
* will update comments
* will rename vma_uffd_copy_ops() and replace NULL checks with VM_WARN
* will change some of single letter variable names.
 
> >
> > Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> > error handling paths in mfill_copy_folio_retry().
> 
> That's nice!
> 
> >
> > Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> > shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
> 
> I think this is a bit overly brief. And is it only shmem where this might
> happen? Is MAP_PRIVATE hugetlbfs not also possible?

No, hugetlb is not applicabe here, it was not changed to use
mfill_copy_folio_retry().
 
> >
> > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
> 
> Hmm this is the second multiple-fixes patch I've seen, maybe that is OK to
> do :) I guess if this one, indivisble change fixes both then that's valid.
> 
> > Tested-by: Heechan Kang <gganji11@naver.com>
> > Suggested-by: Peter Xu <peterx@redhat.com>
> > Co-developed-by: David Carlier <devnexen@gmail.com>
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 79 insertions(+), 20 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 180bad42fc79..b70b84776a79 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -14,6 +14,8 @@
> >  #include <linux/userfaultfd_k.h>
> >  #include <linux/mmu_notifier.h>
> >  #include <linux/hugetlb.h>
> > +#include <linux/file.h>
> > +#include <linux/cleanup.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/tlb.h>
> >  #include "internal.h"
> > @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> >  	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> >  }
> >
> > +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
> 
> I find this a bit confusing, these are the uffd ops for... copy? Or you're
> copying uffd ops?
> 
> I'd maybe rename it to vma_uffd_ops_on_copy() to make it clear which it is,
> and add a comment like:

vma_uffd_ops_for_copy()?
 
> /*
>  * Determine the ops to use when performing a UFFDIO_COPY operation - this
>  * specifically handles the case of a MAP_PRIVATE file-backed mapping,
>  * which, upon copy, is CoW'd into anonymous memory.
>  */

I'll pick the large comment that got dropped and stick it here.
 
> From the snapshot point of view, I have been pondering if this was the
> clearest way of checking things because you are, in effect checking a
> specific case
> 
> it, but after much back and forth, perhaps it's not too crazy... you are in
> most cases doing a duplicate check to the ops check
> 
> 
> 
> > +{
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> > +
> > +	if (!ops)
> > +		return NULL;
> 
> Is this correct? The code you removed from mfill_atomic_pte_copy()
> unconditionally replaces the ops with &anon_uffd_ops, regardless of whether
> any operations were specified, but now not providing ops avoids that?
> 
> I mean it's correct if we can never have !ops, and presumably we can't
> because __mfill_atomic_pte() unconditionally calls ops->alloc_folio() right
> at the top of the logic?
> 
> Doesn't uffd only support shmem, anon + hugetlbfs? So why are we adding
> !ops checks at all?
> 
> Actually claude (:>) tells me that async-WP memory mode (ugh god) can be
> used for _anything_:
> 
> 	/*
> 	 * If WP is the only mode enabled and context is wp async, allow any
> 	 * memory type.
> 	 */
> 	if (wp_async && (vm_flags == VM_UFFD_WP))
> 		return true;
> 
> But. This function is never called in anything but a copy context?

wp_async has nothing to do with copy (or zeropage).
 
> I'm not sure if you were protecting against a possible future usage? But in
> that case surely you'd just want to VM_WARN_ON_ONCE(!ops)?
> 
> We should also have a comment describing the situation like:
> 
> 	/*
> 	 * Only async WP allows arbitrary file-backed mappings for UFFD,
> 	 * which is the only case in which ops can be NULL. However,
> 	 * we are copying here which is not permitted for these
>          * mappings, so this will never be the case here.
> 	 */

I can live with one sentence tops here ;-)

> 	 VM_WARN_ON_ONCE(!ops);
> 
> Also in:
> 
> static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> {
> 	if (vma_is_anonymous(vma))
> 		return &anon_uffd_ops;
> 	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> }
> 
> This is doing a redundant check _and_ making life confusing, as if
> !vma->vm_ops is a condition that can be reached there, it can't, as
> vma_is_anonymous() is literally a !vma->vm_ops check :)
> 
> So surely that should be:
> 
> static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> {
> 	if (vma_is_anonymous(vma))
> 		return &anon_uffd_ops;
> 
> 	return vma->vm_ops->uffd_ops;
> }
> 
> I mean obviously that can be a separate patch, but that's not helped
> make things clear here! :)
 
You are welcome to send it ;-)

> > +
> > +	/*
> > +	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> > +	 * memory. This is an effective ops override, so retry validation must
> > +	 * compare the override result, not just vma->vm_ops->uffd_ops.
> > +	 */
> 
> The wording here is super confusing. 'This is an effective ops override'
> and 'retry validation' and also the 'not just'.
> 
> Also it makes zero reference to the invocation of this function from
> mfill_atomic_pte_copy() - this function is pulling double-duty so this
> comment isn't really quite correct.
> 
> I'd maybe pull up the comment from mfill_atomic_pte_copy() (and adapt it to
> suit the changes, also mentioning the snapshot use case).
> 
> > +	if (!(vma->vm_flags & VM_SHARED))
> > +		return &anon_uffd_ops;
> 
> This is inconsistent with the rest of the VMA flags API usage, you want:

This is consistent with the rest of VMA usage in uffd, we can convert it
all in one go if you'd like.
 
> 	if (!vma_test(vma, VMA_SHARED_BIT))
> 		return &anon_uffd_ops;
> 
> > +
> > +	return ops;
> > +}
> > +
> >  static __always_inline
> >  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
> >  {
> > @@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> >  	return ret;
> >  }
> >
> > +#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
> 
> Hm it's a bit weird to have a VMA flags define outside of mm.h.
> 
> But I definitely appreciate you using the new VMA flags stuff :)
> 
> Probably just renaming to VMA_UFFD_COPY_STATE_FLAGS or something?
>
> > +
> 
> I'm a bit of a broken record I know :) but a comment here would be helpful
> describing what this is for.
> 
> > +struct vma_snapshot {
> > +	const struct vm_uffd_ops *copy_ops;
> > +	const struct vm_uffd_ops *ops;
> > +	struct file *file;
> > +	vma_flags_t flags;
> > +	pgoff_t pgoff;
> > +};
> 
> Yeah I don't love this naming, you're not snapshotting the VMA at all in
> any real sense, you're comparing a subset of things specifically for the
> UFFDIO_COPY case.
> 
> Which is fine - but I think we should just make that clear here, because
> perhaps in the future we'll want a generic version of something like this
> and this is going to be super confusing if we do...

Let's deal with it in the future then. This is a local structure, used by a
few local functions.
 
> vma_uffdio_copy_snapshot maybe ?
> 
> Maybe ok to leave the functions the same name to avoid a mouthful, the type
> name should make it clear what's going on.
> 
> > +
> > +static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)
> 
> No single letter var please! This isn't plan9 :)

"C is a Spartan language, and your naming conventions should follow suit"
https://docs.kernel.org/process/coding-style.html#naming

Here it's perfectly understandable what 's' means.
 
> > +{
> > +	s->flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> > +	s->copy_ops = vma_uffd_copy_ops(vma);
> > +	s->ops = vma_uffd_ops(vma);
> > +	s->pgoff = vma->vm_pgoff;
> > +
> > +	if (vma->vm_file)
> > +		s->file = get_file(vma->vm_file);
> > +}
> > +
> > +static bool vma_snapshot_changed(struct vma_snapshot *s,
> 
> > +				 struct vm_area_struct *vma)
> 
> Can the VMA potentially be any arbitrary VMA that might now be remapped in
> place? Like anon vs. file and same file and offset?
> 
> 
> > +{
> > +	vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
> > +
> 
> You have a comment for each of the other cases, so one here is useful I
> think, e.g.:
> 
> 	/* Have any UFFD flags (missing, WP, minor) changed? */
> 
> > +	if (!vma_flags_same_pair(&s->flags, &flags))
> > +		return true;
> 
> > +
> > +	/* VMA type or effective uffd_ops changed while the lock was dropped */
> 
> Can the 'effective' (probably better to say copy or use effective
> throughout) uffd_ops change though? You already check that VMA_SHARED_BIT
> is either set or unset across the lock drop above so is the copy_ops check
> even meaningful here?

Yes, it can change if a shmem VMA changes from SHARED to PRIVATE or vice
versa.
 
> > +	if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
> > +		return true;
> Surely we should also check that the UFFD context matches (accounting for
> NULL cases)?

It's checked in mfill_get_vma().
 
> Could we not otherwise have weird situations across UFFD contexts if both
> VMAs happen to contain identitical properties otherwise?
> 
> This seems to be a canonical part of identifying a UFFD VMA so strange to
> not see it here?
> 
> > +
> > +	/* VMA was anonymous before; changed only if it no longer is */
> > +	if (!s->file)
> > +		return !vma_is_anonymous(vma);
> > +
> > +	/* VMA was file backed, but inode or offset has changed */
> > +	if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
> > +	    vma->vm_pgoff != s->pgoff)
> > +		return true;
> 
> Hm so are we OK with a VMA where the file has been closed, then the same
> inode re-opened at the exact same offset? (e.g. vma->vm_file differs)

The copy will go to exactly the same place in that case.
 
> Would this be problematic with hugetlbfs or shmem?
> 
> I guess we pin the inode so the f_inode check _should_ be valid, from that
> side.
> 
> > +
> > +	return false;
> > +}
> > +
> > +static void vma_snapshot_put(struct vma_snapshot *s)
> > +{
> > +	if (s->file)
> > +		fput(s->file);
> > +}
> > +
> > +DEFINE_FREE(snapshot_put, struct vma_snapshot *, if (_T) vma_snapshot_put(_T));
> > +
> >  static int mfill_copy_folio_retry(struct mfill_state *state,
> >  				  struct folio *folio)
> >  {
> > -	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
> > +	struct vma_snapshot s = { 0 };
> > +	struct vma_snapshot *p __free(snapshot_put) = &s;
> 
> Could we avoid these single letter var names?

You suggest to call it a_dummy_pointer_to_allow_use_of_free_cleanup? ;-P
> 
> >  	unsigned long src_addr = state->src_addr;
> >  	void *kaddr;
> >  	int err;
> >
> > +	vma_snapshot_get(&s, state->vma);
> > +
> >  	/* retry copying with mm_lock dropped */
> >  	mfill_put_vma(state);
> >
> > @@ -467,12 +543,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
> >  	if (err)
> >  		return err;
> >
> > -	/*
> > -	 * The VMA type may have changed while the lock was dropped
> > -	 * (e.g. replaced with a hugetlb mapping), making the caller's
> > -	 * ops pointer stale.
> > -	 */
> 
> This comment we can lose given we are explicitly comparing snapshots, but I
> think it's not great to explicitly point out that we're doing this because
> of the lock being dropped, we should say that somewhere.
> 
> > -	if (vma_uffd_ops(state->vma) != orig_ops)
> > +	if (vma_snapshot_changed(&s, state->vma))
> >  		return -EAGAIN;
> >
> >  	err = mfill_establish_pmd(state);
> > @@ -545,19 +616,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
> >
> >  static int mfill_atomic_pte_copy(struct mfill_state *state)
> >  {
> > -	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> > -
> > -	/*
> > -	 * The normal page fault path for a MAP_PRIVATE mapping in a
> > -	 * file-backed VMA will invoke the fault, fill the hole in the file and
> > -	 * COW it right away. The result generates plain anonymous memory.
> > -	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
> > -	 * generate anonymous memory directly without actually filling the
> > -	 * hole. For the MAP_PRIVATE case the robustness check only happens in
> > -	 * the pagetable (to verify it's still none) and not in the page cache.
> > -	 */
> 
> (As mentioned above) I hate that we lose this comment (or the gist of it at
> least), can we please move it up to the copy ops function?

Will move it before the copy_ops()
 
> > -	if (!(state->vma->vm_flags & VM_SHARED))
> > -		ops = &anon_uffd_ops;
> 
> A comment here would maybe be useful. But with a function rename and a
> comment at the function itself maybe OK without.
> 
> > +	const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);
> 
> Can we please have a:
> 
> 	/* Only async W/P can have missing ops, and that can't copy. */
> 	VM_WARN_ON_ONCE(!ops);

It would be the third time :-D
 
> Check here to make it absolutely clear you're not running straight into a
> NULL pointer deref in __mfill_atomic_pte()? Maybe worth putting a similar
> assert there too.
> 
> >
> >  	return __mfill_atomic_pte(state, ops);
> >  }
> >
> > base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
> > --
> > 2.53.0
> >
> 
> Thanks, Lorenzo

-- 
Sincerely yours,
Mike.

