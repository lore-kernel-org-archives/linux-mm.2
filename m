Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA61FE7DF0F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E306B00B9; Mon,  2 Feb 2026 12:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C53F6B00CE; Mon,  2 Feb 2026 12:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7DC6B00CF; Mon,  2 Feb 2026 12:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3D5F6B00B9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:54:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82EBF1601F8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:54:27 +0000 (UTC)
X-FDA: 84400266174.16.3A123C2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4595210000B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:54:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770054865; a=rsa-sha256;
	cv=none;
	b=tAQYVRrek63l8hjC7Allx1XuU61k2cs5RWNoxFWsxgNUfors/Y2sKBe8PJpHBKTVeh/y41
	Isr7CA/QLW2UZVRw70tPd6oQCCiKeZ8cqyWwEm8SZwLoprKQpT+a1R/CLvnH8A2o+k59/m
	2lmHEZO1g2wOjDLHyJXdA9Adu27HfVI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oT5AYiREUr4gx/DTQUh9LxVVIb8uuFN/plSveYuoWZM=;
	b=zQrPMKzYB8qBQ0uShzRHnoVCOx6INLrvhu6bOa/Zm8KHvEPjlpjX1J/uWYUnQFIxesWzOF
	By2OhGg8nTLuWFdz/uI/sjUOIjmsVMdozwO8O4NGk8/mo2wTvF+GlaUd1lCsJiXiHyxEk2
	4QJtcJHh80P4rKEJ4HPBFuX3BTFnMY0=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f4Z3Q42MMzHnGgg;
	Tue,  3 Feb 2026 01:53:22 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 546A140572;
	Tue,  3 Feb 2026 01:54:20 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 2 Feb
 2026 17:54:19 +0000
Date: Mon, 2 Feb 2026 17:54:17 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<kernel-team@meta.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <terry.bowman@amd.com>, <john@jagalactic.com>
Subject: Re: [PATCH 4/9] drivers/cxl,dax: add dax driver mode selection for
 dax regions
Message-ID: <20260202175417.00000abe@huawei.com>
In-Reply-To: <20260129210442.3951412-5-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
	<20260129210442.3951412-5-gourry@gourry.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4595210000B
X-Stat-Signature: fysz11641tc5xy44y8dwbnbogwqgiuhm
X-HE-Tag: 1770054865-833824
X-HE-Meta: U2FsdGVkX1/B1aC6jA3O4YLapzxRMHcgByDWhKe3c+CXwTKtaCuwgSzStFe5NRy9vLDhuWNCL/w2llM9BUgwvnvI+YPdH1dfGBhexcQVSUB4PicShuQ4Zu7CgSeofh4YcUjOiKRcPrJ/YnJVQClfV/HhS6Jqx3xVkFgJmpF/7KaZcDb6RSPhjbgDgjlDo/M+XaGBPBwm0O4Rs5zuN9+uebskEmpt1I4fS44h9nf9DtoJD0kgKFKSiosONJgNgT9l22XFoNex/3ALKA/E90HstRxVFlC7zZCDY1TwGNQICY0vpDqjt5Nz1KMpOoKogu5VUOOagKx8Q2Wj4bSqbqi5jylnSDYQ92dDm9YcpxCOfQzMGqm6TeqR9hP2JPL7bVWK16Uv8aYR106X5QlTKj++5DEYDSxuTbV78/UaNa5wHmnanezbdXvT3LZqhpouejyQjLpKZO8rBDxvb1OaJ2czNjW8nbo1wk0HW/CG5IPKsi+DArl8W+WUcEKU5z7qKHdal6Cc45rZtenNOXK8SIzMFPPxnSYIwtO2mGKNXE9D4GBWFL3s2IuEe+QNMnc1mJEdN1nCFHeoei1WOfWxWf1he9Oyb4565yRhVb2d4pjsfpOKyYZbxtkOsrhACpeZ88VRBrptgsEqL+KgHRpa3qbXP/WbQD/xwQFJNJtbbtcqfgAh+ayljFgrSdPLCHgD7Hy5J2/Tk3WNU3QclMq2iEu69geBpru5uzrDb/A0NXSuQZcnzkOVOSU4LBFLSvqW60zCue3lXLrH1GsMRUJxOwUMtcv8toEqjPAS41gSPK+vjpLuMTu5Sv/3gbTtS0jyyujoeBQ5FUKt0Ovh5mJF8lq1XeB1VNhwYd0IRCcaoaQq0Nar0pw5j3nbVFaZ3/RMxmxubhTJB4aL5UKreY6RuM9qtVYchmZ01YcTfy5pDQx4vR/oHD9neyEr0Eghw+zpOn5tAZUBuFwsT2J2ESpZ7oM
 OeRrEfP7
 gtAhf3gIuIAtgi9fjGJ1rkqoTSO7NJK5Y/a4a7/lM+8k+y4HwbNR+qFfAjhvNfzyPYd6wVdHrq+9+8VZpjh3zqBbLJkkGqcLRjJkctKRWZOQcXfI3FFBMm15RAHWL/XljwbFvdatCLDQpd+FIzTmbkorRsi4g0epE5ui6Geju5OZM13CN8wRS9RW8UibJkxkadbJR9NZ85BmH8LwuJQd5Y3RVI7Tkju6s5ypgOSYScV6xGmKL6Hk7slbAgtBWwneukTULzSLfdv3A0uHLImUlX/3sN7XBBp+8NNW5mJ3t7w0f16uB/gNvNPX4lKYk+mEqWyFwWhaG2+KxF5toAIyhl3z96HcObDf+4oWO6dmmArfu5pY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 16:04:37 -0500
Gregory Price <gourry@gourry.net> wrote:

> CXL regions may wish not to auto-configure their memory as dax kmem,
> but the current plumbing defaults all cxl-created dax devices to the
> kmem driver.  This exposes them to hotplug policy, even if the user
> intends to use the memory as a dax device.
> 
> Add plumbing to allow CXL drivers to select whether a DAX region should
> default to kmem (DAXDRV_KMEM_TYPE) or device (DAXDRV_DEVICE_TYPE).
> 
> Add a 'dax_driver' field to struct cxl_dax_region and update
> devm_cxl_add_dax_region() to take a dax_driver_type parameter.
> 
> In drivers/dax/cxl.c, the IORESOURCE_DAX_KMEM flag used by dax driver
> matching code is now set conditionally based on dax_region->dax_driver.
> 
> Exports `enum dax_driver_type` to linux/dax.h for use in the cxl driver.
> 
> All current callers pass DAXDRV_KMEM_TYPE for backward compatibility.
> 
> Cc: John Groves <john@jagalactic.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
LGTM
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



