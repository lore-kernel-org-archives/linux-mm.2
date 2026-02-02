Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 539C1E7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9386B0089; Mon,  2 Feb 2026 13:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796926B00A3; Mon,  2 Feb 2026 13:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A21D6B00A6; Mon,  2 Feb 2026 13:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 550296B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:42:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E4CBC13B6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:42:04 +0000 (UTC)
X-FDA: 84400386168.16.2012CDA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25A2E40007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:42:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hYC2BZfq;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770057722;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAtv739Fm81yOnDk6gg6D9jyBN9kXpflK4sUDsIicis=;
	b=0baOTscMOYTh8X8CYyVuwMIPnKKELlCFiK7bkxQODP8yPSuBtIwMPGRSAPd3JOHcqVJC2W
	XYlVKcGrlO3qIApudjwboJrFR1MRBNmhnLp6+EZu8Z5369H0KicxgJrMh6ZB1Pl/bxGkR7
	qyoGWQZbuypugkc9u8EI7mAMgQn58po=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hYC2BZfq;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770057722; a=rsa-sha256;
	cv=none;
	b=3Tm3hFYMp4pxCN+jjHq3kdYoMGmmI4Kft+dREoBrPr6M259MROhyookBNbFIZlqzr1GJW2
	6DDuI4DS85VW2Uf1NZ33G9dO5Pvm1BYJwsPM/9F4EDnu0OfPe95mH3vLIgLuCT2ntEtOtD
	5IZXsNgJvyBGTh+/OfvcR7Lt2qXVzok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uAtv739Fm81yOnDk6gg6D9jyBN9kXpflK4sUDsIicis=; b=hYC2BZfqAR1mxw6GyS+HzD/dL6
	Fu0X5tDfReMe7mTS0jzm6j8FijBdR+cBotrURA8yIHAs0aWloUFkhSWA35EiBG0vzSoPc4ErZFUtp
	rnKgZUh6Mr8htEMrq9x2JlQyoFJRmXkqdwqqXVy0943zDpg5UxCEeZX6FF5y/40t2F3re14nwkpCU
	EcWbOBLC1njTOB91nz38wKXQ8zLxYHAsICfK5+7AmhIOFYyZFfZ+6+Cp7BNYAf0R2WVHs16hGB3jA
	ZYzeBKc7S7N3ePoDG0c2WKgFSJZ+799RxLZ+Ns0TvfOaeh+Am3k2c8lsPiqgQQ81jop2Fykx3Leol
	cOjJ4mbA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vmytw-0000000C1To-1T8e;
	Mon, 02 Feb 2026 18:43:56 +0000
Date: Mon, 2 Feb 2026 18:43:56 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Orphan filesystems after mount namespace destruction and tmpfs
 "leak"
Message-ID: <20260202184356.GD3183987@ZenIV>
References: <aYDjHJstnz2V-ZZg@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYDjHJstnz2V-ZZg@thinkstation>
X-Stat-Signature: ghku3cwwi7a1r1huchm7ckd1dy431hw8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25A2E40007
X-HE-Tag: 1770057721-289660
X-HE-Meta: U2FsdGVkX19sTB5ij5m0l3TBrCpCCBVIrXk9BJcCocf3iSSRki9cFMrasd5TGJu2o3MFajOtV8Cb7iNjUB4q8aGarsKuCmb8yEOc/4EVb4jOIVnQCuFe6l6J4SiUFP+x+x8glgy879uHmgKVzYAIpplMuivNjcK4aWKKZMpJCFNIxuFUR9Dy4pWjiSJrbBna1UIAN5SLv1LWBtA0E9KO+TiNVYHl855Nb5poM9BsnRucUk7+Ms38HW+RlfZG89NVseicynx00gzdyw+bnD4wJqS5n0vo7q+ZL+h/q0o3c+DfkeuBYTA5sGJJtn7SGkIWmBHWrpdfa3gV5ppPYGnymA/KN70GahigQj+GJOvRiuvzlkHAHd854wW7vqBKzqOctYyOYGtxPs+5FV0OnBWRoOSZ9lKaTMnl0DhvnI4J1cr0C0COjlgngzwiWE8LLoWQfGceovYpTykvWbwvV4XsENJ61asPQFxvoQbEPAT8N34UW7V2RSvjKl3v7xSuDIefoQUPXMzyEoNkD7Ps4ot8zfIDe/iQs9U8QTypNa3P5aFBxYWAbS7l1PnPpnFDFTcgW8RY+camXgwg/KgDpNoH5UiJvYRNg7vXlwjHxK0pP42068qr98R52Orx6WWH2X7FoNDvS+7r1lo/X7ZTlMQw1bvS0ItEvw4cpmfl/CYnBVURyPk7y4JDxP8XhEiVW4k6g6c8WbWZtriOGfLCvlyFeKx0+K7Tn6LGB6EJbOHCopR3AzFPJ9wLEH8fWHrKlC3Ub5h/kdAeD/XUgpsY5PuGsvU83c3cg2U5rCUKOJ8KlyjvGCk94gnAbe4BzWsPYpkYPoQrdtxsWz9GLc9L1l283Yo4HjQtPf6rfEYyYBfAHDSGLwh70izX9AEl9yI5MBrrQORD39Rot5jLjz992twOlQJCQc4xsWG1IaC7sUDgK4sstVB7JRhKSUA41nj8CkPIvqzVQ7GdIBfAeVKbx8A
 LnCRMj6o
 DMCAlQcwQTXkfS+BowhR9jRymzfztntiwZi7lkorFttFFRWduu1ejrkjeiWf49CFdeN1EGmMDNK6epDtp40yDiHqmeUQTK+ZXpMY796Q4a+Qu85PPk/0AlyDSh2LfdDCd9xKnkCDsPZj69BOWeLgVazADw0i+YZgxq0dQuDYsjMtrSNTDkb2J3N+QZ0AvwH2hG2xMLSobS2nVcRswNM/cARQp2kTBtDLnoTAW2mjIU9HMGHVepKBkE3uoyJYzcxUmtUSzYWKFLA6Gi5I0xq0z9ECfOGdm6exFiHVIbcrgaLYVN99z1eAsrmeulOywEju3QX/ytEEqHOQt0raC1hyzgVP7R/WGCQef9DlULtQl7g6f+wqkwI8O7HAEMqxnRweoPtk2TvcI2kJjt1+LKVXwlqmlQdskx3xRHuVv+EVRWFpPPhkDEPbgq2f8oA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 05:50:30PM +0000, Kiryl Shutsemau wrote:

> In the Meta fleet, we saw a problem where destroying a container didn't
> lead to freeing the shmem memory attributed to a tmpfs mounted inside
> that container. It triggered an OOM when a new container attempted to
> start.
> 
> Investigation has shown that this happened because a process outside of
> the container kept a file from the tmpfs mapped. The mapped file is
> small (4k), but it holds all the contents of the tmpfs (~47GiB) from
> being freed.
> 
> When a tmpfs filesystem is mounted inside a mount namespace (e.g., a
> container), and a process outside that namespace holds an open file
> descriptor to a file on that tmpfs, the tmpfs superblock remains in
> kernel memory indefinitely after:
> 
> 1. All processes inside the mount namespace have exited.
> 2. The mount namespace has been destroyed.
> 3. The tmpfs is no longer visible in any mount namespace.

Yes?  That's precisely what should happen as long as something's opened
on a filesystem.

> The superblock persists with mnt_ns = NULL in its mount structures,
> keeping all tmpfs contents pinned in memory until the external file
> descriptor is closed.

Yes.

> The problem is not specific to tmpfs, but for filesystems with backing
> storage, the memory impact is not as severe since the page cache is
> reclaimable.
> 
> The obvious solution to the problem is "Don't do that": the file should
> be unmapped/closed upon container destruction.

Or remove the junk there from time to time, if you don't want it to stay
until the filesystem shutdown...

> But I wonder if the kernel can/should do better here? Currently, this
> scenario is hard to diagnose. It looks like a leak of shmem pages.
> 
> Also, I wonder if the current behavior can lead to data loss on a
> filesystem with backing storage:
>  - The mount namespace where my USB stick was mounted is gone.
>  - The USB stick is no longer mounted anywhere.
>  - I can pull the USB stick out.
>  - Oops, someone was writing there: corruption/data loss.
> 
> I am not sure what a possible solution would be here. I can only think
> of blocking exit(2) for the last process in the namespace until all
> filesystems are cleanly unmounted, but that is not very informative
> either.

That's insane - if nothing else, the process that holds the sucker
opened may very well be waiting for the one you've blocked.

You are getting exactly what you asked for - same as you would on
lazy umount, for that matter.

Filesystem may be active without being attached to any namespace;
it's an intentional behaviour.  What's more, it _is_ visible to
ustat(2), as well as lsof(1) and similar userland tools in case
of opened file keeping it busy.

