Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9745C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCDDF6B009B; Wed,  9 Sep 2026 09:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DDA6B009D; Wed,  9 Sep 2026 09:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C096B009E; Wed,  9 Sep 2026 09:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96BBD6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:06:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D43CF1C12B2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:05:59 +0000 (UTC)
X-FDA: 85194246438.22.B02DCE6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF96B1C000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:05:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=h4aPQMF0;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PemFBMviso9wUk51x5UQAGvSeZzXgVpZ1oI2Ix7beok=;
	b=To0igbDMlYUb4ZxsRphDIJu9sJxfza/0VecmtkdQTBCzcSNjDjPLTYvAZJwJglE95SUew0
	VXg8Ry8wc98rLcq48IUZPnAxisqiNarqTnZT3swb95eYY2WajJ01+q+zk+ejYHPX6tgTMd
	FFErsE54y8E2SFORmIiEkfFiUyu3N8I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959158;
	b=Nkjc8T2khyyGRMYbgxxn9un2RvLAFu/XNXb1EKaqjyjNrKzSoJ1RVm+nC/LiDhvxvrrUfU
	4uxesP/cvFCPwtBjhIIFW6vycGSg+LvOuw/+wxIBxOPI1z/8Jq5u0HMDcFMHI0gyASUWd5
	2HYApfCiWvPdQ7awPTo1rzmecpFU3IE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=h4aPQMF0;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=PemFBMviso9wUk51x5UQAGvSeZzXgVpZ1oI2Ix7beok=; b=h4aPQMF0TgBykrGoPNAWU/sfP1
	HKgkZpOnAJ1rQeQWmsaRyU1t9hzIN30Pm7NOJJxu2QtTGxvj4Su+CvgJ5S7Vhq0H9wozAegm3QIBL
	YL+kR/j2+zqdwQ2tfHCcNJYQ8kon7SuAfHiTxxVUzxepPvCY56NhyPHIUABjwM29ngLq/icWz8lCq
	XtMgnUoteYawUU1GZ7TqtXnka0m/T2g+72a5Kqnxyclcw6UUaVIl0dnPGaXexjGd2cUnnQRs50GYm
	RcDEM0lZ/XZHXajn8KbIqujRqrSspBlIfLhhLT3btevmvVoyaKUS4dOhY/wRz4B6sNHzNXPSqKrmc
	aQ2JlOXw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Hzv-0034da-0I;
	Wed, 09 Sep 2026 13:05:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 09 Sep 2026 06:05:22 -0700
Subject: [PATCH v4 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
In-Reply-To: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=7468; i=leitao@debian.org;
 h=from:subject:message-id; bh=QzxY6swGj4uClWFDi/b7LYNR3LsUHGQKrkxuPAwiI/A=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYxYrjNedwZha81oWfKnvUlWIrUR+ttXbdT
 l5XHuOQ65KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bQIiD/47XBTdySzJJtvFna4DTxdL7fCIOx+d+ZkNqTDRMWLNAkMtNH9hyKBgmwpCEUXbmuDW57i
 7z5iZz3wMWHsnim7Shcm5b75pz4sKnBSN/YenYNaa+WjyYj11hyTCMB4+ZqAQpABLU93O1fBgis
 Mydvnr+Md7jm7iHdBRsAObubUES2rX0s/h20ymBfdnz7DuonN1WctKkEe3JwKmY7YIIfk0Z2k8R
 HR3qOKtzWE9G/ZweGOGrIRGspOXrt5uRSVhLf7ej8NRQKURmbzTF68LoEcYTu7KZG/+PiOSBGfC
 JT6A8W+LdXIqLP5n5BvQzF5cwjCBxf4M9sF5zzQccNbtzk/x5rF5I1kc949gpsvVNuL693ENllb
 QAZDuboAsYoW8PuxrxGP+8m8CwICLtrlyrgcm0PUI59jq7FpcRDhG9va5FoynqT+FM5ObtPZnEf
 81wXL6ZTltDpi56YaqzeFXjTCTw4tBL+5un5LXX8gu3lpk1BoHK2YfJFYVAftUGOBFJrI+59fR2
 63x1A5FmxRmHzjfJLbZctxjIYh/m+z7bbV6eRJLfkyBDw5p4TwZcAsmioHUB1tTYnw1hgDv52c9
 SSwivX1YNiKoopoAPgwYMZN4tjrabbItkpMi3cIcq0ZXpeBJ9HsujSYKherKxP+x4sIHNJJdJQq
 mxF94JC+1ZEEA3Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DF96B1C000E
X-Stat-Signature: dnf4usmfkfkxuk77cnhsb4ectzsg1sos
X-HE-Tag: 1788959157-724908
X-HE-Meta: U2FsdGVkX19gbyB3f9kRi5HJkElQ8MQT8wZdO6G+S0NM4KnAiLaGWlKRwJQ8iiDnOj2QqP2uFm/0ZW9D91/JTokrx3RCcImNgPcT2aaCTh3MyxKlugmFBuWmppb3D0nNSgGquPEhXdqvhAyDzJS7PgeMXHgns3KqZKz9qLD0c/dubLoxmYxWCPqpf2JjKKcNregckMNbJHVfj2t7EgwCQMQNssJ8mFqRQQ3Spf3awEFRGP6lE9lguxefxmYtgOFKn8RbEW1Zb/QshbwG+bWMNRPpZfUh6qpIDyVS98/6QN7dVPwAVFcS+AjLs1DMiv7G99ex4mzhlohoc9ZEcLt4nejJCBwDQ+HIAV6Se9eO9bEz4pTJO+Rq2qYzd2kLnjgHnYOuGihOUJRhYKcElvR3HhUWTc2KXH/4IBLGA8V+Cp6wN7s7pRt/B4P4U15wQ+GrK4YFr52kVTfrf4ydLFot+aSmOC2st+fQmXsiPYAggCmjvneZe6e6BwkSnDiGdXxS/NtSeJCqLwdSzEaHoWsw8ubd+co3E5YV5pi7fiIttRGr51YToDVPWJupJLIjUOecrBiSkeIsmoBp3AMsR9RACIEL/YWlOPQdl9ySgJZ+SZ5CSES+AaY5Uha2cKhz0TrgQ9BTjmnPxOWihcZH++uMJi5nbXbm9mKLHJ+cvvOYlEyLm9TITOkBQH01R2QAw/Mb+wZPjBEtfSmpGPGJNgZE8Rc7oi16wOI5CfKOCjFERqGUur5Awyu1RwzGoPHNKNlWW+iUWfus3+vYkmgS+Xj2mt+UFhCoeAHcK/ZDzGfyPFKhnZnz/9u1TAxb24uMiD0U5N+I+VxAPGf9CVU3W5mt41mbLh9om812fNmL4rdEsSyOgcXRT3ZAk0zgqZQb7Rvd2l8Kutx3737x/s2ZlW2kTQz4TMZ4rpxGOJKUYg6IZ773nd1qP6siWLz3k2Qpm72c1grB5mw4ts4zAGhkHNU
 5M6QXuD3
 y8q5lCXqXqJwoTY7aeMShaoTkFWi+8HivFxJEuVzoJ9onTdLV2b7MAkDn/mRqkHMK1T7fWJnhOLbU1ZYyFd9hVb1Gwdj06wMSM5O8/5BRPttFs21cGyaAl17/AP0keYEIsqVEeg+0hfCjjOKxbjxq7zT/5kiTW2+0IPMnVFX0inxFDJmgpzcpFSD9igGlBvONsRNLQjMVJVpLHGVjddO/RbwccVGYu03ZotglJ7KrpCXw4LZyWcDG9KuHbno3V2odp6xQX41rIP06cFW2zYy612xBRSmZkHW1PtCzcSURM+jhnQrHwrhTVdROiktutBccmd33zpHPvTxK3500AeCRdwYti8HnkWKq7X17HIkkMlRwMso=
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

The table is EFI ACPI reclaim memory, which becomes E820_TYPE_ACPI and so
reaches neither memblock nor the direct map; touching it then faults.
Hand its pages to memblock from efi_config_parse_tables() the way the
unaccepted memory table already does, and vet the inherited header in the
same pass, so everything afterwards can reach a table it can trust with
phys_to_virt().

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/efi.c    |   2 +
 drivers/firmware/efi/poison.c | 115 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   8 +++
 mm/memory-failure.c           |   3 ++
 5 files changed, 129 insertions(+)

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
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index af1fa443839c4..55b2ee53fc268 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -883,6 +883,8 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 		}
 	}
 
+	efi_poisoned_memory_reserve();
+
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
new file mode 100644
index 0000000000000..c18edf111c710
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,115 @@
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
+static bool __init
+efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
+{
+	u64 nbits;
+
+	/* Whole words, and a bit count that can be taken without wrapping. */
+	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
+	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
+		return false;
+
+	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
+		return false;
+
+	return IS_ALIGNED(pm->phys_base, pm->unit_size);
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
+	if (!efi_poison_geometry_valid(pm)) {
+		pr_warn("Ignoring malformed poisoned-memory table\n");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Vet the inherited table and hand its pages to memblock, the way the
+ * unaccepted memory table is handled. It is EFI ACPI reclaim memory, which
+ * becomes E820_TYPE_ACPI and would otherwise stay out of the direct map, and
+ * touching it then faults. Called from efi_config_parse_tables(), so
+ * everything later can reach it with efi_poisoned_memory().
+ */
+void __init efi_poisoned_memory_reserve(void)
+{
+	struct linux_efi_poisoned_memory *pm;
+	phys_addr_t start, end;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	pm = early_memremap(efi.poisoned_memory, sizeof(*pm));
+	if (!pm) {
+		pr_warn("Could not map poisoned-memory table\n");
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+		return;
+	}
+
+	if (!efi_poison_table_valid(pm)) {
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+		early_memunmap(pm, sizeof(*pm));
+		return;
+	}
+
+	start = PAGE_ALIGN_DOWN(efi.poisoned_memory);
+	end = PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);
+	early_memunmap(pm, sizeof(*pm));
+
+	memblock_add(start, end - start);
+	memblock_reserve(start, end - start);
+}
+
+/* The table, vetted at parse time, or NULL if this boot has none. */
+static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
+{
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return NULL;
+
+	return phys_to_virt(efi.poisoned_memory);
+}
+
+/*
+ * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
+ * unpoison cannot tell whether the unit as a whole is good again.
+ */
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (!pm || addr < pm->phys_base)
+		return;
+
+	unit = (addr - pm->phys_base) / pm->unit_size;
+	if (unit < pm->size * BITS_PER_BYTE)
+		set_bit(unit, pm->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index efaf63f9a54ed..56402fdccd114 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1286,6 +1286,14 @@ struct linux_efi_poisoned_memory {
 
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void __init efi_poisoned_memory_reserve(void);
+void efi_hwpoison_record_pfn(unsigned long pfn);
+#else
+static inline void efi_poisoned_memory_reserve(void) { }
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
+#endif
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a2ca8df501cae..d9b8be696aac3 100644
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
@@ -1326,6 +1327,8 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
+		/* Only hard offlines are carried over to the next kernel. */
+		efi_hwpoison_record_pfn(pfn);
 	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",

-- 
2.53.0-Meta


