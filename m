Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01254FD8FFD
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C036C6B00C5; Fri, 27 Feb 2026 14:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C926B00C7; Fri, 27 Feb 2026 14:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A326B00C8; Fri, 27 Feb 2026 14:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873786B00C5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 550DD1B817A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:20 +0000 (UTC)
X-FDA: 84491260560.03.EAFB034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4357C140007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tcY8+B1p;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNiK4foKnR/mzFqjupikBWO19R9YsVYf5Dbq/rYnRnQ=;
	b=mUGKH6ce/mDqhb2FYev/NWXhfMhUtsBFY1NRDYjFlTUPog0U+qLj3SJWaEb+RaMOFAjhHm
	vU3Axz8CEIHAG6qmm0ias2a+uwFe7v6yW3gZ2PHrCfmjgpEEPWXqm1ZzUQhPZbxSmCQ7ar
	ztF2XYAwb3PuKboaCdeFu9JAEZBaW2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221398; a=rsa-sha256;
	cv=none;
	b=Fh+EtATICnhxVgA6HB1Z9vrXMLo2Rm2Nn3TywdT98abEwF11fB8sW8lrsJbeSfDzZe/WaU
	PPaYG3hlRvygVpYSSVmKC/dA6o8qYRZ4wpcUCkyW+WLVPpcu8p1GVdjCFvksd64mPDPUrG
	596ZxJNmny+ko5xl4rsJQ320Ksg0ICA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tcY8+B1p;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07D9F44581;
	Fri, 27 Feb 2026 19:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25694C19421;
	Fri, 27 Feb 2026 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221397;
	bh=SAMYtAvGiq2l3siqpeP/HjyvgvsrRuVBB1mTlVx3THc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcY8+B1pcBpmKdlfCS0uOZ512/5KyplcwQlwEN0riGqHbwjNQAx0jMfCuPwb+j7bo
	 QTo7Hn26jsaBCD6x8+xZ3LAkO1InTpbihOC/cpljfElycYpd4ueewY83LtTyrULyhF
	 9Vifg2QibBztU8orJDKm/LDbPjRiW0JDGXR9CADTTGwsi+b3bnNy9+xloQpsq2VNVb
	 1lNLBIhny6cu8Zx0eNxyKG3ykqDSkVFU1KTYiOJVWtmg4Xg7LQcV0d3VC4ikEi6tOM
	 Uv3/BD6OOJdE9kIOm7lAIi5l1pzPT5a/OVOxeLMKCzChMJ1RL0yIYWxctoc1mXy4Jx
	 yVj1KvyY/leoA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 509F8F40068;
	Fri, 27 Feb 2026 14:43:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:43:16 -0500
X-ME-Sender: <xms:1POhaTPYYIx41emnSltkSPqXLs7Hw07GkH2erO2UVreMOcH7aRHXNQ>
    <xme:1POhaXLpLqC3CgEIU3xtszaBhGEElS7OpjSlH1TW8K67YmRAAYihChJIThB26_OZD
    ghRVBh0nz2xziQRiabzH7hwp5sJSk1yvDsYP1IEgYQTv0FZpoNYRjA>
X-ME-Received: <xmr:1POhacaye2j0k2NKv4CmZ5wSqYbQ02TxqLESpFRdQFKAPO59yh6ikDXxZP1KVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:1POhaYlV9F7FZhkhPP5UR7LfiXU6yPyJrPGzwTL6WRDORp1W2i3PAg>
    <xmx:1POhaXZr6H8m-b0joZT-p1OXlbwkGQzpcQX-LIjAPoH-NN7_Jkf5IA>
    <xmx:1POhaQBJlSdzCZ0oSCNa2A_5TTgq1iBBuH7YThh5LrfhqqRLl3vkBA>
    <xmx:1POhadZ8i3JjbDQAlPlYfQHZOXHq8w7pPx_dv5VK1_lw6zxR2VRcIQ>
    <xmx:1POhaUhL3C6uixSlUoBGYAj6w1gryeKqIB1jiI6nvwKAdmF3xLrwUeIM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:15 -0500 (EST)
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
Subject: [PATCHv7 04/18] mm: Move set/clear_compound_head() next to compound_head()
Date: Fri, 27 Feb 2026 19:42:42 +0000
Message-ID: <20260227194302.274384-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6uip8qaiu55goza853raat3q34pxbgw9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4357C140007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772221398-165944
X-HE-Meta: U2FsdGVkX1/fxMOUSzfjbu1kjknKtaw0GWFHdGQoZN5HZdhgnHJ31ENu6BN4ftiWiyUxxQzCdkTizwnbK9QQEicOAHoRPrsJNDY4VDYcty4YZAdR+L2YMf361Q5k6AyhyG43kiyKYyA2EKE7zNPPosC/ZxgcM2jUnSJTPMcfP644ZXvApah2NImLCXt5A8MIDec37PKGnm/RGMcTCFUGfWlZTIjokQn4fu766P/oz7kShzLsbVC+B1tT5Cc7W7arGjlyvHYt9FeBctj/y8Vz65WrgoSUuE9omMt4ZSv5rfUiiTvTPmDPGiJqHlSRv6WCs4qiAsca0fH+a5X3flsbJ7Vdg3vc1Quv9xiDMvOHHo/OmC6aOx3j0M9JF+bwRSCUY3jVEJe4n1x+NRzy1cmQsF8Aoayd44ZPQKbYZ2e1uX0Vj/0fS7Zo8pDZc7nMM4MG5YPRY9mAjEoQ5wQCeDzMy5RDWLEqmNA9MzmzTI5LmaVtwhTsyTRhO6VWy1+yAntVUWrPBUl4aRRcpQxk6/aDJ7ECSV15oDTPJX5pKvLg1pNp0M4BP3QVXf7K0QGryq5Sh8mDJ4fUeEvkZHI81GIkzKlHTwrDXHvj4+gG6CbEZDdfwWFEfend43csb97h+PkRt62wq3R9IcpUUSA5TW4tLz8htxup1e9a4Zj38JL2KPdI0aqwE7isJ7prYEhQz6TpiUFv1r5RODnjWpP5qnb3D46QWi+8p1Bq7W8B0GBfoSCq7Zals7nhW8Rx9mktxgSuo/3VkSmGBv3KAMzNbMayWCYVE86h6jdt2VF0hxrsJbl6SyIVBRXhScSpqCKfLkaYl/xFdBKX32HktS8rDFZpRxVx91O8BsWBWH8FgvOHLUyD8WvYlk82gmwEAYtp7Bbi4hVOudWZYd3EYUTS/cpEjbsBoNQ2XeOvuFUvTr8X/fP0EMVTrUWISW6l/S/QyKJmCppw3TRHUgOPy/dmZ6O
 1jI23hoG
 n7ZStmVsY1ecksRFzbo4vStMSFIYMSU7FRoyfs8uUGYmhomVuHaJfG35tHoEuEFFPxjZhGTsiWAyc9P8SpPbzM1I0MlLBDbZDxObz76zE0uW+Fx1WBXkOKj6U60bBIYHPMGNQbIIVhb0clChF3ByOJZGUYjtsfYV0tTRDZySCt3PWBXhUDRRGxCDGhFoXraMLwrtvzUVFqgy8jOKr8PvXfebVGVJLPDnMJBT96286uSbr7huBsgoHUVrKII8n9H/qP9Xle2Q9qzKl1+FrCdnDeO3x4JVE/MAv56kPaCTXeUpQu/3I47k6tD5XXgezTI8zf9JXxHYFu9Abiuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so
keeping them together makes it easier to verify their logic is
consistent, especially when the encoding changes.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 70c4e43f2d9a..42bf8ed02a29 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -290,6 +290,17 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *tail,
+		const struct page *head, unsigned int order)
+{
+	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
+}
+
+static __always_inline void clear_compound_head(struct page *page)
+{
+	WRITE_ONCE(page->compound_info, 0);
+}
+
 /**
  * page_folio - Converts from page to folio.
  * @p: The page.
@@ -865,17 +876,6 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *tail,
-		const struct page *head, unsigned int order)
-{
-	WRITE_ONCE(tail->compound_info, (unsigned long)head + 1);
-}
-
-static __always_inline void clear_compound_head(struct page *page)
-{
-	WRITE_ONCE(page->compound_info, 0);
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void ClearPageCompound(struct page *page)
 {
-- 
2.51.2


