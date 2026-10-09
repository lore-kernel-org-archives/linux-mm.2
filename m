Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290FCCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 04:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22766B008A; Fri,  9 Oct 2026 00:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5556B008C; Fri,  9 Oct 2026 00:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1E66B0092; Fri,  9 Oct 2026 00:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9000E6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 00:05:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F5F01C2775
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:05:51 +0000 (UTC)
X-FDA: 85301749302.24.4A8C5BE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id E949F120008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcujubUb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791518749;
	b=6yAhUaXuqt3/G8eNX1DCycnLk5bO2Hubp+wmeL5IU/b5po7YNf2kgYq2WjdZdDIA9yUJg3
	RrjEl9+5ymnCFxR25/VhP3vxsbdrcnaXzh99csEGGRcNHdwiIRgM091nmqVr9CJkkfH93f
	HsCPL4bod9e+7Ry+yIE3KvJTjFCrKqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bcujubUb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791518749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=k7kXgRjaxMrfUfMk/7wilqvwx6qXDNf7CXbywIXcA0w=;
	b=HYqTs/Co7BWPKiEu2VOLAIn6smFf6+5sUVkR7NXVTFuUXPXswd+g4hS7+tQ0fHAivz+Dd/
	ji4eiQ9RsRIDeeL9ArelTT+PeAuh0BiQPIOvq4929tKGiuBiibvlzeeJmiqIkjRVa8Mliw
	+m8TcRbqQYpnbF09tM0Nmi5UVGP///s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791518748; x=1823054748;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding:in-reply-to;
  bh=I1BXP/Tpqp4ETqFVmqrX8cQ8bLthe9xiOaA+MQbaqSo=;
  b=bcujubUbYNALx6SFmK50eiy98rFdyH0uHByYb9OVOzk449be/Kw3uiij
   usZBVRYxTKnESj6PoQqXSyENsq/9FQkDFmsDA/jXwG15Sw+y9N3up2A4X
   5VgVwR4ILtYXOUrUS/KeD5tcQRwd2MbRVUeg9mse2eqTKmffTXnL3QFXF
   R1jct+AVO/NQTt5TQRHdSjINPMGUYGh7FbSLMyESzVRQKYWYR2Jx9r6cK
   WdG2fhJRBmTUDxKlZVM/hvoTZ1/xvpPtsnU6da1HmuNF1qXffFE52UU14
   DHJ4nJrKa/dRPVmxvMWegnyc6zTAKS+y7wvoSkxLZWRTKgD/wbJpHdtIf
   w==;
X-CSE-ConnectionGUID: 5q2iCmHXSvytwVwAU4HzLw==
X-CSE-MsgGUID: ues/d9vHTeyqYfcE8yvARw==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="192701"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="192701"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 21:05:46 -0700
X-CSE-ConnectionGUID: cQkUjz9aRPio1SLvh9m57g==
X-CSE-MsgGUID: /mylW4+xR8632V+dILFP4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="204660"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 21:05:43 -0700
Date: Fri, 9 Oct 2026 12:05:39 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Park Tae-sun <ts930@dgu.ac.kr>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
	ltp@lists.linux.it, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org, Park Tae-sun <ts930@dgu.ac.kr>,
	yi1.lai@intel.com
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <202610091104.927c0472-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179066531783.50175.13377521828379196177@dgu.ac.kr>
X-Stat-Signature: kewzggrqd9j9qb448qbadyemn6fmim1i
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E949F120008
X-HE-Tag: 1791518747-278136
X-HE-Meta: U2FsdGVkX19V44b5bEmyAAVBeeDy9KuMR782MD8li1PNhIAOTE/kRvxR0qUiED11sk1vm6OK2y1XYVZVnm/fHZaJmzwnVhKYkEIay1GARmKolN0qbkL2SAx823Ac1unmWDRMhHB0Gu6xRKrGNnIgb3SzKZovUv7boEwykcevS25X7a+JjVIvMbF0TS8IoRSlX0iKQmUKplCw7LFtPAMn4MzLO4AXxZhkmdWazxkXuLEURtrtfBDAqr7N+x/DgAwqJd5yBGJzSVRJ91raFYXfywNV9hl4Lv/5NGviF/JmM4iY4I+wb6nFUHWrSvNVoY7pH93w7EX2DLVyt1/cFmUoGWsEAHDKI4bjCLBbmV3nH1wtEIWe2mxxnJAQJKRlrlT83nZXQZDTK2v0R0hoIivKf8oWzfJFaD0jb63SsZ2z4UeGe45u527rHbas479UxTsN6lJSF6xw/vkuuVGnSoq+enAVRD2JvPkwzgLxVtxbLEudDbj29EGj7hGl5PVwk6keG8i9qDiy7Mo0Q5CnJZy7DSzD+44bSfCsfr/6hTudbnQfnLf+1XdvXE/YL+Ip3z6pA469wfKXsFmK+17ybmAdozSVU4mTiuV/ycyhTVJEtTholnyeoZTtEnJF+WjWJ3NypORqGZtqHdR3Xi4jSTzx8aSaZDGjn3U/cZZpTA1N+/hbxjI+EEHzxnLOG2tcFOmInGsqPdaMwN4cyLb2J2xYEaxO3uufmVoXRgW6yAuOwBxYvp3lAcjMj1DbLErcaP3y0v9LWjEH7AUw9NN2UqokbbCcx7pR93a2OY59YuiEz1LoH9FvA1dzC/famfhNyDCsCMOPSXEUeJjxqc2FSqdrYaat207DG5kgQdwefs7LXdaCVrI7gah97w2FGVnxDt2e72dYKE5w3nAeBJVRUyE1XeAXNIySCbdUnVn+DOWBjFQPOtfH5mt9YIivjCRVsg5UG9DG0BuBXdDXutY8IAv
 8KxQZhbh
 PQ3qoJpwdj+MmLTRGWxJS1MPV0LEIhUDPeq2yCEUP5vDTJaCgPpuFakGtlLypN+QDTjPOjk55BlA1QiVISOu70m0ht3ewjenYksIoOurE29UHUVJWFncZYX8uVozfLnHIsDAEHnSviX2Z61E0ac+CGHhaiNElELWSuMnatuw9P4NoWdw8ZiX9gNCZZUPzrwU9W2Qchsf3eVPmgbuvbhXKQRoOPkpORfsHERgWIZzHWz8N1MmD00a32OdW2zcQPLSE8oHP70MLtDPdYQAJq7NkbEI4e21im9BGipdK456Mmzej1rufzqnE3F5vHKRxhaBHnhpvgoucHQBOqOioUuML770RinoYczomUIRp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

kernel test robot noticed "ltp.mlock02.fail" on:

commit: 04f914e0ef30c5119e204bdea0db05ec16d5778b ("[PATCH] mm/mlock: fix zero-length request normalization and integer overflows")
url: https://github.com/intel-lab-lkp/linux/commits/Park-Tae-sun/mm-mlock-fix-zero-length-request-normalization-and-integer-overflows/20260929-145634
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-everything patch link: https://lore.kernel.org/all/179066531783.50175.13377521828379196177@dgu.ac.kr/
patch subject: [PATCH] mm/mlock: fix zero-length request normalization and integer overflows

in testcase: ltp
version: ltp-x86_64-0596b09f2-1_20260926 with following parameters:

	disk: 1HDD
	fs: btrfs
	test: syscalls-03


config: x86_64-rhel-9.4-ltp
compiler: gcc-14
test machine: 4 threads 1 sockets Intel(R) Core(TM) i3-3220 CPU @ 3.30GHz (Ivy Bridge) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610091104.927c0472-lkp@intel.com


PATH=/lkp/benchmarks/ltp:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/lkp/lkp/src/bin
2026-10-02 22:24:50 cd /lkp/benchmarks/ltp '/lib/modules/7.3.0-rc4+/build' -> '/usr/src/linux-modbuild-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
2026-10-02 22:24:51 make -j4 -C /lib/modules/7.3.0-rc4+/build M=/lkp/benchmarks/ltp/testcases/kernel/syscalls/delete_module KCFLAGS=-Wno-implicit-function-declaration -Wno-int-conversion
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
make[1]: Entering directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/delete_module'
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: gcc-14 (Debian 14.2.0-19) 14.2.0
  You are using:           gcc (Debian 14.2.0-19) 14.2.0
warning: pahole version differs from the one used to build the kernel
  The kernel was built with: 132
  You are using:             130
  CC [M]  dummy_del_mod.o
  CC [M]  dummy_del_mod_dep.o
dummy_del_mod.c:20:5: warning: no previous prototype for ‘dummy_func_test’ [-Wmissing-prototypes]
   20 | int dummy_func_test(void)
      |     ^~~~~~~~~~~~~~~
  MODPOST Module.symvers
WARNING: modpost: dummy_del_mod.ko: missing MODULE_DESCRIPTION()
WARNING: modpost: dummy_del_mod_dep.ko: missing MODULE_DESCRIPTION()
  CC [M]  dummy_del_mod.mod.o
  CC [M]  .module-common.o
  CC [M]  dummy_del_mod_dep.mod.o
  LD [M]  dummy_del_mod.ko
  LD [M]  dummy_del_mod_dep.ko
make[1]: Leaving directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/delete_module'
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
2026-10-02 22:24:54 make -j4 -C /lib/modules/7.3.0-rc4+/build M=/lkp/benchmarks/ltp/testcases/kernel/syscalls/finit_module KCFLAGS=-Wno-implicit-function-declaration -Wno-int-conversion
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
make[1]: Entering directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/finit_module'
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: gcc-14 (Debian 14.2.0-19) 14.2.0
  You are using:           gcc (Debian 14.2.0-19) 14.2.0
warning: pahole version differs from the one used to build the kernel
  The kernel was built with: 132
  You are using:             130
  CC [M]  finit_module.o
  MODPOST Module.symvers
WARNING: modpost: finit_module.ko: missing MODULE_DESCRIPTION()
  CC [M]  finit_module.mod.o
  CC [M]  .module-common.o
  LD [M]  finit_module.ko
make[1]: Leaving directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/finit_module'
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
2026-10-02 22:24:56 make -j4 -C /lib/modules/7.3.0-rc4+/build M=/lkp/benchmarks/ltp/testcases/kernel/syscalls/init_module KCFLAGS=-Wno-implicit-function-declaration -Wno-int-conversion
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
make[1]: Entering directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/init_module'
warning: the compiler differs from the one used to build the kernel
  The kernel was built by: gcc-14 (Debian 14.2.0-19) 14.2.0
  You are using:           gcc (Debian 14.2.0-19) 14.2.0
warning: pahole version differs from the one used to build the kernel
  The kernel was built with: 132
  You are using:             130
  CC [M]  init_module.o
  MODPOST Module.symvers
WARNING: modpost: init_module.ko: missing MODULE_DESCRIPTION()
  CC [M]  init_module.mod.o
  CC [M]  .module-common.o
  LD [M]  init_module.ko
make[1]: Leaving directory '/opt/rootfs/tmp/keep-initrd/lkp/benchmarks/ltp/testcases/kernel/syscalls/init_module'
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-9.4-ltp-04f914e0ef30c5119e204bdea0db05ec16d5778b'
2026-10-02 22:24:59 export LTP_RUNTIME_MUL=2
2026-10-02 22:24:59 export LTPROOT=/lkp/benchmarks/ltp
2026-10-02 22:24:59 kirk -f syscalls-03 --tmp-dir /fs/sda2/tmpdir Host information
	Hostname:   lkp-ivb-d04
	Python:     3.13.5 (main, Jun 13 2026, 14:18:01) [GCC 14.2.0]
	Directory:  /fs/sda2/tmpdir/kirk.root/tmprsp5n38n

Connecting to SUT: default

Suite: syscalls-03
──────────────────
 [1;37maccept03:  [0m [1;32mpass [0m  (0.056s)
 [1;37madd_key01:  [0m [1;32mpass [0m  (0.032s)
 [1;37malarm07:  [0m [1;32mpass [0m  (3.021s)
 [1;37march_prctl01:  [0m [1;32mpass [0m  (0.038s)
 [1;37mbpf_map01:  [0m [1;32mpass [0m  (0.031s)
 [1;37mbpf_prog02:  [0m [1;32mpass [0m  (0.026s)
 [1;37mbrk02:  [0m [1;32mpass [0m  (0.032s)
 [1;37mcapget02:  [0m [1;32mpass [0m  (0.023s)
 [1;37mcapset03:  [0m [1;32mpass [0m  (0.026s)
 [1;37mchmod08:  [0m [1;32mpass [0m  (0.025s)
 [1;37mchown02:  [0m [1;32mpass [0m  (0.033s)
 [1;37mchown04:  [0m [1;32mpass [0m  (0.035s)
 [1;37mclock_nanosleep04:  [0m [1;32mpass [0m  (0.071s)
 [1;37mclone304:  [0m [1;32mpass [0m  (0.043s)
 [1;37mclose02:  [0m [1;32mpass [0m  (0.033s)
 [1;37mcreat03:  [0m [1;32mpass [0m  (0.034s)
 [1;37mcreat05:  [0m [1;32mpass [0m  (0.104s)
 [1;37mcreat09:  [0m [1;32mpass [0m  (2.213s)
 [1;37mepoll_ctl03:  [0m [1;32mpass [0m  (0.038s)
 [1;37mepoll_ctl05:  [0m [1;32mpass [0m  (0.031s)
 [1;37mepoll_ctl06:  [0m [1;32mpass [0m  (0.031s)
 [1;37mepoll_wait04:  [0m [1;32mpass [0m  (0.028s)
 [1;37mepoll_wait16:  [0m [1;32mpass [0m  (0.038s)
 [1;37meventfd01:  [0m [1;32mpass [0m  (0.032s)
 [1;37meventfd06:  [0m [1;32mpass [0m  (0.062s)
 [1;37mexecve02:  [0m [1;32mpass [0m  (0.052s)
 [1;37mexecveat03:  [0m [1;32mpass [0m  (0.514s)
 [1;37mexit_group01:  [0m [1;32mpass [0m  (0.134s)
 [1;37mfaccessat202:  [0m [1;32mpass [0m  (0.026s)
 [1;37mfallocate01:  [0m [1;36mskip [0m  (12.628s)
 [1;37mfallocate02:  [0m [1;32mpass [0m  (0.029s)
 [1;37mfallocate04:  [0m [1;36mskip [0m  (13.159s)
 [1;37mposix_fadvise03_64:  [0m [1;32mpass [0m  (0.020s)
 [1;37mposix_fadvise04:  [0m [1;32mpass [0m  (0.042s)
 [1;37mfchmodat02:  [0m [1;32mpass [0m  (0.029s)
 [1;37mfchmodat2_02:  [0m [1;32mpass [0m  (0.024s)
 [1;37mfchown01_16:  [0m [1;36mskip [0m  (0.032s)
 [1;37mfchown02_16:  [0m [1;36mskip [0m  (0.029s)
 [1;37mfcntl02:  [0m [1;32mpass [0m  (0.029s)
 [1;37mfcntl03_64:  [0m [1;32mpass [0m  (0.026s)
 [1;37mfcntl04:  [0m [1;32mpass [0m  (0.030s)
 [1;37mfcntl08:  [0m [1;32mpass [0m  (0.029s)
 [1;37mfcntl13:  [0m [1;32mpass [0m  (0.030s)
 [1;37mfcntl15:  [0m [1;32mpass [0m  (0.032s)
 [1;37mfcntl17_64:  [0m [1;32mpass [0m  (0.021s)
 [1;37mfcntl19:  [0m [1;32mpass [0m  (0.024s)
 [1;37mfcntl20:  [0m [1;32mpass [0m  (0.015s)
 [1;37mfcntl20_64:  [0m [1;32mpass [0m  (0.025s)
 [1;37mfcntl26:  [0m [1;36mskip [0m  (0.017s)
 [1;37mfcntl31:  [0m [1;32mpass [0m  (0.025s)
 [1;37mfcntl34_64:  [0m [1;32mpass [0m  (0.077s)
 [1;37mfcntl37:  [0m [1;32mpass [0m  (0.028s)
 [1;37mfcntl40:  [0m [1;32mpass [0m  (0.029s)
 [1;37mfgetxattr01:  [0m [1;36mskip [0m  (13.250s)
 [1;37mfgetxattr02:  [0m [1;32mpass [0m  (0.049s)
 [1;37mfork03:  [0m [1;32mpass [0m  (0.034s)
 [1;37mfork14:  [0m [1;32mpass [0m  (6.133s)
 [1;37mfpathconf01:  [0m [1;32mpass [0m  (0.035s)
 [1;37mgetegid02:  [0m [1;32mpass [0m  (0.024s)
 [1;37mgethostbyname_r01:  [0m [1;32mpass [0m  (0.027s)
 [1;37mgetpgid01:  [0m [1;32mpass [0m  (0.027s)
 [1;37mgetppid01:  [0m [1;32mpass [0m  (0.032s)
 [1;37mgetpriority01:  [0m [1;32mpass [0m  (0.026s)
 [1;37mgetresgid01:  [0m [1;32mpass [0m  (0.013s)
 [1;37mgetresgid01_16:  [0m [1;36mskip [0m  (0.019s)
 [1;37mgetresgid02:  [0m [1;32mpass [0m  (0.009s)
 [1;37mgetresuid01_16:  [0m [1;36mskip [0m  (0.018s)
 [1;37mgetrusage03:  [0m [1;32mpass [0m  (0.562s)
 [1;37mgetsockopt01:  [0m [1;32mpass [0m  (0.033s)
 [1;37mgetuid03:  [0m [1;32mpass [0m  (0.031s)
 [1;37mioctl03:  [0m [1;32mpass [0m  (0.040s)
 [1;37mioctl05:  [0m [1;32mpass [0m  (0.412s)
 [1;37mioctl09:  [0m [1;32mpass [0m  (0.426s)
 [1;37mioctl_loop04:  [0m [1;32mpass [0m  (0.160s)
 [1;37mioctl_ns07:  [0m [1;32mpass [0m  (0.025s)
 [1;37minotify02:  [0m [1;32mpass [0m  (0.030s)
 [1;37minotify05:  [0m [1;32mpass [0m  (0.264s)
 [1;37mfanotify04:  [0m [1;32mpass [0m  (0.028s)
 [1;37mfanotify13:  [0m [1;36mskip [0m  (1m 2s)
 [1;37mio_getevents02:  [0m [1;32mpass [0m  (0.043s)
 [1;37mkeyctl01:  [0m [1;32mpass [0m  (0.031s)
 [1;37mkeyctl09:  [0m [1;32mpass [0m  (0.042s)
 [1;37mkeyctl13:  [0m [1;32mpass [0m  (0.020s)
 [1;37mkeyctl25:  [0m [1;32mpass [0m  (0.042s)
 [1;37mkcmp02:  [0m [1;32mpass [0m  (0.019s)
 [1;37mkcmp03:  [0m [1;32mpass [0m  (0.037s)
 [1;37mlandlock09:  [0m [1;36mskip [0m  (0.029s)
 [1;37mlistmount03:  [0m [1;32mpass [0m  (0.035s)
 [1;37mllistxattr03:  [0m [1;32mpass [0m  (0.025s)
 [1;37mlremovexattr01:  [0m [1;36mskip [0m  (12.707s)
 [1;37mlseek01:  [0m [1;32mpass [0m  (0.637s)
 [1;37mlseek07:  [0m [1;32mpass [0m  (0.031s)
 [1;37mlsm_get_self_attr03:  [0m [1;36mskip [0m  (0.031s)
 [1;37mlstat03_64:  [0m [1;32mpass [0m  (1.919s)
 [1;37mmallinfo02:  [0m [1;32mpass [0m  (0.029s)
 [1;37mmallopt01:  [0m [1;32mpass [0m  (0.029s)
 [1;37mmlockall02:  [0m [1;32mpass [0m  (0.015s)
 [1;37mmkdir02:  [0m [1;32mpass [0m  (0.026s)
 [1;37mmkdir04:  [0m [1;32mpass [0m  (0.032s)
 [1;37mmknodat01:  [0m [1;32mpass [0m  (0.021s)
 [1;37mmlock02:  [0m [1;31mfail [0m  (0.025s)
 [1;37mmlock04:  [0m [1;32mpass [0m  (0.034s)
 [1;37mmmap04:  [0m [1;32mpass [0m  (0.031s)
 [1;37mmmap05:  [0m [1;32mpass [0m  (0.028s)
 [1;37mmmap12:  [0m [1;32mpass [0m  (0.030s)
 [1;37mmmap13:  [0m [1;32mpass [0m  (0.024s)
 [1;37mmmap21_01:  [0m [1;32mpass [0m  (0.027s)
 [1;37mmprotect04:  [0m [1;32mpass [0m  (0.017s)
 [1;37mmremap05:  [0m [1;32mpass [0m  (0.032s)
 [1;37mmsgctl03:  [0m [1;32mpass [0m  (0.029s)
 [1;37mmsgrcv06:  [0m [1;32mpass [0m  (0.032s)
 [1;37mmsync02:  [0m [1;32mpass [0m  (0.019s)
 [1;37mmsync04:  [0m [1;32mpass [0m  (12.563s)
 [1;37mmunmap04:  [0m [1;32mpass [0m  (2.483s)
 [1;37mnice01:  [0m [1;32mpass [0m  (0.031s)
 [1;37mmadvise10:  [0m [1;32mpass [0m  (0.027s)
 [1;37mpause01:  [0m [1;32mpass [0m  (0.038s)
 [1;37mpersonality01:  [0m [1;32mpass [0m  (0.053s)
 [1;37mpipe01:  [0m [1;32mpass [0m  (0.025s)
 [1;37mpoll01:  [0m [1;32mpass [0m  (0.030s)
 [1;37mpreadv202_64:  [0m [1;32mpass [0m  (0.033s)
 [1;37mprocess_vm_writev02:  [0m [1;32mpass [0m  (0.037s)
 [1;37mpselect03:  [0m [1;32mpass [0m  (0.034s)
 [1;37mptrace07:  [0m [1;32mpass [0m  (1.565s)
 [1;37mquotactl07:  [0m [1;32mpass [0m  (0.536s)
 [1;37mrealpath01:  [0m [1;32mpass [0m  (0.025s)
 [1;37mrecvmsg03:  [0m [1;36mskip [0m  (0.032s)
 [1;37mrename03:  [0m [1;32mpass [0m  (13.382s)
 [1;37mrename11:  [0m [1;32mpass [0m  (0.427s)
 [1;37mrequest_key04:  [0m [1;32mpass [0m  (0.029s)
 [1;37msched_get_priority_min02:  [0m [1;32mpass [0m  (0.024s)
 [1;37msched_getparam03:  [0m [1;32mpass [0m  (0.024s)
 [1;37msched_setparam05:  [0m [1;32mpass [0m  (0.030s)
 [1;37msched_setscheduler01:  [0m [1;32mpass [0m  (0.026s)
 [1;37mselect04:  [0m [1;36mskip [0m  (0.094s)
 [1;37msemctl02:  [0m [1;32mpass [0m  (0.032s)
 [1;37msemop01:  [0m [1;32mpass [0m  (0.031s)
 [1;37msendfile05_64:  [0m [1;32mpass [0m  (0.021s)
 [1;37msendfile06:  [0m [1;32mpass [0m  (0.036s)
 [1;37msendmmsg02:  [0m [1;32mpass [0m  (0.028s)
 [1;37msendto01:  [0m [1;32mpass [0m  (0.019s)
 [1;37msetdomainname03:  [0m [1;32mpass [0m  (0.034s)
 [1;37msetfsuid03:  [0m [1;32mpass [0m  (0.032s)
 [1;37msetgid01:  [0m [1;32mpass [0m  (0.024s)
 [1;37msetegid01:  [0m [1;32mpass [0m  (0.034s)
 [1;37msetgroups01:  [0m [1;32mpass [0m  (0.027s)
 [1;37msetgroups02:  [0m [1;32mpass [0m  (0.030s)
 [1;37msethostname02:  [0m [1;32mpass [0m  (0.026s)
 [1;37msetpgid02:  [0m [1;32mpass [0m  (0.029s)
 [1;37msetregid03:  [0m [1;32mpass [0m  (0.028s)
 [1;37msetresgid01_16:  [0m [1;36mskip [0m  (0.024s)
 [1;37msetresuid01_16:  [0m [1;36mskip [0m  (0.027s)
 [1;37msetreuid05:  [0m [1;32mpass [0m  (0.028s)
 [1;37msetrlimit03:  [0m [1;32mpass [0m  (0.023s)
 [1;37msetrlimit05:  [0m [1;32mpass [0m  (0.024s)
 [1;37msetrlimit06:  [0m [1;32mpass [0m  (4.033s)
 [1;37msetsockopt04:  [0m [1;32mpass [0m  (0.039s)
 [1;37msetuid03_16:  [0m [1;36mskip [0m  (0.023s)
 [1;37mshmctl03:  [0m [1;32mpass [0m  (0.029s)
 [1;37mshmget06:  [0m [1;32mpass [0m  (0.037s)
 [1;37msignal06:  [0m [1;32mpass [0m  (2.763s)
 [1;37msigtimedwait01:  [0m [1;32mpass [0m  (1.351s)
 [1;37msigwait01:  [0m [1;32mpass [0m  (0.133s)
 [1;37msocket01:  [0m [1;32mpass [0m  (0.075s)
 [1;37msplice07:  [0m [1;32mpass [0m  (0.102s)
 [1;37mstat01:  [0m [1;32mpass [0m  (0.029s)
 [1;37mstatfs03_64:  [0m [1;32mpass [0m  (0.029s)
 [1;37mswapon04:  [0m [1;36mskip [0m  (6.522s)
 [1;37mtgkill03:  [0m [1;32mpass [0m  (0.037s)
 [1;37mtimerfd02:  [0m [1;32mpass [0m  (0.029s)
 [1;37mtimer_create02:  [0m [1;32mpass [0m  (0.039s)
 [1;37mtruncate02_64:  [0m [1;32mpass [0m  (0.023s)
 [1;37munlink10:  [0m [1;32mpass [0m  (0.033s)
 [1;37munshare01:  [0m [1;32mpass [0m  (0.029s)
 [1;37mumount02:  [0m [1;32mpass [0m  (0.457s)
 [1;37muserfaultfd02:  [0m [1;32mpass [0m  (0.035s)
 [1;37muserfaultfd06:  [0m [1;32mpass [0m  (0.037s)
 [1;37mutime06:  [0m [1;32mpass [0m  (0.034s)
 [1;37mwait401:  [0m [1;32mpass [0m  (0.026s)
 [1;37mwaitpid10:  [0m [1;32mpass [0m  (2.036s)
 [1;37mwaitid05:  [0m [1;32mpass [0m  (0.015s)
 [1;37mwritev06:  [0m [1;32mpass [0m  (0.036s)
 [1;37mperf_event_open01:  [0m [1;32mpass [0m  (0.227s)
 [1;37mfutex_cmp_requeue03:  [0m [1;32mpass [0m  (0.025s)
 [1;37mfutex_wait05:  [0m [1;32mpass [0m  (8.378s)
 [1;37mfutex_waitv02:  [0m [1;32mpass [0m  (0.667s)
 [1;37mfutex_wake03:  [0m [1;32mpass [0m  (0.086s)
 [1;37mmemfd_create03:  [0m [1;32mpass [0m  (4.430s)
 [1;37mcopy_file_range01:  [0m [1;36mskip [0m  (25.754s)

Execution time: 3m 53s

Disconnecting from SUT: default

Target information
──────────────────
Kernel:   Linux 7.3.0-rc4+ #1 SMP PREEMPT_DYNAMIC Sat Oct  3 05:36:16 CST 2026
Cmdline:  ip=::::lkp-ivb-d04::dhcp
          root=/dev/ram0
          RESULT_ROOT=/result/ltp/1HDD-btrfs-syscalls-03/lkp-ivb-d04/debian-13-x86_64-20250902.cgz/x86_64-rhel-9.4-ltp/gcc-14/04f914e0ef30c5119e204bdea0db05ec16d5778b/0
          BOOT_IMAGE=/pkg/linux/x86_64-rhel-9.4-ltp/gcc-14/04f914e0ef30c5119e204bdea0db05ec16d5778b/vmlinuz-7.3.0-rc4+
          branch=internal-devel/devel-hourly-20260930-212937
          job=/lkp/jobs/scheduled/lkp-ivb-d04/ltp-1HDD-btrfs-syscalls-03-debian-13-x86_64-20250902.cgz-04f914e0ef30-20261003-53256-bvcqf0-1.yaml
          user=lkp
          ARCH=x86_64
          kconfig=x86_64-rhel-9.4-ltp
          commit=04f914e0ef30c5119e204bdea0db05ec16d5778b
          intremap=posted_msi
          max_uptime=7200
          LKP_SERVER=internal-lkp-server
          nokaslr
          selinux=0
          debug
          apic=debug
          sysrq_always_enabled
          rcupdate.rcu_cpu_stall_timeout=100
          net.ifnames=0
          printk.devkmsg=on
          panic=-1
          softlockup_panic=1
          nmi_watchdog=panic
          oops=panic
          load_ramdisk=2
          prompt_ramdisk=0
          drbd.minor_count=8
          systemd.log_level=err
          ignore_loglevel
          console=tty0
          earlyprintk=ttyS0,115200
          console=ttyS0,115200
          vga=normal
          rw
          keep_initrds=/osimage/pkg/debian-13-x86_64-20250902.cgz/ltp-x86_64-0596b09f2-1_20260926.cgz
          acpi_rsdp=0x000f0490
Machine:  unknown
Arch:     x86_64
RAM:      6894444 kB
Swap:     0 kB
Distro:   debian 13

────────────────────────
      TEST SUMMARY
────────────────────────
Suite:   syscalls-03
Runtime: 3m 43s
Runs:    189

Results:
    Passed:   2283
    Failed:   1
    Broken:   0
    Skipped:  230
    Warnings: 0

 [1;31mFailures: [0m
    • mlock02

Session stopped
/tmp/kirk.root/latest is not found



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261009/202610091104.927c0472-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



