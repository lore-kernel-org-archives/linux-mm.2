Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D4ECEBF72
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 19:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0EA8E0009; Sat, 15 Nov 2025 14:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398708E0005; Sat, 15 Nov 2025 14:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADD98E0009; Sat, 15 Nov 2025 14:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 194108E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:17:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2C9889849
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:47 +0000 (UTC)
X-FDA: 84113800974.18.0E769C3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7AD20140002
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:17:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fO8ifyPa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763234265; a=rsa-sha256;
	cv=none;
	b=uaEiq7nLXDskn/VxCQ1Z0gr8L67pHmFLkZyJ8OKVKdJRM7729SyaVJUN8LjLoOHuFN0Ryn
	2Hk/8Ayy2oN6QO4vtmgPo6mH1EGhrPf2keDvIYUbhbYaX4z0SmwRgwTOfw7I1O2YI8TwAv
	MNwnccqgvzjs5OJaCzIC5yIhEBtfAQg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fO8ifyPa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763234265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UmDEZh5vGq0Z88G5Am9YVdXZN7joxBZGMGhV0p837rM=;
	b=KVYzkBq9HG8lJBB5L2XyuuCTDHLAUCbhFZw/OdDEORyBBoXgbZOA6IWjJVFpSUlK4GnpM6
	Vx9a+8GAAc09q4LmsGZ3zWk32EKwUMYIJv/ik+P6UEe4bCc7eGoGA7MTynDNN4Jhhg/azs
	11vgxQgfBW/dxwtftw/0/+NcY/QNYNI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763234266; x=1794770266;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=bwvI3c+HmFTzePIicqVXEPZEDllCSbcNtYHq+t1aXVE=;
  b=fO8ifyPaB3ONhIQBgtDhZS2v2DKeLESKBeCx7JwxUE2eAE7vlYhCr6yx
   J4eJdOLhsuj6cAjDtHvBta34YcScbg11MHXf6r9LFVHQ9zlQwVS+c13/l
   IuLNeEV8vP9w1woswXWKDxFkFoWb8xrXo7/nGkPBw3WgdVdNRA/Uv4+O3
   uTFGDYRibgVst9YxvBRildzxjc2+4UKXlpyf3XSvOfRdRxb57II6eCGMU
   8remUv/NCUHhUqPb8o1s33SusiBH11QdGrSb2AC/m0yhfWP4C7DU5OJD4
   Ho7IBclgjLEs5ocpR5rjh3/0PDV4fO4GZvDcF796EIHd4YQ22MP6uWiNF
   Q==;
X-CSE-ConnectionGUID: CCAMnpIVSnieZG6sf/vYTA==
X-CSE-MsgGUID: NFAZlCHxQwO8seyPToMTiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11614"; a="67901331"
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="67901331"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2025 11:17:44 -0800
X-CSE-ConnectionGUID: eboLaDQ6Q/OFyywf7DDL6w==
X-CSE-MsgGUID: RrtIGC+/RiOEFs1XvRpx7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,307,1754982000"; 
   d="scan'208";a="194194209"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Nov 2025 11:17:42 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKLmG-0008CR-13;
	Sat, 15 Nov 2025 19:17:40 +0000
Date: Sun, 16 Nov 2025 03:17:16 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [akpm-mm:mm-nonmm-unstable 82/133]
 include/linux/kexec_handover.h:108:7: warning: no previous prototype for
 'kho_alloc_preserve'
Message-ID: <202511160332.SpHDxf5J-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AD20140002
X-Stat-Signature: h8ts8poypdngckmujppi568awqb7iakd
X-HE-Tag: 1763234265-782155
X-HE-Meta: U2FsdGVkX1+MxZE8qC4oonDvEmWULZOXNrypyVTbQYK+L8xn5JsBDE6r8JKgISO+ZUS/MVjs4tpuObQ6wIUUrMV/yLk/QYmkCnRzjOKEH7HZ9t898X8DlIFmW6ngc5zGi25CDnXF6ygBAfVhl55aNYDmpP0U7tcm+HEK4PATs5cXQHBqJGAuUPzDwb/3WMju0K53UNZi1YcF1YTk/5VuNWnhq67RsYWmcS0FmeezRaZxNEDCIAadstMyY6V75RfmfY68sI5p7LhDsEt87bxaWwsKQuTG6uqqFAI9AT5YNKg+nrMV3d1mexsNx2p7sB1Don3YvzUiB3GUS4KBe35jrk90gDyjx90J8zZvB8A7VOCFKp4wDzep5JFrhDLdrs4gWfO03k3kcXYV2FSFvF3va33C4Ny6hW5QVXikATQ94Ta7IabJTTKYINmopvwvJ93TQMC51XFWvr8kPr6azeFkJtLMxN1B3dCETQjLaCtUEWV1aopwIHk0/aNRIY+n8J/w6NzcyutzqqSLvvsAfjfvsvrgoIDGi2WdebdiAiXwRZ7P1TUY4h4Y2MVpd7MzzqNf9+2iXWzK8qDf1CEvZKw7ikJ13PzV3COWcKixVhBU+mg97y5djurAbJaOsgNyxWwQzLhnSzn23F25sONHJPbsn93h/m/ZiF930tv5PbBDyh9cztqrdAgFH1TKtqS6G6YeUQoCbVllI9Vwodlp3FkGBVDhf794cY19xtRST+ji3v73lxwZQe/PO6IdgENPyXTt4zFW9MRH0frJjXkvNhPfMsy3vkKst9MNRm97f8eZJQvmvM0MrWBG9W2alDoIEQ390VN4EzKFUETVHSshKnBkURag8U1yyfEppkduC4icC5S3RGPrd4RAK9apeNUdf2ipBZJSZLFOYFew6lhFk2vbW66B1LLrsbYbk0sDNeishVUhL5BosyZ62tUztAZdAT51yuhrO5B1Ll+APefgkvj
 NfWAeVqS
 pMzeVH7FnR7H/9Gr92Z5N62GztNayQF6+iPR86uRDcx7yOOiIWmEB5lKsJhXMFpxILlNPeibx9uOeLPyc65upzYvmqnu5HIGjKD7wYPVPibKhmWTPf4QEXhebHmNkI+3sCOlaq6TtaVDhehckSqSJUJe+no1OvPZ1Cu+zVv/NvZHeAK0oR7pfzktcBnfoX6QajYwLiUvCv8pJsh5kS/AqZyJNNF72Bo5QwnGM0Wss0E/3/hTW3M3rLZC5hFm7iYKSbAUr93tHxvMmzl1QZXpVJBdbdknnKDVMXQtOpHclFBg1LdDTpiJiFylpLrDPd2mLnVrume7P4KPKGty39OJXYBOc1hMTLMVLlfSgsNOMiZZLjcHY3Sg98+h88Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   4fc88c237bfe11bde443e104428aac56e63a997f
commit: 88316955b5b1b4cb0cb2fad416f7e8dde9b246a0 [82/133] kho: introduce high-level memory allocation API
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20251116/202511160332.SpHDxf5J-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251116/202511160332.SpHDxf5J-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511160332.SpHDxf5J-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/mm_init.c:33:
>> include/linux/kexec_handover.h:108:7: warning: no previous prototype for 'kho_alloc_preserve' [-Wmissing-prototypes]
     108 | void *kho_alloc_preserve(size_t size)
         |       ^~~~~~~~~~~~~~~~~~
>> include/linux/kexec_handover.h:113:6: warning: no previous prototype for 'kho_unpreserve_free' [-Wmissing-prototypes]
     113 | void kho_unpreserve_free(void *mem) { }
         |      ^~~~~~~~~~~~~~~~~~~
>> include/linux/kexec_handover.h:114:6: warning: no previous prototype for 'kho_restore_free' [-Wmissing-prototypes]
     114 | void kho_restore_free(void *mem) { }
         |      ^~~~~~~~~~~~~~~~


vim +/kho_alloc_preserve +108 include/linux/kexec_handover.h

   107	
 > 108	void *kho_alloc_preserve(size_t size)
   109	{
   110		return ERR_PTR(-EOPNOTSUPP);
   111	}
   112	
 > 113	void kho_unpreserve_free(void *mem) { }
 > 114	void kho_restore_free(void *mem) { }
   115	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

