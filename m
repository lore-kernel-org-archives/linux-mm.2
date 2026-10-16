Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C035CCC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1F26B00B0; Fri, 16 Oct 2026 00:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B1F6B00B1; Fri, 16 Oct 2026 00:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29BC6B00B2; Fri, 16 Oct 2026 00:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7806B00B0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:46:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35242A02BF
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:46:29 +0000 (UTC)
X-FDA: 85327253298.07.4E32F08
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5264D140007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:46:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H3CNYYQD;
	spf=pass (imf26.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyouCirkfl4i9xhRozPfDZr6kxierua5xUCzKxgnlRI=;
	b=g3lc7l5rLQfbFt56YhYYBQROl13tQqG9RK9AQXG6d6TYzi+O6TaQAnBNZhmKBJVGVV6vv8
	vMCkxy6K15m0tG0DAp5WYVW+W3MW1KP1YgtMACZOYA9twCS0Rb5VhLmX3Mn6AESxU/zSOe
	SVMWxV47LYWRDHfgjM7b0dbagGyg6cg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125987;
	b=xYjfXTJbrdBbWEdv3kQhp5qDXgVIMiJyiaHD5fmt/rtDlHyWmB4smSZV3kZY4hPC2ZLeLM
	M3a6iNooCKCEzWI/WWKTLUhfWGT6TlP47ElIsFXRs7ol21l0irsdFY7PBDk9TRTDBb8OEG
	pdSLqoho/dTwMY3g1T0V2eMqThlP3CA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H3CNYYQD;
	spf=pass (imf26.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792125986; x=1823661986;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ESE5Y7NX1PVIUio7g0vrpnPWwgH0Dm/XFgqJ74MmLb8=;
  b=H3CNYYQDfP0kddfbPZL3j4Breb3ZeMM6rPeEFVyk97aFCg9+YAw5XhMh
   j2mhTGOVRimEjB2jtOA9Fr/JJfDnuyTvNJPVuFgXK3tLAYH9qneKHjxzC
   To4BGJFwaQWWGGAqsWHHtmr08DTe8uPrGRF+JclIOvoqJEDcD1ZMajQlU
   +O0adFMAdcSxWpqMqfD/BNZRO5/xQqalEF6o4v9Jsct8tjVzFFrftkw5K
   SrhBouyFcM6Rep1VVF7BDQiC+yDnQ7vZRr/m3z+sNizWLhi9xlm+UI3xM
   F7c3QUxdQbilndtHx90lfoxRV+iMLlFZERLHKnDICbWOh/UD0C6oB0bR1
   g==;
X-CSE-ConnectionGUID: hUQV2ZIkTTazkFvbnWUgtg==
X-CSE-MsgGUID: fLpKtEj0TPqX4GSuAWFceg==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="917571"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="917571"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:46:22 -0700
X-CSE-ConnectionGUID: pTq9aZLBSWy1P65RlcXdSA==
X-CSE-MsgGUID: 9pjtIiMZS2WPwF8bG0cUBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1955532"
Received: from unknown (HELO [10.238.0.90]) ([10.238.0.90])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:46:18 -0700
Message-ID: <630d7044-c7b9-4cfe-a05e-0def5f2900af@linux.intel.com>
Date: Fri, 16 Oct 2026 12:46:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jpb@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 iommu@lists.linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
To: Peizhe Liu <peizheliu@utexas.edu>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5264D140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: iw737qrtf6bn8yqqfhexkuok4ww9kown
X-HE-Tag: 1792125986-182956
X-HE-Meta: U2FsdGVkX1963TGYWI3jCxPnXLb4WyAf5ymztxe2kP7ww+0Taru5HN5o1VgPTLK2xLwGukLlVfP1Mdy5VduEJmYYMIeSvwZGWVt4WqEIerqpKE2tafE0hi+5KZ7Rx8QzsEYF1X7DVSfDQn/yQ7X0q5A8O+Xlbn0nUZcixkGmRqSHcABj8G+5LdiZdEeVAWiKuGsPWcBofb7qzxKoPIX8eEs30MLM3u/RbxMV/3nYdEvQFizHbje0RXBmdDQVCsJHLZdcIEbSFESUCEpUaIk6a9sjp0MF+VcO1V05FQlDl6DuGhK0xBC2bZAl3WGk3ifzooYo5sRLQPCB0KjkfGDTNVD/B7pzaRNLYpZ/D6YcScy+DZXNkY/Uo34qHKl2OW+mbZvXf2sdYRXzXGDg6MpNp4cV7xnApZgPT8LfwvP9zK0VxzNKX07cH6xWHpwdgb8V8Om8Nj6hiKNGtV5EH4yUAHRvqKtTiXM1s08RmFVS0+24rt24mmtSmLpWM/iiU5lfDVEyrcyTDg8HVcaf2/65jiFObXp/zwsNc18TeE8lFhsrMenfQDgbXsBF6qoXDGByeILbB2ZwouzDmdZwA+5MNScMSdytuNVFeGyMchsWW6tQ9rIJ2VaBj7uee8EPjH18GMrpQAdy7aCpjRa/ZUkjrBWg0RFNOJcCOEP2uYY8L7s6aCezAAYrlWprDZ4Mkyi1dzd6mol8hDPGWiY3vvYmT7wmxt+NavEoBZ7i5eCsDw2zAOP1JxA25LleRBbzXbLD4NbiKA3y8QjOQku6eoY50vkckGECnRNSWnhaFR7/NP6MPzaBSUAQmsoDEJsvh3HAVVoY8DLh71taWZr5kCVKJl6ceXUKm+2r1BrHwCCG3P9AsfqLWbidRm+o+hImRiDGEDearaLI7CCmDcLVQzD/4VHy5VhGOBfJ+CzzC2XOGVUHkBIcu/0tda3zN5CyqenLZmh2d9ffXvGMDieHlil
 HyHfkZgj
 i1MZgXkALJhLWZXPttXBdATiNSRemVdOpS4dw793PgaheNPRWNc0GTgbspfbUhghc1QsaCusDdmZVkCMpnp0+xO4JiOzeiNVuox7lvZv0xTUtv1ktYGeHuKl+67GNzLtl1MZHJtKfXVr9M7S/jqI52mGrJWNqW3mtuNc0t5BMTp8+OEf1L4hu8YPaiUMrLBkHQXgUOei6XV8+7XWizKoMA6EeIOkhPMIN1uV2qBt7lm4BWIbIgHvr21nXeCrvCVq7kr8NWgNERLqsbmUbFK/QDjq8Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/2026 4:08 AM, Peizhe Liu wrote:
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu<peizheliu@utexas.edu>
> ---
> Tested on a Xeon Gold 5512U with Intel DSA, based on iommu/next.
> Before/after testing confirmed that the block-on-fault case charges
> the page cache to the task's memcg after this change and is subject
> to memory.max.
> 
>   drivers/iommu/iommu-sva.c | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

