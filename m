Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86EDC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83F0D6B008A; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A356B0095; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684236B0092; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 450026B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:55:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1518FC02D2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:48:29 +0000 (UTC)
X-FDA: 85226105538.26.1882325
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1704014000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:48:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gj6JBLCj;
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789717707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXqdDZMk2n2ZA2FZuhNJE90D+Z4Rs/KppQMaR2DzMcs=;
	b=1X4s+wz/5O2Bn1xnaqvXROuYpi6g/jo7rIYrvXtKEUx20OauBWFzHfnJxFHjhu22dN1bVe
	DJsHCPzwwWekROK1D3H2buye7wSRiwXyD1GjxTHPaQRk/w3o4q9+kJzplsefnG3cbWF+M5
	L8ZVA1KJnimRJR4v/Q1c5RBeEZ5V1a0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789717707;
	b=3dNtEdYi59PJ5zGgb7dLOhNZOIyBzmZ/GJHJfibWjvktj7C+viXJt80N/damOfEUoy+xy0
	cAp02LCN6pZMx3H3LJ32dqRSkgaqIPMGRJ4/u2P28sP8GPRHkxdAogX74WyQVYVVYVWGZt
	CnMa9VoWssfZlWXIYE+hRCVPUefNJ5o=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gj6JBLCj;
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-486e1a044c5so239281f8f.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789717705; cv=none;
        d=google.com; s=arc-20260327;
        b=DgNP/74Y1ur9BTKPxbeKLll3pNv5Bo3hXlu7jFk6bbDLnMZ0Wsnyi6ef8gAZz/sgzL
         vbvT7qKN2LGX2jqVBJ3O+GdCjDP4X4fTt1E18845YZ7c75NSXsaltEsQj1C5tqZkJdX7
         4bpzKBvBHV/BlVF+Ca49Y3/2NGBSy1wk3P2xhcl5S+gM93wOy6t6F4+pVqgoej6gSnQ/
         lA+Vcd8rbdVJOYvr8wCzgmCapUVkAAgqpgKscEkMMSpwTVikWzbIeVCuyyU+bbJBMt5C
         SgMuaYHtH6oKZu2Ci4HG3rK3T1ztZ9hrczxsDZLy8cUBgmhPhDp0iB13T27hxJOx67FF
         uikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MXqdDZMk2n2ZA2FZuhNJE90D+Z4Rs/KppQMaR2DzMcs=;
        fh=wXoBtfibThRa1ZoQ2vIH7l8UCeIQVbzaEoBZ6rzJx1I=;
        b=ZmajeE1XUfX60fYLro7gEI0xEvmhVNAa8hY0q3QEWLqlKolzghGQs9yR38//8GDAaS
         eOjqfcH0NLjCbBjBEvkH3Qj+XFFvySbLpgNQlMMeP/r9s91etV6CA4CXeCFf/dWpYFYu
         fXPkooWDia8OKQzOV0n3UM6pGgGoGyoH8fVvKdMhJ/w3IJwMP7JJHbAhthQ/E3Fehi/f
         xTpRixYffMWbG3KwtxzS1q1O0kH8jmqM9LuCtqiWTS8vxFFZgqEfbDIIB2YWmjG3ounn
         MiIaMFKeeJinZud/rihCj5dAd5XFCvNihJ5kS9J3TgUR9dO7+C46D5pTEgQAfj8S1isY
         he/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789717705; x=1790322505; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MXqdDZMk2n2ZA2FZuhNJE90D+Z4Rs/KppQMaR2DzMcs=;
        b=gj6JBLCjLIr/WROf9mueLltZRp7qg5MLcPUwDK+fvqFfSwIiLFZJe1tPS75O6RF2Nb
         AqiWKW8G1xRB6ce9ev2NT+zZjyY+5jbtOowOVQEmWurI/5m4CBIaiXuT4TRlOgwRS4qZ
         Fs+/XbM0YDrczfLQEkYflhEWlRfuZnNx/ULVExMG0NYS0OOUHKZUSvm00OaamNY4FUNm
         aGdqnyElfW4SpUGEoezjNfhIAUdRLw+RzaTt/9hqG27WNhSj+Lqdkj+Na3O+xbPWVR7+
         sgkLhT8GDte4avVEguifdi5Z0LcnQJEJD/Yd+ic5ZbgGNeH1t3qS4yU9509U9cMfNbj1
         YxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789717705; x=1790322505;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXqdDZMk2n2ZA2FZuhNJE90D+Z4Rs/KppQMaR2DzMcs=;
        b=gg1C3uN4xT6HYmao2Wqa1ngKadKRXQDuTOo6M/viSuXoBU2WU/hQPJ3QUhNPm3zaDO
         dBLDHIVGAxeH0U8JrTAj3aI3fr2xKjeNaM2SjJ+FRatalShywsQ7ja4OAffbIrAZwAzw
         GCwtwnW1vVeomIxEy5CgepG2kPmuhNcATlVECcsX8vUVW0MQNAAOaW+pwLGGHE5A0PZD
         RK/FN813b++ukXWeJp1Tdrt52GStGswcN/ptAPwnImgqoqvw8tpYy5QBW+4Obouyet7n
         8+H0RBdSF03vQoRuADvO/E1cFX2a1QinxCkcSb1nuiVtKcaecC8MZIwlk4TTxsnM66aB
         6FHg==
X-Forwarded-Encrypted: i=1; AKwUvByyj+dnYVvs2B5gJUlznMP9JAHzzEnQNdP5U/QTOQur+aaAlnn7q7tGBEnMh01QXVYuXcCnQCt9fQ==@kvack.org
X-Gm-Message-State: AFuF++lR8vSgyFWnzlres6yCWUwW0h+FyudFwasGJsoTD6R/waPNYiI0
	bupK6MvumJIm5dEDYoIrgSd6iFyPY9qNcGC5xe9gBzhBs4OSjgq/cOzwptRwggMuDxTdKPwKevd
	xTLVP4Ew81md1jdpW03nAmz9LbVWoR1g=
X-Gm-Gg: AYBFou1oqsYqqlRR8VvGU809/tgXQbNHAXhXV+eWcS5gJl/TnxAYitDWoeX5FTMKSkt
	nooqRitDn6jMeVdlXvnNdRgmawmpkGnmjQJfgC0pZ9w4AFT3omHuSLF5TlL2MWD89sStRPMorRJ
	HFn+IwyY/4tGe82IDadIcQQq28qSATS82iqHPXOOa098zKVOCC5bzcAWRBIq/zdG9Hi/9nCvKh/
	j21SeSLgl1cygV6JGKgczqLokOOUTkALU6Oo5+c0UzsKXyiCEnEobhyoaUYeP48fZn8+QARk/AU
	QD9HlsIsG8HKDgXyplSPaGQtirpv7kg6Mwlmu/NmVLo0/vbUk4HQCcxlJvuSTH0NX8s=
X-Received: by 2002:a05:6000:4b13:b0:487:1687:197d with SMTP id
 ffacd0b85a97d-4871e212458mr1713724f8f.6.1789717705281; Fri, 18 Sep 2026
 00:48:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-2-jiangwenxiaomi@gmail.com> <CAGsJ_4xujxpH6OuuUao2=TAjTMKhr77ufW6OoZuk-VB=YPd6fw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xujxpH6OuuUao2=TAjTMKhr77ufW6OoZuk-VB=YPd6fw@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Fri, 18 Sep 2026 15:48:13 +0800
X-Gm-Features: AcwNN1U7w_zpIxImLoNROHRiindh6mTvUu1jbd9liF3b4JQySYxKRKgU7ZyE2AY
Message-ID: <CAHKocdHS-D7Gg_n3razCrp-QT5seT4KWz9r1TSWVVwLFsZmU7Q@mail.gmail.com>
Subject: Re: [PATCH v8 01/10] arm64/mm: add pte_set_huge() and pte_clear_huge()
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1704014000A
X-Stat-Signature: qckza5ugn3jd3b4hjagpssgh7ycj57wu
X-Rspam-User: 
X-HE-Tag: 1789717706-478032
X-HE-Meta: U2FsdGVkX19NK8MTsCLCNtO3tbN+UlMJV1W4LQtuh/BMoEUOlwraaZ/Bk+9Ye0F9Fy3qdBLESzE49jmpWwhkUX4GU3ng/d75sGemQG0jfibPuKMdnmyXMNVuOdi3y78HH718kv86IG74yBnavSO2mmt2HfGSrsRW0PcUHpl612AR5insyo61YojnMETR/Oix9Z5ZMeCrlb0VepoLHgSHAHAG5ikexMfEKhOaq+z8r71tMK4grjm3kzc+o0oa3XhgJhq0t5d9YQF1sfMEp7+xMI9hSDBaWOzaJjbrM9DYRoyb3hNpH2mrCPM9KAm9jlCXehhZjP+sitFp0c4s9Bc/+tZAZF+G1e7rCGT9op6y+u7gCR3B9MGtZXbBmkpKrBDRnk2KrdHgUwAfyIAgGVLPCTWhIzioB4K+i/CNbdg7NZdwsWx7RZ7s4Txis2efvtyh8Qlq/ztACy1ayhJKRtN2EamDiUD9zYOqG//mg+uS6rtzneTWUu+WWGkN2l5xEPT7RFgnVQcER9d0QxgRr7U6NCobYjT/y6+cQLG2oYvM4l/7Uop/JZqa2ixTt6ezXIk55ohnXEEV96xjPCBiKflVCuV3UYZ+b0RG+bbZCQIasKI1zm1Lh9Mb309iaNXUCu9QG6PBDjrArqCrc29il/5Wm9wMTLM+Lih9D99+yS0EJmAn6prIwV4xx0btL5Iv3Ntn6LZoF0ulu/TeJyLh51u2S7yCoe8/yxTCQHBJwb/9qADW/sJ+xLJmZcptcflaH+9d0SKm17Yyqu/nwknD/7BUINTsvdplT6Ut5sXmGLSwwI1GAoj/5wd6FVePdckadR0MiHlyxlRAuDi/9S3AoThGopcSFeM7HRKbsEaDJPSnF9263XPrMbcRjcFa3nLeBLJlGaq6y8eTGxG7EyDdVHui6bbvUNIw7RmP5u+5hfJ1762IA7dRhmk0XoPbYU7mpQLSHIlkKPPN+lkdl8q3e+3
 layignqH
 jryIo3l5Uhe/leE9y3gqrp5GrwJLqYIAH+q5KJew8rJQJ5KWqyQp3FEyO0Dsxpisn0avJHWWkEN8c9IvGpgmGWnOtnxXjlsevrckfxB6bpEPkeffWoE33Gak0AQtQEXEsHB4S2q3M7Sj8cW/yHFYVkios0fvzf0K0CYITRoTiYRZy5Qmmo00mZrsO07cFp9oAaP5A1iXOhmFpkPLigPgql8Kfzyobn6JrU2UChxeIVNqP/bWyHC5VRfhBreiHWICwKqnZzcPAk3OU8R/Ohp1wXc+hTItZU5hsJj522y2dEgsH49E58D97Tl4kMT+71RFXQ4e6djw4fOGYrVdRBmHx/Czji8tRuif3Qqs+Bm/gSFMaPo+mKrqtBtscXa0zF2lEPZKMhyEahzs29/z6A66mJlq4QraQHYzhdRqJgSRTDyMupyd+TD43snRMk2x0XmFeff/B4WmrBF+1RsVPqw3cgg/+8cy/QJGhT4inbc5O5ygRIr0iXeAiE/vo5fl9VqNL2dE1PmZF3QhwyX+nCEgoVJHi2dQBOxZfK8hvZXJYgOKlQQuhtNMXbHdlVFIAuLOY3UzE3QvZtThUdUN3Y7iM4VVCHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sept 2026 at 07:22, Barry Song <baohua@kernel.org> wrote:
>
> On Thu, Sep 17, 2026 at 1:29=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.c=
om> wrote:
> >
> > From: Wen Jiang <jiangwen6@xiaomi.com>
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
> I tried to apply the patch to mm-new, but it doesn't apply.
>
> % git am raw
> Applying: arm64/mm: add pte_set_huge() and pte_clear_huge()
> error: patch failed: arch/arm64/mm/mmu.c:1872
> error: arch/arm64/mm/mmu.c: patch does not apply
> Patch failed at 0001 arm64/mm: add pte_set_huge() and pte_clear_huge()
> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
>
> % patch -p1 < raw
> patching file 'arch/arm64/include/asm/pgtable.h'
> patching file 'arch/arm64/mm/mmu.c'
> 1 out of 1 hunks failed--saving rejects to 'arch/arm64/mm/mmu.c.rej'
>
>
> [...]
>
> > +void pte_set_huge(pte_t *ptep, unsigned long addr, phys_addr_t phys,
> > +                 pgprot_t prot, unsigned long size)
> > +{
> > +       unsigned long pfn =3D __phys_to_pfn(phys);
> > +       pte_t new_pte =3D pte_mkcont(pfn_pte(pfn, prot));
>
> Maybe we can drop the `new_` prefix.
>

Will do.

> > +       unsigned int nr =3D size >> PAGE_SHIFT;
> > +
> > +       VM_WARN_ON(!IS_ALIGNED(pfn, CONT_PTES));
> > +       VM_WARN_ON(!IS_ALIGNED(size, CONT_PTE_SIZE));
>
> Do we also need to check that `addr` is aligned?
>

Yes. arch_vmap_pte_range_map_size() already guarantees all three,
since we are already checking two of them here, we should complete the
set. I'll add it in v9.

Thanks,
Wen

