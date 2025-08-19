Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E67CA0EF8
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 16:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA0A6B0127; Tue, 19 Aug 2025 12:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63DA6B0128; Tue, 19 Aug 2025 12:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C527F6B0129; Tue, 19 Aug 2025 12:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACD906B0127
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:22:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A8D480D2E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:22:25 +0000 (UTC)
X-FDA: 83794024650.15.94BE028
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf19.hostedemail.com (Postfix) with ESMTP id 644D21A0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:22:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i0eAlELO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.21) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755620543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqABCmJMu4C84OtUpBrf8FaBlZZlbwt2cwGbL+sNB3I=;
	b=1tSlE5CR31bBck2/J5tcTs+63/mCgEAGPQSjFjEkCaOwZSee4Y2ePRaen9EEY9JgH9QRJW
	Rl4h1aIgXK1iv0od6UlN5LZaEGMGc040uVwtdMVX4lir+fobiU66iESiWzjWkJK+83sGIn
	FTT1l6Z5qejBNXoE0nttgeC8HT7CsdQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i0eAlELO;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.21) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755620543; a=rsa-sha256;
	cv=none;
	b=yK8fn9g+1qTy41vtcUtYt03Gw3UvPYsVc7KojxyHkb/QmKFEJHfkTNoFVo5Qpva+lPrGpC
	DT09SidgUDVDDQy5/bXrtuxUv3QIOptmJ97FXk99hkqrGK/mIXaGk+UjX2/Zco/5ns9Av+
	mTiAei7Yp3UsRl0xNSWMJ43bIR3tYu4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755620543; x=1787156543;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=W5BXlbdL6VMt9fy51GQ8P4Eh8jE43eeq4m0X4bsoFVk=;
  b=i0eAlELOJ693f1ilnnK57fLo4IXOgMkbAWug6doIzfG+dEdPhIYW4cbS
   fJ38HgpmzVPKrwx/bkO95hggkn7APVeomeVN/saBwljgEqO03KTt7zDsc
   Q1H1tCToaHAZvN2OCLTibDHfGOVk7pFn1sA5r9/iSHM0lLUhTto/J7x0v
   11VyDD0huPsNUPN1s9yRQeEdwwUlN5i6p5gKe/5qI7CTw/ISbzA/OS8cC
   m+T7n9uOc4wX5AgGZdJzkAffHp+oLrfZcdyn7fXpKIoYLuOwYD8nQTD2P
   s4JeECmOqov54+0tWp1y5qsvZwZTCSfSwY4QCOv5PMMtiAUxIjjKQ1HMn
   g==;
X-CSE-ConnectionGUID: nLMgzuOjTyeVwRkcpq/pmQ==
X-CSE-MsgGUID: uWTGSk1aSOCr4zSWw744vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57784055"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57784055"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:22:21 -0700
X-CSE-ConnectionGUID: KRj5XQo4TCqnKLwiAeRdFQ==
X-CSE-MsgGUID: L0XRhVf3RUKqK362RJBLlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="172326288"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO [10.245.244.175]) ([10.245.244.175])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:22:14 -0700
Message-ID: <a781f7781a9bf510c3707a5c9a235e1dab785617.camel@linux.intel.com>
Subject: Re: [RFC 3/3] drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and
 implementation
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Maarten Lankhorst <dev@lankhorst.se>, Lucas De Marchi	
 <lucas.demarchi@intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David
 Airlie	 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maxime Ripard
	 <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo	
 <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 'Michal
 =?ISO-8859-1?Q?Koutn=FD=27?=	 <mkoutny@suse.com>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin	 <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song	 <muchun.song@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "'Liam R . Howlett'"	
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport	
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Zimmermann	 <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 19 Aug 2025 18:22:12 +0200
In-Reply-To: <20250819114932.597600-8-dev@lankhorst.se>
References: <20250819114932.597600-5-dev@lankhorst.se>
	 <20250819114932.597600-8-dev@lankhorst.se>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 644D21A0002
X-Stat-Signature: pdf76hjnjrezh99xhjqfxr4f8rokox5i
X-Rspam-User: 
X-HE-Tag: 1755620542-257153
X-HE-Meta: U2FsdGVkX19zjwbIFkzU9GlhhUKYk9GI2+mTM5P9xdc+XyXZWNDpS30+jSADWely1E9w/x/kFcq28gxjgI91bKkujSu2JIIzVHabcyE6KLJhucjE1wRozmwwFuXcQi0lIuWN289E4BsXYJdU0j9Er616mdqCdx5QVEPtzhOF/1B8IeK+pLrQCdrMOp5cgLQjcr4m3XZtI2rPoDMG3eDrGTCNRe3BAICNlqGbb5WA+WWBBKYGfT8aHjhNq/6SpPRqUsPVsSnxZxzi9tK4/cEaPHpIXxDu5CCa5McXO9JMmZ9K+emqdMgz3XoSv3gqXO7uWPT6QP5eHvr7S63XnZUiwe5SdFDXcUJobf1bJwkEJgySsHJDc1JRKuwCUrNAplncWr5kxf7ic0gMAD5WJ0c0Z2GikbbjcITpO/j4RkI+bAJqjGyG0PQJH4icHSujF7ZPFrzWlTuSRVqeHEPr19fwBlH6iNufphFmMsNUa1TGJ/RIf2BbcMIqKvZmvhIWj0e1xQuT9E10CXg7uEA7hHUAQL420gyADHa0stATw1uhNxNLnXemwvHxv59oPK8dJ7ppBPjH/9nOCDluuEJhKzp4ab42xLOWQTPiYZlweTDJn9OIkq23URWsHYEjGWOv5uWmML8g39mWa48Ax7JDgQ9+4EJ2eZlHAUz43q/BDp2ZJ3XEGs6hVaVsvguiQGCy0U7Z8kv4wyaCEgw47wEhDi+eJE176nS2pNa4JiNbpWR6bxu0xftlIlB5/Kg5ArnpfZ58zP1CdGjWTuj7hFvDbKBeLOIb6TprcVbdijGA6g56VdCzqhJI2zS89BfbIOYm3ayQ0TuNIUpE+sDJ1slVUp5XkXmCXMT8CUcLqwt3xmnb1Pvr3kA9W8KUqnX7NCS7FN7uiUJRj5rSyrURTdN50UAKAneJbmeyOKA+yxxS9PlgqMjl4Vkq/gW7mSp4z5U6T2bmr8BXERlbxUBRSM9IHJd
 e4H2lzZj
 JKu0AICkN84b+oj28VBk87LeJ39zZB2ms3R5s05B+ZqOJzvns2IQwmB29EUh5PdAFZf0QTE7QyAv2Km3NUxtOhunYt9uvX9d2WP5uLUOvWJGJwRZ6E4qOueximIQYS2Y2k7qKi4f0Vw4rr2DQlFLY63MOOMbVe7RF4cDakPTSD17IWx4hI3Tvj4NqANn+DylrFxrc7rmmyM22C6vAxKM2Y7gGKRxFhCSJhPW5tKyW8xrbavYoIw7769/HxuA/3cqr2I1OfTWahI95AqtGsfiiXlz9dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Maarten,

On Tue, 2025-08-19 at 13:49 +0200, Maarten Lankhorst wrote:
> Add an option to pin memory through the science of cgroup accounting.
> A bo will be pinned for its entire lifetime, and this allows buffers
> that are pinned for dma-buf export without requiring the pinning to
> be
> done at the dma-buf layer for all devices.
>=20
> For now only implement VRAM pinning. Dave Airlie has a series to
> implement
> memcg accounting for the GPU but that is not ready yet.

Previous discussions around this have favoured a UAPI where we pin a
gpu-vm range, with a pin at mapping time, or dma-buf pin time where
required, this allows for dynamic pinning and unpinning, and would
avoid having separate pinning interfaces for bos and userptr.

In particular if we don't know at bo creation time which buffer objects
will be exported with a method requiring pinning, how would UMD deduce
what buffer objects to pin?

Thanks,
Thomas



>=20
> Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
> ---
> =C2=A0drivers/gpu/drm/xe/xe_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 66
> ++++++++++++++++++++++++++++++++-
> =C2=A0drivers/gpu/drm/xe/xe_dma_buf.c | 10 ++++-
> =C2=A0include/uapi/drm/xe_drm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 =
++++-
> =C2=A03 files changed, 82 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
> index 6fea39842e1e6..4095e6bd04ea9 100644
> --- a/drivers/gpu/drm/xe/xe_bo.c
> +++ b/drivers/gpu/drm/xe/xe_bo.c
> @@ -5,6 +5,7 @@
> =C2=A0
> =C2=A0#include "xe_bo.h"
> =C2=A0
> +#include <linux/cgroup_dmem.h>
> =C2=A0#include <linux/dma-buf.h>
> =C2=A0#include <linux/nospec.h>
> =C2=A0
> @@ -208,7 +209,8 @@ static bool force_contiguous(u32 bo_flags)
> =C2=A0	 * must be contiguous, also only contiguous BOs support
> xe_bo_vmap.
> =C2=A0	 */
> =C2=A0	return bo_flags & XE_BO_FLAG_NEEDS_CPU_ACCESS &&
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bo_flags & XE_BO_FLAG_PINNED;
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bo_flags & XE_BO_FLAG_PINNED &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(bo_flags & XE_BO_FLAG_USER);
> =C2=A0}
> =C2=A0
> =C2=A0static void add_vram(struct xe_device *xe, struct xe_bo *bo,
> @@ -1697,6 +1699,16 @@ static void xe_gem_object_free(struct
> drm_gem_object *obj)
> =C2=A0	ttm_bo_put(container_of(obj, struct ttm_buffer_object,
> base));
> =C2=A0}
> =C2=A0
> +static void xe_bo_unpin_user(struct xe_bo *bo)
> +{
> +	xe_bo_unpin_external(bo);
> +
> +	if (bo->flags & XE_BO_FLAG_SYSTEM)
> +		WARN_ON(1);
> +	else
> +		dmem_cgroup_unpin(bo->ttm.resource->css,
> xe_bo_size(bo));
> +}
> +
> =C2=A0static void xe_gem_object_close(struct drm_gem_object *obj,
> =C2=A0				struct drm_file *file_priv)
> =C2=A0{
> @@ -1708,6 +1720,10 @@ static void xe_gem_object_close(struct
> drm_gem_object *obj,
> =C2=A0		xe_bo_lock(bo, false);
> =C2=A0		ttm_bo_set_bulk_move(&bo->ttm, NULL);
> =C2=A0		xe_bo_unlock(bo);
> +	} else if (bo->flags & XE_BO_FLAG_PINNED) {
> +		xe_bo_lock(bo, false);
> +		xe_bo_unpin_user(bo);
> +		xe_bo_unlock(bo);
> =C2=A0	}
> =C2=A0}
> =C2=A0
> @@ -2128,8 +2144,27 @@ struct xe_bo *xe_bo_create_user(struct
> xe_device *xe, struct xe_tile *tile,
> =C2=A0	struct xe_bo *bo =3D __xe_bo_create_locked(xe, tile, vm, size,
> 0, ~0ULL,
> =C2=A0						 cpu_caching,
> ttm_bo_type_device,
> =C2=A0						 flags |
> XE_BO_FLAG_USER, 0);
> -	if (!IS_ERR(bo))
> +	if (!IS_ERR(bo)) {
> +		int ret =3D 0;
> +
> +		if (bo->flags & XE_BO_FLAG_PINNED) {
> +			if (bo->flags & XE_BO_FLAG_SYSTEM) {
> +				ret =3D -ENOSYS; // TODO
> +			} else {
> +				ret =3D dmem_cgroup_try_pin(bo-
> >ttm.resource->css, size);
> +			}
> +			if (!ret)
> +				ret =3D xe_bo_pin_external(bo);
> +			else if (ret =3D=3D -EAGAIN)
> +				ret =3D -ENOSPC;
> +		}
> +
> =C2=A0		xe_bo_unlock_vm_held(bo);
> +		if (ret) {
> +			xe_bo_put(bo);
> +			return ERR_PTR(ret);
> +		}
> +	}
> =C2=A0
> =C2=A0	return bo;
> =C2=A0}
> @@ -2745,6 +2780,28 @@ int xe_gem_create_ioctl(struct drm_device
> *dev, void *data,
> =C2=A0			 args->cpu_caching =3D=3D
> DRM_XE_GEM_CPU_CACHING_WB))
> =C2=A0		return -EINVAL;
> =C2=A0
> +	if (XE_IOCTL_DBG(xe, args->flags &
> DRM_XE_GEM_CREATE_FLAG_PINNED)) {
> +		bool pinned_flag =3D true;
> +		/* Only allow a single placement for pinning */
> +		if (XE_IOCTL_DBG(xe, pinned_flag && hweight32(args-
> >placement) !=3D 1))
> +			return -EINVAL;
> +
> +		/* Meant for exporting, do not allow a VM-local BO
> */
> +		if (XE_IOCTL_DBG(xe, pinned_flag && args->vm_id))
> +			return -EINVAL;
> +
> +		/* Similarly, force fail at creation time for now.
> We may relax this requirement later */
> +		if (XE_IOCTL_DBG(xe, pinned_flag && args->flags &
> DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING))
> +			return -EINVAL;
> +
> +		/* Require the appropriate cgroups to be enabled. */
> +		if (XE_IOCTL_DBG(xe, pinned_flag &&
> !IS_ENABLED(CONFIG_CGROUP_DMEM) && bo_flags & XE_BO_FLAG_VRAM_MASK)
> ||
> +		=C2=A0=C2=A0=C2=A0 XE_IOCTL_DBG(xe, pinned_flag &&
> !IS_ENABLED(CONFIG_MEMCG) && bo_flags & XE_BO_FLAG_SYSTEM))
> +			return -EINVAL;
> +
> +		bo_flags |=3D XE_BO_FLAG_PINNED;
> +	}
> +
> =C2=A0	if (args->vm_id) {
> =C2=A0		vm =3D xe_vm_lookup(xef, args->vm_id);
> =C2=A0		if (XE_IOCTL_DBG(xe, !vm))
> @@ -2790,6 +2847,11 @@ int xe_gem_create_ioctl(struct drm_device
> *dev, void *data,
> =C2=A0		__xe_bo_unset_bulk_move(bo);
> =C2=A0		xe_vm_unlock(vm);
> =C2=A0	}
> +	if (bo->flags & XE_BO_FLAG_PINNED) {
> +		xe_bo_lock(bo, false);
> +		xe_bo_unpin_user(bo);
> +		xe_bo_unlock(bo);
> +	}
> =C2=A0out_put:
> =C2=A0	xe_bo_put(bo);
> =C2=A0out_vm:
> diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c
> b/drivers/gpu/drm/xe/xe_dma_buf.c
> index 346f857f38374..6719f4552ad37 100644
> --- a/drivers/gpu/drm/xe/xe_dma_buf.c
> +++ b/drivers/gpu/drm/xe/xe_dma_buf.c
> @@ -53,6 +53,11 @@ static int xe_dma_buf_pin(struct
> dma_buf_attachment *attach)
> =C2=A0	struct xe_device *xe =3D xe_bo_device(bo);
> =C2=A0	int ret;
> =C2=A0
> +	if (bo->flags & XE_BO_FLAG_PINNED) {
> +		ttm_bo_pin(&bo->ttm);
> +		return 0;
> +	}
> +
> =C2=A0	/*
> =C2=A0	 * For now only support pinning in TT memory, for two
> reasons:
> =C2=A0	 * 1) Avoid pinning in a placement not accessible to some
> importers.
> @@ -83,7 +88,10 @@ static void xe_dma_buf_unpin(struct
> dma_buf_attachment *attach)
> =C2=A0	struct drm_gem_object *obj =3D attach->dmabuf->priv;
> =C2=A0	struct xe_bo *bo =3D gem_to_xe_bo(obj);
> =C2=A0
> -	xe_bo_unpin_external(bo);
> +	if (bo->flags & XE_BO_FLAG_PINNED)
> +		ttm_bo_unpin(&bo->ttm);
> +	else
> +		xe_bo_unpin_external(bo);
> =C2=A0}
> =C2=A0
> =C2=A0static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment
> *attach,
> diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
> index c721e130c1d2d..3184fa38ce17e 100644
> --- a/include/uapi/drm/xe_drm.h
> +++ b/include/uapi/drm/xe_drm.h
> @@ -765,12 +765,15 @@ struct drm_xe_device_query {
> =C2=A0 *=C2=A0=C2=A0=C2=A0 until the object is either bound to a virtual =
memory region
> via
> =C2=A0 *=C2=A0=C2=A0=C2=A0 VM_BIND or accessed by the CPU. As a result, n=
o backing memory
> is
> =C2=A0 *=C2=A0=C2=A0=C2=A0 reserved at the time of GEM object creation.
> - *=C2=A0 - %DRM_XE_GEM_CREATE_FLAG_SCANOUT
> + *=C2=A0 - %DRM_XE_GEM_CREATE_FLAG_SCANOUT - GEM object will be used
> + *=C2=A0=C2=A0=C2=A0 display framebuffer.
> =C2=A0 *=C2=A0 - %DRM_XE_GEM_CREATE_FLAG_NEEDS_VISIBLE_VRAM - When using =
VRAM
> as a
> =C2=A0 *=C2=A0=C2=A0=C2=A0 possible placement, ensure that the correspond=
ing VRAM
> allocation
> =C2=A0 *=C2=A0=C2=A0=C2=A0 will always use the CPU accessible part of VRA=
M. This is
> important
> =C2=A0 *=C2=A0=C2=A0=C2=A0 for small-bar systems (on full-bar systems thi=
s gets turned
> into a
> =C2=A0 *=C2=A0=C2=A0=C2=A0 noop).
> + *=C2=A0 - %DRM_XE_GEM_CREATE_FLAG_PINNED - Pin the backing memory
> permanently
> + *=C2=A0=C2=A0=C2=A0 on allocation, if withing cgroups limits.
> =C2=A0 *=C2=A0=C2=A0=C2=A0 Note1: System memory can be used as an extra p=
lacement if the
> kernel
> =C2=A0 *=C2=A0=C2=A0=C2=A0 should spill the allocation to system memory, =
if space can't
> be made
> =C2=A0 *=C2=A0=C2=A0=C2=A0 available in the CPU accessible part of VRAM (=
giving the same
> @@ -781,6 +784,10 @@ struct drm_xe_device_query {
> =C2=A0 *=C2=A0=C2=A0=C2=A0 need to use VRAM for display surfaces, therefo=
re the kernel
> requires
> =C2=A0 *=C2=A0=C2=A0=C2=A0 setting this flag for such objects, otherwise =
an error is
> thrown on
> =C2=A0 *=C2=A0=C2=A0=C2=A0 small-bar systems.
> + *=C2=A0=C2=A0=C2=A0 Note3: %DRM_XE_GEM_CREATE_FLAG_PINNED requires the =
BO to have
> only
> + *=C2=A0=C2=A0=C2=A0 a single placement, no vm_id, requires (device) mem=
ory cgroups
> enabled,
> + *=C2=A0=C2=A0=C2=A0 and is incompatible with the %DEFER_BACKING and
> %NEEDS_VISIBLE_VRAM
> + *=C2=A0=C2=A0=C2=A0 flags.
> =C2=A0 *
> =C2=A0 * @cpu_caching supports the following values:
> =C2=A0 *=C2=A0 - %DRM_XE_GEM_CPU_CACHING_WB - Allocate the pages with wri=
te-
> back
> @@ -827,6 +834,7 @@ struct drm_xe_gem_create {
> =C2=A0#define DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING		(1 << 0)
> =C2=A0#define DRM_XE_GEM_CREATE_FLAG_SCANOUT			(1 << 1)
> =C2=A0#define DRM_XE_GEM_CREATE_FLAG_NEEDS_VISIBLE_VRAM	(1 << 2)
> +#define DRM_XE_GEM_CREATE_FLAG_PINNED			(1 << 3)
> =C2=A0	/**
> =C2=A0	 * @flags: Flags, currently a mask of memory instances of
> where BO can
> =C2=A0	 * be placed


