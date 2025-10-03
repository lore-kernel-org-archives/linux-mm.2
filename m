Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8F2CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 12:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AC28E0007; Fri,  3 Oct 2025 08:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61EC8E0003; Fri,  3 Oct 2025 08:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F938E0007; Fri,  3 Oct 2025 08:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A718B8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:22:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4846F1A074E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:22:44 +0000 (UTC)
X-FDA: 83956716648.05.8066C22
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5F008A0009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:22:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759494162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OeDVDlwSeC1BlDNuZhiAP1Uyu1ZwbSRhEUGWJoBsNQI=;
	b=cHQI0PChUCuG9Rrwme+TBGE4JAHwZGJNrxkrX66KTDc6MYaZLW6pdsVCxPp106GI7IpiwP
	ksA48jeup1wpcZpP8rekKOvcV8CsHse3kyBeOZrz9CB9PP2IEKbRNVIuNRY/E2lraNWugE
	2w9BB4RhidVk2sjdZuju1UkSkOuJ4o4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759494162; a=rsa-sha256;
	cv=none;
	b=Hnb9zA7UP5BPUd2pLJcH2scTqTGK2xD9VPNXpVRK+eoayLI2IpgW2MP6ot1nbGv79hZKzU
	eA84yiOVm0Kw84KUmaO8ShMEvVnE67HbLddER7Xh+p3fy9g72JPBgZmjG39UhY1gunTXFj
	8MtHlQ4MHnUlQsYGQBjbuNybKC8/Bi8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdSQS4xR6z6K8Xc;
	Fri,  3 Oct 2025 20:19:28 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 07A4E140372;
	Fri,  3 Oct 2025 20:22:40 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 13:22:38 +0100
Date: Fri, 3 Oct 2025 13:22:36 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Bharata B Rao <bharata@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 5/8] x86: ibs: Enable IBS profiling for memory
 accesses
Message-ID: <20251003132236.00002ecd@huawei.com>
In-Reply-To: <20250910144653.212066-6-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-6-bharata@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: 5F008A0009
X-Stat-Signature: 6dsbgamfd3w3oe3snaaufm8a1n5trscs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759494162-431401
X-HE-Meta: U2FsdGVkX18bq7PHjpI0A2i0tgthixDBK1VlRKVjZC3EC/QYBo7Iw3Ma0jCTO7I/hQXJyLo0Dcx4lMo0W9GYUjBSVwt6A8yjEKZlAKkNV+sxC7r2PmztSapQ/w+G+DkFWszz7xFizEtsog1Bc34KNujsYy0u1+gRNUCEsNgnengzS8ACFr6ARppWIxc5pI3+6k5EO0BXhOofjFIBAq0ZCe3kG8VKwIYLRLg6CvTYJrT0gmrNMrUMakz9dVERx233xkggMG2CDrt6R+WeS03XLGZMb6bdfqZ7HgnzeDyQqiyHbwY9Ik+64R69hAXglsvOm63lFmtiuIP/T4+6+2ogQu/5UVmNa1kGbJXO0XUuc+q9FvnPPyjnGrc2fIEMFbO15r189pBou9iEw5OcXButTn9DG2NdMUanAwHlScgahwm0iJ+DePw3Pz+xKkgRkcJuH40wlou1Kb+gsBENTMdrC4znReBtyucbHe2I4TB7o/XQGeAlhqFBk0WJr41O9l8CLz2s7a47Uvjyv1FFglZ9IJNzoRODA3D+9681zBLF64pSnghr5I4HIOQ2fVnOsDBclNxP1fiDEm8Kr1TYwynYwRjjxONvVxgHPTuLtALqwcp7TR9YXWTOCqGwWEQLYHJblNyQi3O/PxbSjb7ZhTqPjXMkxs0lTyzCRLXRwVtDTfVblLAKx555DYptS4xXwm1QrNE6F2gBNuZuR6+krpq9FSkrXaD1OIayL5bZZhrcXNy8LTIZYjSkPoYT8UcqYxMqpWUOch2H+NRad7TAAnUEPDJPi/vqzRNko/yFsYPHj73awh2mqfOxdsmOmCToHSlPKPmyQf7RxCv51FS/otpDXAeQ6s/KrDWLGYbMcSZzWwRvwWYPkhKlphbTtOEc6GyKVZ8Lcn1vhz3f9Ri8sDRawSgfBGpnHv7JRblOKXhjqQuQb7b7OaSN2txCyDTDtwbxgFHb/F8CPEMOtLxj0fa
 ThVgJIJo
 LcXM/efn4lJKMYxGdvi4vimhIsnd1k22dW7pnv+KGzBX+K7eQhtKq5TaRPFqBhA9kc7yybtyAR2OgyRN/Tcm5zOTrLgQfOwCvR+XPEPQGWKWaFvS8XWvSen1RVr+iKKvpTpmgRDsqbF1Ebh+/zz3K/wJRx63STUHsdMZrEMNzVVYVBMYNlfOuf2qde/VsB1R5bbeCJxkNd001XGVQoCDLgbvXCq7Zu6eEXmka9Ql/89EsRMm+iWeba3uRwMOmGwfVpXsL5hbWxlENoDV9i/QRHxkmKUOnG7RL9iW1n8QVVd2mQgau1DNjTKuqplmJx13rWQEq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 20:16:50 +0530
Bharata B Rao <bharata@amd.com> wrote:

> Enable IBS memory access data collection for user memory
> accesses by programming the required MSRs. The profiling
> is turned ON only for user mode execution and turned OFF
> for kernel mode execution. Profiling is explicitly disabled
> for NMI handler too.
> 
> TODOs:
> 
> - IBS sampling rate is kept fixed for now.
> - Arch/vendor separation/isolation of the code needs relook.
> 
> Signed-off-by: Bharata B Rao <bharata@amd.com>
One "oops I misread it" wrt to review of previous patch.
+ a really trivial thing.

J
> ---
>  arch/x86/include/asm/entry-common.h |  3 +++
>  arch/x86/include/asm/hardirq.h      |  2 ++
>  arch/x86/include/asm/ibs.h          |  2 ++
>  arch/x86/mm/ibs.c                   | 32 +++++++++++++++++++++++++++++
>  4 files changed, 39 insertions(+)

> diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
> index 6669710dd35b..3128e8fa5f39 100644
> --- a/arch/x86/mm/ibs.c
> +++ b/arch/x86/mm/ibs.c
> @@ -16,6 +16,7 @@ static u64 ibs_config __read_mostly;
>  static u32 ibs_caps;
>  
>  #define IBS_NR_SAMPLES	150
> +#define IBS_SAMPLE_PERIOD      10000
>  
>  /*
>   * Basic access info captured for each memory access.
> @@ -98,6 +99,36 @@ static void ibs_irq_handler(struct irq_work *i)
>  	schedule_work_on(smp_processor_id(), &ibs_work);
>  }
>  
> +void hw_access_profiling_stop(void)
> +{
> +	u64 ops_ctl;
> +
> +	if (!arch_hw_access_profiling)
> +		return;
> +
> +	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
> +	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_ENABLE);
> +}
> +
> +void hw_access_profiling_start(void)
> +{
> +	u64 config = 0;
> +	unsigned int period = IBS_SAMPLE_PERIOD;
> +
> +	if (!arch_hw_access_profiling)
> +		return;
> +
> +	/* Disable IBS for kernel thread */
> +	if (!current->mm)
> +		goto out;
> +
> +	config = (period >> 4)  & IBS_OP_MAX_CNT;

Bonus space though before & that can go.

> +	config |= (period & IBS_OP_MAX_CNT_EXT_MASK);
> +	config |= ibs_config;

Ah. Ignore comment in previous patch on this not being global. Clearly it needs
to be. Oops I misread this earlier.

> +out:
> +	wrmsrl(MSR_AMD64_IBSOPCTL, config);
> +}
> +
>  /*
>   * IBS NMI handler: Process the memory access info reported by IBS.
>   *
> @@ -304,6 +335,7 @@ static int __init ibs_access_profiling_init(void)
>  			  x86_amd_ibs_access_profile_startup,
>  			  x86_amd_ibs_access_profile_teardown);
>  
> +	arch_hw_access_profiling = true;
>  	pr_info("IBS setup for memory access profiling\n");
>  	return 0;
>  }


