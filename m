Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA23BCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2496B00AF; Wed,  3 Jun 2026 17:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92886B00B0; Wed,  3 Jun 2026 17:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AE86B00B1; Wed,  3 Jun 2026 17:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1C246B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:31:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66EEC404BB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:31:56 +0000 (UTC)
X-FDA: 84839899032.29.E774948
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 434C040009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:31:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=VrxOiHhq;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.53 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780522314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5iqrCHjutj+wP2G1wPc50Z6+aExdn36Rac6q6pqNP8=;
	b=kX51+yAu0G4IrfTnJJMEGa3vVFudYiW3ervBeJj7ugZYGz9rcfb3DC4l90/RBA1SMzx8fR
	9RlTqUKLozyboHppKmjKeLWMJHkhQFU2Js3ddCDZYAQ6Ql5lHjDfotS3/vBfGxfQeht9iG
	9HCdUVHk/LxtZp764Aii1Wy3tIFBUJQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=VrxOiHhq;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.53 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780522314;
	b=HFYDAwgHjQ9p+sl4bCtzwTjSi+m5yw8u82EoFuGIGYmKfLuGx3pz9giTOLJ0We//xEHrJd
	kc2QOVSQBMgs26tLlAJD5OL9ZBvEfyl98EpRgWkTQbFWyN6f0A/xHBSoW0+wEPloNNQepd
	hngxyAPTmelSL6wabTP9P2Ed5DS4+yc=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aa68d7d757so4201190e87.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:31:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780522312; cv=none;
        d=google.com; s=arc-20240605;
        b=KyeB0KQZhtxCEOzwbrrad6LtsXTvCMGBU+Xet0aUTqwXqawp7mwN84WCNCkCz7zpkk
         VNb6QzAcTvjrroCVbdVLnXiFTsY/w7s3d/xqRTUuNKzTHgolrX15+hLzSpPRbqWKYrqV
         Qkkehgy6vJ3x6GjGqx0JeeI5KUzmtJq2tquUDhKN4YK10U1QdZfAGXKj7uMGd6zV9e07
         kpDpg1HdgGfckakew/2FQcq/74HNliAey3S0dQ4Gw3basdPhjRO+1/3ZbVKv+JC4i8FH
         ZVBcspQ/YEBRSAxAMiTHyWWiLUM/4gc2LndJYAQ5fku9/oEAs1CD0uaq8RgPxg+zLzfZ
         miGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q5iqrCHjutj+wP2G1wPc50Z6+aExdn36Rac6q6pqNP8=;
        fh=EXrQHHObttgCG8JeJ0/LpTpRSRKznX1EtZ489k+iLjY=;
        b=EogWBsAkHDLMWYYHXulWgt1MtF4+73FhWvmcjwMBJQN6Uf72KLJjlTwQAIQX7+B6cy
         4PcRIkINYYhS4rx5LhGVlbzoE9dDrHn3NHnF7i66sAxTDU8vnTkKpyEaN6ziQIol9N7d
         EAVic/14yaM7S6ZGhggLW7sFbRDkbR6lYbUVKj6jgiZ2DZivm7t2x1bDmnJPycPQ515C
         Z3Oe6DF/C4R4CUVbYYJyoJO5erCRzyrEXhf4+N28CXsbOGRn3/U58pO2/03r5N9HTv0h
         oMwSOget2CbcnspIZyek3RveAPT22pb3/RDvgwfyejX9h7aNzRayLet6DmoDSJ6TyrK1
         BCLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780522312; x=1781127112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5iqrCHjutj+wP2G1wPc50Z6+aExdn36Rac6q6pqNP8=;
        b=VrxOiHhq0ho4T/ihkr1Y+Ac84F104dgyCsbOjeifChPQHT2wZaRgc2a9qknwaaNYoi
         0w/qOaIt1ByWPwszjsSqoVdG4Qt/2NK+Blo+vJ8yvZR8B463+hpyeS5I4qbmvz2xdHYK
         KkqmS9db+GmGjzSLkMPLzynw80fhVVMETWmYGQ3OFBWQXKgBbUkXD2ohRmxR+Dfm7ZaR
         Idgi8Ma/fr31NqdrfRj8n+9Xp4LqE9i1vgkrunr/4MkcTBgljGMBXL/79dMa/R23MJBf
         tYJ/AAPhTzuvWf+DzFLt95zGD5sbtR/zCsmlVtVAZtVRGDLViCMD9OTjq5uViqzpwagP
         XE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780522312; x=1781127112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q5iqrCHjutj+wP2G1wPc50Z6+aExdn36Rac6q6pqNP8=;
        b=CplUjHNJALWjcuUlqYimaRJW7gE9ek29Ule8TsJqQV1EHiKlpOry7KxcKTR3PHMoJ8
         dLvwSTzgqYwNQkLl8p21KjNH+NHrQ+WScRo9s1JIbJZl1B0R1Nlxfnqybw4WsU4ZC+hG
         hKzDjuKLq6RPYwLAHjHkbjnK5UETLbf2Yw3RU8XigdCMAbODh5Lmif7nbTFlNxAQEwi1
         o5innruVJRr4XWPv8iCYM0AxqUNCmwig8Zw6p9+9oG/zOVxXeYLbr79oJ93ejdbD85ZV
         eePo2fyGYFdO4o3Ss2j5TKMuDjlsCRszShapYkTQh/mtHxQXfXKUr/pUBM5rkoT7xJdI
         KiRQ==
X-Forwarded-Encrypted: i=1; AFNElJ9UbKBiO/sB9ACmXCqVilwftN2/EciIqGEACHPBKqCL8sWvPFVkX02dV+Yl4aytJ+NaJ7ZJ29PXAg==@kvack.org
X-Gm-Message-State: AOJu0YyAkN2sIkGBmIg8rbgCNs2eL5TeVmAqxClplG8/+vohkFlPhMA4
	37GrItMcs/EesxtJinfUKlPLFADvKjN+GFILizWB/YWtFI+wq4oyj0a/UQ5mgVs1ATEpcANpqQY
	uwHzCl14hYlqf6xZievN1575kPWy/JE5iNkH1IOJi
X-Gm-Gg: Acq92OF3rj9Zo5a2c5S79T5JEtDdiV8N7AaIbhO7SUtUFma57DridbN/CpPc0360KKw
	B+B74Ks9scn+siiazTavE/56DPV1fWM9DCvZgkgGRMuXVG0Vj1AhIE4atdx/Ml0N0hIhDBxHqI9
	e3JlehUeo6sv9klOd77A2twhCnwTy6g/9L41I6rBg/ih6P0DhF1Rpso7WfZD40UimiUmYBoGkv1
	I8fUtr/tj9SW4CFqpk/c8dfwEKkacrrs3mOGWRNK/4LSQVVpWj1cHpvO537HABJuO8hM1LnCPtA
	qL4Awl4YXF+m9eSafnw=
X-Received: by 2002:a05:6512:66c9:10b0:5aa:6c1f:d300 with SMTP id
 2adb3069b0e04-5aa7c061ed1mr1281308e87.11.1780522312203; Wed, 03 Jun 2026
 14:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com> <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
In-Reply-To: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 14:31:40 -0700
X-Gm-Features: AVHnY4LsKDQ8qf8M6LcHYa40LO1DYv3gySsCGNMqZCGh4-xivJwaSH-NzjuOFXE
Message-ID: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: s76pe4rdw9qobzkzoj385ctg1ooz6q65
X-Rspamd-Queue-Id: 434C040009
X-HE-Tag: 1780522314-547485
X-HE-Meta: U2FsdGVkX18C4UpoJp3Hr9DRZQroVk+xJrTLwsGAoXKcbXsoTJFKw3rd6Hf1FvFfDA6V3K2S7+u8ci8k80/mftNUGQ1u9OS2zrI53LbKY9i2q3mLcLO5cwd2F2LFucAx+Fg6+oNkFx2F5DXP7x7M1VdPEMx8x5Iq4pbYghRQSm/LGD9Vxkn+U68QcBgF+Wk8rtt7jj4conKpwqIAH4EYVtrms3LcG/3p/gRziY+NIfLbh81bJRwJFfuDrfGtMxSFJDrykHbZsB8v9hUpL3SZf8B7k28lK0RNFCVe8OrEUQP0PXNyC54TNcFD5bbEzBSMBoGwlKzDlo2wVOX9rAfrHWTnyd/623nNK3GXNuBAZvttUhJAPMTRGStRQbZaLcS4GVfGLRSR2z86mPgeCf8Kplqgk75jcwnzSKh+52ndO6VVbkw892sNlNmCdUnXmEarwQl3ferh24jM/AP81ERByGeCShkBcfX08Lz57xctcOEAaruxlOyY6T39gBQQw3AOOGNTMidv4VQss153JErF44afRhCdfWVK8NEF7yd0gAincEjBQxfi1t+3s7rRWgYfLmWonT+RnWiz0IswCBxR5035+hP9F4KGOFOoeyqCWbmxh7qA+cnSHwU//VMSDWXnES8CofA7eTvNzNYODg4GXgGuEa6epneu+Aph5GJQo6UvuNdVtUi5+NzYpilHGJBQAm3QpRWpOUnNA3W6b0pip2U3kacq5CazRXPyHcNn1Q2VuROBS1zIFT2eJt0MaH8dVFnNKfYRG8OZ6UVTYc6e9Ks2fPueBGsPe6C5YKfqIqlUJZqRwgtL4e5DefecV2xUKpDOHYc2oO9ZR4Q9+BPKyH6sFj8hRNF8e6V5wbz6TLW5CYVCPZPGXq2etx2u3WK1ZOSwUzcLzO/jDxzYV6b5df1XCmmRkTzdGwnmHPBEQf1k8l3rJr+tbu6PZpzr4IwJ44xLyKXw9oKDti3y98J
 +qppUiRl
 GYVPSeln5W8AMdsdvTL0/HWkSZGOROngeXSxJSqFTrpxRFRufnnsl8lq0EPgGra7lInVESBEDAeBT6RyaNuAu1xcVBXGtGSH/aXxK7cZTipUjsAhvmC1X8EX46Ey8pLZqVUaAnTpJ3icfoiTst2Nw4iysBc3Bu6cdTntN7ngCnIaKiRCh4qBAF+tYhpKLJjVoWZP+Z3QZDmeXLIBvo/4egW1prrWEu155VxY5iP5+ueLfcbR1mTP0aGHr4UONOYfqmpdPrJeWgBSpeSLSYj/nxvCMwz109Fv85cDyK16silAB82F1PU7nLYVNfPoLK6uWWrATGdolhjxR1SEcwKPvUzUL/B7mlCL+zDekgDV4s/KVwaSvV8kb6RHuh2zLz5rulEMQPtTytSfhUQqS6rha6qXF/u4fIlEipe/g+4q/QMTwpnMow054XNLizdl/UReZ3t/q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:29=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, 3 Jun 2026 at 11:10, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > So maybe we should make sure that, if we go down the route of
> > disabling all the splice magic, that we leave an API, maybe the
> > existing sendfile or maybe something else, that does an optimized copy
> > from one fd to another and that is at least capable of sending from a
> > file to the network with at most one CPU-side copy.
>
> Why?
>
> That is *LITERALLY* the attack surface - and the complexity - that we
> should be removing.

I think I buried the lede too much and you're arguing against what I
was trying not to say.

Maybe we should keep an API that does an optimized copy, from one fd
to another, that can send from a file to the network with at most ONE
cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
for one.

If sendfile and splice get completely deoptimized (which I think makes
a considerable amount of sense), then I think that, as you said,
there's a risk that the most efficient way to send the contents of a
file to the network is to read it into user memory and then send it,
which is *two* copies to get it from pagecache to the outgoing socket
buffer.  But I think that just one copy can be done with essentially
no funny business.

copy_splice_read is conceptually not terrible at all -- it allocates
memory and copies from page cache.  But splice_to_socket involves
MSG_SPLACE_PAGES, which I think is a part of the mess that you
dislike.  And the path where one does copy_splice_read and then
splice_to_socket has to be a bit complex because of tee and (I think)
because splice_to_socket cannot assume that the incoming data is just
ordinary unshared buffers.

What I'm suggesting is that, at least for network families/protocols
that care to support such a thing, there could be a slightly tedious
but otherwise utterly boring path to *copy* from pagecache to socket
buffers.  So, once the copy is done, the skbs would be ordinary skbs,
exactly as if the user had called plain send(), and nothing downstream
(the network drivers, crazy crypto code, etc) would ever see the
difference.

I don't think I'm suggesting keeping *splice* as the user-visible API,
but maybe plain sendfile could do this, and maybe someone would add
io_uring support, but all the complexity would be confined to the code
that does the actual copy and not spread to anywhere else in the
network stack.

--Andy


>
> sendfile() was a mistake. It is literally the "file->socket" thing
> that has been buggy.
>
> I absolutely refuse to get rid of splice code but keep the buggy sh*t
> cases that caused all the problems in the first place.
>
> Because *THAT* would just be completely insane and pointless.
>
> > Even if we=E2=80=99re just doing that, I continue to find it strange th=
at we
> > require that a pipe be involved. What=E2=80=99s so special about pipes
>
> Again: it was never splice or the pipe that was the problem. Stop
> barking up the wrong tree.
>
> It was "file data to socket" that was the truly horrendous issue.
>
> That said, to explain the pipe: The reason for the pipe is to act as
> the kernel-side buffer.
>
> Now, these days we have much more capable iov_iter interfaces than we
> used to, and in that sense the "pipe as a buffer" is certainly not the
> obvious choice now.
>
> But even then you need to have a *handle* to the buffers for the
> general case, and that's what the pipe fd ends up then still
> effectively being.
>
> It was also done to avoid the M:N translation problem, because people
> wanted to do zero-copy between other things than just "file ->
> socket".
>
> But again: we're ABNSOLUTELY NOT keeping that "file -> socket" thing
> and getting rid of splice.  That's literally keeping the bath-water
> and throwing out the baby.
>
> Splice is the *good* part (well, relatively - splice is bad too).
>
> ile->socket needs to DIE IN A FIRE considering the security problems it h=
as had.
>
> I hope Jakub is right that the problems have been all fixed, and this
> is all theoretical, but having seen just *how* many there were, I'm a
> bit sceptical.
>
> Because if people think splice is complicated, you haven't looked at
> the skb rules. They are completely arbitrary and complex and spread
> all over the tree.
>
>                Linus



--
Andy Lutomirski
AMA Capital Management, LLC

