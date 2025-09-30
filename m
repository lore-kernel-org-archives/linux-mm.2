Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC8BCCA471
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C318E001C; Tue, 30 Sep 2025 06:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CCC8E0002; Tue, 30 Sep 2025 06:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBDE8E001C; Tue, 30 Sep 2025 06:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6C0E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:34:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6796DBAD8A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:34:26 +0000 (UTC)
X-FDA: 83945557332.22.C0C580D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id B572D180005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:34:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NIKKplQL;
	spf=pass (imf16.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759228465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbY/LJgi/hkVStIZE+oMFPVvfQL9H1+gJ2FKaunRqJA=;
	b=xcREu9JUVKnuH2Zg+u+EgQ+A4ArZOXrTPfGcnwdjSP3Qv9NPVwOKzAlW/lbwlvU8gU5tNg
	pYWhKI0nA0zRfbcge7oJhfnuH92DBFYFjrG0edX9emLyghEVTd2k+Eg4VC46Dw+E9awKK+
	7fPJeVsugYzgTaBxpBLvlw8Dw0FDkxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759228465; a=rsa-sha256;
	cv=none;
	b=jXDfb4P6wc2xnPb8PqOFPK9e9JKU6Qi/2QK/2Q6OkGJZNzaSvU6w73phccfSN1XnURGxUn
	H8uUFF7RNoeKyGqLTb4/Kyl9B6SnLTblntG+njEN6vpgtLaYyx62YwHXx985XAahWRACNc
	1oqxj/sXP5xr4IthA+NjN+9O79Bn/iU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NIKKplQL;
	spf=pass (imf16.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759228462;
	bh=7l2J/Ru7XvxJ3xkwlTwrWLNh1heBv5EFllRq1Vc61vM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NIKKplQLtlhIDKIqdg847poxEl5ErwN4Lfi5J5LLGSuX6iR6FQGnBrwrPmmTydwpV
	 fntcgMxtBmraxKo226PQ2TkYwcrMVGQe193/Aaiaw8pKM3+rByPVmEB1FBmheX2BKE
	 966aCCa8PTgzNTiRH7n90OfHSkE6Vcjoi9bgnSQSSUkA46f5VkL6r1z6BQfYVlkrmY
	 aBLfRByF/oHIpGiPFoQ9i496dJdBIxFy9a1k/SHml+1+QiAtfZgYMIJv1S+L+3OlOp
	 L1BMfgsx8+AQbxn+Lb6XlWlIPKKhPBy0ZBsp3QCp3Dai6tPRZCQbmk2tG2JSSyBLV0
	 jN9VhZ3Y68EIQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 020E517E10F3;
	Tue, 30 Sep 2025 12:34:20 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:34:16 +0200
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
Subject: Re: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point
 option
Message-ID: <20250930123416.4ff59b11@fedora>
In-Reply-To: <20250929200316.18417-7-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-7-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3a1kwd3qojmu8spusrd8dzaegnw8sqr4
X-Rspam-User: 
X-Rspamd-Queue-Id: B572D180005
X-Rspamd-Server: rspam10
X-HE-Tag: 1759228464-686956
X-HE-Meta: U2FsdGVkX1+1BbXJwt3AnFi+tr0Qg79h84w/Hf+3D5IQfVbFWVJ6AU+P1gk6sgsoeABHz3n8OoNMQ5n4NXrXFTC3LsmPptPMf9w3qXQyAHhLiHAiePNvLo9ELdstTms9KLxZHT0hbUD50+/81+Opau5clwizOl6IpKzdCS6l7Ly+LGrPKlxXjVOyegLaJbysumahc/LXdwj2QFEVb27fNv43/e1TH/TxJPiGpoh2Km8vo3hHf7LM9qBI2oA98jFIoPppygEMcmSdOWOcmyh6kTP59SnQxc8Pf2WCU+BblHXL7Wkz/0xsJoszhmGW/hvWsiRXRgy5tby/Yy1vU1vmM1ZvPh/zJ3mNY9AFLe7RqcnAxidcgR987pO/9t+teFHVqzVqWcHEA8E5uoXO6WL94/CvNZE5Hi0Afl2rzJZDPmivm+GcT8w8BZtMMLvnnwsjq01Pi/Ey7fpZxoGMdJHBBis6dPse+NVng56c/6Eq5IDDqzOc0iLChmynwt7Pl3By7IvTm7jr04asBo5nZ+4aG5Jf2+bSGrIEPD6fznZOgQWrRLSE7kmO+cj9a/Io32decgSpp7nZNGV79weQa5zTEDuI12Eowc+JeIWHCjmva7xtSwdKla00vhtsGmfemKgiG5g0hsTAvbgB29iDlSJL5gdKRTYlGCbXGPLYr4hI4ldOH+WolfiJzazITlzze0w6LnOWsBKNwkNMdWYgwTd/WzjPvlcg8AHDKfpScH/PZEJYy6EMTYBDzuX1SYou/87nimwvZ9GvNejYq+xV00CVXVk+P6M1FHGGh7ZtzfrSSdQWOUdSayzPLGdNLwAa0mPdFiDP1Deu7cAQwveGIPudeMkmlOOTiSrP07j+idL8FUT8Z1U/FCsFlTNeUOQe4GrtlnjGij6mF9GA5J4tI6R8tepwwC2TAosnbNcIwjmPneJHgCmTfGfLr0kRZSmPPwNT+C1wqCGxc7y+RiP/DZc
 QZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 22:03:14 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Introduce the 'panthor.transparent_hugepage' boolean module parameter
> (false by default). When the parameter is set to true, a new tmpfs
> mount point is created and mounted using the 'huge=3Dwithin_size'
> option. It's then used at GEM object creation instead of the default
> 'shm_mnt' mount point in order to enable Transparent Hugepage (THP)
> for the object (without having to rely on a system wide parameter).
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/panthor/panthor_device.c |  4 ++++
>  drivers/gpu/drm/panthor/panthor_device.h |  3 +++
>  drivers/gpu/drm/panthor/panthor_drv.c    |  7 ++++++
>  drivers/gpu/drm/panthor/panthor_drv.h    | 11 +++++++++
>  drivers/gpu/drm/panthor/panthor_gem.c    | 30 +++++++++++++++++++++++-
>  drivers/gpu/drm/panthor/panthor_gem.h    |  3 +++
>  6 files changed, 57 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
>=20
> diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/p=
anthor/panthor_device.c
> index 81df49880bd8..4f254b574287 100644
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
> @@ -98,6 +99,7 @@ void panthor_device_unplug(struct panthor_device *ptdev)
>  	/* Now, try to cleanly shutdown the GPU before the device resources
>  	 * get reclaimed.
>  	 */
> +	panthor_gem_fini(ptdev);
>  	panthor_sched_unplug(ptdev);
>  	panthor_fw_unplug(ptdev);
>  	panthor_mmu_unplug(ptdev);
> @@ -269,6 +271,8 @@ int panthor_device_init(struct panthor_device *ptdev)
>  	if (ret)
>  		goto err_unplug_fw;
> =20
> +	panthor_gem_init(ptdev);
> +
>  	/* ~3 frames */
>  	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
>  	pm_runtime_use_autosuspend(ptdev->base.dev);
> diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/drm/p=
anthor/panthor_device.h
> index 4fc7cf2aeed5..54ca61567426 100644
> --- a/drivers/gpu/drm/panthor/panthor_device.h
> +++ b/drivers/gpu/drm/panthor/panthor_device.h
> @@ -135,6 +135,9 @@ struct panthor_device {
>  	/** @devfreq: Device frequency scaling management data. */
>  	struct panthor_devfreq *devfreq;
> =20
> +	/** @huge_mnt: tmpfs mount point with Transparent Hugepage enabled. */
> +	struct vfsmount *huge_mnt;

Now that we have a helper to create a huge mountpoint, wouldn't it
make sense to have this field in drm_device instead of having each
driver add a huge_mnt field to their <driver>_device object.

> +
>  	/** @unplug: Device unplug related fields. */
>  	struct {
>  		/** @lock: Lock used to serialize unplug operations. */
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
> index 156c7a0b62a2..16916e0b6d89 100644
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
> @@ -11,10 +12,35 @@
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
> +	struct vfsmount *huge_mnt;
> +
> +	if (!panthor_transparent_hugepage)
> +		return;
> +
> +	huge_mnt =3D drm_gem_shmem_huge_mnt_create("within_size");
> +	if (IS_ERR(huge_mnt)) {
> +		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%ld)\n",
> +			 PTR_ERR(huge_mnt));
> +		return;
> +	}
> +
> +	ptdev->huge_mnt =3D huge_mnt;
> +
> +	drm_info(&ptdev->base, "Using Transparent Hugepage\n");
> +}
> +
> +void panthor_gem_fini(struct panthor_device *ptdev)
> +{
> +	drm_gem_shmem_huge_mnt_free(ptdev->huge_mnt);
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
>  {
> @@ -270,10 +296,12 @@ panthor_gem_create_with_handle(struct drm_file *fil=
e,
>  			       u64 *size, u32 flags, u32 *handle)
>  {
>  	int ret;
> +	struct panthor_device *ptdev =3D
> +		container_of(ddev, struct panthor_device, base);
>  	struct drm_gem_shmem_object *shmem;
>  	struct panthor_gem_object *bo;
> =20
> -	shmem =3D drm_gem_shmem_create(ddev, *size);
> +	shmem =3D drm_gem_shmem_create_with_mnt(ddev, *size, ptdev->huge_mnt);
>  	if (IS_ERR(shmem))
>  		return PTR_ERR(shmem);
> =20
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/pant=
hor/panthor_gem.h
> index 80c6e24112d0..6804b3912cc2 100644
> --- a/drivers/gpu/drm/panthor/panthor_gem.h
> +++ b/drivers/gpu/drm/panthor/panthor_gem.h
> @@ -136,6 +136,9 @@ struct panthor_gem_object *to_panthor_bo(struct drm_g=
em_object *obj)
>  	return container_of(to_drm_gem_shmem_obj(obj), struct panthor_gem_objec=
t, base);
>  }
> =20
> +void panthor_gem_init(struct panthor_device *ptdev);
> +void panthor_gem_fini(struct panthor_device *ptdev);
> +
>  struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev=
, size_t size);
> =20
>  int


