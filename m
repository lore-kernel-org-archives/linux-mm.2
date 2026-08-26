Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2DEC61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872396B0098; Wed, 26 Aug 2026 05:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8471D6B00E7; Wed, 26 Aug 2026 05:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8626B00E8; Wed, 26 Aug 2026 05:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6E36B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FD921202D2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:20 +0000 (UTC)
X-FDA: 85142887200.02.856ADA6
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id EF06840008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KBVStN8d;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736318;
	b=68HvEkh+yZhntBC+tkRugx9aX0gF3ZVQ8vNJbuaQTJAN2p+SOq4480wwLrCCZbeliAM0GW
	jXpDXsY3A9VhdAPMufNAC81GYnDiYf7TB3gHTXf3kdxunYeEioDdlZLC3ErZoWyA/f3XqN
	abXCQrU7CIyXLOR2ctCECD/QNWlSojo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KBVStN8d;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9edbR+c1lIWwnMXcuZ4KLnLfBU2ND4Eytl1ZUtAADc8=;
	b=HIKKTS6lrEgU/uXYa/uJWyC9puRhpa092G+MFr1R7pcZwLwL43jifBM3A94lJu+1mdjBqb
	1pEkl4fonCP7sVMzpILLdx57/ID2iZT7L/31op4PBiAnjWxLKzRdVsZJtuMJmtO8HbEPHu
	xbQplGeu/ls/OZoyZzjzDA7DglurRNk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9edbR+c1lIWwnMXcuZ4KLnLfBU2ND4Eytl1ZUtAADc8=;
	b=KBVStN8dWPuI9yiBGp/Kx3AtHQXr/JcHChmjwO+KMIF1cJvdn8dAp/8Bewckmuy7wkYaOMIR4
	ij3HNnpyCUcZ9hM3ZViAfMc6YQ+wna5UnBvYWUkemqrG8cx+eM57NwbIFrlq/YG3TQAKabbsqZR
	iOqhygocFvk052U3Kzzseq0=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVJr151wrzRhWY;
	Wed, 26 Aug 2026 17:14:25 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 61173202E6;
	Wed, 26 Aug 2026 17:25:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:06 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 00/17] crash: Rework and add arm64 crash hotplug support
Date: Wed, 26 Aug 2026 17:25:24 +0800
Message-ID: <20260826092541.3905933-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EF06840008
X-Stat-Signature: fxnxn47bhpepgrh17mw31btmby5893g7
X-Rspam-User: 
X-HE-Tag: 1787736316-875568
X-HE-Meta: U2FsdGVkX189Lg85K5Uv9MbBqU3SaZsZGF5hX3lPEftcqIE+C4Md6YT1a6T83uoGiVjOyXIBfjkUaif7k+73TM/nOVYf0DL/kOVnANuDOzNK0xXMYQwIHbUSnm3RGg6od55k0SVagVZjneMXv2h9xs5yJ5LLYT7Rz2ltuP4/bBkRftqNfvDimrByqp8VVL+beyXKX7z0E3FQcT84MuSd9zQ1aOLJJvl7DiXQsxiW95c9a+UA/hctxtmeBTOCIWBJBMRTfVRQf9+ttUwtzh+VFw9oYMtvRAmTPQYADgi+8hbO4bfj20YByeezbOcmjnflYJIyXsBHgJrGcFOZY8h/MJGjIP45CQ7UpTEOglR62ADai9GFvIEjD3/pyAH/4UAE88kz7+QVyJzJV1crhNySNGL4ZvWownN2wdmCD1rYISIrrStYlfeqEnvETsnCU1vPhMPFsqHKpePhnd1Y4czMNywCTAc9nzYCU770ZUIvb/YNl5iwfmvSAtNigjQvwB6ebc9ZrMb1JnvtFhqPBmOZBRt1gAVoMHQTmpZeeah8IRDIrh2UY3gl72LVpv1hV0w1rHVkNpKjoEg6tpsv9Cc7jkPqYdIjgiCWATZYz61BcEg0BmluBAqd0sXn+0+U0kyRrK4Y5w/3ldWo+Mnv1o44DsVTSUMUnNPouDOx3uFU23NI+Z51vbF6mOZRNtwX4HicfOdckcQHKtJY94Ap0pDOjM/7CD6JKuXMpE9ApScB/gvPjbuU2wmMPiEs1gtyzftttquu2L0Ez3nHZoQMoikzys2FjVIlLxVKnvhwa326stemVsk9OniScRkzRCJEC5m+msaR5LEK5CkENnXMIk4fHmMOeSHzqO3IdSUq8NBGnVSz3M50UVYK4jaUNcMsWti+xwQRNqAA3WP33GUPpAfmvP1h8RhuR+xxBjudl4e47a6bVtoFa2q7KH30ZvBkXLN4Ide87bOZeSXQK3fhlmj
 ppAGizVN
 tamsZzqwkiVPZwqzP5igWe/amJd+zqbRJkGdxxBNB07+Oke/+X0N7uQIYW+QP/0pjEByKZhglpV0qzVbKvaw4qyP89wFoLr4WlWrDxNDEU4E9f9SJKLMId+lVwHB1JpdxVgqODbIpxa6BkSN3LoBvv8SBM3tIpCCFVRN1h70JGlE2ymzEh8qytLlFKoCU5HilwV3Kg9MXDEWn3oL+dj65L1rZjcjgpGyLnN7yz1XuExc4alEQchNCMDc98D4WRI+6EHxrKwLV9/0xb36Jmcu3mh/RSg3Algl52HhJsAeFzeMgXGSOzW4ycZO34eK1kaeZ1oxynLQuBTiazOTKzNl1xaTiWa88TCZJzXXevKIKEbHJJw9lbSqgZS5Teajc5CklqOq47AxmON17uHtQSLOuEmVt64O02GbvIirl8H2emcdP7HgzlXMkegfdiuYHKChGB9ZkLvoSYMeFOEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CPU or memory hotplug events occur, the elfcorehdr in the kdump
image becomes stale, potentially leading to incomplete crash dumps.

Currently, userspace udev rules reload the entire kdump image upon such
events, which is inefficient and leaves kdump inactive for a long time.

Commit 247262756121 ("crash: add generic infrastructure for crash hotplug
support") introduced a kernel mechanism to update only the elfcorehdr.
This patch set implements crash hotplug support for arm64.

As Baoquan and Catalin suggested, it also addresses and fixes several
pre-existing code issues found by Sashiko AI [1][2].

The major improvements and fixes included in this series are:
- Fix several memory leaks for arm64, and similar issues on LoongArch.
- Fix TOCTOU race in crash memory range collection
- Simplify x86 related code.
- Simplify arm64 load_other_segments().
- Implement infrastructure for arm64 crash memory hotplug support.

This patch set is rebased on x86 fix [3].

TESTING
=======

Only kexec_file_load path has been tested; kexec_load is expected to
work via KEXEC_CRASH_HOTPLUG_SUPPORT flag but not yet verified.

Tested on an arm64 guest using KVM-QEMU[4] with the following
configuration:
        -M virt,acpi=on,highmem=on
        -m 4G,slots=256,maxmem=16G
        -smp cpus=4,maxcpus=8,cores=4,threads=2,sockets=1

1. Memory Hot-Add Test

[Step 1] Load kexec first:
        ./kexec --kexec-file-syscall ...

[Step 2] Hotplug and online 128M memory and trigger crash:
        (qemu) object_add memory-backend-ram,id=mem1,size=128M
        (qemu) device_add pc-dimm,id=dimm3,memdev=mem1,addr=0x160000000
        echo 1 > /sys/devices/system/memory/memory44/online
        echo c > /proc/sysrq-trigger

[Step 3] Verify vmcore layout in the secondary kernel:
        readelf -l /proc/vmcore

The newly added 128M memory segment (0x160000000) is successfully
recognized and populated as a LOAD segment:

        LOAD 0x... 0x0000000160000000 0x08000000 0x08000000 RWE 0x0

2. Memory Hot-Remove Test

[Step 1] Add memory device and online 128M memory first:
        (qemu) device_add pc-dimm,id=dimm3,memdev=mem1,addr=0x160000000
        echo 1 > /sys/devices/system/memory/memory44/online

[Step 2] Load kexec, offline memory, and crash:
        ./kexec --kexec-file-syscall ...
        echo 0 > /sys/devices/system/memory/memory44/online
        echo c > /proc/sysrq-trigger

[Step 3] Verify vmcore layout:
        readelf -l /proc/vmcore

Result: The 0x160000000 segment is cleanly excluded from the vmcore
        program headers, and the dump completes without any hang.

3. CPU Hot-Add Test

[Step 1] Load kexec first:
        ./kexec --kexec-file-syscall ...

[Step 2] hotplug and online one CPU, then crash:
        (qemu) device_add driver=host-arm-cpu,core-id=2,thread-id=0,id=cpu4
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo c > /proc/sysrq-trigger

[Step 3] Verify notes count:
        readelf -n /proc/vmcore | grep -w CORE | wc -l
        5

Result: Crash hotplug responds correctly; the newly plugged CPU4 is
        tracked, and 5 NT_PRSTATUS notes are generated.

4. CPU Hot-Remove Test

[Step 1] Add CPU device and online it first:
        (qemu) device_add driver=host-arm-cpu,core-id=2,thread-id=0,id=cpu4
        echo 1 > /sys/devices/system/cpu/cpu4/online

[Step 2] Load kexec, remove CPU, and crash:
        ./kexec --kexec-file-syscall ...
        (qemu) device_del cpu4
        echo c > /proc/sysrq-trigger

[Step 3] Verify notes count:
        readelf -n /proc/vmcore | grep -w CORE | wc -l
        4

Result: Crash hotplug automatically updates the headers upon CPU
        eviction; only 4 online CPUs are registered in the vmcore.

[1]: https://lore.kernel.org/all/20260601094805.2928614-1-ruanjinjie@huawei.com/
[2]: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
[3]: https://lore.kernel.org/all/20260826073527.21487-2-ionut.nechita@windriver.com/
[4]: https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v2

Changes in v3:
- Handle "KEXEC_CRASH_HP_REMOVE_MEMORY" action.
- Fix several pre-existing code issues reported by Sashiko AI review [3].
- Introduce crash_extra_elfcorehdr_size() and elf64_phdr_size() helper.
- Rework related crash and arch code.
- Add test method.
- v2: https://lore.kernel.org/all/20260729031235.2840255-1-ruanjinjie@huawei.com/

Changes in v2:
- Split out Powerpc bugfix patch as Mike suggested.
- Use phys_to_virt() instead of __va() in update_crash_elfcorehdr().
- Convert pnum_hdr_sz() to a function.
- Only assign elfcorehdr_index after kexec_add_buffer succeeds, considering
  crash_handle_hotplug_event() already performs validity check on
  elfcorehdr_index:
  - We can safely remove the check for CPU hotplug
    in arch_crash_handle_hotplug_event().
  - The elfcorehdr_index's segment mem will be valid in
    update_crash_elfcorehdr(), so we can safely remove the NULL check.
- Simplify the commit message.
- v1: https://lore.kernel.org/all/20260723131242.1537633-1-ruanjinjie@huawei.com/#t

Jinjie Ruan (17):
  kexec: Record allocated CMA pages to fix release size mismatch
  kexec: Extract kexec_free_segment_cma() from kimage_free_cma()
  arm64: kexec_file: Fix CMA page leaks in segment placement retry loops
  arm64: kexec_file: Fix elf_headers memory leak in retry loop
  LoongArch: kexec: Fix CMA page leaks in segment placement retry loops
  LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
  crash_dump: Fix potential double-free of keys_header
  crash: Extract crash_get_memory_ranges() helper
  crash: Fix TOCTOU race in crash memory range collection
  elf: Introduce elf64_phdr_size() helper
  crash: Introduce crash_extra_elfcorehdr_size() helper
  x86/crash: Use num_possible_cpus() for elfcorehdr size
  crash: Improve elfcorehdr segment identification
  x86/crash: Simplify crash_load_segments() using
    crash_extra_elfcorehdr_size()
  crash: Simplify CRASH_MAX_MEMORY_RANGES handling
  arm64: kexec_file: Simplify load_other_segments()
  arm64: crash: Add crash hotplug support

 arch/arm64/Kconfig                         |   3 +
 arch/arm64/include/asm/kexec.h             |  11 ++
 arch/arm64/kernel/Makefile                 |   2 +-
 arch/arm64/kernel/crash.c                  | 165 +++++++++++++++++++++
 arch/arm64/kernel/kexec_image.c            |   1 +
 arch/arm64/kernel/machine_kexec_file.c     |  57 ++-----
 arch/loongarch/kernel/kexec_efi.c          |   1 +
 arch/loongarch/kernel/machine_kexec_file.c |  10 +-
 arch/powerpc/kexec/crash.c                 |   6 +-
 arch/powerpc/kexec/file_load_64.c          |  19 +--
 arch/powerpc/platforms/powernv/opal-core.c |   3 +-
 arch/x86/kernel/crash.c                    |  46 ++----
 fs/proc/vmcore.c                           |   6 +-
 include/linux/crash_core.h                 |  27 ++++
 include/linux/elf.h                        |   4 +
 include/linux/kexec.h                      |   3 +
 kernel/Kconfig.kexec                       |   3 +-
 kernel/crash_core.c                        |  57 ++++++-
 kernel/crash_dump_dm_crypt.c               |  15 +-
 kernel/kexec_core.c                        |  26 ++--
 kernel/kexec_file.c                        |  16 +-
 21 files changed, 352 insertions(+), 129 deletions(-)
 create mode 100644 arch/arm64/kernel/crash.c

-- 
2.34.1


