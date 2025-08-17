Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E50CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 10:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D79D8E003D; Sun, 17 Aug 2025 06:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF3C8E0035; Sun, 17 Aug 2025 06:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC448E003D; Sun, 17 Aug 2025 06:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0508E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 06:16:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B4E14060D
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 10:16:32 +0000 (UTC)
X-FDA: 83785845024.22.428810C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85799160004
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 10:16:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nUqp0oQE;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755425790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wObD4o5Nhuux0JaA4g9bRmof3EsIGbuhXyQwMbkuBZI=;
	b=WPaRAVJTVuNeLuqI3mD+UYtjVEZU84X9MippCqpem1SnX/ezmEsJqTlAoNeQcpMrXrs43H
	vqMUNnP7F9pAkjnt2JpQT01gUz8lLJfJNCgHFI2b9fI0hoWEFof/mN0DT6iYy6JAHUKxtl
	uamf+yH++a9YUz+Ly67PcuZRtCnA838=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755425790; a=rsa-sha256;
	cv=none;
	b=c8wxjMuR6ho841en8oWXhqgDPHFOEv29XZAtmuQYJ59fcoGj6aGbYw0mCqys3wOLn4h6uf
	QiAufsp5eoNHgRBhBImfiYEdDNb/7n3L5h4S4fQkXAExObYThPjbfkjeGRSgAvYjE+yrGA
	siHvIRZ/38VagscQXXfBg6uQiBNojhw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nUqp0oQE;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755425790; x=1786961790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+A14c1W+X+e9ckEeG7fLA+HMWihm8ocOrIT9CAvB0SA=;
  b=nUqp0oQE1a+jbcVeMw2ve1EAoeDqD2WBB/iCZ6ar1MvLMQDsGUuAQTn9
   nkeRxbe8X7BfU+9IYf/5yQVcG5eSND+6tYpba58fk4J3SkP01YrRoxuTs
   SnMApt38nrJL4ubOAD3P3Rg6j6SyHNMtA/owD0x3j4q0YNgfJA9n89v0k
   O6B4AhLiRnKSVWPdyvsMvjV6xEcjcVx9B5GoY7Kcg6vUoPASeR7LpDAtR
   fXnzxvZmawN3P9pNBzFt2wEkJKidQe7BM7yqRGBP3mzaA5+f3MQf/TU71
   abEuinPF8qw79V0+DEiZ06jzzh5b21UsrZYEvIJIL87oxuLw0mCQQeF1D
   g==;
X-CSE-ConnectionGUID: PBO2at+4T4iTcr6Q1AGTRQ==
X-CSE-MsgGUID: OEjwL9biQNyARdZ4eapK1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="61511055"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="61511055"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 03:16:28 -0700
X-CSE-ConnectionGUID: +9d8gx9kSNufnReCk+lhMw==
X-CSE-MsgGUID: krM7rEmbTX6xWVFMAnBwOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="166847320"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 17 Aug 2025 03:16:24 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unaQz-000DT9-0i;
	Sun, 17 Aug 2025 10:16:20 +0000
Date: Sun, 17 Aug 2025 18:15:37 +0800
From: kernel test robot <lkp@intel.com>
To: Huacai Chen <chenhuacai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Message-ID: <202508171758.8m5jQYdz-lkp@intel.com>
References: <20250817083534.2398601-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250817083534.2398601-1-chenhuacai@loongson.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 85799160004
X-Stat-Signature: prkqdz9huwu8kap7hnoe8bkii1bafb8c
X-HE-Tag: 1755425789-760463
X-HE-Meta: U2FsdGVkX1+bSus3lvDah/XwMFdU04u/cGdmmDX+Qs1oEBEGOOGfnnS08qeFDsGkAifPyghOsay+UsfmoDebywaplY4wXDyoKNDWre/cVZOsmSeK8AQ4WIkHcJADLFtS29H1Gvt2oBykY/usP2X78xBu5JMdAaJRo9H4TbBVe6DRo7dX/VtCkDtLVRnioNNCitJ/VKjCeSC97DfRZs+Oeh7N6S2C2W8yOGXkZYArsV9pYgGZA5DL6W1obaRutTdzh0jYGiAN53iZtS+ZnT11UeiyXWEp1CWg37SoPzQ39qKBn1jIGHhl2StypxrIXv+RkgfDg3kLtmL1NTmFMrEAxdBjcrrz3Ou7YBPmV9ZINAXXDWYCJdTtenvYUIzhzplgWa3TAbk9D3V/3so7P7o8Nr1VwaQy6cXbpwz7P0ehAQLIKBhObZNXGgnIE2xesggk8wjniNfTbiyTe6ory558fGfMshW8SoFn2XlLBW3kXW7FWsU223nS390k7e9LzMrxpMsCiFFjfFvLSZtCAbeoFmZqKbGqsxzUpPH2ETThzb6CmmJHHaCLJuEP+sM/xx0shE5MzphX0+0ta7RUmHFv0L8doVgZp5m2IxH8h577DlPcenUX/j5luEKvDu0ekXQ4wMXWVhdLm0wkUjXdwritUxjEseAaSdSZxbKtZn1gO/iGDRxbiYaGr95Ak9zUc8JuP9s2YRVyCWf+zhKwnzJd+365eadW86DL8ObXgr8+nqfXkhx5TkqkpB9r41Y4VY5r4gwi6r8UW8xPkF2kaazN7feNQhqIY4H5YTznV9W7SgyL9YCRGI4Vb2nW796TQXE7sBjOR05OEExDMAubGKYEKcSsX3rMG3KjeZVq3ro59A0UzLtw7+MIB43Mu1qpZqBABaDTdid0SmnkpArQ/xZ6MZorLqLBcnO8WHIp2N8os+w4M4naKt+LR+FP0cPAyQdxxkhdGdeld0/8DwZ+yMx
 FYb/eLvT
 Rzo5XpBqwhPwSoH7V+IxZVGPR8OqWhu7lha4UeQdjI8JoKirw30n6k5TLtWuYHnXFzSYfwmKjuFF7vsYbrkFQJdtHdB3x9upCm1hYwHKB3yPDlzPjo1EG21aF/WBPs+Is7bumk/EZZF3naroxjOmpGvALWBFDTKPkG5DUKhDWPPP8J1G3UV3kfGalqSccRFYO6HY9CUwR0djYHZ2oEdOy2eHlf3aCw0NJStfl3BYvZo3OjrhcE60/T7ccgIqNHl4eA+GfPguR1EUzb3E9Ohk2wuhKOMvR9npyP2OA6LuAK78q8Enqr+uDnem7vUb3H6wf4u2DmvgRsPoQqULKf+aq33k7GirzjVVAWCQURpt9+BdcLlE0uZnV8YJggQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Huacai-Chen/mm-migrate-Fix-NULL-movable_ops-if-CONFIG_ZSMALLOC-m/20250817-163814
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250817083534.2398601-1-chenhuacai%40loongson.cn
patch subject: [PATCH V3] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
config: x86_64-buildonly-randconfig-002-20250817 (https://download.01.org/0day-ci/archive/20250817/202508171758.8m5jQYdz-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250817/202508171758.8m5jQYdz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508171758.8m5jQYdz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/zsmalloc.c: In function 'zs_init':
>> mm/zsmalloc.c:2249:13: warning: unused variable 'rc' [-Wunused-variable]
    2249 |         int rc;
         |             ^~


vim +/rc +2249 mm/zsmalloc.c

  2246	
  2247	static int __init zs_init(void)
  2248	{
> 2249		int rc;
  2250	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

