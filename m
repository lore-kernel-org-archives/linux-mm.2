Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C898CDE014
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 06:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035258E0008; Fri, 14 Nov 2025 01:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27F48E0002; Fri, 14 Nov 2025 01:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E158E0008; Fri, 14 Nov 2025 01:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0E268E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:47:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F1AD1DFFB6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:47:04 +0000 (UTC)
X-FDA: 84108280368.11.BB38A4D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48AE91A0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:47:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V2TGOG28;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763102822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IIOh4maN6KyDGD/hBZLhDdgRlrx5uNeZxSMbOp4/1Ok=;
	b=ib0nuw5bUr4WUFZ+nFA/HsKX23jscsOnsckv4nVdzu+yPsUpd5s8HQgxq9T6EqI9TIIjFc
	GFG/MDK6sb0njMlFqJxo4Ux7L6mtvq+/ceRUyXaTMNjN4NyHMKL6e6lJLV9OiaKvkCHyHu
	bl0fhXIy/OaJuzxtldyav2NoRH0V0v0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=V2TGOG28;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763102822; a=rsa-sha256;
	cv=none;
	b=tkwo4xbn0VXMe7xO269kXax8ZYFxOYh90ulqNBjL8V1Aud2vvH/Y/fLtSmGVCMF2xpTsG0
	yI55ShyBsRoKbB3k0tJ9r/ME7Z8lNBFuHNvP3+6HkA5xvAsT7blcU2M5IY8z68ZgSvL8Yi
	ILHY1MZ8ZpU2AzMEl06O/J5Sr/Xh2vg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763102823; x=1794638823;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=c63TyLXwQfY+sk3K1HPrm/PP9kevMhREC0lGp84f11I=;
  b=V2TGOG28yOP4os3XY+jNZEQKWrmgjFjpgL1jCVGVHnnLQIdh+ueqkuAi
   yIy8u9WF331b2/QYi7xSGeHwcviEZD5+rwZZnq9yB7ejFPxb0rOT2XD7A
   HfDa9myHOkUXZ8Xhc3eH53rG44aBFHFWbCCWvFl/UHWQcP6Z4T1uRG2Dd
   ffuXuh5CYpnP4ITFF5+LJ9V3UUkVE7dtZqsHxfovoqtgIzyV/Pii0FfPb
   tIof6AZHtr4sRoTbqWRM6kGJXmhixhf7FTd5n48PIpIYnQ+8ws/ZHbCc1
   loMUvJ95uD7lm3tBwOnNsZkrRKT1TQ+h4GiGEthBVwLE3zqus+9/4YP3A
   A==;
X-CSE-ConnectionGUID: vHopFzuSRYW1ONKDDUJj9Q==
X-CSE-MsgGUID: rYF6RfCYTfaKaQO8J5L02g==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="64400137"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="64400137"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 22:47:01 -0800
X-CSE-ConnectionGUID: WqtCRE61R5m5ri9oFThYRQ==
X-CSE-MsgGUID: 4GiGKfxxRvGpKJkyaAKSTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="220359548"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 13 Nov 2025 22:46:59 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJnaD-0006FB-0j;
	Fri, 14 Nov 2025 06:46:57 +0000
Date: Fri, 14 Nov 2025 14:46:06 +0800
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 36/283] mm/hugetlb.c:4753:18: warning: implicit
 conversion from 'unsigned long long' to 'unsigned long' changes value from
 17179869184 to 0
Message-ID: <202511141140.LrrRrtIv-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 48AE91A0002
X-Stat-Signature: pniqi39t67x9ahhcgp6uzri8pq1qfktk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763102822-548423
X-HE-Meta: U2FsdGVkX1/e5mywqRelMEcxy5OtdK0K4gB/eUscQebIOYN4AoSjSB6SGeic1sxhurkyYq+Bp1d3k6pAKzwfHAUj6t2QEVK977nqrELhDzrotKWyqGFlTO8x7PcEP14lWw1B0dGwdZHyGgMqURaXjarmJ5jSes4nk0MY9FRRa3LafTPB3fVAI+nnG1dnbCYrpfmvEH5untXb4fKnrzBbDrGrRI6tl6asvhhstd0/xcOZVuDDRpqB4HHcwH/XFNmKEC0hdidAc5Z9NeSHkxtOeCd/FlI8hka58YKdViDRc8Lxl9GeY6sNr6eSZc+YyLFkvTTaDP4ozDxQL7xize4HtysqiWs3z7U3I+iHWC5gLasB7PVfulFpr8wmZ+Eqq+rqeuVrCviZqCS0IaJrJIVSNqM0sQ9MCG39R8zbGxFcEVh6DfiInRyxqQ1HD5hq1XqhArP4gJGc2oGAtqf3ivegjJNm4s/3IKskaHqBDUyAoPrlnLTq7Pfi1QAyFGi38rqppOtFd5YnrWIBX3DiClZWEyvxuUHwYCP9FneGg97WH1Zc2tZNxKxdCOJlObQ9tMFp1mE0D5NJ4L1Fg3qQJG770BFWdnwNbFl9ZgHG76SsrsGpGFfYZcjibgf7fELaLiz3tpQYk29IC69QNbNHU41ZfrFgUkUnfcti2Ey6p52OvP0Q/LYul5MBazvFfvLNN3NJVRU0ntiSn+Cpwlx9DiQ0OQ/bUwLn6/DWeL1vow+i/OvLlUlKmGcg/5RLv9hwecIJO6R7KmWqu37wnyN+mJS2gBpQZmNiINmcolcG1VjvafMEICX6HDsk4ixPgUEXkasBH/S4YM7wPwn5E1EfBz65z/Dh1B4bAufEd89Rnzqlfzs5+4uOd0kOv2PJ3x3Ud5SiA7k1BX5p8xCGWguTONGn8cV4C6YUqF0yKqKytKiXmxqc0uZrSvd9kTzaD9v2A9XtpMuckcw/rZCK5n3Pb5e
 Xw5gMmoU
 XiFjoJ3wsSvYOUlrNOwpxpetth5T0d4LIfOcWoQI56Qp5eBrBkj8A5mdL/QFHKjVh8ul81Y8ckLgvE7auIWUMnCf4ZEppxGM3qFjbmhJTMusVF8MQoOZDPm+aHJFMxKNvi3Pw+Rh0+euw8qdWBdAWt9A+uAcPMAYjYwzcq0+E2iPoHJTqGNjNSafPbCcvm83fjzTBDazzPqfBA4VieeaVc0suxLD7Tzar0Al5O6JSoVayXPTe7ervEfL7VnxQSJferDzuocLWFs/kOzCQGz+l+wwuGu/2/3LtVkO5cPJWRIn5nmtvlykNJOuN2LL0jCp/ZJVGaXBFHKeaNimdOq/1jTeyULUGv8pawRp7cgzwqgr1NM/S5zkq+YVX6cih7QUdXRyiIncYIE6DXwENjfk+vB8gx9hRSEp2/bQfBNTN3sdpxXl+oHs2wu8ZXNv4j8sA7ns2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   1c571d1c4c7e042c3c313d1a2058a17848ccebac
commit: 2f6ff71280ffddb27ad7174d24f573e2683870cd [36/283] mm: fix MAX_FOLIO_ORDER on powerpc configs with hugetlb
config: powerpc-randconfig-002-20251114 (https://download.01.org/0day-ci/archive/20251114/202511141140.LrrRrtIv-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511141140.LrrRrtIv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511141140.LrrRrtIv-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/hugetlb.c:4753:18: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
    4753 |         WARN_ON(order > MAX_FOLIO_ORDER);
         |                         ^~~~~~~~~~~~~~~
   include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                 ~~~~~~~~~ ^~~~~~
   include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~~~~~~
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
      20 | #define __AC(X,Y)       (X##Y)
         |                          ^~~~
   <scratch space>:85:1: note: expanded from here
      85 | 0x400000000ULL
         | ^~~~~~~~~~~~~~
   include/asm-generic/bug.h:123:25: note: expanded from macro 'WARN_ON'
     123 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   1 warning generated.
--
>> mm/page_alloc.c:6910:54: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
    6910 |         if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
         |                                                             ^~~~~~~~~~~~~~~
   include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                 ~~~~~~~~~ ^~~~~~
   include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~~~~~~
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
      20 | #define __AC(X,Y)       (X##Y)
         |                          ^~~~
   <scratch space>:106:1: note: expanded from here
     106 | 0x400000000ULL
         | ^~~~~~~~~~~~~~
   include/asm-generic/bug.h:111:25: note: expanded from macro 'WARN_ON_ONCE'
     111 |         int __ret_warn_on = !!(condition);                      \
         |                                ^~~~~~~~~
   1 warning generated.
--
>> mm/util.c:1263:16: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
    1263 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
         |                       ^~~~~~~~~~~~~~~~~~
   include/linux/mm.h:2104:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
    2104 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
         |                                         ^~~~~~~~~~~~~~~
   include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
    2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
         |                                 ~~~~~~~~~ ^~~~~~
   include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
      56 | #define SZ_16G                          _AC(0x400000000, ULL)
         |                                         ^~~~~~~~~~~~~~~~~~~~~
   include/uapi/linux/const.h:21:18: note: expanded from macro '_AC'
      21 | #define _AC(X,Y)        __AC(X,Y)
         |                         ^~~~~~~~~
   include/uapi/linux/const.h:20:20: note: expanded from macro '__AC'
      20 | #define __AC(X,Y)       (X##Y)
         |                          ^~~~
   <scratch space>:39:1: note: expanded from here
      39 | 0x400000000ULL
         | ^~~~~~~~~~~~~~
   1 warning generated.


vim +4753 mm/hugetlb.c

9fee021d15ddd8 Vaishali Thakkar     2016-05-19  4742  
d00181b96eb86c Kirill A. Shutemov   2015-11-06  4743  void __init hugetlb_add_hstate(unsigned int order)
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4744  {
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4745  	struct hstate *h;
8faa8b077b2cdc Andi Kleen           2008-07-23  4746  	unsigned long i;
8faa8b077b2cdc Andi Kleen           2008-07-23  4747  
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4748  	if (size_to_hstate(PAGE_SIZE << order)) {
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4749  		return;
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4750  	}
47d38344abd0c7 Aneesh Kumar K.V     2012-07-31  4751  	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
59838b2566f6d0 Frank van der Linden 2023-10-04  4752  	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
7b4f21f5e0386d David Hildenbrand    2025-09-01 @4753  	WARN_ON(order > MAX_FOLIO_ORDER);
47d38344abd0c7 Aneesh Kumar K.V     2012-07-31  4754  	h = &hstates[hugetlb_max_hstate++];
667574e873b5f7 Miaohe Lin           2024-07-12  4755  	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4756  	h->order = order;
aca78307bfdaf3 Miaohe Lin           2021-02-24  4757  	h->mask = ~(huge_page_size(h) - 1);
8faa8b077b2cdc Andi Kleen           2008-07-23  4758  	for (i = 0; i < MAX_NUMNODES; ++i)
8faa8b077b2cdc Andi Kleen           2008-07-23  4759  		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
0edaecfab218d7 Aneesh Kumar K.V     2012-07-31  4760  	INIT_LIST_HEAD(&h->hugepage_activelist);
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4761  	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
c2c3a60a857bfe Miaohe Lin           2022-09-01  4762  					huge_page_size(h)/SZ_1K);
8faa8b077b2cdc Andi Kleen           2008-07-23  4763  
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4764  	parsed_hstate = h;
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4765  }
a3437870160cf2 Nishanth Aravamudan  2008-07-23  4766  

:::::: The code at line 4753 was first introduced by commit
:::::: 7b4f21f5e0386dfe02c68c009294d8f26e3c1bad mm/hugetlb: check for unreasonable folio sizes when registering hstate

:::::: TO: David Hildenbrand <david@redhat.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

