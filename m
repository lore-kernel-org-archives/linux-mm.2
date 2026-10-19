Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A68CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EC26B0141; Mon, 19 Oct 2026 02:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2446D6B0142; Mon, 19 Oct 2026 02:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A896B0143; Mon, 19 Oct 2026 02:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB1876B0141
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:42:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BED28061D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:28 +0000 (UTC)
X-FDA: 85338431976.05.3E38C1A
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A616A0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rStAN/zm";
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392146;
	b=urZhmqxjfC9Z7J+CkE7OATt1Zes7OfJ8LgOlfS9k6UnaKgU/DxbOB45xg72Axch2206qXf
	h1QymgG506ZjsdPqqOXxJ2eGrDROJrQcE90TSp6738ZTq+WmNHYd0rS2LmTjvQYcxwWMC+
	BjWm2Z+Flvy96qqCx7nnVm4DQJbAapM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rStAN/zm";
	spf=pass (imf15.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f5XFXarYDugU15GvRn4heGPbOvz9Qo8H6YKk5rO58RE=;
	b=ybumo5zlOQhtvm7gOw4RVtXFqgPN7t4Pp3JLAEn7sDTSVH6v5OjP42fzZdSmFlUpWFCGFH
	Kq1WucKPDNl/Uy9Ygzf7+UFVjabzXdjhg6qlRTozxtNkrzXfquz9cSCtqE2CXB9JcKpg67
	rIU4EiNP6y0sf52W6SrJPzt1nhA7jWc=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cd5e6f0a22bso540776a12.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392145; x=1792996945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f5XFXarYDugU15GvRn4heGPbOvz9Qo8H6YKk5rO58RE=;
        b=rStAN/zm3SyKogcUoKFDfAwqSfRk4rKRbeZ68GYQ+c1psrTHTW5+7XxO6PR8SOTgb6
         yZlikL09yc0EvaK61ciSq4PHg8lkgaOUTDkp0v4U8iv+HoIpjwyAdS+jPjSKt3pzjYVM
         0E2nIn0u7Ddv/q5sGVwTgSrK68B3n1B/tbqcsbqvaJvITNiNdh2S2gPlfDRWNUt8udGA
         vprO/pj4jHw5PeElBzGLgcVhQgzL4cdC64AgzhPwr8G3FMQjf9tVQ8yleItmJ+4y3V4D
         39J9qPvaeKWcaEECc5dXR3KmMsfiBFCv/rKHVKrLf0qHE73a09C3XLVVhD+Jv7/6s8xV
         4OGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392145; x=1792996945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f5XFXarYDugU15GvRn4heGPbOvz9Qo8H6YKk5rO58RE=;
        b=FK41q9qipMjLtrTac11W/PljFHqwBTzsw3EEF4w+Gyec88sALXAdZ5TfiX4Bb8X/t5
         LMT7P9y4LGpBBZKLU6pNsnGD23eQEjCNIb20gL+0MDfvPyew0wb2KtjDS4DJRr650kwO
         7d0hz4vEH+E1Mds1JERzadAYE5BQojOzyNj2K4Jx9m2/yigxN/9Tv9xXz4/EXWwed8mV
         aaVhTY+ShvsSMhMkk24NMoYC1ekXFCk7njwN85pEPI+D04BwvtNRcENpmMEHyXQxwwWZ
         4dB7sImoNcfNcxr4fTK9kddJChNBHudw9pGCUQSAkVvuLCaAcAFlH7gLX7a4Zgjq9lAN
         JsDA==
X-Forwarded-Encrypted: i=1; AKwUvBzaIHW3UeeqdDf1JC+7nHTIBj2pdHEFcBbtjWrFw1N6Lo3UOT+a7nq15HiUqn2RBBDt1Jh+cn4AIg==@kvack.org
X-Gm-Message-State: AFq9FYJYe/pc3jgQbgiSSXQkcDnw02kJDxet8W6yvTQfpvbz3T9rzWKQ
	xC64AD4DzAPPZyUEpvIgy7/yOAtrpDKMWO+zsx/c/y0kxT48FXKxHZ2c
X-Gm-Gg: AYBFou0E+VScVKBy0k2nRjMgJSVcwKv9P2JfaWzoXtua3C3g8MndVQaJ+y1AkOSPXtj
	G5IsNO232ukEwgq1kaoP6TW97Ept+qyI9vUsIY8YEtHhnoE5W/IrA8xRYlU3BJgdf6l7UTaQsjy
	eb3JR0JkqZ200HF1k7Q4RiVpBGizN5M8M6RD7dUcNf/VA2ix9AlqEzb7zLSoQrLNPflkfWdtgsV
	amL3Q/TF4H5C6XLoTqZYU39RqGBpnK2BRSYO6f6kNccNtEUxiIfuYcZTNJW024xOewkMOJioRHc
	s92Fo+tq9KoipqFSgo6eFdoq47E9DF0WAAOvQnY/eXOYQaH82GIQToesWKZaNj8vwUqxGMUD4Ub
	WpXHuY+rcGVg+ENIcCVWPbTJPl0qswb7+nHnjOQgUe2cmitt5Rwibuve8AJEOygovpf68LUQzqS
	MZxC05+5VfIdf+LLTWD0MKw1I9MDcevgKE/GhS35CO6SKlBfGzGOzzkkYRp9i1zUR3d80gGB/tQ
	DIVhGcyLM2AvLZHHRPadCDWH3dcZsRsi8Wc2mMiVpJ0n0uxLc/XKj/8cU1KIyzlW+WcOw==
X-Received: by 2002:a05:6a20:e30b:b0:3e1:c6e6:d101 with SMTP id adf61e73a8af0-3e225f7674emr5446422637.29.1792392145181;
        Sun, 18 Oct 2026 23:42:25 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:42:24 -0700 (PDT)
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
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
Date: Mon, 19 Oct 2026 14:41:52 +0800
Message-ID: <20261019064157.29885-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A616A0002
X-Rspam-User: 
X-Stat-Signature: jg3bs5dhiersmaes5kcbi1ktpg7gmjim
X-HE-Tag: 1792392146-276381
X-HE-Meta: U2FsdGVkX19jpSD7VAB2amNvKEcfP3/8/ULuskUdtSnpalbcFFbhFX/1QfeP+tKy25Ek1YOUq+LXROagYzw91rzublQRXX3zmjFQYJHBJgkY8cf48tQ2xtQuBZPfuqy82c+QQo2P8OHhI8//wD3GJ67pMlr2zcWWt3GyX+hQMYTFuDzIyVvDLZAkDeCDQwziK1IKcZbWeNSSL1WBLNzv02qzrs3SaD/c6ux6qkW0uiPl11vNnGVY/sJDQqSWsNhg7QUTRMio/SuhREAm15QntCakV66A+Mj1YGc6cK51vifAriUWAwzmBG8p+BAynhmp5LbR1oWaPgVLmZxInxBF7CnpS2RN979Y3juYteVn3VgW8QBfcoR4xu5pKzg0IX4+crgNgKFWDcSyUcBUfFiNhFTTNz8snI5YpcrlWy7Qo3AiBq6CDf+NqMCyUhz/QBmJqiMu7LFTfx/ZbFezQS4njvL/R82MaCuPVl5DLOYbKK2ZOsmTRS74ItmioOmrjY/tpNz41UTQKI5yiU2GKl+3fbQnBcKN5aKdrAr2AvXiQGfeOmHB/vDLcAYW/doRENejz2/TenyJjRQlmjz4hHUzTjlAcLqdZVSKXqwieEh2NaLAMtLcN5+F8xaUKy/J3QQxZ6Pe0Zgpx2QflWf48x7Kgearp1PZ/KAdCFNOaRMbLF3i8KZvnz8mv1nC0LFO0kJNnyeJmBxXijorstzPcoUed1V+Df5c7h6mep9IIr8wcRwIxTCtaIpjrTEn1JDkRPlyBeIJ5jpCKhxh1Stn3jK4HY3fpx71USxPozBwGpytttX1chUrB3gV2T87EXnGT4voS9Fiwpx7Tk0ryZ9EzjcXQR2UMdpYC52PTgpzcUcBRoQ2XNPLZpMB758eF9LC/wKsmZC1NyhgO7q2X53xJZJoqHCjP7eDKFTlLaSaa6MsdZuQgNEj+lwAFC5wZ95DZI3cBtR+Up1KrLUU3yGGrh3
 gPnHQp5H
 pDh3KiUueHSY4keH+MtvDSDVJnXEye29TbgtFX+UzeR8MxeXXmeTVRva3ublXi14r8yYzHGeHD9MMUyV5fgsZm45asvWwI7WSp8V2zbBSMQRyDQralLYFjx/bdbDvg44d8lgI14K9Am7wNZnvrfQrSM3WEIb5vtVcCMZNAWBSdQJUautA2ep9KAl0Sce+izNYRfyiy7nbYYhyC9EwvtrgPeNa+AHDBBVZrG6KbwS2mmkppn9y+eQYqR+m8CRiMDcyu4MgklDy4xrceg5ALxbNRZKePMv2ZU+HM3RcL3WJ2TfJTv5SsF1U/ufp+iClnCvTrZ3+rWq7cX4cPIt3ipZ2FGjCZ5q9wgC4htHBNrW+IOcFxFCjc5Vx+I7t4g3HHqZvloZ45nWDE3kn/c0xdmkbaoOGos2ebOpn7ZPKgxMIMltfM5bCtOgnvuaElQnwdhL9pRsIZoKqSo8ihHQjCvr8gRmaRejvnSGKF2kAlCD7gKnlA6KcfomCDuQiZLZyDv2KHZfKM2lvvb4I5iAJEafUypjwEatOUGPR6H/LgZaowskXt6yMcB7hM2Pr0wValSGDobvs
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
become a critical performance issue, which made us reconsider enabling NUMA
balancing to address it.

Enabling NUMA balancing globally is still not acceptable since it can
introduce latency spikes for latency-sensitive workloads. What we need is
to choose per workload whether NUMA balancing runs at all, and which mode
it runs in. A latency-sensitive service wants NUMA balancing disabled,
while a batch service wants its PMEM-resident memory promoted when hot
without paying for scheduler-driven migration. No single global setting
serves both.

The Design
==========

This series introduces the fine-grained per-cgroup NUMA balancing
control. It grows out of Tejun's suggestion to store the existing
NUMA_BALANCING_* bitmask per cgroup and expose it through BPF kfuncs.
cgroup::numab_mode holds the request: NUMAB_FOLLOW_SYSTEM (-1) defers
to the global sysctl state, anything else is a bitmask.
bpf_numab_set_mode() writes a request, bpf_numab_get_mode() reads the
combined request of the cgroup and of every ancestor back. The hot
paths walk the same chain at read time behind a static key, so while no
cgroup makes a request the overhead is one patched-out branch.

An opt-out wins and binds the subtree: a DISABLED request anywhere in
the chain opts the cgroup's tasks out entirely. Otherwise the requested
bits OR together and the kernel reads them independently, the way
kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
both modes. A DISABLED request only speaks for the cgroup's tasks,
never for its memory, which follows the remaining requests of its
ancestors.

The cost of the additive combination is that an ancestor cannot cap
tiering short of a full opt-out: a descendant's TIERING request
re-engages promotion for its own memory, and promotion is the mode that
consumes the shared fast tier.

The readback contract is worth spelling out: bpf_numab_get_mode()
returns the combined request of the cgroup and its ancestors, and the
kernel reads it the same way it reads a single request, each bit
independently as kernel.numa_balancing does, so a combined
NORMAL|TIERING engages both modes. When any cgroup in the chain makes a
request, the value read back is the mode in effect for the cgroup's tasks;
when none does, the readback is NUMAB_FOLLOW_SYSTEM (-1) and the sysctl
decides. The answer speaks for the cgroup's tasks only: its memory follows
the remaining requests of its chain when it opts out, and that folio-side
view is not exposed by the kfuncs. These are deliberate simplifications;
both can be revisited if callers turn out to need them.

The sysctl's own documentation is untouched; the override is documented
where it lives, in the CONFIG_BPF_NUMAB Kconfig help and the kfunc docs.

The override was measured with schbench, 384 workers, on a two-node
384-core machine. Whatever kernel.numa_balancing is set to, a cgroup
request puts the cgroup at the throughput of the equivalent
system-wide setting, within a fraction of a percent: the override
itself costs nothing measurable, performance follows the effective
state alone. The two states themselves differ by less than a percent
under this load.

Changes
=======

RFC v2->RFC v3:
- The struct_ops interface is replaced by two kfuncs, following
  Tejun's suggestion.
- Improve on the function naming and simplify the code (David)

RFC v2: https://lwn.net/Articles/1099962/

RFC v1->RFC v2:
v1 keyed the hook on the memory cgroup and temporarily embedded the cgroup
id into the struct-ops value, because the cgroup struct_ops integration was
still under development. v2 attaches through the cgroup struct_ops support
that has since landed in bpf-next, keys the task surface on the task's
cgroup and the memory surface on the folio's memcg, and adds the
memory-tiering mode alongside enable and disable.

RFC v1: https://lwn.net/Articles/1054030/

Yafang Shao (5):
  sched: fix stale get_pref_llc() stub for !CONFIG_SCHED_CACHE
  sched: use static_branch_likely() for the NUMA balancing tick check
  sched: add helpers for numa balancing
  sched: add BPF-based per-cgroup NUMA balancing mode selection
  selftests/bpf: add tests for the numab kfuncs

 include/linux/cgroup-defs.h                   |  10 +
 include/linux/sched/numa_balancing.h          | 149 ++++++++++++
 init/Kconfig                                  |  20 ++
 kernel/cgroup/cgroup.c                        |  14 ++
 kernel/sched/bpf_numab.c                      | 195 +++++++++++++++
 kernel/sched/build_policy.c                   |   4 +
 kernel/sched/fair.c                           |  33 +--
 kernel/sched/sched.h                          |   1 -
 mm/memory-tiers.c                             |   9 +-
 mm/mempolicy.c                                |   3 +-
 mm/migrate.c                                  |   7 +-
 mm/vmscan.c                                   |   6 +-
 .../selftests/bpf/prog_tests/bpf_numab.c      | 227 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 +++
 14 files changed, 681 insertions(+), 29 deletions(-)
 create mode 100644 kernel/sched/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

-- 
2.52.0


