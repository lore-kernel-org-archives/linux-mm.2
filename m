Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D72FAC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874DC6B0099; Wed,  5 Aug 2026 10:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C9E6B009B; Wed,  5 Aug 2026 10:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7635E6B009D; Wed,  5 Aug 2026 10:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9136B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:48:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E3791A031D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:48:45 +0000 (UTC)
X-FDA: 85067497410.26.A4B0346
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B2F0180006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:48:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TSX0e4pN;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785941323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74JnmzC+AtkPtezOthxS7FXM4/QTh3C+xB8eJUSwR4c=;
	b=R4kzkABLn8fGxzZjd+E0ke2pmd8lEDQEuZPQv+EZEQwycGF5n0XUZf95Dm6laqV/+4DP3B
	xjhVus0G9hmA167EQO5+2/EOaIjFf9OQsQLGvtsSOCTwJ2nUNQ6/meu0+uaIYC3P7QRcYc
	SxuK67+Gom+EnJUUHgpQbq33b/Bf+g4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TSX0e4pN;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785941323;
	b=lSAOTB6RYNFGq8LBiOvc4AzAnUzo3wjTCqlXZ6sjn//JXU9ixkZD6YMQFKZ8OxRYtto0lr
	bjGZ+3UNDw4WzfHawYQ5eP1i4zWMrncgteiDb3Glj3FhdXUp2EIoNpNaCDroTrdg0x/3ke
	4TFiYWd2S/D826TObjYYGoSf3ngPOhE=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a177b2dc8dso9083a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:48:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785941322; cv=none;
        d=google.com; s=arc-20260327;
        b=aD1pK5wwjrSAv9zPLxyVTiSStebq2OIVo32gohGheUP0Rif54dwOX3GxPAHKwCYR+e
         8g508T6iVb1PRKRDx4nehCNv6LwvrfpEvl6vD3JzU8t2u/1wszB8XgDdRukGeTGLXUiK
         z4qIrkrlHPyu6FDvQEIjv9U0GHy9CzJNy+GG+ZrAEU7KKsORbputqQOrd3t1AT1BW3wS
         8UFfG0oC8szHnY/Utd4HGUHqrcfLGzA+wpCZYdBr+3xPlYdOzi9XbQhXNxnukpKBPvh+
         IjmTWY30+hjckeK9UV+LHRCdOONto1lE+/ebgmyFJh8f92e/VXmlL+JXev949C1dSAvW
         8gRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=74JnmzC+AtkPtezOthxS7FXM4/QTh3C+xB8eJUSwR4c=;
        fh=NUDfSoN80MmePXYc/438Wn8cTxEAsaALSl4jrJFpg3E=;
        b=iUfHps/+7/2QkWoBjCsLumG47qs8V3aY6YFxffnXeqb7b9b4wJGSv/nT9mYO04CJ1n
         vZV7wdhl8JwDIUss/61O51WcLed+QT8B5PJ1vcqzdxxSYtl50/EjcYqxD/5EW04fE+11
         CAACTMDFz0C9U+sid0/T0FMidyz2tbGchgmKHv7NYA722AdhkJwLB99RH4gxZDVTjoXT
         TBYWrMxV3Sw/Gt/jjctUmDqssMuae/Fl4N9tJzZRBGIQCBalwcfrzUpxeIV7PLDS2/3J
         ZXCuSjR0R6Bhtf3nWMD5M50fdWNfLaVDKnvWtqpBnbnF/j6+rcfQxbCixsRSJKifRhWr
         eo9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785941322; x=1786546122; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=74JnmzC+AtkPtezOthxS7FXM4/QTh3C+xB8eJUSwR4c=;
        b=TSX0e4pNtpCpQDiRQsYxjcXiPnlcER0oUT+/tm78aKLlv/Ebw8IqX0VuCBHUD9vfR/
         OA5joOxGeaZnq8+738a4j6XwvvYaK7tgXRPoAFMIsFSnw7LJtld9QDvcf77ObklfiEx3
         9SIWHD85EI5Wke10srSTBElytD0etvUUpYLW4saHcPzlYHfBNLEmEclkPZ8FeIH8ci16
         s+1A2ZpDDuTshOyyVposEnD7kqPrVdWxhcPQri/L1u2KiaZUTCHaULskoQDYaK5SJJqm
         pWacnzIag6Vnhl/BvBcCoHN1rcDIBFLjSWR27QZrS8cYqJbDW3/4X8mWnwMd5fg1s36N
         7seA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785941322; x=1786546122;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=74JnmzC+AtkPtezOthxS7FXM4/QTh3C+xB8eJUSwR4c=;
        b=MEb+EN/yaVbEXnA+3WIouhvXv4CYfniANncfYh7voTGfTwyYkBdAQMLxvCuXlJkzIg
         VtswlO7AUQ1kxKjjOJGr0oh3ibchs5z2EOx8VoMwsh8P09FsreV8iinuQiqjCOw+f9VG
         geD4Fs66o+9RjrqcxIcgJCn/jcorBTJq6HIf5AfRnbSwuHE4hPij90cJJ0GcgWFzy6TE
         rny8DsGHFzvzg6wBQFfggENX+pPfVooyo4lRUwHFH06Woo2c2ksbTV0ZZiTeThB2x6O2
         iWnHAuPc2W8458cnC6auCdoX8RAfAT6JLWdO4yHbXbErOBQ1GOTqHP72cEcKGwXIgHls
         7Fyw==
X-Forwarded-Encrypted: i=1; AHgh+RqcIiA/GbOdAozeMdMyE+n33nG/iWpcsFBc4e6MAKtYNz7uegu1WNqBDQFvCgawIm5xr2TrqH1T2Q==@kvack.org
X-Gm-Message-State: AOJu0YynNV4iEGf0HllZ124zgV8jNhwES+abK4VGx6cWAtgnppHukHcI
	gk9wNirVRJINfSf0ggklOXZ+MH+jkqLWwRzLym3/EZ/813VcHigCB+0nBfUbTkH2wFQdlJdqbid
	AFYrKzMBNh52QaIKUp62N4Mi5BF2K8mUCzwDNulZXhiqAbL0yAwB3pXbv
X-Gm-Gg: AR+sD11g+H1Z+RK6+V55r0X64HVWX63KUgAsESYnniAuiv+JyG4cwaVyHeDGhK9AopX
	o322glBcFiHP62V+D3/jvs8eY4v61PLYhpsMh1wVQXHfjL8RBesQKoa2Gk+mi5XAjNZ/SE86zsB
	VwimuH2IswUeg/iZN6Rlok+6ayNLX5eM2aa1yHH4gfUAJs6BX0bWONYHHvX1iHsv5wF3ENJH+0c
	8GHiPqUAMX55VLGRj+quiJJiNv9TfJODShdVuvQ6mqo8vFLz7lcGDOqD/KRbOoSGYA1PqN2Ay8h
	PAksXqS6Q5sq2ud+4EbX8C12KeaNiKyaYNFxpWpbZ4RQzCxhsuiEQigSSoQzJ2m+wJ7F18AUwfc
	=
X-Received: by 2002:a05:6402:44c8:b0:697:7f69:48e3 with SMTP id
 4fb4d7f45d1cf-6a14fc7db15mr73328a12.10.1785941321666; Wed, 05 Aug 2026
 07:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260805090633.141001-1-hao.ge@linux.dev>
In-Reply-To: <20260805090633.141001-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Aug 2026 07:48:27 -0700
X-Gm-Features: AUfX_mycrpDzhEJqHYmTeNBhjo08UvV5vnN10hZEYxiggLM3MZtoYjhTvx18P2w
Message-ID: <CAJuCfpHUqqD_GttG3bmxEPxeYNA9p7SH3aseWJFHAWN8aYKJAA@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B2F0180006
X-Stat-Signature: 5t7d5yoyoe7or9ypmqcpbmubtxbrmey7
X-Rspam-User: 
X-HE-Tag: 1785941323-790340
X-HE-Meta: U2FsdGVkX18K3knPkOaRBq2A5/8dm0c1pV5AqH4PRgUW/RyI5j28GqSf+o1qf1OgF71RgNa0xzAg7TCOFqkyf0CdtEAwuw0+58N1twGM0btA3yEqH41wHJVf3qKay+/A1gvhTHG/GB9xBaYsd3yOitsbFfkTOEC6WSq/BhPb2pXG3JzOTSC3UCQc0WQOIaUHbn70wOD4Cd+ovbNdpiEeaC4yppyNyGlh/FJNIiPT5OZmbHbhTmEjBqQj/k4174Dr1istvjjUdB5BobEJS93rU+bQM7Lg5o3r6BWxOl1PF37Nvn72auMAjw70iXtbzzVDIoec4JzjkpjVYu2X42YaQn9xlmw/amzhcJonIh4xZR1Z0D7u7OUg/vPa1sro8OHmFGNxxUdW1m9UdCnNPX33xuwXQZ+TZ5Gd6Qstm40MOXkwkVF9c7YIql0tFeKAWV93C0lJbJDpNLUd+rvPqZ93J0JVZsPq4s7w6mguysDFiPxP+e2Vv/yfDToD+yzni4Mhdr1qUM+DfhIe7fC+VroZO7ta01Wikr3GkQmFkiYrc3Jo+XUcLcg4Kcr3K2dHYKxfORp7Hq132orX4mmsWLlo8NOCysRY4Pj5KLspnW+83dVG1+A9wKWaeUrbCuCqziC6SR+BVbNfqJzzRhCDBLtG1Dnc+46xFkxTEm3AVJVU76xpYOT3djObZGXsPycrsmrDihBZOa5M+Y/um2Jc3KJ+sWbdDwQ/6scTgn6TGlzX/ASQ781LiJRGuzzi8sTWNnDpLGsbz3h2Y1wkfYMFGNdpqU1M2xvM0IXX3jxMz/aMasNuSk0m8KTLTTxBQRF0YJhXYW6q5w8am5iHJs667nB7ieiMQZ+HlD93f8BQkxxcJbz7oqAdPii9h+NE/v5Dc/avItInALRV0PuNgkn6ktTnOnu/MD7X4DIF1tFbVaLAgG4GYjgm5RH1rUU4BeuP4P+kLONb6lD4FfGYafMT8dj
 U6GlJ0Z5
 lQVgMj5m7qj501yZMKBxhMeHM/PSjOnUW7+CXh9dU3gikxjfl5ApNebVpDTIQO9f2tiSSGMaesepVpR6AJmWhc+ysZIROzMNWDQECKqhXPvlDCH7J6/4zc9ZBYcWOgt1NovNS1kMS8rEfefb3wbVDawMyISOkZzTHZGsBoN2poy9IxZXqLLx0Nkl/xThsLMEqe6oRNer40Y4qcqBsvSDkht5jpPN93wCFeghL7jps9fTj29RSJxgbRDcaHpYY8r6R0ziFJLrRPaWpfrAHQHcRtC8gxXfes+JeR+1anAb+pYDZUJmM7I0bB6cN2BKlMH9RGX65fw0513lY66Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 2:07=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
>
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
>
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
>
> This silently corrupts /proc/allocinfo: allocated pages get attributed
> to the wrong call sites, so the statistics it reports are wrong.
>
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
>
> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> the mapped pages would never be reused - shutdown_mem_profiling() sets
> mem_profiling_support to false, so no future module load enters the
> codetag path.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
> Changes in v3:
> - use pr_warn_once() instead of pr_warn()
> - return -ENOMEM instead of -ENOSPC (Suren)
> - expand the commit message to describe the /proc/allocinfo impact
>   (Andrew)
>
> Changes in v2:
> - return an error after shutdown_mem_profiling() to skip
>   vm_module_tags_populate()
>
> v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
> v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
> ---
>  mm/alloc_tag.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..35ef2bbfa13a 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -904,10 +904,11 @@ static void *reserve_module_tags(struct module *mod=
, unsigned long size,
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> -               if (mem_alloc_profiling_enabled() && !tags_addressable())=
 {
> +               if (!tags_addressable()) {
>                         shutdown_mem_profiling(true);
> -                       pr_warn("With module %s there are too many tags t=
o fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> -                               mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       pr_warn_once("With module %s there are too many t=
ags to fit in %d page flag bits. Memory allocation profiling is disabled!\n=
",
> +                                    mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       return ERR_PTR(-ENOMEM);
>                 }
>
>                 grow_res =3D vm_module_tags_populate();
> --
> 2.25.1
>

