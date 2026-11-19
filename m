Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3224D606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=I/tJpou7
Received: by kanga.kvack.org (Postfix)
	id 39E5A6B0683; Thu, 19 Nov 2026 15:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376346B06D1; Thu, 19 Nov 2026 15:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BAB6B06D4; Thu, 19 Nov 2026 15:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F14946B0683
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:05:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8025C40AD4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:05:17 +0000 (UTC)
X-FDA: 85452947874.04.E1FD809
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id C82631C0015
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:05:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I/tJpou7";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795118715;
	b=F6gctZtp9F1Z7hy6RttB7PWrJMNWDMZ8MV/G0TNgE+z2fs8n1sAV0hnUlB402r1yRDBJJQ
	rjiojOgDDGMiq4x38p/dDR9vTpgvqG4OBrBIIOyVvkgaU7xssDPiys8tzG2I6OMMibftYY
	HDPU34bW1olDxesowb5xtjP8LEuUY8A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795118715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmEqAprUI9Ka1b+cT75gbEclXdVG5O2jXgAq6Y++HCY=;
	b=I06qF758sHArsWNdlFRO8I5cvAy4n/tY7DKibnOuuIcVxXpIqY+p9tWvsVSCVbmELu6tNM
	M49ieKVANCmuQE2buG8NsSvQKy+2gvJ76ZZuwYjR6wJlvMEN23LTBGshPHzfVpsN9N1Qp+
	1PxO4uZD9SV8jEREWrUFg7UiLuYVvpg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I/tJpou7";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795118715; x=1826654715;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M9h6fquN+Bcj8CTTmf5eSTB6s6zm+g8iWEPOazkw2do=;
  b=I/tJpou7RWoTJ77YsNaoT7xQDW8K6eR1NwxlyoTBb4xiky6FV3N7OLbp
   qnpTFQ3NZB4hpBHB2ID9OFF+DiF9wrsXukoxEwvljrPuLyVVwmyhwYg8P
   ju++HP1IYqcPiIDfUL5lMQFsqqUPLTCeOa8PV8VdvzSb0LNblkb9AKgFb
   lAq5LcvOYBhV8w7wDznmy+7iwR1x8LT1NOtHz5lDWF9GIBb8cXxM3pyId
   RL+CB9VHM6HLzEl1sjcPy3WRurVAK5wLdFiFDk/qX9kJ7ijzJp8qQO3yh
   B4ViFklcjySdcNfCUVGtJFaAbIci4t1fjsdauQfofAp6Pv/VRUKQOtlLK
   w==;
X-CSE-ConnectionGUID: f8rYEnjbS7emR8FGGKEe7w==
X-CSE-MsgGUID: oUDILBDgThuNMCx8YpVf4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4027099"
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="4027099"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:05:11 -0800
X-CSE-ConnectionGUID: VJif7ihFTwWGTN9RwwUDLA==
X-CSE-MsgGUID: aMLciR08TZO3r5v0GajycQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,221,1787036400"; 
   d="scan'208";a="10603979"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.109.68]) ([10.125.109.68])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:05:10 -0800
Message-ID: <55034934-8aab-4e8a-a74a-b30c977670ed@intel.com>
Date: Thu, 19 Nov 2026 12:05:04 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
To: Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
 david@kernel.org, kas@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de,
 rppt@kernel.org, stable@vger.kernel.org,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
 <20261115000005.GG3706007@nvidia.com>
 <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: poj6kg5udp1bu9ackfnjcy3cbcrrdyce
X-Rspamd-Queue-Id: C82631C0015
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795118714-508128
X-HE-Meta: U2FsdGVkX19iPem8ZvcIPZPdvTblv6K90XjWPxODfv9J80YC5jDltEuA6hz5gwo9EWRnmHt/uai0uqjT9pnz9hsOGOsTSGAxneiE6ZV8y38cCORtIYqrOBxrGhTOGEuPpwvK4uXRlDk5TS4myO+4ppnp2p0YbzcSIErreKaSjbkG6NhQW0LR/Yg3IrpPjp94rCt0ilA8bhqi+ZCXLxxW4XhfhPAMkhyLvnXPGTm9pU/yIJJCQ/2OAeTyZ1FWlhEphiYdK3rVt7y8jrI/oa0oxjsB8ugJQt723gO6+2+lbmL5oJifigcyCDTwxROUXzonGNcjSeCE2VDEp+eldSkvMNRN/T7HXB/aMDHMGzKG5KPX2xZHu5CQDNXEeEPIQHC0wI5uNizpFCIldrI2WDRpJZYyU4FfyOpnGjhV6geU62CdhYuhxpJnNKQ4w5/mt95tI4KgqC2tlXUwdSax2gLomcWq6Q8ZRIdQe/Gbb43zvMFUGiXpRxGEkdN20mhcTjCXkW0FJUSsM9hm42PI0Gd85+dZoDmr1NuRBwRbDbmI0Y70n0V7YslL0XjOBDAfhUDBZVvWWsPGCNVUsYwrvcBGa5Z/BHI0ZdCHh0h/lTgDT0aHtyMikVfxhMLpHwTrU830S50Zk/8//Kg/dUBCrUPGqQx04a3SGYfUpbIO30XscnqjcrToxa1uCn4sF/tGlEdQTvoxXikmpBkYIOoLjF/EvjbdNXhkna3wT20H3yjyWC/Xpkhx4CebWW5ais4OAaEzrRT+9/pbO9apicbTqPk86XHSt5R6ZI9T/ra/icWClwYLNdlfqQnGHYZ3+cJfpsSoKGbLl1G1lvkPd2Z7J1e3gCBF60wfqIWA9nEunt9Edx+peDAxxqaShUduJelYMT/1f89E8t6bJO4Z0wBZLEIscZCjWjXdOoTxyvQMjK/8e/9kMqUii+UCwrhgJWjv92hDQt25RW45OONUyc9jQ1Q
 biPb9r7s
 515oS3FS/SRUBT6BJ1wSkMHsMhfLnaY3/oU1FhG3CkpbpRtljQET3VhfsAHLY4/xhfbmZzXpT6zv3frM6j5KzbC5cdVWMYEA5Vit4c4m8egixfv+e4M6087frCkW+Mm8vtjQx35KAW0Ym+bQJDwPOQdOqiU8M0TK3s//MT/G7RFieAfim1/ysXa6Y1aWKSeHXsW95wAXcF+23bXZOTBlh3tDSZ1vM5e61xtu9HX0y+/OJarbB3k+rsquviSQMqOzwHeHDw/Guu6AbRetIfEwKZDtmMU1DBXFTN3pwBtn2dkWMb9iWipXTHa5VuK70X5+HztpGwuwZvnWgDQbCSZ/k1SSucryZtgyEysYW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/14/26 17:01, Andrew Morton wrote:
> On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
> rejects ordinary stores, but pte_write() reports it writable because
> shadow-stack instructions can write it.  HMM consequently sets
> HMM_PFN_WRITE.  Nouveau uses that flag for GPU write permission, and
> RDMA on-demand paging can use it to grant device write permission to a
> registered memory region.  A device, or an RDMA peer with write access
> to that region, can then overwrite the process's shadow stack,
> potentially corrupting return addresses or bypassing that protection.
> 
> Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.
> A requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.

This is a fun one.

I almost wonder if we want to go one step further and disallow GUPs with
FOLL_WRITE on these PTEs. There should be precious few reasons for
devices to be writing to shadow stack pages.

Isn't this a bigger issue than HMM? Should the fix be in HMM?

