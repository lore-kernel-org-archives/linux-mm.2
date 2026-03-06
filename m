Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15160FCC056
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4430A6B008A; Fri,  6 Mar 2026 13:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1646B008C; Fri,  6 Mar 2026 13:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3796B0092; Fri,  6 Mar 2026 13:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5EF6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:41:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B068B59FFB
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:41:15 +0000 (UTC)
X-FDA: 84516505710.17.0531B81
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 569A5C0002
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:41:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Wg/i8/QW";
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772822474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5um0Un0dBqpJi9mEsTrBTXwrxc0DE4YjAakbTEyXQ=;
	b=DyiXVTpj6ZM6Jz8coZEEkC7DWWvxK5eouvVJVon84YPLEzzVgKQhA9PrEJW59L6etWLjR3
	g4kr42Xv4qHf9+ESX7M3B6mM/G+9F7m9ybbhhQvPbBFzEI4LmePqFOdt1pqd3zr+xk9U7g
	3Wy0vDyFoztVNMUq+Bwdal1FYJETQRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772822474; a=rsa-sha256;
	cv=none;
	b=MSa8WXbguTjBl6q1wWLyfnSpc0XT/9J+XA+c8C7JOPoUWGg52+xV7NBgjKsk15k3Ytkcjj
	VQ/PXT3cEvpKNf1WPq+MNq1nz8etIb75XAzxB6Xh1Mf7shFq66MRCUh3rFIoE/2pXPWBQJ
	WelNPEHhqm7ha/5Ea54uPEuWnLoI9Sk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Wg/i8/QW";
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VM5um0Un0dBqpJi9mEsTrBTXwrxc0DE4YjAakbTEyXQ=; b=Wg/i8/QWd4Ak3VOJCLKU4dOiuQ
	xhhympkoBIIrndvU9oNWzizRvbkRQ3jezMSezju9eBLweSBuzsBZdBVnJOYqnOrHMvr5SmlnVP7Rg
	Ng7hBgG47iGveYVWERXxjBdpvNRmq5AUyqBbP+7Nd6VQdOMNY/jUo+w/KgoQdH47g2HRf2TYFAWfw
	CCM7PTZXAotdCUsSZQMpGSkloS/Q2nDnr0/Aq9/YgBeRNfhWNv8pPcEzDkNj6deFHagI4erqIHgJp
	eteoq5s9zoTi8qpjjo0mqYvWpKAt2FdK+b+ImQ30AyTXD4aDaJV9zgu+yWXF0XFKvpq91UIqEg4U3
	Eoj2sqbg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vya6m-0000000H9Eb-2cL2;
	Fri, 06 Mar 2026 18:41:08 +0000
Date: Fri, 6 Mar 2026 18:41:08 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Chris J Arges <carges@cloudflare.com>, akpm@linux-foundation.org,
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aasfxLYRWzNodAYO@casper.infradead.org>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aasddOvIfcMYp3sk@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aasddOvIfcMYp3sk@thinkstation>
X-Rspam-User: 
X-Stat-Signature: d6iw4t6ei1ratxokqychzw4kxf4afw1s
X-Rspamd-Queue-Id: 569A5C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772822473-662764
X-HE-Meta: U2FsdGVkX1+GId4awX6+8LfyrPMGfCNYRWX0WAMHKuGpOVZQfZ+CW4qz7E4qSFEgvwrbi3xUQ2Pnf7B5RgLgnZCoMwcKimhw+4iha2IQ3ckpcndR4nFgGNHx7Ba9qrhHgbQ8mVBy5LohpQfMan0rJ9LWba+hRxNGi241EzBo538IKApRmmfsHAdrcdP5JS1sYS3yY+x+GDV3iONeyZMIvNMRrVXuPMCg5r+J3RKQ9z7joxDw1wdPwFWCWYn8dZmC1z+SqleycnNshl4KoQ66OP5fvQ0tLyCg9rhkeCbus2+zSRq5nBnUbIVLtBWg4XLPwphV27lcawfMZu4nGAt14x3n316skSw0PedtZQIWtj9s/euHcJuG0guRIgzRuttwj07NlACyd7zgHzkqUB/1EuxbSjO5WjVVZgJOw/bFmDljNHIv0L6KhMqaKwfJsZ7ZY/DR/cEd6kauP3j3HQGUfPFQONfSaoJ2o2/E0JHHy3mId26dqQShHVvrMU4DkNNH0dccP5vRQTu2oTUV09TdEIYkmT7oKtBPIHASayc33dP/drdfMLsCMzL58HP15/WNTN9wc78yztQHjFPo8i+YuhlP+irSBs4VJDuCFIk6p51rfQ101et1WLIupkh+uSg5uc8tw/tl+UM+YcUGdB1iIq8u6k5bqXWzrFsKmmZ+osVPOQRW7gBi2/YbkiGQNXvT6T2+OXmXx7WxcLkKciYF9XHMMaUCUq8XlFuHzcomhSLhtPXk6oUpScxZ0FNikowpWfJH8IhQOuuFF3uKKDZwrf3KM02ciGenlEjbA4jX7mf3xjGDd8Kdt/2q29Ra0y4lJZvE4BMltl7dOk6/Nkha8+uNXCqu6N8BNxZY64VDRx1xlz2icVmBdW9IVj9CoN0cjE+NkHEZBGuItwVv97q9/f+pwC3vfthF5vmrVWB4HaUZatmzQmprHMbhFMlAh8JGDP9M10WdfcbhQOuFTHa
 2JSB9UtH
 Kea31Y6+xXxWc4HgYLZ/oAnT0BxwjJUFxZrz6OIHTv9dSvwYyYlHYzfRRwxeRcm4/eH0b1VhVVeYnZwSJP3FMhqPZPLXE4s8uZ9xcT09pjlMVfXV+8JSpPBECigSaMeB5uKViGoQlVn82xR1tbpyiLzjBhuD7E4mnBiZBN/PseEaXHM640AGrSB0v8hlYlQN3bG9lGcXOYXaP3Rm7kxVuiUR8RU1h8vLuo3QmVrMMJRu2spXznz9eiFiJeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 06:36:30PM +0000, Kiryl Shutsemau wrote:
> The proposed change doesn't fix anything, but hides the problem.
> It would be better to downgrade the VM_BUG_ON_FOLIO() to a warning +
> retry.

The trouble is that a retry only happens to work in ... whatever scenario
this is.  If there's a persistent corruption of the radix tree, a retry
might be an infinite loop which isn't terribly helpful.

