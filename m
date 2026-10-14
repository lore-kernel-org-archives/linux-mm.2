Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC42CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E417E6B008C; Wed, 14 Oct 2026 02:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF29A6B0092; Wed, 14 Oct 2026 02:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB97F6B0095; Wed, 14 Oct 2026 02:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8FE6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:42:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 045D7A6A09
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:42:36 +0000 (UTC)
X-FDA: 85320288354.23.CD131BB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BB2740005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:42:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OikpuoYg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791960155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Iqkl7+mdETcDekNy8MPDpoS4avTzxShOADMW8q/jzUE=;
	b=50cNX7UB6Zdth4mxUt/V3edNtDAIvaQ7XV/pMndxX/AdfhppVsbv0hPaq2BCEg/LC/KTek
	0XuijFKyNE6/uJSgm4JUm5nGsaY8kP700mqe2q0ovFLw4mgGBMm23lG1X/NLFZzsKUoRPC
	xwNk5l95khSipu3pEEtt8Sf8zYZGbTk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OikpuoYg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791960155;
	b=ja8lzpWau9nJjnM83vQad3/V8LCKCRpzqKSrM1yayZDeB+D8Wgb+2xoQzG7scAoBRzu75q
	G/Ba+ezXauJvXLswDtgqfnaEdpDReSvFpqn3C/rAaZPVO3h1T4Ohc5kqU1k5KzTY4IlskS
	ndO45JhNMqfd4XUnNYCNwLK0fJJM894=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791960154; x=1823496154;
  h=date:from:to:cc:subject:message-id;
  bh=ZRZd86mHacRp20fFhPVwjb/0qtXpGh+rKVDO89RpS78=;
  b=OikpuoYgzwYiH00qDP3vY1C77Faphp39FuI4fbu8a5AF3oOG9GtDBcJ+
   PCnks2g+xzQR2vV2en7gnN5mVbtrfWUK/r6tKg3GD08N1jcDhkLM93iPg
   lGDxSlpjLCjEaaRTVpOv1RHIq8ExmSmvjPKi5MvNZYat5DW+/52GnyjA1
   fp3cZKJLR+iacyn/yTBy96TwdRmwjgrfAorPoY26N04N+EKB96Sd3hW2p
   U5dHzLXEPGh9os+IHB61Y7v9ftI77SDUTxLt8ehVsTFLDBbTs1cSvceSf
   sbOyoKMaZJYOT9eDRrxCklTFiWF0+3aOaJoEZkuW2ZxJloy6RZ0Va0yfU
   A==;
X-CSE-ConnectionGUID: 5NtJVytXSG6rlHi/lg5n9w==
X-CSE-MsgGUID: sQFaC18zQ6m8JkBGGOXaoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="794273"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="794273"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2026 23:42:33 -0700
X-CSE-ConnectionGUID: BDcNKyVoR9yUfdACxEfAkw==
X-CSE-MsgGUID: TrFrtYm+T7OOK14m0fzi4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1290938"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by orviesa003.jf.intel.com with ESMTP; 13 Oct 2026 23:42:31 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xGsh3-00000000Asx-28DO;
	Wed, 14 Oct 2026 06:42:29 +0000
Date: Wed, 14 Oct 2026 08:41:46 +0200
From: kernel test robot <lkp@intel.com>
To: "S. Biplab Raut" <Biplab.Raut@amd.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 16148/16498] ld: warning: orphan section
 `.altinstructions' from `arch/x86/boot/compressed/misc.o' being placed in
 section `.altinstructions'
Message-ID: <202610140857.6jRIqXf1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 6BB2740005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: qtp7nixd3tsjjdxmfa53rwwzfec7aqgb
X-HE-Tag: 1791960154-954194
X-HE-Meta: U2FsdGVkX18Pm0owI6IzIbhWuXzZPXr44ikiS/G+Qshij0262cRUojlUp3/HSdCNA6mlTCfwGJscMHpIJ0MCfCfsrLIUKwBePMEIcPGtNiexzS7V17qFsfT2nz2iHB132IOYuzxvQF/uAhe3xFGtpRHM6sfiKx53ddsRCJ8aMDDOnAWMRAUA2BiLw0xGgbA/sx/hqplzWWDGbQFp5Otlu9oCJhJI1q/CIn7MLRbhJnOeCgSJcFshO3etvh0s0EPry45rYmoDDIy4rTRsxTFC+R9yxXjP+Xxkrea1h1TEA6kBAyJ2927hcoNb/fGtQQm8J62bpkXBxPMMl86V1rB0VITn62M7vcT8IwyyKFUynE+zs3lUpNSZ7Or9zMggQlzSeMbxU7THl00FBLePy3Sr0t61H4Rtw1wHE+j05c5ZXcwXxcIADICivT2/o4EuhSX40ZERnwAI8j7CyXBZqL0x9YQ+CtVFmvRegwAxJyay/G6YwNvCc+ZpfUx0+iIZzEIGQWQUW2wFJ1dYqQ2sqpQlSd/wKG9dfmYz5eEZ59v/LiL/AiAfXdOI5MGO1fpa4sD1Lit4DVaZqhdD974fJdgI8mvVWRGqOmHZ2eIIxWWRqdAprZE6O2M6v9WSVHarpOKdn9yq3jVYS0paht+xQ5hnPXiobV3G8RFPSkgcP+joj2JCECYt+rcAlzk/HZE+QFTyg9MIJOHy2TKg0spgDmKcqLj5/vz4fZePl2GmHHv1FaKU5A4CiXaJsv4/qmFUmd5bhpWR0KEkI12FxhCVTIpNunk4yiwtGIDSQBTBwEXUE5CZMzWfrq48DqTgvN515+Dx/3/VqsGVaYAn0pI4azWuV++uzFDgANUu3fGq91T1rW3Rkh4nMx3lshULIcxdCzJlJ7aioXBedeKmq8zqibHuxSjwJ2LhOsmUPgnC3PUQmgYyZ2VYF+hfuIf9TkkWfxz8/a75W7oI6q9bXoyFUzK
 34Q42ZyE
 lA5h+94sowbRAHg81Sa1x0VCYq/gn+1abDoLfq6dF0hO67A13e6PhQHRx3BZ5+odjzi5uAFMbSYmufjr2GECwO1gd9SDsNK/SuS75DFbCR1AXkKL4Coz+tKBivQagFsuGLvQElEz5sqNTkKaWx++6O8z1s8Iqk6NLarmFBarU25YwYrpiciD0ZtPMAmzzxL3EChAU4g3+P/DbNSyQ8Hy3faSC150XME20BnOI3+ANAU4jRD9Ii+CudxNMegAO0MfnKfVNWu/2/82wTO2oMvvUWB9mbldYwUxW2J38+gBWmCi/MRmgw1OuyF83uO3yA6eqETd9pKa1QxUcCxc+DP6bsGHZWiPCYjqsddB77nmQIhEPoIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   1fffefb00cc0b0da1f2ae24e3d33364530ea6515
commit: b575885f96602d24a127dd325dda1739ef6edd46 [16148/16498] lib/lz4: add software-pipelined prefetch to decode fast loop
config: i386-randconfig-2001-20261014 (https://download.01.org/0day-ci/archive/20261014/202610140857.6jRIqXf1-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261014/202610140857.6jRIqXf1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610140857.6jRIqXf1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> ld: warning: orphan section `.altinstructions' from `arch/x86/boot/compressed/misc.o' being placed in section `.altinstructions'
>> ld: warning: orphan section `.altinstr_replacement' from `arch/x86/boot/compressed/misc.o' being placed in section `.altinstr_replacement'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

