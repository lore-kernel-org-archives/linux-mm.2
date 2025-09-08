Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B21E6CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D8E8E000B; Mon,  8 Sep 2025 00:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15638E0001; Mon,  8 Sep 2025 00:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E527C8E000B; Mon,  8 Sep 2025 00:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D393C8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:56:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72751BC297
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:56:42 +0000 (UTC)
X-FDA: 83864872644.27.885F322
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8361680002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:56:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=reHZuh27;
	spf=pass (imf30.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757307400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G790SWKrMS2Spa5lQ//0xp8+Nr4ojk2QTeGItf6Z/ZI=;
	b=3pU5QzTZFFL33qNRwaWbpZ9XQbkLPGGEC9KdirE9UZ3bHuGBMwJBxF5jwI2ddTP0KSfAYv
	1JH3hV/9clXUS1lkLVD0lKd1g0RjlurEKw+eMu5qUWTCPJa9JQhhfXVA7i16P8fLTOH0+l
	UcTDEhzUXhbwxzTA3iN7GT3vuGmg5x4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=reHZuh27;
	spf=pass (imf30.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757307400; a=rsa-sha256;
	cv=none;
	b=wbxSPznce3L1U2JkbTROVxwgBc65LBKExfQq2X648tKenwANuFpPZzwJ+I92S9m5NVq9HZ
	f9ePXO08M8NzvGaG1EelVFowXi5FXS/WxiNtSwM5+ng9XtdhuCENpY49T5dvHyVvJMdAxg
	gXaKqrYBM2OcswzyOaeEsTuqnpwLEIE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so10903a12.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757307399; x=1757912199; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G790SWKrMS2Spa5lQ//0xp8+Nr4ojk2QTeGItf6Z/ZI=;
        b=reHZuh27U5Qi0/ApWCFLZ+5t5BAsvuwHRPrEPr+E0/ekBq+pINZlEZqPy1TBMtBdS+
         Amdsvxd/sZS8KahnDh1+HB2cGg/xSD0th5ZMOCbGx+2MiA/1EBViQLsdTohyKkR3xYkV
         f/Z93S6TWrO6JFyBSkef2Pah57cXHdl7DjFclomwrwtUdqVFHzQTCnmOVY5ROe0vwho3
         unLAwH6n+1uMDJ48bOH6+Sp4L6Vyn+d48sX1X0WPXqmzvDyPnm2CLOHTQqFpmTFmpnY6
         ebyHZg/cHSZW6ytScAHlQqJvYyYjVRzip4zZXLIwNsYSQ94zsdtHcLx7K2QmPgCk/qXH
         Ag6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757307399; x=1757912199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G790SWKrMS2Spa5lQ//0xp8+Nr4ojk2QTeGItf6Z/ZI=;
        b=OvOL7ZK1aN/7/vYUUK+rNekGI6CK4ioSzjkmREragHBF5ly7Gzks+twtVZ0TWzZvzc
         mdOLou5EH4mNkvURvC3WpdRGPVV45DzDVqXEfzV4VbQI89PHjngzHa/ZyqJeZjFEA4Ap
         fYd2JEWAhoK35minQ6m0x4BQftAVSazgoCsvQZB9aLjwJc0YlmgAw1gaAZDC9Zsjy5DM
         LxCmk/LbHFQPg9G7Z+vZlopMPdtFQlS7Hqax3qNVGtZbDwlg8X4RKeRZLT2Xg++ksS5u
         WwDBb2pjvSHNt88m5J5U+lMMveAdDOedhiHkbqpP11D1y2Snz3WpGzt95cyiV0+3VzwP
         PyKg==
X-Forwarded-Encrypted: i=1; AJvYcCVwc1fjwPIMgaq8YrHWJg8FjAaLI62T/326HX06fql46pEQgiKWerM3R+1wz2GFMg88PiYyyVl2ZA==@kvack.org
X-Gm-Message-State: AOJu0YxdS57f1FUuxl3dF800CQWDByrymTrmDt0NfP/t8sfU+LmVADyQ
	1bBYOWr2RXMD+nPqNrfSC+BtJUWHBrbA+/lGRU7Do6zCxbJEHlhFAkCjo55jI8AxRkJjpHunYd3
	qnJyoitOSDD9BdswunSqXijWq0fDncaobeX2BI6Rt
X-Gm-Gg: ASbGncsF8mpTPAj1Y7Rs/RafQcIOa583bcCLTcjaGh1IU96EeHUKKJvNTLa8mMZrZUu
	wbm/vtxCRzt4WtRH54m3YYtzQJRxKqLa5jGCXY2GN1tNGADWwOMxgOIlXljeOz3YjYtS0G4BqLZ
	h3ibzlm003AiLjFPFL/sdX5VWYJU6h48HRgGq1nv9uVctEk/J3kP8wgM3B7GBtTDb0HAF6WDPaj
	ufdzAC/743W/7FhmkAlGXlZtjsU8VUr0WPMg1YF0Wo3CLn1otOm4PBp6g==
X-Google-Smtp-Source: AGHT+IEfZcQKWymUsTqqOHgiy81N82VSvnJqKcYZvNDzmsCtUqE3l9TNTQbgDZ9aaqLldDgztdzRQMKqVYJRylhPQfU=
X-Received: by 2002:a05:6402:2346:b0:61c:b5f0:7ddb with SMTP id
 4fb4d7f45d1cf-6235d1a4bb2mr2464a12.6.1757307398564; Sun, 07 Sep 2025 21:56:38
 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com> <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
 <f5cb68a7-19eb-40aa-95f7-51fd004a3f8e@redhat.com> <e6b12ef9-1808-45a3-9d64-5c7fd1904b5b@lucifer.local>
 <CA+EESO5FnraOUV=CzcD6t_e086pC7rDZuVv4w2ng==7KacA=Pg@mail.gmail.com>
 <d61b173f-ed58-4d60-b1a1-b93678371576@redhat.com> <CA+EESO42EqQps7C7P1HfMJ07ioRnkktKGXO42VU0fHT_1xvC8A@mail.gmail.com>
In-Reply-To: <CA+EESO42EqQps7C7P1HfMJ07ioRnkktKGXO42VU0fHT_1xvC8A@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Sun, 7 Sep 2025 21:56:26 -0700
X-Gm-Features: Ac12FXz21g3aZY8pBxInKDKKJwg-ZQSv234aSGthQCUMDFh06_0DIrztZfN_DM8
Message-ID: <CA+EESO4iBZu0qcqWrSP166OYRp1Mqr2i0Z5ei1sjd1g6+bT6Ow@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8361680002
X-Stat-Signature: k6begk7s5ekpcm6w8e3yxxxzb68oa75p
X-Rspam-User: 
X-HE-Tag: 1757307400-651172
X-HE-Meta: U2FsdGVkX1/DnlsgZ5rDP5I08obfXl67h8CsSlB1MWkJqvjEkxKC8uFZ6yc2ULJjPZ1HS0JQNnAXVjEMBED329MPBrK9XFajAycieWcCy8A7avpsPpvWLDCgqk9rHrmElyDoSCdCmf7RUVoFI6u+jwpiVCgYrWD86AajGTlBXawONM3+GAs0X0x0S6XKQ71siUmctX55NQGx8VGqBGJmsCPkm5pG9fBxNHmojsdbROeH13oE3ZSpEIs3wMkjtoGAF6GFnKDIBRJrQLdp7pLYRWaJXOZyTuOXzZKsjLQRSwyE1NhYWHgGdbpXbf+iR12JqhcXiNYhXcW1HF3rn9LcetnjVwXaaNgUTGqVabrmFxyCPS4SXxT31Ac5hLcUzVj73r58zmLjbQ+xtAXp1HOGBYJWulznXtRQtPcKuXKX9a7YXUxrNo7pfS45k8dSjelqswT4s3hmwZeuOBA/1faXKJ4BzvwJlpx3nrkSTgATTigyleQXxYLtcpLkPvqUdSO4c5mJ2ukWTmlFRLxEBlQq+ge4lh2Iqzwmr2jrYW71dTAvdPBMiT38aWUVwj/2P08zISUad5UKG+OtVnIzXxX3WeZS/W15ZLxP/dL53fKf72B0GrGXQMC/+DIxuPX1inewP6kmgCI3Od4rMgENZmAs8z7xpnGEhy2A7EWppCTCFoLt17xKqcLfDb4+1hznI4X1sIND6/ea+8fW4b+PCASdeUEL5z3UVbpo4khtwIK03s8raQ2yED3oAMId9OfutTC4BVfkeiRPDpZJ5tPRIcov9SsH+xkkEEhRkh7RKEvmWBy+OG0jCwiPVgpe7NR+svmHYOYQxScKAmcMV0WBhv1n7xKBrVutnmPRO/qJI+Rt3ZMG2avQ2dGfmHxvXs/MSBJTzV+AbbeK0zgDoGZAmAH3DDvyMlx2v39AIHeHFbkXutvY5iuGzHU5miiZXtn6e0uEdu2MWZ0ym0XQLomEGVU
 xQdRO0dR
 WhMDCe+oyftUVTz/EVvCKF0MlyWqKtCSm0oIUT/a0d/lu4+GGgJnIgASes1bGfIsaYOuY4X4tgkf8/sv+ZC9z/uOsjKGnjk9r9ZiezX1o9UpNFQ3sIEcvfDRzzwyRyZX9D3gWSD6HyHhMY3IfAqs8jhcM9anTHuKEO4WmGN7VCGY+4jKMzza+q7U6KPvfmIN7lDAvR0HGnKf4UJ8S3dBApYupBsRVztp7uJsNpR1+QxtJK03Gg5HLPuEwpu5CxozrGhBvOgKHC1vDF+z9jkLuw93m8yl1M9XaCLRxuFZQo1Oll2nMvXI+AHGr+Ffhg7KAG7WPj4Bu40aTY/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 12:04=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> On Tue, Sep 2, 2025 at 12:01=E2=80=AFPM David Hildenbrand <david@redhat.c=
om> wrote:
> >
> > On 02.09.25 20:59, Lokesh Gidra wrote:
> > > On Fri, Aug 29, 2025 at 2:04=E2=80=AFAM Lorenzo Stoakes
> > > <lorenzo.stoakes@oracle.com> wrote:
> > >>
> > >> On Fri, Aug 29, 2025 at 10:42:45AM +0200, David Hildenbrand wrote:
> > >>>>>
> > >>>>> I do wonder if we can identify this case and handle things differ=
ently.
> > >>>>>
> > >>>>> Perhaps even saying 'try and get the rmap lock, but if there's "t=
oo much"
> > >>>>> contention, grab the folio lock.
> > >>>>
> > >>>> Can you please elaborate what you mean? Where do you mean we can
> > >>>> possibly do something like this?
> > >>>>
> > >>>> UFFD move only works on PageAnonExclusive folios. So, would it hel=
p
> > >>>> (in terms of avoiding contention) if we were to change the conditi=
on:
> > >>>
> > >>> I think we shouldn't be using PAE here. Once could consider using
> > >>> folio_maybe_mapped_shared(), and assume contention on the folio loc=
k if it
> > >>> is maybe mapped shared.
> > >>
> > >> Interesting!
> > >>
> > >>>
> > >>> But the real question is with whom we would be contending for the f=
olio
> > >>> lock.
> > >>>
> > >>> Is it really other processes mapping that folio? I'm not so sure.
> > >>
> > >> Yeah, I might go off and do some research myself on this, actually. =
Nail down
> > >> wehre this might actually happen.
> > >>
> > >> Generally I'm softening on this and maybe we're good with the propos=
ed change.
> > >>
> > >> But still want to be super careful here... :)
> > >>
> > > Anxiously waiting for your assessment. Fingers crossed :)
> >
> > I'd suggest you prepare an RFC patch where you neatly summarize all we
> > learned so far. :)
> >
Sent the patches:
https://lore.kernel.org/all/20250908044950.311548-1-lokeshgidra@google.com/

> Sounds good. Will do. Thanks.
> > --
> > Cheers
> >
> > David / dhildenb
> >

