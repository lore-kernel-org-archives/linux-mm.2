Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2BBE98FB5
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 06:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799AB6B0005; Thu,  9 Apr 2026 02:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A646B0088; Thu,  9 Apr 2026 02:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660176B008A; Thu,  9 Apr 2026 02:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF156B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:06:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDF548B788
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:06:54 +0000 (UTC)
X-FDA: 84637983948.04.0FAE9D0
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6454E180008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:06:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NoWQsXZR;
	spf=none (imf06.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775714813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MoIk3QXCJ15PUs08yPqRQRJkWDOpoLHAsaU9dEoaDdI=;
	b=Bx79cUOBPkooi13OEMQkQxYq9uSgCXp6SehGtkvd2P706EisgGSjHx48idvU/mIEv4kUC0
	PNFyUW3ugJ8+RnvKu+h9LMPHFpT68cksO8r1LtdjKEYFhK/db7BhLbe2EeOYAqAO6/h4c0
	F2taRJn0znz9rIlQS5vP+zOUKMP9o5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775714813; a=rsa-sha256;
	cv=none;
	b=DYRHuMBJ26XFYNW9aEGPWUEd0wUNZeCaHB0M6ibJG6YfkbThYO+KKusPet2eiQev92xqep
	CjCyAyGFWFUoItvYQyiJL45H8V6ctqYCIHEipFyzwYJJaUxpgvvR/d/XeJXG0E8dmuTRNe
	1gqvMcXzpJ9XmITcA+E9MnLqXEMfkOU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=NoWQsXZR;
	spf=none (imf06.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MoIk3QXCJ15PUs08yPqRQRJkWDOpoLHAsaU9dEoaDdI=; b=NoWQsXZRjYZWDfbKjd8x8lDS7q
	hqv81mkMVT5Nerz8ZCUOl54FlxVECej5vgAk2MjPAdNjTMin66BXINo6pKCjnKka00/CklqOr1mYb
	lKcHzntcxC6JQ25i8Dm/OLF1UgvSIw+0W2xdgeFg50wC42U8LAk2f6do6HXEFDJcASStIXjfH85Ql
	3jcHuApM1LHFVYzLrcNDBbwMi5mogSDHre1ajepfUEBlPIoJ6iyfwNvHg8J+PLxSI+lM2UExI0XTS
	eWAHEQe+vfgThTrcQCKYrrtWXGgbWh+uyvEQ+r3HKv5FZrqQQY8Il/oA099ANIZ2LhChbsp4HuuRW
	bDWKjZfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAiXR-00000009k4Z-2Duk;
	Thu, 09 Apr 2026 06:06:49 +0000
Date: Wed, 8 Apr 2026 23:06:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: improve write performance with RWF_DONTCACHE
Message-ID: <addB-eRg5cXzZhHG@infradead.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <c2351220336d0ad99396a331bad34c6177bf354e.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2351220336d0ad99396a331bad34c6177bf354e.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: c96uspq5e3mtbuq4c8zs65qwsqg4jgxb
X-Rspamd-Queue-Id: 6454E180008
X-Rspam-User: 
X-HE-Tag: 1775714813-132096
X-HE-Meta: U2FsdGVkX1/uFz0jaUWqli1jPN+TYhsXOSouci4CwkW5XyU4KDV3uw6b7g20uYAP3o2X2/XxLIr7oX8JBsoqdwyGvMrnOIc6Bd6uQDqJ316ifU8q9KJ/X5bd1RRS/dMW+XjBsTc48nobfxXnxJ5F8ESH3NrfGNdol8z16WvuVpj/wkmjHRPhGiDPqgWyiLz6X5kvUN+JVBbEGsQFycp6orwxwoJZQTX/AqBs3Qk4p+3++VvonsgkMVd8BFbB/N/csNFis+0KqlHIOWsndCILF34QF0AampfFitSXC5xAWuEPK2xtfh4bMm9v8X3OqnaTxrvKRH+Pa8QG+AkVUq3CPJ8BZ6/is8TWhvt7iUlbR9Ta1tqnXcrhm+7RUT+hnUukT7lSFfAcfIwPWfWwugc3lVpg1rguVHx7MiZyHx1fjPDnoYQ9ZgCmBs/JlS7VYQdFW5yzVgQhrGGFluw++aHTow1+PI3PZgAzv2FpmCAj2UdLYGJMMXb7GorjewsHLZMGgJw/z0CXwjECn4cFdoYop6ebvPJYsilHe/3moawo6zT6i0k/1Kus0HHJjlhvYwHV2JZhHV1iJV6jxba5ftnamb1YxfcGaXpsh3F/6zAUjZMe8A2cn/p3IlWWiMbtlE5I3ivjDaQOrLSjZW6p4nUZJyQDmDm0IdKZ2GTmvlKtVbGOAUcUqOCGGRfYftD4qe0z+qw4YxKrwY575K9iNq1TzNCgZFsi+2Kd7I2j+GM9yI+PGGJSNT79U12grrZ4hJmRcf75KTYbHcXmdOjMNIJyv5mW1c+YNnxTcCZz8QOrlPZhKsTodiXPX9MQNhv6oAXH9INbnNjsGvg6H1e60GNAWa41dSfjm8TSx2tA7TwN9wA/dB/lXv2fCF2BCuOnvbLmsQlSF2PRkzoQIV573nFL+aVpNrbGt/IfxBh9a0P5tUioGgVZ0zg4zcoSiDPmfLGPLlxQQWxaQkC7+M+jERP
 qUYqYGJm
 zwAJ2EFPDUfM6hnLXEaagzCZcU4JTHjFQpt0nVg/8+THCScWihR52VJ7x0UEjx3fodiCC7/mt8M1t1lNYanxQHmPzdDw9gr7JpNQ4IXJazvcFxIm2juux/gxYLXjuSTi7DABDeYfVfN92I4tGITUJSsu/JsDRLXgBvgsX/VTknsG3LdoLiMzRjuN/Ven8lBcMdbrL+9C2FMDGC/gCJ2za4m/c6J4at3pCpPjugqlwPbfDjOQiYhpmFGhldyjofr70hsmz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 02:45:32PM -0400, Jeff Layton wrote:
> > Assuming that looks OK, I'll probably send a v3. Original cover letter
> > from v1 follows:
> > 
> 
> Actually, that version regressed performance in a couple of cases.
> I think v2 is probably the best approach, on balance.

Limiting writeback to a specific inode has many downsides as I explained
before, so this is not surprising.

> Maybe we can get this into -next so that it can make v7.2?

If you want to target 7.2 we're not in any rush.  If you were trying to
say 7.1 we're way to close too the merge window.  We also haven't
heard from Jens at all, whom I'd really like to look over this.


