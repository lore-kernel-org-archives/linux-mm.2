Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5EDD6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775CF6B009E; Thu, 18 Dec 2025 10:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743206B009F; Thu, 18 Dec 2025 10:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577AA6B00A0; Thu, 18 Dec 2025 10:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4524C6B009E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BFF656AE0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:18 +0000 (UTC)
X-FDA: 84232927716.02.9E9B152
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 76DD112000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJacVhkQ;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HT+q9kDi7pa66syEy3O+VYN/j3Kowzh7v/SJobdurL0=;
	b=2o/cTmMaLxmqH8dpto+uvx9K2zh0qohgLbhOgQ2RSpFGp90GuhyeIsqmHvdk5qMR3qIKG0
	mf7EUgLXV2ZhJZxGcF2I4f/GSuOnVTUehVIZeYJSYkfOTLx45K3EKPFkO4qBNGvTAMpdSg
	2fEXLHjP4wzX3jg3hm9XKgFBOWaawRY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LJacVhkQ;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070615; a=rsa-sha256;
	cv=none;
	b=uvXouHSqKgHLTWjJ/kEXCCUpnKC7kVg9DVNpUpPBJv/arQpSSXZmRaxFNXHIgF0Ia70tnQ
	BYgtr64dxfuxERh2feydnB0O4h2CLdXqnU9KdTVtJiYvMKKrlFML1czqy6qm+xHl7wsBxO
	HwOMQJLToSmFrgYiX8rz+GLl8T6ees4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 310FF44577;
	Thu, 18 Dec 2025 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D3CC116B1;
	Thu, 18 Dec 2025 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070615;
	bh=B1eibsAcWSn5y/4mdCGhgsGHb7qIzuBZJfdR09u3QuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJacVhkQPLYFRT+bJ2vM8A7HwCIPArlwYIv8IJtOmXYgoFjQKETVuVklGANvu1pWJ
	 rjkurIpKERJo3LRtBfokpqtUdnUKRuqigGEJYwt1aGJ6CI20p9bX63RoMqbjm84vDj
	 pOz8cTNCA+X3oAoQ0az0VNHtP+J7c7zaPyXyDejvuKwDozFH12ePc2dVYcRLE19CGj
	 f2PQ4k9V93mrNb7gW+zSQSU6u5Ouvm/E6/htNWqfWwZ2ZTp4rWmJ27ERTswS5pshRI
	 bWjBcMS+F429gPSPQaUlBFeQzb7472LRdcuEnkTN2XDAACRcwRe2D5tLsJg+qG9lji
	 x8J3f7GY2uiyg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id C101CF40078;
	Thu, 18 Dec 2025 10:10:13 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 18 Dec 2025 10:10:13 -0500
X-ME-Sender: <xms:VRlEaTLQ4VM1hsLkcIo2jLIurPbv0o27FYk879rbEKt1GfEn2vLAeQ>
    <xme:VRlEaWbJAAcco9_sWEYBf8glqJGPOy-oP69TygLdsWwH17SDS-A6U_F_LESARbonS
    w8MvQ3jK2c7kPrZUE04nASfNEILU7rOhgoLtRjtCUzlL-zTkogaHg>
X-ME-Received: <xmr:VRlEaehYrujDKY5hqtZc0e6PVcoImMLP0cGnhIwtm-uEGPdmh4FcUMMOzwkyDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:VRlEaT4izlgYmEwGkIOV2AztU3kXJy105Lsg1xmAeBLtWZ4JCSsLXg>
    <xmx:VRlEaeqQ_IrHVosLaiJaTKRZLHdlCorHOQaauSlobmdwkDsNe2699w>
    <xmx:VRlEaYg-d3dPoyLqeNQ4OnI2NvIjdnTxkW2kE3zwPqU4qptTcLLoiw>
    <xmx:VRlEaeu2Z56K-BcD3cDfgAq7Cn7s268CT14t23ZWea_CvExjcIVjzQ>
    <xmx:VRlEaR3ull44ZKmgYLFg0vf7AcAI5GpXJVPAnrWchn76wB8DKbOxXLD_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:13 -0500 (EST)
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
Subject: [PATCHv2 11/14] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
Date: Thu, 18 Dec 2025 15:09:42 +0000
Message-ID: <20251218150949.721480-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76DD112000A
X-Stat-Signature: fzugjgskdjhr78cqfsa7awcs71tgn8pk
X-HE-Tag: 1766070615-590320
X-HE-Meta: U2FsdGVkX18ieMvmXGdTTn9+KudiOiMg0EWIhF8bbGOXZ6wwOf1rgJFh59YWXRYGeCSKXwIdiB/C9Ooh4HDsmg5K9Y3+YIp5IIYQ9Nzqs1CQloFzmfNKwlWQ9To/NrvlONvJ5ko9WswCpB2jwzC+TwVkzH9xYuFgB+bQEf6GO9HbEskp4BC3ovasRuHx0jIZYw5Jkh16qqBx530VJKSsnL7TSHJZyBy2u8gRYHgr3CKf0UrEy11vWRWgHl3kKVN8NX42NAsWF1c9XHm61YsR4Riyabc0p3fjivtM3gTxJBkRwUg1S1h4NxF33DRG0vMNW3CTL3rCto3vm5jDL71PpdelzoU6I81PEFH1sVVxVIYG7oAArSl8U/xARXZo01iUtNOlDnB1cP8nFkrCBCv8tkwWBUNBHCUH+mTkW03gucmw/3tx0yhbl9FIdAcEl2MhCwE2yXrw9rcjGx3o9jtZWn93/rYYTSX56GiMdZnJq0HDsKhv5dkuckr/IZX4at62cPfAdG1VYbhaqxDWahgocgXog4Bmsa21SvhtCayLkKLJhjWiASZfuDD50lFKZjxVJQX0TkQEYscBeQgsSQL4uRDZibsLnZKWgOU6bPhBFpEkimOc6LmgaZJFA2jNYy/YigpGsMhvjIMO7gEayesLxpghH5DWdgX3UPheGMWIFPzYz1Ujzxu/86SjXwKpXVGxRiuykG5Q/uQ79pwg19Hb0PVgNBiE6N/NTDb/kZzUWDfM0uvscTRnOQnWChlhdJ28ozk4RQZ2JmtLlZgAuBcM/vure7h44SgRUpalZI22knwPmZl9ZX/8YZVd4RaFyptsLcLeAt2hLG/r/7nkhZlV18x6cRNIoDhYNbU1H1UJM/LfNOn6a0EP5s8u8DPTnf1/aL3PlXGIQXNalqE0PvQTjJlb77NdyNxtY8BxAxddeLfvBnmI61qI3mHB+1wkKNiitQBgmiJhVkiw4Ijp9DK
 u43tS4TX
 hAmX/wTDAV+1M4IpTi3N/CL3nu2iKfU1THsFMCMdv89G+dZ0kaQdAaadUg/zVUhEUnRjTmLfEMAqboJ14W5alHNq96XPdRsKxmxQYCQUV+ysDn1Qw1fCN71EMUyQwFmWNRKP5pag0ATGHnjF/2Y3zwHkSWJQWpVA2LTtIUl9Ip1bHyWC6sYD5fpK3OsxLhkBFhFQ9V6bbPhZ3WjB+x12TaSrx8X6tv3TfWneOKjLnCOQUBD3Zj0Oqg4LkbrXw5BHcskq+ByuRST3ZkPtY3S24DZS3rpvvNGE4JDMV6szfFJZDHD0NChTH4D8VSw==
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
---
 mm/hugetlb_vmemmap.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 63d79ac80594..cc0fcf847810 100644
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
 
@@ -456,7 +451,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
  */
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
-	return __hugetlb_vmemmap_restore_folio(h, folio, VMEMMAP_SYNCHRONIZE_RCU);
+	return __hugetlb_vmemmap_restore_folio(h, folio, 0);
 }
 
 /**
@@ -479,14 +474,11 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
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
@@ -576,8 +568,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
-	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
-		synchronize_rcu();
 	/*
 	 * Very Subtle
 	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
@@ -636,7 +626,7 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 {
 	LIST_HEAD(vmemmap_pages);
 
-	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, VMEMMAP_SYNCHRONIZE_RCU);
+	__hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, 0);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
@@ -664,7 +654,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	struct folio *folio;
 	int nr_to_optimize;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH | VMEMMAP_SYNCHRONIZE_RCU;
+	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
@@ -717,8 +707,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		int ret;
 
 		ret = __hugetlb_vmemmap_optimize_folio(h, folio, &vmemmap_pages, flags);
-		/* only need to synchronize_rcu() once for each batch */
-		flags &= ~VMEMMAP_SYNCHRONIZE_RCU;
 
 		/*
 		 * Pages to be freed may have been accumulated.  If we
-- 
2.51.2


