Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5152DE7DF16
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04DF6B00D1; Mon,  2 Feb 2026 12:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2396B00D2; Mon,  2 Feb 2026 12:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE006B00D3; Mon,  2 Feb 2026 12:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF546B00D1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:56:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38920160255
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:56:50 +0000 (UTC)
X-FDA: 84400272180.20.EF0B337
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F7D5140004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:56:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770055008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dm8KihIz1z4y132RbHwgKpuTCZ7+0DDA1nAyic0ydr8=;
	b=AS4pnOKtOZjGGuR5K6xv8WFNPsrEeTwJKgTb9G+flGvTTPs49pTu5x2bDYI8jwp2A7PF00
	kkwf64COs8rD2QII2vQ1gvtgKEAunFEQh4oChv+mkLawGuPwvz0JiI782LqkDEsZQ31mGh
	nrrG7UFJDl0W5lNCz0gsd/uXNfKaFBU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770055008; a=rsa-sha256;
	cv=none;
	b=0h0FyszxZNJ3CYvdg87obnrSIW8ABGjWL2uiVNU7u2wqvU3/viTK+00wdcNTH2I2KWmoBR
	gxBVDNzDXV00Bd8/0i1HFH1p+3i6pSHNfuK3QWpTu2R6dey7W0nUdtayFGLSWZq+6zMJ6T
	OAQ/ooCUOXktp0mJYoWXTxKks+OXfts=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z693ZqSzHnGh8;
	Tue,  3 Feb 2026 01:55:45 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 4CD2340569;
	Tue,  3 Feb 2026 01:56:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:56:42 +0000
Date: Mon, 2 Feb 2026 17:56:40 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 5/9] cxl/core/region: move pmem region driver logic into
 pmem_region
Message-ID: <20260202175640.00003ef5@huawei.com>
In-Reply-To: <20260129210442.3951412-6-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-6-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F7D5140004
X-Stat-Signature: 6suwaxcb9jzgpi4mkmfqbn8xj8q7bhdh
X-Rspam-User: 
X-HE-Tag: 1770055008-690890
X-HE-Meta: U2FsdGVkX18iFk0H+Q67KTJPBjasiNWAzrPzipvlM6YIVdS3oftpyZZzt/64ivhrCe5pBsbO0njZifG6oBcTf6STM+DrkCy7gdLb6CeXXHzqE2NhTeVnDq1ZAS5L/HSHwaYexJfLaIWwkdZ6wq5UA7KYtgmoXk52TtshGEszDNgKoD2hLl/h5dzT8vfrWPJdEGQ2c2Q4pcfsJHaFRvR1pmYYODYS2duTdSNLcCoUWePNs6Ng96ia222nJC5O42rCibRCQGSDTRHruuWhrmEj9ai+dtvHpHTaFZ8k/wQPhluTwUVjbQw1GERGRBFFD/FdmUzgaTERa3e9uFJeF+TK4FPtJRPp8zqV3IoxLoxfVThdYiRFlMNWbMIeAr69LN2XwUhbbPAyKj+ggq+ZBQKXCLGO3s7PMHOXOqrHQy2HemrWzvpLry8B7A+ty7Vj/926goFYbklvC270KFm8X0J4QdZpTa9vQNQWuhaGAD8TiTjfzqAcWGOsX4ScGiWeLc0CMuelgtnknYiSdYV7HGaFh8ZTO+lIZgyMKTr+dehteI67oWxDPZY1E2/dQEak+FTjuAAS0iEeXkTEFzHNBur9Ur/zLbjx/jTM52zYw2IM1K3rJr+GoNzLp4mz67j2E26qPU3BrWhrUW17dlnhpiUQdnCx09dvZqQbYjWDo5wbXDThLPtsEle/G6W0wnUkULGJ2aS5GCFW/O/POkxWYBE7W62QdG0Gpnrg73/GKBOYrzcIXVGavsNXNMSy/DEIPFBWdiPbZJau4TZW3nvYs+41iGz2G2QUHrSNacXNVYvRiuZ3fbWAcx0aLtQGQzzQDUGTlqEG0cOm3RkU47YB4aEJqALPWWg2HeuAOvxniRKibiKv9baN5DwhhmxYskCZlYUw3rewoA4ESJAboHEIw8Py/VH16sASt6x0zT5Sb1nl3u9nDOKCE/QlFPRbenMzHToCeRFjUz88kPD2XygnvRh
 26a+9t4F
 jqqd7r6AvIHe85sIotBRv6UKsSwd/H9u7nRxaj2w17c1K/rzI+m+QmaiO+AuuUvxyuTXiqsSjA7hK9VuWH7JzjwC0VSLDM5FN4JG5IS/72WtP0EkgoBUUEJkzXa8p2Dvly7Qf7lMh5L6dYaddVgbMfuuwZQxWGwFEMvrfRyO+TBPXs12yjHm8Qs4wXbxtwBqOb90SinXunjlew1xQnSHiSyG8qgVgpOGnIIEEoUjnCJCm+UPwsZ+iMAZOq0c8hT+vWWotlNQBuTVgLEuS1+FPVMBfRaJPkVm1OaVWaoyVuGfdqdhvIOehdyQgRWVrfTX5PqRdHK37EWDiR9BfpGWpVMsJs3aVOd00uPvJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 16:04:38 -0500
Gregory Price <gourry@gourry.net> wrote:

> Move the pmem region driver logic from region.c into pmem_region.c.

Needs to answer the question: Why?

> 
> No functional changes.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
Minor stuff inline.

> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..81b66e548bb5
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,191 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"
> +
> +static void cxl_pmem_region_release(struct device *dev)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	int i;
> +
> +	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> +		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
> +
> +		put_device(&cxlmd->dev);
> +	}
> +
> +	kfree(cxlr_pmem);
> +}
> +
> +static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	NULL,
Maybe sneak in dropping that trailing comma whilst you are moving it.
> +};

> +/**
> + * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
> + * @cxlr: parent CXL region for this pmem region bridge device
> + *
> + * Return: 0 on success negative error code on failure.
> + */
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
...

> +	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> +	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
> +
> +err:
> +	put_device(dev);
> +err_bridge:
> +	put_device(&cxl_nvb->dev);
> +	cxlr->cxl_nvb = NULL;
> +	return rc;
> +}
> +
> +
Bonus line...

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c



