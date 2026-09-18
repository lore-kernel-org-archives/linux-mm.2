Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A8CC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD056B008C; Fri, 18 Sep 2026 04:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E186B0095; Fri, 18 Sep 2026 04:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0458E6B0096; Fri, 18 Sep 2026 04:37:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D408F6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:37:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4CB0A5FDD
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:37:48 +0000 (UTC)
X-FDA: 85226229816.10.1FA1C85
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf22.hostedemail.com (Postfix) with ESMTP id DCF39C0004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:37:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MO1niSdK;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789720666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0yQ4rBAEiKMEofLz40Ao8DmOY1a2/mbTmLdfwCpmzU=;
	b=RY89ogBUDWho99W1xsuMO7go1Ei2pdw0k4UESfQFh2QNWNZhk5Vy5Ze92p46BRwOzRRyL1
	Nw1MIisVakt1g5JlRD0HT+Af4lu5QTKUNaDc0y5crDWMlE6RdA236tLrEn6MGDLvtYYK2K
	cUuj3Vwjm+fonz0XyIus/FdzT15ntTU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789720666;
	b=jFtGyu9jdew0XhXGVwhrw6TkXUf3dqU9HEOjkrU1abT8uNKTwZf4g4I0v1ohqnsr7P4i7s
	Yu+8XmdKwNIO2sAT7/l7WyeKxoRU94st8JVR73hV+WtgIsWuhEX3bIq8PC1AezWzmu9ofg
	onOGZOPfudQFUHRj8+JMSlsKEGcpTBg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MO1niSdK;
	spf=pass (imf22.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6351831so212004f8f.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:37:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789720665; cv=none;
        d=google.com; s=arc-20260327;
        b=r1OXG5qUeLorVxZApM8LJ0IN4SoLMX69IvR8mbR08AT4+Zr8qQjFQPlFc+iEB8pozl
         JyhB51O70BSgXtRMF8L/KDJ6wXOuQh6WfFGCzdnc5eqAEb+Y6lrZ06RcdxBvkN7k18No
         pBKUGRNyMQWXYc/GAZ2X32Vgjfgbq5oDSgnAS4GE+IfP/n6wmuBRKDENVcQgDlEqJoFk
         leFwHiQwHzhdU49+AAs9V9ggDQL6GjExCLMLHh83MAz96TakMpLoSTnAqfmtfT++8ftn
         0sZ3E/OXwHdnaze069pBc5PFxuGVHDq4zUkVKYFERL3dr8q9MkQiInlDOpR51SmD2rpW
         2WAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m0yQ4rBAEiKMEofLz40Ao8DmOY1a2/mbTmLdfwCpmzU=;
        fh=LulHVN05QOIOMREG4amRELKs3RehZB5TWJhR/lu+URQ=;
        b=g8hzOiWae09uJgoZgDSIVT/VBYnRMD0KZWugEa7gICnFvlZkHnconyLLTHaeNiFL1t
         YEKhowhz8tvKs+X2hqf5aLMFmNUv9I/E7vfl6AaLdKj2QIpPpetfT9o27DUEi+f8roKa
         vYdloJupkYEjh2VLeWV0IZ7lg4KNUdrdGkXryiOin2l1B0gmpwvcAwMBoIyegTOku2X6
         /RWjpITjFV2XvcvlFcPPjWSF/qnd0n+pW59lN4iJQMhMbuUsn1y0ozqVA4cVPLUh0BAd
         3VN8QPSzJbAfmCCh5Ymv7idEqToevOp14gB/VsO8YMxl0V2n6sQK+QIvf7pw0NzJS2QT
         7dIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789720665; x=1790325465; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m0yQ4rBAEiKMEofLz40Ao8DmOY1a2/mbTmLdfwCpmzU=;
        b=MO1niSdK1tW6f3iNsJQ2wRUmGuYK/ncWODuvu99yfgKZ4fEjioQhEY8spca0njwsNZ
         mTB3IQWPyLRWAigaFREavqEPo2ZotHMCkCm894FP+xY8TuBrIQVoZciIuc71Wb/x1NgZ
         3gxJkfiUToCpE4NeaM8ByiHendy1SDrEv1BCNybjSg83H2/B8/adlDAWJ1ibta2xB+gL
         8OnlV6sP6QOgJqTcVD6S2NOuY8Hy32FNjor+1SYTtezEiGBCj+6dVaLpgF2ogg6iB315
         3XcX2oD2qRQYlo9GdcAs8dDv/uAWThM4C07bAN7vU+k1H2QXcULOQjTcSmHLcw8+O82a
         x4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789720665; x=1790325465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m0yQ4rBAEiKMEofLz40Ao8DmOY1a2/mbTmLdfwCpmzU=;
        b=VX401/Aynvb7orhpjwuBmLFj70OfGpr2dZJ1g8MRDBOSZzhNMRKnCKMUAGtOnnfEG9
         chL2WwynaINORcPE26RpptWlLnoM25VgvpgrjnDRkbW1p3nilEn4bDQQsWt6OYV1rmvS
         QurC0/lLRylBHicjU8pgNR35TBBXkXWTem6HOhlPlMCCRDyj64yK+LW7XhHbPIn0IAOq
         rbqLqnWgBmq5ugI/k//22r6M3afj3Jc9D9MEqA/pDxoknT7L0yqV5CuRU+RuF6PnOdxJ
         E/PXZKQEVCj20OKjI6LhWceffneFnOPGpmN0noTdYijQQ4xup/d2q8t/mpXJgSveVhzA
         uqJg==
X-Forwarded-Encrypted: i=1; AKwUvBxLBzv4f54EMlabBoHRZUpuHthmsoVXjbZB8h/KbmAAOw70s594w+0SIikpIyNEego01qu/rxabug==@kvack.org
X-Gm-Message-State: AFuF++mv7AfkUG2DvP6MlUIkUIjTE4uQ0v35m5dENWRSxiYmRIUSWTBN
	Wl6N9n2a2oPWOzpJRA4XpNNxWOojllFX7mj6qOuE40ngyHMzHDiRItgmxjcD0wnv1rK3kJuT2Bu
	gKxl/Z2QyAPiDCtMon6dbOGsZ+dff2E0=
X-Gm-Gg: AYBFou0rrWYvFZ0JpZtkYwkVw6X8axGS3IwGi+RB97CknaMqb2IyuJMraHdYajoCjY4
	fB4yC4p+A1dg4ONwrvZiBHBlU/Tes9xN+q6v55zeQsMhHlc/rZSs8lw/RG19CArwmlBWrzdGqvl
	baXMjoqUpZhpftPGn6BU35QP6XrflKj2XWizEBzJ2rHxTOP8LMDpmchjMdfSrvyXuaj2axn4zJL
	IPvIzySTCB4f8mhoQf1IbK2cBT7cOvUecMOsEDN9rmeImKGGWTUCX+FLe8+iLYbnxg4dACd3TLl
	J7AgUvEPj39QGEjv10qu3jPgMSlrBId3J7N0hmjg1TVvdGc3NxgSNLk1
X-Received: by 2002:a5d:5f4f:0:b0:486:f4ae:72a2 with SMTP id
 ffacd0b85a97d-4871e2131a7mr2297716f8f.1.1789720665326; Fri, 18 Sep 2026
 01:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com> <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
 <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
 <CAGsJ_4yJ-KCHbJ9S2GKXfO51KB8g-y2Q_MikqE9-6VesR-RC9Q@mail.gmail.com>
 <2462f67c-f7d3-4eb3-a093-6a338ef49f14@kernel.org> <CAGsJ_4zMG6v-ioi8-NhveqowPVAnsHkFCNy_c7+KHDMRW3JH-Q@mail.gmail.com>
 <24aedc8c-a5c6-418b-a37e-051f0d6d9fa7@kernel.org>
In-Reply-To: <24aedc8c-a5c6-418b-a37e-051f0d6d9fa7@kernel.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Fri, 18 Sep 2026 16:37:34 +0800
X-Gm-Features: AcwNN1XBh3Wey2x3l7KbPhov9h79lwYf3qMIq1ZNnS7cqxD6HqWXu6Gr_vbTLnA
Message-ID: <CAHKocdEmb-Hsxu8FCxvzhz3XdzmrPddGo4wv6GqjeHvAYfxVrQ@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	linux-mm@kvack.org, urezki@gmail.com, will@kernel.org, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCF39C0004
X-Stat-Signature: xqhwgbxskpr13w5t4ku3s65uascqxce7
X-Rspam-User: 
X-HE-Tag: 1789720666-757741
X-HE-Meta: U2FsdGVkX1/Dy3S4O2xcuFshwYBESPv4m3v4fpJrJDubYK8J8D9XFxdT3lOqEJb/C7VOuZqcibWs4h+rM6KL1DE3S/tH8oLQj+5bAUfOimXNu53iQB6996YvPKYVEpTIgh492ilS019W8ExTjM7Imils25/tpXPSVV+ckALVqKaX8VnhVrM2opBFoEsdQfVwGhjGE3NsrOd32EZ5sYVwyQNgYw2rln1cphP8/KDJPKefJ18cLW9y9bE0a6YiLe+GjqdCcEgVpNhj1I73goGK9NKjAAOLlZmSoou6JA748zKqLJR/a2XiByK94+NnL3gs5WcYr57zjkw+/Jgr0RKBtdnJoYpFIvVvyjx1LlK3XsKh3GxQ7e4KqKQmGXf2n8RtalcnOsXuC8UuNHD1cfF/00dQSb+dJPmcTzTXoHSh2gVbpU/O0avXDM7LviHJSNlocHwzl9uOXqiZbVUe8i3/gtqbVw1HjFaTMFw5LR0caIlmiyOJsuzc8w7zI4GjBESE/7RtKzt7XY8NpTXVA/Rt6voDP6ITxCTuw8Ay3BOlTlvq3WXZtIa6+cZ3S1M5SCW5pOqBZISyFMymp5xDoWYgIAY3C0Yzco/G5z7Hk7CrI3B50vv5wY+FFlYpWd5TVlsqaLnE5JHjT+SrLxzpQ1wwVltfN3CnC7VxP+UOz5vn22i2cTmZuaCnEQtfFG3AdUPJa7jwIVx0WJFhhRWvtrdPsh+WM7kGcGY32QwzRBmQg4DQknYVKkalBRxlTS1qvx7M20UDcF6zOddOH9yI4ktUWDfnQL1t0c5ajrcWUxbfOLL0QLTUHxv5hAJjYDuq2RcX69SywiU5vebqUKiU4Z5g5rtFoyd8jdzOUe8nNsG/vp6nXrsOKzbJy5d1CmSg2WPR3i2tLpzuDsfZBVcM5jDadmrEi/hVHUO5FCuB3otfG6TiixGeQDmHsNU2qZ72ryg/+N/LpV9MwgWXlnEv45T
 AQRmSrIS
 gizlr9OPjmJqnW+LWgdsUtPjTW9yuZZOKX0S9oDUkitOWUMfuYQzP7AtApVq1nBBFi50Qbeksh1TyV7DZnK5ZUaaj+5WgXS2sUJqjPuuoJ4hTGwahOKlwq1BnlyHuod8rlipdH4p1z/oMUv1JLw54+QnhJMihhP7wO/fC19gk5Lvcz8ryW3Z+DibSCKcURFtA3xBBsA57sfICyCbSs+098Y/EiJZMzravpcKkyBFMJZ4J/oS19eRdQkLwiQqafvsELladYPh0W+x0bO4fK7hN/mH1z9nPX/2eHCzx7JkdMPGbGIcwMEZWyjX5Ll+HLXacOLcPFU9NmriF8ENjDTprjb6GYmRL7SibDXFDo9jH7jeROY4+T9S2s68SPw6z3w31orn47EbfAlelyAV3pOteg4wQSc2NPxnih20mFLEQMT0KXO26TAQIPPyQxDzDoCqyiu/k2EWiZfdGZO/tmLLc9KeVWqmhcicvf6SSlY+GZO5rtulrkpDtSPizk0TdUTYB6nS0gHCGsVshbnQRjHzlzsTOP7m6AzZog/WrGq7DavlQgO7DeckuTB0knowyc/NnnsaJaps04yltuP21FdmHcY3pXTpUNPN95AMqW8yYiKrCHAbJDfWQ9xVFa6I5FhdYM1prPd1xCP+8koEW9KlJkLsRl1HHgcQy6Kugizzb46JL32K+MekYeeF4lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sept 2026 at 15:04, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
>
>
> Le 18/09/2026 =C3=A0 08:14, Barry Song a =C3=A9crit :
> > On Fri, Sep 18, 2026 at 2:05=E2=80=AFPM Christophe Leroy (CS GROUP)
> > <chleroy@kernel.org> wrote:
> >>
> >>
> >>
> >> Le 17/09/2026 =C3=A0 23:44, Barry Song a =C3=A9crit :
> >>> On Thu, Sep 17, 2026 at 10:41=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gm=
ail.com> wrote:
> > [...]
> >
> >>>>>>
> >>>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >>>>>> index cdd68ed3ae1a9..349ced999f959 100644
> >>>>>> --- a/include/linux/pgtable.h
> >>>>>> +++ b/include/linux/pgtable.h
> >>>>>> @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *=
pmd, unsigned long addr)
> >>>>>>     }
> >>>>>>     #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
> >>>>>>
> >>>>>> +/*
> >>>>>> + * PTE-level block mappings for vmap.
> >>>>>> + *
> >>>>>> + * pte_set_huge() only has to be implemented by architectures who=
se
> >>>>>> + * arch_vmap_pte_range_map_size() can return a size other than PA=
GE_SIZE.
> >>>>>> + */
> >>>>>> +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> >>>>>> +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> >>>>>> +                             phys_addr_t phys, pgprot_t prot,
> >>>>>> +                             unsigned long size)
> >>>>>> +{
> >>>>>> +     WARN_ON_ONCE(1);
> >>>>>
> >>>>> BUILD_BUG_ON() would be better here.
> >>>>>
> >>>>> It should be possible because fallback arch_vmap_pte_range_map_size=
()
> >>>>> will constant-fold PAGE_SIZE so pte_set_huge() will never be called=
.
> >>>>>
> >>>>
> >>>> Agreed. These fallbacks exist only to keep the build working on
> >>>> architectures with PTE-level block mappings and should never actuall=
y
> >>>> be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.
> >>>>
> >>>
> >>> I am not quite sure. It won't be called at runtime because
> >>> `vmap size`/`unmap size` return `PAGE_SIZE`, so the code won't
> >>> reach this branch. But it will still be built.
> >>
> >> The fallbacks are defined as:
> >>
> >> #ifndef arch_vmap_pte_range_map_size
> >> static inline unsigned long arch_vmap_pte_range_map_size(unsigned long
> >> addr, unsigned long end,
> >>                                                           u64 pfn, uns=
igned int max_page_shift)
> >> {
> >>          return PAGE_SIZE;
> >> }
> >> #endif
> >>
> >> #ifndef arch_vmap_pte_range_unmap_size
> >> static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned lo=
ng
> >> addr,
> >>                                                             pte_t *pte=
p)
> >> {
> >>          return PAGE_SIZE;
> >> }
> >> #endif
> >>
> >> Therefore in:
> >>
> >>                   size =3D arch_vmap_pte_range_unmap_size(addr, pte);
> >>                   if (size !=3D PAGE_SIZE) {
> >>
> >> GCC knows 'size' is const and its value is PAGE_SIZE, so it won't emit
> >> the branch at all.
> >>
> >> It is call constant folding, some explanation here:
> >> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fen=
.wikipedia.org%2Fwiki%2FConstant_folding&data=3D05%7C02%7Cchristophe.leroy%=
40csgroup.eu%7C869dac21f28d45988a3d08df154c225a%7C8b87af7d86474dc78df45f69a=
2011bb5%7C0%7C0%7C639253088878897551%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcG=
kiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D=
%3D%7C0%7C%7C%7C&sdata=3DDvtz1%2FAHvAbVYO%2BRaHTOizcD%2FclJ9FqTcWXKMhIFVyw%=
3D&reserved=3D0
> >>
> >>>
> >>> So, would a `BUILD_BUG_ON()` trigger a build failure here?
> >>
> >> It shouldn't, if it does it is a compiled bug or this is because someo=
ne
> >> has redefined arch_vmap_pte_range_map_size() and not pte_set_huge()
> >> which we'd better know at build time rather than at runtime.
> >
> > Thanks, Christophe. I was also thinking about compiler optimization. I
> > was just a bit worried that we're touching the common MM code, which
> > affects almost all architectures, so I'm not quite sure whether this is
> > supported by all GCC versions used by those architectures.
> >
> > If it is supported by all of them, I agree that `BUILD_BUG_ON()` is a
> > perfect approach.
>
> AFAIU this is the assumption made by the kernel, see
> https://docs.kernel.org/process/coding-style.html#conditional-compilation
>
> This is the same compiler, I see no reason why ability to constant-fold
> would be dependant on architecture.
>
> Christophe

Hi Barry and Christophe,

pgtable.h already does this in a few places, the !THP fallback of
pmdp_clear_flush_young() is just BUILD_BUG(), and its caller in mm/rmap.c,
a file that is built unconditionally, is guarded by
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) rather than #ifdef. So on every
THP=3Dn build, on every architecture, that call has to be eliminated by
the compiler or the build breaks.

I built it with BUILD_BUG() on x86_64, arm64 and powerpc (8xx) to be sure,
and all three are clean.

It will be BUILD_BUG() rather than BUILD_BUG_ON(1): BUILD_BUG_ON() expects =
a
condition the compiler should know is false, while BUILD_BUG() is documente=
d
as the way to flag code that is expected to be eliminated at build time.

Thanks,
Wen

