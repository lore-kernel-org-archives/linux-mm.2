Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765B4C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AAFD6B00AA; Thu, 27 Aug 2026 12:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173F46B00AC; Thu, 27 Aug 2026 12:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98EB6B00AF; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0006B00A9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8B12120121
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.03.544019A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0AF628000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BJTaHo4n;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sNvDMcYcMTOOUWSf0yI2ssQ/wZJvPJdat4hMuINy2z0=;
	b=LuD5QgO1BVITGofSpK8hlN3ElnFCs8fTT934u+qpDCAD7YYb91vD1E61Np2XZAUa00iaft
	uBObmn9CPWwb+R4+9n72IAQC7epafKJGNtTE2yzDfwcMHmcHBXmbi7fYfaXDGScKKAU6To
	+IetO7OgHEAiSPmf5pl2/qeT7moYt0w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BJTaHo4n;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847884;
	b=0HBU2dcgV9Gwj4zB5hrw/nTp0TALGv/qhCIQkZ2TMo3O1VZxux/JHwxjOVLTpfbT6woidM
	weDxIh2nhGZZbejh0vAE5V7dyH+h24i02LM4H9r59bt2vMQdr095UDgC4GSpl53JDaVoOX
	K9Dcy1+aax3fYGcBUoUJnGITUOqTShQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sNvDMcYcMTOOUWSf0yI2ssQ/wZJvPJdat4hMuINy2z0=;
	b=BJTaHo4n0ixCzKigfowoDpi1iFHxi/BPkiYvQINGtSZCkkOuUVNmJStblIjFJBX0MHygpMizO
	T93Fl6tGtVWApqAi048i50K1FsBqDB3x5gfEBI9dt6Gk9b8F9p3OdAtaAQIuBuLkQM1TcGjS5c6
	8nNX9Wr9Vl2naXdJkZbevwk=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KC4wvNzHnH56;
	Fri, 28 Aug 2026 00:23:59 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id AD9AA40570;
	Fri, 28 Aug 2026 00:24:35 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:35 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Fri, 28 Aug 2026 00:11:40 +0800
Message-ID: <20260827161158.3618409-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yzfeiqipmymn8nctc3xkaayeq47q43i7
X-Rspamd-Queue-Id: 0AF628000C
X-HE-Tag: 1787847883-533972
X-HE-Meta: U2FsdGVkX1991VgqUYW71b7ggWY0q1ydK8aJeiXiE7d8HmqPKxcycW4XDkjFzmnFr1zTA/ny3LE0TCf86aJK92VDjXYaqKAtaxsm39plnjcLHXUSLowGMUZRRNTO3RC2tLZPnhLTDzaSEKfDS1QENp5p0F0N0gI53pIFaWyuM08jBK130dJZILyIVBfefTIBwktfnt/nBSqEheFaq1cDLJruG6+t6z0aLdY1KuXIr+8ciVNAktrwJBRoieaitAWLXy2tKzvz9dFQwQo1XSC5iwzCag8X7WOAvtyJR1923m2hCtQ/qaUqWhz80s1iph+c/2ISWw9k8Trhe2jALtcxg2bO1X0K/xCN7ZX0OaFYCxLcM/nSJUk5KGF6Bdh9SzBvWFFohHxt/jz9LFKn9QuUjN/OOlHi3kB1s1L+EJO7MtAbCu5UgCI903at5GWM5FkEHqWDKs+IKTb5M1j5FZa9Zglli5pO8znZGk0J/S3KiXnVRe0Tp/vzj6BR8kjo3MfMp09rP7IowRxXeUFq/i8wk7GSc4HaP60ZEnWcc5LdDK0Uh7fznEN9+YpAiLX7uMqUBOhILDYm8jJN9JLygqMel4w84ZaWIdmFRbzixMwnq1R0iErmIMF08mNvjcxQCXaeviHWxdiP9pRsmtuS+xCmNY+ajG+ZIhrkuySEsg2WVGb0cGtqjufp520CHuF8sB1YaskO9wzSI6eMVXedymIhD4EFoRoP7B3kJUbYAHNnoJ0SLiKuKRy0gWC2IIN9VwKUU3AGptXBYUPyj1NSptjW1C5VIA4+zyaqqMMiuTL7fxtVkWRgI7+W3tVmDHA1fbAACtbzKW+FHN/ajW1N1c1pN44pMasYl0aEd8g96NB39T9reCMHu5EQzEG1G+J9YUblcAMfE/kG2rg/hWoisXuGku427xuKL7PWMMKZoFUzqXC5BhuqIfMlnPJdbIePBto1fZR5eBQ77p6VvJoYsnP
 paqhbfTD
 FgFAzErAxCmq0tm844r1XP5D4HtTt+9hrI3D5yFU6gPRsez+KHr33ieNbMW0+2f82I7mo85p8gC657vr1KLvywLJP88zdgbQ4qzGfaLDCZErnYrU51Sizcvu0FZVK9oxfgCfceB1h+GjL8sWy3O/wnutQSJSLMeGbLXLpFQ6XW0+Shq8mIhDxBJKwu+HqLlnbC0TK91UNxo1sl6WyZ1TcRwBlViIbOG5dI75Ji0FHWaPfACxoxvvLCUxyNqQKip+uZCVTVaycuHQZ9hpCl2vAWAeIhLi12ZFPqYd2CHiV2RTUCYQ7DG3ok4lpylWzT3L7blFetzY6lgzMTMAk1+4+BK0Cf0gS0qDBG6diIzuOqLCa7ANXDtx042y94Dr+YE91Dp3Cm9xUWzrdwiXGUfTx7/bNHkTIlHivhNZ6zEDILwvR9xo82tYZyU1EOR8ORE3sBxRXV5XsYOpaWitWg/eN2C98bK6SEmux5/O1I0XshWMTgTcM1YxEm68UEElAY542rNiEfaPaxL9C+hhTZiTUpQf06AsePqotIfZ/L4dVTz8ijIQ+VOm2P2dx1Uj3qkGPgOT6KbEQlWbqUuHuNh0StUxFjbXx24viUC9ePoVTA6tDpiSAPyjmvwKhzUKVn1EI9j0EDfc2JLwva3Ps1BeUlmpvySeiFvahwG4pU1JjVzD1Fx+WbEqpBbkeIf+kdMabCABtjWPAV7Xl212eJXaGM+vUylWE38q+Wr0y9zjynObpmXYivgH0/5qf8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current status:

There were several prior submissions with some sort of replication
for NUMA systems, including one from our side for the x86_64 platform.
In the last couple years, several research articles related to solving
locality issues on NUMA machines through replication emerged as well.

[1]  - arm64 kernel text replication
[2]  - x86 NUMA-aware kernel replication
[3]  - x86 kernel text replication
[4]  - NUMA replication of user data
[5]  - Mitosis: Transparently Self-Replicating Page-Tables for Large-Memory Machines
[6]  - WASP: Workload-Aware Self-Replicating Page-Tables for NUMA Servers
[7]  - PaCaR: Improved Buffered I/O Locality on NUMA Systems with Page Cache Replication
[8]  - Memory page replication for Linux on X86 processors
[12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)

As of today, none of it was merged into mainline.

Patch set description:

This patchset implements initial support of the kernel
text and ro-data replication for arm64 platform.
Linux-next was used as a baseline.
(903c1cf6dff9 Add linux-next specific files for 20260821).
This patch set heavily relies on our previous submission [2],
their generic part is the same, these solutions might be merged into a single one.
However, after thorough re-evaluation, we were not able to observe
performance improvement for the x86 platform, so we have decided to stop this
direction and switch on arm64.

Current implementation supports the next functionality:

1. Replicated kernel text and rodata per NUMA node
2. Vmalloc is able to work with replicated areas, so
   kernel modules text and rodata are also replicated during
   modules loading stage.
3. KPROBES, KGDB and all functionality that depends on
   kernel text patching work without any limitation.
4. KPTI, KASLR, and KASAN are supported.
5. Only part of a translation table related to
   replicated text and rodata is replicated
   (up to 2 pgd entries if kaslr is enabled)
6. 4K + 48bit and 64K + 48/52bit are supported and tested.
7. New cmdline option: "kernel_replication=on|off",
   to configure on the boot stage
8. For verification check dmesg output or /sys/kernel/debug/numa_replication/

In general, setting up a new pgd entry in kernel translation table
not often scenario, most of them are covered by current patch set.

TT overview:
                   NODE 0                   NODE 1
                   KERNEL                   KERNEL
           ---------------------    ---------------------
     PGD   |@| | |@|   | | | |*|    |@| | |@|   | | | |*|
           ---------------------    ---------------------
                              |                        |
            -------------------      -------------------
            |                        |
           ---------------------    ---------------------
     PUD   | | | | |   |@| |*|*|    | | | | |   |@| |*|*|
           ---------------------    ---------------------
                              |                        |
            -------------------      -------------------
            |                        |
           ---------------------    ---------------------
     PMD   |READ-ONLY|MUTABLE  |    |READ-ONLY|MUTABLE  |
           ---------------------    ---------------------
                  |       |                  |     |
                  |       --------------------------
                  |               |          |
                --------       -------      --------
   PHYS         |      |       |     |      |      |
    MEM         --------       -------      --------
                <------>                    <------>
                 NODE 0        Shared        NODE 1
                               between
                               nodes
* - entries unique in each table
@ - same entries accross replicated tables

Since for kernel space and user space different tables are used,
user space tables are not replicated at all, so synchronization
is not required.

Known problems:

1. Other combinations of base page size and va size (especially with 16K pages)
   should be adapted and verified.
2. Replicated translation tables for the vmalloc region are not local right now.
   Allocation performed with default memory policy, so translation tables
   for kernel modules will not be local. However,
   replicated text and rodata of the modules are local.
   In general, vmalloc patch should be cleaned up.
3. Any modifications of kernel PGD level. These modifications
   should be synchronized across all replicated tables.
   Right now, for example, memory hotplug/hotunplug
   lacks this support, vmemmap and kasan regions for
   added memory might not be observed correctly. This could be fixed
   by patching all places in the kernel where swapper_pg_dir
   is modified, or by "lazy" propagation on kernel faults in the pgd-level.
   Propagation approach will not help in the case of pgd_clear()
   on swapper_pg_dir though.

Overall, this patch set in an early PoC stage and require some improvements.

Overhead:

Memory overhead for the kernel itself is about 30MB per NUMA node
  on our deployment. For kernel modules - depends on their sizes, but text
  and ro-data are not that big.
CPU overhead - replication performed on the boot stage. After boot
  only "rare" operations are slowed down -
  module loading, text patching, kernel table pgd-level modifications.

Performance evaluation:

Our local testing was performed on
Kunpeng 920, 128 CPU, 4 nodes, 100Gb for each node.

Microbenchmark:
Kernel module with a huge text section (~50MB) filled with CPU-bound
instructions. For each NUMA node thread is spawned, each thread in a loop
executes isntructions. Total execution time of each thread is measured.
The insmod call bound to node 0 through numactl (less time is better).

node                 0        1        2        3
Before time, s     5.567    7.598   13.294   18.905
After  time, s     5.469    6.960    6.777    5.531

Diff               ~0%      -8.5%    -49%     -70%
In this benchmark, interconnect was not used by any other actors,
so microbenchmark numbers might be significantly improved.

Customer's evaluation:
We were provided with the following feedback on this patch set
directly from our customers. Unfortunately, we do not have details
regarding how these measurements were done other than it was
a production setup.
Evaulation was performed on Kunpeng 920 and 920B platforms:
CEPH distributed storage +5%
StarRocksDB              +5%

Couple more words about patch set and technology:

This patchset was merged into the innovative branch of
the openEuler distributive 1.5 year ago (openEuler-25.03)
and was actively tested in production environment [9], [10].
In addition, besides the kernel part, we have published
user space replication (for translation tables and rodata) as well,
but it is very complex and experimental
even compared to this patch set [11]. With replication in user
space, we were able to achieve the following numbers in
performance improvement:
MySQL + sysbench      1-6%
Spark TPC-H           4-20%
Phoronix test-suite   0-25%

Discussion:

The main question we'd like to discuss is the following:
Should the kernel replication feature be merged into the Linux
somewhere in the future? In any form, not specifically this patch set,
but the core concept itself.

If the answer is yes, please share your thoughts on this patch set. What else
should be fixed (or reimplemented and redsigned completly) in this patch
for mainline in your opinion? We'd be glad to do it, and in that case
I'll send an updated version in the near future.

[1]  https://lwn.net/ml/linux-doc/ZHYCUVa8fzmB4XZV@shell.armlinux.org.uk/
[2]  https://lwn.net/ml/linux-mm/20231228131056.602411-1-artem.kuzin@huawei.com/
[3]  https://lwn.net/Articles/36602/
[4]  https://lwn.net/Articles/45082/
[5]  https://github.com/mitosis-project/mitosis-asplos20-artifact
[6]  https://dl.acm.org/doi/10.1145/3620665.3640369
[7]  https://dl.acm.org/doi/10.1145/3767295.3769359
[8]  https://github.com/Carrefour/linux-replication
[9]  https://mailweb.openeuler.org/archives/list/kernel@openeuler.org/message/C7M5E2K2UD7FV7XYPWPZREJBCOCBIVRN/
[10] https://www.openeuler.org/whitepaper/en/openEuler%2025.03%20Technical%20White%20Paper.pdf
[11] https://mailweb.openeuler.org/archives/list/kernel@openeuler.org/message/73MAUDM6WCGSSOKPZGPNZAYRNQGUR6DE/
[12] https://lore.kernel.org/linux-mm/20260715180455.515692-1-yang@os.amperecomputing.com/

Nikita Panov (18):
  mm: arm64 add Kconfig option for kernel replication
  arm64: align kernel text and rodata
  mm: allow per-NUMA node local P4D/PUD/PMD/PTE allocation
  arm64: add arch callbacks for kernel replication
  mm: per-NUMA node replication core infrastructure
  mm: add support of memory protection for NUMA replicas
  arm64: add support of memory protection for NUMA replicas
  mm: set memory permissions for BPF handlers replicas
  mm: add replicas allocation support for vmalloc
  arm64: enable per-NUMA node kernel text and rodata replication
  mm: enable per-NUMA node kernel text and rodata replication
  arm64: make power management aware about kernel replication
  arm64: make kernel text patching aware about replicas
  arm64: add correct alignment to kimage in efi code
  arm64: add support of NUMA replication for ptdump
  arm64: add kernel modules text and rodata replication support
  mm: init kernel modules with replication support
  mm: introduce kernel cmdline option "kernel_replication="

 .../admin-guide/kernel-parameters.txt         |   7 +
 arch/arm64/include/asm/efi.h                  |  18 +-
 arch/arm64/include/asm/mmu_context.h          |   4 +
 arch/arm64/include/asm/numa_replication.h     |  54 ++
 arch/arm64/include/asm/pgtable.h              |   4 +
 arch/arm64/kernel/alternative.c               |  33 +-
 arch/arm64/kernel/hibernate.c                 |   5 +
 arch/arm64/kernel/module.c                    |  11 +
 arch/arm64/kernel/patching.c                  |  96 ++
 arch/arm64/kernel/sleep.S                     |   8 +
 arch/arm64/kernel/smp.c                       |   8 +
 arch/arm64/kernel/vmlinux.lds.S               |  22 +
 arch/arm64/mm/init.c                          |  49 ++
 arch/arm64/mm/kasan_init.c                    |   2 +
 arch/arm64/mm/mmu.c                           |  42 +-
 arch/arm64/mm/pageattr.c                      |  72 +-
 arch/arm64/mm/ptdump.c                        |  24 +-
 arch/arm64/net/bpf_jit_comp.c                 |   4 +-
 include/asm-generic/pgalloc.h                 |  90 ++
 include/asm-generic/pgtable-nop4d.h           |   5 +
 include/asm-generic/pgtable-nopmd.h           |   5 +
 include/asm-generic/pgtable-nopud.h           |   5 +
 include/asm-generic/set_memory.h              |  14 +
 include/linux/mm.h                            |  92 +-
 include/linux/mm_types.h                      |   3 +
 include/linux/moduleloader.h                  |   4 +
 include/linux/numa_kernel_replication.h       | 112 +++
 include/linux/set_memory.h                    |  21 +
 include/linux/vmalloc.h                       |  18 +
 init/main.c                                   |  17 +
 kernel/bpf/core.c                             |   4 +-
 kernel/bpf/trampoline.c                       |   2 +-
 kernel/module/main.c                          |  20 +
 kernel/module/strict_rwx.c                    |  12 +-
 mm/Kconfig                                    |  10 +
 mm/Makefile                                   |   2 +
 mm/execmem.c                                  |  39 +-
 mm/memory.c                                   | 129 +++
 mm/mm_init.c                                  |   3 +
 mm/numa_kernel_replication.c                  | 821 ++++++++++++++++++
 mm/vmalloc.c                                  | 454 ++++++++--
 41 files changed, 2246 insertions(+), 99 deletions(-)
 create mode 100644 arch/arm64/include/asm/numa_replication.h
 create mode 100644 include/linux/numa_kernel_replication.h
 create mode 100644 mm/numa_kernel_replication.c

--
2.34.1


