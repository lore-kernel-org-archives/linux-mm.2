Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9ABD116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CE06B0022; Mon,  1 Dec 2025 03:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14126B0024; Mon,  1 Dec 2025 03:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51276B0026; Mon,  1 Dec 2025 03:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 945A96B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:16:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 407B51A0842
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:16:59 +0000 (UTC)
X-FDA: 84170196558.02.D329387
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4013A180016
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:16:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MtQNiUA8;
	spf=pass (imf06.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764577017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQ0VZPoDm0JewNcCiq9HLkGqzWBIpasi/lSax/oKY04=;
	b=CwXmhwF2fHQG9vqL79PduGukZJO0/ihYJ/MCV013cCY0fwthph7/81lMHoTc7WJlEre3cy
	odpmeGJ5CoRK3zT9wnaWYKEc/rQc2u1ISdd0Hu2rEjoj7hM/AUux7xpxPz4hYbUMhNMueC
	go16mXbwm2tdG8bL2uHDc6ZevEuolbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764577017; a=rsa-sha256;
	cv=none;
	b=1jC39OjGvv3PiPalaK5KARsw+qW6J7rFYsCVGxHiee8HIUibbmW8ZYWiBvjYelvnPKzxRE
	6QFMPXuM4szGEPFL6uihG0bqZFWp57RVPfWN/4Sr7VFqBdrYonQOED5W+kb/cmqGmlWY4B
	2Wrg0rQXx0htRKLHSr5XjeGSuhra6r8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MtQNiUA8;
	spf=pass (imf06.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764577014;
	bh=SjCMyB1dHNwtgPTS0MoHLJhuhnjVA2MdD0tj6aAiy7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MtQNiUA8jUaVwIUGbuaTBXQWC/AgCctwBHVMPb+164YHYlYfjkrYFBJELoRP0VqGb
	 P9DYysHwyY9kNkN4LfOU3AU5gV+OjAkHy48NAyqKLDB8GeZLuhfjPlr524yI4a4YzQ
	 VvkTxUKOq+PtulTUbIbaODh1Xj+fWtWz3HKq+LS9iTVwP6xLmecWck7pwCi9gQY0uJ
	 PXBtYQTRV2aQxBC+xkYBfdJZjqFfX0pf0/lyTxNAzTFkL6Dy0RMJxjTzXr59VDelRL
	 5V6fNUFWH+w1H0gQT+gSiwBWn38MemyT2zTpwxcnhY2dHLO3SE5/VWksC+H8btMcPI
	 nfEFt6sQabtYw==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9CCE617E126B;
	Mon,  1 Dec 2025 09:16:53 +0100 (CET)
Date: Mon, 1 Dec 2025 09:16:50 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?TWlrb8WCYWo=?= Wasiak
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Christopher Healy <healych@amazon.com>,
 Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v10 02/10] drm/shmem-helper: Map huge pages in fault
 handler
Message-ID: <20251201091650.4c45e494@fedora>
In-Reply-To: <20251128185252.3092-3-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-3-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8tanp4i49j3braxejr1bt48pdnt8hzsg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4013A180016
X-HE-Tag: 1764577017-435717
X-HE-Meta: U2FsdGVkX18B7vgbWytVBgPX39iO+J80NbYCwUjAO0WzvnOBPccS1qYdh3UCWN4Oc09xejJrRwLxSO4jxZyHapvy9JW3ne38kQQAf2FQZGa2zUQ0qyW1tmCLj1o/zJ+ocQU31wfNoIrv9vusrgXU/l9/VHyFW8Nq5BqZz61rZ44zYHrvOjeH5xllppS1ypoTKQ+NzOB3/LPzYb2dDyt2B1jGSNgdEMscjGEfVjGK8vW1dS2UGGEq6GNUFBCUlFcSi4qRqKuRnJdpX9IHPecYA0k/XGgBRE1Yl42qLPrA2QyE5RB9Pa9hhrqY/YQCz3k5vZxKD2mz4EraxFs+tsqQoqfVnx66XQapmhV7qeVPSaSKa2NztWKFleek9vjjDtJkKgOQ7rqsS/eQUBRP9eDfyEiqNgYAjsNjtuCRB3fm/d0MSGYxg8Mzh0u/ETE+tlqdGMb8PpOA4+T71u5I91skha75A3PkNYeK1u5ExpfrkD4ogNTc3FpICIwF1XqoJLHed+5Ao79cYsDUaig5yhY0hdoWTUxRr/v+MOMpmQNWSoPMJ2OqefBtMbpugNqKuMW/0q20fASOPqLjVV0l8n/4aPyeee6leHkvEhbC03XDytqHcauv8vySr9+VUHjC59iujdhnr/mkCPdPfX3xfBUbTCzV7nH5FdQJGDlwAyUqyiBl40pVdemLAcVfFrlHO2kbbAAa1aJBRA4DXtmvCoFQOnSRABSzf1VMkKBcYQw4jSSZNLtDQK1j6/whNoZvkwu50oUfrljXFahkrtmg1FZMTiY/ZcyP/fo9ilFdAtG7Vn4AQSDfTn0icbAWndXFvCuFmR1UiqBK4o2VMAGVYjERql8Hakc+xbyNLK5DLMRnmqEeZVDjgbheVbrqdzEIFmNP9TH6Ve20tngUWP74etDjIaMa1D0/lOsBTyrqTaNSPVxW0hGXrf119HJTohJECYH47VJgrnJyZn2ahK9l6YH
 +00hgNyT
 J0N7SNhfWax2bGrho5oX/2PQMBKc6UAbRT4wkVK8fuEG0xkSJkp/ArHPz1SRGffhD4n14D19AL2cFMT80CEMKwxG6YzZ8wV+eZJDhQVAR2kBEX4gbMvPCqN6kQdW6KBcLbj3Er+FLrLoDY3gms/gsrp5okVXBeG/F1TO5AqC9eF/t5N4rEfHUr02LlZNiQ0uJzvcWvAdVaDFOZrUbyCaAqjLQLYSMJQihszwElAwssCzdD2G1mQ70PLRQXEaOu8w73/osYn9zWo85gDKXdN9qx8RnDCT11GAZ6OsRZpUC4rg3hsTExPMw7uTGhRjj7QU9bOSxFdM5UKA19gDIcw4Iufi9hJM8y7+/hXNafk6DbOzncOjTqundTM3f1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:44 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Attempt a PMD sized PFN insertion into the VMA if the faulty address
> of the fault handler is part of a huge page.
>=20
> On builds with CONFIG_TRANSPARENT_HUGEPAGE enabled, if the mmap() user
> address is PMD size aligned, if the GEM object is backed by shmem
> buffers on mountpoints setting the 'huge=3D' option and if the shmem
> backing store manages to allocate a huge folio, CPU mapping would then
> benefit from significantly increased memcpy() performance. When these
> conditions are met on a system with 2 MiB huge pages, an aligned copy
> of 2 MiB would raise a single page fault instead of 4096.
>=20
> v4:
> - implement map_pages instead of huge_fault
>=20
> v6:
> - get rid of map_pages handler for now (keep it for another series
>   along with arm64 contpte support)
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 55 +++++++++++++++++++++-----
>  1 file changed, 46 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index be89be1c804c..81f4ac7cb8f6 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -567,31 +567,68 @@ int drm_gem_shmem_dumb_create(struct drm_file *file=
, struct drm_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
> =20
> +static bool drm_gem_shmem_fault_is_valid(struct drm_gem_object *obj,
> +					 pgoff_t pgoff)

AFAICT, extracting the fault_is_valid() logic into a helper is
orthogonal to the huge_page mapping stuff, and I don't see it being
used in the rest of the series (I guess it was when you were
introducing support for map_pages()). Maybe this should be done in a
separate patch, or postponed until there's a second place checking for
fault validity, dunno.

> +{
> +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> +
> +	if (drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
> +	    pgoff >=3D (obj->size >> PAGE_SHIFT) ||
> +	    shmem->madv < 0)
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool drm_gem_shmem_map_pmd(struct vm_fault *vmf, unsigned long ad=
dr,
> +				  struct page *page)

nit: could we name that one drm_gem_shmem_try_map_pmd()?

With my two nits addressed, the patch is

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> +{
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	unsigned long pfn =3D page_to_pfn(page);
> +	unsigned long paddr =3D pfn << PAGE_SHIFT;
> +	bool aligned =3D (addr & ~PMD_MASK) =3D=3D (paddr & ~PMD_MASK);
> +
> +	if (aligned &&
> +	    pmd_none(*vmf->pmd) &&
> +	    folio_test_pmd_mappable(page_folio(page))) {
> +		pfn &=3D PMD_MASK >> PAGE_SHIFT;
> +		if (vmf_insert_pfn_pmd(vmf, pfn, false) =3D=3D VM_FAULT_NOPAGE)
> +			return true;
> +	}
> +#endif
> +
> +	return false;
> +}
> +
>  static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma =3D vmf->vma;
>  	struct drm_gem_object *obj =3D vma->vm_private_data;
>  	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> -	loff_t num_pages =3D obj->size >> PAGE_SHIFT;
> -	vm_fault_t ret;
> -	struct page *page;
> +	struct page **pages =3D shmem->pages;
>  	pgoff_t page_offset;
> +	unsigned long pfn;
> +	vm_fault_t ret;
> =20
>  	/* Offset to faulty address in the VMA (without the fake offset). */
>  	page_offset =3D vmf->pgoff - vma->vm_pgoff;
> =20
>  	dma_resv_lock(shmem->base.resv, NULL);
> =20
> -	if (page_offset >=3D num_pages ||
> -	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
> -	    shmem->madv < 0) {
> +	if (unlikely(!drm_gem_shmem_fault_is_valid(obj, page_offset))) {
>  		ret =3D VM_FAULT_SIGBUS;
> -	} else {
> -		page =3D shmem->pages[page_offset];
> +		goto out;
> +	}
> =20
> -		ret =3D vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
> +	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
> +		ret =3D VM_FAULT_NOPAGE;
> +		goto out;
>  	}
> =20
> +	pfn =3D page_to_pfn(pages[page_offset]);
> +	ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> +
> + out:
>  	dma_resv_unlock(shmem->base.resv);
> =20
>  	return ret;


