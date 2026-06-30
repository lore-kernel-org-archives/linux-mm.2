Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB980C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D286B0123; Tue, 30 Jun 2026 08:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDB86B0125; Tue, 30 Jun 2026 08:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC986B0126; Tue, 30 Jun 2026 08:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1DE6B0123
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:51:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31AD7140492
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:09 +0000 (UTC)
X-FDA: 84936564258.06.EBC83AE
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf11.hostedemail.com (Postfix) with ESMTP id 389754000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pmFjIc62;
	spf=pass (imf11.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782823867;
	b=u/kXnr4oc2rT+Fy1QO/xzOUAxrcJAT4dLrJC2ubONsmN/CKS+pW2rvAokXxEO9In4TzZtN
	2QSypODAyELpBa/FOS9J7gsxqI+2/c5wZNDy8diGbt+cHwniy+k63pz9HQY6xEGLIB7oSL
	RGd8Q2e5yaZdxC4nbN5P2k9G7vnsBXw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mh7PVs54/IGL66hAXUYgzEKfE9b1/hD48362A18g4Ng=;
	b=3akCcJs5H+2AdcaxUfSeW+Ksb04EQH4yBTqmO8awuzdUIDWVXNWxXfhzvpkIEaXPnSAr8E
	uKqsS+CK8hpvhNmJKBms9RVJVoSmi1NcSQIeZN8n13LfOrwzHKuBgMAbJhiObH9iMMkarI
	c7Rbg4imv263RNSbUUYsKYFtOplm1eE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pmFjIc62;
	spf=pass (imf11.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb36ed873so2240729e87.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782823865; cv=none;
        d=google.com; s=arc-20260327;
        b=Lu12KZa7XVisAyG3L0wk3T+Qq5HrQdbXr3JrGtShXpuXiozcjvJGaYUk+pOLZuAzx2
         ldYhyn18Eisx7AmbzfrtIhM+sELdpTVJF18aFzRdl+XNQ0CqXatWYjU03vN4jfFLEJkR
         XEPZWjwmAOpbR/EHfP/5tpImfDpWgkvOtbkeofvA59NBlR9CB2WvdL+gWWw1q7iGMi9f
         uoX7tiIzFfJFeVYwI2GzrGkudiJ3BTGuvg+B58TbOwgj0aq5RJZDyQHSDqtyD/u54Sof
         NwVt56jqtimkEC1TA4iqlcaC1pwX5ZLo4RaeEGS2Ac5vicC6qrLLDtfvdJQEJbVa8S6J
         Kxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mh7PVs54/IGL66hAXUYgzEKfE9b1/hD48362A18g4Ng=;
        fh=9tOe94w8QCWTVRLJBBhirm/J+ZHzmwphkeoYSmrI31I=;
        b=sNpUsDPDwtmnH1qqtgzug0KB9B9FdzYy73KTQKbA+SXFeufWYOpzjZDDBrqf1ZQY0b
         X1yjv7PnqR1aD1ZTPCsBvhSkm6v66VUWw5/cFSD2kYXEBlRQZFct8eHojoHsow2F9IhC
         zmfX71mVyRW4j9T+2pDVAtzZVaEGJ/EmAzgKnf/AMxaJzut2ZNMIsskX8x95LgQew6oX
         QzGmcObAWlA9dHxFOT0ApyG80heOrRd2Io8aBLsjKaK5ewLuCf+D+0lJiOEF3xY/94lo
         0+fEvPaSt3xn6vHa2owKodTQx46KKUPE42oO1kOHZQKD6OkUSIusFS64E7J+6pFx4U1M
         lu+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782823865; x=1783428665; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mh7PVs54/IGL66hAXUYgzEKfE9b1/hD48362A18g4Ng=;
        b=pmFjIc62TOCGwFIMUXcjD/bQtGod5igNh+ZXYQpvdQtYKCq/+fOaC7ivV3Hf56m7sj
         etnO1Ng1YmpkOrpk++q0dvuBhZT7zOM24FXGm9Db1MtnKi738HpoAH3ou9cbe6Ydir6S
         q/Kw5nG7imF0aMusIaumLidO5S6/8kdi4AkKsS/9adFib93DS3L4sE38fdF3+UYskBMZ
         O9EBtRjR1dQYmU+gAgDcyxywsd59ifAH5UD0oErAcR3WF9VTbzRt3UPclozcfrV/Lxk/
         ujgTEuGv960STFx6CFYbd8OvZyvvZiFQT+f9L1raN56yyRj4whmjGddFkf/S6/X0tcle
         8zow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782823865; x=1783428665;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mh7PVs54/IGL66hAXUYgzEKfE9b1/hD48362A18g4Ng=;
        b=sXa3XuL0e0rwxQ5AgiaHXqcoLoHjzFC9jJv1fBMFzdfchOk3r468zhik5JhUi2Okaw
         Mca52S2Uc96vcg/ydVVDXRUiFzjuC4Lpvtmh+t2XnqOGbEQgECx1M69gd6ml9zMmHB9g
         FovjjSUwnY4d4OjnxeaveKRl78kIY7poxFgspyWLRJ1tCX4EP1EGIu3O5iOFHKbEaTlY
         bceETFEEUuiTaZ+AgM80p/jS2sw9UUxOaCZlnb7K485ViHNCCTGmHRci/6zyzuJkPYpb
         uET/cin9ko4X+mV5PrkLCyPDsPVQDM/EQYObxCvR+1NjUzHZq3iy9kEf573KgT7r+ARI
         hRoQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLN43h3QbdxR9An3bc5nFRwXcZeOG0Zsx4jrynSDRlYRMFRSkwF00N/OoHJkB+W5/xcmdJ5VCclg==@kvack.org
X-Gm-Message-State: AOJu0YwpRX6ns05SlAZfbazy9eBt6/EAbdXS1XfPgfs4Xro+z0HHHngh
	C4MAS86UfSdMZQMLyHZGsnQ+g+3DwZfYbPu8+iaRw2jeM54epz+IAqDIMb7AglQCLAxi3gMfSCZ
	R8gy2ee/8+canFhaMC4gsHAATWB0dKg4=
X-Gm-Gg: AfdE7cn1cyBX8xLFa49xwFQgVThbQHcLw2WPdFzdRDO1xR0Q5Nxf6ggvV7GsmIGEgZO
	URRBiMBBgaCZtwIGl8sr7AvFmkbvU653whwpxwuSC0SfIwjX0OjmCfFxwTLznZgBv1CAY4TaglM
	pTv9f1hR/KisCk0cOnLDsEFMr2VihiqvevEDUnqM+Ej3lYhszfJNJ6x76vr9V96jSEv4uqzYybO
	XGXG9p8RvntoWfWGylfUmNrmaeljLi+6+sTscBXETju4b/GwTLqzwLbVUZvrbODW6aCBltbakc8
	m3W+JC5ukYPrrChdmRT2j3EyRs+0
X-Received: by 2002:a05:6512:1557:b0:5ad:4c10:e990 with SMTP id
 2adb3069b0e04-5aebdbaf156mr585149e87.43.1782823865086; Tue, 30 Jun 2026
 05:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260629165349.4260-1-igorpetindev@gmail.com> <20260630010032.141941-1-sj@kernel.org>
In-Reply-To: <20260630010032.141941-1-sj@kernel.org>
From: IgorpetinDev <igorpetindev@gmail.com>
Date: Tue, 30 Jun 2026 15:50:53 +0300
X-Gm-Features: AVVi8CchYJgpWPXFRkA0mT0Q8LJor-HbhmtHWl7MJsNtGowl2Od5TWeWUPZfohg
Message-ID: <CAG21Q82oyQLR4fqTh3kZUMwGC2EyFpHZ=WLGwTCdvkoENbM0Ug@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
To: SJ Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000002cf8b606557807b3"
X-Rspam-User: 
X-Stat-Signature: 39tqw1336x86kxkospg1rmqyk5ewdz1p
X-Rspamd-Queue-Id: 389754000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782823867-95750
X-HE-Meta: U2FsdGVkX18IBgziclhBDdQjBgBLpqhl49E2IsOnKM1mmNYSrlPZlUEnPeojPTNAGNUS6qewENgbnDE/8793POklyt+Szn7o38kmqQXQ2X+P3lCggcj4pwKY6Ylz2A3lPKSU0Rq2FP5uQuUctbg/w05dVHSBnnxMZxY/4Xhcj1bOiqv8W/JYNv7TpcfUvkBv3is2tezBSqh14P+452UgF3pZcEmXZcOnhnSlpdCQEEQJnvvbEVXhyaWqQKeq0zDDWoTxJXLDBwcLncsBS0kTw/PqqNNZgx5AyNrkOJ3mvdgxsJN7h7U76YSozShwHTaK5+nDkB1rf08EdtEBcSYx30iH//m+mqzgej2B6tu1UJkRHTwMRiBBctQJsuLQgmJrSETPwzSLzxYopFi0U6SqFVJ3t9xhJB+qnli1ims028Vi3PLvIeEjF4WsT+STCsUIjT7iJEqrlad1E9jISNw9hieR9hqYVf40mhSiMeSnrkXPy1vDcrqoC1Z0aGfSWfoodAzd6p9EdjegJLyrEbfDZGhZy0h6I3qHRckIY87Ec13Y0ZnI5Cv4sTPRvAd1sne81YQjuR8Lh/T3byRDEc7pIZg9A1NqOXHOQKfHGMlbmnwcpAeWYC0z3MQA9lzAxGt+GXeYyhdb7InEzV2K2kAzH0ApIXowWBVsP4L2g9Zi6X+fIfSl7dZQd32jETV/WWSdT+i7xPfpc9c0fhdjf9bPD0gNebfpp91aUSqPfHvmTZihAHqGtmyeZ0kV42LbaqYSeDwYlygx9fAQJczn4zJqVqelIQh4w2uZ2/C8VxEle/lmyGv/9ttN0CGwCRMbSWvdB0NLSMNTtCD3ISBz8zd8/up2hVXppco8PBpsMnRut6GL8SQLzQZU1HF5EC6cqis/eIXnu63bEU2yTr1Sv73X5QFWtI/vJikXoaC7orQMqeyRbeNcGJIxRUz6w/Dzq/zxTU0b2ByOKExhgmZmas3
 nFPAeHIw
 KXJfa4A5BJ0isfmI4T6dZjbyZ10nQ+rhgnUxwRYj6fTZyKuSoS8emfllRbFyR1Q6KzcxlAExqwekvmvn6Szab1r0gc2yLQIPfK2En6004sdXAXmgxPDP6iTZW3+8cJT9bUH0fxV6mgoI0Fv8zX5toQmrqoXmaPlczDgM8702PnvHx7OtNNp/9Bo3Atii/al0eZTmvkrHcE9ZC+HeRPceCF0bb8TYC2bEXdut5sy0HevIj6j5CAUIlCEDmFbec1DHDodDmTeLhsKLL4uA/G/D0cfkcTjvziNtFtKT0B9x3ML3llzZ66xEcKRd3qmobKT2mvqZWmUTTiotPZogS0s/2drY+IubijfFWbHo1aM1EhCu2j/vFQvq1McbVBidNJLXUtz2hb6xdGsP5GG7kPXf/Ounb9xjcWsYIYupfWVDHk0e+g9AazpKKHdoFCGqHxxwwSqT13YbckOlKPQVXOOJT3TLTZTaN6/FwsVUfgnXCdbM3in3Xf8n2pdaZTbKirFz7whDp+TZGhY3Siww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002cf8b606557807b3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi SJ,

On Mon, 29 Jun 2026, SJ Park wrote:
> We prefer using a real name. I show you used 'Igor Putko' as your name
before.
> Any reason to change the name?

Apologies for the confusion. I recently reinstalled my OS and misconfigured
my git setup. I will revert back to 'Igor Putko' for the v2 submission.

> As Sashiko also commented, this may cause lockdep warning. Actually this
was
> added to fix it. Refer to the previous discussions [1] for more details.
>
> How about moving rcu_read_[un]lock() to the caller test code?

That makes total sense. I will move the rcu_read_lock() and
rcu_read_unlock()
calls directly into the KUnit test code in mm/damon/tests/vaddr-kunit.h to
prevent the lockdep splat.

Regarding the pre-existing high-severity issue reported by Sashiko AI about
missing check_stable_address_space(), I believe it is out of scope for this
particular cleanup and should be addressed in a separate, dedicated patch.

I will send the v2 shortly.

Thanks,
Igor

On Tue, Jun 30, 2026 at 4:00=E2=80=AFAM SJ Park <sj@kernel.org> wrote:

> On Mon, 29 Jun 2026 19:53:49 +0300 IgorpetinDev <igorpetindev@gmail.com>
> wrote:
>
> > __damon_va_three_regions() is called only by damon_va_three_regions(),
> > which already holds mmap_read_lock(). Since mmap_read_lock() is held,
> > the maple tree and VMA list are protected from concurrent changes.
> > Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.
> >
> > Signed-off-by: IgorpetinDev <igorpetindev@gmail.com>
>
> We prefer using a real name.  I show you used 'Igor Putko' as your name
> before.
> Any reason to change the name?
>
> > ---
> >  mm/damon/vaddr.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index d27147603..345b89b5d 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct
> *mm,
> >        * If this is too slow, it can be optimised to examine the maple
> >        * tree gaps.
> >        */
> > -     rcu_read_lock();
> >       for_each_vma(vmi, vma) {
> >               unsigned long gap;
> >
> > @@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_struc=
t
> *mm,
> >  next:
> >               prev =3D vma;
> >       }
> > -     rcu_read_unlock();
>
> As Sashiko also commented, this may cause lockdep warning.  Actually this
> was
> added to fix it.  Refer to the previous discussions [1] for more details.
>
> How about moving rcu_read_[un]lock() to the caller test code?
>
> [1] https://lore.kernel.org/20240904004534.1189-1-sj@kernel.org
>
>
> Thanks,
> SJ
>
> [...]
>

--0000000000002cf8b606557807b3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi SJ,<br><br>On Mon, 29 Jun 2026, SJ Park wrote:<br>&gt; =
We prefer using a real name. I show you used &#39;Igor Putko&#39; as your n=
ame before.<br>&gt; Any reason to change the name?<br><br>Apologies for the=
 confusion. I recently reinstalled my OS and misconfigured<br>my git setup.=
 I will revert back to &#39;Igor Putko&#39; for the v2 submission.<br><br>&=
gt; As Sashiko also commented, this may cause lockdep warning. Actually thi=
s was<br>&gt; added to fix it. Refer to the previous discussions [1] for mo=
re details.<br>&gt; <br>&gt; How about moving rcu_read_[un]lock() to the ca=
ller test code?<br><br>That makes total sense. I will move the rcu_read_loc=
k() and rcu_read_unlock()<br>calls directly into the KUnit test code in mm/=
damon/tests/vaddr-kunit.h to<br>prevent the lockdep splat.<br><br>Regarding=
 the pre-existing high-severity issue reported by Sashiko AI about<br>missi=
ng check_stable_address_space(), I believe it is out of scope for this<br>p=
articular cleanup and should be addressed in a separate, dedicated patch.<b=
r><br>I will send the v2 shortly.<br><br>Thanks,<br>Igor</div><br><div clas=
s=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_att=
r">On Tue, Jun 30, 2026 at 4:00=E2=80=AFAM SJ Park &lt;<a href=3D"mailto:sj=
@kernel.org">sj@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">On Mon, 29 Jun 2026 19:53:49 +0300 IgorpetinDev &=
lt;<a href=3D"mailto:igorpetindev@gmail.com" target=3D"_blank">igorpetindev=
@gmail.com</a>&gt; wrote:<br>
<br>
&gt; __damon_va_three_regions() is called only by damon_va_three_regions(),=
<br>
&gt; which already holds mmap_read_lock(). Since mmap_read_lock() is held,<=
br>
&gt; the maple tree and VMA list are protected from concurrent changes.<br>
&gt; Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.<br=
>
&gt; <br>
&gt; Signed-off-by: IgorpetinDev &lt;<a href=3D"mailto:igorpetindev@gmail.c=
om" target=3D"_blank">igorpetindev@gmail.com</a>&gt;<br>
<br>
We prefer using a real name.=C2=A0 I show you used &#39;Igor Putko&#39; as =
your name before.<br>
Any reason to change the name?<br>
<br>
&gt; ---<br>
&gt;=C2=A0 mm/damon/vaddr.c | 2 --<br>
&gt;=C2=A0 1 file changed, 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c<br>
&gt; index d27147603..345b89b5d 100644<br>
&gt; --- a/mm/damon/vaddr.c<br>
&gt; +++ b/mm/damon/vaddr.c<br>
&gt; @@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct=
 *mm,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If this is too slow, it can be optimised =
to examine the maple<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * tree gaps.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0rcu_read_lock();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0for_each_vma(vmi, vma) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long ga=
p;<br>
&gt;=C2=A0 <br>
&gt; @@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_stru=
ct *mm,<br>
&gt;=C2=A0 next:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0prev =3D vma;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0rcu_read_unlock();<br>
<br>
As Sashiko also commented, this may cause lockdep warning.=C2=A0 Actually t=
his was<br>
added to fix it.=C2=A0 Refer to the previous discussions [1] for more detai=
ls.<br>
<br>
How about moving rcu_read_[un]lock() to the caller test code?<br>
<br>
[1] <a href=3D"https://lore.kernel.org/20240904004534.1189-1-sj@kernel.org"=
 rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/2024090400453=
4.1189-1-sj@kernel.org</a><br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div>

--0000000000002cf8b606557807b3--

