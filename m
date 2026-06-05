Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6235ECD6E6E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645056B0005; Thu,  4 Jun 2026 21:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F58C6B0088; Thu,  4 Jun 2026 21:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4876B008A; Thu,  4 Jun 2026 21:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 391566B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:06:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9496A05E9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:06:27 +0000 (UTC)
X-FDA: 84844068414.19.EBD5C07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26E06120009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:06:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gffu67pK;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780621586;
	b=seb67/7I/qr7zSIxY9Q5IC7JJQQ5A1aGjiuxEsMIcqYMNo99HfWYN7XnJNfJOUWyRYW3ps
	gqDg5Jq5Ru80IqjmFuZGtNsWS0MNC26tk05JhPZ7sXjtEKU+CUGQsYuSlu8HmXWcANx/wh
	XhgBGZslRUwd5y2cFcQa54BO5szL3rU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gffu67pK;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780621586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2jfgDGh1JqIqL3XwH3zVPi2aidnhBEMNm8yj1o7J8A=;
	b=4W5v8n0yS12IoDpVAiK6kG68UAyxv5m+J+OvIemuVKbCGwLg+6w0eSGyBR0bTWlv2cUKfk
	7KtEXs9zOzW0lvLR17RBDNFbHDY3V2G4diDEQJJZaxt0n25jnCTUjxRh5A7X8yOZBqTXJC
	EsK2TFQJR4Yb6ahIwyuM0mDskoPvmQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 553D5401BE;
	Fri,  5 Jun 2026 01:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AFF1F00893;
	Fri,  5 Jun 2026 01:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780621585;
	bh=O2jfgDGh1JqIqL3XwH3zVPi2aidnhBEMNm8yj1o7J8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gffu67pK00AcBbgZgJJLLwrZd3eSRjO95CGNVW/EFGuYpyN8pmAqRxLB288ZQradf
	 yVO0GMXO8jIdXbf2E6UzIEOo78NJj10aWMLnVRaKjYS7+bSe7hC6eDXFD2pgr3DOTw
	 TqWVWbiZR8RUX7bY8EZFeiQUWE6DHPFgTXa/b6iMBfm6Ac0vJUfmoSlCu37AONtYri
	 09XyeIvhx3Z0/RHvtrjcFFthd3LX29izDHjZPxAEVY0o91R3R7WEh3VntEVFrrMqxL
	 eWMVD6WqqvwLdueUJOhUmuD/ojS1VZJIkv5ucmEjfp+eVM+IxmKjJYZJrx1JOARU33
	 u94QZPvqaZ85w==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu,  4 Jun 2026 18:06:19 -0700
Message-ID: <20260605010620.83004-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604150338.501128-4-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26E06120009
X-Rspam-User: 
X-Stat-Signature: yngppj7tso47qzfe178dopky5dkuf89m
X-HE-Tag: 1780621586-552811
X-HE-Meta: U2FsdGVkX1/0KId7s/p/MDvYLCLAqwS+EDxRdkpfbbpU+hN1zbYSM7d0l0Boem4VLVbyPLaDInGDC8AKUIYtXIW4V2/csmRfeU/BRqL0RaHJIaaCF5Yj6qnWttuMY68dhJZv9VmtOt9bOCIDNH3libpNLJ0pkVscJ8T7KDJbKYixXAjI0jxQ66WZNoquQMCJ/crC0C5eaNdt0aQsrMSWIU/clE0vNso58FjGf9K4Pz6p25ANAaYWm7dgXhXGg+6Oeu0Ul6VoLYiSuRThKrFhVVj+BKavAixyD9v6u0stuBL38wXQ67JHSXyshp975Nd5wEcdQ9DMy0pcuSlP/kNQKreIRSKnmaVbyDI9l539xZAzf8lJFtmQRDknoYYPm4FxtuxufBc30QGWP/wd8MHdexazZVxMRZtvX36fn7fTD7broFkYoyNil8sNg2tr9XvB0pz3v0EpVAmFpOFLHfZy3MJF8AFOm3ugzPcnr22X6uqpsYeNW8n5BlpGtKFDdMxRKLjO+i7OSfA9agNEz4CHgAS2yaPEM0DssY1Wfw63bRi5SSgjWyJiF6oVvmlTZDj2GUw39tnKHmUWcMwOOo417nl9yEfm5D4A/Ryh8yciMZAc18PUHC18V9EMpwpVhh4PxEx3RNSfef3V7E5o/xNZYEt2x2qP6p7W9CZHIpm8kl7iDqYvapV+7Rcc/FNEkQ9otBA8tNQMzYpRYmLbg3f98FcZQ+9aYeLSRwuNLlxZEcFRNSi0fbTeU/YYhIOIo9UMQwJWoPcPVoMoBvO0NlAHyurhtFHmbgLjbYQ6XsdzAmAPBdoRsb8TtKRVCuoYRGdcmbTcDhfIiWkwJtWEvToAhS+rfvMkxG0EER91S2BWrBWDj4reLha5C+aE5kLf79tfrk7QirONWHuzH6NAL0gHnsALVwktr7BnSYXbf8E3+1lv/i1PpqiiwCb8LR6kG+50sykv9kaQegSo1dcI2sK
 yyXaQ6Eg
 fxv2ZuMvF6o5wOCAXvG6PWdcCH9mO35tZu19FF2PmBRi4J/0270XvjPumMRMFOkMHxY+5NEWq+GfahcKwEWTIXeB/1+NabXqgy4oTTcQtD8sb5hbaZEfCYz2APYwAot9eEH8olgRk37i/09qoNtf3P8MdFJw0Cs3mYm21EPYKtSSajXN/ThBpUclBo43AQZfJAOSH079KnlFHCW/ihTLbeMPYEKHIyTCmo6E/c1sXIobkAJy101WsPSXLspYWuciVbgWBsfZ7aO+I2JLejTFw+Kb29sw7rmnRpy6/5eVCNKpQqJXq+TlMPKmM1Qo5bQ9RVndNr5qDUjzRmHNMKDR+VAlYRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 15:03:36 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch introduces a new DAMON module (SAMPLE_DAMON_HUGEPAGE)

Could we make the name shorter, to look more consistent with other sample
modules?  E.g., SAMPLE_DAMON_HPAGE?

> which collapses hot regions into huge pages.
> 
> SAMPLE_DAMON_HUGEPAGE operates in the virtual memory space, for a
> specific task. The user is expected to supply the PID of the task
> that is going to be monitored through the monitored_pid module
> variable.
> 
> SAMPLE_DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
> increase or decrease the aggressiveness of page collapsing. User
> autotuning is also available for additional tuning aggressiveness
> control.
> 
> The module also includes changes to the DAMON compilation, so that
> the module can be enabled or disabled.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  mm/damon/Makefile              |   8 +-
>  samples/damon/Kconfig          |  12 ++
>  samples/damon/Makefile         |   2 +
>  samples/damon/hugepage.c (new) | 350 +++++++++++++++++++++++++++++++++
>  4 files changed, 368 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/Makefile b/mm/damon/Makefile
> index d8d6bf5f8bff..16459ce40304 100644
> --- a/mm/damon/Makefile
> +++ b/mm/damon/Makefile
> @@ -1,9 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -obj-y				:= core.o
> +obj-y				:= core.o modules-common.o
>  obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
>  obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
>  obj-$(CONFIG_DAMON_SYSFS)	+= sysfs-common.o sysfs-schemes.o sysfs.o
> -obj-$(CONFIG_DAMON_RECLAIM)	+= modules-common.o reclaim.o
> -obj-$(CONFIG_DAMON_LRU_SORT)	+= modules-common.o lru_sort.o
> -obj-$(CONFIG_DAMON_STAT)	+= modules-common.o stat.o
> +obj-$(CONFIG_DAMON_RECLAIM)	+= reclaim.o
> +obj-$(CONFIG_DAMON_LRU_SORT)	+= lru_sort.o
> +obj-$(CONFIG_DAMON_STAT)	+= stat.o

This is for letting the new sample module use the code in ops-common.o, right?
I'd like to keep sample modules simple and isolated under samples/ directory.
Could you please make the sample module simpler and remove the above change?

> diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
> index cbf96fd8a8bf..512f150aaabb 100644
> --- a/samples/damon/Kconfig
> +++ b/samples/damon/Kconfig
> @@ -40,4 +40,16 @@ config SAMPLE_DAMON_MTIER
>  
>  	  If unsure, say N.
>  
> +config SAMPLE_DAMON_HUGEPAGE
> +	bool "Build DAMON-based collapse of hot regions (SAMPLE_DAMON_HUGEPAGE)"

Can this be more consistent with other sample modules?  E.g.,

DAMON sample module for auto-tuned THP collapsing ?

> +	depends on DAMON && DAMON_VADDR
> +	help
> +	  This module monitors a certain PID provided by the user through
> +	  monitored_pid attribute. Hot regions are determined by DAMON-based
> +	  sampling. Collapsing occurs according to the quota goal using total
> +	  memory usage to huge page usage ratio. The ratio is set by the user
> +	  through a module attribute.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/samples/damon/Makefile b/samples/damon/Makefile
> index 72f68cbf422a..f90845faec85 100644
> --- a/samples/damon/Makefile
> +++ b/samples/damon/Makefile
> @@ -3,3 +3,5 @@
>  obj-$(CONFIG_SAMPLE_DAMON_WSSE) += wsse.o
>  obj-$(CONFIG_SAMPLE_DAMON_PRCL) += prcl.o
>  obj-$(CONFIG_SAMPLE_DAMON_MTIER) += mtier.o
> +obj-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= hugepage.o
> +ccflags-$(CONFIG_SAMPLE_DAMON_HUGEPAGE)	+= -I$(srctree)/mm/damon

As I mentioned above, let's not mix samples/ with mm/damon/

> diff --git a/samples/damon/hugepage.c b/samples/damon/hugepage.c
> new file mode 100644
> index 000000000000..e24562c92348
> --- /dev/null
> +++ b/samples/damon/hugepage.c
> @@ -0,0 +1,350 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 HUAWEI, Inc.
> + *             https://www.huawei.com
> + *
> + * Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> + */
> +
> +#define pr_fmt(fmt) "damon-hugepage: " fmt

Apparently this module's source code is following patterns of reclaim.c and
lru_sort.c.  That's for non-sample modules.  Could you please rewrite this
sample module following patterns in sample modules, like that for wsse.c or
prcl.c ?


Thanks,
SJ

[...]

