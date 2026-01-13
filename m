Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31624D2F349
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 17:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955E76B0005; Tue, 13 Jan 2026 12:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903A36B0089; Tue, 13 Jan 2026 12:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8023D6B008A; Tue, 13 Jan 2026 12:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE706B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:38:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 241951B1C9
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:38:38 +0000 (UTC)
X-FDA: 84327650316.03.40CD344
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id BC95580015
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:38:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MxiSzS/P";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768325916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mQ5sMmCv4iRO5E9poXPBqTr7T+F8CKNr4A2FSX4Li5o=;
	b=FFQu7OBBB5EXmCA8r4uxu37Rcju9bvpy8IFFLYwUqPhvCB9RlAA7COY0WW5kpIQ6SMw8hL
	9fhn9RT1BVE5//f5YL4dng9C1sdImSlzH3Ak55IgcnGLoZ8jRUqjiUgGPUixSP9mZNXO33
	kJez19/Iu8MoRLRLgB8P61qD+fRpWkQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MxiSzS/P";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768325916; a=rsa-sha256;
	cv=none;
	b=rZi4L9O9YQSpbjiYRqadVgICwgYy0fmig0UjtG/cKVIxzolWrNr5AioFoGhakPVD0FClqO
	UCW+bJXbHpuNHM/Tc7Oje6qtuaVhsGL9izI0VFeV4R3GBRN1ISDfIC+zUP6TD9gkJg01OL
	WKJg5P0jpNUq4syVLntjqLziYwaaCF8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768325916; x=1799861916;
  h=date:from:to:cc:subject:message-id;
  bh=sszUYqvh01nu4Eid8QPas45VhqwkdR3+wRrLcb7xHFg=;
  b=MxiSzS/P/tpL7Ct7uiFjHdJdjYcJpjHEs3o1SKHpE/LW6a7XZuoARlWY
   qf3RuzfUImLjiOUrIHBJWgMMQIK+4Wo380PH+KnFhguWLEcnVHxD0BikE
   DNrcUT1pBGlrQNUlFZUAAvIJ8eGI5SJe+aPWxF1VZp42twjTLiMfdJdt9
   Y7MXNGX7/tnFSHZ7iSHhznhYdExRgz7nPXhlp+i4Ss/KAIaHh3fxCGcVv
   e7WkCMJJ8fZ2Yc196Wwy4Ufe9nDNPVdK/epxyMU1JKuAqzFvyyKVxjLwB
   9UGF10E4JGbtl5WnPZKw5JBsj8PoDjFT9DRKChtmtO6H2h3bKpO7fNObk
   A==;
X-CSE-ConnectionGUID: 1y5IyOaoRcyXu3fQTBklxg==
X-CSE-MsgGUID: fYrLdAnbT72SW14pKk8aHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="73474765"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="73474765"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 09:38:34 -0800
X-CSE-ConnectionGUID: tB59I1d5QkuSTknXxDUGoQ==
X-CSE-MsgGUID: wLzOGHoFTKeip81Czu1gmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204335546"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Jan 2026 09:38:32 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfiLd-00000000FBC-2uLy;
	Tue, 13 Jan 2026 17:38:29 +0000
Date: Wed, 14 Jan 2026 01:37:38 +0800
From: kernel test robot <lkp@intel.com>
To: Petr Mladek <pmladek@suse.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-nonmm-unstable 77/129]
 arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function
 '__bpf_address_lookup'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <202601140159.I4b0kwpE-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: gh4qoi7tkw6xfmp1sqxsfr3b7e1sitt6
X-Rspamd-Queue-Id: BC95580015
X-Rspamd-Server: rspam04
X-HE-Tag: 1768325915-478438
X-HE-Meta: U2FsdGVkX19LnaVBD4IaJXNXAXyGEBIofRfDwpZMZtW/QL5/7T597pRO1n6lap0u8vJ5BvbRi4VTlPLMv5u59Qr4iti5Kr2XFiTXyq4rsdXY25p7+v+NxSsqsrSO5f663epBBM3i2cJdbxn1aI7+AM6Fx7RbjXSOLrC7q4h1fqfNVDFJSaHHX+m+FmbThn5JiIpEgWI+jR8o/jeqVqHreeWpu+L21WR2YjawiNdoAWjTkxw1wpA8hAKpJh1uGXxXFnuYIunr0spM3dbg3xYGSHi80yBeGBN+LnihPg8rt0xO2dNCltE5IlWmrWOzUAuyZNsHyEIUpnAPOoNMIyTHiNHXkGXTgfl12Ymnz6FjmX+eaRSjefr5Q1dusCD2u1gfMdKOCmAHD1bC/gdXh8EbMVp1ocJtrwAWLgVrGEgeybnyIxRBG3jJqiw/yeGIxKc0xX+DfFpuvsbticI0bfyIpbpUBaoJm4KPPa6nYSRBzLpAhJVA7m1vA6zQVyx6e+hPP6jmccs1ltr8VgUnYt+7Xr3vZA2GtatLcMAp5M6jHZkDhBOC9ruaUhWLjocUg9QpPpNwXLJgcENIkmnnhFiuuyUrWt7J4S7iGKGQic9KbtWKEIxHIciPc1ry3JsrbT4rVnJfQlgELX9sO8UkaKn68f9uJFcd9dBRhyz3htRp+1xn9MGaL+m78mw4c+q+k3/ip2OLWUBa8wNQv15KOiEf/uS4ySKTfiTJsBGTMZ61KWAiceyHEwFgQ87S9/QUoplYsrcbedCfyka21UN43pudww548xhR4e2MWYJ42Z4jJhCWStvq40Ri0eiWNmU0q1yWPjkNm2U0Gn6/dbnFXq1s2thLmx1IN3Gp/l5ifPLGjXnQzgnpmdZcnkm3Sa0qgiXgTkCCXktiHEL/UQZzcP6iFj90111ySDBF6fetdr+N/XEFrfJz+VRH3qk7fioxxHVgUV1g/+zm7Jr/evQoHrd
 DrPSg23f
 f+HyjA1U8Y6xTIRHEyqxLj0h3MpuzBjSWgcgWyy1i4JIm0Tejo2mxi5U+yiFllk/pTwsZeJWdvL+6rbfT8XtxjiT0KAHU/JR9sq9t8qrjeqfxJi5WKbDa+ZPDmvU9CgvxGiFLlrQhMwUC6Ohx8cN6SQeDXznybvEU5sDEEyHXdIsG/1LRB8LAweEsvbNSrTMLDcuC03OdjlwA3lQAjH4y5hJbVMiumdz9nRuvCMxnTCm+OciWGjZDgOrL5UpsfeZ1kjV4s2ZS9AKj+idWBMtMix3XoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   01c8de771f4a779caac5d841b1cb2207ac23330a
commit: 0f1766dc93f077061bf42cc6222bb2ade96422a4 [77/129] kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601140159.I4b0kwpE-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function '__bpf_address_lookup'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1322 |         if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
         |              ^
   arch/loongarch/net/bpf_jit.c:1322:7: note: did you mean 'bpf_address_lookup'?
   include/linux/filter.h:1378:5: note: 'bpf_address_lookup' declared here
    1378 | int bpf_address_lookup(unsigned long addr, unsigned long *size,
         |     ^
   1 error generated.


vim +/__bpf_address_lookup +1322 arch/loongarch/net/bpf_jit.c

9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1305  
ae4a3160d19cd16 Menglong Dong 2025-11-18  1306  int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
ae4a3160d19cd16 Menglong Dong 2025-11-18  1307  		       enum bpf_text_poke_type new_t, void *old_addr,
ae4a3160d19cd16 Menglong Dong 2025-11-18  1308  		       void *new_addr)
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1309  {
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1310  	int ret;
ae4a3160d19cd16 Menglong Dong 2025-11-18  1311  	bool is_call;
73721d8676771c6 Chenghao Duan 2025-12-31  1312  	unsigned long size = 0;
73721d8676771c6 Chenghao Duan 2025-12-31  1313  	unsigned long offset = 0;
73721d8676771c6 Chenghao Duan 2025-12-31  1314  	void *image = NULL;
73721d8676771c6 Chenghao Duan 2025-12-31  1315  	char namebuf[KSYM_NAME_LEN];
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1316  	u32 old_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1317  	u32 new_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1318  
3d770bd11b94306 Hengqi Chen   2025-10-02  1319  	/* Only poking bpf text is supported. Since kernel function entry
3d770bd11b94306 Hengqi Chen   2025-10-02  1320  	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
3d770bd11b94306 Hengqi Chen   2025-10-02  1321  	 */
73721d8676771c6 Chenghao Duan 2025-12-31 @1322  	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1323  		return -ENOTSUPP;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1324  
73721d8676771c6 Chenghao Duan 2025-12-31  1325  	image = ip - offset;
73721d8676771c6 Chenghao Duan 2025-12-31  1326  
73721d8676771c6 Chenghao Duan 2025-12-31  1327  	/* zero offset means we're poking bpf prog entry */
73721d8676771c6 Chenghao Duan 2025-12-31  1328  	if (offset == 0) {
73721d8676771c6 Chenghao Duan 2025-12-31  1329  		/* skip to the nop instruction in bpf prog entry:
73721d8676771c6 Chenghao Duan 2025-12-31  1330  		 * move t0, ra
73721d8676771c6 Chenghao Duan 2025-12-31  1331  		 * nop
73721d8676771c6 Chenghao Duan 2025-12-31  1332  		 */
73721d8676771c6 Chenghao Duan 2025-12-31  1333  		ip = image + LOONGARCH_INSN_SIZE;
73721d8676771c6 Chenghao Duan 2025-12-31  1334  	}
73721d8676771c6 Chenghao Duan 2025-12-31  1335  
ae4a3160d19cd16 Menglong Dong 2025-11-18  1336  	is_call = old_t == BPF_MOD_CALL;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1337  	ret = emit_jump_or_nops(old_addr, ip, old_insns, is_call);
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1338  	if (ret)
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1339  		return ret;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1340  
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1341  	if (memcmp(ip, old_insns, LOONGARCH_LONG_JUMP_NBYTES))
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1342  		return -EFAULT;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1343  
ae4a3160d19cd16 Menglong Dong 2025-11-18  1344  	is_call = new_t == BPF_MOD_CALL;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1345  	ret = emit_jump_or_nops(new_addr, ip, new_insns, is_call);
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1346  	if (ret)
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1347  		return ret;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1348  
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1349  	mutex_lock(&text_mutex);
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1350  	if (memcmp(ip, new_insns, LOONGARCH_LONG_JUMP_NBYTES))
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1351  		ret = larch_insn_text_copy(ip, new_insns, LOONGARCH_LONG_JUMP_NBYTES);
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1352  	mutex_unlock(&text_mutex);
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1353  
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1354  	return ret;
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1355  }
9fbd18cf4c69f51 Chenghao Duan 2025-08-05  1356  

:::::: The code at line 1322 was first introduced by commit
:::::: 73721d8676771c6c7b06d4e636cc053fc76afefd LoongArch: BPF: Enhance the bpf_arch_text_poke() function

:::::: TO: Chenghao Duan <duanchenghao@kylinos.cn>
:::::: CC: Huacai Chen <chenhuacai@loongson.cn>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

