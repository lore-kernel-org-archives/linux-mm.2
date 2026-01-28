Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7473AD25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB5C6B00A3; Wed, 28 Jan 2026 08:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72F36B00A5; Wed, 28 Jan 2026 08:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89376B00A6; Wed, 28 Jan 2026 08:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B29DB6B00A3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:56:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E741D423E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:26 +0000 (UTC)
X-FDA: 84381522372.20.63FD100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 700F740007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fp6j4ESW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608584; a=rsa-sha256;
	cv=none;
	b=NSmS7x9jonWwnluj53cs37HGW2RsYEyDnBhqRgpJx0HtvUlGV788pb2Ee77QPJs7jjgFCZ
	cam9U+uzJOUvMcWgMTOnJ/bt9I/uBBD9AjyWJ4CWQ3OrV9kY6XlKAwqbzVklkM4Dc8Y6XG
	f6georinu2fRmAl8VZ5asanUgTO0vVQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fp6j4ESW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kpHSoXqxf5GjGcePqDn3nxWI4t4r0fImtG83P45AeQ=;
	b=EAWrA1Tmr/Krm8iKleCARh+1yMY4U4PVHuavQlRjqRQZI25f1mfb+Hl8hJrNd+oOzb0RTc
	BnbqhOibu5esaYY3G6D4UcqH0gZLKEQOwK6vHp6aRnaINWI1PhZ7WRjhZjEwpjzUp1tnn8
	h6UuUJQhcEUPqiF1JWkV3Wine68oxYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 97A76402D9;
	Wed, 28 Jan 2026 13:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA35BC4AF0B;
	Wed, 28 Jan 2026 13:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608583;
	bh=b91kl2Y7wNS31vuKwPTA6osyXzCzrCdA/U3fWgaFpvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fp6j4ESWls0g4guXmBtJsetkvINSeuu/OyesPMPmy8o3e+WqScuTVci2ECveqONti
	 LXFyxZ8a3XF3N62st3LxSktINQc/fCHXdNRxtP9nVPOFq+uQORS1bacaG2MLO4hDJh
	 Xf11dSizLpArTYmLiaODHds2NmwSkN4CtxuL9zkLsynE/X24FExn5uLN2AmrpsEVZw
	 vTTMKnr4Xk4L3T27yjpTHOb+D2iksejzQh/xP7AUzRbmQ5Tvtl19BM+OTEMjwkTl60
	 5puOfunCE5kYKdRYE5e1oec2JMNdKRe7Ea1X9fX+wwGI2eEFs2cAyi72d1gDNBIQLm
	 Mvb7/gx4ZdEEg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0BD5EF40069;
	Wed, 28 Jan 2026 08:56:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 28 Jan 2026 08:56:22 -0500
X-ME-Sender: <xms:hhV6aQJVBWYjeWHryXDJ5O2cOW1PVek3og8rYHzYpLSJ2lf2gdoy-w>
    <xme:hhV6aZUHLqTRmG7AUfDcX1BGWm5uikU7S8KP36t4kXQa5eANwa6oM0SoiHoYy008P
    NUBfWOYXZusMUsRGQI1GbTolzLXtyTBGvlgKd-HUdjvYOBAiYhH3Q>
X-ME-Received: <xmr:hhV6aa35cnPVojD9_OXPu_6GoUMYMMWLDrz8mpJJs3QZ-4In4yA9wFoh8tmEuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:hhV6aeQP5eLhTx4zu1ETQKwbDMOmhXDMX8l5FsxIgJiSwhZRGvLs_g>
    <xmx:hhV6aTWGuaoLyGuETHuIz0W1MuqRjjgVJAQoSihAGGlj5HXSHh16hw>
    <xmx:hhV6aVNGuYpQuoEwuiYPN61HNkM3MpC-TOZAADE63U6IkXveRaSIUA>
    <xmx:hhV6aS3r-oD0bU3ng8lxZnNiKzMiwhNQDyr5qgnRUdX-Re2A5zmkdQ>
    <xmx:hhV6aVNwpJsNaS6NncEgFNEDDJvYk6Q2P6s8eJV-rDt2zUwtBpTwQEKy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:19 -0500 (EST)
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
Subject: [PATCHv5 09/17] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Wed, 28 Jan 2026 13:54:50 +0000
Message-ID: <20260128135500.22121-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 700F740007
X-Stat-Signature: iocr3cf7hjxmfc8siwfdj7xjwnysgyam
X-HE-Tag: 1769608584-261034
X-HE-Meta: U2FsdGVkX19NZyQXMbOY3wJ4lJ5kFCA+jENHn/M34vlNjdDL3zeDaaXGYauHCtZDQT9n57WZ6y9/4+Mk30YfVZ7E46fZrJb1QZ7c/gFj38Qzsf7Tl5bSFIma+cjAzNraABsGtJogMJ925XG45jI1envvE/c1T5AeTxDel4AV63au9Qe8RyhKnazuJgWP2aNNKq7+0DTxwanQA8o3WHpgDgsrugwhlbj2CnsBqT10NZ61OU6e/8pjpRzpD+UvVINYMPqs82sxO05AuWKXLv0aN+4M6fDesXhKB0hQdH6cSG/mLurAz4yfMMsvGpc7YJufyagy39awJ6isdamrP//tjwyPL0N4GlxcgSsZgLUMgYcANSlJTdeTHAbSstC2nkOoutVwYE/LPd9i6euo/P4H4G4wPg2in9yAxgIaa99HDwAo6pK+yo4KLG24g3hxoIORdNvOevuJk3yFiKSWTCQNYrdXqoNt24AQFgn3eY8D/nNM+QjhWgDacu8poMNUVbGtWGXHVmK+8RKK2E80dSHCFTPw4Q8OnURQyOqn/DkjQNKAnlVncSgHcra0cBxkEBsLeZQqUssLEP9tzgwY3bem3qI//LZoP6LjsywyNZ8+o5W1I6+1M68h3LiskL23K3Gy/HbCsJWyfQiULGjjK9ljJM/EV/nlBL14uv71fjgI5g17x23S6rzstjw37p+lpG4IwxRkYlXlTd5lHg6nkt6Yi71vvEKdl/WrIgvDP8m8qSKR4IRV0eHOKeI7liK+SP+B6UnzGQKxAcz6h0UIcngJH/5QJei2RiH5CmbdM/VOmqKkjY5eNm5Cx9lcDNJQ7oNIh/dgXrBKtcs84i9pkpDAqdc3vpxvo1kwIw7GXli9myh/VBZVV8VGVmcXzDJqc3JsGZwjgjdbu0s6ivgzOh4av1HIebWF8GcWg0v4fg+NW2caKXgvuxm0I00sLKoznkl8X5jOunbMXMQWyxzJBAb
 eLB2YqT2
 vBN2I8A5tqt+IrpstyGumeIttPcEqMVXJv9tkICTCgiisL0yHbSx/Woe6g9w4lZjjWWIktjr439NRzFHr2+3lw1yjco1z1kOHYIs9kzM2yC8XY63H/x5kPf16ZhJYMrhEGBS8FL+0A3sEccCylZUJe1yHYWxF91QLMz2NSCcpmrMocDubTCZEOkA00OIak6D9plHRwhMZMxylTX1PDmym8sPMkaYrH3QfC6eGftxO1lnw/IfQ9WfpbYR7BIth/q0NsQ7lAOcsPPVGi/HzcprOAqPsNFO7LDp0hefZBENpmGP6XMF5IrnfAvXU9+diyYE9TQBL8nieSBk9SNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If page->compound_info encodes a mask, it is expected that vmemmap to be
naturally aligned to the maximum folio size.

Trigger a BUG() for CONFIG_DEBUG_VM=y or WARN() otherwise.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/sparse.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index b5b2b6f7041b..9c0f4015778c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,19 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		unsigned long alignment;
+		bool aligned;
+
+		alignment = MAX_FOLIO_NR_PAGES * sizeof(struct page);
+		aligned = IS_ALIGNED((unsigned long) pfn_to_page(0), alignment);
+
+		if (IS_ENABLED(CONFIG_DEBUG_VM))
+			BUG_ON(!aligned);
+		else
+			WARN_ON(!aligned);
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


