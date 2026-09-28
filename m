Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1CBC9830E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 02:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13016B0088; Sun, 27 Sep 2026 22:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC40F6B008A; Sun, 27 Sep 2026 22:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2486B008C; Sun, 27 Sep 2026 22:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACDB36B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:42:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E43DA0B2B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:42:41 +0000 (UTC)
X-FDA: 85261622922.06.45B47DD
Received: from mail-wr2-f14.google.com (mail-wr2-f14.google.com [74.125.225.78])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50E9740006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:42:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NRCEXwek;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.78 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790563359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZjJVun8xN7GDkHYEL3bXr/VlWpA2YfoNARMcoM9xVw=;
	b=Z1oLUcnKFzrKUkMjuKDqWbvVDme+MsgXlV33rljzpp/N+wwA9dRxQPvY//ip2N8+a7jFHO
	gn7kzq3z4fzAba+yl2n+TdgkU3PVwT9ZWORnAbcJNpkOR7SFvPEjRQfHSMnqHjfVgYW0H2
	vgVasL3LnqSHw5KzwMHoRKm3lNCikkM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NRCEXwek;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.78 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790563359;
	b=BNm64WoHxtkpC6xyL+ilsbqdtlYQ14Xlbs0Oa/jwRIx2kYmZOHh+jQxaITBCICialskTrG
	R5d5o6tyAXVCwvFYb/a2Moci4MQXwTM8HXcc9RSdvYPKcXFOVBaAErONBNz2GL2jxq2z/q
	m7rtjopbdnaa+TCbN8aOaPWxDriU9fA=
Received: by mail-wr2-f14.google.com with SMTP id ffacd0b85a97d-4888598e4f9so1345593f8f.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:42:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790563358; cv=none;
        d=google.com; s=arc-20260327;
        b=eJauYjG8wBvlC5O/vpo9lkE64iw/bhjMVuOdAPRE1y4wBuQ/MZbX+LErl0Ehmq5N/l
         wfK6H4I+NTsUPnmF48miDihb5j+9vsvoIjNavSUU572TPjz5AhmythYfbtj5CzlIn2AB
         2lStqWJJgWwWWca3MF218/Lh6vnh4eKp8mA116yqMJROoDXvc5v/tfORRW9HRIU4g1h7
         RWnAYsnU7pt3DXBwpGGR5/N8c3UJFMaLrb7nA1O/nEik2mlxGewsO80tautea6znehUj
         Fb6adRi1EgUm/szzmeIXctpavZEpects/uwxbzhoMWOjDSakXLeoFfVR5dByCeHcNnoU
         o+xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YZjJVun8xN7GDkHYEL3bXr/VlWpA2YfoNARMcoM9xVw=;
        fh=w7Wzr4yF0Z0rs7UZv06hnlJTgW/xFl3zYeVpRpSkgtY=;
        b=orhjFBEDCDKnKk5AR8pF2GC7gCmXBcnZlj+yltHWDFu840yF2IKDSqwtXdRqLMX4Ps
         igBlZ1UfzTcQeoa2ji9vmcKUXXmV+AcytD+aZ0cnBP8uNnoKvveaEtYWB3tB+l0BHdqu
         2fWEb0XM8XqQqpcUhqnjh3AsAFzifJcF3iIUGDkAN3/xUeZfF6eqeKPsHn6yFTZxqjex
         6k9/499G7jyME8lVmSV3vmLeZ26qujHC0Vdm8EAKaPWqC3PGt9bHxQNiLR7JkycKu38d
         NnyUMWIERoCDJ/+46z12sDwBPvM49oN8HFOBHUlgHOXHz2YLEZ+pARNMvCHjHKxohPxB
         aLbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790563358; x=1791168158; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YZjJVun8xN7GDkHYEL3bXr/VlWpA2YfoNARMcoM9xVw=;
        b=NRCEXwekwoLfr6JfK+u2taPDBwm5akWEm8pOMctnWFcH5CoHdvhYFDaGEbc6eV3pbW
         k4Wn1fH5Ljd/v62nmm/cwTnW2sKQ+0AS6qrgprE33HSQqNjhuR93sOvfLYkKwPBwsqRI
         +eIXnsbpCj/wiUN7Nrg/ZegMYlkwyDnVqDm4lKDBlOLUACRbCMqQMfxL8wRQPCGwmBU6
         s0WK+ocMUSaJo+smeKhjhHWj0hIa7DbqZYV931TGHRSz190yTfKvVUM2TMzrRwa7pC2B
         +lDjHeZtNXkEnKdsPZJ2rojy15F8KXa657ch+QVMOuZ376iZtksQv/rn0DbbJ7CLbU1a
         pxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790563358; x=1791168158;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YZjJVun8xN7GDkHYEL3bXr/VlWpA2YfoNARMcoM9xVw=;
        b=dmAwPTSFwnBcSpxdN5inkGNdJIoL3wsINhZ2hh+fcC1CZcq3WdCEG0s3RGSzBWVoO/
         oE0vr3Lq/TbK/vAl3aZgVJ4C76bHG61+vliRhYAVjyl53G3yeBhoyrksD/eUB2etkTFs
         t1G5fUe6R3an6nJxCC17hpDxuFHYRIrMhpQoMlWL01Nv5WkgMPq1ifgLgbyHy0kFHZSH
         3Z8txCjYbse6hFIiAdNJp8HoM76/5yT2L3VDdMygD6WY/4muHLOIwkCaSppx52SBtkU8
         U+MY4rXlx00/znjvrI93MZ3+cnzUYO9BeTSEozXm1jteRjY3T49rs7ui413C2yTky8PU
         Uo6g==
X-Forwarded-Encrypted: i=1; AKwUvBybDWyH9Z9OGNLGcnOz7s3RNtCVR6WUyz8xflazAuRZbRh+chHeRfAP0+DrOM/Um1GS12SIoDImgA==@kvack.org
X-Gm-Message-State: AFq9FYLxC26s6DJizJX24+IScYAfnizKQ3oUPgVwUrfU87bfiwpvuLf0
	vJVbnuJTaZidT0zQAPLEY/LcIGoKtVqjl+jiThPCP8fz0CnYs3PrmCojIJTvLPecLKVM/AKYlv4
	jdrrk6ntvq89k4uO9oeVzGCMiCG+Xlro=
X-Gm-Gg: AYBFou07sji5+X0smWnBAqYW/HqJ2WcRP2vkFWmglStQXjTfMaZLAt64DRuyFxhla5X
	jQLwmDnrfFgix0f93inlZG88QRb68IT3bwKC1+GKg7xSCJbOn6FO1xZ+BN+hM+nO8RgvGlsLBR9
	iNNMBKd/QFissgQVQJ2OZwmv1CLV6/VY1Tse/bDGEpa6J9k4yp1ie/+bhQJRtJJXxxVthDvZpWV
	waXS2+g2NSGRcfA7u0uhPqgUmEzoIiQFPbhwJIC11Ub5kd2fKS0QBeCiQq41/7vociCI67R0mCR
	lQ09eUBagxJlrd7NC1RJtEyAA8Ss84Ijs9MHtA7t4aIQvNzxEDhL3D8z
X-Received: by 2002:a05:6000:385:b0:488:8cde:aaf5 with SMTP id
 ffacd0b85a97d-4888cdead77mr6051154f8f.2.1790563357707; Sun, 27 Sep 2026
 19:42:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-2-jiangwen6@xiaomi.com>
 <CAGsJ_4xQhmRigaV_2G3pdOgk5mvC6HNzqCyUdRY3RSG8-QNC-Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4xQhmRigaV_2G3pdOgk5mvC6HNzqCyUdRY3RSG8-QNC-Q@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Mon, 28 Sep 2026 10:42:26 +0800
X-Gm-Features: AclHuK-tj6RxDkR8fHhPZoG4i4S4CyEDCcJlFwKY4ZUdtlHJk_F2XqaylhywMI4
Message-ID: <CAHKocdFUw3BDjKwGhE+gMxyVXmMWtX4pP8brY3dBOhYhYoCgdg@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50E9740006
X-Rspam-User: 
X-Stat-Signature: he457q8ywzab15hrckbrr5xef84brba6
X-HE-Tag: 1790563359-357596
X-HE-Meta: U2FsdGVkX1++s6QgTaWCRkDmZ9lS5pmh0yWj3ysp4cMjU+tW75ViJr954qYthp58vRcbPVYtinkp/x81hVg9j2KAeGpjZqJ+zlmamwISfruz6a5s1gZYZDpk7wLU7oTSankcDm+ftX9Of2gO3sILpRYCqQIKn3K3XTJlKgmRaNMxLgg1i8Mme6lqKwNo+KSVMAShkGWRpmulp4hjnXwQcvd6MqwwCW9mvJAooi3BGA9kUTyTSJkrkczg+v+dFX2bWzk0iuL7EzklFzhSw2HDS2WOsxpxOdx66MsCPQMwxwK1xmneomFzGgKLcZdY+hH2uQ4TN1XXu/3t7xKzc5Mib+Nmb2wRxtCXVeWYIHsar+Zpoyg+flVtrecjGzslnlE/cQYw0j7B+PXh83glTqTTYevqLUD0jyjjBbedoH5BQaKyJZrYzTHNtL3Bkst3ULUst1Om96Zah+iNipKG4U3UUclB15IM1+gR8aZ+WEE488nSVSr8NJunbLL8uVsoZyUmIIzChtXO1kCg6rZrpFo+8e9Bel6FSGCjGuPfl5BVcx/DTn/40GKKwnNWjn3gj6H+IHYKACLjXmbJwlPVmMvKke7R+/neaz1Y/2+nd0C9q+YIXWjkYRIVueGOTIFLynryPOzXtqu2XWn51xmb4xdWxhnSwPHoQ0RHuneutjp4C/qDJ/5djFY1V7kvpOUagnT8mHHhfoWaK45efhc4HOAOsaSNVdVNd6/pTpk4uF25Dre+3iec9OoZu+ioCrgJUZkZXirOR0KyGwVE2gqkHBCm/uFL0hRjKSTygDVrKRYLwTvCbsg6a8T8cplh2wykMuQswfFcSQKrYWU5JAleAayL758v0GuZDgwsTw+vnZCfwEmeTjW4BlYoTMDMn1ICQvjzNSTuTwEk/K8lpZiTJOQQEbk+jSOH8F6rasB3yyPbMSTzJDL39Toaca83K6izNjoXJBHHU7yqFEXNAiQlTdE
 HyNmRgVr
 a6n8Z+V0Jgx9LOCgEWmhnrPc71W572jMKVHJOXdp8nDnm9owsVYfASeiyF/tVFyTtoyz3CmYZJLrZM4NLWiigj1xvfG8YdsD5WUFM+6EZe1rCzBmPvbdP//u1OsoAm5kbvn1TbIkWCdeI2leBRR0SbZgeP2JEHAgWMyOha8H+IaoS1evYzv3xNqxUNPvYTawefQuIqiX/kPVk+kF745D7YGA/HXdVXtIX4c7b+z9sgHElve++TbhXECw7aJkvANDfQODIac9gFVh+rpbRoF9FavZkJkXQeoCbiGRWZJXBjxDiIPIFrdmJNlnjzuzUxizUh3MpnLi/4JpUtC7RnwMGiVqQkTOtv9U9vSDHELKedMir3oMRYc5uxXJEY8DkNKwPALrD9pUu7yuE6DYecQKMKCkZXrsg9obuQ+42jU0akL4M3IKlrkDL+DkotExZEwOmJVoqCwzsi+xqqzj5FzylPuTJVliDLkwz2OZvzD5CRq98oDDuaI4wRwoiwUXqJGjwz4iRLTAJwdtaIvHoGyPuqgOhAObmJCyOUMaJsz86IG5bnrK4iaSDvszRaqogJwLdIeiVyZ+xUDL3YzcjsaZ3Mex2bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sept 2026 at 05:30, Barry Song <baohua@kernel.org> wrote:
>
> On Wed, Sep 23, 2026 at 2:28=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.c=
om> wrote:
> >
> > vmap installs PTE-level block mappings (PTE_CONT on arm64) by reusing
> > set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
> > helpers gated by CONFIG_HUGETLB_PAGE. This makes the feature silently
> > unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c=
 to
> > HugeTLB internals it does not otherwise need.
> >
> > Add pte_set_huge()/pte_clear_huge() to arm64, joining the existing
> > pmd_set_huge()/pud_set_huge() family in mm/mmu.c. They build on
> > __set_ptes() and __get_and_clear_full_ptes() directly, so they do not
> > depend on CONFIG_HUGETLB_PAGE.
> >
> > There is no caller yet: mm/vmalloc.c is converted later in this series,
> > once the generic fallbacks are in place.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>
> LGTM. Please see the comment below.
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>
> [...]
>
> > +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> > +                 pgprot_t prot, unsigned long size)
> > +{
> > +       unsigned long pfn =3D __phys_to_pfn(phys);
> > +       pte_t pte =3D pte_mkcont(pfn_pte(pfn, prot));
> > +       unsigned int nr =3D size >> PAGE_SHIFT;
> > +
> > +       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
> > +       VM_WARN_ON(!IS_ALIGNED(addr, CONT_PTE_SIZE));
> > +       VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> > +
> > +       __set_ptes(&init_mm, addr, ptep, pte, nr);
>
> You have patch 4 to revert the `clear_flush()` modification from
> 06fc959fcff ("arm64/mm: Support huge pte-mapped pages in vmap").
>
> I guess you may still need to guard against the case I mentioned in my
> reply to patch 4:
> https://lore.kernel.org/linux-mm/CAGsJ_4xiLScr2PrPu7Eem73GvPCtsuYd3J05kW3=
SC4QSs5Q4aQ@mail.gmail.com/
>
> Something like this:
> VM_WARN_ON (pte_valid(__ptep_get(ptep)));
>

Hi Barry,

Agreed. I'll add this. The vmap path should never see a valid=E2=86=92valid=
 transition,
but an explicit assert makes that contract visible.

Thanks,
Wen.

