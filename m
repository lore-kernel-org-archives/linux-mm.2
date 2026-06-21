Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D06BCD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 23:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BD26B0088; Sun, 21 Jun 2026 19:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06F06B008A; Sun, 21 Jun 2026 19:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCDBF6B008C; Sun, 21 Jun 2026 19:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8A06B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 19:01:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 099E3404E1
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:01:13 +0000 (UTC)
X-FDA: 84905442426.15.EB35BE2
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id B78E8140008
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 23:01:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=XUhy6sJs;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782082871;
	b=TfK6ki7fELWnMlUfdmxZinE+gobhIMxx8BKYninYPqbadwd3iM/15K3cLqX5UZtZHoAj8c
	8IMKpItrDv+LloSzX2l+bNG8ZmQaYRE+EOej8YWye37nRV6Cc1vs3B8sVnTMlUC1jFWyfX
	/lip9SJ5J4LWqyC815INcHdXYeVNIyM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=XUhy6sJs;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782082871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ayxpk5lMi8kgF5G790ndxiShXBXkVm3vjul0YcGB4oE=;
	b=GbE2qeayXr/aJD8EyXAfWWbqKHyo2IK7eGG/bAuiFy0MKcxl6aMFezGhfXCy6aJmjNv/xU
	IBxTAvkL8Xei4sdJ5VpmJ1FtfrE0fo4JT6q6tdtSJ0OZirTHWN7qVneQt7U2ZfgkmJVdUS
	KvM/dUinWsKIFunnNCUgoqcEQ9CROOM=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bec450b950dso524145466b.2
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 16:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1782082869; x=1782687669; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ayxpk5lMi8kgF5G790ndxiShXBXkVm3vjul0YcGB4oE=;
        b=XUhy6sJs/CSyCWLiynEw1Xl+/inMzCqiCOq7ay+AH+5+nlflSXB6tZzQJaHt8WQ2sF
         Wau23ah5ZJuY+9Vs8uC3H33baNJ+kQJIuzXpZg79LT6f4WXiy6gzQtOzvIoxDQ02hchP
         AcZrOKxOxMGpCGCbXAs4iPJlwdsxDWtyQ+sqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782082869; x=1782687669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ayxpk5lMi8kgF5G790ndxiShXBXkVm3vjul0YcGB4oE=;
        b=AJ2h8iPG82dlPr9CzI6PFGAP7w22m9xZRYHcpOWIKatmXOnOMY7oupXUqcsBrDG2WH
         g72M4in4ypfIi49FTKQmIKrZwCTKanAF1XphaT8//dCL3erNILJV3ZTSCmMNq8hGh1wX
         riNf1FIeElOhGtgR88D20kK61txpS7CmJNZkYXwYIX8speskgOZRrBMfYsZQ+ICTsoPB
         AfqQXI3OemecMs0NJYDxzL/IoqVGS0DlxMJMjjEfMnuQK5X25kZ8sqVUpl5Ta/+dy02E
         jnboCsDgx38EpdFWNTAFdaASm3/zVoTCAnzSWes7gOQ/NN2YJA49ipOM5b+yrVlFQgRI
         KjBA==
X-Forwarded-Encrypted: i=1; AFNElJ8oN551+r9fb+PhGCkSRiaYvbalG3StqlWhgbuTyFWT9EDCVSW05/pmDCULiBnC5J4sOvMzqVAazw==@kvack.org
X-Gm-Message-State: AOJu0Yyj9PiAdBQKyMUIFDRktsobNd2aKaaJdXPyckCGWSY/Medtinel
	3+5y+sDmfzTSMtHVJhlYRcJ0+H69Beah7qAx66QERNYp4IBA/U1mH4ZbZtXyVTCgC3cqRyrdlMq
	9sRD3Pq/6xw==
X-Gm-Gg: AfdE7clbH8zlRbEvWdab0sPbiaCWC/n4/j/vHQLSUNvcy+4GiuUnboStvnGZVHouC6M
	jipWQHfWfv6d5+GV+ofkWpasiypabnFaHLEaFlK7iW1NgRBE8D2Jz+3IhxtMAtvlm/gedyYCW1A
	uyQGvjyI+KuJ5g7MKvHq9M0UzZ0ZiZIV/zsND3PH7c9kBvO3SY2+N6M0wQiN16z9FJ0PFkW2QQW
	6NQzoV1JiWCwOzMXCSgLrNQmgH8QuZf4693Tsh1H7DOLYa47jnDNAvHHQxSHhxfc61LPtlrKN0l
	XptAO99nmOedNgONMZK47QC+f7sNsCNLn+roMuhaWVXxWeKG6Xcr4GLyFyYFeLkbfaYGEkUtzNA
	0kShdLCvyu4CERK4Zdxz6WIuDQNiIx8UwdjPlofeA+tVGBuXnJEW9+4vlgdlphFQoQyvxVbqdMs
	PiSOp4QSs9ol4B3KbluxW6/TBFhYfQZvd/FQooMysHO4kpDS90+1T7Hp082E66c4EZHuNSv5o=
X-Received: by 2002:a17:907:d649:b0:bd3:6ec5:f141 with SMTP id a640c23a62f3a-c0b743ac8ffmr561758366b.30.1782082868840;
        Sun, 21 Jun 2026 16:01:08 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c60ac80c8sm243679166b.40.2026.06.21.16.01.08
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2026 16:01:08 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bec450b950dso524143866b.2
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 16:01:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/7hzcZJAZUPK4TRV4e19HKsoB7Jzyqtt+H3kjpUsy5yPhEWn+mgRz4VlxMXTQBoV0RGu/exOj+Fw==@kvack.org
X-Received: by 2002:a17:907:7254:b0:c06:5ce4:7ca0 with SMTP id
 a640c23a62f3a-c0b75b9034cmr501551966b.53.1782082433619; Sun, 21 Jun 2026
 15:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev> <CAHk-=wjwdbrwUpTiQef5eAd9pfC3bKig9YpXxoHQinssubRh=w@mail.gmail.com>
 <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
In-Reply-To: <839a2ea2755fdddf5af773e006237b07c9e261df@linux.dev>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 21 Jun 2026 15:53:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg2H=0Uf5skMriD4dhv-UM78UmZwrJ9+QCyq-keQKCubw@mail.gmail.com>
X-Gm-Features: AVVi8Cc9exsaNG32LrKZVpIWvCzlobZG8EYlo8msA-PdfbSNmBeEMkDNyHrU1Q4
Message-ID: <CAHk-=wg2H=0Uf5skMriD4dhv-UM78UmZwrJ9+QCyq-keQKCubw@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: Gladyshev Ilya <ilya.gladyshev@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, ivgorbunov@me.com, Liam.Howlett@oracle.com, 
	apopple@nvidia.com, artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, foxido@foxido.dev, harry.yoo@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com, 
	pfalcato@suse.de, kirill@shutemov.name
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B78E8140008
X-Stat-Signature: n8rjgnqzjcmkqe5gf89omk3xucz7tqse
X-Rspam-User: 
X-HE-Tag: 1782082870-157753
X-HE-Meta: U2FsdGVkX1+UfZHiCieMYMyLlUljzeeq6WcGwDkXq2aZWGxoyMfiBBQknmODJtkCo8qvN/d7ZhcPMOjRmP2gbvVupQDv3CmPesfnIneyYQ6Ix0QGW7W0Cv7Vc5wzMwsezbhr2ME4DJgKIZtRnCSZ+mx9lFho0hIn0lCKeYYwwcf87hz2cdSsyEppxOtxoVWKfVi0WkTR5F6ltqc7OvG1jUlba/MiSoM5RP6O75nUOAvh0H6lpHxG3cI1zA5M+KH7a+8okqbA3doYzEOIETzYeP23tRC7HNXZaS82UFFyuYS4s0RQEIradNezvXZ57ve0b0Rbk1Upgitc1ajgFm0AJOvcp5ZHY9uCvoNZL/KNfmor0Ou1G7ngY99Sy1fmQYuRxprmlU3ix4DJKaIbUZWLPHkMWSjG/kCNAlqxD/81Fufs1agp7+CGHz5h97FTHiEg1jD8wdH7sKxMRpsiUFxwCjcOAHitlxVW2DAh4PpTKQF7RvC1hS8trhtZDF9LNqV6HW4KTwkyHPAfXMJr06cO4SlfSAxlw0p9n9UCH49HtinZws/J01SuQgF1tX0CRZolpyQKV4d7Ap8pteJ7HZ8sCp99lv5NcIv6SZCfYeAaF7USMOx2amzi/uzuaB1YTr2WF2cCm1bJIau2mOoj0O0H3X8tyYeA9CFiXJ9soSxMcvxUL4jU8ZgBLkUM8MTTs+e28Eeep7EteeCXEe3Y039CO4ej3V62m7oMrhy1J4B72ywPbn8QHXQnZ7IX4g0dhTQqOZa6WvOnTiakjaPIlDN/OCiuMiIK8y382KsaYc3PTpOrIYCe1BdoX2Bgc/7jNbB4rCvEF2Zki1KZexBEqaxAE7x8YZP8gd0qD8r+sEP2FEm/fK4u9BDU/L+sjD+R+J/KPG7CeXBjKZ2UWWgqMhF/x16mzGFo4L1eM7tJCLciHKRsWqC8l/10mH7w5rrlmAPPqXOJU4krjkG6N+cULst
 hE/dQ8Eq
 QVBOTPkNurIwHd/nlkbIk1VmDbXP3rAzOjeeAgKQvkX5pmjeK0yOwVR4K9DbfPeZ22Z0+3YJrwENYx7wnywe6Z17UNiu82Mq11AbDIdtnqU/XLylV6G65/EF0s08OTgY9LLvyoQ5KWLNS5Kw7joUdcMnCkiBUUXATB+wC9L/i4VWdqPRTtGvUGCcL6qxhi82rZkXGw+LaGxQUGmF5bvZGExQ9HPQf9Bh35c8bItN5HBbIgVb0FOTfbNXFRh7enTsG62KWXiFO1gWCVUeX27E+8iDR0sgLGMlmCIc3pJRixJA1ERxem8wWe1Js0fxJxiQe/BcXtQpKqlcb+56oiTuHJPXAjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Jun 2026 at 14:34, Gladyshev Ilya <ilya.gladyshev@linux.dev> wrote:
>
> >  - everybody who sees it go to zero - optimistic or not - does the
> > "zero to frozen" cmpxchg
>
> The problem is -- the zero you've seen and zero you are trying to CAS
> can be different zeros if the page gets reused fast enough.

I don't think re-using the page matters.

As mentioned, the only thing that matters is that only *one* entity
does the destructor, and does it using the data *from*the*page*.

IOW, for an optimistic failure case, you can't decide "I failed to get
this page for my use XYZ, so I'll use the destructor for XYZ".  You
need to go "I failed to get the page for my use XYZ, so I'll use the
destructor for this *page*".

I think we do that anyway, but yes, it's worth making explicit.

And if it wasn't an optimistic failure, but a success - then it
doesn't even matter.

Because even if it was released and re-used, the definition of a
success must involve having checked that the page matched your use
XYZ.

IOW, let's say that you *successfully* did the 0->1 transition, amnd
after doing that transition you checked "yes, that page is still in
the radix tree".

Then it simply is entirely immaterial if your success was because the
page was released and then immediately re-used for the same thing.

It doesn't matter that you didn't notice that it might have gone
through a FROZEN state, and then been re-allocated and put back in the
tree: the end result is 100% the same.

Yes, between you looked up the page optimistically the first time,
somebody could have done all the work to put it back in the page
allocator structures, and then somebody else would have re-allocated
it again and taken it off the page allocation structures and put it
back into the page cache radix tree and might be in the process of
being free'd *again*.

And then you come along later - after you were interrupted by a VM
delay or whatever - and now you check the radix tree and you see "ok,
same page, still there, optimistic lookup successful", and you don't
even *realize* that it was free'd and re-allocated in the meantime.
But none of that actually matters. Your lookup was a success, you
updated the count from 0->1, and that page is valid and all is fine.

So I think that yes, there's a kind of ABA thing there, but that just
doesn't matter. The whole point of "re-check after you got the
reference" is literally to check that the optimistic page that was
looked up is good to go. And it is, even if it might have had
something else going on just before.

             Linus

