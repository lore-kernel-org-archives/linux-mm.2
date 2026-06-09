Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5395ECD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47F066B0005; Tue,  9 Jun 2026 00:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4569B6B0088; Tue,  9 Jun 2026 00:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3934F6B008A; Tue,  9 Jun 2026 00:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 286A06B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:39:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1FD08DCFD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:39:41 +0000 (UTC)
X-FDA: 84859120962.01.1153186
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCB8C40002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:39:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780979979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=qLFsiwUGn9Ehn/0e2w5EV/2Wa4qPIqqSTMyEXl1IZpc=;
	b=jaSOUo3Rba4Mki/McPdAG7ZhMwp6lreIIN6t089H28l8+wu98trzO8pPGVDg81oSlQ+sKD
	dvK+ef6FsSNvpS3DW3q/2xrPw6Ws2CHSoRc12xn9WTZpR6LqtmNbmv6mvtF3K0LFaNwD7B
	SahQDvP4qqNZ4Ck8ZeZR3vQ2l07+N+4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780979979;
	b=CTt65T0KEkPOQRLM63d2BHogZjoOo9fGZK6hogGSdHplxDzIFU/vYl5Fi6SOe2GLh6FzZ5
	WpTYve+4BurqSxkAfK3vkS2qGvlGIbMjI0Mr4sJdJzFrxD/p8jA8QudqVR4jV+gDNmLCEX
	H5D/URgARDihqvNQOvh6T0FKOF8xgGY=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gZGQv5bRPz5BNRf;
	Tue, 09 Jun 2026 12:39:35 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6594dTb9032774;
	Tue, 9 Jun 2026 12:39:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 12:39:31 +0800 (CST)
X-Zmail-TransId: 2afa6a279903aee-0a940
X-Mailer: Zmail v1.0
Message-ID: <20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn>
Date: Tue, 9 Jun 2026 12:39:31 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY4IDAvM10gS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6594dTb9032774
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 09 Jun 2026 12:39:35 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A279907.000/4gZGQv5bRPz5BNRf
X-Rspamd-Queue-Id: DCB8C40002
X-Stat-Signature: o4a3rubf3ihpxt1k5mfg4kco8nb35dqo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780979978-876365
X-HE-Meta: U2FsdGVkX1/ylTRCbmZzcY/MlAXjy9AN6FW3Kurv1cAO1H4rAigXFHRxDKpXOSMd4dkq8f8dpzdw6O6qHzUK5cHNMLWHitXL/Xwwl5O3iyd8gi4+gmkhy7zQk45MHnFBol2Unng3bBFmttuILODhHFbvxdswTtzBS/cD7fByshi0JEeOz1rjWh4LsvjPXCm+US21naeVbfqCv1hSz8RoQch8ddCpRhaxCEOrocIrsUnSuidh419wMd7SMWf3AXtDzkIoJk6A4qg/IITvhj6IUD3+8cPWLqlxp/sqDeXvEWzkUh4zKv7tagahn9JDr4y/Ug4K6yuKzYGYbMBdbDa1Z6WbhdcrspwccSj4Kp1f1gioINQ/iI63chmo1h/kgH0PM3/dTiU8eNH7al69OZz1fFxqjkS+FMh/BRG17ITbNpGQ13bqtgo+fgAuvj0ak5iyB8pl4cn88gte3DizN8oJRpvEgYbkCr0DWuu7vq2u9yngdhpa3XIzcKTye+bLWvZK5foeAqSDrOa+NABFJN5fRVlNbC293CDt4qb6wxanZNuO2qo+wVCXOjUeV9dAy6wJhnOEhNjRP8h9TMW/vdnWBOP0/x6VgvGc9Kx8YLPdI6DwkfFHJ4LBlbbrSWKLM2JToHYq1/ogeU9895XLlDonZF1ogJAiQJHD8o31HHdqfoTcjwtE0IsJiOdxwqJQJESjP+7SnowfkXUD2zJ6b5YRwO7DEbjRhVCprhud7KHMU9m/7dngJlVJwxAppKHY7mslAFwnKD3teF/yesanxr3kuw9HhFzG4wQ35eI8m++ktIPYDxpxp1AqAR/NJ1D+VrlPQ1gYPk5zZLMkjxEtKSeh1HKtqNJFvQLx+J0utdI1XmYSqe7yPg5c0XHpnghwJQpOctYMIOpxAfGz+9EoNODEyCGojP03CvDv2FTiDBWnt7d1FoUbJ8F3RYDDsgSaLCmFXhWHr82LRP31JC9Z97i
 gsR2E7sb
 mV9OzBikqQ6B0tArFyKEf0SwVc3KKRVWbJmbcBF4i3E0SAp7PbQ93P9B37kcX5vSbuEypOidKxLMA7RsfCJ+asGmug+hJ36JIlXswOM+apTLro4isN51NU3ZFvPBVLqbel37G1gWghODlKXvfoXv7Ug2rgvG9UJQcv0n85uOWsbRIvpaSWxFFn6KOaJEYOhlG2wJDVUf1rrV8p6Qcs9RaQWcmJKt4EbKgQ1c4aiOBfMAqSRBzGUg1LH9EZpwLqd8Jvu5c0mvfGLIYWtFXSAmDBPntSqZTNzJvBAbbfsYlJbDAbBquGugip+Nj+7+jdgMa0pHKtrJBFkdZeQKRh2IxOp1nbak29UU8xWttlk9/l8O14Qt88O9YE6cEQQvuoz+xjgylBCrLwjCw9qE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

This series fixes a severe KSM reverse-mapping performance problem
that can freeze applications for hundreds of milliseconds under
memory pressure especially when a lot of unrelated VMAs sharing a
single anon_vma.

Two key highlights:

1. Lock hold time drops from >500ms to <2ms
   - In our benchmark (20,000 VMAs sharing an anon_vma), worst-case
     anon_vma lock hold time during KSM rmap walk went from 705ms
     down to 1.67ms (max) and 1.44ms (avg).

2. Real user impact
   - The anon_vma lock is also acquired by page faults, reclaim,
     migration, compaction, mlock, exit_mmap, and cgroup accounting.

   - A long hold due to inefficient rmap walks stalls application
     threads, causing latency spikes, reduced throughput, or even
     container timeouts.

   - The problem occurs even without fork() – VMA splitting (e.g.,
     via mprotect or madvise over time) can create tens of thousands
     of VMAs all attached to the same anon_vma.

Real-world examples:

 - JVM / Go runtime: These use mmap for heap regions and later call
mprotect(PROT_NONE) for garbage collection barriers or guard pages,
splitting the original VMA into thousands of small pieces over time.

 - Database engines (MySQL, PostgreSQL): Large shared memory buffers
or anonymous mappings are managed with madvise(MADV_DONTNEED) to release
specific pages, which also splits VMAs.

* Why the benchmark numbers are realistic: We observed ~20,000 VMAs sharing
one anon_vma on a production system running a Java application with KSM
enabled. The lock hold time before the patch was measured at 228 ms (max)
during rmap walks triggered by memory compaction and page migration.
The benchmark reproduces that VMA count and lock‑hold behavior in a
controlled environment.

For systems that do not have thousands of VMAs per anon_vma, the
patch adds negligible overhead (a single pgoff comparison). For systems
that do suffer from this issue, the improvement is dramatic:
1) Worst‑case anon_vma lock hold time drops from hundreds of milliseconds
to under 2 ms.2)This directly reduces blocking of parallel operations that
need the same lock – page faults, reclaim, migration, compaction, mlock, and
exit_mmap.

End‑users will see lower tail latency (fewer application stalls),
higher throughput under memory pressure, and no more spurious
lockup warnings or container timeouts caused by excessive lock hold
times.

In short: workloads that do not hit this pathological pattern are
unaffected; those that do will see a 100x to 500x reduction in lock
hold times, which translates directly into a more responsive system.

Change Log
==========
Changes in v8:
1. Suggested by David:

  * Drop the tracepoint and testbench patches and leave them as OOT patches.

  * Rename pgoff into linear_page_index and update the corresponding commit
  desciption.

2. Fix AI's issue: Use process-self's KSM counter instead of global KSM counters.
https://sashiko.dev/#/patchset/20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn


Changes in v7:
Mainly to fix some issues AI review points out at:
https://sashiko.dev/#/patchset/20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn

We have completely correct those possible flaws according to AI useful suggestions.
- Patch 2: There are mainly 3 changes as follows.
	(1) Use COMM-PID filtering during trace parsing to precisely match the right
	    events.
	(2) Graceful handling of single‑NUMA node. trigger_rmap_walk() no longer calls
	    exit(1) when no other NUMA node is available. It returns an error, allowing
	         the caller to clean up (disable tracepoints, restore KSM config) before exiting.
	(3) Fair comparison for anonymous / file tests with KSM. anonymous and file‑backed tests now
	    use fork() to create thousands of child processes, each sharing the same physical
	    page via copy‑on‑write (or MAP_SHARED). This ensures that for all three page types
	    the latency measurement is based on a single physical page mapped by many VMAs (≈ NR_SHARERS).

- Patch 6: There are mainly 3 changes as follows.
	(1) Fix mapping size tracking after mremap and protect the original pointer on failure.
	(2) Use baseline delta comparison to eliminate interference from global KSM counters.
	(3) Fix error-code confusion caused by pread/close interactions.



Changes in v6:
- Patch 1: Defining a single event class once and instantiating the individual
	   tracepoints with DEFINE_EVENT, as AI said:
	https://sashiko.dev/#/patchset/20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn

- Patch 2: Suggested-by AI below, three useful changes are done:
	(1) Safe event pairing – Now stores folio and rwc addresses for rmap_walk_start
	    and matches with the same addresses in rmap_walk_end, eliminating
	    cross‑thread interference.

	(2 )KSM configuration preservation – Saves original KSM settings and restores
	    them after the KSM test, avoiding persistent changes to system behaviour.

	(3) unlink in advance to prevent potentialfile leak – unlink(filename) called
	    immediately after mkstemp, so the temporary file is automatically removed
	    even if the program crashes early.

 - Patch 3: a separate, standalone patch to update the MAINTAINERS file.

Changes in v5:
- Patch 1: replaced local_clock() with tracepoints – no overhead
           when tracepoints are disabled.
- Patch 3: switched from vm_pgoff (unstable after VMA split) to a
           linear page offset.
- Patch 4: adapted to the linear page offset; added user-impact
           description (real workloads, lock contention examples,
           VMA splitting scenario).
- Patch 5: simplified to a single process with 32 pages (instead
           of multi-process), as suggested by David.

Changes in v4:
 - Add a tracepoint for rmap_walk
 - Provide a testbench for rmap_walk
 - Add vm_pgoff field in ksm_rmap_item
 - use vm_pgoff instead of address >> PAGE_SHIFT (Suggested by David and Lorenzo)

Changes in v3:
- Fix some typos in commit description
- Replace "pgoff_start" and 'pgoff_end' by 'pgoff'.

Changes in v2:
- Use const variable to initialize 'addr'  "pgoff_start" and 'pgoff_end'
- Let pgoff_end = pgoff_start, since KSM folios are always order-0 (Suggested by David)

xu xin (3):
  ksm: add linear_page_index into ksm_rmap_item
  ksm: Optimize rmap_walk_ksm by passing a suitable page index
  ksm: add mremap selftests for ksm_rmap_walk

 mm/ksm.c                          | 56 +++++++++++++++++---
 tools/testing/selftests/mm/rmap.c | 86 +++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 8 deletions(-)

-- 
2.25.1

