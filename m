Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B282AE7DF19
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098336B00BC; Mon,  2 Feb 2026 13:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045DD6B00C3; Mon,  2 Feb 2026 13:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69D26B00C5; Mon,  2 Feb 2026 13:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D312D6B00BC
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:20:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59D391B157B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:20:24 +0000 (UTC)
X-FDA: 84400331568.28.C27D425
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf28.hostedemail.com (Postfix) with ESMTP id 102FBC0008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:20:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770056422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3LfpLUKkUp8m047MWHWS3aPn2NG/lnhFexns7yE17o=;
	b=bU3DehJJbAU+Qnk/sOrcam70Hx/s5IcQkrHonH//CdAl9uaJW1YCzEtnvAPrZX3j+s8cIF
	0nohmlUZlREX9UV7+1vUdxG6K8g5ilui5ilYNa0H/0SQBanB36NAk7xSjb4GDd2vS9vxrw
	gHzJOcVciKE6/3lqckytV6qEc69u/pQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770056422; a=rsa-sha256;
	cv=none;
	b=prIDXFP+U7s318C/+p/OmwbnQKTVg/btBF0e508LgYaFNsDn8OHhYno3LtJe21TAO/VOg0
	oHK5aU3YvVMPWn1JS/V61NcDCWRrwKtxBg7HmzB6Gv73Upo6Is+viICsf5bzWJBdyTAPHz
	tJsoDYqJdOMUsVgWe8MdZzeSnVoUrK0=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Zdb2s8dzJ46BB;
	Tue,  3 Feb 2026 02:19:31 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 80A7140565;
	Tue,  3 Feb 2026 02:20:17 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 18:20:16 +0000
Date: Mon, 2 Feb 2026 18:20:15 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <20260202182015.0000325b@huawei.com>
In-Reply-To: <20260129210442.3951412-9-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-9-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Stat-Signature: k3dewi93mcp3kz3mzzmoz8cjhd9qpaat
X-Rspamd-Queue-Id: 102FBC0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770056421-441607
X-HE-Meta: U2FsdGVkX1/ZsOV89za4AO/bNpIfJ9p89ca1nEJciM2Ll2GicSDA+hJxy2WFiU9kegqbde38P+NMusfIsWar0GlA5JZpTPJUbWCsAagbtp4v7/+00uFR6C5N/ZXcG2BQk/xf9iBdv+9nFoOxnr7q6/OWdLCrO1s+XPjx/BZEw2eN+Apb8JMtq8eNBgM3hDeYVnW/1mCEvb8ojPqd3ZKweUWtWWthZ/x1+O5ecvtUEJHa/2D+H05qC7SSD7djewhFc9D5Vzuw/kGIbFaRSfx8cfbY8yxUZb+3GzCHOl+UEPylJbslAA5cPrmU7gzIst4WvmWXK/GWJfuTvpKdITHEf52hKmV8IpmJSR3mvnChJiZA0N6193ZgR3wAkVcrI/lddeLrkhBv0360pZPYfeeOcGTVB7OK20GVsrNrKZ+uHpbVTvQQEX9szghdDDbXggKHcHFkHd7S8E5UiRywVD15Rndx4iIvQVkiEDVPRXpinptxM4jXrHrx5WmfvB2cmTPV0riEbX+dXiCWpIZKgaATRj2ewTbkFktjydi22y9M790VG8Ke4EmTvplhfsLMPCutbvYEfNY5wIfT56fgHRcPiolSXbhUUGRUZFc3rh7CtucLXqwG+ZaqbIq//0BjjKAXbOMkkeGsOhjmzBe59wfk9QMAdlTZcdDYrkcFkmuXmleBpKXd/6d7esH0vW3fWTL0Si4F5aAIO6XJ3MbgFvXoc3PUOX30r55DUBXKfPoF95uBObuIsvHdIjNuDH++TQMdOUjHIJlf7uk8wfdtvRSxG5x50++10Rkkrv1K5ORDPhpFhZSWiTVs5tqPkXWC5iv2u18zUEPzeZAro5sWhzCumtzsQerSdeC4/P9TsgeCpDU2/Yq2rTGLwlgVl/7LbvfitkYCNZj2xOpNvdkuiRCx4fiCb4Y4S+8it8kYUNV59v2L6cgydSBNzSgEWIc/sBb/rv4RZU/R0Qdc3z4Q0Ht
 mrjrcGiA
 QRaij8+9wSA3Y7+NHDAove3H5fPv2yO+ULNroKahCP0dGzSDHJ982HJlOhaYrU2JEW2KXGhbhOQ/VXRU6NAdsi8rWtwgY6OdSbj+Q8TDSYDjO0JNMq0oOswFoOHskCBbv3+vw9Ht7qDE4XkWhkv+qQrZaKAmso7M+WB9u+nVCmzBqWHqNHCBrhCLpiJbhDCicrNUeej5puYswefpLfhvOmwhxjtgR9urpApwy27t8fLp9rOB5bwD/Yrgqbj4vf4IHv3eF/1O9rxoohrdO4IMQK1bm9TjSQ/6nTSXdY9D+IoP0ekhr4MjUalCqn+T9dwGW1rqlwNoSGR5qss3tV72raacVfIKH/3bC/9O/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 16:04:41 -0500
Gregory Price <gourry@gourry.net> wrote:

> In the current kmem driver binding process, the only way for users
> to define hotplug policy is via a build-time option, or by not
> onlining memory by default and setting each individual memory block
> online after hotplug occurs.  We can solve this with a configuration
> step between region-probe and dax-probe.
> 
> Add the infrastructure for a two-stage driver binding for kmem-mode
> dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
> devices and creates cxl_dax_region with dax_driver=kmem.
> 
> This creates an interposition step where users can configure policy.
> 
> Device hierarchy:
>   region0 -> sysram_region0 -> dax_region0 -> dax0.0
> 
> The sysram_region device exposes a sysfs 'online_type' attribute
> that allows users to configure the memory online type before the
> underlying dax_region is created and memory is hotplugged.
> 
>   sysram_region0/online_type:
>       invalid:        not configured, blocks probe
>       offline:        memory will not be onlined automatically
>       online:         memory will be onlined in ZONE_NORMAL
>       online_movable: memory will be onlined in ZONE_MMOVABLE

ZONE_MOVABLE

> 
> The device initializes with online_type=invalid which prevents the
> cxl_dax_kmem_region driver from binding until the user explicitly
> configures a valid online_type.
> 
> This enables a two-step binding process:
>   echo region0 > cxl_sysram_region/bind
>   echo online_movable > sysram_region0/online_type
>   echo sysram_region0 > cxl_dax_kmem_region/bind
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
Trivial stuff. Will mull over this series as a whole...
My first instinctive reaction is positive - I'm just wondering
where additional drivers fit into this and whether it has the
right degree of flexibility.



> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 6200ca1cc2dd..8bef91dc726c 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3734,8 +3734,20 @@ int cxl_region_init(void)
>  	if (rc)
>  		goto err_dax;
>  
> +	rc = cxl_driver_register(&cxl_sysram_region_driver);

This smells like a loop over an array of drivers is becoming sensible.

> +	if (rc)
> +		goto err_sysram;
> +
> +	rc = cxl_driver_register(&cxl_dax_kmem_region_driver);
> +	if (rc)
> +		goto err_dax_kmem;
> +
>  	return 0;
>  
> +err_dax_kmem:
> +	cxl_driver_unregister(&cxl_sysram_region_driver);
> +err_sysram:
> +	cxl_driver_unregister(&cxl_devdax_region_driver);
>  err_dax:
>  	cxl_driver_unregister(&cxl_region_driver);
>  	return rc;
> @@ -3743,6 +3755,8 @@ int cxl_region_init(void)
>  
>  void cxl_region_exit(void)
>  {
> +	cxl_driver_unregister(&cxl_dax_kmem_region_driver);
> +	cxl_driver_unregister(&cxl_sysram_region_driver);
>  	cxl_driver_unregister(&cxl_devdax_region_driver);
>  	cxl_driver_unregister(&cxl_region_driver);
>  }
> diff --git a/drivers/cxl/core/sysram_region.c b/drivers/cxl/core/sysram_region.c
> new file mode 100644
> index 000000000000..5665db238d0f
> --- /dev/null
> +++ b/drivers/cxl/core/sysram_region.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2026 Meta Platforms, Inc. All rights reserved. */
> +/*
> + * CXL Sysram Region - Intermediate device for kmem hotplug configuration
> + *
> + * This provides an intermediate device between cxl_region and cxl_dax_region
> + * that allows users to configure memory hotplug parameters (like online_type)
> + * before the underlying dax_region is created and memory is hotplugged.
> + */
> +
> +#include <linux/memory_hotplug.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"

> +
> +static DEVICE_ATTR_RW(online_type);
> +
> +static struct attribute *cxl_sysram_region_attrs[] = {
> +	&dev_attr_online_type.attr,
> +	NULL,

As below.

> +};
> +
> +static const struct attribute_group cxl_sysram_region_attribute_group = {
> +	.attrs = cxl_sysram_region_attrs,
> +};
> +
> +static const struct attribute_group *cxl_sysram_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	&cxl_sysram_region_attribute_group,
> +	NULL,

Trivial, but don't want a comma on that NULL.

> +};

> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 674d5f870c70..1544c27e9c89 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -596,6 +596,25 @@ struct cxl_dax_region {
>  	enum dax_driver_type dax_driver;
>  };
>  
> +/**
> + * struct cxl_sysram_region - CXL RAM region for system memory hotplug
> + * @dev: device for this sysram_region
> + * @cxlr: parent cxl_region
> + * @hpa_range: Host physical address range for the region
> + * @online_type: Memory online type (MMOP_* 0-3, or -1 if not configured)

Ah. An there's our reason for an int.   Can we just add a MMOP enum value
for not configured yet and so let us use it as an enum?
Or have a separate bool for that and ignore the online_type until it's set.


> + *
> + * Intermediate device that allows configuration of memory hotplug
> + * parameters before the underlying dax_region is created. The device
> + * starts with online_type=-1 which prevents the cxl_dax_kmem_region
> + * driver from binding until the user explicitly sets online_type.
> + */
> +struct cxl_sysram_region {
> +	struct device dev;
> +	struct cxl_region *cxlr;
> +	struct range hpa_range;
> +	int online_type;
> +};



