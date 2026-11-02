Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A83606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=iL+qx9/J
Received: by kanga.kvack.org (Postfix)
	id 1DFE76B05BA; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167196B05B8; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CDB6B05BC; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA8D86B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B0241C2827
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:14 +0000 (UTC)
X-FDA: 85391172468.18.1241A91
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5ED54000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="iL+qx9 /";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQz4ufqd2Q4pBt2NMjn+Pfl+axlhgiEHVkl4wqUSAM8=;
	b=493a61xubVNldl9Btq8xq0N57j/cwCWpaM2PFH93HRQ66vZlLAjc5g9qqGlozroms0baNV
	0MEUq6P9AFSqK1NewgAwe8p2aLTGcl+NVPDyGzheuFEOWSQtnwo3C3dvF0hKdwvZgexnaJ
	Q5F9+M6T+n975rH08vE2+yvVgrftKiE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=xuR6x2CQ2K24gN5znFld46MB3CX52OSyC5WXExtKcWVjjAYBAb9RRvO37EpsU60sfO7+4B
	5b2Ul4F++AJoE+cZ4Dnw7V4nBlT9ZogmBAWZB2qjx+R/Du70u5kWAywN2lAmE0bmyL4kTO
	gzC2aic73AwanUvo1sPjZ1ySqXP/r+s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="iL+qx9 /";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=xQz4ufqd2Q4pBt2NMjn+Pfl+axlhgiEHVkl4wqUSAM8=; b=iL+qx9
	/JBkO86cVuNMAZvBxfplTv6ssEsvlUud/J24WEiSke+ox1ksfdHctY2tCsgnMsI/D6PXtHQg48IHQ
	LoQEMwjm04/NT4lcvkNBvpA17v8wJx5IRpwYp+jSV0fpyjwcLA1/bdOYtCvdWAkpHFbzZI37xXVgG
	wwYMryms2NjxURsevcBkgpaVJGw+mKGUeuVX+B9C6OWrbbzORuZKHSdOfCV1AsS1sWWhA5ZzVgtnz
	LLKik2pnPrJA1JcG3Xur5hH1Wsojbzdb6igJxU2/8XYocEPcZ451sd35mMq57FPiqIBTgluXAuFpz
	jXtIWuoBlsMUK5I42SVJsDTlctqQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-0hAn;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 5/8] mm/gup: fill the pages array outside the pud/pmd lock
Date: Mon,  2 Nov 2026 14:30:23 -0500
Message-ID: <20261102193026.3860700-6-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wmotyskgfhns1ro5jybydn57uaqqrdhy
X-Rspamd-Queue-Id: A5ED54000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793647872-570410
X-HE-Meta: U2FsdGVkX18ZdI/s+s+a8ZjQaPvz2Z20JPJ+n6Fkfe0KywYnFmgVMhXQu5YifjzTZ89KWNHiP15dvpZAaY2wwXHuW1AjmBoDaBIi6o12+sdQTHgTcQVBhJMSpRWS0YCyEzbUlJrAofXrDCGwbQMDA06CHgCKWf3vS2BAK9HTCp7cGD5QNvCAb/3awczfkKwDXenrwMCEQ82m0XZRt+e3iwgoWAxZnBUAszIUcM+jjz231JZh6QvLlMHFIjx5ZzsyN6wteuiEkmD920sUvuTc9Pw6MVLQWorbiiWIy4LAMUX3iyaDktCxoD8JzCwIdxbY95TpSavkTEs/Dy2/0yrF9qlhXuPufc4CbZGt/r9MtXDBFvgErTLD03OgUz7fUa2nU6nfhqDhHKjvnmpnqSxtZSJ11Eq2vM1v7jH7f1aObN0GbcVElK2XTcpbdgfvPDUYJ47XHJez9sx7gW6DZ5Xijn0N80k/W6CKq0N2N2gQDOyoVlzS/g9+Y+fcG7XNrby7+F6GDbklnDFgqrBdqKEPTRIHsT3Gi2KwqB3wRcJXNukokZR6CHJOX11DJ6sTMZTQ2kXZP1QRQJj9IZCGUeplvGUtAodG8cgVxBBq60qb/vjLv6BM+cbiXicWQ3wxfrNwyEs3HNaPC0pZEyXJERo3pNnrhFFfUEwLyJ3IpxlXY5NhP9U+MKAZGohb16ms8VRiCGn0HiZtFN1ZL6msddMLqeJwq7k9uqdt1aTYRPItoBe60jZsxRkTDh0crBxq+6/sTWwvo06BITlUQ5wB+pGybFt9LxiVqo4YjmY1MHLuZWrcglQ9eyxp9mYcRm6pG16Q9ug0hZI0y5Gxa6noBC8AXFiTMXF9cEnDGTMGpBL0t4fCxywZvrEWovpF/4zAJlyTC+FYnwxQDwo23CnF5Yj9s6iOheCEuYLgrHznG0Omk4eLWxwA8Fwk0tNcrjVlT7sSNNBoLAcsDbrAZeQlC62
 MU/49qjw
 NsZVGdO6XRFSqUR3KrpfFl11sZp2wRacCLfjvhX+CDaEqvNwjtTHiI/cYiE/ZaiRuVCFpgGVpuqh8CULorAAtAebJDYcHV/bzhhLRlrISubSdRWse9rJm/FEWSMGGl3+Jq5QGs3HitIVhFC5fIUbajlDxn3lNtwrUDeG1/vFvV2tBeX43y3icrsjD14Pbkm5HTOgGf7ww34grq91qgvkeELrYzuIyyS+vp60hj8GmwmFrcAOF6L6+MWreI3MA1eOrS/vASd8WDU03EDQ/Cm2DeDptDh88FU0+OzBPDfNnEnS/ryIyK4/7DLSXzRzZVEOLJZjg4GajAEuEuxc2duj4v8qKJLDDg71YGr9WUiweQiaRCfWg060ajbM9+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_huge_pud() and follow_huge_pmd() fill pages[] and flush the page's
caches while still holding the pud or pmd lock. Neither flush_anon_page()
nor flush_dcache_page() needs that lock.

Have the huge paths store the page and let follow_pud_mask() and
follow_pmd_mask() do the fill after they unlock, so the flushes happen
outside the critical section.

This should be safe because try_grab_folio() has already taken a folio
reference before the unlock, so nothing can free the page while the fill
runs, and the fill itself touches neither the page tables nor the pud or
pmd entry it was reached through.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c2a4f5b987ced..2edffc424f272 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -714,7 +714,8 @@ static long follow_huge_pud(struct vm_area_struct *vma,
 
 	*page_mask = HPAGE_PUD_NR - 1;
 
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
 	return 1;
 }
@@ -779,7 +780,8 @@ static long follow_huge_pmd(struct vm_area_struct *vma,
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
 
-	gup_fill_pages(vma, addr, page, 1, pages);
+	if (pages)
+		pages[0] = page;
 
 	return 1;
 }
@@ -1016,6 +1018,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	ret = follow_huge_pmd(vma, address, pmd, flags, page_mask, pages);
 	spin_unlock(ptl);
+
+	/*
+	 * The ref is already held, so the page cannot go away: fill the
+	 * array and flush caches without the pmd lock.
+	 */
+	if (ret > 0 && pages)
+		gup_fill_pages(vma, address, pages[0], ret, pages);
+
 	return ret;
 }
 
@@ -1037,6 +1047,12 @@ static long follow_pud_mask(struct vm_area_struct *vma,
 		ptl = pud_lock(mm, pudp);
 		ret = follow_huge_pud(vma, address, pudp, flags, page_mask, pages);
 		spin_unlock(ptl);
+		/*
+		 * The ref is already held, so the page cannot go away: fill
+		 * the array and flush caches without the lock.
+		 */
+		if (ret > 0 && pages)
+			gup_fill_pages(vma, address, pages[0], ret, pages);
 		if (ret)
 			return ret;
 		return no_page_table(vma, flags, address);
-- 
2.53.0-Meta


