Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFF6DCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B15A8E000B; Fri, 12 Sep 2025 17:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488BC8E0002; Fri, 12 Sep 2025 17:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39ED38E000B; Fri, 12 Sep 2025 17:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD1C8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:26:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDD811DF81E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:26:18 +0000 (UTC)
X-FDA: 83881881636.01.30F1910
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF3D340011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:26:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p5ast3Fh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757712376; a=rsa-sha256;
	cv=none;
	b=bfHdMakxiNVWWrdrWSaBWkqMxPjKCEG75qisoy58Mo93U0ZiX0PLqklOv931V4XRimGmiz
	DqDfK1wlTq/CEmUw9GYxPSfnQUW94u+GEaPlpGucFDJ8sb7/3ttXcV9GsTJB6KpJoGzKPd
	nYgHBFz+7wNj7Oy4v7L9uXEwS+t47kk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p5ast3Fh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757712376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvKdVbyifmMQtLiLEuJNO0oLY6w9M5FF6iZOtodu0JE=;
	b=FjNqS8xMi9BiXm48Md7cnS9SbKHE6HLRmDDLuO4hxpPVywDTz0cRx+CTx5xWj//j6a2B/Y
	g00K3KZBza5pYdC+qggrdvym/89YCpno4zjRF+veXWKMiJdowCR7ptnZQ815HbS1hzrefJ
	IoI0Geo21OoZKfi5ioPpingaU1QL1CM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b78657a35aso40751cf.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757712376; x=1758317176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvKdVbyifmMQtLiLEuJNO0oLY6w9M5FF6iZOtodu0JE=;
        b=p5ast3FhzWXQ8qkvBsmshoVOTr7mbvdOxGCS2aMYEUsy+t0AQ6f42czVZ1aYG7WtbV
         NapxrZUYfE2qBT8SVmIA/U+8+mEL3tzezlWHHhxDh+9OlJbmgIe2qUMPspsbiqJ2nO33
         EEgnd82PWc4VyvO1NmIXqu1hV3y8uJeDRoLFZU28a3BCenG7tdEljlAJGXkZwlRCrlNT
         11R0h/T8IeJ6x+Ra1gz5KLnGC1ZVrHoXmqyZEKMf/a2AJu42VQS69YsezgRqxbWSHhD7
         8ywNPnIdagbmD0TX9lf40WY4FoXBSBu1RPBrmOwMF8vWYlohHX6b7B3N0aYgkJQOyFvL
         nwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757712376; x=1758317176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvKdVbyifmMQtLiLEuJNO0oLY6w9M5FF6iZOtodu0JE=;
        b=Pw5/9RlswvVs8bzsoXoPpRJsHieIlAvrcKjiWc8LKJsY37SfUuhECHSDIn2PdIG19H
         aDZ9P8qsyyzhAi23e7vf70MF20REmiSS9TcHIngav8Hh+snsoTTXPcO9n7AdgL725VcL
         8QjE4zO46ePy07jWCBlzxn+J52rBjDj7FcmsIUzbfxkC+bdaxBwatAroHHO8YixyTfu0
         dCD4tY4qHDFM+sJ2PUQK7TDC9Aq6zDWp9lOGhXAOATIQsMQ0kx6I384xbL+fWnbh4p0L
         y8hV/9/wokQBVHcTlu8A1CjT0twR+1++LEu4Pinlo90pyP9LoY/w0Em98872JhaYxdIC
         23IQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5pAkRGmFhG16o07+yw48oBeixENsvEwwx3/nHA9ROUK2hsPp+/HjJwONxR62mb44gp/Xi8yvyIQ==@kvack.org
X-Gm-Message-State: AOJu0YyR7bUInD63oF1wa7q9+VAhf6kaVzLy9BkujgKm+4EEhKL1pZZI
	zsyOR+ioZYJclwxUNCa3EbAalliZUcJ6giCGVMo3tT49jdmq++eUu0qbgFf6mFj5ZrpJNzIZmwx
	Eq2ayJFCHF1tI8+FGiekB27pMEx0DGGjqnHwAg+xD
X-Gm-Gg: ASbGncsRwnq3x173vV8Z1GF+lOig8ppusHVM5/ekgm/aA7BWFsczul5Tt8lRgzCK4BU
	ZDEiCfi9UceMqwi0Pd4SZjVNWcxE96Z7iWLk3babYrV4/VyIzFkSxPpWjPBI7LvFVpkobAidPKm
	iFhtbPqPCkEJWKniU/0NfUl2f/t9jopS7sjR30HG2RVry0a1Yqp7VwnZrP1cY/i5tPhcTDVrauo
	Huwdk1lalJOsnqS62sUxNM=
X-Google-Smtp-Source: AGHT+IFSuL7CTzS4gEZSpO1X8g5FeeNt+3kp261icCkCLwm42ah7q7mBs5KzeZelGn9VF9fWNCIiTNhUC/wH74GMWkg=
X-Received: by 2002:ac8:5906:0:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4b78c7452cbmr493111cf.0.1757712375514; Fri, 12 Sep 2025
 14:26:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com> <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com> <avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg>
In-Reply-To: <avhakjldsgczmq356gkwmvfilyvf7o6temvcmtt5lqd4fhp5rk@47gp2ropyixg>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Sep 2025 14:26:03 -0700
X-Gm-Features: AS18NWCT3yKzoCb64MG-xR1etkq8v64TAfWEV1zPfnX4dNeKLRbKwfi5_tlAVvc
Message-ID: <CAJuCfpGPcDUEd0A6jf=pmMkkF019JXGk9GxEPE6iTHOdp8+Xww@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	vbabka@suse.cz, harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, 
	andrii@kernel.org, memxor@gmail.com, akpm@linux-foundation.org, 
	peterz@infradead.org, rostedt@goodmis.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF3D340011
X-Stat-Signature: ymfq7xeskpp51kz3q76qa5urd71igkb6
X-Rspam-User: 
X-HE-Tag: 1757712376-126455
X-HE-Meta: U2FsdGVkX1/5pEJIQGazkZIxU7wX0xmzoNt3upDSRXRtGVhy0m3XGgjXxmH7xw05en969zRWhgMPhVO8ABGxM2UsipUiS0VxiS8lhYb4okKK2B29w7qoPkRF7VaP9lj+4iWO3eTAhLaiZjL+lxsCL/e1e7U81u7UCHy4CPOlwSbl2UfkKaP6ZR/wMxs5Tbco/rVCGKPn4LrB1caJJmhbv85GB1klSdUA5RhXSbGkvCR8Lr+DgZuE7qzHkB9U5kMyuiRR/917vi8exW9hUxxpS1Y+P22kklgoeFMIcLMn5kO/8xI/l4G66MKT208kN3R5H3/g/bZJ/dUO/WQQ/xYOOWGIuDKmqLNfP3wraehxHhNeGaRwskIqEDKupTZdFUzfF14AHyZgHzyY1itc3OJg0luJRDtsxQfnmC/NNTgjtLXPwcEes/3CNLhqGY7HKdwtRW31XqmJSWlwlnzXFwrg5CjpSV8BToBs8yS1rz4oLeWA9waS4NgcHWpJcXORAV9HIL1InDUcCruvkinXR/FE9PTp2pGQhnEYVy6/Rr4aEr6H1s63wqTM89Ov3OgG/jGgfG2sufA+gre7IUbGZE8mub3YlzwHTZQq2lP+mYkan9exXeT10Ug4BhCgHtmsstK0NaQ0Y9wWAhy/H2WpZYjPp0qx9lcP6WD6XplHkuyVb8TIZkikUQ+hrDuVMTS0ianxU90fH4LDePBcxabx6KxRO0hT8KfV5aZtn5lAtJG68HU7jgfoc3tuQN1weTc6SD1oWdIxclApMpsKPiyiQ7DTDoML27oXT7cIdgA9b+zhoLN7IFG11bMRhSnEjol0QYT5oKx7fehsTvYQJHG43OIsAKCnvSfU+sfEKxxIeH9YQ61mod8QT1xxnCuFs6+LleXm00zouVmMtd0q1Zw78x40qQo9biKR+ueeQlNCFkDL86mzzSFZDCe53x6CIi79rpAIIbDXCNPVXFRgeVRlBcB
 jxi5z2IK
 BiVHVUi1EMtLHBjRBwdPeRGUUwCrf41jaDnDezaejqSR4y3vt3AmEbAI0/Ljc3G3D0wOgQcDmUUYURsQWpvqZITs+spMt4/kuHQU+aNOf3rKoyin3SNd8G5xnupbhrGQOmaGGviBxNIH/T2dQy2pw3p9YJr/4i31NtDmS6pdPGEM9KOM+YFYoWXz7RfeIt38SN2eDd+EMG3Aitwlu1iio9o2On1/W9JsN59SIcubxKOoQFghzsDU2VdMiNpeyxr0UsodI8bNUe5y9Q+9EBOwpSEwZCz2WpQ+bh2e4VLIGE/rT7nXRXg8Q8PUCZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 2:12=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Sep 12, 2025 at 02:03:03PM -0700, Suren Baghdasaryan wrote:
> [...]
> > > I do have some questions on the state of slab->obj_exts even before t=
his
> > > patch for Suren, Roman, Vlastimil and others:
> > >
> > > Suppose we newly allocate struct slab for a SLAB_ACCOUNT cache and tr=
ied
> > > to allocate obj_exts for it which failed. The kernel will set
> > > OBJEXTS_ALLOC_FAIL in slab->obj_exts (Note that this can only be set =
for
> > > new slab allocation and only for SLAB_ACCOUNT caches i.e. vec allocat=
ion
> > > failure for memory profiling does not set this flag).
> > >
> > > Now in the post alloc hook, either through memory profiling or throug=
h
> > > memcg charging, we will try again to allocate the vec and before that=
 we
> > > will call slab_obj_exts() on the slab which has:
> > >
> > >         unsigned long obj_exts =3D READ_ONCE(slab->obj_exts);
> > >
> > >         VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS), =
slab_page(slab));
> > >
> > > It seems like the above VM_BUG_ON_PAGE() will trigger because obj_ext=
s
> > > will have OBJEXTS_ALLOC_FAIL but it should not, right? Or am I missin=
g
> > > something? After the following patch we will aliasing be MEMCG_DATA_O=
BJEXTS
> > > and OBJEXTS_ALLOC_FAIL and will avoid this trigger though which also
> > > seems unintended.
> >
> > You are correct. Current VM_BUG_ON_PAGE() will trigger if
> > OBJEXTS_ALLOC_FAIL is set and that is wrong. When
> > alloc_slab_obj_exts() fails to allocate the vector it does
> > mark_failed_objexts_alloc() and exits without setting
> > MEMCG_DATA_OBJEXTS (which it would have done if the allocation
> > succeeded). So, any further calls to slab_obj_exts() will generate a
> > warning because MEMCG_DATA_OBJEXTS is not set. I believe the proper
> > fix would not be to set MEMCG_DATA_OBJEXTS along with
> > OBJEXTS_ALLOC_FAIL because the pointer does not point to a valid
> > vector but to modify the warning to:
> >
> > VM_BUG_ON_PAGE(obj_exts && !(obj_exts & (MEMCG_DATA_OBJEXTS |
> > OBJEXTS_ALLOC_FAIL)), slab_page(slab));
> >
> > IOW, we expect the obj_ext to be either NULL or have either
> > MEMCG_DATA_OBJEXTS or OBJEXTS_ALLOC_FAIL set.
> > >
> > > Next question: OBJEXTS_ALLOC_FAIL is for memory profiling and we neve=
r
> > > set it when memcg is disabled and memory profiling is enabled or even
> > > with both memcg and memory profiling are enabled but cache does not h=
ave
> > > SLAB_ACCOUNT. This seems unintentional as well, right?
> >
> > I'm not sure why you think OBJEXTS_ALLOC_FAIL is not set by memory
> > profiling (independent of CONFIG_MEMCG state).
> > __alloc_tagging_slab_alloc_hook()->prepare_slab_obj_exts_hook()->alloc_=
slab_obj_exts()
> > will attempt to allocate the vector and set OBJEXTS_ALLOC_FAIL if that
> > fails.
> >
>
> prepare_slab_obj_exts_hook() calls alloc_slab_obj_exts() with new_slab
> as false and alloc_slab_obj_exts() will only call
> mark_failed_objexts_alloc() if new_slab is true.

Sorry, I missed that detail. I think mark_failed_objexts_alloc()
should be called there unconditionally if vector allocation fails.

>
> > >
> > > Also I think slab_obj_exts() needs to handle OBJEXTS_ALLOC_FAIL expli=
citly.
> >
> > Agree, so is my proposal to update the warning sounds right to you?
>
> Yes that seems right to me.

