Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9588DCCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 20:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531708E0009; Sat, 11 Oct 2025 16:45:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2228E0002; Sat, 11 Oct 2025 16:45:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7D18E0009; Sat, 11 Oct 2025 16:45:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 294318E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 16:45:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8476E5A896
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 20:45:40 +0000 (UTC)
X-FDA: 83987014440.18.DA072DE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A7B64000D
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 20:45:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Up3x5dEN;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760215538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n06QTXtl3a/wrs0lAAObale3FnA8jpmm1gsucfwf+g8=;
	b=sUXrn7QBTjWSkQV8IkKCVFHGvfFcNbD9zKymP7ybXXzx9f7At/xNfAQ2nXwbuDOds8N7oN
	KLhnzc9vJqWdBp70Zu3e/Gj0lQxCE52axst5GHIabAf8rPqcR1vbkfDlPInlYAsDvBUHF7
	q6yjCgq7f1TsvzXqJva4R7Qf7uJ4dQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Up3x5dEN;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760215538; a=rsa-sha256;
	cv=none;
	b=RzB8nFzIe1SSkl3cxLE7xHri0U+AS65xA5HbXS1Y3PPYL2wqdNA2OTcpcjPB+0GdMyBFnb
	Z+EA+qcEEvM4upkAZG7e8lf6R8qnlW8O9x5W5cgzoiNUwMhXyO7HZeniTp6uyKoVpXb2z1
	xd1ixRSmhuSuzdEX6p0JhF4T5tQ1Dz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760215538; x=1791751538;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+EZDHLX+jXHaVPDuh39qXsqEU1NcxfapBxnx8UnMJQI=;
  b=Up3x5dENYbyh9dYrRf/NyiT3UZmgCp2aO1Wgc0Bexww+TSlFQ3SvuQYF
   4dGicVpGr63MhI7RfglBanduMWbTewK78SQB/rR6kOqvJqgcpyrv3ywgU
   jGGhqhGPnjtp5NoHPSjYG81hPfOlyYs6sQDU0sQr67KctWO67u6r2FD6f
   knsgtxgHLsiezd0G0yZ3mUq19xks447HpMxD2jk8Sg5fNmrQI9pFnNDcR
   X5jPacDglfh69rRWWH0J1cEjJ1xvsbTkoXhtrDqELSvYJm0xriuWTYAMq
   L+HHULIEIt0RM/BZmsYQwNNT+QCaOoyqIYn4HxyXZLlqemnIZZb76aXDx
   w==;
X-CSE-ConnectionGUID: Qwiv0IGASZ+T74DXNd+75w==
X-CSE-MsgGUID: qWN8zeBNSI+HSgW9ujJY1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11579"; a="73011069"
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="73011069"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 13:45:35 -0700
X-CSE-ConnectionGUID: l3RXPPrnQH2puA+IW1Seog==
X-CSE-MsgGUID: TTsSoK8gRDSRzaKMrBoMfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="181668638"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 11 Oct 2025 13:45:32 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7gT4-0003z5-1b;
	Sat, 11 Oct 2025 20:45:30 +0000
Date: Sun, 12 Oct 2025 04:45:07 +0800
From: kernel test robot <lkp@intel.com>
To: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	chrisl@kernel.org, kasong@tencent.com, youngjun.park@lge.com,
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
Message-ID: <202510120456.vTSygUXV-lkp@intel.com>
References: <20251011081624.224202-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011081624.224202-2-bhe@redhat.com>
X-Stat-Signature: o9t9hq496hccoe1mrex55z8n7j7k1um4
X-Rspamd-Queue-Id: 9A7B64000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760215537-352435
X-HE-Meta: U2FsdGVkX1/wDLNvjRaDC/ndo6gO3uAlqd4dsFUh6YOPuBXNvQ3HE9bWYnNSHUua1oQn7ccGd2TD3iXT93nTfbv/xGswhcRKz2JzYDdV/nxd3xCggvqSxOkPHBYYmT528FMQASmjIvoH5/5ZWBtzmUt1BYLxEoIkCZ7wcxtdUPTX1+ogUA0RGKDPI5BGnaZzVMOoaycAQlv6w5i/09VJ09r8qk0Gf5FoZTNgyY1y4LULM1Fu56BP1T6IrSEOSKlGwusTv99954n5l0Z3cXkm3uSiRpq2XENx3rpqCKDtZq0vYdac+4Xnoakb08TEt3KEnjceIyY1QrnEMlIPMW5GzGn4b7P9pB9Fo4lmiIs5HeCnik9pLSbqsbhJZl3HXvD7CvZhYPgWQ/zyz640dS7Jdhqt3OJGHhHdDOPBbrACnQGQp2B51IJOBLhPrCW5XrdUQ+52AwtOmFfWCh3wUZMmKkTYtkCxLvWyQDoJLkbUMsNnk559uFpqKg//KBlfpu4c3Lvn33809dZEN+a9kDY3OV8SAfyfMwLD/KeN4dlcAlDgzk3SC85ZVp5KIQ9+HY+8QoB47CQ0idTb2F3QYngQhXlQxovvlMQplZQ9Ve899Q2y4mlV2j/RB2bHuIMmgTjNCp5x2ICyk2Bd3/hijqt4CBeB0kWFM7wGbmjc8n3HSkNBzX4yiEVHpT7Z1U+4GxF/UmaGvH110gQubbPZnjlfRyLbA7Ut3wRE8idtJtql+VAwVkXUyJp9IXsaz/ecBOV/dq6eekJVjzUOCfmjJCphfjFJBg5rA6MB2sNCiUAGxXg48gW1ek1gm2XGHRAs8/wwJJBxDirTsdFEiaPRLHTosIJXLKCmE7gKvnRq+DLdx6uu2HLuX1rzIlVF36yXvAPxkGL99hfVksTftD0rzpX+KixKHnM84cO/4D9+ZlfamCHdGW4OGPBjmItofaBBVQshr8/d/iskSiWxU7UE5Gh
 CF7ZbReG
 xrAXD5SQJTS8++zjG8YawVyzfbsRD0rHYoM7RYtr1CRf0n7kT2bvHaviK/gnVEbX2lf7Br+vmDtyEqoRNF0HucQPi6FKfeiafeyDcNd4Ksdx3EoPscQFK+1OMcTNGh7rzS4kfoUcdX9w8WwR0M9QZkDJ+WjXSrfurqBSpjYGwjBpw/5o1c3SvnpUzd36m1rItMNbZFmlfFSqPqNsT9hxmFc9vLkEIOLu1zwlEI/J4+PP8O+XtN+GEKfVNiqzw+4lvMwHg0AtiUkTy5/WntdJZCoM4J1hsSira/ccRTfRaiKg434x6RzZWX07fYU+kViCSdncqiMLhNiJ46eq19X0UBScMKEIbKbzqRl4u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swap-do-not-choose-swap-device-according-to-numa-node/20251011-161743
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251011081624.224202-2-bhe%40redhat.com
patch subject: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device according to numa node
config: i386-buildonly-randconfig-003-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510120456.vTSygUXV-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/list.h:5,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/blkdev.h:9,
                    from mm/swapfile.c:9:
   mm/swapfile.c: In function 'swap_sync_discard':
>> mm/swapfile.c:1395:46: error: 'swap_avail_heads' undeclared (first use in this function); did you mean 'swap_avail_head'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                              ^~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^~~
   include/linux/list.h:620:9: note: in expansion of macro 'list_entry'
     620 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:869:20: note: in expansion of macro 'list_first_entry'
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:46: note: each undeclared identifier is reported only once for each function it appears in
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                              ^~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^~~
   include/linux/list.h:620:9: note: in expansion of macro 'list_entry'
     620 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:869:20: note: in expansion of macro 'list_first_entry'
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/init.h:5,
                    from include/linux/printk.h:6,
                    from include/asm-generic/bug.h:22,
                    from arch/x86/include/asm/bug.h:103,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5:
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:620:9: note: in expansion of macro 'list_entry'
     620 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:869:20: note: in expansion of macro 'list_first_entry'
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:530:27: error: expression in static assertion is not an integer
     530 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:620:9: note: in expansion of macro 'list_entry'
     620 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:869:20: note: in expansion of macro 'list_first_entry'
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/blkdev.h:8:
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/stddef.h:16:58: note: in definition of macro 'offsetof'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                                          ^~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:620:9: note: in expansion of macro 'list_entry'
     620 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:869:20: note: in expansion of macro 'list_first_entry'
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:22:23: note: in expansion of macro '__same_type'
      22 |                       __same_type(*(ptr), void),                        \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:530:27: error: expression in static assertion is not an integer
     530 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/stddef.h:16:58: note: in definition of macro 'offsetof'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                                          ^~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:870:21: note: in expansion of macro 'list_next_entry'
     870 |                 n = list_next_entry(pos, member);                       \
         |                     ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/list.h:869:64: warning: left-hand operand of comma expression has no effect [-Wunused-value]
     869 |         for (pos = list_first_entry(head, typeof(*pos), member),        \
         |                                                                ^
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/list.h:773:28: note: in definition of macro 'list_entry_is_head'
     773 |         list_is_head(&pos->member, (head))
         |                            ^~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:22:23: note: in expansion of macro '__same_type'
      22 |                       __same_type(*(ptr), void),                        \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:530:27: error: expression in static assertion is not an integer
     530 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
      78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
         |                                                        ^~~~
   include/linux/container_of.h:21:9: note: in expansion of macro 'static_assert'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |         ^~~~~~~~~~~~~
   include/linux/container_of.h:21:23: note: in expansion of macro '__same_type'
      21 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
         |                       ^~~~~~~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1395:69: error: 'struct swap_info_struct' has no member named 'avail_lists'; did you mean 'avail_list'?
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |                                                                     ^~~~~~~~~~~
   include/linux/stddef.h:16:58: note: in definition of macro 'offsetof'
      16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
         |                                                          ^~~~~~
   include/linux/list.h:609:9: note: in expansion of macro 'container_of'
     609 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:667:9: note: in expansion of macro 'list_entry'
     667 |         list_entry((pos)->member.next, typeof(*(pos)), member)
         |         ^~~~~~~~~~
   include/linux/list.h:872:27: note: in expansion of macro 'list_next_entry'
     872 |              pos = n, n = list_next_entry(n, member))
         |                           ^~~~~~~~~~~~~~~
   include/linux/plist.h:197:9: note: in expansion of macro 'list_for_each_entry_safe'
     197 |         list_for_each_entry_safe(pos, n, &(head)->node_list, m.node_list)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:1395:9: note: in expansion of macro 'plist_for_each_entry_safe'
    1395 |         plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/swapfile.c:1391:13: warning: variable 'nid' set but not used [-Wunused-but-set-variable]
    1391 |         int nid = numa_node_id();
         |             ^~~
   mm/swapfile.c: In function '__do_sys_swapoff':
   mm/swapfile.c:2893:21: warning: unused variable 'nid' [-Wunused-variable]
    2893 |                 int nid;
         |                     ^~~


vim +1395 mm/swapfile.c

b487a2da3575b6 Kairui Song 2025-03-14  1383  
74cdc690138b65 Kairui Song 2025-10-07  1384  /*
74cdc690138b65 Kairui Song 2025-10-07  1385   * Discard pending clusters in a synchronized way when under high pressure.
74cdc690138b65 Kairui Song 2025-10-07  1386   * Return: true if any cluster is discarded.
74cdc690138b65 Kairui Song 2025-10-07  1387   */
74cdc690138b65 Kairui Song 2025-10-07  1388  static bool swap_sync_discard(void)
74cdc690138b65 Kairui Song 2025-10-07  1389  {
74cdc690138b65 Kairui Song 2025-10-07  1390  	bool ret = false;
74cdc690138b65 Kairui Song 2025-10-07 @1391  	int nid = numa_node_id();
74cdc690138b65 Kairui Song 2025-10-07  1392  	struct swap_info_struct *si, *next;
74cdc690138b65 Kairui Song 2025-10-07  1393  
74cdc690138b65 Kairui Song 2025-10-07  1394  	spin_lock(&swap_avail_lock);
74cdc690138b65 Kairui Song 2025-10-07 @1395  	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
74cdc690138b65 Kairui Song 2025-10-07  1396  		spin_unlock(&swap_avail_lock);
74cdc690138b65 Kairui Song 2025-10-07  1397  		if (get_swap_device_info(si)) {
74cdc690138b65 Kairui Song 2025-10-07  1398  			if (si->flags & SWP_PAGE_DISCARD)
74cdc690138b65 Kairui Song 2025-10-07  1399  				ret = swap_do_scheduled_discard(si);
74cdc690138b65 Kairui Song 2025-10-07  1400  			put_swap_device(si);
74cdc690138b65 Kairui Song 2025-10-07  1401  		}
74cdc690138b65 Kairui Song 2025-10-07  1402  		if (ret)
74cdc690138b65 Kairui Song 2025-10-07  1403  			break;
74cdc690138b65 Kairui Song 2025-10-07  1404  		spin_lock(&swap_avail_lock);
74cdc690138b65 Kairui Song 2025-10-07  1405  	}
74cdc690138b65 Kairui Song 2025-10-07  1406  	spin_unlock(&swap_avail_lock);
74cdc690138b65 Kairui Song 2025-10-07  1407  
74cdc690138b65 Kairui Song 2025-10-07  1408  	return ret;
74cdc690138b65 Kairui Song 2025-10-07  1409  }
74cdc690138b65 Kairui Song 2025-10-07  1410  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

