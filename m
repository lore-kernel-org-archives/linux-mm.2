Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88500CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE7048E000B; Mon, 20 Oct 2025 05:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEBE8E0002; Mon, 20 Oct 2025 05:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8A58E000B; Mon, 20 Oct 2025 05:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAD598E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:33:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47E071A07CD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:33:32 +0000 (UTC)
X-FDA: 84017979864.26.56355D0
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 438604000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:33:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=vIPyLY0q
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760952810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35P1VBGXpvybu0O/QguU3+ECEHWeEOmbTTq+p+G5dt8=;
	b=zw2gH8yO1Ky7D2h371PNv8Y6Z1oGqBavbcrEqXktbHXZWVndAVmaeejlI8e2OiIz77gnXW
	Phx7K1ixtrOThhX3WkDxFSQHB5cBOYWYJhxhct8eChM/PHOjoybKKoQ+exSxFc01WNIDK6
	fQD6mBMilKM+E6NfWoI8LX64oDldsWU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=vIPyLY0q;
	spf=none (imf27.hostedemail.com: domain of tursulin@ursulin.net has no SPF policy when checking 209.85.128.53) smtp.mailfrom=tursulin@ursulin.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760952810; a=rsa-sha256;
	cv=none;
	b=fwxS9UcBkRoHK3wKdBg/Vqm4iTZPZwG2cmoFxiPLw/qp+tQS2CgUG18K9O3YhxXYsFM8yw
	pdR3/A/UAZmdyZLTtl+SrPrWkSpATzoPssRLnhrzaXLatwRHCXoQO8O/K9nMeUNs8+xFWe
	n2j9jE9Qg/9DNuFYNdcL+Or1t2O22H0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4711810948aso26845465e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin-net.20230601.gappssmtp.com; s=20230601; t=1760952809; x=1761557609; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=35P1VBGXpvybu0O/QguU3+ECEHWeEOmbTTq+p+G5dt8=;
        b=vIPyLY0qtQe9nU5ArzNl736+JYD/nttWIHhlnL3TyzLOzfT+NLnu019A9ZUBWSr+SN
         rWLv2Rg/kkMtEHWAWS3FAgwwUX7+H9oXvMv7GYQMu+mO3s625r5ch1VRtybIARQ81ic4
         gtgb2t6y1XSMeMGocxwa0/++dAN2d8iW7ZQDNXuLEya+c2SW8uMhYArJpk1omTiUMcDN
         vrB3e0K5s/7NVU3ANgbiW16kc7raiCJsPVV553fJ8W5LtlvALrCjWI+ML4tE2yajNadK
         BXO8P54vwQ/Nqym6pJ4ICZMC8STO0+Ch8jVLJicZrpCHoune20MOEJfnzOwswI4YsBJE
         1LQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760952809; x=1761557609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=35P1VBGXpvybu0O/QguU3+ECEHWeEOmbTTq+p+G5dt8=;
        b=HIng+KKaq2APkWV/H9GKcpQPXM2+X4cHQidymPFV0ro43Gc8OLVcVUi4M44B+5CcfJ
         SNGreLC5oKRM/MkWgQjSYjNWRDVfYOZLNpGOgRdxmoEfMPDNl4a8pCk0fQP58VAmy9RR
         hYkZquCoqOPBPXgGYHNjCQRJOaSegC0Qg+2HrSdm/bf0AgGqJ5ZlpSV5pl3N/uXl9ldr
         obdjd3qYAXeLL2ujMRMB3/CGIc2tASn+fF9yRgyIV/8uxFwziPoDwkM6/Z1ZvpeYs0yR
         LRS+YhZGhi1/3TNHbrumuIxBaiErL8qu3s1PcDkraw2n2mkypcTcQm0mZir28jikf66N
         jvjA==
X-Forwarded-Encrypted: i=1; AJvYcCWB2cCusDJZPK+2VPwytSHNPYdWYoTUHZuywtvCF7d6nGpPW0LA2gfKfo7CEMDRIw+j9JZSbiveIw==@kvack.org
X-Gm-Message-State: AOJu0Yz4lvFliq5nvpBwzX9KnjmK0Vw7+P6B0VjePaWlxvJk769eP2Wu
	3XuX4piyQmMuQQAYsQM7lbkJfYvg9pS2eedvJsCyt/ntyF1oNA2LPdi/y0SQMaIe0hY=
X-Gm-Gg: ASbGnct92sG1YkEfKd4eOHARuAtU0nn4tAksCfUXOzjTWcDM2KfIieIdCLDc4FxXoKX
	YwxCHz7uqANSu4cZ9p8sTxHMeGe42vDyKFaO9lNtE3XgPpd3tAZ7YHvDdn9sD77i1KmN60JN38c
	UL+9fCXoABmvYq9/+gXuKw6UusIlEbfWc60CQIB9llinFij61Xl+NDWqo/0DMkM8M783/QnpEb8
	1XXpTdVB7YmEeGkqUb09c97LZg1SuRzTz9HibcAfLIjopSP/HqoEZyEo/dx/IPYIT7zdX7jooH6
	cqWW9voN3YrdrDSkUZwNtQiLbqXXK9rabK4REPUXi+IDXqR17MSma7JWPEmepcaIRawSwxrsTJh
	YNYbTjJPHCBI5dK1n5omaxR2MvfynX3Y1dPIHeB5kxAQ48a1G1a1d6yW4u0B+6/oDFx2DoYXGM4
	vM/VBzxV9TJfsq+1FUYoQOxZOdgg==
X-Google-Smtp-Source: AGHT+IGUDMR8mkIoFpUlAAdUP/6zPdVHLyL+h1bB5WDQD3WBZIgLWI1xtBdpKBPhcrO0v8yIyFyufw==
X-Received: by 2002:a05:600d:41cc:b0:471:13dd:baef with SMTP id 5b1f17b1804b1-4711791beadmr80450325e9.26.1760952808602;
        Mon, 20 Oct 2025 02:33:28 -0700 (PDT)
Received: from [192.168.0.101] ([90.242.12.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715520dd65sm134062965e9.15.2025.10.20.02.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:33:28 -0700 (PDT)
Message-ID: <0130b962-6cd7-4f2c-8fd0-809a21495e03@ursulin.net>
Date: Mon, 20 Oct 2025 10:33:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/13] drm/v3d: Use huge tmpfs mount point helper
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
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
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-8-loic.molinari@collabora.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20251015153018.43735-8-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 438604000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1xdkyxdgu395wuasc9d3mhdtf75b8xi6
X-HE-Tag: 1760952810-123245
X-HE-Meta: U2FsdGVkX19sQcBaoTPMfEFMEkC3zXRSzE4ayYGD/bikLypeL8xhhfpHgoBlm1UQYffP/vaCggMWpQoWmPOEezvse/s6qPzQnmkq08dLDvXTWoCl/C8tFULPjV/hbLeLD8fwzvo2rQxbrKxISyDXja9KAh5xCWC6PttdfcF29yrpJtotR352Jp98N2oa8L3XQSyhtskg9+fpGF060Ss0GG39X63NoRduajnVOtoJuz3MzMax8vTECp2ZjVTsIWBZsJxGai6/bIiAhCPZop0H/8YxiFo0D5HKs41UZs9ut0+XetvplIkdAFP9PYv217RJ/NsFBzwUpg9CpbguIDP/tHDnRsUcrsXn5qUhogOLZI7FG+Q2N5aOtUxbYEUP8IOOFtJvefcmJgvmRhvRb+mK8XVfWX+eAGmn0aj99j6sqnVhN+Si1CHcatRXGb9jEFaz6j7MoiqH4EtX7Xcp8Lq4dt1j6gDG00IGsA2a7v5bbHJ4ljPJmQQ6XwgCoKyUzQ2rbmUh/GHn1vrQUfyCprAqJ0bOKbcQCnwPa0rD2nJulHjm1G5s2O5u9zmgqHg1Wtbt5qGCtZM6C8EvG3jrR//rbLFlZehb2apJqjDjhJYJHmVSy5dSJ4VzReCYf9eFTqfVEVmKD2VXRn9AC1agX/8Kq8RgBk3vB14o3JOwJ3uNxWe0OgMdX7zat6P83S82NRfzPqNLE1IrivkYO3XKgyfLyvvS/iYjZ+SNi2AJ9beuAZb6T9gp/W9QF8IwJPz/mdk0tKddGFj2kQT+eGuNMfLXHW2rflToZyppVYseTD/+xnaojKEbPPvZnXBV6nHlYE/EwqN0FGiaP46g0PVC/M+KXd3xRv3fllVTEE7mvlKxgmWG0g7tsd5f8MIbZj3RBRa6kpFFw7D4snhBNuF3kRph1nXoNThcpXzV7FFbfobKgvnUf5MbvT9AvSdZqfcT77fkhe/K961t+OUQAZltzC7
 eq8yubWJ
 nvJPWO1duM1Ngaq+XdOLR5ppcuQnzjp1ipuATiJvMcMTPiZHkszwm0mtayq6Fm1IGy9IR3v5CCpnnkpSlrf/7dcP1YfxNL3ka5kO6Q6Go0u7Cy4oGAtwZnWokvbqRf/yhwz43497ZjYu76i9egmbRwxdddQ3IZ5sYt2nftWbk5MScq/IYLwydzTeSmUUNTIkoZ5t8yeFuRBZIBJUrXfncL4p8kgMq8kLP5OMdjIuLooM1X/EyWZ+f6OcYAry52jWZpyyn24x2xlJ4b3NWIbObrGqYPaBD8EgEXBiDvswZt8dowW/DJyntoVlTU6T8/ggsH61hILuP+1xh0DTx0dHIe1IvMAGMspdRZfC9ER8SVMM+Rk/WNo3UgaWLVIEnzHCHgfdcu3R7VHN0U6x58/41V/J2ADU3NK/KooiW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/2025 16:30, Loïc Molinari wrote:
> Make use of the new drm_gem_huge_mnt_create() helper to avoid code
> duplication. Now that it's just a few lines long, the single function
> in v3d_gemfs.c is moved into v3d_gem.c.
> 
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move v3d_gemfs.c into v3d_gem.c
> 
> v4:
> - clean up mountpoint creation error handling
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> ---
>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>   drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 +++++++++++++--
>   drivers/gpu/drm/v3d/v3d_gemfs.c | 60 ---------------------------------
>   6 files changed, 30 insertions(+), 78 deletions(-)
>   delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
> 
> diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
> index fcf710926057..b7d673f1153b 100644
> --- a/drivers/gpu/drm/v3d/Makefile
> +++ b/drivers/gpu/drm/v3d/Makefile
> @@ -13,8 +13,7 @@ v3d-y := \
>   	v3d_trace_points.o \
>   	v3d_sched.o \
>   	v3d_sysfs.o \
> -	v3d_submit.o \
> -	v3d_gemfs.o
> +	v3d_submit.o
>   
>   v3d-$(CONFIG_DEBUG_FS) += v3d_debugfs.o
>   
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index c41476ddde68..6b9909bfce82 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -112,7 +112,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>   	if (IS_ERR(sgt))
>   		return PTR_ERR(sgt);
>   
> -	if (!v3d->gemfs)
> +	if (!obj->dev->huge_mnt)

Maybe it would be a good idea to add a helper for this check. Keeping 
aligned with drm_gem_huge_mnt_create() something like 
drm_gem_has_huge_mnt()? That would then hide the optional drm_device 
struct member if you decide to go for that.

>   		align = SZ_4K;
>   	else if (obj->size >= SZ_1M)
>   		align = SZ_1M;
> @@ -148,12 +148,11 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
>   			     size_t unaligned_size)
>   {
>   	struct drm_gem_shmem_object *shmem_obj;
> -	struct v3d_dev *v3d = to_v3d_dev(dev);
>   	struct v3d_bo *bo;
>   	int ret;
>   
>   	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  v3d->gemfs);
> +						  dev->huge_mnt);

Okay this one goes away by the end of the series.

>   	if (IS_ERR(shmem_obj))
>   		return ERR_CAST(shmem_obj);
>   	bo = to_v3d_bo(&shmem_obj->base);
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
> index c5a3bbbc74c5..19ec0ea7f38e 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.c
> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
> @@ -106,7 +106,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
>   		args->value = v3d->perfmon_info.max_counters;
>   		return 0;
>   	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
> -		args->value = !!v3d->gemfs;
> +		args->value = !!dev->huge_mnt;
>   		return 0;
>   	case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
>   		mutex_lock(&v3d->reset_lock);
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
> index 1884686985b8..99a39329bb85 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> @@ -158,11 +158,6 @@ struct v3d_dev {
>   	struct drm_mm mm;
>   	spinlock_t mm_lock;
>   
> -	/*
> -	 * tmpfs instance used for shmem backed objects
> -	 */
> -	struct vfsmount *gemfs;
> -
>   	struct work_struct overflow_mem_work;
>   
>   	struct v3d_queue_state queue[V3D_MAX_QUEUES];
> @@ -569,6 +564,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
>   struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
>   
>   /* v3d_gem.c */
> +extern bool super_pages;
>   int v3d_gem_init(struct drm_device *dev);
>   void v3d_gem_destroy(struct drm_device *dev);
>   void v3d_reset_sms(struct v3d_dev *v3d);
> @@ -576,11 +572,6 @@ void v3d_reset(struct v3d_dev *v3d);
>   void v3d_invalidate_caches(struct v3d_dev *v3d);
>   void v3d_clean_caches(struct v3d_dev *v3d);
>   
> -/* v3d_gemfs.c */
> -extern bool super_pages;
> -void v3d_gemfs_init(struct v3d_dev *v3d);
> -void v3d_gemfs_fini(struct v3d_dev *v3d);
> -
>   /* v3d_submit.c */
>   void v3d_job_cleanup(struct v3d_job *job);
>   void v3d_job_put(struct v3d_job *job);
> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
> index bb110d35f749..635ff0fabe7e 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -258,6 +258,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
>   	v3d_invalidate_slices(v3d, 0);
>   }
>   
> +static void
> +v3d_huge_mnt_init(struct v3d_dev *v3d)
> +{
> +	int err = 0;
> +
> +	/*
> +	 * By using a huge shmemfs mountpoint when the user wants to
> +	 * enable Super Pages, we can pass in mount flags that better
> +	 * match our usecase.
> +	 */
> +
> +	if (super_pages)
> +		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");

If it is this patch that is creating the build failure then the two 
should be squashed.

Then in "drm/v3d: Fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n" this 
ends up a bit ugly:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
  	if (super_pages)
#endif
  		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");

Does this not work:

  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
  		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");

?

Regards,

Tvrtko

> +
> +	if (v3d->drm.huge_mnt)
> +		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> +	else if (err)
> +		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
> +			 err);
> +	else
> +		drm_notice(&v3d->drm,
> +			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
> +}
> +
>   int
>   v3d_gem_init(struct drm_device *dev)
>   {
> @@ -309,7 +333,7 @@ v3d_gem_init(struct drm_device *dev)
>   	v3d_init_hw_state(v3d);
>   	v3d_mmu_set_page_table(v3d);
>   
> -	v3d_gemfs_init(v3d);
> +	v3d_huge_mnt_init(v3d);
>   
>   	ret = v3d_sched_init(v3d);
>   	if (ret) {
> @@ -329,7 +353,6 @@ v3d_gem_destroy(struct drm_device *dev)
>   	enum v3d_queue q;
>   
>   	v3d_sched_fini(v3d);
> -	v3d_gemfs_fini(v3d);
>   
>   	/* Waiting for jobs to finish would need to be done before
>   	 * unregistering V3D.
> diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
> deleted file mode 100644
> index c1a30166c099..000000000000
> --- a/drivers/gpu/drm/v3d/v3d_gemfs.c
> +++ /dev/null
> @@ -1,60 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0+
> -/* Copyright (C) 2024 Raspberry Pi */
> -
> -#include <linux/fs.h>
> -#include <linux/mount.h>
> -#include <linux/fs_context.h>
> -
> -#include "v3d_drv.h"
> -
> -void v3d_gemfs_init(struct v3d_dev *v3d)
> -{
> -	struct file_system_type *type;
> -	struct fs_context *fc;
> -	struct vfsmount *gemfs;
> -	int ret;
> -
> -	/*
> -	 * By creating our own shmemfs mountpoint, we can pass in
> -	 * mount flags that better match our usecase. However, we
> -	 * only do so on platforms which benefit from it.
> -	 */
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		goto err;
> -
> -	/* The user doesn't want to enable Super Pages */
> -	if (!super_pages)
> -		goto err;
> -
> -	type = get_fs_type("tmpfs");
> -	if (!type)
> -		goto err;
> -
> -	fc = fs_context_for_mount(type, SB_KERNMOUNT);
> -	if (IS_ERR(fc))
> -		goto err;
> -	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
> -	if (!ret)
> -		ret = vfs_parse_fs_string(fc, "huge", "within_size");
> -	if (!ret)
> -		gemfs = fc_mount_longterm(fc);
> -	put_fs_context(fc);
> -	if (ret)
> -		goto err;
> -
> -	v3d->gemfs = gemfs;
> -	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> -
> -	return;
> -
> -err:
> -	v3d->gemfs = NULL;
> -	drm_notice(&v3d->drm,
> -		   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
> -}
> -
> -void v3d_gemfs_fini(struct v3d_dev *v3d)
> -{
> -	if (v3d->gemfs)
> -		kern_unmount(v3d->gemfs);
> -}


