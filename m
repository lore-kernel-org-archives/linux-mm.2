Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A55EDCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD37F6B0095; Mon, 12 Oct 2026 08:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83DA6B0098; Mon, 12 Oct 2026 08:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0386B0095; Mon, 12 Oct 2026 08:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9106B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:06:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C0CAA8BC0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:21 +0000 (UTC)
X-FDA: 85313846562.19.8CC4186
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4826920005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOAc3Vj1;
	spf=pass (imf31.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806779;
	b=gmdz4xjUJRZNkH5PSCO1P177ePrRG3zpuQB8KZkFJkdPtK2osifHessPm42C5+xYnAfLLZ
	DtP9ImCDrHJrhFcaRsnoPf48gF5OcURO+n/MzPuNiaugA7i4MDDgqSzOZGVHfGedI4jGwa
	/GRqrJQrcuBs1TSj6BRnOR/ylPMWj/E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bOAc3Vj1;
	spf=pass (imf31.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+6TC9tkuUm/bLCdfdY1GSYMOsuFEaxNls0zgTMNafU=;
	b=3zfGI+UVp2LGg44uiFV0XLVJbJs780vjTNCCfFthnTr4dIqOpySPJgbPwBVpfuJrIY4+ZD
	fhwS6coNv9v1aLCbNULIP6+s7gpcQRwNKyBDY+BCC1KekUinyWAoGOTk014Qcp9SB8RquV
	dl0TXWvMkAgAMGHVyJBvDXCDJacFK3E=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso809705a91.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806778; x=1792411578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+6TC9tkuUm/bLCdfdY1GSYMOsuFEaxNls0zgTMNafU=;
        b=bOAc3Vj1OpcrTb/E+zJBHgLXrnoqU9i4uEHPM6jjSosYjNZzTisKUuAH0GIr0w5r+9
         Kg0nt1hj9WKdC51efzuC+edDKpnfFb4qIRCXXCc4ZGTCiKaRs6u3hnmNSeRkjLYFwTyB
         vwq8TXuHtkddCgacgMBKVbQc2AylS/rvjzjAkceJ0Y5/8M85JwbzpNllzzJmLEPUu8lw
         mYGvsBbc2kMdc+jdrp7KC11ANERo1yQtOP4xSLWLEA7sLMRNbwbYooX0k/Rd3iL410tm
         L0xc8g3fZa1u5gN+TQs9B7ZWadw3y5CD7Jjy472AxMSV5xNdwuYUG5ABqaYZLQxXC5lA
         3aZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806778; x=1792411578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+6TC9tkuUm/bLCdfdY1GSYMOsuFEaxNls0zgTMNafU=;
        b=19IL+2WvDFguR5ckU/w3aAUnMJo9sgyM2RVOIJJjDuyX5oWexLyTtV2pw5Mjkl8bC/
         wWeXOxWGXt9phmjVw69DeQXpuyo1K41sp+bMSwWrRSI+FPoF49qW9I2VHokUYhM+3VwS
         tC20XPZJknDESveHVOqND2ARYkMSaau2txHjxD4mFJQ30bBDjFvo3ylyv4jb5vGqw4q/
         +QnHq+gc4OrrqBAM4cvMrXXUrslDF85sKyWEkT9pYKbkpoFbRzpZ22QjlUghNBMxjNsD
         nRVkof9uXeBtIPLyTl1BOUa/+dlavwYRH7Ce8nP43PIuVfopDRXEpJYzmYweORM0CDnn
         3SGA==
X-Forwarded-Encrypted: i=1; AKwUvBxKB81Bn6QxJWK6y3lX/o6gLsAteyseDNhUVi3+gZBoqWEAGOA9zyBRGl42nFfUqEux7n5rjBwvVw==@kvack.org
X-Gm-Message-State: AFq9FYLGjPKxebhgkZWGDAPuM56BSVWdyiLORvunUTdPE2mqTtSiKr6y
	DvAM3vi0d73q6Mur4HMhNMyq1bggBbVVM+kuUa2D4aisaqHS1wJSr1mQ
X-Gm-Gg: AYBFou3dUznqodzkopEECiTu9B2IRRAnakeyXLpsQxGcFrAq1FGsmZdN59SQ1qSDyL1
	AcDy/tEzoj0mn9FolnNibYQ5cQOgyc2FaozMtOL6DMCpE99vSeUIUbj4QPdBLPwAHYn+8LrteSA
	CL2MxFLzZDaxICegN2iuXM08gSui9XsHQd4a5yik/P801Cr/N7scMZaled8dYNOomN3ycRm6ck/
	iRbYdLUEpuq87sS6COMCuBCGAx1myiuUXafJQ8h/TrLfeNR2O3u6xqM1bJFy3Y+waTYSg2czPGN
	RS7cfAakPOTAT43CFLYl3phSzpOdWDEitXzI1eMeb7N0fq1CF2XTgxdALaiVYpBoa7n12/cnYel
	0cz8ib5s9XZJFzOcOVwzNc3T0kOgQxhwpYnewNJbzvFBm77LxfnN63i8TkBZIap+VS7bsGSu6fL
	D0y2OtJ06HeFxg1QRjNK4C52HFvuWzFsA+Maop5TKWm+eGeRQTcsdY9VehqsWYJiO2rPANSjl3o
	t0aS/Wv2hJOielH7sC4Q9Ng2NNSOLw00snrbatOQdJ7cA==
X-Received: by 2002:a17:90b:224c:b0:3ab:2ad1:f10a with SMTP id 98e67ed59e1d1-3ab3a0ef48emr6943974a91.0.1791806777940;
        Mon, 12 Oct 2026 05:06:17 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.05.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:06:17 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v2 2/3] sched: add per-cgroup NUMA balancing mode selection via BPF
Date: Mon, 12 Oct 2026 20:04:37 +0800
Message-ID: <20261012120438.52849-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3gokahcw7grof96wgt1cpa7zw84pj5tx
X-Rspamd-Queue-Id: 4826920005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791806779-534202
X-HE-Meta: U2FsdGVkX1/DfI78ONNCCWfgQKGu5D1zq2Muax2G/BaZ6k7Rjodn6GvabuWetQy0ZK3uX4B6a641XfJbcxw0Ax4KqH6J8dxgzKjx+/xDhIOOCTJ6YIvvsU64ZePTE9LCn0AvOc76/ZnynSlzcpsCMR6swOEQ/sW3jO/J6Te2OlWONCpoxTx8P+wlPCILBPOdUNlkoIMkeOKwgb05RL8gt9YYOcgCiVmuPm4cedXbzqnW6VLR61zvfcM7n3ZdLswXwQVR0xjVDFvKsN+X7+ICuAp6Z3J1Q/gW16y2/HQhx8PZbWtydZdJjye32o2Q1GZzrpnPEhYn085fI6z58Na1chcCEjcgBhYD93JNVAUe3EIVhMJHAreQw7rnhHEPMFXElhjKpBDSP7x3VzRBYSYmVUHIXOiktE7EeXyk/zBfzQzjJbw75nAhCl3QLu8VTfrfE2cPkyq3YkP3xjJuuDX08NNhuigCJqb+MnhiU/WVb19G1fFWYNjsGVYGUMVG31JHjZU/TnvaAvB+SKUNupwOfm3EijZoofG+Qyq9NqtThOdvlyOG461VN/oBPaJ680ZPEW3A+xzpVFWYG7MroU/r3AOhWgS6DPQUfasgisVhUhPKubLZDHzEVuQw0bDRi6Y1b0bE3vzratubhKpigfkscZh1LNXf2lfezN/1JDDAAjePbSCCDzKuu1e4UMaImApBp4m6g6+JbSodne/B7AO7sVoc6B+smqCkUeFYeCS729u7FiZIqD4sYBEUaCjE1n9JN4ayU0Itfz9Od6Z+gKs1TLzbEKZ7dAU8Amp9jI97ujYQS5IWmvcAmrp9H9Ywd5jFUoTcZKdZOCqSLUm4LtUoJZQlMCLmmQwruc2ooO1zBDgRwt98kVDxGdwE8DCvyfrj29bOrSaCu/+EtU26kMtklBT48Jwh+CKcsxzherE0ZpzgPdcAYwIpa2bMjShxpwDSq21+danD+x63zYxKCJS
 sBlVaArz
 h+Ew4GmEbIu3SQjlhPi54vVArsf9osHklpKNZ5QCaQOm+KYtQA/ggRYCYPnjo9XIoePp6tcXiyxJC5vB8zBBcowT3SlDRTqkmikK6VQNrlLdRjJ2W3GB1cBSWfxF14Ya+p+lTTLAypR//EdcgodRbxX2guh1rJPUr8aOf1roZXeTfoEHJey2r/AwPZW5c76d7/9f6vD1fHRE/0nG8ZYBHzmQ2Ub/utkSotHuaEQfOxim2TacXjJaHsGaxtXwc0qJYDsI/y5MMZyFoWnKrCivw7M7KbWga9DO65QjWtQUPehq6iAMLC5n+/h3v5ilMUVU5DUFcM7KNRxITvliGGo+N6sB+gyRx5FFL8aAmMNfxaTW4F+2zPxvsVKv38H/F3T+NCKreiIUblTUm0NbjC6TKII5mLRdcaS+uRpmMnkmDTwRnO/z0VEGvm1JY6zIsSQXcPGP4J0DcFWRGAbysGbwIMSCouNwKFR4BGP2WFnreA8I6HX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Global NUMA balancing is all-or-nothing: kernel.numa_balancing and
kernel.numa_balancing_mode pick the mode for every workload.  A
latency-sensitive service wants the scheduler's NUMA statistics but
not tiering's promotion machinery; a batch service wants its
PMEM-resident memory promoted when hot without paying for scheduler
driven migration.  No global switch serves both.

Add a bpf_numab_ops struct_ops. A policy attached to a cgroup picks a
mode for that cgroup; the kernel runs the policies of the matching
cgroup and of every ancestor and combines what they return.  One
policy question, two surfaces: the kernel passes the task when it acts
on a task (scanner, fault statistics) and the folio when it acts on a
folio (cpupid vs access-time bookkeeping, scanning exemptions);
exactly one of the two is set, so a memory answer cannot be keyed on
whoever happens to touch the folio.

The memory surface converges on folio_numab_mode_tiering(): it decides
folio_use_access_time(), the top-tier scanning exemption, the
cross-tier cpupid reset on migration and the cpupid migration guard.
The task surface: task_numab_enabled() reads the combined request
directly, and task_numab_mode_tiering() decides whether faults on
non-top-tier memory feed the statistics. Both compose with the global
fallback numab_mode_tiering(), so the series is a no-op until a policy
is attached.

DISABLED beats NORMAL beats TIERING: a policy can always opt out, so
no cgroup is ever forced into heavier machinery than its own policy
asks for.  The demotion and migration-fallback machinery stays global:
it is keyed on node-level reclaim state, not on any cgroup's policy; a
TIERING cgroup under a normal-mode system gets promotion without
demotion.

A policy which implements nothing makes every task pay for the enabled
static key, so bpf_numab_validate() rejects it.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf-cgroup-defs.h      |   1 +
 include/linux/bpf-cgroup.h           |   2 +-
 include/linux/bpf_numab.h            |  77 +++++++++++++
 include/linux/sched/numa_balancing.h |  65 +++++++++--
 kernel/sched/Makefile                |   5 +
 kernel/sched/bpf_numab.c             | 164 +++++++++++++++++++++++++++
 kernel/sched/fair.c                  |   4 +-
 mm/memory-tiers.c                    |   8 +-
 mm/mempolicy.c                       |   7 +-
 mm/migrate.c                         |   4 +-
 10 files changed, 317 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/bpf_numab.h
 create mode 100644 kernel/sched/bpf_numab.c

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 0147b8bec973..c0056d170a1b 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -48,6 +48,7 @@ enum cgroup_bpf_attach_type {
 	CGROUP_UNIX_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
 	CGROUP_TCP_SOCK_OPS,
+	CGROUP_NUMAB_OPS,
 	CGROUP_LSM_START,
 	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
 	MAX_CGROUP_BPF_ATTACH_TYPE
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 8a75a6cd7309..bbfa171e449c 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -119,7 +119,7 @@ struct bpf_prog_list {
 
 static inline bool cgroup_bpf_is_struct_ops_atype(enum cgroup_bpf_attach_type atype)
 {
-	return atype == CGROUP_TCP_SOCK_OPS;
+	return atype == CGROUP_TCP_SOCK_OPS || atype == CGROUP_NUMAB_OPS;
 }
 void cgroup_bpf_struct_ops_register(int atype, u32 type_id, void *cfi_stubs, bool mult_trace);
 int cgroup_bpf_struct_ops_attach(struct bpf_map *map, const union bpf_attr *attr);
diff --git a/include/linux/bpf_numab.h b/include/linux/bpf_numab.h
new file mode 100644
index 000000000000..7f78eef1c159
--- /dev/null
+++ b/include/linux/bpf_numab.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF policy hooks for NUMA balancing.
+ *
+ * A bpf_numab_ops is attached to a cgroup. A NUMA balancing decision runs
+ * the policies of that cgroup and of every ancestor, and the kernel combines
+ * what they return. BPF only picks between things the kernel already does:
+ * with global NUMA balancing disabled, a policy can enable it per workload;
+ * with global NUMA balancing enabled, a policy can disable it for
+ * latency-sensitive workloads or opt their memory into tiering.
+ */
+#ifndef _LINUX_BPF_NUMAB_H
+#define _LINUX_BPF_NUMAB_H
+
+#include <linux/types.h>
+
+struct task_struct;
+struct folio;
+
+/*
+ * What a policy can ask for NUMA balancing. The kernel ORs the requests
+ * of all matching policies, so one policy cannot undo another's opt-in.
+ * When several requests combine, the conservative choice wins:
+ * BPF_NUMAB_DISABLED beats BPF_NUMAB_NORMAL, which beats BPF_NUMAB_TIERING.
+ * A policy can always opt a workload out, so no cgroup is ever forced
+ * into heavier machinery than its own policy asks for.
+ *
+ * The mode bits mirror the global sysctl_numa_balancing_mode semantics:
+ * BPF_NUMAB_NORMAL asks for the normal mode, where hinting faults feed
+ * the scheduler's NUMA statistics. BPF_NUMAB_TIERING asks for the
+ * memory tiering mode, where the cgroup's non-top-tier memory records
+ * access times in place of cpupids and is promoted when hot.
+ * BPF_NUMAB_GLOBAL (0) makes no request and defers to the global sysctl
+ * state.
+ */
+enum bpf_numab_mode {
+	BPF_NUMAB_GLOBAL	= 0,
+	BPF_NUMAB_DISABLED	= 1U << 0,
+	BPF_NUMAB_NORMAL	= 1U << 1,
+	BPF_NUMAB_TIERING	= 1U << 2,
+};
+
+#define BPF_NUMAB_VALID_MASK	(BPF_NUMAB_DISABLED | BPF_NUMAB_NORMAL | \
+				 BPF_NUMAB_TIERING)
+
+struct bpf_numab_ops {
+	/**
+	 * numab_mode - request a NUMA balancing mode
+	 * @p: task the NUMA balancing machinery is about to act on, or NULL
+	 * @folio: folio whose NUMA balancing semantics are being decided,
+	 *	   or NULL
+	 *
+	 * Exactly one of @p and @folio is set. The kernel passes @p when
+	 * it acts on a task (whether its scanner runs, whether a fault
+	 * feeds its statistics) and @folio when it acts on a folio
+	 * (whether its memory carries cpupids or access times, whether its
+	 * top-tier pages are worth scanning). A policy must NULL-check
+	 * before dereferencing.
+	 *
+	 * Called from the NUMA balancing hot paths (hinting faults,
+	 * scanner passes, load balancing). It must not sleep.
+	 *
+	 * Return: bits from enum bpf_numab_mode.  Other bits are dropped.
+	 */
+	u32 (*numab_mode)(struct task_struct *p, struct folio *folio);
+};
+
+#if defined(CONFIG_CGROUP_BPF) && defined(CONFIG_NUMA_BALANCING)
+u32 bpf_numab_mode(struct task_struct *p, struct folio *folio);
+#else
+static inline u32 bpf_numab_mode(struct task_struct *p, struct folio *folio)
+{
+	return BPF_NUMAB_GLOBAL;
+}
+#endif
+
+#endif /* _LINUX_BPF_NUMAB_H */
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 353772b49c5f..fb85e968b1f3 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -7,6 +7,7 @@
  * implements memory access pattern based NUMA-balancing:
  */
 
+#include <linux/bpf_numab.h>
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 
@@ -36,25 +37,67 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 extern struct static_key_false sched_numa_balancing;
 
-/*
- * Whether NUMA balancing applies to @p.  The @p argument is unused for
- * now: a later patch will consult a per-cgroup BPF policy with it.
+/* Whether NUMA balancing applies to @p: the global sysctl state, possibly
+ * overridden by a BPF policy attached to @p's cgroup. The requests of
+ * the task's cgroup and of every ancestor are combined; a policy can
+ * always opt out, so a latency-sensitive workload is never forced in.
  */
 static inline bool task_numab_enabled(struct task_struct *p)
 {
+	u32 state = bpf_numab_mode(p, NULL);
+
+	/* A policy can always opt out, regardless of the global state. */
+	if (state & BPF_NUMAB_DISABLED)
+		return false;
+	if (state & (BPF_NUMAB_NORMAL | BPF_NUMAB_TIERING))
+		return true;
 	return static_branch_unlikely(&sched_numa_balancing);
 }
 
-/*
- * The global sysctl state, for the system-wide tiering machinery: this
- * reflects kernel.numa_balancing_mode only and takes no task.
- */
 static inline bool numab_mode_tiering(void)
 {
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		return true;
 	return false;
 }
+
+/*
+ * Whether @p runs in tiering mode, i.e. whether faults on non-top-tier
+ * memory still feed its NUMA statistics. The requests of the task's
+ * cgroup and of every ancestor are combined; DISABLED and NORMAL both
+ * opt out of tiering (a policy can always opt out), so only an
+ * unopposed TIERING request engages it. Without any request, the
+ * global sysctl decides.
+ */
+static inline bool task_numab_mode_tiering(struct task_struct *p)
+{
+	u32 state = bpf_numab_mode(p, NULL);
+
+	if (state & (BPF_NUMAB_DISABLED | BPF_NUMAB_NORMAL))
+		return false;
+	if (state & BPF_NUMAB_TIERING)
+		return true;
+	return numab_mode_tiering();
+}
+
+/*
+ * Whether @folio's memory participates in tiering, i.e. whether its
+ * _last_cpupid carries an access time instead of a cpupid. The requests
+ * of the owner cgroup and of every ancestor are combined. DISABLED
+ * never speaks for memory (it is a task-surface request), so only
+ * NORMAL and TIERING are consulted here; without either, the global
+ * sysctl decides.
+ */
+static inline bool folio_numab_mode_tiering(struct folio *folio)
+{
+	u32 state = bpf_numab_mode(NULL, folio);
+
+	if (state & BPF_NUMAB_NORMAL)
+		return false;
+	if (state & BPF_NUMAB_TIERING)
+		return true;
+	return numab_mode_tiering();
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -83,6 +126,14 @@ static inline bool numab_mode_tiering(void)
 {
 	return false;
 }
+static inline bool task_numab_mode_tiering(struct task_struct *p)
+{
+	return false;
+}
+static inline bool folio_numab_mode_tiering(struct folio *folio)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index b1f1a367034f..688d4cd12c4f 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -40,3 +40,8 @@ obj-y += core.o
 obj-y += fair.o
 obj-y += build_policy.o
 obj-y += build_utility.o
+
+# BPF-based per-cgroup NUMA balancing
+ifdef CONFIG_NUMA_BALANCING
+obj-$(CONFIG_CGROUP_BPF) += bpf_numab.o
+endif
diff --git a/kernel/sched/bpf_numab.c b/kernel/sched/bpf_numab.c
new file mode 100644
index 000000000000..924adf30889e
--- /dev/null
+++ b/kernel/sched/bpf_numab.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * BPF-based per-cgroup NUMA balancing
+ *
+ * A bpf_numab_ops is attached to a cgroup via a struct_ops link. Whenever
+ * the kernel is about to act on NUMA balancing, it runs the policies of the
+ * matching cgroup and of every ancestor, and combines what they return: for
+ * a task, the chain of the task's cgroup; for a folio, the chain of the
+ * memcg the folio is charged to.
+ *
+ * Author: Yafang Shao <laoar.shao@gmail.com>
+ */
+#include <linux/bpf.h>
+#include <linux/bpf-cgroup.h>
+#include <linux/bpf_numab.h>
+#include <linux/bpf_verifier.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/sched.h>
+
+/*
+ * CFI stubs. These really run: a slot points at them while its policy is
+ * being detached. Return BPF_NUMAB_GLOBAL, the identity for the
+ * kernel's OR.
+ */
+static u32 numab_mode_stub(struct task_struct *p, struct folio *folio)
+{
+	return BPF_NUMAB_GLOBAL;
+}
+
+static struct bpf_numab_ops __bpf_numab_ops = {
+	.numab_mode = numab_mode_stub,
+};
+
+static const struct bpf_func_proto *
+bpf_numab_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static bool bpf_numab_is_valid_access(int off, int size,
+				      enum bpf_access_type type,
+				      const struct bpf_prog *prog,
+				      struct bpf_insn_access_aux *info)
+{
+	if (type != BPF_READ)
+		return false;
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_numab_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	/* Mandatory: the core calls it without a NULL check. */
+	return 0;
+}
+
+static int bpf_numab_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	/*
+	 * Members also run from the scheduler tick and from load
+	 * balancing, which hold the rq lock, so they can never sleep.
+	 */
+	if (prog->sleepable)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_numab_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_numab_validate(void *kdata)
+{
+	struct bpf_numab_ops *ops = kdata;
+
+	/*
+	 * A policy which implements nothing has no effect but still makes
+	 * every task pay for the enabled static key. Reject it.
+	 */
+	if (!ops->numab_mode)
+		return -EINVAL;
+	return 0;
+}
+
+static const struct bpf_verifier_ops bpf_numab_verifier_ops = {
+	.get_func_proto		= bpf_numab_get_func_proto,
+	.is_valid_access	= bpf_numab_is_valid_access,
+};
+
+static struct bpf_struct_ops bpf_numab_ops_desc = {
+	.verifier_ops	= &bpf_numab_verifier_ops,
+	.init		= bpf_numab_init,
+	.init_member	= bpf_numab_init_member,
+	.check_member	= bpf_numab_check_member,
+	.validate	= bpf_numab_validate,
+	.name		= "bpf_numab_ops",
+	.cgroup_atype	= CGROUP_NUMAB_OPS,
+	.cfi_stubs	= &__bpf_numab_ops,
+	.owner		= THIS_MODULE,
+};
+
+/*
+ * Run every numab_mode on the matching cgroup and its ancestors, and
+ * return the combined request for the caller to act on. A task question
+ * walks @p's cgroup; a folio question walks the chain of the memcg @folio
+ * is charged to, and an uncharged folio makes no request.
+ */
+u32 bpf_numab_mode(struct task_struct *p, struct folio *folio)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_numab_ops *ops;
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+	u32 acc = BPF_NUMAB_GLOBAL;
+
+	if (!cgroup_bpf_enabled(CGROUP_NUMAB_OPS))
+		return acc;
+
+	/* Kernel threads have no user memory to balance. */
+	if (p && !p->mm)
+		return acc;
+
+	rcu_read_lock();
+
+	if (p) {
+		cgrp = task_dfl_cgroup(p);
+	} else {
+		memcg = folio_memcg(folio);
+		cgrp = memcg ? memcg->css.cgroup : NULL;
+	}
+
+	/*
+	 * A cgroup outlives its attachments while it is live, and
+	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
+	 */
+	if (!cgrp || !percpu_ref_tryget_live_rcu(&cgrp->bpf.refcnt))
+		goto out;
+
+	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_NUMAB_OPS) {
+		if (ops->numab_mode)
+			acc |= ops->numab_mode(p, folio) & BPF_NUMAB_VALID_MASK;
+	}
+
+	cgroup_bpf_put(cgrp);
+out:
+	rcu_read_unlock();
+	return acc;
+}
+
+static int __init bpf_numab_ops_register(void)
+{
+	int err;
+
+	err = register_bpf_struct_ops(&bpf_numab_ops_desc, bpf_numab_ops);
+	if (err)
+		pr_err("bpf_numab: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_numab_ops_register);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45086e6f246c..2cabe8c3ec1e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2964,7 +2964,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(numab_mode_tiering()) && !node_is_toptier(src_nid) &&
+	if (!folio_numab_mode_tiering(folio) && !node_is_toptier(src_nid) &&
 	    !cpupid_valid(last_cpupid))
 		return false;
 
@@ -4207,7 +4207,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (numab_mode_tiering() || !cpupid_valid(last_cpupid)))
+	    (task_numab_mode_tiering(p) || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index ec7b9aadda98..b401f2e36d99 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -57,15 +57,15 @@ static const struct bus_type memory_tier_subsys = {
  * folio_use_access_time - check if a folio reuses cpupid for page access time
  * @folio: folio to check
  *
- * folio's _last_cpupid field is repurposed by memory tiering. In memory
- * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
- * record page access time.
+ * folio's _last_cpupid field is repurposed by memory tiering. When the
+ * owner of @folio participates in tiering, cpupid of slow memory folio
+ * (not toptier memory) is used to record page access time.
  *
  * Return: the folio _last_cpupid is used to record page access time
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return numab_mode_tiering() &&
+	return folio_numab_mode_tiering(folio) &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 79053ece02cd..6b8359ce16f8 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -868,11 +868,10 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 		return false;
 
 	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
+	 * Skip scanning top tier memory whose owner participates in
+	 * tiering: hinting faults on it would buy nothing.
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (folio_numab_mode_tiering(folio) && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
diff --git a/mm/migrate.c b/mm/migrate.c
index 4d2ba87eaa34..dd4e370ae9f8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -819,7 +819,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (numab_mode_tiering()) {
+	if (folio_numab_mode_tiering(folio)) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2719,7 +2719,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(numab_mode_tiering()))
+		if (!(folio_numab_mode_tiering(folio)))
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
-- 
2.52.0


