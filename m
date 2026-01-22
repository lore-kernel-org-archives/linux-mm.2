Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF21D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9716B0349; Thu, 22 Jan 2026 14:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D8B6B034A; Thu, 22 Jan 2026 14:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25136B034B; Thu, 22 Jan 2026 14:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42406B0349
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:48:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 542D71C177
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:48:59 +0000 (UTC)
X-FDA: 84360637998.10.A19F565
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 487891C0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:48:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="q/1daJqZ";
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769111337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfAqgxH1582WZq4I3423rt+lWJCsFYGPLOPu6I2/Cdk=;
	b=KuhgZUqnyS7uEg8YVj0C2L6hRXsHUBA2Ero5UOvH0wubCklpvoKSvWBBh8kvqwlJ1nDYvV
	k9Xgc6iq6Ej/Il6Tw7gQhAOZM9pFStGAwykQF13sCkz1KfQp/j5u0dQbFsRtMRz2hOtWlV
	H6v5dph5QTmAl80dr4Vf07GS+nsfjMs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="q/1daJqZ";
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769111337; a=rsa-sha256;
	cv=pass;
	b=dNN1RsEWCNxKEJUw9/bhonZZQeOTd961qG1pwhDuSFkL3BJjKJh+ojPh6H+q0iDhkUJfys
	x1+TN89S2DpjuVzAhnvVGeKl+tV7FVwu2mpc2z4nPRrkAdo2+61SGZiPOSh0PBIgzaIVyH
	h49v5N1a8gODE5B+Xi+4C23Q79Bw9Vw=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5014b5d8551so95591cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:48:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769111336; cv=none;
        d=google.com; s=arc-20240605;
        b=ae+PBFidUhAMwYFUCTiDNrxDAqPXlhRa2dQLUTUc2a2rucSVGImy/W1ea5mfPO65Im
         R6Tmi5F5/6MVoktS05EC3stpbwmiDXARuAQfl6D4y84NpMeM2gPZJEnhEUbh0pzvOKWh
         xV8f5XIqUe18IYkpR3RMnAkaUBI9TOio2mpD5UDRu0pTa5WYnHvFYz1SvlR0w0c/Vbkq
         kSUb5jSAPYD8dWWjJpURFhxp3CIQN5UWmhmZ0/5Ln+IdcfaKTNHJKU09aFDtn1duHQIL
         6VtEVEYqykcmWYhFBRAvxl63cYVgMEKDwSjAvuClVARLAuxMtnNPycw+PdAa8OlXpB6C
         yhPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kfAqgxH1582WZq4I3423rt+lWJCsFYGPLOPu6I2/Cdk=;
        fh=V0sDit/TgHn81EeEneXp8c1ZdId/2Lqoev8sfyFMcb4=;
        b=Ndq6w3RFHZRbHDzZygPe+sPZDCT5WubcxcSN6Y0DuEEKrKYqoF9VkkD+KdBrBVj3n3
         UdiQOoPY8HbA4zjYZyV5hQC3O7eqba9UPWN2x6MARHAYsp9mPyOYS02/v1tWQsga3pKe
         s30UVIcCHWGzbAPlkc5XYXArBcUoK5om0LXtQSQdg2JxGoewNFCCpywCSoiqeK4oEdjO
         vrSW8vCVzLrxu9pfqhE2K0bIy6zjZjKRJtdbBM4uQX+7HRdz2Lv6oDDfSX2HUtpygWoN
         2g4dQjFDpmGWf3Z85TzTzE7U+H0/niiomk/KYccQytuiwAHOOTrNSejSvoeRA3jgD1aI
         +YeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769111336; x=1769716136; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfAqgxH1582WZq4I3423rt+lWJCsFYGPLOPu6I2/Cdk=;
        b=q/1daJqZA/pSoslZazcb3oIy41YSbQgHMrZ5zKJsypMThhjQRqURXX5nu5q/Iu+2ar
         QdHQrGbIuDG/4PDnr3vCMlDKQPO6NM/PM6BZjNGJlGYM4flNsPWRtqVlB55D63xtYUH+
         4vbasZB9ythfWlggosNgPLt5FVyj2mkdBR7cO9/qz1DXqmVc8u4lXTR5BqT54yJiufpj
         zjqez8RZViDgipd14dktCCnEFK8igKYPtg0KV2MCpGvN8iEyb43DD7TU16FxFHh9zebV
         ha4EnnPZ9hSsgMakonIHpw4Y/un1DY5bMgTIpa2AEDboFH6562kb0dkI830/Dj2wNfD8
         E/fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769111336; x=1769716136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kfAqgxH1582WZq4I3423rt+lWJCsFYGPLOPu6I2/Cdk=;
        b=Kn5rRMQl0I+bDn6/Lv6E8bLviApgPCQSHjD7m33kwI/bfKhN977xaeYsU46OXVVTsn
         KllGeiUktqz6L6GKd9qb7CtaS6KkE9/NAMO07ihzJou/PAEJkrP9a2ye+GIWeyhxumiL
         kNBkTN6Ym8B4lG7OLemXRJ5o/VScosL0j2I4+NGsNDS3JhzDmYX/fPzt+HJ8P0TfoZCa
         HB8Lm2y/sTPKTN9Y4PIXsuXYRhg/4W8/IY27Tb4wX56YxdwCt8iANSDLGpSYLblqxona
         9Ou1qfqpA0ggQmxsCORjh77A6HfVacrSgwuf9PNB7OE7GCxq8jZH8bZbxzdxkeE0aG1q
         7svA==
X-Forwarded-Encrypted: i=1; AJvYcCWWOna1wNYtJRTwUyTavLzEGzkWiRq6coI665cJNh0wV2SBhpTLfX+PKrreV686laiauUYATeMJ3g==@kvack.org
X-Gm-Message-State: AOJu0Yzf49A7wsDV8xHwA3WVHJz5CoqWsvWbiclwTxC885rBzouo/Pw0
	w4sWhEOIxl/rDHp9iYA9EzEm7YMzSu7qYcHGHGGLqoK7xGqYaxB3oV9SmbHpD4WyaaNkXjaGyDR
	liD87FqiTpNnwuJi33yqXTqFqrB5/EZuuHGGkrtFO
X-Gm-Gg: AZuq6aIUlFQTHOVxy+DYOUYvzKg2v8O85XN5Sm4xLOQnrNWwZAWdJfDTS2r+bBqS/ir
	HzHYwxLvfpYthZ/CQsbir8yqixXXAKbbOeTu3SSNw0pi/rTVh/oV0Sq1ryjLUk06Lgp1MfUI/u6
	utDxHBj5f2PMlI1cdrZhZ5ZvEhIKBPMgnH4OR/fC1/4pDZ1fkqyCkrZYs4YL592Ey9E/WwkLA11
	eB1Of5d2XI0t/fUmTyQKqxuj1uTsecBlQDmAo63fTCptzco1o2NRVilIInKv+g9ecf4r843T0V9
	jzKJHnyXSvbNf2PHWES3Vk+d7n/09g==
X-Received: by 2002:a05:622a:52:b0:501:197d:32af with SMTP id
 d75a77b69052e-502f7f431afmr2017041cf.0.1769111335997; Thu, 22 Jan 2026
 11:48:55 -0800 (PST)
MIME-Version: 1.0
References: <20260116165416.1262531-1-pratyush@kernel.org>
In-Reply-To: <20260116165416.1262531-1-pratyush@kernel.org>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Thu, 22 Jan 2026 11:48:44 -0800
X-Gm-Features: AZwV_QgYYDLmHCzfY5_3eVms8MoiUtOZs2iFbsinPGV_5oYeZSyGGaB4IQhOzrs
Message-ID: <CAAywjhTfAU-NH7+Wevp_UxquuJdUNuKvnv_Hzh6GDcFFxC1Bpg@mail.gmail.com>
Subject: Re: [PATCH] kho: print which scratch buffer failed to be reserved
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 487891C0007
X-Stat-Signature: yq8cgj9kskmh81rpi4ua6q6fedeea13i
X-Rspam-User: 
X-HE-Tag: 1769111337-849497
X-HE-Meta: U2FsdGVkX1/uDjNkIGJiGvfUzKE7iTsbzONJvh1hUt81K5gZEBsIXO9nn/6ZN6vh0b6RCdc9T5p8sTznGmT2tNrQtTZDoFJCgduD5gm5Py4C5l3E7ppK/+OYFScWH5sxCSsV0l2ytTGbPgq7jmAAc8mA+jGT/g1HOjdvu8yRoXIeSVaWGg1KeXJjLN1eAM/hDyJyZD9b216W/ivzayaz5p6Xjp0XP6XH3I5wVow5NXNhxXxhcCq+rnisNAhpSLbMo6gBkL+1tykzizEVwEfdWRDGk8Fn/KuOMYaGhkOWuIU0yVG6ngRvUCPo+BjIy88qheXnsCV7ZlaA46GvFE90EDFiwy7mqCPsvPQKNacbjUHRsmXuD9QWUhdTa4irmmFkhR9arkPa4F0jpMOVh38yudGYBZbXSbuqnJtRtHwYR1/C91Ojo9nZaXnzCCn/VJxuins5GP60nWUGPCgskJHFDX4lpG1mF2Zon0LnzeQizQJmWkuuKuc5tepJq1r3q//p9E4dn5o6TL2XqtBj/knG2khccXyYpgZTYm/b/DdiDPcOMiODSOuhbL5zPZlglfinFJ9NSmL9rNKJrktyMtfHnFtcFj1A/DgsNPu6tnnEsjzG0srDe4Rgv7G9u+qCEdMnfBoyROwJuWQmdx3kixoTvvv/B+sYXT0IAj4WFalz8aREJkBAtebv5QYvPhdbdPixguWWtsdoXdKNkjJB06/EkintGofA3cQUF5bhzJug0u8S9imTEmzRTGQ3yaXhFcr80CKEJw5wgcRcjxOKOFJZX5VFmNsMjFkpMn50LsJF/1tmptOi8C7+55QalN6kmK73lhpa6DkoqfH8y3vOeP5p4NsLYRtJ79SBNcjpaJ8rT31D6B2WvJvn35Olo/UoxgvNxYiobdbUW1r+ZdrUylINJWfZ0GU2j3ULFgtq1rrpVeo/fLIZ7IBycQofMRG1nr22EswJY2sJIwHUHUgy79z
 OAP6C1/0
 l8tIaD6IwRFw6HFqxm9y2d6gGOkxqaR6fq+2noTScchCpWOh4XSBv7q3KK6D0rBmBxfpeIMZvpnNI/8KoMF+PK0NW5gGQF4Q/LxorvLR4RnPbfxXW6REmqX994jXkxFnj909d8tRQfAoQfT69o/sDAsyoeGaY6y1chXNjpCC94esqTgyNTKecWNdhQlvgzeS+YvEQz6Z2htNo68CB9xY0nBHGOHsY0RtejSgvSEVFsjd/FtMr99kVYcCDwwGhbF5xanrJqLqh/KD5YMEfbEu6gKJ2z0F90c6fn3e0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 8:54=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> When scratch area fails to reserve, KHO prints a message indicating
> that. But it doesn't say which scratch failed to allocate. This can be
> useful information for debugging. Even more so when the failure is hard
> to reproduce.
>
> Along with the current message, also print which exact scratch area
> failed to be reserved.
>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 49bf2cecab12..636bd96780ae 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -651,8 +651,10 @@ static void __init kho_reserve_scratch(void)
>         kho_scratch_cnt =3D num_online_nodes() + 2;
>         size =3D kho_scratch_cnt * sizeof(*kho_scratch);
>         kho_scratch =3D memblock_alloc(size, PAGE_SIZE);
> -       if (!kho_scratch)
> +       if (!kho_scratch) {
> +               pr_err("Failed to reserve scratch array\n");
>                 goto err_disable_kho;
> +       }
>
>         /*
>          * reserve scratch area in low memory for lowmem allocations in t=
he
> @@ -661,8 +663,10 @@ static void __init kho_reserve_scratch(void)
>         size =3D scratch_size_lowmem;
>         addr =3D memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES,=
 0,
>                                          ARCH_LOW_ADDRESS_LIMIT);
> -       if (!addr)
> +       if (!addr) {
> +               pr_err("Failed to reserve lowmem scratch buffer\n");
>                 goto err_free_scratch_desc;
> +       }
>
>         kho_scratch[i].addr =3D addr;
>         kho_scratch[i].size =3D size;
> @@ -671,8 +675,10 @@ static void __init kho_reserve_scratch(void)
>         /* reserve large contiguous area for allocations without nid */
>         size =3D scratch_size_global;
>         addr =3D memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
> -       if (!addr)
> +       if (!addr) {
> +               pr_err("Failed to reserve global scratch buffer\n");
>                 goto err_free_scratch_areas;
> +       }
>
>         kho_scratch[i].addr =3D addr;
>         kho_scratch[i].size =3D size;
> @@ -683,8 +689,10 @@ static void __init kho_reserve_scratch(void)
>                 addr =3D memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT=
_BYTES,
>                                                 0, MEMBLOCK_ALLOC_ACCESSI=
BLE,
>                                                 nid, true);
> -               if (!addr)
> +               if (!addr) {
> +                       pr_err("Failed to reserve nid %d scratch buffer\n=
", nid);
>                         goto err_free_scratch_areas;
> +               }
>
>                 kho_scratch[i].addr =3D addr;
>                 kho_scratch[i].size =3D size;
>
> base-commit: c37fac0551448c68e36f14782acaf662c7a1775e
> --
> 2.52.0.457.g6b5491de43-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Tested-by: Samiullah Khawaja <skhawaja@google.com>

Tested on my test machine while investigating the scratch space
allocation failure.

