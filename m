Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09676D116F9
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2869F6B0005; Mon,  1 Dec 2025 03:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E1F6B002B; Mon,  1 Dec 2025 03:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C056B002C; Mon,  1 Dec 2025 03:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4986B0005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:46:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9910C51827
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:46:05 +0000 (UTC)
X-FDA: 84170269890.18.0819237
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7A4DA0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:46:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QRQ92yMr;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6t8qTPTOomrHbv/DVKE7MMtu5+0Acn3nfd4mMd4iW4=;
	b=HGVv0E42sbtN421iXtNUYI4iPPdhj7jB00zOQp6yqq0V08+6qOodD1AyOcxjLes6Km1SkB
	p8QzOv9UIgyrMk8nO9HgSGM7JTKP4od1AgnaFZ3VP9gTbLzX0FM8Wlcdea+3MLZKusT+Xa
	EF/Oa0+aVRUrNWrHHaIUX32VbsQDES0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578764; a=rsa-sha256;
	cv=none;
	b=hUmfNz3Ip9s9YReXZ9sWXl3uUGIe6sHYqQ/X1iwTf0YpI7qeFUAew2rC2NA9pEMgGAWroN
	Z9ibscgsuiL3wj2kzrF5/Gxi73ZIeS0EbCgGvnzc0Dx3Ofh9X6CeNthTfEVsZs4Q1cF3t4
	9Ly1lN9O7XsiNs3ZzAxBitJmUXOTVo8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QRQ92yMr;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764578761;
	bh=OAnS/yXE9nV5UZXIRrvCT7YzkHlT6SyTgUSWEbYw4YU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QRQ92yMr4FxswuS7dMmtS0/G7FNb+cGDfYbWV/1BTYAstPkV1ut/wZRMAMI6QmvPy
	 QeYmqgYEafyKz/1PDHi5w6Rc+hGNF5UfldfSz6m37VlnlAYYxoqA8/a0d3N3xdB4fW
	 cf8Jy0yFMyab4zkWe6d1PIlbbj3Ss5w6YSobXHPq/Z/6qjpkTzMb1bdPLzYDD3Egwt
	 wiDI69uCGF9/PLyv4LWZRJJkkEQA9DVzdmxmRVhHrmOimQnE57ZtQ52tXcI7sf2oPA
	 c2241tHA+vHP/1bv+qagLzq0vZev5wOBExyTLjV3zpPwO7cnd4dn0Cg+Dl/QjjM20b
	 YlbNdkfLEOtmg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 41EAA17E013C;
	Mon,  1 Dec 2025 09:46:00 +0100 (CET)
Date: Mon, 1 Dec 2025 09:45:55 +0100
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
Subject: Re: [PATCH v10 08/10] drm/panthor: Introduce huge tmpfs mountpoint
 option
Message-ID: <20251201094555.595744ab@fedora>
In-Reply-To: <20251128185252.3092-9-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-9-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7A4DA0006
X-Stat-Signature: hxjwcbenng7dnafdbk44nyrrxgjgwu8c
X-HE-Tag: 1764578763-858817
X-HE-Meta: U2FsdGVkX1+ezkKzRFPsUVb3hGBZL3WL2eMrHF9Q9YpmN8VDLnbry4NnzR0CPxrq7lf0NPuTXXagYX96LaC3pokw4mbBSuCz0XL0S5d5O/H9pnjSm2HFYoEzggQCwg5kpw53K4XGjnndUKhe8Gt9OE3yBHxfBnUEJqAN8GmNkhBK2WiupZP/5qgUKez20VGttGySAkH/ioesE1p1vie6748wLaLqPMlnN9VZIQ7fqQG5XB2sq4u/DbhzCTM/cY+bLtOsIcD1PenPqmocdUh1Ndjb7YLZx23mmtgRJeLh734a2ZFHI/WW6Fk8vzaya9MxGZiLftKPz73MEMMsMHzuDrC0ykW6mVL2wZczZFv4Rkc9+ddu+Y/xwYZv/zZpwu6hccRhsxlzgKc2GdyBJ53Cf09bsY+PagELTXTE4mHWLKd6KJoeKt5nD182b6eL4IjNoCeP/n5DHtBHj2NmO8yRoniINbS9D2ABhwREG+zLMZZWKArlsuVgIQ+WnZSZg9oFKDKgde/Q+ZU4VG7UE4EAtwKr+60VTXtm1+iRS/8Nl6Q4U78OlbORtfO8rg1c18Okee8fqs5Lt2iDoGZs8Nqih2bKjaBYCgpf2B9ezbeql930fXxvTGXEt2gi0HzunGX3uiDnaO1GNQNRu/HQ4pVNnjSSnV+cKQh/JVhU1VyClPM9wv3JRVDkZWp0VfA4l5+14yv9QUWR+inMUPTlkV/8vE9AIwitjOpPbpkVha68vUpMxmDut9a6LF27Pk1zM34LrV8V7P8RRk5Yvp41jJ+VZKq0jVWGyBjvQnJ3SldhmpdIUqI0H5gYtTdA6esP07m+6iYjbNr/twlcreDZHCvXTsDvucZbRtPnd/KVEyrZtTZQ96VupWsWiFqhE1T4c2nJa3nLty0L79lGidJuE08ucVtvF36scTj2lgZnPTzSvEHLuWQY0xWReRf7AM1BQR1zVKzXG4oPxnqUCkNa109
 sgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:50 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Introduce the 'panthor.transparent_hugepage' boolean module parameter
> (false by default). When the parameter is set to true, a new tmpfs
> mountpoint is created and mounted using the 'huge=3Dwithin_size'
> option. It's then used at GEM object creation instead of the default
> 'shm_mnt' mountpoint in order to enable Transparent Hugepage (THP) for
> the object (without having to rely on a system wide parameter).
>=20
> v3:
> - use huge tmpfs mountpoint in drm_device
>=20
> v4:
> - fix builds with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
> - clean up mountpoint creation error handling
> - print negative error value
>=20
> v5:
> - use drm_gem_has_huge_tmp() helper
> - get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs
>=20
> v9:
> - replace drm_gem_has_huge_tmp() by drm_gem_get_huge_tmp()
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
>  drivers/gpu/drm/panthor/panthor_device.c |  3 +++
>  drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
>  drivers/gpu/drm/panthor/panthor_drv.h    |  9 +++++++++
>  drivers/gpu/drm/panthor/panthor_gem.c    | 18 ++++++++++++++++++
>  drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
>  5 files changed, 39 insertions(+)
>  create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
>=20
> diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/p=
anthor/panthor_device.c
> index e133b1e0ad6d..2979ee0e52c2 100644
> --- a/drivers/gpu/drm/panthor/panthor_device.c
> +++ b/drivers/gpu/drm/panthor/panthor_device.c
> @@ -18,6 +18,7 @@
>  #include "panthor_devfreq.h"
>  #include "panthor_device.h"
>  #include "panthor_fw.h"
> +#include "panthor_gem.h"
>  #include "panthor_gpu.h"
>  #include "panthor_hw.h"
>  #include "panthor_mmu.h"
> @@ -294,6 +295,8 @@ int panthor_device_init(struct panthor_device *ptdev)
>  	if (ret)
>  		goto err_unplug_fw;
> =20
> +	panthor_gem_init(ptdev);
> +
>  	/* ~3 frames */
>  	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
>  	pm_runtime_use_autosuspend(ptdev->base.dev);
> diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/pant=
hor/panthor_drv.c
> index d1d4c50da5bf..55dbda6dbf9c 100644
> --- a/drivers/gpu/drm/panthor/panthor_drv.c
> +++ b/drivers/gpu/drm/panthor/panthor_drv.c
> @@ -1559,6 +1559,7 @@ static const struct file_operations panthor_drm_dri=
ver_fops =3D {
>  	.read =3D drm_read,
>  	.llseek =3D noop_llseek,
>  	.mmap =3D panthor_mmap,
> +	.get_unmapped_area =3D drm_gem_get_unmapped_area,
>  	.show_fdinfo =3D drm_show_fdinfo,
>  	.fop_flags =3D FOP_UNSIGNED_OFFSET,
>  };
> @@ -1626,6 +1627,12 @@ static const struct drm_driver panthor_drm_driver =
=3D {
>  #endif
>  };
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +bool panthor_transparent_hugepage;
> +module_param_named(transparent_hugepage, panthor_transparent_hugepage, b=
ool, 0400);
> +MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount poin=
t with Transparent Hugepage enabled (false =3D default)");

On a second thought, I wonder if this shouldn't be an opt-out param
(which is what V3D does, BTW). What's the downside of enabling THP if we
have a fallback for cases where memory is too fragmented to get huge
pages at allocation time?

> +#endif
> +
>  static int panthor_probe(struct platform_device *pdev)
>  {
>  	struct panthor_device *ptdev;
> diff --git a/drivers/gpu/drm/panthor/panthor_drv.h b/drivers/gpu/drm/pant=
hor/panthor_drv.h
> new file mode 100644
> index 000000000000..79dccd289881
> --- /dev/null
> +++ b/drivers/gpu/drm/panthor/panthor_drv.h
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0 or MIT
> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
> +
> +#ifndef __PANTHOR_DRV_H__
> +#define __PANTHOR_DRV_H__
> +
> +extern bool panthor_transparent_hugepage;
> +
> +#endif
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/pant=
hor/panthor_gem.c
> index 10d255cccc09..7ae07a9bc996 100644
> --- a/drivers/gpu/drm/panthor/panthor_gem.c
> +++ b/drivers/gpu/drm/panthor/panthor_gem.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0 or MIT
>  /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
>  /* Copyright 2023 Collabora ltd. */
> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
> =20
>  #include <linux/cleanup.h>
>  #include <linux/dma-buf.h>
> @@ -12,10 +13,27 @@
>  #include <drm/panthor_drm.h>
> =20
>  #include "panthor_device.h"
> +#include "panthor_drv.h"
>  #include "panthor_fw.h"
>  #include "panthor_gem.h"
>  #include "panthor_mmu.h"
> =20
> +void panthor_gem_init(struct panthor_device *ptdev)
> +{
> +	int err;
> +
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !panthor_transparent_hugepage)
> +		return;
> +
> +	err =3D drm_gem_huge_mnt_create(&ptdev->base, "within_size");
> +	if (drm_gem_get_huge_mnt(&ptdev->base))
> +		drm_info(&ptdev->base, "Using Transparent Hugepage\n");
> +	else if (err)
> +		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
> +			 err);
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
>  {
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/pant=
hor/panthor_gem.h
> index 80c6e24112d0..2eefe9104e5e 100644
> --- a/drivers/gpu/drm/panthor/panthor_gem.h
> +++ b/drivers/gpu/drm/panthor/panthor_gem.h
> @@ -136,6 +136,8 @@ struct panthor_gem_object *to_panthor_bo(struct drm_g=
em_object *obj)
>  	return container_of(to_drm_gem_shmem_obj(obj), struct panthor_gem_objec=
t, base);
>  }
> =20
> +void panthor_gem_init(struct panthor_device *ptdev);
> +
>  struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev=
, size_t size);
> =20
>  int


