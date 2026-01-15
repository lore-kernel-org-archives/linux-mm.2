Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BA4D44C56
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894436B0099; Thu, 15 Jan 2026 09:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED966B009B; Thu, 15 Jan 2026 09:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E35A6B009D; Thu, 15 Jan 2026 09:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB096B0099
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 329CC8B5D4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:26 +0000 (UTC)
X-FDA: 84334473972.22.F502E27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1710C140010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZikTKWW;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6E05Hy8xHaSq43VuRLBZRM51lfVX1GzuKTZsLwlTSyY=;
	b=Ig1Zcy1jY7Ord4UwduSrXEPrgLhpYysr7gU8YOB6724iKc9qdbbSaZGZlw6tLLBXPVqP1m
	WN+bhi99kALe04aNuyfe6J4aIm8JXwY2e8nunotOm4u8TkJI88nNYITebIuVEWEgTlojdq
	efODbQlVnjHIcahpXRdaEu0LkLESlYY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZikTKWW;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488384; a=rsa-sha256;
	cv=none;
	b=bLhtig30h2po+QpExVHiM2qI1speS3AGYmPncs0zSPNdpUMJ3LW0v3xMj7aFGS5eDEL3ys
	rE9wLGQpVI7pGLdUabLBJHsJ60A0pMXf8dBuXMB17pelva82bROh34NLLUpOOHdhcsnYed
	dFR5n8qc7vltjODfmXg91Klvrd6d1IQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CF7644410;
	Thu, 15 Jan 2026 14:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89C1C116D0;
	Thu, 15 Jan 2026 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488383;
	bh=6g9s/Zv5Bx6BabFSpoMhFmX+Y4IAWEXocX3aiWMnCgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZikTKWWRDRCncKDnsWIQuNB3lIxtLlBsbSUOlbBs3oJB3Bzbek7Y1pB8x2RUgq/T
	 gN+gyS2t/ABkcjykSQ7QYZfvOlLpEhN9d94MN3JaOQwn8P0nQbJOimRXtbZ2g0Kwgc
	 Pa4Vihv4FpvENgxaNep3Wi88Dv6zSh9ePIPZ1yF+a66L3DIJRpi3jPGq5NFXxmfg3q
	 mKr5mKXFqrX0+NZzdGr8nOSkqdKc5LJoj3bTuP0RH1PRd19TPiu5p8Oh3uEUV9BD9M
	 2yyoS0+CbkfUWbMd5V2ZHqBovGXKW1xorCIuV3wBGKNmWCAhKt1mC6u/K25n7+WhJz
	 jtSGyDOSOLgvQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id E8866F40068;
	Thu, 15 Jan 2026 09:46:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 15 Jan 2026 09:46:21 -0500
X-ME-Sender: <xms:vf1oaVymPEzPHNKiDVkgp5BBK14Pl7vpbDUein-JD28T_w3w8WK6Mw>
    <xme:vf1oaaZxeDKkSrAZS_e0E16_K3rPoguVOm5iZ1skzZ69pC6F3i_xO9xNQ7dqNb8dL
    lAv-LgQv3gT9IfBBEXJ22GFk12g-QAynX1nZ432kP4hE3Z5Mvw4MKui>
X-ME-Received: <xmr:vf1oaSRfPen2a8Pq9IqIVrqLR-aOMbiktRd1pxIV5XgyZSS43axHNg6PdVmRrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:vf1oadgiGJM1-h9PJssj4IKVbs0nQrUwCDG6TMIRneHnvKmEAbd7GA>
    <xmx:vf1oad40uJuKdKOcskNdsejVIhJ_Ofj80I3a65kiMzeTteqTjGiQzw>
    <xmx:vf1oaYndqRb9WegMFAfpBN8DNdNbNhGWIJVCC7GE6oRVCZoFjoyCwA>
    <xmx:vf1oaWNTG5_wh-3ycIHLMakdoht9kCcUXXb2JPwnvacOZ1RwDz1uow>
    <xmx:vf1oaSosPYBTbR9kl-glKLqs80Lz7CkKDtAwQL_UPZYO1g-PiG-oXMEf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:21 -0500 (EST)
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
Subject: [PATCHv3 08/15] mm/sparse: Check memmap alignment for compound_info_has_mask()
Date: Thu, 15 Jan 2026 14:45:54 +0000
Message-ID: <20260115144604.822702-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1710C140010
X-Stat-Signature: e5f7qehi9h4fgposjomhy4pcqsnpmqf1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768488383-68069
X-HE-Meta: U2FsdGVkX1/xi5jnBFbTat/kXcKFbzY63wX2uratP+XhTwVWCxixfEb1ByiFebelue2cdUNdZbTyqtjXi/QypuFcXvkPpOneL5LTQE9nD8/s9/kuI9dTewSQIZKFCwEGBjp6eqOd05vp/YI1nPPRKDrGCd2xGbK9BXqZZsqX5Je6GdO8RdSuHZ6Y3Puz/VY6NJ0ZTi9UP0kLr3FGQOi+guAZx1v/UvK7Iz77JXYnWWpR+Mumu6kjZxuoKT1AdH5E+/alLRotQi6OFyMwOLreNfehmUmi08O+QgwJLoTKYfhyZX1lbWvfzAa/xnwAD8PSchrKk9UIDPkDia/OvoTbzZJwb5RfPJuaExZ9DHYh/0GsQbbjCPrYoAhBWXD8croKGArCt68CHgB+e+zxDoiCjy4dat1IMj8k7fwYmEUUwaISY7VroXDkWmr1F70JYnedQyGSE/+M8jy9lYIB75t6vwjlQAh62woSmKNDWIuemfh5EGGWaP1GgXoJ5wLxvtl3awiwDRYh4/UkI28TZtMi3sLeLTbaiOn4Hf28Hs+2Y4TpzsbH5VXXE93IYkiAoZJh+1jrFsjUlFSUGt8YvEPNpDCEDvCTTz+jB2OVHotaf/dKdJm5Z8Z+ht9tvfnYrLPgoMdV2sMHEMF7BxjZbwdso83ek3aeHk9HagMXR2WVFG/P87Q43SDUKIYfXmY2C7G4YREyOrxvBy/Ir+Lt90dZSonIN0tt7BQ4cx8ywz61saCnKz18gZe+5gkyqz6D6bxpAFfVxxsOkbRYodf5flZ32dBat+Q7Wed6OI0qZfT7qJNZE3GB8D6RXP1OmNlGHydHrck5DN0eO0nBG85QLyg60boILI8J/ubuPtc8EE8/NDKYf5VQ9yh4zB/hULJXRg4tmnyeKvi/38Vjxgawdr43bS7SWfKwkm84nw0qOoenIB/X2DEy2llGMZbNj+4HNFmseKxtLIFWuOyUDIGqMfy
 plQ+WiaD
 b07cbP2cNOHz2dRDEL2L8D32HIPbsDnCzEtxLWC2Qp6LIMqHuNzcmYXKQEjiMy4JCciUJrMm4ujapjEg7H5GfaNAwuAcJGUkvo0eEBmTWA9OdKq0VSny9oMKIEYvHP36meLCijgptwCr/JXKbvAqNbhUA8tt4jjZhT8sOoz+omshWA8SW02nNSrq0N3Cag3ufaRV6mnLkm9ALw9dK/A/rs+t7aR+3RV8jUpyWmM6mrGCvQIYtrE5hhpTjXTtdOMnXAg+9r5XriCgt3a7DArlddQzZrBiH4Nw2CvX5h07AbCRZgm+WI5dsBSZbEY5kNEAcx3rdfvY0/fF/upumslb8dFysSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If page->compound_info encodes a mask, it is expected that memmap to be
naturally aligned to the maximum folio size.

Add a warning if it is not.

A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
kernel is still likely to be functional if this strict check fails.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 mm/sparse.c            | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 590d1a494c4c..322ed4c42cfc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -92,6 +92,7 @@
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
diff --git a/mm/sparse.c b/mm/sparse.c
index 17c50a6415c2..5f41a3edcc24 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -600,6 +600,11 @@ void __init sparse_init(void)
 	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
+	if (compound_info_has_mask()) {
+		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
+				    MAX_FOLIO_SIZE / sizeof(struct page)));
+	}
+
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-- 
2.51.2


