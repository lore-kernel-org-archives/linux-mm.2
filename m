Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F978D4A5E2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69146B0005; Thu, 15 Jan 2026 21:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A100D6B0088; Thu, 15 Jan 2026 21:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EEA6B0089; Thu, 15 Jan 2026 21:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 809336B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:04:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DBA2592AB
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:04:40 +0000 (UTC)
X-FDA: 84336183120.19.B6E4B64
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4FC0E1A0004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:04:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j3DsGlw1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768529078; a=rsa-sha256;
	cv=none;
	b=v5nkRijNo3sqvJbJgQzx4Si5S/xsJmv4t25y12Y4UjbA0mRPwGWj+SQ4/UOlDhU5fq4fxg
	h0A+58kozkSIgpiYp/jfzPlzG79c9EG064sJHl6OjwYimaqrcwkw8Ohn5t+hyv6blorZJQ
	a+ZibPyEQGyAM4XCHN74I0PEWTGXta8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j3DsGlw1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768529078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pp8xLppQ0MmmMp7iZrsfLhJwefYOx1OG3X2oa9l7GXA=;
	b=U71Wqk7Q1HavVj6mXC/24PNjqlVzoNG+Ha6ofOIYfobDtV5e1HNTRUPXtEydqGF1IhdCav
	3XG7U68Yx3sgaKw4MR5S69o9Uo9dGkakcY32JVlsV35t3smJccUFWFcfobQ9steKnMapk+
	J/GYW7/tX+RnNnEq/qIl+03u/vbkjeo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768529078; x=1800065078;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FSR96mvqfYKhN3guEUKfYNC/qmzApNrx81Q7cdUp94c=;
  b=j3DsGlw1G3ygVDf5Yhn+Uj6Q9RvHTBFrhDk7Pt1hzZF5gMYhgxaFgSwF
   oPswU6IQhjgUumU7qdCLN4w6f3M7Pad73PSQ1WKbFNV/agfPl10RZCmeR
   cSWO5gB22k3xa6RhTb5z7RaoP0dwM/h34HI1lYXeDc0Szm+pqSzZ3oFS5
   2CfScnchLtIU5+PTjvonEZzFb46pBUdQ7dDDN+jsTJN1uC1BD3YOnueTf
   b96Y5vd6ROA3vahm0AqOJDJQMhMqYQPKajGBfX9VxP8OWs65nd7KvbXsX
   n/SZbPKcU4hQu3GQxwtKBm2/REg73vvTj0HG3VHejluhGtHkXXfgg52d6
   w==;
X-CSE-ConnectionGUID: r40Tt5ptQvG1MLJYuNLrLw==
X-CSE-MsgGUID: /M6oZQzxSyaJJgbl0hnofA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="87421306"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="87421306"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 18:04:36 -0800
X-CSE-ConnectionGUID: JRwRd9eZTZiNen7mrvf2qw==
X-CSE-MsgGUID: FyAMgUcFS7+XR40u+NaN+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209257322"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 15 Jan 2026 18:04:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgZCO-00000000KFS-13La;
	Fri, 16 Jan 2026 02:04:28 +0000
Date: Fri, 16 Jan 2026 10:04:27 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <202601160925.VR8a2hUw-lkp@intel.com>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
X-Rspam-User: 
X-Stat-Signature: 3uybm8ifbba4ohxwdeuyuoa67ehh9bpg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FC0E1A0004
X-HE-Tag: 1768529077-841084
X-HE-Meta: U2FsdGVkX18CUEvb1Ostyl2S/ETsVyVTY+Xd/r8C1h3THEDaTMLPoL6WhrnzQHhGY2R/KIfJVhs5ehtti11l+kIYfirakEgoYd6cy68j0c3W7VH0xK+Znkqxb+fUOiqavb0lwAe7BsEXH2jCr6fHEOZysyFRuZ8zW99G8vHmQJQKtoR0LolbsGyDHWejAExp8rIUQQxaydmGwmlW3sw4NM1xJ6hP02awrSUE0qtkhcupmYv9YJU/9VXJOX9RYXJBAJNzzYjBTBN7L3JjZtPyk7VwRbIKpNzReYZsDV4n6ThTevQ1Jby2Cowx6Q/BBoRLucYySKWGCHfTLcMOCovGX1Me1ZRbD63NPRr2OSWpmqd/A6Bj6Zbsd8n+4uicYHmA/Byni2dAEhKshWa5ThcghKlIVkb19zyKOv1662ixeMKVmmVfvQRn3urDcuI8v37Q6/2RUehpwRkaP4dWm8ZnjIN7eTCiaCyCYiILEhXWdMDmXvwDgBPj+dbSVKKGYlU7LuMMxuXOhvXVzhgVMqCUikwbdALKS79XSlUpy7LIOr7sanQJpp07bLwlChmMsOAScXZqvsaMfJF7xUxy5bTry/TmZWg5iBiEaVOsgC4f0pBBsNyk26anbTUk7npnBKgPNKQZD9GuYil7XWWuxBs8cQ8wi/K6+7oBrT8KG/nNBYWCaMhkO96RxMpmhwB3b1Xq7XCjAJYdBiM11e2eOW/P6Ygg7hColF6eVZLYIjXaHphgAEAmOWokwHZaBDL1REc2xOfuUG+fiTJwmRr1RELLI/0d3vgsd7Cp0qdffu/U97O1zHqze+bFYOIWSdL45GAkQSWbDZ3Z8OcAyFeFXwtw2btrO4yXa+BjOHyQ71e7HkxB788dpLsSVxJYoaIDoP2xCkWHcW2S+p99XuxgR2a//5BQcdsYRIgkgnpILZgr1/2JLg7JQgiNjfDptoqxhPFGlmEDhOvwagKovx5wWSG
 qu+nhhEi
 7zoyU2PM3POAWoUhzUOcTfO3e+XKk2ZcdD8vHNDrJVuFwDrt2HXbEa+XAtfXcQS582KQT8OMdqHMqL0PNzbhDItossBG6PUyTdd24vyNkd9nLsw8vn1MWypFjV18IZ3cXhwhzRZBuGcA2ATiQKMTkJXehy4XB/Sv/KbdjQ6PsViDPnZpZK1rCKmhHO8eSI1TruY/1a0ZlsdgCqjgF0+YxmZj9efCpo6D6w/Ru4srw4D5jXMuyhp37UW+RTAovtXbD9SZfhl8YcllZynio+QMkzM469Uz0F4gEIY02rZvy+pZhStpRywfS28eiyhU4ZxTAco1Kl9uoSk+NUnWcQBTzXWov3NdNbvRrH3n4nfBMRuUEoY6N1MCuTcz7UfT6qOaZTjRx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master v6.19-rc5 next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160925.VR8a2hUw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160925.VR8a2hUw-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/internal.h:23,
                    from mm/filemap.c:54:
   mm/vma.h: In function 'unmap_all_init':
>> mm/vma.h:175:27: error: 'FIRST_USER_ADDRESS' undeclared (first use in this function)
     175 |         unmap->pg_start = FIRST_USER_ADDRESS;
         |                           ^~~~~~~~~~~~~~~~~~
   mm/vma.h:175:27: note: each undeclared identifier is reported only once for each function it appears in
>> mm/vma.h:176:25: error: 'USER_PGTABLES_CEILING' undeclared (first use in this function)
     176 |         unmap->pg_end = USER_PGTABLES_CEILING;
         |                         ^~~~~~~~~~~~~~~~~~~~~


vim +/FIRST_USER_ADDRESS +175 mm/vma.h

   169	
   170	static inline void unmap_all_init(struct unmap_desc *unmap,
   171			struct vma_iterator *vmi, struct vm_area_struct *vma)
   172	{
   173		unmap->mas = &vmi->mas;
   174		unmap->first = vma;
 > 175		unmap->pg_start = FIRST_USER_ADDRESS;
 > 176		unmap->pg_end = USER_PGTABLES_CEILING;
   177		unmap->vma_start = 0;
   178		unmap->vma_end = ULONG_MAX;
   179		unmap->tree_end = ULONG_MAX;
   180		unmap->tree_reset = vma->vm_end;
   181		unmap->mm_wr_locked = false;
   182	}
   183	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

