Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628B7D711C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919C66B0088; Thu, 18 Dec 2025 16:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F12D6B0089; Thu, 18 Dec 2025 16:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7226B008A; Thu, 18 Dec 2025 16:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 672136B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:49:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D8B0C038D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:49:37 +0000 (UTC)
X-FDA: 84233933994.19.4C95623
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3536A16000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:49:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dnfHpco4;
	spf=pass (imf08.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766094574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSUSXWk89hI9/EDnvyCElvY9u46O/v34cM58Hh3o7v8=;
	b=esQKPxL/pDkFR2U7mP9mLaUV38U205n4XbxoX9/PS7JQY5OwccOHLh+Vp5RoEQvRkfDOEk
	pq14Jnoxv/thL9cf/HwxuxU41q5J3nbhjCCmSA4xLZoH3rqOhP5flPrwXM7z79yBQGnYgg
	YFGo2yEhklfr0pgzVmxEVs8pmRSxBdg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dnfHpco4;
	spf=pass (imf08.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766094574; a=rsa-sha256;
	cv=none;
	b=VAF/2BEByhDTy6/UdS8mG5PpeBxm3Q1/uGwO1EsI+DrmHaMCAMXUdlbsvPdcbiOzZT/K8F
	vnZ/ly1MrNlu+d7+blgoDfnZnaZme55JUvZuCFew0CZSaOv0Em72S6JwHNsEHajufRUpP4
	K0wAwrWtR6B5hKGKf52+9preSepfU0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766094574; x=1797630574;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=M06MCaIb8PWS7kX0AksYLwEq4wJXXsnFR5/EpfqCjgQ=;
  b=dnfHpco4OWL+dxwD9dGQx8aooSml3UzjW0T+Y942K/lbUzW+G4NKRsLj
   +WfnNzhwqdc+edJZ36XqA2Jwr4lqwa4tAEPITtgP9ZrtrZTEqzN8P4cuv
   OOcIreJXNpirWFdxoP/pE06E49McSA+GWucIS9OY1Q8xSmVY8GhH3epwx
   +j5Z/i5NBMa+vpBk8KdXZFgpuWQpgF4TrSE8lDjHsVddpebq/reN+9KcV
   B1V8pRROAZVDqi/oAviRherGdHtBYyAQv7n5IzgC9uMCmSV+y2epl1+oL
   pplUX0L6VQ9+phmCViTqE1xmodboK+hXkuJmo+gfJOcMcJg4vLJ1tAMaI
   A==;
X-CSE-ConnectionGUID: iFetKHCwROKP/Qdq8dEBbQ==
X-CSE-MsgGUID: Mspt89mNTJ6ED/gwgKTGXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="71918900"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="71918900"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 13:49:33 -0800
X-CSE-ConnectionGUID: 2Rmht5HYTJ6BZFsCRCf/fA==
X-CSE-MsgGUID: vLF7f0OOR4uyXFAXQ/ODSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="197953858"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 13:49:33 -0800
Date: Thu, 18 Dec 2025 13:56:13 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org,
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com,
	dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	ricardo.neri@intel.com
Subject: Re: [PATCH v2 11/13] kho: Allow kexec load before KHO finalization
Message-ID: <20251218215613.GA17304@ranerica-svr.sc.intel.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-12-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114190002.3311679-12-pasha.tatashin@soleen.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Stat-Signature: jf979szdimh7nzgcob7noqncjaag19fx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3536A16000E
X-HE-Tag: 1766094573-398830
X-HE-Meta: U2FsdGVkX1/jULgY0muT3MnEKcIzNevspjbvOXLfX1XZlsg+ab2DdMlbYb4qYGlbWtqW0sROUAd8By6/ABmHvV6XJ95x2n2fYfi89WWawnCRvrStM9SM70aRhyl7MdtkOMS6SGqJAhfBEWnDu8x81tDb0cQQCnh0D5YsD3KyKJ6pglrk7KOxBUe3p75LJdOrdDOboeo9E+irhMsnO/5eTviLjtQI1BQVANeNUyf6jn86zlr+ksYpBg15AUlszjgsjzsNwXU9z3h0pZVzgCALtXTR9G5CuCb7chFqijq0Gmp7w9bZy/+tQFltq15K6ab43Vht+0+KH34oiU60brZLBWTH+D6RPdt+HqIPKJ0sTgM5vAXYt7Gg/FM06Yo9E5/urd8Jk12umh4q0gkBZEWDxIiBUHZIc5/00kUc9RP00HDHRnej5i9FAZhjylZbKtRN5sclEaGJu2gTnLrNIbU6sSjiAg1lCG9pU2L7seKEd7WF7sMMceMB4YKvO8WScZSMmiVjpJfHnekH0Bsa+6QJIX+3t8qlw3KhFrGVBzbA4p/9Sm0miqZ03LJSCikEobc1UmlnOwy2JdiwyAYDjuIBGWPRfVl1qBGwte9uzP/z5Yv9bP1mKQHEAQwYCqdYLRarS7cFbL0QmbVE9p3wqdaYeY1y9FqN30yNOmV378i+a7oO8kYRiXBAy00TCEdtAMSv43JmTk1jTJKL3JHLb0aiDRk2QG9mrdQBVz24RaaVlVzaVDHGSIbgLldDsKqFtVHeLrmYNWd0DD3BvGqVp6DTCeS+5BG284mmKfxSfdAoy7HZcFjHQyvSxDsbY6dflcv+yfrH6O+PkD2eeoseRr81TYjGXNHMZ1Crp/KRbjTR0ghtw2k5UGJx+G2B19KMvQgtpPoLEFouh937I4BevoFVVGxL7hT3SZRwlp9Y4QJjbu1B8cM/myJFTSW5WTVxqpEAluxGj9dh48ntbyv9FtD
 w3+zjC0B
 Ii9+Ka3M3uv7rxbgYNNpcXKwNUL+kWFLIwkQ7kNWdEtR2KnARCd9Uju7MN6M3Sn9EdChckyEi7+eIFM+YCkrQ1x/YCXgpLGnc/8fjbjZ8D1InQxoeEckcvhFZoWnnTnLrji0SDxoqyrL1csFS72U/97oZWR/J/rFa9v+1XkIVjh9lFK7JxgDR/qAejspylkozryq7kgO0GlfSQghdh6kdg91Gfay1GYyVnKobeCXCiC8Fxma3fykhM98o612xBnoSfdhz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 02:00:00PM -0500, Pasha Tatashin wrote:
> Currently, kho_fill_kimage() checks kho_out.finalized and returns
> early if KHO is not yet finalized. This enforces a strict ordering where
> userspace must finalize KHO *before* loading the kexec image.
> 
> This is restrictive, as standard workflows often involve loading the
> target kernel early in the lifecycle and finalizing the state (FDT)
> only immediately before the reboot.
> 
> Since the KHO FDT resides at a physical address allocated during boot
> (kho_init), its location is stable. We can attach this stable address
> to the kimage regardless of whether the content has been finalized yet.
> 
> Relax the check to only require kho_enable, allowing kexec_file_load
> to proceed at any time.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 461d96084c12..4596e67de832 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1550,7 +1550,7 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_out.finalized)
> +	if (!kho_enable)
>  		return 0;

Hi Pasha,

Using v6.19-rc1 (which has this changeset) and with:

CONFIG_KEXEC_HANDOVER=y
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_LIVEUPDATE=n (i.e., nobody calling kho_finalize())
no reserve_mem= entries in the kernel command line

I omit doing

echo 1 > /sys/kernel/debug/kho/out/finalize

before doing

kexec -l <kernel> --initrd=<initrd> --commandline="$(cat /proc/cmdline)"
kexec -e

After the kexec reboot, I see endless warnings about list corruption [1]
and from _text_poke() [2] (see below).

The post-kexec kernel finds KHO data but it obviously is empty because
nobody was using it.

I was expecting that KHO would handle this use case gracefully. What if a
distro does not finalize KHO before kexec and are no in-kernel users?

Am I missing anything?

Thanks and BR,
Ricardo

[1]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/lib/list_debug.c?h=v6.19-rc1#n56
[2]. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/alternative.c?h=v6.19-rc1#n2506

[   10.730845] ------------[ cut here ]------------
[   10.734848] list_del corruption, ffffd143c1330008->next is LIST_POISON1 (dead000000000100)
[   10.742846] WARNING: lib/list_debug.c:56 at __list_del_entry_valid_or_report+0x91/0x110, CPU#12: swapper/0/1
[   10.750845] Modules linked in:
[   10.754845] CPU: 12 UID: 0 PID: 1 Comm: swapper/0 Tainted: G S  B   W           6.19.0-rc1-ranerica-vanilla #1440 PREEMPT(voluntary)
[   10.766845] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [W]=WARN
[   10.786846] RIP: 0010:__list_del_entry_valid_or_report+0x97/0x110
[   10.790845] Code: eb e2 48 8d 3d 9a 0a 5a 01 48 89 de 67 48 0f b9 3a 31 c0 eb cf 4c 89 e7 e8 b6 d9 b8 ff 48 8d 3d 8f 0a 5a 01 4c 89 e2 48 89 de <67> 48 0f b9 3a 31 c0 eb b1 4c 89 ef e8 98 d9 b8 ff 48 8d 3d 81 0a
[   10.810845] RSP: 0000:ffff960b000b3c20 EFLAGS: 00010046
[   10.814845] RAX: 0000000000000011 RBX: ffffd143c1330008 RCX: 0000000000000000
[   10.822845] RDX: dead000000000100 RSI: ffffd143c1330008 RDI: ffffffffa11c0cb0
[   10.830845] RBP: ffff960b000b3c38 R08: 0000000000000000 R09: 0000000000000003
[   10.838845] R10: ffff960b000b3a80 R11: ffffffffa0f470e8 R12: dead000000000100
[   10.842862] R13: dead000000000122 R14: ffffd143c1338000 R15: 0000000000000004
[   10.850845] FS:  0000000000000000(0000) GS:ffff8af4bc88d000(0000) knlGS:0000000000000000
[   10.858861] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.866845] CR2: 0000000000000000 CR3: 0000000428c3a001 CR4: 0000000000370ef0
[   10.870845] Call Trace:
[   10.874845]  <TASK>
[   10.878845]  __free_one_page+0x2b5/0x840
[   10.882845]  free_pcppages_bulk+0x1cd/0x2f0
[   10.886845]  free_frozen_page_commit.isra.0+0x219/0x460
[   10.890845]  __free_frozen_pages+0x37b/0x700
[   10.894845]  ___free_pages+0xa0/0xb0
[   10.898845]  __free_pages+0x10/0x20
[   10.902845]  init_cma_reserved_pageblock+0x4f/0x90
[   10.906845]  kho_init+0x1ef/0x250
[   10.910845]  ? __pfx_kho_init+0x10/0x10
[   10.914845]  do_one_initcall+0x6a/0x3c0
[   10.918845]  kernel_init_freeable+0x1c8/0x3b0
[   10.922845]  ? __pfx_kernel_init+0x10/0x10
[   10.926845]  kernel_init+0x1a/0x1c0
[   10.930857]  ret_from_fork+0x256/0x2e0
[   10.934845]  ? __pfx_kernel_init+0x10/0x10
[   10.938845]  ret_from_fork_asm+0x1a/0x30
[   10.942844]  </TASK>
[   10.942846] irq event stamp: 926677
[   10.946845] hardirqs last  enabled at (926677): [<ffffffffa04064d2>] dump_stack_lvl+0xb2/0xe0
[   10.954845] hardirqs last disabled at (926676): [<ffffffffa0406475>] dump_stack_lvl+0x55/0xe0
[   10.962845] softirqs last  enabled at (926576): [<ffffffff9f4b6383>] __irq_exit_rcu+0xc3/0x120
[   10.970850] softirqs last disabled at (926571): [<ffffffff9f4b6383>] __irq_exit_rcu+0xc3/0x120
[   10.982845] ---[ end trace 0000000000000000 ]---
[   10.986845]  non-paged memory
[   10.986845] ------------[ cut here ]------------

[   49.243722] ------------[ cut here ]------------
[   49.243723] WARNING: arch/x86/kernel/alternative.c:2506 at __text_poke+0x42b/0x470, CPU#20: kworker/20:0/104
[   49.243725] Modules linked in:
[   49.243726] CPU: 20 UID: 0 PID: 104 Comm: kworker/20:0 Tainted: G S  B   W           6.19.0-rc1-ranerica-vanilla #1440 PREEMPT(voluntary)
[   49.243728] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [W]=WARN
[   49.243730] Workqueue: events intel_pstste_sched_itmt_work_fn
[   49.243732] RIP: 0010:__text_poke+0x42b/0x470
[   49.243733] Code: 21 d0 49 09 c0 e9 06 ff ff ff 4c 8b 45 98 4c 2b 05 9a db 7f 01 49 c1 e0 06 49 21 d0 e9 ef fe ff ff 0f 0b 0f 0b e9 58 fd ff ff <0f> 0b e9 6c fc ff ff e8 89 9a ff 00 e9 07 fe ff ff 0f 0b e9 b2 fe
[   49.243734] RSP: 0000:ffffae7dc054bbe8 EFLAGS: 00010246
[   49.243736] RAX: fffffa9c10d9d000 RBX: ffffffff8ed40a4d RCX: fffffa9c00000000
[   49.243736] RDX: 4000000000000000 RSI: ffffffff8ed40a4d RDI: ffffffff8ed40a4d
[   49.243737] RBP: ffffae7dc054bc58 R08: 0000000000000000 R09: 0000000000000001
[   49.243738] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[   49.243739] R13: ffffffff8ec43830 R14: 0000000000000a4d R15: 0000000000000a4e
[   49.243740] FS:  0000000000000000(0000) GS:ffff9dc10ca8d000(0000) knlGS:0000000000000000
[   49.243741] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   49.243742] CR2: 0000000000000000 CR3: 000000043803a001 CR4: 0000000000370ef0
[   49.243743] Call Trace:
[   49.243743]  <TASK>
[   49.243745]  ? partition_sched_domains+0x15d/0x520
[   49.243748]  smp_text_poke_batch_finish+0xd5/0x3f0
[   49.243751]  arch_jump_label_transform_apply+0x1c/0x30
[   49.243753]  __jump_label_update+0xcf/0x110
[   49.243757]  jump_label_update+0x134/0x200
[   49.243760]  __static_key_slow_dec_cpuslocked.part.0+0x5b/0x70
[   49.243763]  static_key_slow_dec_cpuslocked+0x45/0x80
[   49.243765]  partition_sched_domains+0x3b7/0x520
[   49.243768]  ? partition_sched_domains+0x7c/0x520
[   49.243771]  sched_set_itmt_support+0xe2/0x110
[   49.243773]  intel_pstste_sched_itmt_work_fn+0xe/0x20
[   49.243775]  process_one_work+0x238/0x6f0
[   49.243780]  worker_thread+0x1e8/0x3c0
[   49.243783]  ? __pfx_worker_thread+0x10/0x10
[   49.243786]  kthread+0x12e/0x260
[   49.243788]  ? __pfx_kthread+0x10/0x10
[   49.243791]  ret_from_fork+0x256/0x2e0
[   49.243793]  ? __pfx_kthread+0x10/0x10
[   49.243795]  ret_from_fork_asm+0x1a/0x30
[   49.243801]  </TASK>
[   49.243802] irq event stamp: 80
[   49.243802] hardirqs last  enabled at (79): [<ffffffff8fc513f7>] _raw_spin_unlock_irq+0x27/0x60
[   49.243805] hardirqs last disabled at (80): [<ffffffff8fc45581>] __schedule+0xb31/0x1210
[   49.243808] softirqs last  enabled at (0): [<ffffffff8eca82fd>] copy_process+0xadd/0x21d0
[   49.243810] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   49.243811] ---[ end trace 0000000000000000 ]---
[   49.244076] ------------[ cut here ]------------



>  
>  	image->kho.fdt = virt_to_phys(kho_out.fdt);
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

