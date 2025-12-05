Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6F4D3748E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1AF76B00A7; Fri,  5 Dec 2025 14:44:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF29B6B00A9; Fri,  5 Dec 2025 14:44:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7F76B00A8; Fri,  5 Dec 2025 14:44:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B99F06B00A6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84DAD160308
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:03 +0000 (UTC)
X-FDA: 84186443166.30.19BED77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9882F20004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gi4MD8No;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963841; a=rsa-sha256;
	cv=none;
	b=JP1+nyh/gzOBX3vqQKlv7ocbCxUpFeS2D81NhQ5qexOhymJjIkMtG4aei+ZNyqztcjFtnA
	N97hO/WPZdZIbSFMd0Ao7x70NfswnqcsQSzrtw5JnJXZSrmL/yvtrK5WW6X599v5K6pyiz
	bzIEN//xs1icFSfBp3S5hH0oZxxXi5M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gi4MD8No;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjtEEnVf5wMMr6Xk4qo1PXLmRSK2SiS7mHl8tLHN8fg=;
	b=QieWjpNZs6h8nbizme+kIzNlBIEomD0v2y8Ssf3lv/7LdGaaYSZ3RM/EgfFYrIQ9FxX5tO
	uSTUygLhj+E9vHqTS9bpWbOE7pMRYOrOZuV/8+V/D1+BYg8DbR/3Txob6HhPfervwmOVHp
	E249Pkl/Vzoyte4dY25Xc4MrN7NUnGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72CCE4333C;
	Fri,  5 Dec 2025 19:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DF7C4CEF1;
	Fri,  5 Dec 2025 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963840;
	bh=lqawaKMvHwfyi4yljLF/OMqkCt81UZ5brr29AJIhMIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gi4MD8NomMzj0O+AMBedHkwGfambz+m0F+Tba2x2erGIDjddTOmm3Kd7kopq8GqVq
	 g5PDE/PqZDT5Y9Xy4gxuIYo8RcsKcO0GKb1LPH41+f7B501vjg9UKiX9WvLI4eYzh1
	 bkzRqWsZ+tB/HWdZEq/0BTBnDdHGeI12T0UxR7pSGE5xacVIClSWk8xouYBc4Ca7YD
	 FMergGKVTT7c1uURvlndM3teOTrqp1TaCUfDwrGx45jPuS6WFNS5Y7QGkwsyOXocbK
	 m+29dX7jr6ssGAQoUyh8DCZstp3cV8t9K2UyXg8Mx0cPdodG6FavpboGPQbb7C4/Nn
	 mEx3zdx/7pU3Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2241EF40072;
	Fri,  5 Dec 2025 14:43:59 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 05 Dec 2025 14:43:59 -0500
X-ME-Sender: <xms:_zUzaSfS--_fGNmWqwJDbEa67LylLakxjlo_JKYpnkJY1lU12THVlw>
    <xme:_zUzadkbFl3wVqHfFI19I1a3fqSE9_bF-6G0JOwVZ1FVj7iMQ8esgmLhVO_gmwIT3
    BGN6A7o0QTPMwVrQnviPzpMZPJws7sMPMxdjJuwostSHi3OjGOV3do>
X-ME-Received: <xmr:_zUzacyQMfX0nrGQDIaL-usFAZVEh7FJYQY_5_SaUffPQAxEzTIbmDNaIKidDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
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
X-ME-Proxy: <xmx:_zUzaYOlOFYdeeZX4MrjqeTcac2Q8vm_XD4XhQZy-zrTI54r6O0tiw>
    <xmx:_zUzaVg0PN_mNac7LtwGASmNr0ufPsODLm5tqf_2ILS-oM3QQ2fAeA>
    <xmx:_zUzaQ-3rMmcx1k2zS5Xj0JWhbtwHCVUqSrm_oQRwUFbTGeVLWVs2A>
    <xmx:_zUzaaK9xIB2GD_bwwiMF0UMKBFYrwG_xBvb1TnfwPf6LlpDx7BZlA>
    <xmx:_zUzaRaCMgh8g-8xcspfDIJx-BQ7UO4tir_Rcs-Yy790nIoictNvG8ZH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:43:58 -0500 (EST)
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
Subject: [PATCH 03/11] mm: Move set/clear_compound_head() to compound_head()
Date: Fri,  5 Dec 2025 19:43:39 +0000
Message-ID: <20251205194351.1646318-4-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4cwxzezpds4ns6o1m7dd4fd476euuprq
X-Rspam-User: 
X-Rspamd-Queue-Id: 9882F20004
X-Rspamd-Server: rspam01
X-HE-Tag: 1764963841-500446
X-HE-Meta: U2FsdGVkX1978CDEkVJxgm6X04ltP3oy5gcZ1skMM7XumujSpZnBA+/F8asdbpU+UA9oG0S/2r/ucAu/O8LIwzRgb8+zX+IZOY3DEvo/fd4nuu54wf3C+E3q0xYU0d5KjfCTFePSVjvi6alu3LmI30d2xRO6EkTxMQqGQ67iUFcDZfETbEUi61nSXDopvcrT2HwzSik9JMa2DTVu5a0ag2f3Hyyg5Ck6Y7LNjdOUjJX8pvLhZGl6R6vL4ZNGuxEydDLq7uUQSktEzTnEWUBkAkYL0S79JTL7uCxfhiNiHwJPqfSNrtie8kJbiMyruVigukO/Ya6RcxpKrypPwxbSxpa078W9QOzn7liWK22glNU/CM8UUnvCwWzxBkG1YHh9VG9ODwb7YqEJMMOKo9uQ1u+AHf5ZlrxsFStx+5DijHACm2YDA0m5fg3JXE+oxX/2D38Wlyrs+DQj0RHfW31InjGDWxWH1Vk1y/QMW59F05f7PaIb7QZYUFw5lBBhGxa5fC2sBvHIvoRkjsVL3Q8sHuMGiQWZpndEhinERslhC9rz/MWstxZBqV95pUgVX5lkkMzdrCf2Kpjy4PNArezhHpBo+GU22pbsC8EFneKKz6e2tqHpwcj1c7TwWjwKDqBwDMHlr0430BQjHzYUSggsNYnjb3Jq2hXQs5GH1PaVJz2ouY5uXUOchH+464njRrq01kYvAFe+5xHhVi/qV97W9EiL5q0fAZRzNVl0TW6SxVf+iIOpuSbr2Z5qZOf2ISAmB89AH7ozcJ2hAFdChrwiF2C5BuYT/Ku2YsNMJGXAkQS6uy0eHh435FHim/+jcEPLXFzP1FF3VQsllD4DDva9R/qcNk8J1hfef+K+2yp3Z4wRoaGxtBOJlY3O0YXhGFTWAVadZd553oFW+8pnpwvWYBVIX/1kx8d/idXD8efrzo+EveTXyWYIXqG85sPKFS92MuTL3/U6vHo6KywioVg
 ZLexxV5K
 0DFBr4Zy1eWQmW2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move set_compound_head() and clear_compound_head() next to
compound_head().

Their logic should match, and keeping them together makes it easier.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 446f89c01a4c..11d9499e5ced 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -290,6 +290,18 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *page,
+					      struct page *head,
+					      unsigned int order)
+{
+	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
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
@@ -865,18 +877,6 @@ static inline bool folio_test_large(const struct folio *folio)
 	return folio_test_head(folio);
 }
 
-static __always_inline void set_compound_head(struct page *page,
-					      struct page *head,
-					      unsigned int order)
-{
-	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
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


