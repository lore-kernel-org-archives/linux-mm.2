Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F96FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B836B00AD; Fri, 27 Feb 2026 14:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1775A6B00AE; Fri, 27 Feb 2026 14:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FAC6B00AF; Fri, 27 Feb 2026 14:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1BFC6B00AD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CB9CC2D8B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:52 +0000 (UTC)
X-FDA: 84491229144.04.A2EF09B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1271100013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1ZhwVtL;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3R4OCTjobPVRyxbJyhbrcnnC1qO1GTyTh+w/mF35eOQ=;
	b=8NX51EqK999IlZoykViwWs2aOXQb1A6Khh5xNHLxJOfvOOkI2hscADKqFbiS1GeNWbyUuM
	AJG03ZeDxZpZz0Vhi2dLQ395BdXpPaNyC/Wj68SW2vjL47nPBR4wD9jdg0n2Yw/Ri/u9D4
	IsekzX5cLiTxQ9bS5GmjDG/tMuEoNaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220650; a=rsa-sha256;
	cv=none;
	b=OdLUuy0gP/EGemZMz8un3ZB+wEaqXZqW3Ar4OOz9W23IXOzbAI03ooL6oZECX/cPS4PEgm
	t+zOLcFmQ6zFSrPKzJ95pfEFmaXQ1CR6QzsUNBXls1dK9Prvg7LSflz9QEzT2UuJtYpiMS
	b7YrA3pgZ8CL71N9XbKn5NSQ4z2J0+k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1ZhwVtL;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1761A6183A;
	Fri, 27 Feb 2026 19:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C776BC2BCB0;
	Fri, 27 Feb 2026 19:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220649;
	bh=LOY8VAe/nVKiSQ68uoLiHfmxr3OLz3fuUlP6Bcoz2gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1ZhwVtLshCc6W6VEgRGoWV6cFIDtz977Vfc2/BW6tvFxF1dFTISeQjxvlZ954qvj
	 b3JsdehHvjj4hijceqYU/NkRtD9Pu3cJLuWX3ASuylaBOGdvojc4zCXKzErvG82WQZ
	 t+L7OegVBChNba9wKHjm0dZY0F7ZLjzwh32adaluwtf2VujHmyACunrf/2XLgYqXgw
	 kBakFN9wN8aBUkcaEKisrbYORV3Zb+sh7EqU3ZJXBJKAyPzbiKqgQJ8aipgY/Redwq
	 oNemENGRkExYvIyThUXktknRJ7yLxRqVq3DC9Ogb4jMtLK2ok0iIoqWZqPaATQ5uf1
	 0hrVXJnNwjhfQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id F17EDF40069;
	Fri, 27 Feb 2026 14:30:47 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 14:30:47 -0500
X-ME-Sender: <xms:5_Chaaqkpv2EIL8EFICHL2NYZfyjwfhoDESf_rRtka3Tgru4OcRLNg>
    <xme:5_ChaR3iTUBgLR4mEgSgmDE1xNJfOpGmDzMK665WSpf1noA7SOErXnI2V2nILeGcX
    aj3yK_wxBM9vbt-8Dt64sPZi6HPDBSbMjXQtdJPTdaquFEY5xXpAbg>
X-ME-Received: <xmr:5_ChaZU1ufDjRy-rgKuDfuxyKTkqp11zZKiXbQfMJGUgxnAwQvlJGo46Jz3cvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:5_ChaawBf71MVdQa4M92oz74hMi7YoLxocP7rfthlP-8pI_UlmHIkA>
    <xmx:5_ChaV0o32FS9x1NzNiFK9qVfeAsBOZ6ndYp0uooyFtItoW1p7YeXQ>
    <xmx:5_ChaVtBT4LqmtJ3KuU_a8cgD7VGVLWUNmOwe7loQsDP3LWI4L9q7A>
    <xmx:5_ChaZX9vwaB4qKolrp8XCAda-D9ysmJXv4ZwWi4TalxpirOeqpaXw>
    <xmx:5_ChaZu29sYzerShiej9T6R5-LXrJEbqJnjGAdACqWHJccUQQ-HK2Adv>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:47 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 10/18] mm/hugetlb: Refactor code around vmemmap_walk
Date: Fri, 27 Feb 2026 19:30:11 +0000
Message-ID: <20260227193030.272078-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cxddhroxewpfexsynr1k1smsb9cnrqju
X-Rspam-User: 
X-Rspamd-Queue-Id: B1271100013
X-Rspamd-Server: rspam12
X-HE-Tag: 1772220650-945896
X-HE-Meta: U2FsdGVkX1/XADQgNjO5O8WWk+VhhRkFLj9HQiKjGOjoP/DhxKbfK13bGhmG+h6BoYg42Pa0xvb1r9v4IhHbrs2pcwry83EORIZkXkd0fJ75SBOw8ngPRm757J71930mfzV5aC8+rh9bKxWPeqBkcqIaKS0QRq+r0HcEvxZAQDuubWIn/7v5fKdqyUsqMnxeQEf/4HBd6/r/OHANn1RiMSPM/w1vWji/iKiZfZzF76Pdt+yArPdVuhCUB89AQgKPqC0Klekj7haBDv2krfS3hXBHCxnvvhgJA+/jfKr8A/D6z/qfau2nUc/at/jPv1a4hdedzehIRNFT4c/zCx8FjgpeT4iawD2oToHoYhLnMbZrg5UW46GCPpyWtKiTKyOEFhZXNDjJpN0P0FnaQT0cIIGbYCVdY3OB23aP94dCuHhXgUg8tpB5AT9gtGl+hETp8ng4rmnY90law3eZGr0vbUuVISwF1oX9uNLKjdoBN9T5AgAFVSrpONdrvp8F84LFVeZwqD932GT+vULPI0eZN7FMJv3oijrcYM1RPZmX70ahE67LHEpu4a/bYkxAkGOwxYRwnnX66AVP+iigft3NiDrQePYFpLVqSA0qii5Bgcqa/VzosNhWwQmH1Z0eqGc4hsWR4wOmVfXrtoTSfwDKobPVHAWjJL/wjZCFbPnqLkHb+4wt9EHqhDqJUdc2bRwJUGofhNUUUpKyIfoyXX8JjAMoBFsAn8gM8rYOeZkYLgHJiLG2MrkIjAp5AOAyMQ8MLOOOP1Pkj38+eLVI+kZzeSpY6Q4NLjqlrMIIX9qONy379vhvzVB/ej3/iGcsIU0kuWOu3GPlP9cxp2+Xe2BTR3gTJHxm9rN7U2NuB1shAm3TyBkL28Q0KsZr+87vjK+HPnvrZqHjORBkGkgdNQeo78BCzxXU4fwjjN2sTOQxbZgiNrNfjM3AvuYv/ebXDiNU/UwzlHypCTpcttsgalG
 KrTOaSJu
 5C4MJ/yr4G4EWF2vYXrrGxQsQzNiPNOU7G+QQuWyPZ7/5lu8Cs5/GyyEb2BKj+/h3R+NCbYDj0NJAyIQ7IlU93WUbAaygjy2TFFmedoLHmTL/5bSJsnD3b/qwHc3gXfkbXLgrRYC50kIbNzgzcFPUDEzm13ggkjJWkrmzlNt0WP8TCGLmXUc8QOZcOkrNXqWVF25y/0OjWyApiWNZcQFQj7wZLqs2ixeLfSqOal8aa73pHn3u/v3uLxu2xUkJk2PgLwgeiXctyRPrbrCt0lWc7Vkd1HQDeNcSbUj644C/bc3AVnV/yMX1k7ZTVylwftk/F+ydqikUh58JQv9Je6/E9u+Xng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

To prepare for removing fake head pages, the vmemmap_walk code is being
reworked.

The reuse_page and reuse_addr variables are being eliminated. There will
no longer be an expectation regarding the reuse address in relation to
the operated range. Instead, the caller will provide head and tail
vmemmap pages.

Currently, vmemmap_head and vmemmap_tail are set to the same page, but
this will change in the future.

The only functional change is that __hugetlb_vmemmap_optimize_folio()
will abandon optimization if memory allocation fails.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb_vmemmap.c | 226 +++++++++++++++++--------------------------
 1 file changed, 90 insertions(+), 136 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 935ec5829be9..3628fb5b2a28 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -25,8 +25,8 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @reuse_page:		the page which is reused for the tail vmemmap pages.
- * @reuse_addr:		the virtual address of the @reuse_page page.
+ * @vmemmap_head:	the page to be installed as first in the vmemmap range
+ * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
  * @flags:		used to modify behavior in vmemmap page table walking
@@ -35,11 +35,13 @@
 struct vmemmap_remap_walk {
 	void			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
+
 	unsigned long		nr_walked;
-	struct page		*reuse_page;
-	unsigned long		reuse_addr;
+	struct page		*vmemmap_head;
+	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
+
 /* Skip the TLB flush when we split the PMD */
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
@@ -141,14 +143,7 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 {
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	/*
-	 * The reuse_page is found 'first' in page table walking before
-	 * starting remapping.
-	 */
-	if (!vmemmap_walk->reuse_page)
-		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
-	else
-		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
 	vmemmap_walk->nr_walked++;
 
 	return 0;
@@ -208,18 +203,12 @@ static void free_vmemmap_page_list(struct list_head *list)
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
-	/*
-	 * Remap the tail pages as read-only to catch illegal write operation
-	 * to the tail pages.
-	 */
-	pgprot_t pgprot = PAGE_KERNEL_RO;
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(addr == walk->reuse_addr)) {
-		pgprot = PAGE_KERNEL;
-		list_del(&walk->reuse_page->lru);
+	if (unlikely(walk->nr_walked == 0 && walk->vmemmap_head)) {
+		list_del(&walk->vmemmap_head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -227,53 +216,50 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 * write.
 		 */
 		smp_wmb();
+
+		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+	} else {
+		/*
+		 * Remap the tail pages as read-only to catch illegal write
+		 * operation to the tail pages.
+		 */
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
 	}
 
-	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
-/*
- * How many struct page structs need to be reset. When we reuse the head
- * struct page, the special metadata (e.g. page->flags or page->mapping)
- * cannot copy to the tail struct page structs. The invalid value will be
- * checked in the free_tail_page_prepare(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 4 (one
- * head struct page struct and three tail struct page structs) struct page
- * structs.
- */
-#define NR_RESET_STRUCT_PAGE		4
-
-static inline void reset_struct_pages(struct page *start)
-{
-	struct page *from = start + NR_RESET_STRUCT_PAGE;
-
-	BUILD_BUG_ON(NR_RESET_STRUCT_PAGE * 2 > PAGE_SIZE / sizeof(struct page));
-	memcpy(start, from, sizeof(*from) * NR_RESET_STRUCT_PAGE);
-}
-
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	pgprot_t pgprot = PAGE_KERNEL;
 	struct page *page;
-	void *to;
-
-	BUG_ON(pte_page(ptep_get(pte)) != walk->reuse_page);
+	struct page *from, *to;
 
 	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
 	list_del(&page->lru);
+
+	/*
+	 * Initialize tail pages in the newly allocated vmemmap page.
+	 *
+	 * There is folio-scope metadata that is encoded in the first few
+	 * tail pages.
+	 *
+	 * Use the value last tail page in the page with the head page
+	 * to initialize the rest of tail pages.
+	 */
+	from = compound_head((struct page *)addr) +
+		PAGE_SIZE / sizeof(struct page) - 1;
 	to = page_to_virt(page);
-	copy_page(to, (void *)walk->reuse_addr);
-	reset_struct_pages(to);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++)
+		*to = *from;
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
 }
 
 /**
@@ -283,33 +269,28 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
  *             to remap.
  * @end:       end address of the vmemmap virtual address range that we want to
  *             remap.
- * @reuse:     reuse address.
- *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end,
-			       unsigned long reuse)
+static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
 		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 /**
  * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
- *			to the page which @reuse is mapped to, then free vmemmap
- *			which the range are mapped to.
+ *			to use @vmemmap_head/tail, then free vmemmap which
+ *			the range are mapped to.
  * @start:	start address of the vmemmap virtual address range that we want
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
+ * @vmemmap_head: the page to be installed as first in the vmemmap range
+ * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
@@ -317,69 +298,38 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      unsigned long reuse,
+			      struct page *vmemmap_head,
+			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.reuse_addr	= reuse,
+		.vmemmap_head	= vmemmap_head,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
-	int nid = page_to_nid((struct page *)reuse);
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+
+	ret = vmemmap_remap_range(start, end, &walk);
+	if (!ret || !walk.nr_walked)
+		return ret;
+
+	end = start + walk.nr_walked * PAGE_SIZE;
 
 	/*
-	 * Allocate a new head vmemmap page to avoid breaking a contiguous
-	 * block of struct page memory when freeing it back to page allocator
-	 * in free_vmemmap_page_list(). This will allow the likely contiguous
-	 * struct page backing memory to be kept contiguous and allowing for
-	 * more allocations of hugepages. Fallback to the currently
-	 * mapped head page in case should it fail to allocate.
+	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
+	 * call which failed.  These are pages which were removed from
+	 * the vmemmap. They will be restored in the following call.
 	 */
-	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
-	if (walk.reuse_page) {
-		copy_page(page_to_virt(walk.reuse_page),
-			  (void *)walk.reuse_addr);
-		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		memmap_pages_add(1);
-	}
+	walk = (struct vmemmap_remap_walk) {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= 0,
+	};
 
-	/*
-	 * In order to make remapping routine most efficient for the huge pages,
-	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
-	 *
-	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
-	 *   should be continuous.
-	 * - The @reuse address is part of the range [@reuse, @end) that we are
-	 *   walking which is passed to vmemmap_remap_range().
-	 * - The @reuse address is the first in the complete range.
-	 *
-	 * So we need to make sure that @start and @reuse meet the above rules.
-	 */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	if (ret && walk.nr_walked) {
-		end = reuse + walk.nr_walked * PAGE_SIZE;
-		/*
-		 * vmemmap_pages contains pages from the previous
-		 * vmemmap_remap_range call which failed.  These
-		 * are pages which were removed from the vmemmap.
-		 * They will be restored in the following call.
-		 */
-		walk = (struct vmemmap_remap_walk) {
-			.remap_pte	= vmemmap_restore_pte,
-			.reuse_addr	= reuse,
-			.vmemmap_pages	= vmemmap_pages,
-			.flags		= 0,
-		};
-
-		vmemmap_remap_range(reuse, end, &walk);
-	}
+	vmemmap_remap_range(start, end, &walk);
 
 	return ret;
 }
@@ -416,29 +366,24 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse, unsigned long flags)
+			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
-		.reuse_addr	= reuse,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
 	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
@@ -455,8 +400,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -467,18 +411,18 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
 		synchronize_rcu();
 
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
+
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator, and
-	 * the range is mapped to the page which @vmemmap_reuse is mapped to.
+	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
 	if (!ret) {
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
@@ -566,9 +510,9 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	int ret = 0;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
+	struct page *vmemmap_head, *vmemmap_tail;
+	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -593,18 +537,30 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
+	nid = folio_nid(folio);
+	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+	if (!vmemmap_head) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	copy_page(page_to_virt(vmemmap_head), folio);
+	list_add(&vmemmap_head->lru, vmemmap_pages);
+	memmap_pages_add(1);
+
+	vmemmap_tail	= vmemmap_head;
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
-	 * to the page which @vmemmap_reuse is mapped to.  Add pages previously
-	 * mapping the range to vmemmap_pages list so that they can be freed by
-	 * the caller.
+	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
+	 * Add pages previously mapping the range to vmemmap_pages list so that
+	 * they can be freed by the caller.
 	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
+	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
+				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
+out:
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 		folio_clear_hugetlb_vmemmap_optimized(folio);
@@ -633,21 +589,19 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 
 static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
 {
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
+	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
 	 * @vmemmap_end]
 	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
+	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
 static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
-- 
2.51.2


