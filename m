Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F159606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=MQJP/Zeq
Received: by kanga.kvack.org (Postfix)
	id 798936B0380; Mon, 19 Oct 2026 16:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7497B6B0382; Mon, 19 Oct 2026 16:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FA56B0383; Mon, 19 Oct 2026 16:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407F66B0380
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:58:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E8E6A84E4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:58:26 +0000 (UTC)
X-FDA: 85340589012.21.6844471
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id 685781C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:58:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MQJP/Zeq";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792443504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etQvNscIjqvkrWpefPH+Ohc94n3wsi43ZWyZPkQfApQ=;
	b=lRAZmVDaZKDSRmWO5jDiauHg4EA8ZWaNl2gsnRdA0fa1drB4GqgUzKoK21sDMfaZP9P/6k
	NpRdZv1EpoR2ClaSNZ53jAC/orEN7p7i2fxNmbfbwRuBupRtavFoMPsyrcOtRnDONxfGB5
	QEUPZB/cQmuglhXKj5oUTBenmZA7Gbk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MQJP/Zeq";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792443504;
	b=xZyXRykz9Srf+cVFRn/EJBDlMMn29nEutODee/lsTUmmZhzWjEvqB2IbUZau9AS77TVuYH
	X4hbkLenufPL+Nodlg0xHn0jwdHyxeaIc3GxLnyYCdf1wm7/hT/xga9FwW5gzCx2V1FCcV
	EV342ruPwmaLwAQY/PDyRSHq6zCIMo8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792443503; x=1823979503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LjZKwGBbVcACOcsPvYU618VBeMr1LoG3ldjZ3OGSp3Q=;
  b=MQJP/ZeqaCS9Hl76Rfka6j/Fyty9PVAXaYJuFhaL+ujI1YEvAoTgtqbi
   xYeK4Qe+kVYy8C9eAIBUuld7ggPEqP4uQeYCSt9CAogVx6ZT8vPGwylx0
   ZXYdXSaHaO1zoxSw6me+mPJOEexthNvdGh95al4OM8hxedUa9CZ9W/rvK
   9a0cdgx+58RLW9rxlHlUhSF6VHq6uUCWS/dYOMWsXwx9ZpOKOVHbT1Pn1
   ZpfSg/AGa5vpwSy2ZRKBKWyrnyvYRIF4vQuR2QIbSDDuFz3KGD1Eg6wlO
   OxiqNQlaNICcZL4BMYycn6v16HTfEXYmbqSkyAL/Aoz7AL0BUON9jCFwR
   Q==;
X-CSE-ConnectionGUID: YURCcVnuRv26C5qInF0FoQ==
X-CSE-MsgGUID: bpgYZIpzTLW6l3a2vFrmLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1240720"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1240720"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 13:58:22 -0700
X-CSE-ConnectionGUID: l4uSqfeCQheS9pa1UzaC7Q==
X-CSE-MsgGUID: pxRj+kMZRlaHxvrp1glKuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2943062"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Oct 2026 13:58:18 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xIuQx-00000000MO2-3Cks;
	Mon, 19 Oct 2026 20:58:15 +0000
Date: Tue, 20 Oct 2026 04:57:54 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 next 03/15] kallsyms: Improve selftest
 test_perf_kallsyms_lookup_name() output
Message-ID: <202610200434.qSHPOyDo-lkp@intel.com>
References: <20261018155206.132411-4-david.laight.linux@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018155206.132411-4-david.laight.linux@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 685781C0003
X-Stat-Signature: b4q61ko3oit1tf47diazu3btazi1x9aa
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792443503-856521
X-HE-Meta: U2FsdGVkX18uL8xz0/4mDEZ0E6yNTdmOzDKuI4FQA9E5sJiJISxZX2zeojFWDPmnl+7j/khJIHWjuZjajLwHzQKg5jB4NtXqaIJlFusWRqevA6WkOJP8vs5sZvn5pf27MqIjyB6cMhFwpHKDAp2w/auIBd1rOvKqf47PmW8plGJjREao2nCM8QCXIbjcmAXpTQCVrW4AZWyUYat/l+3yP7t0mBaNJ3v8DT7z97d2q89S1gJL37RpoBb6fZ5E57Vy5qedLk4Lk4tCCgrvIplplpEiWwuFIVOHL8qPA0WcJRRxH6FvAaU1jpzDtcpdQUTpdKDvKptX1As7bLo+YbgxoGFzH3eebX1rUCYO2mzWsdXafK0knSehhVPpc2nEl0ZqoyIg7wPIVIkPrsMdxwfT0/KCX8uIZkozjHbVMsgQou1eaPhoDHESWfQUz/AZk6xbX2gpDc/pOahVlh9rAZfqloQNv8x0UlqvReO1tcLb5qHClZ9qPCIJnp3CFX8PC3l/crnD2D9GeyFZnrIJjvlzFLsSgG2X/8lEeeX5WxVnXgBqkm9sWZmySFExeEf6fP89UxrKdtUc+EQH270sEAbIJyB3JyF5qEUT2DKrEytZLAjwlv4usa3FdaWdZz3w1uQoh6ss0stdAGj07TQbqiWjIMNP0m6vk8DA24gCoyaZBz2q2+l9aGnUr0ibcXY8wmM75hqCIGavjB+zLV+CLsbcUUgK91zPHuJSJ6oHyp3NyzpJq5DeRJV02+ZM+QfzJL7J382D82pxL+Iqau64Howu4QeKACSP3b4886KvjIlyk3y9r82tyFrfy8+RygufjZGLuTU94YNwRaXE5kA7hEtaWuiKmWEKNcLIJzi5MFawqL5u+HjIiX35lziaQHBFYtFJhx0dBF9t9BlIIYsk5fXIo8+TdZGlmcwYN9xPNrR2n4eSIR+eFJOJNZUFJSUH4H4q9HL4Ty8tF/WXsMiuaWe
 2Fv4uIu3
 6Klcqz+Yuf1SzsQj29rhnDKhFikj5dDW3I9vSVja480BQ2Kn1ArA8Gqe+1+db586Z/rYKVFJ+2g34ySN7O84iCrXU/hVGSwHW5cJQwz+RwB+MMUjDGTsJoEMXzrQb3EXN3zdiim4tTWcGWsHPWUZV4OPz5po2hUgcKMw/B5CZq1ibrxopuJttalGQNzYqriJQGgUBQOuotBCG+ObpYjWZshvABr7omGc1fc4dDgSQUhpEH0qdknRDXH0k5JfXZxakDRJSBcr319DShsGD3QtrUpz9ACGPTFy6bTXMBt2pwD6kFUvIu47JxQ3t31fkoprONU12mTNNIbx56gB1c6R6euvjDCovdSPGr+ONUssJ+bzJ+Qz8kncMY5PhW89w+pxMdaAOMq1EcSNLKdrCeB8X9QXylbpDzY4VoTJbKZtpzm3TrkK7oLSUycJltcd5GwyuiGb8VxJQNBBEuMO2SRMH6h1yQQs99LJaf6DRt3hrlpTjJEIMOnbkwExFvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.3]
[cannot apply to next-20261016 next-20261016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/kallsyms-scripts-kallsyms-c-Avoid-overrunning-on-stack-buffer/20261018-165152
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261018155206.132411-4-david.laight.linux%40gmail.com
patch subject: [PATCH v2 next 03/15] kallsyms: Improve selftest test_perf_kallsyms_lookup_name() output
config: arm64-randconfig-1000-20261019 (https://download.01.org/0day-ci/archive/20261020/202610200434.qSHPOyDo-lkp@intel.com/config)
compiler: clang version 21.1.8 (https://github.com/llvm/llvm-project 2078da43e25a4623cab2d0d60decddf709aaea28)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610200434.qSHPOyDo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610200434.qSHPOyDo-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/kallsyms_selftest.c:82:12: warning: unused variable 'The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun' [-Wunused-variable]
      82 | static int kallsyms_very_long_name = 1;
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/kallsyms_selftest.c:69:33: note: expanded from macro 'kallsyms_very_long_name'
      69 | #define kallsyms_very_long_name \
         |                                 ^
   1 warning generated.


vim +/The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun +82 kernel/kallsyms_selftest.c

    81	
  > 82	static int kallsyms_very_long_name = 1;
    83	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

