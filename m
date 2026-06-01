Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF725CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF2D6B04B6; Mon,  1 Jun 2026 16:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7216B04B7; Mon,  1 Jun 2026 16:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECCD6B04B8; Mon,  1 Jun 2026 16:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3AE6B04B6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:04:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C32D91407A4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:04:17 +0000 (UTC)
X-FDA: 84832420554.22.BAF1DAA
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C57F180006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:04:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqhhW0ySu7E6Qvr6l0HrHgMOs3WrJavCJ0AVC6vE9Lo=;
	b=Gz8VkljMYZL4gSdxT6JCcBE7RaCbHf12rKaIVQLOHivRqSN6t2KZT6mG7upV3a9z3mxnuB
	nQ3p7USVEDY8L1K1txLHranCKTrqgDSKQYbLxhJ0rywghW0HFv9IjBH4HSRWvgFSBJYILA
	3gFoQx+SC2zO5TeNtkWuhjJ1lD0Gf30=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780344256;
	b=Qxj5TF/PmhObp/7w8LpprsftM/GWEPonySCoMjSpC7PV3LPbi7ysYAtiRlpFbjbolI3Jd0
	/3ADaIB0QO5fRGD998xKtmIRP7ws4HvXcsSe1+oNWm1HihrHmk8T3ClKwcgGNtaqftcd5+
	0M97ILgsp0Mo6yaBY9bt4sUBlAck4pc=
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68DA14070E;
	Mon,  1 Jun 2026 20:04:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id A76E530;
	Mon,  1 Jun 2026 20:04:09 +0000 (UTC)
Date: Mon, 1 Jun 2026 16:04:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner
 <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org, Matthew Wilcox
 <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
 <hch@infradead.org>, David Howells <dhowells@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Pedro
 Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
 patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, Jan Kara
 <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601160455.2c187574@gandalf.local.home>
In-Reply-To: <20260601173325.GH2636677@ZenIV>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
	<20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
	<CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
	<20260601173325.GH2636677@ZenIV>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/l7NpaaKPpVVcYp6ykgwcyKHOTZkMF8KI=
X-HE-Meta: U2FsdGVkX1+J41g7IAS42JSeE5M9CFGhSVLKinkR5n5mo/WYVmBVHXBpB5cbIVL47VN3NsR+c1LBVIEHnhIvPvN6NQi5OTyaalsbrZEmg3uNAU4L5pjofHBefOVOwNAzq+bTYnik8yKJTyJaiIEZ//BclFM5tzba7zY+yq3qDmo5h2ghnrR+eDolpCZLEmUU1Ym4s93HTmeKQd6vDDUtwpZKMi4L2rkJyltTU8DXus3jvdVihyyTkULc+uoUj3MmLLV05SGgEjAXDGIG29TGeb2W66WTCW47AFMcODko/oJOuCEj3D+mT6s8K8FqbmRLqPBpAFWNEmeijv9MkxLF04LGCExu8JIYiaBNjan8sjAMgUDEmR1OwJeg5Jf7Echc
X-Rspam-User: 
X-HE-Tag-Orig: 1780344249-165888
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C57F180006
X-Stat-Signature: 7cam7g5hzwhc6gruyizz1xgu7z48o865
X-HE-Tag: 1780344255-744355
X-HE-Meta: U2FsdGVkX18dZ2RjkuSoOErgLa8UJRWQUmfLEbM/xQYn4gMUL1uf+wdDkOKHREdIzDJbPwEC0K7Sg4gLZKa0gvQI7eaQcKEmTA7FF8yfO4bMxEyBAvdtZo3V+sSmZ6nxHUqJjOUgLTDqOzSUj+WIf7Y6qPHbFxPJL0SqIBcPRF8iZsZMUfM8IwRD8U+VWUjvtkO7JhWuhoalwZ6awfKajgdtJSDvAz19t2eAKLVejF/aOVhXHUgw3Ki6S19LIl5AJSIx7trRrosX+MMThXGtd8ZvPVt3On6xOcGWXlnKEXAevvGKIB6NDkgoLlVG9XP0RMQ8f4biUf81eP46bYS231ExgYzlmCP5Vaog3gKoK7/ErjeTruXO0vJyI5UrESQv4DXi1y4UWi8bEma+mHEucP5OIPkUTT9pdJMUBSW2L3QwC/2dJ7MHsY5Ag+Y4fyA1En8vpRieBuFm+IWDsx8tZB7q7pnYigWphIIMSdOswRAvRWSxCWPCkx/XmwRysraIBprvmEKn+w2Jm1eVHdXu+B1wXAWYWYRPSHB4UIKXcYIm0LXjYb6Ckg1mvAiKlmpK6DyQJWg4WeAUpQfh8LXVBriqX+6UJUNlYNUCNA7D5zSYGExf+ag54BVN5Ywffws3CeYl1EmpSfohf2g+x26MlFRqHAEY9qYfaxw6W24L/MMfavPRQVq8Rf9sm1537tZ1zM8fApk5Bsb7/OZ3zEZiC0KG07pthmmuz34qImkGo5rDs1/vE00onts/lE6kf1PgqdJ1GF40XMLBBi8j6CyPFGu6HMoyfRA7Hb50zfKuXd3Q5OvQWN5mpq9B1lHzxL9L1mcZx7/FQ2xphn+P+xWYM9pwnXVXCeyGGD6h3Ctpl0udNWJdHyHMFs3uUNkntz5k83D7QKF5sa1UuVwkEZlJpVmDwl1f5yiatTBwMDn9jmSO8dkDM+mNOM6V014LuOP7imp4Uh0+WjzsUKO70bK
 R0PZo4u0
 GzFbyngAUr1V5HRG4Rr5SFwtMxnm7Tp/i61Lq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 18:33:25 +0100
Al Viro <viro@zeniv.linux.org.uk> wrote:

> On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> 
> > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > a big simplification.  
> 
> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> Communications between the kernel and fuse server at least used to
> seriously want that, so that would be one place to look for unhappy
> userland...
> 
> splice-related logics in fs/fuse/dev.c is interesting; another place
> like this is kernel/trace/, but I'm less familiar with that one.
> 
> rostedt Cc'd (miklos already had been)

Thanks for the Cc. The tracing ring buffer was specifically made to be used
by splice and the libtracefs has a lot of code to use it as well. As
reading the ring buffer literally swaps out the write portion with a blank
read portion, that portion (sub-buffer) is used to be directly fed into
splice, providing a zero-copy of the trace data from the write of the event
to going into a file.

trace-cmd defaults to using splice to copy the tracing ring buffer directly
into files to avoid as much copying during live recordings as possible.

Whatever changes we make, I would like to make sure there's no regressions
in performance of trace-cmd record.

Thanks,

-- Steve

