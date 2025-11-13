Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242E9CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F1C8E0005; Thu, 13 Nov 2025 13:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816968E0002; Thu, 13 Nov 2025 13:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D3A8E0005; Thu, 13 Nov 2025 13:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBB18E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:12:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E4A713C08E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:12:08 +0000 (UTC)
X-FDA: 84106377936.22.31C0250
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B20A40011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:12:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i0CbDAF6;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763057526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eHsuAs5Ho9vLqNPdoKJux8qPl4LGeHAR3Yo6gGLdMU=;
	b=nRdS0jrsE7cciLeBT2kXzZj+7asHolu5JDRO2H9V19v259ttYxg5Q1grtDr9L0jflU7Aee
	XkiA2na9pv3z96RHhtrL1OuqcmMzXVZQqyGvH37iuAXX8kYyS+srpdXpOGe7VQJDL+J3y5
	iIDtTbHXfMaM01DRD/fY5JDvx6Ld80g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i0CbDAF6;
	spf=pass (imf04.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763057526; a=rsa-sha256;
	cv=none;
	b=5C6VGUF15KuMAgzvgrc9Dt4AIfFg3QlR2yHAxmvGmVjNlXVtrZGdWnN4jPY43oYwYDaiDF
	lHbocgBTkwYPDhPDHkSNrcW4vWUUjJzUZpA12a5iSFdgZtVhhbFsaIdzwJOksJ2W8JmtDa
	Ruy6ogL2rcRg5zsnDFOAap82MJu4ctE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763057523;
	bh=eggkhC6mk5737Q6dXVCr1HI04S4YU8Wm2zybbQQ4foA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i0CbDAF6pCbWEMlJpLb//tNQ6Yv1i+dHQZGVPCJnVkweoEGmlw48d5tZDmSxx333M
	 nt4GoO0PyuP0bNbEwDVNY98cz438MWKbbxMjCD7dmmefRgQpXVVnQ321Rz9W4WBxr9
	 hD6NU3aIKykDFuGCJs028cshFoa/0CsSJCbdMtxLP+mtf94jPIFPj5LS8mnmIvR5fB
	 VrmSy0RLe/MFKL5HKfC7rc6/pcdLWGaZinio6jRZGnk50KKHbPwVoPEHabv3b9fBOs
	 x+gim+uMWamOOdj/T5PsKDWrMKn3cf9SwpobDBglRpuOtLPfsW2D8s5CBr4bNlbnV2
	 BuHRmPPV7+XRQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9222917E127F;
	Thu, 13 Nov 2025 19:12:02 +0100 (CET)
Date: Thu, 13 Nov 2025 19:11:58 +0100
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
Subject: Re: [PATCH v8 07/11] drm/gem: Get rid of *_with_mnt helpers
Message-ID: <20251113191158.43328c47@fedora>
In-Reply-To: <20251113170008.79587-8-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
	<20251113170008.79587-8-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B20A40011
X-Stat-Signature: 8ept59a6i61whwzymhk7k6u35xump8ig
X-Rspam-User: 
X-HE-Tag: 1763057526-477300
X-HE-Meta: U2FsdGVkX18QOrBsVj77X45Ila/fZ3v6MJLrT/CuWM9ztReT7n7wP9KMNRK75M+B8QSm5p7OQRNymA43SdwDG4jEVWnP7/X/pGmbWmqdWHhl4Q8wusYG8jiLYCdurZfgOcuOcvuluYIwNnmtg9SRxt0Am0hu6LRHtP2+IbP9wRqy72cI0x7QJHuaeycfpkdZVAfRRdfZwGqQyESk7o9jwqOHf8x/xGq5mzq3WCCCtD3ZPrGj/0E8lXKIFQhNyhehnEuqPBYa2k0ukd//5y9qnIgl/L0RdAiZ2z3XpLteG46N33x66zjKGevgalRC9VH0xEJULCQw1dCLzGKjC4eIlLnPWrOwwa/IUVZw5MVmQ/jUatQCAyHXisBayF0CbQuYec5NVsDtlNpzTU3jQh15dxFREtlJHANF13VW/OwdElpNqrs3zWZMRhKJTeyYnfzitPQ9HANn7/Y5jGAf+lsM+Jug+04BVdddlrs1fZAprIOS80QldWkcocUQ87Roxv9t78fLz5JItR8kU3/C0bAfImEf9syfZpzn4iLAwDCvfpWltUe9i3OKACkhe+gwH6xHAA3n1TEloqaOTMo5ak3zvEntkmRzMvJ7YYsaRzr2n2ZOBflOj7wY6VBbBTl0Sxbc2yhbSNdjbVX8bxJIiscVVgI549SjKu6j9gELyL/I7Gx6eIJCNKTjCGvC+fZ1UYzjhEb1DdL9KZJ2ctxY3eFL1yfXvVNZTGYW3+9DHdMNYHd2UsZfqsZH6xOEWOcwU8q/+g4ahJOnfEUY2UDOo0CuzUvQFtAXXPHXDNgBk4a2nyfYZMRifGvz2e7jCJDiRQMdvbtTdRkPBexxXrcgt8jI9TYPMjF61DDYlXlDtkzqzoMiYzV9yf27mjM/SVYbcibzc00Te1VLrgjK5/fgobhwQZIv6toc6LlLgJh0/rlIxuyBmxU0CgnIRBCvOForMutVJzHCBhVUAo244zLmTD9
 JutvAfzn
 BwNjSXj6s+uMt5GykGUih/XPI5moNEE1hhdbvqK9YKVHa4ly4ta+q/4/cITxDMoPzD7AaIcrC4cMeq6C98vVfwDiu6JNidf8DSl1BJevy7SAPYe87fwb58LaWvDgS5+9wAanDFnDr/IgPUbj6zlCaP99YjnDoIo9l2lpSh8gBr7oHjScC6Nrwc39HdAw3gl0hQtnSAvHVK2meZ2JYD7rSbqIxZHarLa6Mr1phfBfxssis24QZZz0yM0ko4IHK3wSAffIiBk96q+hNqyqvOuZQYRPmyu0Agenfs1x+f5c/eBT0agZCc44tBTnrygNmW/geDJXKXSt1lQUK7dUkU47KGg+yqZOnW1VacT2QMv6NsnR9FlBc+qmWcFmmbE3A8zHqm+mfc51BSF/mqFL/PhPnYM4t7S7oZlHg9NPipsmStSCndyU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 18:00:03 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
> be removed now that the drivers use the new drm_gem_huge_mnt_create()
> and drm_gem_has_huge_mnt() helpers.
>=20
> v5:
> - use drm_gem_has_huge_mnt() helper
> - compile out shmem_file_setup_with_mnt() call in builds with
>   CONFIG_TRANSPARENT_HUGEPAGE=3Dn
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem.c              | 38 ++++++++------------------
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
>  drivers/gpu/drm/v3d/v3d_bo.c           |  5 ----
>  include/drm/drm_gem.h                  |  3 --
>  include/drm/drm_gem_shmem_helper.h     |  3 --
>  5 files changed, 20 insertions(+), 67 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index bbca2ab9e9a5..1b0b5813acef 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -171,31 +171,33 @@ drm_gem_init(struct drm_device *dev)
>  }
> =20
>  /**
> - * drm_gem_object_init_with_mnt - initialize an allocated shmem-backed G=
EM
> - * object in a given shmfs mountpoint
> + * drm_gem_object_init - initialize an allocated shmem-backed GEM object
>   *
>   * @dev: drm_device the object should be initialized for
>   * @obj: drm_gem_object to initialize
>   * @size: object size
> - * @gemfs: tmpfs mount where the GEM object will be created. If NULL, use
> - * the usual tmpfs mountpoint (`shm_mnt`).
>   *
>   * Initialize an already allocated GEM object of the specified size with
> - * shmfs backing store.
> + * shmfs backing store. A huge mountpoint can be used by calling
> + * drm_gem_huge_mnt_create() beforehand.
>   */
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs)
> +int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *o=
bj,
> +			size_t size)
>  {
>  	struct file *filp;
> =20
>  	drm_gem_private_object_init(dev, obj, size);
> =20
> -	if (gemfs)
> -		filp =3D shmem_file_setup_with_mnt(gemfs, "drm mm object", size,
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (drm_gem_has_huge_mnt(dev))
> +		filp =3D shmem_file_setup_with_mnt(dev->huge_mnt,
> +						 "drm mm object", size,
>  						 VM_NORESERVE);
>  	else
>  		filp =3D shmem_file_setup("drm mm object", size, VM_NORESERVE);
> +#else
> +	filp =3D shmem_file_setup("drm mm object", size, VM_NORESERVE);
> +#endif

I keep thinking it'd be simpler with a drm_gem_get_huge_mnt() helper:

static inline struct vfsmount *
drm_gem_get_huge_mnt(struct drm_device *dev)
{
#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	return dev->huge_mnt;
#else
	return NULL;
#endif
}

so we can avoid those #ifdef CONFIG_TRANSPARENT_HUGEPAGE in a few other
places.

For this one that would give you something like:

	if (drm_gem_get_huge_mnt(dev))
		filp =3D shmem_file_setup_with_mnt(drm_gem_get_huge_mnt(dev),
						 "drm mm object", size,
						 VM_NORESERVE);
	else
		filp =3D shmem_file_setup("drm mm object", size, VM_NORESERVE);

> =20
>  	if (IS_ERR(filp))
>  		return PTR_ERR(filp);
> @@ -204,22 +206,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *=
dev,
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL(drm_gem_object_init_with_mnt);
> -
> -/**
> - * drm_gem_object_init - initialize an allocated shmem-backed GEM object
> - * @dev: drm_device the object should be initialized for
> - * @obj: drm_gem_object to initialize
> - * @size: object size
> - *
> - * Initialize an already allocated GEM object of the specified size with
> - * shmfs backing store.
> - */
> -int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *o=
bj,
> -			size_t size)
> -{
> -	return drm_gem_object_init_with_mnt(dev, obj, size, NULL);
> -}
>  EXPORT_SYMBOL(drm_gem_object_init);
> =20
>  /**
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index 81f4ac7cb8f6..43a80f3fcfd9 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -50,7 +50,7 @@ static const struct drm_gem_object_funcs drm_gem_shmem_=
funcs =3D {
>  };
> =20
>  static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_s=
hmem_object *shmem,
> -				size_t size, bool private, struct vfsmount *gemfs)
> +				size_t size, bool private)
>  {
>  	struct drm_gem_object *obj =3D &shmem->base;
>  	int ret =3D 0;
> @@ -62,7 +62,7 @@ static int __drm_gem_shmem_init(struct drm_device *dev,=
 struct drm_gem_shmem_obj
>  		drm_gem_private_object_init(dev, obj, size);
>  		shmem->map_wc =3D false; /* dma-buf mappings use always writecombine */
>  	} else {
> -		ret =3D drm_gem_object_init_with_mnt(dev, obj, size, gemfs);
> +		ret =3D drm_gem_object_init(dev, obj, size);
>  	}
>  	if (ret) {
>  		drm_gem_private_object_fini(obj);
> @@ -103,13 +103,12 @@ static int __drm_gem_shmem_init(struct drm_device *=
dev, struct drm_gem_shmem_obj
>   */
>  int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obje=
ct *shmem, size_t size)
>  {
> -	return __drm_gem_shmem_init(dev, shmem, size, false, NULL);
> +	return __drm_gem_shmem_init(dev, shmem, size, false);
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_init);
> =20
>  static struct drm_gem_shmem_object *
> -__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
> -		       struct vfsmount *gemfs)
> +__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private)
>  {
>  	struct drm_gem_shmem_object *shmem;
>  	struct drm_gem_object *obj;
> @@ -129,7 +128,7 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t=
 size, bool private,
>  		obj =3D &shmem->base;
>  	}
> =20
> -	ret =3D __drm_gem_shmem_init(dev, shmem, size, private, gemfs);
> +	ret =3D __drm_gem_shmem_init(dev, shmem, size, private);
>  	if (ret) {
>  		kfree(obj);
>  		return ERR_PTR(ret);
> @@ -150,31 +149,10 @@ __drm_gem_shmem_create(struct drm_device *dev, size=
_t size, bool private,
>   */
>  struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev=
, size_t size)
>  {
> -	return __drm_gem_shmem_create(dev, size, false, NULL);
> +	return __drm_gem_shmem_create(dev, size, false);
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_create);
> =20
> -/**
> - * drm_gem_shmem_create_with_mnt - Allocate an object with the given siz=
e in a
> - * given mountpoint
> - * @dev: DRM device
> - * @size: Size of the object to allocate
> - * @gemfs: tmpfs mount where the GEM object will be created
> - *
> - * This function creates a shmem GEM object in a given tmpfs mountpoint.
> - *
> - * Returns:
> - * A struct drm_gem_shmem_object * on success or an ERR_PTR()-encoded ne=
gative
> - * error code on failure.
> - */
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_de=
vice *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs)
> -{
> -	return __drm_gem_shmem_create(dev, size, false, gemfs);
> -}
> -EXPORT_SYMBOL_GPL(drm_gem_shmem_create_with_mnt);
> -
>  /**
>   * drm_gem_shmem_release - Release resources associated with a shmem GEM=
 object.
>   * @shmem: shmem GEM object
> @@ -861,7 +839,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device=
 *dev,
>  	size_t size =3D PAGE_ALIGN(attach->dmabuf->size);
>  	struct drm_gem_shmem_object *shmem;
> =20
> -	shmem =3D __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem =3D __drm_gem_shmem_create(dev, size, true);
>  	if (IS_ERR(shmem))
>  		return ERR_CAST(shmem);
> =20
> @@ -909,7 +887,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_=
map(struct drm_device *dev,
> =20
>  	size =3D PAGE_ALIGN(attach->dmabuf->size);
> =20
> -	shmem =3D __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem =3D __drm_gem_shmem_create(dev, size, true);
>  	if (IS_ERR(shmem)) {
>  		ret =3D PTR_ERR(shmem);
>  		goto fail_detach;
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index 3bc714ea6392..d3b68ee05dbb 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -153,12 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev,=
 struct drm_file *file_priv,
>  	struct v3d_bo *bo;
>  	int ret;
> =20
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  dev->huge_mnt);
> -#else
>  	shmem_obj =3D drm_gem_shmem_create(dev, unaligned_size);
> -#endif
>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  	bo =3D to_v3d_bo(&shmem_obj->base);
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 58fa1e6b9773..75276a12208e 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -529,9 +529,6 @@ void drm_gem_object_release(struct drm_gem_object *ob=
j);
>  void drm_gem_object_free(struct kref *kref);
>  int drm_gem_object_init(struct drm_device *dev,
>  			struct drm_gem_object *obj, size_t size);
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs);
>  void drm_gem_private_object_init(struct drm_device *dev,
>  				 struct drm_gem_object *obj, size_t size);
>  void drm_gem_private_object_fini(struct drm_gem_object *obj);
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shm=
em_helper.h
> index 589f7bfe7506..6b6478f5ca24 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -109,9 +109,6 @@ struct drm_gem_shmem_object {
> =20
>  int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obje=
ct *shmem, size_t size);
>  struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev=
, size_t size);
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_de=
vice *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs);
>  void drm_gem_shmem_release(struct drm_gem_shmem_object *shmem);
>  void drm_gem_shmem_free(struct drm_gem_shmem_object *shmem);
> =20


