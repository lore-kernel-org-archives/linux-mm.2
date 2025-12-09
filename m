Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20CED3B98A
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 18:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6FE6B0006; Tue,  9 Dec 2025 13:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67A16B0007; Tue,  9 Dec 2025 13:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B572C6B0008; Tue,  9 Dec 2025 13:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A16686B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 13:06:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53F44B7845
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 18:06:10 +0000 (UTC)
X-FDA: 84200711700.29.EDDC332
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA46AC000E
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 18:06:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JL3CLzO9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765303568; a=rsa-sha256;
	cv=none;
	b=PKNQpdBscRFt5XKm/jHdNe7ExNMTMLDasp1KCXtOhQYacQIQRMd35uRvi9DQCn8JnXbG6V
	oKH+oVbgpCO0Drk2oNliOC9sD5viw1b2NwYWrMB/A4X8UF/NNH5kqe+HSP35Amzu9UgwnP
	vo8SQq4ocZiRA9VAjZ80wx/8xP0ANEI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JL3CLzO9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765303568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iBDKi+mtCQKzJoCUWOyyx0NYDSpQscWdtJyV8tlWwI=;
	b=oxPwbTN2CJ+9FH+YKJH5R1/dZS5v03Wk0XIgVpPBus4JcTtcb54g10KgQrEQ+TziHwjML6
	6IugkbiEc68GtVwYTd7PwZQ4DQadlzRMFYuCSaGasPByk1YtHots7GW6Wsi2fADmIrG/JL
	xtFIkfagYXxxbbf3+S1cbX8fYnOBz/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765303568; x=1796839568;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=07h+7iBXoZF2/As0GV/qDmBkKOgLQ1vyvDX4HcfGzyM=;
  b=JL3CLzO9cWjIyBk+SFpw4cO6M/rYD/KNWHF/4BnV3X5CtjlEgOFYzdJm
   135gfdbgEzEtooOjTcnxRrfYZoANkpd/YsWOHt8zXIJXuLf9QGVKBTCTy
   XwuACPZuDu9NvJf5jaqFumo322H3iAOH3+k/svUha5wq5HeXpZR9GQhC1
   TdJYne6TIUFUhiY9/iPTGcxJMVpkMVx8CB7UZPfYY6ixOd9BH3ZKHpDAf
   UNzsguABgNrRcUqIFgm9FL5EEqLpy6QB1/NMPZSdIlUHirVZdy3Pu6bgC
   XFsl1CS7jVSja9dbcgHPl6va6QWrCODNoRlCHJytYJ5d+OEdDAWT716n0
   g==;
X-CSE-ConnectionGUID: lu1yLHlDSJ+tuyc/IllyCw==
X-CSE-MsgGUID: 2d8p9ovYTJSi8cWQNL9VOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="84680305"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="84680305"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 10:06:06 -0800
X-CSE-ConnectionGUID: xx2RS3ENS1mxbMIde3HKOQ==
X-CSE-MsgGUID: Q8HV4iIJR0mlQaeYpVEStw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="227325758"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 09 Dec 2025 10:05:59 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vT261-0000000028F-1sZw;
	Tue, 09 Dec 2025 18:05:57 +0000
Date: Wed, 10 Dec 2025 02:05:05 +0800
From: kernel test robot <lkp@intel.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>, aou@eecs.berkeley.edu,
	alex@ghiti.fr, andii@kernel.org, andybnac@gmail.com,
	apatel@ventanamicro.com, ast@kernel.org, ben.dooks@codethink.co.uk,
	bjorn@kernel.org, bpf@vger.kernel.org, charlie@rivosinc.com,
	cl@gentwo.org, conor.dooley@microchip.com, cyrilbur@tenstorrent.com,
	daniel@iogearbox.net, debug@rivosinc.com, dennis@kernel.org,
	eddyz87@gmail.com, haoluo@google.com, john.fastabend@gmail.com,
	jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk, martin.lau@linux.dev, palmer@dabbelt.com,
	pjw@kernel.org, puranjay@kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
Message-ID: <202512100134.TRTNjFGL-lkp@intel.com>
References: <20251208034944.73113-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208034944.73113-3-cuiyunhui@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA46AC000E
X-Stat-Signature: r8xsemw47t8g7yawz8cbjmjqbien34rb
X-Rspam-User: 
X-HE-Tag: 1765303567-590290
X-HE-Meta: U2FsdGVkX1+c5eGdBKPgLc8/Xmmc+9vETnQUXlCV6CPnWTP5Yiq4qiPCjeRrGHL7TxNA7JKBQGkOPBmjxij+wxbzQPVTRBl4o/1mcq4mYoA8Oe3m1kRo4385BKpLB7FlxymmV3ThzB5aMP37p0wnyPpZGmXWMnkuHglEaTSUsE4HCZi6zeGw5d2nmUW9PsNne0KSzBTgHDNUifc5pBfCO6yw8hOOHCXcXJgvxqZkIRoxjwTdCsRE0ZFws4ChFQup/nrMZfhpuY+wqF3XIDqsJ5XfIXQ4z/+MVCIdrMMPXrWa2UhLLDb6MiGW8GuX3dn/6/NpPyFs7pAtj0oE0xLgzNP42VQiuVSdrMhPbVdWEuJd2lQ0+cghykNN69UOmEwk0p+lcFJC3puQPCa9Z++sSCmc6dsDLARXP47Qlveam5DPaWr+m0+5IdWu1Cd+o4Yg0Vk2cTLlZewpZ5SJ4YyyzWAlO32EYLxQOyTcspjFmIBtkUszUrdEYFbKr8P6IqDKHYR35XHnWXxljmNyyFok4JbXQIPtrytbb4t70FzxTihNNY4iJ+rrHOvYMvzctzm68Foawp1zqVc/Tq/zahNRm4dw/4+nZx62uiRj/j0140qyDP+lPC4WfQ7wR4XFf4zAPo+0wSBONiVrMOzUOK7h5ITn/2C+qDVLBv7oGHOckn6rJJyO6QRo9Sve4VBPZyFlJc1FPNHPyqy6wCymZkBHyWnwUnMfBTvNY9zbyt/NfPaRjmLGVfS9DFmsgdO7bmrP1hUvDJKlVYQLt1edsnec51B7ZTtHo6SbCBgtvZOTVBdFKYchPPu8Trw8b+0UwQkr+g4qB0Mq9tOKC2rStPgk3rnsSdTdWq3RymQs2qiZfEV71rv1ECnV5Nq16nB4lOdLv9jetrEGt155v5Rtu5k/luG6Eg8Rkxbq1YY4uXmAUAE8C5kssdKxJIXs8J3/jx0uwUnZ1Al/GCJfsdU54KZ
 IeCELw8L
 1qKLSC9IycdkNv7R01a0WLAYfS9sUWMFy7Er3c6rTfef1UUo+zKGI8TTkXCqAVE0PCfI6Ag2ctUADAtMgb0uzYRPV5MCoeNGnvO7wrIo9UFc76wKjQ0abLE6WAe/N43/E0sdbqlrobHb0gK9QAcAbrZzNC5ohVsO7gKtcFfqJb+XLREHQy7bxsY5BHj0dBuRtjEa1PVuxvyPdlHOH3ssfFX4yTcX/Pq1HSgDD2mIhHy+obrlf7pb2d7cpiqUK7vdsaZcl0HD8Xp/QJ8d4MC0c92Z9uSWW685AxrOKSHlE1pyImG+4OJOWeCnsHTMwSgboz5jH1vi+itYV9s/ojcogmtiT+PFgyb1rlMzqzFqKHm+9nRhFD+Zq8ThI8s88T/nsyhfxERnjlmd1GC69RAa0nN38PAIdRsCSsf29WVXQWxRKzuldoBrMPg3V+G51mJmPJ9ZM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yunhui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.18 next-20251209]
[cannot apply to bpf-next/net bpf-next/master bpf/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yunhui-Cui/riscv-remove-irqflags-h-inclusion-in-asm-bitops-h/20251208-115407
base:   linus/master
patch link:    https://lore.kernel.org/r/20251208034944.73113-3-cuiyunhui%40bytedance.com
patch subject: [PATCH v2 2/3] riscv: introduce percpu.h into include/asm
config: riscv-randconfig-r132-20251209 (https://download.01.org/0day-ci/archive/20251210/202512100134.TRTNjFGL-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512100134.TRTNjFGL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512100134.TRTNjFGL-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/gfs2/file.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/mmzone.h, ...):
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
--
   fs/gfs2/trans.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/sched.h):
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)
>> arch/riscv/include/asm/percpu.h:113:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)

vim +113 arch/riscv/include/asm/percpu.h

   108	
   109	#define PERCPU_OP_8_16(op_name, op, expr, final_op)			\
   110		PERCPU_8_16_OP(op_name, op, 8, .b, u8, expr, final_op);		\
   111		PERCPU_8_16_OP(op_name, op, 16, .h, u16, expr, final_op)
   112	
 > 113	PERCPU_OP_8_16(add, add, val, add)
   114	PERCPU_OP_8_16(andnot, and, ~val, and)
   115	PERCPU_OP_8_16(or, or, val, or)
   116	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

