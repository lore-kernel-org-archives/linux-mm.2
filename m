Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC0D107BCF1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 03:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE6C6B0088; Fri, 13 Mar 2026 23:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1962D6B0089; Fri, 13 Mar 2026 23:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF306B008A; Fri, 13 Mar 2026 23:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDA976B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:43:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 445598B8C3
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:43:51 +0000 (UTC)
X-FDA: 84543274662.29.917858C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F4E61A0014
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:43:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m7D+SqgS;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773459829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lop73fpryGmzlcpYAtBalLiy4Ozu+gjZcQd8EQmhOPE=;
	b=rHuFCeCvGFjdW1pIZKERFKF+DYZvLMlMTwrUM0i/ea9ftP1i9w2LWlHmCwoI/4TUlLfNil
	YNzXbGA83dyT8Xp1TXQlXupHSM0Ocn6ooXuPdXdfvG+QYqyHTkAzHgd4DVkOOTH+iv06wv
	4bQfAqTFSFRdPrYiVjTS6SrX1Lk2LpU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m7D+SqgS;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773459829; a=rsa-sha256;
	cv=none;
	b=8BuzCf7wHPfUzgMiJM9FEHAPFIVFaMWKgsHFY7BcgiOgwNra7ECexBx5ofEp2aN1qAi5sM
	IrH+UYe6sMQgb8qJLp21WUjenwjGO5n3ijK4+SnxecVPeEXp6nVTyEANUGyE07iJDgghqY
	mnRMwJz1zq32fbttBGc6G9Z6P3GtKh0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773459828; x=1804995828;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kS+cBmQC7gM1gNSUurbOOTzzOTiUZdBmnUD9OtT30Lo=;
  b=m7D+SqgSwae9iV6UMkOrpHm4TYvUeZxsidhm1WlfXehTrGT0uKQr+nmQ
   t4wN/FrDy/dnKuyzd2XapTy+hsb+LiEUjUZLpwLG+bXMHtVq7dmChMT3T
   ieKu3Vcv6h5MDr/Tt+J2iWFLa46alqYY7Ok4MFUGzQc+Z12tJxGdojFrL
   RicWL2hUud9kj3gLVovMSnI8CLeeFOoBVFqwcpKOk4PVQWQzwzaC8PmeX
   6yRV2e4RtKRmDwkPfaRf5k40CkhmtK5l1N7+FuCyAEhfNTcJlJLLVKg/a
   YfBWBtjFsqMBtAnAdv3sy3GWihOnjlriu0FelcsdMI5flXm2qrzs9tK4K
   Q==;
X-CSE-ConnectionGUID: BAH4IbgkS6qQPuyeCY9mqA==
X-CSE-MsgGUID: Xt6RvNA9Q1irSCKO0o88og==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74481699"
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="74481699"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 20:43:46 -0700
X-CSE-ConnectionGUID: UKSJurcGQnWhOrTi8Ezv7Q==
X-CSE-MsgGUID: talYbqnkSdie1UjmS14HqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="226026513"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 Mar 2026 20:43:44 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w1Fuf-000000004c7-0vqk;
	Sat, 14 Mar 2026 03:43:41 +0000
Date: Sat, 14 Mar 2026 11:43:24 +0800
From: kernel test robot <lkp@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Saravana Kannan <saravanak@kernel.org>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 7/7] of: reserved_mem: rework fdt_init_reserved_mem_node()
Message-ID: <202603141108.XvqRlNaY-lkp@intel.com>
References: <20260313150802.1121442-8-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150802.1121442-8-m.szyprowski@samsung.com>
X-Rspamd-Queue-Id: 4F4E61A0014
X-Rspamd-Server: rspam07
X-Stat-Signature: afzttx3upfg8gb41hs1dcfd7pjbdfac6
X-Rspam-User: 
X-HE-Tag: 1773459828-398165
X-HE-Meta: U2FsdGVkX19p8rObMpECe1uFSn2TtLkBPyv1JW7Rf2ncwjvlxguZ5dPAoqqOyRhnlD9ky97Tgi9D+rbOIO5rpAoiaXLgCe6TaLAXvkw/lp5prZdJWz1zoatNgnrEdjphNnmZwSaKivc17BontTOUmRZr59zaNwbJdga/YTZ+Eusdvb1QZG5v3X3A6tI/xfdKENJuaneuX6FveYOG2525x/QFFZgT3HgBtXlsIX9y0PxZ9Zi475CIeXTcZSLrNib1ks9B3Tb9FHfQF+4rsgvLaVoINBILA5ZFvEafDQi4ecR/vFUbNWeJfk86BFY4NVe5DRg4MNxcygZrA1zvcZvU+pfbQxsCbePGDIHF45lOyR9hmHArnN8uZDglqa7811OjY+8CyeejfJ1nRHAo05ELyzrrYspLVAF11/nfLwPTdb1RXhpMKA6gQy9iElEFD0LqiDMHatlAlDiEr2jtICnwPf3tuhfh//pIOi8xYKocyYui6OLVxG0CEhN5w4Db+ywDSQhDzxcJTFRj0LGv8emCETnlbfp9NXZacEARUn+LkzFGNy2DyL5iz2YTSkEqZ9meuwBHBx5FCBWkJZP94pEPsfaFvDMsZhUgOnxSLN6zL6X/flQbwS8rfNlugK9Uih4X+b/A5ieB6Xy+AnHl9gpIWYqDoMLTyK+cajnUHUpF/kJzemGZLcfj2mYE4JT2yYxSsmXduRQZo5ieEaD1o87rfxDgphSV6mScSdMLJKKfa9osIGXM/PvZwPEA3wMZjEjQ0GaLwRZRRF11EfZjjPvhOKNX4MZ0q+YSTr3M8VirRzITDf6intvpBLpwL3BxA0JhJxE/DmvoXWfcoZiLKWn8grOdqQIVWT3J8Ha9e8s1+YUz+f245MM9k85jdkTHPzqDt66/PbZujMwfFr6hyp5uXL72Qij0H2Rfciu4niIaZLwDaXeh6/To0bMteKytFTJkyS1P+WaQoROzDMaZ6Nf
 O8BEIJSQ
 UrhCkO+CrbT/xMTE0qsJThVNAK0Z+I5ujXvKAxRuiEK6obtgD//hrJvOoC9I49EkgJs5ghuuI8Cr1PkN7DiEbyq0Km9KlSj+Vsht+frTzL3BiLagtOLeSl2EX8s+j7j0Y7GYo/xfkidMO0Cshs4kMMj+DCscbdEBvdYMuw63lJcpORswWchmnFGQAFsK/2amBKlUxvMHMKtnoiE2aw2SRenXL8QIl1xqMtLjVp3/OZ0zlydDvJNDNlXYtOms3C5ZuX7KHrJGbdDnnX2wk7PXnhq5/pEVHFpvtzYU66SA45ker4jiqcQUYKBCYuDhuMd7UPAjHKE9C2KVG/KJZRyWdFzSLuX6jdzwaB77C6GNGa71DRgfQnq7bAA3xigNcSwk3Rh55m9lg1g09eEhmb0AMucPYX4S4fy1G7OfeJ2SOc4nXZj9oMHCFSter2mzQ0vgaeuJPardgCpRVSLYqkGycN5LlAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marek,

kernel test robot noticed the following build warnings:

[auto build test WARNING on robh/for-next]
[also build test WARNING on akpm-mm/mm-everything linus/master v7.0-rc3 next-20260311]
[cannot apply to tegra/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marek-Szyprowski/of-reserved_mem-remove-fdt-node-from-the-structure/20260314-023123
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20260313150802.1121442-8-m.szyprowski%40samsung.com
patch subject: [PATCH 7/7] of: reserved_mem: rework fdt_init_reserved_mem_node()
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20260314/202603141108.XvqRlNaY-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260314/202603141108.XvqRlNaY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603141108.XvqRlNaY-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'uname' not described in 'fdt_init_reserved_mem_node'
>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'base' not described in 'fdt_init_reserved_mem_node'
>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'size' not described in 'fdt_init_reserved_mem_node'
>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'uname' not described in 'fdt_init_reserved_mem_node'
>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'base' not described in 'fdt_init_reserved_mem_node'
>> Warning: drivers/of/of_reserved_mem.c:580 function parameter 'size' not described in 'fdt_init_reserved_mem_node'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

