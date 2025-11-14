Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B4BCE7A96
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3098E000A; Fri, 14 Nov 2025 04:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73DA8E0002; Fri, 14 Nov 2025 04:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A138E000A; Fri, 14 Nov 2025 04:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A23788E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:08:14 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 362BD1A02A5
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:08:14 +0000 (UTC)
X-FDA: 84108636108.07.F1787B5
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C13AC0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:08:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ArVZC0zv;
	spf=pass (imf22.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763111292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fk9hjlAKCp2Nkb/I2nP50EjbfMYVmooA2v6BOAwtQI8=;
	b=eOnsHdlEZMYF+itBpoa+hbhzDtItI5WnhLmPiH3bZXlOTfWZBSD14KsMw4tquF+x9P1ZfW
	7jKltJDBLqnH8S3LbtFFQUxYN25bOWkVw7fPCO2PZnEys5U3iH5XpR2JhZ6j8H6NyJVMUA
	JXP/JyctZqqrchf4+OeA+IZF2fJKtxQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763111292; a=rsa-sha256;
	cv=none;
	b=HvEC/xnIq2NYZDvjYUbnQp27nmUSf4e1ylHQhgtgOEt0bdvq+5CXt7GJw0jSshEuHHjuoL
	ra5kLLfCKn4FzS9sTWSthHBq69dtXj45AvumxvtzuPOKioQuwQWHBWIomqJBSTa9NyZGy5
	Ul+87Ieov51Qt4Q9CANp20lQ+5FFA/E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ArVZC0zv;
	spf=pass (imf22.hostedemail.com: domain of peng8420.li@gmail.com designates 209.85.167.172 as permitted sender) smtp.mailfrom=peng8420.li@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45033024e59so795932b6e.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763111291; x=1763716091; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fk9hjlAKCp2Nkb/I2nP50EjbfMYVmooA2v6BOAwtQI8=;
        b=ArVZC0zvyf2pPSdA+6wAFOzQD9kx4jnoA0zNWkbak8EfSbMzrwvFarALfKdoew+3Ul
         YYQ16fJfz1ab7okAfA+GwkWoENaa/NvA4r0Fdk7O0UshJhjkEH0UCPfpnJfl/81Avis4
         C1LMoIMuUh3IWK18uMUlWhLS9MjxC9r7GgemR+LIdrElztAbvJlOaNqZN3THJncGd81W
         LmQ69aVb58ch49KVaGgxm6rROV/cXv+K+B6egAvO0Xd9fYWhMMyzPZ/8otgc/c8U+sTt
         elkRiYVaRGM6PzSFg0LiITqfy1ezAdadpuDLKIX9jbvjXtf80sA8MLlClX1XfL6XmAUj
         kCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763111291; x=1763716091;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fk9hjlAKCp2Nkb/I2nP50EjbfMYVmooA2v6BOAwtQI8=;
        b=aDgyQTS/f6RZVig0kHr+1EnxufaUnU9klT2coUQOv7/jnssUhqvU4EM5i/3g/KqAMn
         VU99Q2XwTRGRrFJ8UpyNp9gV4Xs5V1mTaSct/0aTPhrKe+8ea4rviavxACJuHNJ0T3lj
         9gdnSmW4jKYZYZ9sD92KB7JgvdR3sAgLQNDcE8rT76E1HG7h4kI9koPh/EENLRLNtRn7
         oGAcoIJdz8rOOGcyj3KfDa2j4uXjtXu5Po7i7Jppb5QRJeU6zpa4Ehpbq/n+s0AwY7N0
         N/G8fUwnSyd61SiGhe5BLJfOC27xZsGHjnk+BjBxb7XUbL+zoHtH51My8cWyZB7Iz9qp
         dbfA==
X-Gm-Message-State: AOJu0YwaHrmut3bTl6izAJ9rMtdglowDad648Nf8EcDJDbuApEBM2zhb
	Ei+CPzfBP8pzWpsp10eJbgHrkFW4BGfHpzcjY4zij1c+pQ/HqCKETD891Fa3vwjpI3GzXDZ0YnM
	xi6C525OnfYV36kbs+1p1dCYYiF3YTD0=
X-Gm-Gg: ASbGncv5gaTtSTyUX0o0eAxqC50ROEJIiSjCQ63Rs6V6cicsMxdQia7GTWw48Ef+RMH
	pm/720McH5Xt/4vaa6/aD39hyd5/gMYgOEAQH8cve2hjDZiOW0W10gb2MzuMF6AdAt4NA75FNOS
	L/nEJtzh7vGtQeYH9HH2ME8p36s2WF2ybp0Mk3+w1eymjhca0EFrIQDqf1iLe9+U5H3zrQAX0AJ
	b3LxXDNAW3GAMtXyjQ1zmALpeFIA0CLFIKmcpn6tqspDs2jw4MsMNrlxavSykVbjeqUKf4=
X-Google-Smtp-Source: AGHT+IGFPkKomgOK8gZAZxGDjFMv0lYwO3oXF4CbVYN8PckamHP+Gm8rIRyeJ+0DujrhIZ9abKJLwqFvSPDQCbQ2c88=
X-Received: by 2002:a05:6808:4705:b0:43f:9c34:fba2 with SMTP id
 5614622812f47-450974510edmr1299342b6e.12.1763111291363; Fri, 14 Nov 2025
 01:08:11 -0800 (PST)
MIME-Version: 1.0
References: <20251114085038.191031-1-peng8420.li@gmail.com>
 <20251114085038.191031-2-peng8420.li@gmail.com> <d0da951c-914c-482a-b5e9-93657b5f7a78@kernel.org>
In-Reply-To: <d0da951c-914c-482a-b5e9-93657b5f7a78@kernel.org>
From: peng li <peng8420.li@gmail.com>
Date: Fri, 14 Nov 2025 17:08:02 +0800
X-Gm-Features: AWmQ_bmd0H8_9vQM2x_o2DVsoxdbOxPwX-8S_385b8qp3bIGwoHihvTgtmLiyWM
Message-ID: <CAJFsz5zJefLH5jCV3tZH+07ZH20oNtEY6kbGKP5QzFmhf0oTXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Fix the name of the source file for the "FOLL_WRITE"
 macro copy
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, osalvador@suse.de, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Content-Type: multipart/alternative; boundary="00000000000038a5ac06438a5604"
X-Stat-Signature: ufh3a8kcteegzb5g764ep9c6y83wyapy
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C13AC0011
X-Rspamd-Server: rspam01
X-HE-Tag: 1763111292-436003
X-HE-Meta: U2FsdGVkX1+ZTdvUteU7sXQ3s4nDt0/dykZ2BnLFYYGEHMX6raSIxbsIsJGvnM0EjouziwzbrthzOoYKWNakQkZ+gWbg42+v80FrQGjgZQrM9TCrJcWvlsXPlFwCP3LyxqC5/H6AQUq+0c5VxqFKHUsqQAqn/sP4HjBxsKQPjRC+PqkcyqOWd3YQO5M/YcKpLUPkKSmzsfnC6OkmvdSKcUTJTKDLAQpAY6w6EtVKf02u9H63s0tfXqPcs43H6L0U669uOIVJ/lS0SZsd2c5m8l0gNITzDOJwvqPS6Frba32N9OG6307x/vxFpErRF56fWoCr24aCDftzyVD92GD6PXXzvoW2nErmBU8KeMqEIMnTL5U1zgOLHEfxp/k3G1h69t6+w5MrOBLOfTPUNdopcY/jSlsIYH7LhN6OKSPrg2OEl9FtEJSHy13tjldq64kU+EKdqZX9Fq5wokwoDMW3fmdBLTBo6a5EzEbnUYG9xNxr6Ky8aUaTdiGaosK+MpiTmkuZmGeu78rEIUSZwh2w3GxVKFrAr1VZe8rUYB7q1El/5TRdPMxrljWWAZvTdcA4XCBeBD5RcbgLAeSYd2CJQV61WiQ4ufhGZni7QLlSpgVKXfyjJEsMKnr6O0D8oaH265P5naP203cM+iRNwXKPRVh3Mz63M1J4+2jArfBo19qm0uZ+10bgSC6B7SdAs3ydpiMoeM1SxaTHn7bhTroWcgayBlzPBBwlqRFCHmMToxOzNmHygdtaHRq4M7nfY527znNtg0RWZckaYex7LP319J2CGJsT0bBbcSLo9HC2c7nIFXVKhC8h3zt4u6GCbEjcUy6/UAQilh96sS/ypU/n1pOOfc1ygmx+TSJR3v7AB7N6Gu87qLbFkZe9UTnp6a9uPkdf3XRSMYOgVlqjUNwRwFKJdrFEbm9/cKH6fqOTZi6kyk0phnD41h208H5m1YsIHWVSIRGzPI73HDI6KNx
 KtVi5WWr
 iIH4UYq6YsjpE7d/TTUtaTzvf2hpgvCKJ1uTEjLvbvp7NJI+5y5ag0OAlbs/5HgrTb4oIBLNHxJ4f0uN1ZDy67MuBaigiA2vjmttztUtroh44c+3d0wew1I0cYQ0ZMHc/ZMgsQlt0XMy2mlSkhXMjDnFfpWU9QMuKHTSf1mI6LXyb+aRoliEtJm4rLKnhGEI1f3VQ0GhT7QYjGdU2kB9D/yjsVmnIEdwj3VqV77nSY+AzEloj0CGljx8PZT/BS8iWJKJ6cHgsGZwnIqYyQs7gByw+Sa4uoZKyRHhDlsVa/wZaNwk0jNUoYw/GDonvSNPyjPSwaTu9zk5VHhc7jHzODz65ZkzHYWcJ6j3HB4vzmd1jojZuRy84JkpPNNSnQYSDrHFPt54dgS9SUJsWSW9lchV02Cdu5S/d2isKiOuSgh4ZNi2c18eeRGT6/eLq6pGXG8/c0SysTOQr5eGMucEiDyx659DusC6nEYhF/RxSp7KUa6P0+auzUkwj1DFQOWo0qGU2zTaYDCTAemKmClVfC0EgJTXpuQ2NIcZyCghcr0SdhyXAe4T3YBiiis0y5L4O/d0R/73IoLHfS7uaEYnb+eRWirlab5SAKiNPrS29H8vWEGDukI+fKVBMMKsrv05UR7bz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000038a5ac06438a5604
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David

Thank you for your prompt review.
That's great. I will update it in the next version.


Thanks&Cheers


David Hildenbrand (Red Hat) <david@kernel.org> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8814=E6=97=A5=E5=91=A8=E4=BA=94 16:57=E5=86=99=E9=81=93=EF=BC=9A

> On 14.11.25 09:50, peng8420.li@gmail.com wrote:
> > From: "peng8420.li" <peng8420.li@gmail.com>
> >
> > The 'FOLL_RITE' of the copied source is located in mm_types. h of mm,
> not mm. h, so fix it.
> >
> > Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> > ---
> >   tools/testing/selftests/mm/gup_test.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/gup_test.c
> b/tools/testing/selftests/mm/gup_test.c
> > index 75f7134d529d..9cdcd10d3f6a 100644
> > --- a/tools/testing/selftests/mm/gup_test.c
> > +++ b/tools/testing/selftests/mm/gup_test.c
> > @@ -17,7 +17,7 @@
> >
> >   #define MB (1UL << 20)
> >
> > -/* Just the flags we need, copied from mm.h: */
> > +/* Just the flags we need, copied from mm_types.h: */
>
> Can we just avoid the exact name and say "Just the flags we need, copied
> from the kernel internals."
>
> ?
>
> --
> Cheers
>
> David
>

--00000000000038a5ac06438a5604
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><div style=3D""><span style=3D"paddi=
ng:5px 0px" class=3D"gmail-">Hi=C2=A0</span>David</div><div style=3D""><br>=
</div><div style=3D""><span style=3D"padding:5px 0px" class=3D"gmail-">Than=
k you for your prompt review.</span></div><div style=3D""><span style=3D"pa=
dding:5px 0px" class=3D"gmail-">That&#39;s great. I will update it in the n=
ext version.</span></div><div style=3D""><span style=3D"padding:5px 0px" cl=
ass=3D"gmail-"><br></span></div><div style=3D""><span style=3D"padding:5px =
0px" class=3D"gmail-"><br></span></div><div style=3D""><span style=3D"paddi=
ng:5px 0px" class=3D"gmail-">Thanks&amp;Cheers</span></div><div style=3D"">=
<span style=3D"padding:5px 0px">
</span></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr"><br></div><div dir=3D"ltr" class=3D"gmail_attr">David Hildenbr=
and (Red Hat) &lt;<a href=3D"mailto:david@kernel.org" target=3D"_blank">dav=
id@kernel.org</a>&gt; =E4=BA=8E2025=E5=B9=B411=E6=9C=8814=E6=97=A5=E5=91=A8=
=E4=BA=94 16:57=E5=86=99=E9=81=93=EF=BC=9A<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">On 14.11.25 09:50, <a href=3D"mailto:peng8420.li=
@gmail.com" target=3D"_blank">peng8420.li@gmail.com</a> wrote:<br>
&gt; From: &quot;<a href=3D"http://peng8420.li" rel=3D"noreferrer" target=
=3D"_blank">peng8420.li</a>&quot; &lt;<a href=3D"mailto:peng8420.li@gmail.c=
om" target=3D"_blank">peng8420.li@gmail.com</a>&gt;<br>
&gt; <br>
&gt; The &#39;FOLL_RITE&#39; of the copied source is located in mm_types. h=
 of mm, not mm. h, so fix it.<br>
&gt; <br>
&gt; Signed-off-by: <a href=3D"http://peng8420.li" rel=3D"noreferrer" targe=
t=3D"_blank">peng8420.li</a> &lt;<a href=3D"mailto:peng8420.li@gmail.com" t=
arget=3D"_blank">peng8420.li@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0tools/testing/selftests/mm/gup_test.c | 2 +-<br>
&gt;=C2=A0 =C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/sel=
ftests/mm/gup_test.c<br>
&gt; index 75f7134d529d..9cdcd10d3f6a 100644<br>
&gt; --- a/tools/testing/selftests/mm/gup_test.c<br>
&gt; +++ b/tools/testing/selftests/mm/gup_test.c<br>
&gt; @@ -17,7 +17,7 @@<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0#define MB (1UL &lt;&lt; 20)<br>
&gt;=C2=A0 =C2=A0<br>
&gt; -/* Just the flags we need, copied from mm.h: */<br>
&gt; +/* Just the flags we need, copied from mm_types.h: */<br>
<br>
Can we just avoid the exact name and say &quot;Just the flags we need, copi=
ed <br>
from the kernel internals.&quot;<br>
<br>
?<br>
<br>
-- <br>
Cheers<br>
<br>
David<br>
</blockquote></div></div>
</div>

--00000000000038a5ac06438a5604--

