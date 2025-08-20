Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A33CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0E68E004F; Wed, 20 Aug 2025 06:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88348E0003; Wed, 20 Aug 2025 06:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC55A8E004F; Wed, 20 Aug 2025 06:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5A6D8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:29:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B95160419
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:29:56 +0000 (UTC)
X-FDA: 83796765192.03.AAD685F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 834AE160007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:29:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=i0An9jEV3o4+BtXvYYFe+C7Ti7DwjJ5UStbGH3Nk+GY=;
	b=7YSAtKHLMVa9p9VvlewDCwtBshRCZ98kQiBVzEMO2G1XttglkTaJLGtQPkOfRh4QRRo7tp
	1VIophVa7lKa4LlEPLguB4zuDvTZym/3rW52OzMs9zli+F4mUyCdUyBsyTSQV19QjXiu1q
	7EC07ZCQJA6LKaV0j0QfP8LzSSNHHkw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685794; a=rsa-sha256;
	cv=none;
	b=oaHOG8ytscBt4BRva+Pp3NWb25m8z9FrsiU7tLUVuu0feGb8jUIdEkl4JSZEgzqDOJmauS
	zZzX8AljpgZ+xrlbJPmm9OiyefNYCG2Ww1dDC3qfygPHo7KwqAOOR4qC9j9lev2KrN2i6z
	k3zGce+H1XpDWtGncXMhwlVZaVmQXhM=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N0n0mSFz6L5l4;
	Wed, 20 Aug 2025 18:26:49 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 05FE5140119;
	Wed, 20 Aug 2025 18:29:52 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:29:51 +0200
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Subject: [PATCH v3 0/8] Cache coherency management subsystem
Date: Wed, 20 Aug 2025 11:29:42 +0100
Message-ID: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 834AE160007
X-Stat-Signature: f68numro8w54xcc1apdmdyfu6uu866h1
X-Rspam-User: 
X-HE-Tag: 1755685794-576249
X-HE-Meta: U2FsdGVkX1/z8Jf4BQBCKMkY5KSYotrqgg+tlHoNAtlDplT7bFhu6AFaf0LQToiZ9qgOEAehCWISOuUwAaNy649io0/zKyiI8tx9TO+JAbtvNNkYDu92+4szl+ZqcaWJs5xdBW8yW9OwxQbDCzXDRb6NgaEJoMATDlD8ZAHk2AQPfOrN070q561A+bp7SVutM3rGMNcnqIYRjFAJ/a7g7xISks/jaHH+YRR/j1M1fII42H/s7/wwG93r6Zrg5HkNtHldv6f3zblKC8T9AWb0DyasfjXEbNSEVUQ5HWc7F6V8n0Xe5C6qyy0SU8TczvlnPRFAzuxYghMbnn6kL4f9zJo3yI97vVSQtdyqJv3SJXaohIVJjHTc2yCeKS5ZB79Wmjxt4sDza17ehvyU3pbM8bMkvtNmHYyaPc4mhH/LzcTwtpXkJ+zdAdYnnAuXGxyh2DrsDwfIwIJcNegOqltF57mDv41LlskHb8n7CKfb8lRoGQHeiPZKG4Vif3wVOenKxTb+BPyI417IuyF5ljOlMD68MKh+HqlwXl8d1NEVeunkKPf6UMFYuNI1KxP542Y2Vctp7FDj28H+fbcD3F2j7z5Qx0Ipbi1Wz6zhBN3NkWdXT9hEmIWgFq8s1qfIBJFHqK9PNJlR+EhgtUK0LWu/f6HNkBzKM5KxLW4pD6rwQ7e/sxoCtJS+JZbpRkHUrcn2XWSUgy71nSVSnBS6ga6LYMYKUsK7Kbi9mun8ViXv/dx0pNHFjhRkpkaYZ7F4lbODKOkRan5Y7e9Y4HKtJkTe17aYGW6N9J0NMpjfOcEl38GmbEFVpyY3hhuK3Hy68Za7BqUzYipShoP8OfKLiv6DwkZkCRFByJPNla3LRmwPwm4/GyRMzQWZNdZu1FXQlyQi9sm3dpTpA+Y+2I+Z6b4UlN/I89Lx9LEnzkP0tN+OqumDS6W+zLoZ66qoMSukl3aLE0aNiKvivkVFz36vf8B
 lpmGDzVZ
 RPAetPML3YjCs36xa7KtMD7qlYhYDeWkhs0OSNFINdrAWnv3F+K+V3NDoxQ9xGDDZybV8b8qz9oybJda9+G5cm2v3dB5xoQPRudog8Fucgd1GJGabLXFhRAe8UHz4YuwCKyaCWb2k+gLItGalrEgA4AF/HH5N+7y015ph+FwRgT162Bw13YQHRsNMsppqYDkg7f9b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support system level interfaces for cache maintenance as found on some
ARM64 systems. This is needed for correct functionality during various
forms of memory hotplug (e.g. CXL). Typical hardware has MMIO interface
found via ACPI DSDT.

Includes parameter changes to cpu_cache_invalidate_memregion() but no
functional changes for architectures that already support this call.

v3:
  - Squash the layers by moving all the management code into
    lib/cache_maint.c that architectures can opt into via
    GENERIC_CPU_CACHE_MAINTENANCE (Dan).  I added entries to Conor's
    drivers/cache MAINTAINERS entry to include this lib/ code but if
    preferred I can add a separate entry for it.
  - Add a new patch 1 that drops the old IODESC_RES_ parameter as it never
    did anything other than document intent.  With the addition of a
    flushing range, we would have to check the range and resource type
    matched. Simpler to just drop the parameter. (Dan)
  - Minor fixes and renames as per reviews.
  - Even if all else looks good, I fully expect some discussion of the
    naming as I'm not particularly happy with it.
  - Open question on whether is acceptable for the answer to whether
    cpu_cache_invalidate_memregion() is supported to change as drivers
    register (potentially after initial boot).  Could design a firmware
    table solution to this, but will take a while - not sure if it is
    necessary.
  - Switch to a fwctl style allocation function that makes the container
    nature of the allocation explicit.

On current ARM64 systems (and likely other architectures) the
implementation of cache flushing need for actions such as CXL memory
hotplug e.g. cpu_cache_invalidate_memregion(), is performed by system
components outside of the CPU, controlled via either firmware or MMIO
interfaces.

These control units run the necessary coherency protocol operations to
cause the write backs and cache flushes to occur asynchronously. The allow
filtering by PA range to reduce disruption to the system. Systems
supporting this interface must be designed to ensure that, when complete,
all cache lines in the range are in invalid state or clean state
(prefetches may have raced with the invalidation). This must include
memory-side caches and other non architectural caches beyond the Point
of Coherence (ARM terminology) such that writes will reach memory even
after OS programmable address decoders are modified (for CXL this is
any HDM decoders that aren't locked). Software will guarantee that no
writes to these memory ranges race with this operation. Whilst this is
subtly different from write backs must reach the physical memory that
difference probably doesn't matter to those reading this series.

The possible distributed nature of the relevant coherency management
units (e.g. due to interleaving) requires the appropriate commands to be
issued to multiple (potentially heterogeneous) units. To enable this a
registration framework is provided to which drivers may register a set
of callbacks. Upon a request for a cache maintenance operation the
framework iterates over all registered callback sets, calling first a
command to write back and invalidate, and then optionally a command to wait
for completion. Filtering on relevance is left to the individual drivers.

Two drivers are included. This HiSilicon Hydra Home Agent driver which
controls hardware found on some of our relevant server SoCs and,
mostly to show that the approach is general, a driver based on a firmware
interface that was in a public PSCI specification alpha version
(now dropped - don't merge that!)

QEMU emulation code at
http://gitlab.com/jic23/qemu cxl-2025-03-20 

Remaining opens:
- Naming.  All suggestions welcome!
- I don't particularly like defining 'generic' infrastructure with so few
  implementations. If anyone can point me at docs for another one or two,
  or confirm that they think this is fine that would be great!
- I made up the ACPI spec - it's not documented, non official and honestly
  needs work. I would however like to get feedback on whether it is
  something we want to try and get through the ACPI Working group as a much
  improved code first proposal?  The potential justification being to avoid
  the need for lots trivial drivers where maybe a bit of DSDT interpreted
  code does the job better. (Currently I'm not hearing much demand for this
  so will probably drop in a future version).

Thanks to all who engaged in the discussion so far.

Jonathan

Jonathan Cameron (5):
  memregion: Drop unused IORES_DESC_* parameter from
    cpu_cache_invalidate_memregion()
  MAINTAINERS: Add Jonathan Cameron to drivers/cache
  arm64: Select GENERIC_CPU_CACHE_MAINTENANCE and
    ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
  acpi: PoC of Cache control via ACPI0019 and _DSM
  Hack: Pretend we have PSCI 1.2

Yicong Yang (2):
  memregion: Support fine grained invalidate by
    cpu_cache_invalidate_memregion()
  lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION

Yushan Wang (1):
  cache: Support cache maintenance for HiSilicon SoC Hydra Home Agent

 MAINTAINERS                        |   3 +
 arch/arm64/Kconfig                 |   2 +
 arch/x86/mm/pat/set_memory.c       |   2 +-
 drivers/cache/Kconfig              |  22 ++++
 drivers/cache/Makefile             |   3 +
 drivers/cache/acpi_cache_control.c | 153 +++++++++++++++++++++++
 drivers/cache/hisi_soc_hha.c       | 187 +++++++++++++++++++++++++++++
 drivers/cxl/core/region.c          |   5 +-
 drivers/firmware/psci/psci.c       |   2 +
 drivers/nvdimm/region.c            |   2 +-
 drivers/nvdimm/region_devs.c       |   2 +-
 include/linux/cache_coherency.h    |  57 +++++++++
 include/linux/memregion.h          |  10 +-
 lib/Kconfig                        |   3 +
 lib/Makefile                       |   2 +
 lib/cache_maint.c                  | 128 ++++++++++++++++++++
 16 files changed, 575 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cache/acpi_cache_control.c
 create mode 100644 drivers/cache/hisi_soc_hha.c
 create mode 100644 include/linux/cache_coherency.h
 create mode 100644 lib/cache_maint.c

-- 
2.48.1


