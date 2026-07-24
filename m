Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD149C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708086B0088; Fri, 24 Jul 2026 09:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9406B008A; Fri, 24 Jul 2026 09:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEC96B008C; Fri, 24 Jul 2026 09:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376C76B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:24:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 981AF8023E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:24:21 +0000 (UTC)
X-FDA: 85023739122.29.684F54C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id C1DEC8000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:24:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G0eEmgn+;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784899460;
	b=gOxwcy8SgoDDo/j1a2jM6cDOyFYHvzU2I1ZTXJz/LnvjXO9qUBJbf2PR8zRJrjrWAcrYrJ
	QdUHYUXKgsG2fKBvF8BbyB8V8M0jl8bCCPuCBQKDHKITsH9tEoSNgHaG38PoIyjmBPsxZd
	LAZEgXzWSiM20PDmO9wrKnyrfCB3cV4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=G0eEmgn+;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784899460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNZt1Lmyz9OGAAhL0ppxm6oxc4dour8CHkwYM0ZCDr4=;
	b=C6HHczu44fSBL2tgpxW1xqvGtSr20pwtcvAJBuNH89p5q/gR7k0KzHCPiBzGakPUzPd5WB
	EqkeE/BMNJ0KApcFYRNH+JDwendR0UYddzkrcf+NEIU1RbFHXkLEF6dnPMG2Q/qbC6Q7CW
	l85FBvICBKLSRqM9hpPMpQ45D2+9hqY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gNZt1Lmyz9OGAAhL0ppxm6oxc4dour8CHkwYM0ZCDr4=; b=G0eEmgn+6+kn4CtVtHA7ghXxmJ
	TuvP6rDtyJj6YSFCunmL2hd5XCus7VuVpuaJy9glVb/qRJ5eHsbgVI6wiXZpb1Gw7uxf/qvOT/yGd
	FV4sGUUKG2MWVETPatCgY9ko7X0J06AUKeKFQAMOsRTDY6Qn1xJMpRAnWe41Mw+Ap75OPIh9BzGkb
	isjLKrXFM230Nlrz7WGJ1yBEJQn+k5O7e/0+3nr8Fp2WIGNfIJ/VaG9cAA8/Bitf0+/770jGNumNR
	8Cac16d3BvbeY3/IdIyt0JXJkojvORSs8esxA2RRip+nzSu8q6+mJ86cNqfqp8u2AMhw+QblIjmyv
	4/G9llBQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFsw-00000003XuZ-03Cn;
	Fri, 24 Jul 2026 13:24:18 +0000
Date: Fri, 24 Jul 2026 14:24:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
Message-ID: <amNngTk1E1vrbvCd@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-4-willy@infradead.org>
 <20260724085124-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724085124-mutt-send-email-mst@kernel.org>
X-Stat-Signature: dfs8hm5uygft3855yw6uuus7bnhjdyoq
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1DEC8000C
X-Rspam-User: 
X-HE-Tag: 1784899459-283567
X-HE-Meta: U2FsdGVkX18dn4Z54cDtjgNoEqKMj1sRWui0pQXwEfk9qN/yWxAaaGBKUhfjuRZzfay0YiJYYleUHp4htWm30spgvs+N9gr61SwtRDB4I3sSIT9VMT3rVL8Lufo3tWAsd46deaGwptrC8nn4jsUP3KZQ0fstYHE/9Cvpqi97zZ2wxtOkg92zH2z8K1EdzpwdUGB6wHY+i3TP1mehho24AvZe/wtyTtesPpZ3q8qgIr09frnUexGOJSLRJHPpvG+oXFt/OdmjisSepNGtjWpF/B75Yeoq8okG8UpQvN2DH7lYy/qBqKnvSiL21Q0CoRcF4zOhtoy5F5f74UBOwwBTVUwEGBqUEydbm1V3C3vR7MdmTLVfBqvS9TCvzC6cJixfeN3NA8vCZi/KNTaDN4U2SCghIpJtJ6vNvR55nWaXof200RQYVH0v1i4SshXiFsV6kOhqtPX86+w/b9qkUAWztjja9sTHGwCPzPz3WFGj3EjXyZ9DVHYnOHhBMwy9XBUc5ddiRvzsUd7JS3RkD24rNreF5Z+OY0mi/lFdBxGe3DLfceNI8o3z2J9sUWO9+oN7I9OgbVMYWqkY2D5E1D0vnbaXopbka7ZEXNX0moUrr3RzkVk7DSpraiR5+Gq4opPucVD5+skUgy3KDmL6uzhDaNeyEL+kJEz4EYGAEhJNYVkobXrNut9U9YauXB67vHemdilAe8lRYDiMWi7rrsJJtpWKmIzi4yr3hsVMX/ROmBb1l5gVsgcNEh6uu5I9DzpnrVjbX/w9pfY+UxFy6dLOxEOaBpLjRIkXT+nmbQnW/uaIpoB6obs004tG1VAaySeKv80i9nmrhWx9FOLPuH2+zT2ORsR7EA0uKdcvsg5/Nkj41GWGa0YQcugdYFN2X2bJUGGBElxVQvN7fGW0NhJ0Jy+MJt0l5HzRcVNeH54S2rLzkkBXo+TzeKfGjo6dS7oJ2a6AybkGKx2+EXmP82E
 4Jqb+Kks
 Mmze9uExUGhhGI3jzPjCLzu17grrVDyD0ltyl2zH/k5uTzWvPNb3dZdCmy62QjAQ/za7HAyQ5XFNuR/5ckjLYFhHwdvxEmGiz7XN8fMUh/kE5JMJUfw49f0uKDrWASHInsAr36C0WWP7+sj2Z0SFLGoc5g0FLGT/xEtV1zElkYToTx6GmYANwMHpIRCt9pbM5qHBkQIcHUtRLlYVScKGOV5XTd5jGOIwEuYWs2VE7tiueiQaAVysGMFeiAbIXXPOkSekrPbN2hWF3M1DbK+5t7ddsObbgGJdGNLT21V83qAC05umSWmnasmbWChTSoehDAsQtZU4elsu7Xlwpo8K1xyFW1zLFH6uyUyN+wZBQDRbLEjrs7dzz/usQVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 08:52:13AM -0400, Michael S. Tsirkin wrote:
> > -static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
> > +static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
> >  {
> >  	return folio_test_hwpoison(folio) ||
> > -	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> > +	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> >  }
> >
> 
> It probably makes sense to document when this should be used
> in preference to folio_test_hwpoison, given a lot of people
> got this wrong?

folio_test_hwpoison() / folio_set_hwpoison() / folio_clear_hwpoison()
need to stop existing.  I know how to do it, but it's a lot of churn
to page-flags.h.  Not something for this series, but it's on my radar.

