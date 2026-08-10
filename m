Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09043C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F066B008A; Mon, 10 Aug 2026 13:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1D76B008C; Mon, 10 Aug 2026 13:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC11D6B0092; Mon, 10 Aug 2026 13:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD5C46B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:21:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FBE7801BE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:21:23 +0000 (UTC)
X-FDA: 85086026046.30.639DC11
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E39740006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:21:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="w4/MCNU5";
	spf=none (imf17.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786382480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cy7OYoW3PJUmnKukrwcZFQ3hLQc7isy+xcCx8NMp1l8=;
	b=XS1fR0gOiOfJ+//eUTVCEd3F3O5SDMNg0pNeo8QFnFY+I0s3mnvIwGihODnLo1D2RzRmnO
	frD9zxpGmPlN70vOWBYvQDgbw0YW+BEuAbCUzgn6GUOaRhKHbauXb1ebtkQYoRD4ntCrD7
	AmQGLMUGYTtkeD8LNVfJKGtzKmjsL/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786382480;
	b=qR0/pM62OUURZdhPY6rY2tFQF+3fVsCsAorhvLppuat6iXQCd7UDcJIltggvl/eTNOUwgP
	QexP9uJpr4ilOYwPleUhArMvX/ry5P8ITnOUIweNgVL7RZMAItnFTjB/+Cxv0JdUcvYl0W
	yqyRHa5xNY3P3Lhg6tgsKMQizVlUvoU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="w4/MCNU5";
	spf=none (imf17.hostedemail.com: domain of BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e92feb25c851dffaa619+8387+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cy7OYoW3PJUmnKukrwcZFQ3hLQc7isy+xcCx8NMp1l8=; b=w4/MCNU5K681S4PdttIQArlltd
	aplhwsp6XCU4p2gSmBzQF63vxrK4SGZ9xboYcrehjzg4Zr3lNxMHnAh0pJ0dg4kHYPhyd2NSBYLJD
	lZ8DB176sohHR4/o2j152C12lB5eVjKKA8KsNzmqLL2eOpSYJ36jGbd2dNJB9CE5puTWOt1qH+lc9
	YarURFLhH+UEkLQ/d1iU53sByUUn4us6p3VCMUzCh6/mtbn9U6LFvLJpg/+TJu9+BmsC04586zYRK
	WOakoINSy5YfcXOZ/OZP6tDomANg7HvVvbMmQNq0UDAaig+srKF/YjsKaSG2KN9JJbYYYdGZXa4XG
	JMbvD+IQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtTgZ-0000000CVLf-1MO6;
	Mon, 10 Aug 2026 17:21:15 +0000
Date: Mon, 10 Aug 2026 10:21:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <anoIiy0V-m-05yZc@infradead.org>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
 <20260810161404.GA1930@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810161404.GA1930@sol>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E39740006
X-Stat-Signature: sfpujemo4ietqdfe9iwoahuretp7uuwa
X-Rspam-User: 
X-HE-Tag: 1786382478-397021
X-HE-Meta: U2FsdGVkX1/qiG/7XGZdsOMxPJyk0+1CbbbDDS6nuEC2mWA9NuafBdpeFNkvCe4K2sPLMsEbrveyIqCwHfU/qZqtsarw4qqz6mOTd5X7gBC/dHC4A0h0z1i7VPD8FLQc/RwHM+XNeSTQ2dYVvVuNlX7620AWA0hNuUlBoUXWfG1faYN438ZFBGlfiEaiWVDMyNpSFKhiMWPjfCfT1p6yybKDlSK/AhbYbitjNv35ZYzAEkCjGNFbg7aF9UeQVFPKPcJm5Sj8o+bN1EDlMwSivR1F9CBAsUAWKFHfbwrIYCqpkBOuaGwiY06LrXzJ5M3dvdjlSwRTNEwReK4VZwRq9vvXj/kS2/1dwrMdYDdO8P191cCfoZp/BKkdnuiTyhnTNYkujblo6aasvq/8jL94MuSTXzUhfWEmjjZPk7FHnLi55o897lUDCfShLwi34w5UMRlxKKCQZr90Nhn7mKyso0tbnjVflMClPMYiOo7hwqqpUk+MaNi6gH5Xc3x3Z28BnIJtghcC5ULgzBM+/Y5i+qbYRgI/cKwrCX3cTQqekLrGN/nIDN0NXqR4KV7jk70jOjNxTYzDjMqy2edHyvSu0wh8DlMHn5t4ukkDEIep+TgbDHEIu7bgNBTExnzY+LRSEmtdJWOLCNXbmK4BkjLRMrMRWVxxohDSDP6PFmXiFkkxA1zKK5cdOtwdRyuLFHuAYbP/MOqGZqtIQD5WzOrKd0iGmx5Zjd13nGKbEYUFnEhixDC6dyeW/AQkJhV8eF5Qa7bqPqL341gs9at5PlLHRaPek+psgrrirVUL5lBNBPstexZNdk/0BwFVn5YckzyvRFwDAwtvvL+31MmIba/E9ltmzob9eUmMGizmLzKlUvCEcr5Xr0As6tDg7lle17VumQUcfZ3d5rz0NuRxtwVJCK+r0F36oxat1lGFcxKxVxVmD9dcH+1GYBdQmq/f8Yj6xWhlZVTn7D9Dj+FUu8b
 WWIdhW0q
 EHrzSAlXXxw8mpeV0mll7IJfhvKGTmooTyKsrwTXuHb/ncX7+12grvh8SWBV/phrUazUmvUpRmkmQP47v6Ox1+W30AE4+LTgktcBC7Id/K/JH7mTzpDEFuMOFQCNAyyCNjijMqhYFxE3u9WrkT1kTYNu0QTUk+vyIvdwOJSkG3BUV34r56a9MzBeYomT5V7cVDbBBFvHbcjZc1gDSPyY7sz1MPQhaAfzNz026gtK4cnpcu0R+K8wQfcf2hvwpPb2/Kv1n1f3qjADaCdp5JcYcy6/Ye3iUrP6iu+nniMYQAGSd9gu6MeW2KJcBpMUav32YRXOTpG5ayPIxSSeBZlweMrtM2d1wgXkSKrp4cUo9M/xShKUfVN3VvROdAX0Fl9fjHw80MJ9vEnfxWEgYcoKnm0CVqj07vhHZ7vWyP2ucXkIJrYprlE5SlsHs+KOAK28rkT+8jrrtVMOK8IaohabpGuUpbzsJizQohflKrlGrcwySxd/n5YW8zpmzj+97FXd/806gI/9j/vGUjMAMow0XXieE7z1Cuun9gcDiyY9KZivroXzs/yFh2bVbX5dZZRSMUyXVH9JutFSxXWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:14:04AM -0700, Eric Biggers wrote:
> On Mon, Aug 10, 2026 at 09:00:11AM -0700, Christoph Hellwig wrote:
> > On Thu, Aug 06, 2026 at 03:10:30PM -0700, Eric Biggers wrote:
> > > To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
> > > mempool_alloc_bulk() allocations.
> > 
> > It doesn't.  fallible mempool allocations are a concept that doesn't
> > make much sense.  Please just go straight to the backing page allocator
> > instead for callers that do not need the mempool guarantees.
> 
> It does make sense.  When alloc_pages_bulk() doesn't completely succeed,
> there still might be pages available in the mempool.

But they should not go to a caller that does not need the mempool.

> blk_crypto_alloc_enc_bio() should try to take them before falling back
> to scheduling the rescuer kworker.  The rescuer encounters scheduling
> overhead and is single-threaded, so it's slow and should be used only
> when absolutely necessary.

No, it should just try a regular non-bulk alloc_pages (and eventually
alloc_pages_bulk should do that fallback for the callers, but that's
a separate discussion).


