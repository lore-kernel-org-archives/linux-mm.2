Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB85CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668A76B00E8; Mon, 11 May 2026 12:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6407D6B0117; Mon, 11 May 2026 12:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DB46B0118; Mon, 11 May 2026 12:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46D296B00E8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:00:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9DCD1201C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:00:33 +0000 (UTC)
X-FDA: 84755601546.05.7DB5C94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25C07140013
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:00:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rDrY8vrT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778515232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgxxrQrunYOFdtUHMzxvGZxhYSNwjak4ACzMLjqG6O4=;
	b=covjdk+tR2nUw2T5U26r8CPBikucNebvAtfxWiPQdlbu1Ms9LoXtnKx+DRJjf5kNa+PMQF
	ASHn8UYElOzKtkA5g/9WOiew25pcUkP+1ZvctNXfz9ohGIRBQG9vVMZs/0mfNHnxKlI2DD
	XNBHrrJZkYD1IHj1AgyhExF4+89BLPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778515232; a=rsa-sha256;
	cv=none;
	b=up5kvJwyGAKRd+6t+2BUgbTgjnkhN4sebFrAxThjaGsGstGDAwaclxp+LLKzEFaAC1AMjO
	8NpIvBYwrdjHVDvlrPsjP4whajAPNloWnT9qVCkIa6cBMSHblrxxlY13ZWZQvkBwdSEC8T
	Uo9btlI5uIjzmAHKvYWV2B/9yIXZuNM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rDrY8vrT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FCD060103;
	Mon, 11 May 2026 16:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A5CC2BCB0;
	Mon, 11 May 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778515231;
	bh=GgxxrQrunYOFdtUHMzxvGZxhYSNwjak4ACzMLjqG6O4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDrY8vrTp7dO3FIZueKI7NbApDBdmFwkIQV6hL8v/oYR8yxFGGb4jBvRnhMLp0SNQ
	 YKAl9sHSjrvWni1g4typz6JsrgfLXWW3IB97KZRgY6zlhhFdjZHuEaPdAU1PBIzwWy
	 a+ztmz0LmdsaBY84OusUk6uNOwhx3uZTxhkY+NW+YfggdMlrF+BULmxQSOx295Vg4S
	 Iw0tqn7Hm0hCQ40FdeQfO0lm1sA32DKh9RWln9uej4R678dshC8lLNBDRxtW1Dm65x
	 lqkY8f4J27r3uOGQ7IcvVI68vJO1XbYs+YC8LARK4OFGxMBTmNCKg6Ku7sr5Ek3ChQ
	 IKseDzbyNf5Iw==
Date: Mon, 11 May 2026 17:00:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Message-ID: <agH7ONBSX7XLzS6q@lucifer>
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer>
 <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C07140013
X-Rspamd-Server: rspam04
X-Stat-Signature: xucnfqtpgc7zft35f4i167336qbbrh11
X-HE-Tag: 1778515231-738060
X-HE-Meta: U2FsdGVkX18UtKYwWAS7rOl2YIjRR6oxjIkM4nb4qql8aUeLC8Q3rpAQtY3dGkQqLuC7WvoZ6DsPpKVYlGUDiSAU56O6jUY78yEXQfHfRm91oRB26FRMlq0C/68uhd/v7G4H69lbiccM5gzTNLXe0U7YnbjQ8L7cIyiWc9YcUW9ax//mAEgjOW+gE69rTWcXfZbAIjapuFbgKPJkxElYR9qTCX9VgbTBSgv4zjF33nic/YVMrDq0yOyKDss/Y3kOTVDbkIdXHZkBg14sR53y3zi1mU6ikM1IykBnt5feYXZmIdTDuEvG2FiFE5Tl0P4I5Q2knFG+4FDa+8QXauoQZUDr+AMEAPb1F98iiwwBbu0rcu0KnVtbfdjh4/NG2w68QV3iTGYuIZ3SbgDs59x2/0UZdkuZITvUAF/ej0ZrQAnUk69O4qwY/w4CI8xvWpxoDVO3ovKPuaTOpN7Qfh13nTS4eD2k+ED7VS++Y86Cm9G4VrrfUt4vaJDt14WKmXNQDR0GR85eXKvUjuiGgE/clc73AvID7EA4oqRIcy0pdQImBVc+KEK5S4JlorFffWN8j8oVf69IKIJZCJWGT5FHjqHAxBD4IfUbLnhCyVB0erlhUNn2t7pfBUhpWiF7Z0ttQuK0WRzSnMGm/ihGTzNb7y1gEwbOxcOTKIOWfBVohwQNqaTFKn0yDz4s6uqQOer9wkZXQrbXm8YmoqrtUKgQxnIbacOKbk34rE929OedVHsVFydd2mqwh3aZLDeaiwXMwGNRoRYUgaGns6KeMi5XIP8MlAYtaKzNp1hIpeckeT/jEHiwvPAXiWnYmHCsUAK7qJUxC9s60Vsl0+X9cVjmMCR4sEwpOSUM6dZmJW6sfzrph2UN6h1KCAK/hE7xE3e/WTOQCYxgkluiXkDpZJBfjK2oo8RN9Ys2cvbCz+NKN2UEXHc8VppQ73sOh5QnjsdL29r41KUQCS7TpUsf8+q
 jDYCYQFM
 wJaHKFXz7yEEn4SDPbi36T866Vvb5kY5Mg6djZnvQwx/stEtSV5NhRFqmTecfswaTUXlHhQ5GMcLA6h/0GSmW4drzbs1plgUVJSasjj+NpvBtfa3TaTKlcLKFNhE/G6+Fif1bJOuCXZT1p3IS4RpmGegLBvkanRbVhylE0/bZQXwvID0Sn/RKxl8fpiyT+f8WJgGvEz2lDC2uI6Vrz+ZVlpASuY1utYvTPIUCpKCmBsRvnTkLAQd5pUU2sFkAiUS+YwWZA4lAanjAcsbY7WaNHoV8y2OsmHbTTFF2pCacxrUFzIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:40:24PM +0200, Jann Horn wrote:
> On Mon, May 11, 2026 at 5:32 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > On Mon, May 11, 2026 at 05:19:50PM +0200, Jann Horn wrote:
> > > On Mon, May 11, 2026 at 5:05 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > > Hmmm I think it's a bit debateable honestly. The ability to handle there being
> > > > gaps is a _new thing_, so there are no semantics to speak of. Prevoiusly
> > > > mremap() simply required that you only span across a single VMA.
> > >
> > > FWIW, I think mremap() on a source region with gaps is such a
> > > hazardous operation that nearly no userspace code should be doing it -
> > > gaps are areas in which any mmap() call without a fixed address could
> > > place unrelated mappings (unless stack VMAs are involved, which would
> > > also be a weird scenario), so to use it safely, you have to, among
> > > other things, make sure not to use libc malloc() at a time when that
> > > could place an allocation in the gap (which means you also can't use
> > > printf(), and so on, unless you have swapped out the memory
> > > allocator), and make sure that you have no other threads that could be
> > > doing that, and so on. There are rare circumstances under which it
> > > could be safe, but I think it is almost always better to have a
> > > PROT_NONE anonymous VMA or such as a placeholder.
> >
> > Well, we're holding the mmap write lock so none of that could happen
> > _during_ the operation right?
>
> Not during the operation, but right before the operation. So from the
> userspace perspective, you have to know that there are no concurrent
> threads that could be creating memory mappings at non-fixed addresses,
> and you have to know that no mappings can have been created in the
> memory range between when you checked that it's empty and when you
> make the syscall.

That's a very good point :)

But I guess applies to any operations that operate over a range of mappings
anyway (madvise() lets you also do this, though it'll give an error code
_at the end_ _after having done the operations_ if there are gaps).

So madvise() can have the exact same thing happen right? which is... fun :)

I actually wonder if we shouldn't just change this to disallow gaps. It'd
simplify the code and we could even do the check upfront in one pass. It's
doubtful anybody is relying on the gaps behaviour for anything real.

>
> > You might debate also the fact we hold that for an extended period.
>
> Eh, I mean, that's also true if you call mmap() with MAP_FIXED on a
> gigantic virtual address region with lots of populated PTEs in it or
> such, or if you call mprotect() on a big region. I don't think it is
> problematic that there are some very chonky MM syscalls you can make
> that will hold the mmap_lock for a long time, as long as we don't
> expect heavily multithreaded code to be doing those operations
> frequently. (Being able to keep the mmap lock held in write mode for a
> long time can be useful as an exploitation trick in some cases, but I
> don't think that's easy enough to fix to be worth the trouble of
> addressing it.)

Yeah true.

>
> > Honestly I probably shouldn't have allowed for this, I've had to do at
> > least one fixup relating to it I seem to recall and the semantics are
> > _clearly_ confusing.
> >
> > >
> > > I think the right documentation for this is "do not use this on a
> > > source region with gaps, it is technically possible but extremely
> > > hazardous".
> >
> > Yeah, I mean on reflection, allowing it was probably a mistake.
> >
> > The real use case was 'my VMAs are fragmented and I don't want to have to
> > know about VMA merge rules in order to move them', i.e. no gaps.
> >
> > I will do a manpage update and indicate that it probably shouldn't be used
> > but if it is, the sematics are such that gaps are not propagated (i.e. it
> > is as if you mremap()'d each individually).
>
> Thanks!

Cheers, Lorenzo

