Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD41D3748F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD076B02CE; Fri,  5 Dec 2025 14:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8106B02D0; Fri,  5 Dec 2025 14:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98246B02D1; Fri,  5 Dec 2025 14:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A33256B02CE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:11 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 705CF1A02D3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:11 +0000 (UTC)
X-FDA: 84186443502.25.1B6F0E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56A8B4000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrSR2azR;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnqn/0c5W1uAeK9rvxcXnjILSavkm0HtPN63LG/K6nM=;
	b=AHZ6YDlkyX1/GwJ/+8OY9cu6jlcGMNdspBgF36TNlgilePU2SKWgalHkeUkaWjAqI2CfBg
	Mpjx0oBn/EOQpOifMbzUAkt61wC5haLHupe85g9u1B6ldLt5nseYVm1fRk8phX8s1Tjm3E
	SM1OofXH+546ZCutjnDhdmgm43UIYMw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IrSR2azR;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963849; a=rsa-sha256;
	cv=none;
	b=ql8TDNmGMT/yMyH1VzYY6c3akPxoId2ZD9qLJ8jEs1VxGcif5+6H7kgBFMoRAfKqSdrGOc
	JkiJo1PyOj9FFB7lsC2gp7w3DxA8GpuXqtsp4LeIgHJx3NZZGa/wmgjvR8nZ779Andoq8R
	AhmzkKKtP4r498gQSCDyY428JjBLN/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 791E7440C0;
	Fri,  5 Dec 2025 19:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BAEC113D0;
	Fri,  5 Dec 2025 19:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963848;
	bh=U5PAArSwkT6xaG+oWnh1pdHULJkKB8HiCIVlrRlQHnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrSR2azRCEJSUIH2Jw3c9F+KDAtoo1B2MAclcw1BISGTs3nhmGYF1Q75BuylzusBv
	 Qgf+KjjD0G6B7iFg+0Tu7WYYf/Hja4X+vMnPj2Q8rSXAjL0eIWngZD5iy4i58tMEwr
	 /cgsoiRxIK1BATAJ49jnE3PxrsjW1br2nqxRtB2GsqP788wKbpICSMEKm5UVDVaT3M
	 o5xZFTge44HcLE/WrMoIasQNEBrDmiqNbp4W6OAbYmdfd5rUh9kVr4YEnObOygqPJY
	 1UW7Fm377C7jYoLUFsaWuXw1NYi7kmS2DxV9PO/hrqqkyaruz2WaY0soQCcdsg6r+a
	 aSWhCSASHCXzA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 05BC3F40070;
	Fri,  5 Dec 2025 14:44:07 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 05 Dec 2025 14:44:07 -0500
X-ME-Sender: <xms:BjYzaREoeFSHQs3p1cKf9XBcvsI98ZMgBC-B9wU5EIkn19FBCxOVGg>
    <xme:BjYzaXvs7vpJCIDkGyQ-IB1dJeLBu8ZlnFzdC3NE5QE0R8FOba5P1bD1sj6ihHZei
    fzT252_OpCq8ibqOrv3kQ1Fqib6qUCMHMDG3qNI0GETuRN--rKcJ7Js>
X-ME-Received: <xmr:BjYzacbxS8e0TANbEdBzFcabR30IfKX8vQAIc6Z81lwKjIcaYuuoMieXzcex4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
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
X-ME-Proxy: <xmx:BjYzafWLDLE4kIJQxjck657nYCMThqOWoipn6jbIH-3JZz-hLugUHw>
    <xmx:BjYzaeK-lznUZbJXdED-0Ji026VDgwOIu2Ocv9fIJ--gdn7CK3rLmA>
    <xmx:BjYzadGvVuTh9COt4QvlQWkR9dTIidW2JZS6XQnTvGMe1jiVAs-9gw>
    <xmx:BjYzaTz0eR-g7qxvkkoxFyLAQHdQU6PXo5G_QtEsIaQa_wPz3RqKiQ>
    <xmx:BzYzaagdYUzw-jYHUdQKWbBeqp_Tt8Co-MXqGnzIrTtoyOHK-ZRkOw0b>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:06 -0500 (EST)
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
Subject: [PATCH 08/11] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Fri,  5 Dec 2025 19:43:44 +0000
Message-ID: <20251205194351.1646318-9-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7mq9rzftzjndojsopkrbcb3s6agznjpf
X-Rspamd-Queue-Id: 56A8B4000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764963849-165180
X-HE-Meta: U2FsdGVkX1+4Yw3vEv1gqxI04G0tMrS3JQyJbuULH8Hd7AKVwie1JZ2G6YS9xoDhauRc8Ncp6DZk9mOYOXHXRh0SlBp+P2Nnc08pp9Vcv+yym2BPdmKndcwa1EFf977NmLfUR1yx6Wf0e9LxJFVFxfFN0rCaV+xcR50QGvFHR1579AInkJQBXEeIS2QFMGKLQvmMIUzn6wAvHXieWOKMJ2SdsHvDzhuMRkW8ed+zgyoI1VUeBaSJqKuMyYYaQrmpq83nRrYTOjMi9HDc8TwwzwksGCsEEOIF6K8of/JaBGthzGjU2UXToZql2Sm4afGYsbaKzcHTxUV5Ew2kzsdAYrd7EXil0kX+AzccSexSsLfvX7JoWJiN31WiPPawvykoI0AH608aY+QJTeUPV1r7sHVAeDP8ek4QRoweogk/QW8jeYewhf5ZlCbDxQHRYGU1c+TKP/gqpmDJ8nlIFtZ/rMTji4aCvYox228f+XyU6P8BYFnA905THtcMwW+6RSYE6YyP8M9SAXQc00sHtBjZ4Su24n/+zyjLF7MAldZkb6Ys3QFzaMOpNiFaxkiBRN52AZXKJ8/R0piYXQm2GAP+LWEdvd0N90i4SP5nAe5cpmgCNjlIOfQyk8X7kbOqT4FDFXyHunA+hwp8n3275xYlQgasog6SqBXs2QXTVYEqn3b4SDUSb7HOpfAlQ3JODZgVDCOoSRQsLqfeH2kheENthKkBZfnulk+iAGH/QVXi4mtIpYxxpT/8d/EQmcp4dAhEbfsQLtAdGmdQJaD0TH4VJYcFL1MzE0V9YV4uebRqTvFZuOhzUgDgdMxUNWGAQP+AEGrO2DjkcQPN8x1sK7y39HGjSknu2GmwkTa+zkK+3WBZyhwbsGn9O0dufT/d6QqB2jtUKw7rGitxRH34qzxD4V7imLCyURs6ork8ZkhHfGVrEe110GWy5/H6VzzUD/EN9KQFGfPoM75AJ1fYErI
 syPgTaOj
 JFSMbaxPcOuK2wk2KbSTJqIka8ChMI8ibF0MF4VUUK1YgeMx2SfWMT8wxhvqmgasen6qR7WZF1+/H+uvuTztNqFtwqlzgj1GEb2AJwANeiJnoQHV3gTkTcEAQ3G3DooUATDVqotJI3IzWTwGYJCRQhhm56x8qtQXKzwG6AXFajvfzK72hKsYmZJdMrrGqTJ9m8woVwrHM2GaJacoQHrU/gztVvbmcJSDSYo9PYrgNMEe8bm2rdDdAF5oABZ4IsPvEJTcwJBGuEM8rHAEqDitcDZYce1sx8tgc0CW1icT8XIkT3/HXyJV+HtZUaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fake heads no longer exist, so there is no reason to synchronize them
with page_ref_add_unless().

Remove the flag and the synchronization with synchronize_rcu() that is
gated by it.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 2543bdbcae20..0f142e4eafb9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -48,8 +48,6 @@ struct vmemmap_remap_walk {
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
 #define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
-/* synchronize_rcu() to avoid writes from page_ref_add_unless() */
-#define VMEMMAP_SYNCHRONIZE_RCU		BIT(2)
 	unsigned long		flags;
 };
 
@@ -423,9 +421,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
-
 	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -457,7 +452,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -480,14 +475,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
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
@@ -558,8 +550,6 @@ static int __hugetlb_vmemmap_optimize_folio(struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -621,7 +611,7 @@ void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -649,7 +639,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -702,8 +692,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


