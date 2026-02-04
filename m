Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E66BE9D402
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364EA6B0093; Wed,  4 Feb 2026 11:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312416B0098; Wed,  4 Feb 2026 11:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248F76B009B; Wed,  4 Feb 2026 11:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1328E6B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:04:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC0A757688
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:03:59 +0000 (UTC)
X-FDA: 84407245398.18.FD98EEB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9B90180013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:03:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AVzXf6Ju;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770221038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9lIxu4ovet3xhuS4wnPeL3igvkStQvaCz+D9Z2wMRo=;
	b=jKp4F3jYN5KPx+GlAk2Zcs1c3r8Tc2tRbpTZcMGFsIj+KnXLongNT3mEb/l8v0PHoQ7CzM
	dK/YZRCmyCdRNyzDh3UVQyDIkBNPUtGvMAA3lYrSLD9shm4Dgt1Or/qLxDX0a7br3UKEB6
	7cGBuxahCZH/adVR655WSjsgPODKymk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770221038; a=rsa-sha256;
	cv=none;
	b=srflNqc3bva+mm9QajVHjGOLB7Ohmf22rM7sfS0UjYEY0E1W0S5SkqJGX+qJRCmz14K9Qq
	GNRvmUqb6et1gDT8Ke1N9WX23ff8mzY4rYGb+lujtY9Vw88mqPq8kkpJ34J3G876pI7DfI
	8vU7RHMJL0cqXLhHcGGs/Tf+Zb2BgZE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AVzXf6Ju;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b9lIxu4ovet3xhuS4wnPeL3igvkStQvaCz+D9Z2wMRo=; b=AVzXf6JucTDPWVzrpQ9XcUMEMX
	z+HeNAuKCPsQFG5JrRLiDvhnyJ3iXUaG6Oj3VrHMMb7CdMKCOiZTl2PllyeyqDrUfZm5jkbBX7nt5
	Y5BU0mR/TvGLvXKFocq5mnJ+KDK4s7TAebhq2bd1BTB+ffCH38WwHowo1MECacVwJmNm6ynadJUzA
	tDTJEsvxB/Q/wMCcX8JZWNATbxhjraAiPh6oCrMFL7QFLbviam1Yqf5iEnYbSTvzv+LHIX/AhBM9b
	xzzKOzfxfLW1u+hUfHNUy96xIAyGrkTbb3dqFNS+oKCseN0tqZgHwWp2B0Q9ZN5GRHi6uGgxRj4wU
	i5cdSDQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnfM6-00000002ItN-1FYi;
	Wed, 04 Feb 2026 16:03:50 +0000
Date: Wed, 4 Feb 2026 16:03:50 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: boris.brezillon@collabora.com, loic.molinari@collabora.com,
	frank.binns@imgtec.com, matt.coster@imgtec.com,
	maarten.lankhorst@linux.intel.com, mripard@kernel.org,
	airlied@gmail.com, simona@ffwll.ch, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] drm/gem-shmem: Map pages in mmap fault handler
Message-ID: <aYNt5m8rffUYK1al@casper.infradead.org>
References: <20260204114341.195143-1-tzimmermann@suse.de>
 <20260204114341.195143-3-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204114341.195143-3-tzimmermann@suse.de>
X-Rspamd-Queue-Id: C9B90180013
X-Stat-Signature: om55ix9x8bbf11qc4jcjxore6urkkyto
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770221037-550783
X-HE-Meta: U2FsdGVkX1+Xdlz9zaEqLr/xS9ojNSKJXMtmUfzdOLbbXgH/HwgV6i+Op3YP8hoCw+z3OmlBrOySPMAN0yi3PYwGDGvAa/8wkhhqwVWlMYdK5P19AmKk88FMm8yU+9jMIr0kMmib8irJ/jgyr/ArAQ+ERCDFRLXOVdii+UXSprqjwOTFGLGIJ7n5EbmG+ofkh31Aw7X3Gd4PNYH+VHTCfpKCQwfRarm3jWs7lE3ktnVV6zacEzSAIU3mzvUN46s9vGf9S4mQmLQkN5vIaKmJalpIfeevEk2hCpOk58tcnM8KPI9szAyIqUnubXcK7H3JTFCZRXbncbrjtUw1rmm4GG3rODkRI6aVpdYMlxmsj/t23xweJy6U3KKR3YlAudg/m4+MvBp04BKat7cZ5tD2qW+zwI8aTK9h7VUziO8ligMp4GmwxckSXPqwLhgCy3mITbhgnHOjmX4C0JqoZrglJGQMpD+QsywtvpgGGr7lPjoUO4gRq3eC6YQDaZ9e+3tAVln2YRRogVxfJGP96oduFUyZSYy5+GD+/HOCSlz/gJAyukGxOrU9k39PtaoclMG4mF8Rw0IbQtu06GrG6F9mYRll66nDEU+1eosLe8yzKelfIm/zsbOigQ7DBoEemsgE8sUT+Bo5L0pX1RySYFeN7Xj12UEv5bVtTOX70nACjUTTsqohtEkOoznCDzYftKHbZoGmjk/37xrbMzh5USdONsT0TPIrkJ+G+qGWjWz60Y295cABJU7vjpnwvgIy46qm5fVFpgQ/vReaqDawp8Zq4cd6HNdmO6xK3+kDzDnSfDCRepxNebp+yvbzJZhMcRV2qA5qlDZNbsIpi38SuxiLnOcOdUrxAjeN72OMnIiQsG/6Fwo7RcKcdGjmWDTymHHgLc/WPbrRZBBZ0rmsfXlgauaBj6DGd8vAOo/oHc4PE/xYbhpErF1J71h6jXmetFx/YUDrDGFT8qw7UvM2ijc
 Z42a5eg8
 Vn4n+LCyoI29ZX9159bhmhaVKGhZcTntyWhXFSBo3KzCxTEP5QaUk7HDxw9t0hgxFShD5zaJIk9r1LRR5PxCLDkhodo/XIPAJN+d9CD2E1dr1lJ952JVJ85FrsfWpZwKej8o8MTLRY6QvX5U5O5OLI5WG71gRcs4qCxO8uaJBmLe66GVYfWeeNbH9TEoQzHrAAHl98J3oho7vzMCOPT0AR3ytyfLRHp73E6gcp+gDI/gWXFMyxA+UCuIckQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 12:39:30PM +0100, Thomas Zimmermann wrote:
> +	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, page);
> +	if (ret != VM_FAULT_NOPAGE) {
> +		struct folio *folio = page_folio(page);
> +
> +		get_page(page);

folio_get(folio);

> -	pfn = page_to_pfn(pages[page_offset]);
> -	ret = vmf_insert_pfn(vma, vmf->address, pfn);
> +		folio_lock(folio);
> +
> +		vmf->page = page;
> +		ret = VM_FAULT_LOCKED;
> +	}
>  
> - out:
> +out:
>  	dma_resv_unlock(shmem->base.resv);
>  
>  	return ret;
> @@ -689,7 +698,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
>  	if (ret)
>  		return ret;
>  
> -	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_mod(vma, VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);

Do you need to explicitly clear VM_PFNMAP here?  I'm not familiar with
the DRM stack; maybe that's set for you higher in the stack.


