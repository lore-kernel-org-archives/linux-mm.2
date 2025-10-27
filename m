Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5EFBCCF9EC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 11:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D9C80038; Mon, 27 Oct 2025 07:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECEB8000A; Mon, 27 Oct 2025 07:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DFF80038; Mon, 27 Oct 2025 07:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2F9E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:38:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9030314054E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:38:25 +0000 (UTC)
X-FDA: 84043696170.18.032D023
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id B681F10000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:38:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RWc4ELhX;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761565103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kM2IZ9cwj+UJLgsANeLqvUwZb/NBB1zAaY/ie/RunGc=;
	b=dvE9CyskswAnxkeUGL5PMZTB87aozFnsIfoP9MrSxH4NXmqw72tAN44Sy6L09vPywcqNVo
	/viCEPocH+nA1WNiI46iCnWzb95JdGQNBKTf7+Wb18bcYJkEw7Nn+x6Xd0hwSWSFv3CLJ5
	pb3t3LuCxzSRW+z/Bex4Ut3ohOlOt1E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RWc4ELhX;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761565103; a=rsa-sha256;
	cv=none;
	b=z3G4bNI+W7Rk9sttH+D7MhUuCc05sg+AEZS2IfG0/h7Y8EeF9+WyiCtDtk9dh++yz5PZwE
	IwDnV2JhfEjjU7s+4qkhve/z7IU2QKz9hysZtRMWXhwsaxoIaiN0NJN/DSt3hualZEvRrd
	lKvSkR4CDh3LzJkJYmVTYUK5td+vLq0=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-780fe76f457so44695877b3.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565103; x=1762169903; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kM2IZ9cwj+UJLgsANeLqvUwZb/NBB1zAaY/ie/RunGc=;
        b=RWc4ELhXWkYjDqtjcLGZG7MRchmbM11adXfrc1jWgCa9mpkWDXRfbShiZegQ4o3d9k
         lVzJrsEkoLNUvRETCJ62Hyq64h1idmBbWfvGpFPE14Pk9OtDMoFQNtd7EAepiW/jshFJ
         KVdh94ulZPZ4ofe7inZoSacrhQxWlbU6trumia9iaoZoOskAO5YhJrtxE2hdkUPUXaG8
         yad3lbXLlfmFU9ItYL9Jv1VdVuDH6j1lihyMK6B51Rlhyx/VKDWJ4AQBPfqoWcUvwcyp
         dIgCsoZek+9gVSjO4eSxOXFhr0gcuUyx21o3H6XzaPBWlIZKj6U04OmEKbEG5bV40C8Z
         5otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565103; x=1762169903;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kM2IZ9cwj+UJLgsANeLqvUwZb/NBB1zAaY/ie/RunGc=;
        b=grasOv9suBoqTopEaYSYaZ67dlT1eOrFgHb+9WJqy6IcCsnML2xCMDJWFh7PXpDL7P
         u6YIBW3JDEVD4fzh8BGEhP2AXR2cMmJi4HzukXGrhCP6+rV3jwkeHe19dynffLI7couP
         YMEm9ZtANB/MPSxVBakNDOq4KM8kSP3m30pIqVd0YYe3AqCAKgQRHbn+jWxWl8Uv+v+s
         FQELNEVlRV/hFDK6Dex1/0mWFHnLvNqoLm3LIxjxm4w8FIP5xpAvTOo/MdeEV/+tfc1U
         TNoOFQA71O4G/JUPVNQ7VqRLqgP4v21czqX1QivI8LqUqcVmbOjhD93zfKY797ZpwzV9
         IOyA==
X-Forwarded-Encrypted: i=1; AJvYcCXha0wfpJUAgIeuJNj8D4x60B5T8qlzNbn3b/domA6sRSx+FwPtWL9tW47kRUkfcx91ujO6OhFnJA==@kvack.org
X-Gm-Message-State: AOJu0YyhJCtAFBxf5wE360UMiHrhFkGH5R50l07aj2kGn6I/21Bk81Dp
	oVk2zwY0u9CQYdfWb7/d1EmgJkuxgkeY6RkTI3QhR7iIbgVHAYTEX2lQJE6T+VcKJg==
X-Gm-Gg: ASbGncuElz1TEDw+kdQQpAWwPJaO+ViDI5fm3zzO3xMcc/Co2xDqDfy3IGbBb76Ql46
	M9ZLKVPTESyUtZvsX02UZ7AZ531vSSEVPb1mBCd2VzegYMo9Bvufz6NZjXEWPBfl6iwLTWWj4FR
	CZPcL0zN+UEiWcF0tP+XhZiksbV2ITcWnhjljdFnTZ47AfXPl6xo+dWoY63z8ucokNye3kNCNty
	o4Rx5k2XbMdTjs2bYOonzYVAL2lvKuXYQw+vMQpeILFS3cT7aK+WBKTz+ARy2G1K3kB/+ZJK4kq
	dLAxqrF8vkooZn/FSqxn7nKFALJ0mmkS/tfuWC5SAFu407xUzVD6upmlxiQRD1ujsJahLqOfBCT
	Ki2t+KtqAMIYDyORsY/Z7vGztjCiwVRUvWd7siXbdOzYliI0YDgh0i3IxN+/U1+nC7z0FOUqoiH
	JUFpwN/WV0GHovi1fkf7a7mWFsj4SXjNC+zEoA1EevIG2Eys7qvACl1V1u9sG/
X-Google-Smtp-Source: AGHT+IE4Ub7ALPlx8peQtM84EXgIvuQeQhQB62WRPzDKnIKsnig9v60A6eNZIkmhT0CWSJohULobMg==
X-Received: by 2002:a05:690c:4806:b0:784:8c2c:320e with SMTP id 00721157ae682-7848c2c3fe4mr478987887b3.34.1761565102322;
        Mon, 27 Oct 2025 04:38:22 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f4c4724b9sm2225325d50.27.2025.10.27.04.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 04:38:21 -0700 (PDT)
Date: Mon, 27 Oct 2025 04:38:18 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
    Maxime Ripard <mripard@kernel.org>, 
    Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
    Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
    Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
    Rodrigo Vivi <rodrigo.vivi@intel.com>, 
    Tvrtko Ursulin <tursulin@ursulin.net>, 
    Boris Brezillon <boris.brezillon@collabora.com>, 
    Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>, 
    Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>, 
    =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>, 
    Hugh Dickins <hughd@google.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Al Viro <viro@zeniv.linux.org.uk>, 
    =?UTF-8?Q?Miko=C5=82aj_Wasiak?= <mikolaj.wasiak@intel.com>, 
    Christian Brauner <brauner@kernel.org>, 
    Nitin Gote <nitin.r.gote@intel.com>, 
    Andi Shyti <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, 
    Christopher Healy <healych@amazon.com>, 
    Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>, 
    linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
    intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, 
    linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v5 04/12] drm/gem: Introduce drm_gem_get_unmapped_area()
 fop
In-Reply-To: <20251021113049.17242-5-loic.molinari@collabora.com>
Message-ID: <f34bd4ef-5779-b364-0df6-e52f8377b461@google.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com> <20251021113049.17242-5-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-2004846092-1761565101=:3513"
X-Stat-Signature: rizh8yxmxt5jtr5pwc6yzhmq15yjhgux
X-Rspamd-Queue-Id: B681F10000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761565103-643337
X-HE-Meta: U2FsdGVkX1/Hma0zpBwhPRGPw6Gm2OPrltlzhB5q24/LJ0pSg9Dk+y1QCQ+27cWjE3wtUr1po4Zz0mrd7+uBv7GtiZmjGDeBB7PE444kL0LH31EwGi/KsWl4agXWekU4DaIci86yT85wzlQNf8XyHGhWShDX6kTUiFnDwkF9nCQh3zq+cORVTI99PqOzn1/stlb7ElPW8SL0URrPtZIvfAHhQgs3LpWi3vcn25JM9MAl4MicozLINBLqJrajFLy/2HWhi510n3cWy5O6MJiaDKOYgtXKSi3w+Xm6Yut724Gz1BV0uS2yUWNydkh6dO+sX0Z0+1pmkNVBJZrkPA7Hnmpq4AsXeTQIEwS/e7G/kvcK2dTtKVkS3i6VrgJlFTv0vnXcX/Wtz48+OLs1l4ifhU1jMiMZAM4q7iuUQsuOwWNW5JMB8PKT6rCaypn8VNxErXSdWd/0JI8hvYYnRtMOLiO4gc9lzEIG3/qLF0J63VZ5MkEiLmJDBCiz7DLH6Tj0NVF+gbZ2JytuaF6L72yZqggQjxgpz2fVY0gGf98R24sYc+0idejPVQ0Ps9is8ouLQafIH+tvsW+lPgHLLgFNj8BbQNC6jeXHcJiGjJ/5olq9UqcuN9cKQ0WQ/exl8BUIPIVWLanQbzQL9zE6Hvnz/QXqCd5MYOV/k/gyHbfjbWs1AgIBJMBR6ZiDkH5E4+P1M/qj9+/shJVb1QUi9ognSCBJLILDcAJUscM1xsza1oTMVcGVJyNhjftjJ1jHLDQVlrsUxDpUF00qZ3HQtW4hzZYrtXpy953obIKvvWJSHG3ZwUR6zG4K+OXNerRVnBz9g+aP3ifoXb5ipLpWU7/WkmvQid06ZIPzXUpKqrK+Ofze5XDuzK5s5+YXcZSmkJuMOI5YuMHilaYIHx9Ye4Yx9egH+b61KKUNIJjWH6Wfc72VQXZk/OUY7vDzbhH8WIhhA3Hs5hGRrBfRZf+4HNi
 vrhH0zSE
 LZgd8Z5c4v/kNh9EUp5QPC6ezFj1wg1LTnrit9/xyjtVo98YJf5XfEhZ57OljS0aTl8gMAtwi/326+lcZjNvVFbTONlOnc91zl8UP1rN2Tn6pnqo+e/wjPvECV799i9yozQVTgdjCt9FeV9lDqQruQq/jajVwO7ZGME+pSrF5U97UZRiGeoDuGRoNJk+Aq8e3e78Zka/FxC9NZ3+RsCm12loIWDd4nc+jibzGJPX9BPApfmeunoizLQdshY65Ihn1qcDM6XYBsEHJ/rx/4NW/JffKw8BDcw0ppJC4+oJd5AyxSnGBFIRsO8z6c9XaLMunIWzL9vrVWaf+fxzEiRPLTorwRK+ZCoTMqzwOdasu5d4aZcWAmwKiRuogHUmApDPIm3VqsulRSXYPRIvpqEhogXdDZau7HFnGujmETWVMrkHj/vb22ofjrNb/UBoVuw5zape2J701s9OnAIsqiX/jrcmibFFWXbn5+HSVLv308SaBtffyMwAk8X8yQqFES4/SiO/mPF7NIIeDGcnjzvM96aL2e3gP5RYUmvLn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-2004846092-1761565101=:3513
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 21 Oct 2025, Lo=C3=AFc Molinari wrote:

> mmap() calls on the DRM file pointer currently always end up using
> mm_get_unmapped_area() to get a free mapping region. On builds with
> CONFIG_TRANSPARENT_HUGEPAGE enabled, this isn't ideal for GEM objects
> backed by shmem buffers on mountpoints setting the 'huge=3D' option
> because it can't correctly figure out the potentially huge address
> alignment required.
>=20
> This commit introduces the drm_gem_get_unmapped_area() function which
> is meant to be used as a get_unmapped_area file operation on the DRM
> file pointer to lookup GEM objects based on their fake offsets and get
> a properly aligned region by calling shmem_get_unmapped_area() with
> the right file pointer. If a GEM object isn't available at the given
> offset or if the caller isn't granted access to it, the function falls
> back to mm_get_unmapped_area().
>=20
> This also makes drm_gem_get_unmapped_area() part of the default GEM
> file operations so that all the DRM drivers can benefit from more
> efficient mappings thanks to the huge page fault handler introduced in
> previous commit 'drm/shmem-helper: Add huge page fault handler'.
>=20
> The shmem_get_unmapped_area() function needs to be exported so that
> it can be used from the DRM subsystem.
>=20
> v3:
> - add missing include: 'linux/sched/mm.h'
> - forward to shmem layer in builds with CONFIG_TRANSPARENT_HUGEPAGE=3Dn
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Seems reasonable, but a couple of minor remarks below.

> ---
>  drivers/gpu/drm/drm_gem.c | 107 ++++++++++++++++++++++++++++++--------
>  include/drm/drm_gem.h     |   4 ++
>  mm/shmem.c                |   1 +
>  3 files changed, 90 insertions(+), 22 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index a1a9c828938b..a98d5744cc6c 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -36,6 +36,7 @@
>  #include <linux/module.h>
>  #include <linux/pagemap.h>
>  #include <linux/pagevec.h>
> +#include <linux/sched/mm.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
>  #include <linux/string_helpers.h>
> @@ -1187,36 +1188,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, =
unsigned long obj_size,
>  }
>  EXPORT_SYMBOL(drm_gem_mmap_obj);
> =20
> -/**
> - * drm_gem_mmap - memory map routine for GEM objects
> - * @filp: DRM file pointer
> - * @vma: VMA for the area to be mapped
> - *
> - * If a driver supports GEM object mapping, mmap calls on the DRM file
> - * descriptor will end up here.
> - *
> - * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> - * contain the fake offset we created when the GTT map ioctl was called =
on
> - * the object) and map it with a call to drm_gem_mmap_obj().
> - *
> - * If the caller is not granted access to the buffer object, the mmap wi=
ll fail
> - * with EACCES. Please see the vma manager for more information.
> +/*
> + * Look up a GEM object in offset space based on the exact start address=
=2E The
> + * caller must be granted access to the object. Returns a GEM object on =
success
> + * or a negative error code on failure. The returned GEM object needs to=
 be
> + * released with drm_gem_object_put().
>   */
> -int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
> +static struct drm_gem_object *
> +drm_gem_object_lookup_from_offset(struct file *filp, unsigned long start=
,
> +=09=09=09=09  unsigned long pages)
>  {
>  =09struct drm_file *priv =3D filp->private_data;
>  =09struct drm_device *dev =3D priv->minor->dev;
>  =09struct drm_gem_object *obj =3D NULL;
>  =09struct drm_vma_offset_node *node;
> -=09int ret;
> =20
>  =09if (drm_dev_is_unplugged(dev))
> -=09=09return -ENODEV;
> +=09=09return ERR_PTR(-ENODEV);
> =20
>  =09drm_vma_offset_lock_lookup(dev->vma_offset_manager);
>  =09node =3D drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
> -=09=09=09=09=09=09  vma->vm_pgoff,
> -=09=09=09=09=09=09  vma_pages(vma));
> +=09=09=09=09=09=09  start, pages);
>  =09if (likely(node)) {
>  =09=09obj =3D container_of(node, struct drm_gem_object, vma_node);
>  =09=09/*
> @@ -1235,14 +1227,85 @@ int drm_gem_mmap(struct file *filp, struct vm_are=
a_struct *vma)
>  =09drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
> =20
>  =09if (!obj)
> -=09=09return -EINVAL;
> +=09=09return ERR_PTR(-EINVAL);
> =20
>  =09if (!drm_vma_node_is_allowed(node, priv)) {
>  =09=09drm_gem_object_put(obj);
> -=09=09return -EACCES;
> +=09=09return ERR_PTR(-EACCES);
>  =09}
> =20
> -=09ret =3D drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT,
> +=09return obj;
> +}
> +
> +/**
> + * drm_gem_get_unmapped_area - get memory mapping region routine for GEM=
 objects
> + * @filp: DRM file pointer
> + * @uaddr: User address hint
> + * @len: Mapping length
> + * @pgoff: Offset (in pages)
> + * @flags: Mapping flags
> + *
> + * If a driver supports GEM object mapping, before ending up in drm_gem_=
mmap(),
> + * mmap calls on the DRM file descriptor will first try to find a free l=
inear
> + * address space large enough for a mapping. Since GEM objects are backe=
d by
> + * shmem buffers, this should preferably be handled by the shmem virtual=
 memory
> + * filesystem which can appropriately align addresses to huge page sizes=
 when
> + * needed.
> + *
> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> + * contain the fake offset we created) and call shmem_get_unmapped_area(=
) with
> + * the right file pointer.
> + *
> + * If a GEM object is not available at the given offset or if the caller=
 is not
> + * granted access to it, fall back to mm_get_unmapped_area().
> + */
> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long=
 uaddr,
> +=09=09=09=09=09unsigned long len, unsigned long pgoff,
> +=09=09=09=09=09unsigned long flags)
> +{
> +=09struct drm_gem_object *obj;
> +=09unsigned long ret;
> +
> +=09obj =3D drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SH=
IFT);
> +=09if (IS_ERR(obj))
> +=09=09return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
> +=09=09=09=09=09    flags);
> +
> +=09ret =3D shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
> +
> +=09drm_gem_object_put(obj);
> +
> +=09return ret;
> +}
> +EXPORT_SYMBOL(drm_gem_get_unmapped_area);

Not something I'll make an issue of, but this does look rather like
a drm EXPORT_SYMBOL() of a shmem EXPORT_SYMBOL_GPL().

Not your intention, I think, and a quick look around suggests some
inconsistency as to whether symbols here are exported _GPL() or not.

Maybe there's good (historical?) reason for which is which, or
maybe it's something maintainers would like to clean up one day.

Please make this one EXPORT_SYMBOL_GPL() if you can.

> +
> +/**
> + * drm_gem_mmap - memory map routine for GEM objects
> + * @filp: DRM file pointer
> + * @vma: VMA for the area to be mapped
> + *
> + * If a driver supports GEM object mapping, mmap calls on the DRM file
> + * descriptor will end up here.
> + *
> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff w=
ill
> + * contain the fake offset we created) and map it with a call to
> + * drm_gem_mmap_obj().
> + *
> + * If the caller is not granted access to the buffer object, the mmap wi=
ll fail
> + * with EACCES. Please see the vma manager for more information.
> + */
> +int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +=09struct drm_gem_object *obj;
> +=09int ret;
> +
> +=09obj =3D drm_gem_object_lookup_from_offset(filp, vma->vm_pgoff,
> +=09=09=09=09=09=09vma_pages(vma));
> +=09if (IS_ERR(obj))
> +=09=09return PTR_ERR(obj);
> +
> +=09ret =3D drm_gem_mmap_obj(obj,
> +=09=09=09       drm_vma_node_size(&obj->vma_node) << PAGE_SHIFT,
>  =09=09=09       vma);
> =20
>  =09drm_gem_object_put(obj);
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 8d48d2af2649..7c8bd67d087c 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -469,6 +469,7 @@ struct drm_gem_object {
>  =09.poll=09=09=3D drm_poll,\
>  =09.read=09=09=3D drm_read,\
>  =09.llseek=09=09=3D noop_llseek,\
> +=09.get_unmapped_area=09=3D drm_gem_get_unmapped_area,\
>  =09.mmap=09=09=3D drm_gem_mmap, \
>  =09.fop_flags=09=3D FOP_UNSIGNED_OFFSET
> =20
> @@ -506,6 +507,9 @@ void drm_gem_vm_close(struct vm_area_struct *vma);
>  int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>  =09=09     struct vm_area_struct *vma);
>  int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long=
 uaddr,
> +=09=09=09=09=09unsigned long len, unsigned long pgoff,
> +=09=09=09=09=09unsigned long flags);
> =20
>  /**
>   * drm_gem_object_get - acquire a GEM buffer object reference
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b9081b817d28..612218fc95cb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2851,6 +2851,7 @@ unsigned long shmem_get_unmapped_area(struct file *=
file,
>  =09=09return addr;
>  =09return inflated_addr;
>  }
> +EXPORT_SYMBOL_GPL(shmem_get_unmapped_area);

As you have it, that export comes under #ifdef CONFIG_SHMEM.

I know parts of drm do "select SHMEM" these days, but you might not
be covered by those: maybe you need a "select SHMEM" in the relevant
Kconfig, or maybe you prefer to duplicate that export line after the
later !CONFIG_SHMEM definitiion of shmem_get_unmapped_area().

Or better, make no export here at all, but drm_gem_get_unmapped_area()
use obj->filp->f_op->get_unmapped_area()?

> =20
>  #ifdef CONFIG_NUMA
>  static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy=
 *mpol)
> --=20
> 2.47.3
---1463770367-2004846092-1761565101=:3513--

