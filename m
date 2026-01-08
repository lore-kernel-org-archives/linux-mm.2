Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D323D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 15:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1FD6B0089; Thu,  8 Jan 2026 10:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479E16B0092; Thu,  8 Jan 2026 10:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2DE6B0093; Thu,  8 Jan 2026 10:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE186B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:47:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C04311AD34
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:47:47 +0000 (UTC)
X-FDA: 84309226974.14.5620DF4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id CD14B1C000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:47:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767887266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5I+oTRNExw8wz30CEOXeWaJTBiVrRbXwGfFXAxW5R4=;
	b=TfuBvYlwzRBbrl6cF05aYOqKSbifJcNq04IBj32XnMpualXAOBv548fjaXlMS3SWFcnuGW
	A1LumNxVjcl4PTfGta6LSUy2/b9lSUhU+q5ocWGJRkqn+dt92XfLwcSw+0vea/UonFKePm
	NjmlzmId5jrkaAlVRcAT9PtwpV6Zjm4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767887266; a=rsa-sha256;
	cv=none;
	b=s2nOVMvLJOHdkHW9fvSo30tDcGBywRFF+7laFPos+rSpqfwpe0JWVeIF1sBvi4FWKaO2FT
	I4ubja6TNttMrp0sVDuxWXya4tZvGV7CH8/af4yZjL138lIMUunZ05kFe2NOxR/BvcUt2u
	5PgOvDdSdHE2SiK79TcgxHclgBsOaC0=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dn8Rn1V78zHnGjb;
	Thu,  8 Jan 2026 23:47:33 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8DFFA40563;
	Thu,  8 Jan 2026 23:47:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 8 Jan
 2026 15:47:40 +0000
Date: Thu, 8 Jan 2026 15:47:38 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>,
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>,
	<hannes@cmpxchg.org>, <david@kernel.org>, <mhocko@kernel.org>,
	<zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <bingjiao@google.com>
Subject: Re: [PATCH v3 1/3] mm: memory-tiers, numa_emu: enable to create
 memory tiers using fake numa nodes
Message-ID: <20260108154738.00000e47@huawei.com>
In-Reply-To: <20260108101535.50696-2-akinobu.mita@gmail.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
	<20260108101535.50696-2-akinobu.mita@gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: CD14B1C000E
X-Stat-Signature: b8rx35b1zu6xqihm9r8e1m5cpq4kihb4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767887264-190149
X-HE-Meta: U2FsdGVkX1/94M+syyY2eDOwz0DVZi46wh2kkooMVQRNSafM86pWyG111+Ve0FD6uput+wrXuMY10xG0b/U9PJghKoZawAatY65vejKvosAaf1ZjCMgAkolxTc7CYMMhHyGRl7WMYSVKjILcXJzGBbSGAD3kuZq9BlJPy8gSSrfrWk+JbjwmboJxw6Dz8zy3OwYH4FzY6Fvg0mjOhDfEgvI24Kfir+vyDJIvsTnlf6u5WpFD0Tly29uVgrVyODjDMQXQeWceCYiHBJN/xJtRGoZ4R8P4cXZgoeNqh7pWGgrIdwtTOo07C2T2xS5E2k+mSZjk019sEyDHy/oZr6MkbkaJr3LOoExQNBrUhXoPRS4p81wuMirlC5YFsDSGRb2jsEXqgua0YVSFnIvWMXkYqvH0YFqlr7nHgAXKx0cwaIaYSE6Vv8APfoqofxWmvR/1aGKd9Ld2oiU5mRCp7SjlyQyzViGlWzd6cVlnBMNZKbhfDW9YFuUP/rBgpP2mlG9QEsBTmvj3JSlxe8T/HXabNO5WMnMw5t6lmRC52BjFpjphpy8Gdv+dSwQD2L+jfeboTz2tRk1fAMqqq1YGtBWYo9mp70K0we4gmYqO8St/f9SCIzQu8G0SO0ErKkBWe5QZN3UKIJDW+IMy5aHePuVj/MZrKkZoYjn/qMRQePRqZ/Ad9I7EX4R7DiIA4BTejwijW6IkjpVYwhfEQ6pzFmCxqq71VdoHZT86W6rOLpcdnjzq+jUthV7bzUYch6O9Ho1WvErF0ZXdDWJEx+rjOm5pSOSNxcvOpfND2HWPaoRUqk19RuzR1XSRT3Mn7SXjUS7sugx8pZCMLbdTqAzrhqz9QEkyFktPLmDRhZ38py5LQ2mHus+T5NxXHbh0gRFnMtKVtQEv64278mJ19iA6gZhsxCDmtSHn8Sf5Tm9nr6mpe8/buFGXRK5IWF3TX26f8l5OOWS2tpcW+z2E7bxeagr
 i3yFjvCX
 MFWIk/T2eQjBKJezqiVjSmVcSJ7FegTIHfuG9VYZGLBpKwaXRaFPbOAHR+oQBcr6lKsJQ9khHhpFlFIzhIAo7KX5i/0wni6DIyBpBniwY/SMPuW2a3zmEJ5t6j2isZN0SnaA4NwNkSBpkPT6gkDM/43xZLGwGeUHTSFEi86iKN55X+4erIgSP6OVwxLva8Kq6aCTiNIP3kmhbAMMPTmHGWY2vRUdk+5JyGgto8VA3ol2U8GDWuygd0+Arf1/kr/k2CfOF3Cnj9+p0107d7763VyqXGTEizucWRrCWvn85aTjrquwm4VLlBXaq6XtCnAhQAYKHZVGUyUgyrdqC0AM/o44I1erg8DscxuXP6b6tDay8Xd2TmToZ7Bz+POQH3GLdKaN70jwYOjnowkF2i3o85rTFShSLM7D+/BjwOqGjic4sySU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 19:15:33 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This makes it possible to create memory tiers using fake numa nodes
> generated by numa emulation.
> 
> The "numa_emulation.adistance=" kernel cmdline option allows you to set
> the abstract distance for each NUMA node.
> 
> For example, you can create two fake nodes, each in a different memory
> tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
> Here, the abstract distances of node0 and node1 are set to 576 and 706,
> respectively.
> 
> Each memory tier covers an abstract distance chunk size of 128. Thus,
> nodes with abstract distances between 512 and 639 are classified into the
> same memory tier, and nodes with abstract distances between 640 and 767
> are classified into the next slower memory tier.
> 
> The abstract distance of fake nodes not specified in the parameter will
> be the default DRAM abstract distance of 576.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> v2:
> - fix the explanation about cmdline parameter in the commit log
A couple of comments on includes, with those resolved LGTM.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> 
>  mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> index 703c8fa05048..a4266da21344 100644
> --- a/mm/numa_emulation.c
> +++ b/mm/numa_emulation.c
> @@ -6,6 +6,9 @@
>  #include <linux/errno.h>
>  #include <linux/topology.h>
>  #include <linux/memblock.h>
> +#include <linux/memory-tiers.h>
> +#include <linux/module.h>
> +#include <linux/node.h>

I can't immediately spot why the new code needs node.h

Should also include
linux/notifier.h for the notifier_block definition.

>  #include <linux/numa_memblks.h>
>  #include <asm/numa.h>
>  #include <acpi/acpi_numa.h>
> @@ -344,6 +347,27 @@ static int __init setup_emu2phys_nid(int *dfl_phys_nid)
>  	return max_emu_nid;
>  }
>  
> +static int adistance[MAX_NUMNODES];
> +module_param_array(adistance, int, NULL, 0400);
> +MODULE_PARM_DESC(adistance, "Abstract distance values for each NUMA node");
> +
> +static int emu_calculate_adistance(struct notifier_block *self,
> +				unsigned long nid, void *data)
> +{
> +	if (adistance[nid]) {
> +		int *adist = data;
> +
> +		*adist = adistance[nid];
> +		return NOTIFY_STOP;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block emu_adist_nb = {
> +	.notifier_call = emu_calculate_adistance,
> +	.priority = INT_MIN,
> +};
> +
>  /**
>   * numa_emulation - Emulate NUMA nodes
>   * @numa_meminfo: NUMA configuration to massage
> @@ -532,6 +556,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  		}
>  	}
>  
> +	register_mt_adistance_algorithm(&emu_adist_nb);
> +
>  	/* free the copied physical distance table */
>  	memblock_free(phys_dist, phys_size);
>  	return;


