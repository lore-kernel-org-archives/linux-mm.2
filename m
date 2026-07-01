Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3322AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D7E6B00A8; Wed,  1 Jul 2026 05:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2140E6B00AB; Wed,  1 Jul 2026 05:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B196B00AC; Wed,  1 Jul 2026 05:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDD1F6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:06:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5523A167E70
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:06:44 +0000 (UTC)
X-FDA: 84939627528.14.B340E0E
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E68A18000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:06:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AUzTuqlX;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896802;
	b=rsblXffieFubIVk2RTksGjJKVmMgYrXyX0rOIwuMfE9qtsM7OS9DCcO8MreEg57Dmo2E3z
	gRG8Z9k8hk3dqbiltdPckR73Ibacz57vwIW+IPyMOzlqBRvmx07pXTxNFnFxo5ti57ScxG
	w6i6SIhcrNuQ7vYgG3sAB0GDGsIXdpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EjyWjEtrStwT/2+GI68sA9Nxt1WEmHQBHqN0cpYv9mI=;
	b=RLGSjuCY6IRBV5niyXG9oNZeKtDlY7Of5KDXOIqyZPDk8ETNuDAncwMgEwWY+zVmRZnTlK
	+SNzMBiL8PsjPL9Wh0pG5kyurBIxS1zOryTYUgPLR8osdbJKBa8IlBbLJxatUMFNMDMh1g
	NoFkGZFu85dmDDB/C7wRNH+yJq8Qc0I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AUzTuqlX;
	spf=pass (imf24.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896792; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EjyWjEtrStwT/2+GI68sA9Nxt1WEmHQBHqN0cpYv9mI=;
 b=AUzTuqlXcRIm1fVH9G21uK/TvuhInTC43antstOtLIaofe7UDmyMxvQ275UzJEk68bXz3j
 3osGYWwCSZQ5yEYJihOMfDd6/IJECLI6B4rQSaAds4Rc6AKAuTMOTTasqG93nrauRrNIvD
 ldZ7lhvbFvvaPx7MT1DundeGyNFy9tjY8CoTOTyEpWV5QxkcvKA4gEUoF3eMmIstc+ZglR
 XQ8YHnAmQdUSkQnaKMs7MIU4EBhWGnFfMY4DM4SCb/EEb5dVWUguBNmFQpLIbzFE2RcZIT
 KyXewqVz+CDL1tXqAE4z3LUXVEmRI/mn7CYA06Zq9OlSQ95y5y8nfuH9FjK1GA==
Subject: [PATCH v5 0/8] mm: optimize zone-device memmap initialization
Message-Id: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a44d896+7e0ee6+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed,  1 Jul 2026 17:05:45 +0800
Mime-Version: 1.0
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E68A18000A
X-Stat-Signature: rxjip6onmcq37o8tbmine8tpc9ez13ms
X-HE-Tag: 1782896801-781940
X-HE-Meta: U2FsdGVkX1+kBqzLAm9Wcju+RyytGddFKhAiSQXEUg/YQ/MqzgYL72cQYcm4nItl+Owe7O2zPxIfFgGBhaCDdqoiUYfGat491sM1SZaqmqClWFsXfNuLjCyeJlzZ0ZXUX2UoCOvTOTUGkpdqQOd6gHriyJWkNSfZ3IaPU3aFz3yAxn4DHDtF6Ubp5U2OGXAuXlClbFVtcb5W9gMMlNRqV3fVbPnA0Ps2CLrZsO6H7d+9G+LxKWY9d4drFNX32QWNM3ifafH9eGtTcCpVnqUd8KfgZM9r94MBo/j9UANapX4yy4nsRdFYvKqdulH1fpGNCRw87rJROg4opYdpjtUitN/ZqRPt8tYP0JvA1x4UJGJilptuV3WObNrRBI4YT1joyNp8ASLf5i3TJbcObG43MoVWPQJEuLKSuaavoByKhHq+INpuAmNh/zaJETutmyzV4k+/cn1KM11Tk/IWyIGMdf4Rn4lVLZpTjO0wkvmpq94sWqpeit5oAsrmvdT/9jbxuVCAFqRLgW10l4Q/RDhMmN/Ik+uw79/9n7InQdXex70DMKTZ+rEH/ySH6pA4xImCHxHayalewvgLiaZFRMe4607SS1zdRDs9Q/4DJWMTpzl/auSPwsd3IiVMPfx7HDbwPHQ0hcpSjW0Ll3zDqrerxsQc0LoT86u5wgDd7y+wMACFQvWjYeNxdB4Fu6kQmfQ7Vc2xdU5uy8RN4dxbg9EpHJn6CS46SUDYjiXvhJJPkKYO/TlQHhU17wwgy1nam0vjxY1x6aDbA9IqZ4bvhM0lwfdCooamfLkzxzL951xhhR4stZaBn8mo0LhOY2uFdTJq7nY8msQcMHTM77NEdtX3wxBOGnMTihWCxlGLjWXuwVhrAg6lRwQDYirYphgsFJHIvF6yuOuLLLSSRglHfiJUU153x9P5eb8KjxMX0jJg586c9JiJ6ALcxkUSU/W1tbnyWzcQpiOJvjRcs5Vpgbi
 MV39vsDq
 1HB8J7Cwmn+BeV+labyS5FWjfwo1SgrtYwMJ6Hiz9RcLXY6HHPg9QhenrlAem8WD1s9x00+PYt5K1G60p0iKAIjBuuhVBkGGvt6C3RK1aTQreinRC3nhEOXK7KE1qRKtcXx12oYtSB5phViMXJRfHMzjCqnu6tAgiTEEmKDWhHq0W5G9GKnRYHvpHzQFUJkBFHvkYsDYvvAgTWzNNCSVbhfr9uWIuiZ+KOwnVyAVsD2/4tCErAxjXNulhS4wwwx4RNFFkvM4LSavZTBus6RCt5009wg==
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

 arch/x86/include/asm/string_64.h |  96 +++++++++++++-
 include/linux/mm.h               |  19 ++-
 include/linux/string.h           |  18 +++
 mm/mm_init.c                     | 209 +++++++++++++++++++++++++++----
 4 files changed, 311 insertions(+), 31 deletions(-)

---
v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v4->v5:
- Rebase the series from v7.1-rc6 to v7.2-rc1, and refresh the VM
  performance numbers.
- Simplify patch 6 around a small memcpy_nt()/memcpy_nt_drain()
  interface, rename the previous memcpy_streaming() helpers
  accordingly, make the generic implementation fall back to memcpy(),
  and let x86 reuse the existing memcpy_flushcache() backend instead of
  carrying extra policy/alignment logic in the generic layer. Suggested
  by Borislav Petkov.
- Add physical-host measurements for a 100 GB PMEM region simulated via
  the memmap= kernel command line to the cover letter as supplemental
  evidence that the same optimization also improves fsdax/devdax map=dev
  bind/rebind latency outside the VM, while keeping the per-patch
  performance data limited to the VM measurements for consistency across
  the series. Suggested by Borislav Petkov.
- Add supplemental test_hmm.ko results to the cover letter as another
  physical-host data point, in addition to the pmem bind/rebind
  measurements.

v3->v4:
- Rebase the series from v7.1-rc3 to v7.1-rc6.
- Rework patch 4 so the reusable head-page template is seeded from the
  first real struct page, rather than being initialized directly on a
  stack-resident template object. Also add an explicit !nr_pages early
  return. Suggested by Andrew Morton.
- Rework patch 5 similarly for compound tails: seed the reusable
  tail-page template from the first real tail page, thread
  use_template through compound-page initialization, and reuse that
  prepared tail-page image for the remaining tails. Suggested by Andrew
  Morton.
- Tighten patch 6 so memcpy_streaming() maps to memcpy_flushcache() only
  when the destination alignment and size allow the transfer to stay
  entirely on the non-temporal path; other cases fall back to memcpy().
  Suggested by Andrew Morton.
- Rework patch 7 so the existing 4/8/16-byte cases remain handled
  directly in memcpy_flushcache(), while the new aligned fixed-size
  fastpaths cover only the larger 32/48/64/80/96-byte cases. Suggested
  by Andrew Morton.

For changelogs of earlier revisions, please refer to the v3 cover letter:
https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/

-- 
2.20.1

