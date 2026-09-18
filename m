Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CC8C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072846B00A3; Fri, 18 Sep 2026 06:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CB06B00A6; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB206B00A4; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B24B6B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9C0F1405DC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:38 +0000 (UTC)
X-FDA: 85226448636.06.9F997D6
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf09.hostedemail.com (Postfix) with ESMTP id 89997140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dTuhtcwS;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725877;
	b=l85EbwAqPS1g+ZDDazSGlCJCqHk3j35M4MG/LXUlVx804k6sRETCtn3CG99DLhGeKngNta
	326rbTP6H9g2A/Wq2IPbJfGIyvUzM0VBk+7AK4H7hIlpPDaCOrXtDm/4Hr0Oiji0IxRxYt
	vC3qkK/pzi72XPPL+PT65LP/wkgokGU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dTuhtcwS;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBoAe3J5L5xeTOESkZrKV2F9E4gAR8UGD40P6q3mXxY=;
	b=nO4wU7W+qjM3bQuHlzQmVbAiZHQItUKeqfJCV7sNYIe6M3aZnDpXw7Ozz4UGkWlRAcfwkz
	0ymTDWiquApMabfzfJqLxtePJ/oM4ysFckt7boFLc1gsh0iRJI9dMn6PtYmI/U6c13xP70
	LJVvSp+0xe8GyebktwWLDxA2KPBmrG8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GBoAe3J5L5xeTOESkZrKV2F9E4gAR8UGD40P6q3mXxY=;
	b=dTuhtcwSh/o5shWC0RoXx2lcvY/zYvyJR2Kz9hjSNHzX9HE953qpbG9U7PH1h/b0Pzl5cdz9y
	u/4FTCFoKvtgjAfRGJYMjTPsm3gD2Yas+qmy/I2kYMKOsOPq1PF47iCv/rkfr8ZNIN6qj6UZOvJ
	h4w+ZCHTuPAhooLAh+ate2o=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hmScZ3Jsrz1cyVf;
	Fri, 18 Sep 2026 17:53:34 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id ACEB140586;
	Fri, 18 Sep 2026 18:04:33 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:32 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 17/17] arm64: crash: Add crash hotplug support
Date: Fri, 18 Sep 2026 18:04:42 +0800
Message-ID: <20260918100442.3841135-18-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89997140003
X-Stat-Signature: bwf8nzji7i8zsmjk6wnskaaabzud4ezi
X-Rspam-User: 
X-HE-Tag: 1789725876-77668
X-HE-Meta: U2FsdGVkX1894O5G8p3eVfP1pM5jrbb9N2DMZlgE+jvTuASjQLBnlIY9GMStFPjr2YFSNhWlOthg59qESWQl1IL1rlFNYgRmblgt+Gf6DUBETZF366LcUCr4U7seuKHf51R4Q7M8ZgW8Kt+XzZ3UrGkhSauSlSU7FFffhUt/Ox8BlK9zSw+2JzyLUfxzCAaHNEiQZwURxEuZHF5QDP7rk6OnNfVjIlVz0qLxmM/VEL8CMF/zopqfs2dHtoVG+Fm2zLPydbBl7l+Jk4qSSBagWg+az9bDxZYiAG+1uERqU4daSBeF14eaNiYpa1egpqsY+dBofsK4sZ23VzZ65fHHkadYGfB6Xo7OpZarqR6aPd0mIjA4qTS135+3243ZgaKfZSXqiFhV+y9PF8Hn3CWuy0WxDzr0iWqw2OMpz66SlcaUxa+DHt/wOZpfhR6cc+043x1wYtleVb4yXyjW62yD+RjmD3tNOSTc9cW98tEh0r9xHE3Kb0VNEs5OIAoze8wRjWFclJwhisAC5vgK2UmZTRLczNHoqUzfTWb4Y+wAuWMLRlYN3A2gESchQZLp0t5rUI4psajD7JZd9I99ovwZO1qJAWDILXi5VVOMFoxVKTxg23m2JAS6l0iN0UioYvRz1+nsSrbioVxt/S1AyY1ZaqFHOfxmzokroRoKyj6gA2R4X3mb9kUIzGec3McYJtL6Kl+AgjP1adljHt4I7b1EfMuWJBqCzpDioTeLyOJiWFBWTWS3PvZk+yPGT5hAfaTqZyPSXSowtS8sNWF3cCE1Zx8kVEqjNE1VjFU2vZKctSVW+ADhzGMSEJvOcyaIAG2c4G0LGfpls/FAmAi6i2jKCAtTFrUOezCkHOtTdBgSdxWw/EArS5TfV4dkqbQMIgeQzEdmGG9nOfMxJbmHJqWxVmo3BHv9EMtb2OoNXAIQldWyw0NTzJ6ic/lBEXl9Cj/k26tHeU/gIZYPxMppiZY
 0jR3dp7C
 ZaKs+hpE5Fx1G/gljbq2RCAJzbzBfmPlh48TwT+MFqTBr8oio4iHjbT9yIna3xJjsTTroBOP2HgQ54jlVq8KvdkJICY5fgUVzz2YINQnE/L6zdbxEUw+DQE4UvING93hnAmKh09ZXvoYrWdlX/GkwHWizckpgRqoPe/em1l4B0Psd3gp/J+cZmczPeFTg9XQclzgD9gzJpizGoXlp7UbNL2QJnF94gjR1958Vm91kM+AHW29rOaYO31jJIKg40OCXyxhRd0ZecB92N1G/FiSWcaHLiJxPO8n/6NY9ewTcsEBAyVUyZ7mBIwW2htJqqRi1GC3kiCni7sQJsmJ6UuOikkcYnDwDNSAgv2l8lsq324fpgA7uDba/+NJweor1GRf6Q5ESGCsbSHzSr/NPttWj1eMcap0x4GDH8zGvO5kuYwkIRkhcKknMVSv1Pee/SVpVlgDnLWsvK80KDrAGjDjdWSctXt8dzvrUQ3v+G6qmHLRACrZIMqg9Z4cz1ZmVTh0fMfcACNRqJIEbILhWGAeR8GArKtRuTkSSg3Et35wIJSEWijVkfdlyeRK0/ilT7HfL6SHGF9+AU2wNuA0=
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
This patch enables that support for arm64.

On arm64, only memory hotplug events require elfcorehdr updates:
- Physical CPU hotplug is not supported.

- For ACPI based vCPU hotplug [1], the elfcorehdr is built using
  for_each_possible_cpu(), so no update is needed.

The patch:
- Adds CONFIG_ARCH_SUPPORTS_CRASH_HOTPLUG (default y).

- Implements following arch functions to handle memory hotplug:
  1. arch_crash_hotplug_support()
  2. arch_crash_get_elfcorehdr_size()
  3. arch_crash_handle_hotplug_event()

- Moves arch_get_system_nr_ranges() and arch_crash_populate_cmem()
  from machine_kexec_file.c to crash.c for crash hotplug reuse.

Follows the approach of x86 commit ea53ad9cf73b ("x86/crash: add x86 crash
hotplug support") and powerpc commit b741092d5976 ("powerpc/crash: add
crash CPU hotplug support").

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
[1]: https://lore.kernel.org/all/20240529133446.28446-1-Jonathan.Cameron@huawei.com/
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/Kconfig                     |   3 +
 arch/arm64/include/asm/kexec.h         |  11 ++
 arch/arm64/kernel/Makefile             |   2 +-
 arch/arm64/kernel/crash.c              | 171 +++++++++++++++++++++++++
 arch/arm64/kernel/machine_kexec_file.c |  42 ++----
 5 files changed, 196 insertions(+), 33 deletions(-)
 create mode 100644 arch/arm64/kernel/crash.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..96de2660b1cb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1720,6 +1720,9 @@ config ARCH_DEFAULT_CRASH_DUMP
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
 	def_bool CRASH_RESERVE
 
+config ARCH_SUPPORTS_CRASH_HOTPLUG
+	def_bool y
+
 config TRANS_TABLE
 	def_bool y
 	depends on HIBERNATION || KEXEC_CORE
diff --git a/arch/arm64/include/asm/kexec.h b/arch/arm64/include/asm/kexec.h
index 892e5bebda95..f165c094b32e 100644
--- a/arch/arm64/include/asm/kexec.h
+++ b/arch/arm64/include/asm/kexec.h
@@ -130,6 +130,17 @@ extern int load_other_segments(struct kimage *image,
 		char *cmdline);
 #endif
 
+#ifdef CONFIG_CRASH_HOTPLUG
+void arch_crash_handle_hotplug_event(struct kimage *image, void *arg);
+#define arch_crash_handle_hotplug_event arch_crash_handle_hotplug_event
+
+int arch_crash_hotplug_support(struct kimage *image, unsigned long kexec_flags);
+#define arch_crash_hotplug_support arch_crash_hotplug_support
+
+unsigned int arch_crash_get_elfcorehdr_size(void);
+#define crash_get_elfcorehdr_size arch_crash_get_elfcorehdr_size
+#endif
+
 #endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index d2690c3ec528..9bbac452994c 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -64,7 +64,7 @@ obj-$(CONFIG_KEXEC_CORE)		+= machine_kexec.o relocate_kernel.o	\
 obj-$(CONFIG_KEXEC_FILE)		+= machine_kexec_file.o kexec_image.o
 obj-$(CONFIG_ARM64_RELOC_TEST)		+= arm64-reloc-test.o
 arm64-reloc-test-y := reloc_test_core.o reloc_test_syms.o
-obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
+obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o crash.o
 obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
 obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
diff --git a/arch/arm64/kernel/crash.c b/arch/arm64/kernel/crash.c
new file mode 100644
index 000000000000..08dc9b952498
--- /dev/null
+++ b/arch/arm64/kernel/crash.c
@@ -0,0 +1,171 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Architecture specific functions for kexec based crash dumps.
+ */
+
+#define pr_fmt(fmt)	"crash hp: " fmt
+
+#include <linux/cacheflush.h>
+#include <linux/elf.h>
+#include <linux/kexec.h>
+#include <linux/memblock.h>
+#include <linux/memory.h>
+#include <linux/vmalloc.h>
+
+#include <asm/kexec.h>
+
+#if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_HOTPLUG)
+unsigned int arch_get_system_nr_ranges(void)
+{
+	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end)
+		nr_ranges++;
+
+	/* Memory hot-unplug may cause range split. So add an extra slot here. */
+	if (IS_ENABLED(CONFIG_CRASH_HOTPLUG))
+		nr_ranges++;
+
+	return nr_ranges;
+}
+
+int arch_crash_populate_cmem(struct crash_mem *cmem)
+{
+	phys_addr_t start, end;
+	u64 i;
+
+	for_each_mem_range(i, &start, &end) {
+		cmem->ranges[cmem->nr_ranges].start = start;
+		cmem->ranges[cmem->nr_ranges].end = end - 1;
+		cmem->nr_ranges++;
+	}
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_CRASH_HOTPLUG
+int arch_crash_hotplug_support(struct kimage *image, unsigned long kexec_flags)
+{
+#ifdef CONFIG_KEXEC_FILE
+	if (image->file_mode)
+		return 1;
+#endif
+	/*
+	 * For kexec_load syscall, crash hotplug support requires
+	 * KEXEC_CRASH_HOTPLUG_SUPPORT flag to be passed by userspace.
+	 */
+	return kexec_flags & KEXEC_CRASH_HOTPLUG_SUPPORT;
+}
+
+unsigned int arch_crash_get_elfcorehdr_size(void)
+{
+	unsigned long phdr_cnt;
+
+	/* A program header for possible CPUs, vmcoreinfo and kernel_map */
+	phdr_cnt = 2 + num_possible_cpus();
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
+
+	return elf64_phdr_size(phdr_cnt);
+}
+
+/**
+ * update_crash_elfcorehdr() - Recreate the elfcorehdr and replace it with old
+ *			       elfcorehdr in the kexec segment array.
+ * @image: the active struct kimage
+ * @mn: struct memory_notify data handler
+ */
+static void update_crash_elfcorehdr(struct kimage *image, struct memory_notify *mn)
+{
+	void *elfbuf = NULL, *old_elfcorehdr;
+	unsigned long mem, memsz, elfsz = 0;
+	struct crash_mem *cmem = NULL;
+	u64 start, end;
+	int ret;
+
+	ret = crash_get_memory_ranges_nolock(&cmem);
+	if (ret) {
+		pr_err("Failed to get crash memory ranges.\n");
+		goto out;
+	}
+
+	/*
+	 * The hot unplugged memory is part of crash memory ranges,
+	 * remove it here.
+	 */
+	if (image->hp_action == KEXEC_CRASH_HP_REMOVE_MEMORY) {
+		start = PFN_PHYS(mn->start_pfn);
+		end = start + PFN_PHYS(mn->nr_pages) - 1;
+
+		ret = crash_exclude_mem_range(cmem, start, end);
+		if (ret) {
+			pr_err("Failed to remove hot-unplugged memory from crash memory ranges.\n");
+			goto out;
+		}
+	}
+
+	/*
+	 * Create the new elfcorehdr reflecting the changes to CPU and/or
+	 * memory resources.
+	 */
+	ret = crash_prepare_elf64_headers(cmem, true, &elfbuf, &elfsz);
+	if (ret) {
+		pr_err("Failed to create new elfcorehdr");
+		goto out;
+	}
+
+	/*
+	 * Obtain address and size of the elfcorehdr segment, and
+	 * check it against the new elfcorehdr buffer.
+	 */
+	mem = image->segment[image->elfcorehdr_index].mem;
+	memsz = image->segment[image->elfcorehdr_index].memsz;
+	if (elfsz > memsz) {
+		pr_err("update elfcorehdr elfsz %lu > memsz %lu",
+			elfsz, memsz);
+		goto out;
+	}
+
+	/* Copy new elfcorehdr over the old elfcorehdr at destination. */
+	old_elfcorehdr = phys_to_virt(mem);
+
+	/*
+	 * Temporarily invalidate the crash image while the
+	 * elfcorehdr is updated.
+	 */
+	xchg(&kexec_crash_image, NULL);
+	memcpy(old_elfcorehdr, elfbuf, elfsz);
+	dcache_clean_inval_poc((unsigned long)old_elfcorehdr,
+			       (unsigned long)(old_elfcorehdr + elfsz));
+	xchg(&kexec_crash_image, image);
+	pr_debug("updated elfcorehdr\n");
+
+out:
+	kvfree(cmem);
+	vfree(elfbuf);
+}
+
+/**
+ * arch_crash_handle_hotplug_event() - Handle hotplug elfcorehdr changes
+ * @image: a pointer to kexec_crash_image
+ * @arg: struct memory_notify handler for memory hotplug case and
+ *       NULL for CPU hotplug case.
+ *
+ * Update the kdump image based on the type of hotplug event:
+ * - CPU add and remove: No action is needed.
+ * - Memory add/remove: Update the elfcorehdr to reflect the current memory layout.
+ *
+ * Prepare the new elfcorehdr and replace the existing elfcorehdr.
+ */
+void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
+{
+	if (image->hp_action == KEXEC_CRASH_HP_ADD_CPU ||
+	    image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)
+		return;
+
+	update_crash_elfcorehdr(image, (struct memory_notify *)arg);
+}
+#endif /* CONFIG_CRASH_HOTPLUG */
diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 3d907f8ee594..c0d0442fad9b 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/libfdt.h>
-#include <linux/memblock.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/slab.h>
@@ -39,34 +38,6 @@ int arch_kimage_file_post_load_cleanup(struct kimage *image)
 	return kexec_image_post_load_cleanup_default(image);
 }
 
-#ifdef CONFIG_CRASH_DUMP
-unsigned int arch_get_system_nr_ranges(void)
-{
-	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* for exclusion of crashkernel region */
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end)
-		nr_ranges++;
-
-	return nr_ranges;
-}
-
-int arch_crash_populate_cmem(struct crash_mem *cmem)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
-		cmem->nr_ranges++;
-	}
-
-	return 0;
-}
-#endif
-
 /*
  * Tries to add the initrd and DTB to the image. If it is not possible to find
  * valid locations, this function will undo changes to the image and return non
@@ -89,8 +60,9 @@ int load_other_segments(struct kimage *image,
 	kbuf.buf_min = kernel_load_addr + kernel_size;
 
 #ifdef CONFIG_CRASH_DUMP
+	unsigned long nr_ranges = 0;
 	if (image->type == KEXEC_TYPE_CRASH) {
-		ret = crash_prepare_headers(true, &kbuf.buffer, &kbuf.bufsz, NULL);
+		ret = crash_prepare_headers(true, &kbuf.buffer, &kbuf.bufsz, &nr_ranges);
 		if (ret) {
 			pr_err("Preparing elf core header failed\n");
 			goto out_err;
@@ -100,10 +72,13 @@ int load_other_segments(struct kimage *image,
 			vfree(image->elf_headers);
 
 		image->elf_headers = kbuf.buffer;
-		image->elf_headers_sz = kbuf.bufsz;
 
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
-		kbuf.memsz = kbuf.bufsz;
+		kbuf.memsz = kbuf.bufsz + crash_extra_elfcorehdr_size(nr_ranges);
+		image->elf_headers_sz = kbuf.memsz;
+#ifdef CONFIG_CRASH_HOTPLUG
+		image->elfcorehdr_index = image->nr_segments;
+#endif
 		kbuf.buf_align = SZ_64K; /* largest supported page size */
 		kbuf.buf_max = ULONG_MAX;
 		kbuf.top_down = true;
@@ -177,6 +152,9 @@ int load_other_segments(struct kimage *image,
 	return 0;
 
 out_err:
+#ifdef CONFIG_CRASH_HOTPLUG
+	image->elfcorehdr_index = -1;
+#endif
 	while (image->nr_segments > orig_segments) {
 		kexec_free_segment_cma(image, image->nr_segments - 1);
 		image->nr_segments--;
-- 
2.34.1


