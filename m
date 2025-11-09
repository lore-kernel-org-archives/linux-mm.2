Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514A9CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 07:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6C08E0010; Sun,  9 Nov 2025 02:11:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666FD8E0003; Sun,  9 Nov 2025 02:11:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EC48E0010; Sun,  9 Nov 2025 02:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B0698E0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:11:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD3AC140910
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:11:58 +0000 (UTC)
X-FDA: 84090199116.23.2236302
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21162180009
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:11:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVKWhFcm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762672317; a=rsa-sha256;
	cv=none;
	b=g3zQi9IcednLJiaNu8jw8vftHrAzU65aUa8HKXTZ0IxvgGTI5c73Xx6toOug7N/hhYzgfV
	47NXlosGZ9LrpgvoJu4kAZP3nVYMaEXela07M4Pr2j2JCUdZj4KyfcjxR6xLnbHG+oFZLT
	jV2lmzQvH/8P22YIvI8HTpzHVpCGbyE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVKWhFcm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762672317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jA5fhqGBMOQIcmvlhfsbq8pkS0VKtd4IfLzWgGCSFg=;
	b=MAtxBv/6ntZscV+N5jLrbrD5kRf4XZ0dJaD//aO7oj0dEye4ykBs1H13VNh5EkFGoF+Ntw
	tjZSav8cfVK4wBQkQKOkUZU/rqWAV9/42TmE+uxKFURy9FtuuAG6z4pSgmTxm4ShuUZbXm
	HrVMvQ4fRGxCbFe/ACprjV06s4wqi0A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F75E601B2;
	Sun,  9 Nov 2025 07:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D66C4CEF8;
	Sun,  9 Nov 2025 07:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762672316;
	bh=fz6YEmNbySw049IgPi0sWFOajARsPNxOfb00HrLa7F8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VVKWhFcmmgsl0CgGP3/akeP+0Deoi+k93/1z4vFV2wLPYduROhSgadLQkVRPas+ct
	 bXGtRL2xpjdwXydNiHc4niRWU3TVWR1KVz9Sk5iIXyx5yrFTu1d04HgF7JEHWJSAs+
	 zZe49jXIXS+EHNDOJFKdv27ji6NG0rMhyuLEKouXGZCNafwjes6GENkhi1UbW5CIB1
	 DUVR32kpzIqm6aG2/azj7wGzkR1hP39Obw+X4edU0YSRM0EZxYBlclJNh6ztFzEUJG
	 E0gdub8CEQJVy/junBGUitqhCWn0BrVwHk5Sx4K78HKJm95/a7Htmn+t2cjjGQh+a5
	 sMVUNSCPeCT4A==
Date: Sun, 9 Nov 2025 09:11:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aRA-se6hJPzHD3mA@kernel.org>
References: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQmplrpNjvCVjWb_@kernel.org>
 <mnjrtg62qh2rd353mbudryvs3neukt26xtovyddm5uosxurmfi@lldnrp7a3666>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mnjrtg62qh2rd353mbudryvs3neukt26xtovyddm5uosxurmfi@lldnrp7a3666>
X-Rspamd-Queue-Id: 21162180009
X-Rspamd-Server: rspam07
X-Stat-Signature: bh8emeb8ntgh4fr9tfrgwce6rcnxt5t1
X-Rspam-User: 
X-HE-Tag: 1762672316-726180
X-HE-Meta: U2FsdGVkX18FLnJaRYqznJUbEUloWhX03D/8NipSuX51S1O6jSMRFWIPlgouQDuL3elOkOIVQK9YdU3RpomS8fkl97R55MKAj9dwZAXWFuseJwCfKLNO78pRB+wWSjqVHEEok4KrPg+ifOrvgWP9JPWwDP/yav6a+AVvvlvuMVPD8G8hY2f8Tt2larERFR09XTdEKVZTgNYqEVLnFGSJ1OQBD73cZeDX/uJqhxI2Zap8EeEMnm52biib3e5nu9jj2DKfnyXyaEjUVtGhGsSnZ+tBDKz3HGI4Ya48CL8gibfMcvVzw+aP21OAPCR0OFZT3FBqKxbPc+PJA2MyDSm0+aMvJmac11OOAULW1RTqlpeEHV/36QenUX1TlIhq2ySsCTQeKOrUSkJZkYCGnmvnpJ5jgWHjdq57RtDj9J2yqHUFybYjE+vmJAxmrP2psIIhWHnu56R78iTpZphFv43YTPlak4Q3bMqFUYGoCWTbZYAv1jdEvXojt/SyOdDyXdznhYOQ3DfYzkQ2wUvtfX8AxMOHnjMGui9Pl8LSOpRatzAhIV/I7WkffpFSoQempUpOMkbzWEI20/3WvGFJPVKshvakIfnXaXs1fjfI8kP8A0Vc0VxdC4LzRfX5zISnJzdLAw2OTK1VFAohpL/o0K5GJMcsGibbv5wSYZBrFMC1pa73pN6qj9yclobf2hqJzQFnIn8aUyAsHoSdJlpmI3RMeoUCQi/KIFAZcVenDZXjQ0hjoy2UjS35DWG4l8nuMXKn/BW6/GBZTr77nO4YLXKMbRgbBZOf5HcEqSrVJNHeyS05VgydfBrpv3kv+hPo9BTUy8/E29z+qy7xyfikaYVYJSBgbk1Kru/4rzwYPUAs3F7QTO7k6mExCz93AQIx747WRmMfYtOTnD3lMnVaVjdAfv/zX/kY8jkS6zjKkkxWtbaONfcFjns1soR6EeJWGvSFEH8sQdYpDBkkL2qf9qw
 cu2ds2OQ
 u3pxMxW1DcKCGCPtiRZRcT6KnSib4nMXaNVdX1YNJ+GWnMDXD8YX6gx5dKpsV4qH/26Gdiq87d7o8anGQUzf0L60R8SxpVZ37JzRjpFnVvNImrfOvXZlq9XGKzU+uLCAE7kBldN8eSjMcdMgQYQcKatSbEpjQeSPaUjpdEe/YFJonjEhzOFyX9NnbELsLLCKLGicHRYlur+iVbqArRZviay68DhERVBNyQ6nxUBrjWCPqW2gV5Tk+5rUshQ2n5lFx/twwqMs7zzMTkbXUh4C3+a5Izcvm3T0mj+Mhngi199VDsatQDLnq8mGEG5ViizL0JbZ4fGC737NmjS2q52uX2/q5y+kJMMnQmZBWZqQaK+vlwR4zmRT0H1nR2Rs9rGE4wYA/O1MGQirLyw+0AR/TtiAL5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

On Thu, Nov 06, 2025 at 11:32:46AM -0500, Liam R. Howlett wrote:
> * Mike Rapoport <rppt@kernel.org> [251104 02:22]:
> > On Mon, Nov 03, 2025 at 10:27:05PM +0100, David Hildenbrand (Red Hat) wrote:
> > > 
> > > And maybe that's the main problem here: Liam talks about general uffd
> > > cleanups while you are focused on supporting guest_memfd minor mode "as
> > > simple as possible" (as you write below).
> > 
> > Hijacking for the technical part for a moment ;-)
> > 
> > It seems that "as simple as possible" can even avoid data members in struct
> > vm_uffd_ops, e.g something along these lines:
> 
> I like this because it removes the flag.
> 
> If we don't want to return the folio, we could modify the
> mfill_atomic_pte_continue() to __mfill_atomic_pte_continue() which takes
> a function pointer and have the callers pass a different get_folio() by
> memory type.  Each memory type (anon, shmem, and guest_memfd) would have
> a small stub that would be set in the vm_ops.

I'm not sure I follow you here.
What do you mean by "don't want to return the folio"? 

Isn't ->minor_get_folio() is already a different get_folio() by memory
type?

> It also looks similar to vma_get_uffd_ops() in 1fa9377e57eb1
> ("mm/userfaultfd: Introduce userfaultfd ops and use it for destination
> validation") [1].  But I always returned a uffd ops, which passes all
> uffd testing.  When would your NULL uffd ops be hit?  That is, when
> would uffd_ops not be set and not be anon?

The patch is a prototype. Quite possibly you are right and there's no need
to return NULL there.
 
> [1].  https://git.infradead.org/?p=users/jedix/linux-maple.git;a=blobdiff;f=mm/userfaultfd.c;h=e2570e72242e5a350508f785119c5dee4d8176c1;hp=e8341a45e7e8d239c64f460afeb5b2b8b29ed853;hb=1fa9377e57eb16d7fa579ea7f8eb832164d209ac;hpb=2166e91882eb195677717ac2f8fbfc58171196ce
> 
> Thanks,
> Liam
> 
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index d16b33bacc32..840986780cb5 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -605,6 +605,8 @@ struct vm_fault {
> >  					 */
> >  };
> >  
> > +struct vm_uffd_ops;
> > +
> >  /*
> >   * These are the virtual MM functions - opening of an area, closing and
> >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > @@ -690,6 +692,9 @@ struct vm_operations_struct {
> >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> >  					 unsigned long addr);
> >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > +#ifdef CONFIG_USERFAULTFD
> > +	const struct vm_uffd_ops *uffd_ops;
> > +#endif
> >  };
> >  
> >  #ifdef CONFIG_NUMA_BALANCING
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index c0e716aec26a..aac7ac616636 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -111,6 +111,11 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
> >  /* Flags controlling behavior. These behavior changes are mode-independent. */
> >  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
> >  
> > +struct vm_uffd_ops {
> > +	int (*minor_get_folio)(struct inode *inode, pgoff_t pgoff,
> > +			       struct folio **folio);
> > +};
> > +
> >  extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
> >  				    struct vm_area_struct *dst_vma,
> >  				    unsigned long dst_addr, struct page *page,
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b9081b817d28..b4318ad3bdf9 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -3260,6 +3260,17 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> >  	shmem_inode_unacct_blocks(inode, 1);
> >  	return ret;
> >  }
> > +
> > +static int shmem_uffd_minor_get_folio(struct inode *inode, pgoff_t pgoff,
> > +				      struct folio **folio)
> > +{
> > +	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
> > +}
> > +
> > +static const struct vm_uffd_ops shmem_uffd_ops = {
> > +	.minor_get_folio = shmem_uffd_minor_get_folio,
> > +};
> > +
> >  #endif /* CONFIG_USERFAULTFD */
> >  
> >  #ifdef CONFIG_TMPFS
> > @@ -5292,6 +5303,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
> >  	.set_policy     = shmem_set_policy,
> >  	.get_policy     = shmem_get_policy,
> >  #endif
> > +#ifdef CONFIG_USERFAULTFD
> > +	.uffd_ops	= &shmem_uffd_ops,
> > +#endif
> >  };
> >  
> >  static const struct vm_operations_struct shmem_anon_vm_ops = {
> > @@ -5301,6 +5315,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
> >  	.set_policy     = shmem_set_policy,
> >  	.get_policy     = shmem_get_policy,
> >  #endif
> > +#ifdef CONFIG_USERFAULTFD
> > +	.uffd_ops	= &shmem_uffd_ops,
> > +#endif
> >  };
> >  
> >  int shmem_init_fs_context(struct fs_context *fc)
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index af61b95c89e4..6b30a8f39f4d 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -20,6 +20,20 @@
> >  #include "internal.h"
> >  #include "swap.h"
> >  
> > +static const struct vm_uffd_ops anon_uffd_ops = {
> > +};
> > +
> > +static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
> > +{
> > +	if (vma->vm_ops && vma->vm_ops->uffd_ops)
> > +		return vma->vm_ops->uffd_ops;
> > +
> > +	if (vma_is_anonymous(vma))
> > +		return &anon_uffd_ops;
> > +
> > +	return NULL;
> > +}
> > +
> >  static __always_inline
> >  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
> >  {
> > @@ -382,13 +396,14 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
> >  				     unsigned long dst_addr,
> >  				     uffd_flags_t flags)
> >  {
> > +	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
> >  	struct inode *inode = file_inode(dst_vma->vm_file);
> >  	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
> >  	struct folio *folio;
> >  	struct page *page;
> >  	int ret;
> >  
> > -	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> > +	ret = uffd_ops->minor_get_folio(inode, pgoff, &folio);
> >  	/* Our caller expects us to return -EFAULT if we failed to find folio */
> >  	if (ret == -ENOENT)
> >  		ret = -EFAULT;
> > @@ -707,6 +722,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  	unsigned long src_addr, dst_addr;
> >  	long copied;
> >  	struct folio *folio;
> > +	const struct vm_uffd_ops *uffd_ops;
> >  
> >  	/*
> >  	 * Sanitize the command parameters:
> > @@ -766,10 +782,11 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> >  		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
> >  					     src_start, len, flags);
> >  
> > -	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> > +	uffd_ops = vma_get_uffd_ops(dst_vma);
> > +	if (!uffd_ops)
> >  		goto out_unlock;
> > -	if (!vma_is_shmem(dst_vma) &&
> > -	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
> > +	    !uffd_ops->minor_get_folio)
> >  		goto out_unlock;
> >  
> >  	while (src_addr < src_start + len) {
> >  
> > -- 
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

