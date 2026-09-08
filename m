Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3529C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55AF6B0092; Tue,  8 Sep 2026 09:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06F26B0093; Tue,  8 Sep 2026 09:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4FC6B0095; Tue,  8 Sep 2026 09:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AACB76B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:13:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E15E140485
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:55 +0000 (UTC)
X-FDA: 85190637630.06.59F5E56
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 78DED4000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:13:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=STCEYKvr;
	spf=pass (imf07.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vo8u28j4GyXE0RpSvRuCGjIeNosarp7/Ns5KHxaIM7w=;
	b=1t1aEvH0pyPLDhZpCZ8OxnyJeWgnoiwbggvYwd50Bj+PXZVfi3IMfFW/TQFqCIl/VfiXSx
	u8xNJKD4RRQpwm28OiBNZ2KdLwGDQowC2/5opvz0BS60ayBPpcSfby8wF+OB2MuZPbuPyE
	TOv7fclv8eFMg+IwW1X8tISyaECC2S0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873233;
	b=5LwSXKvdCb7QEBZ6YvkVDN4/+dUnQqSkP74HcDFd/whr4rmxXNd9FGm/E4AzH3qAYhkx//
	0zbk4JXd2OoAkTvp7hfA8f0zU9vzew5P8JUyILRdJcbUkSDRpz+KSTZoF1U9tpLOIXBmoN
	GOdTL2j3B49ldm34A0parSbvYectPoc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=STCEYKvr;
	spf=pass (imf07.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c250f28f1cdso741358266b.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873232; x=1789478032; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vo8u28j4GyXE0RpSvRuCGjIeNosarp7/Ns5KHxaIM7w=;
        b=STCEYKvrMcEtkNlSW9A88ic9fI/yaCdE2K9RtKgkNvdkSVfandMTp3EPqZDtDtdX7o
         6w3GKWPyy3LrFwNWDOCTVJMOdrdtvfkJ0zVvjHR54cLpfAM0p39mi1BLcLMOH49ZFmJZ
         1YoBcvTvYX9kBn/BJXgBgHSEDVkfYnNc9kre5iHeksZDWcv6K4db709I2N+vmF+9pJKA
         3vI2LswaO+76DbXEBq16ipjqZ+Ui0xPzzoInjGSR0pWkJ7iVmW4YD1AVtIBXesHmvyC6
         1p3+YbJmBol1XqFbLMGTVZ2X6f5E4RMgPBNk8yEdHzZ5GDvdmDbQMGaedcS/4CPYFKQG
         wOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873232; x=1789478032;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vo8u28j4GyXE0RpSvRuCGjIeNosarp7/Ns5KHxaIM7w=;
        b=Dd5IxBs7LhlqCXqe6DEK8JT2BLcd1hvq2/c1t9UfcfZyhd81wVcA8nZ/Z2fd8CmPjN
         HfWzxXuj7mAzyPM+vm1fq5hIKw1g3uk/3GmVJVHkyIhW01hDbD7FzhcglB6X1Zhv35FQ
         1qSxhMTtDJgPTh0UlGq4+svstvJPRt2TZrpvgEXvPFVbdIFznOfjSb0STREnd1Ob24Dc
         psx+6U/NgsUd3gzsCT36ypvl3ystHotnHljrVCjf7PHMdKN+Msk0gJGhmNNWfaucEMg9
         IlFrK2dALclORAMBwITiNJ6DtDhDNSlkOPmJqI1qVGH4tZPySVw9GcFZWsSsXVUaMa50
         nC1A==
X-Gm-Message-State: AFuF++mKdJ0RBK3hL5yCc50KKM2Zr5tJGWGpvwTdcJNV0zbZc7exJOvJ
	3w7p/i2rciItoowDt+gUScdCrkcc923gSiwo9EuIXBe04Mevq2B2Px+6
X-Gm-Gg: AYBFou2u2/vYr63kpvJbEhm8h6P1mv+LjisTXi1NyeOh8GRGk0rhKJE0vXhrRJgqTnv
	3LxrElX2Z6+H1MR/JwY4XBlJaFDoyJZyq17fFkFfBrZdTON1EVU0nopJeVQ2mhIk8/ILEfBcCSW
	b4rg4DUwYcvXdu4J49JW142Lufdgh3hOXUMyYd9UfxUJmgVspIqOuE0BETE2q81DdADLj3Av8ZA
	HPNXTNAguQH5+lm7Om29Awon5fvxBeAuodrvJDwif2+CqrFo56wX2jMUz2M0DgsW8StvrmxtD3M
	yp5pFopuO8LTJKjQbrOgeePv6l5TYibC6W8uuq8x57UyoVi2wZRoKcsUTEBzKhD+jQUzMCdx2QP
	krPkKeAQZxMdWNl5r5h75EU4bx6Q3934765VoBk1kSc8dblD+9Vni5PaTVKrDk+HKtZ/iFhVYcu
	TGWhjplcktJop9EHvv/+SKLSy0+6jeNCXDhyzFeDbtM4wZuHov8UcNE8byfC3O
X-Received: by 2002:a17:907:934c:b0:c25:c954:faf2 with SMTP id a640c23a62f3a-c260ca20979mr1124208466b.21.1788873231550;
        Tue, 08 Sep 2026 06:13:51 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:13:51 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Subject: [PATCH RFC v2 00/11] stackdepot: reduce memory use for persistent
 stack records with a trie
Date: Tue, 08 Sep 2026 14:13:33 +0100
Message-Id: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNyw6CMBREf4XctTVtDQ9dmZj4AW4Ni3J7kSpS0
 haiIfy7BZYuZzJnzgSenCEPp2QCR6PxxnYxyF0C2KjuQczomEFymfGC58wHhS9NvQ0sRJJJTSJ
 VUmN9zCFSvaPafNbHO9yuFyi30g/VkzAsX8usMT5Y9129o1jHm0L8K0bBOEsPRc5RiSwV1RlbO
 +i6VY72aN9QzvP8A3s9S5/KAAAA
X-Change-ID: 20260807-stackdepot-trie-2de15a2dcf97
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Stat-Signature: kfa9ydmjqumoq8w715kqq3jn7e6imc41
X-Rspam-User: 
X-Rspamd-Queue-Id: 78DED4000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1788873233-797987
X-HE-Meta: U2FsdGVkX1+CwW6NWBhU5j5Tw44sbU5RFfrlReB7TRpwHHrT8eydjf+t9DKg3iKPgwFj5SpE9HW1w9rMChkcak2AGbPq21brJjNrx8eK9zcKSzbMVYspk6BvoeCBVHyMiQYbbpjzvkNpcL5Xx6Emktnmb5gLvTysKNY5yHB1jjpnsGL1Zh+BmB/taRw0LrJAOVM5R5pmnSyGzPomz6L7n/5aFqWEntmim4jOSrGgxFMtH1PXjfjEMORnpB4yMj84LZ9gvA0kBKa0Or08GRT7sRC25Tgy/YjMCTO/Bw+KovSiWhJYsCb9xoQt8zuX0v9sq6s20sKs6Ybyv2j3bOmiiqka6vEqA5353oT/PzOredMbVcSrlGIQ6xWizmNOcpZe36107l6rYplxa5ecWTbH2gzmwtBCnDle7dxCRGEXj21pGghshHB9zT34U6vsvSupVWxIn1/z6QPv27jtkeBcX4FUWgrzRtmofZI0jHUp9PYoPvEN9rNf8lF33IkGtHKoeFKpe9AplnI315p+38+EXdKF6sDuN72jOszTzuyDFqFzPOUZGzXybTzV7sDkWYd7cu1kHW5YLVTzTNOoD6ifN7umK7UwhkiyRg7VwjK3qTHrKz8U+PhxeTs88t9X1+rIIwMLJ5NdgpMJrZ5+ZML8VoHGtK1GuN5TTCYrBIYsg+jKBpmPOpxYTe0oGwJOub+X4vOGXkQAlanLSnbekE4Bv9lMLLlbLo5+x0dDb/Hf6ML0RrzpJYv/ADvIq8WhJ73d8ZwoIpyXKPgD+koxFKpTpZwxlQcV4Jp0afyB55Pg10fc2yi6q6n33e6aBPEiw0FPGAkrY5OWF0UARyzK2SpAptlRpN7y8zZlUFKwTC4KCHbvKWkLjUchYLdLdUuADFENaerUNYXlOdrNpk+u9ycix7xXaMRQ9Zd7dcNseMlLr9pMXcnPUJrwNOIp9uhaMTDIwUSy+HSMD8HLxleli1N
 0ECcc2u9
 aiaHOpB42VRaW1i+0nQVzSgZ77TdPWptn8v/pRK5c66D3STxYM84ZikZEYyZpRGN/c/CPg5v6FjI8scNMxO7SOiVTeg4ccKwrNOCme6yOOnHXyDL4Y315sJDHy+rijFtp1vLTx9NpTGuAGtz6EQnmiHjaDMfjspJGI1Ncr1CNL8iwsxy/ZGmB2K44xzZRusqxbCqnDp2dkn9OY9cGkF9fmCirLQO2TRmCchDc6B99SUTtJst8aa8JTu9M0VXIbInaPVrlT9Fojy/ZNaNgRa2DTAzt6dj6VKqB4pPkCtMb3jWsV51aYHcT1eRASOCGR4A+n27tCwcmEAoTClDmjxaim7Z4GBxM4OkMUABpHJWoUdy+ntgdZR94quMLWC+6EJ3Ih87dE0FljFCENz53ajR/Fl9VN9FxbfvLULlZ/i9++ll82k2qeJc3U3BOPGNYZ82ahZsCDiw6ysRXAE9JKf/k44xC2jVAVfdF1heuLQn7rbSjomFCeL1QC+b6l15Q5v3C340sCa10fTOZmFTc5R7NUsk0asF5NZMjLQ+Pxu83RpAF7FcfKZY8N5qbsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series reduces the memory used by persistent stack depot records by
sharing common frame prefixes in a path-compressed trie.

Cloudflare runs KASAN on pre-production servers so allocation and free
stack traces are available when diagnosing memory-safety bugs. On some of
these servers, stack depot exhausted its pool budget even after we raised
stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
persistent trace returns no handle and a later KASAN report can lose the
history needed to explain the bug.

With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
Doubling the limit again would allow 1 GiB, but it would not change the
linear growth: the hash backend shares identical complete traces, while
two traces that differ by one frame are still stored independently.

The trie is opt-in and disabled by default.

Backend behavior
================

When the trie is enabled, a persistent save uses it unless the caller sets
STACK_DEPOT_FLAG_GET or STACK_DEPOT_FLAG_COUNTABLE. GET records can be
released. COUNTABLE records remain hash-backed because page_owner needs a
stable struct stack_record and its count field.

RFC v1 only looked up existing trie records when a save was not
permitted to allocate. RFC v2 also makes one best-effort insertion
outside NMI using pool and side-table memory that stack depot already has.
It does not allocate, sleep, retry, wait for RCU, or fall back to the
hash backend. If the trace cannot be recorded, the save returns 0.

An NMI save remains lookup-only. It can return an existing trie handle, but
a new trace returns 0. The hash backend can sometimes insert from NMI when
it already has enough pool space.

Both backends share stack_pools and the stack_depot_max_pools limit. A pool
used by the trie is unavailable to hash-backed GET and COUNTABLE records.

Design and API
==============

Each trie node stores a run of frames and branches only where traces
diverge. On arm64 and x86-64, a frame uses a compressed 32-bit payload
only when it can be decoded back to the exact original address. arm64
stores a signed offset from _text. x86-64 stores the low 32 bits when the
upper 32 bits are all set. Other frames remain full-width.

Trie handles contain dense stack IDs. A sparse table maps each ID to the
node where its trace ends. Fetch reconstructs the trace by following parent
links.

Insertion is serialized, while lookup and fetch run under RCU. A new stack
is published only after every required reservation succeeds. Replaced
nodes and child arrays are reused only after their RCU grace period.

Trie records are not contiguous, so stack_depot_fetch() remains hash-only.
The series adds stack_depot_fetch_into() for caller-owned storage and makes
stack_depot_print() and stack_depot_snprint() work with either backend.
Kmemleak, KMSAN, SLUB, and DRM use these interfaces. page_owner remains on
COUNTABLE hash records, and the GDB helper rejects trie handles.

Patch 1 fixes final-pool preallocation. Patches 2 through 9 prepare the
API, consumers, tooling, and architecture hooks. Patch 10 enables
trie-backed handles and adds a boot parameter that is disabled by
default. Patch 11 adds trie KUnit coverage. Trie handles do not become
reachable until all API and consumer changes are in place.

CPU cost
========

The benchmark was pinned to one CPU and inserted 32,768 distinct 32-frame
stacks on KASAN-enabled Linux 6.18.48. Within each group of 64 stacks, 75%
of the frames were shared and all frames were compressible. The insertion
order was shuffled, and the warm save-hit and fetch phases replayed the
stacks 32 times.

                         arm64 CPU ns/op         x86-64 CPU ns/op
                         hash       trie        hash         trie
Insertion                 777      9,417         792       11,269
Warm save hit             945      1,287         623        1,012
Fetch                     251        511         123          476

The main cost is first insertion, which was about 12 times slower on arm64
and 14 times slower on x86-64. A warm save hit was 1.4 to 1.6 times slower,
and fetch was 2 to 4 times slower.

Memory use
==========

I collected stack depot state from four live KASAN servers using the same
kernel revision, 4 KiB pages, and an 8,192-pool limit. The servers remained
active, so the values below are rounded.

                              arm64                 x86-64
                        trie off trie on      trie off trie on
Run time (hours)              61      64            65      67
Stored records              162k     87k          498k    217k
Registered pools           2,630     925         8,192   1,940
Pool budget used             32%     11%          100%     24%

The trie-enabled x86-64 machine used less than a quarter of the pool budget
while the trie-disabled machine reached the limit.

The machines ran different workloads and stored different stacks, so this
is not a controlled comparison. Exact memory savings depend on the
workload.

Stack use and limits
====================

Before this series, the KMSAN report path that prints an origin used 768
bytes of stack on x86-64 with Clang 19. RFC v1 increased it to 1,264
bytes. RFC v2 reuses KMSAN's existing scratch array and uses 752 bytes,
slightly less than the tree before this series.

RFC v1 also materialized as many as 256 frames on the stack. At that depth,
stack_depot_print() and stack_depot_snprint() used 2,072 and 2,104 bytes.
RFC v2 processes 16 frames at a time, reducing them to 184 and 200 bytes.
Kmemleak and the converted SLUB callers each add one fixed 16-frame array,
or 128 bytes on 64-bit systems. DRM uses the bounded snprint path without
adding a trace array.

A node's child array must fit in one pool. Each child represents a
different next frame after a shared prefix. For example, allocator stacks
can share the same initial frames and then diverge at many different call
sites. On a 4 KiB, 64-bit system, one node can hold 1,024 children. The
largest observed node had about 835 children. An insertion that would
add a 1,025th child fails; existing records remain valid.

Trie IDs use handle values left unused by the configured pool limit. With
64 KiB pages, the default stack_depot_max_pools value leaves no such handle
space. The limit must currently be lowered to enable the trie; otherwise
trie initialization fails and the hash backend remains available.

Testing
=======

I ran the common KUnit cases against both backends with a 64-frame maximum.
Trie-specific cases also ran at 8 and 256 frames, including a 64 KiB arm64
configuration. The tests cover public API behavior, each insertion shape,
old handles after topology changes, and compressed and full-width frames.

I also ran the patches with PROVE_LOCKING and KCSAN, ran KMSAN tests with
both backends, built with arm64 GCC and x86-64 Clang, and booted with the
trie disabled and enabled.

Questions
=========

I would particularly appreciate feedback on:

1. Is it acceptable for an NMI save to look up an existing trie record but
   return 0 for a new trace, while a non-NMI save that is not permitted to
   allocate gets one best-effort insertion attempt?

2. Is the roughly 12 to 14 times higher first-insertion cost acceptable for
   an optional backend, given the smaller cost for warm saves and fetches?

3. Should stack depot reserve some of stack_depot_max_pools for hash-backed
   GET and COUNTABLE records, or should both backends continue to share the
   limit on a first-come basis?

4. Is the 1,024-child limit acceptable for an initial implementation, or
   should child arrays be allowed to span multiple pools?

5. On 64 KiB systems, is requiring a lower stack_depot_max_pools value
   acceptable, or should trie IDs use a different handle encoding?

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
Changes in v2:
- Expanded the motivation with KASAN systems that exhausted the
  32,768-pool limit.
- Reordered the series so APIs, consumers, tooling, and architecture hooks
  are ready before trie handles become reachable.
- Added a best-effort insertion outside NMI for saves that are not
  permitted to allocate.
- Reduced trie allocator bitmap scans and added CPU benchmarks.
- Reduced KMSAN and stack depot printing stack use.
- Documented the shared pool budget, child limit, and 64 KiB handle limit.
- Expanded KUnit coverage for public APIs, insertion shapes, trace depths,
  and frame encoding.
- Link to v1: https://patch.msgid.link/20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com

---
Caleb Kan (11):
      stackdepot: stop preallocating after the final pool
      stackdepot: add caller-owned stack trace fetching
      mm/page_owner: preserve accounting with countable stack depot records
      mm/kmemleak: print trie-backed stack depot traces
      kmsan: report trie-backed stack depot traces
      mm/slub: materialize trie-backed stack depot traces
      drm/locking: preserve deadlock diagnostics for trie-backed stacks
      scripts/gdb: reject trie-backed stack depot handles
      stackdepot: add architecture hooks for compact frame storage
      stackdepot: share persistent stack prefixes with trie storage
      stackdepot: add KUnit tests for trie storage

 Documentation/admin-guide/kernel-parameters.txt |    7 +
 arch/arm64/include/asm/stackdepot.h             |   42 +
 arch/um/include/asm/Kbuild                      |    1 +
 arch/x86/include/asm/stackdepot.h               |   37 +
 drivers/gpu/drm/drm_modeset_lock.c              |    5 +-
 include/asm-generic/Kbuild                      |    1 +
 include/asm-generic/stackdepot.h                |   19 +
 include/linux/stackdepot.h                      |   83 +-
 lib/Kconfig.debug                               |   17 +
 lib/stackdepot.c                                | 1650 ++++++++++++++++++++++-
 lib/tests/Makefile                              |    1 +
 lib/tests/stackdepot_kunit.c                    |  582 ++++++++
 mm/kmemleak.c                                   |    4 +-
 mm/kmsan/kmsan_test.c                           |    4 +-
 mm/kmsan/report.c                               |   28 +-
 mm/page_owner.c                                 |    6 +-
 mm/slub.c                                       |   12 +-
 scripts/gdb/linux/stackdepot.py                 |    4 +
 18 files changed, 2454 insertions(+), 49 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260807-stackdepot-trie-2de15a2dcf97

Best regards,
--  
Caleb Kan <ckan@cloudflare.com>


