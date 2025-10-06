Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C93CCCA472
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44B08E0007; Mon,  6 Oct 2025 03:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C148E0002; Mon,  6 Oct 2025 03:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32018E0007; Mon,  6 Oct 2025 03:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C13258E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:18:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C86DB9B19
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:18:08 +0000 (UTC)
X-FDA: 83966835456.01.49F1FEC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7649C1C0004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:18:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ow50FbFk;
	spf=pass (imf21.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759735086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAqlY9H8So5CJwowxtz6znHAk3BdxNsUwnEFqH3N7xQ=;
	b=8XSwm51d4rnT9wrKnuBeCHzt8gZ2p6Gns1BvF2PoR0BpBmjyn8J0uV7yM3DSLnGweOykUb
	5cdbDQk3bn+JjRp8q9Ki84MmxEMeztzcEpYuISFFkwYhStoMC8lNaZD960KhxqfMposUTh
	Mpg4QStzOWkhubkk2c0R8dCoOxuKgoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759735086; a=rsa-sha256;
	cv=none;
	b=A6D8/JNacoM8gkhNunB+yl5qAXSyaYlb4BagbA/EANgjYUFkwkvHYrIVy/7qqq/fe0CljR
	6P+tUfLnABspCxj2huGddv0zSL6NE2NZ7Ds0ijMpGvtB5CKNIGyDwrnt3uYHLEfUWGi72I
	5WL3KgL/bTGP8p3OCFrxwKcq9l2Z6oE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ow50FbFk;
	spf=pass (imf21.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759735084;
	bh=lZ/n0Q4PSONNTacZa2zCgNApaZj6MNu9EC54zqvaIns=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ow50FbFkx9Jixg+xEFpCEeUdFIUmpo3MSKyC3xnJorfUbDFZ/fJysTWtjafpnM8Hm
	 C/XlyCYm51AVAptfBdDo1DlhBvYI63wmI754IIQXpWWqMf6EKleqB1z633vHz7ixtx
	 TTiVymqIf7f9isv1ffCeMbhh3nYd+EbpGqn4nYnIjGudG9stfnZGlmeCD6lRVTtXlb
	 eyJMoOL/zr7UZd7GSIcPNxQTraC2/Z2o+G3Xrz7N9ogU3JCTuCJeHNXaMMpPrJFrfb
	 HkPVMlxgaHbPG4G6RgoFFS2A2gCpHSzL7s0xHgmWxSmV30rZmrv/KQw1k7vHKJm840
	 9X+7cxunp2JPQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 536E017E1292;
	Mon,  6 Oct 2025 09:18:03 +0200 (CEST)
Date: Mon, 6 Oct 2025 09:17:57 +0200
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
Subject: Re: [PATCH v3 06/10] drm/gem: Get rid of *_with_mnt helpers
Message-ID: <20251006091757.642d912d@fedora>
In-Reply-To: <20251004093054.21388-7-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
	<20251004093054.21388-7-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 14um8bfkxohm5j9hak999rsp7ppkp63x
X-Rspam-User: 
X-Rspamd-Queue-Id: 7649C1C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1759735086-312075
X-HE-Meta: U2FsdGVkX1/oVmk+As2UwYoIdWEXtHFlwCOLB69SyO0tZQrOjWhkJ/0SqFefhBgB65QqvFi4lsVKEoh4wCfskllvi9732Fsmgn2Y1sydUzXOLG2VLCqYGsXEr0DwGQLDmlw0CbUA3nxGCtK9gYQINMYrnIl4F1+BzT7pCskyFzA3rZhNng18/Pna91QkBfh2o9/APvI0BmgQMQ8BOGsPCBwtYt+sbrycVsMBBZSnjhwx1LRXDsw7cLqvoQ4q5p6+49yC7Fqzs6nOQ22u0YBxOMp6krzUoNLbimSUHFfoHKQ2xvY9AgdWhhN4ZLxhUcWT3/EGD1jt1Tu6S/WPh2qqsPoYtupLXiVD5mx9T56cGKKX1kf1uCMRXLZbsQBnl7ch/5/ygG6Ra6sIXvHdvSUMnOoWkcu7K0aBt+ZO/MV5H9w+hF5IIxQK6owFSnX0WFUPkN2LOIJ8g6yod7Su0TX+xRD49/Y/ci8pA8oD92WnQkjSDwzJXBxUvteCXCtd8f6i4/NhmprIyAROB3ASXLXVDzK9t8/Acfw4KKVszmz7tE8uSejKwzFfE6+EXaex5OPBLFMrBiR4IAefBKehhgPfZF1QKZYmflVsOqWqCLsNHM6EdvUwTbFW3aFs0SW9lJfWJmoERjC+pimKfr9KUe/YP5gRbdKyFIdrBFO63Lp83NsHEas6N4Kz3IYiXEpZse+gTYgmf/z15+rxi1WLvDK15j9rnS9gAB2Qwx/E0c6ns4qnJiSUH1Bw1BrmTGbmIdUId262mN/Fo1AdRkFvEWtTk8oUFs3flNr7N7kz6fdUOMLwbEGODR8Rv4hL2cyuqjbSbuuGgjsquVlxnx0syBonb7ky/U3SwEvYC7INmgkVwPFjMa6LkDuLMTkX9Yeyn9nlhTGMOYnHtgoRlIBOARpTTIdldoZasYcf5qKdnE3r6OII8Km292wyPgngro5l950P3Fx8uukTIOt4xw+uWXP
 BJMe8wMr
 //X6X5K0meZZG7T4sWEgSNHmjswloauSyk7br+tZZE4UvqUF5IXd3F/zQAoTKQ5IL6/Cxbi6YRdZa4a59g7QMHMj/w+TzPkYKKhwqieU8/TRFI1lDx6NaShDGFAe3h89JTenVW0EAl1WtOyemVmFULJbSqLRwBB2tYXHRzE9ZuGKwgZtaV9Y6vFmxa8NzL3O5wbSLrVjq0y2s0BDTd9D58r1tDeVnUj4sArv08PWLEopIFIh4Gsy3s3pwl5pZZk5/uCg5edHckc6KSefOmkug7rxH1I6VFCaX8diKW1fF+jUVCv+AeFfKyPQTrHeteJ7O7yIdr87r4ORR0gCL3a738J6JYu5ZtATVDeAqvm8Rr1b0+HlP1K2T+A+nvh9kmaTZ6tEzA0bXqgFQpqlr0mc3lJWLM8345ohLG3P/by0MkZT9SyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Oct 2025 11:30:49 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
> be removed now that the drivers use drm_gem_huge_mnt_create().
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem.c              | 34 ++++++-----------------
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
>  drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
>  include/drm/drm_gem.h                  |  3 --
>  include/drm/drm_gem_shmem_helper.h     |  3 --
>  5 files changed, 17 insertions(+), 64 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index b4e4947210ef..a29f57943b93 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -181,28 +181,26 @@ drm_gem_init(struct drm_device *dev)
>  }
> =20
>  /**
> - * drm_gem_object_init_with_mnt - initialize an allocated shmem-backed G=
EM
> - * object in a given shmfs mountpoint
> + * drm_gem_object_init - initialize an allocated shmem-backed GEM object
>   *
>   * @dev: drm_device the object should be initialized for
>   * @obj: drm_gem_object to initialize
>   * @size: object size
> - * @gemfs: tmpfs mount where the GEM object will be created. If NULL, use
> - * the usual tmpfs mountpoint (`shm_mnt`).
>   *
>   * Initialize an already allocated GEM object of the specified size with
> - * shmfs backing store.
> + * shmfs backing store. A huge mountpoint can be used by calling
> + * drm_gem_huge_mnt_create() beforehand.
>   */
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs)
> +int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *o=
bj,
> +			size_t size)
>  {
>  	struct file *filp;
> =20
>  	drm_gem_private_object_init(dev, obj, size);
> =20
> -	if (gemfs)
> -		filp =3D shmem_file_setup_with_mnt(gemfs, "drm mm object", size,
> +	if (dev->huge_mnt)
> +		filp =3D shmem_file_setup_with_mnt(dev->huge_mnt,
> +						 "drm mm object", size,
>  						 VM_NORESERVE);
>  	else
>  		filp =3D shmem_file_setup("drm mm object", size, VM_NORESERVE);
> @@ -214,22 +212,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *=
dev,
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL(drm_gem_object_init_with_mnt);
> -
> -/**
> - * drm_gem_object_init - initialize an allocated shmem-backed GEM object
> - * @dev: drm_device the object should be initialized for
> - * @obj: drm_gem_object to initialize
> - * @size: object size
> - *
> - * Initialize an already allocated GEM object of the specified size with
> - * shmfs backing store.
> - */
> -int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *o=
bj,
> -			size_t size)
> -{
> -	return drm_gem_object_init_with_mnt(dev, obj, size, NULL);
> -}
>  EXPORT_SYMBOL(drm_gem_object_init);
> =20
>  /**
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index 22c4b09e10a3..5c1c1e8040b4 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -49,7 +49,7 @@ static const struct drm_gem_object_funcs drm_gem_shmem_=
funcs =3D {
>  };
> =20
>  static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_s=
hmem_object *shmem,
> -				size_t size, bool private, struct vfsmount *gemfs)
> +				size_t size, bool private)
>  {
>  	struct drm_gem_object *obj =3D &shmem->base;
>  	int ret =3D 0;
> @@ -61,7 +61,7 @@ static int __drm_gem_shmem_init(struct drm_device *dev,=
 struct drm_gem_shmem_obj
>  		drm_gem_private_object_init(dev, obj, size);
>  		shmem->map_wc =3D false; /* dma-buf mappings use always writecombine */
>  	} else {
> -		ret =3D drm_gem_object_init_with_mnt(dev, obj, size, gemfs);
> +		ret =3D drm_gem_object_init(dev, obj, size);
>  	}
>  	if (ret) {
>  		drm_gem_private_object_fini(obj);
> @@ -102,13 +102,12 @@ static int __drm_gem_shmem_init(struct drm_device *=
dev, struct drm_gem_shmem_obj
>   */
>  int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obje=
ct *shmem, size_t size)
>  {
> -	return __drm_gem_shmem_init(dev, shmem, size, false, NULL);
> +	return __drm_gem_shmem_init(dev, shmem, size, false);
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_init);
> =20
>  static struct drm_gem_shmem_object *
> -__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
> -		       struct vfsmount *gemfs)
> +__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private)
>  {
>  	struct drm_gem_shmem_object *shmem;
>  	struct drm_gem_object *obj;
> @@ -128,7 +127,7 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t=
 size, bool private,
>  		obj =3D &shmem->base;
>  	}
> =20
> -	ret =3D __drm_gem_shmem_init(dev, shmem, size, private, gemfs);
> +	ret =3D __drm_gem_shmem_init(dev, shmem, size, private);
>  	if (ret) {
>  		kfree(obj);
>  		return ERR_PTR(ret);
> @@ -149,31 +148,10 @@ __drm_gem_shmem_create(struct drm_device *dev, size=
_t size, bool private,
>   */
>  struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev=
, size_t size)
>  {
> -	return __drm_gem_shmem_create(dev, size, false, NULL);
> +	return __drm_gem_shmem_create(dev, size, false);
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_create);
> =20
> -/**
> - * drm_gem_shmem_create_with_mnt - Allocate an object with the given siz=
e in a
> - * given mountpoint
> - * @dev: DRM device
> - * @size: Size of the object to allocate
> - * @gemfs: tmpfs mount where the GEM object will be created
> - *
> - * This function creates a shmem GEM object in a given tmpfs mountpoint.
> - *
> - * Returns:
> - * A struct drm_gem_shmem_object * on success or an ERR_PTR()-encoded ne=
gative
> - * error code on failure.
> - */
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_de=
vice *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs)
> -{
> -	return __drm_gem_shmem_create(dev, size, false, gemfs);
> -}
> -EXPORT_SYMBOL_GPL(drm_gem_shmem_create_with_mnt);
> -
>  /**
>   * drm_gem_shmem_release - Release resources associated with a shmem GEM=
 object.
>   * @shmem: shmem GEM object
> @@ -878,7 +856,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device=
 *dev,
>  	size_t size =3D PAGE_ALIGN(attach->dmabuf->size);
>  	struct drm_gem_shmem_object *shmem;
> =20
> -	shmem =3D __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem =3D __drm_gem_shmem_create(dev, size, true);
>  	if (IS_ERR(shmem))
>  		return ERR_CAST(shmem);
> =20
> @@ -926,7 +904,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_=
map(struct drm_device *dev,
> =20
>  	size =3D PAGE_ALIGN(attach->dmabuf->size);
> =20
> -	shmem =3D __drm_gem_shmem_create(dev, size, true, NULL);
> +	shmem =3D __drm_gem_shmem_create(dev, size, true);
>  	if (IS_ERR(shmem)) {
>  		ret =3D PTR_ERR(shmem);
>  		goto fail_detach;
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index 6b9909bfce82..ef9e9c15da3c 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -151,8 +151,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, =
struct drm_file *file_priv,
>  	struct v3d_bo *bo;
>  	int ret;
> =20
> -	shmem_obj =3D drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  dev->huge_mnt);
> +	shmem_obj =3D drm_gem_shmem_create(dev, unaligned_size);
>  	if (IS_ERR(shmem_obj))
>  		return ERR_CAST(shmem_obj);
>  	bo =3D to_v3d_bo(&shmem_obj->base);
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 7285a62d9afc..42d9066b1785 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -497,9 +497,6 @@ void drm_gem_object_release(struct drm_gem_object *ob=
j);
>  void drm_gem_object_free(struct kref *kref);
>  int drm_gem_object_init(struct drm_device *dev,
>  			struct drm_gem_object *obj, size_t size);
> -int drm_gem_object_init_with_mnt(struct drm_device *dev,
> -				 struct drm_gem_object *obj, size_t size,
> -				 struct vfsmount *gemfs);
>  void drm_gem_private_object_init(struct drm_device *dev,
>  				 struct drm_gem_object *obj, size_t size);
>  void drm_gem_private_object_fini(struct drm_gem_object *obj);
> diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shm=
em_helper.h
> index 589f7bfe7506..6b6478f5ca24 100644
> --- a/include/drm/drm_gem_shmem_helper.h
> +++ b/include/drm/drm_gem_shmem_helper.h
> @@ -109,9 +109,6 @@ struct drm_gem_shmem_object {
> =20
>  int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obje=
ct *shmem, size_t size);
>  struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev=
, size_t size);
> -struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_de=
vice *dev,
> -							   size_t size,
> -							   struct vfsmount *gemfs);
>  void drm_gem_shmem_release(struct drm_gem_shmem_object *shmem);
>  void drm_gem_shmem_free(struct drm_gem_shmem_object *shmem);
> =20


