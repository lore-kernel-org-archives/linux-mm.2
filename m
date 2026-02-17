Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC1AE9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522BC6B0088; Tue, 17 Feb 2026 16:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFE96B0089; Tue, 17 Feb 2026 16:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CE9F6B008A; Tue, 17 Feb 2026 16:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 222E56B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:18:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA884C140E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:18:15 +0000 (UTC)
X-FDA: 84455211750.27.03F4610
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf01.hostedemail.com (Postfix) with ESMTP id F421640012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:18:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ndVZ1RoZ;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771363093; a=rsa-sha256;
	cv=none;
	b=21nsOl+SsH1g/mh0C+E+fkNJFB/AtpONSUI/dqruAE8NWt/vT8iMRN+MCLtPNIFZ+Ek+Oz
	UmumrJygySc5jYoTUoh5kgyfa1tDhqOBqTN2aRVdaB1HHFJJInmJjFOf0xRrwhY63avWyY
	TuTMssp0jhqt+2x0En7g7IFNuId8dG8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ndVZ1RoZ;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771363093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJTSefH9+HDoEEKJ3Ozl2JI+wX+wVLO2Ke3/Gt8RtiU=;
	b=eGM06HsHkuaKSHS840S13VlihvRkvh74YV07IdMpzaMy12V6d/HryzTsBmHLeb28HAsQgb
	Ls9eONvdQEfaHfhN6pxMo2sVB4a2Kki93KLcqiFTr5wd/feuqytM+bq1K4WXwXPZec8l9a
	wE16u1p5QtWq4A17pNFzDrUJRyylhbc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771363092; x=1802899092;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZohkSzNrI1aHnsD72W2wMAvwZYjTdr/MX/TjDGlyz/M=;
  b=ndVZ1RoZ+p6uiFscfj3tsX+jgLjYOOz2zthYMdMTmm4O34quUqMdrGd+
   0i0fseDFWTbb4p25Yt70iJk3+p+Uy9MYsO/1dh4sRwm8yOrPz/twfcxfU
   ugP+iuJRYCeRz3CSsZFKe/7d47uC6W1/0Anponhrg+nO6JENF62bkeqRw
   a5etoX6lUB8rfwuGjdZngsbjXRgoGUjm9sZSwEuU3pHTYDCreNirc5Qo3
   0uvPa8xQoPIqpKIpCOPkAnCSPVgqYnLxc3p1L7IoR/1Mk+dKLlrtODc8h
   km8s+BS0xYVrc4XeSYF4HcqfUnb3qniUv44G3Wzr/PffbH/k+h6aEywJa
   Q==;
X-CSE-ConnectionGUID: 1VsItxWyTMS4qF6/H/NJjg==
X-CSE-MsgGUID: zCdKFLZeTmuYYPnerH0HLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="97903378"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="97903378"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 13:18:11 -0800
X-CSE-ConnectionGUID: yxqFdQuKSOeef8cfUtANyA==
X-CSE-MsgGUID: gkj+1tp8SEGb/vuS/jObQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="251696798"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 17 Feb 2026 13:18:07 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsSSK-000000003Ir-3iLC;
	Tue, 17 Feb 2026 21:18:04 +0000
Date: Tue, 17 Feb 2026 22:17:06 +0100
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Carlos Llamas <cmllamas@google.com>, Jann Horn <jannh@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] rust_binder: avoid reading the written value in
 offsets array
Message-ID: <202602172222.mGDpJK77-lkp@intel.com>
References: <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com>
X-Rspamd-Queue-Id: F421640012
X-Stat-Signature: 1aomuj3u3yjwdrqpq38fy3t1hx979rme
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771363092-275312
X-HE-Meta: U2FsdGVkX198RbGY2nX5/6eFnLyTFVKtBnZfdOaKiENgvCYKfDGG4XloiuIEkpNwAgkDQKMLwOrSuo9W+lnzwZzvs4rUGDKy9t64e2sXY2OVjl5Ex7Gy9P9WR7+ogkkxNa24qViTZuPyiJJNe+WfoPBruqi3cox1iiZ1ZO7sbpLXEdRaDWvglH+EoQWV6FvVH6e++vlZKEb6dLCDiH/8eah/1VXf8+pdTEH+VQjV6+lHUyjAHFY76Ibxy9cCI6XpI5DQbme0oobvI/pySzAujw86VXCpEB3DkCkzvfsr3MUQs+zhcFdoBo4vCQ7nrz7CRs4yngvStcHNGBvM2xhbJoC/g5H4p2SE3qE2+SGDoJY0yNAkHnj1Zi+a2wm4QFOvzjBu5wfW0I+FaNtSXrLVHyDWwI27dliqCK9ZKyCwgddyhRPo91shKRBeexkWBSDUJOdgKu8jEYj9boueB9F6B8tZFHYAtmwmfvIgEQ/CgWpsdYm+4A72W18KrP4ZK/DiQiispoflFGl09npIWoOJnRxYui9dWnDFNQ2tz1PrDvHmLdYmRqIF2rswvVdig/j+EcLmn2QhFNAnyag+5Bmv0Ssqx6Z1Vm9Bt6oKkXMclMvLQQ51cmQkA/HIv7/xcnmBXTdA/jfOE3TnD3AGmJr/e62aywnabtueApk8ofD0cDzTHNZ+VcugzIvPkYRnqbatlUpG2Sc8Dc9uVXCD3FLXTdl7Ri0uBCqz7WfoD3iUBou5ml04dBjBWJ17ElbOydQ9HL4ZICtS6riOr1F4CMv3RLFqMThOFDsQarwQHZRK2M/vsi09nopX4ge2oHta+6aNHQqc7jeNMIjCGLs2la8nlcdiqcPmhkL5+GTW29Po4cZ8XapWk+8/w+GZgoaH9YnojnVFCO9BNayUUaUy5uWnYarhn/lOZxXhTUtDZ7Gbkzu0ZLSuSQmB18jkoRTkgFRHYv711JvY7DSSoqKN1PC
 1epb7A6E
 8YI7T2iX5HvonuR0V0K4Lbu1iU6h0b+1VKzxlGVgd8rqNCopkLcuaMZfuwJR/QFiKJInRaTzW2QzPjivuvByQkct1XofUhikuLlEikiJclY59STTrH2W6AOEEDeIRN4OrjavN1rghdUwBu6DYL6CqlfWeojOq/HyZzU5EdgkCUh0KYSUJaZsnheN2w0U2m7zK+wVObpcLNnkWsteZ4eF9S0sjxXRwfdoKKpq7lyaPU8nYjZdIWChNvfCtsZI6E65XLKDi8JOO7BXERnkhvl0NNk3w0pzf1XhLFH9RtZfEfCza+GjWr3qDSb+TrTlQhZG9vxfCazfkYkb5HH3sSLmcrA6+giDgjXMfj8Yfk7M636yaEpzEAyqbXY+zDRZjQalYNBlMxnryQZpLtq2hax/BgfOUtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0f2acd3148e0ef42bdacbd477f90e8533f96b2ac]

url:    https://github.com/intel-lab-lkp/linux/commits/Alice-Ryhl/rust_binder-check-ownership-before-using-vma/20260217-222439
base:   0f2acd3148e0ef42bdacbd477f90e8533f96b2ac
patch link:    https://lore.kernel.org/r/20260217-binder-vma-check-v1-2-1a2b37f7b762%40google.com
patch subject: [PATCH 2/2] rust_binder: avoid reading the written value in offsets array
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260217/202602172222.mGDpJK77-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602172222.mGDpJK77-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602172222.mGDpJK77-lkp@intel.com/

All errors (new ones prefixed by >>):

   PATH=/opt/cross/clang-20/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   INFO PATH=/opt/cross/rustc-1.88.0-bindgen-0.72.1/cargo/bin:/opt/cross/clang-20/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 12h /usr/bin/make KCFLAGS=\ -fno-crash-diagnostics\ -Wno-error=return-type\ -Wreturn-type\ -funsigned-char\ -Wundef\ -falign-functions=64 W=1 --keep-going LLVM=1 -j32 -C source O=/kbuild/obj/consumer/x86_64-rhel-9.4-rust ARCH=x86_64 SHELL=/bin/bash rustfmtcheck 
   make: Entering directory '/kbuild/src/consumer'
   make[1]: Entering directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
>> Diff in drivers/android/binder/thread.rs:1018:
            if offsets_size > 0 {
                let mut offsets_reader =
                    UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
   -                .reader();
   +                    .reader();
    
                let offsets_start = aligned_data_size;
                let offsets_end = aligned_data_size + offsets_size;
>> Diff in drivers/android/binder/thread.rs:1018:
            if offsets_size > 0 {
                let mut offsets_reader =
                    UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
   -                .reader();
   +                    .reader();
    
                let offsets_start = aligned_data_size;
                let offsets_end = aligned_data_size + offsets_size;
   make[2]: *** [Makefile:1903: rustfmt] Error 123
   make[2]: Target 'rustfmtcheck' not remade because of errors.
   make[1]: Leaving directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'rustfmtcheck' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'rustfmtcheck' not remade because of errors.
   make: Leaving directory '/kbuild/src/consumer'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

