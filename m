Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B7ACAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 17:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8054F8E0002; Sat, 27 Sep 2025 13:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6728E0001; Sat, 27 Sep 2025 13:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBC68E0002; Sat, 27 Sep 2025 13:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57B368E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 13:15:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5FBE1608CE
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 17:15:26 +0000 (UTC)
X-FDA: 83935681452.01.A74A581
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id 307ABC000E
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 17:15:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EewJzGce;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758993324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC0l2ngBdT2r5GrG40OKqd+SZ3mlRG9V0L/kwbjpO+U=;
	b=nlLGWjNR8ETqeKizCJo600v7fxFZTaoQVTD/dWIvaT3UUl0b5VEXPYi0Awq5kfIiGZbKhx
	drD2ry4NRQJWB9awDy5Srm0OEc6a0K78/ICFnDUEXSqpxzCn8DFzQHVibl0gj8bnXQszRR
	wvLaK2VQL7QtfYcTCCNkUduYlAiGjxI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758993324; a=rsa-sha256;
	cv=none;
	b=ac0mwLPB9rJF9FCEEDCVGcnfhep8wDoQJWeh7i2+pGtwCyqQqFbprLt5AlnGy7lcIRJ2zq
	1edji57w6yGbjYPiQqT7zeMPiYweghcNHPCTziSIBl0GeEHe/bGl2DOM7Ind+14mm6NUpa
	bAXznFSAtElGQKHbkGa0dHiQysC/Now=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EewJzGce;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758993325; x=1790529325;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l3z7WmQKQxNWz8k5q+sA98HFf5uJz31lFUvbYbHWsG0=;
  b=EewJzGcePWH4Q0R03B6e9uqRZKJvb5L5ktQUJFmYJw1GgSsXXUSH0BbT
   a1wL1E84J6bsGwdNAEFokpC3onEdKmpuYct6wmuZPRTrqD0Xtf4t3zhSA
   VYaE7Gtl4HnPKTBYujtX9nOfRi71gNbgny31uzc9nF0QCh1c5BmF0sOnW
   GFFmY5jeJrDNagykEQqSlbw152Ke2g5s4F18m9emrmIsSqyjT/lV2eVuY
   xIzPXrpnKnpVkOJnrpshvNIvYxzNCbFLXxe1OEzT+7veIkZcvcoQjFhz3
   qBIYlQ7zV5rBftHDDoUZajkpp+PNs9PLpyGTuXFHfw0D8/+BkM2Fl892+
   w==;
X-CSE-ConnectionGUID: 0ucsS7A2R0u296X7eOTPVg==
X-CSE-MsgGUID: 7YS0bn5kQkibmLYtjIfATA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61208278"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61208278"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 10:15:23 -0700
X-CSE-ConnectionGUID: poz5PeyOTuOPYykHgftmhg==
X-CSE-MsgGUID: grlmEzsmTlKzFA4tdYdAwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="177447736"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 27 Sep 2025 10:15:20 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2YVt-0007EL-1V;
	Sat, 27 Sep 2025 17:15:15 +0000
Date: Sun, 28 Sep 2025 01:14:59 +0800
From: kernel test robot <lkp@intel.com>
To: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	chrisl@kernel.org, kasong@tencent.com, youngjun.park@lge.com,
	aaron.lu@intel.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v2 1/1] mm/swapfile.c: select the swap device with
 default priority round robin
Message-ID: <202509280002.NWLixh90-lkp@intel.com>
References: <20250926155504.5122-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926155504.5122-2-bhe@redhat.com>
X-Stat-Signature: 3xwfkksbbz54fcyfrj6fg3w9wktgqd8u
X-Rspamd-Queue-Id: 307ABC000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758993324-637296
X-HE-Meta: U2FsdGVkX1+3ukGJP5fTZl/gIV5xzxIPlnD7E3QESShj33NOSzWUgwcJEPItYO52o0amUjBMnDFKcQK61e5oZfYA/SHRNWKUXet1zP4cXy1WOWvi3kkDMb5Zd0atRtUbegXztlRsHFb2csS0+nxjnBSreW1VYBzx8a4rzfsjmEDSqW40rT9d1CiYSu4741ChjdsE16TLltpzZcDAVRzo3xfDhSMQDtTytbVgD3nRKbMwe4tGQOzmy4tPuI9QlbRDQv1qfArGYZl2mN+P+52tRuZU7oNFbqzhMFuUxN9Enh9SakLuNjXafTg/BiDPigEyzjIKcc249xAar7umGLoVQn2AVtwbSpIQxAJqoY/87RsOSzNHbkIajpxg7DmSlcX89j0F9stvlNs0Vv6ysnd0pkH46bV4lbTPhTxFr/rfwEwXs0Jd6ESSe9qcIgj6ViRFTzNSEFT2YGiJ66BZ7z88zbD2YkMEyFgJxjqzA+trJvwNehYYi+9u8DB1p3Og4BafqvOLDeevFPrBaTLQHjeACH+WHI1/9uLMiJ95dymyYGDJRIFqKxnm+HquHmbcgb6+txvDyS1/7GIPslP6a9uYCjnKAbJi712XwHcxrpHA8pbuyFbb1++m2Fs5FNHTAD/d3UjW4tLCy06zeCMjwUqdZHOeHd1xQmsP97l4TUFBaog7nrfL8/6eJ6+v8ZdJkc+9XZBYoevuvs3jxOHVDCVKcI+8dZHfv3aw72nYxEpiBwxB1I69wcwSNAtwmmLgD76/qZHTSppfMbYojyvuOxKEjsu9q5AMTPMJVNmwNSQPgqPLChERQ4o6A8qlgACFNhRDUWKQAOZTIePx1sS314u7R+kdVba6ABMknrLUWVFINuNnlw/w7lo+xStfIv/FogLKp3CzI76aBPXOHni5R1NhyVPMCLAqGCrSbjwT5tvL12ZNzGfDnN28IzIt38JJ5Ver0gIa2SohwWzErq8o5rX
 eN0FRERI
 vClGkCz9AGJSLT87Fd6G1T5t1PNfnCRET+wkiciDuSwk7bSrYI8uX512Gz/w/EThAzmUJLAUWtzA2w8DtuUl3qIHgXuHAdr7IwzrfuU2El3mRNDmtTuMyo7jLgZNQIEZBGUISy3gCNzsBZwVf4qs5krLHtEOvC8Re5iHXmC9mSQ9qfAP8IMDGb8WaOa82XOQO2OzRGBaYpsca9Hiz251rdt2BA+88+IqLZpn4gqHlwrMoG5ca4aAXyX0BX/6mgcF3a0Ph0RGXrHS9GcrNxRIzlVpJ0xhvOYRyfVJZZLBRe6hhsQMOHSh5xipciV6HuwGvU8m2ouSWkqQ1uZQwDLcDZ9U4E8ytzw1o0xgY7xH/vphTtUr/MIltlC0NSO0JGdAM4gLf6XA76m2FfNkUvcHeI/gQUnY87NxzldUF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.17-rc7 next-20250926]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swapfile-c-select-the-swap-device-with-default-priority-round-robin/20250926-235740
base:   linus/master
patch link:    https://lore.kernel.org/r/20250926155504.5122-2-bhe%40redhat.com
patch subject: [PATCH v2 1/1] mm/swapfile.c: select the swap device with default priority round robin
config: sparc-randconfig-001-20250927 (https://download.01.org/0day-ci/archive/20250928/202509280002.NWLixh90-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250928/202509280002.NWLixh90-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509280002.NWLixh90-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/swapfile.c: In function '_enable_swap_info':
   mm/swapfile.c:2550:31: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
    2550 |         plist_add(&si->list, &swap_active_head);
         |                               ^~~~~~~~~~~~~~~~
         |                               swap_avail_head
   mm/swapfile.c:2550:31: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/linux/list.h:5,
                    from include/linux/wait.h:7,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:7,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/blkdev.h:9,
                    from mm/swapfile.c:9:
   mm/swapfile.c: In function '__do_sys_swapoff':
   mm/swapfile.c:2655:34: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |                                  ^~~~~~~~~~~~~~~~
   include/linux/container_of.h:20:33: note: in definition of macro 'container_of'
      20 |         void *__mptr = (void *)(ptr);                                   \
         |                                 ^~~
   include/linux/list.h:612:9: note: in expansion of macro 'list_entry'
     612 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:770:20: note: in expansion of macro 'list_first_entry'
     770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:173:10: note: in expansion of macro 'list_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |          ^~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:2655:9: note: in expansion of macro 'plist_for_each_entry'
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |         ^~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/init.h:5,
                    from include/linux/printk.h:6,
                    from include/asm-generic/bug.h:22,
                    from arch/sparc/include/asm/bug.h:25,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/blkdev.h:9,
                    from mm/swapfile.c:9:
   include/linux/compiler_types.h:507:27: error: expression in static assertion is not an integer
     507 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
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
   include/linux/list.h:601:9: note: in expansion of macro 'container_of'
     601 |         container_of(ptr, type, member)
         |         ^~~~~~~~~~~~
   include/linux/list.h:612:9: note: in expansion of macro 'list_entry'
     612 |         list_entry((ptr)->next, type, member)
         |         ^~~~~~~~~~
   include/linux/list.h:770:20: note: in expansion of macro 'list_first_entry'
     770 |         for (pos = list_first_entry(head, typeof(*pos), member);        \
         |                    ^~~~~~~~~~~~~~~~
   include/linux/plist.h:173:10: note: in expansion of macro 'list_for_each_entry'
     173 |          list_for_each_entry(pos, &(head)->node_list, mem.node_list)
         |          ^~~~~~~~~~~~~~~~~~~
   mm/swapfile.c:2655:9: note: in expansion of macro 'plist_for_each_entry'
    2655 |         plist_for_each_entry(p, &swap_active_head, list) {
         |         ^~~~~~~~~~~~~~~~~~~~
   mm/swapfile.c: In function '__has_usable_swap':
   mm/swapfile.c:3835:35: error: 'swap_active_head' undeclared (first use in this function); did you mean 'swap_avail_head'?
    3835 |         return !plist_head_empty(&swap_active_head);
         |                                   ^~~~~~~~~~~~~~~~
         |                                   swap_avail_head
>> mm/swapfile.c:3836:1: warning: control reaches end of non-void function [-Wreturn-type]
    3836 | }
         | ^


vim +3836 mm/swapfile.c

a2468cc9bfdff6 Aaron Lu    2017-09-06  3831  
2cf855837b89d9 Tejun Heo   2018-07-03  3832  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
0ff67f990bd457 Kairui Song 2025-03-14  3833  static bool __has_usable_swap(void)
0ff67f990bd457 Kairui Song 2025-03-14  3834  {
0ff67f990bd457 Kairui Song 2025-03-14  3835  	return !plist_head_empty(&swap_active_head);
0ff67f990bd457 Kairui Song 2025-03-14 @3836  }
0ff67f990bd457 Kairui Song 2025-03-14  3837  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

