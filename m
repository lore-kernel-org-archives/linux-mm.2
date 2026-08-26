Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CA4C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750766B009B; Wed, 26 Aug 2026 08:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727776B009D; Wed, 26 Aug 2026 08:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D0B6B009E; Wed, 26 Aug 2026 08:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C986B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:04:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 752A81C1973
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:55 +0000 (UTC)
X-FDA: 85143289350.02.041B6CE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8A82C0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:04:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fAkhlHRO;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745893;
	b=netexRM9X5vPV+1NmMjOZRU8ceQOi2JtBY9ldvcY53etdAo/5VsAOA1oOG6aOR79mENJ/I
	r+wm5BqFMI8RICrg+k1VMXXbwvPQW3N+GKZDCe9KG50kBaCPnBRJhxYSUZgI/CIxQ3G7TP
	O4KdjyEw8rQDGzIvpGZe/R6rV2qwPZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNmGsxm7/3k+LNhJKR8mNefNQdIE2fnt5a+0XM15yqM=;
	b=sjYuWz9fYSYO0EG9ixjpNBV54QCMvUhFWW1yop59bv5e90GSuHf5AqpUmXECm+lG1o1O06
	D1TlLSU9GGiSYPjkNyueuKB5ailG7o/GlXaCsNGog8DBLayXv3m+1OJKJTeZbxyB3jGu7e
	PlM3eBnkFGcwKcXD70f7Ib2PZxxgLyM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fAkhlHRO;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=gNmGsxm7/3k+LNhJKR8mNefNQdIE2fnt5a+0XM15yqM=; b=fAkhlHRO91Pu1CJ21hYPfrNbTS
	dX16DffjA5WDOzEjg5E+3Kp8rpQt76YYGHNZsVVqx96im6zNoAucLD8fDa7TvlWYYvXjCsqTBkGqu
	KIjEXpGFtP3Rt+xDZV9Fd9jJXI8m6v5Yljquu+P5fgtW9r6/x0TiKFytQbQRntWaDUP4Dk12xb7qd
	xl7t2ETg2rARMtzSUt5KHlN8nKuCip71AF1AFV28fNQN/JK1L836Z7aPzogEpS0y8mMpzlIpX14Ag
	iZzMIZa+UisUJ1xtOAC2g9VuTQEdkU+jABoNCCRIKn5xlCOANiN/k/kyYydl1hL7QXzoXzqWOBR7i
	QneAkv8Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCN7-00FCXJ-26;
	Wed, 26 Aug 2026 12:04:50 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:54 -0700
Subject: [PATCH v3 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6496; i=leitao@debian.org;
 h=from:subject:message-id; bh=S2cKpA7kUQ+R7GBTrg8fm7myqPM0I7wx+hvjWQ9x6z4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZK9sTBgNQCxBfhvQIZobnXmKdgrZidzrOiy
 C1uL+pXY42JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSgAKCRA1o5Of/Hh3
 bTreEACYtvZAq+YqtwgWUmjn0XVJ0TqEgbYc10cKuFOW7pLckNCImqjBauSLq7RMmrkgP0wJGL9
 GSKMAAwwjDZnNYxMAEqUCsAe4y1XrUK0LzXWS6R54MOd3WQSYrVrda3NOcuBDQNfawa6C27fuMZ
 U2avXXwj8ynCp/kRC+1yziS1wbbUMdj/56D2NkbgWUO4EzcOtlwsaxQnKQKZN6QeEcwOsCaV1Ze
 +RgiW+3PcwQugvLNj8Vqz7PvK47tRVJmBrK5/fNR62cK9RDYBXLjJQ7t9HbeHQreDbcy8MdNmy7
 XdqKVMU1A+QB5rlgI/Ir/NunyfUqdkD+zR7t8WHqpzLnkWr3GEmpS6iTQXlPAY3WwiNTiWLqNn2
 mTZLpuSjbYhoBuSXN4W9J/ktPV2i6t0KVo/8ystypLHt/LDbdCDwYAJmXnv2ohjvWA0+DnefZ5c
 OCCt5slyt0NG+tSP+l73uTSRnrs33NHRyVDn5RPVYIN9gcEz3V4SHrsCPMNvctstjspp/wLQq+g
 +WKTLS/0u0MosGwRV+e6SA3pPqZU4CjFJjohFuMZ7fcew7f6a2XglFT0E2JXrAy91cfk2vjgFVT
 Z1IuYXANBBTkF+vdL60csjfJWITDaCHIVTLBnCYL2gwE1jGDaibXCXKcVOLxoXtGonk4box8nJ6
 pnHPgLTxCFRVd+g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8A82C0006
X-Stat-Signature: cz37mfktrr57rbg38q6umpo7fxhtq1kj
X-HE-Tag: 1787745893-41454
X-HE-Meta: U2FsdGVkX18mM8og+sBGo3xai4yTstuIrRaprtt1+UUs11Ccw1ROtW2vWTARjcuitcbNEV3HlWsFkagjMWBHX04D2FSrG4MH5Cuoy7lZUBmlfIGJEGij7gSGdzSqefOY8i/C2VLmJdcd2Aexr5bfgCsSmO1ivCSgIG+v5UM8LvIqdU7++Y7I7M+ShPRuGGLiRohuydo9M7NXkd4HfUUSwQ4c07B6PAYSZ6TKEDkqPKPJvrA/pUYWEGLqJ/H+8tq0rEmfjobJ/uWHl1AnS5qmrA4bamujhTIEQLgpVZznU9BHtz+Y4uZvP9Jn/AeZapnpUHDI7IrJ8uhvisH477VeL0P1dPV9hsn9j0hMTo1/ckUdI8guHmPeGUi6+/jdfSu3OXEBkQkPpn3awRflkCDy1LUnC2XiNkk0agGSQ99wZ50TxDUc6JkMupfy/5gr8G60eNiQEr9nNgAxNxf/4ULFmQ4+qPGeynLN+neLlK497XwynE3TvonGjewhipB+mBUhZbtOQuea4strLfKZnXVj3IhtVM/eyrjcroLa9ppCCRQUVb6Og4YFnHf+aLuj+WBYaAXlUemljuxAKJH1UfElaFQINm13EKsOU6faPmDYuEIaC97JeNGVkzfmKsK7FU4hXej91b+u6h36j9ewe8rHWoQAkE4PatgxofLBLet9wscZH1SrTrcFVY793tiDtqZ2lTQmGeeglazy+ZwSTYmA8Y+seaSrCXdCI/XCGugZE7t/dsUryMU/BSn8DSc+tIqez3EA4qhcrI90h4IQ+96Arsyw/F4Ybx0isvmsskpNkNchdTtkWobTMCB5LHhr/ZhSpaYwKRyyG6+Z3epYsR7yh8Fe2r0u1JTYyRb3Jv1mvTxuySfmYi4cTFJK4FUMCsKzgX8zxX/Q+6ClNKaz73PQ8mKc1jCINTryC1akpy83x0Ep7Cu5JWiGswPD1S+X+dj8W2FFn/40n1+aM0JF4t6
 AOT1D7d6
 XZFAYJFOj2RGrb9JmownI4MEroml2jzWbhdtZ6V3hWJsqY06rPGEObOjHXG4j1RMNvFxDttTgA4BsV6HAxfXekM8m0AVqWElryM3/r0ZV0kHLti1TF93UiTDHkoQVRZmqaR1TmfG7rqvDngdj8BWN6NaX1T4k5r0ojPjFHA4OcycNEBrU6kG3JdAWM1sdvlThQ3Zkv62ZaFqltDIOXRYD3eA7NFNVFR/EF3x60WOS+553/ub2ATIhpeTwLJSjN0vIwbw7xhOdjenm6NV8ZDJMES7U18vbZuPISNlHuS27hbGAHMi6G1yvc8frOuOGrGMWXQmsEbWodHJylSm7g+NvE2AVjrSyyupsVAx7zlqTbxWCnaRG0cNBT0C/RncBiCHYKCAj
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
 drivers/firmware/efi/poison.c | 126 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   6 ++
 mm/memory-failure.c           |   3 +
 4 files changed, 136 insertions(+)

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
index 0000000000000..d6855e712832c
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Runtime side of the LINUX_EFI_POISONED_MEMORY table: one bit per
+ * EFI_POISON_UNIT_SIZE, set here as frames go bad, honored by the next kernel.
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
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/overflow.h>
+
+static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
+static u64 efi_poison_nbits __ro_after_init;
+
+static u64 __init
+efi_poison_usable_size(const struct linux_efi_poisoned_memory *pm)
+{
+	u64 nr_units = DIV_ROUND_UP(PFN_PHYS(max_pfn), pm->unit_size);
+	u64 bytes = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
+
+	/* Whole words: the bitmap is reached an unsigned long at a time. */
+	return min(round_up(bytes, sizeof(unsigned long)), pm->size);
+}
+
+static bool __init
+efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)))
+		return false;
+
+	return pm->unit_size >= PAGE_SIZE && is_power_of_2(pm->unit_size);
+}
+
+static bool __init
+efi_poison_range_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	u64 nbits, span;
+
+	if (check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
+		return false;
+
+	return !check_mul_overflow(nbits, (u64)pm->unit_size, &span);
+}
+
+/* The table may come from an earlier kernel, so vet it before using it. */
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
+	pm = memremap(efi.poisoned_memory, sizeof(*pm), MEMREMAP_WB);
+	if (WARN_ON_ONCE(!pm))
+		return 0;
+	if (!efi_poison_table_valid(pm)) {
+		memunmap(pm);
+		return 0;
+	}
+	size = efi_poison_usable_size(pm);
+	memunmap(pm);
+	if (!size)
+		return 0;
+
+	efi_poison = memremap(efi.poisoned_memory, sizeof(*pm) + size,
+			      MEMREMAP_WB);
+	if (WARN_ON_ONCE(!efi_poison))
+		return 0;
+
+	efi_poison_nbits = size * BITS_PER_BYTE;
+	return 0;
+}
+early_initcall(efi_poison_init);
+
+static long efi_poison_unit(unsigned long pfn)
+{
+	u64 unit = PFN_PHYS(pfn) / efi_poison->unit_size;
+
+	if (unit >= efi_poison_nbits)
+		return -1;
+	return unit;
+}
+
+/*
+ * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
+ * unpoison cannot tell whether the unit as a whole is good again.
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
index c7b4a37f760ec..d579d75372248 100644
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


