Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD56CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4DA6B0095; Fri,  9 Oct 2026 12:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D526B0096; Fri,  9 Oct 2026 12:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183D06B0098; Fri,  9 Oct 2026 12:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8D96B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:55:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 461B2C02EE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:29 +0000 (UTC)
X-FDA: 85303688778.08.C0003B1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CF3F2000D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kypflZll;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791564927;
	b=AYiDaq3qVtOKnqMH4SKEhyuhSGBfoB3tQsitHpdFSyY/DIBZdTQLamTXQ7IflUC1tUePV3
	1EkCdcjU+F5iuuExrLbmQvqm0JyJO00tLPvqIjbEsZfJD7CboZ3AIEHFdA/sEogWFt6Spv
	GqCL9aRYqyVvPkvKh2AmHosE1cyTGP8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kypflZll;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791564927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wC5Rz8I1WR8yDSD/uB/c6pVAn56Ir5mAe0LkNam/cuk=;
	b=3+tbtD4+SNlsIVUvicxggHQ6kn1KWmgTbhGUxBorEImXW3llpubiIA4+E7/t+BgdOxdQCF
	fN2t51bf3jKNPUxm3NiAVzaSo94duVX7uVhh+bHV7gScImTblR7lrdFP07e4oi8KOSro4q
	PdYfcc4JMTdUEt/LcJtsVaz9uMQjwNs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=wC5Rz8I1WR8yDSD/uB/c6pVAn56Ir5mAe0LkNam/cuk=; b=kypflZlli3QYnFK0Lf2vTIlUqP
	mPacPVHNEeOi9Sw+ypgmxhxcanWW38ErOLjms9fPwmKTNiXEma3w2DOWBi20C5MUBE8/C85Hx3ru0
	obJck4VDsIfoUtqFxGg6OvHcQADeKpeoA3e0oIcRzPHCVc6+i6cBR1lMVjA8DgOz8cMEMBhJiHoXu
	tAp35CtwAFc+3+fNXpUPaq65uYqZXESVs30Jei0l4EVBh9fPTuFRs/woqTwg8w8vGEQromUX0wsR8
	lbjNvEI0gU4KPV9IVfZ0TpNuUdfpMrXS8Pn0A+BU+92Wfr9+CxiU70ncNAXBqqBnUDROj7muRLHgU
	r7IaPExA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xFDsO-0000000GDDX-35Ph;
	Fri, 09 Oct 2026 16:55:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Tal Zussman <tz2294@columbia.edu>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 1/2] ramfs: Use filemap_add_folio() on nommu systems
Date: Fri,  9 Oct 2026 17:55:11 +0100
Message-ID: <20261009165518.3863950-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261009165518.3863950-1-willy@infradead.org>
References: <20261009165518.3863950-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3CF3F2000D
X-Stat-Signature: 1fx9a53py7hxxpzqrff55cg8trc8wywy
X-HE-Tag: 1791564927-780400
X-HE-Meta: U2FsdGVkX1/irh98Ax0IeVlo3K2RbdKHcG6mzzCX8p2xrZjzVufHQF6JIu3liY/KMvMe94z4h5Lqfw70Jcx9tYd7op8AnUq8h3KEbW/c1U6FoKqjNCHVKVeERf/ikwTGIOSSzQwd98h6Drhdd8FLoHUkunUwLgctyWQVDjflyBt8aISnO6th2V9XMS5HxOfXp+pTpCLuVLKzgQiCVNEtW0sSAoeYMhyj4MVlcn59c4LLFkqWO90MJK0EnT18XTE7LOlgVDE8ZYR6HNj583GJfEDiRO5coRfFZ29I6tdNL0PzBwU5UFXruK+HpvOpAMFD3QRBjWzOD4+Hu5PnucXy6AsZdw6NlxT0+1tusHFyjnMOW3l03PhFqeZMJroGvMNxI5ytGQ4CE4oX8NaNtLqrxQUWj5m1jw6DEya3TzBkX+SQa8CJ4Y0A0WAMbZS3gy28vq/PubMtKEzvNWtapwBrOo/gquWuUgquDOY9TuNYyN3ZghEeJhtky81mn4YYkrr7JmPALGJFJRAOafljW0eDt8LOhBPNlAQZR4Iep+TGLW6/sG8T0uzTaL4rr1LkNxhUxFFXPRRB1uCWExvlAzWwpyoCt5g1JGn1sCgIOqj1t7mDCYaEHxZuv5kpiXGmbFc64i9Kuew1qB44kPKQOjsPC9pOn9XXDhRgs8CDuC4HEG3DkwyjMWpB56JkH7WE6AgI6/FJCaXYng34HXzuN9dFf4uR0XApebS1Se1sTRNiBklrLwrEYBuPc+TU8Uv3NAre2VIo/fxKMmLAXcAlqsmmggQbnxW0nL1GTQHWTkVaV6vebSa49+M3bHjjk/7ghiauElgXK/PobtlZMhFEaOfSBhcfjZ+5ZVJdWXI4CeRsoOlSUiAotaznu9rB5UxV60iM/l9LezcEFdJ+WjvPqzHlGHAH5VrnsvQOVH5PVGCVJ+WQySz59uxY0keIlp7HkzcryUM7EWHeleIThaCUGAc
 YQ43lQDD
 XuCbyAjkNL6Ouda4QsJnhVR4new8D2WrnLB1GDdEu6UXi8fKdvATWp9Z4YMNZlHVYBHB5o2KiNlFAxIVd+m6PkzEkj8RCmlRQxKnsk7RAf6041mv/IG27eYH8/N9ERpMKq+ctnyZYXINwaWPk6C/y9NwzioiTmvDGMPurDT8mA16hpjD7HxNNBEglkQec1leKIBMRD7twWqiUUW384rS9WxqLYkTycWbnKT2U+ReamphxJBYUWr0qIegm9ROKlslUeiKa83SAhohWGa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't send this upstream yet.

Need CONFIG_LARGE_FOLIO first.
Need to enable CONFIG_LARGE_FOLIO on nommu
Need to handle errors from folio_split()
---
 fs/ramfs/file-nommu.c | 53 ++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index fb471bf88ab7..92f33bc7a49c 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -61,8 +61,8 @@ const struct inode_operations ramfs_file_inode_operations = {
  */
 int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
-	unsigned long npages, xpages, loop;
-	struct page *pages;
+	unsigned long npages;
+	struct folio *folio;
 	unsigned order;
 	void *data;
 	int ret;
@@ -82,49 +82,30 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 
 	i_size_write(inode, newsize);
 
-	/* allocate enough contiguous pages to be able to satisfy the
-	 * request */
-	pages = alloc_pages(gfp, order);
-	if (!pages)
+	folio = folio_alloc(gfp, order);
+	if (!folio)
 		return -ENOMEM;
 
-	/* split the high-order page into an array of single pages */
-	xpages = 1UL << order;
-	npages = (newsize + PAGE_SIZE - 1) >> PAGE_SHIFT;
-
-	split_page(pages, order);
-
-	/* trim off any pages we don't actually require */
-	for (loop = npages; loop < xpages; loop++)
-		__free_page(pages + loop);
+	ret = filemap_add_folio(inode->i_mapping, folio, 0, gfp);
+	if (ret < 0)
+		goto out;
 
 	/* clear the memory we allocated */
+	npages = (newsize + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	newsize = PAGE_SIZE * npages;
-	data = page_address(pages);
+	data = folio_address(folio);
 	memset(data, 0, newsize);
 
-	/* attach all the pages to the inode's address space */
-	for (loop = 0; loop < npages; loop++) {
-		struct page *page = pages + loop;
-
-		ret = add_to_page_cache_lru(page, inode->i_mapping, loop,
-					gfp);
-		if (ret < 0)
-			goto add_error;
-
-		/* prevent the page from being discarded on memory pressure */
-		SetPageDirty(page);
-		SetPageUptodate(page);
-
-		unlock_page(page);
-		put_page(page);
-	}
+	folio_mark_dirty(folio);
+	folio_mark_uptodate(folio);
 
-	return 0;
+	/* trim off any pages we don't actually require */
+	if (!is_power_of_2(npages))
+		folio_split(folio, 0, folio_page(folio, npages), NULL);
+	folio_unlock(folio);
 
-add_error:
-	while (loop < npages)
-		__free_page(pages + loop++);
+out:
+	folio_put(folio);
 	return ret;
 }
 
-- 
2.47.3


