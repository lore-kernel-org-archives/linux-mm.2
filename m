Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D565CC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92826B0093; Fri, 18 Sep 2026 02:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CC96B0095; Fri, 18 Sep 2026 02:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC7F6B0096; Fri, 18 Sep 2026 02:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 852A96B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:14:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B15E1C2B63
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:46 +0000 (UTC)
X-FDA: 85225869372.22.D0CBB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 750BFC0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=licAWso7;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789712084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSUon0Ye+JTXHkgGPecismrQ6aWB6KUmBQxrnhvgcgA=;
	b=zQ5xdQ2UUBQcMB4mirR8uXxXUSVruoVKVZEJZRZLJXlb4qbphEceEAmb1ACD9K3BFHD64I
	jPs6lqaA3zFIfKWm2IH48ONKcGKe2k4KD69Za7f1xjuZ3sa6H5uOCI+aiW5i2BNCBJR4Rq
	D8EBlPBffuh3rA9++v3IldHioJQIQVk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789712084;
	b=kilMLZjgKvTBuZMESkmjWXbXn+edEvDojNpwnfALC3qZA+6zNOMj0RcXjPUqU+epjlZfgN
	w6MAUIAWBMk4RynzZ0b0n/Wc3arPVcZJYkOU8pMKlDPdBHNrC0F1n1tuxfFaqI0TrCQ1r5
	WSBNRiSWGCd2zErqrRAR/56lM4qZfbk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=licAWso7;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43BB9602CC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D41F008A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789712082;
	bh=mSUon0Ye+JTXHkgGPecismrQ6aWB6KUmBQxrnhvgcgA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=licAWso7wurpuT+qtLrru9FPdgIU6h3waLk3dqxtGWsNc8bmF26CatzbCM/Iw4YK8
	 mUuPk/kEb/nHWMfsHa4psZ/Sb885bJIE7SruHM36LB8eqgDrLuiDD4TB5JlI566ciU
	 o1ubdN832KdqycKRKvXkCLpiVCbNws2tYcryFU2H0ESDHQkvPnDzicDtgGeCvcgB6Z
	 TxyhxSHhUQBRIiQy9ZDwfykgyg/EWzJXDqOcPAKhopMBA+9UiFVQCyrXcKpztsTCtB
	 4OuZpEU4+I7EVjZDjVG62uXKV8r9vSQdj3+p6Riw0nmGFnpXxp7J0nVFZxO9d/EMzj
	 VU6AIwYogw00g==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-939109f067cso41824385a.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:14:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx5+kf5HYJHNGVjbmNKdgwcXvUhBF3B8stoueD+K+0wetq0fVKjonWd5ylHpoPouaAzKFIOqM3AAA==@kvack.org
X-Gm-Message-State: AFuF++nlwNFcLR2kYDovDeYyxuFuz0G908pTwlC2EglgcWuFmCCIggC8
	V+VdkUU/J6N+djIzfYBAHzukFui6WazNdVyUvt+g4vwms0BieeAUYQj6M5RR8rSLc8uyEcxLoNn
	JUFx6ALJh5mA84/xvi2pDnokPu6xhlUc=
X-Received: by 2002:a05:620a:17a3:b0:939:e735:c50e with SMTP id
 af79cd13be357-93bdc6a6970mr193841685a.13.1789712082223; Thu, 17 Sep 2026
 23:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com> <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
 <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
 <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com> <2462f67c-f7d3-4eb3-a093-6a338ef49f14@kernel.org>
In-Reply-To: <2462f67c-f7d3-4eb3-a093-6a338ef49f14@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 14:14:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zMG6v-ioi8-NhveqowPVAnsHkFCNy_c7+KHDMRW3JH-Q@mail.gmail.com>
X-Gm-Features: AcwNN1X6q5f1Ex-rUff9-91gcAaVXuwTbEB0wMz6EV5siIJ-q7nSpPx4G64lSm8
Message-ID: <CAGsJ_4zMG6v-ioi8-NhveqowPVAnsHkFCNy_c7+KHDMRW3JH-Q@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
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
X-Stat-Signature: fy3fgpp13c1s6p8d6icyzj6fqjonyaqc
X-Rspam-User: 
X-Rspamd-Queue-Id: 750BFC0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789712084-35995
X-HE-Meta: U2FsdGVkX1/UvVA3LvWYLDkL1iwVsDXZBo54+AY7kn54XlG/f3+aq2H8wbGdrg2OZRK+XImtqwB2n1yUjF0dkN84xrDSv14Bp539plTtM4PVCufVvGDsFjSu1Uap4GbQc3FGsCrxEteQ5UyUxv+gG4od091krenBoSH5Ra1wICd3ddeJUql6VWHD69z4HI4CGwPDtPtIi0ZA1zhvMwTYb01JiTSn7KBVxyoPpcGuRUmR87Ii4cdUXIwyOCnc0G0zZ8OEVwQkGkXaXGfQRTme1tLW0yo3UWc36kiO6+e6Qbd4Pfb7q4oGrKLSV0lrk17ydTSGnXlaYQIPdZWTwpvYO0lrlDni744H6PHbPoxcqTqvyYSZTwlZihfbJXNvEEjZdPqWFDUSgza2yxSXScc2MfxMqjNCkpHxQz3TQLNLmEq8dGwEoDmycVis5eNy1wjFAJ5ZR6TlbSdkwJJg4wyEC5/BB/ZIBK0GUHO4WV2efrh8fD0Cq+SJqHQLER+bt2ynNTimRcKKiOqt9UcT1J9Tlxwz+nGki5Ng25amj7TWrsFfvPBZDJf/GKvTX3/1B6lP5DSWn3DAsoi0ZkpUK9FtmJem6XEaKCeYLlJ0LbmPgnYf/u4J+VyaAxceCLoculKgEppfGccswYAZZFEsQDCFziHPOg1uEShkRulkgH7cNSVJfhX2e9c7GcbXib5YfWonU7qGEvV+jhqqQ1r97Lbfo5EE2Rz2ON0Gycu0dZBqaMYvB17wsff1XZwhuF4pYXbHO3bMeYftTVGQwIrSTmEUVQuf4KC83sspEnKnYqxWuhf3gAZPfEBBlPCk/DSGosxfK2Bsl3xi7eVaBa6KTpF1kFM4iDt/0zjlBiHVhY2XrWBBOSp68SfPK0rTvZ/nYAutNiQRCamGLkoc7I6LWHw2JSwL8pF4/Dp+fm8UqkFIPfvemJS5fZv1v+Zi2hLB7Lxrq3UdI7da1o6bFqQXLdr
 TYWc24nl
 yHRwaMSOVhjNlitBF2szkWH1M1vK5gNvu/l08qOxwJQRiq6bX7FVc7qwIDHGyWvOm6pdhgj5kGfz1elRqWbZ63/G/QfcCdE8tE9u8V13Cp8qSxo08+G39C5ABgoilUixZFOQ1sdKelaEUuFUIQYJczZdpIjlImL9n4MGuc/Wq9FA+LlhMWv8b8uSVqY1nEAjySQgHCMSGTq8kNA7t9t8XuPMqFB5+W0l6er+tsXY5fDCT4nJISdgfOBidGfQNVQM/qlJH9C1zUqkit0SOgoeDGlAhD+HIg4FKh8txGZlA5gBPhFMM8FICHyRcg/sbyjXP3Ndg4n9cdCyyWzJk4kAXTR0UdVY4aMn2mRr8cJitEwoOvxmBzkhLQwdnyJiV3h73cLAmeqplIpx302/od+sN1zOvJ+qmIwFXiQwf+ynWEc3MH9+xpeVjKe5QPuQzJy43kC6wJ19AXY9zMcmllK/Pg5zyMkWxz/dqQWVw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 2:05=E2=80=AFPM Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
>
>
> Le 17/09/2026 =C3=A0 23:44, Barry Song a =C3=A9crit :
> > On Thu, Sep 17, 2026 at 10:41=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmai=
l.com> wrote:
[...]

> >>>>
> >>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >>>> index cdd68ed3ae1a9..349ced999f959 100644
> >>>> --- a/include/linux/pgtable.h
> >>>> +++ b/include/linux/pgtable.h
> >>>> @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pm=
d, unsigned long addr)
> >>>>    }
> >>>>    #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
> >>>>
> >>>> +/*
> >>>> + * PTE-level block mappings for vmap.
> >>>> + *
> >>>> + * pte_set_huge() only has to be implemented by architectures whose
> >>>> + * arch_vmap_pte_range_map_size() can return a size other than PAGE=
_SIZE.
> >>>> + */
> >>>> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> >>>> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> >>>> +                             phys_addr_t phys, pgprot_t prot,
> >>>> +                             unsigned long size)
> >>>> +{
> >>>> +     WARN_ON_ONCE(1);
> >>>
> >>> BUILD_BUG_ON() would be better here.
> >>>
> >>> It should be possible because fallback arch_vmap_pte_range_map_size()
> >>> will constant-fold PAGE_SIZE so pte_set_huge() will never be called.
> >>>
> >>
> >> Agreed. These fallbacks exist only to keep the build working on
> >> architectures with PTE-level block mappings and should never actually
> >> be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.
> >>
> >
> > I am not quite sure. It won't be called at runtime because
> > `vmap size`/`unmap size` return `PAGE_SIZE`, so the code won't
> > reach this branch. But it will still be built.
>
> The fallbacks are defined as:
>
> #ifndef arch_vmap_pte_range_map_size
> static inline unsigned long arch_vmap_pte_range_map_size(unsigned long
> addr, unsigned long end,
>                                                          u64 pfn, unsigne=
d int max_page_shift)
> {
>         return PAGE_SIZE;
> }
> #endif
>
> #ifndef arch_vmap_pte_range_unmap_size
> static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned long
> addr,
>                                                            pte_t *ptep)
> {
>         return PAGE_SIZE;
> }
> #endif
>
> Therefore in:
>
>                  size =3D arch_vmap_pte_range_unmap_size(addr, pte);
>                  if (size !=3D PAGE_SIZE) {
>
> GCC knows 'size' is const and its value is PAGE_SIZE, so it won't emit
> the branch at all.
>
> It is call constant folding, some explanation here:
> https://en.wikipedia.org/wiki/Constant_folding
>
> >
> > So, would a `BUILD_BUG_ON()` trigger a build failure here?
>
> It shouldn't, if it does it is a compiled bug or this is because someone
> has redefined arch_vmap_pte_range_map_size() and not pte_set_huge()
> which we'd better know at build time rather than at runtime.

Thanks, Christophe. I was also thinking about compiler optimization. I
was just a bit worried that we're touching the common MM code, which
affects almost all architectures, so I'm not quite sure whether this is
supported by all GCC versions used by those architectures.

If it is supported by all of them, I agree that `BUILD_BUG_ON()` is a
perfect approach.

Best Regards
Barry

