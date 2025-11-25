Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0FCCFD368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48036B0022; Tue, 25 Nov 2025 02:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F8D6B0023; Tue, 25 Nov 2025 02:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61266B0024; Tue, 25 Nov 2025 02:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977226B0022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:23:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C9EDC07A0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:23:10 +0000 (UTC)
X-FDA: 84148288140.10.BEA23CA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 606B6C0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:23:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n9rCMuw4;
	spf=pass (imf10.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764055386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W/+KCV6X+e09gMMjlOVWq/1H4VsZgPrayf7rOuagqoM=;
	b=Dd92//esUeYKdz0PKAonSDszXAYx0r4IwSbtAI54HAP7SGLpY5uxkVRh2ZXVb2XtjUbI5q
	HPhbznqeBE3iN7ZtouDk5bThBd5Q3JiWMBwuOAQwx7PuuiKa3BRRiLHqYCQE1THVtPmmSq
	/dZOKBbsTzOWIoZcpKG+GK47FDtUJZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764055386; a=rsa-sha256;
	cv=none;
	b=y8zl8M1NewEFSI3AVaTcimZMCV26cHZpEOi7xcJQjitgCV6Y+wLC8zDLp8BDihuDvDEVGT
	f+cM2NaEe5PyQvzB91sY/ePq5W7Vvs6OXHX8BCqWvXLBamVNN7rSH339CkfWlNFDd+y9Xt
	RPkDvHGv2zL6gPcwzA1mCbDWTu7bHFQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n9rCMuw4;
	spf=pass (imf10.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764055387; x=1795591387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nkiQcmVMDAWDvgWH8TwLxZ5+OG/fvCcRuE7BgYF1oWk=;
  b=n9rCMuw45Xop7C4zUl7lviGM4VSiIENm2ITOUfbzxOJUlYy8L8diFEWQ
   +TAMPCj97gia8ztx1rp66VTEjdCFgK2pCgTP1epMTcumrdcJb3VXkKEzE
   cMMXfp/Mc7y6H8eHizML/HDF+x002l0zsiFwGewH+QpJZtWAJtyHmTqul
   IOl3AoD0Jejwz1dnXlikBoT3IMM3iuZyUdDcDz5YCucplnWA6nZCc0PEA
   KlXeMwwB/LcKU/UPYO3dN/2HgSWeml5wONEuwE0Ap95Qii33X6ttYFmkY
   kR1zYgrrdPVrfwbFNjQNo2ndYlDhCkN1fZI2cSVBbg1jxLv54WwwyU/SQ
   w==;
X-CSE-ConnectionGUID: 8wwqkhkgQPC17TYe2Rhrpg==
X-CSE-MsgGUID: SYUiHqf3SzqmFM+KhZtiRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69923073"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="69923073"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:23:05 -0800
X-CSE-ConnectionGUID: vWVS/dgcRaeC6PW3k1QUiA==
X-CSE-MsgGUID: DSDRsP0gQ9STzZ9EvJfV8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="215906221"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:23:00 -0800
Message-ID: <5f85e519-5a05-4359-9904-06f16737e28b@linux.intel.com>
Date: Tue, 25 Nov 2025 15:17:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-2-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251124200811.2942432-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 606B6C0005
X-Stat-Signature: jhq798errp4wpa6k4z3enf64kqnnkzfp
X-Rspam-User: 
X-HE-Tag: 1764055386-73064
X-HE-Meta: U2FsdGVkX1+w2emv1F+EWadpTHo4RHUt6tU1bG02jsbFcvrl8Y2pzyhu3Z84l6H5GsocGlU3T/mZe7mqLiLSfyMFoJC6h0nHEkEuPQZPEDuG+aeW2VGixNMKY12mP6ZvUhmG9UCPhvK5OvUIKM58059hqwf9JXLGnctf6vdQw1HVgq/7c11wZ7YYIh571QSW3JnnWbnivt6cbugW5NzEEiJV87mH4lK2UVxK7AJFNCBc7GSDsUAHaViUpyA96eQ+A1T8Xt+7LCp0Pgd+lxJCvngHYks5eYgmqnXVIpEQKQGyWu/VL4p5nSiFUKbBkJsnOdXHp7TrMTlUjCrbdDDt4ui+IbS1KecU3Mq5FSoSW0ZP5LZc0kVXIgzKJgLKz5utRr2mrlp7HH5p94JCIssmIB8WBW1kJLAufaEReb+7prZya2nBB4jn4MiXBbJetivkgsKgngj09Y6eSxpWZvm/E9HqYQrYNzGdjgDYROVjGfs3NPQkj+ilEiLFSSB9NiFIQzOmmmHUEWFbuIdtpoPSI5FIXuNhyKfNk4JGgnbaI6Fheei972G+BgDELpxp3vv8Ah99K5TxykrE7PEF8AgRvpBCNw2lSzTygB3qDAJBZfVtH8dlOuLVqf+xa1lMmshXWHJ5B+FEu5ZJd9ti+hPANohjuzv8aXaHpbpcEFHHPjM3oZJys4WI6lLDklbUmbj7O6hpsmY1KLrEqNojSAP1dj00/Z0ndH9fA+Pzk2062EcLnsuwZEhXxSNwwREVjTtpxtai2xDAMrwtdmtXSFaGRqC2VxgLD458rDFuhx6xrj4BpXtp8IWAtjyXutfgKgdTdVvDge/3tAdhi0K4UYtVxWKT7vvzBbT7d3yOp9BrA4dvdxZAX+Ui1GlrRlV5dmOCA/5gqWrrTaDSjTaT6k7cJGIvqBdNtatoSk6sR3FknqS1RR6z780UPq4VMwpHsDlpc9viDoDl5NqxpEGwKXa
 KVIxUshk
 813MoyMuvA0Hm0VnXQCuLGqkGqpih3FBb93TZpkhvN5Gx589m7KNV9CGKDiLjNnM4Jz/yUxVu5AJVD9O4YXvFxovexYvWpmnscs2mmwzja6xrLTo3wSFfWwc3kaf06hvgy7QVMQ9T1Ii5ata+qiLU5d0p9Iw/de5cQ4jE0skMuugJUNZjYUqwlUfAiZ7bj44tXJCugwaxvEg2kJe98426KUUBxMYe0ODEmQgIyf5fArpUXFOIyvmN/DajPWiw/gAHOgFuUjSZTZjAcffpum3e7oEp1DT0B9cRE+M5V8Hsf4qpG3FLXvWt+6vxIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 04:08, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> 
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> 
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |  6 ++++
>   drivers/iommu/Kconfig                         | 19 +++++++++++
>   drivers/iommu/Makefile                        |  1 +
>   drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>   include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>   mm/page_ext.c                                 |  4 +++
>   6 files changed, 79 insertions(+)
>   create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>   create mode 100644 include/linux/iommu-debug-pagealloc.h
> 

[..]

> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> new file mode 100644
> index 000000000000..83e64d70bf6c
> --- /dev/null
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2025 - Google Inc
> + * Author: Mostafa Saleh <smostafa@google.com>
> + * IOMMU API debug page alloc sanitizer
> + */
> +
> +#ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> +#define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> +
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +
> +extern struct page_ext_operations page_iommu_debug_ops;

How about moving above to below mm/page_ext.c and remove iommu-debug-
pagealloc.h header file? ...

> +
> +#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> +
> +#endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index d7396a8970e5..297e4cd8ce90 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -11,6 +11,7 @@
>   #include <linux/page_table_check.h>
>   #include <linux/rcupdate.h>
>   #include <linux/pgalloc_tag.h>
> +#include <linux/iommu-debug-pagealloc.h>

... remove this include line and put the "extern" line here,

extern struct page_ext_operations page_iommu_debug_ops;

>   
>   /*
>    * struct page extension
> @@ -89,6 +90,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
>   #ifdef CONFIG_PAGE_TABLE_CHECK
>   	&page_table_check_ops,
>   #endif
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +	&page_iommu_debug_ops,
> +#endif
>   };
>   
>   unsigned long page_ext_size;

Or, put it directly in linux/iommu.h?

diff --git a/include/linux/iommu-debug-pagealloc.h 
b/include/linux/iommu-debug-pagealloc.h
index 87f593305465..b2b82cf032e6 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -14,8 +14,6 @@ struct iommu_domain;

  DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);

-extern struct page_ext_operations page_iommu_debug_ops;
-
  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys,
                        size_t size);
  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 801b2bd9e8d4..40133031985a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1185,6 +1185,10 @@ void iommu_detach_device_pasid(struct 
iommu_domain *domain,
                                struct device *dev, ioasid_t pasid);
  ioasid_t iommu_alloc_global_pasid(struct device *dev);
  void iommu_free_global_pasid(ioasid_t pasid);
+
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+extern struct page_ext_operations page_iommu_debug_ops;
+#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
  #else /* CONFIG_IOMMU_API */

  struct iommu_ops {};
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 297e4cd8ce90..345af8c9fcce 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -11,7 +11,7 @@
  #include <linux/page_table_check.h>
  #include <linux/rcupdate.h>
  #include <linux/pgalloc_tag.h>
-#include <linux/iommu-debug-pagealloc.h>
+#include <linux/iommu.h>

  /*
   * struct page extension

Thanks,
baolu

