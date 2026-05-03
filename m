Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D348CD13DA
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 03:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E7D6B0005; Sat,  2 May 2026 23:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F8E6B008A; Sat,  2 May 2026 23:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E236B008C; Sat,  2 May 2026 23:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA596B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 23:27:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32BC8120854
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:27:06 +0000 (UTC)
X-FDA: 84724672452.07.662E8B3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C8C6C0002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 03:27:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gAqcGsHN;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777778824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kI4G4uq4hxTMcjGV+DEt/iG7QbJ622K/xobUxKVWXp8=;
	b=VaAk5I2Rr8AlNKvPPc0u0pGwTUI4C+iXi5yinfbH316s51mZdmAwl5J/3b39/W3QMnOMy+
	j53wiZKBqa0RDbaKPI6NrmC/HQetI3yZgxXceaQHZq3SoJ9JsEjQi/dK9RjrDKp9K++uGd
	fWUHBLYwaHlrtuo6vNqprpom267z0WM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gAqcGsHN;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777778824; a=rsa-sha256;
	cv=none;
	b=OhUyua21L/pTI9jjJfz53l/2+D4bzjlpkpK7bk1HBFqfbwqhPvN5uw5uBDOtxFJ5l0LD9J
	FOAjJpNMLExSJ9k5GpDfgRB5f2rrRfktmva9cFCy5F0alywL4MMnovl7jMnjzoijw44C/E
	ub1wG1PR669hvk8xRD+o7uV/U8HHR6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777778823; x=1809314823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ShNDtoLBYzDk3lm8mhIExWjIgbBm+p5S+tmhFn8bv1U=;
  b=gAqcGsHN1VZOE5TGwhTCTijEDig0mmtLoNG0IlN7F5bqcZxtfmz14J2/
   YRGySso7RzmyYtyJMlIoU5WaK7KUP41uc2qKYUdI0NPKi0e7eMys004hr
   VngwEiNdFYxbzYp3PegNSTX0wcy0I1LKONkz4+YLdwD/WBZxlMRHsSL3b
   vhey3MgRfn7cZccuYqO7AgUUSATE/fczBgLkCXEGxwXJabfErodLw7Oz1
   Ow04h9CfhptfZLaRH288c7JGtB/vvSEbMhymBDz5ttLoSfz/VF5HPrj1w
   5MSD4qKoygUpFEQikk8Qbxmq9Vtn5U84n8ZHQUUwEvduxgnioaNIBuIXJ
   w==;
X-CSE-ConnectionGUID: ysfn5CpFShGp5DWOVuOKrg==
X-CSE-MsgGUID: 2S5iTKcaQ3ee0+Xtzet0gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="96111895"
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="96111895"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 20:27:01 -0700
X-CSE-ConnectionGUID: PCMA6x7IQm2Xg9DcXQBatA==
X-CSE-MsgGUID: 7oZB5GQPQj6AxWUfKMcmfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,213,1770624000"; 
   d="scan'208";a="240182795"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 02 May 2026 20:26:57 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJNTq-0000000025f-24MX;
	Sun, 03 May 2026 03:26:54 +0000
Date: Sun, 3 May 2026 11:26:10 +0800
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
Cc: oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>
Subject: Re: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via
 call_srcu()
Message-ID: <202605031109.uxckW5L3-lkp@intel.com>
References: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C8C6C0002
X-Stat-Signature: wg4zmxduhoekbes7otto3ftof3tp4oqs
X-HE-Tag: 1777778823-802815
X-HE-Meta: U2FsdGVkX18Eo9Y23MGG56IvbwlVCHTFcjTtQCaVYL5nsfnksOC3zkNB+WKKmQSF1ExnoIH1wm1ACWl8FzbsRbYwHyaAc4w6krxe5VBZhW3m5o7++abZIOVSruZCTlICh8gQ7sOn2PghVYi9BLjr6B62Hc9cqLP7xk04M8xpdMZs8Snq2e9JUSoVX//M9UquylsrZB3nwQBC51neFltr4znxdI+AqTDAyuCooiQvnJ2BSmO8o0z3fDMjtPc86jF1UmZjt0J/Cbxh4C0e61C6OnlZMSXBfolxwvcXfYCIOdbTbhAmLgTOg6y2ZqImQsjcz1WN1fsIfx+Z29/zRQP0tUoVN6QEgysjvJSdXqh7EDgsVqKnObukMWWQ8phTI3pOFEsL6RUq3Gf1sU2BBINwPCZhY67mkhkOlV/pqrfYdyPh38Jg6Go9SOn3E/iYF80RTrhnuim17Cf1pHaucbIYKCtbP8STGKcbkPEmCwnchdOQeyNvnGgUofh/F/lp0nkSy/tvQRsg9jj5P7eSWmLLwM8Js6gNOInzCxlQjRHCqC8KHdukS/wj2JLaJw54s8WPjKr8iUKJ9uDbmxfc0g6O4KX51iAmoZSYE+tWPMfI01IfnCF70xylLtezM8gf+i9E95gBWISyoj94VsKFZ3H55lrcT2hCypltSyDLZnblng9JO4enpYpf0kEl6HQ4JX1saxI+QMLgrD51poqHLD7eQ/FEeTFv8x1LYWzNWpb28RlU/kSDi7iIyjT+X37gYwFM8Lv/z/7/u0Ib0FVb+ddvHxcnWR4rcchwTH1CvhwPWOuqn2Ue4it7VGq4XSfJtoZNeRTOqEm3tLJJYX92Ah42Daz1UnZeJy8KXYzABmYxhjnBwEDRO42HYQR7CyO5WBxpH8aWeHSZ8ne+Ep+FKi4Ivy1TJIKs6YEsf5ldJE4kFjZXPqdDdsAmdhRJ2zF3CtP9eCZXljr/sLpTWR2Autv
 2VWE1AVR
 zZoNPbFsCpjCO2mjD/4Ulf7HvVWte2RtT5qAsVgrehkdk2ms6lxp8Fh1dqTwf3Ghj/DZCIN3dDcR5h/PORjfW0SUyy/DQ5Tiu5gPfa21KvMVfyEVanhbOoUAa0ALf5EOgWiFET0a3MzBzSRuT4gb9APgVPg9xsEqSiQA/FZR6a4Zb+9lECFioOEUDWMIdIYLvD9XY8+1sdlwD/XfUBo4VJm4IHBILUSbaHf4o8whiEZKidXBVvwnvSmtgi+lf1UEZGKaaH3nnf3PRtTddaSa01GLgcpyDSpeCy43UIJsZcBli6ERVkratRb2aN4yVJyVL7feaDibpa0oy0KRB/vzTsbj2wXTW1MrPz+v7iZ4yXvx1tBdIQRnQSeXZt3RRUTv2gAePGch1eEfz0AJ3iquFmkTNVMgjPLVYLddgJA29vWKH2/FUEphc5g6LaukUF9YRHOn+yOBhkWdrtxb6udLeF5KufQPdzmiP4lxJ/Lwwcg8GmZnPtPwUEYQKHO9mOsauQgcIKF2ACjfOeIs=
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
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20260503/202605031109.uxckW5L3-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260503/202605031109.uxckW5L3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605031109.uxckW5L3-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/oom_kill.c: In function '__oom_reap_task_mm':
>> mm/oom_kill.c:523:9: error: implicit declaration of function 'mmu_notifier_oom_enter'; did you mean 'mmu_notifier_release'? [-Wimplicit-function-declaration]
     523 |         mmu_notifier_oom_enter(mm);
         |         ^~~~~~~~~~~~~~~~~~~~~~
         |         mmu_notifier_release


vim +523 mm/oom_kill.c

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

