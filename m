Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F34ED58B09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673236B010A; Mon, 16 Mar 2026 00:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6208B6B010B; Mon, 16 Mar 2026 00:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F966B010C; Mon, 16 Mar 2026 00:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 401606B010A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:21:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5A1B140DE8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:21:15 +0000 (UTC)
X-FDA: 84550626510.25.B5B00BC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 177C11A0007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:21:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ewn3TCZT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773634873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=F+GKFg7SYKIX3/MyQGz9jGHELnyUhEBMPGUzN6tbX+s=;
	b=JVuhV6oWdOEqPk/t9V0mOs5SD+5Gw7H9bpOOQgbOXB3vOEy5RFYLarZkv3x3/kiSIWoMtY
	STQxX1f3ls/egKrI+eYa9PZGcO/tP0pAsqsckVYaN6TsKtNfpjvQ5k2yLjBx7FuOfmRNpm
	TDfvXyNdAf1Np9uEgiIp2Rjb1RU/K4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773634873; a=rsa-sha256;
	cv=none;
	b=Y3sJ771PYGODpQuTmkomwPL8XNhWbVPYSiiTCENxzOHj0D9aWrkL8vcqOjX50LQU9VUNRM
	Z3u3tq+KLIxoHfB8/VuCPsmH+o5tCmmmwTqtCFAs+8FdB0aPp69nWwJhQ3su6yrcrSArX8
	sQhqCT+u+NZRYJd+mxxYDArC3zUx7yU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ewn3TCZT;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773634874; x=1805170874;
  h=date:from:to:cc:subject:message-id;
  bh=ugDXr4umjV2wE5t9A2d87jF48b/dnuJsQFKJP2khR/s=;
  b=Ewn3TCZTykOGSl6dNV891VOzfh58V2yFrIbzc1GWptZdJ1DeEvFzCbl5
   eViA5Ou4rJkNIAR2sjpndx+7vM0+wWx2PAguAj+RhtWRDoZxmDi8xyUsV
   GlhM/xw5DJBTjBc4BsYhsNvsj9AlAZyuAsjN6Ao3ZBfo3CBsVct6M7/WQ
   qpCw5oemN1A9/T60JXaknKo3gkmbpGYKlHnzH/45BaS7Y7zpmJLDuwv/U
   Wclm7aWkTHBtoIFJRuHvLXXOoad7UGxbbL4JgtkxLTZCt6yqcx4ActgOp
   LWp9L/iXn2gNUQi/6WKvuP/lRg/TpYFwULv4fw0ekcVF47I4obsv5hBkn
   A==;
X-CSE-ConnectionGUID: ZkUjcKu2RG+J40OTndY2BA==
X-CSE-MsgGUID: zPRC/eZPT5i+aAK8r0Qv0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11730"; a="74833892"
X-IronPort-AV: E=Sophos;i="6.23,123,1770624000"; 
   d="scan'208";a="74833892"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2026 21:21:12 -0700
X-CSE-ConnectionGUID: k/DesnSdRu2BYIyGIy55mw==
X-CSE-MsgGUID: bZVj7hi7RCqXGawirR3+eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,123,1770624000"; 
   d="scan'208";a="221876096"
Received: from lkp-server01.sh.intel.com (HELO 892944969b78) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 15 Mar 2026 21:21:10 -0700
Received: from kbuild by 892944969b78 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w1zRy-0000000006E-1uP7;
	Mon, 16 Mar 2026 04:21:06 +0000
Date: Mon, 16 Mar 2026 12:20:38 +0800
From: kernel test robot <lkp@intel.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 378/389] drivers/mtd/mtdchar.c:1384:9:
 error: call to undeclared function 'vma_desc_test_flags'; ISO C99 and later
 do not support implicit function declarations
Message-ID: <202603161221.qNrB6fVE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 177C11A0007
X-Stat-Signature: aafdd99j3i4xzizigr7spqhf4p8ij8kr
X-Rspam-User: 
X-HE-Tag: 1773634872-617918
X-HE-Meta: U2FsdGVkX1+vu3qhtc148DeH6ybtyjTDIxrnQf36JxyR66Fbe75szQN2r6QcuFgZuXVZY//8k+E5Fn2ZvJsAg3Z7uXaKMuoq9fc2Q8b3NgyoY+TQ9KnMREiGGH1kpELtiZlgticj1adx9VYJe+WXMos7jfd2zVKZr4M6IChbqD0t4sVmsECa/3yg+p9StLFfQ0cvLPwLcX99wnPK9/R6v3W4JOTeNyl6DVF/zZ/Hu8oLBofV8PLHWtsnnYp5FIZ3ADkKmP6Ct30fvS6aad7nfeKD+sB5UDxtZdzAcqXl0T3GaLmOuvUny6VVOa/AwqnCEi+2P+G6fovUvrXwSgy3KPt8rfS5NsKMLeZ5K2V0FlekIqs8fjHs4gx1yQfzWDqKI95PWOW58pndBSq+DVCkTYBz+2Vkcr1lCEwbygx13kZ67SY43mPSpivGhKZnLTCKDbRH7ZKhWpBbTxDIAQ2fVOS+bOnhZKzdVJ/0eRYQttu57sRvMEwwDS1V3g2pySXUWZ8OosDM1b1P24xFtWeVXDrD90RQCMsbfXNdfEimeSxAa0gpphfALhdx1ok7CVpZz1bSTsBSnfzENNGXTZvRfxXog0Un0a2I35VV0KIAjo6nKh3waGeDoJoU/wZiB+quvI/UiPxxGVFZYW9p8ZTn/8j+fquyq+etPHlrLLNzeJcvteiuWFnV8iK/Dcbm3oZN44ZUP7WcX/7U/XnD9nS8aCWkhXg0vrtyq+XCfCb0o5bLip89rXoiw4lfUd6U4HQROer9ivhGwl/p3tpuLCyc5QyhOEk3wc3zb1IhAupbg/uo8fxae8UBsnp8X+W+vFvkVQPYuwNDp22zoOk24gR+5AfJbiKEzm/M2v1BrqpE7bm92TSWnwM7IDS/HK1RejK4LihoIuSPqDBaLkbZft0t9ysiKlZSTe68gQa5R4OHT7mCgevyRt+dDDxYEPW/uKXcRiyPl2CYbFaGcEdZm1I
 B7Eo3gd0
 Y0jGRzcEKv9IUqDj7r76V3lls6HlykVZuR0XWgRo3uVdOQ2dNygVPBUV4ZlbVvHIRjx+D42OaLJincXV238Kz6OQF+mfBNrNMPrjtKecAuPUOuPywqk5Q6R1YE3p24ZzawvWRczTajxJW8IYvaS9v4E86n69r6ZnFir/153AyyG5aCT3HzZ0t65JX8xmiYWhsk1ZLECaCWDCL0qnd7Un+ZT4xLZ5fdvw6EYy9lCQwa0OsmTc4G0uKHkoir0PRkkrxlDZFZaqiCDbojChIqTBlRRvQ0pNczDZAYV+24bQUXKwJkGt6VmE9ZdFN0S2VVw/w7Bpk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c5a81ff6071bcf42531426e6336b5cc424df6e3d
commit: cf0dfae0323aa8b75cee0b94d5c7553b511d7bc3 [378/389] mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
config: arm-randconfig-002-20260316 (https://download.01.org/0day-ci/archive/20260316/202603161221.qNrB6fVE-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 36041192cf6c9042615c8d2364cacc698ef89865)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260316/202603161221.qNrB6fVE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603161221.qNrB6fVE-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/mtd/mtdchar.c:1384:9: error: call to undeclared function 'vma_desc_test_flags'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1384 |         return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
         |                ^
   1 error generated.


vim +/vma_desc_test_flags +1384 drivers/mtd/mtdchar.c

  1375	
  1376	/*
  1377	 * set up a mapping for shared memory segments
  1378	 */
  1379	static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
  1380	{
  1381	#ifdef CONFIG_MMU
  1382		return -ENODEV;
  1383	#else
> 1384		return vma_desc_test_flags(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
  1385	#endif
  1386	}
  1387	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

