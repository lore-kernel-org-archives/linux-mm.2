Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D61AC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F1B6B0098; Mon,  7 Sep 2026 08:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F06A6B009F; Mon,  7 Sep 2026 08:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEAC6B00A1; Mon,  7 Sep 2026 08:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0FC86B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82800140163
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:32 +0000 (UTC)
X-FDA: 85186957464.06.A9481B0
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DF9940008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ThNMN+Fx;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZLAu/+PwlI/1vW7fBJWuLttLveuekpMudYT1PoA2XHk=;
	b=Cykv1t6HkMWN60MJRcCrObUwPML1HpzIAxZ/SMXi+P0ZEK+lit6EKrw/k9YXC0iEo8dgTT
	j/zEqKEqs80mvAMQFROvDjMFy6XvUubdLE4wM4yXbHkVCBG8a++0ZWq3Hx3PrgTzHRaFQB
	Uj8se1GPgH9gLegL1VNuCuJmHDNbAAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785610;
	b=vIqrYwMGUU91cOZfKq59QwqXMA/Dtki2aNyQeAyj3D2JLYjKsvIjB4PclKhPynri7dM/zC
	NweW3+xz1GZilGcWDRklGGqzbxBNPz1CoCzyT1af7RreMx3f0v2GGDZk/pLfdvYia89XJh
	PgBttE01jUmLlXEb1EM9eXGkQIOKi0I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ThNMN+Fx;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZLAu/+PwlI/1vW7fBJWuLttLveuekpMudYT1PoA2XHk=;
	b=ThNMN+FxBCdWIa3igRbbj3G4vQna3kUdvEh4a4qbZ0YMCNk7MjR4gE1Ej8z5O9+GNqSc8wX9Z
	efxFd1I75WLYQaLT2MtzBZWRLgwFD+Qk0ky9w9w5LjP6zI9mZSdY4qgvBxbxfy2Jl3mJQTWzwsu
	apWZ3rKo5PKl0vlDknsCkXM=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hdmst1j7Jz1T4Fq;
	Mon,  7 Sep 2026 20:41:54 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 134E540575;
	Mon,  7 Sep 2026 20:53:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:21 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 00/12] crash: Rework and add arm64 crash hotplug support
Date: Mon, 7 Sep 2026 20:53:52 +0800
Message-ID: <20260907125404.922123-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3DF9940008
X-Stat-Signature: 75zk9aj5894ahrjopifppzfdn8p1cdn6
X-HE-Tag: 1788785608-770082
X-HE-Meta: U2FsdGVkX19Lq/qa1UGSoAF3nnhVQ9IZkkI/X+WrXFvqlfQPRpigKHYG6shn5wYHzVJL6eiGOFWUqyqddDDcA1Z0TWS4WNR+l/Mc0OIDkhe6hTWFUd57FZcE1f3Cg/AaP1jaK6x3V6OR1ASMjEPU4UxWOy3ONGfyBp972XH9fLz81+DZj3fa1uBLqlpoFncqW9KYj/KjUJB0Dgk70p4YKSnkeDMASfnhGu9+EQOSYrdwWo/FSnK/KZPDO9U1YXd6CiFaHqkhvN8PNe9g1lbE6WfdoP97MtXNnRkTmRI2uhzcwVcn34D48tLH/NDW0V9Thg+uduWF+YZ6Rr+Kv/WC7g8QWwBQcYgljc8CD8knSGGkZ1NGl5CGNvOsiLRn0Arl2MQ/EzphZ7MlS21aNwOApaJ8cMxnbDD8brlisN6sIRkb2b1bZi0KNDXqOitVYrFjqEQD3ARVkPv6w02Yjfdlk1AJuZ3CVNPdievuWrAtfb8uwp3CccP5CN6s0qVzM9v/lXVTQm9s6aSsZey3wwi16oh1MdlxhWkZ3LYOFU5egVfMRolykIzmPRGuPRpRd7tb8dexwSzD9HCKb0FPrgxf5R/ffuqSvegGo810fgCHypcpKaIw7vWZsbzEVvYlGx0HhHUrU4FvmTLT9HMvTsWRH0tuV9uy+BCYsN90Tsoh1g8/WvdDg9L0HRKOffnRUBZZxaPTYpjmKrDqBa86+OBS9n0VpODnSJ6ugknolytHYvQreAinQasRRS8XSccvPWst4h6n+RZh1PdsSVsA2HyyR9mndY72ddx8+YgGjqOtskLj0YHrGN3up87bVyMBIp14Us7PpMZW9TSpAV/VSHcRqOGSZKDnE8ayg8DIbKNPocNl/5fGEjEN+p1y7i8fJ6UqiIQfz9L0vCKUzUOpb3nNbotC+rpvWIwZIpE/UDhZ5tXBKI+NDBSLYChqQjof2BJ09n0Snvyrj7gv9bbuI7H
 x8rzTbhy
 MWGWZCnPUuJctYUcQtFF5Ixf6aDxy1qnt87Z7zI23uQ5KaFSHVh/wjL38npBqQ25dxaRxY7ozqVy+YuHrsX0StNNQ7TLBvqDTi0OBrgq2m7AcAmUTX5FMEIs/MY+AxydylcC7JoCzwfaM2/BXaEAinU3EIZbGUYzGogvpVxrx/Jp/JKnoA4r/jtouxeDfIL1ZjjmkCS6D/QvbPwx4uJc4QxrYEf72yQJkmVBtn94sHNTXm0FuD0CVcdOMERIpgvm9D8e2ftBXc8xah/KAt7+UA+erFTnkZ7ZGRuiqeFf7ZAX4LYbCk7EacFJsYxHipGPpRmX8KDFLGv64dNmOYijIu+MfMflUxLIoVagXMo3UgP+6MKjzdhlxNwpHVPsQGfkPHXuMtCH4G6ertJNBN0NNtsaeMrGjOsp6ZkWZ0SKqtN0i2hw=
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
- Simplify arm64 load_other_segments().
- Implement infrastructure for arm64 crash memory hotplug support.

This patch set is rebased on v7.3-rc1.

TESTING
=======

Only kexec_file_load path has been tested; kexec_load is expected to
work via KEXEC_CRASH_HOTPLUG_SUPPORT flag but not yet verified.

Tested on an arm64 guest using KVM-QEMU[3] with the following
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
[3]: https://github.com/salil-mehta/qemu.git virt-cpuhp-armv8/rfc-v2

Changes in v4:
- Rebased on v7.3-rc1.
- Update the kexec_core code as Mike suggested.
- Update the LoongArch subject as Huacai suggested.
- Drop crash_dump_dm_crypt patch which will be fixed by Coiby in [4] as
  Sourabh suggested.
- Drop x86 related patches because of branch conflict, which will
  be done later.
- Drop the incorrect CRASH_MAX_MEMORY_RANGES patch.
- Handle elfcorehdr_index in arm64 arch code.
- Link to v3: https://lore.kernel.org/all/20260826092541.3905933-1-ruanjinjie@huawei.com/

[4] https://lore.kernel.org/all/20260828084900.1496839-2-coiby.xu@gmail.com/

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

Jinjie Ruan (12):
  kexec: Record allocated CMA pages to fix release size mismatch
  kexec: Extract kexec_free_segment_cma() from kimage_free_cma()
  arm64: kexec_file: Fix CMA page leaks in segment placement retry loops
  arm64: kexec_file: Fix elf_headers memory leak in retry loop
  LoongArch: kexec_file: Fix CMA page leaks in segment placement retry
    loops
  LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
  crash: Extract crash_get_memory_ranges() helper
  crash: Fix TOCTOU race in crash memory range collection
  elf: Introduce elf64_phdr_size() helper
  crash: Introduce crash_extra_elfcorehdr_size() helper
  arm64: kexec_file: Simplify load_other_segments()
  arm64: crash: Add crash hotplug support

 arch/arm64/Kconfig                         |   3 +
 arch/arm64/include/asm/kexec.h             |  11 ++
 arch/arm64/kernel/Makefile                 |   2 +-
 arch/arm64/kernel/crash.c                  | 167 +++++++++++++++++++++
 arch/arm64/kernel/kexec_image.c            |   1 +
 arch/arm64/kernel/machine_kexec_file.c     |  63 +++-----
 arch/loongarch/kernel/kexec_efi.c          |   1 +
 arch/loongarch/kernel/machine_kexec_file.c |  10 +-
 arch/powerpc/kexec/crash.c                 |   2 +-
 arch/powerpc/kexec/file_load_64.c          |  19 +--
 arch/powerpc/platforms/powernv/opal-core.c |   3 +-
 arch/x86/kernel/crash.c                    |  12 +-
 fs/proc/vmcore.c                           |   6 +-
 include/linux/crash_core.h                 |  21 +++
 include/linux/elf.h                        |   4 +
 include/linux/kexec.h                      |   3 +
 kernel/crash_core.c                        |  50 +++++-
 kernel/kexec_core.c                        |  26 ++--
 kernel/kexec_file.c                        |  13 +-
 19 files changed, 326 insertions(+), 91 deletions(-)
 create mode 100644 arch/arm64/kernel/crash.c

-- 
2.34.1


