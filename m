Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F469C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874806B0095; Mon, 31 Aug 2026 07:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C246B0096; Mon, 31 Aug 2026 07:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7622C6B0098; Mon, 31 Aug 2026 07:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49A086B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:17:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B020B12048B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:17:39 +0000 (UTC)
X-FDA: 85161314238.25.CC3EABB
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4036A40004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:17:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Thkfo2GE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zafJqSeEeHqjJ82fLLRjlm02xhpYDt1Y2q1o1VoGjaY=;
	b=I0K4IWEy728Sl2Jdfz+GShp5uDNetHdT8v6DgfFIztShcBVAo76cvB9s6vfSR9RDfFGlft
	8cx4tk086a8YC3FILd9QFfwUjKt95fTRHyFsCj+ZYRZUIEryrWNhrY4uFJhjU1iz0IWAvE
	X7wgOUkj97SIy64BnmXRdn5eX+cce2k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Thkfo2GE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175058;
	b=Z4iHnYdqNOaAoMoROsPCV+uRDjp5ObSceoYUa8dscblg+7AE4j1sOkLTRH+/su9Kud9duj
	Mjn1iUVOEikUh9OCNcmaEJ1vaijERh4uni8iA34hgc1gFbUxZxz/zcvGAq/KY0yFvrhmRe
	I0w0mcpa3zhqnNcbWAhNR0gsMXvK+MQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175048; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=zafJqSeEeHqjJ82fLLRjlm02xhpYDt1Y2q1o1VoGjaY=;
 b=Thkfo2GE6yBLxkeJwyQZI7OpivdA1I5GOZdkC5PqEQqHVacckeGseYHKH/GvP+1lXE9b3o
 aKP6GtugHRaFHKw+TF0Wf9qHtur6oZCSf4crdUNWUu/cD3j7VtNZIiMQbESiXzjaBIym5t
 xK8VDCdAjSnImRszdFgVBex63vRmDX/HL0xgr67lVBpJu5drXT+6bLTqZdVytVTXraCoh6
 /4qmOnx/7RmNkOWp+PbgUzjiGSVCKy9g9ovzazqsCHWWTmFEb9oTTw+wKflNT9CGS8Kj9B
 spLAhvt81UABYle7yIw2wB/rROclA7+6N2GL1rGqygMux99sMObvJfPAuHe0Xg==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Mon, 31 Aug 2026 19:16:31 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a9562c6+d15697+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v11 0/7] mm: optimize zone-device memmap initialization
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: in5w4unw4kpapu9frr71kiaxe7ap4cb4
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4036A40004
X-Rspam-User: 
X-HE-Tag: 1788175057-305967
X-HE-Meta: U2FsdGVkX19fAJT02vr5e03c4iWqG83pckk0yhaOeRGYn2iekEU+bCGJcihWWwVHmryxttaqCaqjKiwVq1RGLEMzbP0i3noXAZBHsXWTMawnyEE/2mi4I/SL3KqsyRahnCOgVZ9Q3QbfSJ+8wA811V5n2hlHF7FT5pwgdJOtAGyQ09CipOo6owbPAmGYgrUvP3y4C8UHeZ3946zqc4Ib98nZXGLXkFLKfxEwazc+0x0BXNuDjM6Oy6ToLzGXkxsTIKxGVZ3I7t73jIdjOYs8ZYgMC5Qq1+12fDiMzKxbwQjFy0uDxihFxIaCIzOzv3PhLh4rRMYo0V5TPcS3hqCoArQng5hBK54Qfbn8cxx2X/SXxi3STaUfkf+ps/VU6zg9M0i7734dRMxhJiSMiNugk76BawYzECD8xrVYQNzlkh8CRQC7Q1RsX39OowNyRUUFB1hdAOC2K4FgaezRGqi0UR0FAPNPG+QAERnRRDUjhFRsXspAOLOxKWIaAuhX2HAp23y4Ook1FvmzoVWh8NnZZQ3fMQa5rM6jFa/vq1glJYNqonxWLqfVqDOcHtTPUHUO6gHgAol9SwlDHTz/G8ma0kY8CFHtJLeH0knuRlCGLwJGt8mIMuy87WrZgpgULlciNiDBgOk4rssfQuH/ZfMaH7rSxIEhGKOSEOncGc5WBSfzgFRgQooCmDMZwTkYE5CdEeQFcbkc2c14Tpa01opb4UX8shG+c5cfTLO0tTUNmkpslvyiDIwvtvk7QbNvMVErWX5wJ9TkQlLaC8xqOp0aTnKx2Q8c6Ny1f7Zx1wJbnysKKNBtg6dUJDrNxIDL9mNHM4maMsgHSkmz13374coJ7sxYzFhOk2FL+sSZrJB2VLW0urDQA9FZQTQVCrj+H6WbDOmGkVA2NxTDUqf6wbvpvGXhUFVNQ1jN0zXkEyOX4NaCfsL8pb9ZMwgW7KsKtFY5PQZ4PUjZyJYEEgoG2XV
 F1Z/OoVI
 9WWQm1suv7ca6Zf/JeYPdm+LenEvZxWx/Xvg8KJsdeq/9YwWeD3ktPQ02GorLYwNmjfKj5VO2HggdDjTxleS/nSkG1m/O1MtudCH83NwiFg3aVn+gx6r8j4TYaBCzIEXKZRgTPQbAeYx3ysKpmFuxku2pXDjLKapZLfem3hsSvBeaMQkO9/Fx5/wme+d2bHGOxKgr/Tzsd3+CiK3vCumA4WQq7hcz8m+LyQS+CPg22tXyYNLoe+R4wRIN3nhEYb3TEvWHepjwNJhZ7URnFFvdJ88Cpg==
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

Patches 1-2 are preparatory cleanups and helper extraction. Patches 3-4
add the template-copy path for head pages and compound tails. Patch 5
introduces memcpy_nontemporal(). Patch 6 switches the ZONE_DEVICE
template-copy path over to memcpy_nontemporal(). Patch 7 extends the x86
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

Tested in an x86_64 QEMU/KVM VM with a 100 GB fsdax namespace device
configured with map=dev and a 100 GB devdax namespace (align=2097152)
on Intel Ice Lake server.

Test procedure:
Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of nd_pmem rebinds: 221.07 ms
  Average of dax_pmem rebinds: 191.20 ms

With this series applied:
  Average of nd_pmem rebinds:  71.93 ms
  Average of dax_pmem rebinds:  87.37 ms

This reduces the average memmap initialization time measured during
rebind by about 67.5% for nd_pmem and 54.3% for dax_pmem.

As an additional x86_64 data point, I also ran measurements on the same
physical host with a 100 GB PMEM region created via the memmap= kernel
command line, configured as fsdax and devdax namespaces with map=dev and
2 MiB alignment.

For brevity, the individual patches keep only the VM results rather than
including a second set of physical-host measurements throughout the
series. The physical-host numbers below are included only as
supplemental evidence that the same optimization also provides a similar
benefit on a non-virtualized system.

Test procedure:
Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
30 times, and collect the memmap initialization time from the pr_debug()
output of memmap_init_zone_device().

Base (v7.3-rc1):
  nd_pmem / fsdax: 205.90 ms
  dax_pmem / devdax: 225.43 ms

With this series applied:
  nd_pmem / fsdax: 69.13 ms
  dax_pmem / devdax: 90.67 ms

This reduces the measured memmap initialization time during rebind by
about 66.4% for nd_pmem and 59.8% for dax_pmem on that setup, which is
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

Base (v7.3-rc1):
  avg memremap reported during module insertion: 116500596 ns, 116438028 ns

With this series applied:
  avg memremap reported during module insertion: 46953088 ns, 46428399 ns

This corresponds to about a 59.9% reduction based on the mean of the
reported values, which is again consistent with the pmem bind/rebind
results above.

I also include an arm64 data point for the generic template-copy part.
It was measured on an arm64 QEMU virt VM with 64 KB pages and a 100 GB
ACPI NVDIMM sparse backend. This setup does not use the x86 MOVNTI fast
paths, so it exercises the architecture-independent part of the
optimization.

For devdax, 2 MiB alignment is rejected in this 64 KB page setup, so the
devdax namespace was tested with the supported default 512 MiB
alignment.

Base (v7.3-rc1):
  Average of rebinds for nd_pmem driver: 27.93 ms
  Average of rebinds for dax_pmem driver: 27.87 ms

With this series applied:
  Average of rebinds for nd_pmem driver: 14.53 ms
  Average of rebinds for dax_pmem driver: 16.27 ms

This reduces the average memmap initialization time measured during
rebind by about 48.0% for nd_pmem and 41.6% for dax_pmem on that arm64
VM setup. Since this arm64 setup does not use the x86 MOVNTI fast paths,
the result also suggests that the generic template-copy optimization can
benefit architectures without an architecture-specific
memcpy_nontemporal() backend.

[1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/

Li Zhe (7):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_nontemporal()
  mm: use memcpy_nontemporal() in zone-device template copies
  x86/string: extend memcpy_flushcache() fixed-size fastpaths

 arch/x86/include/asm/string_64.h | 83 ++++++++++++++++++++++++++------
 include/linux/mm.h               | 15 ++++--
 include/linux/string.h           | 13 +++++
 mm/mm_init.c                     | 72 +++++++++++++++++++++------
 4 files changed, 149 insertions(+), 34 deletions(-)

---
v10: https://lore.kernel.org/all/20260810122057.30447-1-lizhe.67@bytedance.com/
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

v10->v11:
- Rebased the series on v7.3-rc1.
- Refresh the benchmark numbers on v7.3-rc1.
- Dropped the standalone helper split around __init_zone_device_page(); keep
  the existing helper shape and layer the template path directly on top.
  Suggested by Mike Rapoport.
- Move the first head-page/tail-page initialization out of the template-copy
  loops. Suggested by Mike Rapoport.
- Fold the template PFN-dependent field refresh into the template-copy helper
  instead of keeping a separate zone_device_page_update_template() helper.
  Suggested by Mike Rapoport.

For changelogs of earlier revisions, please refer to the v10 cover letter.

-- 
2.20.1

