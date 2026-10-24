Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188BE606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=diYYQnRB
Received: by kanga.kvack.org (Postfix)
	id 2AA576B05B0; Sat, 24 Oct 2026 12:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B7B6B05B1; Sat, 24 Oct 2026 12:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1242F6B05B2; Sat, 24 Oct 2026 12:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03576B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 12:25:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A56980357
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:25:05 +0000 (UTC)
X-FDA: 85358044170.13.EB5CD11
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5EE9140008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 16:25:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=diYYQnRB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792859103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta6b9kStTlqhcUIrK0rj2jJZhUFfSCgXPRCGwSKRipw=;
	b=0i0gau3dFXI2HC3xcFRyXxRxoJZR/ETSMSN/mouos4/CqUhUDY4CljMgT7B5P5zh3pUoGZ
	VETlB4WFERDb58feGMAbmmGC0fzpU2vKwW1cwf3brTA/n82sMVdsgPWlyDafpk9F50dnvz
	UoTchNfyJoMhtuZtLr7mxruzL1A2Sww=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=diYYQnRB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792859103;
	b=oPiGDQYrgTK3Vg6WV1eGxEXz31r6qZT44H5Vbq1OvFiULQ+lGsTNneZWuvWiH/8Vxsvnzo
	NG0Vcol7Z7nk50JCJ7jJGLCBXlCdQDqLtgU9lQV3UAQJXHkayBYvG6NYR1QGjA/wqbC0On
	mHAaDdzHkWqWcslDpjRDHMlhBtL3294=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c468bd799ecso229047566b.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 09:25:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792859102; cv=none;
        d=google.com; s=arc-20260327;
        b=UY3ifuil13DwbDrJIJYApdFlpVIOAxh+hxZzPKuGVTiar/aeA1fuWyGW6tZlFDPV4g
         q46L1nw6RMcFFOQMDgMJvtXR//DxEimygSFrcOIcvi6Ge2IIFe8Uctl5WK8Ak3+ptiPs
         PXqbVHS0pDZjSuCfTvx3IQPr5WfzHjH1ur2qKNYIlm2Z1VRH7m9n7ykme5UlLTnRe75l
         HG50iUM0pYKzpo6VE1QyV6p76x/YocZWDxUedVWC4A1yk5YlEn/IRPBWpn6p6oKvlGbs
         eNX7Y1KetNw8hI0vnVPny+tdg/AvukTAkrOrRDS2tWNfRYgT/bceYcmiGQf7KKOqCOa8
         bODw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ta6b9kStTlqhcUIrK0rj2jJZhUFfSCgXPRCGwSKRipw=;
        fh=HG/a8XrVlSdo1woEa3FAeeBClH/7ZKf/nXCukjecrhU=;
        b=LHDCAzk7UBYRFP/I1b653zhCpfzQtkDE7bNP5/2V7efyzUSyIhE9iz2yd1ktkChc75
         FE9U+FdVkPyjAFfo/f7unRDIkf44Vdc+2pnLN0hDE9uYV17uyqqU/whCnaANTRwk1Zyf
         AsAvwLXdJj80+Hcnnlej5W6+bR+vNHzExWZV4UwSgjHzNXt3uFNapT2NZlDXteNr58jA
         BF9Cbje/tVlO4C3kevlzKH6kGbLQvlsy9QPnQjCgMuOB00KhlOzPcj77Jle6b6xl8vS0
         4Ao+1yX5z0XzS/zn6tgIRTZV+hEEPH6BfVM/ZkcUOJRw6ASgrOvJZFQxuYAxwS5kYhLf
         YEzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792859102; x=1793463902; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ta6b9kStTlqhcUIrK0rj2jJZhUFfSCgXPRCGwSKRipw=;
        b=diYYQnRBdOQaeaDKdtAjaLeDuDjpJDLfcyZud2Crlxg/oRv0BjC1IjySHiYnO2KTYn
         XNNNvBv2W7rDv0Uxbxzyk/mgm7xiJBPW+RgkzWMuGUKZPmimEYvF0a63QBMHbQHK2XgZ
         B7bIn11I6dI6pHfwffMQu0rIpUdfNWFWnmP5WMx1IWRPBOBePHNHyHOzCsjEh22srGae
         ax86TQEgL+Pwr/9eIypoWBjjgtUNS/+abYUcaX2TxUQ1qrBQ5Lcjb40zzeoxGY/xC87b
         qociaDIRlic3408cKRYSzYbmJkub5kYm1d6q9LD73YCVPEIenv6hz6oz6bAS9FgVqAfE
         GQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792859102; x=1793463902;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ta6b9kStTlqhcUIrK0rj2jJZhUFfSCgXPRCGwSKRipw=;
        b=GFIxz7C+b3ScKD6NT4y+cdpaZZKWnKWthenRYYBKhR7Q7V4Zws1TYRs5akoVX6+V1u
         1ufvFuBXP+9sOEtFL+1P3Gvg3Q/GRnqAWoJ+nWX8Nn7ut/8JUWLLdykLfo/Mj0BIKrbz
         46KsUfeCngZdzoCUT/Vznor9v6ROTMTK3udygy20d02USAL1SS7sv9Ro1wdWX2BxSt/V
         6yEEmTj+aoVfrIQFq37tHHWGdvvAJKrm4SivuQTOyjJuiHNiOVy7aTRsIyqdza56n2qi
         dVuHt4lIhxK3FOC0YxmCMGJxA+azp0LGu93Os2MozPcanh5t2MY562LIBfDzAWPQdgs1
         0NPg==
X-Forwarded-Encrypted: i=1; AKwUvBxjx3920Bv3BdTsjGz/g1PkTROlAgkq0KsytC7iWr5iKxx+RbvWRO8RIAKDw4qqfhBxfddIZlpYMQ==@kvack.org
X-Gm-Message-State: AFq9FYK694Y2+DvsBixzpNlm56H4XEcriWlqGts4Cs2y1DBTVQsQSrgc
	CTMk6OnMVwer5xQpqfmyaFuefH/uZz4PVuxu70UFQmmOABuIfKBJt+2ZKj3FlzldcF2MRT1uMHH
	Xn14fF+dTLGaLRorBmOZv5ICBxQkYqvs=
X-Gm-Gg: AYBFou3BzI5lB74UabMk4sMvREfmeANMu5lVw9NXqWLuMtGYdxVr7hsPVM1nvwy11DB
	UBrb2Dd6qWys09Vkh+J+pkccj9Dmbjpb+6NLzehz2SHttmuGyJqFuhzKci7zU7RadBVYdZMTOkf
	wig2XsDQZiV0LDzQ4nziMXtOx9SkGUT8tbrdTaa9y1TDOr1N+csrRhcJnv2Hx6+bc90db3kAVx4
	Mg6vvJVub89CnputB7ED+LlPeUPAU8tbTqozahHP63OVqeqDHTLnQ6wcgSP+IKnDGry32s1kLEJ
	quWtZWHygEvLJ+6oBQfCKrJsNLUnjRZjwm9Bx0UZ81RouPU95MMlkFaV94TrAGhBDw54oCo40Xs
	ceCVDF/EhmxlmklduhzFlRgkdyUG9eMvXN16iU4bZW8E98eT2AwNWKrHtzdarhKq7Ve64Rw==
X-Received: by 2002:a17:907:930d:b0:c41:8736:8c38 with SMTP id
 a640c23a62f3a-c46bde59590mr245827766b.30.1792859101720; Sat, 24 Oct 2026
 09:25:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022220203.91911-1-baohua@kernel.org> <20261022220203.91911-8-baohua@kernel.org>
 <sashiko-outbox-183273@kernel.org>
In-Reply-To: <sashiko-outbox-183273@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 25 Oct 2026 00:24:25 +0800
X-Gm-Features: AclHuK8XZLGPPGEKrhXrigZfLOFmwwSSuwTBiqIswh8wTsjxAPb2yu1VJB7vo4k
Message-ID: <CAMgjq7AZF4R8voNhsbj5Ede7NR19k1tkAMGnn7556ydB2ERX5A@mail.gmail.com>
Subject: Re: [RFC PATCH v5 07/14] mm/mglru: balance anon and file scan budget
 by refault rate
To: sashiko-reviews@lists.linux.dev
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	hui.zhu@linux.dev, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, hannes@cmpxchg.org, ljs@kernel.org, mhocko@kernel.org, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, zhuhui@kylinos.cn, baoquan.he@linux.dev, 
	liuxiang.277@bytedance.com, wangzicheng@honor.com, lianux.mm@gmail.com, 
	liam@infradead.org, surenb@google.com, mhocko@suse.com, rppt@kernel.org, 
	zhangbo56@xiaomi.com, lyugaofei@xiaomi.com, ridong.chen@linux.dev, 
	kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5EE9140008
X-Stat-Signature: hxyq3ss85gwmzxsbz9pgfbeiutkmk4cm
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792859103-87141
X-HE-Meta: U2FsdGVkX19cjBcwKKo/zzzkvfLz9MeLcReloTmYYQUYwPseGHoRVsMnmqZlihGvbQWtm5C7dCIJUYKC+iojabknoZ8EncNGUpNXQpHTyDWWrq0MhEku2g/wYAAw3Q0l/noH57c2lq6GYdardUAt5Rw8FPc/Fz7DIZLkq2aKteVxCRXuLFemxCpFdpEt/TqGLL+CpQa5AUr7YMrX6O+r9fZ9n/42imbhYV6n0ewSXmBv01QG1C/dMN4lhioLLNwpV3YX4+aqce5HfdxGfriznnxNs886MWOtPanN2Oylgvqci16+FsaxPwFffMysfNawmz4/Vg1Cy6gnXEa9EwnCNuhjSPVgLap/H9EvKCFvov24RBUfqN8d8pjCUY7tV+TvUs7G0/yV/54yjVCPjIy8iq7ExHjhKHvkj427bwsNkAYOOgYptqWHHci/ZbBPCvRfMz+tY++wt6/0eOeM/P0ItASVW1teEX9Bf3U8l8G1pWUvQfw3aa6uQmxOhim+iwm7wJXFUPmIFPbutijF0fivQR/MA7Xx7majHydutOgTgZikzEO0iphPADJI/Szhsdw2nrXnuFcx+IQESL288qqiJgZM8Ikxu51xBF5MapmVeMx+1R9W92/ZeGOIVMuSiJ4O7h2wh3JoQaUSLNKImFVYfEUYlsKdmsw1NWnPm1KUxA958VMEuUy++Kqfj3p9kTD10Ct6o2mE72JGu+SY9ibDqIGCp+1MfCl7e5HN7/EGGre08xlxX7ypCG9NHlqbIFiKCG03JOxmY2Cr/42ilLyMTKFgTQ9Col1oCmyVwiR8INXjqd3s+Tb6T8pF17zlyDyq6/eg+4GE8y/pRHDIPHpFOjwgUFUMK+nhkBoWxrhG2zvDss8ElM2YYje3KuxmunOTll5V9h1LUFeBU6Pe3Vq4G6z7OhSTtPrjiKl++GWOgdMPD/HaULEMJer/Ad9uz9mcqNSXa7vGoJzGZMH4qjM
 0hSh+vDs
 BFy2+u5eY2VyaVQxMwEbZXkmB0IuJhvOx+do70fLsw4z/BJ8sFMtsK56xz2DG1mVuVuKMeuNy7ZTP7lkaGg3Fp2OFR4dyzZppg0+4UjMVN7qkLXm5U79O7LbaPbZ/rnmknw3Z63/VFx/nzqsyJBGX2AYTk0opOGX7SjKRTQFGFgdu5YAjMQ0TErEMBp9tY2gDyiVUrCFeZ5Fen9B48iPggEFQWH+Am8nKmTxgVeAazdmerAwFH6EykWnDSpPSFPYEMWjZkMpPj3mpbH1/v4tVxdQkhxRTJOAWOdwzQOKwkKsjRLUbZ6hCrS1Ewu4PS2mX2UJGl9mfNbJ9LLbSXPuFBcT5hhs/s9QDBuahyLQ+EE/SwA58nwTQy0lV29kRXE6zy5DxionouZVBWH3zvsoAPfR78P1wnW7943l+OBdUwjDJv6WGmniLGKflGQdTAXKHn/Ma393PrLiRveW2owfYrFDx+ulOmPtXRJsdQUu86jp+icTFDxPha7a8irwMI6cWf8Mgwnl9bERmYaXNDwkETkeFaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 6:03=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] mm/mglru: lru_gen_balance_scan() budgets un-scannable gens and=
 zones
> --
>
> commit ce196f9c0d172466d44f73b512ed408a9ecb6e36
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: balance anon and file scan budget by refault rate
>
> This commit replaces get_type_to_scan() and isolate_folios() with
> lru_gen_balance_scan() and evict_folio_lists() to split the scan budget
> proportionally between anon and file LRUs based on per-type refault rates
> and LRU sizes.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index cc20ba8c6cf2c..fed39b0422e01 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5019,79 +5019,110 @@ static int get_tier_idx(struct lruvec *lruvec,=
 int type)
>
> [ ... ]
>
> > +static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness=
,
> > +             unsigned long total_scan, unsigned long nr[])
> >  {
>
> [ ... ]
>
> > -     /*
> > -      * We are running out of the current reclaim type. Fall back to
> > -      * the other type if allowed.
> > +      * The more extreme the swappiness, the wider the IO cost gap bet=
ween
> > +      * anon and file, so the split should follow the IO cost ratio ra=
ther
> > +      * than the sizes. With a mild swappiness, balance the scan by th=
e
> > +      * actual LRU size more.
> >        */
> > -     if (!scanned && !tried && type_fallback_allowed) {
> > -             type =3D !type;
> > -             tried =3D true;
> > -             type_fallback_allowed =3D false;
> > -             goto retry;
> > -     }
> > +     size_bias =3D max(1, min(swappiness, MAX_SWAPPINESS - swappiness)=
);
> > +     anon_weight =3D nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
> > +     file_weight =3D nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
> > +
> > +     anon_factor =3D (u64)swappiness * refault_rate[LRU_GEN_FILE] * an=
on_weight;
> > +     file_factor =3D (u64)(MAX_SWAPPINESS - swappiness) * refault_rate=
[LRU_GEN_ANON] * file_weight;
> > +
> > +     /* Cross-multiply the ratio above. */
> > +     anon_scan =3D mul_u64_u64_div_u64(total_scan, anon_factor, anon_f=
actor + file_factor);
> > +     file_scan =3D (u64)total_scan - anon_scan;
> > +
> >       /*
> > -      * We scanned some folios but failed to isolate any due to promot=
ions,
> > -      * protections, or races. Retry once to avoid a larger loop.
> > +      * Bound each type by its evictable size. Hand the exceeding part=
 to
> > +      * the other type. Any excess left when total_scan exceeds both s=
izes
> > +      * is dropped, since it only stresses the scanner with no gain.
> >        */
> > -     if (scanned && !tried) {
> > -             tried =3D true;
> > -             goto retry;
> > -     }
> > -
> > -     return total_scanned;
> > +     if (anon_scan > nr[LRU_GEN_ANON])
> > +             file_scan +=3D anon_scan - nr[LRU_GEN_ANON];
> > +     if (file_scan > nr[LRU_GEN_FILE])
> > +             anon_scan +=3D file_scan - nr[LRU_GEN_FILE];
> > +     nr[LRU_GEN_ANON] =3D min_t(u64, anon_scan, nr[LRU_GEN_ANON]);
> > +     nr[LRU_GEN_FILE] =3D min_t(u64, file_scan, nr[LRU_GEN_FILE]);
> >  }
>
> [ ... ]
>
> > @@ -5212,22 +5244,22 @@ static bool should_run_aging(struct lruvec *lru=
vec, unsigned long max_seq,
> >       return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
> >  }
> >
> > -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control =
*sc,
> > -                        struct mem_cgroup *memcg, int swappiness)
> > +static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_co=
ntrol *sc,
> > +                              struct mem_cgroup *memcg, int swappiness=
,
> > +                              unsigned long nr_to_scan[])
> >  {
> > -     unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> > +     unsigned long total;
> >
> > -     lruvec_evictable_size(lruvec, swappiness, sizes);
> > -     evictable =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> > +     lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> > +     total =3D nr_to_scan[LRU_GEN_ANON] + nr_to_scan[LRU_GEN_FILE];
> >
> > -     /* try to scrape all its memory if this memcg was deleted */
> > +     /* Just scrape all pages calculated above if this memcg was delet=
ed */
> >       if (!mem_cgroup_online(memcg))
> > -             return evictable;
> > -
> > -     nr_to_scan =3D apply_proportional_protection(memcg, sc, evictable=
);
> > -     nr_to_scan >>=3D sc->priority;
> > +             return;
> >
> > -     return nr_to_scan;
> > +     total =3D apply_proportional_protection(memcg, sc, total);
> > +     total >>=3D sc->priority;
> > +     lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
> >  }
> >
> >  static bool should_abort_scan(struct lruvec *lruvec, struct scan_contr=
ol *sc)
> > @@ -5260,6 +5292,30 @@ static bool should_abort_scan(struct lruvec *lru=
vec, struct scan_control *sc)
> >       return true;
> >  }
> >
> > +static long evict_folio_lists(unsigned long nr_to_scan[], struct lruve=
c *lruvec,
> > +                          struct scan_control *sc, int swappiness, uns=
igned long max_batch)
> > +{
> > +     int type;
> > +     unsigned long batch, scanned, total_scanned =3D 0;
> > +
> > +     /*
> > +      * Scan both types with the given budgets; the caller checks if
> > +      * reclaim is satisfied after each pass.
> > +      */
> > +     for (type =3D LRU_GEN_FILE; type >=3D LRU_GEN_ANON; type--) {
> > +             if (!nr_to_scan[type])
> > +                     continue;
> > +
> > +             batch =3D min(nr_to_scan[type], max_batch);
> > +             scanned =3D evict_folios(batch, lruvec, sc, type, swappin=
ess);
> > +
> > +             nr_to_scan[type] -=3D min(nr_to_scan[type], scanned);
> > +             total_scanned +=3D scanned;
> > +     }
> > +
> > +     return total_scanned;
> > +}
>
> [ ... ]
>
> > @@ -5948,8 +6001,11 @@ static int run_eviction(struct lruvec *lruvec, u=
nsigned long seq, struct scan_co
> >               if (sc->nr_reclaimed >=3D nr_to_reclaim)
> >                       return 0;
> >
> > -             nr_batch =3D min(nr_to_reclaim - sc->nr_reclaimed, MAX_LR=
U_BATCH);
> > -             if (!evict_folios(nr_batch, lruvec, sc, swappiness))
> > +             lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
> > +             lru_gen_balance_scan(lruvec, swappiness,
> > +                                  nr_to_reclaim - sc->nr_reclaimed, nr=
_to_scan);
> > +
> > +             if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness=
, MAX_LRU_BATCH))
> >                       return 0;
> >
> >               cond_resched();
>
> [Severity: Medium]
> Can budgeting with lruvec_evictable_size() in lru_gen_balance_scan() caus=
e
> lost scan budget and premature reclaim termination in try_to_shrink_lruve=
c()
> and run_eviction() when one type has no folios in scannable generations o=
r
> eligible zones?

At the moment it's like part of the design, prioiry will raise and in
the end we will have no scannable generation limit, zone might worth
be considered when getting the evictable size though?

Also, maybe we can improve the aging on imbalance to trigger when the
scan budget is much larger than the scannable size (and priority is
raised beyound default)?

