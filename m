Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97ACACCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D188E0012; Fri, 17 Oct 2025 13:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D638E0006; Fri, 17 Oct 2025 13:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17DF8E0012; Fri, 17 Oct 2025 13:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE32B8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:31:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F6741193B3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:31:59 +0000 (UTC)
X-FDA: 84008299158.06.EAF4443
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8FAB314000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:31:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="U/vR04eB";
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760722317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYT04EhOdGyvBjdzNlqAGwYogk/hxO6ZthazV6K/rtM=;
	b=4VEzAI5X+lNxt/7GDbAWQp3A1Mv6x9+5elcw8U9XtaK4DVH8KojrFs/m1Q2ZFnbiAW2FyN
	o9BBkikJAwQ8JvuwMP1rZPbxCgwmAyKc/jOm7xlNv1WWM3x2+OX+YCHRHswdrTrEgonOKd
	HWQbVdQ4Ub3nrFrdeEf5bHC2V3sVz5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760722317; a=rsa-sha256;
	cv=none;
	b=7upMCvk7+e3V11z0qSYS7wfcL7MtIz2vPuqhAY3hAEQVFQxHVeJj4Zn4olW6WEDB4fDrf7
	gvyUNVzXav7XihKtTe4VWD7FI4X4wNuLsJlWJt4A8MhcHoOaH4ZVmrdrZsIv4I/ifzDl1k
	HBt20bF8GuS2L4k8S5K9Ok1EAcHKI+4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="U/vR04eB";
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760722318; x=1792258318;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=hYT04EhOdGyvBjdzNlqAGwYogk/hxO6ZthazV6K/rtM=;
  b=U/vR04eBagSetxX5Y0y41wxkB9xbfPOPfIbZKxdzGFEv3A7hNYlyfPMJ
   rZqutz9W2bUHB5/VkNc+lOEcJ71sRQRNEd2GPsItyoZkZpD4wlzs/ZedA
   qOQWL2RtkuZlkt3+k2g1pvqz/HxBLuOVxaIuCrH8MMPURCDM/fSQf+Zuy
   UKaPxLZqKlgJBj77xwRDfod5FsdFS5pCqBF5cZlEz4BtqPmkH4csAOOI/
   Fe7MFK1ffUIm+Gxy611PdCr+er4DEhk4jPuZUl3ArvBkvfJkGe8jVyydv
   ugubMLmqYbnzNhdR2owz10RutNewOF4Hr/4EKoMcfpNfzGiVmkrLm7DmL
   g==;
X-CSE-ConnectionGUID: PjO75/ywTxWnPMrQW+l7aw==
X-CSE-MsgGUID: n7VnUDkvTGefJX491RQlFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66769921"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66769921"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:31:56 -0700
X-CSE-ConnectionGUID: fUTxqA3TRL6Q1+t0WKC0PA==
X-CSE-MsgGUID: Rs4KedRlRb2EN6ovv+QvxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,237,1754982000"; 
   d="scan'208";a="183567925"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.108.40]) ([10.125.108.40])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 10:31:55 -0700
Message-ID: <c4f7c23f-48b3-49c1-8a40-fa388a1baa68@intel.com>
Date: Fri, 17 Oct 2025 10:31:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
From: Dave Hansen <dave.hansen@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Baolu Lu <baolu.lu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Jiang, Dave" <dave.jiang@intel.com>,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
 <20251014174339.c7b7d2cfb9f60d225e4fe5ec@linux-foundation.org>
 <6b187b20-6017-4f85-93ac-529d5df33aa2@linux.intel.com>
 <ecee3200-c8e2-47ec-a219-c88e8e905b32@intel.com>
 <11cad2be-9402-4d45-8d2b-c92d8962edfc@linux.intel.com>
 <20251017140101.GM3901471@nvidia.com>
 <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c3eee56a-7fe3-454c-878f-cff37467fb7e@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: t8ii9wy6o6oda9q97jo8t3gh7tuw9gqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FAB314000D
X-HE-Tag: 1760722317-670081
X-HE-Meta: U2FsdGVkX18uYfLaTrpKRFlEBqptII8PCjHMGeKukaKZVrJJ7JkvxYuo0zGDtEwxHvNKSZHnlrWXXvu6H/9TfL6+krJCv9Ff0tqEKsGxcIMcI8A3Gufs3xnUd1Zqbey5UZQqmbYQhlZyueEiPG/+cf6VxNZReGOw4mHRO8ZtwUggNEKt5PCqN+RMaXjzqrDPRyGWOi3y4Krfw9+KTVu3FGdIEQGBntOQWrE/wn4K/sSPWEQDVOz4/+HoneDgJ8InsktGB2pWi3oYJclO/rqnaMP0o8/H4JfjcFnRWlaS7JWysyzLW2pZV1dkz8RJ4FjmrUNQpLe7rN7bjqCSXeD2CLwBBRjX3GqYL/1VQdgAblDg+eh/UXGhLl/voTz575vSRTH9fwBoSyvpnIY8BHmt1nvK22MOU214S8G536QTn7QzIzYK4T9auL5y8BLVZP5HOqODegv69aONwb7YhpwVAsdachbp5J/7bCJrELFKihguDHu7nZgyTQQg3aMbBgglci3+B4nuir2FjBAF+z9/t/v82F0WtmFQ0jc91mi+FoZodxTO6KsPS7Ba5nnAqApcw4Hnt+32CyMjkMxxok4JFvArebX+6c2bfLzYbKMV/xX56B8DkLgoCimN5KWB+ZKBtN1vZ9WeRmRX9HiDHeGgyLcq13Oxmx94gOxZ3NdUdCe3YeYAtIf/lDBT9qaFhB7DUAZfmgrbnV5eX2NrAs4u3dZi2ZFNfEvij8Zo/k7jITqUYhy1pzqW8fF7Wx/NFB1vapicBA/PmT//5qoBO+1MQr7BZd3cfJ2WsJ9ZnV8rGCZf8qhQOG2JKE+kZH5gtG6B8wDjH8gAM2prxFoq8/WFzvp4bqhiSD6mWHmRMMSDFNfjNBwgvih9ZuHY+N8xr7Sp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/17/25 10:28, Dave Hansen wrote:
> I'm thinking that even messing with arch_vmap_pmd_supported() would be
> suboptimal. The easiest thing is to just stick the attached patch in
> stable kernels and disable SVA at compile time.

Gah, please just ignore the hunks in that patch other than the
drivers/iommu/intel/Kconfig one.

