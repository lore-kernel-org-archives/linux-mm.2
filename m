Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63613D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB296B0023; Mon,  1 Dec 2025 03:33:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B206B0024; Mon,  1 Dec 2025 03:33:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969B06B0026; Mon,  1 Dec 2025 03:33:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80C796B0023
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:33:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D211314099F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:33:13 +0000 (UTC)
X-FDA: 84170237466.15.9D4C7F8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19C612000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:33:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fZwY+kyH;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764577992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w936J3P/KRlPfqAa4ngdWAXFKqKMsgAhbQMBPVbcwDI=;
	b=V567jN6TJ+ulLfRc/TPKwfJVPRBf2gZrC63Lxh9QGADeB5bwYdqrtQKvWSgNlnChyVkc0L
	k4UoZYpbMlD1Azte25DjwTJZyj/2OgGDup2birxPn/vi0dfHxi/hb/oGOTheL2xmmjWUll
	AYrclMVnavfGDH1GD1rJ76VH5qc9kGg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fZwY+kyH;
	spf=pass (imf13.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764577992; a=rsa-sha256;
	cv=none;
	b=c7oKPyBGxIMReW96wdlZ0n1liOEV9d4aJ36NpFoh5TV04GvZ8xcudKckgaS9jvBFSc5VBH
	Clwqfik9/2jgwnpLO0/IuHA6E7cWDIINovTnwHRrqznA2gKm4z6ysx2HMZT0xGldQN+07C
	QgSmlI4CITn2zSm3G1PlgmZAYnHHev0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764577989;
	bh=pgrla+kOLUZuYPxkxoqIl/yW0sY52XI2jx8uCzVwCGk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fZwY+kyHLAczG5Oq2R3cX3+aj+PyLKchUzKWs7WpA17sGgEX0Jx4eOgJSKcpLIlSc
	 d+efAkKKTPevsbP26dutitPeCqXUmJYWownPdzPvEWywIT92G1+v30vihPqo1JV2HA
	 3Z1mM5ZJ60PW6h8mM5qG5pcmGFKa7A3lLN565cGm9f3V+TT0zXwbf8a7oBVHJvx1Dy
	 J7REiBJ6Qz2NOhDg4oMlie9MhxWS3f7XXFl3XSs3Tvcni36GujuX8p+N+8A6mozPG5
	 4/e+16fIozFmjWby8Fc3HuuyeAou9KW0VGhLynR+/1Ajyrf7cFTRGyu5CoK5ShqqaU
	 T0M5zO9ZZ3ZRQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5568A17E04D6;
	Mon,  1 Dec 2025 09:33:08 +0100 (CET)
Date: Mon, 1 Dec 2025 09:33:04 +0100
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
Subject: Re: [PATCH v10 03/10] drm/gem: Introduce
 drm_gem_get_unmapped_area() fop
Message-ID: <20251201093304.285e929f@fedora>
In-Reply-To: <20251128185252.3092-4-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-4-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7jurhbwrcewxa1ys8dam31gwhd39pgso
X-Rspam-User: 
X-Rspamd-Queue-Id: 19C612000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764577991-433459
X-HE-Meta: U2FsdGVkX1/JF0ZtAich3PxEj4zsuXm6XHzcei+Olin8cMoRTTt3G4yHOXeb8BXTlv/5vjRM1FfhadwfwWpR0uRW0HgTvF1xE7CYpUlxRFEP56H6N0+OobmbPca1by3oBamfzmMqbSfH1tjLAzClpbvXFiB9GlnFUqs+GBnuihNDQZuIrUCf2MXooYXkI/gAm1BAUvDXEakh0mLjfr+rxP+u2FmvYhv/i1wkupOZrIYJ//bzs4fT65lRiPf/3uiDneNywQf8Dy3pS+IrEbGpJtGjf8AlXLtpznkmUToAInYnblQS3/s9nnhGVqk0yWemMs17GBSs6k8oYFEYlm0dIs0zytw2nmxHV1738uwDTNNa5W3QA/SwT+sOnDJW5xngOlu8hCMiG5IEpDLwuOtyG+/sAMkD/H2nyHVrwEaeQ9ol/X9aNziv7sWIDWwUmqv+Ou+IGCx15oZWnLIC/px0n/ehMYZ6+O2wVRlN7R0/JnyxbxnHl9ByWOIhJnV66mtlnWunTOaEh3Kk5I56w2U7UKoGMnD3FpqMD8xv8I6VVEmpWgyuWwN2f60dxJm5IVDdX4phnGQwJfDCwD5RDJkHEYuWM7/ZKdltgI0YGBZFhbjrw5a6rBABo2f9nFBZkgtIXAw7xJws2d17w+Ib4W2RVN6+ZqAfKHZLQMScT9MkuOGYi3VLR+bWWX9aNE7npM9L6XkPe/GFv86fBSkamPBs3qGYBfzAI9O+PjEtjbpEymvxKI1WToEbyKw/IyzT8sPeJ7mtt5ddcr/RkMvlYYyOFruHz2ZbRvuuaocvkgnd929nPw4Kd45VpQKBxIaCZlr4Yg/1pOoHsizboCqBbdN0vZcXTiNcO7u0DZK9klLjbsHm6cYEADP2ZFAHLDAbHfGiQGMwP6dzdh87XJ60iyDij1weBWuMVwoFKt8twLKPJ//NzUAKYFY05LFqmFlH5ppYPv1r49QEiR5OkfImGlM
 cNW9gYxB
 gPdIt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:45 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> mmap() calls on the DRM file pointer currently always end up using
> mm_get_unmapped_area() to get a free mapping region. On builds with
> CONFIG_TRANSPARENT_HUGEPAGE enabled, this isn't ideal for GEM objects
> backed by shmem buffers on mountpoints setting the 'huge=3D' option
> because it can't correctly figure out the potentially huge address
> alignment required.
>=20
> This commit introduces the drm_gem_get_unmapped_area() function which
> is meant to be used as a get_unmapped_area file operation on the DRM
> file pointer to lookup GEM objects based on their fake offsets and get
> a properly aligned region by calling shmem_get_unmapped_area() with
> the right file pointer. If a GEM object isn't available at the given
> offset or if the caller isn't granted access to it, the function falls
> back to mm_get_unmapped_area().
>=20
> This also makes drm_gem_get_unmapped_area() part of the default GEM
> file operations so that all the DRM drivers can benefit from more
> efficient mappings thanks to the huge page fault handler introduced in
> previous commit 'drm/shmem-helper: Add huge page fault handler'.
>=20
> The shmem_get_unmapped_area() function needs to be exported so that
> it can be used from the DRM subsystem.
>=20
> v3:
> - include <linux/sched/mm.h> in drm_gem.c
> - forward to shmem layer in builds with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
>=20
> v6:
> - use GPL variant to export drm_gem_get_unmapped_area()
> - don't export shmem_get_unmapped_area() anymore (use f_op instead)
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Renaming suggestion below (feel free to ignore).

> ---
>  drivers/gpu/drm/drm_gem.c | 108 ++++++++++++++++++++++++++++++--------
>  include/drm/drm_gem.h     |   4 ++
>  2 files changed, 90 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index efc79bbf3c73..41d344c270a7 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -36,6 +36,7 @@
>  #include <linux/module.h>
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
> +#include <linux/sched/mm.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
>  #include <linux/string_helpers.h>
> @@ -1177,36 +1178,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, =
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

nit: I'd name that one drm_gem_object_at_offset().

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
> @@ -1225,14 +1217,86 @@ int drm_gem_mmap(struct file *filp, struct vm_are=
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
> +	struct drm_gem_object *obj;
> +	unsigned long ret;
> +
> +	obj =3D drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIF=
T);
> +	if (IS_ERR(obj) || !obj->filp || !obj->filp->f_op->get_unmapped_area)
> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
> +					    flags);
> +
> +	ret =3D obj->filp->f_op->get_unmapped_area(obj->filp, uaddr, len, 0,
> +						 flags);
> +
> +	drm_gem_object_put(obj);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(drm_gem_get_unmapped_area);
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


