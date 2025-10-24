Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50424CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F93E8E0070; Fri, 24 Oct 2025 05:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9018E0042; Fri, 24 Oct 2025 05:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7980C8E0070; Fri, 24 Oct 2025 05:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65A658E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:45:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 041CABE4AD
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:45:55 +0000 (UTC)
X-FDA: 84032526312.17.51A0298
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A24B2000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:45:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aRz+AIt8;
	spf=pass (imf03.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761299153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8i7IvoUyLwZipphMmlbv7Bm0R6d4DUro9PNdCGClahw=;
	b=5FCoATEMoLRS0ot29VGvOLTDKLzUSFK8BeiUXXYuwjLaXxyAJ/IX7o9lHN7cNnu24dTclQ
	LD7Qwcw1J9ph5Pig0ZG35NZdpoLVyISsSFKkHN83/gM5HAhfMlABKxsiItYkzWmmwuPl2+
	peSzv0wZf5XfpWIzYpPS4O7rPg6SHQE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aRz+AIt8;
	spf=pass (imf03.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761299153; a=rsa-sha256;
	cv=none;
	b=cO6/9WxAx4l6oGLF4wuA8a1YhLRQkvwYuSQoFO+TmIv2HXEAmQbs82t4VMJBavF31kTCuL
	x0eCrPHPvTHrcKXGribBzeJN5bMbzx+6OcvQWyPMhcWpeadKWzCcSNMLIOjyeg5VYVgEz0
	dqNn1NmbvKGo15ejyU0kOGKx02f3zoo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761299149; h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type;
	bh=8i7IvoUyLwZipphMmlbv7Bm0R6d4DUro9PNdCGClahw=;
	b=aRz+AIt8JQnu0tLicYAm5LxSzSjux4OSWF+UAi5NZw1dem0rtNU6ik0Fuz9bu71+q6/cQrEH/E6lqnrtjvGBaMPVQQq4y25j9t43KwzHj35xqlwO9d9ZDR9f2/Ntx1RJEc33SF04i+7orFaufA2iE5Msqhc0FBucydVNwuTLdbs=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqu0ajN_1761299145 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 17:45:47 +0800
Message-ID: <d2550489-834c-4dcd-b41f-d22590880343@linux.alibaba.com>
Date: Fri, 24 Oct 2025 17:45:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: Re: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
To: ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com,
 mochs@nvidia.com, skolothumtho@nvidia.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, tony.luck@intel.com,
 bp@alien8.de, rafael@kernel.org, guohanjun@huawei.com, mchehab@kernel.org,
 lenb@kernel.org, kevin.tian@intel.com, alex@shazbot.org
Cc: cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, Jonathan.Cameron@huawei.com,
 ira.weiny@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 u.kleine-koenig@baylibre.com, peterz@infradead.org,
 linux-acpi@vger.kernel.org, kvm@vger.kernel.org
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-2-ankita@nvidia.com>
In-Reply-To: <20251021102327.199099-2-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A24B2000C
X-Stat-Signature: izdu7cj8rto41gfi8hrfyhr6kuh1wrb4
X-Rspam-User: 
X-HE-Tag: 1761299151-897442
X-HE-Meta: U2FsdGVkX1/SwgklOm5lcTre88gyzyltwustFPkDOBx2EvW/MQGoNum0S0oMdT6yEqbDCFzkx7H7OzLCv5Wt5d6ogNpfcZ/MI5IFyChzDl3vrxP7gd70Qeht0UGO4kvFlC2hKsqaZRCFMwAmUQ4T+7dAdIlxvKS7NdFPPtFIM7hChm2TVKxklPYzsXNLNcdNOJByofdp001jJUOmhnwt4m/1syLjOONptAnq72mgZbm0b6oYeoPTDMng6a1NTpDocyonZsGdXTLZQ6wO7KBVnVNEBjOvkxlMTpBuOH38F3BqKa2w0EzKpOu5qt8feKYUqGedQ5kOWHf6LQI7FC8AuIl0o7Wxfbq6GUaGStPj2wDX/NuaSwkXuefZ0J6Cdu1XG32ThlWH6Y0wMHeWp4hG742Hf4p9nlp31/mjGy/KH15fZTFTbb5KUR5mpVj1+OIvBNo0d3wO8E8O9yeMTSnQ82tbdwp8jWMxsriNcln/hd1Ei7F1rF8J00mBI8oB71VIjGXUBm5Bv0DjQatnAeYRNp5e1yR4Kz7wISzx+Hg8Nhyzmu1tHrE+hEnV6dnBpNbtOPmz2DqCYR4aza6Fh7bnub9eJoJ7FP7Wb7+lcwONWwTuYZ+qozAWMOJLKPpiqk4mb3rlXJhOFKppZU5O0C8FOcg3ruqXgGpABtjz/qQT2+F7A29ldLtEFCIXqVjLPphhmzyaIG69xhJFX4vILsMlLpRs7KJ2vaWoN8VBSJliHtPSlhTnYvDTk9WiPkJa7lA4DQotZnoAL+AhhgZOnjKXiq6HOCBFgWTSxZzbY70X4MTQBPZoLMPcFUPlKAv1HPtX/+4ZbPxdsr8qG6jDtit5cb54G0vQlZptfKMujLDC6DnQuJ2z4Zg+nQ7x2dzfqNNR4SiCojnAoQ6qVhhv7AJBi0sSafjLaGhthg3Uwsp5u21AyksHS0TadO20YICsWwe1r6t71KR+KgWvzL9CjsH
 jIKh4ubi
 uyKns76ScUPVgcL4q62zR3jcYD3IOt9Tp+rtHFGDZJNxCWum39W3O6wm2Me31Df3MxakV3McRnhaobxhu3dI8fFLbNT5smYBvIlGdkIEUcV6jnLJDmJ67eh0fd2qcfZfa0IGrc52KFBCwtbuVS2x2evvaZeaCRMgGE9DMirI3daR6Jjk8sQ/+vhrf386ob+y/Wq4RG2e8I5hJuUteNnYGjzVOwJwl4PcKyEOPBmaK91ju5WiFEyvWcyR47rGinRvL4uQdCqieGbBQysB782flg4ctWZX2GgTRMeH5H6m35h/jv//zG4qCHyxEZvdOwlS4RoGC2wSyYqjnmDQ4mgIcZou91B68qOCkfQHf1CYq0DJcY9Nk8I0MXn3FXxR8UqNo8gbhvitauy2SVp2BAM/L1yqYY/5ZwqQJZopgM4STyQ6W4+fOPRZzfZlcxtqB2L7n39/oeRk0GrElhVuoEF9jQ3j94MPc/IYrgmDVropVm2gsV6LagS8qRCXPIVrqOuoJH3mNu5XRM/iSAfs327hhQJZx+3ZtO39/cLjXdz/nU1J/mwL9EnWA8zLHUlw/+YtNOa0aVM6ekxDkJ8SVENAIaI0snel2R9/1LyHeEeD4scIA9NStdJY+V4IX6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/21 18:23, ankita@nvidia.com 写道:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The kernel MM currently does not handle ECC errors / poison on a memory
> region that is not backed by struct pages. If a memory region mapped
> using remap_pfn_range() for example, but not added to the kernel, MM
> will not have associated struct pages. Add a new mechanism to handle
> memory failure on such memory.
> 
> Make kernel MM expose a function to allow modules managing the device
> memory to register the device memory SPA and the address space associated
> it. MM maintains this information as an interval tree. On poison, MM can
> search for the range that the poisoned PFN belong and use the address_space
> to determine the mapping VMA.
> 
> In this implementation, kernel MM follows the following sequence that is
> largely similar to the memory_failure() handler for struct page backed
> memory:
> 1. memory_failure() is triggered on reception of a poison error. An
> absence of struct page is detected and consequently memory_failure_pfn()
> is executed. 

This step depends on PATCH 2. I suggest reordering the patches so that
PATCH 2 comes first, which would make the series easier to review and
understand.

> 2. memory_failure_pfn() collects the processes mapped to the PFN.
> 3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
> poisoned PFN using kill_procs().
> 
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
> to a PFN would need breaking the PMD mapping into PTEs to unmap only
> the poisoned PFN. This will have a major performance impact.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   MAINTAINERS                    |   1 +
>   include/linux/memory-failure.h |  17 +++++
>   include/linux/mm.h             |   1 +
>   include/ras/ras_event.h        |   1 +
>   mm/Kconfig                     |   1 +
>   mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
>   6 files changed, 148 insertions(+), 1 deletion(-)
>   create mode 100644 include/linux/memory-failure.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 520fb4e379a3..463d062d0386 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11359,6 +11359,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
>   R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
>   L:	linux-mm@kvack.org
>   S:	Maintained
> +F:	include/linux/memory-failure.h
>   F:	mm/hwpoison-inject.c
>   F:	mm/memory-failure.c
>   
> diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
> new file mode 100644
> index 000000000000..bc326503d2d2
> --- /dev/null
> +++ b/include/linux/memory-failure.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MEMORY_FAILURE_H
> +#define _LINUX_MEMORY_FAILURE_H
> +
> +#include <linux/interval_tree.h>
> +
> +struct pfn_address_space;
> +
> +struct pfn_address_space {
> +	struct interval_tree_node node;
> +	struct address_space *mapping;
> +};
> +
> +int register_pfn_address_space(struct pfn_address_space *pfn_space);
> +void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
> +
> +#endif /* _LINUX_MEMORY_FAILURE_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..0ab4ea82ce9e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4006,6 +4006,7 @@ enum mf_action_page_type {
>   	MF_MSG_DAX,
>   	MF_MSG_UNSPLIT_THP,
>   	MF_MSG_ALREADY_POISONED,
> +	MF_MSG_PFN_MAP,
>   	MF_MSG_UNKNOWN,
>   };
>   
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index c8cd0f00c845..fecfeb7c8be7 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -375,6 +375,7 @@ TRACE_EVENT(aer_event,
>   	EM ( MF_MSG_DAX, "dax page" )					\
>   	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
>   	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
> +	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
>   	EMe ( MF_MSG_UNKNOWN, "unknown page" )
>   
>   /*
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e443fe8cd6cf..0b07219390b9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -777,6 +777,7 @@ config MEMORY_FAILURE
>   	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>   	bool "Enable recovery from hardware memory errors"
>   	select MEMORY_ISOLATION
> +	select INTERVAL_TREE
>   	select RAS
>   	help
>   	  Enables code to recover from some memory failures on systems
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..acfe5a9bde1d 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -38,6 +38,7 @@
>   
>   #include <linux/kernel.h>
>   #include <linux/mm.h>
> +#include <linux/memory-failure.h>
>   #include <linux/page-flags.h>
>   #include <linux/sched/signal.h>
>   #include <linux/sched/task.h>
> @@ -154,6 +155,10 @@ static const struct ctl_table memory_failure_table[] = {
>   	}
>   };
>   
> +static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
> +
> +static DEFINE_MUTEX(pfn_space_lock);
> +
>   /*
>    * Return values:
>    *   1:   the page is dissolved (if needed) and taken off from buddy,
> @@ -957,6 +962,7 @@ static const char * const action_page_types[] = {
>   	[MF_MSG_DAX]			= "dax page",
>   	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
>   	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
> +	[MF_MSG_PFN_MAP]                = "non struct page pfn",
>   	[MF_MSG_UNKNOWN]		= "unknown page",
>   };
>   
> @@ -1349,7 +1355,7 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>   {
>   	trace_memory_failure_event(pfn, type, result);
>   
> -	if (type != MF_MSG_ALREADY_POISONED) {
> +	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
>   		num_poisoned_pages_inc(pfn);
>   		update_per_node_mf_stats(pfn, result);
>   	}
> @@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>   	kill_procs(&tokill, true, pfn, flags);
>   }
>   
> +int register_pfn_address_space(struct pfn_address_space *pfn_space)

I have a design consideration here. Non-struct page PFNs typically
represent device memory managed by device drivers through their own
memory allocators. These drivers are responsible for allocation and
deallocation of this memory.

Rather than having MM maintain metadata about these PFNs, have you
considered adding an operation callback similar to
dev_pagemap_ops->memory_failure? This would allow device memory
allocators to:

- Maintain their own metadata tracking poison status (similar to
   TestSetPageHWPoison())
- Handle device-specific requirements for memory failure
- Provide more flexibility for different types of device memory

Thanks.
Shuai

