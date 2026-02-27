Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD4EFD7F9C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F796B00A7; Fri, 27 Feb 2026 14:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BA26B00A8; Fri, 27 Feb 2026 14:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF50C6B00A9; Fri, 27 Feb 2026 14:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE9B26B00A7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DC27BBBCC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:44 +0000 (UTC)
X-FDA: 84491228808.09.869A012
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CD04120006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twtqxl9w;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGHTN3DUUSqL+AyAyhK2RUpMnu3/FhcMOUpN7zTMBQU=;
	b=i1fFvqDUnmDZ4PXciDXXksuKrZZjjI923AK92aKVILEc3pAcpTZUjpAq3tprreq1gkPUwa
	ELgaDLbNqT5GHAB+CeSkmp16r0DN2KhZqzpN9ALohKyRgbTzDV9+GGow1nU658Kw7Uw/h0
	KO+YtB7LaToT8bsGTs1cF1DX0J9Fqm4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=twtqxl9w;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220642; a=rsa-sha256;
	cv=none;
	b=PNxTzW0PtzwivomRidwKARNMMWBoKMw8VNzNpx0tkpqJ7Ku1Fc55JC+sGUuZzwNlPAFt0h
	BJ55aaFJeBoC3nY02MHqOgpHRPoQFBXvVxw8Zwvs3FhM1g30jSKEsrmsCouTc4qK1u6ULv
	Hy4o6pKJlUeKAp7o6rSg5c5C8PcQIb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CC4A44561;
	Fri, 27 Feb 2026 19:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A84C116C6;
	Fri, 27 Feb 2026 19:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220641;
	bh=Qa3n5VKBU/DN+usEuz8+Om7G9sqmqxUGPeiY6zJ/Qrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twtqxl9wczz8diLrFrYNxgeFeytvN4YMaxSDd/cMX902a+pgp5qetAQ/6PVnV/CQm
	 Cll9M9UVTlsAbFWs5BwTvAN+NwC3QC+Z+NOKsyJsoafaP+QrfTjt6Pzc5+g7go7gS+
	 k+uiHtXCTq1isYOJ213RRV8yyIs3jODHMsnClBCIL1BYiMW9y6JM7dnZ/FGhrvEySq
	 A5ajdc2Xrkw6WN1qHpWu2dPTdlgHqIa3QVM0RTKJd15bNbqxRhR7kDVkmp5vHx1zgt
	 RBtyvvoTG1iyRZLZfj2wzO1lZHKvg202vJSLbx1Y40yB41gWgXa+b/USXqk/JrIWLQ
	 V/e4Xpm6aU/Aw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6E0DBF40068;
	Fri, 27 Feb 2026 14:30:39 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:30:39 -0500
X-ME-Sender: <xms:3_ChadvCHZYgu4ElP8zMfhuMRciOJHShA5u69P7IDBw6KGL3WD7n4w>
    <xme:3_ChafrCUYNBan7yhJIdA3KDZkASgxhPm4rhvyKMd4OdNwdlYbTs5F1TU0z1dKiwG
    hB_KHQW-JE4zLMJmke4AUYPhbdh0H27Cwcr8b5QTsNxokM7nmM5wMw>
X-ME-Received: <xmr:3_Chaa6BIueRlqQ1KSPVTvfPcHmAOlT31szbNcCLvcTAMYvENjh_216I7S4nUw>
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
X-ME-Proxy: <xmx:3_ChaVHevhdXivQcseAaeVX2FctwBGXs_5X-Zfkm6HDKqWz_a8R82w>
    <xmx:3_ChaZ5YaK0skCo2vdHE6vp5aNjmWkcz1gmZLtZ-Bzrx6pT9nPbh9Q>
    <xmx:3_ChaQgz_8bi52yOT1KBhYhcg0vhJyGjNKO5FWPluzkOBvjz1bGZfQ>
    <xmx:3_ChaT5SRyp7_xZYUsaceo-lT2rtO10HUqhbfDidI5aypULvE4LshA>
    <xmx:3_ChaZCYcReL99Appy5OfpchsxXbwwYOm-GsYIoey2fqCgjQ8rqG4zRP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:38 -0500 (EST)
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
Subject: [PATCHv7 05/18] riscv/mm: Align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:30:06 +0000
Message-ID: <20260227193030.272078-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7CD04120006
X-Stat-Signature: by85x954shy3h1mcm6aa4cmkzpn9qxim
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772220642-717586
X-HE-Meta: U2FsdGVkX1+4Q8JkPxcpHrU1DwI3n3SysRSyiq0jH5oqowGxfWutRfNjdQE4RVR/InqcQqf1NEHhQRHETX01TjbFGzl5cs4yn4Oxc3TdSnesxjkXyOiGb5D1TSRT8bR2+3VLbvlrVHPLAlCTRQxAffk9kJlHhaMHMrNccuW0AzKLr7ZP4Uf2F3/Bpldf8iQtXuWsYgPHO/Uj+Hs8Mo+i58UH6NU0oCRCzu+mISen9HoKQtA1i71deqeGNflNv8IPVU8Cb9kglyEhGIz/aT54EJRCiSJKazcm8DuTNovQdKiwUnID6CYDlWKHLAMwGCxnLqhRNdFy6RxtgECJJ4j3aO5fRN9NHyTN2V5C4lNHy8+EtQqWGUAAdt/0WgReVsj+QvBTshkHXSmIaW+/KjFXcjpIJIs/GHqDFQKZ4YGlMTCAYwfYTJrteRkadITsdboCHM1OmHdETPZFmN1nSTyJq1qVdxMbowI+1cVDL457EGzSVNfAiCkfCS3v7Hlp9Th3yCNTlzCFqszxzvdtQ6Xw+hQdXxQ3WJrKVLTf5TxlBfNhMA902jzuvdwDRwXJAbqoU+UUClpqe2YqQlFUC8zxrb/XKFuz0zjhPcV1lk5jJwY3Yh/vYiC9pPZ0mODy6yrq4GXFjVswJU4QSo/xdbNNLOPiHFtd+8E5N9bTnjHzb3YCln8IMyCZow0OimEvQW1AhLpeIEt26K5s26KqNtCIddMFIeOYEXWqGJUG5NrQiVhNZhZ4Rlm4Ff7YoZ0FLXJppmYHxZ4F6ktLE+nVWX4zJ/J5iUEyoatscugwLVgSAaRL4eaotcj61xNVJzjdat3A5iPZw8P1zU78+gqk1BmhHFPFZu6IkrH4QXm/8wuZxiPIoMfwc058aKJL/38iDUufO/OJOmDmz4TZ1UX1KhtiHFDcm99wEjx1t92Xj7nPnugerYYzzfTVaKBERgyJPXhxEDS+2hSDFD+N5y493XJ
 luI+/uxD
 9QnlwliLJiswJuvuT7QZVDPj0dT3f8vm5URD3nhN4IVtLWLp88tvGatE2O9lsJHaruKn9uzGQY/KqJt4RzHX2bfcW1EtYAXQH/XrnJK+1XPIgudZ40IK2Qdr6CGnSvQqntmrgSQclCAAwaNJbivzv0v8cLeWOp78LyVEpLeXSS6hGI/RcWdDZYl4Nu4AaKlSbZnPqU2wvtmZ8eOe3Swq/8UAosjnwPwGzy0nI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/riscv/mm/init.c   |  3 ++-
 include/linux/mmzone.h | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 811e03786c56..e8fb2239a0b5 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_init;
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
+				    MAX_FOLIO_VMEMMAP_ALIGN)
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be8ce40b5638..492a5be1090f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -92,6 +92,17 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN \
+	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
+	 is_power_of_2(sizeof(struct page)) ? \
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
-- 
2.51.2


