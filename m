Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D3CCD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A310B6B0005; Thu,  4 Jun 2026 12:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2E46B0088; Thu,  4 Jun 2026 12:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8926B008A; Thu,  4 Jun 2026 12:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82C2C6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:15:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 240B6C0946
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:15:46 +0000 (UTC)
X-FDA: 84842731092.23.41E6842
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3FBE620007
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:15:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=ppwPVJXO;
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf13.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780589744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtMzuRVZcGCklSnA+/FZ/RF0Vg5pOuupQOOgmF8wAFw=;
	b=1sCzEvVSmq8Q96PMwRpAy8JehUFlVfkyoYe4sSrmOsBPxEqKk/Xn8IBZIT/lXPDhZBAVPb
	9ee6Q71IMKMo7jkG3fyjC0B9TNZWJ36g+x/l/fprKHA10AkSidbDiyTUanmHp5stWhtcq/
	XWDCL0Yn6cw/hI3dsgJOFgIUGQezUG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=ppwPVJXO;
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf13.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780589744;
	b=w/ZhSR0BY21i6+dNCTx1dO2z1SepgYCMWkUX/NE9kq6xOd0kCN+j6bQ4/2bzJGOoONEXVb
	1TRBra92kWmPIH+9EtBo/k4RNOG20/VwzitEPgcDGI5ey2yXGIBEySOqKUYAQG/hq6jDk/
	18YpiqHIfQNDNLlqxvaigcle7FyOq0M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780589742; bh=mtMzuRVZcGCklSnA+/FZ/RF0Vg5pOuupQOOgmF8wAFw=;
	h=From:Message-ID:From;
	b=ppwPVJXOvGYaPRdvarE9BWEOVpOna9yvC3pObS8GWFHiL3VuCxL45zGcYB3aZJbbA
	 d1LtvytShpiYHUGqpfrFWU17MFQ7amA6RJz/xe76SyT0sSNTsHwUbT4AiRo0QRPvcu
	 o6g4Sl7kKXm14Zs4EoZaddi6Wq8k04QZEhNLAVHY=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 6F0B7C0BB1;
	Thu, 04 Jun 2026 18:15:42 +0200 (CEST)
Date: Thu, 4 Jun 2026 18:15:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aiGkrQnMeyPmEvRB@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
 <aiGfgRch99l_5z11@1wt.eu>
 <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg0e8pP5haNW4qJP1=QwwUEctwjK5k07sv8bskitoMDgg@mail.gmail.com>
X-Rspamd-Queue-Id: 3FBE620007
X-Rspam-User: 
X-Stat-Signature: ny17iurgi39dzgae7spje3ai51fu8t4e
X-Rspamd-Server: rspam09
X-HE-Tag: 1780589744-605143
X-HE-Meta: U2FsdGVkX19xOc/VITM0apJFngUtS9XUnOU9gP7IdiO1phhwOFgcJQDije1iTa+cM6G98mxY35WC4B+ynZMVgjHbLC3/BsG2SpVBS3FALU8EGHE7GuZaMlRk6xEByJqhck/0wzUFO/1JPu80BjvGgCoWRfuUkmxQgEWFZTJjoMMMls+AzHpDryVpOPfPmrOIX7l0Qhg6GAE1m5yAcotGa9un5t8/hDA6QxNZsp655egytCOiPoYyRsFjdJ/RmNqIPsOzFWiWUobHmKud/95BeKeyxWxD9VAuI7Y41+a8annuU3lqgFhc5YhPqed58tHV46vJJO8DQe6tF9pzLMLjNaL4a5udW5aoHHHz7xXnRzyhnQAEOnqTQ9LA34e+PqoeyWsmI5aBnaL26NbctKwBPIyCusGs8u/zwy0vCdBGQwe9i7Ew1MChgl+gyjiuziXIgxcNrepXrRCWFSxnaj5102jd/HU0WSxv8E0LFGkg7ynHUuegIm/OxSNRP5OrrIHv9XzX2MUs6OvxLT0sHU1CAtGShrJRc/ysaY9yOevv7UlJH9JO5slnvKGU0GRsk5cKPd5oDKxCToav/K4yQAlz1OlhiD60HN1RjeByy6moHRDDx4VKcs7ErAbwp8dUZ8xsxSwixS80MfW9J0Br80rfhPjOpWj5YRYb8EaeHo0eRLOG6ODXCNsBneeB64b6+bqEW6laePIApQSzEBH9WgcdMVlrGxMk78nRTCDMSSEJI/+2MKLH0fV9XBHlP6kL5GZr7uhazhWV80XuhkDqcKTdabefTv1HR3Wq6QD1rlhmG60f+JS8/P0o1Qsw0GFXtkRyBhyI3RmK0t/o+z3KkmPZSJeRfO3GMLxzw0emHwvS0DQWAtK8x895XH6IZ7qeFpSjiuV7c32veG5T3PAu3fqzzpchdujiwI7CVGrm4W9oIfwU8nx3Vu86+ZbjokysI8f0hqn6yPinpVMEUsw6BlG
 unB5fj2L
 ruIoATN/GdZXltXJzSYpbEjSNAtnbuUEjXWmSh7Fcy+sbYWC4zECz13HXAwrxSAhTQesAEXGbW+ST5CYDIs/BsrmsicX/eNAz7Y3tQHCE34+Ch2ZhgXfiCBrggFW+ptn+iIptqyU+qGzX0TPuwcUZds6qsWsgXAOLzS6mAD5wGb//AFW759pY/ebt0qBcoPolM+yi5RQWAhPpWd7GN0u2GgM23CYaoQmFQyOXxNvn5I5CYe3otR6ZQYKISjhsgtebcOWwnrgvfo9K8fzj+eiL2VebOfIrIQy0EQ6s5HQDzFmDb9Mtq+r2uGcY1uPoJK54Rv213IQ6HoGo9TfKwNeGMv5H3v2cYUIpJ46gID9Xo2PIXL6WZxMab8B5wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 08:58:33AM -0700, Linus Torvalds wrote:
> On Thu, 4 Jun 2026 at 08:53, Willy Tarreau <w@1wt.eu> wrote:
> >
> > > It looks like you're actually doing exactly the thing that I thought
> > > was crazy and wouldn't even work reliably: you change the
> > > common_response[] contents dynamically *after* the vmsplice, and
> > > depend on the fact that changing it in user space changes the buffer
> > > in the pipe too.
> >
> > No no, it's definitely not doing that (or it's a bug, but it's not
> > supposed to happen). I'm perfectly aware that one must definitely not
> > do that, and it's a guarantee the user of vmsplice() must provide.
> 
> Whew, good.
> 
> In that case, can you just try the vmsplice patch series (Christian
> already found a bug, but I don't think it will necessarily matter in
> practice - famous last words) and that test patch of mine, and see if
> it all (a) works for you and (b) if you have any numbers for
> performance that would be *great*.

Yes I wanted to do that and noted it on my todo list yesterday when
noticing the ongoing discussion. Just been super busy with yesterday's
by-yearly release ;-) But at least I wanted to share quick feedback in
this thread about existing uses.

> There aren't many obvious splice users out there, and even if they
> were to exist they are typically specialized enough that you have to
> have a real use case to then tell if the patches make a difference in
> real life or not.

I totally agree, that's why I want to share some feedback. I remember
years ago when splice() was broken in 2.6.25, there were so few users
that I was the one reporting an API issue to Eric who addressed it
early by lack of users. And I even consider that due to the very few
users, it's even acceptable to slightly change the way to use it if
it can provide extra guarantees (like requiring a capability to access
non-anonymous pages for example). It should not break that many apps,
and as long as they can preserve their essential benefits, I think
most will be OK to adapt.

> So you testing that thing would seem to be a great first test of
> whether any of this is realistic..

Absolutely! 

Willy

