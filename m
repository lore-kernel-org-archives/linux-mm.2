Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E54CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A059B6B0005; Wed,  3 Jun 2026 18:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B60C6B0088; Wed,  3 Jun 2026 18:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5876B008A; Wed,  3 Jun 2026 18:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2B06B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:54:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDD88163341
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:54:00 +0000 (UTC)
X-FDA: 84840105840.02.7C5690F
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64AC0100003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:53:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="Ub6pW0/F";
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780527238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d66PsLO70IOujHc9tD5MHey7l/21gIQRZ4eLyqG6j78=;
	b=rfNii3yE2tlgGoJ6wkoG7QRwxKjBt1ODLWjegfFvk+3b9YSzj+87pIDUkKm2kmX5g03iOm
	xarH0Yv/okbnBmkOvw4xfvCxRUIXGQYvgDbk62MheWBUpW8IYoQWTRhrpzNHdP2QxhQi7j
	jDi4tggLbS5p/ghJ1NsPXZkq1XzoDkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780527238;
	b=NNREYe5ALSh2pnuyr/nk3oH6/IR/XDdwRPFtzRU5oQin2Vy2D6INETU2N1/OenIdvbZWpl
	H4JzYbV7ql/1UcHUPRvHgTEPrEvMQinNCn38DAjuu7spSKr40PcwBlj5Ald9F41qv14jl+
	HkXwaKxKlmBzWtFNIzfgFFYptgcBS9I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="Ub6pW0/F";
	spf=pass (imf05.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c858b392697so36803a12.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780527237; x=1781132037; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d66PsLO70IOujHc9tD5MHey7l/21gIQRZ4eLyqG6j78=;
        b=Ub6pW0/Foma/0sdwPgNz1whvr4CCitZqAjC9VDH8jhC5wxTo9sx8iuUh6Yus/RoZlX
         Ksc3K/D8qanOINFxUvUhjcZucSJpkgqa1YggdjR6SrezdOD62qUGbkeLtg1mym3pjsj+
         iBvfMgChWBqhaa0sP7vufACq3vBCBzdtozU7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780527237; x=1781132037;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d66PsLO70IOujHc9tD5MHey7l/21gIQRZ4eLyqG6j78=;
        b=EGG4xtc5qTcCkXP5SB9+X7KWFDI+BEEA02SgbqsSS+Tm0xxVqZ4DdLGqEF+Vy3KupQ
         JxLBBpMeMNPOkUBsBCZpOFS2xkFAZ1nNKgHrfIThwOayK5VVGEYZ5XQq9vvt4R5ax3M0
         fuuDLCVway9BC5YUoQyueguk8byhKVsI79VWjkP39XO5OZu+SQblddd/mzogbgYWSV7E
         kYltGLt2RQTTmY3sjKYkiiImX/ttKTSXWJ2tUVV2orHOSjOUonQlxZxPAA853uskf0R6
         SDHICy02lTGYtKsf1S96waEFWP/kWLqYeH3zAQK2NxBaRL3IQOuNrDAm6GChSYKD2M+B
         Qa1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8UdCPGlk7F/Aia+zIj99qTjESpZxi1P1ZVPmCLrnBxL8O9MUhxvzi8fd2R5I57mGDd6B77ZlQRjg==@kvack.org
X-Gm-Message-State: AOJu0YwGgLje5KFnnEHMEGEJ2Dz53mDwuAMsGJBFXPIhhoLcdnlT2UqO
	9ge2cGf7GEgftp3bQv528VKUjd0gDQX2Zr6GmaR7oxsAiZdAaJ5HjrLowsuEHU+RcBqKl6mffpn
	QmF/VZXmu4Q==
X-Gm-Gg: Acq92OEk6xKrg1l5rn9GcB/0qlEivWhqZMm2fBAWVQYA269luitU/ot1boEh0TDXJse
	8khwR9sgi11O6A+c+ryiYhcEvvizDb40ZG5/gvZOae7WwiP0lrGaoGt2CiNo3g0X28lDz7JyGwr
	L0eDqUqVWyss/5AS4BVcEBHchB3NFrUnVFuhY6Th66yI6AKUx1z7W2AT705z82n0yn2i8sBgxbe
	30lCvCKFEJcajY8fUwweOHQU/V7alcS6dK834kfKo4WNhgYtgX+Zz79hnnMj1z5ZWlRZcGBqtqZ
	Z24LNKd63Em392uJb+22q27kS4zGl4hAAch93Ty6T/FA7GV/1DV37eismI4O+ZsJ6pJU8jn/T40
	3975yHzlSyYDPiEuLzqiaGrUOe15g9F52HAAGzhr0DUyMEZAsWIsFK+JwGqCKU3RN8lsxdTXqiG
	HokTrod1Scre2Sol9/06YGp0kxxN3zCxQYlHoFeewkfPSDpVgxcnNQneqeAByvmTvJ1lj02RFb2
	VVfzhl0WLY=
X-Received: by 2002:a05:6a21:6009:b0:3b4:79fd:cba4 with SMTP id adf61e73a8af0-3b49763780dmr6455066637.12.1780527237216;
        Wed, 03 Jun 2026 15:53:57 -0700 (PDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com. [209.85.216.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828836efsm4056657b3a.38.2026.06.03.15.53.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 15:53:55 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36b9b15af73so37350a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:53:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ80EtpRZUp2KlxB+LXq2Bt0StKs7LrJcUpUsWykfPSHde5d67XB+L1cpA1zf8nBsGBCS3USQwwXlg==@kvack.org
X-Received: by 2002:a17:90b:4ac7:b0:36b:8873:d96d with SMTP id
 98e67ed59e1d1-36e32b3baefmr4916778a91.11.1780527234968; Wed, 03 Jun 2026
 15:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com> <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
In-Reply-To: <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 15:53:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
X-Gm-Features: AVHnY4JfTnadgKQknxIsZL_Ab3vCkRcYm3kghJCvdkf-q8nXBlQAzmvvhTEK5F8
Message-ID: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 64AC0100003
X-Rspam-User: 
X-Stat-Signature: ezn1g3w5i6kzkr1uoiho4cecx7cspan7
X-Rspamd-Server: rspam08
X-HE-Tag: 1780527238-96091
X-HE-Meta: U2FsdGVkX196Y/Of9bMvXnS4bEEk3oOJLSILGk85GhRylPRxFviDzeCcLT/DXua6AEPHO63XgSyAVgkWGXOM/ntt9TL5g5P2DllQoXzAv3LtEXn7M60x3QnRMEL9BHuxmN3GZYXrFvXV22TK1T4Uz2ob92K25UGbM0mUZ2aPGd1rTRJIR2qYY4aflblZlw8HFHgVs+n3DWOUmRKvWNV1BSiWLjxLP7pnf+GFp2hePoJndIj0uhM0dkWfWfSUeMq5CrBWg4biXGDWaFqVpvw6DkkEsbx46ffygLcNLg0B+J6jzqGXJtub738Ac2zVhhacZ/297fCphxTT1ai8N0EtflvsRahcbb5Lh0W/6sEyLd8hiujbzknRBdYBTOd1/Lgl02HuuvPzM6oL30TpVcAfZ5q7UQqerTqlo6l96soKHA5A0p3Q4DMu5V3bmf2AlUSdqt8ms2rFQmAGSCkVO6KfLIySangS0Xh0+0k3TWidncKPKF2RcB8Ee45SHxyVyQBUQpf51EpQOh0vKq3rh9oTHAVSDbFGGT8KsV+RVqVxwFQ8BVb8kEPdkkmy344R7e3DnAgWDpswfQ7lbJqDsRd1L702YB+JiBlx4rMA7deXGkxHWZrIMSkuNR9yKEnNas5bMrpe7skZG9E9cnAALqDoKqZMs23yyUT8vbZ0pSScYTGVE5L08mngKlgsORXdXvgozdn2gfN9cODYbUaOivPWxuTWWgVnrwQAUNXR02r3kieg4egwu4dPdCcg4rPChHwo2KJ8wjV18OQ45I+zS6fbnF9aaEh1YJ0/8WoErmv8WvCe3W5Owjc+x+7Z7nQxUhKeIOvSiHzjhHbvx+D1IdX40TIzWLT5NXNvxGyWVUSFmExdQlo0sP7OFovZL0Epmcbuj98f+Stz6sMdfzDCFJuXJI0yU83Men346las4I1MUChtrGpW7Z4L2sDaorpQKwKCdoQIRh2NQ/RtzKieOBg
 ZGkNeFlG
 85Uo8q591slXuMT9oXZdA23AtqSC6qEeClOofzdlKXmlzrs12npieLMo1JQysadkvRPr0wg7yF7W7fRUvV6HBiPeQl1VKzzBbyLkOpk+i1z6aKzlhKez7aEWv/KflusmJxrtHJ8MLh6lCtppKN684BhKKioMUQjyjJccoVJgOMKRW8NKpuaUkjHLNdPMfTX+gggGhSguGER0RouJKj7tjBmYZQpV1zJ1ewcc+l7kpd7VD/b2YszbZY2mTyKHMl+CZIuDVBidfU/PguX5owT7odr+ioIGe9WFqOU5Ofv+29c88O2BGOcZaHspKw7IHnUtujMAanK9e7nL37B2JZSCw/IHasv8D4LRSe6i/M5NFU2s8J4Cssn3Mist/noqGa0t4D4eB3abf0GPpmGU1K1mGBBqbNx1xRAGUPGkFr1zlXWCgSmeK3zI58UUUPt54qCoM+ky4DWgkg0U9hMlgvQqv/Wn9cv5/Nsk0gzNoOnduxZ/dtI4aI2U7cekTXAF3n+sW0V+nd6yJ4VdpJwzpN3dCo8pc9jNNcpvIjyKucOnGeFbJns+vZv4Y+BRbFRPq2V6BVrua
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 15:23, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So I'm suspicious that you've possibly make bugs much (MUCH) harder to
> exploit, but the underlying awful code and opportunity for bugs is
> still there.  MSG_SPLICE_PAGES is still around, and there is still
> (AFAICS) no actual coherent description of what it means.

I don't disagree. I've only looked at the filesystem side.

The networking side does some odd stuff too (and I did look at some of
that, and had to be edumacated by Jakub on some of the subtler rules
for what skb data sharing is ok and when it's not - really not my
area).

But at least MSG_SPLICE_PAGES should be kernel-internal only
interface, and once you don't share page cache pages with networking
code I think that kneecaps a lot of the attacks.

So that's really the aim here for me - at least _attempting_ to go
"maybe we can just limit splice enough that it doesn't even *matter*
when networking does something odd and questionable".

And it's entirely possible that the current zero-copy "networking gets
direct access to the page cache folios" is a huge and insurmountable
performance requirement for some loads. So the vmsplice patch - and
_particularly_ my suggested "let's try always copying" patch - may
simply be doomed.

But I'd rather try to simplify the splice code by removing complexity
- and possibly then failing and having to revert it and rethink things
- than not even trying.

Because I think splice() is a *cool* feature. It was always *clever*.
I just don't think it's worth the pain it has cause.

And it's been around for a long long time, and after more than two
decades it's still most definitely not _widely_ used.

So that makes it a failure in my book. Sometimes "clever" just isn't
the right thing.

               Linus

