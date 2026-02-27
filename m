Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A9FFD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0BD6B00DC; Fri, 27 Feb 2026 14:43:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BA56B00DB; Fri, 27 Feb 2026 14:43:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745006B00DC; Fri, 27 Feb 2026 14:43:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 53E006B00D9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EAB65B2E6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:37 +0000 (UTC)
X-FDA: 84491261274.12.9BC49DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11B7A120013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qV1qc5k2;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XOk9plGhk/cgTnCcz5EBmiBCnMN9CNw2pw2wcV3WY0=;
	b=FmsnNRp2jTAHQlwERED1+wfepgywOXQRtjUsck8JZFQNmCunvqw6e1f006QV6Sk53fe4qK
	aGZqoxIXoYQBqO5MvsHudTRDtEHcw9gP6epIpZJtzSvXw/4bRuokC1XoouM9AzRSmx92gq
	q5SwJtuBfcy9Q14g7cxMgoyfdwtpFCk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qV1qc5k2;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221415; a=rsa-sha256;
	cv=none;
	b=R3/i4dMGtUd4/5dWiIoYMSlVjOwvyUbJZwGzqa3Xe9DeBFvSgngGVrxzF8gc66uO9A6AS9
	sBsWf8TvvFnX3hnS3ujgH+OTxVPzis70jPaACVHz+wpkvolDPTOMV/kv745Pobl1WY4jLP
	m8QM4qimrrjLzK1huV36mjuk3MhAiJc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4393C441FB;
	Fri, 27 Feb 2026 19:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFBCC4AF09;
	Fri, 27 Feb 2026 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221414;
	bh=FHdzeRKulPcy6fiq+UUCtu6gFm6WIXAqf8YglnUe5co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV1qc5k2pqXUopcARZPEyR9zjoSeiAqKYKT2cL3lmovASljai4n+Ph4u2XTpNRzkN
	 /c9j6PptnumUVPBylAxmy1BlWZqk7IxB8MMHAziP3Qo/sfxaBN3Oa1jc1iWY3gF1cE
	 mGWSqJQ+m/P7/9cnZNarq9GlxrAEWC0li8NTJ9PIWa2mNa5DHTIqwZK9ADfO9lf+PI
	 EyXV8OOW8abx+GMij/kCjJwWaJmW27hbtAcSu8K7jIE6GsCsDmjvXyXDWnNJEANAVN
	 6gsQ07hAaYu/0+/MVc3subQGzHef4hec4heFE7x71FTXq+FFF7JBhSipeY73U2IWVw
	 x0gQiu6MQqc2Q==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6C577F40068;
	Fri, 27 Feb 2026 14:43:32 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:43:32 -0500
X-ME-Sender: <xms:5POhaWft2Z4hNMgdKH-WvEt06V_ySuhI88_10pmYGOt1VXp3vem3mQ>
    <xme:5POhaZaouepT4twhJM4oFKGeiz4qcb8rMiDepWwNjwnpiEZpwjh_7cOZPbXnCsbAz
    uNSU4w5R2Rn5FfF-vl2DGJf--bPMPesmv9AfkbmFU2uWBnJMZ-YMpI>
X-ME-Received: <xmr:5POhaRpteTqqn0tRHifEiRlxojYOQ-AFQaWyHCe_6-8FogWx4w69m5LOAiZKwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
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
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:5POhaU0j1FoiFXjb4FDCf3_iHuq1E1IiTM4SAnrJirJhjsszj6qbcg>
    <xmx:5POhaeofwXlbs3T5hVHwocrRjaSJkZbhIfhEjK7LjFANz8FdtwFB5Q>
    <xmx:5POhaWRW6i03tA2446PryzOTtzbG7IJ_oAmFyYsnJVJB9cVwVvZZ-Q>
    <xmx:5POhaWoI-p5ajUv4Cb5_Z-JMPmieNc5amNRBDKdy4YEHiEugCUapKw>
    <xmx:5POhaUyxxG_bSb5m-F8feWcYLH7uI8dYZolnRb819cVXuRYJQ6nq54pR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:31 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [PATCHv7 14/18] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Fri, 27 Feb 2026 19:42:52 +0000
Message-ID: <20260227194302.274384-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 11B7A120013
X-Stat-Signature: ntj3upnhnmut1azuajrym5fmdgo6xsde
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772221414-634225
X-HE-Meta: U2FsdGVkX18sY5rnS76gnTHmedtZk9UT0/IM0w22w+U4tgfU0USvYLKodP3VExi9NDpOWrflygpekDtBAVHZVsfFaiDJJhO5GUWw+d/ERldNmtkGec9PMqfOM3vbXSiRdO/HecPFVdW1AZQIPz+MYJsd5pcF4e9r+7d2V/6WRYsIw4/ydwBA31dsUELhOt4crwcSKhVQoF7hYMRIVwLNC2a1vF2oSplA1hEXPMcVMg/wd5oW++LkcKcgJbTou0fVFM9oxgJ+rMDOPe7WcQcUVGX4L9eUbfsoU3iO2c2rGnUsJG76gfzMQj3oBLpr+HZ2StN8BrE/6uQt0TNQjEq8SlSPOEwkqGtD9Td5Cvpcm2gv8F+Xn9MY7HVKzZHsWf82t4GlHqfH6rLSupJwfkeHo2SetylzEBhLYniV6Q2/XqjkELCz6gZD3hQWEtajVT3JcBZv+WRVqB4pS41CRNdb5w/Ga2mJj+dj71Uj39+7cg30/q539m0TaUnmzryUFWgT3skEaBrdXkZG7jWlYMkE+M6cOiWAjsMY7joZszMjrxTCf/gcwfg1RO2PAxsfibKRGCjNLrHzuElyZ/9VsxV457F/ndym+E6jWTSTqnm3BZ+dx4Agh2wHsNlZKi2ua0QXHqKCICom/Hn7TR9i41gZFoKo3ZisqQskVGvBL9ACr7BX672+5XiP+acV3p6rIpH3JBuPCcRMYVKoLckFViLO6YD+XskiWFYC8cNk4fN4LM1/R/7AdUYwuzOyyz1Oe5zW/zqquD/vqXr9kXncThbowLB6cZM1WS6yjVqH+MkrlHGIdC6C5JSnH2zlXMJymqN1PaE6l9q5h6eDi4Xawaw1yN4FMXMUPlD5U8X68glVXDbk8iDzSE0dxSUQ5JjD4054TJHOQLkNnsi39p5pqkzSOPl2NI81Lnc77OxA3oErd9J2TH6tEl/yEdstTDBFUcea0zCuEopZAW7RiERhMZK
 Qmt9J3bq
 nuHVnP2vIHRLMqU5ExFegJRHeeBQS1NNcp9hkaQLycP4965boOu/3LkDZ5LSatgKZvp5Cx25zqFLUiad9lt4jD5xKfrDA5HkJe9hofMGVinZEDRZsFYqNeRd+WshP8lMhKgatK5ZDXlc4UgrsDC7umlRcuDMIRfEWQfwoCB7ylAryq/F+loNDmuqPafQthNaSolSB2dN7ioECVUGMeyp7FWxeTPJujFOnfjUbC1LDkzdAH3qFMfntX7CA0wbAPfUCtBSOPU4OSkOQ+BRoYSTZizuYBN6m8IZD5eXAzOg97/58lqgTqW2p8pffHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
prevent a race between HVO remapping and page_ref_add_unless(). The
race could occur when a speculative PFN walker tried to modify the
refcount on a struct page that was in the process of being remapped
to a fake head.

With fake heads eliminated, page_ref_add_unless() no longer needs RCU
protection.

Remove the flag and synchronize_rcu() calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 92330f172eb7..fd1d5d5d12b4 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -47,8 +47,6 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
-/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
-#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -409,9 +407,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -444,7 +439,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -467,14 +462,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
-			/* only need to synchronize_rcu() once for each batch */
-			flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
-
 			if (ret)
 				break;
 			restored++;
@@ -554,8 +546,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -613,7 +603,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -641,7 +631,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -694,8 +684,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


