Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3280E7DEFB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438726B010B; Mon,  2 Feb 2026 10:58:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C5B6B010D; Mon,  2 Feb 2026 10:58:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F1A6B010E; Mon,  2 Feb 2026 10:58:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 232456B010B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:33 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4E2BB6BD3
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:32 +0000 (UTC)
X-FDA: 84399974064.16.D549CEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01485180013
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ys8kOFGz;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS2eukUletsS9rZzSvv6Rav6V6xNbLE31S7Es2duQNs=;
	b=yCqOHlX8IBjf/EQfmqKJi5vzBz2tWJRjhE7k4HkVRNueyh6gCGlODpjZl5Wp8/RXo9flwo
	f2vsD+AhGjgYaghzOsIH08zCsaK3xHhHftfDXPvlN/O4h1vnPgRgg48IDDUMCuR0puQJVL
	7j4Ncp/wOQ5tuzzkueRJ6Z9rMd6MKwk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ys8kOFGz;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047911; a=rsa-sha256;
	cv=none;
	b=SLKzOZC8w0dcCkDuxTprUuac5gor7Dh5p7Z+rdV7LXdU74xNBQuoUITkuRfkYBVaKHWtkt
	2ak6c9GpY0IhRdJ9wbMP8OjcgBiYiWOl1vleu97ac2XQXdWxjvGDVDw9uueyMzO0DPjAmI
	0ynoFcteWrXozuYeU6FEIXKC6mGjl/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74A17600C3;
	Mon,  2 Feb 2026 15:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A803C19425;
	Mon,  2 Feb 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047910;
	bh=+wgCMwzDLVoGNlHRvG/v0S9LNLGN2YQd+9Xn1Ru7uhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys8kOFGz5vMbx3ZOoic6oVstqGRBr1EdjcCE9f94+bTAlhQKzgq+57b3uf4/lWTG6
	 vmp2s2yfGmXb5R57Pu93/s+uHgHJ1O0+0oF/vNl1mbGRVm1fYdf9fizALK/mjixN7k
	 lx8885MJYMWkEoq6gmRhKOvsgJruTlQUgMCLCj6jFrKHVysWAiDZoe/YG7EkCNInF0
	 ZW7wTuOEzteYxyPomg/HrLC/45OMo37cmWTT6nz7CXc1wxxBb4BEXdnHb69FKCFu4U
	 pmdgzsm+jqQJ2WLQmqcdInH8gtb0kn5IObnfswND42lP2HTDF23tDAMiEWjQo0vtru
	 1vbtjMR85ZAqg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id A1941F4006A;
	Mon,  2 Feb 2026 10:58:28 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 02 Feb 2026 10:58:28 -0500
X-ME-Sender: <xms:pMmAaZhEB4dePen6IE9axxH4o0aQJ7nrZwZYE6uUd4W2oy2wCEHyvg>
    <xme:pMmAaXPOiWHDqQY5t0BUMttCfR6wzlcnF8eGs0O0e0tOq91z1S10PQ5akk4v7PgX4
    kXYqPN72zYikau2jn_reTreShlfCUFFodd0zpAb1Nafr91mTzzPeX4>
X-ME-Received: <xmr:pMmAaTMa2mAfGc3fOj9G-sRiTE6XQvm9OFjfYo2yBV_pZQTTNejxAU679_NP0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:pMmAafJMjs4UBGFcrJLGFdJyQa2vgynmuD4dx70khTcKZ6NfB36qrA>
    <xmx:pMmAaSsZi3v2CcWjAnq-39zPULRXFGW1VdHGknvDlbUZ1P_KKzkgUg>
    <xmx:pMmAaRHdxYwUssHOr-vjVbgO7pEATIVob8Z0FjzwEdh6U3QAeoWNXA>
    <xmx:pMmAaRPO7WqK4WgtXu93_R-V4XQIqXGROmOMYpk5oHN0mmw8TYCxnA>
    <xmx:pMmAaUGw8Q9b3gK7-Dn7LUvlhd7mUjqayDZEDhKnLAjrBZGgXAgw2Cos>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:26 -0500 (EST)
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
Subject: [PATCHv6 13/17] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Mon,  2 Feb 2026 15:56:29 +0000
Message-ID: <20260202155634.650837-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01485180013
X-Stat-Signature: yh3ubpo3tfntbaqjhsedrqut4hefoixk
X-Rspam-User: 
X-HE-Tag: 1770047910-858595
X-HE-Meta: U2FsdGVkX18hYNY8bYwjx0x1cVHGucVlXlxsKDf+JzkeCgWAb0vN1L+BeY6n7f/qPO+7clDspwkKqsLAlfDgIwt7jIHclHgiikGvr8ceKJLC45cv7LnT8U+p3UQ4MNzoCW2Sou1vTZpSZqbu6OpU8SrhGpZjlXqmzbayqmNaddT1CVhmLcEyPmf3AHqZPzRdJ8BgeIGBflKhOUAlstz14QHq+jD5OkrHoSw6PmiOS+NOsNqCGXwI4TYW+F3LdpHEZeMx8aJQNEo2w5TDzv+RNvZEfjhtfImLA4kiWebPneTX5fY30ed4ahnr5wHjJ5/GT51n3rsAEXSB/iFgqZ5xBTikhlhWcRMFd15qvrCiW6ne1aSDX0GSKeLy5fJGwQ5vEFenXKctAMq7GYfRtN26wFjFcwZ94qqLrgX67hhObFE6e4UConNp6pb427XE3QkJUercPsl6La0CjybixvyaOvfkcXeoaEgNuwMn1kHJ6LJDmAb6WhyaY0iQFCPrtbLIxejhzVe4Tm/prb6EeUjF6XTrS4gScK7o+2vZkNCfBBfyOjTFYliMUsY2XhjM17I5Z3/aTF041jxRLJyqUexcozqhJn8LKauPoPVPu6c3OcFAXy8YcsxwE7DMr9SGvQagNKoXpcogmN/mGsYSuQW0mBplygeGwCDIR7vbq+VG8Prl8iP/IU9XcyJ4tt/jOPs4VN36j2dUheed7wWSOpFjypqXQxMt/AzfXXmI5Ru0Go8VHiFiHjWsy+1YnEOiuPSDd61TXF4TIB6oJujtIbMTgNaeUc0if7xQhG25OCnBUoUkdGVFn3wJdTGqotdjdY66ae7CApIKt3nU+9Wzs0HUv/SM+/rAKBelYpEwUuS6tXLEevIyjcztrGhutPmZPMpA+BCb0d0nOV3juEGSIXp3NvJS8jrvoCW63b6HMLLpyS9AlMGNFq4v1sgo4QdbKGOs4wVWHHRiMTo2fd1zVF3
 7oNXgnQs
 o1w1faiTqjX3OnmewrJKONZsfaokHQkcuGy3/2YxSs2RgspEisFnZFUaUOCjaDAFTGHK39IH5ofc2AcTonBKR3SCNQ85QHCieAihHjscQgQjY5Vyf4op/DRgNk7/g00BmL+0Q1/KofTzDbyvuvjJs/fDODNPQ/AcazQcqExDw/PiCnI7LAGjlta5q3+Bmqvyjkk5lXTz0ZAKZMswuIyBMFNAPoKRwMG/dhdAeFGpPJzFxjmxZkw8M7pilnDAtLxv/nmA3083B4iKT25AaxcOeDIP+fFeemT63btsxA7akwJckazkRKxoRlP4xlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMEMMAP_SYNCHRONIZE_RCU flag triggered synchronize_rcu() calls to
prevent a race between HVO remapping and page_ref_add_unless(). The
race could occur when a speculative PFN walker tried to modify the
refcount on a struct page that was in the process of being remapped
to a fake head.

With fake heads eliminated, page_ref_add_unless() no longer needs RCU
protection.

Remove the flag and synchronize_rcu() calls.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 688764c52c72..6088fc77865c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -47,8 +47,6 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
-/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
-#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -409,9 +407,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -444,7 +439,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -467,14 +462,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
 			ret = __hugetlb_vmemmap_restore_folio(h, folio, flags);
-			/* only need to synchronize_rcu() once for each batch */
-			flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
-
 			if (ret)
 				break;
 			restored++;
@@ -554,8 +546,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -613,7 +603,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -641,7 +631,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -694,8 +684,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


