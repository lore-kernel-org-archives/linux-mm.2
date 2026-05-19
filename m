Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F08CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A626B0092; Tue, 19 May 2026 10:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4422E6B0093; Tue, 19 May 2026 10:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357F06B0095; Tue, 19 May 2026 10:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24AD26B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:06:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB3741A0425
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:06:11 +0000 (UTC)
X-FDA: 84784343742.17.37677AD
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2586C160006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779199569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=/TyRM/YTh/JWpnjsldf689ssfsYAvH+u7rMsNgMHy1g=;
	b=cuLZrlA4QcIozQKvj28WLt64Epn4ezzUqao/YV0UVHR/ja3qFAiuCJspCz+EvseBSXaHuu
	0krH+zuAKvStbtQIp6d2Zo/3Kbvo8LG2QewfI0Mrf6pGo6BD8iUaTFwJOZLdSGF+CgvUcZ
	dyqqG69UvCO42iynAGOMOPQ++tnPz1E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779199569; a=rsa-sha256;
	cv=none;
	b=xbAhs+5wBrT8YJsI25DxEt4z2SQjXHGyFRvYdjpJzZCQeKdlB8XieV3qHJvD8dDnmt5H5t
	SRRgnS0GbjOeJEBkxxJQKfba9/jjRBz/JWiErT9Qk8WDR/8NxXOLlG0FFnjbfesGvlh+N2
	W/zDG/v/fmTl66zUDl5Y1rrjAoWxDXg=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gKc042Wh0z51Srk;
	Tue, 19 May 2026 22:05:56 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64JE5XJb091705;
	Tue, 19 May 2026 22:05:33 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:05:36 +0800 (CST)
X-Zmail-TransId: 2afa6a0c6e309e2-0df48
X-Mailer: Zmail v1.0
Message-ID: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
Date: Tue, 19 May 2026 22:05:36 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <hughd@google.com>
Cc: <xu.xin16@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <michel@lespinasse.org>,
        <corbet@lwn.net>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1IDAvNV0gS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64JE5XJb091705
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 19 May 2026 22:05:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C6E44.000/4gKc042Wh0z51Srk
X-Stat-Signature: bi5kj8c3y63ow39p1qmt1x8zwsjkhajw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2586C160006
X-Rspam-User: 
X-HE-Tag: 1779199567-910459
X-HE-Meta: U2FsdGVkX18Fnqx9l4+NApejgLy6QpcvPkK1WrRu7Q5OTItHkBQAip9K4hFUfzp9G49ttMnm2oq5CGE1+8tmbHQls+3O4hc3F44C9XwmSl/kxrdNIrhsE1CZRuppwQyGHAI40w9rDYJOeOU8zxALP3vyQoa0a9WF7RpqYMr80+REslo+lpX9uSJFYPAShgfqtGWl54FkItNd2rVqQEL636gs5wjfRTX4Bjrqu0VfaYCBDgxlX5ZrQII+R6Asl2dOezIQ90BDKfYglnf+PqShlNNulf2a53NwNc2vWKOsRnkK9OflQdRJJYu6oNA4OX+ceHI4TexZ52Tx8LYN+Y5jd0o8L8G3iAKrjbxNX4VF0AcJvLRAkOPN/MTG7BXCz69Cy2QjAlLqJNgjpFn906B6b4MW9TogS0Vn0Kkv0Kab7FDrddnGUyPjcyllXqVXEOs90QyngtM7/BF/cpBKuB4QrEdF1cAGyHPeqwRkbG0JcvoILaI7MmjHD5fj5HZnALHfEzn+IFMKWP5xOU/vuJJVm01lA6E6EBRshQd4QPffLjQ4iZee8Q4LhXF4bb6qijAX8oYbdver7JG3R17FZKRQ9vL7LRE48uRpsvnr+dAn/Sw3zG9C9q80D1SexWjQooJ7OWIugtjC5W84U0LZ5yF5VDOTiQrYCYn1X5/uWkum8C1P8bqyx8WwVPIIESIkND1wnP6ykqq4CPIskZpwvrc0ROu4iPgGc435OULTA5S+/SRcrZqADAbxhBG2myn3/wUfdkztmQXoWKfqxkblyQZiES9qhVkvS9RPwwUQvFi9mAMHhnqGrkCcCU8VH7aF8znutz0xTjuICvK/vqQOrIuEeMxxUX+aZ/xz5/PmGKbHwoHsFNMhds6c/Ls1N4xB/D8bSA2IJrYMgKC56UnwHXtxpA8VeQH5txzVVSDpqIwRZTChEjEZiDb7HDS+qgglO3VsD5bq2huDJplUuPr1F57
 DM2A0I1s
 /nW8SwK/9gVZMLaNSc+8MAQufFRaeRXb+cF82KCjSHM1J332Ao/n9x/sEfrqsUHaa6DBAWZrGVi4JfeTpzxkQWAgcw8ADLkHquRpT3EDvP9bse5+NXRJZ4XjoMKdH82XxuO2BzlF/JudI8XFiH8tuW0qPyg0Q7XQc7FGHN6TpT3aec54Il1ggsR/IjO4nEZVpi3kfxUcn1XfTB3a92tybkIfMnv+987V7TRATvu+JHpd2/tV9NKNCs35q968KAEdN8XtRbkCkesLxMEOcRIUg/ILkjV3uhei+fQyP+2tUC8Eq3B7jLDwfXEB/FGmadk1gMwh9NHIkSkt1hXrC9LMbFvlbVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

When available memory is extremely tight, causing KSM pages to be swapped
out, or when there is significant memory fragmentation and THP triggers
memory compaction, the system will invoke the rmap_walk_ksm function to
perform reverse mapping. However, we observed that this function becomes
particularly time-consuming when a large number of VMAs (e.g., 20,000)
share the same anon_vma. Through debug trace analysis, we found that most
of the latency occurs within anon_vma_interval_tree_foreach, leading to an
excessively long hold time on the anon_vma lock (even reaching 500ms or
more), which in turn causes upper-layer applications (waiting for the
anon_vma lock) to be blocked for extended periods.

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

Patch summary:
==============
patch 1/5: mm/rmap: add tracepoint for rmap_walk
      - Zero overhead when disabled; offline latency analysis.

patch 2/5: tools/testing: add rmap benchmark
      - Measures KSM/anon/file rmap walks.

patch 3/5: ksm: add pgoff into ksm_rmap_item
      - Stores linear page offset (not vm_pgoff) using a union.
      - Cleared on failure paths including break_cow().

patch 4/5: ksm: optimize rmap_walk_ksm by passing a suitable range
      - Uses stored pgoff to narrow interval tree search.
      - Reduces iterations from >22k to ~3; lock hold 705ms ->1.67ms.
      - Includes detailed user-impact description (suggested by Andrew).

patch 5/5: ksm: add mremap selftests for ksm_rmap_walk
      - Single-process, 32 pages; covers mremap + KSM + migration.

---

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

xu xin (5):
  mm/rmap: add tracepoint for rmap_walk
  tools/testing: add rmap walk latency benchmark for KSM, anonymous and
    file pages
  ksm: add pgoff into ksm_rmap_item
  ksm: Optimize rmap_walk_ksm by passing a suitable address range
  ksm: add mremap selftests for ksm_rmap_walk

 MAINTAINERS                          |   3 +
 include/trace/events/rmap.h          |  73 ++++
 mm/ksm.c                             |  48 ++-
 mm/rmap.c                            |   9 +
 tools/testing/rmap/Makefile          |  11 +
 tools/testing/rmap/rmap_benchmark.c  | 529 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/rmap.c    |  76 ++++
 tools/testing/selftests/mm/vm_util.c |  38 ++
 tools/testing/selftests/mm/vm_util.h |   2 +
 9 files changed, 781 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/events/rmap.h
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

-- 
2.25.1

