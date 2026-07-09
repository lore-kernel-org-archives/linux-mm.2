Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B16C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 21:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4C06B0005; Thu,  9 Jul 2026 17:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355286B0088; Thu,  9 Jul 2026 17:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2449F6B008A; Thu,  9 Jul 2026 17:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEFBA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:07:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E6BC1402A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:07:27 +0000 (UTC)
X-FDA: 84970474134.14.F6D2DEC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA8AF20008
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 21:07:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zl5TP1X2;
	spf=pass (imf31.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783631245;
	b=mWAR2gqHbsET5lXqhbYM7e1ae7WAw7CZKZHZB1P4B24pCo+7tA9tvqeSph9HNlY3o8C9jV
	GRJIBkJvUFUqdbd/udATHPLMWrF8XZAacy96AGWjxZjFwOGw/yKrGQ3mz9YZtR9XkSk0pe
	QDeHKWgUrBEX3B/Zc8KsT+j8uts3FXo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zl5TP1X2;
	spf=pass (imf31.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783631245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDugQUgBAUBQi5cnaOpJjdnV77GYChvNQUzDzLhTm4g=;
	b=vTorwC/qpwH9bo6syi8fTcXdRfVAgvp5P0IFgDALUL0MGaML48hFBisfy91C9XF31Unf7S
	iVEEhsQzrZyBjvyJZUExR5iHQHXSO8iSf9XMh/KdOWyE/NCsepZSfeBQggEFcJiPoitRjC
	GLxV4x4jd9qnK2X65809KqJ+LTj1wMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783631244; x=1815167244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CcbzFpuqxbP31RWAKcPyqR+DOuQ1YM3H4ZPQJpHMvx0=;
  b=Zl5TP1X2oXmbzw6YeCu3m9clJksPx3eGcikP5GYLf6DKn70ANPk7nLKW
   cBF1O47fckTOBuoLJwyvLJoQhD5Npvbe/rqpdQVsZhPHcYQpt9hUjSB1f
   jI4DaOQpwrdylOMxF0gausRGX8GpjJ63kaZSYp2ZTbZIfl1VYticSYqij
   O3SuFwwy5eiR5sX2GArSsiLgSzngiKmH6B0TzGi9i6EbJgu6mEmWejEuO
   zB3P7RQSSc/dZ/9aKOcVlm9Cmms6EQwQwDQ6bQGsWALlpfgV1WeRQh1va
   1E+FHM1Qa2eblOtNVvmNvcX9HKyE9AM/BYaAy8eyxgKsYwtxGmgUUHghG
   w==;
X-CSE-ConnectionGUID: zzuBmUtPRPaEFw3+wO9YJw==
X-CSE-MsgGUID: DW4ShyshQwOuW5+ilDvgFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71854371"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71854371"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:07:22 -0700
X-CSE-ConnectionGUID: HCOrVRvIQYiPh/zZ0nyc9g==
X-CSE-MsgGUID: ZJq6SJJxQbec8bcZ2BSGCQ==
X-ExtLoop1: 1
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:07:20 -0700
Message-ID: <8ad8e025-ffea-4bc8-8797-6a280ecc229f@intel.com>
Date: Thu, 9 Jul 2026 14:07:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA8AF20008
X-Stat-Signature: sxh3oob7ny5t7jqo6xnu6tbnn15p9dkz
X-HE-Tag: 1783631244-574392
X-HE-Meta: U2FsdGVkX19D1qyQpUf8f0KK+HodIKw7rwSGsDNW+6Iw1nEEAEPCYf6cprya3BF28hF0AANf5idFlqUZkK6Nf1il2I+7DjxGlQBjwl/kwe35uIAhOZDcCMToWQrDVfj7XBjpxl+iKfSzJsKGbV5+82K7Ai9zsjdT+y0bi3DWhzVhFInBjIM8BXhR1pJcYaLbLLemSQuXxr0f2wqvKSh4+xcsLCEhZcaT0aRwvHeDRbUpfQ+1MD6wmpVdmCquLK396lYdI+wIt8Fn/MHPwMQcM2OAnLukC0r2rGhlYTje4L7Kc53bboPfnQ544UWhpgL2FlrHaqAvDbz0s0vjHR82K/0GDFnhn4gc0Ea2hMY6tt8ZAkzh9sve9IpVBQV6nytN4pB/+v98lmo5ArAwwlidSUDAwsR7q5iK7l9QZOsXiym4ifw9P9iuLGLRlESAiottXidWZm7dReH+UVibU+1iQMfSqReh7v7mT65XAIeUGd/csKnQXSnNvND+f60Ydd2CE3AJVz67YKNv1PCtc0DvPrMrjzzKXHaEwn3VF1pHMsNCVYnT5NV9vIMUS3DIJ6SqrfZI4FIlAOTjUMVJQtk5WFlK4THg5JXbH8J7qDdimZ3heYHT+hvnbMnw/GImpGUOJACrVrwjslaTpElWk1X9pHbT//M6lKcRi1P62mueqaWG/mb9d26f1oizgq/chEQ4cjyZMI5btyu0INh8IFmzrCyEC1zCfbZ/6RjAB58HKP1Oy9+z2YA938tkTYnwoObVSBPN6sKAX38461Ko07rb7GMWo1euaAnjlKLH8wJNkqa8s5u+n8jMiB/JZwWlVUbl5auT1//wmgX89HT/lQwZ+aiAE8NBzHYVdThPjy8+tuGu+bW05rzTUchwTh1o3fXoIfLvUMaPEmfd51M3iwP0HzYmMn1Xi1gnLKeonuAXVF8hrWZZXDyDSdAl6AcJXvuD5K5ify4dr+Ykz+CuZqF
 sKVBTWE3
 /2u/IqkVvff3+o3fWtxE+KIc+YgkzhTGXtW3VBTCSkUCyA8fYAh5L/a215iPnO8o4jGYKCvrvQxgu0D6kR3H9msNtzqVLHP7w+cn+cPP+fvf/H8sZIakdHsWm5vm7XPueeGPwNlqeKr3i2U1zLZ9BbVWBgwQTOJrROgjjXoaZbNH25HfpqHb/Wbcwqax/zFcfPtELdM07S79DL8kTdgl37Cu4ZT9mwNuEzlbKO/PwWaDyLE03yXHoByFWbQo3ZNcZpYKGZQFQuyRNWty60XHSHif5+bMdWzB/ln3rmN+IsomSAnVT94OGDZnObxQJlUOqj03Ymfqke/r4vdiYnI0S/npRG79BbGUbrM+ajrdjh8okfX7sRwOKqoKf7dteS40T2NcyPYCfnc87PvAst/MJ4S69Dg+JSYnYDX998aKmF73OR1ytDjJJB4GGNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Capturing the system default would otherwise break the ABI, because
> the system default can change - but we would be statically assigning
> the value at device creation time.
> 
> To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> the current behavior, while providing a clean way to override it.
> 
> No behavioural change for existing callers (still the system default).

behavioral

> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c         |  3 +++
>  drivers/dax/bus.h         |  9 +++++++++
>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/dax-private.h |  4 ++++
>  drivers/dax/hmem/hmem.c   |  1 +
>  drivers/dax/kmem.c        | 11 +++++++++--
>  drivers/dax/pmem.c        |  1 +
>  7 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 492573b47f66..4a03b323b003 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
>  #include <linux/memremap.h>
> +#include <linux/memory_hotplug.h>
>  #include <linux/device.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
> @@ -394,6 +395,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
>  			.size = 0,
>  			.id = -1,
>  			.memmap_on_memory = false,
> +			.online_type = DAX_ONLINE_DEFAULT,
>  		};
>  		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
>  
> @@ -1527,6 +1529,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	ida_init(&dev_dax->ida);
>  
>  	dev_dax->memmap_on_memory = data->memmap_on_memory;
> +	dev_dax->online_type = data->online_type;
>  
>  	inode = dax_inode(dax_dev);
>  	dev->devt = inode->i_rdev;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 5909171a4428..3bc76bc0a145 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -3,6 +3,7 @@
>  #ifndef __DAX_BUS_H__
>  #define __DAX_BUS_H__
>  #include <linux/device.h>
> +#include <linux/memory_hotplug.h>
>  #include <linux/platform_device.h>
>  #include <linux/range.h>
>  #include <linux/workqueue.h>
> @@ -16,6 +17,13 @@ struct dax_region;
>  #define IORESOURCE_DAX_STATIC BIT(0)
>  #define IORESOURCE_DAX_KMEM BIT(1)
>  
> +/*
> + * online_type sentinel: the device was created without an explicit online
> + * policy, so the system default is resolved when the kmem driver binds,
> + * (not at device-creation time, which would freeze a stale policy).
> + */
> +#define DAX_ONLINE_DEFAULT	(-1)
> +
>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct range *range, int target_node, unsigned int align,
>  		unsigned long flags);
> @@ -26,6 +34,7 @@ struct dev_dax_data {
>  	resource_size_t size;
>  	int id;
>  	bool memmap_on_memory;
> +	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
>  };
>  
>  struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 3ab39b77843d..1a7ec6212213 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
>  		.id = -1,
>  		.size = range_len(&cxlr_dax->hpa_range),
>  		.memmap_on_memory = true,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 81e4af49e39c..902e922dc4e4 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -8,6 +8,7 @@
>  #include <linux/device.h>
>  #include <linux/cdev.h>
>  #include <linux/idr.h>
> +#include <linux/memory_hotplug.h>
>  
>  /* private routines between core files */
>  struct dax_device;
> @@ -79,6 +80,8 @@ struct dev_dax_range {
>   * @dev: device core
>   * @pgmap: pgmap for memmap setup / lifetime (driver owned)
>   * @memmap_on_memory: allow kmem to put the memmap in the memory
> + * @online_type: MMOP_* online type for memory hotplug, or DAX_ONLINE_DEFAULT
> + *		 to resolve the system default policy when kmem binds
>   * @nr_range: size of @ranges
>   * @ranges: range tuples of memory used
>   */
> @@ -95,6 +98,7 @@ struct dev_dax {
>  	struct device dev;
>  	struct dev_pagemap *pgmap;
>  	bool memmap_on_memory;
> +	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
>  	int nr_range;
>  	struct dev_dax_range *ranges;
>  };
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index af21f66bf872..2de3bc925172 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -37,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
>  		.id = -1,
>  		.size = region_idle ? 0 : range_len(&mri->range),
>  		.memmap_on_memory = false,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 592171ec10f4..0a184c0878dd 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -72,6 +72,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	int i, rc, mapped = 0;
>  	mhp_t mhp_flags;
>  	int numa_node;
> +	int online_type;
>  	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
>  
>  	/*
> @@ -132,6 +133,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
>  
> +	/* Resolve system default at bind time in case it changed */
> +	online_type = dev_dax->online_type;
> +	if (online_type == DAX_ONLINE_DEFAULT)
> +		online_type = mhp_get_default_online_type();
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct resource *res;
>  		struct range range;
> @@ -172,8 +178,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		 * Ensure that future kexec'd kernels will not treat
>  		 * this as RAM automatically.
>  		 */
> -		rc = add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, mhp_flags);
> +		rc = __add_memory_driver_managed(data->mgid, range.start,
> +				range_len(&range), kmem_name, mhp_flags,
> +				online_type);
>  
>  		if (rc) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..e7adace69195 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  		.pgmap = &pgmap,
>  		.size = range_len(&range),
>  		.memmap_on_memory = false,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return devm_create_dev_dax(&data);


