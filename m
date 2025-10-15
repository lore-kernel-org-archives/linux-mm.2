Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEB4FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 04:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3511D8E0012; Wed, 15 Oct 2025 00:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329848E0005; Wed, 15 Oct 2025 00:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265E68E0012; Wed, 15 Oct 2025 00:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15D0A8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:02:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD27747AC6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:02:46 +0000 (UTC)
X-FDA: 83999002332.08.41326DC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id 911851C000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:02:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LfNDFY7k;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760500964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfucgX8ssmEAuSCdZ/Lp7P4GlVmuSbno7gcO+6splP8=;
	b=YeX4Fi87+jN+INsGW0/AQ3WT4VSKPsx39mP+4etnaJ9x2WvvzCvpV9VFr/HkFBb8QU7JPK
	FMCXu8tZ8ZS2wcN0YaP4MYT5MNWy/zWW4Vka+Tu8wmnfN0gK6y+lOnPsz9+nvogBUkWS8i
	713c/sKbFnbcBtwUx7xmYM7RWr0Pq8c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LfNDFY7k;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760500964; a=rsa-sha256;
	cv=none;
	b=7P3gZJgMJFZUATDzWhNtFpuCCam3QGHW/3nADDRBHF5lS3I++KdX9g6OTA2hhNfEtaKdn2
	tbi3uyscV5dTljj4BdJAmSSQbKU3guyI/4+9zGNSCDWQ6rK+N10zJoWn3vCWK/OhMMjxUP
	VMDbVez3s7TvlVzhThr23byX2L1ZtAo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760500964; x=1792036964;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IPYoc3DHk1NL/YolvyR0cWS69iUjEEZ5j0JF14Po0+4=;
  b=LfNDFY7k620FmB66lX03y/IdjLx7lvRoizhO21aQsjU+v4JpcBPJo1Nh
   nzBeSoXdwrgOKDK7snC2gh7cYHsih67GnX2v08jJNtipszbXQatCOLNay
   BgTMX1v+YTP0nTYn9DuDvJ3UyJSqX5CLvdDoZ5eY13HJfRmjINKc0JF1P
   t+7kh22Pf2qYX5l5KZz1N+LFgMT7d4AbsHnZhbQtYVxranylyGcnDeGEo
   PfwzVLd+Dql96wzwBPN5uIC/rYgObV5xJwK3+EEWlvm9z9P+AEcoHdxqN
   rjsc3AT8Qg8S9d+sO2fbeZGBNQwLJcx99WSn11fiD3g/1b1cJ+WMOIx4d
   w==;
X-CSE-ConnectionGUID: GHaujZfTQ7uWXLXXUgW49g==
X-CSE-MsgGUID: kzs9NfUpR82D43vYpKD+PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="66318626"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="66318626"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 21:02:43 -0700
X-CSE-ConnectionGUID: NvEnqguAR3Kd7fzemWuaVg==
X-CSE-MsgGUID: CSuUhS57SgWXI2/is1sSHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="181733557"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 14 Oct 2025 21:02:40 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8shN-0003QH-2q;
	Wed, 15 Oct 2025 04:01:40 +0000
Date: Wed, 15 Oct 2025 11:53:45 +0800
From: kernel test robot <lkp@intel.com>
To: Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Donet Tom <donettom@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] drivers/base/node: Fold register_node() into
 register_one_node()
Message-ID: <202510151130.JYajIJuM-lkp@intel.com>
References: <910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com>
X-Stat-Signature: gcwyzkre1knt9mwf1pt1s5zj534hadur
X-Rspamd-Queue-Id: 911851C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760500964-742933
X-HE-Meta: U2FsdGVkX1+Yx9Ik9As9x5GtgZcBRUBkzqvRyglAbMwVaIM/l20P5ok/nHmHch9cSJ5YB/DE6u5NFCKUf2sgkbi98krvx/ZgSbIsxeQGdfTKipAP+VkfkB/nTaIKla9v1XM7plmKwwrJH5DuIhD3JeRp/ihkZzcZi9t4mE9XfZ8aLzHbO1sZudvs0hK5MWNvzxJ2nkdvtzUISSny8SeL6pHyvCV0X/+QTasal4MrcFVFwdhtuD2Gi9JVKmi9zUCUK67pj1sYG+fDFSXG94S+BFuS0EFCfwtcewoCLwMxLCL+UWajIltid6YTXSYkNuKRxT3LUVqEgSsIxxN9jJcp5gk0E5yJYtuf9luTgRDlyrTpB+e9ft4J+Et+It4s+e8mNXeF0NGMBLeucQHABnAalVn2leXosZHKZLOzT4i96dJJSqh4q6FEQleLaXtBYSdVJ/fc9jCqUajVoXQ/JHqDKarjCfUZP0Tei5em3vdWyRp8rv7B9rNBkgS00rndgCsYc8VAcyFl4BFqQq+7q7wpsDd4wJ/DJpa+bmGXhMJESunfc+ejoC/m6b9+B/ISU5jj6a0jFDTRbB03bxM2Dsgf2S0gJIBu4bmPbk0fEJl5Zh4uwHIxxOruVQce0rPpOZ85vYAulJQEqL8Uhaca/zEo59TY+nKpl8pYP+kXZpkzKyF4PfGPPWUX/MBwD3OK1mvBAMIkOa1+ULR7OwO0dPod8hRdMStl3gAgcbjKTisxdTZBcddWE5Afq1XguADDBi0DtRdRDb5RnKAkVtnmregLkygzajy/HxSE9Ryg52Bga3wLFVYMgHJrG2xiuHkdirqT63MFKCyHodjHJi9w/zWTfzHq2u41pyZ89Z4+FAE9rozCY6NRUUBdEmJk6shJAtVG1EaPQkQq7l1mW0OS3kDJ3eLRf1NIalLBXKpO31DzDDulimc76y4CFoSOjhzZtzkHc34U2X85lHHq6Sk9L9X
 CI38Excd
 hdjzOnUn0Lo1JwrUtVtkpzeMclrCO+6KF7AdnTkzDrEANDLPWYUz2AzE5Ru3qUoeZv56+DVelp67+Wqst80H5SyA3ZA9E8iUMDXOUmB8ScnTxR+MXGUhDLyE1sBGMAmZ1LG7Q6uZTIocSloXrtKJJ6O2XoliuAE/PnU+ZxtlDHpr6qGuon8VJiBKEK8O3sKwD2tK/jtr7ELn8PW7mLD+9CEar/Y3B68grpXIOzc3JxxuwykMKKjE9WEep2Q6nwrptjftyD3GbjcXfQqMtJ1RpLCA8fHvUcXXQSseuAbDnFXa1z6jyDuHFziSyUk8YaIc1no/uPxEvMAZVwJQ8mjoRbKYmImCVz+9T0nSQzKrYypLYnznQV6UccDMPs3Pie+7IxvtfEv5YoFYhcBr5aDZr/0fytVr5I1U1LfUX2fpYehZjQknlho5M0/h37TsaNmxq80xS5NMrZkwrAMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Donet,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on powerpc/fixes linus/master v6.18-rc1 next-20251014]
[cannot apply to driver-core/driver-core-testing driver-core/driver-core-next driver-core/driver-core-linus powerpc/next tip/x86/mm rppt-memblock/for-next rppt-memblock/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Donet-Tom/drivers-base-node-Fold-register_node-into-register_one_node/20251015-000850
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom%40linux.ibm.com
patch subject: [PATCH v2 1/2] drivers/base/node: Fold register_node() into register_one_node()
config: s390-randconfig-001-20251015 (https://download.01.org/0day-ci/archive/20251015/202510151130.JYajIJuM-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151130.JYajIJuM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151130.JYajIJuM-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/base/node.c:889 function parameter 'nid' not described in 'register_node'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

