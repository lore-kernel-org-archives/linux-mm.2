Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D718AE9905F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 09:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068AB6B0005; Fri, 10 Apr 2026 05:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019A96B0089; Fri, 10 Apr 2026 05:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71946B008A; Fri, 10 Apr 2026 05:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0BAD6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 05:23:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 686E858FC1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:23:34 +0000 (UTC)
X-FDA: 84642108348.18.9821BE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9DD071C0013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:23:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXP9WrNi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775813012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0e5cORq5EePfMto2zoLbHvyKO76k/fBqhrli5JrWus=;
	b=zpox3+9MPgCiH5NX+AI+eeNX6kDkyE0vRKmylnvrg502TYrJD5vvI/JMIY/MyItsVyGRzm
	vFBkGDdFD0sUIQRlMTNyKSYwnIAPIu9EYGUiRWwwUrjhMaMUbOzxIUBsq5MU1lleZmZpWH
	b3JWyQqQ3+6ipcIwPHfICNdqEFh0TfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775813012; a=rsa-sha256;
	cv=none;
	b=6C613CrSXl9nIANxK5lBL5MOfZ7vWtB7Mu58OoOMOtOEvjM2iZHI6L2nxxk30EX2z1jxMK
	zKT1E22r7SSAfoupEaxmyReRrJOrlZiM6aTuySSsDrWF5XfmwTTrcp9Id95zwHs7tIL0XS
	L92AumoHXdaHS4yY2VYqN2r3kWfvwP8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXP9WrNi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82100434BC;
	Fri, 10 Apr 2026 09:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A61C19421;
	Fri, 10 Apr 2026 09:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775813011;
	bh=bRS2sFDSkxDNUxdLeMiZMk1q5DPX9sCGAQGX2rFyGa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXP9WrNis/L8hNuW4Ic6OoPesbEAjB1wAoV4JK8O4tFeM9AKY9lwNWLtfK1gj0EzO
	 O4bNbfXYyQfJgqkczpXdFRJvyWnqvfa7fkt6ZIkjvBJeXx9h9AIqfOw+JC6qfcj0BT
	 dlNLLL0wNfexikgNm/PU4lTU7NGIcu6mp7MXxmPdEJdFqqoano9zlHds5wSs84Zb0m
	 xw0uF4caQzfOaXDh1S0t5QCJZ04QkjPbNqp0Gozm++BGvD1ZcXLvTn2g2WxE6JT5O3
	 djlsiOGlGxr6B9LsxLVXYuMF5du/p7ehQMF6t3rYM0r4NxAShCMqnjf/kbJc8K0D2P
	 pvODL5A/odabA==
Date: Fri, 10 Apr 2026 11:23:26 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, lsf-pc@lists.linux-foundation.org
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
Message-ID: <20260410-anonym-freigaben-186946cb50e3@brauner>
References: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
X-Rspamd-Queue-Id: 9DD071C0013
X-Stat-Signature: i8pishg4y8188u99rsp88hkioy46eeat
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775813012-483210
X-HE-Meta: U2FsdGVkX1+1B4NE2QehJMuC75UqgpAWsXqbkC1aFWBq54w0rZUhrV+isOhsLrPNCwg0QBV+kMEld6paSysCCMFhFeTPpGPfUzeBbhinQN1t9yEKZdtyT1uLpf+4XQ6T0creuu7KeuiT0z6X0v/uzoYdZ7DMmB6GBCvFzzStOYuLySLykOvBeHEum7iWGl7p8G106vHIFnICj2KxtT3SPcTJmtFxTeoK+GC3HZcCbmC1x6kWkFH8ndR538osp3OHOXJBamBdiz3RvnoPXP07X3Yc1bYum+G+b78agaFJ1DH3Qo+CvcpBjM+9kl9ai7//JhpdQRTJX6am3cRpYjISwH77vSmKzh8ueEd7I/PuQ69a4SXzBJwi07GkoV95o4Mpt0OGBazUYhKmQE9vzE0KP7vKWnG2I356NL0p6EKGf54ouctM9emiWdBbrym5n4vg8mLiEezdhd+cFAYg9aVNfgP9yighzsF4gxOfcHmfrziwbSsYUjAh1gkghkFkJuL8yrCiz5uTuZqo7zKX5ntSvBocw10qRqae83kAqeR4QYhKA0tzdnMz8FIWVWJOpl8ihmS3U3L3SO/RdvRJ1YfLlyX4z1BgmxcVL7beZ/L7xpg1E9W48LzOZ2RJYxeCVurz4WYHWqkPkLWsTChLzuDPWYQ+paxV3lOuuZMeRy884pe3jegwJvkMdoWETVq7OLbCYtVV8J7mPXuaE9gRqoIQAXIFZruZTC1rXoRX8CbGa4NBKmRGfFSmGKh8nWrTMvYoUZwWSTuPE6qjzfR5sAVNvFBjMKtlI8c+jL+XGgzGUpkWCxiTOann8XXYa8Rd7Cctvww1+ngtfIoJEIqIu9WpjIjHpz66M56CjHCfU368WrCAuchZEJHygNzplzswDFjzYWIg5u9E17jMNw5cVPre7foAvTmsQJY2R+3YlZlxOWIUcoF9pXIv+lEgKSb/4XA1QrpmXaMVbyrXpQJDucW
 WQOO33O5
 6sOQA4lcghFH3GoR3IWmGXjkN3/Mn5KNMufxI5fRBdzTcXUjh5Mei1MTCzJ1DjP/4h+EAiaAzSfK1L9Dlydrb3UbgUXQfZ8K1+3oLNdtYzVkfBjswlPIpXJ/wBRi54mh1V2QgjO475obmYvhyiJtHai0FB7iiXUb47KsQuqIhArxrxDNdcF6S+xOy98k2ixkdrI/BV6y4VTLUVXqU986y6DwNNqVQ3q/k5Pu0ETj2EWwtJnlrAidXBKJU2ZuvPDdt0AsnIXL0HGuS+sNMF+uzu9NHOeuLgOkcdfK5kM+QJd11eTE=
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

I like this approach.

> 4) The work will walk s_hard_reclaim_inodes list and call evict() for each
> inode, doing the hard work.
> 
> This way, kswapd / direct reclaim doesn't wait for hard to reclaim inodes
> and they can work on freeing memory needed for freeing of hard to reclaim
> inodes. So warnings about GFP_NOFAIL allocations aren't only papered over,
> they should really be addressed.
> 
> One possible concern is that s_hard_reclaim_inodes list could grow out of
> control for some workloads (in particular because there could be multiple
> CPUs generating hard to reclaim inodes while the cleanup would be
> single-threaded). This could be addressed by tracking number of inodes in

Hm, I don't know with WQ_UNBOUND is that really a concern?

> that list and if it grows over some limit, we could start throttling
> processes when setting I_RECLAIM_HARD inode flag.
> 
> There's also a simpler approach to this problem but with more radical
> changes to behavior. For example getting rid of inode LRU completely -
> inodes without dentries referencing them anymore should be rare and it
> isn't very useful to cache them. So we can always drop inodes on last
> iput() (as we currently do for example for unlinked inodes). But I have a
> nagging feeling that somebody is depending on inode LRU somewhere - I'd
> like poll the collective knowledge of what could possibly go wrong here :)

I still think we should try this - for the reduced maintenance cost
alone. Imagine living in a world where there aren't 2 different LRUs
constantly battling for review attention..

I'm split here but depending on the size of the actual work needed to
make this happen we should at least be open to try this.

