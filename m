Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC086FF5136
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 20:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DB06B0089; Tue,  7 Apr 2026 16:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5556B008A; Tue,  7 Apr 2026 16:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC286B008C; Tue,  7 Apr 2026 16:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E18D6B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:10:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE18A5BA2C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:10:19 +0000 (UTC)
X-FDA: 84632851758.13.62FFF5A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf21.hostedemail.com (Postfix) with ESMTP id 206281C0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:10:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QQXAvPd+;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775592617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9SZoFYkz7LrouamvJCoKOrJYm4KVjniOvk38Taxwb0=;
	b=iBmEJ2Hnpvhrxa3BesMokGs3CZwlDySYDRJyLTCFC/2my2ABaXblKvsAhf8T8/QWbBOxnu
	R2FEn7IW90iMbKmpCpQt/B2EPEU9QvHZ/vUuJWqyOJ16qS/2MUjXPsS1EoBpTzxCWBz69a
	ozybLUtcznVKpXAVTA/PEY5zEWNWRp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775592617; a=rsa-sha256;
	cv=none;
	b=Blt4ZsqoiXPeYWOHkKZ9j0F7izolPmuq9oB7MigPU7PvGAv3zaOFuI1fthUVDlK+ce2mEb
	pHWgAOWpF/pKADxREBOosEF3g7Na5pfdwgJsHCfznZlCA3M6QVLHjS1o77PnPGMgkupa/N
	b7bvp052wss/uiVzfSdOeTqVA1QEQu4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QQXAvPd+;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775592617; x=1807128617;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZlgXUtbGp9j+zCOWe5Ae967XxGrV535xTwvFK6UmZ5M=;
  b=QQXAvPd+cSVUX2Y3CwBF4Lq4dLSam5U33bUB9QtB+CH05n0MCTyWxKC5
   dNRNGgbirdXplaUmKmEJdEe/eTukg/mKhC1l3a/b7vC7weU52D30axviQ
   bwb1iG7LdD0m1KiAEXBo28EuJ2E/bIxPCO4p+ofJAy5oLGb3qlIpBXEze
   wYdWKd9dm4NBGHDniV03FkcwGUnVlTF0uVzsHwdyPGpcXl7cr/G3QR8gc
   wVyaupUWhDIYDtAW/2hWGYBX2jkLYYpFUeTzdujfC1H8MR4KzqKeTEW7w
   MTdT1+pIIOD85JTgshWy7BJVij3ubyOAlrWW4uo8HFR2iTEnlRZRHncWg
   Q==;
X-CSE-ConnectionGUID: NPgbeQXYTdqKXAdGAMDdHg==
X-CSE-MsgGUID: t4UZf+XvR8Gw7MGHfbwsnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="99193187"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="99193187"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:10:15 -0700
X-CSE-ConnectionGUID: 0eRiTkflTqqol3ybLGpaKQ==
X-CSE-MsgGUID: p8ynAgY7QhusErKGmcc/Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="251568846"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 07 Apr 2026 13:10:13 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wACkU-0000000010H-30K3;
	Tue, 07 Apr 2026 20:10:10 +0000
Date: Wed, 8 Apr 2026 04:10:03 +0800
From: kernel test robot <lkp@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <202604080450.mkKRp9Mk-lkp@intel.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adKJMRkQJXEwHs-j@redhat.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: xm6z1d17ef6fcx56zjp7new7qkggstaa
X-Rspamd-Queue-Id: 206281C0005
X-Rspam-User: 
X-HE-Tag: 1775592616-266834
X-HE-Meta: U2FsdGVkX18gwFeSaQimpggznKqOUdRNLR8sOMDL5O0HRss6cGXnLJWCoKwquv9rrXjZZtDifeS2JpEM16/EwxCvqSwiQxbVlBNIV9o1y7VC9qyKjBTV0qdvEYmvsfehE5ejcvaT1t23otbyjjDCbtEP6mX/tNBnjA2pk1krzwabFRB7Y7yrRrrh8QO7+5r/8KYFQATAj/x7jc8uLk0jzPzfNd5xXhWF4wHLU1jqPw3iCZNrsFRkWmKgNFwTtoRa0vjAgWSh1y2hhvCmyE8XyOG9OOOwL0zK5N5Z/zYelvIiSe/OyOgx5cm2ofB5TH/nZrmEC8f2arFu/0fCFAj13pn3h6isC9M7JHwwBt+oUaGoxfcwf5XoqS+ukjkSZBAan/KlqYhNNXk0zRhGGv3eWSctFkPFjp5xtD98bmb7Qym1+QVcF/ALYIHCUWAJLC0Sb847iBvle4juPa90dPbFJFrQPfZtP1kJKGvlGGA0yVwrlyzt0NxNu13jS5P2sgBFhFTJJ90iNBxnvSLiZHD+11bkaXu7wChOqHv/8ACcwKsFZbOvIN14bD3JYHQ4XiIGusNdpP4UO8jqpwWn+2i33dNh/E1guPC8PJRAT8gDmBG5xV0FHJ+NL309AoYj0qeJuVmNLTKoze/N6JMbBSxBCXoayvqA2Rq+ZH4p6OaNo3L/E49tUTcS8+w2IjiT4UkM02IPFFOXFx4P6KL3tSpyFbLbpUE3lv7h/WjM7AVzdWWx3TKWwOfoLZ2STu2Pt4ojq2F7kmmCESh1q8B/bfrXUKBOsCoWhh9emNwPB/EfCYasZvhRgdQp37GH+aRoFVUti82v96CEskQgkUaC/q8A9uqhHgqd8JDaLdXghLzTfIv4b8DLBIaDWf1Sn001vyo6swub/hm/NOiRFOWke0DCdEH+AhXhMSdKRQp7xkoSLTXCgBHDspqgT3O8YOCFrfhPuGAd8vwJheYjo7dsYzW
 NYma9+G4
 lAu2Hi7TlMNXXFrXmr/nthsyklsEQZGAu/CqPEw1ucpz5hYVzgcMUYPes2NZCrxqNZ/oOjHFzP9yTUrIIVz38jW81vugY80n6SvD6wmlx5cB1DLnGBDTgxgLSlBZQfmhujXA51dWRmdzC4yLFHh8EKSdaamXH9Ike/ReculAIL4pdS/tCo01M+gwtIQF7iMtqbPxtb3SZqEJ61k4vtjofGOHapq1QbCw6nUDRfLWw0r1Fq4n8ojnfJcKdAdmswrPKwixkvHz4lkHm6aOE3CaWIt6HYGa1K/ak+U/9JByOmLt5YKlkuSlUZfFCnnZ/ahSzYqOhRshwhoBWHy0+8YHDme2oU0f1/DL1r98PS+cQwt/Hao2MW1x7wSnTRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oleg,

kernel test robot noticed the following build warnings:

[auto build test WARNING on brauner-vfs/vfs.all]
[also build test WARNING on akpm-mm/mm-everything kees/for-next/pstore kees/for-next/kspp linus/master v7.0-rc7 next-20260406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleg-Nesterov/signalfd-don-t-dequeue-the-forced-fatal-signals/20260407-131556
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/adKJMRkQJXEwHs-j%40redhat.com
patch subject: [PATCH] signalfd: don't dequeue the forced fatal signals
config: x86_64-randconfig-123-20260407 (https://download.01.org/0day-ci/archive/20260408/202604080450.mkKRp9Mk-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260408/202604080450.mkKRp9Mk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604080450.mkKRp9Mk-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/signalfd.c:53:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct k_sigaction *k @@     got struct k_sigaction [noderef] __rcu * @@
   fs/signalfd.c:53:40: sparse:     expected struct k_sigaction *k
   fs/signalfd.c:53:40: sparse:     got struct k_sigaction [noderef] __rcu *
   fs/signalfd.c:69:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct wait_queue_head [usertype] *wait_address @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:69:33: sparse:     expected struct wait_queue_head [usertype] *wait_address
   fs/signalfd.c:69:33: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:71:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:71:31: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:71:31: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:76:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:76:33: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:76:33: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:110:32: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:128:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:131:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:135:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:151:32: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:155:38: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:175:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:175:31: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:175:31: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:185:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:185:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:185:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:189:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:189:32: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:189:32: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:199:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:199:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:199:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:201:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:201:39: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:201:39: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:204:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:204:33: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:204:33: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:206:35: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:206:35: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:206:35: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:305:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:305:39: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:305:39: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:307:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:307:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:307:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:309:17: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:309:17: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:309:17: sparse:     got struct wait_queue_head [noderef] __rcu *

vim +53 fs/signalfd.c

    50	
    51	static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
    52	{
  > 53		struct k_sigaction *k = current->sighand->action;
    54		int n;
    55	
    56		*sigmask = ctx->sigmask;
    57		for (n = 1; n <= _NSIG; ++n, ++k) {
    58			if (k->sa.sa_flags & SA_IMMUTABLE)
    59				sigaddset(sigmask, n);
    60		}
    61	}
    62	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

