Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F666CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65816B02CD; Mon,  1 Jun 2026 04:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B7C6B02CF; Mon,  1 Jun 2026 04:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78D56B02D0; Mon,  1 Jun 2026 04:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A62C86B02CD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:37:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70DE91C1C72
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:33 +0000 (UTC)
X-FDA: 84830689986.30.D00EE7E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCA12140002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:37:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="pCo8u5/E";
	spf=none (imf09.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303051; a=rsa-sha256;
	cv=none;
	b=NA/ITuK8bd2QdL3oiTiHo/b+zcSNCqKucufuj0hqOYnUC1Qd/13WurWbLn+8g2qeyneDhP
	It3Is0VVB6Dx0eeB6ZVW15HvJ32bP0CVLYXaspiqza8BjcCZlwQCd86YRizD4FZTv4h/wb
	y6jO1Oep5OP1LDhBV6KFp2Zca1o6hP8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="pCo8u5/E";
	spf=none (imf09.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kbipd5my0kxdieuohQ54gw7V4ZjO4rD65DLmWgf5FoU=;
	b=5Cu0Ec9MbEHQcvd/UGdDwsdaKG1nFK2uJk0rQApj6qBOMOc7W1LnTO7Q5HhY+yqABe1vmn
	xx/YkQvYUEaV6UJ0lVTFIWR1RwY1qo/cBApYtEKfnLoIONS756S6W8g8Ow4MYhlhAMisz5
	I8DhJTjgpcyeEHCoc1l93V/9lzvZoTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kbipd5my0kxdieuohQ54gw7V4ZjO4rD65DLmWgf5FoU=; b=pCo8u5/EGo61wq7DLV4otnZqdD
	OMKAhmp+oGDMcYMT7Ta0Gra/svzVEhzB9h4Mlyr6qhbqnHyzJRuakcf9K2wnhh4Xs5svWnMG3nU39
	nEFEwBIbWdCzHAa6ZQkLfL8Z9u4Du4KKPYJSY8uDCe7irg541ag9s+9qsPiZklhNsBKlzzXNQKtv3
	i9m0sjGUjA1z4hn2Wy0EtQdYV8IChJPs05aiIkFxoYXU65kECrcx7M4vBe/jpoV/uSwO3BBjMcFtY
	Jr6zC9JTzuHWs9fNDLqK9lWXUH95ZY0YIoMRqh6Vyvg1M7o2fyRtr0zo5aAT5aGrduWeDV17HwtHc
	OF6Pvsiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wTy9F-0000000AN5J-1YMj;
	Mon, 01 Jun 2026 08:37:25 +0000
Date: Mon, 1 Jun 2026 01:37:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <ah1ExWQdq4yhnmqC@infradead.org>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
 <ahg55Ei8Fc3iRsnA@infradead.org>
 <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb59cca8-28b0-4231-a109-a6ae0ea12a03@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: CCA12140002
X-Rspamd-Server: rspam03
X-Stat-Signature: 6bd3o4x5rnj17k6ee956maxjz6tgo5m1
X-HE-Tag: 1780303050-471374
X-HE-Meta: U2FsdGVkX19ZVyXRQ4Y5MYQozQDfzUozG9NtvOlmJ0YH9zuRcsDLUEun3uihB68PFqNaqjh8fgHFXR8qJ4nqAY8jeQUck5MxyOS5nPDskQ9ZkqR4H1mYg2yfjeUOxh77Q396khIay3zdBXw5k/IzUSzSLue8gXuCR+VszdZCDH9au09Krqs14hdc5nEbq1hDMfASNC28zYvCKPMAvYrxgZRyfwWp6SbSZMN6O2Y+aei8huVZSSjvLtWMfeyJ0fC6Jjy9euLZUlMaTtnN5dPrwkDYUn1SH4KTF1Ff4qIj7SYM4NyF8ppiv9RJ7T52LnB8HspODw4+3TY1mIIJ4hBuDyqx2lduR5vWzhFjgykMZKJ6JxlV8fGidGWWwotq+RQfcml1PvNIYMQa19iUZyBhvV0O2ivOvmeUbRyXyc1WYDjj0zyFjMKSLusc72Mlt+Cgq2lwgo/zFgZM5DTYkQOzo3S6yVVpW+qOKp8XGRxdwRF/PLNaCTXfiYBYXS6V45iHEDQ2cvyAoDIrJ6Bbfa0RNXhbpli5L0wKvZ2L2qGZU8vw+ll+KWjXl5w7GEB3J/HUU3iAjVY/OHcQ+zu4Ho2UxLVWbFjWZYRCcL865WkPffNiq1uFGD7eb+6e4e1CzlJ8DHW+JS7x/hVPWHe8JqhVEDuNVX0jnStYFa7xwgXJjo9piKIfbTyFQ6sE1fh/Fa05tMFrgMbkfabUEw3L/uIACL3nQPQ5MY48nX9/kA4IvLcZTZnI/+z2le/kPmgoAZNHbj0wrYcKl7o4RJ5myk+/A5AmPoYTeHopvhQeuosTfGsXfTOFQrMSVhT6ZKJKyjMC7T3Mmq+VhV0e/skfkKLbiBiJiBMIomVpvFfq++tq+QQ2f6ifJzxvkHGU9zdIRm3XoTiG5q3fQ5ExtJgQcGCyMgF8+BdPXK5+X3hOWsM4bmev59QJGqbBwKRE2ddpWG9slEh+yPnIB5Ayh7+VTCH
 oQHHrnnP
 /IF4E7639tLNiQUc9ChZMW6BCPIQlboP86x6PR2dLn3R+pO1nkou/CNooVDrdAAN55ZJNGsITjgAqQwYe+tAqiRqUlLiVkm9BCL4KUoCLeR3wQgFOrdq/XMcqokb8KC9v0gJVvF7S+g6Qg9MBm2GJbPNqYn0e1k1U9iLLroYKVZLtc/fLCb9IQzGrktfqCVjl0RTwA3iyYGd3ep1RMDzZ5jbbNdr7422LOYkiN0vGd7QP1HAUtLtBzXpjTMJakxBW0DqqpZQ0TTNiZOj5MNp6vOq0Fcvkes/NyAvTMyUhmlmwKpVbk9lxme9mSpitPZwGe6G1t7niiRniAxurz2ec5jlxUm7U1v9hGvk1JH/7eg/czHcbuah2BgAwZciPD4spYKr8t6foJ/Y1yi4xHS8YJxnoJfWCWPZpryqlqzfnQGPaprikbUR+Cs21Ekiwgq1XsaWVVQ7PBVvjjC/hiyo/u9INN5+uTRyLn+HNZkhD1o8qYoYCYhUQbJ05YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 06:54:07PM -0400, Tal Zussman wrote:
> On 5/28/26 8:49 AM, Christoph Hellwig wrote:
> > On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
> >> Overall this makes sense to me. In particular I agree it makes sense to
> >> move the file read/write helpers into fs.
> > 
> > I disagree very strongly.  Mixing default implementations with the
> > higher level APIs is a really bad idea and leads to people taking
> > stupid shortcuts and other layering violations.
> 
> fs/read_write.c already contains some of these "generic" function
> implementations, including generic_write_checks(), which is called by
> generic_file_write_iter() in mm/filemap.c. Right now the two files are
> unnecessarily interdependent. I do think fs/read_write.c is the natural home
> for these functions.

generic_write_checks is a very different beast.  It is a generic helper
that every implementation must call. The implementations have to call
it with the right locks held, and this it can't be done before calling
into the method.

> > Splitting up filemap.c makes sense, but I'd rather keep the generic copy
> > into and out of the pagecache code with the MM infrastructure for it,
> > as it is not VFS code, and making that clear to anyone touching the code
> > is important.
> 
> About half the code moved is implementing direct I/O or multiplexing between
> page cache I/O and direct I/O.

This will hopefully change quite a bit once we move everyone off the
legacy direct I/O code and the helpers for it.  Another reason not to
move the code around for now as it should change a bit.

> It definitely shouldn't be in the page cache,
> and I do think it is VFS code.

For the higher level stuff I'd agree.  But I'm not sure how much
is left after the above.  If we have good helpers left something like
libfs.c or a new library might be a better place.

> The one exception I see is
> generic_perform_write(), which is analogous to filemap_read() and should stay
> in filemap.c (and probably be renamed to something like filemap_write()).

Agreed on that.

