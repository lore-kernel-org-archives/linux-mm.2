Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2682BC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C666B08DD; Tue, 18 Aug 2026 02:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C67F6B08DF; Tue, 18 Aug 2026 02:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF73A6B08E1; Tue, 18 Aug 2026 02:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C25216B08DD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:10:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52000C0AF0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:10:48 +0000 (UTC)
X-FDA: 85113366576.28.30CDE95
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A43E40003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:10:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3Lc2Rqz;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787033446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=03XrAgWUIfiSPQ5t3z3JrnXITobmfpDmBrpvKrXoXgU=;
	b=hRykbpVzQG6T1Bh/DYCOyfLZibZZuRsf5H9063LtdFzt3FRi0ROWTGlY1fbCA6xTIUCyUo
	1QTTHAHWHSnwFVUNRdsIL5QU/8uvwmI/DJ8DY7TJU45r8YtRz8VcplSpAVQMUdrXiNH3Lk
	6ZCb5Q+vq4fVj9IAH+3BMzlyPYJ+htE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a3Lc2Rqz;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787033446;
	b=JAAO8xBUYJSVm+GIf/c/WHrsooV+ozlWPzSrOVfrcXcSijBKwSOWO5ruzQS/k3fvnNSKb+
	eNY7utxi7sYBPn0U3tsmiub9Mxadbwj8gvAaPLTojZseK/8XVzFEPIFtt2a41ICjoGkygS
	bLpJdDs+ZOK0xdjdUFeMyNlUoEEqAYU=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3900e39d935so3825492a91.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787033445; x=1787638245; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=03XrAgWUIfiSPQ5t3z3JrnXITobmfpDmBrpvKrXoXgU=;
        b=a3Lc2RqzEKbz7u9WPM5FrjQeIyEug7mswKyNY30jmYfY5JvqLY6MmK90loHRZevGs5
         survX2RUPhBE/q4Vr3eAhIxffp/tPYxbGAwSxgff6UbuXPaKpMtLnh39FU2Gq9+T7G5C
         lQymI4Tr1UXurX+ooMKualcF1cF72HbkTB3mHDvJEAYnZ/lh57TmkJ6yvPCR4mspbWSe
         EunvA6NQ1giNOcHwSBmjjtqvKb/J6Il/b/a4KikZL7eh/xjoMBKlrYLuZv52JFjlHLi1
         XT+vZNpWwI25FW7GBvTErlAih8Afnr3HiLniZOxXyMK66a/T35cGWVayAboOUI3xs2JK
         UsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787033445; x=1787638245;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=03XrAgWUIfiSPQ5t3z3JrnXITobmfpDmBrpvKrXoXgU=;
        b=sF7U80SyRixanZp4MZo8XyEdn84jIkXogU0TDnQP9mSfIn587SQ4WnRQOQtq/St2AY
         72b6aWU30Vwr+ukxnUzAAeahaj0lyJvwkIzn1455cftp9s5249+GTfuXq4PaVcFT8keH
         BGpyDVQjEXI8buSiMQqGMsGaR+pzZVaYCdlLMIm8CRlWSliLc1R7jMOreVDyU0jViLOr
         wuXKyaQCEodDoRG4AN08FRKONRphznyL91jffDYc9S4OOPORF2FOpvVY7W1cH3FBrsvQ
         kLCocCkg2ZXlhlcn8G/C0ou7kKKafy2Yp+OyUuIgeMb+JU40gYTNC6iowY6tFWBLWAkY
         xwdw==
X-Forwarded-Encrypted: i=1; AHgh+RogTVW6dgXwX2hPwDKsvaF92Z45mDSTmMGJ9tyMjSnUiBQ9UBgQTYJN/vKNnujmO8sRtzKNeaXSUQ==@kvack.org
X-Gm-Message-State: AOJu0YzLj7eHxGMuJnjMxhWo5M+w1PEdmmZLpQCRmgM0imskXVzCR9NW
	TSYLvZbXQnsfwVLLu20jdL44Jb63tzozsmXh+zRprGjMCgCwZ5wSdcYT
X-Gm-Gg: AR+sD10ckCXeMQv+4mUDEOxMGol/uCea7e0kr4lLgyF/TOymvNqxiL8R4X7bsrlZ51v
	ug0kTCmezXHSC6+3bHbY3bzVaXW0UmPin2CNpIx9qB1kcTsZVt9bl+JyeQsCgzMfACXNPEAf61A
	17NBlJ+lDnTV4AK3hAwNTIwEZb6jLgOteeTediwLtYjugeiD1EMDa+5YQqgxDc/cObbK1GiGAhc
	RmYRR5WD8siYU+oDN95olUJpQcrUd9h20W1AFHiSbgvvPOTUo70Z94GF9WVTdepmnqII03fqQjD
	+65+7yf3eFNH1s+/d5P7LFGm4P0ktswaOIIPjMknFXe3Q1ugTCOBwT13G0FGVF8IvxPYm0Kt9Jf
	4p2uAk/InvKA3qu+kSoCokaP0DR1VfO8tWNvW9GQCCs2oEAo2WKRrduLsKdoKG+rVUfTVwEZOag
	aL4ILH5FSwh5y7QYP73tiILzeWJSKELmmgkUZkqakw4HTT62+AVDX5oXuCfowhgeyVkaahJ02jT
	N7uYxo=
X-Received: by 2002:a17:90b:5707:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-3933e61bee2mr33646076a91.15.1787033445097;
        Mon, 17 Aug 2026 23:10:45 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d38bf94sm4633942a91.9.2026.08.17.23.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:10:44 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	shuah@kernel.org,
	lianux.mm@gmail.com,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 0/7] mm/damon/perf: observability framework for hardware-sampled access reports
Date: Tue, 18 Aug 2026 14:10:24 +0800
Message-ID: <20260818061031.827057-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A43E40003
X-Stat-Signature: u77984g471ir6tgkxo8kb7ruzfmgcied
X-Rspam-User: 
X-HE-Tag: 1787033446-588586
X-HE-Meta: U2FsdGVkX1/tbSpAP6OmMFjGfIXMnBFv+DF6JxIsdEz7o99LBqqd8OBSt8Po4IrGw4YsSy4pJ2cgqeDjd+47fRMcAnjIl7P3WNpCqijtI97VzjAR/KNTIQ0B21pbgy2w8K8koRxoVIoZqGuxDS1AGbBmQjcFzyLwC1Ig4mf22pPj6yLy4yGQ5JgEcr9FcW9ZMZAv9wiTlMWk3DUzApO4YFF6Q/AXq7jPQiLg7dBVJq1kmT/jxBuZ93AGoJafrNT7ZRC2PvDY6y1TixrMZqg/vcTA1CpXvrecrpj5pz9P8+C5lYZcOg1FPOY52s6TF+8TAwlgH4EMcvn1pD8faO/+kQldkRIU0gL7kNBoMINdRBXwYauQEGeqL2hSUOUmYhaYCkIWWnrH4Yrd79lfUDjTIRmNLq5z+QNV2JDhb4J47pgL38OJjjnrp18gNjqLswyt9iYbA1wEYrGya4yIMIDmqnx+rrKme0Xiz9viP9obMNkGo33K0vBp5kdWq/yqMeBWGiRVYBhpPz5/2nq/zafAocqzbKeW7BJuDdyJGia17Ecu5oNr6g7BFwATJYgGMSj14GhfJE+KFnBrtqPOMvfSLBZlr2RNcxoKxU5+ADtTddQmusEPLnvR3o3pVMxdVoLlWIZPv4O1muIKdnTgKFLhBl0Im8gL4iRIs1lTCQWLHJ6Z9Drp6ZyjHfR/apSrxsz5AR3yj7L/MBQp+lmFBKcO0vcFKEsuGZYwzHzZuV7HmIf2rjoKBuTrE+WhoSFRqQwSXEWuZ8r4zs39Nkdr4wZ3vrUlUCAFyafGsevo9dtJogJ8obcCW3/gbKkBSDSb6giFL7e7+ZnuukBiNk8aReqJILuxBm7NbZqwlMIemDaK98xjQj1mI3pQ7erzlGF4JdkAB6thKP6WGWTrtKxpg0Rsm2McARi/pfsqt2Ri6Xkc7gNEoLxC3qaalDIPIaTmK6z9WxzalN1Eyu2v0CS9cQ0
 ashgkb9v
 wNvYszdKkwI6voADW3jG6Y0co1gynqPxR6kvM32v98usywszzFNfsDquEBRUwvYlTn6P5PPW/1+hazw3dIPSBSUqmy+Gn0UZwDKNh9lAn3AAZGRrO1MGWqeyhGp1RpyJQpegTuyADT5h6AAFObgECFnNw1I839/JnLWUxlKwixQzGXU/amfKvuqu1gFghk+8IV9tfsY63eyLvJUz+JS2a8p+ufmBqM8BPRdJY+8Lu6s+d0sIzm4Z3/zB5jCebdtXC5IaBVZfxFWbhWL66cQlA3EkDsqCNcPBgaOWmQ6WZAQ5+OzGyBpyF0oCV0gsibgNiRP7NlnQOHhZGJM80WTZ53OsmP68W5czzFHQWoq96RsD/j/5yX93hHTcYmSUI2qBYrWpLgGv6gqZDo/1FQy7vTpm7cN4IEp5tmnFQfTGqfRkLE008MEnAp8ZbMy1T1vF+gAHUW1SCVgwFWyWDt6lrzHTy21bGUYlpGl+cGphsTj/rowbYVPiaA6KFWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

This series adds a unified observability framework to DAMON's
hardware-sampled access report pipeline.  When a PMU backend delivers
zero callbacks, the framework pinpoints the failing stage —
was the event not created?  not enabled?  did the hardware produce
no samples?  did the ring drop them?  did the drain fail to match? —
without a single printk.  Every PMU backend (ARM SPE, AMD IBS,
Intel PEBS, …) funnels through the same damon_perf_observe_*() API,
which fans out to per-CPU pipeline counters, debugfs statistics,
and tracepoints.

The framework does not contain any PMU driver.  It is pure
observability infrastructure that sits alongside the existing
DAMON software statistics (scheme stats, kdamond stats) and
complements them for the hardware-sampling path.

Why this framework exists
-------------------------
The framework was built to answer a concrete question during ARM SPE
bring-up: what prevents SPE from delivering samples to DAMON?  The
answer could be anywhere in the pipeline — the event wasn't created,
the PMU wasn't enabled, the hardware produced no samples, the ring
dropped them, or the drain failed to match — and without per-stage
visibility, the only way to find out was to insert printks across the
entire pipeline.

The framework instruments every stage with zero-overhead counters
(when CONFIG_DAMON_PERF_OBSERVE=n) and optional tracepoints, so the
failing stage is revealed at a glance.  It immediately diagnosed the
ARM SPE gap: Layers 1-3 (event create/bind/enable) passed, but the
PMU was not producing data — a PMU-level gap, not a DAMON pipeline
bug.  This confirmed that SPE required an AUX buffer backend, which
does not fit the perf_event_create_kernel_counter() API.

During the subsequent ARM SPE AUX backend development [2] (which builds
on the perf AUX kernel-consumer API [3]), the framework was used to
verify each pipeline fix.  When the AUX backend was complete, the same
framework confirmed a fully functional pipeline: Layers 1-7 all pass,
real SPE hardware samples flow through the ring, match, and update
stages.  The before/after results are shown in the Testing section.

We are posting the framework now so that other PMU backends can reuse
the same infrastructure instead of re-deriving it.

How to use
----------
Compile with CONFIG_DAMON_PERF_OBSERVE=y.  After starting a kdamond
with a perf event, the pipeline is visible at a glance:

  # cat /sys/kernel/debug/damon/perf_stats
      --------------  ----------
      Counter          Value
      --------------  ----------
      callback          233
      valid             233
      ...
      enqueue           233
      dequeue           233
      match              12
      update              9

For automated diagnosis, run the selftest:

  # sudo ./damon_perf_obs_test.sh --pmu software --freq 1 --sample-freq 100

For structured diagnostics, enable the tracepoints under
/sys/kernel/debug/tracing/events/damon/.

What the series adds
--------------------
Patch 1 defines the three tracepoints (damon_perf_sample with 8 fields
including sample_flags, sample_type, and execution context, plus
damon_perf_report_missed and damon_perf_drain) with the CONFIG switch,
the observe API declarations, no-op stubs, and the Kconfig / Makefile
wiring.  (Reviewers: tracepoint folks — Steven, Masami, Mathieu.)

Patch 2 implements the observe_*() core: per-CPU monotonic counters,
event-lifecycle hooks with lazily-allocated per-event per-CPU state,
NMI-safe sample classification with execution-context detection,
ring enqueue/dequeue/peak, match/miss/update, and framework init.

Patch 3 adds the debugfs perf_stats interface (debug-only, format
unstable).

Patch 4 wires the observe calls into the vaddr overflow handlers and
the kdamond drain, integrating the framework into the hot path.
Reads ring->tail once with READ_ONCE and reuses the cached value
for the peak-occupancy estimate, avoiding a compiler reload and a
torn read on the NMI producer side.

Patch 5 adds the automated selftest with snapshot/delta accounting,
per-CPU state-column checks, clean-session guard, and a PMU support
verdict (FULLY INTEGRATED / PLUMBING-ONLY / UNUSABLE).
(Reviewers: kselftest folks — Shuah.)

Patch 6 documents the framework.

Patch 7 adds CONFIG_DAMON_PERF_DEBUG as an optional Kconfig option for
verbose pr_debug() output via damon_perf_dbg(), wired into every
event-lifecycle hook, the drain summary, and the init paths.  Adds a
pipeline health check to the selftest that diagnoses which stage is
broken when callbacks are zero.

Testing
=======
Tested on Kunpeng 920 (256 CPUs, ARM SPE, kernel 7.1.0-rc5-mm-new-damon+).

KUnit: 35/35 PASSED (damon 29, damon-operations 5, damon-sysfs 1).

The framework is PMU-agnostic.  Three configurations demonstrate this,
with the ARM SPE case being the framework's core diagnostic value:

**Software PMU** (page-fault sampling, exercises the full pipeline,
no hardware required):

  $ sudo ./damon_perf_obs_test.sh --pmu software --freq 1 --sample-freq 100
  SUMMARY: 27 passed, 0 failed, 0 skipped (FULLY INTEGRATED)
  callback=170, valid=170, enqueue=170, dequeue=170, match=6, update=3

**CPU-clock** (address-less PMU, plumbing-only):

  $ sudo ./damon_perf_obs_test.sh --pmu software --config 0 --freq 1 --sample-freq 100
  SUMMARY: 22 passed, 0 failed, 3 skipped (PLUMBING-ONLY)
  callback=1913, valid=0, addr_zero=1913, enqueue=0
  Layers 1-4 pass; Ring/Match/Drain skipped as expected.

**ARM SPE** (hardware trace).  This is the scenario that motivated the
  framework: without an AUX buffer backend, SPE cannot deliver samples
  through perf_event_create_kernel_counter(), and the framework
  pinpoints the failure without a single printk:

  $ sudo ./damon_perf_obs_test.sh --pmu arm_spe_0 --freq 0 --period 256

  --- Layer 2-3: Enable & Run (via per-CPU state) ---
    [PASS] Event Created (max per-CPU state >= CREATED)
    [PASS] Event Bound (max per-CPU state >= BOUND)
    [PASS] Event Enabled (max per-CPU state >= ENABLED)
    [PASS] Perf event creation (no errors in dmesg delta)

  --- Analysis ---
    Pipeline diagnosis: PMU not producing data or AUX pipeline broken
    [FAIL] Sampling — 0 callbacks — PMU is not delivering samples to DAMON
    [SKIP] Event Running — no callbacks — state cannot advance past ENABLED
    Ring: enqueue=0 dequeue=0 overflow=0

  --- PMU support verdict ---
    UNUSABLE: the PMU never delivered a sample to DAMON

  SUMMARY: 19 passed, 1 failed, 5 skipped

  Layers 1-3 pass — the per-CPU state advances to ENABLED — so the
  kernel-side plumbing is intact.  The health check confirms
  state >= ENABLED but enqueue=0, ruling out event-creation and enable
  bugs.  The failure is isolated to Layer 4 (Sampling): the PMU itself
  is not producing data.  This is the expected result for ARM SPE
  without an AUX buffer backend, and the framework diagnoses it as a
  PMU-level gap rather than a DAMON pipeline bug.

  After the AUX backend is added [2] (which itself depends on the
  perf AUX kernel-consumer API [3]), the same test script confirms a
  fully functional pipeline, including real SPE hardware samples:

  $ sudo ./damon_perf_obs_test.sh --pmu arm_spe_0 --freq 0 --period 256
  SUMMARY: 27 passed, 0 failed, 0 skipped (FULLY INTEGRATED)
  callback=47248, valid=47248, enqueue=15161, dequeue=15161,
  overflow=32087, match=255, update=4
  All 7 pipeline stages pass.  The AUX drain path delivers samples in
  process context (context=0), and the ring overflow counter (32087)
  shows the ring is sized for software PMU rates — a real-world
  observation the framework provides without any additional
  instrumentation.

Known limitations
=================
- The debugfs perf_stats format is explicitly unstable and must not
  be used by scripts.  Tracepoints and counters are the stable
  diagnostic interface.
- The global per-CPU lifecycle state is monotonic and never reset,
  so a previous RUNNING event can mask a current event's failure.
  Per-event per-CPU state is available for accurate tracking.
- This series depends on Ravi's hardware-sampled access reports
  branch [1] for the following facilities:
    * Per-CPU SPSC report ring (damon_report_rings,
      DAMON_REPORT_RING_MASK)
    * damon_report_access() and damon_report_page_fault() as the
      ring producer
    * kdamond_check_reported_accesses() as the drain path
    * damon_perf_event lifecycle (create/bind/enable/disable/free)
  Without [1] this series cannot compile, so [1] must be merged
  first.

References
==========
Link [1]: https://github.com/damonitor/linux.git
          branch: ravi_hw_sampled_access_reports_rfc_v1
          commit: fd968106e5bf
Link [2]: https://lore.kernel.org/all/20260816142222.689624-1-kunwu.chan@linux.dev/
Link [3]: https://lore.kernel.org/all/20260814144927.489172-1-kunwu.chan@linux.dev/

Base: fd968106e5bf ("mm/damon: add damos_node_eligible_mem_bp tracepoint")

Kunwu Chan (4):
  mm/damon/perf: add observability framework with tracepoints and CONFIG
    switch
  mm/damon/perf: implement observe API and per-CPU statistics engine
  mm/damon: integrate observe API into vaddr overflow handlers and core
    drain
  selftests/damon: add automated layer-by-layer observability test

Lian Wang (3):
  mm/damon/perf: add debugfs statistics interface
  Docs/mm/damon: document the perf observability framework
  mm/damon/perf: add CONFIG_DAMON_PERF_DEBUG and pipeline health check

 Documentation/admin-guide/mm/damon/index.rst  |   1 +
 .../mm/damon/perf-observability.rst           | 210 +++++++
 include/linux/damon.h                         |  44 ++
 include/trace/events/damon.h                  | 120 ++++
 mm/damon/Kconfig                              |  33 +
 mm/damon/Makefile                             |   1 +
 mm/damon/core.c                               | 129 +++-
 mm/damon/perf/Makefile                        |   5 +
 mm/damon/perf/debugfs.c                       | 145 +++++
 mm/damon/perf/perf.h                          | 235 +++++++
 mm/damon/perf/stats.c                         | 308 ++++++++++
 mm/damon/vaddr.c                              | 104 +++-
 tools/testing/selftests/damon/Makefile        |   1 +
 .../selftests/damon/damon_perf_obs_test.sh    | 578 ++++++++++++++++++
 14 files changed, 1880 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/damon/perf-observability.rst
 create mode 100644 mm/damon/perf/Makefile
 create mode 100644 mm/damon/perf/debugfs.c
 create mode 100644 mm/damon/perf/perf.h
 create mode 100644 mm/damon/perf/stats.c
 create mode 100755 tools/testing/selftests/damon/damon_perf_obs_test.sh

-- 
2.43.0


