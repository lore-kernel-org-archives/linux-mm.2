Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E1FF9B600
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE246B009D; Wed, 22 Apr 2026 06:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F5F6B009E; Wed, 22 Apr 2026 06:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DB76B009F; Wed, 22 Apr 2026 06:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAD06B009D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:00:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C907E16158A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:00:39 +0000 (UTC)
X-FDA: 84685747398.04.834DB1A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5069280019
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:00:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SjVLdPKC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="73x/GLVl";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SjVLdPKC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="73x/GLVl";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776852037; a=rsa-sha256;
	cv=none;
	b=NQyrVudHxdc0O0L3+mpIYdtsdIUaRCZAnGezq+sXWll6pGds3HmQNEkbtCu8udAN7lSBYF
	YpFJyruroB7y0+Xnkf+UhuKLKw2JweqJQh9meMGCvFaP4L26a+fLiWQLRfNMyFGC3USImU
	8mQhRQIaZ2apwOpZbq94eUGxZqXzpkI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SjVLdPKC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="73x/GLVl";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SjVLdPKC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="73x/GLVl";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776852037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=ZhdJMkm+niDuvddJnZushpPwRF/4B8Jki1HLMpgfdwgQBubra3qZb4wI72RY6A5+H3X4wI
	i5el1tP6zNuEHa06uxSTXEaa4QaI9jxaPnTCxjzbhed7CV6qNR20digVLVRIelLkQHz6jM
	vfsXmoaKPxc5NDvwMSPxogqK/26VOhQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0C0E66A81C;
	Wed, 22 Apr 2026 10:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=SjVLdPKC4/j27kw40iMX2JK0V6VseBXiSUfd+4TOCGS5X4cvfQuuyUD3cNC+z6b3Um5AyW
	FCZuZqGuOg1rhRbIZovbzw1kz3YFyR9YC7nmD/ZBwVuxw9MarF2IWHQP4W5vF5KaNOJWxu
	OttKY/agBQ0jd46ecgnZ+V+I7+eWDkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=73x/GLVljcjJrS9pKrvLri7z3sAmhL189LSOcVyD1SuE3XqkSCGmAngQhgrrIp/b1qDNIg
	Djn5enwMO245HABA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776852035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=SjVLdPKC4/j27kw40iMX2JK0V6VseBXiSUfd+4TOCGS5X4cvfQuuyUD3cNC+z6b3Um5AyW
	FCZuZqGuOg1rhRbIZovbzw1kz3YFyR9YC7nmD/ZBwVuxw9MarF2IWHQP4W5vF5KaNOJWxu
	OttKY/agBQ0jd46ecgnZ+V+I7+eWDkI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776852035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gC49Yb3N46hJVol6vATt4FOJ+QGAh8iwrDdeZTg2tjc=;
	b=73x/GLVljcjJrS9pKrvLri7z3sAmhL189LSOcVyD1SuE3XqkSCGmAngQhgrrIp/b1qDNIg
	Djn5enwMO245HABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8291593AF;
	Wed, 22 Apr 2026 10:00:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d6ilOEKc6GkRVwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 10:00:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1C59A0B60; Wed, 22 Apr 2026 12:00:34 +0200 (CEST)
Date: Wed, 22 Apr 2026 12:00:34 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, 
	hch@lst.de, ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <eqbodkjxxg32ryxsdngx35yhv5fy4p44fmvlnlnoyib6bstlmf@4hzxnfwleynb>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
 <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Rspamd-Queue-Id: 5069280019
X-Rspamd-Server: rspam12
X-Stat-Signature: x3y457uueqjofwitrm5ppp63yhx6w45z
X-Rspam-User: 
X-HE-Tag: 1776852037-872491
X-HE-Meta: U2FsdGVkX19DajC9pCmvWjHhGkmTl7rhsavXdB/4ox0/R/ozW2lEdH8EQHeQX13vede2shHe0NE+tkB5Vt08lbCrJFlpkszFNrsBeVIYvMfFeYjkfln6pr77kwCmeqDbcy/UWbM76v1J0X2TphteaypaAgP2MhF2X6kqph3hx3WA7DoNeD9wugYMV3zS3M0bH6mA11zfp1afJRiekMcfjShgC4Dzb3J72TftMRBVv2Qr+Dx43tGcgfyYJT3BhbYdkX48pZnH8fJankTXsPDkfR5T8kleBo5flddM0A9rtqqQCpRTqBzAdXsfcEZUSWbK3spk5vi51n+HkYzZEAalVYVTuwtUWqBzU5CuQLwHGOZHeFf5OFYw5so21SZGeIuTD+jPnlj5Jgt5p7N6FvkhZBNb9GlJyZW3uJM1oyJ6ybVMCBwRFCPynnHXluSNNfupvyA0iymOCfdOopVCfZoi/j9c2Et1RwG0pp0fZ6opWcDblvZenDD+NJBA7vxKohgovuRKSRuEnRPSYRhNZghydBb25eDJZuRRxnXxQOnGKfFDO8GXQ/FaUW7rmP2LLWG7Ka8b/badKxWlc6WUZdzZIOGOhHwnReeL73v/pflu2QwqtHlEUireM71RL2JpPFW2MfrLc7i8ZeIr4vqQKzXieRnHVoGeGxFyZ4dcdePWk/jhYomrXs2eORYUNFQ1rjmb+JtGR8q7ykB6Zu20jEg962l2FkoIbf4s38WJnE6WerTNpebu7hI/oljKKjTyD7SDY3hxzLpTc9fVMFG2bnfw3kRBijOrLl1scm5+CrV7wFP9Tbi7FSxztzI/AW9UqMQiaKzbYXPakVFw+doz+Tn6ng/BLKmDO8qinc+PYuD7t3UWcdWg76kjN0peyc0Y0bvIxCNpHM4OsfQsD58LeVpHp888sRLIXq4n84gs0+wPtJ4O3mmad75BxoqcU9I8n3730TJd1u7EzkxglCI8e7Z
 4wPgf5Km
 Ed3tAxQRoYv3Jhu8lS6zg0pavqZU41iCsFOo3acsoaXR7iCdE5bXQqydSzOS4t/QDzUgebfrZ53l471EUNwjwfwO8lQMb62+EI7FxIJKQXaMArwjDN4oTzm7tXFuYUxKIoh4cTmp9HOYdc8uyPSF8X4yDThv1aY2BunScqR2bS6bj2pPtxyQNoLS7bmapSB1C1r9ATk8z0ReMzcQidkSNBKkac/0hRv/JpyzmRKtNx4Vl7QGjduFKcMne18/u0BvNBfrdcyaUM+6VEV/ZQzIQ9+76IjVadCfmTHEt5fhH5n36iiqSNuaP7NjBFkpn+Vywx04bVBrbvv4bHkYgWiaMgJeiLcc4uFSgy/QlcjhdjS92fA8Gv/fMTTZePJ/W/f8liDgVaCKpZgdpt13srHMxOEhgDCGaqCjOK4C0GIpHyHCT+2mhR0AFgjrSDZALy5Gy8A8QH0JYljcyxvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 21-04-26 23:37:01, Ojaswin Mujoo wrote:
> On Mon, Apr 20, 2026 at 01:28:18PM +0200, Jan Kara wrote:
> > On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> > > On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > > > +
> > > > > +{
> 
> <...>
> 
> > > your comment but) after this email, I started diggin a bit more into why
> > > it is needed.  As per my understanding, it tackles 2 things:
> > > 
> > > Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> > > allows us to allocate new blocks which previously might not be allocated
> > > if bs < ps.
> > > 
> > > Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> > > old EOF to end of that folio so that readers dont read junk data after
> > > isize extension.
> > 
> > Correct.
> > 
> > > Another thing I noticed is that most users of
> > > iomap_file_buffered_write() do their own eof zeroing in the FS layer
> > > (eg, xfs_file_write_zero_eof(), ext4's new changes,
> > > ntfs_extend_initialized_size() etc). 
> > > I think this FS level zerooing should take care of mkcleaning the eof
> > > folio (problem 1), as they call iomap_zero_range() which would flush the
> > > eof range anyways. So am I right in assuming that for FSes that do their
> > > own zeroing, 1. is already taken care of?
> > 
> > Well, I don't see anything that would writeprotect the old tail page in
> > iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
> > address 2. Not only due to mmap but also possibly to clear whatever junk
> > there can be in the blocks after EOF.
> 
> Well I was thinking more like if the EOF page was mmap'd it would be
> dirty and blocks beyond EOF would be unmapped, so iomap_zero_range() will
> write it back which shall mkclean() the folio.
> 
> But I think the same race we discussed for problem 2 can also occur
> here.
> 
> Thread 1 (extending write)             Thread 2 (mmap writer)
> 
> iomap_zero_range()
> filemap_write_and_wait_range()
>                                        // mmaps & writes EOF range
> iomap_write_iter()
> isize = new_size
> // pagecache_isize_extended() is
>    needed to mkclean() old EOF page.

Yes, this race exists and unlike in the case of zeroing where it is mostly
harmless not guranteeing calling page_mkwrite() with updated i_size can
lead to filesystem tripping on assertions, data loss or similar.

> > > As for 2, I think after the EOF zeroing of the FS, there might be a
> > > window before iomap_write_iter() where an mmap writer can still dirty
> > > EOF blocks, hence the pagecache_isize_extended() would be needed here.
> > > But doesn't that then make the eof zeroing in the FS layer redundant? Am
> > > I missing something here?
> > 
> > Hmm, I agree the zeroing looks duplicit (for some users of
> > pagecache_isize_extended()). And yes, doing the zeroing from
> > xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
> > write non-zeros before we update i_size) but I'd have hard time to argue it
> > really practically matters - you are racing mmap writes with buffered
> > writes so any kind of write atomicity guarantees are not there. 
> 
> Yeah, seems like it is not enough to take care of either 1 or 2 and
> pagecache_isize_extended() should maybe be enough. I was just wondering
> if we could optimize it away even for normal extend path (no racing mmap),
> we can avoid the expensive folio_zero_range() calls.
> 
> Regardless, Ive not looked at this more closely and its a separate issue
> so we can revisit it later. For now I wanted some clarity around
> pagecache_isize_extended() so thanks for that.

Well, but pagecache_isize_extended() doesn't guarantee on disk blocks are
zeroed out as well as it doesn't dirty the page. Also
xfs_file_write_zero_eof() potentially handles zeroing of more than a tail
page. So you cannot simply drop one of these.

> > > Regardless, for our case I think we will also need to do the
> > > pagecache_isize_extended(), mainly to take care of problem 2, but where
> > > exactly should we do it now?  We currently change the isize in endio()
> > > but for aio, it can run outside inode or folio lock. I think this
> > > function needs to be called under inode lock(). Hmm.. its a bit late here so
> > > I'll revisit this tomorrow with a fresh mind :)
> > 
> > I think mainly to take care of problem 1... You are correct about
> > inode_lock but since we are updating i_size, we should be better holding
> > it, shouldn't we?
> 
> Yes you are correct. In the aio writethrough codepath, the inode update
> is happening without the inode lock which is wrong. I overlooked the
> fact that even aio dio uses IOMAP_DIO_FORCE_WAIT to force isize update
> under inode lock, and we should do something similar as well.

Yes.

> So in v3, I make the change that for extending writes we shall always
> finish them in "sync" fashion so ->endio() runs under inode lock. Then,
> after ->endio() in iomap_dio_complete(), I will call
> pagecache_isize_extended() to take care of this. Just like isize update
> right now, the isize_extension only runs when the IO was successful
> otherwise we return an error to the user. This gives us semantics like
> dio while handling extension properly.
> 
> Does that sound okay?

Yep, sounds fine.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

