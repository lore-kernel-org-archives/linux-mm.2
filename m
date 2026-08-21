Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A16D0C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F190B6B00A5; Fri, 21 Aug 2026 06:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC9376B00A6; Fri, 21 Aug 2026 06:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A016B00A7; Fri, 21 Aug 2026 06:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A08846B00A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 289BD16040B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:54 +0000 (UTC)
X-FDA: 85124847948.30.285EC98
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51EAF100012
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=mKXagGDK;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Da1CWZALucIaRBUeETb+igOf65zQLydAHdg2K0GnubI=;
	b=VmgyRjPSvUCclbXaCOdrvwhxvfaqZegum5swcmlFjIh245UQXG5OsloxrMX9/Vjnx7k8u0
	LV/AChLj0dRND5pP8TktcG1qXlW/A1HepatKM6prqMwD3U6Zbxz/ovsV4xtTnXIeYJlZUO
	zVUlmknGS4hpcX5EPGdR49GtkEU+Wa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306812;
	b=R5kwsVbhEH2qZyLffRGpNXyhqpLXBDVC4IsT44ZMKLf+aMZwVlzXk2KJ6T32dsd9BhPphU
	Wnf4Yt1RT3hjP0i176gP+Fg0LzZrl3h4/OI9mMCWDyadwr49GpkpAucMtCZkGKcypyjhQS
	H6gZBCDuhWRnJq2KwgCSVVkHZG5XfFU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=mKXagGDK;
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Da1CWZALucIaRBUeETb+igOf65zQLydAHdg2K0GnubI=; b=mKXagGDKJLVneYlwEdigYndfQw
	1mEFjLB9WKlOEcBzknkiea42hyXZun3ERd29AthAl/3Aw4rbOHdv28xtug/V4e7y9pVZ62dcnCMyZ
	eTTBTIo/nX8l++3Fs1yagZAdSjAesjdbpns5gWeYtFxj8blWazG5AKmvPFpK2PUwIEzLycWHf+Ewj
	/N1+8W8GicZYDbFapUYUiiBWA3c2KQOodGCesHjgrN7cIX+IYOk0PLbkKPtrQsiZ/fyH4uZf2OEm6
	d9BuIchhIxKcUx5t2ytHBA0uj/94nBcGy9d4iLWyyhVbmapQte1KQxEBFfrvQ2n9dTsLXQwjWLFjW
	oCTPSoTA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM97-00BGBw-2h;
	Fri, 21 Aug 2026 10:06:46 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:05 -0700
Subject: [PATCH v2 5/6] efi: record hardware-poisoned frames into the
 poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-5-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6912; i=leitao@debian.org;
 h=from:subject:message-id; bh=lWWIEjhuVgXrSedCC6Ci+SxjCAerQM0bIwFhF7iWBwk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMagImGhYCNupSzFcmMTFpU0hwmHaEe+j5ab
 QCBtZQBztyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bdlKD/0R0D67QRzyfCB/qpVSpAVO6PMBhhDYOyWsLrycnJcm98PDAO68wuR9JXf/04LbHxJaKUx
 GXWLPITI60/ULF6LdZCzpYaUf4rpnK6vraM9t4M0bpqUkF14+lc6HxjcKo59OgtacBxcVlJhFXx
 g7OO5swDEgwkcgVHq0Ig810rGo2ZscSgtX8Di52kdRnbFd5gLMJBev8bL6uPQuel5VXwUNaeuVN
 Ca9jj3mhO9czJAvTmb0ITOQS/V3/cKoewetvWvoi223H8bx7nOy1QOsvRTecq5ifuAzhmmGuDrv
 lNucuKLFJAy61TNdGHxmGbqbusYwNMgVvOihC9Br0VnUWQeMDi6UwESzDcXnFT+qiF4sFD5ooHc
 aexaH2V+h4tTbJ2s2+w+fwoKhE1yExSRdAwLrUqG95xC9LecO8mf5AQlsPV3R1dyh0r9G/rNlHm
 5LJtAIfiaa2rDS37nOyK5UOuHz3AUX75oe2ylckY5P46YEtj79/nmN7PYQWucNr7Z6DCZZQTbWV
 tVkU7ofwJ4heMBCDgEYr+zg8L0ZoOtfe8xs8x84xIZGI8deQ+m10aAVL02DqP0fey9RRrWspZOr
 t0YygL2bI7CT21rF+ZamVC3w/vG4kLHuMzFNqEWdMCL2Hqci0SO2d2NchiqC8v2FirssI0O6ITu
 6xsFQY2jdQSCUkA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: 7i3ikwyc7er5n66fdji3ooqwguajgssg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51EAF100012
X-HE-Tag: 1787306812-646135
X-HE-Meta: U2FsdGVkX1+VL9L2yQbp00ltCtPHHv1PQAadxC4kdCyGXPZwly0+RMwYEUqIVnBl7/3NVsU/9U5gOmQjqXgYyO67nRCKxrDi5RwcxpTNNwSJGQJMwAisdru4nRMwzsfl4AWF/cGNWKMTiRI2j8miPRLRuqAvOUzUCahYduyH695u/TRzoF/hEYVOt/wLgflUh+fNjn6sEafv5J+yl76ZRPGb8CQvUje8Cqc8zc047jhWlxClyCuq5dVNWdA7lFYulC62MeyXv553WRZtGi991Jf3fEiMXDO3HMiXrtvx+SYPsK77TyoI8D33OYNc5S/mqLUAxgYZew8ruzJT9eNJUvoFy04803MV0nIhNIdL32eVgiOI5rd6pIAvQcjyHKWKPlImYQRN5ruKFlgnjWYaYlnMwBOpkHSLkIPQEwzeD0+TUnMeJrPkhtzZ/ZMfvSCGgTcm8LVTRZSckWp3zAJTA5wSh5OYOKts6zdh3vI/gFRTrWVu4bljIWVhoG0ou+doTBuuyOCr06XM9/+DxmDg+mdhZuWT380X0jYk6cnFWazXfOK9bRbgDt/8dm5M+HkKbqJCIjU9O1fXVJmbqmWk580VX3WDZOWv+OUjZnzNcGlAwaBX93eFCJYZjra84soVgq6V/MI5bpNCM99H6LvAfjrr2uYqEgHRnCRmqlVTgvS7RseZ8z4qwW/1R/wRfQHrv5Ym+/p5tx+mcVibOrlCjsbhp2EGG+lf9gdEQ6TWxm9qoJW4fu8o0GqJerGHAIzDkXZjLqw7ntPha6Fu+rVm/aECVRy+v3e4Gt7jtE4RaVmgCIEKIyJz20OQMhqU+UVceMJTZKNtwd8V6yioLzjtjassdxf7grl1ie1lwLRHPAswrKUU0gYnB5PZP8mh93nFpP1wBl/IiWev3HmLHYzdLU3oX/aVtBrF+/Aa55tcOkpXYCCZ9klH2BLMVDrrs4PT0Q8TqrOthRPtgfdrW8P
 og7uqC9T
 A+xIKKT0oJK2999PewszQb5i8sGPFhCCKuX97O0+CSQBkYvBOWoCt/9nBu1GLIrHqpTkZXGVHiw2XBqUk9NuIjuRg3AfWbarjQMl9XE0ZI0x7QPcGteEwEUc5zZkU76KYodZ0XoPxhRqkvO5ImUSzeyCnpkF8zrxzQKXzwFCfxLnkkrLlC4EzNrmjsHdhFY9BBp51BwdHHRq4kSqc5Iv7sDgAsxQt8F0w19jEhJj1OEjLLsGHVOUhDm8Pvk5l55INQ3qMXQWQD8ouNpodmlHR5mThqLe/lyXT8mHZer2UelKvtjx/77ZVkvMbp5xKODcbjcT6JrEE006MzSTsb766kS/2kL3HWniRmLXf6ywKyQO7gzf/dgi16KWkjO8oSg5gb9Th
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

action_result() is where memory_failure() reports the outcome of a hard
offline, so hook it to set the frame's bit in the
LINUX_EFI_POISONED_MEMORY bitmap.

Soft-offlined pages reach num_poisoned_pages_inc() through
page_handle_poison() and are deliberately left out: they are still
functional and were offlined predictively, so recording them would turn
a prediction into a permanent loss for every kernel further down the
kexec chain.

A bit is only ever set, never cleared, given that multiple pages can set
the same bit, and it is not trivial to decide if the bit should be unset
when a page is unrecorded.

Unpoisoning a frame therefore does not hand its unit back to the next
kernel. That is a known limitation.

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/poison.c | 130 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   6 ++
 mm/memory-failure.c           |   3 +
 4 files changed, 140 insertions(+)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 8efbcf699e4ff..05d0a490923e5 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -43,4 +43,5 @@ obj-$(CONFIG_EFI_EARLYCON)		+= earlycon.o
 obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
 obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
 obj-$(CONFIG_UNACCEPTED_MEMORY)		+= unaccepted_memory.o
+obj-$(CONFIG_EFI_POISONED_MEMORY)	+= poison.o
 obj-$(CONFIG_TEE_STMM_EFI)		+= stmm/tee_stmm_efi.o
diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
new file mode 100644
index 0000000000000..2f47293a4e45f
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Runtime handling for the LINUX_EFI_POISONED_MEMORY configuration table: a
+ * bitmap with one bit per EFI_POISON_UNIT_SIZE of physical memory that records
+ * hardware-poisoned frames so the next kexec kernel can keep them out of its
+ * allocator. The stub installs the (empty) bitmap; this kernel sets bits at
+ * runtime.
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
+ */
+
+#define pr_fmt(fmt) "efi: " fmt
+
+#include <linux/bitmap.h>
+#include <linux/efi.h>
+#include <linux/io.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
+
+static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
+
+/* A non-empty bitmap on a power-of-2 grid that phys_base actually sits on. */
+static bool __init
+efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	if (!pm->size)
+		return false;
+	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
+		return false;
+
+	return IS_ALIGNED(pm->phys_base, pm->unit_size);
+}
+
+/* The range the bitmap claims to describe has to fit in a u64. */
+static bool __init
+efi_poison_range_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	u64 nbits, span;
+
+	if (check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
+		return false;
+	if (check_mul_overflow(nbits, (u64)pm->unit_size, &span))
+		return false;
+
+	return !check_add_overflow(pm->phys_base, span, &span);
+}
+
+/*
+ * The table may have been installed by an earlier kernel in the kexec chain,
+ * so check its geometry before doing any arithmetic with it.
+ */
+static bool __init
+efi_poison_table_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	if (pm->version != 1) {
+		pr_warn("Ignoring poisoned-memory table with version %u\n",
+			pm->version);
+		return false;
+	}
+
+	if (!efi_poison_geometry_valid(pm) || !efi_poison_range_valid(pm)) {
+		pr_warn("Ignoring malformed poisoned-memory table\n");
+		return false;
+	}
+
+	return true;
+}
+
+static int __init efi_poison_init(void)
+{
+	struct linux_efi_poisoned_memory *pm;
+	u64 size;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	/* Map the header to learn the bitmap size, then map the whole table. */
+	pm = memremap(efi.poisoned_memory, sizeof(*pm), MEMREMAP_WB);
+	if (WARN_ON_ONCE(!pm))
+		return 0;
+	if (!efi_poison_table_valid(pm)) {
+		memunmap(pm);
+		return 0;
+	}
+	size = pm->size;
+	memunmap(pm);
+
+	efi_poison = memremap(efi.poisoned_memory, sizeof(*pm) + size,
+			      MEMREMAP_WB);
+	WARN_ON_ONCE(!efi_poison);
+	return 0;
+}
+early_initcall(efi_poison_init);
+
+/* Bitmap unit covering @pfn, or -1 if the pfn falls outside the table. */
+static long efi_poison_unit(unsigned long pfn)
+{
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (addr < efi_poison->phys_base)
+		return -1;
+	unit = (addr - efi_poison->phys_base) / efi_poison->unit_size;
+	if (unit >= (u64)efi_poison->size * BITS_PER_BYTE)
+		return -1;
+	return unit;
+}
+
+/*
+ * Record a hardware-poisoned frame so the next kernel keeps its unit out of the
+ * allocator. memory_failure() has already removed the frame from this kernel.
+ *
+ * A bit is never cleared: one bit stands for a whole EFI_POISON_UNIT_SIZE, so
+ * an unpoison cannot tell whether the unit as a whole is good again.
+ */
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	long unit;
+
+	if (!efi_poison)
+		return;
+
+	unit = efi_poison_unit(pfn);
+	if (unit < 0)
+		return;
+
+	set_bit(unit, efi_poison->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ce0980a5bb81b..f03b1bb576133 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1284,6 +1284,12 @@ struct linux_efi_poisoned_memory {
 
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void efi_hwpoison_record_pfn(unsigned long pfn);
+#else
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
+#endif
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e2..357a72ffda625 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -43,6 +43,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
+#include <linux/efi.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -1286,6 +1287,8 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
+		/* Only hard offlines are carried over to the next kernel. */
+		efi_hwpoison_record_pfn(pfn);
 	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",

-- 
2.53.0-Meta


