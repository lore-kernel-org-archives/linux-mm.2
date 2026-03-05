Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B689F30946
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959DA6B008C; Thu,  5 Mar 2026 06:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907C66B0092; Thu,  5 Mar 2026 06:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA2B6B0093; Thu,  5 Mar 2026 06:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3E96B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:40:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 140C21408E1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:40:02 +0000 (UTC)
X-FDA: 84511815444.05.66F958C
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12914C000D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:39:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBzjnndT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772710800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trP2W0oN4p19Y5VrVJ4Gqg9OM1UXsvsrtCfj/w2m4qg=;
	b=cuDOVRqpGWNsIVsSlmBwH2Cbo2qtqPMN8z9ZbuDXveMknwF9nqkZ0iZahB7szcfQ3nitf0
	Xh4gXBEOQvtv34do3yEXauzceFGjYz3FoPrri5B+AEvOu/0xkb4RrrRGV6ddYV0e1W4FJW
	yDMjghv93K9lpl5ZWrpZSQP5kEok3Vk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772710800; a=rsa-sha256;
	cv=pass;
	b=NcsyjCV8xpFDr/rcXQzlWY7a601M6+7bzvl2SroplcMR+wIdE2FOEb3FvYUhFlLQdU8m21
	RfBDzvywX8T1Wj1DjxFjOAFmmOG+sRnoR4gFKHIeDWhNwj/uyrR+zHlJ+ZF69R+TWYwa/K
	96Skm0bgxrJFkjE4yKokEZ0g1SxJN4U=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBzjnndT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of tytanick@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3870df2331aso65980301fa.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 03:39:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772710798; cv=none;
        d=google.com; s=arc-20240605;
        b=hGasJA9jmBIxAxbok3jGXLNRbRh6W/N+S0cvti33alWfjHKZMyU0JbkFkti1YtsYGG
         K569aWrzZFSkrDLqGvD3V7UeHFC/H05bq/4MNdNKV4c+hz24k1Bfz8xRTM9CUhiWJqoe
         26Uqz7T7Pp3cEwRfsEZKGwGSIBnduIuSvboYUsfEEDBlsZKO+O0w3w1wT5XLF9xE4kYk
         5U0VNTn4LN6n6WpEDb/GM483ZzZjdWwNW+V17qvkagsn/0hrRUpBIfoQDirIE7UfHb0m
         EUB01KdRpOg8QcQIo2+ajlzAtv/+zvCSd3HiBDmtlc0/aAuuUCfhJE8coLcyBod9CscX
         PjMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=trP2W0oN4p19Y5VrVJ4Gqg9OM1UXsvsrtCfj/w2m4qg=;
        fh=kyW0xutFlYxYFoDQVssd9/I5tYG5xp9dlVzXsPR5j6U=;
        b=k3th8ro6InSSwiIlUm9ig2ZK07yImk65yfBe6+rAOBhrABK/SO4iwOfdZEYmBSBDiK
         SxwzWhB4a2FqXhChc4p8asomE14wAoDAFRTFFpELjGJ9AVVHAdcsCwcFk5+vhKYwFUH2
         jx6tPf+2fIEPFVBw4hhxtjnRS+fcBSz/kK4lW3ggvy6mbwMphSBfOiyqDhXje8lpl+br
         MeytGRT3wFpzsujeBI5gjuBfYP15t6hBTr2yzeJ0N6JPazbWLx5jsBiBpkbg8+YnBKd4
         OGA9/t/IzQ7eof8yYxdU89xxcRUfr2rcTizNq87o9XGzUmPIpB2/GX8m4FMYhtGG5HhI
         9+Kg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772710798; x=1773315598; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=trP2W0oN4p19Y5VrVJ4Gqg9OM1UXsvsrtCfj/w2m4qg=;
        b=kBzjnndTsiMfJWRpZIOzE6fkAXBIq+JXNaFDAb3yOsMYKhixPpP/aQJeCJ4zCMS+QL
         6i0azJ8LjYyGlJcoB+bMX1RSRK5m7owyEqqLjjeMiRcMsokNfZ6fkkUy/GyoyoPBIiEx
         DTjYps5BEF7OCI8KCBWrAyp/F1l5SL043UaujknV7zzVRlFDTpVxo4IHkH+lhc9lhVae
         jmEpJa5XBQ+8IVF1SQJsMqupRr3lhmYJeiUW8eoiPkzjzOq8khTjeeWuQDPRI0eyisiR
         NccvVepxO+0mMr31ydKR8Wkg5DnbR04imkal/tVwSdYqChhjAKouW4qMYWS/C40wDwEE
         BVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772710798; x=1773315598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=trP2W0oN4p19Y5VrVJ4Gqg9OM1UXsvsrtCfj/w2m4qg=;
        b=Tr+q+F8gTr+NaZjFWVJ28mghroSElsVRow4VyyofRXVT1gl/Ugk4254pS7P3FB8BtO
         0vzmIUsd7sJFcZXiGT+IO5BpxMoNNlB08e6JDpEWCKTtPmSVdAJGqqpk2/r2YliigzgU
         s+dOprZJFGo6lC7iY/hMt9whVYR3njXfXta3ok71fKGKySkWedn+mt5PVVBSYuGj+ifk
         80zDwXK0gLwUYxMJldy3vJSBvGglFeSwwp2XWDZ02opbVnoPjxcu7Ezz0YxBLLj0xkkE
         lqztQSylcH/dfAuruyr/uwrXzffMDR8070tucC6oD+Wk8iezXmpB1TptuWyamw+rrhs2
         VkTQ==
X-Gm-Message-State: AOJu0Yw/6smCTRi9xkvZcWBUoSqtb24vSRR5K4htIxIMXGRen66K74Nt
	nuV7GU1V2DVnIIQ3sJirwMEc22WZ1WuIBW2BXBXFVDfmraRyINfr/cBb5GiKeVFeAQK2vQCaQ9n
	dDzlE26jC07ebru/XIspWsKEcJnCGKEKaPv08
X-Gm-Gg: ATEYQzz/jpJu8KZgSB7w/t5xButlS4iXBAZdwh9fLIhQ+k0SMFBuk1ofnmWLY6/Jwgu
	DQ1J+fAlW5IkuOKJ4ekWiBqiBlz+TkXbrxVHXMZ/802Ur+9DRpyxyPlwtYew1EPhXmdsT9F8YON
	rPW+hFDQys8DWFUlM7Ewmt9GCCEKLQcUbVYzefESF9wp/n6STcFGh5duEM2mZmv9ByndODPogv4
	sJ3g33fxEhjbVpqSjZYWzVXfohi+6OY4GERvUTn+c1uu10RopW7suN06Wz5T8Fv6WTbOdk/B6fy
	Ax8DAYAKTl3MQzILkfklsMYiBUiRqNphcU/ioG0ZcqFNu1UpYk2thRie9+UQsHxAq7PAEQKjFDx
	/dekCoW5B6Fvifc47SqVCr5+o
X-Received: by 2002:a05:6512:3c82:b0:5a1:188f:3038 with SMTP id
 2adb3069b0e04-5a131ee54afmr886069e87.3.1772710797972; Thu, 05 Mar 2026
 03:39:57 -0800 (PST)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org> <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org> <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org> <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org> <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
 <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org>
In-Reply-To: <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Thu, 5 Mar 2026 12:39:46 +0100
X-Gm-Features: AaiRm51pu9uAWt2bc51DiyJcFutnByg1_nmjLiXZaSNUwMuaNtKcbrvZ1QK1Wi4
Message-ID: <CANfXJztyrv3Bc-YtTWX64+tEWNGQE3cOdjs6PkAvR-aGYta-ng@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/alternative; boundary="000000000000671b0c064c456528"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12914C000D
X-Stat-Signature: ymbeajwrkxbphn6tntg3kpwy4s93631p
X-Rspam-User: 
X-HE-Tag: 1772710799-410082
X-HE-Meta: U2FsdGVkX18NqmUMY88kGehk6wIPZ8ms30pA8jM6761Bcxc8aKlZEXWJFv+iyo5f7PzmsbK7Ive/qNJCnWl34glXsuTR6hfByYDUkeaNWDejqcGv1CTIc43EkxO9WNNOPQWqTnHDL+uyGfwfedzjzKPOB9hxMLNeH3WF7ZOuMf7IAppEuqVCR2R/Wl1yo/of+RFfy5Xqlj6ysjfO9uCTsCiS/T9UKiuAAOxF0zsNU7/U75g7N64TXxCfPQ9gBHt62tmUktn+87lVTc47xvFxuv601rM0HQ497pnG4/gsKWrBACxTdcon6quQtsOardIgsNHj+tzGGGLp1NuFfSEuAQ3WWQBHVnc9sbvgMlEUTOA4wp0ixB9gVJi4ngpoNNyM2GFpTTfcA3kBJTtdo2DUNKqIwvHAuA/BkWu8qWpqKPiQKokhTlgrf/eun5UX0SHFvbXyhO/YOIdfO7KpvNcAP2hfDYSWijBtJbp/jbR9RiPZYa/17hLrlibhmop6/Cn5RVU4c1Gm77qgl5z29vIKV2qNeVQeYfH8nGgUsxASlOHlFI/++uMBYYNi7CBcJLXpk+HKx2T8gtJrRmQgjeVxHzVG2NGAdsDXzDz+6hmHud3foLYAVwcE8jH81uCu983c1uOck55WcRSFRwT9VqvNT9yhkRZn+lCz3n40PMHqCtUIWqUPjN5W2F6JLghTodgxkLT1oV5m30vC+6X2OLUcZ9416zDi6BmpHCyVQv/DdoT3oxnjEnrgJOKv1mXgpz4AADDB2C85RUriTF5UMQFAwfQGn0Gb1pvg3X+JtfOILdfoO0oGvmebu7lCjqCUbpxhCuEsG+/+SUYaEUJSEoak1EXI8K81Gl9pFUG+J1n5SPE/D4cZZvPLO3jtoFH37z8rl9J/9D3h/sfylF++3keA+sQpSaOAgTdCATiCKrW7ypkYiINMHT8E+C6TSelXxa0dnXAqJr/Ro8Xl8KuGji0
 XUt/7wbe
 vnUVIfXfT/zYo0nUGZwpuvWk2goDc9u149PAZKY/UPcfP5+wc7jaUrOGH49/NYnUvKVpVf31Dt4/wYZEztwkluJoxZoYhuId7GsskY63ejzPNmcjfCpMqZEBTRzsjNb1nZEOdl+aAkktoISkUYeCawFRhHQnMKTmMjYkGkPxvqDobAcJ1rb894aaWMes6BH3dWXgndAczbJfNUKUezPwfgSWiWOcQkL3T2bLZ3W60UdTXq2+wrvGv1zajpl9XOYUcYAndrUmu7Z7DiwEZLdEE9XoD9f02WzBWUELvOio+Y6J7z2RvZlmZYxQL3vSjp8CKO5oknVjQGlpuI+c9DGGx4JKH514hwLZJRuV5rLN4z+8fHhY2jt+ARCsd1fB1N1HRtrxnztZ/ps7j7h1dr8NCNn6wwvi/EdiW/qGcXwC5NWpQKfLqEvNJrYVyjxEMmGLOxccPpNT26eIQCLs8AHeh0x/B1f/uOPOLR5pGcMDNJ6uTt4nzMvIcwbVJ6yH8WFEMYgsHalOSpnuKc5YniFlQLj1N3Vr8fdh3/3dFBj0M1pSE453w5ZHCRr9K9GvRscSr5gWyX9XAVNpVTuixm5gOBAuRbcxoY17dqmAYFljcz7wFDJFkn7mGPp694cM47OIJeRsZVoJ69agaO+Jf2/2moFdO8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000671b0c064c456528
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I had this problem on 6.19-rc4 yes. I saw it. But i cant reproduce it NOW -
this is what i ment  :)

--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


czw., 5 mar 2026 o 12:38 David Hildenbrand (Arm) <david@kernel.org>
napisa=C5=82(a):

> On 3/5/26 12:34, Tytus Rogalewski wrote:
> > Well, i would better not as i would have to put this on production as i
> > have no idea how clients are triggering this in their VMs.
> > Cant trigger this myself.
>
> I'm confused, during your first mail you wrote "It happens on multiple
> servers (less on 6.18.6, more on 6.19-rc4+)", implying that you did
> reproduce the problem on 6.19-rc4+?
>
> --
> Cheers,
>
> David
>

--000000000000671b0c064c456528
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I had this problem on 6.19-rc4 yes. I saw it. But i c=
ant=C2=A0reproduce it NOW - this is what i ment=C2=A0 :)</div><div><br></di=
v><div><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"gmail_s=
ignature"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"lt=
r">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">czw., 5 mar 2026 o 12=
:38=C2=A0David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">da=
vid@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 3/5/26 12:34, Tytus Rogalewski wrote:<br>
&gt; Well, i would better not as i would have to put this on production as =
i<br>
&gt; have no idea how clients are triggering this in their VMs.<br>
&gt; Cant trigger this myself.<br>
<br>
I&#39;m confused, during your first mail you wrote &quot;It happens on mult=
iple<br>
servers (less on 6.18.6, more on 6.19-rc4+)&quot;, implying that you did<br=
>
reproduce the problem on 6.19-rc4+?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000671b0c064c456528--

