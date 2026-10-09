Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6DACA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460F46B0093; Fri,  9 Oct 2026 01:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437E16B0095; Fri,  9 Oct 2026 01:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3787F6B0096; Fri,  9 Oct 2026 01:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1290D6B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:20:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 744C2120147
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:20:39 +0000 (UTC)
X-FDA: 85301937798.13.F9FD71E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id BDB50C0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:20:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Itjqv9VF;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791523237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vODWK2FmAv73Y5nOIKYDdXa7CANO+32pzRQ/FnUVPY=;
	b=dONg1x9SuKU7VRUkJG3i4Jn9Hx3oaSnIcZlLlq7q2+H5ov1BgvJNQFYHlxdOPSRzX+0i9J
	0gikI+BYRJww1YmEbBscPcg2w5f9f0P7L4m3nQf/oqgqAKcEr78V1+PNbiKORdTGQT7HE/
	vvMmkvn2nkaBCA4MKCJaARge1XPCcjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791523237;
	b=TRlhlI8romjgPwpja5tRTdkQZaEo4eBgF3tu2lQZ4f0I41XNHNhl5X64Avia+2wmXtm26A
	kk+ldLj2MeTWS1ex44x7gYTvAlNyExgy0Lo8bIcLj047W/j9XrNPpffvk9BBL/GUArTesm
	Wqx/FOgJWoQRbN+V1G80UKKO6ARfm0g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Itjqv9VF;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791523237; x=1823059237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xhtmVVGd5YK/g4pvEYSi0j/h86N+dnT8EWTbUFDzkeA=;
  b=Itjqv9VFmCN0devpkdACubP5en9ld7KXCoZZes9dq+FX271y5ni5u8aH
   Q86gUHfKLi6aCH5ndoYuaeQsGwRn0D66/uY7u3uM1IoKNESorsqlw6wNe
   MnSvp4mO2bfnR7gg9NwU+IxcUnaBua1DS924bNmnulZMQq9b5biLKzIUZ
   SGFLNl88xCgUMuvHFpOG8nyaSj+S0aEwFfZBiFiat7/rnKTgYTWMU/J0C
   LG2CA8F5tfQIJ6YlGDDuitBtBmeEHdL5iTs0EVyBsApD85ecTwoYRxboF
   Z0c1qizqmGK1jJ3Gn5CvY7GRPt5N7eqjT4UbLI5BnkdhgX9dKF7wR/lpQ
   w==;
X-CSE-ConnectionGUID: ilNqg45aSt+MT5SZEoww2w==
X-CSE-MsgGUID: xJs35XODRzeFEDT6AoM8Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="324345"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="324345"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 22:20:36 -0700
X-CSE-ConnectionGUID: ypCTQnOlQrOVDUGGrwXC4w==
X-CSE-MsgGUID: vaDae3PmR6CFJTkuE9r9ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="181330"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 08 Oct 2026 22:20:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF31y-000000005Ls-23w3;
	Fri, 09 Oct 2026 05:20:30 +0000
Date: Fri, 9 Oct 2026 13:20:07 +0800
From: kernel test robot <lkp@intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
Message-ID: <202610091317.jGUqplBp-lkp@intel.com>
References: <20261008152403.766439-3-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008152403.766439-3-m.szyprowski@samsung.com>
X-Rspamd-Queue-Id: BDB50C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4doaynf7rer84fptrmbxustcpb4qw8y9
X-HE-Tag: 1791523236-522968
X-HE-Meta: U2FsdGVkX1/MogkvsAyIWb0IUlz2fydPcebAsVjTsIx/CYjENlqee7pt0U1zNkskjrdOvFIbVhXXqloBw3IAY6RF+AjywSkFVSMaiFCTOLXXQTSR1Sg6NGHSieFQvoRL6h7il08OcsgfAQWofKx+TnETvApciS8SuHJHIDlmtDrm2GEMW+BB+ONWmuwVqcBAG+b+RMJ9eKFa1II0LAwOTZjdiua4Ajd4wOd/Xk18az8jls6E3vAu1jSirFtp9HECmkgs5jskgr+34Syh7cYK4nkoejhkFsE4Dda+tViJZASgmtSson7SU8GB0582wDwrngYzoWyIfbt5Hqw+eqfS7iUyJkn6TjUGBBZXGnsMnBsWiRk2ZQX9RoP8zAyhZrhIQlnRy64RD3jf6mEKBvmDby9NEqgS1MKPdFzXZXi9ubCdVZusWhBa6FoKRiGlLNEEksZJSGr4rQ4qXjVRCBt7Ud3T2jd5zFWtGjpSzeN2m2kLcZ+dv+txpf+sTOYPFpUs3srGT0KIPDKnDS99IxX2GWOvWn5zKq91VcnAULiw53ebQ9F+6PuXuNqP8LcqhhD4RkhY2VNGqbtn51L5XDLcJeGdOmWQNSPaiE8snSA+uO6mMzW+ESBBBgwiaa2ysUqPVJwlCP7srFBNRxHmIsKoEkxlFXCL7/ewSgcgDlB09alMMBkag5D4dUBJHALnBEVpRd06d5/bl0sXQaC4tZ809reeBZIR600aJZr2LwlQthl+apAdgfWFvMIPTis9232xgkCuStx4a0yIi76Wp85IkrI352Mu5a8QwyVm1H28aDl+kpt1Oo4e04T7YCHKbtwp1y++JP+UFOhZ8rePAhSIBmGH3YJnc/xp5i44gaB+wYBhLcsiMFSQfwP+5BGPQIhGUJHwDm/YIBdiK1RzPrs2A52o5rch2AyZfxaJIK7Z2iZCiAN6GEjkvca2Fk9pvn/h/dM1YloHyLRT54d/Vt/
 6qPFG3Z1
 ynPTG0bZQLODaaqVzRADc/i23G6CPpPk1qfHvORg1paFgeq/Vi4ZESFWB50M6xZBjc5cz6bi+znbU0cor0yVjC0n9x7cl5ZLNTltURDyAYeF40C0Ne2uKuOzJCH4d00iLaJcUyRdzYMTRRUhqWGqEgz6jUYX4rlVJpc8RE/lkTs8yFlCEalaUhUq4AYHT+XT+j/FdSgYSaMKX2Byg/CTl8ZLxFkMdweGhN55KBiT+zkcnjKsDDkPLKiz9uPvgvHrAFb/gbvYcP3rgSgYYHxuwGuNvHKUw1NZ+48yi9aggXG9o6PDWU9O3txRDx006C2OIKfwKZZ8dei66GzRRnDFc+sQqZtxecjhDTIad8CLCidWirAi2DrVfGGiFu/u2dKGORgzV78gGpqBj3FcbF91F1segARapwdlvjJiw3ksmglG53twlz2TyagE1017NHqUmnXoFVBfzDf8VHltdBkXDHe4aPQ==
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
config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20261009/202610091317.jGUqplBp-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610091317.jGUqplBp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610091317.jGUqplBp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/of/of_reserved_mem.c:27:10: fatal error: asm/early_ioremap.h: No such file or directory
      27 | #include <asm/early_ioremap.h>
         |          ^~~~~~~~~~~~~~~~~~~~~
   compilation terminated.


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

