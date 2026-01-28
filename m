Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83450D25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA50A6B0093; Wed, 28 Jan 2026 08:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B7C6B0095; Wed, 28 Jan 2026 08:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AC06B0096; Wed, 28 Jan 2026 08:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1E136B0093
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75F0BB8C61
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:42 +0000 (UTC)
X-FDA: 84381520524.19.46D61CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F9224000A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lwZ+0z+/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1zvDMaiuoy/HUk5FChxrVaaUTv6nkNh8D3CA+a87hI=;
	b=PZkRle+7Xw+lwIY10S0rEXEkN8HZWmVlGgRfZibl494YqLuVdTxDddKSQ4ixKG8JV0vkn0
	wuQF4t8OAGbFv9PjVANlgLnUIbn83upfdLrGvK5pUggaDMlQhBsbqim2d01baAr6NcVSfA
	BcJ+Zd1KGCzHkrPiAmphy7dk/ZkfJQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608540; a=rsa-sha256;
	cv=none;
	b=HOMfHScCRXQCPvDzX3ybopqWSvftDmaTnqYskXt1eb5qkr22uuH+juFwV4UnqyQfwEtlAb
	J61m+MNi0H6/uzuqbHmV9Olawdu2GvpCgfvCTgaorM5b8Jn0RQgXOU56LLMW3FqJ8z+Yt6
	I3U74qZWNmSJSm1fpufwpwjjo9HcCoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lwZ+0z+/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A33C8443AC;
	Wed, 28 Jan 2026 13:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA01C4CEF7;
	Wed, 28 Jan 2026 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608539;
	bh=IBF8LKGHv8lxiBFV8UfHPvSAlGIc6Qys2WBMHwwJVg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwZ+0z+/i5xQoJMB983l91A7Kll5RJy1TYPjokSHydMfqlYRjYa8uT5FKuIk8lmu9
	 9UXLk7z1cmvFGJeU08A2MSYK+rfeCmHBXxuch5ksF8gjdzaaVxM3DHwIC78aZweytY
	 FP+Hac8WyFQeXQM5BCh4vX1FiRCcrgwVgSGyZ+dlaeFKru2NYXvo/BEN/G+oQkosGI
	 KG/FCpf24V30FR316SXjzZjJVtEdsihznqVYmzllaPTn15rYFoh6JAEH+xRi+ECFSz
	 la6ifJHC/P0Id6UiegeCaE99t4L5RTW9EDbZg4Bgfay10RCDGhsPifP9nsKBI8NL3a
	 Bjj8ez8I1r5qQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id B4365F40069;
	Wed, 28 Jan 2026 08:55:37 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 28 Jan 2026 08:55:37 -0500
X-ME-Sender: <xms:WRV6aSXv8CSFA6WCH3D4DEChzoz6HoLF_6S_vfGHGygBGxB1euPOqQ>
    <xme:WRV6af3xOruikHOYovDZVSzFskejsJ4AljrJ30hL7Erdwo2dnvk3wp8ywXmwDXjwx
    cgYcbS7OjZdnhnZm-yFAlRB5YE-ViiHFoQ7YbkNErMozp7soDuG>
X-ME-Received: <xmr:WRV6afSp4WVW_ZDTqck30b7ngET2eCpWVySAFUxj-uv5QzLc79KcqKANRJCbyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:WRV6aQV_cUmC4MSZO44zEnu8dMXvBlUNtCwN_qTewd4GuJqDMmTn9Q>
    <xmx:WRV6aeMWWSgXAk6owIEpXJnCsZNO9vUOTgBGkhJ5IgHKnrO34HDFRQ>
    <xmx:WRV6aX0YKFjtUwnU4zz1m5YA5uCXFx0ivqZTJP3OW5OJJ6VhKpPrsQ>
    <xmx:WRV6aWObVvbcyJpgECa9hUTkZvHWXABVIVXMgWj92inmzGaDb-9qOA>
    <xmx:WRV6aVt5lcbOFVXC_cAUMKfZqf66sv_VwYTKn1LVoasd0ELvPTK0GV3u>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:34 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
Subject: [PATCHv5 04/17] mm: Move set/clear_compound_head() next to compound_head()
Date: Wed, 28 Jan 2026 13:54:45 +0000
Message-ID: <20260128135500.22121-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F9224000A
X-Stat-Signature: 7zeb97153xr1rdazmssi7x7mo1hggxtu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769608540-30901
X-HE-Meta: U2FsdGVkX18BgCZe3iq1Xz5ZJ6HRY0lEjduiaLv3MWaE6sIc2Wk4vLYf9eVLGOHTMvdERud1Ucr9Prk1qz5iU8QCPByqQs3/gRkx0wHHZa6aWTJcpf8R9Sp8Ylf/mtUy9uuPFwNK+yWSoPOGACYAB7iSx+S/UE1eIZdrFT4BBBWiRogu4oC/0Kt1fBMpeDzFb/SVxBerbdfctVKT8i2xElzMRVC8rQHoqJKhPh6ea6dhYvs+aC2/7P6h8HdqN2QFo71hxDNFTVwT8CzbjsQpcVu3vitmO4A0xS6SkSys41WpfZqSaA7kyTzqeyDU6lafqNzCTXqBMzzltuCRhlo54/Gt8pwssECS2P/OL0U7BzQ6vI9okTeWJb+zZk0jeq8EnwWUpQaNRIwGaGWRWmgqQZqQbWxTuItK+L4+Vqp+pmgwL8wHQ7PnxXx4tZ5yA6fR/uJ5Nq4d2aEerOVsjdLTuWVRlgaJ87uHDIi0cG24xMrO74GqcE2nqLZb5kA85zvXf3X0sHZDj5n2erBdfr9vMVx5am1z2ZRAjJZ5oihAanAIwHMkd5IfMcwdf2MV1LKWtplIx5n0xVUhyycvG6T/h/k/DdC72hd2BSCY7qKiZIK4LN+LBw2RtN5tUzN4Tu2n4kqBLFA2zlpw/TSkAAKO/5oZGvAFvyJaGw2P/MqLveFs4yyjvC09ZxaZVNJuL6xtRICbdvztyW8UkyfWoSKsZKOqyIUnP8v5VSv/ifR1YL2w8BqSW/MMbFwbPYQ2jrMCCaj441F/bJ2jZcA1lP1k61398DL3dbzqO7poOVbhCrUX0TQp3dhUvb9QGhSah1035owfII9GwBEEMNQ5Byr8j6P36453FLe3nQl8tZg02QbGAtYV06dwAlAxZTEVTvPEYR8U95xYrOp9dLnibQxlwHSaDX1ZzVv/fzjt7nt0AupM+5PmtsYNayiSuN57YLqhcpPHxelpTvOJ+PSiJ08
 IYKw2/0Q
 bEfnhKbTvAsxOxAT4xcCKrLWhGfobvm1v4AEbaRcV28+B8TGX57K23BgbFgOJtBkNZaD6ywdk/jyZMm4WaoervjTpfCdxegMVamzgbOGiMmaYWFwmjl5gDIWoGjDVXETStab/1aOaRPR4zbkEXhbDJDdkwcD1Aj2GgVcMRcgkhgtQNS/A9n6xG1rPhcWP905d9SWGUCudy75YxVhciBjLtk1iPW/u4XqkMMw1EOSSa6nSQYmATSQoOwdVBGz2oMPTLSZoqhgIj5kfqTi4FCqkuEIp79UglFt7mZ9UjRJptdXNF8ZaNgpG9jLQsW/BgcH46FBmgmkQfJxi9DY=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index aa46d49e82f7..d14a17ffb55b 100644
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


