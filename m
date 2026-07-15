Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2FAC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 02:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43556B0005; Tue, 14 Jul 2026 22:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA236B0088; Tue, 14 Jul 2026 22:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6A76B008C; Tue, 14 Jul 2026 22:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5E76B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:49:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAE8612056A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:49:50 +0000 (UTC)
X-FDA: 84989480940.29.C907DB9
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id D192D100003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:49:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Az/JOGje";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784083788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKnWx5LrBtIKgWAbXgiWOXDWrG19qs6MsR+rTdIDWJM=;
	b=M0qO2W2+gmM1MpFhHotK8gFP3MYuocaez364e2L9OfZIneHCz1z9V0ofhArGxO+L1D87ZL
	t2WJaRZcn9yzcIog8EOOO9+759nrKoj33lq2KhFsf68jylZRjG/PvlagFb9lHY2Ij6g0GC
	lfOGi1zevrgdlHe8/D5jJ44fCWPw6PI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Az/JOGje";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784083788;
	b=CDK4ous6FgWrZz9PmLtWgUJ1nbsr4NDGHArwWYHQd65zdVs02zCJZyZu9H7p38uWzc1CY/
	ORtmYzH5OcPCVNXGLzglF3dfNqnVVY/sJZeCur8dZQ/dxcq3yOdh1CJcHKIyI1ONLi5yZ8
	aVWs96/E0k5xod8RTrDGdILlBDBXjXE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso4673244f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784083787; cv=none;
        d=google.com; s=arc-20260327;
        b=Sgxoq+jhheCfY1xG6Zk/Zb164y6FDZlKwz//Cl79W07UmyKOMR7kMIqDq+7q7M0LJA
         RH9HZJ67qmkI3giHpkPlQ3A8tbuJ+Q7IPMF9PxI1Ze+Z6hZaeU6vgLN6yJDmKOn9pNya
         cS2tM9MpXzehXksI75jEA9OPstHEP40dwKgu9881x8OI0EclHZBjdgmXunla5XcW9XS6
         xFEixh97ft/W6LLVQCpW2dtNP574g9N9d4jjyH7GQ1WL7BZPLiRugt9CrPqvqoGqh9bJ
         a6nj7oeA8LV6nXH8HOsYytUSBSLPY4IqIBhR4aflCNhemV7Ol/HzgmeBWiiJKW78iTWr
         jPZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FKnWx5LrBtIKgWAbXgiWOXDWrG19qs6MsR+rTdIDWJM=;
        fh=xXM1WLrZmoIWkQK9Kgj1jO8IpjtB5KUD0mucfPZg4X4=;
        b=NKVOE/yVGhKHuJXoXvNC04MCtpjFN5hcDW2vhZMtzlNjznoutegPjqPPOTbkOe7rA7
         ejvxMkhTEUUue6JOHPqQGgxeqj6pnUlG+NO7gCcqtQX+g547G3ZzRJkTVQlOZc4S8rZ9
         t2WPDE+sboPSM9B9iQqMAl4mNpTzUy5XqnKUtrH4rA7qdQ365dQFW3at0ySK6omfhDjw
         nXVdefdXXBCgvwyYlwfu8yTFMzvPx6ueoNPzSrA0UVt+dGpDZQ97e5xAH+BFZx1DFFYc
         PN6xd4lRo006NkMJkGIV/vIFax85koclJfm9/vC1OAOHdjlfRC7lrwFYWTOS4mM5/jua
         jSUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784083787; x=1784688587; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FKnWx5LrBtIKgWAbXgiWOXDWrG19qs6MsR+rTdIDWJM=;
        b=Az/JOGjedHWO3hKFRyTo6gxpzfbM4gon1Puq+n35vWd2i9EOenQn970mktRkE/8q0U
         k2t8QytkQp7n2Olx1rAR9hIoRuP5JmfB+2S/ILsiSVVzsgQOGhA4M+mLGGb4fwCg39jp
         Apb7V/i2w6N2OAuC+qqJI0cboF7oBuq8ioRpBvb69NgeNF4ztbAucyBbtN67Vfx+gpJr
         u3iZ6VH7zqgQbIaTl+AolKW4K5G2yk894nWyyJ0KVCmbgH9YzmiZG9u/RSavY/3Az0pl
         DPi6RkEQrY5WuJxybMLaKxbsdqvrnlGbVPSbAp3WcT2tl7Nt+lqhfKOLfRgIbLginVwo
         JnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784083787; x=1784688587;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FKnWx5LrBtIKgWAbXgiWOXDWrG19qs6MsR+rTdIDWJM=;
        b=A7JaaB6tO5A2b3FpkPe0SmEeI0C7ZFBxq5Rn4KRFQw0KmRa6LIx8PX2GTRQW+MWEnj
         6zBAF8QXjtqgjCWCnNnKqZrFVwwwLIplgZEIWDitbBgL13vS3fgtXJ4CSfKEftyvt9iM
         NMwqxhvYR1rFW7tw3CN2t/px7bJKFiMtPSBmG1eBFfAHT0Ys2yjFACyj2uJTRhOkihLf
         wxLO1BR7lHa2qDvwnRkI8HSA34MQvRU0Rqz5VIoaUPofl7CydvG3HeymO36z8n3WicUj
         473yV1pjn/j85DvnUUzMqjd5sfzrB6W4lZVNntOq2Pr4X20I8fRaddUdMZDLXWuSZ06+
         JP7Q==
X-Forwarded-Encrypted: i=1; AHgh+RrxyXLEdOvu9u3I/dJi5To6jhXRY5r3OAe1ji/L3UCswl1aqMu/v72MHSL6JhzdejbTLrhqHpQWkQ==@kvack.org
X-Gm-Message-State: AOJu0Yxzoq/kBwfZFNC6BLxoxhluqq4KRbFI9w4dssg6lPTc7xgFUncW
	C1NnIP3sgB8ByxsHFJbDs9H4hdh4zxKXThbmhKY72d5ZHc7mkqipoZH+bi/HHWBs4oVwcoTsxIk
	7jWeLGepyJZdQA8Xkc7kteltB5xzVtf8=
X-Gm-Gg: AfdE7ckVhRz9nULiH0Kui3P2CaAL2sP6V9wiK9a11FSjquVjd4YbNophHgv3G+FpYCX
	X7fSwot0nPYveV20OFTsLmu46lktBjYm/ZD9o5ueO8RDpISE9y6Uet2Azg/x76HOIPuet5yAjbX
	vwIdLdx1ZLCxMoMf2YedPnVpj66zONRbFh9YhyDj32Ja73n7idmw+eBUbD8QKr8El2Nipz97H2l
	7bGvPuZ/7dTq0SKzm6szgH+GWvYpG9ycL9AQ16VMDT0lhqCOvejYSbRJugHcFu5wKTJt4ovRg==
X-Received: by 2002:a05:6000:4382:b0:47d:fc45:8589 with SMTP id
 ffacd0b85a97d-47f4fc6b180mr843449f8f.0.1784083787198; Tue, 14 Jul 2026
 19:49:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709073823.6643-3-jiangwen6@xiaomi.com>
 <bc4ab9da-0b16-4203-9901-4845323c3e5c@arm.com> <CAHKocdFn9DP=wGLYJrhndxTnxz=eMeWYjK1m2OzPotcvz_sVjA@mail.gmail.com>
In-Reply-To: <CAHKocdFn9DP=wGLYJrhndxTnxz=eMeWYjK1m2OzPotcvz_sVjA@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Wed, 15 Jul 2026 10:49:35 +0800
X-Gm-Features: AUfX_mxTQ2AORVdVLQD0WyKg_A5YApzG5_NgRHhzAQxuuwLcGmmwOTgb4HGKwEg
Message-ID: <CAHKocdEOveLGiad3pOFMNGEKec-wvnwY7w88-8k1Npm1t_YTcA@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>, 
	Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D192D100003
X-Stat-Signature: h1ig8icp64f5m4dhsx58zg7oanzdz4k5
X-Rspam-User: 
X-HE-Tag: 1784083788-305901
X-HE-Meta: U2FsdGVkX19ZRCXsuKMzoG6AF3ZoOtvPm86dGFdrodvltxn8WKnTMTU31j8EObqAksYJH150TBk4ED1aNqbLl/AeyHpg73fQN63hZG0+i/QAyT1i1qoTv0f9bsXv+mRXKfnoySSSyvuLGm1b7/fciqwkyehbE7cBjLlbxTxs2LUW1MG2UgnCygFidTHSU7ERE96MGXUmIset8JcXnPNcLQS0BK11cD9gpm8yx1AOQQpbcSXQU8XuxBEd3cDNiTMYabvnfxsO7n12ivL3yS6MsCEvv0bB17YxuQ+NCGlasrT2BPm6xhjMu0I3s3nNYu3BZp7A5oJ5y9N1WpoQdbkXcr6ECPhlPfHR9R+cR8Bo3aYZcpeFg6EEoapOMEGyPAMcrnJ17o4BHPmKC9QlYAEWdTHYF2p5qnTaZACo6zZ5RMUwjFLQKlGq/SA1wAcTxlbpk+SozD009LYyHXlsEM4hipQXVGVUjhe8bHEe6JNrT4uFB5deFUAIc2RTqKMEu0Ma+2dNPppWMbeeXNpgKOYnP9jIaNVHbEg8y4WtMc4gsK8WOBeKGDZs70Yw/kYXvmZm0kj3yObAi8bzGjLKy4VfALC1BQsIjvalUU/KRFGUWgGS0iSwhVXKmj+DZKLPiaFso2TkCPGdVz9/VzgBwoB4bJhl4GkUe59k8Wh7l/CXX3TIaho7ch5/PEo85QLK43IYOxh3EwJK3UqdOt7ukdAkK8JGSDKOb+gYC5PWtyOspiTBY3Wz1KHceCUrd3bYQD+B6hDci5F/fSPtqgqb+YZDXSN9cXlZqSM52kN8pD1i8w1hiJz+iP65iDnD5xosbwfQezMXzXfYZ/peaIYSYDERIqiHPe+4AstZR2YkvRwsLas5Ft9htJyIMJZEPt5kzUo8ZomN2mc1qjUQd4/IlgvgmkrNCb4bjkVaSL5SNg1ti1g3VnsU2U5tVnfWJ5d66d1mAEFoZC1xpVx9IIf9VX5
 A/tCUwB8
 lDT14k7OLi4tz7Gw06TLLJoH4WiO4ngf5GH7bKpx5srJW++B3oz5Y7OEc3O1i19gZr3WHCgCp4Ngv1UwaL66NxR9ToKisnIwUP+sdKU6T82mYvwV3MdQh+3bGjq24+XRwLHXTGIORaPzlOY+U3rVC7VhG52GPnjXIp/VAxxI+Tb6nzCYvnaooejtq6rp21Q2mpgM3K1c/8pbpfLSvZSE42FXzAqlhiTkdX2JrmnZSAisGIzh4/IsB9cX9kEnzjVFmlIH1I6Z36+paYBAZXchBYJscahVT1yPd948NmmN/Z+AmqHyRMJaps3HpwRRuOKWGeJM8XnLwPpe+abbGCDVvNNUyRVy1aCMEBFXvUcUDx5m/ar5rpM/2UcyCQeRgkbjkaM/HDmPVq4in848+0knAmadmTqny6hbcVfcl1j+7IEAj2yXckDbrOfwmaBITA6yg23UgIFpSu64dPwKm5Sd7qCY+iwdYI7gJgSf2cg6bydpaEu6swtuqDgXKRTW3MZcHKrAIbGJN+EmkV4rLrFle9U/nYPy6KS+CiHjBoRAaFiOFQvSxRKbMJNDEuL2qHMgXL3LL7YpO6zE5za8x8fPLVS/gNV8bVagPPbQfI2jeP4TSS3ZCCQOYamqQgjwxnSOSRvHGn2qQaJQFFvFP20d5OZE8mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 at 17:24, Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>
> On Tue, 14 Jul 2026 at 15:13, Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
> >
> >
> >
> > On 09/07/26 1:08 PM, Wen Jiang wrote:
> > > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > >
> > > Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
> > > blocks, reducing both PTE setup and TLB flush iterations.
> >
> > Too little commit description for the proposed change here.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > Tested-by: Leo Yan <leo.yan@arm.com>
> > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > ---
> > >  arch/arm64/include/asm/vmalloc.h | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
> > > index 4ec1acd3c1b34..7d9c7dc795c42 100644
> > > --- a/arch/arm64/include/asm/vmalloc.h
> > > +++ b/arch/arm64/include/asm/vmalloc.h
> > > @@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> > >                                               unsigned long end, u64 pfn,
> > >                                               unsigned int max_page_shift)
> > >  {
> > > +     unsigned long size;
> > > +
> > >       /*
> > >        * If the block is at least CONT_PTE_SIZE in size, and is naturally
> > >        * aligned in both virtual and physical space, then we can pte-map the
> > > @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
> > >       if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
> > >               return PAGE_SIZE;
> > >
> > > -     return CONT_PTE_SIZE;
> > > +     size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
> > > +     size = rounddown_pow_of_two(size);
> > > +     return size;
> >
> > Please do explain the fact in a comment that huge pte mappings
> > upto PMD_SIZE are being allowed here, if the given block is
> > CONT_PTE_SIZE aligned.
> >

Hi Anshuman,

Would the following comment address your concern?

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -29,6 +29,8 @@ static inline unsigned long
arch_vmap_pte_range_map_size(unsigned long addr,
  * If the block is at least CONT_PTE_SIZE in size, and is naturally
  * aligned in both virtual and physical space, then we can pte-map the
  * block using the PTE_CONT bit for more efficient use of the TLB.
+ * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+ * capped below PMD_SIZE.
  */
  if (max_page_shift < CONT_PTE_SHIFT)
  return PAGE_SIZE;

> > IIUC arch_vmap_pte_range_map_size() gets used only when config
> > CONFIG_HUGETLB_PAGE is enabled. Hence should not these new huge
> > sizes being supported here also be added as valid HugeTLB sizes
> > thus updating __hugetlb_valid_size() and adding corresponding
> > new HugeTLB page sizes with hugetlb_add_hstate() ?
> >
> > OR could arch_vmap_pte_range_map_size() and set_huge_pte_at()
> > can be updated for vmalloc without doing corresponding changes
> > into HugeTLB itself ?
>
> These sizes are not new HugeTLB page sizes. They are only vmalloc mapping
> spans selected for a particular virtually and physically aligned range, so that
> the PTEs can be installed with the contiguous bit in larger batches.
>
> Therefore I do not think they should be added to __hugetlb_valid_size() or
> registered with hugetlb_add_hstate(). Those describe the HugeTLB hstate sizes,
> while this change only affects how vmalloc chooses the PTE-level mapping span.
>
> Thanks,
> Wen
> > >  }
> > >
> > >  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
> >

