Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECAFD1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:52:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A73C6B0005; Thu,  8 Jan 2026 10:52:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453D96B0088; Thu,  8 Jan 2026 10:52:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CEF6B0095; Thu,  8 Jan 2026 10:52:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 234066B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:52:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE93213975E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:52:04 +0000 (UTC)
X-FDA: 84309237768.30.B33CD41
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6D2E40014
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:52:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767887523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQzyI1+3vWEDMdlaRLlj1x/3OvSgSmIKzwUdP25ft48=;
	b=7LfLf7ytCJLS2sXypCMCWTH5JYd2J4RjSVWbiH7W3Xz1LzaN2zAvX5HxqXeWcd17nZHBll
	aKLAm3sRQQSN9wu3zAErJXsoxxvahHpcgm8PyYLODX1H0RXVg0QSYxYNOyTYs2g1XH/MKa
	15V4yq+zF/VY5CnlBSU4MlKVsa/xSgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767887523; a=rsa-sha256;
	cv=none;
	b=6QEgGFbrJTSA/bgPQAQus5wTYIixeHkKVwzkJoOxGQrR6O5fGqct/kzw8428lJgJRxOTLp
	/oh9fJUTVsYLHhXiQJ/zQBJRILYROgWRPLXQL4O7PeGiPSejl+PIfHiHLFZu5A/ZX0Kbcj
	9YQsvG5urjmKU15a5Okoh9XX/2goNuQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn8Xk75mbzHnGhc;
	Thu,  8 Jan 2026 23:51:50 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CD0240086;
	Thu,  8 Jan 2026 23:51:59 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 15:51:57 +0000
Date: Thu, 8 Jan 2026 15:51:56 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<hannes@cmpxchg.org>, <david@kernel.org>, <mhocko@kernel.org>,
	<zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <bingjiao@google.com>
Subject: Re: [PATCH v3 2/3] mm: numa_emu: add document for NUMA emulation
Message-ID: <20260108155156.0000156b@huawei.com>
In-Reply-To: <20260108101535.50696-3-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
	<20260108101535.50696-3-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D6D2E40014
X-Stat-Signature: 95wycz86xdcxwpff34rz6jxkchmodx9t
X-HE-Tag: 1767887522-257925
X-HE-Meta: U2FsdGVkX18u7WM+DoONFaUo8NzLY9mU0Mzdl8RqaXQXhPmQBKTGldNk13fYdwxMYL4JJR5bOJr8YREjH0GCL4/VjJ01MJlz2MceHDddy8CxPzv4J3aYuI7gN1dnPxTzTlRu5o44HePQnkq9DAoSroklRfARlNkBk3MF/efXFfTHPYB8ST8A/nQr4hGAlWaaAXHmY4XQSLKklIiyqllt6VauXkyAIySx/jbcOBnBIp10eX6nYGZAJPftde4SPUGABLVd7KcOsTyIGT874Ksu3ifHuFwhMMmVrfoQ0Jh+fYSWh37Ochanq7Y2BolwrDxXKGSJ7TtDG6U3uGNOWJllc1Tc53KmKpTsKkj7VZpCc4KGkZTtnqSjUZ8o3sXp8SaABOmLs11s+Hrb8PJL6/ziHnWQb6ir18qT0zcWci6falL6XABwq2fOjuLPUk42SPAMVw2xJ8M3Xl5xen2d0E5agLSsAJKpvukiBx2jSd1ECtA54vJQFfFw8VcgTCHaRCdTCOjDeRuviW9axKXCwqHcxfQkGYRMktqcSr3TsniKFk4ecfxg3wVYQmvh2GY+XTozK44ENXQetEeMLlfBw2jN+2Gs8YxMiIypNIlWTfBfxm1myrFXtDoQ+imgrDqx7eSt3hAD1rjYwELOH8JUlENrfT1YcFMD6SH310Oj3OVCUv2+PncQwJU5TJjEMLqI3tYi1lTxuSeST0cbsDrKkyzSV/64yLBzQm6LyprGZsyyDflJ38yOWb/EJN1TH/8JmUPwsIsIdzLQJxs4KPxVWJtcC7YNkF7YiXCnNTnxF/qof53kiISAaxWDMerd4r1RkIn3NWeFr5CDykNcU5awSFTblhbjsVUoZVYxbhC7eLk0CizcHseN8E+tZR6Pb7ryPxrgwA8VnOJZNPhcH5YofjNl4Xm8sAVxlI0OJyyprqmDAUrYS3pD7qiBqMzdHvzaqnvsz8WE2uhXn20iDI/CpwR
 UWNPO8Ys
 aMMjXTY2DeUp9mKzs31MEinvL/lW7hj4k7ZRH09a5IIilxIahoVexYxT/YPoxeZNe0tTNYyZymce4Q5eWUeB10sKGprVPB5ud9c4gFnd3CUTHmBpRD2wDpsY836Ma0qhHrSk5QF9sfNbQuqpKw4oEYWprEGnFgrtGSO3ILA2zxvh0O26KRnwZTunb0YLbYW5twwKCeGsXEQ3DaFedwV8BV6lm/Bau7tb2Q0mLZmMsS5RBYbkyeWSfg7qto8OPVHNpWyDNnr+RaKnGYd8WXjqAJf/dIlj+dawtZdDQhE4+/yZphLbfjjlyT2HlgyScR71NG7xFTBK9Dnl9na791vBdw5WSYuOgweqxqrBTECqWgMU1BR7ypACj5whTusrXbNo0yORY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 19:15:34 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Add a document with a brief explanation of numa emulation and how to use
> the newly added "numa_emulation.adistance=" kernel cmdline parameter.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
I'm not sure on the benefit of a NUMA emulation doc that only really covers
the new stuff in your series.  Feels like a more thorough doc with everything
in one place would be better.  Still, what you have here is good to have so
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
> v2:
> - added in v2
> 
>  Documentation/mm/index.rst          |  1 +
>  Documentation/mm/numa_emulation.rst | 30 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
>  create mode 100644 Documentation/mm/numa_emulation.rst
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..7d628edd6a17 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -24,6 +24,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
>     page_cache
>     shmfs
>     oom
> +   numa_emulation
>  
>  Unsorted Documentation
>  ======================
> diff --git a/Documentation/mm/numa_emulation.rst b/Documentation/mm/numa_emulation.rst
> new file mode 100644
> index 000000000000..dce9f607c031
> --- /dev/null
> +++ b/Documentation/mm/numa_emulation.rst
> @@ -0,0 +1,30 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +NUMA emulation
> +==============
> +
> +If CONFIG_NUMA_EMU is enabled, you can create fake NUMA nodes with
> +``numa=fake=`` kernel cmdline option.
> +See Documentation/admin-guide/kernel-parameters.txt and
> +Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst for more information.
> +
> +
> +Multiple Memory Tiers Creation
> +==============================
> +
> +The "numa_emulation.adistance=" kernel cmdline option allows you to set
> +the abstract distance for each NUMA node.
> +
> +For example, you can create two fake nodes, each in a different memory
> +tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
> +Here, the abstract distances of node0 and node1 are set to 576 and 706,
> +respectively.
> +
> +Each memory tier covers an abstract distance chunk size of 128. Thus,
> +nodes with abstract distances between 512 and 639 are classified into the
> +same memory tier, and nodes with abstract distances between 640 and 767
> +are classified into the next slower memory tier.
> +
> +The abstract distance of fake nodes not specified in the parameter will
> +be the default DRAM abstract distance of 576.


