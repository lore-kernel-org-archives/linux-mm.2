Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C541073C9E
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 11:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FF8C6B0088; Wed,  8 Apr 2026 07:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0296B0089; Wed,  8 Apr 2026 07:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5CC6B008A; Wed,  8 Apr 2026 07:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBFB6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:40:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBA938B098
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:39:59 +0000 (UTC)
X-FDA: 84635194518.18.FD4D262
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0FCB31C0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:39:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=br+AjYMw;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775648397; a=rsa-sha256;
	cv=none;
	b=loS8TvJC0kA7rXFCszUzl5WlW/FBGE+E09jsSc1YQPaIKCTHOM9TVzsaF/GKLB86YTWFnV
	cqAuLxgHKTR6CTrHDlU5ZXJg3JGRZ8Wb7ol/yJlDj4GhEujV2yyWDOHmx/xZIbhI0wHCI2
	2D0WQFw8oB/dkZ1oRFM5m9hIioC/s/E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775648397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6g17erByoykGON+TSyBDmj0OmB/NMPGt5p9yi/Buldw=;
	b=2eXWaz8YBynYi/rwC49ZzzXHSkPjohJ+ezFYzS+9ztPrDfTPuWZ1TmFizfN0oPasT3uEZS
	N4INfJshS5zRYjnGxx4CTxUAwmzViBNcLA9Il2b2e1Tte+ekHfMwnMlriVoLEtO7WzMFUH
	AI6/HUsPjEj36Nk4QakGjHNmkwm6apk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=br+AjYMw;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775648398; x=1807184398;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M44PhwDlWKWyqOa96JhxJQdu8Mt5eTXDoByuV4Pch0s=;
  b=br+AjYMwn9QjA5V95xcsVsC2Kk/GmHSXwkUxcslv8mB9/MgYZSHC3Jjw
   l7i0s2p9t+pIi3rJvN5OBFY8StbMlQNDebBka2ELKmBNccsECYawXSJxp
   YmLEAw9VPGkNkDJwnmsC4odFSrTtUmUlKud8Yx7ZABXYU0LA9s3ACROwy
   TBatGEeioqxcCv+PHcmFEDthJUdK5i+wKPY0isiNIq/aw5yk53DYSo6px
   jElw0oaiuipHUcyDZTFldpXkdZ0ePXeEAippGIB9DBKTZAQ5nZYVSqz7v
   HnMVCiio1NX9CDQY4Ro6mmLOAow9zgmyLY2+YbPu1GBk/z13GYtDr7K8q
   Q==;
X-CSE-ConnectionGUID: mUWOkLFzR8ie486KvWezJw==
X-CSE-MsgGUID: hMTx5obLTzKfIWQwHSe9PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="86919996"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="86919996"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 04:39:56 -0700
X-CSE-ConnectionGUID: KWFlwwkLT9uaqbmyJtJbuQ==
X-CSE-MsgGUID: 1TqoiT1iTqu2scY79dY+Ig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="230116190"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 08 Apr 2026 04:39:53 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wARGA-000000001nL-3cxM;
	Wed, 08 Apr 2026 11:39:50 +0000
Date: Wed, 8 Apr 2026 19:39:37 +0800
From: kernel test robot <lkp@intel.com>
To: Shuvam Pandey <shuvampandey1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Shuvam Pandey <shuvampandey1@gmail.com>
Subject: Re: [PATCH] seq_buf: add KUnit tests for seq_buf_putmem_hex()
Message-ID: <202604081907.Ko14RCaV-lkp@intel.com>
References: <20260406033728.25998-1-shuvampandey1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406033728.25998-1-shuvampandey1@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FCB31C0008
X-Stat-Signature: 4wj73xrzmo5qa3wp7i8wen34h4frug9a
X-HE-Tag: 1775648396-181949
X-HE-Meta: U2FsdGVkX18fYBTagFxevxdLgfYy4qf/T3oe020VSffBAE7BNOK9PSIBZgFJqkgSTr/roLumGlSFRyTzPe0qLBEFPqnQ79CfgJbweGlwhIs1T1kX/SHs4uQ7fkq0XrMO+r/HYDiEMxQzfuXuINWrGqJRebF4tmVd6kEPplCfzoiditvw7sAsDR0ebcVgaCzDCvFJBNXEgO8/RsaTjACMiObl3yecwW/t6RftC1KcdnLx+ZU7YjhVTZuOf81z307uiEVpGvwnkDa5G2Sz1liRsw5YifROhAoGrJYSPA8BtbBg7/7UK/yo+C9O/jDyk6XQp4UywOBMTwMGbdgdHB2rO1UEsEpMVKZ31peU0DiDhqK6OOCMgSkXTa4dsiwAORvNS9NKuwMDNLaHz99wDy9BAw5UfD9SoU3SfbqblwtMTz5NAAL//YKpzqWgOFfR/7IMY2bQP8OdpFXLAOZINmmqI6hQ5XfhiilVgnSdFXldw8jWln7yftXV8gxI7ej722FoC7blFIeuNPk4LKGf/dKmI1FSahm4D70octHEoQCUMGCZak++Qyskwb2jJ9MenBFuzzOpZK4I7e+a2ycw0WQrj9r/d9Y/OJ0np/PMm7dXKkyaPa96L++IwxdncHT+uwls4+skHKh2N4CEkEMTj5ZMmJDSK2UwCH5sC7mUCrTpUQH3eLQfboVoYMLNYIv0HS2R+ZoTW1cNldzVGFMaqUEicSWtmLr6HLmhysU+ceBjx3gmUvXOEmMn83hlk/MPo0/d4jCbpRp02wf4kV4eDt4lsXb7J+2P02uuj8z5cmXnSldmpcb2e9A2TU+Kvk5Otfki6ewjolKEOLlw6N3Dn+AdA2kxly3aV8p9t45l/S4qUbOvAc0Mf9CgY1BkPXx+QniLKzdVAphsrbX3okucgxXKu4Il8SD1hjKQ/kax4lSdCk+9LrC9a9r43Is7gu0q1I0gaT/ULBSMiJA/cGrwQQb
 xdQ2fU15
 fXkxf9IugXzAT6gKyobRGAiH58jejyY+jYlbQF/mIsf8zGwWRhU9DtGe0y6RkHkaCjY0IhR6hQ4rgna/i5Ap0bmgEWIrRMWIPF2VHQ0vX/ZnN5koyJNgnWK4+t28calaa8dbofdoSC5lSyNpY7doe/TQfL6KsQXBgeJ5Z/UCGvIN45HIDFzTP7HiSJdLoZbZNPTCRMCJG0JhSmzARpDnTBvKoNbKM1VFxpPpF9GuhuwxqFPA8gPImRrOqszQ61Eac0U2RZ/nVB6toUZIrsyn2RxJy/LLau0qIL8BNmGN7JXm8zk4Fb+2fKDMocdHZ7uzY+6u1uh1LwAba/3H4LXrP95+uy8iSIARMvb7IZEJXc/N44HzvEcLQRPD9He9WvPn98eJtYsHCDcG4ZvwfQnA72VpcgF3U/PyhmjLM0/FZuPk1X+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shuvam,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on akpm-mm/mm-everything linus/master v7.0-rc7 next-20260407]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shuvam-Pandey/seq_buf-add-KUnit-tests-for-seq_buf_putmem_hex/20260408-090623
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260406033728.25998-1-shuvampandey1%40gmail.com
patch subject: [PATCH] seq_buf: add KUnit tests for seq_buf_putmem_hex()
config: arm-randconfig-002-20260408 (https://download.01.org/0day-ci/archive/20260408/202604081907.Ko14RCaV-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project c80443cd37b2e2788cba67ffa180a6331e5f0791)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260408/202604081907.Ko14RCaV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604081907.Ko14RCaV-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/probes/kprobes/test-kprobes.o
>> ERROR: modpost: "seq_buf_putmem_hex" [lib/tests/seq_buf_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

