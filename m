Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6979CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7F96B0092; Sun,  4 Oct 2026 14:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99576B0093; Sun,  4 Oct 2026 14:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88B06B0095; Sun,  4 Oct 2026 14:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84F0F6B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:24:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54A7FC0BBE
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:24:22 +0000 (UTC)
X-FDA: 85285768764.10.DFB0B9D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 61BC9100002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:24:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NXB2gfrD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791138260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+kvayuBhXRE2GquXHfPa/A7+zWFdbc7YesX/WrD9SmY=;
	b=CIR75Z6ErmEZ6u4s6kZ/ssCobdgBjU8q4FewxQEaUyOGlo7z7C6VkhQdSTaOEWPIDlprAJ
	xofp2NWZmq5duNzBxGisFJ/r/vLdMKaPHeNHdYTqAIkWequ3KKeXqwjYQPoeSOPvzEBYzF
	F2ETF0CXNB2kj4v8EB1ivrdHE/MP3xc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NXB2gfrD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791138260;
	b=Sh+Br4Q8dBkcVzaTdAiSp9qOnCmqCv1EIDzBjsaFzJAg4pr7nV8YWkA7QML/WXXXw6KTC0
	jIaVBQ3iPwiIu87g4fNeoMoW08zuBiC5VMM3gAEWFd8oND//jcT1WJS4HBxUVwBErvg2H7
	dumGtWMoQqcoNjnrNB+ZYPVxm1o6zVs=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6afac79b3a3so5647a12.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:24:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791138254; cv=none;
        d=google.com; s=arc-20260327;
        b=jo1qJHP4md2XANl4skWymvsvesPIlgE4/xPVjBsB5e8ynkrSI615phzaGPcatvazN5
         qt0X42Kv3qSGmQtFkwjB70DvPBslzcMQsHWCA4DVbdi1u+cH/T4uab5NNIlc1IHF/wMm
         OE6y9+IbdXIka4WdYGlL2zGrNjRZV4ORn5fN4rBh1y5lVZm3foHa/i51jvVmNLyM/J97
         64d0Vi6fIqvjMf+ciy7LSarL0m7hBCUgLKtAIjHMJ/dYObGoJI5UZypQEJsDx22cD06d
         2pQfXNmbSeB3DHbn7FiaJJnSzyDe3DFHNklg8o5GTsWC3IMkSHP0md0XxLXEzwByq8aE
         zy+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+kvayuBhXRE2GquXHfPa/A7+zWFdbc7YesX/WrD9SmY=;
        fh=0yGV6onaZ0Y7omvcv5g/DlxPvgCKatTJMzfYTvpEBu0=;
        b=ixODW3tcRfpRNztBAj1YQdR5lO9/dvMpg4CV7d1Napm++kB/7/JfJM7+EG0/sbud6l
         GHMR1rXywLcbMbmJHjNWQYRIwYuTvEvXfFnfOGNWK0btCRiJTgruFb24JK2uW3fM7pj7
         jMgzXyYVlL6/f7mNQmIBp2u1ugGn9v9FgC/Ig0CVIcjA4ITq4QF3tI+T46JcoksYh98m
         xJCGCFB6OH2SzmadJ2V5Zsy3izvLyk7XhkJzkIkSpLWzgUXLnVUBo/TFqayPzZ0EczYl
         0yySWDESjNRSgY/Vh8O0pe2aAFoiX5NaBFObI9XFujZ5cZAdChdNSltTL2PL911Lxwop
         +N2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791138254; x=1791743054; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+kvayuBhXRE2GquXHfPa/A7+zWFdbc7YesX/WrD9SmY=;
        b=NXB2gfrDOMdmarh0WNFD7dutKQG72gOAlbrOoZhxH3n2CqdXMbWSpzRf0b9NQVRAbi
         2PXaZDlFSN68vrTV+ULbsl1RrBYjBV56051Ie/PnblZp7z0ONh1l9ukPTyfZBGwo4uj2
         VTmmNmulRryy/AGs6mUvLPcVD1tDC8B/9QmxGUN3ZDDwPAoLDfUmz8LY7xW4QjWfkUsy
         Acp5y5ewKmN6gzyWiOa5o+NILM8j1VPnCfwddS7Rm5fvHvABQBe6jYWKJB9XR7KUWhUe
         1jkRdBNIQkOdvzv+FJx6Umhtc5WD/leU2IsmB1Z1HrJfBlZefj/RsinEMkyyOKVFayqz
         xTkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791138254; x=1791743054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+kvayuBhXRE2GquXHfPa/A7+zWFdbc7YesX/WrD9SmY=;
        b=2kmuKXWxvp3Ia8skGFmYT38Qsq9/X47mNYJd9eA6c6sDGXaoDT77elSvr5Cft5wbJ5
         dkjJezmQU99Z3Gh8kOcOjbQb+pLpkrc3IEdlQex6tMBsDd5qlBhwHDyKBFSUpJd1K6U+
         ryWqSR/afJni7xnK2vIdyxBnQ8jrJ9Td8RqueU/ELfsISInqY6z42ae7DbUtcii5eNWA
         Q7RoNbKekHFhmxqBkILYPiL4b94En96oZq51dgfYiEWy1JtfTnq8v4wlkGsqBrUZY77a
         2i7Mf6svSdk6zD1+6aDyqUJUv+22m7s5bbW6euUU2yPMU1RVociN7Rs+vmSI0/IV1hUK
         VYWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwX+n2mXQcgN4Yvlm0gON10arsfIGtAmEEtn+H0vISAKq1Mlqf4tvBhKwLrUEDPDE/5RLqVaTw0IQ==@kvack.org
X-Gm-Message-State: AFq9FYKp0BWYhiQM1i1Bvnp6MAm1eGANOTiWqysAoRnKIO+I4xBIwQXw
	0YzpNKzKTcJuLiDbJNOYSWS/tX+liTPBH8y36PxS4+07ub+T/RBNnLWUKh8pUP20mmFEUDtAwte
	1td1yBtY24dVFknOXJxURz8+EcpoiVyKIxLpU/JwC
X-Gm-Gg: AYBFou0QxT+bGbZIAjQihrPD2Otks4AinO2DQQRcuDtTCJhquJGrVPk4HqlB9oeqCVO
	8CBG43LnhT3pnHr39gDtLo5dsEPvENN6DL5oFGcV5qCodFm7mnFpZZx4+vrzf7XT25/GqNJWkJ+
	uwFnNMSbw4i0lMvKKN69YeEpUQL6XU3ON6wclqN5iTSX57BVX5AkIi76QKQc0fgNHcmuyp3gonk
	LsLNBahwuzNGu2FjXbPaLrFXqoyNA6UOPG+zRxphsGUwrbLB9Zbg0JUjBVuSVc/RRFikroOGG//
	fWOZuZDe+eeoFnjhaadgaQbUMmDAjz+r+RekDYqP/iuCN7/YlEqn+m1x
X-Received: by 2002:a05:6402:22d0:b0:6ae:1866:cdfe with SMTP id
 4fb4d7f45d1cf-6afaf69c8dfmr26911a12.11.1791138252600; Sun, 04 Oct 2026
 11:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929082014.160587-8-hao.ge@linux.dev>
In-Reply-To: <20260929082014.160587-8-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 20:23:57 +0200
X-Gm-Features: AclHuK86etgyIPJ222To041zNkSoFNgDLomueBKSopElcapCeLMOxFHBtlsBju0
Message-ID: <CAJuCfpEwrdOKQmt9_=J4Qawtg48AUuwwbc2Lp-1oWiNbKO_UVw@mail.gmail.com>
Subject: Re: [PATCH v11 7/7] alloc_tag: fix the /proc/allocinfo lifecycle
To: Hao Ge <hao.ge@linux.dev>
Cc: "=Kent Overstreet" <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61BC9100002
X-Stat-Signature: ao5g6e5rswnmu3pub1z4do1g4id6mj4p
X-Rspam-User: 
X-HE-Tag: 1791138260-724675
X-HE-Meta: U2FsdGVkX1+E59SChdtIHLlyt5E1Sjjfefe+Qf6SlY+P9w5DVyK3NL85x4UvJ46eGSigNCingLEedHfjeADz2tAVO2bFcfcY6TZ1HODL6l6QlcuhQtqw42mgDDwrANkmnf3GMq5KyIRDEYSEijAxHndY/vVzPgGwsFRHdSExV1h3H1PAWnmZQuAqG3zosJSkpu9IjNXx1IQnukw7r3fPwcSvfT7GuIWidSt4WaNjxOpsJOKx9cWvT64IERV233yLQqgV4BorLGSWrZR58x9WuxUX3dJKZs21Jw6yc5dcUQBcUDOqnTVkLhl2DK7J1QPJ9TCjLnP7XoECky3erE0L5ElwRT9bivrld8MftndXXYA51vwoVW5WFUl1+viJGVKPR9mj/oHyFu1GbjSYlwY5O17Eyw8cwszlNqz7oaxp8BymeXATZJx+X+tw5jPc5RfNcKYDI0ZnFoECZfEx2Npyrvz/uMHV4K92PHwHRHCGiw7bFwFnI7oedCmUjbNSEOBoOfuKBr00XqK1PWJ+3GKkcM0GM3EGFQYit60t9PTH7kQMbEaFSbq1GIHbpqOR3s6AGFh8dEMnAMQgNvCOj8FTSiFwDjp1Hnhu3/Vg90Mgtw0J+4Ogsn8e6kYo3u7YKBL5K32aRgP/1UkyviYwKveJFQSgan25ULpPQtBRpB32wWf26mGb2/6KRmF6duF6Xj/YIJDs8lyp11BJ++WHAynoTR83VnZ8f8dzuhrSSPTntCpfWZOQnVH4n/DjpIVQ/20uwU1Jd9qtGapTAMBrKj3iy5myamN2l3oozTWaRwFCRlLcPps+zCQP8z9Fue/Ec8YAwrpSRx4KUPt0/SOYx5Pj/rABu/Pr7kpK3ZdjmMfAZD7H0/M0QdIVfS8kfEQiqP9gJsitocIiLr/K5B7l0OKpW2Wv/s959pnvoFqJi8VRRcPr49z7IjpnPQNf2tBb5mSwSBuStBKYnxqYKcCrcD5
 Ym97wQKy
 97v3BVVSuzshthvAnRMRVV9lZoQzFKJWJxkOh3WRIpaXYcemy23Eat2soP+e+ogKksB0v+GvRbzqKDqsIZuCKa2eFaSCbWME2X/zjw+TGOQuY7lIGNPMSCZvrcuOimGFFFhE+2IG+ojt9V/2BLA2bEglLbui3+CmcadtvgOxghOe1WedxwMB8kWKKnkxCvK/dnHkn+9xKPRK9UvnonQ//qGA6eV9+Pmt4iSClLxQX1w+m24EzyW1F3hFfUz2e0thwNN8r+OekVOeZTryejQiivTlvt0/5KxjT87Uw3geMXvZK27F4NsZ1Hx1a9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:20=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> shutdown_mem_profiling() calls remove_proc_entry() from
> reserve_module_tags(), which runs under mod_lock held for write.
> remove_proc_entry() waits for readers, and a reader takes mod_lock for
> read in allocinfo_start():
>
>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>   ----------------                   ----------------------------
>   reserve_module_tags()
>     down_write(&mod_lock)  [held]
>                                      use_pde()            [in_use++]
>                                      allocinfo_start()
>                                        down_read(&mod_lock)  <- blocks
>     shutdown_mem_profiling()
>       remove_proc_entry()
>         wait for in_use =3D=3D 0         <- blocks
>
> Move remove_proc_entry() to a workqueue.
>
> The deferred removal also affects alloc_tag_init(). The file is
> created before the type, so on a failure it is still there with
> alloc_tag_cttype NULL or an error pointer, and a reader panics in
> allocinfo_start(). Create the file at the end of alloc_tag_init()
> instead, a failed init leaves nothing behind.
>
> If proc_create() fails, the codetag type and the module tags memory
> leak. Call codetag_unregister_type() and free the memory.
>
> alloc_tag_cttype can now be freed at runtime. alloc_tag_top_users()
> reads it from __show_mem() without locks, read the pointer under
> rcu_read_lock() and take mod_lock before dropping the RCU lock, the
> type stays alive until then. The only caller never sleeps, drop the
> can_sleep argument.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/linux/alloc_tag.h |  2 +-
>  include/linux/codetag.h   |  2 ++
>  lib/codetag.c             | 26 ++++++++++++++++++++
>  mm/alloc_tag.c            | 52 +++++++++++++++++++++++++++------------
>  mm/show_mem.c             |  2 +-
>  5 files changed, 66 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 7f2d80a59792..852dc10c00ee 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -81,7 +81,7 @@ struct codetag_bytes {
>         s64 bytes;
>  };
>
> -size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, boo=
l can_sleep);
> +size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count);
>
>  static inline struct alloc_tag *ct_to_alloc_tag(struct codetag *ct)
>  {
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index a25a085c2df1..0c4e0337b474 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -87,6 +87,8 @@ void codetag_to_text(struct seq_buf *out, struct codeta=
g *ct);
>  struct codetag_type *
>  codetag_register_type(const struct codetag_type_desc *desc);
>
> +void codetag_unregister_type(struct codetag_type *cttype);
> +
>  #if defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES)
>
>  bool codetag_needs_module_section(struct module *mod, const char *name,
> diff --git a/lib/codetag.c b/lib/codetag.c
> index a0b600720afc..46d0904b08b3 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -429,3 +429,29 @@ codetag_register_type(const struct codetag_type_desc=
 *desc)
>
>         return cttype;
>  }
> +
> +/**
> + * codetag_unregister_type - unregister a codetag type
> + * @cttype: the codetag type to unregister
> + *
> + * Undo codetag_register_type() and free @cttype. The caller must make
> + * sure no lockless reader still uses @cttype, e.g. clear the pointer
> + * to it and wait for an RCU grace period first.
> + */
> +void __init codetag_unregister_type(struct codetag_type *cttype)
> +{
> +       struct codetag_module *cmod;
> +       unsigned long id, tmp;
> +
> +       mutex_lock(&codetag_lock);
> +       list_del(&cttype->link);
> +       mutex_unlock(&codetag_lock);
> +
> +       down_write(&cttype->mod_lock);
> +       idr_for_each_entry_ul(&cttype->mod_idr, cmod, tmp, id)
> +               kfree(cmod);
> +       idr_destroy(&cttype->mod_idr);
> +       up_write(&cttype->mod_lock);
> +
> +       kfree(cttype);
> +}
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index ba8a651769e3..b9af5fe5bba2 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>
> @@ -484,22 +485,28 @@ static const struct proc_ops allocinfo_proc_ops =3D=
 {
>  #endif
>  };
>
> -size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, boo=
l can_sleep)
> +size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count)
>  {
>         struct codetag_iterator iter;
> +       struct codetag_type *cttype;
>         struct codetag *ct;
>         struct codetag_bytes n;
>         unsigned int i, nr =3D 0;
> +       bool locked;
>
> -       if (IS_ERR_OR_NULL(alloc_tag_cttype))
> +       rcu_read_lock();
> +       cttype =3D READ_ONCE(alloc_tag_cttype);

Code looks correct to me but if you are changing alloc_tag_cttype to
be accessed under RCU, then you should declare it as __rcu and use
rcu_assign_pointer()/rcu_access_pointer()/rcu_dereference()/rcu_dereference=
_protected().

> +       if (IS_ERR_OR_NULL(cttype)) {
> +               rcu_read_unlock();
>                 return 0;
> +       }
>
> -       if (can_sleep)
> -               codetag_lock_module_list(alloc_tag_cttype);
> -       else if (!codetag_trylock_module_list(alloc_tag_cttype))
> +       locked =3D codetag_trylock_module_list(cttype);
> +       rcu_read_unlock();
> +       if (!locked)
>                 return 0;
>
> -       iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> +       iter =3D codetag_get_ct_iter(cttype);
>         while ((ct =3D codetag_next_ct(&iter))) {
>                 struct alloc_tag_counters counter =3D alloc_tag_read(ct_t=
o_alloc_tag(ct));
>
> @@ -520,7 +527,7 @@ size_t alloc_tag_top_users(struct codetag_bytes *tags=
, size_t count, bool can_sl
>                 }
>         }
>
> -       codetag_unlock_module_list(alloc_tag_cttype);
> +       codetag_unlock_module_list(cttype);
>
>         return nr;
>  }
> @@ -591,6 +598,13 @@ void pgalloc_tag_swap(struct folio *new, struct foli=
o *old)
>         put_page_tag_ref(handle_new);
>  }
>
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
>  static void shutdown_mem_profiling(bool remove_file)
>  {
>         if (mem_alloc_profiling_enabled())
> @@ -600,7 +614,7 @@ static void shutdown_mem_profiling(bool remove_file)
>                 return;
>
>         if (remove_file)
> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +               schedule_work(&remove_allocinfo_work);
>         mem_profiling_support =3D false;
>  }
>
> @@ -1351,16 +1365,10 @@ static int __init alloc_tag_init(void)
>                 return 0;
>         }
>
> -       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> -               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> -               shutdown_mem_profiling(false);
> -               return -ENOMEM;
> -       }
> -
>         res =3D alloc_mod_tags_mem();
>         if (res) {
>                 pr_err("Failed to reserve address space for module tags, =
errno =3D %d\n", res);
> -               shutdown_mem_profiling(true);
> +               shutdown_mem_profiling(false);
>                 return res;
>         }
>
> @@ -1368,10 +1376,22 @@ static int __init alloc_tag_init(void)
>         if (IS_ERR(alloc_tag_cttype)) {
>                 pr_err("Allocation tags registration failed, errno =3D %p=
e\n", alloc_tag_cttype);
>                 free_mod_tags_mem();
> -               shutdown_mem_profiling(true);
> +               shutdown_mem_profiling(false);
>                 return PTR_ERR(alloc_tag_cttype);
>         }
>
> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> +               struct codetag_type *cttype =3D alloc_tag_cttype;
> +
> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> +               shutdown_mem_profiling(false);
> +               WRITE_ONCE(alloc_tag_cttype, NULL);
> +               synchronize_rcu();
> +               codetag_unregister_type(cttype);
> +               free_mod_tags_mem();
> +               return -ENOMEM;
> +       }
> +
>         return 0;
>  }
>  module_init(alloc_tag_init);
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index b938cbcd774a..a2e710404a48 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -439,7 +439,7 @@ void __show_mem(unsigned int filter, const nodemask_t=
 *nodemask,
>                 struct codetag_bytes tags[10];
>                 size_t i, nr;
>
> -               nr =3D alloc_tag_top_users(tags, ARRAY_SIZE(tags), false)=
;
> +               nr =3D alloc_tag_top_users(tags, ARRAY_SIZE(tags));
>                 if (nr) {
>                         pr_notice("Memory allocations (profiling is curre=
ntly turned %s):\n",
>                                 mem_alloc_profiling_enabled() ? "on" : "o=
ff");
> --
> 2.25.1
>

