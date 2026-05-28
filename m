Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD971CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC41C6B0088; Thu, 28 May 2026 03:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C755D6B0092; Thu, 28 May 2026 03:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62F06B0093; Thu, 28 May 2026 03:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A49726B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:35:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 474D81204CE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:35:07 +0000 (UTC)
X-FDA: 84816017454.23.CD0A34C
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4D6E7C0006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:35:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gww3MPQn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779953705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reouSAreG4DvxwmiDsl4NAPK5EKzixRF8+P3w1K3aZI=;
	b=ddWPEgnCs4S2j8+GjsLKRcgUmlfoN2qrTILzqEepa938gVTZvo6WbP5CsCdUxT9onLM9eZ
	5W7CLwv55gCzMyhneuqun9XvtBJBBv8P+dRElqfqwaYxD/xHc1Hh+m3OKlRnjb16ODTSwR
	8cL78YCUO5VRefpQfJIj0fTmfmjsJJw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gww3MPQn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779953705; a=rsa-sha256;
	cv=pass;
	b=V5uKEUlm8te0XPeofv7cZbdOB4hAxmTK4LlQnl0md6FASMj/1Bb5iu4y1ReDwCoyWHaRCw
	+IMimywq6QFoJXXmlbYmee87sMVZrrziy6lbyCdgfgrgALaUiddH7HPCmr+IHaSfWfwtTR
	cb3VMo/DGU/z+x7PNMPVdmqQgXUP6YU=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e36bb16a92so6453628a34.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 00:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779953704; cv=none;
        d=google.com; s=arc-20240605;
        b=KLqpdimxSDE6ms8TMeU8Ua+BO77VrAjAmB1M6ozecATKgacLTYrYX3oLx67d++JaGT
         N5axzpIxG8IvmLiZPohrTm8h2+6xIohnnTpIcv10N4p6GatM2ChRusH6Ph9FMm5BkRzk
         dbMGAwenAoaARp8uQ/4/ZhzLtDuMg/eMXYVHdav0iNTjCChfRkWf+PYcdgXxc9A8vEZJ
         39703MD7QYtgG90v6XzFUwoxq2aJMAO+KcmFuEDRD5tabp9wOdDJz1exRovTYvn0mhRJ
         pueEEBs3k+UKcftsV+HxBggYLKMbgaATEYdtrA4e1pJaPv8FXLsKEVx/AziOBqHK22qw
         MDww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=reouSAreG4DvxwmiDsl4NAPK5EKzixRF8+P3w1K3aZI=;
        fh=QvgZYzXSp+WG55c7NX+41VF/BnzDZictrznLHCEuHJg=;
        b=cy+lV2U58k3LhxOgFFerKOkfcGxt9rmypeWN5FDWRAhyHK1cD7Z96bPJVWgz4bCfo8
         F+3UxI244ztH5iD2CaDd0u10/r69HnmRMEyFcnKZ+Bnkl6w7dljEPPrxLc6Fe1kp/nJ0
         eyjsIrSW869cQ/aEQ9JBsmzpWYgfB0kp3yMw8NOs6C/z0aLfQF7YjjpDSbFjit0WHyLM
         KnazUHVx+iI/hdDsdNSo7eIGG5sdGyUKY66IEiVGshDDJnqKsH6rijCRoQaMkztLWWDa
         K37PmRIX51sA4+Q9r9G8Tnq+kTn8HVDXHTux4TyaOjedddM5X9ChQB0+a/RPVPv9Zn2g
         wTVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779953704; x=1780558504; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=reouSAreG4DvxwmiDsl4NAPK5EKzixRF8+P3w1K3aZI=;
        b=gww3MPQnXq0JMeKBBrel0WiRwZEccmd8OoypxinK7ljQcw9BAZxmj7s3ah6hA6FRKz
         tULoEWeoyDJSaRf2LhZSG7na3KBhEi6doWUHNp5e6QN5wo1WvioPmntu3FhUiOWj0eyX
         9jJx+irDdpntZCDrnZ/NiPzm0lwuNlHiNGxJUPnNIPa5UKnu8US63a+Gay/aQgqhb6hb
         fnnZSaNZJYxmOQ681plvLDHZol1qpf+UWEDlE8D+1Iqw7comp3dp37+UICQJ3Gk1PgAt
         VIBEWTZawZZPV4LEKnNXQX1704HzXqHYkb3mIQ2TvEFr2U2ePl514aBPLHcueWMKgN7l
         bAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779953704; x=1780558504;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=reouSAreG4DvxwmiDsl4NAPK5EKzixRF8+P3w1K3aZI=;
        b=gkeE+2IX74tIq24YfUoOX2MZXGvi6u21wScN7l7iUJn6RyqQNWf3iiPbgontuZe07e
         0wxXPJp/TiFFDd+Vizj8nq2viGtLgru//KkNWOqCR66dXFoZZQV1YV6KJExl6O+BPB4Y
         1y0ro/Z9I/+alNIPsOpqE583pGS3BBAj3cDauyIPM2OHV0NVJMXLE/5hvnHxOAVVKJ3R
         zuDjaiUog5CPbXZNm7bc4iExg2WtLSJ+agWB/NhVwpyU03YSkUDjl+o7dhFSfzKqhrKu
         MsMJZI3tmXOBXcM1q8l9YVic2VGp3tykt0IHKoc6XvdYJ5mQzII4ELn9oecsnI+kOkwB
         P0gQ==
X-Forwarded-Encrypted: i=1; AFNElJ9NDDgHPqzLu3ajZKcJLxFUfDex/iNkERktp9x6tY82J0w7VVsA1O+T6Wx5d42OGaRLV/nM5eOfGg==@kvack.org
X-Gm-Message-State: AOJu0Yx1Th0Uh+tWiXAsdQYEi/GGwwQKwfKQ/OJNPkMRrvSss8e/uRW0
	pSlOi2KpLMAqF78jVV53odJDBqLuv25BulUOb27p7MdYt8ibsrkH2G+ysH6XCDk5rIbTx+yqnMn
	0cDWvtAyIJuTTw7zfFGoESJ28oasmhOs=
X-Gm-Gg: Acq92OHwTKgw2mOSf1KBxXWWIPjBXSwoiSb/dRSCuVNEVsH2Cy168XkZ8XQc8IyDJUV
	YLky2tuNpwdr2o2y+kJENKBBS2v9PNBFBEk0lCgE2klXt13rsC6zqApOLMN0/X0krKCKs4XCyP9
	CI16ywH+UF9cwr+v95u8dWiRSy19uwFs8iJBxEvu1NJoRV31EGLYhn4oulDQ/8G7bHQ/YFvHr5S
	YgF++knNNbahuSlpyOfGOWh0Y3mIoMCuvM2fh7+YOE7BSdXyQItezOKy2cpU+g582ioBDG/sYvM
	yGu54C/RcV+Gvy5e3boParE+B1k5TV+fth2EG4BukeKxHzGP
X-Received: by 2002:a05:6820:1995:b0:694:9070:8227 with SMTP id
 006d021491bc7-69d7ec8bff2mr15238787eaf.41.1779953704035; Thu, 28 May 2026
 00:35:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260527184751.4147364-1-rppt@kernel.org> <20260527184751.4147364-3-rppt@kernel.org>
 <CA+XhMqy6NH6Nn0=jT7Js6nAe-8UbZbhpTCoP5gSBsODpAMfqnQ@mail.gmail.com> <ahfvuAdJs8zhzkTF@kernel.org>
In-Reply-To: <ahfvuAdJs8zhzkTF@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 28 May 2026 08:34:50 +0100
X-Gm-Features: AVHnY4IV-v34HI1v-nSluq0jRB9wt35Pn8XfNmVVWZdLssmaVmPa3sIuaVUKubc
Message-ID: <CA+XhMqwa+s6vFp-kRhOcVQJZJK9MLwjoVzXp4UyU5Di6DgsqeQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] userfaultfd: refuse to __mfill_atomic_pte() for
 unsupported VMAs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michael Bommarito <michael.bommarito@gmail.com>, 
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mxx8hfi8w4dm8899bc8d5mxdn5zeyi37
X-Rspamd-Queue-Id: 4D6E7C0006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779953705-760024
X-HE-Meta: U2FsdGVkX185+Uw0KZ23Qd5p8lhQV6xYIC3gACMm/Rh3DhyRcNAi/CvVAg7D4a5RdimPkyUOTicaQ5tOUv9vHq1bm11S9DG4ueUdQBz4vF3mMKj3/hhAE56cyr0cWFbGD+oncvdccNyHfvKB69cnpNZ7OjG+zCYIBK8RcM5LRAf+YhcV6Fg/iUPQef2u4R8q6bqTSpsJF4p7+d4h5JGs2UYm+vZtnHVamP8iPu7Eb/DkfNG9yYO30bQ+NJcBRVSRJjg84EbvS+AyQlGAnVsKoTRGy0icBZ2EfKNsXpU8qBqwxneIKwSPo1fxyXQQn+5i6C0zTYT+Ga2UEvlD0Ls2xWy68IvrqZaBUy343Kd2vETCv2Ef13xrD4soqVBkey40Yedi3F38XAvqT4qPu05vR5dejIOlVwPWSByl/ckUDUksDDLunHtjj4KXBvndk9MjdfAIZ+nZLMZenYYfTOOGATa5ChIam54KYZ0+giiVBzjJnFa//hPm8UXfwaIYk8YYMecuKam4YrMrNdN7oNcDaMWug9jY5Et5t++AnPuO70ojU150KFuMqohU7z2LVdIpdqFNUqy50kjPznNlUqxMWpeDiy7tsyOBsUT9mGZnyLHG1NMkGDOUXhDLG6W10y3dmShGxVgtMC6NAmI9PhuLpo7nZ5dQsPAhCBCdQn9g+M3sTffMpUX1TFpfPk7GyPmJ+aMB8YFvLCT5AQy9QRr56+Fj0Ja7oxOD4T4CIQlYKY0O6TDlAkQueVkc0wDgH+9I6BNmyj8t2karwFqhS9/jvuPhhwwJq5qeLb0CQ6s1zZuzemY23grZhmXE9GlweOGsxqKZuysN7+vUO1gAPESzxQrRD7AvNWu6wKsda1N2GPW4nOOgdu75McJFtMjxpUxUoF6I29VmI4wbw8LbE0KgxPDkyYXpEskebTyCQQJdX+tK/Y6hAdKJXYrABushboPYAUNrAmaEdrcZ30nx7Z3
 hMF18s0T
 ullTKnArMMpEdkG7fw2Hz2gKpSVQC7bUNXrrGh0mZ8JOwaF2qdcOWq5ZvuHjSpQbO975L4o2zMsV71R/v1pxNH11fX/FSUoVl8jSLWl6dSmQ9epAdNlV7VxLf/SB4OLsCcJ9+2R35qBv1FRRCoJ8aJ4/R2fHrPWJdBom4ZlWufOOfqJrjq7QeUXn/ZvyfftgZysKfY/ZNbJul8UhIPSuB/e8Oj8AanfyZLeJ6Wlabe3r19R7Zm3ZlTb2wfShTMF2ZvNFBnz6Lf4fOzqtGibUn2Dwiu9PNm7TPOxBxZp0/J1NZDyrn2mPKdNDhjthjCuI4vOVVNNm+UmNeMQJZrZ+UfUl/Nz/Vban+IB6W1yIEAHmXc8pNOO8uJj5xUBKr0vBOwkAM0RRNREYPF9zP801FA85ysY4fT9kFAMAvpcG/XfQHJ9BNpcz7rFff9LJerhMiRXbvgzHeJyTRTrRYQWsJ/5DYtaguWiiMIN/De7JEwC5U6lLtNA4JBs2y83n9NuEQVDGTppG+ZBXEsmN6Kq3x8fzl6UPWTIDj6ro8xJtTDyBBvahZBxUJQVVd7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 at 08:33, Mike Rapoport <rppt@kernel.org> wrote:
>
> On Wed, May 27, 2026 at 08:09:01PM +0100, David CARLIER wrote:
> > Hi,
> >
> > just chiming it
> >
> > On Wed, 27 May 2026 at 19:48, Mike Rapoport <rppt@kernel.org> wrote:
> > >
> > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > >
> > > __mfill_atomic_pte() unconditionally dereferences ops because there is an
> > > assumption that VMAs that can undergo mfill_* operations are vetted on
> > > registration and must have valid vm_uffd_ops.
> > >
> > > Add a guard against potential bugs and make sure __mfill_atomic_pte() bails
> > > out if ops is NULL.
> > >
> > > Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> > > Fixes: ad9ac3081332 ("userfaultfd: introduce vm_uffd_ops->alloc_folio()")
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  mm/userfaultfd.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index e5d2fb3ce2c1..2872c71bbf36 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -552,6 +552,11 @@ static int __mfill_atomic_pte(struct mfill_state *state,
> > >         struct folio *folio;
> > >         int ret;
> > >
> > > +       if (!ops) {
> > > +               VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
> >
> > nit: Is the warning message a bit too specific ? i.e. Also handle
> > MFILL_ATOMIC_ZEROPAGE case.
>
> It handles ZEROPAGE case by actually copying a zeroed page there so in a
> sense it's still a copy.
>
> Differentiating COPY and ZEROPAGE here will add complexity that is not
> justified for a message that should be never printed.
>
> > > +               return -EOPNOTSUPP;
> > > +       }
> > > +
> > >         folio = ops->alloc_folio(state->vma, state->dst_addr);
> > >         if (!folio)
> > >                 return -ENOMEM;
> > > --
> > > 2.53.0
> > >
> >
> > Cheers.
> >
>
> --
> Sincerely yours,
> Mike.

ACK.

Reviewed-by: David CARLIER <devnexen@gmail.com>

