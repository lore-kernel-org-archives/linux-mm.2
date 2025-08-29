Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A55ACA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBC66B0029; Fri, 29 Aug 2025 18:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC476B002A; Fri, 29 Aug 2025 18:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE88D6B007B; Fri, 29 Aug 2025 18:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0DD6B0029
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:53:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4279485A47
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:53:09 +0000 (UTC)
X-FDA: 83831297298.20.98F0317
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6AF5620004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:53:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZmcI8gdS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756507987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP7ofGzhoXbkAcoP3nfJ37niPOsXFlBqhoPStdcV8Qs=;
	b=avlKi4Ihjlr2mAWh0WoHFKgs7bTydrXaiajMw368L6GeexIEv/Ipu5uVFLTtMpO6qJ38+y
	wzHQ7PQP3qcnyGH2Ov7i0jdIVQVeHO4+nlRgXjGx9UbjxSTD7Lq6Stqm8NMzAXghsso3+s
	GSi7ZUwL8rgs5t4mKr2LQNvXwJFTlpM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZmcI8gdS;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756507987; a=rsa-sha256;
	cv=none;
	b=rRBxKDrXzlwFeuSAQkq06cTSCG+/O8iod2EVBvJHwNOjAlZq6tjoR4CIYOVtY59zktwfBm
	FCTt44B7HmUtDEWEohZk+zLB/PARs/nO+RViaiVZNQz2tHagi/rMCEIu4r+NyWr7yRQI/K
	hzBpUtbYGlqrJEd6lIsl8IpMQf54PS0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EP7ofGzhoXbkAcoP3nfJ37niPOsXFlBqhoPStdcV8Qs=; b=ZmcI8gdSHOoauiSVuiQXSqIJaf
	gH7JWt8H2HoxZ8CRa+v3UAad450a171VjuUcuVy3itEjfP05JE5ESrlxw9nTFSnpNAv4RX/7Ij/Xh
	T0NiWtkayJMwk/WwSTJUb8KoUZ6xOVvq88tM4MsgjoU+B83hYm59cZmrPE9p78AFwuTMwrngAGm2d
	0L8GL8GuMTULr3yEAcnDmQdEnSKwSObyrksAsSR8fBDm7JGNkt2CBJuEKmO7cUMJ8b++te/kr+bOC
	/WdeJWzIeDr42ukTmYz3JNao4CsLi322yrXSI+hyZ+dbYHJtmH5aGGH93KOiXQSK86ZCQtczV/bq2
	gu+r03ow==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us7xv-00000001kdU-0wqu;
	Fri, 29 Aug 2025 22:53:03 +0000
Date: Fri, 29 Aug 2025 23:53:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH 05/22] mm: Constify compound_order() and page_size()
Message-ID: <aLIvT4HcHUSnwP2U@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-6-willy@infradead.org>
 <8A306C85-D97C-4665-A683-0AA69122AEF3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A306C85-D97C-4665-A683-0AA69122AEF3@nvidia.com>
X-Rspamd-Queue-Id: 6AF5620004
X-Rspam-User: 
X-Stat-Signature: 4gdxc9o99wn778ehss76azd6mmoq5741
X-Rspamd-Server: rspam09
X-HE-Tag: 1756507987-258319
X-HE-Meta: U2FsdGVkX19LhN7tJyYjuF9y800Fesy1W2DqWajmkIXpG9RT4Ec9q36eQghexqQiRaM6cJREzGzg8rjVKmQRQ9FrgHsVp6xpA1cu1/EI5f7ZOSSmZZ/ZcRPBNyN1w3D56fV7eZWCAG6cqqxfuXacNCsDJqCzi3IobtRrZ5XZjNCeQ2iQ0jz3bWIzU/cMewyVruigD291e1m8x+Jj/d9L8yngoyp9B6IN18kIlAiFAUlvfBK2FNFlaSyzPxzpaqZLl23LrBhEXrxZLJa6MKSDzFbnvolof1CCmqr3Rp1QD1RDP+khzm8pNLoP54mIeZGZuiD3ZFTNZBl3fGZ3/U3axDpTHEs+G6e5P3FX7aCr+bZxls003On4QvgjkqsitJ7X7sK/UGJLHn4UQxX9Ezi4oCNkBB4G6qytVoMjQhsM3Tqs6dUlk+HEbVGu8dssvOQzxww2hpWnjubAiZMk/rMpCVtCnmWaNdUwtuRU036BuKMN283rACA7eIAIMx6uo85IjyO4uj6jVZ2H1MNY7h46Mn//ttydsIVFyuedBmhiDKex/wOLqH1g/uWfKKT/yHIfy8+X0ELKj/GU2XrWkRUxtMOSCGqhr9A9JFbPOO/GNY7khRj1Pg5iPb06YB/mP1XM36Qb8WV6LtyHtH1NFvcVq4fFIp5UPWennKLWbd2JI5trP4KhZaTW7t1xvBdpRjl4JU5GxAo7KnsW50+xEoshHxpIBCVVX6LTocm4SL5umkvag2ftaVfPwl95HcUsbAkL8vuj5LSo+e/5QfpTFTK4LuYJ5DzVMO5t5QeYrxPHreyeiPHTgXAJaHh/OkbaYoanpoQD3QyKBhdSE1eZuIgKzEYEiZPkwoGDdhBycPP1Y6+X9rS0J2jUn9TfF+/c0qxOyHIj3PPKBQKzge5VGp9BH+65vRpx8tfa4ioHbKCYaXI1m9UlHlGI9IlcTLulSA47j1666YUYJY5VDaP2+D1
 aDKh7KfT
 2BP5f1WpOaMDXf2vWzjK7pTRmB56ezkzP3knLOAdzoXbCJylHRjwQkWmA3fnep8KWtCLzJEqvFNTTzKBxWelhKF72YKI35puyHu77BZuXRSkz7JdQDWZP8teCOHrt2W1xcTT6ilrKyWog627qNffyjjZMoQGeGWgnI2imv2OGFeHYK83z2hQZNbSRSX6ImNpObta64vRtetAFF7f4XpzU8N5QrcO2oKVGDthy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:42:43PM -0400, Zi Yan wrote:
> On 29 Aug 2025, at 11:47, Matthew Wilcox (Oracle) wrote:
> > -static inline unsigned int compound_order(struct page *page)
> > +static inline unsigned int compound_order(const struct page *page)
> >  {
> > -	struct folio *folio = (struct folio *)page;
> > +	const struct folio *folio = (struct folio *)page;
> 
> Why not
> const struct folio *folio = (const struct folio *)page;
> ?
> 
> page is already a const pointer.

It really doesn't matter; it's not going to affect code generation at
all.  We could cast it to void * or const void * instead.

