Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754FBCD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80396B0101; Mon, 11 May 2026 11:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31BF6B0102; Mon, 11 May 2026 11:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F786B0103; Mon, 11 May 2026 11:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A723B6B0101
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:33:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CC721C0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:33:01 +0000 (UTC)
X-FDA: 84755532162.23.34B2308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9694A160006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:32:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f163O4vD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvKtNQvtbKP1T3EoVvmW4tuiJOgiNa3QaaSX79WRtWg=;
	b=GsSJyi98t47LD/xeNjhzRjDDesHNjB5GaMtcx52e58o9YSobxdtTljGFqh6mfzo/ipf3tF
	6nWGRSy95yxuppt/m0JCnOTjKLAXvqdMtUARvJXaNtLEi1dhmpv0SWJs6dERrxQT80HJw6
	rO2Du/Nh13SsBQgKYp5I5i9XNVIeABs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513579; a=rsa-sha256;
	cv=none;
	b=IUo8/7hG4w83gIMSof2nip+LeoIJflxTr+2+Xyvi9mwn3JsH1/7zMwbsxwLFULBNnnocff
	fuAN5O+a2n7fSeFRO0GAasz6OKqaJtvaRMrvCkSVRFdTS9HkAfxAurX741eUw8W9T7s+Op
	kD5uwZNWT5eLuWfb70Swt5XbsVXLUGw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f163O4vD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9097241AA9;
	Mon, 11 May 2026 15:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3F0C2BCB0;
	Mon, 11 May 2026 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778513578;
	bh=oY/dHyH+Y8UtkwvZvzcd4kYBZgahoB9UOj/6bh+miOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f163O4vDyOPdc0JOyCKRpy0lRzjCWKbjjKUkj/3k83d2qiJTRJijGRViJ7jxmVH8u
	 haHq3+i8v3z88OUkEpqNcCbpuk/F7rvLI1b/b0hQaRVBpnrCpj1jfukHSBkLq9Mghj
	 oHeswfHFyQKQiuNg1AuajeDj4CgD4Pmvzi1N4pBrq1vH6z0ODsIRieCvN2DJ4VNv51
	 StU3TkCqXGxEE9TRIX++ykRNNCb+FgPu6X3kw3GgMfNzm45/ZwR8P6Qt+cxH4VCWbu
	 rtCCwnxtOBWt1NljSVkAWD5rX8qyDZjwwOpEqpKk8v/YcTTaUQmCTRo6sGg1W7fWlM
	 2aeYKrAoTmVNQ==
Date: Mon, 11 May 2026 16:32:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Message-ID: <agH1ZSdX_7QF8P_I@lucifer>
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer>
 <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9694A160006
X-Stat-Signature: hesc8bqh5byu5ixppa3xtyq5tm4gop8o
X-Rspam-User: 
X-HE-Tag: 1778513579-9523
X-HE-Meta: U2FsdGVkX1/BOaGPITD6HyY5ouCv8l+wU2BjRGmqIbhLuWSZppckt4ouqECVmA1ZMms4Ded9gD6Zvj1kdmhSzn2gp539mmny61sbN504TstPEJKc+Jvu7J4nyLm4dH6d01W/mU45svFiSLfFaAv9v82LPggaJr2xm2AjoDbiZ0MlisjFppa0MBldldGKSt0zEvh7qeZsZO+e35vbPJjesGx7SbjJQP+jb+F/UFx0xQmCk57XdGWpMIn8p4RvTLinhQaqXwxawq56BjsQznUmlnw5nMRnExCRAm/U+WpEO0oTUHyl5pPx4RIhAhc5HzKZJkPuuFn8nzqTG0JrMQAcuF6WrVryw7uIgSpQixjPOepGcC59M977lkexhEoxQrV24Do2L7IXdGOc3mhhWUS7hVfqYL11GMCIIzc5K7ZoHGHqZmDh2Z0RaAt3PvdzkS0Jstn/S+zeDVd2ScAVHIj42gqlvqFymHp7YBNhxa823bSEocyinD7hjXHEZsIhXkjRu4iZ2B33Jan88ewISUWBY8wxvgQNYwXG3ZLXum34VBEZBNA8X6IFfGY2+JNDeC05d51P2ews+yAJNA0n/HnHDXhlF9yxLKp1L7oObwqHKfj83GvLtzz14J9wEls18mgry3lH3MQ/UjM4kKYp8Y6FjaxGZ5GJ4MQeniHdI5mZ4DvlndE071e8RBrLzcieeDPIsG4iKcn2aTJXKhUeswOwO4QYFtBnLOlTMu2ccsywtcWmsQfS0j37gHjRwF+f6B4kSbFZWIglvLNgsUx6QEwH5Abz8FR5cOOgetEOB1JoUgvuxxIbsRDXZfQTTeUjnebTtXAdGdAr+Fda75dqr67CD7fO4OxJP6sO2LmSI/esRGEjfR+/ohEQcpiK4MkrTR0cz1BS+IgQ+SxqzeyMHWtetQaKsijzruiVD8KcTYyj2vL0ucq5pwyRutxIvW2L1knc3roriNNOXeBCAM0AQbk
 brQUmzYF
 cc5K/Nprmb5Z2JmJH9Qb54oaIJxdZITPm7ZQxohi31Yb0THrpKyzDvXtGXm2lYozPOc4A1IYCwPgCbKFq4enOYskM2ZRaQFcqkU3GQYm9NEfzxz5S2Eue6QyPh+Z1vEGJItkqWyNM5EZq8jrHvmzkxhuviboFeHKCGEcYKYrn90wpx0rDoo8cYejEnr8qgwDe5BuLhEVVN/YJsctbEI3wWOgOj4i6VSdCNLllbN2DDO4kP5hd0Wxd2AexcxoBmz95G+I6VZsneXWVj2xi1lr66/Cg+pbYTsSoFdnI5HL3MOdVUCwE5t5BIpOem9unnnhq2ohf/k0y9Nl6pwFcnXjvB3FNzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:19:50PM +0200, Jann Horn wrote:
> On Mon, May 11, 2026 at 5:05 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > On Thu, May 07, 2026 at 06:24:45PM +0000, fujunjie wrote:
> > > When MREMAP_FIXED moves a range spanning multiple VMAs, remap_move()
> > > iterates over the source VMAs and skips source holes.  For each source
> > > VMA segment it narrows vrm->new_len to that segment length before calling
> > > mremap_to(), so the MREMAP_FIXED destination unmap is also limited to the
> > > current segment.
> > >
> > > If the source range contains holes and the destination range is already
> > > mapped, the destination subranges corresponding to those source holes can
> > > therefore survive the move.  That violates MREMAP_FIXED semantics, where
> > > the destination range is supposed to be unmapped before the move, and it
> > > also means that preserved source gaps do not necessarily become gaps in
> > > the destination.  Userspace can then observe mappings at destination
> > > addresses that should have become holes.
> >
> > Hmmm I think it's a bit debateable honestly. The ability to handle there being
> > gaps is a _new thing_, so there are no semantics to speak of. Prevoiusly
> > mremap() simply required that you only span across a single VMA.
>
> FWIW, I think mremap() on a source region with gaps is such a
> hazardous operation that nearly no userspace code should be doing it -
> gaps are areas in which any mmap() call without a fixed address could
> place unrelated mappings (unless stack VMAs are involved, which would
> also be a weird scenario), so to use it safely, you have to, among
> other things, make sure not to use libc malloc() at a time when that
> could place an allocation in the gap (which means you also can't use
> printf(), and so on, unless you have swapped out the memory
> allocator), and make sure that you have no other threads that could be
> doing that, and so on. There are rare circumstances under which it
> could be safe, but I think it is almost always better to have a
> PROT_NONE anonymous VMA or such as a placeholder.

Well, we're holding the mmap write lock so none of that could happen
_during_ the operation right?

You might debate also the fact we hold that for an extended period.

Honestly I probably shouldn't have allowed for this, I've had to do at
least one fixup relating to it I seem to recall and the semantics are
_clearly_ confusing.

>
> I think the right documentation for this is "do not use this on a
> source region with gaps, it is technically possible but extremely
> hazardous".

Yeah, I mean on reflection, allowing it was probably a mistake.

The real use case was 'my VMAs are fragmented and I don't want to have to
know about VMA merge rules in order to move them', i.e. no gaps.

I will do a manpage update and indicate that it probably shouldn't be used
but if it is, the sematics are such that gaps are not propagated (i.e. it
is as if you mremap()'d each individually).

Cheers, Lorenzo

