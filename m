Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3261CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 11:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECD38E0099; Fri, 31 Oct 2025 07:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376278E0042; Fri, 31 Oct 2025 07:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264A68E0099; Fri, 31 Oct 2025 07:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1158E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:17:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C88DDB9547
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:17:16 +0000 (UTC)
X-FDA: 84058158072.20.5B5F319
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id A172A40002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 11:17:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761909435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=VG2ZXFA5ya8adW1y1VrqLqVg7XoS2peqnveGWzUthrY=;
	b=hiO+hkTPQw614Tw3bXVY11Rz1A9G5zMtMqNrtah85OM8r/t3dqkJPP6SEdEHDi6jSDCwF/
	xMzJ3fPJ3mCOekyLglHt1aE8Fy+lSQy/ZFWk5ZBQnNdz2JeCehe6E72DflgLLU079APY7C
	SadY+YqFS0yGew26db+jkaxwgtGi4LU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761909435; a=rsa-sha256;
	cv=none;
	b=TjbVKcMmQImZkuwJAImsAo/NaSAbefNIhd8ysksy1EPZKP6nKmPbW0Dpem+qGMF01medfX
	CQM3qWymysZj24BPkIvMCUsMj1id/Ekj7WaWkglEabUImDCConLBOuOHCdDvHhynJCjR7U
	0KbYN9zGPbCKrt1RRrR3mCsiaXhjlPw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4cydjQ6cF3zJ46bm;
	Fri, 31 Oct 2025 19:16:58 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D0B20140370;
	Fri, 31 Oct 2025 19:17:11 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 31 Oct 2025 11:17:10 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Drew Fustini
	<fustini@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Alexandre
 Belloni <alexandre.belloni@bootlin.com>, Krzysztof Kozlowski
	<krzk@kernel.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v5 0/6]  Cache coherency management subsystem
Date: Fri, 31 Oct 2025 11:17:03 +0000
Message-ID: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Queue-Id: A172A40002
X-Rspamd-Server: rspam02
X-Stat-Signature: gsnhw4ffy9t48f87t4sx13wnegn8d9k7
X-HE-Tag: 1761909434-274212
X-HE-Meta: U2FsdGVkX1/E75psKyPjJcbL/v1KfTXzwO4osH9IoDbfbrCAkpPSxeWAHaz6M/KS9kWvIfLnPR8nImrOq/fWizgH5DEjEYI/lvydNaQkklBjyH2gPz8aU+LmkbJ2j03SuklPRQaHZwpBdkZ8FBbeBSuuFDmTYwafKyrnHVciZT3XMWucWnR5LiGDWDyFSXXt7SPnT4/sOGlJmUixbMXHTH655/Vq8tXRs8jQNGRq6T8319kDAFjgwxnhbAur08IIFcBqWYe30IHZ1mUrHiRm+NRIM7Cj9adDaKGYOxgv53FOwmXshcaBpJ6KIRebKXBSjOW09DtDWtUsNX7g4pAOSwNf6bi+G1LfybiCwdeulOFU6AXCCZ8PPiRYP5nAkCDNNlXyZyKCTrCAZEixsrNqVT/Y3msVyVQPfqHZSV6tWtvxQMdj0PEEZJQi5rFGiyY2wip8vgdUgwh1m6M1b6YjuVjRtHteHPKH5Zhqd4ip/wcwj7gMSHYvAMSenIU/ip5gANmBouwqx91n/4DWT/U10UkoFDInTc5nbgmZ/6Az5dvMBktQ8DX6u/+6n+Avwe9VdmT51eqBpqApb7IKmmPWg9xdLuRa6SWp5liIYfYac0citYil2m6r/qvQRnlSdJNS8FguymYF9RLk5pB60nlM4rkbtpVmDvhqdi++awgjANqwXxkHcpOYFmBih3ZPaJUKe5OPBbdzFRIu8zIe6npuhRc8bUMjxtBNXf2CnptA/C4Yv20Aw0SQfxg2BiLyMmosGDDukdNgFXNEm1OfeIzcs4eGo0b6Je0OQ1/JTZ3gQ9mobmhHyi47AeRwL4UgyAYrboZFgQQ+Px+NjOXe2C7c3gZC0HCipMehJhrE175hrI7wjmgEllXevXiFrHqFCDUBX8O4YNCJTzNcZvKKmdUyIqRlFKMr7fwITrr0hqKUMY5I4iUrt65whUEyt4B2g46mLvVMcetnFg2oBYaGabE
 Y26UzfpJ
 ne8p81z9cuTAzG3fLJFD+ydZDk7iVt0ovDue0maxTEGmnCiPPIN/9suXPWO+s/eLKIlqXUzOtoF7sbmIgGi2DooujKfXLcQ1qS05Xp9idfFPmaf6Zvf7RNCHfZF3Ap6skftTHQTi+8CFVJsYeiXK0AMFOIq7E7iMKzdiNVQIZ8ZnITBUXHG2woTZ7rQ1o36AVfe7f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support system level interfaces for cache maintenance as found on some
ARM64 systems. It is expected that systems using other CPU architectures
(such as RiscV) that support CXL memory and allow for native OS flows
will also use this. This is needed for correct functionality during
various forms of memory hotplug (e.g. CXL). Typical hardware has MMIO
interface found via ACPI DSDT. A system will often contain multiple
hardware instances.

Includes parameter changes to cpu_cache_invalidate_memregion() but no
functional changes for architectures that already support this call.

How to merge?
- Current suggestion would be via Conor's drivers/cache tree which routes
  through the SoC tree.
  *  Andrew Morton has expressed he is fine with the MM related changes
     going via another appropriate tree.
  *  CXL maintainers expressed that they don't consider it appropriate
     to go through theit tree.
  *  The tiny touching of Arm specific code has an ack from Catalin.

v5: Changes called out in individual patches.
Comment and patch description updates to make the following clearer.
  - Difference from cache-coherence operations for non-coherent DMA.
    Longer term it may make sense to share infrastructure but for now
    we have two parallel systems as there would be near zero overlap
    in code or functionality.
  - Why multiple agent handling is necessary and what that means for
    the HiSilicon HHAs in our systems + the driver inclued in this set.
 
v4: (Small changes called out in each patch)
- Drop the ACPI driver. It has done it's job as a second implementation
  to help with generality testing. I have heard zero interest in actually
  doing the specification work needed to make that official. Easy to bring
  back if needed in future. I have it locally still as a second test
  case.
- Add a cpu_cache_invalidate_all() helper for the 0,-1 case that is used
  to indicate everything should be flushed as no fine grained range info
  available.
- Simplify the necessary symbols to be selected by architectures by
  making CONFIG_GENERIC_CPU_CACHE_MAINTENANCE select
  ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
- Avoid naming mentioning devices as there is no struct device.
- Use a kref so as to have something on which a _put() operation makes
  sense avoiding rather confusing freeing of an internal structure pointer
  that was seen in v3.
- Gather tags given.
- Various minor things like typos, header tweaks etc.
Thanks to all who reviewed v3.

On current ARM64 systems (and likely other architectures) the
implementation of cache flushing need for actions such as CXL memory
hotplug e.g. cpu_cache_invalidate_memregion(), is performed by system
components outside of the CPU, controlled via either firmware or MMIO
interfaces.

These control units run the necessary coherency protocol operations to
cause the write backs and cache flushes to occur asynchronously. They allow
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

The often distributed nature of the relevant coherency management units
(e.g. due to interleaving) requires the appropriate commands to be issued
to multiple (potentially heterogeneous) units. To enable this a
registration framework is provided to which drivers may register a set
of callbacks. Upon a request for a cache maintenance operation the
framework iterates over all registered callback sets, calling first a
command to write back and invalidate, and then optionally a command to wait
for completion. Filtering on relevance if a give request is left to the
individual drivers.

In this version only one driver is included. This is the HiSilicon Hydra
Home Agent driver which controls hardware found on some of our relevant
server SoCs. Also available (I can post if anyone is interested)
is an ACPI driver based on a firmware interface that was in a public
PSCI specification alpha version

QEMU emulation code at
http://gitlab.com/jic23/qemu cxl-2025-03-20 

Notes:
- I don't particularly like defining 'generic' infrastructure with so few
  implementations. If anyone can point me at docs for another one or two,
  or confirm that they think this is fine that would be great!
  The converse to this is I don't want to wait longer for those to surface
  given the necessity to support this one platform that I do know about!

Jonathan Cameron (3):
  memregion: Drop unused IORES_DESC_* parameter from
    cpu_cache_invalidate_memregion()
  arm64: Select GENERIC_CPU_CACHE_MAINTENANCE
  MAINTAINERS: Add Jonathan Cameron to drivers/cache and add
    lib/cache_maint.c + header

Yicong Yang (2):
  memregion: Support fine grained invalidate by
    cpu_cache_invalidate_memregion()
  lib: Support ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION

Yushan Wang (1):
  cache: Support cache maintenance for HiSilicon SoC Hydra Home Agent

 MAINTAINERS                     |   3 +
 arch/arm64/Kconfig              |   1 +
 arch/x86/mm/pat/set_memory.c    |   2 +-
 drivers/cache/Kconfig           |  15 +++
 drivers/cache/Makefile          |   2 +
 drivers/cache/hisi_soc_hha.c    | 194 ++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c       |   5 +-
 drivers/nvdimm/region.c         |   2 +-
 drivers/nvdimm/region_devs.c    |   2 +-
 include/linux/cache_coherency.h |  61 ++++++++++
 include/linux/memregion.h       |  16 ++-
 lib/Kconfig                     |   4 +
 lib/Makefile                    |   2 +
 lib/cache_maint.c               | 138 +++++++++++++++++++++++
 14 files changed, 439 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cache/hisi_soc_hha.c
 create mode 100644 include/linux/cache_coherency.h
 create mode 100644 lib/cache_maint.c

-- 
2.48.1


