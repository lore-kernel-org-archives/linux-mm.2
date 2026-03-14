Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8816107BCFE
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 07:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30B06B0088; Sat, 14 Mar 2026 03:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDEE46B0089; Sat, 14 Mar 2026 03:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0676B008A; Sat, 14 Mar 2026 03:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4346B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 03:58:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 516AFBB918
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:58:26 +0000 (UTC)
X-FDA: 84543916212.13.4A54744
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id D12BB100002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:58:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hcgplQkD;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773475104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qkfgDGS9LvyVw/w2IDp6Q5SFMrD8p4r5M/1wXoq7Is=;
	b=HfM1yKVVaZxPzGkoqI+GE4XRGN09uSU+7rgf0r9lVnWPrxZdAhgcjOBsGiRYd1CGJjCRp3
	zf9KL1/Qf0KMI4tFDTXCzsy+27hLQrc2mL3vprALcjbB0ZEATXU2CdWT2j6RSPdm/j+5IB
	AX6SSadqG6hTFhnahFEhB4yrLD4+02Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hcgplQkD;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773475104; a=rsa-sha256;
	cv=none;
	b=mUpWKox0zERI1Ju6nlN4S84cJoXy75OAqf5BSmtmezdZeZmGQ23xTKxijoHVFuZ8dh4L8/
	TnT+Ne1xi3LL3J0YyvE8aA5Gjpd6t48MG1lUc7wMEn2rd8zXVHNKsaT/qECzjq8xqlxCeW
	x/Kxf+lqC4jCLcK6cUFVmz74VICjC5g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773475104; x=1805011104;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/4mO55ZscN1eFQLHdQLwOS7Gxe9h8uCnujezTmQwxyE=;
  b=hcgplQkDpQioLzc5ku90MwsVo4Qs7fnS9NFGZGa/MBDsFR/1zimno86c
   TkP7oQLwDtw2i1+onApYrkWOT+hmKkP2W1FvIE5vvfWbUeCPimx7OepVX
   HzHCiqISsR+Z99kte8+snGaIatuD+ZTuduB+sIUTYH05pAoLPWdRrP20G
   mnOcQbtsckhM531sAa321suwXarMPEQBy+a3dmbxg/gZq9zkdjQCwMgN5
   6AFJTEtR40/kPSE6r5W1/aY7MeBvOETd6DNxYifBj7pupAjXZLhieBKy5
   nhAlyG8kDVW8A7QN0/4KvCYFOvSzlx9b42nQqIfKVnA6WT+YGoOfJ5tNG
   Q==;
X-CSE-ConnectionGUID: ytXeYVn1QGW63Ym0IQUALw==
X-CSE-MsgGUID: KiLdwrIFSXmv4amhjmcCyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="62140692"
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="62140692"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2026 00:58:22 -0700
X-CSE-ConnectionGUID: XV8nd9QKRpqyf1cdyxEXxQ==
X-CSE-MsgGUID: K3AoNwyMRBOBlrzhjAovxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,119,1770624000"; 
   d="scan'208";a="218691536"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 14 Mar 2026 00:58:20 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w1Jt3-000000003ld-2H34;
	Sat, 14 Mar 2026 07:58:17 +0000
Date: Sat, 14 Mar 2026 08:57:54 +0100
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
Message-ID: <202603140843.vdpZ0bgs-lkp@intel.com>
References: <20260313150802.1121442-8-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313150802.1121442-8-m.szyprowski@samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D12BB100002
X-Rspamd-Server: rspam08
X-Stat-Signature: 78e8eqeohxj9aknnfehmfg6g9rm77m84
X-HE-Tag: 1773475103-194781
X-HE-Meta: U2FsdGVkX1/rv7oVaeJJTcyNeRXSO3qU1UpIDlA+tSZZOg5LJWVLljouk9UJr+xTjfu0zJwxXZDtLJiKbS5OoteDCfWloAvNPTcrv2CQUAErLPvmBzTIDWYutAZLqJnSigWsCmmVNZvbsrXBSdttAEN0hefRW1fiEQFO2yIh2T6Uweqs5ItTsd9xbnc9JVg17JfwFVyNeJTg/P6+kGFSKgQP18vA9Sc/XDyEENiGpMTORvBSEHRR5KTQ67CP2xPfxB4VSQP8yfbSe9N/AJtH2Uv6rM3qRuB7ITMiWFgY27qR1lUeIC3riQzceer47MCJcJnPaN05iz4ymPTSjBnRWiprlW3QZO4n1bQtkJDkBtrvI2Yh+eX9XonZGrIV2RaIrOYQswgTbKTojyGYmJYJ8AusDuuGeWZw9I6BFIF80/ok8LDyqy9ix+RuT0lplLosLZPanjj6JpnGEQKWACUpBfCVsZ30uxFnRoIu3NVsCsfI7v1Ptkz8vSnD17NLC303UjEphFJgfgEXj7X1OOyleRXIKWU00p2JOziolW6RJUjDRSV+qaV5bJ36DXzOeEcG0fHKVPQspw3vuT89cyEsoJZN9jAjgRUDLDxca71HQpq1oH67pzmsCqlU9v6xnlTKI+WkA3GnJfi4r4f5vQEsGSbd7zXXRYUhT8JbG6kubSYtqPQMV0gpioaTm58jj8ukclL3z/dR0PN9Gr09ASbyB0N/KGKZOKx1okyRW79zG5dAxUYTedpFGk4Vlr4opCkkpa6ixegTHx9ZFaMpLNL3IV+sTVWWtyaewZ5Hzc5vXtDzI6on8cAJlac4FUg6J/FOk/NpnRbnS0dufXcTC3wpenjI/1d+N/Fq7O0qiw6zPISykvZh/ZDaMvwXLbU+bhlR3u15MmSPFsfEGBGCtfnamHrMtRidb7X/EA8z3Ug0lao1ru19SK+6akKetzprTi7obZL27wLZHXB6bmXTQ9y
 hGbZXAn4
 4bJq95Ka2Gu8Fe/Vv+6EY5LQt68+dNqMj/td5X9Ww3AnMSTLGIfRlfDC8fzOlwegGcXXY6o+uxwfgzA0kWPYJ4IsC8CG+hKD+nQUk+l8ojyMA1cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marek,

kernel test robot noticed the following build warnings:

[auto build test WARNING on robh/for-next]
[also build test WARNING on akpm-mm/mm-everything next-20260313]
[cannot apply to tegra/for-next linus/master v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marek-Szyprowski/of-reserved_mem-remove-fdt-node-from-the-structure/20260314-023123
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20260313150802.1121442-8-m.szyprowski%40samsung.com
patch subject: [PATCH 7/7] of: reserved_mem: rework fdt_init_reserved_mem_node()
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20260314/202603140843.vdpZ0bgs-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260314/202603140843.vdpZ0bgs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603140843.vdpZ0bgs-lkp@intel.com/

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

