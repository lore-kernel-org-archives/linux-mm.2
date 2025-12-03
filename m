Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDB3D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1EAD6B0029; Wed,  3 Dec 2025 04:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5D26B002E; Wed,  3 Dec 2025 04:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C3C6B002F; Wed,  3 Dec 2025 04:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81DCA6B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:18:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 339DE8A423
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:18:56 +0000 (UTC)
X-FDA: 84177610272.27.9C59A8D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3F3C24000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:18:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPkPmRea;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ql++8oIfq0N8Sw3ugzWzChOj33oCiyU6Iohx69rIu2c=;
	b=6HZGvJZbvVMRixGO9uSnzlAgSY1APSNrpI9e4m2I2PfGmA6YKeVO6yxl4d/Anan1ElWlzA
	YXdB76QFBbGiYA5ICaPajLtssX9Iu3Tpbi5KYFRil7Eq4OYpqCNX384g/budmTQYv0eGd2
	I1MYYkzjpt9TkrR2GUdOBZnIAdBf5qk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cPkPmRea;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753534; a=rsa-sha256;
	cv=none;
	b=Kc1E3Y+sqHPsH+448tmJ/9AJi+smh77FWcpIWDLDHPJBW8I+uBFDGkEnANtpodjJ7EHCit
	f3PKIBAnRoQvHpbn/PTWg1pm7gLKS9OD229lCmJzRvPUGf57oEvUPq8nsIMHyZxdxtrxg4
	S+9VDZtJueokODVhBsqaQn8//sMAhLA=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so8254524a12.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764753532; x=1765358332; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ql++8oIfq0N8Sw3ugzWzChOj33oCiyU6Iohx69rIu2c=;
        b=cPkPmRea/kINLfflVVYE6yJBl+laBGHT0S+Zz9OLxelNr423UPXfKzwW1gq5eLHijD
         RCCqqmPC5sbnSU8oLjdAJRd4PhINWHKlZSIzUCozAejHsPvR80vK7XtUrQkdlMY/oZ+0
         a4AOytrPeTq479GLA+y7NetBvUz/Rv+/cBeQSXzDSva1qEFyuXOBuiSnTOsngsNlBeDN
         rD09D/o8BzQadpnqgpx2o3FHtBTZV5MSs/2wa3T5loKgO7keCTzrMfy2qJft/CjVRBZ9
         JJb1oGgYa6T8b8F6DvEYZrlS9Ja9sD9M+caD0G2fmoCgO6Mm+wtVhY4PSQ/ayysedaXK
         dirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764753532; x=1765358332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ql++8oIfq0N8Sw3ugzWzChOj33oCiyU6Iohx69rIu2c=;
        b=EH7hHWnaTuBskEe6uzt8DbUIeEP2I6aDBRAhmdDlt+ZS5wKvZ40B7rW1/ePR5WjdBj
         3kJUFfuNnA54TYEqodk7AmeSuuklkEcbyyg1P9xLkiLqTF0fpXvFamXtvg3vMRFPFYWh
         StMIME8ZKMJ86u1PXK+NPp3eb/On895ChOFFQuVNrchPQUnGQTADApoK9VfKt/QRKbmb
         Et1H0gs49afOYiP8sy1AsaoD/CZkAAsX0Jcwi6/VoDl6oxvMJS8rVTVJ4/NiG02eA6uO
         aKu+sUZQ/zK0qLnw0IjEsJ53gf1dwURPLdwui1vnbF9Fr/nEBWd2ZW6/UhzzSNk/+MrN
         u1TQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhvYEAALYXaCoe9gc+rN7573PvXY6HdkclEYpPKnLQvxSwWXd49zAPgQW3ccbOkR4xZBmdrPNDZg==@kvack.org
X-Gm-Message-State: AOJu0YzK34voSn1Z0N/rzqHgQEJNX09Jyb82FpejCjF1cdQkdACHL1l7
	pLRCJ4w8R1v90x9ckVnQiygR+/sqQjwvjmRz80fQCd7DtrpGE90DRdjSL6YZ6w+nnQiupHF60Vp
	3m3zr2Td2YdeEmipo2EJO5QAHf/e1vsA=
X-Gm-Gg: ASbGncu5w2zxJDOhZoQP9QKGt7fxQwtDZ0SaGjoAwvVvKW967yjglvxs2M5G8Zg0XEL
	iQPyLMDyvlAkVAFlzaxWFHtE6+mQUB7vBQOkUZnhO96Lx7uSF3k5F+kw241O8J3+WYCBAgKTyVD
	T6oY+4xYsMmO0nVtqF/DXQVaoUcPtj+lIH8GIBk0wUGFuY+smGbLksZlji0LzkEvSiw6AcZtzB3
	Fiq1iiiovdXYKrkYi76hPBJhdZ+iYS/OYARwY3VmFhsYlNaLzcIdBV+EPG1zaDUuvnmbFYdde3a
	wzAUPPEBQ8EFf6MliN9DX4X4/w==
X-Google-Smtp-Source: AGHT+IHR5GdKaIRSJgBH/EStrCwXPMNUDTdsyK0kTD2yFj6ZgO/y3zCx9KM6IDz4H2sMXGknxSVuoIoicQ4ymAdTGJ4=
X-Received: by 2002:a17:907:d03:b0:b76:8164:88b5 with SMTP id
 a640c23a62f3a-b79dc76d5eemr163828066b.46.1764753532117; Wed, 03 Dec 2025
 01:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <aSMhj2Q6BTMNSsA4@casper.infradead.org>
 <CAGudoHF1wjY5tF-aKVrjOHoSunSGTrGSrmm3nnmPArVzajTNYA@mail.gmail.com>
In-Reply-To: <CAGudoHF1wjY5tF-aKVrjOHoSunSGTrGSrmm3nnmPArVzajTNYA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 3 Dec 2025 10:18:40 +0100
X-Gm-Features: AWmQ_bmmwG3HJxBumPF9yPwpr6N5IAwXXwVhPXvzZrIQxJaFQEzyiv09DmZXvX4
Message-ID: <CAGudoHH=imWVHKyQ_GrvQUEQawBfmkqdLkjSwdecmTyxiRv8rQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3F3C24000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: x5qfaiwwg3bjfmtw39u87zhhjnbqzd3z
X-HE-Tag: 1764753534-905707
X-HE-Meta: U2FsdGVkX1/WzscPo0Z+5D5LgFY8RaLBmQTQdZTQgtKXU2ee0srPXfCT+t6XF8tU4JVHeiVCrx/jFc81e0XhNnQ02ITJlng5iKQPYBit4sHaeVQJjUqZ85lIU1DrM6N3VtSaGKxn26h41X4cVbOqyYAH5Vxb2bBH7voGHiZ1ah/6RCdlV0fiQh4VKkbXX9bZuuSIFiHd4ft1tKTPKypvFnCq47iQt1bPfvpSHZ26OjMo5uz4m8rZ19EhGG0iNJmfswi6bBEzYIkiYMHH4FNVOKXFQ7aLkJ2YvZAhnPdRnGL9PZkDtb0lzpucOk/fHJGmGSOJp/SYdpmwj99H71dTe/nLLLiyo0ZxVllG014mwqi+5AoVEY0R1kknDWbNhLA13gYJgIuZl5BBGtigTZDO6Qdx6TN5KIZxCj4ZHGkpGtyk5ALsYML/fxQxqUXbwI/74rSRNqshJRgg2tcOkQ6Q2f/bUgmk+amD902azhspzTHcGYe5GhNljnvgrAwic3HB7IrhGrWXCVANpQ6UOlLSjNfqvQT17twCozJoaAkeaPoPMOytLp5kEz7/L1jW75iI2exgnr5fqhrYmSHOHV8GY0fkfx4VHq74rTpZBBiZ9Uy3hK4C3qdWLGGkHz0ektYx7s1NQ8GlIKUj10aIdh1bmHoiaR1zwoXpfSH+CaBMpIJkHYAQNMy3L6eADjmud8VTjpwJhBWnkIeKd8pWEV0NOy/A2xq/syDFaNZcuUtWn3zBSRQYTZwjJcnD7Iw1MFlS92y0JPCdJ4vYUumoj4KeEq+Xj+9J+TlxyZSUlvTMj7a9+wDaJBo5kBVfruJcTvp97h7WBO6p51TQzUi3ixALtLPYV6Li2qH6w/2sLgv8OotIzlIXVekIIl2jsNA61bO/nqQPXqn0yJd2/QqTXveKJATdzGo+/Fh//y4E3lBWUn1Gg5YrHTjZ3drvyF/Yzy/FvIjrvI5YcvSC6rqTPHY
 1VsiFpoq
 M7lAquMsuTZStgkZwSw02G3KDO11SccPKKD39I/t2XHYpEJLa5BgEgQX0sn04mr+kbXvU58/sSPVO2Cq0F+xL5sPVJyd1nqHDT1Cy4qF1PsyvgdIM10POVm5ae7cBBx0o+cI1IYlLLDNLSTRLcL9pDhHS3iNJyDkNwIHHqoVtaQ3URKmFq3AZxuIOhx605l2KPXQGjvVetSifJVGyG7FuPrnAZEuaByhwC0+Pi/O8ResmQDmZnIOCLC7BbvtBeacFO0ZLvsQK/x7HHJjnu3cNJ63EQh1dLKpWMUJdWp0kKOZCmce+YMqH1hZxWrUfis7D93kVWKGJB9xE5R/8X4syq2z+H0d2eI6LpYl7rxoywq+5nBF+31AY1GpvtJi2dgNWb839PWnXSlVqEQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 9:37=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> On Sun, Nov 23, 2025 at 4:00=E2=80=AFPM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Sun, Nov 23, 2025 at 07:30:51AM +0100, Mateusz Guzik wrote:
> > > When spawning and killing threads in separate processes in parallel t=
he
> > > primary bottleneck on the stock kernel is pidmap_lock, largely becaus=
e
> > > of a back-to-back acquire in the common case.
> > >
> > > Benchmark code at the end.
> > >
> > > With this patchset alloc_pid() only takes the lock once and consequen=
tly
> > > alleviates the problem. While scalability improves, the lock remains =
the
> > > primary bottleneck by a large margin.
> > >
> > > I believe idr is a poor choice for the task at hand to begin with, bu=
t
> > > sorting out that out beyond the scope of this patchset. At the same t=
ime
> > > any replacement would be best evaluated against a state where the
> > > above relock problem is fixed.
> >
> > Good news!  The IDR is deprecated.  Bad news!  I'm not 100% sure that
> > the XArray is quite appropriate for this usecase.  I am opposed to
> > introducing more IDR APIs.  Have you looked at converting to the XArray=
?
> > Or do you have a better data structure in mind than the XArray?
> >
>
> Hi Willy,
>
> in other responses I outlined what I suspect would be a viable long
> term solution, very much not idr-based.
>
> However, that's not something I'm likely to implement anytime soon and
> I doubt there is someone willing to pick up the matter.
>
> Whatever the long term solution and who/when implements it, the
> current code avoidably loses out on some performance because of at
> least two lock acquires on each fork instead of one.
>
> At the moment it is structured in a way which makes it possible to
> take the lock once with minor effort.
>
> Leaving this in the current state results in a minor risk that someone
> will make changes which turn fixing the scalability issue into a
> massive problem.
>
> With my patch as-is I can suffer some pain and avoid modifying
> idr_prealloc, but at the same time I don't think the modification at
> hand is particularly problematic. Notably it does not change any of
> the internals.
>
> So the question is if by "opposed to introducing more IDR APIs" you
> mean you are just not fond of it, or is it a straight up NAK. Per the
> explanation above, I think the change is tolerable in its own right
> and I provided reasoning why I'm adding it in the first place.
>
> If the latter, I'll see about massaging this to drop locks and retry
> memory alloc.

Welp, retrying preload turned out to be significantly less painful
than I thought, so you can consider the above question moot. I'll be
posting v2 without idr changes.

