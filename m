Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B443CCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 20:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741B86B0088; Wed, 17 Jun 2026 16:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC226B008A; Wed, 17 Jun 2026 16:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595BF6B008C; Wed, 17 Jun 2026 16:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7916B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:08:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A9C214058C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:08:00 +0000 (UTC)
X-FDA: 84890490720.10.2BA71CD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id C80D0180007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:07:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FWZohVnf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781726878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkc/cwFVPTo6PfiKk5XSU4N+7uAosbnedDKdwgjJAs4=;
	b=UFeVhDgkC4+eLcgAi//RCJiCiQ2prQ/cDXt1yqNG58uiUo4NayluGBcf3XPpURFYm6A3mF
	LbElrWCHshJvyNwOuJfBcaoY80JvLmcNV9mjC0ZWi/fIf1H0V2XxLCaztlDKdnVYM+5aiM
	gtr4IFD4e+7Z9EsM7z0KQI+bKVqytXU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FWZohVnf;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781726878;
	b=16/AiHKCmHb6n7m3JawZ/tEHoFPUYZHejpBkmV7tdHgIGkHjCZnGqv/zGPYgAbWDfVpX+6
	1aOyyPLxMt3MhFvZ1/piizK4veOIflUk7fM2K4teLgI0nFI+icA9Dk5a8ERN1FWK8dau1I
	lt6o4283SFkyo/ifjOTY5tK0I6tao+c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xkc/cwFVPTo6PfiKk5XSU4N+7uAosbnedDKdwgjJAs4=; b=FWZohVnfjGzWlfq0c6Jx8HhCkE
	uHSI+UsVJtrzf0zrp6i9dUqecmh8INz9icR8j1wxFgkF5Y/2z1rpGYcIWo2XI//nGKTuoWbZrzy8I
	pj5c+PE1kJtho72bNCBEASb3GO05NK1OT59UjkqgmeHPzHUzT5fcZ1zRDwKRoVP+GQ7VE0e+2+K/i
	ki7eZcQbRWaBpBDmCH4vXhtFyX1XADU8yfNmFGwVqTTNtxj8rtyKvzHbRA+nv5U/IAOGG+jTgDZRw
	WDk2Ye6HPjDzgc46m/BTkwX1LTOKK3L4RvUAYzUtPjHI9F0iPqntolPyYH2zHlsV7UJ26i9iXhUYd
	cKw5xM9w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZwY2-0000000DDQk-3y3d;
	Wed, 17 Jun 2026 20:07:43 +0000
Date: Wed, 17 Jun 2026 21:07:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, viro@zeniv.linux.org.uk,
	brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
	rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 04/11] hugetlbfs,filemap: replace
 hugetlbfs_read_iter() with generic_file_read_iter()
Message-ID: <ajL-jsMdL0u1wGo2@casper.infradead.org>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
 <20260617172534.1740152-5-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617172534.1740152-5-jane.chu@oracle.com>
X-Rspamd-Queue-Id: C80D0180007
X-Rspam-User: 
X-Stat-Signature: t1tsm7hn3twzd4pdr61msre1exugg4oo
X-Rspamd-Server: rspam09
X-HE-Tag: 1781726877-296861
X-HE-Meta: U2FsdGVkX19EXMRoAWjiiiamPlAado8uHtlE+Og9SvG4f1cTxzsQTxieIZPI6/K+sxgZVHqBcjF2udXeC9/qADDAH6fw8QgxwuDRKR08M39PKbot5fC//nbnQhSHpZ8ntZr+DII3TDFO32PHJ5tug2UvHLxQK63HxhwyH/wrOSIDHJb5MR9DyMc+YCyW1Ydvq6F1zD6+eP947C/4dYLt/AeNeO+HFbr8UbuOadEgI3NwSFOubyQh2mC1NhPMZzlv/nz67YRvM9HNJ0DQ12CgXc8C1FgBYvoR+z/ISuBGDdcdGPoOHCxDJTS/5WlYk9nVImB/waScdDlROAxji4ikYYt007Su3Q3GCF92+EZf7wIag5bw4n6ByLToX/vCAIq00kge8Z2yFXmJTfntNYnasbzFeJUgHUSK9S/+fjvwc1zDXjyFtM1qQwxJtZqIMmlC0R671HUehAEMNGTB8tE5enckKn1Png/TOT9y2m1eAvQFhgLeh10eTN4+TyRxbraVYEgHZLEDiigDfjFQHz6OCrqyqYVCPk5VOex9rC+rn5j/+VzqkNw3FKs5jjc+xi/Hkzbn0Ddwyhm++N9fo5nl8UG6VzlrRTWRJr+zsY6B1PRt28PBemKm+EFeqWVKhpUtcGF6LcKNn9mw8BcYm0fnJQWSzlp6+2/5CcPCUX2otjwgyysZQAreOdIO1bOmeiwAYK6MJT05La/8diSp5gLqB/C49S0eFR2ppbPU6ZZ7wvmYSEPlClOpzpzN2KkUvq8T454/hBm3gBTS23F71CVtfrXq3MN0nbzHVRltv8fFyjx2TlG5FgDdV4NphNNxDwgUlrY0kyGWxibU6GYxZT3yeSN+aseW+QImPQXCeN4yKo8frOvkvm87wfvGZfzZtoofSTa0PaTNJs8d88tX861U9fB9a0XvRbZU0lIDz7PHuL6wt+ac/DwfEmvpbAIWMt5wLgWmhCqjPYgsmi/Mmur
 JBdC3T/l
 oNcbWR/ZV6z8kIKNvxiomr30ONTFZIxApRClzB3yxTIqP3DAjnrEuKJpxmiQes5Rl6tqOwQE7L46uT++Snq1IqRDWahYdjs9/LeX6UOXnCXND2HyoATGklRmncqr2q5HeVKl8y5g2B4p7NfVafImsdHEvAwftLHqAv5qihEExC/sB2QwlLSswpUNNr2bA//Hptc8ABgRMxY3FNsHoHdxbmnD2fFX96CVMVesygjy26u5mZJXoyayHdoQFAI9ektBhvfv3yogP59Z7P6LuRgfxg24yJ3a9YnjSDtSPp5etPnb0lgygd3p0zsS7KdzPlu7cNhHBwZhRhRbowyAHIuRbM3cN42t+75YlS1Lfgd5u/eeunCNaDhNDYZytwSO30ijoaTSVvcVDBzOw8SE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 11:25:25AM -0600, Jane Chu wrote:
> +++ b/mm/filemap.c
> @@ -2672,20 +2672,30 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
>  {
>  	struct file *filp = iocb->ki_filp;
>  	struct address_space *mapping = filp->f_mapping;
> +	bool is_hugetlbfs = is_file_hugepages(filp);
>  	pgoff_t index = iocb->ki_pos >> PAGE_SHIFT;
>  	pgoff_t last_index;
>  	struct folio *folio;
>  	unsigned int flags;
> +	size_t min_folio_bytes;
>  	int err = 0;
>  
>  	/* "last_index" is the index of the folio beyond the end of the read */
> -	last_index = round_up(iocb->ki_pos + count,
> -			mapping_min_folio_nrbytes(mapping)) >> PAGE_SHIFT;
> +	if (is_hugetlbfs)
> +		min_folio_bytes = huge_page_size(hstate_file(filp));
> +	else
> +		min_folio_bytes = mapping_min_folio_nrbytes(mapping);
> +	last_index = round_up(iocb->ki_pos + count, min_folio_bytes) >> PAGE_SHIFT;

I don't love this.  Is there a way we can get mapping_min_folio_nrbytes()
to give us the right number for hugetlbfs?  I don't see why it wouldn't
be possible ...

>  	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
> +
> +	if (is_hugetlbfs)
> +		goto done;

We don't actually need this, do we?  For hugetlbfs, I don't think we
can get 0 folios in the batch, and then we won't find a folio with
readahead set, and they're always uptodate ... so we're just skipping a
few tests with this?


