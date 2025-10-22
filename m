Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55793CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789E08E0010; Wed, 22 Oct 2025 07:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7614F8E0002; Wed, 22 Oct 2025 07:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E498E0010; Wed, 22 Oct 2025 07:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55DD88E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:33:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1F0D87990
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:33:58 +0000 (UTC)
X-FDA: 84025540956.05.0F68C53
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54BE7A000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:33:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132836; a=rsa-sha256;
	cv=none;
	b=FKT64RKEg9KxCWP66P22CHPz6NrDheIxP8vLaKLPi+QpU5tZzMK7aCty0V43i25VnOs+m1
	gViaPFWzOHwcDZUHXP3Y/t4PBrQKO5CtTJzgIH8umalFjLW5ZJLbiknaBJhyjaXKwPFZFj
	9tWFiLyqnEF9JI3tXNXgYxMb/rm1Vac=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Ws6nqB6HgODTdo+oD3MhV0Xqtt/ibjBkouNJ7xdECKg=;
	b=zGjpUYyhalAECnUXhhjPCvOKhggqEsSr74ZqIGVOzgjKGlIhObDwG99yKE1OOLD/PMdQh4
	u7v6JODR7+nRszXVRbmjCJFz+cIHufKJf24Z71bDO3hbjiFJHQJdc40DP8e5B4ut16qW+U
	ZOqutDgc/tnV6Q4aJ7HT9kI+ajf6vGs=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6RM1Yb4z6GDLk;
	Wed, 22 Oct 2025 19:30:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id ABDEB1400C8;
	Wed, 22 Oct 2025 19:33:51 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:33:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v4 0/6] Cache coherency management subsystem
Date: Wed, 22 Oct 2025 12:33:43 +0100
Message-ID: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: 6tsedgah9kwa911tp84tz13jdeb167bx
X-Rspamd-Queue-Id: 54BE7A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761132836-109306
X-HE-Meta: U2FsdGVkX18r1tKvaw4tdJZqKt7Tu8Sg/KxhU5gCIZZUHw/sapl5mCiKpzkqN8A6Wvp9/yLki/OJrqua4Fgg7eHPOkgXMxnDhYPFUb4X/kPRH1SVmXZZnJWWeU7VVnx6V/tNqWygh1ZL7c5LBAzgZaLODO/+o3/a/GqwTRpxn6lgRiyXlmticLaEmRd4HK7iyLwvlKOLJSlnU03rI55fPZTol/mMOi6YgkgZ2U66ovPIsbS2dOT+QIK5q3opClwGGa3zuPyNg9EZ+EbRQE8DY3rFlaS0uHYybACs1jLjHoDXGbkkwVNGZUHKXRIvEzWTHdAqDW0v90cwL7U24rUPrFQrluQbVSGjiJ7dWdCyTliQ6ClHk6IKuqSvDt/viv/F4UwER8XUhX2YqwmB9AstxZaVy86uWuj72TbNma+sVoNYapCsPIVInsh2Y5tasdcUp+FKGqIjA7wIaXw2pNXghCnV6dUUKq5TzXCfHU13aQHER+atAe6+v3Kz3KEyvAXmQnx5XxEkyNnT2XqpSY4RJUcdC8Jt54t2BZxcz/PnulDju/NBQiuxkQcTlyX2GuwxqGI+PMTi1e4p5PoVx5x4MkFhkZVUJYdTyu1U1TbwmqFPEM35/QAyuiqWHSY7sbKxLgiXOpUnYDlQLf8pHLwewWIjDTIYPkrp60B9fB0x+vuFwDAyi9uJ4evJT1PcT4yFjNLEdt2bniVYEeJmwThU8qu06gjANdNoWJ7KMUpaZVoe2u4g/FsKdPK/RzBOwQrNqr7C5weUqnWriuKcVgkD9Uwryqq2pSsXabwm079fRaRasZdQg0n9/KWbyqor9zbBPSDjaJQ/SLsPfMdB73aG0wlyH2HBqOJfkqxinKho9FEP+lKLDCMnrX+flapqa4HU+C3cHZPOBYSInANKhr4jdAdNaKHk4TRO5FXDIqQBzxYA8ySzu4RE6B79tR7WdsmU534namCVAX0133LXQss
 4QAeAKWk
 8jlstLByMSqxTv22SWN2jaVq0fMTwqpTYzRzyYX68U08Pb9EVEDnR9P/vjnacuHBhuoDKcLTj5HjlA/iLXBofp1Jbxq9BK8BK7SrkjNCa2Lq1dGxt0Kpe+YG8I/C5YBu+cllynK0jA3OjaBagszcIixISu8ezP7XXP08IGdNJmxb86JiTapqdXDRV/LyCW+euOu33
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

How to merge?  When this is ready to proceed (so subject to review
feedback on this version), I'm not sure what the best route into the
kernel is. Conor could take the lot via his tree for drivers/cache but
the generic changes perhaps suggest it might be better if Andrew
handles this?  Any merge conflicts in drivers/cache will be trivial
build file stuff. Or maybe even take it throug one of the affected
trees such as CXL.

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
 drivers/cache/hisi_soc_hha.c    | 191 ++++++++++++++++++++++++++++++++
 drivers/cxl/core/region.c       |   5 +-
 drivers/nvdimm/region.c         |   2 +-
 drivers/nvdimm/region_devs.c    |   2 +-
 include/linux/cache_coherency.h |  61 ++++++++++
 include/linux/memregion.h       |  16 ++-
 lib/Kconfig                     |   4 +
 lib/Makefile                    |   2 +
 lib/cache_maint.c               | 138 +++++++++++++++++++++++
 14 files changed, 436 insertions(+), 8 deletions(-)
 create mode 100644 drivers/cache/hisi_soc_hha.c
 create mode 100644 include/linux/cache_coherency.h
 create mode 100644 lib/cache_maint.c

-- 
2.48.1


