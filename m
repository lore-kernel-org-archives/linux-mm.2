Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC80CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 809498E0012; Mon, 15 Sep 2025 14:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0F58E0001; Mon, 15 Sep 2025 14:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6B18E0012; Mon, 15 Sep 2025 14:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2ED8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:34:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A584BAF60
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:34:15 +0000 (UTC)
X-FDA: 83892334470.13.72F4027
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id 58C541C0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:34:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="izOqhM/D";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757961253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YNqKk620ewXGknZa3uh9Ff/B1oqvR1Huk8EUzdnUaRQ=;
	b=ZV4RBszNlGPzqweXuI1Px1O4O9Gbv6/OLxiU1sl0DPPbyRt3Mqb4bnNrRwcEjOmM8dRtbV
	MQtf1oObbH50CgsDMjfNUaKEmPrFbdPpNx7TRFK9/8F+InsBAdoPhms8uY5GmzeEDo8N69
	ZdDXJMhLVqp5BkFtAlzfyG+e9w9Js5E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="izOqhM/D";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757961253; a=rsa-sha256;
	cv=none;
	b=5HAKoZwuoOidNRhq7Y0r5HaCEMqfSXDURRGtj3LQk9+Y3F5DA7klUUSyQS/5cPm/FeeCWC
	0ubicGKlQd5J9EwgXlWqlmunbGIAfP5Sq87UjUB9vaY/Pd3QC+MvPOHOGHtg4ghjJjpsHL
	u40OWyt4IOXvrUdEV4d3LDXUqoxhc9g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757961252; x=1789497252;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=TZC+H6eRGc+Z3JEU3E9ernW85DbRAtUT36rFei+847E=;
  b=izOqhM/DEOZdQwl7+ZOPsG7k4Erk9iWsl618CE7mukQYTXPksxnkJDJA
   UMkHCyhCzbRo2lhXVk7JSrV1Dnn0DYufQI1qRVryrTCjOJoKHBmMdKfrR
   S6tCId5WHSRK7k5tuu2EUWckX8ugqUp3CccQT9m/SbR4HgPtFiWr3AZkQ
   Hh53Jyswm2Qc6dSU7qb//npmNsOZdRM3mVd+Y1T2WAoJvyhlc/Msq3AwL
   pnwOnG4nD+rWEqQOHgCSR5vfKwlEl0hyclnDidvpWH+tc9NNkJdJ/jQSA
   4wT0MsHYQ9bsgT6NZpAxBBkcXXmGjVZ3ZYQGIJvx+AkZgZAnMX5uU6x40
   A==;
X-CSE-ConnectionGUID: 1cK/oW5ISQSYIUUaxpvH0Q==
X-CSE-MsgGUID: aFMB2LHFSiqi+lj0wS49aQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64036631"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64036631"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 11:34:11 -0700
X-CSE-ConnectionGUID: 8/5D6YqKSJu/tMIX803gYA==
X-CSE-MsgGUID: lcODT8ceRA2A5kunGGrhTQ==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 5b01dd97f97c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 15 Sep 2025 11:34:09 -0700
Received: from kbuild by 5b01dd97f97c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyE1e-0000ZT-2x;
	Mon, 15 Sep 2025 18:34:06 +0000
Date: Tue, 16 Sep 2025 02:33:42 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	SeongJae Park <sj@kernel.org>
Subject: [akpm-mm:mm-unstable 187/225] arch/m68k/include/asm/page.h:20:27:
 error: lvalue required as unary '&' operand
Message-ID: <202509160214.gDtkbWC8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: yqio8fffb6rd8wuzidm88fnqneygsjmu
X-Rspam-User: 
X-Rspamd-Queue-Id: 58C541C0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757961252-170316
X-HE-Meta: U2FsdGVkX1/KgFHvPgVGYyMhfsLxI/qyt1sQ/I4IycZgPz3rvF9JxmEcXYHp6Qmp+9PJgeax22VI0hZj0APUsTcA0V6uu3CZkiW196chvvzzPf6TUR88sbOHDHIWtgyUwuU9U49j+Twes8HmR4m3bSpzvpWkf1mFf27L1nbPjuoat1fOW8sSzRYsQedQO//Xm8TD8IvgF5UL59N+46rWYlZSyUvOS0wco/ffOIKGHpMf6kXcEYIo5mWhN7AefiUMpniRMT6uEj9ZpooUTuznWAHSZRQfy3cQ0I8tVWA7WGk/ZpYnyyJN8Z8ZOJSziM7a5hrfJ7vYC0MT1tlSYZvuZMDBok1L+BNNR5pKcRcUcUsm2SphcaQMzj/cae18NPm6ceefkt/0NLfq4FJ2i+mCkasrVWC8HxJkpJb8kyqq7r5MaEl4pOywUe4hYMBsp34aA+oq1w48zypTsvYVHAs/vkQv/H1stigvn9GbdNXbNzRuWm3jTLLVaS5EcMHf9NdK0u8/Ebl8AP7nXNXXrgWcZ8LEIL4K/8rRkLKdMpayjicITz7Vp5BZt21RTYBUphGjASoeiI+HiSSkOZwwIm/pbp8f9H5tpHJ5JolTV5+Z/okpIEaMTRrOOU239MZtxnxCT1qGM+b0kZcJVS4GO9ahAv9bRGh1vCZ0Q+ATVadUDyaDd/sFjHuVOz2AsrOo2gmyElv1O629WH2i6wL351CpGRO0pmULld0nwEvy67xy157z1k1eLhmgiqhLw2LmXU2+CDHVhgGPTCAoI4HEqBG58tQiVJn/5uCI2iPMNWJugzvZG7W5IkKkm9+XNZ4Q3vvWmsGOJEifTYLrYamzK/4N+w9ODP3tkVjefpZFaPF4de1M/YUYL1QG0xbuPdLN4Gt5cbi+WVHNglJct4M2Jld9M4GCT+kBuPyzSbHrVHNd6QC6ynzIse645FljALywMPN6csL7DN4EZvmRPnvRP72
 vOP3bjXx
 Mi9RedVA0tbcCrBQEa9BU+ShZpHV2Lzz4G2LpF4R70nyBH6rlwZiXM8VkKAQXDTEoFB90Yq8G866EpzVhIa6vevHMdmmOVbvaixG5M4Vfovfp5u9w1cm7DcpvwwhFvTKxAgU+PufbnOrJMDUSbZiUA0jZUoe8z9eg7zEnAssV1B9mjI80HMCqIHM1HF0AIfqusq5mt1jQw1vc0Mj9vYS1OTwqILbPjYEfloYsmlQaJHupGLlC0fPoGe+HOpdoBuOJA2FNKA+lbmsdwrdjqLfyTuDGcLe4OSl7qs5i0YWiyCBWrANfoLqok6djiwKmFkci0oWb42TGA1LiRecgy7g7a/CcsyKtOp1DkFxxodOxXMLuP3whW5sJ9ggg/iAFuiLmkf4zdVf8xaV+xTODmHGado585W4f7gkPhfs6XDBVrxvTseRnTQdNPWEJ7YmN4ZLDkiSR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   0f409ed671a46de4b172899f7814a5bf37a33d86
commit: 00cd88c03fd1c3242be5726998b3bf47afbf17a1 [187/225] mm/rmap: extend rmap and migration support device-private entries
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20250916/202509160214.gDtkbWC8-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250916/202509160214.gDtkbWC8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509160214.gDtkbWC8-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/init.h:5,
                    from mm/page_idle.c:2:
   mm/page_idle.c: In function 'page_idle_clear_pte_refs_one':
>> arch/m68k/include/asm/page.h:20:27: error: lvalue required as unary '&' operand
      20 | #define pmd_val(x)      ((&x)->pmd)
         |                           ^
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   arch/m68k/include/asm/motorola_pgtable.h:116:34: note: in expansion of macro 'pmd_val'
     116 | #define pmd_present(pmd)        (pmd_val(pmd) & _PAGE_TABLE)
         |                                  ^~~~~~~
   mm/page_idle.c:74:36: note: in expansion of macro 'pmd_present'
      74 |                         if (likely(pmd_present(pmdp_get(pvmw.pmd))))
         |                                    ^~~~~~~~~~~


vim +20 arch/m68k/include/asm/page.h

138ff3462f53a7 Greg Ungerer   2010-09-07  14  
138ff3462f53a7 Greg Ungerer   2010-09-07  15  /*
138ff3462f53a7 Greg Ungerer   2010-09-07  16   * These are used to make use of C type-checking..
138ff3462f53a7 Greg Ungerer   2010-09-07  17   */
60e50f34b13e9e Mike Rapoport  2019-12-04  18  #if !defined(CONFIG_MMU) || CONFIG_PGTABLE_LEVELS == 3
ef22d8abd876e8 Peter Zijlstra 2020-01-31  19  typedef struct { unsigned long pmd; } pmd_t;
ef22d8abd876e8 Peter Zijlstra 2020-01-31 @20  #define pmd_val(x)	((&x)->pmd)
ef22d8abd876e8 Peter Zijlstra 2020-01-31  21  #define __pmd(x)	((pmd_t) { (x) } )
60e50f34b13e9e Mike Rapoport  2019-12-04  22  #endif
60e50f34b13e9e Mike Rapoport  2019-12-04  23  

:::::: The code at line 20 was first introduced by commit
:::::: ef22d8abd876e805b604e8f655127de2beee2869 m68k: mm: Restructure Motorola MMU page-table layout

:::::: TO: Peter Zijlstra <peterz@infradead.org>
:::::: CC: Geert Uytterhoeven <geert@linux-m68k.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

