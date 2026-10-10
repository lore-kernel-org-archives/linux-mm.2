Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3444CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 01:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1D26B008A; Fri,  9 Oct 2026 21:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262A56B008C; Fri,  9 Oct 2026 21:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151826B0095; Fri,  9 Oct 2026 21:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC7E16B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:50:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AF0C1406A6
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:50:24 +0000 (UTC)
X-FDA: 85305036768.07.31DD179
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 935FD180002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:50:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TmLPXuVS;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791597022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bw7aOniwS5sT92Ud68/2RfQP9mrvdk3qSlLf+3oG5Hw=;
	b=V478+M81EVJwe0/rlV8twBXwQl6llCSM7pLsPhBPYhN4lxwjckEkEmEqF+WYY6eqQ9Hsbq
	B1Scwyrazekhr4Nchgy6r+xuk/JyrhrLz/223sjJxG/nDjuAkk3pak0wj2MgGQg4cwTCfX
	JuY1q/vWXactvSarhjL4yoMWL1+NCqA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TmLPXuVS;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791597022;
	b=p9AIZ2+po4szhisdFUnRTyk+W8PAgbvHW/IEha4kJXqczJubUe0MDeWFNg7pw+S14q4ZNO
	EtjrvMTGIvrp1gMhonN0BaglmAXt9gO2PAuMBzz2tu+EUwT9t0XQJBg3qj7j+i9fDI5szU
	QZ8Dlrjj2nkNiI0qDaf4dm9xiGwY1nc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791597022; x=1823133022;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xr7BFcuPfN5hxzlUU0KILbgM3T/srUjFVBe8YW5OnqI=;
  b=TmLPXuVS0ct7BhW2z+6dVd8ofmMlWovjm00u2hqmHRRFK0aa4UTQMNxH
   yh6jGpbm8isBxcVDl6vwzIlvehgLgSJwHNMFkgzjGjLvSqPLx9UErgD0e
   GiZcReWsAZsG59oMm/lGkGOnrJejzlZ60+/Hv7VpG1ta2AhZc0Z/22eFf
   35sQppPbO/ThRB6ipVAwH8LPkSqEEv8ZpC+LUT+0zfzBsYl/774KJlP51
   z2HP3iLGBYAuVabssinh4qPLcoRZ5raIOIrV8SXkl3+9FCspTntchZ2dM
   oOl1+wG2+EuOOYlzsO7KOy1fqe7fKIWffc9OAt3VVdjlK9fsxU194qkDw
   g==;
X-CSE-ConnectionGUID: 6VlfGF1MSwGRzl44DNxQ0A==
X-CSE-MsgGUID: pK5+cp/5Rh+h4UQINRXATw==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="392482"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="392482"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 18:50:20 -0700
X-CSE-ConnectionGUID: sDLi4PEASumchOCUfOXSpg==
X-CSE-MsgGUID: m2EQ6+o0RkuxgBM+z9aDvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="802347"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 09 Oct 2026 18:50:18 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFME2-000000006Og-2tcr;
	Sat, 10 Oct 2026 01:50:14 +0000
Date: Sat, 10 Oct 2026 09:49:44 +0800
From: kernel test robot <lkp@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
Message-ID: <202610100950.LlAi30cT-lkp@intel.com>
References: <20261008152403.766439-3-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008152403.766439-3-m.szyprowski@samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 935FD180002
X-Stat-Signature: daf3zzistd39araau77wycchqcfzds46
X-HE-Tag: 1791597021-105707
X-HE-Meta: U2FsdGVkX1//cA3BGR5jeHrjYD1KvuiD6Wc9iokWlQzmmFjtAu1QKyaZfQJOtKBrIJXgSDh3cuFFiR8zOroGjuLBQ3Rhn51WlqGW5pYKUcRTqCISaKllA5J3Tde+jhbo1HVSDWWBVkD4UCNXdvqMebQ/wqqzdW38ovKGc8N1VyGIw3q6YezuafUtkWc4T5/E8Yur7kGhB1E2pMS1TjXvKhXJ0s/8Y2V3T/GwHs//w7Vis09O0lRmYC1uWOAucvfHqgFkVtK4FRYEyrejTr9q+pnBLO5e09LxjJ9lfJ8fpwBcLm8lbtEDojq8JkLPg6STV1DP5e5KtyorEHzQGtxcC4Rd7PjRsP71xWGLUAevCVNLhP8/q673PQ9ykwWm3+5vAouf8hKUU5KPja/i1Qxivf0qp1kC7mNGdLtcnjYJy2/uJVN680Uucael+zTfdb5mu20EIU0kIAy1/bGNfGB1u4UOr6nwsx1uZ2n5+upEjt825ozzeqN3jqdRYIcduPWyrZWDm+R67FbKBBgZnDCEo0yuvqeJqS655CFT02SJfdQf66fsndamHAZFe0nfyxV+Fd9DH0/V4iAfsto81DLtk93g/VJ7TUG9rOjg68OkYYuEwE0rvZdRHFLj5I4EkXia9+t+WnHWY2SYMEF/JklxVIpMoE5BCTY2Jo/8al64gWljFbLrTmDVOb0h6rgREj4v2d9bJURxozKGMn/dCONEwf/VjPm2CsDoF3L3aB/EGikVIZBU2ELHN4OFrz+ILDGtwVaglqT34bYO6p4ZKpKmCZZzEyUh/cfTMtIe8Q85pIbxK7UQ2PwCY5jwhAknweSQnWtI9YO14VBETrZnGgwk4jsr8j4c5u4TYgjW6iaQKckf5EpRiRkyJhU7CNwWIMPluzOA5F1JIilMMJEQ1EmjBBrNDRXSDQ+9bi18LeR1MA4x/QpApEseXHuWeKxn11F+3KUCnWKW10CJzKiuBg9
 wRp9yXeX
 OXIq/lVbuA8On+pX2X06FbaQfWGJ9Wa2CGWhVIjONkIwaL7Ns+fua8IBUqCOsV8VNY9+JZFgCF7zFvPuKCcdLn5hwj+hXX9SNIbcJ60gSZflw1SUAkklT9vP6Bs8uanXcb+qllt09aOdV5NZD3N+tl8TZZ/c4Wy6zRSLbNtvn7g5AvxsLHkDSXXGGdaiH2NqJZN/4qbmwyxCrgV6Wk6Hn1ZHC5GqV88RPj+7cv9pwBz/aED/iiKYQaIWNXdqyfzfWlMefzlQBGsh8IHovDhUkof1mv58BRBL8N2gvZnwVT4sEKBEBnZz6Jx69tEYziHRB80HnzZzdHQcmYFcwVLOF2ZvAUnLAVRQFS49JmlqBmZM58PZW4dcFmwZ3BJA7ONu6mm62mkk35bwOBcoKc2wZTrdDEkWU9ltC4JNoYHCh/IrIvsFAbLALfxqNjLVYPlZkV+GKl9Hobo6eZZfJ/gkoifzT9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marek,

kernel test robot noticed the following build errors:

[auto build test ERROR on robh/for-next]
[also build test ERROR on linus/master v7.3-rc6 next-20261008]
[cannot apply to linux-review/Marek-Szyprowski/of-reserved_mem-group-allocation-helpers-together/20261008-114122]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marek-Szyprowski/of-reserved_mem-group-allocation-helpers-together/20261008-172400
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20261008152403.766439-3-m.szyprowski%40samsung.com
patch subject: [PATCH v2 2/2] of: reserved_mem: allocate and map the reserved_mem array early
config: sparc64-randconfig-1001-20261009 (https://download.01.org/0day-ci/archive/20261010/202610100950.LlAi30cT-lkp@intel.com/config)
compiler: clang version 21.1.8 (https://github.com/llvm/llvm-project 2078da43e25a4623cab2d0d60decddf709aaea28)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261010/202610100950.LlAi30cT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610100950.LlAi30cT-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/of/of_reserved_mem.c:27:10: fatal error: 'asm/early_ioremap.h' file not found
      27 | #include <asm/early_ioremap.h>
         |          ^~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +27 drivers/of/of_reserved_mem.c

    13	
    14	#include <linux/err.h>
    15	#include <linux/ioport.h>
    16	#include <linux/libfdt.h>
    17	#include <linux/of.h>
    18	#include <linux/of_fdt.h>
    19	#include <linux/of_platform.h>
    20	#include <linux/mm.h>
    21	#include <linux/sizes.h>
    22	#include <linux/of_reserved_mem.h>
    23	#include <linux/sort.h>
    24	#include <linux/slab.h>
    25	#include <linux/memblock.h>
    26	#include <linux/kmemleak.h>
  > 27	#include <asm/early_ioremap.h>
    28	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

