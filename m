Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9DD606A680
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=T4wdrjtr
Received: by kanga.kvack.org (Postfix)
	id 1EF086B0A7B; Wed, 25 Nov 2026 11:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6446B0A7D; Wed, 25 Nov 2026 11:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC336B0A7E; Wed, 25 Nov 2026 11:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D36706B0A7B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:36:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3553D120DF7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:36:09 +0000 (UTC)
X-FDA: 85474193658.30.5FF9414
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3368840008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:36:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T4wdrjtr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795624567;
	b=33U8fiuSLEL936Pp3ya9Tn/hYE65fsoSPUu55Yfq+CPYz2KkJVdDo1eNk8amKf+ifaQ+BE
	BZZBGE4mFD2mwQC98xTSyugomJ3kc/Yq3y9ucc66fG7TQgrUey1ITc0AEWY9tT/V/7XcYM
	Ga6JydAtqpv2VeaNN0SPdmRgNhEYWaM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795624567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhIE02AGyFlDGJY9YH7/2qCR3QQs0Kiq9oYiZ1U/+5o=;
	b=T1BWc0opaB/Gav+xdwEXLgNTlSeFUo5BBlIrrJMcESPbkpOb9K11d+oJVrcQq+jWUl67Du
	2jdfiMsAxZqm7x9JnTSV4Eflb98JIQJo6DI+Fl9GCgmaJof/K+CRJUTmFZs9fGViQGwsdh
	Y0EBHsffboq4KRji4cdpN+P49imwxqE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=T4wdrjtr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c50cc7540b7so849347366b.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:36:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795624566; cv=none;
        d=google.com; s=arc-20260327;
        b=qH+TptXwQaJPGifZmi0sudgdIcTFAr/oZ9lNeyeI/lOOGuoxmsujPBG7/1S6ytNpH5
         mYfAqPaoc+YNoXQY+Cy0Kzg8aduG7XzZKiDbNJRSfVKWLIKBkOigvHZPtFGj3B+5tG5y
         7rWWzAtg7ET6YkQBQJjQT+23onGGaSiHtYTVtndiXztbYPVjgIulkfMd3UK9BOVGX7Cg
         bhj8ixTPZUzQnKR5QLFbBbdAjzbloKyOexCZmHaGS8VINzlXymCOLFh7o+KAf3dSsnTN
         730oajnaZH2Kn9GXZdK6nZIL87nh/Ti+GX6SlEIePhVlhSri4EvB8GcW2rj5ULQY1E0O
         /l1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uhIE02AGyFlDGJY9YH7/2qCR3QQs0Kiq9oYiZ1U/+5o=;
        fh=Gny6k2DRXfyueyrdP5Ci8HTMHqTTcsvS2tn/nA7suy8=;
        b=pTFuem38mHmkxSLchg34+RgGubG7G+KQDpsED/en3GTauaSH9H67zcvlrm2b5WEcT6
         MWVYWIOu60NdL5iWhd052Y8AWhBfESrqC5CXG8cCiLKDS2SsHK8AvrTugRRD7E9Agaff
         lteI5uM0HF5EY11yl2z5OS+wFlv1IEZWo5rr6d1b3mWaIRvJBsmfyUHEVTCGaUxoaRFj
         zUDa9DLHDKB+7/AXrtZ7jgpiwy99y92W1XKWgKOA3XrdhaRpyjiaA1aReDqjLXdzM4Kd
         ZX2vLUSs18XHkPClcDBg3vgaTbHPasQg+0Pnn3vX0e5PexeljpTiElK6Ru5KhQcY1uiU
         kSsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795624566; x=1796229366; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uhIE02AGyFlDGJY9YH7/2qCR3QQs0Kiq9oYiZ1U/+5o=;
        b=T4wdrjtreW8U0hc58sX2GOzdjmRy4+yzfF2JeCHgtixDceDJQQHx2UUt4t2NvhJbiM
         zdXH2IWkqe6I5GFaKcoMJfqwC5qwmJDShF6kFUVMkl1Pk7qxO9fkkectEVSj7ejXMMOO
         G0ztAvZ8lKaGD5b2FQzPfXJmboyVya5yuOmAw8qtIroHJ8mzlr6XxT/yXzO+V4koSbmZ
         yKu7LHgHKRUP1/BbS33OWcNV+wlUPf9csEj7jRVQSqS9RWjK8purJzS02ONK1HggHGQu
         MARBCO6VY0tDJEaquVyLz1A5cuLFvKOsWtcUYmkw5pS6HKwC4xuRjub06DRF8P8RRdaE
         K68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795624566; x=1796229366;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uhIE02AGyFlDGJY9YH7/2qCR3QQs0Kiq9oYiZ1U/+5o=;
        b=ObvsoatuuBogWN8lWfayCDt+XzoU1VCtgQXc68HZmFoFC/OhEMZgJcXe26x7DpJj8C
         +bywq/QMKJECy4ohF51zClmizEkRq7ZHq6OGIlVP94v+KjXSlFIeZy2ukPv/+aKHp/Ve
         cxHJhJGa/edt8ZGUAugNhIgjYysPQoiCqEOYwHimnGalRpyWmpxeRW90PDLRpeyjHaXY
         9tWMtvVsEG891ffjOrydhfXS69YRCP+02xkaAq33UkaDBVJZaM+StuflyL22MA2YrkEq
         4QtKKaGiA4tkz8dood5LIZ1aIQvTNnm/TV558/7AeUQCdGMT1uO1AoHPXEkr0jaXo98Z
         GSzg==
X-Forwarded-Encrypted: i=1; AL+hErGoCUmZr5brpE+9Wz0ie56qonVVlGCICf73H4ObHGYJGhv0of8P1ri6whwwfi4fju0MhxkpHuPQ0g==@kvack.org
X-Gm-Message-State: APuU4Z+M44HrxZ0RotqzxWoSNF4R4jgdKfvxn/uyiTfXwx76OiMNCXSf
	PXv+vAvINDcnDJbD6nmNveXhNya1gGNsNdwzeanbQLzyxwYmrevcSq/T9WsySqV9PZijq5Qx0q0
	CmGRgBgb+9mKN1JzcXt/LM3PTHkstlWEBH4ysNppV
X-Gm-Gg: AZFdTZf8nGiJTNLjt9a1E+ngBhu6nz9ojEs1dZCQke9FDlx7BYHAl5IfmEsSU3RrL+O
	sfN4B7QOGCxOUHOE96xWH39jNasIJTIHVwGTddnjsaD2YCkxo0UWXriMINQWB5EDDEW38sRPOPg
	aV9fVIp8uDV+Wdwt1S/9zMFLKK0J4VXTkE6wXQ/GWG2tTkvPcIEDuDyobRasNRObsNgGMT3H95F
	3fbaw6jRqu/bvzjf+hbamJH56kGryRygIndh0ZTodzv7bM22bosvMcUZs09YOo1FRoluUJLNqfq
	6g2/ZH1DQLRdXuIRYvi3wkUfBvSJbpkdkljNM50FlKY+ZkZfPeqLWvdKfOevE0oytIO1No4YuFJ
	RFdvFX2xZWHHoqi7rNmHYXLPuvIhdxwRSDmDwOngfPIUEZXhkRmZr2cZLv1cra7R4/zS/OfH+hu
	oPKacmVyl9x8KqZ2k+DugN4lxDe1XFjumhUXMqnYgSIQTU6GBK2IA=
X-Received: by 2002:a17:906:a408:b0:c49:901c:d9f with SMTP id
 a640c23a62f3a-c513aaff7dfmr1242424166b.49.1795624565163; Wed, 25 Nov 2026
 08:36:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-17-jthoughton@google.com> <sashiko-outbox-228645@kernel.org>
 <CADrL8HWNAByKifcNgre_YAX3M+bwAW0BgMrfPmWHubOEs+AfDQ@mail.gmail.com> <5028917F-EFF3-488C-903E-9E19E5DDA3D1@linux.dev>
In-Reply-To: <5028917F-EFF3-488C-903E-9E19E5DDA3D1@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 25 Nov 2026 11:35:27 -0500
X-Gm-Features: Aa3M54rufHLyzy98JyZmpwMFKUD2VIgSM3pNxMhAoaY6IhoB1clLOE7jnDE3xSw
Message-ID: <CADrL8HXtwnZ4P7E4OhMKs03b2zgzfxnmAHMw4mknjivAk+FVKQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement
 try_populate_vmemmap_pmd using AF trick
To: Muchun Song <muchun.song@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ixzzs46peudhp8191tbwjimwn5hy3tmu
X-Rspamd-Queue-Id: 3368840008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795624567-938779
X-HE-Meta: U2FsdGVkX19YaKOqwSZ2p2FsCjAe//IgGgY0cOjD/CJPDaQGBIHfLsj/xWjznwlEwdwvGzHswtlVJz5cMaE7FbILnIPdYzFjDccB+pcj8hqdn3izaFC7UhIa6wesJPvA3RDxV2vscD33yE7VaKPkDDJkuXFdhBA4jti0bu+o7zZNwJxPitV5mdCMAF3pKK9vOiCCNUuSRfDRBdo+1DafPKM+JVzVrJTYbE8Dzdbz3afLspANyc/wdl9JRVHK3+AT7lpvaFbuo8BWSVvWM5gKdvxEHKYsUTATbIVz2z23JfyU+SRgOf/ErTgHPJVvi9WMOEm1KaU2q+WcU+eWD9qTqg/icGkb3qFRvyj3CD3IuLZBeqA6cyZmg7u6UdRwUP7ZfMR8DOzEfCBruPNAu4mlVnLNTI+UuCelcGQujxivj3KnWRAoVn4leVARjd9mryqXbUe1QBCZ/IAT3n1RiPcCi6GSFV4lDR+9aPSSKV1vgFmi/nLK/JQK61YR9HS55BaLwHAr45lBtvS0avrO4xqXr4gxX3206EROrWNrJqviqxRbVzhnWj+Rnfd09NJN7YSy3M943tnXnWgyOMtWSdNiZmkvr62Au2OGBSnx+V3BZwJGduk/KvZXT9P+pLxfZP2L7IpZZN+MksqZ+k1OJgkWlSyDbaQIILewaC+QHgkmAwD3GaJ7umFuQNehVJ48r3pU45Zt+MpNdRTC2oMm1y5fOKUt44DbAGx0tkRTYvCdFoQZa2Yn9oMd8GIGIt3GSpLReTfDP32zxVH44lfE4DDng5wl6WmhQbVNmWuaqmTVcUGY/c+Ly10FUWtNumpWKFn2CoBUpy8CcJdGoksHAYLACUKXC6hUJLd1T8sA0JhdIvr7pK5LS8HuVU/VLHbPrk+57Jlag29XblNrGoLT2iWkwPzNT8YVI7sF4llVC3kIlXQYtn3hM4ClA1/BKEnu515Wd28CRvdCgdPSbNXSjLS
 ayjCNfi3
 Q8jhgOZq8vSEIwzAXsgUn+OIjMnS7bz0Ne1eocmjkgth3svPdc4jFmlFNzCpannyVdAitjdkvdQxIOSK3cKPRGIl9a9E4fsVnyiZPtArlAEclheSfp0KOSP03QsqAzysCrBWpjrwDQfC/bCo99RZsqRR8S+D9QD/TMXT7YS8LdNXloaRozEJ1BWDguA3GzkS7kevX41/MHQQsskTvsPlTER6AynxrFUxEQDqzgEvEYpDVVj/5vVkoxZvjtBK2W2fzIWTCpjJj/i2IwjsKJLcC/qjWfO6NR04G0dXbPxH6pYYikUwFEzTjRwlZCXMvxVw3i7RQZ3FxIvE/tePMQF+hjCQdayI+kmHzCPib7yaJlc1Bkh4seZJbdqsHjBdyL9cqm+y2iB7x6/XoxcMpIp6mF0z20+oqDFz1WS4E2wF2AZEMY8Tz4j7YdtkwTVJmK1FxTYvSpdjgodEo37QlW/JWgiqb11QBfE7Cvwws1VaJlsPHWlmdxBKo3TIvdmM8hnH6it9pK2qkae/5rvfmOPj8l18BJeUskSwIflGMc+X6kEL3jstChPqpkNHUNHVSMek3U3a4Jgj3MbiKnXdebRVJCPxV6p7MU8/uQYztC4gXA5CZ/qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 6:32=E2=80=AFAM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Nov 25, 2026, at 01:39, James Houghton <jthoughton@google.com> wrote=
:
> >
> > On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote=
:
> >>
> >> Thank you for your contribution! Sashiko AI review found 2 potential
> >> issues to consider:
> >> - [Medium] arm64/mm: over-broad TLB flush in try_populate_vmemmap_pmd(=
)
> >> - [Low] arm64: direct AF=3D0 block-to-table transition in
> >>  try_populate_vmemmap_pmd()
> >> --
> >>
> >> commit 1319c4a7862ad5f3b810c4beca866ee98bd48fd7
> >> Author: James Houghton <jthoughton@google.com>
> >>
> >> arm64: Implement try_populate_vmemmap_pmd using AF trick
> >>
> >> This commit implements try_populate_vmemmap_pmd() on arm64 to replace
> >> in-use leaf vmemmap PMD block entries with table entries by clearing t=
he
> >> access flag instead of using a break-before-make sequence when BBML3 i=
s
> >> not supported.
> >>
> >>> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/as=
m/pgalloc.h
> >>> index 0263329fb7b30..7e304f01ce6d5 100644
> >>> --- a/arch/arm64/include/asm/pgalloc.h
> >>> +++ b/arch/arm64/include/asm/pgalloc.h
> >>> @@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, =
pgtable_t ptep)
> >>> static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t =
*pmdp,
> >>>                                         pte_t *pgtable)
> >>> {
> >>> -     /* BBLM3 is required. Its presence has been checked. */
> >>> -     pmd_populate_kernel(&init_mm, pmdp, pgtable);
> >>> -     return 0;
> >>> +     const int max_attempts =3D 16;
> >>> +     int attempts =3D 0;
> >>> +     pmd_t old_pmd, new_pmd;
> >>> +
> >>> +     if (!system_supports_bbm_through_af())
> >>> +             return -EOPNOTSUPP;
> >>> +
> >>> +     if (system_supports_bbml3()) {
> >>> +             /*
> >>> +              * BBML3 allows block->table transitions if the PTEs un=
derneath
> >>> +              * do not conflict with existing, potentially cached
> >>> +              * translations.
> >>> +              */
> >>> +             pmd_populate_kernel(&init_mm, pmdp, pgtable);
> >>> +             return 0;
> >>> +     }
> >>> +
> >>> +     new_pmd =3D __pmd(__phys_to_pmd_val(__pa(pgtable)) |
> >>> +                     PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
> >>> +
> >>> +     old_pmd =3D pmdp_get(pmdp);
> >>> +
> >>> +     do {
> >>> +             if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
> >>> +                     return -EINVAL;
> >>> +
> >>> +             if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
> >>> +                     return -EINVAL;
> >>> +
> >>> +             /* We should never get a contiguous PMD here. */
> >>> +             if (WARN_ON_ONCE(pmd_cont(old_pmd)))
> >>> +                     return -EINVAL;
> >>> +
> >>> +             if (pmd_young(old_pmd)) {
> >>> +                     /* __ptep_clear_young() returns the overwritten=
 PTE */
> >>> +                     old_pmd =3D pte_pmd(pte_mkold(__ptep_clear_youn=
g((pte_t *)pmdp)));
> >>> +
> >>> +                     flush_tlb_kernel_range(addr, addr + PMD_SIZE);
> >>> +             }
> >>
> >> [Severity: Medium]
> >> Should this pass addr + PAGE_SIZE instead of addr + PMD_SIZE to
> >> flush_tlb_kernel_range()?
> >>
> >> Invalidating a single non-contiguous PMD block entry only needs one
> >> overlapping page-granular TLB invalidation, as in
> >> unmap_hotplug_pmd_range().  With a range of PMD_SIZE and stride of
> >> PAGE_SIZE, pages equals PTRS_PER_PTE (MAX_DVM_OPS), so
> >> __flush_tlb_range_limit_excess() returns true on CPUs without
> >> FEAT_TLBIRANGE and escalates the flush to flush_tlb_all().
> >
> > Oh! I didn't know that!
> >
> > I will change it to PAGE_SIZE instead of PMD_SIZE in v4. Neat!
> >
> >>
> >>> +     /*
> >>> +      * Translations without AF cannot be cached, so we can replace
> >>> +      * them without BBM.
> >>> +      */
> >>> +     } while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd=
),
> >>> +                                   pmd_val(new_pmd)) &&
> >>> +              ++attempts < max_attempts);
> >>
> >> [Severity: Low]
> >> As reported by Catalin Marinas on v1 [1], this rests on an architectur=
e
> >> detail the review could not confirm from the kernel source: can a CPU
> >> walk cache or TLB retain information from a valid leaf block PMD
> >> descriptor when AF=3D0, or is a TLB invalidation and break-before-make
> >> sequence still required before converting a valid AF=3D0 block descrip=
tor
> >> into a table descriptor without BBML3?
> >>
> >> If it can, skipping flush_tlb_kernel_range() when pmd_young(old_pmd) i=
s
> >> already false or directly overwriting the valid AF=3D0 block descripto=
r
> >> with new_pmd leaves stale walk-cache or TLB state active while a table
> >> entry is installed.
> >>
> >> [1] https://lore.kernel.org/r/aoSJcAFMNJ1nPl2H@arm.com
> >
> > Yeah, this is why these final 5 patches are marked as DO-NOT-MERGE.
>
> If we aren't sure about the hardware behavior here, why don't we just dro=
p
> these patches? Once the initial support of HVO for arm64 is merged into t=
he
> community, we can bring up this uncertain part for discussion. Wouldn't t=
hat
> be simpler for this series?

I'm including them for three reasons:
1. I want HVO to be supported on as many systems as possible. At
Google, we have systems that we want to enable HVO for that do not
have BBML3.
2. I want to provide the Linux code to potentially facilitate memory
model discussions regarding the AF trick.
3. My interpretation of the Arm ARM is that the AF trick can be used
like this, so that the final 5 patches are in fact correct.

The series can always be partially applied.

I am happy to drop these if they really ought to be sent separately or
if they are genuinely incorrect. I hope some of the arm64 experts can
chime in. :)

