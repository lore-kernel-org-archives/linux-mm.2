Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E22BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714D66B0088; Thu,  9 Jul 2026 07:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C53F6B008A; Thu,  9 Jul 2026 07:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB706B008C; Thu,  9 Jul 2026 07:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 332116B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:25:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE9D21C6483
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:25:57 +0000 (UTC)
X-FDA: 84969008754.05.3976ECA
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 387E24000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:25:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kzjgJrZq;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4hnKT2U0BQq9BUwMBRD2qfbEirp8V8apnVJSe2FPr0M=;
	b=H7YMzh2dKd//TYMKsiu6O55QtKkBH7kCLPhq7Alf1auVx/VOJB04Quu8ClOhjGrz9MO9lZ
	bc+CkkPCoqikCIRpNp5cUHA3FIl+xQEamhXt9tHldqGMzjFAY2mdA0LskWge0+6tozB8w/
	MX6wqCkxNHG0JSVLTa21S1YRndM56i0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kzjgJrZq;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596356;
	b=Tp9NfHLWEBsTH6f2BplZwLOY0r1Iq+LWpLwqi+ylakYVFsG4MrzE5SNWvB5nG4EbdKVjbI
	gmc/cCDdL6rlPyv8M5ugAdIJZ8VkoF6+EUuyZHdM9i6bSjpydb3ipgR+wwggwp2/Gc526E
	9OayGJjoo+ZIOgnSkljWM8NznwpAyWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596348; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4hnKT2U0BQq9BUwMBRD2qfbEirp8V8apnVJSe2FPr0M=;
 b=kzjgJrZq+Ip8/EyWMUvE4wp8CkbAoKLcYPn4g00hN8za62oF13oyeF9GhAiXCl/nxcXG75
 21CAJnRu3e5ilsJEZZyRlmdhnq19TLCr2OYzhYwD7szWC0SJ/9b/9d8AoGVMowacFM60gc
 Kj/GkqzUpzTX3t5mpsKVwTxCYNPs/fhoqTOvuOwU5F9kXkbEbA8WTWGg1BseH13MM3WkkM
 jGlQx+UV+zVfIBHcJ16pnvljztYcBGGNY3r+m0js7Up7hQ5OronqKzAlseZSq12bnIuCvN
 NMIPy52FU4B/ye0ObiK9bmZF5Zxd86skd96svkEHSYYAmpqBOwdp9BNaWM7r0Q==
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260709112520.24857-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a4f853a+aa7106+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v6 0/8] mm: optimize zone-device memmap initialization
Date: Thu,  9 Jul 2026 19:25:12 +0800
Mime-Version: 1.0
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
X-Stat-Signature: 449y8c1geiy34ajp9eouxgh1fj9cbnqz
X-Rspamd-Queue-Id: 387E24000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783596355-400904
X-HE-Meta: U2FsdGVkX19QuahQkug5ePAU7zfb+xs1pSWXQLatrylwnMI2mKaEMsMmOfTqd4AiJEDMBLpFVoqK0RhBJHcSDmJd5R8u/ywXcU7A9g1+PFkLw4+mVoQd2Jbtg+Rhck8665v1625FBqz9kt7T6KyRR0WSd5x2a3zioNZ3YKrKn114emH41NkONj+Xt07+M9l7K22iBibzXV0Jqvo2ZPghK8/k8DqCqo4ImGgWOvrLgnpZnCPOzsYGE6tXUTZIEm11lQNWBGORbkEFd34cr7VetHebsuyx64nAfnhqt3Dmejja8iWK2NYl8ucKqLr74+bckbuyeqJw6qTtkx+BInB2nW+IU5Z7hYjQoNB3dQ6LXDbWAZwp76CwxR/ptpTpsEEuv3vk+7Vaf0SGWcqhSILUhie06z5WVWeI2/ymizS9duTpFhldKWts+JniqOXjCf/cU2PTK0ojOkprzwMp4jclyaLcm3YQ4Yi30SL0S1wqMBCfeuB//B4sxk99esOXWXdTTRZWh7IIdoy0zdiEED8l6cwGen643uYkcdd/c+ILzMexLzfjKXJUesT/zFgC+k8y3UDqWOfc3NZJC33YRzqLhBVUFsP/QndrjZQ943OztEgeBQzn0OPQeUupqt9/BKZSIDiaTz6Arr8+Ka04lYcu/0cQSBBdWXimV2qqrQHxLm5wKjkyUpxTJzamLtkg8uuNZsLOUysdQwx0o2pop7jGJiQOi1LZP7kWiBnP6uRWZ+8UBBop4Q3JoQI6C+4+6lThuX5WrTK/FBPFCwdi3oz1mt9zN0FO5vHLy/ZHlH/V+WlCgmjKrSk2HPfdmDxDnf7rYQ0jx6ljW+T8G9Y6QqDOtU+OTL3IDmyTuUtHsN8siLrKpScJA8ui1XAJ7Qz/lVAKDOXOAgAyfsZojUL8I4XwD0zesovkiLPVzlH1M58tbCPtYfJLybJZOXkvBhfYhVVyZFEoBSMCV0oY7JQh4YX
 3bdbuV4x
 RTPq0qg/a9UvOmQ9JIISXNbiL7mA0B2aTFa7aU+IHi5K0x4ddb9EXsNGe/QqjT0Wk6CRjvTKn6GApZyUUfq1QDfshtdy1AxHuvM1p5R9GUlkhac2D+dbx+CweuBWDzry72rswbvfmnOMOE0ZpwBhO4K2kzLk6YG/5ubwKPt12qbP9XA5QbnYn7oxgAqD/k1b3E3PKBSlsOgKD4oQh80Knu5msxzfjmAzqTCRqSpPkG01ddIQGe+EpW5zXjvWLcp6h0tz/PyV83B37z/a4CmD4N00C5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can take a noticeable amount of time when large
pmem namespaces are bound or rebound, because it initializes nearly
identical struct page descriptors one PFN at a time. This series reduces
that ZONE_DEVICE memmap initialization overhead by reusing prepared
struct page templates and, on x86, using memcpy_nt() for the template
copy path.

The main target is large fsdax/devdax pmem configurations, where the
cost of initializing the memmap shows up directly in nd_pmem/dax_pmem
bind and rebind latency.

Patches 1-3 are preparatory cleanups and helper extraction. Patches 4-5
add the template-copy fast path for head pages and compound tails.
Patches 6-8 introduce memcpy_nt()/memcpy_nt_drain(), extend the x86
fixed-size memcpy_flushcache() inline cases used by that helper, and
switch the template-copy path over to memcpy_nt().

The fast path remains disabled when the page_ref_set tracepoint is
active, and sanitized builds stay on the slow path so their instrumented
stores are preserved. Architectures without a specialized memcpy_nt()
backend continue to fall back to memcpy().

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series applied:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average rebind time by about 60.4% for nd_pmem and
56.4% for dax_pmem.

As an additional data point, I also ran a smaller set of measurements on
the same physical x86_64 host with a 100 GB PMEM region created via the
memmap= kernel command line, configured as fsdax and devdax namespaces
with map=dev and 2 MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series. The physical-host numbers below are included only as
supplemental evidence that the same optimization also provides a similar
benefit on a non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
once, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.2-rc1):
  nd_pmem / fsdax: 179 ms
  dax_pmem / devdax: 264 ms

With this series applied:
  nd_pmem / fsdax: 82 ms
  dax_pmem / devdax: 113 ms

This reduces the measured rebind time by about 54.2% for nd_pmem and
57.2% for dax_pmem on that setup, which is broadly consistent with the
VM results above.

As another supplemental data point, I also measured the test_hmm.ko
module on the same physical x86_64 host, using the test_hmm.ko setup
from the previous discussion that times ten 64 GB
memremap_pages()/memunmap_pages() iterations during module insertion[1].
By default, module insertion initializes two DEVICE_PRIVATE dmirror
devices, so two avg memremap values are reported; each value is the
average for one 64 GB chunk.

This is not the primary target workload of the series, but it exercises
the same large ZONE_DEVICE memmap initialization path and shows the same
direction of improvement.

Base (v7.2-rc1):
  avg memremap reported during module insertion: 116689362 ns, 116539263 ns

With this series applied:
  avg memremap reported during module insertion: 54607108 ns, 54458236 ns

This corresponds to about a 53.2% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.

[1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/

Li Zhe (8):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_nt() helpers
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_nt() in zone-device template copies

 arch/x86/include/asm/string_64.h |  78 ++++++++++++-
 include/linux/mm.h               |  15 ++-
 include/linux/string.h           |  23 ++++
 mm/mm_init.c                     | 186 ++++++++++++++++++++++++++-----
 4 files changed, 273 insertions(+), 29 deletions(-)

---
v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v5->v6:
- Rework patch 6 so the x86 memcpy_nt_drain() helper uses wmb()
  instead of an open-coded sfence, while architectures that do not
  override memcpy_nt() keep the generic no-op drain fallback.
  Suggested by Borislav Petkov.
- Rework patch 6 to use the usual self-macro override pattern for
  memcpy_nt() and memcpy_nt_drain() instead of a dedicated
  __HAVE_ARCH_MEMCPY_NT feature macro. Suggested by David
  Hildenbrand.
- Drop the default: case from pagemap_resets_refcount() and drop the
  WARN_ONCE() after the switch so newly added enum memory_type values
  remain visible to compiler switch checking. Suggested by David
  Hildenbrand.
- Drop the unnecessary empty set_page_section() stub from patch 3, keep
  set_page_section_from_pfn() as the only !SECTION_IN_PAGE_FLAGS no-op
  helper and fix its indentation. Suggested by David Hildenbrand.
- Rework patch 4 so the reusable head-page template is seeded from the
  first loop iteration, keeping the main loop intact while ensuring the
  first page is initialized only once; also drop the extra template
  memcpy helper, as suggested by Alistair Popple.
- Rework patch 5 similarly for compound tails: seed the reusable tail
  template from the first tail-page iteration so the first tail page is
  initialized only once, while keeping the main tail loop intact, as
  suggested by Alistair Popple.
- Rework patch 7 to rename the internal fixed-size MOVNTI helpers to
  movnti_*(), keep memcpy_flushcache() as the externally visible
  wrapper, fold the new 32/48/64/80/96-byte copies into the main
  fixed-size switch, clarify in the code and changelog that the
  ZONE_DEVICE template-copy path relies on the 64/80/96-byte struct
  page copies while 32/48-byte copies stay inline as well, and drop the
  separate alignment check based on the physical-host microbenchmark
  results. Suggested by Borislav Petkov.
- Run v6 VM spot checks for the fsdax/devdax map=dev paths. The
  results stayed in the same ballpark as v5, so keep the previously
  posted v5 full-run numbers in this version instead of replacing them
  with another partial data set.

For changelogs of earlier revisions, please refer to the v5 cover letter.

-- 
2.20.1

