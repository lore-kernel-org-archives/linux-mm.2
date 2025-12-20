Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCECE668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 15:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D606B0088; Sat, 20 Dec 2025 10:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA206B0089; Sat, 20 Dec 2025 10:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFB16B008A; Sat, 20 Dec 2025 10:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2606B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 10:44:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2DB813B770
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:44:27 +0000 (UTC)
X-FDA: 84240271374.14.67467D6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0953140005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:44:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O9iqtskN;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766245465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMl/TGA0u1xBmBaMRlepUrMqntUGhGfVo9a9FRBDMXc=;
	b=2eY5D1zKrAZuC8iFcrqlFEl35mP9Mn5gHQPD330u74XczPg+RKUevCAGs1txFhi2u4Ab7P
	/bBCfPZLIC+nZzg63GsskL+4yZN3WV3LvgYWDj53aqq5U7H9Dwdqp0ckVuFNVuWsd1WPKZ
	8PGiSiYtrAvagzgr+MxqtWTQdTCpRow=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O9iqtskN;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766245465; a=rsa-sha256;
	cv=none;
	b=1pf16ECXro54JP6h8AZ4F8bVlmCFon+XpTQxJTvXqjA68zhJ1FeBHTP3ApOON7Lq5xleRh
	8p7oLi0KNH5wDVWxpzP6XMXJJ5Uc2u5XmLQZAUp45CdKG+hNvnYchmH28ncflWZVm3Xfvx
	KiJzIfhWoDyKDdhLtmJUNFRN0G3jbCw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766245465; x=1797781465;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i30qgdidF5swEfrY8bISvHkNXQBtVxmPrBDz6HH/8cE=;
  b=O9iqtskNA5KY/6Ecw5zASgsMZjKfABKdxlTFJsLX7ZCn/RgKka50dsK3
   BBl2NXNxkrYGb0jyxG0QO1Eb2UWbLU+II45XMthVK+sVRmkvrMx1rJD3/
   lCUCQ/B/iOsCTKGFHmrmibzrHgSOVqe9j7Nnej9ALRMJLgz7jun55t/tV
   uCRlcNy0qDyv8yTFIsVFdSFfyl6Zq428lQu7TeR16kScQ/mhTJJJKr5UH
   bY3Hwlc0DM91z4EcbpRZ8kHfy1sYnSpBvPrXIsmo3744Kgzz+/eMfwzdP
   yy8jSI6GuSp7YZ1mVKuGsQe5yDkFf95W5zFb0eSTP09DEi6B2B9KNuMx7
   A==;
X-CSE-ConnectionGUID: DPuQniRPQ/+SYdNOxKDJBw==
X-CSE-MsgGUID: gfzuAytwSJOLnKHDc5ZUyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="79297145"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="79297145"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 07:44:24 -0800
X-CSE-ConnectionGUID: 7rxyLLmsSwu8Qk61HDxw4w==
X-CSE-MsgGUID: odg2+K3HSBq45ro0hb4fag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="236535410"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 20 Dec 2025 07:44:18 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWz7v-000000004m1-2LBa;
	Sat, 20 Dec 2025 15:44:15 +0000
Date: Sat, 20 Dec 2025 23:43:44 +0800
From: kernel test robot <lkp@intel.com>
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 03/13] kernfs: add support for get_unmapped_area callback
Message-ID: <202512202307.ewUcqBQV-lkp@intel.com>
References: <20251220040446.274991-4-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220040446.274991-4-houtao@huaweicloud.com>
X-Stat-Signature: 54umbb954ns6aaygy7baymnjxdx8ab58
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0953140005
X-HE-Tag: 1766245464-94354
X-HE-Meta: U2FsdGVkX18Qx8cSXIMw8BRjqobCB6tQbL28j4KpxcipxhDytpDMcSjX0lbdex1bnatSvJBifzkUF8WxgUGlg4HaNkASSqpXwIH5FzWJjb9YsX7lvMxXyU/PLQ111UQ6XgcK3CHN/XuF8XU6+UmVseu/t9LLk6D9ZjwB+/8sWQr5Fc3eAuT7a+B97hsiotRJpJFehiSuGlYzy+kN8Cr8eadZ3HhaLIieomnkDateMC57W9siLzgoyD3kGm+hEZxW5nGOPm4zHfABZzN1rl6pScIsP7+z4/1q/VrtgLNM3mOZ1YAiO8xHcoMUC8nEfsMJgDlMeUwSKwvJFMNetXDYCYHaVVS7odSyOrhQ0CGlWEF/sv8XUYWkP2XqTj93orPl7i4cCb5Iwvqouxgnfl/SV2KnLxHnV+exBNILwKn5Mnv40S0p9rlj7p98RB1OdvI2D2Z2oExjm5FrCfjo9xkk0kziXm6YP8Dg+ldznBe74SagPR0gZ0Cqr4KbmLFxGKCu/wQKgEwGHgFrsWpXf2lljWzkDr6fpO6d9bVfFWqjxuryNQPJ8hkQGuIAAxLAlK+Xhs725y0puaPZo/5X37+rivxu0NA4ruRnOoyBUjO8JgmMxM5t2XhUQ2WfQEdkvmcnyt47UL/ksiNqSOM8jbpUdjBx7p9j24NDJf6Xn0hznxkYkB5n/7Gy1XJQ5ZlD0NJgZsd/nziCwDhVL71sbNLRFmrXGAPA63H2syydynEJjBpzyTy3OQn306BRRNEGnWeqhMASw+pQ3DWElSVapD9UA7AdfaEgbUPQq6pDFS/SIcMlgDUXC1rztAhogLMhIqKj+tp1QJaq8ucGkUbJIOyXjzNZgte+AkX4Gv/tuNIdruYJrXgmtjkg6/yucmIqIvnq27OsA1+OakCT0X4diSqQJpZXZuFLLJ4kg4DsLxBSqZ6WUJZyWlUbBkMC1MlsHIvIJFVmYwYe2Z+SgjO0YME
 vySVUleC
 kGUMs7ry0eWjOMLI211nNtMogaJQhk2mM80bLAiNKhNEDB9yDaBZw71dYWZzAnlS/7lxX71pC5wrunE2NJ/DZOd4RDI27kcHRICcn8Sda1+JXpgiFsH8IORavI2vv9mdVmpSAPl0/d8Mim7Sj7jZU6ViSEctqpY+MC0Gdvmow6eRTk2Olg8uPAxJclZn5q29lneV0qVjgnRvgasxzh9S5pFIiX+qsd+yMfp6STrxfmCpTdAEf5kIuD+vKu6jiZ3mc/GfE7/AaLAyW9rKkqk/tE8zZSS2zPXI1Hid9bf5UlPmMLKXM/0AgZESETt+KJ1639zO/VEJ49AXgCXClZx3XGghPAk2v1y6kzyZR9qmnVe24+RKRgn7SvBYhjg8cps57y9MRSVcAX9UMMFJJl3ZLN8coyOpmVH4QgQWLBCUTzPZLsX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hou,

kernel test robot noticed the following build errors:

[auto build test ERROR on driver-core/driver-core-testing]
[also build test ERROR on driver-core/driver-core-next driver-core/driver-core-linus akpm-mm/mm-everything linus/master v6.19-rc1 next-20251219]
[cannot apply to pci/next pci/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hou-Tao/PCI-P2PDMA-Release-the-per-cpu-ref-of-pgmap-when-vm_insert_page-fails/20251220-121804
base:   driver-core/driver-core-testing
patch link:    https://lore.kernel.org/r/20251220040446.274991-4-houtao%40huaweicloud.com
patch subject: [PATCH 03/13] kernfs: add support for get_unmapped_area callback
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20251220/202512202307.ewUcqBQV-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202307.ewUcqBQV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202307.ewUcqBQV-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/kernfs/file.c: In function 'kernfs_get_unmapped_area':
>> fs/kernfs/file.c:480:16: error: implicit declaration of function 'mm_get_unmapped_area'; did you mean 'get_unmapped_area'? [-Wimplicit-function-declaration]
     480 |         addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
         |                ^~~~~~~~~~~~~~~~~~~~
         |                get_unmapped_area


vim +480 fs/kernfs/file.c

   456	
   457	static unsigned long kernfs_get_unmapped_area(struct file *file, unsigned long uaddr,
   458						      unsigned long len, unsigned long pgoff,
   459						      unsigned long flags)
   460	{
   461		struct kernfs_open_file *of = kernfs_of(file);
   462		const struct kernfs_ops *ops;
   463		long addr;
   464	
   465		if (!(of->kn->flags & KERNFS_HAS_MMAP))
   466			return -ENODEV;
   467	
   468		mutex_lock(&of->mutex);
   469	
   470		addr = -ENODEV;
   471		if (!kernfs_get_active_of(of))
   472			goto out_unlock;
   473	
   474		ops = kernfs_ops(of->kn);
   475		if (ops->get_unmapped_area) {
   476			addr = ops->get_unmapped_area(of, uaddr, len, pgoff, flags);
   477			if (!IS_ERR_VALUE(addr) || addr != -EOPNOTSUPP)
   478				goto out_put;
   479		}
 > 480		addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
   481	
   482	out_put:
   483		kernfs_put_active_of(of);
   484	out_unlock:
   485		mutex_unlock(&of->mutex);
   486	
   487		return addr;
   488	}
   489	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

