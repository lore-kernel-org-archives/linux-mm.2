Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B12FF60ED
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06306B009D; Tue, 31 Mar 2026 04:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDD1D6B00A0; Tue, 31 Mar 2026 04:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBA76B009E; Tue, 31 Mar 2026 04:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB5716B009F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:49:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 791A08CDA0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:54 +0000 (UTC)
X-FDA: 84605735508.28.1D8FF3E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F905120004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:49:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlUIduQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uYkD+Mm0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlUIduQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uYkD+Mm0;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=UkehvBo6KcrtadyGOlVTYcCwyNxXIsy4uwqnmac1FrJa9TBycabzcRm3vCoQXLeS1TcsFm
	ZHHIy6XMKgwJXBJHIBTEVF1v0CR+BO0IznH9lJw++cEfpoLlclH+eDZrbCXLeWwBPijhFV
	NZToolzfx5hmpupPB0ZOlx3HjsUo5xI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946992; a=rsa-sha256;
	cv=none;
	b=1mNOrO9dhHZzS61QHrq29fYZ6Iq8Mn2g/7KKzdyaeygri3XL1pQJsvdtr74+ugnbXd385i
	gvTHKk/9pM1ME/5whDrnWArct1E3378Xr3rjSIpid2nBLGTCZN5oLz4pIr9MZ1vhbO/+pG
	sDXHV9z4aIh3sKCiGxS/6LRMhDNn1ig=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlUIduQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uYkD+Mm0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlUIduQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uYkD+Mm0;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D0A25BEAB;
	Tue, 31 Mar 2026 08:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774946990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=wlUIduQEDXoPt3aXNwJT5NDX/0+zCJDMy++1/ggArpX5NSBk6wBRUfCtlKVES1z3gvKpB6
	WbQHqg44UpEafP6tJlw2QDKkYIqIPlRYyfXjtqI7qotDgtmoFLFJOXX855/EvAkb4hWoZV
	gBgpQAi8CJ3jxWaSmtfERLt/hmK4dCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774946990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=uYkD+Mm0jxgXujM6nk/nyMorbFZ0MFisnVyt5DaDnXGFCdJI/+EzU758M3a5C6YSwDTz/u
	qJ1NUaQb1+x8MKAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774946990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=wlUIduQEDXoPt3aXNwJT5NDX/0+zCJDMy++1/ggArpX5NSBk6wBRUfCtlKVES1z3gvKpB6
	WbQHqg44UpEafP6tJlw2QDKkYIqIPlRYyfXjtqI7qotDgtmoFLFJOXX855/EvAkb4hWoZV
	gBgpQAi8CJ3jxWaSmtfERLt/hmK4dCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774946990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=uYkD+Mm0jxgXujM6nk/nyMorbFZ0MFisnVyt5DaDnXGFCdJI/+EzU758M3a5C6YSwDTz/u
	qJ1NUaQb1+x8MKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FE254A0A2;
	Tue, 31 Mar 2026 08:49:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3uejC66Ky2ntMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 31 Mar 2026 08:49:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB159A0AFD; Tue, 31 Mar 2026 10:49:41 +0200 (CEST)
Date: Tue, 31 Mar 2026 10:49:41 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
Message-ID: <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jyutwo6o.fsf@mail.parknet.co.jp>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2F905120004
X-Stat-Signature: n5h6hre8hwnsij415ykid8yskqnfk37o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774946991-688519
X-HE-Meta: U2FsdGVkX1+UWp45GDNvSEosYvzQNMdHN9lJLnYxVd5VbQ+AXxliD272LNnSN5a9y53cD8TF74/5ulYwhJMKzPCu7J200sQV3Gwbb37pnWa4GNXgx9ZXRARbaK86PLp5IS+ARL1bJ9ghjwh14sv+sFK8rOw0ymFFZ9Mlqa+UWXYJEhBduPRnZKh+wFSJUjEjaeROBO/N4S+Civ9Wt80ztxE0kLj/F13zuuPjomWTbS2wwspPW2esZxORq7/fjKoB0xIdE/D8OMa4Nt/V4LI8FCKoFVbvTCTyP2B5qrEYgFEMlmsYV71jzl3TPeB3IAfqI7dhsQQnEH98UJ+UQQgeO621GH6NK3otll5uGIWmzJMum+XqbK7VygHkzwJVVPEWZZFzacZSHS6cwM6VcIxkNMCioH5y8Da+0+cuh+4JuRLzeLLxkwHm2NnpQaV+miLY/xHnrZhpiZycmYRbtJEALthTUranHhCNmt3hZ04D2Lew4Iw4cQPNEN8qj9ehqn9l7CXB2PVUzPZ/jRfFLKy6SD3LxADtYgPsjEh20YkEvdm0r5l+zg816q5ld7pWFADWQJgB1cG1ll+n9LAh2E7UT31tuDahAJxSCtx9fxLTR/5cdh/pzQuzaVzUEgOvCVQHxC8Mk1DqcGIRAyyM3TO5f1jkZCElQlSb59KBT2No0lEQAvP5WuWgkN53zQf6T+YbTYVwshECpC6mjd4GvQMwrl4Q5EzrFM4AmrX+BBkTrgQSyMxBOBxcnQkHva1agMOcbTb5dmGbr4pUZMaXAtN/Km4YfKyAMwWe0t6ve6PhYRKqiHs9D/M0EoQsr2rPOmF4G5vOfKrx3yHa7Pk5xav8acfOV561t/3UCHFaAKZEAA+sldihjgVth94qKPbHhxTzTQV4s+e5/YS9fA4vKQIC/3P3KryG9gqDb1POkKU/bmsq5NMwm92kxZBddCngbpOFgoV3gbS0+oh6H9Cye84
 6tGtUn4/
 TDnwVM1ZjRH1kE3BzukGxsushAs0t1MPvKNRkZtyWByf5Y8Qvqmtn4DVvMvxBsO2v2Gjg+t67kYLKW/hHT7G3uY60J3qY5M3WFrnXnYBnd5naJS7g/8eXgr9VwHxicd37q9kRF6lx11STyL5sW6J9Weihks8VVBWdnhLeV8R8cFjdDE3ITaEzntaydqRQWE2vGso7OiM1/WjicWPteZxb2hc4HpRKfZj/YEwLZnYWAC1eOn/xq9NMsz2b+se0Iwb9RYP8WPMjhc8kIMahyZU3u5dyklQEAXjWty3y/SVyYbajNXnsR4utvbLLj+2jZMq18TsKS8ivlGX1RTo1g5/ZiPmZsxKswi43hgdmlWSqxXyXdoDeucQHVVSTmkMbOjZpzhWQbk+k0wpDxD1s4iwMjBnzf0o1fP6wIENTZ2fC5eRANPIleMH6KhI+x4kEVXBNlgKO5RpwQnboGIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 30-03-26 20:29:19, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> > There are only very few filesystems using generic metadata buffer head
> >> > tracking and everybody is paying the overhead. When we remove this
> >> > tracking for inode reclaim code .evict will start to see inodes with
> >> > metadata buffers attached so write them out and prune them.
> >> >
> >> > Signed-off-by: Jan Kara <jack@suse.cz>
> >> > ---
> >> >  fs/fat/inode.c | 4 +++-
> >> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> >> > index 3cc5fb01afa1..ce88602b0d57 100644
> >> > --- a/fs/fat/inode.c
> >> > +++ b/fs/fat/inode.c
> >> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
> >> >  	if (!inode->i_nlink) {
> >> >  		inode->i_size = 0;
> >> >  		fat_truncate_blocks(inode, 0);
> >> > -	} else
> >> > +	} else {
> >> > +		sync_mapping_buffers(inode->i_mapping);
> >> 
> >> Hm, why do we have to add this here? For FAT, if buffers are still
> >> dirty, buffers will be flushed via bdev flush?
> >
> > The reason why I've put sync_mapping_buffers() here is the following
> > sequence:
> >   fd = open("file")
> >   write(fd)
> >   close(fd)
> >     - now data gets written out, dentry & inode can get evicted from memory
> >   fd = open("file")
> >   fsync(fd)
> >     - this should flush all dirty metadata associated with "file" but if we
> >       didn't call sync_mapping_buffers() during inode eviction we wouldn't
> >       have a way to do that.
> >
> > So in general I think sync_mapping_buffers() call is indeed needed.
> 
> Hm, it looks like not new issue, isn't it? Why we have changed now in
> this series?

It isn't a new issue. But so far inode_lru_isolate() was checking whether
the metadata buffers list has any dirty buffers and if yes, it skipped the
inode. So inodes with dirty buffers in this list could reach .evict method
only for deleted inodes or during unmount and either case makes above
problem impossible to happen. This is however a layering violation (generic
inode handling code shouldn't care about details of buffer heads) and as a
result it makes it difficult to abstract the metadata buffer handling this
series is doing. And all this for a handful of filesystems which,
honestly, aren't used in performace critical settings.

> It is including trade off write amplification vs reliability (i.e. may
> not call fsync()), for example. So I think we should not add it easily.

I expect in practice you'll hardly be able to observe the difference as
inodes usually get quite a while to be reclaimed at which point the dirty
buffers would be already flushed by background writeback. I don't see how
this change would lead specifically to "write amplification" - that would
mean frequent redirtying of the same metadata buffer of an inode
interleaved with frequent reclaims of the inode and I don't see how that
would happen in a realistic setting.

If someone comes with a realistic workload which would suffer significant
regression from this change, then of course we should address it. I have
plans for adding an interface for filesystems to expose the information
that inode has some pending dirty metadata and a way to flush them from
flush worker because that is a common need a lot of filesystems has and
doing the flushing from .evict isn't always doable due to locking
constraints. I'm still thinking about details but this has to be a properly
abstracted interface all filesystems can use and not a special hack for a
handful of old filesystems.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

