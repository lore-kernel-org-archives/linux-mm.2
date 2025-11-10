Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F0CCCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A79D8E0022; Mon, 10 Nov 2025 09:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958458E000D; Mon, 10 Nov 2025 09:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895CB8E0022; Mon, 10 Nov 2025 09:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765128E000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:29:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF0B136246
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:29:59 +0000 (UTC)
X-FDA: 84094931718.18.F1563EC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7379E4000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:29:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mWbaF5HD;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Kp4oGU2IhAZmbxd6RAGRjLVD84kLCEDwpotmqI5w2xA=;
	b=SYYnV30Bdr27le0bDXtnact5q7LRqPzE+psucAGDyv2woti9DYDexPnmi6aryP4g1JMYTi
	RuY2tDDvD0XOV33VHtLltg9raczIifx1XN8srPmFLkPDRFVWxT2eBLgbo52E29QQilZund
	QAQl30AZroDRTGBWaBP0vUIrBo8QyUo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mWbaF5HD;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784997; a=rsa-sha256;
	cv=none;
	b=BCC1Mx4Q/snvZm2DeCV+OZdEnwy/totcwL8g81vs3KLin00noON3URmhqoVs8WAJU5rdlX
	mbnXeViV1AcFJNqjL+dEvj/k1U5wucmYgpPHrWsyboXQWi0hTMfLI8vwBZmCy+9xaiLzZL
	tbsR9jNI9KL5L4iT6CXIVsobuofjbjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762784997; x=1794320997;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=cwl/GWKBRI65r318+pLvo4xqvgQzYWCHJ74rFPBPHxM=;
  b=mWbaF5HDXce5gf7Ex0NW2mS9X4kwZdFm7eHxkPS+C7bXFnHqRLn3JFgQ
   nQR2csNVncxIAwJmOEFWzt3I+t4eG2wxSmH6eRDesGI+H0uNqF+Dx+jKM
   tSbcL3Wv9L5uRcyB50rvB6SLKL0A7S46ryQpm+OpEGk2g8OdmeWQZ/Sq7
   LBXhavv+qkZHJrqFwx6+2PIbU1we09Jw5HnfVc4REtKvXIGuwXhurbMuk
   RUg/kWN8nQ+tBpK8yJhyOCnBUAG1haY1B/3iboVUXguLvTJcvOzPaPC+P
   92+Jq2JD2/r4O9dFtrjzclYqZN/A3LQ1c+FM8DNW7ASdBCUHAWUJAtkdK
   g==;
X-CSE-ConnectionGUID: p97YVS/fQvay/IOyO6rCFw==
X-CSE-MsgGUID: 2k+TcLRxTlmX4UiTRlibmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="87465633"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="87465633"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 06:29:55 -0800
X-CSE-ConnectionGUID: 5uwT5rpTQnu9brrqli+7Xg==
X-CSE-MsgGUID: zwHD1DFMT5O9YmvbLLm8Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="189407859"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 10 Nov 2025 06:29:53 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIStz-0000XD-2F;
	Mon, 10 Nov 2025 14:29:51 +0000
Date: Mon, 10 Nov 2025 22:29:05 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 291/296] include/linux/mm.h:957:24: sparse: sparse:
 incorrect type in argument 2 (different modifiers)
Message-ID: <202511102224.9qWchj6g-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 7379E4000F
X-Stat-Signature: fezfmkhfh8pdnso54nzbtnykserznm7a
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762784996-216176
X-HE-Meta: U2FsdGVkX19J3G347KsAfw8aHHkOXer5BBljw4ZKpHeUWh6ksPsEw8rmWjx3P6vsp0U4fqywEcZbxLLImOko5KJo7taAJ/DN2kx7PNg19KhCXYttpRkeRsPeZqrzz2imXqYO3xYDVHj5H26mPMvmZ7vzL0W1nTyQhssPdyBU7JFHhngSuMNKaR1uJPu40Wmph73CoN9X15WV/QHW6MhByHtwo0kLPJ03y63sfN93F8ceFb0n2SRJ7FhR+jE5TQCmNdkSj7HEqgqfuiXWuG1isbXdfM2bL6/O9hu6muUzn947XRdhRVsdMPojYwU2rxbi0H0JLRG4WrtNmg1r86OgSeK9l21gE9DIqlsSJsuwcynJw6Ka7vhafKpqxoTFlDB4E2XvtAigwTr4veDFgTPzddNbWJIKKyxtIvfrkwx9b15wOAAWdhvocGb2So3oa0V4kYaVU7aJ3Nht6DZUhkZjdODk8NHFNZztlTqWVA1pLoCeIAjPRbcsRYr1WvjNSFxGcYsTeI2tx9/FlBtSXfNlkCLXxqXS/VqQn00EjTxYBVcO6VY/Jhb4KXGjbtKLWM9jAFJliKENM4vZQLfNtRSdcQbCfAfNGQgbnCoJhzC9IsIvzx3jms+l6cG7pLTTGFc8LSCD/mHTCGdj7kMOvh4eRivN4QFf/YKC9Y686kKzcaqhis15DXgG8O5qF8d3ZaoQ9eRPeafNo3wM1Em0nF+FYe3Tr9D5UeywTSRDBiwtR59sfr6LVhfHgV2oXYAwBDvGujxpzEKjdT6xVexXmqUYXzbtQUKlM2Ip+ImR3kPw8aJm4QKtPTEj8FaVejPBKUc00uR95Ru+t85ZOEAKlbOULN5VMshW6lFsyewp2OX3aHwJd/wH2MeHIkLv3z4GsHSVBjvH7BAAIVfEC6FkPUNUeEKsOTKRdyIZBC/hOTxRqa/xcMBXdDe7uT3GnCkrvUnDxrhncsIB2L53MakG8LK
 oMOxS4e3
 YppSyJSCl9+T3O9zkdVgbHSO76FXK4JK0CVA9RDlVTEd3FhDH+DG+NWRVAMv8EFGBy/yUH7rNG8BHTU/WkDhpCWoieM664NpsEgvY9lN6MfXCV2iITAioaDkAlvMbDKmXW+A3oJPi5/PL01SQWU40ICRXVF6Vjtl3YYzJMQ1MiMO4+7f4GMHqjxtyVIn5oi/laB6nB/royeIUsdOchvYks1aSvnvRgcwRQP0F0SyQG5FvRNUR38obpmgFWNiq60yFqsSVAF2f8R1nxCpowzfnHhpZfZc3paRBTlm1ZzMeXbXZO/ZEXb8qD+YxIBEeHjWy6XklgkeT91qKk3LyRWuh+LwTWDfXYZgcKnqTsXZBiATg2g0RVu9XmZPe1+fFArd6Qq2LIOyoZbR3Y1XAD3GForUgIj7j0xgSOOThOJuQqV7neZMKr/J0rw62OE9jFosQbcD1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   8017f1fc873a78f54df02521b4d150f7101916ae
commit: 85de428c7ca1b71457690b95e162662d0edb2792 [291/296] mm: set the VM_MAYBE_GUARD flag on guard region install
config: s390-randconfig-r131-20251110 (https://download.01.org/0day-ci/archive/20251110/202511102224.9qWchj6g-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511102224.9qWchj6g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511102224.9qWchj6g-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/khugepaged.c:830:25: sparse: sparse: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
   mm/khugepaged.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:897:25: sparse: sparse: context imbalance in '__collapse_huge_page_swapin' - unexpected unlock
   mm/khugepaged.c:1196:26: sparse: sparse: context imbalance in 'collapse_huge_page' - different lock contexts for basic block
   mm/khugepaged.c:1705:28: sparse: sparse: context imbalance in 'collapse_pte_mapped_thp' - unexpected unlock
   mm/khugepaged.c: note: in included file:
>> include/linux/mm.h:957:24: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *ptr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:957:24: sparse:     expected unsigned long const volatile *ptr
   include/linux/mm.h:957:24: sparse:     got unsigned long [noderef] *
>> include/linux/mm.h:957:24: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected unsigned long const volatile *addr @@     got unsigned long [noderef] * @@
   include/linux/mm.h:957:24: sparse:     expected unsigned long const volatile *addr
   include/linux/mm.h:957:24: sparse:     got unsigned long [noderef] *
   mm/khugepaged.c:1822:28: sparse: sparse: context imbalance in 'retract_page_tables' - different lock contexts for basic block

vim +957 include/linux/mm.h

bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  946  
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  947  /*
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  948   * Test for VMA flag atomically. Requires no locks. Only specific valid flags
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  949   * are allowed to do this.
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  950   *
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  951   * This is necessarily racey, so callers must ensure that serialisation is
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  952   * achieved through some other means, or that races are permissible.
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  953   */
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  954  static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  955  {
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  956  	if (__vma_flag_atomic_valid(vma, bit))
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07 @957  		return test_bit(bit, &vma->__vm_flags);
85de428c7ca1b71 Lorenzo Stoakes 2025-11-07  958  
85de428c7ca1b71 Lorenzo Stoakes 2025-11-07  959  	return false;
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  960  }
bf91f4ed2a530f2 Lorenzo Stoakes 2025-11-07  961  

:::::: The code at line 957 was first introduced by commit
:::::: bf91f4ed2a530f2e55e7b202c1692a4c682888d6 mm: add atomic VMA flags and set VM_MAYBE_GUARD as such

:::::: TO: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

