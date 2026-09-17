Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E321BC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9731D6B009E; Thu, 17 Sep 2026 02:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C156B009F; Thu, 17 Sep 2026 02:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8895E6B00A0; Thu, 17 Sep 2026 02:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB726B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CEA21C1822
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:32 +0000 (UTC)
X-FDA: 85222222344.06.E52565F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D5AA180004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:07:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JyWS//Ir";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789625250;
	b=orWU/RJbnxKWZjfYBtpq71TF6PwuJ+sLSyOcOUG7eSfmCVTeZNBOnUv9n3b6fij1Qu1BoE
	Rwb+SAG2BpNQ+s0FNA6ULzZayqvhqQIBfOIYBHbhsiYD48G5VJfN10iWx7hmHvKgEdA8iD
	9d73gH5PIPho7bI1pzROUPvVYb6AE/Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JyWS//Ir";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789625250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqaGXeiI19JmMrfZJKzFwEIp/5Qj6q2YW8WHfV2wLwo=;
	b=aH+0FpfrYYDD9nTKA9jP8JI6aZ64+QpXqmeFJ431VzS6ItKYUbHIkmLwZlqB+YpDwbwxdT
	Sh9A0mp2djhmbJ2IlfHRTjBtcnHx7F/exkqczzCqcef/KzL9tL4z8M/5/kxYilQP0mfB3I
	QIkcBJOOm0taFNflyGbXd7h77X4FcI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3143407BC;
	Thu, 17 Sep 2026 06:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2571F000FF;
	Thu, 17 Sep 2026 06:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789625249;
	bh=gqaGXeiI19JmMrfZJKzFwEIp/5Qj6q2YW8WHfV2wLwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JyWS//IrL4Aw7bFXomKjFolUgbIPHsZouDWnic5S+aTpPokzfuKgOWPTKof8kMzf4
	 ORUeYQ7na9GxLBhUgaS+QgFavTWYFpX9op1wkO371fVcu4TQB37YANueMbWoCS3a6P
	 4GaCJnXwuJRDcjIGL1Vgu+a09rYWHkz9cEJeKR8+50Jzg5GrQ848QBQVWuHm5hZT7F
	 ErKPWyG7fMgo5Kj/NLgWhk9CRjoNVnq/glGzRCwnl+Wmj//5qEETRXIw2qdXzFNwkc
	 JS3S0SAQC2GrQwKYZfkxkXqgQQolwcnUoslsEEN60If1un8fD41lNUq+qgIiSZzihh
	 nUSPmRA2Mb7Ag==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 17 Sep 2026 09:07:06 +0300
Subject: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Potapenko <glider@google.com>, 
 David Hildenbrand <david@kernel.org>, Marco Elver <elver@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D5AA180004
X-Stat-Signature: tgout5ha6ccw6rxwk9dp46hrha7odyu6
X-Rspam-User: 
X-HE-Tag: 1789625250-452272
X-HE-Meta: U2FsdGVkX190yRn8gerPrIPLZzwL1dlHr7xzLq8s5PR2oqHE3eh7/4eOTGw3m1u4wJUOQoZpBb4So7AxTY2nklmmccO9ckXyoi0I2wMNVkLEYFO8+LnL2PnM4WVM8XZ+Bmx6EkjpWGlYL8SLCpl7l7t4A3rfE8ijlB9Z3iOu3uOat7pooZ410PpG8s6aRrYoPAA7JOWrxaEmtbwW182g8Nkfru/lZUwkyfk+wc1Ij40di7uLKy6MEq2ThFIHM0i5ZBs7BGnQ9UrUiwufBd0zd2vnVSbL7t5W8yAy2aFUYXqtAsimU9Vr6rT0gW6kHFKw0k8dw2GnqFUIFdS8qq+ejUjhmDl1znIJCdpn+CGjW9QAaI+mmtAnT0/F+A+4D9fknBVVExnG7mA1CVPon+GWoDXM/hkJ/q2W+ONUGkk5wfjPggBFwgqRsD7669aOGFJLO867750VI8rumdgE4r0K3ZmPBlVYBlGxM36kZcqSEPemf93+KSbgoGtwDMDbzf6uk+EccGL89tO6Omv3V2Q2W2cOMjXVP5UOitTfPvNpXF5ZqenVJRrqH5qxDBmfIzOOTIvVMCWCdL3F1cO6f/S5KZLJA+05JNMtRQ4K32s1YJ5aI97RjU6y7XFR36QCJCpPag3clK6N6FNHNBh6VAWgrW8p293E+/A/FKsFSPgUgJyvg9qP/Iim1qUDIP5yrn2dStGxs9melQEq/0lLZ3BwUwb4/Z2vKu3c/YCFoz3yewhvHyIlywtwQSbU7rATws1WgXgKeonHQrs/fzEnFxC9qpEMh9YAYzdXyNrJ19u5PHAOEzgCrqwbUZi7iC+/kUCSUhckpypO1F4p/p63NizhzY4I4Fahb6MBITNkDS8RGxkkuY0hPr2721Vg+sUniMQtyUsPIvH5aEWv/N/ZmVkeEUXL2gOLGH8ZbP87lWi/PhitxERSw7eRRfrsWFm1eJnlNzFw/fY7xTsmCRyb5Td
 6IgtwuRS
 QPt2w5iH3VxUqEssUPZc1B7CjFotLG7Od0nLtXEBTyWTZckxg8QIQhKafi5lSbOIrSZQh/FHL0gxJrpbahybc5GbZ1GRaW5KaisNuIMNCH6OGECdn9ZrsMTFI11yIykhPLGZe4C+EtGABIKz3TK3k5kowT/eGeisY5mcUtp48+xiNosaqcUmDouP9G/kltulJTDlQr2zZ0y8xIDvIgRNsFDuG1BoaxFoK348sHoNW/3Q6k/CbRMsV/YeavsHfk7uN92tY1KLYgYy5D9jcGVONahCzMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pages protected by KFENCE are removed from the direct map.

safe_copy_page() temporarily maps and unmaps them using set_direct_map
APIs, or, when the stars align, even using debug_pagealloc_map_pages().

Neither of these APIs cares whether it is a KFENCE page and both blindly
perform the update of the kernel page table for any non-present page.

Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
KFENCE and debug_pagealloc are enabled is an amusing coincidence.

But with increasing appetite for using set_direct_map for hardening
purposes, it becomes too big of a hammer to enable saving any non-present
page in the hibernation image.

Another gotcha is that loongarch that does not have a direct map at all
advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
hibernation.

Extend KFENCE with a bitmap that tracks which pages are protected and
provide kfence_force_mapping() and kfence_restore_mapping() APIs that allow
forced mapping and unmapping of KFENCE pages.

Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kfence.h  | 29 +++++++++++++++++++++++++++
 kernel/power/snapshot.c |  7 +++++++
 mm/kfence/core.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index e5822f6e7f279..33a126cb6d1b7 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -222,6 +222,32 @@ struct kmem_obj_info;
 bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
 #endif
 
+/**
+ * kfence_force_mapping() - make sure a KFENCE page is mapped
+ * @page: page to map
+ *
+ * Check whether @page is protected and map it if needed.
+ *
+ * Requires: is_kfence_address(page_address(page))
+ *
+ * Return:
+ * * false - failed to map @page
+ * * true - @page is mapped
+ */
+bool kfence_force_mapping(struct page *page);
+
+/**
+ * kfence_restore_mapping() - restore mapping of a KFENCE page
+ * @page: page to restore mapping
+ *
+ * Requires: is_kfence_address(page_address(page))
+ *
+ * Return:
+ * * false - failed to restore mapping of the @page
+ * * true - succeeded to restore mapping of the @page
+ */
+bool kfence_restore_mapping(struct page *page);
+
 #else /* CONFIG_KFENCE */
 
 #define kfence_sample_interval	(0)
@@ -241,6 +267,9 @@ static inline bool __must_check kfence_handle_page_fault(unsigned long addr, boo
 	return false;
 }
 
+static inline bool kfence_force_mapping(struct page *page) { return true; }
+static inline bool kfence_restore_mapping(struct page *page) { return true; }
+
 #ifdef CONFIG_PRINTK
 struct kmem_obj_info;
 static inline bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 52ef0599c2076..6583b57722e25 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -31,6 +31,7 @@
 #include <linux/compiler.h>
 #include <linux/ktime.h>
 #include <linux/set_memory.h>
+#include <linux/kfence.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -81,6 +82,9 @@ static inline int hibernate_restore_unprotect_page(void *page_address) {return 0
 
 static inline int hibernate_map_page(struct page *page)
 {
+	if (is_kfence_address(page_address(page)))
+		return kfence_force_mapping(page) ? 0 : -EFAULT;
+
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		return set_direct_map_default_noflush(page, 1);
 	} else {
@@ -91,6 +95,9 @@ static inline int hibernate_map_page(struct page *page)
 
 static inline int hibernate_unmap_page(struct page *page)
 {
+	if (is_kfence_address(page_address(page)))
+		return kfence_restore_mapping(page) ? 0 : -EFAULT;
+
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
 		int ret  = set_direct_map_invalid_noflush(page, 1);
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 90925c646c4c2..666e8991d1fed 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "kfence: " fmt
 
 #include <linux/atomic.h>
+#include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
@@ -123,6 +124,9 @@ module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
 char *__kfence_pool __read_mostly;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
 
+/* keep track of protected pages */
+static DECLARE_BITMAP(kfence_protected_pages, KFENCE_POOL_SIZE / PAGE_SIZE);
+
 /*
  * Per-object metadata, with one-to-one mapping of object metadata to
  * backing pages (in __kfence_pool).
@@ -249,14 +253,36 @@ static bool alloc_covered_contains(u32 alloc_stack_hash)
 	return true;
 }
 
+static bool __kfence_protect(unsigned long addr, bool protect)
+{
+	unsigned long page_addr = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long pool_addr = (unsigned long)__kfence_pool;
+	unsigned long index = (page_addr - pool_addr) >> PAGE_SHIFT;
+	bool state;
+
+	assign_bit(index, kfence_protected_pages, protect);
+
+	/*
+	 * Reapply protection if the desired state changed while updating
+	 * the page table.
+	 */
+	do {
+		state = test_bit(index, kfence_protected_pages);
+		if (!kfence_protect_page(page_addr, state))
+			return false;
+	} while (state != test_bit(index, kfence_protected_pages));
+
+	return true;
+}
+
 static bool kfence_protect(unsigned long addr)
 {
-	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), true));
+	return !KFENCE_WARN_ON(!__kfence_protect(addr, true));
 }
 
 static bool kfence_unprotect(unsigned long addr)
 {
-	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), false));
+	return !KFENCE_WARN_ON(!__kfence_protect(addr, false));
 }
 
 static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *meta)
@@ -1335,3 +1361,25 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
 
 	return kfence_unprotect(addr); /* Unprotect and let access proceed. */
 }
+
+bool kfence_force_mapping(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long index = (addr - (unsigned long)__kfence_pool) >> PAGE_SHIFT;
+
+	if (!test_bit(index, kfence_protected_pages))
+		return true;
+
+	return kfence_protect_page(addr, false);
+}
+
+bool kfence_restore_mapping(struct page *page)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	unsigned long index = (addr - (unsigned long)__kfence_pool) >> PAGE_SHIFT;
+
+	if (!test_bit(index, kfence_protected_pages))
+		return true;
+
+	return kfence_protect_page(addr, true);
+}

-- 
2.53.0


