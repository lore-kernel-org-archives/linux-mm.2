Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8710E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226876B00F9; Mon,  2 Feb 2026 10:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0B76B00FB; Mon,  2 Feb 2026 10:57:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B5C6B00FC; Mon,  2 Feb 2026 10:57:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBFE06B00F9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:57:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2EEDD3AEE
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:22 +0000 (UTC)
X-FDA: 84399971124.05.6FA672B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 90E2A140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:57:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YuVzolUx;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1zvDMaiuoy/HUk5FChxrVaaUTv6nkNh8D3CA+a87hI=;
	b=K+MaqrS/4BWLh0TSGkXcaxjg5i5W+Kwo2zHrmQ8d65cqMhlINHLgzlm33WIK1F0PobJYYg
	OKhNExbC1oW5i82rx2I168RAtQJLJYrMKU+R37z4y9FQEf4H6eZXK6zTecl4t6at4VcGW0
	6HHldZD8aWl7TiEWqskFfopm3pBUtmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047840; a=rsa-sha256;
	cv=none;
	b=ejXW0jcNF5xYVokPaOMsckUhJzN0OxApq/tgyEOaBR4GC/Pkr8dVWwCTLWZmRD3Y5sT4P6
	r2Id45IjYlLdvHPJMTQijKuTX22Img3f6xtYByWZjvhHz70jVjgXX0i34Whx7dT61avnpb
	3av5kPaeH2UWPF1wOO7CIn/TcWllRsA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YuVzolUx;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4CCF43ABA;
	Mon,  2 Feb 2026 15:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128E1C19422;
	Mon,  2 Feb 2026 15:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047839;
	bh=IBF8LKGHv8lxiBFV8UfHPvSAlGIc6Qys2WBMHwwJVg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuVzolUxox1f5GDWOA8CVHMmtNtR8rH56CE799gR/LBfgxNTQE4DS7AzSZ05rBRWc
	 FnPse+uKdKjUnE+dIg2WDGrAWi/DxQyNqRQWnVunXN1EQZ0s+l+VLBWznFXBq7FRtT
	 2kLH+J41Lw+8XmHoO8pYl/kmQCiGHNECurCynDzjvYqd0jfAMqj0+rIDcD3/XTp9qN
	 47jsB7V7iAH2Z2sWcSbM12x2hkw6jF6ysOVcj7VilqhwFryfXkl/hYvYBV/pqe5XOM
	 V6I4WeWBkYYa/9pdpYNKkE5dwOOWz7J7plXl/u0mUpblatGhNNyZ0cKj7TlsLEOboH
	 w5M6fqyvPoheQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3A677F40069;
	Mon,  2 Feb 2026 10:57:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 02 Feb 2026 10:57:18 -0500
X-ME-Sender: <xms:XsmAaZ8N7sRBFacFfLWK13Ue8N6iCEOIUyBKkoBm6B2qEy29XeyjOw>
    <xme:XsmAaW6w3XnKVDwrmP53pkBrzNH0kPwGD5djm1jP2l7fNlkeuljlmSeLiBvQAj-RN
    8kH9vKV4uxnghg8HFB3jlFUYqPtQks8jEFXDDwq4FCcKvaY2eork5Q>
X-ME-Received: <xmr:XsmAaRLU_Bb7pbehAr9C94xhE2TepA20ZmiTQxko2AWD3GSzOCpgqmFs7GwENw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:XsmAaeXK6Ulq9xSuV1Fe1W8lKZh40n4Vh18Lo85oJ_aa2SVlvjb54g>
    <xmx:XsmAaaILrAokZPLEJ-okksvlwcJuSj8xqBbLN0QhXKUlCSW46L9tsQ>
    <xmx:XsmAabwDWM_7ZNYuh_qbv3zxFwhpPd5c34plUfYXwu-4cyfF_I905Q>
    <xmx:XsmAaeLmiQHe6CStLnXUwh9Uqg-GtVdOxvC7Bg5bVtH0QBE9Tnc6ow>
    <xmx:XsmAaWQ6hs_dYIYE26JrtJqW2_VAoQXXbs2kAZJYabhvNwhdxfNQYcq->
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:57:15 -0500 (EST)
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
Subject: [PATCHv6 04/17] mm: Move set/clear_compound_head() next to compound_head()
Date: Mon,  2 Feb 2026 15:56:20 +0000
Message-ID: <20260202155634.650837-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90E2A140007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: deysq89y6ez7es8rbkpgjxwnwyr9kzi9
X-HE-Tag: 1770047840-395169
X-HE-Meta: U2FsdGVkX19MWGOZa5QfVRQShjIgFuLNmHciLF5zFbQvAKpsKHbJ/pyJd8WbVCSH5TiEe5F6ik/hUQ+jw5Chyfn6QONI4YVzCpgKlvj+PKm/kdE1Hm2rF6mIuF3zAzkXUGYlbNbOSXXBgqa1HUM6Y5FVn5SfwXQaFTy0xuEtGVBS3pwkkaovSHnzz2gaUndCIqNYtXHmVFrudM69dav9oYHO9p6Pc+PJG30L4QIn9F67G1ErlDm5tKhAhqaK4Ce0sv+TXUKJYLXAaSSoJ39OQsekKqo2DqiNZEfCnMv7x6nh6GAGvl9rL6jVQFUdrP44B6N3xltbwgM+7sXMeueDp1sipzHJm7KuyFCtUP2UWP8XkU53NFL4JaLfTmWFk1aer0a4+j1SDvd7Zb1hdIds1x8RiXOL/jExKZOxOHJoaHHeX3hX9prIvlWFQ0RrhiyE9LcmzRG0rwIn4UT/aopIS4m/mzlLBaPFtsvhK5Z5JKmCJmyfh+wyhFt1qNgRcPzo4BN883Mo4WsJFQMkKBrf+PFHjVIhuB+dkkzxRhsCmfnFy6xAyWoAC8OBGaMjmb32npKha/96hxETStpSSH9LswwOeiH4qvgCqjiy/deBPZaHcUaGCot6oc/9PfVTqa80EJauV49zaU7+mJdh1JInKIU8Njil+VKpqAjeepnSNFyFKylHO22h+Oh9sC8ZxOWJN2s73AeCG58s9TQzVDbOsyafjAKji1lIhTnfG1rIBzMz4V7hTVLRMo6EurLcH9uqKX56Z9gBcKj/blW/y9Y89hZ+ofrMJaUhcFKCEcrySANqY1AhNlVNvthQi5nzZpMKGswNk/Om29Bm1ClE5Lc2Us/TKizLZmUbRAGEDI/K/iub2gQC4TgjhZkfktC6pQNlNir/2Lhhf8Ti91ACmDnx27sAQlYgZ/vOwJzd2dQ34JM5GKAgAcNoU4Q9WrL7UjrxHFLzhpbKBC2pUt2fucQ
 s/XogZoF
 +f392sPCMWdGK/fbWh7xN6hBAvDITuMRh7JZjIh1eB6S57yRZk1cIBO4/KEWuazgIFpSpYvN1v+2oZUvA+yMmx4oiyPoMy9daPqEDTS+tzQy9e0YFfWUxwuzD/RaWXZZxWB6mfdhU2QdyLJDTWPwlnOC7160SRA5Zhad+w9needw7jbOrTvDDn8NaN2WHhK+pO93VLjng08mNzCn4irnlEQ86qS9XwMCCuIrOptcqSBNDg3Uw4utclTfW+XZLJbOQNKIrLi3LbOXpigLJDGzgZFew+6do+ycMaB8531JTf+qoLLLjuF2PoSocwd2gEToND9umNexQ8a3yr0Q=
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


