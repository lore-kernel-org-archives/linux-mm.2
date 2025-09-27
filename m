Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FD9CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 07:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBEA8E0002; Sat, 27 Sep 2025 03:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB5C18E0001; Sat, 27 Sep 2025 03:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9318E0002; Sat, 27 Sep 2025 03:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC4DB8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 03:57:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45B1EC0623
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 07:57:16 +0000 (UTC)
X-FDA: 83934274872.16.5D46D0D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id C91E240005
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 07:57:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XNToOZUB;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758959834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETg3VIwap483E01V+VbhlJ1wQH7xyZjf058RiPBSSOM=;
	b=Ax1Awtk2/HgvXZeoMZyB4ysF+epfV2myk1djzZcofAWAFVJ5DbXcpf+ZcNzPB3dxm8tLcj
	yCNln5a3BVCrMPdTIBVjnwcdxzx/VV+8NjVBSTZ624uOda+bR3dTDtFA3FDleJOsZxvzz9
	6ti6GLVEgScd9EQY88pQQYYyBg/o484=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XNToOZUB;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758959834; a=rsa-sha256;
	cv=none;
	b=Eyn31Nt0WVHJqGH+PguQUwzBRtIFclJS4RSYmbpPI2j9AzzaE3sYTSMmh9LdSJb85rXv9w
	WNd4zW6tChIFBSndOjwEQmU+tjpQfUkBDBGeRbEFBQjubPDVRj/RR7YxMJmPI82fnvJ4HU
	/Fij+Vz8G53lBbZklEIGmvxNTzRZY2E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758959833; x=1790495833;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3kN1snQSfXQgSzhlScazdwzv5am8mNjFcM/6vLXUSkQ=;
  b=XNToOZUBRbyK8QuwgzOULwVG2GpTy4kb26BPPzukJX/mThb0FFTEIia6
   DEymTsweHSleya1o/wOg7y98XfII9+Q34Jjj99B8frNlUMScrPVvYS1Nz
   Dgepv1yP9TyUCaiH7azDQuj4iTFLq77yHX/dOwkPHVPFg3Sm8a6xD+BjJ
   k5Zx+0DRSOMwgvjAin1fbMJf4QLx9ijAW05V9IQbk3aDoc80YSzNh5Rhc
   2jOvMyizVzjSxazV3MFUt2nNVyaOMLlWCrXCkkQsOp1Bl8nu8BF6MVGjK
   R8ohV6rn6z5HnlWFuUMJVrlDkIsq/g+cV5UzCSgqn5sEAb5HD8S8nSPGM
   g==;
X-CSE-ConnectionGUID: zWzaGdT1SsWzPQP/stVnPg==
X-CSE-MsgGUID: ERIsWe1oQn69lSrmNta/+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="48843020"
X-IronPort-AV: E=Sophos;i="6.18,297,1751266800"; 
   d="scan'208";a="48843020"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 00:57:10 -0700
X-CSE-ConnectionGUID: dYD6ObKjT7m1hTj/oazEBA==
X-CSE-MsgGUID: Dr+/R4KpT+CgVTC63ou3cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,297,1751266800"; 
   d="scan'208";a="201474063"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 27 Sep 2025 00:57:04 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2Pni-0006tb-2b;
	Sat, 27 Sep 2025 07:57:02 +0000
Date: Sat, 27 Sep 2025 15:56:10 +0800
From: kernel test robot <lkp@intel.com>
To: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v2 1/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <202509271545.8d7xtJIA-lkp@intel.com>
References: <20250926155504.5122-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926155504.5122-2-bhe@redhat.com>
X-Stat-Signature: 9ddnx613r6uex5gtosoi1agaj1z31r7n
X-Rspam-User: 
X-Rspamd-Queue-Id: C91E240005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758959832-502722
X-HE-Meta: U2FsdGVkX1/Nyj8mkxwXPAeOYFFyUKjBLl6th9wzZx8Yu4Z1dJlSkQiEhQjZMrCIDDRW6sxdFnUDD7fT9987uC94w/t//LJV/0M7Q6evywu9pPpexxi4+RRWzczilA1hdxMnQI8pFmaO+NxP28c/2dVcN9/zvvCRy3xs9X5KNpwkQgYHjatxOPuIovuiOJIK8SuGK77aShVsjuiDWPkhkcJPt+Yk+2pEM1HxGhfpPb5IXs42ZzwT3OM2gPJHKzDLdq9uCRQQTDlswJA0jahIO1Jqssk0+h8FKqvssbcFA/26hL+InT+xFsAQR5c9JvXShHqnrcFzHLjBCc3AYChcVkL1LjJFKQ2lc+UuTuVb22/1w1wNUoXYHB8uVtjJfoIddWbvJgq6REQDFPTnxWH/l7qhvY11s6UTDlbrC01Yk0CYjiR9CmsOhulu7YAdhKKlCOYLaC1BmcKrAGKFr5eRYiQGNlBVU/xqk9igy/Ra0AdPLjU2RKF/Ml6EUCw9oZm0vMldXKZlrmgV5MRRfXMz++lNeob93SV+A1BpWRKQ0F2VdZhOqKCFrQRwYXbDsi8FXs1Q9WCfmhmGONhTBf9e7el91zt2sXkc/uCvYhtnrbXdUsd2X8TZ2mF2mGzxamUQKx9tq+vKK6ufVBk98fnUiuIBdYCAPX2broW4873tKfiezv9b6yiu2o8VecjmsNZMDcnIeINXIBr8vRog6cJRQWBZ28M/Bw4F1GdDnrxsZH9FkIY79iaTbQhMJt1eFf8XNNL/Zgx4pFK04MLLbM7gOQby84CbP0H1DNuQEJPpgGAkwIOjKBCDwveGJT78KswePeGuPHHDNIHWeRHhGItGCgSWPyur9SvltRJMcpJjTuh/lMWeEfEsHCzVB/9OsoZikNXLfbS/qIMFrix5QFdZoOIVIZC2o4gSjcDlb3WCj0kEy+5pKYwpWW6yG6Vm8/R/4DMWZbzksQpEVhxmX+E
 I/UwMyBH
 QMDvMWZZMk3e1KsQ8m6UtNDcZj3crPrcQ+d9BHWlQdpU8EFfWOYlE4YKD+9aIJR/DPI6ZaOPnj4rjSxlLJN18fsaynle1VwUIRT8kLqT4/B7fuzFH4SmyKMIs0VPhtGCV2IhoyEFJjFr1Ik99KI1KILPQ5GshSXFY/ran0eqi+jwXlqdpWNMNzj6DZW74/v9UM9EVBereIkON2y2pCgbEDfdYpk+KlZzQqB3ArEqRTLZc9n9IfWjA+sylHgaF6a0TBf/TQuG/mJv8nAww87H6JMSa3+36SVFufGt8Zsikb+LrnBFlR0r6YW6XRuj0/zsQGiXNfwq5fqPetIq6W3Y/kXz38onA8mR/2/0zpXHEjYUKpBOTCGya+HCnJqK45pH65BeUDn6rFNo2Z77zy9HEpmdhUjXr+Oap3dBI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.17-rc7 next-20250926]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swapfile-c-select-the-swap-device-with-default-priority-round-robin/20250926-235740
base:   linus/master
patch link:    https://lore.kernel.org/r/20250926155504.5122-2-bhe%40redhat.com
patch subject: [PATCH v2 1/1] mm/swapfile.c: select the swap device with default priority round robin
config: x86_64-buildonly-randconfig-002-20250927 (https://download.01.org/0day-ci/archive/20250927/202509271545.8d7xtJIA-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250927/202509271545.8d7xtJIA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509271545.8d7xtJIA-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/swapfile.c:2550:24: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2550 |         plist_add(&si->list, &swap_active_head);
         |                               ^~~~~~~~~~~~~~~~
         |                               swap_avail_head
   mm/swapfile.c:99:19: note: 'swap_avail_head' declared here
      99 | static PLIST_HEAD(swap_avail_head);
         |                   ^
   mm/swapfile.c:2655:27: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |                                  ^~~~~~~~~~~~~~~~
         |                                  swap_avail_head
   include/linux/plist.h:173:30: note: expanded from macro 'plist_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |                                     ^
   include/linux/list.h:770:30: note: expanded from macro 'list_for_each_entry'
     770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
         |                                     ^
   include/linux/list.h:612:14: note: expanded from macro 'list_first_entry'
     612 |         list_entry((ptr)->next, type, member)
         |                     ^
   include/linux/list.h:601:15: note: expanded from macro 'list_entry'
     601 |         container_of(ptr, type, member)
         |                      ^
   include/linux/container_of.h:20:26: note: expanded from macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^
   mm/swapfile.c:99:19: note: 'swap_avail_head' declared here
      99 | static PLIST_HEAD(swap_avail_head);
         |                   ^
   mm/swapfile.c:2655:27: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |                                  ^~~~~~~~~~~~~~~~
         |                                  swap_avail_head
   include/linux/plist.h:173:30: note: expanded from macro 'plist_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |                                     ^
   include/linux/list.h:770:30: note: expanded from macro 'list_for_each_entry'
     770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
         |                                     ^
   include/linux/list.h:612:14: note: expanded from macro 'list_first_entry'
     612 |         list_entry((ptr)->next, type, member)
         |                     ^
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:507:63: note: expanded from macro '__same_type'
     507 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                                                               ^
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^
   mm/swapfile.c:99:19: note: 'swap_avail_head' declared here
      99 | static PLIST_HEAD(swap_avail_head);
         |                   ^
   mm/swapfile.c:2655:27: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |                                  ^~~~~~~~~~~~~~~~
         |                                  swap_avail_head
   include/linux/plist.h:173:30: note: expanded from macro 'plist_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |                                     ^
   include/linux/list.h:770:30: note: expanded from macro 'list_for_each_entry'
     770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
         |                                     ^
   include/linux/list.h:612:14: note: expanded from macro 'list_first_entry'
     612 |         list_entry((ptr)->next, type, member)
         |                     ^
   note: (skipping 2 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/compiler_types.h:507:63: note: expanded from macro '__same_type'
     507 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                                                               ^
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
      77 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
         |                                                  ^
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^
   mm/swapfile.c:99:19: note: 'swap_avail_head' declared here
      99 | static PLIST_HEAD(swap_avail_head);
         |                   ^
   mm/swapfile.c:2655:27: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |                                  ^~~~~~~~~~~~~~~~
         |                                  swap_avail_head
   include/linux/plist.h:173:30: note: expanded from macro 'plist_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |                                     ^
   include/linux/list.h:771:32: note: expanded from macro 'list_for_each_entry'
     771 |              !list_entry_is_head(pos, head, member);                    \
         |                                       ^
   include/linux/list.h:761:30: note: expanded from macro 'list_entry_is_head'
     761 |         list_is_head(&pos->member, (head))
         |                                     ^
   mm/swapfile.c:99:19: note: 'swap_avail_head' declared here
      99 | static PLIST_HEAD(swap_avail_head);
         |                   ^
   mm/swapfile.c:2677:23: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
    2677 |         plist_del(&p->list, &swap_active_head);
         |                              ^~~~~~~~~~~~~~~~
         |                              swap_avail_head


vim +2550 mm/swapfile.c

eb085574a7526c Ying Huang           2019-07-11  2542  
b85508d7de901c Barry Song           2024-08-08  2543  static void _enable_swap_info(struct swap_info_struct *si)
eb085574a7526c Ying Huang           2019-07-11  2544  {
b85508d7de901c Barry Song           2024-08-08  2545  	atomic_long_add(si->pages, &nr_swap_pages);
b85508d7de901c Barry Song           2024-08-08  2546  	total_swap_pages += si->pages;
40531542e28324 Cesar Eduardo Barros 2011-03-22  2547  
adfab836f4908d Dan Streetman        2014-06-04  2548  	assert_spin_locked(&swap_lock);
5b648db56b50e1 Baoquan He           2025-09-26  2549  
b85508d7de901c Barry Song           2024-08-08 @2550  	plist_add(&si->list, &swap_active_head);
c70699e555537b Ma Wupeng            2023-06-27  2551  
b228386cf237e6 Kairui Song          2025-01-14  2552  	/* Add back to available list */
b228386cf237e6 Kairui Song          2025-01-14  2553  	add_to_avail_list(si, true);
cf0cac0a093415 Cesar Eduardo Barros 2012-12-11  2554  }
cf0cac0a093415 Cesar Eduardo Barros 2012-12-11  2555  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

