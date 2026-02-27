Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD27FD7F93
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B416B00B4; Fri, 27 Feb 2026 14:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1356B00B5; Fri, 27 Feb 2026 14:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC576B00B6; Fri, 27 Feb 2026 14:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49B376B00B4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:31:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06872140868
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:06 +0000 (UTC)
X-FDA: 84491229732.04.B186DC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A37140015
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/CVW6HM";
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcJ8r9+9myGaXNcmZJTxEDzI8cwMAukJGYfFOhUtSK4=;
	b=mf9hkVJMpijdV/sVmTCU36FXBZMLp5FX9tSK63MdeMRN9QSdUykKSvObdZSW53Jl3D4Ots
	fhYekGkPWc8ucwRIbgKQj0yZv6UHQZYsQefxX313VmfBlsjtFgNrS9z/SlpQoHi1/Jr242
	z376yvMN72SR0XQjU8I04l5axVBBFvg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/CVW6HM";
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220664; a=rsa-sha256;
	cv=none;
	b=LzdmytFmTc414txFUAnAssj02jIHJcgjm1h190Xy84KAGOxdhUgZ/gs8pGhiq+UB+78U5L
	D4+dJfYmUB3Y6+/rA9bQH3g2wz1Fp4KCjRQ/KnsOYqB1+PIf4JSeG8CO/ERyGMgJpc1TrU
	XqvA+TV9JCImJp7vs3e7sqraZwD3uHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 776896132B;
	Fri, 27 Feb 2026 19:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D26C2BCB0;
	Fri, 27 Feb 2026 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220663;
	bh=ZAx3R9GqRsOU9srbTUp+FvCts3Vk9aVQHLhkmRYHaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/CVW6HMplEXh/CaKI4txvDVOAX/dF+GHRWQIbfic3meSWwB6asFDUf4lf3R7q+XT
	 8Epw+rY13eRtWHl5sQOD0wNHx0VPUCAx+4bPf5R2eWl+6AARabe5hsYeRQsXP+WnNX
	 0U1adi3sup8r7ZAS4Lr0k0nfTT+PcQlHaTRN4+cozz3y2fVzt5108kWP9jl3MOk3ZQ
	 GwxmvY+On+dPeSfroEuElzANWtZeaeeItAcT02fgNnMnIKFr+Oo+c0iJG77KQu9j0+
	 RgCkXudzqrx0xhCFJ6b55s9q8wqZ3127e/4BTogyRQ7JWIZYFVKfEYbCWHiIO9kbO4
	 CCoUIiGA7VLCg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 56CACF40069;
	Fri, 27 Feb 2026 14:31:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:31:01 -0500
X-ME-Sender: <xms:9fChaQhVopWkZjWOMOQnBwWhehF6ytvntKXg-pIdJqoDWT-pNYu4Dw>
    <xme:9fChaZJE60_pYl5aLKKlUfNdFNcHlYVfCZu9rSif9V15khcd0KSvR6-yGWTIi-jwt
    OTljHoeiCv_Y0IZAVIUxlFgATzwioUQOLTRM16dJIS2iiOUAnszVXE>
X-ME-Received: <xmr:9fChaV68NTTscTord4Ow0WZvfiFxhEH-dmDSKAdaTTsr4D4C5uP6zD8dw8I0pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:9fChaVjnukCmVwfcvm5KjVi5U0Uayf3jdsyZnupzXdvTC4iPmh-Bww>
    <xmx:9fChab8-p2o6Xa2pyFQZtKG1t3xjUAU8NCmJOR0tmXaa7j6WnaxtOA>
    <xmx:9fChafdEL9XjLjNzFe8DZCvfR0sCqgyWf74Vj0-sj2_6RUKX52COoQ>
    <xmx:9fChaXltPObyp-Dtr57gwPqeWx8QYYxQHbDegrKRA9-JcnYtnkW9Ow>
    <xmx:9fChaRxUNCXbgsg-vF0gmO1UBY5xKW38xAsslC0DhFwnqJQDU12rA4CU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:31:00 -0500 (EST)
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
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 18/18] mm/slab: Use compound_head() in page_slab()
Date: Fri, 27 Feb 2026 19:30:19 +0000
Message-ID: <20260227193030.272078-18-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A37140015
X-Rspamd-Server: rspam07
X-Stat-Signature: nq4u4wwtbwpm3frz9zn7n8jhrrrwpc5j
X-Rspam-User: 
X-HE-Tag: 1772220663-170526
X-HE-Meta: U2FsdGVkX1+4RYP+QmQMATfu4uvoue3/7cc/e3qhde2zt3bN5U3MjToEpKpZK6lkbdIpjj53mguAdQvSG4Ad3nQnsUSWmQoKGpGVrgg4IHoNWeAT6bfiHFplUI/KRqCODZq8lKll5F7eM1jhroOKWQg36z39tlmsJtvQZrSaknmydv2D1UG2Pn3+kcog46QBF8yfHWK2kPH2rL638Mia7D6l/4JTcDn/Pz5jLfrKD/Fb8nC6tmTHrCCovKGz7Cr7ZdBndV7nDtkbeGcmr0DfosFzwgPx5w9VkWigkImUfA/fEh1naMeWeaxF31hU49q0DrqS44lzoEmCl4m64lt1pD9Su6SpRDcolSroZqA+Km9BBUyH7rt/6huvjxQsFJPlmnPXEezvPpHD1hvJT1j8kG56Dz3Cb9hcruGMUoX5Yrqvi6QuiLGkm/TYwBaJQTxJHpWH6oKFZvpfAUFCEoHEXPWIszBvvewUm2+GtWtqvvU46wk6aeKrJ6xFdrBgyMs+hksRmt6cYwyglhoJpBQ63pD6UkWA3qXYvYeztCCwpjI4W35/yl/Vqn3rQF6Kf4yKDjSSdY23fRB4RxyVoPg1whKlJaZbO4J/I8iyas5IZENKmH1alr1E10C5Uk9fgMo62WcbYn2cCI0ZCIRoruPBqB7POVnuQlmojV3+i6Dj0oFm3Tr4t9djlZmyXF17Xl6FY22FCkY+opdBeD5Rjy8kP4ybUcDcW9NmsCyzQRHa2LwfJjTO+fomwj3gL+BSaBz9cHHjikujwtP+fq4VESXgShoEzPAV1QTw3XpLNc0+Ja5JZNCjKUXogcHNQIgFsWsKDyDFhj9znPH7VONyCkq1o/DqCMzk86WnRxhXeF2BOG/O44M8mz5vJarpGzCIjrW40Vch6R6BqmB/Ws3xYSpvtwFjz8B9AmnSZ4vRQ7XsP1U1w04ImzfjtjW3vGWeB2MPoWZ1HIrJScIobriLof8
 8JiQqCm2
 mHTD714wJCwDoVJ1KjvCADo0eo6POqp2+xg7c8+U88ol6C3s5F1Q2XkBZ1zfxmraKNSk67Oi24Whe1W6ht8csS2HJivMZq1xiitAlmyMiXe5Vla2izlfbwcQmvbHlUW8KnbYaTIhHlmBhJKQn4czjpSCtsnIMxAIKvEyIuSztVIYukfIXHGmaJLx5M5B5xs29nzR/4q4wphnbR1MSpuZnVotFj6CTseli8hQdRbVRGwI9Fmrs0tvQ5WlKys/WznTOFtNy4ohgNYNUCbSZcxowss8ugj+S6CObj1QQ5PRw40Dq/l889lcAKAj6kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

page_slab() contained an open-coded implementation of compound_head().

Replace the duplicated code with a direct call to compound_head().

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1a1b3758df05..7d3b929019ae 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -131,19 +131,7 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist
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


