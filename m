Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7023C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D066B008A; Fri, 24 Jul 2026 09:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34566B008C; Fri, 24 Jul 2026 09:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C5C6B0092; Fri, 24 Jul 2026 09:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98D836B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:34:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24A931A0399
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:34:13 +0000 (UTC)
X-FDA: 85023763986.03.152F0EB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id AA51418000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:34:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/fFo/94";
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784900051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Gz4viE8dOBjBXdN6lTFFvwoCis0aeCWu3yW7zM1hAxg=;
	b=Td6R0thvmBM8iLc4/8BJE0Li0Bo1bB5esUsVR9kfuRvYHOG3reLKpJbz7aOla/pGxWDcud
	OHHrxhwP8mkUhJhxjAYllV9J1kbp4DdlBrkJxvET4WUa8tZJwPCihJeI3w9YuXjwRvBT3X
	KIvhn3OGLF9YgiaCvFAIFbVBGD+NwAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784900051;
	b=kSco2iyIa4uVojranvNBvFNwYrR+vQW0iLkC9p/T2N58Qyh1WE4r1k0o7Jm1gJbkDbJahi
	1VdZb1A0PetEIbm8tsELj/9pAonvgWxStPvYCGKRt4J9/iA2nMMrUDXhNDJ1C0zCCRdVnA
	BVXtNUmIDC2pM2u6M9n2tpAvOcpyR4U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="M/fFo/94";
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784900051; x=1816436051;
  h=date:from:to:cc:subject:message-id;
  bh=HCi4xO+oZO+F1vmtPFTVqw36/Cr9j3p5ty+lqMpqkjU=;
  b=M/fFo/94Zw9zPQnivtJ6QUJvE7yUgAARFzlWiFDarBXkLkOYB4EvnKCo
   bNkX05dtswmYe6otIGlAo6gfkVLcfyqJTEHRFQPzaIu9B96wId+w6/hDR
   IZpnVzEzyKDL2oKCCiVkNYgKy6YeC3ssFq2alwoaNYU7JpxdaYrcdQh6Q
   8xz1ZAdZ3LJosFuGu7oNAuo5gp/84ZIIbsOXuw7GF838aXVdL9CrPHNYN
   h/XO/xG3xXjE0g1onSSLT1VAXmbRRv7uAVIIY2Hl0vxYQOYZmrZgrsikx
   Vn+VAtYgVkJmfhmlngg7lLi3wb3Tx3otxizDng6niazb6A6UgmD8k4PLc
   Q==;
X-CSE-ConnectionGUID: dYptPqqhQd2Z79bkYHy7OA==
X-CSE-MsgGUID: i3cheqYlRkCzINcr9t180A==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="89455821"
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="89455821"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 06:34:09 -0700
X-CSE-ConnectionGUID: 8yJCjbu3R+imxNNkEgibFg==
X-CSE-MsgGUID: vx2i6CJeRiWRKF1Kh5dX1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="259368202"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 24 Jul 2026 06:34:08 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnG2P-00000000apb-0AIu;
	Fri, 24 Jul 2026 13:34:05 +0000
Date: Fri, 24 Jul 2026 21:33:08 +0800
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: arch/mips/boot/compressed/decompress.c:undefined reference
 to `__ashldi3'
Message-ID: <202607242144.ZsfAPGBh-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA51418000C
X-Stat-Signature: xrkmfci851t75heeqo3ppsadymsq3y6m
X-Rspam-User: 
X-HE-Tag: 1784900050-764743
X-HE-Meta: U2FsdGVkX1/6TeYq7v5YdkLqt0zMPmJuFiOR6MKedLbYZBfp7GR8pWzHrmm9ixqIg99CNjOiPEKiYgU2jZrikRLtUsDYtwj8+MhOIsD8cvrYv9MnEuxbNVoY/tDgcfrJ7pfpv6OWJxyRxO5ZJcbI6ZndfprMdQZLkJl3uaSGNPt05spF1aUHNwgDVhS0Q++nJ4Qa7dD8kb2RmgTU03Ip44LWGzGDkHVsDA9YUcDYtFhJOgYMkn/Z9DLQjxB0QJX2yGxSSMv+iGXSnqNVTlS9VYMUTdGFOATXzP5Z5iS6GinY+czGhh+NEf8XtQ8+P+ds6RS9qhkmsy+lbg4ZDaP9c8JJUYOS/nDPVw+ARN+nunIEbfSGMubVsoFByzTVIM+sjoPxyGGpmfLMX5a8xEBtLH2lMVqoVUbgJRTxSq0uVTwbG6H/X5AZHSUPpgs7EuYcrRp5bArY/WOKWMA+pjKIvpB6JPvt+4FX6VkUWM0TN1BLV/mfEUI2U/ox0mGNdAPFC6VRpgMwLhvxqovEfiTtKVASWMZk1WdaM0T368D8/4AaWwPofgfh30zw1Xa/Ug2NGuls2n3j7n96yeSq+4XaKodbXs8WoCJxq2jMD22IkRsynnmlagu27+ZIw7MDwxWrQqLryByM2wPLIJyzvUQSjdAEla3xiZWyGEfDnW8fj7uzVNi+cH945fYbekHI8p5rRwns3sE3iJHmvIv4Fwaefe6AG37DM8/IdUNIT7teX/tlPDgV3iUTzBnLpQcF7jkL9Km6+5hIlSTqHpUCw895JzuS6iArQvhwde+93y2xH1vjCq986vP5/L9ibomntUMspUVupmIc+w5l11j3C6YdxanNUh4iccY63/8De5RTbjehD8PYsivi4sUxNvcoQQXCtIP9TEz20IWK1TgxxrA6uXzl/maHX7wc+9MNgHGdToAA0pi/TJ2rVb8+bCIHkGQsf26TRt83M8OQO2hewno
 R/h2/4bN
 49nnpbDHN1NkGV+sFZxnZU520UQsUCfyNF3XnPvEdAZ4RRWcU0JgoMbGANto7uvrJktGeYFoetKdMT5UMnjvXzcJ/N49CEI6YIC2UfnnWjn4MgcVgsssCHkxxIImxsmosgXMIxjIbj+FsfQyxUDDUoLrO7J1JHH+p+AJguZD34wLsBwgiEFXlwL2z0PnAA3rAv9MAtCSqr+/6yhZztTQ1OoI4BXNriJLo7/QAFZHvOdJ1LRbcIhi0gk7CRLdJjbRcmbrkgsbw8R44cObJ4DQ/qrg2MkSCNRbPzVGByoE3azPpnMBHMCi/Pp24jkLtVtxVXurcN5iTBMMZ3FFUhWl5u9ZideLLTMh08S9s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   4539944e515183668109bdf4d0c3d7d228383d88
commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
date:   4 months ago
config: mips-randconfig-r134-20260724 (https://download.01.org/0day-ci/archive/20260724/202607242144.ZsfAPGBh-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260724/202607242144.ZsfAPGBh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607242144.ZsfAPGBh-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `$L13':
>> arch/mips/boot/compressed/decompress.c:(.text+0xfc): undefined reference to `__ashldi3'
   mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `$L12':
   arch/mips/boot/compressed/decompress.c:(.text+0x168): undefined reference to `__ashldi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

