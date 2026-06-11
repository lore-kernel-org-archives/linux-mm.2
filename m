Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 779BECD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D38F6B0005; Thu, 11 Jun 2026 03:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584286B0088; Thu, 11 Jun 2026 03:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A086B008C; Thu, 11 Jun 2026 03:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38CC86B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:17:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC4A51C3237
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:17:49 +0000 (UTC)
X-FDA: 84866777058.29.10067BE
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id DEBB1100009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:17:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sy5dx0+f;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781162268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQhvUZ/DbKf6/FrlFmNBUBTYC4OnQ9SUq8CAmtvtmpA=;
	b=Wcj64pKh1HxUcGLkk3VQ45Vjv1gtLxUoumJW9jowyWnDxEZgqrNSupaUGa9i/paS6tIZ6D
	zgtkNBQwdxNwdV/TTEjuPmjcAPaS0N3LkdB8v32kbh8eJLG2z1q6aR/5sQYLBLQBLY1+Jr
	TUM/Hk9eoiOT+DE3XSOVVA1LTcdhs08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781162268;
	b=kwIygnQW5StAcUqV/Kj8Jf88UiNLSqQl9weKdWNphmrzKQANcA8aSJSjaH2RA0UoJkUSyE
	qfkymcJuPb6cFFD7jBPyx/i4V5CIXAfVt9CGqljJW36SkKguQJOZ35ExWja/0XDUtyIkRU
	Xe8x735IY7fMpUscrrPBacTMVoZuCG4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sy5dx0+f;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id B2D35D1438;
	Thu, 11 Jun 2026 07:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1781162265;
	bh=SQhvUZ/DbKf6/FrlFmNBUBTYC4OnQ9SUq8CAmtvtmpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sy5dx0+foJ2ScZ4tBYFnB4DhLS92V5pg+v0SGYTkem1nbyFd6xfJTyFf9OYEhfLwJ
	 ZaAc/VbC7/EOornnQ7Y6s4ARfBsV0d9MxWFS+NCaBc1HINhdYGNHKpn29lf2DyNF1K
	 8iW896swJPRi2QnuCHQ4br1eZusJ65henUh4DGAA=
Date: Thu, 11 Jun 2026 07:17:41 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 5/7] locking: Add contended_release tracepoint to
 qspinlock
Message-ID: <aiphFXe_TPNPxZ_n@shell.ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
 <5d7ea75ffe74a785e6b234ada9f23c6373d4b4c1.1777999826.git.d@ilvokhin.com>
 <20260513193342.GB2545104@noisy.programming.kicks-ass.net>
 <agXBb0ga_6HJrrnm@shell.ilvokhin.com>
 <20260603120811.GW3493090@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260603120811.GW3493090@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: DEBB1100009
X-Rspam-User: 
X-Stat-Signature: cq4w5wdkztfgrecaex8dh1d3gmpu6r8r
X-Rspamd-Server: rspam08
X-HE-Tag: 1781162267-982167
X-HE-Meta: U2FsdGVkX18IUahntZxHb76q3JoDa7bhkTM34mxYdVhJDsKo7S6xiyC1oSPd9PAFOo/E5NB5Tqc5E8/kIczu+3T8vQ1GYLRCXWEnYTvMbr+ZKQwda95rNyI1XR98xsdPxaGdOT8iChq5SXIdSOOLd1v6ZlDaehlQSBJng87sh2RNQRhjq/GEtejREQ6u9+gsgbeOXokTDTyaaWcXS6RhUvFPpPWblyKbp+59bwrE7GwJWfQujPO0adYkUtGFd2MHJ2D0I8OnWgC3t7cI9igEFH9z4qx++TgSilMHjtmZ5/n72wML3MsvjmZu+Bp1vX7xU7Bp4lcyp6Rs8HDsVBCE2ltCIT2IFUnjAoIKyoqVWjUwGAOvUQdVxqp9qYqMdorp3eJ1U2PM4OT9ihYG8IMxJMK5lEHGhZsarYCbaHOryr8RdPNRmm2iEM77abc0k1eTb97AR0mqV8TnmNaqvzy8wL+TDQ8p86taPNKcWCggq5nwPtPlbFwMrH8UhCFRKzY0XT6F6+esIpWLh7V1kqW0sPoXnvrz26Y8iGpynOPGQR6LRK1V6VdX1A/50Mmy94eBAGpXowitsM+9murh7Wfz+NeVnWX29HnpfcVlVWE/YVzjxPtz0nKEXuPY0MNb4veDLqmn8CvoHJWI4QG/DRmHwhK3LYmAKc94WuD1XcbesWju183Ve7QrtiM1r1sx5wzxmiWY4TsW4lcvr6RQ5iAuza/GbhQdsNC0hs/c4HzoPZ/icgTr2f9OTnkQMCEM+PZiSn2D18wll33mScP6rdBhDsoGArECwVQ3EGqk2tE6Qyj4x4gxzgPKBckpH6RDnP2G8nysXGBRBzwJcQeY4A78XqzBwwM1DuRrNoXDiLCbog2njiOO0nqbxbvpg3fs1PDGCP0ymuS+sthJUiksJBXQECSX1wNMlUyZEXfIRcCk/fu0sss0wuOM+gSqz+plpX02Q3QS/GYSRcTCoYo0M2u
 JZ4H2u19
 t0ZHcbTQGSBMsZMu9IeyiUKeYYXhVW13I/ecGpJQXixj4ztgWEXPPrGiv8TcwlmPL1IupnZeFbiVRReTzSsKJEKfz6Ajs1WXTJ/8KlZfPouOYPEVlIr4G+lBg99ibKRJYKliSn/E3GfDhq3K1kkSp4L9IrOOM9NWP3e7pGoVoHN0Lr/4oQY4qdmrM06PXbVDFzivD6uELCAktqa8gqryBP88LwXp7DDNBf2Q7m718DkliGzyX7t4m7pKjTi5qmZkF1eVEYF5E9EgyoPKij/9xQC8a/gNKo1J+wp7jfUthXw5/6xIJVSi8yEB3/Bk5ne4TNSuYVxWPdjDGxBmBJRdHHNcn4hCkGGAL0FTtUe/Mt23mebnfup3pmenCrhqiNFCTXfU39zzF3VS0+b6j17FqiioNxe8qbbfxoMy3ykLHWONRiE3IaEl6U33yO+dPIwNrq7tqmKQpilj/rJMMzukUNV/1RkMo11xrWiTml3H6why8/LWo+KZkZ/PKeCXWLTyOUzi8DmEAubp/dWbwjNcDwcW4Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 02:08:11PM +0200, Peter Zijlstra wrote:
> Also, I think someone should go do some performance runs with
> ARCH_INLINE_SPIN_* set for x86 just like for s390.

As promised, I set ARCH_INLINE_SPIN_UNLOCK{,_BH,_IRQ,_IRQRESTORE} for
x86 and measured the effect on a few real workloads.

Short version: inlining of _raw_spin_unlock() adds measurable kernel
i-cache pressure on every workload I tried, and on a
kernel-i-cache-bound one (nginx connection churn) it costs ~1.27%
throughput. I did not find a workload where it helps.

HOW BENCHMARKS WERE CHOSEN

The cost of inlining unlock is text footprint increase. Every unlock
site grows, and the extra bytes compete for the shared L1i. The bill is
paid by unrelated code, in both kernel and userspace.

Locktorture and similar microbenchmarks can't see this, because they
usually hammer a tiny loop that stays L1i-resident, so they measure
fast-path cycles, where inlining (fewer instructions per unlock) looks
neutral-to-good.

To make the cost visible, the workload has to have real instruction
cache pressure. To achieve that, it has to touch a lot of code.

A good way to screen benchmarks: look for high tma_frontend_bound
fraction from 'perf stat -M TopdownL1' and simultaneously require it to
spend non-trivial time in the kernel (be syscall-heavy).

SETUP

Hardware: 2x Intel Xeon Gold 6138 (Skylake-SP), 20 cores/socket, 40C/80T
with kernel built from locking/core branch. Baseline _raw_spin_unlock()
is out-of-line via UNINLINE_SPIN_UNLOCK=y. Experiment adds the four
selects above (exact patch is at the end of this message). Cache
geometry (lscpu -C):

NAME ONE-SIZE ALL-SIZE WAYS TYPE        LEVEL  SETS PHY-LINE COHERENCY-SIZE
L1d       32K     1.3M    8 Data            1    64        1             64
L1i       32K     1.3M    8 Instruction     1    64        1             64
L2         1M      40M   16 Unified         2  1024        1             64
L3      27.5M      55M   11 Unified         3 40960        1             64

Per run I collected cycles, instructions and L1i-misses. To stay within
the available PMU counters, each run used only 3 events: cycles,
instructions and one L1i filter (:u or :k). The NMI watchdog was off and
every run reported 100% counter enablement (no multiplexing). Userspace
and kernel misses therefore come from separate runs. Each benchmark was
run 20x per side: 10 with the :u counter, 10 with :k.  Cycles,
instructions and throughput are pooled across all 20, each L1i split
comes from its 10.

KERNEL IMAGE SIZE

To give a sense of the code-footprint increase, scripts/bloat-o-meter on
vmlinux, GCC 11, x86_64, defconfig + CONFIG_PARAVIRT_SPINLOCKS=y:

    Total: Before=23838694, After=23977159, chg +0.58%

ROCKSDB (DELETESEQ)

    db_bench -benchmarks=deleteseq

Metric                       Baseline      Experiment     Delta   Sig
----------------------------------------------------------------------
Instructions (total)    9,574,476,543   9,573,602,441    -0.01%   flat
L1i-miss :k (kernel)      198,588,165     216,672,536    +9.11%   **
L1i-miss :u (userspace)   593,276,235     616,433,813    +3.90%   **
Throughput ops/s            431,398         432,897      +0.35%   ns
Cycles (total)          4,681,002,302   4,665,106,876    -0.34%   ns
IPC                          2.045           2.052       +0.33%   ns
Time elapsed (s)            2.4012          2.3865       -0.62%   ns
----------------------------------------------------------------------
L1i-miss: higher = worse. Throughput: higher = better.
** = beyond per-run noise (+-0.1..0.36%), ns = within noise.

At constant instructions, inlining raises L1i misses +9.11% (kernel) and
+3.90% (userspace), both well beyond noise. Throughput, cycles, IPC and
wall-time all stay within run-to-run noise. So the i-cache cost is real,
but at IPC ~2 db_bench isn't fetch-bound at the app level, so it doesn't
surface.

No benefit from _raw_spin_unlock() inlining.

KERNEL BUILD

Building locking/core (defconfig), GCC 11.

    make -j80

Metric              Baseline      Experiment     Delta   Sig
-------------------------------------------------------------
L1i-miss :k          36.72G        37.51G       +2.16%   **
L1i-miss :u         246.99G       246.06G       -0.38%   **
Sys (s)             478.250       482.420       +0.87%   **
Time elapsed (s)    105.221       105.373       +0.14%   ns
User (s)           4022.046      4024.012       +0.05%   flat
Cycles            8,894.10G     8,902.12G       +0.09%   flat
Instructions      8,424.28G     8,426.48G       +0.03%   flat
IPC                   0.947         0.947       -0.06%   flat
-------------------------------------------------------------
L1i-miss/Sys: higher = worse.
** = beyond per-run noise, ns = within noise.

Kernel i-cache misses (+2.16%) and sys time (+0.87%) both rise and are
significant. Wall-time and userspace L1i are flat. Kernel build is
GCC/userspace-bound (User 4022s vs Sys 478s), so the added kernel fetch
cost is real but appears to sit off the critical path.

No benefit from _raw_spin_unlock() inlining.

NGINX

I ran nginx with taskset -c 2.

    perf stat -C 2 ... -- ab -n 100000 -c 80 http://127.0.0.1:8080/

Config for nginx was the following.

  worker_processes 1;
  error_log /tmp/ngx/error.log;
  pid       /tmp/ngx/nginx.pid;
  events { worker_connections 16384; }
  http {
      access_log off;
      server { listen 8080 reuseport; location / { return 200 "ok\n"; } }
  }


I used nginx version 1.20.1 (prebuilt, from CentOS repo).

Metric              Baseline      Experiment     Delta   Sig
------------------------------------------------------------
req/s (ab)           25,113        24,795       -1.27%   **
L1i MPKI :k          70.06         72.10        +2.92%   **
L1i MPKI :u          20.16         20.66        +2.50%   **
instructions          5.86G         5.83G       -0.50%   **
L1i-miss :k           0.41G         0.42G       +2.44%   **
L1i-miss :u           0.12G         0.12G       +1.95%   **
cycles                4.82G         4.81G       -0.28%   ns
IPC                   1.215         1.213       -0.22%   ns
perf time (s)         4.077         4.129       +1.26%   **
failed reqs              0             0          -      valid
------------------------------------------------------------
req/s: higher=better. MPKI: higher=worse.
** = beyond per-run noise, ns = within noise.

nginx connection-churn is the one workload that is genuinely
kernel-fetch-bound: MPKI:k ~70 and IPC ~1.2 (vs db_bench's 2.05). Here
the cost surfaces: req/s −1.27%. Misses rise in both domains (+2.9%
MPKI:k, +2.5% MPKI:u). Unlike kernel build, userspace is hit too,
because nginx runs user and kernel hot on the same core and the kernel
bloat pollutes the shared L1i.

And the kicker: instructions fell 0.5% (inlining removed the call/ret)
yet throughput dropped.

Caveat: ab is single-threaded, so it seems the worker core is
under-saturated: cycles is flat (−0.28%, ns) while wall-time rose
(+1.26%).

Measurable throughput regression from _raw_spin_unlock() inlining.

CONCLUSION

Inlining _raw_spin_unlock() raises kernel L1i misses on every workload.
It's an unconditional cost. Whether it costs the application throughput
depends on how kernel-fetch-bound the workload is.
  
The cost is real everywhere. It only surfaces as throughput regression
where the kernel is on the fetch critical path. And inlining did not
help in any workload I measured. The one micro-effect inlining produced
(-0.5% instructions on nginx) was erased by the added i-cache pressure.


From 99502328caed3c195e20cf194a1e8aa1563f3896 Mon Sep 17 00:00:00 2001
From: Dmitry Ilvokhin <d@ilvokhin.com>
Date: Thu, 4 Jun 2026 07:43:00 -0700
Subject: [PATCH] x86/locking: Inline the spin_unlock()

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 arch/x86/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fdaef60b46d6..c9a0638225fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -113,6 +113,10 @@ config X86
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_EXTRA_ELF_NOTES
+	select ARCH_INLINE_SPIN_UNLOCK
+	select ARCH_INLINE_SPIN_UNLOCK_BH
+	select ARCH_INLINE_SPIN_UNLOCK_IRQ
+	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
 	select ARCH_MEMORY_ORDER_TSO
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
-- 
2.53.0-Meta


