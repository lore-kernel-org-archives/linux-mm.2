Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7982AC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6176B008C; Mon, 24 Aug 2026 12:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696BC6B0096; Mon, 24 Aug 2026 12:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1A96B0099; Mon, 24 Aug 2026 12:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30CDD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:44:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF479A2B20
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:44:17 +0000 (UTC)
X-FDA: 85136735754.06.48B95FF
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id C033DC000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:44:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WYPJT4/p";
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787589855;
	b=TMD2m3SJfjEpZvyoI07ns7Dozua2SfxYBKdCngJ7FB01kG41RKR1a49KPq2XRyew/nYfgH
	oOiFtO6HIwl5v5CF8Ep76bADQKqEYJp7BJ9W7kvhUfJn8VAuNyB48i6dM4jKpS0XRwHtXW
	Ycsr79/EH0iDTOs+XgwHUIBtWHTNWss=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WYPJT4/p";
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8n7u4Av3FZDgQp3mwzYnpHadYzCcRvADEKN8iR0SUI=;
	b=W4DELGP6Hr1idp5lJHfoKyo3U/+FU514xmkg8I3Cs3tETqu4W3dKpqpMaascrJ/afd4OkE
	4w+UjB1nIiKzqt10czL+QrBLNlhJY98qGIRoEjKb9RL1+JsI5rofQ0PyFRf02KWkj5AvLJ
	CndnORay0XvXePWX6W7q3o7h9Vzp790=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c10ed63c0so469861cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589855; cv=none;
        d=google.com; s=arc-20260327;
        b=l8VkDRmVOEBftZSTkYP9fmmYiTisO8Lmw4waegySQgAEAunHZSXsBWO5LVTOJQ3aDV
         dgxqgHYc0fPdnqZAqvL6F5bBuJNvmaEpzkUOXTJ/GwNMJu6X6zNZijuhuXJobCyyuRH8
         cj+Qu2bbixEPNR6grqV0yoQSVpUiCTON/G6abIWY1ymjLxJmOJ121IL+I8jhfLIH41eq
         g005+qjAzCLxvoG3hGTm5RnWMiWHhKo3WHtMYq+o6Lur/ccFkiRxnbQIpNijuKzuTPEB
         0yZ3z2EavnA1sB0IItx+vQPednkORNmPW6x7hrOwrkddWLqE5geKVZPgpZkMrEIuymjW
         i/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v8n7u4Av3FZDgQp3mwzYnpHadYzCcRvADEKN8iR0SUI=;
        fh=mTAdjZdBU1bKvcKAVQ5ljq5ifl/MojI6r0g+j4z+jpM=;
        b=f1YWUV2V7j5RmhiKcneKFI7jCE5uZNvYUadp/HCkdBY8AqGu0MxNbkprVk1XNEQOrS
         IHtvEW+UQXJV3T7YMs6Ap1c4EaLr7UA6vxqvhnBRMOJUJMnjTeds5OGwmz5JqHKzJIXV
         bKZh+rv9mbXR0rmTPwCDMebIeCcnU+tDQbzNg3f4/nQ/KvUCH5xJ+2KyrboGz4gLbbOz
         0n1gTD8npAcCojWaHV54CbUZGFmKCjh0mFrXd0xpAOgrqF/JVZpD71rWKDy9sEqXmDnR
         5m/2PO1Cmk5HsgC5gAWY4DZ4s9hX0uMtHeeaToORc8+kPkBzrPIgWZP0WerJNj5lbPKw
         3OZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787589855; x=1788194655; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v8n7u4Av3FZDgQp3mwzYnpHadYzCcRvADEKN8iR0SUI=;
        b=WYPJT4/pUPhVwtX4SuQ2BcaK8kT3d4Dzg2Rq4vqaiaVjaFCxnuPAR2LnW/iXkDe9Lq
         N6885i0X/aY1Dli51sJTbPS0tG35oy1XYZhq//jVhT9TzL9fEy6SkhuPzkRd4LvaEBOY
         mcK81pSKKHj/BDfFjQ0652bhKe2IoxleoEaGxsIYnUTVfr8DQ7VcA4lAGACFfVeiq1Ws
         x+6haDWITRC5QgGrnqjqP8XC6W4xo+adAAM8hbOginXbSJWojw2ohsh4RJeROqV/OyrP
         CUjNaP4L98p/KhEQGNN2ELWfo6ZzNp76SvPQA4PbKaB6oCg+DNTY9YQ0dKPQ3FCjxbrv
         LHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589855; x=1788194655;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v8n7u4Av3FZDgQp3mwzYnpHadYzCcRvADEKN8iR0SUI=;
        b=Ps3sZoyrXm4THb85PjbBKPS74tPfzQkETxvzpW/VOy4VaGC8g8UccsQACqdbxWAj9G
         YtlAopzordS/jvyjLQ5/a6JgrXHchX6cgfl24lJwjMv92yDIWicV0OxsKuw+dEPl+Mx+
         8HKdqjzSzsbpaEZeWRphXvvg1h+eUQcBL0dNastwtxmzGGj1eqi5xD3Iues7GAuPqrCW
         M7Eff7x+++QYURJGdL9lEuNNHtnv8d6mDa/U9fF+d6s7PiAUIkVkpDUR6VepWc0T2fJ+
         QWtC9zcOLsygo+jkmuWVeszlqf/bo8jB1oUT7E5R8NiiRzUV1KYX5rv4DycuOCwhJedJ
         kkzQ==
X-Forwarded-Encrypted: i=1; AHgh+RpXEZqGwE7HRyFG5EhhP7C4yzwlf+hRxG/f6kTToeSwLimE3G6OEZ/h+2wxfQEnJBHG6C89vzhcKw==@kvack.org
X-Gm-Message-State: AFuF++njmwPELOXEGNb3vvOtHjgpG/8bjCEOVaMcsXC+YwyuBCSBOdr3
	5trvf0sXpQzA8veJBYPcMrEHoFsnQ1bzDCMPHddjbvQSFrwOWc8jMoaI8gyHV5jwWghr5I20WME
	KvUFG4voYI+ORDJFhWV50X04uyG/gu29Y8kL2RRXt
X-Gm-Gg: AR+sD11vcX2gtgT0ivyu6UzIXOLYn4kNn5FZHY2V40z7LhjetSSTK+Nw/ks7iuRQDao
	sLswBG8Rc7FcaXw3l6t7erSbNL06XKyeVoofIAC5zAc6jw/PJvgs7RD2KpnAgodAJF5cc47zukh
	j/ktqPnx8gX6on9w5jucwrh+cJ9bdgoL96pWKVX/D7cNaQ2A3i//bXiELY7LCyz/m4H+9eAqNwc
	ZhUf/PvSoYLZOw4gQkMnf6luqp+97k2ZF/sxlDEIwhybnyZJyDQBo2eU1OMexpnUTi8i+eQI6Tm
	H2wbM24yXXR08zPyhHZWS5yUQU3oztNa7Dyy9f/XhGo=
X-Received: by 2002:a05:622a:1b2a:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52e092f16e4mr42031191cf.4.1787589853987; Mon, 24 Aug 2026
 09:44:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260817062726.106511-1-hao.ge@linux.dev> <20260817062726.106511-2-hao.ge@linux.dev>
In-Reply-To: <20260817062726.106511-2-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 24 Aug 2026 09:44:02 -0700
X-Gm-Features: AcwNN1Vt8cECV76f4DrYdyxlek4yoLVqyMGuasMmaWPxXTrP285P-kcpJdRH-s4
Message-ID: <CAJuCfpHbcJVQVpGx-0CYR9W=axy60FtiaPK0G=B=U0KmGWiyvw@mail.gmail.com>
Subject: Re: [PATCH 1/2] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C033DC000A
X-Stat-Signature: q386x97odg448yua19c4roz9u6oeic99
X-HE-Tag: 1787589855-883202
X-HE-Meta: U2FsdGVkX19Z2PPekVIe29/61MKsNQPnZa5Vk5oy9qc+CMLY4zsTuP3MLvfEkSsWxlNJyCBVaJdwMkGgK5+xTtbIMuBzqxmJKTmolumV8rkifvaHerpwYDpZ44WnbgZbq/KTcOCH0Y6XbA2Ale9DIidaT26c5llKNBvA8Vr3zxEa/9aRv9XVV+9k+HiBbtVaPNQ4oUUS9KlfcI5IsGpVb17IIhtkK6IyZEsYVTZcfTITLW8bXzWdUF0MgW0OEpOBpe/8vNXqsNKC9Va7xseQMvbIrl0GItCtl8rSoUj9O+Lpl9iExaJM7KzXhZ4XeAlyVoB7YWG25NCadfp8nVU38xRKTudLa8hDmuK7mV+Om0tKwIfdSSm/0r3bTyHi5jpFA9f6plPAiDAHxTYShAu17Hs4fZjT4C46oAKbCZKkg7HEIGnRd8xsqnIZHBEfbHzKdkqAuc9qi0bOtXmBtjvKZNRCaYlIuD+5FHwlE4d7jcNENyfz4ze4m7IL8KBzPNs4ntOf1XUS9n9S/4KwRM3muCPqnizC8ZnvSDcdQhHGN9Dy4l8R9ZBxHfWFth6dk0JOpKgbxn9jIG/lJ548OaKNGEbcuE/4nRmbb087plgM+yK5+vIt2AVN6GBXLMjs1fz+uEF5kx9eE43iD9VBkuQ4D95oT9yrruqq1B8qJWErq6FfP/3Ky7LABoCf+azXb1dVKAqpkMM3ZPV+CCh0GRtIoG9w3GQJduk6VpZVR8bkyE5Lqgvktsw7WKUU5j4gDuDejTX+vb6ywDiX2jh6kpZ0ttjsink5Dkll2SaI45+fziG/47tMKsRkNAQZ+W0XDj1UhmUvASjCeYsj74/DPK89qOtPqgkI7ROvvnpP2ZP8Ocm8fsjGIHX0sXn/5cSFKMm8h0zX1Z/mQitZhQvHm7/3NFnW6LKAeR7MtuBc96y7mjhE1aPRA2pGpBNMg6gBjLQ0uDiao9IqhzSTogqLpXS
 s6KoBm2t
 4SBhK8hiTL/Ce02RKQjtbfPG/8yWojJscUu6vfaU1NwbimZf4TPDeTtcgfmhsDuvgtZ59Cph2CT9g0AMXQysZ0z5R3nV6ihvNm7BZAqCsUEWYzoil0mhee/CF1Yjg5W+EE2O66tqvFhoSwouNrqmPGE+5B+SsO7PUgjzxDwg1ll2b4mLxWJFaoRLQm7bfm+2VhvVd80fjc8AuhpZumhL2Hmy1vdXmYsXk5rxDVxJEaBxPXw2bMU9yBCcGoJeBJQwumZt32CSL3icACoZLGFphpFNWAMsw59nCFahiuWrYUqem+bjbPN92VhNWLD6lr0w8eGXGH8IX4sxqcOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 11:26=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> After shutdown_mem_profiling() clears mem_profiling_support,
> needs_section_mem() returns false, so later modules have their codetag
> section placed as regular data and never enter the alloc_tag maple tree.
> codetag_load_module() still called load_module(), which allocated a percp=
u
> counter for every tag; release_module_tags() could not find these modules
> on unload, so the counters leaked.
>
> Return -EOPNOTSUPP from load_module() when profiling is off:
> codetag_module_init() drops the module's cmod, no counters are allocated
> and the module loads without its tags. codetag_unload_module() now always
> calls free_section_mem(), since a module whose module_load() returned
> -EOPNOTSUPP is not in the idr but may still hold a reserved section.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  lib/codetag.c  | 10 ++++++++--
>  mm/alloc_tag.c |  4 ++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/lib/codetag.c b/lib/codetag.c
> index a9cda4c962a3..a0b600720afc 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type *c=
ttype, struct module *mod)
>
>         if (err < 0) {
>                 kfree(cmod);
> -               return err;
> +               /* -EOPNOTSUPP means we can load the module without its t=
ag. */
> +               if (err !=3D -EOPNOTSUPP)
> +                       return err;
>         }
>
>         return 0;
> @@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
>                         ++cttype->content_id;
>                 }
>                 up_write(&cttype->mod_lock);
> -               if (found && cttype->desc.free_section_mem)
> +               /*
> +                * A module whose module_load() returned -EOPNOTSUPP is n=
ot
> +                * in the idr but may still hold reserved section memory.
> +                */
> +               if (cttype->desc.free_section_mem)
>                         cttype->desc.free_section_mem(mod, true);
>         }
>         mutex_unlock(&codetag_lock);
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..80eccaca665a 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -975,6 +975,10 @@ static int load_module(struct module *mod, struct co=
detag *start, struct codetag
>         struct alloc_tag *stop_tag;
>         struct alloc_tag *tag;
>
> +       /* Profiling disabled: load the module without its tags. */
> +       if (!mem_profiling_support)
> +               return -EOPNOTSUPP;
> +
>         /* percpu counters for core allocations are already statically al=
located */
>         if (!mod)
>                 return 0;
> --
> 2.25.1
>

