Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16971606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CjdQt7B5
Received: by kanga.kvack.org (Postfix)
	id 2D91A6B07C7; Tue, 24 Nov 2026 11:54:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289E06B07C9; Tue, 24 Nov 2026 11:54:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1517C6B07CA; Tue, 24 Nov 2026 11:54:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E20EC6B07C7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:54:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 852DDA0B7E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:54:20 +0000 (UTC)
X-FDA: 85470610680.13.6AB5163
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 990274000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:54:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CjdQt7B5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795539258;
	b=OCLhbZdiQNWXrVW18BkjbsgcpP4HYk87o8nujSfrcJNdn2ziqpNCj4WWV482WqpLMdihwF
	evqssdUY5DapxhF6M0pMCfojnGFzggGQHy3CFX7g20dI5S9zvyqW9LOb422sDxUUVQUeJb
	HewewUK2jCIhaHPG57yQ+7GaKm0hLnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQq3cn5OTp7tCndSsmVZ6PwJT9jX22+B9CY0Yosdsx4=;
	b=VvK2W2H7+j/xp9AapmDSnDGRKy3NhKDgR7eMdJk48jZyfWR2NDsR3bT0VJXmQ1b6jL3szK
	AmzIP19t6BZIT6F0J3o71L4Fx87FTbapv5XDZUkZvCreg93L5xxjY5OZxa3EHI/RPyGNBw
	0aTfW/m5o01qHkK5VUmos3+RNp7b2cM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CjdQt7B5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795539258; x=1827075258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cEnj9GUC9C0dZpOykEV7TDMrFtzJuotLx+ZqYNB/UEs=;
  b=CjdQt7B5LFziH89/4AhIselma6M1Ptf0urt8M77OdPnboYSYopmw2ELi
   cZxLq16V6Utrd3GU0xd92EYiE9E0hNWFatMvyL5tfKi9YlvRGvlTOxjYM
   ag2QFUOuEk/co5VbEyCfztjLbT+NiSkgNB983nJ1iH0zoyuf2L7b9VwNo
   8CgqNA6HuxLoEfg0d4see6znbY1nn1/nt7hAVA6EO/xoi13wgiT0MaIRL
   uAV0iSKcmkYZ50FTSE75L84/uoPyBygvad7SmgK6Z2EIrdSfFWOj/OLs/
   YxXLde212SBnVxJtEoIaD9BKWQO6jYDEqp5wwHdxoT+frPpLTZ/ocGvco
   Q==;
X-CSE-ConnectionGUID: hgkEQYWkT22M4GN73mX2EA==
X-CSE-MsgGUID: 5mSnA2tDQw2lAU9htN2uig==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4240340"
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="4240340"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2026 08:54:09 -0800
X-CSE-ConnectionGUID: vnpYnMGKSYeRsQ/M01NTNQ==
X-CSE-MsgGUID: GhG120cyQY+TVqu2ME3v0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,231,1787036400"; 
   d="scan'208";a="11810537"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 24 Nov 2026 08:54:04 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xVtmL-00000001Pmw-0kfT;
	Tue, 24 Nov 2026 16:54:01 +0000
Date: Wed, 25 Nov 2026 00:53:45 +0800
From: kernel test robot <lkp@intel.com>
To: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
	Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Subject: Re: [PATCH] rust: bug: add warn_once! macro
Message-ID: <20261125001602.y8fdKF1R-lkp@intel.com>
References: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124132707.101769-1-mbkchelofficialdev@gmail.com>
X-Stat-Signature: 8ysh44cinzex7txdfmhbdw5in31qtsbh
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 990274000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1795539257-970302
X-HE-Meta: U2FsdGVkX18sOMCi2jwM/XyUiy45dxRYuPOCMKKG/Goz+vVg6zXJMeGZJ71jIaMHKI/XVf+RcfZto8h3BZkPNZipovR2tQt1/+cECOHntF2a4HN/YYw7p3pQgCxanQ0RAX+mJwDAfSojW1ErGMgn7HAQ34i7gTGNJc++7kJszss0rEga6Lxz+L2t90PEojacDIEK7Z12qTOtZ/OoBFjnKGo3DEy5kwuunui4gz65aSc8Q/aFbpy11YSROWDrLAlkine1JAYEjID795ZznKV/dfX/O1essHX7mRt/tFSk9v2/SF7wdCk0UFxzHLXYH7u6p9SF3x6GZkO2kaBpAHB+U6c5s6VP1Ni7YTMEkMwJbHPbSzL/Yw2QpGPG8VfPQiNl+n8T/ZS90XFzee9g71H1ogsBRx8lJ2nbWAVH8AyHEWu/mWsJp9tuHpGmuU1bYsGdeOURHss5QDa52jIJRtQM3CrPTONtPC1N6CpcZDeAaRMmvbBgrHilY9heIfmxgDvgdBDfuAQBlyeYuNdYxpPjHAcjRL1PHIwQKOXgteVn1Ff0SRitlBgD7S4eJ5Mk0UA8WjcfDWZ+s8cgpRBofN+8eexk1mCv5BefC0HcboQdt3uR4ke8QMASpXm69AYIaq20mCz4YvfZOhU9NAoj4QJz902Rl8An+WmDYozgwshu4o46nnDX1a7UmY1VHSrPBKcgthltOQsos1LdrxtbDU7FbPAH/ixHwqVcFo07dAl1wUizVs73j/BUY0dCXhVOLXygEJJqSbmJTEq2OvWNE+b61pn7zIVemKHRuBMtedcqqtvxMI3OoSS2fn3E8CxErgrTFKNmYAL/xWSGI9Tah/RPnEOD1JHd94jRkCM4lPQyQ2Y2g6bnprSK5J88Al9nUHH0MuaGv8d+zyno8FKlVjh11ZHhkz1BqbnfBqcVDoGnHNO1euEhKgf3whKFl1uSPgWiWqd/qQ+VW2kcO638PB9
 /QGWzCQN
 mxfMje9DBSWCEZqTBnx9qaNaxl/p/TsQhOnYNR+cQZutdu+kL2MiCWsRKWwS/aASPotQb5e7fZ1dVmU9kfF3h3WIHb8SD9mZY4qlLWMa8Lb/kvs8bAwWaaLFrV7Zqm/zdKUiH/GBzVAYLnYIyPohjneQbZ7tLbkY2qlycOAjrKKKeKdXg/0gIHHGvfQM2FmOQSRS3Ki53PkiCVnCNDC0tWX6YyshEu+WGbJC/xQXme3+liYXATLrfbtnrdqyZ6qq5y+RfS1/Xd/B0lywknfw+Jf6lBDzuWjebeiRclncq6U5eKk4hNUtpbDQImWwdQghDmWw/kt4kfOcOgoVyu1eqfPJwCT+GAgsSHmYT3jI31aYgoxCyVGytjSjhEujfc46ECoBBHEHW8oE/1YxqzpNq8Kp5EqrvxoK4hzmPSEnwIs+YOgP5tcdGdUDvDFBKpWoSfdBjhH1lEApRdZ6l3RWs2Qe85O6up9jGEhXDG1yoIBYLTx6dLa4/WtchApTVZLodso5Q51A8ghjLWVZV/ygBwrdzji8JTlRx+1NScmuy0fnCGkbcb56aDVF229M6WGzi410t1ImYB6gi8LW1fm8v0ymBSRbRVGCmNMePoge29IuEia2oFXbMpeSG8HEBJarN3uIOE/5BOkRGwXNy1S/JOXzObGLHpzW0vsb4eFQEb/pkNANAKPy7FT5a4DHHhVFf2t0AS2+BK/w917qWyX+jLh8OF9UDs2/HkDBj1TjtiKUPYaKKrkPQwkq+N9GeJDFh9aaz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ivan,

kernel test robot noticed the following build errors:

[auto build test ERROR on rust/rust-next]
[also build test ERROR on akpm-mm/mm-everything linus/master v7.4-rc4 next-20261123]
[cannot apply to ah-configfs/configfs-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ivan-Tverdokhleb/rust-bug-add-warn_once-macro/20261124-152707
base:   https://github.com/Rust-for-Linux/linux rust-next
patch link:    https://lore.kernel.org/r/20261124132707.101769-1-mbkchelofficialdev%40gmail.com
patch subject: [PATCH] rust: bug: add warn_once! macro
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20261125/20261125001602.y8fdKF1R-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261125/20261125001602.y8fdKF1R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261125001602.y8fdKF1R-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:28:
   In file included from include/linux/cgroup_api.h:1:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
   |                                                   ~~~~~~~~~~ ^
   1 warning generated.
   llvm-nm: error: rust/helpers/helpers.o: No such file or directory
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
>> error[E0425]: cannot find value `BUGFLAG_ONCE` in crate `$crate::bindings`
   --> rust/kernel/bug.rs:172:37
   |
   172 |                 | $crate::bindings::BUGFLAG_ONCE;
   |                                     ^^^^^^^^^^^^ not found in `$crate::bindings`
   |
   ::: rust/kernel/mm/virt.rs:118:12
   |
   118 |         if crate::warn_once!(did_overflow || address < self.start() || self.end() < end) {
   |            ----------------------------------------------------------------------------- in this macro invocation
   |
   = note: this error originates in the macro `crate::warn_once` (in Nightly builds, run with -Z macro-backtrace for more info)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

