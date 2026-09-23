Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1BB5C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE016B0088; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F096B008A; Wed, 23 Sep 2026 17:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6BE6B008C; Wed, 23 Sep 2026 17:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D12676B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBB7880130
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:45 +0000 (UTC)
X-FDA: 85246271250.13.E2EFA79
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf18.hostedemail.com (Postfix) with ESMTP id EC7C71C0008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=K3wNORFf;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zkKoYk37zs7WcKh+6sHfyUj3HAIw43ESyu1nLCkyq7Q=;
	b=NNW4HuKFQedHOikM/SO96VCHms7sVI1odRqjIYRSk5jsoNGM0y+UOrr09NaZMNrTyARHqY
	eqiMZIXll/Q4Cg4AjYFrWK53tUctH/nhKuhySZ1G/AZttSHgSmfmtTlPGhvAZvY34k3Grq
	WLRI1WivT/6hIythM611HZV7/Lyiw6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197844;
	b=dIZluNE2nwR5E+I3KosZ5+kW8YLphrMABgse2apEM5iJqrGmg0Lme2Sy5u1uYT++HeKiYs
	9gtDkEzj3uM72OsPA6+xkRQ1BXILSyPUoUHpdIu559ZM710dv8XzqLUmHFf4SrWTrwDA7n
	9VH84tF6DYVqWZvRsMGpXmE4I03irV4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=K3wNORFf;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cc46c8so170488685a.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197843; x=1790802643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zkKoYk37zs7WcKh+6sHfyUj3HAIw43ESyu1nLCkyq7Q=;
        b=K3wNORFf8pzco14k7SW58miTODgaYizip+hSYGbI94+ufnGwLw9b68KmWzGTjA1WlI
         6K6f3D2fCuOgxRnt+2/AmyXw2JnSiZ0BsDi6jR2XZu35pCq6F/gmneNnMSm65HXg9XZF
         Z3XXQ5ZxsG8XgNh6zNW/Ya6r5sH0FlHrlsiODZSvL4VDhEa7unZEVF0yYXYhZin+9utY
         Gxyn94rDrnNJqaam0ZrJZZV7V4rDmVkAyqFJm6b7pyWQWiPgAFtlmyJ1x2kafZ+4b23z
         DvzEIGNXAzh9Ej+EdHd51jhoWVRV6AwUWaucFa2JFJnhK7sLZAijON69hDcV/e6UNGnF
         MJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197843; x=1790802643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zkKoYk37zs7WcKh+6sHfyUj3HAIw43ESyu1nLCkyq7Q=;
        b=BZtvjibsNZRThhKK0T/gDw9y1lmb33csI237Vf4YCXJXGKzWV6n7wm1ODHmHNP5a5m
         bQGioubJirXbikoikkEHlV0O+5T8wHxSDHsNpCQUT1WNySZ7sfhCcA5e9+p50IpyAWVg
         yPzvmXkeWsveNY5ST4FeWWjDQtTCM3RVH3IaZp9/15k/iXsIUF1jU8UTt8b5DkbZrxYo
         Ag4CKuSzNMAx9nsJxhJ45eeDkS3LZmBuOjjrx3MYxs6sDmJrIZZrfyEbPHD3V9uB11MR
         1w4U+Ptu7tQOqQKlcp8LWofT5/m9926E3Te2uf/mjDJFbrco3WiiHjb1n6JGGM7PYfVs
         kjJA==
X-Gm-Message-State: AFuF++m26BD6H1K7leixUTOh4kgf+5uQEXfwwUm88OwS6RpT9l6QzNuY
	CMZE7JGWJJmvT+8x9Iwh/csVjCpokXpMob+HRbo5l2ApQQ2xXTj9BpcKw/glwkl5m+Lh9BBEbpY
	XRRfA510=
X-Gm-Gg: AYBFou2GXZwa2qYBcBLr7/G2mtEeer2qFqAsLWTVkB6UCv0ojLeH02iWSp9Q+B/6rgC
	EK8A4zf36yrsK+9vzlfcH0wE2SzZ8A5BruW2xjwzaxHKDLeqX47pygoyaYd+uioF1CtXEVL9hJL
	DxZIxcGlII4WzvVbzJC0P8Jl4XJT4J2Xt/qNE1PARL96K5NtguA48MDkoIlcRquOiWkv7yrpzAq
	cl3oC4Ipb0RUAz3P/9uckq1kvlX/57JYdUx2yoKcc+2djyOL8GPyrt6uI8SBGiZ6zYZuv+eiXY1
	1HrK2+aiLrpPbt7GKeffsPO0q+59BxDXK5vcPjAqLsOxwcQeTmaq5oyEDmuXgldHQzl6eHa6IA3
	N5ssoA0DmtkH7mlKevcT7+BjljzgMdf0M0Op2DB1M2nVSt4LIAtMS1p5nQJZgY9/bpjIYMmzQ9y
	3TH8HqQ4BbH+ZITrh2ASxh8Rnkxagba92gC5Bfc+w/kzwP/fFumaR2EUffP5Z7rpe1gxRRkjdLP
	oBD7no/oqsT3+f5h3odWP66p8/RsFQMDy6UinRDyrrFA+LIoJnVpBkzMlRp
X-Received: by 2002:a05:620a:271a:b0:93b:d8b3:f9ca with SMTP id af79cd13be357-93c347d1b8emr57822685a.21.1790197843026;
        Wed, 23 Sep 2026 14:10:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:42 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org
Subject: [RFC PATCH 0/6] mm: pass alloc_flags through folio, filemap, and bulk allocators
Date: Wed, 23 Sep 2026 17:10:34 -0400
Message-ID: <20260923211041.3127588-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC7C71C0008
X-Stat-Signature: 4j7eahjpiahwkf8ti6mxfcqhkwogrh5s
X-Rspam-User: 
X-HE-Tag: 1790197843-550748
X-HE-Meta: U2FsdGVkX19HRyz4qarJIVsx2vFvxmxHkzJAA3jErSZTud2OCRhdem7y2/eh629wyJ1MYAelYp3pKQJU2+a/R8L4wxaiHz5nY4ct4DKw6LJ+lls5yG6Mjs0U4yQfQcPxcrKtsIRP/EReJjxMD7qoW+Da3/KVkXMojv3DxOh3sfGJ3LOPq7Sug3Aj+WQaPatUrCaipPeP85LmWk1bB9PZJMq6Ef/B25GhsrLyjnQVWrLSsfwJddi0KXsr9qOvBqgP7v8d6kFJyu31CgMjT7rZ/vPhvMdU+JPM3/VrPNZH7vGyWZcTsijplIcE2kzr8EUf9U0Uqyymoy6q0/92znuQ3mZ+/j+PAmjzSSyu13RytFLPPMv9Mclgw0I7IEUn4wDA0ptWZBjxg9P2CHYx+9WN+bMWnXbYO8NQ93OVVtw3WOe4F5PhnijNf/K9qfTqpZi3reRoLnI5Ov0dk+5XNDBsIn18HMdcysSRD/1aM8dNLtMGyeqfIVoKw42ZyUf70PNCiIL62NJU6qYdu4DHhd+8P3S5mSV3Xhe2YloWLXVUnjlvENPw8iQXz2ZpyPehhhKp9MxXtKc+r1n5P/DTj6hp9fVK1C0/UIhtq2sMyMSIhOt6AuFcf0Sm0qTOTy0Td69Og07UtHB76yx3TkPDNrr+Z+KNiXsarOcgcZvxNBM0nOYLylTUebNwEPkwpmhRy1VGOq5tzVjcnwAfkBVN9DVMtJ22GodpJg7ciHQGOiSOt3tQ4i+QkuaDkt0yAyYLcAN8XESR1SFO1q4OcowCu1E9c8/BSPaf237VV/E6aSvwSmMMSWtXqSrh6a1GMPMLi1AbdDxjaR9cQmDPSNSsbU4nX7GLl/n09l9s1sVQJn8KX9wv8vG/gDYljs3LyIT9CnwlqaSHqbjtUrfB1uJuVogWeoK6W1b79E0P4pX9NqY40zYAaWuS5nFKdFfK0BTB928KiCcGVlCJJQhevYOB5H0
 iI8A3c7L
 Bm/tKlRUGvzC0pvPY7aHyyOarZW5gJ5wErbKedaeKKezw8lbSZh3cL0HC9Ji7GP2UO10BoT3aJROfGnBwEpaDsZWn6p6QngWJzvjXiAgR2Ihu1B3qIZBR5dszO0oZdb1Gj/NBwXl58YypUWTZOZUbsVhX8XdLA150KdyS0yHfCADGrL9iqClOJ0VqWiYloIPbZlhrEM5Wcy4NqKt4AztpqsH0i9LkJBHXzLzMD5szgXi9l8IT/YuHYNh4f6uIOLBtAaGQvPhwf175LeK7Lbh+MVkx6nyCjWFL2bxUqwQJFz1CQ36QMWVPBhOGM2Cbvt2oEuH+0VGUGYmlr3W4qD78QF7Mrwl6tiKtxftPFDNkV8v0ZVobj1U8U40+TC8mZ3O87Ot9tRLiPu3jM14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio, filemap, and bulk allocation interfaces currently hard-code
ALLOC_DEFAULT before reaching the page allocator. Multiple MM series
need to select allocator behavior through these paths, so pulling these
changes out ahead helps both series avoid conflicts.

This six-patch series first separates allocator behavior flags from
the bulk allocator fast-path flags and shares their validation and
preparation. It then passes alloc_flags through the MM-internal folio,
NUMA policy, filemap, and bulk helpers.

The existing exported folio, node, filemap, and bulk interfaces remain
ALLOC_DEFAULT wrappers.

Non-task ALLOC_NOLOCK folio allocations bypass task mempolicy and
cpuset-spread selection because those paths are not safe in all
interrupt contexts.

Existing callers retain their current behavior.

The allocator changes were built for x86-64 with DEBUG_VM,
DEBUG_VM_PGFLAGS, DEBUG_PAGEALLOC, PAGE_OWNER, PAGE_TABLE_CHECK,
PROVE_LOCKING, DEBUG_ATOMIC_SLEEP, and memory allocation profiling enabled.

Testing under virtme-ng/QEMU used a four-CPU guest:

- test_vmalloc vm_map_ram passed 50/50 64-page batches and 100/100 one-page
  fallbacks.
- With page_owner=on, all 25 runs produced the expected partial batch because
  page owner deliberately uses the one-page fallback.
- The alloc_tag ioctl selftest passed 4/4 tests.
- The migration selftest passed 6/6 tests.
- The page-fragment smoke, aligned, and nonaligned tests passed 3/3.
- khugepaged -s 2 passed 22 non-swap tests. Its four swap-dependent tests
  reported failure because the guest had no swap configured.

No BUG, WARNING, lockdep, or atomic-sleep diagnostics were reported.

Cc: Vlastimil Babka <vbabka@kernel.org>

Brendan Jackman (3):
  mm/page_alloc: add an alloc_flags-aware folio allocator
  mm/mempolicy: plumb alloc_flags through folio allocation
  mm/filemap: plumb alloc_flags through folio allocation

Gregory Price (3):
  mm/page_alloc: clarify bulk allocator flag scope
  mm/page_alloc: refactor alloc_flags preparation
  mm/page_alloc: let the bulk allocator carry alloc_flags

 mm/filemap.c    |  45 ++++++++--
 mm/mempolicy.c  |  44 +++++++---
 mm/mempolicy.h  |  28 +++++++
 mm/page_alloc.c | 217 ++++++++++++++++++++++++++++--------------------
 mm/page_alloc.h |  10 +++
 5 files changed, 236 insertions(+), 108 deletions(-)
 create mode 100644 mm/mempolicy.h

-- 
2.55.0


