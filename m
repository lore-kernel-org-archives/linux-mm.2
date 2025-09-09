Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 327F8CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5AA8E0006; Tue,  9 Sep 2025 01:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7843E8E0001; Tue,  9 Sep 2025 01:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9DB8E0006; Tue,  9 Sep 2025 01:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCF48E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:57:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07B3A1603AA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:08 +0000 (UTC)
X-FDA: 83868653736.21.E10C3AA
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 364BC1A0009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:57:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uf0mCj8n;
	spf=pass (imf19.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757397426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0I1zAXhdndSc3XvrJimxDyPrxl8WejTBLzAt2+qA7Fk=;
	b=GdumPhhQJKOzr0YCA+l4KaRz0j13A9el5rXJ/4stklVEoN9KS3y8aHtBRKjN3Ih9efn00N
	u8Olc/0m9JbMFM23aCdF01ZNTGWWqIfFdiGs9KwaX588qEnZ15KX5xbvofmp2D1u1bR9Sf
	fBaASfvB4MZR3sTRFcdXgMIe+JjrNRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757397426; a=rsa-sha256;
	cv=none;
	b=y/qlo/OVyEtfZNfkWT6BSeSin1Y93LrM39nSkTSRz+5jnAwL+R519DaE+i0CXPMpxcyI5+
	W8P0vSQ64ef9ajfpyVThb5AQc8PdLSHs6rtXN5FLm9VRHAZiyk+3/pxX4Sh+ewzVH2QwYO
	OJdSZgN2cdXsumv2HI4ajT2maims3mY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uf0mCj8n;
	spf=pass (imf19.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so21513a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 22:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757397425; x=1758002225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0I1zAXhdndSc3XvrJimxDyPrxl8WejTBLzAt2+qA7Fk=;
        b=uf0mCj8n+zShS0CDCvuM8GoUboEODXKDyPjkCN6PkOvrzwyP46oOOGxW2iSnODVOYV
         xCy6Ic2L4CrDT3amJM6mBtgNSX8E9/g98Csr9/9J98ELzG3zXUr6iN4zSVUwRaroQUJw
         +i9HknlTRbboaAya++zxcRADP1pEWlnmojVTJ9JIsDykfi7G4w7ZSzrHK3ujgH+Wjma/
         e+pLXxtza8bmADxPTZpuicVYRpMUPVl/VLTnLDcLDvEwUWyWoSNd5vtKdmQsf4kyhSE6
         JtjvIzcKHCHvuiEKf7aKCotDi8nEP0zXzy9A5sxA4Nd8OpvA5LbglvTchnB2DJa0Xxth
         DMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757397425; x=1758002225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0I1zAXhdndSc3XvrJimxDyPrxl8WejTBLzAt2+qA7Fk=;
        b=ZZ0+JyYE9UdllNpVHKQYHt0qR+GbfcRLJHTXFtkF2/5nuiFAK9olpHgYQiSrzyj8vp
         xqkvvFTpPMRD7TKEMEUEM2Lekc1Q5loUKEWGlm0OLexXj05ZmAELqTvQbZMbAxQ3CRv2
         lVRl/dW/rvh/raoebD/u/Aa8aRXzYtTzfNAwgD7rNoGROPp6tmp/Uf9/bC8tC0ThNI/4
         b38w2z8C9Q7LtysIdNgoKiv2tItOBJyOfPqSo/QbhzB2Mjzwwd7AXv2PHGgMfpgIsags
         CF85CNQVswIh8cgvuXz/tNnQ2dbhir9iGq02wWQSALTAJINKWwia3sdAyUjEZArjb3jS
         j98Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMEynSlTgbQ897tMR5rMylW7/K+tgtANFIeeY2AgLCY8RUK9zAh7AXuiFYhTztWYoZM7sHwVQykw==@kvack.org
X-Gm-Message-State: AOJu0YxsqkV8cLIwYsD7wiaWxoFb8UfZQS1mz7A52AOjUqS6IMxyJOu6
	kMj0lDBEk6t7X0ATTjGWXY2YaqQPKbMYu47jUUCqy4ZKmk6CQhpDNVDQDGk1Jwj046V/jTWvyxf
	3+T+gCrrNLUizxd4Ujedu6NtH7yoQrayAzk/0fxGq
X-Gm-Gg: ASbGnctuPTOpjRj+DZzZycy8g85B7pNWI44PIVBmZiOla8aAkYCJqA2/jYmvFobm10X
	sKzmog2xVjYq5/QXlREVwuxBb/+WNAjMinUHxn5SL/C/8MDAQMINes9rv0r06HUviRgZVAvi/L/
	Jjb+hXj4ZjwCIPy2r28OZuUckQR31S7jThI4h2SrD7MxNhpUAq8Dne+1oE6on3cMZGgYFEEwbHt
	k/1hiT0H0A5ELItt3Y9ATyHu5xCTbtSiS/54ny3M/sLR4KZmu8bHB1J0w==
X-Google-Smtp-Source: AGHT+IGa9Afax9DwN8rE0JsUU7rSLfewbpMndfJukXBQBNknGdi3kxyYJBaIPwF+FpVUySaQnItiyCRMgakC7y7V4Wo=
X-Received: by 2002:a05:6402:28b1:b0:627:54d2:75cc with SMTP id
 4fb4d7f45d1cf-62754e1f579mr154687a12.6.1757397424459; Mon, 08 Sep 2025
 22:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
 <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
 <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com> <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 8 Sep 2025 22:56:52 -0700
X-Gm-Features: Ac12FXziICO3j4MyGPY5DB96lMWZO14yuWkOoKlLE13L7-43c386SSzyIZ8oH2Q
Message-ID: <CA+EESO6eNfb+92+uYDRRWdx4SJnHGY34QtzbWUpoB54yjvL0xw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qwre1qh7dq4q6jpgo9bpxp1fr1o4wqbj
X-Rspamd-Queue-Id: 364BC1A0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757397425-605102
X-HE-Meta: U2FsdGVkX18OOF4aST3myfpTp+dXdVH8xozSekc4y3XfSEOoKs9ZrY1sJbfyM2rQ1sXpXSJg/DtbZl7ftJZbCD6gcc199JMFnsCvjdsrXxysmKvFXwu+8xuefczVe64H59yGF+HCXo4ZR7MTyLtvXxZ4+q8f6T1l/1u/G7D4Xkj/2JWVudyvCbnSFggIX82NVZwOcG21AUAZlDaxqEWtBSweEBjpwgF8itaGjR7X6iHuPRt6DlQE5j9G++s9eIG+tjDBLQmHgVEfHFC9PXZX8BahRWJyZZzG++d2ubMvBKVEdmT8XH5dd/crjo6fqKStyGuY4eEdM08Exhr6cSB59xz/AI4jt155LYldk2G2r7qjAcQzlJoobd3wQ+kCAeAfSAcdXMbzalGl94rIWbZzg2qFf4UjQSlqI35qv/DVCrUSHvdSWZtTf0aLh92ISLJBNmLiArfwW7EnWxKgkcxZS8HYi7Upi/toqsxPCDSKesVjoRpj6ldwl9gnjgfiHXCvNkyAgOAiPaZsHvBJ/jXE8Ah1Ny+IH3UwA8YAN3EIbam6d9T2j2Vr8kmv/Fwp2VpvkwoS693WD2KCMGbTicl1GR0Rjtkd2ANZdr9yB+Ol4E687dSpi3vkMg56gNC8TeTvQC8+wXfg2MRPOStjYFUIQP/b1NFWmaLChuVCneaKVni/TnRfpekINpcASGssTFYKd9pXJxVeB3BbRAuI1sRKMs5seMPiQnJHlRXQHAez6ohJ3dAwYWfkjNKsQpSHGeT0fAWLvZdAn3EsjhrlD2xf/hzIZQR6BkqQT7ysc6AcFofyFWsbxspjswgiEZxa0lUbM/vZMiqROn6Y45c4BcHTjwOd57vfATuzQ0wumYZbohvR9cGaB5cJa+lp+RyQ6gODimFmO4nmvFovVUaI+DhnkjnC4ElbrpsOxnoUJZYj3cV5ZUC2un+jAkOZ0WAsM2lik+E1l/0abJY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 10:52=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Sep 9, 2025 at 1:37=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
> >
> > On Mon, Sep 8, 2025 at 5:40=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@goog=
le.com> wrote:
> > > >
> > > > On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > > >
> > > > > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshgidra=
@google.com> wrote:
> > > > > >
> > > > > > Prior discussion about this can be found at [1].
> > > > > >
> > > > > > rmap_walk() requires all folios, except non-KSM anon, to be loc=
ked. This
> > > > > > implies that when threads update folio->mapping to an anon_vma =
with
> > > > > > different root (currently only done by UFFDIO MOVE), they have =
to
> > > > > > serialize against rmap_walk() with write-lock on the anon_vma, =
hurting
> > > > > > scalability. Furthermore, this necessitates rechecking anon_vma=
 when
> > > > > > pinning/locking an anon_vma (like in folio_lock_anon_vma_read()=
).
> > > > > >
> > > > > > This can be simplified quite a bit by ensuring that rmap_walk()=
 is
> > > > > > always called on locked folios. Among the few callers of rmap_w=
alk() on
> > > > > > unlocked anon folios, shrink_active_list()->folio_referenced() =
is the
> > > > > > only performance critical one.
> > > > >
> > > > > As I understand it, shrink_inactive_list() also invokes folio_ref=
erenced().
> > > > > Shouldn=E2=80=99t it be called just as often as shrink_active_lis=
t()?
> > > >
> > > > I'm only talking about those callers which call rmap_walk() without
> > > > locking anon folio. The
> > > > shrink_inactive_list()->folio_check_references()->folio_referenced(=
)
> > > > path that you are talking about always locks the folio. So the
> > > > behavior in that case wouldn't change.
> > >
> > > Thanks for the clarification. Could you add a note about this if ther=
e
> > > is a v2?
> > >
> > Certainly, will do.
> > > > >
> > > > > >
> > > > > > shrink_active_list() doesn't act differently depending on what
> > > > > > folio_referenced() returns for an anon folio. So returning 1 wh=
en it
> > > > > > is contended, like in case of other folio types, wouldn't have =
any
> > > > > > negative impact.
> > > > >
> > > > > A complaint was raised that the LRU could become slightly disorde=
red:
> > > > > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeifeng@=
oppo.com/
> > > > >
> > > > > We can re-test to confirm if this is the case.
> > > > The patch in the link you provided is suggesting to control try-loc=
k
> > > > for anon_vma lock. But here we are dealing with folio lock. Not sur=
e
> > > > if the ordering issue will be there in this case.
> > >
> > > Right. Not sure what percentage of folios will be contended; I assume
> > > it is minor. Maybe you could share some data on this in a v2?
> >
> > Any suggestion on how (or which test/benchmark) would be good to
> > gather data on this?
> >
> > IIUC, shink_active_list() doesn't behave any differently whether there
> > is contention or not, except when it's an executable file folio. So I
> > doubt such data would be any useful. Please correct me if I'm wrong.
>
> Since we skipped clearing the PTE young bit in folio_referenced_one, a
> cold page might be misidentified as hot during shrink_inactive_list().
> My understanding is that as long as the percentage is small, this
> shouldn't be a concern.
I see. That makes a lot more sense why folio_referenced() is called on
all folios in shrink_active_list(). I missed that young bit clearing
before.

Any suggestions on a good testcase to gather this data?
>
> Thanks
> Barry

