Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89205C61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083726B00EF; Wed, 26 Aug 2026 05:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28566B00F0; Wed, 26 Aug 2026 05:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16BB6B00F1; Wed, 26 Aug 2026 05:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6B0A6B00EF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 052111402E3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:38 +0000 (UTC)
X-FDA: 85142887998.28.D431A9E
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf04.hostedemail.com (Postfix) with ESMTP id AF22940007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3MdARlzQ;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736337;
	b=NRtRYkN7d+3TkzYb2W/53Hv5k5yXN4yLLucrbZesNjoYATq9m9bZYAK+TfQaOv2e0wcXA1
	7qeveawDNhJcT+JApNpI4nqJs2W2cvmOV+wgAL2SAo00OqZElvr8p3KBq9EhatEWeDFlmH
	QYwJQNfdw+DHrpyu5XYbSpnJpMJyDHg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3MdARlzQ;
	spf=pass (imf04.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cgw5ZyBI8tRtEDh7EDDRec6LYICayfmN/Ij1j/3X5fQ=;
	b=j3hZNB/NAPzsi8hivzNQjhGdXVzCwpHGoxHCehL9lM1E8IUJvm6g0XwRtLPlAfdVi0nrV0
	f9MXOlxivK8Os1cDqiDH9UAhKswPrO+bzsEAqkVkcd/OUA2BTXr/SxXyds34Z0CYdEB44r
	gqYAtGD1PQkNLI2ToznTidB0+jlYQy8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Cgw5ZyBI8tRtEDh7EDDRec6LYICayfmN/Ij1j/3X5fQ=;
	b=3MdARlzQun+xzAHOJhU4sO7o1K3lj0gTWdnFc55tBXyFjPHnWZTqiO3DmfdrhM0KvbpYg+PLQ
	Gm2jGZjDNIHD7qJ+XMi6WDQTtzAxhZwAd0rjnzFXn/r+AS2pkKxpOgdhXBJBi3/8JVnX+40fxH7
	PhonXjGR1KQyVYU0TBpsG08=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrN45zdzmVb6;
	Wed, 26 Aug 2026 17:14:44 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C57740586;
	Wed, 26 Aug 2026 17:25:30 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:27 +0800
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
Subject: [PATCH v3 09/17] crash: Fix TOCTOU race in crash memory range collection
Date: Wed, 26 Aug 2026 17:25:33 +0800
Message-ID: <20260826092541.3905933-10-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Stat-Signature: qiuszx8ugq7teac7c97d5rqkdy8yps7x
X-Rspamd-Queue-Id: AF22940007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787736336-935119
X-HE-Meta: U2FsdGVkX1/x8VYdteXYAH3KNB95W5ng1Yp4drVK9Wwlw8IhbGpjvROfo7aG/A5N91N+o9sy0CzU/IqlD04PMTitN+2RunljoJQRXyRYaNYGIt4+nYIvR4yOug4cHzQWOJAztpdokLE10osYQz9xtsXQKJR46p3NTlG4zX6QLo2H6gKPuiHaVyuuUpr7nE0zcF+bzYFAKIgMd5sbqXzseSLA2rBeKTVKKiKVtfVBYoR16xl27RaVXUaZvHdkqfVCnG68s8EXxmjMR8H3qfreHpIG+3/dZMpUvhoz0z+25E+v5o57HQwutaB4gcY/GqKZ5+aWUBHfRQ3ZZ3/bkFLpFHNhKmUkXO/G7iIQm8M8T/YmXQvMD8CGLIlDYlo/lKDmk6Y8KN03GyJaJrcljLrKYw6Ip6n0OfDQHiXCAxUYAolzIGmYQkHhEbNMS7rWpeL97L6wRuqUDA5+VLpW6aVUiX1+AIrCUrI1WS//gOLGcNgF1P9xTiPs6VY/yTOxSGfr4h8uCyySvMRelNAG/wmCfkVIfloMzKDfO+mE/pLV/EspDrGzrrWri76V6SSWEHUWktSoTaCk2L2g5dC0gd1hQvvCXNPeKHp6VyJ8S+0SWRKaP/lP0vWQ94J2Ky33ocEfNCoyAsrJwAweF+xlNga1idR8xrfr8V5KhDOgJ3LG25JNS0T2VHkF4nNQAoh6zk3KJT2TaPVXqQ/qVAtCKI18aT+1+y60S4mTYdr22otiK+026akcprHoaDtZvtrTCRHS7hzdaLwGZZsDMO5YNa/G1eMn1MnPsZmSKVKbADiKFSHmVunK66sXzLV+ZEKtpbQKlxy15xYUpyeGCDExPUxwTqhky3lmE/kEhmM8U/zCSSuKFcZxRZPrTuaeovWE9k0bbmmfztF7RnrpILua0WS3+XaO+aZXfMRd8TI7wZ/hljP7lpuG4xBlZ8B73FuqfH47jynnp0BB7KytbjcOipB
 k9Ws51kX
 GRcQQ6Pt1ie7l1uYuU8FH+MKo9FtuJ+TCtS2Ir7weHqBcid4/ay0yCIa1XWECDxL0pzVCnpImPI5kw3pzP4gqK0hFgiXbjIZbmMvpBBVXLeAgOOJAYtx4QAN51d2LWF+YVWdY39K+qCQY7d7Kj7yVcxLAsYc1VtfQtwLFWwby3Em0QkBHmAUdX42o5X1+pKZbd6ZcZ8+vSpTG0GR2ISRitJez99IE+JlOVRTG1ZG93aoHCLTG+kuOZuzLNXjb280iAbGC2kuKzAzdXIkxlLGauzhpc4hIYD2v0/vyTiaZZ40kYg1VWA6/j5Oz1nofpqbcA00OOEpoMlciORmg1wLCFK8NhyyxjhiU/JR1oZfZu7yWApsh7s0/oUReC+a6xt3PFK6fThqyEdJUPeHsgTYZUsz4FeDwWZGiddlYz4y+/y3zxVnTAHiy+bwUDPpF5IwovYccsgL0H1Io2qd+rEsvtBH/RyNxqAzGdVeVjzt0+w9fXlzxOj29gp2ayajR/AQCmkhAOU2Da6NGhnn1gwYAbOWYNU6FBHu3ABUhr9/FT2v8WUxcWCKS1YQPhDK/T9nfm6R/1tf00KDcv8YsBKdO9OFZrHU2wNp5F6Nj8lLQp8w6/8W2E2a0OSldIC3zs7R2RS7VlLp93Sftc+97kbWtd0KdCjMP88vYVHEa
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
index e6f23933a6df..8f8c0e592849 100644
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
index 619af312bd9a..6789ff0af39e 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -62,7 +62,7 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
-extern int crash_get_memory_ranges(struct crash_mem **mem_ranges);
+extern int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges);
 
 struct kimage;
 struct kexec_segment;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 991d1599cf9a..05a2a8be083d 100644
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


