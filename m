Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF269F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FCFB6B0005; Thu, 16 Apr 2026 06:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD466B0089; Thu, 16 Apr 2026 06:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AF76B008A; Thu, 16 Apr 2026 06:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18F6E6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:07:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE5CC8C468
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:07:04 +0000 (UTC)
X-FDA: 84663990768.11.CA551F0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4498E20003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:07:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXpXxFXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qGDlrHWQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXpXxFXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qGDlrHWQ;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776334022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EcHaRDCO2TcdZgOqKy9Dp05VXuFoot2xbmnN3s5lDQ=;
	b=ZguaZkT1jux2j5ydm01OP62i+ZQoo2w3WspPyRZZovWmpsRbhwT5IiELlFmcGxDUX/VLmq
	MiSMR3WssY8iNpwPXJR+ZVwSkgiOowGKFq2nqhWf1MO3vrw8Ce7WDlwE6P1UWluW6GLoO3
	HfQx9xDo8Jerm8tcAU3zNv5szWUjGP8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXpXxFXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qGDlrHWQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXpXxFXa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qGDlrHWQ;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776334022; a=rsa-sha256;
	cv=none;
	b=8bCgwnzh6lnzoP/d5fiiCdxG8Yo4lvXlzViigBIeRf9c0Q70vZ5/ECm/a65SowgQu5oazt
	bccDTWL82PmNK9he+x4lWmJJX2MWcBevXuA6/9yVV/YX/qm/3kFDdswqXmvEZ4LKgqkWB1
	gxXguVqCZ1dFI9AckSAnpHI+gEw86DQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 60D995BD0D;
	Thu, 16 Apr 2026 10:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776334020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9EcHaRDCO2TcdZgOqKy9Dp05VXuFoot2xbmnN3s5lDQ=;
	b=MXpXxFXat3UOoSmGM/b3+Bgt9jmwiutz/pPbSew2EMc7ms0u/JXL7fKtg5GctcBNoncP60
	enSZz8B/16v3plAqj32IE1LkMgoRF6ZR5CP1yPdAUkGyEzz9BD65NKxMDaR74XGqMWf4XY
	iGVdy4jCZI0UhnHM5Q6acBsRNSA+wac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776334020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9EcHaRDCO2TcdZgOqKy9Dp05VXuFoot2xbmnN3s5lDQ=;
	b=qGDlrHWQzMhEwBF6SinNUqWu99CbZzD4HorExPel7Ayutr2kcRZHGkl9Nw+LmKQK4J7Bts
	L93HHcJEZdJ8EkCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776334020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9EcHaRDCO2TcdZgOqKy9Dp05VXuFoot2xbmnN3s5lDQ=;
	b=MXpXxFXat3UOoSmGM/b3+Bgt9jmwiutz/pPbSew2EMc7ms0u/JXL7fKtg5GctcBNoncP60
	enSZz8B/16v3plAqj32IE1LkMgoRF6ZR5CP1yPdAUkGyEzz9BD65NKxMDaR74XGqMWf4XY
	iGVdy4jCZI0UhnHM5Q6acBsRNSA+wac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776334020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9EcHaRDCO2TcdZgOqKy9Dp05VXuFoot2xbmnN3s5lDQ=;
	b=qGDlrHWQzMhEwBF6SinNUqWu99CbZzD4HorExPel7Ayutr2kcRZHGkl9Nw+LmKQK4J7Bts
	L93HHcJEZdJ8EkCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4980F4BEDD;
	Thu, 16 Apr 2026 10:07:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DbbtEcS04GnvEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 16 Apr 2026 10:07:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04507A0B30; Thu, 16 Apr 2026 12:06:59 +0200 (CEST)
Date: Thu, 16 Apr 2026 12:06:59 +0200
From: Jan Kara <jack@suse.cz>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <i67kqas5wx2a25tzoleygwpeyunx6ovvf3t2e25yab3myxbazh@h7hctwxddhq4>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <ad1QfUWEPSCDUDYv@linux.dev>
 <z6m4h2yamlckbyzh2ey2ixa7t7s6hlzg5jcle4qyebkopkvujw@pcrzrkuycg4g>
 <ad_Eo7iQVT-HUkx1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad_Eo7iQVT-HUkx1@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4498E20003
X-Stat-Signature: jgtakhpkgzumwqugr98st9chd8s9tabw
X-Rspam-User: 
X-HE-Tag: 1776334022-732553
X-HE-Meta: U2FsdGVkX1/sfy+rqbiPjyKCX3Ow0wk3i+LUV5VSCGbl/DqqZgBFXp0GTPuHNmpYyIcofgWEIrTU4DHYOLone2ezs4qUrC0jXtmJss2Nz6UPpcb5k2JTPros1/l+/k9tP0RM2hzP1j6GB4HVxX1Nqwa94+C1bQVTajDkpzY4UsQAUkURM7dfU/gK6iEIKz0OBQsjq6hTVQ0zTZsd3KqZUQ04Bg+U7Nd24miykt+zXhRxkcX0V4zNYcFg16mkr6diWIcAxoDO5kuC8b2Ls1W6itSNnzHT2ScqcJPPERgRcc8/nIrkzvt1JK8b+EoagDdAaGYi07ZBRtWP7NDtmbuHa/spneAsDW0NiqNrnlEkjuYuY6G3TFtOdSmYCuV7Ul3JGx8YVAuaLDpUhy0N4rnU0DgQJIg7cylE+LXMtFqc3WCeyW2mSdi2AKd5wdh7qqp5H7VifLM+8DUwCBlyDKCU0dyzKdMelkVa458XDiGRInjeefv5q9240KTdVa5U46uz3XQDM7GXxSwViFneMfoFWrWiLdWur64AVXV7J4sfPEiRh8fR0+QM6dp7LmRhgSjgdTM8fKKmRWCq92O+IZeR0kAcMaMbKTnmZilY/cTaKIZ604Ih1gS8L3BXmCuua6WPpn19lG70EWP63AW4yecR2CEWZUQwOSl347RkbEzL4MFJO/jAiRaUZgsLLT1B0zl1kVoVgBn6ysL/6pEZ3zDvERBPHKW5Jv7glRwxROxysMq4+V9pxuh9amYM+3RXy4DAtr4LlTc//I3p01+7mCo+OHT/RnKsXfebTZ2zTPgc45D/UHy8GN/tBhyivV2OrBC65Rn6zYTFvgEDfDN8FuTDjkPH/S0n6sco/KD4whsiXz+mR+7pNiz/9/EyiiHTFCBoanONTEUL/ZxtFcYRxLjL9iUpSfGE6xKU6Xhd3y1BRL7L37J1XonjV0AT81MxbT6JnE1F/LdDH9VCRbf7W+u
 wS+sRP5+
 CPg40IJmX93Lio7w0JMsYwmaOcVnwNiEbsZp1aRGou4D88Ba7h/ptZ5iBNiQhAP32IITJP3qznoBhrdwqmGot9U6t2MRnRcSnsxqjlFBJ3tj0KPNr6TUnCShDlUjt71eFOY4myyUNa90rPN3+reSpAs/des+hZkdgHUYCAuFT7oz9ZQuaeKn02N0FH2EwzVE6rhE1vmj4rfnW9VuBr9UvRqryISagsiVCO8As5vI5WkYS/fhaivYK2mFtn9l4wNUO1cx4gufNb3ppMkmNkgUgGa4WXwXv2VQxaPrJBU00C376B89OxC5bShBE5rkOYca800uoH0qCFEH1MvTQD4cMejQ/zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 15-04-26 10:45:11, Shakeel Butt wrote:
> On Tue, Apr 14, 2026 at 11:15:48AM +0200, Jan Kara wrote:
> > > > I have been mulling over possible solutions since I don't think each
> > > > filesystem should be inventing a complex inode lifetime management scheme
> > > > as XFS has invented to solve these issues. Here's what I think we could do:
> > > > 
> > > > 1) Filesystems will be required to mark inodes that have non-trivial
> > > > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > > > whatever :)). Usually I expect this to happen on first inode modification
> > > > or so. This will require some per-fs work but it shouldn't be that
> > > > difficult and filesystems can be adapted one-by-one as they decide to
> > > > address these warnings from reclaim.
> > > > 
> > > > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > > > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > > > performance reasons. I expect this to be a significant portion of inodes
> > > > on average and in particular for some workloads which scan a lot of inodes
> > > > (find through the whole fs or similar) the efficiency of inode reclaim is
> > > > one of the determining factors for their performance.
> > > > 
> > > > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > > > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > > > to process them.
> > > 
> > > This async worker is an interesting idea. I have been brain-storming for similar
> > > problems and I was going towards more kswapds or async/background reclaimers and
> > > such reclaimers can do more intensive cleanup work. Basically aim to avoid
> > > direct reclaimers as much as possible.
> > 
> > So similarly as we eventually moved direct page writeback from kswapd
> > reclaim, I think it makes sense to remove difficult inode reclaim from
> > kswapd as well. In particular because I think such separation makes it
> > clearer that while you do complex inode reclaim and allocate memory from
> > there, there's still kswapd that can free some memory for you to make
> > forward progress. And you better need to be sure that there's enough "easy
> > to free" memory to allow for forward progress of difficult reclaim.
> 
> Another important point that we need memory guarantee for forward progress of
> the difficult reclaim.

Yes, although I don't expect we can get it in a direct way (we have only
very vague idea how much memory is needed for reclaiming such inodes) but
just by making sure the amount of hard to reclaim inodes cannot grow too much.

> > > > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > > > inode, doing the hard work.
> > > > 
> > > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > > > and they can work on freeing memory needed for freeing of hard to reclaim
> > > > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > > > they should really be addressed.
> > > > 
> > > > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > > > control for some workloads (in particular because there could be multiple
> > > > CPUs generating hard to reclaim inodes while the cleanup would be
> > > > single-threaded).
> > > 
> > > Why single-threaded? What will be the issue to have multiple such workers
> > > doing independent cleanups? Also these workers will need memory
> > > guarantees as well (something like PF_MEMALLOC) to not cause their
> > > allocations stuck in reclaim.
> > 
> > Well, single-threaded isn't a requirement but in the beginning I plan to do
> > it like that for simplicity similarly as currently there's only one flush
> > work doing writeback (although we are just discussing moving to more for
> > that). Also the inode cleanup will contend on fs-wide resources such as
> > journal so although some scaling can bring you benefits it will be
> > difficult to scale beyond certain limits (again heavily fs dependent).
> 
> Difficult reclaim uses fs-wide resources (and locks) and thus we can not
> depend on it to be effective under extreme memory pressure, right?

Correct.

> Or do we want it to be reliable under extreme memory pressure where we
> will need to provide memory and cpu guarantees to it?

At least I don't have that expectation :)

> One more question, I assume it is fs-dependent but is it possible to avoid
> allocations (and thus reclaim) under fs-wide locks? One challenge/issue we at
> Meta are seeing is (btrfs) lock holders getting stuck in reclaim causing
> isolation issues.

I don't think it is practically feasible. Often before you acquire locks
and start working, you don't know how much memory you'll need. For simple
operations you can go with worst case estimates and preallocation before
acquiring locks (like we do e.g. with radix tree manipulations) but for
complex mutations of data structures involving journalling etc. it isn't
really practical anymore - too much code to execute, too many possibilities
to consider, too many interactions with other parts of the system.

I understand the priority inversion issues that are arising from this for
memcg reclaim. But I think the "measure now and punish later" model that is
used e.g. for dirty page throttling or blk-iocost throttling of metadata IO
is an approach which has much higher chances of success than trying to move
the allocations out of locks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

