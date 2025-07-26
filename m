Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE597C87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 03:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD626B0089; Fri, 25 Jul 2025 23:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5646B008C; Fri, 25 Jul 2025 23:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2216B0092; Fri, 25 Jul 2025 23:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7D96B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:36:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E20D55C08B
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:36:21 +0000 (UTC)
X-FDA: 83705002962.02.B1A787D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4423D1A0006
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 03:36:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iXZnHIkt
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753500980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SqKK1itEFeyqao+wJaeXuZjHvB4xmHKjQAwZpz8zt0=;
	b=4FLw5uOT8dFrk8YgyAFk6KvbMCBsE/twQaR8Mq8XpIINx6Kw6+dGiP6pTivDNqs2GtNQLx
	TLniC1XxR5DSo+k+5GL3ENXFCrjuVuwhSP8IOnFitU4k368kz9O9nbKwFAAW4L/EnymVFO
	NA/YFmKxPkvYLe+wLylPQsZg1hI0NWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753500980; a=rsa-sha256;
	cv=none;
	b=ErdWPVHJCbvfvEKAfbsKDXzLjbAEmftFnOPMD6gxXych2vyQ8rRNg7S/j8TPpTNthmb23u
	lX9tAcCJoww0ydC9QMyh/t4OX8Msan6USPgZhd3+t6h0wq1XAZdqm1vqAO/nuYNGv843zD
	R4vSH7aaZvc7/Cj8U3x++fZMN5u5Hxc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iXZnHIkt;
	dmarc=none;
	spf=none (imf19.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=0SqKK1itEFeyqao+wJaeXuZjHvB4xmHKjQAwZpz8zt0=; b=iXZnHIkt5XNkk41IakbLXc3TT/
	VlOBtt4hbBrKqRz9anPJNXv8D4IwuY6U36ttsi1mNzLyklsogRm5k8NebdKtPbrV477Us9lmRy493
	AG1leB9CMMSkhivLuTx2ibMe81Qi3VEJswvfeVLL1DmvB4EMgAtTKAFNjR5/LBJYtDSSRcaGMYQ0y
	wdyIbvS7ldyFKYgyNg9Dzi1EeX/GEtzL2Vlug9858seMBXcan3f4wWyXqO+tyDlpKH7ZV2aaolZSj
	9eTQxAVa1z/GT35Le6gy29VoN7MqpySiX69AmzKlOyr1Y+OmDhC9TQh6SfbmKoc4eF9bY5hcTpMtd
	4xy+Dt4A==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufVhr-0000000B5Pk-0JWR;
	Sat, 26 Jul 2025 03:36:19 +0000
Message-ID: <0fa9e4e7-1247-4c82-8c0b-fa65b7fbb56d@infradead.org>
Date: Fri, 25 Jul 2025 20:36:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 01/29] kmemdump: introduce kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-2-eugen.hristev@linaro.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250724135512.518487-2-eugen.hristev@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zxgxua6iow3yw46pjgbe7erk4qdr5hte
X-Rspamd-Queue-Id: 4423D1A0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753500980-454520
X-HE-Meta: U2FsdGVkX1/+dxcR6RVXoiEt2MsTeRjP2d/Bc4My59Q/4ej7/kbYk5hYneIrK//hHazM29lKeiJx/n1qmvSS82+3ppDPYqf28ScinPdlTh4uxO6PLfEyYr/ZJFTawPnDVjViOXY7ipPqoL1OqOkbFep7UVGKvfE3XjuhGaMVe+YmecRroEvaLQd2Gk6pvtzuMA1i7weWaE2TTxRmVVvqRvZ8CA9rV2DQqCMQtExPcIOTt31nRRR5QEw8qq834kr48uy+nAB0K8BDw/0YVPDjmjwoMG26dbJP5xrdPQXSiFk/wI5qEb6tzj1G2/Y1ly7Pifs3OQdu7NPasD4pP1z2ksCfLG1ztuCTTZm6c1/dpSd6BNjPafg3dcBLHNMx0cuW89AyDIclzdSp7ZkIsIVs842/MLG83GNY57OJvW/ryrS6U3ZVnECOsKTN1vw7aNT+fsMKgtAExORN8FBHAXuIO7G27Ewns7eJqyHqSXwypafngCdfq8J8s3Omc07ESLTU1+rUib81HCXP/XyijsPrY8nkLDj7yvdN2U7/EC4Nv8O4m1zKQHHcILKWM2k3Xo0GeoAhR6lygWJlkQJM6G00R4Fdvt/g9TyvjiXjsLA26HqxyQ4zBk77Ce2f+ML2IsyOxf8NAWaGB/ojnJuvB07BWFArsY9GqtbvRfa6RQAfOvbAA6YL86BT7CamXbgSXAUWvDfNF3DcxWLi8/bXyT8rlDJ9qjGtdjfKan5ey/Ys30E3SaUxmQYTleNH9fHtZUTWQSKHrM0kPoGZGZBrVI0V6xrS4wz7SYs/Srti0lji2ELKwCfCaC+97cZeKAMSrxkS/OkrJL5Jufg/R5hlKrUyst3w5NjGdo7rpJZkhaH7a82YDqnfXJkuiBZ9Dmsc//YApGKooo8+rpzjSXIMDe3QmAb7WIbMfzBnh97gse+yQTnJ4szw9wtrF9gyiuDm/e73qwzw3oQD6XkZn+tO9Vf
 l25MUPpc
 f32PD3eahCfQnmkl2Zr+3C9xYRpRaSRHspQgWdzTrGudb9EFMNAccIxhaXMqYhDyQJpILzNVuCDaL78OncFLxqlTSKCGphvsSO9a9qqM4+FNj86YPzYjuXmfvvFjZK46gB23gwdJA2LtTfeKkmSSEUmBPKPVdLwQesEDnnOtdxt3gr2MifH2/bJVC2pbvdbtm/Dz6qhIKUtM8OH561dgjS4hIzJhi9G/YLyCfRkKn2V8s63R+lTlqgenbj9AiuStv3sAG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 7/24/25 6:54 AM, Eugen Hristev wrote:
> diff --git a/drivers/debug/Kconfig b/drivers/debug/Kconfig
> new file mode 100644
> index 000000000000..b86585c5d621
> --- /dev/null
> +++ b/drivers/debug/Kconfig
> @@ -0,0 +1,16 @@
> +# SPDX-License-Identifier: GPL-2.0
> +menu "Generic Debug Options"
> +
> +config KMEMDUMP
> +	bool "Allow the kernel to register memory regions for dumping purpose"
> +	help
> +	  Kmemdump mechanism allows any driver to register a specific memory
> +	  area for later dumping purpose, depending on the functionality
> +	  of the attached backend. The backend would interface any hardware
> +	  mechanism that will allow dumping to happen regardless of the
> +	  state of the kernel (running, frozen, crashed, or any particular
> +	  state).
> +
> +	  Note that modules using this feature must be rebuilt if option
> +	  changes.

It seems to me that this (all of the KMEMDUMP Kconfig options) could live in
mm/Kconfig.debug instead of creating a new subdir for it.

-- 
~Randy


