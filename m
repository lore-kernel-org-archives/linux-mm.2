Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EC3C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9B66B007B; Thu,  6 Aug 2026 13:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6812F6B0088; Thu,  6 Aug 2026 13:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597336B0096; Thu,  6 Aug 2026 13:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2696B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:41:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4A3580181
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:41:00 +0000 (UTC)
X-FDA: 85071560280.29.491C695
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 105141C0002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:40:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iQWCevy5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786038058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s50/Dncm/XVDEXbgfdvtyBDU0LCq5hI6Hqz4Yn4A3oc=;
	b=BALFd2rZyubd7xR+1WsHcz0rKdhc1GM2xh7vPSdDaudQlLIFpou1RdiLX3qG79smQg8URb
	NcvvzAcBYfYGgFT+xMn/JljvRPDvfNwwuv0RweEeJ5OLsbcz49wNwr8WfZKjmPVg5wR2NL
	cDT0fYaLsKFY32RjS1Auq8UE3czYclA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iQWCevy5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786038058;
	b=7IFVFsDrdIFPR7eE36tc/E+td0IGGs+WfNFhfkdxCL41eiotqM42KK9D866DHq/sArz7yM
	9N8pzn6pkl7qFrQeNwHh95jPlb3epbWzRUZ3VpV/RdaJWWHr4SCpdpS4LSOB+NaU81eEgF
	CeFBrgH0f4ftPibLOXSTEeGpw5j+EZA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786038059; x=1817574059;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jR6UAf+W3pRyagiBnBIthX9L1RTvVK8tgmNzQD67mJU=;
  b=iQWCevy5joUw+yLiFZt4Jlqn9IrKF3pHcD2g8WQlNUNsBFjbRZFnP3J+
   pKSAt7SrrqMYYkB4kxIiEci0+A+D9XabVqHW942ViCdYToZm9pP1k6iYE
   h0PtuDIpIeMbqEpywcALO+NH9Vt5LkjaKf8d9DpE2QNUGCK5OKKATbzUe
   FO+76olhH4ucyc+wvw93DHbBnIb71iAcqXEqOp6sQ/IVhY2J3zAIAeo/M
   nMAn63v4CfPFBVfEsBTQMw90jaCDP6CdZqIrAClwYoVPBIOuiwevRbNhX
   /UwDXO+F9kzAmUl7QSjjznA8SwkYkjausVE0y4wsOrfjZqzvdKVqHYEZI
   g==;
X-CSE-ConnectionGUID: YvcZxQcqSZq9c8KV20J6+g==
X-CSE-MsgGUID: sYEnVwCoTwCqqt9gd52SxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="98151988"
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="98151988"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 10:40:57 -0700
X-CSE-ConnectionGUID: 7DB5m3cyQx2LtjOXhuPo6g==
X-CSE-MsgGUID: 1SUtF5e8QmWqOPxccB+TSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="300373251"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 06 Aug 2026 10:40:51 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws25I-000000004f4-1D7z;
	Thu, 06 Aug 2026 17:40:48 +0000
Date: Thu, 6 Aug 2026 19:40:10 +0200
From: kernel test robot <lkp@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>, acpica-devel@lists.linux.dev,
	bpf@vger.kernel.org, coresight@lists.linaro.org,
	kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	mptcp@lists.linux.dev, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, virtualization@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] tools: Use fputc() calls in some functions
Message-ID: <202608061909.wj199SHx-lkp@intel.com>
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 105141C0002
X-Stat-Signature: caexe1rahhcmgxrb4z1hci4tenx33cpp
X-Rspam-User: 
X-HE-Tag: 1786038057-113344
X-HE-Meta: U2FsdGVkX199SzAtfTxfpNHbNP0f8DKqgf6OydNzdWYr7f3oNJep9AVy8noUes7XaKTWYHgvbzFBpVPFU6mPlGmF4Sa0TkNnaTuMff2laqQKnZAbsmhwl5dwFDdPqrn3mlBnFZcXEFiAy/RvXwfZ80Tgk00xzKObUA/xSUovj97n+soCgTzozfqJCtiNa4E2S1IGJrBO8gQA2/kTByIKNaSW3ycn6ViqFdiiZuwCt6UI8dSp5dJZ515Lmv6G6z4R2BU/bdRTgJrqzA6O9ciM2F4zMDcW9tRW8im7KELyDtvgbaZ27Plir2Q4UgzroElRgdm2mUpzzlzmzot4gQbWTZAbvwO7Hd+mNSyBD/dkXswNqblW3S66W7ujs+TvNI93JhbxaJMZkM+/jQ1QOMk2mEBC+tCOCrBXARDb0UrR1jKcdV8C8YtbwsCUNljfeIyMFI1v6a7uwHzn/9FodLRfyzh3gbgpgKUhJ3kibwRLUHFcngxUzQZfKK+aTcuFDPR9DidbmmdDz3MALslhUkeilCh07FRkDQgiw1hV9NgTsGD1q07GI/lazHz4XzAY+nYv56vUsC41aoJVAbqYPuvXG4Dovm5koJheGMGwxrAMLS61UTQlNA4IpQwntGFur7dxv4cMeiJvQOA8H87e5T7oL2tAJChZpr/yPeVqHkmMJDOtPDznZNA/eekdrfiydVzCllnNAvonal04+0igWKAy50wi31STEOgLEjrMPT0zpCZoFDCqUXveOnwusGT9nqwjKD/GGGlPN51u4edwiw8ALo/ItC9w6zuLCfu0poKbdmAhuga8vH5Z5ohCQP961t31CFpn2ZXHc7BI2tOdJY1XVCiof0hphxTRUSXIcrXNIJNxYjkZsWDo4U5PkIr4VC8Si2UUkV1/hkdHMVBocxh2IZqelUu58yHJ3AYTwQMU7hUJq2icufH8L24Tszg1va5H+9e40b+WckCy7KIKy65
 VSvoF8mq
 NHpGmhVC4E96geuYfED0gZvsGilAKrwxwLrYBiReEa/AVkuDO5muWE8ZVMZoaiX0lzIg1kZFBJ61hOGQREkrPUZGQMcIQm0jF4KwRbLtBwl8KJz6vLTR/2/RL80m8feYBQDZg8Kd1Vy+tpK1Vlj6RZsSZaGP9zVVALF4mmuk4DUjitKl9aIuEUpaIpz9jxLFCGKhF1Rusruhzm8aEvMJ9RlQ08Mhonz5gc+3ETJHZGhR2mQ/ycU2klJTdwZ6w3YMhW+131qJp4XyK5v+xQeHnOyP3ftz/xaeENFPuVV7E9NHSCSpQL92ry0uyDgS2xzV0kDoHt5uSbHtxe970K+BLYhJW3jnLcddiZCRl0ojXGHfMsIoaQYn+nq98CNAjLtm5GkMQiIZNPpxulWHjD+2QHYqcEAVnrZKBxCYZXp1bbWvq2c+33HPQJiJoOhMyteCqScTiUnQPS2Fa46WREMaa+HRpcEdr12wDnZpi3cuFoLOg/tsy4dLNA/cvmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Markus,

kernel test robot noticed the following build errors:

[auto build test ERROR on perf-tools-next/perf-tools-next]
[also build test ERROR on tip/perf/core perf-tools/perf-tools linus/master v7.2-rc6 next-20260806]
[cannot apply to acme/perf/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Markus-Elfring/tools-Use-fputc-calls-in-some-functions/20260806-165154
base:   https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git perf-tools-next
patch link:    https://lore.kernel.org/r/48f2d61f-d468-49b7-881e-f00777db073f%40web.de
patch subject: [PATCH] tools: Use fputc() calls in some functions
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260806/202608061909.wj199SHx-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260806/202608061909.wj199SHx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608061909.wj199SHx-lkp@intel.com/

All errors (new ones prefixed by >>):

>> builtin-check.c:300:8: error: incompatible pointer to integer conversion passing 'FILE *' (aka 'struct _IO_FILE *') to parameter of type 'int' [-Wint-conversion]
     300 |         fputc(stderr, '\n');
         |               ^~~~~~
   /usr/include/stdio.h:155:16: note: expanded from macro 'stderr'
     155 | #define stderr stderr
         |                ^~~~~~
   /usr/include/stdio.h:611:23: note: passing argument to parameter '__c' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                       ^
>> builtin-check.c:300:16: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'FILE *' (aka 'struct _IO_FILE *') [-Wint-conversion]
     300 |         fputc(stderr, '\n');
         |                       ^~~~
   /usr/include/stdio.h:611:34: note: passing argument to parameter '__stream' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                                  ^
   2 errors generated.
   make[5]: *** [tools/build/Makefile.build:95: tools/objtool/builtin-check.o] Error 1
>> disas.c:540:9: error: incompatible pointer to integer conversion passing 'FILE *' (aka 'struct _IO_FILE *') to parameter of type 'int' [-Wint-conversion]
     540 |                 fputc(stream, '\n');
         |                       ^~~~~~
   /usr/include/stdio.h:611:23: note: passing argument to parameter '__c' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                       ^
>> disas.c:540:17: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'FILE *' (aka 'struct _IO_FILE *') [-Wint-conversion]
     540 |                 fputc(stream, '\n');
         |                               ^~~~
   /usr/include/stdio.h:611:34: note: passing argument to parameter '__stream' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                                  ^
   2 errors generated.
   make[5]: *** [tools/build/Makefile.build:95: tools/objtool/disas.o] Error 1
   make[5]: Target '__build' not remade because of errors.
   make[4]: *** [Makefile:123: tools/objtool/objtool-in.o] Error 2
   make[4]: Target 'all' not remade because of errors.
   make[3]: *** [Makefile:74: objtool] Error 2
   make[2]: *** [Makefile:1587: tools/objtool] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

