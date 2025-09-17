Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3762CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13B98E000C; Wed, 17 Sep 2025 01:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC45D8E0001; Wed, 17 Sep 2025 01:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3018E000C; Wed, 17 Sep 2025 01:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1B6E8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:04:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66BEF160217
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:04:56 +0000 (UTC)
X-FDA: 83897552592.16.2D5FD25
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D1B080002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:04:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K4HdwQV8;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758085494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZEz55vnKWns6VDkaWcQmypGBYAaCR3xPOFfGClLlqU=;
	b=lbZdKPTA2PjQgzRdf8NAefd95l3/qWcwxgXq/u+/On8D2xYsVrcHtbUUtPRtUuqT5aqwhW
	HF0SEh18kFsvWU7KQ3cpE+oA/xE3wwW0WT9AWUDMZYWaJt2lm+zJCE7DvGiYpP4w93gxwi
	MOWBBy912OW9rHbAroIh8G091JjDUZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758085494; a=rsa-sha256;
	cv=none;
	b=rnw7UAEOPtj/yll4eFY09Fn5ryjhArREF1ewBtoqWvv01n0IJf/carSUe5BzVkIRQs2BZT
	nMpuK1qpigeZx9JWBqKfrdR9i1091O8dQ8f/8i0i0ewnblMkhMcK0r7wIb07cKJEAOVHLC
	HzrysZWHVtDT+Gi8us2F8vSL2KVZA/Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=K4HdwQV8;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758085494; x=1789621494;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X0Rfb5QCHwBe0RYYo786Yb7JEFiCMsaVK8QtiTrRVxE=;
  b=K4HdwQV8Dz9yP9OYo0V3OJAxqjIw6tscuLcXweRht/mf4VKrVMfnzXTn
   T/pT4zubk/iODPno7akNBJ+i9zWE32s1BJvEEJDPbktVqvqzDyjNzhegG
   mdWFZPKNCovY8/tDtKIcDenyZK+0vha8S3Kxp6xx5Mdna0Ug0Lj0KW65i
   z8Zk+YhO+Mg9RUyGgQU7xMrB/gKgkX16iC+xpYVPq3ahFaCOSI7tjiYsj
   RmG7i06nNV/e3W6Urjt0kk6h44sum93J+cI7tjmkoCQ072t3aZs3XsvGN
   Cl93hQCSFbFCI22K83CtBIIBvEclu7YnENAPH2nZxwPAfLY3C4ndEBVNB
   w==;
X-CSE-ConnectionGUID: x/LTKqQ4T8C1Nx+K50kShw==
X-CSE-MsgGUID: tMwJCiifSwi/6R36tgdacg==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71484289"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="71484289"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 22:04:53 -0700
X-CSE-ConnectionGUID: sB/NHNXdQIqoO2ykPrcXBg==
X-CSE-MsgGUID: Jad/lXalRXmHa4vZHqcc7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="175224112"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 16 Sep 2025 22:04:46 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uykLT-00015t-1z;
	Wed, 17 Sep 2025 05:04:43 +0000
Date: Wed, 17 Sep 2025 13:04:11 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for
 load_script
Message-ID: <202509171240.sw10iAf6-lkp@intel.com>
References: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D1B080002
X-Stat-Signature: iu48i4sce4njr1a7dewaqziu9xke4hqa
X-Rspam-User: 
X-HE-Tag: 1758085493-831923
X-HE-Meta: U2FsdGVkX18PScMrNCc1CVDPvWsmhtltTLz1IxUkCm1ACPnsE4iDPNFreqN3jo36bF+qYi3Ggqik7EzWpSbhYK4I4S5iB7L67xKNEqqGpN9kIjw8PEKGfiu7nmpoF6kcDe4j2vzXDBYIC9WYp7GLsBxympMYeFlLHSuv8wFh2U2UhsTh0tKWUhLj6oUxCQmMBwE9m0ZK7opPRBQz+lyrTPOJUJctnHIXvAnvJjzMhuEIohQoQphGtY83pMVYq7TDUd9GPAzGgbIpDKD+0yrCDN8FpqZsbGb6aG7PX6rEYA2/fcExsSpJjRrAcDDk3csZVsxYdS1u/4a7PWnci2aArkh3Syd40I1NHR7Jat6UhXVpcKYuuWdGlScP58TnzTIH4HHxDokIFT6AGA2hPiwURIRA1t37GSA7SfB6mdtiIr00MdT3KujcSrEnpVqueqyqHN0ap86iZkW+h3SLpN3e5Ocw8ho3JSpA0ARrXFSxyRILoC8dKGdBQLumIHg+Ki/vECM5OYpjRpuF0VczHts7/00FmFdh/jzC4h/pcCSHmumXtdKHKecUvIhfxLpAUvEy5WyWP8Und71s5PecdrmVhtgTOJxcju4HCHrkSIY9UzbEXVYlzUI2v25ZXS8Tx0+VYZ2Qtnz2NZGINeHJOIj9Kt8oNkrE9qGEYOulw+8j/qB9VSA/m3nmaN7xsP+xRYjMJDjr/pEMQNeJ0i6jUr7QswjEZqnqbRd6ZgIAVpg55NHUiDWilPxsFLUExYhwkeU9PO49tmAfl/W/JNUx6XDUQ6H9lkavH+sOzaUwUKDYQ76HdX/NX4t4ku7DLprofVOfco4IoQJbTE+ksHSB8hNMKU/POkFi/gWxA174GP/FJzxM8EzEBLotPeHHHvKB6E2pAyIWVm4at/ee6iOzUqrJZyBpzPGmtByKJ6HETz+z1r+4tGg3ymlEu2fBHewueQBt7WB2Wxb8IbamC+RtSVV
 LyGPzSsd
 CxdzRkYa3gxSlX5MJtXX+lhHDC1Q6SKN1Dr/xVHLk6/0+Twg17haQ/tKrjktnmhXFw2wm1+c8b/3w7hqwAhbo+g0S6GBLn/x4iJvSxsQl/BXh1eqFAQ9QYULKUohpLLfA2a+1vAocV776L1yR1hodlgeFy1jdA1/EkG7kt2aIrdYXkhqonyxnvTUY/GMM+1QITV0z124vzv2Cr6R6ZuvkNsnTlGTRfjYHkEWt+6qA9Q18egiLDH5afZcm8UPrucoh3k09IZRzcA7RsrJ+bmxzRIQ58ymVbKS1dcpGzCKMVlxMBQ8UHVT5cQSvAtituKPdIQGGGlTxi5GShTqX+dDj7X4dbXqyfIG5VtDi0UuZa8s+n6DKA+yR04cS2dCuAbnWEyoiV+1J/NWwbMQe97tc6hBTCd57rh/l+xbo4Qwdqcfwxsu0UyHOZbZpDd93Xe4x/sXcaCu5KJtXQ7xlshEUWUZ2rzMcm6rH/NLdSiFUWAD7XiivAovl3hYFPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-10-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for load_script
config: i386-randconfig-013-20250917 (https://download.01.org/0day-ci/archive/20250917/202509171240.sw10iAf6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250917/202509171240.sw10iAf6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509171240.sw10iAf6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
>> include/linux/kfuzztest.h:135:3: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     134 |         pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%lx", rt->num_entries, rt->padding_size,
         |                                                                             ~~~
         |                                                                             %x
     135 |                 (char *)rt - (char *)regions);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
   include/linux/kfuzztest.h:141:37: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     141 |         pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
         |                              ~~~           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                              %x
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
   include/linux/kfuzztest.h:142:3: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     141 |         pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
         |                                     ~~~
         |                                     %x
     142 |                 (char *)payload_end - (char *)regions);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   3 warnings generated.


vim +135 include/linux/kfuzztest.h

6f8f11abdf5c57 Ethan Graham 2025-09-16  117  
6f8f11abdf5c57 Ethan Graham 2025-09-16  118  /*
6f8f11abdf5c57 Ethan Graham 2025-09-16  119   * Dump some information on the parsed headers and payload. Can be useful for
6f8f11abdf5c57 Ethan Graham 2025-09-16  120   * debugging inputs when writing an encoder for the KFuzzTest input format.
6f8f11abdf5c57 Ethan Graham 2025-09-16  121   */
6f8f11abdf5c57 Ethan Graham 2025-09-16  122  __attribute__((unused)) static inline void kfuzztest_debug_header(struct reloc_region_array *regions,
6f8f11abdf5c57 Ethan Graham 2025-09-16  123  								  struct reloc_table *rt, void *payload_start,
6f8f11abdf5c57 Ethan Graham 2025-09-16  124  								  void *payload_end)
6f8f11abdf5c57 Ethan Graham 2025-09-16  125  {
6f8f11abdf5c57 Ethan Graham 2025-09-16  126  	uint32_t i;
6f8f11abdf5c57 Ethan Graham 2025-09-16  127  
6f8f11abdf5c57 Ethan Graham 2025-09-16  128  	pr_info("regions: { num_regions = %u } @ %px", regions->num_regions, regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  129  	for (i = 0; i < regions->num_regions; i++) {
6f8f11abdf5c57 Ethan Graham 2025-09-16  130  		pr_info("  region_%u: { start: 0x%x, size: 0x%x }", i, regions->regions[i].offset,
6f8f11abdf5c57 Ethan Graham 2025-09-16  131  			regions->regions[i].size);
6f8f11abdf5c57 Ethan Graham 2025-09-16  132  	}
6f8f11abdf5c57 Ethan Graham 2025-09-16  133  
6f8f11abdf5c57 Ethan Graham 2025-09-16  134  	pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%lx", rt->num_entries, rt->padding_size,
6f8f11abdf5c57 Ethan Graham 2025-09-16 @135  		(char *)rt - (char *)regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  136  	for (i = 0; i < rt->num_entries; i++) {
6f8f11abdf5c57 Ethan Graham 2025-09-16  137  		pr_info("  reloc_%u: { src: %u, offset: 0x%x, dst: %u }", i, rt->entries[i].region_id,
6f8f11abdf5c57 Ethan Graham 2025-09-16  138  			rt->entries[i].region_offset, rt->entries[i].value);
6f8f11abdf5c57 Ethan Graham 2025-09-16  139  	}
6f8f11abdf5c57 Ethan Graham 2025-09-16  140  
6f8f11abdf5c57 Ethan Graham 2025-09-16  141  	pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
6f8f11abdf5c57 Ethan Graham 2025-09-16  142  		(char *)payload_end - (char *)regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  143  }
6f8f11abdf5c57 Ethan Graham 2025-09-16  144  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

