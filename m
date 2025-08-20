Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D991CCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581106B00FE; Wed, 20 Aug 2025 16:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558616B0100; Wed, 20 Aug 2025 16:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EA26B0103; Wed, 20 Aug 2025 16:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF6E6B00FE
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:37:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6FB1160119
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:37:51 +0000 (UTC)
X-FDA: 83798297142.21.F19B0CC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47204140015
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:37:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlOpZdpM;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755722269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XP9WNbNBHWy0UN59Uy/ifL6ppdS4q3FL1zyaJ0Tq04=;
	b=PGOzwIDqEHNtCPThXn5yvnC/WwVhekCTpkkud//CMDJxOYUKrQC3vaPrdRYK0vhSheKpZ7
	upu9FPtB7SsyZKNPp5yAadJA5avp5EmLPEdPqD/ISwrpfSHNRRr/yMklHiL7mbg2qEf2qN
	WDNaMcs4o5AJBLIgMkwt69U7nJNA0H8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlOpZdpM;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755722269; a=rsa-sha256;
	cv=none;
	b=ENZG3nGBIaqFBxE+u2XUeJgoMQhIzCaROrEGc+yStOOLT8RKo1111oxfvh/X4+3OfH6Wa+
	HfIVs83QJpGk6Tjkj1/+bkdJn3LHNjfRmwJRuneuDhAztuS+6lyliswlB1NTW0/9+yR7HC
	7jAnCQqZ6GRGe8Txiwa0tCtM1qrvpzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755722269; x=1787258269;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8QcGfN5TdHUtbZS2m0Ej+NCFDQ9y4qlsX6+iyfch6dY=;
  b=nlOpZdpMov5QiHrccE6YsYGUC125ISvLbB0XMHjcBw5MACIVhO/+aM/f
   r4st0J7G5dZKrOPfhe+JLPV49/Emgy8Vfzk6jgaHWf844cA4IrEMMhMei
   JlBPbTxE2Z0i3cN6WB3rwQmwc7Z5FYPa8BtjrjijVvCR3q+//DMLSMMw4
   06lYJG0Phu3InIBFkdToeI6gSGDl4uMuRb1N/U8oZLunEkwv4JWSQaVdj
   WOIOh5bK0AZVDKHXF9UCueM4FW77gZvj9yBcbwdSyJPlBLuJvMELeAz9D
   hXQRyTNhgAy4OsUwtAVADhVppezKTcCu25q+n636TlIgE0TlL3r4c6+2R
   A==;
X-CSE-ConnectionGUID: Igs4w93qRgaL183PT1Ddgw==
X-CSE-MsgGUID: ZSMuUSfBRU+nhBFOgkjn1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="75450440"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="75450440"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 13:37:46 -0700
X-CSE-ConnectionGUID: Qx5SML5/Rcq4Dz+k+Q3cHA==
X-CSE-MsgGUID: WmwMD/4fTSGku8VThrHu1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="173481976"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 20 Aug 2025 13:37:39 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uopYu-000JfX-35;
	Wed, 20 Aug 2025 20:37:36 +0000
Date: Thu, 21 Aug 2025 04:36:46 +0800
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
Subject: Re: [PATCH v3 18/22] mm/mshare: Add an ioctl for mapping objects in
 an mshare region
Message-ID: <202508210437.BXbf4eok-lkp@intel.com>
References: <20250820010415.699353-19-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820010415.699353-19-anthony.yznaga@oracle.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47204140015
X-Stat-Signature: fugtxji4r75ukou6hoessg4jq8ahoaz9
X-Rspam-User: 
X-HE-Tag: 1755722268-545570
X-HE-Meta: U2FsdGVkX19khOjvINRnFaTGq6IDu8IAdhRoaSgbEeMAS9eQ/trZjw71IYxihxnv1HKSkE8dSLj+Z4h6CCiGYklWsi6G7hNJYl55A1/XWKtNS4neGmAx90yDv4mS7AX4MSyhQkHw+2rebUy8/PXgmE+VPrid7jWkEUCkgZfYNxFRsJjqoobioFgEbXPUrrPQWqAJXpaATyjQpXGHMx+kmgv9iTFRAes6Axi/S7jh1fjB9uJN369fWZZaH69/8VeblVdAPjS2wG4BAKsaW5G5X5MZtzIe+xtJcCgMTkr1InYpzQSx8MvCNd/IFCBSa/QWa5SS/qrrb+ZhjteJ+rS3leHBOMxiqf8OAymErkj6foq+L35dMX4QimarjzMXMwnPgqOQ87t0AO9cDXvZkXozf0MQ7/5652luxSFSsXeI30Vsphgim2pE0vXAOKZd+GUJmllcPLrCf7CEFy4ErBfs2Vc8YisE/xuVHwiKQyU9VwwsGTwXvxLMt1FG+N/dOX74Gis+H9ULENzQCi0Fx9Meeojf+T4pD3MamRbY3bgTRdAke2+2HaCDBdpnUd7NRMfb0mua3ievkOr1DMw0afSTgj7nmxyHx580y5d6uv+5gR9vaCy7MaNr/DQv0ukbefi12koyWA6D2EY7NcyZ+PR/oGpfS9IKSKHNAJY0DNjhws7igLXtYU6TdteP6blQXB4k1twA7favzzcVBaCFar2T1dKsfbIPEbJsBoBJMHYUTDbfO59Ibz5GBhu/0wlipE07I2PJ5U67MEquCiWGQem4epDWze8J7a0ZjmkUp3wkkgLbBavpAp/LD0dH0tW/+rDzCE+RU+lzvoV1AEjD6fadmBnXli8HsCfAhHCsstq7jy0a+grvMcr8i7/sHma4f/3ZnlvgBaalfUXg9RcQUmZUHTDyw76lHkKSxWdqARODkOd8Xz97Miz+JvkWWwUW/DRf/QnjVj5iCcsMf8rVEXW
 RZuxRZt4
 ThGZvIDrI5kLvGE/pHFPjGx+Am1mtla1QPTySs3uA3DHjHDFI1ee2/tF4G8OTOQ7rOZAiK2tnpUus6bS/urP2qf7qbG9WVNI1WJ9upi2UFz1XJnm1H8JK/7v/NMpS2eYmyfNFZM2SP1YM5Pl9qvDwynufEHWkNfYb6Jt292ik7PA6wnjCF8yWpacDShkEi0ROUmr1iz/+RZKyvXdPMZ7T8dUCwjUP6tJswWRlPObNvi3o1IQ/X94N7fnaMEW8h4AWBVKmIDYYUerm/Us89SjdUYZfvybNWWksr+mCbJm3nwps0PTNSlQqv1EZ4Zgb742CkY0Eh3SYQO7kcKbM8GLvpBH2OAjEyaAFDYzWa5+7sfc8JUBm+StH6puhNw==
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
[also build test WARNING on next-20250820]
[cannot apply to tip/sched/core trace/for-next tip/x86/core tip/x86/mm kees/for-next/execve linus/master v6.17-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anthony-Yznaga/mm-Add-msharefs-filesystem/20250820-091021
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250820010415.699353-19-anthony.yznaga%40oracle.com
patch subject: [PATCH v3 18/22] mm/mshare: Add an ioctl for mapping objects in an mshare region
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250821/202508210437.BXbf4eok-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508210437.BXbf4eok-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508210437.BXbf4eok-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/mshare.c:305:16: warning: variable 'mshare_start' set but not used [-Wunused-but-set-variable]
     305 |         unsigned long mshare_start, mshare_size;
         |                       ^
>> mm/mshare.c:386:57: warning: variable 'vm_flags' is uninitialized when used here [-Wuninitialized]
     386 |         mapped_addr = __do_mmap(NULL, addr, size, prot, flags, vm_flags,
         |                                                                ^~~~~~~~
   mm/mshare.c:361:21: note: initialize the variable 'vm_flags' to silence this warning
     361 |         vm_flags_t vm_flags;
         |                            ^
         |                             = 0
   2 warnings generated.


vim +/vm_flags +386 mm/mshare.c

   297	
   298	static unsigned long
   299	msharefs_get_unmapped_area(struct file *file, unsigned long addr,
   300			unsigned long len, unsigned long pgoff, unsigned long flags)
   301	{
   302		struct mshare_data *m_data = file->private_data;
   303		struct mm_struct *mm = current->mm;
   304		struct vm_area_struct *vma, *prev;
 > 305		unsigned long mshare_start, mshare_size;
   306		const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
   307	
   308		mmap_assert_write_locked(mm);
   309	
   310		if ((flags & MAP_TYPE) == MAP_PRIVATE)
   311			return -EINVAL;
   312	
   313		if (!mshare_is_initialized(m_data) || !mshare_has_owner(m_data))
   314			return -EINVAL;
   315	
   316		mshare_start = m_data->start;
   317		mshare_size = m_data->size;
   318	
   319		if (len != mshare_size)
   320			return -EINVAL;
   321	
   322		if (len > mmap_end - mmap_min_addr)
   323			return -ENOMEM;
   324	
   325		if (flags & MAP_FIXED) {
   326			if (!IS_ALIGNED(addr, mshare_align))
   327				return -EINVAL;
   328			return addr;
   329		}
   330	
   331		if (addr) {
   332			addr = ALIGN(addr, mshare_align);
   333			vma = find_vma_prev(mm, addr, &prev);
   334			if (mmap_end - len >= addr && addr >= mmap_min_addr &&
   335			    (!vma || addr + len <= vm_start_gap(vma)) &&
   336			    (!prev || addr >= vm_end_gap(prev)))
   337				return addr;
   338		}
   339	
   340		if (!mm_flags_test(MMF_TOPDOWN, mm))
   341			return msharefs_get_unmapped_area_bottomup(file, addr, len,
   342					pgoff, flags);
   343		else
   344			return msharefs_get_unmapped_area_topdown(file, addr, len,
   345					pgoff, flags);
   346	}
   347	
   348	static long
   349	msharefs_create_mapping(struct mshare_data *m_data, struct mshare_create *mcreate)
   350	{
   351		struct mm_struct *host_mm = m_data->mm;
   352		unsigned long mshare_start, mshare_end;
   353		unsigned long region_offset = mcreate->region_offset;
   354		unsigned long size = mcreate->size;
   355		unsigned int fd = mcreate->fd;
   356		int flags = mcreate->flags;
   357		int prot = mcreate->prot;
   358		unsigned long populate = 0;
   359		unsigned long mapped_addr;
   360		unsigned long addr;
   361		vm_flags_t vm_flags;
   362		int error = -EINVAL;
   363	
   364		mshare_start = m_data->start;
   365		mshare_end = mshare_start + m_data->size;
   366		addr = mshare_start + region_offset;
   367	
   368		if ((addr < mshare_start) || (addr >= mshare_end) ||
   369		    (addr + size > mshare_end))
   370			goto out;
   371	
   372		/*
   373		 * Only anonymous shared memory at fixed addresses is allowed for now.
   374		 */
   375		if ((flags & (MAP_SHARED | MAP_FIXED)) != (MAP_SHARED | MAP_FIXED))
   376			goto out;
   377		if (fd != -1)
   378			goto out;
   379	
   380		if (mmap_write_lock_killable(host_mm)) {
   381			error = -EINTR;
   382			goto out;
   383		}
   384	
   385		error = 0;
 > 386		mapped_addr = __do_mmap(NULL, addr, size, prot, flags, vm_flags,
   387					0, &populate, NULL, host_mm);
   388	
   389		if (IS_ERR_VALUE(mapped_addr))
   390			error = (long)mapped_addr;
   391	
   392		mmap_write_unlock(host_mm);
   393	out:
   394		return error;
   395	}
   396	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

