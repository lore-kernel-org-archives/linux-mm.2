Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EE1CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007D58E000D; Tue, 16 Sep 2025 01:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB918E0001; Tue, 16 Sep 2025 01:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9F78E000D; Tue, 16 Sep 2025 01:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C78E58E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:45:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 731E313BD1C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:45:58 +0000 (UTC)
X-FDA: 83894027196.15.8F4A016
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id E1C7D1A0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:45:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YK6vRU9L;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758001556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8yKuqUuNi5ZGWeZzyS9p394RXT1XJTenfbwPP5sGok=;
	b=J8dmBnY/zXBfLl35afMY5H1B8TqWFGpcXj3FOtJ9bTJGJ9kybuv/FAmi3VsWp/AU1ZuCaD
	ptqVDkETR1ILEca0oeWzATqpmxSxNXaESzOzLsWhK9h0zE6asBaTYJR8E9gspADq651k6t
	9HcGlelB9hArEA4W4MI4nTMjpGVhUD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758001556; a=rsa-sha256;
	cv=none;
	b=XlbX0E15mKQcxhuG61rmT+PMCD3gzdNdCocx7vw467VFqaBH3cAxJ0hb1G7r5nDtHTuUwS
	Ruiv2RO7vMTvQOg00NXGqYmXKx0Kj4tsa0GfHZLYDnLCqhzRHn6g23IuKIDrwHUgLM2b23
	cXjEvGCt1F87QnX5JBOz7GibxoYIuQ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YK6vRU9L;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758001556; x=1789537556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=St0T9L/irb0uOHmCv7ND5bZ4N+RxY3A5HgQju34FRd4=;
  b=YK6vRU9LpepnWA5u5gPc6sXntPXU1T3WGFCbFOkY4UUhnASacXTa4Oo7
   3q7rvLmJLvIngUshqIF0/+gMhiZ197PADNaVAHCrfw+UzX1W//E3KOu7A
   JTllhXYkTqs1Q7xZ59or7jB2yjT+9iLOcyF6/o7J7saFPO32g+XDsBx6z
   lKAVCnMaC+v+kUr3OWCRjGHEJLvDeozjJTHd0fkCz+/JlHPg5xDSpV4II
   R2eCLfsfgxBKWsIV9WfFyBL6RVfDcDE81dB6jw0VuRFaBJzMIxh/EbICn
   sUqTdmKRctJeJsFZ6u+65vGEibZXJ7aFeTlYuKbbK15/PMB6f2SPEavWh
   g==;
X-CSE-ConnectionGUID: Sclo6L7RTiWWEp6Ageb7+A==
X-CSE-MsgGUID: YsJcvEjDTRKogIn2jVSRrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="63902759"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="63902759"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:45:54 -0700
X-CSE-ConnectionGUID: MlV3610HQl6I+ZtfDRhHmw==
X-CSE-MsgGUID: AV8iiBnCROSuPNFdCkIvjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="178848707"
Received: from lkp-server01.sh.intel.com (HELO 5b01dd97f97c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Sep 2025 22:45:47 -0700
Received: from kbuild by 5b01dd97f97c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyOVc-00011z-20;
	Tue, 16 Sep 2025 05:45:44 +0000
Date: Tue, 16 Sep 2025 13:45:20 +0800
From: kernel test robot <lkp@intel.com>
To: Tariq Toukan <tariqt@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Will Deacon <will@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net-next V2] net/mlx5: Improve write-combining test
 reliability for ARM64 Grace CPUs
Message-ID: <202509161338.Kq88HUjH-lkp@intel.com>
References: <1757925308-614943-1-git-send-email-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1757925308-614943-1-git-send-email-tariqt@nvidia.com>
X-Stat-Signature: gtfhrep98sry1d3k7pkdd3ije9f8p81q
X-Rspamd-Queue-Id: E1C7D1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758001555-345029
X-HE-Meta: U2FsdGVkX1+BAgcCEbGGiYAyab4SaJ3vEnDdKGDxKBGiyQB1dymxFw2zs1jRJe2HXHsMrrsu+VskN8vINAF2h1VSPclQBWIvSXZOsyYdekWiVJDqdwJ5YPw/zmNROnsLkvRwsWpnfeOyPw3oXsu57Y8Hfp5Bc9tQ3AurvSGZ271wXEIgYGm/dy5NMIRZFu+f9jVDhNGLP7zKgO05JWEs+0dEdxcf62ALkmQioEApkvOuwFVvHoLaiotjfNMGiNPrymHE6XFKJ4BjMi/8KZ/35l6c2XbfZ0X5uaUgKKl4sNKFyEDqZ8i0MAodx1ET4FpWGnrhtA9DSI0kdO2/qXJ584sSD4e/9d/YG6GNV1jFl98tcjW0x6OIsGXlqleMEZ/tfd/09yYJ8pKDbLMz/l3fCIw2eedWIydsUUNrilON2XN2iaNCCQUluJgkwCOLBw5QxfzT3tcWy5QpEoAMpdZ/j4nhsemMuos0r5GCUkvsi3VGq8gmoTBXes6H4hV/Slajz+T1kBgT0jk6FqjaXUEGfC5kx8m/43dApV9M1tyPR5WIu6hDrc+CQZd4+/oiDpmIWS9KZoJKpLmclBWYv+/v1geoIOHnzmnxC4t48edN79rLLb1BxsYXIn04ZVh8AOvOg0glMbs7KRaVi89Q0u7eqGU1Zyt9LwMGad24nDFT+ubCvZHmYFNxcFqY1SiWTVKQyOWyCrwlWCSCdD4zpzmpWHzlG8m0BcBKYUMCrb1KfiFNe1djoZ9GxpfrVpmsSqnAPoiRCAlu7JhtF71EICBPGSrenmJ0WL90Vd+ZB2T+JaP7pnSZySMqlzdezf/sbif+w5uBg3K6GXKsMiqXPrM/KwidGWGI+CAa5RliOkGWaUSIxrI7y7Do7vpIQ5Hw187t1gcpWZyLhfh1dmFAa/CmqHdj3NIy/QtBpj36WYymULDyj3XKNokWy7ihnofQc+VIvmlRcWKUSeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tariq,

kernel test robot noticed the following build errors:

[auto build test ERROR on 1f24a240974589ce42f70502ccb3ff3f5189d69a]

url:    https://github.com/intel-lab-lkp/linux/commits/Tariq-Toukan/net-mlx5-Improve-write-combining-test-reliability-for-ARM64-Grace-CPUs/20250915-163901
base:   1f24a240974589ce42f70502ccb3ff3f5189d69a
patch link:    https://lore.kernel.org/r/1757925308-614943-1-git-send-email-tariqt%40nvidia.com
patch subject: [PATCH net-next V2] net/mlx5: Improve write-combining test reliability for ARM64 Grace CPUs
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20250916/202509161338.Kq88HUjH-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250916/202509161338.Kq88HUjH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509161338.Kq88HUjH-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/mellanox/mlx5/core/lib/wc_neon_iowrite64_copy.c:9:3: error: instruction requires: neon
       9 |         ("ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
         |          ^
   <inline asm>:1:2: note: instantiated into assembly here
       1 |         ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [x19]
         |         ^
   drivers/net/ethernet/mellanox/mlx5/core/lib/wc_neon_iowrite64_copy.c:9:48: error: instruction requires: neon
       9 |         ("ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
         |                                                       ^
   <inline asm>:2:2: note: instantiated into assembly here
       2 |         st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [x20]
         |         ^
   2 errors generated.


vim +9 drivers/net/ethernet/mellanox/mlx5/core/lib/wc_neon_iowrite64_copy.c

     5	
     6	void mlx5_wc_neon_iowrite64_copy(void __iomem *to, const void *from)
     7	{
     8		asm volatile
   > 9		("ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

