Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3833BCD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 04:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616B16B0005; Sat,  2 May 2026 00:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED596B008A; Sat,  2 May 2026 00:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503316B008C; Sat,  2 May 2026 00:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 401FA6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:55:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5B751C03A3
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:55:30 +0000 (UTC)
X-FDA: 84721266420.21.437A764
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id EDEA8A0002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 04:55:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CPAsbgjQ;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777697728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38UTNlR5/wJ7GH9B/C8bYPfw6/YDxXRYcxpxaD4KDkw=;
	b=pei9IoGl+EZ3vvmOHG2AXDjlKPZoqYGZw6KcAwcgpvzodQO/bhg4x8zu8D/0LZNz2HRGsD
	50WE8ZdUP7ZDGhQVlAWuB1vwWAo8eP+JyNhDstKHhFXzRH1Tf3IUCBuzbK/UpirJyL6csC
	6gD1VlQnYKvZr9evyTHU/jmpOUtnf+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CPAsbgjQ;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777697728; a=rsa-sha256;
	cv=none;
	b=UTQ52kLXJn30cFPlYd3JTn5tJ1m5CwjstpsmELo/oDi5PjpifZeXv8EF+Lvoz7bkUgeBQh
	yxZvKa/KjgJ+LSRmKbxWtRTM/0makZYsFrvCRRRQ9BvM0IOUV8vYojSi/ZRJAJOIkrCtdd
	Hh7G+hsw/+1g6da4IwwLodYV9IAZj/s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777697728; x=1809233728;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=muz3Gn4korg+6J8rsu49cXA8q5KYIYesTuw3bKtX29A=;
  b=CPAsbgjQgabEB+DtzvgoVh140WJb+l2pBrc4Dnt8H9v4qu36N1rb0JA5
   rJqWLS54+T6u3PiSSVS4Bl/4nr8dCWwOvfetNAwSt8pXcFtC1yA2eQ0EJ
   tkZcv/UbfCl0kBlAdEoJ08AvGMfYS0bSsb1aPIV+UN+1E0ucHciSwDaoI
   zvME0dsjWpkWWbw2eVK4aqNOG4aGDKy3vuiyfPyq4s9wvB5UM+wjZB1O5
   QDUv1UPBiSVeqdUMqVcgqGrxhDu3ys/wCekYGkfUtjGRYW9QVnxeq0/0v
   Ju2iGl3SUnj5sBv5xoqhEcJhSEgp2krw26pGLCU5Vasau44rzvKhOTSiJ
   A==;
X-CSE-ConnectionGUID: FRl5wIBDQ2uvCR8uDtiaeA==
X-CSE-MsgGUID: Eba2KLcjTWumRiTvg7Du9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="77811821"
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="77811821"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 21:55:26 -0700
X-CSE-ConnectionGUID: llL2noBBTQS1hGL4KDHO9w==
X-CSE-MsgGUID: qCtvcYm+R+2TAH3W5hO1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,211,1770624000"; 
   d="scan'208";a="235099619"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 01 May 2026 21:55:24 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJ2Nt-000000001A5-0AOd;
	Sat, 02 May 2026 04:55:21 +0000
Date: Sat, 2 May 2026 12:54:45 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry
 accessors
Message-ID: <202605021251.huVQW8Xg-lkp@intel.com>
References: <20260427052000.196402-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427052000.196402-1-agordeev@linux.ibm.com>
X-Stat-Signature: wey4yrbmummxboj963euiqcyapbsfu66
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EDEA8A0002
X-Rspam-User: 
X-HE-Tag: 1777697727-217754
X-HE-Meta: U2FsdGVkX1+SCcHaAQnRvJ5S9dtnXA+La5V5jEm62w/moODwJU5+399D7B03iUIBCWiz9BMAXxx/q9JSyrVKQG6XGLdy0FKJ/dtxB1Ta8wUIfYhGjC41kLlinzg48Z/hoWh+zHI32vSuOjNddmaYmm6gFWFZkqigOH6+KRhlDMt4l6X1ePBpLTH34YpOqjMQY17Jf2liNfHqWpYD4I1w1LuY+9Tbb9WjZP83SYrSP2g9ln3W5TdG9Ugn/o64zOBGbBZxmBybEPYw4dY3msE2wRXwjgv+zn6fqkzujF6wFJHIvFuaWPSENAeWW1FSwjHXLhA/a9dNcgiStxvXLoQLsHGk3fcWCYEiajudJ3h9IgOnb0lG43OXe7EPJMR4uwFOp5OwJhX6J67RLPjcw5SutIyPbD0nYEsZkD0qJDm1ExwT8/sPtJK2pFKf39W37enIUmt/G/hog6xI6gCyRZrjcUWqP4BiuMMrPw0bCIieK4lQL+BXfmDA0kY2sD73LjfmnRh7CtBbrgpMT4UvKogJpwV7GpecPGHEoFhWi4rRC9PpRg/BhmD07viGW2O5WR4l9oc/ey9lq3JsyoT60ailwH84u2gAitnkhBz7gBYVzEIM+IB1hvvqNVwD3FKvJdFGx7XpLmwZ53OeD6ZCCouZI08Edzwvhw8oZjMVSQtD5hm9EfliDqlpGgCam88el2+LUN/Id9pMo2A0ftooD66NPreHM/LXIIzcRx/0CYQPGniokTrkRR69XZUvWg809a/kM2H+5KX2TqcyuXQ5uIeZuOxSavQyp3+vUCUpGKH95L3HhFJIjuBMFWMM7Bn40bpaojp/aezodrsjAOLcHwCbGn8bHy5/AmHvE2Q+4i7LNGqaYTzeTYcOMHNpDZR0dudDXwJlAiPj7sVWov9zkSh0lvDnNU5W/fSFAna5fsm+/OyNn4GUFmWO8QY5dklQD6nZEwd1OXN+va6KuNsZ3z6
 CppZK89s
 xwnF4AIdFeJ9FtPt92ge7xho3rx+suBJDBy3QmRzgf8tX2jM+3SB/QcxaHc9ruAzapO7ICVEr6NaST9T2jkAwvDLtzSNodxzSNtZXnseV4KgV0z7pvNz/g5NgSMRWKHl64cGdF3teMaoeAfPsQVQiYSvwHfBfIBkX4q2GLF64/AunG1PmI2dW9J9tgArV78DQHP7Hvdyq/maFPlU2XFN3tH+s5ajPPnZZ4JTup9BE8L2WFArsSF30X4L6uGxlwyxKYvotTFOfi4CR+q2BlrWY2ZN6xw3BilYZIG8PeYUa7+3WmhEPMRp46kEV0f5VScLTYQJ3ah1Rfv5tKITOgYHoIS6kMDl5rlkfDv+3B1vj47zPmwQpseGQ9hKQofaOj4Ul6HQBBdWDairxlmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Gordeev/mm-page_vma_mapped_walk-add-missing-pgtable-entry-accessors/20260429-030409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260427052000.196402-1-agordeev%40linux.ibm.com
patch subject: [PATCH] mm/page_vma_mapped_walk: add missing pgtable entry accessors
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20260502/202605021251.huVQW8Xg-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260502/202605021251.huVQW8Xg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605021251.huVQW8Xg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/page_vma_mapped.c: In function 'page_vma_mapped_walk':
>> arch/arm/include/asm/pgtable.h:144:44: error: 'pgdp' undeclared (first use in this function); did you mean 'pgd'?
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   include/linux/compiler_types.h:679:23: note: in definition of macro '__compiletime_assert'
     679 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:699:9: note: in expansion of macro '_compiletime_assert'
     699 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:33: note: in expansion of macro 'READ_ONCE'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                 ^~~~~~~~~
   mm/page_vma_mapped.c:222:34: note: in expansion of macro 'pgdp_get'
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~
   arch/arm/include/asm/pgtable.h:144:44: note: each undeclared identifier is reported only once for each function it appears in
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                            ^~~~
   include/linux/compiler_types.h:679:23: note: in definition of macro '__compiletime_assert'
     679 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:699:9: note: in expansion of macro '_compiletime_assert'
     699 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm/include/asm/pgtable.h:144:33: note: in expansion of macro 'READ_ONCE'
     144 | #define pgdp_get(pgpd)          READ_ONCE(*pgdp)
         |                                 ^~~~~~~~~
   mm/page_vma_mapped.c:222:34: note: in expansion of macro 'pgdp_get'
     222 |                 if (!pgd_present(pgdp_get(pgd))) {
         |                                  ^~~~~~~~


vim +144 arch/arm/include/asm/pgtable.h

4eec4b1396ac6a6 Russell King    2010-11-26  143  
eba2591d99d1f14 Alexandre Ghiti 2023-12-13 @144  #define pgdp_get(pgpd)		READ_ONCE(*pgdp)
eba2591d99d1f14 Alexandre Ghiti 2023-12-13  145  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

