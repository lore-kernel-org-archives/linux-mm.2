Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DEED2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5CA6B0088; Sun, 11 Jan 2026 15:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0936B6B0089; Sun, 11 Jan 2026 15:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0D86B008A; Sun, 11 Jan 2026 15:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCD4F6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:55:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40CFD140FD2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:55:05 +0000 (UTC)
X-FDA: 84320887770.07.EDDC39E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7F26640008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:55:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FlNwjV8B;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768164903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=V9YGdrtNXEMofXC2VYRvZrlGXD05bJauOufvject7tk=;
	b=57ywF8dr466bUTT15l+Dgxuj2ykhvoTeV5zKGZxazo7heKeTKjAct9dWGRJqx3JSa2R1zG
	qZyuhHnjPUbsFMcZKWEC5gjXYaL7sW5NZcs9b17OXoJwa31LuX5zhqokMs3Q3N3rj3Waij
	sDBseabXCOx2ct7T2EFjW9TYS9Jbrqc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FlNwjV8B;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768164903; a=rsa-sha256;
	cv=none;
	b=jhVwP12m1VSLbBuQKem02G45yxmUG0C8wf7j5J47D6Rt8JLOt/8fEpowFQg0FcosKoX6yf
	8ljqj/Yn4wO6wOebNs5LZSZauWbfgvnEcny8GzUV/5fHEUShGzqNGxrnf7cbX0pRQoOSfl
	I12gIB+RwDtcCynvSEAKcNcrrsANKvE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768164902; x=1799700902;
  h=date:from:to:cc:subject:message-id;
  bh=azs1KeAwl/jOwE0Um03liCx5f9eIs2ftpl4R+vKv6O0=;
  b=FlNwjV8BoE0lCRk+I896i0UNMrc/jZcoddmgNhsnvgZL12N29sQnh//M
   mxq8UfHo1Zf6r6vQ87mfraV39cuXWzYJCpZWH5FhqRqCp3ve3XFPft1el
   IeD1w6XSvAdPS3lHDAtYNfm/FKk+SgRvSmHyYIKwxF6NjHu5xPp8cguy6
   qAqwKXergPnGV9gXsc60+Bgn8geeoVC6uf0LiDcqSU7LnzLUIl7vTII0A
   W2hATBwuPiZfqn5dARLx0NVbL/SxMVA44WgGENmNhteFDEadmVodLcVWl
   zRTT2TuEoa1uMWy7rq+gLKlpCG0PNvsJyoVUiTj4ZIbE1ADyQoKa5xFvO
   A==;
X-CSE-ConnectionGUID: 79+QbMejQ+++07RNDoRBOg==
X-CSE-MsgGUID: G9H7K4OKRNuHzQiqxCD4SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="69349110"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="69349110"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:55:00 -0800
X-CSE-ConnectionGUID: WP7RanmIRyapg5mr5SkDXQ==
X-CSE-MsgGUID: WcgF09mnRfO4qlqmJ19KsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203941795"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Jan 2026 12:54:59 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vf2Se-00000000Ch2-3KPJ;
	Sun, 11 Jan 2026 20:54:56 +0000
Date: Mon, 12 Jan 2026 04:54:55 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 4952/5095]
 arch/loongarch/net/bpf_jit.c:1322:14: error: implicit declaration of function
 '__bpf_address_lookup'; did you mean 'bpf_address_lookup'?
Message-ID: <202601120429.Bvdp1mP1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: fyo8rci6uj8syr5qw3e3yrnb131d3xu9
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F26640008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768164902-499225
X-HE-Meta: U2FsdGVkX1/p45zkTrIsoMstO8bjOHILfIcTElGXkZADT1U6psYrGUs3x09KXhfVpBSi+/ZzX2Y5Cf0Cv4u35n/ui5Al/yFDOR0cs5oq453H8ts/KNI2jSlUO8GAj+pWqtOK2hZQbCliT8xFCzwK+wwG1jfXWU2s7CDzbqrvhi41rIbEoNot4j+7JyoLsTybJuPAriFGj0ECbP2sydVbMKLgt7dhOVhla9v/wAjQ7xuRqY5ZF8xntkwbgymxFHPkluVBoD6etHgtA79+Y9IEmSqagP3p1Vv3GTnKrIF6l6e+u6UgPscHcWZEK6qpLiIHs3THnFdBCTqOSzSn5+oCe27bVdvQYMMFO/CkYgKrtNdJoi4ThboHiBkRNIG8V9NQYWvtfdJCts0aSVZnYRJLiyVmbicy6eXMRhCNlD30G3pcFW9p/q2iUfQa38gVkJviVy5EX0zGWzzFalDIy7Hp5Z+/qnr1WFMSpLiYauT+EEfEEfyQQY/L0lgm0Zn1qPXa6KcQELg3F1UxRkZ4JY7IZdTJ6hgsHAEoVxfOMWcXlwm82dscRi08sKVmE0WVQVnF/PiHNHTG/MRO+OD2OydQUx7Xjh4GuCtG/tnX6e5ilBIOl7GpJW659B+isd367CBm/dKHsnOk0vbPkrKt2fJfN7O7AnK0ov/yy134pFL32KW++3N/T0mogikYuqXjOrOp7MG2ioHgHpXiQBUhyM+3ixUbHVhXTJElLHXSGsIyx4lgD095qqNa823XSO4Wj3rDXZGfUCg5C+INszTuFx4QwcHwN7N+xrF8FnJE+rEj6UDXeq19Uhd47vYzPR+jc9q0ZygbJWRcQSYO6NnZ5AhLMHR+/DHSHtIL7sAYqLzzzURbq6uLbMrL0Yvl2lZLjsvLSic4rE0oS/gEp57BYykc3fq6BvuO+7ryVRP+U8zfAtJ+ESdsuS5EsruUizNDYF0Fvn1EKiaQGQRToS1htPm
 62q9gxQa
 WUWpE2eppNtlwSHjD4UR2xNODFmqt9L30KgkdgOL90JKDBC+uwgvGxHDeJada1ZrZPYrvolT0gYw2KTpCxVVvpVAtmN1fXFXcmm0HQshqia/e9B/19bj0oAuAGiMEw/CJuHnzoqFquGqr77CvGOQkRaVZTMfa8+vGB1hUFjG/DjqO1d4eZaLWOwPqs83K69WZOG63ZR5EDYnkdSnH73+HPw86OIm9VOYI56J/KhNzCSEoHyD4gM5+PfeZLFYyP8CfOalBbjDDaIrxEHxUv65wIznW4TKV2rrr0C0un6PoPBGMBtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f417b7ffcbef7d76b0d8860518f50dae0e7e5eda
commit: 90914704bb11e24b42bd368b91e4a1e69d42e72c [4952/5095] Merge branch 'mm-nonmm-unstable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
config: loongarch-randconfig-002-20260112 (https://download.01.org/0day-ci/archive/20260112/202601120429.Bvdp1mP1-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260112/202601120429.Bvdp1mP1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601120429.Bvdp1mP1-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/loongarch/net/bpf_jit.c: In function 'bpf_arch_text_poke':
>> arch/loongarch/net/bpf_jit.c:1322:14: error: implicit declaration of function '__bpf_address_lookup'; did you mean 'bpf_address_lookup'? [-Wimplicit-function-declaration]
    1322 |         if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
         |              ^~~~~~~~~~~~~~~~~~~~
         |              bpf_address_lookup


vim +1322 arch/loongarch/net/bpf_jit.c

9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1305  
ae4a3160d19cd1 Menglong Dong 2025-11-18  1306  int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type old_t,
ae4a3160d19cd1 Menglong Dong 2025-11-18  1307  		       enum bpf_text_poke_type new_t, void *old_addr,
ae4a3160d19cd1 Menglong Dong 2025-11-18  1308  		       void *new_addr)
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1309  {
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1310  	int ret;
ae4a3160d19cd1 Menglong Dong 2025-11-18  1311  	bool is_call;
73721d8676771c Chenghao Duan 2025-12-31  1312  	unsigned long size = 0;
73721d8676771c Chenghao Duan 2025-12-31  1313  	unsigned long offset = 0;
73721d8676771c Chenghao Duan 2025-12-31  1314  	void *image = NULL;
73721d8676771c Chenghao Duan 2025-12-31  1315  	char namebuf[KSYM_NAME_LEN];
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1316  	u32 old_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1317  	u32 new_insns[LOONGARCH_LONG_JUMP_NINSNS] = {[0 ... 4] = INSN_NOP};
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1318  
3d770bd11b9430 Hengqi Chen   2025-10-02  1319  	/* Only poking bpf text is supported. Since kernel function entry
3d770bd11b9430 Hengqi Chen   2025-10-02  1320  	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
3d770bd11b9430 Hengqi Chen   2025-10-02  1321  	 */
73721d8676771c Chenghao Duan 2025-12-31 @1322  	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1323  		return -ENOTSUPP;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1324  
73721d8676771c Chenghao Duan 2025-12-31  1325  	image = ip - offset;
73721d8676771c Chenghao Duan 2025-12-31  1326  
73721d8676771c Chenghao Duan 2025-12-31  1327  	/* zero offset means we're poking bpf prog entry */
73721d8676771c Chenghao Duan 2025-12-31  1328  	if (offset == 0) {
73721d8676771c Chenghao Duan 2025-12-31  1329  		/* skip to the nop instruction in bpf prog entry:
73721d8676771c Chenghao Duan 2025-12-31  1330  		 * move t0, ra
73721d8676771c Chenghao Duan 2025-12-31  1331  		 * nop
73721d8676771c Chenghao Duan 2025-12-31  1332  		 */
73721d8676771c Chenghao Duan 2025-12-31  1333  		ip = image + LOONGARCH_INSN_SIZE;
73721d8676771c Chenghao Duan 2025-12-31  1334  	}
73721d8676771c Chenghao Duan 2025-12-31  1335  
ae4a3160d19cd1 Menglong Dong 2025-11-18  1336  	is_call = old_t == BPF_MOD_CALL;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1337  	ret = emit_jump_or_nops(old_addr, ip, old_insns, is_call);
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1338  	if (ret)
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1339  		return ret;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1340  
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1341  	if (memcmp(ip, old_insns, LOONGARCH_LONG_JUMP_NBYTES))
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1342  		return -EFAULT;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1343  
ae4a3160d19cd1 Menglong Dong 2025-11-18  1344  	is_call = new_t == BPF_MOD_CALL;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1345  	ret = emit_jump_or_nops(new_addr, ip, new_insns, is_call);
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1346  	if (ret)
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1347  		return ret;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1348  
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1349  	mutex_lock(&text_mutex);
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1350  	if (memcmp(ip, new_insns, LOONGARCH_LONG_JUMP_NBYTES))
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1351  		ret = larch_insn_text_copy(ip, new_insns, LOONGARCH_LONG_JUMP_NBYTES);
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1352  	mutex_unlock(&text_mutex);
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1353  
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1354  	return ret;
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1355  }
9fbd18cf4c69f5 Chenghao Duan 2025-08-05  1356  

:::::: The code at line 1322 was first introduced by commit
:::::: 73721d8676771c6c7b06d4e636cc053fc76afefd LoongArch: BPF: Enhance the bpf_arch_text_poke() function

:::::: TO: Chenghao Duan <duanchenghao@kylinos.cn>
:::::: CC: Huacai Chen <chenhuacai@loongson.cn>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

