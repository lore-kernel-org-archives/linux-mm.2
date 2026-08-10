Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD60FC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8DB6B008C; Mon, 10 Aug 2026 08:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B09C6B0092; Mon, 10 Aug 2026 08:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5EA6B0093; Mon, 10 Aug 2026 08:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD586B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:21:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8E52A0159
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:21:43 +0000 (UTC)
X-FDA: 85085270886.08.FB725B7
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf02.hostedemail.com (Postfix) with ESMTP id 72AFF8000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:21:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="G/eEW0wn";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dczaLfb/wvpy7phZzpA48WeB2I4S9VA211sCQqFUqdA=;
	b=frTqEKNgOHCGV55hrkwKx563uRqj0Jqw/QmDtTbZTHwECgBCM0SSEmV9tNm5ziOB0M22S0
	AQ34ufYtkV1F1GH1gD5/a4h86NRJXWsLFxjZ358XNvc1iOjJrprHg8z/U3gHd2JsSfBclF
	xhuPFILBrHRb/pvj2Vlx/xyD76qt4q4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="G/eEW0wn";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364502;
	b=Bq8m4gDd6UqLiG3KDIGG0XLkMtT5XiJYq4a/QYM4SLsScMMErSS1Q/BvWoPDBeiCIiQKMb
	Y6Ch5QiPIKC3GsWnMLjI1X889YR40tyuCc6zWk8C+QpU0ZOdTiHAKXUnqQnHIbQvmvSJqB
	O41I9cZYUipV5tTcBUKYRBhTxZ6NlTI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364494; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=dczaLfb/wvpy7phZzpA48WeB2I4S9VA211sCQqFUqdA=;
 b=G/eEW0wn8PQ3r4OCtDCOW9b68ur15tAACs8hMUM/MQd78WtfWbHfzAMjhq/zUAihI+B4Dh
 W68Kn4XuWQsiNTW9WY7lbvukYUFtJZuyk3GJ2DNNfV9WhQLVfAhy24x3JjCDY3NknrCXuz
 uA+mrpmsdvkxnErvvoe2OlG/vZkcqYUIvUGL1ZVVvDRAPEvzbnmrbQv/PDeS/bsXHcIeOM
 pz1zbQakK8o5kv7zfqnGjZXK8tODsf7jYXHmB+HxIGE6eXOAHy92h/oqDTDIrTa1xqNRQO
 BFXmI+gXluWFZhZ8/ny2XHEZGVp1F0RxKswIP7mPTBHwPLsEMJVqNteiEDbQ7g==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v10 0/8] mm: optimize zone-device memmap initialization
Date: Mon, 10 Aug 2026 20:20:49 +0800
Message-Id: <20260810122057.30447-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c24c+d8b0d6+kvack.org+lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ttdgnftdbp84zfa1oyo5o16odk3s5kc7
X-Rspamd-Queue-Id: 72AFF8000D
X-HE-Tag: 1786364501-774741
X-HE-Meta: U2FsdGVkX19MY1v4AqsWWcj/f/etPhkRUzN3ODHitOeDb7fHxIMKgz6tEKVnGVxTvYlnPjZNK8Cs50iqcM26dqlej5TYMW7BfH70iv58+Dsbk4G7Nt79HnXV9uacWYNvVbJcX7l8DN0yPJLwhM8wlO+HWUoBMaX0pYYa8KpDZs6yuREorVNIqDmmLvqmG9mn0pa4wt/jjLOipJV+SLXbbji1c48xTZT31MSm9A75ac0hP8iX44OzGsuSbbdaeHLcqREw9KZBdH9SwnUVvSUceHRtZLRHA6KxJqHNYmRAkNFVUfwv7ZdnWtAeC/S8uMu3e74DUAqhFtjOV/CM1Sn2SN29O3M8ytqphiQ1hHRfj1t4ZVpOub0wKwFhcng/Gjc1yp0k2IM3B8GcT5PWkkxkU/F1hp0PcmRWOVEB406wgRleyCyA+9Zp6NuaLYDY0+v/dC0kabMz4skGVRARF1l5y5TfBg92cIavju2V7tbPAYkhshL2MpFEfDJpgfdLSucZ+CVnK64EVeXlI2TMMp1W4gFE3wUaN8dQ44kNWKWXT35QXDzUvcQBAEJ6BmT1m0iy5weaeWnKOl/g85pCg9V/TiCUhhWpD410v1m1atbHi9ImUXtIgodo5ZkP3gjJ85D3b9onNYzNE7WAoAX2BwJA4xlOK41qIaL4Jp+9nH570u9aCm+6iTZpxnHJ9CPtLEybU44FYwnWU9Kxii4P3XYirsvhMPXzwHOFSNX0owr2PImPasw/6bD0sQyAAd6wgWLpndGbKmVHldV8uCxJYYrAeo3/8zuD6WMMbXZvDAeHGyd9k2eKZKgG+vga4jLR01tJhl1UP2neO+56mSw7pp0ffwe6cm6AE867Gz22jdVGvNikJG+j22/rBtbOh1EaTfR8kEyU3wDNz5ryt8bRfTNO5xH3KpSxv+BR2eT9UGtWmd4RyT5DG5rcbm7SGLGKaO3SfUJd4vJJ9Dp1K0Lxxvl
 FdqKk4/+
 MCT+M9UH+LwlufAmVhrvcRYob3pNeySP3yAPYB9XUnHgdTbRd3PBQvxVsWJFxHqWF73SD7rHyC6NPTnJXvhWMubGfN0N93OXbZ17ls2qeNvVj6FKcd+8q0zEkIM8RQeU9Jbl6IYviPcxGev3g+0IDYy+rwAt4c1yx/6MlIjhJrsuIYvYxZvTM5XeHVkGJfeWkkOUu+aS49KA4WeJ4JTiVAHhwGkJt52B08rsjQr1YAqu9xDjzWHGZOwhiYooS5uFWVdpOwCW9AeEIqbsG/VEsjpS8Qw==
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

[1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/

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

 arch/x86/include/asm/string_64.h |  83 +++++++++++++++----
 include/linux/mm.h               |  15 +++-
 include/linux/string.h           |  13 +++
 mm/mm_init.c                     | 132 +++++++++++++++++++++++++------
 4 files changed, 201 insertions(+), 42 deletions(-)

---
v9: https://lore.kernel.org/all/20260803070929.86075-1-lizhe.67@bytedance.com/
v8: https://lore.kernel.org/all/20260727123429.5673-1-lizhe.67@bytedance.com/
v7: https://lore.kernel.org/all/20260720120259.1545-1-lizhe.67@bytedance.com/
v6: https://lore.kernel.org/all/20260709112520.24857-1-lizhe.67@bytedance.com/
v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v9->v10:
- Drop incorrect Suggested-by trailers from patches 4 and 5. Suggested
  by Muchun Song.
- Fold Borislav Petkov's x86 memcpy_flushcache() cleanup: route the
  existing 4/8/16-byte fixed-size cases through the same helper style and
  keep the "memory" clobber consistently across the inline MOVNTI cases.

For changelogs of earlier revisions, please refer to the v9 cover letter.

-- 
2.20.1

