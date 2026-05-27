Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4670DCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 13:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B316B00B9; Wed, 27 May 2026 09:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B7A6B00BA; Wed, 27 May 2026 09:23:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5508C6B00BB; Wed, 27 May 2026 09:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44AF66B00B9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:23:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B873C161A02
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:23:51 +0000 (UTC)
X-FDA: 84813267462.17.80C3F21
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 833D21C000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:23:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JsSjYe+F;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779888230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZB3jLeDuyVXGOta57KrwjfIcilXpPZhg+DcknzsLGU=;
	b=yfdoy+JCIRUZWkPkm+j+oqMWWDHGyW6h1/LO/RMT/9By0VDQHPYfC+qrHfath5LVs2FfbD
	s4Q6TH/dwgR6QJHIY8/cmL69wiE9pDWjm+cmA8HHTiwzDyDniIte1TmySe0kl0eU0oo1BG
	kTHjzlCYtr57G2P9Zkh8NyZE1TTdXns=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JsSjYe+F;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779888230; a=rsa-sha256;
	cv=none;
	b=I3bcH9siZHy1gtfNWJeMzIf0y20ZZ966XywHUqHQokhbCo+ZieH7VSccDkHTuJjBqjOUG9
	TRwY5Xt26n3ISH9OLe9o2sIVujpnzZeUU5fMwfoQpTUl3/PFWzzTYFrqyuitURqhmnQL/E
	dztJDL0uCiASjYJQrEpxPImgZw5v2Kw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/ZB3jLeDuyVXGOta57KrwjfIcilXpPZhg+DcknzsLGU=; b=JsSjYe+FKilmfc4e0GANX0IaDV
	duXqcHYHtaDGAcpe1DKPgPqDOZbE+oDMS8c191PnezqEiKTuAl+Z9cdodL2/anK2W5wxP4BFIOc7r
	U1tuX5lppW3v64EwMa4T3JBvS5FxLpkesMYQGVYlsVFpzxBTDoc1MlRCfTYX/KWy7v6OoyXfKQFas
	WyJsi1J4Z9u3n58uHy7iCCfC21aOcrzvGtysPyqwNrUsKJzgF0ddZmyscOAAp8h/pLTkZPHIPw1AF
	dEXQkgM8Vd7IKhFVDnL7oJ1cRbOCM74tKbKZIZ8xgbJ+vM5EkWa75bNZ11teqv8Ep7Q7bIPNIY5I+
	+5vQOUxg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSEEZ-00000002aQd-2xdg;
	Wed, 27 May 2026 13:23:43 +0000
Date: Wed, 27 May 2026 14:23:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Message-ID: <ahbwX_AdOrtCXS6-@casper.infradead.org>
References: <20260527071816.GA17632@lst.de>
 <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org>
 <20260527121920.GB6079@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527121920.GB6079@lst.de>
X-Stat-Signature: dmmbrgs5ki6h7fbybi9f5yfbnu1zy9az
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 833D21C000A
X-HE-Tag: 1779888229-300503
X-HE-Meta: U2FsdGVkX19PZlcyfXkYKqfYkopp9Lu/yPsODFWm5odcJKb922IPROOLbn+qaBpD1UHItiEoaH195bHjcxnUW23Vv72/EzJf70OmHrgkKAlnua040uKxxbSw38cKnhz5f3EsM/1AnMScyGOIhQyEvSalzrwjetJR4zMHvfsp1GRz8/7uGxxHerHu72mp0gQrKBXBTq+ruQwu7k9pvhT4Stv9qiHArC5qgWxsorOtBC3isLu3mHUn2zEYI9P+AJgQwHEZvwPXo8G2ZJ5WTPGc8qwjtj39nefRiTfaPYMwaPwXWtrau5MQhUqv9H8mYVdY1JsiMdxqKuWCc+FIhu4N6lpHGNuS9Z4ACWI05Mq4BwuLBM79j4rcMBmCXQ9jw9HLt1k1WOKyraS1NEnZ/lEzo1fdeSBRIa87lgyxF8ZmbmFS/lvAhO6irjZ9+N6rLZBqVh5YzSxCZbxY9YMFvDO58gfwF9pao0znhUEplpC4xuIzqCC4vhp1HEVLnVGTcEIJ2h8MBt5xYtOBmoDAa7qk0r7j2aRPBBlQ1SxPp7zMC9BpYOAOvNy49tlslAvWGyv0Kp7MsRpNk6wfeJOWeHwRZXzdxkOtoZmXciwkYlXLS1f2nSVhodnnK0XWw2NgNzLM+RYWmHTV2zWwzelBm1CALkEXjgkIafnBH6Ig9PhGwV8YbECIH653hmanSLy8rzPraYfUxUQJGDDctXAsm5Cr0tkL4Xxax06pNf9W2rDL0Fp3MUWgwFZAtbtRECcc/wtX71cleTrgSDjMzStF7PQJ2e4s4aSu2ji08d4u4WxvBUX+vkGMzcOPAcA1PIWGoN/Yr8Mhdf6bE0g1v0JuWP8dqS2NIJyxgiOS4ALW/jMx66mivMUUX57PRI/tJgr7F1rRkPBxhuK7pHpoaIcrzw6RiaF7+FYhXLZErogDf6N5npy/oFwqrNipmk8DUd18ruFt2T6T26QiFtCZZ0O98Wi
 4PSiAK4v
 HE24GoaZK4p9Mb8U3U0Gkwd6KoBbYLqSnSqbraUrOOwBBysM4XGilMn8GZDP8xEszT4jF0QhS/Nbqx3v3h/vbpYRhJLXQ2QiQ0gdj0a4wn5m29aA00Mib5Jt7jWue9ATMhy+llzvFFNieLOWnbVnkq8DH7q7CZQmqw02hbJCrr2PFDATpz61/akhmVTqr2xgnk3CUhjyhoCPXeHtj9Fjh7jbDBLffMCnepRJFOnSQW/y6tLmRN5sBsQl809gGpiS7AinBkMVjX9lHQiiWUM767ucUgPjm9PmPcrpYyaB+YraV+pFspyo1kMrNqK0anW6SU8+/Vh+d3+74qP9qu9yEluFBUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 02:19:20PM +0200, Christoph Hellwig wrote:
> > > There is one single user (svc_fill_pages in sunrpc) that relies on it.
> > > For everyone else it creates extra burden and is very error prone
> > > (speaking from experience).
> > 
> > Sounds good to me. Will sunrpc be easy to convert, or should it be another
> > flag to opt-in to the current behavior, that it would use?
> 
> I've added Chuck to the Cc list, but from memory sunrpc actually does
> make use of this feature and he objected to previous attempts to
> change it.  So a first step would be to have a lower-level helper
> that works as-is and a wrapper that zeroes the array, even if that
> doesn't feel as efficient as it could be.

I think the problem is that sunrpc uses the pages as a queue instead of
a stack.  If it consumed pages from the end instead of the beginning,
it could just refill the entire tail of the array.

