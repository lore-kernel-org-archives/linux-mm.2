Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B321091931
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AB26B0095; Thu, 19 Mar 2026 19:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4056B009F; Thu, 19 Mar 2026 19:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBB66B00A0; Thu, 19 Mar 2026 19:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFF856B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:37:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88C9A1DE8C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:37:53 +0000 (UTC)
X-FDA: 84564427626.14.B11F855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C745080006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:37:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/GyXuLe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8RLNKPZGBgeeC6oP3vrENo9XP7BWDJsphRKsL/5ZvWc=;
	b=twniy5Fmwq+k6ghzgTsWHyIpeS1Yt3ZdYqv7eqGwF5uZlCQfECP1BiPH7+SESyCjHOdAEi
	mmWGFgHDDF3cY9K+NKI8gZdGOGlVAtYerBGuP1aaQRv6+kFN1LN9fUNqtfPbsU7Z1i9VUZ
	1gPKdnyeWD5LNsqEGjNkHw1leMncJ0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963471; a=rsa-sha256;
	cv=none;
	b=jCT0LVlurnkmUFhmmmJ+o5etH0NZg/IKPe/U4VpRmCSCvseXejkPwTBP7wAFOSlulfVn8Q
	EeBTB0w+EfYmi0fddY831JQmmW7EDiZvhD8y+iMiugm4/K/dMiQzqd7j20xBkZfcNPhNLv
	hIKOSvvk0nZ1FMC+CYiKEtTD8gnJ1/E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u/GyXuLe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D73ED60053;
	Thu, 19 Mar 2026 23:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E63C19424;
	Thu, 19 Mar 2026 23:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773963470;
	bh=aIr7TfKEnhjyUIbFo1gldXXuVIRtbjWJ7wqzkAXHWqw=;
	h=Date:From:To:Cc:Subject:From;
	b=u/GyXuLeOODnQupuxN4gi/j2QHgINgQ1hNo5CTyrVLNGqs8vzjdHngIwAzSmsTUjA
	 X72eakAHMuD+3AoMGMVZ4MgvUmiOMpByerI48Um1rss2NBXNVg3HMNjUVCgkzGoaOk
	 RS3HY2PyB54xhHd+wfTk4n6r19xdB8kp1YK3Sipgqcf1eAQCEknBD6SjYxDfBjQ3zH
	 JU9/3P7Ugr8++7Vd3OAparfJWfY5OzHRTGY/JkuKAXRJtkLaDfZJtCp7GlQT6yTBzO
	 vG73YKDoCvyxtZxBQ/DhTz8jIhyig9Ru9KgewBCwe3Nc+a0yWKUISfp1xC/9/uhOkt
	 z3z9+ALBkNgIA==
Date: Thu, 19 Mar 2026 16:37:45 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Michal Clapinski <mclapinski@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: NULL pointer dereference when booting ppc64_guest_defconfig in QEMU
 on -next
Message-ID: <20260319233745.GA769346@ax162>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oKQGQYgdjErEaAqZ"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C745080006
X-Stat-Signature: tm7rjf17efx8851u3s7dsda1pgwbh7hh
X-Rspam-User: 
X-HE-Tag: 1773963471-474894
X-HE-Meta: U2FsdGVkX19w3QMivPzGEBnkNUfQcEkziSdYrmyM1BujvvRR+B2rxPFz4VBYxd9Ee++udpilJKvaeb6oUOA3Ji/6kLj+kdBM/l1DPkhbfRdB6NOYHMjTNV7TwUJJxIs4zcmJeBmpR30w4mytpOmxCmQPYX7WvPhM9+JHTU0ztDA+rv5RujuDEe4j3fqbKJKiTfo9SFL8FMESt8INLNoJNpqZrKbhcfTowcYfCfah6aPy+LMOhIaAsQ8bRWpEB2S5W8iRwwlFCPUgvv0f1ZtkAlgskLpGUVaSrlcE1yUcP5wuedmbSj1QE5QdBz2OaduGYLMtSPDuJ7d8obHGZFd8dLjSsMVcrFxr5em05aoYTvDCR/4r5Boqz8CNcEGS1hhaNFNOmPVI8eGQmhkSd0B42o/deUWYYV+0dfKFim77/NLgycunGcdv2uRe6+IfcwwKlSLzwCgaq/zM7H0O7JkCCi2dPMGnjJ3xxdrISEvsucg8R8nsHErSm6rABG+boqkv1kKZ+YP3CHxQP0AD1fwcNFWDXvTYPZyW5urmiVPYnWeBj0f3ZnmqhL2X3BeWoBNQsb+t403YH9L/ptl+KDjOK0s183VIexGc3uQsiOsVF7W02RL/wMO0k/8X7QoyTSY1OdvMVv+XO1ZD9fdsDOLN+DWFFlXgUPKWRFPe38A/JBIkrIqDWftYMtN+SPhxW2rTsrqaR0mJV4YxFbHPeaGBNPzwYs1ZC2s27EdZ7lDujFPTqeGjBLjbjVxodH0pedbDqIkySIfiaWs+bDhIl/dAb/XMJN/TPH+nUSxshxwnVcruXDQxD1gyk423J46tqwkkJaNlwOL0FMIDDb03+/sOGcV+ZwQZjWc85Qru+yiW/f3kHdDpV76TA8ROn0+X81ffYpoLR/a07MrbOv6CmMckQIOqblNmbmyuucn7wH/6+w4t9kyn+N52Edx3EaHstsEA3AiFBpOFuuvKMEIb9ng
 2IhAw4Cy
 MT3yxVusDNCp6MMxIPdusqniy4gqF6xgx2xosuCgfyDlgSw9yri9dDEoiVCI+BLn0n2E2PdiNZ6bXxD5CpdiLvvU7Y0yBeiWxHE2E0hKbLJ/pFo59wcu7C0eTo7KP01JjQVARf0G68tN420oSNnoryVn4/Hitnx4z9ikYHL9DkSHLpigCbftSNi8d489Uc6PavqnuUhtF9QVQrsxtek2lNbgNsNIkiB9jZZZlHIOIByoWDZKsUbV/HmPxdkh8wcSs+zupyWUNbw0IOQpmJvjyPA8K3bgNNEm53F3XbOH5gUY+bAnV4Y5Q2P6lp/T49oRL68AIxenYV/KhfmJKrmKXb1OMTUhFYixC0eVtJ89nVliKD3nB5PNljenkkZMQ4zGMx1k2WrGqCDmIwVu5n6Gz6jFg+pSyDxlqtbA5TGFIS95LcFrGugSvqSuXMkjiFcZgQjVQT/C55WpxMzEdr0q9PCWLwZUvs6so2dY3eBRRt0RLAeKxeTlhggPcdCsgNiseUUAWPCC5Opst+pwEtM/ZAGdSFlSMNUNuynng1TPTLxzMYhVOEA7gTxrQQJNuZ+BX0aBwlS9SsqdD32dnZuovFGdriJOKvIOjtTmU9/WMS1XKHmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--oKQGQYgdjErEaAqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

I am not really sure whose bug this is, as it only appears when three
seemingly independent patch series are applied together, so I have added
the patch authors and their committers (along with the tracing
maintainers) to this thread. Feel free to expand or reduce that list as
necessary.

Our continuous integration has noticed a crash when booting
ppc64_guest_defconfig in QEMU on the past few -next versions.

  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/23311154492/job/67811527112

This does not appear to be clang related, as it can be reproduced with
GCC 15.2.0 as well. Through multiple bisects, I was able to land on
applying:

  mm: improve RSS counter approximation accuracy for proc interfaces [1]
  vdso/datastore: Allocate data pages dynamically [2]
  kho: fix deferred init of kho scratch [3]

and their dependent changes on top of 7.0-rc4 is enough to reproduce
this (at least on two of my machines with the same commands). I have
attached the diff from the result of the following 'git apply' commands
below, done in a linux-next checkout.

  $ git checkout v7.0-rc4
  HEAD is now at f338e7738378 Linux 7.0-rc4

  # [1]
  $ git diff 60ddf3eed4999bae440d1cf9e5868ccb3f308b64^..087dd6d2cc12c82945ab859194c32e8e977daae3 | git apply -3v
  ...

  # [2]
  # Fix trivial conflict in init/main.c around headers
  $ git diff dc432ab7130bb39f5a351281a02d4bc61e85a14a^..05988dba11791ccbb458254484826b32f17f4ad2 | git apply -3v
  ...

  # [3]
  # Fix conflict in kernel/liveupdate/kexec_handover.c due to lack of kho_mem_retrieve(), just add pfn_is_kho_scratch()
  $ git show 4a78467ffb537463486968232daef1e8a2f105e3 | git apply -3v
  ...

  $ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc64-linux- mrproper ppc64_guest_defconfig vmlinux

  $ curl -LSs https://github.com/ClangBuiltLinux/boot-utils/releases/download/20241120-044434/ppc64-rootfs.cpio.zst | zstd -d >rootfs.cpio

  $ qemu-system-ppc64 \
      -display none \
      -nodefaults \
      -cpu power8 \
      -machine pseries \
      -vga none \
      -kernel vmlinux \
      -initrd rootfs.cpio \
      -m 1G \
      -serial mon:stdio
  ...
  [    0.000000][    T0] Linux version 7.0.0-rc4-dirty (nathan@framework-amd-ryzen-maxplus-395) (powerpc64-linux-gcc (GCC) 15.2.0, GNU ld (GNU Binutils) 2.45) #1 SMP PREEMPT Thu Mar 19 15:45:53 MST 2026
  ...
  [    0.216764][    T1] vgaarb: loaded
  [    0.217590][    T1] clocksource: Switched to clocksource timebase
  [    0.221007][   T12] BUG: Kernel NULL pointer dereference at 0x00000010
  [    0.221049][   T12] Faulting instruction address: 0xc00000000044947c
  [    0.221237][   T12] Oops: Kernel access of bad area, sig: 11 [#1]
  [    0.221276][   T12] BE PAGE_SIZE=64K MMU=Hash  SMP NR_CPUS=2048 NUMA pSeries
  [    0.221359][   T12] Modules linked in:
  [    0.221556][   T12] CPU: 0 UID: 0 PID: 12 Comm: kworker/u4:0 Not tainted 7.0.0-rc4-dirty #1 PREEMPTLAZY
  [    0.221631][   T12] Hardware name: IBM pSeries (emulated by qemu) POWER8 (architected) 0x4d0200 0xf000004 of:SLOF,HEAD pSeries
  [    0.221765][   T12] Workqueue: trace_init_wq tracer_init_tracefs_work_func
  [    0.222065][   T12] NIP:  c00000000044947c LR: c00000000041a584 CTR: c00000000053aa90
  [    0.222084][   T12] REGS: c000000003bc7960 TRAP: 0380   Not tainted  (7.0.0-rc4-dirty)
  [    0.222111][   T12] MSR:  8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 44000204  XER: 00000000
  [    0.222287][   T12] CFAR: c000000000449420 IRQMASK: 0
  [    0.222287][   T12] GPR00: c00000000041a584 c000000003bc7c00 c000000001c08100 c000000002892f20
  [    0.222287][   T12] GPR04: c0000000019cfa68 c0000000019cfa60 0000000000000001 0000000000000064
  [    0.222287][   T12] GPR08: 0000000000000002 0000000000000000 c000000003bba000 0000000000000010
  [    0.222287][   T12] GPR12: c00000000053aa90 c000000002c50000 c000000001ab25f8 c000000001626690
  [    0.222287][   T12] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  [    0.222287][   T12] GPR20: c000000001624868 c000000001ab2708 c0000000019cfa08 c000000001a00d18
  [    0.222287][   T12] GPR24: c0000000019cfa18 fffffffffffffef7 c000000003051205 c0000000019cfa68
  [    0.222287][   T12] GPR28: 0000000000000000 c0000000019cfa60 c000000002894e90 0000000000000000
  [    0.222526][   T12] NIP [c00000000044947c] __find_event_file+0x9c/0x110
  [    0.222572][   T12] LR [c00000000041a584] init_tracer_tracefs+0x274/0xcc0
  [    0.222643][   T12] Call Trace:
  [    0.222690][   T12] [c000000003bc7c00] [c000000000b943b0] tracefs_create_file+0x1a0/0x2b0 (unreliable)
  [    0.222766][   T12] [c000000003bc7c50] [c00000000041a584] init_tracer_tracefs+0x274/0xcc0
  [    0.222791][   T12] [c000000003bc7dc0] [c000000002046f1c] tracer_init_tracefs_work_func+0x50/0x320
  [    0.222809][   T12] [c000000003bc7e50] [c000000000276958] process_one_work+0x1b8/0x530
  [    0.222828][   T12] [c000000003bc7f10] [c00000000027778c] worker_thread+0x1dc/0x3d0
  [    0.222883][   T12] [c000000003bc7f90] [c000000000284c44] kthread+0x194/0x1b0
  [    0.222900][   T12] [c000000003bc7fe0] [c00000000000cf30] start_kernel_thread+0x14/0x18
  [    0.222961][   T12] Code: 7c691b78 7f63db78 2c090000 40820018 e89c0000 49107f21 60000000 2c030000 41820048 ebff0000 7c3ff040 41820038 <e93f0010> 7fa3eb78 81490058 e8890018
  [    0.223190][   T12] ---[ end trace 0000000000000000 ]---
  ...

Interestingly, turning on CONFIG_KASAN appears to hide this, maybe
pointing to some sort of memory corruption (or something timing
related)? If there is any other information I can provide, I am more
than happy to do so.

[1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/
[2]: https://lore.kernel.org/20260304-vdso-sparc64-generic-2-v6-3-d8eb3b0e1410@linutronix.de/
[3]: https://lore.kernel.org/20260311125539.4123672-2-mclapinski@google.com/

Cheers,
Nathan

--oKQGQYgdjErEaAqZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: 8bit

diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
new file mode 100644
index 000000000000..196da056e7b4
--- /dev/null
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -0,0 +1,75 @@
+========================================
+The Hierarchical Per-CPU Counters (HPCC)
+========================================
+
+:Author: Mathieu Desnoyers
+
+Introduction
+============
+
+Counters come in many varieties, each with their own trade offs:
+
+ * A global atomic counter provides a fast read access to the current
+   sum, at the expense of cache-line bouncing on updates. This leads to
+   poor performance of frequent updates from various cores on large SMP
+   systems.
+
+ * A per-cpu split counter provides fast updates to per-cpu counters,
+   at the expense of a slower aggregation (sum). The sum operation needs
+   to iterate over all per-cpu counters to calculate the current total.
+
+The hierarchical per-cpu counters attempt to provide the best of both
+worlds (fast updates, and fast sum) by relaxing requirements on the sum
+accuracy. It allows quickly querying an approximated sum value, along
+with the possible min/max ranges of the associated precise sum. The
+exact precise sum can still be calculated with an iteration on all
+per-cpu counter, but the availability of an approximated sum value with
+possible precise sum min/max ranges allows eliminating candidates which
+are certainly outside of a known target range without the overhead of
+precise sums.
+
+Overview
+========
+
+The herarchical per-cpu counters are organized as a tree with the tree
+root at the bottom (last level) and the first level of the tree
+consisting of per-cpu counters.
+
+The intermediate tree levels contain carry propagation counters. When
+reaching a threshold (batch size), the carry is propagated down the
+tree.
+
+This allows reading an approximated value at the root, which has a
+bounded accuracy (minimum/maximum possible precise sum range) determined
+by the tree topology.
+
+Use Cases
+=========
+
+Use cases HPCC is meant to handle invove tracking resources which are
+used across many CPUs to quickly sum as feedback for decision making to
+apply throttling, quota limits, sort tasks, and perform memory or task
+migration decisions. When considering approximated sums within the
+accuracy range of the decision threshold, the user can either:
+
+ * Be conservative and fast: Consider that the sum has reached the
+   limit as soon as the given limit is within the approximation range.
+
+ * Be aggressive and fast: Consider that the sum is over the
+   limit only when the approximation range is over the given limit.
+
+ * Be precise and slow: Do a precise comparison with the limit, which
+   requires a precise sum when the limit is within the approximated
+   range.
+
+One use-case for these hierarchical counters is to implement a two-pass
+algorithm to speed up sorting picking a maximum/minimunm sum value from
+a set. A first pass compares the approximated values, and then a second
+pass only needs the precise sum for counter trees which are within the
+possible precise sum range of the counter tree chosen by the first pass.
+
+Functions and structures
+========================
+
+.. kernel-doc:: include/linux/percpu_counter_tree.h
+.. kernel-doc:: lib/percpu_counter_tree.c
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d741..612a6da6127a 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *fdt);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+bool pfn_is_kho_scratch(unsigned long pfn);
 
 void kho_memory_init(void);
 
@@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
+static inline bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	return false;
+}
+
 static inline void kho_memory_init(void) { }
 
 static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 6ec5e9ac0699..3e217414e12d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..b2e478b14c87 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3057,38 +3057,47 @@ static inline bool get_user_page_fast_only(unsigned long addr,
 {
 	return get_user_pages_fast_only(addr, 1, gup_flags, pagep) == 1;
 }
+
+static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct mm_struct *mm)
+{
+	unsigned long ptr = (unsigned long)mm;
+
+	ptr += offsetof(struct mm_struct, flexible_array);
+	return (struct percpu_counter_tree_level_item *)ptr;
+}
+
 /*
  * per-process(per-mm_struct) statistics.
  */
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_read_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
 }
 
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_sum_positive(&mm->rss_stat[member]);
+	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 {
-	percpu_counter_add(&mm->rss_stat[member], value);
+	percpu_counter_tree_add(&mm->rss_stat[member], value);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void inc_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_inc(&mm->rss_stat[member]);
+	percpu_counter_tree_add(&mm->rss_stat[member], 1);
 
 	mm_trace_rss_stat(mm, member);
 }
 
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
-	percpu_counter_dec(&mm->rss_stat[member]);
+	percpu_counter_tree_add(&mm->rss_stat[member], -1);
 
 	mm_trace_rss_stat(mm, member);
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae722886..1a808d78245d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,7 +18,7 @@
 #include <linux/page-flags-layout.h>
 #include <linux/workqueue.h>
 #include <linux/seqlock.h>
-#include <linux/percpu_counter.h>
+#include <linux/percpu_counter_tree.h>
 #include <linux/types.h>
 #include <linux/rseq_types.h>
 #include <linux/bitmap.h>
@@ -1118,6 +1118,19 @@ typedef struct {
 	DECLARE_BITMAP(__mm_flags, NUM_MM_FLAG_BITS);
 } __private mm_flags_t;
 
+/*
+ * The alignment of the mm_struct flexible array is based on the largest
+ * alignment of its content:
+ * __alignof__(struct percpu_counter_tree_level_item) provides a
+ * cacheline aligned alignment on SMP systems, else alignment on
+ * unsigned long on UP systems.
+ */
+#ifdef CONFIG_SMP
+# define __mm_struct_flexible_array_aligned	__aligned(__alignof__(struct percpu_counter_tree_level_item))
+#else
+# define __mm_struct_flexible_array_aligned	__aligned(__alignof__(unsigned long))
+#endif
+
 struct kioctx_table;
 struct iommu_mm_data;
 struct mm_struct {
@@ -1263,7 +1276,7 @@ struct mm_struct {
 		unsigned long saved_e_flags;
 #endif
 
-		struct percpu_counter rss_stat[NR_MM_COUNTERS];
+		struct percpu_counter_tree rss_stat[NR_MM_COUNTERS];
 
 		struct linux_binfmt *binfmt;
 
@@ -1374,10 +1387,13 @@ struct mm_struct {
 	} __randomize_layout;
 
 	/*
-	 * The mm_cpumask needs to be at the end of mm_struct, because it
-	 * is dynamically sized based on nr_cpu_ids.
+	 * The rss hierarchical counter items, mm_cpumask, and mm_cid
+	 * masks need to be at the end of mm_struct, because they are
+	 * dynamically sized based on nr_cpu_ids.
+	 * The content of the flexible array needs to be placed in
+	 * decreasing alignment requirement order.
 	 */
-	char flexible_array[] __aligned(__alignof__(unsigned long));
+	char flexible_array[] __mm_struct_flexible_array_aligned;
 };
 
 /* Copy value to the first system word of mm flags, non-atomically. */
@@ -1414,24 +1430,30 @@ static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
-#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
-{								\
-	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT									\
+{													\
+	[0 ... (PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE * NR_MM_COUNTERS) + sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
 }
 
-/* Pointer magic because the dynamic array size confuses some compilers. */
-static inline void mm_init_cpumask(struct mm_struct *mm)
+static inline size_t get_rss_stat_items_size(void)
 {
-	unsigned long cpu_bitmap = (unsigned long)mm;
-
-	cpu_bitmap += offsetof(struct mm_struct, flexible_array);
-	cpumask_clear((struct cpumask *)cpu_bitmap);
+	return percpu_counter_tree_items_size() * NR_MM_COUNTERS;
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	return (struct cpumask *)&mm->flexible_array;
+	unsigned long ptr = (unsigned long)mm;
+
+	ptr += offsetof(struct mm_struct, flexible_array);
+	/* Skip RSS stats counters. */
+	ptr += get_rss_stat_items_size();
+	return (struct cpumask *)ptr;
+}
+
+static inline void mm_init_cpumask(struct mm_struct *mm)
+{
+	cpumask_clear((struct cpumask *)mm_cpumask(mm));
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -1523,6 +1545,8 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 	unsigned long bitmap = (unsigned long)mm;
 
 	bitmap += offsetof(struct mm_struct, flexible_array);
+	/* Skip RSS stats counters. */
+	bitmap += get_rss_stat_items_size();
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
new file mode 100644
index 000000000000..828c763edd4a
--- /dev/null
+++ b/include/linux/percpu_counter_tree.h
@@ -0,0 +1,367 @@
+/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
+/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> */
+
+#ifndef _PERCPU_COUNTER_TREE_H
+#define _PERCPU_COUNTER_TREE_H
+
+#include <linux/preempt.h>
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+
+#ifdef CONFIG_SMP
+
+#if NR_CPUS == (1U << 0)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	0
+#elif NR_CPUS <= (1U << 1)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1
+#elif NR_CPUS <= (1U << 2)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	3
+#elif NR_CPUS <= (1U << 3)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 4)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	7
+#elif NR_CPUS <= (1U << 5)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	11
+#elif NR_CPUS <= (1U << 6)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 7)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	21
+#elif NR_CPUS <= (1U << 8)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	37
+#elif NR_CPUS <= (1U << 9)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	73
+#elif NR_CPUS <= (1U << 10)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	149
+#elif NR_CPUS <= (1U << 11)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	293
+#elif NR_CPUS <= (1U << 12)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	585
+#elif NR_CPUS <= (1U << 13)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	1173
+#elif NR_CPUS <= (1U << 14)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	2341
+#elif NR_CPUS <= (1U << 15)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 16)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	4681
+#elif NR_CPUS <= (1U << 17)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	8777
+#elif NR_CPUS <= (1U << 18)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	17481
+#elif NR_CPUS <= (1U << 19)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	34953
+#elif NR_CPUS <= (1U << 20)
+# define PERCPU_COUNTER_TREE_STATIC_NR_ITEMS	69905
+#else
+# error "Unsupported number of CPUs."
+#endif
+
+struct percpu_counter_tree_level_item {
+	atomic_long_t count;		/*
+					 * Count the number of carry for this tree item.
+					 * The carry counter is kept at the order of the
+					 * carry accounted for at this tree level.
+					 */
+} ____cacheline_aligned_in_smp;
+
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	\
+	(PERCPU_COUNTER_TREE_STATIC_NR_ITEMS * sizeof(struct percpu_counter_tree_level_item))
+
+struct percpu_counter_tree {
+	/* Fast-path fields. */
+	unsigned long __percpu *level0;	/* Pointer to per-CPU split counters (tree level 0). */
+	unsigned long level0_bit_mask;	/* Bit mask to apply to detect carry propagation from tree level 0. */
+	union {
+		unsigned long *i;	/* Approximate sum for single-CPU topology. */
+		atomic_long_t *a;	/* Approximate sum for SMP topology.  */
+	} approx_sum;
+	long bias;			/* Bias to apply to counter precise and approximate values. */
+
+	/* Slow-path fields. */
+	struct percpu_counter_tree_level_item *items;	/* Array of tree items for levels 1 to N. */
+	unsigned long batch_size;	/*
+					 * The batch size is the increment step at level 0 which
+					 * triggers a carry propagation. The batch size is required
+					 * to be greater than 1, and a power of 2.
+					 */
+	/*
+	 * The tree approximate sum is guaranteed to be within this accuracy range:
+	 * (precise_sum - approx_accuracy_range.under) <= approx_sum <= (precise_sum + approx_accuracy_range.over).
+	 * This accuracy is derived from the hardware topology and the tree batch_size.
+	 * The "under" accuracy is larger than the "over" accuracy because the negative range of a
+	 * two's complement signed integer is one unit larger than the positive range. This delta
+	 * is summed for each tree item, which leads to a significantly larger "under" accuracy range
+	 * compared to the "over" accuracy range.
+	 */
+	struct {
+		unsigned long under;
+		unsigned long over;
+	} approx_accuracy_range;
+};
+
+size_t percpu_counter_tree_items_size(void);
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned long batch_size, gfp_t gfp_flags);
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned long batch_size, gfp_t gfp_flags);
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counter, unsigned int nr_counters);
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter);
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc);
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter);
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v);
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b);
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v);
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v);
+int percpu_counter_tree_subsystem_init(void);
+
+/**
+ * percpu_counter_tree_approximate_sum() - Return approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the approximate sum is fast, but it is only accurate within
+ * the bounds delimited by percpu_counter_tree_approximate_accuracy_range().
+ * This is meant to be used when speed is preferred over accuracy.
+ *
+ * Return: The current approximate counter sum.
+ */
+static inline
+long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	unsigned long v;
+
+	if (!counter->level0_bit_mask)
+		v = READ_ONCE(*counter->approx_sum.i);
+	else
+		v = atomic_long_read(counter->approx_sum.a);
+	return (long) (v + (unsigned long)READ_ONCE(counter->bias));
+}
+
+/**
+ * percpu_counter_tree_approximate_accuracy_range - Query the accuracy range for a counter tree.
+ * @counter: Counter to query.
+ * @under: Pointer to a variable to be incremented of the approximation
+ *         accuracy range below the precise sum.
+ * @over: Pointer to a variable to be incremented of the approximation
+ *        accuracy range above the precise sum.
+ *
+ * Query the accuracy range limits for the counter.
+ * Because of two's complement binary representation, the "under" range is typically
+ * slightly larger than the "over" range.
+ * Those values are derived from the hardware topology and the counter tree batch size.
+ * They are invariant for a given counter tree.
+ * Using this function should not be typically required, see the following functions instead:
+ * * percpu_counter_tree_approximate_compare(),
+ * * percpu_counter_tree_approximate_compare_value(),
+ * * percpu_counter_tree_precise_compare(),
+ * * percpu_counter_tree_precise_compare_value().
+ */
+static inline
+void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *counter,
+						    unsigned long *under, unsigned long *over)
+{
+	*under += counter->approx_accuracy_range.under;
+	*over += counter->approx_accuracy_range.over;
+}
+
+#else	/* !CONFIG_SMP */
+
+#define PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE	0
+
+struct percpu_counter_tree_level_item;
+
+struct percpu_counter_tree {
+	atomic_long_t count;
+};
+
+static inline
+size_t percpu_counter_tree_items_size(void)
+{
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned long batch_size, gfp_t gfp_flags)
+{
+	for (unsigned int i = 0; i < nr_counters; i++)
+		atomic_long_set(&counters[i].count, 0);
+	return 0;
+}
+
+static inline
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
+}
+
+static inline
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counter, unsigned int nr_counters)
+{
+}
+
+static inline
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+}
+
+static inline
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return atomic_long_read(&counter->count);
+}
+
+static inline
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	long count_a = percpu_counter_tree_precise_sum(a),
+	     count_b = percpu_counter_tree_precise_sum(b);
+
+	if (count_a == count_b)
+		return 0;
+	if (count_a < count_b)
+		return -1;
+	return 1;
+}
+
+static inline
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	long count = percpu_counter_tree_precise_sum(counter);
+
+	if (count == v)
+		return 0;
+	if (count < v)
+		return -1;
+	return 1;
+}
+
+static inline
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	return percpu_counter_tree_precise_compare(a, b);
+}
+
+static inline
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	return percpu_counter_tree_precise_compare_value(counter, v);
+}
+
+static inline
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
+{
+	atomic_long_set(&counter->count, v);
+}
+
+static inline
+void percpu_counter_tree_approximate_accuracy_range(struct percpu_counter_tree *counter,
+						    unsigned long *under, unsigned long *over)
+{
+}
+
+static inline
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+{
+	atomic_long_add(inc, &counter->count);
+}
+
+static inline
+long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum(counter);
+}
+
+static inline
+int percpu_counter_tree_subsystem_init(void)
+{
+	return 0;
+}
+
+#endif	/* CONFIG_SMP */
+
+/**
+ * percpu_counter_tree_approximate_sum_positive() - Return a positive approximate counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return an approximate counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive approximate counter sum.
+ */
+static inline
+long percpu_counter_tree_approximate_sum_positive(struct percpu_counter_tree *counter)
+{
+	long v = percpu_counter_tree_approximate_sum(counter);
+	return v > 0 ? v : 0;
+}
+
+/**
+ * percpu_counter_tree_precise_sum_positive() - Return a positive precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Return a precise counter sum which is guaranteed to be greater
+ * or equal to 0.
+ *
+ * Return: The current positive precise counter sum.
+ */
+static inline
+long percpu_counter_tree_precise_sum_positive(struct percpu_counter_tree *counter)
+{
+	long v = percpu_counter_tree_precise_sum(counter);
+	return v > 0 ? v : 0;
+}
+
+/**
+ * percpu_counter_tree_approximate_min_max_range() - Return the approximation min and max precise values.
+ * @approx_sum: Approximated sum.
+ * @under: Tree accuracy range (under).
+ * @over: Tree accuracy range (over).
+ * @precise_min: Minimum possible value for precise sum (output).
+ * @precise_max: Maximum possible value for precise sum (output).
+ *
+ * Calculate the minimum and maximum precise values for a given
+ * approximation and (under, over) accuracy range.
+ *
+ * The range of the approximation as a function of the precise sum is expressed as:
+ *
+ *   approx_sum >= precise_sum - approx_accuracy_range.under
+ *   approx_sum <= precise_sum + approx_accuracy_range.over
+ *
+ * Therefore, the range of the precise sum as a function of the approximation is expressed as:
+ *
+ *   precise_sum <= approx_sum + approx_accuracy_range.under
+ *   precise_sum >= approx_sum - approx_accuracy_range.over
+ */
+static inline
+void percpu_counter_tree_approximate_min_max_range(long approx_sum, unsigned long under, unsigned long over,
+						   long *precise_min, long *precise_max)
+{
+	*precise_min = approx_sum - over;
+	*precise_max = approx_sum + under;
+}
+
+/**
+ * percpu_counter_tree_approximate_min_max() - Return the tree approximation, min and max possible precise values.
+ * @counter: The counter to sum.
+ * @approx_sum: Approximate sum (output).
+ * @precise_min: Minimum possible value for precise sum (output).
+ * @precise_max: Maximum possible value for precise sum (output).
+ *
+ * Return the approximate sum, minimum and maximum precise values for
+ * a counter.
+ */
+static inline
+void percpu_counter_tree_approximate_min_max(struct percpu_counter_tree *counter,
+					     long *approx_sum, long *precise_min, long *precise_max)
+{
+	unsigned long under = 0, over = 0;
+	long v = percpu_counter_tree_approximate_sum(counter);
+
+	percpu_counter_tree_approximate_accuracy_range(counter, &under, &over);
+	percpu_counter_tree_approximate_min_max_range(v, under, over, precise_min, precise_max);
+	*approx_sum = v;
+}
+
+#endif  /* _PERCPU_COUNTER_TREE_H */
diff --git a/include/linux/vdso_datastore.h b/include/linux/vdso_datastore.h
index a91fa24b06e0..0b530428db71 100644
--- a/include/linux/vdso_datastore.h
+++ b/include/linux/vdso_datastore.h
@@ -2,9 +2,15 @@
 #ifndef _LINUX_VDSO_DATASTORE_H
 #define _LINUX_VDSO_DATASTORE_H
 
+#ifdef CONFIG_HAVE_GENERIC_VDSO
 #include <linux/mm_types.h>
 
 extern const struct vm_special_mapping vdso_vvar_mapping;
 struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned long addr);
 
+void __init vdso_setup_data_pages(void);
+#else /* !CONFIG_HAVE_GENERIC_VDSO */
+static inline void vdso_setup_data_pages(void) { }
+#endif /* CONFIG_HAVE_GENERIC_VDSO */
+
 #endif /* _LINUX_VDSO_DATASTORE_H */
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index cd7920c81f85..290ccb9fd25d 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -448,7 +448,7 @@ TRACE_EVENT(rss_stat,
 		 */
 		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
-		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
+		__entry->size = (percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);
 	),
 
diff --git a/init/main.c b/init/main.c
index 1cb395dd94e4..453ac9dff2da 100644
--- a/init/main.c
+++ b/init/main.c
@@ -105,6 +105,8 @@
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
 #include <linux/unaligned.h>
+#include <linux/percpu_counter_tree.h>
+#include <linux/vdso_datastore.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -1067,6 +1069,7 @@ void start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
+	percpu_counter_tree_subsystem_init();
 	mm_core_init();
 	maple_tree_init();
 	poking_init();
@@ -1119,6 +1122,7 @@ void start_kernel(void)
 	srcu_init();
 	hrtimers_init();
 	softirq_init();
+	vdso_setup_data_pages();
 	timekeeping_init();
 	time_init();
 
diff --git a/kernel/fork.c b/kernel/fork.c
index bc2bf58b93b6..0de4c8727055 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -134,6 +134,11 @@
  */
 #define MAX_THREADS FUTEX_TID_MASK
 
+/*
+ * Batch size of rss stat approximation
+ */
+#define RSS_STAT_BATCH_SIZE	32
+
 /*
  * Protected counters by write_lock_irq(&tasklist_lock)
  */
@@ -627,14 +632,12 @@ static void check_mm(struct mm_struct *mm)
 			 "Please make sure 'struct resident_page_types[]' is updated as well");
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
-		long x = percpu_counter_sum(&mm->rss_stat[i]);
-
-		if (unlikely(x)) {
+		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
 			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
-				 mm, resident_page_types[i], x,
+				 mm, resident_page_types[i],
+				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
 				 current->comm,
 				 task_pid_nr(current));
-		}
 	}
 
 	if (mm_pgtables_bytes(mm))
@@ -732,7 +735,7 @@ void __mmdrop(struct mm_struct *mm)
 	put_user_ns(mm->user_ns);
 	mm_pasid_drop(mm);
 	mm_destroy_cid(mm);
-	percpu_counter_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
+	percpu_counter_tree_destroy_many(mm->rss_stat, NR_MM_COUNTERS);
 
 	free_mm(mm);
 }
@@ -1125,8 +1128,9 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (mm_alloc_cid(mm, p))
 		goto fail_cid;
 
-	if (percpu_counter_init_many(mm->rss_stat, 0, GFP_KERNEL_ACCOUNT,
-				     NR_MM_COUNTERS))
+	if (percpu_counter_tree_init_many(mm->rss_stat, get_rss_stat_items(mm),
+					  NR_MM_COUNTERS, RSS_STAT_BATCH_SIZE,
+					  GFP_KERNEL_ACCOUNT))
 		goto fail_pcpu;
 
 	mm->user_ns = get_user_ns(user_ns);
@@ -3008,7 +3012,7 @@ void __init mm_cache_init(void)
 	 * dynamically sized based on the maximum CPU number this system
 	 * can have, taking hotplug into account (nr_cpu_ids).
 	 */
-	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
+	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size() + get_rss_stat_items_size();
 
 	mm_cachep = kmem_cache_create_usercopy("mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..ce2786faf044 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1333,6 +1333,23 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+bool pfn_is_kho_scratch(unsigned long pfn)
+{
+	unsigned int i;
+	phys_addr_t scratch_start, scratch_end, phys = __pfn_to_phys(pfn);
+
+	for (i = 0; i < kho_scratch_cnt; i++) {
+		scratch_start = kho_scratch[i].addr;
+		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
+
+		if (scratch_start <= phys && phys < scratch_end)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(pfn_is_kho_scratch);
+
 static __init int kho_out_fdt_setup(void)
 {
 	void *root = kho_out.fdt;
@@ -1421,12 +1438,27 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
+static void __init kho_init_scratch_pages(void)
+{
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return;
+
+	for (int i = 0; i < kho_scratch_cnt; i++) {
+		unsigned long pfn = PFN_DOWN(kho_scratch[i].addr);
+		unsigned long end_pfn = PFN_UP(kho_scratch[i].addr + kho_scratch[i].size);
+		int nid = early_pfn_to_nid(pfn);
+
+		for (; pfn < end_pfn; pfn++)
+			init_deferred_page(pfn, nid);
+	}
+}
+
 static void __init kho_release_scratch(void)
 {
 	phys_addr_t start, end;
 	u64 i;
 
-	memmap_init_kho_scratch_pages();
+	kho_init_scratch_pages();
 
 	/*
 	 * Mark scratch mem as CMA before we return it. That way we
@@ -1453,6 +1485,7 @@ void __init kho_memory_init(void)
 		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
 	} else {
 		kho_reserve_scratch();
+		kho_init_scratch_pages();
 	}
 }
 
diff --git a/lib/Kconfig b/lib/Kconfig
index 0f2fb9610647..0b8241e5b548 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -52,6 +52,18 @@ config PACKING_KUNIT_TEST
 
 	  When in doubt, say N.
 
+config PERCPU_COUNTER_TREE_TEST
+	tristate "Hierarchical Per-CPU counter test" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds Kunit tests for the hierarchical per-cpu counters.
+
+	  For more information on KUnit and unit tests in general,
+	  please refer to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  When in doubt, say N.
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index 1b9ee167517f..abc32420b581 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -181,6 +181,7 @@ obj-$(CONFIG_TEXTSEARCH_KMP) += ts_kmp.o
 obj-$(CONFIG_TEXTSEARCH_BM) += ts_bm.o
 obj-$(CONFIG_TEXTSEARCH_FSM) += ts_fsm.o
 obj-$(CONFIG_SMP) += percpu_counter.o
+obj-$(CONFIG_SMP) += percpu_counter_tree.o
 obj-$(CONFIG_AUDIT_GENERIC) += audit.o
 obj-$(CONFIG_AUDIT_COMPAT_GENERIC) += compat_audit.o
 
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
new file mode 100644
index 000000000000..beb1144e6450
--- /dev/null
+++ b/lib/percpu_counter_tree.c
@@ -0,0 +1,702 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+/*
+ * Split Counters With Tree Approximation Propagation
+ *
+ * * Propagation diagram when reaching batch size thresholds (± batch size):
+ *
+ * Example diagram for 8 CPUs:
+ *
+ * log2(8) = 3 levels
+ *
+ * At each level, each pair propagates its values to the next level when
+ * reaching the batch size thresholds.
+ *
+ * Counters at levels 0, 1, 2 can be kept on a single byte ([-128 .. +127] range),
+ * although it may be relevant to keep them on "long" counters for
+ * simplicity. (complexity vs memory footprint tradeoff)
+ *
+ * Counter at level 3 can be kept on a "long" counter.
+ *
+ * Level 0:  0    1    2    3    4    5    6    7
+ *           |   /     |   /     |   /     |   /
+ *           |  /      |  /      |  /      |  /
+ *           | /       | /       | /       | /
+ * Level 1:  0         1         2         3
+ *           |       /           |       /
+ *           |    /              |    /
+ *           | /                 | /
+ * Level 2:  0                   1
+ *           |               /
+ *           |         /
+ *           |   /
+ * Level 3:  0
+ *
+ * * Approximation accuracy:
+ *
+ * BATCH(level N): Level N batch size.
+ *
+ * Example for BATCH(level 0) = 32.
+ *
+ * BATCH(level 0) =  32
+ * BATCH(level 1) =  64
+ * BATCH(level 2) = 128
+ * BATCH(level N) = BATCH(level 0) * 2^N
+ *
+ *            per-counter     global
+ *            accuracy        accuracy
+ * Level 0:   [ -32 ..  +31]  ±256  (8 * 32)
+ * Level 1:   [ -64 ..  +63]  ±256  (4 * 64)
+ * Level 2:   [-128 .. +127]  ±256  (2 * 128)
+ * Total:      ------         ±768  (log2(nr_cpu_ids) * BATCH(level 0) * nr_cpu_ids)
+ *
+ * Note that the global accuracy can be calculated more precisely
+ * by taking into account that the positive accuracy range is
+ * 31 rather than 32.
+ *
+ * -----
+ *
+ * Approximate Sum Carry Propagation
+ *
+ * Let's define a number of counter bits for each level, e.g.:
+ *
+ * log2(BATCH(level 0)) = log2(32) = 5
+ * Let's assume, for this example, a 32-bit architecture (sizeof(long) == 4).
+ *
+ *               nr_bit        value_mask                      range
+ * Level 0:      5 bits        v                             0 ..  +31
+ * Level 1:      1 bit        (v & ~((1UL << 5) - 1))        0 ..  +63
+ * Level 2:      1 bit        (v & ~((1UL << 6) - 1))        0 .. +127
+ * Level 3:     25 bits       (v & ~((1UL << 7) - 1))        0 .. 2^32-1
+ *
+ * Note: Use a "long" per-cpu counter at level 0 to allow precise sum.
+ *
+ * Note: Use cacheline aligned counters at levels above 0 to prevent false sharing.
+ *       If memory footprint is an issue, a specialized allocator could be used
+ *       to eliminate padding.
+ *
+ * Example with expanded values:
+ *
+ * counter_add(counter, inc):
+ *
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = percpu_add_return(counter @ Level 0, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b00011111);  // Clear used bits
+ *                 // xor bit 5: underflow
+ *                 if ((inc ^ orig ^ res) & 0b00100000)
+ *                         inc -= 0b00100000;
+ *         } else {
+ *                 inc &= ~0b00011111;           // Clear used bits
+ *                 // xor bit 5: overflow
+ *                 if ((inc ^ orig ^ res) & 0b00100000)
+ *                         inc += 0b00100000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = atomic_long_add_return(counter @ Level 1, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b00111111);  // Clear used bits
+ *                 // xor bit 6: underflow
+ *                 if ((inc ^ orig ^ res) & 0b01000000)
+ *                         inc -= 0b01000000;
+ *         } else {
+ *                 inc &= ~0b00111111;           // Clear used bits
+ *                 // xor bit 6: overflow
+ *                 if ((inc ^ orig ^ res) & 0b01000000)
+ *                         inc += 0b01000000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         res = atomic_long_add_return(counter @ Level 2, inc);
+ *         orig = res - inc;
+ *         if (inc < 0) {
+ *                 inc = -(-inc & ~0b01111111);  // Clear used bits
+ *                 // xor bit 7: underflow
+ *                 if ((inc ^ orig ^ res) & 0b10000000)
+ *                         inc -= 0b10000000;
+ *         } else {
+ *                 inc &= ~0b01111111;           // Clear used bits
+ *                 // xor bit 7: overflow
+ *                 if ((inc ^ orig ^ res) & 0b10000000)
+ *                         inc += 0b10000000;
+ *         }
+ *         if (!inc)
+ *                 return;
+ *
+ *         atomic_long_add(counter @ Level 3, inc);
+ */
+
+#include <linux/percpu_counter_tree.h>
+#include <linux/cpumask.h>
+#include <linux/atomic.h>
+#include <linux/export.h>
+#include <linux/percpu.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/math.h>
+
+#define MAX_NR_LEVELS 5
+
+/*
+ * The counter configuration is selected at boot time based on the
+ * hardware topology.
+ */
+struct counter_config {
+	unsigned int nr_items;				/*
+							 * nr_items is the number of items in the tree for levels 1
+							 * up to and including the final level (approximate sum).
+							 * It excludes the level 0 per-CPU counters.
+							 */
+	unsigned char nr_levels;			/*
+							 * nr_levels is the number of hierarchical counter tree levels.
+							 * It excludes the final level (approximate sum).
+							 */
+	unsigned char n_arity_order[MAX_NR_LEVELS];	/*
+							 * n-arity of tree nodes for each level from
+							 * 0 to (nr_levels - 1).
+							 */
+};
+
+static const struct counter_config per_nr_cpu_order_config[] = {
+	[0] =	{ .nr_items = 0,	.nr_levels = 0,		.n_arity_order = { 0 } },
+	[1] =	{ .nr_items = 1,	.nr_levels = 1,		.n_arity_order = { 1 } },
+	[2] =	{ .nr_items = 3,	.nr_levels = 2,		.n_arity_order = { 1, 1 } },
+	[3] =	{ .nr_items = 7,	.nr_levels = 3,		.n_arity_order = { 1, 1, 1 } },
+	[4] =	{ .nr_items = 7,	.nr_levels = 3,		.n_arity_order = { 2, 1, 1 } },
+	[5] =	{ .nr_items = 11,	.nr_levels = 3,		.n_arity_order = { 2, 2, 1 } },
+	[6] =	{ .nr_items = 21,	.nr_levels = 3,		.n_arity_order = { 2, 2, 2 } },
+	[7] =	{ .nr_items = 21,	.nr_levels = 3,		.n_arity_order = { 3, 2, 2 } },
+	[8] =	{ .nr_items = 37,	.nr_levels = 3,		.n_arity_order = { 3, 3, 2 } },
+	[9] =	{ .nr_items = 73,	.nr_levels = 3,		.n_arity_order = { 3, 3, 3 } },
+	[10] =	{ .nr_items = 149,	.nr_levels = 4,		.n_arity_order = { 3, 3, 2, 2 } },
+	[11] =	{ .nr_items = 293,	.nr_levels = 4,		.n_arity_order = { 3, 3, 3, 2 } },
+	[12] =	{ .nr_items = 585,	.nr_levels = 4,		.n_arity_order = { 3, 3, 3, 3 } },
+	[13] =	{ .nr_items = 1173,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 2, 2 } },
+	[14] =	{ .nr_items = 2341,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 3, 2 } },
+	[15] =	{ .nr_items = 4681,	.nr_levels = 5,		.n_arity_order = { 3, 3, 3, 3, 3 } },
+	[16] =	{ .nr_items = 4681,	.nr_levels = 5,		.n_arity_order = { 4, 3, 3, 3, 3 } },
+	[17] =	{ .nr_items = 8777,	.nr_levels = 5,		.n_arity_order = { 4, 4, 3, 3, 3 } },
+	[18] =	{ .nr_items = 17481,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 3, 3 } },
+	[19] =	{ .nr_items = 34953,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 4, 3 } },
+	[20] =	{ .nr_items = 69905,	.nr_levels = 5,		.n_arity_order = { 4, 4, 4, 4, 4 } },
+};
+
+static const struct counter_config *counter_config;	/* Hierarchical counter configuration for the hardware topology. */
+static unsigned int nr_cpus_order;			/* Order of nr_cpu_ids. */
+static unsigned long accuracy_multiplier;		/* Calculate accuracy for a given batch size (multiplication factor). */
+
+static
+int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
+			       unsigned long batch_size, gfp_t gfp_flags,
+			       unsigned long __percpu *level0,
+			       struct percpu_counter_tree_level_item *items)
+{
+	/* Batch size must be greater than 1, and a power of 2. */
+	if (WARN_ON(batch_size <= 1 || (batch_size & (batch_size - 1))))
+		return -EINVAL;
+	counter->batch_size = batch_size;
+	counter->bias = 0;
+	counter->level0 = level0;
+	counter->items = items;
+	if (!nr_cpus_order) {
+		counter->approx_sum.i = per_cpu_ptr(counter->level0, 0);
+		counter->level0_bit_mask = 0;
+	} else {
+		counter->approx_sum.a = &counter->items[counter_config->nr_items - 1].count;
+		counter->level0_bit_mask = 1UL << get_count_order(batch_size);
+	}
+	/*
+	 * Each tree item signed integer has a negative range which is
+	 * one unit greater than the positive range.
+	 */
+	counter->approx_accuracy_range.under = batch_size * accuracy_multiplier;
+	counter->approx_accuracy_range.over = (batch_size - 1) * accuracy_multiplier;
+	return 0;
+}
+
+/**
+ * percpu_counter_tree_init_many() - Initialize many per-CPU counter trees.
+ * @counters: An array of @nr_counters counters to initialize.
+ *	      Their memory is provided by the caller.
+ * @items: Pointer to memory area where to store tree items.
+ *	   This memory is provided by the caller.
+ *	   Its size needs to be at least @nr_counters * percpu_counter_tree_items_size().
+ * @nr_counters: The number of counter trees to initialize
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ * 		carry propagation.
+ *		The batch size is required to be greater than 1, and a power of 2.
+ * @gfp_flags: gfp flags to pass to the per-CPU allocator.
+ *
+ * Initialize many per-CPU counter trees using a single per-CPU
+ * allocator invocation for @nr_counters counters.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
+				  unsigned int nr_counters, unsigned long batch_size, gfp_t gfp_flags)
+{
+	void __percpu *level0, *level0_iter;
+	size_t counter_size = sizeof(*counters->level0),
+	       items_size = percpu_counter_tree_items_size();
+	void *items_iter;
+	unsigned int i;
+	int ret;
+
+	memset(items, 0, items_size * nr_counters);
+	level0 = __alloc_percpu_gfp(nr_counters * counter_size,
+				    __alignof__(*counters->level0), gfp_flags);
+	if (!level0)
+		return -ENOMEM;
+	level0_iter = level0;
+	items_iter = items;
+	for (i = 0; i < nr_counters; i++) {
+		ret = __percpu_counter_tree_init(&counters[i], batch_size, gfp_flags, level0_iter, items_iter);
+		if (ret)
+			goto free_level0;
+		level0_iter += counter_size;
+		items_iter += items_size;
+	}
+	return 0;
+
+free_level0:
+	free_percpu(level0);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init_many);
+
+/**
+ * percpu_counter_tree_init() - Initialize one per-CPU counter tree.
+ * @counter: Counter to initialize.
+ *	     Its memory is provided by the caller.
+ * @items: Pointer to memory area where to store tree items.
+ *	   This memory is provided by the caller.
+ *	   Its size needs to be at least percpu_counter_tree_items_size().
+ * @batch_size: The batch size is the increment step at level 0 which triggers a
+ * 		carry propagation.
+ *		The batch size is required to be greater than 1, and a power of 2.
+ * @gfp_flags: gfp flags to pass to the per-CPU allocator.
+ *
+ * Initialize one per-CPU counter tree.
+ *
+ * Return:
+ * * %0: Success
+ * * %-EINVAL:		- Invalid @batch_size argument
+ * * %-ENOMEM:		- Out of memory
+ */
+int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
+			     unsigned long batch_size, gfp_t gfp_flags)
+{
+	return percpu_counter_tree_init_many(counter, items, 1, batch_size, gfp_flags);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_init);
+
+/**
+ * percpu_counter_tree_destroy_many() - Destroy many per-CPU counter trees.
+ * @counters: Array of counters trees to destroy.
+ * @nr_counters: The number of counter trees to destroy.
+ *
+ * Release internal resources allocated for @nr_counters per-CPU counter trees.
+ */
+
+void percpu_counter_tree_destroy_many(struct percpu_counter_tree *counters, unsigned int nr_counters)
+{
+	free_percpu(counters->level0);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy_many);
+
+/**
+ * percpu_counter_tree_destroy() - Destroy one per-CPU counter tree.
+ * @counter: Counter to destroy.
+ *
+ * Release internal resources allocated for one per-CPU counter tree.
+ */
+void percpu_counter_tree_destroy(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_destroy_many(counter, 1);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_destroy);
+
+static
+long percpu_counter_tree_carry(long orig, long res, long inc, unsigned long bit_mask)
+{
+	if (inc < 0) {
+		inc = -(-inc & ~(bit_mask - 1));
+		/*
+		 * xor bit_mask: underflow.
+		 *
+		 * If inc has bit set, decrement an additional bit if
+		 * there is _no_ bit transition between orig and res.
+		 * Else, inc has bit cleared, decrement an additional
+		 * bit if there is a bit transition between orig and
+		 * res.
+		 */
+		if ((inc ^ orig ^ res) & bit_mask)
+			inc -= bit_mask;
+	} else {
+		inc &= ~(bit_mask - 1);
+		/*
+		 * xor bit_mask: overflow.
+		 *
+		 * If inc has bit set, increment an additional bit if
+		 * there is _no_ bit transition between orig and res.
+		 * Else, inc has bit cleared, increment an additional
+		 * bit if there is a bit transition between orig and
+		 * res.
+		 */
+		if ((inc ^ orig ^ res) & bit_mask)
+			inc += bit_mask;
+	}
+	return inc;
+}
+
+/*
+ * It does not matter through which path the carry propagates up the
+ * tree, therefore there is no need to disable preemption because the
+ * cpu number is only used to favor cache locality.
+ */
+static
+void percpu_counter_tree_add_slowpath(struct percpu_counter_tree *counter, long inc)
+{
+	unsigned int level_items, nr_levels = counter_config->nr_levels,
+		     level, n_arity_order;
+	unsigned long bit_mask;
+	struct percpu_counter_tree_level_item *item = counter->items;
+	unsigned int cpu = raw_smp_processor_id();
+
+	WARN_ON_ONCE(!nr_cpus_order);	/* Should never be called for 1 cpu. */
+
+	n_arity_order = counter_config->n_arity_order[0];
+	bit_mask = counter->level0_bit_mask << n_arity_order;
+	level_items = 1U << (nr_cpus_order - n_arity_order);
+
+	for (level = 1; level < nr_levels; level++) {
+		/*
+		 * For the purpose of carry propagation, the
+		 * intermediate level counters only need to keep track
+		 * of the bits relevant for carry propagation. We
+		 * therefore don't care about higher order bits.
+		 * Note that this optimization is unwanted if the
+		 * intended use is to track counters within intermediate
+		 * levels of the topology.
+		 */
+		if (abs(inc) & (bit_mask - 1)) {
+			atomic_long_t *count = &item[cpu & (level_items - 1)].count;
+			unsigned long orig, res;
+
+			res = atomic_long_add_return_relaxed(inc, count);
+			orig = res - inc;
+			inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
+			if (likely(!inc))
+				return;
+		}
+		item += level_items;
+		n_arity_order = counter_config->n_arity_order[level];
+		level_items >>= n_arity_order;
+		bit_mask <<= n_arity_order;
+	}
+	atomic_long_add(inc, counter->approx_sum.a);
+}
+
+/**
+ * percpu_counter_tree_add() - Add to a per-CPU counter tree.
+ * @counter: Counter added to.
+ * @inc: Increment value (either positive or negative).
+ *
+ * Add @inc to a per-CPU counter tree. This is a fast-path which will
+ * typically increment per-CPU counters as long as there is no carry
+ * greater or equal to the counter tree batch size.
+ */
+void percpu_counter_tree_add(struct percpu_counter_tree *counter, long inc)
+{
+	unsigned long bit_mask = counter->level0_bit_mask, orig, res;
+
+	res = this_cpu_add_return(*counter->level0, inc);
+	orig = res - inc;
+	inc = percpu_counter_tree_carry(orig, res, inc, bit_mask);
+	if (likely(!inc))
+		return;
+	percpu_counter_tree_add_slowpath(counter, inc);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_add);
+
+static
+long percpu_counter_tree_precise_sum_unbiased(struct percpu_counter_tree *counter)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += *per_cpu_ptr(counter->level0, cpu);
+	return (long) sum;
+}
+
+/**
+ * percpu_counter_tree_precise_sum() - Return precise counter sum.
+ * @counter: The counter to sum.
+ *
+ * Querying the precise sum is relatively expensive because it needs to
+ * iterate over all CPUs.
+ * This is meant to be used when accuracy is preferred over speed.
+ *
+ * Return: The current precise counter sum.
+ */
+long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
+{
+	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(counter->bias);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
+
+static
+int compare_delta(long delta, unsigned long accuracy_pos, unsigned long accuracy_neg)
+{
+	if (delta >= 0) {
+		if (delta <= accuracy_pos)
+			return 0;
+		else
+			return 1;
+	} else {
+		if (-delta <= accuracy_neg)
+			return 0;
+		else
+			return -1;
+	}
+}
+
+/**
+ * percpu_counter_tree_approximate_compare - Approximated comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate an approximate comparison of two counter trees.
+ * This approximation comparison is fast, and provides an accurate
+ * answer if the counters are found to be either less than or greater
+ * than the other. However, if the approximated comparison returns
+ * 0, the counters respective sums are found to be within the two
+ * counters accuracy range.
+ *
+ * Return:
+ * * %0		- Counters @a and @b do not differ by more than the sum of their respective
+ *                accuracy ranges.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	return compare_delta(percpu_counter_tree_approximate_sum(a) - percpu_counter_tree_approximate_sum(b),
+			     a->approx_accuracy_range.over + b->approx_accuracy_range.under,
+			     a->approx_accuracy_range.under + b->approx_accuracy_range.over);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare);
+
+/**
+ * percpu_counter_tree_approximate_compare_value - Approximated comparison of a counter tree against a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate an approximate comparison of a counter tree against a given value.
+ * This approximation comparison is fast, and provides an accurate
+ * answer if the counter is found to be either less than or greater
+ * than the value. However, if the approximated comparison returns
+ * 0, the value is within the counter accuracy range.
+ *
+ * Return:
+ * * %0		- The value @v is within the accuracy range of the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	return compare_delta(v - percpu_counter_tree_approximate_sum(counter),
+			     counter->approx_accuracy_range.under,
+			     counter->approx_accuracy_range.over);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare_value);
+
+/**
+ * percpu_counter_tree_precise_compare - Precise comparison of two counter trees.
+ * @a: First counter to compare.
+ * @b: Second counter to compare.
+ *
+ * Evaluate a precise comparison of two counter trees.
+ * As an optimization, it uses the approximate counter comparison
+ * to quickly compare counters which are far apart. Only cases where
+ * counter sums are within the accuracy range require precise counter
+ * sums.
+ *
+ * Return:
+ * * %0		- Counters are equal.
+ * * %-1	- Counter @a less than counter @b.
+ * * %1		- Counter @a is greater than counter @b.
+ */
+int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
+{
+	long count_a = percpu_counter_tree_approximate_sum(a),
+	     count_b = percpu_counter_tree_approximate_sum(b);
+	unsigned long accuracy_a, accuracy_b;
+	long delta = count_a - count_b;
+	int res;
+
+	res = compare_delta(delta,
+			    a->approx_accuracy_range.over + b->approx_accuracy_range.under,
+			    a->approx_accuracy_range.under + b->approx_accuracy_range.over);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/*
+	 * The approximated comparison is within the accuracy range, therefore at least one
+	 * precise sum is needed. Sum the counter which has the largest accuracy first.
+	 */
+	if (delta >= 0) {
+		accuracy_a = a->approx_accuracy_range.under;
+		accuracy_b = b->approx_accuracy_range.over;
+	} else {
+		accuracy_a = a->approx_accuracy_range.over;
+		accuracy_b = b->approx_accuracy_range.under;
+	}
+	if (accuracy_b < accuracy_a) {
+		count_a = percpu_counter_tree_precise_sum(a);
+		res = compare_delta(count_a - count_b,
+				    b->approx_accuracy_range.under,
+				    b->approx_accuracy_range.over);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_b = percpu_counter_tree_precise_sum(b);
+	} else {
+		count_b = percpu_counter_tree_precise_sum(b);
+		res = compare_delta(count_a - count_b,
+				    a->approx_accuracy_range.over,
+				    a->approx_accuracy_range.under);
+		if (res)
+			return res;
+		/* Precise sum of second counter is required. */
+		count_a = percpu_counter_tree_precise_sum(a);
+	}
+	if (count_a - count_b < 0)
+		return -1;
+	if (count_a - count_b > 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare);
+
+/**
+ * percpu_counter_tree_precise_compare_value - Precise comparison of a counter tree against a given value.
+ * @counter: Counter to compare.
+ * @v: Value to compare.
+ *
+ * Evaluate a precise comparison of a counter tree against a given value.
+ * As an optimization, it uses the approximate counter comparison
+ * to quickly identify whether the counter and value are far apart.
+ * Only cases where the value is within the counter accuracy range
+ * require a precise counter sum.
+ *
+ * Return:
+ * * %0		- The value @v is equal to the counter.
+ * * %-1	- The value @v is less than the counter.
+ * * %1		- The value @v is greater than the counter.
+ */
+int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v)
+{
+	long count = percpu_counter_tree_approximate_sum(counter);
+	int res;
+
+	res = compare_delta(v - count,
+			    counter->approx_accuracy_range.under,
+			    counter->approx_accuracy_range.over);
+	/* The values are distanced enough for an accurate approximated comparison. */
+	if (res)
+		return res;
+
+	/* Precise sum is required. */
+	count = percpu_counter_tree_precise_sum(counter);
+	if (v - count < 0)
+		return -1;
+	if (v - count > 0)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare_value);
+
+static
+void percpu_counter_tree_set_bias(struct percpu_counter_tree *counter, long bias)
+{
+	WRITE_ONCE(counter->bias, bias);
+}
+
+/**
+ * percpu_counter_tree_set - Set the counter tree sum to a given value.
+ * @counter: Counter to set.
+ * @v: Value to set.
+ *
+ * Set the counter sum to a given value. It can be useful for instance
+ * to reset the counter sum to 0. Note that even after setting the
+ * counter sum to a given value, the counter sum approximation can
+ * return any value within the accuracy range around that value.
+ */
+void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
+{
+	percpu_counter_tree_set_bias(counter,
+				     v - percpu_counter_tree_precise_sum_unbiased(counter));
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_set);
+
+/*
+ * percpu_counter_tree_items_size - Query the size required for counter tree items.
+ *
+ * Query the size of the memory area required to hold the counter tree
+ * items. This depends on the hardware topology and is invariant after
+ * boot.
+ *
+ * Return: Size required to hold tree items.
+ */
+size_t percpu_counter_tree_items_size(void)
+{
+	if (!nr_cpus_order)
+		return 0;
+	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
+}
+EXPORT_SYMBOL_GPL(percpu_counter_tree_items_size);
+
+static void __init calculate_accuracy_topology(void)
+{
+	unsigned int nr_levels = counter_config->nr_levels, level;
+	unsigned int level_items = 1U << nr_cpus_order;
+	unsigned long batch_size = 1;
+
+	for (level = 0; level < nr_levels; level++) {
+		unsigned int n_arity_order = counter_config->n_arity_order[level];
+
+		/*
+		 * The accuracy multiplier is derived from a batch size of 1
+		 * to speed up calculating the accuracy at tree initialization.
+		 */
+		accuracy_multiplier += batch_size * level_items;
+		batch_size <<= n_arity_order;
+		level_items >>= n_arity_order;
+	}
+}
+
+int __init percpu_counter_tree_subsystem_init(void)
+{
+	nr_cpus_order = get_count_order(nr_cpu_ids);
+	if (WARN_ON_ONCE(nr_cpus_order >= ARRAY_SIZE(per_nr_cpu_order_config))) {
+		printk(KERN_ERR "Unsupported number of CPUs (%u)\n", nr_cpu_ids);
+		return -1;
+	}
+	counter_config = &per_nr_cpu_order_config[nr_cpus_order];
+	calculate_accuracy_topology();
+	return 0;
+}
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index 05f74edbc62b..d282aa23d273 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -56,4 +56,6 @@ obj-$(CONFIG_UTIL_MACROS_KUNIT) += util_macros_kunit.o
 obj-$(CONFIG_RATELIMIT_KUNIT_TEST) += test_ratelimit.o
 obj-$(CONFIG_UUID_KUNIT_TEST) += uuid_kunit.o
 
+obj-$(CONFIG_PERCPU_COUNTER_TREE_TEST) += percpu_counter_tree_kunit.o
+
 obj-$(CONFIG_TEST_RUNTIME_MODULE)		+= module/
diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_counter_tree_kunit.c
new file mode 100644
index 000000000000..a79176655c4b
--- /dev/null
+++ b/lib/tests/percpu_counter_tree_kunit.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0+ OR MIT
+// SPDX-FileCopyrightText: 2026 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+
+#include <kunit/test.h>
+#include <linux/percpu_counter_tree.h>
+#include <linux/kthread.h>
+#include <linux/wait.h>
+#include <linux/random.h>
+
+struct multi_thread_test_data {
+	long increment;
+	int nr_inc;
+	int counter_index;
+};
+
+#define NR_COUNTERS	2
+
+/* Hierarchical per-CPU counter instances. */
+static struct percpu_counter_tree counter[NR_COUNTERS];
+static struct percpu_counter_tree_level_item *items;
+
+/* Global atomic counters for validation. */
+static atomic_long_t global_counter[NR_COUNTERS];
+
+static DECLARE_WAIT_QUEUE_HEAD(kernel_threads_wq);
+static atomic_t kernel_threads_to_run;
+
+static void complete_work(void)
+{
+	if (atomic_dec_and_test(&kernel_threads_to_run))
+		wake_up(&kernel_threads_wq);
+}
+
+static void hpcc_print_info(struct kunit *test)
+{
+	kunit_info(test, "Running test with %d CPUs\n", num_online_cpus());
+}
+
+static void add_to_counter(int counter_index, unsigned int nr_inc, long increment)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_inc; i++) {
+		percpu_counter_tree_add(&counter[counter_index], increment);
+		atomic_long_add(increment, &global_counter[counter_index]);
+	}
+}
+
+static void check_counters(struct kunit *test)
+{
+	int counter_index;
+
+	/* Compare each counter with its global counter. */
+	for (counter_index = 0; counter_index < NR_COUNTERS; counter_index++) {
+		long v = atomic_long_read(&global_counter[counter_index]);
+		long approx_sum = percpu_counter_tree_approximate_sum(&counter[counter_index]);
+		unsigned long under_accuracy = 0, over_accuracy = 0;
+		long precise_min, precise_max;
+
+		/* Precise comparison. */
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[counter_index]), v);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare_value(&counter[counter_index], v));
+
+		/* Approximate comparison. */
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&counter[counter_index], v));
+
+		/* Accuracy limits checks. */
+		percpu_counter_tree_approximate_accuracy_range(&counter[counter_index], &under_accuracy, &over_accuracy);
+
+		KUNIT_EXPECT_GE(test, (long)(approx_sum - (v - under_accuracy)), 0);
+		KUNIT_EXPECT_LE(test, (long)(approx_sum - (v + over_accuracy)), 0);
+		KUNIT_EXPECT_GT(test, (long)(approx_sum - (v - under_accuracy - 1)), 0);
+		KUNIT_EXPECT_LT(test, (long)(approx_sum - (v + over_accuracy + 1)), 0);
+
+		/* Precise min/max range check. */
+		percpu_counter_tree_approximate_min_max_range(approx_sum, under_accuracy, over_accuracy, &precise_min, &precise_max);
+
+		KUNIT_EXPECT_GE(test, v - precise_min, 0);
+		KUNIT_EXPECT_LE(test, v - precise_max, 0);
+		KUNIT_EXPECT_GT(test, v - (precise_min - 1), 0);
+		KUNIT_EXPECT_LT(test, v - (precise_max + 1), 0);
+	}
+	/* Compare each counter with the second counter. */
+	KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&counter[0]), percpu_counter_tree_precise_sum(&counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_precise_compare(&counter[0], &counter[1]));
+	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(&counter[0], &counter[1]));
+}
+
+static int multi_thread_worker_fn(void *data)
+{
+	struct multi_thread_test_data *td = data;
+
+	add_to_counter(td->counter_index, td->nr_inc, td->increment);
+	complete_work();
+	kfree(td);
+	return 0;
+}
+
+static void test_run_on_specific_cpu(struct kunit *test, int target_cpu, int counter_index, unsigned int nr_inc, long increment)
+{
+	struct task_struct *task;
+	struct multi_thread_test_data *td = kzalloc(sizeof(struct multi_thread_test_data), GFP_KERNEL);
+
+	KUNIT_EXPECT_PTR_NE(test, td, NULL);
+	td->increment = increment;
+	td->nr_inc = nr_inc;
+	td->counter_index = counter_index;
+	atomic_inc(&kernel_threads_to_run);
+	task = kthread_run_on_cpu(multi_thread_worker_fn, td, target_cpu, "kunit_multi_thread_worker");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, task);
+}
+
+static void init_kthreads(void)
+{
+	atomic_set(&kernel_threads_to_run, 1);
+}
+
+static void fini_kthreads(void)
+{
+	/* Release our own reference. */
+	complete_work();
+	/* Wait for all others threads to run. */
+	wait_event(kernel_threads_wq, (atomic_read(&kernel_threads_to_run) == 0));
+}
+
+static void test_sync_kthreads(void)
+{
+	fini_kthreads();
+	init_kthreads();
+}
+
+static void init_counters(struct kunit *test, unsigned long batch_size)
+{
+	int i, ret;
+
+	items = kzalloc(percpu_counter_tree_items_size() * NR_COUNTERS, GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, items, NULL);
+	ret = percpu_counter_tree_init_many(counter, items, NR_COUNTERS, batch_size, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	for (i = 0; i < NR_COUNTERS; i++)
+		atomic_long_set(&global_counter[i], 0);
+}
+
+static void fini_counters(void)
+{
+	percpu_counter_tree_destroy_many(counter, NR_COUNTERS);
+	kfree(items);
+}
+
+enum up_test_inc_type {
+	INC_ONE,
+	INC_MINUS_ONE,
+	INC_RANDOM,
+};
+
+/*
+ * Single-threaded tests. Those use many threads to run on various CPUs,
+ * but synchronize for completion of each thread before running the
+ * next, effectively making sure there are no concurrent updates.
+ */
+static void do_hpcc_test_single_thread(struct kunit *test, int _cpu0, int _cpu1, enum up_test_inc_type type)
+{
+	unsigned long batch_size_order = 5;
+	int cpu0 = _cpu0;
+	int cpu1 = _cpu1;
+	int i;
+
+	init_counters(test, 1UL << batch_size_order);
+	init_kthreads();
+	for (i = 0; i < 10000; i++) {
+		long increment;
+
+		switch (type) {
+		case INC_ONE:
+			increment = 1;
+			break;
+		case INC_MINUS_ONE:
+			increment = -1;
+			break;
+		case INC_RANDOM:
+			increment = (long) get_random_long() % 50000;
+			break;
+		}
+		if (_cpu0 < 0)
+			cpu0 = cpumask_any_distribute(cpu_online_mask);
+		if (_cpu1 < 0)
+			cpu1 = cpumask_any_distribute(cpu_online_mask);
+		test_run_on_specific_cpu(test, cpu0, 0, 1, increment);
+		test_sync_kthreads();
+		test_run_on_specific_cpu(test, cpu1, 1, 1, increment);
+		test_sync_kthreads();
+		check_counters(test);
+	}
+	fini_kthreads();
+	fini_counters();
+}
+
+static void hpcc_test_single_thread_first(struct kunit *test)
+{
+	int cpu = cpumask_first(cpu_online_mask);
+
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_ONE);
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, cpu, cpu, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_first_random(struct kunit *test)
+{
+	int cpu = cpumask_first(cpu_online_mask);
+
+	do_hpcc_test_single_thread(test, cpu, -1, INC_ONE);
+	do_hpcc_test_single_thread(test, cpu, -1, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, cpu, -1, INC_RANDOM);
+}
+
+static void hpcc_test_single_thread_random(struct kunit *test)
+{
+	do_hpcc_test_single_thread(test, -1, -1, INC_ONE);
+	do_hpcc_test_single_thread(test, -1, -1, INC_MINUS_ONE);
+	do_hpcc_test_single_thread(test, -1, -1, INC_RANDOM);
+}
+
+/* Multi-threaded SMP tests. */
+
+static void do_hpcc_multi_thread_increment_each_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpu, 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_even_cpus(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpu & ~1, 1, nr_inc, increment); /* even cpus. */
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_single_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpumask_first(cpu_online_mask), 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void do_hpcc_multi_thread_increment_random_cpu(struct kunit *test, unsigned long batch_size, unsigned int nr_inc, long increment)
+{
+	int cpu;
+
+	init_counters(test, batch_size);
+	init_kthreads();
+	for_each_online_cpu(cpu) {
+		test_run_on_specific_cpu(test, cpu, 0, nr_inc, increment);
+		test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+	}
+	fini_kthreads();
+	check_counters(test);
+	fini_counters();
+}
+
+static void hpcc_test_multi_thread_batch_increment(struct kunit *test)
+{
+	unsigned long batch_size_order;
+
+	for (batch_size_order = 2; batch_size_order < 10; batch_size_order++) {
+		unsigned int nr_inc;
+
+		for (nr_inc = 1; nr_inc < 1024; nr_inc *= 2) {
+			long increment;
+
+			for (increment = 1; increment < 100000; increment *= 10) {
+				do_hpcc_multi_thread_increment_each_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_even_cpus(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_single_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+				do_hpcc_multi_thread_increment_random_cpu(test, 1UL << batch_size_order, nr_inc, increment);
+			}
+		}
+	}
+}
+
+static void hpcc_test_multi_thread_random_walk(struct kunit *test)
+{
+	unsigned long batch_size_order = 5;
+	int loop;
+
+	for (loop = 0; loop < 100; loop++) {
+		int i;
+
+		init_counters(test, 1UL << batch_size_order);
+		init_kthreads();
+		for (i = 0; i < 1000; i++) {
+			long increment = (long) get_random_long() % 512;
+			unsigned int nr_inc = ((unsigned long) get_random_long()) % 1024;
+
+			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 0, nr_inc, increment);
+			test_run_on_specific_cpu(test, cpumask_any_distribute(cpu_online_mask), 1, nr_inc, increment);
+		}
+		fini_kthreads();
+		check_counters(test);
+		fini_counters();
+	}
+}
+
+static void hpcc_test_init_one(struct kunit *test)
+{
+	struct percpu_counter_tree pct;
+	struct percpu_counter_tree_level_item *counter_items;
+	int ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	percpu_counter_tree_destroy(&pct);
+	kfree(counter_items);
+}
+
+static void hpcc_test_set(struct kunit *test)
+{
+	static long values[] = {
+		5, 100, 127, 128, 255, 256, 4095, 4096, 500000, 0,
+		-5, -100, -127, -128, -255, -256, -4095, -4096, -500000,
+	};
+	struct percpu_counter_tree pct;
+	struct percpu_counter_tree_level_item *counter_items;
+	int i, ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+	KUNIT_EXPECT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+
+	for (i = 0; i < ARRAY_SIZE(values); i++) {
+		long v = values[i];
+
+		percpu_counter_tree_set(&pct, v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), v);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, v));
+
+		percpu_counter_tree_add(&pct, v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), 2 * v);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, 2 * v));
+
+		percpu_counter_tree_add(&pct, -2 * v);
+		KUNIT_EXPECT_EQ(test, percpu_counter_tree_precise_sum(&pct), 0);
+		KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare_value(&pct, 0));
+	}
+
+	percpu_counter_tree_destroy(&pct);
+	kfree(counter_items);
+}
+
+static struct kunit_case hpcc_test_cases[] = {
+	KUNIT_CASE(hpcc_print_info),
+	KUNIT_CASE(hpcc_test_single_thread_first),
+	KUNIT_CASE(hpcc_test_single_thread_first_random),
+	KUNIT_CASE(hpcc_test_single_thread_random),
+	KUNIT_CASE(hpcc_test_multi_thread_batch_increment),
+	KUNIT_CASE(hpcc_test_multi_thread_random_walk),
+	KUNIT_CASE(hpcc_test_init_one),
+	KUNIT_CASE(hpcc_test_set),
+	{}
+};
+
+static struct kunit_suite hpcc_test_suite = {
+	.name = "percpu_counter_tree",
+	.test_cases = hpcc_test_cases,
+};
+
+kunit_test_suite(hpcc_test_suite);
+
+MODULE_DESCRIPTION("Test cases for hierarchical per-CPU counters");
+MODULE_LICENSE("Dual MIT/GPL");
diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index a565c30c71a0..faebf5b7cd6e 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -1,64 +1,92 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
-#include <linux/linkage.h>
-#include <linux/mmap_lock.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/time_namespace.h>
 #include <linux/types.h>
 #include <linux/vdso_datastore.h>
 #include <vdso/datapage.h>
 
-/*
- * The vDSO data page.
- */
+static u8 vdso_initdata[VDSO_NR_PAGES * PAGE_SIZE] __aligned(PAGE_SIZE) __initdata = {};
+
 #ifdef CONFIG_GENERIC_GETTIMEOFDAY
-static union {
-	struct vdso_time_data	data;
-	u8			page[PAGE_SIZE];
-} vdso_time_data_store __page_aligned_data;
-struct vdso_time_data *vdso_k_time_data = &vdso_time_data_store.data;
-static_assert(sizeof(vdso_time_data_store) == PAGE_SIZE);
+struct vdso_time_data *vdso_k_time_data __refdata =
+	(void *)&vdso_initdata[VDSO_TIME_PAGE_OFFSET * PAGE_SIZE];
+
+static_assert(sizeof(struct vdso_time_data) <= PAGE_SIZE);
 #endif /* CONFIG_GENERIC_GETTIMEOFDAY */
 
 #ifdef CONFIG_VDSO_GETRANDOM
-static union {
-	struct vdso_rng_data	data;
-	u8			page[PAGE_SIZE];
-} vdso_rng_data_store __page_aligned_data;
-struct vdso_rng_data *vdso_k_rng_data = &vdso_rng_data_store.data;
-static_assert(sizeof(vdso_rng_data_store) == PAGE_SIZE);
+struct vdso_rng_data *vdso_k_rng_data __refdata =
+	(void *)&vdso_initdata[VDSO_RNG_PAGE_OFFSET * PAGE_SIZE];
+
+static_assert(sizeof(struct vdso_rng_data) <= PAGE_SIZE);
 #endif /* CONFIG_VDSO_GETRANDOM */
 
 #ifdef CONFIG_ARCH_HAS_VDSO_ARCH_DATA
-static union {
-	struct vdso_arch_data	data;
-	u8			page[VDSO_ARCH_DATA_SIZE];
-} vdso_arch_data_store __page_aligned_data;
-struct vdso_arch_data *vdso_k_arch_data = &vdso_arch_data_store.data;
+struct vdso_arch_data *vdso_k_arch_data __refdata =
+	(void *)&vdso_initdata[VDSO_ARCH_PAGES_START * PAGE_SIZE];
 #endif /* CONFIG_ARCH_HAS_VDSO_ARCH_DATA */
 
+void __init vdso_setup_data_pages(void)
+{
+	unsigned int order = get_order(VDSO_NR_PAGES * PAGE_SIZE);
+	struct page *pages;
+
+	/*
+	 * Allocate the data pages dynamically. SPARC does not support mapping
+	 * static pages to be mapped into userspace.
+	 * It is also a requirement for mlockall() support.
+	 *
+	 * Do not use folios. In time namespaces the pages are mapped in a different order
+	 * to userspace, which is not handled by the folio optimizations in finish_fault().
+	 */
+	pages = alloc_pages(GFP_KERNEL, order);
+	if (!pages)
+		panic("Unable to allocate VDSO storage pages");
+
+	/* The pages are mapped one-by-one into userspace and each one needs to be refcounted. */
+	split_page(pages, order);
+
+	/* Move the data already written by other subsystems to the new pages */
+	memcpy(page_address(pages), vdso_initdata, VDSO_NR_PAGES * PAGE_SIZE);
+
+	if (IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
+		vdso_k_time_data = page_address(pages + VDSO_TIME_PAGE_OFFSET);
+
+	if (IS_ENABLED(CONFIG_VDSO_GETRANDOM))
+		vdso_k_rng_data = page_address(pages + VDSO_RNG_PAGE_OFFSET);
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
+		vdso_k_arch_data = page_address(pages + VDSO_ARCH_PAGES_START);
+}
+
 static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 			     struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct page *timens_page = find_timens_vvar_page(vma);
-	unsigned long addr, pfn;
-	vm_fault_t err;
+	struct page *page, *timens_page;
+
+	timens_page = find_timens_vvar_page(vma);
 
 	switch (vmf->pgoff) {
 	case VDSO_TIME_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_GENERIC_GETTIMEOFDAY))
 			return VM_FAULT_SIGBUS;
-		pfn = __phys_to_pfn(__pa_symbol(vdso_k_time_data));
+		page = virt_to_page(vdso_k_time_data);
 		if (timens_page) {
 			/*
 			 * Fault in VVAR page too, since it will be accessed
 			 * to get clock data anyway.
 			 */
+			unsigned long addr;
+			vm_fault_t err;
+
 			addr = vmf->address + VDSO_TIMENS_PAGE_OFFSET * PAGE_SIZE;
-			err = vmf_insert_pfn(vma, addr, pfn);
+			err = vmf_insert_page(vma, addr, page);
 			if (unlikely(err & VM_FAULT_ERROR))
 				return err;
-			pfn = page_to_pfn(timens_page);
+			page = timens_page;
 		}
 		break;
 	case VDSO_TIMENS_PAGE_OFFSET:
@@ -71,24 +99,25 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 		 */
 		if (!IS_ENABLED(CONFIG_TIME_NS) || !timens_page)
 			return VM_FAULT_SIGBUS;
-		pfn = __phys_to_pfn(__pa_symbol(vdso_k_time_data));
+		page = virt_to_page(vdso_k_time_data);
 		break;
 	case VDSO_RNG_PAGE_OFFSET:
 		if (!IS_ENABLED(CONFIG_VDSO_GETRANDOM))
 			return VM_FAULT_SIGBUS;
-		pfn = __phys_to_pfn(__pa_symbol(vdso_k_rng_data));
+		page = virt_to_page(vdso_k_rng_data);
 		break;
 	case VDSO_ARCH_PAGES_START ... VDSO_ARCH_PAGES_END:
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_VDSO_ARCH_DATA))
 			return VM_FAULT_SIGBUS;
-		pfn = __phys_to_pfn(__pa_symbol(vdso_k_arch_data)) +
-			vmf->pgoff - VDSO_ARCH_PAGES_START;
+		page = virt_to_page(vdso_k_arch_data) + vmf->pgoff - VDSO_ARCH_PAGES_START;
 		break;
 	default:
 		return VM_FAULT_SIGBUS;
 	}
 
-	return vmf_insert_pfn(vma, vmf->address, pfn);
+	get_page(page);
+	vmf->page = page;
+	return 0;
 }
 
 const struct vm_special_mapping vdso_vvar_mapping = {
@@ -100,7 +129,7 @@ struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
 					VM_READ | VM_MAYREAD | VM_IO | VM_DONTDUMP |
-					VM_PFNMAP | VM_SEALED_SYSMAP,
+					VM_MIXEDMAP | VM_SEALED_SYSMAP,
 					&vdso_vvar_mapping);
 }
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..ae6a5af46bd7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..7363b5b0d22a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -786,7 +786,8 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
 	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_deferred_page(pfn, nid);
+		if (!pfn_is_kho_scratch(pfn))
+			__init_deferred_page(pfn, nid);
 
 		/*
 		 * no need for atomic set_bit because the struct
@@ -1996,9 +1997,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
+		for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
+			if (pfn_is_kho_scratch(page_to_pfn(page + i)))
+				continue;
 			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
 					false);
+		}
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2007,7 +2011,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
+		if (pageblock_aligned(pfn) && !pfn_is_kho_scratch(pfn))
 			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
 					false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
@@ -2078,9 +2082,11 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
-			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			// KHO scratch is MAX_ORDER_NR_PAGES aligned.
+			if (!pfn_is_kho_scratch(spfn))
+				deferred_init_pages(zone, spfn, chunk_end);
 
+			deferred_free_pages(spfn, chunk_end - spfn);
 			spfn = chunk_end;
 
 			if (can_resched)
@@ -2088,6 +2094,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			else
 				touch_nmi_watchdog();
 		}
+		nr_pages += epfn - spfn;
 	}
 
 	return nr_pages;

--oKQGQYgdjErEaAqZ--

