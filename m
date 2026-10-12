Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69F0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9122C6B0088; Mon, 12 Oct 2026 08:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2F76B008A; Mon, 12 Oct 2026 08:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B26D6B008C; Mon, 12 Oct 2026 08:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2D96B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:05:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF4DC140B5C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:05:38 +0000 (UTC)
X-FDA: 85313844756.20.8A45876
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA977A000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:05:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEvlryvS;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806736;
	b=2A9w/wOAdBEf8AGN2cWn7bkHs6LGo/2otmTJDYIAgKfR8Fq2nRHOh+RdVbfVuADZyyjcH8
	DSUIAldtqZY/9Aqh/lhmSgdxQJ7SmDvS0sVtszMstyUc+Yr1Hp4l6qFm8UnpSXbfIXErDq
	9eOORT7BMExqUc/1s+v/WtQ2xLveCbM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JEvlryvS;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kLbm/HnztJlhbsvLEPa7IOES1RKYfU4H2Ro9opKpO1w=;
	b=7fIJk1DnPERCtbWexQonkVdeK491JNEHo4zzVTdph9UjcWonY3ewoIiyO25LzRWECIO2XS
	GbDfKM1rkFD0+uvMBWtJ6Kb78KD6HS3ok6hx4xfNfoTZgh02seGFKLckX6cclYL9Q5VIUG
	c1HkGA4lwI568uhV0GAdTvkXrW2FnqU=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so845966a91.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806736; x=1792411536; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kLbm/HnztJlhbsvLEPa7IOES1RKYfU4H2Ro9opKpO1w=;
        b=JEvlryvSfMvtrl4TpMOxjuGpaz0xPh5SmLQNXYLKNdq0joT3DLEEwdsUEuvNb/xCIv
         6pYNHtsLA7wL1XD4sD2pm2lJ48iFnQFRtaHmR1Alb3We0FKUdbL6JYgDtappX7I7XTYQ
         19SkWARkd04seJSNaeWGF3FQ0BGLcbGc6ysFf3Tk1H9TYYBUKCbWuHX0RXvHvPSzv7pc
         T81jn1lnxvobflcS71RWeBFNoMAuCRE1oQyI/gPc9p3ucp137ztgn7P65nfkDxNoGx/Y
         ezvKw5m2qdj19qtQrruSnIRQz8ip9hVgesjbE9rV3n7Iv13mZgGWHI9HGE4IL0uBd0pw
         9BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806736; x=1792411536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLbm/HnztJlhbsvLEPa7IOES1RKYfU4H2Ro9opKpO1w=;
        b=25Ku7RibPwqzGa2mUlUOihkiKVinecDfT2xEfiOqVLYntHh+os/qPMuWRmL5WcEg06
         HSDlztJcpYOemct0yYqMZKAo8npCTGDKZUUH7kGRCwd50pP4jEmCDdwO5Cs3oroOKB2e
         a025oS3fr3gUz8G8fM60JKIB4d9nbszqpuK+ntWCVNPgPd3gJwAC/iH57HsMkJw76oS3
         VGNd0OnQDfeMELe/sDlUj9cqJatoiKWRDv/yKr+EbMAmUYFYPczF1SJCddR2/RXccjmQ
         +z37IwiG2Xh3k0ElLRjwjZCy4m+0/45WT5yG/YFC4Ba0cNSN77eAHSELvJTk8h/qj0KW
         gYEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxF372KYb6EhmwHMSBKlgALJ1ANtFNzB9zec5TkQYIEwxrHwB35aTmtQtKgF6oIrEs5+CkxNWIQGg==@kvack.org
X-Gm-Message-State: AFq9FYJupdGyYTXW/AehGVw/ATIOTmB/bEcruIAxfWwqcwvGu3X/HEfR
	E933nazZEea51AT54tJkxlHizixu+yJc+y4U+gUbie/Kf25jkkCHaQ6G
X-Gm-Gg: AYBFou08yT0xwG0fVqMSpUaUWUILIBNWeuhXhOOZ6/Y9u44xj/+id3hXjlWbjUipH3f
	q2Ih8zsgpYljz41j7HtwJHauIE4ZuYcLYPEL1zFN+NRrxWNdujvg6p+2VKhikDa1deBf482dtvO
	5CP2nkzwk0x6KuWeuykGnf2MpIa7qxdR4sq8/zROv5gOdgr5/WmgO0PZDve4ZCT+uAmQAwV/AgK
	sNbhx0Ix+mJvJf511sfFQ9O8cOfLr7krvJbBXMvT9VqVuWqV/9I+vaby+BVpgF9DnsuYJ/uGQE6
	flV/Qwc27q1qxgHgpT4pnnZbcjFMCF7JpsGFHbG8rVt+QoKFjgwnx0vcNPKOhGzpwqQkhABQjXl
	8xk4xESvH5git8jGWDZdjqXRc8Dyc6yU8lKqzCJmOkjkykrScxfK9IuGoGvK0xGaBZKJj8wYGZm
	MKaW/Xn9EW4tfKf52DNEb+bDGA8Gx9MZSox048x2gWFOuZ2N02bSRLKQiTn+8ElHPsJ/bjXrG6E
	w+VlKTFUi9k7UNFfGjKr8k7L5ztkzF6i1cKptWA1wbm2A==
X-Received: by 2002:a17:90b:3b84:b0:3aa:f4af:1e16 with SMTP id 98e67ed59e1d1-3ab3a4871e5mr7188609a91.7.1791806735133;
        Mon, 12 Oct 2026 05:05:35 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.05.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:05:33 -0700 (PDT)
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
Subject: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
Date: Mon, 12 Oct 2026 20:04:35 +0800
Message-ID: <20261012120438.52849-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fynh97dan3rh1mjjiwuopcf6pgmktrag
X-Rspamd-Queue-Id: EA977A000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791806736-321259
X-HE-Meta: U2FsdGVkX1/j1V92ImyS+SJJqKjtkQDdFqjScgwHr2ATKynBnyP3IswW5SbwRL2eduU43gl2KLy8SuKuAzyL7VUDsPaO16uT3NWArmHrCl9OeD7v5fgdnnlrekEFoH4duQqkcGuSt2C3vfV748OIUD4QrPLZIR+TajxTEIexceG7dGycSr8tZPE4kcjB5r4Sp+jIQfcMLWXF7xLrbjIRmOkl1XM2eqycTCxjJd25NwOPkdsFdd6ct2zIzA9zAlfH0bEe0mg0Y2W3MOJZsRHHObUbDYO+hmMq+MO/4ha3NPNCC+FwNovviFJJgQgyD1xOz4H3ceED7ZMUws+lfUn/niz7yF2g0/FmQqvgn2ot8ml1sCj02+TPjN2FTqaDmfZr89+aROlmnUfbh1DHW+KEeEjz3YBbCUGOFghl+rnVRgjLQPAmso6zbl1pFhp+U1bV1IuZyR1rOkK54bLD1WrK+sRW49xiMKYDmry9gH52ZJe2P85OdAn76dVUxDLci1+3l/6HseVzlzZsvDe2sF1g4OZjcB9dc8JXqFTcGCrXPIYvqrligl0jra4kIvfp8+yo6XUP04N65fn5t9e0uf2hpmjoMYjF/VyDjphO6H5yR6D24LnVHS7YI1n+Vu3FP3gx58CE/Ycc9UNiCme1/u1ujU2KhChv4EME/FxjlAa1oxsl0ds2hALO+IbUlkJmjdekH4XVGe8+Wjdid1Rzpzf1JVzdEQoqKgT5jYIlviQMLVrQdogNRW/o+JCkh/MzL4snmeVEElaT+ewiiPWWkSqumBcqVaiLsmGTMWLA1nnZPNExzi+2m/gNCMoNktx0JH11Pu5xMVvivmKYqc+LXguC8P/ry/A70oWOGptVOY7RjTOCfCtKBTvAWF0HqJDKeNSfQdSRkztWYsdGnWsf8qP+TwoJCt9DbjGxWqRvaluMipMz+/Sp7tWZUvu9G83p1HCMt+6YRLwu6l+ZvNxYb0D
 NGY1sk9c
 MtYFBMbLtDY4a095TJwg/geD22CAWRvnM1l1B2xTDqjwksC7cFY8CxYFaZNfQWNQd0qjaH/mopLWNJQjKO4skx5BKmeskx+cLxWvXCl+3eLwYcy7gB1qYNJpTBnr8/75TyW0HfAIabKgH8DxXPuBzDn2fZ9kNA/Kc/II+aEVssKXhGbL61t9/kh3fsMjKBw8Yid0OCUc5Ju9Cw/nMfcij/uBv/d8ehNvQYWAjN5H61P9so61QOGyAp+xoBsXQDwE5ilesQ+ZTRXGxjcEViWAwGkBfKK1Ju8uiPcvfXZzpWKAju0stpOF5xtBG6Isb2hk8i2rm7TP5zBD9UeLE1vf2rOdWq1+VHJHKg0ka5SKhCtULn6ASA48SbYnot8I3kluSUs8d7m/cuQiukh4F/xnxLtPFyrIOGeiAYUBxIz2jpCJMWJSXefO54TD+eKCGp225hGaXA0F71aeIBKAAZFXl/7wMeJJ7fmGU3jUhlpCH2rby2xmk3M9rLasn9hvLCYasRxP3TSSuf2N8r9ekgtEMPNNGWuqUcUoIveHamVmeOV9HizwFdhZk7Rwp7mKiBW1To+KO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Problem
===========

In our large fleet of Kubernetes-managed servers, NUMA balancing has
been historically disabled globally on each server. With the increasing
deployment of multi-socket AMD EPYC servers, cross-NUMA access has
become a critical performance issue, which made us reconsider.

Enabling NUMA balancing globally is still not acceptable: it increases
the overall system overhead and can introduce latency spikes for
latency-sensitive workloads. What we need is to choose per workload
whether NUMA balancing runs at all, and which mode it runs in. A
latency-sensitive service may want the scheduler's NUMA statistics
without tiering's promotion machinery, while a batch service wants its
PMEM-resident memory promoted when hot without paying for
scheduler-driven migration. No single global switch serves both.

The Design
==========

This series adds a bpf_numab_ops struct_ops which attaches to a
cgroup. The kernel consults the policies of the matching cgroup and of
every ancestor and combines what they return. One policy question, two
surfaces: the kernel passes the task when it acts on a task and the
folio when it acts on a folio; exactly one of the two is set, so a
memory answer cannot be keyed on whoever happens to touch the folio.
A policy can always opt a workload out, so no cgroup is ever forced
into heavier machinery than its own policy asks for. The demotion and
migration-fallback machinery stays global, as it is keyed on
node-level reclaim state rather than on any cgroup's policy.

The hook is designed to be free for everyone who does not use it.
Every call site (scheduler tick, NUMA hinting faults, folio
migration) first tests the cgroup_bpf_enabled() static key of the
new attach type. The key stays off until the first policy is
attached anywhere in the system, so with no policy attached the
added cost is a single patched branch.

The BPF consult comes before the global sched_numa_balancing static key
rather than after it, because the primary use case is a fleet which runs
with global NUMA balancing disabled and enables it per workload: a policy
must be able to turn balancing on for its cgroup while the global switch
stays off.

Once any policy is attached, the key is on for the whole system and
every task pays the walk: a cgroup lookup, a percpu refcount tryget
and an iteration of the pre-aggregated effective array, so the cost
is proportional to the number of policies in the chain rather than
to its depth, plus one trampoline call per policy. This is also why
patch #2 rejects a policy which implements nothing: attaching one
would flip the static key for the whole system and make every task
pay the walk for no effect. The key turns back off when the last
policy is detached.

Measured with schbench (64 worker threads, 30 s per run) on the test
box. Wakeup latency percentiles from the final cumulative window, in
usec:

                            p50  p99
  balancing=0, no policy    15   207
  balancing=0, policy       15   205
  balancing=1, no policy    15   199
  balancing=1, policy       14   201

With a policy attached, wakeup percentiles stay within a few percent
of the no-policy baseline whether the global switch is on or off, and
throughput stays within the benchmark's own run-to-run variance.

On this box the global on and off states are themselves
indistinguishable for this workload, so these numbers isolate the
cost of the hook, not the benefit of the selection; the benefit side
needs multi-node, memory-heavy workloads.

Changes since v1
================

v1 keyed the hook on the memory cgroup and temporarily embedded the cgroup
id into the struct-ops value, because the cgroup struct_ops integration was
still under development. v2 attaches through the cgroup struct_ops support
that has since landed in bpf-next [0], keys the task surface on the task's
cgroup and the memory surface on the folio's memcg, and adds the
memory-tiering mode alongside enable and disable.

This is still an RFC with limited testing. Feedback is welcome.

[0] https://lore.kernel.org/bpf/20260706171918.317102-1-ameryhung@gmail.com/

RFC v1: https://lwn.net/Articles/1054030/

Yafang Shao (3):
  sched: add helpers for numa balancing
  sched: add per-cgroup NUMA balancing mode selection via BPF
  selftests/bpf: add tests for the bpf_numab_ops struct_ops

 include/linux/bpf-cgroup-defs.h               |   1 +
 include/linux/bpf-cgroup.h                    |   2 +-
 include/linux/bpf_numab.h                     |  77 ++++++
 include/linux/sched/numa_balancing.h          |  82 ++++++
 kernel/sched/Makefile                         |   5 +
 kernel/sched/bpf_numab.c                      | 164 ++++++++++++
 kernel/sched/fair.c                           |  16 +-
 kernel/sched/sched.h                          |   1 -
 mm/memory-tiers.c                             |   9 +-
 mm/mempolicy.c                                |   7 +-
 mm/migrate.c                                  |   7 +-
 mm/vmscan.c                                   |   6 +-
 .../selftests/bpf/prog_tests/bpf_numab_ops.c  | 250 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_numab_ops.c       |  57 ++++
 14 files changed, 660 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/bpf_numab.h
 create mode 100644 kernel/sched/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab_ops.c

-- 
2.52.0


