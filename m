Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D1CCE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B298E003F; Fri, 14 Nov 2025 12:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB7B8E001A; Fri, 14 Nov 2025 12:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D718E003F; Fri, 14 Nov 2025 12:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD08B8E001A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:11:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CD2035DC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:11:54 +0000 (UTC)
X-FDA: 84109854948.01.476C4CB
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 984DE10000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:11:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iO5UYGYr;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qaUHBXt7DsOiN/u7r+4HZ44pXX0xxkNNVuNs7VY5Ow0=;
	b=ZTVjr772NLD00h84PiT/lln8N61zl+9VBiruVq8C/0dW8LPsWp0kCDlHbHcwgbX60hesU4
	Ng8MwjVcUS/Aobd0EjjFe6/yf0QgldjH6S84p6CEMzeNBkZ5bewdCbgZ63IubkkSQR0r+f
	kocOrhYrhEUkXCBCO57ObBHAuX+3qj0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iO5UYGYr;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140313; a=rsa-sha256;
	cv=none;
	b=MCHIBgAi69K1N57R7wAWjZA4lfL36yV+BhRmCyjTfA1s9Ye88oUxS0mCwODQoglGMti16r
	6HK6wCVXFonhgeVffSDPDbjDNOp09/ADL6h3PMRB32Znol+BH+hRe61HYRoO/lH8wXmz9t
	792NIJ57EwSa4Os4vBMbC+57XmP/UGA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763140310;
	bh=WlbXwYIISbc9OIhLL3wAoAgqK0p6o8kpKTuAtUHBtw0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iO5UYGYreCQecXg4Cf7etlTDF+O+an0YK++LVDcKAgJ4mGZnEV6zcqe2ZpNckJyNL
	 bVAHVrKEvGWrvd2zu2ZnxInpBqi8GOkGZkEq7zoFMxsScHD/Bx9x/PEnzfJqra/F9W
	 +cT6OKCbmlnOPSZQI/IMuRRXfSzKVIrJ3wBomNEXCnblZzjFAS/2GevNrLmBDatZUE
	 WBuNyfpg1nV2FRCxk6dZuxFanfvcnEQdMhIKuDhrrvykrUTywnqjID/cm/Xn/GJa82
	 1bOt+WNJh1GXksFSohsIy5WA71wVXhYwe8QLxWUoAs2dCI9boQDhCo+t5mIB/ECm+z
	 zD6ls0I09fXKg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4768617E12D5;
	Fri, 14 Nov 2025 18:11:49 +0100 (CET)
Date: Fri, 14 Nov 2025 18:11:44 +0100
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
Subject: Re: [PATCH v9 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
Message-ID: <20251114181144.51b44c8b@fedora>
In-Reply-To: <20251114170303.2800-7-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
	<20251114170303.2800-7-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 984DE10000F
X-Stat-Signature: 5bnqubdyc6awx8j5tm8oey4aerjrwi3d
X-Rspam-User: 
X-HE-Tag: 1763140312-692940
X-HE-Meta: U2FsdGVkX1/aLgCmKIFP5YPpvSGXI1B9BlV9+YiCD3EsuDgP+xPJOpjnQpg4VFhyqXLeC3mUc+nq310vDUVvNa6/ZIQN5krUJV1HZfmu/wZvFsuR4qo+bgNjGaYywJlKERX+FsIUy1sPxPNRfaWnXoQEOP8bOk2hdZKMw1EYz8qQzLWNO0Cjq7zDuP2Tp08pVyMvIxE26XjHP97BiBN8I/vSuxEhyxyI/slA+e/55FE5zLOX7dlowL7Xp8rg/sj0XXAxHB8wO9kqtk9wTRcsug8k/FRthK70p/aoauSmmOaERLGVSs0NzNUxh/ulqR+Ab0aH0QJ+BSmdGB1eRNMVcPB48bfSN5TZiGirdOp3fiVRt/q6MuhOwXiYpMn+RafurVGicP6SPcB9/85wOvq9x0Z+MVmrB5M2bxpg/EWCGpHHzrAOEwzjA2nV9ZK55sJUZUapSSURcFFsUQU346zt6jswJqpPccN9R4OvfOSqfoZ2Hx7oK5fowldvfggZOXuYXsqIvKR2x+bsRTlU9fVlBALXdMEYqiKko6EIaXhj29KcgvMVxUC8jTEEq+VVh5EUfcJ/4YspKFnR73uSz/DttcIz4GL0MGppJaopvIJg9gRXjf7BvHroGJ6OJx1bz4crIzCd1Ow6dX31UHeGZtljK9JoXqN6iEWRALgY0pe5IEOhJxYLdL0sqUl0R/2in2lV+tqtp9Y4aKnT1z4H+SceddVkQ4doAuQADqpdMXeaqn4s+ukSnUGQKqgaX6oT2x6q/5v7w9KMLnqFwMo+LO3pAF00vExJyX5oB0Xke2N5Krmp0kTtR33BZIoQraH6kNfVBw+NvpPbOQkVaDXJpqVzgPn5qyuffkyKbrYiRFiSspDoSPYm95NgbcNHNZYLEAX54zRcEUMlPJ9nD0cWbLUL8h9mji5C5GlwQJv9gSZL8ja2PvAnuQeLpsny4LTcEsB/TVnabfBidrdSPv8HIS5
 gos1HMVq
 Xws2mL1tPk/epMOzLKFQTPN/dO6J3KsbW+HTYofZEIal8rnJoAkPBCvmOsWh//2PyTwJeUmjqD9/F5ryYS3/RHMEwWb75Rrr80GzF+rbabxtLoZ/qAdp6r8hFUlmHPczBwBBT7qLYmk3S401Gu7pOFM64R3XoynVo8kxgLezqn6v9Z6XiiOM82TmrpiiB54wdHtMFxcmFgBnzC7A5n83zQ41dIjH8n1R5DMj/e/4qLyJiMMLp+xbPhJV7RWrwz5geFvn1gIRho4cv6Ifyux4W0TA8CKZQv8KeCJGmDjH1Q8BdBzfAlSL4Z9VM9o3+C9YOLiSm5HdWHDqW20RvDiYMNwae9xATU3XFStNcdDgWuax8hxh+wqb9zzPHQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 18:02:57 +0100
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
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> ---
>  drivers/gpu/drm/v3d/Makefile    |  3 +-
>  drivers/gpu/drm/v3d/v3d_bo.c    |  9 +++--
>  drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>  drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>  drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>  drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>  6 files changed, 34 insertions(+), 80 deletions(-)
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
> index d9547f5117b9..211578abf9b6 100644
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
> @@ -150,12 +150,15 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev=
, struct drm_file *file_priv,
>  			     size_t unaligned_size)
>  {
>  	struct drm_gem_shmem_object *shmem_obj;
> -	struct v3d_dev *v3d =3D to_v3d_dev(dev);
>  	struct v3d_bo *bo;
>  	int ret;
> =20
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  v3d->gemfs);
> +						  dev->huge_mnt);
> +#else
> +	shmem_obj =3D drm_gem_shmem_create(dev, unaligned_size);
> +#endif

Why not drop the ifdef and go for

	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev,
						  unaligned_size,
						  drm_gem_get_huge_mnt(obj->dev));

?

>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  	bo =3D to_v3d_bo(&shmem_obj->base);

