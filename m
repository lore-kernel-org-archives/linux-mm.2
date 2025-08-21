Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C55CCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA276B0093; Thu, 21 Aug 2025 05:43:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B1D6B0095; Thu, 21 Aug 2025 05:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A981B6B0096; Thu, 21 Aug 2025 05:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9893A6B0093
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:43:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 463FD117519
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:43:52 +0000 (UTC)
X-FDA: 83800277904.12.A731D0F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 48B56140004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:43:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FA8ATTGH;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755769430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yYKb2bEANcTcTfN3dgDIVDbVG1UYQAMc9uu6bSA0Lps=;
	b=th1iLDNdfwf6BHm0eyn0HTyF+z/dGw9XJzGVlsjDKGx5DYNNEvK4SRdl4D1R83zN4Q9B4l
	xh8Gx/Rb7yhqzgTepNxk11CK0uQfT71jgIgdVQ5fK0so2Aka5IPI5dHPGoC21F8n5TI3yZ
	saH35jEvKUi26Gb703xUNgK70K0uMTA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FA8ATTGH;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755769430; a=rsa-sha256;
	cv=none;
	b=dCZs/sL+lg0eyxZr0dhhyYOLzyTU+CM8bSCNrvwFN2fgesKbGbWhUTuUrPL/ofThITTLvU
	j8n00owP739RjIBSrE1lbXOYHxF2ZNstdAjeWvVdh9zrBPJa2AROf0ewT2s5XwYEPBskYV
	B002yJheNfs76SW0Fh8OmeoXWfFqAFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755769429; x=1787305429;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Yi4yP/dAKMQb71ykPMOVkOyUJGGCArjcYWUGLnnS7qQ=;
  b=FA8ATTGHyFibcMvzlfEylPQYz5IHcQ9YH1qfKYh0WdIrcDB5g230bjpV
   7WuP+v/bQgHzna62QLtu4j/bTzvF/IjLH9JH81+PJFCPFfveRKyPNqVx+
   4rGdMakSCA2DaoRSL74nxjSBHLnUe49+j2WwICmZrV4PfLSp/0LF2JZoh
   zU42GXsG/xumxVVc758exgeCZQq06l4tlgRe4t21fJ8MYx5EzDuW0zAGH
   tBgUVnux0EhwkV+TO7YURspStIWPM/1ylcDNNO8JuvAPbp40ymV1CU/qW
   tA6lDpzzLh2OXWZbgrEYT1e/V815dZWy/49dAvqelOma+AxgdNMFZpBrv
   Q==;
X-CSE-ConnectionGUID: Cn1TwtlgRiK/OW1Hs/+Wzg==
X-CSE-MsgGUID: Vo2pgJWEQvWlgRz611ueRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="68323353"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="68323353"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 02:43:48 -0700
X-CSE-ConnectionGUID: m5zCssh8RQC22026GY3ntQ==
X-CSE-MsgGUID: hvRsMFHIRzGSmP6IIbjwIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="167877201"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 21 Aug 2025 02:43:46 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1up1pP-000KA7-1e;
	Thu, 21 Aug 2025 09:43:36 +0000
Date: Thu, 21 Aug 2025 17:43:16 +0800
From: kernel test robot <lkp@intel.com>
To: SeongJae Park <sj@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 3382/3950] mm/zswap.c:48:15: sparse: sparse:
 symbol 'zswap_stored_incompressible_pages' was not declared. Should it be
 static?
Message-ID: <202508211706.DnJPQQMn-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48B56140004
X-Stat-Signature: kt1bzc1qqs891xcuwnitntiqem3xiuai
X-Rspam-User: 
X-HE-Tag: 1755769429-662745
X-HE-Meta: U2FsdGVkX1+0AlTbM/dxHqdCMzuXvdfS/aLP+J8FiAVU8RGHkew8rqQZuV70+WXzYVqi/XgC04ciHCHw0KiQEWeWG3rdLwkXHMoW+azsubUTtxmTvFVGQ+tIx8fOAriyd/3HqT3TmSG3qSpl6uwXEIKpF2N1uISfQyL1Lbz92rL9c43pNCfqJJppJG9EisDilrpdSzFXGJYLWcEkXx/LxfBLaxvXtMq3glhA1pwZIMUz+NaVswOef5mHaLQo8msOl1xkY99j0zzYYJzhdelj6kOn545q8n9Uyux++2c+MMMv9MKjIPioCcuToISAVHnpZ7/Br45bwADJBI/+jaXFgzkobHzXd8C3rL1T7XDt7AfkJyKWq8YeXtf40feabNmuvFjfxUFvFbBGKhTgqVKslU7H7GvWZSrGXlPjoCM05G9z93kec2AcTmnu/h5g38+EU+sZd3Y4ARcjYlZyjy3iAOMws6Q6WNPweKze13xhdx6EYEl5hrsKxyOXyAJIeui+kfVYq18Ij0HpLzpDXUnmf4IRuYQRJu1rANx70l8o8lxwskFUvCzhuMNaOjLeKZTEoYCY7RzsNMC5v/Vd1jIFipdigJMk886JyGoESngzjDtYqc/gijEV7yj9Ue8MS4bLkNqcdoQjANYD1SA1ZOEa8d2E9UjGqWs30Nh6VeeVi891jri/rJg0swRvUhv4yMM1JVdwNnB7PzIyJUF1oJKByPSxMyjAno6yg0F1G1xkW9gKJ+tb1gAPSrGMimCr5al1w2Gysq920Yd6oj/JUO3Qr/D9LvOJC9qX1BLupu1IKNQcEL06A9fU/SVA010yAtwGGvzX5s3nxNLY+z8WkyYKfRvbg1UYdbRTp9lq6lEEyoQxcB7WEEDEnWCU+yfF6Uzxk8N/gou2XBfCDS9dfnIDZ7F+gBpBDAf2m33SoN617y/Fcecz3m9n4WxLS4kTudwlr6/1BidqnCM5zZuHKW4
 UreDeqTx
 bbUWfsHEnWJJc7H3AQItSCbvnVJ04LsEKhdeuQtgKE/q4kB9pyHtMD2eRqlf02AL4NT5v5/WDYUijAWghvLNI0i1ELQwEF9JSJa1tJVazL65pwWSvV5DqFTlAZ2TIxVP05mCfNAEoMq6s5hwfPTBxZi8Ymh1vMO/CC53LSNR8wyg+zs9+JnknU6orRoi4BUDeUJ5NzwfesuI1DR4W6OC28L+GjfhyzmLA2xfRw95LBazmaTXRpwtQfmssppHI4sDjTw0RyxLUwQQa+IPNfwMosoEuR0z9x0A4FnBtDk6pFSTwCBAQfYrRRHHAUGY8zwraYIfbTKDOXiuoistZ0J0vwPVaVCveaBPDea9dhiyA+i2Cqn/lVyJPB151b21SMMWhARHSOC8dNVsMTtNv51LOCNeBDspis7zZy6VDP4qiKGS/WwHAC3RSmUzkqPBHypcxRxE7VTzItq/TwH0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   7fa4d8dc380fbd81a9d702a855c50690c9c6442c
commit: 6d522abd7b4fc78d51934e6c9a53d8e2349f5d3e [3382/3950] mm/zswap: store <PAGE_SIZE compression failed page as-is
config: arc-randconfig-r123-20250821 (https://download.01.org/0day-ci/archive/20250821/202508211706.DnJPQQMn-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 13.4.0
reproduce: (https://download.01.org/0day-ci/archive/20250821/202508211706.DnJPQQMn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/zswap.c: note: in included file (through arch/arc/include/asm/cacheflush.h, include/linux/cacheflush.h, include/linux/highmem.h):
   include/linux/mm.h:80:9: sparse: sparse: preprocessor token PAGES_TO_MB redefined
   mm/zswap.c: note: in included file (through arch/arc/include/asm/irqflags-compact.h, arch/arc/include/asm/irqflags.h, include/linux/irqflags.h, ...):
   arch/arc/include/asm/arcregs.h:155:9: sparse: this was the original definition
>> mm/zswap.c:48:15: sparse: sparse: symbol 'zswap_stored_incompressible_pages' was not declared. Should it be static?
   mm/zswap.c:1250:23: sparse: sparse: context imbalance in 'shrink_memcg_cb' - unexpected unlock

vim +/zswap_stored_incompressible_pages +48 mm/zswap.c

    41	
    42	/*********************************
    43	* statistics
    44	**********************************/
    45	/* The number of pages currently stored in zswap */
    46	atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
    47	/* The number of incompressible pages currently stored in zswap */
  > 48	atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
    49	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

