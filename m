Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E74C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 00:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571276B007B; Fri, 24 Jul 2026 20:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521B16B0088; Fri, 24 Jul 2026 20:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437536B008A; Fri, 24 Jul 2026 20:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 143E46B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 20:58:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89AE31A023F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:58:05 +0000 (UTC)
X-FDA: 85025487330.13.BA35C06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF87840004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:58:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kBYs7bZF;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784941083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=D3cCY8vYvI98ztYBy6jPpL4C9FECBY+REAs150M6C2s=;
	b=B2nxf2GZ7fP/0EMwxN+culcbBRP7o9F6X+e1BL9tevi/T7yKkuW5/LN1qb+4urJMH9SXYV
	wjzgCPU1v0qtwyiX506MbU+tPlQRvWEiniuKI74K/lhDhvEAhm0U7yFLYtzXoiaqNfPxw9
	oaoS8a+8SMTe7XwJ8/eqoO4uTwgY7Ds=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kBYs7bZF;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784941083;
	b=dBsqMPwnkeFImp6RZBi5hkNZFjdx5zLMThD3s0XqKhbznfViVCkI39KJ1VyM/lwFlhgMwE
	zYuOAOFECXchBSDKFNnvxfy8HrTnDeteVYhctnPkQ5vCAR0WKNQ6P5yby++e6sbJyYr9ko
	aGkUEhqjzLYKsCpQ+hh7H0ocO6b4hL0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784941083; x=1816477083;
  h=date:from:to:cc:subject:message-id;
  bh=OAC6lBYbl8VKrUKfiQCex2CU2yUl/JiNEBgpQiMRODM=;
  b=kBYs7bZFbLyyfWY94rheQ6sllpTg0XoTswPEP+P91dkOGPRP7lG6GiP0
   13tdOdmiYY3NWaR70zqTjvhiODvUeGW0GjwW2iHZ6wxMeyGLjNFVDafk+
   tdhPGDgAviZo5k0wHw4+1vymfp6pQY/h84LsuD5njiZtTIoHND6CV2Tjy
   qGztgDrzqmL3BET9n2WA+63Jtg5uioL/Rac5qoZMYYAixrSJhevQWcpOx
   AAzz+D2wgLU7FQfWQL07ptxRkW1aR4vVMI8jcUq5DJhJuR6f73WM8QoWx
   0Hun/zSLcv9ZIvb8sE05FI0Dw76pK/zMrWpiujc46jHfNvuPMbI7tqCR9
   g==;
X-CSE-ConnectionGUID: dq28lrsEQlqSGRtnY6ecow==
X-CSE-MsgGUID: EkRaTL3tSGSn4wnArHgQzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="96984156"
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="96984156"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 17:58:00 -0700
X-CSE-ConnectionGUID: WWJvxTpxS3yqv0N+7GfukQ==
X-CSE-MsgGUID: HVpGNqwLR3q7V+kGTWL2/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="263850546"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 24 Jul 2026 17:57:58 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnQiB-00000000bNy-2WA9;
	Sat, 25 Jul 2026 00:57:55 +0000
Date: Sat, 25 Jul 2026 08:56:41 +0800
From: kernel test robot <lkp@intel.com>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 340/601]
 include/linux/compiler_types.h:702:38: error: call to
 '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
Message-ID: <202607250853.VaJWGLeA-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: BF87840004
X-Rspamd-Server: rspam01
X-Stat-Signature: uom3phfm1cidut7nhtidu4tyccc3zc8s
X-HE-Tag: 1784941082-516625
X-HE-Meta: U2FsdGVkX1+1pr/p3IoDYgQZf2WIVu5N4dIAlAr1HYsNxTnJ84coZ+4jGmDfwgMZlWqM3ZKjDswcj2NfTm7I+UFoS3VqEWnYsN9sItSjNUFDzWMwkvydshEdPo+cU9lebfv+H2JctQ3hLT/80VuGITKlGQlL0qjRWfQZQoA1Vk3sY3SI348qoEU9kn3hjiGoysrL2pVzyHdxbouWchcvKka7QlF9dkh01AiNE4i0BVVR6en2PXU9IWkWSMxJ37R6Jgl9A5M4HhhbAyocGSvE9hwkeEs9yCUA+b89Gi0JN6il8nAR1CxhHrYQYkzNu9/HHm/dKO2YxXYGdYeLr8XpQCYkDTe9Pw1k9Crl/p3YVYx1OsVESP09/FLZZLzTdBu8TcxYSqHAaUSk7C3hVS0voOCyB7fxF9M6OH+0mk2LbmtxpqEeItqFyGiUB9hhknXWocCT7CwUQh/mo56Fe6CgBVL9S38fbipX/xSnJHerErYKAKpFeFVVqcoebOsDDkZn3FhvHaPdMUV5r3M7OnSF7/zngJV2kEUK8EzQdXQGp8l2iAlqSFccyaBetQH+6oULeLfydURNZs55QWRlETc748NmhTqLvkG+QjqoI1mH4rPKN096w90aF/R+QQUZ9o0V7waMmSwKvOqs4nmF3lX6SyHwvCrzhBpkgT4fuwTV4kbNbRpvcCIwsPgWTSgxD46V7BZj2i/5ciAYAcrDw7XyQkouCOj2cePHHYdDsYnFt6Y8ZsdtJBh8OFXZeloM8muNEsjpYLT+Rf9kneQ/6m32ApF1AqoPa/7UpjItjqmjKrjA7ToYR9pnM0TWuqsrO4qPWwyfCC1nxCvbPqsk+Ioe3wK6W+XOlorSDLiAJuI/tkpXyxldz8ObnmMu08racHNPlEBLdZfu18a0UKxFJc27y2Bi47kJjlmlWXpj9jZKpZWyqGigm0Sl9EwbGqNNpsMo/LIhzcFLlyKmmdlza+K
 KmMZj+R/
 e6mn9VbPz6nqT5AZN9fE3k+xXg4uXrX9UA8a43cwV+P+VUwbqetiKO4Kt75a34FgGzGax2TNn2U+13/rRyLzURYmVbnWLQA6XcHfo7ObCT0s0VshgaZTiyWosySsSCvhy7kBrW5ygXBV5rlOhXr+hLky4zhLR5tc2MajwM38dHecGi0aNXw/LBuZmaPRuT4L65fbnQMGirrWY8F77a0IRDNZqiO8Q6earmRgo4wnCyPSdrYhCP2ujCYHxG4yC05L2LEi0EcQ6bz1X4fy1g/qCO4AvxIpjEKlNF6SRZyBNhy2J5DtvBrM1iEE06strhdcLkJgKlUhHC50zsKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   c04df384b55dd9dcf72c36b661becb5aaba371a9
commit: d2aed7c02fafacb9d055a2f683ac12e977ef16e0 [340/601] mm: preserve RWP marker across PTE rewrites
config: sparc64-randconfig-r134-20260725 (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250853.VaJWGLeA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607250853.VaJWGLeA-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/huge_memory.c: In function 'move_pages_huge_pmd':
>> include/linux/compiler_types.h:702:38: error: call to '__compiletime_assert_501' declared with attribute error: BUILD_BUG failed
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:683:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:702:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:60:21: note: in expansion of macro 'BUILD_BUG_ON_MSG'
    #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
                        ^~~~~~~~~~~~~~~~
   include/linux/pgtable.h:2145:22: note: in expansion of macro 'BUILD_BUG'
    #define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
                         ^~~~~~~~~
   mm/huge_memory.c:2874:35: note: in expansion of macro 'PAGE_NONE'
      _dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
                                      ^~~~~~~~~


vim +/__compiletime_assert_501 +702 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  688  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  689  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  690  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  691  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  692  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  693   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  694   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  695   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  696   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  697   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  698   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  699   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  700   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  701  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @702  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  703  

:::::: The code at line 702 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

