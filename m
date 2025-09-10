Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33841CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D0D8E000D; Tue,  9 Sep 2025 21:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CEA8E0002; Tue,  9 Sep 2025 21:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662358E000D; Tue,  9 Sep 2025 21:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55BD28E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:29:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09DE25AF37
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:29:12 +0000 (UTC)
X-FDA: 83871607344.05.5AB1588
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A73AC0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:29:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BGYkEiU9;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757467750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ARkTrb8vyNgh7YfzKqGvmW7mJhC0hlibzasTFwHJPWA=;
	b=i8I5nBBP75G247V2M92zbTqFj8IfF16J1V9baWCa+Ty/N7f3eNlptC4loPNtYdhfMGUy1h
	iTWb8GwuZVl8cvdreStPCHKKiUTfBoT6oTuMmbjPzPyRiHfdnSgo/S0alrhEH88w4sBioP
	qLM/jrs5aWl/cCxAo1rvxEvWtoBXlfI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BGYkEiU9;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757467750; a=rsa-sha256;
	cv=none;
	b=RuF+xIAICGLjlNfv+zjgE8y8hJwWvf4MncgwFxFKt5voejwlwOPWWOOU9c9itEAE/IXNVF
	+XJrIDgtM02Xn65jwVRlqwD7pzk8nQXZk9FR6RZq5FNFSlvujTpJWdQR+OJM8fsEMdmqQ3
	+dCj1Ldl2fusBqU2ub3oXzf8oWxDWQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757467750; x=1789003750;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ywE05WToLpUHQO2zkUpWziW2sv/68Hr8hMuL+DQ7vP0=;
  b=BGYkEiU9isbxkfGWlrBGW6Jeye3q1YujyvV9jbLIOiszfGn/74uUd4VZ
   tX/L5cv6p/ctEY8oHd4zzCBEbxM3tK8ycRTveMOb2pWLX/hKfbfQh/bwt
   gFoRojNMOeAfUW0l869nCE1oNUWiGDFImAXXrDbDHo9rJtTBLx/7Ylf2d
   wPPs72xtPik6sXsZhzHaxdkHQSsxVPHKxNI8qALsxlJzmpdcpUkeKcf4O
   EjwbLfuTfGJGC688qo4Pleb6z9tYdDQMo/cJGCd/1D+rpic9j8HJ1oUa6
   arh0USNL9ZU1hcFExQH26mYv7Ez7i2XIY9Z1tL+fJwR1OS1gq89028Wty
   Q==;
X-CSE-ConnectionGUID: NAbp5qiHSc21CKE4vbJNXA==
X-CSE-MsgGUID: +sMLfHEFS/CPPLNFhlzXuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59831766"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59831766"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 18:29:08 -0700
X-CSE-ConnectionGUID: 9dzJTkRvSg6YR09gz7/TPw==
X-CSE-MsgGUID: xqLUD1v0S42/t1HsCl+Xrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="173156662"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 09 Sep 2025 18:29:06 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uw9dv-0005Pr-2E;
	Wed, 10 Sep 2025 01:29:03 +0000
Date: Wed, 10 Sep 2025 09:28:50 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <kasong@tencent.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>
Subject: [akpm-mm:mm-new 359/411] mm/swap.h:455:24: error: implicit
 declaration of function 'swp_offset'; did you mean 'bh_offset'?
Message-ID: <202509100956.7q0VPOo2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 1A73AC0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8cuiz1xgxeyzqngkdb8krde7wrs5rauy
X-HE-Tag: 1757467748-167904
X-HE-Meta: U2FsdGVkX19/ooMvs+SnEi2Ml0+/Qcn4yi7vwb/tDtHCnZZcBPLuWftIBXbr4M1t8Z1MZYm56n9YLRhdI6cwWVgSPw8uhCjrZ/ZsRmMtBjxgFumaDCqRAZDnx8/5Wva0ECXWuLLhObIUyD6X3qNgiik4zDGm1vd6JOcgrDpcDdPyGPnb2DLLqPzvFPnPlZsN1GjmRoKtpwr5UJFeZFWgYsfGNfJTs0HeIdgriteyZOqBBgX8HLJyF7eMgkOiCjPwKzL+YwYdnjGNdk3amgQteWJhxfdGSMyCE8ZH1lUWz7AoU1lNwGcEMQYhRr7yT5LZv6KG33RopSoFKno0Ub+gqIt8OcWMD4UE9pLt3Ks968QjuxES+rhDY7DB7Ec9mYRj/dZCt84zIOBaIFpdLi5tY5cTdiwyCozWLsHi7k0tnkLHV+3FDMGYWpkrgEcaRBLw3f5p2yvJ0RU+jdGRQfog4K3F9RDpIxVo5WEfeF7aG0rh5Uj+jCHKWXkCkffP2dHGIYyEJDfUqIIHdeUrLhtCmYl2YRzSgIFY1o1bVluDutIHMAs2zBsTr1VBE6zXOSAcgIHpa+rUKdkIHMuM6AgC7KVlZzqKpG77qUJCrnNGCnBxNFGyGDmlIKjy8q5vHQeL1xIpRQwm2ZXrWQyfl6xmTnfvotYQUanPT/DjnWOJEfwUl8vQxYJf8SkKgP9Mqz0kgUfV0s2HHfSWQFi62DFdscfl6+goj+wsEVI0LzNziyFHuk2Qihf3ll+kwWqAgPDrfw042+drA9n/Ts13Atodeiv+QoNmkt3XReMfeng3Qiz5rCw/YQ2sk47wFWLTkzdQtaJmfVYjsjT1PmJS5xjc/YujugW8ibaUcxoTe0NX7gDSSwOoBqFTAahRqIocVHZSK19MCGJVMAgxDoTUwDTutIJgi5ce9dJwPwoMlOQLS0Ow4MjNENUvA17Rtm0EpGBsjeMV2H96VRFJHqavAGF
 x8nD8Zqk
 WF4ARTPmE+ut+KmIFYgZ91PpHukV1XI71qWAYRlrC6mI4cM6+0sNH7KG5xpulD2rsQdYroH6MzyQQODB0LNXTR7zEuad5af7AXEbi6PhCsN/2Ag2OQs79JITPKxOkMw/llQGS9jULxZ5q/R6PGrW3pYod4uuki+ntopwGtlPP7ZEy5cfvQp8nVLMkwVt3co1LZn1QOAfcz+00tNzaqUDBgTvchxu1dIjJkSTz843ezMolT98hhaVy0375pRHf0KfeccVTWaT51/pRxWLEjxhBpnMlvPfLdnNgb2hdTyeYhoimOCQNFMcv+w4IF3LiaepdgjS8SGjNpERatp4w80hwy2YsUvG/Mzlvl++atq0o1c33AvC/T+u7aPDhRcSfgQaLw4RBFZMzqCbf/Ce08qttLXWfW43wXYY0GWrc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   f4e8f46973fe0c0f579944a37e96ba9efbe00cca
commit: aabe1e0289084317ef7603c14132758fad3a975e [359/411] mm, swap: use the swap table for the swap cache and switch API
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20250910/202509100956.7q0VPOo2-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250910/202509100956.7q0VPOo2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509100956.7q0VPOo2-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/filemap.c:65:
   mm/swap.h: In function 'folio_index':
>> mm/swap.h:455:24: error: implicit declaration of function 'swp_offset'; did you mean 'bh_offset'? [-Wimplicit-function-declaration]
     455 |                 return swp_offset(folio->swap);
         |                        ^~~~~~~~~~
         |                        bh_offset


vim +455 mm/swap.h

   440	
   441	/**
   442	 * folio_index - File index of a folio.
   443	 * @folio: The folio.
   444	 *
   445	 * For a folio which is either in the page cache or the swap cache,
   446	 * return its index within the address_space it belongs to.  If you know
   447	 * the folio is definitely in the page cache, you can look at the folio's
   448	 * index directly.
   449	 *
   450	 * Return: The index (offset in units of pages) of a folio in its file.
   451	 */
   452	static inline pgoff_t folio_index(struct folio *folio)
   453	{
   454		if (unlikely(folio_test_swapcache(folio)))
 > 455			return swp_offset(folio->swap);
   456		return folio->index;
   457	}
   458	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

