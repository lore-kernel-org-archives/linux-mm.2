Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BA6C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9D36B08EE; Tue, 18 Aug 2026 02:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9806B08F1; Tue, 18 Aug 2026 02:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72486B08F2; Tue, 18 Aug 2026 02:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AADA66B08EE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:11:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52AB3160A91
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:27 +0000 (UTC)
X-FDA: 85113368214.06.DB52AC9
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 691ABC0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n90CgS7U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787033485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkufMBhFwqowO3sZfc9l3+J3Km3N7KYxt/zmtGdjLcc=;
	b=oWw0//uhjQKePLET+j1+a8IqBRh61URijEDz03a+gN3+meAhjjbslQM2cDs1my/sVvvkWa
	t+IwWHwztl5dpN245qL2coa48k5Kzz1IeJC7/nFVyl8WawKrcIyegDpG8zNdOW/PrT93+d
	OsPnVdCwZare6fQmYALpPp8ALvW8NBw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n90CgS7U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787033485;
	b=VnaXWtOzooohGLMRSW5CQCH5tUAw5pkMzN+SNKAKKhUqftSKOpSR+5YClSLG3z1iHtFMr3
	+Tpag7ImoXHoLp9XKoMKJQP6aHmAdVX0xz8A+enXHD2aW94IwzvLLvZYmvnjHopOVdnodr
	OtZsswmrmveNT7x6tgYFx6SiEaK4uUE=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-383cb94f742so5174844a91.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787033484; x=1787638284; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OkufMBhFwqowO3sZfc9l3+J3Km3N7KYxt/zmtGdjLcc=;
        b=n90CgS7UofyPg88qzzNVE4CHpTnNOLLCMpiPEI6gdNWHbgcveKkKT0FiBpKCzKs++B
         G6KuxQcyEyaP8S/WbvcQjhfJU8v+Z/kijJ/JdJkhstAOiEAKevA9Cp34ndegmN35JV9i
         eKUPTJqPkZgd5PLwwhCtlesu6EPF8DQfh8XTqMp4FErkVv0l+lJpWSe9GymfHhEQ1xCc
         qS8zNFJNWL8d1I68S71RRo3HDhUAGx2Tdvte8+pzpb30aq4i/qetMP51A9AP7+jF5O+Q
         HF0GLaXGq4HXyAYxDQk9b66jEjsUGsOHNo+RrIbnzhtZf+a9WXuEccbLg14FK5UpQ/uu
         rY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787033484; x=1787638284;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkufMBhFwqowO3sZfc9l3+J3Km3N7KYxt/zmtGdjLcc=;
        b=ajJ6t+3hRK3xYE81kiaYIeWCy/M2c26dI45fukSvT5dfksif8M+nVskHLefU+Bd677
         rt6g5JIjuJnfzrqB2/4l1kfsDEIc0GkouMD0dP9SIhkP+vVO5FZiaxds+yFCkPQf842x
         yC1aIjbiidH2Y1pwCupAYCXmTLBi5aEIJSrG4qZvvW/rMr6RyG4t5qfbYecVbElxocU4
         hsrZxr3azoPEchgNw3X0rp2ezKvX+34+v3S+CSVRHypstD6zDpsoT+jDTvaSo0WCexHF
         IOoT7rKa8YdP+zXCM/yDa6VFrGzIqbPBjvvk/gX2+BirKJ+ISBiEQnHDdG8GOzr6TWl6
         6Rjw==
X-Forwarded-Encrypted: i=1; AHgh+RpLPiu9zpMTL1Uqj7iInTa0NwuSK9rFFZvjF0FNM30w9UxEzEN/SOLTrIDo6RH5AgrRNFDr0TLO3g==@kvack.org
X-Gm-Message-State: AOJu0Yz5W4yZoMnYsjkA4RCoYXsyl31Ac+v0+Yt1C0VW2TJZlcYsKSB3
	EOhe3nPNj/Ouz0GSGrVOy1LJx+zIb5FSzTZ8fMXOtT8YezXlLjMAC1WH
X-Gm-Gg: AR+sD10XF+xSHwK2ZRBRNhPPjeavHE/jJZqrgRoaH8kafHbE/V2cmDEfH0NziasikqJ
	bsJbECzlntZ3RacF8NtbRsYAh++0WNqJCLFNszEQC4gQZnssCQNJhRKNPYL7L7Nadc6kxG/pejO
	32Ygb+cP7heOI/CdxPyk7s+0I37dg1ExEjXETeMXpQ+BtrzuamhAlDS6bcVW4/h9CU80Yf3VvjL
	F/g5ApCQo4aTjLPpkwTSWmhF59rcecoUaWBrgL3448qP3mOQ1SdZpFSWhL5C5kFhCLrVXfS1kIL
	hIYiOazXccAAhi8fWVC8JAxoxTQj+DKBvwQ2+nKGclsjWlwQhOqpfELW2iSSMpbvUOuyoPLqzVD
	IJndKXNIhfSp6xC4911sqZswurBjEBka/+mFqPhw3PIslksnEvhkwKubUFW46ir8r3TifYoPaLL
	yjwoVoxk64qTg7FDmewleXf3aXyKf5Eg/ZjtFL1I45t6abySxu2uAzjP2FPA01Tf0osQztV+eaO
	ljEq7bVKqEi
X-Received: by 2002:a17:90b:2f10:b0:38e:f6eb:2b38 with SMTP id 98e67ed59e1d1-3933e63ba0bmr31731771a91.17.1787033483851;
        Mon, 17 Aug 2026 23:11:23 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d38bf94sm4633942a91.9.2026.08.17.23.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:11:23 -0700 (PDT)
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
Subject: [RFC PATCH 6/7] Docs/mm/damon: document the perf observability framework
Date: Tue, 18 Aug 2026 14:10:30 +0800
Message-ID: <20260818061031.827057-7-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818061031.827057-1-kunwu.chan@linux.dev>
References: <20260818061031.827057-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: greep1t8pp8i1ig6o53cy5nzb1yz5zaf
X-Rspamd-Queue-Id: 691ABC0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787033485-309452
X-HE-Meta: U2FsdGVkX18IyedIL8yCFK72T2iYK6Zvp3sJl/dUYH7bOQYKH+XVsTlqNbKc7ZfKLUlkXlk4LJLx/Fqw94Z91/5E7TN1ychkiCFwLknd0rBKopxavO9TibxfZ2QMUpjsNOQTHT0Xd83HZZuudwjKrqHZurcQX4fO5lyccEv/javKHQl67Vm76X7+9xjVqS+RLglhg/y1bhP+V1eNaB7n9vyXC0D7zcpOnzFWNVFw8An8nBCmgp8M0U6LsIIJAtV/gDL3gL7o5g2Ih/edLLR4Eh8PVftJrjXfcgylaUbU1a354wBQy+atX2yVsXhWp666j3H6NKPP/wJ5xZlxuYhcsj1Q/hok3exkkdKw9MXQ+pkm88FieGjXCRemsaeFuOuzug9vMWl5lW4AFdv+pdD0RSztDka9sHAw11V6idUG3uwejMO+Maf+IG1XFOY4oB0802GZc4x9ui/p84MguOYSYKXPSnZ6UcBZFzdt6l+yjC98LYcvgcVFXfBqlruoBbL7TawXw8Au0CwUZN9xRJtnhbfyoN+CGymBoX16dPVGemri08mbeli3nhvY1w7RSuEzkYeBdwrWXFHVEWyb3/ywsymBJ27vRd7CEyVvgVSMQfae//KG2vWMHYmbWsXzKRkblWYxeRprZoBNHPNQSaorR/nVh1mFgWKuwoHpT9SDMG/oL94DmQcw6J5XoXlfsnLYAM71h4Qu9ptp3lLyhCMx87O1kYXw1eJgOk3OGUFDcwt1+GzznhL545Vala/J1987rcA+5LSWJ66xOE3s/Kol9p1JWJ6f2uOAxR9DruApygMEiU34zzk6RaSwySEXxdJKMPu0j+P+dWShLLpTUIDgGMeb0vkVkdsu9LvY6btrFQZPaGNnMhugOHWoH4JcAo7NUGxiTf20kHQjE6K9Gk5Cx3hcPxaFZFl4bPYzyBzq1Ytz1lZoh4gijB6MeVreVw1Ca+o5YXyIGIEylImlFOv
 RyBYz13F
 dKJ3ELQGaW7439+JCkof5kx8Lw9pkd8e9yQUMxq5TnJEdLNcLtbnO+M2aH8axcHJTFy23JQLOS8kvgT/VKs59MDWrUD2NTbHK/updpXH+64dL63CLGbCjwL6ztQIw26vgMpj4eTMvCGrz/HlTx4ozyu4IC2Rd33neQYmINF4FaS4MJ19qTDR4J5SL7377uZjvbyOI3Zxg++J8X8XyjfLmnjkKyTYfdbrbH/MAn0jNTn3iZhul1GSFBtkrGrf1HftV3+5bAh+g08nu8pfabtp1NHL4AXJhZ+k1byLfACcwfOUlPrUqJsX/MgADlW+U5Y6+wR0TOdn+jSlY1H0op+5AlTssQmHsMmKtKQ2hYYKVEXF96PqIaay97VuTTjr8WY9sJiyKI/9yjbpnFeN+0wG32Xb/VNJi/K/QHuhnvFwoiuXPMq3ZeDWq/V84vTAUX5I/xkcptBbuFKH3V7E8pr/I1LM9ZKiWq52FvhiR62CsnMjM3lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lian Wang <lianux.mm@gmail.com>

Add documentation for the DAMON perf observability framework,
covering the CONFIG_DAMON_PERF_OBSERVE Kconfig option, the
debugfs perf_stats interface, the tracepoints, and the per-CPU
pipeline counter model.  The debugfs format is explicitly marked
as unstable and must not be used by scripts.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 Documentation/admin-guide/mm/damon/index.rst  |   1 +
 .../mm/damon/perf-observability.rst           | 210 ++++++++++++++++++
 2 files changed, 211 insertions(+)
 create mode 100644 Documentation/admin-guide/mm/damon/perf-observability.rst

diff --git a/Documentation/admin-guide/mm/damon/index.rst b/Documentation/admin-guide/mm/damon/index.rst
index 3ce3164480c7..623a5c312b69 100644
--- a/Documentation/admin-guide/mm/damon/index.rst
+++ b/Documentation/admin-guide/mm/damon/index.rst
@@ -15,3 +15,4 @@ access monitoring and access-aware system operations.
    reclaim
    lru_sort
    stat
+   perf-observability
diff --git a/Documentation/admin-guide/mm/damon/perf-observability.rst b/Documentation/admin-guide/mm/damon/perf-observability.rst
new file mode 100644
index 000000000000..3aa8185de314
--- /dev/null
+++ b/Documentation/admin-guide/mm/damon/perf-observability.rst
@@ -0,0 +1,210 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================================
+DAMON Perf Event Observability Framework
+=============================================
+
+The DAMON perf event observability framework provides per-CPU counters and
+tracepoints for hardware-sampled access reports.  When DAMON is configured to
+use a hardware PMU (e.g. AMD IBS, Intel PEBS, or ARM SPE) instead of page-table
+walks, this framework exposes raw pipeline diagnostics so that every stage of
+the PMU-to-DAMON pipeline can be inspected.
+
+Counters are best-effort: individual ``u64`` writes are atomic on 64-bit
+platforms, but no cross-field consistency is guaranteed.  Do not build
+policy on snapshot reads.  For stable, structured diagnostics, use the
+tracepoints under ``/sys/kernel/debug/tracing/events/damon/``.
+
+Pipeline Stages
+===============
+
+::
+
+  PMU hardware → overflow_handler / AUX drain
+    → damon_report_access() → per-CPU SPSC ring
+    → kdamond drain → target match → region update
+
+  Layer 1:  Event Create   perf_event_create_kernel_counter()
+  Layer 2:  Event Bind     per-CPU PMU attachment
+  Layer 3:  Event Enable   perf_event_enable()
+  Layer 4:  Sampling       callback / AUX record received
+  Layer 5:  Ring           SPSC enqueue / dequeue / overflow
+  Layer 6:  Drain          kdamond consumes entries from ring
+  Layer 7:  Match & Update region access-rate update
+
+Each layer has a dedicated counter, and most layers have corresponding
+tracepoints.  Per-CPU event state (UNINIT → CREATED → BOUND → ENABLED →
+RUNNING) is recorded unconditionally and exposed via the debugfs
+perf_stats file.
+
+Overhead Control
+================
+
+Two levels of overhead control are provided:
+
+1. **Compile-time** — ``CONFIG_DAMON_PERF_OBSERVE``
+   When set to ``n``, all observe functions are compiled to static-inline
+   no-ops.  No code is generated and no runtime overhead exists.
+
+2. **Per-tracepoint on/off** — standard ftrace ``enable`` files
+   Individual tracepoints (``damon_perf_sample``, etc.) can be
+   enabled or disabled independently via
+   ``/sys/kernel/debug/tracing/events/damon/``.  Counter increments are
+   unconditional (cheap per-CPU ``inc``); tracepoint decisions are
+   guarded by the ftrace static key and are zero-overhead when disabled.
+
+When ``CONFIG_DAMON_PERF_OBSERVE=y``, per-CPU counters always increment.
+There is no runtime toggle for counters; compile-time is the sole gate.
+
+Debugfs Interface
+=================
+
+Mount debugfs::
+
+    # mount -t debugfs none /sys/kernel/debug
+
+One file is created under ``/sys/kernel/debug/damon/``:
+
+perf_stats
+----------
+
+**DEBUG ONLY — format may change without notice.**  Do not parse in
+scripts or tools.  For stable diagnostics, use the tracepoints.
+
+Read-only.  Aggregated counter table with all pipeline counters plus
+per-CPU breakdown::
+
+    # cat /sys/kernel/debug/damon/perf_stats
+      ┌──────────────┬──────────┐
+      │ Counter      │   Value  │
+      ├──────────────┼──────────┤
+      │ callback     │    233   │
+      │ valid        │      0   │
+      │ null         │      0   │
+      │ addr_zero    │    233   │
+      │ kernel       │      0   │
+      │ inv_phys     │      0   │
+      │ enqueue      │      0   │
+      │ dequeue      │      0   │
+      │ overflow     │      0   │
+      │ ring_peak    │      0   │
+      │ match        │      0   │
+      │ miss_tgid    │      0   │
+      │ miss_region  │      0   │
+      │ miss_bound   │      0   │
+      │ update       │      0   │
+      └──────────────┴──────────┘
+
+      Per-CPU (non-zero / non-UNINIT):
+      CPU00: st=BOUND   cb=44 enq=0 deq=0 ovf=0 match=0 miss=0 upd=0
+      ...
+
+The ``st=<state>`` column shows the per-CPU event state machine position
+(UNINIT, CREATED, BOUND, ENABLED, RUNNING, ERROR), derived from the
+lifecycle observe calls.  This allows verifying lifecycle progression
+without parsing dmesg.
+
+All counters are monotonic (cumulative since boot); userspace computes
+deltas between snapshots.
+
+Tracepoints
+===========
+
+Four tracepoints are defined::
+
+    damon_perf_sample
+    damon_perf_ring_overflow
+    damon_perf_report_missed
+    damon_perf_drain
+
+Enable via ftrace::
+
+    # echo 1 > /sys/kernel/debug/tracing/events/damon/damon_perf_sample/enable
+    # cat /sys/kernel/debug/tracing/trace_pipe
+
+Each ``damon_perf_sample`` record includes:
+
+  - ``addr``: the accessed virtual address (0 if the PMU did not populate)
+  - ``data_src``: PERF_MEM_* encoding (PMU-dependent)
+  - ``period``: sample period or frequency count
+  - ``cpu``: CPU that generated the sample
+  - ``reason``: 0=valid, 1=null-data, 2=addr-zero, 3=kernel-addr, 4=invalid-phys
+  - ``sample_flags``: what the PMU actually populated
+  - ``sample_type``: what DAMON requested
+  - ``context``: 0=process, 1=softirq, 2=hardirq, 3=NMI
+
+The ``context`` field is particularly useful for cross-PMU validation.
+For example, AMD IBS samples arrive in NMI context (context=3), while
+ARM SPE data from an AUX backend would arrive in process context (context=0).
+A mismatch between the expected and actual context is immediately visible.
+
+Selftest
+========
+
+A comprehensive automated test script is provided::
+
+    # cd tools/testing/selftests/damon
+    # sudo ./damon_perf_obs_test.sh --pmu arm_spe_0 --freq 0 --period 256
+
+The script performs a layer-by-layer validation:
+
+1. Checks kernel configuration (CONFIG_DAMON, CONFIG_DAMON_PERF_OBSERVE, etc.)
+2. Verifies PMU availability, tracepoints, and the debugfs perf_stats file
+3. Refuses to run if existing kdamonds are present (side-effect guard)
+4. Configures DAMON with the specified PMU via sysfs
+5. Runs a memory workload (stress-ng, stress, or dd fallback)
+6. Collects dmesg delta, trace output, and perf_stats
+7. Verifies per-CPU state progression and counter values
+
+Example output::
+
+    --- Layer 0: Environment ---
+    [PASS] CONFIG_DAMON_PERF_OBSERVE=y
+    [PASS] debugfs perf_stats exists
+
+    --- Layer 2-3: Enable & Run (via per-CPU state) ---
+    [PASS] Event Created (max per-CPU state >= CREATED)
+    [PASS] Event Bound (max per-CPU state >= BOUND)
+    [PASS] Event Enabled (max per-CPU state >= ENABLED)
+
+    --- Layer 4: Sampling (Callback) ---
+    [PASS] Sampling: 84532 callbacks received
+    Callback breakdown: valid=82103 addr_zero=0 kernel=2429
+
+    --- Layer 5: Ring ---
+    [PASS] Ring: enqueue > 0
+    [PASS] Ring: dequeue > 0
+    Ring: enqueue=82100 dequeue=81987 overflow=0
+
+    --- Layer 6: Drain & Match ---
+    [PASS] Drain & Match: 81987 matched
+    [PASS] Update: 81987 region updates
+
+Additional PMU examples::
+
+    # Software page-fault event (positive control):
+    sudo ./damon_perf_obs_test.sh --pmu software --freq 1 --sample-freq 100
+
+    # Any PMU by type number:
+    sudo ./damon_perf_obs_test.sh --pmu-type 38 --freq 0 --period 256
+
+Kernel Configuration
+====================
+
+Required for observability::
+
+    CONFIG_DAMON=y
+    CONFIG_DAMON_SYSFS=y
+    CONFIG_DAMON_VADDR=y
+    CONFIG_PERF_EVENTS=y
+    CONFIG_DEBUG_FS=y
+    CONFIG_TRACING=y
+    CONFIG_TRACEPOINTS=y
+
+Optional (enables observability framework)::
+
+    CONFIG_DAMON_PERF_OBSERVE=y
+
+When ``CONFIG_DAMON_PERF_OBSERVE=n``, ``/sys/kernel/debug/damon/perf_stats``
+is not created, tracepoints are not registered, and all observe functions
+are compiled to empty static inlines with zero overhead.
-- 
2.43.0


