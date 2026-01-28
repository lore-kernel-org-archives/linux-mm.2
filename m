Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186BCD2F009
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7971C6B0089; Wed, 28 Jan 2026 08:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754A26B00B5; Wed, 28 Jan 2026 08:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657416B00B7; Wed, 28 Jan 2026 08:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 530986B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 215D7140675
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:32 +0000 (UTC)
X-FDA: 84381525144.19.8863115
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14747100005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hA1vG5Tz;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2pnQO0FL3JmnvperC8nJTusQu+LDYD5aKc2nDrZEuU=;
	b=psVCLnQyPBIaDHzAvifrMbkS15GP894SvzYSnfnvM60hKgiTn3RhZcWfi33M/Lo0VEV0pA
	go1o0uTDzuaEuY3qrk4Jf8YzWvUyywd96p/dgy5sDjdxkcovkod+MF2I7vNv5xRCPCPIb9
	L9P3YvLneh4kUeyIrrT0SEJEKgfgT8U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hA1vG5Tz;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608650; a=rsa-sha256;
	cv=none;
	b=RXduzPAQRCXwxs0UAIcvbV6q+oxnyfonqmUPeVnsT9mVhQ5clQJIP+Rk/Hbyi2v+LtG9dF
	u7B6eqnbI1Hcln8wks/nMOXEqMCA7wZsN1sNQlB+XW9lYw8r6TONDvcIR7b/Qr1HCXwRhg
	WAAaJbpeD+INya3tBI/HgKWivHzNg5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C6F43A03;
	Wed, 28 Jan 2026 13:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B817C4AF0B;
	Wed, 28 Jan 2026 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608649;
	bh=R91tSPgHS8R3tSxlyTHy32NvxCdn2aqL9vpLNdIzhxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA1vG5Tz6vOVAQiU0YsGs+1zGfO17BHvJRxameN2GBjn9V92QPbeegKchTpfhn1wC
	 Rf/lIoX5DrS8lm7/aAYd1+fTblvcPwJVOb7SFqsX7UQ09dLICjbFfveEGh7QQ388pN
	 iZus3O9W8W1MxsTDGmpmJCzaVtENyyLlsg9HKDZjqCYu4gboBsvGiNJUFmgdZP4C5/
	 kAqzRtLpe/PLkDqyxLZJ4UZ4+5eh9Uh2z6qvS/ip3G11UQ3+95QNFa/4u2F6wqqfge
	 GNlwDAjZgRMyOfLRHdCjOkeMvUhhJZTaD8SbeSzDY2EEI8HRG6V3GWx9BwWEjfQI5o
	 FyMbIf3TLKELQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 52CD3F40068;
	Wed, 28 Jan 2026 08:57:27 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 28 Jan 2026 08:57:27 -0500
X-ME-Sender: <xms:xxV6abXja8uVpWVH8OPOn0bReKc4sZFVsrpuoX6H0zMzRmSKTuYgVQ>
    <xme:xxV6acybEbyYlxjxYdDgTfhcijwH_NNskGsGOZL6We2-zsu6mWiBLLiRK8kpcSQFo
    np91_264AOcPAJXsufw5uQUsGu0UUYO1Y01oUv6EprH6UZ3Oio7bgQ>
X-ME-Received: <xmr:xxV6aRh_NmufiJL65oK1gGKIwXbKAD3IbTDDdMqt87_Hr8eQA-ZLPutaB42evw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:xxV6aXMAp9NMowzB4AXQTB_2v0ux-svSrTKQXS7ZDjpGcos7ugSkeQ>
    <xmx:xxV6aRhtQTFsqhlRbGI08wv7MUaROZDojecGBB8QxgS9HLHZgWy-iQ>
    <xmx:xxV6afqGSp8mgCnWnp--rEgjKV2lViniL8HYVojnEP68AtsvSRaGIw>
    <xmx:xxV6aUh83S4nqs2ZuXUz5Q7CYJoc_KPMZBxJkdkIqWs3OnASe6wEtw>
    <xmx:xxV6adJ6XmKpm6pXNVnSYhSUzjUz0ZvVBtmSflrUQUwi_77g1YyGLy9E>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:57:25 -0500 (EST)
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
Subject: [PATCHv5 17/17] mm/slab: Use compound_head() in page_slab()
Date: Wed, 28 Jan 2026 13:54:58 +0000
Message-ID: <20260128135500.22121-18-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: sgfue55eqardn4p3i3kqwkpb8ijs6t3k
X-Rspam-User: 
X-Rspamd-Queue-Id: 14747100005
X-HE-Tag: 1769608649-667506
X-HE-Meta: U2FsdGVkX1/spsNzJyF3PQGrcjJocE4gpQ8bNWjFZxcg1wZj6YnMkTyUe3Ox94lD2OLgsrtBdnwo+kmQV6fZOrR+Tre1DZYESkgQ9eNW2smSrnJJULD8crpTPy8pfGYAHwVTP+c74sKMLn8fZpxYT3AFXNk+p89HlneJdEOlBTHkV5CpMwanlmLrfdzzdv/BB/f7OzA2Q3fTEIUncA+tA8gqtNBzvwdkkk2LLe1jYPglpVeXygZGIJB7qkW9Aif+K39YBVT3+sQuqAwBo4MD00rZbanb+Bhr1FXwMXFuVZlDptZerOVz5rtCCenk7+Hma4ZxhflX3GHIJ2eZg6QtOIun/a3rXjn1Dp6v4VQhrcWmQrnnWklAJjifcIb706ZqvUinO2RHF6qr4mNCth65qt++XMBUC7+3k2ULNhF6bwTUe1VHQ3PU4s0RizZrTxG0dd6bco68/+TWVsffEHt+en2DJwy1wCDc115MYmxNXMSf9PszWfGRYcifL6OrPiMHEMYvSwzz6Z4ukNmYST8Ok+sLSoY7mIfC+jdx13OvaajQRF+ESQ7Ev2hchlLGHejjSIFeDh0vdSeoa3qYSRsfwQ/frSDan32ES25XY8g7NpnTctSbY8oeQY4m6/onOHazG1AhgDWwVLrf6sJuWpByXFGKuGpf568xJnqi7iwCosRCy3A3RzUK7IFSyXWfX5bdr8lcsqRI1+Ore0jtcbZNMZZNR1pzG0RB3+jw0nP+hBraW+iQlCjRzxFopBbdtWfYmPGu1cIZLHq4pCaTFvKoYbjVehSYc1Rd7FV7glyKwYTJ/Hq32Y5/6M+UldIMocWfOdCT4fZmMWz0yvXqwDAOudtFAn7fmPB4GTmVJEkStsFzQzmI/eI9NcFii4pJiSK4F+sGFh5tNC49hy6wrHbzUvtpcuKLJeP8/7SPxvdeq0VHXOlxo/qYAL1dC2hCJMmXHsUwzPBPDpc+16KP+ZQ
 pdvUOcQO
 81P5yZ6cWPbyGbJQiztFDFUx9ffZ9ji66f12BlBX08KBZ4uLRcfxH2uc7YkD+AL6Gtk6YhUks6wYP5da2zjFopVvc5gOg0dbh1ezD9hg2bO+VG9mh7VvF/GNdeRzW57mqUfB4A9K6yC1KvG0Io+3l6i7MiXLXPAgV/25mvAIMSiZEOy4pr9ruDoXooRF9oj2q5yaZlyMS/3A98AYCm+exuJOExICRUF08dtYMqDCuBNMimwnenOEIdGddwCBRTP24ilOLVzTlNgTWc+mAVo7pVDZPnFv/6ngQRBF7397juHOmvtm+JFUF13QpHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_slab() contained an open-coded implementation of compound_head().

Replace the duplicated code with a direct call to compound_head().

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

---

I am not sure if this open-coded version is intentional and required for
memdesc transition. Drop the patch if it is.
---
 mm/slab.h | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index f68c3ac8126f..970a13ac5b8e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -137,19 +137,7 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
  */
 static inline struct slab *page_slab(const struct page *page)
 {
-	unsigned long info;
-
-	info = READ_ONCE(page->compound_info);
-	if (info & 1) {
-		/* See compound_head() */
-		if (compound_info_has_mask()) {
-			unsigned long p = (unsigned long)page;
-			page = (struct page *)(p & info);
-		} else {
-			page = (struct page *)(info - 1);
-		}
-	}
-
+	page = compound_head(page);
 	if (data_race(page->page_type >> 24) != PGTY_slab)
 		page = NULL;
 
-- 
2.51.2


