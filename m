Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE5FF3D5EA
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B326B008C; Sun, 29 Mar 2026 00:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113366B0095; Sun, 29 Mar 2026 00:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FD86B0096; Sun, 29 Mar 2026 00:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6EC56B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:37:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 207AC58842
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:37:30 +0000 (UTC)
X-FDA: 84597841860.23.3DA3206
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0909040005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:37:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U1bcRAsx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774759048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LEbfRJKWzeTSm6rLBMhXMMc34VvctBC8WwB8RJ6S1JM=;
	b=3fUzB6SV4KQmpSp1whtN5xBBaH5cmYCtfkgQamOPLL4Ap1wRKvMsIqxpnq/oBmLhSXDdeN
	SIX+c8ke7SEy0s8bCwlXawVPHJFwR0D3WF5hqxntEd50WZBN1s22Uiq9HmgVOvK7CiAtdd
	BvAWZ2tByYiR9trnqldBXinbUPDO+us=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774759048; a=rsa-sha256;
	cv=none;
	b=dlAV4eUA9ta5eZyjjy+r8SbLx49w8/X2YzeyJqAiZH8BcBSrk3HA7AffwvAbbxNVfJ3np4
	hB/HdZOWdF9BO46oWSHJNTDaE7Q0b2Vz22+2jHZ88667izh4xdOzF5DedirMwDFXJUjo6/
	YKrbUa8mCs+V8tjI4m7TF7uiWbkANeQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U1bcRAsx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774759047; x=1806295047;
  h=date:from:to:cc:subject:message-id;
  bh=hHLN7Ja3LQZLQWTHsYWN1jUeyvTU6JdbUM3DC4qpivw=;
  b=U1bcRAsxGTMXpcF1UbQhkShQgfFVMoclJJk49rFvz0nvbJhfHehintFU
   quzmVCcfIvjs3uf4OWty+TiIPgbHnAvCmawpnQGm+ma+02hJor97xnsLZ
   R5drKoYrEteOG12OnI9Y+7UPIoBjS/buAF0PvPGIcKvjkqh/jW7QuebIi
   AzOeWwUBs8CIp3y+nO4Cj1b3qWBMMLs9/tLN7rg+YqwqaMjj2Fh/3SUwn
   s4ufTdTen3LjCPHfYRnHS5N3BLhxFnflhxv8YPLgnUMjCQfzKcwiehlNj
   xihRAQky63vtG8V8GhnaECqqh4jCNQ4o12CbDP8X1U6nTE9tzq1LVz71G
   w==;
X-CSE-ConnectionGUID: WNxLbxetT3Wp6w7fzckWJg==
X-CSE-MsgGUID: CwnVrJbZR8yPaNP0akiXKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79646717"
X-IronPort-AV: E=Sophos;i="6.23,147,1770624000"; 
   d="scan'208";a="79646717"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 21:37:25 -0700
X-CSE-ConnectionGUID: IwQuR/VvRLqziO7tz9LFkw==
X-CSE-MsgGUID: verF6TuPTMaYnXjUyKIDlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,147,1770624000"; 
   d="scan'208";a="263650748"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 28 Mar 2026 21:37:24 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6htp-00000000C4r-0LWi;
	Sun, 29 Mar 2026 04:37:21 +0000
Date: Sun, 29 Mar 2026 12:36:27 +0800
From: kernel test robot <lkp@intel.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 193/194] lib/alloc_tag.c:815:25: sparse:
 sparse: cast removes address space '__rcu' of expression
Message-ID: <202603291211.YhY0R0se-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 0909040005
X-Stat-Signature: b9qq7b5gwypeqptxsr3uqhau4yga8n11
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774759046-869194
X-HE-Meta: U2FsdGVkX1/t9gT5vGmdCJGWaAOWcXilv07GQF8weU0624AuAwYwhbVa7guwsMeTM3z4ArIJ0byjjE7YgxfiQHF6RLUHXNQoVbm3SjfXtjfOKdt+8xTN+qYm4T0IP5fg+znD5sIlV8AnhyIoBuSCfS1xWQis4fwVBw1A5sW3hQRKhjR8niOUbjWvlGT2XppcqYUXmsLTxnOIEJgwJiGaPWt8Leg4j6YDx3Kyt8dVQfRarmxWtTYEPKpxIPDGsRT3ctuC0GkvcBxXnv07jaF6ck+zzM/6JeZ1HVhmGeBzXwGLKjwK6Q/wrJpUGzyOjSJFLfsUjyG0lXQ9CWHSLcku7x0hX4zyC8vJ5qpaGAi4s1M/TlozF1wbp6eJLrPkyd62VoBHpg6+Ez1D3/j8DX16CFFJKu2YXXrz5XQwTNzGIiwjkEKliO8YI0MqVAgzdMOJGGlAcz4XS9AG5yResV1Ygb2GRm76XWKXbrhMDhcwaN77Eegf6+7FTVow4Qq5a7d54tuHIhwBGOg730h6jA6dEi8jz268Y/FK1OklmveV+ogElpZWQfOeP1d/zjwZfVfrPYmZMpIGp7eH9oCxEqTjkOEYut/yHSIkYTSiW6X6c4e65ir/3Ab9zlOwA+m3IjM+/qkpNMb1UXNp6a/2dMDCrNKUNi+y8T+VjHHgz/VclWwcKQw3940xZtWoJ+NKFaMuisZwWjD3pr43eFkWHkkRSd5Y9Qszys344PuSeiuiGVcdbD7bS9OLfd52t/i8ImYW0BLrLOzDPCXSYuYwBwAN3KzAuzJ43BfGmhbHVVRcGYXScns6mKuH3wV7psYtIBi6WbLKTnUbS11F5eitwWzqAoCCPX3zcaPIeJwkhwrsLHNlhXPRb6cqSMq5SaHrphUjBWfcn5JGZSu3+/d2m3nNWl7f/GH6sgmjdbsBDDhxnX8+6/14DuPT+JOvT08Kg1MUei3FoMurwNosKgKJsrf
 WwGrsz2l
 xF75gMEuo3Uia7WkeRGtaSvjIsjjDkLE7jzkz0fJ649WQbYkVkrkcg23JmTMURLzDTKUxe9jeFpG47v9qUFADNXDfC0MMaTN0lXpCP+X+Y5dlcV1iII09ZNjZOUCAFCyf9pkcDZwbIqjwc1F6RxXQaOuf5qFrbCU+AGWYRxlgBOCdFhqykhlNIIzXETmI4NDVxVpiVVKiYsvrgpIT7KppDKesllFh3YGwp6jEzsDg1521hhhVoqcPynfos2zINMwk2vd4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   df2267b6380964f1305128001f05bc043ddf1f37
commit: 8bee7b4b574f880ff2c7491212e2ef01cd82f2fd [193/194] mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
config: openrisc-randconfig-r121-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291211.YhY0R0se-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 10.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291211.YhY0R0se-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291211.YhY0R0se-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/alloc_tag.c:815:25: sparse: sparse: cast removes address space '__rcu' of expression
>> lib/alloc_tag.c:815:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   lib/alloc_tag.c:815:25: sparse:    void ( [noderef] __rcu * )( ... )
   lib/alloc_tag.c:815:25: sparse:    void ( * )( ... )
   lib/alloc_tag.c:828:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   lib/alloc_tag.c:828:9: sparse:    void ( [noderef] __rcu * )( ... )
   lib/alloc_tag.c:828:9: sparse:    void ( * )( ... )

vim +/__rcu +815 lib/alloc_tag.c

   802	
   803	typedef void (*alloc_tag_add_func)(unsigned long pfn);
   804	static alloc_tag_add_func __rcu alloc_tag_add_early_pfn_ptr __refdata =
   805			__alloc_tag_add_early_pfn;
   806	
   807	void alloc_tag_add_early_pfn(unsigned long pfn)
   808	{
   809		alloc_tag_add_func alloc_tag_add;
   810	
   811		if (static_key_enabled(&mem_profiling_compressed))
   812			return;
   813	
   814		rcu_read_lock();
 > 815		alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
   816		if (alloc_tag_add)
   817			alloc_tag_add(pfn);
   818		rcu_read_unlock();
   819	}
   820	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

