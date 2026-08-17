Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E72C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422006B00BE; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5216B00C3; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134326B00BE; Mon, 17 Aug 2026 08:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD5A56B00BD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D249816072B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:03 +0000 (UTC)
X-FDA: 85110726246.27.74510D2
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16357C000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=duZN5jTO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FKYH8HaW2tI6HGTmTWskn24rlydQB4hrTDox3Z2R7Jc=;
	b=VfF8hT1+yx8kuFKWmMJ37vMkycIVnw9O4bS8fTaAZiCat2lrg9NBJvo05YT05/bXr3Mvxy
	amgEFhHe7H/p7c96HD+xHkUIjQhIjVaYdLdCP9rqL2s4m3+e5ezfVfeuv/RQC/xEeyunSf
	M/nl8u5rmOpdEgxBLT8VCaZkWVj0ULM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=duZN5jTO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970582;
	b=LwlF7kInuxduFxixseM7Bbc0Wk7zILMdxxjYuoTZXixLuv6Qi6CwQjika3iyzWc3A4hPVX
	mtBaxnoIokM9i6370qcfXxFJi9ppMO1P4SMYKVu3QVyZowVhR1aap8qJwH54LrLIPOyL8U
	QnRq4LBHOeUWxlMnqDibwawX+F3/FAE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso7375829a12.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970581; x=1787575381; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FKYH8HaW2tI6HGTmTWskn24rlydQB4hrTDox3Z2R7Jc=;
        b=duZN5jTOFYXJ2thr/XtHc0CiBTh9xTR56hhyHdzNFTzhT2bUkPr2FRCiIIodsiTPoL
         DJ6iT4z/Xkng1RpEhpVz96OrbGdaIq9dOPCLwQT+0YNvroKw6817ViGF72MX6QjGqAC/
         IRiRbk6jJUVuN5cALvaRvj/2vpzPbFQn3231+XPGIddgR1BQU9cFlqxOw3MAW5chQcYl
         L5kUYs16t6XQKbvXgD7cbV1mOq2cP/LE2JJ5L4f0jqgqDqhDyZ/C2x67+E7ifwgQOnF4
         24L9kZRaPt1GMO3SeBuHpLGf9qS4FJFDdHx24MEGbDnfKVfCz2yg/YmNzm+yoWhujlE+
         y2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970581; x=1787575381;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FKYH8HaW2tI6HGTmTWskn24rlydQB4hrTDox3Z2R7Jc=;
        b=NvUDdaTIGJRgL4vSZPKMKkmBbn1CSs+NQ05LbVqn3xJiQMAA7EqVExWiINRN3xTRxU
         kWJS9Hq+s6qPcAszTGM7sII3M4B8hqrxzz6iCYwIcR80/FjmgCWiPOAd0WaqltwvJEDT
         oyrVvsGrisZphiGBXtG4o02gEQ4VKR9ZfZ6ttU4y85bkZPRiRzrcvoc1n6SZSoBzH5HA
         kJehXKjOUYyC9n9imwG2h9ap8nmsFgTS8kTvkFLlUV6KdoWu/4sTwmYFVtScS/eQ2wiQ
         7bpnTmFjPQMma4hez1p3p5n6MoLkA6onF/1TBk/9CbAOdnMa2UoMQTegJZbHIylyRwwl
         sT4w==
X-Gm-Message-State: AOJu0YwSM4VK0rMeK0o/TXBQrw3UTkVt/OMQGVxseYkK19WIR2A8x1BE
	TQCqKv5jvURLXPGcYycY9Rn2Bho4Gsxnr/Ga6g/eakWqvyraDgD24AjJ
X-Gm-Gg: AR+sD12MES+b6HvIQP4ib2liEUW1Gq/5QUzAYZ5c2UIzWm8P1BCJgWyqz8KgmK3PKCG
	RB1SiV36rYmOJhAyeUX/JCzTeo9ZlN33FRiq7Dbp4/WRIziOnaK50ekD9v1+DKjy9nnc3VD+ma9
	HDhg3xIC0wzGZJCSk9E+7KVjCB1PulDx/v0J/G5BFiiU4sgTghvJ6RnmhXukyReipJbtCgIfhls
	ueOyrnLqpIge+nM7yZRwLI/hSw2fZdjBWc46rB+FsTAlVNPIaC9OMyttncQOPq5mmskFdB5XF0j
	g0bt3x8V3OwdbABdsbvB2PSIUjIMIpze2gRHLYk6cJgBiePPTooJCoxNVLUlJtZtKlUw9ZP1vN6
	nPQuPO6CcwdDF+QrCw26EzjmZ8f6WWgNWp38NrFFKRhcVQCh8siorjm+N43UyAwFYOdsd7nZHN4
	X9QGtEWPlCUHE5F2IBW9sBUvxS4Epq1bUaDtZNRzYvGNqBuf+4eQ==
X-Received: by 2002:a05:6938:a08b:10b0:c20:d90b:2ccf with SMTP id a640c23a62f3a-c212a18c63fmr756880066b.7.1786970580310;
        Mon, 17 Aug 2026 05:43:00 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:42:59 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Subject: [PATCH RFC 0/9] Path-compressed trie storage for persistent stack
 depot records
Date: Mon, 17 Aug 2026 13:42:40 +0100
Message-Id: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDCwNz3eKSxOTslNSC/BLdEqBOXaOUVEPTRKOU5DRLcyWgroKi1LTMCrC
 J0UpBbs5KsRDB4tKkrNTkEpBZSrW1AJ2JpzZ4AAAA
X-Change-ID: 20260807-stackdepot-trie-2de15a2dcf97
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 16357C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ok7npwwk7waqmtfpqb5ohj1cf91xsnap
X-HE-Tag: 1786970581-10831
X-HE-Meta: U2FsdGVkX1//LAjlsHpy+E5KbGBmyTbo5gOJVhKsuF+3aFd90FwECCAyCSWLY1qL3E5fUNzUMpe6qiz3ADPINraOvjQlb3f5IcyROrztWuhBdWaXumV2gKz8DkkOFTdMXnWqijXWiB8iOrk/Off3Pr9CxODysTukiJW7oAv1pXVJJ3sNsy+oinPuxWFSf1qIyz/MbChH/DGsw7UAlH3BsjK1mCuOvJb48cb98JxfGufqRiCJ0JPoRfEw9OSPEdu0RgdvS5CgzLbg15MbYwMrYpfQvvO+0+2ke53B6grNH/Li89ibAWmop2SlyyutfvPiIGCwj371KEXS9MtPAvb2SoDz8WQktaMex26q9Bi2pB88FwEUjzxzYdkk4OuP2QLgb3AC19bEuHzel4PGFxV8L2nT69JwQzvyc5zlLhbu1QX2YV1rDwaeepBonuqVZyMFQc81Jdzuz9VL3wl0RURzmw9I4Cr4aZoGHzytnkE+AHeMeXnIHKsxrazIybtu+MIt4pJSgVfzIv/lpnO7N1s3gaw+hoz3wqwvnMp2tOMxKCjUMcZhV6hSSKVBL0oQNKNsYmEZgtJddHKQ+GVDfD+LopY8jpaI9VgPlCb9QJDK0xyFesZiRQuamI1e3r04numT3smYlhy9xvAQK8WbnLCsxOy7J9DPV2EoK8zWc0uxq101IS+s5qYjzqGDu8SOKtdEyJ0Z23YBfAxSG5br3uhD1IU3RsRdwra3a2kvRfn6CqGQDVWE71wAgdREcduMb0waqBp1SOZUcbizI4kJnn8mS7qYNBeE2g9VCGJLikRkfy7RaVV9ArDINYo4lE52V5cB1yYdvy8W/2boSbERfew7ewly0ptm2N+v96XElr6MaWGPvMHZofaj3ZINKCjdIYucgUnXj9/2DDM43DciSxuea7A3qFELwa+6d04LcIyl+k83ESkUlZQft78ZdLHmijgohklG2e2YPOPk0z1s+VY
 kmstPAdB
 OnwxvCvV+hyoeT1fEYCTqpOemSlN1cznxQSiCQvXecFUp9pUsUbV1By9jL0kByRaKjB1QaShiGW7+utoKEGcvkH+qHPRI3DXK0OqE0Kn2Y356VYr68p3mCqDyx1kbRC4n2htagxbU6nRg/Gbt7J/1UkPkuk2/jEGZ8SVIDmS/rJq6fQimtMxnystL03gWfbBQNhs/YTeCaZCzdubMFyWZAVOKHd6GaNcefVZfJbc+pP+ImHP8HOoXV+HkiImzXwAmZGDuzZZf8y23ZNaKk06mFl6NTscBdD3Ym9/SbRfLymfZm8W+YJfBwcoNVXCKNxgfPJTL8HPjYkBSj3BVaY9cqemtFS1yDJhbxWE+2wS4PXOGwZsquPNkYM136qqmUGBu6z2Wm436gN5WG1hjLkrG8p31ec5Ebw4kTDmtiRpxWcm6OUsUD1trCQt/680InEOGzodzEPUcljgO36qTy1BRD6UUWmKisEPA3wTJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Stack depot stores kernel stack traces and returns compact handles that
diagnostic subsystems can retain. Some subsystems keep those records for
the lifetime of the system.

The hash backend deduplicates identical traces, but stores every distinct
trace in full. Allocator and sanitizer traces often differ at only one or
two call sites while sharing most frames, so the same frame sequences are
stored repeatedly. This can exhaust stack depot's fixed pool budget; once
that happens, new traces cannot be recorded and diagnostics lose stack
information.

This series adds an opt-in path-compressed trie for persistent,
non-refcounted traces. Related traces can share common frame runs, while
records that need refcounting or direct count access remain hash-backed.

Backend policy
===

Backend selection follows record lifetime and API needs.
STACK_DEPOT_FLAG_GET records remain hash-backed because refcounted eviction
requires record and handle reuse. This series adds
STACK_DEPOT_FLAG_COUNTABLE for page_owner, which needs direct access to a
record count. COUNTABLE records also remain hash-backed, and identical
countable and non-countable traces occupy separate records. With trie
storage enabled, traces saved without either flag use the trie and remain
persistent.

A trie-eligible save that is not allowed to allocate, referred to below as
a constrained save, performs one lockless lookup. It does not wait, take
the writer lock, or insert a missing trace. A hit succeeds; a miss returns
0 until an allocating save inserts the same trace. A trace seen only from
constrained contexts is therefore never recorded. By contrast, the hash
backend can insert into available pool storage and uses a trylock when the
context cannot spin.

Trie insertion failure returns 0 instead of falling back to hash storage.
This keeps eligible persistent records in one backend and avoids hiding
trie exhaustion by consuming hash capacity.

The hash and trie backends draw from the same physical pool array and
stack_depot_max_pools limit. A pool assigned to trie slots cannot hold hash
records, so trie growth can reduce capacity available to GET and COUNTABLE
records.

Design
===

Each trie node stores a run of frames, and branching occurs only where
traces diverge. Children are sorted by their first frame and found by
binary search. A node at which a saved trace ends receives a sequential
stack ID encoded in the handle. Such a node may also have children when one
saved trace is a prefix of another. A sparse side table maps IDs to nodes,
and fetch reconstructs a trace by following parent links.

An architecture hook encodes a frame in 32 bits only when decoding exactly
reproduces the original address. arm64 stores a signed offset from _text,
and x86-64 stores the low 32 bits when the upper 32 bits are all set. Other
frames remain full-width; the generic implementation always uses
full-width frames.

Trie nodes and child arrays occupy contiguous runs of 16-byte slots in the
existing order-2 pools. A writer lock serializes insertion, while RCU
protects lockless lookup and fetch. Each insertion reserves all storage
that can fail before publishing a stack. Unpublished reservations are
released immediately. Replaced nodes and child arrays carry an RCU
grace-period cookie, and later insertions may reuse their slots only after
the grace period completes. Pools, stored stacks, and stack IDs are never
recycled.

API and consumer changes
===

Trie records are not contiguous, so stack_depot_fetch(), which returns a
pointer into depot-owned storage, remains hash-only. Add
stack_depot_fetch_into() to copy either backend into caller-owned storage
and return the number of frames copied. An undersized buffer receives no
partial trace and returns 0. stack_depot_print() and stack_depot_snprint()
also support both backends.

Kmemleak, KMSAN, SLUB, and DRM move to backend-independent accessors.
page_owner remains hash-backed because it keeps stable struct stack_record
pointers and uses the record count for base-page accounting. The GDB helper
rejects trie handles instead of interpreting them as hash pool offsets.

Activation and limits
===

Hash handles reserve pool-index values through stack_depot_max_pools; trie
handles use the remaining values to encode stack IDs. Increasing
stack_depot_max_pools therefore shrinks the trie ID namespace. With 64 KiB
pages, the default maximum reserves every pool-index value, so trie
activation requires lowering stack_depot_max_pools. If optional trie
initialization fails, the hash backend retains its configured capacity.

Patch 9 adds the default-off stackdepot.trie_enabled boot parameter.
Keeping activation in the final patch leaves the trie unreachable while
consumers are converted, so every intermediate commit remains safe and
bisectable.

Testing
===

Stackdepot KUnit passed with trie storage enabled on arm64 with 4 KiB,
16 KiB, and 64 KiB pages and on x86-64 with 256-frame stacks.
PROVE_LOCKING, KCSAN, Generic KASAN, and hash-backed KMSAN configurations
also passed.
Trie-enabled KMSAN reproduced the documented constrained-only misses.
Arm64 boots passed with trie storage disabled and enabled, including a
Generic KASAN plus PROVE_LOCKING configuration. drgn stack
materialization and integrity checks passed in both backend modes.

Results
===

Kernels built from the same revision, with 4 KiB pages and KASAN enabled,
ran for 61 to 67 hours on one trie-disabled and one trie-enabled machine
per architecture. The workloads and stored stack populations were neither
replayed nor matched. Record counts and per-record values cover only
successfully stored persistent records.

The x86-64 trie-disabled machine reached the configured limit of 8,192
pools. The corresponding trie-enabled collection observed approximately
1,943 pools, or 23.7% of the pool budget, but that collection raced. The
full observations were:

                                       arm64                    x86-64
                           trie disabled   enabled  trie disabled   enabled
Uptime (hours)                      60.9      63.9           64.5      66.9
Stored records                  ~161,819    87,088        497,600  ~217,163
Registered pools                  ~2,632       925          8,192    ~1,943
Pool budget used                  ~32.1%     11.3%         100.0%    ~23.7%
Backend bytes/record             ~266.49    182.44         269.73   ~154.76

Values prefixed with '~' came from collections whose start and end markers
differed. Those collections raced with concurrent updates and are unusable
as coherent snapshots or integrity-validation results. They are retained
only as approximate observations.

Backend bytes per record include pool storage and backend-specific
metadata but exclude fixed allocations shared by both configurations.
Using the approximate values in the table gives 31.5% lower backend bytes
per successful persistent record on arm64 and 42.6% lower on x86-64 with
trie enabled. Given the limitations above, these ratios provide directional
context only, not matched estimates of memory reduction. They also do not
establish equivalent diagnostic coverage because constrained-only trie
misses are unobservable.

Both trie-enabled machines remained up throughout the observation. This
uncontrolled soak does not support estimates of CPU overhead, system-level
memory pressure, or overall performance.

Feedback requested
===

Feedback would be especially useful on:

1. Whether lookup-only constrained saves, including the loss of traces seen
   only in constrained contexts, are acceptable for an initial version;
2. Whether stack_depot_fetch_into() is the right migration API while the
   pointer-returning stack_depot_fetch() remains hash-only;
3. Whether trie and hash records should share the physical pool budget;
4. Whether the 64 KiB handle-space limitation requires a different trie
   handle encoding; and
5. Whether retired slots should be reused only when a later insertion
   observes completion of their RCU grace period.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
Caleb Kan (9):
      stackdepot: share persistent stack prefixes with trie storage
      stackdepot: add KUnit tests for trie storage
      mm/page_owner: preserve accounting with countable stack depot records
      mm/kmemleak: print trie-backed stack depot traces
      kmsan: report trie-backed stack depot traces
      mm/slub: materialize trie-backed stack depot traces
      drm/locking: preserve deadlock diagnostics for trie-backed stacks
      scripts/gdb: reject trie-backed stack depot handles
      stackdepot: add boot-time activation for trie storage

 Documentation/admin-guide/kernel-parameters.txt |    7 +
 arch/arm64/include/asm/stackdepot.h             |   42 +
 arch/um/include/asm/Kbuild                      |    1 +
 arch/x86/include/asm/stackdepot.h               |   37 +
 drivers/gpu/drm/drm_modeset_lock.c              |    5 +-
 include/asm-generic/Kbuild                      |    1 +
 include/asm-generic/stackdepot.h                |   19 +
 include/linux/stackdepot.h                      |   81 +-
 lib/Kconfig.debug                               |   17 +
 lib/stackdepot.c                                | 1484 ++++++++++++++++++++++-
 lib/tests/Makefile                              |    1 +
 lib/tests/stackdepot_kunit.c                    |  473 ++++++++
 mm/kmemleak.c                                   |    4 +-
 mm/kmsan/kmsan_test.c                           |    4 +-
 mm/kmsan/report.c                               |   17 +-
 mm/page_owner.c                                 |    6 +-
 mm/slub.c                                       |   12 +-
 scripts/gdb/linux/stackdepot.py                 |    4 +
 18 files changed, 2168 insertions(+), 47 deletions(-)
---
base-commit: 3b1d6bd7bb11fd040bfa7b712486f5bd41a276cf
change-id: 20260807-stackdepot-trie-2de15a2dcf97

Best regards,
--  
Caleb Kan <ckan@cloudflare.com>


