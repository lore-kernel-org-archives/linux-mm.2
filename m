Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D1A5606A338
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftCwKSyr
Received: by kanga.kvack.org (Postfix)
	id 048F96B05B2; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BDA6B05B3; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E514F6B05B4; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDEDD6B05B3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44656A08C0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:25 +0000 (UTC)
X-FDA: 85384053930.01.11889B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A5F89160003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftCwKSyr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1pJ4mfGksx99HkJq8FYvOx6HIQ0+ynloGyB5SLePdU=;
	b=dj2CeEQ1BLelW/wPRpuwBr3jhBPEBetDwr2YpOctpSEB4UVU8iY7mQvnuRLLr4U94BwvYf
	jYwGBOd1DoPKkXd7KPwjn9Xvs1BBd97jc5oHkdDWY4Ckx+6lD4qovZ8LzvUbyfNqS7ZP9F
	Dt3pXok0JVCqnld/Rj3ZCzqgc4rG4HA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftCwKSyr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478383;
	b=ksHzoe/uIPkOzTw8NDx8KYvBEXWa3UrQ5e4/SvGIxd/vAW/M4/CmjsF3eK5SxjSwASkYEV
	uLxrCkt8xLEqEL6irKXdneB2wSUU9dsYgVrU4oOjhUWrY6H4Xn6+nmcPl5Lre+QK2SGwbI
	3PboTlLn/jCm8cXGKY2AuX66eKcGvsc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3876A600C8;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4561F00919;
	Sat, 31 Oct 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478382;
	bh=m1pJ4mfGksx99HkJq8FYvOx6HIQ0+ynloGyB5SLePdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftCwKSyrq/qTTQ3igmVJUHvDKcaYxQvEaPr7Gre89WudutxclXGGdSXc/1Cy2PCyy
	 GVA55+jbA6TSShSdO2sbA/dKMoFUw+I65d9NLTiOIWJX/MgBUmeMW4kep3b1IF9Yb5
	 cgnTdQU45rJaskbG2y6UZvXeuWKcMNtifHCUVpVKgINTMWg8iKbAE9gi92prWrwnXZ
	 x/7NRDBAGyO83guQPk+J+goYXiz4Yl2RQPScs47ZYqmvvP1edrjYVWWLKwvhjBqj6Y
	 c/FnFEiSStslR+N/+BuYdcx3CNKmMMi/O8alqGfj59niN+5ebYdxsQJ9xQHMb9m9VP
	 nD/g40WW2zq9w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/6] mm/damon/vaddr: advance migration attempt in folio level for filter out
Date: Sat, 31 Oct 2026 13:26:09 -0700
Message-ID: <20261031202614.96036-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A5F89160003
X-Stat-Signature: 73i8ekhabbb9re9bwyhab7cakzeu4sh7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793478383-720563
X-HE-Meta: U2FsdGVkX18CX5ad6fFbheLRMkCOEcwoZicNAA9FAxUw5E88i/pbVbASykYmcl1GASnwCsXb0yc1ly1KQjBVrEbFPrOCmCdnZi0eM4KXM3iPBuhK3wVMB6/+N8eKjJ2UoFXwoldK7bfA9wguJ4dI9laQZc30CQEq5NA1LIx/piDMeZXcbRb918Xnjp4xl9p/rLFrZuHycr6lvESkwFioJKJulEiBYJEgW1D6ZAwv4bhwSIIns12PrLHdh/Vq/1bRGsjLbtmRXwvK3h6Z4+8OrAFaC0a+t6wf+gosB6WsPpYH1yKLx4Vwk4ofq/Hc5LDd1YKwzzK9yRT1mLGIXobV2S+XqcnfdTFMGlCJtmr+bCKaT8aLKeIDnwUPd1Id1z6uLdomuDFrDA3XFYD9keiDZ091yRA2C3Y85pyzp+bAEfyTG7pcRzgEMGCTWh9LI9WOtv//DhxerfUwYcnwpa9BtaQpYmajA+j2yTD5qw6NIdQT5NwLGZmoFMEAvhPe0mNnZR0E45vWwFy3Xz23ITqg5UQ0hM+q1NlBJ5z2IMcU+JgSUCfLxPx4s5GUDzoZ0nGSQG3vwVE4Q2Rs9D43oaKymu/3saTWaVP07FhE7mr9+ERXGc1O40wlUfAnMVVAH3JBhYJBwZLjQNC9QSDWVx72fC1EDoA1NrsrS/xyfyUzD3l8vWMFItKCUz2roLOQ5f8SzlIOllxJspcbpXo3bswSS0X/XaC+ktBok5MLph5IeEBrZ+fXp94Wj56XZN/bHRKV6KE2UBU3q9iMcsOzH0Rl/szrSKriCRKlM5VQTgk9X1Vc/MdCCzip45D1sWkZVU7hqByCy3VT8suFc9IHZiePDy8EUb76b82tyJEhMKfzcSxrCNbwsfbIby4z84n/+8otA1c5MBcgrmMtzAF1s0CrdvaeZLy4HpGSkv7QsajLaQH+u432kvau8eYIynK2V9eJx2zwP4A8U/FDgkQp+zx
 xrUGGmoP
 V5qZ+8AvUpKiLn0o17KeR/OoccRY8kt5ptAqf/AiLYS7ILNMJdXYpOUDrKwmYepOJxTz/lOR1scWY6qIaE/Esg3jvkBP731KlDSocWdU1GroeiJ5YeSAIpBsRAyDBcxnkdYK4wEVgtWc5XiT0PpePb3GDuQahfYSLfyjoyWuEQ5lugdcuJwEY8TiAAPkcWqcVISDt30umMfDEw8LV377/6vrrl+ckO9nCyjmuVGGKVcS59IlXf7XRYDR4SRnB7REwZqiOAiulyVW4ig9eKL8Tk6Rs+UIVNY1syuRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_va_migrate_pmd_entry() finds folios to migrate under the given
pmd, using a loop for the pmd address range.  The loop advances in page
size if a given folio is excluded by DAMOS ops filters.  DAMOS ops
filters work in folio granularity.  Hence it is more efficient and makes
sense to advance in the folio size.

Advance the loop in folio size for the ops filter out decision.  For
that, do the folio size based loop advancement offset update before
applying DAMOS ops filters.

Closes: https://sashiko.dev/#/bug/linux-67c34df7-6dfb-4e18-9ce0-0d26915e5785
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2c..c271b6d63c027 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -881,12 +881,12 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		folio = vm_normal_folio(walk->vma, addr, ptent);
 		if (!folio)
 			continue;
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		page_idx = folio_page_idx(folio, pte_page(ptent));
-		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

