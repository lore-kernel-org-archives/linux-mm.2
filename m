Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F807CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C8A8E0005; Wed, 22 Oct 2025 04:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A254F8E0002; Wed, 22 Oct 2025 04:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A378E0005; Wed, 22 Oct 2025 04:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826F98E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:06:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2907A1607FA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:06:09 +0000 (UTC)
X-FDA: 84025017258.20.22C643A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20F70180008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:06:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OqTfjc8C;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761120367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbRFR+ZpGYYTlsfjXIy1DY+bCq0b0X8hIY6V0bBxrPA=;
	b=5fF3IUznMuRSQlugHW+iw1nE1HjRQb+brzZZ4f6P83m87ZUGGDAPUeuhYt4ofXJ9StvRSW
	BHj/PShVBANjyKZ7x9E3e4T5z0fwUk0/Lar2sWGiEXPsDikHU1Mnv4tZILSStTUgyuy6w1
	sJ6f9mf+zA91V4Ct/5Od2t4AYJwVlaw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OqTfjc8C;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761120367; a=rsa-sha256;
	cv=none;
	b=3dPa4rGC4EYyIj0vz3dZQ9+L+BlBu3gnBEG9c+BaTR/xPKhvZ8HbXkKkhvMdaud0xa6Jh1
	LT5jpJjtWO+l7W1+TJXa3IjGqgQ0AC1miyFE9XLOLsPEAUq1K7IlEb4O05ieOAlj6ZdEtE
	yBJXlji0z8jHG1AIKv5qlQ+fkvk3E1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761120364;
	bh=Vv5HW4hMaQ9k6PZF5xQoMjollRe8szXt8vgnUejMW7Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OqTfjc8CeEZodXvloy6yGK0vCCVA3ZUOYsnD0vEOc6mxtUqJblDcDaqLtizrvul49
	 PqaCN2GxY14WvR3VNgeQ6zH+ZkRWkBdHFATc+T0ISJSIMQstxywXwEhe0f3sau3hIG
	 2s1hgKhwTABfdbTdBWu4g5VySi3p1xg2O3YFMA2bTO4hbIaZP4x1JTuHz0o5J7avAv
	 19F3fOgQTfNDUMFdBhHG99F8iDFH0tjUYUu71nrlziw30LL85XwkNuoNo/cpdUHuFp
	 4h97W1yuKztO1Kr1rsUpThg7hLXqk0irWVaBaETOxDtvitMsoLJE9UkotUICc839pE
	 OXfWXcVlNP8NA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1CE6317E12C4;
	Wed, 22 Oct 2025 10:06:03 +0200 (CEST)
Date: Wed, 22 Oct 2025 10:05:48 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: kernel test robot <lkp@intel.com>
Cc: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Boris Brezillon
 <bbrezillon@kernel.org>, Rob Herring <robh@kernel.org>, Steven Price
 <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen
 <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal <mcanal@igalia.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Christopher Healy <healych@amazon.com>,
 Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
Message-ID: <20251022100548.4dee241e@fedora>
In-Reply-To: <202510221301.wU3TSqMg-lkp@intel.com>
References: <20251021113049.17242-7-loic.molinari@collabora.com>
	<202510221301.wU3TSqMg-lkp@intel.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 20F70180008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: oux5it1yw4mgwtnsmbtu15wb9wmonmjm
X-HE-Tag: 1761120366-591045
X-HE-Meta: U2FsdGVkX1/sABxujsvGPJc/6yb/45wlOGGZ6MtFcN3WhWZtPQpLsjP8xt/oY8oX0q4SybsYExWp5+oi8QZeE06UxM3DSoNr3xble2DZBp7K208e/CXIEYmJ4lNB/ZHnsZYNKtG1kuFZ62+3nzwenmb4rbQHL8x8iAC9VbOgQYRfN2l70k48uzcYqz/MNg4BCUQ9fZPBZ5UUNoXV6MXlp7Jomoa1FHjlsXA5wC8PC+jPxIG5tcukgxSSa1AZ4yX4xUtvExLtV1aoOVqrBYX8RKMAw4GlsE3byrjiqOHw8iXqtuvA5N3IobR0+pLEn3znSSTfsXEfhR7ixd3387WkGsELiz64X/v0Lq1w8qfdPtst+jiwler1GjSuDXS6+AhKFK55eb6Ir7eaPB9XGPQR1mOB2hLzC04pq5RHIhEKl1U8W/43uZm12PK7XDkUd2SQT9BxTfVdLvaXhPTVxWOFdlnkG05YP99WMqDtjJ9ijGevmsUiO1r6xy9fpzwk4i/fG21yxTsnXlUoRS0+P3/zzfo5+AR2Rw3KyQpk8oKUebmApSLFCMUZxQJd6uti+N7fWLr8PZjc0iXqqW8QJo3H+NqQlyhFNtrS4ncqegZj1beW0liisOtKkbz8lciymrHIbdD7RD8z9K5ZKu0Xm8IdFn+WSjov9vN5yxGRxSZ15ub+U8z0V4qtcgR4Qg4Nrybwyh5DjJuQAUBjMh3Ekoa4Xn+mnkFeTjsZjPEo7ZcJpWXFWGeRZOqkb0QwhZqd4gN+9ecASXRoqeN4OMsIGxvPqAx3Xrpk9NddoZCIuAVNTgyE2q59qi/vOAK/Q6+TqV+cYhqDvDVKXXIdELnbcwpdf2HZFCRGW5yFmPGVGzfRWh8FCd/kFLTR592t37lDLzyTQ6nODZD69Ef777u4Imf53zyE04eS/rqKmUKSpzFkb5c9urBaavZNbAr58TCc44jcFKgAWrmsHqLjKeTb+xg
 Ih8QRiCA
 Dr4NSJQc08eiSbCFmXtz7K+vUMa/XHoWhKhR9xq7cpqeEMPRKIgEWiO+OmovHgkgNDmWzMg9dohOSZgqLlzPFN9byJ2Bmdz68uY9nCLs4W7Bx2BEJ1Q+N6uQXs7UphQiGn4rv58aFPZCKugO33pbssv71rAD9lZpCxGdZRXezT8qLALlKwn15YpZ/kYHWLSk5Vf+5uIwOpf2wdw9ZyfSptRc5clu7DiJpaQN0eh+IeqGdNqB/dh1mkFDeFpbRaNYEBO33h/hQUDN13qs7nXWJGulFXdJrnO6j2Bksn3FpTrl7LGsGljEBTSlpO2rfQq6tGnqfWTRhGHU2E0bqWru7e8X5GoNqVhrpkZwa1XZLYIEzhhNcCHHRj/vXFCtnXmYtdppGvsKDAT/FiFVyMDz4T307IOnzIBNPxZSyBLDEo3DUMHLaU5uqOhzOBzipwMAtP9ohrSCT+DulQcCps38QAyipjin8aFXGAQV9p3jfNZ3d/8rgO53XeOHYfZrTOg2mzd8iGZ9N8SQpFPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 11:25:10 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi Lo=C3=AFc,
>=20
> kernel test robot noticed the following build errors:
>=20
> [auto build test ERROR on next-20251021]
> [also build test ERROR on v6.18-rc2]
> [cannot apply to akpm-mm/mm-everything drm-misc/drm-misc-next linus/maste=
r v6.18-rc2 v6.18-rc1 v6.17]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Lo-c-Molinari/drm-=
shmem-helper-Simplify-page-offset-calculation-in-fault-handler/20251021-193=
355
> base:   next-20251021
> patch link:    https://lore.kernel.org/r/20251021113049.17242-7-loic.moli=
nari%40collabora.com
> patch subject: [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpe=
rs
> config: x86_64-randconfig-003-20251022 (https://download.01.org/0day-ci/a=
rchive/20251022/202510221301.wU3TSqMg-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251022/202510221301.wU3TSqMg-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510221301.wU3TSqMg-lkp=
@intel.com/
>=20
> All errors (new ones prefixed by >>):
>=20
>    drivers/gpu/drm/i915/gem/i915_gem_shmem.c: In function '__create_shmem=
':
> >> drivers/gpu/drm/i915/gem/i915_gem_shmem.c:511:59: error: 'struct drm_d=
evice' has no member named 'huge_mnt' =20
>      511 |                 filp =3D shmem_file_setup_with_mnt(i915->drm.h=
uge_mnt, "i915",
>          |                                                           ^
>=20
>=20
> vim +511 drivers/gpu/drm/i915/gem/i915_gem_shmem.c
>=20
>    486=09
>    487	static int __create_shmem(struct drm_i915_private *i915,
>    488				  struct drm_gem_object *obj,
>    489				  resource_size_t size)
>    490	{
>    491		unsigned long flags =3D VM_NORESERVE;
>    492		struct file *filp;
>    493=09
>    494		drm_gem_private_object_init(&i915->drm, obj, size);
>    495=09
>    496		/* XXX: The __shmem_file_setup() function returns -EINVAL if size=
 is
>    497		 * greater than MAX_LFS_FILESIZE.
>    498		 * To handle the same error as other code that returns -E2BIG when
>    499		 * the size is too large, we add a code that returns -E2BIG when =
the
>    500		 * size is larger than the size that can be handled.
>    501		 * If BITS_PER_LONG is 32, size > MAX_LFS_FILESIZE is always fals=
e,
>    502		 * so we only needs to check when BITS_PER_LONG is 64.
>    503		 * If BITS_PER_LONG is 32, E2BIG checks are processed when
>    504		 * i915_gem_object_size_2big() is called before init_object() cal=
lback
>    505		 * is called.
>    506		 */
>    507		if (BITS_PER_LONG =3D=3D 64 && size > MAX_LFS_FILESIZE)
>    508			return -E2BIG;
>    509=09
>    510		if (drm_gem_has_huge_mnt(&i915->drm))
>  > 511			filp =3D shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915", =
=20
>    512							 size, flags);

Maybe instead of this drm_gem_has_huge_mnt() (or in addition to), we
should have a drm_gem_get_huge_mnt() helper, so we don't have drivers
dereferencing drm_device::huge_mnt directly and we can get rid of it on
non THP configs.

>    513		else
>    514			filp =3D shmem_file_setup("i915", size, flags);
>    515		if (IS_ERR(filp))
>    516			return PTR_ERR(filp);
>    517=09
>    518		/*
>    519		 * Prevent -EFBIG by allowing large writes beyond MAX_NON_LFS on =
shmem
>    520		 * objects by setting O_LARGEFILE.
>    521		 */
>    522		if (force_o_largefile())
>    523			filp->f_flags |=3D O_LARGEFILE;
>    524=09
>    525		obj->filp =3D filp;
>    526		return 0;
>    527	}
>    528=09
>=20


