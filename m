Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42124E99069
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E25B6B0005; Fri, 10 Apr 2026 06:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692C46B0089; Fri, 10 Apr 2026 06:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582116B008A; Fri, 10 Apr 2026 06:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8966B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:00:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA5F413AF80
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:00:46 +0000 (UTC)
X-FDA: 84642202092.23.EA26D21
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A3F9C0012
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:00:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YByLtiwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EXhnDdlj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QGqRXNQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K9uWVvbp;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775815244; a=rsa-sha256;
	cv=none;
	b=Fx8rXq3EwsQ/Q1Z+CSkK9btBaQKWA17eCVAkBZpn9wN7pswSMNoOZi67FIxb0CP44ilcoB
	cTOKfXRLsaTpTra9WJn8ARiMfT0+1mHvbe+Q9VUKHPeSJkOUdyDrowjkPJsmqfvDJ/2WW+
	O+YX7vnIol5qBwbT5B5CuozH7XIxq94=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YByLtiwe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EXhnDdlj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QGqRXNQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K9uWVvbp;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775815244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkfVDK9m2+79hoSwUpq2JOOIVAKK+qSsxl7RUf+4B3A=;
	b=r6sHBCGH6uHSNQ0nVKVore/HKL6coowENIGU/d8XdSx1Ja0cjZLlUVK05KU6xvvspbDyYt
	qiwETPJpKsdUNS+anlhvNCc+BdPPsWGQgKUH/OF33LjPcEbHgFnI0/jolmq9MIVSIINkv4
	9yOUta/cn2E+mPeX+Od27tHwTV4D3qk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12B046A7EA;
	Fri, 10 Apr 2026 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775815242; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkfVDK9m2+79hoSwUpq2JOOIVAKK+qSsxl7RUf+4B3A=;
	b=YByLtiweH28ueinQh4cOraL1Tga5KFCAlFD5jqBnR3noOVyYgzvBvAj38lSQx9dpR5eSHZ
	HjqyvC5maBcHMVwWxrHo44no5mw73Ri00g7MiAWwtsyg6S5G/ZWtTGwr5c+kpT+NLeH0m/
	s7d3ZMoZjOFN6/jfmy71t8RwGBzoIfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775815242;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkfVDK9m2+79hoSwUpq2JOOIVAKK+qSsxl7RUf+4B3A=;
	b=EXhnDdljyxynm7L8VIMO/zaek/RsmlohwURNe50heC8RI18nrkG3rL1UeAcIZ5mNf+EDJA
	+FrZewPx/VuCXkAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775815241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkfVDK9m2+79hoSwUpq2JOOIVAKK+qSsxl7RUf+4B3A=;
	b=QGqRXNQEqeQK54c+iWpzvuaPLbHea83I7jsnR2wyD7x3iyOEc8kS++hzUVTCXMGlMEdKMx
	WjQwFyc/CsLkiO6Om80jbut5dP38y+UHyWMhu50/1l/IhqAHvVEb9O5i8Ndln1oq41AQBt
	+14urth4otxagawg8WGYotjtzqjeh8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775815241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mkfVDK9m2+79hoSwUpq2JOOIVAKK+qSsxl7RUf+4B3A=;
	b=K9uWVvbpHyrDD48RRwxvErv6aucdFyrETF3aNk/Je3GKGFCzAWBubta5L49rJlgVOLdU1V
	hDT+/sl2AAHtpvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 087DE4A0B2;
	Fri, 10 Apr 2026 10:00:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sywSAknK2GmMXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 10:00:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BA687A0A81; Fri, 10 Apr 2026 12:00:40 +0200 (CEST)
Date: Fri, 10 Apr 2026 12:00:40 +0200
From: Jan Kara <jack@suse.cz>
To: Boris Burkov <boris@bur.io>
Cc: Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <ialh7bznacamw6ogfwniawtz577t3xo2mqgcjaweashqhs3ijf@jebgxzy42zqd>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
 <20260409164834.GA3472346@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260409164834.GA3472346@zen.localdomain>
X-Rspamd-Action: no action
X-Stat-Signature: w6uqtqqyqfjfawb3ddkk8nargeskmh1f
X-Rspamd-Queue-Id: 0A3F9C0012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775815243-853575
X-HE-Meta: U2FsdGVkX181CV5WWsr35LWh/pOTuXYpwvtuBe5CGcb4Nxo7jnz1bToDKFAbwIrhSaKc5nFS6ZtRokukuT6rLFI2lhC5trgy8VqxTc1PSHOkj0VR/JwgAoqCnibLtgAvK39/WYkyLy+LQbU4yq7dBUbMzT7aRGlZGFKYiw2WR4GEzszqXl4bxX6RUDG0B0c6tK+A3VDYo/yD/oeuWbd4b0+m5yAYRtOwaHj2DIsdE0ZwKqCPrquKK1O6a8vn4kmWmsMg7XP03nSWDlQeNDLH2YSbtKOWyn+44dM3b0rOhc7p8JbtvkH9ORtB7wBr9OrNymoucXHtiDz5tcGUPIVcC/hdbqJkAxsG/Qyh5TYFB9Ht4ydCdBbiM0k6Z8JSxhR+N1yQZaFg3OXVp8crI2jyM5wxf9Z76cu0jYErY1oBaUO0iytwOORWf9hTWqVDrPM9avfOgAMw1fmsx8pBYs00226BtxCLALe4VfzdR8jNdxnsWRl2Qs+VRORjGM/4CrUJazvw34MH196vDG+W5X+j+MXJWwx6ZJRegLfK36mdXimeodpOasFcf2/cqL2pLZnJ9ARVzELVQkmuBaNAUzeVeJGsBY+xIB4qcYoUAdHM6MTu5tfoJkTzXihZNZpIurzdS0FyJ+Q8mJl4X7/s1XF8gJvMBp/zrhtAkWnbGcOMRkYq0FbcOp+v2h0uUbv1lf2iH2+vymZrt4NNmGL0FPkeI1VdpqbsP/EsOo/qXa89bqhpUa/o9pGZJ3+bHCx4Y5DXhGruEme38Si4HOkO8apWoKtsOnzTUTTuNNRcX/KnXekUNGAqR4INCHOmieOCQRJ6a8igAsd/prAWdW+Iumjuo64boTXgYm30QERRHh5umzYxazX1EzpWoHOGaPiGGRt44zh3WKmRS9VSrFnBCwcuIt/9CIKBf6qAfX41Y75cx0zLuX/BfLBt8xnAjaIcr/iR09cTFLPvb3FyaiCAWxU
 ryzqv8cK
 8CfsYbjpH34L9QRJFNj/R/EO2MQxQNWu2uPK4cM+JnauDU5dWsrS7iwyIOR2pPj+9QCWKaxP96+B9xTQ1c4m5g9G5LDCFyLyuZPuIZB+Xr9Gb5vSaUDApQgqhGhRGXGXhNnKvYyAdJrWTrkjlHFW0Z+MOZHc2nmnxvXaionJSoX5VGdbOhWI479n4FE+SHPBXnsgkZCNIS3+/itTREBaohDVaQngVJon0IyIfXw7JQxD2KhTtMOmKvhu2Xxlo16uKSUUEIqqH42GSiU7X+pybYgXIHpWDF/olgwMpk+KNSrN/+qRODkJKEcTJPpqc/n6aDXrxfDo6mffZmI+qKr/IRaDdEN9X8Bsxwh300WJWwjASi7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 09:48:34, Boris Burkov wrote:
> On Thu, Apr 09, 2026 at 02:57:47PM +0200, Amir Goldstein wrote:
> > On Thu, Apr 9, 2026 at 11:17 AM Jan Kara <jack@suse.cz> wrote:
> > > This is a recurring topic Matthew has been kicking forward for the last
> > > year so let me maybe offer a fs-person point of view on the problem and
> > > possible solutions. The problem is very simple: When a filesystem (ext4,
> > > btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> > > complex cleanup - like trimming of preallocated blocks beyond end of file,
> > > making sure journalling machinery is done with the inode, etc.. This may
> > > require reading metadata into memory which requires memory allocations and
> > > as inode eviction cannot fail, these are effectively GFP_NOFAIL
> > > allocations (and there are other reasons why it would be very difficult to
> > > make some of these required allocations in the filesystems failable).
> > >
> > > GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> > > trigger warnings - and for a good reason as forward progress isn't
> > > guaranteed. Also it leaves a bad taste that we are performing sometimes
> > > rather long running operations blocking on IO from reclaim context thus
> > > stalling reclaim for substantial amount of time to free 1k worth of slab
> > > cache.
> > >
> > > I have been mulling over possible solutions since I don't think each
> > > filesystem should be inventing a complex inode lifetime management scheme
> > > as XFS has invented to solve these issues. Here's what I think we could do:
> > >
> > > 1) Filesystems will be required to mark inodes that have non-trivial
> > > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > > whatever :)). Usually I expect this to happen on first inode modification
> > > or so. This will require some per-fs work but it shouldn't be that
> > > difficult and filesystems can be adapted one-by-one as they decide to
> > > address these warnings from reclaim.
> > >
> > > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > > performance reasons. I expect this to be a significant portion of inodes
> > > on average and in particular for some workloads which scan a lot of inodes
> > > (find through the whole fs or similar) the efficiency of inode reclaim is
> > > one of the determining factors for their performance.
> > >
> > > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > > to process them.
> > >
> > > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > > inode, doing the hard work.
> > >
> > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > > and they can work on freeing memory needed for freeing of hard to reclaim
> > > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > > they should really be addressed.
> 
> One question that pops in my mind (which is similar to an issue you and
> Qu debugged with the btrfs metadata reclaim floor earlier this year) is:
> what if the hard to reclaim inodes are the *only* source of significant 
> reclaimable space?

Then we are effectively deadlocked on ENOMEM. That's why I think we'll have
to put some throttling on the creation of hard to reclaim inodes so that
they cannot grow out of control.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

