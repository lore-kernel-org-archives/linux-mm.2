Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3862FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043596B00B4; Fri,  3 Jul 2026 04:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37866B00B5; Fri,  3 Jul 2026 04:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25856B00B7; Fri,  3 Jul 2026 04:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFC186B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:32:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2288120495
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:07 +0000 (UTC)
X-FDA: 84946797894.06.2566331
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6997A4000C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDRZOSFN;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783067526;
	b=vf+7ni8TkVTlvyEYp10pJurL6wRXG2rTvhC7xEfFEiVwSkGuIlUhvAozt9uiOrXNFM/bj9
	AaNuTx6WT5Eifm7b+9ZIdryusj67OSRhXv/SuLdmEnn1umocRfelCBTG+m0VIvwHh1yHyt
	HHREw7Yox6QZsc1wJtGtwFTWYhzq2bo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pBKtvWEvDurD2pDDuKX3P4Fwi/GOkJOnCPOpHPUzSmI=;
	b=ymi5Uz34PRGMfryyvil63dVd5wnEGMAScgHIfpV1DMS5hZ9+sZjU3kEtkFYa/QIBRTeiHI
	3thN9lpF4gSxyxF6lT3ZvU6SWLYvCxJzFyf/YCmX8oRseXFX4WjQxROJEkwlRnLALXpHge
	L61p4RD6Zx0wT4vi7bymrlhAk7zOY8A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDRZOSFN;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783067525; x=1814603525;
  h=date:from:to:cc:subject:message-id;
  bh=tmEvE928znH8qNFZmFA9+hqKVw8A78urxl5SprV9/2A=;
  b=BDRZOSFN3nqir+lYQ/kqcN7luBb9UmYHQ6ie3y/Hf2QO9n5dELWrynMV
   jfMUrEf5vud+wf8lXUclfHbywdfPTslKZvhZAAVTVb9ZIsqlXNQLFEiCX
   fqd+TAy4m5vaX8ZBOrnfHiQi1ZZqGhrEAAePaG7f+bgxZckQJt67QGpZa
   zNkvwBJaaJwfvVtbPmSIkGV3ujbhzZgF3ZFak0rftUIOlKh2GzpPTij7n
   IJqVvTBSc2w6lHSXTa5QAd5oEAfpwTDShBgDHLFb0OQcHBP7GntZ+SmJK
   VjvIoeu1j/LtzSvBHvuUz8BcKpRaH1W5dohNBo3YYCI7xG3UAmhA550pT
   g==;
X-CSE-ConnectionGUID: tzb5SFSDSYy+WsT77RZCyw==
X-CSE-MsgGUID: H3TZXzOGQRSQaayQq2C9sQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="83852773"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="83852773"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 01:32:04 -0700
X-CSE-ConnectionGUID: 03LZJP41SLaCC+oO1VZ0zw==
X-CSE-MsgGUID: 9cNI3tVrTpa7JRE8fDZIvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="249090055"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 03 Jul 2026 01:32:01 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfZJW-000000001SH-1ObJ;
	Fri, 03 Jul 2026 08:31:58 +0000
Date: Fri, 03 Jul 2026 10:30:59 +0200
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 242/252] radix-tree.c:459:17: error:
 implicit declaration of function 'kmemleak_transient_leak'
Message-ID: <202607031019.AffpLUyg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6997A4000C
X-Stat-Signature: ftg1joxqr3u846nonaagoks8fa19sdzp
X-Rspam-User: 
X-HE-Tag: 1783067525-606909
X-HE-Meta: U2FsdGVkX1/xKrzLkaVfFDTjRrD9v5hzuKr2swj+QyQmu5xBdD12hux5mmYfSEMcbQ3ZQ+oKKjKR3KNUGYUTV/Vp0/UZM+ep/qsDP4Efsrv4RzWYVlsodmyIQJVEpSZhvpKTOvZsS+tKnFO3MMaqUUiI3AYOhqec0vpbG5VJz9okq8K0lTUspLsAokqme6V3jMinpc8VMLSukYA68GcTYY2AarwPoK/lYzvMS7FwtD4GjjMdds+vs8B89xLZ4mUK8qVV6vcdfA330G85lDj9M6mp2xeQS8mThxe01CQv+tjXnWAQEEVFrHJSIfUCwEtE/jXHPoiC871Sex40EuPhN61jz+ijT1iYERER9pEv4k23DkKaMG50/xOYs3W2zleF7OtSajFlCEUX/AwWfqIlZgMhkGG71pqBHVhoKPBGGJAvGFGlz783lpNqushirwIOwn7DhMS5NEn0tGh1PnEKUfUkN/waC4lF5279m6bwMGewAR2+Gm8iThLdNSmpBnFlDjQaaF+Rr96eFfv/GmNNPPR9tZ413moQ3idQRNmlR3EZU7K77bBqBLp9HllcA5/InwW0GypWFcx4z9EyRtcSc7PFdjtiswoPCAy07Apqunn5A7JzXrDSnME9GesKFASxs09GwwMpWABn7dfiovzoiYNaui4dA/iEOOmdgGOcTTVdg7pGOJamAVXWr0TtDYywq2if8fZq1ljCUqQNCJVZoxVogOZbj/N0y+6S5l7xZj0yhRqD9CCfDbqHEvut/53VDr0vcdEbeQGEP+PQoKqnPoYsBPKdij/RTCn9T1CGJhOzNbAwMd9I80T0+IQYHIPgIs7DRYRDV1qfedr3MSNdTWNBTbZtTCfmDC9XNLUjcppgrwTL5NRwWkRUYmDWa20dL2r/MnKmB7wdX7oTspe2uINMygTbTlAa27dDY5SH2ILvPga1kKnut/95YM77XaguS723hG+LmiTupVW3ZXi
 5L8UCxyM
 mWtUVxRM4Zb5h9yz+K2YFEbb6jgiTKY27tf9iw3MIBqye5j36rJmJqCC/INtjnN7JhEubfS6KHaskuXtOaGX6UfgnwNgpqlKkf0SfOxz0JESFt5KaxeY5q+OXrteFDQA0TuZIHqKA27Ns5PpmSgCeXmsosmN4yjUEV2xdy/uImtOTcf+9wYGEgXK/JUz49iCsXLikjndDNSoD/FmWmOsxUsgzfqAVdLKubqa9p33BOTCoZxdRLR+X/OofYe5UcY+E5Gz5j4niwhWT0bPe06VuXh3Zyz+sNA2Age9x90P65AIHrItOF/eTEPnnyAMhuZ7SQcdNiExcTL8SX00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e031e55776cf9193b4720a253e92539ca536d224
commit: 58b5601b28c144be1905eef7964bfa8457f58292 [242/252] radix-tree: fix kmemleak false positives on tree head reassignment
config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/config)
compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607031019.AffpLUyg-lkp@intel.com/

All errors (new ones prefixed by >>):

   radix-tree.c: In function 'radix_tree_extend':
>> radix-tree.c:459:17: error: implicit declaration of function 'kmemleak_transient_leak' [-Wimplicit-function-declaration]
     459 |                 kmemleak_transient_leak(node);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

