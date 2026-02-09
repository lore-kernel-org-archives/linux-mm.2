Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D57E81BCE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B096B0005; Mon,  9 Feb 2026 09:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28F86B0088; Mon,  9 Feb 2026 09:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D349F6B0089; Mon,  9 Feb 2026 09:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BEC886B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:23:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DCA855B1C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:23:50 +0000 (UTC)
X-FDA: 84425137020.04.61AEAF6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 671B180006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:23:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OYDI4z+D;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770647028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5KHvYfFXbbAijewTxVtlxVx2P4m59i9hWIHk5CJiow=;
	b=dXCA2CaNpPGLeY6V0qF+R3U6E0PW0jVqYvutUPcqNCALKJHF4NoVF+SLDg+8O4fjurYanT
	xtsWCbniSyDflKU3H+7yZk7i6XlDVfgBwtwEfTbVhBrkwRjV7eQ7bFeQvFPk6anqhq0j1s
	m0pOgifWilKNzZf2SFW0/Elx4e2qHIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OYDI4z+D;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770647028; a=rsa-sha256;
	cv=none;
	b=yntne8p+8aPdWtodK6/XdQi9xwy3vmwOOtl/9yf2cXf0otGIDbdAT7LFfBbDSbnXPYgHVB
	3PfSCC1Y4JcGb9vnMglj8A4y2wzbzzOtFtxZIsxRLg58o1nLsUKM9XnchrQzmiwPHB9GRh
	6Qw7IhRHnzbsmtv+IyYuPGTEg62dLSQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770647025;
	bh=lAZj3fiYD2ZcgmVNgscrFnQUNp8/AmVIT6EQcsXvwHw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OYDI4z+DMY2cli26e14h5OO3uUPfSyZc+1PBhf0+JFw2rszybr3FJ4l2ZW3IOWcEH
	 IPxPkCJqfbfiXm+lvMQ5pRXS21g8tvAcka9izZaP4yxQsEu1Lj83/dAffBMIwhOvd0
	 iEBhE7vgvSv/gX5nWJWO9R08g3yRIoRfLEOclR19VGTeK7JTRsGliU9aVcoO34C7D5
	 tZkmTuGa1DJpfLA6xe+7tLuWRkdDnXGRfAsMIw0N1kOhvxF5K/2f5BdON4AueNNlEQ
	 qXgRGJ/Vg94vrAg3CQdbs248Aq9RvjaX3KfO2Dwryd0sUQa+1lpTyA+vfi8Ao6P3tL
	 MCZjnpDJ+mH5A==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 78E4417E13C5;
	Mon,  9 Feb 2026 15:23:45 +0100 (CET)
Date: Mon, 9 Feb 2026 15:23:40 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260209152340.16f9b30a@fedora>
In-Reply-To: <20260209133241.238813-6-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 671B180006
X-Stat-Signature: 5rynydnqemx1w7xntmm6chia49ddxey3
X-Rspam-User: 
X-HE-Tag: 1770647028-544400
X-HE-Meta: U2FsdGVkX190TQz1gytFNswwmLj2xswVYWmxYk2Xascy6zVBBB8IVNXO9wQF/DXj85DFEehcPTSmv46NQ0azbFtjBMO6MBHoGS/7LVWW0w235HK2Pe9gIRvVyRITNaVU4H0aArnqI68LvOarRiOiaHV1CkE22PVhEzM+Jo2JLH4iiDVgssZnl6Urt0yIBZuCHDcGL3iTOj/o5qVUPQRUlrmea6mjTL9iqfX7l4QNHTTl7YKwqFHb4gvvaXTKw3BTs/XiSzAJfKySFvbYQZXvXjWsvvdgyUS6A7Vw3CP59YwDxEXTuzg+d0kYm6NCQ1rdHypWMvspgAZ2qb/fRgbT5Zok7JdE1p8Kk69ue/YBiAe1QgUeAnXDqhfWkCajjInQXY79YcgRGxqTVpr0H8zNX6JvwfLREsdwWpY1c4OpZpu620UY+F7BkBpBbOo06V+9mLNUyFBgaGr3hhocHqRcPg0iYfIXAqmLu1dvYafkKdFHojMiGCLHX9WGtZLizOU41U8UF0vn/XuSao+ShAeNRVNOP6ssA4RlDPeV6NUZ8fpRQ/kuAVTbFFmlIEiwRRedLq/Fn7m3oU2CuJbqETQbjhXxBebM26GmFKePe/7eIfGaWuFq+EIxr6PCWHwqkg98zdI3rj78dE3wpv+T6eHISMFIsXZXIo7LnaQ5+aWFBHFAnY0UN4OkSPygX5DLSQS9G7vEHGucM6rfbjB5IL+fcV89GImRYsHKyCYn4CxC+CF4Y9grPI9pYDvOybQ4NvQ1Zn1Oxx5GtDw5FvD8Dd8WC3OUjtR6H8Sb1HPCTRyc+VR4JlX+sdaIlG1ljcL7i1rGsF0Br9uIJiMDF6SUofgbs6RM5MN/3RzXg11xV9mh64XgWf4MZgZNIdGAuUVwdI6aA8dUNmACI3+UZkq5f0lrPxMt02Cd84+/1D9kVGyCRCMrcSFAXhFHSncB6FylG+3V1SQJeFQG/ppFpj03E86
 auuacGlJ
 ZbojbqFKkzRy/ek7EbocoQ+F66xKP/JqONcmEA7Z9Ny8aWTbIfz2H/+00p0WfchnAd+2O/DUhWYTd+tOLIzNgUXl15VDE1w24qfM4EWRokcV71nlcR88kHov6vCKV0Wshfpuwg62/sfyjUeRrvkN4XPqBlz3BtvZ4bAEMGty+MK1yUdoz5m9HYK5AqETH4c8z/wtaHdvUcEoql4xw+JoIOaYH/+sNxyS30yMH0MfdPoVTZ8rfqQGVae79UT81kdUm/cQCGm074IW/T2ptsKOIGVuLbwHWOJRIDAv/8ACvn4XV8hP5FieAl+gsZOS0kkwMMYo/Zn3BjhacKI5iHCxpR+tfUtmZ/bKa+RuJAzklGjzpA/k9yrP4gVTQYgji4UaYOhg0mCqssAt+ztVK2EzGM3ZjTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 14:27:14 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Invoke folio_mark_accessed() in mmap page faults to add the folio to
> the memory manager's LRU list. Userspace invokes mmap to get the memory
> for software rendering. Compositors do the same when creating the final
> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
> out graphics buffers when under memory pressure.
> 
> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> for writeback should the underlying file be paged out from system memory.
> This rarely happens in practice, yet it would corrupt the buffer content.
> 
> This has little effect on a system's hardware-accelerated rendering, which
> only mmaps for an initial setup of textures, meshes, shaders, etc.
> 
> v3:
> - rewrite for VM_PFNMAP
> v2:
> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c3a054899ba3..0c86ad40a049 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	if (ret != VM_FAULT_NOPAGE)
>  		ret = vmf_insert_pfn(vma, vmf->address, pfn);
>  
> +	if (likely(!(ret & VM_FAULT_ERROR)))

Can't we just go

	if (ret == VM_FAULT_NOPAGE)

here?

> +		folio_mark_accessed(folio);
> +
>  out:
>  	dma_resv_unlock(obj->resv);
>  
> @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>  	drm_gem_vm_close(vma);
>  }
>  
> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +	struct page *page = shmem->pages[page_offset];

Should we have a

	if (WARN_ON(!shmem->pages ||
		    page_offset <= (obj->size >> PAGE_SHIFT)))
		return VM_FAULT_SIGBUS;


?

> +	struct folio *folio = page_folio(page);
> +
> +	file_update_time(vma->vm_file);
> +
> +	folio_mark_dirty(folio);
> +
> +	return 0;
> +}
> +
>  const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>  	.fault = drm_gem_shmem_fault,
>  	.open = drm_gem_shmem_vm_open,
>  	.close = drm_gem_shmem_vm_close,
> +	.pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>  };
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>  


