Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176E0CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71ECB8E0007; Mon,  8 Sep 2025 18:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8188E0001; Mon,  8 Sep 2025 18:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596A18E0007; Mon,  8 Sep 2025 18:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43E788E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:12:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D17A011998D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:12:35 +0000 (UTC)
X-FDA: 83867483070.08.23E2CAC
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id F31411A0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:12:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HYMcx9nT;
	spf=pass (imf19.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757369554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Xl1XVxoSqwI0ZoraVsh703ayp8eVzWrOHFDUHS3EOo=;
	b=Kq+KI1WIXSymnwX0WFhp6Sh1p5kFnqElTcbcpmhCdKg5WVjBDwpAVY4WUKPag8CQi/hTAz
	6i7GcMCBXm/18G+fl2VtM0PginNy6idgb96FnumjgPo+7zZvIANweaCeNdT3bSUvxe4WBA
	rNG1jDrbjvsDQxvrRWSA0+ItHcFtVZo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HYMcx9nT;
	spf=pass (imf19.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757369554; a=rsa-sha256;
	cv=none;
	b=dT9syiOFcjDdCAgE71thIWCZ+pJVYzDfRsnH4ci5vODEhOroG4hxRIeYImIdiQJltgB3q/
	MQGU0f3e1kVgGSTQSCkdUGIJ9fKJ6X7AbvO8q38/piCpE1tfW/U9RxoS28iJES5S/nOucR
	0sidxDn/4SPevn7vw+xWkIPbnk0MWhQ=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so25379a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757369552; x=1757974352; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Xl1XVxoSqwI0ZoraVsh703ayp8eVzWrOHFDUHS3EOo=;
        b=HYMcx9nTIkISHvj3jck9obAiSNhi95qE9uUHvhPc0vvRxn7071O37mJ0Zh1s0Scjtg
         o5RgJJZ3cXnTiIhjoEfVNDSZpE8wBNdnWajLGuYr8yAzCwnykhPJvfVqoDZFS8G4gNH5
         RxhX8TVFnJe6bY8HroWxhaOn00igcC0VYeWlwxG6ZveIw2P25y3JUeZyt1MD4G3uOojm
         7RU0SnmVDg4S74i9LGvvt4RdJHKfSkf57TUtHqu3ZJekuRjAF6w+CqX/FGFs/DGngsNu
         0bi+H/HUla8ZRVS/MKkktk9oRuBPRH3MB81gskam6twOM73Z+XvQDYkbcfmsaqEH4qbk
         xwDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369552; x=1757974352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Xl1XVxoSqwI0ZoraVsh703ayp8eVzWrOHFDUHS3EOo=;
        b=BnnOIrLyGPpZIZ18V8/Rxgrw1cz9CgThoxMeO85ESOadqrO3iLj/407DXfmrEgOniy
         n6e0L27UDNIyyh6Czc9aFvVksLpZKAEjPMZ1X6FdUZXt1XScVwIHurb56Z36sPTjL9L6
         H9gWnuFyocMD0qdYIboM1ZqZNqiU95mvObbWWjai1Rsz3tijNOaVvqU9ZLps9J8Y8Yxg
         /+j0UQ++IAOWpT8YRzqY+kXNpTwN9VtnM7XD6yO4nOPaGFuJA3ue31txNceiX7c61rXE
         AUvdtmW1TO7X4b4deiewIgnFoviUEmxseQLuQS9huwfh8Ez2i7wnTzsP5qCjukPc9QMR
         Pe1w==
X-Forwarded-Encrypted: i=1; AJvYcCV7LaqRjy3ZpFBYjHKr5eWykWtNIq/HVvQsbdZvcECFwmCfM/DpvX9Wt1u2HvODuwwCzyj2rgW8fA==@kvack.org
X-Gm-Message-State: AOJu0YzQ7e+MA2uHqmka1n5ItwsDmx9/nwCAS6LipJG8WQ64eXT+dZnh
	zrYzikKjxGJWviPj48K+OLzsTDKBDpSyn6mf3P1ae1mFulwKzrJgMAySW8nq9Y1JSmUyyXpDs9M
	QMlT39zyhqqRV10iECJYP+HN9Lcu2dVBCsgh+HKVZ
X-Gm-Gg: ASbGnctK14k9rFw/G7YKrGE/12VJnwe/m/DtnX6FO6u+MjHznHRYTuveJ9rpu0Nileu
	zN5fjeYDntIIkxFQBNfMLwtKnsgYHid+abO4CSpszalWDnH6DatxFU68F923aOE7Fh9vk85JQ7E
	XUAG9blYZoMWH99XuShZIbl2WIWACs4gCo4BsySyxzoZbHGTl+GLDWPGWCvq9il8D+ZSPHKXFjf
	oz4A7XJsuvXHJLOvQT9If74Z7Ss+x0x4FEXg2xVF9jM9wbr+nuSJMrMLvs=
X-Google-Smtp-Source: AGHT+IH9odSsS/MEJl64A2Wsm9yxFRCaAThe4F3JEGy9jCyQRTU1Kgqv5DK9xlMH7xXkcP4LWiI0Pmdcp/kwuYbIT6c=
X-Received: by 2002:a50:ccdb:0:b0:61c:1dbc:67a with SMTP id
 4fb4d7f45d1cf-623d4bf0798mr160253a12.3.1757369552124; Mon, 08 Sep 2025
 15:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com> <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 8 Sep 2025 15:12:20 -0700
X-Gm-Features: Ac12FXw48nGuqW0IQGvyigU3wDeh4bbS_2gG5bE9Ue6xaCVGsZxYg8pSE4MSgaE
Message-ID: <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F31411A0008
X-Stat-Signature: dm5xakriczh8gugkzy9zeyytjh53cw86
X-HE-Tag: 1757369553-763772
X-HE-Meta: U2FsdGVkX18Q8lTpfqCFoNerptTvPc0pp7xjykHyg6QeIhMkiUVioJAlAnvRBFETQevcjCYKhQGh/vJkTzrXVltKzBDfYsMvOUgSZI/XqPBIcOhskgnI9EF62WpLiYe0Q+wQRJdBj5m+cAHpzw3SgttE0gvynbbX3BzmyWQV5hPHEQvyml0gExvrS2YXCpIqKxt3YNHL9Q6w7fD66EhAHy9g6vJU4T6iUFRpt4l3vdcixoMIZgBFCMLlDme3BeciLH/HqQIjrDxbaJdfpBbO48V8N+50O3BZ113i597tW61jArQAEFLeUUjsWq7IsvHYvyhWm9jzlDHciuhc03nodC/cTsmJ+gsF2hAPkr6Zpj50rnQHSokT5580okGnF/RFkufqgiaL66Q/JJaLgtpWeTvCvm3eCUK2qKTRFe38fnLdEaMjLba10LcVsRhtIzK9gh5w9iXavomv8ISbbk4h1go+Mza7vbmmcnnZc97wBu+JMz5RJBpcOXrTWyVrtDJzZMTPqeHMg6r2dNdBALeOJuHqL6Csn3VRBxDQJ1BMFtcOH9N+l/B9VRvxxuzOUfMB25vgfon7wGAYvlkV4lmLU0ENvEaHLQKZBNkbyvV3uYCUMhyV57/f5e8lp3urhQ4XbBmvHpm3YY0g0/ve/vjrVDHUKmn1Mtvgz3/g9ed2IOOhAPTOADC/cfLYeUMA3qDoyrF32IMB/rbYlb3VZrbc/l8FL/TU1UWC6z+141WozFoz4b5jNWJbY0KM/iz6hdBTTeVaEBPEgqxDzHrelCwXggBr4qo3UifUMTtb3xbuG4PJ+RswzpinYZfTRt4cm/jILHhVFH2zfLtEyim42ezWEPhMGhNwKi01t7BAjRkCBgb788aQwgwGwWY2Jb5YwjjtNwdkGuXBWg4rWissB4KpAcTtKJ4CCfgkSVltITb2IIcznFHZdXX8O4g34wNQMmgopeJLVPqznOW0VIwHCTM
 yQpVqHXU
 VWMQdrr6DA7zeaXZ5NAO2FWgByV2p6u5BgKn9spT4ct5xVdmngjUBCUiluGPuSqq9S4z9MunA6etE2ZtWXRw2+BWL7aW7pl/XYTuxUvtOMuh4/c1934ol0EYWS1+pGmO7fl9h0ONWHa+UAUG5i/dr/OGGbRfTkB+ZrQ+MwwJ2WGalXjFMYrq/uSH+mgf6PUg7fo+He528SUuZEpZHGMKEKX8qrPvoOX+X5Wh1/f+td6/KQAxcnujfu0UxZ7t1Fgr56SDuyK+A0kD6S1EdkOaH82L8S11CQeclTBHQM4J3xp946LD3Uy9Yy5owmF86cxXqRsyLHBfmGOIVlNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.=
com> wrote:
> >
> > Prior discussion about this can be found at [1].
> >
> > rmap_walk() requires all folios, except non-KSM anon, to be locked. Thi=
s
> > implies that when threads update folio->mapping to an anon_vma with
> > different root (currently only done by UFFDIO MOVE), they have to
> > serialize against rmap_walk() with write-lock on the anon_vma, hurting
> > scalability. Furthermore, this necessitates rechecking anon_vma when
> > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> >
> > This can be simplified quite a bit by ensuring that rmap_walk() is
> > always called on locked folios. Among the few callers of rmap_walk() on
> > unlocked anon folios, shrink_active_list()->folio_referenced() is the
> > only performance critical one.
>
> As I understand it, shrink_inactive_list() also invokes folio_referenced(=
).
> Shouldn=E2=80=99t it be called just as often as shrink_active_list()?

I'm only talking about those callers which call rmap_walk() without
locking anon folio. The
shrink_inactive_list()->folio_check_references()->folio_referenced()
path that you are talking about always locks the folio. So the
behavior in that case wouldn't change.
>
> >
> > shrink_active_list() doesn't act differently depending on what
> > folio_referenced() returns for an anon folio. So returning 1 when it
> > is contended, like in case of other folio types, wouldn't have any
> > negative impact.
>
> A complaint was raised that the LRU could become slightly disordered:
> https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@oppo.com=
/
>
> We can re-test to confirm if this is the case.
The patch in the link you provided is suggesting to control try-lock
for anon_vma lock. But here we are dealing with folio lock. Not sure
if the ordering issue will be there in this case.
>
> Thanks
> Barry

