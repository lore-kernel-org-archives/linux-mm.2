Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA79D34094
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638A86B0088; Tue, 27 Jan 2026 10:52:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602C56B0089; Tue, 27 Jan 2026 10:52:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525DE6B008A; Tue, 27 Jan 2026 10:52:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE1B6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:52:50 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5F19B6C0E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:52:49 +0000 (UTC)
X-FDA: 84378186858.03.DF5E403
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 936A0A0017
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:52:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Q/qL2+gL";
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769529168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0iUHH7hrzY92UrriF0Zwe3VNDVROGGmufPatJJpiJs=;
	b=5Pmpz4OD6BEMmG1AisQwFL77Mx5RI++1H5TcsGrjXQyqUDUWG5YiB7GJoIshf33h7PPSsu
	wE2K1Z1HEQ4iaSzw97xuoP3Uv/rO+CuoCAWtetGx1v+Txjn0q0PtjBMqObqwzj+yMLRL/W
	/alHGsUmWii1gOitdbZ4b1CxYpb0JBk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="Q/qL2+gL";
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769529168; a=rsa-sha256;
	cv=none;
	b=Ouc0JGHZCoEvHXWfp7ShzK2XgcaGVM4BRTLCTjOCuJVrt+8PErpoYEzOWFCv7qJ8t3+/ku
	q1e5xAFR3j27IfgEp7oFzNhoLEYP5yRSqzLeLxDVgXfTel9tshj9zoT4VqSti8uTPfiLn2
	zyQPYAvG6L360A1c75Po3ae5uiB7qDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1769529164;
	bh=Ma9DUQK/UE5KKiJVITo3EgKsfU16YIafflssOe2kpFk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q/qL2+gLej/GQpukA/veuC+5qzdUsML/gqM+1q8cw8b+dcy1RhJb6HbGJumTlmiw4
	 fWyvYjHkwS2hNODt1/xc4m1QGf2BN441uY3RDzIQp3c2/oPL/y+imFySjWNiXORJXF
	 32gsNg3wa3d/M8jGCmmU4W+wbOIzehGzxclt9IG2YmJ4sF18nECXULAicvq4E3kv36
	 myQ5kilkTToaX13twmBXrfSFaVYtVQgcJjKMk24FzheJgd0u3zg88M0gd5aUDYPFPk
	 95E5ssq/GWaAlad4AVoOKV0tSr/T+S3/7iUv9grTzTVjmu17xOFYNDFArFk7TEVoz6
	 J5IBpGjDh5SqQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0B0D717E012E;
	Tue, 27 Jan 2026 16:52:44 +0100 (CET)
Date: Tue, 27 Jan 2026 16:52:39 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, frank.binns@imgtec.com, matt.coster@imgtec.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] drm/gem-shmem: Track folio accessed/dirty status in
 mmap
Message-ID: <20260127165239.78f3dde6@fedora>
In-Reply-To: <20260127132938.429288-3-tzimmermann@suse.de>
References: <20260127132938.429288-1-tzimmermann@suse.de>
	<20260127132938.429288-3-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 936A0A0017
X-Stat-Signature: h4nm4s4axtki9q5x9hen4p1j9un4wi77
X-Rspam-User: 
X-HE-Tag: 1769529167-403959
X-HE-Meta: U2FsdGVkX1/Cz4byZpFIyUOnET4MCWyccYI2NrjWzsUyLEqQg8nGjk9YeD4rJGKdQeZSNbpAl8iiCJE3IL/qLO0zYMog2V1TZO2Wmmli1YXhZ//NhkF7QXVV0j45Eu92HT9nAJwq9PwXhsMcPbX/2g6eZ+5wfxRyk180v1Z1RKujbket/DhvTYec+wQDuMn0a7LPlZOnJy91ntUyQi9jabkqIx82GqXlpuD7iGGXz/fQt/ntDcWGvYFrJGOaU9AFv5Fjd3+uCPdz1rzMvykpKCf6jSlygIMeIdBD2ZsRiVVlYNMfy59L3VPBiQtBJZdbloqHQqHPasdOX0B11oWOZxGaCsIt2uwhKZYeoM6M1aA6YIQsCtWC72QvmITtDgk6Q4QjOBiQXK5H0iGZImfyaSyXZV1MPYv7gj2de59Rqy396QT+eUyTXKWnAO9iOGYocZeXsimYLY8F49oaUyxu37euFFhs6ADOygAY/HjLTHNLgkzpnxTUdbDCrHy9XeKJMhvhECVB3vcZmfGJ3NaaHneGj6f40onfmQiaCrNxZookje4Anx5QcnVMqOnzFAX7sQEwYhHAG2FMne26Z4yLxPYmC82TCTSAKv1Sf27YgDTkfdx1bm/6JM3m12LSLmb9lOFmYgJSiNOPcrUXY0FvpWFzbU73V64Lo8Ngd/fGeKTlqUp62aJftnac7p68+a0f5rmiXG3c53Awvg1WW9D8z3f4Acvs0DEFKTgFElOjd+MnDaOAcliMO66RYewiIGfMANOzffJ6HzSw/1Hvt6nGfzISVmMGBfwzmAu2v49lEMy7p6PD2EIGqBYn543Ypp93+vKDZjc+I9v4bdTYq65NIxdUyAY5z3sPGrbiZXGQpJr+bPg7vBX0u9n+wf+bM4INl0FCtnlv2lqsbX9T0aiTpgfTEOZSsRRBOGTywfFBHbtmqXCFWuerjSONTRT7Og0gOVSimfG2Y9e0sI+US+W
 BrRiwPoa
 Rmn7u9TZ7KtWkGZ+oSw8EdluhZzlPV9Ga/U9X3KY3V0jcAQAnv/gK1zWx9yMOWCKr4OkTnzXnrQtVH7eg8dPpm5kGVNvycuW8NqaP+xZbP8zxVbCJ4aqJcE0AzMkYVCxDumw5ckQthfySycNz6ye96ayTdjIKYAZF0mLtbLnenRTHCV90VX/dnxd35mMvU3c3bOO6URe2hJ6V11/RHmbBqhw1M8qa6iIWBiBuZMlnOQSkHwWC1v+hibM4qQAVvNQmBBg8VHloBCDEe2K6W24LbvJ85Nsn5++F83Ol59iyXH3XG+veF1nZxLKZ7TK9gw+YI5BbeQhPWzMEJWb+A+E1x8Au/5DXjJ3i/GESpUEpkdG8MuADVs+Czmkwqo9DAlqPXVWtcWxkCoFkojC/AXnVqXjntA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 14:16:37 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Invoke folio_mark_accessed() in mmap page faults to add the folio to
> the memory manager's LRU list. Userspace invokes mmap to get the memory
> for software rendering. Later compositors will do the same to create the
> final on-screen image, so keeping the pages in LRU makes sense. Avoids
> paging out graphics buffers when under memory pressure.
> 
> In page_mkwrite, further invoke the folio_mark_dirty() to add the folio
> for writeback, should the underlying file be paged out from system memory.
> This rarely happens in practice, yet it would corrupt the buffer content.
> 
> This has little effect on a system's hardware-accelerated rendering, which
> only mmaps for an initial setup of textures, meshes, shaders, etc.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index b6ddabbfcc52..30cd34d3a111 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -562,8 +562,10 @@ static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
>  
>  		if (folio_test_pmd_mappable(folio)) {
>  			/* Read-only mapping; split upon write fault */
> -			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE)
> +			if (vmf_insert_folio_pmd(vmf, folio, false) == VM_FAULT_NOPAGE) {
> +				folio_mark_accessed(folio);
>  				return true;
> +			}
>  		}
>  	}
>  #endif
> @@ -605,6 +607,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  		get_page(page);
>  
>  		folio_lock(folio);
> +		folio_mark_accessed(folio);
>  
>  		vmf->page = page;
>  		ret = VM_FAULT_LOCKED;
> @@ -653,10 +656,23 @@ static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
>  	drm_gem_vm_close(vma);
>  }
>  
> +static vm_fault_t drm_gem_shmem_page_mkwrite(struct vm_fault *vmf)
> +{
> +	struct folio *folio = page_folio(vmf->page);
> +
> +	file_update_time(vmf->vma->vm_file);
> +
> +	folio_lock(folio);
> +	folio_mark_dirty(folio);
> +
> +	return VM_FAULT_LOCKED;
> +}
> +
>  const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>  	.fault = drm_gem_shmem_fault,
>  	.open = drm_gem_shmem_vm_open,
>  	.close = drm_gem_shmem_vm_close,
> +	.page_mkwrite = drm_gem_shmem_page_mkwrite,
>  };
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>  


