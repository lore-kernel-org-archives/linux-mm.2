Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61060D29DEC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B991C6B008A; Tue, 13 Jan 2026 03:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42876B008C; Tue, 13 Jan 2026 03:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E2D6B0092; Tue, 13 Jan 2026 03:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED046B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:56:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F8A7C05D7
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:56:48 +0000 (UTC)
X-FDA: 84326335296.13.973D0F1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D41F140009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:56:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RItBYGKY;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768294606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKYog1s1rgC3A1wPn0CXl2kCXGZnLviZFkaZRflmZew=;
	b=kzKRFSrHWCpuJ0rCNq0APUy+5jCU4z6f75kXY4RTsWozO2xxeigbw7j6uEiYxA8jNAZMDF
	rxXxrm5hrH25uSBtXozxaF9D57l1ACpWWSFNnWVB5+rRhkhH59fmxnxJuIaCGV212n/P3n
	tL3To8lwV1YgQEFgpnEutcPnvwluyxs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RItBYGKY;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768294606; a=rsa-sha256;
	cv=none;
	b=cs/3jW0i5c7YqNtuYD0/i+KKubZKEJ4q3cGjhkJ4IVNZzza+gL14x9E00E8oTF7F2okn8h
	CN/t6YSKuvwr0x0HSynhDWyUdKKaRkVY5YlEqs3muxIObGV8n5Tz5M7rqi6z+jAFD61r92
	noSACu0ETMaeMmO5NQJ+Z7KdaCp+2lI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768294605; x=1799830605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VoZ8K+Qh3HPMMc3FiXVccpGnuyA3hzWO2LYr+PyxFck=;
  b=RItBYGKYmpwRzpob9i9EnGXdnAaZ4Rf1RvkjXgNPninrj8SrpL/M62uL
   ibcH943Y6tXiaqrJgJQUE/Yvtq3e4qsBH7j9T5kaZx91QzetqchNZWTd3
   wu4BxWdfaEik+fpv0Box8ki3d+lwHjsG2qGmlDgFnATN1L1v2oV6U3yT3
   YrDoccYhrQl3HdmKPWMHFTKy32RXhWyfIf7XVCWeGm9La/jF/57035WEW
   NB6wrL5Hva/cu5AVxi+N2LLJAyl6cME6ZufTrhF1kAXTipl9Hf3FLbtRh
   GRRlaK090qEVdPlWBJ4ckkg0pDhsAGBLZ3r26SS4u2jMmxQOCF5aoaZdp
   g==;
X-CSE-ConnectionGUID: ZRMM2MGtQAe8JLqUdF6voQ==
X-CSE-MsgGUID: 7hv8EdmnTnieUSxJ5sQBrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69557857"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69557857"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:56:43 -0800
X-CSE-ConnectionGUID: Xq0hi+ipTRGDfypKKi+Tmg==
X-CSE-MsgGUID: DG7rfTZSSJ2mqDqAx1Nyhw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 13 Jan 2026 00:56:39 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfaCb-00000000EUy-21D8;
	Tue, 13 Jan 2026 08:56:37 +0000
Date: Tue, 13 Jan 2026 16:56:17 +0800
From: kernel test robot <lkp@intel.com>
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
	linux-coco@lists.linux.dev, x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	kas@kernel.org, ardb@kernel.org, akpm@linux-foundation.org,
	david@kernel.org, osalvador@suse.de, thomas.lendacky@amd.com,
	michael.roth@amd.com, prsampat@amd.com
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <202601131632.NrQzg2Wm-lkp@intel.com>
References: <20260112202300.43546-2-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112202300.43546-2-prsampat@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D41F140009
X-Stat-Signature: 8pabzhhi3s3cwrh4yii5h8txiztaftth
X-HE-Tag: 1768294605-995649
X-HE-Meta: U2FsdGVkX1+sgB4ShPWMz98TOY30BqJNY1i42NOHu5u+7Wt4qy5E8iZNxoN2FdGZ6pBui2zDaD3IdDamSRYhV2iOTHg9bzuTONEkf65yXyZ+4vQs8j0rARCm9+vTT7z3XQQ0sD1xhS47ZgRjnswf9IfuyXpdxNpteqxiyZ6sTEJ5F24DZYMiDEKGKOGvp0V+LAMjYYgLfCYlCTccVqK2ZV6rVq+Zga5HEpwyxcnrQuV1nY2UO52UOv/ZbF1M1mPVjrWc1cwD3GS0bW9DvB8Ij7TdRULEmlfKYUwpOS3bV/07JhjernQGlQdYxhOdhABl3zKuS6KYKf96jQWDt79yLIV9Obc+rf4qNbWLT32iXlGNw5ROQReKYXtb3ikhLD+Ytadsn56sHqnkuKXt9s4JFdFeIvoaj4aGO1Iv+A+8QUd5H5qxphWuYk59sFWX5Tzt0bVqmJZyyo+i9sORp6PVNwVd0JjfQE12s6elgSEJ1o4SBYb8N4guZTRX6v1L2TCcQesFHaOO94ACqvUk/KVkKDkfuNfBrv3B1QEUj/Z634C8FMOSybD2Jp4uPICoCu5v63LcsfMMKWneV5g2uuV+cOoABl13wETOj/TDVOwhYgl1Od+LdhXbBm/LxU9BIZHtLVtOkKrGm/7K++X77lIEw5lXysLt1TD56ZWzisjA36+cQbmYxuhtNLy1V9cFWYkMuHIdOrh/ydmVDfXa6/cp279wc2TzdEPLdf/7I0LDCCSECRFdZ0ayeuy1oT+/eblbxyqINYpOKmx8/qiNNv2V8q9IjPvorHyOPYTkQBjWPnPpVzegej+ecEZWAThY784dcdbMZ4p6arA65Mx12xAuSvToAO9VrLIzZD502F6W6kjMu/xPaJ+ptqPha1Nm54u7zPg27QwhgfUyZEgqJmCSkJqJvZocZ7OXaxNvIvCMaG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratik,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on tip/x86/core linus/master v6.19-rc5 next-20260109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pratik-R-Sampat/mm-memory_hotplug-Add-support-to-accept-memory-during-hot-add/20260113-042631
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260112202300.43546-2-prsampat%40amd.com
patch subject: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory during hot-add
config: s390-defconfig (https://download.01.org/0day-ci/archive/20260113/202601131632.NrQzg2Wm-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601131632.NrQzg2Wm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601131632.NrQzg2Wm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memory_hotplug.c:41:10: fatal error: 'asm/unaccepted_memory.h' file not found
      41 | #include <asm/unaccepted_memory.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +41 mm/memory_hotplug.c

    39	
    40	#include <asm/tlbflush.h>
  > 41	#include <asm/unaccepted_memory.h>
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

