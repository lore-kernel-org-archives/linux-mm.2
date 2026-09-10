Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB38C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4A56B008A; Wed,  9 Sep 2026 23:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C855B6B008C; Wed,  9 Sep 2026 23:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52A36B0092; Wed,  9 Sep 2026 23:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 891F76B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:29:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21B29C03B5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:29:28 +0000 (UTC)
X-FDA: 85196422416.06.33FB926
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 28B0640008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:29:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yjbwx+9V;
	spf=pass (imf07.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789010966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TEznphyxn1qeQSYeoLfnXmS+cZcuPR9YWMNrjN6++Os=;
	b=QUVDUnmQ7ljapS902s4MLg6ewWLwKqVwHXk4zeZELYqeJM7RnZou4SwdEIPLf49oSMqwrZ
	6x2ml9tAMTHyBtfCF1/ZeFtcldHWB8PpiCyqVbcPsATHOhmFNXkU7/zTzIhDG3CMfP3t8Q
	G4szelHD5+xgtqLZbk2qmm4xFp72rUY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yjbwx+9V;
	spf=pass (imf07.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789010966;
	b=PTH2h4RVxYOHDVK4Qq6qM4FoNnQSuaBnlG7CjNYz8LqgnP/A7ohaAovtOYn/vd3FjK0gN/
	vq6bILinqV2JtowNcphUvhbSCbUtoPYHIE6PIMgmTClIUIPGEunmer4rQNfotU9vcqMdEn
	00uVwD7JXwGEIb+6EjKDI6AeKYvoUdQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789010965; x=1820546965;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=R5ZmA9ZvPvP1QNDogTCVyoFtS7h5Z+UX4hS7ENIPH24=;
  b=Yjbwx+9VWLaibPWG8CJDr03Q+5iAeLlqg6jUxSLUqhF0JKOjmPfaeblh
   GAFYwipaO/BgdTov++Fbxh+3XVcXPZcjvsB2Us++5COoQ5aot9haiokK5
   l3yfgH+SU3qcxaWtk4X4+n7hNZ5rRgArHogHyCnwbgPBW4hUkBoJdoQX4
   KyxIT1jSO/R6kXnh3Hz/C8H2l5lMcC59tnZwtn29NOA+yTjBFiJgTFM8d
   sXCAoOTvUDzVPIC9XOviIbTTelyC6wUzHV6q62fdj3tOamGaT01N9dAm9
   lyLUl8lFkrYK7K28XOvy9Nar2LMt/zKOJh3fNhAvNI9M2mrJE7EHMjeG+
   A==;
X-CSE-ConnectionGUID: QP+tJFXFRdaRjl6iSyjZmA==
X-CSE-MsgGUID: Ux7PA+cgTcmAbQWRPPdCyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="93276733"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="93276733"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:29:24 -0700
X-CSE-ConnectionGUID: Gg1zQX4CT9aLpslbT2VlIw==
X-CSE-MsgGUID: Kd1uG4YoQhqLtUm6gTu4iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="275646486"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 20:29:22 -0700
Date: Thu, 10 Sep 2026 11:29:18 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Eliot Courtney <ecourtney@nvidia.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linus:master] [lib]  f4806cc63c:
 INFO:trying_to_register_non-static_key
Message-ID: <202609101106.771b567e-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28B0640008
X-Stat-Signature: 6yr9un9uw9t9s69c7yznu7yxg8akugrm
X-Rspam-User: 
X-HE-Tag: 1789010964-874020
X-HE-Meta: U2FsdGVkX193yYVb49Nczc5f7eHaURahRc+4nc0M+EgcWHeh1IUwUsYsajpuxx2SVzWo6ZFlIdrP2oR82MDzC8fkGg1hgaS729lbA1LfeKqavYVCXai+4IPv3f9fTSTgqGxLTCeFjyulFcPImvN3qXiJvHqaDGyRcS2SHuAElBBEdWpQZHBLiNq3JzjYCEA/Mi2rGWEyJTa1slEu5dVUES/isWQ2TZUyq4ttjv8OwMM9q2yT8od/zdFTP36RqYx2f1e5zF9k/1dqEOWnVOF8SvU5ruAes70rePb1bOUw+YyLs05fxlBy84FzXXQIkDWQRf/EZ58NhJMDGMRZwTDUNCQzh85GtPPzQhmbH3VNPIE1W6ShPMPmy9c/ZLFeLNDiNff9pRtL3N3AFUuJWsUa6TYkn99aa/eQ1hgUN6ObEJsfN5JESS4w/guulm7ynL8L+ivMtbxrYCatjk84ad+NxoFimOvCz5lZSfXWElZwN2VBI/aiqRWkQI4MLxC502qVogp4S0GuRIBIlWRLfLptHVWLQlW3O3iAVSqcAjJKHCxXIkX9YT3CoAoGqZkmOx2rd17AsxJ5Natd5r1c23SuYwzgPzxgBsbTnIqRoXiZLe0kbO37ElFhWO3m4YXCTKlDGha2QlZqm1oUKy8SfuWnUBdnXqk481HZ8JR7pKcOjARqhmlaSgarNoBJZ31NDr12GMvDC0zGkOefIsuM2P3zKp3C0Hz1A7LuevwcROW0RAZmKVNK4vLJ8lCZypW3CnFcAlyw5HO+odLx/Hj1KHHHanKS4OiBhmTEHKfELr4gu6vgb7hzdMtyrwEhH1e4xVtkXCtn1cH1xVXtqy5SmBVxzHrFePyHowcDdgyjiUXYRq9PSaLpb+DrRw48KNAqRYgMo6h9OfejD4UFXhIVZYSiVSg2yGTdiGgqhLuIzSXkVGU5su6TWjddA37CN9VLqlmmUftNzaQZjHOsMMcigtQ
 7yOrOtyF
 Tgo1cuUMY22datO2FLzGQo8grXTJ7bkdnrSFl0kFG7DBt3wMDJCGJf8wE5BA3FsEo6vkTPSlKICmQve5TWG3tGegGycc06yly1Yfq+BPTkMqrNY2A0bCkUrPc+CJ6Qf9QFKAUBXyhMvH9Eol0DSgIzzca6s4jPoEfwzCKP3n2bIhkwZxT6QYxQozHX9FFiF6/n0TWA/QDdpNFe55DBICXZpUxmOwLswONkiI6dmiu1glqTO5aBXBXGa/vbePsTckOeR+obXM7+pKbgimxVKdIBEFHTqeUFMLGXnHCHusRSH54EDsX2DsEyKXg8rGvNpqI3deR9Q8l4yp9Y6y50IUQlJr0CwIx1ctLzvZJhKQv/RZOQUUuLtIKxmbWfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "INFO:trying_to_register_non-static_key" on:

commit: f4806cc63cc65bd752fd72d84937614dca6504ec ("lib: test bitmap vs IDA vs Maple Tree performance for region allocations") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master a9d7ced84989ec05be09b4b8428759ef60450a0f]

in testcase: boot

config: i386-randconfig-054-20260822
compiler: gcc-14
test machine: qemu-system-i386 -enable-kvm -cpu SandyBridge -smp 2 -m 4G

If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202609101106.771b567e-lkp@intel.com

[  157.121248][    T1] INFO: trying to register non-static key.
[  157.122147][    T1] The code is fine but needs lockdep annotation, or maybe
[  157.122147][    T1] you didn't initialize this object before use?
[  157.122147][    T1] turning off the locking correctness validator.
[  157.122147][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.2.0-rc4-00086-gf4806cc63cc6 #1 PREEMPT(full)  167be1ded5cf2d764b5931072317f04af057210f
[  157.122147][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  157.122147][    T1] Call Trace:
[  157.122147][    T1]  ? show_stack (x86/kernel/dumpstack.c:319 x86/kernel/dumpstack.c:337)
[  157.122147][    T1]  ? dump_stack_lvl (dump_stack.c:94 dump_stack.c:120)
[  157.122147][    T1]  ? dump_stack (dump_stack.c:129)
[  157.122147][    T1]  ? register_lock_class (locking/lockdep.c:984 locking/lockdep.c:1299)
[  157.122147][    T1]  ? __lock_acquire (locking/lockdep.c:5237)
[  157.122147][    T1]  ? __lock_acquire (locking/lockdep.c:5112)
[  157.122147][    T1]  ? lock_acquire (locking/lockdep.c:5872)
[  157.122147][    T1]  ? mtree_alloc_range (linux/spinlock.h:342 maple_tree.c:5800)
[  157.122147][    T1]  ? __lock_acquire (locking/lockdep.c:5237)
[  157.122147][    T1]  ? lock_acquire (locking/lockdep.c:5833)
[  157.122147][    T1]  ? mtree_alloc_range (linux/spinlock.h:342 maple_tree.c:5800)
[  157.122147][    T1]  ? _raw_spin_lock (linux/spinlock_api_smp.h:158 (discriminator 1) locking/spinlock.c:158 (discriminator 1))
[  157.122147][    T1]  ? mtree_alloc_range (linux/spinlock.h:342 maple_tree.c:5800)
[  157.122147][    T1]  ? __lock_release+0x42/0x140
[  157.122147][    T1]  ? kvm_clock_get_cycles (x86/kernel/kvmclock.c:80 (discriminator 1) x86/kernel/kvmclock.c:87 (discriminator 1))
[  157.122147][    T1]  ? ktime_get (time/timekeeping.c:321 time/timekeeping.c:455 time/timekeeping.c:973)
[  157.122147][    T1]  ? vprintk_default (printk/printk.c:2494)
[  157.122147][    T1]  ? benchmark_maple_tree (region_alloc_benchmark.c:136 (discriminator 1))
[  157.122147][    T1]  ? region_alloc_benchmark (region_alloc_benchmark.c:197 (discriminator 1))
[  157.122147][    T1]  ? benchmark_ida (region_alloc_benchmark.c:124)
[  157.122147][    T1]  ? do_one_initcall (main.c:1347)
[  157.122147][    T1]  ? do_initcalls (main.c:1409 (discriminator 1) main.c:1425 (discriminator 1))
[  157.122147][    T1]  ? kernel_init_freeable (main.c:1445 main.c:1658)
[  157.122147][    T1]  ? rest_init (main.c:717)
[  157.122147][    T1]  ? kernel_init (main.c:1548)
[  157.122147][    T1]  ? ret_from_fork (x86/kernel/process.c:158)
[  157.122147][    T1]  ? rest_init (main.c:717)
[  157.122147][    T1]  ? ret_from_fork_asm (x86/entry/entry_32.S:736)
[  157.122147][    T1]  ? entry_INT80_32 (x86/entry/entry_32.S:940)
[  158.731005][    C0] clocksource: Marking clocksource tsc unstable due to frequency skew
[  158.804793][    C0] clocksource: Watchdog               kvm-clock interval:            63117ns
[  158.871025][    C0] clocksource: Clocksource                  tsc interval:            62703ns
[  158.935843][    C0] tsc: Marking TSC unstable due to clocksource watchdog

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260910/202609101106.771b567e-lkp@intel.com

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



