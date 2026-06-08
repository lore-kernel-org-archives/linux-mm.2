Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CA2CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DA96B0096; Mon,  8 Jun 2026 11:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154966B0098; Mon,  8 Jun 2026 11:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A916B0099; Mon,  8 Jun 2026 11:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E89E16B0096
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:45:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0BF814016F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:45:14 +0000 (UTC)
X-FDA: 84857169348.20.090BD15
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1A1DA000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:45:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f1x9fjqa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+aIFgkJHczJNgL4kcgnE8wdjpuzfAatRFTenorL55A=;
	b=F+I9Y/pRW4m1Afy1cMCo6H/K0p9+A3zDznvl4gMoGSoDXJqR8qt29rQYUVe1Z0nH8i9Dhi
	mc7VlhpLF0wINJ/t4F7hfR/l9ydmYkDvj+auJVQv3Mc2P8/p+vnLYkam18mfYFH9Kbhp73
	X7EtNeI66lIA/ANmIF9lfiMf5ZelIgw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f1x9fjqa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780933512;
	b=54mBMU4OgH+qI7ja4GTBVCIy8Jsv1xEOhJaIvbrh8xIxop2NXN892TlXdWnwWGlxW932qM
	XvnEErmeEcvWb1gcoI1IIulnIUg9rTvcBr4t3sNFttXVP5zKsohcYujAqmfZ+md7a25e2u
	T/wWdAcSILtr/b6WUhyUir0zpBIjIz8=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-68ced08613aso30504a12.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:45:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780933511; cv=none;
        d=google.com; s=arc-20240605;
        b=JiZSv8MGHcqi4NK/OKlStSwuvP3sIeYM/JxiWPrwWYtgdnOgtMyUBM91ATjxj7Qkev
         Eq4B2fXq320nLB/eObKuuIEpm9sagEWdQmHubGbdImtyrSsy/omq7iG+BwR3yOQ7jEbC
         Y17uN6SCBQQ4ehKMhPmSZNF+hRDUkz4b8zx/055TIDu00VPrIeR/FuAfIfQf/tWl5TVg
         NRBaqpDdVjyn2v6R1MUZvvNoAfyzKfz/eX0KQcw9C+Er5nBlr6EkxpOW9F/nG0Mim8lx
         FkuTg+eg4+oJr8L134FN0Zj/CqS06Hw6Q/zt2fAdYZS79sZ3QWfLGe6HExOUQeq478Ur
         Fhhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J+aIFgkJHczJNgL4kcgnE8wdjpuzfAatRFTenorL55A=;
        fh=BJq4/q+SYcvU//wnhVtcqP5HUtJUqlq6vVn1202VWTU=;
        b=EJGVI7rCNw+7BWD9Ve7uI2wNx989duUWLuaoVswf16o/0tDRrYlvQeYKJjAZdtidny
         5yGOLUF0NtxWoLpIyXGaFaH4OM0AdsA+bAESjtqK2AVB43CwikpJB+yK4Skt2SOztYk3
         wIxZjvlwh2s3GzCFxSiOYESztmV2YoojsNa1CyKr+v0jLh2m4h78iWB+di9bQreKBGn3
         iMMTTaiJPf+hT9OVPT0SLxmKO6+o6mPI4zv4JtMEr6+BDoEzWA7VokTDSzoorfjKOmbF
         qLe/TsqJI7hsbfC7AzgWmLVaIH+zQ/wwuJI0IcqmcngI3MmUGeqEWdcn53jsoSD4RlNJ
         HM0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780933511; x=1781538311; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+aIFgkJHczJNgL4kcgnE8wdjpuzfAatRFTenorL55A=;
        b=f1x9fjqaU0JuajomKn+LGr1S6EuIoHPlppYBQHnGTe1nxdNjVhsIOzN5cgKWepjRke
         tPrQujr7p76e1TIzcjPL5jOioag/5qdyCGELgLrIUs4rw/GBVQBOla6FY0SPnxbj/Fps
         4KMcmsxzQd9m79TdgRBwBe4NKj2omp5WOF62Pxg4Yu5YeHMqM5WnoBs0o2hmmApdYGAu
         D3Nzgpv1r9WkAFnMbtuVfAafsToN6+69tiiVDmAAR8fMn023fZ43/HDbIr6bBIP2AL9/
         juAolxzGCycYXm/bop0CgAJWR4NjEeRiOh2kTyIYP5btvIzOaW4x/WHDBPZ+5eXnQu0F
         WPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780933511; x=1781538311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J+aIFgkJHczJNgL4kcgnE8wdjpuzfAatRFTenorL55A=;
        b=n3BWyyXTWhqXPovLsdSUPryxZo3ATdgDLJYQhjNN8IUVIeH6IWhDsBK/GbMtHsR1OI
         3IIFa06rI6Mp1Y1h6x+PDqM5eW5qGoN4PgtXtU1lKnBabKCMPO0LATfeLKW3TSBIuW9q
         UTYru0wtmdzlFVCyj5+LwP4EectdKew3vdYLVTvEfi/t+GDAjudZYYFk5HI9u5hrNOy9
         lj8dvt696qb7Xtm/lDdBp57yxA/aE/muLScz92L3U5FAf0w+r9lsgdVSOyQcEjzdKyq3
         tw1tSSaG5NPAVwQ5zBaREjS9tUPsgb+qUYKL+hyJdAUaZOSZt/s76HRHVmuU7FAHWQKd
         E/7g==
X-Forwarded-Encrypted: i=1; AFNElJ8S2BDXX6MHAXbSL9APWd3ZrHXugMWoDjcN0YJkLNgfpmddQAU6X9S1YZ20SeyGsSCPqpxXVCCsLA==@kvack.org
X-Gm-Message-State: AOJu0YwjHy7SCBEDTxg8qc5eN4mDWGVFnhiblZYLjSithU7kvjhbXwjS
	OEmna8qzLyoW/mF2KjVak1ZURkjAGyEXeeQsXqI0UQ1+xKduzi9tHJ34Cja2NujQ9WUPzLbBPfl
	+Ci94WwaHebp65ZYOvs8LrMHp1a8FrZSVjVjVKmun
X-Gm-Gg: Acq92OHss/cJWSs5uIanVSMijrUyUMe3ja7YAlKLIhDIwJEy8txJV4iK51PbC9lzZIS
	k2qGYEuBGA8yGqvvd6RGTh1Ca6ti+TLyIipJDtgKX6sh1LExbtd13c1pYRsoHq8WNMRCfn2DGZZ
	WXkzN97zAabDOKOt+09+II9oGuvqZ6F2JMG/Kp5oBERM14v140h6EKJ6RU6aRu/b6TZwZTwQTW2
	G8Iah55UP1lGuyCBc7iJskKECHzgObfn3eDynKUplml8CbcvOdPbM53OoGjj9nwLWh4BO0d21Dw
	i1QzCBsx3gVvksp/
X-Received: by 2002:a05:6402:33d4:b0:68f:d45f:e496 with SMTP id
 4fb4d7f45d1cf-68ff191c24bmr172212a12.13.1780933510801; Mon, 08 Jun 2026
 08:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <aiPWD6xZLg6g4DTO@lucifer> <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
 <aiZ5qFTc6XDMsqB9@lucifer> <13f428df-7922-4870-85bc-90039453f247@kernel.org>
In-Reply-To: <13f428df-7922-4870-85bc-90039453f247@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 08:44:57 -0700
X-Gm-Features: AVVi8Cfxi7NgQqGh1zDMQIjBR9NRT8lg0XNTPpig62vSCMjknBDjB80v_CdcxnE
Message-ID: <CAJuCfpEGncKHsp5K8fzxWfCZC=bH+UG7n4CNzzXhwYcvT7rfHA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1A1DA000B
X-Stat-Signature: t31kwwtp8dea1m69kh8nppr44szueefm
X-Rspam-User: 
X-HE-Tag: 1780933512-597844
X-HE-Meta: U2FsdGVkX19VOZYI9AOc8BGYdlwQJjBMuDgVHxRJVc8WackCBDPa6lm8J6Nurae0fyhN2ihtzUlWybqae+dhCT9c9am/jxO+hK9Z4jGGR919ZE07D/3RvWaEBlI88+qfZfiXC+mP5dikf97IxqIsbsbrs75njBspcZ8p15agSuMB51Gg2eJg1P9JXxp1nKCvdtBpJIGOWlYpjwBLSnSuVny/VUo2E+JQGS9L0gX/o3UmJRwReaWRLlLRYJgr2X2/HBDH92BmNEERpGZ/CdLE2GJ+698F/jFa7UG5j0mHfWVMIZgCzTTKe6yB42udhhkY54Z+K24HaXFQr7DosNUPQui+G49CO4zVCZpC4RKPFKRP4rCkQkoSWY/UFsBLLmhWC4Uxa8bOrQpBuHyEMabAIJa2Wy6J1eeZKe2eT0q0Fu9FDxvPS8fvAs/jdCig8/2KYFiixxSH5I2FdyX202FQQhHxBk9EsG4c/Z2pQ6fJZqwBQ9aplJbHrTSzh0GygEa/Rf23b07L1uXREGoKPAv6u6GwAcFdtFvo6YEx3n1lxsYjHq0kKc1ovDHutES5jjHxSvAGccnog/bCB6daEMKLBBmg9Vud8UCX5o64uYj26p0+uKvRdjrh6plInfxF5N3tN+p1+GLRAr1zx6iZ812EtmWqGYakRfcqT8hWw0sDYymqE1CpKoTtg6Xeh9WYm4BEzOspKrO4KjNi+8zMLvSfZhWMESJU3USHjKDHwfWIw9hs80rocsFKaewo+K2FtTzvIfK8PXGfxt+IWqMBvyidfQ7anT+U3PzXcxrvMrF9OerNDR11xVW0Milsia60fZ49C9lDOw2gKYIVmOwW0kdVEO05fJbuBnFbLX0PEu+pmeqNQXzv8/Ah3JT1HntjUK4iMN93AkqwL3y6knWiRDQD+9Du+XiqfYnD2y1EIABcLi3YuCVATaapqdJWFL3ik0HUUzrLaMtdDU0jXidC7hY
 qkzq7C3N
 Yheh2po+FW85H6Hw8xvHtOEjEncNA3opZr4M8grNa8QAIrUwlucCrJLAiTzzl9XbIeNmsId2C5kg7Oz/RHf6hpB+Fdoj9zp79Gsgrw6FsAbUt9UQOmzpBVCv+XdMeKF06yhM8r0DOqS44kANi1SjE7x8xdd0ibe57HT9fA+NDxG7wMXIr+srEIbb/4bDFHSQHXHx5e9RmUQJdakyqLGMndjpdrecFHkoDad+WVHgwJ+xahKSVeq4oih1XxlWXi5rzsDKD5LIzN90NhOc2VCOE8thVdaP1IpvebpcIigmH6R/8rj+eLG55LxWB2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 8:32=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/8/26 10:14, Lorenzo Stoakes wrote:
> > On Sun, Jun 07, 2026 at 12:45:23PM -0700, Suren Baghdasaryan wrote:
> >> On Sat, Jun 6, 2026 at 1:12=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> >>>
> >>> (Will review separately)
> >>>
> >>> Sorry to be a pain :) and I know it's a petty thing, but even for a 2=
 patch
> >>> series it's easier to handle if sent with patches in-reply-to a cover
> >>> letter :>) also makes it easier to track overall updates in cover let=
ter
> >>> changelog.
> >>
> >> Yeah but the first patch is a simple cleanup of about 10 lines, and
> >> writing a cover-letter for a single patch seemed excessive. Andrew
> >> would have folded it in with this patch anyway, I think.
> >
> > Makes sense, sorry to nag but I want to be consistent in nagging everyb=
ody
> > the same :P no matter how well I know them or otherwise ;)
>
> I mean, it always looks like there is something missing in my inbox (e.g.=
,
> people CCing on patches but not on the cover letter). So then I dig for a
> missing cover letter and find ... nothing.

Ok, I'm convinced. I will add a cover letter if I get to respin this
patchset. Thanks!

>
> --
> Cheers,
>
> David

