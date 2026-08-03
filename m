Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E5DC55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FFE56B007B; Mon,  3 Aug 2026 03:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7CA6B0088; Mon,  3 Aug 2026 03:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDBF6B008A; Mon,  3 Aug 2026 03:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43B446B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:10:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C709BC063E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:10:13 +0000 (UTC)
X-FDA: 85059084306.28.C42724A
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 370EB10000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:10:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Yv+rapu3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Dlxlju2HTEwtVmJagDsLypfIpt084rUgsfdg3oPPP2E=;
	b=1UenQYH9AuZ0NLChPQq+2nkZU8OOt/x5F5GVoeiDIraagM6MB0EjNg1DwrW0bSK0+i940m
	XdAhcUbo79YZiFfTbjLG+9w8MW2i248JOVC7j/tdNMA22AzcCmwoPR+hnIeoOW+6HLApJ7
	Kr06m3yjZCNuyA8zYAgnaRkEqlv1Qlc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Yv+rapu3;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741012;
	b=4JcsO3LTh1MUY7mVsOu7JvmbGhyYytZKTOrZ0biKAnCZg6PyGtbnsOlHRnjO449W0vEOKt
	AsIQ+ybeQjwo9edxcV5ERlOqDVHA0RkthCnzPXZmaWvDRwb3F8Q3XMB+Vxt3evtaEWslrB
	u399txg5gq1M95SPG3y9+FHlN2Nfsss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741004; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Dlxlju2HTEwtVmJagDsLypfIpt084rUgsfdg3oPPP2E=;
 b=Yv+rapu3nvFwufQyDk9X2aJmCFNEHL0xkzWMrPG4B8EG9AvI1LUgoMCEc6ZkbWBRamok8H
 GrXBeSYmDPvZwJzdqvFKoY2CFpXe8LPtRm4fWLU5trWj7uzbVOjfsySPeNPjxTRuiqzhfk
 Cq1UjAoTbSiubJIPH9xeLSS+C5dJxsWeKs98QqR677wK8hj8ksH8ywC+g62Hq1o9tKWcGJ
 ly2vH5unMs10YkWozvT/hXG3EFCnG50u4un67uf1GxnnSTktv+SHObBkJ/Hv4yQAxuClTk
 lsw0+JD9rCXs25vFK+g8070gToPIE6vbkI6YC5nMQ1KHjtQCNTAF9UkECATm7A==
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260803070929.86075-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v9 0/8] mm: optimize zone-device memmap initialization
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a703ecb+48644a+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:21 +0800
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 370EB10000C
X-Rspam-User: 
X-Stat-Signature: qf45ouut6mai5bnix96k6zr4nedfhje1
X-HE-Tag: 1785741011-680957
X-HE-Meta: U2FsdGVkX19+DDuLzcWI1A4hi0ta/8O3EBdHHAaWrfYd6v/rAp/i9rQt0nv0OHAcbBBTUQb4nZM8CjUGX1BNkgBzuKsv+MV9pVlZKIgQ21CMCa16xFq8N4YMJXz8oc4NlcG1Spk+Q8NjC3PH4zv/QMHFmujyUfgy6Z/9KqakHlATUAsJUwG/0QS0LXSQN+i/FvlAL10qZGYULR0AYnf+BLFqS2BbrXCkEj3vlopo9lXsGCFsi3W7xgw+Q5R3rIHkpH/Vr752/bsBLYYRE4CJewPqNe/6RP36sB6T4yfzBop+qXPA/XEY6Y5WrAOVa72g+J+XhMR0hAFdX4jo7C+B/NFFg2cHitZM5A8PDU8S7m7iHRn1I55y7k4OJ0xVbLzqmFJvxvQiko/1MQdYlEG8jk8Igd/TBxBU4NCZAGmFBCb/LkehuoZcSIgjSLMpQJafHMAqGcI7DwYBeYXWBbdU/vk0agkuBXYsL/unoFm50cQW4f6tKAjacKJE+0abE9z3nUENzsTv7X0crB7GJITsozkgqUj32cfNX694YfcN1uFsavSv/ywUJdbBtGh4yKh4af2lDwVVN+spFLwsY7pSqPRKZxmvixil5XUkK+XHxCZH/qYt+27i95G/ZV9ksPAgo+Fb6e2f1pcHG0bjzeqf5WJ8QeYZsVSF3qUdb0/5kib5e8QEJCT4x6SDULvKjo6vnym9dLDiJD6ttApbTtl57u5oZIYKHaeNduRRt7MZxD86slu3BGemp2oJZCLITzyz1mkPvyVPvPRVw+Y7+VjYrhbOZwLzuHscpkj+tRNcRQ+z7g0Pz6HTwvyenw6jR/a+Hq/w3bONJ2JgsZqRDM94iIUa2Gl+GxreTf7X4gC1jlt6sihRcsp6KZfgXzkHpb1gGvPZ6+XudQgyrlsLJHIVfXe6HoNFnsl7aMh8Cqu7rjOdoSQTpZPw7/sHPvxuSFC6aTxE8BZE7FmqCVvwY6P
 Brjp6ibP
 w/rZNXnhNXLfq7jTOv1fTJByIWcPmBHwtpgGwO7l5YAlLnrU3bGpt6TA5AK5B2ZVB6orcWkeSOBgvIOpWz6SEoNyuxpURW+TYheYG8oWQy289ANZdB3NR+bKKVR+NNAgdt89Psa9mLw6l5ZctCvM/jhBiWFrJErUz8+9m9hOR2n50ramY4mhlbANGHrFmyZAvnbIs5O6NtPdsrnXoaene4ZT5XtezVZdghFKPNFl5Fimt1OfdlHG9oXAZkWubDAe/Y469ucESO7sHxkguMXGd8C0Fdw==
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
struct page templates and, on x86, using memcpy_nontemporal() for the
template copy path.

The main target is large fsdax/devdax pmem configurations, where the
cost of initializing the memmap shows up directly in nd_pmem/dax_pmem
bind and rebind latency. This matters because the cost is paid in the
synchronous probe/bind path for large DAX/PMEM ZONE_DEVICE mappings.
Userspace workflows such as provisioning or reconfiguring
nd_pmem/dax_pmem namespaces, bringing hot-added PMEM-backed capacity
online, and recovering or rebinding a device after driver or device
changes all wait for this initialization to finish. Reducing this cost
will yield benefits as lower user-visible provisioning, hot-add,
recovery, and rebind latency for large DAX/PMEM devices.

Patches 1-3 are preparatory cleanups and helper extraction. Patches 4-5
add the template-copy path for head pages and compound tails. Patch 6
introduces memcpy_nontemporal(). Patch 7 switches the ZONE_DEVICE
template-copy path over to memcpy_nontemporal(). Patch 8 extends the x86
fixed-size memcpy_flushcache() inline cases used by the x86
memcpy_nontemporal() backend for struct page sized copies.

Architectures without a specialized memcpy_nontemporal() backend fall
back to memcpy(), so the generic template-copy optimization remains
available without arch-specific support. On x86, memcpy_nontemporal()
maps to the existing memcpy_flushcache() backend and can use the
fixed-size MOVNTI paths added by this series for struct page sized
copies.

memcpy_nontemporal() is only a copy primitive. It does not imply a drain
or a publication barrier. Callers that use it before a producer-consumer
or device-visible handoff must provide the required ordering. The
ZONE_DEVICE template-copy path uses it only while initializing struct
page metadata, so the copy primitive itself does not grow a separate
drain contract.

The numbers below measure the time spent in memmap_init_zone_device()
during driver bind/rebind. They are not measurements of the full
nd_pmem or dax_pmem bind/rebind operation.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  Average of nd_pmem rebinds: 244.28 ms
  Average of dax_pmem rebinds: 273.31 ms

With this series applied:
  Average of nd_pmem rebinds: 96.79 ms
  Average of dax_pmem rebinds: 119.04 ms

This reduces the average memmap initialization time measured during
rebind by about 60.4% for nd_pmem and 56.4% for dax_pmem.

As an additional x86_64 data point, I also ran a smaller set of
measurements on the same physical host with a 100 GB PMEM region created
via the memmap= kernel command line, configured as fsdax and devdax
namespaces with map=dev and 2 MiB alignment.

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

This reduces the measured memmap initialization time during rebind by
about 54.2% for nd_pmem and 57.2% for dax_pmem on that setup, which is
broadly consistent with the VM results above.

As another supplemental data point, I measured the test_hmm.ko module on
the same physical x86_64 host, using the test_hmm.ko setup from the
previous discussion that times ten 64 GB
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

I also tested the generic template-copy part on an arm64 QEMU virt VM
with 64 KB pages and a 100 GB ACPI NVDIMM sparse backend. This setup
does not use the x86 MOVNTI fast paths, so it exercises the
architecture-independent part of the optimization.

For devdax, 2 MiB alignment is rejected in this 64 KB page setup, so the
devdax namespace was tested with the supported default 512 MiB
alignment.

Base (v7.2-rc1):
  Average of rebinds for nd_pmem driver: 25.60 ms
  Average of rebinds for dax_pmem driver: 25.60 ms

With this series applied:
  Average of rebinds for nd_pmem driver: 11.07 ms
  Average of rebinds for dax_pmem driver: 13.20 ms

This reduces the average memmap initialization time measured during
rebind by about 56.8% for nd_pmem and 48.4% for dax_pmem on that arm64
VM setup. Since this arm64 setup does not use the x86 MOVNTI fast paths,
the result also suggests that the generic template-copy optimization can
benefit architectures without an architecture-specific
memcpy_nontemporal() backend.

Li Zhe (8):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_nontemporal()
  mm: use memcpy_nontemporal() in zone-device template copies
  x86/string: extend memcpy_flushcache() fixed-size fastpaths

 arch/x86/include/asm/string_64.h |  68 +++++++++++++++-
 include/linux/mm.h               |  15 +++-
 include/linux/string.h           |  13 +++
 mm/mm_init.c                     | 132 +++++++++++++++++++++++++------
 4 files changed, 200 insertions(+), 28 deletions(-)

---
v8: https://lore.kernel.org/all/20260727123429.5673-1-lizhe.67@bytedance.com/
v7: https://lore.kernel.org/all/20260720120259.1545-1-lizhe.67@bytedance.com/
v6: https://lore.kernel.org/all/20260709112520.24857-1-lizhe.67@bytedance.com/
v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v8->v9:
- Fold the removal of the local non-template fallback into the relevant
  template-copy patches and drop the separate cleanup patch.
- Reorder the memcpy_nontemporal() use before the x86 fixed-size
  fastpath patch, so the x86 patch shows its incremental ZONE_DEVICE
  benefit directly.
- Rework the x86 fixed-size fastpath commit message to justify the
  struct page sized copies and report real ZONE_DEVICE initialization
  data instead of a standalone microbenchmark.
- Add arm64 QEMU nd_pmem map=dev and dax_pmem devdax measurements for
  the generic template-copy path.
- Refresh the per-patch performance data for patches 4, 5, 7, and 8.

For changelogs of earlier revisions, please refer to the v8 cover
letter.

-- 
2.20.1

