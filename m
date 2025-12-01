Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2797D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492B36B0011; Mon,  1 Dec 2025 03:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443086B0024; Mon,  1 Dec 2025 03:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3323F6B0029; Mon,  1 Dec 2025 03:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 226F66B0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:37:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B0E813BF9E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:37:18 +0000 (UTC)
X-FDA: 84170247756.13.8F8966F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5864918000F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:37:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=mmeU+Izl;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFlOTL7kOMuh6Q7xjMVMXiyeBznkxk27tb39NXeQrMQ=;
	b=3BlP7DwannRuMQKxei95tvV2OyJ7UDwqxVX/VPfJOXCJRrKfTjBkwp4IBpumuOrdQHGoTl
	5P1tYItSMkZWqCwJjYsOCwfEE/PXy/kwF3gPSJInS17BnQWdA/qWas9tLiicTQrJycNv6J
	7k05Gf8BKCjmNYqz8fgqqCBgARVhBZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578236; a=rsa-sha256;
	cv=none;
	b=T0XUocWwBrsJRglkqSEmaM8a1rkuRqyTv/o9MnIrh5clFfHlVB7OPfWVFXceB2zL3Rk6ND
	GgPWbOcyjBGlIhJtAIWI8IsczLidIr9NEME9cowGjUPkLLF3ptzrLsArnl25Doj3QLO43L
	XEKzeof/Tn4BIwew3J8lBX0jQzzDDWo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=mmeU+Izl;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764578234;
	bh=dKHEIGMARN2ZgD6GrhVSLQoZUL6QHxg/W4EDae754sg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mmeU+Izl8dBKX8C5mjcCEI0w3BHU01XnHGSNoKTeE9sijji+rHIFKReQCLO4+sjCu
	 vd98y8c9tMult/K/TnqjaCT4REWe+1PH6po35efZ0p+KHjfxthh1LiblaVxNeAp7Zy
	 xd2kut55dFKut4EWh+nQBFJcyozvI36thqgqWP7psspliFTZtBoa5R0hvK3Mx3wthr
	 kDi/1X4sUvu0bjFMbzQnx1xj8MKEqhUl6kZ8T0akMPdHtiwqoML/EDBRZTazaTcfDE
	 IwEuqAD3tlOFeWyyNds/KpLhu3+c+Mv37CRJUHZ+D4gl88KCGnIS+pliRlXujwLaam
	 KIRxyMOl658mA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E4DF417E0EB8;
	Mon,  1 Dec 2025 09:37:12 +0100 (CET)
Date: Mon, 1 Dec 2025 09:37:07 +0100
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
Subject: Re: [PATCH v10 06/10] drm/v3d: Use huge tmpfs mountpoint helpers
Message-ID: <20251201093707.751e3ab0@fedora>
In-Reply-To: <20251128185252.3092-7-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-7-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5864918000F
X-Stat-Signature: pii3534yhdrs9fwwfjkx1m1pd645akyu
X-HE-Tag: 1764578236-445349
X-HE-Meta: U2FsdGVkX19RDmSyueqy+JrjR79sAQdxE54knLoLDA/qEGjVEb5wikndxN9VswGWMHfyo7m4LMtIjT3ltgGgADBNKFGA0LgsKkFUF4ter/owkAnujJAmw1+Z+cE3oGF1wKQxvBQT1kxbV4OZW/oRbG33NIQITIGpt1xxI6rxZZC5EwBC4Sy6eg7C/ZBy84OxUKvczjeG2BgBjVvSzFSYzSdiwp0CNdddyuIanO7OIm3EsbqR45rEANerTwUKOCKDik6l+xeLUjXg1sWzEeeTHsdLv8ModnlQ+6k+FqXeZTKzyxaBdz0OjURIb+p5o3a4nwCKGG8HlybijRmmOZr6areLTxZ3VzwWKsV4RrpnxfCQcoE7LOU5SL9X9Ynj+hJIBAmS/6Kxvmz7oJwcLLY9OCK8DqUwV3cmxpo5hYxZFHpowMVsP5CIbKNf4aJeMDyarGNz1AuFS57p8BMttqfk4i073bDwnNo66J+K37BJQiNAJP+93HQq7rIg4oMGrxzP+imQ6O5E4/8E6n/QygdpTp5B35qP2rqdvRLERU93BdDxynn7WKijJL5jJKKD1Am9jTdPm4jKnttwNC2RUK+0uXkp0a7Grs2DJGPkBSoql3FQ8ON7OReE92tyqJFLWwlEXBlW994b8jNU60svBdgW1Yxp0Tsfa9VutNAyyTNHoQ2k2DGnC8vBXDcfZXNFSw+9hG5bELfKqdfh8TFtU8kEfiOsFXz+jlTpstj4sUB4gibd5XV/8+s4E4z9u6xi+rVwomKir0osrDxrb8b2+qgH+8JSGX8ok76t4jzOM2240+wcyiGDt9Udf0pKvXnzYX1RWgDPvR65mxfKZHQdBrwuU54+vocrBQUywPeRqcxGaCnE23yOH35opQaoTKpn1Rr70WlDbkg6A2/QfSXUZ5VoUn9ZmoN9do/B/QEFG4thagVqVhN8apFsQraOG98JRALY3kt6YdJXeH5LrRe7+4p
 9Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:48 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Make use of the new drm_gem_huge_mnt_create() and
> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
> it's just a few lines long, the single function in v3d_gemfs.c is
> moved into v3d_gem.c.
>=20
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move v3d_gemfs.c into v3d_gem.c
>=20
> v4:
> - clean up mountpoint creation error handling
>=20
> v5:
> - fix CONFIG_TRANSPARENT_HUGEPAGE check
> - use drm_gem_has_huge_mnt() helper
>=20
> v8:
> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
>=20
> v9:
> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
>=20
> v10:
> - get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

I'm not a v3d maintainer, but this looks okay to me.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Melissa, Maira, any chance you could have a quick look at that one?

> ---
>  drivers/gpu/drm/v3d/Makefile    |  3 +-
>  drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
>  drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>  drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>  drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>  drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>  6 files changed, 30 insertions(+), 80 deletions(-)
>  delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
>=20
> diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
> index fcf710926057..b7d673f1153b 100644
> --- a/drivers/gpu/drm/v3d/Makefile
> +++ b/drivers/gpu/drm/v3d/Makefile
> @@ -13,8 +13,7 @@ v3d-y :=3D \
>  	v3d_trace_points.o \
>  	v3d_sched.o \
>  	v3d_sysfs.o \
> -	v3d_submit.o \
> -	v3d_gemfs.o
> +	v3d_submit.o
> =20
>  v3d-$(CONFIG_DEBUG_FS) +=3D v3d_debugfs.o
> =20
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index d9547f5117b9..3ee8d9c36d92 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>  	if (IS_ERR(sgt))
>  		return PTR_ERR(sgt);
> =20
> -	if (!v3d->gemfs)
> +	if (!drm_gem_get_huge_mnt(obj->dev))
>  		align =3D SZ_4K;
>  	else if (obj->size >=3D SZ_1M)
>  		align =3D SZ_1M;
> @@ -150,12 +150,11 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev=
, struct drm_file *file_priv,
>  			     size_t unaligned_size)
>  {
>  	struct drm_gem_shmem_object *shmem_obj;
> -	struct v3d_dev *v3d =3D to_v3d_dev(dev);
>  	struct v3d_bo *bo;
>  	int ret;
> =20
>  	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  v3d->gemfs);
> +						  drm_gem_get_huge_mnt(dev));
>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  	bo =3D to_v3d_bo(&shmem_obj->base);
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
> index e8a46c8bad8a..8faa9382846f 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.c
> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
> @@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev=
, void *data,
>  		args->value =3D v3d->perfmon_info.max_counters;
>  		return 0;
>  	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
> -		args->value =3D !!v3d->gemfs;
> +		args->value =3D !!drm_gem_get_huge_mnt(dev);
>  		return 0;
>  	case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
>  		mutex_lock(&v3d->reset_lock);
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
> index 1884686985b8..99a39329bb85 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> @@ -158,11 +158,6 @@ struct v3d_dev {
>  	struct drm_mm mm;
>  	spinlock_t mm_lock;
> =20
> -	/*
> -	 * tmpfs instance used for shmem backed objects
> -	 */
> -	struct vfsmount *gemfs;
> -
>  	struct work_struct overflow_mem_work;
> =20
>  	struct v3d_queue_state queue[V3D_MAX_QUEUES];
> @@ -569,6 +564,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
>  struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q=
);
> =20
>  /* v3d_gem.c */
> +extern bool super_pages;
>  int v3d_gem_init(struct drm_device *dev);
>  void v3d_gem_destroy(struct drm_device *dev);
>  void v3d_reset_sms(struct v3d_dev *v3d);
> @@ -576,11 +572,6 @@ void v3d_reset(struct v3d_dev *v3d);
>  void v3d_invalidate_caches(struct v3d_dev *v3d);
>  void v3d_clean_caches(struct v3d_dev *v3d);
> =20
> -/* v3d_gemfs.c */
> -extern bool super_pages;
> -void v3d_gemfs_init(struct v3d_dev *v3d);
> -void v3d_gemfs_fini(struct v3d_dev *v3d);
> -
>  /* v3d_submit.c */
>  void v3d_job_cleanup(struct v3d_job *job);
>  void v3d_job_put(struct v3d_job *job);
> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
> index 5a180dc6c452..62532a89dd14 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
>  	v3d_invalidate_slices(v3d, 0);
>  }
> =20
> +static void
> +v3d_huge_mnt_init(struct v3d_dev *v3d)
> +{
> +	int err =3D 0;
> +
> +	/*
> +	 * By using a huge shmemfs mountpoint when the user wants to
> +	 * enable Super Pages, we can pass in mount flags that better
> +	 * match our usecase.
> +	 */
> +
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> +		err =3D drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> +
> +	if (drm_gem_get_huge_mnt(&v3d->drm))
> +		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> +	else if (err)
> +		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
> +			 err);
> +	else
> +		drm_notice(&v3d->drm,
> +			   "Transparent Hugepage support is recommended for optimal performan=
ce on this platform!\n");
> +}
> +
>  int
>  v3d_gem_init(struct drm_device *dev)
>  {
> @@ -310,7 +334,7 @@ v3d_gem_init(struct drm_device *dev)
>  	v3d_init_hw_state(v3d);
>  	v3d_mmu_set_page_table(v3d);
> =20
> -	v3d_gemfs_init(v3d);
> +	v3d_huge_mnt_init(v3d);
> =20
>  	ret =3D v3d_sched_init(v3d);
>  	if (ret) {
> @@ -330,7 +354,6 @@ v3d_gem_destroy(struct drm_device *dev)
>  	enum v3d_queue q;
> =20
>  	v3d_sched_fini(v3d);
> -	v3d_gemfs_fini(v3d);
> =20
>  	/* Waiting for jobs to finish would need to be done before
>  	 * unregistering V3D.
> diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_ge=
mfs.c
> deleted file mode 100644
> index bf351fc0d488..000000000000
> --- a/drivers/gpu/drm/v3d/v3d_gemfs.c
> +++ /dev/null
> @@ -1,62 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0+
> -/* Copyright (C) 2024 Raspberry Pi */
> -
> -#include <linux/fs.h>
> -#include <linux/mount.h>
> -#include <linux/fs_context.h>
> -
> -#include <drm/drm_print.h>
> -
> -#include "v3d_drv.h"
> -
> -void v3d_gemfs_init(struct v3d_dev *v3d)
> -{
> -	struct file_system_type *type;
> -	struct fs_context *fc;
> -	struct vfsmount *gemfs;
> -	int ret;
> -
> -	/*
> -	 * By creating our own shmemfs mountpoint, we can pass in
> -	 * mount flags that better match our usecase. However, we
> -	 * only do so on platforms which benefit from it.
> -	 */
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		goto err;
> -
> -	/* The user doesn't want to enable Super Pages */
> -	if (!super_pages)
> -		goto err;
> -
> -	type =3D get_fs_type("tmpfs");
> -	if (!type)
> -		goto err;
> -
> -	fc =3D fs_context_for_mount(type, SB_KERNMOUNT);
> -	if (IS_ERR(fc))
> -		goto err;
> -	ret =3D vfs_parse_fs_string(fc, "source", "tmpfs");
> -	if (!ret)
> -		ret =3D vfs_parse_fs_string(fc, "huge", "within_size");
> -	if (!ret)
> -		gemfs =3D fc_mount_longterm(fc);
> -	put_fs_context(fc);
> -	if (ret)
> -		goto err;
> -
> -	v3d->gemfs =3D gemfs;
> -	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> -
> -	return;
> -
> -err:
> -	v3d->gemfs =3D NULL;
> -	drm_notice(&v3d->drm,
> -		   "Transparent Hugepage support is recommended for optimal performanc=
e on this platform!\n");
> -}
> -
> -void v3d_gemfs_fini(struct v3d_dev *v3d)
> -{
> -	if (v3d->gemfs)
> -		kern_unmount(v3d->gemfs);
> -}


