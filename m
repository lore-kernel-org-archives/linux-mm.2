Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A09606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dd3By8wU
Received: by kanga.kvack.org (Postfix)
	id C834C6B0A8B; Wed, 25 Nov 2026 12:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AA66B0A8D; Wed, 25 Nov 2026 12:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB196B0A8E; Wed, 25 Nov 2026 12:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 838236B0A8B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:16:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C90B120F3E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:16:27 +0000 (UTC)
X-FDA: 85474295214.27.D50173F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E1361C0018
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:16:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dd3By8wU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795626984;
	b=EAgol/NAlFi1yl5mO7GGIDxx+S+qfZ+jR3E6YiwewKCBkE+L8bxPLRpFpK3Jt5LKaz6HyH
	K0bBgbg8RISLbQbKOSz7C2Vwwo4cWtgMXfLKm21sCtoLUBMlpFP2ET7+Z4ch+f6LLtpzNP
	nzNoPXf5FxmMShaAYUynF+gF1QookWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795626984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XJ99uewa+KtsNo9XkOKtjKPjKDCzD0NbSDxZp+Yar8=;
	b=bGYO1xD8ObzE2eSfeA6rH8R/+7X3tvwcrn+xATxmhfySS1xA9WaGrd0XycxOZBqAlGLLUQ
	N+so8FyCgtBC80wvLe00OatoBLvhZCm3tyfMZtmrFrJCjl9q9gCY4eonP4E9LI2qfLThWC
	YyEy/rfi/4cFW7+VuNLWe+v8Js0Y72s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dd3By8wU;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795626984; x=1827162984;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WcuGcUE+EwZ5wRASadJcsmh+YFYYe0xIYYtZnCYENIY=;
  b=dd3By8wUNEakZyh1dWKE2/URg+sKRJZ5S7LPSjOQaa59LxHmO0IkxO7B
   fG3o37bAEFyZoaIWDDRBkBvsx312RekKbXU6vF6G5aKAmprK8lsxeqE1z
   QhqKYMwnl+8Z0Ba4syjZQsYLUsTPEQMPW//685myOBM33r57pPqQVx7/S
   Gh4ISAqwMo2A1bKGPBxFk0Os7q+Y8Z2CGHjgK7YJMcEA27EetN1mOx2r2
   56HO0Swjtr8Jldn/5JxPIBIXYTug5xK9UQ8CQx+Z7Gsec3MU6bZO4NZzB
   vlmOqLqynhxakBQzWJeRWgvblzd5zAet7lV5xzu7VmiBVi/9Yb5fuT2OQ
   A==;
X-CSE-ConnectionGUID: AvCJsHbbTi2Q+9yP5ekAEg==
X-CSE-MsgGUID: Spb9TixxRlm23R+WL7OadA==
X-IronPort-AV: E=McAfee;i="6800,10657,11977"; a="4504434"
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="4504434"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 08:45:12 -0800
X-CSE-ConnectionGUID: N09VVOjbRLiZ5trnYphJjA==
X-CSE-MsgGUID: KqMnJCIJQsSP7hGHZ+fvdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,233,1787036400"; 
   d="scan'208";a="11802730"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Nov 2026 08:45:06 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWG7C-00000001S7G-0Bev;
	Wed, 25 Nov 2026 16:45:02 +0000
Date: Thu, 26 Nov 2026 00:44:36 +0800
From: kernel test robot <lkp@intel.com>
To: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <emmir@google.com>,
	Andrei Vagin <avagin@gmail.com>,
	Paul Gofman <pgofman@codeweavers.com>,
	Bharata B Rao <bharata@amd.com>, Daniel Wade <danjwade95@gmail.com>,
	Yin Tirui <yintirui@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shivank Garg <shivankg@amd.com>
Subject: Re: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
Message-ID: <20261126003542.QALFbvl0-lkp@intel.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
X-Stat-Signature: uffrb4hziytt9wysog9tef19ptipmx14
X-Rspamd-Queue-Id: 8E1361C0018
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795626983-633725
X-HE-Meta: U2FsdGVkX1/YJib0zw8OS2Q8OMrK1CHf9Ty+/tMMJ1/3GO+ieWtkAT59RSUA7BeioVHXSfHOhemMDUz7AQ8satQKY3fTHxgAQHIGBY+uJ64AaiLp+tg2XRO13/YOZ5hoV/ZsClmnXqD1QjHRGQJ2rIWiotXShnGwT+M34GcxE80paTNiq/YVUzEAdqvEjEQmveU2We0XaH4aesFLd6QuWhZ4u2uDe6a+OsryEtVdkPEE3jOJgLkyhC7mN2JBoubm10jJf3XbTthVURUvGWrGL2nO+DPazJD68FdRuVIppDnSBe1DWGyHBBFrw5JZ3xVaUW03gpINn+AbyrQHzG2K1oOM2/9p1xpbELmtbXkqt064dvrQHHpGLZvgFYulqrTUyOvuKRvqsel9z+ssz9VQ8t2k86FD77Or5VyVeZGIMw7TXF5vge/WeWXiAzSGg6KSr6JJjq+iAVhYS25JYMdauFUeRYzY9YtcXmFDB7TknDUnsJN+TisTh3d979LrId7jsmScAdrR04ECkqocalv0IDS0wnhFlKoe4eH4UHfmcbMMQeCZcUhBe7/PrAK5wfajgXQicnKvNvjEdDDMGKSAgC9rCX+gKRS1xeljnVVfRBKreIjtisjHxftBz55sXe8I1HRcfAfwm/dB5AmEVETjq4eHNjZYhQrKJevTahdsc+5m8zuUdnp8poi6LxqxL9sPQkyebfry0XPxQ6gVkSonlxADmZvFkHjWBaubKBE5owS59Z/bzuZsCPQevkXbgmPXAiev2TdKtkYrkefgvJ5S1nQmizwPnKszJ/Mt1nib5vikAEx2sOr/LmgQO5T5Rdc2tIRs6Zw0fa92Vd0N9Epq91qYUNu4sh8ii3FIy9yhtfIOjkwbIlY5KYiXraGqKjRtAYJYmRht04zijn+peYVRY9+LiR/UPmk2i1a3PtcbiV1tNW9mM9NXeIc/EkudmSJ66kkem/pYQBP7ghWOn+r
 uTSf8GT1
 xgfMcDEVwXwP0P+aeGKO+KSI0uHdAThsr+LQYGMCF+LMlDEKNeNyiLoj9e+Y22E7JkLmTg3glWqk7HgsuDGUPN3ug9yBhwxVTOcyeviEAMUgLMEO+JfaZRWeyNNvQH280tgj/DfTdph7jYwzO/Z34uNf1kk3AIUzbnDdBf4kQ/cBUy4KDcZMYu0c/aU6cm9H0GFojIM4BRu1yX+bjQr8Bp5572BlPO19GfmkSennYgKolQfCA63TxM2/mqkvcF/KKA4yIVXGU6y1Ax3/iEw2JthMzLHFXceKzpBy24El0IQGWY9QJ9AOfdr86qLKVjjCPdSE6wwNRIOPDwgpEKW+WLPmo9QO2Wvi/TNlW55a++3+hNMONiRBcauunlMVz+PAiYCMQGeLpdqUShEUBoq4fpAJDVP9al8aStaN4mTulbp6NuKtRBN/I3Pbg3p+1fa9ofGVBi64/ukMpGyWJ1DHd/n/+ng5Ms842pgVV6nsaZiv0RasDHzLeZInzM8XhpDGp301H4Pv0fiCYwXmwgxnAf3pILVeZAC517Ird8b06qKweGYuLQxz8sZxJXWKNTv9XnsRd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Shivank,

kernel test robot noticed the following build errors:

[auto build test ERROR on 98f6b507621822477db7ec7cef8519de0dd243c4]

url:    https://github.com/intel-lab-lkp/linux/commits/Shivank-Garg/mm-move-the-soft-dirty-fallbacks-up-in-pgtable-h/20261125-133227
base:   98f6b507621822477db7ec7cef8519de0dd243c4
patch link:    https://lore.kernel.org/r/20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c%40amd.com
patch subject: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20261126/20261126003542.QALFbvl0-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126003542.QALFbvl0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126003542.QALFbvl0-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm/kernel/asm-offsets.c:14:
>> include/linux/mm.h:972:19: error: call to undeclared function 'pgtable_supports_soft_dirty'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     972 |         VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
         |                          ^
   include/linux/mm.h:985:19: error: call to undeclared function 'pgtable_supports_soft_dirty'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     985 |         VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
         |                          ^
   include/linux/mm.h:1000:19: error: call to undeclared function 'pgtable_supports_soft_dirty'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1000 |         VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
         |                          ^
   3 errors generated.
   make[3]: *** [scripts/Makefile.build:185: arch/arm/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1417: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/pgtable_supports_soft_dirty +972 include/linux/mm.h

027232da7c7c1c Kiryl Shutsemau    2018-07-26  967  
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  968  /* Use when VMA is not part of the VMA tree and needs no locking */
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  969  static inline void vm_flags_init(struct vm_area_struct *vma,
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  970  				 vm_flags_t flags)
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  971  {
277a1ae3879a82 Chunyan Zhang      2025-11-13 @972  	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
9ea35a25d51b13 Lorenzo Stoakes    2025-11-25  973  	vma_flags_clear_all(&vma->flags);
9ea35a25d51b13 Lorenzo Stoakes    2025-11-25  974  	vma_flags_overwrite_word(&vma->flags, flags);
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  975  }
bc292ab00f6c7a Suren Baghdasaryan 2023-01-26  976  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

