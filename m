Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 678C6CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 00:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4156F6B04DA; Mon,  1 Jun 2026 20:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED266B04DB; Mon,  1 Jun 2026 20:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329DA6B04DC; Mon,  1 Jun 2026 20:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB166B04DA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:28:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5B1B1C0A92
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:28:28 +0000 (UTC)
X-FDA: 84833086296.27.72923A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18FDB120002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:28:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TwGEmlgk;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780360107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Slg9d12DIpflrilD7A2AKj3teZ7pACuCN0yNTcRFtLQ=;
	b=FL39sevVn8Qs+0qM0R9mX5tfF8gsp5PL4GGqOR4LCg+YAQ8Mum29un6/UJRqiZ4lrt6LhW
	HlD08ZnmI2F2B9b9LNUhC9IFubuYBuGM6kEag9vY4sqVOKhVAEZju+C8oc2yMSXmqp5A6G
	k/MdmQHljfxDdruJGHnpDTt4YFCfEts=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TwGEmlgk;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780360107;
	b=SVlxv9zgvvRDVoyiB6DaC/VzanrT48vx9PzhdVLnAIBmTmpzW7JT4Bcxi1YR8NQeAmbsRY
	40bvB4oe7Gy5fN2S7VbBGgSIJ2TugJznfq2S4w2yfRxCquKplue2Dq21Gl48HvTMWQgn/W
	qPvps7bM0+KMgV+JdJfhPSywhKQIYaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A55E6001A;
	Tue,  2 Jun 2026 00:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A011F00893;
	Tue,  2 Jun 2026 00:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780360106;
	bh=Slg9d12DIpflrilD7A2AKj3teZ7pACuCN0yNTcRFtLQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TwGEmlgkOSCqITM58gG6pT8IVelTAcsMweMr/i4OOMCAtucX/zJUxGFLy723fHJ1G
	 2zlZx5fxbmhgSh+6f1UJERPZ+etSvyv8toosvcWhnhuWo6IZGx2gdxEPCnM2ebBfjO
	 WPCRazYPlC4PvMA51SubT1XwysVby5d6Cgb2Sz3c=
Date: Mon, 1 Jun 2026 17:28:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds
 <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>,
 Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-Id: <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org>
In-Reply-To: <20260601160455.2c187574@gandalf.local.home>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
	<20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
	<CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
	<20260601173325.GH2636677@ZenIV>
	<20260601160455.2c187574@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ou1be4fpo8ntfjzgrhynp37uyp16afxp
X-Rspamd-Queue-Id: 18FDB120002
X-HE-Tag: 1780360106-61482
X-HE-Meta: U2FsdGVkX1/2an70pj63UYrd5/wMLRsaxd076PDC+Fg31/h69e47bDrF3jpZNMc8dFbPHqJEOLAcNJeJIzLKGhKSj524hcXMLmMqalPPO9CALEGlrxxLT0KFZrxNfhgGWc2H/liSTaB5LjUgQde/RW7k1Wsnwsa2NGNfLBdz6pLHksgnfE9daqDRw5we8iMALGy33H/oM4g28VyCxrYijtIpMXwOuEPbukTWk2mGHC0AfVs9cs2PA09OfW+f3sZpg9ifhFVi7YKUuIQyhCWdxMXAhdQSs/R2Xois1kGQ/4IdWbw3YoeVkx6Fhk9RPpEasjRqF4RF8bC4XAVKaYhuKXx7abE7H6Zi4JKdjZA6jxAPvvuk6VBazK6KdPmvnQ2x2qETnrBanRTTGbkrZYN2NaNphM/wm7EJfLgbL7bLcUBaqphO79eNAfr0jGtgWG8YSdIGQB3sOQUDV5R+rKgi+clblBaxBEPuhEQQnBmYVkWXv7OaQFOlzy7dCaHkacpKmmDHX4yXAZf+uLL0M7ecD65m8wNMQ+lxaGLZ9KHG+MtOYPeJfDM8YwBowZXofQgN5BdI4ksiq86Mu2gAGljXLogFyn0ARr2q6XZCI3RAv4DOntCzgp8Xw9jTtV3C7TXYRSkfdesjTWvgMuEKG9rLlc4SR/Du9M277y0kvSbuCkTaLni9/L2w0PZSx48omON6tbQgytTB3UQzTYVQnA1ldrKrx4Yg4UuuPDcbjL8xLIKuq8DAcyeZBKrg22uUffV2KRFzwk/6JJws0dto/iI8xnMmC4fXEz86e3MHcU4ex3eCqSltBah7I8STfQ7PZknrX7Qa1PZMQDtA+qtoupJCNXqiEbeZvVycrLRcSrM76UsZpsxRR+uk5KPa7N2glNNkLzaOSkeJGlDFT6GjOgbTLLKUVyUeOFKYyrLWvO4g9W+WDrfB7i8jl9SPLqAa3MsqC8Fa4HhY5t70RsdJRnK
 IPQcH+uq
 BXbNSZUU/DlZCTkNiTgpqYSoFpA6xGMPiooD/u6ZAnv5ZH22UAmrJ2fTbAAdQmcq4Ru4srQvMWgVtLITtq5MkQMDdNFG0ZvIs3UPlr0wWqqoWMXskW/3FDLSrVvEs9Ah60iJaXUVUUZGf6lbW1oiCaOFGoguTPjdbBE4QllRMrxNVXA2ixN2+4uVSJNX7wYm7GTnIYNgrLL1y6MlW858KR/iFbutitC6bTVWohv1kzCg5PuXLH0/gQKHf4Mn5yMhl4DvSQk+QKXOoPRTTtHmbva63LntbGSeBKdSvTecGCwKHVHIO+f3T/uNlmpMEGrf5DWlPF9x/kmfO0B7GXCZyNfIP4CqF2cB3vBvghl3uRCCrCVmLU9LvdAED5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 16:04:55 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 1 Jun 2026 18:33:25 +0100
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> > 
> > > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > > a big simplification.  
> > 
> > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > Communications between the kernel and fuse server at least used to
> > seriously want that, so that would be one place to look for unhappy
> > userland...
> > 
> > splice-related logics in fs/fuse/dev.c is interesting; another place
> > like this is kernel/trace/, but I'm less familiar with that one.
> > 
> > rostedt Cc'd (miklos already had been)
> 
> Thanks for the Cc. The tracing ring buffer was specifically made to be used
> by splice and the libtracefs has a lot of code to use it as well. As
> reading the ring buffer literally swaps out the write portion with a blank
> read portion, that portion (sub-buffer) is used to be directly fed into
> splice, providing a zero-copy of the trace data from the write of the event
> to going into a file.
> 
> trace-cmd defaults to using splice to copy the tracing ring buffer directly
> into files to avoid as much copying during live recordings as possible.
> 
> Whatever changes we make, I would like to make sure there's no regressions
> in performance of trace-cmd record.

Well yes, The patchset seems sensible from a quality POV.  But to make
a decision we should first have a decent understanding of its downside
impact.

I haven't seen a description of that impact in the discussion thus far.
And that description is owed, please.

I assume a small number of specialized applications are using
vmsplice() to great effect?  What are those applications?  What is the
impact of this change?

Once we are armed with that information, is there some middle ground in
which we de-feature vmsplice()?  Fall back to pread/pwrite in the
tricky cases and still permit vmsplicing if the application is
appropriately restrictive in it usage?

