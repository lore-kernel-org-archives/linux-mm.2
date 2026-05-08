Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381BFCD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C406B028C; Fri,  8 May 2026 16:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C676B028D; Fri,  8 May 2026 16:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B086B028E; Fri,  8 May 2026 16:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEB56B028C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:51:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7CAC402D0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:51:58 +0000 (UTC)
X-FDA: 84745449516.11.71FDB3B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id ED6C440009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:51:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DoEYhR+l;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778273517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEfhH7soGOY+NvW6hNKDxTNc/jmCbHu6WRc722MzwYA=;
	b=ElwHeq8GLKH2KA7apo4jySx1weWOhf4qZ4oms4u2Qs8lc+yp6w8W2loLKAq5EPwxc4kgI/
	nz2A3fUWqLOwXMQMWlcFBbpgcoGZlf/U0X2XeAGcCKZfmIsH4dsaUqSn3uneCfdpQ1uFIH
	wossrReKDy+1h9sY7FpwTYWWyzAY5hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778273517; a=rsa-sha256;
	cv=none;
	b=I3p/3/VNvowOtb4GqjECG+UxJVxrQCCOoLG1GiGYbbV2GMt7YdG9rL17sKsvCKEpMxIU3A
	3wWtyBsSJYPBkgrXfTzKX1LZXVlnXvy0AYRh/ql0+LR066oF5+9bucpuYUuiBJPKaCvD7b
	w6W3HyZWRpyQimdaYTlDrVVOJPtv7zE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DoEYhR+l;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GEfhH7soGOY+NvW6hNKDxTNc/jmCbHu6WRc722MzwYA=; b=DoEYhR+lr87lDjCCoWz43Nz8fh
	Kh5xBsNZT0nxtwdDo8gMsL6aXtk/al6mmBwBevTpmUbCeKQ26NhQ6CkmGAKHezp6Z2dO/NtOMU+3V
	BhebJJMLZiQUWLE+220yImh0erbPEtoxlTjk6dPqXI6vGdLYkFjAxUGVn6F3SVNQ2fhvpowelho//
	yfqYrWyBFcpKjGmlHokDZuKqeJvyMogo6sphO8eCM6XqQ/5daZE1m8QAW1wdP18QX6Q64rW4aGZhZ
	iExeQARLlo8H5d8ipCso98QG4x4fAT6HqtDEsgjbCeSTYwI1cQ9WZr4SLuLcS+I5m8LjFTYVOemnv
	gODAN6pw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLSAq-00000007UqE-0hPF;
	Fri, 08 May 2026 20:51:52 +0000
Date: Fri, 8 May 2026 22:51:51 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Andrew Ballance <andrewjballance@gmail.com>, 
	maple-tree@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] maple_tree: document that "last" in mtree_insert_range()
 is inclusive
Message-ID: <d5qyczrzz7yzxpveshdbm2u3fl7p3db73iczjydbm5aghkjkno@t5jf4hgkzpqk>
References: <20260506105218.2d027cc0@fedora>
 <afw05fkEikYVxpzr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afw05fkEikYVxpzr@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ED6C440009
X-Rspamd-Server: rspam04
X-Stat-Signature: zpjty9zg67oiem48fwboqahcc81cx3m7
X-HE-Tag: 1778273515-607215
X-HE-Meta: U2FsdGVkX1+X1wt8wfIWgh8ENulv0Z/9tdWXR/zKazwlUlf6ujU7FlpO/DrmnITgzoe1FbW3lXzWUffLs0TXci2xzkM4puLncWcX49cvbOdGB2GlB7Hb3GMoOkDs/4lOkxW/BRrnOq/56CFqqxXmNvPDLp6NZySzm2mPtU9/mqyL0EFW+jUFsI7SKo4Wz/uv6p3iswgiXfRDxE6QwfYYUXgKu5diiMOmNUEPkPo8gjCfZxhIdUEEv8N8cvs0d8qV4jHzeGePEdtZmHL1RLuxMtHHjqZvdSLqDVxOdeVg7A5OpAYlDJXPy36RltJtUiwNzcF382JhDp99Yu6XJc2R3K31XdSoHeGn5yv/7nZ8G46oM3dshY/86t8NWTvGBe4/l0yKP+eE2ADe5/vWQ+N6YpL6F+yQvrGc5KR2ffNWIp2R9wdniZZFGs2EL1ilJ8i9kY2PmfpBIugf+FP3YMZ5hAGMWBHMHYweOJ0w6RzQZS7d2/EoRB6KlBDlUwAZfgvqrmBqKMGGIzahK+SyDioOXsV9DaUChYI46N2y7F5AV5z3m6cdI7oqPqK01PhXq717DTGmswiDsHjr1wlu5NDm1iPBtvuH0wc3W+SpXTJC6Pqhi0D8MtQa1Gx7EhGdPLRK5KuIe69u+k/oPQ6V3nhvAZb8mro3YA3lXXVKNS+CPrplGBZVhuAg4HLHhlRqmltkngOhBSV4EWO9vypJIgEo5iBKqNoKKP/NyRVk0/N/0B1uerlot9ZR8t9vueubqERPXWRSEh8XHpSXLSM+NslcP3bXjlg63V55PUyhMbAy2OoFwskJRcBdj0dhjjOw44aLTVhOSnWTO5RzsTGkaH/7usBfYWuMfaHp8miA+Fg+GQFYVlVpblP9clPWM89aOlMB8U78oHlDk2jW40yj/v9V67xX9vV9AlAfkEUmCmjde3+fuTvr/fu9aRVgpY5HJgrrTZfv13Uc4U7rfM6bN7V
 6u7eXoJp
 6kjDfpAFQS01DZ5avO7XUiI0T4F16K6CyySlQQ0ynm2h/3vGCK7qTGU2Rv25h/HJIepGqjbmJpZOKD0sbf/y/urJmclp+8gn+PFPMZqkAoso00whbYlalW2a+T94Rb6Ysruw8PeoUE4FtogKFmm4F/A3mAqpNB6o0isnMS92S9zwLKo0tOr9ODGE4BPO8ZGeTzJX0hTxNFUgSj1qkZxdVTrUsQZZvW8l8s2s/UUebR/pz0sQyrqrEMKs5GlIQE2LfzqU9oHIfo5wKO0KYT7L2jCi2rIM3D+8NwEJmz85sjkls7k4GWglCteGM/9CEeFpX84bfapNvRrXpF9MFGL0J5F33ztYMQnHNcxHcZP1QJarlibVkTQ+d9f+RsQ5GsPuJGVvqoXJ4CecSnJvkVymEhMIexv7WBu4UKBOFjmPlBHjB6D8vfu+nrQF46xzxOY5Cke/cs06hEgGqUFm16MOvJ/hSZ82f1h5dOQRH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/07 06:44AM, Alice Ryhl wrote:
> On Wed, May 06, 2026 at 10:52:18AM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > The kernel doc of mtree_insert_range() does not state if the address
> > represented by the "last" parameter is inclusive or exclusive. This can
> > lead to bugs by code that assumes it is exclusive. Explicitly state that
> > the parameter is inclusive, and add '[' and ']' around the word "end" to
> > also stress this point.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> 
> >  lib/maple_tree.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > index 60ae5e6fc1ee..dc9591218446 100644
> > --- a/lib/maple_tree.c
> > +++ b/lib/maple_tree.c
> > @@ -5730,10 +5730,12 @@ EXPORT_SYMBOL(mtree_store);
> >   * mtree_insert_range() - Insert an entry at a given range if there is no value.
> >   * @mt: The maple tree
> >   * @first: The start of the range
> > - * @last: The end of the range
> > + * @last: The [end] of the range
> >   * @entry: The entry to store
> >   * @gfp: The GFP_FLAGS to use for allocations.
> >   *
> > + * Note that @last is inclusive. That is, @last = @first + length - 1;
> 
> How about writing it like this?
> 
> * @first: The start of the range
> * @last: The end of the range (inclusive)


I like this.

I think the range should be identified in the initial statement.
Something like this:

mtree_insert_range() - Insert an entry from [first, last] if there isn't
an entry within that range.

> 
> Alice
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

