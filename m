Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 133C7D3748E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E65F6B02CA; Fri,  5 Dec 2025 14:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD836B02CC; Fri,  5 Dec 2025 14:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137D06B02CD; Fri,  5 Dec 2025 14:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00A956B02CA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C046EC02E1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:07 +0000 (UTC)
X-FDA: 84186443334.03.60328CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D98E820011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AgiPtrVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963845; a=rsa-sha256;
	cv=none;
	b=NRrt2NMhzdtyXGuBm4EWU8ZrphPn72nMjWjn6uQ1pDzUCRl+lmsV/B1S7bQtoEt2+mhv1t
	Pib/VKjKJu6wSZKzUDsArzJQlOfeqvzR1TAL/AtR/uycrwVxpFceHE6ab9swPzuymrn2H9
	hRz3mzS9UJ0VZUe7CBEmok2vSYEMiWo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AgiPtrVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGqTgdoyuYM9HwpEddMGONFXA66y50eKfx8h1W+rJz8=;
	b=wxf3hqjOj5NV3k06+iMyQn5jUmu7Yt8P6UCMWPZIVJcJDUltAStM0N9NDtqjm6g3nEzU7r
	zVLc7b/OYDmLy+QxT0eBMDicjLNABQN+5CHb8jOsCWXTBSA8gJh6PUM4yjeH6tYgbusd26
	qJaTpukQbv3+BPfa46UgwZSZPfUYeSY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D89C600C4;
	Fri,  5 Dec 2025 19:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29DAC4CEF1;
	Fri,  5 Dec 2025 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963845;
	bh=erDMk5n25o0/hdJds3iImDUXzd/Rz0LRle34lfHHSXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgiPtrVKgw7k95Ikc5zp7HhewJ5p/J2m5k4+IeaJP+6mFavQ0I75LGCqn/BxgDWW4
	 HFO3qpG2dm3byiiHF3n3tgVzMho4IYIIIpIoCc4IMLLNuVS/EhjT0fa6f5v0YTrpkC
	 PtwNWsqA7VEALqJMPoLf8CjP5RLD2YmuIa+LZPSi7QriXIm84L3KAIYJk3/VxqxGVA
	 88Ddy0fkLXmq8PuXv8Cenc6DInv5+H2Fz7+JUz7c0zGMCnU0DDijVkONaYrQbIxDFt
	 w69u5MwgJeC2EUVgScwAies0cGyWwTy3q+AkhnQWT/0jw+1r7ybv8SxzqtYr9xbk/X
	 9fOUzcXoTO1Pg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 10D4FF40072;
	Fri,  5 Dec 2025 14:44:04 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 05 Dec 2025 14:44:04 -0500
X-ME-Sender: <xms:BDYzaTfAZVornU8Dh7v3mkBRDUWbKaziPLFoLrcSBDgpnqHMr2uXmA>
    <xme:BDYzaanY0i65CHmY49auROa19QrcWk4eesIJskQEEofE8ZHYi8BtIGEuDcVRNNSZM
    RmczDGR6DI-_a220Ey9y-sc0XE097AnIx0bpUur0-X1CNku_MfKMqM>
X-ME-Received: <xmr:BDYzaVzV8EPlSbHnlqX1uB3xYuJEqrblgdgB8MKp1o6xfdr3UbKWwt4ItB6PPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:BDYzadM2AsrpJeV1kJuoPDjiNfQNe3Iugr54GD8SqvM05f0FOgFshA>
    <xmx:BDYzaWjzXJoQilaw2idjK8sXdXDTh-hweYaZ61uUKsh5d2pEyCGBJg>
    <xmx:BDYzad9wBuWugGbRMTXaLSSFjZbxWEc-rFLKH9R30O38utProehEOw>
    <xmx:BDYzaTK7qW4W4wDjWO8Muta5XOxUgOAAzzOlIOu2Mtb29YM9mdmNhA>
    <xmx:BDYzaWbYQa-nwc7Gj3ZFRRKXlKo_OtIK_nBvhue-KKVBwKSyMmAcfaox>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:03 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 06/11] mm/hugetlb: Remove fake head pages
Date: Fri,  5 Dec 2025 19:43:42 +0000
Message-ID: <20251205194351.1646318-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D98E820011
X-Stat-Signature: mdh9eztkfb5winf1i7jhdg43z3w4xi7o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764963845-468177
X-HE-Meta: U2FsdGVkX18FUnMGFrhZ5HwzOivVwQVZa8/74HQndZ7DUMWM+AL3SKJYQkfQLDDS2R+Ko6cOnb7104BG7kiKD7tUokd/XtFMnDFG41RILCm2byRyZcPGxAmAgodgdrsHcMmy4OrsoMXjm/G7e9gVdN1fuB3dhV3gP3qTkIVgOAq9VSdclH8YCJmfIzwoaDonvlg7PRXtkg+7IIM8Hltdl88lwoH5ypO82OV+abkt2Ck8emAck/Y3Eqab6TQKaPs457XnfyLszrYiGTzGUvKfRU72CHAd/tsqkmQbUFNEZhI1p8SQd8In+4KoNwO9si4iSkKpAtaUsL299/zA+a4gp4bqXFOY+waV/yr2Fsb/vXbMRAhyHCuub1drRkPgXRmHOGkbuV1rjhwXTEGnkR/oKrxwqIGVPF1kL4lMjMdyygIk9+rPEISLj4rZj07EdSnhRz5JQHb7xoS9l/qqvHn+bpN6DsVPJr61PYyASzoS00na0urCcroDf9/enLrVLKIYGDSgwWRmkFGmwNM1dP7BZzvzmfOB4aChcuQQsR4SdyikQmE0s/fm6GLceZKc5R3RyxHyiYKsMVG/4kVYeOFx82uIlANo72m7F219fcPWZBbunWuA0wNN30yHl5TcXWEnHeI91FaQPYYLAoVk5u9jbaWwebaAe2lagsZMKuNbzoN7p6tRWzsMAVuhNLEdVSmS1QnzeDivTXik5A8LB6KeVE9Mk4vHFeLT0sWq+HEnUNBVC8lVlI/o8EwUDZadMZzbsQHy3BEs/3o8oCHLJcAqiGOw68GCWuvSNdIIje7Dkk/0g4/IT0GR1mD5/82aOmXj+D7rQPwbM96CMODc2DZKPnNio3MuR+UBNGcneZLKWK0gaMZaSpcDzq+6nCkAodE3FuXdYf81W9wzCCI17mc6rn0VOef6wQFAJJlB/kog4ekfh7KXP0UbbfM2kXXN2MEWre+N9owH5EFrP9ur5Fw
 BLYbV/vI
 2451jTGDR5Wnr2YXhTTbhcc4TpRsLM7f2Nk90SPWc4TMgNGK5gGgzpTU/FoG3n+DUPtQQON41zwSBPdSullfww55gyZiU/lApdV84bogndOkcyZIvaohJHd2RnxA627oPNLVZ+M8LUqpD+T1+8KbghOrYpVav8LM24NV6bJ3raoKm6dZeTa3ysg0NzH84Rn2y1SNPcDVE1ed7hs/sjh6Chh1jocaQeM2uIptq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB optimizes vmemmap memory usage by freeing all but the first page
of vmemmap memory for the huge page and remapping the rest of the pages
to the first one.

This only occurs if the size of the struct page is a power of 2. In
these instances, the compound head position encoding in the tail pages
ensures that all tail pages of the same order are identical, regardless
of the page to which they belong.

This allows for the elimination of fake head pages without significant
memory overhead: a page full of tail struct pages is allocated per
hstate and mapped instead of the page with the head page for all pages
of the given hstate.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/hugetlb.h |  3 +++
 mm/hugetlb_vmemmap.c    | 31 +++++++++++++++++++++++++++----
 mm/hugetlb_vmemmap.h    |  4 ++--
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f..75dd940fda22 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -676,6 +676,9 @@ struct hstate {
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 	char name[HSTATE_NAME_LEN];
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct page *vmemmap_tail;
+#endif
 };
 
 struct cma;
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index f5ee499b8563..2543bdbcae20 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -518,7 +519,24 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
-static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
+static void hugetlb_vmemmap_tail_alloc(struct hstate *h)
+{
+	struct page *p;
+
+	if (h->vmemmap_tail)
+		return;
+
+	h->vmemmap_tail = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!h->vmemmap_tail)
+		return;
+
+	p = page_to_virt(h->vmemmap_tail);
+
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, p, huge_page_order(h));
+}
+
+static int __hugetlb_vmemmap_optimize_folio(struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
@@ -533,6 +551,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
+	if (!h->vmemmap_tail)
+		hugetlb_vmemmap_tail_alloc(h);
+	if (!h->vmemmap_tail)
+		return -ENOMEM;
+
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
@@ -562,7 +585,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
+	vmemmap_tail	= h->vmemmap_tail;
 	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -594,7 +617,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
  * can use folio_test_hugetlb_vmemmap_optimized(@folio) to detect if @folio's
  * vmemmap pages have been optimized.
  */
-void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
+void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
@@ -868,7 +891,7 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 
 static int __init hugetlb_vmemmap_init(void)
 {
-	const struct hstate *h;
+	struct hstate *h;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 18b490825215..f44e40c44a21 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -24,7 +24,7 @@ int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *folio_list,
 					struct list_head *non_hvo_folios);
-void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
+void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
@@ -64,7 +64,7 @@ static inline long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
+static inline void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio)
 {
 }
 
-- 
2.51.2


