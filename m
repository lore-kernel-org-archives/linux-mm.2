Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D9DCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488426B00AF; Wed,  3 Jun 2026 15:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F406B00B3; Wed,  3 Jun 2026 15:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375E76B00B5; Wed,  3 Jun 2026 15:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24EEA6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:00:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF9D4C1E3E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:00:12 +0000 (UTC)
X-FDA: 84839516664.17.AEB6582
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id D71D51C000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:00:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vgw8DIld;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780513210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIA7OMH4LElTq822fWlCipSn1JAPio6YUtyo30XPXHM=;
	b=iOgxlapNex25Mo0vYi54ThZEOs26vOJZVD9OxCE8r2/99/ZS42UFH14jCvpurjceS4Jic0
	+NiduSmzDHl7VyeRM9PVSqBJe432kms5oaZKZ2M9UhkiPZ6ZL/i7T/wfUXSmTnPjaNcBpr
	em3n8mrg3ns0xIuMmu/qTybpSZPn4Iw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vgw8DIld;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780513210;
	b=ZkKqnfnMhx2dIX198vm84Yg1XYm2n/MwW9NQ5sqE+0cNm7NUp2AbAeTc7aGfY0N/wKjwuB
	lmuJGsjryxYvK/dV9Uzgqjd5c/OT5a1c6APMEw3GnK3X5hVH64LYlad8tb+7LcgRWucBkB
	2QCIlzcfvbtyPtX6zYYAhgI0P7pNfKU=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765531803so111891cf.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:00:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780513210; cv=none;
        d=google.com; s=arc-20240605;
        b=WE6bNJ1pPpsK1v2xve10Xn4pzaNx+AAkThSuSL5TCZi4cbFrlKrDvJpiGdi4xf9xIQ
         2GB7FeUYjOm+mRL3n1tzqcJ93jgn2c4g05S7/7gjKdp9g+cBsxLLsp7YrmGkLB0C03eh
         9N9US8m2L6ySeMnDZGdMObAkDAL5zqIVaYPjE0KspMXpwDZzXn6BT5x1nSoOdcdFHnRA
         kzTA7AGlBDI5M+7Ztjsx9IvnAVCoq2JFFjJJBpLoQ3mGdulVp6xGcw31wit2EJH9zbX/
         Uba7o5wdUbxFecmq7SZpwhUgduM8r1JDmhnkLT+Ee9mgMx4X3DgSpyC0bnReiJZo5bOz
         ZbNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mIA7OMH4LElTq822fWlCipSn1JAPio6YUtyo30XPXHM=;
        fh=CDQXjo7Q+FJ/ihj+uMsPUandYvZmJTunEkZjmvk/9m4=;
        b=C4CMti24ibFcW6SSf8lv+Z3FmQ+/SR0N38VYM5DNR0rG0fAXLV+eaPuM/Vp149qZt4
         +1SXQeYVATDKmrULKWcvbuincNajxdV35qlgA7f+fy99K+gm4B+Afy1p6WEVvV+STkoh
         2fq2C/qPz21oqnmt+Hq2WdyVe593+Xgq2mkopNBFuZMPIYX2CLthujiYu7BzCIWplQ17
         Z3zoAyGz3yDESfNU4U8D7OMubd8vo9BkmTVazIdOtl4FzPyDjIOgh7pJCsNVaOs4NbO0
         XfOLWmkaZ8wx+VpWQkGDAhyowuYJ/Nj5biR/Q7zggLZtjmQgWvu0+0NPU294Al0QWWiZ
         KuTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780513210; x=1781118010; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIA7OMH4LElTq822fWlCipSn1JAPio6YUtyo30XPXHM=;
        b=vgw8DIlduewyaqHtnKwIQf7tt07puga5jkOuaVPV2FElefzRGXfLFBd3Wca4r11CJy
         p2t/MTMXft8u9uWDwiO2vUQEyeTY+SXWsYhrKMljrUbHtCh/3xB9MRktTaprEsUfdXwa
         csNcJppSawhgGtoUkqGru0ZfJcn8C4LmIahKwQEQNH3J4ex8S0rmnIu7t0mSamKLlvl8
         ONkoOyDcHF3NhUJ47KH3tOusRxBzRHIGPGAOItWWpfxR/wkG1Jz2w1UGKp57fOyS/ygV
         pPadPG8SLkkcqFMWUaVrzMmx0ZCxBTj1mGFeo5b0Yv6LMnrJAsmrb9cExPImlWEP+uHe
         hNyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780513210; x=1781118010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mIA7OMH4LElTq822fWlCipSn1JAPio6YUtyo30XPXHM=;
        b=iR7YZGVx3JM2yygh2PCM/SKe1L1KONE3Z05elgayHJfQ7+8zXgymzMOk38H+azR4P3
         9DXtV5BbuFRytE7a6I9ss1VODNvLtn6NNmDfD7FZqTQ1LicA+a7iHA3yseS3Kmul6kip
         mGbpRFVrj11mhLwKrudvmcz0wYDR4gaW0KAJuWo68pBP4l9bvM64v917uodeumH/Fkcd
         mkkXWBpP6wPaHx0oxU0k0TvgX4Bha+UmfJ9F0cotEiqVTh2MuBrbUZxgxAR0Cc/rtaLj
         NqQe8WrQyGbcqFRjtkdZCJCPPYFLKAURcCDPr6uFztrwVbTfoDL1e3HmzJzHB/ENUXMj
         2t+g==
X-Forwarded-Encrypted: i=1; AFNElJ/W74q1ujvQMvhBIwtm+wVTAFbM5ugGbm88Fq++hCcW46TGVvUElBgLm6zfNiPq+lHzVSj9efELHA==@kvack.org
X-Gm-Message-State: AOJu0Yzy/mgZh8/D53/e9Q3eqtjY1rPJSsg1q3MocKbe499XIlXYVYd/
	3EqPHkg0QE5cQHe/gR2c7Uc6oN8DmtcmNGKPLQT0qLspLsdFWdFO38Zjpj0NBqhNNIhSnGh0qCn
	fllkHWloRzjc62iX23x0s8IytSHCErO4okp4psvuax+/Rb28xzgGTmLRVk2I=
X-Gm-Gg: Acq92OEymcsEXvFuoczNzyxgYMeqZtP1PyEexjY3XCBrQR6xsDjHmkAdQJJsKKVakBL
	iQvrAxbuO8dHl1ziKAHOOqkx9mLVVHGzJFzd7m6uSOkAdWrfVd1B9yk/Nk/4WiTYzEYXCmsSWoB
	uRTGgrIZqiCfrHngGYXvzvQNhjie4kyh34c0lI+dPLbKMxfPnkGEsjYiDqRYs/4d3r+2znSLptx
	FhRVbprdRZiNDG56C1PdUPn6iMl8JDx8gxXH9mHaITW324ypWxrzp/o92LACCn8+dL6htxn3n+u
	4uwlTJInulxOvYXDNlTyP5rsfhi8YYVABjL8KSBz1o56sPu9
X-Received: by 2002:a05:622a:791a:10b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-51787904e11mr1370401cf.5.1780513209031; Wed, 03 Jun 2026
 12:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260525072117.112779-1-hao.ge@linux.dev>
In-Reply-To: <20260525072117.112779-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Jun 2026 11:59:58 -0700
X-Gm-Features: AVHnY4IgjDMQT-UcqPG21EkysW-rXuHZsX-lWzD0Lpc0PfR7NWXqLKbNghROTmE
Message-ID: <CAJuCfpG7YCRYWHUn6JM+nFp0eeZz1RSxp620BQUJA8GKKay0uw@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: fix use-after-free in /proc/allocinfo after
 module unload
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D71D51C000B
X-Stat-Signature: x546bp1qgccbomcdxtaia44sds11wi6i
X-Rspam-User: 
X-HE-Tag: 1780513210-340114
X-HE-Meta: U2FsdGVkX1/NHoWi1pHr285oHY5adIMD3vzbwBNKBZ81FLvTgO9JEAMqoB5xn6dwJAB2JG7INj/3oENgEbVnJ4xlyruUqNuGxE2oVJ2lcxLK+nmeNaJUYeEFh38HGLNFKRbMeu873Z2ZOXJShm6vdSH9N2xu9+Dh2TSGtopNXmxxfr5i6eqprs+B6yHoEE0zog4tzDhNhaG+Fn5b/OhFWvlDhGTkNAw/0CAibM+UqP4bGOLdbXOwSr10zb1+W06m5CUqoQ/HVl0Efhgsohk8qzok/3/uBkJApMTOVFAotmKDk6nKR1DzgDjka4GHsyJR7LrjeIt03q292UtTgyFf6vVtBKoQ2TavhQgVSttfSGf3go28nrFgtK+qPq4kJZiPALKzyXARj3ADFAOPMVHoJ/QETIHjOhnCoFpFTL58HjiICQog/HorBqguEzoIUTqDUNOzaelMKVxgv6MG9EjfpJB3dv1knU2fOHspE8drTchwX/7XuUl3DyzOJL647ZhG/IYgM0hNzdmzIWnA+McG8XghUzs7dREBY4U29BN/+8noMuKgHYN3XOW+XrunTd8Mnr0ogrm4dP7q7RpUFmzb4Q9tgDTTrSs7JqW3ENGU3wSUE8X5x8XNl34EuD3UWb4tzfxOf7vx6fOr2MD2qYnrXxkNFyAhVG/821Yn5ukG4oTuKYpGVtXoPSDGiJu9fODCe4Zn1V7sJB0TATrZCR0um3aXW3UBtg1MSNkV83NKhY+iHMijFkFr5uhyIWMmW/gIGTn5B+DG7qIyzxTgFNeyyLDDh+MOGFZv2FVHLIjUbuCVccaxbEj6x5ipruJuxrbArIbZ7OOwmBdAqLn1mkD79ims/dMSZjczq7QvNpjc6PRj6J58epHWYpAfelA3abjx2v5NwLncxNR+eTo8bRTEEPSWgmv9C8w5RATZgD6GIQcPmsvYy/Pespe6H5eJBkFL4GCB2mIWsSOl3A2BkAu
 bai5uLMu
 LdsWp7sWwsbenHVhgIHEN49GdBTiR8yBgeEuGEdzV3sLd/UEBHUaXU3ZLMauESvbU+h4hOUfoCcZ4B1UwGv/F2geitij+GVuHCw5ZCml3UlnTBe29NdJMvp/yIqHPbXEkHf/GEmrgYA2SUTj3AmapOb7yAppldAUKOwXEeskC9b0unLSLGQi8LANZwPjMdFFyaGLJI6PSFAhT2kiVNuNMxcrQEHWWCb0u3XLIyWIrHMK6XOv9vyCTlCisp9ujixu6BGm0yb4tFOGVVI0YzORsvlSvpcwD7bhaY4JcaIb963/tOWvfTrxC5HmLhAwaTfomDGs3AJNWmuVNj2b966jvWWFlpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:22=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> allocinfo_start() only reinitializes the codetag iterator at position 0.
> For subsequent reads (position > 0), it reuses cached iterator state from
> the previous batch.  allocinfo_stop() drops mod_lock between read batches=
,
> which allows module unload to complete and free the module memory that th=
e
> cached iterator still references:
>
>   CPU0 (read)                        CPU1 (rmmod)
>   ----                               ----
>   allocinfo_start(pos=3D0)
>     down_read(mod_lock)
>     allocinfo_show()
>     ...
>   allocinfo_stop()
>     up_read(mod_lock)
>                                      codetag_unload_module()
>                                        kfree(cmod)
>                                        release_module_tags()
>                                      ...
>                                      free_mod_mem()
>   allocinfo_start(pos=3DN)
>     down_read(mod_lock)
>     // reuses cached iter, skips re-init
>   allocinfo_show()
>     ct->filename   <-- UAF
>
> After free_mod_mem() frees the module's .rodata, allocinfo_show()
> dereferences ct->filename, ct->function which point there.
>
> Fix by always reinitializing the iterator in allocinfo_start().

Thanks for the fix!
Yeah, unfortunately with the way seq_read_iter() is implemented, the
op->next() fetches the next element and then seq_has_overflowed()
might cause op->stop() without printing that element. So, in the
op->start() that follows we can't just call codetag_next_ct(), which
would handle the module unloading case (see
https://elixir.bootlin.com/linux/v7.0.1/source/lib/codetag.c#L93).

>
> Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between rea=
d()")
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  lib/alloc_tag.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..2b2d1580c714 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -51,16 +51,19 @@ struct allocinfo_private {
>  static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>  {
>         struct allocinfo_private *priv;
> +       struct codetag *ct;
>         loff_t node =3D *pos;
>
>         priv =3D (struct allocinfo_private *)m->private;
>         codetag_lock_module_list(alloc_tag_cttype, true);
> -       if (node =3D=3D 0) {
> +       if (node =3D=3D 0)
>                 priv->print_header =3D true;
> -               priv->iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> -               codetag_next_ct(&priv->iter);
> -       }
> -       return priv->iter.ct ? priv : NULL;
> +
> +       priv->iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> +       while ((ct =3D codetag_next_ct(&priv->iter)) !=3D NULL && node)
> +               node--;

I don't quite like this fix because if a module that we already passed
gets unloaded too, then skipping "node" count of elements might skip
some extra valid lines that we did not report yet. That's why
codetag_next_ct() directly goes to the next module using
idr_get_next_ul(). I would rather store the last codetag reported
using allocinfo_show() (last_reported) and use
codetag_next_ct(last_reported) in the allocinfo_start() to go to the
next one (or possibly skip to the next module). Does that make sense?

> +
> +       return ct ? priv : NULL;
>  }
>
>  static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
> --
> 2.25.1
>

