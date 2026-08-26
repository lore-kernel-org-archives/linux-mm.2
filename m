Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A699C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 04:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB876B008C; Wed, 26 Aug 2026 00:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C8A6B0092; Wed, 26 Aug 2026 00:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9F46B0095; Wed, 26 Aug 2026 00:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08E086B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:53:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 644C0C026F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:53:12 +0000 (UTC)
X-FDA: 85142201424.24.B4E204B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf18.hostedemail.com (Postfix) with ESMTP id 85F3E1C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:53:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787719990;
	b=hji16ys/r8tZL11ghGP4rzGlUkK15nCr92/NXmWrTOTkiHN/GaFkMAX2TPlzsldvGJ9I8I
	C8yLzqkWH9bx+MxPiBB4k4mWGF9D0L4zUwemwwmP1uzC+ecqNfH33Rbf8P4bHJ5PuMSKPq
	R8i35kupO+yMwpZKBV9X1rvp4kuNWXU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787719990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BX+Aw9jGEryr8KlQ+oYDjN9cDa4zCzlWhN2xEwaOs/k=;
	b=K+eYGYZSO41NFapSVv9/2w82tC8RKsozlEWa8k43NkPRo7sAwcRAXEhwQxkWL0X1YUV4t6
	8sfmL84/PZdYObyOeMJDEei10SLQC2nw7ecKkd1P1KIw3Kf+3FL9N//7XkFWQXXoYHJZ0V
	O8x0sTAqXGfhdh3RjQPgl0CfZUhXQ+w=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8852B68AFE; Wed, 26 Aug 2026 06:53:04 +0200 (CEST)
Date: Wed, 26 Aug 2026 06:53:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Qu Wenruo <wqu@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826045304.GA15122@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <a1f8902b-72a5-40fd-a36b-89b6ea271cdd@gmx.com> <ao3sgEET8GuY7Rw2@casper.infradead.org> <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3486b8-a506-4732-8274-b3179fb06a82@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 85F3E1C0002
X-Stat-Signature: epfzpg7syxsiyi6xc3fkx5d811bcazqi
X-Rspam-User: 
X-HE-Tag: 1787719990-189525
X-HE-Meta: U2FsdGVkX1+mdvhUomKC09ENjHZVQdPNY8GAPBaDRV7LenzFSDyJlcAOmIretrTMLuS9h0T8fC3wND4TJe/6mCNfAHIIimLjOlrdeMyxlfgX0ExeTLaFfhCQEKaaXKxm5A+Rutt6DOGv33aTRZ3eMOvZiIV8MZ+f3OOhDSLQCQcXq1ZbvFZPFlSyksT87PrsW//DHjALVdfzHyWbw987lGuNMk+aVPr2ipLhfocvyZCAqY+eOeYoD3T8LKeOb7rbF8B2YnYvaz9dFPKEwEQMjjp1lb2Mw4vR1uoLcHboUJ8iDEf99Jr7mkVEsHnUpPe5DN1C/fBa9b9bQG1nZVcEMuWwnE8liybKNQZSqMiWK/63oob1rrpTZEdHWrXtJEgSi2BXNe8dN8ki/mBTFUx0gKpPQNyRA3ZhVVYPK8lQ4dDuW+EL7Q7djhW6D9E6JOcnmWAI9JdMLh8unxZt1uep3NBuoWZg0UJHd8srHnGgFvQQLnUqa7GCiC2HfzPCqMJKEjU18yaXzL8NPfP6aWttBnPVIzi+oby8QbfXWz8Ti9CQI+K+QanSTROdQUvbs2yrvJ9lTN/oPvuHalh/D3hFk6LXIViOmugt9n/yInLHLYnOPwGhtagNhDWH7349nzhrnYr5foRC7cAPqgOWWo5+Duy7LF6qH4VTLcEXa7gmWDrf/m0PX7H8ngunkttil4nLm6YLqpZRJh51WJ3gAW6dekeamq4QQNaLqVbelHfkNdt99iTL5fJNHbgjygvIdAohpiv48stYMW+N+mVRXdi42O5y7p40xSwxWemmmt5XmJmDRbRyxaPCEgX7QLaABbA7DAvJhQnEOOeIeUr8VQ7y4JIJYecjWsLcfIibKKhcp93frEguNmsYTezVS49pPAcu2V+LdNcgesjBTRQ7L8fYGAp7sdKiaPpuh9kzCfmcmiZDB2jS90lOrFw2stJ4ErWRaJ5BDBifWf7L6omF+Zc
 D+eGHVDy
 OsE+jlOiWMoppEpqI6oMcybGtUDeMIPxz5zPTYM/a+NIKMiWuTWOCsVLgjng78R3CVeNhQKVoHnJNLqut0+sMEChX1x9e3a+TA1B8BVxkphIl7lCR0mBql0mxp3lDukINRQC0Y5G9iz4aOT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:03:38AM +0930, Qu Wenruo wrote:
>> Why is it hard to do it immediately at writeback time?  I think you're
>> in an even less restrictive locking environment than page_mkwrite is
>> called in because you're not under any MM locks.  According to
>> Documentation/filesystems/locking.rst, ->writepages is called with
>> absolutely no locks held.
>
> This space reservation problem is a btrfs specific problem.

Not entirely.  It really is an issue for everyone doing (forced) out of
place writes.

> The root problem here is, btrfs space reservation can trigger 
> writeback/transaction commit.

While zoned xfs doesn't actively trigger it, it still has to wait
for the GC daemon, so we're in exactly the same boat here.  The
space reservation has to be done without VFS locks, and in the
rare cases where we can't do that (->setattr for an unaligned
truncate) we have to play with fire and dip into a reserved pool.
It has been on my TODO list to fix up the VFS interfaces for
that to be called without locks held.

> This is due to the data/metadata COW nature, and that's why we rely 
> completely on buffered write to do space reservation, and avoid any extra 
> space reservation at writeback time.

That's the only sane thing to do, as at writeback time it is too late
to reserve space.


