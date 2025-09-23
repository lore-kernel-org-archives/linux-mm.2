Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4D1CAC5B1
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 11:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387688E0011; Tue, 23 Sep 2025 07:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F818E0001; Tue, 23 Sep 2025 07:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2756D8E0011; Tue, 23 Sep 2025 07:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 114438E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:03:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8F5B589A0
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:21 +0000 (UTC)
X-FDA: 83920228602.30.0953C43
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91E9620008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:03:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A ujJnep";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gBi3iRA2;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758625399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=;
	b=tyapJ9JaFQ5gLy4/DmvbO7SPVAnuhbY3f2dJOZdME/bK0KovdkvcQYhvMDMvQWFgFWIWqi
	HRc1b0cVilRhcaBdT7TqtTtZ3pGBClr6NoBZEdrNRJlnV2WwGCosauv3GAGrbBnF63CYL5
	Ajzf6Rf80vEWPgTQMUQmi/teMnw+nYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758625399; a=rsa-sha256;
	cv=none;
	b=w1ja4Cc0BKyGz0oUqySidShQCWF8KuAWGXhtZtZQLsu1wjsoVg0InVm1kI07Jcj9byAlyA
	e0RQVQYgquobkoaJunbMqK1l+XRai18xNRzYB7dOv2FSiRmglnQ5dpiFWaxojhI4CeWnqc
	zcbrVBQUpX4hvSBc+EbzPhcyRmoyQr0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="A ujJnep";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=gBi3iRA2;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id DA7A3EC00A0;
	Tue, 23 Sep 2025 07:03:18 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 23 Sep 2025 07:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758625398; x=
	1758711798; bh=9h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=; b=A
	ujJnepmyPZhX+WU2im5VqmQB3MvkTLXHej6jJZyzkNWzDWqCFIyVSqoAGpSMAboq
	+b/122qzuZjnXko4oM/kCcXjJg14d1MLno35d5juDolhe13UfmmeHhiKC9rYmeCS
	M/kFWQUxZvOuVThjgjJ4lW3bBxuFGd2Uz41duKqu31Sij7XXs2XFzehKo65XRSZS
	dqzL9n//3JFY9Hka9eHl4kv5rC5m8jm7oCXvu/Ts6Y+a636NULVzhcBIoph2mRcH
	7yf99Nt+Ur1WAkArYEems7E5zX00MaJhlxjUclyJT08c46yXcKtlNjKaDqlajZWp
	dWklv5pxm2ETssA8/JMSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1758625398; x=1758711798; bh=9
	h5a9glrsc1Q9FewltBTBylrIxsnIQry21VQ9ojF/aI=; b=gBi3iRA2F5JjgzmV+
	BbK3yEUYy5dVuMOaEa3mlJoVNS12UA9rh2MueCMl1WmzTCjNFt+McWKcbUJfSKNa
	v02KmchecKc2952pY4HUFLGYscXlbISs1v1pwCsknGlBf2XJ/iOP9QLthZL8cyPg
	slKOMCzS5kOd/5slgK1S4xJHSoMdoHunlQGB07mQQSOb3eG6CKdAieOgkubfEyvb
	3v1W43vpahyJVPkQcLS3+xUFbnpc6p6nwyg2XKbu013ks/dlfMtmT4YfTgnElYmJ
	yltiLz72DPp78PrQ4ntMvtfApoVMWushhaT6knITFRgN/lYSJdgrLc3uGMM+WgE0
	6E8EQ==
X-ME-Sender: <xms:dn7SaLCRyfOeMN-LirZgCNkSzzPe7I_uIkCiCeLwM4WiwYnzu31_zw>
    <xme:dn7SaNfmOx0V162i6npcR1LRccL2LA9xRuwqa0Mdy0peFQhEl4FAkGAVm2f4moZYE
    21gBS7uXrVsLBcOTZUgF-aYZDnc3NeSCFEkh8LM1YBtd6WOABsVKQ>
X-ME-Received: <xmr:dn7SaMsP_EZTYkBeQOSCMcO1DqVRLUAB4h3EtXENojYIDjWIidJTQWMfoi6z5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitdehiecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:dn7SaEL0TGvqvagSgL1oJennoyf4z9ha436y9tH2hsoS4Ucx7SagVQ>
    <xmx:dn7SaOb-zkhE9P-t6GzGXOs4qVOr8skp2iU7ZTFkNxzQNmuz0N7gWw>
    <xmx:dn7SaKLHVQZqrQeZ__21eRWumkA-AugL1An9SFsrHotPAVtvoZ55Sg>
    <xmx:dn7SaHqr2JMWXKEgqf8Z88pCc09vkLR1XVw3KFFjwTCHggyjvM3wDQ>
    <xmx:dn7SaKHG10GWoGr7hoEXwpzOVcObPuZHFV7R6mCXVrrrmj0Dl6QnYO6V>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 07:03:17 -0400 (EDT)
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
Subject: [PATCHv3 1/5] mm/rmap: Fix a mlock race condition in folio_referenced_one()
Date: Tue, 23 Sep 2025 12:03:06 +0100
Message-ID: <20250923110310.689126-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250923110310.689126-1-kirill@shutemov.name>
References: <20250923110310.689126-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91E9620008
X-Stat-Signature: m6cew1987mohrky4gj7szc18gp9wrdsr
X-Rspam-User: 
X-HE-Tag: 1758625399-67742
X-HE-Meta: U2FsdGVkX1+RPa+6WcfqXljD5PrmoP7TYM+RlcGfDLCPYcQUKOMYZwYGhdfyiOXIYlDhLG+UQnFkricqlLOnTdaQVzhh1VuSKgkfcphV1QT/yFmcajDG9CAuiYzMerrZcv++kUrrQBHGEOP4abqaNNIdeVIQbkzYLd9dQygyBZdj1TbjphvSpGkkLaOx3+3+rFQZTIol0PjUAnWfKuLFltx9rvWiKsHPiGqg7ei7tvKgEA3nXFZU3Z0lpOYZf0qxnMe2NH1NEI4dMOVhjeclUvkPcyla6TA4lPqKpdPQbdhYQyMRNt90qqBJ5mkTg82KQ4fZfuGc0akyMwhTq8M/sPmBIERQ4nPogIo1gMRvaX40jWwyw8A08USi4haayxQjrfV01AGOaTWMihtEKUhzCB3bjLSzkwCnQhujalMQ7UTpLvYvDRTGv8OYgdT7SJBOw9bwalLS+ru7UE9X4aekU0fFyVUi9nUNmAaDVpHhhfKKuFR1Rp+4AcoiOa+TDLyWESoZi0MwoEo7vE1qKn/DqkJSObDmf7/X5iDzcN22ZohAiXbgnU/ScBVFikKIX0n+p1XHF3A2hTMGvtJo5TrzlzKE31W5c+FZ9lWzw3faR2gk0TZcK1pfN9za/t0nKeGMCI3Yav/Bhz6IOOpP5tH0O6vjtF2C8YsAtpmByQFghW8ExxsMGml89ZsV5/QR5mLBfZy/FytBP+M6o2lLZZ8UhzxsDjVB90RsCZ/gX4hEl1bQ48q7moDmHi/QcJEbhj06KtVljhC41qvrz/fbdZa7Hf1ZeiaLyxelJ8yhAT1j+PhIOndpNWpOJ0ANdc2AhD1OntvbRX/oVBdllguRjuETFGf3ithN+lsGvRPvmZijH8VdGrAM5sGIUgYrW+FT+qKnjbfAp46xVIN7oDZ/wSJQ8KTY3wiBshmGh5b9F5MheXmWJSNbzobYOgrdQq3WlRutFGaWgqZcUCfRLdOYj5k
 zQS34kQY
 VFbPfGo5xUM0Y8BwUcnINNqEjNzznBStIFCirLHxXz4RoO0GvFGwtLAqgftTZS2D9uGyJ1ZE5GQLCl4EC+6KGoUTHiJCYYZsLxHaB3AmPDu32wOOZocKFyR5PTOqaKwNPbJ06ZCO+mf+Dlo70mZNjOfMi4H7ToWZddmi/CQ7JTgjTsehIaOTvbKblmu42eoUiWlN/m3gjjFe8NSJzfoRzvAGliA1jzwuVMqDIdPRPmpJMUzx8oR15V+J2b1qeEiNRq67RZjZ21qo3MkdtJlvccKpglrrChAAZz/PULu6COBiPOxQ3yJx3K1AFZaTvJgpKAIYqceh3tiRTyf8JinEfT6FwoZyoPVez0FN0DSdOl7hEEPyaYFuSFREKeKFS75ViVvYnC8d+FX11deGqP1ZMkTxKadPxZOEr4e0b
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


