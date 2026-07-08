Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1195C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C323D6B009F; Wed,  8 Jul 2026 03:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09506B00A1; Wed,  8 Jul 2026 03:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B475F6B00A2; Wed,  8 Jul 2026 03:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4F66B009F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:49:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2586C1C3CFB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:49:02 +0000 (UTC)
X-FDA: 84964833324.08.11CB51C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4FF60180004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:48:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Yf34rmEA;
	spf=none (imf06.hostedemail.com: domain of BATV+3086788e15153571dc5e+8354+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3086788e15153571dc5e+8354+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783496940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GKqWLEPMpSojJNy8dWRNhk5xCmhjbzGdFpbVnUJaBw=;
	b=w5WDRYy0beS69U88YyX/nclnig7/xtMbCGl/evwaVbDl5LzeN0yPVnuSXi5Y1d5gNEOsXt
	an8Ys7UoSpkG+pJwVWia7Z6vtERH2Bp+P07KjtqzAXsafZ35gEhdSRpY1NMEa3YXOWWIzu
	oNnDNPhzMFTRWZKMHtaWdPJWnS72Sno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783496940;
	b=DG9KPZhjomrFkL9+jXiq4VWEE8LyTRknZ6N7NmRxGso4IKDB8nill6x+yToJGJe2gG5m2P
	FLxIx8Xfq7D8+q+xmBjtm6qq9SGfcrNaSPcYj9LjPKNIP7Op5kevTMU4xeAg0KmLna+s7V
	pvj0mERPX7mE1ee/ZtnBqWrvFw5HdF8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Yf34rmEA;
	spf=none (imf06.hostedemail.com: domain of BATV+3086788e15153571dc5e+8354+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3086788e15153571dc5e+8354+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1GKqWLEPMpSojJNy8dWRNhk5xCmhjbzGdFpbVnUJaBw=; b=Yf34rmEAxcLNuhnC7Kq8y4edIn
	yHLw/ZngPfYN4Ht4snU+mOMkMNi/O+LHMInNR9DR+2vJR7VXHFoixo4uBSKJziJQeVDiqI/V+11Yg
	IFd68c1E3lx9cSVDK9tTEXqswI+f+n/QplUk1S0geaRP1VEq5yiPEhkapAerHAxA2VkxT2SeJ72KU
	WHzQ/+JskZTDMwYxI7N2j8N1EbWgXo1uGBe+tgI7ktqUEBtV6XkIn+UQkA7S6ZReyWLGxQCJnFDEA
	MTly9iUpoiyS95CyXfl2WbcQ+qoOXfUQ/9w9W33kJEHw8gQZaVK07G8PlP6x02jRmr9lMDeFFLGH8
	cO8aLwFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whN1c-0000000GXRD-1kHi;
	Wed, 08 Jul 2026 07:48:56 +0000
Date: Wed, 8 Jul 2026 00:48:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ak4A6IEmWNi27I2d@infradead.org>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
 <aj4iiD5C_yyLeb3U@infradead.org>
 <akevQfFVteCOD6LM@google.com>
 <akfAgy52s_Gch2KG@infradead.org>
 <akzsO_vmYX_7Umjd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzsO_vmYX_7Umjd@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FF60180004
X-Stat-Signature: em6abqxch5jwq5jgw3rd67ih6a3kmk5o
X-HE-Tag: 1783496939-351278
X-HE-Meta: U2FsdGVkX19tHEb6mmMijDvDpLCJlPrqPHn+3xNPk5l/IUwwO+Iv5OlSFBCqgrmdS+iXfTgVorrixn20kirQa6acchvWhO1XTVhhfL1hI3GBJw0cqt717SnbSfyy6Snp6NfVB36TtUA+Cyik805WXjhTh9EPqRgUUQUcCTtag76nMjzBNrgpzFHgUNeZafJG1aW1yGc8gylZrHya7H3ODOcMRp0s9u/vx96DkTzitWRGOi8i3gZaxXwUqYO+rGKRwwkrEwmxJ+a2PkzkE7cNFKjKf5iV5ZVNmMTRAO1o3rmx1UY+EoW71QaYhlhWZyeI3qiIG9q/Whgu503cjhOWQmlSDcSR6YHzbqEU15mQWyDtE2b2pMw7ZIgohtJ0mT/ZstOfAFwVY/AC8ZXjessUMp2RKXre9rWGhCOGweA6b4DxYAPXSyKgmoz46jz4u+IZumrSdastQjinL0icTHn99nk8RFKasr0lz/ox/m5Ru/YkrZ0xKGWGHwovs6dKU6nEz8XckTNvz3v0sJMLjVDoFAefkc1fZSrCIYN0s4wNk0Poas9ZvYODZ+xM7s88aUBe/e8vwOEXb+UjS7NHsccYLEBtEljcE+IEgfu8SQsBxFHf+vq8UInnyPWMQUBQMv6PckoPDMFDxey5IO51FEC77+6TTWMJdMH3p1hVgCtJtwulPyHF5mV1yCTrw/4jZArG3NgkIyhBvk0aqGXWbTuHzyLqjfmLWxFvm9sZTx8bBT9FLWN6Nx+RTQ0QKVgLmLfSqQ2tzAoxxLH8iBRUihdbTXV7p9iZhDpma9+821X5jrVu7WNBjWx01qrelJxjdSOJTvoYZaS62SgGwrNY2UCAj6DLDbDdYGQYuNHLAsha8wh9zn6VIOEzwYE11q42kiJUqmGvKO9jovslmYAl0oS+6SQ2bw1iXxEvXuRmDgiSGuox8uiq+DU+w+OWfH6epiDBEbXW1Uv7EX5nwJkzGFl
 pw1bfP+e
 U/I+fvjesWGtbGUESNO4akFV7+ENJLjsRvMAw8KFyxsYxvePFR4P9/YZm61HOVLQgVhlJesSrdT5oDhhcwaUQjvGUmh1uUEvJxoYqwqXgacY/crBpEZK36nsVcx2xH3NhiWukwOtgp69hK6SMmBQYnE4ifMAgizDW6TAYe3rQst78XYYVedh4QSSqe52wacmfzG1stgxUzdAHZ+V+966IG0qy/AsU2t9qIIU289UChy+8AFlJ4UEdkJU372CKZG4ncvE+468fqV/dpW2AuRzRPlJ5BCDNE/pTlUHyUJ0L28+9LvC9cXstF3pXUxogbl5ROAd/fhAPEini6C0k9E+1MQxABO9S6ANuByIuMFofJNY5KTVAxtK5rPwAhzU6qD4KAp4k+PJakM4Y3o4Fb+0QzPGcC3CDbjmS01aUDHIJN/uBtHgQW/3h9DdzJF6caZG3IS9lTmVpMJeIWj5q+SU84aJ5lpVUhkA7n78PrE8a0QmLEVwbBGMJPE1/1v5vgiqwZ24u/q0rr34Jt1FkXyE58IMp33sDU9zNScGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 12:08:27PM +0000, Pranjal Shrivastava wrote:
> Ack. I see! Thanks!
> 
> Regarding the page_folio impasse, how do you suggest we proceed? Should
> I expose and use get_contig_folio_len() from bvec? Or should I move the
> NFS helper into the iov_iter lib? (or both).

Sounds like the best way forward for now.

> Also, do you suggest sending the Folio move as a standalone patch if it
> is blocking the rest of the series or do we prefer keeping these in a
> single series?

Sorry if I'm thick, but I'm not sure what "folio" move means.  In doubt
if you think you can get a series merged quicker without a later part
I'd split it.

