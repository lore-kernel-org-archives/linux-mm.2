Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B34D116F9
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76616B0008; Mon,  1 Dec 2025 03:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E256B0029; Mon,  1 Dec 2025 03:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8B026B002A; Mon,  1 Dec 2025 03:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 960466B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:39:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 672C0515C6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:39:30 +0000 (UTC)
X-FDA: 84170253300.20.45B09FE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7443BC0009
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:39:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aa32VnMR;
	spf=pass (imf22.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764578368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0r/nV+FzyfZbIbNGNHqcFdothQiHPSUlnurKHo0Cx5M=;
	b=cFulfvxCJqdjSawJPe8RHMT1PeiCwOxxvUFV3rmc8yCWFXbiiC0DVNqz4kMWyD6QhSXNcZ
	tGDD24JaI6/S8K2L0dFex7N4XrKXPtAnfZQd/zltjNhk0wq/FiOY2asOCRmRNxMOTmTWI9
	4QQZ1sajY05U/wsCvz0359FTsyRGlsM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aa32VnMR;
	spf=pass (imf22.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764578368; a=rsa-sha256;
	cv=none;
	b=306g8JQz9RALQKh/lclusLGwe5t7sSmjQ/fz0VU/utl/++gVyUKtIuVi5tEg2Q3vPyGCsn
	x5paam6oK7BFXMPwPuRYBPvZQVecZxjuaFa7tFnWJ9goPxoRSuxGgZ4eRvHmVdQiE3qGM9
	9ljfL8TSPiSh+ik46qDgT/aBupQ/cjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764578366;
	bh=/yEJjkl7mI536u4P1ZljdIoiBzn8hkUDB1We2y+0lF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aa32VnMRDGNZstcTn0Yk21gz6Bp3VD/2Qpcw8VGcVMwsqhZW+9ROIvypak8/Cgf4A
	 DZaP3ErEeb3EX7nGUwnjFlL/9Ey9o2SewxmdQefgUnajm2HN51Pj2tch2WlWLjfJvX
	 qTZ25Fxoxo5VsZHGk8ob2ADJylVc+clQoGA7A5LbGJIgcy/QZjyWqAyfG9VIrSsHIX
	 YQwt2GVHQRvWFZ1lT3/n0N7UxTrlMc8B2jLv7BU1QE7kn8mSzpwRG3M88ajMbVhp8R
	 OlYZJxcGlftU8cibXYfrHo5G/V/n/5RiOrGELOyT1jOAYnGsmkURlRxSufF4zQrGHp
	 ELUWueVvAn8RQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3676D17E013C;
	Mon,  1 Dec 2025 09:39:25 +0100 (CET)
Date: Mon, 1 Dec 2025 09:39:18 +0100
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
Subject: Re: [PATCH v10 10/10] Documentation/gpu/drm-mm: Add THP paragraph
 to GEM mapping section
Message-ID: <20251201093918.4051d21d@fedora>
In-Reply-To: <20251128185252.3092-11-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-11-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7443BC0009
X-Rspamd-Server: rspam02
X-Stat-Signature: 57ywz3bicq33frmo975ab55cozee93bh
X-Rspam-User: 
X-HE-Tag: 1764578368-379129
X-HE-Meta: U2FsdGVkX1+MxhACtaZRYpmPbGlY/wBwwXVlZ1enAQrbjq3kzqKBJFPkuL5LZMvep7UPAObIfaPpWTPHqC1vTnhF4c1okm55x5r8cDWrSYpX3V2T4rQutLyOsdIqSHEBAfV/aQAAKrJmowELZ+8h79jsOmHSun2b3jgRocRT+OhAM06KVpT4GoPJ6T3TNPVZHWDbSGbb4GPWTjaq4wfkPQuJbeX8X4D3Zad+hGthz8j0l5JovM8yPkLysjOkqI7tBe9deuNdle7oHmo9NqabqiOEX9xjeA+5TIBZY1l3S/lb9ihpbkfjz//2XFyTgnxkhZDGsfbCV5f7AL5Pwu8djxtr/LpIH2KsBE1+IK/86+usbgg7/TDlAqdaZHIF+BOxxKfzx+jg9TQwJHUIDZBD/abUxLFZtGUzF2MtwksTMWMUwRrSXMoqzAg9TYZaPwXRTXXsyj6xn3JwZs9XY+oS3TwthENCZ/qLcSa0oQyKIjoCptMu0YD5yRIjzNRnBqKzdLB84M0HlcgocA2UJ0RAR7YuLqZqlCZiJsopKM5Dd6QFKPkZ0kfnonoC/IUNQiXkc1DyfVsRH5cV+a/oDUb56fIZC73Va5GinDjJyoRSJyrhP95PtqI2Teu3AqHU/BLCTsZRzlpFt+8seTBw4E6h13CI2b8+DTup4Lce3Iruc9nKo1/dJdN72DuzVy51BtpBSkXQyVNTnqe9yJa003Ila74iGdOXi5pWosifppl02DRV65OA239R2axx+5LxJ4dMmWbdsQH/sbTtHYmLAER0zAR9sVcnNaEsYYB32fEVi+WYxxbvr3k8bi8UJaA7RoR5UiOibLJ9rR9fqf7hFlGiCCjBVzryLlA9+LGJ57vZ3jE81s45PmZkMWCu8+xxG3+s2eEV92tIienSF0Gptr9lS911yI38e8CAhgOeHfdOVh57upW7oMNTrOcqUXsn1I9EIdFII3eQwyk50sNo29K
 D240gGMq
 AAhknUr1OnHYYplBACeF1lBqIZhFcISEanQ+4tSGZQ96lLsM1YEw5kqxUKrRn3kVhiEgPG8gsk1b2LInlV46HI5JsWlTB4n3WTQJgUaHL/8uQL0q0K13yBYPvF9fu0ZG0eBPs8btDzhCGLntfgmJVevtxhKMSjiiVNwhRDlohuuJiRdVomAd9VBC1erZOkJY3uBdkx+oRGmGlZpKUMPvc4PyyrIVVvjXYghmwuVko/8MoFUzXGAiZoXi4OHNF/UjZNWvEF9xxj5vgi+Iu/J2Z0mR/kdbuptCDGEdDWZj5R/apJgutdeTvl9FDRs8RklnHZ8Gdpj1fU0FcsaplD90uUcqCwz+/a0uQSucMSW+qyEy4XcQJYaPtd/V/In/MEOGgbrqNThuHo8VeCAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:52 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Add a paragraph to the GEM objects mapping section explaining how
> transparent huge pages are handled by GEM.
>=20
> v4:
> - fix wording after huge_pages handler removal
>=20
> v6:
> - fix wording after map_pages handler removal
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  Documentation/gpu/drm-mm.rst | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> index d55751cad67c..d69eab0b4093 100644
> --- a/Documentation/gpu/drm-mm.rst
> +++ b/Documentation/gpu/drm-mm.rst
> @@ -290,15 +290,27 @@ The open and close operations must update the GEM o=
bject reference
>  count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() help=
er
>  functions directly as open and close handlers.
> =20
> -The fault operation handler is responsible for mapping individual pages
> -to userspace when a page fault occurs. Depending on the memory
> -allocation scheme, drivers can allocate pages at fault time, or can
> -decide to allocate memory for the GEM object at the time the object is
> -created.
> +The fault operation handler is responsible for mapping pages to
> +userspace when a page fault occurs. Depending on the memory allocation
> +scheme, drivers can allocate pages at fault time, or can decide to
> +allocate memory for the GEM object at the time the object is created.
> =20
>  Drivers that want to map the GEM object upfront instead of handling page
>  faults can implement their own mmap file operation handler.
> =20
> +In order to reduce page table overhead, if the internal shmem mountpoint
> +"shm_mnt" is configured to use transparent huge pages (for builds with
> +CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
> +managed to allocate a huge page for a faulty address, the fault handler
> +will first attempt to insert that huge page into the VMA before falling
> +back to individual page insertion. mmap() user address alignment for GEM
> +objects is handled by providing a custom get_unmapped_area file
> +operation which forwards to the shmem backing store. For most drivers,
> +which don't create a huge mountpoint by default or through a module
> +parameter, transparent huge pages can be enabled by either setting the
> +"transparent_hugepage_shmem" kernel parameter or the
> +"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.
> +
>  For platforms without MMU the GEM core provides a helper method
>  drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to g=
et a
>  proposed address for the mapping.


