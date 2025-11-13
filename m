Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 566D6CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90DD8E000C; Thu, 13 Nov 2025 11:56:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68DA8E0002; Thu, 13 Nov 2025 11:56:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E7A8E000C; Thu, 13 Nov 2025 11:56:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 948848E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:56:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6218189F30
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:56:52 +0000 (UTC)
X-FDA: 84106188264.20.E3911DE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59AB6100010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:56:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=FRtlNmSL;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053010; a=rsa-sha256;
	cv=none;
	b=AhvdnnXLD2rsihwiyjk5q3c8XQWJlwgFVhxh00vDOafCWH9ZHQZR6XKqWt285NyKZdGpMa
	VaKJgIE6URRvcpi/eZTCiKgM3pWqefpwRaaMKwVMZcbqpULApBYiyPUU6u5j6xAcWkc0ez
	IEV2mG4+uKUFxrPop+V6BOkxkn5o7k8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=FRtlNmSL;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLg2nVeuRiOS6duP44BugFtgKt3MpBy6TwjPVOa0bcw=;
	b=uaxOdiDxip/AxsymUSAFX8YbtUM8FSA2wkunPKtIiraXVWQIG6FVy3ocwKGsSz6m3GCEsN
	z2O9Ki9SCCsb0cs4bxzKnoQ1UE6ZItXAhy03wNRAOzcpyt7pfk6A50LiJjAjp5iKyHZC8m
	Q/DNFXnI3JwnysHIywQ/utCcpJzenXQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053007;
	bh=1+FQxddv+Gv2SejLN2zY1r/1JVvqwZUYXTD9m8oYsAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FRtlNmSLHDA/2Nv2mbXWXq2mTvHGE8tGj6zoETOXwrXJdjTpd31Xl6ief8OS/Xw4W
	 pA3FD1SGX24pFlTRJQtxD4eCRgHK77nVFLKP6M8jOjfdc/JXW04hxEGKhr63ZbmyRN
	 XDysbkSZ3wauE8MowoZAJEnobj4x4BTyEv9EEQ543kTlq1FqyxHvUS5+jN/vvHiYIj
	 a44S+S+VYspJmIlyCczIc86MMMwf4eRTaPIdXP2io/GNYx1aIs0o5SK8+QmJusqQCb
	 2QLtkOqRzdRr2e/BP0w2m/TL2UM0Zs9geH7XtyuwJLaCRed2dGh9CXP2Mx2Ks6UDHt
	 FXtlSeU/MMzoQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B311A17E04D6;
	Thu, 13 Nov 2025 17:56:46 +0100 (CET)
Message-ID: <7961866c-8809-4e8f-a070-484962964f41@collabora.com>
Date: Thu, 13 Nov 2025 17:56:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251110155000.2936-1-loic.molinari@collabora.com>
 <20251110155000.2936-7-loic.molinari@collabora.com>
 <20251112102507.66060e30@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251112102507.66060e30@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59AB6100010
X-Stat-Signature: yw3bwx4oz3zracbuisycemjieg9x7qhq
X-HE-Tag: 1763053010-473111
X-HE-Meta: U2FsdGVkX1+JJhy2V/5iY4LzEb6Zw4NyKaQXu5QH6q8gvZsb+qgTi+9KfcJIjCGJKLwUso1uiEqhCjwG0vFYQ+03mLYaf4Sp5W5OdXr+fpEL/1kgKVXoNq4TiZRJOgPeLCiuxnrxV91vEMINXd7NR8FFkTPnQ4dGVGp4p0KejMDh0DrfhlKHAzFRHswVHfQ6m4Za/IVsiCECcAYzl3IaGMrRkLijxbuf6p5K6GkX7J1uriSkvXrqpTJWtL5UpZEGbWXexJKvwXH0rSFmOMMlDbkvNK83iMpheaFR7X+FtGaGgBNjXbWssjgcoNT93AHV+ey2Urc8idsWz2ZfsH5lRXXWq0wuVTQpPgGkVid3hTKW+lAZ+GY7FofpF1gDueG5xq8OiRnIodtc20S+Hq5Ats35cnycQZ4UGSnCDAD7v3ieZMinB24H39pvAGLj/ZJA5r/karL8to6kiP26Mrw6EscT2g5pYGHEpihq4hgYb5WY8ZhlsQXFIYqx7n00FL3IR0xKtdAASocmm1/k3hFWhMCNaGO59RbnZfzcKEBlT8UCIW50Af6ENz8ZXnKy6kOLLlf/E2X+by09Pp9mahQT+lICt/cpWPt0Zq4XMVWi68RtiWikIoydi/F7+QXS1LMOK+6aHdjitia3PNblTf5d86QCF5ujORkpI/nVeAN+MacxU9LbIPMmd091VcMo8nUOdM+QZtF13knrwnwCoPwBfi5ahdGXfLIx3uIqKnHjeWMSAVQkxXfsQSMaoZSIaHHiV5nEB+6nCmn+ZZ73tPp1Ua50RuFYznIhJCs0tsou8mopCjra4IxTpYiY3xGGNrfARbUhyIcDCFY3Ww3kWAeWrMDWGQNWd+NeaJrld2RVjLN2UuOci2Lo5x9HtUcO3LocGlTTV+StS9pH3hHsHuRZ7u5vdpJoqqSvX8f6hl7MoOini5a8syt0ypZ74EJtxjmYQuD4PvX4KbKJauZ8SYZ
 9GEfquey
 fEYX6CjvgEK6h6mowr0cE7aOWClh9UgPIkMUl+34HDQ7xJ6t6NArdFSdHBQevJwBiWCmGayRWABqh7vT6MAlU5u1A7rnPK6cAYSWKJyhO6o0rjs6iQbknS7C/gR0rtvwC25ehTJxIf0PLSyVFw7QYnluM+FqJFkYTC3ukiJDHfsj+edvINdakOjNnQqCiwDkP8Ni1RfOOZsz60ceZxa5y2ev4En2WfsaKmjCRFFdK1xRyhXmJHwV/nzqqUKWkb5QikaO0p6gdW1uKBp9S8VPl/WUwA779UcZB3/yM0nwiZ1GXKjDZWerDcqCH3eOxy3xPxbEY6rnXR3YVk+n+1eyrvvENuPj1NVZBzufymK6dp1td9YWxZiDWKq6MQ1R+JaRSvdZoxwD+iuSLZBgF6tx/hJbhRgPaQr4DR05TnLq9eI1YLfT2eNvyB0RBycVvxeUlUlR6hM1vxaeSecSgLcPQutnRPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/2025 10:25, Boris Brezillon wrote:
> On Mon, 10 Nov 2025 16:49:54 +0100
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> Make use of the new drm_gem_huge_mnt_create() and
>> drm_gem_has_huge_mnt() helpers to avoid code duplication. Now that
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
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> ---
>>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>>   drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
>>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>>   drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>>   6 files changed, 30 insertions(+), 80 deletions(-)
>>   delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
>>
>> diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
>> index fcf710926057..b7d673f1153b 100644
>> --- a/drivers/gpu/drm/v3d/Makefile
>> +++ b/drivers/gpu/drm/v3d/Makefile
>> @@ -13,8 +13,7 @@ v3d-y := \
>>   	v3d_trace_points.o \
>>   	v3d_sched.o \
>>   	v3d_sysfs.o \
>> -	v3d_submit.o \
>> -	v3d_gemfs.o
>> +	v3d_submit.o
>>   
>>   v3d-$(CONFIG_DEBUG_FS) += v3d_debugfs.o
>>   
>> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
>> index d9547f5117b9..99c6a775d18b 100644
>> --- a/drivers/gpu/drm/v3d/v3d_bo.c
>> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
>> @@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>>   	if (IS_ERR(sgt))
>>   		return PTR_ERR(sgt);
>>   
>> -	if (!v3d->gemfs)
>> +	if (!drm_gem_has_huge_mnt(obj->dev))
>>   		align = SZ_4K;
>>   	else if (obj->size >= SZ_1M)
>>   		align = SZ_1M;
>> @@ -150,12 +150,11 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
>>   			     size_t unaligned_size)
>>   {
>>   	struct drm_gem_shmem_object *shmem_obj;
>> -	struct v3d_dev *v3d = to_v3d_dev(dev);
>>   	struct v3d_bo *bo;
>>   	int ret;
>>   
>>   	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
>> -						  v3d->gemfs);
>> +						  dev->huge_mnt);
> 
> I thought you needed some kind of drm_gem_huge_mnt() helper to cover
> for the fact drm_device::huge_mnt does not exist if
> CONFIG_TRANSPARENT_HUGEPAGE=n.

Ah right. For this one in v8, I've just added a temporary ifdef that 
gets removed in the next commit while getting rif of the *_with_mnt 
functions.

> 
>>   	if (IS_ERR(shmem_obj))
>>   		return ERR_CAST(shmem_obj);
>>   	bo = to_v3d_bo(&shmem_obj->base);
>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
>> index e8a46c8bad8a..30b55a00eeda 100644
>> --- a/drivers/gpu/drm/v3d/v3d_drv.c
>> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
>> @@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
>>   		args->value = v3d->perfmon_info.max_counters;
>>   		return 0;
>>   	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
>> -		args->value = !!v3d->gemfs;
>> +		args->value = drm_gem_has_huge_mnt(dev);
>>   		return 0;
>>   	case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
>>   		mutex_lock(&v3d->reset_lock);
>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
>> index 1884686985b8..99a39329bb85 100644
>> --- a/drivers/gpu/drm/v3d/v3d_drv.h
>> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
>> @@ -158,11 +158,6 @@ struct v3d_dev {
>>   	struct drm_mm mm;
>>   	spinlock_t mm_lock;
>>   
>> -	/*
>> -	 * tmpfs instance used for shmem backed objects
>> -	 */
>> -	struct vfsmount *gemfs;
>> -
>>   	struct work_struct overflow_mem_work;
>>   
>>   	struct v3d_queue_state queue[V3D_MAX_QUEUES];
>> @@ -569,6 +564,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
>>   struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
>>   
>>   /* v3d_gem.c */
>> +extern bool super_pages;
>>   int v3d_gem_init(struct drm_device *dev);
>>   void v3d_gem_destroy(struct drm_device *dev);
>>   void v3d_reset_sms(struct v3d_dev *v3d);
>> @@ -576,11 +572,6 @@ void v3d_reset(struct v3d_dev *v3d);
>>   void v3d_invalidate_caches(struct v3d_dev *v3d);
>>   void v3d_clean_caches(struct v3d_dev *v3d);
>>   
>> -/* v3d_gemfs.c */
>> -extern bool super_pages;
>> -void v3d_gemfs_init(struct v3d_dev *v3d);
>> -void v3d_gemfs_fini(struct v3d_dev *v3d);
>> -
>>   /* v3d_submit.c */
>>   void v3d_job_cleanup(struct v3d_job *job);
>>   void v3d_job_put(struct v3d_job *job);
>> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
>> index 5a180dc6c452..f316f67364d2 100644
>> --- a/drivers/gpu/drm/v3d/v3d_gem.c
>> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
>> @@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
>>   	v3d_invalidate_slices(v3d, 0);
>>   }
>>   
>> +static void
>> +v3d_huge_mnt_init(struct v3d_dev *v3d)
>> +{
>> +	int err = 0;
>> +
>> +	/*
>> +	 * By using a huge shmemfs mountpoint when the user wants to
>> +	 * enable Super Pages, we can pass in mount flags that better
>> +	 * match our usecase.
>> +	 */
>> +
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
>> +		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
>> +
>> +	if (drm_gem_has_huge_mnt(&v3d->drm))
>> +		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
>> +	else if (err)
>> +		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
>> +			 err);
>> +	else
>> +		drm_notice(&v3d->drm,
>> +			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
>> +}
>> +
>>   int
>>   v3d_gem_init(struct drm_device *dev)
>>   {
>> @@ -310,7 +334,7 @@ v3d_gem_init(struct drm_device *dev)
>>   	v3d_init_hw_state(v3d);
>>   	v3d_mmu_set_page_table(v3d);
>>   
>> -	v3d_gemfs_init(v3d);
>> +	v3d_huge_mnt_init(v3d);
>>   
>>   	ret = v3d_sched_init(v3d);
>>   	if (ret) {
>> @@ -330,7 +354,6 @@ v3d_gem_destroy(struct drm_device *dev)
>>   	enum v3d_queue q;
>>   
>>   	v3d_sched_fini(v3d);
>> -	v3d_gemfs_fini(v3d);
>>   
>>   	/* Waiting for jobs to finish would need to be done before
>>   	 * unregistering V3D.
>> diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
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
>> -	struct file_system_type *type;
>> -	struct fs_context *fc;
>> -	struct vfsmount *gemfs;
>> -	int ret;
>> -
>> -	/*
>> -	 * By creating our own shmemfs mountpoint, we can pass in
>> -	 * mount flags that better match our usecase. However, we
>> -	 * only do so on platforms which benefit from it.
>> -	 */
>> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>> -		goto err;
>> -
>> -	/* The user doesn't want to enable Super Pages */
>> -	if (!super_pages)
>> -		goto err;
>> -
>> -	type = get_fs_type("tmpfs");
>> -	if (!type)
>> -		goto err;
>> -
>> -	fc = fs_context_for_mount(type, SB_KERNMOUNT);
>> -	if (IS_ERR(fc))
>> -		goto err;
>> -	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
>> -	if (!ret)
>> -		ret = vfs_parse_fs_string(fc, "huge", "within_size");
>> -	if (!ret)
>> -		gemfs = fc_mount_longterm(fc);
>> -	put_fs_context(fc);
>> -	if (ret)
>> -		goto err;
>> -
>> -	v3d->gemfs = gemfs;
>> -	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
>> -
>> -	return;
>> -
>> -err:
>> -	v3d->gemfs = NULL;
>> -	drm_notice(&v3d->drm,
>> -		   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
>> -}
>> -
>> -void v3d_gemfs_fini(struct v3d_dev *v3d)
>> -{
>> -	if (v3d->gemfs)
>> -		kern_unmount(v3d->gemfs);
>> -}
> 


