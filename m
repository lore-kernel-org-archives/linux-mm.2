Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBF1C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A9C6B008A; Fri, 18 Sep 2026 04:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11836B0092; Fri, 18 Sep 2026 04:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27986B0093; Fri, 18 Sep 2026 04:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6E16B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:44:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32D15C03BC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:44:28 +0000 (UTC)
X-FDA: 85226246616.15.65812F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3F60F12000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:44:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKQpoPYK;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721066;
	b=Zo95TYES42uY7ihQZ83NvvyAQn0+0FFp6mdh1R33AZtB4nw2s/zIM3BPPAjQGghTgwXP2q
	7oOVTJ3U19DoNNOam8W6JRbmEm+kkmxgkqOIvtsFU36pKS8YJFwBahAAB8/RfjLTAEjvwh
	54iBQ1Jt1MCHDYYKvvRPSheowxx6DiU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKQpoPYK;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfptLJpLwa1HkLn6r+lnBSBB9zhrI022aUyQ/n+iqZI=;
	b=qEpihTPXDsuzCrCTFRr4kerLWaJfDK3nWacZN0KjxHvXNgQCgojc65sbe+p1/ksC8xc3ws
	1oSQTbnXqcYQWeuthl/qmqeyLa6deqTEws4En+gVmMVV7WI8JAlNGGooAu6uNo3xk13xtp
	w3WJOfe63S5OymVw0Z9s11qXJ+ulyOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6810943AF0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFC81F000FF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721065;
	bh=yfptLJpLwa1HkLn6r+lnBSBB9zhrI022aUyQ/n+iqZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WKQpoPYKtLvvrsANllnpazyBLjRD4QmuKuAgFZJ+R23L2z9t4yAN+ACJErx1PPLcp
	 YtolKadJaCrAtitOs8awaYY/VMbJ8Q6/L36/H0qNStZMmY1edyfG1bkb+dO8M0daCj
	 25bn53UilLvQYI1zKM5frfrxRWf45TEef5EH/K6kUxnvY0h3OG0YNQ241FqO+AVgh5
	 /1vNxD6Ah+KlqPlGnrXYjy62/4wfCjSsu3CmlZ2awkanq/i4MdIQk5y6nr/N5thZul
	 tzkhmvRWaSDcQUfWZGzo2paV/vNvrN2/R03Ja6OCm+ttH82QbijLXDvQ6H9U3Cp01O
	 nYQuqkIXgMEBw==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109f067fso66925485a.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:44:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBydBJVIjQF50MMuq80kP1fZYdFKmQu4LMzi533oU6MmnFVUw5rDdqCnqNf/rEDAf+l+dXDGDgMs8g==@kvack.org
X-Gm-Message-State: AFuF++k3hNy05B6D95sY7swbvW1mwHIha0D+0GPjEC9nF6oDJRlrt5ou
	+HXcWr7JqYxgrUaB+Qwm4L091jwOEBbmIHyXyxy1WA0Nr3R5R/O8TejPt4moJzKu39sgH6PEY4B
	A/h5PlnnEA2d8d9GM54FJ/lbwPNoOrck=
X-Received: by 2002:a05:620a:280a:b0:936:dbd7:fcb3 with SMTP id
 af79cd13be357-93bdc6de89amr218538285a.21.1789721064703; Fri, 18 Sep 2026
 01:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-3-jiangwenxiaomi@gmail.com> <58e3b456-7389-4752-8de5-1cc82964c3c7@kernel.org>
In-Reply-To: <58e3b456-7389-4752-8de5-1cc82964c3c7@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 16:44:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wKG91hd1Y3W4mbdh6B8Kq09JyDjyvXeeCmQj+L6bHm2A@mail.gmail.com>
X-Gm-Features: AcwNN1U1UKmWK4_bdU3CXRYgsAbkO0CRi4o48diyrNchNw7WdNKVQp3kHhkJ8xY
Message-ID: <CAGsJ_4wKG91hd1Y3W4mbdh6B8Kq09JyDjyvXeeCmQj+L6bHm2A@mail.gmail.com>
Subject: Re: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, david@kernel.org, dev.jain@arm.com, 
	jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org, 
	ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F60F12000D
X-Stat-Signature: 3whdwypqj9pggrs6r18jkh1haux4tzzs
X-Rspam-User: 
X-HE-Tag: 1789721066-540340
X-HE-Meta: U2FsdGVkX18ISYTDcYoSNCiMsphwqAyUxZkqXNE5nEbqVInGazqWksbA2tCxFubCr7uZvp24rW4Ax7QucuRgg/XHF1RrOOtOvLcWHsbkshiyJ/eEa95x+OYjc7b+Kgov8Uw1oxc5wJe4rPGz5nQmQvD3E2Zs5gp0L2w+fezWrxgCRNdDMHT1AMVKJX5aYnCG+kBliVjVBYnMTtTnXkvIAE0tEi+Qem5NwAQgXLl9WXI1jvVN8qdbtiAq28NzyL3AXB4iX0Wx9oFqTlIxjcl4KnOOd8oiyXc9kMlTFaSpi+Xd5QNWOZOHQltqD2eZWOHM1hz3vhif7BL42fZbVbR9Rg8EpIQgizE8Pv4rXYIbOd6jgczyr2aNs8BQTDRq3KQ7ZcaM/z7pxtrYbOAauSFVG1lJRLs9oqgSAaKPwNg2eGfFc/64FWsdc/gOw4s1dgnKLd/Lppzb1BDmL6vOw0azLkGLDXK02Vv0gu/1UBFavL/DQEGZ6zn0w/SU6ODo0iUq3XLz1U76wjFZ+4QbMK0vKmwqjFxqAXUEFqK/8jP3V/RVkZ62m9etOYk034gYyreAPanB/5yPpycN1QmmW53c2hrbxptJkM/kNZ585YlAP4nrIaEQrpHLaxdvbMQt5H0IcYFsbL4qPh3jhZlfh+RGoEkIi1IaaHfE66AuE4jmL0YnJZrHoaZGd7jq0stHPOpI1T8/VBYdC65YAemedHNBlBI09DquEgG0jufgVmKZtDb2uCnTSOOmStPMr9EVFxRHPlmNnU2G6wz0l3vZ2Sj85z8GI5h5R+asxxB+Vl+c0EETf2s0UZLdy8rtKSgmnRMff1yOp9kuEeJCOFaMkxoTojY+kx+ZFQkUJAx+/QuZyXFPtJigXEFQjTCJPt0jj2EpMl69t5Zw2lLG3MC5E3D6UIVpkQpgV+LZawfVGL9E+7FWOw06NunXZmwJeVK9M1rTm7Z1DhUWdM8daDhEgH/
 6mrUWwJj
 /c/52LPyuS1iyx1eIiCBC3n1eq30OR1ufpN/YbxdPw5zkkj8ERyKSOhdPz+noRleoy7LIBsMY9Hq6b4WUepw648liVNoaih58Ul3rFkEGrhcPqOurxvjfaBKbGdN7sIDrCrY9jnvBA3ndOB1GtutICU5oMlikuZ9FZ8ovmYnJOtelcf0xfplvwAXNBxg0bhtF12ncNtGk3VjMQjsc01BbGCtT5LfyxCoymphiuCWagxuOYGjln++8xJ+FQ+68b25WOdqRbABbjmEXMHlKfjSc3M+ozsdbk5QvVDWs7nX3JnB+Jx5WhUVwQIgsdI6OGAQ+GbVjtPx4uDoBrsojxOaQ6ivsQKGN9+dzy7eBAAGWvrzuaUqbhQzWoxj9xqQ8T7iIrDAtnb27SZaO5aWr/qFZn458hLc4L6uhiG4eHkdOXwlgk/DW+AuAgZ7pkD++nvKybgpp1KKc5UA+THk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 2:14=E2=80=AFPM Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
>
>
> Le 17/09/2026 =C3=A0 07:29, Wen Jiang a =C3=A9crit :
> > From: Wen Jiang <jiangwen6@xiaomi.com>
> >
> > vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
> > by reusing set_huge_pte_at(), a HugeTLB helper gated by
> > CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
> > CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c to HugeTLB
> > internals it does not otherwise need.
> >
> > Add pte_set_huge() to powerpc/8xx, next to the existing
> > pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the hug=
e
> > PTE and writes it into the backing cells directly, without going throug=
h
> > set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.
> >
> > No pte_clear_huge() is needed: 8xx does not implement
> > arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes th=
e
> > block-mapping branch.
> >
> > In practice PPC_8xx selects HUGETLBFS unconditionally, so
> > CONFIG_HUGETLB_PAGE=3Dn does not occur there today; this is a decouplin=
g
> > cleanup rather than a new configuration.
>
> 8xx selects CONFIG_HUGETLB_PAGE because it uses set_huge_pte_at() to map
> kernel text with large pages. That was added by commit 34536d780683
> ("powerpc/8xx: Add a function to early map kernel via huge pages")
>
> But now pte_set_huge() could be used instead in
> __early_map_kernel_hugepage() and then CONFIG_HUGETLB_PAGE could be remov=
ed.

Hi Christophe,

Do you mean the code below? If so, it sounds like a good place to
clean this up for powerpc as a separate cleanup patch.

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 2518d2a6bdb4..830cdb391161 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -87,9 +87,7 @@ static int __ref
__early_map_kernel_hugepage(unsigned long va, phys_addr_t pa,
        if (WARN_ON(!ptep))
                return -ENOMEM;

-       set_huge_pte_at(&init_mm, va, ptep,
-                       arch_make_huge_pte(pfn_pte(pa >> PAGE_SHIFT,
prot), shift, 0),
-                       1UL << shift);
+       pte_set_huge(ptep, va, pa, prot, 1UL << shift);

        return 0;
 }
diff --git a/arch/powerpc/platforms/Kconfig.cputype
b/arch/powerpc/platforms/Kconfig.cputype
index f0adbf7ecb7f..efba4d960083 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -41,7 +41,6 @@ config PPC_8xx
        select FSL_SOC
        select PPC_KUEP
        select HAVE_ARCH_VMAP_STACK
-       select HUGETLBFS

 config 44x
        bool "AMCC 44x, 46x or 47x"

>
> >
> > There is no caller yet: mm/vmalloc.c is converted later in this series,
> > once the generic fallbacks are in place.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Best Regards
Barry

