Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEE6FEE4CC
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 07:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017486B008C; Sat, 28 Feb 2026 02:15:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41E36B0092; Sat, 28 Feb 2026 02:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8FD6B0093; Sat, 28 Feb 2026 02:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC76E6B008C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 02:15:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9976C1A0B3E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:32 +0000 (UTC)
X-FDA: 84493004904.13.8D20044
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 709C9180009
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:15:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EodAyxOm;
	spf=pass (imf06.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772262931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mFgtGAL8dH+1/Hg4XeTLDkYoN8VuWkxKnd+XeVBTUlY=;
	b=qdmYBvdmlKh2nxj/R3VZi6W/7+/E40eDyqWXj3MX99WCDAW1UsVSBkoXh9e+/iKsYhqO1B
	4V1ChYhs0jhlHuYVslUBzhdZU6JAAGrl70zz5gwXYAze5PB2Q+WkS7pvys8rb2sIE6DDAa
	cG8HgJrn6eSQe48mDNVVqGAKLS3+Iyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772262931; a=rsa-sha256;
	cv=none;
	b=J0oxuS0soJ8pzPxLxYu+1nHVPopTZ6OpZu7MBs6NKKJWU7pJYlQ4mfHbNVd/7EgNwAEnkv
	JD/Hd7zUWcdZ89PiNCmyqOhSLkUJq+LA7hvyo2ep7gCjhcYyOyyLIMk7NDZHRWlP1f9rYy
	F/2L9J2AyND6jjrGemVBIwsGXDKedpk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=EodAyxOm;
	spf=pass (imf06.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mFgtGAL8dH+1/Hg4XeTLDkYoN8VuWkxKnd+XeVBTUlY=;
	b=EodAyxOmCYEFBPJpOjKo/Q3dPBnTr3eTjEpNxA4EGPuNhVCUFFJb/pc866X3VVGXjINMZ1K1d
	oF1qyVtJKV92neV+7AcQ5SlekmeKj2yatm5oTRu8OdZVHqNQTfvVhjtjC9bAf7PddXOeIA34Fgh
	1Aw0pwSSMio3RYaiRPOZi/g=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fNGYJ2b1PzcZy3;
	Sat, 28 Feb 2026 15:10:12 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 70D9A40561;
	Sat, 28 Feb 2026 15:15:18 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Feb
 2026 15:15:17 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <Jonathan.Cameron@huawei.com>,
	<riel@surriel.com>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC v3 0/4] mm: add huge pfnmap support for remap_pfn_range()
Date: Sat, 28 Feb 2026 15:09:02 +0800
Message-ID: <20260228070906.1418911-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 709C9180009
X-Stat-Signature: uwmqkgytgy7pbrwieg4ogd45rscrwzun
X-Rspam-User: 
X-HE-Tag: 1772262924-563626
X-HE-Meta: U2FsdGVkX19j7lKp1TNS4ELhRJgwAF0QXJTJQMIIcoIkSlQ7owl86/TrPmbPNyIS6VrnrkViOChn+dgmQcbkBFTTd/UiqKlQH3fIvf5QbJFtWb9eZqMyK/Kn3Uy1N6G0PN277qFlWXCY5vZHZ0GoSLymx3GintmOoazIf/1zrXSXZlAY1y5RKq3lIVX8ArvsYInl/d9q3klN4cS5mwmhXxiHMwIpWHT/TgnEwzIjbQ1FcBuivI5TAp0Pl7IUO5LyT8ZNBR+BTMrCqPBTlI4qr+nllCvXNdo6n4NhPCDhBroaRwW+RvxkazPCDglKtXyQ6W5JCoH4dBrzmypZyaN6bCUFh4hWdW1naGcEhAQerKGe0nixd8UWEE343Z6rpi8YS69/71BOnh0A3ljp7FHPFk3eivD0IyjdQwE2fWTkeGP5ioyBlqk8sxJZcfyz6RFr4+6cg6GSJlK/I/s263CGPsje/ajGf0lHf5vpxSUQdqELaPHgjLPItMRsXXqvM0PrHkEaEhpsMD4Y4jnZBHKE7MycT53sj+2dZgRFlvWLCKY0dZvcUyGdo1dFBzhkZm+27sYK3W8/ks6hLa2CDKdBq3HJH7lDeNZOvZYXH8QDG7JFgNJNe5zpEAY6j8cdfOyv6TmYm7EBPGqeoYG1r4PloJ09V8m/y8/Bp4JSxjoim0MpimtcAYDcG9wUaBboAsJl5EYoPdEQv086hs4FTwpDr0Nou6BAHQyA40Z3fHyO8Pf76O/9Re5iZVYYQqcMc9eJcWn6NaN/Ef4gXa2tj80SeRDoOzbbhPj4SrVTx5Ga5VGbk9AtCOJnuJ0ZK+jKOsWlQRLDc7Vt8mLY+Taki1dspvpOT4b/ixPcV0mzkdTvofduECUT0ljb2K/YfH6oQgptmqbZskDMXo3rQuwcgrX4x5gK1XaUlGTpIvaXKGr8iFcskzZzFfIoRJZBe5kBMi0qcN1S9wU772+7gM4dA5k
 rVez/y8I
 efbuu20hZwmQLwPp+0J/7MIvk3Gdsj9iWjH3UtlozFm/pqmPUydJWrMyOHP35bOM7+wWjiuHStN5dn/KCeSaBjT4oCZyEJg9aUQR6lPvqT5KVsVkbwAxhSbInbVU/qxccrFEEpXOen4PvXZKo5nzSvn63xi8tOAUEj1tC6dDArA9fYob51Z2F98oWMU18ZAgJkKr8VQCu4FrdS7cB29lMdn6Skbi1s81Ople9UIJfwpX6Iryn+EnVZ1xYDxFBntZftcSkuErY1wSsTPc+CujVlkgp0n6xSK2LIHq0dE05e1pvs0ngfAt5ATmZ1Eorxu+clxkEHDKQ1EsUK2uC+1ccaJXVd9SRoyNDS8EbznWeJYAm/mLxwK7H5Z0cl+mxDuXo9d0P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3:
1. Architectural Type Safety (Matthew Wilcox):
Following the insightful architectural feedback from Matthew Wilcox in v2,
the approach to clearing huge page attributes has been completely redesigned.
Instead of spreading the `pte_clrhuge()` anti-pattern to ARM64 and RISC-V,
this series enforces strict type safety at the lowest level: `pfn_pte()`
must never natively return a PTE with huge page attributes set.

To achieve this without breaking the x86 core MM, the series is structured as:
  - Fix historical type-casting abuses in x86 (vmemmap, vmalloc, CPA) where
    `pfn_pte()` was wrongly used to generate huge PMDs/PUDs.
  - Update `pfn_pte()` on x86 and ARM64 to inherently filter out huge page
    attributes. (RISC-V leaf PMDs and PTEs share the exact same hardware
    format without a specific "huge" bit, so it is naturally compliant).
  - Completely eradicate `pte_clrhuge()` from the x86 tree and clean up
    the type-casting mess in `arch/x86/mm/init_64.c`.

2. Page Table Deposit fix during clone() (syzbot):
Previously, `copy_huge_pmd()` was unaware of special PMDs created by pfnmap,
failing to deposit a page table for the child process during `clone()`.
This led to crashes during process teardown or PMD splitting. The logic is now
updated to properly allocate and deposit pgtables for `pmd_special()` entries.

v2: https://lore.kernel.org/linux-mm/20251016112704.179280-1-yintirui@huawei.com/#t
- remove "nohugepfnmap" boot option and "pfnmap_max_page_shift" variable.
- zap_deposited_table for non-special pmd.
- move set_pmd_at() inside pmd_lock.
- prevent PMD mapping creation when pgtable allocation fails.
- defer the refactor of pte_clrhuge() to a separate patch series. For now,
  add a TODO to track this.

v1: https://lore.kernel.org/linux-mm/20250923133104.926672-1-yintirui@huawei.com/

Overview
========
This patch series adds huge page support for remap_pfn_range(),
automatically creating huge mappings when prerequisites are satisfied
(size, alignment, architecture support, etc.) and falling back to
normal page mappings otherwise.

This work builds on Peter Xu's previous efforts on huge pfnmap
support [0].

TODO
====
- Add PUD-level huge page support. Currently, only PMD-level huge
pages are supported.

Tests Done
==========
- Cross-build tests.
- Core MM Regression Tests
   - Booted x86 kernel with `debug_pagealloc=on` to heavily stress the
     large page splitting logic in direct mapping. No panics observed.
   - Ran `make -C tools/testing/selftests/vm run_tests`. Both THP and
     Hugetlbfs tests passed successfully, proving the `pfn_pte()` changes
     do not interfere with native huge page generation.
- Functional Tests (with a custom device driver & PTDUMP):
   - Verified that `remap_pfn_range()` successfully creates 2MB mappings
     by observing `/sys/kernel/debug/page_tables/current_user`.
   - Triggered PMD splits via 4K-granular `mprotect()` and partial `munmap()`,
     verifying correct fallback to 512 PTEs without corrupting permissions
     or causing kernel crashes.
   - Triggered `fork()`/`clone()` on the mapped regions, validating the
     syzbot fix and ensuring safe pgtable deposit/withdraw lifecycle.
- Performance tests with custom device driver implementing mmap()
  with remap_pfn_range():
    - lat_mem_rd benchmark modified to use mmap(device_fd) instead of
      malloc() shows around 40% improvement in memory access latency with
      huge page support compared to normal page mappings.

      numactl -C 0 lat_mem_rd -t 4096M (stride=64)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      64.00               148.858 ns           100.780 ns        32.3%
      128.00              164.745 ns           103.537 ns        37.2%
      256.00              169.907 ns           103.179 ns        39.3%
      512.00              171.285 ns           103.072 ns        39.8%
      1024.00             173.054 ns           103.055 ns        40.4%
      2048.00             172.820 ns           103.091 ns        40.3%
      4096.00             172.877 ns           103.115 ns        40.4%

    - Custom memory copy operations on mmap(device_fd) show around 18% performance 
      improvement with huge page support compared to normal page mappings.

      numactl -C 0 memcpy_test (memory copy performance test)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      1024.00             95.76 ms             77.91 ms          18.6%
      2048.00             190.87 ms            155.64 ms         18.5%
      4096.00             380.84 ms            311.45 ms         18.2%

[0] https://lore.kernel.org/all/20240826204353.2228736-2-peterx@redhat.com/T/#u

Yin Tirui (4):
  x86/mm: Use proper page table helpers for huge page generation
  mm/pgtable: Make pfn_pte() filter out huge page attributes
  x86/mm: Remove pte_clrhuge() and clean up init_64.c
  mm: add PMD-level huge page support for remap_pfn_range()

 arch/arm64/include/asm/pgtable.h |  4 +++-
 arch/x86/include/asm/pgtable.h   |  9 ++++---
 arch/x86/mm/init_64.c            | 10 ++++----
 arch/x86/mm/pat/set_memory.c     |  6 ++++-
 arch/x86/mm/pgtable.c            |  4 ++--
 mm/huge_memory.c                 | 36 ++++++++++++++++++++++++++--
 mm/memory.c                      | 40 ++++++++++++++++++++++++++++++++
 7 files changed, 93 insertions(+), 16 deletions(-)

-- 
2.22.0


