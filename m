Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B20E99065
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFA56B0005; Fri, 10 Apr 2026 05:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170496B0089; Fri, 10 Apr 2026 05:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F646B008A; Fri, 10 Apr 2026 05:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6D406B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:43:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EFC313AEEC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:43:44 +0000 (UTC)
X-FDA: 84642159168.24.62E5A7D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39726C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:43:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xtNaBOLy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n7kK1FXc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xtNaBOLy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n7kK1FXc;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775814222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQWqa1s/8lhEUAwETf6ZaQiJm59dpP90K55kIlu9W1o=;
	b=Zjtm/nL7llrhh6q5do+yeeTIRhpHBHiFPZcHhciLNTggAF20ZyRwEC/xDipCAsIavzL0Ps
	ARHHYK/SWnnQfD7VaPAXIpY/bkhewySE+zzqoVOXb7rWTjCbARcK5Y8x+Dfe7gKq6OIXou
	5NNAOBwfLlbzb5fq3qd9BqPbu1kh/zA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xtNaBOLy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n7kK1FXc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xtNaBOLy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n7kK1FXc;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775814222; a=rsa-sha256;
	cv=none;
	b=ydojXathbtRRxagPRMmCYC+aHEUY5k8IIzqw0ukdGPALAzfN+i2VKnmkx5Wrvu+7WsgPk6
	s6v4Xf9czDC3GI/Jlykk9CYlqv69ywQ1k2bDzn04GzEuJnSZbTyK2wxEq/ZxgN+CobiSoe
	8Khq0rm7Vz/DlhS26cPmrGGQespMJYw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 474625BCF0;
	Fri, 10 Apr 2026 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775814220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQWqa1s/8lhEUAwETf6ZaQiJm59dpP90K55kIlu9W1o=;
	b=xtNaBOLyPvEKzmF0bWvTTiidvQRvBU6e0DOguykkx1cJBs3H3A/B0mQIGtCOtYdtLcjMvO
	OUSmaZrMO4t5APA3crw7P63vfl1fGBEN6Ux6vjzqBLKc+Ya5R6ToiGtslKUbFsLJ+jVbDs
	jbjPXqAsmfO94d/1CluSnpnp1UYjGO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775814220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQWqa1s/8lhEUAwETf6ZaQiJm59dpP90K55kIlu9W1o=;
	b=n7kK1FXcQuF8d6r+mgyBcPCAmS4ZjvheU0tdpA+tmGtfnIze7sE52xkTufir8acvqUauLO
	W9HDeTwCbAdXcPBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775814220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQWqa1s/8lhEUAwETf6ZaQiJm59dpP90K55kIlu9W1o=;
	b=xtNaBOLyPvEKzmF0bWvTTiidvQRvBU6e0DOguykkx1cJBs3H3A/B0mQIGtCOtYdtLcjMvO
	OUSmaZrMO4t5APA3crw7P63vfl1fGBEN6Ux6vjzqBLKc+Ya5R6ToiGtslKUbFsLJ+jVbDs
	jbjPXqAsmfO94d/1CluSnpnp1UYjGO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775814220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AQWqa1s/8lhEUAwETf6ZaQiJm59dpP90K55kIlu9W1o=;
	b=n7kK1FXcQuF8d6r+mgyBcPCAmS4ZjvheU0tdpA+tmGtfnIze7sE52xkTufir8acvqUauLO
	W9HDeTwCbAdXcPBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B35DF4A0B2;
	Fri, 10 Apr 2026 09:43:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QfDDK0vG2GmgSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Apr 2026 09:43:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 064DCA0A81; Fri, 10 Apr 2026 11:43:34 +0200 (CEST)
Date: Fri, 10 Apr 2026 11:43:33 +0200
From: Jan Kara <jack@suse.cz>
To: Jeff Layton <jlayton@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <vpgymg4vq7fv2iebfjebxbufjvo2yre64lcwjgsbyivu2pxmpp@zhjplhrjayc5>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
 <20260409161258.GU6202@frogsfrogsfrogs>
 <c18f8189b755c13064f51d93bfcaddb15300f9f8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c18f8189b755c13064f51d93bfcaddb15300f9f8.camel@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: ktrs7bfqss8xzhtdhokazo15pkkms78b
X-Rspamd-Queue-Id: 39726C0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775814221-333589
X-HE-Meta: U2FsdGVkX1/IKnA+QhpO3Z/+sinmzKgigaLNGaEiwX9xHDv7Ah10w0ldku3h450EwdntkTfZrnWL7k9JCF0RdcA67EWmrpcWyVeCYI3owcvOF9QGbP6GsaU7PrbeSySOF0RtfcoyaPzdsNcxDHQuGbVLcDgHdNAa0zfZ2ZOpUmlnt3m7WpnpKBHCpKfbdYQ2/9bOE6hSJVkIEpKfG90IchWC274aTANI9kCjTIw7xuv8pkgK3yXszKHyePVZo09U8IoXb370ievbxbIaTjgBVVbpjyAWBfsYfruLNWn6Sjf/IV+UQFGBwgLcx71jNKAQgc/q2SXf8LAIgXaHbhVP61WSUdxFKQnQSENCSil9swozRQTMCFQ+OrYkPikZQbunnnjXkuEGCdkVLIqQm4DWVGkrGtftIgkNMOJE9NrEWRxFi8cQERToZqYxoqU3Nd5G9O0No3xjQz5umncUQnOr3s+eFoUxBbpeJHLo+Q2bjuc2VBQK4JoYfRIXHXRqhstFBtxez+l/8kB2efKGNyJa/Jsa/may46KkRHXfoce41mfNIaXMo4FeY7TXuofDxUQvKmyehE4KNrc5dUfaKq74ob6h8Wq6HaB+voZQvKFndcX9gEDGN7DVGTQIIDQ8J0nnZJwubCWzbGA5Lo395L7lVp50N1dfTUcbjCow6PIYcCzUXtHsdfja4dx7lEZgStkdADLapBDIe1ppKLz6VZq+GXR03QBtXPwshFQLQlaiLsuvxhuXQamb8sGfkHLCOA7m8vpzJWBcamN0pq8bqh8AhjOUp+lw5I0EVEoGeiWCi04yAkVoTW90Zupb0VvDYdpHcUQau4Bwf5myqLO1kHAMCcd8QfF7sDClhEtZVQUcaQgje/lFnUElLBvMf0YxAdqaykrCy31htse6lj9I/NSSq35lcPB5a85fGUU6Ex0rV6zdR0yYXuzF2IJnXvkkl/suQeIXtOfWjxQ31WYWmOv
 WVWjJM0a
 3N79369KcktWwXG02ZD5c+yHbryf33SC6KkGhEzTALIH+a3YmnSzwiv3qhLepCpkjrhh9XdgBHwWx9lUFOPXoOvkGv6QnXXkjEGvnUA+9UIIT6PH4fDf9yVt0m4sCjfhSDiEPV2IhHtMvGDV3WCrPKcvfAosTlDCgY4VBwgnKoTchJi6cElcmyVG6kSZtvkdzo3zrJYOEnFsSKbLZttL/gYZa4F8gK0+7UhtOJtRxzYZb4HwyV/rZWY51uZNtzhniVTQ6ovw9EzT0aczwar3S9F46KfHSF0w8Zhm2XBeJhTydDpPY1KbRWhTimWURr+XV2T8smUMYjTe8OhNgcl1t0IlMhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 13:37:17, Jeff Layton wrote:
> On Thu, 2026-04-09 at 09:12 -0700, Darrick J. Wong wrote:
> > On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
> > > Hello!
> > > 
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
> > 
> > This more or less sounds fine to me.
> > 
> > > One possible concern is that s_hard_reclaim_inodes list could grow out of
> > > control for some workloads (in particular because there could be multiple
> > > CPUs generating hard to reclaim inodes while the cleanup would be
> > > single-threaded). This could be addressed by tracking number of inodes in
> > > that list and if it grows over some limit, we could start throttling
> > > processes when setting I_RECLAIM_HARD inode flag.
> > 
> > <nod> XFS does that, see xfs_inodegc_want_flush_work in
> > xfs_inodegc_queue.
> > 
> > > There's also a simpler approach to this problem but with more radical
> > > changes to behavior. For example getting rid of inode LRU completely -
> > > inodes without dentries referencing them anymore should be rare and it
> > > isn't very useful to cache them. So we can always drop inodes on last
> > > iput() (as we currently do for example for unlinked inodes). But I have a
> > > nagging feeling that somebody is depending on inode LRU somewhere - I'd
> > > like poll the collective knowledge of what could possibly go wrong here :)
> > 
> > NFS, possibly? ;)
> > 
> 
> NFS indeed.
> 
> Bear in mind that the NFS may fail d_revalidate checks on child
> dentries when a parent directory is changed on the server. I imagine
> some workloads might see a performance hit if a large file's dentry has
> to be discarded and looked back up because we suddenly threw away a
> bunch of useful data in the pagecache.

Thanks for filling in details! I was having vague memories that NFS was
relying on inodes with 0 refcount not getting immediately evicted. I'll
keep that in mind when thinking about solutions.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

