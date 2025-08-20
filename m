Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A297CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 19:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21BEA6B00AF; Wed, 20 Aug 2025 15:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A52F8E0022; Wed, 20 Aug 2025 15:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094F76B00AF; Wed, 20 Aug 2025 15:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8DD46B00A9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:03:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7950B117FDE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:03:23 +0000 (UTC)
X-FDA: 83798059086.09.FEFDB87
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 03EEBA000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:03:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLVYAWAt;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755716601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLBsH/YIejPlJTdrf80v1UtSZK9GJ7uL4JX14pYsht8=;
	b=oJXFnXnZVSsB6ayvsuX/bq+hTmKx9FRNyptwZpVshyFiECyYz81PA2eXqFR3YoE79xjzn7
	KcVbmWNIkvxfORgdkDlngECfLTEKsqOjWv4rdrCo1N/OrQqgD+hVlPhozVcgqje4w5JNC4
	vkXa5/iwzGemb8avGw/+juofTpPN80Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLVYAWAt;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755716601; a=rsa-sha256;
	cv=none;
	b=25hTeRQZA7F1hVpc798HCQ+I3+kAbEYhP0ddOXkz5HOGf36At7vHOJge1iU0MEPwyb97Og
	fwszKaNxHENCvW8YUU3ivhZiLeiCTjo7Q1d3w6vG/AOzPid018hN+oALVi6DAh3JBECX2V
	EyIIFERMECSwpKWrPMySBnoIkyKYvKA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755716601; x=1787252601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5GfvpmvDEwt7/WHZ41ArcJBD9qOfspQN8odDWzwdDho=;
  b=mLVYAWAt7YIAtYuhUQUtjQmpCHaHBZvx269jehVWvuTwtcEldysJgReg
   lVQ8BWXMvaha6qaONx27R+x61v4LzmlSH0+SxmJFRRr4geHXjVGXry4de
   zpww6sp4uhfKUX8oFbFmW/l4blKposDhRE+oMB8/KjVX6HxsKxXYG1N6w
   uQhwppgIdpMBujBh6SWoWVdnzpEzUXDisu57atrn7QvO6f+7XSfE/odL+
   Z3558n232odVq/5BLYdhJihnOB8o0SpNbRwayYHvs3YdxVZoCVluqSZlo
   TsPgljLzpKaPU0FVMrJu0tPrksPmw8QSg+H5E9tOob4hbVwxvT7EvVced
   A==;
X-CSE-ConnectionGUID: mLmCHEtqRLO24lSzQCgFJg==
X-CSE-MsgGUID: drEjMdXMTxil4GAlDfStZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58064874"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="58064874"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 12:03:19 -0700
X-CSE-ConnectionGUID: XsAQ5YMoRIiHW1uiss991A==
X-CSE-MsgGUID: 474uIyjeSk+QHWasyB2kSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199075421"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 20 Aug 2025 12:03:12 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoo5R-000Jbr-1r;
	Wed, 20 Aug 2025 19:03:07 +0000
Date: Thu, 21 Aug 2025 03:02:57 +0800
From: kernel test robot <lkp@intel.com>
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
	bp@alien8.de, brauner@kernel.org, bsegall@google.com,
	corbet@lwn.net, dave.hansen@linux.intel.com, david@redhat.com,
	dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
	jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
	khalid@kernel.org, liam.howlett@oracle.com,
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com,
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org,
	mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
	mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
	osalvador@suse.de
Subject: Re: [PATCH v3 07/22] mm/mshare: Add mmap support
Message-ID: <202508210230.0Zc3YDIy-lkp@intel.com>
References: <20250820010415.699353-8-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820010415.699353-8-anthony.yznaga@oracle.com>
X-Rspamd-Queue-Id: 03EEBA000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: chz5xu4kst9t4hge4ejqtmrmmpwwgh1c
X-HE-Tag: 1755716600-708225
X-HE-Meta: U2FsdGVkX1+L/czzqcnvQ+MYKMXHkYAVJqbaebxidboOv+vx8HjRYICx7TDK47byKzYvMyvhS1IeXwlbryHoI1wcnM+zfCOGKtsAUok5xNMStxxQ2dTSW+ZrKjnGv7UuvOr0DL4sL9+WXuFJSkNj5xxU1ajiwCv/7EtSelwVJsvchDqYNa3oQoEV9Q0Pfi4hwzLErfjg6mPfrQczhc5k2NB3QkkPE3j3mZaMmE0zpOCZNMxbLaOgrUeuNWsiBrYhy7SpkLmOmZUa7wyaYJVju1nykm812oRuN23UwMFpPlwSUg41se2yRPOxRn6NNCq4Av/b08azNRZTwlPFF9PZH3OIlByP0G9qSlb1Fna5ImLeQnzkrxgOOuC6FzwjB66aDNE3kBPWrXgx62S9uaNV4VxguKgbQbrwkIRRh+h9aoDf6k/jW2hi6O/y/M20u/8nCGvpK2zP9IlvOxXXp0NnIhuz767P01iz+7RhktGSJbhKCov+rkxqdf3PmB94yxeDdFyxWnu20nTg+g0oyEV9c4m/dta2LyBAG7J9l7JBPhsPeloukM4XQSuk5p3FMmLOHfuwLP2RR+KPjuFQpM0X9HvjJxLd8VLsYL+6SBt0HoECbOrJKK+S2KVsHL1q9a3TdAYyQyyRSppbx8oxRPWyhCKjcStmGMsRtZyDUdgA12jMmMocCteqUlHXsg6+QDiFnRv3TvBhVuCncH1Y1RJw70M7rYI0KlqFZRAbtsoDS2/QRutFZtc+Z9i1hTA/As5HHfNoRQv0ghaGC+A26Nr9z+dnZQ0sZwEnhUvuSah+c4ZyrWdO9em2VDJ0+KQ8cqlfBnPtTY9DfJzyo0el9mw1vYYsSxHAVZDqnJWpykuZt7VaxVtLagmWeo0K4YXmUAo8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anthony,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on tip/sched/core trace/for-next tip/x86/core tip/x86/mm kees/for-next/execve linus/master v6.17-rc2 next-20250820]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anthony-Yznaga/mm-Add-msharefs-filesystem/20250820-091021
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250820010415.699353-8-anthony.yznaga%40oracle.com
patch subject: [PATCH v3 07/22] mm/mshare: Add mmap support
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250821/202508210230.0Zc3YDIy-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508210230.0Zc3YDIy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508210230.0Zc3YDIy-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/mshare.c:121:16: warning: variable 'mshare_start' set but not used [-Wunused-but-set-variable]
     121 |         unsigned long mshare_start, mshare_size;
         |                       ^
   1 warning generated.


vim +/mshare_start +121 mm/mshare.c

   113	
   114	static unsigned long
   115	msharefs_get_unmapped_area(struct file *file, unsigned long addr,
   116			unsigned long len, unsigned long pgoff, unsigned long flags)
   117	{
   118		struct mshare_data *m_data = file->private_data;
   119		struct mm_struct *mm = current->mm;
   120		struct vm_area_struct *vma, *prev;
 > 121		unsigned long mshare_start, mshare_size;
   122		const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
   123	
   124		mmap_assert_write_locked(mm);
   125	
   126		if ((flags & MAP_TYPE) == MAP_PRIVATE)
   127			return -EINVAL;
   128	
   129		if (!mshare_is_initialized(m_data))
   130			return -EINVAL;
   131	
   132		mshare_start = m_data->start;
   133		mshare_size = m_data->size;
   134	
   135		if (len != mshare_size)
   136			return -EINVAL;
   137	
   138		if (len > mmap_end - mmap_min_addr)
   139			return -ENOMEM;
   140	
   141		if (flags & MAP_FIXED) {
   142			if (!IS_ALIGNED(addr, mshare_align))
   143				return -EINVAL;
   144			return addr;
   145		}
   146	
   147		if (addr) {
   148			addr = ALIGN(addr, mshare_align);
   149			vma = find_vma_prev(mm, addr, &prev);
   150			if (mmap_end - len >= addr && addr >= mmap_min_addr &&
   151			    (!vma || addr + len <= vm_start_gap(vma)) &&
   152			    (!prev || addr >= vm_end_gap(prev)))
   153				return addr;
   154		}
   155	
   156		if (!mm_flags_test(MMF_TOPDOWN, mm))
   157			return msharefs_get_unmapped_area_bottomup(file, addr, len,
   158					pgoff, flags);
   159		else
   160			return msharefs_get_unmapped_area_topdown(file, addr, len,
   161					pgoff, flags);
   162	}
   163	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

