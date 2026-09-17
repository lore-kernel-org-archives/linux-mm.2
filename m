Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C8AC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E6D6B008A; Thu, 17 Sep 2026 19:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B216B0093; Thu, 17 Sep 2026 19:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EA86B0095; Thu, 17 Sep 2026 19:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2296B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:22:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 947CD1A04B2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:22:24 +0000 (UTC)
X-FDA: 85224830208.19.52DC147
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9697C1C0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:22:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMyDXfFP;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789687342;
	b=QOxTUgpu6TryO0R9GbgaN6QseRB4bG4s7yCOLyawoTLFq0ScxqvIafgTaEE56yNyP5Q0id
	bNx7QH9ZO90KZTmoYqOIzAGI/kXLluiywKmcSTIYYWGtLeuWhQvyQ+pomMgkCyNbJRvM7n
	g237R68ONcQnXYb4aW2zhlpwZ7Cm4Ls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMyDXfFP;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789687342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMZh1YMYCYrRC2uuwUki1Jazz5iXTgol+eU8SrrfkyY=;
	b=O4s6D14VMffRzuO8HHbrb+qai5abZvOwJi8ci5eJiURMpLnD5zryDGrNmGH5ER8UuIJdJa
	Q6W2OcUXhKVx5oCXhkzOVM90SGhtnct6KUQm2GB3RhXD/3BxYp5pu/It7eqhOi3ivb5Byo
	VxyC2dhHX12DZ2SbnOHiYjVQROgePUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B806444049
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01AB1F0089B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789687341;
	bh=tMZh1YMYCYrRC2uuwUki1Jazz5iXTgol+eU8SrrfkyY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UMyDXfFPJ6TD7VAJu/Wo9nOwx21vOAIJyHqkxfySfMaGoz3L5SRzIRuYI6+hBq5Fn
	 VDxtPogqxAZqT8pWf20ID37n7+Tnf1ShUmnTeR6Ws4U8ye+c5hV8nmnvdP/9SIaRz1
	 oVrxtZYf9D25VxY16SDLIkJw+KxWNVDWByqc7Bv821rdlnEV0ad0v/0J10dcDSxlBx
	 DUjrmnzdOgwZ5WBE8l1Rg98I3/mY5h/CmE2mnXbu9SnLwfE2Q9/STmdY1xkpDSRuvq
	 QubDsA6jFihfX+X0r3Vgzg14qdy25FbeEj7HpBIQnOY9UhbIVFC0VzepoarsGjndoF
	 thgumBxMGF03g==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfe60d5fso3074346d6.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:22:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByg6ky1mTefPKFd06QosSd2O1f3YK71MnxWdGlL95OSfJ7B48+AUHfB++m5oT+gosxduJLAbClaYA==@kvack.org
X-Gm-Message-State: AFuF++mfSb3pkjPhWKVPGs3zT7vDC3LTyqWKvehqIjN+ZkSVmS5w24+C
	+3+l94SxoMLkJRgy7mmIHx0sPhD0ZCuZUxOuiiBAZx7BhdNvLGl6C9QLbrUEgJilxzQ4C5qq867
	PAelv4n/8LB1hfdhFaf+YxHAK0v2QnJ0=
X-Received: by 2002:a05:620a:294a:b0:93b:da60:a557 with SMTP id
 af79cd13be357-93bdc6d5b3amr95981185a.19.1789687340744; Thu, 17 Sep 2026
 16:22:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com> <20260917052933.188679-2-jiangwenxiaomi@gmail.com>
In-Reply-To: <20260917052933.188679-2-jiangwenxiaomi@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 07:22:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xujxpH6OuuUao2=TAjTMKhr77ufW6OoZuk-VB=YPd6fw@mail.gmail.com>
X-Gm-Features: AcwNN1WjNP8GdpSkB1mGsUq58TKlHY6lfOfrir1kzagtl_zxNQgmPbeTkRXOdwM
Message-ID: <CAGsJ_4xujxpH6OuuUao2=TAjTMKhr77ufW6OoZuk-VB=YPd6fw@mail.gmail.com>
Subject: Re: [PATCH v8 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9697C1C0004
X-Rspam-User: 
X-Stat-Signature: s7gu6msomtdsh1tp5ymww8bfm9ymkdwb
X-HE-Tag: 1789687342-194568
X-HE-Meta: U2FsdGVkX1/jO4lfGY0KHlEhgmhUmI0k1PNpuqPLI4+rSG54Ep2UmFWeAWhe6cntDAJZ32VvJ/yxKNOAAfZ+cmCRZAbOasW7u7PYYLuiOAQZIiDqma6EUm0GkWm5OT9F9Nrh1OvD4mHaA65QZU6a7W/EK2nh8+dwkwdPlH1/67vNykdqIQ1PAs44ky0PIc0xiiH48hqou6DgvgGNomTC1ChF+WSLCmqr7VrI7WLEID0clk2z/YwzZP73iaEE/AQZ/FJd1f4DUBPZJI94MfOE7p3DQS24A3B5KliM8wrHxvCc1FRAbmZGt9Reh7k8pLEGd8W2yDHQt8A/4I05hioyonq5aDcPSxblb5iMYFr4Qb0i/L/JKt9QwnIapno5WyDbR78qkoLnIqe1z6tICSwEHqTquDBGrf0kAZYFK5sbB1Zn4SA5Os9qgMtMpRhlxUBDq7Qgkjt5KPQFE0RVS07ejPNTHLfZ9BCPVMMnuegEQCuAKqte/VEew5NskQcPDfHt5si15PchDOv78EVggJ15p12/ly3NokOVs8Y5kArJZwDay7p/HHAc7PfSG9GPGLcdOKT5VGpGtS1GNvF51z0pgz9JYeH+85wGkPSKyjCvfxC/l9XVLlklDgzVgBb2dAGU6WUopymqF5ivjqbLO5nN4O5tD7rOd3xuOngl8qvy9pTvC4JZrlAM2I5Mg6+Kd3+yLl83hRp9U1D5nq7gtBwKv8rTLeiQeArrr2wWQ8RQ5WAgzNCN56gbxMCTL1PaCeb8ztHZFf95nYfQSl2Yu5/7B93o+Jdh85niirXYa5O+qsdh/RzPL+SQwWTddjq584ZxL20c1g/6jO9ZPkShCUyRHSxBWzYPbS/NNNW0SiyoKVR1tkqBgAPWvuxRuBQXeCdBbke0UveaqqgdqHk7xnWPq5f2yRzE/KdRRlT7MRYHkEYXxQZEwyh7Fo7kWWIq8EpP7WVeziDVsYADoUREb2I
 cxpckxJt
 VGlAKpNlpYOdStSF8vKyqHOcaOVeLyjp7iA5P9Su8EqKwmgT1VwMljRd0MunI3RmKtAPUGYfozZiQqVRugNy9YcaZA3M1i1NPs5grLzvNDXpDcjwhWi7a7r+DaD9xtCZZCSYzohTWctAcRQY5lfty17glQq1wLSe8RWHio/zt8JaULmpBvI7ojU1+WZe7ukgvw88GnaOg4YNJzk81m/6Kgwe37wikWL0y6Dk+xaFjL5gmL5tWcbpDefNU7pA+J44S8JZLH5ysO6N7fNfgVMTcoGvxTVyE02U3eTzNILzEIU1yDpMvCPT3gxd88qYYEg1HPBWMglq8GhmQUOAVFjlvt4Wv5dnBqORdnOpfqsysgli32RaVLA/NwSa82I/mY2RaToyBVUk9rDSK5/qEoRhZmzTYAvl4CmjpUMB4RZuQg2K8PGNjqIjCj9Bq+YnwFsntsutXK5hDXFI0n+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 1:29=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com=
> wrote:
>
> From: Wen Jiang <jiangwen6@xiaomi.com>
>
> vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
> set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
> unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c t=
o
> HugeTLB internals it does not otherwise need.
>
> Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
> pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
> __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
> depend on CONFIG_HUGETLB_PAGE.
>
> There is no caller yet: mm/vmalloc.c is converted later in this series,
> once the generic fallbacks are in place.
>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>

I tried to apply the patch to mm-new, but it doesn't apply.

% git am raw
Applying: arm64/mm: add pte_set_huge() and pte_clear_huge()
error: patch failed: arch/arm64/mm/mmu.c:1872
error: arch/arm64/mm/mmu.c: patch does not apply
Patch failed at 0001 arm64/mm: add pte_set_huge() and pte_clear_huge()
hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

% patch -p1 < raw
patching file 'arch/arm64/include/asm/pgtable.h'
patching file 'arch/arm64/mm/mmu.c'
1 out of 1 hunks failed--saving rejects to 'arch/arm64/mm/mmu.c.rej'


[...]

> +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> +                 pgprot_t prot, unsigned long size)
> +{
> +       unsigned long pfn =3D __phys_to_pfn(phys);
> +       pte_t new_pte =3D pte_mkcont(pfn_pte(pfn, prot));

Maybe we can drop the `new_` prefix.

> +       unsigned int nr =3D size >> PAGE_SHIFT;
> +
> +       VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> +       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));

Do we also need to check that `addr` is aligned?

Best Regards
Barry

