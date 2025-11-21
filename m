Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9CDCCFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 02:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323FB6B002F; Thu, 20 Nov 2025 21:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBA56B0030; Thu, 20 Nov 2025 21:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238F86B0031; Thu, 20 Nov 2025 21:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 143226B002F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:50:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84D0A12FCC3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:50:03 +0000 (UTC)
X-FDA: 84133084686.17.887F703
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFB1120002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:50:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jfFR0I50;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763693401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=80Dm5gxPWMx6QECH3luEPOXtrlbBKDhJX35ZwqQptoo=;
	b=tVhudOen/1vp33+xviGMV5y1LIBCtnbAm4+oiQLDGQaiz5w5oou2seowH5FdcLVvjvgqya
	T4mw5BhYt+GvUJ6cHtdPTiArnWIvBgEX1weYf3X43r0RbrX+74FYCoiawvH1jXKG+WSfDl
	R7KgCGUakD5GdJY6JsfeJYTdAa5I1Ns=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jfFR0I50;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763693401; a=rsa-sha256;
	cv=none;
	b=bAYV3Hg2yR4S8G1GRKMwgski+Ab3W+CchngYgmW/X5B02YHrJK2mlnmLqjY4Y8Wu1mSZXL
	hgO3uJ1Z9MIcDKoD7psqmCgf593XO0oUq3StJczXs8JD7R/+N2231Kl4SBNxAyNcMXXfiA
	WNI5h/WQuAUOA9xv/Nel+a5BebYEpYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763693401; x=1795229401;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=K94SV6QMRUsgclNuzA+uawtb5vLliCETVk2q+6FBiPQ=;
  b=jfFR0I50Z2Wy40/5XoqTurY4v34uMmkyTSkj8xG2erERROlqblNNAxOl
   Amh8XwAPBuzJgiwFhRN7vGwXXTOPijJEg3pmvyvRRIFke3rO8JMUcWM9t
   fSqX7RfZUX5eIQIDobSsTDqgJHushNGcKmG8EOTpiPDDJpomXpE8Dh1EO
   Lr9iiMMUiLfn+yp+d6X0XF/aLHuGTQnKW8l5ZSTpI8Kks8W9gI1tEAUWL
   DBEZEfvOTXOcNvygQmHMFShK1JBSf0W0G69vLsx3eb63fIcTNYVJNiebV
   ffm5whebgk33KOBgggDsp+Dq1Ep+sJGt0jYySExOsdtBCDerjFQVJjEZR
   w==;
X-CSE-ConnectionGUID: +0rzTTAvQbSKK1R70/0IVQ==
X-CSE-MsgGUID: LAL5gayGTjWFIeGIlBM7ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="69647077"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="69647077"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 18:49:59 -0800
X-CSE-ConnectionGUID: MZYcnEf9R3K4ZNCITvmalg==
X-CSE-MsgGUID: qJ1axJZvShCPEE6KzU/tRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191994606"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 20 Nov 2025 18:49:57 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMHDe-0004rk-3A;
	Fri, 21 Nov 2025 02:49:54 +0000
Date: Fri, 21 Nov 2025 10:49:53 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jann Horn <jannh@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: error[E0609]: no field `vm_mm` on type `bindings::vm_area_struct`
Message-ID: <202511211004.JW70Scx4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: EFB1120002
X-Stat-Signature: h6aqwygrmk8r895z4aj3t6g54jcq31mp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763693400-631320
X-HE-Meta: U2FsdGVkX19OrEAhZixHE1AyDgoiyrI74c4L/FaHlttEIR2SpbH6VWmjzy96JT/p68DDwduL9SW99QYZZGE6PsPPWSlUe81Xv6Yx+3LavvXpN4/wwqUAYgnXP+RujbwWHy2Uzjr02gmcvLqeSjn5Ke0y1EqZjxYz/7fK/S7IbUoCv0znj1Q8kAAMJhlayZ513P2WhMpuS5lhv60ev+vXdjPQy9ug20kZ/fMF2QvRlKGnbrmAVmbNKGRLW3dMMa0xxqfqK49In6tVhZCiDYcEJQFPa2RntDFMo7Vt2j9fj6dUn3+mEk8qxQRSz6+L1o4Z2QJY2GzH1aVw1B1dQjLn/ELfSPYF7QRjEm5x2JOqHadaJz1jyDcz/7VXF0K22v1wkp8+Y1Qz93N/aNqEKyFY+Hgt+wXajOSs6uK5+8KJkMwHzERB4hmoT7e6uMlkEXWqVbiL7pYTNXd0muVJ1IWzM7jrfYNI6FP8/9/S0pNyJVIuIhsE0JBYCS88Iajb53VXSGff6/7ie6lXZDbn6KQOVUzkyQ7usO0vRNPBwMMVuPKcs+Gs8MuF7BrT6h07e09CzD5bIMDQ8Vl2rk4W9+GuV8hwV35CIwH4yaiYdmkMkjqgQHeP0f83iwAVgaMoSupp4FfQ2/lwWrmLwuL5GtJXIXrqy4so74Wygu3HNKgES+kPiLimTK3wMUtOikJuCOvnOymTnV3xofbju61y9Qm+u40h/JwSKM/wIykfQHGm1iVcFFMcGIt9B3s6J5dIvDi1mWgWwuwS0kILtRB+HC/W8qIlxFXSOXbVYOXT6G6YbpekUWhzwjC+qpGOW8onaTSVcMCMkwAPJHamWr36welVRa2U/z81lNKrRioi8u+hYHTbW1ekeXKFkQbtAL2faLPANkTlKpmUtuGgdJLtjhy06NUYSFsw5/81A5b0jKNxcGKe0+RkHh/X4qjfxg6KmEVfzgLjH42c/2fMRJvm/zQ
 swDTIFq/
 HYC63UFKyCw60lxJ695xpRAoiZqmXKMNE3gze9ZfCGyysvP96oJd/z1KCV/ByPc8uig/xSgfIs+YXGhDd2h53wQkLnI4+xVMI52iAIyLRDTTaRTqnacC9jZ7Wl3foU2mOA6Nh5Ai5rQZpjVtF8evRIWHYfvteNj8bYSfS6DiiwLzX/rB7gEPIjIYXL1AvqJ4kH4ySWxddU/HgObH4s/ERw8sdTm9vH1WBGhBeNH2b9/sk+zZXMgYxaChNjjUwlveVs5KPVnv6vggIjf967AXe7nNWjEyBTV2F1SMyYYyvMhYnY0K/TXbgolQDLxxlx/iY4FtqyUx8Mnb9YxhVdifM7cexjHofnm5Z7CuCbvYGZdkFSRv9i3KM8caTxZozTRQfUON8UgIFtPt3QBB/6KFN1iexYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   fd95357fd8c6778ac7dea6c57a19b8b182b6e91f
commit: 040f404b731207935ed644b14bcc2bb8b8488d00 mm: rust: add vm_area_struct methods that require read access
date:   6 months ago
config: um-randconfig-001-20251121 (https://download.01.org/0day-ci/archive/20251121/202511211004.JW70Scx4-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9e9fe08b16ea2c4d9867fb4974edf2a3776d6ece)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251121/202511211004.JW70Scx4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511211004.JW70Scx4-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0609]: no field `vm_mm` on type `bindings::vm_area_struct`
   --> rust/kernel/mm/virt.rs:58:56
   |
   58 |         unsafe { MmWithUser::from_raw((*self.as_ptr()).vm_mm) }
   |                                                        ^^^^^ unknown field
   |
   = note: available field is: `_address`
--
>> error[E0609]: no field `__bindgen_anon_2` on type `bindings::vm_area_struct`
   --> rust/kernel/mm/virt.rs:68:35
   |
   68 |         unsafe { (*self.as_ptr()).__bindgen_anon_2.vm_flags }
   |                                   ^^^^^^^^^^^^^^^^ unknown field
   |
   = note: available field is: `_address`
--
>> error[E0609]: no field `__bindgen_anon_1` on type `bindings::vm_area_struct`
   --> rust/kernel/mm/virt.rs:76:35
   |
   76 |         unsafe { (*self.as_ptr()).__bindgen_anon_1.__bindgen_anon_1.vm_start }
   |                                   ^^^^^^^^^^^^^^^^ unknown field
   |
   = note: available field is: `_address`
--
>> error[E0609]: no field `__bindgen_anon_1` on type `bindings::vm_area_struct`
   --> rust/kernel/mm/virt.rs:84:35
   |
   84 |         unsafe { (*self.as_ptr()).__bindgen_anon_1.__bindgen_anon_1.vm_end }
   |                                   ^^^^^^^^^^^^^^^^ unknown field
   |
   = note: available field is: `_address`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

