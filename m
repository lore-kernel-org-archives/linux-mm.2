Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D13C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 04:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F1B6B00D5; Sun,  4 Jan 2026 23:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0774A6B00D7; Sun,  4 Jan 2026 23:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2696B00D8; Sun,  4 Jan 2026 23:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBD4C6B00D5
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 23:46:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B54B1ACD1A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:46:29 +0000 (UTC)
X-FDA: 84296674098.13.9356CC4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id 68FED40005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:46:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Osa9AYo6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767588387; a=rsa-sha256;
	cv=none;
	b=sGeWRnu1F/weC3OirLl+jyTyNRdKjNSujTOBULxun2lQ0BPBqEFqks8kAt1XZ5ViohtJl+
	dJ8TIf/hLysbyycN2J91gRguHC5gjLcouyGacOcIzdTzzjTClpTAfEq2z+n+89K/bIklcP
	pjqa3YTQeoybsuMLpUHGqTQ9Chkl7SY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Osa9AYo6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767588387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=InQf/76fnHHFMB6qLlLLxfF2uVE32caiSOT2o0Wx/rA=;
	b=dbhjYKkl5IKyJJeP5ZpY/HhTPr6eB8NHnZd9IocXXJbc5XEusvXFFZwTBPluhp6S9FWi0F
	CxsondpcT92mz8a+ogmpFZfy6kSOcxUcFbfedC/dcsEC9CtywnXpp/cnaHk/6AApapF+8Q
	331cng7YBeCWyBhmsb65+J+V7pfz3vY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767588387; x=1799124387;
  h=date:from:to:cc:subject:message-id;
  bh=e66a15lEvMS5/0tetiz2yLJL3T9fHXsu4MzXu0oYxec=;
  b=Osa9AYo6Ld22ZdDyl2ASyuU/SCAkwkpA0COWh8MiAJfImdjiywEs/9gm
   OLudNZxDMrUs6ALVEaDRfFQvnfapu8J/zIh6rTQjzn9tTSBOjzKM+2Ih7
   qNyDxVP79ZAEVaSrfu6l1orxeW3/mUz1BwzNlWJ/8Uq64y7Fa0AFlA+0c
   xTc3K5sRr7TyMeSlA+zwMHxqHU1OV9FQ/Q5vD1a3CkP+m8c7qtPjENonL
   DK3hoQhh83eYuYQhlBHwGyD5cv4PyiCwb1bY7POQOsG87pQ5nO+CZXkgA
   rO3Yy/o+BxNT4rhn10Pr3Txg0YTrm2ir8mXwwPD4u+nsa3bZITdnaPOui
   g==;
X-CSE-ConnectionGUID: VQXwPjbCQ3WX4ploWE0fQQ==
X-CSE-MsgGUID: 4TxbGoW1TpujbjkFdb8new==
X-IronPort-AV: E=McAfee;i="6800,10657,11661"; a="67965063"
X-IronPort-AV: E=Sophos;i="6.21,202,1763452800"; 
   d="scan'208";a="67965063"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2026 20:46:25 -0800
X-CSE-ConnectionGUID: BFNiGtvcTiquc4zhMt9meg==
X-CSE-MsgGUID: sflfUcZORl+soO98ljR6eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,202,1763452800"; 
   d="scan'208";a="206780138"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 Jan 2026 20:46:22 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vccU0-000000000wH-3KdF;
	Mon, 05 Jan 2026 04:46:20 +0000
Date: Mon, 05 Jan 2026 12:45:48 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 Sasha Levin <sashal@kernel.org>
Subject: [sashal-next:mm-next 5/7]
 arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function
 '__bpf_address_lookup'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <202601051241.10hXC1ge-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68FED40005
X-Stat-Signature: trs6kk9m9owazc1epg31sa35tgiqa9qq
X-Rspam-User: 
X-HE-Tag: 1767588386-695534
X-HE-Meta: U2FsdGVkX19jy6N1OMp2oMSzvf0Rka+FDlfQN2qTtmXGqysRPXD89etj5NNfMs51UwwpufxakPPbMtZZmwmKdYEojsTJCKQlqdBuNnGYNkxlqjne1qYZWoMqvp7TfstKsshjyCFYg6u0axIkEs6wTqgKC1WbsA45kt9yYTrNy0DCbOMipmePv/OwEi11aXesaiCh8VAKxVZWMSuxZfXuLUIwekuosSOoTQyguXkjXQmYihrCq38byQQU05rMSSj6kRSfuGeqkrg88i2VCI1tlIyHBgwHynrfy1dqzmgZnWImmR2RyiTqD4qBprtH4uK/knlgBmslt1D3sUPQ2dO3tZiu5wC9do3edw8em/BU0o0fygecixV6ag5i+x1HAKTZsshqbkt4PP/N0C434D8aM+123Z4EffInXcwz4CMDY1ZtdiO/TOhsy8x6vMsutGQrkU6bYERBVyEZ4RhMyvCyyPs40tw9YYowHI5x1G0Uu99MFoHCQ2Jii41D5edH8vC1WCn/IP6tTqrCjln+XL/Iw3hFXB2R4e37Eot/F9JqfqTIvvZbwmZyycTKnACrD0O9eEfy3FsVi3376Jobac41H/iO/anE0bBnqOgl+Pg8XqKcBsKJpwlGq2FqlF9z6yz9zDpBALztOPElQDwmOm6xiR01rIRuPHtKij9fRW3O8blIT2+Lr+TUovMC3VaGWXD+DpTtMZm/YIbOuFK2h5eEmHw0wFi45ApeBpbRNAK4VcOt17tezvbFkL3KiqBKg0/qwDGidO5gE8PG2QBcd+NIEWRGZ+MxM9wqMjU0HP4uLqYiTfw1yLj3sP0BGdQjxasGCv8gUyWIyiVTIq5nWDMCeNv3nhUz4VYFGq9sF7XeU1pjdcl+Hqk0aCb/BaDKYdF5StyU4EYXb/TzjduIRIqgNqtaj1nRLYTCFytDFyGgLOpETFOiCwMX7x+UPG1oz6k0d1fxgZfAZ5ZS00McV8J
 O3YtgeM7
 5IbikuZ2FX+Xy1OJD6a7PcIARDgsDawHIh3iHP7rz+pXh4qsCA+b2HMCsRHMciRHZEvOXeZyPZmF5raEjhWV2Ce4JandzjnShepYRRS9fjByHa7vpkTKpQa0NkbjpkNAFdmMjDPh5l8Cyza18fJf5G57PgES+5+OTPwtp9kQHPaaJz/PxEPHVn83KY/4ncYH23YrYd+wNIhTmvwUY1GHIJJnAoEqEPAyIO+VRtwGWI6zmn6VfIM0n7F9Se5BebzDclCM98B3gDV083SLpWTICEzgi1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-next.git mm-next
head:   e10a56cdd2c231b8e6e59651bf02e3878ea3cc76
commit: 5c48a0498b4b96a11af18d27ae295822bc40e0c3 [5/7] Merge 'mm-nonmm-unstable' from https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (mm-nonmm-unstable)
config: loongarch-randconfig-002-20260105 (https://download.01.org/0day-ci/archive/20260105/202601051241.10hXC1ge-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260105/202601051241.10hXC1ge-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601051241.10hXC1ge-lkp@intel.com/

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

