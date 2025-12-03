Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78920D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 05:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1B56B0011; Wed,  3 Dec 2025 00:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81636B0012; Wed,  3 Dec 2025 00:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71016B0023; Wed,  3 Dec 2025 00:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92A386B0011
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 00:55:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B49658EB7
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:55:25 +0000 (UTC)
X-FDA: 84177097410.03.10F8AC5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 130401C0004
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 05:55:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SwiZw8Vf;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764741323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TgeU89wiO33UrOeH2CuuCcfCtsghV3K4O/7YtJ6+HwU=;
	b=6/j2e4Apm8W3Ste/mlcI4K6vVuqnP2egIfnPKHMbrMDga0ybCGw1mUl8IGTFe7awsidbTY
	UUSlvj6KBjprqYAmvdiNdbk+H/rFWPRG37oqf+LDE3tsx6rTzJ4faeXTNplNFRPe7qsyET
	nc1cSY6PXaxmN8noewppyl+jlhniTDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764741323; a=rsa-sha256;
	cv=none;
	b=K1iya9eZ4t06x7w5v8zAU/h552jyUAfGAdy+9Xbf85VUzl9QXfzIjxoYuBjmdp3A28QGwv
	wNuOPigHFpqpRDjIc2GVBxOitLsdFjUQQ+Mt+WPj2eLxmHI5XQ21iOcSdgnMmCv6WwFWmJ
	YpPtsfPKDRAmlnaCRHAeStlR45+Rgzo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SwiZw8Vf;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764741322; x=1796277322;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=U9cruv8p0jaO2ym/HzJO6H0i8CLbx9AQJ+UaaEtZpT4=;
  b=SwiZw8VfXykjazUfYdJzY99lB7KHz8V9POl37DNCE04Vyds/72bbFcWt
   YBVq/gcHUaTf5UowSZzOW2ZIzi0BKktTAYVoN84jWJ63tcrr5IG0ZHV7C
   DrKuuZRZtPzinAjaL9AcwRzLUlPdqGNQkr91K4uBzsopdviq/RTBi92B6
   dlDESwJZlcx9buDMY7slKvECe+sL0srgdR53U7UGtzlUJXUV0jN086Ktf
   3S77FfFtOKAe3Q8nNQUSlSwiRU5drZOPGW27lttyNvIouhtN+tRyZhFEQ
   mwArfjK0mRyk09xSebqemBNNTc1JeUjDpko5zh4Ll1pjk4zaaNcYxTMQw
   Q==;
X-CSE-ConnectionGUID: kS3dH3zGQF++LYK5lkR+Ig==
X-CSE-MsgGUID: llT/HTIdR76MLhnFDlggcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66891580"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="66891580"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 21:55:20 -0800
X-CSE-ConnectionGUID: eKTMhSavS8ScsZUjGPmRvQ==
X-CSE-MsgGUID: ITaWRu3CTIW1a9MG70qPWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="194680709"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 02 Dec 2025 21:55:19 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQfpb-00000000Adi-26Og;
	Wed, 03 Dec 2025 05:55:15 +0000
Date: Wed, 3 Dec 2025 13:54:20 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jann Horn <jannh@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: error[E0609]: no field `vm_mm` on type `bindings::vm_area_struct`
Message-ID: <202512031349.FAjXZLVU-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 130401C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: dueqjpxj6ggmju87pirtiqu551prcst9
X-HE-Tag: 1764741321-151634
X-HE-Meta: U2FsdGVkX1/Qm6JL7mpGFLc5bvA1wgzIJj5N7PqbT94+IoujHpyC+2nyAMc0we7cTwLymy/oppbklVPxXaK/KKzJLFNobemiuRpODmGTz7mTxl/IkHOkZnTUmzf7Nor9I38gAKMi+HxQL0ARc3sc6Nbyzh9muHB9NkkaE/yv3nfDnQ+RtRKljdCcvtUn8DMnvXsvAx7MHzvMsBdCKXN6PccIgRXf47OJ2bPfAh4alQKHkoM768Wfg+7gqrJG4kdu+okOYwPy6mtoFq/hMauyDT/aGW9/StdVYv9oZY9qAnNw2Pd+9LEtH/K79EmRm2UQ5znDg0Kq6M42sZexNS+cKApr28BxweVlOR2g5XfGPpjaDiecGAqzTW/ueuWeOGJA2YAY7bV26dUWN80aQLnsEOEXa0P09BOhqm91WqiLCpkW8HgGRTsdkvTT+5GCp/z8bHDwPBArVQB4WpfT9P4wU+17WfVFzs058/KcitvryS+yMTA1osNmVUH8ufB72V7be19FleTvP7meg+7JTwLlIf1Ol4u712qM5HbvjA6j4Kqb8NvNLq6JxbRekU4HdOUKCR4hVrE+qRZviwlm5m0zT8OAkkujIIRXj8YXcUL43z08IpzLs/GB/BGQiLqtkprA0qLEcY0R+fS+xZsEETjWboBkzB4JxsYQ1ZVPM1BKRXFDwDpi67PxZphJGbqTWeGuRuSCPgnuc4bqrGF/r9/5wUcctNSLUHjlJjOSdpQDRzj+XYXHCU0op59CH6B5EnlRYcRcLqrfqmD6p42veUMVPjQ443Sj0PMnyU1EtSIzFhHocuaNNeWlsLz6QecwaVA4MOyDSi8Kn8n3xVP+flK1ABXN7GiwqP6zeQlMHu+ry9Ayf5rFPt/9XGdu9TcNC9NpKlkqLVgrLFbGLXR6jzjJDIk6A2TQbcfcPFSUP2C1JCIyNP2hz/U50JiGYvSEG76z6Yv0v4IYU+JE4EwMX1V
 YzgyNiz+
 iHv/bjw48IxRV0hkBV0vfDA7VIBNt5snwssr92otseKEqOJUzme/NMlICVhBWStGEk8M4cUbqoD+b9JWC9q6tncQ/7srtYrZLQPNfy1RUokmEsQy6BcNK+C2TY3+93CiM22D0HSm5rnrIHCAMvrrRgSeMBl9iRZg1vVR86mQq67atHll/IeQw+HovoWac28PitAXQlW+8roemYZdZJ8KmF3EQzTogvrAXXnEKlSyCcIWLYyDtUXnDs9yU1Lk3Qi6lYUvhsF6YIbRQJavCpOHq9P6sfB1RQ7O7Duo/lL62cnY14XpLcki+iOifaAVgSowGxtrLKJFQJq3QPm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3f9f0252130e7dd60d41be0802bf58f6471c691d
commit: 040f404b731207935ed644b14bcc2bb8b8488d00 mm: rust: add vm_area_struct methods that require read access
date:   7 months ago
config: arm-randconfig-r121-20251201 (https://download.01.org/0day-ci/archive/20251203/202512031349.FAjXZLVU-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project b3428bb966f1de8aa48375ffee0eba04ede133b7)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512031349.FAjXZLVU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512031349.FAjXZLVU-lkp@intel.com/

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

