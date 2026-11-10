Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38691606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=S0eESyzu
Received: by kanga.kvack.org (Postfix)
	id 4B2896B05B2; Tue, 10 Nov 2026 13:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A616B05B5; Tue, 10 Nov 2026 13:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379976B05B6; Tue, 10 Nov 2026 13:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 170036B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:17:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 963B780A67
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:17:16 +0000 (UTC)
X-FDA: 85420016472.25.568E02C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id F34FB80004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:17:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S0eESyzu;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794334634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=uVW86SaIsVQ1pRfuXiCieb6sjN02/CSz/lkj8IUV8/I=;
	b=cmVPBvVvDfzlZ67XjqolmzH4SLpU9h4MpMaAg3XePmWrFOL5kekOQNBwxZd9jpRNha2FXC
	mtG8RdjOTJMjNQWBA/SSZqulXLhUbRH/iuT9yiJZdbHPQidUtJxy+uHfTgemWQXa5+oWZ7
	EQ8QLkK1N01hO5vIMY+430dEWWCWczs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794334634;
	b=tKSnXJIVCTjxe16S8tu13PcjFKjc9UGZmhKan16vqpYxNOCjQe8GVoY+yVJwlnaUwCumK3
	fRgRxdIRkf3DiIBS9PwBhBTeaivoamg39yGrMlZjDTeVahDLxYZu58WL3aZ5p2VoSdw2h/
	rKTVaIhEcFelIrqXlrqNT70ga81j1Sk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S0eESyzu;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794334634; x=1825870634;
  h=date:from:to:cc:subject:message-id;
  bh=4HfgLbOM3A/ev4u8W2Hzd/Y/C0hVfaFcq/wgf+gEoKU=;
  b=S0eESyzulZq6ULYc00PXuMalvcrS5kyXMYreTfwRkdEcDDhosKUNKj7x
   G8psNPbhjNmw/JS+vQodtKGASJ5p+opu1fIs3v4CT0nGzr/Ny9bcIlMy8
   BmNrG8TntFBwt4MD9bt7maZypok9cO8EOgUPG/3aR0ovomh+h6YXicLX5
   V0A7SC1bD0J1+ZDPM90nPmaDB6KMFJJp9NdDPncd/UcmX5k+xqCUx1qaj
   hYiEPKpmA2IKnJQoN8dzk2v8H7/N8jT9cPBHrDlvTDYmDJPgCIBoLQcFf
   sZnGQR3am8R4l2TkZsiVoUlKGHKclZdmMN3Tg3tjPg+XWYp3VCPBw+GNJ
   Q==;
X-CSE-ConnectionGUID: vxxrN8tSTyGd1Vb/fuTWhw==
X-CSE-MsgGUID: ZerwsmssQuy3PWXS34MYCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="3112026"
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="3112026"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 10:17:12 -0800
X-CSE-ConnectionGUID: GlJXzI56S6i2HfV891mHeQ==
X-CSE-MsgGUID: uCVtrcNwSZSLR8uxhBhpLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,206,1787036400"; 
   d="scan'208";a="8085574"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 10 Nov 2026 10:17:11 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQqP6-000000000KN-0ES8;
	Tue, 10 Nov 2026 18:17:08 +0000
Date: Tue, 10 Nov 2026 19:16:39 +0100
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Nathan Chancellor <nathan@kernel.org>
Subject: WARNING: modpost: vmlinux: section mismatch in reference:
 __arch_xprod_64+0xf4 (section: .text.unlikely) -> set_reset_devices (section:
 .init.text)
Message-ID: <202611101916.F9L97HFD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: w1dtdwpjafnm4jnor6fcp3agpceserpb
X-Rspamd-Queue-Id: F34FB80004
X-Rspam-User: 
X-HE-Tag: 1794334633-891136
X-HE-Meta: U2FsdGVkX18RelGQOjrytU7lOFVGjsOu1EedVHDidC3JzzcDQSVP4J9MbCImYh/u/2qnUf+tGaIuKlMcXFnuZowENb9qMzU6BLMv4bxo0gK3+8DUshymDLRDawNxpyizzM820si+FKdqi3rDmzbJqdbku/a6cfaDznYCfg5Iz9tvEg0e4OxwscWpRXmFNqo+UI+GaUUdbb2jn+057lP2xwGBGMErcq8tv4yqgNjzscfPbUQdr80xNmhyk2oZco3n4s0Vh5YnWRC20JvGjsN3fNWpx+i+z3gp8WUqUZ+1lma1AH31FSFgi1U3jaTFkK/L5Cwx4iiLGIp9hzQ7o6cdCHzCgSsFUOVUNAQZwF2EMHy76sd00TIRcCmSgyCsLtDf/MwbQevQi3L7lmPmKU+guJXlSWSbLdpGvEI/k0lhKWR6A+u03va49laHUPuLUV3CW7bw4f0miGZL2mNt2DMav1IzISl7ze9vx+KD5zdjlp6GuiBvWtVi0oGp/9tuOGjQHWv3o1Q7qxVlqb34/h5zmvHv6etNGmZ+o4lYJokZ0CluJ0hTgaGbQ/CmO793pnZ7ZKhTOTlt2nD5ZRYPQl6k4ih8LZNdi9NwrccSsA25MejXvPjK6e5H3m8sdlRKJzTQKF97T6LW92AfavdhG1TAXmQ1110HLy6HWOeGXu1JspM7Pu2+uWW+dDq8dggoYS9qM2FooaoIA8GmkyvrVuy5/jmDp6yh5+sb7xiMfjTVFVi0eaQEVOs8/ocGenDPV6mCfP/mGz7gVu+VGmEEAx1L6lC6X+jW+95oVRTh33uOCt6kcpzB5DBiHkcJIvVzkpf+H/jNNU+8rmEUhCIbtnlcENPeFpecCwhznoKNYQEduMYJz/N39FfjRKxyuo46hjCQq6fts/phdpdEDjEcNFQK+6dsNUCjmTphtjcpyhSyDexVNjtlGWLjXGDzV55JukKuCDP5QJFpOaAMKaVF4fV
 d0r5UKES
 OBD5kLtgVYDRvAyPpS3djq4cFZCH6xsvytYoLVCT4nSDe1WPV8fysKg9/1sRveOa5WGf4EsjUy4U4hjVgLExynbPRJPb2XZOM8cthJHU6SWdoHGMsYpvL9OM5bw4o1UefNTJhavftV+IuGze2/Vp2mynBmBVqTq3v0FOwL8OIeWoMZuDXBxobG4sti7cI+86fTfy4mWCLAkWZB9gNRvDNldTVPxiJzHg/t13hgV+eygUEj1rusY3yTDGDujH5C85eLuJlXsHwy7lU7XKCB2qlUSX/LC2eNeE78nJJLTvCPU2eJ8bKjpL26WTyWSRbMyRrWO9NwqIPLvKGODQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Arnd,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b3dfbde62cf1981c4638939c159dfd087b7a72e9
commit: 94bfc7f3b0c7c33331ba4ff6cc64ff309dfcbce8 err.h: use __always_inline on all error pointer helpers
date:   5 months ago
config: xtensa-randconfig-r2111-20261108 (https://download.01.org/0day-ci/archive/20261110/202611101916.F9L97HFD-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611101916.F9L97HFD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 94bfc7f3b0c7 ("err.h: use __always_inline on all error pointer helpers")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611101916.F9L97HFD-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

WARNING: modpost: vmlinux: section mismatch in reference: strcpy.isra.0+0x30 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: __arch_xprod_64+0xf0 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
>> WARNING: modpost: vmlinux: section mismatch in reference: __arch_xprod_64+0xf4 (section: .text.unlikely) -> set_reset_devices (section: .init.text)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

