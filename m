Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63BE109B491
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5597E6B008C; Tue, 31 Mar 2026 11:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A316B0095; Tue, 31 Mar 2026 11:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1B86B0096; Tue, 31 Mar 2026 11:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 298F16B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:37:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7A3D1601A3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:37:24 +0000 (UTC)
X-FDA: 84606762408.25.79373A2
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C086A0018
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:37:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IU8eXk2n;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774971442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKbaIn/Erm/OKC3BYhqOYCRieKJ7mZWnRM71s1E5vDo=;
	b=e5g8ODaX9p0jya74Tw2eUX7uNpU3Qp1k5iAavuSqkWEZ2dg5Xs/GeORWEcWb7fUJY0AaBQ
	PqExdYdi9VnBSKhD1ibt2tobbjJ9lzmAlerX7IsGGjG4r5Ca1XD0/FJ8hKPxjoFDIwfcs0
	NIGYZv8BqfpirX+J2HNFaShOpwnMehc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774971442; a=rsa-sha256;
	cv=pass;
	b=iQCEoszf6/cMMokYQaqfR5ogKufPqk9gHMmnEQUpR5T4ecE4poTgVtUJyLVx7uXW4mXeWQ
	q1f/KFszmRm+sFm0eMAjDX1z/1SwNj3ETjRN9f4ku6AbeKkVJhbAss2wnAoZ1OGuGBCIdM
	hqJ/qrKcOkBOGNhhxKQ+UpyHiy6uSRQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IU8eXk2n;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-66bb7118c96so14083a12.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:37:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774971441; cv=none;
        d=google.com; s=arc-20240605;
        b=i3y66RMdLfRDGzQ9yXYgbIITS1GepT+Uizaax0a4vkNI/2FMRUZM/JsFUNgq2eGFB6
         1pO37F+DWxwgfNNoGCjL4oC6dLt75kGQFEvYCNC9F07JlLJ9MCd2doPnCb2M4UuwumqV
         M1C/pGMqK1h/QDQq3u0ND9vIAU9h/RW+YyR8wUqSGd6pKmm50XHTJubCTZ0WBJpJwI0c
         98omAHGpv+EQWda+r+3GmJiw62sIgk8SHByYZ5RMQUeHAYVznGBd30wS3ed/HXa5uXKW
         5MSPQHXZ1MFRiPNpNuV034jlUlIsd1guEYCYINloy9alS+fa3ndpJ0Mv51KR4C/O/iIo
         PQEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MKbaIn/Erm/OKC3BYhqOYCRieKJ7mZWnRM71s1E5vDo=;
        fh=zP8zJE5aEXiq4KQekB2hi5YtL7afdQcEeStXOHYjeqk=;
        b=H8wqho3Pa90RyS0co87Jda3dTWrA0uPNxNYuetoCOoRivZEH54CJNWmH8l6tZk4Owa
         zApPUzhDLOHHFp6XR5mtgJdwHSG9WtMDpx9e0GvXl5A5M8G8tahOP3dVzY7ShPbSaq1r
         Sfh2bEmtZhC1MYoWgqC08szXsE8StHI7ur+9mCjC96CyysNsFvMTuF5Y5KioGN7TqWG6
         ytciFV+pFljbafp42NgWIYZCQYJh+dZ9tca3pFs8OSnq7enftGqJo/uQIBdda4rZt80S
         SrZfCGWqo2+hmjZF6xJgl3RI0q0QIKRy518dZ9oBqRaEtd39xd7Ztvt8QGQIkD7ijNAB
         L5Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774971441; x=1775576241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKbaIn/Erm/OKC3BYhqOYCRieKJ7mZWnRM71s1E5vDo=;
        b=IU8eXk2n03g9TfWyyNuwTOgzVeBIy0JDH6n36FVIQw8kyxZjts1w+uBbdy+kwaKcsl
         6MtX+nM2za5EYP6gq25gjBUM76hqjF82iBcx4jbaDKk6CIYhSn9KSLJEOGgiqh2O4EyW
         12fFr7n1iPn2MTijfSSppYjT0VIzoT4lr3aY/c0aCpBThgCXeXRtOTaMAUNwu9JrVf9x
         RjkRSDPLOwKSQuY8ZL9wXp4rZvlOaOVxEY3SuowL4lhugRUccGXXaSV3xfG6cSpqRxE0
         RyyU27BPVNNplRIQB3QT87bsoMFhKbnqbsy0Ljl+NeQzafLADW2+d6TnWQyYBRMsEv7d
         0O1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774971441; x=1775576241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MKbaIn/Erm/OKC3BYhqOYCRieKJ7mZWnRM71s1E5vDo=;
        b=ItLgm9f97LJ+GiMZuM960apfsKtINK8OmUaHn2hv6s4CDHG903sFnFvjPejG0oJZfJ
         lLvjxph5nWEsdFC0loXH9qT40YRQkcVX4k/2N6tOgx/RIMN9t/gaej6cRgsga769oHjO
         zuC4OxZR0DRay+Cd3NLbD/xmP7XzKbMaO+E2707B6oKA7rJ3qwvPNmhVuD+7RpkcuktN
         GDI9aCsf8rqXmz0xTXjJgwZeHQUtvE408AnenrXQjFkyOZfbtmyUJMDWRPVY7oOtDYew
         /KkxnS5zOY8TXJIkrglLEPbxOQXWAUC73aiPG9T9LsxTcFQVoqv1FL3ByTNwZiy4697M
         Lvqg==
X-Forwarded-Encrypted: i=1; AJvYcCXjXRdqoOHPDl7vP+zfEUVz8I1RFkw57FgNb7wikhJZyJLATyeXwk9wKZ/kGHEaAEjn1pDsPtqcqQ==@kvack.org
X-Gm-Message-State: AOJu0YzDgZVZdklJjdfaCrLdSdQRNbLmQbhiOu17hLUrqw0SJq1LuOC4
	EFfnmZbgA1Bh4PsapkOYi5lngTlWtMD0H2g6Gjkp5joMMo/pw6MNVvmxD5TyZLaMkBXXPFQJp1Y
	5J1wwz5B5FO02KvuyxGwc28jXQSEPYSwk3br4VLFE
X-Gm-Gg: ATEYQzxvvEmQ+zSyjKNDD11pYh7LNVPIuuzg/sRhqecnZsBxITvRhALJafhLhD18IQD
	Me8BTWkgQmG8vi1YAynP5yTGcQzgQojAk+zkllxyrYk7fBMYxx6KvkEElm9PkKpO9iJgjFk59dS
	z1kP7tzEyC467KfnGWLWLx3BbNHCeHUN5kN3UGMoifFz5E8mo6TCrg0xasE8QyPQ/XfgHMtTjVR
	L3XHJP+/GnrT3kpQT46Dedb5od97n5b0kbtWceV/Vk98j8VDyrXRBkUpa/s9m9m3/qaAelo9C59
	f2RyjrldtaWffSN7Bklhv9Tyifyl0uw8b+/Czg==
X-Received: by 2002:aa7:d889:0:b0:65a:1240:b8c4 with SMTP id
 4fb4d7f45d1cf-66d95ac7d37mr2610a12.3.1774971440376; Tue, 31 Mar 2026 08:37:20
 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327205457.604224-5-surenb@google.com>
 <e490c85f-e1e6-4722-9399-e4743549a390@lucifer.local>
In-Reply-To: <e490c85f-e1e6-4722-9399-e4743549a390@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 08:37:06 -0700
X-Gm-Features: AQROBzC2ce12XO-wrMbjKgwg4rrHJ7TFHnXAWz9ZLQknqrZfo06VAqH0Uhfwo2M
Message-ID: <CAJuCfpEOynabVz3Z2o6-KZAbE-bT49oXtR68GeS7YmCrYzC6ww@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] mm/vma: use vma_start_write_killable() in vma operations
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: g5y61m99b8w7f1n4b6qu6faqkx47he4u
X-Rspamd-Queue-Id: 7C086A0018
X-Rspam-User: 
X-HE-Tag: 1774971442-249565
X-HE-Meta: U2FsdGVkX1/vg8RvD7Gj57p/jbY/vXqw3BEyQyIbXlDU0mhlmQw2fIBu6ThrdP8OtX4zfqOd8rEDB+BwS7nvLrdOpZInOsaHqL9aVZflqYEjZfVzrL6JYlxmzUi7CNMbrjMTbitfZX1NsVKYReGVI7LNMkZdX2/yTbpvCiCS3rY49dQhTJegI/6GTpHu8F8MUt2iQ75Yt3wcDGYbmt8uFC0GUteG/RquYTMF6LFQOyHn0JrfgApFPE2ieXcuMnaRL/0Hrn3VFYtTpVS7Q9p03A6ro2HZwXTrX7GaGKUgB1+hv2Sx8aiUSh1FGfH8yFnRYPBAUfNfDtxsr7n3cuA68V9H1J2vCKg5Oq3TjiM9q2TIJrHkcrO32dtehtYrwZqalwKuv/US98KtcoItIoxphW8N08Athpqf2CVt2ZJyx3Rq5EUWRoYRBrNPCTkX5CJuBVwML98OrZA4n2YmhuiLcxa17lEG+hmDcvWlikdYek2Dzvp32F9GK1vI4vEsHhiIC/yq4YfPvLlUy8yrwKwvIKBW+qLDpykxAxAqxfineHF/nnn+h8tKX9GkPdtztUZX+tsuMTcbzxalRWw1VaL5Z7Hxy+zoY0OdcxglYtOjAZaRbVlgvfbKo4grgQzoVUO41rlxPH43t5ZQXZCBQlCXhll4Hja4CTP405o00R9UJQ8EtaY6aOqwhCZFWXds7P5lCzZJMzyx/6mAMn7Aro7pN2oPfOnezMek4PIwxyWKKuIv0v1kX7wCeFCcBT4XjDWdfBbiDkvmzMVqkxXaYXUXdAv3cDkLN/r0m1zcmgNq688I4fayUOdisRQiGzrpPyH/O6MGDOXiQjkdpIkb0QNfcdQjNFq71I/EnBBMJGk1lSVWKILpkjADCb6H+fdkK/ntOcyzwTndobODhblzomRtqY5AkeUT+2rYMtwGPESPvOiO7UY+B06fwkWgoLrxpwGQ+Q38vEIy5D9usdgYTGj
 q5BxldBS
 3rM/DnYqxwJgUnZ8FLqgSkyeFBnNqVEwWCfndv2JqiA+ScxD51tC8Rl96hMVReY1VhYumvky+cy0AC8rLm11gQ4bVHDRh2g32lbI4Vn+6AXb+WdYnM87ELTfF85JkzrznOlzqRfpYAuCx04XhSz6kR1l9hOJVyn8QDMA4qrunuv5v9aTBTsYt1aLCc47zVkE+RHxemBsWyRd17kQG1kdV/+TsAfriHys8rSEYWkSxBtW3xVFJyyRFGLwU5cs6umqpHJADpFbreARlZ5f1GhritkXnL+QYelyB2ilD4lqKVNRgFl4C0n0ylMTaVcz84Jn453Bkg+qyD8I4PGDNH75f3NLyqAv/oRb62osKU3vq+JnGi2IwrXtRNpsPHs5tkIQ/Liiz0HIYaTrJHSz/uzSZEMH6Ku1DiKM91aOLSQBJY/rVWjywqXQ1CE8kgDoarQgbg0HQkiKP3ETeV2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:24=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 27, 2026 at 01:54:55PM -0700, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable(), improving
> > reaction time to the kill signal.
> > Replace vma_start_write() calls when we operate on VMAs.
> >
> > To propagate errors from vma_merge_existing_range() and vma_expand()
> > we fake an ENOMEM error when we fail due to a pending fatal signal.
> > This is a temporary workaround. Fixing this requires some refactoring
> > and will be done separately in the future.
> >
> > In a number of places we now lock VMA earlier than before to avoid
> > doing work and undoing it later if a fatal signal is pending. This
> > is safe because the moves are happening within sections where we
> > already hold the mmap_write_lock, so the moves do not change the
> > locking order relative to other kernel locks.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  mm/vma.c      | 146 ++++++++++++++++++++++++++++++++++++++------------
> >  mm/vma_exec.c |   6 ++-
> >  2 files changed, 117 insertions(+), 35 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index ba78ab1f397a..cc382217f730 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -524,6 +524,21 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >               new->vm_pgoff +=3D ((addr - vma->vm_start) >> PAGE_SHIFT)=
;
> >       }
> >
> > +     /*
> > +      * Lock VMAs before cloning to avoid extra work if fatal signal
> > +      * is pending.
> > +      */
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             goto out_free_vma;
> > +     /*
> > +      * Locking a new detached VMA will always succeed but it's just a
> > +      * detail of the current implementation, so handle it all the sam=
e.
> > +      */
> > +     err =3D vma_start_write_killable(new);
> > +     if (err)
> > +             goto out_free_vma;
> > +
> >       err =3D -ENOMEM;
> >       vma_iter_config(vmi, new->vm_start, new->vm_end);
> >       if (vma_iter_prealloc(vmi, new))
> > @@ -543,9 +558,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >       if (new->vm_ops && new->vm_ops->open)
> >               new->vm_ops->open(new);
> >
> > -     vma_start_write(vma);
> > -     vma_start_write(new);
> > -
> >       init_vma_prep(&vp, vma);
> >       vp.insert =3D new;
> >       vma_prepare(&vp);
> > @@ -900,12 +912,22 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       }
> >
> >       /* No matter what happens, we will be adjusting middle. */
> > -     vma_start_write(middle);
> > +     err =3D vma_start_write_killable(middle);
> > +     if (err) {
> > +             /* Ensure error propagates. */
> > +             vmg->give_up_on_oom =3D false;
> > +             goto abort;
> > +     }
> >
> >       if (merge_right) {
> >               vma_flags_t next_sticky;
> >
> > -             vma_start_write(next);
> > +             err =3D vma_start_write_killable(next);
> > +             if (err) {
> > +                     /* Ensure error propagates. */
> > +                     vmg->give_up_on_oom =3D false;
> > +                     goto abort;
> > +             }
> >               vmg->target =3D next;
> >               next_sticky =3D vma_flags_and_mask(&next->flags, VMA_STIC=
KY_FLAGS);
> >               vma_flags_set_mask(&sticky_flags, next_sticky);
> > @@ -914,7 +936,12 @@ static __must_check struct vm_area_struct *vma_mer=
ge_existing_range(
> >       if (merge_left) {
> >               vma_flags_t prev_sticky;
> >
> > -             vma_start_write(prev);
> > +             err =3D vma_start_write_killable(prev);
> > +             if (err) {
> > +                     /* Ensure error propagates. */
> > +                     vmg->give_up_on_oom =3D false;
> > +                     goto abort;
> > +             }
> >               vmg->target =3D prev;
> >
> >               prev_sticky =3D vma_flags_and_mask(&prev->flags, VMA_STIC=
KY_FLAGS);
> > @@ -1170,10 +1197,18 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       vma_flags_t sticky_flags =3D
> >               vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
> >       vma_flags_t target_sticky;
> > -     int err =3D 0;
> > +     int err;
> >
> >       mmap_assert_write_locked(vmg->mm);
> > -     vma_start_write(target);
> > +     err =3D vma_start_write_killable(target);
> > +     if (err) {
> > +             /*
> > +              * Override VMA_MERGE_NOMERGE to prevent callers from
> > +              * falling back to a new VMA allocation.
> > +              */
> > +             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +             return err;
> > +     }
> >
> >       target_sticky =3D vma_flags_and_mask(&target->flags, VMA_STICKY_F=
LAGS);
> >
> > @@ -1201,6 +1236,19 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> >       if (remove_next) {
> > +             /*
> > +              * Lock the VMA early to avoid extra work if fatal signal
> > +              * is pending.
> > +              */
> > +             err =3D vma_start_write_killable(next);
> > +             if (err) {
> > +                     /*
> > +                      * Override VMA_MERGE_NOMERGE to prevent callers =
from
> > +                      * falling back to a new VMA allocation.
> > +                      */
>
> I don't think we need huge, duplicated comments everywhere.
>
> I don't like us effectively lying about an OOM.
>
> Here's what I said on v4:
>
> https://lore.kernel.org/all/9845b243-1984-4d74-9feb-d9d28757fba6@lucifer.=
local/
>
>         I think we need to update vma_modify():
>
>                 /* First, try to merge. */
>                 merged =3D vma_merge_existing_range(vmg);
>                 if (merged)
>                         return merged;
>                 if (vmg_nomem(vmg))
>                         return ERR_PTR(-ENOMEM);
>         +       if (fatal_signal_pending(current))
>         +               return -EINTR;
>
> OK I see you replied:
>
>         We need to be careful here. I think there are cases when vma is
>         modified from a context of a different process, for example in
>         process_madvise(). fatal_signal_pending(current) would yield inco=
rrect
>         result because vma->vm_mm is not the same as current->mm.
>
> Sorry missed that.
>
> That's utterly horrible, yes.
>
> I'm sorry but I think this series then is going to have to wait for me to=
 rework
> this code, unfortunately.
>
> I can't really stand you returning a fake error code it's too confusing.
>
> I guess I'll have to go do that as a priority then and maybe queue it up =
so it's
> kinda ready for 7.2.
>
> In any case I said in reply to the cover, I think this series is going to=
 have
> to wait for next cycle (i.e. 7.2), sorry. Just too many functional change=
s in
> this revision.

Sounds reasonable. I'm not a fan of faking the error code myself, so
hopefully, this change becomes much simpler after your rework.

>
> > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +                     return err;
> > +             }
> >               err =3D dup_anon_vma(target, next, &anon_dup);
> >               if (err)
> >                       return err;
> > @@ -1214,7 +1262,6 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       if (remove_next) {
> >               vma_flags_t next_sticky;
> >
> > -             vma_start_write(next);
> >               vmg->__remove_next =3D true;
> >
> >               next_sticky =3D vma_flags_and_mask(&next->flags, VMA_STIC=
KY_FLAGS);
> > @@ -1252,9 +1299,14 @@ int vma_shrink(struct vma_iterator *vmi, struct =
vm_area_struct *vma,
> >              unsigned long start, unsigned long end, pgoff_t pgoff)
> >  {
> >       struct vma_prepare vp;
> > +     int err;
> >
> >       WARN_ON((vma->vm_start !=3D start) && (vma->vm_end !=3D end));
> >
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             return err;
> > +
> >       if (vma->vm_start < start)
> >               vma_iter_config(vmi, vma->vm_start, start);
> >       else
> > @@ -1263,8 +1315,6 @@ int vma_shrink(struct vma_iterator *vmi, struct v=
m_area_struct *vma,
> >       if (vma_iter_prealloc(vmi, NULL))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > -
> >       init_vma_prep(&vp, vma);
> >       vma_prepare(&vp);
> >       vma_adjust_trans_huge(vma, start, end, NULL);
> > @@ -1453,7 +1503,9 @@ static int vms_gather_munmap_vmas(struct vma_munm=
ap_struct *vms,
> >                       if (error)
> >                               goto end_split_failed;
> >               }
> > -             vma_start_write(next);
> > +             error =3D vma_start_write_killable(next);
> > +             if (error)
> > +                     goto munmap_gather_failed;
> >               mas_set(mas_detach, vms->vma_count++);
> >               error =3D mas_store_gfp(mas_detach, next, GFP_KERNEL);
> >               if (error)
> > @@ -1848,12 +1900,16 @@ static void vma_link_file(struct vm_area_struct=
 *vma, bool hold_rmap_lock)
> >  static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> >       VMA_ITERATOR(vmi, mm, 0);
> > +     int err;
> > +
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             return err;
> >
> >       vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
> >       if (vma_iter_prealloc(&vmi, vma))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> >       vma_iter_store_new(&vmi, vma);
> >       vma_link_file(vma, /* hold_rmap_lock=3D */false);
> >       mm->map_count++;
> > @@ -2239,9 +2295,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >        * is reached.
> >        */
> >       for_each_vma(vmi, vma) {
> > -             if (signal_pending(current))
> > +             if (signal_pending(current) || vma_start_write_killable(v=
ma))
> >                       goto out_unlock;
> > -             vma_start_write(vma);
> >       }
> >
> >       vma_iter_init(&vmi, mm, 0);
> > @@ -2540,8 +2595,8 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap,
> >       struct mmap_action *action)
> >  {
> >       struct vma_iterator *vmi =3D map->vmi;
> > -     int error =3D 0;
> >       struct vm_area_struct *vma;
> > +     int error;
> >
> >       /*
> >        * Determine the object being mapped and call the appropriate
> > @@ -2552,6 +2607,14 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap,
> >       if (!vma)
> >               return -ENOMEM;
> >
> > +     /*
> > +      * Lock the VMA early to avoid extra work if fatal signal
> > +      * is pending.
> > +      */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_vma;
> > +
> >       vma_iter_config(vmi, map->addr, map->end);
> >       vma_set_range(vma, map->addr, map->end, map->pgoff);
> >       vma->flags =3D map->vma_flags;
> > @@ -2582,8 +2645,6 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap,
> >       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> >  #endif
> >
> > -     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > -     vma_start_write(vma);
> >       vma_iter_store_new(vmi, vma);
> >       map->mm->map_count++;
> >       vma_link_file(vma, action->hide_from_rmap_until_complete);
> > @@ -2878,6 +2939,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >                unsigned long addr, unsigned long len, vma_flags_t vma_f=
lags)
> >  {
> >       struct mm_struct *mm =3D current->mm;
> > +     int err;
> >
> >       /*
> >        * Check against address space limits by the changed size
> > @@ -2910,24 +2972,33 @@ int do_brk_flags(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
> >
> >               if (vma_merge_new_range(&vmg))
> >                       goto out;
> > -             else if (vmg_nomem(&vmg))
> > +             if (vmg_nomem(&vmg)) {
> > +                     err =3D -ENOMEM;
> >                       goto unacct_fail;
> > +             }
> >       }
> >
> >       if (vma)
> >               vma_iter_next_range(vmi);
> >       /* create a vma struct for an anonymous mapping */
> >       vma =3D vm_area_alloc(mm);
> > -     if (!vma)
> > +     if (!vma) {
> > +             err =3D -ENOMEM;
> >               goto unacct_fail;
> > +     }
> >
> >       vma_set_anonymous(vma);
> >       vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
> >       vma->flags =3D vma_flags;
> >       vma->vm_page_prot =3D vm_get_page_prot(vma_flags_to_legacy(vma_fl=
ags));
> > -     vma_start_write(vma);
> > -     if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> > +     if (vma_start_write_killable(vma)) {
> > +             err =3D -EINTR;
> > +             goto vma_lock_fail;
> > +     }
> > +     if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL)) {
> > +             err =3D -ENOMEM;
> >               goto mas_store_fail;
> > +     }
> >
> >       mm->map_count++;
> >       validate_mm(mm);
> > @@ -2942,10 +3013,11 @@ int do_brk_flags(struct vma_iterator *vmi, stru=
ct vm_area_struct *vma,
> >       return 0;
> >
> >  mas_store_fail:
> > +vma_lock_fail:
> >       vm_area_free(vma);
> >  unacct_fail:
> >       vm_unacct_memory(len >> PAGE_SHIFT);
> > -     return -ENOMEM;
> > +     return err;
> >  }
> >
> >  /**
> > @@ -3112,8 +3184,8 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *next;
> >       unsigned long gap_addr;
> > -     int error =3D 0;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> > +     int error;
> >
> >       if (!vma_test(vma, VMA_GROWSUP_BIT))
> >               return -EFAULT;
> > @@ -3149,12 +3221,14 @@ int expand_upwards(struct vm_area_struct *vma, =
unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto vma_prep_fail;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto vma_lock_fail;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3183,8 +3257,10 @@ int expand_upwards(struct vm_area_struct *vma, u=
nsigned long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > -     vma_iter_free(&vmi);
> >       validate_mm(mm);
> > +vma_lock_fail:
> > +vma_prep_fail:
> > +     vma_iter_free(&vmi);
> >       return error;
> >  }
> >  #endif /* CONFIG_STACK_GROWSUP */
> > @@ -3197,8 +3273,8 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *prev;
> > -     int error =3D 0;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> > +     int error;
> >
> >       if (!vma_test(vma, VMA_GROWSDOWN_BIT))
> >               return -EFAULT;
> > @@ -3228,12 +3304,14 @@ int expand_downwards(struct vm_area_struct *vma=
, unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto vma_prep_fail;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto vma_lock_fail;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3263,8 +3341,10 @@ int expand_downwards(struct vm_area_struct *vma,=
 unsigned long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > -     vma_iter_free(&vmi);
> >       validate_mm(mm);
> > +vma_lock_fail:
> > +vma_prep_fail:
> > +     vma_iter_free(&vmi);
> >       return error;
> >  }
> >
> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> > index 5cee8b7efa0f..8ddcc791d828 100644
> > --- a/mm/vma_exec.c
> > +++ b/mm/vma_exec.c
> > @@ -41,6 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >       struct vm_area_struct *next;
> >       struct mmu_gather tlb;
> >       PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> > +     int err;
> >
> >       BUG_ON(new_start > new_end);
> >
> > @@ -56,8 +57,9 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >        * cover the whole range: [new_start, old_end)
> >        */
> >       vmg.target =3D vma;
> > -     if (vma_expand(&vmg))
> > -             return -ENOMEM;
> > +     err =3D vma_expand(&vmg);
> > +     if (err)
> > +             return err;
> >
> >       /*
> >        * move the page tables downwards, on failure we rely on
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >

