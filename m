Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59540FB3CE4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E506B0092; Mon, 30 Mar 2026 05:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835636B0098; Mon, 30 Mar 2026 05:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCDF6B0096; Mon, 30 Mar 2026 05:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58A576B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:08:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 077931405A0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:08:32 +0000 (UTC)
X-FDA: 84602153664.04.324D25C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id BEB25100008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:08:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=21z2fq7M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF4HnnPs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=21z2fq7M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF4HnnPs;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774861710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=BbnKtWHjco6xx3sTeJYJhH5OExZVybDxHBpC8UlxxTK5o73rVxYw1t6MNfIJh5jFCIpVV1
	WfVAbqCHI0vcLYy7te4lKpijNsb0KvK/xC3yKGCs0qtVD07ve/mKwt0x4GtNrnVSqHqvwg
	3pqRWwPzt8SxH0z8Bz18TdaCaHCPv2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774861710; a=rsa-sha256;
	cv=none;
	b=xdY1YX0cAd/rF3nv9PPD1vaS8Iu3F7fsT+HjY5+6k69SPrAXFRjHt0C54OXRwB9zam+84v
	Bp0hEj2IROLbDqLx8J/zp7vGbv9Ubx8oR0wCNGR5dO+m7fskW4xMQNHMuFRUZFsfCdDFiT
	O57uiy0AvM2rO+dL6hngl6mLiHdfdZI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=21z2fq7M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF4HnnPs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=21z2fq7M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF4HnnPs;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 008A25BE8B;
	Mon, 30 Mar 2026 09:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774861708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=21z2fq7MEM8GlGdf2p1Uv1FeRcKESExRgP+QFExXTXCq9vjvD37Oln1sRgp63MmpBleU0K
	hcsDaH4YT7EkKrFnmgAqwxXLt3e3712CNd7DtJZvwhfeN8+oYg+A6DG2FPd01Km+HpRF92
	Q0qGVMee1nWWIhqzMvwqQd4zNbECO7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774861708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=vF4HnnPsOGy+AHlch9F2HDIU/7wavrI+NPGwGHYZTtBvptIg60FlEL5e+gbAg+/DdYXe1u
	RCzDEww/+tR4L0DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774861708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=21z2fq7MEM8GlGdf2p1Uv1FeRcKESExRgP+QFExXTXCq9vjvD37Oln1sRgp63MmpBleU0K
	hcsDaH4YT7EkKrFnmgAqwxXLt3e3712CNd7DtJZvwhfeN8+oYg+A6DG2FPd01Km+HpRF92
	Q0qGVMee1nWWIhqzMvwqQd4zNbECO7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774861708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=vF4HnnPsOGy+AHlch9F2HDIU/7wavrI+NPGwGHYZTtBvptIg60FlEL5e+gbAg+/DdYXe1u
	RCzDEww/+tR4L0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED7BA4A0A2;
	Mon, 30 Mar 2026 09:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jdLrOYs9ymlLDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 30 Mar 2026 09:08:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1894A0AE1; Mon, 30 Mar 2026 11:08:27 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:08:27 +0200
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
Message-ID: <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldfazqo2.fsf@mail.parknet.co.jp>
X-Rspamd-Queue-Id: BEB25100008
X-Stat-Signature: eurjty9z6caetohfhpkq7u51eidzkxsx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774861709-123901
X-HE-Meta: U2FsdGVkX18bVc9F9iHdpuQr7wKfXrlzQpxKMlpQXKTpEJExCzWajTwPM5J4XQrUNpz7WKa7v3nYd3GQYCEzVokTPLugSa7eQa7tC7kEeSCgfLEDZ3/RF85iY0lI5rSrYLPw3ZCmtOlMwHdXd21UFaJziMFllj4YrtYcEZZ4Xp6QSce/jSwwAeTdXf2Du9I5LWpUmtgPqQNyIva4X8IC/dQkATyVUPO9TTS+kpRQL7WP8XpFt6mODEdGpduPsUs4+bfr8cPm7nZdQD8xRH2igkw72E/gEKBkOyN5NE7mbwOMPSTb2lPv1I/0UjnwL6dBXaIKVufnK+cdfl37+BIASFjacpecrxqk1xcDG3nG41NdzY4oN3XxG+7vTFlQf/7sAb0NPAb1CgsZwGIQSL34HAsd7YLY1TdrDbwOnSgTuTBSWmZH8DYzA3SAkWo1W9l9pK1Q4i3ICRrtNfcOdRd8cW+Jeo+NY8jQXwWIgjr+6c7qU1yoWaf/9ylI4UhhxOBM4ImM08IWaGt9ogKkF9GYkpyUH85AQ4xhQFkIja45CY+4ZRrVqOoGkStbddxnyBBLoIXv/Pd1zylxjFLvRDINdFxzX4tIgVsoPGS1o8+4nqJETWTJZFRW2GIK9ZcNZZW3oFhi3EEM6RZqeNKqkwJOJbHQWNck63fl4pEMet7rJ/t+L+6ifrMKXuUuch5/aozme/T2xseXY0eI2kJEQzoN9lJ2j7omBzqe0sbL7KImAg2WzTBySh1SoOoLLpGN2mT3PvUm9gIHKkxt/zM60cLBKoejmr+tXPnqBIpCCBoNwT98zqS+rbWxIhHhrxgdTen7hH2hKgn6BstA/N6qxJKiBturg7bEi5ts7Yrh7yP9BzUki3LeYYJrSE8yws9C17iJwxOk6hOwV71KQuaKg4OHebsIopOCWWfGzKHiCUr/CbJ+97z0nYLyvLQj6fa9rZCDkB9dCkKETHv0H1iHUn9
 eIhr0ip/
 581RMb0ya+E++2Phnk5THFxZBm0OCs6302sTyFv/1S3XDYMcgdwMST8+ehgdjJ3JArM/MnWDqfPA2Afwz+4O+PfIPXdmNcBxDzoAKRn0vw2ORVaiBujN03i0KVEjixb9At7oqE9IcZY8uQsPIgvIyrLuC93VrzVz8X9V79lTXFam2YHKdi93nw5qi/ttMRFEIg5fE2AmIOtac61QLS+Ox3ZgJiGx7h6LbIAQ2Ubc+V91+pxndv78BnWmsgPzdNOgbmpG55+Gtr8Cdo7UqUD7xZetAk1tClD85lfVOjSChClvRtV5GXAAYVXw/T9X1Q81Orl65oMQvWPN/o59UyCZysyIwzjDajw8aZTFqL0BSL/JhtS56q11JTWIngFXDMKrjLgIIwXXB+B90hVSK4VY7Pb+3ap1WrNUtY1DUZaiezqJxWQzbVSCiWQPKpq9/G0anCfUP839XoU28iiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> > There are only very few filesystems using generic metadata buffer head
> > tracking and everybody is paying the overhead. When we remove this
> > tracking for inode reclaim code .evict will start to see inodes with
> > metadata buffers attached so write them out and prune them.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/fat/inode.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> > index 3cc5fb01afa1..ce88602b0d57 100644
> > --- a/fs/fat/inode.c
> > +++ b/fs/fat/inode.c
> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
> >  	if (!inode->i_nlink) {
> >  		inode->i_size = 0;
> >  		fat_truncate_blocks(inode, 0);
> > -	} else
> > +	} else {
> > +		sync_mapping_buffers(inode->i_mapping);
> 
> Hm, why do we have to add this here? For FAT, if buffers are still
> dirty, buffers will be flushed via bdev flush?

The reason why I've put sync_mapping_buffers() here is the following
sequence:
  fd = open("file")
  write(fd)
  close(fd)
    - now data gets written out, dentry & inode can get evicted from memory
  fd = open("file")
  fsync(fd)
    - this should flush all dirty metadata associated with "file" but if we
      didn't call sync_mapping_buffers() during inode eviction we wouldn't
      have a way to do that.

So in general I think sync_mapping_buffers() call is indeed needed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

