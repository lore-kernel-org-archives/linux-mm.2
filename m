Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8C28CD342C
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 03:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D4E6B008A; Sat,  2 May 2026 23:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E0D6B008C; Sat,  2 May 2026 23:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B4C6B0092; Sat,  2 May 2026 23:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C93816B008A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 23:27:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B0921C07F3
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:27:08 +0000 (UTC)
X-FDA: 84724672536.01.5BE877F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AA68C0002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:27:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RXdPf+4u;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777778826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuZRVQcECLQZkUzi3woNDOVUbSA2BdvFM928riufwXs=;
	b=wZgSoBBmqWFMCqgOvSCmxYIhk6F4ea3Rp0/rGERKxLh6gTekw20JH/0Te1uw5S/9Qkp6v+
	f3d4u3295dVvYusCWs5oPC+OsfkKPweJrsQjG4QoC6Rb4IVPK6cYhV71956TD8Iys8c9p6
	l2n+jl3+oQjhIKiK9U8bImM0JLcfz/s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RXdPf+4u;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777778826; a=rsa-sha256;
	cv=none;
	b=XbPB35C+cdYNhJ6JDrjKnci4eHJA5PmZNvJbomnZibTeGmmA+C0Utl2FP4uaKOR85oraRN
	4BI5G+mATDYT0RBMo1WgUKF/2OBqBFGZIjyhsGvzaKNpwgEHq30REJw+GbgDDUkqnwD7KF
	5LTXzLXwNLpBAD9R0RuZIR2+xpR8cr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777778826; x=1809314826;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ThXQhMikk8hxgAx07+XgCLWhDs9WRJYcmWLBf6AsvLc=;
  b=RXdPf+4ujjGY4jmmOQ6SyPDLA53TbfuCoQG9P+GKt0095JFDuZNPUjCS
   9ZBcDibdSN96Pek7ORV6bxivLBdSkUdjGyGYc9KwzE1PAVEr3g4HbeYhc
   Ocl8a1fadYX3QgObjC0mdX4Q8beUIOnhVM52J4oLBeFkIUQCXAU7UN0Km
   qJNfgIYy9cpPjf/mQoX6rQfVN3zz34YQvk7cE5ufr+l1T/19r9zl6D8FX
   lcB+skB91iB6lOxWDj0/EZDuIJKV89Z0WiF1344uw4fpX9+KgbgCVMmXf
   sxoiJAN/rqqTzeqnybKtuhGiJ1KyjSWw0hYApcGR+CIAvsujyuPkB8SFR
   w==;
X-CSE-ConnectionGUID: 2+grTjsbTKKrXjisqf1cDA==
X-CSE-MsgGUID: xin+TZv/TfaK/+BL2X2bLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="96111907"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="96111907"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 20:27:02 -0700
X-CSE-ConnectionGUID: qHMWufCwSIGpnrzHrQx6fQ==
X-CSE-MsgGUID: ZO1gsvhvSgCXvuXrkhaoRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="240182796"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 02 May 2026 20:26:57 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJNTq-0000000025d-1ypD;
	Sun, 03 May 2026 03:26:54 +0000
Date: Sun, 3 May 2026 11:26:03 +0800
From: kernel test robot <lkp@intel.com>
To: "shaikh.kamal" <shaikhkamal2012@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	pbonzini@redhat.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>
Subject: Re: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via
 call_srcu()
Message-ID: <202605031115.qmkkOLQc-lkp@intel.com>
References: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5AA68C0002
X-Stat-Signature: 59ddiuktxmb1pmhtceej4jyq1puwkn7u
X-HE-Tag: 1777778826-93621
X-HE-Meta: U2FsdGVkX19mJ+Yfk8JfM+yQ1fTcj+M8mReK9Nb+Eu9tmdCBD/6A7EZ50XB9VmFfSmUpCu5zr7iGCa7luKimoBeoFl0WcGpHixEtZIHCAYfZCJytzza8P/UhQrmDB8qbAsYppgmZO+Tzymax30Stmv6A74T/ODGZudg5+8gvNV3ju6X8dykqGGEucYzZzaGjYhnrXzISeJb0jQE61lyhPJ0HEzc00tqhxx9MZSixgEFoZdd3m35NJDGBm6yAULeEvJBIf5Qqe4wwFN91EsouNmk47RIWGZWlk3bLbPGLAf0PrT2r2ozKmIHzbO1TKy1yG9G3wxD7Qb42YI7zo5U3QBR1OfZaYHypy9TJzL94qPVEG5tnpM6QNvuaxDHpE/BUX0lf2OFx0kXT6XdK4axrM7Mu2xNCmF95wxev6BO/x5VaNbc8lKq33DsPVOIkxa3e0Z4EGr8xAgHqvm9pPXK5s1l+l6lCZmCiMwqM6OvQlNNcXz9/m4V2vy5MAOZiEpbPrODPmOEOM3iYZN1VExmjiMe2XGIy5ZnxMtl8EbFUqmke7xXm2OYai9TCctUG7T3H0SHO9/qwCF+NbsKOjPuFlf4eewrJ8Afd7EVQ8gwMBVCL6UnTm+/J+1xlUOzbCsiSeawMdgzQEK0/lPAhT+b4yqaCTfKX+lDhlqJVebBTiX4dSDQh6Z0lUVToiE4s/xEpr2Wz5cQiEXFfVjIfXOd1dIBwjtIH/lTgx68UZaOZ26TRfbfgs1nrCATCvcqOd+tt7CfJtE8dEEneKtSAIscZCOpFWl+VPyFuyNWQ6ohfpMke9UTMF2tAWDWeKiGFluNLKWXxOm0JNAphxiNHLNP9ZjWzxRpX3RmLrPHEv3DxjV/kQ3sohuKGSmrxenbftTUdT/lnqbEvlJ6iwrl9zQLQViuRHjTErkTcj6SH14WQQwz8M5gvblVuHbTsy/9s2Tvx7gaLA2Bu2IRWAEi5QjI
 gfVYZx5h
 K2mnNLlpGS3mRSjX0H0bDBv+bOtsE5KxmayGrNKhzUQbRnoRLXGZ4JUZ/nuNiEi/A2SEFyL9Tak47ee4eNbgRJMZV/P28SnUGSuevKrrkQnyr1DePNY89eiZaoUhpc+oJq/AY+SMaDRh7K1GDkFi8Mn3uOlhRHcYtu3UMrsBI61Ip6GoIqSjxFW/7ILyccLuHpO5u2W79CrIhQYYdj+LsuQca+Fi8ZCBnNCxAZq9icsVi5QGTSegSntcOn2D8hk0BVRCZu2iRj2TSwSdeFpL48AbQHKWmBNLcJbrobL+LxPgpDV44qJ2wxjYt7PzbEcJE0u5IkyuK5H7qXPiHetA80EyRz7T7uTRSnv819bqhuMZQat+bdWBZvJEsX7nNhHd9RacSUy6VAWdCJdYvzuPs+LXT0WGoPTjPls+PAQKwKJ0SCHdE67aGZHPKc+nXKtjws4vaJCJlU5mqtLXi38ZDdqacm3S1MVFb4/mI31TB4vskfOavzw+Tcdr7ke9sNsIieR9sbZLsqRUdLb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi shaikh.kamal,

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.0]
[cannot apply to akpm-mm/mm-everything kvm/queue kvm/next kvm/linux-next v7.1-rc1 linus/master next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/shaikh-kamal/mm-mmu_notifier-Add-async-OOM-cleanup-via-call_srcu/20260430-202943
base:   v7.0
patch link:    https://lore.kernel.org/r/20260429222548.25475-1-shaikhkamal2012%40gmail.com
patch subject: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260503/202605031115.qmkkOLQc-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260503/202605031115.qmkkOLQc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605031115.qmkkOLQc-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/oom_kill.c:523:2: error: call to undeclared function 'mmu_notifier_oom_enter'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     523 |         mmu_notifier_oom_enter(mm);
         |         ^
   mm/oom_kill.c:523:2: note: did you mean 'mmu_notifier_release'?
   include/linux/mmu_notifier.h:610:20: note: 'mmu_notifier_release' declared here
     610 | static inline void mmu_notifier_release(struct mm_struct *mm)
         |                    ^
   mm/oom_kill.c:511:28: warning: variable 'oom_reaper_th' set but not used [-Wunused-but-set-global]
     511 | static struct task_struct *oom_reaper_th;
         |                            ^
   1 warning and 1 error generated.


vim +/mmu_notifier_oom_enter +523 mm/oom_kill.c

   515	
   516	static bool __oom_reap_task_mm(struct mm_struct *mm)
   517	{
   518		struct vm_area_struct *vma;
   519		bool ret = true;
   520		MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
   521	
   522		/* Notify MMU notifiers about the OOM event */
 > 523		mmu_notifier_oom_enter(mm);
   524	
   525		/*
   526		 * Tell all users of get_user/copy_from_user etc... that the content
   527		 * is no longer stable. No barriers really needed because unmapping
   528		 * should imply barriers already and the reader would hit a page fault
   529		 * if it stumbled over a reaped memory.
   530		 */
   531		mm_flags_set(MMF_UNSTABLE, mm);
   532	
   533		/*
   534		 * It might start racing with the dying task and compete for shared
   535		 * resources - e.g. page table lock contention has been observed.
   536		 * Reduce those races by reaping the oom victim from the other end
   537		 * of the address space.
   538		 */
   539		mas_for_each_rev(&mas, vma, 0) {
   540			if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
   541				continue;
   542	
   543			/*
   544			 * Only anonymous pages have a good chance to be dropped
   545			 * without additional steps which we cannot afford as we
   546			 * are OOM already.
   547			 *
   548			 * We do not even care about fs backed pages because all
   549			 * which are reclaimable have already been reclaimed and
   550			 * we do not want to block exit_mmap by keeping mm ref
   551			 * count elevated without a good reason.
   552			 */
   553			if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
   554				struct mmu_notifier_range range;
   555				struct mmu_gather tlb;
   556	
   557				mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
   558							mm, vma->vm_start,
   559							vma->vm_end);
   560				tlb_gather_mmu(&tlb, mm);
   561				if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
   562					tlb_finish_mmu(&tlb);
   563					ret = false;
   564					continue;
   565				}
   566				unmap_page_range(&tlb, vma, range.start, range.end, NULL);
   567				mmu_notifier_invalidate_range_end(&range);
   568				tlb_finish_mmu(&tlb);
   569			}
   570		}
   571	
   572		return ret;
   573	}
   574	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

