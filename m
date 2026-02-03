Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A14E8305F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 08:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587C76B0005; Tue,  3 Feb 2026 03:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535B76B0088; Tue,  3 Feb 2026 03:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D7F6B0089; Tue,  3 Feb 2026 03:43:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32DDA6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:43:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FF9C1603ED
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:43:30 +0000 (UTC)
X-FDA: 84402506580.28.7F6857D
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A5D5100005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:43:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qxcjfl6I;
	spf=pass (imf05.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770108208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7qeozh0WbVS4uKMXQGUmb52+Fq95iA3qpwphe5USlQ=;
	b=yT1g0lnx9wmlEsAjW2fgi77QuebLL0chi6nsbKZi6++3dVNFfL3Sebx8qpALE8ZgBRnbbh
	qJgb+efgb7zVU1lToUjJBtpaSi/OEeYrk6XHucItLGOOcL992hRMugTk+XaLCydAvXLva8
	Pgr5kdPaaCBPk1TDCihmuWtQjNhPFCM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qxcjfl6I;
	spf=pass (imf05.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770108208; a=rsa-sha256;
	cv=pass;
	b=y/FB45TpLWgz6E+CZM2RWpNIksGrs5h4roaBdR17sKJ0yeRVwDNxr9DckbtBlK7kldVmFg
	VCa61LdxxOBQnS7n1FsdtorTQHqOmFACZ8+V5CI2KNdlAqOiSm72tPlqPSluWBpyjKkmb6
	QM1yiPDPu/TQIx04qoiOJ9ra6Sv0RNc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806f9e61f9so27285555e9.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 00:43:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770108207; cv=none;
        d=google.com; s=arc-20240605;
        b=HFw8wzLfDMp6f+h/2PQ7Mboq7PlF2ka/z5e1HNoM1RzSufYMBJr8LArzXufodea6H5
         ZLvBf06hm20FWKWVADopqmtEqDJr82n+ykw7R0AnXib45tvqNkFcvyU/alXg+K9DKdkg
         2IZKRGREqrBpFKlZkhtxl6IN92YzPbeVsTxZwJqiWtCIbRrZtxjv6VNZNsnLOo3ZU/wA
         KEqu0Ip7f9rmRjGlqg3FdXLf3YeF7S4SGMvDKWEt8psmxqqbyaKTFjI9aLGzxcskyOeC
         EHfDdlfipLQVeltYMkl0c1st7O80G0eMP8I8ZODDEOBcjSdPR10FjqOwjAzP186laZUq
         at6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=f7qeozh0WbVS4uKMXQGUmb52+Fq95iA3qpwphe5USlQ=;
        fh=fAJ4dYEmSppBZariH886qvIVCxnceFI7x6yhuYvzkf0=;
        b=W4CH195/E2wMBx9ZoP6a1AsGBVfuQNcL+7EMxeMNpkBqcIbxNdHkt8EVywmpBxwzwL
         Cnfz1ziOC/u4Bo8zPXs3AchPqr3S74AVIqG2+oQimfiybIAMuwgFGLhVuK7kRp7RpWX4
         DWKqrszXhyMRxa/V1qOQFP3MAKXTY5jLk8GJj2LjE1a6TN40dFlZuqzTxcnD0xgXoO+2
         KCmgPxpTimu77u0CF1dgKKYXMduh1aYndjXP+cHR6Td5M5GhVeoCER5yjcd9y8PvT92Z
         /T7tzdnAaLHoG2nvP/Cc7eplNr6FVhkQ2VkPwc7WtLgpOSo0ZFhGXA5v0eEpjC5GdJPh
         Lq/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770108207; x=1770713007; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f7qeozh0WbVS4uKMXQGUmb52+Fq95iA3qpwphe5USlQ=;
        b=Qxcjfl6Iatfrcye/Zml9iFhy5vOlwUZA7ovvTdAfsP0BkJvvZ8a4YrPuPp9isvE3yg
         c4u3E4lH08zXFgp2lZjKIpgotWn9Lea7FT0/l6SkoqJRIb4Nofr9B+LYoW2o3gE8u6CZ
         EmBIFyrQLRC1B+5okIeLAeuoUXEFeOVh//YR0D7QEjq0w1Zkfbt2dBi+3tPcaKJY5rlm
         EUtBwMYI0kh3tDnvHz31GpxayZyfaGGcZZfMuMsbmpAVJvzhPr27sGj1OCC3/S6o8OSW
         a144A3SSdoJPpsoDqmraMYsQ8RVhFbGCOd2JNbeNex1sM+gTViObc+eZZNC+4FYHKrDZ
         5eSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770108207; x=1770713007;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f7qeozh0WbVS4uKMXQGUmb52+Fq95iA3qpwphe5USlQ=;
        b=KvqYpaIvUeEl8iR/+HkEpxzRz5mPBTUFdzHIH2CFFvkl2Kt02nuIFePnSfnjt3c6v/
         mIzNNRAJok/Am1epFywyd1KghNOk1jOMFTqruQPUzhU8iFvA6wHW/I0Z8uoLS4VwAGre
         klbuzS9lf7EV4eixdQ7sKNC2Sg8CTeIc+YZDY5NUqXXJKGD0GMPKed07u5YRWRF1Kzjm
         e4OgVARyv9xAxuoi6F9ZL9BdgpWGHJcqdtD77N0xxS2MhVW831yHaaOJx+35N6ZR7Dha
         4aoj8abpTwJccQlFykoF4TMWj1J6aDQ3meYs3bMV7gc552wJ0iA4VpNIKc8qIgsyOfnr
         hu/A==
X-Forwarded-Encrypted: i=1; AJvYcCVd3A9x9NIKf3Z2sBYaFkdDqn3cgYvsFmidJwXbJrYZiOn0SMR9X3nR/xEg/lRbgiDaCR4vD8ms1w==@kvack.org
X-Gm-Message-State: AOJu0YxQ6eXSMUjNhHMs1SlPYvJjC1ijzxKmkcRAQLoDka6ssq9W1XD2
	mZZwQAogeDwFYNjQ7mzeOKtrvoh86X4GMo0Vheq5j+5d/9uT9Nj1RcE6bY+Lzz5A/3cOmKAk7sC
	8HfSclu+wgA2L96YEHvnpKjGclYV+Edg=
X-Gm-Gg: AZuq6aIB6BAdbYwr1WbyaFeYnHibNlVw6IuKR72WjzNmv4xWS/CzWmiO3C9Iom7WDHV
	kkJdgRpao86PxliWAvdGhdwpraEXFCToBWL7h3kxin9V5uRg/Gv9R/nKM9O9B627Q7zDfVsI3B3
	5SHhMPKXBQbnZz2ER/azIacdb8gPB3scX0oBlhqGsK3fraESV+RzQXg5zN4Ya6q9l2L+UWBgw7U
	nz/1EZZ95ryKc8nlv+hZVz1rIhPzkHO+D9X+UgbGy0La9c9T39CvJD9zWt91ZI6P9iR4hBk1xUe
	cyilxJ6Melp3J592h8CGNosWOO4=
X-Received: by 2002:a05:600c:3e1b:b0:480:32da:f33e with SMTP id
 5b1f17b1804b1-482db47ce18mr188586095e9.17.1770108206608; Tue, 03 Feb 2026
 00:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20260203073757.135088-1-ahacigu.linux@gmail.com> <3e59ca4e-2301-48a7-bb8e-d028f07b1446@bytedance.com>
In-Reply-To: <3e59ca4e-2301-48a7-bb8e-d028f07b1446@bytedance.com>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Tue, 3 Feb 2026 00:43:15 -0800
X-Gm-Features: AZwV_QhiNxo7meE9JTKfsDOzFg7vzH7VfOmIyl1ZziFCxTpysBhh1n0g2VpW7KY
Message-ID: <CALjTKD=2YaMLmQqsa=u6cwg94BVRC-5Y1OV2d0Z+7ULRdz4k0Q@mail.gmail.com>
Subject: Re: [PATCH] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000de79350649e76e18"
X-Rspamd-Server: rspam11
X-Stat-Signature: m1r4ri87d4qudk4udqps46ema7ygnxji
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A5D5100005
X-HE-Tag: 1770108208-473272
X-HE-Meta: U2FsdGVkX1/Itj3X/uQshbOxz3WnbgRmgprmLmwhhc5t31ZGYAqlG7SHk8NlmadZ7oIHyAWF8z3lVEYyIxqrngdkK1AVlHN64tCPsVociQrWh4dTCC3dnxs+YTk/urGlvC1O8jGlv/tzTcmMUtZk7Qma3cRSve7hJUtPCUIQeC6MOwsGYl6/5AvqWoQ0ONgDq095g5+vgDYb93MGgMOEQEerhP6dyiQLF5gqdFc0jmP8ouBXAo9MD7lgHJqf2ZLoPOM+mJVN5eW+i8VLbb8P3tqmBtjEPcbzDIZVfUCCUbagNDNMB1YD544XH4OF5zOpGAskRPV+rZt3uMaQLptCr8U3pprfA9qo+KQ5wKanmatJhEfDJtWBtTY2KfyWXWLGTsagI8joRbH1CXvzQnso2G24jts6cAvr5fghUOl+n3QBxIbwIGahP9+nI7SaweLKh8U/tVekOqPwlKher/5Vt6d+LD+W6dcepJf5NB6cF2vtN4XD6Cvzyyoo9rk5ySZeRtFV/MmvbHFLYw6XrclKBPvni3pAgFHNNtsAv4mMqJRt77IM7pV1PQ9FurmLPDkvNaq8hmeN8hLC4gXvZH9+8CZjrxmrTH7haP8Unnf4O7OtTduJrjtAZHAi0ohVsMuUbZXHpnEZU2zkN6wqEvWnh/CShB54M1fqjbhgUtp+SYSW0/AIJQT1zvbjeyzCr5S5djFvmJYbVEEtIxZ2Iipe+1Xoxow04M2Pu/oyglF56RsPEgOGCcmGeC6fc7umvadzTRQs/pByuLV3ZCQovNP03shjOOtvGRevJWh8++0EYy5vkosqThVsMLvpF7OfJVyqmS20+mrs7FXavnUFAXVKprVi37ErUSylWJeAeSWlYHr/Q83WF0rL5EQi6F4dyGfRND0yn9B7egeK6UDjMyIIrRgM+j8lKAt0wsHumFeOs8tRcypwvSChEjFD+ht4YIRooXq+o+5ed78pTU2IRM1
 2N5OsltM
 lZVJzcO5Cr3JQq7PWYN8e3EJe3LzfiWcKzQpzX9oJdGkK/FANUY3cGzDLnSRffKvjwmK8X/k5X2yJDMQNWHs1Qr/arElUXveshHmZXmOYfoG8le7JcUK5er27FA84vIDFbfsYYa42GUnRQVk7ppq+VXLuT7Z6zhXrQisovlofNsPc55zcqND5CxMrJx30177TB1clXsBWQDmkenmGLAZP3DMiu3otczyefCRHDpHi5PGw6rZz6/Yt2O0ywd+i02gPDtj54OguO8fqz9DLaDrcl7ry1LZYBGxQhXhYcusOToMigTR5QmWyGFpM548nc5Bhx6G0TcTsBSUblwBAGgg+jVntArebj1RpHGH9rH6TIupj5Lysrk0KMdvhEP4aBm8Zl+2LNCyFbYGjEXPRsjd41BfWdld6APWLlTEsEaocJRmbz5VRlxCzTnPx3DBYJ2DXyZmUMvdMbdBTvet8QDyK28KNlQj1sbXOtWoHAhlGbBmAxRJZids+RLbnQ4hPbBPsCW7kCNhscTMT1kmzpK164dU8tlRBdPzxnl72nZgBZy2JaIuKUfymb+TQplakhh2h+OZcEj5gnQRZSFRq7e8hjz9avg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000de79350649e76e18
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure, makes sense.
Will send a v2 with the bitmap clearing.

Thanks,
Altan


On Tue, Feb 3, 2026 at 12:18=E2=80=AFAM Qi Zheng <zhengqi.arch@bytedance.co=
m> wrote:

> On 2/3/26 3:37 PM, Altan Hacigumus wrote:
> > When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> > However, shrink_slab_memcg() doesn't drop the reference acquired via
> > shrinker_try_get() before continuing.
>
> Good catch!
>
> >
> > Add the missing shrinker_put().
> >
> > Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
> >
> > Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> > ---
> >   mm/shrinker.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/shrinker.c b/mm/shrinker.c
> > index 4a93fd433689..d0be120488b4 100644
> > --- a/mm/shrinker.c
> > +++ b/mm/shrinker.c
> > @@ -544,8 +544,10 @@ static unsigned long shrink_slab_memcg(gfp_t
> gfp_mask, int nid,
> >
> >                       /* Call non-slab shrinkers even though kmem is
> disabled */
> >                       if (!memcg_kmem_online() &&
> > -                         !(shrinker->flags & SHRINKER_NONSLAB))
> > +                         !(shrinker->flags & SHRINKER_NONSLAB)) {
>
> Since memcg_kmem_online() and shrinker->flags cannot be changed
> dynamically, it's best to remove this shrinker from the bitmap:
>
>                                 clear_bit(offset, unit->map);
>
> Otherwise LGTM.
>
> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Thanks!
>
>
> > +                             shrinker_put(shrinker);
> >                               continue;
> > +                     }
> >
> >                       ret =3D do_shrink_slab(&sc, shrinker, priority);
> >                       if (ret =3D=3D SHRINK_EMPTY) {
>

--000000000000de79350649e76e18
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">Sure, makes sense.<br>Wi=
ll send a v2 with the bitmap clearing.<br><br>Thanks,<br>Altan</div><br><br=
><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, F=
eb 3, 2026 at 12:18=E2=80=AFAM Qi Zheng &lt;<a href=3D"mailto:zhengqi.arch@=
bytedance.com" target=3D"_blank">zhengqi.arch@bytedance.com</a>&gt; wrote:<=
br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">On 2/3/26 3:37 P=
M, Altan Hacigumus wrote:<br>
&gt; When kmem is disabled for memcg, slab-backed shrinkers are skipped.<br=
>
&gt; However, shrink_slab_memcg() doesn&#39;t drop the reference acquired v=
ia<br>
&gt; shrinker_try_get() before continuing.<br>
<br>
Good catch!<br>
<br>
&gt; <br>
&gt; Add the missing shrinker_put().<br>
&gt; <br>
&gt; Fixes: 50d09da8e119 (&quot;mm: shrinker: make memcg slab shrink lockle=
ss&quot;)<br>
&gt; <br>
&gt; Signed-off-by: Altan Hacigumus &lt;<a href=3D"mailto:ahacigu.linux@gma=
il.com" target=3D"_blank">ahacigu.linux@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0mm/shrinker.c | 4 +++-<br>
&gt;=C2=A0 =C2=A01 file changed, 3 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/mm/shrinker.c b/mm/shrinker.c<br>
&gt; index 4a93fd433689..d0be120488b4 100644<br>
&gt; --- a/mm/shrinker.c<br>
&gt; +++ b/mm/shrinker.c<br>
&gt; @@ -544,8 +544,10 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_=
mask, int nid,<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0/* Call non-slab shrinkers even though kmem is disabled */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (!memcg_kmem_online() &amp;&amp;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0!(shrinker-&gt;flags &amp; SHRINKER_NONSLAB))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0!(shrinker-&gt;flags &amp; SHRINKER_NONSLAB)) {<br>
<br>
Since memcg_kmem_online() and shrinker-&gt;flags cannot be changed<br>
dynamically, it&#39;s best to remove this shrinker from the bitmap:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 clear_bit(offset, unit-&gt;map);<br>
<br>
Otherwise LGTM.<br>
<br>
Acked-by: Qi Zheng &lt;<a href=3D"mailto:zhengqi.arch@bytedance.com" target=
=3D"_blank">zhengqi.arch@bytedance.com</a>&gt;<br>
<br>
Thanks!<br>
<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker_put(shrinker);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ret =3D do_shrink_slab(&amp;sc, shrinker, priority);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0if (ret =3D=3D SHRINK_EMPTY) {<br>
</blockquote></div></div>
</div>

--000000000000de79350649e76e18--

