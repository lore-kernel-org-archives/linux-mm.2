Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63AAC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378416B008C; Mon, 24 Aug 2026 16:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3011E6B0092; Mon, 24 Aug 2026 16:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0E86B0095; Mon, 24 Aug 2026 16:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC9FD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:47:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B777A024A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:47:44 +0000 (UTC)
X-FDA: 85137349248.01.58EB29E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81754180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:47:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r9LfvOkj;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787604462;
	b=vmnVLCofLhUlqBJfKrRaM39GXj2KABGYIamrUHBZbPhjgXEQ/Xm81qTVCdrGoH/t+hawH9
	Ra3JixvwL8S3cFN4NY1W8mIqnwzik2qdilxcepyiPOAOCVwrQy91qlTYwsdlKDoIQ6AmZf
	1/siFFgQ32hPKgbhwfUJQ9DbA4BV0tw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r9LfvOkj;
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787604462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niEZYxfNIOD72gAedVquSAPl0GL96aOUAIsjWVWnyrs=;
	b=tTDcuqMeCDwdy42JjVgk3LkAKHTAcuKBUKCpRBCHJtVl/yffFhQUQFYsxwj6n8Q9VHNHNz
	8T872g0DlYKCRPgvapY3KdXu9JGRcuuRyPBjx6b5QhlXJtY1B1SceNdQGaZqoZE5gOa2B4
	A+qaXuE4aBSKkGzQtwebvym5m5QGIMw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=niEZYxfNIOD72gAedVquSAPl0GL96aOUAIsjWVWnyrs=; b=r9LfvOkjge2amjsBvyE5gj6qMI
	uYvVlQ3b0KYGngAv8XESPmmtwmX5YL31/ZZL/aCv3YA8HiM47NGP857BeCRMrrjzps/Ne9d2cn52v
	zqL2zGvjLLk1nv9syOdx3pvPSZ8lB4ZZOVBgqTtBiLjoK7MD80xjfIWR87mDrmvJgbQIzO6B2iuYH
	wqfSCFzLZJjECzSnGHLMWVk/RyHGkAgVmz+igPSrxnkQPu9UxG3bW9HhbNxyefBXIscvW+/Ut9PSd
	iZrPpiftS7pWBxDvgsL/MprJcvS05WbioAv/k/Wf8gVfSs67WWjwBEeQoBx+YaSMwlZC9Q0pIrjfj
	dHmqFNDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wybZv-00000007nCw-0Kvv;
	Mon, 24 Aug 2026 20:47:35 +0000
Date: Mon, 24 Aug 2026 21:47:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org,
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
Message-ID: <aoyt5pL7mXYwSqsG@casper.infradead.org>
References: <20260820193343.3852967-1-willy@infradead.org>
 <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
 <aoxHOSC9kTPbKeNq@casper.infradead.org>
 <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
 <aoyKxvdQdeJQfPHj@casper.infradead.org>
 <CAJfpegtgenUaudDcvecJuV2_WkkVw=gdcB0Eqg=UFKPMZP1uKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtgenUaudDcvecJuV2_WkkVw=gdcB0Eqg=UFKPMZP1uKQ@mail.gmail.com>
X-Rspamd-Queue-Id: 81754180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fsznt9eidq16taoystp1woid5mgmqicg
X-HE-Tag: 1787604462-369695
X-HE-Meta: U2FsdGVkX1/Mp0fY9sI1HN2OTiMJiVISlL0/6/cK0h43Y2sZ+8k8lyEk7/zxQpDJowbM0CnFDysBl68OEHJaRMCakIT1PegxxXPrlkRgIFByk6vp+Df2svg9AdGcNaRAxezwmnrb207uBgB6xrsVaG/kQDgLZS+3H8wLP72uOd1QxM6//KxtZmmgwzzlfnYcBAg4gdUHYtbpX4sC1EpPgFazT18216GwTX3Sggp2ZaREZJ4RpdyEdlpHVGmQNuUjjG+eSWhMuJLSOBmXp+UbvdWWbcppvi1xCGaZI9nLwKRqzUmSKUcGPjxM5dq4rFyYtdYYepFaCkgTrhkzYuwmjMlloIVJ5zVhDYk3WQa4c2JAVFTvHgwFNrT912HrNFvt6MvOR+l9/uk7kL9ZhzREBI568OYETfC+i5FOUAwhJbLYIVkS31TtHz5zNqzrhPvEesMBLLvC1kJiiBjM7p4Bd3ZAq7E6dRFVtWDoiQdKW23i9ypVdhhi5RhUEwzbQTuVWdAYFXZ9bwk4HMmMANrSr1BHTA24jEFQoz5gCnoCMTjuTZn1esyzC2tp7kOaeF0IBldJvX8/FzwFlAY4nRe0XCR33pji0qyhqVoRwsrgNlY8/tU6+VMXDG8isHXyRkZEzNcIe95Q0rnisTMlHGv4tXvjQ2h6r9i623S1K+yhteEHT2p2gjv0NCA9gEs2h9IFLMYrpImWzBpctg0sNXZxoelAfU5woYNu3lAIM21bejH6J5vlSFM8ljek5NwJJZDKqb/jMEShlVS3AcQ35z9YJm81HxVhBRtgk5K8AynzuE4Mj8g+Glba4y+5Qfav4739DiWvtBorIIcSO/AOdUbAsUF6TZcwhq5i/X5yPMiIvuttbccq+jOjh0YMOngKcHDuaJbPyQ+98dLy0bVMzKvBy4LlkrQQXQ3c3P17JqLmY52OIrQWPi8uj94XMDNr9d7fDZx8Fd+ues6VoU4ARyW
 WH5Rq9VF
 xN3oWmgJKliKw8hGXcKzMwRSnt4+84JV3MfH+KMeZiz2i4tdBEeZR/04n7CWyeP+oG7cnBjI8QmR1tibm48bNhw5lbTVl3UhVIkUch/Ljer3HDbhKbOdWHi52D7G4GIklMG3o7Pdu2YvigD1P3WcdUm2SIBIbCG8HubVraDKlD/qUH1KOASBRkavtvY5/tVUPE1JQO3c6SCwVzdetGJss6PtsJy7v41r3adwkNlGEKVArvjvgBUFJPGmH45hRugm7gQZw3bsMDrBAh1do1BDy1VaxVIytgBqZqmqFJ6o1B5EMK4h6D19rJjRthX+I+EBh/YDhd/URySD53UiI+xFoxNCQomqjYx8WAuZ+ETs40uEf6yU2QXAcBSUjU3yXztyJh2Yz7jFgXyj6rH7vI6SsC6FTZitWWpnFdNOJqVGHOPJ8p+0B6VynrS4Ws8pN1RJabSBqU17q/fHGWOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 09:33:03PM +0200, Miklos Szeredi wrote:
> On Mon, 24 Aug 2026 at 20:17, Matthew Wilcox <willy@infradead.org> wrote:
> 
> > Before:
> >
> > fuse_open()
> >         invalidate_inode_pages2()
> >                 folio_lock()
> >                 folio_unmap_invalidate()
> >                         folio_launder()
> >                 folio_unlock()
> >
> > After:
> >
> > fuse_open()
> >         filemap_invalidate_pages()
> >                 filemap_write_and_wait_range()
> >                 invalidate_inode_pages2_range()
> >                         folio_lock()
> >                         folio_unmap_invalidate()
> >                                 folio_test_dirty()
> >                         folio_unlock()
> >
> > so what's the serialisation that the filesystem can perform in the first
> > case that it can't perform in the second case?
> 
> In the second case filemap_write_and_wait_range() won't write protect
> or unmap the page, so it may become dirty after the writeback.

But that can also happen in the first case.  page_mkwrite() can be called
immediately after the folio is unlocked, for example.  Or the folio can
be evicted and replaced with a different folio which is then dirtied.

I've widened the race window, no doubt.  But it was always there.
If you want to prevent something like that from happening, you need
to be holding the invalidate_lock across the call to
filemap_invalidate_folio() and whatever other thing you're doing that
needs those pages clean.

> That can't happen in the first case, since the page is written and
> unmapped while under page lock.
> 
> > or alternatively, what's the serialisation that would be useful by
> > adding a lock/unlock of the invalidate_lock inside
> > filemap_invalidate_pages()?
> 
> Nothing.
> 
> What would prevent this if we'd have writeback + unmap + writeback.

We could do that -- but it won't solve the problem because the pages
could still be redirtied after the second writeback.

