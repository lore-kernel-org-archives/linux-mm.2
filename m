Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D216C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795526B009D; Tue,  7 Jul 2026 20:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746496B009F; Tue,  7 Jul 2026 20:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634DC6B00A0; Tue,  7 Jul 2026 20:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 344856B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:08:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E9F64060A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:08:42 +0000 (UTC)
X-FDA: 84963673284.07.D31AB70
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id B72F120006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:08:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LIHFxdyh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783469320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kb/xvVbvZ2c9F92U8pIkmxcQRFXF7zJtJ9eluQJqJNk=;
	b=2RBdbnouiasANgIOB0yZVetDz0yJHB1a6bm3Z56wiqTwQGD2fvYU/If2LTYDydRLZ26txD
	mHc91M/YGguSV8e/4Oh+N+oKxUIBPFu4Ag1R5MNnI9GGj3hK2ERdiZsIxJqOwdKGYnCjzf
	aK1++qZDLEHEiOZ/N9AJ5Hm8vv4Pp3M=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LIHFxdyh;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783469320;
	b=XOK4LmpTBN3eSuf4DDVd8KDLj7mST0gljsSrPqX1cGHg2iufF767zBf4u22tEJ4OGrLzI7
	xKz+b+jDkHqYxz5Ur5vr1dR2vcrgcbPM8PfSDjlCCGUxHEb7jWODHnEt2vZUjkjcwggorp
	zCuBJS87DAykSF3FIdtavklanFL7MUo=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb77b3afbso97374e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 17:08:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783469319; cv=none;
        d=google.com; s=arc-20260327;
        b=eM9BoWGS3xbRGtZ55acxcqnxImDA3+kRqf7EJgdK07OkMAvfuBNMviXINKdOnB7DiU
         586IUG8OSR9Ylh1RFsYKEkHPPYNxT66hEbYTcDCZFKRz8qg5P8M4l7U8AKqV0UlRpadZ
         SU4LA4hcUHe5xTJVSEyPgxiv2h7cBxcx1JR96+CmoiM/nMjZA/axvgUpIngVV0OtKnX1
         XS0iyy8iCsWVQcHjk7gtc8HLYJI/lxQZYindNQrQ5pQ/Op4tpCJ+eLzezWz1SWFDjN81
         Psr4l1YFxOV5gGviT7TykKqrL4fsAAA70/5q0tT1oLzk5mC/rtIs5KxFAK1Spsn1z4Pv
         mvVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kb/xvVbvZ2c9F92U8pIkmxcQRFXF7zJtJ9eluQJqJNk=;
        fh=/l3zQ3arxXaOvB5xxzLv/E6e27u3g2uewUacqfRg1ks=;
        b=oN7KkUOOAmBnaCsOoCLl4QIC+cUtOlO87B+SS4Sa7kvm6iPAXplLYrhoDycWRTYgTM
         hvsiU8ZOCK4RG4RDkXV5MzNQ37L7KJ67opkAUG06Af1Lv40js1Sx4UNnDXO0GfUaO6h5
         ezIAPpfef+Ih+deVN1yyVZdz9K2IJKupE8m7py+L+0EUhc4klnV5g8RM1WUbaapaYL4/
         XtuIB3IgX2aq1VhgLIpH80ujgmydratZ04JqduTiML09NOk0AYTnYAKtP1s05f9JftEl
         mLgBgynpFOrAo71hQU0rAhiOnlhvrNchZFhiAhI8Tc9XhONFwgvRAHJ8T0tZoU1/S6MX
         QV6Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783469319; x=1784074119; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kb/xvVbvZ2c9F92U8pIkmxcQRFXF7zJtJ9eluQJqJNk=;
        b=LIHFxdyhVdVqdJ0lxURhY7O3FXXM+pJZdZ5Xy9AOlKmILRKTY0EgbbxDPEKGVzooRf
         vtdOZpvEwC7RZZzEzMYgMZrLs8u5vA7t+KFFjMd0o4NtL3lYUThmoBeGwahEf7MFgmIK
         VrOrFpylcOvkp/ZMz0BxQ/mzfadkaMh2RVTQCGFliYuLKoA1LwWEfCXfbHlTVsguG1QE
         bb9CmI8WpIaWk/E2pEoLzCX+gCrjdxEySN2/F7197R0PEWdbrhUUGxvHUk7Un3X7GJEF
         NjvYYaPYemYZ8EBWp8Oqu9odlomWlcS3vimeeFuKHXiXuSnL900JjAwGV0ycaI9X6L/7
         D+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783469319; x=1784074119;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kb/xvVbvZ2c9F92U8pIkmxcQRFXF7zJtJ9eluQJqJNk=;
        b=ZbyvCTggOYULHfpkq8MrI1u/txgUIfW/3D/SU1BRKCZLbfsY9Z8+Gv55MBihAOSxyC
         n5bY2Jb6K1hjfSgscWhvcMnqVheeAxau2b/WMOx2UBZ2faf3G4R9KGJcslv/w5gj2K1M
         WE7DghCJQg5x/yTbEKyG/e3MYF5kBf3tXapbhx0H2VnhcOxYPv/lfhEU3EAQe+QdTzaO
         j4QvYq7jldGngHgVq2KaKJYU8OXuOMi2Z2l0zN8R6HqoUMXkQ/UKMTFq5OQJGhwUWh6e
         +i3yW7HKxj/2xSh+lOxO4rpPKuj1yWcsTQFkoqPPzR1XOpZbUhuUuaOvoxnGIc6tFZA5
         fEJA==
X-Forwarded-Encrypted: i=1; AHgh+RrWMZKUNMUP3zgA+W9fuETWmGwAI3RePgutuDJEinlNbruhBSXZIqYwnanOF+4bYW4qDo7cDtLXLQ==@kvack.org
X-Gm-Message-State: AOJu0YwGzhYQf6aU/dS0vlLuyay/q9fOoX7BwXoHrZYWkm/oPIGNUHCW
	5Ro+Pi6AQR8cMVKprpW+7siuYMLqeysuBrApLjATJYaTZk2YFJGRvTbM8CGM8jC8HjKMytDixZ0
	essjnTEiufgEFRvyi+egMwd3IkN86eWI=
X-Gm-Gg: AfdE7ck/qp+tNvNEsNdD8LMU5pipb/s4CtBSayyjihG/OtMoP5LXZbG5UN5BiRkL6Dk
	fzSIjKRpfJgUCVXBVEOnQHjf+vN3TB0GQCWRF07VDeOaVYzk9m1p8h4iFbJD7HiJRUmekM9KKs/
	I4uK/wizXLO2MEoviygk4QG6e3Too8cZT1wrLjSlFQ7NwZkNPFmoaypIEdySAUuMGh/eOZGEOAJ
	0IK+rpSROo20F+FAoQW43lM6bVxtRnXERSv1cPyJUlxDsKO2CPqRWmFNQwdzptL7BbxgnBS
X-Received: by 2002:a05:6512:8046:b0:5a8:8db6:b3d with SMTP id
 2adb3069b0e04-5b01147f555mr40151e87.24.1783469318736; Tue, 07 Jul 2026
 17:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-3-willy@infradead.org>
 <CANFS6bYc5uSSYWvwJZ4BgjzF0_bO9rkcFNvX2vVHnzWDi3kpuw@mail.gmail.com>
In-Reply-To: <CANFS6bYc5uSSYWvwJZ4BgjzF0_bO9rkcFNvX2vVHnzWDi3kpuw@mail.gmail.com>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Wed, 8 Jul 2026 09:08:27 +0900
X-Gm-Features: AVVi8CdGi_C6rE3txMZQnG-e3IT5Ry6oWBkUYMiraSxo4xYpBWUS0o-T89fKM6o
Message-ID: <CANFS6bZZN6455QLhPE=yYi5fAHMt+MuqumtW6BCg__pESLiLaQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Namjae Jeon <linkinjeon@kernel.org>, usama.arif@linux.dev, 
	lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B72F120006
X-Stat-Signature: yjmcbio8j1qqfds4539mjdcsuewymbhf
X-HE-Tag: 1783469320-123500
X-HE-Meta: U2FsdGVkX1/8Lru9wEe0DUNeNfcpmwnkjIVUo7tMQKM8l9hyQN5zLIphiE5uJ45F6wpCHKGRAUNRv8ZNSPJoHamVnjwb69R/225l0NM+GDV07ATEmlcTQVAMNG9CjSwgk4aaZ6GD6/vAjfwjKU54c3FJ7U0Ms8Q0qYop8/V7bBP3xe4oxrihanFYi9baHoQBhfn+mAbnzGVWchx3B9j2jl4jfHnU9DktcDebu/0ti/wnXCx3ppyy2I/1VviElMN+Dyj2GzPdVKH36ye3ipSMHQN3C6UOuY9dMD13THUfnqAAOr9mtKG5Ui22pCV8x6vuWqU7wMWuhrGp5bFMFwKDxQD1GU0JeosEiDK2JplV+/9LBjbNDhlpIlXgXp+myiLRVTHN56Q1oVoLz720QXZNsZ4x81L/R+OH+uAG6kOuu74kxNzIFjozOkOkZ8YxFpnS6UbK+b9eYsY8kWLHJLohbYsHwIFn4KBY2x1Oso43xpygLr4G7NCYVhGJBiaytvMIcOEMqbyZUDLc3TiwVBbohVhRziGDzVisZA9/H0xxA7y8dtIVHUmEMoGfMJK+AF5ggSq7rqCFW2ZPNgBgR39FRkiGc3swyaFsD30DLMYZdoeQrN3t3AtQaioBa7g12wmWlGI63L8RyBjw4DUikYvuz0hGlZxtdZgkK6r+wr41OzOBlRyry7Q4QG3D3RGoQUtJoKXxwoP+gq3/qYrWhi9FBjZgeNUT6/nUshTApxsD+CmAsenHKE7c9AZVija9cYCgudrsHtlwelQjoKUq4AlwzG5jGrO9dAdJEGgxELYBl0UfUIJE4dfyDEVa/o1fXjO0ywf0cn/NWeOs0tGARJuc+ysdFSm7BP/17Ynp6An4e+mlJmfAIczz3c3ZvTujVz7IW98ViolLwvTGjgTcH7v0ElaYTUdm3HMpkQSdqpgIiNV2IJfCde9gM4omqqV/CbihqLxy892xR7+4r2uzUa6
 RkjThRXi
 OCqUb63YqdzXFN250NRqNb2779wLC0wFTrkVR4zvwSu8IQRzwvrWFDCwx8ahrAF6YdLd38b5quxPljktxERWh4WHMnVZ65l68k+05DmlvS2Llh4QnJ9KTjtuIXtYw81E7ooQPF/1uPtrKGgkS5AqOThiY0Kvdju7AbYTQKOe1I9SrOfc5FbIPB4R5gLWaKPfJ2jZPDAs4j8t/RrfWC8MSaFlsVnkk5FhdQc1wn/jY7LjrtxCbwO1wjxC5kJ6g95Qb7UzAhU5uVAHd0MLAUhQNRdfiy3r3mykqT8i25a2Xsob+Diowiw7ikybmABW1Q0f3OQ4+h8SYor2OWZsIbsxCtrF1QX9rf5xMJa/54HHIguTxUjsFQMuJRo9O2vEtFlq/y/Cbe14wTLye7PIy9T1ZoEOY/KcFUa5fi2VVknwaI8c/mBeG1559rrt1ekPs3BmgfMwEiReMs4REpHsKHs5LNKjO/jg/gGMT5MSnLiquB39aClMLJgH2NVY9Vpe2T66y6uq09ZgktdbrFcAmeoQH4S8R18QfReXF58T8uLKv48YI3IHeS3DPhxXmrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

2026=EB=85=84 7=EC=9B=94 6=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 10:58, H=
yunchul Lee <hyc.lee@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Hi Matthew,
>
> 2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:06, =
Matthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> >
> > Nobody is supposed to use page->__folio_index.  Use page_offset()
> > instead, and simplify by working exclusively in loff_t instead of mixin=
g
> > up loff_t and pgoff_t.
> >
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  fs/ntfs/compress.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> > index c904858dff3d..b279f38636d6 100644
> > --- a/fs/ntfs/compress.c
> > +++ b/fs/ntfs/compress.c
> > @@ -105,13 +105,14 @@ void free_compression_buffers(void)
> >  static inline void handle_bounds_compressed_page(struct page *page,
> >                 const loff_t i_size, const s64 initialized_size)
> >  {
> > -       if ((page->__folio_index >=3D (initialized_size >> PAGE_SHIFT))=
 &&
> > -                       (initialized_size < i_size)) {
> > +       loff_t pos =3D page_offset(page);
> > +
> > +       if ((pos >=3D initialized_size) && (initialized_size < i_size))=
 {
>
> I think the following change would address the review comments for
> this patch and patch 3/6.
>

Would you mind if I continue working on this series?
I would fix the above if-condition and add Co-developed-by for my changes.

Please let me know if that's okay with you.

> if ((pos + PAGE_SIZE > initialized_size) && (initialized_size < i_size)) =
{
>
> >                 u8 *kp =3D page_address(page);
> >                 unsigned int kp_ofs;
> >
> >                 ntfs_debug("Zeroing page region outside initialized siz=
e.");
> > -               if (((s64)page->__folio_index << PAGE_SHIFT) >=3D initi=
alized_size) {
> > +               if (pos >=3D initialized_size) {
> >                         clear_page(kp);
> >                         return;
> >                 }
> > --
> > 2.47.3
> >
> >
>
>
> --
> Thanks,
> Hyunchul



--=20
Thanks,
Hyunchul

