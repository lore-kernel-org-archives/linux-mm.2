Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C43AC606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=flOJ/X+y
Received: by kanga.kvack.org (Postfix)
	id EA8C96B05B9; Tue,  3 Nov 2026 07:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59B86B05BA; Tue,  3 Nov 2026 07:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F476B05BB; Tue,  3 Nov 2026 07:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B739A6B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:29:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 365021A0316
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:03 +0000 (UTC)
X-FDA: 85393737366.09.745DB4B
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf09.hostedemail.com (Postfix) with ESMTP id E213A14000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="flOJ/X+y";
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708941;
	b=UsZdjYui46V3OaV3e/bIpjBJUG83yT15lT28+Mv8JdNvYAEblE4eIvtYdTnakhVqyiVr/f
	aBdJHx++bcPu5WNyl36CwpCUmFva5KlqjhJtBM0+ptgt8IHif8sDHgC7FU8Fwg8GV38CdI
	ocCAbr+5ZWp25hAercDNtcktUD/+ewY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="flOJ/X+y";
	spf=pass (imf09.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wOhCgbps4lA7SRHLdsZoglLbAnTEV76cW6tNLVgU3KQ=;
	b=I8hWIunhU9puan//RuYzmgvnm8kyV7gBlWd3GhG8H3iAp6CpIMd3YWOBcgodSO9HQO/1Rg
	kvfeyJmLPOpmo5c0e4PG7yvEgO/zSNzq1Rv+CzSO7h0JfmFHmEvc8kZ2lAOWnoMMbomqTe
	M5uu8AYy+2FB4KgWjcrFVMjvJ+UO1tk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793708935; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wOhCgbps4lA7SRHLdsZoglLbAnTEV76cW6tNLVgU3KQ=;
 b=flOJ/X+ybYPE0Hw4aOowGOFweRGDj5wp90XD0ZDJd3YEc7liRSuOxdYJb1w176ufzFQZGm
 vukg3j0UsIJ60M2J0Dc118YPrpEJakKP5Wa7SiS+W5E2AlyBbf6VWujCzC/k+tYUtk03N1
 9kqqB+DEwtAV3xjH302BOj0Dd9OoHeX5zQzNHy7LEdlCbubi1gYeMk9PzEMfdQ+Ftbh8YU
 zxbBo1qFWly9lag/rwXrs2d6rAbdqnasVopYdmKEk9RZRN6whQuYlM1EgJjsdDEOltyNRR
 u/Fd1jA1FFRdlwcnz8gm6GEmvaf9iKsXIDeL3ZndzramxVK1idxj9FtYOvIR3A==
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 0/3] mm/mempolicy: add per-cgroup weighted interleave controls
Message-Id: <20261103122816.48037-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
Date: Tue,  3 Nov 2026 20:28:13 +0800
X-Lms-Return-Path: <lba+26ae9d386+db8004+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E213A14000A
X-Stat-Signature: xb36qaiyo3bombr3ib3rxxoosyejy7y8
X-Rspam-User: 
X-HE-Tag: 1793708940-763768
X-HE-Meta: U2FsdGVkX19x2g3mnPTeefjUrQ7oGkTpaBfW250E52xeyqOMQqdUCadAs+8DqPTbOS5GY+JYGnuz0khoeuSSdIEDDiwcp2eL8gb8Aywli67awKbQ7XcFTc3j9ADgG7TKTyTkSHjG0qRY4IghuhrrarYPSdMGMNIwSY98Q1Iuvd/X2JYIC6uSIVIS94J1vWih1UJx2ATjL8Rr8joe1x9KA6kB5qC3EV2rt/ugbnTtop5b/hmdSxgAS64TqI3oOa1BZ/b6MZ+isbHueHIYmh0ZxSYo+cKUXdsrEOA1XjaDOoI3oCGKfleHX6stZ7qQRN3H46m0XVsPYb1QEIHdlcpcrya4Ck7kTYDnkhKPDjtwI8f//18QuAnQelrIwvDGBWenBRWxDsFO9RZUtzKewoTKrFTZ55bYsEn7XHaaQvyUmpanyyH7z7zajnweYRVG5R91mpBc+zg0ugkOhXRdJLJGaqLFmfUuq4K07OQBHayVeCy6R6n1Majro6E3pvYjnroO5ZrM2uFT7+X+gTdQBB1yaWtZ7rE5zKzFni3j5WDg+dthDZA29+NbFl/GtozJhEJl94p57bDk5l+tuMJtJo3rHX7vbru38D5IrbT7g/gyG0oQK0wawOuS4zziCPCnoGzhRQcZ3NGtqkPg7Kv7DqCFNwMHJL/IlmW6hmYmUAQaGbAKI0vwey+LqNvYBqZemo2CR8Im9eVF2gj7B+KPeeKo+7a73OCbpwAiFi/ARodl95UiLK/R8ibJhsiYQ6xZ3wcN4cAVf41V0J1uzmilssyyLK58pEWjTYXmNG03yh3Lo1QmzSvQIPBexxaYTs+WfhjWQJb5B7CkBsmk+bzAcNTndIEdoHYmTCGa1sKYugoAUHOqqMUB0UZtz1UoQEmdIkEZdxPHsYLlsq8wv9H7x+UYLbszd+v9cWft2ql4ZjrBGT+/OJi9PO1isHYZBbzarwEwwkN5AxvX0N5zPkuNsIk
 LsKqE4oM
 Of/lUkbh+EUlnrcxY826kyVgfu9b3AJpEtluYY/qyCdS6Lhs7ucSSRTmoixA/8gJK7i3NQg6gh1aiGWJlJxGgNy436EutEQ+GrGLVFjFECWBGUM6YkcYmEThV0YOPMH3KtcTI+po0btUA3BjFsZpAxVwJmy2gE0uh/OBEkOUaXxGgedaLaR8TX9GkDMvZiDJRHEzPZdhlCX65g+O9mmusBiTu3wO77AhbGuAy+yn9xtIgmB9sJbK17u7wURgq3i9qG8R+KfsNVvPgoHTpgknMVsp/6PJKRN+o6BAW/GtDk0G8iZBzEfEzuaVwp1KI+bEnqdVkqbZfwikvhZhJ5VCpifEdazfnFnyH6l5z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MPOL_WEIGHTED_INTERLEAVE currently has one system-wide weight table,
configured through sysfs or auto-derived from node bandwidth. This series
adds an optional BPF control plane that lets privileged BPF syscall
programs install manual weighted-interleave overrides for individual
cgroups. The per-cgroup override is supported only for the default
cgroup-v2 hierarchy.

Different workloads may prefer different DRAM/CXL memory ratios depending
on latency and bandwidth sensitivity. Per-cgroup weights let an operator
tune co-located jobs independently while leaving the system-wide default
unchanged.

There is no new user-visible Kconfig option. The BPF control plane is
compiled behind a hidden derived CONFIG_BPF_WEIGHTED_INTERLEAVE symbol
when the required NUMA, cgroup, BPF syscall and BTF prerequisites are
present. The existing weighted-interleave mempolicy remains
unconditional, as it is today.

Each cgroup stores only an explicit weight override. Cgroups without
their own weights inherit the nearest ancestor override and otherwise
fall back to the system-wide weighted-interleave weights. No per-cgroup
weight table is allocated when a cgroup is created. The first BPF update
for a cgroup materializes a complete local weight table by copying the
currently effective parent or global weights. Nodes not named by that
first update become cgroup-local values and do not continue to track
ancestor changes. This keeps cgroup creation unchanged and keeps the
common no-override case behind a static key.

For simplicity, this series keeps the existing per-task
weighted-interleave cursor behavior. A task still caches the current
node and remaining dynamic weight quota. Weight changes and cgroup
migration are observed when that cached quota is refilled; the hot
allocation path does not revalidate a partially consumed quota on every
allocation.

Readers use the same lifetime model as the upstream weighted-interleave
table. Normal allocation paths select the effective table under RCU.
The bulk allocation path may sleep in the page allocator, so it first
enters wi_srcu, briefly uses RCU to choose the current task/cgroup
effective table, and then keeps wi_srcu held while walking the table
through bulk allocation. Replaced cgroup and global tables are retired
with wi_state_retire(), preserving both the SRCU sleeping-reader and RCU
non-sleeping-reader grace periods used by the upstream code.

This patchset provides three BPF kfuncs: bpf_wi_set_weight() creates or
updates a cgroup weight override, bpf_wi_clear_weights() removes it, and
bpf_wi_get_weight() returns the effective weight. All three kfuncs
require host CAP_SYS_ADMIN.

The cgid argument must name a cgroup from the default cgroup-v2
hierarchy. Overrides are cgroup kernel state: they persist after the BPF
program that installed them exits and are removed by
bpf_wi_clear_weights() or by cgroup deletion.

The existing sysfs interface remains global. It still shows and updates
only the system-wide weighted-interleave state; cgroup overrides affect
new allocations by tasks in the target cgroup and descendants that do
not have a nearer override.

Li Zhe (3):
  mm/mempolicy: factor weighted interleave state helpers
  mm/mempolicy: add cgroup weighted interleave plumbing
  mm/mempolicy: add BPF kfuncs for cgroup interleave weights

 include/linux/cgroup-defs.h |   5 +
 include/linux/mempolicy.h   |  10 +
 kernel/cgroup/cgroup.c      |   2 +
 mm/Kconfig                  |   6 +
 mm/mempolicy.c              | 357 ++++++++++++++++++++++++++++++++----
 5 files changed, 348 insertions(+), 32 deletions(-)

-- 
2.20.1

