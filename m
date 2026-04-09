Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4EAF31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B656B0089; Thu,  9 Apr 2026 12:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCBE6B008A; Thu,  9 Apr 2026 12:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF87C6B008C; Thu,  9 Apr 2026 12:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4B96B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:13:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56C74BA3A2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:13:01 +0000 (UTC)
X-FDA: 84639511362.10.2A1FB0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF64E18000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:12:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L95Rovtd;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775751179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7EzA94o1Nnl0DZ4yqd4j1zqoivjRXNsUhltIKFmFX4=;
	b=DfQn6ggb3LkG/Aw87JhO0wDQAdTMLLuDiY39pv3GTW188UOn3lIHX9/kTBiCqMW1OfzSlX
	vg3BIhpgJa/BZ3xu+igZd8sCMt6CL75z+FZDY7SCxugqVy4LFg7lVP6cV26AJLkX0uPkkL
	kpd9F9ixYpZ4x8e6+g6F1vMn4egd/HE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L95Rovtd;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775751179; a=rsa-sha256;
	cv=none;
	b=rx5NLtPKUxnWnD4p4MW1fbu2sl+vR3go+ua5yZSsR+zmRucm8fiBxyh6P2vd6l6AmkQ+5X
	9y8DQ6EcRzx6LKofKEeoDE/xIhEcdWuFmTl13N5Poq77Z2hSg/AvOINtzMs9s7r7+z2G/Z
	MFpDJXLpuh1ainM/L8MPAREipIHDA+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1ED0600CB;
	Thu,  9 Apr 2026 16:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AC3C4CEF7;
	Thu,  9 Apr 2026 16:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775751178;
	bh=f4fYl1Bgw3X/qBz85lGZ8DoKbiAtjXnT8GvKt8TU8dQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L95RovtdTY6ZH7BEOl0PSFriOj2XL6j4oBWoN6g7RlBWEAOsu3DpN0hd6VQd6GgbL
	 A6eRlIH9Sq1DyjbvN0tRKofTpdAaS05EJ+8QSbfth6aW2O+IUeIg5A2c7j0SlXmRn6
	 CEsBqh4isVK62rqshknzXbXBEtGPvtEnr0MJ6Qc4j9mhFoyV29Gkv0ldiAvz6I6T9U
	 QNjW/ypcMsze+dzIVbPbqzPl5JMuQojwd0XlxFd00ULmA7bResEVf1C+8JO7FjPU4U
	 gPrGKL/4AqkvsUZjDVd0aVo3B9g7hoO8JGJ73DS/KxRlNfeLwvxLBdhJcF6O7wnKY0
	 9/qKHO3F1LIuw==
Date: Thu, 9 Apr 2026 09:12:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <20260409161258.GU6202@frogsfrogsfrogs>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
X-Rspam-User: 
X-Stat-Signature: tzou8u4pspyn7mj4m6szrb6dho73fi8p
X-Rspamd-Queue-Id: BF64E18000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1775751179-538499
X-HE-Meta: U2FsdGVkX1+XlAH7mXqRRqIKsrJxIznYOEbecc1CmZChJ1cG/MaXLYQOFlqA2cuKUd2luO+I21GYeR0eZuB2Og0wEOZkW4yLbEdt7KzVGendLwWPNjCrZVRTkutE/AytVM/XgLgSeFj7oBLsTAbResmDinvfArIX5NocZKr8UQl5cHwe/RDAxn4wrFBo2ImFPTc6D/veL8LwEWOXSLiIDTanL/OG419t9P7JIG0x/3LtPpnhAb8dDCPL1dApFOu+GtHZWLUmJcNrmrOWXwysZP82iLWZ92SUaPgp7AbvCbux3HrJGjOljtv/7AqYkETPhUrUjrc0B5RK6EYGMeZGmVqkz2XVYChcWI16Jn+JoplFlg68JepKqTqMJ0jG9HsSSrINNFkJo83lIoUHNXR2zpG9ZLIJ4iXtAER28Q0SSHYTtNUPKV3L0Ewhc6SnfxVAUTSPVPRaCp6OxrAzsl5ntydXZhOET6fpVw8b6oRQcNy4G/VpEs1TOGlEP5X7ynGy6B3/sDG5sxLK/+AjpNcq2A8l5veYOGsak8TjtqI1pYGOWMLc7bj9xQZRNTMQlL8TddDxt7td98QNV7Z9+bnBnx2DjS3ihbN9Z57W2YTRk31nVK2nNbpiEYternZIHijO4msGvpp5MMtMG8hR7njoG9gVdWREdMwuqvB8iDVYn4h+4ZpdqY2TO5PEaBSSzy1yesvWCNjNlwVuB4kAvrCPoCDDFcCOylEY9EHFqgngEe80XBSvyIHjCjiOpfai7WrCURdUgkwmtky7v4aog3UuHBeRrLJdlRAmHatwml2w3zuBAAsEcWMxCWabt127Uj8ZHcZuS8ZrJ4w7JpDR8yinIxHjA5p+JI1PzAyrkJNIKilz+2y2F2UUfi9hRBb33GfAqH8pG36Mw0Gi1Q+htASpYlwcvUBddecScJhDfFD8QAzu2KVtaNY1evINnwMcQcaSMCK5yYj9xhtCKAqMlUD
 gt9+BzoA
 MCsc1Z0mnp2pMR+GGHngO0r7KkDGyX/2anzaQpTe4dplkiMtaJY001vBLrMcbhB92Wkx5KztoqWOjMq/HsJUWzjEEutnu9dCOMWWDs4Sxv1lEpzg7GjCwi+BAbX9Zw79JWsS/N2vvkiZPaKONwst4avF8ux1abEeY4CWxBZhcDIacwR3k64B+VvkYaQh8u4/1DKrRHnFZtayz/X7L3Nc71X0anBmGY76js9PfxpqvMsmltx1+Ctg43eytW3988jQrkJKlxfszTc/gNXQOL94s+wM5M6wWtovC0iV17U99iVH0gRa6HfYUip1VfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
> Hello!
> 
> This is a recurring topic Matthew has been kicking forward for the last
> year so let me maybe offer a fs-person point of view on the problem and
> possible solutions. The problem is very simple: When a filesystem (ext4,
> btrfs, vfat) is about to reclaim an inode, it sometimes needs to perform a
> complex cleanup - like trimming of preallocated blocks beyond end of file,
> making sure journalling machinery is done with the inode, etc.. This may
> require reading metadata into memory which requires memory allocations and
> as inode eviction cannot fail, these are effectively GFP_NOFAIL
> allocations (and there are other reasons why it would be very difficult to
> make some of these required allocations in the filesystems failable).
> 
> GFP_NOFAIL allocation from reclaim context (be it kswapd or direct reclaim)
> trigger warnings - and for a good reason as forward progress isn't
> guaranteed. Also it leaves a bad taste that we are performing sometimes
> rather long running operations blocking on IO from reclaim context thus
> stalling reclaim for substantial amount of time to free 1k worth of slab
> cache.
> 
> I have been mulling over possible solutions since I don't think each
> filesystem should be inventing a complex inode lifetime management scheme
> as XFS has invented to solve these issues. Here's what I think we could do:
> 
> 1) Filesystems will be required to mark inodes that have non-trivial
> cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> whatever :)). Usually I expect this to happen on first inode modification
> or so. This will require some per-fs work but it shouldn't be that
> difficult and filesystems can be adapted one-by-one as they decide to
> address these warnings from reclaim.
> 
> 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directly from
> kswapd / direct reclaim. I'm keeping this variant of inode reclaim for
> performance reasons. I expect this to be a significant portion of inodes
> on average and in particular for some workloads which scan a lot of inodes
> (find through the whole fs or similar) the efficiency of inode reclaim is
> one of the determining factors for their performance.
> 
> 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a separate
> per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work struct)
> to process them.
> 
> 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> inode, doing the hard work.
> 
> This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> and they can work on freeing memory needed for freeing of hard to reclaim
> inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> they should really be addressed.

This more or less sounds fine to me.

> One possible concern is that s_hard_reclaim_inodes list could grow out of
> control for some workloads (in particular because there could be multiple
> CPUs generating hard to reclaim inodes while the cleanup would be
> single-threaded). This could be addressed by tracking number of inodes in
> that list and if it grows over some limit, we could start throttling
> processes when setting I_RECLAIM_HARD inode flag.

<nod> XFS does that, see xfs_inodegc_want_flush_work in
xfs_inodegc_queue.

> There's also a simpler approach to this problem but with more radical
> changes to behavior. For example getting rid of inode LRU completely -
> inodes without dentries referencing them anymore should be rare and it
> isn't very useful to cache them. So we can always drop inodes on last
> iput() (as we currently do for example for unlinked inodes). But I have a
> nagging feeling that somebody is depending on inode LRU somewhere - I'd
> like poll the collective knowledge of what could possibly go wrong here :)

NFS, possibly? ;)

--D

> In the session I'd like to discuss if people see some problems with these
> approaches, what they'd prefer etc.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 

