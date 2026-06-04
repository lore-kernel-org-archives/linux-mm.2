Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1E7CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E276B0005; Thu,  4 Jun 2026 02:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F296B0088; Thu,  4 Jun 2026 02:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35046B008A; Thu,  4 Jun 2026 02:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A24286B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:32:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9737A0628
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:32:21 +0000 (UTC)
X-FDA: 84841260882.24.93AE497
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	by imf31.hostedemail.com (Postfix) with ESMTP id F2CFF20004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:32:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=jpkB2nzY;
	spf=pass (imf31.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu;
	dmarc=pass (policy=none) header.from=1wt.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780554740;
	b=2PFK8qtwMhFx8OdaBIhW7WyasiMeAdR+g0jjltGL2KAt/jFaJpHOfpEJlaXu/36QpWG6YO
	XRASDbuUM9T8m8AJh8nQMNR29G4cfirC3st7eX1eCgFBW5S4aGaxKoDnjS7nAyR/whP/iC
	IGveNpH6f2sXDly0l3rr7QaqLc+2158=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=jpkB2nzY;
	spf=pass (imf31.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu;
	dmarc=pass (policy=none) header.from=1wt.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780554740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9nwLs4KwMwQ80PQ1Q3ExZLliPxSXG1vTX5NNZIw0Hg=;
	b=Np+n04rBb2r0wvutZOoA07jBfetEH/qid5lyxvn5Az1hOnub82ppDU9w4gN7LhmhrG6ss7
	3S4Qhcl3ZhVGQdfJai0wUbozS+DaOaGdkNGwPa/wE0AiQSsDGzxiLqtJ8bHKXGpE1LY+N+
	5ZGsOvJjvsaf//UF2sstyEisGu2BwEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780554737; bh=D9nwLs4KwMwQ80PQ1Q3ExZLliPxSXG1vTX5NNZIw0Hg=;
	h=From:Message-ID:From;
	b=jpkB2nzYMYFGJLo2yxhZ7zzA+WhfbH6IPBDq/rnj5kwadTf4T1dykNg7QvtDS3q/f
	 X1+Gc6B00HW6CKs9VJ9MpDO6InL90L1sxTWsIl/GvAc+96Vwhwlca0ShHaEEmf4bvI
	 0SMiD+Gpq2qOzkk1UhzhXudoxeVA4OeVV8ZoBGyc=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 989C8C0B73;
	Thu, 04 Jun 2026 08:32:17 +0200 (CEST)
Date: Thu, 4 Jun 2026 08:32:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <aiEb8CTM-ovMIq7-@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
X-Rspamd-Queue-Id: F2CFF20004
X-Stat-Signature: yagtdwfhsxeirn43jiha9opn9b1ak9yf
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780554739-802802
X-HE-Meta: U2FsdGVkX1/AQhEeGqB5kwOTKI1uJafH6nBgAgMPc1V8zvBLvBkrMIexE05pDhFDQPLa+2wDhc2uRlfDC3+N+dZzI7IYr7q4tqs73OfmMeeYNQ36jsEWTiawjwATo20NhxuVqbh2XDiD8HcUbkI9fVNabtyjOfg7PUsvJAPpZj2L1Uj5PUhiAHExk/m3/C9FblsBA94105H1BrVXf+ovpE+f3UFBajfw4t88NcVbxhM8JVkYmlqtBGjJ7U8ulIgprbORASHRgfcJzo2KJ8DqDSraFoaX/1V3DlX9ZAWHcko/YXMKgjZHOoMA1Ki6sXw5wUSf2my+6hYxjU7t7Tz2d0pHmph+xIkWmR8tIyv+3JjdecO7vluW7/daGUqryzcAgdDVayX7gUYJRs1HX7pFgu34thXxUIIUHngQbtLm+EOXPF6i1ovxmtnL6fa9I837O73xggzMIYxKiVKEDolpY6xZcIzy5JdPRup3zDjjTgawKph1G8q7oHsk8IbDjg3FXI6JzUWnBOtFLv4My9/DPEPKCKhPul9B3cUgUFvnh29u82gX19D7TxxVycQhPWN++uSypXTOuZq7HCW2Je/190X31q8Ek+TOHa5puwNhq9htELSCZ1jDujbWCUPZu4pkRZ/dXGCSimXBuiXh3/mFCJu+pa2kX/E+zc/c9KnCfmKoVkX4SjWxdMT0AQg5jwYM5voK3FEXFih7eUPABD5FerIdkpsa1zwnBhBV00wHxcLxja1Ol11Tg77l765aqfWSGnCcxrxUr92q1EzSywEMl6gj4B/9ic+bmjBjHEpCDjsEb4rOef+R/YEOmcVk/7hh/Qb2tSijG2pUBVRlLZGOHgpSK1QYThaBprYkLPkCysZtAqk8e/ecw/9xJTE39KJAm/r5MY7CfNKaM9S1tlIQ53Pd1gj/EuQCFXC30a+jVLqTiVEXvau0K4XRTZ5YvL4sNW1FzfcBoF/UzCFgtyJ
 FgqhRz99
 HgOBaxMKgcq9ciOQIaR6dKx/O/r0kSULGGMPKK23YWgfdjjIt41McsyW7cECOzjT0AJjAiZBqrV30ta7bkdENSey7EZzY4jfW+JQ08Tfd7IBf2iwVchNyubFAlFEg42kYp4tbhOmBRq8edbUcKnuUziVjv9NwScD2wy5wL8HaiaUrYX0T9VzQq+yZEPioZuq+pZ1QkeJ0ESXYHyRjjbli1CcNbMK3sw66X7J/a4lRNCTTccnbXIK8Hhzt53WzfTEfSTZr/NwdvrIbeFHh4sU32E5KsfayT2yXseOab/VlXMcfos/Hmmrlz5KRX4VghzZj+MS4lp2zSuveOaNN12ajJDrKQm1HlluLDSGD+aitek5kuTAmkTdr9farAof+qhIoiO3nY0rPEh2rnm46o+7XO0fIcP4siT6dsWcQKhtR4K0bzS03SIXyeIgnXVSqRXDnX4IV4FDY+/f5tkdDggjZRu4xyQMrzTLCnaXsGddylEn/bStn+G8QGAugyLq0/yIinXyHmCOhsYlbu8RWVWuA/IADAMncDFIw2uYJ0iCraOva+tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 1 Jun 2026 18:33:25 +0100
> > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > 
> > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > 
> > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > > > a big simplification.  
> > > 
> > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > Communications between the kernel and fuse server at least used to
> > > seriously want that, so that would be one place to look for unhappy
> > > userland...
> > > 
> > > splice-related logics in fs/fuse/dev.c is interesting; another place
> > > like this is kernel/trace/, but I'm less familiar with that one.
> > > 
> > > rostedt Cc'd (miklos already had been)
> > 
> > Thanks for the Cc. The tracing ring buffer was specifically made to be used
> > by splice and the libtracefs has a lot of code to use it as well. As
> > reading the ring buffer literally swaps out the write portion with a blank
> > read portion, that portion (sub-buffer) is used to be directly fed into
> > splice, providing a zero-copy of the trace data from the write of the event
> > to going into a file.
> > 
> > trace-cmd defaults to using splice to copy the tracing ring buffer directly
> > into files to avoid as much copying during live recordings as possible.
> > 
> > Whatever changes we make, I would like to make sure there's no regressions
> > in performance of trace-cmd record.
> 
> Well yes, The patchset seems sensible from a quality POV.  But to make
> a decision we should first have a decent understanding of its downside
> impact.
> 
> I haven't seen a description of that impact in the discussion thus far.
> And that description is owed, please.
> 
> I assume a small number of specialized applications are using
> vmsplice() to great effect?  What are those applications?  What is the
> impact of this change?

> Once we are armed with that information, is there some middle ground in
> which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> tricky cases and still permit vmsplicing if the application is
> appropriately restrictive in it usage?

I'm using vmsplice() + tee() + splice() in high-performance applications,
load generators to be precise, and soon a cache. This is super convenient
and extremely efficient:

  - vmsplice() is used to prepare a "master" pipe with data to be sent
    over TCP or kTLS
  - then for each request, we do tee() from this master pipe to per-request
    pipes.
  - the per-request pipes are those that are used to deliver the data to
    the socket via splice().

So we effectively use vmsplice(), tee() and splice() here, and for exactly
the reasons they were designed: only play with page refcount and not copy
data. The code is here for the curious:

   https://git.haproxy.org/?p=haproxy.git;a=blob;f=src/haterm.c

and its ancestor is here:

   https://github.com/wtarreau/httpterm/blob/master/httpterm.c

It simply doubles the network bandwidth compared to not using that.
(62 Gbps per core vs 31). I would seriously miss it if I couldn't use
this anymore.

I also have mid-term plans for using vmsplice() to deliver contents from
a cache to sockets as well via splice(). Right now our cache is split into
too small chunks (1kB) to make that useful, but as soon as we can move to
4kB pages, it will make sense. There the same gains are expected, and I
would particularly dislike the idea of no longer being able to implement
zero-copy!

Maybe some arrangements are possible though. I'm not seeing any other way
to achieve the same things differently, but possibly that the base of the
problem is the easy abuse of vmsplice() to affect the page cache. Maybe
placing certain restrictions such as he area only being mapped to anonymous
pages, or anything similar could make sense. In my use case it wouldn't be
that much of a constraint. Well, for the cache maybe it could be though,
as it would prevent us from sharing it via persistent storage. Or maybe
we could require a CAP_BACKED_VMSPLICE to be allowed to vmsplice file-
backed pages, which could be sufficient to prevent easy LPE each time a
bug is found ?

I think that the users of this APIs are rare enough that we can probably
find a solution that anyone can reasonably adapt to with minimal
constraints. But most likely each of these few users rely on this
*a lot*.

Just my two cents,
Willy

