Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32BCCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 17:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9C78E0002; Wed, 10 Sep 2025 13:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A0D8E0001; Wed, 10 Sep 2025 13:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79738E0002; Wed, 10 Sep 2025 13:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3FE68E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:29:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54DB41180E1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:29:12 +0000 (UTC)
X-FDA: 83874026544.28.527F183
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7EA342000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:29:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i9vEifFT;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757525350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXWKe1w6lDmVOAxo2bDh999s1RPdxhTm5trGZqZDIUo=;
	b=cbu/L9jio0p9dUNh6vDrr6hUl9rYU+pNkd/dT6I+CzWS+bcgQGkvcLcv2xGHzKGvmDDU6s
	kP0f++8CP6xjfeChshRUvU+U/IVOb0DyW6yba/h0BTGHV3ck54lB8cKjyA6i0sE7QfjEhC
	zWktVB3jYosdkvWBkQb38X8t5UBKvLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757525350; a=rsa-sha256;
	cv=none;
	b=s88iRSmKQ+q3Sgyz0/H6KQvOIiI7rNOSI6UpNk1Dd7E7A+NMX1fITF6C5UymsO2tmPYAxp
	QVDFZR6wHDakXuqWl/87L4J3BKwZXquXsDcqRhn/bmBzawTH1RozlwylUQHse8Io38ayOA
	bFrQX4cW65Nqu3q2eyqR9GpgriCN7Ag=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i9vEifFT;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757525350; x=1789061350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lnqyI9f64I1yhXVL6nN7wKwIlUzM9Wz76sbGLU0tYUk=;
  b=i9vEifFTTjlIkXheijcHg57yvNX21oGGFeyJP3OlCIHXKLiAI162ALGg
   31f3cRSwsmDB14+gM0bKMP3I9MmeZ7tu6KftkNwcBUeDmTvoMDqqp0ev3
   NpGfHQtCCh/p0nQYy8wzSGZjKupjhYWA8Rj2nkfAJlOi63D8BRN03gNvN
   olQCSoFE1cvoU/lpS908djZSeC1hcmkKgG3nG/on6Xtde6z/lkuSgle3k
   SpJa39AWqLmkn5EB6kO1+t+LuAfW/o+XuSgI6jMaFYe4XcccWNimNiaD9
   IsjVZmjj4Ar1euJcpRqfRK49AUnHZ9i0i/9xiWMgydmmLN1QhpfzMKoVi
   A==;
X-CSE-ConnectionGUID: PAMw7MiBSIeAz0QqR6j64A==
X-CSE-MsgGUID: qNf/9OXjT1mYXHFBmHJM0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="58886900"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="58886900"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:29:08 -0700
X-CSE-ConnectionGUID: 4mWWF5aTSDe+1XoKr5D04w==
X-CSE-MsgGUID: ltXG1s5yRRe/xWJO8Hq3Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="173826211"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 Sep 2025 10:28:42 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwOca-0006Al-0G;
	Wed, 10 Sep 2025 17:28:40 +0000
Date: Thu, 11 Sep 2025 01:27:44 +0800
From: kernel test robot <lkp@intel.com>
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	hannes@cmpxchg.org, usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com, willy@infradead.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net,
	21cnbao@gmail.com, shakeel.butt@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Lance Yang <ioworker0@gmail.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Message-ID: <202509110109.PSgSHb31-lkp@intel.com>
References: <20250910024447.64788-2-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910024447.64788-2-laoar.shao@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EA342000E
X-Stat-Signature: d9dygftd1b7jqd46hubgjxnkisf36bpr
X-Rspam-User: 
X-HE-Tag: 1757525349-694019
X-HE-Meta: U2FsdGVkX19xq9jC4MNaRubeqa9j63Kx6zNXOpkhdByoPRyfNzvOMNMmn93rR3jwLTSJiduXYpyFE/7jmhF+7GkrvgAeY3JIhNKHbnxggAmJzXkgPYVBBqnr/UGcBHK1aFw59w6DBFB7aCM/EbHjGXDFLIfHp3iqvkybwQs5Qi90iC3H4TzUqT73aTMayvYVZJ2zib98Xq+pFH1XeQQZ4DZASmpsj0Ve+7US4PfINDbwpCpSStc6U3LJSwGsDVkTUD72Wu4el3uOgqIW4McIwoq8kMecY4IlpBSulceIJQx5NeAxQfr2u3UNy0WZuGCoMLu9hdT/WC7jAsx9rkova5bEC0RRNSj8aktiAZrgURqorbe0fsNV9RONSENpHDlau7Ot5D0xWFITZ6VmzLju9lXiCExM6pRuxaPZbg9JBCCw4H8oSltj9kWqbrg7CL7IhtcUaE8gO8VEmUyrvJfrDwAxzJuYIL0LZHJyH6sQmY76Uhx83JaHEUzWEbpYU9CHl7C8HkFu2d6+qNKEqr5lEEU9+qje/ExTXpjjwsMd0eiyomgWD7MklLkypNWkbI+icnXqoh9+tn9J27zF0ahtmQ6F3c/OUVweOV7mgDvWwrJCS2y/EPZHgRydJRJ0057j6dWGd7wx2o/18ousOAtQ697QgftDu/Be0e0WOvq4gjF9q+szKuEqX41O046H0jUup01QPL41KzIt+pYEZt28wbJIrwNO/cw5Ne3Sc4c75pps/GNyBBWufN0Y0Z6iTVWiOrykrrHgaJbO44tqdxQg/QS54QUZJd6DVk0F1F8qwVLxgvcNmT8kXlrdneze9+gkxJB7IjCMlskhRAXwIJVFqvkaGUPzMfbKCPbC1ftma/G8H34VO53LJZmigV94y7Ii8Y2zZSiEQ8QTaJ06yBX4IzjU6F8N4cWm2C583szRqRASbS6Gw+hRYnI4WxoNDWTVTOQHwVF+IhtlM3LsZ8S
 0g6sUQE1
 hMsoHbA/qb7KNbawylmxngjNj+L7iu8RNCVRyJtkCWAWDoVVFmsbLZXfMOpaBycMe1QsNO8UVTAQpmIe8HDcP1flhjMQtVyaxEjG6mmwJRWoGJlY3n2qMdMOJ27/6EIwmIR337lFe7YdnCK6lvlUSS9mKhqsGJdMzEiWhjM4kSGULUfOt4JSnWLslUD2YXfWk52KI113DuBYXxkrGzMXNOBYT7wSE08gKI0Im7HSAtTig/i1t9ylHwsmqV+3BrfeSvt2OFbKzwt9MtrRg5t4J+DAN/dmR3mcNdJtdNhmO5aWklcHYKS44vRLp57+px2e0JlWlvW3q1rgeOiDfUGWuVEaypI+lWBnSax2jCIj/0i8fpv+Ik8e/lvRCIhtjhwBoBJOE2QmmyeNQHM0Io9s/76pj3UEsnT1BkSJ5tDz3J04JLWKDUGhjW+UmQlFzRs26nYWN3K6sR1FJ0q31U8tGRifkwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yafang,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.shao%40gmail.com
patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pmd_enabled'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2500 |             hugepage_pmd_enabled())
         |             ^
>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepaged_enter'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2501 |                 __khugepaged_enter(mm);
         |                 ^
   2 errors generated.


vim +/hugepage_pmd_enabled +2500 kernel/sys.c

  2471	
  2472	static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
  2473					 unsigned long arg4, unsigned long arg5)
  2474	{
  2475		struct mm_struct *mm = current->mm;
  2476	
  2477		if (arg4 || arg5)
  2478			return -EINVAL;
  2479	
  2480		/* Flags are only allowed when disabling. */
  2481		if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
  2482			return -EINVAL;
  2483		if (mmap_write_lock_killable(current->mm))
  2484			return -EINTR;
  2485		if (thp_disable) {
  2486			if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
  2487				mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
  2488				mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
  2489			} else {
  2490				mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
  2491				mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
  2492			}
  2493		} else {
  2494			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
  2495			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
  2496		}
  2497	
  2498		if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
  2499		    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> 2500		    hugepage_pmd_enabled())
> 2501			__khugepaged_enter(mm);
  2502		mmap_write_unlock(current->mm);
  2503		return 0;
  2504	}
  2505	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

