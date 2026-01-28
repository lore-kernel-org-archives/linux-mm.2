Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ADA4D25B7E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13A76B009E; Wed, 28 Jan 2026 08:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1E36B009F; Wed, 28 Jan 2026 08:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97306B00A0; Wed, 28 Jan 2026 08:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C66EB6B009E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:55:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F5E4BA521
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:59 +0000 (UTC)
X-FDA: 84381521238.22.DD8BE6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D93C020007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:55:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aSfS4zqk;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5itD1SDwquwWs2ds/5ZXa9iuE390ctktQFtmzlQ5/0M=;
	b=KUDEPiXQSeklE88Y1EWYKVNWTdJpgIaDp0QZoW6CYSRypPimKWITmI3TMtkbf5gl0iq2Tg
	TfY66Lu+XZ0wv2bhLhf2i97asj7jYNJxhvIdDpRfByM8m2UzWL0swdBtHNiPhsmQIBdQlG
	W62HfLWe9zWihCrZjugvT0Ck08mMfv0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aSfS4zqk;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608557; a=rsa-sha256;
	cv=none;
	b=zj52mPgQJ4pvBrujZl01tgblwC7/oVtoexT/VhqLnZuP+tP3xsyR0ZxQsDv5Z0FuRDNJ4g
	7dK+g5aHCf7BdEW0ktbjtKR9BC63Dhpw0lxphZLmFe7EkdMtX6u6OtZsWqRy7KecE/XDeN
	vj7Tp3jdx0KREUgBCpj8XoMK6aF7zQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63E37600AD;
	Wed, 28 Jan 2026 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4842CC16AAE;
	Wed, 28 Jan 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608557;
	bh=gSmvqtqPx9nfy8Fha/oZ+Wj5/HcAhp/Bj63bLn9BVgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSfS4zqkiQirAMa4sg/10S+f9YjL+SEBWnjL0oqrgw1ZwGZTJngNAJ72nT96X4RJF
	 O/bCFOF/CKFdCt/MvG1wQqfVU/YWfUb+mNG+8RZWLYa6Dhilo1NQkkmjsVb+PUVljX
	 HWt64cKbkmU7VMQ3jLd1BQLb/iVPvprRxo+s+cN/8yHRaTgzpVWdzM8PhhLykgYuce
	 +xyu9QnskUWVexe2pVLB52fJzgPbhvuhOSdgmNFkhfI/gg2dE+TBrMQWk5+uu66ljc
	 sFCJwrGbQq4FLLZcyrJsjybQQxEPTfNZ95iO5Mc5q+zzUjNlTmJUQ2XyYlh2G+11UX
	 bPUclcasHDNrw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6E120F40069;
	Wed, 28 Jan 2026 08:55:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 28 Jan 2026 08:55:55 -0500
X-ME-Sender: <xms:axV6aXA1ExlFUtDBWzg_bt4IS7G8DRDTfKBgadVokIPfMe44t7P7BA>
    <xme:axV6aWtqIaLFmJdFjQvxneGi9Vq0a1wFZnURiMxdK1iYHxxGTN12HAAX2DQxj4m32
    f2pSZYcgqUUG3RehqchugthcLtLok35BOiA2NtA8wRS8dKsZCFrUw>
X-ME-Received: <xmr:axV6actSKPCq5Ep2tkcGeMLxa5C8V1Sy3HfbLg73XsNW0jvicy-nlYW6k73Jgg>
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
X-ME-Proxy: <xmx:axV6aar11BVtW7su70KxKpfacmLD_KKRjs1rwm6RxhxOdIp00YaVgQ>
    <xmx:axV6aYM_1mkvTrlwWWHXImp-rSWQUlnT-77wYrYmJk715njwpiubag>
    <xmx:axV6aYlAWDB55avl4rhWdKNXE4lnVZUNustFAxp0wNwJUNt_OJp7Xg>
    <xmx:axV6aSv4P1g4WQ7uiaAQy7S_Lxydyfvcx6CLrwmCDWTtD69dspLNlQ>
    <xmx:axV6aXks34t5g-5ItH6OTvzh9pV3ClyBtjP_MuqKX10NRTLBcDUU1oOE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:55:53 -0500 (EST)
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
Subject: [PATCHv5 06/17] LoongArch/mm: Align vmemmap to maximal folio size
Date: Wed, 28 Jan 2026 13:54:47 +0000
Message-ID: <20260128135500.22121-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: kcrprg4pqp6btxo4z7c9k4pb6sfmurhe
X-Rspam-User: 
X-Rspamd-Queue-Id: D93C020007
X-HE-Tag: 1769608557-452544
X-HE-Meta: U2FsdGVkX1+UlCINd8f3izeC0CvoJradihmzqgO6XXDjJYuZSKIaw6f+GfRWYCgxhRl7X4A3Ibvvgf3ztrEQG9wSfLo2RNQHJ+fUNpaCN0aVFf8oXR7BVex5ZIxVYUZmi+ejVIuoMPM5EAhoR92TpIpIG8MhDz/Nitg4W80VQ+cj792zOMIg5TYaLfNU/aui3X4BWj6AUjyKpBB7nhFDbGCop4sM2eNvIQRTI+jF5Nn1so4ODeqCTofutN3RKlqdvXZ3aTL/H8Tpdf8Y/VoTS9L5gzbqAwUVl0LRt60xYbCV+JgOYo7dDOb4qPC9kNk5l+UXrmcd15EW/sUPyZgRkIiAjmc4//CwyG1ZiNjlQ3QJSm6AXBXKKOx+viXd6JntRQhBRpqcGe/Xv1j7svRow8SWGJ6OrB4pYAUH6fWqgYH6fQ6Evpl2R/VNYpDvTFzdCU3oV8d96gXJaWKcVM0fETXtFWaX3gB/M1zBQsIDw/UxObfuFuF4TvPXhuvU3RoaV9BUpBUFjB3Q+dpLbbA58MfXeDH5sPqevU8n0+JwD1LVppNFT2B6ze+dHIDx5dGYTG3CYq3aeXOhp0Ha8MwENHKLVuMQPboZeN6WnZkJeC5end2p8cXKHO0pnp2ZiUhvYILAGd2K5Mmxibt2tOieabZ5PDtCoGFBaJcRMETk38B/2eZDhcxSaIcqvOkdXXsXpgaST6Tf/1vplt2ZfHLiYcVoUoazTzlIf2whQNpsdm9wx9Rk7xZhM79tci/ierJZBJRWgbxmFzAbhpSo9DOLI2G+7JoZJJ7R4Mnzespbgy93gazOpKCjh7zJzx9pqsgrDCG3ScQkFYxHiA10PQOWSro+QGi5S/UjVWCTzdOCOmy9UPYx+n64nzp/yYYB8HJI9UYXnEBhg3rAGUaH5pPTufGsslDvE8iy/dkzJua5c6YAtSe8NbK26A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to MAX_FOLIO_NR_PAGES.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index c33b3bcb733e..f9416acb9156 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
 #endif
 
-#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
+#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_NR_PAGES * sizeof(struct page))
+#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
 #define VMEMMAP_END	((unsigned long)vmemmap + VMEMMAP_SIZE - 1)
 
 #define KFENCE_AREA_START	(VMEMMAP_END + 1)
-- 
2.51.2


