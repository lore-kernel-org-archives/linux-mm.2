Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2D3E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DF46B0088; Wed, 18 Feb 2026 12:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955DA6B0089; Wed, 18 Feb 2026 12:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854A36B008A; Wed, 18 Feb 2026 12:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFE96B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:37:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 141881A0168
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:37:54 +0000 (UTC)
X-FDA: 84458285268.13.DB9C4CB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF73714000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:37:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chjdh5XH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8FLJRHIA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LpDGGDTw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zBV5uAub;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771436272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiZMR2ATXrpcVfWnnpGxqgw91jILZgAAnYQZEzfr0rU=;
	b=zlxQq454srQE9NLwyUm9+m6UqsKFyzkCjjvLv6MTcluuRdtaYJkW38pbKfXdDM8EJy6zoC
	gS61fJADOqLPW2QRXLZzd+MHBj2PKWEv7QDs0lJp6UCW0y7eVdXuJlG8ncUI5ClkSvhyH4
	jmyF/Oc+2XLT5biTXI6qUH5jfpkK9ao=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chjdh5XH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8FLJRHIA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LpDGGDTw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zBV5uAub;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771436272; a=rsa-sha256;
	cv=none;
	b=Ixcw92dM6PCskswhkJUrca3bqXpOnYp9zyw9afs8QrOODKl1vNoUuFCv0sacaYNkbbjTck
	UhxK17dT+1DUwyDfGIdbAvinI+n9xiMSk5ntnUlaar8hw0xbCFOXj6oTEpLS3dINsq8lN/
	3SItT8RWWiF0xRylFw+D2jmJ3fLo+60=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DAF533E6D4;
	Wed, 18 Feb 2026 17:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KiZMR2ATXrpcVfWnnpGxqgw91jILZgAAnYQZEzfr0rU=;
	b=chjdh5XHQ+spZBLzRoayZvH6v3WCn9Eh7IwU1q7gx5e2Ktw0hr9RCIvNZDkdRD01Tg12z1
	z5ACcsrgXLSZnOVdiEYiwoY1NaUMAUuG2CUTxuC42+WFxXtadrNkb0w1PAbJnfKbvsYnju
	lU115Yrm+Syi3d5vKeOjFJXTsemsKhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KiZMR2ATXrpcVfWnnpGxqgw91jILZgAAnYQZEzfr0rU=;
	b=8FLJRHIAucgH0EEOwmbJ+dxSNSPw1CIvtLVWU9j+/afBiV/Duq/SRGWidsB582/a9fZkgB
	6UjbSABipwpw34Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771436269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KiZMR2ATXrpcVfWnnpGxqgw91jILZgAAnYQZEzfr0rU=;
	b=LpDGGDTwuOY9t6+AZxVmD5Mj+fPPuD/AFbECH5A9xW/tCjPbDDtnhWeQNBdHdL0CbuaPWY
	pteqfXfNJ7rXCIdglDBGZk/jba07QkBygebUoZcq/6ZogWMi3xTV81a+ypv+eWv5713m+y
	McJNc/rPVvvMDN3L6Db8XfKf4WFrd5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771436269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KiZMR2ATXrpcVfWnnpGxqgw91jILZgAAnYQZEzfr0rU=;
	b=zBV5uAubWbzcySDYHmKue/ElL13lBzL4CztINAngAwBuduN9S4FoRYJqsydV74Njz4a+Yd
	md66EnPx1s8caKBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2F3F3EA65;
	Wed, 18 Feb 2026 17:37:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pL+RL+34lWnXaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Feb 2026 17:37:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6AE5FA08CF; Wed, 18 Feb 2026 18:37:45 +0100 (CET)
Date: Wed, 18 Feb 2026 18:37:45 +0100
From: Jan Kara <jack@suse.cz>
To: Andres Freund <andres@anarazel.de>
Cc: Jan Kara <jack@suse.cz>, Pankaj Raghav <pankaj.raghav@linux.dev>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, djwong@kernel.org, 
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, ritesh.list@gmail.com, 
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>, 
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <umq2nlgxqp4xbrp23zjiajwd6ombed4dfwbajuh35xd4vphyee@26g2y6a4rdnu>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <2planlrvjqicgpparsdhxipfdoawtzq3tedql72hoff4pdet6t@btxbx6cpoyc6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2planlrvjqicgpparsdhxipfdoawtzq3tedql72hoff4pdet6t@btxbx6cpoyc6>
X-Stat-Signature: ccxneshsamprb9s7w6aqno1gcjpencca
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: BF73714000A
X-HE-Tag: 1771436271-404905
X-HE-Meta: U2FsdGVkX19oic1fLEdcTxi5lqc3fXs4PyeWUNcNgml4sUsomJCJniuvrB/DtOoIwt8CdJS9Z0vzAaVfFxNhHUC5pgEm5wrNRNYehWe9pGOyCzOGARmOjRBhra3rPOMSyQIikFLICwtmBrBX6U7vgUkk6W3OhLL02dQHPiz5yQPX6XhEbYkC5o0LB62HAD1GiU9oDmbDffqT5bRdknThGceVt2VSRK+ge4vUSqweWLodIvdbthmT/G77cWNNKsMoaVMmN13daUgbFe40zMogCCHaR0Yqxu2t818jiWEMrp4F9oz3SQYWNsu2BoX+5Md6/7pTPtCXLcZG10yzzl15Cv27fdFPoMM/Fv90eWKYm8p2Qoa+FX4wkJieYDXaOJAe7UXK2l9Vwkgqx78IHGvGjhSiOTBOV1PuYWFqAKujKxSyurlGKNTUZNmCzKqQRQCvsDr/UHwFRt6Ourbre4kYfP1fKEIE4iEjJjT1J1fVuH/Sck05/ACFsW4kCK7FU3NAZbb15HXmn6PUEdXQu42aw675wrE1vbTYFfEKfl+tYiliSLk4IqCClCNSM5TEmGRbeHi9bBEpIo1ghcYGGPgL3ZREL7BkhkA/V2lu66pouJdDqjflvBmakDsJANf+5yV8P7l7MWxBwEImR8Wlu+1I7Y7BeoKyCXUTSy/6uZJajNwTr4xmp2wakoCymzpDsGbh7rL30qdUNvWZMzTN6rrWldtqVfAssb/Tb5R/7topqsFaQVKy7RpdAnREDNi8bBeKGCha0x4Pn02IhQvPEHB5PjFQawtwBZorU2xlIuyUnmLCccbsWbr8plvCosjfS1tbqtIfLZyTtzb0MmP4rjFOT3MYXizmSJ0lmcIoB3i6z8x7zFNL8ls5EXDm/RnQgeWCDilRFG5nGWOc7sCOqRHzkGpFnYsXuOG0nNT4olDFpRnMvQW1GrpnoPS5gGmvNy8FvHksjrv8r6y0cQ+vNYT
 R6hkPL7o
 xjvq+TZUL3zgynUoW6u70rXBeNHHn63lQoEofAJe2FPyIBHwj+q3BAlKrr7TZa2U3QQxgDHIz0IYxhOR2Ed78f1PjgD4HQIVTa5c4xb1LrJfvEYKeLaaE75v2KH5HfXHn83b513XUc8fVvpt0fKQZ8DtB13NnEvJxstWrWPYtpGXT4s6/sS+Glrv84xzqjNqgx7WOXvk7L8MaqXepg8UxeFvOYAzn6RCJCLj4DKnTfwykwjmtAkNIxBom+JGgi2+lg+qRejnbxqvQcwQLNa2hWkqwkyGGhArBmTsoKelEX3jRFYRAQ/aTDaSfvVZm6mbouYqBwkS/FJab8uhcEGev90oIyMMOUizTRsSatkPCFTtfcNVw7JW/tnECAtZ08k8UAKSswYyD5a+PK15NCYNjBgUncbrME3xMG4Zg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-02-26 11:13:07, Andres Freund wrote:
> > > P1: pwritev(fd, [blocks 1-10], RWF_ATOMIC) start & completes
> > > Kernel: starts writeback but doesn't complete it
> > > P1: pwrite(fd, [any block in 1-10]), non-atomically
> > > Kernel: completes writeback
> > >
> > > The former is not at all an issue for postgres' use case, the pages in
> > > our buffer pool that are undergoing IO are locked, preventing additional
> > > IO (be it reads or writes) to those blocks.
> > >
> > > The latter would be a problem, since userspace wouldn't even know that
> > > here is still "atomic writeback" going on, afaict the only way we could
> > > avoid it would be to issue an f[data]sync(), which likely would be
> > > prohibitively expensive.
> >
> > It somewhat depends on what outcome you expect in terms of crash safety :)
> > Unless we are careful, the RWF_ATOMIC write in your latter example can end
> > up writing some bits of the data from the second write because the second
> > write may be copying data to the pages as we issue DMA from them to the
> > device.
> 
> Hm. It's somewhat painful to not know when we can write in what mode again -
> with DIO that's not an issue. I guess we could use
> sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) if we really needed to know?
> Although the semantics of the SFR flags aren't particularly clear, so maybe
> not?

If you used RWF_WRITETHROUGH for your writes (so you are sure IO has
already started) then sync_file_range(SYNC_FILE_RANGE_WAIT_BEFORE) would
indeed be a safe way of waiting for that IO to complete (or just wait for
the write(2) syscall itself to complete if we make RWF_WRITETHROUGH wait
for IO completion as Dave suggests - but I guess writes may happen from
multiple threads so that may be not very convenient and sync_file_range(2)
might be actually easier).

> > I expect this isn't really acceptable because if you crash before
> > the second write fully makes it to the disk, you will have inconsistent
> > data.
> 
> The scenarios that I can think that would lead us to doing something like
> this, are when we are overwriting data without regard for the prior contents,
> e.g:
> 
> An already partially filled page is filled with more rows, we write that page
> out, then all the rows are deleted, and we re-fill the page with new content
> from scratch. Write it out again.  With our existing logic we treat the second
> write differently, because the entire contents of the page will be in the
> journal, as there is no prior content that we care about.
> 
> A second scenario in which we might not use RWF_ATOMIC, if we carry today's
> logic forward, is if a newly created relation is bulk loaded in the same
> transaction that created the relation. If a crash were to happen while that
> bulk load is ongoing, we don't care about the contents of the file(s), as it
> will never be visible to anyone after crash recovery.  In this case we won't
> have prio RWF_ATOMIC writes - but we could have the opposite, i.e. an
> RWF_ATOMIC write while there already is non-RWF_ATOMIC dirty data in the page
> cache. Would that be an issue?

No, this should be fine. But as I'm thinking about it what seems the most
natural is that RWF_WRITETHROUGH writes will wait on any pages under
writeback in the target range before proceeding with the write. That will
give user proper serialization with other RWF_WRITETHROUGH writes to the
overlapping range as well as writeback from previous normal writes. So the
only case that needs handling - either by userspace or kernel forcing
stable writes - would be RWF_WRITETHROUGH write followed by a normal write.

> It's possible we should just always use RWF_ATOMIC, even in the cases where
> it's not needed from our side, to avoid potential performance penalties and
> "undefined behaviour".  I guess that will really depend on the performance
> penalty that RWF_ATOMIC will carry and whether multiple-atomicity-mode will
> eventually be supported (as doing small writes during bulk loading is quite
> expensive).

Sure, that's a possibility as well. I guess it requires some
experimentation and benchmarking to pick a proper tradeoff.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

