Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B024AD1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0096B6B002B; Wed, 26 Nov 2025 13:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC7A6B00A3; Wed, 26 Nov 2025 13:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39C26B00A4; Wed, 26 Nov 2025 13:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D33696B002B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:12:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92B221A0384
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:12:26 +0000 (UTC)
X-FDA: 84153553092.07.CEE16F3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id DC9BD1A0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:12:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JRvuNpsp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PtTLvNlAPzTCtZxbx8TJAu/vmykgjh28xl3qQUk4Bw4=;
	b=UOaPGp3ncnd2t7eXJr3NCj37/oNFN1ytHalav3u+PzsxRAg1Lr15Lv8e9uxchebFrBTsQW
	GEVvGQK8rftQ2T+O0MQwEoyvWjEOJsX+4KeVn741xLsAeF0CEftn6Xcqj2OAkNy2npXHft
	bircyzEhMmGhTS+z6TswFQAnJoQz/Ec=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JRvuNpsp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764180744; a=rsa-sha256;
	cv=none;
	b=kBxC5Qj4L10PUPNRLKtm0Pa8hlQ44UrXMYWQWqKCXxKSD87eV6udqJqMwsuzAN26zgIUBd
	iBfGiRm9CyM88eXanPhi21BSP7gSWBpHLGaDc7839rc+FEPA3bX91RZBj/VSG0VTi09eTK
	j/UCgDQIChrGCTA3p0pvsi/l0rWmvcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764180744; x=1795716744;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7wuZeNb8w/wyJaRkL/QbSho/BhSlScXyL2qk+Uj1ZnY=;
  b=JRvuNpsptM5R3sJFvnB9ZU657K4fHNjpGNlHo8loDxoZCjQOeRn3iOBa
   5iQUtH0R+vYOzr9rY4xSedmkcWaRKZFQ8+1wA05KgnXPdFxeajfz0lkzi
   ohozi3IGykYrmMP5qAj9ds6feETo+c0i4CXZnBk3La/zgaTn09M0ePJQX
   TKM7C51+EcvDhiQux0/E8PxFq+2Wz8aE27dqa4qvzXFgIlvqJ/qp58XBC
   zo3Ofj+ncFG+G/VZlMJ848v/BS6tH4v2iE0id6ogEKko4pWC+Q492GE0N
   z0YFN8R8c0cgOJ76tYety35K5+/WEsdfp9kVvs1beukX4OKZWIPMm8Xzq
   A==;
X-CSE-ConnectionGUID: xZJNx9d+QRGTpH9Ilx2LFg==
X-CSE-MsgGUID: f3EGN0wrR+aDw31qx0YIxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76551022"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76551022"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 10:12:22 -0800
X-CSE-ConnectionGUID: Hsw28dizQ1C60gb4XIxcxA==
X-CSE-MsgGUID: /32RU1tKThuB+w3kpKZFrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="192818390"
Received: from igk-lkp-server01.igk.intel.com (HELO 1f7de368ad0d) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 26 Nov 2025 10:12:22 -0800
Received: from kbuild by 1f7de368ad0d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOK02-000000001Hz-25iw;
	Wed, 26 Nov 2025 18:12:18 +0000
Date: Wed, 26 Nov 2025 19:12:12 +0100
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>, linux-doc@vger.kernel.org
Subject: [linux-next:master 11827/12060] htmldocs:
 Documentation/driver-api/hw-recoverable-errors.rst: WARNING: document isn't
 included in any toctree [toc.not_included]
Message-ID: <202511261943.PGqXohrz-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: DC9BD1A0008
X-Rspamd-Server: rspam02
X-Stat-Signature: pio3orx8dco4nknkaw4mrucgsgjdizon
X-Rspam-User: 
X-HE-Tag: 1764180743-912718
X-HE-Meta: U2FsdGVkX1+ePTGJW7HYVG0a8C/3KK0llfYkRQEvYh9Dljpt8utjXiMIRFK9wvuNq0jkFPQ26Wbs8ZhHjxa4LyDXLjKBh/rntNR+qTfTb8U1ozeiTetre5nMDTSduHAaqNHzLYhXkeuNG/TR0qKwG8qrDTrmuif2d4M11Qq321r+q0mGPlhmnLeeZew3abBmmjVrpMRdlQ7S4weXWh0SSdz19lNOBaqC0p7bGSqDe9uH6U6lpT5KbkJ+FBxQjkxGcd5GCLOTjEC10rCGejewPSLaI/MxvwYvs/p+l93b4G9yz7O9IqD58itkdGVq2GLrW6VIo7zvC5qI6IVPxRbTiTpbnVooZE71U5pWI01nEVqtUZhQ8MmHy5YOpo3tA8Gw8gBOPES9YsLJzWl/l70cI9z/9DDH3SbPbvmkTp4JI9iU0dFf5EdYA0ndw9SYRyhWn73Bv5jkNlHmQoItGapfZHNlhuvLGzMQPYl9DcXw7pCq2Qcv16XUewdH/OfQLq9iAF30fUr2Yms7v7ORY2VTUZLCpQYe5SiuphCLUL824CKhzOGm1ZK+1POmZvTqjwd7pbJmNxhSkHvO8gJka0azv+TvZ7C7fy/X5XXw0QlXb5iCXyIChVgQ6RuLvTheGMth4XBEuXFEf/pUQ6YGBEVAUDVMOBn5TZdWHqyxzbfbSdMtWWjQ807kxa0eHVt1YSutBULMUPOXASkTeUmJe8qleAEBmY+ZATYXp/CMK9g4PxOGg0PnNzy0yNVdqszJRusSt1YyobsSgLhpJULAt3IIiodyndKi4FVUE3UScrPqGyc272Eun/1QOSIEMVgLWQBaTqK1Od+NGebJupOBBE3x+sODU/kQxyfh9bG8SV0A/xDWBqGTD4gH9Te/t0hsG0tzMgwBdSHUm+yM5OA3MR1VfROUS3gV7znuw+GGUI0Cvf41exKjCZ16GzvaPjVlog0o3fpuhghxZC6Lfl7KJ9D
 G11XBBux
 fSPraukl4eNgFuKD/m6qkJBOcgVpMmJSk1laJmgP2PWcBnJ/aA9N2zdbRd6Q5/rUd0jWiA7GIT6HObMNfb8zVNo/zVTmCKm5pFOC4ahhndaTBCvq+aXK3LOlJR60GV8b2Nh2W0g+LEPyyvO/BRbMyeii2TcFmYkdW7xVEfOx7tK0xIhwQMriYu4xXis6FV31Z4gJ0uul/XBtX1xfVBlwOGC/7NCELuaYdPTAo1XZJIW1c0BAsl8uD/AJt+F9Z4FVuL+swFbNUzsPgCzF5KMzuu++fTpO7H6QlULfevjGVmgSxBT9Zh2dRSdTsnMmsrrua8zbWp8dTCGlEgcSCiFmAFmqUm2t3JKpCl5YzAGFRAr0JTz6gqOderesu3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   663d0d1af3faefe673cabf4b6b077149a87ad71f
commit: c03fb5253a0341ef7721ef107a89768a073b945a [11827/12060] vmcoreinfo: track and log recoverable hardware errors
reproduce: (https://download.01.org/0day-ci/archive/20251126/202511261943.PGqXohrz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511261943.PGqXohrz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   ERROR: Cannot find file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/mutex.h
   WARNING: No kernel-doc for file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/fwctl.h
   WARNING: No kernel-doc for file ./include/linux/fwctl.h
>> Documentation/driver-api/hw-recoverable-errors.rst: WARNING: document isn't included in any toctree [toc.not_included]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

