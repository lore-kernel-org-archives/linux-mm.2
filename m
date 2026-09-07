Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B09C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0966B00AD; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90156B00AF; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09B56B00B0; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 743A76B00AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15C17140134
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:47 +0000 (UTC)
X-FDA: 85186958094.02.4972CE1
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf01.hostedemail.com (Postfix) with ESMTP id AFAC94000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PFWOEzW3;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785625;
	b=lvE0+M/9C0Z9brczl3pFhikO7NY61UrIA8Wh78iU9YOY0zbmUp5myMHd7lbl55S+xnLG1l
	0ZGaKlCyDN1dYcCPUZte0Q6LGxhAmyb7hpICC/JP20tvaWPMIDL/kvF/iAAzTnz2xPA+px
	/FVJdOyzi7HPhhoVRkkQo2qB5qvM+M8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMsDzrH1XpehMqQs/w0JG1pv9sEwHPRhsiu7VhrmhiE=;
	b=kzgI/db7TF1mR4UsOzhJC/9+OPy5enJ6O5F7HDmPE43UmvvkwnjY+mFp4uYnductvX0c0H
	MWVQeMQDK0tnS4TaKbd/gQ7qwecCPiWMox6RtYa7Tyd8CTl6Xkk3RZ2c2j5Z6n6xYDl295
	WIiCmibSTv+ByzjkaTZct90qdTA9J9k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PFWOEzW3;
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YMsDzrH1XpehMqQs/w0JG1pv9sEwHPRhsiu7VhrmhiE=;
	b=PFWOEzW34CdPN9JSv+yhTNsaJl9NX1WASFU7PMTHtkuU5Cg6snn8UuLSCgjbA6fRwCMfSGUZd
	wUlvUu05OgFweBO0eZKgjSB9KUhIeFgJxjhu6Uyisx/JZFHDDjaUug1/Zno+bL4jM+TkzSBOGb3
	C8e/AqwAQtW2yyEUkwMfAHc=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtx2HRHz1cyPY;
	Mon,  7 Sep 2026 20:42:49 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id CBB2E4057A;
	Mon,  7 Sep 2026 20:53:41 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:40 +0800
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
Subject: [PATCH v4 12/12] arm64: crash: Add crash hotplug support
Date: Mon, 7 Sep 2026 20:54:04 +0800
Message-ID: <20260907125404.922123-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AFAC94000B
X-Stat-Signature: io473ny3hpqtoc8ziyxtgiqdpa9a5dft
X-HE-Tag: 1788785624-358903
X-HE-Meta: U2FsdGVkX19oc6afhZuEDprsbZ3XM0XLc/bKxydmhCFxvb6JsbUh8Gc1Zswa54agvN/EibCGL0inkrnaWm9T004cUDN/+yRO51KVwvjIds0ZN3xt5NRuUTaBkQlo1cn6JKsELdxtKUIPD8mkwHNZP/ubWLM8qBsZhJBrM0/GxIkZIg5iJZoxkwGewmUZQ3bQoku5beJOrw66+9cq2qqkwjqPoUKU22pZhKYl8fyRWUMV65agGBJfd8Zpw5B2mqo7wxRrafjQ5Bw+azGbpBdTNAtVd3VgyZgKkxd7KWCWgONc5dsoggyLGJs1Yhlb8EuRkuqClBrQmhsaP4D4hw29j0AJdih5vJEsLOvVcfJH3Zh7m5MBXYJ/VuZokiYWVk2gujykiQGkElMoofQlRlagCL6X7qfu/8vRr/02KewybG0wVLWnuYOp/1tTwPyXu6O7c9PEYHvG7fe/wY5240w6MeDlWzE7hwCCj9nrcoB4Od6rxnQYCzTcJbeHpa/tPO7i5voPhhUI6DPT4e8bI1S9IfvbZNMwPGCqA7wscazSkusDuOxdB+0+UVGzyjlW3y2+sn6nNqeJZPqeQcaRjudqQsfb9uc3nahRd/iRFFZO0bjuTxfpxviFDgsSxff3+kiJWXTBB1AvNS7iK3LJhSzju6Oc9hhptRzWdtmfEWFsp01CFEFz8AeEM/64YU+rskL/1ctFm4ycGG/5bNfVV52skVuSI46pblDdAI5HBZhvAvHJa1804Uib/MOZHVtSVEYoL5N9bvUWguDE0mm6A5w/7foYMcRYprhOTX0l7Y/NRp2ZJGIqD2x8oLw4xDFTQtcqlhkhfyaTCRHGFf0wo7jLUdBVgraPwLvA7iusIgwkNt7yqXIXiYUUpdD+TZB9PoF2hNMfRCuQMSL8z8SIo8SQdyErTspWIb70MzYtWuYoey8IEutglFPFJ/aQjh1YdvsmtACADIWnFHptA2ktQFf
 QLZS9xxF
 0pH8gmhWTsqvmkSrrvsdmtS3FN5/b29JlWctqPE1A/nQ5fH78QytiTMlvFDP2qVALrnb+Hztjxr+JBKe6df96oPuvqpavRXripfDgaXs8/0LGjNADL/dYuS6C4CevBCph3pAm7IaLUTLJKl6mNwbk+8CcWMJjwN+/vhWTO26aKM1DS5y/d/8kQ8QQoTGYEPTV/ymDLKcg8aQPfrMbNJcIjMN0Znkl7mjMY2gHsDj/uhPXRjwLkzz5j4HoNv52zsHSPMx5OIxUk7THUWj+GAc10Se+ZcE3U/dpVZ6erkjY03EHvQL7NkaX+v379aEMuPp6Hq6xSr1B3hIe00xmHKq141ywpfpvmoS+taBshnkCEt2tQtCS9pzkaoTjOF1102H6/QopVtLFgd8QvAyKnmWtkVAA7ECEKYQLzRHnHr3WTiue+YOd83JVhDlqgnohYekl0YhQ+6Am0/da7AlXcSZqnU7qJC5QV8NZuEE/lNQ2HOgCsMWomO+I1zyMTAkLms3xJE+t
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
 arch/arm64/kernel/crash.c              | 167 +++++++++++++++++++++++++
 arch/arm64/kernel/machine_kexec_file.c |  42 ++-----
 5 files changed, 192 insertions(+), 33 deletions(-)
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
index 000000000000..f3333c10c1e6
--- /dev/null
+++ b/arch/arm64/kernel/crash.c
@@ -0,0 +1,167 @@
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


