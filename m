Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1154AEFCE23
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DAA6B0005; Wed,  4 Mar 2026 12:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507906B0088; Wed,  4 Mar 2026 12:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFD76B0089; Wed,  4 Mar 2026 12:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4EE6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:30:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE2641A0632
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:30:52 +0000 (UTC)
X-FDA: 84509070744.28.3488D08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 215C1180018
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:30:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6N0bbeK;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772645451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHML0BajZe6IR4xiZ6yZGMHrxtV7B9c3Ct75VfehqIo=;
	b=YnI1i6bJV3pKg7QNdpi4WRccKoK+Nw3hY72z6JumArVBYyjgvOHl2DpoUAznhYdio0YWE8
	Dv5/I0Iq+btJrC6H3m3E73cRLBDscSn8otkmmN2SmXUE2XrJDAIE8n5uJILVDTwCyxnv0u
	guP9cfTgK70Wwc15kX5bQTiVeNUOt9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772645451; a=rsa-sha256;
	cv=none;
	b=EXRztO1zvFsy3h7KUXsZekIFQ9O2ds1BZx+kn1uZyBjNmR2TTz1Gyial46HoFK+9KOmDvS
	G7c+lw13YLJhMTW591Nv3cddNsXsEwawsjE5b+Yfg5phCFLK/z+B0FxBoBsL6QjF6c8XCI
	EdM1/7bRJLbFMo9+nmraqpVJBcrqpxY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6N0bbeK;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFF804070A;
	Wed,  4 Mar 2026 17:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D61DC19425;
	Wed,  4 Mar 2026 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772645449;
	bh=/fst7LQw2k45jc4t6FChxbkges9fZ21UIyJ6w+2+nfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m6N0bbeKxVheSvkh0l4ssNtAh4SDpqlhj82LHNAqqA4zTWOZm+Syg2QZBnZZKLPfK
	 uRBQnjYZ5NzoXcBA//+H89x510M56J87wZZ51o3Ka56yD0WeC2neTjQk8pdApnkwCx
	 RmmItvIprg+g0A5m/5xEv+CU99QE/ZjUL88dy5OEW/zo/0qRHQBcyBFoqjOepkEKWy
	 mL+4gOKOhwARtyZCQIOP05C70LxrSrAlyfGvZLpUjMsh4fedacXpSm2pPAvlT8Myk3
	 5U76nrO1cNlGUy6j0WNrasaKjZR3Mu0RpFsxlw9SRQERNOKakdw5UESEBA/lmfFKAj
	 O2+nxWbbgiWQg==
Date: Wed, 4 Mar 2026 17:30:46 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Qing Wang <wangqing7171@gmail.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Message-ID: <ce01c391-0368-41b6-aae1-51b4b1153511@lucifer.local>
References: <20260227025842.1085206-1-wangqing7171@gmail.com>
 <aaFrmHzIAkEe7ufy@google.com>
 <aaF0zS3xh5KgM_yy@google.com>
 <aaF-bhAIhCgusG9k@google.com>
 <20260227102038.0fef81e9@gandalf.local.home>
 <20260227155601.18ebd3ca@gandalf.local.home>
 <e4deff21-2fb5-4f37-a7d3-ede5f69a4489@lucifer.local>
 <20260302115220.163f1249@gandalf.local.home>
 <71c3a923-dc00-471c-9555-c08d5e135dee@lucifer.local>
 <20260303102528.744d57ae@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303102528.744d57ae@gandalf.local.home>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 215C1180018
X-Stat-Signature: cfc1hd3p7u6zanogcuhahpi8ntr391i6
X-Rspam-User: 
X-HE-Tag: 1772645450-763742
X-HE-Meta: U2FsdGVkX18wgOFnEfCYyuS6569n73BBJc8ZVbbOB2d+pMvyniRlS9VjA6/zezG+1y6wQ5RucpIp25bzwndkmnapUG6cyawb/OeA7tQ7eBF/EAgr7jphSsHoPvFln4gGxLIlEZ8Sgf+tzX0QEgjj4LsWrVh0bsvbf+S94dm2rfMD2SGmW29PcWoeqsAo1aWNVkkwPzLdTUcOZive9l5faUD/sE3NWI8gS9MJ3QRVDaQZj5edm3a6TkZ91wVpaVemzSjxXYabq7d/RIi6+DkYExjtLtvpNV3q9SZW3ZaXgzEFSM2Wj4MTg8VxljwGQvMOcoTm62p/M3XAnTQINpSNMCXOPG7OIY1BBKP5nbOKiB+RT0gy8Lh7M89+Wg+fYTNO9n7TpmvkFdcYlJtAyFmLHs2aYc8Yye1CMGMtMpvgeR+7OJWNxZFflj/ozGRFJjFf2hyS5prbVHYr6BNemdAVmmquA5aQ/KP8uVM62mt0yMPK1SmJc8hFc8bRNxJqoY7QdTmI0rDbY9xeOT4lYpjPGJ5NNIyW66Bat92Z6Nwzui8J4IRis5xjE8WzO0g1/9ULEHPsfyUskjpJEYutr5vzgzaD1SAOMKgfSAEhzgWGHErT2XNWWzHrqrpYnRWHO3GPTpco6/eWr/2A9W/WLyekNcViPFJK1V4DEErhKKGLpgoPdzjeuPgN+ArBwxI+b7LIdHXIt9HuRL7n/3RGfLc6tp1I3b+f7XLcxKr5ZxhFujTOJteybbupxo8mar0X0IA2XRS04SZI+7PlAm8RyBe6Z+Z/GuugiMmaMEI9CLbhrariEkNVk/VODGfSpHw3EPbs06MUlTY47cwGQ9aa+DtHWSprPecLHlE9hMa/QcF08nDZlCHxmTD1NqwF/Vdy60dxm7U9NKbIZgCGxSAKjqmZAvk4yMVUkHErwQPRNrxrg2bcmY4wOsvzQJXxJ6y4ZdlFZwPt04hH3fzgy+w0fFr
 wZbcTEFp
 lL/pZxdXATSuVA+I50wSn1DM6hs6CJfMhNnyakrgypFukBJ7YTYrwoC/Z/Qc/Skk60xEE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 10:25:28AM -0500, Steven Rostedt wrote:
> On Tue, 3 Mar 2026 10:19:52 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > > > Setting VM_IO just to trigger a failure case in madvise() feels like a hack? I
> > > > guess it'd do the trick though, but you're not going to be able to reclaim that
> > > > memory, and you might get some unexpected behaviour in code paths that assume
> > > > VM_IO means it's memory-mapped I/O... (for instance GUP will stop working, if
> > > > you need that).
> > >
> > > Well, we don't reclaim that memory anyway.
> >
> > OK so maybe not such an issue then! As long as GUP not working with it wouldn't
> > break anything?
>
> Yeah, we don't ever use get_user_page() for this memory. It's pretty much
> all handled on the kernel side. User space just has it mapped as read only.
> The kernel doesn't care what user space does with it.

OK.

>
>
> > > Yeah, right now the accounting gets screwed up as the mappings get out of
> > > sync when it is forked.
> >
> > Ack, is that in a way that could screw up things from a kernel point of view at
> > all? Presumably there was some report that triggered this work, like an assert
> > fail or something, or a warning?
>
> Yes, it triggered a warning. The start of this thread added a patch to allow
> madvise to remove DONTCOPY from this memory without screwing things up
> (by adding an open() handler for the vm_operations_struct).

I mean that'd be preferable.

>
>
> >
> > If a user is explicitly going to an ftrace buffer and madvise()'ing it in random
> > ways they've only themselves to blame for being so stupid :)
> >
> > As long as it's not exploitable in some way I don't think that's too much of an
> > issue?
> >
> > It'd be nice to keep the semantics of 'don't copy on fork' if we could, even if
> > some crazy users might override it with madvise().
>
> OK, so should we add the VM_IO flag?

Would be preferable not to lie about the mapping if possible :P that'd be a hack.

>
> >
> > Kind of separate from the question, but I mean if it's kernel-allocated memory
> > which you're managing separately it should surely be VM_PFNMAP?
>
> OK, I'm a bit confused. What do you mean "managing separately"? You mean
> managing the user space side of things? if so then yes.
>
> Hmm, I haven't heard of VM_PFNMAP, can you explain more its use case.

means either no struct page (e.g. could be I/O mapped device memory) or 'don't
touch struct page it's not for userspace' e.g. kernel allocation.

>
> >
> > It depends if you want to have a refcounted folio underneath though. If you do
> > then yeah don't do that :)
>
> I have no idea what a refcounted folio would do here :-p

Well you are currently treating this as a userland folio.

>
> >
> > In general I'd suggest supporting the fork case if you can, or just let things
> > be wrong if a user does something crazy and undoes the VM_DONTCOPY flag.
>
> OK, so don't add these flags and just allow the forking to happen as this
> patch does (if they screw it up, it's their problem).
>
> This patch is here:
>
>   https://lore.kernel.org/all/20260227025842.1085206-1-wangqing7171@gmail.com/
>
> I mean, we allow two separate tasks to mmap the same buffer, and they will
> have the same issues as a fork would have. Thus, I guess the answer is to
> apply this patch?

Well note that vm_ops->open is also called on splitting a VMA (ok I guess you
disable this I think you said) and also mremap()'ing (before it removes the old
VMA, if MREMAP_DONTUNMAP is not set).

Probably all that's fine right? If so then good, and yeah something not-VM_IO
would be best I think!

>
> -- Steve

Cheers, Lorenzo

