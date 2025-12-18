Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4153AD6ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8E76B0088; Thu, 18 Dec 2025 07:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53476B0089; Thu, 18 Dec 2025 07:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980056B008A; Thu, 18 Dec 2025 07:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0826B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:09:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DC071A0E8B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:09:11 +0000 (UTC)
X-FDA: 84232471302.26.7B4BA8C
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40FA91A0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:09:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxCYuDBP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766059749; a=rsa-sha256;
	cv=none;
	b=nPBSxFNweiCljnKzp0CyZzLK/gwrgvptGlbBbGlLzkfBdu0VrHMC0qN6rLB4F4c0BGENEf
	Xd9jchBG+OEGgrucOO/Blip6z5qXn5mGkUfB7mS6soOfN//O4cH0HDd53DLf9XRL5O1KbZ
	zr/gkStKhO9RuZrC0DNImnie6pvOp2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YxCYuDBP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766059749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHE1DktcfgTgvIuicioIyZLgtx7X0c5eJ01RjbYGdSI=;
	b=Gq3Fav6MqnuTvDNU/+QxD8urWJ+fwMVWJr163S4BYtLHDm3HR/IEIK7f5IPQ9THNTH839s
	tdWEB8ic5KamAmY3BUM+1s7UBY4dpIggd95e28X4fmMgnZtz9FqZP/QRzA+e3bDpW58vhQ
	aj2e16Oc3vR/T3MiJ7iwEQkIgxnB5ik=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-ba599137cf8so193370a12.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766059748; x=1766664548; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHE1DktcfgTgvIuicioIyZLgtx7X0c5eJ01RjbYGdSI=;
        b=YxCYuDBPnlu90QoDDFr42Z5hUDpU2spNmYcs/YnkkrmafC/qQi4a0cWalnyepe61dK
         G/FuUd/UFnHWWJIwd+4kOB2cxzv1y2ylm19k1crB3egdGr40Vzzw29qdvnL+GjMO1dQB
         GcvU6/0eMcQ8cEBkzw01H1AmXDIiSDJArU/FBx44SypgCfdIdrM13EOfh3mUOa2dBNHJ
         gDgkig4ZMPueHP1PDY0W8b4CsCROED30pbGppFn3/szWq7klgUNJ/Xf4HxCrs2UJBLI0
         b40Oy6zFO7h9Ia6dGRuLbIPst7RHMBRfNVxfGHamy7iMDVpXW1aZ/FzRq6QDsC3hfKJR
         l1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766059748; x=1766664548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SHE1DktcfgTgvIuicioIyZLgtx7X0c5eJ01RjbYGdSI=;
        b=aiT7i6RA+rScLwEOcDIzmwtzigB3U2NHy8P2Ms8DhMMDBJxG9ncgWcQsv/px4vPhbj
         WIKNs0aZdZ43sdW+7KKD/zV5O2KbSAmA8gG3hQciBIaWAOT8KtS41sDXATPhhRUqbzyx
         XUXQtIA8keW+0XCZ7aVU2xCD+vha9fnDeGNmlpSeujbEfqk8VVlsqC0UEoN5TW1a6ROT
         CMbKZTWTyiUDB6+NbFQPFSgcLVzzteuGx6opYr+6QLEjAKjlzah3S0idpl9HwFL90WJq
         QeWnpeH9krv1GHoOdE572UVuLVBJ08pYNsSboNS7z0TA9f4a5zv1/nk+GIgOsdom/xiH
         JwyA==
X-Forwarded-Encrypted: i=1; AJvYcCVYV/EC4aVq78T9aGlSf6wCKPqJ0JFahdCRSsj1minWM2d5ibywpmJB45VXHown2mRt0gi4ygILzA==@kvack.org
X-Gm-Message-State: AOJu0YzknBYByIHSNvXsipVPPk69ubt21hvV6F7T9VJmJKxQ1gG/ir25
	t7/0dyNuemid8DvMkzzWhe7At9rH+zTFQwBc5UOvAVs/ceDhAkEsofbC1ohSipPlwKCdqz5WTuk
	Dp5tol26wKvrimJF1YeOtzYl59jZVsA0=
X-Gm-Gg: AY/fxX6xU4NtedEPxmNOI5ZN5zh/bINhMPZrRO2BMneqWrEvc9oLUO5HOXxtQH7TrKI
	h6+OUggDYFncYEIPP3ruefBc797+LNyZ21WnHGDk9H0GzOepsScSBw1CCHNWOtUTKDRxpZLtEuu
	+3n1maz2RCngX5FrQRiCQqCLHVvrLqfzQNLxC97xP2sUkQJQhGE+ayw2rOBBh4b5E2ukvaM9hml
	kWL5UE9wYANIdx06TPvnAWjYb5r4epMghk2hhNsoJW05GNyKd2KgDv7hRLWJtmIjUJ1og==
X-Google-Smtp-Source: AGHT+IFTTfUO30yzA2Dx4USbhYHMj0svTb/BVY1U9NRWjNhoq9m1ZU+yXheFUq02TDUzG8NzUgZV9kxNT8DNGyPr9UQ=
X-Received: by 2002:a17:90b:17cf:b0:34b:75f4:96d3 with SMTP id
 98e67ed59e1d1-34e71d80c4bmr2064722a91.5.1766059747972; Thu, 18 Dec 2025
 04:09:07 -0800 (PST)
MIME-Version: 1.0
References: <20251217120858.18713-1-pilgrimtao@gmail.com> <d373f7b0-f822-4c31-990c-41a6cdc76db3@kernel.org>
 <CAAWJmAYJdEJyybVgD7erzZgvwufZ8gSmP_FCohmZLYozbhbb3g@mail.gmail.com> <d2aa6eb6-cf67-4b89-a9d4-306c720fad55@kernel.org>
In-Reply-To: <d2aa6eb6-cf67-4b89-a9d4-306c720fad55@kernel.org>
From: Tao pilgrim <pilgrimtao@gmail.com>
Date: Thu, 18 Dec 2025 20:08:56 +0800
X-Gm-Features: AQt7F2pkmTsUiJV8lIIJaZ0vsj6lH6G4x65cGL3iKhJH2kP5ETESDd5-2fe-D1M
Message-ID: <CAAWJmAYfaic8Nj+_Zj0W9LToRBkA+77zqDTPf9iguf7B36L6qQ@mail.gmail.com>
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 40FA91A0003
X-Rspamd-Server: rspam10
X-Stat-Signature: 1w61i1t7fhrbn9hrskc4pe8oaymgqcky
X-HE-Tag: 1766059749-203487
X-HE-Meta: U2FsdGVkX1/Dys3lAc+vV55J3GPMdZ1Ckc0WDysnwkz8wNoPMhr+1uV9Ay3muhuPKGwRvrI9mcJ7hANueMgLKEbbpDdDQLusUd8h1bu/uSkVArpmly5qNRmJQ5O5Yfve2KuQp1r745bch9QrTptSTud6flBf3AUho5KoWYl2lz0QeIYTvlP9kwvngyUAEh+zwSXSA/Jbd0OS1vHIKv1F8Xwq4NiQWQ5CkkIk1GPdRh41KR8aBqhc5mb7BFwgkQjYktFUA/PTiFJBL75Pdm4k8aIcgW86wq7k0m2glSC5s6L1XNz0IlYtasgjwKqx+WA0H5uagnmlYxG5NT0FbvhTSctQKgQt2GB09GhxQi3uEqpmFddwB08pQYPzx61Sm28hbcT7R5ixjELvqzU8CPFRDcnlBBDKnRjvUlnW6UJbhqNfLQ60OPvU2B2ycxJbIxJtHGCBE0k2oCU6iRu7GfIrMKmvrBT8nxZzqNk0zUy0Ymz8ZjoB4sROtCwaKW0HTr01mEY0bYwv3wT3c0PVvsN8Zk8j7y+al1X7qgrGJXp95v7PWpST3eMMqGh9LrOk+22yGuXbQuMhxRzKQqmppCoGLWt7w/kmP1ZEAGDX8rWK1TlZexsUZEMEJ16V5XnRTMFu3cK3o0yE9Dv+RJC+I8YbPBGM4J15m9txIuJFpr0L7kjyMpCiIiDpfCTthBe7BbsPjdj4zspvmTVoTyxaDWv91/YtLlZhsWhEKEuoNReEEpMS2H8ekWfKMRtgz1Z6zaQxjC/euBlftVBW9uwX1iHOSLLx8dAJBewROCqHVyCyysPQmMB9JbwC3ux10mWB968M2dMz3InK4iGTfvxs0vX9UT026l21RE45qDUxaEKMQ+yyLtNBsUscrLxU37DxeHFnFb0pGNdMWMe6ahnUHR3EjA7a7eWOASNGrsAcP8HJgWrZ3/FQVum4LyZr9pChCszAhy11f1hFLitSuDdOkg7
 H7MRDwHR
 ZTiceOXeuH/9LnIBXoWGbNxBitFED/xeF0MrUgJdQirRm9mLtVvH4TE1L8GXTC9DsUZvimAf7pvsUYAtdhF+9HorJ+af7fXcz30+1P75wxuCx/8Nn0OOEXm30S5aCxxTQ3LH71L5t1B/q22ML8YPAGASmIP9x1dif8kQfH659p/0AbcOcodvdX/ZCd+G5BpJnbBZ+vCjX18mvrdm8YEDTYYswxpFNR93XJKIetKK7g908sItyHkZOxRv+1T/pIF3TkDnSv4vUx9qQzmnDVkLOA7RSPmO08cvcmhNOUdOJ0njiV7G1REguhJ0YCdp/Dq5ZkSot+idYP7DciCma63UMiBaCHIjtEfDJYOdfPC6A25IMtpjeRdbN32/lW1mNEwPkNvsp2OWQkyr+lfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 7:49=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/18/25 12:02, Tao pilgrim wrote:
> > On Thu, Dec 18, 2025 at 4:44=E2=80=AFPM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> >>
> >> On 12/17/25 13:08, chengkaitao wrote:
> >>> From: Chengkaitao <chengkaitao@kylinos.cn>
>
> ^ this is the author
>
> And you reply from a completely different address with a completely
> different name.
>
> To whom am I talking here? The patch author?

Yes, I'm the author. Due to company security policies, I have to
use two different email addresses, which I have no choice...

> [...]
>
> >> Bunch of unrelated changes that should not go in here.
> >
> > This indeed contains some unrelated code changes and removal of
> > extra whitespace. These could be split into a separate patch,
> > but the new patch might be somewhat redundant, lol. If you'd
> > like me to proceed this way, please reply confirming.
>
> We usually don't do random other stuff as part of one patch. It's a
> different story if you touch the surrounding code, but that doesn't look
> like that here?
>
> >
> >>> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
> >>>    EXPORT_SYMBOL(_PAGE_CACHE);
> >>>
> >>>    #ifdef CONFIG_SPARSEMEM_VMEMMAP
> >>> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long v=
end,
> >>> -                            int node, struct vmem_altmap *altmap)
> >>> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> >>> +                            unsigned long addr, unsigned long next)
> >>>    {
> >>>        unsigned long pte_base;
> >>>
> >>> @@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long =
vstart, unsigned long vend,
> >>>
> >>>        pte_base |=3D _PAGE_PMD_HUGE;
> >>>
> >>> -     vstart =3D vstart & PMD_MASK;
> >>> -     vend =3D ALIGN(vend, PMD_SIZE);
> >>> -     for (; vstart < vend; vstart +=3D PMD_SIZE) {
> >>> -             pgd_t *pgd =3D vmemmap_pgd_populate(vstart, node);
> >>> -             unsigned long pte;
> >>> -             p4d_t *p4d;
> >>> -             pud_t *pud;
> >>> -             pmd_t *pmd;
> >>> -
> >>> -             if (!pgd)
> >>> -                     return -ENOMEM;
> >>> -
> >>> -             p4d =3D vmemmap_p4d_populate(pgd, vstart, node);
> >>> -             if (!p4d)
> >>> -                     return -ENOMEM;
> >>> -
> >>> -             pud =3D vmemmap_pud_populate(p4d, vstart, node);
> >>> -             if (!pud)
> >>> -                     return -ENOMEM;
> >>> -
> >>> -             pmd =3D pmd_offset(pud, vstart);
> >>> -             pte =3D pmd_val(*pmd);
> >>> -             if (!(pte & _PAGE_VALID)) {
> >>> -                     void *block =3D vmemmap_alloc_block(PMD_SIZE, n=
ode);
> >>> +     pmd_val(*pmd) =3D pte_base | __pa(p);
> >>> +}
> >>>
> >>> -                     if (!block)
> >>> -                             return -ENOMEM;
> >>> +bool __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> >>> +{
> >>> +     return true;
> >>> +}
> >>>
> >>> -                     pmd_val(*pmd) =3D pte_base | __pa(block);
> >>> -             }
> >>> -     }
> >>> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> >>> +                             unsigned long addr, unsigned long next)
> >>> +{
> >>> +     vmemmap_verify((pte_t *)pmdp, node, addr, next);
> >>> +     return 1;
> >>> +}
> >>>
> >>> -     return 0;
> >>> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long v=
end,
> >>> +                            int node, struct vmem_altmap *altmap)
> >>> +{
> >>> +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
> >>>    }
> >>>    #endif /* CONFIG_SPARSEMEM_VMEMMAP */
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 15076261d0c2..5e005b0f947d 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long siz=
e, int node,
> >>>    void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
> >>>    void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> >>>                     unsigned long addr, unsigned long next);
> >>> +bool vmemmap_false_pmd(pmd_t *pmd, int node);
> >>>    int vmemmap_check_pmd(pmd_t *pmd, int node,
> >>>                      unsigned long addr, unsigned long next);
> >>>    int vmemmap_populate_basepages(unsigned long start, unsigned long =
end,
> >>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> >>> index 37522d6cb398..bd54b8c6f56e 100644
> >>> --- a/mm/sparse-vmemmap.c
> >>> +++ b/mm/sparse-vmemmap.c
> >>> @@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd=
, void *p, int node,
> >>>    {
> >>>    }
> >>>
> >>> +bool __weak __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> >>> +{
> >>> +     return 0;
> >>> +}
> >>> +
> >>
> >> Reading that function I have absolutely no clue what this is supposed =
to
> >> do. :)
> >>
> >> Also, why are you passing pmd+node when sparc ignores them completely
> >> and statically returns "true" ?
> >
> > The pmd+node is indeed unnecessary. My original intention was
> > to provide convenience for future architecture extensions, but
> > upon reflection, this appears to be a case of over-engineering.
>
> Jup.
>
> >
> >> If you can tell me what the semantics of that function should be, mayb=
e
> >> we can come up with a more descriptive name.
> >
> > In the SPARC architecture, the original vmemmap_populate
> > function does not retry with vmemmap_populate_basepages
> > after vmemmap_alloc_block fails. I suspect SPARC doesn't
> > support basepages, which is why we need to modify
> > vmemmap_populate_hugepages to provide an interface that
> > skips basepages handling.
>
> So, something like vmemmap_pte_fallback_allowed() ?

LGTM=EF=BC=81

--=20
Yours,
Kaitao Cheng

