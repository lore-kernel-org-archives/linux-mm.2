Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A047C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88256B0092; Tue, 29 Jul 2025 22:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B381C6B0093; Tue, 29 Jul 2025 22:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A746C6B0095; Tue, 29 Jul 2025 22:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98E696B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:02:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BC1B5840F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:02:53 +0000 (UTC)
X-FDA: 83719282626.03.9DD5BC9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10C0F20002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:02:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f+TtzDBX;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pClM01K1NV42abCZuWF9Aso7qHQ0uT4E8Plu8UGKdbg=;
	b=LsSkGuYytteJ3/ZamUkTy69qJ1N1wBbVCNG7F0Fpfal5rzbYdHk2eeUVnHB9Lz6tBqxvxX
	jhue1A/eYr564Ur3RIQcHnYMyNz4v/CFYet/dEo5olEHkVzDjdkLWb1ykBMeI7MYVkFAv+
	Q8NUfqLbxYGJmSJ0zCJqHE7ll5cXuNo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=f+TtzDBX;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840971; a=rsa-sha256;
	cv=none;
	b=mR+6GosrscPwH0Y6j+gHz8YqVjlpopZVXhbD8hejBBscwS0SSRvEH86Eo1o6GPLEPZPK3F
	MT25ryRpMctf6Kfju60CQAkpoCkhKk7oNDQNwQVPMtb91VigcwW4Nfhj5HaqdxNBF9jF5M
	FV7Y+PliZlpt+ZcFbfowz3E1tTEFM3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753840970; x=1785376970;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=E85IkhXBpgXIamGr8PggEgYjw9F7Qq0GsZrvNSgrNG4=;
  b=f+TtzDBXJUgvXnFVNZKbYChTz9zvIylK64pTiNswT0VMfVsqXFemKDTf
   9yOiH6XYpoPNUZ8kt7bLnM326AQM6Ap9l/sCWoFT3FMeOl3f0p6eHw1mH
   dEs2TLQxp8SaDdxNPMpvmig/ZVUElYEXusA3hUAp6bm/MmzKr5xMmGqSb
   PHqbUk2S3kFJbaLeFb/q7yxzCkwWzfkloSuUuRIm0bkGNlwGqkLOiha2N
   4ERUnR3dlCDsWQ2fcT3msyE+23a3LtOiKvODuKI7KLL7CHzDsvUeMRX9y
   J1+NC3euM+e6KnM2XKKK8Cg8364eNyCRXTAauNJrRjToFtRXtVN2vMyGX
   w==;
X-CSE-ConnectionGUID: 76WhZzoVRv26Ub3/NZjlFA==
X-CSE-MsgGUID: SIddZSfjT5SYvmKM5JcgMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="56276525"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56276525"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:02:49 -0700
X-CSE-ConnectionGUID: vV/8I8DwR7y6hzfpdqlVxg==
X-CSE-MsgGUID: D/bzK4w/T5yuR2Bc2xEntw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="193709174"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 29 Jul 2025 19:02:47 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugw9U-0001sJ-36;
	Wed, 30 Jul 2025 02:02:44 +0000
Date: Wed, 30 Jul 2025 10:01:54 +0800
From: kernel test robot <lkp@intel.com>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Alexander Potapenko <glider@google.com>
Subject: mm/kmsan/hooks.c:269:14: sparse: sparse: cast removes address space
 '__user' of expression
Message-ID: <202507300944.NePjNXZ2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 10C0F20002
X-Rspamd-Server: rspam06
X-Stat-Signature: qqo6dgwptna4kow3wee1cd1k7i7676u3
X-HE-Tag: 1753840969-688408
X-HE-Meta: U2FsdGVkX183iVCylYlQCBzhQ5uQsBT7gZK5C0bAXWYHyMBSSGUdeWW5mhnxomQORX5Fm1aeba+EQsXCqhNWnddYdLP9/+qywYcNRTI7RfYaLdVftKEflmUG6gzV+NmY0PRRYClk+ZH7wbLO5bR0YhexNfYZ+bvbzcXdM1C68FJf+FTrGZOSldX0okjCla9K8T5Ob2JKVhQy3LFWss0PybZA4zsQ2tCI9iVu4WN6s4FvEJAzFIcWx7knVyDPPvLtNmFoORN3Mv2nYy6SDH5HJFI8k3umHXQ/wh05N+WhC7tgG8170OpZ4GcXnOy1QkHiSynatfETGIon8302fRxsDhrjEpIujQ39vzeZQ0ML+SiHBl0fvpjrk7l0arNlZvyG9OeLgB4DXpEmqLWbTDQ3jvAo2a5jZW/3AgLYFvwRd5jr5fwWXmTDMDaCE9mdSBsyhtVmfTwp8fMULvuGXOAWKpfjnhgvkjSrFcNfht1GbsazoaerG6IovVNf3tSTCwUIh9RBfj2mB2ckY0LnL/gqokonpZrYaad50lYFFm77HX03pXV/hEDmIdjf01hZHjqAO9EjVXWtY3DnZRTKTMdosiDBJu+35Mqn1NBC/8gPpnVGcWMYRqfSu3fB9N9ai1ulpXgaiB9iqRuxPKf4bxsMTxZ+KF3OMItn8B7BXcPozoqcjOq2pXctgrJ+RyRZ9jW4/80rlPmV17y7RygxEUxxu88Ov7gxrBYpDWU8k1zJLTPOHF0v+wegwUEAZjD6rrHR6U+1OxCdAvri/BuMPPF3I+bMPOHZ7YfqN4EPEiv346CjtI7hswPPWrr8Um0Zm3h2hpvj6uprFPMZAry33ka5pTE8W9SGlljYhTjO6yHO72Uh+jAT6mqEx0qEIMZEheEJ/g9tuVbLjIbz9Xtu7Od/6fUQjVUzJULHU75zoA9Eb2l+PBVD+2v4xkJz61NddwSZKeQKMyRveotXPJwug4Q
 xy8f5NsY
 tgzGAjGXfLVdNNDH/c7307ZDMp2WdoczXliHplLzWUEl63QVNUUimYkhTJ0l0WUJFNc4JONfLFjLT492k/TVHi0CUT7wpQZrNyDdT2ur1wWabGTI1eJjX+HWhl0DTwoD0pNMV2G1brbpkEJCxI11X9IT37GUmqBy8oIwTVncQQkf+3YeUGEd/3ihl5fFQNZxvVqIy3qngdJZzE0rxYXkPfHY9gbpOvbfT5gvT9MXqrsoJMVlk0WFakM2f0KppM2FHh9rTFTF7S2EAeqDgYIM5hE2ZZztKyz6bSJGIW04uN1R91jru4ROJ4BXExjg3kEsZ1kXDrsUc0et/IGJaZ0p20pPS3bj+rNpT1nIbbmcjS/sUUBaGv/+Ax1AnrvCCNyTOffNDLQu+nq9L82gsi4/3RrhyEptVOSwMlCts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   14bed9bc81bae64db98349319f367bfc7dab0afd
commit: 3a8f6f3b469b4075919a3613e182f9a70df92d46 kmsan: enable on s390
date:   1 year, 1 month ago
config: s390-randconfig-r111-20250730 (https://download.01.org/0day-ci/archive/20250730/202507300944.NePjNXZ2-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project bcd0d972247154336dd1321f1fded818e46671d1)
reproduce: (https://download.01.org/0day-ci/archive/20250730/202507300944.NePjNXZ2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507300944.NePjNXZ2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/kmsan/hooks.c:269:14: sparse: sparse: cast removes address space '__user' of expression
   mm/kmsan/hooks.c:271:75: sparse: sparse: incorrect type in argument 3 (different address spaces) @@     expected void const *user_addr @@     got void [noderef] __user *to @@
   mm/kmsan/hooks.c:271:75: sparse:     expected void const *user_addr
   mm/kmsan/hooks.c:271:75: sparse:     got void [noderef] __user *to
   mm/kmsan/hooks.c:280:50: sparse: sparse: cast removes address space '__user' of expression
   mm/kmsan/hooks.c:306:59: sparse: sparse: Using plain integer as NULL pointer
   mm/kmsan/hooks.c:319:79: sparse: sparse: Using plain integer as NULL pointer
   mm/kmsan/hooks.c:325:79: sparse: sparse: Using plain integer as NULL pointer
   mm/kmsan/hooks.c:421:78: sparse: sparse: Using plain integer as NULL pointer

vim +/__user +269 mm/kmsan/hooks.c

b073d7f8aee4eb Alexander Potapenko 2022-09-15  247  
75cf0290271bf6 Alexander Potapenko 2022-09-15  248  void kmsan_copy_to_user(void __user *to, const void *from, size_t to_copy,
75cf0290271bf6 Alexander Potapenko 2022-09-15  249  			size_t left)
75cf0290271bf6 Alexander Potapenko 2022-09-15  250  {
75cf0290271bf6 Alexander Potapenko 2022-09-15  251  	unsigned long ua_flags;
75cf0290271bf6 Alexander Potapenko 2022-09-15  252  
75cf0290271bf6 Alexander Potapenko 2022-09-15  253  	if (!kmsan_enabled || kmsan_in_runtime())
75cf0290271bf6 Alexander Potapenko 2022-09-15  254  		return;
75cf0290271bf6 Alexander Potapenko 2022-09-15  255  	/*
75cf0290271bf6 Alexander Potapenko 2022-09-15  256  	 * At this point we've copied the memory already. It's hard to check it
75cf0290271bf6 Alexander Potapenko 2022-09-15  257  	 * before copying, as the size of actually copied buffer is unknown.
75cf0290271bf6 Alexander Potapenko 2022-09-15  258  	 */
75cf0290271bf6 Alexander Potapenko 2022-09-15  259  
75cf0290271bf6 Alexander Potapenko 2022-09-15  260  	/* copy_to_user() may copy zero bytes. No need to check. */
75cf0290271bf6 Alexander Potapenko 2022-09-15  261  	if (!to_copy)
75cf0290271bf6 Alexander Potapenko 2022-09-15  262  		return;
75cf0290271bf6 Alexander Potapenko 2022-09-15  263  	/* Or maybe copy_to_user() failed to copy anything. */
75cf0290271bf6 Alexander Potapenko 2022-09-15  264  	if (to_copy <= left)
75cf0290271bf6 Alexander Potapenko 2022-09-15  265  		return;
75cf0290271bf6 Alexander Potapenko 2022-09-15  266  
75cf0290271bf6 Alexander Potapenko 2022-09-15  267  	ua_flags = user_access_save();
f926e9326f3a79 Ilya Leoshkevich    2024-06-21  268  	if (!IS_ENABLED(CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE) ||
f926e9326f3a79 Ilya Leoshkevich    2024-06-21 @269  	    (u64)to < TASK_SIZE) {
75cf0290271bf6 Alexander Potapenko 2022-09-15  270  		/* This is a user memory access, check it. */
75cf0290271bf6 Alexander Potapenko 2022-09-15  271  		kmsan_internal_check_memory((void *)from, to_copy - left, to,
75cf0290271bf6 Alexander Potapenko 2022-09-15  272  					    REASON_COPY_TO_USER);
75cf0290271bf6 Alexander Potapenko 2022-09-15  273  	} else {
75cf0290271bf6 Alexander Potapenko 2022-09-15  274  		/* Otherwise this is a kernel memory access. This happens when a
75cf0290271bf6 Alexander Potapenko 2022-09-15  275  		 * compat syscall passes an argument allocated on the kernel
75cf0290271bf6 Alexander Potapenko 2022-09-15  276  		 * stack to a real syscall.
75cf0290271bf6 Alexander Potapenko 2022-09-15  277  		 * Don't check anything, just copy the shadow of the copied
75cf0290271bf6 Alexander Potapenko 2022-09-15  278  		 * bytes.
75cf0290271bf6 Alexander Potapenko 2022-09-15  279  		 */
75cf0290271bf6 Alexander Potapenko 2022-09-15  280  		kmsan_internal_memmove_metadata((void *)to, (void *)from,
75cf0290271bf6 Alexander Potapenko 2022-09-15  281  						to_copy - left);
75cf0290271bf6 Alexander Potapenko 2022-09-15  282  	}
75cf0290271bf6 Alexander Potapenko 2022-09-15  283  	user_access_restore(ua_flags);
75cf0290271bf6 Alexander Potapenko 2022-09-15  284  }
75cf0290271bf6 Alexander Potapenko 2022-09-15  285  EXPORT_SYMBOL(kmsan_copy_to_user);
75cf0290271bf6 Alexander Potapenko 2022-09-15  286  

:::::: The code at line 269 was first introduced by commit
:::::: f926e9326f3a79f7e01ac790e2361f44d8ca8320 kmsan: fix kmsan_copy_to_user() on arches with overlapping address spaces

:::::: TO: Ilya Leoshkevich <iii@linux.ibm.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

