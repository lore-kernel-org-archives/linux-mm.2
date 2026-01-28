Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9EBD2F009
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB806B00AD; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E506E6B00AE; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37B46B00AE; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C14006B00AB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:00 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A010B9CE0
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:00 +0000 (UTC)
X-FDA: 84381523800.09.302B540
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F5A3100003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2HZNztt;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IekA0SCp0PxuX0VWR3ppv9RUw4F4V9IuVjPzxEhq+xI=;
	b=QXrjY9Y+Eib8+8XMa+QOMwOdlg5ujJ8P6VPnarF51NEd4c1JVVITmLhigesJy7kfE0uQNa
	GZ5yc18XwjC+NtbLbDACv/MQ2lQ1XUzZz+GtvPZwr+Rnc5SvwQAxdXNNjyo2r9G/hKnYXT
	vcfv1norhHsZ7v6d+Dom31zbsEUo4VI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2HZNztt;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608618; a=rsa-sha256;
	cv=none;
	b=gOcrdpMt/eB650iPcNs+E8ezgGt+tiS9WRFV5eOVfc07y6sJkmWEujagNzQud9kUneltL/
	etPMtMQTAPNpBynlBw77bvIJn2sS8prPR7k94zuF2stzopkz6+QV3gtDE6hjp1HdylkXHu
	hShCqPbCo37eUFfBIZpAaFbrgzSJ7Dk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C00D44453;
	Wed, 28 Jan 2026 13:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15B3C2BC86;
	Wed, 28 Jan 2026 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608617;
	bh=/J8V9jwFScp2INMSJwfe65TqSX6OjE7/lS2Qj5yolSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2HZNzttR9S47HYlLiT2TjUsmz/3zG+QxDqwRSYLNPXdAKLmHJx2IFEMqXxUIb9Al
	 VzvxU1MIt+9Uka4xgO9CgKWW3F1iUJH0GzIUOdFcfz4dmRkeq1KBEAuW6RkzpG5htH
	 UK8WyDL6Kqx6QhXT/3Lm+KdmsfozXI/U/t7Y6HSSkSqN7hCpqOZkjn9AnWdOSb4Y5V
	 2CYpdWA2WtuKim3T6HYPTzj/2dYbcRAAm4EyJHZ77xXyt8kqRxl/Rro8vSwpOlukYx
	 rTbleo3bFDu+kT9+DHiOe0gh8M4iIcXQOqiglAGrbyJNDXlchxEh3rXc+wF2x8uT5X
	 2SnrociFGwESw==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id D8C30F40068;
	Wed, 28 Jan 2026 08:56:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 28 Jan 2026 08:56:55 -0500
X-ME-Sender: <xms:pxV6aZgwMmEZQJGTkdBBUFpH375y3foHYhDGK0zbi8q7Y9zVYSUcoA>
    <xme:pxV6aXNK2GUSkDz7fC3nz4sKGg6itah0R9huGtqOdgi7wXhf8V_T8JfvxO7AkF1op
    TGPr_fJ0oacvCE4w43pzjBatxSzXmkQWusPjx76N59w7v1_1Z2tHQU6>
X-ME-Received: <xmr:pxV6aTPmrAnN-L6JrhSoyRc9Qb7d60iEG5J6M5apRrk5fk5KS_cNi7xRfVHYZQ>
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
X-ME-Proxy: <xmx:pxV6afIolyNXFFgNATLFUCybtrTAeNlWlYGAzVQUzTnwfBzNKfKd4Q>
    <xmx:pxV6aSvF-HVWdV-JOaJhE9G5pytWLByCY1bIwtyymt0YG654XmiCHw>
    <xmx:pxV6aREZAEZG7GwRy2jRORfck6fhSZ_83t7QwmL2pPMOhRUSCSuYIg>
    <xmx:pxV6aRNaoerreMj35yd1nzUqnON4lumQBbPEI8KRNLKe9tyAxpPttQ>
    <xmx:pxV6aUFMLM8N_VPr6YHInStFXxsd_ytMCtTWp__mdHJMLT2aENmFBXsN>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:54 -0500 (EST)
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
Subject: [PATCHv5 13/17] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Wed, 28 Jan 2026 13:54:54 +0000
Message-ID: <20260128135500.22121-14-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: cqeued1dn1f3p71zreua4wu9qftpgpko
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F5A3100003
X-HE-Tag: 1769608618-210128
X-HE-Meta: U2FsdGVkX1+tPi+6GJWDr9+CNYghg3uy0RF3Az7SHytwf7Dog7qjeNaqJ48tA+K9/r4CEpg8Qu4AarVr9CNMoqFIf8uACd03G6ym24++wxUZa0sNyn5SBdkls8lFFxGWKUkPsuU9a0QJ9Nmpl7NfclKiwkueKpOqQbKgPfSs9LYlfdSyduW8SVFZS/VPnEbOciKBNgC2GLRdk0bxypWgbU15sK8vgHi67MVWbb4U6qbhbfqwJcNazsFeLHKwDH9Gm2hixIF/VaXZIMBbm6Lm08LlvWZ28SZL27LIGcnj7wwcrYnARKv1hi+uv7xzZglZQfNm/s1A8f/ZTZfHkYaH4a1b+5jP95RpGN2nPoC0CDesDqUx+xFTf+h9PD3noYAgksW0LEB24x1Nntk6wTevCHYdaLpd94m1pl9VhYqv2hPxHw345rg3b6T7Ns3K6bx/nbr7BBQWt0YLis6ttVXNWEbq83kZuf14XQtR1WKFJMnl3SSrH4icZbhyDfQmoeQx1UdPA1tykm+UHIZ7hBWEoPa7xteUJ9CnAfOWNkzFLotwcJF09WS0LzthzvCNohDFAdoibNfldx19Blxgbkiveo84A3rfFlqIHIoG6N2kUmNHq/+di5jjb/TkRELnSe5yxVBNygqPrb7GAxspJcUfrN5V5bAx6ELY3+wxqFbgO9lZqL20p6n+bb5DQJ3s37E89JmfSj6pPgsM5PiVf34V26/stX+S6yWV2Fm4FF4rfsAX3sNSkzutBCV8K60SALsxClufmXTLp09wgFAmKegu/fWglZyeev85eTYrtq7KDsx6lSMjn/0YfRR7/dqjdtmvqn1fkqbGS18KQNsa0M+lVLzEGq+bMssxbpSiuY/XoUEdZgr2+bAnKo9H/70gEyNaKW7ntmAAaNIdhTa9noCuTwVw1z3NxTqG+/29hc/95lqpDYo7ey5UlBZfzvIAlhhBmi47I9qAP+9wKckZB6q
 GUqkwf7I
 XLTPSLuA6i8dn0dnqKf48AbJTy8GgrOSSZVsQW7ZerWji4+SqskLUADccx5RqWVeltfw73hs+vHun6EhsJTvCzTZUwRCpD0TlkJ4HMUf5bzbcvw2KTmnp11+SJYdZJVKR8t6LhYBfkBqn+Buh282SutW+6pR43f0C5ZFDfdKlEE1J4UROKMH1mO8/9ROu/j+RcSu8SvvESg04Bv+dyPoU2faSBAT+MNCrWIBZuLWMnF9uQRlHkMDI9zqFlOzQs54ePRfna54id0Q5UbNx7BdGijGMsk0WV+Y1+fOX0w2K170OdGakpOWHLAf11Q==
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
index f5f42b92dd7d..fd74a164c494 100644
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
@@ -556,8 +548,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -615,7 +605,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -643,7 +633,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -696,8 +686,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


