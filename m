Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27368FF6E9B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDB16B00AA; Tue, 17 Mar 2026 19:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E3E6B00AB; Tue, 17 Mar 2026 19:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394176B00AC; Tue, 17 Mar 2026 19:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29C626B00AA
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:15:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D10EEB9643
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:15:01 +0000 (UTC)
X-FDA: 84557112402.28.ABC580F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id C882F140006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:14:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iG7+n74J;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773789299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=51eJPnoRW64EYCWzVyWg9nSeegyZbxlmFyw5nLz6ki0=;
	b=eR3Ntmgsp9XgAop1H9nfNFQ1BHfMku0hc9y5MnMvFr5U5OQB2qifF26FfwdMJ62QWRs9Ee
	M27bNNj+4xDyBxX/W4XQ6YkUcFuF9uA0kXaHKb62xhXsvcxg6VjvdvXHeLK9O3NDACDCDd
	9kCGk9+oExoj+WGkR/2EGRd3+IV3r/E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iG7+n74J;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773789299; a=rsa-sha256;
	cv=none;
	b=t0jromIsRZ5gjc/vErbuel3Fn8xzS7JWZu4JzxN0RaJQS+ygnvQtjSReKdJC1Hjf5NswZF
	gygIxyhZbtPCRUrrAY5bMiNN00vkJEQz0Opd99YPoOn7XoyZHRwT3acstFL7m5SneF0h3w
	BG44TtRyQcjc+8RemdmrL056t9qC4E0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773789298; x=1805325298;
  h=date:from:to:cc:subject:message-id;
  bh=v9b0lVxagdfBNG3cjyaaHJRAr1KsZRo+WTWLZN5n2TU=;
  b=iG7+n74JfAbrGndeDSytRQonYWnvZmg7KAAxoAAR4RAS1IiGUhjMV9F7
   bd6rTxECoFc2xObBzgpqefCndXPfDxvZpNRLvaZqI7aOw1yC/LZXuDILa
   8dlVjTWYIYdEU8lUGOYI6HV7uAnexthXw4AIzpasPHuml/4fo3Bzi5KMC
   srFYnZyOh4usRAMtzwYWJrRgd9JrQoscUiM6iWF/eGDdU4hOdD9fPCEub
   zb1/hg7jWCBI9+aoPcAe65pz3TYyr4baMBAp/F9MzrDQtyKMVskSb3glA
   NpbNAJcPr+3ULPh9XgbD4Vl9G4mUSWY7W6uEQff05KFAU9q36skqjVbK9
   Q==;
X-CSE-ConnectionGUID: 6jlLyzyjTbCGHuZqJ1ySPw==
X-CSE-MsgGUID: GVxazoi0R9GF4NsrqmFfRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="92221147"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="92221147"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 16:14:55 -0700
X-CSE-ConnectionGUID: hd1YebRkQm+ZfR6btRJWRQ==
X-CSE-MsgGUID: 7Dd/QOLURMmbyeWk6getkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="227098958"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 17 Mar 2026 16:14:52 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2dcf-0000000029p-3F6X;
	Tue, 17 Mar 2026 23:14:49 +0000
Date: Wed, 18 Mar 2026 07:14:24 +0800
From: kernel test robot <lkp@intel.com>
To: Michal Clapinski <mclapinski@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 424/425] mm/page_alloc.c:557:17: error: use
 of undeclared identifier 'MIGRATE_CMA'; did you mean 'MIGRATE_SYNC'?
Message-ID: <202603180711.mqOPviIG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C882F140006
X-Stat-Signature: wwz53r1unhq7bwpef5owtktaouia1urz
X-Rspam-User: 
X-HE-Tag: 1773789297-891405
X-HE-Meta: U2FsdGVkX18jTaoCGZ2bvu/qhVfZZzxd/lEOuaS09jwl5/1PaGcp1Gf8FUCUDDz8Efus22OutZ0guo2o8fmjfGNcDG1HDFygAeCY6mxnU1IewPVU6V0MW9y59KnQCk9SEt+LufvkGuuwSCHM6RELSCer+rf43uvh35Sp7ZYyoCVpVt0LpvFsfR4a1gtzRUZD+cFKa+G1pIJhlFrbjg3WS2DwTUbzap3mdLqLAcMlnmlzS/II8J0EVsEs6Hly1a4P68NOVBLb039WWfnvPbgc0IM1YC0lzVnY00+JQMhXbPDN/tNsl3KQPJDdpUYXTS3WTUbd97LWonwcIXi0pR81QMA5uME8X15+0X8zlqui0CyD6g26K9+9G4ByX3rkvGahpE1y+F6og8Rj7MSqzG+U6rwgQ7t4NJJUFz/0YXWfMQ6dmiroeChFER2IfItn7EdetXkVKE+0beclp35HExUd82gPIlRYrZ6gvN0vlrxyGsrsMxNFsyvuwxq0ywq/Qtq/tFNHsMTt/H1s084MVszSOU2WVpFcoR4VHA0VqnMs9SCJrm6AzoKHkPSh4nEdh8FKGljWjXZ4Z23JwOEPzknfjRbQQpHv71NhzsGTJZVwmuZswM8Pi0jfkYO1pkCmYcAGgFlLxmN7YGmngEwSwOzpc/CBvBIpASXDKN6iz7iqgMschWvSLWdNHqlUxiwNsxw56GYBhuLieaYYC2WfkgpkK3na5e4TtmNSVNRpprXopHmioMpDvAqBoPlAo4YAnJR+7Qylm0wPQps/fxMUgTyTmBhUnueqK0oOyjcFQhSQkhcRybFTIDMz+VAB+LOVYDU8oV5XSbuYXYUlSkKk9AnKDw0/HW+upg48VR+JfKphoQ8gNNzKnnKg9At3UIqm3SMAyW98vVYxjJM1KJ1YtczANAx+UtSdX93WjNAbeWyZGtMCKQNmxWRboXnujaCGH0+GeySe5sppVhLkvYbUvuu
 GK7VuksQ
 AoPZrbX/sQDX/nLh9jYNAPJ0D29Q4wy/CM+U3Ak/NDMy7tO3KJFqcKdtVrkZOOYN6YyjRVf6Q3zQgFcRGkXzjo4NvUGD4e3zuYY4D0nESkhMaix52Ox/6AOpLRal8lv19GZ5ag0FnuF6cw3q3RV+GpyUkOOL5iXMMrcf/dMmDoOZ+JmAkRNpAbeLqQpd6G5eIkWSnn4lS4zThfRr6GR1kWGnF3F9WwtMOXXkP13kXQCwUCXysmH5cxPTFKS/fVvj12pzBjvgWMiIZV1tYVZdA5+QQDQ43glt8WQ8N0YNZTQt7jBMm0fCae0A0aSuWjAwdiaLFS7sebLsYFMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c31e58126afa2665dc5b7f78c60e5fb25218d7e5
commit: 1e1dab36a7f3e06700a97696f62e7691ce4ea85a [424/425] kho: fix deferred init of kho scratch
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260318/202603180711.mqOPviIG-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603180711.mqOPviIG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603180711.mqOPviIG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/page_alloc.c:557:17: error: use of undeclared identifier 'MIGRATE_CMA'; did you mean 'MIGRATE_SYNC'?
     557 |                 migratetype = MIGRATE_CMA;
         |                               ^~~~~~~~~~~
         |                               MIGRATE_SYNC
   include/linux/migrate_mode.h:14:2: note: 'MIGRATE_SYNC' declared here
      14 |         MIGRATE_SYNC,
         |         ^
   mm/page_alloc.c:557:17: warning: implicit conversion from enumeration type 'enum migrate_mode' to different enumeration type 'enum migratetype' [-Wenum-conversion]
     557 |                 migratetype = MIGRATE_CMA;
         |                             ~ ^~~~~~~~~~~
   1 warning and 1 error generated.


vim +557 mm/page_alloc.c

   542	
   543	void __meminit init_pageblock_migratetype(struct page *page,
   544						  enum migratetype migratetype,
   545						  bool isolate)
   546	{
   547		unsigned long flags;
   548	
   549		if (unlikely(page_group_by_mobility_disabled &&
   550			     migratetype < MIGRATE_PCPTYPES))
   551			migratetype = MIGRATE_UNMOVABLE;
   552	
   553		/*
   554		 * Mark KHO scratch as CMA so no unmovable allocations are made there.
   555		 */
   556		if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
 > 557			migratetype = MIGRATE_CMA;
   558	
   559		flags = migratetype;
   560	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

