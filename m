Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A062D116F9
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3265D6B0012; Mon,  1 Dec 2025 03:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDF86B002D; Mon,  1 Dec 2025 03:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B9C6B002E; Mon,  1 Dec 2025 03:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 114606B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:47:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD4A5BBE49
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:47:31 +0000 (UTC)
X-FDA: 84170273502.03.95AC5C8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id DDEE514001A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:47:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=P+rbz0D0;
	spf=pass (imf26.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qMDKSwobwp0gueR87tjduNpaaTF5UOTE4NzxdRt7uw=;
	b=33KKVQloC70MsCHPgTIQsdRfVgOrWDmn8MOxLOye6A+kQZg5FXAvoCWZkPI9NWuXphuOna
	O1caHVjyH/dDknN6dGDreA9ycy737f72BK3o1wGJEZhBrDPxDg95g1leXVUrsUXgEqfriU
	yJl/1pNgBVzoOVqQTpvXLLk69ki5PVk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=P+rbz0D0;
	spf=pass (imf26.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578850; a=rsa-sha256;
	cv=none;
	b=T3iBk6EBH01Xy/huYTkMRQIrH9HvBCNecbLXgwyFdyc3loOALlNM2dLxUw0+66b+/oo9Hx
	ryR+1Syb5mzJBp0PqZ/DR9to6+O5mo62WXplG6WnpjE1Btf1fY/bXPcR1kiw3cHRH1cR2L
	Bt0l97C+b2KQ1vztqEw6dS27BauqqAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764578847;
	bh=kCd2RoLHIKSGnTYHHhQCfrIODg8yida9mwlOxzq6AzU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P+rbz0D0Vl2Wk5t3Fpiq/s5CAqaBFu2e23HkTAI45xU8RBmdb1N8hntNks7Ah3bRO
	 KoEgbcP8rd2dzn3Hw+kBEBBnVp9WjTwolUyxMyJNekfAbwxxmrZ852hxw3D06xqWwe
	 Qk3boA6lSxqrTitZqBlu8R/dKS27RaR138IwolvQdm785PHTJcF3RlyUKvTyE/Inu3
	 Gr1l01ZcFaIfN17VUozoRuil+RpiA6lKlfeRfuI538axj2u9eCu4r71FEHzJ82we47
	 0rfe/5gbRCOMCUTlMr4pbownGyeI7RYr2XvzqCkF1/YO1x1m3hAhdYaLs8hhuVUxD1
	 6ir5SEg7HAqJA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B43B517E06C3;
	Mon,  1 Dec 2025 09:47:26 +0100 (CET)
Date: Mon, 1 Dec 2025 09:47:20 +0100
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
Subject: Re: [PATCH v10 09/10] drm/panfrost: Introduce huge tmpfs mountpoint
 option
Message-ID: <20251201094720.692e18e2@fedora>
In-Reply-To: <20251128185252.3092-10-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-10-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DDEE514001A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5zfrganau53sn5yjfjf7k9q7zcec3w4z
X-HE-Tag: 1764578849-822511
X-HE-Meta: U2FsdGVkX19MjQgPCHF24mk8NHY7nJqm/vbOW3ohLc2MupfQTBu30jCytYC/5VQnonLUSaar3sbqk8s2Pkfb4p8FdLC16Nc1JeqqqJYO07BgTx4GruZrf8tvehozGMj84hYqbP5E1puEC1pAM0rhawkXn8SkHd8MfRyBohjJSFf2wBVEsCGLaQnlIM/qsGIVXE/r9FjobQPdvtd3p9+54RMDXrvmAGNsJj3A5/u/nb8WbPJT1uyAtJKX6D5fB515u75aqnuhYHYpMUzpF1BbcffzzznxIVOozLLidtn3XNIn6RDa5+CU0IxXM/Di0mFb2WsL47JgA4acNmxmlv5V9sBCKp79Cru5jCqBITm9AXUNmeiG/xNdahO2u/Kjv1eHDcdM57tALtC3n9FIUu/LRPTAEVnC1BFv0Rbj8ahv7oZdEywaIDbzU9uvRVSXVfVedMQ6EkJmhCFkung6Wc+iZG94h31DWI0GhqE/oe/gXkIh+t+xAyajsSLqEKUJbpS+O0q59zsZ2UIY2nUINoECcK5qlkh33/Kqm9M74CDYDGZ10cB8hSZ6TqthwIHCdLx8/ipq2cz/cm+EMxIehPzRA91tg5LvxvMmMdKOA0eFg+OKgApqCXqFGD6SVGGSCvOgnLaO0ZFh8zxVjMi5m3PdfTcVw7R6/b/Ptp9/eb4VI7+R6T+GYGrJcOSgrU50Z9ToUt8HTi8JvnqeE02xBqfguZo7RYqSev/T49eGN4amMmmc5YPqx3/ReNAQVlExos2JtvfaZKGK6F5KCGWmBKScv3UEoZRbofd8yJAzma07UYmXHDS6dK7bKVBpQEd8CTYNo3XWXYZPumSsiMI1tDJ3GrdTNu9NAmQqAgNp5Xj190/WHpGDlW8ai/RRLmLMcs3VeodB26OvWnoqLJM+AVa/Jhx69sG6t//l8pP03uClusrT3A9BB6K11MkGvEoBzRyAdwnv792anPZAXY10dx4
 5oRJp4NP
 FhEyW51PGa52PSEsjthVbpnJpDH+Co2oniREv/lOy2OevSjia1MuRfg3DNs1lTvqWl9SnsGx2Afh/1HtxMoVlqXqWsh8sWJYYLzoGDBDGBcfgvvKqqL0qYklubvbdQG7orsraW4d3ZmbYoI1Yevci3mw0gV6jvIWlCy+iN3ZMHe/D48krIk/bY/ARwMDUNOq3ndfskmWbBKCvZy0rNIAax8LnJp0iXY84awoBLclS4rrwlQ3uXSNEqX5HSmHvKXNUJNb8ZaNB9LUAwBUQDtBKySFX9GTzWKNKFnwpkmAT049IUnv2vMT31fqAnSTjDIc7NY1REvmxKpWSXd2qJNfNnrR/eUn0b/hDFwOwAKqmM3YTVQqRR1zseiPNmkmg6fm20C4Se8F+mlhcUWNtpWboL6SJcGhzMHpziBBf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:51 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Introduce the 'panfrost.transparent_hugepage' boolean module parameter
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
>  drivers/gpu/drm/panfrost/panfrost_device.c |  3 +++
>  drivers/gpu/drm/panfrost/panfrost_drv.c    |  6 ++++++
>  drivers/gpu/drm/panfrost/panfrost_drv.h    |  9 +++++++++
>  drivers/gpu/drm/panfrost/panfrost_gem.c    | 18 ++++++++++++++++++
>  drivers/gpu/drm/panfrost/panfrost_gem.h    |  2 ++
>  5 files changed, 38 insertions(+)
>  create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
>=20
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm=
/panfrost/panfrost_device.c
> index c61b97af120c..dedc13e56631 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.c
> @@ -12,6 +12,7 @@
>  #include "panfrost_device.h"
>  #include "panfrost_devfreq.h"
>  #include "panfrost_features.h"
> +#include "panfrost_gem.h"
>  #include "panfrost_issues.h"
>  #include "panfrost_gpu.h"
>  #include "panfrost_job.h"
> @@ -267,6 +268,8 @@ int panfrost_device_init(struct panfrost_device *pfde=
v)
>  	if (err)
>  		goto out_job;
> =20
> +	panfrost_gem_init(pfdev);
> +
>  	return 0;
>  out_job:
>  	panfrost_jm_fini(pfdev);
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/pa=
nfrost/panfrost_drv.c
> index 7d8c7c337606..7f59568faa05 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_drv.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
> @@ -858,6 +858,12 @@ static const struct drm_driver panfrost_drm_driver =
=3D {
>  #endif
>  };
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +bool panfrost_transparent_hugepage;

Same here, if there's no downside to enabling THP support, make it the
default.

> +module_param_named(transparent_hugepage, panfrost_transparent_hugepage, =
bool, 0400);
> +MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount poin=
t with Transparent Hugepage enabled (false =3D default)");
> +#endif
> +
>  static int panfrost_probe(struct platform_device *pdev)
>  {
>  	struct panfrost_device *pfdev;
> diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.h b/drivers/gpu/drm/pa=
nfrost/panfrost_drv.h
> new file mode 100644
> index 000000000000..edeb093eb6da
> --- /dev/null
> +++ b/drivers/gpu/drm/panfrost/panfrost_drv.h
> @@ -0,0 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0 or MIT
> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
> +
> +#ifndef __PANFROST_DRV_H__
> +#define __PANFROST_DRV_H__
> +
> +extern bool panfrost_transparent_hugepage;
> +
> +#endif
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/pa=
nfrost/panfrost_gem.c
> index 8041b65c6609..c1688a542ec2 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
> =20
>  #include <linux/cleanup.h>
>  #include <linux/err.h>
> @@ -10,9 +11,26 @@
>  #include <drm/panfrost_drm.h>
>  #include <drm/drm_print.h>
>  #include "panfrost_device.h"
> +#include "panfrost_drv.h"
>  #include "panfrost_gem.h"
>  #include "panfrost_mmu.h"
> =20
> +void panfrost_gem_init(struct panfrost_device *pfdev)
> +{
> +	int err;
> +
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    !panfrost_transparent_hugepage)
> +		return;
> +
> +	err =3D drm_gem_huge_mnt_create(&pfdev->base, "within_size");
> +	if (drm_gem_get_huge_mnt(&pfdev->base))
> +		drm_info(&pfdev->base, "Using Transparent Hugepage\n");
> +	else if (err)
> +		drm_warn(&pfdev->base, "Can't use Transparent Hugepage (%d)\n",
> +			 err);
> +}
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
>  					struct panfrost_gem_object *bo)
> diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/pa=
nfrost/panfrost_gem.h
> index 8de3e76f2717..1a62529ff06f 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_gem.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
> @@ -124,6 +124,8 @@ drm_mm_node_to_panfrost_mapping(struct drm_mm_node *n=
ode)
>  	return container_of(node, struct panfrost_gem_mapping, mmnode);
>  }
> =20
> +void panfrost_gem_init(struct panfrost_device *pfdev);
> +
>  struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev=
, size_t size);
> =20
>  struct drm_gem_object *


