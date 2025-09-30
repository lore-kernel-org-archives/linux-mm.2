Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EDACCA471
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79C418E0006; Tue, 30 Sep 2025 06:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773CD8E0002; Tue, 30 Sep 2025 06:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0438E0006; Tue, 30 Sep 2025 06:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 599828E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:30:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E06F25A0CF
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:30:13 +0000 (UTC)
X-FDA: 83945546706.06.839F5EA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9D7B160013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:30:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jKq8joig;
	spf=pass (imf08.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759228212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WA7AZNB/K1H5rFmkeXDUOp7h1tGHfRfL/5/efBunjuU=;
	b=0jf7krm07CFuszk21Yjp59HjLwPGBXycJnxq6UwazFsE05BUSXbnHRIs0kFHdVb0SQ9YQ0
	PAH50f5Q4MQHBEfNFcVVzQobeQjaErEHQk9wnA7fDFRafPQfq9N7xzzco/L4ugOVuf2Gyp
	RoSMVy00EEY7Z5lQqDZDmtIOLKaV4kA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759228212; a=rsa-sha256;
	cv=none;
	b=4g5i6T7M7YnCSL7pqTaXbdh9yCX2z+zmYfWqa7ijuFzSKZB73Awo+Z9To/+VrEnespnXnq
	GE+Ua0RDLs9cHoUnATiBrJI1axkwUISjqr5CZuDoDES3gMebTTBdG3T5rF1pgNfSHa+KBP
	tBPo4F7l1uYlLkf81ADzVxl5Z/9MhSM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jKq8joig;
	spf=pass (imf08.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759228209;
	bh=3mTTpLiMqnXjtsubYnc/0h302ORdA8DbizXcRRMB8YI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jKq8joigCrtAG9Qt4gVEr7ETSzSYaNE4I9ApnBM8V78qDeF0YbigN7S+RDAn9Cy87
	 cv5VFUuOpqSgaIAoDAme8WyKJUGzxlGjprctBQJhHeLX2OhvZeLUvMH2hvQ/lFP/iI
	 uQOs+MuLqvLRosA1DccwsBNHw8zJlfTnlNbb450S193Wg29c7JlkX5KNhaxALfqRWU
	 oZuysLeigN5GUoOIT45tWV973qEUR+AXE4Zu5z9XYUFWFVOmt4GSlH91mKDWYBKesn
	 eKZQjq7Z3dso39uQuZmuaUPL/Gv6ONeNDxhHdxPuxKscgOANt6/R2hnbgaErI6/8N+
	 yAdWjZppvgFyQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 65F6617E0097;
	Tue, 30 Sep 2025 12:30:08 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:30:03 +0200
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
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Message-ID: <20250930123003.75370854@fedora>
In-Reply-To: <20250929200316.18417-3-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-3-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D9D7B160013
X-Stat-Signature: ne4yp7gdcegbyndnns131yneigcht367
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759228211-52554
X-HE-Meta: U2FsdGVkX18XlrE+EKSiNdkUU9CusqibJWYgRh2g8Y4wW6osV6DDXTLa27G96/YoM3X/p/Po8qluKJjFfm580aOYDYX1KzUjjMzwc0I2tIL0diiXNXLt7g3A6YH/nQlHCIcX/Qgw/+WbL01gsMgKTX8VGBHJcnxl4IeVjHOuBzKPN3EUr5O7Zw4ZeZJnLVqI4i02ZYqbbQvM1xXNX+/M7r6H7G0NRUVDMf6IE6JQ3fLTszxKvz3U2Krm4S4xGMg+vSyQivYjKB/iW45dfTNTa+wa1wM3yCFjIm4SpPvseEro2Up3Mie0hCHVVSEv7/r2JMFwTzpMJXiiKyzohB/1980BUT/UCdM307zZShVrk6ibIcD4eanql7UFnUJr2+o1q7Oaqo6LhXB7xgKXIeZ75xexwkW55yyoW37gDUgLHHYR2KHxMuR/MxNSlBOz5zvIlOCIDSB/NQGXjOYb7GPe720nQE6TsekGhC7X3NPvCqTBQ3P4xrMJuvqMZWBvOLuDPhPHGWpOPQFzGg5KuCZHdEw+hKNOnZIPNkWTc5PDSk1eQNo67SHmlEGLKHMrfCutlcNAnL/eWpUe3stscB3V93EjtSLU5ScMbsFpvaPQ7foKwG6AhW3BPLtrx1YR4tvQ25lVwSzRLJiVg+OjS46g3H5mSSok8muQ1lD/zicyN1vghx6rTBQqxc4vaov1xA00uTiJvN/qlWuYU0bAxN/pReCo8oNQog/kXIr9/KGTE+ILRfY8K4Kihz51ImngzuOP2mfCTetb0kuyX/K5NBoayRnnsmIWzddqgrbVLPqyxPdhIM7kZ+hwfbfsE+EN21RRCqH0xpGfpbeIB17iUEipyVmMrTfonbnxJZcepXy61ocsXT6Apf4fLK61ogXM21vvNEy/3Nh3OVSIpQ00AGjpmkFo3YQOzWYdC4M+SmVScutQI0EeMic5GMqWxYiwasV9SJSOnIk5x1WM9ckkxZO
 Jw4e8Ymm
 Fl7HK5ry9hqYKgAQa2ZWAmScht4RFjJPN86C9DwwI09LxT6j6b7mO7YnxyetENTVyyFzv4GgXswkm6H+JSPU9MFMKc8oBzpCcx9oDgSGnsp7hNJFO5PtEBl8EMqJXKg6FzZnUzZdaaYfwF7B20k86VEabdIvaOyeKNJ4lso2SekWH1LmdU6DhRjFymClu6TnkfGK357B/O6ffaDbiAySy/EsBSyIRZ7cEGs5AAsB9SNPWtH+Id5IU8oWNj7hywj6F3T52v1Kj1fQDvtEBibZKBiOh/rdw1chEA6wZbn/vcJtk5+g8treX5EiFbCGkVLB9lS1w3V7O5rcWWhTdcWEiYpqioSqDGvy9KxusLr7u3oJ9Qhcpinigeq6KQ1dHgbO0kH8UI7S+ACj3imrK047DZHvvb4B3VH0xs+DLZcGnqkIdh+WwMHRvdcFEs+ywRC1z63+i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 22:03:10 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> mmap() calls on the drm file pointer currently always end up using
> mm_get_unmapped_area() to get a free mapping region. On builds with
> CONFIG_TRANSPARENT_HUGEPAGE enabled, this isn't ideal for GEM objects
> backed by shmem buffers on mount points setting the 'huge=3D' option
> because it can't correctly figure out the potentially huge address
> alignment required.
>=20
> This commit introduces the drm_gem_get_unmapped_area() function which
> is meant to be used as a get_unmapped_area file operation on the drm
> file pointer to lookup GEM objects based on their fake offsets and get
> a properly aligned region by calling shmem_get_unmapped_area() with
> the right file pointer. If a GEM object isn't available at the given
> offset or if the caller isn't granted access to it, the function falls
> back to mm_get_unmapped_area().
>=20
> This also makes drm_gem_get_unmapped_area() part of the default GEM
> file operations so that all the drm drivers can benefit from more
> efficient mappings thanks to the huge page fault handler introduced in
> previous commit 'drm/shmem-helper: Add huge page fault handler'.
>=20
> The shmem_get_unmapped_area() function needs to be exported so that
> it can be used from the drm subsystem.
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/drm_gem.c | 110 ++++++++++++++++++++++++++++++--------
>  include/drm/drm_gem.h     |   4 ++
>  mm/shmem.c                |   1 +
>  3 files changed, 93 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index cbeb76b2124f..d027db462c2d 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -1187,36 +1187,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, =
unsigned long obj_size,
>  }
>  EXPORT_SYMBOL(drm_gem_mmap_obj);
> =20
> -/**
> - * drm_gem_mmap - memory map routine for GEM objects
> - * @filp: DRM file pointer
> - * @vma: VMA for the area to be mapped
> - *
> - * If a driver supports GEM object mapping, mmap calls on the DRM file
> - * descriptor will end up here.
> - *
> - * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> - * contain the fake offset we created when the GTT map ioctl was called =
on
> - * the object) and map it with a call to drm_gem_mmap_obj().
> - *
> - * If the caller is not granted access to the buffer object, the mmap wi=
ll fail
> - * with EACCES. Please see the vma manager for more information.
> +/*
> + * Look up a GEM object in offset space based on the exact start address=
. The
> + * caller must be granted access to the object. Returns a GEM object on =
success
> + * or a negative error code on failure. The returned GEM object needs to=
 be
> + * released with drm_gem_object_put().
>   */
> -int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
> +static struct drm_gem_object *
> +drm_gem_object_lookup_from_offset(struct file *filp, unsigned long start,
> +				  unsigned long pages)
>  {
>  	struct drm_file *priv =3D filp->private_data;
>  	struct drm_device *dev =3D priv->minor->dev;
>  	struct drm_gem_object *obj =3D NULL;
>  	struct drm_vma_offset_node *node;
> -	int ret;
> =20
>  	if (drm_dev_is_unplugged(dev))
> -		return -ENODEV;
> +		return ERR_PTR(-ENODEV);
> =20
>  	drm_vma_offset_lock_lookup(dev->vma_offset_manager);
>  	node =3D drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
> -						  vma->vm_pgoff,
> -						  vma_pages(vma));
> +						  start, pages);
>  	if (likely(node)) {
>  		obj =3D container_of(node, struct drm_gem_object, vma_node);
>  		/*
> @@ -1235,14 +1226,89 @@ int drm_gem_mmap(struct file *filp, struct vm_are=
a_struct *vma)
>  	drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
> =20
>  	if (!obj)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
> =20
>  	if (!drm_vma_node_is_allowed(node, priv)) {
>  		drm_gem_object_put(obj);
> -		return -EACCES;
> +		return ERR_PTR(-EACCES);
>  	}
> =20
> -	ret =3D drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT,
> +	return obj;
> +}
> +
> +/**
> + * drm_gem_get_unmapped_area - get memory mapping region routine for GEM=
 objects
> + * @filp: DRM file pointer
> + * @uaddr: User address hint
> + * @len: Mapping length
> + * @pgoff: Offset (in pages)
> + * @flags: Mapping flags
> + *
> + * If a driver supports GEM object mapping, before ending up in drm_gem_=
mmap(),
> + * mmap calls on the DRM file descriptor will first try to find a free l=
inear
> + * address space large enough for a mapping. Since GEM objects are backe=
d by
> + * shmem buffers, this should preferably be handled by the shmem virtual=
 memory
> + * filesystem which can appropriately align addresses to huge page sizes=
 when
> + * needed.
> + *
> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> + * contain the fake offset we created) and call shmem_get_unmapped_area(=
) with
> + * the right file pointer.
> + *
> + * If a GEM object is not available at the given offset or if the caller=
 is not
> + * granted access to it, fall back to mm_get_unmapped_area().
> + */
> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long=
 uaddr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	struct drm_gem_object *obj;
> +	unsigned long ret;
> +
> +	obj =3D drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIF=
T);
> +	if (IS_ERR(obj))

Is this supposed to happen? If not, I'd be tempted to add a
WARN_ON_ONCE().

> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
> +					    flags);
> +
> +	ret =3D shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
> +
> +	drm_gem_object_put(obj);
> +
> +	return ret;
> +#else
> +	return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags);

Looks like the above code covers the non-THP case too, do we really need
to specialize for !CONFIG_TRANSPARENT_HUGEPAGE here?

> +#endif
> +}
> +EXPORT_SYMBOL(drm_gem_get_unmapped_area);
> +
> +/**
> + * drm_gem_mmap - memory map routine for GEM objects
> + * @filp: DRM file pointer
> + * @vma: VMA for the area to be mapped
> + *
> + * If a driver supports GEM object mapping, mmap calls on the DRM file
> + * descriptor will end up here.
> + *
> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> + * contain the fake offset we created) and map it with a call to
> + * drm_gem_mmap_obj().
> + *
> + * If the caller is not granted access to the buffer object, the mmap wi=
ll fail
> + * with EACCES. Please see the vma manager for more information.
> + */
> +int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct drm_gem_object *obj;
> +	int ret;
> +
> +	obj =3D drm_gem_object_lookup_from_offset(filp, vma->vm_pgoff,
> +						vma_pages(vma));
> +	if (IS_ERR(obj))
> +		return PTR_ERR(obj);
> +
> +	ret =3D drm_gem_mmap_obj(obj,
> +			       drm_vma_node_size(&obj->vma_node) << PAGE_SHIFT,
>  			       vma);
> =20
>  	drm_gem_object_put(obj);
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 8d48d2af2649..7c8bd67d087c 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -469,6 +469,7 @@ struct drm_gem_object {
>  	.poll		=3D drm_poll,\
>  	.read		=3D drm_read,\
>  	.llseek		=3D noop_llseek,\
> +	.get_unmapped_area	=3D drm_gem_get_unmapped_area,\
>  	.mmap		=3D drm_gem_mmap, \
>  	.fop_flags	=3D FOP_UNSIGNED_OFFSET
> =20
> @@ -506,6 +507,9 @@ void drm_gem_vm_close(struct vm_area_struct *vma);
>  int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>  		     struct vm_area_struct *vma);
>  int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long=
 uaddr,
> +					unsigned long len, unsigned long pgoff,
> +					unsigned long flags);
> =20
>  /**
>   * drm_gem_object_get - acquire a GEM buffer object reference
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e2c76a30802b..b2f41b430daa 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2915,6 +2915,7 @@ unsigned long shmem_get_unmapped_area(struct file *=
file,
>  		return addr;
>  	return inflated_addr;
>  }
> +EXPORT_SYMBOL_GPL(shmem_get_unmapped_area);
> =20
>  #ifdef CONFIG_NUMA
>  static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy=
 *mpol)


