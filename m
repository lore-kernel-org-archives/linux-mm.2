Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732DCC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EA86B029C; Thu, 13 Aug 2026 12:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646FE6B029F; Thu, 13 Aug 2026 12:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D1D6B02A6; Thu, 13 Aug 2026 12:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 382A36B029C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:33:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99AE6C0216
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:33:08 +0000 (UTC)
X-FDA: 85096790856.29.607D319
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64CADA000E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:33:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XoqBic57;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786638787;
	b=jKOZb5Bsg7Tw/HE9N/ALf5i24MwQu3wwg2Wqh5OUjYzCUJxp+1FzzHFvBdrrlDhciYVzwa
	3+1P6sG59OgSbl5YbU+18BLiCbN2c4NMHFy/A2RQF+ncGCfCgZ3wzSpOa+5PI8+gqLYyI9
	6cE1VL5Ax48Gm50HhlR75BcWDKoXvs0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XoqBic57;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786638787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f88pVlznjU4eedBUyobQ8mnUcw0dBsZ7WpYkkmcfPr8=;
	b=F2OPPOqq+G9PRsa8OqcdrK6+b59NqnOd0tZ1pqpssvczeaD0cYqcG4cPB5DpfZs9em6CfD
	piubN7BY6LphrIVHHboshIckDkojnw2ut6jT7ViCSYkxOGfM/EFFe99XF2cGZHM1Ycnl9W
	xTz22+LQ5VRXSheoHzCaBMem6yhueT8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f88pVlznjU4eedBUyobQ8mnUcw0dBsZ7WpYkkmcfPr8=; b=XoqBic576JQC205dwdswzqlh1C
	BycP0xBQ8Ku3miNJdlvx4wDw0BzkIMcEhfDtqrCjhWQjp/2CpMnmmxhLUBcMBledxDQ5YxfOzQHWY
	PEl1UtWWOaJa3VCF55Kj6c5iSVHgw50jZZrjnQmdUKKKDy+DE2/MyLRUajBXjORWjCL1XBbOU0XGy
	e7wQ5KM/EpgYypZjp/Rvs/siS96FzH66oKnNawl+HY/03B86zQYjV6pag0zhtmtURumXMyPXWePYd
	5DOx/nyaL3DiM3H85WK3nXcJ3GhJ85JXCIRPUlFhN7uYq9SHX9MDDYSAMmqqBwn20Of7VPm8ZWOay
	fkwJzHfQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuYMZ-00000003rfO-2GnM;
	Thu, 13 Aug 2026 16:33:03 +0000
Date: Thu, 13 Aug 2026 17:33:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v9 11/15] filemap: Add hwpoison handling to filemap_read()
Message-ID: <an3xv6Hae6g3aHCh@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-12-willy@infradead.org>
 <an2e1j3C_4DA5KXK@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an2e1j3C_4DA5KXK@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64CADA000E
X-Stat-Signature: 7e4hpgaudiihjhnhyies7jqg164ey4f3
X-HE-Tag: 1786638786-519558
X-HE-Meta: U2FsdGVkX18+0McuAs1uBKjuQj3xKyDKdLITkwQ+br/kr9pq6eeI+rgYZugFYM43OBv9HYj9EoE0z/da5m7Pv3N9ciVq50SmwpgPF0ahfNndoJSCQv/cLujg5fNK2H6erFCxWqoU0mpZ/G54f4W7sQ2+IevnLmVOYht0A5c2DtVmw+vygd1374vZV9uSJWKxH27LmzO8afBgAY4qOC/XfsxF+qgjq46ol5o0qyvOAc2KMz97rw1+H3FRdzHFQx7iz4p6mm535Vs4OwPhZ7+tQmhHdDn11I8lWmZry/Wt1d945Q0K9Glp9fxTaIApjWepc/nbMP/jZCMspG+ZGHGtB8gqarKe6JMNUZra2YuosQH/u6RlRKf+tiy0C+/Mxwxwn9+u5EHpgJL4lMVPSkx8kkVsfuJY2nfCthbDGDzw6EmD9YN7a4eqrhAznNO2Fhpg1Ce4T4C48fitT4toTVJj1oPCuigk+CakwnQx42yelVit5FIqhgY0jxJfvctQgvA7lhh3nMxpgTmNIzWi+cxszXSQ35KGwH2vXqw0BCrEq8cjds3I9JpRkCJTusuu29z+VQGeAh4xwvj4ojXPkPfoHMy6EfnqqUFKKxFQ/AVTu/2u6lZJ7RqfbnRnHHeT7Z6PHcDyNlNRV3yioN+nE3iX3d8ZFtT6+zrx0z2nqx03H8d+r/J5e7G4WV04YnC/30+XrkId3e9zzbX7gb15eXjLD2OXvMznQlEbUnb9OT4fZF/lN5WakHLPLvrp3qcnrMo+tZ2+5SdO0pr9oxQ0ko8eb1eGKGrcZzMHgCg09B+/tq2FZYmjeoExilZ1QqooVx59RB+KcEP4uKxGuaPq6CW9dZHvMWcd2JOwxss+ghK/BU0MtI/NjWRs3GI6pbDFRVeDA1XFmks4+xbeKnCiwzKoAEVGrMbOPRlWsrwSfTIYj47m80nKdnTusg0pImfcWf8pkl6i5p34dItKmr/3Bac
 n+2xdvyl
 HVvvYza1M3pHE2bXyBMFdwtREDUjAVMtYO3NOHZmMpw6T9DeoS+iBkvivGuV9itIIrexv3SkOt7IcrX3/8bRyLhBTySHDKBD3Gc9ol4EZiq0jWwRfEC4F3lml9U3XjwOyVl2XlaY/OFuzhlK5xRwS1yLMlt/nYc5pDmCryQCP/uR0OYnQrDBLF1vB3KKpF7vxw8YSCa3xL1u1AdbkQxskvCUuIaDe5xrF1SpssTp3IOCsEDwu0nM1dq0LVXtp1ah/04K+Zoyh0VeEby2az1X5TuPNQTpqQtpTCuHfbN8CaYclUk6KTufWrd7LfQZvguzVuQJ6ZOZ0bzAbSTZBxQAGWNfntF588eUxst4aeLbMtAkqw46kq39qAZZ7vRWTx8yQi+dVDzePw9npSno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:55:44AM +0100, Pedro Falcato wrote:
> > +static size_t adjust_range_hwpoison(const struct folio *folio, size_t offset,
> > +		size_t bytes)
> > +{
> > +	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
> > +	size_t safe_bytes;
> 						    offset >> PAGE_SHIFT would probably be more idiomatic

$ git grep '/ PAGE_SIZE' mm fs |wc -l
116
$ git grep '>> PAGE_SHIFT' mm fs |wc -l
656

it seems relatively common.  Personally I find / easier to understand
because I sometimes get confused between left and right shifts.  I
don't think I've ever been confused between multiply and divide ;-)

> > +	/* Safe to read the remaining bytes in this page. */
> > +	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
> 			similarly, offset_in_page(offset)

yes, that's easier to read.

> (yes, no codegen difference in both cases, but there could be a difference
> if the ARM dynamic page size stuff ever moves forward)

I rather hope it doesn't ... but I do hope it manages to strength-reduce
if it does.

> > +	page++;
> > +
> > +	/* Check each remaining page as long as we are not done yet. */
> > +	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
> > +		if (is_ref_page_hwpoison(folio, page))
> > +			break;
> > +
> > +	return min(safe_bytes, bytes);
> > +}
> 
> Wouldn't this whole logic fit better in copy_folio_to_iter? shmem for
> instance also handrolls its own hwpoison read_iter logic with
> per-page-copies, etc; not amazing.

I did wonder wbout doing that.  We don't currently have the folio in
copy_page_to_iter(), and copy_folio_to_iter() decays to
copy_page_to_iter() immediately.  So it'd be a larger change.

> >  
> > -			copied = copy_folio_to_iter(folio, offset, bytes, iter);
> > +			copied = adjust_range_hwpoison(folio, offset, bytes);
> > +			if (copied < bytes)
> > +				error = -EIO;
> 
> I don't love reusing copied here, but I guess there isn't much better
> (in order to detect hwpoison-derived truncation)

I thought this was neater than using a separate variable.


