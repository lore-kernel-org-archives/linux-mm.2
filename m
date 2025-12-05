Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECDE0D3748E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5095D6B02D0; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1A56B02D2; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381586B02D3; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 222406B02D0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5D83132B62
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:12 +0000 (UTC)
X-FDA: 84186443544.07.4416438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EEDB4000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gLf/PxO2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963850; a=rsa-sha256;
	cv=none;
	b=E4awuCC1GANejObzOv5ZDen6t1VcCNQT0KENVkfTTTPrNeO1I1tvtgzlv6vxSLknqVWQhM
	koDlWxSMioxVSppu5TKz/0GEajXAYsvHLbNrCbGmmzoToY6I3NDOAlX89BO4AL+TI2wb3i
	azFQ+3y3ThHbkpPsUg9HZdznt6VIdWk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gLf/PxO2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFRPqXGKGkpVFgLpMJdZ9M3ASCrs8FprYVxSnNYjZZQ=;
	b=UElSIpLjiq3KDmvoYi1rNULc/OT/cOqq7/YfTbt7VaJ5NqLQabr6c92cjFRyeFrT2XNmM5
	dzDmD1BIgG1ebzPZ9I79MeT1+heJPAyOefz1UdJj4/WUV1Ev3fPZJlB2dC7fF7+Ky5dnNU
	eZmaeeUfCdFmy+bSYDfHf3E6IoMYYME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D371544076;
	Fri,  5 Dec 2025 19:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E7FC4AF0B;
	Fri,  5 Dec 2025 19:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963849;
	bh=vhq429tIDs6D+pc33PO6NtrAK6m6SZT/09TRSadLOc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLf/PxO2bIa2dLsNQWmR3fp7RUrn173XdagBc/dThaXfI/1qYUq32/aNQjfu2yZTc
	 qkF4cam8ltdgjwlqW53nmM9v6FlPVYuJrn6FJzIlUJE5FORYNycBnhW8LTtsKAmoCI
	 oiIEg8TId8GDsd6sCvPZmMp3/9gjKfC8za55ldVUaDYeDOFPWvS8b0VStgEAje0E6/
	 7moY5p66hY07yVE9lMT9TrTvey+YiGVER7i4CNA1d0ybI3D/51Naw7JOKlLzorfxTg
	 VCESekFSP1WkFk3YzQsWkB0Sc3co1usThtKhhEJbWU21TrRcWgarg0IepuNhE9Ij0k
	 FZpw8mYgSwCew==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 76B72F40072;
	Fri,  5 Dec 2025 14:44:08 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 05 Dec 2025 14:44:08 -0500
X-ME-Sender: <xms:CDYzaefIZCTiqGXYT5WkuWRJR8sscdkVkaL5JToyA9Y76EPlq3cM4g>
    <xme:CDYzaZmrd_RLPJ15ayil_GEj0CavyYqE3Gn2EDtHQnXxiyUKKyJy9ajyklkeAdpHT
    KQxSQQfdxCXtpKuuwPno5BwQ5-adFv0NOGyFqRDH7faEpHMulZAPD5S>
X-ME-Received: <xmr:CDYzaYxF4hWozMdNyo9CCCCe4Emc9wGVPNRBbIxP2BICvrdpNVGRQ5IP89Sgrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:CDYzaUMb2iRiA5kEGlZbJmJdxlsxBBb6tLUuPccIGtppBZ-jCWla2w>
    <xmx:CDYzaRjXxfZcYsBbj8qyhp0d6vF-03iuSZNVSklt_yJ6wgCPMXUzUg>
    <xmx:CDYzac-CfwCtvoil9w1pMlLMt5npTKtBKiz17Ud5d4zh0ffwn0xNRQ>
    <xmx:CDYzaWL-k5DV0bieawBRqM7csVn1hagY5nwUlNkNqEt1OU3piNzkhA>
    <xmx:CDYzadaTnSjredx5HS3876LIJPKpoX8hnpt7Vyfy5GbW5qIqFHwRg7Kd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:08 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 09/11] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
Date: Fri,  5 Dec 2025 19:43:45 +0000
Message-ID: <20251205194351.1646318-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3q48aj3a7jfnprujsrcwf1yuupb8fyiw
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EEDB4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1764963850-68933
X-HE-Meta: U2FsdGVkX18ehtSCtGdBD1EB+yIF3ENMck7Zd1h4/dSXu521NVy1VEoEF8V48DIDVct4KWi5FPAUu1DOkW+43kEAQQVh7PaLdbiE3kUMzfoUUXbv+PTwufOatlcYtAVkPEnhbk7x/qeRdwjjOlB56xFQjreyQhUqyh1xeQB0dcCam5usEmak/Wy0bxnhVxAuu1p/V9DrMWTytNL/um+vEOTDZFx9dWByqGc0+s67yZSv/tDvzWzKcdU5W6IlaxGouSZ5PSz4sBed1irWfJwo6oxFxwNBYWgkXTTBYooadNiBaCraBEAh4Vdwe8E0I4T1ScTwKV11OGPVvSfBcPDeLVBQSuQ75OEuTCS/MvDemEizGZVjwYgcwkfknGx3XG7GrZ1sBPWnNWI4MpYeBov6SYYNmBLaKAhPmrsxHoAfh9Y/wwLKoGC/WxIWenrhf6PBZuWYjroEPcSJc+XY0yIMdsBTa2INZwtS+8QJsQ7WTG7NDK+X1vjwLIwHvuCDSUrGEfSc21jCnHCCCmRNhgZWMcs1jvfGBxoKrF4C6ZYEOvBQy4zmK8WeqrCy2S6zbuYUIdekh6OcJbT3fipAUZCxBWl8gG+H5QiZEgnip0MNU3nGrvju8GZga8BfC/pqXFOuoxLfs1uh7vcVCHtmX8OIBCzyRxGWT2Vuj0DhH9+Pj35yJ6w0uT3XE2wZQNKBFdctZ2FnxY7YU2ZW8pTSdvPnsjeAm5Ma+JuqxfATjpN/B93ifJEjwLJJJBVRaT7/ExmNsX54GJlyz2barMijxlyrJaLDTv1oH5I2muY5e1K4cHscdPtKPeyj3t/4bkD+8IXfE1SUtQykjVz9/kLrhuUDV/hNl/vdWEGSELt5bc3DRruXntLMIyPsxVCetOEl1RJxpHmxrjobsQOUkkl2fAbR/wItnh1aEWzi9UTOq9vrwT+4sM8TaEDbdl+ndsHCAL0dZhecqt2Lo5hmeQmXVFy
 9P9Oav8a
 jdE/AxqDjIfCOIROEmGp4DbQpyuwwgjSni/7O28y+wK/lojEkto4r0GhQnaf9jtzSsNQsKjjwg1kAqow7KLTMEn3cBau6a0UrNPBIQAPOOIZmF6/RnrrG21UcRTKsL6UlQtBZekdI5LfwbgVHiT1wEAAWtfuHYqd7DaHXf1RDvDddDIuSkJ6MaIrWyJIw7jAHYyi1uDM6pLgk/9wxjKIhCWUKJcBDmFSKsLtufSl+qL4mDQgvkk9e5v/z2EJVi5IuL/kTznGJtmk/mle1iC8ral84IKX0Xuk3mLrE5jgil/6eCEZ0vj8wmHNs8XanEgle3/arDdY0prxGfvzRgoDial0p2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static key is no longer used.

Removed it.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/page-flags.h |  2 --
 mm/hugetlb_vmemmap.c       | 14 ++------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8acb141a127b..02a851ab7f5e 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -198,8 +198,6 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
-DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-
 static __always_inline unsigned long _compound_head(const struct page *page)
 {
 	unsigned long info = READ_ONCE(page->compound_info);
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0f142e4eafb9..81f5160ff216 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -399,9 +399,6 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 	return vmemmap_remap_range(start, end, &walk);
 }
 
-DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
-EXPORT_SYMBOL(hugetlb_optimize_vmemmap_key);
-
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
 static int __init hugetlb_vmemmap_optimize_param(char *buf)
 {
@@ -432,10 +429,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
 	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
-	if (!ret) {
+	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
-	}
 
 	return ret;
 }
@@ -548,8 +543,6 @@ static int __hugetlb_vmemmap_optimize_folio(struct hstate *h,
 	if (!h->vmemmap_tail)
 		return -ENOMEM;
 
-	static_branch_inc(&hugetlb_optimize_vmemmap_key);
-
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -589,10 +582,8 @@ static int __hugetlb_vmemmap_optimize_folio(struct hstate *h,
 				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
 out:
-	if (ret) {
-		static_branch_dec(&hugetlb_optimize_vmemmap_key);
+	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
-	}
 
 	return ret;
 }
@@ -658,7 +649,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			register_page_bootmem_memmap(pfn_to_section_nr(spfn),
 					&folio->page,
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			static_branch_inc(&hugetlb_optimize_vmemmap_key);
 			continue;
 		}
 
-- 
2.51.2


