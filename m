Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81408FF885A
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 05:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94806B009E; Fri,  1 May 2026 01:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DA56B009F; Fri,  1 May 2026 01:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5246B00A0; Fri,  1 May 2026 01:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A80CE6B009E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:58:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0878DC1EA6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:58:37 +0000 (UTC)
X-FDA: 84717796674.07.C06F51E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3D6D180002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:58:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F8odcznc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777615115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl49s9nKRClq0v5ghPMid/E/Bdbj8j5SNFSfnfUeaH0=;
	b=6i7dTc7TqlYsO2CmMLojTS8JeJOPOuldb3EcbJgeUeiO2iMiw0jDI7RzRBSb5fMCW0PBzg
	EGDzYqxEfaY+MYRZ2Q2ueHf6+66hvTXOV9N12v9zusHWALxGqh1fSuIzAtkf53/v85Mr1c
	p0lgHTReAomXtfzw4wklDU4+8uXiJ1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777615115; a=rsa-sha256;
	cv=none;
	b=q0PjsB8tcxy7yHmv6+oA0vB8XHJKs6NNtxjay4d4pEs6TLMP3QX56FcmWhmrC6xtcwNq/o
	nlmOBBjXWvOJwmNWkOVkohIaCcEK90KOQBhNvpvjdX+hm+Cfagh2+6Nqv9K9jiWpDgiD7X
	luKzR4wWmOCswBuOQXHm2OPise66dHM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F8odcznc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777615114; x=1809151114;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yAcfkxfbR2la1pdfQAuJBKYDWqtlUkcS9+Sx+Dtk6WE=;
  b=F8odcznc1+xi1ywzjyEWDRlqUpQ8PCPD7PzQ6wQknlcvP1noXDX6A4dE
   rlZFj1QjzSDd9AoWaHNKzBDSLLIkcj8aXbSRIV6VEvLl1OFwi5KXkdoWn
   niEIbV99g+e+avnUWqH0do5xLTbZx392xmwn97grC+kXW8cYbhRdgxW0e
   L8C/uKDPTYys6ZXaScj/R2SqYAkPSiBQHKAQiQKARYL1AIf5FBxex+r14
   w2S7rnSDbuxnlqxr59lNH0apAsVZcoqGyqjzwphQiB8LqrIRx9EdsdYcD
   sRWgO+luHOIiGBBH4Bm7nqZqMxeukwtC46apBusIYRBe2C7jwf/t3rrqE
   Q==;
X-CSE-ConnectionGUID: kdDxdcOnSiyjrosu4i5yYQ==
X-CSE-MsgGUID: sZeGNnupTa+qeiH0p4BB1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="66112805"
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="66112805"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 22:58:32 -0700
X-CSE-ConnectionGUID: AXnJJ+04T3eT2pp35tH8sg==
X-CSE-MsgGUID: t0eMZvkhQCKmdnSeyLrGjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,209,1770624000"; 
   d="scan'208";a="258376842"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 30 Apr 2026 22:58:28 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIgtN-000000000EX-13VW;
	Fri, 01 May 2026 05:58:25 +0000
Date: Fri, 1 May 2026 13:57:47 +0800
From: kernel test robot <lkp@intel.com>
To: Feng Tang <feng.tang@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Changrong Chen <chenchangrong.ccr@alibaba-inc.com>
Subject: Re: [PATCH v3] dma-contiguous: setup default numa cma area if not
 configured explicitly
Message-ID: <202605011354.YrrRWXdx-lkp@intel.com>
References: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428060550.7167-1-feng.tang@linux.alibaba.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D6D180002
X-Stat-Signature: mywts9j53htu4q5e3jaonaftqaof784b
X-Rspam-User: 
X-HE-Tag: 1777615114-128176
X-HE-Meta: U2FsdGVkX1/MlZ5ucYi3NufSgccpkqXJhM0CziO9HF0lC0i8Dpv1Neu+euiZ4PKLGEUVLMwR15kjE0J1X/NmqEF04nyBetCm2gXdYhCpvwpfX1bmC0Ynl4SS7wZfdPcbc1pvBBSP+ZONnCkJWNHql/4boIq3sqV6s6Xb8/IGaOozNWgk72NLZB31EqA82phFqhCaJaZJS87Xw0JyIdIhIEj+sUlPB5m2KHLivOfeZBNXkoHW/RNKqVcgTteOkW6tTPsLE27l0r0clEqd7jTxxaAeIZNRSEftxPHk7RWKaAd0YUy7u2eQsDgHk/qw7cEQhYmZ8WFbRfVpoJDY5KzxJlH0HDH2A7co0Sb81dZUAmiDKRW6dlNIMDE/gmPdJkZxqiDulsAwupFTmeFs9Sl9ftiEwueRa/SY3mH41bow43FPhkX8Lyz0OO3djoSzwGHnpiRzJ4cJlROw+ib9AIqEAaB5G6/rrGxaZpDrCARMLRPBaFArjKohfxHlf60oMiNAE7UcqbF7vo0tiDbaTWCBlyDCasSEBoH3EH8fRF10mLaDSJdxP3d2iXJdKcjZOWOyK/mH4stAaq9G42ekRz5Q841m4ugojdUEKToLzolbyPsnMYTDqYPIFa3QLVvqlvq2qKz7YMM4XjKAqSgdFklHEF3NZsg3vmUj7i2SZEdYUrRAUn+vwlskAJJh/dlGaVAdE7r9wJr+ZAvHtlAOY0Bfhr0LEWq1h4CRkdhcZussKhJX8QfMXuIXerC5sVxfNBgp+sq9T0/V7yM1o7jd4+FuiNOywlTebAbiI2Lh26R+tzgbvUxZ2o0Ik9ogAKfAQmTYgKzNddO0HHZAOPvSrOH67kpUCNjtnYsTNiznejr9ySAgMn/QPQT9TT/sisgf2is+4LSnmOMZfBDmYk8qQIhkbhXYZ812/7ED2f+DsdgOkHcIDTbXskU09jcAJNuL8qySRAnJPBd5IELzh4CQOjS
 MSRvAmgu
 pK0lLoTepvRbqi8JfVlNk/UVwXA8aYzH7KUtofSpfbrB/LYOOAXb4aLb727YucT35YgSR/F7qpVQlymGLktEdAFXsdpnwSl93gY+Wc4eikofEFeCq27+SfS7/yKYJcKQYk0d4FljcelN8LRMLgmWUymF1TPvE1J7fBMGQnXxYhnyqlX0YpFBDhHjJfhwiD94agMi9PqVaA4RmDjOKqQuhsRMqvMwSnzweCoYJ/tBNi0L0vuRHrWceXB/EShF1B4ft7btlZy4K9WieSogaizjMEBqJLrJjwkI45x+1tYvAT5Zuf82VlqSdK+80OxBDT4RSG7N1fL+c3aVJZeWCXLGxCvukng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Feng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.1-rc1 next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Feng-Tang/dma-contiguous-setup-default-numa-cma-area-if-not-configured-explicitly/20260430-073422
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260428060550.7167-1-feng.tang%40linux.alibaba.com
patch subject: [PATCH v3] dma-contiguous: setup default numa cma area if not configured explicitly
config: x86_64-randconfig-r112-20260501 (https://download.01.org/0day-ci/archive/20260501/202605011354.YrrRWXdx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260501/202605011354.YrrRWXdx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605011354.YrrRWXdx-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/cma.c:57:12: sparse: sparse: function 'cma_get_nid' with external linkage has definition

vim +/cma_get_nid +57 mm/cma.c

    56	
  > 57	extern int cma_get_nid(const struct cma *cma)
    58	{
    59		return cma->nid;
    60	}
    61	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

