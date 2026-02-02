Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA38E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74016B0113; Mon,  2 Feb 2026 10:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DD96B0115; Mon,  2 Feb 2026 10:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1FE06B0116; Mon,  2 Feb 2026 10:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4D76B0113
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:59:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EA4CB6E48
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:59:03 +0000 (UTC)
X-FDA: 84399975366.15.EA4F804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76E4F18000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:59:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpOydMld;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2pnQO0FL3JmnvperC8nJTusQu+LDYD5aKc2nDrZEuU=;
	b=uc/SXZhy+0qu8HSw+FQrfykecrW6Kx4+Dq2h2YQRZdQKGaOh7BJT+i8Ji0U3nYWyDkQ7ww
	RAnVGzom5Rk3bJ8+SVTcjVUUIUeZk5mBV2F/45vF+3r9GCSUjilSE6lPqNdoSPte6LqHAI
	T+enpudO0jnlvhwcNEhkdnJ36MMYL/8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mpOydMld;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047941; a=rsa-sha256;
	cv=none;
	b=IMtK5w2QggmFMCOXOvufpnYP+KLR9Yt80CxhkBczb1umuv/0mbXMX7o0YYbdpKYZdHlsqx
	mSWKHW5zN4XLrWFeLE72UoBRLoOLbnf0OsCOY9e7VGXuyPEumTJA2RFOdrhyZr2oQ5VzmI
	5GahISBHfEz7KDYr5peJITGnsAfwNJ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0203860138;
	Mon,  2 Feb 2026 15:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DDFC116C6;
	Mon,  2 Feb 2026 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047940;
	bh=R91tSPgHS8R3tSxlyTHy32NvxCdn2aqL9vpLNdIzhxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpOydMldGE3vDSIAxvLL8F4Uesmjk16CJnSt4BkLpAEbEehvSWDSw5uNDFNksUp18
	 T+Vhq/vg4cKq54yC9K+zru9IALS87gEyR4pIsdDo3a2VQb0175M+lIWA9Ociu1O6B1
	 +F+MXbDe5knkmEArn+geGEJ7lPbijY6/l0VB7BMWFsrDKhvSuKYsuPEJ/4saalpu+8
	 VxZkmCMe3tPtiK1Two5OYiK2pO1aGQJzBXfJdn3iWCGQ4WtQyRFLmA63V1767hHJbd
	 Cbcgu0rA8ITNYPIVllDHwrM+0XlhQ/jpKzGk0BC32mxa37i2ttf8kIuVroYp2CgvVo
	 rLl4FA2pL5ZlA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id D8F90F40069;
	Mon,  2 Feb 2026 10:58:58 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 10:58:58 -0500
X-ME-Sender: <xms:wsmAaZ-Fkqltl_3qylb1vz37HPIPxk1JPI-ZnH3HZk5CdPtI9mP1Ng>
    <xme:wsmAaW7ItDfYu1Pl2SR_PZsIM-nfn_BcLi_AzhtWLYZQv3ImgbkOYvn-eh_C--w03
    vAUOn0PsOS3-Jqp5DW9fDiwGNkBcCUXBOvUegTvj7dBrhr_rQRlgEkD>
X-ME-Received: <xmr:wsmAaRIMIkuVYKXtGFlAfcedkVr4PgylWT0_pkHCwq3DBXmmQyey4GoZ-WIXCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:wsmAaeWiEo4nm2mdVTK69Z7O-jXyHtKv-JEBbfjE4aEPINXH4pAwCg>
    <xmx:wsmAaaIDIOIylVOh6IhDCHd5ij_mCIy1UV_CRx6XlAZxMmdC7S6xig>
    <xmx:wsmAabybiFyot6eW-nXctPYFcRv2NSZ0NvrH3f7SfknhvPLsZOpKEA>
    <xmx:wsmAaeKeyuedVcg4MeKgE4jwA6WAbW8ML2cGXY4VNJQX82XDU7r_cw>
    <xmx:wsmAaWSSZJ7up1Sfzq7D9w41W_ggM4uBIdlN14bHIZwl9Q2fOYFd0-8_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:57 -0500 (EST)
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
Subject: [PATCHv6 17/17] mm/slab: Use compound_head() in page_slab()
Date: Mon,  2 Feb 2026 15:56:33 +0000
Message-ID: <20260202155634.650837-18-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76E4F18000E
X-Stat-Signature: mci5tofeapou488g8cnu8eaxhwytojb1
X-Rspam-User: 
X-HE-Tag: 1770047941-171472
X-HE-Meta: U2FsdGVkX18dd/QsQOJr/Os1XvIc+l2EPRekl47yMav3SzNJVMlKvM/19Gkm7n3Z/xeGLk2BUB2XQjQOYR51UwCzCGjz80PRc74a/eqEwIoaMEQX8F3Fuh9wHGDcJYjMREoNHYnWoStwN5mZaa7BgTh4zNM8guV9z/hnzwamQOZpkgz3Z4EwjUyKEefynJNgOe71/4xq67O675v6gGSiHzkVNucamgoD/PDVE6xGmi9eRxcWVaumJtO3kWRtjJay7K9nQBKNr9hZkwsoquGs5ANBOs5XTm2dFfmOV4MPTLKHVKEQTPJGePvPOWU3Dw302NvA77dh5egJwZtIAFn3z7mtbMnfu0ihfdcVYC26ALXj8V+P0s1vDctJwU4o32x7MKXc/fIrWKOKoKwqAYUhEXsujBAptCvmu7AloDHSYh0xQY6HDH2Mc65FDkzUgQxJO5/smAWxjyY9n3WovGPtccOVzsU7DaoYmaqTbyL6EpQul20luFETjDx8DGbEIl6sfeJYHneFCcZmA6WgYaI7P5B+PsiOpQ8MxmIvi8IpZs4AVXiZTVc99bBOFsbtuuDmb2DrR/RkDP5J+a0cuRHD0lUgv5peExn1YNwa1swS4KW0vIrb+7Q3ehn5PAP7sZRM51cF3qFIn0bUQV8KrDjLZlnHR3njnY9iSWDqzXR9EGFJjmnnKlURbVCsHZvylwLix6NSG3ylKDk7P8j4BFc5Kr75AX+FEMkPm7xQUTUkBVCujWrmF2ZeVLp3iTgCMjjP2okbjhGwY9NeP7xdZj2lFIYyQVR1zyM0CazXWr9HlkdCojL72bpovPrwASQk77Nhrj1MPYsQkaDZHui+M14GNqI8SWXSTFdxxYe040pfrFrHWfe0aYYdv46hHA9XMSSyscKqapxMs+lzJ35RZW1yGrsS7IeGk1A/qv9yzRxNuK9Ql9fpdMMZ+LcSOPuXpb20ESafntu/BdYeBwoE3/+
 WE3hO7yK
 InAaCMlQaFWgCbV4hE5ZRAnjO/PvBIm8E/CX0r+y4O0CPJfo/n4zkCAoSiqaTl1x5wLHicRr2TvDR/1suf2sUHEhScWwJ76L3geklKOukp7gkJQLeY57R5UE9Mlsc8zW57cjR0wjIzhQn1yIMa+l31ZEvCcMFkt3siwj36XtvuT8QmgQwGY/g5c6vYi4hbLAJSDazoetmvnZAwmM9ohD4nLixuKfcWRtxkQ6flh3V+MLHdYmj7C0ll+hN+KEGdgMl1Nrrzs5BnWgibZbYw6wVtyBWC2ldv0UnICIBMPn/IMVC36FPiTZXG7zm2A==
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


