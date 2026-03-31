Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBBA9109B48D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EDE6B0095; Tue, 31 Mar 2026 11:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5D16B009F; Tue, 31 Mar 2026 11:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4336A6B00A0; Tue, 31 Mar 2026 11:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 350606B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:24:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFB47B7310
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:24:05 +0000 (UTC)
X-FDA: 84606728850.03.BE63B55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3668D40005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:24:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKqiA6JX;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+549Nln8DqoqXF0qCkIjYDCZp/f92HAIUb2SiSCCNY=;
	b=3g5BAUiCNGYllLPwG9U85lQFfY4jPGqPkOPzxCQXAQGyWyz/U9wLs4+90HW+W9QEZPn3pq
	IoQ1z0Yeym8GGFfOqSUCRItozRXZdkCtogoNbmC8NTHQ7PdM1UkJK+QWmjpxWZom00bJGr
	kpo/94ZyDQ88OtUBXNOo/fMEPuG81fo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKqiA6JX;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970644; a=rsa-sha256;
	cv=none;
	b=x7EclEnku4XAYH2ZV26qvILk1xRx2EewiWN3KrFiFAv0bJjFQaNQqtWWU3tROOzVu3Jp35
	oV2jpKQ0zhtkJhBaFRh5VXFDMFoZZslyOpdXjRI8Fa4fiyPht/NASTQZUBnFBpNN8jClYs
	5rqHMx+GQfgK6UpvgBFbybINSCMp4PY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1340342E01;
	Tue, 31 Mar 2026 15:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925D4C19423;
	Tue, 31 Mar 2026 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774970642;
	bh=3mA8yhmwSAY4oxzzAbFQyFqOh6xAwsxwgZjjBw72kWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YKqiA6JXJp8cZOzS0sGVZ37Nc19QkYMmlautv+TkliDyiVF4PeV3zMHiNLwUI4RK/
	 vuWX6IwSC+JpiWxF9sDdC+Rknar2iLWvFVMr216e5uKXpDJfqlRHSh0ta6rLRFbcsf
	 7x4HHDlGp64qAgFz+icMggzhUz45aVTmLjG5bukEVsMCsNdEocNsM2Bf4FT8xAnK7j
	 pYl891rWsuPwvkqM5G8WhKYxoV9vI7bQWZq07rcrh6tLx3TiqZ7TkIrU8odYJo5Ybe
	 NUWAWRKrHOD//+MV22oUMi4aPYxtvImourkUYscAFQtxeC19vapANRluBjwes0uwf3
	 BkBzpSX8Kjucw==
Date: Wed, 1 Apr 2026 00:24:01 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <acvnEd3-s6XI26vb@hyeyoo>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-3-rppt@kernel.org>
 <actxscYZGFiyvUcs@hyeyoo>
 <acva_NKf7T5rbIC8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acva_NKf7T5rbIC8@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3668D40005
X-Stat-Signature: z1n3pkbu13dijbpkxc1a351xu46y869g
X-Rspam-User: 
X-HE-Tag: 1774970644-916642
X-HE-Meta: U2FsdGVkX1+1Xd1pjpkCXqkkrO8cBSU4RVOx75sOyCa1KUMhPyf8BBz/BoN+J+E9bXoR9hlQpFIvMehAimJ0J5WhabxSTa3isL3kZo0B7UyAO1P9KnyzAypG9AI/OHeRMXBts+Pt7XGPfMy5S82e+3/WbbEKGdRC+g2gkyPk6CDJC/+LKiY0P+oZ8sT8jslP8mbC3/zv67OTuoo7+kpc0Sk2SwQHUP8/SFjrev8xRR+UAvFgufR9hIeXpA9AyG0EgPjkxD70spLMzxuziGYLrON/tkr3rcVJkOMZRZYUoM1SvUX6O2emAbE1+eEoFdbZowgcqavPsRC1kGyvpWIJ9kvrUdJmeBlQfRUdsxGt68E1WqEbvHuWHGSL54QbgPPEgjcHk1ZUrPHeMWzgcLP2/a5yHxG1lRLjEBM8Av0eUITYld6jKSZ5GWsDw7b8Mfl/TmBCMOybnbnPAJ0fmSmfU9N4gKnOOGp/VtyT6uwyjp0hahslqBmV1zJOI3CszX5asYCMjsvrSbXrET0eFPij97uv2wpRt56xuNd0rTYzn7ilAPB1fJClucgDUFwWf+ea7THcJ5yNSBaaJ4TzJJy1BcnvzTWtUcmA2HXEW0Gud1C8GaIxUGIZecKQKjKn6StZYa0FmRtQYf/7KQp9nSC625C+5zLd/3Wxt6YLWJ8sVJSAUyrqAlZOvoLnrw0w0jZ0oHZba0ITm4Hvfr+/GC+dBz3TnF+hb3BFBz+xgHYEFg18fYj1Pz/54pBNRvYgq084pbzR/2/wHoDlW6AjRAY0DdJbO4MssAIFBHSK99ebN9SECVSgjLk3Qepdicw9nBXWIhlaPp1xi/qnEEzkgSBnDLSWIp6ZmV/3Z08W6b7oLPzh6vbxwrgoJrK1JHL5H6fG5QCcm6ckxW4Xi/4E9UwM37qD6iEQTCzw4dOvFC9csxOJ1JqfpgenYRVBw4Czj+Pvszj3MOf21fN2USt6pz3
 SThw43N2
 sT5df
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:32:28PM +0300, Mike Rapoport wrote:
> Hi Harry,
> 
> On Tue, Mar 31, 2026 at 04:03:13PM +0900, Harry Yoo (Oracle) wrote:
> > On Mon, Mar 30, 2026 at 01:11:03PM +0300, Mike Rapoport wrote:
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > 
> > > mfill_atomic() passes a lot of parameters down to its callees.
> > > 
> > > Aggregate them all into mfill_state structure and pass this structure to
> > > functions that implement various UFFDIO_ commands.
> > > 
> > > Tracking the state in a structure will allow moving the code that retries
> > > copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
> > > loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
> > > memory.
> > > 
> > > The mfill_state definition is deliberately local to mm/userfaultfd.c,
> > > hence shmem_mfill_atomic_pte() is not updated.
> > > 
> > > [harry.yoo@oracle.com: properly initialize mfill_state.len to fix
> > >                        folio_add_new_anon_rmap() WARN]
> > > Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > ---
> > >  mm/userfaultfd.c | 148 ++++++++++++++++++++++++++---------------------
> > >  1 file changed, 82 insertions(+), 66 deletions(-)
> > > 
> > > @@ -790,12 +804,14 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> > >  	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > >  		goto out_unlock;
> > >  
> > > -	while (src_addr < src_start + len) {
> > > -		pmd_t dst_pmdval;
> > > +	state.vma = dst_vma;
> > 
> > Oh wait, the lock leak was introduced in patch 2.
> 
> Lock leak was introduced in patch 4 that moved getting the vma.

Still not sure what I could possibly be missing, so let me try again.
when I check out to this commit "userfaultfd: introduce struct mfill_state" I see:
| static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
|                                             unsigned long dst_start,
|                                             unsigned long src_start,
|                                             unsigned long len,
|                                             uffd_flags_t flags)
| {
|         struct mfill_state state = (struct mfill_state){
|                 .ctx = ctx,
|                 .dst_start = dst_start,
|                 .src_start = src_start, .flags = flags,
|                 .len = len,
|                 .src_addr = src_start,
|                 .dst_addr = dst_start,
|         };
|

[ ...snip...]

| retry:
|         /*
|          * Make sure the vma is not shared, that the dst range is
|          * both valid and fully within a single existing vma.
|          */
|         dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);

It acquires the vma lock (or mmap_lock) here, but doesn't set state.vma.

|         if (IS_ERR(dst_vma)) {
|                 err = PTR_ERR(dst_vma);
|                 goto out;
|         }
| 
|         /*
|          * If memory mappings are changing because of non-cooperative
|          * operation (e.g. mremap) running in parallel, bail out and
|          * request the user to retry later
|          */
|         down_read(&ctx->map_changing_lock);
|         err = -EAGAIN;
|         if (atomic_read(&ctx->mmap_changing))
|                 goto out_unlock;
| 
|         err = -EINVAL;
|         /*
|          * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
|          * it will overwrite vm_ops, so vma_is_anonymous must return false.
|          */
|         if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
|             dst_vma->vm_flags & VM_SHARED))
| 
|         /*
|          * validate 'mode' now that we know the dst_vma: don't allow
|          * a wrprotect copy if the userfaultfd didn't register as WP.
|          */
|         if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
|                 goto out_unlock;
|
|         /*
|          * If this is a HUGETLB vma, pass off to appropriate routine
|          */
|         if (is_vm_hugetlb_page(dst_vma))
|                 return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
|                                              src_start, len, flags);
|
|         if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
|                 goto out_unlock;
|         if (!vma_is_shmem(dst_vma) &&
|             uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
|                 goto out_unlock;
|
|         state.vma = dst_vma;

It is set here. So if anything before this jumps to `out_unlock`
label due to a sanity check,

[...]

|         while (state.src_addr < src_start + len) {                              
|                 VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);             
|                                                                                 
|                 pmd_t dst_pmdval;         
| [...]
| 
| out_unlock:
|         up_read(&ctx->map_changing_lock);
|         uffd_mfill_unlock(state.vma);

the `vma` parameter will be NULL?

If I'm not missing something this is introduced in patch 2 and
fixed in patch 4.

| out:
|         if (state.folio)
|                 folio_put(state.folio);
|         VM_WARN_ON_ONCE(copied < 0);
|         VM_WARN_ON_ONCE(err > 0);
|         VM_WARN_ON_ONCE(!copied && !err);
|         return copied ? copied : err;
| }

> > > @@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> > >  
> > >  out_unlock:
> > >  	up_read(&ctx->map_changing_lock);
> > > -	uffd_mfill_unlock(dst_vma);
> > > +	uffd_mfill_unlock(state.vma);
> > >  out:
> > > -	if (folio)
> > > -		folio_put(folio);
> > > +	if (state.folio)
> > > +		folio_put(state.folio);
> > 
> > Sashiko raised a concern [2] that it the VMA might be unmapped and
> > a new mapping created as a uffd hugetlb vma and leak the folio by
> > going through
> > 
> > `if (is_vm_hugetlb_page(dst_vma))
> >         return mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
> >                                     src_start, len, flags);`
> > 
> > but it appears to be a false positive (to me) because
> > 
> > `if (atomic_read(&ctx->mmap_changing))` check should have detected unmapping
> > and free the folio?
> 
> I think it's real, and it's there more or less from the beginning, although
> nobody hit it yet :)
> 
> Before retrying the copy we drop all the locks, so if the copy is really
> long the old mapping can be wiped and a new mapping can be created instead.

Oops, perhaps I should have imagined harder :)

> There's already a v4 of a patch that attempts to solve this:
> 
> https://lore.kernel.org/all/20260331134158.622084-1-devnexen@gmail.com

Thanks for the pointer!

> > [2] https://sashiko.dev/#/patchset/20260330101116.1117699-1-rppt%40kernel.org?patch=13671
> > 
> > >  	VM_WARN_ON_ONCE(copied < 0);
> > >  	VM_WARN_ON_ONCE(err > 0);
> > >  	VM_WARN_ON_ONCE(!copied && !err);

-- 
Cheers,
Harry / Hyeonggon

