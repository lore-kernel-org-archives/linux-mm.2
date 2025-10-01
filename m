Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 899FBCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 16:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C101D8E000E; Wed,  1 Oct 2025 12:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0A68E0002; Wed,  1 Oct 2025 12:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6148E000E; Wed,  1 Oct 2025 12:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 972448E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:36:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6690AC0165
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:36:30 +0000 (UTC)
X-FDA: 83950098540.11.A6669D4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97846C000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:36:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QcrzFow+;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759336588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NO5Cox1O1/W54mk1qS/tzDDi0dYt0a/DUjYAb9Uhc8=;
	b=Mfpy9NqAobZlrpnyOPYmrupMZnYE3U8B6foMo6HLJ20YkvG1e28Ez8xyInoXi4jQx+ElEg
	bOzZt53ayXcWpArxWwyn4OLC5ka9ickFIp/Y9iLDH2d1ek1dvZc0l3B7EPlHE5fEqg9I/I
	KQpzkcLsaBgfuzp3/vKS4u5IcrETgF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759336588; a=rsa-sha256;
	cv=none;
	b=XJW6BlRH6s8nFmaM+gqAOPlKeQqTQCK+qplCVNP32zHQNDwsncCBhSp6FSrQFxkPHVm9ty
	fwFLX5s6bTUCLZT1vWk6lUsZXB2YkcgvpFANXXECLxfsftqVaGBo9p6jSioFGIM9LU0D64
	mGVApUWmhTr1gLr2paZEBLP6LiYsjDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QcrzFow+;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759336588; x=1790872588;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HSLm25QXTpkKM7aT1hm4htROq4qR0UuimjxRvDGXd0s=;
  b=QcrzFow+M75oSXr3OH7Jh80SBPVbKPRxwk80/uw+eGd3l36pH5MzcYIC
   vtRMqWkZx1ga7yG+iHhFErzVVZuIOpJGD85CV5HpdZ8aW1qnHHEY8YqMH
   /tFTie8rhCn/gxRpEE1FgBt6216v7Oha6Z2PoFTvcRvxuP8YhGyaVUe7p
   uvTqF7Jj5APm3hX7ApiD+AqCu/Ej8PfQ5l4l8iWKxYPltIOZswwkG80Ra
   r9fki9xdtwjGtVvO5iDtT3/vyhYONpZctNrAafdiq71ynXcwVe0Fhx493
   /r1TPKQWaOizync4wAEl0NPa3JbzJu2RtdGEJztn2bd5TQYq23HDDV8fK
   A==;
X-CSE-ConnectionGUID: wMdOrcyRQEGdOEUng4zJ9g==
X-CSE-MsgGUID: ZzOs7jKvTQqwKIT2sn3bzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61506579"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61506579"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 09:36:26 -0700
X-CSE-ConnectionGUID: TwRkw5L8S9qMFlhUI5AWtQ==
X-CSE-MsgGUID: OPt0fZOnSpGgCizH7DihNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="183116776"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 01 Oct 2025 09:36:22 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v3zoR-0003B5-26;
	Wed, 01 Oct 2025 16:36:19 +0000
Date: Thu, 2 Oct 2025 00:35:48 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v1 2/3] memblock: Remove KHO notifier usage
Message-ID: <202510020000.IIPFcxsW-lkp@intel.com>
References: <20251001011941.1513050-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001011941.1513050-3-jasonmiu@google.com>
X-Rspamd-Queue-Id: 97846C000B
X-Stat-Signature: 6sbd1u9jcz5xz5niy6q5nhc3ohujep96
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759336587-990470
X-HE-Meta: U2FsdGVkX1+kEEBhSvGpIQabrY50+I5/vT+cDn6lnRiIsrIZJo9GWEoC9MROBgCGbG1vUbY1uQYFJvvj7aoo/s2dpzNyHg0K1KInE/wxEJy2Z6t8zi2q6CroLx8RUFFVuFGli1UrgtxmXsOI2RbPlQewUSyP1bUxowmLNO6GmD24YxuVOpIrAxrkSZi0fLnm/6Q0rGG3Z2dqVvUlnISMOUp6jj14wso2LrPzDczYOtvsx3S9uDJD8BLjQNRcneIxmRBMufdP+mjQROjzfQe98esZhoBa76VM7Lj56pm9f4majl4b7I9fx1rkkVaEtoumPOMjOyqBO0Qs5XHTc7qHeGI1HRhk87VBVufCBU5HDElDgxsQODduGGPgtxn1eo7kwfcMBHAxghlsjBL/8sZl6LoaT9x6llv75SiwBRlVIS4vnh22Ez3fHdL0/qW9vMl8nteVwWujZeeHhkezX9imXLV4wb6Veq9ce6LJpa2YcMp8bEThLKjfe2rBsDTiVk4VWNoaEr4nc0UTzS+n0bKDlMa27+Dpp0N/vruX/6sDJch/NgwreB1V5FsohtXe18ptjH2Y8YlW7KNMiLaOUE6YUnhLIK7rerUVM65NocKXQDfbwGWXxQGjwmwRGVif/+wGA9+yb8+mnl0heo6QcPn9pVUQo2X6/QMRO0cDQvZ9k1M4pX5KyvZpNNnb8/UpeaNnxkKC9eZhRRz+Kt6+teFwerzBLNyb/G7Cmna/SXj9/0C8/dvAOxo/pHTptIa+Wfk19Jjq0yGaJYY8dzxIaCqoGX1fobr0iBboeKG4c+BCp7Mc21p6uY9gGE/TnJ6oHf6UHu7xkZ1X6RFvzTvvzgwlX6BvXCtte60gGrZ9wESDUzLyXcrJF6JWc/SPszV+pLUfZiLrhCYDV+7TAeTAOJRFu0y0QuIcY1dPk3hLeLSiEfCNiZ8qQ/qYhP5FtSvnh7FaYR9FUI6byNu8hPhKvWl
 V6cKb9E5
 kDCbh8SgMnMYb9ZWAiMnUc1pb/nFs/MQRpEZ3zBKEYKo4MTub0xcaDsK7p4uEQG/vKGQSj5jJ2pTCUmu6eNecNlExm8wAan90MIqjrdu83NslcMOMsQI5O2GD48y2Sx+g6gBYQayYsrU3wAdf7G//aIt+rlPIaNPCWaVk6uT4RwOCNnd/gHkIsBR8wihLJ+bL1TrzIXPA1XmqM7p4QrlqJp0E2xNEfZsFM2uPNN3ylDo3i8uXUS0KPmSmzIGkv4NQDvfcTm3ai48i/YYHJtgiJVroXEwFAYp5NxTFcrBoGEuzb2LCei9Ro7PyeewDPKSVygU2wM5ABWRp+lLlDrD28epNcT7zTwzRBA7gk9on5nE+JM1vCwNRneGiNZmGn8xB+o2c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

kernel test robot noticed the following build errors:

[auto build test ERROR on rppt-memblock/for-next]
[also build test ERROR on linus/master v6.17]
[cannot apply to rppt-memblock/fixes akpm-mm/mm-everything next-20250929]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Miu/kho-Adopt-KHO-radix-tree-data-structures/20251001-092230
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
patch link:    https://lore.kernel.org/r/20251001011941.1513050-3-jasonmiu%40google.com
patch subject: [PATCH v1 2/3] memblock: Remove KHO notifier usage
config: x86_64-randconfig-003-20251001 (https://download.01.org/0day-ci/archive/20251002/202510020000.IIPFcxsW-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251002/202510020000.IIPFcxsW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510020000.IIPFcxsW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> lib/test_kho.c:59:44: error: too many arguments to function call, expected 2, have 3
      59 |         err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
         |                ~~~~~~~~~~~~~~~                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kexec_handover.h:30:5: note: 'kho_add_subtree' declared here
      30 | int kho_add_subtree(const char *name, void *fdt);
         |     ^               ~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +59 lib/test_kho.c

b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  40) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  41) static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  42) 			     void *v)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  43) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  44) 	struct kho_test_state *state = &kho_test_state;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  45) 	struct kho_serialization *ser = v;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  46) 	int err = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  47) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  48) 	switch (cmd) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  49) 	case KEXEC_KHO_ABORT:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  50) 		return NOTIFY_DONE;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  51) 	case KEXEC_KHO_FINALIZE:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  52) 		/* Handled below */
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  53) 		break;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  54) 	default:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  55) 		return NOTIFY_BAD;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  56) 	}
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  57) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  58) 	err |= kho_preserve_folio(state->fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27 @59) 	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  60) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  61) 	return err ? NOTIFY_BAD : NOTIFY_DONE;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  62) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  63) 

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

