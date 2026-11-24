Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17CD606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LewI+WEa
Received: by kanga.kvack.org (Postfix)
	id 0D11E6B080E; Tue, 24 Nov 2026 12:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A8A86B080F; Tue, 24 Nov 2026 12:40:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFD76B0810; Tue, 24 Nov 2026 12:40:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB0A56B080E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:40:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 469A5C0BC7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:40:26 +0000 (UTC)
X-FDA: 85470726852.19.870BFEF
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 46FFD160003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:40:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LewI+WEa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795542024;
	b=0nxNeBtNSpAsBHQ0vP4D2KugbP2TpbrQG+2D9CIMHb3TSgynsROYCXafJ7V97RINuJMUS3
	/F2Y4NtQterajwJNmLl3GOIFoky8AVWcS+vjOkIC+ojwdU5A/wP0k6iP3LuUkYQrQvxhzK
	M5PKZBt1wTnkThXrmb3mlZ6EV+ynEos=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795542024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZyMW0Suh0lL3Bzt0NE42D1NOyP8/ltJQBT/Rp/e1E1o=;
	b=B4pjK1IMdfOuqn2nA8xt2kDP4GP3a0mUAcx7s/P+ybJIyWGClMwUUMjTa/vxyR6yDA4VOP
	B4QkmQVzzqQ8RVx2/W8MxK5/R12jdXiUAL72ds6pvN21DcyY1W4l6VKeJEMarx1jDzBjJo
	xM0Zw9MEdawvY51WJpIs4f5P3ahy8ds=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LewI+WEa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4322d310e7so246833166b.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:40:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795542023; cv=none;
        d=google.com; s=arc-20260327;
        b=akEglrte2cA38iX40RKbQ3V839FsZRuSe4WQcg/h5Zjb7OqFWnLosbOLP+5G6crvG9
         0Ne2ytcpUZsrW3Afk8UCJIqxQEwMv1jmzfmJr4UkzDTdFzS3o/Wrp5e8zdqF94LhPOe9
         aUGvRey4icCwYJ833de/4w+u5k3Y8ypfYUKwtYgbB+neLMrpOAa1Z0NUHH1emxjM2wqA
         yxQAzoX2hVXYuKIYvY5ZyeUMiRYLacHTU1Nj9KpMnXb2kE0SC6sDUKauVE+Drt3a/f23
         P4XPs7y9ZHIxqjuQv+aaroYAASSRxL5oJLU0zJ0Kakyr2GKEAigGwx//0qDf+J8ELaAd
         zV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZyMW0Suh0lL3Bzt0NE42D1NOyP8/ltJQBT/Rp/e1E1o=;
        fh=hC10eKYt/j5xplRzRs4PACA7xTIlXFvPmCk1z1fTghU=;
        b=OOUFJ1IV74WLacGaSxmGtCCYmitcGRCWYgd1pxgwH7SUYw9m6D92Bd7//57LibbN/p
         E3EWFrTatEqxV0/KMF0jwDf18SrpsBAH9MqUdbuJ1xsNEDmJdflk0MDsTAyZIa9IGuQR
         8h8f2xqiT5CxC2RFS01Pl5+2MgA51uFTogEKSk+Z/CYqYZ/RAO/LwaWfu5xmR7GqlamC
         s0SQQeKdst9Wj6pMaQSK7rWqe5hedM5712veIAq1A2Ood0/y01S96G6NvCleDdazOemE
         8jpMogmZHYXm3kfYgBnxYHoX8Vyc3Ztz6dVORw7PkcDR9GC05Wnrvy8bs1yBqMkb8lzT
         BVpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795542023; x=1796146823; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZyMW0Suh0lL3Bzt0NE42D1NOyP8/ltJQBT/Rp/e1E1o=;
        b=LewI+WEaOBrYfCdgD6rPOK4GeCelymN5lN8tqfrokRdGtQ5ZSNsLOUFrZxcBE8+aBk
         gkyxQt885lBSAFhJfJrxss7NrQLW7DgbzwjS9iRm16ugZW9qhfxEMU3y9rMfPAUgkdTe
         JbWI0eau3kDNAVmvb6rA+LeFdUd2peLXE6D4k5zbu2oDyuE9OGNDNosvJZ8EyB45oN2/
         Qr8Fg8LPWDtG3pZXFTA+CWCaov49+ITgQ1rCbAkTOnCSFr2gClCvdKgD9XV0d29hH0fQ
         jvYAEMZafvtVdy4zIleBM21DKxxfrQ2W79QjkYPkAIPQhZ4hM7BX9wpe5A+So9pndEDL
         sS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795542023; x=1796146823;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZyMW0Suh0lL3Bzt0NE42D1NOyP8/ltJQBT/Rp/e1E1o=;
        b=FxM/Nq2W8/gWvdpvlkGzlP4iyOfF4QoKqnLt2rGRzuW1YNAvxzlzdr2GgfUO97Z0o8
         N/M9YvcNZh8k7m7wvSkPXaS80190k8FYGbiAPsREakCIk+Za4HBEZgS9kER4FvP5CvYN
         sPOHYZYCbXZsm45NCMf765wUNV7PNhE3uTQdXPfMip03nhG1gvMHRxmqsRg/p0PcgYuF
         xqQVU39k4kJl7Ooek1J723G+8VjD6y17FpTFVLSBkgu4PrWc7xZMXKLLVsfuqPJIxX0g
         WxqnsQp5N/QrP4AcrcDLoMVxA8xgpc2b73ZKurpib1Y3mVVcp4b2XzjtoWLwbpgcTkLY
         Nu3g==
X-Forwarded-Encrypted: i=1; AL+hErHslUO+kri6KcMimTQQnlpqNH4qgWN613T4oEeb+FFHcWQERftNxm1kb0v9OAtQqiGacXDE2oqa4g==@kvack.org
X-Gm-Message-State: APuU4Z+IKyARaa/hqfXlVRIFf+kwxVY54Gp8Xqw6RorGgVYV1kEk+1hX
	lO/vxx4vfWdot9qeEmBqzgAO8T1/WD95nmAEWuL96btn3CLSAOncV9B0p0Xp6K2AAdjwVN6YWxX
	2puIiJT/U/HxyZh5zaqoBffPDs2rg+4S66EolWSo/
X-Gm-Gg: AZFdTZc2eKcegOphLStl7hpr1cFL6FrmBo9UxcVpFBNrmk894zHCw0yH8aYilZJ6FIC
	DjQOIW/+Os9tC3MCBqjRPr7ea9yJAE3MRtAhYI3ZpjCpx+Xqn5V1DbFwyDUTTrvZK96UYDtbjw7
	hf/fchSYkBeM5iIW9JVFT5HrkmOPqFEPp0ob3ukWJIpmjaf6S8wLsYKmLvG0aPB2kjGOvdIOKht
	sF4xIKRRbUXeEJtAAkIVqj3a4ZZdoMZvPeacJK4SD+m9h8Q5sixgZsuJc+KcKd+ISy+DZ22MxV7
	4USilIeX1PkzvA6+5YvwgzPCIbPGpCHFbiKVm8/4TIFlCuMpGLP/0Q3S8y0blWVkqv3lhUpexcS
	ygqAPr9wP6Rn2d85G9GfJ027b0B3zqvRgCDV4QqknudQ5A02g4QnjwKwJUAAyV7IPBMwTRG4VgJ
	W8S2P7TSbhkubtXm0PrfAZFlSiYjbz7U3ptrUklRMdBRL39B7PTGE=
X-Received: by 2002:a17:906:7f01:b0:c4d:2867:281c with SMTP id
 a640c23a62f3a-c513a89466dmr986155466b.1.1795542022434; Tue, 24 Nov 2026
 09:40:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-17-jthoughton@google.com> <sashiko-outbox-228645@kernel.org>
In-Reply-To: <sashiko-outbox-228645@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:39:45 -0500
X-Gm-Features: Aa3M54raiLEh1ZPrKo5WkzdnZfyJOdcj_tuB0KWZ_ie6g2cLD_DMBgOrKleBNf4
Message-ID: <CADrL8HWNAByKifcNgre_YAX3M+bwAW0BgMrfPmWHubOEs+AfDQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement
 try_populate_vmemmap_pmd using AF trick
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 46FFD160003
X-Stat-Signature: q9qkzh99tiicjj63og1cpswwwxoeem3z
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795542024-353457
X-HE-Meta: U2FsdGVkX19Ph4/qLu+/Liv398wvBT+IEjTyKXRrU4V8HKMbOMQqsFcqpfEEeQvCfYmXocfK0OGXz5KvyyhwaF92ZC2w84+hu1ubBO7tam9QrIXIC9iFUnMNNcknNxvuF2eU1iQJGwKxwMYYYYRhIM06aMGnV3Zr5GyfufcIeYGuvJrk97oSKYJMwyllE9q99qug7xs++Hlf0JiEAoWou0BDwJPK5XFLHBix/ov0GhAnuQW8g+0yVPx4LLhLCymCmjawbsMefyt07TES4W+CWqeJ2S4fWwhniQN/XAZ/7M0ZvUcS/ssKuBRhC5KlFcbqHEFCR9ani+uLz/7uCX4iR/a7y2AvQShNow9IZcUt8kRJx3DWMJo0ejcc4bCQ5bYEPRIH/puXddQ26Anl3mz7j86ZahBVINUIT3FaqXZGpiOncrX3b9nGl082enqP4xGvcVDRtNoeB8JVBxHshsMhqnxNvWYc1128ICtOj5n+ViN4Ag/sNZTRR+3iR9J5mnp7MdJ2cV6iqfsu/ruqgKPp1wLOyo+ZEH1tjVecwdUAeSFEs7v6d1oy0LyGvuUJeIycf4CNPK+LPh6gRTKjj8Ydq1GbRC5e0/QExWrqZowsK8fhwYAPCCaHKzTYh+y4WXpeT+tM6sLiatRm9OusRRlOmlxrddD8Xuu3DRTssSgbtgzVu2hJhzJoSwVxVlfz0zpNsTp9dyxpjeDZNfWMjUmM6WcinyptkKP/Q/Kq74QZ1SYKUB1xXaMdMCEfnTGAwUWJT0x24I90T/Td0i/+UzdIEKvfIzZDuGnYLhXMIYL+0OUFJ82DOXNNnFn4YZZEc2UpTBss8jCVQsU9LsJfqzLN9NsRAr99FFw0JbxyJpvYVQp0OaDF8eNsDd0D+HRAhSoU074ZR2mKGL8ue7MbjQwZyA8nRaS1m/KrMkhB4YKg2VEQBAPPRMlFyegNWG9w0S0S3PW22LEZva5u1BIRjMO
 mARrgdfV
 bmbCoaTzqEsLM+5ReM2rvFIHNAcI8cGehCdi+ZEf9SP9VN5ZqXv/gmHGcdmVGnwLPcduHGnsKoWV+7wirzVcC68ygC9Bvu5xV+WzqhgK7RAGXpEW3yJkMR7a1WUELli2s+NpYOQ/62v99Va8KKetPXpeUaMRMU2gh0fDFZriUDKJ81dQDor+eTXEOf2HEHmp+/c+y1Uh9d4ijiVRdVdnolA4AAbTumGl7IJlY5Ts8OqTBl6tAeReKOkCZp1YlDEaNvFZE54eP0XlMj9ooDBKmWcw2OfQ97BfF7QdSW+nRgUa7PuOG74Mgx7+UTgzWCZWfTQXpmcM2x5Fu3Eg5NACh43CaVgn57Ajl/CDrksBLO2fdDCFozieBUbigM7tcDysYcn44oc5G++dyGXYM1lfaJ88Xbj35BFYDWlJgOIejZDlmhaaGmejp6poUl7sBm/4jmVhEJqm0Ta2l+FS8seu36YVgbD91+GJp0yWJn/oOREJf1QwCGEy4DA2iBXqZwzuKE1kRKeXNnUKPMIRUbLNewYzonqwy/pVyAwTAAAb8eFOYTtastEyz3Q/wum7QYHkzThrJ75FxMsoU614L+awfco3SO5GJGy6yoqpvDjK0lXknAlI3COVVRAlEnJqPDhk/di8/ZCxxkZf0bmYwwJhtm+/J3ZW092PRMMrbjUbENkCfCw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] arm64/mm: over-broad TLB flush in try_populate_vmemmap_pmd()
> - [Low] arm64: direct AF=3D0 block-to-table transition in
>   try_populate_vmemmap_pmd()
> --
>
> commit 1319c4a7862ad5f3b810c4beca866ee98bd48fd7
> Author: James Houghton <jthoughton@google.com>
>
> arm64: Implement try_populate_vmemmap_pmd using AF trick
>
> This commit implements try_populate_vmemmap_pmd() on arm64 to replace
> in-use leaf vmemmap PMD block entries with table entries by clearing the
> access flag instead of using a break-before-make sequence when BBML3 is
> not supported.
>
> > diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/=
pgalloc.h
> > index 0263329fb7b30..7e304f01ce6d5 100644
> > --- a/arch/arm64/include/asm/pgalloc.h
> > +++ b/arch/arm64/include/asm/pgalloc.h
> > @@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pg=
table_t ptep)
> >  static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *=
pmdp,
> >                                          pte_t *pgtable)
> >  {
> > -     /* BBLM3 is required. Its presence has been checked. */
> > -     pmd_populate_kernel(&init_mm, pmdp, pgtable);
> > -     return 0;
> > +     const int max_attempts =3D 16;
> > +     int attempts =3D 0;
> > +     pmd_t old_pmd, new_pmd;
> > +
> > +     if (!system_supports_bbm_through_af())
> > +             return -EOPNOTSUPP;
> > +
> > +     if (system_supports_bbml3()) {
> > +             /*
> > +              * BBML3 allows block->table transitions if the PTEs unde=
rneath
> > +              * do not conflict with existing, potentially cached
> > +              * translations.
> > +              */
> > +             pmd_populate_kernel(&init_mm, pmdp, pgtable);
> > +             return 0;
> > +     }
> > +
> > +     new_pmd =3D __pmd(__phys_to_pmd_val(__pa(pgtable)) |
> > +                     PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
> > +
> > +     old_pmd =3D pmdp_get(pmdp);
> > +
> > +     do {
> > +             if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
> > +                     return -EINVAL;
> > +
> > +             if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
> > +                     return -EINVAL;
> > +
> > +             /* We should never get a contiguous PMD here. */
> > +             if (WARN_ON_ONCE(pmd_cont(old_pmd)))
> > +                     return -EINVAL;
> > +
> > +             if (pmd_young(old_pmd)) {
> > +                     /* __ptep_clear_young() returns the overwritten P=
TE */
> > +                     old_pmd =3D pte_pmd(pte_mkold(__ptep_clear_young(=
(pte_t *)pmdp)));
> > +
> > +                     flush_tlb_kernel_range(addr, addr + PMD_SIZE);
> > +             }
>
> [Severity: Medium]
> Should this pass addr + PAGE_SIZE instead of addr + PMD_SIZE to
> flush_tlb_kernel_range()?
>
> Invalidating a single non-contiguous PMD block entry only needs one
> overlapping page-granular TLB invalidation, as in
> unmap_hotplug_pmd_range().  With a range of PMD_SIZE and stride of
> PAGE_SIZE, pages equals PTRS_PER_PTE (MAX_DVM_OPS), so
> __flush_tlb_range_limit_excess() returns true on CPUs without
> FEAT_TLBIRANGE and escalates the flush to flush_tlb_all().

Oh! I didn't know that!

I will change it to PAGE_SIZE instead of PMD_SIZE in v4. Neat!

>
> > +     /*
> > +      * Translations without AF cannot be cached, so we can replace
> > +      * them without BBM.
> > +      */
> > +     } while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd),
> > +                                   pmd_val(new_pmd)) &&
> > +              ++attempts < max_attempts);
>
> [Severity: Low]
> As reported by Catalin Marinas on v1 [1], this rests on an architecture
> detail the review could not confirm from the kernel source: can a CPU
> walk cache or TLB retain information from a valid leaf block PMD
> descriptor when AF=3D0, or is a TLB invalidation and break-before-make
> sequence still required before converting a valid AF=3D0 block descriptor
> into a table descriptor without BBML3?
>
> If it can, skipping flush_tlb_kernel_range() when pmd_young(old_pmd) is
> already false or directly overwriting the valid AF=3D0 block descriptor
> with new_pmd leaves stale walk-cache or TLB state active while a table
> entry is installed.
>
> [1] https://lore.kernel.org/r/aoSJcAFMNJ1nPl2H@arm.com

Yeah, this is why these final 5 patches are marked as DO-NOT-MERGE.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122184453.26=
68189-1-jthoughton@google.com?part=3D16

