Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05F7105F79F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2ED16B0089; Fri, 13 Mar 2026 07:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1F26B008A; Fri, 13 Mar 2026 07:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D943B6B008C; Fri, 13 Mar 2026 07:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4C166B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:58:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 909A0140143
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:58:50 +0000 (UTC)
X-FDA: 84540893220.03.58F3EA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20DC6180004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:58:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YH9fi2HV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773403129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WIZF8M+VVWtUM1h+b0PzSCkMMMbyBLLph7AX19YABc=;
	b=dxGhMCEe2rCGaGa66rTpGr//wLRl/IU+5OGvY8YNFx4uVASMFMA5RmcBE3cWGKcxiTvF2v
	sBkYAWzG5jj/OBih1iFSCdjqHkuRqnoOxIpq8RzzzUivBamQ3Y9XvuoeFgBoIfkz0VK32j
	uUr7a42lVDuDfhcQ+q0Vd/XovcwMjG0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YH9fi2HV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773403129; a=rsa-sha256;
	cv=none;
	b=rD0/mXSbsnAIctR65jLoZ/sH6rlLIhYTjGwEABIzPJ7Z7SYId7I5mJym6mc113AaCBRTZw
	BVMuDbyfmJNQcHk5ZjD8o/8QiBTDsx3c12Vkr6N0FPMQ5h7ej9O3z+B8jQnHkHTriHjfd2
	nVXHQfT4e9XVQqa3vGI5aw3yisyHd3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 598406012B;
	Fri, 13 Mar 2026 11:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4395C19421;
	Fri, 13 Mar 2026 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773403128;
	bh=tJ78C2ydWglS/s0futzZmXxSLW3lVjkdvHe7e96jLE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YH9fi2HVtrdakURceyoTnR9imhhUqeHiuq7JHN+6HvuFrlUSJsiuF29UcGpLCKg3o
	 yR+UyV1f1BFpqY+IWXugGiLi9NVJZrpDyh/aROXOje2VjRHWkUFB0oujSJlQlpAdQo
	 u5lUPCjabMabw5dVPXLEIbrudAxf4v8i3DazYXIs6lho6UiGsyEDdl7A1lHoyDebMe
	 e+Emrt9EFSCc8cYmkL35NpZo/jInX4DicI/FKQ9McovSfhd9+0QvLF/owOnrwsnPBW
	 AaZB7F9noxWYSNs2Bod/B5FC9NnzCvnUnqzQPLstIM2ufZOs1XOXeNpfH7g8JYzT3u
	 K5SwuaZiCuw+w==
Date: Fri, 13 Mar 2026 11:58:36 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Long Li <longli@microsoft.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-arm-kernel@lists.infradead.org, 
	linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 04/15] mm: add vm_ops->mapped hook
Message-ID: <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
References: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
 <20260313110238.2500603-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313110238.2500603-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 20DC6180004
X-Stat-Signature: euozbqgg8r14moe9founas5ht5qymw9y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773403128-181189
X-HE-Meta: U2FsdGVkX1/Rd4hSf63dW07qwjYGdusnjeBkiE4ePg8+L3Q+FEBhdl1XtclhrMkIE9l2B6TyvMXxCzftn2Wh1dfGx8Aa4TmGBWgkOoRbp+9zgTDCxFqLIKOguip09RwLkFGygQrGoDb/768X1Pb8CSrLaXlMRrbj6XYAO97T1CUMpSkfmQSFkMMyyohucGlOqHWUEOKdjEc6W/JGKhCEZrmshRgE4FJyr6eylydZNB5l13zRpGzIqJ6Y5O02wF/s/wkyN+GsM4rvpDyTt4mk43qkhVNrHzl+vRV1NHmuP3n48eoji71N93rXq491y4OZ/QBYmQymIKvdIWHstACFEib7ivHOifmfkLfo75FRSJXO34VeNFOiC76K5GDr2ehvJO/MUdvmw8ymyq32LFTWoxKb3sKO5Ipx+uyk1q3zoCQ2+Rf1fiWWS2EnQP+r3oOMgGEZtMRwtim3EW0Sbq+Y4uaykaCGl4L27ZsCL7DJ+bxXcW6KYMpYUvHOcbYoSqAaZZMCLQcGY3CBqCEkTl4v8NiVnV1EzKw+QDYXLHqabxtoJ0gcjMKGUDNCy2fmlPFgg7qH4ohUo9ZdLsiC/ouRaHGOXdaPQDaIP+7WtG5fjs60qFnzOzYlJLhHeFlb7wx0CQ9qq1bDCab4/xKWHaZal9fGa5fMdNbYARLClS2OtUb/QIFyhnbcHWYvj4skSoEoxP2V9LjUfnqTtzWPBu0p4ty1Wx67+XmBi5eboMKB3Osq/qKn4N9fbwlJMwf6iHuKoi8XpYLOEp4gEKgTcCl4uIDC8uUMV6KCHpQWpdKteBW/WdbHJend8LuMoUgbCRnX0u6FnqW+vS14pIFLnzhS8VXhunspDiSJrcKwXFU6qWO8mdeC8dy3LZ/VnlVC4R43niTN5EfvuYMkUBUq/Qd7rBb0Sbg98xPd440w5dR5wc92fRTeFgY57ikbi4trlH98O71K6p6b7SAPq7XGNmF
 SIyjVW/z
 j6P30jmIIHhB3hy0SoJqdLHlWGRanmr1yxLjl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 04:02:36AM -0700, Usama Arif wrote:
> On Thu, 12 Mar 2026 20:27:19 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Previously, when a driver needed to do something like establish a reference
> > count, it could do so in the mmap hook in the knowledge that the mapping
> > would succeed.
> >
> > With the introduction of f_op->mmap_prepare this is no longer the case, as
> > it is invoked prior to actually establishing the mapping.
> >
> > To take this into account, introduce a new vm_ops->mapped callback which is
> > invoked when the VMA is first mapped (though notably - not when it is
> > merged - which is correct and mirrors existing mmap/open/close behaviour).
> >
> > We do better that vm_ops->open() here, as this callback can return an
> > error, at which point the VMA will be unmapped.
> >
> > Note that vm_ops->mapped() is invoked after any mmap action is
> > complete (such as I/O remapping).
> >
> > We intentionally do not expose the VMA at this point, exposing only the
> > fields that could be used, and an output parameter in case the operation
> > needs to update the vma->vm_private_data field.
> >
> > In order to deal with stacked filesystems which invoke inner filesystem's
> > mmap() invocations, add __compat_vma_mapped() and invoke it on
> > vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped callback is
> > handled when an mmap() caller invokes a nested filesystem's mmap_prepare()
> > callback.
> >
> > We can now also remove call_action_complete() and invoke
> > mmap_action_complete() directly, as we separate out the rmap lock logic to
> > be called in __mmap_region() instead via maybe_drop_file_rmap_lock().
> >
> > We also abstract unmapping of a VMA on mmap action completion into its own
> > helper function, unmap_vma_locked().
> >
> > Additionally, update VMA userland test headers to reflect the change.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  include/linux/fs.h              |  9 +++-
> >  include/linux/mm.h              | 17 +++++++
> >  mm/internal.h                   | 10 ++++
> >  mm/util.c                       | 86 ++++++++++++++++++++++++---------
> >  mm/vma.c                        | 41 +++++++++++-----
> >  tools/testing/vma/include/dup.h | 34 ++++++++++++-
> >  6 files changed, 158 insertions(+), 39 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index a2628a12bd2b..c390f5c667e3 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct file *file)
> >  }
> >
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> > +int __vma_check_mmap_hook(struct vm_area_struct *vma);
> >
> >  static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > +	int err;
> > +
> >  	if (file->f_op->mmap_prepare)
> >  		return compat_vma_mmap(file, vma);
> >
> > -	return file->f_op->mmap(file, vma);
> > +	err = file->f_op->mmap(file, vma);
> > +	if (err)
> > +		return err;
> > +
> > +	return __vma_check_mmap_hook(vma);
> >  }
> >
> >  static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 12a0b4c63736..7333d5db1221 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -759,6 +759,23 @@ struct vm_operations_struct {
> >  	 * Context: User context.  May sleep.  Caller holds mmap_lock.
> >  	 */
> >  	void (*close)(struct vm_area_struct *vma);
> > +	/**
> > +	 * @mapped: Called when the VMA is first mapped in the MM. Not called if
> > +	 * the new VMA is merged with an adjacent VMA.
> > +	 *
> > +	 * The @vm_private_data field is an output field allowing the user to
> > +	 * modify vma->vm_private_data as necessary.
> > +	 *
> > +	 * ONLY valid if set from f_op->mmap_prepare. Will result in an error if
> > +	 * set from f_op->mmap.
> > +	 *
> > +	 * Returns %0 on success, or an error otherwise. On error, the VMA will
> > +	 * be unmapped.
> > +	 *
> > +	 * Context: User context.  May sleep.  Caller holds mmap_lock.
> > +	 */
> > +	int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgoff,
> > +		      const struct file *file, void **vm_private_data);
> >  	/* Called any time before splitting to check if it's allowed */
> >  	int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> >  	int (*mremap)(struct vm_area_struct *vma);
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 7bfa85b5e78b..f0f2cf1caa36 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const struct folio *folio)
> >   * mmap hook and safely handle error conditions. On error, VMA hooks will be
> >   * mutated.
> >   *
> > + * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prepare().
> > + *
> >   * @file: File which backs the mapping.
> >   * @vma:  VMA which we are mapping.
> >   *
> > @@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_struct *vma)
> >  /* unmap_vmas is in mm/memory.c */
> >  void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
> >
> > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > +{
> > +	const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > +
> > +	mmap_assert_locked(vma->vm_mm);
> > +	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > +}
> > +
> >  #ifdef CONFIG_MMU
> >
> >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> > diff --git a/mm/util.c b/mm/util.c
> > index dba1191725b6..2b0ed54008d6 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *folio)
> >  EXPORT_SYMBOL(flush_dcache_folio);
> >  #endif
> >
> > +static int __compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	struct vm_area_desc desc = {
> > +		.mm = vma->vm_mm,
> > +		.file = file,
> > +		.start = vma->vm_start,
> > +		.end = vma->vm_end,
> > +
> > +		.pgoff = vma->vm_pgoff,
> > +		.vm_file = vma->vm_file,
> > +		.vma_flags = vma->flags,
> > +		.page_prot = vma->vm_page_prot,
> > +
> > +		.action.type = MMAP_NOTHING, /* Default */
> > +	};
> > +	int err;
> > +
> > +	err = vfs_mmap_prepare(file, &desc);
> > +	if (err)
> > +		return err;
> > +
> > +	err = mmap_action_prepare(&desc, &desc.action);
> > +	if (err)
> > +		return err;
> > +
> > +	set_vma_from_desc(vma, &desc);
> > +	return mmap_action_complete(vma, &desc.action);
> > +}
> > +
> > +static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> > +	void *vm_private_data = vma->vm_private_data;
> > +	int err;
> > +
> > +	if (!vm_ops->mapped)
> > +		return 0;
> > +
>
> Hello!
>
> Can vm_ops be NULL here?  __compat_vma_mapped() is called from
> compat_vma_mmap(), which is reached when a filesystem provides
> mmap_prepare.  If the mmap_prepare hook does not set desc->vm_ops,
> vma->vm_ops will be NULL and this dereferences a NULL pointer.

I _think_ for this to ever be invoked, you would need to be dealing with a
file-backed VMA so vm_ops->fault would HAVE to be defined.

But you're right anyway as a matter of principle we should check it! Will fix.

>
> For e.g. drivers/char/mem.c, mmap_zero_prepare() would trigger
> a NULL pointer dereference here.
>
> Would need to do
> 	if (!vm_ops || !vm_ops->mapped)
> 		return 0;
>
> here

Yes.

>
>
> > +	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff, file,
> > +			     &vm_private_data);
> > +	if (err)
> > +		unmap_vma_locked(vma);
>
> when mapped() returns an error, unmap_vma_locked(vma) is called
> but execution continues into the vm_private_data update below.  After
> unmap_vma_locked() the VMA may be freed (do_munmap can remove the VMA
> entirely), so accessing vma->vm_private_data after that is a
> use-after-free.

Very good point :) will fix thanks!

Probably:

	if (err)
		unmap_vma_locked(vma);
	else if (vm_private_data != vma->vm_private_data)
		vma->vm_private_data = vm_private_data;

	return err;

Would be fine.

>
> Probably need to do:
> 	if (err) {
> 		unmap_vma_locked(vma);
> 		return err;
> 	}
>
> > +	/* Update private data if changed. */
> > +	if (vm_private_data != vma->vm_private_data)
> > +		vma->vm_private_data = vm_private_data;
> > +
> > +	return err;
> > +}
> > +
> >  /**
> >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
> >   * existing VMA and execute any requested actions.
> > @@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
> >   */
> >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
> >  {
> > -	struct vm_area_desc desc = {
> > -		.mm = vma->vm_mm,
> > -		.file = file,
> > -		.start = vma->vm_start,
> > -		.end = vma->vm_end,
> > -
> > -		.pgoff = vma->vm_pgoff,
> > -		.vm_file = vma->vm_file,
> > -		.vma_flags = vma->flags,
> > -		.page_prot = vma->vm_page_prot,
> > -
> > -		.action.type = MMAP_NOTHING, /* Default */
> > -	};
> >  	int err;
> >
> > -	err = vfs_mmap_prepare(file, &desc);
> > -	if (err)
> > -		return err;
> > -
> > -	err = mmap_action_prepare(&desc, &desc.action);
> > +	err = __compat_vma_mmap(file, vma);
> >  	if (err)
> >  		return err;
> >
> > -	set_vma_from_desc(vma, &desc);
> > -	return mmap_action_complete(vma, &desc.action);
> > +	return __compat_vma_mapped(file, vma);
> >  }
> >  EXPORT_SYMBOL(compat_vma_mmap);
> >
> > +int __vma_check_mmap_hook(struct vm_area_struct *vma)
> > +{
> > +	/* vm_ops->mapped is not valid if mmap() is specified. */
> > +	if (WARN_ON_ONCE(vma->vm_ops->mapped))
> > +		return -EINVAL;
>
> I think vma->vm_ops can be NULL here. Should be:
>
> 	if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> 		return -EINVAL;

I think again you'd probably only invoke this on file-backed so be ok, but again
as a matter of principle we should check it so will fix, thanks!

>
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(__vma_check_mmap_hook);
> > +
> >  static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
> >  			 const struct page *page)
> >  {
> > @@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_area_struct *vma,
> >  	 * invoked if we do NOT merge, so we only clean up the VMA we created.
> >  	 */
> >  	if (err) {
> > -		const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > -
> > -		do_munmap(current->mm, vma->vm_start, len, NULL);
> > -
> > +		unmap_vma_locked(vma);
> >  		if (action->error_hook) {
> >  			/* We may want to filter the error. */
> >  			err = action->error_hook(err);
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 054cf1d262fb..ef9f5a5365d1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
> >  	return false;
> >  }
> >
> > -static int call_action_complete(struct mmap_state *map,
> > -				struct mmap_action *action,
> > -				struct vm_area_struct *vma)
> > +static int call_mapped_hook(struct vm_area_struct *vma)
> >  {
> > -	int ret;
> > +	const struct vm_operations_struct *vm_ops = vma->vm_ops;
> > +	void *vm_private_data = vma->vm_private_data;
> > +	int err;
> >
> > -	ret = mmap_action_complete(vma, action);
> > +	if (!vm_ops || !vm_ops->mapped)
> > +		return 0;
> > +	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,
> > +			     vma->vm_file, &vm_private_data);
> > +	if (err) {
> > +		unmap_vma_locked(vma);
> > +		return err;
> > +	}
> > +	/* Update private data if changed. */
> > +	if (vm_private_data != vma->vm_private_data)
> > +		vma->vm_private_data = vm_private_data;
> > +	return 0;
> > +}
> >
> > -	/* If we held the file rmap we need to release it. */
> > -	if (map->hold_file_rmap_lock) {
> > -		struct file *file = vma->vm_file;
> > +static void maybe_drop_file_rmap_lock(struct mmap_state *map,
> > +				      struct vm_area_struct *vma)
> > +{
> > +	struct file *file;
> >
> > -		i_mmap_unlock_write(file->f_mapping);
> > -	}
> > -	return ret;
> > +	if (!map->hold_file_rmap_lock)
> > +		return;
> > +	file = vma->vm_file;
> > +	i_mmap_unlock_write(file->f_mapping);
> >  }
> >
> >  static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > @@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> >  	__mmap_complete(&map, vma);
> >
> >  	if (have_mmap_prepare && allocated_new) {
> > -		error = call_action_complete(&map, &desc.action, vma);
> > +		error = mmap_action_complete(vma, &desc.action);
> > +		if (!error)
> > +			error = call_mapped_hook(vma);
> >
> > +		maybe_drop_file_rmap_lock(&map, vma);
> >  		if (error)
> >  			return error;
> >  	}
> > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> > index 908beb263307..47d8db809f31 100644
> > --- a/tools/testing/vma/include/dup.h
> > +++ b/tools/testing/vma/include/dup.h
> > @@ -606,12 +606,34 @@ struct vm_area_struct {
> >  } __randomize_layout;
> >
> >  struct vm_operations_struct {
> > -	void (*open)(struct vm_area_struct * area);
> > +	/**
> > +	 * @open: Called when a VMA is remapped or split. Not called upon first
> > +	 * mapping a VMA.
> > +	 * Context: User context.  May sleep.  Caller holds mmap_lock.
> > +	 */
> > +	void (*open)(struct vm_area_struct *vma);
> >  	/**
> >  	 * @close: Called when the VMA is being removed from the MM.
> >  	 * Context: User context.  May sleep.  Caller holds mmap_lock.
> >  	 */
> > -	void (*close)(struct vm_area_struct * area);
> > +	void (*close)(struct vm_area_struct *vma);
> > +	/**
> > +	 * @mapped: Called when the VMA is first mapped in the MM. Not called if
> > +	 * the new VMA is merged with an adjacent VMA.
> > +	 *
> > +	 * The @vm_private_data field is an output field allowing the user to
> > +	 * modify vma->vm_private_data as necessary.
> > +	 *
> > +	 * ONLY valid if set from f_op->mmap_prepare. Will result in an error if
> > +	 * set from f_op->mmap.
> > +	 *
> > +	 * Returns %0 on success, or an error otherwise. On error, the VMA will
> > +	 * be unmapped.
> > +	 *
> > +	 * Context: User context.  May sleep.  Caller holds mmap_lock.
> > +	 */
> > +	int (*mapped)(unsigned long start, unsigned long end, pgoff_t pgoff,
> > +		      const struct file *file, void **vm_private_data);
> >  	/* Called any time before splitting to check if it's allowed */
> >  	int (*may_split)(struct vm_area_struct *area, unsigned long addr);
> >  	int (*mremap)(struct vm_area_struct *area);
> > @@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
> >  	swap(vma->vm_file, file);
> >  	fput(file);
> >  }
> > +
> > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > +{
> > +	const size_t len = vma_pages(vma) << PAGE_SHIFT;
> > +
> > +	mmap_assert_locked(vma->vm_mm);
> > +	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > +}
> > --
> > 2.53.0
> >
> >

Cheers, Lorenzo

