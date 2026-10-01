Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71945CA5FA5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E326B008C; Thu,  1 Oct 2026 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DEF6B0092; Thu,  1 Oct 2026 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C7C6B0093; Thu,  1 Oct 2026 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E84D6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 03:58:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B77A160332
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:58:37 +0000 (UTC)
X-FDA: 85273305474.09.19F6784
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0C6E100007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:58:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XpEITXzU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790841515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0ryAjqgJbQ97DrgWNuEBrn7YtVDsU7C9id15LD6WBU=;
	b=jLtm8Q4a8F6ylwLqC9N5ue4nkQF+/vKtWqjkW87nnYeL5kzOOlH2WxC/Ya3z7w4xcDrOfe
	Ot1FbPQoZP7F3BREw0OzMUCTYwfmDx/FrJHSFBPSPdi2FnMZ6C/v5iBADLYL7yPDdrSNBB
	FYM1gH/znleJBcdji3EQN4Rcb8FFfZo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XpEITXzU;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790841515;
	b=KZKfvpHmnZWU09sJtyfed134CTv84haV6I8whZ8XUn+fGPhf6v7+hoDPlXtZDForsIqwoe
	aQvY640zvu0aYmUtNWi1RdS5oQM6WIQhQ6KvWEXfEEOrfnK8yww2OY/F2aGj3GPXLbzxCA
	/Yt/9m3W/NtVTR38+6UtE0JE6DNtF/I=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b059eae96so679046f8f.0
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 00:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790841514; cv=none;
        d=google.com; s=arc-20260327;
        b=IDX432m14rDNzFdmZjDTdDs8U5bm9iXW7clwJ28r+hPIq9YgIhu1RgQXtQd+vPp4h4
         qvOITikmWUSj/iWIID36cle1YAApmAlOOluybapgZkS8PLDKY0lMLmbHnNnL4ZY6rTDF
         vnKQ8VaeTyuo/w2lCNDOgwfSCPf8volo41eVM4wVRHls9F7gQ45RqhLIWRrx01tbHTjL
         FbhpvOWfNKLKL/+A5NLkubJjYR0WXmaOXjqdGbx4lYNnHIgpc2EL47cBG+nf2S3qVh+h
         0PiR2hvotsCfJRSGNoVkXoChVwo8AIbDK4HYRtkfttWD4Wa+7op9CGomSVi/+oyRjNPs
         0SLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=I0ryAjqgJbQ97DrgWNuEBrn7YtVDsU7C9id15LD6WBU=;
        fh=JogWVwoxvKG5xtPFuC0d8ohIhN5JVW8EWHMtBV46oxM=;
        b=DprnaRgV/MqiTXbPnxPVcvmyNbk31HChXEGVRM9c4z+EzqPVRKWVN+n8Ks9bc4w119
         q4GEUbrsNu3lD4YMNQGLqpMIfMW8EevVRiYG2Y4In+eHNFpdbI6KBqomD4MrY3cHxpOP
         8UaaJCPZA9wqIHAGhDzA5Ao7dAdwWPZmSh42tymSw8k6KmopnEAjGF/kYDx+t+dpByNz
         1Ksj5X6Mw5WhATNbpTY38r9aA9k7XwqNqUNJGLTg9HYi4NCoyJGhqfBYuCdXG1bjdpyU
         A0F7YAVWz7XgTxORzhPp2SY1SKiKP2WWY5jWi1OIO/zOebOJYHswR00AKSZT9JLEMXir
         h4QQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790841514; x=1791446314; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I0ryAjqgJbQ97DrgWNuEBrn7YtVDsU7C9id15LD6WBU=;
        b=XpEITXzUe+zE/ycjbeePDPErV4yAk65AZWemOBfVjIIV1lt40XwtNiC8rPZCqp0q8q
         kJn+9gf3PVg41jZTveWz5RG1oX7/goJCYWpxmREPCKJ6j0yC3yhmZtpbIHvUNDsOV/Rs
         OdHYskt9EwFISlOAVud0/TxGxjnf/fLE3OhALIssPXIFYim9QRUIDOfMrt/uPzkcNHWk
         qZREeXCh2HcLMXn0z5GCgdHeRhySEvfXkposcG1eU344RGc8L3UZYyzMFa+6zHOACxap
         HkJZcSRTCxNbbCjPNojtbpLbxo+yHd+pcfuedDR/YhiYuRT6DIzx4IDFbltyAhcSrUV2
         E+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790841514; x=1791446314;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=I0ryAjqgJbQ97DrgWNuEBrn7YtVDsU7C9id15LD6WBU=;
        b=lP/AKQGrQMpA8stc8Kc6s9x4BsfjpHGm97HY/yiqyG5zDo4TYDuGSiDsxWLkacl0ql
         woKQgO28svgJhvscsanXZHXOb05Vg22Lq6HQsyn+sSW7rwQHAWOeobefTGbV2jngKDM8
         7uMi1ZqAXJ31DDePyjI1QwJhMfyZDlVQDBx8mPdF7ndHerxP2Ed2GMmfbTGXTvn8s5gr
         g4F2v5gRBhpS6JqSvtbbZQLsmAknJQ+4OW+3DD1lsuLgcpboBNym/ZeIz7B3m4TVQ2Xq
         7xoK03I4VVSF5ysm2OfTPSYtavKoQl/6lw+uaGG09vhjNpTz6FCjYtUprpqIPt1BCLPu
         TuqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdDOXRlrkpZTtk6DGRXm16uQceci1MLGcxDyXYCnyb9HFvl78HiQ7PNCSqWD9WDvNG0/46v4j9DQ==@kvack.org
X-Gm-Message-State: AFq9FYKeMuo8eZE5ng7adxcxbKMuuosfW4t/Bk0aVjX0stUHfp41ui24
	enX1oGqXtLBHXOpYrx082LtWvgLcir77OpvM6gthzUTZo+dVKgA7b+yP0gVeHL6uRE7eAD+jF+C
	kRMVuTmQ3n9jd6umBDHHbFSlpe14RZmE=
X-Gm-Gg: AYBFou1oPDvbsCfZZMX7SBnXhIGtl4WrKNR/UR44lFzxB1Z2riMMTeiRRpE3EHmwGs1
	25foyOqUnVdraNQfme9Tjv5G1NNdHV2feQmAw5o3hnSdDpaycrqLkPb6KxBs1rJGe3p86P6ZcoH
	Dg4fkjmivdbQdWsGBVGacVCq4Ys/AGjPjHf1FYJ5ijtdCkCYncl2UP2LTvphD5mevukRtOHq4cE
	5t9BtIEPbo5d4KUjuJQtzPkk8D7/oRLN7U4DxQE8mF+L10s5T7JKf64g+pjHurJnEBLgGcDpKat
	He+v1emSJx8rtSsati35auPcXm6njVL9NSst1P3Wu4VNXwAftxdQ4pM6V4sOeyk7cWk=
X-Received: by 2002:a05:6000:4a19:b0:48b:1b6:3df8 with SMTP id
 ffacd0b85a97d-48b02520a95mr7176472f8f.35.1790841514203; Thu, 01 Oct 2026
 00:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260923062832.479455-1-jiangwen6@xiaomi.com> <20260923062832.479455-7-jiangwen6@xiaomi.com>
 <ar0fJcjNmGGV6uFu@milan>
In-Reply-To: <ar0fJcjNmGGV6uFu@milan>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Thu, 1 Oct 2026 15:58:21 +0800
X-Gm-Features: AclHuK_89bv7uwzbXx-_ECYL_ZRmqX93WJQq5H0UucnAezX9o9f55Dqa5iDge00
Message-ID: <CAHKocdF43Rqnt8-v0WP-t=Dxz2sSJ9xpyjLAYc2fzzKAW1_N8A@mail.gmail.com>
Subject: Re: [PATCH v9 06/10] mm/vmalloc: extract vmap_set_ptes() to
 consolidate PTE mapping logic
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0C6E100007
X-Stat-Signature: xwqqi9afceoxb9duu1aosa1uh1ddkeaz
X-HE-Tag: 1790841515-526091
X-HE-Meta: U2FsdGVkX19F29JewKNEnEGF666HV8HyeGlUHxmHAH8ngLMY47p9cvrpxavKYUa9oio8HiUWAEKHGBjsiLUY/TDcJySAVa9A1UlAqyyFgsthPmN30maLp9yvTYw/xQA4FRadALhGlOwmuKsAR/RJ0nWYlkem8W06ixVK8H5clJBI1MTCreNVA3An6Z1MYlHXMuDomtqMSjnIGc9pg0xljTYubwg9Ti5YSYWc+SOlzACV/c7COywmvMyoAezr//ayB/WnPtI3fVSm57KAVM3HENRd3IW3f2cx7PWYaie+/BLN+L47wU9zTxIA2UrD+c5LQ7VaxVpJ8894KingVkG88z0PMblFKQh331aWBx0XbULvCHI3Ssi/LTiqQjn8XUrEVexQBLtmqMSnoqYa4GGZZzDn5sXV392XZdcuw1NrJWz2piKYTqY38CHtvWlbzoECcmxBIMdCS8SfzSGoaHxu2QvP+mReTOVgHbPeT4qmJy4MSYWRnkczvj8jPK4X6J3L99e0HSqHqsjDJanhyhj9MevxI2SJg6DzVKExMROETsFTdJ4Q3jSdx02IMrqMjLiTnKDOhkWDP0jUsh4ToME87wdQbQNTGWwCkMuCy8/tlaUWiBAU4KFz03m5FnmGZ8GsbppZ7LJ4okQ04SA1Ur4DOvEye3IUAB0I2F3/kjfBdQb8L0xa1bKzNr1picP1P/I5w4xAoE/RUQ5Hg6i/dbIaDcX+W9tlqincM8flWOS9IUJb3vI1FwL7ZGWg5D2fk1Ub1TFvcbJb2j6G2+c1icTlCQnDiRqMG65sbgh6WoTGmUWGxa1IBhwMtroxfK9bedDhxRw3AuRT0KnmCgsIZgMLHgH3KBl3Alb0xImMasNbVDXX/wwvYbBIPN6p8SntV+NQdT9wF+xzJF6nN0olpoxpgiu//s1+8x37x98pOwzGgrKVLLhhgQEn8gzAF0W6M6WheatZHg6doGXJzJ64Pjm
 EdP0tfUq
 2FUPf1uZcsv6O55BeGmsfHM/5zXe9ww/uLhaOqwid+vlKVNhEe70jOGqhaeygD1UWp/Ok082Jv0Cogv20txJIoOc1Zweead8OMH4lzuooytou/HlltNaIvmA+RJmiJmEHgjPgvpSDBcp1bfay2ezINN3dT4A6RDTSoF91A5Uu2MOGOOHJkJTmpBxqeAIUv3y9Tqp1Pc9iX2yLwY15KZCrchOmgjgF6eTcrn9v0vhR7EFNIZoBQLkRvKZgEN+NxqAo4Z0tBaYM7gbmKSXJo9VvfKc00gyuFFfxqM69q5phFO6HX42Wx4PBSpoLKlxsBNAcYKbszgjfhuA/IGFRR6XXUksjC4g7E4mRVkrj6vDQ8j+xYtfhhvbYd6o6WJLsWGxS8x/LU4F6V9I2NB2e+DWckmCw/S5lw89Rtve/y0vITVusW/q+kk/PY4eTSwqtWYyecXm5DUd+tnJ8Voowbd4SqTNsUX19HIm3BZRzg2siA+BvzocvS54eak4QWjAJB7wK4xhCN66Xt1gmZJOp1UkbYJtGvILsFqCJlo75ZCYPV6CDksDmAJmQKxin5fN1P3SANCU1q5RSyTaEy/4/jmYYJg8Qwy/fwzHmVvvFMerzRcqkeFnc8TXY/gJUPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sept 2026 at 22:39, Uladzislau Rezki <urezki@gmail.com> wrote:
>
> On Wed, Sep 23, 2026 at 02:28:28PM +0800, Wen Jiang wrote:
> > Extract the common PTE mapping logic from vmap_pte_range() into a
> > shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> > PTE mappings in a single function, preparing for the next patch which
> > will extend vmap_pages_pte_range() to also use this helper.
> >
> > No functional change.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > ---
> >  mm/vmalloc.c | 36 +++++++++++++++++++++++++++---------
> >  1 file changed, 27 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index fb757d95bde25..d475e52110e4a 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -92,6 +92,29 @@ struct vfree_deferred {
> >  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
> >
> >  /*** Page table manipulation functions ***/
> > +
> > +/*
> > + * Try contiguous mappings at the PTE level for arches which support them, and if
> > + * requested by the caller. Fall back to PAGE_SIZE mappings otherwise.
> > + *
> > + * Return: mapping size.
> > + */
> > +static __always_inline unsigned long vmap_set_ptes(pte_t *ptep,
> > +             unsigned long addr, unsigned long end, u64 pfn,
> > +             pgprot_t prot, unsigned int max_page_shift)
> > +{
> > +     unsigned long size;
> > +
> > +     size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > +     if (size != PAGE_SIZE) {
> > +             pte_set_huge(ptep, addr, PFN_PHYS(pfn), prot, size);
> > +             return size;
> > +     }
> > +
> > +     set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, prot));
> > +     return PAGE_SIZE;
> > +}
> > +
> >  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >                       phys_addr_t phys_addr, pgprot_t prot,
> >                       unsigned int max_page_shift, pgtbl_mod_mask *mask)
> > @@ -100,6 +123,7 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >       u64 pfn;
> >       struct page *page;
> >       unsigned long size;
> > +     unsigned int steps;
> >
> >       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >               return -EINVAL;
> > @@ -120,15 +144,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >                       BUG();
> >               }
> >
> > -             size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> > -             if (size != PAGE_SIZE) {
> > -                     pte_set_huge(pte, addr, PFN_PHYS(pfn), prot, size);
> > -                     pfn += PFN_DOWN(size);
> > -                     continue;
> > -             }
> > -             set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> > -             pfn++;
> > -     } while (pte += PFN_DOWN(size), addr += size, addr != end);
> > +             size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> > +             steps = PFN_DOWN(size);
> > +     } while (pte += steps, pfn += steps, addr += size, addr != end);
> >
> #define PFN_DOWN(x)     ((x) >> PAGE_SHIFT) - how many pages covers the size.
> Replace steps by nr_pages or nr_ptes?
>

Agreed, I'll use nr_pages. Since vmap_pages_pte_range() in the next patch has
the same "step = PFN_DOWN(size)" pattern, I'll rename it there too.

Thanks,
Wen

