Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C808CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 18:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C90E6B0005; Sat,  2 May 2026 14:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A3D6B008A; Sat,  2 May 2026 14:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1616B008C; Sat,  2 May 2026 14:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D98E86B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 14:28:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31679A0531
	for <linux-mm@kvack.org>; Sat,  2 May 2026 18:28:42 +0000 (UTC)
X-FDA: 84723315684.11.EED98F8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8354180002
	for <linux-mm@kvack.org>; Sat,  2 May 2026 18:28:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=imGTPFC+;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777746519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmdoTe+QWrXc7vbISivu0X9BgtGkRj9NfHpSyXM5Ah0=;
	b=WRBA7P1IXUtR1B4cMvBA5r6iIgJKz529rXlt1vzLke7j30bfiaiWxlIfFzalUGKlA8M+d6
	Zd4gdp26eJncx0lnCsc2BE5seV3wEXQNc/vX8lqwTQQYDh0OiVaxTMJuDu/ytbE6c+35aq
	xQgwYiY1fmZbKK+TpJUFibIeUyo1aU0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=imGTPFC+;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777746519; a=rsa-sha256;
	cv=none;
	b=Pt3BWTfF8nuTCRZdSvJxZWZYX+0MFFPSgk22u6tj383WzkwBfTyvrcM7XNfH6c2VEB4gWf
	IX/FV0FsHwmvqviGNNus3MjBznhwOupXd5orhtb7xfyBNR96B4O9fljvk53Zkskv5beaYA
	TfWRaxYC+yJ3FdlSUP9orrMv6xDHMf4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777746518; x=1809282518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q3zM62fEWOJNDVadnK6ghVso273+xpCZLWV1ENBesh8=;
  b=imGTPFC+xf/x8aICFujDh9ulWWR7YYQSkLmiMsERtMtEhae8e2kkC6c/
   c2ZBaw10TRpeKZqs3+c04mEkdoKv+G1RzzP/28gMqf58PHANTDyoG29Jw
   0CgXrCNnRHmxaSkq3umOK1m91WGfldqZnp6ybyjD7xWtjnrbNMe+Hwvau
   /nqkoOdvPEy4ofsFdEGB3T7Y3TaeuEIn9vSBA+i3kmwPYBI//T4ARycVf
   eVfrlB107FIuKcaFE227nNWh20tvv2PqjL/ubvKeLgIk2Q5kzEnxmfrU5
   9TKa5oU0rw1hLKwRG5GRDrC/7/k7Hq/Hbq5IHWkP08e8SEkzzlZQRk5vB
   w==;
X-CSE-ConnectionGUID: WLRpfRBYTrqgH8dFnYeTJA==
X-CSE-MsgGUID: BTT6gBKESSG67wu0mHzJHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11774"; a="78723573"
X-IronPort-AV: E=Sophos;i="6.23,212,1770624000"; 
   d="scan'208";a="78723573"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2026 11:28:36 -0700
X-CSE-ConnectionGUID: uNdBOgO5T9iGHCviaNjmTQ==
X-CSE-MsgGUID: keXHKbGwQHS5NAcVyMXTIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,212,1770624000"; 
   d="scan'208";a="258748709"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 02 May 2026 11:28:33 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJF4o-000000001j7-1iTB;
	Sat, 02 May 2026 18:28:30 +0000
Date: Sun, 3 May 2026 02:28:01 +0800
From: kernel test robot <lkp@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Lutomirski <luto@kernel.org>, Kees Cook <kees@kernel.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Will Drewry <wad@chromium.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signal: prevent evasion of SA_IMMUTABLE signals
Message-ID: <202605030218.3dGIaLF1-lkp@intel.com>
References: <afHBYTUA5XexTj-Q@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afHBYTUA5XexTj-Q@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C8354180002
X-Rspamd-Server: rspam06
X-Stat-Signature: bgf6bktjdkwpcuonsr4yqzk4azhn1r95
X-HE-Tag: 1777746517-403176
X-HE-Meta: U2FsdGVkX18kJ3wElhQpZ9bCJJSFTC/GCmZgkeNYWr1Re7/542V8jFqfCCzd0xnb3ior5CeGTEE4xKJgV0x0xSUXkUxNF5OVDsB+NeIfT/Uksb9QMNV5K2FeKZPelWEbk2ZHwOrkN8XgQ2TyPu8s+6q1mwTQKFHi+V1axkmOYPN9290uW2EhHBwNTaUqsoJU/ZAJXa5M+E7/VloXBFz/Y1uWzFgENmWhIFiWcFn6VXFuNUmI4A2X2gQ8O5gNzFJ1/lo9COBvJNzcqXccBOZcgE7JEpW29mizUyJa37Y6hDIXiSnDEH+eRqWf7zpPY2zVBADZidkI0r2DNOm/ZTblFwzg844yP92xqLzD2EdUzYRVIZBkODJERqHmSkFMm1fv/kgn0S6f9IrLSb9Y4W2uaAHasdmkQizGbAGw+uuujQn2SCdw00TFpR3V9bNpmY6ij3Lvt0u1H5vr3mlBteRaqIfDyIT9UgcYF5U8H8o+DoG5A0wbtyWJi8MdTLSCzCiQeUtAsLnZ0AzlBtTh3Jpdf9TdHv+AKQv+rqAwo3f5Dy5iSzAiQBzkmgxaQp2yHUp9/Yr1D+mMyDox++18ivMvjFw+zskmDaxxuVQPx0hOCsHJQkduYAzjxIooUl3mTtGVEwm1IO60xhOAc/wEGob8oZm+B8e5kCrmB43jgdJLm5i4I5m78K+v4yPUzrBUgLjLf9uSQMyRdNk0wKA4GTUoNL+WI1izoSYX6Eccq/Esny9X1T1nJUGkpTy/qLlh7f6JvoBesjVyTvvkFXxnx2rwJ92XEsT+sxDHH7Zde4CAKphgpkOcREF22BA23Dn3sYIQZp3iv7KXkO9XdRdLm9ID2wPzuPd8Sci2xqE0Id3nBxu41uPro6H+dR19yytBDCLlrPvYONKyCZqHiyFqNSXOglRO1SZz3aZ+65Jwhfx2opdWIxyMWyGzGDWStLQ0xkmFKHxu6X+cc48FokmDXT2
 f9n8yREn
 YAEX0aO/heFMjN62HgO3C5fuKEPON/rpiZAA2OV7sR5PCH2EBuWT4KiuEwbsjkeogkvxQrRyEBvNl/X900XAUx56s9ylCyLFpcZfpdtgK7/1I2XlwpW5JqP/1kn6xRFcbnbpFpAazUgT1GdbGVFGlHhU9WDCVdDV5+NVtMAYA9KaZxOcTC0fka0/pE51nu8a5fDAP8rIG2iPbUlIYVnY6MWO2+mIK+q9kQsYBll6qkOJ94AS+PEnpa6WJjzhRZ1WtGZtifXBFoU+JnaYKqVTPJD0ppg3AYDlLX7e4h5fhRouDN/ALOLjnoJ3/+VRkMymjtcX6/vDc2xWFWxXxW+BsZNqoqDl70V923SyG6tSA5JN9MIUdxzQh6ialyQDxntlINzSSSGHPgrLtVXorbyFFXOryM8EcnRmb6v1zdpqWr2BOXlfqM+JufVl9Nj5yskE2cHkiS2ywxrnsef8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oleg,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.1-rc1 next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleg-Nesterov/signal-prevent-evasion-of-SA_IMMUTABLE-signals/20260430-182827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/afHBYTUA5XexTj-Q%40redhat.com
patch subject: [PATCH] signal: prevent evasion of SA_IMMUTABLE signals
config: nios2-randconfig-r132-20260502 (https://download.01.org/0day-ci/archive/20260503/202605030218.3dGIaLF1-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260503/202605030218.3dGIaLF1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605030218.3dGIaLF1-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   kernel/signal.c: note: in included file (through include/uapi/asm-generic/signal.h, include/asm-generic/signal.h, arch/nios2/include/uapi/asm/signal.h, ...):
   include/uapi/asm-generic/signal-defs.h:83:29: sparse: sparse: multiple address spaces given
   kernel/signal.c:191:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:191:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:191:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:194:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:194:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:194:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:497:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:497:9: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:497:9: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:501:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:501:34: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:501:34: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:523:53: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct k_sigaction *ka @@     got struct k_sigaction [noderef] __rcu * @@
   kernel/signal.c:523:53: sparse:     expected struct k_sigaction *ka
   kernel/signal.c:523:53: sparse:     got struct k_sigaction [noderef] __rcu *
   include/uapi/asm-generic/signal-defs.h:83:29: sparse: sparse: multiple address spaces given
>> kernel/signal.c:1048:40: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sighand_struct *sighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   kernel/signal.c:1048:40: sparse:     expected struct sighand_struct *sighand
   kernel/signal.c:1048:40: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   kernel/signal.c:1314:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:1314:9: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:1314:9: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:1315:16: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct k_sigaction *action @@     got struct k_sigaction [noderef] __rcu * @@
   kernel/signal.c:1315:16: sparse:     expected struct k_sigaction *action
   kernel/signal.c:1315:16: sparse:     got struct k_sigaction [noderef] __rcu *
   kernel/signal.c:1336:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:1336:34: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:1336:34: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2204:44: sparse: sparse: cast removes address space '__rcu' of expression
   kernel/signal.c:2223:65: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/signal.c:2223:65: sparse:     expected struct task_struct *tsk
   kernel/signal.c:2223:65: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/signal.c:2224:40: sparse: sparse: cast removes address space '__rcu' of expression
   kernel/signal.c:2242:14: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sighand_struct *psig @@     got struct sighand_struct [noderef] __rcu *[noderef] __rcu sighand @@
   kernel/signal.c:2242:14: sparse:     expected struct sighand_struct *psig
   kernel/signal.c:2242:14: sparse:     got struct sighand_struct [noderef] __rcu *[noderef] __rcu sighand
   kernel/signal.c:2275:53: sparse: sparse: incorrect type in argument 3 (different address spaces) @@     expected struct task_struct *t @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/signal.c:2275:53: sparse:     expected struct task_struct *t
   kernel/signal.c:2275:53: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/signal.c:2276:34: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/signal.c:2276:34: sparse:     expected struct task_struct *parent
   kernel/signal.c:2276:34: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/signal.c:2305:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/signal.c:2305:24: sparse:     expected struct task_struct *parent
   kernel/signal.c:2305:24: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/signal.c:2308:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct *parent @@     got struct task_struct [noderef] __rcu *real_parent @@
   kernel/signal.c:2308:24: sparse:     expected struct task_struct *parent
   kernel/signal.c:2308:24: sparse:     got struct task_struct [noderef] __rcu *real_parent
   kernel/signal.c:2341:17: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sighand_struct *sighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   kernel/signal.c:2341:17: sparse:     expected struct sighand_struct *sighand
   kernel/signal.c:2341:17: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   kernel/signal.c:2381:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2381:41: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2381:41: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2383:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2383:39: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2383:39: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2440:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2440:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2440:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2498:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2498:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2498:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2538:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2538:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2538:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2540:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2540:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2540:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2638:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2638:41: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2638:41: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2722:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2722:41: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2722:41: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2734:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:2734:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:2734:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:2777:52: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *parent @@
   kernel/signal.c:2777:52: sparse:     expected struct task_struct *tsk
   kernel/signal.c:2777:52: sparse:     got struct task_struct [noderef] __rcu *parent
   kernel/signal.c:2779:49: sparse: sparse: cast removes address space '__rcu' of expression
   kernel/signal.c:2817:49: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sighand_struct *sighand @@     got struct sighand_struct [noderef] __rcu *sighand @@
   kernel/signal.c:2817:49: sparse:     expected struct sighand_struct *sighand
   kernel/signal.c:2817:49: sparse:     got struct sighand_struct [noderef] __rcu *sighand
   kernel/signal.c:3150:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3150:27: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3150:27: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3170:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3170:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3170:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3237:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3237:27: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3237:27: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3239:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3239:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3239:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3390:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3390:31: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3390:31: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3393:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3393:33: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3393:33: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3782:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3782:27: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3782:27: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3794:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3794:37: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3794:37: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3799:35: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3799:35: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3799:35: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:3804:29: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:3804:29: sparse:     expected struct spinlock [usertype] *lock
   kernel/signal.c:3804:29: sparse:     got struct spinlock [noderef] __rcu *
   kernel/signal.c:4296:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   kernel/signal.c:4296:31: sparse:     expected struct spinlock [usertype] *lock

vim +1048 kernel/signal.c

  1044	
  1045	static int __send_signal_locked(int sig, struct kernel_siginfo *info,
  1046					struct task_struct *t, enum pid_type type, bool force)
  1047	{
> 1048		bool immutable = sa_immutable(t->sighand, sig);
  1049		struct sigpending *pending;
  1050		struct sigqueue *q;
  1051		int override_rlimit;
  1052		int ret = 0, result;
  1053	
  1054		lockdep_assert_held(&t->sighand->siglock);
  1055	
  1056		result = TRACE_SIGNAL_IGNORED;
  1057		if (!prepare_signal(sig, t, force))
  1058			goto ret;
  1059	
  1060		pending = (type != PIDTYPE_PID) ? &t->signal->shared_pending : &t->pending;
  1061		/*
  1062		 * Queue exactly one non-rt signal so that we can get more
  1063		 * detailed information about the cause. But we must never
  1064		 * lose the siginfo for an SA_IMMUTABLE signal.
  1065		 */
  1066		result = TRACE_SIGNAL_ALREADY_PENDING;
  1067		if (legacy_queue(pending, sig) && !immutable)
  1068			goto ret;
  1069	
  1070		result = TRACE_SIGNAL_DELIVERED;
  1071		/*
  1072		 * Skip useless siginfo allocation for SIGKILL and kernel threads.
  1073		 */
  1074		if ((sig == SIGKILL) || (t->flags & PF_KTHREAD))
  1075			goto out_set;
  1076	
  1077		/*
  1078		 * Real-time signals must be queued if sent by sigqueue, or
  1079		 * some other real-time mechanism.  It is implementation
  1080		 * defined whether kill() does so.  We attempt to do so, on
  1081		 * the principle of least surprise, but since kill is not
  1082		 * allowed to fail with EAGAIN when low on memory we just
  1083		 * make sure at least one signal gets delivered and don't
  1084		 * pass on the info struct.
  1085		 */
  1086		if (sig < SIGRTMIN)
  1087			override_rlimit = (is_si_special(info) || info->si_code >= 0);
  1088		else
  1089			override_rlimit = 0;
  1090	
  1091		q = sigqueue_alloc(sig, t, GFP_ATOMIC, override_rlimit);
  1092	
  1093		if (q) {
  1094			/* Ensure dequeue_synchronous_signal() sees SA_IMMUTABLE first */
  1095			if (immutable)
  1096				list_add(&q->list, &pending->list);
  1097			else
  1098				list_add_tail(&q->list, &pending->list);
  1099	
  1100			switch ((unsigned long) info) {
  1101			case (unsigned long) SEND_SIG_NOINFO:
  1102				clear_siginfo(&q->info);
  1103				q->info.si_signo = sig;
  1104				q->info.si_errno = 0;
  1105				q->info.si_code = SI_USER;
  1106				q->info.si_pid = task_tgid_nr_ns(current,
  1107								task_active_pid_ns(t));
  1108				rcu_read_lock();
  1109				q->info.si_uid =
  1110					from_kuid_munged(task_cred_xxx(t, user_ns),
  1111							 current_uid());
  1112				rcu_read_unlock();
  1113				break;
  1114			case (unsigned long) SEND_SIG_PRIV:
  1115				clear_siginfo(&q->info);
  1116				q->info.si_signo = sig;
  1117				q->info.si_errno = 0;
  1118				q->info.si_code = SI_KERNEL;
  1119				q->info.si_pid = 0;
  1120				q->info.si_uid = 0;
  1121				break;
  1122			default:
  1123				copy_siginfo(&q->info, info);
  1124				break;
  1125			}
  1126		} else if (!is_si_special(info) &&
  1127			   sig >= SIGRTMIN && info->si_code != SI_USER) {
  1128			/*
  1129			 * Queue overflow, abort.  We may abort if the
  1130			 * signal was rt and sent by user using something
  1131			 * other than kill().
  1132			 */
  1133			result = TRACE_SIGNAL_OVERFLOW_FAIL;
  1134			ret = -EAGAIN;
  1135			goto ret;
  1136		} else {
  1137			/*
  1138			 * This is a silent loss of information.  We still
  1139			 * send the signal, but the *info bits are lost.
  1140			 */
  1141			result = TRACE_SIGNAL_LOSE_INFO;
  1142			/* The task must not escape SA_IMMUTABLE; escalate to SIGKILL */
  1143			if (immutable)
  1144				sig = SIGKILL;
  1145		}
  1146	
  1147	out_set:
  1148		signalfd_notify(t, sig);
  1149		sigaddset(&pending->signal, sig);
  1150	
  1151		/* Let multiprocess signals appear after on-going forks */
  1152		if (type > PIDTYPE_TGID) {
  1153			struct multiprocess_signals *delayed;
  1154			hlist_for_each_entry(delayed, &t->signal->multiprocess, node) {
  1155				sigset_t *signal = &delayed->signal;
  1156				/* Can't queue both a stop and a continue signal */
  1157				if (sig == SIGCONT)
  1158					sigdelsetmask(signal, SIG_KERNEL_STOP_MASK);
  1159				else if (sig_kernel_stop(sig))
  1160					sigdelset(signal, SIGCONT);
  1161				sigaddset(signal, sig);
  1162			}
  1163		}
  1164	
  1165		complete_signal(sig, t, type);
  1166	ret:
  1167		trace_signal_generate(sig, info, t, type != PIDTYPE_PID, result);
  1168		return ret;
  1169	}
  1170	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

