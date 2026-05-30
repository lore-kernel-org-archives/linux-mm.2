Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56527CD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 08:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA4D6B0093; Sat, 30 May 2026 04:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B546B0095; Sat, 30 May 2026 04:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71266B0096; Sat, 30 May 2026 04:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94B7B6B0093
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:59:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AE4C16175C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:59:21 +0000 (UTC)
X-FDA: 84823487322.01.45BE296
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3ED1A40006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:59:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=0wm9EV2iw/7y5jYdgNSKZg9qMCwkEGtT9+mgsf98Mxo=;
	b=EUVynzxNqtn7hDHuE7XHGsj5n2L5i/PxOgsF8c0OFGwZMXGLrWugWIugo+WiszLqGU6oxV
	lCYArUAtlEaYTifoIjwLngcrxDfShoTo2UuhFkNwEvnLfR8Hnl5Gxik2K4apy6DeT9PF9N
	BLiGZZ+hTGjNOqWZmUU/cV5LWJcAs7Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf17.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131559; a=rsa-sha256;
	cv=none;
	b=glFdGpJ6aH0DwfEia+jWvuSlQCvsgTM20oc6+Hom3CoItroB1h7e05iqk7h3KegRG3jkjM
	rfkk7DawnY8ZnGtVI8D2CpDH7OPA1jsyL56jla1kG51lMKA718jZSoMEd9zgPbzIfdssbI
	s0sya/p1cv37/AcClRky4+Kn2Bbc7e0=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gSDg16fxlz52SFw;
	Sat, 30 May 2026 16:59:09 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 64U8x5oG021296;
	Sat, 30 May 2026 16:59:05 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 16:59:07 +0800 (CST)
X-Zmail-TransId: 2afc6a1aa6dbd8f-104a6
X-Mailer: Zmail v1.0
Message-ID: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
Date: Sat, 30 May 2026 16:59:07 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDAvNl0gS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64U8x5oG021296
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 30 May 2026 16:59:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA6DD.000/4gSDg16fxlz52SFw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3ED1A40006
X-Stat-Signature: 1i1yyamnhsaicd16jjx3xept4qhrja1y
X-HE-Tag: 1780131558-652091
X-HE-Meta: U2FsdGVkX1+a5IyMj6iiytqnaIWte0LsQY5Ixnaeep3O3N/cgsyenPyQv48X63CXRo7x9dHl2XNvwM4/1bQSz7cNCur8I38Qfxw5zeSadIfECh4GeDf9lEarxGmSsGQ3ov0txwY6YEbUIHFSO9edcx+UOqpE28sN34LVtkxT8VGq4KQvS7cn/HJRGnTIw+cG40/5rHFNYQKchMkmZ8X7iZeKYGCaiulNWuIKSajZJNSvLQ66FVyF+urt1YrpKblUlvtBw6qXyfDIKjaVPpEhkR5ewEStCZH3bDq1aW0W22BHJ0qgqt63infXv+h5chs9jSYhd/SqMME8MWffnFoUZt9XETcuW+h6sXUBAOU52/qazLuhDv9aTyrwlC+KVVaTYg9IXGHiXm054q/DHuVCnGr7w/DJ28/tnkW/fihR2crfz6fm9fRBzAVI29omZPzo6UZ0uTZDwyv7DTMD+iGtrlIzUl61N1FxmzK3PcatSfNbKxRHmjoElveO8FCJ+RTMKvL8XxNbO47G//qogMLwKWi8zzn01A4nk5xwqjnwcbQrS/mW+0z0/o2Xv557dkAQAgSlj4h4hmlSAYAHJSsyQnZtID5Sm26OzGRWfhxkLadMIPJrfk0/foLrjUQO1uvE4/bjfdXOOR3nOsweVBx+TEeyvdS0AS2PM2/fcA3HKrIIBFSOlhWgEGh2cXa02Dl8SOWhwgOtq7FeR2MuimpDHe+hkipp/j1pP/ZdnglELlwX2WY7Ph/jEJojcpjqaJuIpGY3WaluwvgYDfax+GnFGt53jvMhhUZUE08wJGLhFcVRjKlZNO5kos6zXip2S7RE0RsGYWGMgAv4kMBpsgLQ/WVi5Digkf+fNPKGIgt99Q7vt0coHgNk5uscZ/VAyEiG9+Px2FlnXNr0zhmQQgFVX5p03/hgbVxIWjDQOnD4xBNT4zncnOFjVmOtiIwrEmFp+iIIkYNkcscg/d0oCEL
 PqtGXWFo
 8l94IGwpnmxefBMjRsa01SPduoJQkCq/vWjNW3WNJgNZDTO7QMBsWz5bFrIqDdGP5yDxqsGBsXJpFzxoi48QBofWKTVbfYSGkdZuDIO4WPMZqU2e/Na5z1pRs8WNZjJqLIPEd08V+3au2hDarevxZFSWulnOr5Oipq5F234oKVrGg4Ro4aFfeee8ZkZSOY2THwaD/+Z135UxikvIF8bZ4bqeR3WOsTdVsaB7S75FZBKuaCEUG+9L/hl1+BNY9l/fO94GH9x1h8sd0Ak8/wRYdfsFGmwBOsDBItoMzYIIyhOYuPod4pJnOcWMrIbPdkesEOWzmde11Ub1RfH9vNuWSc6Cstk2ZlFBRFC5PdD6kMXPeWyi1DH7dns3HGfUlZ4T0yxAtQy6ynS5mWBY=
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

xu xin (6):
  mm/rmap: add tracepoint for rmap_walk
  tools/testing: add rmap walk latency benchmark
  MAINTAINERS: add myself as reviewer for rmap section
  ksm: add pgoff into ksm_rmap_item
  ksm: Optimize rmap_walk_ksm by passing a suitable address range
  ksm: add mremap selftests for ksm_rmap_walk

 MAINTAINERS                          |   3 +
 include/trace/events/rmap.h          |  67 +++
 mm/ksm.c                             |  48 +-
 mm/rmap.c                            |   9 +
 tools/testing/rmap/Makefile          |  11 +
 tools/testing/rmap/rmap_benchmark.c  | 674 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/rmap.c    |  97 ++++
 tools/testing/selftests/mm/vm_util.c |  47 ++
 tools/testing/selftests/mm/vm_util.h |   2 +
 9 files changed, 950 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/events/rmap.h
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

-- 
2.25.1

