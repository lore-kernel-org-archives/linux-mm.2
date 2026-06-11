Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D1DCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F856B00A5; Thu, 11 Jun 2026 09:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0436B00A6; Thu, 11 Jun 2026 09:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE926B00A7; Thu, 11 Jun 2026 09:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A84026B00A5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:13:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2ECDC12065D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:13:24 +0000 (UTC)
X-FDA: 84867673128.11.65D6138
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9855710000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:13:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=d8CCrcgF/fmuZYEhh2/BSrJArNLQbmYAlHJiuQgFp7I=;
	b=Fve9IgRv/ABOL/9uL1FHVt7CQNzjmH5Vfl0yfzFxoX0SJQ6ApDDti6sPwNq3+I2S++l0v4
	zAmEqlnxu6rBy9HwAFGA0c1N3XtVz5r0bT3SlRTHSyw/Oz/ytvLZU1kgc0jCabb4h8Nrcy
	7qC2vDKZGS8vpg2SzxYUdMSS28c9tyo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781183602;
	b=Ik6RuTgSgAQwR78kFpq49r0bIJPohQP7WDOKBH+B4PEsmSVcn/9CWWPeTPYABnGaKmmmu/
	69gCIrUc8KdcG8xBkQGxA8l8ovxZAU18Pk34iIvIKfELo/QuQK8VYZmFmvENmpHGmkYFSY
	JW0IEOXdD6dema7wJbugTRmIeABUS08=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gbjkj34XDz8Xrnw;
	Thu, 11 Jun 2026 21:13:17 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 65BDD967092600;
	Thu, 11 Jun 2026 21:13:09 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 11 Jun 2026 21:13:11 +0800 (CST)
X-Zmail-TransId: 2afc6a2ab467109-77efc
X-Mailer: Zmail v1.0
Message-ID: <20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn>
Date: Thu, 11 Jun 2026 21:13:11 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY5IDAvM10gS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65BDD967092600
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 11 Jun 2026 21:13:17 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2AB46D.000/4gbjkj34XDz8Xrnw
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9855710000E
X-Stat-Signature: 37oxxydx8cmhy1xg5j8mq6tigb4x378n
X-Rspam-User: 
X-HE-Tag: 1781183600-533654
X-HE-Meta: U2FsdGVkX18MfrxFvI4SOjjI6JnMivM6O1IANsXNb1mV91fz8yt/xpUyGl8juyMSIAfCLcZ4p14bMYs9sUbK5TdNYWWPJRG9jbbLp4y6aZmicJFi6NMPdSLLDscS813T1+ZhEjgRrnoaGjXt7rj32cJkWTMVsAdBkR9RY6HlNMMr7QA7QBK39BCgue8w37RHdJkzFAqvnJohFkyYmK0prZdE/5bJxhchgabTADYJs7ZUVfQIdnBmZpqlY4K1yl2/2toSLUPFU8ZRgtX87HYNHR8dq2MowXK25D7tBwXhp1ONRn7V45ZKWUY+PmgKJ+Z8J/vuK6r3AMe/z2SfIdTU8nKlYckC/ulb1cbImOuexD7G6y7THzvwwAXOOIXVYPxidiFPuB/c1CU6S89fdauN42r5wqZ07EHOUN438uIH9f3nMQx1TXckwm4rDres7Q8WqyO7YsF1kzTIcW94VLC37Znlx62WT6z7hFdOeyXlO49/S/wl4bXLCcjRhg5Nwk3jT/SZn7UtNMRtLTZY2GHX499iRkRsF36YyyBZT1PU5yT7rfubuHvFb0424q5DwXVWx3ewsZvjNj8lC0Sr7tHcXhmnigh2j1dV+nCqaCwkycdIaNfZC+zZPqpSlcr3neJH9hpaWzPduCcfze6LgnbecEBDeMLpDjb/2V0tvceeiomT9bSwMWxTooGu1+egnLx456XTTsHdZVgpGq0zgUwZ073Fygd9QnFD7ynTTBEajPLUticdS077QlDQ/TBWmiGFloGGsqTWeKIOHxDX8/WSrA43/x/ZI1a+X54blJtchKO0HRF244TAr3WmQFIZa+QLBOGTlz7Ht1yFZlUV+v5rhz2GvwaJRq07xWC13qdkpTNaHpabR/nbdNNCStyJ5wUe9tsSHJFrAs98oVykMHLGbiEEUX5SbOdfNMex4UG+/M4dnlKH+z9ZA8mr9IkWcNUVZmy0dp+SjIZVhtRaZUu
 1xvg22Iw
 AfSBAP8Gf10DQ0LVkFxev6ZOHsEnYOhORmgYTm0ZVqUnCXgLTQKn+FAqsp3IQA3Fzivvlav4kZwdxAOkrPdJA2IMaV7EaAMpAvkSJX9kwMI85nlAe7tHrwX0AfyChyklsFB9FFHFMM2v6Aj99qsH7WgCHC0bYme32MIDiieLWehK4pZpycNE2ojRpV0XJ38SvSI0TnXQcdNS/wn5PQMTTkARcjPzg+obbUE1SdOgPzz07alZXHYlOfN2PnDT/ZCv5oyhBgH6qzmcUZvmTHOpxT2ElLfsjN8z8+DGWw1QCBPokuZYsIwoirALNc5KmtQWoC0oheLXIbMSucoFFxbOHaUagRZI/wE4gnpHdPLMaP799npHtwEw/Pl5xLYbuPgRt0TqLOuKalX5Z/8dfftR96Q+CWpATnTDkD3AK1FjRnyWrUME=
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

 mm/ksm.c                          | 61 ++++++++++++++++++---
 tools/testing/selftests/mm/rmap.c | 90 +++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 8 deletions(-)

-- 
2.25.1

