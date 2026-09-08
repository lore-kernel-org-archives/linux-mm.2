Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4684DC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF166B009F; Tue,  8 Sep 2026 05:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6AF6B00A0; Tue,  8 Sep 2026 05:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCB66B00A1; Tue,  8 Sep 2026 05:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB066B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:11:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B061DA04BF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:50 +0000 (UTC)
X-FDA: 85190027580.13.DFA3A40
Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E43F4000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o/OsFgMD";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h/vplBOxnFGdveu12rD3sXuHavadwRb36C7/bmJwSLg=;
	b=G5jyxfUKKXU2uxzY8uCDIG4CUjS44gZlAIvFamoEp2CRWysdH4Cgqda+t0ugDzcT4d0hDa
	7ZE7G2BlBTA/bVGc7p/CH7ZlcPfYPEepxM+bsUQwcJNDxhD23BJXmjLbFq0n4lxu4+Y3VG
	44GcdrwgtgAP8EAPkNtpwRjOnXoFWY0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858709;
	b=FqPtJU37qVeXJQoWiEJEw0ba8dJGdToXjflRMsuMoTQ+U5UNs3m6C9wdMbxslOHZGYW2tX
	Frx8MQ3bF0aNHWMZ0BhSVwBJ9+uKnpjQPY11aKZ8+LVAhGK0FJasqjj8ogrvYaLhdPGawH
	aha97tK81cF2xQz69vOO4lo0FP1j8W4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o/OsFgMD";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.113 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6VmEDsVAvJfO/ndzZMXcVM2LXI2zLrkuWTXR1AO7Mos=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788858705; v=1; x=1789463505;
 b=o/OsFgMD/O1bayRQI8oxCjqnwesm8mhG7IbQxPmubhZdQCWn5FytYnHxyBMB1yhB1qL9ZVjJ
 zrZd2KjKlbYjW51TJlvoFQycyVVkqmIlttgpxOWrp/6FkOWfoPWzv7yaujtlOHeMPo49Tsc1rce
 L9bXMQWfw1fs5L6ecL3okDYA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d929543bb24a8c1b;
	Tue, 08 Sep 2026 09:11:45 +0000
X-Mizu-Trace-ID: d929543bb24a8c1b
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
Subject: [PATCH bpf-next v9 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Tue,  8 Sep 2026 17:11:26 +0800
Message-ID: <cover.1788857915.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rnqhgeomza1dmufi3jwrw9z43aqy1p5b
X-Rspamd-Queue-Id: 2E43F4000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788858706-461693
X-HE-Meta: U2FsdGVkX1+b9YC6FfPcJ4ZDZWottkXcpG128dMF71YOapnPiB70ae1UJjSbRKGyRMAz9qKU1YqkQSUyyOVOqius+LeXymgz7jR4QM4d+G6yVKGPcusvmRNuBaki6AfPxTHajvAcNzUXXuyvaVfIqukCJ4hUdT6idzlGULnlbK6ZN4+QH13PhxhVTCP2UsO+WU9ThxKu2kGAcgIi/0M5vSF4MD4eWsGYbqzI/laBHwdF03RezfkiUy88tv11+RD5KO8cDiHyGq7fUBrutws1W/Ylg8NbEmM+XQCXF1TmNt2S1hXSklO9vy8U9B9KJmLexl5lRkkyh6uHnHR8/Te/fk6Zb2f5ymZDh0mp1LXSA/QLKSIJXyTLd2a43h7rcu5Fr3y4UdrS047UFXyLEGPF8n9YboazH8MTDQ39QmUvWQp8463ZIHC5Pcdf/ZESPvFR12cyxbleGC3fqao3i4oOyONp0t4vMiHR1ZeRQCcVoyme+SaSnZVo/O/A4MahnIRaEh/XeIPcnDetDxt9jiVn8SARzD+kaI39gFG7rHRlZXSS0qaEEZDZ3b4bUgX+x09S/DEcJ+uA1lqU6m1Y76GGPNwZRUNNnux2PjR3vAR4+vu8WFOLa1h/B/xcD7IWr+eln85lp1/UGwqVqgQfEL0wu405WF8dubjfdyhzpp8XZ69nqYAqlRLiNfNxZ7uX6iznnr5iouvmbp5JqLUm0zUzplgwTuVoj4ut1N86ebtJriE8kJBJsYvTwMq2DZxHB6YiZe87MHHBNfd3w1TMKnzDRMB3O9ZMIJAPAXCrrjayeqHVDYLn1i0G2rDE6OEWnhkluuO+1grAcGYB36b3u9oekybQTx5v15Y9VjrtRyMnnm7hqmr8h3AmVU7QGTwVZ0Eq0r53+4IVAb5DT9EviHjgRG0vl939nvqXalF3SCdSNCJdtk5/zAIet26LjJ6cKfQAYxCOaYYBUkNI7nZBoLP
 UsQAr6Oe
 sdYTJoXIVQVf/kRyr3yrSohxvQg9p6sHkiZIZbAMtnGf1pf+Ba26Qt6nRAYQXpsPDdEOplm52qGS7NPTzYAGx0qRr/VK8eMVchwo1VrzTtKpqg9O2Enzi3N70zw1VOQAYtdfMrhsWUXD/sglL1SZArqNY/H+QIxfbjacMcKYnvaHPVjbKsHZuIXb7lCHnY/9fDvaY
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
v9:
According to the comments of JP, copy the motivation from the cover
letter to the commit message, restructure the kfunc documentation
to separate the direct and asynchronous calling contexts, fold the
fs-lock warning into the SYSCALL-only rationale, soften the "bounded
unit of work" wording (only the reclaim target is capped), and drop
the redundant comment above the reclaim kfunc set registration.
v8:
According to the comments of Andrew, Kumar and Shakeel, drop the
bpf_in_reclaim_context() check because the SYSCALL-only restriction
already rules out reentrancy.
According to the comments of Kumar, Add the swappiness argument to
bpf_proactive_reclaim().
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

 mm/bpf_memcontrol.c                           |  88 ++-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 686 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 259 +++++++
 3 files changed, 1032 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.43.0


