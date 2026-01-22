Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C286D2ED10
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDEC6B00A4; Wed, 21 Jan 2026 20:45:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B2D6B00A5; Wed, 21 Jan 2026 20:45:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398FE6B00A6; Wed, 21 Jan 2026 20:45:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25E436B00A4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:45:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B93DC1615C1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:45:33 +0000 (UTC)
X-FDA: 84357907746.19.6EDA545
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf10.hostedemail.com (Postfix) with ESMTP id 24ED4C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:45:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GWPZVA95;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769046331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPsG4+tgRg6qWP5v/lL0O8vJ9p//Szn5qYCQysmQ4K0=;
	b=oPy+ZqXcaJ3evmRIj1vGiL3NHP620fvIf5Blie7KWZfFHHKp7m8P9cHpao6pXIbmmyXaNS
	NNx/bJAh/4cxt/ArVqwF9F7rl7tdrtDdlq0LTrOGq3eIq/p9jHecZWLKoQCmxujCpbxC5+
	ADJiqhEc78JsHs21zkRvde8aLBnDJdU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GWPZVA95;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769046331; a=rsa-sha256;
	cv=none;
	b=3sf0+wpZKDX6GBFG3TXfKhsqvwLim5s4UdkrmbmFsT9/oxnrxHCyg2TpoKU58Zp5MBD0+d
	hBZ+mCa2yWwX2mWppDb2iaci+qofpLOnQtu/OrZ9dU3W15SWygaXTbb5UQqtPomRULDNHF
	H9ILdPnPDJH38uLeQZjS2m01eFf4nFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769046331; x=1800582331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MarIfSOD6YNmERZZkeLAaUzHAHkjkbeLViVecmLVxJQ=;
  b=GWPZVA95DYn75lMmVQNh9cd815R41r5JgsOigJaVPPyNzDC4U4bcNLR7
   Dw2CcU6ZfR1Q4/IfzCiaXZwQv84vDVo3/O2lGxpeKMcXkvv6QqxSuc8GL
   9Vb9Ewo7GOTjeumewh/Do3UVYN9KkO0ITsEMhSb2OV5h6cg+VDqvhhQ3O
   gSPT25vg9qN110MzfkzqSdipPZI3XOrfyb7FwTI/ppc20LvAHS09IRIHS
   R9xUMCeuYxGB94V14tGSXRBqdWJwGX51YDUkbd4+IMiVUkdRqGDS6Vfaw
   D9xYcYLU4DDRRc0wErZ2kgxL1rDvn2mowQ4mRb80J/AqSgF85CrxTwRZw
   g==;
X-CSE-ConnectionGUID: 5cf+07rUR3GbWc1TgmlWOA==
X-CSE-MsgGUID: LEXPAhZvTaGoX3TmYIYoyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="87860987"
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="87860987"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 17:45:30 -0800
X-CSE-ConnectionGUID: T/8U7MkXSZKG7nxnwrlUjg==
X-CSE-MsgGUID: Qfpkgs07SXeGIMYty5lt/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,244,1763452800"; 
   d="scan'208";a="206927059"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 21 Jan 2026 17:45:26 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vijlD-00000000SHN-3Yb2;
	Thu, 22 Jan 2026 01:45:23 +0000
Date: Thu, 22 Jan 2026 09:44:37 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v2 17/29] maple_tree: Start using maple copy node for
 destination
Message-ID: <202601220811.ac3t5OuP-lkp@intel.com>
References: <20260121164526.2093265-18-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121164526.2093265-18-Liam.Howlett@oracle.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24ED4C0004
X-Stat-Signature: ffuw7nnb7suozcy6nbms48bwqjhmmpak
X-Rspam-User: 
X-HE-Tag: 1769046330-447788
X-HE-Meta: U2FsdGVkX19kbnZiMJM5Ucr8lBrMNnys932v1FDc1jerTaLHnQV2hD+2StFTI/k8Smgd0tPD4wE6zYJHsPoWZBMSGwTnWEAlJhyoNcjBbvLPDYZVyhXNMOjgVtOto1L++upuvZIORUszWVgZPiQeRpYEsDVyVrov53RRGM38BnY6KJk2VcQUDVZ2n8wVqRPYucKb4wJH/3TwRZ6IdpLdB21pJt6GbZ6Mom4comloZrfZMK4lOW8MD8K5gCXPQrl9T9mRatO/lhBbhyaH+tFBPU86ZdSgpQ1XuQubsA9rIj6L2wes5XzMX5MUipIUtzFVU40Bqc8jLIDWWOlM8eK0UL4lBZ++3wGGwi7EX4Sf/U4eEiV/TJ4bdYdNvmVt25jcL54NzhPccoeN5SjjoYgIt3zXdqQ/kToS7Zr6aR/6tqP27qRftcobxqjeamLyPSzlqS0f5VMsO6smrzRaKsYtSVVi6LsMI9m9sTbWoA5vrV0L+nGSL1LZ2oaSRzfLEq7u1Brai7KJLAkXa+dmNeliyqAOiOKlz8DaaXW0re2aCI1DsBEFElfejSw3rgqLK/Eup53v1GJlTnO0aRBalVauuurtJFY7ZFjUkG/FnLE/ZvzAEm2/RwZL03MOsS4p2s3byKyY4zrH7Mb9PoHReYPRy8G9sKiF+zd4nSOtSLIQm3mm92Jq9AOVBsBnQ2EsJqyJM1cjrCQ1v2NNJJtGAsaHK6THhIpxt6r08sexg3nGSgot6XrGqOsFIkTp9tYrZsMV0pbVPCaG9oKeJLYGowYoCkulGTTBZn01ZQzLvhYAI790R3OGxEVVpO0pbdys8Gr5wt/2aLmgv5NlkMaO5QJk/+ypc2Xq4ByIR4BpceZTCL6kUOI4HP3deo4TwFyqMBb9abrzxEt9Mwk9FDCdOy8ntAtKkRBdyCbN3NHAvY/44nAJ2pV9GZ6jF0jaLNtlO/K7SpkSF3hJfrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20260121]
[cannot apply to akpm-mm/mm-nonmm-unstable soc/for-next linus/master v6.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/maple_tree-Fix-mas_dup_alloc-sparse-warning/20260122-023746
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260121164526.2093265-18-Liam.Howlett%40oracle.com
patch subject: [PATCH v2 17/29] maple_tree: Start using maple copy node for destination
config: sparc-randconfig-002-20260122 (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220811.ac3t5OuP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601220811.ac3t5OuP-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from ./arch/sparc/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:380,
                    from include/linux/array_size.h:5,
                    from include/linux/kernel.h:16,
                    from include/linux/maple_tree.h:11,
                    from lib/maple_tree.c:56:
   lib/maple_tree.c: In function 'cp_dst_to_slots':
>> include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
    #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
                                       ^~~~
   include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
     *(volatile typeof(x) *)&(x) = (val);    \
                                    ^~~
   include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
      WRITE_ONCE(p, RCU_INITIALIZER(v)); \
      ^~~~~~~~~~
   include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
      WRITE_ONCE(p, RCU_INITIALIZER(v)); \
                    ^~~~~~~~~~~~~~~
   lib/maple_tree.c:3155:3: note: in expansion of macro 'RCU_INIT_POINTER'
      RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
      ^~~~~~~~~~~~~~~~


vim +555 include/linux/rcupdate.h

ca5ecddfa8fcbd Paul E. McKenney 2010-04-28  550  
462225ae47d717 Paul E. McKenney 2013-11-11  551  /**
462225ae47d717 Paul E. McKenney 2013-11-11  552   * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
462225ae47d717 Paul E. McKenney 2013-11-11  553   * @v: The value to statically initialize with.
462225ae47d717 Paul E. McKenney 2013-11-11  554   */
462225ae47d717 Paul E. McKenney 2013-11-11 @555  #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
462225ae47d717 Paul E. McKenney 2013-11-11  556  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

