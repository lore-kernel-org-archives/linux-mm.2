Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF15CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 17:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E27A8E0092; Thu,  9 Oct 2025 13:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393988E0010; Thu,  9 Oct 2025 13:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281D38E0092; Thu,  9 Oct 2025 13:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1018B8E0010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 13:43:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6DF288462
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:43:16 +0000 (UTC)
X-FDA: 83979297192.03.B51B0A8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C03BC0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:43:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RZ6+RAJY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760031794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rm6API5iGpW76jbuXEpCupir4QRNMlWgwBUhzEruU6Y=;
	b=1UpxmRqA8rEs9W7XoNty2DW19rEmdCmIlVXsV2lrbJQNDqGymeM6hBOmetBjyWJ2uPG5iu
	JC/El0pdCpbdxEhQCvJkejppt3gEanWwMLMhzP/eB1AmC5T11+s36Qq8KF08qwCHU8JueY
	Sl6fxDlLZbGdfjIhr/PMK3GUfvE+vk8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760031794; a=rsa-sha256;
	cv=none;
	b=NWeiAVLJQhUzvUm9AoigA+WREiqdlB7fp8y9LPv/0WlAoBen+PTIYT40ldwIJiB8eccucA
	bDm+feDEhXy+WAIj48JcvNCduGr3lM/dJSBNQ2hEEzlFYAKnYjLRbcgT7U8vyu/q09FZlK
	UAe5XndL3dSmbSzpXPdqVvIR5Kh6ozE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RZ6+RAJY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760031794; x=1791567794;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=+qAPM9tuiSbTcVyAJUug89S6DZoXfhdpy0E/n+ZtWSw=;
  b=RZ6+RAJY2hzySwEmXl0JVW0JhotKy76xguAXfFa1Dni20Tg+ikL63nni
   1COjCmrnGHmaRhdSntRCUs+56IUGqmCQ0lfYhE6jMQBc2EH6fY/5Li4OU
   X7J813iMC4RwamYSqd54D2Xv0zvv2Q10JtcibkLOrj1adfI5YCBNiXNtq
   kS8RavcbC8+C1wDy3Q1uQkAC6rGRurLe/HG8K+Wi2kCZ/yinZ5urjaZfB
   5P+6XRdHuZgLKN+yzlBWKPzpmLdyW3lvkI+pvNHRJtxaAmQ/06Ia2NzNw
   D3SLRB9IXlYqX45J2Th/XinfE/8bIz1yJ9YSEAOZIEnnJE4eqB5u1M8DR
   g==;
X-CSE-ConnectionGUID: W84v42DqQt6vCTsv1BFI3Q==
X-CSE-MsgGUID: rO7wcIRDQrSqge46D5Szug==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62347851"
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="62347851"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2025 10:43:13 -0700
X-CSE-ConnectionGUID: BINDzVwwRE2Qhre09P4kmA==
X-CSE-MsgGUID: v61HicyTSy68d/g6eorPgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,217,1754982000"; 
   d="scan'208";a="185158028"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 09 Oct 2025 10:43:11 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v6ufV-000187-1y;
	Thu, 09 Oct 2025 17:43:09 +0000
Date: Fri, 10 Oct 2025 01:42:21 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Acs <acsjakub@amazon.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ` in
 crate `bindings`
Message-ID: <202510100127.yuqhg8uo-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Stat-Signature: 9e3trt7q5cgxtnmfiqu5q3b9o7xc8bfm
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C03BC0007
X-HE-Tag: 1760031794-888151
X-HE-Meta: U2FsdGVkX18BKArLn46+RPeKZ7wpP/gX4GV67oxidFq/GFNIjk6vodLASOj5kBVt9cWMXCYwD0o0TcnBDNkrYGjh8eKd4Qi7QY2KCM83iceYArT7WzBQRek4RX6BOTAzfunLwF7A5y62iceoBtxb8DhgYYgAhykbkSw2CDz/JX4eNQ407glvUg7ayUL7WHOg1fM3HDQkbra+g7K0kJVxXMyHacEzgBoYAYODXFAhH6faYqH4aaQUYbiX8ViUC8I9SjI7tySwggZkqlFsMYJSB23tuAOkX6ZqtI3BgMBEIoeDJsSSNfkrN4Fa3AnqDOF1vvhLTUrrOPLHUCbaYtjmQKfz0pBqvKYmg1QiMqDkbu5/GRbgZ7gK2/N+959ZG5IJmrGdyj78hCRdQjI/+KAX2LYVQHcSIBJzgRJ1iajH7OwoMjvIEeD+rAAP9y0CXyt3NlEw0Frx7dKiq3M/sd0N9iEZtu7UTpBk3iiSrGj21uJOvhJMOobRv44+0C9lzObh7y3qhgSJcN3sYPqZdJrjwlUPlCqNXPGeLl8QLgAQQZwUe2kdN2QvSUhYgGQ+QAUEx8PRsU854BvEVO9rtwGgcqxgPHZ/VWIIXqIzBgfmuSeOk1rc7L+d4xzvbDEd4TcwkohBD6oGCXW6Vrwz+q3dy2+Irc/5oQIAeMtdUSW3Dev3o+rtB2ZCWzWOjAuMAikG0fZuUbhUFGHvDPLs4HAG0k0JaX2s7pbkEyGZUYExSJWzbovR+ZS+gqwQLBRU4PqURMpPCc9FF4GRf2oHVD/rmM8urJq8jd6vRtDMjPoJMSvdeoBNtj1xK309MoRPdEz9r6BCF4ilhLw2ab5+Dk2huudQjiNka0N1nZW7pZURQIiIt1h9osLmuZCT46TvCaLWGIrkdieCG/sQTElbUPTShcVLHSD1Fk21TTIrdrvfMvTNUQOgM+ZYpVr9ugKIZGxRGJXVjt9jqj6XbjaDwUO
 3tYha/MU
 nDBEvBzQcvpoAh7ivL3TIanDPWerljJ4zYE8MO3saBjOmrRKCFAfshOVSu9l2y07oHGNIXDdChXCL3kg0j54As3wISYlqstD6gRyaNcEZBkdjesuGaJS01Z7WRVXpNkaaHNu5IRWSZyFdQs6kU7l7uuwb73vC5qmKRvWKxM3YvVMWcZA1LBA89q/cX3sskD+BPSKygG1QS1tgmtby1ZVVqsNLqK4EI/9V1ixve0UP7tnO7fE0fh3lQgmoiI5DYeoqzqNUeC21/tEpnyPGrxZZCPmHIpwBNoqk/s5nfn5I6qNZz6t/bJfzdh79pYZSgrrNeRI8/h+F/IrOfN9r66wiyR+BHMDRldYQbnZeKa3mkwgHYjkt9eQbtO48EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jakub,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   70478cb9da6fc4e7b987219173ba1681d5f7dd3d
commit: da4dbad77af8cc850a570fd05455369cc12b0be4 [36/102] mm: redefine VM_* flag constants with BIT()
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20251010/202510100127.yuqhg8uo-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251010/202510100127.yuqhg8uo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510100127.yuqhg8uo-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/sched/rq-offsets.c:5:
   kernel/sched/sched.h:3743:18: warning: variable 'cpumask' set but not used [-Wunused-but-set-variable]
   3743 |         struct cpumask *cpumask;
   |                         ^
   1 warning generated.
>> error[E0425]: cannot find value `VM_READ` in crate `bindings`
   --> rust/kernel/mm/virt.rs:399:44
   |
   399 |     pub const READ: vm_flags_t = bindings::VM_READ as vm_flags_t;
   |                                            ^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_WRITE` in crate `bindings`
   --> rust/kernel/mm/virt.rs:402:45
   |
   402 |     pub const WRITE: vm_flags_t = bindings::VM_WRITE as vm_flags_t;
   |                                             ^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_DONTCOPY` in crate `bindings`
   --> rust/kernel/mm/virt.rs:429:48
   |
   429 |     pub const DONTCOPY: vm_flags_t = bindings::VM_DONTCOPY as vm_flags_t;
   |                                                ^^^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_DONTEXPAND` in crate `bindings`
   --> rust/kernel/mm/virt.rs:432:50
   |
   432 |     pub const DONTEXPAND: vm_flags_t = bindings::VM_DONTEXPAND as vm_flags_t;
   |                                                  ^^^^^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_LOCKONFAULT` in crate `bindings`
   --> rust/kernel/mm/virt.rs:435:51
   |
   435 |     pub const LOCKONFAULT: vm_flags_t = bindings::VM_LOCKONFAULT as vm_flags_t;
   |                                                   ^^^^^^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_ACCOUNT` in crate `bindings`
   --> rust/kernel/mm/virt.rs:438:47
   |
   438 |     pub const ACCOUNT: vm_flags_t = bindings::VM_ACCOUNT as vm_flags_t;
   |                                               ^^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_NORESERVE` in crate `bindings`
   --> rust/kernel/mm/virt.rs:441:49
   |
   441  |     pub const NORESERVE: vm_flags_t = bindings::VM_NORESERVE as vm_flags_t;
   |                                                 ^^^^^^^^^^^^ help: a constant with a similar name exists: `SHN_LORESERVE`
   |
   ::: rust/bindings/bindings_generated.rs:8477:1
   |
   8477 | pub const SHN_LORESERVE: u32 = 65280;
   | ---------------------------- similarly named constant `SHN_LORESERVE` defined here
--
>> error[E0425]: cannot find value `VM_HUGETLB` in crate `bindings`
   --> rust/kernel/mm/virt.rs:444:47
   |
   444 |     pub const HUGETLB: vm_flags_t = bindings::VM_HUGETLB as vm_flags_t;
   |                                               ^^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_SYNC` in crate `bindings`
   --> rust/kernel/mm/virt.rs:447:44
   |
   447   |     pub const SYNC: vm_flags_t = bindings::VM_SYNC as vm_flags_t;
   |                                            ^^^^^^^ help: a constant with a similar name exists: `O_SYNC`
   |
   ::: rust/bindings/bindings_generated.rs:10666:1
   |
   10666 | pub const O_SYNC: u32 = 1052672;
   | --------------------- similarly named constant `O_SYNC` defined here
--
>> error[E0425]: cannot find value `VM_ARCH_1` in crate `bindings`
   --> rust/kernel/mm/virt.rs:450:46
   |
   450 |     pub const ARCH_1: vm_flags_t = bindings::VM_ARCH_1 as vm_flags_t;
   |                                              ^^^^^^^^^ not found in `bindings`
--
>> error[E0425]: cannot find value `VM_WIPEONFORK` in crate `bindings`
   --> rust/kernel/mm/virt.rs:453:50
   |
   453 |     pub const WIPEONFORK: vm_flags_t = bindings::VM_WIPEONFORK as vm_flags_t;
   |                                                  ^^^^^^^^^^^^^ not found in `bindings`
..

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

