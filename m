Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C2ECD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B686B0005; Thu,  4 Jun 2026 15:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CB36B0088; Thu,  4 Jun 2026 15:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B516B008A; Thu,  4 Jun 2026 15:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 434806B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:24:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF02514027A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:24:34 +0000 (UTC)
X-FDA: 84843206868.14.5BA1E52
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5DBD20006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:24:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PVwa/0XF";
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780601072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFXRGmXLuyDVZzX4oAkPyB6gXl3DDy9ITovf12B5TEE=;
	b=wMn5y3r76iGOtWNb7VAmkrXBqi1w7Rh9dio5pjiOpCyRM8v9ESXBbu0Dt/IyrNL2HMUO/9
	rOJT3gT2jVJvy7pvqfX1ZGaIArqLvaVP5xUp+9fHVrM5RTvkZbH7qH6DeQkjNf9lmi6dHh
	ZYZWwdpYsXXY+TboLh7xFOHECS0ycnE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PVwa/0XF";
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780601072;
	b=mpLSdWAOCHKLj0eJ0g/xivCJ6fo1tm7NW8uZFz91NhHm4yJ+v+1iEnuvcuvcQV08hu92I9
	OKlTMlAsjwWG5x5JXpgAaRSbfymY2g3OcJ6k9N8RmfrFp/2LZyW7+nxv+t8qQhjqALTypu
	mB2nDQ1fQBpXPq8nKQZhN2ygsAQfjEg=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51765531803so116591cf.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 12:24:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780601072; cv=none;
        d=google.com; s=arc-20240605;
        b=R/WseB8bLkzKbC2w8K5OtNy2atJDMi7HS8i9OiVCHCuWU7Z9b6UPZ0KlCSJOKDaqw6
         6F+aQh8sCJuzcI3QLp6p8cGa6Ot9xFyYSH5bLS29se++fGPaPUWCaywqF4TRKVtd1xcZ
         amzydSYjpWB4HY2HUmrQDJHDEIBr0ntlFEHxaVqhVI8aPCACoAtAl6zTyJCjoxvlIBKT
         p5esYrqAOrg9nN7WqNrSKSor5aZs1l1hK8O7ws3VUdIR+vDwv9M0tQGcrwmOO7BsDIRN
         f34bAKPI0PAXuq0SJaUjHdgjmJHsEsbwvH5ylA1sR+Dgw6GxFcJZNBXU6GUFmjfnIXmr
         egCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zFXRGmXLuyDVZzX4oAkPyB6gXl3DDy9ITovf12B5TEE=;
        fh=LTnits7M1/VGA4DgIRJXz7Bz0k6OWobGj+LwlpOqhK0=;
        b=drpQQ3NJH7U4X8/ypxt84/4ucbFg+BjHBiCgPd/dZbztdorv7FcKQABZ9MvIMcJDQP
         HhrLb5dpVN4UUU20FVyX69V5eUy1N2GqTP6LHVjdxjyUzGxKsWHDdTa2HTyjiy1168Zn
         Z74WIcwGUTaOiURJ7DE8RaTN9bGVmXVKbwKI71MBOxPMSmPFUgmMZ5SCneIwBA4VOwuF
         KGRLJ/k6L+BliKC18DQ7JGf7H1r+wk/QckHVYIoPK6pwB71Vmxf48844vzgYM8SEbj/U
         zruO6qEpMpr4lSXg2sZLYSaZDxZvl5Pi7JYzcPdhHYt3iVj1v5XB7ZUObYLqejNbD2kb
         2Oew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780601072; x=1781205872; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFXRGmXLuyDVZzX4oAkPyB6gXl3DDy9ITovf12B5TEE=;
        b=PVwa/0XFmYJ7ZB3IayVpVGQj9pUX1sdEXZ8/C/27v4DA9Sz5oGs07W7OjJcIaaV9Dn
         zk6Fqq/89zqJ7EsGIxN2BoOeqW/1HTn9NPXn7abSsNFnFqRYlRzPyexJSVCMdvNUeHup
         vtOAxymT9GO3lHKVB+uv0/dExHFRS12Bh3kID+NDl/bsC4aeCR+EbS9aDxfnoBdfdGia
         iX99Wi1b0+ktQkQE/hSiXyLiuLj3qygInvG4qSOu59AdhrLUaGCrHZSdyIonyRippclZ
         WPHxEmmFj1KpUvoRt/YCv+c2HtSqLYOzpLsfoToLrG5hydW/XW2yJZZkJf6tZdGtcWoP
         6ceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780601072; x=1781205872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zFXRGmXLuyDVZzX4oAkPyB6gXl3DDy9ITovf12B5TEE=;
        b=XFJ2tmrJ8LrVvTD1vz3YCaODnpUrp3iu08Zy8kf7JYQtyYUtVIeRuiDoIEBU1kPxnN
         E0rA3Z7EHoug8qSZbmkz/ArIlrHZyYSpRc5lR20P4+eMIvDPAvdlgTf4ksk/VQ742R4m
         TNXVxYcaoh00qpgjv0ogn/xzht3APmXXPe+IBf/iWr7zUjh5XCoc6lQqVTq8SL1L934u
         stp1SQ0gecQPle7tp6ZBXSTh8C2kW81PZohnVUmae2uOiRuSprKD18Nnjra3FVwIKoJm
         xeBNICsKeaooKKCMc9o2rIVwiEUycg9TFq6f+UFa3vmoENz+1cteISxzy6nPFs0RKQYq
         sv+w==
X-Forwarded-Encrypted: i=1; AFNElJ9AVs7zchrbTDHFd5xwFKaQc/IPj/sfAHupL/xosnm/0On68jH0F5RHcVxtwMgqQHgg1OvhAkpaGA==@kvack.org
X-Gm-Message-State: AOJu0YxEm5S+YuPjb63fJN/6iI8rfazNfczE7Vk3vLAxHuHGGQ5TjNic
	6LQoot4muPSDMI+YoNdxTG5v1jqTBtqXX2j7goIH5cuPmYd2t1tyU5ilN/nhM+09bpfzTlyTo73
	lGiIhqXJeNPRsjYDWqHLcXtmQMsB0lTNfdvC1vp/k
X-Gm-Gg: Acq92OG3x2NffF8h2ZF2lzkepA4sfkm6Gl5yw1zm+f0EGarFeJzsMRrTEz10KzU6Cj3
	3pEEEEvEdFdJjS3dM52e1TS5NKzyWNtMPo6AFxpGyzjeeh7ZWSIerdZr/HXWUSUclSq6QSM6nxL
	tTUg6fhqeUObIE7WYJjK+NhVPuxaaADIWMsvLGSRAf0opqGJXlAAm8xDaRfgXHWhtgGpoftMiap
	nT8VvwT/UfFg1SDOZEVfYFABJY+VfmItkBNqRRh5kEltZeILDgyOkJZze7Zb2GfaG23pyO+PAI7
	nykQYtVL/FbYOFVoBoViL8tEoxdRiaawJInyAA5yMXvgkgQ=
X-Received: by 2002:a05:622a:8d0e:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-51794e33db4mr1665001cf.0.1780601070963; Thu, 04 Jun 2026
 12:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260604065938.105991-1-hao.ge@linux.dev>
In-Reply-To: <20260604065938.105991-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 4 Jun 2026 12:24:20 -0700
X-Gm-Features: AVVi8Cfus8QaLYoVf-BDWsLf609Yb8mL1nOGP6idxhcTRTNpBWipr87QDBS_urE
Message-ID: <CAJuCfpFBcnS8thEbKnd74xTyuKd6qaOKk8+sogC17yL2XE0THA@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: fix use-after-free in /proc/allocinfo after
 module unload
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5DBD20006
X-Stat-Signature: aum1mw9xb1dfwqzc1ko61bjqibfsb86a
X-Rspam-User: 
X-HE-Tag: 1780601072-333436
X-HE-Meta: U2FsdGVkX1/hVycVfd6aADEx/5OHjm9CxcMMWleBH/+5h3sLGHQwC738nqDnHjZ9AnyhzuNP1A7DXixyvvzKDdAfkiARyrrTcw0bWgOWNpSTohqko1e8lDULx1pwh276eKED0TbsgmiKaZRGjFI56k7GV0qW5RKzt/Wc1/HaW/6eXhxso2utC/AaAZfwHQtXwQiOQjJ9dU7tNara0hGdqKEPK6zUpmcKjQ0mTF1ha7nHSa59j1SrPubt4lc6qC90whQCDovbHc8JRYVbAlNly/yEdaQn90wgwcvrjmMrYN3A37S366RVcNnj++aisSnDaYy4n5NMEUHi4UV+jSzoEnLOENrJ1uiRs67GC2N9AkuYnkigOy9f3y17/fiYLXEpEfswj5EgeX0uhhchCL/jZOwofxcLQdPtawMSveKjD6LmSsKPwS0ivK1H3XEQy9FtvMiOoWQmMQEL3kkxdAHph0ekOdNzdfigkIDY9ncEeeXf4CncWgxHtpnwAOlgSQOhoK8oSP0ptpLtxoFbrlxBECPKU+q/zz5EQcpYG56w6ZpONkHNUhJ2wpXr4L5+HU0qtc96tnvuF5zioAW4Lm+tejZAbXvER3jqLtPz9tLOOjD8C/e0E2sBLaGBW9Ho2EWoRnh08gV7Thl0pvYKncj3BHn01fhdVGXurlEuh4skHN9+fQhMhq+YbwVGcqSlH4AZd6QSjoI/2i85MKdRbYrXqeySqY29A/HAJaQSa+pNAuxIgkB5AhFNZPj/KA6yCMGNT/S0tp1SVnYmdshIBa1k1ed7m5xjG0fCSnK06oW400uwSECzVklYgA3OFdO4Sz2k0VTgVXDuRZIQsWidbZtBioKVkDi3ottSW2hb2VZLD8+S1Jd7SQrhbbqi/b2onHZvnivG/pdtk3LswiLkAEIkOBceuhFQbFIT2/bF2739BJC/dMom78rPdyWb4ZqEucAl39Eljo+KTYt0quLJn/W
 +CNjkhNw
 ce4Ekzk6UC+e3oQRvEKKx5WHRhlSw6+1KNZzEb/bFp78q05AxymqlbwrPBMy9TGFK3RVexq8Qx7PQGbPgGRsXZEatt146jQUy2fOWFLywWQyd05UivhwkqlZ0g+yfLpSO0yNa1Az5dHlS2hUo6RX3x15MgF8bzvt9mmQfu5T/HeDqpkZIf/y0i6+5UEBCLjWXsFMCjJDX5EOdqT8gU0v6TCxZHucbGK0GXEcGqw/gPnfyjZ5c78ACuXg6N1kZUEKO1x7fcj1sKIBlZAMBIeT9FkJRR0CC9xgpAB969VPj5ZJOuk/oK6FLHzPOxLH+YblP3sK93UWBfzfKNoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 12:00=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
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
> Save the iterator state in allocinfo_next() and resume from it in
> allocinfo_start() with codetag_next_ct(), which detects module removal
> via idr_find() returning NULL and skips to the next module.
>
> Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between rea=
d()")
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

> ---
> v2:
> - save the iterator state in allocinfo_next() and resume from it in
>   allocinfo_start() with codetag_next_ct(), which detects module removal
>   via idr_find() returning NULL and skips to the next module (Suggested
>   by Suren).
>   v1 link: https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@lin=
ux.dev/
> ---
>  lib/alloc_tag.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index f2f574bcf383..551cc14bb1fd 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
>
>  struct allocinfo_private {
>         struct codetag_iterator iter;
> +       struct codetag_iterator reported_iter;

nit: I would call it maybe prev_iter since it's not yet reported (you
store it in the allocinfo_next(), not in allocinfo_show()) but that's
a minor detail.

>         bool print_header;
>  };
>
> @@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_file *m, loff=
_t *pos)
>         if (node =3D=3D 0) {
>                 priv->print_header =3D true;
>                 priv->iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> -               codetag_next_ct(&priv->iter);
> +       } else {
> +               priv->iter =3D priv->reported_iter;
>         }
> +       codetag_next_ct(&priv->iter);
>         return priv->iter.ct ? priv : NULL;
>  }
>
>  static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
>  {
>         struct allocinfo_private *priv =3D (struct allocinfo_private *)ar=
g;
> -       struct codetag *ct =3D codetag_next_ct(&priv->iter);
> +       struct codetag *ct;
>
> +       priv->reported_iter =3D priv->iter;
> +       ct =3D codetag_next_ct(&priv->iter);
>         (*pos)++;
>         if (!ct)
>                 return NULL;
> --
> 2.25.1
>

