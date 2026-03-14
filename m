Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954F610706E4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84F76B0088; Sat, 14 Mar 2026 11:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32B06B0089; Sat, 14 Mar 2026 11:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E8D6B008A; Sat, 14 Mar 2026 11:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5946B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:20:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14FECC2770
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:20:53 +0000 (UTC)
X-FDA: 84545031186.14.0B9C3BD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5EBCA1A0002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:20:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lblmDcB+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhFWh13at5VNx0PZXoI3U71AUi3i/b82a0dMiFfr0yk=;
	b=lDbPaCUpHNHkpnU1f7Khg0Shci0hezZgy6MOLDKoUX7MhlylZnS7pE/wder5fmH5KgXsf0
	5ywPdn63mtMWjPTLe8sWVHc6mLu3mJSuaUFET7D0NNNl1g1qbvqYzRHMOKHanN+EfMYDd8
	wYlOQGzZz5YVLYTEfGw+v+rJLXpR3q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501651; a=rsa-sha256;
	cv=none;
	b=QYKoG85SP8a6TgRifz0euf5MbHPep+NI3SraWP5cV5lBO62sJGv5lkUjT8zyLds/X4HyBd
	YiYW6Av7TKb8LwfRsWxzEIKMOkmuKQLFj6HTVHfNEc1PbYHuyMNdANgkjhqhca5ql8bbCY
	hpP8iTKi7jdREXTpmFc/uX4xvXZmzJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lblmDcB+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773501650; x=1805037650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1FtGcHaPzohD23/qb3jPURbq6HHqLOzLRiH5ow2x+iE=;
  b=lblmDcB+30u2laq9jQJaA2FlfZvHTrpWIjG14pVTcEdxscqk+kTQ4uKU
   8E5QDjHWmz8GHYsLocPMsPcJwll7oS0XX23QO8ieg0NLRzaB+7apFirad
   JktIxTz4j9zsRrH1RUmPUcWkQy0Q7O9Pxv4t36uUfoOvsiEZAcVClSOJN
   G8NxORi57RH9+zjU+NWOv/xC9kEizTlrHzesgyyM4m1dw3f+0q2O1wVqs
   x6cRpJ+Qaw1uHUulgOlROo9hiJnM3E3tueqx1RLt0Pksy86qUzqZ2Wwt1
   24o4LvDXrPColbuh6IQDkPX9HBosHs6awQVC9c9BjTQXg8Y75FlKz/0zU
   w==;
X-CSE-ConnectionGUID: OCoPOb8VQ0aVoL8uz/M9sA==
X-CSE-MsgGUID: 8rS/ASOFTjmAaoK9A5isUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11729"; a="78476193"
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="78476193"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2026 08:20:48 -0700
X-CSE-ConnectionGUID: qNbf0hHhQhu2DsmAtre4nA==
X-CSE-MsgGUID: RSSzsBKMTTmMexgmUNZJ8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="221663544"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 14 Mar 2026 08:20:45 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w1QnC-000000005I7-1ruy;
	Sat, 14 Mar 2026 15:20:42 +0000
Date: Sat, 14 Mar 2026 23:20:22 +0800
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
Subject: Re: [PATCH 3/7] of: reserved_mem: switch to ops based OF_DECLARE()
Message-ID: <202603142347.aops46Bf-lkp@intel.com>
References: <20260313150802.1121442-4-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150802.1121442-4-m.szyprowski@samsung.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5EBCA1A0002
X-Stat-Signature: spse6cjh7p1ro4kpzufyn6waeir8uas6
X-Rspam-User: 
X-HE-Tag: 1773501650-354610
X-HE-Meta: U2FsdGVkX18eIE87fH8povKvJMHcPc053VD7ZhzGsksLuNrLZZhhObEHl4QcOO5xzNutswci38NDR2qsYOTVV2xFhgsEDIW9Gz3fzduEHJtmLiRfhK9q5gP+pQgly5GD5laxbSqlG0zG2XJ1UbPA9kqvELnv8ghYS/AzqWn02apCBxBHyYgn/P3ZPV4TNm9YpMg1+LmrHJNnI76LRc6eIivGDTkkI9oRvH2Q8dF5/nbANqC6VgRB8wc3AhxT1zFfGnLXXC/U+cPoRBT9Rpf4oefv06ssDK7PD9uoLVwSwp6jM8QQo2oyhZEytBZ3fYshaKpBRCNP7lXXt+QrHMX4pWeqKFmC15KZrPUcZ+NiMBr3GxQG1cMwdMlU1ez/CKL5Ceuwf4bd05BJfdE5oRzm0qvIeMI83NB1zxoCejPAp6YlV8B3E/2AzRbyGm1ilGf6Qr+Z2l9M3CcrpkWsut5yLWPiNSdTXYYvLaB3LTdfY58hKE0FiBqKmr/DyViL8kIoOV8aMMV3mQ4d4h/X/87NL6tdUC8AXqNtRZLJcwBar6hdrr8HBc1AndmKNqh6ykQvn7uGBl9G11XGCQHGRN85Q08yZmNcn0MiTdXrPGw8LRk5rWDuGb7EqryWKpc7rhUV2iAueOgRSvP7SH9mCPfyZBks7puV1KUNznCbFc9Md2yGnIimWHNtr4mNz7narjGOFTSON+mBDWw/wcU+QO76S7pMKIOxmvh4IwoXPh4Ut6rlMRBbrOJ+0D5tQNbx9UrNA0CvxqcbYg272z3huXR198+fXXI4uKYtaqYXA0Dr/ZcApswLwUwP/I9z6SoMWGFtVTV4E6U6Kn2vynXXydL2oyd9vYsP7bseaYXe++Ov4CxDpfd0h6+s3DHs/DhJAT/iSU2QKY70bOxM9pJzED+VatWZ56McrD3KiA/2niYlSMfuWqAGvq5YvWQ40sukYDLOa/MUr6s6BJ6ZhTZbEf8
 Kht7LaVO
 MQzvClJthMurs/1ToHFhUH4GPhqFV+XLOmqLUp9NISN7LnG4E/P487/+ZEcAjlyvmvNYeyHXAdupb/9QgP8KasGDDM4uIpyYlVoMKWu8kH7yUSlxzNdRSmmdIZAvoOkjb9KlsZovf7ZWnTQLsZaDIEP0m7A7L9l3tLzczD0XdQKd6I+OBHq7itsMNSPUpkup961sGBRAg8agcRYJf8MeKMVpClBoYW53NJfCDvUmL16ZR7PgBa24YlzYn+dOWNxsHUqNJaZJ0PTLw/LeYeaPTSCnZcHDyV3pwDy93UQP1aS7XITqygY57wOHa/vN4C5pCEVQvuGPYDltiNABeJrKaxV7smvdO6xnc0S2aLiIcJkM7qLDvaFzM74oJhPsCwLbmR5O6GKD58ezTDVbQfOHjZ3sgW7eDU4xX5ovfl/gfbN6NO40pExRux185ptqqc8eRuXnlS+a7bGr8xLzkqG5UcSno6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marek,

kernel test robot noticed the following build errors:

[auto build test ERROR on robh/for-next]
[also build test ERROR on tegra/for-next akpm-mm/mm-everything linus/master v7.0-rc3 next-20260311]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marek-Szyprowski/of-reserved_mem-remove-fdt-node-from-the-structure/20260314-023123
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20260313150802.1121442-4-m.szyprowski%40samsung.com
patch subject: [PATCH 3/7] of: reserved_mem: switch to ops based OF_DECLARE()
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260314/202603142347.aops46Bf-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260314/202603142347.aops46Bf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603142347.aops46Bf-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/memory/tegra/tegra210-emc-table.c: In function 'tegra210_emc_table_init':
>> drivers/memory/tegra/tegra210-emc-table.c:79:22: error: 'tegra210_emc_table_ops' undeclared (first use in this function); did you mean 'tegra210_emc_table_init'?
      79 |         rmem->ops = &tegra210_emc_table_ops;
         |                      ^~~~~~~~~~~~~~~~~~~~~~
         |                      tegra210_emc_table_init
   drivers/memory/tegra/tegra210-emc-table.c:79:22: note: each undeclared identifier is reported only once for each function it appears in


vim +79 drivers/memory/tegra/tegra210-emc-table.c

10de21148f7d28 Joseph Lo        2019-05-29  72  
6888259214366b Marek Szyprowski 2026-03-13  73  static int tegra210_emc_table_init(unsigned long node,
6888259214366b Marek Szyprowski 2026-03-13  74  				   struct reserved_mem *rmem)
10de21148f7d28 Joseph Lo        2019-05-29  75  {
10de21148f7d28 Joseph Lo        2019-05-29  76  	pr_debug("Tegra210 EMC table at %pa, size %lu bytes\n", &rmem->base,
10de21148f7d28 Joseph Lo        2019-05-29  77  		 (unsigned long)rmem->size);
10de21148f7d28 Joseph Lo        2019-05-29  78  
10de21148f7d28 Joseph Lo        2019-05-29 @79  	rmem->ops = &tegra210_emc_table_ops;
10de21148f7d28 Joseph Lo        2019-05-29  80  
10de21148f7d28 Joseph Lo        2019-05-29  81  	return 0;
10de21148f7d28 Joseph Lo        2019-05-29  82  }
f954eaa20bd915 Marek Szyprowski 2026-03-13  83  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

