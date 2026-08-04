Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA9EC55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63CC6B010F; Tue,  4 Aug 2026 11:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15016B0112; Tue,  4 Aug 2026 11:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A636B0113; Tue,  4 Aug 2026 11:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76B2A6B010F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE844120215
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:15:16 +0000 (UTC)
X-FDA: 85063935432.05.770FF8B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E35D120015
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:15:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=frHzcpl4;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785856515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=1884uuM82Be+Kv8zXAI7cwWYT/kOQrlHum6RIRg9KRo=;
	b=iCZPr2eorP7EBY/5cizDU1tAu3W//kzvYLKIPH9/fBHdYmhZY95qz7A5j0fgFHcpiJRAJf
	SHkgK2RPrbInFuxS19eUciF1lc6wD6lJh/QXksS6ftjTzEaB7SbS0sbo1dOTCz1J39t8HV
	v0CEU3rqgpnGYQuxOJr5NIFebHTNKaQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=frHzcpl4;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785856515;
	b=JQd/ePLehRU1/ygFKroYTjwPTWgF/xocH4U1hrBcrN9QEA1ezNd6CBOpn29kiJ9q8TyU+2
	yl9PMu5nDzF/kbCu+vrdtR+USMQU8KwuxLwrmzSWMd4TCHrIbv6JdVyuoU76e7Tbh19ZZj
	qMCexKrKeIppLxMaEjwOM4BVyj7Wc8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785856514; x=1817392514;
  h=date:from:to:cc:subject:message-id;
  bh=9NJ32ltbcB82qemSEoG7hUOvGbjw59Kq90HTXiUebBA=;
  b=frHzcpl4r1h6HL4e1dHhAlraHeayyDqDa8B0L5zTrDdp5su6+XuXDHMJ
   mHmfsQMQSWVWSZoPfCgvt7DOzOqJP2PtbTA9A4Y+msAeh/5nRDW1TFBMm
   992g8I2uPxItrNdH3ehDGOsoqteBAkjFv6rS7ooBqkJ8UnlbN0pUpNWDn
   BJM4eZ+rBK2H9dzY2StzNLJ3mnTP/+HjNmSSsd3yUAhiMAQmbxoKvgAbC
   Yz0t0pmuB298nfXwqGgEy8n5U4Myp88JQc4xRPnq6idUvwv3yO+HnJzEs
   DlHxEeLIhUZam3pZq5M/wkj3ZviNjXsPhYc37SHJAqbHe1SiB5QB704bf
   A==;
X-CSE-ConnectionGUID: Ey7v/L/HSm66Wx5Tgw68AQ==
X-CSE-MsgGUID: ww9tgYpZSGmK3KZQPW9yCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11864"; a="86441905"
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="86441905"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2026 08:15:12 -0700
X-CSE-ConnectionGUID: SirvBuQpQ/6ErkRXpQ9eXg==
X-CSE-MsgGUID: TWKi9LnJTDmscDnyOXkNzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,204,1779174000"; 
   d="scan'208";a="265359660"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 04 Aug 2026 08:15:10 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wrGrE-00000000A5b-0Kia;
	Tue, 04 Aug 2026 15:15:08 +0000
Date: Tue, 04 Aug 2026 23:14:58 +0800
From: kernel test robot <lkp@intel.com>
To: Pratyush Mallick <pratmal@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 SJ Park <sj@kernel.org>
Subject: [akpm-mm:mm-new 448/454]
 tools/testing/selftests/mm/.gitignore: warning: ignored by one of the
 .gitignore files
Message-ID: <202608042227.XDO54bZk-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E35D120015
X-Stat-Signature: g1m635jmg6c6qyjo48af8cibyibah5p6
X-HE-Tag: 1785856513-245424
X-HE-Meta: U2FsdGVkX19isDw3peYWgLA228pyB5j9B8S1iF5gcKaB3v2/HhqHygOMGwhw6KefFpEESLHrgVcXbDB4E0H7pwjPQ5jFRFA8YcmMPtknzigwzOyET2vuzX5SeY90QhycHkww2hO/o3bsgN+W6Kig0ohNtMacB732GpnyrztGF8BhZh33U0yngUOMCD6XLURY9tUi3TrQYSAHK57vE9YVBBo3cotdqx7hC7zIHpKWsrokd66jLq8SMZpAKKO62WDT1B6+irFPZIc3ViQhkGYyxekGOo5zZ3Ge1+3hrZk2e4NBPYBSKcuLw4BICkf1lJ4Ks8UvTMll5uep1dPutV14WlXsXQ3bLIq4mNMLtN191j9uLJox0yIDJ5l6NhaakQi6duTdetZz30kpLsto3UDh4Tee/cb/4kwERlPlvW7VVKFh0cs6G34S+NbI9xOtD97i9GTeds8zayMCUC6uNZo31HrNkkz4sbYnPDjjorsqD+Mr7ImXvptwyZn2lSZCST3w/j09nGvOL55Hn65o/cMS+06sMmJTDPJ53LyLPFXBCrxq+ntk4DZL3O23sgQ8juFbKmPl4XQU606M2ZS3DGhCdYPMiWAlk6Wc7l/jgTsVYyY3/aqvhnRJdbkNl8ScigCsPtwZU7OR/6VlJnfW+avwqkuvJfm3r9ftaAW0Z8bmp6Ggu+otpWcEkVJrc/N4rfzTQP62zMVgfIpI2iIS8hS9LyTe5+nyUo6/WtDHb/EvnaR5i6LDI6q/osv+eKRtl12+UJ1X/KV89Am3Yaw8OlRRg5JahvkPhNvF6rvULAg2j9YTMwmZ5sIdRkwMGcDFpYbGziZ7g0y8I+31Z9fDJB6ealcy275fbYLBrAdaSPKizYUq9o3Ik4I9lhIrnUpYbZ9cYnLMeCjhpQpVgP6gBl1EDJ46WFCBznOCAsuzXcE3DhC1fDsRqZem5BsiTsn0/tJwbNvP4VZi8nabsqcKrQp
 gSeb+z6A
 RJj2S8lW94F6YNLLu+d5zyJegPdYieYD1LxV9IRbBJe/cmCmplgvsloIqlflKe9J1FMEmD5qr6YkCmy8K7W4Ljk64eDBF9EgGKArzBW+c/OQo3aVPsL/tuC7NOhkqJvELJoJ43Q3eU1RushNUKvMMPdHPjb09ycYjks5uV+Is2/LoipaKnh3G7oOxEcePE/3s4aRl9SUDTLKwJW3zjY7UgdEuEyRfI/RSWdGXqmTeI+Bhhxc+p0pXlutF54MlbTandFeE6VLV9OCHqgpy2KuW9HAEdySD63rdGxOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e47602c51d20a93fa1711ed896dc9480de4374d9
commit: e051bf0188c9ae10e822a532aac5821c2cc0632a [448/454] selftests/mm: use pattern matching in .gitignore
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260804/202608042227.XDO54bZk-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260804/202608042227.XDO54bZk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608042227.XDO54bZk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/.renames.txt: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/.gitignore: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/Makefile: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/charge_reserved_hugetlb.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/check_config.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/config: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/hugepage_settings.h: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/hugetlb_reparenting_test.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_compaction.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_cow.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_gup_test.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_hmm.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_hugetlb.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_hugevm.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_kmemleak_confirm.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_kmemleak_dedup.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_ksm.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_ksm_numa.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_madv_guard.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_madv_populate.sh: warning: ignored by one of the .gitignore files
>> tools/testing/selftests/mm/ksft_mdwe.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_memfd_secret.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_memory_failure.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_migration.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_mkdirty.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_mlock.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_mmap.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_mremap.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_page_frag.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_pagemap.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_pfnmap.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_pkey.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_process_madv.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_process_mrelease.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_rmap.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_soft_dirty.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_thp.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_userfaultfd.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_vma_merge.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/ksft_vmalloc.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/mlock2.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/mseal_helpers.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/page_frag/Makefile: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/pkey-arm64.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/pkey-helpers.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/pkey-powerpc.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/pkey-x86.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/run_vmtests.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/settings: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/test_hmm.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/test_page_frag.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/test_vmalloc.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/uffd-common.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/va_high_addr_switch.sh: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/vm_util.h: warning: ignored by one of the .gitignore files
   tools/testing/selftests/mm/write_hugetlb_memory.sh: warning: ignored by one of the .gitignore files

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

