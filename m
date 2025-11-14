Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61290CD98F7
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7BB28E0003; Thu, 13 Nov 2025 19:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A533C8E0002; Thu, 13 Nov 2025 19:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968D08E0003; Thu, 13 Nov 2025 19:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 85CAD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:29:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13C721601EB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:29:31 +0000 (UTC)
X-FDA: 84107328942.14.7CA5666
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 38FED4000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:29:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K8QEUFNg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763080169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JtyyVm7OPBysgKyjdNk74K+He6OWPqIpcaRs7w3YDZQ=;
	b=doCCghlAuG/WVS+mqZCSyt02nnh1gyxkYGQ0mkVaw0InN/RrYTpScI1W5EuofpLLARfBYU
	fGSfs6cCiaj6aHaoP9jWOqO5prPFd8BKacUKCGJAOC+EJ6wijTJpzmhbfS/snl5lZ7WdJ8
	K3GtqBR+3MCbxjK2wFtb2vKrPJN82AE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763080169; a=rsa-sha256;
	cv=none;
	b=I49BJw3XaAU0RcDiK8+vuv6Of97eu1YjUf94b816G2Fj9ZfIwpmXirbXLggKLorAmPuXZY
	L2QwfIqFJ1+tACyU4c4kxeN3k/bs2gP2/g2iJcAYFNaXGMLo37pysStdLH+3QRvSnmj6zg
	N55O1+HahCiaa3ajPkA92fwl3U82wBQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K8QEUFNg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763080168; x=1794616168;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/SS7OBO9ebI64BEKIbcnp0+vWINhAoKzJ0y1VMXxxVE=;
  b=K8QEUFNgRnicEGOwXbL/pAmK5gs4QaixjWt10WOyUHps/bBC81w60+jp
   f1OCq/+AWYtAo63DfddatBhxmytVzpUhMnf9TKBNzys9xv7Pz8UqZimyc
   ypI+d7xTM1e+dZonCvOFSaI6kqX6I27lMlqbZDBB+FVYAVHb6yCvZpQWE
   EWXguwm+ZcGRbmZx9QtEz4pzEfCeS5YcYFukSuRUzal+pkE+fhbM4t4KE
   X6O832I2Cjl8oidONwtkkBAylwOELyUNF5qSEnwrACCPjfj9Rc+0hK/XO
   tsCLHJIVywP+nfQY9ugyrmHiEXq7xlugqHW0+kGrfiEP/GKMBNEZPocXk
   Q==;
X-CSE-ConnectionGUID: V6TTgsUcSPOoHx6omC0Y2g==
X-CSE-MsgGUID: KWYXwjkeR9eIX6+8+MyIYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="67774336"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="67774336"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 16:29:27 -0800
X-CSE-ConnectionGUID: sgwbx42lRE66dLOlFDCsdA==
X-CSE-MsgGUID: XPJG68mlR8elIzefYTL/6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="190064798"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 13 Nov 2025 16:29:26 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJhgq-000619-01;
	Fri, 14 Nov 2025 00:29:24 +0000
Date: Fri, 14 Nov 2025 08:28:57 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-nonmm-unstable 84/106]
 kernel/liveupdate/luo_session.c:101:3: sparse: sparse: symbol
 'luo_session_global' was not declared. Should it be static?
Message-ID: <202511140809.4JN2GCxV-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 3ghh34soca3wqm8ca6zd9taemtpi49xz
X-Rspam-User: 
X-Rspamd-Queue-Id: 38FED4000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763080168-125723
X-HE-Meta: U2FsdGVkX19S/cIi4s60EJ/h868qkfDPOtOcH0LVWINZ3Hheu8Ez5kQkrL8H2PGqGFsLB8pQ6EnpcJaanCIO94jcvqWk2FWKP0iGg8V/M560Vqx3XLE7xpCZtClb2GbQEytXt2BEi87LQcayI+dqXn9P1XW9VVlZZGpEhBEkTFw2aDxTvrsn84h5nslEV/fM0z9/pnrKfKJUA9WBcu0rnsHg6QZUCRRRtISfD4W9SS4ffqLDajVxPKPGRYhvABVaqzKQHh3Rqw/1PLD8dRmRuLWOEVpWq7ACumCudU4o8KuKWaIH2LdtFOfM1ijjffbgiwJ7ufbvPzLZ2/2iplQUlsQ4e2DaluwTWpdqFqNpeZhmI8m/Ch4157Wcx6qejltiDivXBPNboq9Dcsh7MayMMahvhmR4gCMsBgJ5ahx6jUDkt7S2ASKhhQFPb0OE83KyYyu/D192FEmeD77Vcc0u5LTiQn9pXrvgS/msNT3odiqtTA9OvhmI838tdoV85Kwuk3bfPZQaechi1rYEl8eHkh3hyqzgbIzz6pAbPJaYCCeTWxdOGdBeLOAHxp2J3nuHap02sR1kDItr/MhbhDIduNa9jJ14KI/v9O6FsqZ/knjV8iFKS4Xdh8EhDHvOTtXxXWutuLVtJ518K8MGCUoQOEXcwSa9RUBvdYSOypJHTE7XQTL+CSg5xNzLpXzVJtOgcWMeXR3deQT73qQVrOgnLldjbqis/0d7hjBEZY/XZpc1CyO5cMJNTsP5QY8W3IIM9W0mZ5SU7yVV6A0KgKPFJq5PGdHtpI5i48wcPkOZxf8M5nsgFwdaadHGmSiroUggPPqCP3ue3VCRs5ASpls8Dm9KjjwJyelhtjokq0Om1xxZ6aYS6t22Q3smjTdA29JsjdHbYcHThtZzXjYTwNhRET/x57dz+GiBmpiCkC1d5Aw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   c3e0350a1f9934c5e56d859a26bf37a15ab7bb25
commit: 877409d046405d44ba7e15e19345239c1affa4a5 [84/106] liveupdate: luo_session: add sessions support
config: x86_64-randconfig-123-20251114 (https://download.01.org/0day-ci/archive/20251114/202511140809.4JN2GCxV-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140809.4JN2GCxV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140809.4JN2GCxV-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/liveupdate/luo_session.c:101:3: sparse: sparse: symbol 'luo_session_global' was not declared. Should it be static?

vim +/luo_session_global +101 kernel/liveupdate/luo_session.c

    89	
    90	/**
    91	 * struct luo_session_global - Global container for managing LUO sessions.
    92	 * @incoming:     The sessions passed from the previous kernel.
    93	 * @outgoing:     The sessions that are going to be passed to the next kernel.
    94	 * @deserialized: The sessions have been deserialized once /dev/liveupdate
    95	 *                has been opened.
    96	 */
    97	struct luo_session_global {
    98		struct luo_session_head incoming;
    99		struct luo_session_head outgoing;
   100		bool deserialized;
 > 101	} luo_session_global;
   102	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

