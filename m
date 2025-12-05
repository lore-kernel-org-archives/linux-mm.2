Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F33ED3748E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B24E6B02C7; Fri,  5 Dec 2025 14:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6666B02C8; Fri,  5 Dec 2025 14:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CBA6B02C9; Fri,  5 Dec 2025 14:44:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 465236B02C7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDB5D140304
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:04 +0000 (UTC)
X-FDA: 84186443208.17.AC3B81E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB0FEA0003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qB1bMEd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963842; a=rsa-sha256;
	cv=none;
	b=LG4FWfR7MLxNyPvJfrk0AVA35+zyem2Hgnh/RcUX6XZG2vhtLzk63HFMU1V/d6n8rZ+DY9
	SjgtAMTEqo6xXYs6u1P7CqyZ8MiWQS8/WGIVaumlMsQNEB/TsyDBZcOI+iBX9LZou94AnD
	MTFU/wurT2ETa4JaAaJZJxZyLu6YHBQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qB1bMEd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eHFrU3lZx0BwghWnT1UNIj2BMKYqsa6Kc9z0dwXIJI=;
	b=InkoXMXN8VJXIhuCfdwhOZwXCSr9YYZ1H3Ah1ACwfKWRjD/wAosa7oIKeoVabzp6hufmqv
	57OHKnv7UmZsMysrXt/n7Ve89SubxLyhqbt7CcAZYnhssU1fInbAny3u3C04HEN7tr63kk
	6jb6wPJMa8N5xPkaFkCfzug9NEqFCA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FCDC60132;
	Fri,  5 Dec 2025 19:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6414BC4AF0D;
	Fri,  5 Dec 2025 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963842;
	bh=aRuaBPQblmvTnyI7HZyvBqu8OdLwNSnG7V4pefLWmQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qB1bMEd6Qe1qB8sA6DF47IVLV4wx4VDmTr6WLMuRfLulV0BIQzNv5yvhsRabI5Kxp
	 yidQlRUfbi83PgTXPakDGZilbDuFFY4T3IadnCt81KsMpkaXmvyPXHjDV3AUx9eeee
	 JSMt0JBunFwwJfMJN7jiN1PZeuqFGGEREnWaH8pVLq63WAXFzK6W0B9lvjM4gphj2H
	 R/XmEUz7971xEqPd0iCAW/pszj5gVnp/K+0TZ4Vb4XZAd0kR8FdDZDt+FQSloH/CUu
	 QI9KEEIeMuL6N7rMn1tO2NJTMz1JIHlFW2fZmkFaHCzrUm1+oV6f3s91hIBFEMfDcM
	 xxq7aDCfNeMWQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id AF453F40070;
	Fri,  5 Dec 2025 14:44:00 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 05 Dec 2025 14:44:00 -0500
X-ME-Sender: <xms:ADYzaV-3Lxo_1wb1YWuc63ysXpclfvXSSTqpb8H55n7NKQvUdcaOkg>
    <xme:ADYzabEEv9SaIwu4yu5EhdYy5cmM494YRa-bzybY-auTk29aImMHrtbPK6WuDUzkQ
    0i9B3_a869k0mgli45miG3zgW23oVeb6-DQuUbpIJ5RP595SDGfAqI>
X-ME-Received: <xmr:ADYzacTEbqB6s44ZmjKw-b9s9I8-maBbjxU9KoMzxvJZnI80ob91_KTvoGNjCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdegucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:ADYzaRuWmDQfq-bVg_E6V7R1GTEsow3LcyJbGcuUVEnsv8XgRCSEfQ>
    <xmx:ADYzaRA1XlwlGqlOeDMkbi2fsogyScQTqv0nxVyMxDitVJNyHfiYJA>
    <xmx:ADYzaWdVbNdKZpOdLK2AsI3nxW-4FwxKkknH72r5VSWpTS3U6GEQog>
    <xmx:ADYzaRo5vswsnSAOn8MMUqVU5uzqEmZPD1uokEacvE30h7WKFS7Yvw>
    <xmx:ADYzaS7k-WhrWx8Jrii6xDUVe280lYcLtyoYIa6D9CIfN7WLMDu3wiNy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:00 -0500 (EST)
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
Subject: [PATCH 04/11] mm: Rework compound_head() for power-of-2 sizeof(struct page)
Date: Fri,  5 Dec 2025 19:43:40 +0000
Message-ID: <20251205194351.1646318-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB0FEA0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 6whbsutgh9saieg84839whyikdjpsfd5
X-HE-Tag: 1764963842-779868
X-HE-Meta: U2FsdGVkX1+YMyAnKuzpcuOp0ZUOFwMUArWVeaegUEajkQI877OnRNcJR2ZziRmCMj5wENPNw/zXLRryVjOFOypQsYQd4Ll4Ipq45nUIymgvBrU++u//VYWDPYsMrv/ETWFqyckYZCUmT980XjBP2Uqh3heke2E9KXdoz+XRRZYRR1wK4crRa4dsj4DhuZGQzrnVAzjLi+XmIbtwCBjYtl6gF8VqMs51vXUVA0dP0D+1OcamQTgG+cnjoeH/ioPidAJxLwbG0wua9XZf5iXwU2cl+Ce/vH5k3luFg5H9leJpUDD5tiXInSGd1SIGRPmD0NVUdtal0+D+wH/12gaq9DILr6dPdhEj30dVqWX/QRhaxkakAUt8WyvzL1RPrKjqYDsFHKrsTqPwA5frRDoTE9NFk6HOvWGjqV61jDtGdgP1gJDaCSV5F6V8UR9Q17/NI9BTJ00sNFdIebeIZinhvGI6PfyFfbKEFH5oA7muycc4JJcPC6NbDpCAYwrg1ltO0lYL/hShyAxYgm4/FV/heS0ABhXDp8z8TFM1pz1oJ6xwhE54BhY4o8o2LkH9CejORWZl89MKdXpj50QJ4DNWJThxf3HjS6gmgdhDUJoDEBsL/NeCMGozTzRuogHTKLsTnOGtV3hRQzvn+5YxNCHa5ET6Hp0XWTyEuEyat3EZvV9tlDflk9SuWHP7OAnNcHuGXD/3skgTptOzBaef1SObN/6lJsHhBfQZtFE3dx4hOWkmXsYXkEgdV7WicZTceBySqyKsGiLDF2nAyuvEXr6vTAxxKP8SDdZv2jOzeNb9mRp36p+kC8DXtpeYlb86PGha5cfGLT83j1b7eQjXiK71/XCYTnks1LOnNdHoTrf696FLTD6pwYy97M8oe9xKTQx94CmGl2yd7CEEYT5K5/12ALB/X7Tg4qxPoe/eSUphpEY+VpR1ku+dYlmmTTiKxA7eDU8krNVBtf8HTkfupSr
 gRiLtY9i
 IGXKCfwur5Z7PBqZs7IBAHeyfYQ7MpWsDygthjXR6jSBUD4lrsZEMrHByCVcwLiNhqrH6HZGKpXBYzKrbguWXMuiRj+azhF4gVHxy1CepUfQ/p52F0lZXFjbP6JsecI/lAAoVkJ+1iFBnW9LrMNTz8mY+01wwWZ+z65SZq5uIbCTGDdxaL0clxJZDKFcjVi5fB7PVvM9QqoTyNE8C0SLhUoePVyL21sUCjBa1g8Jl67RVS4rWuWR9H4CXm5xKRVHBOnbInE7TP2+h1tOvaoMksrAIiJTwmdoTJLaAAsWNJHiksyIHCCbKiBFTIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For tail pages, the kernel uses the 'compound_info' field to get to the
head page. The bit 0 of the field indicates whether the page is a
tail page, and if set, the remaining bits represent a pointer to the
head page.

For cases when size of struct page is power-of-2, change the encoding of
compound_info to store a mask that can be applied to the virtual address
of the tail page in order to access the head page. It is possible
because sturct page of the head page is naturally aligned with regards
to order of the page.

The significant impact of this modification is that all tail pages of
the same order will now have identical 'compound_info', regardless of
the compound page they are associated with. This paves the way for
eliminating fake heads.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 61 +++++++++++++++++++++++++++++++++-----
 mm/util.c                  | 15 +++++++---
 2 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 11d9499e5ced..eef02fbbb40f 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -210,6 +210,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return page;
 
+	/*
+	 * Fake heads only exists if size of struct page is power-of-2.
+	 * See hugetlb_vmemmap_optimizable_size().
+	 */
+	if (!is_power_of_2(sizeof(struct page)))
+		return page;
+
 	/*
 	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
 	 * struct page. The alignment check aims to avoid access the fields (
@@ -223,10 +230,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 		 * because the @page is a compound page composed with at least
 		 * two contiguous pages.
 		 */
-		unsigned long head = READ_ONCE(page[1].compound_info);
+		unsigned long info = READ_ONCE(page[1].compound_info);
 
-		if (likely(head & 1))
-			return (const struct page *)(head - 1);
+		if (likely(info & 1)) {
+			unsigned long p = (unsigned long)page;
+
+			return (const struct page *)(p & info);
+		}
 	}
 	return page;
 }
@@ -281,11 +291,27 @@ static __always_inline int page_is_fake_head(const struct page *page)
 
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
-	unsigned long head = READ_ONCE(page->compound_info);
+	unsigned long info = READ_ONCE(page->compound_info);
 
-	if (unlikely(head & 1))
-		return head - 1;
-	return (unsigned long)page_fixed_fake_head(page);
+	/* Bit 0 encodes PageTail() */
+	if (!(info & 1))
+		return (unsigned long)page_fixed_fake_head(page);
+
+	/*
+	 * If the size of struct page is not power-of-2, the rest if
+	 * compound_info is the pointer to the head page.
+	 */
+	if (!is_power_of_2(sizeof(struct page)))
+		return info - 1;
+
+	/*
+	 * If the size of struct page is power-of-2 it is set the rest of
+	 * the info encodes the mask that converts the address of the tail
+	 * page to the head page.
+	 *
+	 * No need to clear bit 0 in the mask as 'page' always has it clear.
+	 */
+	return (unsigned long)page & info;
 }
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
@@ -294,7 +320,26 @@ static __always_inline void set_compound_head(struct page *page,
 					      struct page *head,
 					      unsigned int order)
 {
-	WRITE_ONCE(page->compound_info, (unsigned long)head + 1);
+	unsigned int shift;
+	unsigned long mask;
+
+	if (!is_power_of_2(sizeof(struct page))) {
+		WRITE_ONCE(page->compound_info, (unsigned long)head | 1);
+		return;
+	}
+
+	/*
+	 * If the size of struct page is power-of-2, bits [shift:0] of the
+	 * virtual address of compound head are zero.
+	 *
+	 * Calculate mask that can be applied the virtual address of the
+	 * tail page to get address of the head page.
+	 */
+	shift = order + order_base_2(sizeof(struct page));
+	mask = GENMASK(BITS_PER_LONG - 1, shift);
+
+	/* Bit 0 encodes PageTail() */
+	WRITE_ONCE(page->compound_info, mask | 1);
 }
 
 static __always_inline void clear_compound_head(struct page *page)
diff --git a/mm/util.c b/mm/util.c
index cbf93cf3223a..6723d2bb7f1e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1234,7 +1234,7 @@ static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
  */
 void snapshot_page(struct page_snapshot *ps, const struct page *page)
 {
-	unsigned long head, nr_pages = 1;
+	unsigned long info, nr_pages = 1;
 	struct folio *foliop;
 	int loops = 5;
 
@@ -1244,8 +1244,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 again:
 	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
 	memcpy(&ps->page_snapshot, page, sizeof(*page));
-	head = ps->page_snapshot.compound_info;
-	if ((head & 1) == 0) {
+	info = ps->page_snapshot.compound_info;
+	if ((info & 1) == 0) {
 		ps->idx = 0;
 		foliop = (struct folio *)&ps->page_snapshot;
 		if (!folio_test_large(foliop)) {
@@ -1256,7 +1256,14 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		}
 		foliop = (struct folio *)page;
 	} else {
-		foliop = (struct folio *)(head - 1);
+		unsigned long p = (unsigned long)page;
+
+		/* See compound_head() */
+		if (is_power_of_2(sizeof(struct page)))
+			foliop = (struct folio *)(p & info);
+		else
+			foliop = (struct folio *)(info - 1);
+
 		ps->idx = folio_page_idx(foliop, page);
 	}
 
-- 
2.51.2


