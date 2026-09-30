Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAC0CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC986B0088; Wed, 30 Sep 2026 12:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E196B008A; Wed, 30 Sep 2026 12:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3837C6B008C; Wed, 30 Sep 2026 12:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 169F16B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:37:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82A42C0151
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:37:54 +0000 (UTC)
X-FDA: 85270985268.09.AA5CB20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8ED8E18000D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:37:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HBPo7vnE;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790786272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ftrtKkrzNTj8q1Q9dj1uybZPmbewW9e00JMjgxKT3Jo=;
	b=sujJgcnzK7AI6CrdGkAT9bVho0OUBDksRtZsL1+HtGGZx4PV2mKaxPZ0kZ1xLqZHE3GxV0
	qb41vP0c/xdkWZxfYJUK/KZRRuKUI+evmtxleTF+n6/5dJtpf46mAiwHxUZ5gTJNsEODJt
	5tAYLy6VkJCiVNHM6FLo0DVrZcqP3oI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790786272;
	b=Hm4zEZLLUEbPL5mBqe9QUJ95SHL+p4m88Dtsrz5FTWdaIhKlkl6jxkZy2lA0QlEzVi+DXG
	rDCrFyfPyAT7teG04qHBHTc2rClnFJUK57Uhw6RidkPNMHmY5lPGizFYjQz56PvWHp1mUL
	PsQR/JA+lGgaRkqQU/hhKBSO709QMxE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HBPo7vnE;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790786271; x=1822322271;
  h=date:from:to:cc:subject:message-id;
  bh=NHGLmzgTqg+atFlfLjNFgrrVr9jXYipGErdXaLGp0Ms=;
  b=HBPo7vnECx2p3UGXsvoJTAhTTiqqy6dukkV2XC+q2SnGS06HmcQAho3o
   Ib3huKH1acsZAxBcwNJmcUa1HZwMWIOU4JP7pKo8AbuWwU8FtfGzVRl6i
   tVhYwzz+73s/AmaQGVPUHMS+Qxg0hmB3l//TV9DCYcJWRw7T4nAptMkTE
   9oE25xhK0QoGj6KacVbdiv/g8VjBCPQ0pAOVVP5J7o4CjD+Dr8O8NLC34
   c6eUB33aUDzzdlJFKuCBqAOwze9lP2p5udtDPxEGQ11a1H3iKIYJJm8Bc
   ggWsuv4AJwuB/O71jzfZ85a1XKu95DCm01qmCN0JGyW60Y0wUNNFts5KX
   Q==;
X-CSE-ConnectionGUID: Fb0Mx3DOQUeCJPBQNTVe4Q==
X-CSE-MsgGUID: N2YYt5MkRUup8nsGSy8OQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90584911"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90584911"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 09:37:50 -0700
X-CSE-ConnectionGUID: Rnnulm6HRriijV502SoCMg==
X-CSE-MsgGUID: xJMbo8jrTE6yK3ml1AZxag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="280499999"
Received: from igk-lkp-server01.igk.intel.com (HELO 04362d00df5a) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 30 Sep 2026 09:37:48 -0700
Received: from kbuild by 04362d00df5a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBxJS-000000001vv-0vfY;
	Wed, 30 Sep 2026 16:37:46 +0000
Date: Wed, 30 Sep 2026 18:36:50 +0200
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: arch/mips/boot/compressed/decompress.c:undefined reference
 to `__ashldi3'
Message-ID: <202609301826.MFaFMsmd-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8ED8E18000D
X-Stat-Signature: onyqmyq3g6o3y1hes18djus8bi8pcj34
X-HE-Tag: 1790786271-829443
X-HE-Meta: U2FsdGVkX1/YF4M+YY/QrZgVIY0b3A6KKwXur6FoUPtfxSvwSylFomrARJPfAww/RKKOUq0JohVbn71V1JqF6EXTTAfatysODRhmR6XQ8Y9Df3ZIiFN3eLZ2BpeZ4sSdMiHsPd/qJI6QsC8U2ToMX10BgY4+5KGSAcUCJOD85tDN1OCsBfJ7xtKDiGwzia3f7qOhngxBWVKkMZqZE1VE37aN5Kanrn2sTqwtphYo4rxaggZZ448/dgzcKGuJTga5SeFE45XUmNLkXKro2dQLdEncyQc0CvNoQvteT9tIUwl7nqmok566UX3KOCXek7HxoI0y1aLwCQU5ZLihVPu1WUN7a8O6r2yVfhuAwZrG2ePA16Y1v+h0QoOlmdZZCkoxM7CJ4a+Yw2kqNHMId9IWcyvtoGgmi/JB/PAjL9hmpd/XAQgOwqp25bHLHUvLio+BPgebTq7xnWUPiHi9auPiHEABFe9Sl/VKJ0cQNB168elArse8YALtq4wrkbUG+WBEdjtUK57SdDYJTXvjI+DlgBtfZfzwoNNymOIEyDAV42DArDYcmej4fjD5xCcw+GHiQLQCdaL5NfdoRI4n46wRGDHt2OvmuBRfT+pHB2hnBoSXUI6bmDDyW9XLMpJ+5e0XWbFtEUIzViQqUW+zUmyjuoyfwplzSkpqcgAH9PYuQMHFh3gOQZ99qKp3WMk8MqNCC4VBfJ0J0oto0Ebv+mRjslkNskRMPajxgkcU7bNK1D6s2m7950bt++XecV3kA1xHHXLaETlUkuBt1ypZCELvgqSt4yM2hy8OXh6mYvF+/Ro9kbUH3lCIEx6c/+0TG1zHoMoanFf91IJuAc0MfwmY4WgwEHTs7EBljsJWME0QL+sgHsHhmlqzSplYjOfNAlrNX6xdEYA2Qp48C1yz7oZ4jzFA0Xl80nILPsqr11b2SgG8opK+UnboV/3h0eetorONPjAC0N4NZx8BXfEtgrc
 +Y9uEBTo
 aNDERflS6cqOpZ+rQq2mfaMTZzvD9on8hV6Ni7A9Isl1eSAA/hQglgWa0GQbr92tQUiiM2X7o3XgXbBNOJAeov9unak/jF12VpxNb2srp+u7Z4dfWRlUuzeLWDGnUHPf132NxiDKTKwtOiK6hORlDB/NZGwOW7Iaj+A+toE9eSepO7oZr4tStif+ItJBaMdtWap0e4NRo/whCfK0Ka7yPiPCvos6Xa3iqNqF1nBSq29Y3SC2gUe04tyZa4LbABD3/x1+wZRBAoKwhYRUQkEMkBZLLKUoFdKoBTFSZSs56H+FMFxcrxHnux+J0/bW/hUR/4gv2padNoL7/yUrF+ZO9ESWvPNSVKVV2r2bF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   551c722f40809618230001baccf219193e22fc5a
commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
date:   6 months ago
config: mips-randconfig-r2300-20260930 (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 15.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260930/202609301826.MFaFMsmd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609301826.MFaFMsmd-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':
>> arch/mips/boot/compressed/decompress.c:(.text+0xf4): undefined reference to `__ashldi3'
>> mips-linux-ld: arch/mips/boot/compressed/decompress.c:(.text+0x168): undefined reference to `__ashldi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

