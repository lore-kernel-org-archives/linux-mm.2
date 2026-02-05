Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFE8CE91264
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 06:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3956B0096; Thu,  5 Feb 2026 01:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61936B009B; Thu,  5 Feb 2026 01:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D326B009D; Thu,  5 Feb 2026 01:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3BD26B0096
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:05:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70884B9311
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:05:20 +0000 (UTC)
X-FDA: 84409365600.12.49AAB6C
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 591D61C0007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:05:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kvcEkNau;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770271518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBHW4Xv763Y1jThiTf34K0D7Lq+LdxUqx6OdzU7vHqM=;
	b=HgcCiz4bfNiLH6Oy77zFT365geVH4qDDKc+31LJFIgMpsMPrq8rpmdVHn768LD52Simh6t
	Ni0KRJSMOnau1IxwlDvrXCHuHcat1mPpcyAN7KlZaAvu+LRuZlvGWp3qqamX00Xlo8+WEH
	EonxD62GAR1IzW4rZIjg0/1JXBVOc1o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kvcEkNau;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770271518; a=rsa-sha256;
	cv=pass;
	b=XctV2oebo0LyJWVIlymQRaptUZlCn2aSWfRA3QejhFkbSYt2v3zkUAFislRNgFQKId0/c7
	Z43Jpe570LYj5gGt6WeNq+THmEcu72q/tVMKY76MrPbNyd+HXS22E7Yi6lA+oycqVBSruA
	XFNGjiCRI7+XCoakVjR37xAt2A94zSE=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-38320cd563aso5940281fa.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 22:05:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770271517; cv=none;
        d=google.com; s=arc-20240605;
        b=DFcYQN8Mj3spol1s5jxzbV0qFrUfBb04syhHdrdSfQ30u7bTbU2WDNjWL6Ri+oUWTh
         0zBuezn8JQxcgJ726ykmtOCXSp3OjVdjRB8PuitdnuxFI4Xojm+TssOhn1DKx7gLiImg
         ZwNPAcCyE1A92uu0nk1VK8SRTL3wmd4oH7yXqgzH9CzzEh772rjxKtdBCaspnXVtvQNT
         M3c21/sHKit2cmEkXuNyHeW8NKv8cAkdehyGhYAjYmIBcdeJv7QdPp5rN7WXGCJqkG/b
         U9EJ/gH5smvFNJcuzDt6IpkeBNtd9m5bQuMc2Dsf3dnaHKcfKs10iO8khQ4QvDYrzgeN
         5+kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hBHW4Xv763Y1jThiTf34K0D7Lq+LdxUqx6OdzU7vHqM=;
        fh=WoEhivdOEeH/7yg9PruOr6YXyRlN8Vz9k2fiN06s8Qw=;
        b=Hlynay3JcTS4W1G+iGrKaEiIH6CDF9tr114qz+c01GcUX3hr4o90yNfV9ImYqpfnBK
         TcXYgKH8Bjvg+e/QTssj8kxuj4I0YqHWx3uiRmP8g5Fvql9bGYgx9P1p6vg0d0OxbK9t
         2tX2npdt4DSbLnaweJ12EOse3WMEEdM9HBqNrvMcZeg4ll1KLxAjoqtrJQ2jRcv1TIeO
         amqWYIJA9rky7Z++rhDUfwdtZhbYd16C7QhA/DCTYn8rq9QZXpwzBw8XlwMTU0gMnJRA
         /1d7gICJGd0l27WWTtzMX0B9Pd0gZ41W8rY0pSiZiMCP2FJMxf0GCDY1H/ZAU+uRTDtg
         sCug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770271517; x=1770876317; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBHW4Xv763Y1jThiTf34K0D7Lq+LdxUqx6OdzU7vHqM=;
        b=kvcEkNauIkUmxIj+NhittE04DdCUewCki2CW8UUjTkJjMQGr2UwVhi+PMJPqiUnZmT
         TwmogKwydGairnyZdjqF6T13NXJPLkifhXY/wL3aVmvnwbInjY0nnq7+8PW1Mx0e5kJv
         w5ygSIIIu4iXi8SU/DW1WPt5EAP1XH3Vfs27cGdu4El41VOlq7LcWCq5OEVE+PZH0AZY
         hubRkN5RQ/F29Ap+nNulipq3BUqTQfWPtplKYKQ08edDDtol0QEkXaCFGkjsIPBv++rM
         4fo+VXNNvlRz3QpGpUs0/rXcskKjBskGqRgBAChVgM4hDk90x/9PbD5qfiOAYL9xeB17
         S4Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770271517; x=1770876317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBHW4Xv763Y1jThiTf34K0D7Lq+LdxUqx6OdzU7vHqM=;
        b=tfMvk6NDeZOxd47FnwcI5mNUBKgGX98naO1XkZD3mRyV+MgseHDooZpn5RDFL/fH44
         /aSoyFYXlRzA2SZffWFZTkjJ1o1EFmNmvqnx16JWX/+D/W9w3SDuS1GE3A8QwbfOpr23
         /zxuIqqun3PICtaF9IuFwLJltWDq3j1UcTMwFbehlk7wgtcJT8ndcFIr8fKd6t2fLgsw
         fuPxm8/3hAQjFTr9rO6GLsUdpJCqm8zOqMaEukZ+DdO/cCHZ1CUL1yos0Un/WAyG9NUD
         bJdZ/SfJKW7Soyx3i4MGEeRaL6Z8uFqcI9NbhZVgFm7k6lx913lsfoblM6rZgXMtM/ZS
         zGLA==
X-Forwarded-Encrypted: i=1; AJvYcCVd4hxAvxLmEb3Xj9g+XoyAsLaTN4qqNURfaLBCkZeOB7W2izgVOmsM8vJh6H0S0Hb25nxjBkyS4w==@kvack.org
X-Gm-Message-State: AOJu0Ywaz4810JsVOpH7qFBJNKFylC9dgUEc5mfyKlfCtQ4M/Fp+upPp
	2xY3Cb/elbnLgeVxwDkBrU+Vj8ygmu2IfVT2BgVSIlic5ridc+TlAf7SAA2aC+1AmBopc7AmtHe
	XlnsqVqGfWtCU5f30wIcakHs3dH5es1I=
X-Gm-Gg: AZuq6aI7CUrmdtekiX+G86ESDskOC/mPdX/s+PR9fyQbrF7yK1pO761g0+wQ9MdjJP7
	OVR1SUrB2rbK/bvLIYSi0gJ1x10PsJswsyUjMg+SPlRor6MxF4ogGSGHGfDehaXZ3kDaoIQCRxU
	/M+v9slB/pfWVT3L96wKgaAS+K+hffBUfjpC8h/GtrJAt0VSND/xdjSMsQ5EsMqorkRiUhgytmD
	0j587obWcblnKk1Vjj/166US/Ef9kjLDNPu2Mc3Go8EdEucf8w3ZCJTMc8Id9ofrXyyV6tnCz+U
	ECAl0g==
X-Received: by 2002:a05:651c:2101:b0:37b:926d:5bf3 with SMTP id
 38308e7fff4ca-38691c6006amr19475131fa.6.1770271516579; Wed, 04 Feb 2026
 22:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20260201122554.1470071-1-vernon2gm@gmail.com> <20260201122554.1470071-5-vernon2gm@gmail.com>
 <d795eac4-b52f-4984-a92d-6bfc9d84121c@kernel.org>
In-Reply-To: <d795eac4-b52f-4984-a92d-6bfc9d84121c@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Thu, 5 Feb 2026 14:05:05 +0800
X-Gm-Features: AZwV_QgV-gxrVONK0weFycR-3qSKQeojbNfzxf8xBINTeRa7Nbpn8NHQ-RIwlFA
Message-ID: <CACZaFFObZoY0ddPm_nuWK02yqWtM_g5EvntThaxptbnGoi1oNg@mail.gmail.com>
Subject: Re: [PATCH mm-new v6 4/5] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pcdru3diomz8od8mc3s5arndfxfi6xjk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 591D61C0007
X-HE-Tag: 1770271518-873507
X-HE-Meta: U2FsdGVkX1+jlxXoSs4ywCB97XXtxGeiScYXvTrmCLwCc5v2gDYqmT3M/deRhgXfLNJBAyYxGCKbbQ9r4KUVFikVdTRsQenrictKeZyUCNKLslXx3TB9GfYQPvRea0xsB+gTwXqsKZ92WnLbapSpKcyTjrQTiDmdQWxTw/BlSBd+4W/pBlRncsq4gw8d6pTCnWfTfC6xVcigLu/0RYZkItffQViUfGty0Lq3/Rl6JqfqSz5p+AXNyOAwmZ/mmXWT6Eerrqd4Y1pF+Y2kZgqT/L3Arx6QOglPmtUx+pZcVVzc/QI8eGY92Z8H+uclkHbAhdfnw8opxqUci+/FEVFx/kfRDRQqzXTRWyqSwshJR7yJR9i7HKD8Ef3JUv6uo4cKWvSVZKHOZSKkm+7lm1Xn56L4IcaDrKc37jNk44TBr/TCKUx3p/bHmciaUc9k1bzaS7wLWY+pZim+c5As4S1L+Qg5iCrt8u5Uf/U03UClDBARcSw1O/dOT295eVTY+H1+/Booxt+4TbP+AauR4mLWZTscD0ljFRXC16YohADCRx1e6/I7U9dI8V2GH1XUBD6GLCOca9sggyhdV/v3zRscAYW/hm0+YdIe0J7iuXCQXZbL8PeGxatnTaHAsgDbSXauL1l3mRI9l/CvskzS/8lhB5Rvz8LJ2s72bs9ZrMBlkwh7DXFwQWfZ2UWoJzZ9NgdGRt5GStv1Vb60D0eQltmNr45LOyt/RYbt5BMC9Op08sT2bM/+TG6W2H6ndxD2/1FVWCHk9TY59f4uOjLDkEaxOUMmWDkHrl1JlYS9B0jLCicRtoMLl+aphKFfIuMDOuJvdC/bDmPr0owZdCI2Fr/dmiy0a2/iKQaI1QFSe2GU+Ah4nOEXCm2pCuPwBXTTl0sNNmE+Nz91j5cm7xcqLePdbBSpXUDGPgYcZH3ckSSl55Ijgzg3Gs4SPc9qrkH5ur2xRSscRT0bJyVCNGj0mAb
 ZqvQgc91
 tfwHawHJMMuoKFPs+SrZN9itvwzd3g4+cyHXXaoSY73cSsd5j4pybfXtCexBrnxhSg5PgdFMi2K8wc242Y6C7/r4yHFgia9yeQvUnXvqR3Hjrd7cZZAjotVMaM6RIMdVnJTInAfjpvYzKFW+dN3U+TsTE+KXLiedcuf3lvoE8ffkiLxXlioTEYuyC5ebN6+MdMpCI+eCK+xR5BJOvasYLyRyd8v/zxeEGPAEtsTsoNpf++t3rMJYlGZlHOAIzdzeLh4CiERYAp8lSZn79wFHKB0TrIFpv/UJrRmeUN0m72yf3NCx+2pQfhBp9nYn7dXP1x/RXYnymih9S62ZwVX9c3esOfJVb5kUPsMQCTCWHUSZ0MjiTeL8+as+DLaxSm8mnq6sZdAzLr1K8t1tJLb4GF/0FipX8ekhgiHwUKLzElPMM2GzPHRJrBi7FzBoL+SUhxkPatmHUpdWyMfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 5:24=E2=80=AFAM David Hildenbrand (arm) <david@kerne=
l.org> wrote:
>
> On 2/1/26 13:25, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > And if we collapse with a lazyfree page, that content will never be non=
e
> > and the deferred shrinker cannot reclaim them.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memor=
y
> > will be freed, it is appropriate for khugepaged to skip it only, thereb=
y
> > avoiding unnecessary scan and collapse operations to reducing CPU
> > wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h |  1 +
> >   mm/khugepaged.c                    | 13 +++++++++++++
> >   2 files changed, 14 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/=
huge_memory.h
> > index 384e29f6bef0..bcdc57eea270 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >       EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >       EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >       EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > +     EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >       EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >       EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >       EM( SCAN_VMA_NULL,              "vma_null")                     \
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index df22b2274d92..b4def001ccd0 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -46,6 +46,7 @@ enum scan_result {
> >       SCAN_PAGE_LRU,
> >       SCAN_PAGE_LOCK,
> >       SCAN_PAGE_ANON,
> > +     SCAN_PAGE_LAZYFREE,
> >       SCAN_PAGE_COMPOUND,
> >       SCAN_ANY_PROCESS,
> >       SCAN_VMA_NULL,
> > @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >               folio =3D page_folio(page);
> >               VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >
> > +             if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                             folio_test_lazyfree(folio)) {
>
> Should be aligned as
>
>                 if (cc->is_khugepaged && !pte_dirty(pteval) &&
>                     folio_test_lazyfree(folio)) {

LGTM, Thank you for review and suggestion, I will do it in the next version=
.

> But you could just have it in a single line.

If it is placed on a single line, it will exceed 80 characters.

> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out;
> > +             }
> > +
> >               /* See hpage_collapse_scan_pmd(). */
> >               if (folio_maybe_mapped_shared(folio)) {
> >                       ++shared;
> > @@ -1332,6 +1339,12 @@ static enum scan_result hpage_collapse_scan_pmd(=
struct mm_struct *mm,
> >               }
> >               folio =3D page_folio(page);
> >
> > +             if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                             folio_test_lazyfree(folio)) {
> > +                     result =3D SCAN_PAGE_LAZYFREE;
> > +                     goto out_unmap;
> > +             }
>
> Dito.
>
> > +
> >               if (!folio_test_anon(folio)) {
> >                       result =3D SCAN_PAGE_ANON;
> >                       goto out_unmap;
>
> Surprised that there is no need to add checks for SCAN_PAGE_LAZYFREE
> anywhere, but it's similar to SCAN_PAGE_LOCK just that we cannot ever
> run into it for madvise.
>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>

Thank you for review and explanation.

> --
> Cheers,
>
> David

