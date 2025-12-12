Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF91D43366
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A776B0005; Thu, 11 Dec 2025 21:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1466B0006; Thu, 11 Dec 2025 21:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07086B0007; Thu, 11 Dec 2025 21:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE2F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:22:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F062B6016A
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:22:01 +0000 (UTC)
X-FDA: 84209218842.13.30491EA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2753C1C0019
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:21:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b88CUObR;
	spf=pass (imf20.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765506119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHu0Q9F+DFYpNGC9w0HpSVv/OIzopBBaa+TlweO5lb8=;
	b=lU6G5M0RINNn7EKd8wkkM5aSoforoHXLYZHwhDGu8bOaWK80enfAeKSn08LXxgfXFEimp7
	DxvN7z1kIOjJjqKB77XgubrgaUW05MBMxPaG0Ast0eOh3S4dQ5kCRx+71xHhveiuFqVUhj
	ZLrFKkHpoDW0jq7W6mtVZwItRoeOKQs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b88CUObR;
	spf=pass (imf20.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765506119; a=rsa-sha256;
	cv=none;
	b=GOsd8ec8sl0WJPBtIgBKNxUhIeVgaMURsLWPuWK4rut+EQjYa0EMNki1pMOFo4+FnTwAXE
	KNMZpyF/t41nG89umR5XptJH1vipNEaKN6G0L/XlqB0MENo9DFmaSeHO/w2+I2fxYwCf2w
	EtnBzv8Ney/2PU5mO1cvvdrSLstTvZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765506119; x=1797042119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mTt8SDC8aH6PXy9ej/JNq1avguUMeGlT1TNm2631vCc=;
  b=b88CUObRTWuXI/CObuF8GkRLxzFTokrKgYCRympcgtxYMqmHi+rU/DNo
   7fH2XMD0oFsufXR2wYpEZKllW88Nc1tRGTxpcQSQPCAz6V5dEwfJAmV7H
   mQMiy8xaq7R09SJpfhgZ/Ohax9Om+SJ/YumqEyVL5/DaCBpx07pru1U/9
   BVmcIz2LGetqvclDo3o2a0cj5Uk11cF+9SMT3cwrskCl4mSOG+SBvrn64
   CMOgevFRXp/zsKwFWcHMqSbk3T3KKGjyMRA+QohDNs5KH+PYjOAABAfvN
   HFAAATGPBaujGJneprnMIzOjtlL/Ypz/jpQlcy2/6MQCNWuivynPaLuJr
   g==;
X-CSE-ConnectionGUID: Ta4ZfLioRDSaTY1TIrUHkg==
X-CSE-MsgGUID: d9wtAWaUQY+r8pFSPPoxPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11639"; a="85105357"
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="85105357"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:21:57 -0800
X-CSE-ConnectionGUID: /SHB2B8qRjKtPwD499eH0g==
X-CSE-MsgGUID: 5HgWqXezR6ex+SBURVIEGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="scan'208";a="202038476"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:21:53 -0800
Message-ID: <341bbfd9-e6bb-4d1e-b9c0-9077dc3eaba3@linux.intel.com>
Date: Fri, 12 Dec 2025 10:17:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, rdunlap@infradead.org
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-2-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251211125928.3258905-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: z4sn9h9yoffdp6dki4ruq894xp6htyrn
X-Rspam-User: 
X-Rspamd-Queue-Id: 2753C1C0019
X-HE-Tag: 1765506118-898095
X-HE-Meta: U2FsdGVkX19kl+rsY6xpadRd5KqA/2KKmCUHV6p4R5qJ0hQ44pCeZI8fjBg2Kl+488173ajYh3rzMsM8TCk0p1yCVpJ5stryIKckUs4t1j5tpGE0q21T1twBK4agXoU8uGBHkD+ZNhGsdbWohSXqvhBrVPtyDblp9ltlfpyQDp7STIQ2hV9o1Ah3A50+yWeTdOMhnhNYGdBNSjMXw0RFOLBILmDHtylnI9d//fyCp2s+rJAihoESHbP+w1pPT0c8Wbu4beg0OXl1UpVHWS36LCSH7CubLbo+j2w7uNktEwqQt3sSv0uRtxA6KAgstmkpiJXlCeIVsrVPGUfsIVTFSwKj3sL7zn/7CDgMYa0xP0SAQuBRqLabSg7wVA8Zy0oKKZHsm7W1WMBKPsksNpNTv3hpqxMDVgDNnUUShVYpGwpw+kZoQtJliWvLob4LL1Z8P66mmknIMvHfQjcBwNqL/wrQjF/Vm5nQb30TYpfsZhVb1sAc0W840T8OmINmkwdEhhqIAY/lPc/h0yyjPt4FIQkhdOFaUgNi1qfBIKYwp50ijQkxqHafT60btOvzfkFG4CTdaPUQ6HdKUZyNW6ZQddfaGoBU8vQBOXJmENAojyugMluaKmfKHz/gOiC3OCXt12YaJKm8B/0R7TlHmT4F7pv/lD4BWaREloQwfUbG4dmYa4rDLcJjiywq5CYFAeL+Zj1j4qETULlfKR+oy425LXdu0EPORzPPqxtQBZgF7/XY1mnSNHWkfsi7btctHs0heyOW9CU4vvBDGhxlGnrzYNIfH/wPtkUxsUg5+XjeJ/OCXJnCMSwH9N/izK7DCDv9vquutUGUSnXckTOKEjggt0cqDE+/e7IOYg+MEdYOoJXBaTEHP4SN7nUdblYP+d/NNr1YalZzfrdEb9sifpJB2B0GHID5Cm38QsJqvEyuvOcH6s96q29DMch/EKaNAgv1HlHeAEqctrSaGPkVcZ1
 lbB/dCoe
 N7LOghZxtPupEOQz/iXIVe+JLwpP+igwvPQ/knIejz4Xg1z6XOu/9R9E3JfgpFwWZlRGAesbXLyE7uOG7Zp7mbelP1RN+4dpBF8zV3o7+JaO7ozEIm82E4PxVdLnx/fCvMzJke/Ehdr0+kSJW0O5NCQDmZd8zPb2yAsL2f3iMNe2s7iuAbaBvKZ4a4tu/WqvS3Ex20d+cENz+BkxsTie4sD6YG8EumTkTcba3Th9VnF6Igmn0aqEAz6ENfKdtYSxKrf35n7e0MOlgPwuVdHWNDyA+IaXRcOLe1AFuW9mTPkESAMg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/11/25 20:59, Mostafa Saleh wrote:
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
>   .../admin-guide/kernel-parameters.txt         |  9 ++++++
>   drivers/iommu/Kconfig                         | 19 +++++++++++
>   drivers/iommu/Makefile                        |  1 +
>   drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>   include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>   mm/page_ext.c                                 |  4 +++
>   6 files changed, 82 insertions(+)
>   create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>   create mode 100644 include/linux/iommu-debug-pagealloc.h

Do you need to update the MAINTAINERS file, since a new file (iommu-
debug-pagealloc.h) is being added?

> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a8d0afde7f85..d484d9d8d0a4 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2675,6 +2675,15 @@ Kernel parameters
>   			1 - Bypass the IOMMU for DMA.
>   			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
>   
> +	iommu.debug_pagealloc=
> +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> +			parameter enables the feature at boot time. By default, it
> +			is disabled and the system behaves the same way as a kernel
> +			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> +			Format: { "0" | "1" }
> +			0 - Sanitizer disabled.
> +			1 - Sanitizer enabled, expect runtime overhead.

"iommu.debug_pagealloc=0" has the same meaning as "unset". Would
"iommu=debug_pagealloc" look more appropriate?

> +
>   	io7=		[HW] IO7 for Marvel-based Alpha systems
>   			See comment before marvel_specify_io7 in
>   			arch/alpha/kernel/core_marvel.c.

[ ... ]

Other changes look good to me.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

