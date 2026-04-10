Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0A2E99069
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DE46B0005; Fri, 10 Apr 2026 05:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEC26B0089; Fri, 10 Apr 2026 05:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD966B008A; Fri, 10 Apr 2026 05:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED15E6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:54:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 627C25903D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:54:22 +0000 (UTC)
X-FDA: 84642185964.25.B131F7E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id F206910000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:54:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wsgz0iiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4nk6WwlQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wsgz0iiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4nk6WwlQ;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJVJtqdZtgjjDlnux/SZN8q+EWMmf2snhFNTfIvRit0=;
	b=IUl7tECZI3pty75Fv7lnfpQR/4NqMsuiBCsYDAJ1cI98As3wANf2oo7JBXdGniliI5uBZa
	Pdha3AB8VdQJ4zFfGMFN3kkcK6nU2yg/MyVZeCCbNXPmT/GCVoKDW8imJKSjXFarDPBFA4
	kq8TBNAHYizXOxMwKxI25wbnwjs4nA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814860; a=rsa-sha256;
	cv=none;
	b=4SZv62NwS8X6FHCcMvwECjejQqKQvFPFtmJVx8eyvY5PYW8AeufFnbN9C1I0jIMEbx1thP
	tpLYTzvYemy2PET328HO2GqfP3uqn4oN63SXzMa9qf8hB3iE0XntT7+zD7p5iBS6MAMxBx
	C6rOWXEXawgn8ETweVPdZIIET1Zt/SI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wsgz0iiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4nk6WwlQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wsgz0iiV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4nk6WwlQ;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25CE16A7E6;
	Fri, 10 Apr 2026 09:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775814858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJVJtqdZtgjjDlnux/SZN8q+EWMmf2snhFNTfIvRit0=;
	b=wsgz0iiVTIRu9hvCj+hTeOoO5aWRvJlLqgUYI1GktvxpU8dqjZHQK8G7mK3dT+L7IPs19E
	uh2NL6cRjkXR8kk3zdq22ozAT0FB9XQRD9Uk0iwdsWZ8TH0+4LpnJLfp0ugnK/veGPdF4t
	959iXA2/RZ7OaKeVXw3o+DS5Lb/KtB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775814858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJVJtqdZtgjjDlnux/SZN8q+EWMmf2snhFNTfIvRit0=;
	b=4nk6WwlQVRkFFBCY4spoKL+G4+fqAmXABFGfS+YgSgQN2uodtsQy623QKp8qQMQeF0qa7A
	1BcK7usAWYiDvJAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775814858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJVJtqdZtgjjDlnux/SZN8q+EWMmf2snhFNTfIvRit0=;
	b=wsgz0iiVTIRu9hvCj+hTeOoO5aWRvJlLqgUYI1GktvxpU8dqjZHQK8G7mK3dT+L7IPs19E
	uh2NL6cRjkXR8kk3zdq22ozAT0FB9XQRD9Uk0iwdsWZ8TH0+4LpnJLfp0ugnK/veGPdF4t
	959iXA2/RZ7OaKeVXw3o+DS5Lb/KtB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775814858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJVJtqdZtgjjDlnux/SZN8q+EWMmf2snhFNTfIvRit0=;
	b=4nk6WwlQVRkFFBCY4spoKL+G4+fqAmXABFGfS+YgSgQN2uodtsQy623QKp8qQMQeF0qa7A
	1BcK7usAWYiDvJAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C4D74A0B2;
	Fri, 10 Apr 2026 09:54:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HSDeBsnI2GnSVQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 09:54:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CA47BA0A81; Fri, 10 Apr 2026 11:54:16 +0200 (CEST)
Date: Fri, 10 Apr 2026 11:54:16 +0200
From: Jan Kara <jack@suse.cz>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org, Boris Burkov <boris@bur.io>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <cjuhfxstjtxcsygpnrxuyo7el23we6c3eaetaohuq62uat6iwk@yqdxghgf4vpc>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgYYt8LQqR+feSwqGccqD7Ns3sNgiVHw76mYsbKSwq5ng@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: bxe35ewzggycqdrzjztgy4ih96yzuqos
X-Rspamd-Queue-Id: F206910000B
X-Rspam-User: 
X-HE-Tag: 1775814859-671127
X-HE-Meta: U2FsdGVkX1+xOfNjC+9ttkHX0GTmDdF35jP7uT3Zb0sZSKWpA/YugvWhGWGSfd0Q+rqVCLM7suYR0ZGxGV6El/5Yzu2g0FVm/w35br3anOrngYX4UfjToeIAaAXKUIyYWl/BwUyAM3pnU5gGhrZbe38CZ0i4YIgxkrXvh+MHObEVKTm8ca0kd/IyiwKqnfJ3ijGcAgcanDe1UYrigdQzsTYzUTwQu4SDBAKTX+HdaHQmJZJOZuGcgCo+tyZTI7IEzIBupmtZfIeO4EmRNCZBClNn85Bp5zI7LcCKZEc9+IIgaQJXERLIZDNSTo34qbL7A9ySkcktutlJES7mncI5OqNmHJw/Erxp5GGtk0qvH2ieRkv02XYWwAKHX5jkiWVk/mib6NNfErYiUOFOKiGtinlMxVBnphFtpbz2uf8pNj9ms2/lWvm1h/9WhUWN0+1+5sULxrgzRE6m93OidKB7t2NUWy74ZIAPL5VjWF3A9R2j4lzWzP8mctoaMnWFBmsmWu79VpmzaBHyOMcj0a6w+gl9yUV9fMHyxJ1hB1vtJiRgRFkRxokoEGFI4So0hQ8Uvb3evpGO8tMaPHGlcEqw7xBDIQGsfc3xCOa0Al6cEZn7QG9GEhVs8bYO4xc64MeDNbfUcxYHtEZ5x53zPw9Ysm9R+7EObHjXigJX/8bnfJXM/87mYwJAfCnRXaQ397y18y/KbRCQ/ugO9D7HEhvqimLsN/GJeCu2GrBUkadITNL+Ia5eVfuLDTdbalOWatp9soaPABv0q5QLCx0rMx/z8n3jT9INY/C2WNtZp4PpBk9/lsCqQrDSWD6Fu7pI1/j/83C/3ghDkXhN5aCqW1BnSViux1XhFu/tZUGXRspatcWBHeiMNLNHjnXgcNso7Aid+ZODoFmaDvQ1buuOO/XP4ywEv8qmaaO3uSgjlXAIpC2kJy4BnhzVbrcDKw7u4SfXl6YXWs302Y6mHFKkQ10
 5yW3WRXN
 Vu92FFZqS8BH6iBqoNV4jdWATBA7UyRyR3JK6C2G6ld58Qh6nO9IWZ1VLZ4n5kla99UNjEtIYOza8ddH7ejvQDCLYNts+SH+6e//E6Ir2j1yuddBo0rgSykmphP0SuE5HVq5CKKilByQt7kSkctEvOhxEi0AtV6CWuu9SyNWZHMXY193JOi5n/BhMB14cRGTlcYgzOpWxCyK+kgIOMlxsMy3H3ltYVG9yZRC9k4xOSeB3FHfVuLcj1cwosMkSAfVVtmjGt1m58ZHdfo0Qq18dNvJx0vlNeODcrEr1kJwqTizumRH1lXFR07glWUXgAAfXQEAHUNpbpzqpPGJDbn1KEa2afUF1E0qJ4deoZNNfMuGdiDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 14:57:47, Amir Goldstein wrote:
> On Thu, Apr 9, 2026 at 11:17 AM Jan Kara <jack@suse.cz> wrote:
> > This is a recurring topic Matthew has been kicking forward for the last
> > year so let me maybe offer a fs-person point of view on the problem and
> > possible solutions. The problem is very simple: When a filesystem (ext4,
> > btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> > complex cleanup - like trimming of preallocated blocks beyond end of file,
> > making sure journalling machinery is done with the inode, etc.. This may
> > require reading metadata into memory which requires memory allocations and
> > as inode eviction cannot fail, these are effectively GFP_NOFAIL
> > allocations (and there are other reasons why it would be very difficult to
> > make some of these required allocations in the filesystems failable).
> >
> > GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> > trigger warnings - and for a good reason as forward progress isn't
> > guaranteed. Also it leaves a bad taste that we are performing sometimes
> > rather long running operations blocking on IO from reclaim context thus
> > stalling reclaim for substantial amount of time to free 1k worth of slab
> > cache.
> >
> > I have been mulling over possible solutions since I don't think each
> > filesystem should be inventing a complex inode lifetime management scheme
> > as XFS has invented to solve these issues. Here's what I think we could do:
> >
> > 1) Filesystems will be required to mark inodes that have non-trivial
> > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > whatever :)). Usually I expect this to happen on first inode modification
> > or so. This will require some per-fs work but it shouldn't be that
> > difficult and filesystems can be adapted one-by-one as they decide to
> > address these warnings from reclaim.
> >
> > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> > kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> > performance reasons. I expect this to be a significant portion of inodes
> > on average and in particular for some workloads which scan a lot of inodes
> > (find through the whole fs or similar) the efficiency of inode reclaim is
> > one of the determining factors for their performance.
> >
> > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> > to process them.
> >
> > 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> > inode, doing the hard work.
> >
> > This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> > and they can work on freeing memory needed for freeing of hard to reclaim
> > inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> > they should really be addressed.
> >
> > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > control for some workloads (in particular because there could be multiple
> > CPUs generating hard to reclaim inodes while the cleanup would be
> > single-threaded). This could be addressed by tracking number of inodes in
> > that list and if it grows over some limit, we could start throttling
> > processes when setting I_RECLAIM_HARD inode flag.
> >
> > There's also a simpler approach to this problem but with more radical
> > changes to behavior. For example getting rid of inode LRU completely -
> > inodes without dentries referencing them anymore should be rare and it
> > isn't very useful to cache them. So we can always drop inodes on last
> > iput() (as we currently do for example for unlinked inodes). But I have a
> > nagging feeling that somebody is depending on inode LRU somewhere - I'd
> > like poll the collective knowledge of what could possibly go wrong here :)
> >
> > In the session I'd like to discuss if people see some problems with these
> > approaches, what they'd prefer etc.
> 
> Is this expected to be a FS+MM session or only FS+Matthew?

I was thinking of FS+MM but if MM gets too crowded, we could do with MM +
Matthew. I think the problem lies mostly in fs land but it's good to get
some vetting from MM people that we aren't bending slab reclaim assumptions
too much...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

