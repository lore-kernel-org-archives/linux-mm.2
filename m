Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3D8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DC46B0095; Wed,  8 Jul 2026 10:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7065F6B0099; Wed,  8 Jul 2026 10:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F68A6B009B; Wed,  8 Jul 2026 10:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2AF6B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C135D8B89F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:24 +0000 (UTC)
X-FDA: 84965796888.18.4CB0D50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 091464000F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckeOtBFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519883;
	b=Ajhu2rCny8PL1pduumpwJCxQadGxgxGa8Q6o4YEpb6+p6NjXFBNaC14SViYXg8RKrWCiZd
	xNprrjXk0nxiEPInUJ7PH3SP+cfRc7dC3IrKG48SrbZXxoFmoOoFDcPv+tSbJpgJdswgEh
	CtfIp7UhcMU0NVWG1NScL/1LAA8QNbA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ckeOtBFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFyxPJ20nGKU5oJlQlEyooEUxC7eruHMjD4D5VqWTN4=;
	b=ILgUE9tPKai3pNz3aK90Jhhkyf/vK26Cto/a2oL28+j3hsADHMDR3FSGCPir17ZAkIPeKa
	+wtcBJ3dAHOeC0iVYCmhL/cInJNdDaHX5zdXn7KDo+YPgCnAJr/Oi8bKqsbgwNi0UdIR46
	K1AWWE0QP7D65st6olnHAF8a+FTcIfw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5723A43B40;
	Wed,  8 Jul 2026 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A861F00A3A;
	Wed,  8 Jul 2026 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519882;
	bh=tFyxPJ20nGKU5oJlQlEyooEUxC7eruHMjD4D5VqWTN4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ckeOtBFVWD1BusC3wMJcCqaTHmmEoHVgbLMGflu6kKlHozSqdtjnGzjb+7zJJ6VW9
	 VXatpfZhH7LW8uxrhnywjtXc9clRoKAbB0EVZrK1HS/SY+c0KemZnwjlTeEsFH84jR
	 EHlR2ZitN+nlpIq7ZuM6mQyNUKLWaTNi2N7sKIQ7R0RseEEv7tUp0Fa8Z6LH97lhs8
	 +vvd80Nsy3C83H6H/PjuIHWfxiug6bK3hh/G9GT+ml8eB++m4oxmamKJwmHM0XPzTq
	 2e2oCRenybfCBPgg0qnZfUCpbQasLxBDNtCd/WKsHmfAQGoowgExk56GdvNe3nmnNe
	 V5JUngawtF9kg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:10:57 +0200
Subject: [PATCH 02/10] mm: provide free_reserved_pages(), removing x86
 variant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 091464000F
X-Rspam-User: 
X-Stat-Signature: wackt4rk11r7ubkaqi1sp3cw1emu7p5p
X-Rspamd-Server: rspam03
X-HE-Tag: 1783519882-749718
X-HE-Meta: U2FsdGVkX1+0bZLKJUKOY4CaDUILTiBOQjJzNPhPLdf9+9KzbMuEJE+dFc7+V4nmB8OD4LLQo98Pc351LvZI5XfAlxEKXrwfyFzVDH6Y5J+BStWbmb1p1RtJdWap4OxbgIU0Pxr+/U04P6ZkrW2baNyq02XNQ3gTdCq2XNjMIS0ECkMb8N5jRsSp6FUHMVfF+rsV37mWklLZG2diBCQOtZHhWxYoTP/lmBrJ/JNXsoPo/lJ8xa6/ET3WAUGbWaKRrMah0nqYjwJS8dBBlzP0WlmTgAEA0JVJv3FlFxuU3kEWoJcknhN6oJJyWh2kcCTI/tM4QvRMm2wFA2aq7GYBWj0jXbMHPD1ZP9tCVJdg2qAnG+eSS5SkkEZnf7QjSCOjWPalBJmzDpjP1lvXTRQEhffizbh9Vw7wJbnGWqKZjnZgJ+mn72jCEXileTSafFIxOh2uN+oWWAnGec9Hk1j/9k7ry9ppMK58edwcHxeGYxiWdu6QqqLIcCthpXuhwooxxL238lPo/HIMeGbgOATNWPG/kRvW8vqTNhK/K5q4F7BFgA1El2zl/CXn56iOz4J9Tow5llt1k0gZb9DgzBLlSLZAX5psraTnE3ccnSn9QUZuU2la6YT868RqCTVvUKLxPAFuWCzbF+CEx2nYt40MUlKCO6vUNwms9b0kYpcJshEqVYh44Bs67hhyQwuOUhoTvKYVvmCKtmOsZbzOQjZ1ZhF0mUBbppWANz3wnhlvUrfIiERntVpBBMM6hkMorR9/VyRBLiWvLInkrX7VY+jf5NTRE/xF9hXlvFrmBOjVV7xlGqISzXo+vKJSMNGFTom63zRS2IYyeOVuhClQIxN7POPr1QzjmIuPNp6tPbhKyEtqJ2xOLNxVkZTYNuP2urYsc6/nxQSKu7Ep9AnkVAJgESk9dOALsiMX4D+u7cJXTGiFnqLG5yl2JPf5UlGc8wjJwYAIIbCgXh0hDLj+jcl
 UFoNGehS
 apo84KIYC+kHboc61ch8x3C16nP2DYTJKOaSP7rCSOugD3NpNaba856fiiakjRGyThZmmcmeaMe8vqWa9tNIgOUyOUkYbVbPZm7N2exvAmwzR0F1Gh3QRJYZk5gcAwhxy+nTN7ipTnb8ItzNkgavZAvYeksTONEXMILAL6Hs6zTNTqNNCRq5JTShv2BlMpGLj9njLvvkSNdT9fIOWFbw0bNVlEzenKzxsG/Yl3nqL+OmJYLVGjKT8dZCLJPmsRA8SAyR5heuu5uIsRKTS3unbMjTCyIi1/2PT2FdODjBr4eM+eHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's extend free_reserved_page() in page_alloc.c to free_reserved_pages(),
dropping the custom x86 variant. The common-code variant will consume an
order, so adjust the x86 callers accordingly.

Make free_reserved_pages() assume that we are freeing ordinary
high-order pages, just with the special "reserved" flavor. The target
use case for now is freeing vmemmap PMD pages.

Set the refcount directly to 0 (instead of 1) and call
__free_frozen_pages(). Add some kerneldoc. Use a single
adjust_managed_page_count() call.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c |  8 +-------
 include/linux/mm.h    |  8 ++++++--
 mm/page_alloc.c       | 33 ++++++++++++++++++++++++++-------
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 69e36f02a663a..320e742b0bb3f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1000,12 +1000,6 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
-static void free_reserved_pages(struct page *page, unsigned long nr_pages)
-{
-	while (nr_pages--)
-		free_reserved_page(page++);
-}
-
 static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
@@ -1038,7 +1032,7 @@ static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
-			free_reserved_pages(page, nr_pages);
+			free_reserved_pages(page, order);
 		}
 	} else {
 		__free_pages(page, order);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 113e1752548c2..62b261cccf16f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3993,8 +3993,12 @@ extern unsigned long free_reserved_area(void *start, void *end,
 
 extern void adjust_managed_page_count(struct page *page, long count);
 
-/* Free the reserved page into the buddy system, so it gets managed. */
-void free_reserved_page(struct page *page);
+void free_reserved_pages(struct page *page, unsigned int order);
+
+static inline void free_reserved_page(struct page *page)
+{
+	free_reserved_pages(page, 0);
+}
 
 static inline void mark_page_reserved(struct page *page)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a63733dac659e..9311d1f3793ad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6381,15 +6381,34 @@ void adjust_managed_page_count(struct page *page, long count)
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
-void free_reserved_page(struct page *page)
+/**
+ * free_reserved_pages - free reserved pages
+ * @page: First page to free.
+ * @order: The page order to free.
+ *
+ * Free pages allocated through memblock during boot, letting the buddy
+ * manage them from now on.
+ *
+ * @page must be naturally aligned to the order and the order must not
+ * exceed MAX_PAGE_ORDER. All pages must be reserved.
+ */
+void free_reserved_pages(struct page *page, unsigned int order)
 {
-	clear_page_tag_ref(page);
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	adjust_managed_page_count(page, 1);
+	const unsigned long nr_pages = 1UL << order;
+	int i;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(page_to_pfn(page), nr_pages));
+	VM_WARN_ON_ONCE(order > MAX_PAGE_ORDER);
+
+	for (i = 0; i < nr_pages; i++) {
+		clear_page_tag_ref(page + i);
+		ClearPageReserved(page + i);
+		set_page_count(page + i, 0);
+	}
+	adjust_managed_page_count(page, nr_pages);
+	__free_frozen_pages(page, order, FPI_NONE);
 }
-EXPORT_SYMBOL(free_reserved_page);
+EXPORT_SYMBOL(free_reserved_pages);
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {

-- 
2.43.0


