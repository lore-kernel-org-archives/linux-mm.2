Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E85CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D338C6B00E4; Wed, 20 May 2026 12:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C969C6B00E5; Wed, 20 May 2026 12:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36F86B00E6; Wed, 20 May 2026 12:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4EE6B00E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:20:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39F0F8D1DB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:20:25 +0000 (UTC)
X-FDA: 84788310810.12.8F2AF53
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3737C18000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:20:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lw+naIJd;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=336SA/GYT1P2VucG2saRmHJSICv9pfFSfhTN5OgEmxw=;
	b=Z5NBGz6kvJw/GkktbPcdDDSlOfjpAtS8BXTM8krMudbLH3XcUJ6LscvImeeg0sOmeBljdN
	hG13JUU1lfIPFUReuLNd7R4RkQu9eHknmNCQ5mQdfSqcSWrKv9POymGwTgqBZrR8xOlclD
	WdSdbEvr4cSUmzsrDrYqWFJMjvZegJ8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lw+naIJd;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779294023; a=rsa-sha256;
	cv=pass;
	b=DUE/R9geXi0scC/fkKou2jbcuLTrw2BIOBcuHOA7g71N6DPjxXgyUYmyC4LuOG5SGzoXbX
	VVNE52x9VMzJja3jj0uPp+J+poUqUahPm2dNRxD01PLv61mPz3ztJ9MbXcd5jl0CgkGtSC
	3ZpSuF7EaAx3SAcruskr6KaQnRjXdTE=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-515548f390fso4411cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:20:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779294022; cv=none;
        d=google.com; s=arc-20240605;
        b=jPzIytqelVWengNGR8LuMbsbAG9C3qsSei4xKtYQlO0xwEEVpegs1XOmstB4Bfdfdc
         NDMM9DV/HnUS5E21zcr4ktYVbQT/RdEx9hiu1bm7MZBNe/LUpw8mX7SoCyzdXz0YpmgV
         cq88tBseJqxysCGMmVdoP+tiv/kCoK01iLnO2fOlTQAMgv4zpy7U71KmFMw9EDaKAZ/G
         hIQy9sUBq47bFTfqPHpjAFExUEPYpBdiua7f/nN05703obkqS6XnuSiRKMN+v4G0dEoY
         IN8atLrm7EGZ8nKswR5xBElhzZMRL2nu0D6GdHIh8wMttF9F9m/cdx1hI7+xKAWqIr3h
         S3Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=336SA/GYT1P2VucG2saRmHJSICv9pfFSfhTN5OgEmxw=;
        fh=BvxuJafYadGL4H9R5SMgaSqaNvdWOU8hNe0EgDSFwiY=;
        b=gtK9P/Vu5p2Kpd7OzIGWj++1DDVvQtS4VKISO/0dzDIo08y1nV+RQkwuRJo6B7tS8g
         rNAstMet6G1thAGKNqoj/Uufh90zgvNUA0xeAGYghOVG116SofcxY6TVnLCwVnnh9lZN
         HdKYoVnQl0yNEkOFF8IFlAQy7nyD0uUr3tqV1LufvNJ0P0zVbWm8SgMTmIOwGYW+9xyo
         ijaMDtLz7kLrOo615EmTf9Z6mpAXrgZCaErRCpB1LrbN/mG8f2LM3LqhcmEZfUMTmTWe
         Uq5UQwYBOr4xtXxRQZdSc4+K92m4VceURLEigqf9ucYb5kno5z28FdPKssdDWRjvYaZs
         h/EQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779294022; x=1779898822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=336SA/GYT1P2VucG2saRmHJSICv9pfFSfhTN5OgEmxw=;
        b=Lw+naIJdtQVuDXq4uOfPjsGoY6JUOUZQkrOvuhmO0MLOUYFzftJ+mNNJI2jtUMszmI
         s4ax3JhP1pqLpJ/ZwtbufVuo0Bbl0iS8dKSMruNIJRGpAiaa07M4vXbDNLRKrmj29cxW
         0JcH9z51DsYB1TIhFjaWBzBshdo8/n81vHOoOOJfkiDKdLMQcAYU8nYH/+TORVSU5DnE
         MoOR3E9RpktlgJZkmx6qUt5gvm2XKKtbp+xHO1UOheKlkZM/jD9T90W1idxwT9Ij+bEp
         b1r7tp8iL4popGn7FxT2kzPttz+QZMfOtSZaAg+nLAFuG6J7xLdzQoGt5oqNyX/3RbK8
         gIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294022; x=1779898822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=336SA/GYT1P2VucG2saRmHJSICv9pfFSfhTN5OgEmxw=;
        b=AlUj+ew2kD5+ySn2BlQ1AlF/72a5lsT6wvXVNV79c1uwHJD8VqnlecE2yIjU6JPvqT
         e8pd2h3vwiwNsyT984H6PqJXsqg5EqNBYOQ/Fv+xAATqhGMFSccn8C/N3qdlIB/RJBuG
         C5vcFjhuzUWlozr1zRzKNE8G5JjcfitDhCosWdPrkX2jRppGvnCr4p/kpwZqM80BGg7R
         xmeUMAPN5rbHn3kYPPDJR0pv5qEmiL9J6jxkWVGYzdq+HEPUVuavv41rJLDLbHNWnQKl
         Wpo8pP5gKPItj3gqlpIbmZVNYRHlNfgGS9CkraCZEF8iT2+hBCfVArMkgUYfRapqbQr8
         EFoQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DtJkxILeKxwewqnbnbVpPuy4rm2aSySvbcUb+94a3oM+DfYxajtK1px/pvFMhaEgAf9dg2XzuFQ==@kvack.org
X-Gm-Message-State: AOJu0YzSxCPFLh5nlJO7MQU21SMbl2UWNFHr4BtfLJDIbs0Weo1Zm0X0
	D84lUZE9ZxQ/8dSK6S6uQZ2pcP7wVMiWPosvVYlGjvE4c/d6XIguPFxmTDC+DA0VPCSC7hBjqYD
	0jyi5YU/iVvr/mXpaXGtXExX0Q1nXQb9pRHfpJUz4
X-Gm-Gg: Acq92OH2pkZD7q8nBqag/XrAVvnt2eAihl+wf4TkABeYro0Wn6J6WvtxGwMoY3kRMdO
	fuuXjaSKv74TmQNhqZbQomFDIkYPe8ROsJ76QhiDPh5MU7iFGVhx9BAwsmk8lbW6lL9ZZSnBoa+
	EGjsOd1+Ch7O3QUWal0mIW5dkW6F/C6eN/PeNfYZP5MGfPahepJ5eqR+wtjcyy2YqAArx8aEDR3
	cmCUjpJoFxgpN09QiRbbQKWfiqUdPvdnujA04/GCp+NdnUMkrs60XnYv3kxvPiUQG/TvAzYDGy9
	48s70BuccOzM4WlOfUVeW6L8jW0=
X-Received: by 2002:a05:622a:1ba1:b0:514:c25e:c164 with SMTP id
 d75a77b69052e-5167937f1bemr20762781cf.10.1779294021124; Wed, 20 May 2026
 09:20:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer> <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
 <ag1mk2DSJsiORaxK@lucifer> <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 20 May 2026 09:20:09 -0700
X-Gm-Features: AVHnY4LoOxiQoJQwfyBuM7QQXQEEIIq-qCobTd7La33Msde42KTqBRrMiQ1PsG0
Message-ID: <CAJuCfpHbKHjktnucBNAuRDSasHiZfFDP6xgz2dX86dX1VaJYzA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3737C18000C
X-Rspam-User: 
X-Stat-Signature: amzwmu9yeeqfdxbcqcckca38jk7314ii
X-HE-Tag: 1779294023-95347
X-HE-Meta: U2FsdGVkX1/FWgO0jTqN3eahGwGVp6rDpKzv+rOPDhq19vxkzDXTyqefdnhsWI7n+yLRtzKO6pbKzR5mDqZX8XQX9fgYsqTrt5Qd7uCUYenYxJ95RS1wnvJIkzwOl8o0ME9VaO6j91gXOVf4sjp0lK1LnEkzmV63DBvEx9/omEgA0ehlc7iimSxV6EVF+J33+Bv+oeXjbjH8gUJvJcQw92tN+v3bsuZx2SxyZCeSTrFJi6uBfynAaggh1e7+NMTmfZ1SWbX5K5EF9NRjKEjnJ6ETzHbpCVyaNmn2pgDGAGmVMmr4kGmOQ/rPKRx6LEKI1QTzgbr1Jsf6cE3uOJewtp4kIIyvQjfkreyX9XfY8+Z2s3y3Avefc5YVHuRlDxSKvmnEFNaNqy+diVurLtp1M3XZB+58BTivXVPsj4ti6nIqTnOni0cIbQpqM8N4VNCQ1pLP+yCRtVrsSwykY6QsHBuyMJ+Olqtj252QlYYHOnbWyfIIMLtW/BR4+6gLC1lJTzW13G6prw1OyoYUo4iOK2YaKnqpiZ56Mv0f3cVIFXh+A7J27mNb3dNMmCPYpVJmULuWeTUqHaUi6/YJpiGrMFICS9nSQzLKgxPvC9IUKR62eNyGvIdYn1vy/m7YzrBQGdmt+u7PTO2gXrz+jrxS5fr02R+Q1O6D+Pw+6YouYE4YxN95fnpcyHAPkSK+mcZnFj0emyfjGF0FcR44KrKpcAn09PaRe1e9uftmRMS3MOvqTrmx6y1YzJ/GVTstuH3I7G/kvCCFcbfFLwnU+pKr5Hnq+qcyvpg8o8svRYgGQuEV3+63aI5hwM7sEzdn7Zq8obDrd1o+hNB2Ph5PQhmidDEKawXtaud3pYByYuSC7MpBrqIyjAtKCoBPvLORCzdp5nMIgVSErXc0cavXUos2cLLWg4C+wzup3qa48+MfCFKfHaZBMmQr17e6zanABXz+b1VeX3MNlZL2AnKfQ8u
 Zhz66gY9
 pjgaSokBH8oiNw+cPn4K3SCQt7pnSvgGb4SZV8okLbwTLONyHlWGoD5pWp7otkJWzjCbTF2O9YODPzmPrWk2MCz/ZKNnVQlX1FKo3Lo7YsZlEPR5HD1pQzcJxKRWM0Sva9K65Egd5ARNUTv7gfpCGFHJ9omq1yw2CU3ftN4cZ/KZWmrHLeHDweUma73vyRICqZ/G5FXqEj7K2ol44NV3Nt+avX1yAA71r7S7bbyulVSf8hZ0BZ5PKQ8JMUxJ3ep9nlOAxqFjRRHO5lVSmVpXhNBSjDORm89TzEmfH4sookV5O3HlBjDr+zNGBWcX8V5JzMn9cgRM8lwx/vhDsgJddZ4Nj9VFypekH8fm46hVV3fqDkzw1OgqUPEHKuHWq8OpIRbkD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 2:07=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, May 20, 2026 at 3:50=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> =
wrote:
> >
> > On Wed, May 20, 2026 at 05:18:52AM +0800, Barry Song wrote:
> > > On Tue, May 19, 2026 at 8:53=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.o=
rg> wrote:
> > > >
> > > > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> > > >
> > > > > >
> > > > > > I think we either need to fix `fork()`, or keep the current
> > > > > > behavior of dropping the VMA lock before performing I/O.
> > > > >
> > > > > I see. So, this problem arises from the fact that we are changing=
 the
> > > > > pagefaults requiring I/O operation to hold VMA lock...
> > > > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > > > is_cow_mapping(vma->vm_flags). So, we will be blocking page fault=
s for
> > > > > anonymous and COW VMAs only while holding mmap_write_lock, preven=
ting
> > > > > any VMA modification. On the surface, that looks ok to me but I m=
ight
> > > > > be missing some corner cases. If nobody sees any obvious issues, =
I
> > > > > think it's worth a try.
> > > >
> > > > Not sure if you noticed but I did raise concerns ;)
> > > >
> > > > I wonder if you've confused the fault path and fork here, as I thin=
k Barry has
> > > > been a little unclear on that.
> > >
> > > I think I=E2=80=99ve been absolutely clear :-)
> >
> > On this point sure, I would argue less so around the fork stuff but I r=
esponded
> > on that specifically elsewhere so let's keep things moving :>)
> >
> > > We should either stick to the current behavior - drop
> > > the VMA lock before doing I/O, or change fork() so that it
> > > does not wait on vma_start_write().
> >
> > Again, as I said elsewhere, I think there might be a 3rd way possibly. =
It's a
> > big mistake to assume that there are only specific solutions to problem=
s in the
> > kernel then to present a false dichotomy.
>
> I recalled that when we discussed this part in my slides:
>
> =E2=80=98For simplicity, rather than using a whitelist mechanism for
> per-VMA retry, we could use a blacklist instead: default to
> always retry via the VMA lock, and only allow mmap_lock-based
> page-fault retry for specific cases such as
> __vmf_anon_prepare().=E2=80=99
>
> Suren mentioned introducing a FALLBACK flag. With the
> FALLBACK flag, we would retry via mmap_lock; with the RETRY
> flag, we would retry via the VMA lock.
>
> Not sure whether this could really be called a =E2=80=98third way,=E2=80=
=99
> but it seems more like a shift from a whitelist model to a
> blacklist model, without changing the fundamental design, but
> it does change where we would need to touch the source code.

I thought the conclusion of the LSFMM discussion was that this is the
direction we would take. Maybe there were followup discussions which I
missed?
This approach still drops the lock before I/O but after I/O completion
it reacquires the same per-VMA lock instead of falling back to
mmap_lock. IMO it's the simplest fix for the issue you brought up.

>
> >
> > We absolutely hear you on this being a problem and it WILL be addressed=
 one way
> > or another.
>
> Thanks. This is a bit of light in what has felt like a fairly
> dark situation. I really appreciate your thoughtful and
> responsible approach.
>
> >
> > Of the two approaches, as I said elsewhere, I prefer what you've done i=
n this
> > series to anything touching fork.
> >
> > But give me time to look through the series please (I'd also suggest RF=
C'ing
> > when it's something kinda fundamental that might generate converastion,=
 makes
> > life a bit easier on the review side :)
>
> Thanks! Sure, I=E2=80=99m happy to wait and there=E2=80=99s no urgency.
>
> Last year you made quite a significant contribution to the work
> when I tried to remove mmap_lock in madvise. I really
> appreciated it. Now we=E2=80=99re back to the same lock again, just in
> different places.
>
> Best Regards
> Barry

