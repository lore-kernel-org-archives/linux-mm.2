Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D940ECD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249CE6B0096; Sat, 23 May 2026 13:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2C26B0098; Sat, 23 May 2026 13:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B706B0099; Sat, 23 May 2026 13:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6BA96B0096
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:27:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7576D1409DF
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:27:37 +0000 (UTC)
X-FDA: 84799366554.08.0C73BF2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6A18140011
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:27:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrwOKdH1;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779557255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXaz7Q/CnqS13vT7T2cImdcs5ms1pR0AbdhKZsEe4GY=;
	b=UKnEs0ExdAgitgzBJHYSX2fcK7p9Y+eTvrAac2H3rO18r/RkDcVZ6PsvMsi27Wqn8r1AiY
	hHBKSFxv/sIZZJTQmLinMDLV0wNgyIRLzjfSeGhtVna/BSWE2worL9AoGhOVgqHMzd3qUO
	uNBxVzCLxU+KPEp5dL90src/uPceDXs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrwOKdH1;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779557255; a=rsa-sha256;
	cv=none;
	b=C0pD0LwnTQ15Cu+ERrvh2udRAim+F0+DqUrgoFsurM3pIR5Th5AY7G5lu1c3bhosoyWVEC
	PboWnd3Nh/K5TXxhJTMixTGDl3qGIqTD4kGs4kzpy8tZ3YFPX1dkQxAHjnNBBevqv6DlwB
	pGHCqOaHCIpR7TjoIJ7pV7tuRM1hwGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E196144191;
	Sat, 23 May 2026 17:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2611F000E9;
	Sat, 23 May 2026 17:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779557254;
	bh=XXaz7Q/CnqS13vT7T2cImdcs5ms1pR0AbdhKZsEe4GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrwOKdH1Vd3OHCIuYkHLNh6Q0ty3iMtNYDfdWT7NJtsVadnpW/xHvK/D4ALdk2XYh
	 DSY2dY8UuNJRcke2SRULm/5FkjfyTUlHWbGf73O4lKSk2l5v7U/BkuyqFB8yliF9E9
	 sds9XRX279/pPEx2SYWQzok1GbnlzACwTrQ+twf5KpHCrNi4A7Uq00sXI+TRdi358F
	 7XH1VRyaJ1l2cYvRZS309gC5vdvhyG1aNk8tTyLSr5zKwoou6x1wiVm0BkLBFeD1F/
	 2VVmLnlK+fCUSV44P4VOOl8pHsalQQu/4m5DxtOH1qZrKuou69oHdRICpp2uAm+ucU
	 zPD8Xxf2LNz6w==
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
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Sat, 23 May 2026 10:27:25 -0700
Message-ID: <20260523172725.89221-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522145518.158910-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j86xozjz34prp99zf7nu8f6gw153phxj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6A18140011
X-HE-Tag: 1779557255-292519
X-HE-Meta: U2FsdGVkX19X1vDhV8os7DJ8P7YYf9r/CtPwYKd3vUghJHNfOE2Fx1yaVAex9UtqnU8FCrqVEHM9IVdFnOGf0VhyvQrqkKlGN6DirdljqJluysix27Fn3pw9PvMxGBrtB69PVRQdYa26LhjP/lEHJFvKU8Ld9cw0wIdfSIUuGA3QWwYDmq+x352Pvydld3j+fJ24hZElCBuouUpnJkEl3zXVi5y+CS/ZTEbvcLTFtdydtwaJritOxw7KZ6j2uZDE+B7mtZrlIcpaoGtqV3yab8lESq3JP5hLhwG3vbjfK99eaWTNkwn4MwrhcAbMdrGVt79j+9Xtw4x03vBBgrGy6hoSuEki2M8LzuBYVcGdpuVdhkSfPfnr9BD81ewDWl7wHx9KoCBOlkmDJ2DKe60hTWbFAAvfqKe41JTygHR6PvX5XlDFfpbgs72IdampkVgcslEAuu92q1edzFEsrKvjWcAUDGaFpMdtoIvbkdQoRE4j1GSwkrpjG8y/8thvJ7iVQWrdXLprHOtp0Q3pN85e2f4J4Lsut+19lSCcAOIAC9ZuMLBZ+bneCaq71sYdKxIiZJr/sXE5racBmECH6Qthc5I3JZqu4thlP31T4anyKtgbq9xxSQGXM3GORHmptCPGmRoQBKwC0d/prcz/ut3GUEZaCV5MAxd95ZmP13/TPvmkbTwiYWgPDFOodtTzn2laqKN58dbw1C/SPQdaRxQd8KpR34diO07Ys1tmboyfu9AjgGpieXt5jvkWX9mWqtWDppzGZ7LGjyHsEu70O1l3+1r+aEhw1AAIVaCtQtLtGF9wlHmA9SZYC4IFwf94TclJK+qtwHC5Hum8zMNhgKSJtMTeC8/3aBs2tuxO4VQ+sErsdqQCxVMGQkw+8fK84pG0GzK3fRdGuf2zZXxgWAYJS4x6yom6E0KA7m06xSV7vCX/qHEBJP0n1hYYwVxfEcj/Hz/GX4/dme9FKlUk9fT
 DMqDYaJu
 6nzGHyuQkDczza1PvJZhMblNRXXMPPHbAJcSkvIk0mP1CXjHpEgXcnaBzr5UMNNeJT2Irl/eUmYMDhD3PEBlvkXnJ7TXe4ScJJw51i6hiWJqbLH37VKiuaYieC98NJsAE2CgzWM3ik7Cru00Dr4w/IlQZ/+xu6poncVBZYWi6OTgP64UzWlL3LGxM8v45dxFuzomRytw0zw5peh69IrlhArZ7a6UAbMrvhgdPTcCd4N/xlZDmLUhz7nM2hSryW4qvpsmfdNiegZmP6szqWBFJlbThmdlH6FiyquMRor+WK8y6uKpzdZVt3bhzb2ySI2t4xkUd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 14:55:16 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new DAMOS quota goal

I'd suggest to rename it to DAMOS_QUOTA_HUGEPAGE_BP for consistency.

Also, you missed the ending period after 'tuning'.

> metric to measure the amount of huge page consumption to total
> anonymous memory consumption ratio.

Why against anonymous memory only?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  include/linux/damon.h |  1 +
>  mm/damon/core.c       | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index c7a31572689b..8e15a674e893 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -177,6 +177,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
>  	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +	DAMOS_QUOTA_HUGEPAGE,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };

Before you drop RFC tag, please ensure to add kernel-doc comment for tyhe new
value.

>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 9f38deddcb30..1f1cf10aa241 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2536,6 +2536,18 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> +/*
> + * Returns anon hugepage memory to total anon memory use ratio.
> + */
> +static unsigned int damos_get_used_hugepage_mem_bp(void)
> +{
> +	unsigned long used_hugepages, total_used;
> + 
> +	used_hugepages = global_node_page_state(NR_ANON_THPS);
> +	total_used = global_node_page_state(NR_ANON_MAPPED);
> +	return mult_frac(used_hugepages, 10000, total_used);

So this function returns anon THP to total anon pages ratio.  Why only anon
THP?  Also as I asked above, why only total anon?


Thanks,
SJ

[...]

