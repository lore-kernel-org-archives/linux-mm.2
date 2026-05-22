Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E173CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5BED6B0093; Thu, 21 May 2026 22:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32436B0095; Thu, 21 May 2026 22:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B480F6B0096; Thu, 21 May 2026 22:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF596B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:52:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E30F8E751
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:52:46 +0000 (UTC)
X-FDA: 84793533132.23.A30802E
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id A8DF580009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:52:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418364; a=rsa-sha256;
	cv=none;
	b=uh/j9i/TcqmrT/nqXKERBOymr1D0QFsQa7cj7xlAWFZdhWabSDWwY9hXOaBxEVnMrdp5pk
	xgOZbIdnVmo5SUmDm+uWNN7yYzcr9qaFJEhQcqUuhW6M5QloNeksJ6saimQ/71dFFeMir5
	N5CBUuNi4avOy++8kpNFMg8IPbENL3Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=V/LKnnnTFKNAu+0rMtH4ebcRYZ+S+1GWLEfvZ+z6M7w=;
	b=YRo9XInYr2dDIe/MUeYBw8wqTw5P7+iP1ArtHjZtVLUsvoLOQHLVUbHdQ2hCj1YLZCL15y
	DlpTov192jLbQ9CDoghRZ1WLBa0CtFS8rSOnYNadU8SWsrKIxizcXBRAw/zQ0ZOffRtbtO
	95BCXr4rAPofEol7eIyxa0lhuCV3Aw8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gM8vp4BJ0z51Srn;
	Fri, 22 May 2026 10:52:38 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64M2qX2k015152;
	Fri, 22 May 2026 10:52:33 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 10:52:34 +0800 (CST)
X-Zmail-TransId: 2afb6a0fc4f25bd-02b3d
X-Mailer: Zmail v1.0
Message-ID: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
Date: Fri, 22 May 2026 10:52:34 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDAvNl0gS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64M2qX2k015152
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 22 May 2026 10:52:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC4F6.001/4gM8vp4BJ0z51Srn
X-Rspam-User: 
X-Rspamd-Queue-Id: A8DF580009
X-Rspamd-Server: rspam03
X-Stat-Signature: d4ncauspze3649e3kj6k4d4boxejk596
X-HE-Tag: 1779418363-892653
X-HE-Meta: U2FsdGVkX1/DhxIfiE60Mu6xJOW+prJoUcM85Bugt8wIgysolsj26HA3GcaYGjag/Aki3P8nqCNsKLAWrTLl2V6PQdJ0g+az3pOUOvLEjAexEaOlGw2HW9HrVbm1TCoBP3o5l1ad17yIE+pgnDZzKqRIC3xc6WtzNstEp2H0HDG3PsEFSCtv/alCpPovYKPasf4OSVC4Z/gZdXKTVKkHkOWkQ5+oo4D2Z5mZTozNZLFHXf72bcmmqUlnNX7fBP83uhZeOvj+7sea35lohIGvRM308wdDk7RPW+nf0dwab/9mPf3WgrPpz7Q7C+v7PmCPa/AY5KZHngKN0RRL0ZU86KJ4SsePSL5ZVZwLNc7D7gr7gmK5aUjiRWGVwz8gpekam/PTj142llzftsWLg5375oBsMPiwTm4ysfCnsgp9FU+7FPphHyAaeiJrRl1W6/e1j5kC+K9rovpt0Rw9iOOJ3WJNJ5PNQAbg+sOPCS8jS3GkaaRMqlqOcKNJ5Ccx/n27l37ReNG1Ex0UnEzq2la/SKVjzzL+IfKOM0OOmQa552SAMC+MY/mE4+vzhiI7iSlsISda6YTba44T+J9Z4VzZRE3Kc+ZaEjkP2Dk9eJ0IrZqu7iAyZmXIt+BkDYgoirJnDR96idP8bI+dy75VRApZiKIv568dELdaU+qU1HfSd3udH3i/crdIW4XNoDOJ5Wmay5m1hkjJM7HZurJMX2SQQxgip8hhYfGRBwda/UsfoitmyonSW2eSmhypRTft7aAk2ewoIGgWqtAp3DgU+l1JgtkGprFYLOe50Pk/z48GBTW1dfF86ow4hmsWwUT++Y/MAjCEYq1biIA6DwmGnjMd144NYZsBiEhzxOKgxaQH4K8AUpb1Qphmp1vr/3YVeZT3AcQNIXlVgct1dFrQrTAix6mwydwYQp8hubuAIpHxyqXZLgrlV9Wgx938nyymWEg6+TSmfPYEav98nki73KP
 R6Qr3Zrn
 1oQ8xKjm8zHcKjU9lTVk8LsmScw7c/Ld5UKFFP/fA96S0+Af8BW/C8EfshZTzgHhu3HEMTlY07myplHrCKnIp939+rVpK9v/ScHM00QsYzoqQJZpQ7YaRJDJgo+tnzAhIIjEy5mwyuLBFuFW+U1SPf96OeDxVkIhtQ+MZWHScjC3GOVN+ofZIiBg85soPyF6VmfZYgZjNQEbXdeCRzYV34nd4HPd+5RwWFhFLp6cJ7OJNY4zNP90fqsB29IZ+FDuyXNFhKx+Cae4AExwDo+kMS7Q0Cffb6i5tkK9obeBX1SoNlKqi6xXXLn6TXuhSRBuNl5ytqsmFRt8W/K0bL0Q6CEN5GBixipc1Geas7yYnUytLI+CZRQmUMRIGdnwenCV2J1YFosNORdEuM3Q=
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

---
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


xu xin (6):
  mm/rmap: add tracepoint for rmap_walk
  tools/testing: add rmap walk latency benchmark for KSM, anonymous and
    file pages
  MAINTAINERS: add myself as reviewer for rmap section
  ksm: add pgoff into ksm_rmap_item
  ksm: Optimize rmap_walk_ksm by passing a suitable address range
  ksm: add mremap selftests for ksm_rmap_walk

 MAINTAINERS                          |   3 +
 include/trace/events/rmap.h          |  67 ++++
 mm/ksm.c                             |  48 ++-
 mm/rmap.c                            |   9 +
 tools/testing/rmap/Makefile          |  11 +
 tools/testing/rmap/rmap_benchmark.c  | 461 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/rmap.c    |  76 +++++
 tools/testing/selftests/mm/vm_util.c |  38 +++
 tools/testing/selftests/mm/vm_util.h |   2 +
 9 files changed, 707 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/events/rmap.h
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

-- 
2.25.1

