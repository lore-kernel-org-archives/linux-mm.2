Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE875D232C1
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 23:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E146B0005; Thu,  8 Jan 2026 18:52:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AA16B008A; Thu,  8 Jan 2026 18:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D7F6B0092; Thu,  8 Jan 2026 18:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE0CC6B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:52:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EE8F58359
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:52:46 +0000 (UTC)
X-FDA: 84310449132.12.8F8EE45
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1CBAB20004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:52:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P7Pg/A7T";
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767916364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wEL/9zXcajvLROQVmLKIcsrHgKz/mxopServ7m39ugg=;
	b=JaJu+c2eyWHENGSl3jbnvBdaiKzkTagRUSbxGfHb/cI90xgx23i+jYwRjRSBhN1DeKNq/d
	X+zRjp5xHLh0lCD1d3Vq5zcWiUWcRZabwXeThwWdFFZ1zwgTnhAKNAG/fi4c+KPPU/6QHP
	2Vk2Mq/0IWNdlTOtVi3+TY1ly2QKgpY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="P7Pg/A7T";
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767916364; a=rsa-sha256;
	cv=none;
	b=JY/EwhlNKmDXSc4abiKCAFeOVFj+kovocEwCgweVrOBbxSUaFJuzj4oja63qdUhLpeC38Y
	n0DYCrJ1owXjZ9a2QSIBUdnCzGbAufMClpiAxl8NCuh2z1sti7MJeRjSl+ZJyxeAjC9Zzw
	5SqjDV2AiyLSlOh3xdnKAcKCrki0+Uc=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38316d0c26eso7483551fa.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 15:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767916362; x=1768521162; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wEL/9zXcajvLROQVmLKIcsrHgKz/mxopServ7m39ugg=;
        b=P7Pg/A7TUk6o+bhU2yVFI95hFmJfRV7h1IHL5rcy/yoYIR4q+pgTSEtQzvQ7VNHWZv
         x6fdZsj3eUbm9gwmXHFc1qSkqzW/C12XyuQZLDQQrflKZm61Vk8dFxdS8cgwowYZGSOh
         z9xIMQ8t3PRQOx+dwKt5X362PbA+k5ToEroZW+i1dM+1eNi71QIDx9bdJNRZBJm2bVzw
         dymL7is6ZvbUwU3xAAluY/9ZmgZmRjEoEpbr3hr3k+sPiNhipSTcmob2lp1IW6AZs3yM
         DNJgcC/QqX5lPfl7UJ4Irh3VLNZCEG22AxdcvfHbhUlt0KXqU/GeesLE02sP2fQgKPP3
         QG7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767916362; x=1768521162;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEL/9zXcajvLROQVmLKIcsrHgKz/mxopServ7m39ugg=;
        b=xOYGDVPPyEktOkAtVBGv1YdruS0A2TuXhK6RyOdA3X1ii/dBCWSlm0Uo3pg9Vj8Vpk
         BF7A6i9OoPYfFE1o5YVahCJloexPkKhQeyg3Lei4ozqvCVgLj/6AvOqC9/nLANlULr3J
         Z5KywR/Xu1Lo1a+d+NXO/qlGp/mXdfWlkvCzjQ6VHHfjvNZfHqmpTX+7LmXwKSsjj5Sm
         et17krQK3zPp7TKLmMR6P6573hEuttvqa2mVjj+14BKrQpLr29eQb+PyS5fKhXCqaLmG
         /9xdpGlPtOecK3hc44DwohTN7uYYHFS4CeqRS3M8klw6iBkf5Q3rGVVZugux3zeaHPGX
         owDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW53bT6Mys22IaH/PY3QWK+/m2JT/BK+AUZy/e8t5lUIgkSrx8jrBdt9PLM+kGdOYRiW8DEkMUSCA==@kvack.org
X-Gm-Message-State: AOJu0YxcG8NPLuJtGSmlw+PhZZLTiXxoqYpLZ9c2VmSpgYEytCczxvzE
	evRJGZBm8ixD9h3mg5Uhl4mfg2ERJ1DjdwRNT10UFUbCqz5AF5L55PZ05Qbn6MJYn573U5dl7KK
	9UTZvMYPy3etEuzQtdh2xH5NV7QM0gek=
X-Gm-Gg: AY/fxX6DbPuvt1SE4dObLkCnI39T2+2NaFo4qpQfHA7ZbD9z2kHy4CyNk6KcgtFo3QF
	r/70xUOJgLQvO1BBSx4hRHEREIOoLpTJ8LvlRYLhKrqdLU3xU2i57p9rFbdkxmGnAymx+bsBRfz
	U+hGNsDUk8+mxbpcS3oPsydRYHJ5/cpBvBHrKzo/3iAFfSc3Zw0Sxu34pnTiB6SFCcQ9INSFSMN
	a5gbme8vlLVhzVTVyglI0onSS0ZAUTXlc6j77Xnl+3GBCNq5ZGFIgsv7Klm9rxuOKjZAQ==
X-Google-Smtp-Source: AGHT+IF3rDQLtGALRjniBqK3D9o6u645HHnFVB7fGXUVkTx3bagZzqe7m8TQRaVpuVOM/NquFAUCHWjggxvkwia+N7M=
X-Received: by 2002:a05:651c:1545:b0:383:108d:382e with SMTP id
 38308e7fff4ca-383108d3cccmr10655821fa.45.1767916361899; Thu, 08 Jan 2026
 15:52:41 -0800 (PST)
MIME-Version: 1.0
References: <20260108093741.212333-1-jianyuew@nvidia.com> <20260108111027.172f19a9a86667e8e0142042@linux-foundation.org>
 <7ia45x9bhg8c.fsf@castle.c.googlers.com>
In-Reply-To: <7ia45x9bhg8c.fsf@castle.c.googlers.com>
From: Jiany Wu <wujianyue000@gmail.com>
Date: Fri, 9 Jan 2026 07:52:29 +0800
X-Gm-Features: AZwV_Qje3yHX5SM1zbn4sdlx_lnQcLQFX23vvW2xUCo1k9X-1CudXgwbFnLtX2k
Message-ID: <CAJxJ_jjmBGmGDNpSKNBiiLx5OMp+b+C7GWcnrhO74TFKhDnYPA@mail.gmail.com>
Subject: Re: [PATCH] mm: optimize stat output for 11% sys time reduce
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, mhocko@kernel.org, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000be61d10647e91a27"
X-Rspamd-Queue-Id: 1CBAB20004
X-Stat-Signature: hw7o4knnsyhw9rp3uqfsjdsf3b1pj48m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767916363-293393
X-HE-Meta: U2FsdGVkX1+Eeb2oB3uWsJB/SxWxLjIlbYtD5sjg2RNdc1/bmIhLLDttHS2pvLd8p8t6AAI3hpMl/NBV+BkY3RO7P51iiSNlwWULrbRQcRgVimsWBSSRilPY50qIFUAvwQr+qyv/eo1Nj3SbU5s3frCvWXMPBemiaD6LiafGQg7E2Ffh2fdA0w/TTqdLW4q4tPzdQmErk/tHG53+JU4Uv8RxAbh7HnWUJFzuKfwXP1g66Y0cE+VrNW7BLyllMZqGgEMl3NWUaGbsSEU+vHA3dScelS2mhXt/dOswA/8SEqOxQWk8RKvD0VNquZng9TQSzoKchUAcU5OSYFxRtEQw/NnREumAllcMqaK8GNVowz2EKMidCM8zWIL6LPHLaOdv7LUc9iJDUwv1b7WIH/0L89G5WEifvq+Uy3RUXvcX0fUFctOjQZJuu7jDnXgkVCX6QQ0zzytr0/ExBA5MLu1UQo7fyl1lgJdU3CNWMPU80qxValqsG0hzCWZjM4rs5Fb9vvNVESoNtwJ/pQHa0NS1p4f57V/W+S0yZzjX9Y8x7Ifc9If1s2oIClQowE63x9hgQ6ffgy6spY/jj3jF8HFkJBjkyuYUCVFjHdbJcEeCHN4/nB52oXqj7mPyl6pzj09kGDwKre9LZVtsw5ZNPy3bNweaWZG+P0e3iCd87zUtMOK42uHjmtMP5orCsG3SWQRZDwCvS0zWGPQeLg6b/5XI1wpDfxijrIlk7NNX56psqnDAdPDYgno2LJNaP4aDtLeTgwEfTrgdrW+yZ2qymakPVD/c28DLi92TPcHWopj7PKw1Ra2j2nxU6g48p8hV497Okc7p3SmozrYSRPkkz1ZUoYkBqplG2RgqMyC8kJBvZYZOG12p2t5grEdGrPov2vvj6hNCYbTbnrAEuhJTv1iJnRqsKfdS1oxi+M7ncsMMeC6cdAP/zHyd8yqs2ud3m7fbvhow1B4hNkmsHZUN2ev
 GMnxP3dE
 M+mC1wCUgMC/T1KcY3AZNBtj5gjRFSp3iYo4nIcrstdmEQeC4oXvAtoV3pBnKXXJo5yW2E1N6g64+coJjl30oIbibFzUeew9haQRIo7zBAzcWqTZuT5Th61YsSQCdlQY2jVfAVblNJ7DvjTH8a+XEOjLBLiRNiuThTMQX5ZMHxbcGMoX+q95Xx7abQt5dUXpbOUSRgCUsfLpvrAuBLa1FEIfB0thg0/v7SJBc3pplZBzjBX1cNXc5e1dlSn+OtmcFhe1mQqLcvO9fdvIEk3hMWXsOYkaEmXgTuqvrqrKX51ItBroyTpKrpapqjSxSU9xPgmatYddrQ7H63eL0C512Foj6rr8IS9+mrE2FoGZh3gnG1SCzW2tU5cGh8b33alTx60hrigqhFLUusfHnQ3i8ncw6ayjaasRyGqstt0Sh4HCg0CxAq7QIKg590sQTOp1Qy1xbLvGyP/VUDKpcDOq2PYWTHgIi8kSaUFl7qRbVoA/etidupnT4gH0dSF80SkQ0u2Avg2EkvDQQkwqj6kLA32GGPF/DKo0WHsYnYdIB6T42kaBJ03Qa8PuBbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000be61d10647e91a27
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just checked the BPF kfuncs patch, nice, speed so much, I think better use
bpf to read, instead of normal read.
The workload normally is read about every 2s, but there could be several
different services needing polling this.
Yes, previously the indent was hacked manually:)

On Fri, Jan 9, 2026 at 6:50=E2=80=AFAM Roman Gushchin <roman.gushchin@linux=
.dev>
wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
>
> > On Thu,  8 Jan 2026 17:37:29 +0800 Jianyue Wu <wujianyue000@gmail.com>
> wrote:
> >
> >> From: Jianyue Wu <wujianyue000@gmail.com>
> >>
> >> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> >> printf parsing in memcg stats output.
> >>
> >> Key changes:
> >> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> >> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatti=
ng
> >> - Update __memory_events_show(), swap_events_show(),
> >>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> >>
> >> Performance:
> >> - 1M reads of memory.stat+memory.numa_stat
> >> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> >> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> >>
> >> Tests:
> >> - Script:
> >>   for ((i=3D1; i<=3D1000000; i++)); do
> >>       : > /dev/null < /sys/fs/cgroup/memory.stat
> >>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
> >>   done
> >>
> >
> > I suspect there are workloads which read these files frequently.
> >
> > I'd be interested in learning "how frequently".  Perhaps
> > ascii-through-sysfs simply isn't an appropriate API for this data?
>
> We just got a bpf interface for this data merged, exactly to speed
> things up: commit 99430ab8b804 ("mm: introduce BPF kfuncs to access
> memcg statistics and events") in bpf-next.
>

--000000000000be61d10647e91a27
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Just checked the BPF kfuncs patch, nice, speed so muc=
h, I think better use bpf to read, instead of normal read.</div><div>The wo=
rkload normally is read about every 2s, but there could=C2=A0be several dif=
ferent services needing=C2=A0polling this.</div>Yes, previously the indent =
was hacked manually:)<div><br><div class=3D"gmail_quote gmail_quote_contain=
er"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Jan 9, 2026 at 6:50=E2=80=
=AFAM Roman Gushchin &lt;<a href=3D"mailto:roman.gushchin@linux.dev">roman.=
gushchin@linux.dev</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">Andrew Morton &lt;<a href=3D"mailto:akpm@linux-foundation=
.org" target=3D"_blank">akpm@linux-foundation.org</a>&gt; writes:<br>
<br>
&gt; On Thu,=C2=A0 8 Jan 2026 17:37:29 +0800 Jianyue Wu &lt;<a href=3D"mail=
to:wujianyue000@gmail.com" target=3D"_blank">wujianyue000@gmail.com</a>&gt;=
 wrote:<br>
&gt;<br>
&gt;&gt; From: Jianyue Wu &lt;<a href=3D"mailto:wujianyue000@gmail.com" tar=
get=3D"_blank">wujianyue000@gmail.com</a>&gt;<br>
&gt;&gt; <br>
&gt;&gt; Replace seq_printf/seq_buf_printf with lightweight helpers to avoi=
d<br>
&gt;&gt; printf parsing in memcg stats output.<br>
&gt;&gt; <br>
&gt;&gt; Key changes:<br>
&gt;&gt; - Add memcg_seq_put_name_val() for seq_file &quot;name value\n&quo=
t; formatting<br>
&gt;&gt; - Add memcg_seq_buf_put_name_val() for seq_buf &quot;name value\n&=
quot; formatting<br>
&gt;&gt; - Update __memory_events_show(), swap_events_show(),<br>
&gt;&gt;=C2=A0 =C2=A0memory_stat_format(), memory_numa_stat_show(), and rel=
ated helpers<br>
&gt;&gt; <br>
&gt;&gt; Performance:<br>
&gt;&gt; - 1M reads of memory.stat+memory.numa_stat<br>
&gt;&gt; - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s<br>
&gt;&gt; - After:=C2=A0 real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% =
sys drop)<br>
&gt;&gt; <br>
&gt;&gt; Tests:<br>
&gt;&gt; - Script:<br>
&gt;&gt;=C2=A0 =C2=A0for ((i=3D1; i&lt;=3D1000000; i++)); do<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0: &gt; /dev/null &lt; /sys/fs/cgroup/mem=
ory.stat<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0: &gt; /dev/null &lt; /sys/fs/cgroup/mem=
ory.numa_stat<br>
&gt;&gt;=C2=A0 =C2=A0done<br>
&gt;&gt; <br>
&gt;<br>
&gt; I suspect there are workloads which read these files frequently.<br>
&gt;<br>
&gt; I&#39;d be interested in learning &quot;how frequently&quot;.=C2=A0 Pe=
rhaps<br>
&gt; ascii-through-sysfs simply isn&#39;t an appropriate API for this data?=
<br>
<br>
We just got a bpf interface for this data merged, exactly to speed<br>
things up: commit 99430ab8b804 (&quot;mm: introduce BPF kfuncs to access<br=
>
memcg statistics and events&quot;) in bpf-next.<br>
</blockquote></div></div></div>

--000000000000be61d10647e91a27--

