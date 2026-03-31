Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D19410F92E3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3946B0096; Tue, 31 Mar 2026 12:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4266B0098; Tue, 31 Mar 2026 12:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA1A6B0099; Tue, 31 Mar 2026 12:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99CF16B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:10:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 484691602F6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:30 +0000 (UTC)
X-FDA: 84606845820.27.5C1A552
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3C41C80014
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:10:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EDTdOfCr;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774973428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdYwxX706aiv3hVMTntflMh4V3FGxCWTDWc8TgxR7L8=;
	b=8Dems5GKe7/KP4IihEjPlnNcvXQwLjipytc887VXkVwdY2e5xapGMxtB2f1mKrk8uHTdek
	Mq1zcWAh5xVPvwW2nn5xtbfgCQQoJjUkThb17XzvZolxz/AU+jzuLmUzlpzRXgYkqNyMZ2
	CqRmehDS4FIMfCN88e+hpEnjAXDCkic=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EDTdOfCr;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774973428; a=rsa-sha256;
	cv=pass;
	b=IsxI8r842gSEFyOds/rvE8sjJMSucvSrt/jjeqKWpIS+qBY0n8UDQPw22rq9iT7nSfOlY4
	TTefQW9wtGyEtxk5Zl0INWf58O06ZI02XsvjipcHTCeACqsjk+6m7EWckLg4dXCmLdCDMq
	gmW2SlnUDKRJv4e/xUpTXunHFnyb70U=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66b0dc690bcso12093a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:10:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774973427; cv=none;
        d=google.com; s=arc-20240605;
        b=SlbiVTxzd1CJhpuQcy2tftxOcvxRQoRGI7Hz7xVg6qVSYd2CUiRUN2yXceqaj0kYJ6
         JS6JYoJGj822LPXo8fM6vA4BUCVUd1gEA2G0QugINTaszTb8QBGe6ZHWany0Fl87JRq8
         c2Hnezu1G1PhSfGc5eYSB1FmaKbzPf8ABuhLi1wpvdyD/YdzRpRo7F8xVw0mi1bxpQVT
         xcXeEBXzU7kfznbITwDbI97QxQe6/dyGl8a622MsielX7Dgootw7yxgGL1+VzeNHVtpc
         Cog/aJM/vrl6Oggj99um7ou2CyxVnX4ceOhIuT+E5xbIL4Q0MQLx/UNtXgJmWiZW/Re8
         d1kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xdYwxX706aiv3hVMTntflMh4V3FGxCWTDWc8TgxR7L8=;
        fh=Lpkw5Mt64MGu1U6/CYHCjVOl5orA7aYbGRQ6esfb07U=;
        b=PUgcu/wuDmmXhuMVmKxKWRt0SWCZybYHVVdiZWrazm4Dpj3Sd9BD+5QR0yH2ZNQtkA
         d+3NyfITVcXegkSx1QXbNOMN619JyU3Aw/ey7vfNBchdVwzbbm9cIO5fYsA8BV+zdtPk
         7tVkcmdakqlQAyXURehZtQ3JINqOryQ75Vq0BHp6FpqRylGp2JIaNgVeLugIOVFYw8bL
         GZxtmXcDRoU83F96189X5KywCtVvVfRQLCcw/n86cJa1uxST2961lwjTMCZTjeHdvFJX
         6y1UpQa64qHoMFkn2HsabpZlxq+fXHh7DWPEymhbxX9pupQi9uO4TNy/WAuGtEsMXsUI
         MRzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774973427; x=1775578227; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdYwxX706aiv3hVMTntflMh4V3FGxCWTDWc8TgxR7L8=;
        b=EDTdOfCroDly0BsAJSUdW0Bl+OAnUb6L8N4ZBryZyzxWAVdMRHPN8BUoTGQgh8p4is
         eFZlU5iS/4FbMjOERNyjqfmmfN/z4XbopKWL/EFr4eLuA1dkUlcZWooAWQFaw34nZMEq
         qhRYlz6/8XkFJ/QLfEwuAMgk9VvPPmdFtQLHhhpCMwK28mR27ccuDOE6iYnELBJPmMXZ
         gCOVdySonQeoU2t8kvjT3kGOStoiaDnRRPcW3CqKXC+IIqnYkwY1zdns2w3s3ZE8X8ul
         fAmdlPBhXKlbcr2PY/fUR4DJ0bFcBA19oXZJyn8THPSXIQzBLpxMprNTV/JLUJL9Y31q
         B8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774973427; x=1775578227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xdYwxX706aiv3hVMTntflMh4V3FGxCWTDWc8TgxR7L8=;
        b=Vtzrg3uDVrgJB/IAKN8V2D0iey3+caUPG5Q5HZN/jIl0//f8YvHeHbam8vcwlKOv6r
         L3u4OVUzBu5bLcmwWAFXCPS61Nb8kOewqv7+jSOOvdB65rzPQavSd0cRbbJcXhYQhdAZ
         VCmhioZBo2YWjHvRuAJav0DVVolQkvaJN4BdRTbeNLZ32J9Px/gO5MRkud6ORnpIf7fX
         G6UVwzOukkgA1UtZAVYrBXyghRlkBo6OVGxXMK8OmnEKRkJ7XZlkOgE2Xuz/cXfdNMFH
         dkcNReSe0Q4dnfTkjrBRyxfjAx5CVRUc4BPZ3aynDkQQNrFV7+Dgcpr4ZM8MrR0IGuou
         GmKg==
X-Forwarded-Encrypted: i=1; AJvYcCUOXl2JrZSf4OQvf64EqczjINV96MLH/8Wnn36cFhBrvkmt1tipfUbkLKscboQ+IVJlx4bzTbb7tw==@kvack.org
X-Gm-Message-State: AOJu0YwQMhMO55QB1v68UPjxP+nse5e9HeM79Y4acItt6b++P3+dSFFz
	kqhG4PRWo3oieZavy09U7oIKTbjd+mwvJpstqB4DZs1dJ0FAtLI36tEczZzPl0yBTk6uMu09/lE
	tNl1GyjJUiFa4da7rSA7Tek+/PaPv1gF4aoaoIC2W
X-Gm-Gg: ATEYQzxypxfRuFPuWsi58WceXN3hI/kRIdshA2fvmMP6j+Sfel0bFH7nos6+FuOioHK
	wdD7JU7tan4gnjX1No82XHTRQ8msxzPTduyKfZwWM2TTTpE+/m9jvJmx/vS4JGZLAZA6H/0qaWN
	RHmm1LrKfMDNuGnZM8aIi0YnpriQwQktRxjDVT7eghxG1mVPbA3hyuHdkEbmuNaEX94na73gUHA
	uA71xpR2uk4JraKR2M7ltnMr3trLSDN8CVpmHBdBEXABvvN98Q6uG2Iy4jsD1/SHtBHUX3JAVMh
	SDFCw8YZZPkKXEd5/3sN6gzyeW000uwz2yxapg==
X-Received: by 2002:a05:6402:1513:b0:66a:7b3d:f43a with SMTP id
 4fb4d7f45d1cf-66d95ac674emr5164a12.1.1774973426186; Tue, 31 Mar 2026 09:10:26
 -0700 (PDT)
MIME-Version: 1.0
References: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
In-Reply-To: <20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 09:10:11 -0700
X-Gm-Features: AQROBzAYE7yZ603ZCTiztIPoNJFv_LEwfruI4KST6j3KliEw3ITjS_K5RdjV59E
Message-ID: <CAJuCfpE0zdEn7gguY0vkXpT2y4+Y6oniTyT90C-1KpXS4L_vEQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: cleanup flag vars in alloc_pages_bulk_noprof()
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C41C80014
X-Stat-Signature: o1e7cggs6ajcft56ghzs4ih5y1879qc1
X-Rspamd-Server: rspam06
X-HE-Tag: 1774973428-117563
X-HE-Meta: U2FsdGVkX19mjHqqsNu41bYcguFxH1k1YB+RjdkxI61hJzN0H77DEl8iEgQSabqNB337rS+GobTTXsva5Zdo/WXrhQ5MRlvXvbGHF9ZopW4saJS+h6RFcWntYpCY3cOP0kirby2dqfcrKTht5EkQuTEvrqpbT/IyK587rBMRbdOumcKAFAqQSpaxafw7eJLSaML2Dl5P2jChC3oApHCkJmTZI9OpI9y0peZ5paTM1Q0LG9apL2IoGMnE1l/M7H49otVDXv6wJS8Ry0tkhdxvCOS1sgXJQFVgJxzzPnxTu9i27uS8AiBRHGE91Gx6Ppx1+V9DZw7UDnAdmg2gz/oPQOS1X2zK+Qw2CzhaSKvYL/MXCssFyA99n/86OufJW5sdrQ4Vo0A/EIhojjzGlg4/OP9DKUzbS68QAgijhAPVXqSWvvivcOtwUrm8JLqU1qfgoLkDMl57X2pNhrXLOASiTsJzcvd4gNsp+gCGz4jCRLJDqnJ0e6xOBlEJFceb9ByJWNWLk38F0yYP65LXDAr9cnjm2NYgB721JRakdffK+b4ntn1D19HlwSygT37Bdn5MDl+ZEUjRcDIjOg7GUFc5iH5VtujaKjlNIoZ+bjjMz6EbIzfbCUi9EwB2680XU7L0OzR4++z5bFhgf2+rHqHSN02Gjwl/mQFlFc7L+hPgeOjwMOIx8Pg+gfqB9RkX3u3eMPyRvyXvIDv9o5XAy9JlrLvbb3TyWdaB3YhwRJOP0gTPKv1WwhApOipKttWdOkGySsy126RTiRtbdwkTViqHIo/CFcahHOvcKJPal7Cv5plCXJKJ/bbhZVRIwGtyaBvlipcyPdFicuVPz2li9r1PI2cW1RRKdj3I+0jxjAM3oXybEHw2cOCoDB/ia/olrlDDv/9S+6WsPwoyIZw97FlQG5Vd3LPuRvFdoofWMtWheLqEtYfuBkUcFZOrvnAK+5Xq3lBH5bUXmRqjAQHxgEj
 diufheRd
 KHeNkTicFK0+ebVguW0UreG/CnsxlKMK1cESFksxN/AdUn6CVYyvx6PyN4xayOS/+NOCC4Db7oQY2Kt4i9pS/dxwyCEwFJrZE73nxjcIkr5emvQhs522PYvGmDQNd01UUZCMKaIGeThNEl8fjRQqxDNE5CDWc666MCHGTdeqNHgJwu3usJHioJPWb5wrrn/zKFoxN/53cx+vCWqSBbg2WLiETAM7gVYxWlm3NJRdzAY0C8emvaeILhZI3W4aIoGxgw2cKNjR4lz6BOvOlViCZdlG7v4bZliNBRq89PCvae8KWCizHH2M2KstSw654yGQkTTLJHP5d9Y54rFf+yGSSytTxhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:52=E2=80=AFAM Brendan Jackman <jackmanb@google.co=
m> wrote:
>
> These two variables are redundant, squash them to align
> alloc_pages_bulk_noprof() with the style used in
> alloc_frozen_pages_nolock_noprof().

Indeed. I'm not sure why this was needed even in the original patch
(387ba26fb1cb) that introduced this function. It carefully preserves
the original gfp even though its value either gets overwritten later
(prepare_alloc_pages succeeds) or is unused (prepare_alloc_pages
fails)...

>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/page_alloc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 111b54df8a3cb..5e280ded6e7ac 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5051,7 +5051,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, in=
t preferred_nid,
>         struct per_cpu_pages *pcp;
>         struct list_head *pcp_list;
>         struct alloc_context ac;
> -       gfp_t alloc_gfp;
>         unsigned int alloc_flags =3D ALLOC_WMARK_LOW;
>         int nr_populated =3D 0, nr_account =3D 0;
>
> @@ -5092,10 +5091,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, i=
nt preferred_nid,
>
>         /* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
>         gfp &=3D gfp_allowed_mask;
> -       alloc_gfp =3D gfp;
> -       if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &a=
lloc_gfp, &alloc_flags))
> +       if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &g=
fp, &alloc_flags))
>                 goto out;
> -       gfp =3D alloc_gfp;
>
>         /* Find an allowed local zone that meets the low watermark. */
>         z =3D ac.preferred_zoneref;
>
> ---
> base-commit: 57e5b07deacb0a9bd7b8c9b933ff72e902d4f06b
> change-id: 20260331-b4-prepare_alloc_pages-flags-5bb9a1e04e00
>
> Best regards,
> --
> Brendan Jackman <jackmanb@google.com>
>

