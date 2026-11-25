Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06FF6606A336
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z06kVsav;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YAvQYBkQ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=HhT85ONG;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vX/h8QqE
Received: by kanga.kvack.org (Postfix)
	id 1EF946B098F; Wed, 25 Nov 2026 05:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7C36B0991; Wed, 25 Nov 2026 05:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6D26B0992; Wed, 25 Nov 2026 05:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D334B6B098F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:15:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BE99A0E43
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:15:46 +0000 (UTC)
X-FDA: 85473235092.08.CFE9305
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 339D08000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:15:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z06kVsav;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YAvQYBkQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HhT85ONG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vX/h8QqE";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601744;
	b=WYw/vEVHBZWI4sHWEmMzfeFrROFQrLhEsU1u9Wp9/ht8jbWfVcfRMbepbPQWUQbYJd+dJG
	iJ5zmozaIxUeMJzdcE5peTl1M7uNcdCo+7pImLOXmio/9Gg2NWGAvr7WUg6SEC5oMQm6RE
	HqhfWPfVxcqkPOrmgovYFvIdYJlMYxg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=IhPvYaY+Jh92X69bYWPmM6ZfW4GCu573pFc3WE5LOg1mVSbdDtvc/MX9Oeh5IjQbfNjnIZ
	IfPuFYishkfuk5KOMAtSJWumtNK3kQ7G7ksCDWRcGYksGwypK1aSgAO8VYVG9/ZHzlmayR
	XVLKaKGln9psKQVqlayluPASa/tr+PQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z06kVsav;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YAvQYBkQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HhT85ONG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vX/h8QqE";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2EA141F7AB;
	Wed, 25 Nov 2026 10:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795601742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=Z06kVsavmP7JScicGhz4PLwxBu3Dex4qiFvXFQcw6hiBXSgAPrY31rGsLOeD8I/afpGxWJ
	QqvbieM8a3SnCpA7Y6NvO/lh3yjke/TCCdWF5sXAa71+xF7URX+YmX/guYIaETRth2VdQ8
	X+SZ14rjsBbQF8ej4TrovKNBc078KcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795601742;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=YAvQYBkQHWlLyq/pc6sxjMqrMqDGJezvFVbuvPSz/Ar7h1bOwCSdmBMoEZ2smb9B8M8JBC
	ODHaG9GFSZ3kR0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795601741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=HhT85ONGGnzQc8EzNUw9bIL19KxpV6xykb0gpdQl0kCw8mIPbOdunsyJcQSXg0b1GormL1
	lRw59Xh0TSaLua+iR8MJPm0XaefZaMjMOcSx3P3W3vJ6YYGgrJvJhcKtoZt0fzweZQ+Faz
	rUqtUBs61FQpsWJiUV2N90/xs5lEjHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795601741;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e8sKqwxNACN+JfXcDE3eynoSNxxjB3Xf/j/Wqh4gx5E=;
	b=vX/h8QqEnMmoIVMqKy2xoZTwAcXtH8GK1fsnluYevvaejjH6oEbpgTXu0WSyCAsOPElHfr
	3Mo54VbDLlNzkbBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2408134CA;
	Wed, 25 Nov 2026 10:15:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gu3dMky1BmtxWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 10:15:40 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7F82427BF7; Wed, 25 Nov 2026 11:15:40 +0100 (CET)
Date: Wed, 25 Nov 2026 11:15:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>, 
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: Removing ->dirty_folio
Message-ID: <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
 <20260826050733.GB15122@lst.de>
 <20261125085814.GA24887@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125085814.GA24887@lst.de>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 339D08000A
X-Stat-Signature: paef3r4og4f3sz9uz9ui6668iqqbgae5
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795601744-278601
X-HE-Meta: U2FsdGVkX1+Za2NMS+7hmobIuiA1PLUnn5NPPwlqFvWa+X6SbO/5cuB8vsF+jwcuEzJCnMrm3C6MYhrNc3f7IfL+iN3eMUbs7gW6JwEb22DXUUN8V+50ATZwt80fiUS6TVd/j42rxZw84C6kRpPlLBbl7p27Sb8nx/GPWiqhab+VHsmkctT3ogjh8Jlxl55yuQjq4GVmUPCEP5NrLQS7ezmpAw8GBnLWeP3HkT0BZY4+Kz5bBkDQGDGNhcfO3UCnSn7pvzbxcKrrKnSFx7ERz3KjsCrAfr1INmDZeX6oTHzQOO5Y9zrhhrwQqgs96hJC+WOQBVACsVg/PSZ5OJPAOizueRtiUdWMdi/PH1DoDFPkJ524lx+BWt+lN5IkcSx2cuEbMBn0542ESHcySyUEtGeb6EJVE71R4x9u3HEzoMUDXvh7Fx9/0FP6ZSuWxlwOqbSt2f4RCtnSZjpB2C/94828xK5KqCNabV8iZ8kqVdnxPTeVZp5CUFMv8DU22jfzVmEZ+BFX8Ljjl2PwAL9MaIg0980XzDnyoGMQYl2NuiVQzeKtSOhT5M8joJZ2RpzOMlx6uxQ2k8QVfeMxYu9HhtbtoQoBL2TCdqDYP26obNN8h/1NpFIc0xAEhiRqmsq7qrlZTlKXW2vIc8JmQgd3jzqDSiTOf9anMK+jwmNSrAtbyaJNw6V1ywn6RPhKKQM9eCTxYIu3rYOAJIf63Ryi5uMLsujR1fLvLvoZ9w3Cj9qqY6EOn6R5hcpgXDdp4iUZktU+KH2B0JYzJLe/h64MKdkNNn/t4DuJIIjA0LmR8Zl3Ws5w1JQ+rlIbgpNmX1AiI2lBNjVMIfmzRW9QZKWBsZANWhutv4JRFGNHmgNlzF1Wo3mn7Z+eb4XS1kuRcGm6of7xMK0aCAMsUJqqDHDbPG38SR76x7B8dxnHN20RfLLqa/otxarI0dYbF3mti66QWM1mMq0WPCy79M5NqD/
 Nfi3C3uJ
 w7733pX4uQCsWn6ql5OaN8iVD/GC958qE0jC4nXJusY4XUoagf9ejA28AkLpcxOCn0gFRaAEmvn9BfbpcIaVfr+lzIiEsM12lVOX3wsp1seUIDMAoq2ZMCUjOK0xq1ztdU2rMVroEXabroBtCdEZo/awzRTE0zsVWXkFZOO1ZUVMBqf01nFUwdmzty0nEjZGAz4Og7UHm7yI4mme2VjKbOKY6GCcF/TOl5A6/Z+hcyO6s0HtRwziTwI1sz0b+LFMHY23wgg9+FG3G06gZZwAnIJWPEr4FzqUReZtW7I3yXukv/365nYIjoOVbvy/UJJBwDJN7cjn3e1VpM03z8ACd06qf0t/8oHjYH3izim15WoaTwPZnF4qw2LRmDPTvK5cdL1q0c3SLKyO245EsBqgx/rf2/BRQu3VN/FJDHGk9VLhvrJQbPsEmHt+oKdlFjdnRgk4Kg5HfWzqFuieJKT5XlPcFTd3747jOkSm7J3feVDokp7A6OBm9BRlKt48gvIFPSwR3L6Ya7MGEAu+UfWtyLs94iZhSHEzMaWsRtZNs2krpQqGSQvBYdUDYOe25XucJ/ZAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 09:58:14, Christoph Hellwig wrote:
> Bringing this back as we're having another slightly discussion of
> GUP semantics right now and this discussion stopped before it really
> started.
> 
> Any comments on my idea in here?  If someone on the mm side could
> come up with a way to figure out if a folio is pinned longterm or
> not and we get a pre-pin method into the fs I could start looking
> into the fs and writeback side of this.

I think we agree regarding the direction where this should be going :).
Regarding the tracking of longterm pins, I remember when we started working
of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
to take pinned pages off the LRU (they cannot be freed anyway) and use that
space in struct folio for the tracking we need. John? even had patches for
that but the performance overhead was too big (primarily due to LRU locks
contention) for direct IO. But for longterm pins, the additional overhead
of the setup could be acceptable and that would significantly increase our
maneuvering space in what we can do (because longterm pins are yet another
page refcount in the end).

								Honza
> 
> On Wed, Aug 26, 2026 at 07:07:33AM +0200, Christoph Hellwig wrote:
> > [adding rdma/hmm folks]
> > 
> > On Tue, Aug 25, 2026 at 08:54:25PM +0100, Matthew Wilcox wrote:
> > > On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > > > The problem is GUP.  We have no way to force the GUP caller to go
> > > > > through page_mkwrite again.  So instead we make the GUP caller call
> > > > > folio_mark_dirty_lock() which many just don't, and generally we get away
> > > > > with it.  But it's a bug, and a bad interface.
> > > > 
> > > > We currently have get_user_pages*() and pin_user_pages*(), where only
> > > > the pin_*() version is properly usable for write access, right? And
> > > > dropping such pins should always go through unpin_*() helpers?
> > > 
> > > Right.  I'm stuffing cheese into my ears and pretending that people
> > > aren't calling get_user_pages() to do write accesses.  We should be
> > > able to use this work to flush out the last remaining ones -- we
> > > can put in various assertions that folios should still be dirty where
> > > we currently have folio_mark_dirty() calls.
> > 
> > Last time I checked quite a few places still did.  Including various
> > network file system O_DIRECT implementations (some got fixed, and
> > for NFS a series is outstanding) and some really odd looking networking
> > code.
> > 
> > I wish we could somehow force them to stop doing that, but I can't
> > think of any. 
> > 
> > > Yes.  I think the only alternative would be storing a checksum of the
> > > contents of the folio and seeing if it changed since the last write.
> > > As you say, this is userspace doing something incredibly odd (I really
> > > don't think people make a habit of mmap()ing files shared writable and
> > > then giving RDMA longterm write accesses to them.  Not on machines with
> > > poor quality flash storage anyway).
> > > 
> > > Or we could say "these pages only get written back on requested fsync()
> > > rather than periodically".
> > 
> > Take one step back.  For regular pins we should be able to just wait for
> > them given that they are by definition short lived, where short lived
> > is defined by typical I/O latency for a wide range of "typical".
> > We'll need the right helpers from the MM for that, and make sure
> > we have a good way to debug file system hangs caused by incorrect
> > use of the pinning, but all that is a solvable problem.
> > Splitting read vs write pincounts would be really helpful to reduce
> > the overhead of that.
> > 
> > The interesting case is FOLL_LONGTERM, as it can pin I/O for a much
> > longer time.  And that also means IFF the user of FOLL_LONGTERM actually
> > wants to be able to persist data on a shared mmap, it has to manually
> > dirty folios one or more times during the FOLL_LONGTERM pin, because
> > otherwise the file system would never know there is dirty data.
> > The set_page_dirty call in ib_umem_odp_unmap_dma_pages is an example
> > for that.
> > 
> > So what we'll need is:
> > 
> >  - a way for the file system to know if a dma pin on a folio is for a
> >    short-term writable pin vs everything else.
> >  - for the short term writable pin wait for it for data integrity syncs,
> >    or otherwise just skip it.
> >  - for FOLL_LONGTERM users we need an interface to (re-dirty) folios
> >    while the long term pin persists.  This also needs a way for the
> >    file system to reserve space.  Either as a rolling / bank switched
> >    reservation for the whole life time of the mapping (although for
> >    large mappings this might use up a lot of space), or to do that
> >    ahead of whatever triggers the dirtying.
> >    And maybe a way for file systems (or vm ops) to reject long
> >    term writable pins if they don't want to deal with all this.
> ---end quoted text---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

