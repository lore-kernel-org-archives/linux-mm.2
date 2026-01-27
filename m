Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8521D25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D206B0088; Mon, 26 Jan 2026 21:44:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BAD16B0089; Mon, 26 Jan 2026 21:44:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32FC6B008A; Mon, 26 Jan 2026 21:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFB6E6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E2CF13B362
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:33 +0000 (UTC)
X-FDA: 84376200426.13.EFA8B4F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id CCC4C2000F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qDArK4eI;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pZtX5uZ9ZH0+BFuE+o4DynO7SCqFW/EqynrzAnGfryk=;
	b=bhSL1kdWB3QUruzAvl0bZkqoCR9XOGTnEzOiBpr//PLgVfc5lOCdgEH/+OA0Y4HjebsySY
	sQw4m8nZKYHIw0qH4lZEhzDFEvygx0guSQXBNcoOqYV0I1705xMTml4S59pieHG/W8HvUs
	MKVQCKabesE+VES3F9gz5Xgl08kgF6k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qDArK4eI;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481872; a=rsa-sha256;
	cv=none;
	b=SsbDH8xTStCINfUguwtkxhuWuOOcIvga4y0FJkMSTKZN+6KlYwb4cOrreCcVqwHrkusCAh
	gGXiyXnHUpX2TSYYY0Nd8LLsIeGN6EeGhVOh+VfLaXtcgT9phyFUn6pJuQW1c9DQUrUfaw
	pOUMpI0qVjhquMSlkd4E5zGoI4qYAIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pZtX5uZ9ZH0+BFuE+o4DynO7SCqFW/EqynrzAnGfryk=;
	b=qDArK4eIdzVKhsri5bR/ay3++0Jqq9PUQS9qUgaBHZpgNbAaxMzo+A2iF1mHCIKzmbheWd
	hjfLveEn9k5Fi4VolNAHDeyGuiitTRzbSUw4VMzvJtHpMeor79OaHH0S9gnprUPcgvwv4N
	O4lXpMFvQYCBJJs4xRLgOag0R+mbPO4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 00/17] mm: BPF OOM
Date: Mon, 26 Jan 2026 18:44:03 -0800
Message-ID: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: sef7f1jz77occhysxbmdjycitry3rt8s
X-Rspam-User: 
X-Rspamd-Queue-Id: CCC4C2000F
X-HE-Tag: 1769481871-760055
X-HE-Meta: U2FsdGVkX1/XsBdGsC1hT8Oa/xGBhvbd6Nihm90d4P00Yb5JoJJiZE4r065eRHkx5LPJkOim9zL2ClDElkp25Zak0sHPkDVj/OrJ4pLaUoAdueJ7T0PM+IhOt4F9UfRKjsPgRrxgUjuHVvHiik5Mg4ZFb3F+TzwOWJRs34j05Ek59hsBIYQYHUJGOFpXV4gukl1Q8kJjjZEnARDgKd88GrD93LG+D+46772TQZFbRIsnDOmvVqoT4P/Lg5drB/SEnG7OfnnF43436r/E01plhd6nfiuP27hV4JRFJVzMqTidNY3qRJUj2ttNJSuPfIQcWCWxfvSrqoqra5/tJgtolm1/MldvMM14Z0CeHEAnM6UrpETaP+YYZBHnN21sUxasZNunbvqx+XmNR/yM3RQpcWhXv6EBHviTQZkx1n8DFXRGY23aluIUFqiFcLOeKl5W2e9qaPJYkanu0JM/DRmPWZVBPoIIwer+kTNSaO79Yrd9ogA5mczBHKAiZngwcDtpe6E9Ffi69g+SEnkb00JGM3gFWcvgjQpxWNFHO1mhCQpcuVmb2SmLxLAC/kBmYFSR2PNLoq7vla+rLI8b6Tx9lfMMABhsFS7ZGqEn2+hRZKyJnozf53zO64YEx47ALXGTOetm3VvVGraaL4tmrP8y6m6qxhIh8bAgNNlJynqfbQ0sA+9atqScex0Y6XhibW0l6clt+aSX4Hirdv2XS1lCBHRqqITAUh92ztqSchxqPP+fwXYnCyPMScD9k2fSW8yKzRJauugXzbMgCk6vnUnhcIMNLp1pAG8Tz1Ld+f3NlBkrZGhFL+6YKuZU6acOEvEkzifxHGRVK2CdTlwFchs7l/VhGCE7NBdl6CoxkwbRC5BeCZhdY5C3GjsQ5UG8Koy8c8XZOui/SRLiSpqzsJ+btpo+WVt4Tafox7PKmBApvIGxuwAwD37/okovdExagpQWthxfo5pEdaOv6xvLWZF
 AZXF2s6N
 bK88jCWeQVQVnAh8t4NaIzKQ0N3AT1nQVh6jNaHSArjNSe1mLReQmi1NubeWAsmFPJdTnwr3r4HD1HuEbLgkUnKpcOrEff4MchQEV59343W9UOWACTcKu5XnTwNmiqK5vUiH1YvUIXEm5QAZxfIQxdej+xjBOwykt4RMub/dhs3LAQGuFhPBGC3c99g4zwPq/IM2K3auxFqXHDPzpSpe/5O/52sAmihjrPgld671T29/D0lPLFAVJrNO5MOzDyezxAF65X9mg1YNFzkRA+6XVlgy3XYdJbmmseCtOHp7UY6VGkEdDmvxBokfWzPVdf9p1f5cwxdxEK1wMV/wtEtavF4RFdw6XbNC/wWv8HvzZNSw8ZOg66mLTwT9JLHJ13Dyz3i/tYW8BdbIHN3njrSzmgah9oNXymoYXT4bWkTiSII6H+xkSDZBUKAt0cA0jpxUcbUNh5yRXwoi4gq3z8ZKzc5Sebf39Q+BmxMSo2RkPrCCakSWwntJu9MLaBSpj62HYrC2ysJJlWLDkPN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds an ability to customize the out of memory
handling using bpf.

It focuses on two parts:
1) OOM handling policy,
2) PSI-based OOM invocation.

The idea to use bpf for customizing the OOM handling is not new, but
unlike the previous proposal [1], which augmented the existing task
ranking policy, this one tries to be as generic as possible and
leverage the full power of the modern bpf.

It provides a generic interface which is called before the existing OOM
killer code and allows implementing any policy, e.g. picking a victim
task or memory cgroup or potentially even releasing memory in other
ways, e.g. deleting tmpfs files (the last one might require some
additional but relatively simple changes).

The past attempt to implement memory-cgroup aware policy [2] showed
that there are multiple opinions on what the best policy is.  As it's
highly workload-dependent and specific to a concrete way of organizing
workloads, the structure of the cgroup tree etc, a customizable
bpf-based implementation is preferable over an in-kernel implementation
with a dozen of sysctls.

The second part is related to the fundamental question on when to
declare the OOM event. It's a trade-off between the risk of
unnecessary OOM kills and associated work losses and the risk of
infinite trashing and effective soft lockups.  In the last few years
several PSI-based userspace solutions were developed (e.g. OOMd [3] or
systemd-OOMd [4]). The common idea was to use userspace daemons to
implement custom OOM logic as well as rely on PSI monitoring to avoid
stalls. In this scenario the userspace daemon was supposed to handle
the majority of OOMs, while the in-kernel OOM killer worked as the
last resort measure to guarantee that the system would never deadlock
on the memory. But this approach creates additional infrastructure
churn: userspace OOM daemon is a separate entity which needs to be
deployed, updated, monitored. A completely different pipeline needs to
be built to monitor both types of OOM events and collect associated
logs. A userspace daemon is more restricted in terms on what data is
available to it. Implementing a daemon which can work reliably under a
heavy memory pressure in the system is also tricky.

This patchset includes the code, tests and many ideas from the patchset
of JP Kobryn, which implemented bpf kfuncs to provide a faster method
to access memcg data [5].

[1]: https://lwn.net/ml/linux-kernel/20230810081319.65668-1-zhouchuyi@bytedance.com/
[2]: https://lore.kernel.org/lkml/20171130152824.1591-1-guro@fb.com/
[3]: https://github.com/facebookincubator/oomd
[4]: https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd.service.html
[5]: https://lkml.org/lkml/2025/10/15/1554

---

v3:
  1) Replaced bpf_psi struct ops with a tracepoint in psi_avgs_work() (Tejun H.)
  2) Updated bpf_oom struct ops:
     - removed bpf_oom_ctx, passing bpf_struct_ops_link instead (by Alexei S.)
     - removed handle_cgroup_offline callback.
  3) Updated kfuncs:
     - bpf_out_of_memory() dropped constraint_text argument (by Michal H.)
     - bpf_oom_kill_process() added check for OOM_SCORE_ADJ_MIN.
  4) Libbpf: updated bpf_map__attach_struct_ops_opts to use target_fd. (by Alexei S.)

v2:
  1) A single bpf_oom can be attached system-wide and a single bpf_oom per memcg.
     (by Alexei Starovoitov)
  2) Initial support for attaching struct ops to cgroups (Martin KaFai Lau,
     Andrii Nakryiko and others)
  3) bpf memcontrol kfuncs enhancements and tests (co-developed by JP Kobryn)
  4) Many mall-ish fixes and cleanups (suggested by Andrew Morton, Suren Baghdasaryan,
     Andrii Nakryiko and Kumar Kartikeya Dwivedi)
  5) bpf_out_of_memory() is taking u64 flags instead of bool wait_on_oom_lock
     (suggested by Kumar Kartikeya Dwivedi)
  6) bpf_get_mem_cgroup() got KF_RCU flag (suggested by Kumar Kartikeya Dwivedi)
  7) cgroup online and offline callbacks for bpf_psi, cgroup offline for bpf_oom

v1:
  1) Both OOM and PSI parts are now implemented using bpf struct ops,
     providing a path the future extensions (suggested by Kumar Kartikeya Dwivedi,
     Song Liu and Matt Bobrowski)
  2) It's possible to create PSI triggers from BPF, no need for an additional
     userspace agent. (suggested by Suren Baghdasaryan)
     Also there is now a callback for the cgroup release event.
  3) Added an ability to block on oom_lock instead of bailing out (suggested by Michal Hocko)
  4) Added bpf_task_is_oom_victim (suggested by Michal Hocko)
  5) PSI callbacks are scheduled using a separate workqueue (suggested by Suren Baghdasaryan)

RFC:
  https://lwn.net/ml/all/20250428033617.3797686-1-roman.gushchin@linux.dev/


JP Kobryn (1):
  bpf: selftests: add config for psi

Roman Gushchin (16):
  bpf: move bpf_struct_ops_link into bpf.h
  bpf: allow attaching struct_ops to cgroups
  libbpf: fix return value on memory allocation failure
  libbpf: introduce bpf_map__attach_struct_ops_opts()
  bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
  mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
  mm: introduce BPF OOM struct ops
  mm: introduce bpf_oom_kill_process() bpf kfunc
  mm: introduce bpf_out_of_memory() BPF kfunc
  mm: introduce bpf_task_is_oom_victim() kfunc
  bpf: selftests: introduce read_cgroup_file() helper
  bpf: selftests: BPF OOM struct ops test
  sched: psi: add a trace point to psi_avgs_work()
  sched: psi: add cgroup_id field to psi_group structure
  bpf: allow calling bpf_out_of_memory() from a PSI tracepoint
  bpf: selftests: PSI struct ops test

 MAINTAINERS                                   |   2 +
 include/linux/bpf-cgroup-defs.h               |   6 +
 include/linux/bpf-cgroup.h                    |  16 ++
 include/linux/bpf.h                           |  10 +
 include/linux/bpf_oom.h                       |  46 ++++
 include/linux/memcontrol.h                    |   4 +-
 include/linux/oom.h                           |  13 +
 include/linux/psi_types.h                     |   4 +
 include/trace/events/psi.h                    |  27 ++
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/bpf_struct_ops.c                   |  77 +++++-
 kernel/bpf/cgroup.c                           |  46 ++++
 kernel/bpf/verifier.c                         |   5 +
 kernel/sched/psi.c                            |   7 +
 mm/Makefile                                   |   2 +-
 mm/bpf_oom.c                                  | 192 +++++++++++++
 mm/memcontrol.c                               |   2 -
 mm/oom_kill.c                                 | 202 ++++++++++++++
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/libbpf.c                        |  22 +-
 tools/lib/bpf/libbpf.h                        |  14 +
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/testing/selftests/bpf/cgroup_helpers.c  |  45 +++
 tools/testing/selftests/bpf/cgroup_helpers.h  |   3 +
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/test_oom.c       | 256 ++++++++++++++++++
 .../selftests/bpf/prog_tests/test_psi.c       | 225 +++++++++++++++
 tools/testing/selftests/bpf/progs/test_oom.c  | 111 ++++++++
 tools/testing/selftests/bpf/progs/test_psi.c  |  90 ++++++
 29 files changed, 1412 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/bpf_oom.h
 create mode 100644 include/trace/events/psi.h
 create mode 100644 mm/bpf_oom.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_psi.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_psi.c

-- 
2.52.0


