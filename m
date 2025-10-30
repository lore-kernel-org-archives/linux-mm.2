Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11ADCCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2939F280013; Thu, 30 Oct 2025 12:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AD4280003; Thu, 30 Oct 2025 12:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180B1280013; Thu, 30 Oct 2025 12:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 071AD280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:32:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A573A139D20
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:32:02 +0000 (UTC)
X-FDA: 84055322484.17.2C74EBC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E8F48000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:32:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0j9hU/Ts";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/4I74rDr";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0j9hU/Ts";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/4I74rDr";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761841920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYxUqOLOyZrF6zpcmB2FMK7ECIXy7RwQ0ssrddYQtt4=;
	b=C738es79Uckl3PKkEkFIOswE5NdxXYmFMZFAq/YCAHA2EJEkVsCFwqHQDcxr0+6bfmW5ap
	h0vKuCt6bc5c2I2cQJ3WuTfJIcOygR5XNEpuDLlhfvbBUP/5LYk47lDTJfQStRwdFwH0fv
	ptjYWO+VuvZh5PkAPTHypnYWKUURCP8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0j9hU/Ts";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/4I74rDr";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="0j9hU/Ts";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/4I74rDr";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761841920; a=rsa-sha256;
	cv=none;
	b=UhvoUmzQXe9mGfCz3El5HIxyCSg2qa1mKPtoTNgWFuTND6kMj6rvEYKwvpJc7pfDDLMDDh
	tU4zqrcfr3Y0PspiNBBVGmbqT6VNUhWJy1t18L7xPDKysRVwxHLjZp9jNTkrzobsn6M6IX
	w58G+KJRSU1h+CF/wjCaYMzevHnHkic=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DC6B233734;
	Thu, 30 Oct 2025 16:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761841918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYxUqOLOyZrF6zpcmB2FMK7ECIXy7RwQ0ssrddYQtt4=;
	b=0j9hU/Ts09qlAQwjbg9XzmffczV8JmPTLC5Tal5kBHOkxavC2/Hk/UWPigSPkRxQql3Sts
	m/JuTTW+3nn/0tnzY4tVQfKVzW9d9u29lgLYrbbDh8mLJ0++SMk8ER8Rjt1Faf8L2KJk8R
	A8pTuIrdTPliL9z3rj068Q60O4mKbbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761841918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYxUqOLOyZrF6zpcmB2FMK7ECIXy7RwQ0ssrddYQtt4=;
	b=/4I74rDr2B/Kz3VDx5w+SlXMZ4BGPlIeQHP5WGXrGv/pd5Hck0KSYuZjRFzC7tIlVvc5/u
	UIhBzgKIrxODdDCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761841918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYxUqOLOyZrF6zpcmB2FMK7ECIXy7RwQ0ssrddYQtt4=;
	b=0j9hU/Ts09qlAQwjbg9XzmffczV8JmPTLC5Tal5kBHOkxavC2/Hk/UWPigSPkRxQql3Sts
	m/JuTTW+3nn/0tnzY4tVQfKVzW9d9u29lgLYrbbDh8mLJ0++SMk8ER8Rjt1Faf8L2KJk8R
	A8pTuIrdTPliL9z3rj068Q60O4mKbbQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761841918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LYxUqOLOyZrF6zpcmB2FMK7ECIXy7RwQ0ssrddYQtt4=;
	b=/4I74rDr2B/Kz3VDx5w+SlXMZ4BGPlIeQHP5WGXrGv/pd5Hck0KSYuZjRFzC7tIlVvc5/u
	UIhBzgKIrxODdDCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A3F6613393;
	Thu, 30 Oct 2025 16:31:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EtDIJP2SA2mgHAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 30 Oct 2025 16:31:57 +0000
Date: Thu, 30 Oct 2025 16:31:56 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Message-ID: <c736tssdw3z57kamh6eqc23gr575q375n2o2nnszih64afnaf7@zwbqremsbhwf>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
 <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E8F48000F
X-Stat-Signature: t6puhkru5psghn9gi7ocgq65ihrhgtbg
X-Rspam-User: 
X-HE-Tag: 1761841920-592657
X-HE-Meta: U2FsdGVkX19fxQSld89ZBhO45S8EdMoRCMnjx34VKP6zCZDYXQ08lhQ+nEY5l13k4GuE8BOtuPqXMpRPLsNw9+Q0SMX9+ld+7gbEOWkLO+G6XEIuDWIycUMpqElZIr/RB/yZjwq3mPMQpVY3VlvAyOnBMWNA7psWCKZqTbUrecH4MKPSiciwGqByeosxLR9GezWundjh+j29xSFAwlwjivF7KU9+7H5PTtS/33zKjnsXdUwGM7gc61B7VnG5/3nP0uXoBFUN0BgzM8X3PihqKU0Y89ABaT2I7C+r1urclTOaXNFTmoaufdrok0iABUM+Yo5uE1vfVzPXy2Qzyfvy+MJ8kCBYj5P0oIjPP7ts+reAa0pD9SS46Xk699zIgEZsOdoarH1Bs38dUtwCbUmGCWmxcZKQ+E/1eknhojBnMzDvXn9Fl/rx0pKQQrg1c4MXqocr3SR3a/94mEb7I0g4grZwB3gETZox9MQ5Y4fhJHG/SGWBmsPbS/H9jSOVwXQL2n8MiNuWeHIwinsSpJJmTXOoNsy+qi+CrfbHla5LQ9QyTwHmqoTS/m2Qqx/gB1wLfyvbzwoykWwtUW3taQc7xXxvr5rnTxbgHxgAg5j8tkGvBJzVuRigzd8CkR+FDo1G3fC8710O85sGZBZ1Baq6hXpGpHQO/jLmwUwfxMTobLKrK1+k8DYgA50kLlC8FtLC8VMCeVit9VEk0hTS9dM94p9q2YqKaZ0fjaHtMBGm88X3YF0VQT5tdv3KRLeufz2zJsIpo57hvocfQZB0P6seFal8QczZE+KWIIIYYhWUpBviG1lO2YW2B+rWXJmSsETsbIzJGfp5jK94EljHJLOmYYfRaq6bNCAQMpTWU7NICWCvXoOvHMAEaNsnaLYM0k2Lf7+KIDWFdHbl0d7Nrrl1J8JhTy4uo9USVOqsIAR7AYo/EQEMddi8tJEhOeojrccVw5d1ptZCpN2eKR20nww
 k6CbDi6E
 GzupMxeSlKII+PTu0U/osqOkVqyDsues4TckovXeMD6VihIwF9O4MnEy6XV6RPxWskoyHu90xBPsOZGK2mPDMCwmDvDOg4FnLBIwnUzF8yM3VaaXyDjiK+rp2MYcvMgf9pEq7wRG+n437GZPmuc/izOFLUieu5iXmONDEyj8gkffwbtwV0Lq2CWhVwGYO6YcqcTmdZKeMAhJbD6J8+C5oFG5wo52NKW+BbqTElYM1p4NKGrqmRPRRWvTLFF8HvAvj5/G00FIJnmIJJjMwuAOnem1YYSKuGr03h4D8UbvKlt+6fQxaX40htGc+yRtDEIoyd1EG2EUAtO6KsB7jkpWQnaZuC7VBBUFhbx15
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 04:23:58PM +0000, Lorenzo Stoakes wrote:
> On Thu, Oct 30, 2025 at 04:16:20PM +0000, Pedro Falcato wrote:
> > On Wed, Oct 29, 2025 at 04:50:31PM +0000, Lorenzo Stoakes wrote:
> > > Currently, if a user needs to determine if guard regions are present in a
> > > range, they have to scan all VMAs (or have knowledge of which ones might
> > > have guard regions).
> > >
> > > Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> > > pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> > > PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> > > /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> > > operation at a virtual address level.
> > >
> > > This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> > > that guard regions exist in ranges.
> > >
> > > This patch remedies the situation by establishing a new VMA flag,
> > > VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> > > uncertain because we cannot reasonably determine whether a
> > > MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> > > additionally VMAs may change across merge/split).
> > >
> > > We utilise 0x800 for this flag which makes it available to 32-bit
> > > architectures also, a flag that was previously used by VM_DENYWRITE, which
> > > was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> > > bee reused yet.
> > >
> > > The MADV_GUARD_INSTALL madvise() operation now must take an mmap write
> > > lock (and also VMA write lock) whereas previously it did not, but this
> > > seems a reasonable overhead.
> >
> > Do you though? Could it be possible to simply atomically set the flag with
> > the read lock held? This would make it so we can't split the VMA (and tightly
> 
> VMA flags are not accessed atomically so no I don't think we can do that in any
> workable way.
>

FWIW I think you could work it as an atomic flag and treat those races as benign
(this one, at least).

> I also don't think it's at all necessary, see below.
> 
> > define what "may have a guard page"), but it sounds much better than introducing
> > lock contention. I don't think it is reasonable to add a write lock to a feature
> > that may be used by such things as thread stack allocation, malloc, etc.
> 
> What lock contention? It's per-VMA so the contention is limited to the VMA in
> question, and only over the span of time you are setting the gaurd region.

Don't we always need to take the mmap write lock when grabbing a VMA write
lock as well?

> When allocating thread stacks you'll be mapping things into memory which... take
> the write lock. malloc() if it goes to the kernel will also take the write lock.
>

But yes, good point, you're already serializing anyway. I don't think this is
a big deal.

> So I think you're overly worried about an operation that a. isn't going to be
> something that happens all that often, b. when it does, it's at a time when
> you'd be taking write locks anyway and c. won't contend important stuff like
> page faults for any VMA other than the one having the the guard region
> installed.

Yep, thanks.

-- 
Pedro

