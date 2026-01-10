Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BA7D277D1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 06:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796256B0088; Sat, 10 Jan 2026 01:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744656B0089; Sat, 10 Jan 2026 01:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650706B008A; Sat, 10 Jan 2026 01:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 553EB6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:14:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEB511AB6AD
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:14:44 +0000 (UTC)
X-FDA: 84315040488.02.F4A2EF8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 221341C000A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:14:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Op07DxHr;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768025683; a=rsa-sha256;
	cv=none;
	b=pjjU7KRhzLp4snHqSWmw5f4vxMwWwgDUv/VQ+6aMwKRsXMWEz07akn3mw2cWIMIxz/w1Gz
	/cHpWREZtOEwRI4ZM9ii++c1O21Ql86MOsB6nXLLWC6iBNN0OwLwU82Am8hvjMtCArMWJJ
	NKT5nw5lJ5PqkD8gWUDlBH2yIs04TBc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Op07DxHr;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768025683;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOhqKXHOHZ1Z6TQIHPMQELoPwFKMupQNtk/UZRAYy4E=;
	b=f/Ib7SAd6t+DxM2+3dU5uj2bZduzzXEw89hi7KCrgUR5K/A14XrTet/3EcyN6fb6+rV2Ki
	9uCS/45DHRsEYfBRcVzPdf01WOml3BD551OpuOWByWnH398oHQgSmdDunBMFBm17AiIhqW
	pm4cSw9Ahko3kgNtKQ9tusom/FTkRIk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FOhqKXHOHZ1Z6TQIHPMQELoPwFKMupQNtk/UZRAYy4E=; b=Op07DxHryHEQHOQfCxhuLT0fY9
	WNaAXKfd9891rqZM+6MEvtsS+Fe/U+xGzEbYU7ODsh6NPEIyQDzwsNG0fvwrPa5u68baOnLZM0aiY
	I6LdC/gHGicIJOigkt7R6CeVn+VYPBdQFoMXcBbssAwPQ8FSDCVbxB1RwgJLyP3LZQOvh2mWVh0Jz
	6v4DIx4k6FLMGlnfC/sHajw1Fuju9A+8YgrHhmKSW2OmKXiHxSK0mugHRudzUtZ5sY0BoSC4gtbHi
	XI29GLxeUyHBe5/Og/FaWixZO7HQS1O50EDNt7TaBZvvYCpaIvH5na5lrZKk5P61QllGPOA58pXMu
	OrsqIdIQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veSGW-000000099BJ-3qur;
	Sat, 10 Jan 2026 06:16:01 +0000
Date: Sat, 10 Jan 2026 06:16:00 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage
 duration
Message-ID: <20260110061600.GB3634291@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <CAHk-=wiibHkNcsvsVpQLCMNJOh-dxEXNqXUxfQ63CTqX5w04Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiibHkNcsvsVpQLCMNJOh-dxEXNqXUxfQ63CTqX5w04Pg@mail.gmail.com>
X-Stat-Signature: hpq1mjn1hphr88g8nryp5uza4yts9zan
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 221341C000A
X-Rspam-User: 
X-HE-Tag: 1768025682-405079
X-HE-Meta: U2FsdGVkX18alqo9qh0QxtLlmHJOVEkKeBnWMOCdaWnzRyD3rWNsOnLgRmU5TxW7new932C00qKs88vyAzV0GdraPeJtd2s9kIzMjtl1zUKjNs8S7iAf9ILB8A4n9qbAeI8NXBVD5eOQIuzqZRxI30u4YK0L5N5VReQdjo6s2jtAcsxSlKjeQMrHxjY2OmnxJWSOPUfk+3AcGAtgv5I7DixzNOuiVZPwKdztd2pYdq0iFOreDwpKudROT7TCV4T8ixocb9WLNIm3gKLlaT2CLitnJnxf0s6el7y04m785F6+KQyZW28coNX4FV+SbiutcmMVmUeOa+qEHUDcsU8yOLFpAm2zLpp0bkCthOxfzmrNoBqWvb7RbMK2VrLRHOtOEE84KgRCkTF7LRTQImybYNs4FMPUSgZXURLX1qKcdPQkow0xrTGMQh1U3zfGzuUgxsJ4HyzjFrRMHsBlX3lryPbZ7hFjtM7VytrWu+Sz6+93G4xKuIjjuJoNNWldafTpTfOr+/KLctQIQM0O0fT8OKK1GZI7BfKTHGtCXcjGobiqtmWEQk3f5JS+lHbZnatSpGF57LXmJ1DD+BhOQb3+e/lsYJR/hoZFekRp2Se2N1HX3fsgvhWLRdzAPEBCp/xKRb5JWYu10yOizKah6A/xvccwxyg+yRFxG//hsNAw6DYPyXa7vdO7ulnuKeTZOqMgWawk6OJKpny6kbJNsDOuS5Ik9zCKtVnaMDn0td01AGy9sxLtEIZYmofxOJpi2IzGOM4TgFGk8D5awtpQCwkigkFgX5Q0aE6XQOGjr4MLr9brAlKAB7dHTBvMVh5UHpHWkIZlF3d8XAapLyQVhVNiK0sZ1oLFwfwegWUm+xSEM2UiEpZGGDpO0m0W+NjJz5SDZUEzqwlE9t67FpvEioQ4ZfKOsiFZZMMiiNI+7gIUDIFb0vFl4f11uin7NY56RWG/d8PZz5Fi16jMOrNKK/S
 9BGtfhJ/
 gM6IAk2wlBV3paXRhncRB3gqrFtOlhRIjkSvwjgJXAZee08oZsW+Cxd/svpYNTev6mKSaC/VO4WUnVOzB/6v0KGi5ffbKGzgjbS9oq73b01G/xyG99HG9rgKy11eRcYZdlOrZU/WBC1ORX2OI5G/IwHywgCBrCrsZhLUOdhb/XwhA76RjKv2d4CsHJ3n/ApD0fpXKqaCetMMOa6ChIu/mCRzmnyc4XTPEbAQMpzLFYA8uZRUdZzmm0sbQhQR9FtwShypP/XDaVSOc2rmXVz9okDvEIgXiHqxSJ910T7Ae1PZH17iQOCo6vfoO1W/7HftzicOMKsPvkkY5oortNETEw3ezwWztNpyh8MnXCEYA4gRTaoK/cGldLMXm/in9FFfDi3RlTLQVeUlHdGQrCA23u708o/HD3ZihuMUxOSPpBbGB2yhXnBYu2K9FkDzMxIe8az1LjHu6ZgfDfQt7JIIlZxu+1gOCYLiyDXyAIzQmz4kLnt+xdVlEJzMtEkL4twapBNc75cyBPmiGCKYdUJhS+bq7ndK7dlYvV8qc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 07:33:41PM -1000, Linus Torvalds wrote:
> On Fri, 9 Jan 2026 at 18:01, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >         There's an alternative approach applicable at least to the caches
> > that are never destroyed, which covers a lot of them.  No matter what,
> > runtime_const for pointers is not going to be faster than plain &,
> > so if we had struct kmem_cache instances with static storage duration, we
> > would be at least no worse off than we are with runtime_const variants.
> 
> I like it. Much better than runtime_const for these things.
> 
> That said, I don't love the commit messages. "turn xyzzy
> static-duration" reads very oddly to me, and because I saw the emails
> out of order originally it just made me go "whaa?"
> 
> So can we please explain this some more obvious way. Maybe just "Make
> xyz be statically allocated". Yes, I'm nitpicking, but I feel like
> explaining core patches is worth the effort.

Point, but TBH the tail of the series is basically a demo for conversions
as well as "this is what I'd been testing, FSVO".  In non-RFC form these
would be folded into fewer commits, if nothing else...

I'd really like to hear comments on the first two commits from SLAB
maintainers - for example, if slab_flags_t bits are considered a scarce
resource, the second commit would need to be modified.  Still doable, but
representation would be more convoluted...

Another question is whether it's worth checking for accidental call
of e.g. kmem_cache_setup() on an already initialized cache, statically
or dynamically allocated.  Again, up to maintainers - their subsystem,
their preferences.

