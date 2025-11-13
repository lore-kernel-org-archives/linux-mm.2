Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3019CD6E74
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91F48E0008; Thu, 13 Nov 2025 09:40:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D698D8E0007; Thu, 13 Nov 2025 09:40:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7488E0008; Thu, 13 Nov 2025 09:40:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B88348E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:40:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31DF04D4CD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:40:57 +0000 (UTC)
X-FDA: 84105845754.22.ABCDF9F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A52520005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:40:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FSlA/jHw";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763044855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3938qKhYbuzzgyYcyF61d3qve5VInxvfx3DwW3/j/k=;
	b=gEFq9PAzyQL+vg/WTCVxtQ+6+ym90YszUm4ypDfxBNglK+5sf99SNjqDmbynchQ5YuUgvl
	BPtM57Hv++2GH4hfTAEQNrcCp9PpOIZfHyqm80Bp6eBxIeir/uGiOxsBJpUZzUFoukHKFF
	2tbLJKhuVKr1IxHuNZnDAplL0z8C+nc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="FSlA/jHw";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763044855; a=rsa-sha256;
	cv=none;
	b=w5P8WS0s4dQ+9Iq2Z+KakjJb7S+uzJuFUoWYM20ikX7T1hLx11nmFS6qMh7NNoPeN3QxiJ
	NqjcaFQBz0nNSqds0Lni1Wf5dDrwDX1kuO+VivbF7hNvEGuQh30r/eL7Ceb/9V+3a3Oxd0
	QnXKQn4ymuSabhW88H6RhUQLOy9mEck=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v3938qKhYbuzzgyYcyF61d3qve5VInxvfx3DwW3/j/k=; b=FSlA/jHwFkHrgr7dGQFb3BbbNE
	wCmIiFxSKkM9314Q4NymjaiZQdcvcWbnqAlBdVXyfKNRJ2yrTN7T4p8RtK9Caoi3iYDwWWAyWKSOQ
	dFd3mRg6+9DpYMrjdLufLyCQnTT6xUR1M7zMIZzllSo8ZebRVuckMdSmLK/FfgzBk4qoqBzXnuQUz
	rZf3wTh68+exFs0O9cDnsBBH58A4j6dY31TMMWHV8w1LfL9LFHexe5ySDEMtUXTukvIrTn/Hxm7zE
	51ll0Sk/srivu3V4kahdJZkZyvs1T4hwNPUX+CbxfNskJVhwPnx3QGBlQb2BWdPaK6WdsKpNL4NvP
	8hvj6NkA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJYVJ-00000007esw-0W8m;
	Thu, 13 Nov 2025 14:40:53 +0000
Date: Thu, 13 Nov 2025 14:40:52 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Li <chriscli@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2 1/2] mm: Add vma_start_write_killable()
Message-ID: <aRXt9JXI3rW1kP3k@casper.infradead.org>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-2-willy@infradead.org>
 <894ad5d2-034f-46e0-96fb-135c847e4019@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894ad5d2-034f-46e0-96fb-135c847e4019@lucifer.local>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A52520005
X-Stat-Signature: 8aenntiey6j3qxcuqp14qzufw7fukc7p
X-Rspam-User: 
X-HE-Tag: 1763044855-127617
X-HE-Meta: U2FsdGVkX1/mbvFyZNkSAaSVX7AmqnuPcG0rfHeyybNNMhoHjGr4lp6IbkhJ+2YOqsCLEhkXkAz9zIWQLLlW6MQbhEZi/YBMuM9NQh/v+krX++mmr3LTosEMG3pIY3T7Bs/uF8ZtItO1OleDgFO4iTzkHY9I5jJie/p0vHBgWMfOVQdRyvwV+Gx82uoomUlHdFSOrWXwq3LatesQ38gKyD7dK1dx/vVeaLCbEb4AjO3Q42GSVsPjqWKpjdZKe32I55JY5CZ7qpLY/+KIKWOb9icBlPAzs7dQOpTYfiTEWtBQ9MrJ3BGHlQE0YzrSXlc71MZec4yW88RMjH7bfIlVLEJ0gTfkppRQj1zNQc/WRLcfmP0lD3qn5NW/EGxysHN9usQTEfTb2jxfUWD+NwlKH0Mzo+cUUjCUkU/aJny7G83LRLwm6QpxgW8qUbZUtGG2n3KKg2G5ivkiAhA8eSJNzQCkq5eIgUwhWo/1puZ0LFD7XEZmqa2rOyxXun2MBvv8AYs4biNVcFH8FjaNEPaK7hvphP2bdgKLu/Y1mFUYZjG2OGAVD9rwF9tAILzP659n7RWOpmSopL1JdOZNnVKrbKRKpKPAb211BImDlICprSqRJ8BMqmECO448LRPsKwcpWJPq3ayI/YEcpAdYaNC+UHr5FgzUFbmqfQfR3mwcYl7jXySb1/3kPV2JXrL5kBPFrJjXuVHJLeLGJ10laGWfqXczbTZUUSGIa27+CYjhWy4l1sEcT9Fw7ay3+dMLQTVs9M6ZQKR5Z70300A0UTRXHIF9GcpTtZuKOG/E6FqiAd+5fmWL7r078nd2ERhKwHC6hVSsWhRkzPg2xVM8pbin55wqD6FZfvEG1HsETIIbP9G1nMQzge1Ao/yotW94MnAN0uSANAKA5Hh3TUhSdfcbBihV3AcXW4akkZ56R+/bVRxVfp74XLrL7AafDAD+4LyhGW7DMtGoI0UFAnSa2pi
 sNC9+1n9
 Ka55WAfXspSrr9g0jskOfGveRowU/qypBWSNcmHfPH/uBlwgZVESGHGrvsljt4jfYHbJ5aQmKL1qpXpxMtNeyYB4DfuyQBCwWjKoeC6pBU68Bfz2exlGYataybRawrDQmG1+xRrvxYhIl/oRxDabK+o+y2vdqZM1t97pqda5/7S/oFiZZuzn/T5GWI1kr3lD2fXApvuRjyAdUCB35lMPL7JuYtqlULHz3j3zk9kUT+mFIEQFLTciwMDuRTE8wQNW45TgekhQ3CvaA2vFYJvv5U2KrXBLmy6hnclY4jD1aRCKrWJM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 01:20:14PM +0000, Lorenzo Stoakes wrote:
> > +/**
> > + * vma_start_write_killable - Begin writing to a VMA.
> > + * @vma: The VMA we are going to modify.
> > + *
> > + * Exclude concurrent readers under the per-VMA lock until the currently
> > + * write-locked mmap_lock is dropped or downgraded.
> > + *
> > + * Context: May sleep while waiting for readers to drop the vma read lock.
> > + * Caller must already hold the mmap_lock for write.
> > + *
> > + * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
> > + * received.
> > + */
> 
> Not relevant to this series but probably we should write kdoc's for all of
> these...

Yes.  I was mildly miffed that I couldn't crib from an existing one ;-)
Definitely worth a followup patch at some point to add kdoc for all of
them.

> > +static inline __must_check
> > +int vma_start_write_killable(struct vm_area_struct *vma)
> > +{
> > +	unsigned int mm_lock_seq;
> > +
> 
> Wonder if an mmap write lock assert is appropriate here. But we can defer
> that as we don't do that with vma_start_write() either...

Seems like a reasonable addition in a later patch.  As you say, it
wasn't there in vma_start_write(), so I didn't like to add it.

> > +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> > +		int state)
> >  {
> > -	bool locked;
> > +	int locked;
> >
> >  	/*
> >  	 * __vma_enter_locked() returns false immediately if the vma is not
> >  	 * attached, otherwise it waits until refcnt is indicating that vma
> >  	 * is attached with no readers.
> 
> This comment seems to need updating?

Honestly, I'd rather remove it.  It's weird to document what the
function you're calling does.  If there's anything worth saving,
put it in the comment before __vma_enter_locked().

> >  	 */
> > -	locked = __vma_enter_locked(vma, false);
> > +	locked = __vma_enter_locked(vma, false, state);
> 
> NIT, but while we're here maybe we could make this:
> 
> 	locked = __vma_enter_locked(vma, /*detaching=*/false, state);

Ah yes, the canonical 'don't pass bool arguments to functions' problem.
#define VMA_DETACHING		true
#define VMA_NOT_DETACHING	false

> > @@ -118,7 +134,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
> >  	 */
> >  	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> >  		/* Wait until vma is detached with no readers. */
> > -		if (__vma_enter_locked(vma, true)) {
> > +		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> 
> No issues with us waiting uninterruptibly here?
> 
> I guess rare condition and we require this to happen so makes sense.

I'd defer to you on that analysis.  If we want to add a
vma_mark_detached_killable(), we can do that.  If we want to make all
callers of vma_mark_detached() check its return value, we can do that
too (see earlier patch attempts you were cc'd on off-list).  It really
requires someone to do the analysis of whether it's worthwhile.


