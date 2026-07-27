Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 234A4C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328C36B00D7; Mon, 27 Jul 2026 11:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFEB6B00D9; Mon, 27 Jul 2026 11:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218776B00DA; Mon, 27 Jul 2026 11:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED25C6B00D7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:55:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84619A17B4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:55:46 +0000 (UTC)
X-FDA: 85035007092.19.C1BEE83
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id D93A2A0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:55:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gGRvTUpO;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785167745;
	b=DofBz195+NRo4k9G8yvGTVekD4P5RtWZt3GJlYpA21f+a1RCpQD1+q/fbi5iHdgvFfXc1B
	F3QzFxMaWvW31pZ8bxl0bNcmIpGXbA3WYsn71l8eloohAxoPn2u+NlkR0zSPt9s4nWaHoT
	HE5A0V4cv53RDe1mSnp0CXtQZl9oySg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gGRvTUpO;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1YKY8dxDVPOObAhaY7i0KmqUanNkeNYqSbIMl3UWEo=;
	b=YJRDUxvXfC2Rgp7EGLYkFYKS8k1iLlkBS+Da/FcVd8mA364LgaA3ZVrztBltzZunJrhDlg
	sBJOP4uSvjZ4cjm8Po0yaC63gwq2ORA6zeuRpLEUb5j/NBsrmCV+ezxDMVVWKqG1Hgghjd
	t1OHvW6XaiY+/VrCbjADOljLLPEs//o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r1YKY8dxDVPOObAhaY7i0KmqUanNkeNYqSbIMl3UWEo=; b=gGRvTUpOQQT2es9H0vC5I1nKpZ
	Fh95dMgoA6vVOVbzwRAMkDS7OJfs0dsdoCGbtglMscHw9WN9atinw840A+VcPjErxYvzcE7ghYFPE
	yg2JaV+h0TV9D6OxoT7lp6000dEA8g+ruuYod3u0OvPs2mWOf/3mpkcrKpcShIpsQ346hZ4aK4gPJ
	AdLA8D7lejucGBnSAYtQvuR0vWvcnVKB9AI1cJ1LIgIZ1+f2ffISGpMltDGYhCN4BLOF/tzZXYEov
	yl3bwNaljPe7NPDPDydnB9G8w6N3V9MaXBRvv0ipspBxz7OkymphVIfA2ycMHvBJny2ILGkYmH+Jw
	fOukjkHA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woNg1-0000000AzL0-3X7z;
	Mon, 27 Jul 2026 15:55:37 +0000
Date: Mon, 27 Jul 2026 16:55:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v5 11/12] filemap: Add support for authoritative mappings
Message-ID: <amd_eb908Co9JeyH@casper.infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
 <20260725160042.1557264-12-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725160042.1557264-12-willy@infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D93A2A0009
X-Stat-Signature: p6fypwdwfgcxwosweh9w6zb1i9ckyp1g
X-Rspam-User: 
X-HE-Tag: 1785167743-54968
X-HE-Meta: U2FsdGVkX1+R8QpKDb5ne2RDjDaySzxaycNq08sHX+24IEfrsFBsSOfbpTIKTiJSJD0HDgFXZCNt4wRGoS5RqjOI7qgkfqhZSAVHmSRZcwShkBK1bEk0QzgycEvd9dAfDuOGjd7QolnRZHg9SVBF9VdVNcWr9qSYPW7rrPCWRTbXzX8+kOuAW2FOWldHhhmc5qkwQiJuMgKs/+l1WCj5krWC+32DHE473hVhY0hN9JDaVYVYyj3HxzVnAmxsliVuZ1cRbkb/xwia1HWRPbtbHYuFDerEGZc95Zp6wDFJ7iSRJizFnhgu0Bw3xK6SfCoCf/bxWMI7ggBUh9mMmBVqc7/HD8nroq5sbcS9eIo556UTuiUCfthbyADRq5ue+bKkdXa5gLblurE5yNK79Q2GS1NdwU0YsC/RrOgUC0lE60d2t8xnUEuZEvZ6ZyFGZJpLuAzzUqJg5Uv5LXiZSO+bUcSiAkp5t4KxAM7m9bWHdDpoFkh36bAkybuaFmWag84VXEcjDqPD8z370OpRJEO43OYPykVB6ke0KNcYBYI+NZ09Uiukucdk5t11+/EpYNXJJCQzJ9d/Y/BGY4rREmaHccog4UqqYAy2OR0Ivyc0BR0DMtyymgf3PQiFd2IrtomzSXr8/YrVapKoMeG5yn9E12KRbdHr1GziguQox+ro2Rw4GWjsAXrUdkcQeVi3LUSWARk1KVHu5a5Cs61ivXLjrykdvTZyhhqvEnaB/vmVIMqTx8T1A7mBIj79PYhHEKf2S0aSJSsLnoUNmJgtVUO81ug6FM/1g03ZKw8kqK2I9HKmIY8lZtjY9Di8ifdlX1ruEk06SpwBdtNEq/KHFMJRuTFhpqf+Z1FQJxY5AGW+7cgUqCXEsH+WTJqxHb3NLURRttmgxiVJXOOK5i+ZG5xZvml0LjLaLSmDCiAdh2UrykLc6oeOvE1ANhpZkZq2wVGsbEPkDOS7k+Ta6OgXuTD
 5Y1hqLiT
 vwWKXOTxswmpGOsnUN4BW0WC/YnqwDFt4lUVt/IvIaBLUImCcLvw/R8vK+3JH1vyz6OyCl31F8TC/+dtJO2yWpsy8Q2tgba3j4NXuNo89LqCr4LR6OQtl5z6KISFmD6I3+edq5g2oraVuKkRrDtkTI2Yk91XYJ6wyTDQkX0VAqonTYZ//k/YoW/eZK4OmTGPQ7jRuUfLDyY/j+AMIii3Ne2lMOmvNgfN1cSUrwgCZUp0ul+BZ6/N25D0aOnYQtV9++WRC9hFF5b27x9tteUHmIX7JGK5f9+m74no8CIyn4+4vWl/HngT4O2mfbPXFbtrJ84ttYqhBvvSjstsm/mztk+FZ3wC8PNzUB1QhaipKTbE5iIQE8waflhkdFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:
> --- Patch [11]: [PATCH v5 11/12] filemap: Add support for authoritative mappings ---
> commit 7b270a787d853107f7a64dd3127d799a28d3142e
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> filemap: Add support for authoritative mappings
> 
> An authoritative mapping knows about all the folios in the mapping.
> If read() finds a missing folio, there's no reason to allocate one and
> try to read it because we know it's a zero region of the file.  We can
> just call iov_iter_zero() instead.
> 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 26a5f18121f90..5a8cc20e624e4 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2697,6 +2697,8 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
> >  	if (!folio_batch_count(fbatch)) {
> >  		DEFINE_READAHEAD(ractl, filp, &filp->f_ra, mapping, index);
> >  
> > +		if (mapping_is_authoritative(mapping))
> > +			return 0;
> 
> Does returning 0 here cause an infinite loop in filemap_splice_read()?

As before, hugetlb doesn't use splice_read() so adding support would be
dead untestable code.  We'll add support here when we need it.

> > @@ -2853,6 +2855,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
> >  			goto put_folios;
> >  		end_offset = min_t(loff_t, isize, iocb->ki_pos + iter->count);
> >  
> > +		if (!folio_batch_count(&fbatch)) {
> > +			size_t fsize = mapping_min_folio_nrbytes(mapping);
> > +			size_t offset = iocb->ki_pos & (fsize - 1);
> > +			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
> > +					     fsize - offset);
> > +			size_t copied = iov_iter_zero(bytes, iter);
> > +
> > +			already_read += copied;
> > +			iocb->ki_pos += copied;
> > +			last_pos = iocb->ki_pos;
> > +
> > +			if (copied < bytes)
> > +				error = -EFAULT;
> > +			continue;
> > +		}
> 
> Should filemap_fault() also be updated to handle authoritative mappings?

Eventually, if hugetlbfs is ever converted to use filemap_fault().
As above, it'd be dead code.


That's it for interesting Sashiko reviews.  I've omitted some which
are suplicates, either within this patch series or have been reported
against previous patch series.  Feels like we're close!

