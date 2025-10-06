Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DD2CCA472
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA4A8E0009; Mon,  6 Oct 2025 03:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2228E0002; Mon,  6 Oct 2025 03:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0ECC8E0009; Mon,  6 Oct 2025 03:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D087D8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:29:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E68311A390
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:29:08 +0000 (UTC)
X-FDA: 83966863176.21.6EA2928
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id A0F358000E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:29:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=O5eXUFUl;
	spf=pass (imf30.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759735746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qN0eZ2Q9LK9MBQEd/pY5m5PDqt0CxEtGwjQNzkVaqQw=;
	b=JMi6sNpCTUIFCZH1kvuWn9iV6ZLfxGEDyirQcXTK080Z5phIVUtFc+Wnvzu/7zOsnaA/Qd
	qPJXwUIDmME122w/AQ5+X1nLW6mmNOlbH7IeEYhvQMqonkbND+AWCXH3UArzYnpv6mIYqu
	DHTzmYtuY3lOOz/ozxBjNCuzoExNIr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759735746; a=rsa-sha256;
	cv=none;
	b=1tALe8rjnv9UOUCfGzpBJK3FvJMbZ0QkXEsHyAIMvAABq93kSZWw5bdr0v4pOlrjKMcBHh
	cwlZ5bwL0AAZIvTbRtv9bDVI+kpykwxRuJZPPjbn1K8iifEhf2gngkU2TtH2cYXDo8kOYW
	Ufs4ySPK/mho55v6dh0iSxIjUB/odUQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=O5eXUFUl;
	spf=pass (imf30.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759735743;
	bh=7u6njRZi53HEITWpF/3FhQ3+p0lf8NCaxmZY8Xmxj9s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O5eXUFUleMPqO2Ywy4QyrepgQ1KXJnTMFgAnOtA2JgnHjiC9rOkobKGtXh1fIiZk1
	 9iw6ttXCAKNR6fDiJMmBRrZec/leiNBm0+L32JHGUhrf+BEu572h7ic5/5sJvCR1QP
	 PubgMyV6lIMWcQ2WXG8a+GOdLL4YnOdoBKc+HHD7K7fEWADWi2SPP5w57eW6AtWED3
	 rH6UsYNvBuwN4i4sopayRMDgS0TE0mkA9RwVRcYLyWzs+FJvOF7RHydS+9uYU43Qzk
	 ze+ydH43V6poYejVi07Aobzbscrmul43S/P0V03gThahbOC3LMJGNCDxazhonl2Hxr
	 /a01UTmomtx7Q==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BE80C17E0B83;
	Mon,  6 Oct 2025 09:29:02 +0200 (CEST)
Date: Mon, 6 Oct 2025 09:28:56 +0200
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
 Christopher Healy <healych@amazon.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH v3 07/10] drm/panthor: Introduce huge tmpfs mount point
 option
Message-ID: <20251006092856.02fbfd9e@fedora>
In-Reply-To: <20251004093054.21388-8-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
	<20251004093054.21388-8-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0F358000E
X-Stat-Signature: zboq67bmq5ouzkotwrbqq8jaodn78x74
X-Rspam-User: 
X-HE-Tag: 1759735746-772247
X-HE-Meta: U2FsdGVkX19/IlLZebqkQQjjPFX/tZ6oJBnWbaxdYOjB51vaqHWF4sKOVrH7rqlf42onW0IkXXK6pn+ibSkfZaKIkaaTP25aPqaUIQ+8svCsyB1kCwc0B9IVjW6NIHJFA2KguIeNbrtxniFn7gBFkfRvUlOr4kERvDp7NTH7iE73EOWVSKsnf49HaznlL0ZIOHT/oKba9+MYOHhizRgJ4ZMn1IYF2W4KZP5qYnWj598r89RPfpPPxOu+EmCIEKYO/LTUkdpovwYu5eXeIvfma9UfN0KQR2QxSOrS5tLwlyuRG86pRpLYAPW0ypv7gvPrs3qdeHXe041nbvxN8LdtW4clqR6VOPG6EqvMCzSAyJcrbyymf8YHDcucD9v2sJRuS0aHxSUGii9AWg5XC4gdfHBfGlxDi+6t9kiVNo3fC68n/Baq58sgKMKMUKOcB5UCn7KA2GHMIlas2Iq2o42Ii58wGc0hJM/kpxbvZeNDR/2HiOqrViPtHPwXKxKCsGdwhSV5hKah6ewUEYSgHE4XQKeCRKb9kErRBsaiiIJ1pM4blhNpYnXBGlF4KUW48nIMC6Enloi9lu02IunpLmlE4X+GjSLCiS2G4sE9TFoEus830pVIqhJ+a0tdZPqWuLqO2pWohH7qFyCUqsyqTSezGb/o4xZNH6iW1y6TDznL2FdQKBY6SPWqQsJZOabZJ0osRb4I4cMIG7oFfJXClADh/ar+Im0467vEKtve48zvIua1/xdeyqiebMyuRnKXycQZAuixVgbiORcapcPzsexcJhaJ2O0FZmzY/xSHrkwyqpcYMidIa+uyN3GeQlpxCQFprdI6cYi6WJC977Qoky6bUlkD92j6zNjtOro7VvVc/XCNmXCLCae/o+UiFKAlH6d1N6p0f5ZZc6mItRhvbFlTkPi4S2lL+dWLuKSoh65i7LvHVHxC1q60YKmFd7yUGuEiNwOOonkXMirT8lU7Imp
 NK+Em/wI
 shh2WA0lHhiD9s86GHJcc01qyTg3tSIRJ9OBFZWWEAd+X1JcR1Oytlmk6/M4RriRR59nfOci0odvGxc1CZfjxFrGwXbY5AQusie+/dKlOLzmGWPF37woRyDke2OTU7XQVNwWEjKHz8/rBAIiqJWzhdfRU058t1/DyuOJu3sdvKZ6PBZqHtW8s3hDcHHIixYPAO3+A1wZGSUXgqZl3nesXMfTLuyGsHCcXGoadtnab4TjukkjuSfeGeEFIFqkSLm1cU8mktC9hdCJ7wdJC4rww7WQKIDLL3BIdEfKR+SzbQTaCyrM20MxFd63rItuhGnphl6sFRyjdElz9Wwva68VeWcAFubiieSgSsh83eQEF6QryMGSlXSZbjHkBLUcPmTM0+Iz9hNbzSnFmdANJQ7GD+h6aZ2supIthUHDk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Oct 2025 11:30:50 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Introduce the 'panthor.transparent_hugepage' boolean module parameter
> (false by default). When the parameter is set to true, a new tmpfs
> mount point is created and mounted using the 'huge=3Dwithin_size'
> option. It's then used at GEM object creation instead of the default
> 'shm_mnt' mount point in order to enable Transparent Hugepage (THP)
> for the object (without having to rely on a system wide parameter).
>=20
> v3:
> - use huge tmpfs mountpoint in drm_device
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/panthor/panthor_device.c |  3 +++
>  drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
>  drivers/gpu/drm/panthor/panthor_drv.h    | 11 +++++++++++
>  drivers/gpu/drm/panthor/panthor_gem.c    | 19 +++++++++++++++++++
>  drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
>  5 files changed, 42 insertions(+)
>  create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
>=20
> diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/p=
anthor/panthor_device.c
> index 81df49880bd8..3c0387156bb9 100644
> --- a/drivers/gpu/drm/panthor/panthor_device.c
> +++ b/drivers/gpu/drm/panthor/panthor_device.c
> @@ -17,6 +17,7 @@
>  #include "panthor_devfreq.h"
>  #include "panthor_device.h"
>  #include "panthor_fw.h"
> +#include "panthor_gem.h"
>  #include "panthor_gpu.h"
>  #include "panthor_hw.h"
>  #include "panthor_mmu.h"
> @@ -269,6 +270,8 @@ int panthor_device_init(struct panthor_device *ptdev)
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
> index fdbe89ef7f43..a2be3b904ca2 100644
> --- a/drivers/gpu/drm/panthor/panthor_drv.c
> +++ b/drivers/gpu/drm/panthor/panthor_drv.c
> @@ -1556,6 +1556,7 @@ static const struct file_operations panthor_drm_dri=
ver_fops =3D {
>  	.read =3D drm_read,
>  	.llseek =3D noop_llseek,
>  	.mmap =3D panthor_mmap,
> +	.get_unmapped_area =3D drm_gem_get_unmapped_area,
>  	.show_fdinfo =3D drm_show_fdinfo,
>  	.fop_flags =3D FOP_UNSIGNED_OFFSET,
>  };
> @@ -1623,6 +1624,12 @@ static const struct drm_driver panthor_drm_driver =
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

nit: I'd go for a slightly shorter name, like [panthor_]enable_thp.

The patch is

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

regardless.

> +#endif
> +
>  static int panthor_probe(struct platform_device *pdev)
>  {
>  	struct panthor_device *ptdev;
> diff --git a/drivers/gpu/drm/panthor/panthor_drv.h b/drivers/gpu/drm/pant=
hor/panthor_drv.h
> new file mode 100644
> index 000000000000..27fe9b6f77bd
> --- /dev/null
> +++ b/drivers/gpu/drm/panthor/panthor_drv.h
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0 or MIT
> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
> +
> +#ifndef __PANTHOR_DRV_H__
> +#define __PANTHOR_DRV_H__
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +extern bool panthor_transparent_hugepage;
> +#endif
> +
> +#endif
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/pant=
hor/panthor_gem.c
> index 156c7a0b62a2..49b7d288bfdf 100644
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
> @@ -11,10 +12,28 @@
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
> +	if (!panthor_transparent_hugepage)
> +		return;
> +
> +	err =3D drm_gem_huge_mnt_create(&ptdev->base, "within_size");
> +	if (err && err !=3D -EEXIST) {
> +		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
> +			 -err);
> +		return;
> +	}
> +
> +	drm_info(&ptdev->base, "Using Transparent Hugepage\n");
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


