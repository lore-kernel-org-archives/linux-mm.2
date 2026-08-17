Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48456C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37DCE6B00A0; Mon, 17 Aug 2026 04:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331B16B00A1; Mon, 17 Aug 2026 04:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D526B00AC; Mon, 17 Aug 2026 04:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC56E6B00A0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:15:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E13FA06F0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:15:18 +0000 (UTC)
X-FDA: 85110051516.19.4CE483D
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6E93C0006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:15:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kwf7hz3O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786954516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JMAzOs5+LtBIqUezQL36zcGBLXxM2/IsK2lzs3jOBk=;
	b=rkB3pv4X4TWGVvU+hMkO71yY9bNde8Y+Gic/2Ab39eVZsXN3g6hQuJrwau5apJXze3EUO3
	rGJcgG+8VFzTI0tIIXAA0UnJlukC92PZ/OIX+jIbn9qElh+koJu8TWBqmROLhX1Bo/Q57t
	Kx82WMD5ZIkN3wN/GAmcYwItsAkz6Mc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kwf7hz3O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of thehajime@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786954516;
	b=iV8yVOApo9yKzhDlOheWyFDghR7/3RSF82ey/5bj3jHANi1vBcg27S72FU4a3eHqUOp8G/
	/XeODLZNx7mkLLuDmx3+0kap3X2+WDVZAS06a9rh1125f3zc+JjRTslmce6h6KlKsLLbmZ
	+GlcMhzPdzGpRcQA7PrCaDzpJqklrks=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso1958107a12.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786954515; x=1787559315; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9JMAzOs5+LtBIqUezQL36zcGBLXxM2/IsK2lzs3jOBk=;
        b=Kwf7hz3ON1RIH63pFTNbhAQtq5Je9IpLxvB6nrtuQUr2tWc3aLVlMNsudtvuiZ/jY3
         GIIJ5DL3GK9UVelWgx+8juE1iQgT7jUfCiG0k97IerIRtKZ80U0LOx1oi7V5szCCO0rs
         zcySTGj9G2devea6qXWw087rOOgMfdoGMhcFhS627mD52Eb7qdyjgxh4eT/5phHbX+Ir
         DcXI7OwpPjLjbGW3uDTivVh0aJ2biUhpncau7MVCoFtBUR0QSkrWR9DKk+SwQ4bk7Hqi
         BEwd/CUpXwqUSgHDD5Ec+48xltxQugIO4INc2ergf3hFAM6hQUrY/REt9EmyzI3odWUS
         5Ohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786954515; x=1787559315;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9JMAzOs5+LtBIqUezQL36zcGBLXxM2/IsK2lzs3jOBk=;
        b=PEQrEp2z3snaurrmFAvvib8/HII+VeWhtXI9BcY0VtTMZv3MIDOhmAnRaldIxu1jBy
         BwkUWyd5PiL1BzQVOpqQQf4yNs1dxOJ/SiAvp8DvxD4boFTuPQ6tPiEwaJ1897zIfw2e
         6fBvhvffoAZoI8Uiy9CKB7Rp6YaCHvxQCBEKAdS90zjapLYfSIocxxCvMNQvSc9TqvrL
         qUK6twF1x8pCjGL5b+8qPtmjwXZL68OwBWG6vjG0j4a4+q6N6DkdapAtsw5ie6P5v717
         jgXDZaigcB1Z6O+Cj20gxa1MeZQhX7YuOy+7OKb7FxN8jhiKpX9Yk/xfgteWI1Ai4BuI
         pOrg==
X-Forwarded-Encrypted: i=1; AHgh+Rr6bvcUSL62DNr4Q5pTdliiakDvNqBpChojPDJQYjrIh7qPJRPkRhepWUeaIL8OS8603y9CMBqa3g==@kvack.org
X-Gm-Message-State: AOJu0Yyyfsld23E8Gx3HF2ncn4J0WKp/Tw7VgakGZamHfc2bxA5uCz/E
	OeGoLMBePN8kzPyShA7RPr0rJQEedZTJqoLp5GjahbYLMq1O/ftMqnzp
X-Gm-Gg: AR+sD13pz+wOgP79TnKQYNP+QzLFPeMQQCbIh8ov5spR2u4uPlKJW+3VN6JrWBZ4tdb
	4x9YEVoNOfMq/1gjFpz3pNHFQEegoJC4AKNmDXLYr5NtZFOJwA+uOUOoDkWPbZla6ABSHhnIED+
	ITSwie/9fVcudWAbiKnZ536j/Gq9YEHNcyj1+MraRjVOK7Eam501RwMN8OFLkJCmj+BahHH8AU4
	x26G73bya2x7/3zq4ap7h0/9F5xk4T78BkO8q/1UmpOC7fLIfwqHuyUIFJ/Z+kXOkl+xSaXfEe9
	YH6jNfEH77r+bgBNpfzHs3kfrUWyqP5CTvMHQUd9EisuZjeWmBFsLdiivlh+ez2XHAgESyDVBci
	+XPSzTvZxUd0sR92TUPr0TJyEdVsuHt4bwXeWeaeG5pqAFIErm3A+cxIac25qKW8qaapPJ+CAyI
	nuUK0jamgjK8TtG/5znMjBBeS7YCGoaUXVdSzq56XZjcZ3J5kSAgs+Kh+3sO3Y8lWzSzNEfacJE
	yndNJ8W/RI0Tb9cxn7bx794BdZhnL3tjxZ3s9NDVZL4FsKqJekv0rFMlhmiCREJqx+xxmsqKVQs
	+zbHdcH1ua0=
X-Received: by 2002:a05:6a00:4481:b0:847:770f:da4c with SMTP id d2e1a72fcca58-84fde405e20mr22174169b3a.16.1786954515325;
        Mon, 17 Aug 2026 01:15:15 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8517d223d97sm2255073b3a.28.2026.08.17.01.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 01:15:14 -0700 (PDT)
Date: Mon, 17 Aug 2026 17:15:11 +0900
Message-ID: <m2se4dp3hs.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: daniel@thingy.jp,
	gregkh@linuxfoundation.org,
	linux-mm@kvack.org,
	geert@linux-m68k.org,
	arnd@arndb.de,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	liam@infradead.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
In-Reply-To: <an8PTKUAuZh3BtJm@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-4-thehajime@gmail.com>
	<2026081355-remold-sterility-84f9@gregkh>
	<CAFr9PX=zC8GnxwrR=wTwA4xQq89cHYpxZWooS+-=Q-WuNbjanQ@mail.gmail.com>
	<an3COKVbgQKdY52d@lucifer>
	<m25x1crhym.wl-thehajime@gmail.com>
	<an8PTKUAuZh3BtJm@lucifer>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: wf5b7z8syymt6x49tg8zsnrokucq8o6q
X-Rspamd-Queue-Id: B6E93C0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786954516-385257
X-HE-Meta: U2FsdGVkX19l52UwxAvjh2jPzkXQBOSICClIO8WsNzTwolOFhkaBByL1aXQ5uFs9VU2COtYwW7U+fuVa1HZEWlecBiVxOfRbSci69kqoblHLH2IdRVcsaI41jRoNmP+34eJ1TpLgHMj7tuhlDijY+wSQR+TLKynj/RHA6dw8plM8/6YaJG1WBf9ZV3E++TZkorSv5+bi5SaCKSsxQ8EgNpdGtZlB+EmaOjeYRm40Gjx5pU4YalOq8esemqmLBl5rRNkQc9yKfUgBzhZiuB5DjTOxuT7pGYqyhl8W2bFEPS513k4nq8Y/lm8QwStD+lydlQxTOdaADxbARj3Z/Ils6Ai2n3O/buBDorqYNBtH1jIGp8R+evbc9P8c1RTeXDR5gc3xMpyZdtlfGgKN9zE7GZ3qcs4u0yjqqqW0zdxOorZBEhO+2HpXH3DIAdzg1libfIV7x6blm9xRUhz1iCzuGLQyPsBp4YjPF9acG63ReMfr9jJyrvnz5s9BAX8LAi6U/nXXQ51pGF1AB7Xyk6TlI1J6cvR55nYu9LSfAoUoaXqxt95NyoTsPFg6uyPXKXEereQ1W2wbPr1EgJhQ4NSdu+kDOHNtl9iqzLRkf2QT/imdDRS15wIOHBiJnB1DRY3JizvHfxwaJZpGBp9W7QZl+dqdgVbFrmoxta9WcHuISFqp9WTFHEs7VaUw+wEP0tbE3ulKRlBpvJfCkBCW9vyUhKD46SKFjkbJsSY+ojRdYqVH0e5bcC1qbKA02SiQqXitgcjFk3n2Bd5zxrHA01QnkFPI0CbHuNJtVcbbmUa8VcUNz/EgLDvHPDlUPnMFT1OBbdPwkZYJmsn863/Tmu7Io2j0yiBHNAi2udbkVkVOz9Su3ES+y/adjzce/z9+FNMr4YUjQf0dAoTHiCFGueFZvlrNUFPDwJu06H7Div5bhApBudLCLBSLJrp8k4UyVVIPVuV1W3Kt9sw4gOHo1wt
 nc+YH7pt
 +PAUCMdHD2/9NEhSBATsMp0ikCjqYTyFC7m8+OTANjnU1eEDFnpzfriEPdX/Pa6zp7wQFPdGTBEygCXAmHjf06eRLkpwglJ0HluwEb27BuRIsbEz5W8wrECWsiWg3r3rw2VpWcR42W1toUklm/YJhtPFnM0qREnHItR25Y69byubKbiJmF7CmqX7h9Oh3vZ/BnCu24q9mWyJn1AnMTSQafLW2mdy7JYi66G8ZJEswRTDVBHhlRHLue0oAOhUbwvZybIdfQR+yioY3ixcBBIxkapdPCWng3/y/Ysuwfk1/Ht0q8ALjar/qjLZfUEO4SqJqY0JHYyXgKtmJueXFVNOnFgue38Vlbt9CUZv49+hpEJiTFDMgtjnY5RtMmq9YIEH9KM9OnlWOipbi28BGrWqopNT/n6jMA2VN6bEJDgiseSDz2AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 14 Aug 2026 22:02:21 +0900,
Lorenzo Stoakes (ARM) wrote:
> 
> On Fri, Aug 14, 2026 at 09:42:57PM +0900, Hajime Tazaki wrote:
> >
> > Hello Lorenzo,
> >
> > On Thu, 13 Aug 2026 22:29:38 +0900,
> > Lorenzo Stoakes (ARM) wrote:
> > >
> > > On Thu, Aug 13, 2026 at 09:43:37PM +0900, Daniel Palmer wrote:
> > > > Hi Greg,
> > > >
> > > > On Thu, 13 Aug 2026 at 21:26, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > > Given the age of this issue, I don't think anyone uses no-mmu systems
> > > > > anymore :(
> > > >
> > > > There are a few of us using it for hobby stuff[0][1] and there are
> > > > apparently people using it for actual commercial stuff.
> > > > There was a session about this at LPC 2025...
> > > >
> > > > One of the big problems for nommu seems to be that everyone is
> > > > convinced it is completely unused and totally broken. :)
> > >
> > > No, the issue is that nobody seems to do any testing or contribute any code
> > > aside from at least Hajime (thanks Haijme :), and possibly others (forgive me if
> > > I am missing people's names here!)
> > >
> > > There's been situtions where nommu has been broken for a year and _nobody
> > > noticed_.
> > >
> > > And yet whenever nommu comes up people always seem to pop up and say how
> > > important it is, then mention a talk etc.
> > >
> > > Well if it's important, test it. Test the tip kernel. Report bugs. Contribute
> > > code. Any or all of it :)
> > >
> > > Meanwhile we in mm have to _constantly_ fix stuff up in nommu because it's a
> > > total mess and has real maintenance overhead.
> > >
> > > Having to account for legacy systems that make no sense in 2026 when you're
> > > trying to make improvements to systems people use, or not being able to do
> > > certain things, really grates after a while.
> > >
> > > I mean if you don't believe me git log mm/nommu.c. This overhead reason is why I
> > > now co-maintain it.
> >
> > after spending more times to look at code, fixing issues, finding
> > other flaws, etc, now I become to understand what you meant in past
> > emails, when you're saying a more maintainable way of implementation
> > of nommu.c.
> 
> Yes :)
> 
> Thanks for having some empathy about this :) It seems a lot of the nommu
> advocates simply assume it's little or no overhead and is 'working
> code'. No and no.

indeed, agree.

> I know Liam had to do a _lot_ of work on maple tree to make things work
> there, for instance.

yes, I also encountered an issue involving maple tree on nommu (with
some crash of UML), and initially it was not really sure what was
going on.  It was not an issue of maple-tree itself but the usage of
it was not correct.

> And the recent VMA flags changes have had to be heavily updated to account
> for nommu.
> 
> And the list goes on. New features have to touch it all the time to avoid
> build failures even, and etc. etc.
> 
> It's a really absurd situation to be honest and the RoI isn't there at all.
> 
> There's a reason I keep going on about this :)

I still understand your pains.

> >
> > Since I wish to use nommu.c in future with the latest kernel, I'd like
> > to contribute it for, let's say, refactoring the nommu component which
> > mm subsystem currently has.
> >
> > but for the moment, I wish to start with introducing test cases from
> > very basic checks (which is in the [6/6] patch of this series).
> > Without such a base, we may not have any chances to improve this nasty
> > situation of nommu component in mm subsystem.
> >
> > # this motivation also applies to LTP (linux test project) which
> >   currently doesn't support running tests on nommu platforms (I've
> >   already started).
> >
> > And also as I mentioned before, ideally the code should be maintained
> > by people who use it.  And if I claimed that I used/use/will use
> > nommu.c, I wish to maintain this, or at least wish to help to decrease
> > the overhead of maintainers.  This series is a very fist step toward
> > this.
> >
> > I hope it clarifies a bit for your concerns,
> 
> Thanks, and I appreciate that you're actually doing work here, but I'm not
> sure a single person suffices for this, as well intentioned as you are.

I agree.

I wish that having public test cases would motivate other people to
fix/improve/extend code (because his/her patch has less regressions),
to make this initial attempt useful for broader audience.

So initially this is just a one-man contribution, and I also think
it's not sufficient, but I'm always motivated (and assumed) that an
initial contribution could open the doors to the any other people.

> And as reviewed, these changes seem to be adding _more_ maintainership
> overhead rather than less, I fear.

for this /dev/zero patch in a current shape, I agree.

for other fixes to the shrink/split flaws, I will try to improve it to
let less overhead to maintain (by addressing your comments).

> I believe nommu is pretty broken across many domains (it's fun to set
> claude on it for instance).

ah, I also have thought about that.

> And we've already spoken about broken things that have sat around for
> a long time.
> 
> The way it's implemented now is just horrendous in any case, if we were
> forced to keep it in the upstream kernel then the correct solution would be
> something that somehow 'emulates' an mmu system.
> 
> But I'm not sure that's even workable, and likely implies heavy
> maintainership headaches.

Indeed, an emulation of mmu would be one promising direction.
I would like to spend more time to compare other alternatives for this
goal (which might not be a trivial hack).

-- Hajime

