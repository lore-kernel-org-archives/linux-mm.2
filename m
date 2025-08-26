Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C577C8303F
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1E48E008B; Mon, 25 Aug 2025 23:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C99D8E0038; Mon, 25 Aug 2025 23:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506FB8E008B; Mon, 25 Aug 2025 23:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32E4A8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:17:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC6E11A0631
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:17:05 +0000 (UTC)
X-FDA: 83817447210.30.863B3D5
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9293A4000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:17:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756178224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOtVVgTMRxsacbra4z0RAFmw6Opis8uOFbVsN3QflVU=;
	b=O6AyQ/fWwSHZoGjJwT/6CryDiVqIJVfQKSL4OVZ36rgmKNnyqeVup+Ml/zP4qlTYAAMMPq
	dWZqS3F/s04NVS3lZSJZpNnTsk2itR83JNxkwkS0TmSGiHYYR72yfPfiss5sbRx72wcM+p
	j/K/A6QHtwOkm1Cu/jQ4ehN2vf7SNRY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756178224; a=rsa-sha256;
	cv=none;
	b=YKWT+N32Qf7gxjOYFmPOGIkzwHHZWeHSWPQcNawu0mmXH8Ovkc53wfMsqSJ10mW4lFcTER
	WwG2FylF4zxd+8AIjbBUZoR+46CZZkkc8/8MRQYM3v995f9dzslvpRpD2sDDrMjoOU841g
	S1EatXZzjkLdrkmsu52eTDXuV/kgWiw=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c9t6f3GlDz1R998;
	Tue, 26 Aug 2025 11:14:02 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 23ED1140278;
	Tue, 26 Aug 2025 11:16:58 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 26 Aug 2025 11:16:57 +0800
Message-ID: <7de69c95-bbf7-4dd0-91e9-640da8b8cd5c@huawei.com>
Date: Tue, 26 Aug 2025 11:16:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for
 DAMOS_PAGEOUT
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>, <kernel-team@meta.com>,
	kernel test robot <lkp@intel.com>
References: <20250825151205.36288-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250825151205.36288-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: zqtrraasa1p1bo57ybyhxy3f9gcp9uqz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9293A4000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756178222-987493
X-HE-Meta: U2FsdGVkX1+XVSLD6vC2/SjjTZIFA3muK9d7JAy0J0EIsbrUt5to8F6VE9R6Wo6Pmk1fMhPFhZYfUIgxCwuBbqCRhr5HU+fHM3fgHYmLBj38NXTNptIahPw069D7r7gKfE4bTt50e+ThU6oqFgvMfzQFolnFzabxfFkMIhbpztkrlEu6huAAB2qsMeFnFmsBWNeOTWI6y1LrUe16BZhjJ4ZduKn75PJyjszlkgxymCcncOwrjPM0o9SZdbFenPtHPznpRAoo6sPlnmLAtmzkFJL/aHtofpi2uxXhgJYwNfr/CiOJsWQd6xdF9uNEaNcCzfVqAblTjI+hMBkFokBDT2sCQz8wzN72XGQYW+IX0Y1+mb3YjbaBneofcRlTx7VtGuC4d1FtZYTp63qVK56kY8koGVM7zFEPwYtlyBCwGVUCg40WJYQRlDcU9YvLp0Jdj08+B9zKWKIWBXCSu7+BS1s3+2E4Wjfg3sc6Hb77BYNGO2wKVClfB2GHD68cME4eC9yGEMU3XM4kZFe8ontwICWYtOMvflK6lAtMRP18N4eNt5vR539jfGWcEeP+M6FYeGoGVBGvgAXaB1DtgMQ/YVk3FOg2vgoW5G43LH19I7zANcN0sRaZIu5I35WmobDHZdnA9/Z19phJBi1IgWtRPCPPDmhZ4Z7rg/PLlajeYMNwo5vBz//Hs+3AKZevnjhQGBRbZAjya3DA7eBSNL+Ruudg919BG2ZbWRWzzx9o4RuNzirArkVILcR3SuB8sAxINFcDHmS721RaMalUgfzjMWV4kQXrOMHCUVsN8He4jrOphUrBLrSfLmIgwjjljgQCuaIcWVqyoXXQP4hGPMbxdIj63vJo03xcz1cwCidvB/tejoWCjrq5vMM0KumUAv+fnNjPgwMEgx0MGXURMi+Ljs6fkEzXn2r/KIO+ggkVUUH+94/oelIp28RdkfrEGz4M7CL3Y6sJ7vE0hvzrj7A
 b/FNFYTN
 iQ5J7HqIZBbfSrZo/8bSjlj0MibLpyWbapoL42JbEKTqqI4I2tIKN8I3KFZglUiDlnUAdic2mBWrclifC9h3uEzUu/msanDHugzdwy9uyQHyBzwAjAH5I6A+jSTRlfLem4tZAUStsdWCKzrOkovwgz5I34tAnoK+pvGEOTsNH631o/X9oeKA7NV2z4BPfNP/1qrDeQcdY6N9Z7c4u/PuNi+/5CL+82ggLzWmNh39n1ci5yCK7iPPSzDRgBeivqR6SzkBCNW+Obwh+aWKcFSqtNVU4D41Pe5Xrd02ywe+cMGwZmBUUc97K9iLxiIbPvdi8Cjm15xTO0od5N881ib62ZPfrIA8M0yQ+54ivoE4kISuv3CgSWy3ijrg94ugS+v926FBlRv2/I907hnz4vDWS/UVFiYNuWupothDIHfttvII8pqCP7u6cDk4uJBSBlna/akKqUiNV5PI+Ht9qQm+Anshz2mKLZiLPEVSD7i/jNgZ5p47WQ+auZ+LlpSfbj3iQM6vUQ2VQXddaB9gCic63dAOy2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/8/25 23:12, SeongJae Park 写道:
> On Fri, 22 Aug 2025 17:34:11 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> From: SeongJae Park <sj@kernel.org>
>>
>> Add support of addr_unit for DAMOS_PAGEOUT action handling from the
>> DAMOS operation implementation for the physical address space.
> [...]
>> -	return applied * PAGE_SIZE;
>> +	return applied * PAGE_SIZE / addr_unit;
>>   }
> Kernel test robot [1] found this can cause __udivdi3 linking issue.  Andrew,
> could you please add the below attached fixup?
>
> [1] https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
>
>
> Thanks,
> SJ
>
> [...]
>
> ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
>  From hackermail Thu Jan  1 00:00:00 1970
> From: SeongJae Park <sj@kernel.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: damon@lists.linux.dev
> Cc: kernel-team@meta.com
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Date: Mon, 25 Aug 2025 07:41:33 -0700
> Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
>           return value
>
> Otherwise, __udidi3 linking problem happens on certain configs.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   mm/damon/paddr.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5fad2f9a99a0..09c87583af6c 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
>   	return false;
>   }
>   
> +/* convert physical address to core-layer address */
> +static unsigned long damon_pa_core_addr(phys_addr_t pa,
> +		unsigned long addr_unit)
> +{
> +#ifdef __i386__

Can we use the following condition instead?

#if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)

Thanks,
Quanmin Yan

> +	do_div(pa, addr_unit);
> +	return pa;
> +#else
> +	return pa / addr_unit;
> +#endif
> +}
> +
>   static unsigned long damon_pa_pageout(struct damon_region *r,
>   		unsigned long addr_unit, struct damos *s,
>   		unsigned long *sz_filter_passed)
> @@ -190,7 +202,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>   	applied = reclaim_pages(&folio_list);
>   	cond_resched();
>   	s->last_applied = folio;
> -	return applied * PAGE_SIZE / addr_unit;
> +	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
>   }
>   
>   static inline unsigned long damon_pa_mark_accessed_or_deactivate(

