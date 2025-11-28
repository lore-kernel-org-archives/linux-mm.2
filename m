Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE1CD116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34886B0092; Fri, 28 Nov 2025 13:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4A06B0093; Fri, 28 Nov 2025 13:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD42F6B0095; Fri, 28 Nov 2025 13:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5AA96B0092
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:19:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9290CBAD55
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:19:09 +0000 (UTC)
X-FDA: 84160827618.21.F26491F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id ABBA780009
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:19:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="WSWsz7T/";
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764353948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqByGLx+ZnzuDp4iiuF3nGgGVwltdDx/D1ftF3au4pY=;
	b=tKIRDu5eQrf1YnPRR8zK0q1A4jcoiQKKgJeE2tY57N7SRvCqQlgj1DhUX1+jScuzEOoEvU
	pTVlk+6HUofehzvdPB9EO++hkqWe4WIx+PxynkmsTQVhrcJGPbZWnihOi7eUaryTBHwjs3
	4sTGJpW4Qa+zETbnWvh6JKV+gRE610U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="WSWsz7T/";
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764353948; a=rsa-sha256;
	cv=none;
	b=A1ehjezjz+iFuBXkeKujEZkYI/gYQS+cp6rDjUF3y4UpOl2byL2rC9fvAKgmMydvHKbNGK
	FHAlcDKwY/mRNdjOryM5ZXe5cQtbDMmwkZOZyvgnKhdoFLzGygFbIm80uojzfiuo3e3Dku
	yYHXxU0Jfu5okCU1u2rk2ARLnvHBJ4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764353945;
	bh=D5R1R40lbideVzmASkbHJ+gHLI9Htdhg6MTSqRr2Qzk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WSWsz7T/sjVOoTY/5nfXwZRHu4rhkNDL6DITqGjsmhgwx2hz6hSZAE6ctMOlnxnJF
	 sNXxWZpdtwjuSyYyXpJjJsWQHzlBP9gr2NMAFsuLkz4nkUo7ZkNxbotLciH7qjoMiu
	 a5Jg3BwHxG8zejOGDy7gle6vZvDHWSf2TGd1JXgr/XVXpcjI7tWU1A2KzG+ZG8Kt8P
	 P5OLAuPoFNWq6/2+Rr3Nw5+0eEIz/j/Qt0KADYHVQ9M8EyeAAJEfvwxI3EjivQA6uF
	 pLqciabzg+8vJB6ZKhUg8xveL+owX+GAjrQfdk+M21Hxo19z318Glzqmp/Ihy4+65w
	 dt66CVMfQ7AYg==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0701417E06C3;
	Fri, 28 Nov 2025 19:19:03 +0100 (CET)
Message-ID: <411f7b0f-858c-4486-8819-c01b29cc123a@collabora.com>
Date: Fri, 28 Nov 2025 19:19:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
To: Tvrtko Ursulin <tursulin@ursulin.net>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251114170303.2800-1-loic.molinari@collabora.com>
 <20251114170303.2800-7-loic.molinari@collabora.com>
 <75cf65a0-8967-4e39-8bfe-aa284f8242b3@ursulin.net>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <75cf65a0-8967-4e39-8bfe-aa284f8242b3@ursulin.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u4uph55k38qfrfr5k9uxzd4dkfzakpzy
X-Rspam-User: 
X-Rspamd-Queue-Id: ABBA780009
X-Rspamd-Server: rspam09
X-HE-Tag: 1764353947-680324
X-HE-Meta: U2FsdGVkX1/MwnlnrkBkCWbT+0slCh2eU/JSebQ1ewdOr2ZFxyLyDbWDqj1pCzXz3wzkK8uCxmmiasgmf2u7XyX131YZMGEX3/6Jxz2fymwSGvoEY8yEd71yQHg+5aYQKHOiR0vQhyEHyv57Ef9lLn+I0iYFAywoFnYjfhD2cSkpmo/dNPokgFzBLBlGQclhZypm/+ymNQrcoW7U/mOzW6qz6NwgLeLYs8nTRCWRBsbheokVO/fgP55tI6m5bMqkgj7P9H9l/kw14+ShzTsrYA5Xa/ms54QRe9qC95riKYK8TfNvUcp3+Mhf8Y1fAwmSkbz0Dtb07566rNhjrNsFkK5aG69r8zU5sfjrg/mcNYO1bWmets/P/NrLnVXQQpSn+4lhLG0l3/D0PBAxnt3jFPRNsN78XvuJzXNVlkeV8+UhwdbSDK2cTRXtIwa7q55y3nqagLnCs8FAZLyEGeN03KQTsRP7s2vilGooeU5xtP/xlWx4YzEZp8VmQB7daMRtut2j+pMSuaG3SiLv/Mc65NeebEnRmFP06N7uHmw4L1bRBnttI8GJVXnxSwujIcqysf+EBRWhk6EMr1JUkuJ6LigyCqMAjm/eTuOKO6P//5FOz8XfXwbNk2qSoddrjjbJl/nwCl7gLm0SBXYNdxm/bv2OaIcWCQ9VempND7lnrQtQqc3OEC1I15bEL9C0161UYC72JTn4B9dYmNQbXb0L93tiEJbyq0Hm9DhZhsQsFAhjUHuW92/9QjS59H96yQyjsc2mrpCrrIdE19sAJmPqEqfuya+b4rA13pPvkyCSoyIdnJ6BLHdWaPQyMxxxMo/C1BNzanhueyBd1nkJ8FLRJPvuYNFA9A7SLa8R3SWi+G3h98wnvcpExGCCPsnEAxJeZrKVvX7gl1zNJqUsitFuiw2Db4z/ErxwaDOq0/qWTE+RO86so157v1Uqsu0RCBwm2Z4VICDGpO+n3cKiM3+
 5T2emKkO
 HgFTFOV4Ms28vQJvcinKCohSH4F0ozKpzDxKK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/11/2025 10:39, Tvrtko Ursulin wrote:
> 
> On 14/11/2025 17:02, Loïc Molinari wrote:
>> Make use of the new drm_gem_huge_mnt_create() and
>> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
>> it's just a few lines long, the single function in v3d_gemfs.c is
>> moved into v3d_gem.c.
>>
>> v3:
>> - use huge tmpfs mountpoint in drm_device
>> - move v3d_gemfs.c into v3d_gem.c
>>
>> v4:
>> - clean up mountpoint creation error handling
>>
>> v5:
>> - fix CONFIG_TRANSPARENT_HUGEPAGE check
>> - use drm_gem_has_huge_mnt() helper
>>
>> v8:
>> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n
>>
>> v9:
>> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> ---
>>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>>   drivers/gpu/drm/v3d/v3d_bo.c    |  9 +++--
>>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>>   drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>>   6 files changed, 34 insertions(+), 80 deletions(-)
>>   delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
>>
>> diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
>> index fcf710926057..b7d673f1153b 100644
>> --- a/drivers/gpu/drm/v3d/Makefile
>> +++ b/drivers/gpu/drm/v3d/Makefile
>> @@ -13,8 +13,7 @@ v3d-y := \
>>       v3d_trace_points.o \
>>       v3d_sched.o \
>>       v3d_sysfs.o \
>> -    v3d_submit.o \
>> -    v3d_gemfs.o
>> +    v3d_submit.o
>>   v3d-$(CONFIG_DEBUG_FS) += v3d_debugfs.o
>> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
>> index d9547f5117b9..211578abf9b6 100644
>> --- a/drivers/gpu/drm/v3d/v3d_bo.c
>> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
>> @@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>>       if (IS_ERR(sgt))
>>           return PTR_ERR(sgt);
>> -    if (!v3d->gemfs)
>> +    if (!drm_gem_get_huge_mnt(obj->dev))
>>           align = SZ_4K;
>>       else if (obj->size >= SZ_1M)
>>           align = SZ_1M;
>> @@ -150,12 +150,15 @@ struct v3d_bo *v3d_bo_create(struct drm_device 
>> *dev, struct drm_file *file_priv,
>>                    size_t unaligned_size)
>>   {
>>       struct drm_gem_shmem_object *shmem_obj;
>> -    struct v3d_dev *v3d = to_v3d_dev(dev);
>>       struct v3d_bo *bo;
>>       int ret;
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>       shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
>> -                          v3d->gemfs);
>> +                          dev->huge_mnt);
>> +#else
>> +    shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
>> +#endif
> 
> Don't you want to use the same pattern not requiring #ifdef as you did 
> in i915?

Yes, I'm going to propose a v10 doing so.

> The rest looks good to me on a glance. Only functional change appears to 
> be that you are adding a new error message, scrolling down..
> 
>>       if (IS_ERR(shmem_obj))
>>           return ERR_CAST(shmem_obj);
>>       bo = to_v3d_bo(&shmem_obj->base);
>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/ 
>> v3d_drv.c
>> index e8a46c8bad8a..8faa9382846f 100644
>> --- a/drivers/gpu/drm/v3d/v3d_drv.c
>> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
>> @@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device 
>> *dev, void *data,
>>           args->value = v3d->perfmon_info.max_counters;
>>           return 0;
>>       case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
>> -        args->value = !!v3d->gemfs;
>> +        args->value = !!drm_gem_get_huge_mnt(dev);
>>           return 0;
>>       case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
>>           mutex_lock(&v3d->reset_lock);
>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/ 
>> v3d_drv.h
>> index 1884686985b8..99a39329bb85 100644
>> --- a/drivers/gpu/drm/v3d/v3d_drv.h
>> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
>> @@ -158,11 +158,6 @@ struct v3d_dev {
>>       struct drm_mm mm;
>>       spinlock_t mm_lock;
>> -    /*
>> -     * tmpfs instance used for shmem backed objects
>> -     */
>> -    struct vfsmount *gemfs;
>> -
>>       struct work_struct overflow_mem_work;
>>       struct v3d_queue_state queue[V3D_MAX_QUEUES];
>> @@ -569,6 +564,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
>>   struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum 
>> v3d_queue q);
>>   /* v3d_gem.c */
>> +extern bool super_pages;
>>   int v3d_gem_init(struct drm_device *dev);
>>   void v3d_gem_destroy(struct drm_device *dev);
>>   void v3d_reset_sms(struct v3d_dev *v3d);
>> @@ -576,11 +572,6 @@ void v3d_reset(struct v3d_dev *v3d);
>>   void v3d_invalidate_caches(struct v3d_dev *v3d);
>>   void v3d_clean_caches(struct v3d_dev *v3d);
>> -/* v3d_gemfs.c */
>> -extern bool super_pages;
>> -void v3d_gemfs_init(struct v3d_dev *v3d);
>> -void v3d_gemfs_fini(struct v3d_dev *v3d);
>> -
>>   /* v3d_submit.c */
>>   void v3d_job_cleanup(struct v3d_job *job);
>>   void v3d_job_put(struct v3d_job *job);
>> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/ 
>> v3d_gem.c
>> index 5a180dc6c452..62532a89dd14 100644
>> --- a/drivers/gpu/drm/v3d/v3d_gem.c
>> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
>> @@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
>>       v3d_invalidate_slices(v3d, 0);
>>   }
>> +static void
>> +v3d_huge_mnt_init(struct v3d_dev *v3d)
>> +{
>> +    int err = 0;
>> +
>> +    /*
>> +     * By using a huge shmemfs mountpoint when the user wants to
>> +     * enable Super Pages, we can pass in mount flags that better
>> +     * match our usecase.
>> +     */
>> +
>> +    if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
>> +        err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
>> +
>> +    if (drm_gem_get_huge_mnt(&v3d->drm))
>> +        drm_info(&v3d->drm, "Using Transparent Hugepages\n");
>> +    else if (err)
>> +        drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
>> +             err);
> 
> .. here, but that looks acceptable to me.

It logs a warning instead of the notice below in case of error at huge 
mounpoint creation. Looks acceptable to me too. I'd be happy to get the 
point of view of a V3D maintainer as well here.

Regards,

Loïc

> Regards,
> 
> Tvrtko
> 
>> +    else
>> +        drm_notice(&v3d->drm,
>> +               "Transparent Hugepage support is recommended for 
>> optimal performance on this platform!\n");
>> +}
>> +
>>   int
>>   v3d_gem_init(struct drm_device *dev)
>>   {
>> @@ -310,7 +334,7 @@ v3d_gem_init(struct drm_device *dev)
>>       v3d_init_hw_state(v3d);
>>       v3d_mmu_set_page_table(v3d);
>> -    v3d_gemfs_init(v3d);
>> +    v3d_huge_mnt_init(v3d);
>>       ret = v3d_sched_init(v3d);
>>       if (ret) {
>> @@ -330,7 +354,6 @@ v3d_gem_destroy(struct drm_device *dev)
>>       enum v3d_queue q;
>>       v3d_sched_fini(v3d);
>> -    v3d_gemfs_fini(v3d);
>>       /* Waiting for jobs to finish would need to be done before
>>        * unregistering V3D.
>> diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/ 
>> v3d_gemfs.c
>> deleted file mode 100644
>> index bf351fc0d488..000000000000
>> --- a/drivers/gpu/drm/v3d/v3d_gemfs.c
>> +++ /dev/null
>> @@ -1,62 +0,0 @@
>> -// SPDX-License-Identifier: GPL-2.0+
>> -/* Copyright (C) 2024 Raspberry Pi */
>> -
>> -#include <linux/fs.h>
>> -#include <linux/mount.h>
>> -#include <linux/fs_context.h>
>> -
>> -#include <drm/drm_print.h>
>> -
>> -#include "v3d_drv.h"
>> -
>> -void v3d_gemfs_init(struct v3d_dev *v3d)
>> -{
>> -    struct file_system_type *type;
>> -    struct fs_context *fc;
>> -    struct vfsmount *gemfs;
>> -    int ret;
>> -
>> -    /*
>> -     * By creating our own shmemfs mountpoint, we can pass in
>> -     * mount flags that better match our usecase. However, we
>> -     * only do so on platforms which benefit from it.
>> -     */
>> -    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>> -        goto err;
>> -
>> -    /* The user doesn't want to enable Super Pages */
>> -    if (!super_pages)
>> -        goto err;
>> -
>> -    type = get_fs_type("tmpfs");
>> -    if (!type)
>> -        goto err;
>> -
>> -    fc = fs_context_for_mount(type, SB_KERNMOUNT);
>> -    if (IS_ERR(fc))
>> -        goto err;
>> -    ret = vfs_parse_fs_string(fc, "source", "tmpfs");
>> -    if (!ret)
>> -        ret = vfs_parse_fs_string(fc, "huge", "within_size");
>> -    if (!ret)
>> -        gemfs = fc_mount_longterm(fc);
>> -    put_fs_context(fc);
>> -    if (ret)
>> -        goto err;
>> -
>> -    v3d->gemfs = gemfs;
>> -    drm_info(&v3d->drm, "Using Transparent Hugepages\n");
>> -
>> -    return;
>> -
>> -err:
>> -    v3d->gemfs = NULL;
>> -    drm_notice(&v3d->drm,
>> -           "Transparent Hugepage support is recommended for optimal 
>> performance on this platform!\n");
>> -}
>> -
>> -void v3d_gemfs_fini(struct v3d_dev *v3d)
>> -{
>> -    if (v3d->gemfs)
>> -        kern_unmount(v3d->gemfs);
>> -}
> 


