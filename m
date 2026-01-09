Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A6CD26D99
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 20:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB666B0088; Fri,  9 Jan 2026 15:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479416B0089; Fri,  9 Jan 2026 15:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35ABB6B008A; Fri,  9 Jan 2026 15:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22D736B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:32:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F0E7140886
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:32:47 +0000 (UTC)
X-FDA: 84313573974.18.E153280
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29ECCC0002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 20:32:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I8zR1A4L;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767990765; a=rsa-sha256;
	cv=none;
	b=Gr3cWsVZuNwdt4vk9VGkzl1w8TI86zUjNL+8tCUa07IeRq5JXsMLyIynsUzTbw5UQ8+iTT
	iZxRZo3zQTWNBmldhGdFQ183eHRFR0qX40Ghuc6IwkpUmvsm74h3CSn5tjeHtybGFEdzdM
	3b65B0oeMQvgfBENcZxU5cIXIkOznHg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I8zR1A4L;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767990765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=4QuaRTWoTORHl3RpVORzjau54BYa8Erv15y/Uth7+NU=;
	b=A430fE6AG+JDRdAxF9Vg/FN+ZZBX5Sx7vv3PhmF/OH45hCj3C6MdeeU6pXBlSoWhJVnFqn
	f9296x+w0wYyvoWnMaYXR2GnBvweZfQ5fhN8lXTq6KVtlnJmDVcURtx2f5KacdCrdGCDu0
	ozq/dbbxgmGaIsqh01WdZ49JXHsyMeI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767990766; x=1799526766;
  h=date:from:to:cc:subject:message-id;
  bh=vfTuY7p0m0K6CNSUC1cZoGmv3GGrNFOdYUFAV8eZnYo=;
  b=I8zR1A4LLag1BswObNvGb1Fwxjtw677G2hHx8/Tz4DvvWLxJdDwVfyI9
   qFUiGwQImwVfIBIHDFg38f1splyJparU6DzBbECaXdv1lufmqK4a6xV3b
   lByadAoV1hNEUCprdPC7A09RCia5zk9ejCXPiCD7qwuBibxsHRdMDvNYw
   XCLUM8W4GwESjv7CP40K9JgADjfEA4z1LDB81W0Z2XQhK/AjPI5aJ9f+D
   w1vzKMw0rzfwQhUs1R9bO5w0P528zUWzZFHuaMu5bxolCpT81rPj1Xrev
   KmYE9AJjGHjC0vLrhyjNRqkuzhGMfFg2MR0335xxS0EldXB9s9HHGSoNP
   A==;
X-CSE-ConnectionGUID: YP45L177Toqx8wY4xCKREw==
X-CSE-MsgGUID: 1oiENuZ4TDedtbTHG+R0Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="86794156"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="86794156"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 12:32:44 -0800
X-CSE-ConnectionGUID: CPLooFm5RNG9KJApWhnMIQ==
X-CSE-MsgGUID: OANIqPalSd+ziDQGckD+DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="241059785"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 09 Jan 2026 12:32:42 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1veJ9z-000000007hd-2odQ;
	Fri, 09 Jan 2026 20:32:39 +0000
Date: Sat, 10 Jan 2026 04:32:21 +0800
From: kernel test robot <lkp@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: {standard input}:20429: Error: operand out of range
 (0xffffffff not between 0 and 0x3f) `l.slli r17,r17,-1'
Message-ID: <202601100448.3PrAP6KQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 29ECCC0002
X-Rspamd-Server: rspam06
X-Stat-Signature: yo8ira9hzwia18oarr5ytxf6f1fwq8pc
X-Rspam-User: 
X-HE-Tag: 1767990764-409364
X-HE-Meta: U2FsdGVkX19dNv5hFJboWrMLR4KEhkVPmHmxQ2nTCDCiUdjN5S+YmIpLLYn+zp6k6IYbnyFUS22FgU+xMcKFEiCjwrOl8RR1S6uxyNCZ7URJoFbiOPp5wI7ntKX3DthOHReXv6I/Zrzjtb24Z/wYTI5KShBdHWR7BCN84LI0/Rdn5EnG/NS5Qq/BNRDHp/EVHtSVPgad4r8v2n6e6X4m2fqrsIJCJlTHfEG+tK/24mWBWty+b4o7xb8pZXMOSqcRQpWlSnzhe2R3kf834w/pxHEloalNyUFpIpyuygkOmHmpYWFBjh9Leov/ONEHSh/RS2IWMYvsWw7HxOUfBWyVmpH7UtbwgyMYsUN18A35xdqzCX3bHI6FVhRPoEPltkr4sBNmAolg1Ij5s8IDVqjMFHovjH9SehNjvsQi7snhSJWVUO5D9lElXNN8/tf7xY0Azypa1rC5J7Pk8uIv4zlFyi1lQrolQ/a+OVseH9RjEz0jKlY68FppvIebRT4K9cDwVuSn+oDmwjrbhRYkOTeMGAIGb0EZdjnlj+AeaIV/G22mughgo6zVb+AENOOXd/QjtUyiCjLceSfIJRZtsAIvW/JEeDj+n9ZOPSj/Mba1X5g3x84lCfo34IIZoarxmeoXh2zDugD9RbX9HFtnqPwnRSUCgMoxz9Rnh+wZXYnefgoRiT+mFyZ1oDo5H4tIYe9mWCX62InUPquY+SzglTKMNIl8pm9SmVekPBr0yYPymn/A4klOUaI5dZXcch/4Gj4ynWdQo7ymyjZ+WBXM5ejcG+CRV78uMlbUW6u61V9JPA/jrWW9e7O1fCgpYL/Y9mAkRVgs9cyZb4iN2BuEmD1iK6y1CHTJyy/pFkToc3wpJiV4xrkBpVd74epaHq0jXWpTI14bvgUBYXHR6c13PWbBV5vbAYTKfNm7xfbGrqkBvIOBlOSnvV6YqOgnw4WMkyEu9D1POeqI0MTsMlL3np3
 saaD9s5L
 HfmHdNtwKryp+Poh8uGTibOZhdobTifADhlJHqxftd3M/NzgGmcJagrWHgdxTpCNgF4e0RDQWSvq2VMSuWoQs4tqDpThcgdSF2/NR8KipnW+St+5qhphDUqgbIyIMU7ovevIE7bWaqn4sK4zIRISAr98sgQlFHhKuPW8aQo8dCK1P7gPs00yWaRTl8hdj/3dl6XE0HdRYgK0FJis0m1aMUI6mwBzDy0X1kYtuyA+eC6hH0ethRIeFiq9KwZcDXiXGulHKcMEfn5Wi09JodMtjp8jS1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   372800cb95a35a7c40a07e2e0f7de4ce6786d230
commit: a211c6550efcc87aa2459ca347bda10721c7a46a mm: page_alloc: defrag_mode kswapd/kcompactd watermarks
date:   10 months ago
config: openrisc-randconfig-r063-20260109 (https://download.01.org/0day-ci/archive/20260110/202601100448.3PrAP6KQ-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260110/202601100448.3PrAP6KQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601100448.3PrAP6KQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:20429: Error: operand out of range (0xffffffff not between 0 and 0x3f) `l.slli r17,r17,-1'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

