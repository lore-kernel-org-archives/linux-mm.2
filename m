Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D1CF54AB0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98BD6B0005; Tue, 24 Mar 2026 09:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49E26B0088; Tue, 24 Mar 2026 09:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FAB6B0089; Tue, 24 Mar 2026 09:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 959FA6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:26:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40C22161C14
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:26:52 +0000 (UTC)
X-FDA: 84581031864.21.FBA4531
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4117740010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:26:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GAPjGmLN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358810; a=rsa-sha256;
	cv=none;
	b=mPafj+iIe60Lfmn1AjehTZOklLebCjVMmIx8Z+ymOItIXDIN4T5w3QQPQ41qFtl8Wt289o
	bz1ebFjhf6Pive+v171ad/iY/ihS1A95IRycudl9dG72eoiVzO6FxR5iU3ufZqjSlibp7D
	+qtdd+ri47YEGC0mRUpwk7KcnygVYFs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GAPjGmLN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9CtP85zYJWf6ny5avoGWyCAahNBDAgLwjniCirSLW4w=;
	b=LIIzHY/VRSCohGt6n38TMITfL4Yyl0OU8msY9GI6lXLXUY4L97AqKaSjlb3WHXTpPd6Lee
	iqzuqK0O4lCwqI3VeMMTN7LkBRFhsy/hiT04CoipevcT+AkDqr64Erh4T8JX5yU1mXABB1
	Advs388flRChWlLd4S2TpQryX3J0RIw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFCBA1476;
	Tue, 24 Mar 2026 06:26:42 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 935103FAF5;
	Tue, 24 Mar 2026 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774358808; bh=F/htvyFctlbNCF0Y3WWbR6ZEMytC7JSoA3t6ZZQxiTE=;
	h=From:To:Cc:Subject:Date:From;
	b=GAPjGmLNA2YBz+piw50rSr90wWg1hKu2xeFC6b9WohZRg5sJn/f7FEuJnwTJu0flv
	 CWF5JGZxgDVFsK7L3pWn1XO/yZuSgRC5qDd1WdH/9cHcgbY29uCOLYoYZLWaRyJm4H
	 phG4Qg87ZrNFvEut2qjD6YcSPCYyH4utTyOI86Js=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 0/3] KASAN: HW_TAGS: Disable tagging for stack and page-tables
Date: Tue, 24 Mar 2026 13:26:26 +0000
Message-ID: <20260324132631.482520-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 94hbcnk99mu8bi8ita9wsf3ijwhyrw74
X-Rspamd-Queue-Id: 4117740010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774358810-269888
X-HE-Meta: U2FsdGVkX1+ONGi7671ljRfsbjQgUurViMvD3sahXy0v27gAgfh8/m84xeFDTof9U95mjIDXlBi0IgW4/3ALSOfzzl9/fY0LdMe4sfxuaquXxqawLJAswkLW8bYQbK9VjY5BWvBmqWHCtdcavA254jULFDb2zm+kwB3Vyqq3oA46Qq2zAEv8Lno6ttMJcBU5FtGJzKTKdAZlYcDjoQy4B9l47J3H5AVfthqwBEPW2sSuJdyNFCJH2WHXjBreI1DYgmXezLI/aMrKfYQnl0WDXKbn3x7qBS8Ebk0lRh0kGVr2wzGyky2pX1LhaweRdBPWePQTKqzCFW8dxsYy9AqaiOeQzTzXxB2NO06IeYsP/yJdoD7wpz5DrQc8LhfG2t/Aqoj8S8j7tiARlkPDRwL6/mPNBDvHxZbQo33TOmRK0k08g9OjnL21OOcvSy+tBV1pjq1PNoqeBjEkVC5cQlea0WHagkfnmKlhO3fvVYnXF0tBbjA/QRJ95JlhTWoWdVzpnTPjOOXjcrh/eTXuSWC0Hsn5SR+BG6JX4hi/EeBDDdtKUqQH8e3Iddv/SXapWj6lv/5qDIG/Lksw5l3OaDJfrnIBWt2kEMCiczFG1R+FGudkCf/54bv4z9d1cRxyHLeIpHNsZw70fxSyZvGqc4REf+4XwHLeDx4VxYSUApKnl+amGXfTc4Vlzt93kLHSmxQiLMSuGZREr+BrkmpM6Hxfpmf5I/gw+vZEOsG0xPGR7sAfcEoLW9Xb+L9a0RDfxFJb7ngpVV6R4vG/aJz118fonHmc798sDnw4Lo1NIbs+JkOupIyPo3frqFfM47g6PxEIlRr1YH7ySCWGIkexkP/3LuL+e1JXpJ6OYwQa5+ZydNhRIRPjZOvR9/zZUThlpBBuU8lSEBLImmWg+KDlXTNpOAX6VLdbLigZkceXmgTzgOcXfjZThTYXleqesA4kvuHk5aBhLvoe48KzHH1bP1e
 ERUlwXAI
 r1OTERaGoPQ3ITvV1B+qDshKdB8ekAvXiQcxYQvhOHR6YteuQgOz53/JXaOp6rF+ZdpuS8xCBNkKUBB8xb0g3t3QvLA4JjfsMP0dFX0yihGKf9TVB2dx2g7/YgpvUzuZrvmZq7e2gOq4/17fvRAtOwmD/zfKvH4igNNzp/EtIq6iuZxzz87aTwGAG7H2iXLGvMJoKbIECQywTz46VkrdI4rYDBWtB3qTUUXwwnAWLYCzniRr5UIiWitA1rndHw+D7Sxh0EAc6rZOM3cA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stacks and page tables are always accessed with the match‑all tag,
so assigning a new random tag every time at allocation and setting
invalid tag at deallocation time, just adds overhead without improving
the detection.

With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
(match-all tag) is stored in the page flags while keeping the poison tag
in the hardware. The benefit of it is that 256 tag setting instruction
per 4 kB page aren't needed at allocation and deallocation time.

Thus match‑all pointers still work, while non‑match tags (other than
poison tag) still fault.

__GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
unchanged.

Benchmark:
The benchmark has two modes. In thread mode, the child process forks
and creates N threads. In pgtable mode, the parent maps and faults a
specified memory size and then forks repeatedly with children exiting
immediately.

Thread benchmark:
2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)

The pgtable samples:
- 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)
---
Changes since v1: (summary only)
- Update description/title
- Patch 1: Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
- Patch 2: Specify _GFP_SKIP_KASAN in THREADINFO_GFP and GFP_VMAP_STACK

Muhammad Usama Anjum (3):
  vmalloc: add __GFP_SKIP_KASAN support
  kasan: skip HW tagging for all kernel thread stacks
  mm: skip KASAN tagging for page-allocated page tables

 include/asm-generic/pgalloc.h |  2 +-
 include/linux/thread_info.h   |  2 +-
 kernel/fork.c                 |  5 +++--
 mm/vmalloc.c                  | 11 ++++++++---
 4 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.47.3


