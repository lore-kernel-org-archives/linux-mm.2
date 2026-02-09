Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCAD1E81BD1
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294216B0005; Mon,  9 Feb 2026 09:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2415F6B0088; Mon,  9 Feb 2026 09:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123496B0089; Mon,  9 Feb 2026 09:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02B766B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:26:06 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4F411A0108
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:26:06 +0000 (UTC)
X-FDA: 84425142732.26.EE959BD
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA8B740015
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:26:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Kjz94qS9;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HETrIHxpyTzzI0DlPnJbRCZnlkG4bOrav9lKznWGm8Y=;
	b=N37cRTyvw80m1F3Sbfxhy5cLkRQdA6Pi/kRCnnid4rMrn7E1NWO2cL2oahll4cA3c+uk5x
	ikfG4a1ZKPntSH9nqHWaGTip9Wtk7ZLATEoj+DOkmwRvC8G3dIfE2g9XFoc8YKuNyhHm5V
	cBUt+Ud0yyiAtFQTwPAMOdAPy+ddcCw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Kjz94qS9;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647165; a=rsa-sha256;
	cv=none;
	b=MJ79PaNyCDc2yanUMlZeqhwkCotD2zYYIt45oeJcdJqk1RDrZpYscXN9hNShZLDTgiiFEu
	6tfBn7vMmZP78+jgRS7OiKZbS6pRVH4wXFjhMwKjzgPbA4HTdpbe7EJk9UftZw5exJodwi
	gV2nKCOrbVBtxEldulXizgXjvQCE6GY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770647162;
	bh=Ai1JsGYjgTlQrc8eHRH5768OPEiwDY59ubtKITTwQmM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Kjz94qS9b1XfBmF8cr96hN0kMuxaGtIwA3eZJoiUF+nrcz6ssLOHR4NwypNNeGLYE
	 x5ypN6Sn7uiu3tuB959nEx5vPsxPhMjWzr5bBENEh2S/fgX3Rd4n3EXosnVtrB08UH
	 RMCT88SgNOmIWAUHVLW+H44kFZwgp0FRNrbitmOUbYamcnwe+fVG2b0JJiO6XmXakG
	 K0wLFtZI1bngLjI7IZHWICbog1Id7gG9tUrGGb7Wn6vRuUZVKFeN6mcd+0xz5E/Hbr
	 YnYspRIsly78xk4/LB3yNvrmhTuwrVN2DBR0LEwW2QzTPyr6p8MOKDCdrzIRufgBT6
	 Gop3C1/1K/W4g==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 824D017E140E;
	Mon,  9 Feb 2026 15:26:01 +0100 (CET)
Date: Mon, 9 Feb 2026 15:25:56 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 4/6] drm/gem-shmem: Refactor
 drm_gem_shmem_try_map_pmd()
Message-ID: <20260209152556.636825c6@fedora>
In-Reply-To: <20260209133241.238813-5-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-5-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA8B740015
X-Rspamd-Server: rspam07
X-Stat-Signature: f3ihe3trnit1yfq9y6o1jc87kckdmkuc
X-HE-Tag: 1770647164-732297
X-HE-Meta: U2FsdGVkX18hD+kLJ1sG7fl104/4iNOtoxDm3RkhC4Eu4dxrKtvIaeeNIP1EREZUQ3bDhtCbPCO2s9Oqz8RPGhnvCHY7b6xBeaeAkNVWteOtbJFZeHX7vvbW8cOcW2IR8jcCpzz1+Dijb+JjblJTQyQDhF25Pi4NQBvZAunhbqODLxMCY1P6Ya7qa5kEunm4/JuJoEYBytaUzN4rQfCmfNKQgdIB2LAnge6VQC705hQEWMb7SdW+d3aFZoA2Zgo7R1xfM931rfiRngEl+DDbqRoBqFJi09th7d1S6/4XX/LZwy/DXwP+IWxGdTz2AJzmnjIX2d0YKY1gP/Koq9tCMlbb/iwBFRwx1pD04qaiw71gjBRIg1KUbQIiYW+pkrJ00flU78KsLaZs9p23r+AFELNg/vcy6xwuRlSKetMSk4yqJPzbmJvMcmFnK2tv+j3ksRUDbbbSNvR5yK57fwN/+YbkWH/3IxeMMhnDIy+9BuH9q4hJzCcRws9y2alUkWRi4AEY1NENJIN5ttTJgoZnRRe3wGLMmJ/maIRLhyCZHMw+EpsRCEKpIJwthzDgQCqN+YSQpXUWNrWNXvzaUVuU1a5PRMhNNDZdTics4pHzEga+1Amd5TthyogTgwPgq6BpKSIO3Lo4P+yomly34DI+w9Rry+zzf7DRCG4D3uFaKLMBkh/y3SB06o7fu7S+LvLZVzaGGlEoar6kBrCCsd6Ezv/DL5yrUFY7wSx1LLQQDsfuzVU7Z5toymiRXzd/+jIQIlndjnVbXA+16XyuyOf/MjOQUisKXOoOvDllawjIj5lA44o7+n3jIyaQqporVxC3AJ9LE1561njU34/KmBGiZBAhvCabRSOoshl2XUOn+u3Y1Z1NZyJ/CkkO3t1M7wfbni6hNO2MlqjYicO6iTu68UvKMdhKAfmBgtJ8Y+Gq/7PYSXw6eQfdQrSLENYQwXcVehmHUnVMennnXjbXhQE
 N/1dK+8Q
 E4q+qGLO9O2blocCS6Zgwyoh4FAVNAxXH2vZclyIcGsoZEbsrZinh1WDR/F9uwY1kgEWlPxnzZfZ5cL41bHOOxLEr/QwvW+E2/UhpDHA7yt4/VatFC4WMuE9hZ/2wC6I/N4yLOtSiJDlCTZhnG0OxCBJlul4CJWnGckCAtQxNFbrtQnZaxQivlHoTPBB6b+m6lZ2Pypxer79nwgoDZXQoC/207wtJN8r28z36Ul0ZIc6wa5vocO1F33r/JqpHW89S4twT5rFcMlNMpnMIquB+SWOoSsQAeqSRYYIWKOabWZhCyzSdI5zPpf2R6WqqIzMu09A4Cx8wwcExKxvVY8o2QnlKuTRcSvNHufxRT7iBkUXlTK/O5+z9v5pv9loyyvoU9xGAinn/H+02B4jyjmTx4E+Fg7u2untlYn8P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 14:27:13 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> The current mmap page-fault handler requires some changes before it
> can track folio access.
> 
> Call to folio_test_pmd_mappable() into the mmap page-fault handler
> before calling drm_gem_shmem_try_map_pmd(). The folio will become
> useful for tracking the access status.
> 
> Also rename drm_gem_shmem_try_map_pmd() to _try_insert_pfn_pmd()
> and only pass the page fault and page-frame number. The new name and
> parameters make it similar to vmf_insert_pfn_pmd().
> 
> No functional changes. If PMD mapping fails or is not supported,
> insert a regular PFN as before.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index ab8e331005f9..c3a054899ba3 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -550,17 +550,14 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  
> -static vm_fault_t drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
> -					    struct page *page)
> +static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn)
>  {
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	unsigned long pfn = page_to_pfn(page);
>  	unsigned long paddr = pfn << PAGE_SHIFT;
> -	bool aligned = (addr & ~PMD_MASK) == (paddr & ~PMD_MASK);
> +	bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -	if (aligned &&
> -	    pmd_none(*vmf->pmd) &&
> -	    folio_test_pmd_mappable(page_folio(page))) {
> +	if (aligned && pmd_none(*vmf->pmd)) {
> +		/* Read-only mapping; split upon write fault */
>  		pfn &= PMD_MASK >> PAGE_SHIFT;
>  		return vmf_insert_pfn_pmd(vmf, pfn, false);
>  	}
> @@ -580,6 +577,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	struct page **pages = shmem->pages;
>  	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
>  	struct page *page;
> +	struct folio *folio;
>  	unsigned long pfn;
>  
>  	dma_resv_lock(obj->resv, NULL);
> @@ -591,15 +589,16 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	page = pages[page_offset];
>  	if (drm_WARN_ON_ONCE(dev, !page))
>  		goto out;
> -
> -	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
> -	if (ret == VM_FAULT_NOPAGE)
> -		goto out;
> +	folio = page_folio(page);
>  
>  	pfn = page_to_pfn(page);
> -	ret = vmf_insert_pfn(vma, vmf->address, pfn);
>  
> - out:
> +	if (folio_test_pmd_mappable(folio))
> +		ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> +	if (ret != VM_FAULT_NOPAGE)
> +		ret = vmf_insert_pfn(vma, vmf->address, pfn);
> +
> +out:
>  	dma_resv_unlock(obj->resv);
>  
>  	return ret;


