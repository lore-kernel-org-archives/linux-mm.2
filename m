Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FC9CD5BA0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49E48E0007; Thu, 13 Nov 2025 03:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21328E0003; Thu, 13 Nov 2025 03:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36F28E0007; Thu, 13 Nov 2025 03:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF16B8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:32:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F60C1608D5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:32:11 +0000 (UTC)
X-FDA: 84104916462.04.674F984
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37E67100012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:32:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=k+3UTf4u;
	spf=pass (imf14.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.221.46 as permitted sender) smtp.mailfrom=tursulin@ursulin.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763022729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfukhjueqtZooUC/G//3QoUA+cHzS0R+6tZVZXxzXXs=;
	b=PKaOHDftUTf2q1/PloiMh6vWDySKB6EuZPtBoVw7zv3NcToHfgEAGpALshzZYuzjGr85gq
	p5druL4ufihlzRzmiXSqSuDv4OblDigxgn2XTp5Ztz8V7dTLTx30dnYeg7JD72y5xDIXAg
	nYmV2XyyGBv0zgdoAZi++/2vhyiFifA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763022729; a=rsa-sha256;
	cv=none;
	b=BelQ/QJQt2WSXhNteYoTkU555q3+r9o3fWkpLA8ke0y+r3W4RP4HmLxSm1L8fTgU3HMrfM
	yIl0VeZqKEmAZ0E4AV426DOIizX6XUYlkQhcN+JGWJa+FaGPBx7z2jvEV+TwnmPgReNiyi
	ui/lsxoUb2Xpbo3xGCkIUgTlXoiWnB4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=k+3UTf4u;
	spf=pass (imf14.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.221.46 as permitted sender) smtp.mailfrom=tursulin@ursulin.net;
	dmarc=none
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b2a0c18caso294420f8f.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin.net; s=google; t=1763022727; x=1763627527; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AfukhjueqtZooUC/G//3QoUA+cHzS0R+6tZVZXxzXXs=;
        b=k+3UTf4u8IWuYMFmHO/3S4GWA96UnTLk2xf07JAv38WSVFw3HEH3TQptCrkQdis3sv
         hYV0UQghhhNRhdid+/R6ci2v2nv/Ab32VfJzsUZB1SCH3NzqF0ekkyZqOtdErxvo91xc
         CtG1QqzDcaoyicuZRvbFNGKnxFXnS9YaHZJwcqdBNPFekRimhqB1FzThDmKcwLPIVSnZ
         e9us9aZIbUOfLCR02CzhQoHyIbKoPj8Z+DXiUONI3+hmY9q5UoVz3vyN5vl9OSEExnjS
         A9TWtLLaPu+B9clpbEB6JY+IcE+4lh4b9Zc7kF2VeRsgZ/6CGRiwqYS++/S3DuOEa/rr
         Ubog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763022727; x=1763627527;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AfukhjueqtZooUC/G//3QoUA+cHzS0R+6tZVZXxzXXs=;
        b=Vziq/Bn6e6bdmee/rDj8uAD43sH54fdp+QRJXuesi0z3migUKjA5llOKKZzlDeMU7m
         Y8kEnpMJPMXJq7xspWfbe1HZHZjiSGPdUlRWOWbkOT3kER8C0o7rpGdK9ryTPuIXQ+CN
         2aUlztvb5MxICNAkgA3+6QyvQaEHTRCUT/YPvVgOxYCGr6DQIHjzl2dT+rHJ1rk0ImL/
         lcGjwGVx2DZXiD+T4yXOvjlJUz8tcbaahWPSq3u0c3BqmLwf9wF+EYQgbUsjrVK6WqUm
         8Qt0rquxrzTRirLWGUuroMzCSsSNFpM0rE5xvpDF9Z/9zLZWpkMfwtTbTQFWx7pjWSfU
         gorg==
X-Forwarded-Encrypted: i=1; AJvYcCUGCTgICTl/tD0WmZzwayRtLuqbp4X3Sq8XGR+YxBLSx8CTvZuDW0o9nKhY0N0QmE9E9wH4wauhBw==@kvack.org
X-Gm-Message-State: AOJu0YwOa/z/mSuejw9TH1AQUTJQiZ7bkWdrMId02LtDb1jnXNE0iwic
	t3gaCkxRw0zbY3huXNA40OcGgTG2BSF7AF8Ltb8kE7NqFitRed93qXQGx8TfmQGcodg=
X-Gm-Gg: ASbGncuFU0tvmZXGgtFNN4pJT+nsDMSwAL0p6BGq51CrJ4o7Le1Ec4R9NozQ6mdkVgr
	FSFfJldll1LkzKvFkE0mB5Ihp95WuDOsMayYwtaZU7Bh0yZ3FM9Nc/EAQwOxlPdGtZb9bjz1G5v
	eOwSTbBTIA6pLJZdvkDYROaznqbLGUnOMEQzFHxsnJYnOsI35rEtSoA1E16KxoJUDSRjabZ4Q3F
	/kPJxpX9gFWo4YWnamDIkxEbBfHvC3TsCCWu1rVtN0ev0OJAoYxTlzYxWfoc7TXAAuDMfHDJLt/
	srNzT5ABLzWwANrP1bH1zsNGFovMx7LJHm0qle8bxhM2SeaeqD0Bfmu1Yx1wxUGSwUaWrI/rvUX
	viFU0vONZs82lCFujswVCP8R4vo1BjF0NTtSqabn+WrAmWDdTPpj0RftXqg0Io/NiFaU5XNDmf2
	Fxr7PDt7IzyEGQ3R67mTlHhRuuCouKHUAc
X-Google-Smtp-Source: AGHT+IH0c2l5RRE+V35m+0cvDUuaufSmqRTK85FmE16+vXzvxBENUBvWli2MnoVwwrZQ3zZ9MhCvfw==
X-Received: by 2002:a05:6000:401e:b0:42b:3dbe:3a54 with SMTP id ffacd0b85a97d-42b4bb98aa5mr4746433f8f.17.1763022727108;
        Thu, 13 Nov 2025 00:32:07 -0800 (PST)
Received: from [192.168.0.101] ([90.240.106.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85cc0sm2715644f8f.17.2025.11.13.00.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 00:32:06 -0800 (PST)
Message-ID: <4a311b00-9d69-4f0f-8b82-5f6b7c4c9a9f@ursulin.net>
Date: Thu, 13 Nov 2025 08:32:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/11] drm/i915: Use huge tmpfs mountpoint helpers
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
References: <20251110155000.2936-1-loic.molinari@collabora.com>
 <20251110155000.2936-6-loic.molinari@collabora.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20251110155000.2936-6-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37E67100012
X-Stat-Signature: kamhcttd9mycmqncxb9eun6mipjafmyj
X-Rspam-User: 
X-HE-Tag: 1763022729-475006
X-HE-Meta: U2FsdGVkX1/DYDFArTe1Zi79LBV0yr3APYXPJKuJ/Yi5ROO/+24BBFR2uiEZ/aVBiPYFwNmLOzWXPJDX0kj9q/6ig9y30O28dkQpYgMLFeNAnNo5TRnfmRxoom9s6wBMKJLGQZ+0EvT4Zefwj2tVyVCgpMAdojICvMyGYXhUdM2UoxKP1qAO0R0e/ovaRmMOXEsHJyecvzcpJo8nZjLI2oJzxVBTyocaGTv5U0ttAgihcBD6Hhs0iw/nnqXby62/3QHYu14S/dIh1afc3n3AECUP+rCUA6ODhQMQZS85/Z9ub4F4nVzXRMAu6UeUlwUmGwnADuIj3ijRP+OFxrL4VCs32fOJUWBWt6b/BQQ4wc48hL7LoN2TctJ7X2gDoiPpPHjcAI6QW3NHtdElfeyDYCS187NR7DMz81C7L/d3obc4FS6qKMEjPl8NRzraVgFU6dfYIy3AdKcb7/rbN3hJvC6kMt2WOpO3NrA5X3jMWrP9pI9tudq0L8T3GA8TJyyvj44vi3tvx9/d0FJBqIYNwwSdF14DZh4DZ8sF5v4UxH48rkNjs47x+/zdV8TMWbchWSOmPmej6yQGcFAr/4TNuPGzgMOUhCEWGnV7XZGTzdVEwqQJ5L3RNFPC997rucV+jeQH7BrbCGhWRvLK7y2GX5GOcbFUBex2HSCxYqrbcp0iDxaBzUX7w34yhGMSrZ0iVgN8H7LuuX+nDU8l+OmoC3Niq4bq0J6NPVGpGiJdkAYTpTJVmTmu1y3MwZ8SRLmjArlZ6RPLBmD/0ZuvDD3zxuMJxbwlcBcgDWTfuCDcREz9BmKhKNBob/seTCJgv0di4g0DlXKvu4ql9oJcbifHlX1kjFK1yITxkIa1OnyitmTUgYER1BbGeTLtVX2nO3nAsu8+ijqDOQSzPwO40pVUDhelc4kDc+wtxcjzTKzKRli6HLtrIvoukAkICsD+FVW1Zv6dVcUwVbupleEtD1A
 tyfErYN6
 s+vQA/Wmu4w1nh1IQK32+ZQQy4m3EP8LVVP8WkiIP5Y0LqaoiSYfReVhjE3tKs9n0MTfB/JpZrkSO713oYH0iHlNYapNVpKk2f4gMD+MK5MD2SGXFp8Hj712kH4M+hEgbWl0a6DHx7Tk6Pk8HDXXd4S9vD8bwYLmrNCLsxcan9rGbcdmGhWA3UzzekMgsCMIVm870sbeoccO6gtTd5ZVYWQTXkObnqNQ8P+dAmN8xZiaqIPBXhOnaGDu05J5CAXoIAncsAZodhdORFptq/qS8iO5uklUPnXxgIyvjqfW10objqMV6bdUXHYw1hVAkIeQZ9zxyvfGS1DxUkvTeN/gc0wMdqM3ux7vznhCaOt0S3OtbkCQbiGZPg6K6ZtgoGKIaF3as
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/11/2025 15:49, Loïc Molinari wrote:
> Make use of the new drm_gem_huge_mnt_create() and
> drm_gem_has_huge_mnt() helpers to avoid code duplication. Now that
> it's just a few lines long, the single function in i915_gemfs.c is
> moved into v3d_gem_shmem.c.
> 
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move i915_gemfs.c into i915_gem_shmem.c
> 
> v4:
> - clean up mountpoint creation error handling
> 
> v5:
> - use drm_gem_has_huge_mnt() helper
> 
> v7:
> - include <drm/drm_print.h> in i915_gem_shmem.c
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> ---
>   drivers/gpu/drm/i915/Makefile                 |  3 +-
>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 48 +++++++++----
>   drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
>   drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
>   .../gpu/drm/i915/gem/selftests/huge_pages.c   | 11 +--
>   drivers/gpu/drm/i915/i915_drv.h               |  5 --
>   6 files changed, 42 insertions(+), 110 deletions(-)
>   delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
>   delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
> 
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index 84ec79b64960..b5a8c0a6b747 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -169,8 +169,7 @@ gem-y += \
>   	gem/i915_gem_ttm_move.o \
>   	gem/i915_gem_ttm_pm.o \
>   	gem/i915_gem_userptr.o \
> -	gem/i915_gem_wait.o \
> -	gem/i915_gemfs.o
> +	gem/i915_gem_wait.o
>   i915-y += \
>   	$(gem-y) \
>   	i915_active.o \
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index 26dda55a07ff..9bba6f8cdee2 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -9,14 +9,16 @@
>   #include <linux/uio.h>
>   
>   #include <drm/drm_cache.h>
> +#include <drm/drm_gem.h>
> +#include <drm/drm_print.h>
>   
>   #include "gem/i915_gem_region.h"
>   #include "i915_drv.h"
>   #include "i915_gem_object.h"
>   #include "i915_gem_tiling.h"
> -#include "i915_gemfs.h"
>   #include "i915_scatterlist.h"
>   #include "i915_trace.h"
> +#include "i915_utils.h"
>   
>   /*
>    * Move folios to appropriate lru and release the batch, decrementing the
> @@ -515,9 +517,9 @@ static int __create_shmem(struct drm_i915_private *i915,
>   	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
>   		return -E2BIG;
>   
> -	if (i915->mm.gemfs)
> -		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
> -						 flags);
> +	if (drm_gem_has_huge_mnt(&i915->drm))
> +		filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
> +						 size, flags);
>   	else
>   		filp = shmem_file_setup("i915", size, flags);
>   	if (IS_ERR(filp))
> @@ -644,21 +646,41 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
>   
>   static int init_shmem(struct intel_memory_region *mem)
>   {
> -	i915_gemfs_init(mem->i915);
> -	intel_memory_region_set_name(mem, "system");
> +	struct drm_i915_private *i915 = mem->i915;
> +	int err;
>   
> -	return 0; /* We have fallback to the kernel mnt if gemfs init failed. */
> -}
> +	/*
> +	 * By creating our own shmemfs mountpoint, we can pass in
> +	 * mount flags that better match our usecase.
> +	 *
> +	 * One example, although it is probably better with a per-file
> +	 * control, is selecting huge page allocations ("huge=within_size").
> +	 * However, we only do so on platforms which benefit from it, or to
> +	 * offset the overhead of iommu lookups, where with latter it is a net
> +	 * win even on platforms which would otherwise see some performance
> +	 * regressions such a slow reads issue on Broadwell and Skylake.
> +	 */
>   
> -static int release_shmem(struct intel_memory_region *mem)
> -{
> -	i915_gemfs_fini(mem->i915);
> -	return 0;
> +	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
> +		goto no_thp;
> +
> +	err = drm_gem_huge_mnt_create(&i915->drm, "within_size");
> +	if (drm_gem_has_huge_mnt(&i915->drm))
> +		drm_info(&i915->drm, "Using Transparent Hugepages\n");
> +	else if (err)
> +		drm_notice(&i915->drm,
> +			   "Transparent Hugepage support is recommended for optimal performance%s\n",
> +			   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
> +						      " when IOMMU is enabled!");


Drm_gem_huge_mnt_create() will return 0, and drm_gem_has_huge_mnt() will 
return false.

So looking from the i915 perspective, when 
CONFIG_TRANSPARENT_HUGEPAGE=n, currently it will log the above notice 
message, and after the change it will not.

To preserve current behaviour it might be that "else if (err)" just 
needs to become a plan "else"?

Regards,

Tvrtko

> +
> + no_thp:
> +	intel_memory_region_set_name(mem, "system");
> +
> +	return 0; /* We have fallback to the kernel mnt if huge mnt failed. */
>   }
>   
>   static const struct intel_memory_region_ops shmem_region_ops = {
>   	.init = init_shmem,
> -	.release = release_shmem,
>   	.init_object = shmem_object_init,
>   };
>   
> diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.c b/drivers/gpu/drm/i915/gem/i915_gemfs.c
> deleted file mode 100644
> index 1f1290214031..000000000000
> --- a/drivers/gpu/drm/i915/gem/i915_gemfs.c
> +++ /dev/null
> @@ -1,71 +0,0 @@
> -// SPDX-License-Identifier: MIT
> -/*
> - * Copyright © 2017 Intel Corporation
> - */
> -
> -#include <linux/fs.h>
> -#include <linux/mount.h>
> -#include <linux/fs_context.h>
> -
> -#include <drm/drm_print.h>
> -
> -#include "i915_drv.h"
> -#include "i915_gemfs.h"
> -#include "i915_utils.h"
> -
> -void i915_gemfs_init(struct drm_i915_private *i915)
> -{
> -	struct file_system_type *type;
> -	struct fs_context *fc;
> -	struct vfsmount *gemfs;
> -	int ret;
> -
> -	/*
> -	 * By creating our own shmemfs mountpoint, we can pass in
> -	 * mount flags that better match our usecase.
> -	 *
> -	 * One example, although it is probably better with a per-file
> -	 * control, is selecting huge page allocations ("huge=within_size").
> -	 * However, we only do so on platforms which benefit from it, or to
> -	 * offset the overhead of iommu lookups, where with latter it is a net
> -	 * win even on platforms which would otherwise see some performance
> -	 * regressions such a slow reads issue on Broadwell and Skylake.
> -	 */
> -
> -	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
> -		return;
> -
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
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
> -	i915->mm.gemfs = gemfs;
> -	drm_info(&i915->drm, "Using Transparent Hugepages\n");
> -	return;
> -
> -err:
> -	drm_notice(&i915->drm,
> -		   "Transparent Hugepage support is recommended for optimal performance%s\n",
> -		   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
> -					      " when IOMMU is enabled!");
> -}
> -
> -void i915_gemfs_fini(struct drm_i915_private *i915)
> -{
> -	kern_unmount(i915->mm.gemfs);
> -}
> diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.h b/drivers/gpu/drm/i915/gem/i915_gemfs.h
> deleted file mode 100644
> index 16d4333c9a4e..000000000000
> --- a/drivers/gpu/drm/i915/gem/i915_gemfs.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -/* SPDX-License-Identifier: MIT */
> -/*
> - * Copyright © 2017 Intel Corporation
> - */
> -
> -#ifndef __I915_GEMFS_H__
> -#define __I915_GEMFS_H__
> -
> -struct drm_i915_private;
> -
> -void i915_gemfs_init(struct drm_i915_private *i915);
> -void i915_gemfs_fini(struct drm_i915_private *i915);
> -
> -#endif
> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> index bd08605a1611..2b9f7d86b46e 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>   
>   static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>   {
> -	return i915->mm.gemfs && has_transparent_hugepage();
> +	return drm_gem_has_huge_mnt(&i915->drm);
>   }
>   
>   static struct drm_i915_gem_object *
> @@ -1761,7 +1761,8 @@ static int igt_tmpfs_fallback(void *arg)
>   	struct drm_i915_private *i915 = arg;
>   	struct i915_address_space *vm;
>   	struct i915_gem_context *ctx;
> -	struct vfsmount *gemfs = i915->mm.gemfs;
> +	struct vfsmount *huge_mnt =
> +		drm_gem_has_huge_mnt(&i915->drm) ? i915->drm.huge_mnt : NULL;
>   	struct drm_i915_gem_object *obj;
>   	struct i915_vma *vma;
>   	struct file *file;
> @@ -1782,10 +1783,10 @@ static int igt_tmpfs_fallback(void *arg)
>   	/*
>   	 * Make sure that we don't burst into a ball of flames upon falling back
>   	 * to tmpfs, which we rely on if on the off-chance we encounter a failure
> -	 * when setting up gemfs.
> +	 * when setting up a huge mountpoint.
>   	 */
>   
> -	i915->mm.gemfs = NULL;
> +	i915->drm.huge_mnt = NULL;
>   
>   	obj = i915_gem_object_create_shmem(i915, PAGE_SIZE);
>   	if (IS_ERR(obj)) {
> @@ -1819,7 +1820,7 @@ static int igt_tmpfs_fallback(void *arg)
>   out_put:
>   	i915_gem_object_put(obj);
>   out_restore:
> -	i915->mm.gemfs = gemfs;
> +	i915->drm.huge_mnt = huge_mnt;
>   
>   	i915_vm_put(vm);
>   out:
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 95f9ddf22ce4..93a5af3de334 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -141,11 +141,6 @@ struct i915_gem_mm {
>   	 */
>   	atomic_t free_count;
>   
> -	/**
> -	 * tmpfs instance used for shmem backed objects
> -	 */
> -	struct vfsmount *gemfs;
> -
>   	struct intel_memory_region *regions[INTEL_REGION_UNKNOWN];
>   
>   	struct notifier_block oom_notifier;


