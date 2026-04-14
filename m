Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EF2F9D0EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 19:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A556B0088; Tue, 14 Apr 2026 15:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B356B0089; Tue, 14 Apr 2026 15:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA236B0092; Tue, 14 Apr 2026 15:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3ABD36B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:16:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB23D16025B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:16:06 +0000 (UTC)
X-FDA: 84658116732.29.C17C1CC
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id BCE5E140013
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:16:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2GpWBC6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776194164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDf7QX8dCTjsN07hrx9wGMlU3r+qtis+bAy4ztGxEOU=;
	b=cplCX3IgEiYESFyN5dbiV/BuZIUwAGjrG/MIuVyl/B3C8LS623Sfj8yzNFDa3H+NPNmVpr
	xohFzUFg7GwlnbPZ1KsYAbQOwSTmX8lQr1JkgbUzqlg5recZh1Md2QX9sNsE5e/UzK+M2Y
	LeG6CvUCnSx2dl3RSxs4kHuTaZFlv2E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776194164; a=rsa-sha256;
	cv=pass;
	b=Fis4HSCztq7tb6EXvDows+A1r2oA2vyebx1GLDLpRZH0Uj1V5ATUl85j9muq/vJ/YF2GE9
	g3A+V00oxMUVjl8QeD3HDp8LMsU9rc6L1/MOrnHmHV5r5I+Fs6hQPEUQ6CPJFajaPhGO8o
	wx1xCVmne19ZMgvzF1tqZdCqBRxLorU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J2GpWBC6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso25792a12.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776194163; cv=none;
        d=google.com; s=arc-20240605;
        b=TVZMXOmXO8KeBfWdIO+c3x2RDDwJV7q+siG4R/kmWXSMIyVsqpYiwzdyylV70OV0ly
         fi9opvLmqdTgdFBOSYS98BKlUmMyRHqRxk5hiPmBZUnjrvLllfD/lnua/Sob6IniU0AI
         zPGtNA4o2HelliOgdIIrVkQK7P8d1VTJ3vx3/VcT/o8bR5KwoQx2P5H1uH5uS1Xwf/RZ
         +G+h7KYICrRkxDxEypCq+gdfEvHXHa11nAvHlP566Ql4hFwzhqVzPAYOI3wouC8YwgEp
         g8oUQHT+rvQ65y0wTBH+1aFMIyaXVkIVmzI3yjHL/PFAINKazipLzr6vmzy8ZltuCVh4
         uELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vDf7QX8dCTjsN07hrx9wGMlU3r+qtis+bAy4ztGxEOU=;
        fh=ydjFrPAiv2ZdAM6s+fo/BSXD5HfMms07vf0kAEgdkr4=;
        b=DUYhBhOC5Mg830iuO4GkzuOwF5X6jlrkzIbcbiV9AVZyRKHmcPpRmGksHj00gHRfNa
         CdpmBl6SOQU32fIzhRam+SKRjQwaMLH7BiQ3BNZ78zEjHVK1ZWhlUQxWOo5epfVpPtnd
         pLu4F3FaqS63kzaZoYNGTKr1VMMMrIzlT8K/Xd/gvf+1k8WbQEdFn/V7Bh2qtNUPIWJ7
         gKSnmEwxSYvbUr7YxX7tt+IXtUplS/9MGvK6AOhdnw4kLoU0htF8z934Ogdf39oxEVwq
         DA8Yqn8v8Uqn7/77tEU8+GvKYjz6zW5LnTiTJXip2UTI4nLj+mgbkgcEC4JHCPRbf2D6
         oubA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776194163; x=1776798963; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDf7QX8dCTjsN07hrx9wGMlU3r+qtis+bAy4ztGxEOU=;
        b=J2GpWBC6ihyt9rvi3epUjqIv3P5dcdY2y9rEJ4Qua2bakvz6t6CIbc4BObd9d+k1Uz
         Rmf0w3JgrKOOEOyA1jsY11cCsyUj81TBTKzMSxrhrQ52xHyL//nDBWk31S3ZWbYVZbAq
         N5B/SD/xkKtBf/8ZYe8xH/buAxv5lXWeldSsSP5fy0rOAgLzXezSv9PjwPcTG1n6z5+9
         +WjLGrSJd3bBPt2aOKSYQDFNW4jScSc6vVicSa4u/9HWQFvr4tF6XJfzKCzEer3i5Xgx
         g/pXiHObdYQy3s7eKtgwvEFP7NynREfuuMqs0SO10zSSeqEoiNQqL69bqi8HW5A05pnm
         7wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194163; x=1776798963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vDf7QX8dCTjsN07hrx9wGMlU3r+qtis+bAy4ztGxEOU=;
        b=je9avw0HU/Zrh9aQauQbfW668h0V1JfCXGndQrnD1uAlynAXoH7IjkmBv0SqeN9f5E
         EaVzlsx9lexpvh5Czd6cSXkDEmdHT+vspizWkYq3YgE68alLmb2anrhjYFIflZGKpPk9
         +EXvZJN+Hedt/BDmJmN12AZHY/g4qxoLTBBnYlozPw8wJ9lUrPD5VOY9NHS2DNFS/qu2
         82yg0IDEQsMRekNkV7h/5VM/yDT5bAZYRj/edLNRb7xsn23KzkNvRJotsdWy/8ICHhHV
         CxnJnCp6mowJrxgCOuJooIYiV6EHzhW9by5pL8nGcdYDMlEpIJh/Iu7vt2WNwPhbvUda
         UZDQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WMLwZVpan89NmSbmr4ouZWBMT85ByTy161mHeDJ6UwQLyRE5/MG0xw0xu0lqIcharJDjo9pMmDQ==@kvack.org
X-Gm-Message-State: AOJu0YwcKSMdFjBOv3MsJYcVczobtt7BBUZXg8gWVyQtH3RCKmss7J2i
	eGfXiLnxYEE7+ksiFQOL5HMKjLU4AehyzoeTJKKILlx6/CpQjjm74JpS91KXUn/j0RwKLwF0ELa
	neos/mlxR55eFYbnPwst/lgr2DF3N0yUTFL9luwFE
X-Gm-Gg: AeBDiesayeAb4MEBrAlKR4ouRUg0q14o1cPi9bFVgxDjqEOxUowX59VM23EuSad1Cbu
	h7GtAaFyQkrHB5jLLQouKjrApZSaLIWyWIvfse9QNZgU10o2WuPd+WYnH3FgXeW93l5yLT4zF9h
	U9EhRWUZwnvvXj4lHiWPpjiEtUhMVQ7tiWS9wwz6dn9Jp+to60h1NFpoEbqxcE4966C2pB7e711
	BcUT5FJBW8ws1a9Xstck/RSdDgCte1qCyDY1ruzlipGI3Olo8QMtsGdmJNpimdn0//waYmwtIMO
	w/3mFbaBVNikXalhms5lseZtvMGcSGesUfKF4nXMc8JSHPVvq9jfTm5svRKk38hhfZDyzw==
X-Received: by 2002:a05:6402:5649:b0:669:d537:de85 with SMTP id
 4fb4d7f45d1cf-67229ae4e4cmr5569a12.11.1776194162257; Tue, 14 Apr 2026
 12:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260414065206.3236176-1-arnd@kernel.org>
In-Reply-To: <20260414065206.3236176-1-arnd@kernel.org>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Tue, 14 Apr 2026 12:15:25 -0700
X-Gm-Features: AQROBzBC6Y0qvWaUs1yl7ge9ovqyfv4vIoLNfWuOl8c-QyyjXjHVF53HP06oYnA
Message-ID: <CAJHvVch5GHynkGd+ffNzw7o8VxGdT6SGCXS=mb9kceEOjg07tg@mail.gmail.com>
Subject: Re: [PATCH] [v2] mm/vmscan: avoid false-positive -Wuninitialized warning
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Koichiro Den <koichiro.den@canonical.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BCE5E140013
X-Stat-Signature: 9uqwhw6gesej8cobbsyii73ykkmcnwux
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776194164-770505
X-HE-Meta: U2FsdGVkX19ABDQK48uMZMuJnGJ7ewtcz457xjaV2V2DvKaHfPAMTAc3/Xb6SsZSU98J32FichtwZB2iIGSDCe/PrOD/FslmKi59KbyE5NWTAzd0Wd5xXTz1mNGMI7lUE3ecBpkhZUKHrt5QcIyKRPPVj2V2xvJZOr7fHjQ8pWeJOoeFEmAqm2jilZuhZ/s5m3ne9LmxYzoBb3cBPccG/V9oDWIrq4VwKyoYmb8oQUKPbw7yDryXmkVnAXcKd2fHoTjD78KYF27Bf6sDNpvk/ppahIojxIgU+HVUQiTmlFC67YYYIxD2vbI+1H1iqz1c1RiyYHicyR+n0qXpirDmQVVC3wfok4lKO0CHtPZcdLx2SCXYWoPGfj2I3wC6+2MLD9EmzzNBWraw3fGDmCm5Nx0ZvU4n2fNjeIx53EzVWpxNddL50WIkM5GZ/BBUuC67fSFvu30D1mz3pQUDfuGZDVV9O5zEA9Kxg5MInZcfsXZR6xpLidyCjtTLqamqSj2kN9JV7bPfyQDoM4FDK2I6t5yce/38/Xy7hBqsDJlEnLmJ4v+/abp5+vLdfADR5+GeNXpZPc08CnN76Us13VoTPEQdHEhmP0XEHFHCfBZtH5OOzNC8mqntrc1hl2rXXRIR0y0Ow0lWRY4G9Vvg0tC+kXjVO56odU78nj3/vBQl3XSpTHv0+PcuiH68rVr7iuOdNYSzPkYo4bcL1BMChL9RfafZehmHVOhVLhNk1ge8IosGdSvbPOGFnmYjiB0D//Ebb0lh2ptWojL9BEYYBvpMd1xEyx1NdbOIWn3vyCknwjT62v2scmYA50Fj9xPavkjk3qxMNk8tIay4hLG/8qICS4JLxcoa9e4w6eAaxKgdAAXZajWREU7t7MUPoaf+kZzg1nk1MwIPDzzWDcYRQLf2plyffaGHwMqqlr61OYtQWAy4Zr1AG8gHmOlKiUYhx49sj9C9cd7N21C5LCTvueE
 Q6+g5d/5
 3gF4SvX5Qjx4HARin2884t57ACmurB4G0XtijXkjWA9LkLmcUZ5LD+C/mmZZYl3AWiVdLu6AKN2vlWeu53GimO7U9EUfIRLv0IA7L91qM75tVKSMjDuJUSPGPHC5LXfK007pYRHxPUmL6DtS89Hw5eF/NUiMp+8rtOTHDezt8m1wOlFSP+6StsY7MpNOh81QUNI+iw1f7z0qRWtSB5MlXeymC+vbnAj7Gh5E7q2Vzl5tz5L0gHkWMZZituGZl/XPuR/GJHJbwoaM8p27fRtrFBeU+8PscWKCJVyi/1ijwVjssRfF03ZxRH2Ru9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:52=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wr=
ote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When the -fsanitize=3Dbounds sanitizer is enabled, gcc-16 sometimes runs
> into a corner case in the read_ctrl_pos() pos function, where it sees
> possible undefined behavior from the 'tier' index overflowing, presumably
> in the case that this was called with a negative tier:
>
> In function 'get_tier_idx',
>     inlined from 'isolate_folios' at mm/vmscan.c:4671:14:
> mm/vmscan.c: In function 'isolate_folios':
> mm/vmscan.c:4645:29: error: 'pv.refaulted' is used uninitialized [-Werror=
=3Duninitialized]
>
> Part of the problem seems to be that read_ctrl_pos() has unusual calling
> conventions since commit 37a260870f2c ("mm/mglru: rework type selection")
> where passing MAX_NR_TIERS makes it accumulate all tiers but passing a
> smaller positive number makes it read a single tier instead.
>
> Shut up the warning by adding a fake initialization to the two instances
> of this variable that can run into that corner case.
>
> Link: https://lore.kernel.org/all/CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5=
EmiCHP+1fBpg@mail.gmail.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

> ---
> v2: replace the earlier more invasive cleanup with a trivial
>     workaround
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d3312c51f3f2..f829435d2807 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4760,7 +4760,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>  static int get_tier_idx(struct lruvec *lruvec, int type)
>  {
>         int tier;
> -       struct ctrl_pos sp, pv;
> +       struct ctrl_pos sp, pv =3D {};
>
>         /*
>          * To leave a margin for fluctuations, use a larger gain factor (=
2:3).
> @@ -4779,7 +4779,7 @@ static int get_tier_idx(struct lruvec *lruvec, int =
type)
>
>  static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  {
> -       struct ctrl_pos sp, pv;
> +       struct ctrl_pos sp, pv =3D {};
>
>         if (swappiness <=3D MIN_SWAPPINESS + 1)
>                 return LRU_GEN_FILE;
> --
> 2.39.5
>

