Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97B3D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E02F6B0095; Thu, 18 Dec 2025 10:10:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3FB6B0096; Thu, 18 Dec 2025 10:10:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6353C6B0098; Thu, 18 Dec 2025 10:10:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 541476B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21E151A0258
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:06 +0000 (UTC)
X-FDA: 84232927212.04.4DD87CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B4C5120022
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkoW3Fct;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EfxEZ0+rlpKbzma0NkFALMmdHEGZYC5hHnZKje6Y5w=;
	b=Lq7mPDvMjcLKkGMhY1OcpDPTDWwPsxbk6K8jvxIYOPoMZ7wUIJIC+MsTUqZKYWvr2YzxBA
	OvxobCOuao/VxtR6llbWgfIanKLHQXxIAG5jDRqcT0dAkZFdcYjqxyEC3WvHw3tameex3p
	Q1eGXHwue/o6KplM+5u88lghgparEGw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LkoW3Fct;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070604; a=rsa-sha256;
	cv=none;
	b=MzorurEh1hRqrEfLxo2zts9D71uFHCJLTt+gSRa3ngDeU2F2LxNNDeqWnBZohM1TwgcTlL
	Lpg43tNcrAaldh1GYh9lVUiikBdLR5YOICAIC6yuWJswcnr3Gx1rX4EqFXMHQQDzNsYN44
	wjpIWeoxPOBLRg8e6u9n53Iy04AgqVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47B1A44357;
	Thu, 18 Dec 2025 15:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6BCC19421;
	Thu, 18 Dec 2025 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070603;
	bh=xpVALRLGrlC3mdPn6EctNGLeNqovC9Y7xpC9d4Hifqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkoW3FctTcoQzT6GlDur/1mzo5wawRrQ8Pl/cnl1exw++199oKw1Cy1s1qxqiQMIg
	 A9EqbhmFBAYG3FVmJDrktjHwCZ7g4JXi1wjuQyKHCfnABpNDNMogRF49E6C2zjcAyD
	 mf4RBDievwEEqpaV2Ondj6Pix4bZuMey/tM9wYquc0yVBZggMVWFUuirpjO0Mf4Yrg
	 8qKlEZJjvRn4vEbdueXOJel8HoQ70ii5/nHgy1kTqc130CCuKKelXbib5UhDQGNZhR
	 FUDRaqJ3ke9MZT7kZZomrmR9lz+nfkCevg69KKvY3TtjG+YQmHbBtQbHHpnJ1pmWIs
	 Q1jUYjF1IYXyQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 20747F40075;
	Thu, 18 Dec 2025 10:10:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 18 Dec 2025 10:10:01 -0500
X-ME-Sender: <xms:SRlEac1_SGreXn1zEfcYFGmHyHGlKwNyJRdt1nU4R4-ctiJAU2Y6dw>
    <xme:SRlEaWXQYh89avwgyqAEmmmrtTOu-yzSO400gKolhSRvo30tof2An26Vn6gGU2bzP
    0ikFA58Q9G9mpIxoDr7pRzoEaZ8vN_kT8khjDdDu_dfcIZ6DVBiWX-T>
X-ME-Received: <xmr:SRlEaXttyPF9xmoJssyHXMa0yiyHXy79AvefaH209QkpCNR-E-5o912gdb4Ang>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:SRlEadX26BhIbd7kxepSo9UwKozctXZA69lvYoY149naSxdfPipLow>
    <xmx:SRlEaTW_nF5QJeR62FC4jmNNGd8n3awcFDQq8Njxer5g0Mu-pQEzoA>
    <xmx:SRlEaXdWZjPqFy-glcoiDYQKMc4VPzqoE-RFUCpzWCngaunaOBw6jQ>
    <xmx:SRlEaa6hCcWXykXa_FqO22TQpdJJCnI_Mua-A5iEiDK3OFyicdrWVg>
    <xmx:SRlEaSQVN9Dcj6ERM-oacNFEPE89s6pz81-tXcRydvM_6XTjWQmHWd26>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:00 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 05/14] mm: Move set/clear_compound_head() next to compound_head()
Date: Thu, 18 Dec 2025 15:09:36 +0000
Message-ID: <20251218150949.721480-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: gxhy7ryhpkb1fbwezmou79uukd5o6673
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B4C5120022
X-HE-Tag: 1766070603-312950
X-HE-Meta: U2FsdGVkX18GOkgxtItKFOtJEwLuoi1NMiEYVSdYAOyS+/J9YSimoh697rmVP5VKcqGLzsT64QG5hJvX14n0UFi6bh2uV3hRxda3y2ybbh86FjoWbA4Gq1NlI/k6dgklweHaStv101F/74//Z/ISwM/hnOdQyvsY7hXE0Lkt0u/ukN1HbE/XGyMhIcsELxoz16buJV3hEmg/paLbGxGP59H7fX62/aSm6jqpkWH2jgs3HTQCgFsMWpDM4O6zFbbiVXZi3+A0YNKwKm0FVCZBb4+NYpXANmHxpgXWuVirD+M4hyLm35n1MibCNCJxBnoKdTsz9GNAZ83WvAHjCneCQzu9nIrwJ9vwrquGaQV2sOV7ZhUEzv7y7RW0ZgMdHY9kP/1FbLTY55YSRDU5sYRtLarupmM447178QgNXZy3fMIxjXIImFnumlNnb08fsfB3w4GjAioS9XUR0RP8cRdeIu/ikUgaqpfhEkwJfGMVtzrhCGL/BuunWTUSZa5TPa3RmBRBBNc+XPhFNm0TzBdIs1npeKqdT2yKJE53w69+8UsAfhSit5S3eLpPSKOFzsJruiY9ThVr0CLakneZWgIk2eHv4W91KLYULjmBB4Vf+CnF/ijzQyekxNxJYW3Ahs3iDsq6Qdzd787g6jJdV771aJWfHg/NB7uf5DKaFrBXsDGZ0YxPyMIf8N3y7CBkv5Gy8Z4MtzApQUeg90pkQT140iBRHHqWQBYWHuybCs+R7h3z4VNXmwPdZzoiiqVyjogMTKeHzxJdBWrfuVY1xmoM4tX+/M7Sd1AWv4M1dngeeAFfrM/sW08NrOM131mMhQyDHGssQ0mB3LVlLSyFsEwzDyBNqQy4cV4yltr7u9nIaKlcdAvNotPNueleQm+QLgt+A1SyGgHO/lFYrDQ2fz+TTWpHi19moDdF7+F4GbfOuEHl32fLEgcaVtiujJav8mD04ZMcK2DuOaOt8KDWPMe
 uvW9QYpo
 sZyd/8TsBpwclQwnLIgNAIyMXel7teh9qvypK8FkNVn/WdYt/wZWXRmlhuT78PaJzrlmduEjTAp1K8WyZUd2wRZF4+dhHWZZtQrpLlEMmLr0PN+qNqEz8DMElRd3U8tMUJLh4ktFRCb4FQEQqHH2pxUZKx5aBMWdSB/h1WxLQyKICamZjxCSszoerWQocOJ2a7Ka6iuW3sNh+MdZlC2QbCXRyALTajXUm0C6POPQPIamoJ7UBsBwjIE580+Tcx/BMhuIby19D/jQn2woUV/mlUdw8HWqYOg1dQXxjLsYYyJLaDOqXwtSKdjN7Qw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move set_compound_head() and clear_compound_head() to be adjacent to the
compound_head() function in page-flags.h.

These functions encode and decode the same compound_info field, so
keeping them together makes it easier to verify their logic is
consistent, especially when the encoding changes.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 72c933a43b6a..0de7db7efb00 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -290,6 +290,18 @@ static __always_inline unsigned long _compound_head(const struct page *page)
 
 #define compound_head(page)	((typeof(page))_compound_head(page))
 
+static __always_inline void set_compound_head(struct page *page,
+					      const struct page *head,
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
-					      const struct page *head,
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


