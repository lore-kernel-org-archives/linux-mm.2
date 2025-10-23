Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33D5CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 22:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B488E0017; Thu, 23 Oct 2025 18:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913368E0002; Thu, 23 Oct 2025 18:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8502E8E0017; Thu, 23 Oct 2025 18:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 745238E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:53:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 31C081A0C7B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 22:53:47 +0000 (UTC)
X-FDA: 84030882894.22.1F11D5E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 08AF040008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 22:53:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WXFV0Ol5;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761260025; a=rsa-sha256;
	cv=none;
	b=Ci9scV+T8fpJvpfjcM0MRKlSdDwbYlwRXApYrSV+1fXc4yhn8Kb4Zth/jS6datVB5oULMh
	+DiK09Uzt7DHrsROUOD/NMnyrJii2FYEIP6DvWE8lF/JWRvgULbM0ICkE5J3NkxafvbiHS
	05poAp40o0g8r4r9Jjl5Vl+udKheRGM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WXFV0Ol5;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761260025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xcrIGzLg24yPp188N6lihIn9VjYgTF/T/RrwHAmM87I=;
	b=O3wym+h5b43dObuEj/CqXMtoHjIUeaMkoLI0wmXpFbnMya07xahlr+iqYi1Qqw6uOsDfGm
	MS+KKbeMCDELbAag4yAtOjgN7L6icsqFRui4RAi3CfznWUJNsHbgJ1nmfsm3YUYhgOBcGh
	qVxzqIxVJ5DXL4bmae2bNySWu6743tg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761260025; x=1792796025;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=0QE8HvEHK4lycLqYEDfV2CS/pvTBWa9mkZGA2KfSSHQ=;
  b=WXFV0Ol5+7SUO/kZ460wrMrd4qWGQgHlUPaE7B6I5itHHn0/oAGhhFZ/
   9CZ3QwuYxZVxbnERZRVCIlVQBk+l9zAuihi0IfQWgM53XUXV9b2F6qi0l
   gm5UsQzOlZayq23cDH3xnbtA5ebfMdDvcTFEd6/Z8r6LT4Xj0MFrqFWnX
   Wyu59P3RLf4n03TjGSN8T7E/c205F3kgNiD1EsVuf/ZRPQeQybcoD1lIf
   LV4KWiHX+yXJR7RPJvkVmqPkqgvhMp4PXgRSD79H0Bbz1DRaT4gvo8RN9
   ggfDiP3ax5St7l+0Yy+aBjff7POkprb1RP8jf8yU75PkFbEYX1WzlTkfN
   g==;
X-CSE-ConnectionGUID: HnASVDWoROaoqYGMW6HPEw==
X-CSE-MsgGUID: UBWh4dFWRr6NDoJDyBYu1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62472965"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="62472965"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:53:44 -0700
X-CSE-ConnectionGUID: PvghajoCTBme/3cRVLlAdA==
X-CSE-MsgGUID: a9FEE0ZmSkSLJubWCsYzsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="185055696"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 23 Oct 2025 15:53:42 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vC4Bf-000DxJ-22;
	Thu, 23 Oct 2025 22:53:39 +0000
Date: Fri, 24 Oct 2025 06:52:43 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: arch/um/include/asm/kasan.h:29:2: error: UML does not work in
 KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202510240649.RjPY0lml-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: irwj7axwyaisqwobdiu6hb1fdpdcisye
X-Rspamd-Queue-Id: 08AF040008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761260024-29857
X-HE-Meta: U2FsdGVkX1/IKOUe9GhcOcjiWPY6CIYmfcGlWB6VRrVyIhEZs/ahV7P64mPVCYPfE2Gp+3GV+5I4dvrD9k0Nl3oCkJufqIvdfiRGu8Pqq27AKIqP6U/X8I5J1qtC7PFjsvXyFvQdDF1K0RVbbLuQyDHXU/zu5+6z8n93P/uL7VMqwkcDmNSUykxHejGQ86exyWar2uf4qMdQ8p3ILMfetQU1fuwJATrT3GSkEvrsaAXAThMt6MrQmBv3HtZkEZrjeax3V8u2Ejz9OYyXC2rWYcHfFyBlVcYbksQwGb8XLN0q7pYFuLb/M3UzgBdqszcy3Ukj6qUxmfXQWt0nNqlSLJs8Q5GD6raD34sNVqkDcENzr2uu7aJc08JOMELD9QoakH9x+J6NOyCpngpiJSvJnhK7i9fmdpdTUnv6pqzAzcUJoVYUBTMC55sfAYSYZZahQiY9uR5dLmvERKj2KxTbuFfaPvqMQbyiOBoqmf7FbxjGMXlo3Rn2b1sCDGo9AIPuU6kyrDT6RN1nyDV+scdIq57CA05rMSMn91R9IK3LfusaxtzA95EOSTVWIfemLF71GMjaygfMY/XXDW5ndC4wWugbOQ1Xa0tNCbpbuCcUNeXSfBpK8QRev5nx5Wgi6pPZNuHOJBjcPxvqo95LWWCI8wB+sT10+gGnRw3zGF8JTuWiQM4nh7ZMZKP6/c0/28uWAoIGte1EO5xJwA9mv/CdxmxArrI4ejde2RUtAO1lhVo9ncRyhmRunUnU7qzlS3Rk8FU1gzSLzkFgK8abCr21kZZp1Pz9AvdrN1B+O+izkKLXiOiYM7bOwQMcYvutzeIfCnvMtnDvYnv1ZLYmD4WlLZ1iH5qIIDfjaZGpsMHxxE4JzOtqsKxOCGyYyhvrW8uqVSYqivNxgK4lhM5s6hsLSY2/n/J3Zuz4gvLpTVAWP63Ji8R/PbSxXFU7IKVKv6GyIoa2/9SYXyh7ejXb+RQ
 ooCobo0B
 umLF9oj4jtLPBh7xDnWdpPb27q4T0AfZ8FUJHrEFoPRyhT28EUO7CQHHc/E7TL5C9KIq+DFgEwMgR2zcON1qAST7Z+2tOvpXWgyhSV3ng7wqj1cNs8WFqjGiUrGqbV3CtgiOfHQoBdR/dVvu4Pw5Tuqzn3VfB9S6PgE+j0hvlAQQ3tD4L+vMbQALro/H/hzUDXRSyWVIAPCFIBaWyGVv4CraGytgdVKlw+MXtxmN+aZCosGa+X38Ab7PLvUB55HxytfCj4rjSNIuL0vctaoSgu66Ma4EZY8By2KF2Z+BSgolCbdHJl349Z1pW+jqk76xWdCwhVWlChpieap9Gt7oNqY6SprXo/9Ja1B3SYoqjUxiOLrl+uTzXmHr90GwU+4R+my9xvc4P+bSr0zvcPVMxN+e1nMY6OS1uQQeDarm4l+p5QEZbfpaTDZnW6WVebesCrEqVQMsocAo1Obl9E9CyLQBSd7fEO5zwcKo8eoDa6BFSKL7SlcV7hd4SlBH6y0AAAAzWVbBwnsHPR+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   266ee584e55eed108583ab4f45b5de734522502d
commit: 1e338f4d99e6814ede16bad1db1cc463aad8032c kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
date:   5 weeks ago
config: um-randconfig-r064-20251024 (https://download.01.org/0day-ci/archive/20251024/202510240649.RjPY0lml-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project e1ae12640102fd2b05bc567243580f90acb1135f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251024/202510240649.RjPY0lml-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510240649.RjPY0lml-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:5:
   In file included from include/linux/crypto.h:18:
   In file included from include/linux/slab.h:260:
   In file included from include/linux/kasan.h:21:
>> arch/um/include/asm/kasan.h:29:2: error: UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
      29 | #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
         |  ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:11: warning: array index 3 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:98:25: warning: array index 2 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      98 |                 return (set->sig[3] | set->sig[2] |
         |                                       ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:99:4: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
      99 |                         set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:101:11: warning: array index 1 is past the end of the array (that has type 'unsigned long[1]') [-Warray-bounds]
     101 |                 return (set->sig[1] | set->sig[0]) == 0;
         |                         ^        ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:11: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:114:27: warning: array index 3 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     114 |                 return  (set1->sig[3] == set2->sig[3]) &&
         |                                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:5: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:115:21: warning: array index 2 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     115 |                         (set1->sig[2] == set2->sig[2]) &&
         |                                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];
         |         ^
   In file included from arch/um/kernel/asm-offsets.c:1:
   In file included from arch/x86/um/shared/sysdep/kernel-offsets.h:7:
   In file included from include/linux/audit.h:13:
   In file included from include/linux/ptrace.h:7:
   In file included from include/linux/sched/signal.h:6:
   include/linux/signal.h:116:5: warning: array index 1 is past the end of the array (that has type 'const unsigned long[1]') [-Warray-bounds]
     116 |                         (set1->sig[1] == set2->sig[1]) &&
         |                          ^         ~
   arch/x86/include/asm/signal.h:24:2: note: array 'sig' declared here
      24 |         unsigned long sig[_NSIG_WORDS];


vim +29 arch/um/include/asm/kasan.h

    27	
    28	#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
  > 29	#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
    30	#endif
    31	#else
    32	static inline void kasan_init(void) { }
    33	#endif /* CONFIG_KASAN */
    34	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

