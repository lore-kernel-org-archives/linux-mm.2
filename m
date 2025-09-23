Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A82CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC658E001D; Tue, 23 Sep 2025 07:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D098E0001; Tue, 23 Sep 2025 07:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2058E001D; Tue, 23 Sep 2025 07:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 335DE8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:07:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B812486F61
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:23 +0000 (UTC)
X-FDA: 83920238766.06.8736575
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF23720016
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="k 57Yn56";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RNhe5QDm;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=;
	b=kxLPOl96J4Ma4NF6pLCU1KzG3INePWrXqRzWiS3OUYRzCNzRuy3ZxOUEitXp6k7SIl1LoR
	1Wsj7GL5yHDzafKcvmj5Ncy946qdKRqSy7ON57ovA8OSF+EWsS5DDdduYYRTTP39fJFQxE
	TvgGXNK6fkn0i7N2pgki00cZQarOnos=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="k 57Yn56";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=RNhe5QDm;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625641; a=rsa-sha256;
	cv=none;
	b=t/eVU8KHIQO+AC5+uGR/yK/UYqYr3TEareWs5UV2RE5nUFqP7B5x8JV6hR22V9zym2PZU3
	8q1kSI/IigBRqshS3lFT8xhh/cpPLeO7WPMx7uMaTeFH7gQsApXDmssnjykZuiK+iPauEY
	BB35jN7LfcvQngDWWReWDYLtl8NcbUM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 47919EC00DB;
	Tue, 23 Sep 2025 07:07:21 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 23 Sep 2025 07:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625641; x=
	1758712041; bh=9h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=; b=k
	57Yn56Ft7V1wdRUjQFDU16OLtJjKXC9ojXp+Xly/KRh8s+26eNrrJqXwH1D3+blc
	EsbPeUED693c2ckC9PcNRxqU9hWN0ht+wP6MqXnm3RkYxSTIbSFTtqMvTU1wUQAe
	gzZ5yc10CWXxOmkYvSqggeuJH2j/6iF9F81EskCxcTCAK0iKAkBcHAtg01wWra5d
	Zms63rnfsYBXBFJoI+/zZVornKHTfgfv7qLOp552azU0f8rhj96ZF7u6l4f6CSx4
	x2TtEDASSbxM8cqe8LFicm6p7dXVKKCFVblLl7lqW5oQtwP5pYgFd7tjFwlnJWgW
	E9bX9d3rNwQxo1r2ChMKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625641; x=1758712041; bh=9
	h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=; b=RNhe5QDmEf9xtn3d0
	ihdNJUhcwKphjfzODBwqVK0DRT3qzVn4HxFbUZrS84IaPQuwRIB8PhUO08D0TNpQ
	voIXkcBBQ95BJVGzRl6UCX2t+SYx63XQ5v2fA+HvKKbs4as+iMRkv5CUlhpK4+ag
	foP6nGPPEEWvPQiQdlz3f+6GSJBahvC0hvTOmWyMUkNZwCbncdljB8kD+gxdV7Sn
	OW0PZND/Ntl0M/4zmUT+jCkA5lD2m5dq5vwOxcgvL0LenTxkF9pIgMBeNFFPMc0P
	nGwJActrRumDAK/hKDxQ59Ut/wMg4MRY2Py8q+28SvudQbtXSvHQJQ3ARZWUUaJ7
	KMllQ==
X-ME-Sender: <xms:aH_SaNn37cKXrjN6V14BDk8q0G35B1l4myo4Nt_Mx149alBRijU34Q>
    <xme:aH_SaEw8UL-JgJ0CMQ53RegKCh3TbvKlvX7idEI6BUKKRCuJoYLivzQXgb7xPV9WD
    tfRECIteFDAJ6RX1JYu_wnYqT5cVjrJCnipmALLYI_CtgWUsL3VZQ>
X-ME-Received: <xmr:aH_SaJyQR8w-zVhE0h8UAM9g7bGCI15sKOOTnlojdO0CA4JfhBeiyhWjV5Rr-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeegveehtdfgvdfhudegffeuuddvgeevjefhveevgefhvdevieevteei
    vdehjefhjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudek
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilh
    hlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthho
    rghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtth
    esohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsg
    esghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:aH_SaD-T2gBjlfmljqYYu5iwMTv1UzocAjmF6FVG5DMGtFMgB7c2ug>
    <xmx:aH_SaJ_-LirFFs1XkyuGJZPSkdMaJcEeq3sIyUJwKMhp4mafglfWqw>
    <xmx:aH_SaGffgWggxbnTf6yKA7Q6-y64HNjgWiXoYLgM-XVK4_C44GeTHw>
    <xmx:aH_SaFvIlb3Tz2-WH0saLBDr5lfQpZ4IpNmW5p47HZ151FFuPGQQgg>
    <xmx:aX_SaHqnZ1PCXdU4FJd6pDpubmswp9wsKRXmnp9MQ0Zra0Sd1gBGhgbx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:07:20 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 2/6] mm/rmap: Fix a mlock race condition in folio_referenced_one()
Date: Tue, 23 Sep 2025 12:07:07 +0100
Message-ID: <20250923110711.690639-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110711.690639-1-kirill@shutemov.name>
References: <20250923110711.690639-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF23720016
X-Stat-Signature: omdsxi8gyhsmf6cbz4xj6ifq73eh9oan
X-HE-Tag: 1758625641-553955
X-HE-Meta: U2FsdGVkX18DJ0j2CvqNGoxaRVHJTokY3ZXLHFhvWQSmhM8N3iJL+clwOyZQKhWFkxnsaazsstp1sfQQI2XYKVYoVw4AAKDrSagWKDVGCCRsL4HttqDR4v2TURxE/QrLxcs2szNCxDahaJ4VAWl1By3E4Gm5ORtAMU/5F2xmGcxbqlMaHTvHyevGBwujNKtKgK6PXnNuuOpkNBaaW0PV2W7nkruLufGxrxoEzoH4fxg7iDYSNgrqWljn8/kMNg3ymhBY/pRgy1JYV+l1qKe+/64fU2DMrnjzV78vXRbmv4glShEqhPzCwzVCUWQrY6BAedsFR93JpnqDKUiRyLYTAcw5yYw0Pj+LEK/ZeU8m1oO8lGFUAWtGKmRJD+sPU9sYkYLJNL+TohoLEg5xgHDZZ2HqZzMMWSM3p6w0cYppOZOAc8H6Q324EJFIIw0bfFMdxQ8wiPwBUuVGRs/tY8uOV2YbOtaSpYpCRZ6mWkTqYe384Cpu+Fh+yeuVr9OBfyYuUzIyJmXQdlTMa7/RY1DJ7NLPhgB6CxY+bnQj7mTfStBCQ+0ZK1UYVaEbQ0gzkiDUSxTNVSJrGmLmVM3qCmAUoM0y6QuFH2H3ao97ph8d6/SObW9HL8lxSPoQUWFgZyV/uLt6DWwuOXVhmDSJZXSBj9OxFjRIOdKv/mM7vvF55WpdpYbuNUyonU1x1YjaNY16dhazj8mm5HvyWmrNEjF+ot2/8jlLAfPa0IDH4qUEgcvq4CkpZmsnHS14RhPH7EoppAABHnzqJy1aWzOQ5xdaoNheWc6sr4y2Cj+mncTw+/oaCSljnvOQrWBgHQe4DaCSIygOLkvdy7b3Vty4Mc5rFpXEQrNbb3tfSPA8IdQRleZ8YWkJDDWLApfiTcMr33twadH4DoF3T9HLTouqdSsD6coNdv2e2nk5ky242wzj32qodu4KlYuYh1i6RWF8vb49pWYhmMlgn6P+4p4T73F
 X8Td6QTd
 2SzDhWHRr0U8CnUywoH0+G29NjlDFRHNuMUW2658VTPQ3HqCOd7mAXW5u1nmLthtK/gzta4piTxmP063JiMXzrNe8BxnUl+rZnnu1g8Ua6np2qY0JCOTKdNKZeGACfdfYdb+93pDt2jR9DXIHI3CudLcf/3njlidQmFeCCI+D1F6Y2aoeA7LxdkZ+zDovsMBYTpDYvxAxXDKX7kZN4bXRizJ8dbQRbZnFVIgwtQVMTsQzcH+xNhvzyAgb4a0PxdWYNmkiInFD9MPYYbn6/+6wN5PaTy8IDg8RCHKCGPVGBqvvzcy9eg3fop9uT/SX8Zled/5GF+OIelaeXagenwhzkPWewqscYq0jQe33rmVhllq5LcxcR3rnVP0PixKpR+nsn7AKr7gpEoAHvueJKBSxi1hinuDEYvfWbgTl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The mlock_vma_folio() function requires the page table lock to be held
in order to safely mlock the folio. However, folio_referenced_one()
mlocks a large folios outside of the page_vma_mapped_walk() loop where
the page table lock has already been dropped.

Rework the mlock logic to use the same code path inside the loop for
both large and small folios.

Use PVMW_PGTABLE_CROSSED to detect when the folio is mapped across a
page table boundary.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/rmap.c | 59 ++++++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..3d0235f332de 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -851,34 +851,34 @@ static bool folio_referenced_one(struct folio *folio,
 {
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
-	int referenced = 0;
-	unsigned long start = address, ptes = 0;
+	int ptes = 0, referenced = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
 		if (vma->vm_flags & VM_LOCKED) {
-			if (!folio_test_large(folio) || !pvmw.pte) {
-				/* Restore the mlock which got missed */
-				mlock_vma_folio(folio, vma);
-				page_vma_mapped_walk_done(&pvmw);
-				pra->vm_flags |= VM_LOCKED;
-				return false; /* To break the loop */
-			}
-			/*
-			 * For large folio fully mapped to VMA, will
-			 * be handled after the pvmw loop.
-			 *
-			 * For large folio cross VMA boundaries, it's
-			 * expected to be picked  by page reclaim. But
-			 * should skip reference of pages which are in
-			 * the range of VM_LOCKED vma. As page reclaim
-			 * should just count the reference of pages out
-			 * the range of VM_LOCKED vma.
-			 */
 			ptes++;
 			pra->mapcount--;
-			continue;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				continue;
+
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			page_vma_mapped_walk_done(&pvmw);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
 		}
 
 		/*
@@ -914,23 +914,6 @@ static bool folio_referenced_one(struct folio *folio,
 		pra->mapcount--;
 	}
 
-	if ((vma->vm_flags & VM_LOCKED) &&
-			folio_test_large(folio) &&
-			folio_within_vma(folio, vma)) {
-		unsigned long s_align, e_align;
-
-		s_align = ALIGN_DOWN(start, PMD_SIZE);
-		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
-
-		/* folio doesn't cross page table boundary and fully mapped */
-		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
-			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma);
-			pra->vm_flags |= VM_LOCKED;
-			return false; /* To break the loop */
-		}
-	}
-
 	if (referenced)
 		folio_clear_idle(folio);
 	if (folio_test_clear_young(folio))
-- 
2.50.1


