Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0484BD185DA
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1B56B0093; Thu,  8 Jan 2026 06:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551CE6B0095; Thu,  8 Jan 2026 06:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461386B0096; Thu,  8 Jan 2026 06:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 376176B0093
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:33:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0E3713B8ED
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:33:15 +0000 (UTC)
X-FDA: 84308585550.08.429C320
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2934FC000C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:33:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nT4lce7x;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767871994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uOaQcEvqH/Hd3NqzripTRIq0Qw/v1bGv7C8UVSeJmM=;
	b=I1FbBGZFIt3gsENQ522r+06e1VUrbEQVGZhm6pPRAY9T9Mlh2EdNoHTdeUZW39ULmhyZBb
	SyEBReV4Ob/A62NmHaipaLWMAFAmdJYKhGtg25R0NDJ9ZXVsPys4ZEl5MFXWOHOMBcvdPU
	H3S0WW5NJ4ChagP+yOBandYLsn0lrQ8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nT4lce7x;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767871994; a=rsa-sha256;
	cv=pass;
	b=GAsAwdV8Gdo4DQ8cKcVLdfUf3xWSSQDoa0IjSeiVSD3u2hVtmv2V+3U8PhOS8VqhA7iv//
	4SCXD5YYi9Tdp0Vs3MzFYfrHRrd169mjc4x+nwKVVGPgZXTMum5Sqxpc3hjjt4tP4L3WmT
	Gmqm8dJ7dEKMGSKIvdkrl+nDyT3xBK4=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso794321cf.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 03:33:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767871993; cv=none;
        d=google.com; s=arc-20240605;
        b=cpUbXUTAj8sf2TwsZXdGYkydSw0xX5EsVCJi36W3Uz0bs4RFKqF+1mALCqnX9prgT2
         owFlpuRkcN0SO1eQZDJZO0vFwQxKftnazgbqFxLz9Pb2BxeJHRT4OFHdsNJPrCg4If/l
         lgLwpctJ7DKxUoztxYTEn+eHsxJvWD+NR6iZUZUL0ZxcIN+IV+1aOCtaS6ERzcfiq05d
         ok4SC83BybhiLpfz6hrNSv8ZEWge486HbVWxwgQ7Kw4a/odtRdV6Jt9uJGf6OjOvF/vJ
         yNBezI6VBtVhbGZXGhe7IydH2xSJXqr0ofMolCJWTEpHFFuN0k0gh9bcYTkQ9l7lEFea
         AdfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6uOaQcEvqH/Hd3NqzripTRIq0Qw/v1bGv7C8UVSeJmM=;
        fh=0gMRDBDgVjHXFOibXV8nHTl40MWkMIixGXAkjpiqtBA=;
        b=Lx78cfxDrOBwLiCaiMoSE/WbXLuV1rqXqQvyHHIJjJKuQzdx+NssZ2aIanT38ZNnvT
         A2/HdCOxUVCwWh9lwQyAQlx6/SVnfCn3XgSQcNYlPjl9icTdCy4FpMocOJGXH42tXvfi
         95v1ia3Awgi95veOebmFHlQv8g4bELYEi8prmsoy72BnxMYLuVfblnLaG/o763KqIlFG
         MA9zvTN6YVV4eCaRGX7FqeNP8+/10q4h/O7AVRVKuvImj8K0KPdfPmAz80WwxxmQ2cdR
         mixI43xfuIreQuD+7KIuvkUphNQTey8tRsW0Tg/st/sjEeRRuHbwZYiF+bVU9I4BAtN/
         13qg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767871993; x=1768476793; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uOaQcEvqH/Hd3NqzripTRIq0Qw/v1bGv7C8UVSeJmM=;
        b=nT4lce7x+HhZJjdkANMcpoazPGFeGxVm/FZVQzpO66zbTnMxhK6TC6iu98n3+OMByQ
         2H7ErdySUn4bH8EXf7eshHkA40V5Iy8Zvl0hhKNEEu5+zgqkFWnhJbGrjYadJZ/9U2M1
         81w88962RRRNxR5l0NqTz7A/6U+7Wz36frnn3zBXFfhK+hrIsPL8UEA2ZVXAfci93fXS
         pDCRR6QnEW+K850f/Gy4/hCQUEs5uJEhMcevl76C7BxTuhlpMA1aiW1ryjxp9zVXpBKW
         wQ7IdXtgx303yXPeLOT2RHW+LGAE5oexu9YwMMbG43dT16bB0hIaT7H+tqBpHnW4fNpT
         oauA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767871993; x=1768476793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6uOaQcEvqH/Hd3NqzripTRIq0Qw/v1bGv7C8UVSeJmM=;
        b=CJhQcd5ZeMb7+Jl+tbRqPlJ1557i8HU5NCBzNrf5cXY2Jg/lQdhZl1Si/DClAGk2ca
         RI6yANiYAGwgaFjNqvkZROiAXXkmf5pTUCXjCSzpEVDW5Z8rHXJSy6T8p/NQOZQ8OgPo
         iqEAF0jPV/rK2wRPQUGE9IaZ94aE72ANoI+D+No3nwVqHwLOHotMxDo5NxgnK8eAWaBu
         Npf+j8Ze05dWJclhNeq3ddyHP9hhSbJ57iQwuCT4Vk3h6HBRWvs8L00QEs5PNkyzyyEB
         voi1rhkAY+ix5dtohq9sg2W4Lny62k8+FQD4xC/N99xEOSfekiizI46rFueXUk0KryUU
         SYQQ==
X-Gm-Message-State: AOJu0YzraGFKh0z71UY7kAPOyndhLKLleQGLB6x00N9pGfdAtf3Nb4sZ
	OTdcHgR6E2ah9APk/P8Q3PLaeVu50WNM7EB49Sblz+kGu/0bcT/Nch18yHLrNw9f2VAqrK5kBtP
	A54Sr/I/ZW9y3F87B8ME6Kc+OTzV1dcw+9sAFqUhZ
X-Gm-Gg: AY/fxX4HzVxvheVUEUrKQqOO+ZDC1ZIlLP/fwbYqlAa8aGu7eDxNVb+uyBhdF9HMpGc
	TXQ4u+IeMcXIlGkVhSsAaxqOWgjxXxaKO7egRer4Uh5XIB9n/TGNORx29pbrP+D5pp1SAsOcvZL
	QOYHrL1Edoc9XMIhL6dPR0OkoGJbYbVVOIcxlmRp4NG1vns/l5HO3aUoT9CsvBK8H0NLH5mCtrD
	JIQdvthfjaGrMeTwhCmAO6/4ioS+ugjGfembV8zokYeyzsmvQ45w5EoaT0DwTJqif1w7v+ycsWY
	78hYqKn1WoR+SmAIy2KSIPeLKvSCHA==
X-Received: by 2002:ac8:5ac3:0:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-4ffc0a77967mr7353911cf.17.1767871992772; Thu, 08 Jan 2026
 03:33:12 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-4-smostafa@google.com>
 <aV56BWisUQTMK2Gk@google.com> <aV-PvBqQ0Ktiha8e@google.com>
In-Reply-To: <aV-PvBqQ0Ktiha8e@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Thu, 8 Jan 2026 11:33:01 +0000
X-Gm-Features: AQt7F2pw41zErLif-3uwryiAOrSOrZpnIkyTexwr9_jBpysRxSFYAMim5EQTGb8
Message-ID: <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2934FC000C
X-Stat-Signature: jphaa4isedotgt5hr8emaft7t67q88zw
X-Rspam-User: 
X-HE-Tag: 1767871993-901375
X-HE-Meta: U2FsdGVkX1+sUTw6t5lLvUcCZVPXW1fgIX9KXE1idk7ZGXFEv4ZZ58gLSlXKmO5ggX/3/f4nl+3oh+nQ1SLYovWolf+XQv1Y6NBUdxfV9RKzfpeSMYI6ikupB0aI3heYJ+HwrWpK533DF+t6ib462P8VBWVIcEcC2byoE4PelSgI+/vYqXCOWzGRbwhmeVvYmE5HOIgsRseOxJPqPiitEeN50mOPnHnnj1THCN6vw2xKu8Q4VQt9gdhhcqTD8kN2/ZrUoN00G4Ay9yOK+P3cOuEICuM0RWY17TUCNGr/QJSPnWYIEH/L6/RL0VIzkk4WicdJche7X+0SVQIB6jPv7lGXm148rYkEU2SCo3u40ZucAvKvUpIIirUSEo/FEQ6Sc8CAV8xMpf0QvfEySSxMeTyX6byadnoDliXE645mqUZYM0vQCVIqjUlRxUCNxqChkjRkrFeKXlUQ7CHBlk1RG5qYxIt1nMWh8i+o2lIMoQdyZ+MWtW9p8LbyCIgpL89QqhSE6/S7u66BVdbrtbysfpOvawWqXty3/ONpKiIf/9AwsTlm3ecgWnB2rfB9HmlzFS/Y6XtpW3DOVCSiT5XI9yXbIvAaRZeuzdKF3yyAwscHTASv2TMS3ooVuBggS8eatlkny1dDiQsNZYxIaGRIIOgCs91H1op4+exYS2nuACWnA3P6yi4eNRoBnCimBDwdswdQmJ1Jo4zbTfjDcvprcpmRBrOzcx/aK5MePTpSzAXhdaHWAF424dJJLJzT9lRs977bLVSR8ijFzGyaBfCNElEIBdgCrNZIdpZYqrHgC3YOdswwoQTxnzP5pXsxPuKXCCf86qYQWV4f65ogUExzIbm2GU0naUt+jhH7qG/JoXJaGDNFCdv2g/l/lj2o1RUKvcy4b+QKb8uQ2yvbZ+fDNIzLcqpBQH+q+BW8I+kl+8lDR1+Ba2RypuIilFNcOczIqc4ugDgOGQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 8, 2026 at 11:06=E2=80=AFAM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> On Wed, Jan 07, 2026 at 03:21:41PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Jan 06, 2026 at 04:21:59PM +0000, Mostafa Saleh wrote:
> > > Using the new calls, use an atomic refcount to track how many times
> > > a page is mapped in any of the IOMMUs.
> > >
> > > For unmap we need to use iova_to_phys() to get the physical address
> > > of the pages.
> > >
> > > We use the smallest supported page size as the granularity of trackin=
g
> > > per domain.
> > > This is important as it is possible to map pages and unmap them with
> > > larger sizes (as in map_sg()) cases.
> > >
> > > Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >  drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++=
++
> > >  1 file changed, 91 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/io=
mmu-debug-pagealloc.c
> > > index 1d343421da98..86ccb310a4a8 100644
> > > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > > @@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops =
=3D {
> > >     .need =3D need_iommu_debug,
> > >  };
> > >
> > > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > > +{
> > > +   struct page *page =3D phys_to_page(phys);
> > > +   struct page_ext *page_ext =3D page_ext_get(page);
> > > +
> > > +   return page_ext;
> > > +}
> > > +
> > > +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *=
page_ext)
> > > +{
> > > +   return page_ext_data(page_ext, &page_iommu_debug_ops);
> > > +}
> > > +
> > > +static void iommu_debug_inc_page(phys_addr_t phys)
> > > +{
> > > +   struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> > > +   struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> > > +
> > > +   WARN_ON(atomic_inc_return_relaxed(&d->ref) <=3D 0);
> > > +   page_ext_put(page_ext);
> > > +}
> > > +
> > > +static void iommu_debug_dec_page(phys_addr_t phys)
> > > +{
> > > +   struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> > > +   struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> > > +
> > > +   WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> > > +   page_ext_put(page_ext);
> > > +}
> > > +
> > > +/*
> > > + * IOMMU page size doesn't have to match the CPU page size. So, we u=
se
> > > + * the smallest IOMMU page size to refcount the pages in the vmemmap=
.
> > > + * That is important as both map and unmap has to use the same page =
size
> > > + * to update the refcount to avoid double counting the same page.
> > > + * And as we can't know from iommu_unmap() what was the original pag=
e size
> > > + * used for map, we just use the minimum supported one for both.
> > > + */
> > > +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> > > +{
> > > +   return 1UL << __ffs(domain->pgsize_bitmap);
> > > +}
> > > +
> > >  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys=
, size_t size)
> > >  {
> > > +   size_t off, end;
> > > +   size_t page_size =3D iommu_debug_page_size(domain);
> > > +
> > > +   if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
> > > +           return;
> > > +
> > > +   for (off =3D 0 ; off < size ; off +=3D page_size) {
> > > +           if (!pfn_valid(__phys_to_pfn(phys + off)))
> > > +                   continue;
> > > +           iommu_debug_inc_page(phys + off);
> > > +   }
> > > +}
> > > +
> > > +static void __iommu_debug_update_iova(struct iommu_domain *domain,
> > > +                                 unsigned long iova, size_t size, bo=
ol inc)
> > > +{
> > > +   size_t off, end;
> > > +   size_t page_size =3D iommu_debug_page_size(domain);
> > > +
> > > +   if (WARN_ON(check_add_overflow(iova, size, &end)))
> > > +           return;
> > > +
> > > +   for (off =3D 0 ; off < size ; off +=3D page_size) {
> > > +           phys_addr_t phys =3D iommu_iova_to_phys(domain, iova + of=
f);
> > > +
> > > +           if (!phys || !pfn_valid(__phys_to_pfn(phys)))
> > > +                   continue;
> > > +
> > > +           if (inc)
> > > +                   iommu_debug_inc_page(phys);
> > > +           else
> > > +                   iommu_debug_dec_page(phys);
> > > +   }
> >
> > This might loop for too long when we're unmapping a big buffer (say 1GB=
)
> > which is backed by multiple 4K mappings (i.e. not mapped using large
> > mappings) it may hold the CPU for too long, per the above example:
> >
> > 1,073,741,824 / 4096 =3D 262,144 iterations each with an iova_to_phys w=
alk
> > in a tight loop, could hold the CPU for a little too long and could
> > potentially result in soft lockups (painful to see in a debug kernel).
> > Since, iommu_unmap can be called in atomic contexts (i.e. interrupts,
> > spinlocks with pre-emption disabled) we cannot simply add cond_resched(=
)
> > here as well.
> >
> > Maybe we can cross that bridge once we get there, but if we can't solve
> > the latency now, it'd be nice to explicitly document this risk
> > (potential soft lockups on large unmaps) in the Kconfig or cmdline help=
 text?
> >
>
> Yes, I am not sure how bad that would be, looking at the code, the closes=
t
> pattern I see in that path is for SWIOTLB, when it=E2=80=99s enabled it w=
ill do a
> lot of per-page operations on unmap.
> There is a disclaimer already in dmesg and the Kconfig about the performa=
nce
> overhead, and you would need to enable a config + cmdline to get this, so
> I=E2=80=99d expect someone enabling it to have some expectations of what =
they are
> doing. But I can add more info to Kconfig if that makes sense.
>
> > >  }
> > >
> > >  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> > >                            unsigned long iova, size_t size)
> > >  {
> > > +   __iommu_debug_update_iova(domain, iova, size, false);
> > >  }
> > >
> > >  void __iommu_debug_unmap_end(struct iommu_domain *domain,
> > >                          unsigned long iova, size_t size,
> > >                          size_t unmapped)
> > >  {
> > > +   if (unmapped =3D=3D size)
> > > +           return;
> > > +
> > > +   /*
> > > +    * If unmap failed, re-increment the refcount, but if it unmapped
> > > +    * larger size, decrement the extra part.
> > > +    */
> > > +   if (unmapped < size)
> > > +           __iommu_debug_update_iova(domain, iova + unmapped,
> > > +                                     size - unmapped, true);
> > > +   else
> > > +           __iommu_debug_update_iova(domain, iova + size,
> > > +                                     unmapped - size, false);
> > >  }
> >
> > I'm a little concerned about this part, when we unmap more than request=
ed,
> > the __iommu_debug_update_iova relies on
> > iommu_iova_to_phys(domain, iova + off) to find the physical page to
> > decrement. However, since __iommu_debug_unmap_end is called *after* the
> > IOMMU driver has removed the mapping (in __iommu_unmap). Thus, the
> > iommu_iova_to_phys return 0 (fail) causing the loop in update_iova:
> > `if (!phys ...)` to silently continue.
> >
> > Since the refcounts for the physical pages in the range:
> > [iova + size, iova + unmapped] are never decremented. Won't this result
> > in false positives (warnings about page leaks) when those pages are
> > eventually freed?
> >
> > For example:
> >
> > - A driver maps a 2MB region (512 x 4KB). All 512 pgs have refcount =3D=
 1.
> >
> > - A driver / IOMMU-client calls iommu_unmap(iova, 4KB)
> >
> > - unmap_begin(4KB) calls iova_to_phys, succeeds, and decrements the
> >   refcount for the 1st page to 0.
> >
> > - __iommu_unmap calls the IOMMU driver. The driver (unable to split the
> >   block) zaps the entire 2MB range and returns unmapped =3D 2MB.
> >
> > - unmap_end(size=3D4KB, unmapped=3D2MB) sees that more was unmapped tha=
n
> >   requested & attempts to decrement refcounts for the remaining 511 pgs
> >
> > - __iommu_debug_update_iova is called for the remaining range, which
> >   ends up calling iommu_iova_to_phys. Since the mapping was destroyed,
> >   iova_to_phys returns 0.
> >
> > - The loop skips the decrement causing the remaining 511 pages to leak
> >   with refcount =3D 1.
> >
>
> Agh, yes, iova_to_phys will always return zero, so the
> __iommu_debug_update_iova() will do nothing in that case.
>
> I am not aware which drivers are doing this, I added this logic
> because I saw the IOMMU core allow it. I vaguely remember that
> had something about splitting blocks which might be related to VFIO,
> but I don't think that is needed anymore.
>
> I am happy just to drop it or even preemptively warn in that case, as
> it is impossible to retrieve the old addresses.
>
> And maybe, that's a chance to re-evaluate we allow this behviour.
>

I have this, it should have the same effect + a WARN, I will include
it in the new version

diff --git a/drivers/iommu/iommu-debug-pagealloc.c
b/drivers/iommu/iommu-debug-pagealloc.c
index 5353417e64f9..64ec0795fe4c 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_domain *dom=
ain,
        if (unmapped =3D=3D size)
                return;

-       /*
-        * If unmap failed, re-increment the refcount, but if it unmapped
-        * larger size, decrement the extra part.
-        */
+       /* If unmap failed, re-increment the refcount. */
        if (unmapped < size)
                __iommu_debug_update_iova(domain, iova + unmapped,
                                          size - unmapped, true);
        else
-               __iommu_debug_update_iova(domain, iova + size,
-                                         unmapped - size, false);
+               WARN_ONCE(1, "iommu: unmap larger than requested is
not supported in debug_pagealloc\n");
 }

 void iommu_debug_init(void)

Thanks,
Mostafa

> Thanks,
> Mostafa
>
> > Thanks,
> > Praan

