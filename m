Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D855C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A145D8E0006; Tue,  5 Aug 2025 22:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC1A8E0001; Tue,  5 Aug 2025 22:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901DE8E0006; Tue,  5 Aug 2025 22:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2AC8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:40:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 269C8C030D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:40:09 +0000 (UTC)
X-FDA: 83744778138.03.4F57D66
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FD6E12000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:40:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcfRvDGK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of airlied@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=airlied@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754448007; a=rsa-sha256;
	cv=none;
	b=huit1xAd4O6VVVdO+0TViyQhU2aAjgvq0fqnMMefgYqv2xmhBr8O0ixwAsitDFkwvuus78
	S+pT0xIUpFkG4o2HYkVxemGDH3mZ8O/10LHlO9uXI940/keG2qOSWNRIOcDPjdhDMrQmZ9
	1PzA5ff1AOUzV60VSGGY0jGePflVG1k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcfRvDGK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of airlied@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=airlied@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754448007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tl6AWO4NGvDLUg53CSdZNaGpmRhmHGKVlO75uYRRw4=;
	b=uS7Z3zZbxcIYNuXMwg27OXp4fZxzIoG1M0t9gl7YKxxqskghIu8GtWavEPcsPdj5wpz+YG
	AxMJhOXnin9G3zLSKUKVIPrKh67H3OIQTfCo4lx/Oq7lQmMjIZvef0c+DIrqYKODkSeqah
	yJWPcvT47WpCdywIfoU2l79SMBQqlqc=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61592ff5ebbso10777508a12.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 19:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754448005; x=1755052805; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4tl6AWO4NGvDLUg53CSdZNaGpmRhmHGKVlO75uYRRw4=;
        b=VcfRvDGK3TnyanVmowluSveLU8VB5u7I5UK5YP64Yr2Dz+VftkuOlAf2JAVRzDSl6T
         LJJtV1v3RxF+Y75VzT/CARAxVfoxrrCi9YvgkTvqet03cmeLHnyXSwCCyeDG8PcDsCB3
         g/uqR7MD7RyW2OYJZHW7NDZN3CM6XkkxAXs6xL+jCvPvC+TAGrhfPwy+JFv3CoNBEqaf
         ampUuHLnIN5U1R5aHkWVZnAf+7kYSvZSluY1NblG5qM7eDfRSXmgCBR0pufMq/V33m+4
         3w4oQGbqwSYtZYVVDmr2qZIc7jNi6Uy68Q7WFq7so/gs7OxMbZBrWMvV3LiBObNufNr6
         4DBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754448005; x=1755052805;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4tl6AWO4NGvDLUg53CSdZNaGpmRhmHGKVlO75uYRRw4=;
        b=IqBZG8+tNyckUEdgum/hsTqF0RXU9aZnTfZvB3ObDzTlhc1SRBUmk0Lxib5P6CM7wF
         BUfw7+yToK+Aay9512Zu9PE5ws4ol6K5mz3CJS9/693f0i6bNb9RtGGgcqD39E+SBJIV
         HoXJIMIxqsGUcIbMjaJmfozYmt+9V37rfPFGrDbPoRuDS6vmqGr+p5hva7gL9P72Rcjm
         oAxiOm8z8sG7V56WxkhbF/ZoTC5CO2/Ok8vCsW+hEZTPrFVqXW4Wd2DNzwtR62AhCVGd
         g2j+AyYe3NPhw81JeHVGk03MYgZrQREtfxiVZ1ibBHu8VVLhY2OmuD8qdPH1ujNDhj1c
         XvVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtjpPFIEsXchrCMSWVPJogDLUlXWb4z3TPyEiFPPPwQ5Eg50TzVA7rvCv8MkwhufJcWZlFuyREFw==@kvack.org
X-Gm-Message-State: AOJu0YxOvsXEStQfPMFW3nBZ9fbgHnW5ynfoGnxM4YMUDmGbbPZmyppt
	gFHKPU4dm8SDSynJS+Whbld71989bKFfJzprrfCuHqo10YduJlqVXbPDwlSY218TrL6R+0w4E1R
	GfYnMGvo7s/2CJoaWCAiWqBzc6WNcc9A=
X-Gm-Gg: ASbGncsumwSXiYJTLaqqvlURNfv/gEeLBtSIgORdlD5um8ybu8BNJwHChSdheAdFkpq
	oOPdoDaFqH24X9b00AoqxM/uDb/KjQvnNfOAvahlOOwgaUZZgfU3Be5P2FeEZOgrhjmB5vRB0mq
	Yu6QrI+6uqULQcc91gwaezxtsa7vL/vyFYFuuWC8q8G5kSnKhAJxPt7+rRJa2N4+8WTaqSm8NSQ
	XWqcA==
X-Google-Smtp-Source: AGHT+IHUzPbhB+FsQo4ANKDBYpp5HH5S5LbgXu/87fhfM0uHKzU9yHSpGAIZ6vcgqmgxjPqDBMDO8JnPWJHBL15tH/A=
X-Received: by 2002:a17:906:4795:b0:ae3:a812:a780 with SMTP id
 a640c23a62f3a-af9904f1929mr97244466b.61.1754448005387; Tue, 05 Aug 2025
 19:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250714052243.1149732-1-airlied@gmail.com> <4a45548a-ad37-4778-b6de-1cda7ce258dc@linux.intel.com>
In-Reply-To: <4a45548a-ad37-4778-b6de-1cda7ce258dc@linux.intel.com>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 6 Aug 2025 12:39:51 +1000
X-Gm-Features: Ac12FXwIIk5wOVAGQikb4QIyJi-Rq9qSLmr6bSZoudOrhD8r0vAFxIPLW0ONur0
Message-ID: <CAPM=9twKRN=GXNhyUZEd4b7StCN8WuhG_h6BCZX+ONgSW268=g@mail.gmail.com>
Subject: Re: drm/ttm/memcg/lru: enable memcg tracking for ttm and amdgpu
 driver (complete series v2)
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Christian Koenig <christian.koenig@amd.com>, 
	Dave Chinner <david@fromorbit.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cztd7xd4urpp18u61ptrrya6z5jhsudz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FD6E12000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1754448007-731351
X-HE-Meta: U2FsdGVkX1/UedVdipTJHDhHJDBDx8m6yTirX5RR5AjJ509T6GGHs8CGrUty9A5uwLww2Pxq+BBv6YCN3YmZjTUUOdrmlWdWVCYdT0WEPS2HPPKqcr6eIVVuQzjWMQhSShdOxSynQVClPKvmcYmR2MVtBPAiosOUS3x4ZmXa5Fy8borvz+9VWEFBQyT0SXo/IxAgd5YVJkd4EH/CBCpUm5GPlFoemGayA7evrEo7DXG+hGCxCGv8827oyO8iQa87S5fVEI+cRDWJAez4CE37lUrKEMJlVh664hlCVNTpoJEOpoLHSZkOwyA8SoZpd5fRYYTZRdA5eGRSf010vuq0k6enysgQ8IIzM6yfELp7jBOLVlJ31pwTx/hnNCm5SQa4HI4T3/cAy7tPg5Op+SPCXVys+mplt7WwGAEkLPlk7RtKZ52CU1GDB039/9cyF8AeAMMs0Duhk3c9MB+Nd2g1r0BDP9+bjrs2CAo+tUsumpXUzgbSKVJuiFLBNHwRfqEEokkaTPmHhsDFhGEzZLNH2PN4JCoJobqU2UD1V5FFJkLpEWGLS7jiHgMsHqraGFKQbq8kGa8Zx2smNlx8868ZbVus5CBeFfHhSgT7RjD20aaNmMiCUfk0QnlW42XdemdWT+V0EDCBpb5xU368kdslMDMkKb45Y8LpfwRFY1Y9AdcRp+Bmk502M8Z5ladw7xsFWeKvC/hIAL7qTeVcVsJE9VsnmZiQOOsCTW6euFivl0AUeaJTsU5c4XdcMwt370HFkqPOluxafP0yu7tEDdpYCChbX7MjssEicn0aA5XO6lF6wEPjjMRZSazw8bQq+WJeD6iw1QE6bKlwqKfsuSUaX9PdQiNKCW5obRWnbgd5mAvWu8lQw/0G1opdizMOJfJFHfbs/OnErkttYQF6dLMR8f3ryugUGpVG+DciBrfojQq/j9xjy/9s8Wg/XaqvaizBn8c+ZSfr3fEbfdpv9Ib
 T6ZTmw7I
 l81iaJ0SYHY9OWMfjO0o1pZlZ3C0cJ+Sn7zp+esLY3VVxZLczZ+Z3UfTHV64HERLswxOw1C7IgUUD+XQ98tcfT2MGEyp3/3Ax9ayNy0j2IokbUm6MHoqFylAiUOSPTv2p8Oco9YevnGqHWCA3N+NdQah0aDKRQP8c3tfUCNK4Y9jRR5/3wwQtxAPSxyjiGaVPNxzWRN2GutszwrRJeJfGu0Tswa9MwdSf0A1s1EpI6ijnDBbyqdr2NELhS5VdxAxPHb6qXolL7RS5yyVLQOmjf6VIX/fs1/Dv+k6Byed3YiJmU1GwbXGGuW3SToQn+Gwdeeh71n8X/UTQrrEHuop5lCqdOSY+Xi7XxwEEzWhVAVvZ8x+mKzdBbtdAQW7O+dzuwiTlc0fXRcvRURgK8xPw1gDouKOEstXRuB+S7TegzY8Ev2FPwQ5tH+Q97g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 5 Aug 2025 at 20:58, Maarten Lankhorst
<maarten.lankhorst@linux.intel.com> wrote:
>
> Hey,
>
> Den 2025-07-14 kl. 07:18, skrev Dave Airlie:
> > Hi all,
> >
> > This is a repost with some fixes and cleanups.
> >
> > Differences since last posting:
> > 1. Added patch 18: add a module option to allow pooled pages to not be stored in the lru per-memcg
> >    (Requested by Christian Konig)
> > 2. Converged the naming and stats between vmstat and memcg (Suggested by Shakeel Butt)
> > 3. Cleaned up the charge/uncharge code and some other bits.
> >
> > Dave.
> >
> > Original cover letter:
> > tl;dr: start using list_lru/numa/memcg in GPU driver core and amdgpu driver for now.
> >
> > This is a complete series of patches, some of which have been sent before and reviewed,
> > but I want to get the complete picture for others, and try to figure out how best to land this.
> >
> > There are 3 pieces to this:
> > 01->02: add support for global gpu stat counters (previously posted, patch 2 is newer)
> > 03->07: port ttm pools to list_lru for numa awareness
> > 08->14: add memcg stats + gpu apis, then port ttm pools to memcg aware list_lru and shrinker
> > 15->17: enable amdgpu to use new functionality.
> >
> > The biggest difference in the memcg code from previously is I discovered what
> > obj cgroups were designed for and I'm reusing the page/objcg intergration that
> > already exists, to avoid reinventing that wheel right now.
> >
> > There are some igt-gpu-tools tests I've written at:
> > https://gitlab.freedesktop.org/airlied/igt-gpu-tools/-/tree/amdgpu-cgroups?ref_type=heads
> >
> > One problem is there are a lot of delayed action, that probably means the testing
> > needs a bit more robustness, but the tests validate all the basic paths.
> >
> > Regards,
> > Dave.
> >
> Patch below to enable on xe as well, I ran into some issues though when testing.
> After shutting down gdm3/sddm, I ran into a null dereference in mem_cgroup_uncharge_gpu_page()
> from ttm_pool_free_page(), presumably because of the objects that were created without a
> cgroup set. I tried to fix it in mem_cgroup_uncharge_gpu_page() by conditionally calling
> refill_stock(), but that ran into an underflow instead.

there should be a check if memcg is not NULL before calling into
refill, where are you seeing the underflow?

Thanks for the patch, I've booted one of my meteorlake systems with
this applied to forcing xe, and it seems to be working in my basic
testing so far.

Dave.

>
> Anyway, patch for xe below:
> ----->8-----------
> drm/xe: Enable memcg accounting for TT/system
>
> Create a flag to enable memcg accounting for XE as well.
>
> Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
>
> diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
> index 867087c2d1534..fd93374967c9e 100644
> --- a/drivers/gpu/drm/xe/xe_bo.c
> +++ b/drivers/gpu/drm/xe/xe_bo.c
> @@ -54,6 +54,7 @@ static const struct ttm_place sys_placement_flags = {
>         .flags = 0,
>  };
>
> +/* TTM_PL_FLAG_MEMCG is not set, those placements are used for eviction */
>  static struct ttm_placement sys_placement = {
>         .num_placement = 1,
>         .placement = &sys_placement_flags,
> @@ -188,6 +189,7 @@ static void try_add_system(struct xe_device *xe, struct xe_bo *bo,
>
>                 bo->placements[*c] = (struct ttm_place) {
>                         .mem_type = XE_PL_TT,
> +                       .flags = TTM_PL_FLAG_MEMCG,
>                 };
>                 *c += 1;
>         }
> @@ -1696,6 +1698,8 @@ static void xe_ttm_bo_destroy(struct ttm_buffer_object *ttm_bo)
>
>  static void xe_gem_object_free(struct drm_gem_object *obj)
>  {
> +       struct xe_bo *bo = gem_to_xe_bo(obj);
> +
>         /* Our BO reference counting scheme works as follows:
>          *
>          * The gem object kref is typically used throughout the driver,
> @@ -1709,8 +1713,9 @@ static void xe_gem_object_free(struct drm_gem_object *obj)
>          * driver ttm callbacks is allowed to use the ttm_buffer_object
>          * refcount directly if needed.
>          */
> -       __xe_bo_vunmap(gem_to_xe_bo(obj));
> -       ttm_bo_put(container_of(obj, struct ttm_buffer_object, base));
> +       __xe_bo_vunmap(bo);
> +       obj_cgroup_put(bo->ttm.objcg);
> +       ttm_bo_put(&bo->ttm);
>  }
>
>  static void xe_gem_object_close(struct drm_gem_object *obj,
> @@ -1951,6 +1956,9 @@ struct xe_bo *___xe_bo_create_locked(struct xe_device *xe, struct xe_bo *bo,
>         placement = (type == ttm_bo_type_sg ||
>                      bo->flags & XE_BO_FLAG_DEFER_BACKING) ? &sys_placement :
>                 &bo->placement;
> +
> +       if (bo->flags & XE_BO_FLAG_ACCOUNTED)
> +               bo->ttm.objcg = get_obj_cgroup_from_current();
>         err = ttm_bo_init_reserved(&xe->ttm, &bo->ttm, type,
>                                    placement, alignment,
>                                    &ctx, NULL, resv, xe_ttm_bo_destroy);
> @@ -2726,7 +2734,7 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
>         if (XE_IOCTL_DBG(xe, args->size & ~PAGE_MASK))
>                 return -EINVAL;
>
> -       bo_flags = 0;
> +       bo_flags = XE_BO_FLAG_ACCOUNTED;
>         if (args->flags & DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING)
>                 bo_flags |= XE_BO_FLAG_DEFER_BACKING;
>
> diff --git a/drivers/gpu/drm/xe/xe_bo.h b/drivers/gpu/drm/xe/xe_bo.h
> index 6134d82e80554..e44fc58d9a00f 100644
> --- a/drivers/gpu/drm/xe/xe_bo.h
> +++ b/drivers/gpu/drm/xe/xe_bo.h
> @@ -48,6 +48,7 @@
>  #define XE_BO_FLAG_GGTT2               BIT(22)
>  #define XE_BO_FLAG_GGTT3               BIT(23)
>  #define XE_BO_FLAG_CPU_ADDR_MIRROR     BIT(24)
> +#define XE_BO_FLAG_ACCOUNTED           BIT(25)
>
>  /* this one is trigger internally only */
>  #define XE_BO_FLAG_INTERNAL_TEST       BIT(30)
> diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
> index 540f044bf4255..4db3227d65c04 100644
> --- a/drivers/gpu/drm/xe/xe_lrc.c
> +++ b/drivers/gpu/drm/xe/xe_lrc.c
> @@ -1266,7 +1266,8 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
>         bo_flags = XE_BO_FLAG_VRAM_IF_DGFX(tile) | XE_BO_FLAG_GGTT |
>                    XE_BO_FLAG_GGTT_INVALIDATE;
>         if (vm && vm->xef) /* userspace */
> -               bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE;
> +               bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE |
> +                           XE_BO_FLAG_ACCOUNTED;
>
>         lrc->bo = xe_bo_create_pin_map(xe, tile, NULL, bo_size,
>                                        ttm_bo_type_kernel,
> diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
> index 5729e7d3e3356..569035630ffdf 100644
> --- a/drivers/gpu/drm/xe/xe_oa.c
> +++ b/drivers/gpu/drm/xe/xe_oa.c
> @@ -885,7 +885,7 @@ static int xe_oa_alloc_oa_buffer(struct xe_oa_stream *stream, size_t size)
>
>         bo = xe_bo_create_pin_map(stream->oa->xe, stream->gt->tile, NULL,
>                                   size, ttm_bo_type_kernel,
> -                                 XE_BO_FLAG_SYSTEM | XE_BO_FLAG_GGTT);
> +                                 XE_BO_FLAG_SYSTEM | XE_BO_FLAG_GGTT | XE_BO_FLAG_ACCOUNTED);
>         if (IS_ERR(bo))
>                 return PTR_ERR(bo);
>
> diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
> index 330cc0f54a3f4..efcd54ab75e92 100644
> --- a/drivers/gpu/drm/xe/xe_pt.c
> +++ b/drivers/gpu/drm/xe/xe_pt.c
> @@ -120,7 +120,8 @@ struct xe_pt *xe_pt_create(struct xe_vm *vm, struct xe_tile *tile,
>                    XE_BO_FLAG_IGNORE_MIN_PAGE_SIZE |
>                    XE_BO_FLAG_NO_RESV_EVICT | XE_BO_FLAG_PAGETABLE;
>         if (vm->xef) /* userspace */
> -               bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE;
> +               bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE |
> +                           XE_BO_FLAG_ACCOUNTED;
>
>         pt->level = level;
>         bo = xe_bo_create_pin_map(vm->xe, tile, vm, SZ_4K,
> diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
> index 10c8a1bcb86e8..fdf845bb717e0 100644
> --- a/drivers/gpu/drm/xe/xe_svm.c
> +++ b/drivers/gpu/drm/xe/xe_svm.c
> @@ -700,6 +700,7 @@ static int xe_drm_pagemap_populate_mm(struct drm_pagemap *dpagemap,
>         bo = xe_bo_create_locked(vr->xe, NULL, NULL, end - start,
>                                  ttm_bo_type_device,
>                                  (IS_DGFX(xe) ? XE_BO_FLAG_VRAM(vr) : XE_BO_FLAG_SYSTEM) |
> +                                XE_BO_FLAG_ACCOUNTED |
>                                  XE_BO_FLAG_CPU_ADDR_MIRROR);
>         if (IS_ERR(bo)) {
>                 err = PTR_ERR(bo);
>

