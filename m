Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9E7D5E154
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1246B0005; Tue, 16 Dec 2025 08:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F3A6B0089; Tue, 16 Dec 2025 08:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D796B008A; Tue, 16 Dec 2025 08:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11F5C6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:32:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC569BA6F9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:32:24 +0000 (UTC)
X-FDA: 84225423408.26.8919A73
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BA92160017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:32:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BNNKnEC6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765891943; a=rsa-sha256;
	cv=none;
	b=ZP9iop0A2uBclWcYjft7ZPbYRYJFQnVdtAyM5uAUdxXxlfrHjzijp9eHYS7bPLUuNz6t2G
	5e/dcRhG+bYXcBF7VkBLvzy5PyswWrapyfoqtbBdyiiaAwHC2k/fOUeKcqSeL1Mzc/o9xO
	wUFhkujfHd8UfRQOWv/t/lHaN4s1Quw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BNNKnEC6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765891943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTHtpRyo2+sW5qRsYyBIkYjmvTD6U3MVUMeZA9kiXv8=;
	b=aZkrkFl+LtwZlqv4mgFcVxXZgyoq2XiRcG6Gbhz0EuHnmt0O4QB0Uk0xKd7qNTcQpvY7Lp
	FPZEAP9ic3dS85feY2ZzW27OWakvDkquJ5qgHimiRHsN3aLPS3qkkQ/odcVuLvrRQ0MHh1
	bqes2fFEl0+Ghp6cLAQ9X/lwGUvVqrA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765891941; x=1797427941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N9t0mkY5H1xtpiI7x104oD8Kp+A6sUMpGvqI4yStues=;
  b=BNNKnEC6Hzlt3iYC9voP5ymKthiGgBAeV6/gvPqbPAS4PpcqK3XWFMwM
   PtNLsVkChIyBcZghKou++5kEjf891tHGq1l4Ss6A8YJlAN3Z6eQYdRf/n
   sCeUytVHRDzj04j8RViRoqOtQQAVi+0at32/GioOnfW3L/ssDFtRUDlPS
   SlrFNPSrmeWmqWO72e26A1GUa5pWK5sdgc2ueSldpFvp663LXj99eVBGO
   EpUeUY0gNLncV5HK9jro+9obILk7CwY0z0Kz0ZNDpbWLEgmLXEMpjfIlh
   JoPAfdSxUaw1Z6EqGjZyVNiiQBb7C6Ree1hJh72z8ECx9udk5nOjYXbo5
   A==;
X-CSE-ConnectionGUID: dY2dh0tSQCutK8+Okel20A==
X-CSE-MsgGUID: lc6QyJZ5TcueAM6OCtN70A==
X-IronPort-AV: E=McAfee;i="6800,10657,11643"; a="55379810"
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="55379810"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 05:32:19 -0800
X-CSE-ConnectionGUID: gTGHgYNtRK64Rr8AmdNrGw==
X-CSE-MsgGUID: vawAui99Q+6aZIR+plrxuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,153,1763452800"; 
   d="scan'208";a="202928251"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 16 Dec 2025 05:32:17 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVV9z-0000000037c-0QIS;
	Tue, 16 Dec 2025 13:32:15 +0000
Date: Tue, 16 Dec 2025 14:31:54 +0100
From: kernel test robot <lkp@intel.com>
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, npache@redhat.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <202512161405.8IVTXVcr-lkp@intel.com>
References: <20251215090419.174418-4-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215090419.174418-4-yanglincheng@kylinos.cn>
X-Rspamd-Queue-Id: 3BA92160017
X-Stat-Signature: xo1jfphm64chkqeueikjswdpunzyfaup
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765891940-307284
X-HE-Meta: U2FsdGVkX18oB4kHDfAARdO3yZatEnlsFZvqV7YIQoxSibVDU2BSZ84TYG04nYUDCzrvYt7peGaP19GktCzXO9HSUHoE80jjpP2eOMRU4IWvVVcZY0ywUYEwr8rjDRcknof+XUq9zxvyAl7gimaftc6OHsCgbYCDcbZr2ssrWB/QyQ0TzWnQ47nMwq1miF5w1PzUO8afQ1zvtm+/2xs3/nYExAYfraMx9c+uawFdWzNJKOsZQGKqyhR53OcMrwMWUKRwTwkncda2sim9fxPyQC9zYrRlBeZfzAhGj9HublECbGDe1BlfqgDgmQ5dlClTUiq5VIGq3lOJ141y/Kq+eZ0YN3uxr8LAuw764hRKKWK/LCJQz2zQ8i3mHApz0owDxR8Xj4Vi2Jq/W5tHFocGZ30KD+jm5PxwoLT1nG9sLW+pLOMa9wZFAJFG55+fJgyUqmzMHB7Ywy3q6hyDux8ubE9oebWZnBCILNnkUzWcIDSf8WoQohaeyxaPjLgMAvIfDQY4HQfmWUwZFEK5RczbFXl9S5dGMf+LVn1+4cxk/csdsF97ZV47fwietS3dK8MI8bkiBvYbb+5ujvEaWh6MKTB5e83N6B7QhGIcTfmvI0to1YIx+NsBBf4pDIoOg1hx9jdcb3lMnwY5AFJBD6Hvyol/AHSF8BR9QIOpt3UkSc8S9iCG18kJOT92stlv+Hk2UcQgA0zEAXiJvyQDOgJQL+vH2C5r4GuuLDajnw23F7V5Ag3aZbVGXMC07g334iAMzBThrx+9FBEbDrnLfMFwq+Q+u6YceZIZczd4CBCFpfGq1hVaFWJgqYSQ9euM146t0Wd8lStA77DGaXGHIaU2rHQ+KN+2gAdLSbMWjP0m62G5NHJfjMOuceJEAgidDnh1RIn5zZKNjwjUQ2yLtZMAmpwcBcJCBTv5ls8nYNMyTD+lNZiEz7k7JiBZjiY0Z2Qn8+6nT4nu9SKqOKiGgN/
 UCZJnpBW
 Rv3raaOrylD/i8y+FFjPFur1u7vw7zK6/OL+tM2CprfzMtx3YRMcKZzfIiRGvQ+VyAXX2eir54jKdXCJsbK4h3dmyBbIAKWVJRv+1ErTVP3oc6b4mHSI6qiFjxS1iJX9VIelseSSZ9XcxUHWgFzPNPquhPQzZ13+Ysdn80HH+IVq1tZTu1IMF7LdeP1nPWhTvCfbCshd8+LTA5WM+AFOY48FMlif9Ij3rpjP23iOyJKIf7BnMtxM7advR8HOq/97Z2C7w6A0D/mK/UpGASLgrncC0H8CCTNYW3K/36NVtdxPJsnHq52/pkRADxCHzA/bKzwSKTBOscyAY8yyZZNRLcGKixKztF4pQsIibM58eVz3NxqxfZv3jEe13x0GL1ulvz3XqDKFrCsngV+syWj+3TNDs1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vernon,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20251216]
[cannot apply to linus/master v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251215090419.174418-4-yanglincheng%40kylinos.cn
patch subject: [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251216/202512161405.8IVTXVcr-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512161405.8IVTXVcr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512161405.8IVTXVcr-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/madvise.c: In function 'madvise_cold':
>> mm/madvise.c:609:9: error: implicit declaration of function 'khugepaged_move_tail'; did you mean 'khugepaged_exit'? [-Wimplicit-function-declaration]
     609 |         khugepaged_move_tail(vma->vm_mm);
         |         ^~~~~~~~~~~~~~~~~~~~
         |         khugepaged_exit


vim +609 mm/madvise.c

   595	
   596	static long madvise_cold(struct madvise_behavior *madv_behavior)
   597	{
   598		struct vm_area_struct *vma = madv_behavior->vma;
   599		struct mmu_gather tlb;
   600	
   601		if (!can_madv_lru_vma(vma))
   602			return -EINVAL;
   603	
   604		lru_add_drain();
   605		tlb_gather_mmu(&tlb, madv_behavior->mm);
   606		madvise_cold_page_range(&tlb, madv_behavior);
   607		tlb_finish_mmu(&tlb);
   608	
 > 609		khugepaged_move_tail(vma->vm_mm);
   610	
   611		return 0;
   612	}
   613	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

