Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ED8CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 12:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A018E0005; Fri,  3 Oct 2025 08:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D78E0003; Fri,  3 Oct 2025 08:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E578E0005; Fri,  3 Oct 2025 08:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC87B8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 08:19:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D7F71A0511
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:19:35 +0000 (UTC)
X-FDA: 83956708710.22.AFAF9C2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id B68878000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:19:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759493973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fuj6blZqCq4xnpwT+XGEN8ooNlsHvGrqmKecsaVr26g=;
	b=ng5d3akloM8o4xyGuTG5rFUIKOPGxEox9PeP2fNXOOhK1+bzxJqdtvQbq1rMwbdLSa95i6
	p/vbYgTMQqXlwDb2XOv/ROcY8W1ZOLYvlYlgWZBBINOV+zl+fExBV0rePpbHFWSyPfBuZp
	tY4ngZydfvYpYopI+/9rlC97zC/o5uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759493973; a=rsa-sha256;
	cv=none;
	b=MVtacgwzLlPCqSvRkW7fxJljY0M/c8K5O5k5SAbrLck4S10v9FNPjOnS5rY+4ZdnERfxdl
	YvkoolNbAsSyBBDDxOSnBUMt/D3IVCWRpusj+099rDrW4t5lh6KsFDiOdr+ANHKPK8D6d/
	8qtt8X5rt10nAP5YWOkBoXr43FuR0tI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdSLp26Jcz6K8tQ;
	Fri,  3 Oct 2025 20:16:18 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A5E7140278;
	Fri,  3 Oct 2025 20:19:29 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 13:19:28 +0100
Date: Fri, 3 Oct 2025 13:19:26 +0100
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
Subject: Re: [RFC PATCH v2 4/8] x86: ibs: In-kernel IBS driver for memory
 access profiling
Message-ID: <20251003131926.0000363f@huawei.com>
In-Reply-To: <20250910144653.212066-5-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-5-bharata@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: ytu3pyywjmjq74tg4hgk58x8qfm53bsx
X-Rspam-User: 
X-Rspamd-Queue-Id: B68878000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1759493972-229275
X-HE-Meta: U2FsdGVkX19i6xfMy+N8EuCax0hhBCE9uloc9neY+qNO57I2DcNWGHx5I4GuwOIHjDUWWoJ/U/2CSOZevnKEB7E6Q6qjiug+Dm8f5WwThwg0VLZB4cfrwFerA8J6Za1HGTbDSJJ0BD30npRVuC6G2LZJTO7pui+/UiE/4dg+7JC2HToEdYDgSwxO/ihxJCSFeckQHocVrK98ZtdrsF8PG7A1F8nayr7J7RagDoBeoPKwn96SS600xFjIJ7glcWZBgESo+KGJNX31AskoF7WA/D7fq3SSyw3CLtkpWm8rle6/Drgh1bphQsP5grXKCA+adOaxezGI8PG+FS4ZH9lJVF3MzbcyvGxURXLKNLwYhTcVNTMNaGcSObt1fllVgQVTU5xaptuPQxSZKH/ZlqReCzfu1AJ8SVZxrxxYVKS0mtNAsdI8cwwuLyaHQpO9qdpBTnFikziOt6dy2+o3PJFwneOZmao4Sg1IjxLt8aZJy8Me0JPc/j8SllCxZ6lKB7d5iR+D1tlsC2WcJ2X3/yZPwUUg0rKTFuFiDimlb+ovu6ahYOiIdAVX6sDxXfFJvcQ0CL3y0GhEJcwjrFSwvPQgFqWh6pi4Bq0Rb4ZormtK0WN9XQUDsFhXTKzd+bc7n1Jg9TIGus4RM3zCGne++CKmqolNOPEYAninmpzGqscVs/1OgcoHy/xp4473s2u8gZAl64uN5hUN3lmCfVHin/vqo2Q+gXj1LYIkSBuMCpd2P72VGUmtNyTyCSu7LabJic4ybjV9Z7ykhmVHvMKLJBBwqKJI56XpHERcN7XUCvcsD5SBHUfFroED2eGl2zJW7OlkWYK9v1hpkKGR/M4/kdVeV+WrBOrJKQTCURqV8aR8qG1YyGP4DvADr8v/2a9HN6NvXvJbbR57uTumQadhTfMLcaQ2Aifw+LPc+Xed72wg/5YCwLbv34qG1n5uisRTZFBKuABd793Yy3SjGfPEM6y
 6mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 20:16:49 +0530
Bharata B Rao <bharata@amd.com> wrote:

> Use IBS (Instruction Based Sampling) feature present
> in AMD processors for memory access tracking. The access
> information obtained from IBS via NMI is fed to kpromoted
> daemon for futher action.
> 
> In addition to many other information related to the memory
> access, IBS provides physical (and virtual) address of the access
> and indicates if the access came from slower tier. Only memory
> accesses originating from slower tiers are further acted upon
> by this driver.
> 
> The samples are initially accumulated in percpu buffers which
> are flushed to pghot hot page tracking mechanism using irq_work.
> 
> TODO: Many counters are added to vmstat just as debugging aid
> for now.
> 
> About IBS
> ---------
> IBS can be programmed to provide data about instruction
> execution periodically. This is done by programming a desired
> sample count (number of ops) in a control register. When the
> programmed number of ops are dispatched, a micro-op gets tagged,
> various information about the tagged micro-op's execution is
> populated in IBS execution MSRs and an interrupt is raised.
> While IBS provides a lot of data for each sample, for the
> purpose of  memory access profiling, we are interested in
> linear and physical address of the memory access that reached
> DRAM. Recent AMD processors provide further filtering where
> it is possible to limit the sampling to those ops that had
> an L3 miss which greately reduces the non-useful samples.
> 
> While IBS provides capability to sample instruction fetch
> and execution, only IBS execution sampling is used here
> to collect data about memory accesses that occur during
> the instruction execution.
> 
> More information about IBS is available in Sec 13.3 of
> AMD64 Architecture Programmer's Manual, Volume 2:System
> Programming which is present at:
> https://bugzilla.kernel.org/attachment.cgi?id=288923
> 
> Information about MSRs used for programming IBS can be
> found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
> Model 11h B1 which is currently present at:
> https://www.amd.com/system/files/TechDocs/55901_0.25.zip
> 
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>  arch/x86/events/amd/ibs.c        |  11 ++
>  arch/x86/include/asm/ibs.h       |   7 +
>  arch/x86/include/asm/msr-index.h |  16 ++
>  arch/x86/mm/Makefile             |   3 +-
>  arch/x86/mm/ibs.c                | 311 +++++++++++++++++++++++++++++++
>  include/linux/vm_event_item.h    |  17 ++
>  mm/vmstat.c                      |  17 ++
>  7 files changed, 381 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/include/asm/ibs.h
>  create mode 100644 arch/x86/mm/ibs.c
> 
> diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
> index 112f43b23ebf..1498dc9caeb2 100644
> --- a/arch/x86/events/amd/ibs.c
> +++ b/arch/x86/events/amd/ibs.c
> @@ -13,9 +13,11 @@
>  #include <linux/ptrace.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/sched/clock.h>
> +#include <linux/pghot.h>
>  
>  #include <asm/apic.h>
>  #include <asm/msr.h>
> +#include <asm/ibs.h>
>  
>  #include "../perf_event.h"
>  
> @@ -1756,6 +1758,15 @@ static __init int amd_ibs_init(void)
>  {
>  	u32 caps;
>  
> +	/*
> +	 * TODO: Find a clean way to disable perf IBS so that IBS
> +	 * can be used for memory access profiling.

Agreed on this being a key thing.  This applies to quite a few
other sources of data so finding a generally acceptable solution to this
would be great.  Davidlohr mentioned on the CXL sync that he has
something tackling this for the CHMU driver around this.


> +	 */
> +	if (arch_hw_access_profiling) {
> +		pr_info("IBS isn't available for perf use\n");
> +		return 0;
> +	}
> +
>  	caps = __get_ibs_caps();
>  	if (!caps)
>  		return -ENODEV;	/* ibs not supported by the cpu */

> diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
> new file mode 100644
> index 000000000000..6669710dd35b
> --- /dev/null
> +++ b/arch/x86/mm/ibs.c
> @@ -0,0 +1,311 @@

...

> +
> +static int ibs_pop_sample(struct ibs_sample *s)
> +{
> +	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
> +
> +	int next = ibs_pcpu->tail + 1;
> +
> +	if (ibs_pcpu->head == ibs_pcpu->tail)
> +		return 0;
> +
> +	if (next >= IBS_NR_SAMPLES)

== seems more appropriate to me.  If it's > then something went wrong
and we lost data.

> +		next = 0;
> +
> +	*s = ibs_pcpu->samples[ibs_pcpu->tail];
> +	ibs_pcpu->tail = next;
> +	return 1;
> +}


> +static void setup_APIC_ibs(void)
> +{
> +	int offset;
> +
> +	offset = get_ibs_lvt_offset();
> +	if (offset < 0)
> +		goto failed;
> +
> +	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
> +		return;
> +failed:
> +	pr_warn("IBS APIC setup failed on cpu #%d\n",
> +		smp_processor_id());

Unless this is going to get more complex, move that up to the if () block
above and return directly there.

> +}

> +static int __init ibs_access_profiling_init(void)
> +{
> +	if (!boot_cpu_has(X86_FEATURE_IBS)) {
> +		pr_info("IBS capability is unavailable for access profiling\n");
> +		return 0;
> +	}
> +
> +	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);

sizeof(*ibs_s).
Same as in other cases. It's nice to avoid having to check types when reviewing code.

> +	if (!ibs_s)
> +		return 0;
> +
> +	INIT_WORK(&ibs_work, ibs_work_handler);
> +	init_irq_work(&ibs_irq_work, ibs_irq_handler);
> +
> +	/* Uses IBS Op sampling */
> +	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
> +	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
> +	if (ibs_caps & IBS_CAPS_ZEN4)
> +		ibs_config |= IBS_OP_L3MISSONLY;
ibs_config seems to only be used locally so the global seems unnecessary.
You'll need to pass it in to the one user in the next patch though.


> +
> +	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
> +
> +	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
> +			  "x86/amd/ibs_access_profile:starting",
> +			  x86_amd_ibs_access_profile_startup,
> +			  x86_amd_ibs_access_profile_teardown);
> +
> +	pr_info("IBS setup for memory access profiling\n");
> +	return 0;
> +}
> +
> +arch_initcall(ibs_access_profiling_init);



