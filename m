Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E83C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425C36B0088; Fri,  4 Sep 2026 06:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF8D6B008A; Fri,  4 Sep 2026 06:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DC16B008C; Fri,  4 Sep 2026 06:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F26CD6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:20:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F58D1C2417
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:20:38 +0000 (UTC)
X-FDA: 85175685756.25.BCEA4A2
Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B321180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:20:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6m8bt1M;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788517236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VmKtoarFq095xrJl3ywB6aowSPaPuJr+wDN5St5nkks=;
	b=K9P4HoPhCpL5vEYamdp6EsYICEcsdkRfWFVoeomrYNHet8XF6jsRURomyShANaJneXSMgn
	xfJH2AYHpudwJ8EkKqCbHeeKeZ/WnPgk136PgOLddo5wohdhh/v17o9zn1QohGZpKx3/06
	QUPSSk4ebywzjsZrTMOu31T2uJQaxHk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6m8bt1M;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788517236;
	b=FgBDIb6dcfz5fqobthszJcMNgpYBr7ZgYLlolmjUI+iHyd875EAk1rJVOjH3ZZ2JMJS9NZ
	ruJeToTXJl0s5cecx2f+F2AvqtO7EpdJ5S1xs6hbPlSrxhyABNeic3dSq6wInUAfxn7bD3
	yPk/XoxB2PWAHdHqLX645s8kMgV5Yj8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=43TVaLHf6OIa63sQqdqvN+cq03QzW6qfIs/41gwJ5NQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788517235; v=1; x=1789122035;
 b=Y6m8bt1MwY7QDiFurogWejaOwrHN6SRi1Z6CR/YkunpAHr8iWYcRsU2zQDUEz6ypDwgn8kZ1
 pHdR46PrCoEHNpunDvhhyuqIikKISOc4jNZG2RENLCqSzC0o92SzqNrPvQi+tnLFGB8w1KUbd+n
 q4kfwSba/bWrGN8buFnIzaOE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b99d8607389d611d;
	Fri, 04 Sep 2026 10:20:32 +0000
X-Mizu-Trace-ID: b99d8607389d611d
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v7 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Fri,  4 Sep 2026 18:20:18 +0800
Message-ID: <cover.1788516769.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f1efdz7x5bgeji3uzdkabb417ihhau4h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B321180003
X-Rspam-User: 
X-HE-Tag: 1788517236-428449
X-HE-Meta: U2FsdGVkX1+aoF333q/70uKWC9bmxabioEQIeVceOtut9dtvC7Og6u+zEBfG4m0DqoJz6ndTU3qK1zkdoVoKYBTFNAT27XvlqFvI+y/dDAZz8Q6e38Kf4rzHmeTd6a0LCCCMbdMRWu5mb8X66EnNOFJsHyu31UhN4izuzDNUirlfeiKGLPpE7TSzYW/M5sIhSqtoovzNG/k6U+w0lSlclTvpKMH+hDpBXx4ubBjS1eWj+Hwiqmd5AJWr+KXuo4hWgPrW71JfaFew2LUQ/pb23yhpH3IVsLbZHdhoF4SC/MaUWr8FGoBKx664maMpkuKG9wb5DcIwda3WDfFcqbS+D9PxzjzHjTMD4pNMV9SK/2kM4Huqwyi7uESdRvBhPyAXwhhR1fcnJMlsQMB2anKBMvoG/yEtOLtsQzAL0OhVKYc+o2r/dMy+cAjquomRin0j5e9Aeiqw+ma/18lT9w2Z2qwtJJoKJkxXxMmRRNByOdyydCR8byjY3trtpUoQn06JPiIg4zbtxaAUHCIYoACBAjSPpDYEQ1s43qR3vYmzSKeUW5wfjgAaioV0CCSJbDAyktDD/brSsdYvlG0ZS6xg1W5Vyewn877CrIuG1nl00gzvunzO6Z5/rqgwU6kNDZFrOj3F7/3IPAsujDgHlbLCHRL9yZ5rKIZ6lQa2+nvygtXRcKL1qXr8EzTCgFXpwlGlAS/TQDzj9XwAw6eYys2B5GPSJOgUHZlyjAMkXFeUyqeplhPHyEbp5M2a+zhlmjt6vGtCk6uOxx1s7lp0Isr4gcSIGahNuarFQha2UPsb4+Xn67BCuWNC3JmcOomWFd+4lLdzJJdl+SNO/rb10/i5Y0cmBHteuxQn4E9CamjbI/mUmCm02QjLGGPZ6PZQKWgvoRAocAJLQNN5+blQA/z+LqAxlJkWirR4EqSa81+StP0AjrdkmKLD4y3QQQPLPGTRvzxtK+B7zs0KFrzmIlM
 zohByJcF
 EIpXWpYIIFvNlfsnPcL6zRcH+g3y9QirHhNFLItjCjmmXV8LJetBzsOiJzwGViR2xu9qKqkMJmI3v3eF3MgU1Olg4tFdOJK6j+Cd6Hke+4MsBml9QaTlmwaON4tGiZw/eG4BIxNayemxGz5pzQa1f+NxfrKRfIIUTyk9UpHP1ibFTzcDGF6/xj1Jh8jRlJcfDSm61
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup (e.g. refault
stats via bpf_mem_cgroup_page_state()), but cannot act on it:
triggering reclaim on a chosen cgroup requires writing to
memory.reclaim, which BPF cannot do. This series adds
bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
reclaim pass on a target memcg, so when and how hard to reclaim is
BPF policy rather than hard-coded thresholds.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context: generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. The
bpf_wq and task_work callbacks of a SYSCALL program keep its program
type and run in process context, so reclaim work can still be queued
asynchronously through them, as the selftest does with bpf_wq.

The use case we are looking at is protecting high-priority workloads:
a BPF program monitors the state of a high-priority cgroup and, when
it degrades (e.g. PSI rises or refaults increase, as in the
selftest), asynchronously reclaims memory from low-priority cgroups
via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
more free pages.

Another use case: several vendor-maintained kernels carry private
implementations that trigger asynchronous reclaim when a memcg enters
a certain state. These exist for historical and partly psychological
reasons, but the underlying demand is real. We expect BPF-driven
proactive reclaim, combined with the BPF hooks for the memory
controller currently under discussion and development, to serve these
needs in mainline, reducing kernel fragmentation and improving kernel
maintainability.

Changelog:
v7:
According to the comments of JP, clamp the reclaim target of one
bpf_proactive_reclaim() call to MEMCG_CHARGE_BATCH so each call is
a bounded unit of work, and document the batching policy in the kfunc.
selftest: check the target cgroup for dying state before reclaiming
from it, and add the memcg_async_reclaim_dying test covering target
removal while reclaim is running.
v6:
According to the comments of Kumar and Shakeel, Restrict
bpf_proactive_reclaim() to BPF_PROG_TYPE_SYSCALL by moving it
to a dedicated kfunc set registered for that program type only, and
document the clean-process-context requirement in its kerneldoc.
v5:
According to the comments of Andrii, Kumar and Shakeel, remove
bpf_proactive_reclaim_swappiness.
v4:
According to the comments of bot+bpf-ci and sashiko, also check
current->reclaim_state to close the fentry-on-trace-iter recursion
window in bpf_in_reclaim_context.
Return bytes instead of pages ( nr * PAGE_SIZE ) in
bpf_proactive_reclaim_pages and bpf_proactive_reclaim_swappiness.
Return (unsigned long)-1 on out-of-range swappiness (was 0).
Kdoc of both kfuncs: updated Return descriptions; added FS-lock deadlock
warning to bpf_proactive_reclaim.
Fix potential child process leak in selftests.
Use _exit() instead of exit() in forked children in selftests.
Rename reclaimed_pages to reclaimed_bytes in selftests.
Fix comments issues in selftests.
v3:
According to the comments of bot+bpf-ci, add a shared helper
bpf_proactive_reclaim_pages() that is called by bpf_proactive_reclaim
and bpf_proactive_reclaim_swappiness.
According to the comments of sashiko and bot+bpf-ci, fix the issues of
selftests.
v2:
According to the comments of Shakeel Butt, replace
bpf_try_to_free_mem_cgroup_pages() with
bpf_proactive_reclaim(memcg, size) and
bpf_proactive_reclaim_swappiness(memcg, size, swappiness).
According to the comments of Kumar Kartikeya Dwivedi, drop patch 2
and patch 3.
Remove bpf_thread_wq code in patch 4.
According to the comments of sashiko-bot, fix the issues of selftests.

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  95 ++-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 686 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 259 +++++++
 3 files changed, 1038 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


