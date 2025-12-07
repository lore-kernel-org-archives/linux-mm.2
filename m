Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65678D3B7DE
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975A96B0005; Sun,  7 Dec 2025 09:16:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926246B0006; Sun,  7 Dec 2025 09:16:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BA56B0008; Sun,  7 Dec 2025 09:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 696686B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 09:16:52 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05767C082E
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 14:16:52 +0000 (UTC)
X-FDA: 84192876264.27.DC358F0
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5403A0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 14:16:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oa4+297g;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765117010; a=rsa-sha256;
	cv=none;
	b=ETGYcm6OgETedNjxCD2NI7PCsimkXjkMyfPlezC0ziuD5I+MTO41nYuObLWN6Q2P4eGgxt
	b6QbK93Vx3jRCzC8Sglt3F1zuv6ZsvCsG9aVenPbWAkZI7NHpt5nTNLLGwahODFg2g5CT9
	Nq9/tlgQJdPUjAGVg5OUbHR0hyCusRE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oa4+297g;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf25.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765117010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3hLLRx50FbBBzirdBaadwngiwkvt/UqddVt7E+U/8c=;
	b=X9ILPBwxdeq+//6oQrZtIMfWrpkCpSrilKV8hZ8D/wtDmdo0Yy6IX1itpejJE/v0ANfH4W
	MFfO4ZEek0TIvRy7X1t6A12z8m6zEYVgarreqov6ks6+pnWN9Mk/4BGx75jQByfYOciwPJ
	3tK591TCKB7ONQ4r7zJSyMBMnIFNztQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=K3hLLRx50FbBBzirdBaadwngiwkvt/UqddVt7E+U/8c=; b=oa4+297g+2UCGCayvz+uQ6E/zz
	UOsO6P11PLgH2c/+veGq5tA+GRJKMlr7CL9h4HgI8zMI9tiBwhK/v0g7EKdCzc5E/A397PFsMVtak
	pHkVnTh2JUU0Jd1TAv7WiVTa395zPVKQP3RYAchyME9IVr7OliVuEMbOMl5aFqDMhvpzwSTtt4yUl
	UhIILV89Dk3ch/lhPnF9bxXMzlA+C9PuILvgT6PN9gvFSBlvhlccibnC6DiE1v0HaD9e73m21xe9i
	Gnq0JdHIUX0jPrI76jJ/9mXVLZs/b8MKBE9shzv9EOeZCBNA4dDQ8bq+8VfX9OhEmWV4XfEwTkIlo
	9DWQG4fA==;
Received: from [187.36.210.68] (helo=[192.168.1.103])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vSFYH-009l3a-0M; Sun, 07 Dec 2025 15:15:53 +0100
Message-ID: <a3586baa-2403-43f9-a692-da3e79482cbb@igalia.com>
Date: Sun, 7 Dec 2025 11:15:40 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/10] drm/gem: Get rid of *_with_mnt helpers
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251205182231.194072-1-loic.molinari@collabora.com>
 <20251205182231.194072-8-loic.molinari@collabora.com>
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
Content-Language: en-US
In-Reply-To: <20251205182231.194072-8-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5403A0005
X-Stat-Signature: ynjeiprqsn4saznpbheqhdhwxgxwyyfh
X-Rspam-User: 
X-HE-Tag: 1765117009-160733
X-HE-Meta: U2FsdGVkX19twv4O4pQTITNrS06GcnbPN4in7drRgns52dHl6BvfVF8wH0EnJXobTPqJCGS7hT+kc08669iR0tKM8V20tXyzGtkMuLeBhK9duZTO/ruaHnk7Y5q5qwYfrYAoflwTSUORdXdashHovmDYDfqpIMfgwJiTH7jX9T6Gq8wxyJucDWTJ66GvlSL2FT4KadyoXetBzPCyd3zpwIA35bH5e0rFTawTj6ncve0/wAykLrl+ec1l2GKY5vam7C8UEiMQiXW7Ac0QFfAX257UV5UX2dH4AlbJMbLdLjZQ2zdguEF62DsobGM9NXRhChCwaPJ2v8IHPhrESB4ASx+zffyGgpgrzE19XAbmkrw95cmXih4piByuh+Y9J21pp89HwbmdzOq/dkNjCJwFRFVficBkz6umAyyJXhjXTS8JwfpBFCxqjw2UN24SEX7j7zNspnIF6nK9nNfNHNo7wVFaIOMAhjf+gvGPJZPadrfYWQQFpKTcOr4cR8Sa/eLt6PYLsl7Ynq9sgUI+lkzlC4Ylea05C16phrTV1VuNjeAPLF7wfAYSiNTXHPQJ6q4yEgQFZrWWTtsoX0bG0yVtKyOwWkYJTU66/dm3co/dAZaqwIMVOYEd9PwuSqhdXiQfus6k76L9+3DXyGG5O3GkmiE0m3kqJyGHiZutH0sONFz4q6U2THH0hySoUX7XCJGLv7QKzxP7q5WeFlqkzB5t40GiUEywnlJdR4Q9prISKftjHZZ8qsCOvkNMQSfzBHf6xTTCDb2GaNs2LLbAKcIk+VpWCCEqnMyYIzWgWptL336kKEwQBjrGz99PBSsfqmFQ7auPAo+5HbyxRGLLDNFvCpC1mg1rJQ7fR+1kGAdLXk1DfSfm+fQyDHuube2CniYb4/E8GxBP9FWCf08ZM54G5U45Y8AROt4sQ2SHRw5/r96X0fEZ1q0DccFsVE27okoTqgK1AF2q2cVCIcmjvBd
 kiJeiWQh
 Zh+jqnadkps+KgPb/S53h/o3i1hU2WscZyJrTHuNuCPGqLzGzbURS+oabu1FUwUek6muO6+jQQoU1iBdVNT+/LPpjBE8Uw9p1fAxMQ0CwBAFDr75FaX6lwtuUC2Rz/gsjPieJcPdz+0j0WZWuYt+OQrcTyxdj1mLL0jMZCFJhjcH9SxjPLISzOp5mCBOwHFPzpy/GDzyp+CvEFDm1FbJvNQviWk59++bDxPc7jk1NT+R0axme6QMM4FFBkseG62BsDRu0ttrzUI+KADlX4dV1JlJ8nAR5v4GC4ac5fLRD8IkzAr5Ra6g/I3Dw77PLPNVmanV1jNuv7LMsCHhJxREU3t3YEHmu/LhVnXXR9VMReCnkwqO/Mu56D9gPe5rwt3jfszSAGiFztR5g4WoTbydEGzZP16f18JhKA4cazurX81cksKcbwI96rMb6/wAq+5yxO//ZSvAgCdDdd0N9L0bv+fOzuvmGxM9VxHaK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

On 05/12/25 15:22, Loïc Molinari wrote:
> drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
> be removed now that the drivers use the new drm_gem_huge_mnt_create()
> and drm_gem_get_huge_mnt() helpers.
> 
> v5:
> - use drm_gem_has_huge_mnt() helper
> - compile out shmem_file_setup_with_mnt() call in builds with
>    CONFIG_TRANSPARENT_HUGEPAGE=n
> 
> v9:
> - replace drm_gem_has_huge_mnt() with drm_gem_get_huge_mnt()
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Reviewed-by: Maíra Canal <mcanal@igalia.com>

Best Regards,
- Maíra

> ---
>   drivers/gpu/drm/drm_gem.c              | 37 +++++++------------------
>   drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
>   drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
>   include/drm/drm_gem.h                  |  3 --
>   include/drm/drm_gem_shmem_helper.h     |  3 --
>   5 files changed, 19 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 32dddb23e211..6021c4087a08 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -171,29 +171,28 @@ drm_gem_init(struct drm_device *dev)
>   }
>   
>   /**
> - * drm_gem_object_init_with_mnt - initialize an allocated shmem-backed GEM
> - * object in a given shmfs mountpoint
> + * drm_gem_object_init - initialize an allocated shmem-backed GEM object
>    *
>    * @dev: drm_device the object should be initialized for
>    * @obj: drm_gem_object to initialize
>    * @size: object size
> - * @gemfs: tmpfs mount where the GEM object will be created. If NULL, use
> - * the usual tmpfs mountpoint (`shm_mnt`).
>    *
>    * Initialize an already allocated GEM object of the specified size with
> - * shmfs backing store.
> + * shmfs backing store. A huge mountpoint can be used by calling
> + * drm_gem_huge_mnt_create() beforehand.
>    */
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs)
> +int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *obj,
> +			size_t size)
>   {
> +	struct vfsmount *huge_mnt;
>   	struct file *filp;
>   
>   	drm_gem_private_object_init(dev, obj, size);
>   
> -	if (gemfs)
> -		filp = shmem_file_setup_with_mnt(gemfs, "drm mm object", size,
> -						 VM_NORESERVE);
> +	huge_mnt = drm_gem_get_huge_mnt(dev);
> +	if (huge_mnt)
> +		filp = shmem_file_setup_with_mnt(huge_mnt, "drm mm object",
> +						 size, VM_NORESERVE);
>   	else
>   		filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
>   
> @@ -204,22 +203,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
>   
>   	return 0;
>   }
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
> -int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *obj,
> -			size_t size)
> -{
> -	return drm_gem_object_init_with_mnt(dev, obj, size, NULL);
> -}
>   EXPORT_SYMBOL(drm_gem_object_init);
>   
>   /**
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index e67216cbb469..f8bcd1b0eb32 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -50,7 +50,7 @@ static const struct drm_gem_object_funcs drm_gem_shmem_funcs = {
>   };
>   
>   static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem,
> -				size_t size, bool private, struct vfsmount *gemfs)
> +				size_t size, bool private)
>   {
>   	struct drm_gem_object *obj = &shmem->base;
>   	int ret = 0;
> @@ -62,7 +62,7 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
>   		drm_gem_private_object_init(dev, obj, size);
>   		shmem->map_wc = false; /* dma-buf mappings use always writecombine */
>   	} else {
> -		ret = drm_gem_object_init_with_mnt(dev, obj, size, gemfs);
> +		ret = drm_gem_object_init(dev, obj, size);
>   	}
>   	if (ret) {
>   		drm_gem_private_object_fini(obj);
> @@ -103,13 +103,12 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
>    */
>   int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem, size_t size)
>   {
> -	return __drm_gem_shmem_init(dev, shmem, size, false, NULL);
> +	return __drm_gem_shmem_init(dev, shmem, size, false);
>   }
>   EXPORT_SYMBOL_GPL(drm_gem_shmem_init);
>   
>   static struct drm_gem_shmem_object *
> -__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
> -		       struct vfsmount *gemfs)
> +__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private)
>   {
>   	struct drm_gem_shmem_object *shmem;
>   	struct drm_gem_object *obj;
> @@ -129,7 +128,7 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
>   		obj = &shmem->base;
>   	}
>   
> -	ret = __drm_gem_shmem_init(dev, shmem, size, private, gemfs);
> +	ret = __drm_gem_shmem_init(dev, shmem, size, private);
>   	if (ret) {
>   		kfree(obj);
>   		return ERR_PTR(ret);
> @@ -150,31 +149,10 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
>    */
>   struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev, size_t size)
>   {
> -	return __drm_gem_shmem_create(dev, size, false, NULL);
> +	return __drm_gem_shmem_create(dev, size, false);
>   }
>   EXPORT_SYMBOL_GPL(drm_gem_shmem_create);
>   
> -/**
> - * drm_gem_shmem_create_with_mnt - Allocate an object with the given size in a
> - * given mountpoint
> - * @dev: DRM device
> - * @size: Size of the object to allocate
> - * @gemfs: tmpfs mount where the GEM object will be created
> - *
> - * This function creates a shmem GEM object in a given tmpfs mountpoint.
> - *
> - * Returns:
> - * A struct drm_gem_shmem_object * on success or an ERR_PTR()-encoded negative
> - * error code on failure.
> - */
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_device *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs)
> -{
> -	return __drm_gem_shmem_create(dev, size, false, gemfs);
> -}
> -EXPORT_SYMBOL_GPL(drm_gem_shmem_create_with_mnt);
> -
>   /**
>    * drm_gem_shmem_release - Release resources associated with a shmem GEM object.
>    * @shmem: shmem GEM object
> @@ -851,7 +829,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
>   	size_t size = PAGE_ALIGN(attach->dmabuf->size);
>   	struct drm_gem_shmem_object *shmem;
>   
> -	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem = __drm_gem_shmem_create(dev, size, true);
>   	if (IS_ERR(shmem))
>   		return ERR_CAST(shmem);
>   
> @@ -899,7 +877,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
>   
>   	size = PAGE_ALIGN(attach->dmabuf->size);
>   
> -	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem = __drm_gem_shmem_create(dev, size, true);
>   	if (IS_ERR(shmem)) {
>   		ret = PTR_ERR(shmem);
>   		goto fail_detach;
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index 3ee8d9c36d92..c4316b768b3d 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -153,8 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
>   	struct v3d_bo *bo;
>   	int ret;
>   
> -	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  drm_gem_get_huge_mnt(dev));
> +	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
>   	if (IS_ERR(shmem_obj))
>   		return ERR_CAST(shmem_obj);
>   	bo = to_v3d_bo(&shmem_obj->base);
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 97b5fca8966d..cca815dc87f3 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -529,9 +529,6 @@ void drm_gem_object_release(struct drm_gem_object *obj);
>   void drm_gem_object_free(struct kref *kref);
>   int drm_gem_object_init(struct drm_device *dev,
>   			struct drm_gem_object *obj, size_t size);
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs);
>   void drm_gem_private_object_init(struct drm_device *dev,
>   				 struct drm_gem_object *obj, size_t size);
>   void drm_gem_private_object_fini(struct drm_gem_object *obj);
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
> index 589f7bfe7506..6b6478f5ca24 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -109,9 +109,6 @@ struct drm_gem_shmem_object {
>   
>   int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem, size_t size);
>   struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev, size_t size);
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_device *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs);
>   void drm_gem_shmem_release(struct drm_gem_shmem_object *shmem);
>   void drm_gem_shmem_free(struct drm_gem_shmem_object *shmem);
>   


