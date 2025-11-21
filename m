Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43F4CFA474
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 05:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E02E6B0022; Fri, 21 Nov 2025 00:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 190AD6B0026; Fri, 21 Nov 2025 00:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0809E6B0027; Fri, 21 Nov 2025 00:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E64596B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:38:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95F1FC0487
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:38:42 +0000 (UTC)
X-FDA: 84133509684.20.BEA312D
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id AB4A64000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:38:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hsK/R+QE";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763703520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZf9JOxQ86iiFnhVwWUq/d7v0XLERMhRMClwCQw1iKw=;
	b=55YP2gg+jgtdo/z1w98DWVcSJ51niXwlFgFdyyC97M1+NBQiKbgmP3fysoXUlm1EbSkhZV
	udUHY/bhHTbF/khOfhPz3erYwtlTrjOElVz0cx4hlyeJ8kxZA3/Hbirez3I/ftZJMfLfSh
	eClGHyy3NsaAJOCtHb2IiGjYgeYdxP0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hsK/R+QE";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763703520; a=rsa-sha256;
	cv=none;
	b=E3DtR4EzsGCrlEn84U2kiLER4gPws+T8DT5BMn/WeJd8dZtaCORcU09yF1YYJwjFQZTXi1
	UZ4w1yKmhVpYdvVV5ZVODSwgrl8tacoOyzH0H2+km2DkER/NFYWs4x29ZOlOItleufKUfq
	oUGA8tn6hu/lX123NN/omJVntOJ3brU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b73a9592fb8so346274266b.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703519; x=1764308319; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZf9JOxQ86iiFnhVwWUq/d7v0XLERMhRMClwCQw1iKw=;
        b=hsK/R+QEr0fkScgidt9WiploxpmNzxjDOpyMiNlgEklOuyPjgs+dWZK3jkZBNCRlhr
         fQjP/mqhKHCCZSbY45pSNZRGoyJHgnX2Cjs/GpeZbJXnH+WrpxmnSq+v+j0oh6G5TJoq
         xgms9vo+TT7mBAk0O1EnukDqN8Ppb6grtR3n+y6akXzIYp9B1+d8syz9GOhQSNUf2GRW
         uHLIMSNF7u4X4qyLpulRCQ3TXSxaJ5uTKU2I1AIVUMnD4gyGuEEYsbyuot+OXuVSnV5I
         JLIpa0e0gsgInWRAsmfy07V2LssH8fKdMYqc7wrq+dqh+4byzZrJe67fKNhfLHkl3NBd
         Ou7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703519; x=1764308319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aZf9JOxQ86iiFnhVwWUq/d7v0XLERMhRMClwCQw1iKw=;
        b=Frulk+5hKpSnRVlfCNYk/14/uBc0SSoxFhrMN0/vCuBe1SFYWQyKoGzP8mm9vlN2TD
         9TFUG11I8glSI/f04yvNnIQwIhjkuDPlozrsVPj9fEdtymEDH6I6CrsOjVfw/TSPGMjG
         PzH13okBV1RzbDTjLWp2Ij57QTyZ8CDnjhASRLByB8eyldvECeLGx5fHjtKFSoVQ5Pyw
         UKcBupaCRFyfvOYUNrcEF9G3a5oZPiqqE+htTCz8zyNTVM2qhCfZl9soj3w0tU1xZnGr
         6siEoKnzbtl/00KClmKQbFDikZIMMbtgiQZo+KtgyxU6LmJpNwSGhSQWv8FaZkTlrEgf
         7gHQ==
X-Gm-Message-State: AOJu0Yyf53fVX/6fPjtPHtuUMnSEqeiNdVGxj/P63/yf9OSfSa8mn53I
	nbH7HMk1rPJ1tXbYa8pojRpHMpRf6PX4whrBa+F6o9lx9VUPvdkZlAPrsOHzvQ1G4bp2kV6K97p
	aR9YzV2Ex+xjJaGnsqyVjlFadOj+tArc=
X-Gm-Gg: ASbGncuDCVdetf05A/WPwd6ERqa2qNhzUIQtBeyjF8BoUPMfoa6mCYPPpFUVmz7lFhA
	Mh7AggFUkRCmbNYnzclCXHZaSwyJVjseENtTPhRncrCYbAvhu9yRKRX++7PymFfcpdf3K6X9Da/
	2N6soKra/d0ckbFyxibcTxROx0XrHo/7foN9zleYcdHFghVeBKDhPkz1EPbRmjQ4qYMcJE0OWGi
	aJWdbqiMDQ1FY7WWEPijS9WtoLqaG3VjWa2osgNfov9IG6/1Qj6Ind9bSFTNWmb4cNuAJY6q9E+
	lJkURXsdtXeIOAyQ71FmngttkmupogQ=
X-Google-Smtp-Source: AGHT+IFePgQgKlH/eH2vCzGJPecA0fdnSvAa9+WyV7mxD0ypgAIxV85s/UVnPWH74w8a7bE8RBszO0q0qp1OZFNqWwc=
X-Received: by 2002:a17:907:c0b:b0:b70:4f7d:24f8 with SMTP id
 a640c23a62f3a-b766ef48d60mr132631166b.22.1763703518710; Thu, 20 Nov 2025
 21:38:38 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com> <CAGsJ_4zSqQax-Ct-zz3uMZ_dD7vnvTjWZ_BsnXBnMVpVNNDYUA@mail.gmail.com>
 <CAMgjq7BYNwVSX+=KDxmdFpUZ4gnTDjA7LU_Fi=J6SFUV8pAcUg@mail.gmail.com> <CAGsJ_4y1VyyJj8zfrA7zDOUJ9OSGo6z6KO1zX6n3iigvYpYheQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4y1VyyJj8zfrA7zDOUJ9OSGo6z6KO1zX6n3iigvYpYheQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 21 Nov 2025 13:38:02 +0800
X-Gm-Features: AWmQ_bko2-SSnRjj3i3fNSewSpvOlFhK-yP5ju5e19sYcZBHIvpeWIbxWCvBgQ8
Message-ID: <CAMgjq7DaviOqRoiTGUKdY9N8k_p7yDjzfbzxVP_iiz8mc1DqWw@mail.gmail.com>
Subject: Re: [PATCH v2 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB4A64000E
X-Stat-Signature: e1eet5a98mn41eyziqbgtayrdonix3sr
X-Rspam-User: 
X-HE-Tag: 1763703520-292280
X-HE-Meta: U2FsdGVkX197vfEkGA/+g7gowDk77jUp3rYPCwv2vuu4qwxukicJ0Vl+NGGwBQsjO+HTHj7j2LKzAqO1pZGLQyDORTJikZeXjoMSp8w/JVM/TLneKW5NperSRa5Xz2Pkw8xH6Eoy5f+woVONQrSL8mvSks/+x7lyirnBpnp455PPBwQUrlzw55WjUjX4hVn9JWywURdeKzJ81lL5dopqioPZnZyqFSYFQB6V7J21pq5L6eotxYn61tZsfEegYfDIamA/do4BamMI+Rax1sPpefLc1fk69hlDkjrXAMExdlNBGDSKKtThCA3P+R+hUU40dJ0qcKT1J08otan9NIKo5qQWhuh0w8CcUDYC/SJI12rWnBfdAVl/dhohCp/S+pb2KkUYAUVoS22l2yEiP+3fTeXmBCtIygBmUXbs+X7JK4wFPhcUI/yJ292d8iD44+V8ddp51c0LXncg2B2sJtDDt7SVndG3/JnJw0SUoVwoZ3Ed/cig5ZZ33eiswYImAN+4COhlKxzWu5r+Q/ezN8UdIedVY5NXqmOm6dA1cxdjBMJu/IJboNXQr2mNUStFkaIoxHiU0FMcVbgLiU3MZ+YlComs70jCEE0fH5DeiKHnQ/ZXbjTNXyuyWEQlkJt1fWyn9i/ch8wlR6MoGTq7gq06rShdIT6FXEMH+x15IqSdD2fin7lL0qXe3CXc2l3qE8mG/1nEDlGPOTnrg2/VtItsgUf4MvqHlBV4gEnBj416VZorsgfl2/xMJOwAAm0yBJ+kIx4lFWXTMnrkKMasBwrziBhUApgA15nyfeEK2lgOQWiqZaEG8ht0fxMWwKyQpSq74+MSNvi9qGHohzCTLwau29KWh67hB8qikF4vy7g8UFrS0k7bdj7Y0LhnN8fN/lAUkssxkscGySfQ6MkIGVLrjRRJ120WVChiEqfoGuPuwKn7pAceU1aVdfkOg2EfGLO8TgZezuLLx6nHLGX+/dU
 MiIlq+TF
 q3km9zaPvuEdz+8/ixmr2dtndYEz2iJC4GQE7rTWqqfjg6OJrOjGARvEewRGZdgwT4vBCw/pH/eH/OtfIzuudgpukIwA3x9hxR61fQhEi2l2bVT6mlsVeiGCOCvjJCdb5nlUDbpJguABEJhJf8o4SBHPnLYnDmKYdnUC/tPEKS+RkpvXBL1AON5uaJdrV3EgzIe0dgDUE/wjrSTNZMWmzninebpXHBJ+8pxKDOvvh0u7BDbf+cksa+uWcyRyfu7ZqQ8X0SlsOzheN90W98lBjlbqcBpqDXRO9lv+JEAQBXIPyW232+J5S68q0LQZiQsCgK4mb2eNHGQVPaGvF4nTHhcmdNCNxY849RkFZux1PXfw5yijG7J1bkLFt32V8YhaJ0urj8oVo0VZJIXjM1M1MvCN36ypT8A09CQAJPdrmypieCew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 12:56=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Fri, Nov 21, 2025 at 10:42=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Fri, Nov 21, 2025 at 8:55=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > Hi Kairui,
> > >
> > > >
> > > > +       /*
> > > > +        * If a large folio already belongs to anon mapping, then w=
e
> > > > +        * can just go on and map it partially.
> > >
> > > this is right.
> > >
> >
> > Hi Barry,
> >
> > Thanks for the review.
> >
> > > > +        * If not, with the large swapin check above failing, the p=
age table
> > > > +        * have changed, so sub pages might got charged to the wron=
g cgroup,
> > > > +        * or even should be shmem. So we have to free it and fallb=
ack.
> > > > +        * Nothing should have touched it, both anon and shmem chec=
ks if a
> > > > +        * large folio is fully appliable before use.
> > >
> > > I'm curious about one case:
> > >
> > > - Process 1: nr_pages are in swap.
> > > - Process 2: "nr_pages - m" pages are in swap (with m slots already
> > >   unmapped).
> > >
> > > Sequence:
> > >
> > > 1. Process 1 swap-ins the page, allocates it, and adds it to the
> > >    swapcache =E2=80=94 but the rmap hasn=E2=80=99t been added yet.
> >
> > Yes, whoever wants to use the folio will have to lock it first.
> >
> > > 2. Process 2 swap-ins the same folio and finds it in the swapcache, b=
ut
> > >    it=E2=80=99s not associated with anon_mapping yet.
> >
> > If P2 found it in the swap cache, it will try to acquire the folio lock=
.
> >
> > > What will process 2 do in this situation? Does it go to out_nomap? If=
 so,
> > > what happens on the second swapin attempt? Will it keep retrying
> > > indefinitely until Process 1 completes the rmap installation?
> >
> > P2 will wait on the folio lock, which I think is the right thing to
> > do. After P1 finishes the rmap installation, P2 wakes up and tries to
> > map the folio, no busy loop or repeated fault.
>
> Right. The folio lock might help. But consider this case:
> p1 runs on a small core,
> p2(partially unmapped) runs on a big core,
> p2 grabs the folio lock before p1 and therefore goes to out_nomap.
> After p2 unlocks the folio and wakes p1, p1 may not preempt the
> current task on its CPU in time. p2 may repeatedly fault and take the
> lock again. But yes, the race window is small though mTHP might
> increase the race address range.

P2 would remove the folio from the swap cache if I understand you
correctly. Because from P2's perspective, the page table supporting
the folio is gone, so it would remove the folio from swap cache and
try to fallback to order 0. This may lead to repeated IO indeed
though.

>
> For small folios, this problem does not exist =E2=80=94 whoever gets the =
lock
> first can map it first.
> Ideally, we would enhance the rmap API so it can partially add new
> anon mappings.

Yes, a very insightful idea. That's also one of the reasons why I
added a WARN_ON and this comment below:
"This will be removed once we unify folio allocation in the swap cache".

By then we can either split the folio or map it partially. We just
can't do that right now because the folio may not belong to a single
VMA / Cgroup.

> I guess we may defer handling this problem till someone reports it?

Yeah, that's what I have in mind too. In later phases this will be
improved, and so far the worst thing could happen is repeated fault /
IO, and the time window is really tiny and only happens for the
particular case as you described.


> > If P1 somehow failed to install the rmap (eg. a concurrent partial
> > unmap made part of the page table invalidated), it will remove the
> > folio from swap cache then unlock it (the code right below). P2 also
> > wakes up by then, and sees the invalid folio will then fallback to
> > order 0.
>
> Yes, I understand this is the case for p1. The concern is that p2 is
> partially unmapped.
>
> >
> > >
> > > > +        *
> > > > +        * This will be removed once we unify folio allocation in t=
he swap cache
> > > > +        * layer, where allocation of a folio stabilizes the swap e=
ntries.
> > > > +        */
> > > > +       if (!folio_test_anon(folio) && folio_test_large(folio) &&
> > > > +           nr_pages !=3D folio_nr_pages(folio)) {
> > > > +               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> > > > +                       swap_cache_del_folio(folio);
> > > > +               goto out_nomap;
> > > > +       }
> > > > +

