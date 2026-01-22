Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E95DC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932266B010B; Thu, 22 Jan 2026 03:04:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF3E6B010D; Thu, 22 Jan 2026 03:04:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE5D6B010E; Thu, 22 Jan 2026 03:04:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3716B010B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:04:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27B3488A4C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:04:50 +0000 (UTC)
X-FDA: 84358863540.19.53066F3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5496640003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:04:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mDT4hcKg;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769069088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=SnRr+Ocj642is93dHmbsszmjBu2SjSQGJnA0yA97WC0=;
	b=uKGtDB1Jwkdkx7+OkyK4PdmRqgfJ7g3bgJcZFgvhlv+pVKYsh3x9t1y9r2/T5zpFJe+AJP
	uKQnlHaBTfBExN0/CYpCy4Y08aEvMLu1uMA1O6KgOQfTWCbhFdH+XJ8D7pkwbfXdY449Sl
	6ybenKFegDCwBzIgUg+T1xmNRTOKUis=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mDT4hcKg;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769069088; a=rsa-sha256;
	cv=none;
	b=6X0iPE0fQ8bRduJ5iEuupvH6zqAn0qYbuPJ2nZ93jCEUboY66R5ZCga8P6fqE0PqQGQQGq
	e3nJP/1dlmwX30PF8K/oK7E1LZc9N6YjC2Di5xO3Ki5WM5UFdTONVd+Oj6kbyyrAM6WvtI
	U1SyrLesya8oj4bxX5GiZf9ReQt+ZNs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769069087; x=1800605087;
  h=date:from:to:cc:subject:message-id;
  bh=xVdMDZavYUXU8qpApbkkI6EhcczS7BMVhM5nbxPw7xY=;
  b=mDT4hcKg145/OB5qfl7BjGICrH2BknzpmWnyWr23FN0mZw0p7GURjBTN
   TfvA7+8+QfNdwSxMRTk0IdxGeZo9zUriJo+5dROM7f1yARTtKNgLzZTWu
   DE2OUfsD64qn0th7GHC2GPiGgtTjkYDoW5diGKb4jN2BXhrZ1b6bmOxwp
   iTwwao94DdBIlOijMOx1KrVgKO/9PAzaRVU3eTurVDQ9OA17oDGprFT2w
   nT6TDr6+nzeOsVUUcm8D22FMY3wdOnUNh1DIn92KcIQ1Yo+lXFggn8Ubg
   0n5iYCjD4BVVQROkT6CMClxpwHmty1LMrNy9EyrMMHAx/5hS0WaU2FTs2
   Q==;
X-CSE-ConnectionGUID: gkggmwYBTaq+FowgwhhQ4w==
X-CSE-MsgGUID: KNGN+P4gRXShCU0WyGObfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="80930322"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="80930322"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 00:04:46 -0800
X-CSE-ConnectionGUID: 4jcAYE2URme3cSNXb8gmdw==
X-CSE-MsgGUID: llLIVkZ2RiijFYHAaIcviA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206577077"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 22 Jan 2026 00:04:44 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vipgH-00000000SaL-3oTb;
	Thu, 22 Jan 2026 08:04:41 +0000
Date: Thu, 22 Jan 2026 16:04:37 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 420/429] fs/romfs/mmap-nommu.c:66:42:
 sparse: sparse: dereference of noderef expression
Message-ID: <202601221505.RxftadLx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam12
X-Stat-Signature: ena5em1w5b76phqgrihp6uyogcushyzs
X-Rspamd-Queue-Id: 5496640003
X-Rspam-User: 
X-HE-Tag: 1769069087-904570
X-HE-Meta: U2FsdGVkX18kWrd+HW0tufj+xTxTJ2I/y1Y07bHAUCsePWnl4O/bsvnlnJH8cz6JJ0ILqZwp/XakBkmmq2Qukj7qydZXukvDEDhv085B6CFSgOG934i33HcasxGZRPWDyrIruxQ9Et5+qIhGZOphE5HcB6b2OBgT6rvUijkT9/TvQUEXhL13OvFfeyNUusEQQgJ13kWKILaT5ZRVoVSXjLUUSoRwqJWaiU2+G5p0QfvNw8Hhvi2XeCgRjbr9JaNPZnsKR0mPIdb1jgekObFCRsW0rgLP1MOK7eS2JlAhjQgue2nT4upMFtw4qrQxnTIolp0uqFPvS9S0x8yFA/SYbjdwB/xgUAvKV1B2ybQPlznJngswlunQLmdky9gf7ZKovVeb8V89FK7ejIEDW6bzmi8nn6/1/hfvxuelXUE7qGLA6XCldzf4E4tA0xPwC0dbZO1VrEcKfIG3RxvfwZ/cnbPBfWJcajb+xiIsMFHoDd6Unh1yO7sXxfP0nT4koXwDlqKjGTJ29njDmYB9dtP7LrqaQ9HrormFV+yqHIjsdlkBLXGng2kkJDiL5YGv51vRfVevG6tKqWnK0JhjIjSGBSlq10kVF7ju/s4jOMcHIk8bn0Wyq+mhbRGQCCmi+aH49l6f5W4eHQs80U6flczxexaQtfqKu517Kf7Ue6igmS4hdSVMIaFeijcQ/iVmoSMR0GblkVxFNDgVNNQkjv3YAInjhAwkiLJCOafWh/ccBxUS4KZpgYuq6HJwrj7Zc95yNbCGBfnJ7bJkuU91hx0mlgNzwkQkMG+yYVX+Hz0+tvyT/OYMOru20cU8FVFAVfXDxPrhM8R/5Xc5b9I0m1qVbD6Mp/BQi/jWffbe7CpIUvIeXKvdVtgMrpYV58+W1I7Od8+iYDN/sQp6T6ecO06O1oN6H11oNMkzLLjAQD0NX0HlYjmsERWD/E15jLiuI+FMoMw0hudXlj941bipbaG
 rNzlVrIy
 UvOHfP8ceanditVuEm2HccumwA/wdOP2j5E4gBGCTU/dTXmbp+R6O5rh8yQFPfh9Ftpt+nZWvi0Cswy3q67bGTJj+kffYBjBFFXE7K5lTQspIMkz8iU11hrLj72n7g5K3OrM2BEHpTOxZgjisD9fy0C4yC4qJpVNewaWAcsEtostyM9faOtUfMJ1Ggz6Z6TynPoaVjGEtWGI5RuSnJMgHo6/BiMSkTTGl49Pbbd7guxz3fIIIEgDSMX7fwHJUfF2OuXXs9ZKJnJ7D3BDBCkFyXBfCUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   dc4fe40a11269aead253fa0beb098b00417b8694
commit: 57a654376d4bb67119d436edc8c3c4c0ecb3c369 [420/429] mm: update all remaining mmap_prepare users to use vma_flags_t
config: sh-randconfig-r122-20260122 (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601221505.RxftadLx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601221505.RxftadLx-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression
>> fs/romfs/mmap-nommu.c:66:42: sparse: sparse: dereference of noderef expression
   fs/romfs/mmap-nommu.c: note: in included file:
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1954:16: sparse: sparse: dereference of noderef expression
   include/linux/mm.h:1048:16: sparse: sparse: dereference of noderef expression

vim +66 fs/romfs/mmap-nommu.c

    59	
    60	/*
    61	 * permit a R/O mapping to be made directly through onto an MTD device if
    62	 * possible
    63	 */
    64	static int romfs_mmap_prepare(struct vm_area_desc *desc)
    65	{
  > 66		return is_nommu_shared_vma_flags(desc->vma_flags) ? 0 : -ENOSYS;
    67	}
    68	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

