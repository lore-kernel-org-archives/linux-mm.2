Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC3CCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FA76B0005; Wed, 20 May 2026 08:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740A86B0088; Wed, 20 May 2026 08:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657176B008A; Wed, 20 May 2026 08:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5114E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:53:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0D4AC1576
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:53:42 +0000 (UTC)
X-FDA: 84787789884.13.B9DC610
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 17EF440008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:53:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LH71BuEI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779281621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQ5FPHELtgn1sRAnAV+E5ESjcFvLQBKexCF9mafR+bo=;
	b=RLS4CaOND75PKFVBiuLcM5HG7pyoLUIxBjtPxobrHin9AjD2g5zT10nK9dH2I+9AG114n8
	1t4vUng9ufaV1dKCH4PP1EIMWwsewTnDo0LRUdNgY24GCDx/XI4PsQUFH9oQJExrYrcmOY
	J0J4Xuvjs5IJczihXx7bJ1/BDQfRi34=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LH71BuEI;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779281621; a=rsa-sha256;
	cv=none;
	b=bAWTasfxJ9p9b4bg7r2q9+65U4oH+ZFreJBVf2sUMFYE++BQvgWkKmfyaF1V9fX/VdtBJF
	q5DjvYUflTpg+mbOVmsvamoamr5X9hXHEPihipEUTDcjDqBstJi7G3nRCkECFEdeia2Eu5
	WTFpdDhp/Q1Ee+ePTF6UZnlV7KvLTA4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CE234391D;
	Wed, 20 May 2026 12:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE97F1F000E9;
	Wed, 20 May 2026 12:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779281620;
	bh=DQ5FPHELtgn1sRAnAV+E5ESjcFvLQBKexCF9mafR+bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LH71BuEIN6ruGldi7EGQ0oh/DhaPnQ1NvZSV/E0cFyuIrYHlxxi3LJvNgi1MDtV/z
	 jS1ZyKeNgPgrcMrwXq9N6nam3E80jpS9DHv3AJbNvD6BY5FEOkKWCTnPma8g8ASPtO
	 6y9qyGroMWALaqjvh7zW5TQadRAJ9gJIrQTI4iFEzisCqxUDJ5a7oslmOrGmmy85w7
	 bz+Lppwq2HXYK90bh3HWiXMWyHGkYZM90OBi0be43dJpW3FKbwxw+qTX+5AHPSh+jQ
	 /wD2jIaUV43OQ4z6YAiVWHTRvE9bblLXvLp/SvCfLa44rblGMQ3sm25zkfwP8FZytN
	 wZtOo2EmL0/lw==
Date: Wed, 20 May 2026 15:53:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ag2uzVgx2Xl7zi58@kernel.org>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
X-Stat-Signature: qjfgehh45i9zzxbm9bnexwx4h4pke6or
X-Rspamd-Queue-Id: 17EF440008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779281620-27142
X-HE-Meta: U2FsdGVkX1+seyCX9zOGg83NCHV7AA2UszdJI9FROwNds/QkFB+KLVG5NTLdPJO7ZUHYpOhYnIdPpHoyJutBTxPLUJVf06lrhRvJ+PeThagmPL/sz1svBFjDN9cMp8A9PwqIj9T9XzObAGh+3/MukSc+rRTa+y0OOEdRhGIeGSoUp6WpL3OaeV/MKetbbZbYq8b/4L+naZy5JczuM494VCUPYkkxCr/hOQRYEPuTyljJZq/7VXwYBCng91cmlb6vs94U0pzzpr9Gl7c5FhfRSi5lVhZqJKUNYu2e+nS1aFulthsGYoRT8Q4V5fEdz8Ylr0wxnnN7OSvcuGJzqrSlSp8jepcs8wxED5uRDF9ZtLO6tNsFZVn/Y0HUJXDO/VFt3PhQQmF/19Cgkbk7QdPRwGguOWl12WdLq7EdpAUEGjvtxOBNYnPXzZEOPLMTUcQ/pc17bqF09467ynIHw84OiXtxe1psUhcMdx1MDP1hkNsv48GC7+WGXY6A3EW7cuyvU0JIKqJ5vKXHX2O8TTPDEziU1OvjmkixZ9kb94LKI2CVjsVMWNjPUPfjXW923g7b17X55LGAD0QV/zg1DCSb/kB26u1PWq2S1Tt+fa9UwZ0eUmyOwF8vdecrXTPu7C8A+kwa/I0EevEE/F7EiHxXfEOx1xTScs9+suI+e35CaxAoM5muN5TYT/RSqNCxXcIs0AXlaKgj/pnSYo8vVP4++XtWLQ2YwYdUAe7a56wzZohagix3GWEbWZDxKTli8uDwVdWFGFJr/4DP7VgMgvoH+bpGB64LlgLPpuWRU2WdT8PI1nkwyP0dhPZScNJFlQeMgAlU4bRdiRHu6eYSSLhAoVZHWf5Zl/tOo2F5ykWKY8D45pjOicv3aiIMY5KFYpuH6blghmswqrWACjSxFeR4RFxU6ISH/clT3ei/2ChZOeYLEUwz6gRejco3JGxRjfteRJEP3F7XYIAVp4nsfWG
 HbUKCADy
 ri/aTVo56R084apklqSc8rpLyFfk5B2KN9e/MXLb+o+wxYZ8rZP5kjQ2pjvRMElH7j9MqBVjIZKC1HNj4yzLv1pKvYV3ZUVqcbGjbe6woDwoPEqm377FeaRtAx2lGGMesqKRi7AJIcW8c2WapLMoxo9DsMZ2hxoTB0SYHtlF1OGQ2ZE45HB96j8ta9RBGvjDV8Ppp3I6ycOOogNem9NylIypfACrdELsDZyytnFt+jQ5RurJUIAgmhu51saSuBD/9NzM/GhGz8KnVfeekb3CnAQsyc8e7zuT3em2a/0dmYuKcJEx2JxJfTV4F8zxPSQeDqDr9diG8dGMslG11PgGUwt/ZCL6Jt4I5sv6+gSpeG0O+39R1elAsGb+o9zFuRUGa64tOudGWwcpns9JkWKy4StrE96jawsxce+UkBRzBt9V1+0mD0F0PSB/r2Wj83vywsLAGYFKt3vL2v6gXbyTf6Tk/uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 01:09:04PM +0200, David Hildenbrand (Arm) wrote:
> On 5/19/26 07:25, Mike Rapoport wrote:
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
> > 
> > Introduce helpers for more comprehensive comparison of VMA state:
> > - vma_snapshot_get() to save the relevant VMA state into a struct
> >   vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
> >   vm_file and pgoff) before dropping the lock
> > - vma_snapshot_changed() to compare the saved state with the state of the
> >   VMA acquired after retaking the locks
> > - vma_snapshot_put() to release vm_file pinning.
> > 
> > Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
> > error handling paths in mfill_copy_folio_retry().
> > 
> > Add vma_uffd_copy_ops() to avoid code duplication when original ops of
> > shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.
> > 
> > Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
> > Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
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
> > +{
> > +	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> > +
> > +	if (!ops)
> > +		return NULL;
> > +
> > +	/*
> > +	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> > +	 * memory. This is an effective ops override, so retry validation must
> > +	 * compare the override result, not just vma->vm_ops->uffd_ops.
> > +	 */
> > +	if (!(vma->vm_flags & VM_SHARED))
> > +		return &anon_uffd_ops;
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
> > +
> > +struct vma_snapshot {
> > +	const struct vm_uffd_ops *copy_ops;
> > +	const struct vm_uffd_ops *ops;
> > +	struct file *file;
> > +	vma_flags_t flags;
> > +	pgoff_t pgoff;
> > +};
> 
> As this is all uffd specific, I wonder whether that should be "struct
> uffd_vma_snapshot"/"vma_uffd_snapshot" etc.

It's local to this file, I wouldn't worry about namespacing until there's
an actual need if it will ever arise.
 
> From a high level, this LGTM.
> 
> I wish we could identify relevant VMA changes more easily. Like, using a per-MM
> sequence counter that we simply increment on any VMA changes.

Do you mean per-VMA?
Per-MM counter would capture unrelated changes, e.g. an masvise() for
unrelated range.

We kinda have an infrastructure to detect VMA changes that affect uffd
operation for non-cooperative, we can also hook on that even if
UFFD_EVENT_* are not requested, but that's way more involved that this VMA
snapshot.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

