Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6094CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 15:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C596B008C; Thu,  4 Jun 2026 11:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C6C6B0092; Thu,  4 Jun 2026 11:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49A16B0093; Thu,  4 Jun 2026 11:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A482B6B008C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:53:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C1FB160EB0
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:53:42 +0000 (UTC)
X-FDA: 84842675484.25.1CD7ED9
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	by imf16.hostedemail.com (Postfix) with ESMTP id 72AE6180002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:53:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=aaJG32qR;
	spf=pass (imf16.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu;
	dmarc=pass (policy=none) header.from=1wt.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780588420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juT3AhUSnv3+LEExiQBNIpyMhKj+7Ht6/Ub5bBjOybo=;
	b=VgNsliD/NBhOQ9TvclS6Y3oKe37UVGFIYv/FXrqgWB7Owf2A5G6sw5Ckr6Y6PC+NjXsMr0
	dzsz39vBbcZxQqaaiq72yERQ7ZEMBH7MgM50LNCVd12Z9Fk4Crvr+iHZCB27JhI7pSn7Ix
	vUi6WwWppNkqAxrPRb3f3C59AJypNVw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=aaJG32qR;
	spf=pass (imf16.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu;
	dmarc=pass (policy=none) header.from=1wt.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780588420;
	b=C6QRej4/0MbzT5qCjRdJt9STi2uTQl7H/MULx/ZG4Vha6Ai724kEbHL7bxd7MHmvp3966D
	evvjcjgh9bf4gENlaecYDw28+p29UbxgtaJRuAzwlwRbZ9QuT920Af2uo6qA1apys+FgmL
	JlHsNb812O+a3dEGq+s/G3YzWOkvjXU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780588418; bh=juT3AhUSnv3+LEExiQBNIpyMhKj+7Ht6/Ub5bBjOybo=;
	h=From:Message-ID:From;
	b=aaJG32qRMUOIDg915/7kh3rDdW4vh2IvOB/PNr31yOeigP7OiDM0YHIhZoiZp8UMr
	 NjXu6O405jBSx5uIwefKURTQZonCG1DnK7RxtvWKkjkUveM2Rqq1sV+8PrM60xISZy
	 s80aAPevr1LZI2sSO5N94ajr5iCOo4kiSDrTDoDw=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 4A2D1C0ABE;
	Thu, 04 Jun 2026 17:53:38 +0200 (CEST)
Date: Thu, 4 Jun 2026 17:53:37 +0200
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
Message-ID: <aiGfgRch99l_5z11@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 72AE6180002
X-Stat-Signature: 3h5adjkrwnt11rec4fqy7gk1ynzs6uhi
X-Rspam-User: 
X-HE-Tag: 1780588420-733179
X-HE-Meta: U2FsdGVkX1/NSqavIKgiVnOKkpsLiDoAlKfIzZdY6kHfiPULHjUYXJ/1tnsV++M81z96/t+k8O5pxyYLZ0vQLCzywoMobl5Hir8o2ZMg3xF3SjHz9oUEXvtWRbQOt1nPEEvPiqsWLbIj+TMvTbkpiljXpCiPWjxbMpDpu84Z9/dJClf3TlA3E4sW3sa7IJunr2pGz4cse8X2q5XC/22oByig7KrgaqwrupYjB5DsHJgvNvJEuFejFDWxOMkrQPZdlzMbW4D8JAd1L/nk3u76uHXeA2JcCALC7FoduYM8cR6jZDxc0VP6sNoSpO0Tk8itp6k+OseeJY7yINJ5wgh9WGtulSLyNzRqa59KyDVZMACdVHxydP6Lm/98g6vMVdKBYW35xnz3njmHAaJZ+r9agpszYZWzBMF+KVgxIp0NBzaSpitfZtCJSkcG20fTYMT8gNl8I8/lPoscLQW8v9+GQRA7mtkfaomp29NLm/+qIxYWBuQDNRU+rU0mrJrghI/56ncsIrmgFlZn2YhF7Vcjz1yEUTseeVLBIxoAPyTKqEMSSbU5oehY7a3cNj7QirUKrcoeo3prCiOp/iXLor61nKuKnmXkxaJ4JFFV5hQQWYvBqo406P2ZxYz+AeemN+ZTGdwRw2cI9jmq7znzKiO4x37/qDyMIzeMHgIObaTOKNFgtghzDemNT+b2rLo6amrzZVPmCVVD+X6bdiy76zue2u46KqFfENkJix+GpkCvDyR6Lst7BF1bia0IRQUuJLMpXXAO08pquqoc4jXMlnt16WDZljO2H7DWgpQcB3SttwNGkVpbEtVtp7nw8nS7Bed+33DlHcbodNs98eBxAMFGLNvk9j+keV81CYEAbaxcNcepc9cgCs0PNULcDXzp5YC8cchm1xT408GCbS8eG/KBYqSXXpYGYfzfsuWRDcfzY+/rcNjR3QJP7uk6IgAYkC7LQEi0GFRktKrEhKeKH7S
 KgGjqtEv
 5n8U9MlgZK4LmThrVSTs8bpMm9+6R8dTRFOi+wK9jXf/5u4AOIEwV07m9tJ/yNPY+4ai0aFo6TPsJob3TV98106xVBYIh2G4YQw4S3dJgSPDzKVPSnRL2p5THh2sr9Cvxp8WsdxFD8eIZztIZUzb3EkF/2+/kzs6977sXcdgsjJBYxrn+TQ8ibf11vNOpyMvT8lisIIQ7e4BGKgBR2P94073nV+f8ZK3l2kwd4M4r4FqiCQqd6sSbO9IALJUHjZXyppwWjsH1RcctOQQEerfAy+7V3eFFAfNX6MVoCOVK4+CvtECge2qsyNaRaSDW36Edb2GCysG7gF6pZq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 07:31:30AM -0700, Linus Torvalds wrote:
> On Wed, 3 Jun 2026 at 23:32, Willy Tarreau <w@1wt.eu> wrote:
> >
> > I'm using vmsplice() + tee() + splice() in high-performance applications,
> > load generators to be precise, and soon a cache. This is super convenient
> > and extremely efficient:
> >
> >   - vmsplice() is used to prepare a "master" pipe with data to be sent
> >     over TCP or kTLS
> >   - then for each request, we do tee() from this master pipe to per-request
> >     pipes.
> >   - the per-request pipes are those that are used to deliver the data to
> >     the socket via splice().
> 
> So most of those would actually not be affected by any of the existing
> patches: the pipe->socket splice would remain, the tee() code would
> still just take a ref to the page count.

OK!

> The vmsplice() would change,

OK but for this use case it's not dramatic (it could be more annyoing
for the cache where I'd like this zero-copy from memory to the wire
though).

> but looking at your haterm.c sources, it
> looks like it's mostly a fairly small thing ("common_response[]" being
> 16kB).

In this one it's indeed a 16kB block that is repeated into the
same pipe by simplicity, in its ancestor it was 64kB. We try to
make as large a pipe as we can, but that's all.

> That is typically *faster* to just copy than look up pages.
> 
> HOWEVER.
> 
> It looks like you're actually doing exactly the thing that I thought
> was crazy and wouldn't even work reliably: you change the
> common_response[] contents dynamically *after* the vmsplice, and
> depend on the fact that changing it in user space changes the buffer
> in the pipe too.

No no, it's definitely not doing that (or it's a bug, but it's not
supposed to happen). I'm perfectly aware that one must definitely not
do that, and it's a guarantee the user of vmsplice() must provide.

> So that would break *entirely* with the vmsplice() changes if I read
> the code right (which I might not do) simply because that looks like
> it really does require that "wrutably shared buffer after the fact".

We agree that this would deliver complete garbage an I'm not interested
in such a "feature" at all.

> Interesting.  Because the vmsplice() code uses get_user_pages_fast(),
> and honestly, it never pinned the page reliably to the original source
> - it breaks COW randomly in one direction or the other after fork()

I must confess I never knew how it deals with pages shared over a
fork(), and have been wondering if two processes could create a
shared memory area on the fly just by using vmsplice() on each side
and end up with the same pages (I don't need this but it could have
very nice use cases).

> (and I thouht even after a page-out, but thinking more about it the
> swap cache may have made it work for that case).
> 
> Uhhuh. That does look like it makes the vmsplice() changes untenable.

No no don't worry, I'm not seeing any value in changing data after
vmsplice() and that would just be a bug. My goal here is only to
pre-fill a buffer with a pattern then prepare the pipe with that
pattern, nothing less, nothing more.

> But I may be reading your haproxy code entirely wrong.

I think so, but I wouldn't be the one blaming you for this ;-)

Thanks for the clarifications!
Willy

