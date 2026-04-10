Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19395E99071
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808C06B0089; Fri, 10 Apr 2026 06:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B94F6B0092; Fri, 10 Apr 2026 06:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8626B0093; Fri, 10 Apr 2026 06:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5471E6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:14:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0566FB99F6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:14:39 +0000 (UTC)
X-FDA: 84642237078.28.8A27492
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96EDD40016
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:14:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Whk/T0Jt";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d3pE0V1G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xtfrm//R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B2tjeK36;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775816077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FB+RnV89/37CNFnIW/6jx4C9HcTENMZLB0o6vivbJHw=;
	b=vFqw5K+W0YK2AqDTIP4lmM6XKebPricYxErNcZ9qDcNoNhee/JKqbSy1GAGil9EDartSHz
	17gxL28aLFTAIUU0JN7koJFbQore0Dxalv4MbroDXDFQqrx3Z7pFZdK2f16FPsavDHj0Hq
	YdmUjnRP7nPd2sfkr+CdGraH6X5yPss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775816077; a=rsa-sha256;
	cv=none;
	b=jUws0WHujYLhoHYFnuqhxp0JHCrUgz29/JoTJY+bIs3If2+xS1PCksIvZkbcr0EtD56uPF
	zRv+bHCat6jMRwLkhwxpCA7r05Bi889iOLJ3wOeZbliOFpaXOjUeqaGmfTvUKRjQc03rvW
	AWt2jm+nZdAuiGFwWnTkTm7CY4/m+ao=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Whk/T0Jt";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d3pE0V1G;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xtfrm//R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B2tjeK36;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4E5E6A7ED;
	Fri, 10 Apr 2026 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775816075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB+RnV89/37CNFnIW/6jx4C9HcTENMZLB0o6vivbJHw=;
	b=Whk/T0Jt2kL8zZgd28b5/dawxDtyeXnbtKt4/yU9/6KIxlzSXJMkZ6w/68PyhrrUpLsIwV
	wHEhjMdRgAmU7EHhv14P2taRd9ynHatQkoUp0TlxBli0H7l4CKil3zbN32/UcuUcuq+TZn
	qlGO0UG3qokgjFy7GbZlWbrn1hJ9Tyk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775816075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB+RnV89/37CNFnIW/6jx4C9HcTENMZLB0o6vivbJHw=;
	b=d3pE0V1Geu7hKi5JAB081R15zdWg9sR9NP71WaZqPXZ1SOZCU8thSD1aixFqQR/hI4e+o+
	wgg5rZ3VveMs1zCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775816074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB+RnV89/37CNFnIW/6jx4C9HcTENMZLB0o6vivbJHw=;
	b=xtfrm//RBCmhKmhb2JcJBTBBFXYMehTnUgRzoARP6NJiYC8AajGsCvh+tUA0yRAfg8HwFy
	aBajCyKACffeA1N6oVhuFqHTMsJWRnWzkwTvAFpVPYu6c+aYiA9uDTf29LwazLHbV3HqHv
	2x3EdvfkcrXw2n+Pi+7SJURkXtN+83Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775816074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FB+RnV89/37CNFnIW/6jx4C9HcTENMZLB0o6vivbJHw=;
	b=B2tjeK36uzy73fkyWsRDAew4RvcL1qPmpRF6iSlRw+N0hkPEe7jJD5YbmUhh3J9VEY2zQ6
	wfxfP816p13khQCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA4254A0B2;
	Fri, 10 Apr 2026 10:14:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +DJzLYrN2GlcagAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 10:14:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7BD09A0A81; Fri, 10 Apr 2026 12:14:30 +0200 (CEST)
Date: Fri, 10 Apr 2026 12:14:30 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <cvoy3vexgyxgyqghchpybluuvi4dvicbyjdodab5afqlmxe2yf@vgpzcmu6upri>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <20260410-anonym-freigaben-186946cb50e3@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410-anonym-freigaben-186946cb50e3@brauner>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 96EDD40016
X-Stat-Signature: uizkhtz9739kcbcg1ierfntk5wca5y9p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775816076-926800
X-HE-Meta: U2FsdGVkX18Ftmp977L9JqwPPDEeh1TKj1KbCvp2L0v6HCBW724FLFJ/Lu6acPCW0+KRk2KLqidq2qBC7C4E7Oje0gAt7lxbyiQ+HaTLIV0vwKs5lrPcyww2ELi95D9XJZc39bGEydqkREQm4b4NZko48AT/QsDUymSj4/iS8STsSPx8kJ9+46ZFbjIo0sRuE8wjiXks3hTyczuM3F+gIp1dunj0IaZFcs5dpXrRO/iDNa7hErewsako9Od26bWJ2peOAxta0h6t9fvbpIAW6rLcWvrLtx2kGLH6s2BCc+dLphfi2HAWYLunNnJFoEy4ZKGGiBJ3/ym+irVogRX0l2q/MAOZaFgyAfp/1Ctml362xzV0qU+d+Ta7RbHr793LeAISXS7xLNqXALmSpmQqJvFyEA5Ji6r1P/E9P6XIaSWUIt6W9J7jvJd1IJAqwJEGwyiu4xIomv8v5Jj6VIaREPsbXJPlH2Frk+Z81HFlJKQ1/reb89IA3JbbgAflg/EWHkxfh2F5UCCr0uv+10rVq9bEalIairk5jVoxB4aWm2cDdRzpz0sEIC4BSGxgdznNTBAnXJAxWE20nL20HfXsqMuBTWNTiZtP8rywibMFmfECu3L24bfmIypezbaZPrVhD/mImbvJ0qzhjazAIZX5z4NiJOR/VTlTBrCtpvh4v9B1eBU+jN8GXq5v20pIcQJyUK9stjAHub3c2n6GyC68sCoTZa6+pkzdFmdqjjyxH5kGmX9SwIcCocWU4jc/C7VeNBOyDbWPKNRtfnxGZCA7HHvHEwQQF/ed5q6Zlpf33yc68qFECWCtJSNIWkKjNYSGz13bH5p/05J/znKXuyvC2LneJ/1WncoxmQ7rIobU8tBNLY+eNA9C6oq46dbNNn7553o97LRJu6/tVNLb5dYwfBjZWE230KhzI3Na1d2ZbouqLZUQTyYF6GtBVfOE4XW2opqF2MAm97d+NKz8eXx
 dzy7/N3z
 h2CavZoMuZb3ittNWGNgBY6NOTSNUN1W2Qaktq3oIp4gurpVp5yj733qWr11PI1hs3R8cfNkdI9YBfkeUfJL0RNxWmvAkywGXTKWkGwNyvHX5kc4lT0GRkn8xdDnUBNwxtjCPpBhuRJivB5zqKAUoYxtdlUeUlX50ohVBJwGu3Q1IH3WO6QhW7hIxSc683miAOMJjMVKhc4defFTuhtppipHzvf4wONqDvey7ihzHrgal9/pJBjeRnOwxmpj19cXiAIEa3B2tQ3HZKvX9mky8HbJonq4AQyXSNaH4ux7ar81Ul6ai1uo3byQbp7DI+vKbzC1W4QXz3fuK6fXP9oOMsHhevg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello!

On Fri 10-04-26 11:23:26, Christian Brauner wrote:
> On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
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
> 
> I like this approach.
> 
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
> 
> Hm, I don't know with WQ_UNBOUND is that really a concern?

I planned to have a single work item processing the inodes which means
single CPU cleaning the list even with WQ_UNBOUND. And MM folks tend to be
cautious about these pathological scenarios where all your reclaimable
memory is filled with hard to reclaim objects (dirty pages are prime
example we have solved long ago but dirty / hard to reclaim inodes aren't
really different). I'm definitely open to postponing the throttling part
for later if people are willing to try.

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
> 
> I still think we should try this - for the reduced maintenance cost
> alone. Imagine living in a world where there aren't 2 different LRUs
> constantly battling for review attention..
> 
> I'm split here but depending on the size of the actual work needed to
> make this happen we should at least be open to try this.

I'd love to but as Jeff points out, at least NFS depends on inode LRU today
so we'd have to come up with some way to avoid purging all files from NFS
directory from cache on revalidate events. And I don't see a simple
solution for that...

								Honza
--
Jan Kara <jack@suse.com>
SUSE Labs, CR

