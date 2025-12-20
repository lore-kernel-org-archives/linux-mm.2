Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4087E67487
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 22:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AD36B0088; Sat, 20 Dec 2025 17:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D996B0089; Sat, 20 Dec 2025 17:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1DE6B008A; Sat, 20 Dec 2025 17:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0656B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 17:22:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 041F6C0251
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 22:22:56 +0000 (UTC)
X-FDA: 84241275594.03.F511F9D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id D78DA1C0005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 22:22:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FeEQjIeC;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766269375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5CFWlDMqsIScBlEIMUKaG7tzcNFXOWKVBL9cRce8VM=;
	b=U9ZuT5tD+s5qxxaZrOvNeEMAyw8L9756KZlQpfMDhUeUiXh0UDxO5rH34itGCElg7mpstg
	8u68riYWHIS0Pv/Mi6QR/8JAc4pxuVCiN6Ot1oUdxmRUK3q4fNsHab6lhK4ZYlGFcmcH2q
	G/tzzW39XCaPR+2gyS8uKbbi6SkZcP0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FeEQjIeC;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766269375; a=rsa-sha256;
	cv=none;
	b=dsZaTP2eq+c6gcCMKkAPI34DYRNAsBYTToKbCpwIH8QX3t63oSP9+bsnGOIyhLgVu49YKF
	4843uQYuaMEshhGWsg9s+m6k8VT/1uMHHBYtgQcGX3vbKeVBlnlO9o8+eaVlQ+GkZLgN94
	5SNwxF3Tuzn6X4YvrezSoNJyJCgsUzA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766269374; x=1797805374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R1Jaj/KasLrmbIdCFUgBGCNzU9HfFfRLRQd1chPkPq0=;
  b=FeEQjIeC99r/kiXLB19UjQTlOk1eg6C7jZ3RfebNQyosK9Amy4Ap+LHo
   wFRgPjmk7TWbBuLS2kFZxE4wIZUFPJfN7lsx9zA1/5BD/oURRkXZ1sXJD
   eL/oKeL9PMwp5eU4Qy1Is2ZcPRUBVEyiN9RcdjFvrlvolnLCgTE09Typo
   7TS/yxBTBNPKkR3tUYsSqAMac2yyaZFzpo1cdj/+RjCfrfT+3NPTUocQH
   ysUWNjFIYEa2RfT4sVdi482Nj/rE02Zv/GvAzUgaRAZpMf+4R85AIUn7R
   u5GSlHYa1IZ86J2d/1u1rHAr0SelCUIOM6AlchaxNywtwmJaWWNkNsQrN
   g==;
X-CSE-ConnectionGUID: avuUjbo1R622oOAB2VHssQ==
X-CSE-MsgGUID: 9nag/dxOQNKq25vdPSJK+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="78823172"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="78823172"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 14:22:52 -0800
X-CSE-ConnectionGUID: qLYGld/lTLavhGxUh1bGbQ==
X-CSE-MsgGUID: 4olp1ytkSrKr/eW1miFBHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199211875"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Dec 2025 14:22:46 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX5LX-000000005AD-3uuB;
	Sat, 20 Dec 2025 22:22:43 +0000
Date: Sun, 21 Dec 2025 06:22:10 +0800
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
Subject: Re: [PATCH 12/13] nvme-pci: introduce cmb_devmap_align module
 parameter
Message-ID: <202512210635.b7EdhXBT-lkp@intel.com>
References: <20251220040446.274991-13-houtao@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220040446.274991-13-houtao@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: wx9iba7ntcihkfhbe1a671d8a4ehpgek
X-Rspam-User: 
X-Rspamd-Queue-Id: D78DA1C0005
X-HE-Tag: 1766269373-722788
X-HE-Meta: U2FsdGVkX18H336GLm7SuAJPcfTCRtL/5FFzysHB2dq2LZEWPuUZstorwgHvkA9OEXoVTUUdfVmRrPnnxTFiohUi6pgqXdpYdXuqYstFYI450ZsnwuTSw2ZLr/YnXVFnySElF/mkrDi8Uki5Cu2ceSE0K2WZgZ0byfT37c13xfaOu1c54ZHHJKVdtUFe8RVsB5Kqtn75gL+yotaggCl/amYAwqEVMxlTJKzkbyrcoyCShBvozsqxXgolO0/qWw143LiG6CeSvrlkUvM9cEh9eNa5aL/11KTwREX4vqvprsHGDnhgZuY2rQKgRXyZgYuWdWBxM5RE2lHWF3XwNKHrHEP6LnmZppl3GYr5ss8jwODVC9FehC8QiabcfqX9+IUPn1q/rDSu5rt05gGtvFK6Xf7z3B0A+5sd9YdLInrcm3IXXCaTjzejBW3MkkSKF2eyjxz2zhnuEZy/fGXLGXTEHqfxWiGoG7ofikbYtIYDEdxmDE3z6HIoxo6FI69gyCBZp7nlOLAf+siCNUZVLYhNzKeaoVfHJe31t+ZO3BfWkrUW+RU+loHlxOQRHpEnHWFkhuZFq6Q2IOl22wnkJjy4c7v1cKAFoB11BCthzGpAhOOS2zRcEOqIRUMrAhs1lUCKYQ94PmbbtxJ9nkR1nbirU2qthXOc9+2Vh7EHK1jGshIR6ysXwaifCciUafGWqO4SDilzrYjAdvPVYkzwzBc7yiOnbIBhvwxc03BdiqPQ/fQZ4fioYrBBu7mrZXrcsf2xvO2kvlO5lgecbGyy9tMKM0dpc6f5HUe89JGhMPYkeZlGQmhfETc6sks/8WN4XHUwqhcsTI/TjJAUnwCQga/HtgCQab59j+dY0YuA12VnNLhN42Ehk0BM4I7PwKvUH/C+7fli4p8uO4HaGnDDV17csCP9iKyXmW/doPkMsF8V3RzWqJH9E2jmnuFJ1UTSvMmgqVlTXA/ETWt9qgGa/Bx
 BTIL7Fdl
 3jEu/6wZnRPvznHwKu2lRndVObl5+KB4QROGzyhLBSQElZRw4tBu1630LTv4YJA6nxah7uDVf2le4aFAvShnVUSnzvuIvXmC2TQIQkQZ9YfvhH8/7DfAbIg5ko4h3Ws3PR+60sPZ6Y/r3vxFAfufpsfR/euPHt/vPGcbFIprNQJ+IkNDJD21iNUVOdVacHW4LtT2pK2EXuhSpeVDV52m2dlRJ3ZkSM4wS+I0qS6iBeSQNH0Uru79PTjsSH5VlQ0PcMm1D6PvRmFyJW/68OcFn2vNvyRxPtuYjORTWu9Mbb5O3vQNTZ8M8MWO8s2JgbyzUzasd7Fru5DYx80aWs03HxMacmSC5CJlsZ3nO9+aRoeHpdsbROgcT+2arP+arY0sqiekI9d8JbwJDSmNMWFHhCaiWcT1bEm/t5CQgxdG7wsCZUYI=
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
patch link:    https://lore.kernel.org/r/20251220040446.274991-13-houtao%40huaweicloud.com
patch subject: [PATCH 12/13] nvme-pci: introduce cmb_devmap_align module parameter
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20251221/202512210635.b7EdhXBT-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210635.b7EdhXBT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210635.b7EdhXBT-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/nvme/host/pci.c: In function 'nvme_map_cmb':
>> drivers/nvme/host/pci.c:2319:54: error: passing argument 1 of 'pci_p2pdma_max_pagemap_align' makes integer from pointer without a cast [-Wint-conversion]
    2319 |                 align = pci_p2pdma_max_pagemap_align(pdev, bar, size, offset);
         |                                                      ^~~~
         |                                                      |
         |                                                      struct pci_dev *
   In file included from include/linux/blk-mq-dma.h:6,
                    from drivers/nvme/host/pci.c:10:
   include/linux/pci-p2pdma.h:232:67: note: expected 'resource_size_t' {aka 'long long unsigned int'} but argument is of type 'struct pci_dev *'
     232 | static inline size_t pci_p2pdma_max_pagemap_align(resource_size_t start,
         |                                                   ~~~~~~~~~~~~~~~~^~~~~
>> drivers/nvme/host/pci.c:2319:25: error: too many arguments to function 'pci_p2pdma_max_pagemap_align'; expected 3, have 4
    2319 |                 align = pci_p2pdma_max_pagemap_align(pdev, bar, size, offset);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~                  ~~~~~~
   include/linux/pci-p2pdma.h:232:22: note: declared here
     232 | static inline size_t pci_p2pdma_max_pagemap_align(resource_size_t start,
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/pci_p2pdma_max_pagemap_align +2319 drivers/nvme/host/pci.c

  2267	
  2268	static void nvme_map_cmb(struct nvme_dev *dev)
  2269	{
  2270		u64 size, offset;
  2271		resource_size_t bar_size;
  2272		struct pci_dev *pdev = to_pci_dev(dev->dev);
  2273		size_t align;
  2274		int bar;
  2275	
  2276		if (dev->cmb_size)
  2277			return;
  2278	
  2279		if (NVME_CAP_CMBS(dev->ctrl.cap))
  2280			writel(NVME_CMBMSC_CRE, dev->bar + NVME_REG_CMBMSC);
  2281	
  2282		dev->cmbsz = readl(dev->bar + NVME_REG_CMBSZ);
  2283		if (!dev->cmbsz)
  2284			return;
  2285		dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
  2286	
  2287		size = nvme_cmb_size_unit(dev) * nvme_cmb_size(dev);
  2288		offset = nvme_cmb_size_unit(dev) * NVME_CMB_OFST(dev->cmbloc);
  2289		bar = NVME_CMB_BIR(dev->cmbloc);
  2290		bar_size = pci_resource_len(pdev, bar);
  2291	
  2292		if (offset > bar_size)
  2293			return;
  2294	
  2295		/*
  2296		 * Controllers may support a CMB size larger than their BAR, for
  2297		 * example, due to being behind a bridge. Reduce the CMB to the
  2298		 * reported size of the BAR
  2299		 */
  2300		size = min(size, bar_size - offset);
  2301	
  2302		if (!IS_ALIGNED(size, memremap_compat_align()) ||
  2303		    !IS_ALIGNED(pci_resource_start(pdev, bar),
  2304				memremap_compat_align()))
  2305			return;
  2306	
  2307		/*
  2308		 * Tell the controller about the host side address mapping the CMB,
  2309		 * and enable CMB decoding for the NVMe 1.4+ scheme:
  2310		 */
  2311		if (NVME_CAP_CMBS(dev->ctrl.cap)) {
  2312			hi_lo_writeq(NVME_CMBMSC_CRE | NVME_CMBMSC_CMSE |
  2313				     (pci_bus_address(pdev, bar) + offset),
  2314				     dev->bar + NVME_REG_CMBMSC);
  2315		}
  2316	
  2317		align = cmb_devmap_align;
  2318		if (!align)
> 2319			align = pci_p2pdma_max_pagemap_align(pdev, bar, size, offset);
  2320		if (pci_p2pdma_add_resource(pdev, bar, size, align, offset)) {
  2321			dev_warn(dev->ctrl.device,
  2322				 "failed to register the CMB\n");
  2323			hi_lo_writeq(0, dev->bar + NVME_REG_CMBMSC);
  2324			return;
  2325		}
  2326	
  2327		dev->cmb_size = size;
  2328		dev->cmb_use_sqes = use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS);
  2329	
  2330		if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
  2331				(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
  2332			pci_p2pmem_publish(pdev, true);
  2333	}
  2334	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

