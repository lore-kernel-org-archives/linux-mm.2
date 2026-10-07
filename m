Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0862DCA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 18:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013346B0088; Wed,  7 Oct 2026 14:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F068D6B008C; Wed,  7 Oct 2026 14:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1BE66B0093; Wed,  7 Oct 2026 14:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C46D66B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:52:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41E4412034B
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:52:16 +0000 (UTC)
X-FDA: 85296725472.25.8E4569D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id A6BDF120005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:52:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GEmUvvkc;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791399134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QeN9oUTaafO7UmZjN7Vh1EGSBW6kVaulxkFDbjo74ow=;
	b=Z7AwmLmFARtmjUjn+ShiFS355zO/7XBePDmj55xo2TUBXQbw2fidI1dVJLLGBuVv7RNWf1
	QsbTV9meZAzNnKoCrC4S28bS8uMjekA83M7gbpyzTogLEo+Gm/Z5OLCEyFBTVpRAntEfjN
	vCDFeYS8pSrNPrLoc0Xil1We55PvBk0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791399134;
	b=PukEN6Xq+im127EYW3j2l3MV/MfLFcKGMq0oJRNB8vPe48tt71hQW5uy68FNobwZ1U+Aca
	gouVjG8PblHChCWH7e3lvt1eQDBuLFm1JnLlQQP32i57En3q2SVhUJZ5KLUhlTg7daUH6+
	dfEX4i5IqR/Ho+SrI5qTSSMVJ9LLeFU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GEmUvvkc;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791399134; x=1822935134;
  h=date:from:to:cc:subject:message-id;
  bh=Aczl2Kn56t2w5o8v8jj3PV4XKlgV4w0VSTuUcFGh+fw=;
  b=GEmUvvkcrCyAnRAWDsWF+/NrmlKDTqVJBxETVmKRcJneEUlMzTNJk4rN
   x2zxGTEdwazRxLAM3autX5cRfyxlwDqlQr8MvkrI1U2AnERoU9Ce+esef
   zJp4RgNtyQW0iQ2S8AgIwvt+YHAuXWsmETEpcxYhi+dggpSC8ADSQpyTS
   8u8feZ8oxwAvjm/UCWN3UgLHUcDy4uoivaFNyVQAlQy3HtIRE/qATf1GQ
   xrncezXsGpJmeV3TMI3fHDBNA9l2ZWIEbR7kt+sYVoGUXJvNgy7wpB9Kl
   a6h5YDkfRFJmB3JM3Q91DMWYtHAn5ZQG+ltIfvkwcNBlOmP4DyAxbT4LV
   A==;
X-CSE-ConnectionGUID: Rk4g01mkRHy9csFNId8wbw==
X-CSE-MsgGUID: cIYYlk01TS+6K0sw87iXXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="54775"
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="54775"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 11:52:12 -0700
X-CSE-ConnectionGUID: ZtZr6X9NRJGrpr4kmkQ5Xw==
X-CSE-MsgGUID: XQOKsrmSQw+j8AbsWvzRrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="1604944"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by fmviesa012.fm.intel.com with ESMTP; 07 Oct 2026 11:52:11 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEWkK-000000003pt-3xIA;
	Wed, 07 Oct 2026 18:52:08 +0000
Date: Wed, 07 Oct 2026 20:51:50 +0200
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: include/linux/decompress/mm.h:(.text.get_bits+0x58):
 undefined reference to `__ashldi3'
Message-ID: <202610072038.5a9xpYG7-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: A6BDF120005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xufiub49k1y7gxtixg3x85qzwnwp37fz
X-HE-Tag: 1791399133-710851
X-HE-Meta: U2FsdGVkX1+zDtxRDNBAauG5wqz+i9O2yUlCW2ovggka1v/h5Aajjg7eKe/Y1wfp58rd/N1UnioFl7JTfTcM8dIQ/9tQNzua/BQTFnuF9p9QFt1uWjSgE+jhXg1heqL2vYWrtkFZepvwVmpSLM/fm36/yY6N5t+elGqmRks/lxaHD64G/AuqJ+Fw35tuN5BKHHrDdForFS1sDH3SiZ1ccCx9e4jBdl7xLmCyRueoSMbJ/l55KannRM6SvGke6DMRUIRUiyI5u+LEV9Nfd/uMxDjFiokzvWBSBrnuF8fQz8fMO1dG9NBLcnMDmM8QJu14my2XpdDwNWWyflqYnKjA2FpxMxobRq+DQKmzFmmtbkRWUzh+EtFgFyuB/9e+0R8ByEMzGVs7naLExY/P2n1+5PEz/iktLBkRXyCbfZutJCcmdXsZytiIqTdFBvSrkcVSadVVS3P8EDoUd3/YIWUcXBDKWCzfZ9l869pu+drSTBaaxNKvHgxvXdnXtLgyxHIyKWWrVEpdz+WU1c2uAFZ7B8m3hcsQynHSXdJYWgNjXYffCsrtHsEtlSyc4vaA084DMO5dsMpyIxhk4axNJGmGUQg4fEQj8WrEXBkfq+iBlWL6OyAoxeR/F4ieMeJD7g6ewKRDPmvIOUscO/0avkNWfxadioJbLGC7yY4LI67eIP0AaiFSkJfOS1JjRQww/Y/HJDNyUcXD5QT3945t4VEQLf2gAa4/redsXgeR+pXc5r+GdBHfQ7EgRhJhgeNndAAwZgKE1WJZJWenPnaf0ZB8HmIOF2W0GmaErAdowqRLi4M0TG/UMVHevflVfqNGQCtmfLZ9B5KS13XYmNhHx6OIT1TM0s/WJQ+bz+zuTgKjLd+INi45uNAwkYmdW4E1eTODnoOJff47+MzQTTWg3sFDEpYLIYaNWhvembwSuNe2p3pohA/kF2QUwyZu18559rKSgn6tX9/xbxdN6OnoCeB
 TzmSlB9m
 NNEnGYT1f02xyIBmMoYHl9hysV8fRmu1o+i4N9p8BjGkEamYRMvcbA0Rymc/NiH60SZncBZsIHaf7xFgLs5OnaIJRN+rJEFxn+bPzav2M+xUU+5KoNVq6NWG8jvo6UfMSSRBp/VMBRjRmqnHZKdzHmchDmp2O64ICVBJqNtShC882AYIZ1O8YIdVgb7ePQDy/BMe6BEujJtttouoIohTkrjIi3WldS1rPU9Folvw47IUt3/NJzy+c0DiRxGwU4RdPWbZEeZUxoK4l2exH0IAiEbR3bsgCVcuhsUAdmXGK4uN3OGWTphOWaL1sdXm+bzqGmFUYlg8h1DBNxwR1zqUdV0iHhulxo8lk0eE/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Josh,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7b63ef2d55f24519e7e9e5f4d15dbea03f126e40
commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
date:   6 months ago
config: mips-randconfig-r2308-20261007 (https://download.01.org/0day-ci/archive/20261007/202610072038.5a9xpYG7-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261007/202610072038.5a9xpYG7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610072038.5a9xpYG7-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: mips-linux-ld: arch/mips/boot/compressed/decompress.o: unable to get decompressed section .debug_info
   arch/mips/boot/compressed/decompress.o: in function `get_bits':
>> include/linux/decompress/mm.h:(.text.get_bits+0x58): undefined reference to `__ashldi3'
>> mips-linux-ld: include/linux/decompress/mm.h:(.text.get_bits+0xf0): undefined reference to `__ashldi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

