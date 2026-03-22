Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC55FC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 14:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9056B0095; Sun, 22 Mar 2026 10:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6599C6B00AA; Sun, 22 Mar 2026 10:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5485E6B00AB; Sun, 22 Mar 2026 10:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 429AC6B0095
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 10:24:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F94313BBBF
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:24:07 +0000 (UTC)
X-FDA: 84573918534.03.2ACED58
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6ED3D1C0007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:24:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WZ6pV45w;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774189445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WIm13W/e8I2NA09hKHU/48NVk5PZByL/Ku7MiuA4QI=;
	b=knJquZ7SBfmc287jJuS1thqeFiLA8JZRwvHUj+oFM2SsTYfyAmuVbKt6C8k5Yfr7qEBhBe
	30a+f8FA3C70d+pZt5ZIxNzawVJN2dAqusEpDbUQU+tOtbyDUwJGG8KCVjfg45OeYSqDWL
	rx4obdqt6O5VwUhWVTMyJ/fucGSIC5U=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WZ6pV45w;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774189445; a=rsa-sha256;
	cv=pass;
	b=W5HH6hOO5zWmBkUU8+QfH6S5fpXcowKg25bsl7ccBj+HrPJ5nY1NiNFcdk1gNmNZR6zsL5
	7RCZDxX1Wi03bgDNALdnOw37tb2wKdcz037Yb05zMCOLp2Z+7BmJswP5iMx0C5tg/Cvwlh
	gvPb2uewCtV2Lzf8u9EohzxoISDYxjs=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6694c9c02c5so1564013a12.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:24:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774189444; cv=none;
        d=google.com; s=arc-20240605;
        b=PmQ0vIuqsaIWfFnVR9FuIMc1RjiuOfSJxpX6nnGUM+bm6S6O1hiHLaba0C1iUV8VNd
         Fy5TU5ghP0hZnCFChTI6KXxR9UG9Aq1+cTfOpjAoQwc2sDx4EmUVTdVL274JuzBXrg7j
         cGxiw6w/49RvONOyDcQOZOpkWbCps7k7wD6V21NEEW3109uUwpWOe5cIiGfss9TpzfwU
         87ULDNTiWP0JJ6kLyS9cpDFqrxJnOxACpaqmU8Qzz5/fWS/d027LLXXVTxdYPupLQsw1
         WlMSCI7HV72YJLRiGQobZdBcbC/iNKWYYe1KZlq/QuFxXQ9znJFTbzQWEnIjZVMN/shg
         Rtbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1WIm13W/e8I2NA09hKHU/48NVk5PZByL/Ku7MiuA4QI=;
        fh=Hp5n3BiRgu29wclnleWXbf9+cPxjmFeWD8HZ/z5U8VA=;
        b=Hw93QSDILODwmMRvfmsqV3DKDvIhyi3O9465zQrIMgDDcQ/8bApTxVGnjxYAkk15HK
         UBH9IvsfKy65lTJ4NqJB8IYYdv5kZNkwOR7M5JJODA9QqDozqYBKz04JGj9VGtO25LPI
         /IYn2XpFaxOJw5mcQAZd+trgj7eFcPIM8XTbEucVPLfATfaMzLzSCuDyHZoiai6pZqCi
         NmQVfYK8eCoIwVycOOHA62KJMPDOSE7OxhAxRUZVA2v87Q+9jcGTyGTA4mj5dod7Zgk3
         5f6S6G9w0ermIXMgfWKNfI8AMl5lTk4vlA3vk4aYJ8crlII8K2gxMQwbqZYz5NeX5HGQ
         qOUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774189444; x=1774794244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1WIm13W/e8I2NA09hKHU/48NVk5PZByL/Ku7MiuA4QI=;
        b=WZ6pV45wbJYjMOU6yHaKhrShcS41D4nwGH/cfOSpNBwYSTsWfW5v3sMac/JScTmJbu
         GE3ja05Q3NUlPozK72FneCdTGiSvGZrhzMo1qWjot9qHe0H8Ey8hu7qnQXE/DonSDCCb
         HfYNYYynu+Q6HKcJXj7gDEicooeqt3QOtJ0mNvRJJmrXMoGnesL6fDBpeCZVxsFdb09w
         3sXL0aY5mvpjN6CqgDdVNl67vXO3TIuhYeJsEsi17qtw413iBxK7nT4tPssyCErGD4Yg
         GNy+XT3SBcQlkb2I0vUVVatjaBCSMSfNCdhKppdpI6ndGEtO09pVJEyj5tpV3zkgoLmL
         I4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774189444; x=1774794244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1WIm13W/e8I2NA09hKHU/48NVk5PZByL/Ku7MiuA4QI=;
        b=E+mEgYHSMC77ax5Q62VHzao77bSKEvZyfNkfaD96rWHUaytnYYDiblZllQ9Ds4xNy7
         PP72FiK6g9hN1/BnewEr9sHwY3xEdmU3NimjQrioUyY04FtH0Ua/HgZvyHh2SlrJKKCm
         O4n6p90wJgpU6Xnqrco8RmQlrusA6eJZSbUq/IhY2etpCsvD27hrG/Mjy6Dh1WUSG6U/
         l1LA2zqn42HIPJDCORS842+53QOuDu4qY9KEwcWeEkfdxnk0/FtgO8LqyTzs7712o7rq
         3tngk7sScn7DN0gC0mz0yo6NznAkQoR4k1lUKxzzbq7WJSIbPbcn3zcehdwniaafMYRq
         PXVw==
X-Forwarded-Encrypted: i=1; AJvYcCXW/zDDKKiwTYHLAD5rg5gLFiUI1zT+DSWPmHrXjc5evzniZksp4tRe8V5d0TurbkgHlnw5Jhp8WA==@kvack.org
X-Gm-Message-State: AOJu0YzTIE1OyN0je4+C6lXWU/OxCGLfJ7zUlgfAqX5bd9eoBy/PnFaV
	PfmEVpXjSaqPmopfingnrgzmvjTAvxwxtSDcT8w2MRyruhe6XIU8T6XQkEUMxf0amvir2L21r74
	EZv5cfAFN/Xnuww0JPIYAyG8CMK1l82/nGTG6w8X2gw==
X-Gm-Gg: ATEYQzxgVxCedTApI2NrTf0w4sExljciA0UiNwXxUVKtvgpxZu0FofcIIloLemiS4vM
	ySDtpjUMdDKIzg1IU5ceQ7y91laL6gfJS3343KmJ72h2hC60HPq+meUsdlVKQCObe+f+MA2v2eQ
	yG2knNjrOtZ6c3QKvlxQ8l8nr96PN3r3mKH6oO1J7Q88Fi39DBN92eIfX1BG6yNJ1a2W7/im3V9
	k3Z2BAVEB/e4kMU+z1oVPcFPYYQiICzUXldLRE7mrlYOCTinnCIscaivC5Utg03RVCpbufIV7yg
	uaD0TFsnBUJbmkg3aj/25ElGFEgIwczu7OI1ew==
X-Received: by 2002:a05:6402:40c9:b0:668:6e22:3df8 with SMTP id
 4fb4d7f45d1cf-668c9100c57mr6732911a12.2.1774189443511; Sun, 22 Mar 2026
 07:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-11-pasha.tatashin@soleen.com> <ab_rAg80Fjp8N5A5@kernel.org>
In-Reply-To: <ab_rAg80Fjp8N5A5@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 22 Mar 2026 10:23:27 -0400
X-Gm-Features: AQROBzDqxFHyPyFoA0pvf3xnSsBngMFhdgX8PnnGK6N4Ll82QB4tOI5WqGlcosU
Message-ID: <CA+CK2bBJwpzHk_JAuyed9Kchdqga=2FNpiDVppJEGudS6PX1_w@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] liveupdate: Protect file handler list with rwsem
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6ED3D1C0007
X-Stat-Signature: pgtrbi94fpsabhx8rmrpzi6mfoq7mr44
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774189445-247834
X-HE-Meta: U2FsdGVkX19LeY0jBS4sdagIntVsU8VgyPiwxYm/IPslrQsE0F2Ff8mhicjEDB0M0dOvonDM1/6uHfETEP+WaBjw876vONQ9gHUFqHDihrqCpyIGOdXsZyQAL8BT16DTOKA508nLJevnngybR4did29vjRFNCeuGeqkCuWSUt0dznxVddm4IYvmMHI1UJGR4H++lgiUQxpXb8eJqGVoRAh1Dn6SwYQ1asqV3LB2vzXYgahHDN57eP8sVhWRZ+PTGgs9NFjxWr7o88BUUsxvDOrw23aXGhmbfdZZvWMbzzfZrpkWQaZEfdFBS74dc7bTZAs8P5qAseA8M5f2vusER/fH3pDpz+dEcYtEKHgtXzmoDzqOgUYJV+bsbx98qALAEX560p3CEhhJNAwchJ9LTZOuoT2QAf91juaud9dJMvnnJlnZPljByvJzvpJ+qVc+plULtW7oE+B760zZ2EUcZsptJm64vtELrH/4mFHWqyxgBZcgfRBIzZHtWuhQofzJqp3VmDMQGdibl05fpcn/8jlFYkFG4KUMKTU6Z0bRN0efPAl/tTfja3K1YN2vA/noDmUyXirL0564uB0UI84GHand1Hul8m6DDw5l9VMmvnFTeTLLT8KVzg5/wbzSibm2Kl2Ze+ngEBzTJxiHKf75CHtRDeBx7e5VVLjo0WOTT/KMTAsk/I/cHyvYmcxRWlq/fZZl1p1RGh8YLLACmc+y4Lx72KS2Fq08fDJqMMleamfa05nz7kIOa6q7cQ1OZ8Tk3xqNF4S/QUdjJ6Ufh5rdunNBbJDFy+upuzpd0j1vy8WQ73svodPQJGXg/2HhDxLdhnEIJ93HyeHAI/h31XcIsBy/kZpf3KCiZ2Wr//VbpHUN4UtsNnLzPl+U9QXMlcio63tObvamfRex5TnhMpFmoeNV7tqdhHVuYqnQ1zjXn0zS4Qdg1oALIap3zSEKtkA0ddQ8wkrXbVovsxCdvU61
 VvBl2qI+
 M+Eqkm2GA2Of+yyfpOKcu0x1nGgPxfq93lne6CZvbvUvPc7kOKutWfaQqD0iu1RHYm5AitYLmUznF5Fv3+YVuP06XvAHx24Ab1N1FBpBRCXuEC6GYypRbuiaisgGtWACKZGhvS28BThFs3+YE76bL2pnDMN0zQe3qFmnVGQpVcvhRUfgk5kYQlwmdNCAHDK45RDJrHpDr8aWBPI0ranlrACpmXOl6S+vtFD1xZICbB7jW7IIt63gOmqzzk7AwW7EuI9nXqiyM4ShzbLo1tBIUpTrYCmrHssnu5FKhPViNO68rn8cfrUYdfozceWLjSSm0qnTXZBQmjh920bCQiIT1BfgfbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 9:13=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Pasha,
>
> On Wed, Mar 18, 2026 at 10:16:39AM -0400, Pasha Tatashin wrote:
> > Because liveupdate file handlers will no longer hold a
> > module reference when registered, we must ensure that the access to
> > the handler list is protected against concurrent module unloading.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_file.c | 61 +++++++++++++++++++++---------------
> >  1 file changed, 35 insertions(+), 26 deletions(-)
> >
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index 5acee4174bf0..6a0ae29c6a24 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -112,6 +112,7 @@
> >  #include <linux/string.h>
> >  #include "luo_internal.h"
> >
> > +static DECLARE_RWSEM(luo_file_handler_lock);
> >  static LIST_HEAD(luo_file_handler_list);
> >
> >  /* 2 4K pages, give space for 128 files per file_set */
> > @@ -277,10 +278,12 @@ int luo_preserve_file(struct luo_file_set *file_s=
et, u64 token, int fd)
> >               goto  err_fput;
> >
> >       err =3D -ENOENT;
> > -     list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> > -             if (fh->ops->can_preserve(fh, file)) {
> > -                     err =3D 0;
> > -                     break;
> > +     scoped_guard(rwsem_read, &luo_file_handler_lock) {
>
> I'm not sure scoped_guard() here is better that lock before the loop and
> unlock after. scoped_guard() would be useful if we were returning from th=
e
> guarded scope.
>
> > +             list_private_for_each_entry(fh, &luo_file_handler_list, l=
ist) {
> > +                     if (fh->ops->can_preserve(fh, file)) {
> > +                             err =3D 0;
> > +                             break;
> > +                     }
> >               }
> >       }
> >
> > @@ -777,10 +780,12 @@ int luo_file_deserialize(struct luo_file_set *fil=
e_set,
> >               bool handler_found =3D false;
> >               struct luo_file *luo_file;
> >
> > -             list_private_for_each_entry(fh, &luo_file_handler_list, l=
ist) {
> > -                     if (!strcmp(fh->compatible, file_ser[i].compatibl=
e)) {
> > -                             handler_found =3D true;
> > -                             break;
> > +             scoped_guard(rwsem_read, &luo_file_handler_lock) {
> > +                     list_private_for_each_entry(fh, &luo_file_handler=
_list, list) {
> > +                             if (!strcmp(fh->compatible, file_ser[i].c=
ompatible)) {
> > +                                     handler_found =3D true;
> > +                                     break;
> > +                             }
>
> Ditto.
>
> >                       }
> >               }
> >
> > @@ -850,25 +855,27 @@ int liveupdate_register_file_handler(struct liveu=
pdate_file_handler *fh)
> >       if (!luo_session_quiesce())
> >               return -EBUSY;
> >
> > -     /* Check for duplicate compatible strings */
> > -     list_private_for_each_entry(fh_iter, &luo_file_handler_list, list=
) {
> > -             if (!strcmp(fh_iter->compatible, fh->compatible)) {
> > -                     pr_err("File handler registration failed: Compati=
ble string '%s' already registered.\n",
> > -                            fh->compatible);
> > -                     err =3D -EEXIST;
> > +     scoped_guard(rwsem_write, &luo_file_handler_lock) {
> > +             /* Check for duplicate compatible strings */
> > +             list_private_for_each_entry(fh_iter, &luo_file_handler_li=
st, list) {
> > +                     if (!strcmp(fh_iter->compatible, fh->compatible))=
 {
> > +                             pr_err("File handler registration failed:=
 Compatible string '%s' already registered.\n",
> > +                                    fh->compatible);
> > +                             err =3D -EEXIST;
> > +                             goto err_resume;
>
> PeterZ advised against mixing guards() with goto, but unfortunately I can=
't
> find lore link right now.

Yeah, I was looking into this yesterday:
https://lore.kernel.org/all/CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfj=
aRZQ@mail.gmail.com

Also, please wait for the next version before reviewing it. I am going
to use what Sami suggested:
https://lore.kernel.org/all/CA+CK2bDONAnry0n9qOsR7GSDTw4Xw3g4ZugRPwXD+NdMx7=
rpsQ@mail.gmail.com

Pasha

>
> > +                     }
> > +             }
> > +
>
> --
> Sincerely yours,
> Mike.

