Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87B8CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 16:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D8A8E000F; Tue, 11 Nov 2025 11:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5558E0002; Tue, 11 Nov 2025 11:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B728E000F; Tue, 11 Nov 2025 11:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAA18E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:48:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8913954A53
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:48:50 +0000 (UTC)
X-FDA: 84098910420.04.9EEDB07
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 860CB40008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:48:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PSbwC8vw;
	spf=pass (imf07.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762879728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZbFbYVvcEedVwJRwUwPZiNLEZK9ffdaAqCwqz+/NeA=;
	b=mF13L7pvladzhYumw2kqrFq9EN8vdHnFR8kLh2+5vMgcTLMJ1n3H0xicdJv6YnaicDba74
	X9XS6qAJIJHbcNSmGmnjf9HtravxXMhna0fhGofsM7hx2V0yYc0623iBYFKOp+gf7vD/Fe
	t2DXPRW1RY8qasV1/wJtz+G+xj0xZgw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PSbwC8vw;
	spf=pass (imf07.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762879728; a=rsa-sha256;
	cv=none;
	b=n7Bjlqx79zrHHwpT+VXP7jd6QPN1tao10+DmXYtY3+D3GYBoKlgMdEr7zGztXuZjPZoCCH
	ZyDGmT4/rM//a3l3XBFAVWCiOlIIcM4Q1lHDvV2b8WBdblz1FLyV/s+xmjAEvVzsj/Ywx/
	UT5RZYAlcOgTuTPqwCnDYh51PV7qhJQ=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-594476f218fso3202497e87.1
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762879727; x=1763484527; darn=kvack.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NZbFbYVvcEedVwJRwUwPZiNLEZK9ffdaAqCwqz+/NeA=;
        b=PSbwC8vwM2d1sCH0SJFJE2JxnJkphHJWmwT8T0KgmL2L+gZHwnbS905rCoOTrxBe7H
         /tsohrrksGlYeYv9WKTvL/reqoGenRnGntfD7P+0YGvTmi0KC7TEe7xazHnZmgJKYUuI
         gUVFStwO3CuCI/vywWt9ObLIUHHLgfp0O5iXVht28lBs5Zzr9FMstZaZv4lXX/o0dKPS
         0yVgFEzrt82c9c5mtnqHvxT6zDn//I2measaXomrnenTpuAy94RBye5tRMZtp7XbJeFI
         dwoEhVBYsMsLQa7J4Co30+9MKfYbBoeRMWXvazsCekmf7pLu1l0ghBvMyejBEYe35Gyh
         cLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762879727; x=1763484527;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZbFbYVvcEedVwJRwUwPZiNLEZK9ffdaAqCwqz+/NeA=;
        b=mywKa99V4vG0HtdIOEB0ex9GlYRhX+vGq7yGaUmXjtl/R5+c/OHEmsusyWLG/sij83
         nVZHd8J/Zk3cX5x3ZJE12Z4/MXiizz2UwCefTlPA6VFSWxmxBda3HBokAw1HyYLbV+N0
         FvxIs/wjXhl8LB1foafaKY2HOOV8UWMtR1ch/4GgPfgdU/qldzk8wwS5aHk8vLbnnx+B
         zHoWzbiIKdjI/47432iL8BvMEz6UXf6mN8cUAkbQBN/ePZjlRgpJqg3POyy30RYbZAKi
         +6fW6fAvVMCAtQrbiwspqga8xdqjvUGqNMZLD7M1pwd94tvVvHdua0wTGJC6ynIPEFJL
         NBDA==
X-Forwarded-Encrypted: i=1; AJvYcCWRJXCsKezQYn21PDuhkwTyWeBSebS7FTZ5Q5vSXxG/N4jw7Ar/idVv/N0aba4/sswAo6E2k3FOWA==@kvack.org
X-Gm-Message-State: AOJu0YxBEhn/RTI/gGywPP2ODk8vRsKbP0NC4KfjpovMwqkhnPN6ezcE
	ONRHnkGvVZCg8zUzZj9OhGi8GSaUhw228H+KcSu+wamQeINHchPpHKZPXRAcvYC48URwt0W6nlL
	dv9LOkprdTzoH3+FHLHr6cD1ic+uKAjk=
X-Gm-Gg: ASbGncuHuh8qxUDd+fJOIbGL2G8M3Bw4nKd7zP9zCtaC3e4rd3w5W3qKDZiXSnXrlzV
	oQ+cq0vJems0QsusCSakddxsfbAs48CK2mP3DVsN9Z8PlSorRewGmhpeB16c6s33CvAsFRfkSiX
	9z1jfl1e4CgNLn+Z0JZ4h6zkhZ7xqodDY991V8ChGVolacaX5vhCkfCJfsTzxWJRXPLGhXooh1G
	McyelIllVUjAEKDIQLwZy+uip9a74yOqwK8k/LgIlyPoO2GzLkGWy00rDw7xUI=
X-Google-Smtp-Source: AGHT+IHEe0sy8WvJxoll8giSLL3klufqc2pLCUx8+YL0MxXNPfzvgXc6LEee7WT7jHo+cEBJ70x+MQ9Ie2skkXFy6Hc=
X-Received: by 2002:a05:6512:3a86:b0:579:f0fc:429f with SMTP id
 2adb3069b0e04-5945f1e53eemr4023997e87.49.1762879726251; Tue, 11 Nov 2025
 08:48:46 -0800 (PST)
MIME-Version: 1.0
References: <20251111125331.12246-1-harry.yoo@oracle.com> <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
In-Reply-To: <eesmaqfwnhq4xcoduevr5aodsf622ugn5aheywvpbhpg5fzhcv@5zbfhikqmrtl>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Tue, 11 Nov 2025 17:48:35 +0100
X-Gm-Features: AWmQ_bk-1Bgvnxk0qvW09RSQ0q-NAHra3FjWQ517_JL-8cPHHU9hW1N8F_W3w_k
Message-ID: <CANfXJztJZJ4eaFf+FxC=deFeO7MG0__U3FVtBDcmS7iUk3gFgw@mail.gmail.com>
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Tytus Rogalewski <tytanick@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="000000000000dd736c0643546b6b"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 860CB40008
X-Stat-Signature: 4x7p4j4kd1dxxyitawxbuxwz9sgt9p3w
X-Rspam-User: 
X-HE-Tag: 1762879728-410212
X-HE-Meta: U2FsdGVkX1+Pvj9N3jLW4IOQN8Mn/NIAWr+cNQBTauvvznAxtQDasSPRrVqeUf9w8IHXPz9HuqZgTKCxVkglIgZif0LurPuOJAHHItV6NQhusLNxF3rIhbYghNi2f+UiBiIchGxRuwrF3XcmvrNgk+93/EV4/28FgwB6zrY0dFa+SiYYZ5HmFbgMmDztq23NOgV6Y+0TT8HkNqvDbykYcAQOqmtclQ6LqxisuMZ3+zVDYrTkZsGDwcfpQra0PpxnCyQhGmVZyL5SJdvNamOTJapCDb0TtcVaoYYSwZJo+0KPGYceneThy5osdbttZO022EXFmTlXuw5EI/I9ln0zVmV6PLvSDe87QQsDk2SfIj3m7hgHyyszHBmMq18gq9G9Bfkp4pTQv1CrwXFpl+Y1u68yL6AMOUOU0cM9dpFiPwrpxiK4g6KV0N5UjiB6VK1knltidQHSrrMZ/QcBV3gogh4gY5v5m6jgNO5wAP0+vNUAPToh9dsBXjtsNhzGi6xHbyGHch2GtkxKsTSfKjRvdKhn9ZTMn8klr0HQ8cSD9j5zlxH5FiWOGIClQ/6kxWKtMt6IfqZQs3on3FHzD0kWQRZLGodV7K/NYSJGMzARA3GR6/eji52olFMprj6vIFVyh/MsNtXzYmYsGeO1H59cZEM3+1To1AIQ3Xlxx5LQPCsyPGdQG1CM9ap/jJdQ8QoDM8byiGseWH66tGi0i/etgPXXfIEJlYcgGBnP1ZwAttm9pcvC7GoG/cluEvDj9gJhOwWHeTv3z7GPBsNOOTu+T1q59Sxmq7CvUByKHJBLIyy/YznFzBLUJAkq9yetcUFKR2rvE3RYQs+4L1a4BMeCxRjKwSMXAeCssK7fW5NaEttBfIpbnQEwb4xyFW66BJVyzGNxfKatVho32Ellrv4WY3sO3yGydsuWyb9pupz2EIdaZ1TG7pV0cjB+sFx9lNnayZDpcIRj2lAn1nPWCks
 TkOyxMzv
 snUf/PTiuV+M1Gz74cSMFXuCftiZa92i/OtTHGJqmrJTZ1Nwl7KdxzKdpQ3OpZv9RsDVFhxRMv0SKdPxveZLzH1IMqQUsF2H3S00ACOqW51RtNCvFC/ixX9uLPSs0G4H5FDj+hoHOe1NzCdOmOS1xypaY5FTm6ej51lftq/VBuhdXpzpydsIhhJN4gzCAvm1MwC3AbQeUaWViFPQ2MnNxdRtB0hEfqodJDwY8E9EFhjLKcJtTtSwAloYB9ZtLQV5fgXHP9lnPCVIhDwA6G6V1P6ibb7NiD7PMoeu8O0H8D/xDUhl7Tt4sM2GuQwzyiogdBRF8WGDP+zjqM36rD6l3Oe8PcfRbRGJU9EgbFFO0HCfMwekdKYCUhmLT/WVexFH0fRojvgErqnfOEhn4eLzhyD2kjvcbtCZkc7YH+3WWiD0Unx0zMQZ6cD29n3NO1nGbAhPhZLl8s6DeGrfglp6goJgohefv5zosSKvwYXWWsJQB//iMqbU0Gl0c3/k7mN4vyrWUBAEw0XR9QWR3GP+SxmkgG6c2xxV5oLGVkcRYrfohI1/HyzrtNBg0q4SHuLstqdMIICuDWhqEMJDM0CFRwtFSi6+/d9QTBwnt6kmGxGvynZ8UQtA7go+ClEiavhnylDLu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000dd736c0643546b6b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you guys still need that debug then?
I think this is happening only when qemu vm is working.

I can get results within 1-2 days.

--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


W dniu wt., 11 lis 2025 o 16:37 Liam R. Howlett <Liam.Howlett@oracle.com>
napisa=C5=82(a):

> * Harry Yoo <harry.yoo@oracle.com> [251111 07:55]:
> > The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> > freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> > skip sheaves when objects from a remote node are freed.
> >
> > However, the array is flushed only when:
> >   1) the array becomes full (++remote_nr >=3D PCS_BATCH_MAX), or
> >   2) slab_free_hook() returns false and size becomes zero.
> >
> > When neither of the conditions is met, objects in the array are leaked.
> > This resulted in a memory leak [1], where 82 GiB of memory was allocate=
d
> > for the maple_node cache.
> >
> > Flush the array after successfully freeing objects to sheaves
> > in the do_free: path.
> >
> > In the meantime, move the snippet if (!size) goto flush_remote; outside
> > the while loop for readability. Let's say all objects in the array are
> > from a remote node: then we acquire s->cpu_sheaves->lock and try to fre=
e
> > an object even when size is zero. This doesn't appear to be harmful,
> > but isn't really readable.
> >
> > Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D220765 [1]
> > Closes:
> https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@=
linux-foundation.org
> > Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> > Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object
> freeing")
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>
>
> Thanks Harry.
>
> Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  mm/slub.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f1a5373eee7b..a787687a0d59 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s=
,
> size_t size, void **p)
> >
> >               if (unlikely(!slab_free_hook(s, p[i], init, false))) {
> >                       p[i] =3D p[--size];
> > -                     if (!size)
> > -                             goto flush_remote;
> >                       continue;
> >               }
> >
> > @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s=
,
> size_t size, void **p)
> >               i++;
> >       }
> >
> > +     if (!size)
> > +             goto flush_remote;
> > +
> >  next_batch:
> >       if (!local_trylock(&s->cpu_sheaves->lock))
> >               goto fallback;
> > @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s=
,
> size_t size, void **p)
> >               goto next_batch;
> >       }
> >
> > +     if (remote_nr)
> > +             goto flush_remote;
> > +
> >       return;
> >
> >  no_empty:
> > --
> > 2.43.0
> >
>

--000000000000dd736c0643546b6b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Do you guys still need that debug then?</div><div dir=3D"=
auto">I think this is happening only when qemu vm is working.</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">I can get results within 1-2 days.<br=
 clear=3D"all"><br clear=3D"all"><div dir=3D"auto"><div dir=3D"ltr" class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><d=
iv dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica N=
eue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica=
 Neue&quot;;color:rgb(0,0,0)">--</font></p><p style=3D"font-size:12px;line-=
height:normal;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=
=3D"1" style=3D"font-family:&quot;Helvetica Neue&quot;;color:rgb(0,0,0)">te=
l. 790 202 300</font></p><p style=3D"font-size:12px;line-height:normal;font=
-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"font-size:x-smal=
l;font-family:&quot;Helvetica Neue&quot;;color:rgb(68,68,68)">Tytus Rogalew=
ski</b><br></p><p style=3D"font-size:12px;line-height:normal;font-family:&q=
uot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:=
&quot;Helvetica Neue&quot;;color:rgb(153,153,153)">Dolina Krzemowa 6A</font=
></p><p style=3D"font-size:12px;line-height:normal;font-family:&quot;Helvet=
ica Neue&quot;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helv=
etica Neue&quot;;color:rgb(153,153,153)">83-010 Jagatowo</font></p><p style=
=3D"font-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot=
;;margin:0px"><font size=3D"1" style=3D"font-family:&quot;Helvetica Neue&qu=
ot;;color:rgb(153,153,153)">NIP: 9570976234</font></p></div></div></div></d=
iv></div></div></div><div><br></div><div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">W dniu wt., 11 lis=
 2025 o 16:37 Liam R. Howlett &lt;<a href=3D"mailto:Liam.Howlett@oracle.com=
">Liam.Howlett@oracle.com</a>&gt; napisa=C5=82(a):<br></div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;=
border-left-style:solid;padding-left:1ex;border-left-color:rgb(204,204,204)=
">* Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com" target=3D"_blank"=
>harry.yoo@oracle.com</a>&gt; [251111 07:55]:<br>
&gt; The commit 989b09b73978 (&quot;slab: skip percpu sheaves for remote ob=
ject<br>
&gt; freeing&quot;) introduced the remote_objects array in free_to_pcs_bulk=
() to<br>
&gt; skip sheaves when objects from a remote node are freed.<br>
&gt; <br>
&gt; However, the array is flushed only when:<br>
&gt;=C2=A0 =C2=A01) the array becomes full (++remote_nr &gt;=3D PCS_BATCH_M=
AX), or<br>
&gt;=C2=A0 =C2=A02) slab_free_hook() returns false and size becomes zero.<b=
r>
&gt; <br>
&gt; When neither of the conditions is met, objects in the array are leaked=
.<br>
&gt; This resulted in a memory leak [1], where 82 GiB of memory was allocat=
ed<br>
&gt; for the maple_node cache.<br>
&gt; <br>
&gt; Flush the array after successfully freeing objects to sheaves<br>
&gt; in the do_free: path.<br>
&gt; <br>
&gt; In the meantime, move the snippet if (!size) goto flush_remote; outsid=
e<br>
&gt; the while loop for readability. Let&#39;s say all objects in the array=
 are<br>
&gt; from a remote node: then we acquire s-&gt;cpu_sheaves-&gt;lock and try=
 to free<br>
&gt; an object even when size is zero. This doesn&#39;t appear to be harmfu=
l,<br>
&gt; but isn&#39;t really readable.<br>
&gt; <br>
&gt; Reported-by: Tytus Rogalewski &lt;<a href=3D"mailto:tytanick@gmail.com=
" target=3D"_blank">tytanick@gmail.com</a>&gt;<br>
&gt; Closes: <a href=3D"https://bugzilla.kernel.org/show_bug.cgi?id=3D22076=
5" rel=3D"noreferrer" target=3D"_blank">https://bugzilla.kernel.org/show_bu=
g.cgi?id=3D220765</a> [1]<br>
&gt; Closes: <a href=3D"https://lore.kernel.org/linux-mm/20251107094809.12e=
9d705b7bf4815783eb184@linux-foundation.org" rel=3D"noreferrer" target=3D"_b=
lank">https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb=
184@linux-foundation.org</a><br>
&gt; Closes: <a href=3D"https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo=
" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/all/aRGDTwbt=
2EIz2CYn@hyeyoo</a><br>
&gt; Fixes: 989b09b73978 (&quot;slab: skip percpu sheaves for remote object=
 freeing&quot;)<br>
&gt; Signed-off-by: Harry Yoo &lt;<a href=3D"mailto:harry.yoo@oracle.com" t=
arget=3D"_blank">harry.yoo@oracle.com</a>&gt;<br>
<br>
<br>
Thanks Harry.<br>
<br>
Acked-by: Liam R. Howlett &lt;<a href=3D"mailto:Liam.Howlett@oracle.com" ta=
rget=3D"_blank">Liam.Howlett@oracle.com</a>&gt;<br>
<br>
&gt; ---<br>
&gt;=C2=A0 mm/slub.c | 8 ++++++--<br>
&gt;=C2=A0 1 file changed, 6 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/mm/slub.c b/mm/slub.c<br>
&gt; index f1a5373eee7b..a787687a0d59 100644<br>
&gt; --- a/mm/slub.c<br>
&gt; +++ b/mm/slub.c<br>
&gt; @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *=
s, size_t size, void **p)<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(!sl=
ab_free_hook(s, p[i], init, false))) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0p[i] =3D p[--size];<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (!size)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_remote;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0continue;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt; @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *=
s, size_t size, void **p)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i++;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!size)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_remote;<br=
>
&gt; +<br>
&gt;=C2=A0 next_batch:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!local_trylock(&amp;s-&gt;cpu_sheaves-&g=
t;lock))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto fallback;<b=
r>
&gt; @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *=
s, size_t size, void **p)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto next_batch;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (remote_nr)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto flush_remote;<br=
>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 no_empty:<br>
&gt; -- <br>
&gt; 2.43.0<br>
&gt; <br>
</blockquote></div></div>

--000000000000dd736c0643546b6b--

