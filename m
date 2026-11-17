Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE5E606B598
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K0FcGH8O
Received: by kanga.kvack.org (Postfix)
	id CF5156B05B7; Tue, 17 Nov 2026 04:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5FB6B05B8; Tue, 17 Nov 2026 04:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B983E6B05B9; Tue, 17 Nov 2026 04:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968A86B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:44:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2870DC0388
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:44:25 +0000 (UTC)
X-FDA: 85444125690.22.6FE308B
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BF404000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:44:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K0FcGH8O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jvp97r25HY6I4Tk77YIQozbYjUurzIa+WyihaeOsAwU=;
	b=l0fgU76Nn7Ykl47pTB5FRrn8hwkKAJpYJg430egt0ZA1hzUpgSUHafldHVsXfUGzspZkck
	3hwI/5qsxif63gr6pMjuilSN+Wk4HMfyH8Dp0kiyk8fjXUDFlTzesCNJ8K/5nSNPH/A9+E
	qpr16T/BlR4S9j2WCw0JZZ0vCb0Bauc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K0FcGH8O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794908663;
	b=gtNvr0nsShM51PP5CP2mcVbr2w2TrI6XfwOuZ/CLRIOgXBycasipqgT8dCU6q1AerKhRbp
	oYj3hJTkYxzdp1IEQ5/zLWUsEMJ8V660pl69PUhxuw+pHcRk++DaE9ac+KeH8YNHTKIQ91
	SSTmTR2hGw66s18FwpH96n5BZyvjv60=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-862d919fb1cso738302a34.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:44:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794908662; cv=none;
        d=google.com; s=arc-20260327;
        b=ihnibKC1Cl6gkdSEX8rBdqiHJVr4UmQyttJRlKowH85UKAcDnGUhdalMEXoMlAcW0V
         VwgqWTyxzdiG+enjP4dkjQ2+HrDJh4IyuIRekO6e/FM44Bkj3PvNxj/JQIf2UTanKrHT
         eoWXYtmJMQEjGUFYZigA3v6sn5EcfLs1+f66zfmYG5QEVNL9zTBL4PjJ/OsOpg7AiExl
         0U6CQy0WjbCMgecrQEHE/r4b7Vnj9J9suS24f2a/lrTzlMV7/qLvgy9XDkHnyYbTRfJC
         4JdXnxNk2MUFhDMnLRvJDYutDBJ3xD+8mfgW5cd7FhsP2V5enMu/pyeE1dV91Sg3eWH2
         Po4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Jvp97r25HY6I4Tk77YIQozbYjUurzIa+WyihaeOsAwU=;
        fh=/5R2ZoLtAa1YgvbKxKyb1J3FJdM7LwmmF0j2yoVfffg=;
        b=ekIKsdo57xJTtCjo7PnCKP7T/7e0RPvlBtKh2xG35rqtpLBzrQFdlmfZKtB2CAsMEH
         jW5f2OGNWFba7BNFNQIJdyBSzHM9UdyrQluHu6nMnOJ4TOaK9S5lQMq0DtSE/B4s9ATs
         6nktIZBe79W3FnHG/uETc34GL0d/4+KiUpinOk+oSUU1/KVzsK2xNXk86OKp65DXb+NG
         VqLSj4JVo9G9sAM4Uqehobhvja62e4y/0mbWD1x+qPdmawW0doMCPgN3WZaE5sIR/Cvm
         LQDRmVtxS7gACkVCJrfWPfwkMbu31nclTq2aYcHiXa2DW2HII2HpJMPYrSxyLfCU5wVR
         v3LA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794908662; x=1795513462; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jvp97r25HY6I4Tk77YIQozbYjUurzIa+WyihaeOsAwU=;
        b=K0FcGH8Omcl3YmLc9VXhCu8I9CS6EaseeJgf3nLuJLRrfMqpc4auaO/EzLUiy436bn
         dPm9Rt1xjEcxuX+CAWTf82DwlvXCHzCD5HVTgMv4Cd0BB65L1F0P1103hMdIGeIrFwyQ
         IegJx9YFuAHfBibRjDFZ+po9SawqMcStfVaf+L2Td9t0CvYFkeAshwbkF0AcVrteXVi3
         ZRJulmWE007QByezSJliL8a3pRLTfbztziwEKzHxA/vylpyAzbhEypVK8mWWu1mE38w7
         3YVmmmK+lH39EzyxXWc7BM6O+IRXyjOYQf0vOg67O7lBf1k5vlL7pntzUF8vpErQbods
         to3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794908662; x=1795513462;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jvp97r25HY6I4Tk77YIQozbYjUurzIa+WyihaeOsAwU=;
        b=ln8WG+vxqEnfaf3uDfXS4Z46Mmn8Z2+Yey2Yon+hXbdUKYs79wAHovSeU6zYOjV410
         Or6zSqfEg6aqHYq78Yum3Hdv2uwXPvAyUdLI+Ps8+n7/+5q0z2rX/q8WSaplc4HNK3hD
         oMC1vm0o7rToG4skJoWg20tm5Iy+oI8bnC3qbpcpBZNmK+DAbi7WF3cbyCNwoCCziejs
         XxpBA6xBqnSFcOcA0F4dFmwG0RgWi/sxp+NzGWHMVnZQLVeAymQnQos18UduQKd89Snl
         F4URMsJFazN7VJaTgaP/bV23vZUp9tHPcX/UfFlmpzDPBXOQoLF9qdmirUcPq4lMRMZP
         TmQw==
X-Forwarded-Encrypted: i=1; AL+hErEQJCQlj6YskgoA3EckdxX91VqNRH9TEuIVfgg1Ac+EMEiTlClF2s7IwBh2iY4af1hyYMGjWpBn1A==@kvack.org
X-Gm-Message-State: APuU4Z+g7ydVnQbFcMkWAUcAP5rrENi+qIE5h4oOwU8ZE3NEsEQQ7CGJ
	Gv18hLQ2ByI6QsN/wseZxHzR+dolnQBukGqW+0Z7pwnLgFHlE255OXSrqrl2H6sI6wjnXGD/a1M
	isTKjj63kb0AnRcW/2VkSV0MNCTh3O6c=
X-Gm-Gg: AYBFou0yQZuCi3eqwtDWrJJ1zOHcv+PsQZAgQqF5RvAwBCbvmXDe9kJwJvVy1AN94bB
	B8CBUJ46UsWwyTd/750dyFMSQWQQ7kKU8jXUA+I8z4SXxuoCiVVKMDbVkSJCgXnoBlsfNEs2KLC
	KXLUH6HdmvrUjBYGGVbJY1hjp6JYmrsBirNw7CgTrp5mHicSGWMd88TqpQ8Ic3R/3OGrhYxvytn
	sS+sWYhfkwGyhUtOer7rzYnbqd4zu5IbHqr/vej65mn0vh3K5053pZSW4BWXSe8JSXTIy7EZ4Ad
	lWHgSSXxC3BnuTn5v7/ZgiSAWS/M0J0PopTdC8O+N43dD7og4p1p3USswbOgKSzeHEohyC/0Vzg
	JRcsWAiQdwrR9FBo+zom+W7YsEslYgtOqYhA4fXbW5eh0oK4sntRzy+JYsXp+5TdlkaYTDYBkCY
	jcY9Xe0c5A+N4x
X-Received: by 2002:a05:6808:2224:b0:4e7:851c:23f5 with SMTP id
 5614622812f47-56e6592697dmr12375542b6e.59.1794908661953; Tue, 17 Nov 2026
 01:44:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114181034.2665113-1-devnexen@gmail.com> <20261115173343.82437-1-sj@kernel.org>
In-Reply-To: <20261115173343.82437-1-sj@kernel.org>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 17 Nov 2026 09:44:10 +0000
X-Gm-Features: AclHuK_g5d82mfUchBB7OsssTaOW-D8EloZD0gbzRPPRX5ChSqc5rlA6yiWsHug
Message-ID: <CA+XhMqzS08J_3oAvKZnxifdmuKhLXcMsnSym-_7nbAYpb6yPXQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm/damon/stat: avoid 32-bit overflow in idle percentiles
To: SJ Park <sj@kernel.org>
Cc: Aveline Noir <jm5905938@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000333926066075bd08"
X-Rspamd-Queue-Id: 3BF404000A
X-Stat-Signature: bnxyar4tmu7occqhwkir8kphi7y8oph7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794908663-457231
X-HE-Meta: U2FsdGVkX1+2b26EyuGT8E7TMNSucj2W6rGgMgTYMWVDYUghemT3KRoxdZaLXGuS9+q6mDSwLAkAm+1MhRqUbn9x9YYXNyW9KaxkBPeIDKp0GJtzvja2DLAw2YMFxq9JdiRKz/yGJV2eBKU/znr8jmYVDIHVewzOuNjXZx9iGofUX3TAOY8EI2QEmLN9KXhABLu3jltNKQOqr/xYk4+28BOh2IY/xkQU125equbuYeFsyd+1FTg3Q9vN+/S2c609vZd/044sgwHt1rRkwksG31yEx4kdbK9RiM9RSFZiTkcEZyX1CIjb9feITu0SzTJ9vBlHCKMDBFQnzoSavcqAei5lJAwb6Yzr/b04LDNZoMGAI+P8r1Dhm3fauGWPXsh9jDu3d1frd3QnY5z6jLMzH5yWiKOZpQ7A30QDNzX24RgfVQzJIhAuERNpSbedOb63fQaNuCzKBiL8qrzOtre0X7+o4xxsWldh2EPYmgTogIj+FsgY9gyTLsiWIMrMFr9wcAO9/gTQfdeWw7kdE548k5i/X4yBPS9q5v3ba0pSVgip3DGLLNn3OknFJuBvn4rh2N5JyM5k7nfMne6PzmXMnq0wo7JbWCBa42FJd/aU0+aWAE5/ZiMg+dH9DTwdNs211Mq5ADnPfdqXp4lhKbcsay9nnUSV9ERWDp0OJkDH5yb6kyw3WPyZb4dlVyLnizjIVF5PVA7w5uny5YsAInNvJfZhGmSJltd1th2m3hVEVLl1loK8qSO17Pj3pyt4f1ssI1FlcNwsr10HJj33gP2RxRFgJxG0gjryAin3g3Chg9fC1uOPO5WiKWWixC2XkZLqDBxAmwzW5y5e/2BDCMqCuUj5wFDJ98ej0MJT8w2Iyr26rTFsokM7sZRBhqNsZoZ3ALioN0JDZHmJC6kW9oeaL1sA7awTNDUvJaej8yfzFWPerAtnskwil0w3RU6sscplOK8ompRJujKym5n0uEa
 M7l851V+
 AvJbz5ivQdD92Krv+esx4teKVha29ghM4HKnCxBygHMpYMVOwjyNe9tDWhaGZiEn0jh0oKilbtFBjVPy5ymv10wpy130aKlZiD8hp0ersYpK2FNFdLr+OGdW+z1tha6zBs8D0n6UdagUph+i5tywp7PVVfwhI+ule40CKSDxNQP1MTriLBWmDyQMIY31lLCqi9YSLTGwAm1ZFcJs1L3S3WJQmXMjN/HLRy7tPuzjxak3XP/E+avHaQnpPmSIs35SY54MHC47alE/oGSEwvGPk/k6deyvpO5txgdEH/L+AbFpbs4LPqndcuA+Ow0XvUGmjnM9+CQ2aChBvmYYDG1xTzAq+yJVEBSE6l9doZlT35mnJWPQ982gxS4IG1o2LgflfJ5STn94V+AbxkKOmzi+i9jUjrgSZ5bY7M2BHfSyxAxIzIm5mWFhxHot1+V4pd4qf1zPN5NtgCXSONDNS0PxowgJUsoWDMKpN64L5nRBYmTGht5QbnAGa7cm4B88T/LY8W42IjyAE+YN1znd9cSuRU48sww5eb8kH+wSwPeB13OfjMvvtFigRzgoDvWsiHu7k2bN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000333926066075bd08
Content-Type: text/plain; charset="UTF-8"

Hi SJ

On Tue, 17 Nov 2026 at 02:23, SJ Park <sj@kernel.org> wrote:

> Hello David,
>
> On Sat, 14 Nov 2026 18:10:34 +0000 David Carlier <devnexen@gmail.com>
> wrote:
>
> > Hi SJ, Aveline,
> >
> > The value stored a few lines below has the same problem on 32-bit:
> >
> >       damon_stat_idletime(region) *
> >       (long)c->attrs.aggr_interval / USEC_PER_MSEC;
> >
> > The product is the region's idle time in microseconds, held in a 32-bit
> > long, so it wraps once a region has been idle for more than about 36
> > minutes, whatever the intervals are. The cold-end percentiles then come
> > out negative or wrong. Doing the multiply in s64 with div_s64() would
> > keep the sign and avoid it.
> >
> > Hope it helps !
>
> Yes, this is helpful.  Thank you for sharing.  Would you like to send a
> patch
> for this issue?
>

Yes I sent it, thanks.

Cheers

>
>
> Thanks,
> SJ
>
> [...]
>

--000000000000333926066075bd08
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi SJ</div><br><div class=3D"gmail_quote gmail_quote_=
container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 17 Nov 2026 at 02:=
23, SJ Park &lt;<a href=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; wrot=
e:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello David,<=
br>
<br>
On Sat, 14 Nov 2026 18:10:34 +0000 David Carlier &lt;<a href=3D"mailto:devn=
exen@gmail.com" target=3D"_blank">devnexen@gmail.com</a>&gt; wrote:<br>
<br>
&gt; Hi SJ, Aveline,<br>
&gt; <br>
&gt; The value stored a few lines below has the same problem on 32-bit:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0damon_stat_idletime(region) *<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0(long)c-&gt;attrs.aggr_interval / USEC_PER_M=
SEC;<br>
&gt; <br>
&gt; The product is the region&#39;s idle time in microseconds, held in a 3=
2-bit<br>
&gt; long, so it wraps once a region has been idle for more than about 36<b=
r>
&gt; minutes, whatever the intervals are. The cold-end percentiles then com=
e<br>
&gt; out negative or wrong. Doing the multiply in s64 with div_s64() would<=
br>
&gt; keep the sign and avoid it.<br>
&gt; <br>
&gt; Hope it helps !<br>
<br>
Yes, this is helpful.=C2=A0 Thank you for sharing.=C2=A0 Would you like to =
send a patch<br>
for this issue?<br></blockquote><div><br></div><div>Yes I sent it, thanks.<=
/div><div><br></div><div>Cheers=C2=A0</div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div></div>

--000000000000333926066075bd08--

