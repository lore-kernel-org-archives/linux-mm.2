Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAB3D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A47C6B0005; Mon,  8 Dec 2025 06:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255066B0007; Mon,  8 Dec 2025 06:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16AA46B0008; Mon,  8 Dec 2025 06:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0647F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB2A48B0B3
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:29:50 +0000 (UTC)
X-FDA: 84196084140.20.9A743F8
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id B492640010
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:29:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=SpQNKfWg;
	spf=pass (imf12.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765193389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/W7ciUSS7mJtu01R6f3ip8yDTanTYetdg3Ajls02Vw=;
	b=dsF0k9djxVmATWmEfMAk7DMsurR4CqeBNNcd+Byf25RK1+Y8dyFcm4CthvYYmTxA2dtaIm
	6LsTH6dKCgXCB50bfFA4ikgREMgHw3f8ll59XzkesINfEWG0m/Id68IRMCLZ3L96/eXdKs
	kS6h/zIyOePVn7A0awS/5OOeKDb1I0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765193389; a=rsa-sha256;
	cv=none;
	b=SyX0Zrd+EjiINvdTwIIfCxGRnjWCLUckftaDJaikHvXpWfGghwQ5QzcCfIm+jqY55kB8dJ
	sS/kKZfcoVCuOR3q1Bs1jigxQ2CXjpJ5TOx1truY9JrlgZ5TI47pcfIyvlreqi9YZxHGwt
	UuK9J7ZUVe60v2iYrofUeLoLyCOENZI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=SpQNKfWg;
	spf=pass (imf12.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1765193386;
	bh=yocxDYajSo8I7hKgvmgacDeK5+luRXC0USgZVW1ZBow=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SpQNKfWgcupNyr+v24kkzZORyvuJLtbVY8hTATmtaWYR2XPHVaBf2SI+6MsI3DJ1+
	 CQPhf4EdD4BGGWYdmsMqhjv+c+QoyPb6HcE+po9RcTuVPtzMLcoWDLO0f9ebRtOxAC
	 fFSQch0NKiecEOLiQAjoYvEI1UI+g9yh8ZD2od8Chb37byQjp1HoWjzA3pWQIfnVhE
	 mtj3XSPHPT6+kLJ1EnbRtER2OLxHQCYHdYkDFG6m4Ho7Rgq7lNBgvbo+DkKCXzg76x
	 hNuBM7acxfw1QtCaOYyPJxAso8MZiciizeGFX6FTgSuHAEJHRWa9LBqmcOuDJ0ZPtJ
	 tsBxtqQHZOtvA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DA92217E0CF5;
	Mon,  8 Dec 2025 12:29:44 +0100 (CET)
Date: Mon, 8 Dec 2025 12:29:41 +0100
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
Subject: Re: [PATCH v13 00/10] drm: Reduce page tables overhead with THP
Message-ID: <20251208122941.61bea21d@fedora>
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B492640010
X-Stat-Signature: r77utfaprmgzw66391jgjjdqonqewczm
X-Rspam-User: 
X-HE-Tag: 1765193388-766838
X-HE-Meta: U2FsdGVkX19l+OU4iXj7SpAXA402tbkxE/UB5w/Pjn+J7dVLW0Ybe2ajOD3cLyG698PEv5rR2d/OVaiArBgflSkO5wjwrPBhEB6b7GoZTjt/YNbgsib77tAGzvTNq9n7Ha9KTfE71WVXbGziiRchwWT6FP3W0BOgPCwYU0tACFxpEmOLGncG6LA9p58wtY2xhuE0JK823vMWygL/eF2fr3axDs+ThIN27o08Dev4Ao0s6X40VRE+hSgG4fZEyW3SoPLEPKUED8m4hsnw9ulRQCDmyImvi+qqZ/Vy6u2z6hGvqxrCvAJxhqq/usanGalH0GHiNMIhqyT4WYCSrIQ260/VFJnRdMa8OlE5BTF/7/+Km+rZdgm8V4PC7buX/LUIMwCGWyWw/Spz4wkBr2Z6c+rHZagA8IWwxBHwPqg2xchK3E+ySI+Mkh4FmskRYiusZrO6rJ074Q1+8pHUcDP+YwsGwlp5VWRz8VjmGUCTgU0Imhjs1ta1+mwnSR7tshVOrFIm3PDwDCsQn35VmnkghnE09NNu0wvEVnmzbiJm05aR5Ao6kClPWZOqPdOZtNAX0PEeQWdH/ksIFZY356ULAMjSr09d/2349H0m7eGqt2AY3t67AM2356p/OyZL7K5KrbhU6KMMjrUi2MNJEqceCuLUYg0TQSwM7Ywz2/LVl0a599R6O9FrqCiHI01BuJXv5c6nsJiT1PwSI4jL++0EKyVsTANWB0KmCtW63vBVzfYXq4nk9qzsgbD2hDHZIpKZAhMeqj7qukYZfzvdV669Uj4sH1ZAujv81sZqwecHO651KIXv0Phrsk2/z9Ln33OKMfwBRB64pzyYFyIpbeApJDPi8XrrsGBZoBaE/StEcILr8SWTj0eKf9SXRIB7zACOkKGxvNTewD7e+EK8NjBXjcohBJ9mmNIrssIyh07R0OAsSmLjP+lV1eEmvgRBvh7ztxn7Y3MoETZkj68Ysan
 vyohCuA+
 TaY89f06JEiAzH6eswwkz1oCTctrORH+BxvKuG7XsYwxzseieuFWJEXijXli1U546ixZM9kmsfvXSIUfxmZzXlcRv1WSC/orJ1gCq+0Qb1/kFD15miiYhy5/VNRSM+kS5IjmLPB0t7AnWQG+9XAKqED5+2gKQVlOKNM5Ka/N8gl2R8+l4nBpQHiVLEgn99Y/PQDZAEj5We5x/cCx5n5xaYH4Bkwd8ZpsNOgLj1zWgimv5q56DF8ni3ZCgkwqyhLbjpCTL4/APKSGeDO76hi7YHhtpRlNkw3VxKblpNbPapnafvUT5JdMoiH/vOC455oRsj/XImzW1n0rp1DeP4DElC77f3Z/SXORZAw9js4HR5DLx0/oAFCqIqmClPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Dec 2025 19:22:21 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> This series aims to reduce the page tables overhead of DRM drivers for
> builds with CONFIG_TRANSPARENT_HUGEPAGE enabled and either the sysfs
> knob '/sys/kernel/mm/transparent_hugepage/shmem_enabled' appropriately
> set or drivers using a dedicated huge tmpfs mount point.
>=20
> It starts by checking whether a faulty address in the page fault
> handler is part of a huge page in order to attempt a PMD sized PFN
> insertion into the VMA. It then introduces a dedicated
> get_unmapped_area file operation on the DRM file descriptor for GEM
> objects to get the best virtual address alignment for the underlying
> shmem buffers.
>=20
> The remaining commits propose shmem helpers to create and release huge
> tmpfs mount points and adapt the i915 and V3D drivers. The helpers are
> then used to optionally enable Transparent Hugepage for Panfrost and
> Panthor.
>=20
> For Panthor on a Rock 5B, this series makes the first memcpy() to an
> entire BO object mapped in userspace about twice as fast with
> Transparent Hugepage enabled.
>=20
> Implementing a fault-around handler using the arm64 contiguous page
> hint (contptes) could also greatly help reduce page tables overhead
> for small pages by mapping several contiguous pages around a faulty
> address at once. This will be proposed in another patch series.
>=20
> Lo=C3=AFc Molinari (10):
>   drm/shmem-helper: Simplify page offset calculation in fault handler
>   drm/shmem-helper: Map huge pages in fault handler
>   drm/gem: Introduce drm_gem_get_unmapped_area() fop
>   drm/gem: Add huge tmpfs mountpoint helpers
>   drm/i915: Use huge tmpfs mountpoint helpers
>   drm/v3d: Use huge tmpfs mountpoint helpers
>   drm/gem: Get rid of *_with_mnt helpers
>   drm/panthor: Introduce huge tmpfs mountpoint option
>   drm/panfrost: Introduce huge tmpfs mountpoint option
>   Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

Queued to drm-misc-next.

>=20
>  Documentation/gpu/drm-mm.rst                  |  29 ++-
>  drivers/gpu/drm/drm_gem.c                     | 202 +++++++++++++-----
>  drivers/gpu/drm/drm_gem_shmem_helper.c        |  77 +++----
>  drivers/gpu/drm/i915/Makefile                 |   3 +-
>  .../gpu/drm/i915/gem/i915_gem_object_types.h  |   9 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  58 +++--
>  drivers/gpu/drm/i915/gem/i915_gemfs.c         |  71 ------
>  drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |  15 +-
>  drivers/gpu/drm/i915/i915_drv.h               |   5 -
>  drivers/gpu/drm/panfrost/panfrost_device.c    |   3 +
>  drivers/gpu/drm/panfrost/panfrost_drv.c       |   6 +
>  drivers/gpu/drm/panfrost/panfrost_drv.h       |   9 +
>  drivers/gpu/drm/panfrost/panfrost_gem.c       |  18 ++
>  drivers/gpu/drm/panfrost/panfrost_gem.h       |   2 +
>  drivers/gpu/drm/panthor/panthor_device.c      |   3 +
>  drivers/gpu/drm/panthor/panthor_drv.c         |   7 +
>  drivers/gpu/drm/panthor/panthor_drv.h         |   9 +
>  drivers/gpu/drm/panthor/panthor_gem.c         |  18 ++
>  drivers/gpu/drm/panthor/panthor_gem.h         |   2 +
>  drivers/gpu/drm/v3d/Makefile                  |   3 +-
>  drivers/gpu/drm/v3d/v3d_bo.c                  |   6 +-
>  drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +-
>  drivers/gpu/drm/v3d/v3d_drv.h                 |  11 +-
>  drivers/gpu/drm/v3d/v3d_gem.c                 |  21 +-
>  drivers/gpu/drm/v3d/v3d_gemfs.c               |  62 ------
>  include/drm/drm_device.h                      |  15 ++
>  include/drm/drm_gem.h                         |  40 +++-
>  include/drm/drm_gem_shmem_helper.h            |   3 -
>  29 files changed, 420 insertions(+), 303 deletions(-)
>  delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
>  delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
>  create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
>  create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
>  delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
>=20


