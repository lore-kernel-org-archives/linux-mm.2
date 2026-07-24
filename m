Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A59E1C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 17:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AEE66B007B; Fri, 24 Jul 2026 13:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8601A6B0088; Fri, 24 Jul 2026 13:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7513B6B008A; Fri, 24 Jul 2026 13:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4337F6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:06:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C362EC0457
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:06:46 +0000 (UTC)
X-FDA: 85024299612.01.488C8EA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF7CB1A0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:06:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GLdfE0kB;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784912804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cdT8t9h3yt/zKVd24lkQCq2fH9Gx8Vx54Fl912gDe4=;
	b=VvI4AZ6Y5fsLCSabZqG7LX7kqxpCVX/GtNMkIUHgn4vLpOXFyf50Mb0ABMkmpbRPRK2im3
	UiN41GAFljyKNFJM6qYvaMNcWBJH3m+kFU2HE76LP/6y0zabpV6R1P2SK/4xExwt5X6fa5
	O51Rq7QmHcWJQO70uhkj5nR+5oeTc7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784912804;
	b=vsjnhQX2sCv8vhrPfyIt8xJJlzBM/f5xIokFfS3vqELbvYGG2buqMzP1Hh+MWvIf4ffxbv
	P8Qudc8JYCElcXhM5MNE8X9eUtiofAXwaWYXLuT9LR98ndevW2X3pMm2u5z9sKlEp2sTY9
	9uSa6Gbj6NiXbKiH/Ifec8HgAAcHngE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GLdfE0kB;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784912804; x=1816448804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=et0UWU7GWJFC1gjDPbpE9qllm2y/YzAgaFxgHja6Us0=;
  b=GLdfE0kBiHcA9igp3Vt1oPMOc2pfzqyJs1lQLY3u1W/pS5s5ujn2YwP6
   +HXqSqhDHQ4+TgdH5Aba6SQjYY/9Emg7qbR9reZQGReGU49hQlbCJoqwN
   w3BnW+eEbYau9ZVJUOMScBYcVMrtg7lb2wmkwVW4D40MM7kcus4Se8ldE
   DPChv4uWEc7kB9v/XvxHy625pl4u5B42DxFBWCfV6WN+5aZM+JwWOb1DQ
   vHsA+OMfvipbogVjL3j8s5INbgaD1MkWCKTKAx9xAw3+boWqmlxOl9QCf
   m2XbDwcdcYorQAjPQWhX0wI8vtyIjBKSed5N6nYyxpsLabDkHHqPYEMdz
   Q==;
X-CSE-ConnectionGUID: P0C3KPC0TYGAiVQUtRHA6w==
X-CSE-MsgGUID: OQkygxxYQ5SX0Mt5W3XHYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85699563"
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="85699563"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 10:06:42 -0700
X-CSE-ConnectionGUID: 0Olbifv3SQGISQFQH44YYw==
X-CSE-MsgGUID: mR8xJkYlS+WK7oBFT9Sivg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,182,1779174000"; 
   d="scan'208";a="254835244"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 24 Jul 2026 10:06:35 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnJM1-000000000z4-0zCh;
	Fri, 24 Jul 2026 17:06:33 +0000
Date: Fri, 24 Jul 2026 19:06:07 +0200
From: kernel test robot <lkp@intel.com>
To: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: constify the pte_offset_map_ro_nolock() return
 value
Message-ID: <202607241905.9UNne8Y8-lkp@intel.com>
References: <20260724102017.141532-6-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724102017.141532-6-pfalcato@suse.de>
X-Rspamd-Queue-Id: CF7CB1A0003
X-Stat-Signature: zofir7m3cp8awkhtr4tsnmw6kkt4whef
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784912803-407526
X-HE-Meta: U2FsdGVkX18M7ypUd72tgebAcmkNOt22eTpOA0BYlqYY97NJOVl354DiqqbLVeThBydZFpG9aMWeCNHlxQgte6YKiWU4ecFuTBik4GKzMtG/LUlF01gkJrPJtCkiLE6bPYTZKXNxQIOCAAzYZEmLocDRCVFgNt6s9rmaOKW680w1r/253ElqsY5P6RtTUdJmWrsklrDE/cb9AJPsDx+W2NYrDVn0sD9Srghg5Zk9R2xLgdRcMeYXWEq182nrvUXME6W90Co5k7LQEkB6k380kpjYOlKEisGJnnW9QfuAmo8Ese5HzbDDjH2ow8C+Mroam099wMbK7Le1zxvtAqzON84jy+GqHfEp5zoBLQXX7facBW2fOVPXEQwcfmiJ7uO7o0NrNWZCajwM0XzLeXL9jTx/uP8HP28w/jL8PsOBoG4ltozLGJYno+R0798qCrfG4b2UMXO0OaorPfhi4paoMIHEoFU4VsU/UufZvssLJW3LbZWlkvYfIjQBBf/FISlKrAu+YucclursHZAz1DtNKThycuTBhQP+b/dmY5hApHuJBg21FLcTdkHtbMjbF6Nky3ZVLlvqqr86PLRZ1k2bM0adQgiIRwM7YVveWHqCOhmiabTawRvG+O8Nf1da4dm6/NpACA5ijB4zWm7OT3JZ/41bKk564HgE+HnWhF/usrsRliJ3sL41y/SfwR7PlrWovrNl4HDOI6wozta2s8DwEIPNlwoO6fhUMJRV4GyfjAGWrnAcu6BbsKNr5NyYFC7ECNqeO0upUh8WwCU7JgEsPrTDWuLqpTKAckgejjCmUxBrkiPOiT82HJxzffrR6YKZwrvyB4T+2NkroVRdBjDtv0XiQrMNUKCxQ+iMn44WWPvm2rt/9x4aLk2MGHl4rsVaPdDG0MvsF8Mihws+YNuBqx7pB9H9ufeqt5/aCaz5qH7i3bOu5p7Lf2V8/DNXLRV19INSiDO+Ncx9UIHoEy6
 WTul1DaQ
 Vsf8umLPe0wVUG/4don332YwrBQKHH5hxWUEymO+2KcWfv5dBY4AaUXV/6w2tmr76MTZK7C4dgGY/pwVysIJE7uE3i4/HA8tohV9ZR0qjvWl6WL0azKbHOV5EORUcGKJcw/0A/sNXkfTz8u7CrbzYPuE4Qx1iooV/mgmcmNsbA9IOfPy2iQdjlCfImB6EelYH2udItxG2n0lsZO6HzV6Gp/bdQmQYs2M2dLMSQ+5uINgIdw1cg1qkVwGJbPTi1bYIRx9wU+EmaD6BFWCjThVtioG58RFuw6OHsqQIRszuYmhyktauY/++hEZeJ/lcO9M879OEDkJTEWEizZxV8xLyby2znlsLSCWj4cVTYIg86vjoGGlHJe9o8QC9i10OjYtgfgln1HWdAGCqJxq588lBIDSO4T+BuxkZApbS4x/sXE3W2+x/qnRHsehODYkRUvDEUXMvtX/9Hml1x4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pedro,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Pedro-Falcato/mm-constify-generic-pte_get/20260724-184321
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260724102017.141532-6-pfalcato%40suse.de
patch subject: [PATCH 5/5] mm: constify the pte_offset_map_ro_nolock() return value
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260724/202607241905.9UNne8Y8-lkp@intel.com/config)
compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260724/202607241905.9UNne8Y8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607241905.9UNne8Y8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/s390/kernel/asm-offsets.c:12:
   ./include/linux/pgtable.h: In function 'ptep_get_lockless':
>> ./include/linux/pgtable.h:782:25: warning: passing argument 1 of 'ptep_get' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     782 |         return ptep_get(ptep);
         |                         ^~~~
   In file included from ./include/linux/pgtable.h:6:
   ./arch/s390/include/asm/pgtable.h:989:37: note: expected 'pte_t *' {aka 'long unsigned int *'} but argument is of type 'const pte_t *' {aka 'const long unsigned int *'}
     989 | static inline pte_t ptep_get(pte_t *ptep)
         |                              ~~~~~~~^~~~
--
   In file included from ./include/linux/mm.h:31,
                    from ./arch/s390/include/asm/pgalloc.h:18,
                    from ./arch/s390/include/asm/mmu_context.h:11,
                    from ./arch/s390/include/asm/elf.h:173,
                    from ./include/linux/elf.h:6,
                    from ./include/linux/module.h:20,
                    from net/8021q/vlan.c:20:
   ./include/linux/pgtable.h: In function 'ptep_get_lockless':
>> ./include/linux/pgtable.h:782:25: warning: passing argument 1 of 'ptep_get' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     782 |         return ptep_get(ptep);
         |                         ^~~~
   In file included from ./include/linux/pgtable.h:6:
   ./arch/s390/include/asm/pgtable.h:989:37: note: expected 'pte_t *' {aka 'long unsigned int *'} but argument is of type 'const pte_t *' {aka 'const long unsigned int *'}
     989 | static inline pte_t ptep_get(pte_t *ptep)
         |                              ~~~~~~~^~~~
   net/8021q/vlan.c: In function 'register_vlan_device':
   net/8021q/vlan.c:249:46: warning: '%i' directive output may be truncated writing between 1 and 4 bytes into a region of size between 0 and 15 [-Wformat-truncation=]
     249 |                 snprintf(name, IFNAMSIZ, "%s.%i", real_dev->name, vlan_id);
         |                                              ^~
   net/8021q/vlan.c:249:42: note: directive argument in the range [0, 4094]
     249 |                 snprintf(name, IFNAMSIZ, "%s.%i", real_dev->name, vlan_id);
         |                                          ^~~~~~~
   net/8021q/vlan.c:249:17: note: 'snprintf' output between 3 and 21 bytes into a destination of size 16
     249 |                 snprintf(name, IFNAMSIZ, "%s.%i", real_dev->name, vlan_id);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   net/8021q/vlan.c:237:46: warning: '%.4i' directive output may be truncated writing 4 bytes into a region of size between 0 and 15 [-Wformat-truncation=]
     237 |                 snprintf(name, IFNAMSIZ, "%s.%.4i", real_dev->name, vlan_id);
         |                                              ^~~~
   net/8021q/vlan.c:237:42: note: directive argument in the range [0, 4094]
     237 |                 snprintf(name, IFNAMSIZ, "%s.%.4i", real_dev->name, vlan_id);
         |                                          ^~~~~~~~~
   net/8021q/vlan.c:237:17: note: 'snprintf' output between 6 and 21 bytes into a destination of size 16
     237 |                 snprintf(name, IFNAMSIZ, "%s.%.4i", real_dev->name, vlan_id);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from ./include/linux/mm.h:31,
                    from ./arch/s390/include/asm/pgalloc.h:18,
                    from ./arch/s390/include/asm/mmu_context.h:11,
                    from ./arch/s390/include/asm/elf.h:173,
                    from ./include/linux/elf.h:6,
                    from ./include/linux/module.h:20,
                    from net/netfilter/ipvs/ip_vs_core.c:24:
   ./include/linux/pgtable.h: In function 'ptep_get_lockless':
>> ./include/linux/pgtable.h:782:25: warning: passing argument 1 of 'ptep_get' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     782 |         return ptep_get(ptep);
         |                         ^~~~
   In file included from ./include/linux/pgtable.h:6:
   ./arch/s390/include/asm/pgtable.h:989:37: note: expected 'pte_t *' {aka 'long unsigned int *'} but argument is of type 'const pte_t *' {aka 'const long unsigned int *'}
     989 | static inline pte_t ptep_get(pte_t *ptep)
         |                              ~~~~~~~^~~~
   net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_in_icmp':
   net/netfilter/ipvs/ip_vs_core.c:1768:15: warning: variable 'outer_proto' set but not used [-Wunused-but-set-variable]
    1768 |         char *outer_proto = "IPIP";
         |               ^~~~~~~~~~~


vim +782 ./include/linux/pgtable.h

024d232ae4fcd7 Peter Zijlstra 2020-11-26  775  
2a4a06da8a4b93 Peter Zijlstra 2020-11-13  776  /*
2a4a06da8a4b93 Peter Zijlstra 2020-11-13  777   * We require that the PTE can be read atomically.
2a4a06da8a4b93 Peter Zijlstra 2020-11-13  778   */
024d232ae4fcd7 Peter Zijlstra 2020-11-26  779  #ifndef ptep_get_lockless
3cfe4c8a2f30c7 Pedro Falcato  2026-07-24  780  static inline pte_t ptep_get_lockless(const pte_t *ptep)
2a4a06da8a4b93 Peter Zijlstra 2020-11-13  781  {
2a4a06da8a4b93 Peter Zijlstra 2020-11-13 @782  	return ptep_get(ptep);
2a4a06da8a4b93 Peter Zijlstra 2020-11-13  783  }
024d232ae4fcd7 Peter Zijlstra 2020-11-26  784  #endif
024d232ae4fcd7 Peter Zijlstra 2020-11-26  785  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

