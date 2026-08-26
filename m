Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFB1C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6ED76B009F; Wed, 26 Aug 2026 08:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FE66B00A0; Wed, 26 Aug 2026 08:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CCF6B00A1; Wed, 26 Aug 2026 08:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85EC56B009F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:05:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC39B1C1972
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:05:05 +0000 (UTC)
X-FDA: 85143289770.22.17C0DBB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0928A1C000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:05:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LkUh0EPQ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787745904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xslyR078ZQa9uWsN28A/GTFrLCow8t/z01YQTIpb9Q=;
	b=sV8GdKOWfwklJeBtkkdEseqj56fNEUlb6XH63tcIOpCVhhLJnUhWIHBHQdenAOb6J2TfVC
	QGjxDxjLSDlXE8qkPuFv2fjvC6250XNoocu/dzT5OsAn+bRCIuF4mlYxLcUwoJuEoooLGT
	Kf6EKpqNexVcyVtkBnJoeZmqLyW4Bs8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787745904;
	b=2/b+x4noFcWJ6NNkblKrbHBk8sP/hz3mVk3msfAG+dIJD3bah4R7ND3tWZKgPbOoOus98W
	p7sJdiqlZ0BTT+5LpXOY9iMA9C5Ij5k6qBcOJhnpZH0QqsAnuY32IH+iWE9GbTxsXmX9+9
	/nhySYbJprc8Nz7BpXqact0GwbICvE0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LkUh0EPQ;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7xslyR078ZQa9uWsN28A/GTFrLCow8t/z01YQTIpb9Q=; b=LkUh0EPQg0YWEV+OVhhL9JVar1
	+errUwJd89Jlfz9ZJ0e9fwczcl1eiXAOCjKm2dAVkwISXn/QCAbRUtMikpoexLaNG0LyOYkco7bxD
	gd46v+RNkPwwuVsi729M1C/LlE/5YMDSfW6zjA/+RbGyPuIYzS30Z4cS/RWBBj2GFzrWULotAXkgx
	E03T0r5DlUvwsqPviw8AQ+wKyxf/YtUE6VhFDflHxVxEiyU8xfWaMQ9bpVikanWkjfbxcgU/IFlJU
	dz9F3mtydsPnNG95Si5m6UR0jEludb/lwOWE34uWXrb+QAodQidP+/4NACd0caC6UmRv5JTOgeHUW
	P0bv+opA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCNI-00FCY0-12;
	Wed, 26 Aug 2026 12:05:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:56 -0700
Subject: [PATCH v3 5/5] mm/memory-failure: efi: replay the poisioned page
 in the next kernel
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6726; i=leitao@debian.org;
 h=from:subject:message-id; bh=UoMzb64e2RlMzQ3LgVqhH1IIBLhMvJk/4Xuo1bCJkZY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZLCwO1oNCTElS8ix1B3HUNJcnZq769xR1lZ
 JL5PIiU4FSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSwAKCRA1o5Of/Hh3
 bbVRD/9Iw/LK/BjUim0dpaiQgKRZZ1f8xiftwNTEtyL3fOd0n8rJfhNNwI3sYHq4gVE284XOr0D
 HGbW/hOAUuLhRJmxMLt1Qil0zrEugzPTWrqr/cjzKoc9ga5RFlLqyWgh8m20KaN/vPRotaDgD7z
 lkFCuSvCi0Zz4XeMNR7NwjzbHxsvBKDUMUzHu2Z/+/Z0sHYuVy/Lpweceyw9VkmWvcAdtRQIEP3
 zHv3ZzSeSWh57EEBZFbzvhgRcdsZK+5BCsafGwfZKZNrnyKq+UNWyoQL8IFc49096PwDyb8Vv7H
 h02yYRlRPK3SX7oy0qGdgUsbZnVwq/6cmVZRWYlo6awU5x0wnGxtBq4GFd0w2KgTmd90Tm1xb+x
 t9mJyuJx5cO2t9vbna97j/R/7WumGlKZ26f/PCpNoz3qdeItgOtm2T5p1jodiaHCs9pT3j5H43H
 oxqhKoT4dWSwszAA15pdvAfbCyBj/8hRGSnLgzY6/pMMCMdrDV17a98RuEVN1CmauiQM62VLNm+
 y0mwHb+CUzJEBpngUcZl8El7meotwtiqRQSmfXv92H0N92WqAq/fHk9IRU4FxUfxQjdInJhBcc0
 eiLHKoWhcTngSyZLgxzqcTLu8udSaoB9BmQ89+JfzcASGwJvZZSnmWNkWamlwIqRY+mmUXp2jgA
 SjD/FL4O6CUk1lQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0928A1C000A
X-Stat-Signature: 6hcqx5wnfqn5649nf9639zzf8bur8p76
X-Rspam-User: 
X-HE-Tag: 1787745903-559290
X-HE-Meta: U2FsdGVkX1+fhOr+9bGN3zZ2510nLIip35/ifkvMK3NkTmAMUwh+PfBQloOqGsVbsNHVnPRDqfybCAFxIckfgZEtjdQUQ1ik7I1zSnG8CNQI71sMft2sk7z9S95xZW7EAVOHyr3tEHEMdw3PpWEvdsOMvAew8ZiKZ6sGxBiYgWcZK5Bq2YhpZTqV1b/o8yJm9VsbaotLPEhPUemdtJNvelc8edoxv08GosBSXP3K05enL0Za63oAEf7PWaP9jXn3UfxMVQqQThiWy2KEylKzPRo3mUnX7hZY6eytjkzFwkeEKFJ4JrCIm1dOfvfIIoJKXvvvFEjM3ZfJw2k6Nkmr4LM6uSYmliMLCiVE4ZCfYkaVLqMTx/amkodutp2124f7pMJtefjQMTwHqDZxYNU4MiGooESy+6Ig0pvAkEfM34l0k11xPlKl1faib5eJI06McyYgEgcs1hdpuxL5G8Ipr7FSt0SLNOJrBAQI/it9mNDslAacx0AhPzOn5MXZ4T0zusO7h0+PxIv+qOfE5wtEImng7Jdu2C+C+lrxeQbcx5Ot6sLcanQITKdocHrDhDSpQQ3hgaTtJVJ6cUM8hUK2/IMY2IoeGEAuyMXbEyM9NzD44lHkN6HS95RHAvdL1NvSWtoLCg0UZYLPagc141bWvWdX1kzn58HlC5M7ktZ0KzvIuF38OYFZaoIC0P0ic+RDv7WVRLfyPDdxyuGy5UE3JcRxoJUSBFE9wEW3ORph2QS1Hzv0JYUIFm9kpxHrIq76/r1tUj9Mf5UPIPl7LYqxDFWPCQoXkY+19t5QvXDkVWQ7jaL8KlXAO7wikR8foYKW/D48hNNPfYLqMw2RwHZcHj7FfhAacHJRwMLU7bgEho7Tmt5QoSCMirTn32DWM5Na29Pk/I4woJ4i1PRB9RYJxdMddfnYmt+C+jRQlRHSuzBIoX05nnHbMFkKfqjnJtDKJujS1Amm0F9Upt+qXi/
 HTdKBmtA
 tL3hIoBLJXWQEjVenssbVeF247UCKdDhhUPGjHsK+qlTVmjAH7uhZ8OJZcNJ4iU9E+0Qlmw1/Um7Mlfp9y0u0iu96KxfoOFvTX6vmZAdizBxoGsryCaWX6j+qz3EJC3f6GHwKhsCNIFMoqJoDJEC+g2cQolRDeBnbL/GD95l81hzyZWDgR04324ollFZx44B7JDhXM+VEAjfaOioWBKfLMQO2tP1B5x/n7Q2zhgtPu65K04UUzw5H3GDDhS+yTQUAuy6Vhi5ll3pxSPOPf/l5ysLfemvU48OS2TthUAzveYPfzkDKcaGHXeGvM2/RfWp7q6BvrilQaZirLTGMYJglmAA/V1wqJQ3JpoHJfOHlF1mzU8mzxiIyNXq3JfCRQ1WwRIvm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bitmap an earlier kernel filled in rides the EFI system table into
this one, but nothing reads it back until now.

Add efi_offline_poisoned_memory(), which vets the table header, copies
the geometry out of it, and hands every frame of every set unit to
hwpoison_boot_pfn(). The bitmap runs to megabytes on a large machine, so
it is mapped and walked a page at a time rather than in one go.

Call it through hwpoison_init_boot() from mm_core_init() right after
memblock_free_all(), the first point at which the recorded frames have
struct pages. They end up in the state a frame poisoned by this kernel
would be in, so the placement check that already understands PG_hwpoison
covers them too.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 113 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/efi.h           |   2 +
 include/linux/mm.h            |   5 ++
 mm/memory-failure.c           |   6 +++
 mm/mm_init.c                  |   1 +
 5 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index d6855e712832c..179843277457f 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -9,14 +9,20 @@
 
 #define pr_fmt(fmt) "efi: " fmt
 
-#include <linux/bitmap.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/log2.h>
 #include <linux/memblock.h>
+#include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
 
+struct efi_poison_geometry {
+	u64 table;		/* phys address of the table */
+	u64 unit_size;
+	u64 bitmap_size;
+};
+
 static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
 static u64 efi_poison_nbits __ro_after_init;
 
@@ -124,3 +130,108 @@ void efi_hwpoison_record_pfn(unsigned long pfn)
 
 	set_bit(unit, efi_poison->bitmap);
 }
+
+static bool __init efi_poison_read_geometry(u64 ppm,
+					    struct efi_poison_geometry *g)
+{
+	struct linux_efi_poisoned_memory *pm;
+	bool valid;
+
+	pm = early_memremap(ppm, sizeof(*pm));
+	if (!pm) {
+		pr_warn("Could not map poisoned-memory table\n");
+		return false;
+	}
+
+	valid = efi_poison_table_valid(pm);
+	if (valid) {
+		g->table = ppm;
+		g->unit_size = pm->unit_size;
+		g->bitmap_size = efi_poison_usable_size(pm);
+	} else {
+		/* Keep the runtime side off a table this pass rejected. */
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+	}
+
+	early_memunmap(pm, sizeof(*pm));
+
+	return valid;
+}
+
+static unsigned long __init
+efi_poison_offline_unit(const struct efi_poison_geometry *g, u64 unit)
+{
+	unsigned long pfn = PHYS_PFN(unit * g->unit_size);
+	unsigned long i, nr_pages = 0;
+
+	for (i = 0; i < g->unit_size >> PAGE_SHIFT; i++)
+		nr_pages += hwpoison_boot_pfn(pfn + i);
+
+	return nr_pages;
+}
+
+static long __init efi_poison_walk_chunk(const struct efi_poison_geometry *g,
+					 u64 off, unsigned long *nr_units)
+{
+	u64 chunk = min_t(u64, PAGE_SIZE, g->bitmap_size - off);
+	unsigned long bit, nbits = chunk * BITS_PER_BYTE;
+	unsigned long *map, nr_pages = 0;
+
+	map = early_memremap(g->table + offsetof(struct linux_efi_poisoned_memory,
+						 bitmap) + off, chunk);
+	if (!map)
+		return -1;
+
+	for_each_set_bit(bit, map, nbits) {
+		nr_pages += efi_poison_offline_unit(g, off * BITS_PER_BYTE + bit);
+		(*nr_units)++;
+	}
+
+	early_memunmap(map, chunk);
+
+	return nr_pages;
+}
+
+static long __init efi_poison_walk(const struct efi_poison_geometry *g,
+				   unsigned long *nr_units)
+{
+	unsigned long nr_pages = 0;
+	u64 off;
+
+	for (off = 0; off < g->bitmap_size; off += PAGE_SIZE) {
+		long nr = efi_poison_walk_chunk(g, off, nr_units);
+
+		if (nr < 0) {
+			pr_warn("Could not map poisoned-memory bitmap\n");
+			return -1;
+		}
+		nr_pages += nr;
+	}
+
+	return nr_pages;
+}
+
+void __init efi_offline_poisoned_memory(void)
+{
+	struct efi_poison_geometry g;
+	unsigned long nr_units = 0;
+	long nr_pages, expected;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	if (!efi_poison_read_geometry(efi.poisoned_memory, &g))
+		return;
+
+	nr_pages = efi_poison_walk(&g, &nr_units);
+	if (nr_pages < 0)
+		return;
+
+	if (nr_pages)
+		pr_info("poisoned %ld page(s) inherited across kexec\n", nr_pages);
+
+	expected = nr_units * (g.unit_size >> PAGE_SHIFT);
+	if (nr_pages < expected)
+		pr_warn("%ld inherited poisoned page(s) could not be taken out of use\n",
+			expected - nr_pages);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d579d75372248..03ba40ff70e7e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1285,8 +1285,10 @@ struct linux_efi_poisoned_memory {
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
 #ifdef CONFIG_EFI_POISONED_MEMORY
+void efi_offline_poisoned_memory(void);
 void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
+static inline void efi_offline_poisoned_memory(void) { }
 static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 52a00a0e090c7..092220943531e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5104,12 +5104,17 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+void __init hwpoison_init_boot(void);
 bool __init hwpoison_boot_pfn(unsigned long pfn);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
+static inline void hwpoison_init_boot(void)
+{
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 713fb2f8e0332..1d6a472267bdb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -121,6 +121,12 @@ bool __init hwpoison_boot_pfn(unsigned long pfn)
 	return true;
 }
 
+/* The EFI table is the only source of inherited poison today. */
+void __init hwpoison_init_boot(void)
+{
+	efi_offline_poisoned_memory();
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ddda9d6837f32..f94fa221da0b8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2667,6 +2667,7 @@ void __init mm_core_init(void)
 	kho_memory_init();
 
 	memblock_free_all();
+	hwpoison_init_boot();
 	mem_init();
 	kmem_cache_init();
 	/*

-- 
2.53.0-Meta


