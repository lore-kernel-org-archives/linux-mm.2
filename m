Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B0AD2F03E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF7B6B0088; Tue, 27 Jan 2026 09:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6E26B0093; Tue, 27 Jan 2026 09:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF856B0099; Tue, 27 Jan 2026 09:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDD4F6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:45:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B7A41A01FB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:45:22 +0000 (UTC)
X-FDA: 84378016884.17.2586E35
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 923B2A000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:45:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PBsVC6sE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769525121; a=rsa-sha256;
	cv=none;
	b=3ijtI4O5fAwmwvHsJW+sqkADnG3feKjAb6g0/Z1VICJM4CmI9iHcTv6VMhmEkQisiBEKYX
	LYfOJJeIP9V69eJI637zv64J4emzSy2daoyNoISJvhIxdICLuRFDQRDfKrVlEbsilEmkw2
	s2nrTOetgFLWCH78ubcWjlNw5wk/mBk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PBsVC6sE;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769525121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rurjKDUdu2YDkI9498DH8WLHdV6sVoqC0yZuv3Vzrq4=;
	b=Z9pZAyCO8GCCe/cm0SSIdtv27feQ+wrEwOMjsITK+2VzidRP8Gv5Ih7ruiq/jItR8958bp
	UhLBQxWGZpVONozLlmC+kw1wbh+wN5BJoW0kf5XcL6EfrJ/HfLA3l45seDBAae9UyehLLR
	n4QgUvEA3GWKRtlxDmXYWlMxlFMfD6E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1769525117;
	bh=t4KCn5AVvj1rVtR81P9mAeQidZIfz5aUPhgtLJ6zXvs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PBsVC6sEXH+SbnMLH2IJ5M7Wj/ZkkJugxUmVjUgiIFeib4qz4FNcyPA92uoQ3ajSZ
	 3Euln0XLHJYw7BibSC/+Ar+jArLoJW4pNQBNaXkHOjfE3xbOI10lW+Qm4LMPesljc3
	 k/DqO4TgiXTL2/+5CvGdMCsk6KH7CVvRMSqVuzozY9LP85K8b+ogc2izUSk3qvuH5K
	 xy1Tc7gvhawgH3rV63/lNiPTNrfp3yOlNMl0kksWhba7fIpux8fx+3oS9Mx8Yfg8iT
	 HUyi5F01xUzfl5wilK1Ite8lN7VI0OXDNDz5/6WsEcYYiIbakKSBOQoP8I7+CgS58o
	 ie4Lm3IEF+uOw==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 15E1617E0182;
	Tue, 27 Jan 2026 15:45:17 +0100 (CET)
Date: Tue, 27 Jan 2026 15:45:11 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, frank.binns@imgtec.com, matt.coster@imgtec.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] drm/gem-shmem: Map pages in mmap fault handler
Message-ID: <20260127154511.6e2b9008@fedora>
In-Reply-To: <20260127132938.429288-2-tzimmermann@suse.de>
References: <20260127132938.429288-1-tzimmermann@suse.de>
	<20260127132938.429288-2-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 923B2A000C
X-Stat-Signature: g6qyeg1pb4jdexmf9iymtj5edj8iadek
X-HE-Tag: 1769525120-509747
X-HE-Meta: U2FsdGVkX1+KicIGNC/zrJ8496xohVnNdQgrO9OQ7D4RpV7As+ls48qWmhDUrFa3hrFKXgGRRbWgmzMWBr+lUXPPR8FxyOO6ZjIpSs8dhAi3T/1R9RVjrcgGj1Km0U+E7kIWtLK+aTm2pTWg71+nNF+j3WZtBW6qW77EzVaAFcfvxmPOHXuRVPn3sJKQQy0gaW/zZP1c54qeBKZ2zDWU0w7PaDCbFTB8LTwESpDIVXvO4XoVTk+1TTZaKnvv7aqrkDsSHcUWwuVxcXYhfyD/Jw+KIlMp5JCOXjsTyFA98DDUufZ9ve9eoNslqaPUqRYuNwRyd206iAL7yQbV7MnUJ7pVlElt4mi6RUPF3Gb5Ic3EfhDRSjiOHrHP04PuOkCE348xIazbWO/s9AyIK6QJQSgOFEUTCZa5iD9Zvq+Oa3AEG2zdn1DfN/B1F7K9MlVTz4V64WYfJt5nbeqzP4XyF20gK6bceYPoqajL9HGpHU9FSPPtec8NLjjIGgu6u4NaC+L6vyspjUZaDwH8QDituhPhX0yDMW0XrTKhXg2EAsHagfekTW/J0fqYmT+3Q1UH/6STzu7QXjRNv7mhpxjoxKz5C9P6yYVxrslw1ePJpDHo+Wbn5vw64iW/3eVpDo91TWt/adzmuf/Pj7iabxkda5uNUVYi00opCBBnGYuGg4idH0q/jyFQA6koIP91ak0KAao3L/sus4LS5f99vAfPFCbNAZVfQgi5AVW1TjyshY+xsmghCA/xHPdmm3EP9ElWn4EYLwIVupxqwQ/HI8IW857AjZB82QbpEl7SpqrbI6wn1QBY+l4CRmK9gldx1XvxPc74gC4KdaL8wKH526BBM1KVmqJWU19+UQ5Q/eYZ7L/h96lX3wQ0wgXI3C4/6xze6UYt0l0aUpN1Ft5pLJALduAwmWObTJeahrmiRC7oX4Rut3ADT8Ao5j32/7g/GIdYCoV2DQ6CidxwlCnodH2
 ZCUsZwFN
 Z9KQTQyYiI7y25SSDg+okpZgYf2eos8DIQfsrUOIckSKgRwElbMBHOMiqYkPmlOhwCZVzfpmm+MCGPS9/WtkuDp/fumNaPMwxCkABn8BALASyakofUja/2p3zpBRbs6pQPj6mnjCKLt4PxDT+VIzpN5vwzbQUDD1TsVg1Ag3HrRDlc+6eaynKVp2Uokp6rZX77CXGqpV+MQrRWjXkxg+E/CsmEIlv6ntOzZSHCrbTS2wIRsuOA3BJbUevtPPDf57MCpxasYAKJl1sZm4KICwGCZz8WPmcn3VV8dGoZ8CjLyMBG25XJyPcYD9D+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Thomas,

On Tue, 27 Jan 2026 14:16:36 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Gem-shmem operates on pages instead of I/O memory ranges, so use them
> for mmap. This will allow for tracking page dirty/accessed flags. If
> hugepage support is available, insert the page's folio if possible.
> Otherwise fall back to mapping individual pages.
> 
> As the PFN is no longer required for hugepage mappings, simplify the
> related code and make it depend on CONFIG_TRANSPARENT_HUGEPAGE. Prepare
> for tracking folio status.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 58 ++++++++++++++++----------
>  1 file changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 3871a6d92f77..b6ddabbfcc52 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -553,17 +553,18 @@ EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
>  				      struct page *page)
>  {
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	unsigned long pfn = page_to_pfn(page);
> -	unsigned long paddr = pfn << PAGE_SHIFT;
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	phys_addr_t paddr = page_to_phys(page);
>  	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -	if (aligned &&
> -	    pmd_none(*vmf->pmd) &&
> -	    folio_test_pmd_mappable(page_folio(page))) {
> -		pfn &= PMD_MASK >> PAGE_SHIFT;
> -		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
> -			return true;
> +	if (aligned && pmd_none(*vmf->pmd)) {
> +		struct folio *folio = page_folio(page);
> +
> +		if (folio_test_pmd_mappable(folio)) {
> +			/* Read-only mapping; split upon write fault */
> +			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
> +				return true;
> +		}
>  	}
>  #endif
>  
> @@ -576,13 +577,10 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	struct drm_gem_object *obj = vma->vm_private_data;
>  	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>  	loff_t num_pages = obj->size >> PAGE_SHIFT;
> -	vm_fault_t ret;
>  	struct page **pages = shmem->pages;
> -	pgoff_t page_offset;
> -	unsigned long pfn;
> -
> -	/* Offset to faulty address in the VMA. */
> -	page_offset = vmf->pgoff - vma->vm_pgoff;
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +	struct page *page = pages[page_offset];
> +	vm_fault_t ret;
>  
>  	dma_resv_lock(shmem->base.resv, NULL);
>  
> @@ -590,21 +588,35 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
>  	    shmem->madv < 0) {
>  		ret = VM_FAULT_SIGBUS;
> -		goto out;
> +		goto err_dma_resv_unlock;
>  	}
>  
> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
> -		ret = VM_FAULT_NOPAGE;
> -		goto out;
> +	page = pages[page_offset];
> +	if (!page) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto err_dma_resv_unlock;
>  	}
>  
> -	pfn = page_to_pfn(pages[page_offset]);
> -	ret = vmf_insert_pfn(vma, vmf->address, pfn);
> +	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
> +		ret = VM_FAULT_NOPAGE;
> +	} else {
> +		struct folio *folio = page_folio(page);
> +
> +		get_page(page);
> +
> +		folio_lock(folio);
> +
> +		vmf->page = page;
> +		ret = VM_FAULT_LOCKED;
> +	}
>  
> - out:
>  	dma_resv_unlock(shmem->base.resv);
>  
>  	return ret;
> +
> +err_dma_resv_unlock:
> +	dma_resv_unlock(shmem->base.resv);
> +	return ret;

Why do we need an error path that's exactly the same as the success
path?

>  }
>  
>  static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
> @@ -691,7 +703,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>  	if (ret)
>  		return ret;
>  
> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
>  	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
>  	if (shmem->map_wc)
>  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);

The rest looks reasonable, if everyone is happy with the less
restrictive aspect that !PFNMAP implies, as mentioned by Matthew.

