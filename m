Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC272C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 15:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FDA6B035D; Sun, 16 Aug 2026 11:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47F36B035E; Sun, 16 Aug 2026 11:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D836B0361; Sun, 16 Aug 2026 11:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 730C66B035D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:43:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77AC512056A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:43:37 +0000 (UTC)
X-FDA: 85107552474.12.E33CEA9
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A602140004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:43:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H02EAfvk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786895015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eszLGtBVbElHu24iAecRxVp+VUAxqACUhqeaIpC43XU=;
	b=oUvKhrc5VgKY6mwMQhYqK/5vkAwTTIiTq/DYK8WKYavVOCRT5LAIIfcfX8WinAoo36GIGy
	snXyMHTlTOrMHUVimxvuH77N96tiy6N/cX4p0GLZi8hrCkrdmdlx25Bv/wcO/V2OV/16YN
	BmjBKUaCZtdgXPh+v5y82flOgLo1Vuk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H02EAfvk;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786895015;
	b=Zq9AHEojMD2CNikagsSjhXOF4oDCMNejnBCHaSxbzSgkm+IqNHJasgFDbB6Ump9eAH7bay
	Sz0q27D4YUdeXhwj3feOa+uVJZB/d0oLa2XS/EH5L0zUXsAlLwKNYVP4MdQ24XCrYUwXUr
	8YDHmdqWdOnbvGSQ8wHSFssUw8kbKiM=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c01c79467so583991cf.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:43:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786895014; cv=none;
        d=google.com; s=arc-20260327;
        b=ju+P6HdEGCQpI6MUQP9WulcIu/UKg3c+R7M//P22kRVwtf1gR9FbhlMx5gS8gSTJ39
         wQ88FEbf6vwR9e1iH0LGEMY6eIH5fpjJkI1QpLbVeV7aQtsefI993/vkNKouKwHtbdaq
         PE4bH2qr608Xi2ocF40KiKqN98LAQd8dXre9ypp0bY/ZJ99mR+68oF+ha1G/KxMkxG2l
         SWGZDyGNTOba7BcaQj0TQdsXDrXDahVvv+YVO2Xn1oHSINu9C9uD9g929/WAZ+4A4B2C
         vjlFkTzv1O69T5QFF7gFF/Lc3QYdIalEH9pcNii0cIEdMqoGRid8tKth7fe3zdDkA8ZV
         VJFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eszLGtBVbElHu24iAecRxVp+VUAxqACUhqeaIpC43XU=;
        fh=vP9i4GsUON0hFgOPCAtsEVMa+h504OhphXM3HbDYwaA=;
        b=cgHOIc0YHG9wfgDclu/Q0vtEjsH3rTMYVP8q4A2GCYcFVrtTPWsZwwYFtSOVp/gKxD
         wTqcrldov0zb0n5Z1G78jwwwGh1QOheJZGQYMmGE55wQsB5mnz+b4Qh6VQWks9lvMODX
         EY/1bVO4QscwezthqpZM11lIDy/YwOqEHOo1xH85c4+Rlbzta+Ro28Q/qeeGJGYJkEkG
         fzzwqIIOHKU5CxZfTSRXpDlodARUcoAf6htih/Tldbkjja5Hb5ZGHDqYQsL/KOIFhSnG
         /NBxgPscCr3PN3djKfDcPkKy7hyRW99/7LEVOhxVtxaubJNJ+10XJ/AaVMD8yXeqoi7D
         tJtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786895014; x=1787499814; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eszLGtBVbElHu24iAecRxVp+VUAxqACUhqeaIpC43XU=;
        b=H02EAfvk8vPgofwBT508KrRLcqe/pRR1SdWy8JDyA/AEbViE9R7k73ypcGBKTPmleg
         g8dNkgLuKqp+hLt0Y0DX8WuomGHkc0M2i0XwswzcS5VWSxiIAGBezgBUk1wBKPUPOy7g
         163fu69v1Ui9/ggOLrcR0mnZR2wbR2r274OyKlW+F46gD5AZmpJkeeWrHBR4jDFh/UaC
         5mfn3bXbzG4et2wW5PATkJT/zu4MkTWwqq5kXOv/3/enwHiUBibnDnQbCh1LH+JL841U
         XQtHUkUX1+jmAwnlBQBbKrWRnDv90WSeGMbDiAIWMGw2puvDUBGLk0LSmdVCoVG6yb4e
         u1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786895014; x=1787499814;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eszLGtBVbElHu24iAecRxVp+VUAxqACUhqeaIpC43XU=;
        b=qLyJHZvq3mfe/9TyjidahRemXCQlNZ2CNOsUF9y6kuW9hM2ROATn9ELA8sWIsz94EB
         hqFq77pmvOkzUXMVsmFJ6y03Ieffd7WgyqYeW8+gYaEkX8uSyYlN/jnXH3/gOaeyOwH0
         hefhMlG5LajgvOJ2KVntvQXH83W9bTOoVFzvhs/6OE1PtGAuz/ByVyNFnz/aqLD9SLdd
         R1fz+qV/E6HhiZa+Fzafe/dc11CNykwWqmEOOzt70ZGMwIi69O2jcaqli4pKDp27o8Rv
         5vi4pRhmspz8ySNWru9k5Avk7sMLxBMnhG98TIstkrKBEiZKWkuS0MzrtCoildxwLSe6
         qJxA==
X-Forwarded-Encrypted: i=1; AHgh+RohnxvaKcX4sIZqHQyb8qC3KpWRaXSSQXvWGa7jt89dq22CbWaHyR1NHAOGMavpKjoLBCoIaTgHoA==@kvack.org
X-Gm-Message-State: AOJu0YyeOkVO1hX19ZCay3Hcx/HnWIdDRGeXS/+cdVZHXYA4w+A3XSCV
	Urr9ZmEZT9ptkZ+qpW3keR2N6KcUCi0OBj8doNfRHsDH3bh6aljxB3FAu71N44lhR9IVNEgL6pa
	oB286Wtxba3++FeAyYIQsRmqn+m0CEEzXDZDpnKwZ
X-Gm-Gg: AR+sD1037djk/Chl4nacsjIu5y6bXbuMh9f7Osyai31srHZkM5UqdelobhqCuLOTt9a
	T2y/bAR0CFu0vPyo78q6CTyA4zO8RHmYnakXaiBhcNkokMmoNEgdeKLkC4Y8oaThC5p/uJhLE7w
	5TDoeG6jGFcO3NL9gnK29lxEx+EcjMcX3ZF94uHRkxlneiFQnAK51zW5RHP8phct8BYoa28nma/
	WSvsrsl0dJiVW6PI3jFWpedyZ87ia3m+QmLz2YPQzY7cVY7YOJsGVfJeZ5zHMPvTlj998zOU3Sh
	BjedBP2AiST71qgjeoo4zmSe+sKANgbh/P5o53daZNhHwempaSfomJ9Obxo=
X-Received: by 2002:a05:622a:120d:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52db093ef72mr689841cf.12.1786895013909; Sun, 16 Aug 2026
 08:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <aoF_qmSHiEgujaH5@kernel.org>
In-Reply-To: <aoF_qmSHiEgujaH5@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 16 Aug 2026 08:43:21 -0700
X-Gm-Features: AcwNN1VDuXh8rZ4PpkYixbYEWsLFpD50869I8BKKXdw6FV0iq0NQoDkOni0gQpI
Message-ID: <CAJuCfpGAU+uLDNdcJNKaAG4f0VOoe_3=BSKUC8-Ui4S1gwfDFw@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes succeeded
To: Mike Rapoport <rppt@kernel.org>
Cc: Foxie Flakey <foxieflakey@gmail.com>, akpm@linux-foundation.org, peterx@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A602140004
X-Stat-Signature: 43cdyu37btpf3q9xpna4bb5yykmnqnpa
X-Rspam-User: 
X-HE-Tag: 1786895015-918928
X-HE-Meta: U2FsdGVkX19Z/m+2u26wXqpGGd5RkA2dykbqaUs5BQYd+UeXt2pFzo1PQfhEnOV1OMdZGfIjT3T13SzxJUUKyONLEG8UvyXAWhrsaKb/dXdyhwvMhwaA1bhrUyD3BZDl8HGWP3EOnYNR5YDIy1KQyknF+Sb6z5WnFY6cOTNAY1UMGYjASv8kX480zD7BjX8r0lDwR8wXgEM0OArIzuZgyqD4+/WF/+ce8R+q+AmZ1/6Ic3QoU+pVcgQu5DmHIDGK2g4ZI8Qmms2taxcWKZQ/AANp99u6h9h2/YmHNxu4m6JZd/3EO2LIasMgRKR4j4Xi8fcUDbU1MsHEPRE0VNd6IJDXUR0CM752axJvLuLPkKs7HG2EUhLyWllqkR/6iUjd5TC80l6HDFEI0uDSl0fkSgG1JyAgMuqs9UZ9XqRAbg+aEWwNPVxKcLPnBsjqc33cxG7A7C01Hf5wAqYg2xkOTHoJsDx66V9E0l3bw27HIp93Zic9BdPYMjC2W6DuEfuWzrj9bp3OCFgNUF4B6l98TwDUSfsHJKTL3an7tSLvIVIjdZSArLBa9u7+pG9s5X39CfeEcLCjLS3XkxDmUjbHnf2Gu+HqF6CJu3GSo+TLcZTbIaHjA9n56gvL8Vt0vb1VoTy359t1S8iJuxV6Ni7biovuUp3vLC/wgukmDja2XSMeMQni5XuW5jNypRE18nZ5KF1ehS7/FQxaAtjuyo9Z+Oo8JjS0/CKNtdIl5lXJIXcsYAxfZIPiX4w9vT4I6cDqbtupM/7GyuvTYoNLgL7J03/Bh6IYPf1KveWqkHtSKaSGLRXQuabew+vYQzbtR9krXK7tZ7tjPLVIHQ2nCTsOaxAmWBKYu33ACZT5T4ogLZPzNnJyf98MmGBwUMxJaKHYb9JgjwAlAUxRDvt1QbkBwL9X9F2l838a8AgtlZRmOWDp2xnD+iR/JCFj7l+C2A/X76Oh+U86U+Ri+1W/aAd
 o5d2Hs09
 qw3wq9VeT8sBHLYJHredFZwSaYnHMkOwcPPDTm5BOxhY+IMwS/BiDks0igjHtCOE4kFGlRJWU+I/fqANjX5vbMel9aa9nSTCoR5AycLQBU0D75Mpys6WFFHdY1+c1U2XwxlCqJ1yKOpzyXy6ARptSdwjsmu8i4ZGYlHVcBr3J9xBXIk6834XXkK3NxJ+Qj3CIoA04L7FOyq9arRFkzX/r0OthJ/z18nw/M422WXR/uk2bzr3MA+F7AjnGABuczTsnzr0foABATbqr0q/+feb4SelUcQ6NUFRhccxdmv1h2KsI18w4Y9EUoV1rJY7rlfK5KcAqmwc25pQFmmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 2:15=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> (adding Suren)

Thanks Mike!

>
> On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> >
> > An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
> > when checked and it is EAGAIN, outer loop would retry again on same pag=
e
> > and succeeded but the err isn't reset so the outer loop would think nee=
d
> > to retry again so it goes back again and move pages again. On third att=
empt
> > move_pages_ptes will fail because it already moved and returns an error
> > that is not EAGAIN when outer loop checks again it sees non EAGAIN so i=
t
> > dont retry and break out of loop. When loop is terminated it did not up=
date
> > the "moved" variable from successful 2nd iteration.
> >
> > That behaviour manifested into this at userspace
> >
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                           ^     ^
> >                           \     Kernel moved this far in actuality
> >                            What is reported to userspace on struct
> >                            uffdio_move's move field
> >
> > When the previous behaviour is
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                                 ^
> >                                 Reported to user space via uffdio_move'=
s
> >                                 move field

This description left me scratching my head. If I understand the
problem correctly, the issue is that the err is not cleared after we
decided that we need to retry. If so, how about a simpler explanation:

During move_pages() operation, when move_pages_ptes() returns EAGAIN,
the error code is not cleared even after we processed it. This leads
to a successful retry but then the same pages are retried again due to
the stale error code. This time move fails because pages are already
moved, loop is terminated and move_pages() reports a failure.
Clear the error code once we processes EAGAIN.

> >
> > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for=
 present pages in MOVE")
> > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
>
> Is Foxie Flakey your real name?
> Signed-off-by should be using a known identity (sorry, no anonymous contr=
ibutions.)
>
> > ---
> >  mm/userfaultfd.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index c3adedaaf7d5..595e7e232f90 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ct=
x *ctx, unsigned long dst_start,
> >                       ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> >                                             dst_vma, src_vma, dst_addr,
> >                                             src_addr, src_end - src_add=
r, mode);
> > -                     if (ret < 0)
> > +                     if (ret < 0) {
> >                               err =3D ret;
> > -                     else
> > +                     } else {
> > +                             err =3D 0;
> >                               step_size =3D ret;
> > +                     }

This fix is wrong. It resets the err before we process it and
determine that a retry is needed.
A proper fix is to reset it later here:

if (err) {
-        if (err =3D=3D -EAGAIN)
+       if (err =3D=3D -EAGAIN) {
+              err =3D 0;
               continue;
+       }
         break;
}

> >               }
> >
> >               cond_resched();
> >
> > base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
> > --
> > 2.55.0
> >
>
> --
> Sincerely yours,
> Mike.

