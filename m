Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E594CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 09:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89826B0012; Tue,  2 Dec 2025 04:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39506B0023; Tue,  2 Dec 2025 04:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928A76B0024; Tue,  2 Dec 2025 04:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0CE6B0012
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 04:14:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E81F1A05DF
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:14:21 +0000 (UTC)
X-FDA: 84173969922.13.1FA816C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 733ED10000B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 09:14:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DRc+MBhO;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764666859; a=rsa-sha256;
	cv=none;
	b=1hxoW5FETkXlrfYRlkpNB4JKcw9QPsZbntRDTsLaxbR/y7T2iJu2IfVbXLo+Gw8DfZyfuw
	dWd/lWKChMhb4r6mtJhyeJCIAazyDvevDfoFHC6tYgBJoM3DcEjQ/TkCX1aLoWGJqfYE2k
	dn/rxtXNvwISwlq7uLQ5zXdEriy6e6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DRc+MBhO;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764666859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC4JD69YCTl6Rq5Jcss9H2gq8y/1J0Tm3QdI/bpxBwA=;
	b=dI64P6pKW2TzOpvaJ82KfnIy3ypdm9AG3aPrl2zPJUSZ9SHDFTi/LgydGNRZZxXIfmPh4d
	rIObBAZb1jgT0wlbjg/TT7NWg3kU7gme0Cj2omahSmKSr+mghNdTB6WCQxIRfTrdlx8rrf
	C7SKE+wsT+1KoHJh+6QzheK2x4Z3QZY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764666856;
	bh=9HeGkb1CV5dVb10i7VYeFGTZqYWWEywQIZiFwfcvnNI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DRc+MBhOIKNro4cltO7qBBLqA4sWlayyyVJdH3ujaUMPaEzQGv+x0i/L5gLhI9IqY
	 8vpONH64B12nWznZZv9Uh2FIAGbVMtfSjOuwUk0kj/76lZ2TyprxNOH06j4GdnBgn5
	 cJgr4tr7QLCGHEGVtJ/s4kiTazDUZDvalI1BjhDGEa1qLlo0mRK2Q0LTR431GSwkoJ
	 fJuO2nhqBejHtKD9jBMKPRE3G76pB+Ajw8RrKpBZCF1J7HGtNaQnOeMIIEBu/xY9QW
	 II6EFVNfbvROuRZVtB8ojL17ICD1vj8UA6mciLUOzqLvaJS1SA7pNTwldJaExoQK6u
	 fSAfN+RZNfa3Q==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B826A17E1149;
	Tue,  2 Dec 2025 10:14:15 +0100 (CET)
Message-ID: <e11acf7a-452a-4ef1-91e1-48be1f0571d9@collabora.com>
Date: Tue, 2 Dec 2025 10:14:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/10] drm/panthor: Introduce huge tmpfs mountpoint
 option
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
References: <20251128185252.3092-1-loic.molinari@collabora.com>
 <20251128185252.3092-9-loic.molinari@collabora.com>
 <20251201094555.595744ab@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251201094555.595744ab@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 733ED10000B
X-Stat-Signature: 9emjwiufch6nqws7fiw5tipc78nydkr3
X-Rspam-User: 
X-HE-Tag: 1764666859-336250
X-HE-Meta: U2FsdGVkX1+q/gyYkeTLPPRzHB/TeAlR0XGQXdIlY2faeERgwWklRbCqZfaCGnzYqAJMzk5JgshA/WCmTmbHJpQr5qcrpGaEG/aR5bGxwYDNRRIZ3PeZ0KPx+sbwPs0bFA04zkg5K6mfaQ1C4AapHjVQt7z3vxINhoXlXCVUG0xkKGWeunljKS2qJPKx9/53dKjbczoLfEEnH1odP3u9+1R8NGMU4ZfirUe9pByHNaCinw+JiOxeZ9SDl0iyRtD/vOZlmpPKZmy4Ss+S8lXsFacjsM9FLmtHmZJCdKqpJYFn6agA7TNkyTr6sv2iYaZTym4/J9VDqubvvCSOwS2K2qEOCb5SD+Lxc47gwhQG/NSJLV6SMBueBvf+hqkMCwBVsiuN0YTQ/8E0EFANQmBuWnKtfxogG8+2DKWhfn9qjnehDf6aQGBnqQau9Po7dUjtOpin90DNGuNyBla1X8bwAFqL1OZluBnHCsV5Bld2uuw5xYFBp+SS9q1eOVZSfft0SExsicPv8UvBnBlRAfwz6K+LRw+O8mPT4NV2dOhY+MP4BavhVuThnaDdYIxY7wRzGWumRq9UODFco88l8uGA0jT3zx+nmkqu3JGbHh798rMy2+gl0mmsEgM8F0G27uORdpO8B6SzKt/hJoh8WFcgw9jRyTwfn4s7kJm4Z87G5qDZIBA8ACY8IK9tkqT4dFNGd+EzbArPGWWiStfzieng2Jjq6xy96STHkl4Dqlm8n+3skaOLSp5IeJHcOJZo62znNE8pnqAFLd/u3PHCwHvlK2Ixx31uxUFFyOwEzRDtZCMFLDgwivQYYFfTuGGHESHJEDlsX8TsCjSsf+qAFm6KdmlKqn3MlzstGVCP71GHANs1TW7bZn8Ob04v6h/54BTb8NmWVQOE81Kvhzu+g2/lvQHODeJXOrqGINqfTgiVfnkkWQ0hty0fYtmHg5Bu3jhGuvDTpnjrAmvLOrifZf3
 a/baftrj
 RwM+oI9WlCi6/dASpP3O69F6y0o5rheFR1rtvvO0K6z/zIV9e6u6Ql2ggTBBcAdTIB0la1wT6x7YbyEN91PoE6xKyGdYHDTDlf2p96OipdSOlAJWiaHrxHeaJY2aDYn4pD0foxrArZWk5mZMndOaq26dXe0hDY4Kqbpd5LZozi2ooMq9s3uelp96uLy6wcnOBHOKfLogGDf5buXP5IDFFRNvFiMDikGRhpYXK1mDyd/cILxUumLQbAxpKXvME6aXzUluEu2IJ+hVIGIHLnS9HCDdBFWK55qnHOJOGh3jNnl8u+MDBwsrhpl5U7bE4atxXQmiE7+PvYvI0WZ2JzikQj66FiFdpUOLY0ggt9IKA3Dd2DbiLeEZi/GX81lKNi/Va/savqJH1PnrAc/K0OiD8X0x5rZlqExdCkQznztrE45/gbMxDVTBBr5l2BE1Bt0f0+d3C0MzP22JRmVKevlSicfJts7bd1U1MXXOjOj8NqLXPwJxv9c3L2o31YV84SWNPJvN5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

On 01/12/2025 09:45, Boris Brezillon wrote:
> On Fri, 28 Nov 2025 19:52:50 +0100
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> Introduce the 'panthor.transparent_hugepage' boolean module parameter
>> (false by default). When the parameter is set to true, a new tmpfs
>> mountpoint is created and mounted using the 'huge=within_size'
>> option. It's then used at GEM object creation instead of the default
>> 'shm_mnt' mountpoint in order to enable Transparent Hugepage (THP) for
>> the object (without having to rely on a system wide parameter).
>>
>> v3:
>> - use huge tmpfs mountpoint in drm_device
>>
>> v4:
>> - fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
>> - clean up mountpoint creation error handling
>> - print negative error value
>>
>> v5:
>> - use drm_gem_has_huge_tmp() helper
>> - get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs
>>
>> v9:
>> - replace drm_gem_has_huge_tmp() by drm_gem_get_huge_tmp()
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>> ---
>>   drivers/gpu/drm/panthor/panthor_device.c |  3 +++
>>   drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
>>   drivers/gpu/drm/panthor/panthor_drv.h    |  9 +++++++++
>>   drivers/gpu/drm/panthor/panthor_gem.c    | 18 ++++++++++++++++++
>>   drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
>>   5 files changed, 39 insertions(+)
>>   create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
>>
>> diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
>> index e133b1e0ad6d..2979ee0e52c2 100644
>> --- a/drivers/gpu/drm/panthor/panthor_device.c
>> +++ b/drivers/gpu/drm/panthor/panthor_device.c
>> @@ -18,6 +18,7 @@
>>   #include "panthor_devfreq.h"
>>   #include "panthor_device.h"
>>   #include "panthor_fw.h"
>> +#include "panthor_gem.h"
>>   #include "panthor_gpu.h"
>>   #include "panthor_hw.h"
>>   #include "panthor_mmu.h"
>> @@ -294,6 +295,8 @@ int panthor_device_init(struct panthor_device *ptdev)
>>   	if (ret)
>>   		goto err_unplug_fw;
>>   
>> +	panthor_gem_init(ptdev);
>> +
>>   	/* ~3 frames */
>>   	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
>>   	pm_runtime_use_autosuspend(ptdev->base.dev);
>> diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
>> index d1d4c50da5bf..55dbda6dbf9c 100644
>> --- a/drivers/gpu/drm/panthor/panthor_drv.c
>> +++ b/drivers/gpu/drm/panthor/panthor_drv.c
>> @@ -1559,6 +1559,7 @@ static const struct file_operations panthor_drm_driver_fops = {
>>   	.read = drm_read,
>>   	.llseek = noop_llseek,
>>   	.mmap = panthor_mmap,
>> +	.get_unmapped_area = drm_gem_get_unmapped_area,
>>   	.show_fdinfo = drm_show_fdinfo,
>>   	.fop_flags = FOP_UNSIGNED_OFFSET,
>>   };
>> @@ -1626,6 +1627,12 @@ static const struct drm_driver panthor_drm_driver = {
>>   #endif
>>   };
>>   
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +bool panthor_transparent_hugepage;
>> +module_param_named(transparent_hugepage, panthor_transparent_hugepage, bool, 0400);
>> +MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (false = default)");
> 
> On a second thought, I wonder if this shouldn't be an opt-out param
> (which is what V3D does, BTW). What's the downside of enabling THP if we
> have a fallback for cases where memory is too fragmented to get huge
> pages at allocation time?

The only issue I can think of is maybe the fragmentation implied by the 
alignment requirement. But I don't think it's too much of an issue 
because, as you said, it will just fallback to allocating small pages in 
between, and V3D, which has use cases with low memory requirements too, 
makes it an opt-out too.

I'll do that for both Panfrost and Panthor.

Regards,
Loïc

>> +#endif
>> +
>>   static int panthor_probe(struct platform_device *pdev)
>>   {
>>   	struct panthor_device *ptdev;
>> diff --git a/drivers/gpu/drm/panthor/panthor_drv.h b/drivers/gpu/drm/panthor/panthor_drv.h
>> new file mode 100644
>> index 000000000000..79dccd289881
>> --- /dev/null
>> +++ b/drivers/gpu/drm/panthor/panthor_drv.h
>> @@ -0,0 +1,9 @@
>> +// SPDX-License-Identifier: GPL-2.0 or MIT
>> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
>> +
>> +#ifndef __PANTHOR_DRV_H__
>> +#define __PANTHOR_DRV_H__
>> +
>> +extern bool panthor_transparent_hugepage;
>> +
>> +#endif
>> diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
>> index 10d255cccc09..7ae07a9bc996 100644
>> --- a/drivers/gpu/drm/panthor/panthor_gem.c
>> +++ b/drivers/gpu/drm/panthor/panthor_gem.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0 or MIT
>>   /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
>>   /* Copyright 2023 Collabora ltd. */
>> +/* Copyright 2025 Amazon.com, Inc. or its affiliates */
>>   
>>   #include <linux/cleanup.h>
>>   #include <linux/dma-buf.h>
>> @@ -12,10 +13,27 @@
>>   #include <drm/panthor_drm.h>
>>   
>>   #include "panthor_device.h"
>> +#include "panthor_drv.h"
>>   #include "panthor_fw.h"
>>   #include "panthor_gem.h"
>>   #include "panthor_mmu.h"
>>   
>> +void panthor_gem_init(struct panthor_device *ptdev)
>> +{
>> +	int err;
>> +
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> +	    !panthor_transparent_hugepage)
>> +		return;
>> +
>> +	err = drm_gem_huge_mnt_create(&ptdev->base, "within_size");
>> +	if (drm_gem_get_huge_mnt(&ptdev->base))
>> +		drm_info(&ptdev->base, "Using Transparent Hugepage\n");
>> +	else if (err)
>> +		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
>> +			 err);
>> +}
>> +
>>   #ifdef CONFIG_DEBUG_FS
>>   static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
>>   {
>> diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/panthor/panthor_gem.h
>> index 80c6e24112d0..2eefe9104e5e 100644
>> --- a/drivers/gpu/drm/panthor/panthor_gem.h
>> +++ b/drivers/gpu/drm/panthor/panthor_gem.h
>> @@ -136,6 +136,8 @@ struct panthor_gem_object *to_panthor_bo(struct drm_gem_object *obj)
>>   	return container_of(to_drm_gem_shmem_obj(obj), struct panthor_gem_object, base);
>>   }
>>   
>> +void panthor_gem_init(struct panthor_device *ptdev);
>> +
>>   struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev, size_t size);
>>   
>>   int
> 


