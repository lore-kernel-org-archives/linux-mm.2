Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F6BC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3F66B00C7; Thu, 16 Jul 2026 10:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D0D6B00C8; Thu, 16 Jul 2026 10:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11BEF6B00C9; Thu, 16 Jul 2026 10:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCFCE6B00C7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6646AA0057
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:31 +0000 (UTC)
X-FDA: 84994928382.26.017032A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C17C0160005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVucWdgV;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lX1TFiP6xIbjy9evrHNZox00I5e7bkCckKcJldvVME4=;
	b=U+qWhst32V9A9ltKX6voWQ1PAhxMsVDsVKuqstBFn8moyZJeb++8a75PBgPkEoiyHG7QRB
	OygzKNwDueO7EJeZ+OAH5lqZiAv1eyJ45Jfa0jPTdFjmUAztJH/b/lKvCQ7RllZ9q3yZUx
	QbMRy9j9gmxzHSZH30Yu0iKV6zFsP24=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVucWdgV;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213489;
	b=ifFWwGdgRqJncAF2FAijRClhu9/xFFTO6v6Fj7BtLGLLajiz4r9jYCz8S0nvAtSkrBTOTY
	4Eqnw0WMfZpMCwXBapzittfYwzl959GjOKm/kuSCEKxcvcwMbTRYLP0pI0rCQ3wOfvFg2d
	dtYuw1kUovPSt1K3YZW83NtluGlH2FY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6370F600B1;
	Thu, 16 Jul 2026 14:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE771F00A3E;
	Thu, 16 Jul 2026 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213489;
	bh=lX1TFiP6xIbjy9evrHNZox00I5e7bkCckKcJldvVME4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MVucWdgVB3uHkthYYg4NX8x7GsFBKVscGgVa3g/uHHXEAeYf8FperTLXsPRKNBKQI
	 LS3dPrUJ+oFBauuHY6ef3I8QQjvOJTbNW8vccNpP5NVIMJy20MooRkImJnPP05FWKf
	 CIp+s3x3F1p7sEeFYDWskJJ29o/iW6cB90NVqln618zouzDsORVOkljdc0vz90fGW3
	 CNNJEW8dY782Is74iDs02CzWGU5EfZUYJUrZ5xtYYAfLnk3IkN0UhUyUzk3NF73C2T
	 wFLu1i0M9T6BMeh8DKIBHFtzPgPuMJDyhVi5QtsgC6iM6bAd3SIpxnp0onizUfxkLc
	 7YZV8IDYnrf2A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:01 +0200
Subject: [PATCH v2 02/10] mm: provide free_reserved_pages(), removing x86
 variant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-2-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C17C0160005
X-Stat-Signature: 9bwh4zeqqubst51i8i5iit7f894df753
X-HE-Tag: 1784213489-890005
X-HE-Meta: U2FsdGVkX1/96bZxvXRVIB/qO9H3YgC5zjLZHiuOELQqtgR6iTOYq/DB73Trc9apm+CkLSDkKMaKnPUJ7GjdmYtylaZLn5iFO0w6KKIA/QQHRhlSabi1EEkVdQ+6AVYCsyyDOjZ69oXzMYf1JlRRz3ngiScD+h8RDm+Em3uuQs7AGex5AHfJsy3GCEf8ruLS8EY9aDCM5Iwcp+PShVhk/6kfvdhRyxDxPmAcxtgmq/lVzO12NUYWdb8qCv3n8/0YkaOhV69pY3YlG4Qx/AfUwwbTuztGTA49fmcpSmyuUjk65mG+8N/GXsyvRGGrwd1R1+DHNu1Z6UyR0OP4rAaDtrWAv/c4A36HiDqMPsb8gBwNfysapzSzN5MnKjg5504fj+WZC0zGj0LC499V9pKfvsxkwbFIoPr+GHHL64vl2cquTy9NO4y9Jnb3mzhXV0kAe6HWZeBC6EhJfudO4k8RQp0yXV13mTrPQsBgvl+VfArLfcM76ANFdNLk65LCfqPO5Qkq8jrIp4+gluiptLA3NXQlHfxkS1i78ybdTU+RU/CTD6XKEMjKQFih/+ck2m66ykyzWRffNYjRg5U8DwnnH1Nra5i1eIbShje84oE1R8xLVYcae05YvNsFt6o/LbjXCljbvy7XzGCtK2+PI/ZCLHGht7No8MgWAXfk0gHMUrDTfM1hxYn1wdTiYzrEdwNuBMqsq7A02TIX5Fs70aiH/2bdmFC3+VvUDnszAkeYceghOYGklg0JcmdOw7zbi61efhztrmoh8zScCnI1f/oUn6wS4Sken0LinLBXkpMTymsUok42JcoJww/jCWVJDc83kKRcgEc+e5LmKYjXJdcj9BuqC7VqEvd0gonkQTuJ+81GZ3m2Cv57z7bd2hY+afhrWz2IUej/5U1QdWintRvDEW/mIAjKOnSE8vx6iqqYn20TliCFRYTnNg9Oi2zoMO7kRycDXH0jrRerFaRPXnz
 scXwLAiL
 NEapdzfGRXZvhCE1/n5xtUvpZRpjsot3I8y8UqAhTNxCcV5a2+bbyv30DBAggijHneZ14asmEyxOCBshkRt7at+QJDEtvLq6DBYlRy7zhaUGosDttAfFBTwYNsQj0IJj1gDtyjZAnWo52IuUN+rlP/3N53tcx7UaAkTi23cN5oaKdezhK1twZYk/obDakWhyJLlxXiEChgmUrmZYfyZzeb5vvS95Zb8zw1kS13koKY41aXA7eEGU1wLRjKwrpPdHHVe5xrupJy5sgNHYvcpMrEl8wvZgVFyZJc4e6
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
__free_frozen_pages(). Set the page count to 0 before clearing
PG_reserved, so someone checking PG_reserved (and not finding it set)
to then try grabbing a ref would not suddenly have that ref be dropped.
That is arguably cleaner and safer than the old way of doing it.

Add some kerneldoc. Use a single adjust_managed_page_count() call.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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
index a63733dac659e..2e17243ff604f 100644
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
+		set_page_count(page + i, 0);
+		ClearPageReserved(page + i);
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


