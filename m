Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B69FC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE856B008A; Sun,  6 Sep 2026 21:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F986B008C; Sun,  6 Sep 2026 21:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F796B0092; Sun,  6 Sep 2026 21:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E41E86B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:11:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9B5112064C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:11:29 +0000 (UTC)
X-FDA: 85185188298.04.B7AC8AC
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf29.hostedemail.com (Postfix) with ESMTP id 01E38120008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:11:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qkDXyDDN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788743488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8SfwcOHcFiXuWXMtZLOjZ8Wgybv201Ru9VvBHg88Ic=;
	b=pheeuf3h39CMsnf54MDobuXMBfqH4NNzOaMOV5ANtmAYTKVaUQc6QcGePq80CmL1CcR+Nb
	7DiBi1o9ZMRVUR2rxjwbJXD1qHvBZE+zo30pV9AJYJcfphC1oJKWu5jzeCDOeLShiogAP1
	d6zmahy/D0wIANen39+bQvg/PIquD/4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qkDXyDDN;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788743488;
	b=mSk6BHvyizgPYkjK4kKdhRH0yOq+AKaiMkYdgVoGC14wisSNZzyid276TQNQ+WVaIK/jJM
	V5XKkfzN2K5eafXUW311XgqOhr73GKjH08qTCDKejFDk/+1GAk+RJtkeLiF6tDbBwy+aXY
	ukOIDkk4dLJjMTqKgcHvuVvR736dTKk=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48583cb7d44so240781f8f.3
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 18:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788743486; cv=none;
        d=google.com; s=arc-20260327;
        b=i7KuxgQljq2ebdA5m69XBF/7yG+dbHaoc5A0tntjV2Lf9QQROmnMLHkXDvRUc9wHCv
         no34qfGtN9GS6zYpc+e6XF9VLO4zDZx8P2+XAX7RLsayDOBNJzhEa87OzG9oNoztJudT
         BSle2+tR587n3DmuLY2UnItBg2v7jFW/B0xwJVIHF9kI2rLix2K4BPxGczwV02MURSpz
         Q1+B1BlaR1/mqTDaVKiKfAqgdCru6AtvJ+54+PJ6z4zYyzlry49fudsYFjjoZGQwGmrl
         WUNBKzNdi1/fJ+iWDiBAijxx6uwCacykyIz53+X9ZHjfrR/hiFPkUpEb6yL3d/4yOJw8
         gu3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k8SfwcOHcFiXuWXMtZLOjZ8Wgybv201Ru9VvBHg88Ic=;
        fh=plqczw1JIWzMP9TuwZuc6NmcSrT6DPKDx9/NifstF/U=;
        b=akKE1TmexhZTFkH2BW22P1C4nU/+BKnV9OYZ0zhMqVRPSAb24D9SbBHt0OQ60hHqQ9
         kc5c+N/Bk/LB1CyrftTTOzELcffYgVTBZZdvh4ZV6msImJQRVGI181WgmHa3YzYuh3J6
         HCvQioIoQfAvOLZIpzIF1aiZ9hnDeTW0L0x44qqKx/52krlF8zP7UeKNWNpLXjsUGAMF
         gyOu5+oYZ2bqchvV+XOUitUO4WyrONHAfbzIGZ1uutGspSMAKaikVNGSYngiON7H0Pgx
         WcLn3s3v6BU1TD67x+ohGpNhfM5XYzNCxbxYOL4bgDm6afp/euM8OEcQMofbFMVRtEUI
         REsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788743486; x=1789348286; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k8SfwcOHcFiXuWXMtZLOjZ8Wgybv201Ru9VvBHg88Ic=;
        b=qkDXyDDNtsgGEr7SqjwJJSOhSyoLcZ+xjZyI8lwUVdGCRf61DTodv/ka6APtowmEgI
         hA/jsgjgbQgnAdH1421ufrj/ARzyVfwIzku9GRGJK8tfbR4A/nyr4E2Ax5OSxOKRWxfT
         DmbrC4E4cw6t6Ffq6ihdWv4asQ2tPFnxK+2P1RtYcWtejV+XgnJTtJ8gNdqZMi44QXMi
         pqpr4Aee+WN8afX53U0PPMKOCLm/IUc6QqKzvWGfQVnb7ydw5tc++XicFsBqdqjbHwDT
         hv/c9FxKL1Pz4I0fAV2d6AhwxuzaCSAWkmYUK1sGkTFM1yMmt3C8Zzt63JqNqOg0LFan
         7dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788743486; x=1789348286;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8SfwcOHcFiXuWXMtZLOjZ8Wgybv201Ru9VvBHg88Ic=;
        b=RYZyVpf1V8nEgf3jDW5C0WqJy7LgaG5Cfl/pHr4tN0br5qTK3OQ6rc3qt43/JgBWyN
         6Gmh+MFaKPnb/pdxO/3XmaxiTS1glCulZJLu9aFKNUw5S6o1au9vKbEdkBY2Nh7phYT0
         R5285icr1b8SEi3CMVad241w9QWPgIkRaK8/R4wqqX4O8i+wK6L/EHsWknlDC/AdAGC+
         9vBopiML4AUS1M1Kb8TbERE5/sONhMaSzoTGBjfqfrCAQ8deXhSJXrA5XEjmb2NxmoAJ
         58zhUOsz1DtuiWZvnlJZ1ZL91HN/V40NGgYVaANFExwP7lt7MP7St6RtgxGP1hZnwZ50
         SkhQ==
X-Forwarded-Encrypted: i=1; AKwUvByFP8GbSGZdDApalrwwSePdAWPtJcQzk0B3HMZh7gllQb+tbsz0bL22xmzpi8+OKHoTqWBHnlhCvQ==@kvack.org
X-Gm-Message-State: AFuF++k7WTMcBJnA3Coao/+uXbRApJONd0GPDwL63chA7sBZvRMfMJiy
	NqEWxFNknPHSc+d1GkEV245B22OX+QA8T72YWbWLE4wGDkvUxupz2YA49shUSf5D/LW3KQKda92
	pY/jqf5ffJq1npRsHExC3iQvgVqeI+Z0=
X-Gm-Gg: AYBFou0oZeoXEbTH2y27F+NPbmAjE0bSDvwcFcUA1Quce0zCMlQbsyIEOfLCYEzpsS5
	6EcKHX1WAzq43fjQTAiwz24OhuORhfK0W2omvvGYz0BD/zCkdkFlVKKyj378qqTiXIExSxMcsrH
	Ex3ra0UIKXnRmaPQ8n2MPWh5bXHashAcu4a/N31OaGWKcT4m+azWOOUtZv+56qgl7vYPeWvceW/
	43IOkvAO4PNpfTM17xtXyJr3PTuh613cy5tyuOgouOc/mQh8Obf0dBBGs39XD2ZUcghWGyQdCZj
	t6lH4I1o8NdfWbj6rp0HjbJScV1ozrf1if1xMXdJJ7p3u8uUfOUkRTsaoqXVykfRyKOzdCjWmZX
	wzx2l0rUQPkcC6LKIXQomd33sEFclGg==
X-Received: by 2002:a05:6000:2089:b0:484:3313:4a04 with SMTP id
 ffacd0b85a97d-48590807e07mr10355875f8f.6.1788743486138; Sun, 06 Sep 2026
 18:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com> <ap05ue1pq3TgHOS6@kernel.org>
In-Reply-To: <ap05ue1pq3TgHOS6@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Mon, 7 Sep 2026 09:11:14 +0800
X-Gm-Features: AcwNN1WufdM6tUiTu-c39ZQdufSwNkBnDu9lho31Iod0EgTEfjYNFPqnmJIZUMA
Message-ID: <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01E38120008
X-Stat-Signature: 91r1g7gh7spfgo7y5uz8sw5ruoxw5c7e
X-Rspam-User: 
X-HE-Tag: 1788743487-447016
X-HE-Meta: U2FsdGVkX189r5CRGZWvvhWJiaGtIdQ28RnqY4kCcPKqJXkV8M7NCkGNiSfmcIaKtHM4uSmujNTDxSGKO71IbTfPaRTFNPDf6WVTXVx1ypxmRFAAmJGgnc94Fm1Y70NwF0uxn84j/ZAy5Svuy1uRUFeBNwFQaijnAspuYGKNMr8xCVoe4rkU2v+RyXkQrOlEzRSLmYF8elK4TQ99zwQbo7DzGEPPD8pB54OCWCuJEFWzmwnfeWwKnW84wyIPBXVvyDv9MemUkIha7B+XCcc62SRUvXFyyxkE9gOP/wHE7/TUartRgcdHP6PzbHgCbpl8dNDsOr8YI+t66QTQjsb/dy5DJOIRVJcNEKoMSjQOuJLAmrR+Ck7pd8XJa3rEUT05RACJT0Yd73AU8adJv6MOGHfOHwDRPHCz/SzP9KPcPVRgE/EiSlaGjAeAS+tnh03vRREw6oIy3V0NF+CV4G1H19xgwZRWTKrlNXXmMmNfc8lbuuvmG1KBkT2mruh99N3H5tn2ugFNIu5eMeJNROW1O/k2twrejQOnLAuDHYpeX9DDj2ZW094/0XPlFRuR/D7tVpDGo5azzfG+2VCrCQVdORR0cVjXvvBYs1dbpNVtLTPiuLKaAQ/vMsw5sKc/DAWyuOwR8fnW/FgCL+ggnwD1vTm/x+xQTas3WyKL5a4YDjbl5crxae9YAcpgPgg61BDZHKTSELS5MN0xQRwVTLnkiF9vwKCqDFF15NkATSv4uaHgWEDoZDJt6dQAGg9IaI/E6s6cUHZfnKUDBTfmQMW5ysR7Rv76nMlEyBCJbp9u0eOcu6hAvZpI9tD6GyYgp17m7ytuvxrdvt+mtPL2icrZtmWphkL1uKyJ9ZEFGC31e9SkzGtfkzyt0pwNSkiLuY6BHbSJQmm8B6vpPbWh4jfBS4p9U1+OPjRb0VMXO6i8xa/1S3+/4lsSYoQTBn3ey+9ZVdoQBMH6Jn2jzsvkJyI
 sz1LgzwC
 mcPrghrAc/sppAHS3JCWnTKK6rSwJatDHOWD36RhRfBD7Hub15SzaEtOAT39DqV0Ot7gRK4b4qWnyFVk8KnZJ6MwvJ7r87o9EoaUn8DUsjOCNrcxqoRCQAvKs6Kc3n3vueT4VhTVKR8WJaWMlJyJ3coe+wwQUzpYhQzO4QLIW/eo+yFn1Q/3HarAgaoJc6bWe2urt4npATPvJjGYs+RK6zI98++C9ywzzyXDYbxBkWT1Il5/ySG/qw2TMKRFyeQwlXG+YbUo0d0Hf7f9eH4BiQdVHRb20dpqFPx4Fq8kMEhDE1vK+DaPc+kEEGvYuw/CkYhOElGZVJzLZ8+pVzNVtAmvItCh2vmV3puu+7RM7s20dFGspjD0xvbiGnrPPBurALXktZ1s0iio8tZKaWDqudvHYROc+FMjMR2iHMVKaOCAZ1g+tOvQsYFSRy7/sY+6wJ8H0ExH65c/zeJU7sM3s1alHCi2+1/mJkxwt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 6:00=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Thu, Sep 03, 2026 at 08:49:52PM +0800, Xueyuan Chen wrote:
> > On Thu, Sep 3, 2026 at 5:22=E2=80=AFPM Mike Rapoport <rppt@kernel.org> =
wrote:
> > >
> > > On Tue, Sep 01, 2026 at 11:18:16PM +0800, Xueyuan Chen wrote:
> > > > The persistent huge zero folio is shared globally and should stay z=
ero
> > > > after initialization. As Jann Horn pointed out [1], kernel bugs hav=
e
> > > > ended up writing to pages that were meant to be read-only, includin=
g in
> > > > security-sensitive cases. Making the folio read-only in the direct =
map
> > > > turns such writes into faults instead of silent zero-page corruptio=
n.
> > > >
> > > > Add a page-based helper consistent with the existing direct-map int=
erfaces.
> > > > Handle TLB invalidation in the architecture implementation; unsuppo=
rted
> > > > architectures retain their current behavior.
> > > >
> > > > Protect the folio after initialization. Skip highmem folios, which =
have no
> > > > permanent direct-map mapping.
> > > >
> > > > Inspired by Jann Horn's read-only zero page work [1] and follow-up
> > > > discussion [3] with Yang Shi.
> > > >
> > > > Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20=
b49@google.com [1]
> > > > Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc299=
1@kernel.org [2]
> > > > Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=3DjDx9=
E6dLOULohnhBguvi9A@mail.gmail.com [3]
> > > >
> > > > Suggested-by: David Hildenbrand <david@kernel.org>
> > > > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > > > Co-developed-by: Lance Yang <lance.yang@linux.dev>
> > > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > > > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > > > ---
> > > >  include/linux/set_memory.h | 17 +++++++++++++++++
> > > >  mm/huge_memory.c           | 13 ++++++++++---
> > > >  2 files changed, 27 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/include/linux/set_memory.h b/include/linux/set_memory.=
h
> > > > index 3fe293cfed8c..ed9ce04b18a1 100644
> > > > --- a/include/linux/set_memory.h
> > > > +++ b/include/linux/set_memory.h
> > > > @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> > > >  #endif
> > > >  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> > > >
> > > > +#ifndef set_direct_map_ro
> > > > +/**
> > > > + * set_direct_map_ro - make a direct-map range read-only
> > > > + * @page: first page in the direct-map range
> > > > + * @nr: number of pages in the range
> > > > + *
> > > > + * Make the direct-map range starting at @page read-only and inval=
idate stale
> > > > + * writable translations before returning.
> > > > + *
> > > > + * Return: 0 on success, or a negative error code on failure.
> > > > + */
> > > > +static inline int set_direct_map_ro(struct page *page, unsigned in=
t nr)
> > > > +{
> > > > +     return 0;
> > > > +}
> > > > +#endif
> > > > +
> > > >  #ifdef CONFIG_X86_64
> > > >  int set_mce_nospec(unsigned long pfn);
> > > >  int clear_mce_nospec(unsigned long pfn);
> > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > index 54494c3fa983..742283b36d74 100644
> > > > --- a/mm/huge_memory.c
> > > > +++ b/mm/huge_memory.c
> > > > @@ -42,6 +42,7 @@
> > > >  #include <linux/pgalloc_tag.h>
> > > >  #include <linux/pagewalk.h>
> > > >  #include <linux/cleanup.h>
> > > > +#include <linux/set_memory.h>
> > > >
> > > >  #include <asm/tlb.h>
> > > >  #include "internal.h"
> > > > @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> > > >       huge_zero_folio =3D alloc_huge_zero_folio();
> > > >       if (!huge_zero_folio) {
> > > >               pr_warn("Allocating persistent huge zero folio failed=
\n");
> > > > -     } else {
> > > > -             huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > > > -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> > > > +             return 0;
> > > >       }
> > > > +
> > > > +     huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> > > > +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> > > > +
> > > > +     /* Highmem folios have no permanent direct-map mapping to pro=
tect. */
> > > > +     if (!folio_test_highmem(huge_zero_folio))
> > > > +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPA=
GE_PMD_NR);
> > >
> > > Sorry, I don't remember if it was discussed previously, but why can't=
 we
> > > use the existing set_memory_ro() here?
> >
> > Hi Mike,
> >
> > We want to change the linear map here, but arm64 set_memory_ro() only
> > works on vmalloc addresses.
>
> I believe this is an historical artifact. change_memory_common() already
> updates the linear map when a vmalloc mapping switches to RO and the syst=
em
> supports it.

On x86, set_memory_ro() does work on direct-map addresses.

>
> I believe arm64::set_memory_ro() can change the linear map in the general
> case as well as long as can_set_direct_map() is true.
>

On arm64, I'm reading arch/arm64/mm/pageattr.c, and the linear-map
update in change_memory_common() is only reachable for vmalloc
addresses:

  set_memory_ro
    change_memory_common
       area =3D find_vm_area((void *)addr);
       if (!area || ...)
          return -EINVAL;

So set_memory_ro() on a linear-map address returns -EINVAL on arm64.

Am I missing something here?

> > So a new helper is needed on arm64, and x86 implements the same
> > helper to keep the two architectures consistent. On x86 it is
> > basically set_memory_ro() minus the alias check.
> >
> > Thanks,
> > Xueyuan
> >
> > >
> > > > +
> > > >       return 0;
> > > >  }
> > > >
> > > > --
> > > > 2.47.3
> > > >
> > >
> > > --
> > > Sincerely yours,
> > > Mike.
>
> --
> Sincerely yours,
> Mike.

