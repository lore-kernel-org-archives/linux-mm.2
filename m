Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909D4CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB776B008C; Tue, 26 May 2026 23:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C3F6B0092; Tue, 26 May 2026 23:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AC26B0093; Tue, 26 May 2026 23:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE2C6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:38:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48D751C03BD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:05 +0000 (UTC)
X-FDA: 84811791330.12.318E275
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id C0B4120007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iBMN3MJx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/qdLUAhg4q/WASG3TkbS7LjyH1II/YAwBuKSGkt3vIY=;
	b=z+io3BIlP3N7hdFfm2zIhpWWv7Q1DuebIg/z2FMN++cLo/ZXNlVqAQod5APeMXkfEys5yK
	joRVmFwL+Epwwh60mR+djh8l35MY3kIVPBnNX6Tnw4ey+jbiHgyta3HLs4YhT0+zyqL91K
	sLYzOBlvCasFOMn/S6nDsHL5MaC1UOY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iBMN3MJx;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853083; a=rsa-sha256;
	cv=none;
	b=z8cufp+lXEtcUdqmRRZxXSEzeQvsH+ACMX+1FNKUZ//BxGHxblJwX6G5yuvXaPm00JFeIl
	v81prCSRQ0YdaOVDMLAsLhgFGw5HmU4EvxsVaVltVsTwI1VsLWyVWf6lgQSxGbs0qlI/vm
	mx4omNL7W7tDCS9C7gEeWvNf6LqXV7A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853077; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/qdLUAhg4q/WASG3TkbS7LjyH1II/YAwBuKSGkt3vIY=;
 b=iBMN3MJxkfS8l74oUA/EbdOyXWaLolQcHzhvXGOoh8cPrbyXCFZF0Njz3j5sF7yeiv/ADU
 uPrjmvIBgh/SvgOB8E6eIoMKhzh7reMadrja2wSx+kRdhdfLsCR073+MR2mH//0UEzFywj
 NpvcAgG1nMPsfvig9K08zPy2k1hfRqWXv4oLeAnSqkehA3WZM4j2CV+jehx7uIAffLGmLm
 f0n8bUp27usINwiYpgdDWfqyY7JIXiGs8H5ZI04raTGozepz2TrLkLfEZmWEvBGFZV49vO
 pWJJEiOut4zGAaFjDNhq5o1No38CZK3wrrKIV0+GlRY8fUUFn5FPpQovWbB9uQ==
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a166713+26e6b9+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Subject: [PATCH v3 0/8] mm: speed up ZONE_DEVICE memmap initialization
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:28 +0800
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Message-Id: <20260527033636.28231-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0B4120007
X-Stat-Signature: ncjfgao8psa14wh8h9xdj5xbztdge9g4
X-Rspam-User: 
X-HE-Tag: 1779853082-148802
X-HE-Meta: U2FsdGVkX1/n4sKSnFlj9Q8Z0ke4mCJTERyd7ORbnTfUiOeuodwd1XSrjlTRgk+XMSkTWiQZ/yoGJmReAieElyBdEr0BNcyZktKrxS20LfFpLdssQ0SJMj4k3/I2qF7Ao+4Foy+CYIJVK5zwI0M/ZPWs9uUnGRX8EkQ1hYUA1zlq9RblzNX79nw7XUXSfp4lb7EL38B1GdEuMgiTa7llzwJUn/ET/s6t5iQfgRaAndLFk9IAQJAGgEdiSEFloy53FSkn3qxx6aKBxrZFDLY3WiIS6Wo02TMbV5c7pZLu9d67C+MF/9+a1WHZ3Niz4CMC4mXCcDTSiXAPwvadz9lMN2IQY1q6Ux3t/bjPVzgg9e1OM4ZfP4t+jDw32FDw7qSsgLv0YmCOQGAPv82Xh55qmwPRURJAinWA8W3mr7k0S2Sww/9gTbY4GN6ovoYwfn45EedbYecAhGyAjlu97SlMYbMlM92R6TikCx0iqmOYwsPOqw1CT/cdYH0I1pjp/rktfz+1ImlWdKm1s1S0DI4LwU5/we4bqSfkTZc9/lYytgNk430z7C6YWKrQj+cAhph34Xf7M4mvIXNizHuLE1srWVvJ8KMSX2o6ZoqgL/K/NeYlf632cSlFC//eXKtiHwszXrB5pfScoVbcNLehLoR4foA0V7aplCh92Kl3sDGs9bAhLvaWdjOIA9tZHYvt1ccpUj5LGZfHvSVpe0QMBgE3KWyEEJ8WBVAnmD7T1PeOFhFTzt63SLubA1GV9NEiN8pqKL9OjZiwT5JgFXU3CJYIM2HQa4JJHHe8j/O5T1V51BDp5wEQ+ndwDo2SYksMS9agFPH+JPDKZOZkzMQ2ShgYp/+2Cos8mDHgyvOAYw5+0UWeEqFIXECss85bVeXYFFiDXuOpLOBzDZbqiXG1dDVFqyTmZuKgbzw3mB0asNyAv3BAFI7OXxV8Lvp8HTBQW5EtfKmyC2ZfrzOaXAHvAuq
 5GS6tDdW
 e4XgUip3N13ca2gRFiPrXg5TkGKAB4l3cpcELS9JubmG+XgpgrH2f34TgHWOGnKobTM36hU1nZdqdX7poL+k7EJkBOuhrYChemgfd3imVXO3wAyQAh/MC8fNV5PJmYsDo7XIunL+SMrs7lbSRTgFLbm35cHLxp9m3WcBpndracUBi3odr3XSk17xvEkesK7esJYXkY2B8bAlRz3hdFYx2fuQ25yb0WotivDwsMyrJVs/xA+U/FcDZbzfQ+RT++dghWLXJvCrKv2sHALDo6YO5v/z6TOI08xe0axt2TiSoY8/ortuLaDxAMHpZcZp3X7sHbq93KXxF/SNfHZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series reduces latency in paths which create or recreate
ZONE_DEVICE memmaps. Pmem hotplug is a concrete example.

memmap_init_zone_device() can spend a substantial amount of time
initializing large ZONE_DEVICE ranges because it repeats nearly
identical struct page setup for every PFN.

The series addresses that overhead in eight patches.

The first patch updates a stale comment in __init_zone_device_page() so
it matches the current ZONE_DEVICE refcount rules.

The second patch factors the reusable pieces out of
__init_zone_device_page() so later patches can share the same logic
without changing the existing slow path.

The third patch adds set_page_section_from_pfn(), so generic callers
can update section bits from a PFN without open-coding
SECTION_IN_PAGE_FLAGS handling.

The fourth patch adds a template-based fast path for ZONE_DEVICE head
pages. Instead of rebuilding the same struct page state for every PFN,
it prepares one reusable head-page template through the existing slow
path, refreshes the PFN-dependent fields before each copy, and then
copies that template into the destination page.

The fifth patch extends the same template-based approach to compound
tails, so pfns_per_compound > 1 can also benefit from the fast path.

The sixth patch introduces memcpy_streaming() and
memcpy_streaming_drain() as a generic interface for write-once copies,
with a memcpy() fallback for architectures that do not provide a
specialized backend, or for transfers which an architecture-specific
backend cannot safely handle with non-temporal stores.

The seventh patch extends x86 memcpy_flushcache() small fixed-size
fastpaths for naturally aligned copies, so common struct-page-sized
streaming copies can stay on the inline movnti path while preserving
forward store order.

The last patch switches the zone-device template-copy path over to
memcpy_streaming(). It keeps pageblock-aligned PFNs on regular memcpy()
so pageblock setup can immediately read page metadata back through the
usual helpers, and it drains streaming stores before later normal
stores update overlapping or dependent compound-page metadata.

The optimized path is disabled when the page_ref_set tracepoint is
enabled, and sanitized builds remain on the slow path so their
instrumented stores are preserved.

Testing
=======

Tests were run in a VM on an Intel Ice Lake server.

Two PMEM configurations were used:
  - a 100 GB fsdax namespace configured with map=dev, which exercises
    the nd_pmem rebind path (pfns_per_compound == 1)
  - a 100 GB devdax namespace configured with align=2097152, which
    exercises the dax_pmem rebind path (pfns_per_compound > 1)

For each configuration, the corresponding driver was unbound and
rebound 30 times. Memmap initialization latency was collected from the
pr_debug() output of memmap_init_zone_device().

The first bind is reported separately, and the average of subsequent
rebinds is used as the repeat-run result.

Performance
===========

nd_pmem rebind, 100 GB fsdax namespace, map=dev
  Base(v7.1-rc3):
    First binding: 1486 ms
    Average of subsequent rebinds: 273.52 ms
  With patches 1-4 applied:
    First binding: 1422 ms
    Average of subsequent rebinds: 246.65 ms
  Full series:
    First binding: 1285 ms
    Average of subsequent rebinds: 114.31 ms

dax_pmem rebind, 100 GB devdax namespace, align=2097152
  Base(v7.1-rc3):
    First binding: 1515 ms
    Average of subsequent rebinds: 313.45 ms
  With patches 1-5 applied:
    First binding: 1422 ms
    Average of subsequent rebinds: 240.42 ms
  Full series:
    First binding: 1331 ms
    Average of subsequent rebinds: 99.37 ms

Li Zhe (8):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_streaming() helpers
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_streaming() in zone-device template copies

 arch/x86/include/asm/string_64.h | 157 ++++++++++++++++++++++---
 include/linux/mm.h               |  19 ++-
 include/linux/string.h           |  20 ++++
 mm/mm_init.c                     | 195 +++++++++++++++++++++++++++----
 4 files changed, 352 insertions(+), 39 deletions(-)

---
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v2->v3:
- Add a leading comment-only cleanup patch to fix the stale ZONE_DEVICE
  refcount comment, so later refactoring patches no longer carry that
  stale wording forward.
- Rename the refcount-policy helper to pagemap_resets_refcount() and
  make it a bool predicate. Suggested by Mike Rapoport.
- Update the reusable template in place from the first template
  fast-path patch onward, so later patches only change the copy
  primitive instead of introducing an intermediate post-copy fixup
  step. Suggested by Mike Rapoport.
- Clean up helper indentation and use early continue in the
  compound-tail loop. Suggested by Mike Rapoport.
- Narrow the x86 memcpy_streaming() backend to transfers that can stay
  entirely on the non-temporal store path, keeping zero-length and
  unaligned cases on memcpy(). Suggested by Andrew Morton.
- Restrict the x86 memcpy_flushcache() small-copy fastpath to naturally
  aligned cases, add volatile/memory clobbers, and preserve forward
  movnti store order. Suggested by Andrew Morton.
- Drop the obsolete struct page size/alignment eligibility check from
  the template fast path now that the intermediate patches use
  memcpy() and the streaming backend has a safe fallback.
- Refresh the benchmark results.

v1->v2:
- Move the pageblock-helper split into patch 1, and add a dedicated
  set_page_section_from_pfn() helper so generic callers no longer
  open-code SECTION_IN_PAGE_FLAGS handling. Suggested by Mike Rapoport.
- Drop the v1 32-bit gating and document instead that CONFIG_ZONE_DEVICE
  is 64-bit only because it depends on MEMORY_HOTPLUG. Suggested by
  Mike Rapoport.
- Replace the v1 BUILD_BUG_ON() struct page layout checks with a runtime
  fast-path eligibility check that falls back to the slow path when the
  layout is unsuitable. Suggested by Mike Rapoport.
- Rename the template fast-path helpers to zone_device_* names for
  clarity. Suggested by Mike Rapoport.
- Replace the v1 open-coded arch_optimize_store_u64()/drain() approach
  with a generic memcpy_streaming()/memcpy_streaming_drain() interface,
  and move the x86 optimization under memcpy_flushcache(). Suggested by
  Alistair Popple.
- Split the old v1 streaming-copy patch into three patches: introduce
  the generic helper, extend the x86 backend, and then switch mm over
  to the new interface. This is part of the memcpy-based rework
  suggested by Alistair Popple.
- Refresh the performance section and report whole-series results as
  series-level numbers.
- Fix a missing memcpy_streaming_drain() in the compound-page
  initialization path, following review feedback from Andrew Morton.

-- 
2.20.1

