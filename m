Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17024C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE216B00B4; Fri,  3 Jul 2026 04:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EEB6B00B5; Fri,  3 Jul 2026 04:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68C36B00B6; Fri,  3 Jul 2026 04:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B23286B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:23:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BAC04047C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:23:13 +0000 (UTC)
X-FDA: 84946775466.24.9C14E6E
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf03.hostedemail.com (Postfix) with ESMTP id 638C620009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:23:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783066991;
	b=iU7PW3WkgUyEb9GN5YbL0SVrlULACvSUZJwIRaf7DXhIQgGu6ENBJZYFsWYXC923XnHedv
	Tnad01dBOLPbq6fst+CVjPR9CkuYZI2SuWCgsniduyQfhoDmHMJwyJPmFAihm4FNsc8jnE
	fc3A2cpwxmj/duKCweQDLLaRxBrWwnY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783066991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=6XSZO/dAzdfFg424zIgOgG/s0NYwnw9ZGDYS4jtOgIo=;
	b=uL2N4BfGXow272BqRZOUaLYn2oNeqgpgf7a4ha9KMjOd4iT+MUsKDngGQVmsrKtA2TzG4j
	ORkNVeSDyq0brAsR4cOYEXNpM3K8gazuNlv/stFc5xDrhmg9RT9XtKo7xF8f/mNcH+8mJe
	9c737z/kFxFp/jdIOOO+ei1UwvCxE1o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gs6Ff6X05z55RJ3;
	Fri, 03 Jul 2026 16:23:02 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6638MpM7040918;
	Fri, 3 Jul 2026 16:22:51 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 3 Jul 2026 16:22:53 +0800 (CST)
X-Zmail-TransId: 2afc6a47715d9e1-92571
X-Mailer: Zmail v1.0
Message-ID: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
Date: Fri, 3 Jul 2026 16:22:53 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMSAwLzNdwqBLU006IHBlcmZvcm1hbmNlIG9wdGltaXphdGlvbnMgZm9yIHJtYXBfd2Fsa19rc20=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6638MpM7040918
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 03 Jul 2026 16:23:02 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A477166.002/4gs6Ff6X05z55RJ3
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 638C620009
X-Stat-Signature: kpfji94zkakdawibcqksu7ojqr5kb5oi
X-HE-Tag: 1783066990-816282
X-HE-Meta: U2FsdGVkX1+oH5MfPssPck637vlhncX8lUt8Ijee6oeIHtYRrY1vaEuDYJLivm6hlgKWkCdxEKzGMGqeU0jh4HlSwAInpeKAf6bCXlaXQzy17rzleMsX/7lNtemOhTOheZZ6crDkIgP0wK0sqShZshaysAO6IFGWrSAjjHMUV0x2uxat8+px8uQjD2GAvG+hreGE6pmh24MQTFimdlND7yTIV/Ip6ukvQmqcJrQ5xBtWDaMZsTUKse1aLj4mnMJD6jRUntwhM7u5ZFxsompGnDJEqcNSlVOnbdCgXw8c1/nKPVWLpx3f7IvVG0H13wqb6Di3Wl09vDOr9UCDn3ak22rn0HvnrQs1iJ9HNodw1J3dWf9cSx0moHpxirjDITAe1oZZnYurbR4qpxZ3ZMRyeoUEnBrziKfeMDxRbUMPSOJZwFVPFmKO68znFboQZRNrk6Y1ErwI+5VF336Kr6VmVyaIAFCFjlUFg96Xkw8WwQTH0+mOMNt0Zjmk6i1a0qVjqEHuCxBKAlf6uQOA6qjb5B7bK6VIo8l20NE3P+5vwUWpIg5Yzw6bAqNWpKg2Fpfyv6TzUGTf1IJnvUmzKPqyN4J3t/Xct02Q9yMoeffI4LzB1X4GVT8A1eySe+DF4Gz+8ZyWRriAhJ0v5XKVY3B6QcEHBd2gGiZd+Xs817n8bw3ppQGUPt0AFRFlCu0ETIGZ1qmN2Nslssr/CI8L+H+ccGSypc7CjURdXghEbaaWvcalaJB1GY7uNYq05//dTLzJl0Dw6FK8xSJVUPXzEWIlCjzyPVmmvJUIXczcaQaqBNC9CYalmmUjBvJ8DmKQRPbcX/Q3Yhxb6dYOfcQUG7FdN+lXLtdasHoUHRIRX9HouwScupSFD65zfJ7I4QGMwygkRmBk4qEZG1cT8USq+8FFfmEwIpRmMfz4aWijr3XQhh6TOzqAVXD2Yt3d/GDkU/RyuqHnC+iTwrm887QIFe8
 Xb0k6KUG
 HJNw4ssSciri5S/D4xj0GD4iM6uDXgVx/7BXGBjLHfyrvDwDTBDYjdewW2Ii0ZPeN621KxN2xIX7EfIDNXJ+8gdxT7YKW4bVHqU6UHjnT/Pix9BNoQZm6bWJc+r4pzIdnQ1X0vX/yQ/zzf9TuTLlwS70LIyic4mXXUT0fz1dgFnIP72I4vWwd306s5nolLlis8437l+TXDhmk225wOpGZQ53SaqWswCrKjHiuZTk+JvpeZ9p+GRsNmvjhQMhq8JG5H+wf3eUegocWYhxdMlDgW1t1aT/VGmqGtESfjaYnTrl7COuot8wiKwdjxWTBWAuQ8P+PE7Y7XkfW3p+CohSzmMsvs34wLb5sZZvhBuc2xc2J2RVJeDxNLTi0glNajG9X0Tn4
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
Changes in v11:
Based on v10, simplify the code of [patch 3/3] and add retries case of the low
chance of page compaction while we check PFN. (Suggested by David)

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

 mm/ksm.c                          | 61 ++++++++++++++++++++---
 tools/testing/selftests/mm/rmap.c | 81 +++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 8 deletions(-)

-- 
2.25.1

