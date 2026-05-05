Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35084CD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988A66B00D0; Tue,  5 May 2026 12:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912B56B00D1; Tue,  5 May 2026 12:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801406B00D2; Tue,  5 May 2026 12:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1A66B00D0
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C351A03FF
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:01 +0000 (UTC)
X-FDA: 84733847562.25.29B6572
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48FDA1A0019
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cBR/6v4H";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IGMDvz2yV4/0JfvZ6QXLMRT5Pnmj7yCzlHePnPqn7A=;
	b=HBKW/PREFbfyKHgPRAHnZZx9CyA76Sxa01ZYuwFBPPeSXKnyQcE0BYhn4Kzgx3//8kh6lX
	+MybBYb0EW2APUS55dIsA5o/Sul8kMWcrHt1vCVKcWu0Tn2ZyykKfyU4fxODq4M0WuoCsm
	Wuz5Do71TMGf17eWPTn1SQEjWKqrhhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997279; a=rsa-sha256;
	cv=none;
	b=HaXWcEOG0wpWs50Ll7cEibDZeXHsFTvYR8B8QsM47jgiNMqsiJuGzbhsKkKYXGYhbo5UtL
	q0KS74vSKZbySe6hxvSoTj0TKHiX4RAU78PGm6InNOwzo6nGqsJ/No/N4rY8d4KNnMuKwY
	J1am2ZNKAw2mmOyAfxetdtMJHnmB9L8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cBR/6v4H";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A8A714BF;
	Tue,  5 May 2026 09:07:53 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43D0A3F763;
	Tue,  5 May 2026 09:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997278; bh=7pzU3b7DWaYhX0sffzNlwFRd/XRrt+LdkFDa48ecpjg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cBR/6v4Hv4Sr3C+f8YDgEMZpwRWX1wtvmFmvJ4Q2erUf2USp4d9GAswyqWIF4sbnG
	 GLczzGyxydeIfR6a0yyGKRWCwOyymK1qljTki04APrLxiztckPYDhTly8QWWwWVkWp
	 T9E7LuRUPGl4uZfQnqobNvCfJI5rRz0OdpVFUCK8=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:01 +0100
Subject: [PATCH RFC v7 12/24] mm: kpkeys: Protect regular page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-12-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=5204;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=7pzU3b7DWaYhX0sffzNlwFRd/XRrt+LdkFDa48ecpjg=;
 b=gnCgSobzbTfSdcQyyWLGAZ1VLNECP5e8FFcomVkcQfwTIUG7UQTxpTJUfrmF0R9blBKBKk2dU
 7NsCVzqmZ4hC2NzC38FxkayBoIYqxn8krJSXX+7okMc6XTHfLzpc8aQ
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 48FDA1A0019
X-Rspamd-Server: rspam04
X-Stat-Signature: ssj3wh3hbzdo371o9rhstsyqo95r6rnm
X-HE-Tag: 1777997279-683009
X-HE-Meta: U2FsdGVkX18YjAPXFw33d9KRdGzYmt7Yww9r0JmJr1HvzCc44KlEhd0b/1dwbVZdnEYGBsJrDhdPxNdhLYVH6oZHvnO1zvbxIMe28SXs2ZwuPxl7NleI33fGHavUfX3Lxi3RcE0oScGTDmxA8fcOD7XgndT/HId32jgR+rgAqHlLkeDSkURvBNM/NX0On1P+vp94TFawcQ5P48SEret6TBxIcYD/vJwhXCT6n78h7EiOUwa84u1JcNpftyyB3/J4sp4dHW7+jdgUYbm5/kwzDjECgqyktdMW6+r9uRXQMkSIbwDh2sWMy9YADSVj0AvrV6Dikup6LOOmd1FGtBPgQJGvcgUSvKLATq94YzwIYYMb48le4aWvID+8B3LSzwlSjtHKPRr/01BUhJo9RdUhKB6oEPr4zEd/e7Scpv3bkolpou/rH+SJIExWxMxaMHijfrdEMUBPZHQQVBUdSz9YuT3Zo8Q7APlgV/mTVoOevW/XdKriz/ZLvFQ/VBv1iqb/aS9MGo4ovJA/ufiXkH72IuaEzU7W+1Plm3ZFrr3JoL44jIl1ZgxUK6M08rPE7Ypnxd5hni4Y4/n7eP4zaa740d9qKVrEQrLritJGlB6nLhlpwZA1InyLa+ihuRD9J8lKxKBu5A5/WG2/6eIDfp/mjiewV+Cf9ClrQWUe+Sv2MKZVPukBB/w+wdu2/82lSYbbQ/E0nDMYNT7ezTHG9Up2X1TynhB0TVt7CZoiZNKZ5LTToIenS/zHUiTwLEoUt+uBUGKRquoeMQ78ELOXGwZ1xWfGHhSHvcn4gJQO/c15NfMIuW5O1KMBQR5TCxXrmlX2EYutKZ9TrS479gPcZzkY03+t0Wy8dA+e2GMf6dt6zERkrID4ClrB/cUAGaf2GZz8f3JJY7caHbbgP5GvAXQhIkJewTZS1qKGI4A2ThVbuBEDs5HSeSNs2WQLsvw832b654haiFR8tYj9z12wGYl
 +zaUpT7a
 EixGcXPt8/ETBEk0PZjYg8TcVnlOLiRGn3/eh2xKv4oh9UFSuwtVlmFv6Eb+356tjT+AvahFCXsyBPFZT8ErLY/JRdLzP43yZLhn6SEtnO8GljhhdTFqok6EY+RaTEAsdZmdJu8kOyAIxm9HT+Ribs2uZLUHuHK7LoOCfUp8bqbUMCGQwEnGXaQfn/sT1WAjIXEfmuUSVP/jmFah94IC3UD1N9SSj8ODvgY3E8sqppJKA1gBZvMJ3k/fCm9WoMR0zkMH7qTVLXmNc6bla7HGkZ4kad9PmRUWLxljF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the kpkeys_hardened_pgtables feature is enabled, page table pages
(PTPs) should be protected by modifying the linear mapping to map
them with a privileged pkey (KPKEYS_PKEY_PGTABLES). This patch
introduces a new page allocator for that purpose:

* kpkeys_pgtable_alloc() allocates a new PTP and sets the linear
  mapping to KPKEYS_PKEY_PGTABLES for that page

* kpkeys_pgtable_free() frees such a PTP and restores the linear
  mapping to the default pkey

This interface is then hooked into pagetable_alloc() and
pagetable_free(), protecting all page tables created once the buddy
allocator is available. Early page tables are allocated in other
ways and will be protected in subsequent patches.

This implementation of kpkeys_pgtable_{alloc,free}() is minimal and
relies on the linear map being fully PTE-mapped - otherwise
calling set_memory_pkey() on a single page may result in splitting a
block mapping, which in turn requires allocating a new PTP. A more
elaborate implementation could be added later to handle this
situation.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 10 +++++++++
 include/linux/mm.h            | 14 +++++++++++--
 mm/kpkeys_hardened_pgtables.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 1ed0299ad5ac..c9f63415162b 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -131,6 +131,9 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
 	return arch_supports_kpkeys_early();
 }
 
+struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order);
+void kpkeys_pgtable_free(struct page *page, unsigned int order);
+
 /*
  * Should be called from mem_init(): as soon as the buddy allocator becomes
  * available and before any call to pagetable_alloc().
@@ -149,6 +152,13 @@ static inline bool kpkeys_hardened_pgtables_early_enabled(void)
 	return false;
 }
 
+static inline struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
+{
+	return NULL;
+}
+
+static inline void kpkeys_pgtable_free(struct page *page, unsigned int order) {}
+
 static inline void kpkeys_hardened_pgtables_init(void) {}
 
 #endif /* CONFIG_KPKEYS_HARDENED_PGTABLES */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..7b95b2351763 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -37,6 +37,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kpkeys.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -3648,7 +3649,12 @@ static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
  */
 static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int order)
 {
-	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
+	struct page *page;
+
+	if (kpkeys_hardened_pgtables_enabled())
+		page = kpkeys_pgtable_alloc(gfp | __GFP_COMP, order);
+	else
+		page = alloc_pages_noprof(gfp | __GFP_COMP, order);
 
 	return page_ptdesc(page);
 }
@@ -3657,8 +3663,12 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 static inline void __pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
+	unsigned int order = compound_order(page);
 
-	__free_pages(page, compound_order(page));
+	if (kpkeys_hardened_pgtables_enabled())
+		kpkeys_pgtable_free(page, order);
+	else
+		__free_pages(page, order);
 }
 
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 763f267bbfe4..fff7e2a64b64 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -1,12 +1,59 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kpkeys.h>
 #include <linux/mm.h>
+#include <linux/set_memory.h>
 
 #include <kunit/visibility.h>
 
 __ro_after_init DEFINE_STATIC_KEY_FALSE(kpkeys_hardened_pgtables_key);
 EXPORT_SYMBOL_IF_KUNIT(kpkeys_hardened_pgtables_key);
 
+static int set_pkey_pgtable(struct page *page, unsigned int nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	ret = set_memory_pkey(addr, nr_pages, KPKEYS_PKEY_PGTABLES);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+static int set_pkey_default(struct page *page, unsigned int nr_pages)
+{
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	ret = set_memory_pkey(addr, nr_pages, KPKEYS_PKEY_DEFAULT);
+
+	WARN_ON(ret);
+	return ret;
+}
+
+struct page *kpkeys_pgtable_alloc(gfp_t gfp, unsigned int order)
+{
+	struct page *page;
+	int ret;
+
+	page = alloc_pages_noprof(gfp, order);
+	if (!page)
+		return page;
+
+	ret = set_pkey_pgtable(page, 1 << order);
+	if (ret) {
+		__free_pages(page, order);
+		return NULL;
+	}
+
+	return page;
+}
+
+void kpkeys_pgtable_free(struct page *page, unsigned int order)
+{
+	set_pkey_default(page, 1 << order);
+	__free_pages(page, order);
+}
+
 void __init kpkeys_hardened_pgtables_init(void)
 {
 	if (!kpkeys_enabled())

-- 
2.51.2


