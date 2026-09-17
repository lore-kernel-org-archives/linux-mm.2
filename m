Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1F7C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8667A6B0092; Thu, 17 Sep 2026 17:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817786B0093; Thu, 17 Sep 2026 17:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D496B0095; Thu, 17 Sep 2026 17:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417126B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:44:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 899AF1C289D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:44:56 +0000 (UTC)
X-FDA: 85224584592.12.190CEB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6B07440008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:44:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npcV7UoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=npcV7UoW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789681494;
	b=Rj+Px6jaWyC7RU7omTtqoNX8bM5ihsaqdZ9mj3tWkDyLhkZLIOcAlxYKpFIZT/NmAHVM3N
	h6Ou2ptB6M9d6stbeEXCGCtek7+UI8vTU8gE+gLye8zbFaQdpRpiiv2iHRubkhT4srY5ez
	iaNlpbAafa3IKKvzaHAgpudrzD4wx28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789681494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exG/AXyrr+JXl9+ykc8tK7skhSydPCBzrUM83og95Qc=;
	b=D4DFonfEf+gfNvCYKWn6vqjEulCQOw2uatjQBfieZq59V12SYjbvXik4AXCgHvcWzKwLwi
	seBuYtDWZ9/Cigd9IQIlSp5iFcY8pzrddmKY/0SGwPXjdgmIsAafYM6fVgdSJA27nupLhV
	qcspJVdZFf85ynSuH9w5rVv/1yBqFOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E011D4408A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8371F008BC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789681491;
	bh=exG/AXyrr+JXl9+ykc8tK7skhSydPCBzrUM83og95Qc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=npcV7UoWW8Jdj8dCOiJjPz7NjvHEweQKVyJTOE6EGl+6CXaSXa7Cw5OVetwNA0yjL
	 h6TfoM6Dfif4CAsnrhQwtPWh9kFaQNiTS/ftDGCbVLNPOVI9S/lJcEmj5xyQDqYTmN
	 4ggdves30XSDnwvnOFL4hI3msybJF/Lz7+iqcOZPOOzu46+i0EIy/6sj+UOBlD1JFo
	 ILbB39sk6mpXz/GPDWpGqIe4Mx0g+kV9n4XGrwO9HrCL1sQqEDYUt6q1x/2esCOndY
	 FlVZRxvROq3asnpA7qRe55ewDZVxSRiT7yskG6bEOsB4CTOzEyN7jIbb3SY4BaZOsZ
	 ORbUBr6pMgLsA==
Received: by mail-qk2-f37.google.com with SMTP id af79cd13be357-93910cc46c8so10354585a.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:44:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByd8Pbx6PXohnk4YtifVnAetIbWq23A94RF48B2Uw7leZyDiHd7uVJed8rxLAz1EYKm6iDkxpP8KA==@kvack.org
X-Gm-Message-State: AFuF++kk0rVAhT2AwCUSReg7Lod7Obp+sw+KKf0QYwEGpoJZxRcha88x
	twP1dW8K7qK3yRYdeTqBg6unLGQbDZ2p2/J++y0NXr0rx/Xb3Byy7v2vSceS+NXdkPR5Aw7gGuX
	/II6CkcgXP8OfEP+eAF7y2d6tOUgpsxk=
X-Received: by 2002:a05:620a:1a28:b0:939:b099:d52f with SMTP id
 af79cd13be357-93bdc6d9164mr57128485a.20.1789681490948; Thu, 17 Sep 2026
 14:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com> <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
 <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
In-Reply-To: <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 05:44:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
X-Gm-Features: AcwNN1UtqgSSOa91gBxdyOasYnD1juDs3qwDvpJofhPchMKWgrPs9IOwN7QDNfg
Message-ID: <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	linux-mm@kvack.org, urezki@gmail.com, will@kernel.org, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B07440008
X-Stat-Signature: 6mppf6yzsorrpk489ga33oiqtyeofs14
X-Rspamd-Server: rspam01
X-HE-Tag: 1789681494-463609
X-HE-Meta: U2FsdGVkX1+YPtlmKAuH1XMK49YhryLZ2giTcc+TbmcgLIgvJgB2s2owlN7EXwHBtcl2TzB6EE+eTMlpBkSz9gignfXcBQ0FTXSzfmazyLTtGLBa6ClrZA7/wFuiMfok7y6s7c2K3DTKFdOJ2vfqyLHFvrW9HdjwhqI4cifd6mS3g8TMuueBUPBYkbZWnvsNme4cFi4T5gR+XWkmzzm/5N+J0B+/8UdKY82iI4qQMz19StHUcmWzJclLyIQjCLKrPa9UEaSEYzRbGc20Wa053BZPeVZvohAl1WN8MQQdEgR/Ql7yPxsxoprM4ONp4dlWzLALAG1XAZNf/KIIWzUtOZSurqwTs4J+SmA13SxJR7IDmSolW1ybCyXxhAmvks6bd0T3DGMnRRiXLtGxxTGvR9yDTcs50x2iGIMWgo/yHTLFj5cLoRKo2X6oAbz0v9RD3g/E5+CjqG5compIoXyJkBM6YUw5W44eI0H+UbyIrzgo7b0/b/AdhuAn5N8AlXKHpgZc6D8iTfcbupFe5IrPnE+7pjzIKg42ALedfSb7Co0x6+P0fnekHc78fasbY2I1pIGEUNUjLu9U7Q8YNOwtWOfmkr/VrkzhyvV9nupXlzzIewNl7YDHgmldGyYtWQGTIK4JqFDjCNo7KDatxh0ow67vXbi4c5v1sJ3TYCzxfmQIoClzoVW5hB+A0hmeegzSPeyit1c9do1uhPy/TqOGVyft1HREorhf7fMU4qN4ouRz9X6rWicOilQjA5kNezKhBZNOHpa/EN6kseQehOn8ZXomh+suc+WJqm6bR/aNxwcvP6TrXnpRw3x6NxXm+orQJcv8ROZDC044+hvvoPz/AK/W6YI/SCSE6elO71Ms08nZWtb3Z5xO/Lotg64TvWNeSfrm+nPvsDEu4Gc0tvxLtS/Nr6ulEXj7iAOwAf982Mv4CNhAyeksXPmvqhhe+d6+NvsnKilZ1sxQLr7ZeLs
 YKHZvjNC
 31FK6yfYeI0WKRR+1Sj9GCJbouJUXasxxVGGzC3ONEhF+ytv7fs4ao5IFpa0VeBYgQDcia4tCQgOyqZw9Lj1hDbN1A3i+Hnj5vw0VtJtgh4bFBuRgj2CY3BjnrnlnS1PCEnj8YfhKo33T1D0eAvinNMOAp40gFfrhfk9aHgK94QbG6ouMuJVH5c27PagXId/4nIY9EwGaLrUpNUIsMMy2sQd2BSYtHi3MR+1b+6O8D1ZiQAMnY5Gr3qmq6UwCn6zP4uoeTBaEdbFLnbXqKA5555+mAutlKcEaLn2IBh4J9lABWbczzaluGw4Ef7PosZCtzRTHy1ncXfXCjviVedkZ8GYGPF4R1tKGnIuJ6WrOQnh0ydF92LbCsbm02/nSvkSXHLJ1Gtix4C//kip3i7rRCzkZUmEMzmYYHWmkHbx/RaydHs3usZ1m7dY5xoAmJkAJQ8cheK1uor1EsrxVp50DNXpofyM513O0uTfp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 10:41=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.co=
m> wrote:
>
> On Thu, 17 Sept 2026 at 22:00, Christophe Leroy (CS GROUP)
> <chleroy@kernel.org> wrote:
> >
> >
> >
> > Le 17/09/2026 =C3=A0 07:29, Wen Jiang a =C3=A9crit :
> > > From: Wen Jiang <jiangwen6@xiaomi.com>
> > >
> > > vmap installs PTE-level block mappings by reusing set_huge_pte_at() a=
nd
> > > huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This make=
s
> > > the feature silently unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels a=
nd
> > > couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
> > >
> > > Now that arm64 and powerpc/8xx provide pte_set_huge() and
> > > pte_clear_huge(), add the generic fallbacks next to the existing
> > > pmd/pud_set_huge() family and convert vmap_pte_range() and
> > > vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> > > around the block-mapping paths are dropped, so PTE-level block mappin=
gs
> > > now also work on CONFIG_HUGETLB_PAGE=3Dn kernels, and mm/vmalloc.c no
> > > longer includes <linux/hugetlb.h>.
> > >
> > > The fallbacks exist only to keep the build working on architectures
> > > without PTE-level block mapping support. They are unreachable there:
> > > the callers only run when arch_vmap_pte_range_map_size() or
> > > arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> > > which requires an arch implementation. WARN_ON_ONCE() makes that
> > > explicit rather than silently doing nothing.
> > >
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > ---
> > >   include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
> > >   mm/vmalloc.c            | 19 ++++++-------------
> > >   2 files changed, 35 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > > index cdd68ed3ae1a9..349ced999f959 100644
> > > --- a/include/linux/pgtable.h
> > > +++ b/include/linux/pgtable.h
> > > @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd=
, unsigned long addr)
> > >   }
> > >   #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
> > >
> > > +/*
> > > + * PTE-level block mappings for vmap.
> > > + *
> > > + * pte_set_huge() only has to be implemented by architectures whose
> > > + * arch_vmap_pte_range_map_size() can return a size other than PAGE_=
SIZE.
> > > + */
> > > +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> > > +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> > > +                             phys_addr_t phys, pgprot_t prot,
> > > +                             unsigned long size)
> > > +{
> > > +     WARN_ON_ONCE(1);
> >
> > BUILD_BUG_ON() would be better here.
> >
> > It should be possible because fallback arch_vmap_pte_range_map_size()
> > will constant-fold PAGE_SIZE so pte_set_huge() will never be called.
> >
>
> Agreed. These fallbacks exist only to keep the build working on
> architectures with PTE-level block mappings and should never actually
> be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.
>

I am not quite sure. It won't be called at runtime because
`vmap size`/`unmap size` return `PAGE_SIZE`, so the code won't
reach this branch. But it will still be built.

So, would a `BUILD_BUG_ON()` trigger a build failure here?

Best Regards
Barry

