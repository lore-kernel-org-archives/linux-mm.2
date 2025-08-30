Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB337CA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 16:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FB46B0005; Sat, 30 Aug 2025 12:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0796B0006; Sat, 30 Aug 2025 12:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF6C6B0007; Sat, 30 Aug 2025 12:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C67766B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 12:05:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 896C456F4C
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:05:53 +0000 (UTC)
X-FDA: 83833899786.23.E6DFBAF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0F02880005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:05:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wsd7nG1j;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756569951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaSvdpoDPf/bzIGFEao/8qBHiZSelgJKLpIleWy3GNg=;
	b=GionxseAddP5KyDvyMQ/STFrbji8ZotDdNc0r+pU8MAXwxz2w0Dem/zHD8ixUNtqdLzT2L
	mlqWYTA4BCcyJEftTnhtvcXNpvL7U5eshQ8Iw1GYRgS3bHiUlXZfZ21Hq4Yd8xVyZgN8BJ
	XaolAoC4JZJlGgqC8fmFQPdxYybXNkk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Wsd7nG1j;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756569951; a=rsa-sha256;
	cv=none;
	b=zv7nL5K29gpKwZ3RxeSnhjAQXqfNTEMI1r4XTslRsgLy5cMyrV7R/iEoQYEXOtU6MQAL9T
	tJs+/ulNkvW1WWDtMU3QJq3GpqVEcn2yTrwj+Miisl/M521w12wpIuBHI/2YJ3MSUN0BYB
	09GioYc4qYKwndTR4XosTAZGCdWKMEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756569951; x=1788105951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nZInpuDDYcV/s2vcTKuZGi+aQmE/qU6SPFQgzHBBnfg=;
  b=Wsd7nG1jep/k/rMJzCgQSjZwfnBKIhsNf+vtWgY+ZeEObNY2DZfm6AwA
   CXV0vepWBOdAcCd6xywo4BQlHvOPmSSPjbp4vVOQwus9we7an/RQ39J7R
   vmSy/eSuJ8ZpJ+sbo8hlwe666W2WQVohi8AWU765Enn9+boHgRvcHCH14
   XdLB3aud1HNgEe49f/TzGf1MKJilFAY9LQGuF+jwT9T0bVGU25vVSqljO
   gNVUGLN3wsIaCOjkhL99VgWtq6a5bxF5f9e/9CKBpcYcCK7X56RgZPmUx
   THPxeeneC64ASteLiU4s6dxNDZZRC4yOpkn2zoIK0fFY9Fa4tVa203D51
   Q==;
X-CSE-ConnectionGUID: mU4eXfTVRJK6JlKVqvZ+Fg==
X-CSE-MsgGUID: qg+E7jAgSeCNZ09uLrWecg==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="58764857"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="58764857"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 09:05:49 -0700
X-CSE-ConnectionGUID: gKpngiHdQkukULAx74a8uw==
X-CSE-MsgGUID: tT5xE8p/SCe6K8/5WYxT1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171003721"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 30 Aug 2025 09:05:45 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usO4r-000VUl-1r;
	Sat, 30 Aug 2025 16:05:28 +0000
Date: Sun, 31 Aug 2025 00:03:46 +0800
From: kernel test robot <lkp@intel.com>
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
	david@redhat.com, axelrasmussen@google.com, yuanchu@google.com,
	willy@infradead.org, hughd@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>
Subject: Re: [PATCH 08/12] arch, mm/util: add const to
 arch_pick_mmap_layout() parameter
Message-ID: <202508302325.b9umktOw-lkp@intel.com>
References: <20250829183159.2223948-9-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-9-max.kellermann@ionos.com>
X-Rspamd-Queue-Id: 0F02880005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: hm45d45gt886rnawfietq63cybtt9qm6
X-HE-Tag: 1756569950-398707
X-HE-Meta: U2FsdGVkX1/6Z/H0KAigWq4ppydf5uoSkWWvDvIlLk6LtS7jpHRaG6Vzu6bmEkREVA41pWxsVxNCO/5gUHJMqWvxhyDNxVBOdiHOG7m7PAd+T+UbZBbOmEsWNaJ7j5oGx4F6GfVPsnHpt2mQAVptvH3EdX/N1HColSjxkNQULnAQCN/NkDa/3pKtrNJ5O18aPlkbBNO3TBkytrY1N295IQ1W9t68ZNnRq++f4fgptroOLKArtfDLNhhECXeNVJVD9s8h1AVa3yQk5yIYpjvk2mh7ZdPfkaN2N2IrPR+ftPfw/rCPJ6mvk4VLbtGfujBq6lGljIcG0QBJYRo1dbju/nnmOjfdqAkXOCx+FZUx066/kTOeCxktdG92m+AKh+f1gfPPnFzk18ZEQZpWeYC1vzp/L1zpxoOf2whRgKRqgIysskkGnuypm0vfT5p74LQrybGylznutfhSRc8hUX6Q8OQiXsftNr65ycsLzSoL8q+HUJCvkA65RtDbKK655j5YLhXWDDaDhu1yd19qJ0ZXU6gRU44lbuMsrbD2XcEA/uj7ku8yI5s+5XQdyEjY6ulxFnR9qtxihiSZQGFDdc/WlM+yvMP72RRKf+oZSM4bW6BrfEFXTYb6m6qJ6J/o/3EbGzNwMqQvohGvtXIuHclk7wcqEAOTG0XRaZ+n+Gvs5c1xQE/gMwlXtPZ/wg9qn5iE64GmgGAMA0VK+6F4bubtIujXP3Qx8nDZn7PHisqxALg+ZkIyDBLZm+K/UZIE9+yih5KcfD6faRyVrJqbs3Z/52SXhPyaqtyJ0haT+sY9ywwA6yE4lFYSFOkl/ge1w/hqSTL2dGzqrVs7esWc4/dcanM03XbL5lxg1Py3VXOK9PEiEjrynby0/TkrSDtGjWU8BGK1MFde/8gUFi8qMkcM4rqkzITTqj7HTo2qDAECWUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Max,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Max-Kellermann/mm-shmem-add-const-to-lots-of-pointer-parameters/20250830-023442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250829183159.2223948-9-max.kellermann%40ionos.com
patch subject: [PATCH 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20250830/202508302325.b9umktOw-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project ac23f7465eedd0dd565ffb201f573e7a69695fa3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250830/202508302325.b9umktOw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508302325.b9umktOw-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/s390/mm/mmap.c:187:44: error: passing 'const struct rlimit *' to parameter of type 'struct rlimit *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
     187 |                 mm->mmap_base = mmap_base(random_factor, rlim_stack);
         |                                                          ^~~~~~~~~~
   arch/s390/mm/mmap.c:50:26: note: passing argument to parameter 'rlim_stack' here
      50 |                                       struct rlimit *rlim_stack)
         |                                                      ^
   1 error generated.


vim +187 arch/s390/mm/mmap.c

9b11c7912d00d0 Martin Schwidefsky 2017-04-24  167  
6252d702c5311c Martin Schwidefsky 2008-02-09  168  /*
6252d702c5311c Martin Schwidefsky 2008-02-09  169   * This function, called very early during the creation of a new
6252d702c5311c Martin Schwidefsky 2008-02-09  170   * process VM image, sets up which VM layout function to use:
6252d702c5311c Martin Schwidefsky 2008-02-09  171   */
f547a726bf8dd8 Max Kellermann     2025-08-29  172  void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
6252d702c5311c Martin Schwidefsky 2008-02-09  173  {
8e89a356feb6f1 Kees Cook          2015-04-14  174  	unsigned long random_factor = 0UL;
8e89a356feb6f1 Kees Cook          2015-04-14  175  
8e89a356feb6f1 Kees Cook          2015-04-14  176  	if (current->flags & PF_RANDOMIZE)
2b68f6caeac271 Kees Cook          2015-04-14  177  		random_factor = arch_mmap_rnd();
8e89a356feb6f1 Kees Cook          2015-04-14  178  
6252d702c5311c Martin Schwidefsky 2008-02-09  179  	/*
6252d702c5311c Martin Schwidefsky 2008-02-09  180  	 * Fall back to the standard layout if the personality
6252d702c5311c Martin Schwidefsky 2008-02-09  181  	 * bit is set, or if the expected stack growth is unlimited:
6252d702c5311c Martin Schwidefsky 2008-02-09  182  	 */
8f2af155b51358 Kees Cook          2018-04-10  183  	if (mmap_is_legacy(rlim_stack)) {
8e89a356feb6f1 Kees Cook          2015-04-14  184  		mm->mmap_base = mmap_base_legacy(random_factor);
40ae96eabea408 Lorenzo Stoakes    2025-08-12  185  		mm_flags_clear(MMF_TOPDOWN, mm);
6252d702c5311c Martin Schwidefsky 2008-02-09  186  	} else {
8f2af155b51358 Kees Cook          2018-04-10 @187  		mm->mmap_base = mmap_base(random_factor, rlim_stack);
c52d638d6b5da2 Lorenzo Stoakes    2025-08-13  188  		mm_flags_set(MMF_TOPDOWN, mm);
6252d702c5311c Martin Schwidefsky 2008-02-09  189  	}
6252d702c5311c Martin Schwidefsky 2008-02-09  190  }
fd5d210fa66bee Anshuman Khandual  2022-07-11  191  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

