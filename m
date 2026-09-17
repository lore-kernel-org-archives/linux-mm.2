Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E0BC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32FA6B0096; Thu, 17 Sep 2026 10:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3646B0098; Thu, 17 Sep 2026 10:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB0A6B009E; Thu, 17 Sep 2026 10:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2136B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:41:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F8561A038F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:41:00 +0000 (UTC)
X-FDA: 85223516280.19.ED45D9D
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B4CC20008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:40:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="c/+sDP3A";
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789656058;
	b=2dLFmLXVdf8soGaYeJldbYdcAHi3mQL4zBvN1Fq1KV6cOm7uf0rMxrbKuOBLGDgYe3YDGG
	CThnWZ5YN950ZV1Mb5DhoOR0x0IE+yAN21rqwcKEYFH//Xv85S/xChmI/9VKcEo5Hwx8Be
	EU95dNJ2hu3uPsKRhM849VQpkrge0hc=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="c/+sDP3A";
	spf=pass (imf31.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789656058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKlGaZ7QcAexG2kTHUATEVY4bTePWKI9i02YcMMarMU=;
	b=5lKk7EzoLS6iBmZl5DH9J1k45pDL4p8l3di8EueqwY9a67UiMk6iohyrA/XAYDLmgXcASQ
	Yrd+NYhUEAoXP88T3S3vDMX864dBPGwhhV7vemNyOK5D6LGwUQpLpO2WdMJB8ShQsqyOs1
	3sqZnh3KyCcGAHvwBdTckKEb+kkRG4w=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cc9f581c4so3547375e9.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 07:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789656057; cv=none;
        d=google.com; s=arc-20260327;
        b=CIF+PuHjIYELSGqK9bBesnbcBt8gCCpOKCRg4MTVCWAJCcb7LE4ixiuivu8e3Y0ZWm
         2MlOKdhHNq8LrwABbX8kq5Jgejx0plyexhlt5ZZ0Yf1aFfEGnIxFsh3Ow/G055zZ23hF
         sWGBTsOBuRCJDSLnPfW147Sg7Mvc4FXrhK1VTuCI2bqKecloHcBNXjaWAEtfUSa76nuU
         vWRuq+tWUZ4h710jJ4tFO8FA1vGB+q5seWe30oyiVfbeUY6EolIGc2CghOZdRzWJstxV
         GVXBPEMD384Bjcp44MaPtgUJEHC73MYBKmwIeEHQ99gNE9xmreg2Yc5uxnlo41pOZ2FL
         zyQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tKlGaZ7QcAexG2kTHUATEVY4bTePWKI9i02YcMMarMU=;
        fh=pEuigrYqCFezVkF2mHoddh9x9wVuR5Xd+5rIovFNbN0=;
        b=WwmcZLs1p30JkSdLNoBMpaw0o25yQfSJwY/sRKZRQpB5zP9Uu05pjsvyuUN7Yn8TRu
         z6sQgpHq7naV63+7spnF8imwjNhj6dteHWMD4oUirDUwHOArHvEzuBgX/V2r7+6yeK3Z
         ue1a0nLTRI2XHDaMaz+BxIIu8uphIyCcp+cqVrqyKCpHJSjLI5tzgEGcaN0EqDf9cK7F
         ierEteY2gZw/KJvu7I3ZqkcXv07TJHsBs/WnnIoVjswbfJt8e4CPl9cmVclmSmRqarnZ
         4YF9aiCmDHyIwj2kGtc7ydyPZdWdLH2+rKx89rYW4cfsSNPznGV/s+N8ZWmOfQkSNFp5
         aymQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789656057; x=1790260857; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tKlGaZ7QcAexG2kTHUATEVY4bTePWKI9i02YcMMarMU=;
        b=c/+sDP3AYd3uCKYLRg6Jwn/SGwohzNwDx48uj6bD+LVQ67QowM3aXphiWhBfAKxDuG
         WqxMzcc4/bL/+ekJ5jgbVTjlwpcQAdkG2JBR29vI5pHChqS6H7l6AAdL8quXaHMtwEEk
         1x/ZFHyHqF2zJL8yKb2WTTv1FKVwaglnnCbGX/Qzn20x+tcCRwCmEMH3V3bmtQekG1bZ
         XIyKhfoMIdJmYQJd839tMAr/aJLbBmu1bQK8jYrWcc+jaJre3uBQvLE02jXySnbJq+l/
         XRRrNR84KHTOPSfdtv5TGDB3+NAoy5jXvB9joyGGdJMB62K4g7xHgh1RbnRKg5B8T9NR
         vAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789656057; x=1790260857;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tKlGaZ7QcAexG2kTHUATEVY4bTePWKI9i02YcMMarMU=;
        b=NPG+VdIZt/y5FfSC1PjDrKA2HZGfQK7laHf1JqDHLl1wZbxJyL7RYZbKrJHLQ+XNct
         Nb/XsCGpIUhuUCHIbtwE0/mriM9061xUKtJZLEdbc48e7WGtm1555q4KfXCe2As5CxbT
         PFjFqW4ky5aKYYJj7rc1s+WKN2c3kVuDqZXpwqE62C4GR50WlbEdKEzqLqizR6lyQNhz
         iUyGlwmwkTGYHKxe5MYfhoyw/niiwx6MuZPRhDu2n8SbU/FN76PTTP8N3xBwgJrAa4wi
         phEgzWBxdCRCP/Nb2ax9zcS9Fg/NnYc6E+mrJmKyFyB7PUsITrj58yGoKU/ITojZ/A/S
         mRcQ==
X-Forwarded-Encrypted: i=1; AKwUvByOL1JcDW67HBozJ4tUtiqIN60KAhvdPMYtyoMXDh7SNLSOi54nkTSLiYszUH7QU9dzC+tn9bpVxA==@kvack.org
X-Gm-Message-State: AFuF++n8vl0ajRySnbHti4/QEmagz9oCswvNv4FIao9IAj0A9q8iYru9
	n1j2UWsxZL3yHsmaa6LYSN1KkkkwSaPKJzF2vYnigxPaVxNTXkCOwkfZkvEulaB9Pvj/SMj7ZE1
	+L5199VUCIBz1YXFUu9OOY2CC0l7sN4E=
X-Gm-Gg: AYBFou3uLkHPfeHUXw/yYSEj9znCLP+sX48RkF3eoTuzVjy734y++dbjNknnlE6EyOo
	wg4RUai0TAwEiFbZZwVW6XAY6Jh0pE56hAu/f0a6ti/EDv5YcuAAimlz5XEuD0Fb12bbOOZj4fs
	uViyqDhU3Ue45gLMecZlKijz5cac4cAAsH6vzgvTK/nGRLxORGOY6K/a8GiwnGqDS6TNCQ7uIu+
	m+v3kncpBO1KexjE9qTTdOvJVOmNKPpKoT/ze5VTKjHhG8WtvUfTRbLaXb+PLz5yinpI6cy4O/T
	Hq9/Pq+WAmrpDBso7GlY3GZVm2KfBW+D8KOoF+5CzuG1m3jrkdHJ2Drg
X-Received: by 2002:a05:600c:c490:b0:49c:e37e:4389 with SMTP id
 5b1f17b1804b1-49fbd1b7e82mr50298125e9.4.1789656056433; Thu, 17 Sep 2026
 07:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-4-jiangwenxiaomi@gmail.com> <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
In-Reply-To: <27072d94-13bf-4bea-948a-d8a67976601e@kernel.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 17 Sep 2026 22:40:46 +0800
X-Gm-Features: AcwNN1Xe57v3xkT9n8VgdwgVRkLfN2sWNkgkjHSUvI4F8KcWXjC4skCrmqkDzZ4
Message-ID: <CAHKocdE_zyUQT459AiTBDzQHk0jh+VpXuSMDdgHjkg-dAkgBNg@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] mm/vmalloc: use pte_set_huge()/pte_clear_huge()
 for PTE-level block mappings
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B4CC20008
X-Rspam-User: 
X-Stat-Signature: rjewsoz4j3t1s3ezf4c1er8gka3mmyco
X-HE-Tag: 1789656057-347719
X-HE-Meta: U2FsdGVkX1+psfrXW02buy9pyETv15XQPW2ipWdGZag/+3cun7UBNpnhpY6DaWui2P8+nVBMtXzQhpJXw5yHlssuEjubE/GuszkLF73YSCUzmmKxyUKNVCP2oK5K4U2COsJVmgbZdv2QgKRnEXKurh3kPFo/ASYHZtQGgqeUWvtA/2avPepPnuZ6dckHKkURbQxgoSY8MqaCOrpC3yhzHrNLtqcUAVGN+G7XecIfUTnbn66gZZYG7Hqjhossfy3By6GAXOwtSg/XEfj/g3+MmsmqvnhT3TBPUTQfACuTapueKXxxTUPI29CX+MorCYGuSQdWv8i3IlUe0jITsf+xJ/lus8+dAmY9FpDmglWPaQmsMR0uGyp9fQnUaco3bYOuJHQJhbosahBEgvIvt6D8vJNmW5Dal8WVBm7dlUukpSPsE3HtscK/XWniAFLzgaqdCYGlDdVOiAZIQUCh8Z0UIFZc+fFA5sgg2wA+qYWHxnWBir+qM7B0ESXXVjtmEgIY5h3cip9oxBEGQoZJxkRPFgwiZURfJ+eFr7UJqo5CVG9fcLtCsZnPpzvdWRbTFk/rDjhbB/rVqfF0TaO609AuP8t8rjtPG6xioeOwTqeHoqk6JjtTJvwgVWJ9hUEBjLbvb0aVXMoBtralWBfeuht4TKtelYduYfycPsqT7eeFQYfjv724SBXM9EnNH54eVAk/aNVrBKR6ztiX7Ofz0opJELDbLrOjOy65rRPpz7zar6/4F7A0FEdGJR2gxQrE2RW6TVrenpmsF48slQBGzr7oWDVJYdmFY4ohqE6hbmY2UKMfpcV07/r8Qdo+3Npk7KuWabBPTNepqacldaTYoECQ6+5KxPUtmzBE+ZVXRfYw7w231jM5inHEagiVCHfG2Ar9YIRrQLVQXQ5b0u4b3l2rCWDaQZvWVj1MA3imJPIRyRcc4ChMswEMzupJ70x8X8Ih+BqlAQu/w/H1cLcKaad
 hCGJafpz
 7eA0GpxWuhbUGV3JwbErFsQo4EfnHc0MFUTg4wWNr1aKfg/+pXz2dPu40LfmRRQv7RtFE9RakucbF24QP2Ctylz8kqMR8GF/Xz/ArCRSkZEWJjQLAJSm+t5oR0xTxE+kh3NR/IzxUStN3yhE2S5JBVF5cw5FW/3y0vFNl7ZH/oYWAWUE5rn1m97/6ppD+H7Sn7/ysoxcEi8HX4ypu+JN1kCiYgvsgeRejsHlK/KRJXupKjsrYZ0bDiKie2+XBsXKEmvDZWQaqWNasR1XnIh+ZjUDNZ/ty1atAiuYK1MEIeH8s3+mJVjiIpe9l7q0bLZ68XfxBlLq7t68Fh6AnSQkB7Haeo3iYwgZ9T+sbPi54PDKMhE1Fqh4QIV3yewhZASIiag33G50GuaAX2j957iOmRH0drUHuNGnO8s0vlARKW98DySrpx1njTUpvgeWuZOZ2T20h6ojNZ4Ar3zm+fy7s8gnuT7CYhdpgZkqBHpDPv4BufAqUg0xVS+XhZ0bimvNdWPqbXgWOrWNJ+cXDTp1E16HWhJlsItGbOhE97KtUUPT3Z2G+SYQaCn5G36bfHU1y7vBS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sept 2026 at 22:00, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
>
>
>
> Le 17/09/2026 =C3=A0 07:29, Wen Jiang a =C3=A9crit :
> > From: Wen Jiang <jiangwen6@xiaomi.com>
> >
> > vmap installs PTE-level block mappings by reusing set_huge_pte_at() and
> > huge_ptep_get_and_clear() under #ifdef CONFIG_HUGETLB_PAGE. This makes
> > the feature silently unavailable on CONFIG_HUGETLB_PAGE=3Dn kernels and
> > couples mm/vmalloc.c to HugeTLB internals it does not otherwise need.
> >
> > Now that arm64 and powerpc/8xx provide pte_set_huge() and
> > pte_clear_huge(), add the generic fallbacks next to the existing
> > pmd/pud_set_huge() family and convert vmap_pte_range() and
> > vunmap_pte_range() to the new helpers. The CONFIG_HUGETLB_PAGE guards
> > around the block-mapping paths are dropped, so PTE-level block mappings
> > now also work on CONFIG_HUGETLB_PAGE=3Dn kernels, and mm/vmalloc.c no
> > longer includes <linux/hugetlb.h>.
> >
> > The fallbacks exist only to keep the build working on architectures
> > without PTE-level block mapping support. They are unreachable there:
> > the callers only run when arch_vmap_pte_range_map_size() or
> > arch_vmap_pte_range_unmap_size() return a size other than PAGE_SIZE,
> > which requires an arch implementation. WARN_ON_ONCE() makes that
> > explicit rather than silently doing nothing.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > ---
> >   include/linux/pgtable.h | 29 +++++++++++++++++++++++++++++
> >   mm/vmalloc.c            | 19 ++++++-------------
> >   2 files changed, 35 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index cdd68ed3ae1a9..349ced999f959 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -2134,6 +2134,35 @@ static inline int pmd_free_pte_page(pmd_t *pmd, =
unsigned long addr)
> >   }
> >   #endif      /* CONFIG_HAVE_ARCH_HUGE_VMAP */
> >
> > +/*
> > + * PTE-level block mappings for vmap.
> > + *
> > + * pte_set_huge() only has to be implemented by architectures whose
> > + * arch_vmap_pte_range_map_size() can return a size other than PAGE_SI=
ZE.
> > + */
> > +#ifndef __HAVE_ARCH_PTE_SET_HUGE
> > +static inline void pte_set_huge(pte_t *ptep, unsigned long addr,
> > +                             phys_addr_t phys, pgprot_t prot,
> > +                             unsigned long size)
> > +{
> > +     WARN_ON_ONCE(1);
>
> BUILD_BUG_ON() would be better here.
>
> It should be possible because fallback arch_vmap_pte_range_map_size()
> will constant-fold PAGE_SIZE so pte_set_huge() will never be called.
>

Agreed. These fallbacks exist only to keep the build working on
architectures with PTE-level block mappings and should never actually
be reached, so BUILD_BUG_ON() is right. I'll make that change in v9.

Thanks,
Wen
> > +}
> > +#endif
> > +
> > +/*
> > + * Likewise, pte_clear_huge() only has to be implemented by architectu=
res
> > + * whose arch_vmap_pte_range_unmap_size() can return a size other than
> > + * PAGE_SIZE.
> > + */
> > +#ifndef __HAVE_ARCH_PTE_CLEAR_HUGE
> > +static inline pte_t pte_clear_huge(pte_t *ptep, unsigned long addr,
> > +                                unsigned long size)
> > +{
> > +     WARN_ON_ONCE(1);
> > +     return __pte(0);
>
> Same I guess.
>
> > +}
> > +#endif
> > +
> >   #ifndef __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
> >   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >   /*

