Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5C0C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA376B00B5; Fri,  3 Jul 2026 20:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8AD96B00B6; Fri,  3 Jul 2026 20:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53016B00B7; Fri,  3 Jul 2026 20:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 826BB6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:12:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D55AEC1A73
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:12:05 +0000 (UTC)
X-FDA: 84949166610.14.63D8381
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3325D40005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:12:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j9aRk03V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783123924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hNkMVRoa6PmVbKSdlA83ryCaqn5C2uYv4FtwHZj5BiI=;
	b=7nguFafNb6fx5CFygRBVpv+Gydp7BwjAVsOvsOrbKa5On9uNJlJwHa81F1qN82qFxkxgxf
	02WaXu9uIpDr5eVC4Ibk068WODUO1jDoa3fRCQb9MdRWVPbGV6THIVdwnDm+WYSLLgnz7U
	A6jT0xVh63xFjE5fEpoI0O1L0Hq4PiE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j9aRk03V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783123924;
	b=ZTutUWDC5tcuBVyT+q2X1KcideQEbpjlEj/B4wabTcSue7R6GbgMCoA3pjN1gqBALBGVQv
	vX3jCJO14A/nIeptbQRcjlXQU/yBBn/UzRhgGf8zFaDxMQhbC0Zxw6RFKKR1kOM3MVw8px
	dMu8XIWnv2tw6dZhNGRKD/5ebbNGhAY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783123923; x=1814659923;
  h=date:from:to:cc:subject:message-id;
  bh=h05lKYcusIRAhCEvVYrp+8bmN8xkHNWkKi4EBh+jybw=;
  b=j9aRk03VQg8HP1awCUVPJIKQdMUJ3y0A6kA78j71QbOBxV2gc8yFZcAp
   wfHjM0xOMNiV64JOv5yxPxqAwnWdpXe0IcJ3TDLdLbYeRiJyShv7emi79
   43ZeaUBfP+fRxglr/rlkxb53yCFp4Qe8jRCqJTjWL5ZeXhkEEcAUHrejS
   O0XbG43b9Qa4CM3Px2LHVBpcqk/cxdvsmRlb8gJUCMP/X01OeNZknrdJ2
   omH3bAB4t41IaESDW9KdgNa83dmz9iFdepwCePjFFRqR7icwzNdsdnl0l
   nCHmTKxCc6ocKZvHCuiVj6I6gS6e6FCtIKvSsVcVPJYMQq+H2kVJUvth2
   Q==;
X-CSE-ConnectionGUID: xtint2k5RnCrhHkZWeDT+w==
X-CSE-MsgGUID: llFzqCDiRbm+gcUCFmx8XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11836"; a="86413627"
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="86413627"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2026 17:12:01 -0700
X-CSE-ConnectionGUID: o4IwWJoLSvmRWyL3G7y+3w==
X-CSE-MsgGUID: 4KZRQjPHTLyhPpg7hQ+MuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,145,1779174000"; 
   d="scan'208";a="277542293"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 03 Jul 2026 17:12:00 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wfnz9-00000000CiV-0wF7;
	Sat, 04 Jul 2026 00:11:55 +0000
Date: Sat, 04 Jul 2026 08:11:52 +0800
From: kernel test robot <lkp@intel.com>
To: Kir Chou <note351@hotmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 David Gow <davidgow@google.com>
Subject: [linux-next:master 3047/3809] ERROR: modpost: module
 random32_kunit uses symbol prandom_warmup from namespace
 EXPORTED_FOR_KUNIT_TESTING, but does not import it.
Message-ID: <202607040749.JXe1iGAF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3325D40005
X-Stat-Signature: of1s4uepom5usjt8nj86n9zmszoiswq3
X-HE-Tag: 1783123922-799525
X-HE-Meta: U2FsdGVkX19YlpeRsia730nFwR6ArS5SAxx3ZIO0ZplwLbSLZSTsWOfNbrRyCu7vqIopBDj9L+XNPatxlHuwdZxJlA2+iKdpxj4VpNQWNr5LyPlqUFa3EIsHAMj2RjXWlcKTJcT3NVYTOAPn8fyFZkU312HT2WN1jx31yZJU/JNrksTMzntiUNlzNX9knaY8++gd/Ubm2Y2tSR9wv9N53P/SUrRuW+eTWrCoeV+VMr2+RA1ImEBwaPICUWQCGsG0vPACk7mQDCsskBKhazgnF6djOHzaJ8BDeoHzE6IkAXs16AHCPIvdRHq1G8NJWx0tF42ujJV8p1bcUNNAeZx2+ugcSL3BgqjhhZqB3Zuqz8ywKvxygX1gb3SIBEms1+L1lRe95IQmFJdl5ZDQGRP4BGPbh6nD77MAftLVbosLuOq7sm8gaiADmf3ciuwbDQ76VrYWq7RrbI9jtLZvPRMD66GhS+lnGtMd9kIURCMT0lT8JlqD8CvGeMRc2dJi0DPdO/F5j28Pz2Ba9z5m0V25nEKeePWmDy/tgzH+pwxrSD+LBVgzdTvE+OJz7ShIZMoKasAVwS77iYII6OzieQKRDdbl60j9f8HXut2CYZ7La/ug8pMIvA184tXszcU3ezybSaK3HrUUat0YpRBed+0npcVjF9i386N9hzcacxyXwC4KkbCMn42Jkaz+NvH+tssijkkNeX/JrMcwReY39P+BItKD8DHMFtmvGJKIi0xbqqTV8kcN639vOujrnLIHZE+kZRHtaioRmdhlFguhekQOb8MLsSXCfqnSM8pJeJ3hCNm4xv7v2yOYkX9VaheCw+7BbtanrbUKIn3ixjCV0kvLOdPmpvk4+hjIZjYgNZjtkELTY8NCT/4onFBOGfIjJx3qMmO8v8HJkyz7v8rBcryzeXSrktlbmqbqr76UvlYeruM6QyFgIqLXy1wqIPG7wH3zKVJus4vMAwKo1475I60
 k9vd+0+2
 670ffYGbpaZgXhRidRdfDPHGoEf+jo9PNEuR26pyR+JeJ72CWW/B35h4wI1qFeFY5jWgm3It8DtpMdq6e+aU1Ra8etXNEMNnL08gD8NenDNj+vRhnAae4d3yVqFUKqxOMLUAyqkyvLrUlUBiYu63PYVzQzGT5I4XBJrB1xvef9csxxZDYKkuX5WKblq1Ib3sN3VzbQySaH3AR+A8MGbzaF8dw65faq1Kafry2Ca5GcT68jNm8qMxY3M5nQcYz3xcCAQyhZDgkNpRzHHehWgXxyyxDMcPYVbyAiqI1mFDHxyiYIMnSlCzkJPRBATfiN5l3BdJMtBHF8DoM7nU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   2b763db0c2763d6bf73d7d3e69665222d1f377cf
commit: 2ee1282ed36ff65ff425a4c6d3121bd701dcd547 [3047/3809] lib/random32: convert selftest to KUnit
config: x86_64-randconfig-104-20260704 (https://download.01.org/0day-ci/archive/20260704/202607040749.JXe1iGAF-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260704/202607040749.JXe1iGAF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607040749.JXe1iGAF-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: module random32_kunit uses symbol prandom_warmup from namespace EXPORTED_FOR_KUNIT_TESTING, but does not import it.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

