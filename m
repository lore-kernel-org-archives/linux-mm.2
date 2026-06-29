Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8D7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A406B0092; Mon, 29 Jun 2026 05:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DFD6B0093; Mon, 29 Jun 2026 05:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25DD6B0095; Mon, 29 Jun 2026 05:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 850B66B0092
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:41:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17566C30BD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:41:22 +0000 (UTC)
X-FDA: 84932457204.22.4ED4AD3
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf17.hostedemail.com (Postfix) with ESMTP id 313F140003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:41:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782726079;
	b=pQT34R9vbztOyw1pMQXiS0sm+LZBbSrO/lE7EJUvsZwxBXuARen1m9IOSgLh+FzZI7OXXt
	Xa4OGS+DKhEkSZHMjhTE2Km8LGjg/v/to2iDec4+/n/ukdhqXTNJynytazGNzYwqr7xFOM
	NeeYymRPlP5ixIWPYKqpdN1K4xS+sE0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=VuQOyO8nGubLqvdhDctn43qAMFhY++yleYKs78QQoxI=;
	b=XM2Jv5ATuxuCChvO0wNY5VhdCsWBQK+FlDDxCQSQtfQwl2vFaM9lazjAgkdNW8H2YTmF0N
	nb4Q3BhvEkGFFtKsSIPCqSmz8Wltcu3RUDJ3X1mFGrWni4Qfjzrk1MHnxuIVX39fDM4ni3
	lReRY9dAhwuBZmFJ+sJua/25/2lTSr4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gph9h1RFGz5B1B0;
	Mon, 29 Jun 2026 17:41:12 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 65T9f9JH070836;
	Mon, 29 Jun 2026 17:41:09 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 17:41:11 +0800 (CST)
X-Zmail-TransId: 2afc6a423db7dd0-e44f4
X-Mailer: Zmail v1.0
Message-ID: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
Date: Mon, 29 Jun 2026 17:41:11 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?S1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65T9f9JH070836
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 29 Jun 2026 17:41:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A423DB8.001/4gph9h1RFGz5B1B0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 313F140003
X-Rspam-User: 
X-Stat-Signature: fm7ceebfxrjerr871eptjizu17bqki3z
X-HE-Tag: 1782726079-693911
X-HE-Meta: U2FsdGVkX19t2WfmakzYkxYHV0YgbbdC6xC8AK6rIf111Of+vCNGNwP9uSUng1QEKGo2hlySzPn3/AC2GtDhfGbdBcwyFAttchEQShNAV2Vvk+j7nwtS2dnOqOLbjkm5FpnvaREjdzCFPA9NN1uvETgrJjqchzWsY2T3DrrIzxsqM3Nx2aLbXgzc8T6lB6DI7fFUa4guqvNqcJluEQAPvwS82MAAtjItLw/dZwzkAMUiU1xRYuum0YPrdMH3v+v8xz4WM7XVXI/t5p7IYHkDOgOWYRZhpkV5OQdOfS81VQCaUHlRNKbUPAvH3hYBRzDJW7+MHjH70Z2xidqeP1zLWu2szXEPsp2UimH70NgMDt1HRDcEz3hGiJ9z3cx6u+V+RO8i5uwUV+gqw/lvXzXk3MKD0Dy3XQVR/8elUo+r8LAUGvQ2x+RB+thpmcQY1t5F/QdB6SfUSX3Tz5GJUZ//BGuCCk/2RG0pyVSEp5jG31dRpUOCwFlEevvbWRPndwi4dgb8mRgd9kEeONj4p2R/3iWj1wHJ4Sr1Q9kC6mUEsLicx9lUmjcgxy7RZTH7XglNhU75rUHAC2+/excmDk4x0ZzimnJaHdeiuBUHNAC7aJhbDsRxZjn7F6iytRm5HNTgDZ2ltZc3jYS2PjOxarAXWIdm5w/qMw6wf7Oa69S4mz7snw0LUWBauLEEyIKacpL/F4jL3IZXYiUid4pSdaKRPPtxo8BgZ2e3vISMJGO6HydZ66S3RJ36zFc2WJYFLJSb1Fwp70vubMIt9VtkETFX/7YHMJeZD58SSDZQzq8bFlvb/7FZ4xMRYPHZqKrgxoGsui+4G0u/LPlMhzfmscSBdFBZZmN6oE4aaI8GlOnnkgRkilPreutwLr8EiDtJCtqDtEW/yWb0olC2pHiKXvacEgbcAQV246jK0pZ5vQuLC7lUF73qoTLWs1JrjBN/jpSbijafNZKL+/yzxDZqtPP
 ueXHHR7E
 AyO/3KhvbULymbQEGM274J782TSR1zES/IO4ZVsyVuUE71NRyxUuxWbWTknX44SfXW+ZKEwAlYEBt8j9/9EMk2udxu7Fzgk814gwoFd30Egq1ver9dexpaHOJOX+u4hsywVBo9NYw4ttSv/LhgyCtIV9+KtM5UPmfLdCMMrMbN5G15Jgef8lBgb2xxAAqPGfuVlkGcodaeQS+ymqzJrc8XxBbMRdFYwStghDQdvryNmZlU+hlNeao964mQ18L6bD5zj+MyeWiLNPet63nSiNrB4cN3O+RMT+ihbu9Y51Qc6D0NUN8H6xkiizNW1/renFcAqdO48P8J7rOlI2cXrAY3c42XkmrrkJEkJx0L6+4J37VHQZzcQj6ch7HREgJLQWN1XiLTFGUR0KjJNU9IzGng1UVBD8u3xgRtuh2zAWp5+1H6MI=
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
Changes in v10:
Only update patch 3/3 according to the suggestion:
https://lore.kernel.org/all/68da8183-dbe7-40d3-b6e6-43c3f12767e2@kernel.org/


Changes in v9:
1. For patch 1 & 2, some update of commit description and code comments.
2. For patch 3, fix according to the suggestion:
https://lore.kernel.org/all/eff26d08-d824-4459-858e-277760fcb4a2@kernel.org/


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

 mm/ksm.c                          |  61 ++++++++++++++---
 tools/testing/selftests/mm/rmap.c | 107 ++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 8 deletions(-)

-- 
2.25.1

