Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C99D44C5B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89DEB6B0095; Thu, 15 Jan 2026 09:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82AF16B0096; Thu, 15 Jan 2026 09:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB826B0098; Thu, 15 Jan 2026 09:46:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E60C6B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C1881AD564
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:22 +0000 (UTC)
X-FDA: 84334473804.06.15518A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D36AF18000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vOk/BYUF";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488380; a=rsa-sha256;
	cv=none;
	b=iy97SJp3tUlKNU4RcHy4cGinVxMx3c1naV4v39bpKxHVxmNgerc7wuObwCSvlgZ9wpdBQk
	/A94tX8OdiHrTQUsJpE/T3GHrhEmCnyRCUVNO/AqfiUgqfuaVgFxgXztLqSSCeQugJ/NEl
	1Q16LOI6bft0lEdY9nMePxdacrZxUAQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vOk/BYUF";
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL0+LVL/0/F3lb/k3ta1tTPmCzccC0GRXnixZB4AwtQ=;
	b=19mh8hTYa0szaT/BHMvAxOA+PUSIz9cG9Kb2y0+GdMlefCv5ysX37SGNnYkDLW+5R36KgV
	pLK+Uze3NnQiUMQ+gAW0YkpcMQD8IbbVGrOQwCO3LU7cUl7zaob1z4XUX/mepA497WTqQF
	QQewN1G8BwOsMSJL+j+cS6hwcft4Dj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DABDA4443E;
	Thu, 15 Jan 2026 14:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1940DC16AAE;
	Thu, 15 Jan 2026 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488378;
	bh=WUDBQAa58qP3pHbP6EnrIXpUoC+TsGSOWrtaUEZdRJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOk/BYUF3RLC3PapuN4FEHV/ZzzuMRtsVLGbNO8Fw8rkeQ8nQuXzAp0W00erckRm2
	 ikAKfh6ZLwYL4muFR4byIG0GEaBtCpIbrE4bPmux7crS4Zs8o73h64VuhCLw9i7mIe
	 poJrb8uDmXrmxLkI0hCMJeqsv4FMjc5+LngPmnFsG3aJ3aLHxoMI7rU2e72bMYy1Gh
	 f6VIvEMhvG4ZLAg3vWs0AJWXRa5Qyy74PBWbaJH+FJjJu/ZQVTGVRE0jEhiKok0x7h
	 Hg1vn32C3A19TpX6QN/iHeKXLd1X2diRI7IRQKw0B7VyDvRKwDWQxPcKMuYSmqMk42
	 FodVyw8c5ts8g==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 45A69F40068;
	Thu, 15 Jan 2026 09:46:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 15 Jan 2026 09:46:17 -0500
X-ME-Sender: <xms:uf1oaXkP45D0zP2yku0ESobsdwM3amD7FO-SjS2kL5uux3FAlrXr6Q>
    <xme:uf1oaaGE1gY76qcxlANxUskvtzw3vIu8QidSdpseQwp3EuVadhZ_eXDHhgsGM69Nl
    OA0KCpYlzqcZyhQIwwPEv3utlIp3i25RZPmXmkzkiReOgx-Zq_t1gH9>
X-ME-Received: <xmr:uf1oaQcTSqH06vT4vZY0XWihEFoP3PsUIMTMYi_3__7Jf01OKx0iYPOHeNBLbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:uf1oaXE76FKl22Qozw2n8bhcH3ADVhpV-2YNeF8TLVwTjw0A4-Z07A>
    <xmx:uf1oaaEdwe_YQZgTaPL1Z8YNQoHqP6nXB6GyQ8___rl3IdsSjFRnZQ>
    <xmx:uf1oaXOSR2CR0GJ9rM1FzUi9cZeNU6-Y2C7tkVuYTrdWvWXgmvESfw>
    <xmx:uf1oafqTJBFcqRohiZJEz6HGcCMVVsRFIjWc7ehMJP1_bXaAvBIjAQ>
    <xmx:uf1oaYCHcLMe9Sq8ZZGMwpWe7bAM84e1FxGB_-bN5RlWk25Qwy-kxufM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:16 -0500 (EST)
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
Subject: [PATCHv3 05/15] mm: Move set/clear_compound_head() next to compound_head()
Date: Thu, 15 Jan 2026 14:45:51 +0000
Message-ID: <20260115144604.822702-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D36AF18000D
X-Stat-Signature: 71ihpjnapc7jb5n17mg93og69f45u6ct
X-Rspam-User: 
X-HE-Tag: 1768488379-742969
X-HE-Meta: U2FsdGVkX191PkHBpnPZLmLpbHr/BjV3CqzaglSwREehD85YUoFf6mON03L3T/oe4nFrBllklvmFIpC2kLWHepGMxkV0K/iyZPDaKqffRyBAk56IionjFbmT2zgJFIUTCj8Qqp0fuv+tK+mv6ZFaGnSKJ32mnT2awD4feA/9yjhqFmdss2VoPWKP1+7u+OwA8GpCg/A9MeKhSaYdxB/5204OLOUh9460NKfHW/nYOwF+r0ckrhuWcBRtZ30taUHDEpmzd3XTdAppFjsmI+UBVDpi318VmtgxnM1zD48rkKhoTz0EcIjTOPKoSymAvVgKdVD241xq8o4rNt/UmsWQqLXIQr+VNgGJTFnsddr5GULLbUjMP89vZMLXis7RGLkWEea5qPbJi0wPxvt64g56mVsI6VJid4lzQns3jIjMBkx4IgF2LiirWom8ttfmmsOITxnrqqdUO0/rEd7laHHKMdIb1F5oYaOHc5uHtduhpui1TLoEfSLJWyLLaBpHh4kfq/q9X6YrWN5Q1xbsMPErhjwoJrrkMobMdolILqfIKHQTN1lkCC7PeMaoDRwrW29XRhd5O/2LK/xpJxFI1X9feqrelOkNPX+2ot8LRVqjIfJH0Ge85aqUCiiTFLnEC7xOigjhOjoFA9udIa3qf8E6tL1YAjfmnBi9+I53eeP1m8SGBHCJ12zS9z/xOxXCyawv19YLr3RubvWTkqJczv6IpMNOOCgRhohCzi5vOpSV8l44DNUuhX1UooDetpzjvae/OC2Qf+uJZXGRr7hOjKIcwxF3Pj3uDFratZQT1Kh1p4vicU2mFCHwMkgBqHbvCPPTkignIjueo0kMyxhFEV06Z91mv1ccUs3hhGlqs1mDzkPMKqMhGHIYSmeT9TLG0qt+E6vG0D09DDAuDYgUOuga1iZQScZkMk8rmKdfuBjWce++gd2Wh938CZnUsRxBsvTRFr8XC1LVL7kP98RESt5
 C3rbafkm
 J6MISLXS/NnMdoBn25YTE4vbZnBIMAk+OG6rV3IZ0vehjcGbDd87fz0H9F2T/PwQxBxO26LcI+A+fbB+v7CiMu6d+6Gd6Ccw4SbJhYDEM9PpdR24vBcCl5GUXI2O9XrSJgCaM1ErsxjzR2F79gUqIHMbbWdPVtjyYTD+CV0HouRy6CEQfulvj0tYtr7SruPBWCX/gxWM9l3F15GOAX7y6PN7HBUTxJyPxQAsUNkg6jQZ5+SqFHvcSgqIK6lW87RmQs3iTt7CVQd29ZId+FsCxQ/IHlERf8HYLcloK7HtDPoiNNc259g9Lba/kZA==
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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


