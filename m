Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66A30CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 05:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977FA8E002A; Sat, 11 Oct 2025 01:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950008E000E; Sat, 11 Oct 2025 01:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C9F8E002A; Sat, 11 Oct 2025 01:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7465A8E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 01:00:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09979C051F
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:00:33 +0000 (UTC)
X-FDA: 83984632746.09.A324813
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5DF98A000C
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:00:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aY7/mYYW"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760158831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwINF39Za9W8pbyNPLBBsYysgw3nmU4lLhfEgitfLP8=;
	b=70vbWjpCY/WYDdgF/xUHGzVTG5sO+oddcS2GnPi5NyFHl4o+tpwu1YywhbTf5DNYSm86PQ
	gIMvX6GZb/R2N+vY5YRJfPezlTq7nfNj7Zqbc4nJsZWgKhrpuL0T7Pz8vQ+zwcDfWIz0/w
	bI4mgg5ymFAAImcbat3BwC7KmTjaB18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760158831; a=rsa-sha256;
	cv=none;
	b=d5ZjFw9fXuGE0PwVSUxOuSCMplTZVA9NbpE2hIuTC/teMPwzJyMzWPF39LsyDpXp6lyy5L
	Tg27VD/5vEw9fA2lkxWvUc59yoSaVanUu6Bhs7bAc2dHe8yr+2R/1C4KJXEOyZZydrLuDI
	WW4NcNkQteTHj/8Lv2lhRqUaxR88ol0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="aY7/mYYW";
	dmarc=none;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pwINF39Za9W8pbyNPLBBsYysgw3nmU4lLhfEgitfLP8=; b=aY7/mYYWJE1Se3knWIXulnfUBH
	38pOZI9Jll+gJU4XfLd5rZT4SKJhYqQZzHG7ZI7DVubGM5D9SjNnITFu8NkoyRntk2rNr+a7TK6e6
	0rpH/WVKrXb6nEZiXPV59WUMgQC9M4BJmPlyX9oVRWjE0TUAdHt5TRtLOpetJ3YDW7gIHljZIiUJU
	7gOuKGthrWssVBpGdkYHEm+Vl4nLRxLq3Z8FQTfV7Pz5XDLleu7h9OqDClKOk8Nkz9gjmkrLbjFtx
	rChjsrjAhCy5X5uK1lY6o0CFylZ/v7XLBxJu/aTvi+Z4DIewqlVdpNZ+MBIr4xr/2t4YJQqHknWn5
	vab37KZA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v7Ri8-00000006OFe-0RbS;
	Sat, 11 Oct 2025 05:00:04 +0000
Date: Sat, 11 Oct 2025 06:00:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@redhat.com,
	jane.chu@oracle.com, kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 2/2] mm/memory-failure: improve large block size folio
 handling.
Message-ID: <aOnkUxWPODofUnRy@casper.infradead.org>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-3-ziy@nvidia.com>
 <934db898-5244-50b9-7ef7-b42f1e40ddca@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <934db898-5244-50b9-7ef7-b42f1e40ddca@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DF98A000C
X-Rspamd-Server: rspam02
X-Stat-Signature: jzby1xy79nyg1fsg43yknjea5ajbp57c
X-HE-Tag: 1760158827-961566
X-HE-Meta: U2FsdGVkX18HIKOcr27xyKYkou8hTFu+C9/8xYnMd+BadSWOe6h+YPRuWuHmBttsklLOh1FBehpOBNYGrf+Bvd6qc0SrlxdGk1n1AiTaUYvSHrEjc2mme2yJ3B1/7Rx7W7PF9swzZGT10ARPNFgY5clUsq2u543pPQFGuisSg50NO4HAYVQix3V/ucJC8kJpZRdlvemGSfud1ZiY+wbofa7PmhU/2aJI5xp11+UfnsX1XGRZ8NO4uO0dkEiooS01ru0w10Q+xGrzxs0XwnDeT8hvUvITNe7rcvmzZwZ3KJXPsHQp5o/yCjAQmCQUTqvbJpN+QCMVrPLNUOyvilqZPJaagv6Hmqs/aa6gAA7xQTFjRlUBaASSxVAJNwfnfOcPCc2Z5igmnCF0AOgXdYNW4bair3FtJTGAU95ZWM2kXHqXHoMPCQ3DyNk6ordj3B6W+xDju5tqCq3+D4FnX5l0j+5sMWpaI6hvn2+PvuQQLC3hPJmULBtwVOYO+M1pqooRP7JFrw+CLbAp71ANDjtUoNGUnXQAMxlLMPAreDQ3FdCnhnM/UT9NBdyl+Wd44QnABihou1VAXGqiKt8PZJ4cIMlTfcpL2CEGr98u9AiUHxF/Cx/tKT1brqXmDUFZP6cOJiwKkra1/v3zvJKZCFqiLgl6XEc6LzfxW2fcV38uwXkerASbay+jSmA46W47GAY8ICNxQeYxAYXy996ppF/FJImamvh0Kk8cwEvbYlKfkc48/LzS0LUpZ+kcDbk1XbZzqEcQNS+CbNRjfxj6uwAIe9nx0ElksfchaKJEcrXbfl4aKQhBNcORHawMiMBjaYDW4hwpicfdok3mVjPwwO7HCvxsUwx8/lTZFxzfIBBnFPdHvB9d0BINzcmEkTM2ojn73usXZF6/Rp5vxd1+rqAwpkDarc4pYTzfFO7yU36kV1ZtjK7uJ2NQOQeHN6oTJyKyMkvwJC4eJ6RHUor8r1m
 +nmiGMR1
 qQT3OQi65oCKSz6mSDcH9XeJAEC0/c8x9dW4Lgwy7WzMEcg5N2tRa0mJreSbJDS8u5Js3v2AleVtvjs46HJZ1A3IJcIJZjHQlBXPuaTwYF8CRg8Y9m+MhqHE1mGTUrZPKd7sxHjcbaG8AABxRihMCVqUXVo5aLe5a25jnCiCHmeVvV52Q7sMmEO2x5S2DPVbxkNbXfNS8wjaIk0E9S1y1RFoctRc3Rm8K0CMv/Ew8EcHjmcrQC+1cijJA9zIb1H+wldM5cvdspj1dUy2DAtMIL7EJrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 12:12:12PM +0800, Miaohe Lin wrote:
> >  		folio_set_has_hwpoisoned(folio);
> > -		if (try_to_split_thp_page(p, false) < 0) {
> > +		/*
> > +		 * If the folio cannot be split to order-0, kill the process,
> > +		 * but split the folio anyway to minimize the amount of unusable
> > +		 * pages.
> > +		 */
> > +		if (try_to_split_thp_page(p, new_order, false) || new_order) {
> > +			/* get folio again in case the original one is split */
> > +			folio = page_folio(p);
> 
> If original folio A is split and the after-split new folio is B (A != B), will the
> refcnt of folio A held above be missing? I.e. get_hwpoison_page() held the extra refcnt
> of folio A, but we put the refcnt of folio B below. Is this a problem or am I miss
> something?

That's how split works.

Zi Yan, the kernel-doc for folio_split() could use some attention.
First, it's not kernel-doc; the comment opens with /* instead of /**.
Second, it says:

 * After split, folio is left locked for caller.

which isn't actually true, right?  The folio which contains
@split_at will be locked.  Also, it will contain the additional
reference which was taken on @folio by the caller.

