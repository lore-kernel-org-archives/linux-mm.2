Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4B61093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 01:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273666B043A; Thu, 19 Mar 2026 21:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B646B043B; Thu, 19 Mar 2026 21:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160D46B043C; Thu, 19 Mar 2026 21:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05CE56B043A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:25:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D3255B255
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:25:29 +0000 (UTC)
X-FDA: 84564698778.05.EE16766
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1033540008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:25:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xa7DX2JW;
	spf=pass (imf17.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773969927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meaCcuCuf01rx8J/3G0ZOFEj83zr+wXfZDIg4Z9jId4=;
	b=RvdmZgPkDSY8J7GEJRRGNyb1PnYenGI+5WGHYrBbI4tGf4fXVxErLdeb0z6RFjUC5cQr8S
	brQi/B0lqdv5vUw1vcrRcgL04PLQ31kHLeqXKmjsLboTdfrGwVRDSBzRa0/0TMSeK9Zayu
	Yp7EgNFovu6rs3MEf5COj/mtd30dezA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773969927; a=rsa-sha256;
	cv=none;
	b=qT31AP+Kz4mc4jc00tftYLzrowsTyzsVLx8tTGfNCmb1+CvcX7XcUg/F9cgf8M+MwIbirq
	yXl6aKRD7lP7xCSFoBJGBPgwefdZCKra6D6BDbH9ZO1Fz4E+yIHm74xHnMULj0jBBVhCMT
	xYz9zxovH7XN/Sdy//XHO4hNCPu6vZ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xa7DX2JW;
	spf=pass (imf17.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773969926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=meaCcuCuf01rx8J/3G0ZOFEj83zr+wXfZDIg4Z9jId4=;
	b=Xa7DX2JWtXPGrKx4szeeUxdBz0lj8HuzhZQIqO6RZ5zUt2yCNV6ly2ZlHd2xKGdClSUulr
	3WjreUx+bP0aYIoaF+QjeU0LHFo2DppHJQ5bLQK/kql6+IcANjbaedDS2xa5JgePU1v7pv
	Y+1DMvNgJOcpfOT849xOp9z2IE2xmUg=
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com
 [74.125.82.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-ZmLjABNTN_KFOyuhtrV0rw-1; Thu, 19 Mar 2026 21:25:24 -0400
X-MC-Unique: ZmLjABNTN_KFOyuhtrV0rw-1
X-Mimecast-MFC-AGG-ID: ZmLjABNTN_KFOyuhtrV0rw_1773969924
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-128d285d6c3so161135c88.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773969923; x=1774574723;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=meaCcuCuf01rx8J/3G0ZOFEj83zr+wXfZDIg4Z9jId4=;
        b=iBz1FgfEAYMEG+q72xdhSgEiPNahxM1S5O1tolXsBLCyl6bh+63bBpCFI9dOWYGtrX
         90UNWzXHaJxcGgubYxLIF1afIfTKnROeQCMjmuzhYuQsQ3cw9Ooe6CiLVUnxl/2mdb5B
         rm2A8VwrkXQdDgVQig8ylvDlBHn6a9VIc3m0MFELqy5/iFgKXCoyf0UHbylbYuH6Bi91
         c9cGSIMvhVaZ9qlSSzu2KyCj+OVS1YCtxFLfj3aaJ42GjmPPKMsdr7ukmWwv/aq+4aLG
         aFNfUXGwwFJoWRRiLXB+DqI5PpFJ9eWxtMRoQn3eMXzkBzM9B87c8TUjdM/6/HM80dHn
         zeCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWr0ZhtF+KY9hAhsYw8JQcIjEhVWjc04iSN7N43xal0sCwdKKCVB/lL04tK54I6DrmimZpKcJ4jdA==@kvack.org
X-Gm-Message-State: AOJu0YxP68sb6xuPxRYCjmXhhGKtjUXTrUI0/5qwIwWhFVLcmQlBGe70
	YOTALLL+IQtw65RM2I20LZZRov8t1q+TFt3vxRAoS8wj73Qtaq/a9W05oGg4u9l/2e6IEs9u4RQ
	nMZKERKTvFLZSeJCumfpag80w08f7OMg3dXLJXfGDUZYxdqrRKQoJYSZxx4BH0pzIaTnx8LgK31
	51wtbTv3Kb5R9/r5G/5sXv2wNjXSQ=
X-Gm-Gg: ATEYQzzKKNfylQ0OqkRyfVxgnoAtR/DB3jemduS3o5R4eFMd8sjlc7XAsFa2T93leRS
	R7f3shqHpodYzZfyxtzZHEDWB6yqQJY3GWYSbs4n/C0iMjx4/4c3wL9kL292rA3STRzVJcwRe/x
	3wmrfBfTAfep+HqUYvVxz67pPP96pKevd2YKJciPXZD4w5qXz2kIfRH3Pg7lNIsBHsKKLE2dC8l
	UZl5w8=
X-Received: by 2002:a05:7022:68a3:b0:127:9e95:a2f with SMTP id a92af1059eb24-12a7267dfb8mr491973c88.2.1773969923574;
        Thu, 19 Mar 2026 18:25:23 -0700 (PDT)
X-Received: by 2002:a05:7022:68a3:b0:127:9e95:a2f with SMTP id
 a92af1059eb24-12a7267dfb8mr491962c88.2.1773969923110; Thu, 19 Mar 2026
 18:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260313043532.103987-1-liwang@redhat.com> <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
 <abPEALhYmtBnEULi@redhat.com> <CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
In-Reply-To: <CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
From: Li Wang <liwang@redhat.com>
Date: Fri, 20 Mar 2026 09:25:10 +0800
X-Gm-Features: AaiRm51OMUz5HtuOO1gW6zdFNMkpagDxDs-kLBIfG7-7hyqBtVroVpFu94MCU_4
Message-ID: <CAEemH2cQSoTEVb+8NxZpc=qQVrd5DBhj7HmJA5o9GZFke3zj0Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: yosryahmed@google.com, nphamcs@gmail.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 88FlmJ1iKF5O-MBB0r_0lMdBW2tVk72RkgGhr2nF4Ig_1773969924
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000001c14a4064d6a8fc6"
X-Stat-Signature: eioihtdkpdswffgw3zhjpeert5nawyr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 1033540008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773969926-314193
X-HE-Meta: U2FsdGVkX183L/o2zNOqbgz2qmCKa6xKpu4rMoDzBHwXiP0VwV3C6jJapCjvNbuHPFln3FbCJ/tFo95KuGEAc2WZeyidUCdN5dnhQmBM4z98WomtbPUbFRTjX+hkplD0r5ytk4V9FeppklZPaMUtViaIYKOv389oi1ItQ/g7VdzRr8YdtXB2UqzfkHYs2XkzNDeIiEwi/vmvwi5IAv3av/i5SzOrP0USLl96tri7CzxZuiRE/3HECYrinKyTRGarmlPZB1pMiAvDJTBOsFFrmvsOrhZ1htlhJ5/T9QuixyTj2ds55shdMGM1p72YHsHuOBtW1vxJX+E1wehkNEv2XVT2g0/3Z3qOUh1SFEz4Xi6/koC/XEwSnQVkzfvzsa1sgha857CaYzDxNII4n8gnJfFCe+mYgKDpARCu1JKBxoQRetSo2mYjbW0/lAH3K95oRzeQcev9nLJ2Qt2dNwDX/TBgpK4AHtcB+7tDP+OWAXBI3yFVLZ7Zl1tpyRUBsxJPVUa+1zrgEDbmrYnuOI0NVZHhMj78VDhRe+xmRi6p2w4vCwKNGBM9B/gMpAmXq3/QFLcw+jwyw9H7aJeikOfPQQCbyLAXUrDw4ud6i4lTDzlgxwjef+Q6IvvY6faOMjVEyEaK8MS0NCJo6KkDhkUfkWuy27tYKAYizz+vbrIz3+2/SF9tlwty51diA2Yx6z0V49/ak3SvUxIuLIQGlh4rvzmxqFKumRSy3nBOOMkA60eU7cXuHt9BINNqZC3OC7JpWNWZlwfiXpfbqL0NW0NTcLywvSumBNaSNk35YtEOgAHLh7hC8rjk3R2kCzoTSU1xofJASBjtSicCp9WLmua9UL93Ny+XWdSctC/ApJD9iNAyBfsgMQrHWzZezTBzhtEhthF7Ob0xUlH+FY+Tnwo3MUkNXAY8OizASZOlMV0t46RZ3YuHE4Zcxgrewp5GDvPsnV126XxvT0y4PTs7t23
 1oN69OKD
 9E/pLZtUd4V4FMokSo/aELUTVtimKdqqP14ip6RAETOOWVb9/n8iBvZ4x6lT1P8CLvLAHrEzflEyAjmcSJP4f9rM2X7ZXL2WUKuI7dIBcAjrB9ct9CrPOcex5zbICrlR7AT3IRJIysiv58q8GRkGeoTuZ0YM2TbVXPqmfX5UYogFEtGaG/14aTq9dI9g6NK3ek6MPEd5ksWw7WAYfnqbavBfezAjIqtzk8/r4d5mGXsCQYLH3a3FvA0Q0yqoOYQWo9WMb5eowD7991ejwBqjGr3Hwikoicn7uxKoTDWdbuFFO33QAqoLX3m4lNoHO04l6NT8/m4KpUpBzpi92JaGbVjUZYj5cCmxwAPcYeKwYdHFYplKFrbQCRnzhLgoSOM8ckIYGcx2xLWVAFGUbcM+KEWRnCNK4taka0KmPiR5ii2ebLhzgPX0qdM1eSZDQOIfqUplekpfFlnGXvAzfNTK0xqd79ha1Zt2wYnvqqkW2szJKqjd4tSFnugTKn0zV4gCOUhWOzV3PGZQvDTJgrCN85kuyTbNzJUgKo1gw7oypJE8gG/60AwRbYQ///8JAoJFC1HoybC0gqsvXD6/UmlL1AQ1wwf7q4PtL9xprFnmY+Q/2xlt33ereDbBA/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000001c14a4064d6a8fc6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yosry,

Do you know who will help merge this patchset?
Should I wait or ping someone to move on the process?


On Sat, Mar 14, 2026 at 1:35=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:

> On Fri, Mar 13, 2026 at 1:00=E2=80=AFAM Li Wang <liwang@redhat.com> wrote=
:
> >
> > On Thu, Mar 12, 2026 at 11:34:41PM -0700, Yosry Ahmed wrote:
> > > > diff --git a/tools/testing/selftests/cgroup/test_zswap.c
> b/tools/testing/selftests/cgroup/test_zswap.c
> > > > index 64ebc3f3f203..e69d845d3592 100644
> > > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > > @@ -589,9 +589,21 @@ struct zswap_test {
> > > >  };
> > > >  #undef T
> > > >
> > > > -static bool zswap_configured(void)
> > > > +static void check_zswap_enabled(void)
> > > >  {
> > > > -       return access("/sys/module/zswap", F_OK) =3D=3D 0;
> > > > +       char value[2];
> > >
> > > Please wait for discussions on the previous version to conclude and
> > > give people a little bit of time to respond before sending the next
> > > version.
> >
> > Sorry for the rush. I thought that I had clarified the issue there.
> >
> > > I think this can just be be:
> > >
> > >     char value;
> > >     ...
> > >
> > >     if (read_text(.., &value, sizeof(value)) < 0)
> >
> > This actuall introduce a problem to the code, as in read_text()
> > that achivement is:
> >
> >   len =3D read(fd, buf, max_len - 1);
> >
> > When 'sizeof(value) =3D=3D 1' pass in that makes read(fd, &value, 0);
> > read zero, after that, the value is set to '\0'.
>
> I see, I missed that, thanks for clarifying. If you do send a new
> version, put the path of the module parameter in a macro or variable
> to make the lines in check_zswap_enabled() shorter and hopefully have
> everything fit in one line. Anyway:
>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
>


--=20
Regards,
Li Wang

--0000000000001c14a4064d6a8fc6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small">Hi=C2=A0Yosry,</div><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div><div class=3D"gmail_default" style=3D"font-size:sma=
ll">Do you know who will help merge this patchset?</div><div class=3D"gmail=
_default" style=3D"font-size:small">Should I wait or ping someone to move o=
n the process?</div><div class=3D"gmail_default" style=3D"font-size:small">=
<br></div></div><br><div class=3D"gmail_quote gmail_quote_container"><div d=
ir=3D"ltr" class=3D"gmail_attr">On Sat, Mar 14, 2026 at 1:35=E2=80=AFAM Yos=
ry Ahmed &lt;<a href=3D"mailto:yosry@kernel.org">yosry@kernel.org</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, Ma=
r 13, 2026 at 1:00=E2=80=AFAM Li Wang &lt;<a href=3D"mailto:liwang@redhat.c=
om" target=3D"_blank">liwang@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On Thu, Mar 12, 2026 at 11:34:41PM -0700, Yosry Ahmed wrote:<br>
&gt; &gt; &gt; diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/t=
ools/testing/selftests/cgroup/test_zswap.c<br>
&gt; &gt; &gt; index 64ebc3f3f203..e69d845d3592 100644<br>
&gt; &gt; &gt; --- a/tools/testing/selftests/cgroup/test_zswap.c<br>
&gt; &gt; &gt; +++ b/tools/testing/selftests/cgroup/test_zswap.c<br>
&gt; &gt; &gt; @@ -589,9 +589,21 @@ struct zswap_test {<br>
&gt; &gt; &gt;=C2=A0 };<br>
&gt; &gt; &gt;=C2=A0 #undef T<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; -static bool zswap_configured(void)<br>
&gt; &gt; &gt; +static void check_zswap_enabled(void)<br>
&gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0return access(&quot;/sys/module/=
zswap&quot;, F_OK) =3D=3D 0;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0char value[2];<br>
&gt; &gt;<br>
&gt; &gt; Please wait for discussions on the previous version to conclude a=
nd<br>
&gt; &gt; give people a little bit of time to respond before sending the ne=
xt<br>
&gt; &gt; version.<br>
&gt;<br>
&gt; Sorry for the rush. I thought that I had clarified the issue there.<br=
>
&gt;<br>
&gt; &gt; I think this can just be be:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0char value;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0if (read_text(.., &amp;value, sizeof(value)) &=
lt; 0)<br>
&gt;<br>
&gt; This actuall introduce a problem to the code, as in read_text()<br>
&gt; that achivement is:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0len =3D read(fd, buf, max_len - 1);<br>
&gt;<br>
&gt; When &#39;sizeof(value) =3D=3D 1&#39; pass in that makes read(fd, &amp=
;value, 0);<br>
&gt; read zero, after that, the value is set to &#39;\0&#39;.<br>
<br>
I see, I missed that, thanks for clarifying. If you do send a new<br>
version, put the path of the module parameter in a macro or variable<br>
to make the lines in check_zswap_enabled() shorter and hopefully have<br>
everything fit in one line. Anyway:<br>
<br>
Acked-by: Yosry Ahmed &lt;<a href=3D"mailto:yosry@kernel.org" target=3D"_bl=
ank">yosry@kernel.org</a>&gt;<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr"><div>Regards,<br></div><div>Li Wang</div></div><=
/div></div>

--0000000000001c14a4064d6a8fc6--


