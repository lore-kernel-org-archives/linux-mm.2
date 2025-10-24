Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEBFCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3163A8E0104; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6378E00C9; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5798E0104; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09EB28E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9CAD140F68
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:44 +0000 (UTC)
X-FDA: 84034186488.06.952D867
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 06D43180006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dyyL4Ar+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRJpv1zm9hr0FTI5e2mY+1JJIHYqIOb+kDWc9i65Lh4=;
	b=GwF7/Hghst4BoBdIX3XLdN8WD9vHfIqlx+hjaBcxp7HwqptrDOAYMPhxygaJ4YxZV07NbN
	Wbqvr+FQzkfI+BuGUcR5iZpViV+WMPOZYmWBcEyZIVcS+xzsDRgp32I/75hgJPrmJfsj2W
	axQ+xy9MXXnqDU8v2p68z4g+6fvjJX4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dyyL4Ar+;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338683; a=rsa-sha256;
	cv=none;
	b=4MFkG5XqUHwhw1UK2w1Jm3mnf3SI6fovqqPknz3wFQTlDwZsV89/tbUrLo+CEepHMOu/rK
	oG/OohtDn9KA+OWPVXXnkHenrRGUzi0cv3HUep5BsoyRG1EN85Qd3BKD1A3+39AGWsRH0r
	eLqu9LM3aY5WkIeElIXXrdKcbPsolCg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vRJpv1zm9hr0FTI5e2mY+1JJIHYqIOb+kDWc9i65Lh4=; b=dyyL4Ar+jvoBHjoYmWeCIrVMRr
	NDoVovLtwuRmOVUVHxA79dF4DkU2F4d/Gz4sWzcGsVYrJz7DWOYQA0EMT9HXswGR3yQz+7GyE4idr
	FSzws+gKsMLbUmgMQsioU914hsvoYb7kGak5QmyiqgngxbaGKTgDQjAlJSkdr0LRKP1vX1f8EyDLM
	LrYnR7cSPjBsaKgRqp27iCIBDVWzphmhCh96+3dsIcSScJkQcExNbyzCm4ds4Az0FXiq0SjtBZoUl
	38Q7iRXvC/0BXfTu6QwU5lvzFow7ESIwYnTsKzQkCQUP/D0Cdkcuf0dCO6s7fhcjkhdbLx76QucN3
	diHsFbOg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKR2-2GQ3;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 03/17] slab: Remove folio references in memcg_slab_post_charge()
Date: Fri, 24 Oct 2025 21:44:18 +0100
Message-ID: <20251024204434.2461319-4-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06D43180006
X-Rspamd-Server: rspam03
X-Stat-Signature: yfi3stw8exypxh6uzp8mbnzeseubjop5
X-HE-Tag: 1761338682-776919
X-HE-Meta: U2FsdGVkX1+ypMlwwvtTilK3cifjJiGY7LR6Yk/skrAgZ/Xgf04di0/erkbgVSGwxvwdiwly4vAjwcQla3UHMrzBL1u4Wy0LzWNB86qkEClsaNQApNamo+UcV0rtiYDJcafnNg24CXx4G813i7fCCbohdpr9QF40OP+8fRIRXSbt5CujFCJq4mw5Jy9DMZ8cFaU2fRMOYfrDSELFWn2l0Sau0EwuBSgur1o1oNDqjXvDXmRVUiq4L3JKVzsV4FkV8LX2fH8l88VXnS0qtHEU84EifpzJJiTC7a7BKdUQd7QDH9ThRE79p0pO3CM2ALDE67dwG1mFA4xh8x1kVz2jKSTPO63TSusPRKMokZpGH2Lu2RJmPeDlSljJ5+CAKiNlfoE92sgtaBIRQmcJh6Ej1QZ162vy18zo7l67T6HjsItqXIpYA/lCmNIpZjLFq/P1l6Ms0LXVx3UACDW9SbydFRX6ZvYl41jjqmOu3GVonQvc9OIrjjG1pmR4R/0mg9VxaJtwFfHRsv20o4kRZq9XHB8VXWJ3xxB3xiHvh7GhFpLV6UnEANYd1UAdFjXECVR8hPJkO2hsSEb5NlXgORkX9mpEpsMjXW8ngj7raLwphajZXyIL6kWzPFcUnqJ9CO+pdnSIwXKXrAaLnuX3UIKSvSni8osOajk5Mq4Vh0HO80bcnb+8rTz54C1KoRcQQlAB9AMkulICjt74BwCW+5IrwGiAGwGjEEuQVOoFUjftnCOtfDfrtDf4Yj8NrpLoNgi8DL2kb+M1darL/8foWURpe8W+VPoBNdsjYvieu5VTwvrN92uyZ1z0MC0EXSSybGSr255qb+nueHVbdQ+gXu8+HPjeDS17uQO0FA49sZcvOB4wFdR/h9E7L4WWWgWuKENcXbXVi0g3SzUUDx83q70cvwWC4nIUcpPOS8wvdS6uObUaNZR1p56gvm5tQK4ln4ZJgjLHyJXWancTR6EVVuU
 lX3HcjM3
 PeTxnvcGmh17Z2+D/6ruJjI7ib0W47YFHoCUmar+zAFlnJvW0fZ9H693ggXwzH+4u6wTfqsQw1qVlcA2SZCVY/1Xyp6B5hVmWPqTQBtyYBe1PqKyUctECl5BRKyIVaN+w13SKeXVZ1/hq3lF9JKsYj3fnD4kzikOKStT5Ddpwfj6VQyI9+jVap3Kz9BJZiz4rfM2KEFyQqBDD9I4yNwC8i4m8idSU0HAsvbZlTn3wDBR61No=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This allows us to skip the compound_head() call for large kmalloc
objects as the virt_to_page() call will always give us the head page
for the large kmalloc case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 90b94b418010..c72795f4f433 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2363,33 +2363,34 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 {
 	struct slabobj_ext *slab_exts;
 	struct kmem_cache *s;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	unsigned long off;
 
-	folio = virt_to_folio(p);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(p);
+	if (PageLargeKmalloc(page)) {
+		unsigned int order;
 		int size;
 
-		if (folio_memcg_kmem(folio))
+		if (PageMemcgKmem(page))
 			return true;
 
-		if (__memcg_kmem_charge_page(folio_page(folio, 0), flags,
-					     folio_order(folio)))
+		order = large_kmalloc_order(page);
+		if (__memcg_kmem_charge_page(page, flags, order))
 			return false;
 
 		/*
-		 * This folio has already been accounted in the global stats but
+		 * This page has already been accounted in the global stats but
 		 * not in the memcg stats. So, subtract from the global and use
 		 * the interface which adds to both global and memcg stats.
 		 */
-		size = folio_size(folio);
-		node_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, -size);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B, size);
+		size = PAGE_SIZE << order;
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B, -size);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, size);
 		return true;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
 
 	/*
-- 
2.47.2


