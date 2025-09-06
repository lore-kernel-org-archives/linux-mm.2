Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84196CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 13:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F878E0005; Sat,  6 Sep 2025 09:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0648E0002; Sat,  6 Sep 2025 09:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF7B8E0005; Sat,  6 Sep 2025 09:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62F958E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 09:31:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14240BA0A8
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:31:53 +0000 (UTC)
X-FDA: 83858913306.18.F0EEACD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD923A0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:31:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iMDMidZH;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757165510; a=rsa-sha256;
	cv=none;
	b=7+nmL2bnh4VK4puCJXJxZBtDhY9WUXE0JAyvd23w5+LN1VZfB6sSSFobb1shmSMSU9WZWB
	CoBTGI1rHf08n8zVingg0QyGzPpumZ9efOjo1Zw7pJtPbQy8rW54yO9paDDzGiAP+Qyw9R
	jobJB4jS77Swj60No83fhJiSnkwsZT0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iMDMidZH;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757165510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMkZCa/hy8bOzXYR02+KaIahsI+L7xsosuNCL6m1+aM=;
	b=GU2D72nA3QFlvZls3dp+LoZCU4M2jfLeQ8EJ3uwksxPl54cKyqsh1l0QRmFspXro34/DJW
	Z9RR3iN4+OH+7T3IfoYHnsWTApOhAtICQh1AW4jwqkzwKC6HpcM87s6e7cneziCpBTfIoE
	Yar8LOLa49p2j4YlUW/N8N68HTiMsmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757165510; x=1788701510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JxpVAPprCj1/cOsB/r2kwrJ/LKeJT1ayD6hStYXR2fA=;
  b=iMDMidZH4jVxRRXI8f2cxdZBTWzuceoa+pGUz4J/EkKfeBnN8MIm/O+g
   J1r8eEh9lJxWy1RzYp370jOHx39yt2cLwjwt/W35T3zgp5ZdQC+NPD6Vs
   4zj+IcgehUUoTeiU0MY2GDNVRqmjCWwgS4B6VPjFgRJteYcCokQITHYVx
   nL39gGJD+5t7B/7DVXEMtRWuGyZzFKypDePXE3hHGFXSBj7U0FusYVkQT
   +Cf7tGGCYrMkkKUVoMQdEfS7ZPgxtrBfyyLHHuxCR+ObySeA+ru0Rdt6f
   sIfdLweV4BaxEL/hpzCVImwclBO1IAgx/0uElAtR2o24GuBKQe60QDkQn
   Q==;
X-CSE-ConnectionGUID: /lt5Mhb4SPauH4bFniV+RA==
X-CSE-MsgGUID: NMCtU9IBTzGUN6IuBDDO8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="82083303"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="82083303"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2025 06:31:48 -0700
X-CSE-ConnectionGUID: 3JrKiGFBTfW5BencZrBXMw==
X-CSE-MsgGUID: 9JDGkvDmT02J1DrNzFJAng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,244,1751266800"; 
   d="scan'208";a="176730549"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 06 Sep 2025 06:31:42 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uut12-0001VP-0c;
	Sat, 06 Sep 2025 13:31:40 +0000
Date: Sat, 6 Sep 2025 21:31:09 +0800
From: kernel test robot <lkp@intel.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@redhat.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v9 2/5] mm: uffd_wp: Add pte_uffd_wp_available()
Message-ID: <202509062145.1ipU0q7y-lkp@intel.com>
References: <20250905103651.489197-3-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905103651.489197-3-zhangchunyan@iscas.ac.cn>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AD923A0006
X-Stat-Signature: fc4r5o91rtpwdftfibcp8qqip7xhdr53
X-Rspam-User: 
X-HE-Tag: 1757165509-192883
X-HE-Meta: U2FsdGVkX1/QdJWetuAQqfLQXkBhpdEojE3KonV1iTltxi4784ckAJoGQq3tP9M9T7jqH3ukUbIClH83Zp1OQgpCEjYp9FZGv24F9CSUazB83ewvqpkMniEa18L2I4BKmL70ID3fbW1Sp5SI4kOMxwq+9AY6CMpDrFP4eHJcRJbfDzmxCBpoCWxaA0TjEnKYa/IKSjiBAcNdqhaati9Qee5H/1xQJ6dXoDY5+aawUbE8YAJw2QJ6AuLwu7QvYakfpMrqxqgbXTWED2lMwm9G99siMvVvBb3jpfH/e27jOpGJqv4XLfHag8W7GhYA15707FBiyAatLh9eOyD5LWKiqwhvri3dMxPR7FrJy5EqwLVJacW0r/8bxB9Tu3YN1DbEAirPk7gCoB/xnCLWPz23qzlz4NmlssIxR/yf8sFQrjOJQm9KgAyuN0SZ5xeS78sKbyl9FvYILZCNaqI16LiZ574PEP75d8SWwRNHGNRlJzbLRwgmz4hXJkqkU4Dp53ddw6wuJbu2Y+XArsO2RRAORHepWitFalEab7Nx+jCj06nNULlPaqPeK6kZQyPcDtoXboR7ct9c0T5dlJRlRCJIjPxcsYNZRcWJ8NuQzkTgJGVdGx9hSo2ciSQon+EpM7MFwtDiPWp50A6XcrIKqjyoNpfsvImgitSqhhbC4X+9m3Ksn5Sg8xlHvmhMYvzcu0L/JRTA7FyJ/kB7LW+xuQlnxcXCP7q+dQlA+nJJWdkNnlVmxV5cb5P+/dDFFD4c9GD3hLnaFmjhhxHVoQDKtei5nzO+FAvOuLzICQz4/IZWFnNx7ZUPIiPti2X+CEpcQjvupnGqejo+0/crNBtiWSyXGTUBHZFLPuOog9boU4mlPEwviVsZ70MFbZJZdM6huOAJ4aoDk7RGwoC9V6UAiPSe2QcfbKH8T3yDCPSKmkpiCr2oXBL9rcOP6NijXvAJ5WKkHsb8T+J4Aox84aHW98F
 DExz0FO/
 Hc0mnakFssbbicGBbMt1A7ln7qPAHC9CiZzvESZ9G68VAuFGriYwNuJCTRi8Hta1kvgRWQ+fN9l68nkdu5HdHR51XUrBozW1cM4BdjRWWxXhTpyRvf5zkB46prFp7grABvPZodW3k6KXLkDopJgTS+djjCat5vsrS3efA30KFWZWYOTetUmhvu5Tg2H+LK3gxBL6EbFoyU5+t5OU8/IRMthCCRPLlHVlrhRPEDGMlWLa1yHSh6yhyGjUCDjsv8fDGkAOkrDtFwWLRoXC1joCSmdU37Z98tlyamDrzkD0CW3Kq7S8jAGkMNZLe8yifrjZnKEgroCDcGLHYXz2wrSEY7MULzZu0zlcFlrIgpxs+hfa+Ge0dJPYxTiLKz9CH2PCv+2utJ3X0ezevZNMzIo8hjyAPtuP76QzG+Fh3v0D5ZoQFuYGxjWofGTNuBvumingLAobNnjJOulONl5KxkjCl/Qm96WZ+TKCSdbhakG0eUOzgP7ePZNx72LXGCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chunyan,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.17-rc4]
[cannot apply to akpm-mm/mm-everything arnd-asm-generic/master next-20250905]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chunyan-Zhang/mm-softdirty-Add-pte_soft_dirty_available/20250905-184138
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250905103651.489197-3-zhangchunyan%40iscas.ac.cn
patch subject: [PATCH v9 2/5] mm: uffd_wp: Add pte_uffd_wp_available()
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20250906/202509062145.1ipU0q7y-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250906/202509062145.1ipU0q7y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509062145.1ipU0q7y-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/../mm/internal.h:13,
                    from fs/exec.c:82:
   include/linux/mm_inline.h: In function 'pte_install_uffd_wp_if_needed':
>> include/linux/mm_inline.h:573:56: error: implicit declaration of function 'pte_uffd_wp_available'; did you mean 'pte_soft_dirty_available'? [-Wimplicit-function-declaration]
     573 |         if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pte_uffd_wp_available())
         |                                                        ^~~~~~~~~~~~~~~~~~~~~
         |                                                        pte_soft_dirty_available
   In file included from include/asm-generic/bug.h:7,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/m68k/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:79,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/slab.h:16,
                    from fs/exec.c:27:
>> include/linux/mm_inline.h:579:23: error: implicit declaration of function 'pte_none'; did you mean 'p4d_none'? [-Wimplicit-function-declaration]
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |                       ^~~~~~~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mm_inline.h:579:9: note: in expansion of macro 'WARN_ON_ONCE'
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |         ^~~~~~~~~~~~
>> include/linux/mm_inline.h:579:32: error: implicit declaration of function 'ptep_get' [-Wimplicit-function-declaration]
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |                                ^~~~~~~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mm_inline.h:579:9: note: in expansion of macro 'WARN_ON_ONCE'
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |         ^~~~~~~~~~~~
   In file included from include/linux/file.h:9,
                    from include/linux/kernel_read_file.h:5,
                    from fs/exec.c:26:
>> include/linux/mm_inline.h:591:22: error: implicit declaration of function 'pte_present'; did you mean 'p4d_present'? [-Wimplicit-function-declaration]
     591 |         if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
         |                      ^~~~~~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
>> include/linux/mm_inline.h:591:45: error: implicit declaration of function 'pte_uffd_wp' [-Wimplicit-function-declaration]
     591 |         if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
         |                                             ^~~~~~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
>> include/linux/mm_inline.h:602:17: error: implicit declaration of function 'set_pte_at'; did you mean 'user_path_at'? [-Wimplicit-function-declaration]
     602 |                 set_pte_at(vma->vm_mm, addr, pte,
         |                 ^~~~~~~~~~
         |                 user_path_at
>> include/linux/mm_inline.h:603:28: error: implicit declaration of function 'make_pte_marker' [-Wimplicit-function-declaration]
     603 |                            make_pte_marker(PTE_MARKER_UFFD_WP));
         |                            ^~~~~~~~~~~~~~~
>> include/linux/mm_inline.h:603:44: error: 'PTE_MARKER_UFFD_WP' undeclared (first use in this function)
     603 |                            make_pte_marker(PTE_MARKER_UFFD_WP));
         |                                            ^~~~~~~~~~~~~~~~~~
   include/linux/mm_inline.h:603:44: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from fs/splice.c:27:
   include/linux/mm_inline.h: In function 'pte_install_uffd_wp_if_needed':
>> include/linux/mm_inline.h:573:56: error: implicit declaration of function 'pte_uffd_wp_available'; did you mean 'pte_soft_dirty_available'? [-Wimplicit-function-declaration]
     573 |         if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pte_uffd_wp_available())
         |                                                        ^~~~~~~~~~~~~~~~~~~~~
         |                                                        pte_soft_dirty_available
   In file included from include/asm-generic/bug.h:7,
                    from arch/m68k/include/asm/bug.h:32,
                    from include/linux/bug.h:5,
                    from include/linux/vfsdebug.h:5,
                    from include/linux/fs.h:5,
                    from include/linux/highmem.h:5,
                    from include/linux/bvec.h:10,
                    from fs/splice.c:21:
>> include/linux/mm_inline.h:579:23: error: implicit declaration of function 'pte_none'; did you mean 'p4d_none'? [-Wimplicit-function-declaration]
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |                       ^~~~~~~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mm_inline.h:579:9: note: in expansion of macro 'WARN_ON_ONCE'
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |         ^~~~~~~~~~~~
>> include/linux/mm_inline.h:579:32: error: implicit declaration of function 'ptep_get' [-Wimplicit-function-declaration]
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |                                ^~~~~~~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mm_inline.h:579:9: note: in expansion of macro 'WARN_ON_ONCE'
     579 |         WARN_ON_ONCE(!pte_none(ptep_get(pte)));
         |         ^~~~~~~~~~~~
   In file included from include/asm-generic/bug.h:5:
>> include/linux/mm_inline.h:591:22: error: implicit declaration of function 'pte_present'; did you mean 'p4d_present'? [-Wimplicit-function-declaration]
     591 |         if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
         |                      ^~~~~~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
>> include/linux/mm_inline.h:591:45: error: implicit declaration of function 'pte_uffd_wp' [-Wimplicit-function-declaration]
     591 |         if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
         |                                             ^~~~~~~~~~~
   include/linux/compiler.h:77:45: note: in definition of macro 'unlikely'
      77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
         |                                             ^
   include/linux/mm_inline.h:602:17: error: implicit declaration of function 'set_pte_at' [-Wimplicit-function-declaration]
     602 |                 set_pte_at(vma->vm_mm, addr, pte,
         |                 ^~~~~~~~~~
>> include/linux/mm_inline.h:603:28: error: implicit declaration of function 'make_pte_marker' [-Wimplicit-function-declaration]
     603 |                            make_pte_marker(PTE_MARKER_UFFD_WP));
         |                            ^~~~~~~~~~~~~~~
>> include/linux/mm_inline.h:603:44: error: 'PTE_MARKER_UFFD_WP' undeclared (first use in this function)
     603 |                            make_pte_marker(PTE_MARKER_UFFD_WP));
         |                                            ^~~~~~~~~~~~~~~~~~
   include/linux/mm_inline.h:603:44: note: each undeclared identifier is reported only once for each function it appears in


vim +573 include/linux/mm_inline.h

   556	
   557	/*
   558	 * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
   559	 * replace a none pte.  NOTE!  This should only be called when *pte is already
   560	 * cleared so we will never accidentally replace something valuable.  Meanwhile
   561	 * none pte also means we are not demoting the pte so tlb flushed is not needed.
   562	 * E.g., when pte cleared the caller should have taken care of the tlb flush.
   563	 *
   564	 * Must be called with pgtable lock held so that no thread will see the none
   565	 * pte, and if they see it, they'll fault and serialize at the pgtable lock.
   566	 *
   567	 * Returns true if an uffd-wp pte was installed, false otherwise.
   568	 */
   569	static inline bool
   570	pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
   571				      pte_t *pte, pte_t pteval)
   572	{
 > 573		if (!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) || !pte_uffd_wp_available())
   574			return false;
   575	
   576		bool arm_uffd_pte = false;
   577	
   578		/* The current status of the pte should be "cleared" before calling */
 > 579		WARN_ON_ONCE(!pte_none(ptep_get(pte)));
   580	
   581		/*
   582		 * NOTE: userfaultfd_wp_unpopulated() doesn't need this whole
   583		 * thing, because when zapping either it means it's dropping the
   584		 * page, or in TTU where the present pte will be quickly replaced
   585		 * with a swap pte.  There's no way of leaking the bit.
   586		 */
   587		if (vma_is_anonymous(vma) || !userfaultfd_wp(vma))
   588			return false;
   589	
   590		/* A uffd-wp wr-protected normal pte */
 > 591		if (unlikely(pte_present(pteval) && pte_uffd_wp(pteval)))
   592			arm_uffd_pte = true;
   593	
   594		/*
   595		 * A uffd-wp wr-protected swap pte.  Note: this should even cover an
   596		 * existing pte marker with uffd-wp bit set.
   597		 */
   598		if (unlikely(pte_swp_uffd_wp_any(pteval)))
   599			arm_uffd_pte = true;
   600	
   601		if (unlikely(arm_uffd_pte)) {
 > 602			set_pte_at(vma->vm_mm, addr, pte,
 > 603				   make_pte_marker(PTE_MARKER_UFFD_WP));
   604			return true;
   605		}
   606	
   607		return false;
   608	}
   609	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

