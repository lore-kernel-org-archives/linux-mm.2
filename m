Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D974D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994D76B0026; Mon,  1 Dec 2025 03:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CD46B0027; Mon,  1 Dec 2025 03:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85BCB6B0029; Mon,  1 Dec 2025 03:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 747016B0026
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:34:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2958C51250
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:34:40 +0000 (UTC)
X-FDA: 84170241120.05.8CCEE52
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47FB74000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:34:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M6kHp05m;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNyH9tDAQu3zP74epRw609ciXKaxrUALIfV6RB5j3+w=;
	b=o/yTesjYEtv1k8CtGGLduoPI3xfyGTVqsKQBVQIqHZ8vfENuzNeqLIeQUdp91F0ydQBtos
	7b5T8FFNahgr2DaEvAa1N13o2IeG9uA3B8xi8AnyIPsyqzSL5DhEOh4D8QPfKnnEEzeM69
	P9tjRWgMthwLbWVLMfjtfmJwi2D39dA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M6kHp05m;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578078; a=rsa-sha256;
	cv=none;
	b=N5NvsFNQVleO6mDcerYX0okJAImS4IAirKHwgotlxz0pXlXS+QRgrOpcAlGKKPHSG7rPjb
	3sO/0Lg73QVL+s43k0cWRStYH+2FSFgjrJKw1yTyiQ3c/QDf2gyzTDeY0o0jn4wfZj8eEI
	3G/4+UfYIuUojavf7GnWPpGmXiFA6a0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764578075;
	bh=bDPYc8Ad43GPmGGO8b4zIo3oVR1qxhpi1lVENnkkQ2s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M6kHp05mEYL6ScpntjhktZpUKFnN+zzmyRYbC2wAlsMUkg5hXrAUPFQMUPfk5zrXS
	 iBGx3s8Bj90RtXmpxCQMI4R2cUZqYcLkd6bPAxLSTeiRD+p0S17oemRF4TbcwZXN1j
	 BSFJtcibB00n6e3HLlAztUi+9qaPjXsb94cAKFsOR35tQc5fRA/bTR5Z1xfTu/kah3
	 V8gJw9o+n+BYRz6EFa42dlNpUHpc390/W+Jpjnq10XDaqAfYCq3vi/n7xmfdzN6uoM
	 YIgONcd61f0XOpG/pHcBZ/7BVUh5BGkQaJ70K89+Y90ubAbX0QdUa9V24bjXWxWRyn
	 a0w3d1jomS+fA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8153917E0EB8;
	Mon,  1 Dec 2025 09:34:34 +0100 (CET)
Date: Mon, 1 Dec 2025 09:34:32 +0100
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
Subject: Re: [PATCH v10 04/10] drm/gem: Add huge tmpfs mountpoint helpers
Message-ID: <20251201093432.5cd45ae0@fedora>
In-Reply-To: <20251128185252.3092-5-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-5-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 47FB74000B
X-Rspamd-Server: rspam11
X-Stat-Signature: zrx5aw5zhcij5cfisstksfk5o7acn18y
X-HE-Tag: 1764578077-262499
X-HE-Meta: U2FsdGVkX18mzhbO3Pg78oLo3yyG9vKHy2EKXUWDvyDELJyMsjbM+Cd0dWSgAU/e8lqQkBS9JCV3e1mOubMH2RuXbCX0cu9CwvUaslN+ii6kYTwq5IKYZ8sxlv7gwZYz+r3RI044nPCSpCvxiXbsidjLa4DeboZJx4DHFgzHAGAu8nXCRN2FkZNyZqzp50ip8jpKehK3y13z+IlMF+JreQfFMiwebU7nS8ymvBTGa+J8wsnQ7Lm6N9uyTbrxd6BBvWX3d48sHIYDVjPaJJTTn+vDMJhmZ8NfNRzbAdO0L7g885ov2Cb2aYqXR6F5ry/nNAPM0xsARyE7+wMtoFo1CvJMQCAP8yLveHUtD5HP8P/VjHRFbCSSnWTX2UvZN5a+6fwlfCZARuJ1pRM/hD9OFwyN/Lp9tefJsDmZ8CYex4E3gLWBzwNW+0N4k2MPIVViL25nSM0SegZN1yAFZw8gajrewpKr+LH6EjTi/Y+iXlBQSkKNddd7VZ78IPhiErdISG7yn1no2ZDM3YZR56ZahiXEl99jgKHoOoMcgXUyz7uwzFmJHo8+f4qrLxD3gPmg02ikilOD93jM/tnx7G+WpmAlxtNpU5olEAvuhDxcGW1KHQFb1kjwQiUW0ijF9TUH0Gr67q2/aNUP2Ygr0+CxRO3USnlQkgFzfAk+sShTi/CU7lLF9x//0ZsdJc0YsGyNvLWfQJ+Gt0Ww8Cvrz9DPrCNvNyjy7pBGB/XHPcnwEX2KrSxeGrpxV1fx3/RtBpqkYbBU2pFilZvv6sTCm0OZ/zo8QSimYvBk14cEj7JZWZTlb2q+xbHOF0FlhQ3NcizJCx/Ub8NSobH8cpNO8dPXaq5Rux6dYQRVP2TfGIBpGEcd8V+T7Lwg6iTg88sCKGa/ML84rWWdRWbHuqy07aKyvPhmdnvlUkD6Hu0qaR02kaRBXnG4ISk8/W8w6SMS+iOePvCdk0PrerMVWM5mhlr
 zDcaNkmM
 Wk2Uf5TFp/KTiVgEyFygy257VXoYhDkDutYfwtDesef0k2CODjUx0/L+UtuIouCi1bWdQVZqwo7rChhYxZIaSSZoqZksxaqBFePid375OmopE4jZ5hOgQvICnPnevN4oBAduxow1CnVQkfil+/oKF/gp3+2jrXtRsjWkjhdtBIYTK2qAyI9hUCHUpQnDxmQaVS0Z9+j/f8KeX2jdPJ6ZqT0EyRLRXnYXP+9P9m/zlcwp7FpGD48AZokQzxdp4lZK/pReUpax3oKTyWpI8wAAfpbAG4J/yvBAt3gqf96tjsLNZ9tQD8p7bNpwzrMMwTMe+bGZmrTqCKOL01SVdbJetjB0N0W/wcMpgYtcP4GYtAXL0dMuaMgHjkOBEjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:46 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Add the drm_gem_huge_mnt_create() and drm_gem_get_huge_mnt() helpers
> to avoid code duplication in the i915, V3D, Panfrost and Panthor
> drivers. The former creates and mounts a dedicated huge tmpfs
> mountpoint, for the lifetime of a DRM device, used at GEM object
> initialization. The latter retrieves the dedicated huge tmpfs
> mountpoint used by a DRM device.
>=20
> The next commits will port drivers to these helpers.
>=20
> v3:
> - store huge tmpfs mountpoint in drm_device
>=20
> v4:
> - return 0 in builds with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> - return 0 when huge_mnt already exists
> - use new vfs_parse_fs_string() helper
>=20
> v5:
> - remove warning on !dev->huge_mnt and reset to NULL on free
> - inline drm_gem_huge_mnt_create() to remove func from text and avoid
>   calls in builds with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> - compile out drm_device's huge_mnt field in builds with
>   CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> - add drm_gem_has_huge_mnt() helper
>=20
> v6:
> - move huge_mnt doc into ifdef'd section
> - either inline or export drm_gem_huge_mnt_create()
>=20
> v7:
> - include <drm/drm_device.h> in drm_gem.h
>=20
> v9:
> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem.c | 57 +++++++++++++++++++++++++++++++++++++++
>  include/drm/drm_device.h  | 15 +++++++++++
>  include/drm/drm_gem.h     | 33 +++++++++++++++++++++++
>  3 files changed, 105 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 41d344c270a7..94e5e04865ba 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -29,6 +29,9 @@
>  #include <linux/export.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#include <linux/fs_context.h>
> +#endif
>  #include <linux/iosys-map.h>
>  #include <linux/mem_encrypt.h>
>  #include <linux/mm.h>
> @@ -82,6 +85,60 @@
>   * up at a later date, and as our interface with shmfs for memory alloca=
tion.
>   */
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
> +{
> +	kern_unmount(dev->huge_mnt);
> +}
> +
> +/**
> + * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs mountpoi=
nt
> + * @dev: DRM device a huge tmpfs mountpoint should be used with
> + * @value: huge tmpfs mount option value
> + *
> + * This function creates and mounts a dedicated huge tmpfs mountpoint fo=
r the
> + * lifetime of the DRM device @dev which is used at GEM object initializ=
ation
> + * with drm_gem_object_init().
> + *
> + * The most common option value @value is "within_size" which only alloc=
ates
> + * huge pages if the page will be fully within the GEM object size. "alw=
ays",
> + * "advise" and "never" are supported too but the latter would just crea=
te a
> + * mountpoint similar to the default one (`shm_mnt`). See shmemfs and
> + * Transparent Hugepage for more information.
> + *
> + * Returns:
> + * 0 on success or a negative error code on failure.
> + */
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
> +{
> +	struct file_system_type *type;
> +	struct fs_context *fc;
> +	int ret;
> +
> +	if (unlikely(drm_gem_get_huge_mnt(dev)))
> +		return 0;
> +
> +	type =3D get_fs_type("tmpfs");
> +	if (unlikely(!type))
> +		return -EOPNOTSUPP;
> +	fc =3D fs_context_for_mount(type, SB_KERNMOUNT);
> +	if (IS_ERR(fc))
> +		return PTR_ERR(fc);
> +	ret =3D vfs_parse_fs_string(fc, "source", "tmpfs");
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +	ret =3D vfs_parse_fs_string(fc, "huge", value);
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +
> +	dev->huge_mnt =3D fc_mount_longterm(fc);
> +	put_fs_context(fc);
> +
> +	return drmm_add_action_or_reset(dev, drm_gem_huge_mnt_free, NULL);
> +}
> +EXPORT_SYMBOL_GPL(drm_gem_huge_mnt_create);
> +#endif
> +
>  static void
>  drm_gem_init_release(struct drm_device *dev, void *ptr)
>  {
> diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
> index 5af49c5c3778..7dc560ad14fc 100644
> --- a/include/drm/drm_device.h
> +++ b/include/drm/drm_device.h
> @@ -3,6 +3,9 @@
> =20
>  #include <linux/list.h>
>  #include <linux/kref.h>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#include <linux/mount.h>
> +#endif
>  #include <linux/mutex.h>
>  #include <linux/idr.h>
>  #include <linux/sched.h>
> @@ -168,6 +171,18 @@ struct drm_device {
>  	 */
>  	struct drm_master *master;
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	/**
> +	 * @huge_mnt:
> +	 *
> +	 * Huge tmpfs mountpoint used at GEM object initialization
> +	 * drm_gem_object_init(). Drivers can call drm_gem_huge_mnt_create() to
> +	 * create a huge tmfps mountpoint. The default tmpfs mountpoint
> +	 * (`shm_mnt`) is used if NULL.
> +	 */
> +	struct vfsmount *huge_mnt;
> +#endif
> +
>  	/**
>  	 * @driver_features: per-device driver features
>  	 *
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 7c8bd67d087c..4e9ab5d294ac 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -40,6 +40,9 @@
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +#include <drm/drm_device.h>
> +#endif
>  #include <drm/drm_vma_manager.h>
> =20
>  struct iosys_map;
> @@ -492,6 +495,36 @@ struct drm_gem_object {
>  		DRM_GEM_FOPS,\
>  	}
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
> +#else
> +static inline int drm_gem_huge_mnt_create(struct drm_device *dev,
> +					  const char *value)
> +{
> +	return 0;
> +}
> +#endif
> +
> +/**
> + * drm_gem_get_huge_mnt - Get the huge tmpfs mountpoint used by a DRM de=
vice
> + * @dev: DRM device
> +
> + * This function gets the huge tmpfs mountpoint used by DRM device @dev.=
 A huge
> + * tmpfs mountpoint is used after a successful call to drm_gem_huge_mnt_=
create()
> + * on builds with Transparent Hugepage enabled.
> +
> + * Returns:
> + * The huge tmpfs mountpoint in use, NULL otherwise.
> + */
> +static inline struct vfsmount *drm_gem_get_huge_mnt(struct drm_device *d=
ev)
> +{
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	return dev->huge_mnt;
> +#else
> +	return NULL;
> +#endif
> +}
> +
>  void drm_gem_object_release(struct drm_gem_object *obj);
>  void drm_gem_object_free(struct kref *kref);
>  int drm_gem_object_init(struct drm_device *dev,


