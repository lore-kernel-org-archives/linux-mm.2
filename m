Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57075C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E356B0088; Tue, 25 Aug 2026 14:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F2F6B008A; Tue, 25 Aug 2026 14:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207156B008C; Tue, 25 Aug 2026 14:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE44D6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:10:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DB5D1C006A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:10:13 +0000 (UTC)
X-FDA: 85140581106.27.8EDA3A0
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 748CA1A0006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:10:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PDt7yble;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787681411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wv/8i2/r0DhMFhYGjiSe41oBSJemDQDm6k1QAsBJN70=;
	b=lfo5v++kZM3/9opA1QRpbvXtY1UK+Xg9H2JcR8q4I2SEB4n8BkuVvfOh3Xk6ipbcLOAXn6
	XJ2Hr2GySCjY2i0kqIkv1M3vdTZDSXvqwSt78k/HAm1mzwkdHEVH9B+ucu4kgmvbOculSq
	j6Dt9e82zMi0qT2HEBagwSGQwR00RhI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787681411;
	b=T3X1TLN1yphED+/v/T87IQbbMK4Pntf1kjyl7CAaxleQRJGStLhoLXxVZfPGrRA3B33bVG
	nvNNPrS0SbNkIj2EeS62gRCC4VjYUD7JZgJ2O+hL8Pb0Z0Iqv4Up3vreRHrVfPsmVhnYHp
	4eAbMPyFCwVOY2JWk3ovOS4Q/8FHeaU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PDt7yble;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15d111ca99so618737066b.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:10:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787681410; cv=none;
        d=google.com; s=arc-20260327;
        b=SFgGWQ4unxgaZQ1e0Dc0gHtGmnEeDe3x7oY5upuvFqGwQO+3xlaoAKh8wBFnxDTFSJ
         BlbUO69T9oX5SKGSjQKo8TmieGgFeCv+xYzJiuLFPbTKaDVaQFNtQUhZrlBM/ocwb0Mj
         mvGimfGUPCYtiqWWno+RHKdN6WB3gN2YSP/1wF99kHjLt/tAaABFu0DSpQ054Lxg+dsw
         JRS3WuNSvPFhhqICMJzQxQ2R2O5nY8dG8tO5MjIyVXeMl5dC30BNMgKofhb/fOlN1qgv
         lLowbsYt2Oz8Rg3ubOrMBfqabRrubDeg6Ru4duzmViAK+MHzPyQDR/+y8R693P1UEzg2
         +CFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wv/8i2/r0DhMFhYGjiSe41oBSJemDQDm6k1QAsBJN70=;
        fh=eYRu7JSKReWQM6KU4duSL5OkJ8+jSBAam+vw4WVfLlQ=;
        b=ADEhrz+aTYy3XrHQ5cuVCbYqLRC5UfJpcadDDgGMbeX1tR5ISc1PrwgQUX18tvPNsz
         0nD4+hnAsL/eq1DF5nKd9VQsSsJGG3UatOq1gzN8rI9OwOgTQGm5qeapp4yM3mdaZgt2
         smOO7uonKTt63ER9KDBg38E18du/5qah4NV4BwP5Z6O+RvbVVNYf4iO2KSJsNacYgVr9
         ZaGuv9zoWOKMErwGt1thCkoLSCuXP2rT9Am/ffygi5AKN5rJw0cfwYpFgTrQLqeQyyfP
         H+kqasKO9BAuOkHyINi2NZUCMVLjBAsTos/51jX4bVlHMcf6mtOZBO7UeQ8qqaN7f9U8
         uB1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787681410; x=1788286210; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wv/8i2/r0DhMFhYGjiSe41oBSJemDQDm6k1QAsBJN70=;
        b=PDt7yble0VpUTQKtn8R0gS0OqFTSjl6OR0gLivs6KvhLcMvI7BlwxN4qANbj0r6UHL
         g2RrizrPCGt10t3C3nQhf7mOiBjDu2koQ48g7Mpti03QxWH0StcTy55T5cvlgIpuG3Zi
         BnnfP9l5lh/1l0zbLhRu6MHap7WS0TuaW9S01D+RKXmFzbUm2siEfIfNY9x8IIB8cwCh
         r2Rdo+UkeeSYR0oLlNO4/9AOyZvVZZGSGF172Zh/2aPuG1RBxW108i8TczgBJ2szfHZX
         2kquWgPGfESRQXYPZDBtyQQ95/PeoYDrquMSW/ddIgpI9cREwfMCx/Xz0ULh91rLjMIB
         scIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787681410; x=1788286210;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wv/8i2/r0DhMFhYGjiSe41oBSJemDQDm6k1QAsBJN70=;
        b=d2dhPIJyl6mluH8fLIyehDa3b8SEH4thelFEKpeRy4HuC+bXWPqG0gON3vGBnZspnm
         /4UVcKSCBvRRpSCOsu9B3kZ8eKp4fU3eyVrEcOxXVtBlmeCrLHHM18ZazKxHFvbtlGK8
         kv4ssYkaSbd1G2UahYqfTZeybuvqaX64xnwCP8uwFguLDY//Ra8zEV1pUHO7uVAfTXEx
         cIGIqQb1pLR2Vlnt4go+/D/RhwHvJ4MmlcBvyA3T4EaKdOwtRNbYgy87kDbwDmyodYb1
         4VOMQ7Imx7bATzcNwx+zp2AV+MZp4A0dE6MmmHz9pmLxWdEyGLkv40znyy9Vqm/6CYWO
         ynnA==
X-Forwarded-Encrypted: i=1; AHgh+RpZxEJzcvyIiiwopSdD7PAepqXFzW42Grvq78ciKgGlTcq+vYo9HA0Hyk5R9mHrQ053dR+NOCNCpQ==@kvack.org
X-Gm-Message-State: AFuF++nsKN+iqXu/CZBVUeoxRZQmw2euVlQhx8JA/c/7dR14ij8aNfCc
	XUR9fVk0+Rq5J9ZMFPAlbCrnHQJNZ/oBQLQrakdpj0fs6eKvQwUcWwoyfx/y+chLhPXZTKDzpyw
	HGRaP3L9jzU9eR48A2ZxsHT8dViO/q/w=
X-Gm-Gg: AR+sD12iz7s6/s0NzSHlwHf+SxDDJSXccFoGRDMRzJTGjrhpShqIi04hnQqGl9r4jbF
	2/nhhLATzBUgG6P0s2E9hgEHbx2x1ivzua6ROhLDtnEHfd1o0heKOi+LTJEJhJh4uMYTHqkVj2s
	hX0iyAt7/ybSNbths03bEsdkKBNVLiGX6M39VSlbzU2tVhaDuwR+XDV5+asqF9SvkxQMd3A3DCw
	CMV3GlL29VRZoWlKH+L5sTqAdxt+i82xzVuXN2R1IyIiGNAsz90ri4ymChbY1zCxCcnXFUPmC3t
	hgEC5aChrw7moQ2b4JfCT1WkJKGXU72/xQCwlcMC8yAvTgv6AvJK7LG0AoPbsecUZvHRUEszU6a
	ySQ==
X-Received: by 2002:a17:907:6d27:b0:c20:3679:a2e6 with SMTP id
 a640c23a62f3a-c250bbda55cmr52812166b.10.1787681409534; Tue, 25 Aug 2026
 11:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com> <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com>
In-Reply-To: <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 26 Aug 2026 02:09:32 +0800
X-Gm-Features: AcwNN1WoWZ42TIcBIvQ4FM7tCHGkzPr2iUpFfJEQyW4tsoobZ0euPIhWqeI1ZtA
Message-ID: <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d1kucy194t7qpubcuwhin7qbd51gn1jy
X-Rspamd-Queue-Id: 748CA1A0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787681411-878511
X-HE-Meta: U2FsdGVkX190imUOzykBXew+fD3Sj+1w8T7M2feCYglV2NiPWTXqMGJ5eDhWmlGFGKJY5k6jYJcyP2EVsjlREQ//cREDiRXCvJ+6qES9gi+zhm0U99USaTWkgq+9Bm0rDOw0WUeYqpD0GzEXLYSKI9uHbIr87JLVyMP+p+7fhxdAobNsnfJKwd8h/ScukcCcrI0uzD61T02CzYrMqBfDyWqiiYxKh6MY5tWIQh0XVEn7QH9BPVcPkZaBmUbOdPCalYH1u89EgZZsmnQVdmyYx+XomE8kml3i0sjPoYWUK9dLGh7YIPeb/fPysbweGZRhalCyeoDN0wxMtZSvZdIYO3AQtPZESa4NN2fANvD3KlkJ4fF01HrW+h51bnH+PllOKrZAmestE9mtipntJ72FT6yHKXWsPWx0+c9kcAAk0ZORg6+EyWOtujpT5DSCcXqcJaRfMOLxN26rcIJW2EHcIeiYKPyNOmoFxKy676u5ERnVVnpbetAduvqm45XfZ7jkN1j7WOrPIXwOj+QIJ9e51jFjXkTCYDS8ZNgIXes0BCE6eTpoNTAYy0NM9BZImZaZFdQiZd5blUzHkUScAPhf9vT1OHNI/v2SJ2mAql9LVQPkfPP8XHGxjxXNl+sXh7J3rEu9NnC9BqYRCLJeDeRMvV5TwUOd/qKhRQBL8VeMV1CGLlHsqZYv0teVJCvp/PRV0Iq1GL7hLgFq4sb2VnX6MdgXULetkqJrg3BEsnqD8Cvq3/VvvO12Ysgz7QY30sNT9Sg1YYSy/lPxwuBhNuWql7Ju7NG9hcf0v0mM5vm6L9WucYK8YCRNKzaJqgLSv/OlCdMuGS1gq5mOkuWSy5pcCNSiMIMob1tA4j51URS0CcevWR3WbF+xuoUq78dyJEh6U/QWmQlQmVHrZ4mvZXJ2bmVv4ppOmXrSCsc/wVDtXfiCSnL+dNK5S0SrGSZKEHg27uQKI69X1eFh/pWdzVh
 aayo06Ub
 6k/1mt6ORBtdx81ic/+NLyZ5heUdjfXmQ/4TtwUWFmB28jq323ERQmCpzsZscBsCftNu6o6/EdE6Ep40qW5B5Xgqgu9extEB5Y9KYTwEv1Rm+v1NnUZZEI5x1C0JxV+fi0z6ZincirTPhzwcSSnCawXwWNk60+EOJ0uYvem+HTgS+iJXZoFw1LpD01J1sCLOz5gZfbXgNXMvbyKAXM8fyeZggqypFiFv8OGeLuQkDuTdFUmn5mErXQGn7Q0+VWGkjsL8MdKBUDH24GihmWESy10rAhYU9ggNHv7+nVUO/8wqdmYw4faGvj1Y92ThMLs4lxnMOEkDAKZaaIueYIbnXtHeXqmj4xbHLphJQJHveig83CHHj29CSFnyBMqEHS2mm8kqtLXpQHDVNGTmRZ89L4jJv3aji1f4kd1CBBXUwcwvoa3bJX6PDD8caT/k2qMmZdiS+rMNeZLpYXyt8ObdRWy2RuiM2EQ6+woRvA81WwrlVS8kmZdbYFdhaV2h3sUy1WJ0tgzCoy89Yf6DoaW/lKb3l7UCSZu+YB8Pehjk8Xj1Qljc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 5:06=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/24/26 7:05 PM, Kairui Song wrote:
> > On Mon, Aug 24, 2026 at 3:25=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> >>> This is a cleanup series split out from the MGLRU swappiness series [=
1],
> >>> with the cleanup changes separated to make them easier to review.
> >>>
> >>> Right now, isolate_folios() is quite difficult to follow:
> >>>
> >>> 1. It uses for_each_evictable_type(i, swappiness) to iterate over the
> >>> types, but i is not actually used as the type within the loop body.
> >>>
> >>> 2. It uses scanned =3D=3D 0 to detect whether the current reclaim typ=
e is
> >>> exhausted, but this is not an accurate indication.
> >>>
> >>> 3. It has an internal retry when no folios can be isolated after scan=
ning
> >>> some folios, but the retry is implemented in a way nobody can underst=
and.
> >>>
> >>> This patchset makes these behaviors explicit and much easier to follo=
w.
> >>>
> >>> Run kernel builds for several rounds in a 1 GB memcg and take the
> >>> average build time. The patchset shows almost no performance impact,
> >>> with a very small improvement that could simply be noise:
> >>
> >> Just FYI:
> >>
> >> I tested this patchset with a 3G memcg limit and a 10G zram device,
> >> running 'make -j32' to build kernel on my 32-core Arm machines, and go=
t
> >> some performance improvement for ths sys time:
> >>          w/o patch       w/patch
> >> sys     1845s           1570s
> >>
> >
> > Hi Baoliln
> >
> > That's a very interesting result, can you share a bit more info about
> > it? e.g. vmstat? I'm curious how this happens.
>
> Sure.
>
> > I suspect patch 2 or 3 changes the swappiness / reclaim / aging type
> > selection behavior, or maybe it reduced the reclaim amount?
>
> I gathered the memcg stats as shown below.
>
> It looks like the direct reason for the performance improvement is an
> obvious reduction in anon refaults, which is what this patch aims to
> achieve I think. That is to say, we should respect the type chosen by
> the PID for reclaim, and try to exhaust that type before falling back to
> another.
>
> Before this series:
> workingset_refault_anon 59706846
> workingset_refault_file 9229283
> workingset_activate_anon 15108561
> workingset_activate_file 365660
> workingset_restore_anon 15108561
> workingset_restore_file 1018493
> workingset_nodereclaim 0
> pgsteal_kswapd 0
> pgsteal_direct 92589340
> pgsteal_khugepaged 549
> pgsteal_proactive 0
> pgscan_kswapd 0
> pgscan_direct 456629355
> pgscan_khugepaged 549
>
> After this series:
> workingset_refault_anon 41277086
> workingset_refault_file 9131522
> workingset_activate_anon 12924656
> workingset_activate_file 345901
> workingset_restore_anon 12924656
> workingset_restore_file 1005959
> workingset_nodereclaim 0
> pgsteal_kswapd 0
> pgsteal_direct 71723800
> pgsteal_khugepaged 4013
> pgsteal_proactive 0
> pgscan_kswapd 0
> pgscan_direct 342179445
> pgscan_khugepaged 9311

Thanks for the info!

I think it might matches what I had in mind: we currently have a very
subtle behavior for MGLRU: in try_to_inc_min_seq, it will refuse to
increase the gen min_seq beyound (max_seq - MIN_NR_GENS) even if the
last gen is empty, if another type still have MAX_NR_GENS left. As a
result, if one type is reclaimed more, and another type have many
folios stuck in the olest gen, the over reclaimed type will have a
very tiny oldest generation (all new folios land on the oldest
generation and are reclaimed immediately), that olest gen will stay at
a near zero size and gets exhausted very frequently, with min_seq not
increased.

This will happen to file type very frequently if swappiness is low, or
happen very frequently to anon if files are frequently reclaimed,
really depends on the workload.

The old "if (!scanned && type_fallback_allowed)" will return false and
raise the priority very frequently. Raising the priority means the
next reclaim cycle with run with larger reclaim ratio, resulting in
over-reclaim on both folios and slab. What's more, it might trigger
aging.

With this series, it will see that as exhausted, and fall back to
other type, which in fact respects the swappiness / PID less, but also
avoid the raised priority and over reclaim in some cases. I did a test
on my machine and it seems matches that model:

Before:
*** Executing swappiness 1 ***
sys: 665.941
refault_file: 945242
refault_anon: 916129
pgscan_anon: 13195435
pgscan_file: 2419874
*** Executing swappiness 60 ***
sys: 650.801
refault_file: 238839
refault_anon: 1026646
pgscan_anon: 13082867
pgscan_file: 809642
*** Executing swappiness 100 ***
sys: 621.135
refault_file: 211113
refault_anon: 931943
pgscan_anon: 12008517
pgscan_file: 778586
*** Executing swappiness 150 ***
sys: 633.591
refault_file: 198239
refault_anon: 987093
pgscan_anon: 12645094
pgscan_file: 709927
*** Executing swappiness 200 ***
sys: 627.747
refault_file: 163649
refault_anon: 1024657
pgscan_anon: 12088189
pgscan_file: 653841

After:
*** Executing swappiness 1 ***
sys: 729.234
refault_file: 962067
refault_anon: 1175614
pgscan_anon: 14588298
pgscan_file: 2396037
*** Executing swappiness 60 ***
sys: 677.685
refault_file: 238877
refault_anon: 1008627
pgscan_anon: 13744350
pgscan_file: 888445
*** Executing swappiness 100 ***
sys: 668.947
refault_file: 250359
refault_anon: 994929
pgscan_anon: 13307019
pgscan_file: 794981
*** Executing swappiness 150 ***
sys: 649.764
refault_file: 180899
refault_anon: 971073
pgscan_anon: 12238885
pgscan_file: 709684
*** Executing swappiness 200 ***
sys: 648.377
refault_file: 228112
refault_anon: 1237758
pgscan_anon: 12653346
pgscan_file: 734499

So I think in theory we might see more ineffective swappiness after
this series, I'm also a bit concerned about the "lrugen->min_seq[type]
+ MIN_NR_GENS =3D=3D lrugen->max_seq;" check which is strictly related to
the limitation of try_to_inc_min_seq I mentioned here... In the long
term I think we better get rid of that limitation, not sure how the
behavior will change or fit after this.

BTW the above tests were done with ordinary block SWAP, with ZRAM, I
see an improvement instead (it's related to how SYNC SWAP discards the
folio immediately and blocks the thread while ordinary SWAP does IO
asynchronously so there would be less concurrent reclaim, and changes
the dirty/writeback mix that evict_folios()'s
 loop sees, especially nr_reclaimed, and here we will avoid raise of priori=
ty):

Before:
*** Executing swappiness 1 ***
sys: 599.135
refault_file: 925843
refault_anon: 1838025
pgscan_anon: 20390687
pgscan_file: 2423955
*** Executing swappiness 60 ***
sys: 591.367
refault_file: 336184
refault_anon: 2350551
pgscan_anon: 21099503
pgscan_file: 1109003
*** Executing swappiness 100 ***
sys: 593.672
refault_file: 328276
refault_anon: 2332940
pgscan_anon: 20894727
pgscan_file: 954910
*** Executing swappiness 150 ***
sys: 585.939
refault_file: 296374
refault_anon: 2063673
pgscan_anon: 20537898
pgscan_file: 935107
*** Executing swappiness 200 ***
sys: 574.283
refault_file: 313356
refault_anon: 2065897
pgscan_anon: 20145043
pgscan_file: 881381

After:
*** Executing swappiness 1 ***
sys: 578.699
refault_file: 844457
refault_anon: 1793171
pgscan_anon: 19307170
pgscan_file: 2364248
*** Executing swappiness 60 ***
sys: 582.053
refault_file: 390580
refault_anon: 2066277
pgscan_anon: 20413030
pgscan_file: 1201373
*** Executing swappiness 100 ***
sys: 567.520
refault_file: 295709
refault_anon: 1923291
pgscan_anon: 19299837
pgscan_file: 978007
*** Executing swappiness 150 ***
sys: 582.983
refault_file: 311833
refault_anon: 2041126
pgscan_anon: 20547029
pgscan_file: 940061
*** Executing swappiness 200 ***
sys: 562.710
refault_file: 301914
refault_anon: 2005846
pgscan_anon: 19257095
pgscan_file: 839522

So in summary I think the gain is avoiding priority increase (by
falling back to another type and satisfying the reclaim target in one
iteration, when one type have a tailing draning gen); the loss is less
effective swappiness. In fact, I think we might fall back to another
type MORE, especially when under pressure, not less, contrary to what
the patch message suggests. Not really against this change, just a
headup that there is a impact on swappiness / aging of this change in
an unexpected way, and things may gets more interesting if we want to
lift that limitation in try_to_inc_min_seq as this is directly related
to that.

Right now I'm checkng if we can archive perfect swappiness as the IO
cost factor for MGLRU, and avoid OOM when under high pressure, so at
least the blocker "get_nr_gens(lruvec, type) =3D=3D MIN_NR_GENS" for
reclaim will have to gone I think (we are already seeing tons of OOM
causes by that blocker).

