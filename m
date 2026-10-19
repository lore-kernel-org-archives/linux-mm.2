Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62724CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EE76B0259; Mon, 19 Oct 2026 09:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEF76B025A; Mon, 19 Oct 2026 09:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314A76B025B; Mon, 19 Oct 2026 09:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 119516B0259
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:28:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8801B1C3CD5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:28:49 +0000 (UTC)
X-FDA: 85339455978.02.ED0A7CC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D4AF2000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:28:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QkpYY7iC;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792416527;
	b=QBAsDpPDSlxBetFwkevgT9CMhtuPYIv0Cl/iwnHEf3VHxoqJjs2Zu9iAx6ytUBxGys7ttD
	xWWXfFpBKjM1lLZR+cXXw53c9wn62QqGbsdkdwSc/sUMs5wObMyR4Ks6KnXzdnozmBxQG1
	bqvEuaoTefilzZScPhIKwHyuCTKvP4s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QkpYY7iC;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792416527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ddJTBqqP160dIEu+r1VKf8BesPijOGUUK5ZIppvdxcg=;
	b=FH3nw67Eo+AKwnR6M3wiLqZ/e8ymY8ZbqGGg50X++knkdZX7qr6tsEY4cvnBr6HkgHfxLp
	RSgTA2bwdQ96cH6zzgqJJppPLfw2CTc2Dvaj+4F5ioFt0Ljo6iK+OS2yYJJN8eD55Z5oR9
	5p14NYzQq9IG++25RCMkJ8v8cgYEIWM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792416526; x=1823952526;
  h=date:from:to:cc:subject:message-id;
  bh=lmyxpMgNY3gyVyI0VoUqaOi2IiniSdL5VE9DkwnJY5M=;
  b=QkpYY7iC4uwpx9p7enB58+7BDumW/ZYFV5OySFurri33wDhUivurLvfK
   c9Bk1HKmqA4v7KR2mXXiM6n1pqFNhCyTWqAkMkeMhh77TzKeGfHOwns3k
   9bCPdrRl0EhiDuEkPprCVUQzsKXbuzOyNfLTrQC0ug6bo5TT/8lBg9Pdu
   kmFdoG27N1AcY8ZJT99lLl2uabo0mLdJ4U38ymzvvT/O8hcS49UpaT9be
   /OiFYM4I9XE/sk0aCEFRZDS+lJtiDjsQmBuxr4oGj+RDGvNtcaE25uZI3
   xPf3WHH9Xh6Jb9F7cHxPlzA9bBEsmE2PCY4k6LCe495EIcEuuR36e68rJ
   w==;
X-CSE-ConnectionGUID: ts0xuZJRQ4yfjrINfzU9Hg==
X-CSE-MsgGUID: mgtyAPcIQH2xHvkLkfMVCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1000434"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1000434"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 06:28:32 -0700
X-CSE-ConnectionGUID: coDAQwNUTL6IW6Z91AAxbw==
X-CSE-MsgGUID: sBkBx4cxSOqgQWP53mahRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536901"
Received: from igk-lkp-server01.igk.intel.com (HELO 3c253b998be3) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 19 Oct 2026 06:28:30 -0700
Received: from kbuild by 3c253b998be3 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xInPg-000000005dD-2x4g;
	Mon, 19 Oct 2026 13:28:28 +0000
Date: Mon, 19 Oct 2026 15:27:47 +0200
From: kernel test robot <lkp@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: __efistub_cmdline.c:undefined reference to
 `__efistub___ashldi3'
Message-ID: <202610191553.uvFTO4t9-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D4AF2000D
X-Rspam-User: 
X-Stat-Signature: xqf1d565chxo9q67f43y9drk7hns66s9
X-HE-Tag: 1792416525-863541
X-HE-Meta: U2FsdGVkX1//PSqdCh23a+GblO7yY7bmoAO7zWxgicBwKKkxygEs6y/t6H3WvjftJEH7puQsXb/1E28+w/k9UGBabpQCG37chzHqhU7QsYPRdL0/aEoQob/TOHAyPZfyytPnEwEm279I8mACp1/26uJ+iHtfOF/NN8IXyw1KTmkKRhjBAtmCfVHzxwOfJS57fCwAp0AeD+vJ0vvPSeMV/FSTePXfmGMnxIVfsLa8psOcYbLf06AYBxDt0GgaC5hv7u/JaEXEQ9bMUY34P36ekxHUrxUigR8sigbyRIp0odxcEzIPfK+vfBg81aJa9hwMTe6xDBQLFL0mIyTM6qRzPuGfjnTcA4Fzo7v3DFRjTM9RgufrFyMcazriKEUBwszIkcgHeXSyUA9DqsR9pj0RyhsfGR2Q/ethOu+Fuai3Ud7QJhhUHpdaXkP79AxQasCZ2SJ2zQxF9nEB/fr7n16sOSAV7bWr9OeIf2BFmTFOXimBWxBagAiNyzkNp9goEEMzZcJInLgIdLZ/xFyMHlBsKM3kZ0BuZDAaiJCXp4oAJ5K+ZhgqNJ1b8Lx28STY0WcLHgTLKC0GM7skzlzPQ0L94/VTbIEXOycyA5qxMgPmbzJT2aEgYko8Icyv4FZt/u6LBAEZGMu1mVu9b382TvE4RFjdXkcb+PkPlB4ogGIy5x3tSMyQwrcGZ0GsX8PZ10fTUJzwIimE6/yKzikHkt/NBvmjQVw5hOLavNdMMttMy6WdzUXh4eQ1ZVKhAETYfXDVkq/1UIdJUaSPJ4CgEEFAArH20V6Xdmhp+5xoEjxwGm2jh4zKZMG1USO7g696Eo0AWhRcuqQJH+e2WU90Kwki4vUTATcC9LMoLwkLTFm54vkvUTKZ6I9nUzv8bJLH+h0n3tPZCxBW8ufOJgwsvlWSunnZpZ8PdBYZyFu9+L84lWvBitmD0jcVcQ817yKiec9gIXWSFdLPOQBsBKl6dyO
 dzwHN15/
 NKBvZv0ToceArWeTH1P4ahIOV6Dt4aB7xtsmHucZBIJLKTCVlqKCraExy2xsUtOAb08PSPEtOt63Vw8xhl4K7omW0Odhk/14p08HHWV+FFj5JGAfECTed/oafXkSvmAQ12lGdZMhlu5rEKjHU2CanQBqRr3zLrt3jPTEnBIOJVCirQTWfJt8al7Z/5PFh4h0sTyocnWIDGvMcGkYFmCC5fHrANgr+v4tJAEuqQ7CsJwWKUSCRR3T5/Gp7dH+8T7eRtyZaeMxWDUc9htw1JLhTRVLWPrHpuVo6QabLu6ttjhqvavwUqavrLy3ZvdCUp3nKKkGcjx2BlOmYR4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   c03c1a14507dfaf8b856c2608f9ac216021fc222
commit: 9a4580db6e9f83428813f671a79486469684069f lib: fix memparse() to handle overflow
date:   5 months ago
config: loongarch-randconfig-r2309-20261019 (https://download.01.org/0day-ci/archive/20261019/202610191553.uvFTO4t9-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 16.2.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261019/202610191553.uvFTO4t9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 9a4580db6e9f ("lib: fix memparse() to handle overflow")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610191553.uvFTO4t9-lkp@intel.com/

All errors (new ones prefixed by >>):

   loongarch64-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L47':
>> __efistub_cmdline.c:(.init.text+0x288): undefined reference to `__efistub___ashldi3'
>> loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x298): undefined reference to `__efistub___lshrdi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

