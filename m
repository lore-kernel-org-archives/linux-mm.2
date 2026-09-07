Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F235C79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E84D6B00A6; Mon,  7 Sep 2026 08:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7727D6B00A7; Mon,  7 Sep 2026 08:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612BE6B00A9; Mon,  7 Sep 2026 08:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6756B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3E83C0130
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:42 +0000 (UTC)
X-FDA: 85186957884.16.D70D31F
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65206140006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ERzwKorN;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kakKxXf+thybgh5+T6XpGw7wzdtVr4alrTQrwFxQYKk=;
	b=ufIGxSHNJyz53DYXL0+YZGn2RP36PYOb5YGUMbQqnmW0u/5kpHImfko7nKt71797XDEFr2
	hu/UAm376I/fFHknRH59mSBD4UJo3Rcdjd/pXhlZ2QpHiMYnHQr3g3zlG6Fnl7jp3LrgJe
	9JlKl4xmlqCtRzK2iKADzd/Zdu7tIwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785620;
	b=3ruMzW5/2+Ihv69ALhtvJFzMvLvZJegUzrFeMQTN/cfiJcoOJVWL5fEfLePduibAa80BjD
	Glo1jrD2yTspOBkjlaxfHh+HkGT5Xx3KHowU22Q9m/2ICTYBp6zjSH3G8+PCjSarAOeSfn
	GzAIOoaBR0t2fHdPHH9NGPKxG8n+7NA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ERzwKorN;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kakKxXf+thybgh5+T6XpGw7wzdtVr4alrTQrwFxQYKk=;
	b=ERzwKorNX46smNvAMTCQwH07tGmDr+QFeag7UHiF601UiTQY0+4igkANnfmrJIwdnUs0LRVC2
	P6bWuQZJV3zUhCpJAs3AhNSnLDMTy+URrLgI+F7px6xff3bjOn55hqEJE+l3/ta7v2SDGxv2wRI
	A39hs9W7d99bLQJTOTp4OiY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtm3dR7zcb0T;
	Mon,  7 Sep 2026 20:42:40 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 96EF940579;
	Mon,  7 Sep 2026 20:53:35 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:33 +0800
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
Subject: [PATCH v4 08/12] crash: Fix TOCTOU race in crash memory range collection
Date: Mon, 7 Sep 2026 20:54:00 +0800
Message-ID: <20260907125404.922123-9-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: kcdsgxrf6m1acgfwjkghzhzqemta4aaz
X-Rspamd-Queue-Id: 65206140006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788785620-530494
X-HE-Meta: U2FsdGVkX186p8hLoLXNaiO0PAK91v9iYSXEkJK7Fv7D8sUKhXLOvkYt7yLbsPPXofZ1EAzdcEPl+Viv9tRZSEHeqFEOZHGFpKjYVSxe8BMVFljSzStjMiLCjAqoyizAGpKo5mjW0rf2Atm+hOWMyNB3PioJF5mxcc/XRKn4cYs5Kp2X5T8ekiN7cFI+qUwu+3g2YS5VoqqfBF65LVMU8DCSWsCTf8RIe3I0ydDGLnfRW2GbwTt9fGhq1UKeN1Q8URRD+VMxXZtFORpcrxg7CeBUsnJg/WcsEQaVJg0sIxcN1AcpfJd1tQ1JVUkMJA8cmUb3f+emCDX4mPxTO8bwCltmwT4S2KLXVreOQYkttMsLULLQcN3trEJqhpDiN8NfmvPX3uFNbLdnmV4/AXWC/pphqcBx0fH2uGxwechwMSQKL7gcvJf54NZHu6qg9tzstGSMatx3lpIWnxa/LUQ5DfVBwMHn0JUZUVLoDfdMO5rj0F2vMZ9Df2QbKZDQcxSeEh5wgPv2vUS/r3AtKmFveLha1mekndRgvMElnwuUJLUYnZlGcvuXz7nYBHACCaxHlKt9w7k6kjTeMkZMOKKLRHjMtxRhMZyRyvcurlDnD5a/I35xgphLAvsHbTIYtHuSsrP2lu5+OFcfGmjigXLqfM6CrLXiyxvyq08pGG1WQdI+QufOUOlzVYLm+GDrdwo/Dte5bKoM35PIiaLvDeOl+oSSGkK6JCNn1CJKWk6kNnRQCw9wMde+9hf68wLdekASHIifPPdHl+AVw4SvDbGgBNYdybj9dqEc+CAEMi1QDGo8xCl8OFH1YbA+EII+rab8gieoJwot/CnZi90nBoTDmpxe4Z2eKgQ0+Jv88/wGIGgeSDSVorG8MJKA71n8LnvR9udL4dJrcfE44z0xWAUZ6u/nELVMGGAED0DTgR43/nQeSRnzwLAIYqDg1WxasCFVWhXSHAbtTHW5jcMQq+i
 1xUQAG6e
 ERVYsp7kSuWB87CtqxosQhLGbjye8e34lG9ObJcJ2muroHAgr6MUT6M3FzNu23tBhMUKIVh+KUoOxft0RBkayaQTLYl4S2ietQ1AwvD4EZRf7wum49tzMBpQUTQ3T998qzK7bDWoBxcigNtIX9hlgzjKrDaGd136zGpK3aK2v30Ym/HtvMj0tVNqh+zl/08Msn5Y05fQ7P0/FicBRspJupczPKGpY14ioLzUfWyV1SyhTXNG78McFqoo0f4GSlN0x528CJroFcI/1kNB6IcWUkX6tld9cADJJUvj7+eq0mumQQGod1Uei/50fxtcURCiT/2VFwpmL8puq7R7FyiywjNWopjT6YMrHnAQmglC35IuXJamZMJ2PZTdIOir5IeE899ut8Twaim+3aW6pzG6Mu4lhqvgJm3n90tbrVgD8sRZSiA1boEN3LPGVo5sDi4wpBuTJImHz2kwmxbUmG2bfPCfeWA4YAnPDM+nRYeT6t4+YxQ+LVlDFSo9kOKxnvnVJUeb/VGh8n1DgKQH4UZThpT1X06wQYzFnVoLxALO2k0ewQJVrshOLkAkHLvFXsSVpc4essvrXB+opVMYLzk37ovXB7gibgRbOpVvYURJwuroINkFlvrS/lV9Y3V04uPZNVoCu/xUp2sRh/URhtz+Bjhxqui8OYy4gFEGq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The crash kernel ELF core header construction counts system memory
ranges via `arch_get_system_nr_ranges()`, allocates the crash_mem
buffer, and then populates it via `arch_crash_populate_cmem()`.
This sequence has a time-of-check-to-time-of-use (TOCTOU) race with
memory hotplug: a concurrent hotplug event between the count
and populate steps can increase the number of ranges beyond the allocated
capacity, causing an out-of-bounds write. If the event triggers
memblock_double_array(), the memblock array can be freed and reallocated
during iteration, leading to a use-after-free.

Protect the entire range collection with device_hotplug_lock. Since
the hotplug notification path already holds that lock, add a lockless
helper, crash_get_memory_ranges_nolock(), for use there. The regular
crash_get_memory_ranges() acquires the lock and calls the helper.

Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Fixes: 8d5f894a3108 ("x86: kexec_file: lift CRASH_MAX_RANGES limit on crash_mem buffer")
Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/x86/kernel/crash.c    |  9 ++++++++-
 include/linux/crash_core.h |  2 +-
 kernel/crash_core.c        | 28 +++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e681ec9cf1dc..d6430a593778 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -448,6 +448,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
 void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 {
 	void *elfbuf = NULL, *old_elfcorehdr;
+	struct crash_mem *cmem = NULL;
 	unsigned long mem, memsz;
 	unsigned long elfsz = 0;
 
@@ -461,11 +462,16 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 		(image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)))
 		return;
 
+	if (crash_get_memory_ranges_nolock(&cmem)) {
+		pr_err("Failed to get crash mem range\n");
+		goto out;
+	}
+
 	/*
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
+	if (crash_prepare_elf64_headers(cmem, IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
@@ -502,6 +508,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	pr_debug("updated elfcorehdr\n");
 
 out:
+	kvfree(cmem);
 	vfree(elfbuf);
 }
 #endif
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index b1c816e98143..a68c0a6346f4 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -62,7 +62,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
-int crash_get_memory_ranges(struct crash_mem **mem_ranges);
+int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges);
 
 struct kimage;
 struct kexec_segment;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 406b68d2adfd..39feb39b53be 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/buildid.h>
+#include <linux/device.h>
 #include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
@@ -317,7 +318,21 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_get_memory_ranges(struct crash_mem **mem_ranges)
+/**
+ * crash_get_memory_ranges_nolock - Collect crash kernel memory ranges
+ * @mem_ranges: Output parameter for the allocated crash_mem structure
+ *
+ * Gathers the system memory ranges to be included in the crash kernel's
+ * ELF core header, excluding the crashkernel reserved region and other
+ * architecture-specific areas.
+ *
+ * Context: Caller must hold device_hotplug_lock.
+ *
+ * Return: 0 on success, in which case *@mem_ranges points to a newly
+ * allocated struct crash_mem that the caller must free with kvfree().
+ * Returns a negative error code on failure.
+ */
+int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -351,6 +366,17 @@ int crash_get_memory_ranges(struct crash_mem **mem_ranges)
 	return ret;
 }
 
+static int crash_get_memory_ranges(struct crash_mem **mem_ranges)
+{
+	int ret;
+
+	lock_device_hotplug();
+	ret = crash_get_memory_ranges_nolock(mem_ranges);
+	unlock_device_hotplug();
+
+	return ret;
+}
+
 int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 			  unsigned long *nr_mem_ranges)
 {
-- 
2.34.1


