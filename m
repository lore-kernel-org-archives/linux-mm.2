Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0EFEB5969
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 06:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59796B0005; Wed, 11 Feb 2026 01:04:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E078F6B0089; Wed, 11 Feb 2026 01:04:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09D56B008A; Wed, 11 Feb 2026 01:04:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDEC26B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:04:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D18C139F16
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:04:23 +0000 (UTC)
X-FDA: 84431136006.19.E9C41F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACC5520005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:04:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xu5Mobm0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770789861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2QJeawPBO58Ez7fEeRAJa3KHsKkABAUpuXTFFFJztI=;
	b=denuLLQsHa9GLrm42xl05uejmcHzj6M7VI1VJzvSvquH5TDo7wu45O72coJU5ev9MPmw9i
	dEkm3hGig7SNLLYbfX2DhWpKlkMYfWkjMe/CBTTDhuvoDsoIH0mjlAZhYkG9TCNBMf3ire
	e2/rO6uRtutpqnojsCuC2g3M2nnr9hY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xu5Mobm0;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770789861; a=rsa-sha256;
	cv=none;
	b=I2eXobHFapqEVmIByaLQGEJvhsiYvGTPDAt7rgtdnbhl2Vr9CKgKx4uPTSnzatHWbUohi8
	pSIxfYAW8YH/S1pAYIVOEDz3wOi89Wu64sZDjuTpMGr4fiYfJ8R9CYk3ztgmotd2ySioGX
	1PEk/D2WIWyw4ztOHW7L4/MVUcVTWFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B864F41744;
	Wed, 11 Feb 2026 06:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB967C4CEF7;
	Wed, 11 Feb 2026 06:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770789860;
	bh=1ba4HtqH6wJILWm4/0xJUBvvlpODk4MGkINVKN5zbxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xu5Mobm0F8wyhieAmIGzh63x8lptqVNcvo43aLWfKj6Tzv+Zl/kKchoY9ZdsHpeY9
	 7VY7AX4De2TIfQU33FMKPr6fbkei4k9WsONs2oo7VhZtr3CQp7M+FrWIMR0CcEV2Bw
	 idpILaIQ8PtxB+tqtiZhDkYCY0OamXU/ZQC6DQvOWE0CgBDJ4sBAW/xcziwr/oevAp
	 ATuo35V/KFJp1kLKUH/ym/DEQd7QymS16+vW/OsOhdX9h0EfVKeWyVrw07I45sDb7d
	 0FXA6azSR3Rqcixdu+T53iaoPlH+4auPPf+s5B2tud/yLWQPikgXkLOxXx/3AwixPf
	 Fpqc4cdK//yzQ==
Date: Wed, 11 Feb 2026 08:04:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Message-ID: <aYwb2XgRiFayzBXS@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <aYJg5lT9MG0BQFkG@x1.local>
 <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0032ac8b-06ba-4f4b-ad66-f0195eea1c15@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACC5520005
X-Stat-Signature: ssrrimm641b339x35m6tco5u7xt79s74
X-Rspam-User: 
X-HE-Tag: 1770789861-85182
X-HE-Meta: U2FsdGVkX1+oBQZ7x4oS0T1DGxJj3rUedN4Hiv0npCQsN9Q0cSuTqwdXouM/u5hsgvNTZNurBCWZfw0yI3Aq+T2pcFehTUUF26bmNgaqsuKx84BrTpiy2RFVV+IqrZTHyOgP+2Xitk0ZDZYEBK2SpGVsLHakiFg67tTQlinWQBRkXyKL326fp3bpmJifXm0c8Aqb7CCSy6MzR1w3kCGB9hRiD6AgACZko0VWGL50gAbV65wdBrpOHdKhuwRY03LHv7+S3nPkq9Onlthmo00Sar8QLMO4dXDd/o13vVFkkMGOL/DS3Yf6+01OYbaGT81sDHv7AH1ucQu+ryrIfs44/nxgd86WtaujYS6Pd6jK7ePuAbAsXsDYxGeLn2sGmytkHI1YBMkKqbRwUbZtmZYmT8gcy8j2d0gPJ+jtTJ3kLHxulf/IY5s7a6j1hyrChVoL4H8f6U44k0RtQJg+qIAyUMpGqLKCq7oo+2He7vFPX3fCg7wTb+wpplekM5uZqG3vE/GuyhOkIIC9wtQkutKAtvQjSKaXv4lzzMdA+ot+ZLZRrYQTR761Rikqc+SwCYYmWSLJostVB8lHAxuTyoWNvr60ATD2QBC7xaJAfzz8UgSFdl57YvohTiUS3f6N1VnKdGcxt5QksgVB+6QMX6Hyqnc+KVctZYmQWcgwqC6ubACexUcOYYLpGZNBCn8jhy+u8W2NCT8pTz4aOWwguGO9iKtt0DFdncBfS4nxs3zVXBwtTsQyOu5ve4DlE3s2blJBRqn9GXLSID6Cwdi6dRQd3lJu8FgwzXstiOCFDxc4/WYkoDVxX6Gt7nfJQabyecmKd4rJPvoidzaCaBPqhIQ35rmfCS+bg1+zM5RlVikAEAoe8rk6pzgEmYMxYbxF+qf3w0+xoE6f/nO9XneAJ1MEdLTf9KY1FYrIC57bO/3mRg20DEp5WO2srVtoqXOFik/InoWA3KK7sFvQ5Pk9cHj
 yk2vXftK
 hbKvHorQ+/2fn1ttugQAgpjYsD3lFcDnWi9/hlvjzgxWmKG4kJooQmbmm3JV6pWDhqlRrIS+Eog/8kgeJ2dvmz3QoS8C1oXacsFN5MrC7+2+JWTvQmZYL2esD47u1VwYmOe6x07QrX/hTxR62nCafr+UazUG/gDJ000JnZo98mI2FmtGS82m8JfPVbF7vKCU9QKw7Z6jGW1M1v+7RjG/4aAva9rn7SLJ/7NM4TL9SztGGgwluRmTCNBpc1ct8zMjvov1rxIeA5eyp+L5RB+Pk/P3hhH7Dq6UZ6ZvzGDn16XXkRFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 04:35:47PM +0100, David Hildenbrand (Arm) wrote:
> On 2/3/26 21:56, Peter Xu wrote:
>
> > +static vm_fault_t fault_process_userfaultfd(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +	/*
> > +	 * NOTE: we could double check this hook present when
> > +	 * UFFDIO_REGISTER on MISSING or MINOR for a file driver.
> > +	 */
> > +	struct folio *folio =
> > +	    vma->vm_ops->uffd_ops->get_folio_noalloc(inode, vmf->pgoff);
> > +
> > +	if (!IS_ERR_OR_NULL(folio)) {
> > +		/*
> > +		 * TODO: provide a flag for get_folio_noalloc() to avoid
> > +		 * locking (or even the extra reference?)
> > +		 */
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +		if (userfaultfd_minor(vma))
> > +			return handle_userfault(vmf, VM_UFFD_MINOR);
> > +	} else {
> > +		return handle_userfault(vmf, VM_UFFD_MISSING);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >   /*
> >    * The mmap_lock must have been held on entry, and may have been
> >    * released depending on flags and vma->vm_ops->fault() return value.
> > @@ -5370,16 +5397,20 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
> >   			return VM_FAULT_OOM;
> >   	}
> > +	/*
> > +	 * If this is an userfaultfd trap, process it in advance before
> > +	 * triggering the genuine fault handler.
> > +	 */
> > +	if (userfaultfd_missing(vma) || userfaultfd_minor(vma)) {
> > +		ret = fault_process_userfaultfd(vmf);
> > +		if (ret)
> > +			return ret;
> > +	}

I agree this is neater than handling VM_FAULT_UFFD.
I'd just move the checks for userfaultfd_minor() and userfaultfd_missing()
inside fault_process_userfaultfd().

> > +
> >   	ret = vma->vm_ops->fault(vmf);
> >   	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY |
> > -			    VM_FAULT_DONE_COW | VM_FAULT_UFFD_MINOR |
> > -			    VM_FAULT_UFFD_MISSING))) {
> > -		if (ret & VM_FAULT_UFFD_MINOR)
> > -			return handle_userfault(vmf, VM_UFFD_MINOR);
> > -		if (ret & VM_FAULT_UFFD_MISSING)
> > -			return handle_userfault(vmf, VM_UFFD_MISSING);
> > +			    VM_FAULT_DONE_COW)))
> >   		return ret;
> > -	}
> >   	folio = page_folio(vmf->page);
> >   	if (unlikely(PageHWPoison(vmf->page))) {
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index eafd7986fc2ec..5286f28b3e443 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2484,13 +2484,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >   	fault_mm = vma ? vma->vm_mm : NULL;
> >   	folio = filemap_get_entry(inode->i_mapping, index);
> > -	if (folio && vma && userfaultfd_minor(vma)) {
> > -		if (!xa_is_value(folio))
> > -			folio_put(folio);
> > -		*fault_type = VM_FAULT_UFFD_MINOR;
> > -		return 0;
> > -	}
> > -
> >   	if (xa_is_value(folio)) {
> >   		error = shmem_swapin_folio(inode, index, &folio,
> >   					   sgp, gfp, vma, fault_type);
> > @@ -2535,11 +2528,6 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
> >   	 * Fast cache lookup and swap lookup did not find it: allocate.
> >   	 */
> > -	if (vma && userfaultfd_missing(vma)) {
> > -		*fault_type = VM_FAULT_UFFD_MISSING;
> > -		return 0;
> > -	}
> > -
> >   	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
> >   	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
> >   	if (orders > 0) {
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 14cca057fc0ec..bd0de685f42f8 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -421,26 +421,6 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >   	folio = __filemap_get_folio(inode->i_mapping, vmf->pgoff,
> >   				    FGP_LOCK | FGP_ACCESSED, 0);
> > -	if (userfaultfd_armed(vmf->vma)) {
> > -		/*
> > -		 * If userfaultfd is registered in minor mode and a folio
> > -		 * exists, return VM_FAULT_UFFD_MINOR to trigger the
> > -		 * userfaultfd handler.
> > -		 */
> > -		if (userfaultfd_minor(vmf->vma) && !IS_ERR_OR_NULL(folio)) {
> > -			ret = VM_FAULT_UFFD_MINOR;
> > -			goto out_folio;
> > -		}
> > -
> > -		/*
> > -		 * Check if userfaultfd is registered in missing mode. If so,
> > -		 * check if a folio exists in the page cache. If not, return
> > -		 * VM_FAULT_UFFD_MISSING to trigger the userfaultfd handler.
> > -		 */
> > -		if (userfaultfd_missing(vmf->vma) && IS_ERR_OR_NULL(folio))
> > -			return VM_FAULT_UFFD_MISSING;
> > -	}
> > -
> >   	/* folio not in the pagecache, try to allocate */
> >   	if (IS_ERR(folio))
> >   		folio = __kvm_gmem_folio_alloc(inode, vmf->pgoff);
> 
> That looks better in general. We should likely find a better/more consistent
> name for fault_process_userfaultfd().

__do_userfault()? :)
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

