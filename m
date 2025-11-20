Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9E6CF857E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471E56B00A1; Thu, 20 Nov 2025 04:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBDE6B00A3; Thu, 20 Nov 2025 04:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E2E6B00AE; Thu, 20 Nov 2025 04:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF796B00A1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:40:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB59013BB3D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:40:00 +0000 (UTC)
X-FDA: 84130488960.15.C4F54B0
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7A83C000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:39:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=wYlkjAf0;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=tursulin@ursulin.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763631598; a=rsa-sha256;
	cv=none;
	b=7kINt1PIgujNcUcuHhuv/e5IOmdEHhlna+RoUcHx0odKf9Ast2fMYfeFAVnlKJseD9zxKO
	pcKdIAABnVBw/JhSN3wq1UpVNjccKrU01eCuj0oD7UAzjWaB7u7/WMascrOlwO5F6g6dj1
	Ttuvt1lrh/yypFcbH7Nva7GB8dHryqk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=wYlkjAf0;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.128.43 as permitted sender) smtp.mailfrom=tursulin@ursulin.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6D2T/swrfGwwYIubUbU67Re0aJ0OQCaQcEzYhgb7k8=;
	b=A4dfSUj/xf+GhJBi56bgv/RppIQ/tb6W3JtFPvnkQ2aFTe3ZIzzSDkwm4Po/zf3FbcioQc
	GPy3YzijI1rFJy3YmDdZPej4VlfCkE8PRoa0A6Cbcbf8l4B2ZCnll4oF76UxoZ4AyOWT2L
	ZkOfjkqPWBf8zdH4IzRvnXwdjxpepQA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477aa218f20so4083615e9.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin.net; s=google; t=1763631597; x=1764236397; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U6D2T/swrfGwwYIubUbU67Re0aJ0OQCaQcEzYhgb7k8=;
        b=wYlkjAf0LAUacTwGw4J+wx8o5PUDK2usYi98mt/wKJhUHeiS7r8BxUKL7+VgH2h5mu
         YVgGvingxSUx45ogDqHTII0M5ttS+hp7D2KBBZbnVSeT3tYH/AMXGuNBtzm+dbZCz8xU
         0g8bSMVtIrX8Wu27I2TJFz1Jk7qj48Bx+FG/mNG5E4m1LvETT59Rub6JJYKzwhlVQTRE
         tvR6wWxuSoCc/tD4hHJteT1792kXhracmmLqvuuXx1lEUMXnI8i1Ba7vDa+dKtuPMjyh
         f1hs0NK3Gzt+uqh/khQGIovDaCDt5oOpltMFExBWKXwNYFppRTHaC56k23i8ffUxtuyi
         SPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763631597; x=1764236397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U6D2T/swrfGwwYIubUbU67Re0aJ0OQCaQcEzYhgb7k8=;
        b=Tp5Q4OBubcNbjOhg6ccozRtMtLEu0v6i1Y+xrJrC/vZF64WQq8MfisVlezyad+CMyn
         vb14cFiBpsvexD+aeVnhrf4gHUBabm70WPyO4ocqyRSk5JIDPsgJ2j/5BOSu1qAFxsMc
         KTlolKe91D9RgDP4N3fVOVvmikXHKBcWndonxVv926OOIa1/qWKkyS9f5foJOLNp+PBm
         EghYsr2L6GbAOBfnh7I1vd/TFEVA+ObFT2slX80KtF0Ogrmgw8xM3VRSkakfy6FBe6pE
         uFC1cOC6oabhdF7bH11x/hjkK0K3k2U3xZ/skL3nblvBLg+4nfInIRcNmOQRhib8jda6
         psuw==
X-Forwarded-Encrypted: i=1; AJvYcCWudlWwZBFXogea4WuMIge1L/GsgIVDqzyJ/ktvxcK+kyvBsKvoHu2Moi6ZQNUR61qRq3Z4YQO9dQ==@kvack.org
X-Gm-Message-State: AOJu0YwelL8f3+Nk0zh8C0W1CcL5ilrsp9SZFdQ63BNTvS3ahpF27+Lp
	XWiVy2X+hjdVYtvqHAurmZfKQCgW0ovvc7p/rUCgCQjh98Z7cxY2/6wWiTH5+EaYZzg=
X-Gm-Gg: ASbGnculNgMWqZWfdew2sPWZ3XOsHStWpRaw4mV895B4DP+hF3weR3lps3J5KeiNFz6
	oakPvNU2zsD+b9POxCskTZ2twX7WdSwPX6TfbN7b9QueXeUyg0eAJSiJqG9BJGC3+eCw0hQ6a7e
	FHnzGsYAY4A4zfbo9+A2ZVo/6AVHYHg4ue1p4hv0qXOietiAWe1ZzntijvBLCUFKqByVMq+UN8N
	5OD+l1BTA1w7aWpTsoWv2Xg6LKX9zqWCoY2QXZyMT0+ngRmD7EOjbpRzqF2tnyrFALBd1YrHU5N
	Kl57mIR1R4Wo666uXgtmpWV0INZj8a14I1iSuzNbUgpfTix8uM6R9e0O8jt6hf9ML/L1Y41mf7K
	Zmo5fSkwj2Or5t+aGQK8I539E0nEyXcp9P65tHeULj4o7cX8Bho4t3K8kAB0Zl+Uy8czpcMJu6D
	HzYXVXCwINn4GAg2JW2+qJ4W0tIhdf1WzvBja4a77Ei34=
X-Google-Smtp-Source: AGHT+IGOpmCt7r6aMgv0PofyN+s+ybvbGGWrGxrluj7E2hm4OOsNHntjgzS2fQRDmHRVqJS0JlWLYQ==
X-Received: by 2002:a05:600c:3550:b0:477:75eb:a643 with SMTP id 5b1f17b1804b1-477b9ddd8c4mr18898435e9.4.1763631596107;
        Thu, 20 Nov 2025 01:39:56 -0800 (PST)
Received: from [192.168.0.101] ([90.240.106.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b0ffd37bsm100308375e9.3.2025.11.20.01.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 01:39:55 -0800 (PST)
Message-ID: <75cf65a0-8967-4e39-8bfe-aa284f8242b3@ursulin.net>
Date: Thu, 20 Nov 2025 09:39:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
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
References: <20251114170303.2800-1-loic.molinari@collabora.com>
 <20251114170303.2800-7-loic.molinari@collabora.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20251114170303.2800-7-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7A83C000B
X-Stat-Signature: f5s3xop9ousni7ixmnzzkctybo3oubzw
X-HE-Tag: 1763631598-274819
X-HE-Meta: U2FsdGVkX19EE/WT2UQ0SsOhCP28yfEvLVD5Kn4wcKSCozquNier602WNO49PGOsF2gHZ/7aM2lbgVsp8ClIUzotR36ZChmnwx+Qm52FRsU52zJWBjxUP8wApNxCWXjRC/SgqNNp0763eIKJK0spPaIfGHdneK5rLa6TtqzNylGNJh7sv+xdQg08VkmMVjbRhdYLeKN78q5T+qcrP8w8edta0n2WoeYeS1ej2T5eJfy2wEMVrOafb5kmJSKfPgIXE5o5hjxItxLew/z1e7RU8FCGmNwmXQOSp3LNvZsbbPsefHylyEYalapLvqP7KwzDwR8sIRQJYyKmqTjoPZEQwZ9n6O7OmtK9lBbVqN1XvnmkAJtyoTb6g56oyc7rk9njTuOVz1KXfPSG9Noz3KlmE1pwtJHjlrY3p1qj+KNK56yof8eYVMu63KcMNq/in1MIWkUVS8SkXWeqNqp+XwCzg8lYxTbUPCiUyLpdpDgtPTFuLs/VduuSr4pirmZMw4+/P0jFkSw2ZT67tjT0mGR36+75ez72+anIhssL4e3CjJ23JlhGoX9uDM5tWgx5jkZhetXyd/NCtdPNk1rLgGsbKoL4x9Ne7F7hCEot9oOvXnTVcs6UsIYSA+zp/U6AbRWlRGpbEMCDLZPBpHH339ZJ1dU7tHCMQXdhvezjmH2OE+o6I/VNs0IqVEoI3p21SZ37qIOxUdfQ5lAjJWYQ7lZ9x+JFkkYRZxg1FK4pUc9NqxD5PPMnQYnDe27B7Uq7kn+ay+G0szPpqlzbIVAzu1SktzJAlTs+0rPgtvVy67Ejr+vfS7qp9MKapPBaGiwmgs7n/NKDTDQ4R6r6Lau/MwOedC9Mq1JBvYpLrPJDMQBB5VU5D/um3QMuXJYfChWkpO906bDUlW+FfdOeP22B+pg5j4BwON/FiHpVK1d3yzfp5O/OmEI1arPBnb4LK50Rl73m4LcnRvLAkgXuwqPbzgt
 CWgdEazk
 B2vsiXQcu+TtBZQT7iqUPETdpKsQH8/j/C277do0ZTvoGHkqLOnCPVpFyetQGRhfY2dBtaQ2wqjPi92v31X2qiTTc0OE38bR5nxWeDEfjWnhPmQPkBO/PH4+4iTqLH9LohalYQxjy6JxpsSBU32XjbBKKbUalJW1VHGCjfqCdENbEBp+F/bADvp33lLtAiWn9neXyKM1OFTf7PAyy/6dVCMJ+ryEFIN9B9es6CiXvnrvxMFYUyYlRtHTIB+RkVXQea/9QwZ5gxnYsXU7NwCDnrUqRRiZfFdxSg/WbA+3YUFbKzEWCcy99HTKALJi0PwHmjM6rsdf+r2eam/yR2HwqODJZjJl2V146rd8GxZkFMGvZTyWTJWhX2aVYz/Le/TsYFQMs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/11/2025 17:02, Loïc Molinari wrote:
> Make use of the new drm_gem_huge_mnt_create() and
> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
> it's just a few lines long, the single function in v3d_gemfs.c is
> moved into v3d_gem.c.
> 
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move v3d_gemfs.c into v3d_gem.c
> 
> v4:
> - clean up mountpoint creation error handling
> 
> v5:
> - fix CONFIG_TRANSPARENT_HUGEPAGE check
> - use drm_gem_has_huge_mnt() helper
> 
> v8:
> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n
> 
> v9:
> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> ---
>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>   drivers/gpu/drm/v3d/v3d_bo.c    |  9 +++--
>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>   drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>   6 files changed, 34 insertions(+), 80 deletions(-)
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
> index d9547f5117b9..211578abf9b6 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>   	if (IS_ERR(sgt))
>   		return PTR_ERR(sgt);
>   
> -	if (!v3d->gemfs)
> +	if (!drm_gem_get_huge_mnt(obj->dev))
>   		align = SZ_4K;
>   	else if (obj->size >= SZ_1M)
>   		align = SZ_1M;
> @@ -150,12 +150,15 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
>   			     size_t unaligned_size)
>   {
>   	struct drm_gem_shmem_object *shmem_obj;
> -	struct v3d_dev *v3d = to_v3d_dev(dev);
>   	struct v3d_bo *bo;
>   	int ret;
>   
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
> -						  v3d->gemfs);
> +						  dev->huge_mnt);
> +#else
> +	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
> +#endif

Don't you want to use the same pattern not requiring #ifdef as you did 
in i915?

The rest looks good to me on a glance. Only functional change appears to 
be that you are adding a new error message, scrolling down..

>   	if (IS_ERR(shmem_obj))
>   		return ERR_CAST(shmem_obj);
>   	bo = to_v3d_bo(&shmem_obj->base);
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
> index e8a46c8bad8a..8faa9382846f 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.c
> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
> @@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
>   		args->value = v3d->perfmon_info.max_counters;
>   		return 0;
>   	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
> -		args->value = !!v3d->gemfs;
> +		args->value = !!drm_gem_get_huge_mnt(dev);
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
> index 5a180dc6c452..62532a89dd14 100644
> --- a/drivers/gpu/drm/v3d/v3d_gem.c
> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
> @@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
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
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> +		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> +
> +	if (drm_gem_get_huge_mnt(&v3d->drm))
> +		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> +	else if (err)
> +		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
> +			 err);

.. here, but that looks acceptable to me.

Regards,

Tvrtko

> +	else
> +		drm_notice(&v3d->drm,
> +			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
> +}
> +
>   int
>   v3d_gem_init(struct drm_device *dev)
>   {
> @@ -310,7 +334,7 @@ v3d_gem_init(struct drm_device *dev)
>   	v3d_init_hw_state(v3d);
>   	v3d_mmu_set_page_table(v3d);
>   
> -	v3d_gemfs_init(v3d);
> +	v3d_huge_mnt_init(v3d);
>   
>   	ret = v3d_sched_init(v3d);
>   	if (ret) {
> @@ -330,7 +354,6 @@ v3d_gem_destroy(struct drm_device *dev)
>   	enum v3d_queue q;
>   
>   	v3d_sched_fini(v3d);
> -	v3d_gemfs_fini(v3d);
>   
>   	/* Waiting for jobs to finish would need to be done before
>   	 * unregistering V3D.
> diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
> deleted file mode 100644
> index bf351fc0d488..000000000000
> --- a/drivers/gpu/drm/v3d/v3d_gemfs.c
> +++ /dev/null
> @@ -1,62 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0+
> -/* Copyright (C) 2024 Raspberry Pi */
> -
> -#include <linux/fs.h>
> -#include <linux/mount.h>
> -#include <linux/fs_context.h>
> -
> -#include <drm/drm_print.h>
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


