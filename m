Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A347CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BE56B00AA; Thu, 21 May 2026 00:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CAA6B00AB; Thu, 21 May 2026 00:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB7E6B00AD; Thu, 21 May 2026 00:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A24B6B00AA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:02:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1165BA03BC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:02:48 +0000 (UTC)
X-FDA: 84790080816.20.B41C720
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02247180002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:02:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qWuU1V7e;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E/YNDgmqShx3e3fJDptG/XMLbuSaoABmDYTKAIO9WS4=;
	b=J73thdXmpreajjx5Fg5BuUZAeI2KSR+Go6QwrYUurnLxPy2H6sBNXmT5whVYLEdWcKxFTO
	VDU/NqiMgysDu3xNyPhq1yqbYZFEiMmbhd1lNW7RAuFbMnFle66nOIeNiODkaM8V4eeDqm
	wFiQMFYiAuxTdg3oW7oqbzroLJAWRwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336166; a=rsa-sha256;
	cv=none;
	b=gRcV6VJf6YD2X+GhvjJanHaQAGNvb8vNgGU0oFjQjWLF10LfMoSlrr8is9CR/cJXGRRZQQ
	jH3ieq2xXNbZmnK86/79U6rFsni3oFh4todqEken33oXxrm1x93PuQAH2udZppOR4VmHBS
	Wn53QkWLFHSm0mzQRvnail6T79EJHi4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qWuU1V7e;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336159; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=E/YNDgmqShx3e3fJDptG/XMLbuSaoABmDYTKAIO9WS4=;
 b=qWuU1V7eGqYe+PSwZYr8euYxqeppmmOmuP2GarcEh7cX/W1oKz4rJGdrF0EzkpIOOyzo+W
 gDRsbfGonbKBOMlOxSReGi9Ry+NMOLjKwqMkrNik5tDJmiSMlYO6kTkmFmfSkcsjIMk+VS
 +EAa6FrbKgsONzmeOlLg5kYlNDJHDWn3L8INDgdpZ7NKpUvC0hjQnrJh21BtWqh9f7YY/2
 ELjZDtDnkvlI1ZT2Tb/bzSpssPjIvsf1pTBeIq4CkqwUvTqJCgupODDJQEGSoB3splZ41l
 41uUeFsxY9QmXExEffNKizNpuUDzAFrSrSSJ5ISWtVAE0omFk6UeBiaYdDM0oQ==
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
Subject: [PATCH v2 0/7] mm: speed up ZONE_DEVICE memmap initialization
Date: Thu, 21 May 2026 12:01:17 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a0e83dd+2f8d01+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: 02247180002
X-Stat-Signature: 9z9om7ghppzbikn59nek8raagxsm3cqo
X-Rspamd-Server: rspam06
X-HE-Tag: 1779336164-845071
X-HE-Meta: U2FsdGVkX1/qLNnTHH2IUpKSZircI4tW94m7KGiN1J/HP0LXYzdDSp1ri4R9ubG/G2xIIiyk9rJWNG6OvnnRuMLpqVTo/jIO3F0iKTCJrY7fVqhb79T92h3rLV3/VEyTFR6blcS0HL/3pmEPVQ48Q5Frn4QkstBtPimE1UNc2NlMkkmMveBB9uEpB/8nRreoExrH0DAWbC76o8XF8TzUMSKxFHUOPQIVfD0/aVkzCAC2H50MTxNaLMw257p712vF4/FK2yFJ7DuOHxAX+HSM2uvQdtuDMN4OIdo5jjlbNoBnfCh7AEN/r8mxusaF94kc36lcaWuDwsUbWqJV0J8A3LBh7IxB37jVspPZGseMg7AP8GahFoYn3HEngr0yFzyBszEH2LWGSuSraC5iNl63h1hnhCKCyb0spRrxG/HYFdsS6bDvDgwZKiORN7zF0MBIEZOFKb2JGll0t2U1R2QjmY5v8K3oBa45Zq81n7ZZw76y7zjB2dZm+K6PqspqbbylvnyKenoze8La8LwkCf29l2gzs9TUy4YMaI8J88UUBxi5HpLEYBxM22cwM1CiDS5T/lrf9xoL6PXZCCgirdhmLmtJ9Ifps7fqZRWlxfGBIV6dBGF4JIuMBqSE8kqem9dalZ8T9X3pZ9gdSpprpWMQypYYke9NKgS+AGqIvDqUYehcf7G0/8cveMvy/21KsX4wcqG3EBVeWRQcggVV+9prySkIkxhGfiTxzxwtWCmc7lKE+ZEZ0RfQrY4iuucvx35z+CDbC5li1VbPFQcGL/4NE3AUDux2JKPYZegPT8wvRr6R6yIzbdnB9KiZO81yROFg5/tKBp2JhvAvZViamCUWBe5oXp4Ku98DHndFOhUm6+9cuTj72Rm0OrMfqVIcCv9X1WOoalQ1zYNOTLK5jTwpRReBfMcGczXGjsvOTKWQIZratD3yBfpodh/62I+ihn72GVR5W/hIHSfySKMjWl+
 lJP7u0gk
 gSWpwlggPhMMJ/7anQ3JXC3XGzhAFP/U/gFIQ/gZKS3lTZg/5J9UzrSAg8B1EYP+uip3jaAgGxFps7+/6+zz7DASYRyoZ0z+afFOabbPfqr/QI/RVWetr4+XxupfX7uHRaJdHrawz2t9iWT9ImPUdK+7raPK+y3tE//jxW0I/nWWK9mJXOj0JbkiK/Xdbv833ONv1YS8NXN4CcuIXk90koV2QzNdI7Wm5lo1dLlqXM7bKlGJdM+uLy7N/NHr5jEGwX+8beiIsW0nhaG757erX+TcxYoicrX4M220rmwArKqxur+h6tDPc3LrnPlKfqWMW58CBwC99lP+tMXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can spend a substantial amount of time
initializing large ZONE_DEVICE ranges because it repeats nearly
identical struct page setup for every PFN.

This series reduces that overhead in seven steps.

The first patch factors the reusable pieces out of
__init_zone_device_page() so later patches can share the same logic
without changing the existing slow path.

The second patch adds set_page_section_from_pfn(), so generic callers
can update section bits from a PFN without open-coding
SECTION_IN_PAGE_FLAGS checks.

The third patch adds a template-based fast path for ZONE_DEVICE head
pages. Instead of rebuilding the same struct page state for every PFN,
it prepares a reusable page template once and copies it to each
destination page.

The fourth patch extends the same template-based approach to compound
tails, so pfns_per_compound > 1 can also benefit from the fast path.

The fifth patch introduces memcpy_streaming() and
memcpy_streaming_drain() as a generic interface for write-once
streaming copies, with a memcpy() fallback for architectures that do
not provide a specialized backend.

The sixth patch extends x86 memcpy_flushcache() small fixed-size
fastpaths so struct-page-sized streaming copies can stay on the inline
path.

The last patch switches the zone-device template-copy path over to
memcpy_streaming(). It refreshes PFN-dependent fields in the reusable
template before each copy, keeps pageblock-aligned PFNs on regular
memcpy(), and drains streaming stores before later normal stores update
overlapping or dependent metadata.

The optimized path is disabled when the page_ref_set tracepoint is
enabled, sanitized builds remain on the slow path so their
instrumented stores are preserved, and the fast path falls back to the
existing slow path if sizeof(struct page) is not an integral number of
u64 words.

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
rebinds is used as the steady-state result.

Performance
===========

nd_pmem rebind, 100 GB fsdax namespace, map=dev
  Base(v7.1-rc3):
    First binding: 1486 ms
    Average of subsequent rebinds: 273.52 ms
  With patches 1-3 applied:
    First binding: 1422 ms
    Average of subsequent rebinds: 245.73 ms
  Full series:
    First binding: 1389 ms
    Average of subsequent rebinds: 111.08 ms

dax_pmem rebind, 100 GB devdax namespace, align=2097152
  Base(v7.1-rc3):
    First binding: 1515 ms
    Average of subsequent rebinds: 313.45 ms
  With patches 1-4 applied:
    First binding: 1422 ms
    Average of subsequent rebinds: 256.56 ms
  Full series:
    First binding: 1294 ms
    Average of subsequent rebinds: 110.24 ms

Li Zhe (7):
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_streaming() helpers
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_streaming() in zone-device template copies

 arch/x86/include/asm/string_64.h | 100 +++++++++++++---
 include/linux/mm.h               |  19 ++-
 include/linux/string.h           |  18 +++
 mm/mm_init.c                     | 198 +++++++++++++++++++++++++++----
 4 files changed, 294 insertions(+), 41 deletions(-)

---
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

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

