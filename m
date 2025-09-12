Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37BACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233238E0008; Fri, 12 Sep 2025 13:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3A58E0007; Fri, 12 Sep 2025 13:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2E58E0008; Fri, 12 Sep 2025 13:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBECE8E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:34:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72CAA1A092A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:34:30 +0000 (UTC)
X-FDA: 83881297500.16.1243253
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B64840009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:34:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T12eNLDY;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757698468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5LHAOD3RsM7IX6ZQaWQlGO8B8wFFk4TliEC/qZmawU=;
	b=KfHJF4hv2INqfB900iFSbdeRWJg7tidhWTEA1vbFHseUZ28AdKyH8TnaDullR5Dr7QMAgJ
	eTSSVIzrw6IZ2IJnN4btrIhbe+ltHHblDuCHcyuxgfYww1Jo+ve+Fg93qTMYw6gt1bB+8h
	ScNTKePNIaBIDtJpil9J3dMrJMJlVc8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T12eNLDY;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757698468; a=rsa-sha256;
	cv=none;
	b=b0humKLjMcGAFD4+/snhoUcc1lPWUlGeexpYCioIgU6EIIBSaTVXrVmZHv4DCuHrjE6bbf
	pIBrwiWsFwGDc572QZN/k2IxgFD07zoOGWzRC/vk2+A+CoVFe7nkSuRyM92gHvUEkgxJSx
	3H3NecU/b+ZhmnN++2oHtUz4qPZSknM=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3e7622483beso1204003f8f.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757698467; x=1758303267; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c5LHAOD3RsM7IX6ZQaWQlGO8B8wFFk4TliEC/qZmawU=;
        b=T12eNLDYrBV/+0SvV10KssKYYp0V0v9Xg4krGrMk0y+Le5GP62EI7R324RN/FIkXVa
         3XceKzd1Rmt3lX0YnUFhi8TnYgXjiwaRqRJ7eHV+/a+eU/3As/6xqd9SmU4N5nZWM+1m
         W6DYZArObdlxzMco4OaOGNJNmbzi7DZURjB16BgYMXD+Imf1q+45WL1GWSl4OB1MVpLM
         RI+ftejy1Q3Y7jzH+JXjaLv8OSvxY3l0CvqF8Zr2H+Jawkr/M1PQAMFJSnnajMAiDe+N
         9mk6dTa4J7FFclpY8+nxM+fZSnmOAfHuatI9fWKd3NSZTQuMKqDN+o1uf7tQ9vdduxob
         Jifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757698467; x=1758303267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c5LHAOD3RsM7IX6ZQaWQlGO8B8wFFk4TliEC/qZmawU=;
        b=YU0iAJIlnQ2sBVwvnu3A8QgVmejDXr/AxuiZR4hPnHiq3eAo7jpTgfiXS438YWVRGQ
         2WWzmJjYZaZb/Jka6Ro5xnIQV6StaDhh5XtaRKmMK5s2+FkkObGq91N7zs5kObKVOxCw
         z+pJyyDheifnUC4byTMPz4sGs9KBuBC4T0asExYPfMjn6L7Et6C9hr1Bx1HXfzjeoIOZ
         yMWa3pAwmQBkvz42jyB6BucCaA6is4MMpiQ7pkJtxFr/t47jLFdHbJERIgwF0g8upLlt
         K8YSUExt65OXWZAZVnfmsB5jDUwPcQe2HVTwzBQXy+5+iDGYmiep9Ll3a1GT+czOeX3E
         nXFA==
X-Forwarded-Encrypted: i=1; AJvYcCV7VIff4Y6C0GNHpbefaXfOIYXDFZaLZirvD+dDjIIMWNu9KKk0uBYKkZmk+PcrjMX6PLbY6ac2NA==@kvack.org
X-Gm-Message-State: AOJu0YxRgA7PghYQ0ENpkoPnMfgdTPmMVwVnVqU5BJw/8oOsZq2WQjLg
	y4KIGJkuCmAQt4Mia5aOhw1t0WWUvwm9SVk7trulgwfDZQCaTU8xkC4a8cq+DNOhKbBoQyHVWUm
	K9BoaAMH82T7PvcqkEAnfGzWNmBtMGK8=
X-Gm-Gg: ASbGncv6ISr8hhc/MXdqV6+Sy1fVcnCk9PG00LWRSTl8RKalNFNuF0qSSQ4diU/ZZ/u
	Edxttzl5TElDXgJzqFgVFAh3pAN0QLHSAtfpXjgMCKBJ/GvoEFA1eDWKSZhwiMTzH9qq3gQFZue
	Fj9wgxFOd4HwY9Gxi2e+XQt3vTEmgOtlRN5JsQ/joRJ5UxIOzb+5PM10IN1axrAOhsrRFZ3ITKw
	IyCbYPPbNBQ45KbMIwIFXM9tqaywp+T7QhATrHEJd9mL1U=
X-Google-Smtp-Source: AGHT+IF84u9tsLSiw4lDvT5XmwWtoH0L/3zRkVWz/Q7BbdJ5SQIMqXyHfKSwJKnSQJcmnQtbE+lOWa60Ml7eykZbfmc=
X-Received: by 2002:a05:6000:2510:b0:3e7:4277:ddc2 with SMTP id
 ffacd0b85a97d-3e76579abb9mr3853126f8f.10.1757698466762; Fri, 12 Sep 2025
 10:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com> <2kaahuvnmke2bj27cu4tu3sr5ezeohra56btxj2iu4ijof5dim@thdwhzjjqzgd>
 <aMRVNqH47mdkl5Ke@casper.infradead.org>
In-Reply-To: <aMRVNqH47mdkl5Ke@casper.infradead.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 12 Sep 2025 10:34:15 -0700
X-Gm-Features: AS18NWDOSsJ18D-9VlumoGDeKjZauJ0F3-n9lYvWRCc26bWu4h9-Bjo2I0KS2Vg
Message-ID: <CAADnVQJbx0Wf4xrAEfQyZhhpC13zJH6NqdFjYQ+StQzzi+Y=Nw@mail.gmail.com>
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in alloc_pages_nolock().
To: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B64840009
X-Stat-Signature: yuoi5zrzp3qje6m7sp95dzu7kpths68s
X-HE-Tag: 1757698468-302786
X-HE-Meta: U2FsdGVkX1/xr4dZq1Su1gNn9Am1DggMBGiRGfPZzTZMHGtfi0P9jJ5GCqi0erNtWGE4ZL9AsOycDVnqSzxht13v81TGCF+1ngizFB1GdQV6omcVh2r0KZ9959lYbILD4ITkAP/KjllQqD641mgXM96nZ12QIw+Kz83xK1bxZ8vDoS46ZcuuKY0qjYv0s9kxXSh3cwNvnldjUuA2eStJ0JCbcAkyr1wm0NlCFOSbO+3s6qc6jAo9rABkNPDJMdT5J+Lz350Edwlo6E1B5++RUjMsHeIjZV2lIoAYKYleahN/gdSw+LDNhN1ubEI6H3zrboQPnbnLctENQVLOKoryPG2VnTR69uZD50EeoGS1l2JHTnXjhRrS7tx3IpN/Vt4Djeml4qqjsBXixKho27oGIRTfAoZCJtZZam16g6ZOvXXeWchw4pY9UDN1tl9QYKXozN3X9Tqjcx15g58zcyBd68ImH1JxmXSI0/qLvyj9gRPRL/AmYWp7xf5htMd8gNPxQ1ATmKCdB5R9j4IBTSMIXNh+spG6JPBrXHK6mgx/V3v2jZHrqSw66nnyqC2uthULZZ6/Xd+coL2rnVwczuV160uNjnfn5BSq+ZkeSPoNMuAr71FroUJhB/mr6rqqQZr+17OuysGSc+4HGYbGHsP9to1ijpkbRNqHiTwQLVOh1812j3IQFFktxPciA+mfHtUsFznYYz3SDtY5CRgeCA/rPLPx0h9IBlLxDlF1NSbjJ2cbeyPPJprqBGb3XEYr7MqzRv/YIfQQzXXmCxWPhhNK/03Ewb80WCAWT2dXdFOQ87jcfExPzdasOV/HDCmvo0bWxFfck7lJMIRN/PluNtalbI73TgcJEkYyefpDlPKNqLHk5A0aOgn7IeXvioc0HEsN9407FLgwXZZ4pSaMKRxaVT76kMnpGoP/a21xw567h8p8mQ1FtMLaYr19Ul4n+2giJk03HfTEzGTyAWe9khQ
 sE1jR43W
 CwGoZNvSv0lKyRDJyF+Az2MWwA7rzhuNTl/rWe8EZAiLgh0P5T4+alYs/v55oIZ2CVbr6Ko66lSE65Y0TWHfWZkIBoirI4N71QZ9m0l9JV7u7DKcHL1FczdxKV5rh7fvE15Es9M9OfZbZFrxv/iMW41V8+My2wQxxAO4CPIYnLSX+yD70jrpRiPFb7tSWzZBNfac9kuU+ZQaJRf43ievkft8OTcDZSj7Xw/fPSI9KK27RGVkcF8qxZqALYIHdz03pKf/3WNA8/VLuIn93b9CNVTc4G9cW4zlRjehmzm99x08ti/CN1VvLC+qGkOEkwXCtQCxbsS0lTO8kaBdVFAfdH/4EZ7vORq+GgprOyFLnT4StP9YBJx5TrYeLAXQjQ48JWHc/6ct+zSUZ0eQsonfsMBd0iylSjB7vA5kB+qQ3cuXRQPG+A2oQg9vydhv8w+FxDUM9Mbkp8a52ATcQHjB+IjfV89MUc3IVYijzdntO+FRZY9qKhZwOt7ul+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 10:15=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Sep 12, 2025 at 10:11:26AM -0700, Shakeel Butt wrote:
> > On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
> > [...]
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index d1d037f97c5f..30ccff0283fd 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -7480,6 +7480,7 @@ static bool __free_unaccepted(struct page *page=
)
> > >
> > >  /**
> > >   * alloc_pages_nolock - opportunistic reentrant allocation from any =
context
> > > + * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
> >
> > If only __GFP_ACCOUNT is allowed then why not use a 'bool account' in t=
he
> > parameter and add __GFP_ACCOUNT if account is true?
>
> It's clearer in the callers to call alloc_pages_nolock(__GFP_ACCOUNT)
> than it is to call alloc_pages_nolock(true).
>
> I can immediately tell what the first one does.  I have no idea what
> the polarity of 'true' might be (does it mean accounted or unaccounted?)
> Is it rlated to accounting, GFP_COMP, highmem, whether it's OK to access
> atomic reserves ... or literally anything else that you might want to
> select when allocating memory.
>
> This use of unadorned booleans is an antipattern.  Nobody should be
> advocating for such things.

+1.
We strongly discourage bool in arguments in any function.
It makes callsites unreadable.

We learned it the hard way though :(
Some of the verifier code became a mess like:
        err =3D check_load_mem(env, insn, true, false, false, "atomic_load"=
);

it's on our todo to clean this up.

