Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89769EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED4986B00CE; Sun,  5 Apr 2026 08:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85526B00CF; Sun,  5 Apr 2026 08:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AF76B00D0; Sun,  5 Apr 2026 08:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8BDE6B00CE
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97BB4BC8A5
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:54 +0000 (UTC)
X-FDA: 84624501948.14.9BBA4A4
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF646C0003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MQ1bkvCo;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A80UjlR159hWaMO6LOhQ/IhxwfIv1wi1/ZVyLQIlI8g=;
	b=iN07nmSbkos5OF0wr1fmUaCBdyyiE57li19KWwPsb/TYy1z3ulCVD22p7ofQxlxWz/dXJI
	ha8QyP5u0UnO1uKjPsx5PcsTVgoa1lNy0v8B3P5iCK7ndvNahG83VmVcxgM/hu5odwxXwo
	NjRMZHHOkwqYbdDvylivRuCAWyJpdVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393812; a=rsa-sha256;
	cv=none;
	b=h5sKBTnMOYllO9fYbndv+M7g6xANWBEoPkywogFFxbEM7gMDgPzdRNw4jmzy7gb9O+N1sA
	YJp/61qKJYTK15538Nd0KIcf55j3jbpNYdfoY/DwgCogovrFxomD5UvWCzYOsSqYedxevx
	VkhpBLgGz5KelKtzv3nIfhJgD9ytULk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MQ1bkvCo;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so2885725a91.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393812; x=1775998612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A80UjlR159hWaMO6LOhQ/IhxwfIv1wi1/ZVyLQIlI8g=;
        b=MQ1bkvCooqxJUuxKbVVU3aw1dDDnveIbitmBD+LxmNiLENuFWcE1CHKsQWFqtWSOA5
         jB0//KdMiK8Db7oDd4rCvoLshiymh9G7B5cihPMQbTpy4WYp5roJAianl3zwn76QQGeR
         VL9lNuIQACYK1i9ar0bcRRaM4qm95U26+TIFxY+cTDSnjGvCpmgdJVrpxLp3AGwuvmRr
         BpIFF14SFsi8j5p+AgrjZorl0KKUNOpf52eljsNHxcZEJLhm4sfhTYqkKqfXop2CM29F
         H7oBzU93chhuHYGoVpSgR6w87eYBi924EYbCWyZmdTnspvkwUq87qZlgVsWwErKKhdhD
         wCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393812; x=1775998612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A80UjlR159hWaMO6LOhQ/IhxwfIv1wi1/ZVyLQIlI8g=;
        b=jSPAHJnZ79h17zriUI2YXOjhDZ+n7MOmmSkZThpk2suEwckFnGvn5wYcKEi9eqs8Z7
         FB9HfXWKRBBnsNrH+6+b9chEJsNKvXIlYPk7+9nZ4tOvrLyce5bD/Sybb4rXqt5e+tF+
         Sg/iOVELSGfBYpn5vWCTiO1rLUA5SQ4DOFZmkSR6SE8c+WHKJK3jnQNsjsjl3Up7B8XZ
         THw9IsT0HgI6JwIkDwNdZWpP3yeY4b14Uxol8VeCVg64Te4Xp6QH/Swa21XvWnlYml4f
         PvY6FWHB+Vxy8txexiB3h3aUVKMyJUGhUoNr98L91D6RMYwBpCA9zSzw/DCtCC79x8cr
         eCUg==
X-Forwarded-Encrypted: i=1; AJvYcCUMpNyQ95IFAYc/3FPou5QRig5+qQvRkaO1901NA6NN6x/Vxhm3/JM/9CUSEeivzCT0MNgoB/SdKA==@kvack.org
X-Gm-Message-State: AOJu0YwvsC/44UphaYgf4fqRyd4fENWraD0zEtPWi7UYxbkrvqmUc076
	TaqrhtvVpCwVnAP7oq8xfGfqDoLlQER0yz3k/P93yEFRmoE8Svat/tyElQWhreAw+/0=
X-Gm-Gg: AeBDieuO+2R6H12n/JjzhWH71wCZAfaMRJrVzicHEBMwSgLwNZAvSrm9nx/YiUufSzn
	L5l3KT3ddbpYt4/mN4m9dOxmalb5g37zjyZZOnQ/2T5GuKhKSoVnb/cbEkMOZ5u+O+8DEa9Sr88
	pQRr8bDbaXAUHz5Z1VnW/0o9iA2G2QegkHgF1hEHjOC7huCDhbRfF3I16E9O7RgP1Wp5dOOfZYr
	dVBwOgU1gO2ly0GzQUlQI3bUstgdTFN4VQE+cdvrFXps6N2I9Rn7uicQoygMxE1SS86/e8RkKIu
	D7etspyt/rgHrqAgCe3XnxW0trqeydWrSjgk5DM1lntkryd9MFtQXNk3DQDx2X5VRC6ANTD7xZm
	8D6fLgAeHWbaevZ/lZ/sDsF9/yh70N1BLhAhrkrqsTAodRUhcg6pmGOThPVUScnvTPcsA9JTP4n
	aw2YDmcqH/us/pA4IutsyH+SuWRX87mwkO7fN1qTUYxKw=
X-Received: by 2002:a17:90b:3889:b0:34c:2db6:578f with SMTP id 98e67ed59e1d1-35de691abfcmr8431895a91.19.1775393811585;
        Sun, 05 Apr 2026 05:56:51 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:51 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 32/49] mm/sparse-vmemmap: consolidate shared tail page allocation
Date: Sun,  5 Apr 2026 20:52:23 +0800
Message-Id: <20260405125240.2558577-33-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: seywbjpjxk4bk3fgw9c5s36ygpxkoh96
X-Rspamd-Queue-Id: CF646C0003
X-Rspam-User: 
X-HE-Tag: 1775393812-959664
X-HE-Meta: U2FsdGVkX18TNPhpyVbeIuXHpcdixKih3YCIZawrp7McOdeKK4AQmYrA+cGvsYOTSO2T6ln3WGjHSOuINuO8IzE5fT2ImagppG5nH8jusvvm4g2FYMykHvWf/jWXPCHPy5ZDtk+amELcdg5HCxL5aIvocG+8yMjCkBROfSoekv6lHR/oYmkyAZ90f8zYi8Gg0hUIeEYh3YKP4iVkeiPwalMe7x/CeYvTAHajr7FKI5SDMyLyFCQt33ym6pFhIuLFsDXJ5oMSFPWtqFhtICd8LjDRJgPqMcHq1HlihZRSoyfSxPJGUQOMctPTKOCk0rjzGLjqFlw1P7JJAz79Exy5HuDF7mMHlmRu+TG7zde59V0MAK9IMOd88EVCsg8pu2EvlIzmxTmHr5jDUkIbsDScDVjY/snd7OAzdZpewc23VFMQMj6ZQwKzoBhU1HkfebnzFtHdr3h0tciIosZcsEl47zERvgCDqgPT3KJrV+TBExQSGXUPEx/5cPivGA0/GQJsFoQf4wvrpPoVhQyJ2Budp61uP+stEYbPmngZ32RsGvF9oe1USqUcPsLpKteHmIlTMjfMOdXwYuFYo7aGWJ/54/Vu9oHv0JjBtlYhpBoiuGrkbotMEA1V0QZR8QpzMKm9/q2y+/Hfclktgj/fxb1v9a7WF5ImuFJdIxmpQqo6iz4/Bfbel2Q/nz05GOFxUjhSdvNOwKP/RTFPdpu9qP5kDpH878EExyThhBcM7tuabTAWpv3GgDDhGfOYXkH+ZcNzt1wYK5x59tGCRkm5usqNzFki49m20sff8x9WWZqs3EGQHex5ZWPH0yMOQKhCBH7J7zuCcc1P+uWIQgWfxafb81HjRcZpBKY/RiRtR22+42B3DpoVlq2o26iRvSogFe1hBfW0MV/TrQZmbHXHAegW8/ZDFLSbCF4mtQd5VZ4qmr3Xnhyo5kg3HHdHvOAigKM6Vo6TI1N2HmvuafkLQxx
 Uc3jIxRX
 l2qk7SCuxCMnVg0F0O1Jr1NMm9a2G3fTvba/CT1WoQlA+6TA/deSA2DvXgK1s11HqJs/IY8KgXBnTh0UgoOEgBltqXMv075QZ1UjWx/2SvQ7xhAt+Fkc5nAUc18Ot8oXfnbKILb9VBe5UhOMShHvM2vEin0rMMsJBLVWwRE6kvLN7S71YNQFgXpy8zdTfVdKUeG13VVAVQPOkFeEDr+RzY3TCKuFXBnhuxov8Udz4xg50yAqXrXagWBYaVojIox4+1l4bGcPlW6auBbU7SPjQEUxmT4ZLP/TUE3fJRV+zJwhecAFr/69aLiOqwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, both HugeTLB and sparse-vmemmap have their own logic to get
or allocate the shared tail page for vmemmap optimization. The HugeTLB
version handles runtime concurrency using cmpxchg, while the
sparse-vmemmap version (used only at boot time) was simpler.

This patch unifies them into a single function in mm/sparse-vmemmap.c.

The new function of vmemmap_shared_tail_page() is introduced: it returns
the shared page frame used to map the tail vmemmap pages of a compound
page.

Furthermore, vmemmap_alloc_block_zero() is used as a safe allocation
method for both situations:

1. It calls alloc_pages_node() (via vmemmap_alloc_block()) when slab is
   available.

2. It falls back to bootmem allocation during early boot, making the function
   suitable for use in both early boot (sparse-vmemmap init) and runtime
   (HugeTLB HVO) contexts.

This reduces code duplication and ensures consistent behavior.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h   |  1 +
 mm/hugetlb_vmemmap.c | 28 +---------------------------
 mm/sparse-vmemmap.c  | 42 +++++++++++++++++++++---------------------
 3 files changed, 23 insertions(+), 48 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 93e447468131..15841829b7eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4880,6 +4880,7 @@ int vmemmap_populate(unsigned long start, unsigned long end, int node,
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a190b9b94346..a7ea98fcc18e 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -493,32 +493,6 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
-static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	const unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
-	struct page *tail, *p;
-	int node = zone_to_nid(zone);
-
-	tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	if (likely(tail))
-		return tail;
-
-	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
-	if (!tail)
-		return NULL;
-
-	p = page_to_virt(tail);
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
-		__free_page(tail);
-		tail = READ_ONCE(zone->vmemmap_tails[idx]);
-	}
-
-	return tail;
-}
-
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -535,7 +509,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		return ret;
 
 	nid = folio_nid(folio);
-	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	vmemmap_tail = vmemmap_shared_tail_page(h->order, folio_zone(folio));
 	if (!vmemmap_tail)
 		return -ENOMEM;
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index c35d912a1fef..309d935fb05e 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -143,8 +143,6 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
-
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
@@ -160,8 +158,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 			unsigned long pfn = page_to_pfn((struct page *)addr);
 			const struct mem_section *ms = __pfn_to_section(pfn);
 
-			page = vmemmap_get_tail(section_order(ms),
-						pfn_to_zone(pfn, node));
+			page = vmemmap_shared_tail_page(section_order(ms),
+							pfn_to_zone(pfn, node));
 			if (!page)
 				return NULL;
 			ptpfn = page_to_pfn(page);
@@ -338,32 +336,34 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
+	void *addr;
+	struct page *page;
+	unsigned int idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
 
-	if (WARN_ON_ONCE(order < OPTIMIZABLE_FOLIO_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+	if (WARN_ON_ONCE(idx >= ARRAY_SIZE(zone->vmemmap_tails)))
 		return NULL;
 
-	idx = order - OPTIMIZABLE_FOLIO_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
+	page = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(page))
+		return page;
 
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
+	addr = vmemmap_alloc_block_zero(PAGE_SIZE, zone_to_nid(zone));
+	if (!addr)
 		return NULL;
+
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
+		init_compound_tail((struct page *)addr + i, NULL, order, zone);
 
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
+	page = virt_to_page(addr);
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
+		VM_BUG_ON(!slab_is_available());
+		__free_page(page);
+		page = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
 
-	return tail;
+	return page;
 }
 
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-- 
2.20.1


