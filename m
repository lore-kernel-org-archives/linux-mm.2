Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7DCC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B81F6B008C; Mon, 14 Sep 2026 12:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768EF6B0093; Mon, 14 Sep 2026 12:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F856B0095; Mon, 14 Sep 2026 12:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1CC6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:21:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E67781601B1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:21:33 +0000 (UTC)
X-FDA: 85212883266.06.03D2DE3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8788680006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:21:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q+FoHqB5;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789402892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=297+JVBEXI3c18C5qieX5osE5xEML3voRV5ucXXH6Bs=;
	b=vy36jGUJVYscipq0j4x9+nBm90e6CuP/bp1Er+QS23Ts323GYni1k4iMtBRsWQTtIvG4Kf
	sOkEFPM/tBOCW7fGZWOQzxLBR/vGeYzpn1w6ibY8ib0Ao6PHIZR40sqWzv9IEo4n7/K4dV
	2myHc0QroLbw5/YEQFmei7meJvZpJCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789402892;
	b=24gIVNv6yhBn+nwO1aPwvmRL4HQwiZ/A/P1bVpFM2QWs4I/mhiaqNskRPXqhO1sGl6UnkJ
	iBK/UKjxwxtEvJDx12hZNHQ8zpUZnRnfz1pZCpwzr70kxudduwFnQapTXCb9SSqbt5yXYz
	l5zPfzs5WX0YgyJ5ze7PAgppB6uQCGE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q+FoHqB5;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=297+JVBEXI3c18C5qieX5osE5xEML3voRV5ucXXH6Bs=; b=q+FoHqB5IKg9Ayh3ygItLSuwtx
	NEiaehM4HOdu88o69y5LTlU4qriOwK98hKIm6pHDAcIWjQ748TOOAWbZ9krcXn2M0REmUrTOb975k
	/kUYjdjcJVHnJYfpXt6JbnrvYxXWwi737Zzag4Gby1wOwy35cjiP/3YMODS3Lj+O095lhiaEedwsT
	9fAMxoKARdG/vrvEyb8ui8nbtulWNLQWZdQemDu03gh+gvV7T5Qw15RMng3QQSmuBBoHIYdjn5+6c
	UMfEiWRPFBQvvZeFWFyIur1/b1jBqlOHiVHGQr8WOrTrFbmBAPRmyDFa2I2kKj97NNcvX/1+IV5fw
	Yt5vj0lQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x69Qp-0000000Bud4-37Df;
	Mon, 14 Sep 2026 16:21:23 +0000
Date: Mon, 14 Sep 2026 17:21:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] md: Use folio APIs in free_page()
Message-ID: <aqgfA0QFi98gXYG2@casper.infradead.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-2-willy@infradead.org>
 <20260914043129.C6F8D1F000FF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260914043129.C6F8D1F000FF@smtp.kernel.org>
X-Stat-Signature: 8tau3uwjcr4kfpygzr8nnujx55okdx5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 8788680006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789402891-135349
X-HE-Meta: U2FsdGVkX18zU4rc2bt4Ud6IdVcwUtsBIXjGrhSsaJYXQzWDh7O57bPtfTWS+yiw+AylRkEXP9DuqqC224d9XIoYCXlQ6LP8nwVOlxm/x13j3TwAFf4lvg0df/juN+X3gEKP3xFuxCnlNiH/KRufD0ZRT9jhu+MN91Wf5P/PfhsPOBLISfm9QriydFzA6GhusbJ+G/l3eHNaR6BBlQxilWdDB0dj5rFlbKfs+cUn+x+4QRDlqPAUdDE9bzPM0t8bRf57Yvm3UM3K80rKl3BSIHMfoKh0DjaRv5BDjSB7pfJ3rKTIEVxMcIB/6ourfZNqZUlDlVPrnimZDyM42+gmKd3JLL2oNHSA/Nt4w1gfo+h21CLhRLYIaogI+INHaxhpsF0i4HTg5nTNCDNI9RhMYUhRSpO3TwzK+U81M8YnRgXXrBSUgpYWvcI1sxX2L3NqWI8BGzahfA2GMxOOaJ6SyT/hEibVzHY3/jDnDphJdx7lPcitlGzRgiBW7k2jkM1HejFfi+Gc/L+sFqbIcksjstVL8iWgIVAZ1f0utm9UJmj53Yy47OsKSAPR6+t+jPa2iyjz3BiE66SqrQAHJ8Y3E6L1ZiAqxnJvoidoN2oBCq/O8WI4tmcu42teYxAel0ule4LEF2izUvyvof9DoQxfZdTYJ5kZUkyXeV41IyKC6M4vlDrtj7hTuhmYYt0kdLN+D82eQhJnp/Vp3Zp3JupvJegpUIWknSFnddkV64lGB5LaUm/O5NzpVpkOKKyHecyQZN3D2X6bZRN7wBQQ7gAY/wzigTeZXyBgJOuYfdRBxz+W/tcN6hbSoLmA87bppYQr5fXChdQ+QdQV5KNGY8Dr4EFKalF8gEwiIhrpEWnC5sdJZSnHd0hXOWoBuLbWcE/mjXWKPHUSKDtuH6vTme5TDr8pIoNno+F9s2BBN/mDw/wrnJg3JgbWaPE+pSrgJkdh90YUalxKL8WJsicqeFO
 scGf6wWP
 aoUevo2XbjDwHKaq4xlSDmAZV8ekR+miw7Ne1CJt1xlU8K6h2Uk1fVQkEYvVCS47geGqPTXnia2FSBq5czLvP4xy0PHpc3OI7TAfz+CHmqafwmLC9Ai0baifZTWtYw/IV+S0IwDLu/fCNjvIHqrQOLcMSf+ffHQ/Pejs3SBoAio46fnyvR2U2fUWLztkkVIpya0WkHtxdYOdHDW72xchWbYtHsgTBdTKGdGZhoJ298Ehgk6T8VG0NMSvCEGLRV3ydPKoL/fd4LBTfvQ1wFPSJH5jkd0E34yYZsGI+CpV81kqBgRZU3ZSbFDSNsGr247ZWn/k6EC2KaTVFZKw/jEhWxiHF+qU6yDzjeftY5+PfTwx3pLHbb73/bFJD0nJ8WyBueLAhhAlDo5uE7Sg7Ito20j+I53kq/fSWC64bCfLdONMuPXpJ626adjRzmiefDefdEDnSDPq0OFqwArPjQJvmloBgwaMErxZ8SPfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:31:29AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Memory leak of internal bitmap pages and uninitialized file bitmap pages during teardown or error handling due to an early return in free_buffers().
> --

Yes, I thought the early return looked weird.  I just believed that I
hadn't looked into the code enough to understand why it looked weird but
was right.  Since the AI says it's wrong, I'm happy to believe it's wrong.
It's probably not really a high seveirty problem because most RAIDs are
set up once and then never removed, so the leak doesn't matter.

The other thing that looks weird is that this code believes the b_this_page
list is NULL terminated.  Most loops over "all BHs attached to a folio"
have a circular list.  However, that is established by link_dev_buffers()
which is not called by md-bitmap.  So it's correct, even though weird.

The good news is this is an easy fix:

@@ -536,9 +536,6 @@ static void free_buffers(struct page *page)
        struct folio *folio = page_folio(page);
        struct buffer_head *bh = folio_detach_private(folio);

-       if (!bh)
-               return;
-
        while (bh) {
                struct buffer_head *next = bh->b_this_page;
                free_buffer_head(bh);

I can submit a new vrsion, or Zi can just pick this up.

> commit d68f524234e61e6567e52a27e09b9d2546ab54af
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> md: Use folio APIs in free_page()
> 
> This commit converts the page to a folio, removing some of the last uses of
> a few page APIs and replacing two calls to compound_head() with one.
> 
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> > index 5f1637f974c15..7b42db87d536d 100644
> > --- a/drivers/md/md-bitmap.c
> > +++ b/drivers/md/md-bitmap.c
> > @@ -533,19 +533,18 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
> >  
> >  static void free_buffers(struct page *page)
> >  {
> > -	struct buffer_head *bh;
> > +	struct folio *folio = page_folio(page);
> > +	struct buffer_head *bh = folio_detach_private(folio);
> >  
> > -	if (!PagePrivate(page))
> > +	if (!bh)
> >  		return;
> 
> [Severity: High]
> This is a pre-existing issue, but this early return skips the folio_put()
> required to drop the base allocation reference for pages that do not have
> buffers attached.
> 
> For internal bitmaps, pages are allocated via alloc_page() with a refcount
> of 1 in md_bitmap_storage_alloc():
> 
> drivers/md/md-bitmap.c:md_bitmap_storage_alloc() {
> 	...
> 	store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
> 	...
> }
> 
> During MD array teardown or failure, md_bitmap_file_unmap() calls
> free_buffers() on these pages:
> 
> drivers/md/md-bitmap.c:md_bitmap_file_unmap() {
> 	...
> 	free_buffers(map[pages]);
> 	...
> }
> 
> Because internal bitmap pages don't have buffers attached, (!bh) evaluates
> to true, triggering the early return and completely bypassing the folio_put()
> at the end of the function.
> 
> This permanently leaks the pages allocated for the internal bitmap's filemap
> and superblock.
> 
> Does this early return need to be updated so that folio_put() is still
> called for folios without buffers?
> 
> > -	bh = page_buffers(page);
> >  	while (bh) {
> >  		struct buffer_head *next = bh->b_this_page;
> >  		free_buffer_head(bh);
> >  		bh = next;
> >  	}
> > -	detach_page_private(page);
> > -	put_page(page);
> > +	folio_put(folio);
> >  }
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com?part=2

