Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD7DFD9E3D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 05:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871A36B0005; Fri, 27 Feb 2026 00:32:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E336B0088; Fri, 27 Feb 2026 00:32:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713BE6B0089; Fri, 27 Feb 2026 00:32:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 59B306B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:32:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF6D71B767E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:31:59 +0000 (UTC)
X-FDA: 84489115158.15.735B3DE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AEE3180003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:31:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QoQW8FIZ;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772170318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdI6HWq7bYS4a7NgUV29xJjFEF3QDoxmr5mq72kvj4s=;
	b=Ey49wohFEevwVFR98qpp6yD7CNdcsaSKD/PDtkZ/yiLIeVtDi357cCfE2Y9bEcS1iz+aHZ
	DwGV6GMS6zLxWzeBoNenxFL2Hmsv0votcHxtUi3Wqy3PgAIsVpL+Zsm/AQSSQewCmKyTwQ
	6n9icopLmDUcmYZgBD1QieHa2hP/ANw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QoQW8FIZ;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772170318; a=rsa-sha256;
	cv=none;
	b=3wnWKRdzEg1+CJmReFqiDLyGgULDfEH8MDL4/F7msLfGnbwNdKp2WrJVA0xcYAs6bzs2Is
	VzUOr//D8fatWSepkJ8b4xe+T3mDFbXVceer2ctEdyED4ViAT393OZ8mjAwxRKyS5jfhZ+
	5u7Az8/lFsr58pGI9FDmq4mirygju1c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FdI6HWq7bYS4a7NgUV29xJjFEF3QDoxmr5mq72kvj4s=; b=QoQW8FIZjigY7J+JkTU/Wl3Na5
	nL5dUjUVCoo21EvVW+az6uYqbCgt35JTky8ZJdW6Y/Ul1n7OlfpPsgc4S8nd2EO5Z9VtzILUjGGlV
	un+w6LmB6CgEeNLUSoWMVgMdB7SD5k78M184KJdDYJqtNrPsx0Ra6fK3EM8UHG0K2xWPHp4lH3Kxe
	fHK7Icq8qlLldjY6GvHZ7oWTwFEWCJmWotARFy6rsGEwXQRXqYi5phWN1Zcq886gJFhRfgkx96Wio
	5HMt2/pzCGhXOz5SYMD6Ywk/fQfakIpYTrunRcNnSHocvyQUQo69ESCIQov85L36TubL1qODJUGRT
	L5fhs3Rg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvqRu-0000000443b-2Uxl;
	Fri, 27 Feb 2026 05:31:38 +0000
Date: Fri, 27 Feb 2026 05:31:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, mcgrof@kernel.org,
	gost.dev@samsung.com, kernel@pankajraghav.com, tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Message-ID: <aaEsOu0hgCUznzl3@casper.infradead.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206030858.1418814-1-p.raghav@samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9AEE3180003
X-Stat-Signature: 9e58qbhqkq7ir9bq8jxk6xryaif4bu19
X-Rspam-User: 
X-HE-Tag: 1772170317-740953
X-HE-Meta: U2FsdGVkX19JkdguFW1LqJbLcWH/cKv+8+lwQS+z8AEuirMuavVFkmIxz1J8De/L69EFGXWbXnttsv6r2yhbYeBrxBhdXthrQLE/zk0QeKpHpFWOauIezTwO2WNbo+7CBp2qNy+DpOd926d6d3YT0i3WO2XYPVYRvUzM5oVX3bUodw5yNeqGrjx/gZ1SyHSSUYEy4K6OS4cNT0p+7cFlqjzwVSqaru5K54EwHPIl6z+APR7nBjH8TVw10F5YHX/CRy50QowxWpZ+eWYzCyU1XpgHtSi+stHghfytwLMaT1YEOKLqB9jntET4L3HZ7UWSMiPI7vdwhnOgW2Z+pShXR40Y/toFA+wnpV6u26LBBgg1p40GUymYOalhnUBYrXy3Us5r54bvDLJhJySseueYsU5d70AB6busT8lWfP69HiDEczjS3FXm7i2ll30de0CEbduwqSjvZ7p92ug3/lWEKhXoiyj0V71HA2QjjuH3gXN8pM9URnbnDjSXThijdfX9FaPSWMdzEh+h6sOFaMBD9SmhhP/sN11soOtgpLRe+KNB3sf8nxks9xZvBgyZidggO4n6AG7yj9rlwdr33P7o0KhjA/EJDG5jOokAd4E4oEcqwirWAZfLoja6+/b+MKDha3tNnLdS5DZeVeByJUIR+Au7v5/C8Sc65+oflOW0UEMTbDOJWNU9yudMG4cVPmoVF/LhBYmbSkHkr59SO/f73TDbhUXHBO570CY9ZiQHG/tYw19wXeovuViULeU7Hp7ZcgS3JyPp9Qau4jT5Eyk0e7x3pv5AE0TXdBQBr+MFEmuF+7ajCWJS9yEysMPwGlJuk33/bw8BDJhWLalil8GXBDj4KPG8DJFaMfiRPkUIqBfYT+iqlgn0IiiQZEU2pw5QRaOAz1CJtEiozSUI8fCERMa5yvpElgojdvQe5xSrgwfF1pQtUv16EXEFjwfjDBpIUvJ1JVCDOl0m79C878N
 FW1don6e
 YK0ik7ZkqtyRzEhB0XqhZblnostRDcQJGlSVSVhDyId8td7qFHwEKD2xVHThu8xoboPP2xrubfcMNrfFGSNtkjHCed/q5t4Ye+bfoj9UUK4raqkTpRk7+xgC0pGVUxotbXf22ueCwlSWZMsgIbUj83y5SdjgIrB+gqu3KSlw6GhgonvwOICQXEvfq/R77zKCvOsTsghHs2lCRroPizSGRh9ViYGstIY5uS6nbewrPretDMeoVcfBAfNJ833qdyn1EBi8e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 04:08:55AM +0100, Pankaj Raghav wrote:
> There are multiple solutions to solve this problem and this is one of
> them with minimal changes. I plan on discussing possible other solutions
> at the talk.

Here's an argument.  The one remaining caller of add_to_page_cache_lru()
is ramfs_nommu_expand_for_mapping().  Attached is a patch which
eliminates it ... but it doesn't compile because folio_split() is
undefined on nommu.

So either we need to reimplement all the good stuff that folio_split()
does for us, or we need to make folio_split() available on nommu.

 fs/ramfs/file-nommu.c |   53 ++++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 0f8e838ece07..dd789e161720 100644
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
@@ -79,49 +79,30 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 
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
 

