Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5F1E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 15:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E4C6B0088; Sat, 20 Dec 2025 10:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC116B0089; Sat, 20 Dec 2025 10:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07C96B008A; Sat, 20 Dec 2025 10:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFA696B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 10:57:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 532441A063B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:57:28 +0000 (UTC)
X-FDA: 84240304176.16.1F04C88
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A81C1C0006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:57:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PE9QxOcC;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766246246; a=rsa-sha256;
	cv=none;
	b=iPpH7HQMQEuhvQCpfl4vBFfSVcaPn9gUEg/TCJwdVEbg7piV9DqcrYf4Wy2nLec6HDEBuB
	kZ7g8CfCqw5NMbx2dJI2VQVyQeB5+nY5QJY3WK2bLb7rnqfhs/vpcbTKOaxFgULlBJPbzJ
	gEsy5dhe1jVK3eEWH/EQnCWnDTFbTa4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PE9QxOcC;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766246246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzkROV+8+ZPemaiG7wDR+25RDFXtoSWM+BuOBMKEnXw=;
	b=4mf46TWryroodyc1VxLN1/WnOeAnv81YjO6t1J7zkNeH0eHsf2s7IuaIVQYo2s9lMtAlo1
	wD9oi1XeG3d5a8wwJLJzEe/aWPCMQEtndTcWJ3Ib8AvrKsWCQGRU94woyIme4aVxLDVE/F
	MKq+Zel1B6Du5d7RI+D96u+977nxQ3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766246246; x=1797782246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mvgKR5eBPfsudG+7ydx/1/S0torXhJ+RG9LyOYP6tlY=;
  b=PE9QxOcC91ijSXABanApfWrqJz82Pg/1+dioaE/O//cn11Ew0IbIfAZn
   vFXGuDgY51FHyFapoB/gXqC3yfZAMK5NgSeth69oIcGDQp6b+8gi5IiNl
   OZqBs1duYMDJzoiDUBtJkhgbcj/rDRhowLqfGMKOpSQj3gz2b8tKVBbwo
   mQyhnHMI63yYf7414/1Ah+eA4VUV7cegI15eIO5l4iLqiQqInq8PfkR2R
   +KJHg8ZZ85GOTuxwSkA6gMFtm87fHIe7qc7TwlP0ObyzL52I3xT9bD6hp
   +T8Zvrue1krWmwhmqZNZCSJ2rypgVvc8cHWFC+NJ2e8v22nKbzkEqK9ey
   w==;
X-CSE-ConnectionGUID: E2s2WNU+RsqMLkjeqvqRTA==
X-CSE-MsgGUID: 1GD3UbVmRsOzb28Lh/0FIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="70748110"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="70748110"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 07:57:25 -0800
X-CSE-ConnectionGUID: OK5FWqYtSzGM3+TRRKERfw==
X-CSE-MsgGUID: UyYosMaJTDaoOZl/8+B6Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199642886"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Dec 2025 07:57:20 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWzKX-000000004nl-31dx;
	Sat, 20 Dec 2025 15:57:17 +0000
Date: Sat, 20 Dec 2025 23:57:06 +0800
From: kernel test robot <lkp@intel.com>
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, Bjorn Helgaas <helgaas@kernel.org>,
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
Message-ID: <202512202338.qFqw6FI8-lkp@intel.com>
References: <20251220040446.274991-4-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220040446.274991-4-houtao@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A81C1C0006
X-Rspamd-Server: rspam04
X-Stat-Signature: wzdwggjn1a1t4frfpq9dribxobx8tfaf
X-HE-Tag: 1766246245-210732
X-HE-Meta: U2FsdGVkX1/0JBr7x4nDN518iGQA+VM6maS7VLY8A9sLmw1gN5mXVFbWdocUhyMt+HPyykIrFpjBtCOIxQ2E7H6ndV6GNCRBt4aYopUA7rk892D2MdmE0J5GkSim5UxF0Ph4YON0XcunvPAPp8gNzdg/eYS3xEhOhJWIHsX9eeC4nsRPQSF902xAnRHKQTAunBQtLzDTw0t7ATf+c/3yCtqVelAxRyaM0E4GEYZejiDLeL4yxxYHct7YBy3erOrNAGcrvFs0Gq3b4uvsDEtkPqyN63rwTrAy4+nQ/fIYrBxlRyg4+bypXQDO9DTgB9N4QuHfvG9gQmPupkGnkQYtsrIfE7m/S9f5M0kXHYp94yZW64HdUbm7ppS9308jKayvtztlite3xN58GC99EaBhyPScrDuSYuXopfg11t7FR+Iaug9PQNw8EK9Bh6JlK/m4q52oogjjSLZGT+jEMLlG5Hdki6KawvvM8LnmSMxgYJsgZ9v/5tPLZ/CLcwf6b6v9peL8gV89FPhXj8WSPFr+dlE+VxGwYZauk7gVS26FfmBKSsczlDhemoPPwoahR8rHbfjL/MXpWVHPqHudfVdHeKqgEGBr29shXdQZ3GuIT3G0T1MQIXImnoK2vR0lz8tb4vpBUS0PztI3h0zXDfBA+7N5US3WRp1Brgh41bsks6Dz8K1F0mtQAeal+ehihL2+NPDfc0J3+EddoX68t4LXIV0g4bd8XlnLKa4hok3m4XChe7WkB8NbtjKpbJYtAgZiUaGti+oW7n/6IlYf7lG/VPMirX9gNM4zBrXR8djRBUzL8crkGtpS7PTOiLlSush0hqzfMa8MNSJl9xyYN+AILwS8IwBNfQw2UTMViCP+xOGR2xuDKVOfKN1nMJYR89tneumakVP2l/iIQFeakLGGLqjqCDnHdiK/jWx4fY+Ka5KlgWpNQEJycTbo7KYc5bXoLM7wZd2Lke4h2UAtw6l
 wiaj76MC
 qDdN/QLp/Lf2PXmJwnOaO6nkeLX7W5gMne88M5cyTcJWV0ZB9QubKUdMn/ehJSKbu5mxlHmwWfxqUZ9jhncQ/FMrDxoOilBA16yV2LALm2wKpD5xqPcghklRXa1Es4dLpBfBF6j0BV6FuLcaVuF40wPe8eJxHhfKfGUqiEDxOeEUQvjHOrvelnvaOlj6IRf7JQSDJsO1y2srpu11JymTCn9+wHH0upcd+GwGK/Dn3MTl1b91Cyy/0Y9NvNq+ox4gRMrWiE37E1NbE/TYNsyzJMZ30CqzK4UziMYOO68on6bD5h1nUZVKOytO5+C0bl+/k/8E8qeJkIFbYUVi8BWa2QvjYibbXkiUr0pc3hgnMyaf3shZ6LPWnCRBFIuKZboI6DpWCI/lBrW3KjOLtNQoV33U3+BPGflVz3PAyJ/QcN/jMDfk=
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
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20251220/202512202338.qFqw6FI8-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project b324c9f4fa112d61a553bf489b5f4f7ceea05ea8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202338.qFqw6FI8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202338.qFqw6FI8-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/kernfs/file.c:480:9: error: call to undeclared function 'mm_get_unmapped_area'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     480 |         addr = mm_get_unmapped_area(file, uaddr, len, pgoff, flags);
         |                ^
   fs/kernfs/file.c:480:9: note: did you mean '__get_unmapped_area'?
   include/linux/mm.h:3671:1: note: '__get_unmapped_area' declared here
    3671 | __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
         | ^
   1 error generated.


vim +/mm_get_unmapped_area +480 fs/kernfs/file.c

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

