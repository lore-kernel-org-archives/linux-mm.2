Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AC3CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9178F6B0088; Thu,  4 Jun 2026 12:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7EA6B008A; Thu,  4 Jun 2026 12:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DDF76B008C; Thu,  4 Jun 2026 12:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B91A6B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:09:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03BC6400E9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:09:57 +0000 (UTC)
X-FDA: 84842716476.10.7EB2442
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE2C4A000B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:09:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=TElWUM0s;
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf15.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780589396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/e/KFECQ0nVdisZcQGbObkQi59gFXxoiirNSRFoeAU=;
	b=nUTeDdolumd4u+kBp5QsOW79sfAMJnppZbIEbL3mvA4rTBOAZzmhzviIjLMMlMarWJeRyc
	MOiwf6QiKUlwDczsQ8A6Oz8xcDyGhwozi6dzumLWMK7jRBjO/EoMNXaJLILX07fbaQdozD
	h0iXEIVH5nZNroKlScPfMYifdfXXquI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=1wt.eu header.s=mail header.b=TElWUM0s;
	dmarc=pass (policy=none) header.from=1wt.eu;
	spf=pass (imf15.hostedemail.com: domain of bounce@1wt.eu designates 51.159.59.229 as permitted sender) smtp.mailfrom=bounce@1wt.eu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780589396;
	b=b+uwXYLSmlTc2oa+50S9IcQIz0DlKwJtpYj7kcJhL2azvtBP9naeus1WfUB6sUFvX8Rrsc
	lgONPgBZoHPVLq/e9td3DdaRkHwDqErVHsOwUnt6ifK+05J+1q1wQ7/bhe+CeDVmvP4hbb
	QBEojr7mhxigSvWxD5DEMxrrNx9MKmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1780589394; bh=y/e/KFECQ0nVdisZcQGbObkQi59gFXxoiirNSRFoeAU=;
	h=From:Message-ID:From;
	b=TElWUM0sOEBUzobw2i+ObteZadlxtBDeRmHqCRPCvh5A8JvN3VVhCrmkxgCvned89
	 gmmyp3Pp+k3E4V5MOhBKRMkYMNO+fi3SWg5c7mqTFtLTt5SRePYS6NF8eqRvdPqZMy
	 zGRiGXJVHF2QJGmtNzwVRIVXrzMUAuNzP2a//igE=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id 8DE61C0BB1;
	Thu, 04 Jun 2026 18:09:54 +0200 (CEST)
Date: Thu, 4 Jun 2026 18:09:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <aiGjUqI59e966oBu@1wt.eu>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV>
 <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
 <aiEb8CTM-ovMIq7-@1wt.eu>
 <CALCETrULMixRGJyGqAAujW7RN6PP2f_Orn2Y_0hpPMjRqQnY7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrULMixRGJyGqAAujW7RN6PP2f_Orn2Y_0hpPMjRqQnY7Q@mail.gmail.com>
X-Rspamd-Queue-Id: EE2C4A000B
X-Rspam-User: 
X-Stat-Signature: hm3kub51639zoxup7b1p131yb4n8u6it
X-Rspamd-Server: rspam09
X-HE-Tag: 1780589395-637686
X-HE-Meta: U2FsdGVkX1+79ZxQe5gW9eHmyuXVd09sC2QArosxuQK5vbH/32TXg26slfF48TP2KmOYeFM4DMXCQuqXqQR89teySkhye7InV5m0Gwt2An24Jphrfz9Up5Bo9G24TkAWxQPZeIlB4QqE/KxqCQWl64aAiKdI6ItVQTVgT+TW4gMpyB3ey79feN4cQu0Rm75+4cnELKfgNBk9uEve5ouazw4PhFL8XCXuyT8AouUSLWdKOf9U0IcI1pRTAzNet+lEkywDwyB2jWq192vzoRkFenbdfolk0hIq+0kTuGjQcm/kFdSeKvlVyAX63EIFoxeGv+AQyRAepeZQSY1W/iMJq88OXbHsZhWaJdzfy/I3rtn3bAUbD0nzrZpF2UW0fXBZU7oh16iypZF2ToRugTmfp0pxm4UkGzGrrH7Vqa4sKoBY1vFpEg0/cTR0mIYkFsc1UIbg+D5nHPmQP/9z8yyznd3PWyeNuJQ8WpQOQ+WBFmhUtdiwLThpwwZ/AZcrMXDh32wssccGPiiqTHrHJj+xFSXZI++oUxJXwOKP+dtqR+fAp+RcTtGiENlp9SQKdfkk4s/p4KYDFFzApPnb8By9DjKOVNGOV2wUYQrYkg/BMhk9ZvKp753rJOTGV4Bm81y36NmbXumVbzP8AwDUc0SZ4/1WpxpEP3atql3VW5gPzmoc2cMj4Km9BQkQlgEW8w3TrymOaIO1XddQg13Oq7KewrpIZKQ+oRkKxMt+rkcLe724apNQRCPPfCuZAJgsQ3Z05yXIymRzn7/qne2o2ny/oyboPvpqQWc442gX03wiq9MtbrfVxHYUwxQMAjZHMH5eLJeogTU1/q9dgYfsGb22HXzdec6Ipga5m9ccLjbht/jf/hvQ8aGbkJVZ5CdVcCRrf4TEvqUNt5U35AY48Y+iKWt8QKJKqI4tIo+1lmOEJ4maK1tN40/64ndJZ1XPYoVkOcOCFj7EQCyBDax6dLE
 AuTzvGY8
 h1HGGxEa5eOqSRWv6eqFF3cA+RfzH1UnSYdTLlD7TcnS+7BlLtsNElMFXeA5TVv/Ex3HudfAupl/NuvI/XEWmZqeDvZnWifXV5skLp+PIpLfCkAe4EMneDVlE9o0bh9MBi7WPOGh0X6MmEErsuqk5UzTZUUWREwXtb83CSykYUWlFSO6TPU/V0ZheiLkOnVjPy6Dr0QvqIbdOC1vX1RfqDEOQ5bLAXLOzFqOuozLJrx4s0p9bjW3UZmxi9ElL/pJCEK9Xvc8fXVtHzptNUs5P2eByMzrB/1EwU08QZHAmyGJGbc4MZA0F+pcQ6X6WSOcTVu9iOExdwz0gu/Alm+27KBs4KQAP8tbh8tkeRDJEr0Y7qdwcYndDqnY6V1ASG6yyYMF3hgPdWB0yA1odlVXGpxtiFTQETujbuCKwGHrcJKE31JXOeiZZDqne6b2PTlUglh1qzQoBaYNAGt/XqEBiQVqmSuODINb9xBM+g7ScOg7pAK9rnC1l5gCvH9HSoNqkI02AIpnGnRxhn85MAJavgxelXesti5+UaJujuUEG0DPpJg5FUSQK57x8T+LMdEMRNdrvW3Xzm99sgM4sL37bf7eD3wwPAbtUdCrzxQ6qa5MEEjyvht2xSuFj3X5lRAJF7YvcaJM6CF+Y/ZzDjocp7HTsh7mbxOU5GXdEv4cWio1hgHFHogBTmZv3W0Eh5QvRqJYMzVwl9kigD298/abhlISTEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 08:53:15AM -0700, Andy Lutomirski wrote:
> On Wed, Jun 3, 2026 at 11:32 PM Willy Tarreau <w@1wt.eu> wrote:
> >
> > On Mon, Jun 01, 2026 at 05:28:25PM -0700, Andrew Morton wrote:
> > > On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > > On Mon, 1 Jun 2026 18:33:25 +0100
> > > > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > > > >
> > > > > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > > > > > a big simplification.
> > > > >
> > > > > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > > > > Communications between the kernel and fuse server at least used to
> > > > > seriously want that, so that would be one place to look for unhappy
> > > > > userland...
> > > > >
> > > > > splice-related logics in fs/fuse/dev.c is interesting; another place
> > > > > like this is kernel/trace/, but I'm less familiar with that one.
> > > > >
> > > > > rostedt Cc'd (miklos already had been)
> > > >
> > > > Thanks for the Cc. The tracing ring buffer was specifically made to be used
> > > > by splice and the libtracefs has a lot of code to use it as well. As
> > > > reading the ring buffer literally swaps out the write portion with a blank
> > > > read portion, that portion (sub-buffer) is used to be directly fed into
> > > > splice, providing a zero-copy of the trace data from the write of the event
> > > > to going into a file.
> > > >
> > > > trace-cmd defaults to using splice to copy the tracing ring buffer directly
> > > > into files to avoid as much copying during live recordings as possible.
> > > >
> > > > Whatever changes we make, I would like to make sure there's no regressions
> > > > in performance of trace-cmd record.
> > >
> > > Well yes, The patchset seems sensible from a quality POV.  But to make
> > > a decision we should first have a decent understanding of its downside
> > > impact.
> > >
> > > I haven't seen a description of that impact in the discussion thus far.
> > > And that description is owed, please.
> > >
> > > I assume a small number of specialized applications are using
> > > vmsplice() to great effect?  What are those applications?  What is the
> > > impact of this change?
> >
> > > Once we are armed with that information, is there some middle ground in
> > > which we de-feature vmsplice()?  Fall back to pread/pwrite in the
> > > tricky cases and still permit vmsplicing if the application is
> > > appropriately restrictive in it usage?
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
> >
> > So we effectively use vmsplice(), tee() and splice() here, and for exactly
> > the reasons they were designed: only play with page refcount and not copy
> > data. The code is here for the curious:
> >
> >    https://git.haproxy.org/?p=haproxy.git;a=blob;f=src/haterm.c
> >
> > and its ancestor is here:
> >
> >    https://github.com/wtarreau/httpterm/blob/master/httpterm.c
> >
> > It simply doubles the network bandwidth compared to not using that.
> > (62 Gbps per core vs 31). I would seriously miss it if I couldn't use
> > this anymore.
> >
> 
> Wait a moment.  This is neat, but it's literally just a benchmark,
> right?

No, it's a benchmark *tool*: it's being used to stress production code,
which is important and super hard at high loads. You place it after your
proxy and you measure the performance of the proxy (which is supposed not
to be as capable as the testing tools otherwise the methodology revolves
to testing the testing tools, which is not the point).

> I skimmed the code, and it doesn't look like a production
> workload, either.  And you manage to get around the awfulness of the
> vmsplice API's complete failure to tell you when it's done with a
> buffer by ... never actually changing the contents of the buffer.  Do
> you have any idea how you would write correct code that uses vmsplice
> for sends and then *ever* mutates the data without literally
> munmapping (or madvise or something) the data do you can safely mutate
> it?

I'm not sure what you mean here Andy. I *do not* need to change the
data, it's just a pre-made pattern.

> > I also have mid-term plans for using vmsplice() to deliver contents from
> > a cache to sockets as well via splice(). Right now our cache is split into
> > too small chunks (1kB) to make that useful, but as soon as we can move to
> > 4kB pages, it will make sense. There the same gains are expected, and I
> > would particularly dislike the idea of no longer being able to implement
> > zero-copy!
> 
> If I'm understanding you correctly, you see (and measured!) a
> performance improvement, and you would like to use it in production.

The prod for the tool is to be used to benchmark other tools. It does
the job quite well. It's even more important when you use kTLS-enabled
hardware where you can get zero-copy all along the line and delegate
the crypto to the hardware. That's the beauty of all the nice work that
was done in the stack along all these years. That code started to be
used in clear maybe 15 years ago or so, but nowadays the gains are even
more interesting.

> It seems to me that this is an excellent opportunity to remember that
> vmsplice gets a performance boost in a highly synthetic situation that
> sort of resembles a cache scenario and then to deprecate vmsplice and
> build something better!

I've definitely been keeping vmsplice() on my radar for our cache,
and we've progressively implemented various architectural updates in
haproxy precisely for this.

> Or discover that we already have something better, perhaps :)
> 
> https://man7.org/linux/man-pages/man3/io_uring_prep_send_zc.3.html

io_uring is different. We tried it "the dirty way" in the past, by
emulating a poller, and it's not worth it this way. And in order to
do it the right way, it needs to be done totally differently, which
has impacts all over the stack. The code in the file pointed to above
is just for the httpterm testing feature, but the rest is much more
complex.

> I see that this can submit a buffer without a syscall (tee + splice is
> *two* syscalls!) and that it has directly addressed what I see as the
> really big deficiency in vmsplice: "This second notification tells the
> application that the memory associated with the send is safe to get
> reused."  If I were writing the user code, I would very much want that
> notification to be an explicit part of the API instead of making a
> wild guess as I think I would need to do with vmsplice.

I agree, for the cache it's something important (not for the load
generator). But IIRC that's something you can also check via SIOCOUTQ
which is normally sufficient for a cache's eviction system (though not
fantastic).

Willy

