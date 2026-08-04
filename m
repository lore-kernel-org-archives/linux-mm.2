Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 943E8C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CDB6B00F2; Tue,  4 Aug 2026 10:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4DD36B00F4; Tue,  4 Aug 2026 10:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989F86B00F5; Tue,  4 Aug 2026 10:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68B856B00F2
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:19:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF1D016019C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:19:00 +0000 (UTC)
X-FDA: 85063793640.08.B2724F6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 32BC940008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:18:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ffw0nfic;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785853139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V00/kLuYZWrl1WP2P6v5nHLGcWBvcUhXxvPn6YnAyNs=;
	b=aytt7bg0bw2kS5euG2GVkyiZ+NTTZI33KpmONjOFKR1Y7WwXyp5SwhV6IIPOvIwQDT/SIE
	tkZ/A/250VfM0whPkQbnF8nSlqH2pwRTKdGqKwlYvjVZaVDTi9QSMqh0PIjzHzIhyLrGHk
	pJT6GSEQMsrSYW53gc3GyYOCUD9yyoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ffw0nfic;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785853139;
	b=YbyiqkfBv+eSpuN6WxpA/5LFSgBQd2l8VM2HlWQyOxxIRG4DG3uDApvkKMWrjH0vZeTEno
	VBpNVVyL/umZRmzzKFpCrsJlMUvz6eEM+7hH6PzZrEdJ2rhERvBP8uaB5UhsYF2/J346J9
	8vuHcu9QUpQGcBMROmwKJJeLxd53Wxo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785853137;
	bh=NS2eQcNEARzMx/1ftUH+jzAoYIjMXvUFkD5/edzdfLU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ffw0nficG6fw00Dgg4YqWHttUR4eBd2G57pmAUJnE0hvrB18ktH1Hha5Y1ooh3HPc
	 0d/ClqKPyRZkxs1klR968U+gQSbapFAg6hnX+IMk3KPYoXxrFAfvx46bA0/sbU+cdu
	 xbWdxS74bwJOse7HDGJgSQeUcKUFE9aaplqh82Bk1THYh0WKcQSj741EyfCPk4e4Ml
	 amD1v0ouOPV7oB50BZIQO2FfDbINQJuxHb0n68eJITW8VpL97wtLbc7hIew506QK3t
	 kcRhScvhmugo3Ff8i9NNQXyRKllOVMaiJO8F8AxfwtIJS6mb9M6MrwK9ftP3yd/Fz1
	 N5rvtBf44oRFQ==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8D80217E06DB;
	Tue, 04 Aug 2026 16:18:56 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:18:50 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Alex Williamson
 <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, Christian Koenig
 <christian.koenig@amd.com>, David Hildenbrand <david@kernel.org>,
 dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, Huang Rui
 <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, Michal
 Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez
 <slp@redhat.com>, Sean Christopherson <seanjc@google.com>, Thomas
 Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Message-ID: <20260804161850.58c55c6e@fedora-21.home>
In-Reply-To: <20260804161549.4cd9a66f@fedora-21.home>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
	<20260804120529.1730187-3-pbonzini@redhat.com>
	<20260804161549.4cd9a66f@fedora-21.home>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u5aeayqsxoq761cywqaahey9qt53gead
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 32BC940008
X-Rspam-User: 
X-HE-Tag: 1785853139-139990
X-HE-Meta: U2FsdGVkX187adyXX8n/u5aA7V/sOWmB1sOBY+sgatsT6ys6TCb6mfgV3iLruewUQRFtfCFlZWiA1Tc4glqgyv2bqahsu9yViZeI1ufnNsAeWKQgjXBQXKk6prHrDeR3dFT8lzKaflxOIwQji6hqKOHzWYdmssj5t08ZPYg9v3r++ZiafdOLnKX67Qia3XwJtCZgVb+xJgzfI5vywwEo81jcNht1JpeURgNoUyUpuXC/v/zwKjFDsUGYxN1viuJZklmpCzJbstUeY8J3eR5ItDe5OApf1pLQcThpI9TZb2Ibs5xs5Dgc/WhTBrR0HI9orpWXkYVJDnkQUHp/FkJPNiXT+pXMXxF+aOuZ1XzRexVIsMaKpquA2ICd1olwA1m28vG9Pwq9yg/toa4DgclDMTlw6zHYqPV2N0uFElU+kMIuxs3IsMQGHuzkeYUI1mSjZ+wyS6G/j0AuD7xcJEtrYy3E1Z+Z5rgZHF8YSiDrQJ5CC43fGApfV9zkczCyzD1ulJuUMWN0r/R86eHlJJusEkInPmjQAs1G2P33W6lz+1/7wJYOzz5tShzlOy5/slNESRbIuIpxaG6LfvWci0oMaOlVhavzERMdUE2DWY/tOUHuS/UW+E4GT6eBe0XV1p9tqVsf2jLCZ0mSTF+jXIuW5MfU8MCoVZ8i1ohPYGvKAFQa++5DkE98YeV9WTNKL/DGGfMmFN0nwYdCJbnwLKIB3ReprAjQ/tCfDIH8yi+5GxHVv6hj7dbfcnAGe1NP+cVLgmQvwFrVwHvtIj54q9DFNvnCAP8sWx+2HpsO+17M81gZlh7aXo8PT1grW3HN9K6DmAUggqhih7pW31QqokotTjb3RyxcXoHenKF18oZvzXy19/1wnfNmnpVZTCKZkn00az2hO40O/gctR+2/mRF8d7/JIJZHtmSx93Vsc2KMZa8i9Hw50CBF9TYZkVe+AXOVMzqoB6tBcIc88VQb39r
 ciodcaVg
 aY0aBp1ZCzY6EyGuc8zxPL5lvIJOhbQP+OxdvQu+Hy5RQVTOEby2icc6yEvwQcowlnOViakA0kjpJJ//9k6ecP7YXu25T7JYjSohmLBEjSvvVg22ikxRxFf93XqOCAUMhjlhEVQDKfeMIdf+c8qGxajSY45TxkeOmL+a6jRDkTSbW0OpbIf1xs7cO8Sc3Ep62Acyr3Q0BJI+805pX45Z0pUUqZNDKkxFa9PlUVyY75Q54qgCBL40+qPJhaaU1CSl9If0sac6yihJZWFxF/qOZh8pevVLEGB6Jgs5mjlQX0M0OF+dTEMFQn0sX2Kl0mTdhANxi4aXei9ZDWmO6UqXxolvOW35jb+7BQbT5FT6gUURkwYTpL/lPtBY9HMvafzn1M7XdkcAbeYQbU0nFKsX4Q/Fj8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 16:15:49 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Tue,  4 Aug 2026 14:05:24 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > This ensures that KVM or VFIO correctly see a writable PTE when
> > they request one.  Otherwise, a guest write to an unpopulated
> > PTE from a mapping backed by a DRM GEM BO triggers a VM exit
> > with EFAULT.
> > 
> > The code actually is simpler, because the same logic already
> > applied to the hugepage mapping case using vmf_insert_pfn_pmd().
> > 
> > Reported-by: Sergio Lopez <slp@redhat.com>
> > Link: https://lore.kernel.org/kvm/20260729072044.25796-1-slp@redhat.com/
> > Tested-by: Sergio Lopez <slp@redhat.com>
> > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> > Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++++++++++------------
> >  1 file changed, 20 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > index c989459eb215..c81be3e97317 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -589,11 +589,25 @@ static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
> >  	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> >  }
> >  
> > +/*
> > + * Because the vm_ops have a .pfn_mkwrite() callback, vma_set_page_prot()
> > + * has cleared the write bit from vma->vm_page_prot.  vmf_insert_pfn()
> > + * would install a read-only entry even for a write fault, relying on a
> > + * second fault to reach .pfn_mkwrite() and upgrade it, but that second
> > + * fault never happens for fixup_user_fault() callers that directly
> > + * walk the page tables with follow_pfnmap_start().  To ensure that
> > + * they don't see the read-only entry, pass FAULT_FLAG_WRITE info down
> > + * to install a writable entry right away.  Because .pfn_mkwrite() is
> > + * not invoked, record the write afterwards.
> > + */
> >  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
> >  				 unsigned long pfn)
> >  {
> > +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> > +	vm_fault_t ret = VM_FAULT_FALLBACK;
> > +
> >  	if (!order) {
> > -		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> > +		ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address, pfn, write);
> >  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> >  	} else if (order == PMD_ORDER) {
> >  		unsigned long paddr = pfn << PAGE_SHIFT;
> > @@ -601,27 +615,15 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
> >  
> >  		if (aligned &&
> >  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> > -			vm_fault_t ret;
> > -
> >  			pfn &= PMD_MASK >> PAGE_SHIFT;
> > -
> > -			/* Unlike PTEs which are automatically upgraded to
> > -			 * writeable entries, the PMD upgrades go through
> > -			 * .huge_fault(). Make sure we pass the "write" info
> > -			 * along in that case.
> > -			 * This also means we have to record the write fault
> > -			 * here, instead of in .pfn_mkwrite().
> > -			 */
> > -			ret = vmf_insert_pfn_pmd(vmf, pfn,
> > -						 vmf->flags & FAULT_FLAG_WRITE);
> > -			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> > -				drm_gem_shmem_record_mkwrite(vmf);
> > -
> > -			return ret;
> > +			ret = vmf_insert_pfn_pmd(vmf, pfn, write);
> >  		}
> >  #endif
> >  	}
> > -	return VM_FAULT_FALLBACK;
> > +
> > +	if (ret == VM_FAULT_NOPAGE && write)
> > +		drm_gem_shmem_record_mkwrite(vmf);  
> 
> Actually, if we're making the drm_gem_shmem_record_mkwrite() call
> unconditional (for PTE and PMD updates) in that path, can't we drop the
> drm_gem_shmem_pfn_mkwrite() call living in drm_gem_shmem_pfn_mkwrite()?
> 
> Also, I'm not even sure we can end up with write=true for PTE updates,
> because our pfn_mkwrite implementation returns zero, not VM_FAULT_ERROR
> or VM_FAULT_NOPAGE. This means the default RO -> RW PTE upgrade
> implemented in finish_mkwrite_fault() [1] will take place. If we really
> want out try_insert_pfn() to be called for those RO -> RW updgrades, we
> need to call try_insert_pfn() from drm_gem_shmem_pfn_mkwrite().

Nevermind, it's all explained in the comment you've added. Sorry for
the noise. I keep wondering if we shouldn't call try_insert_pfn() from
pfn_mkwrite() though, like is done in other places.

