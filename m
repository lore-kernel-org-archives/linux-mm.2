Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40F68D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 20:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFA86B0006; Mon,  8 Dec 2025 15:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6FB6B0007; Mon,  8 Dec 2025 15:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCC96B0008; Mon,  8 Dec 2025 15:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A80B6B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 15:09:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9576C0246
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:09:53 +0000 (UTC)
X-FDA: 84197394666.18.B5B1D40
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D6218001C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:09:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OJFfRIEL;
	spf=pass (imf02.hostedemail.com: domain of smostafa@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765224592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHtc/+z90ueo42R+9ZDR9Ppw22giUiqfAKE3wYBFhaI=;
	b=MPnJ73OD7ubjN93pvQr4bsXi1L2nSvDMx8Ukkc8LrGy26lPHWKssK5rbWCMRHGr1FXrBQ3
	UKGRmut/vEpqzH+IcMPy4N/WeXc5OAfTWgjBaAMhC+jG0dE8RQKKCnoG+35+7ag5XsqZ+S
	QuSgCKVVJA0gB1kkUdKg+FHW6dyBl20=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OJFfRIEL;
	spf=pass (imf02.hostedemail.com: domain of smostafa@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765224592; a=rsa-sha256;
	cv=none;
	b=vziT3olr7o7DxOssf1/h8OQtHFJFgrGUgI4S1vBG5SFLczEjw9LiMZvrzcKatbXwEWUX3f
	iZRfThXivK9uP20K8CJfP931/U/O6zX05v2rf/fwlihRg8FktBGx6QEpN/kGkxti2TfoTh
	yh255nMApafVUNuTC2zzxPF9j2SDi3A=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee147baf7bso1751cf.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 12:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765224591; x=1765829391; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHtc/+z90ueo42R+9ZDR9Ppw22giUiqfAKE3wYBFhaI=;
        b=OJFfRIEL17dGUaOT5qh5owcBEBtv5qmyQLB2tQ16XkQ7+G0O7fBnNOB6H1yCWcPnS2
         hPiJ08E+JVE94o7U0bQFcx/wQOl83WEEeHmS9sJY31F7vUoYoTOKBW0LFq7Wrj1xsGvU
         IkAYUVM026RRs9jnl5SVVtT0tDlXAn0pF1u7NP0tp9UQ0jPNu4VSjGOZfIbEqeLZ+B9q
         ajFsDyHOGaVGQEiiodjPZoGpKEim9q8GTAvTeQiykXZrt9MqDtXT45Wc41CJizHj2rok
         5pndtKiK/g8FvCpfe9ox6QgTOPvZ5J1IVpKDiE4c70mcIjXLp5ZW0XWWKicL95VZqliV
         d/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765224591; x=1765829391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHtc/+z90ueo42R+9ZDR9Ppw22giUiqfAKE3wYBFhaI=;
        b=gwkZT6tERXyRxLdQEkRjV/I9i2RdHkDQkOvz0SFqZXloDnFjcWkVlYPU5Ut7SeRqKt
         4aVNwUbmazB1cyerJfZM4/4OEnbgcgBPPlwfGkqbJr46Vk3qtiggcIU8flOTR/hzTx1H
         QjsOjIY/rjQnohW+F6MCr8J3DrY0rIChrstfMCfxvIk8cUQ7KlgOrTp6RxRvUbUnOZQ3
         o0momV5KUsa0IVQ+QFRkGzQq8fpQ3A1SAI1L0t+gyfa0xvFafkzNA+6LGnbASHTStVIG
         VOoUT4qTzBuuERwzI9JrQBhIQLRVL0Ev39qlu4UgQ0pmJsao0LhBRbc7cYFY3jGV37V2
         0x/A==
X-Gm-Message-State: AOJu0YxYbfp3tQP4CMHAVaXRP8Xjii3wVx5NePKjM8Pxo5Wu1XQzuoTP
	VBc6f16/Qcg8PTu0HJDoPg41BJK8QQ/KQPzHuzfZNjDbYfbwn8BGOgWhcatccXKakSaR0b8ncZJ
	Utq6kpCtqy3B9QnYvQyP15GYMMP8Dk7EQq4Sr55oa
X-Gm-Gg: ASbGncsxxOH69ywpIEWk1itbPAmm8L2Ilg8zyHe3I5QPi6kqK4aUeGdwym9my5Gcurd
	/8HVVlrg8rXiVWrYpAF6zquji+8fnpg+6lDFXsqJTXgXLeXpAzPvt/xEepqQT62SujhmMAVWSkY
	Z+8MSoozVmQEw1/aRN7nqnzMm58YBdm36qjYYr25BXHDSUE7hgfJtwvPnCuIHaSSgQDknJUy+GO
	tGCxYZsCOiPAZXwF+8zaNgvCbInBs95fq5CjKXXzrwLhogFfBa+v8pDrXpNXWO2c/DjxA/NBe/8
	3wQU
X-Google-Smtp-Source: AGHT+IEpZoR/iQOyoic1B163k5XpJh88inqgJpWY7MOX9hadvYKtYDxWwg4ICG4nBzjKIlyip58I04JqGTDCPmwL53c=
X-Received: by 2002:a05:622a:41:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4f1a4d2d82dmr2006671cf.0.1765224590828; Mon, 08 Dec 2025
 12:09:50 -0800 (PST)
MIME-Version: 1.0
References: <20251124200811.2942432-1-smostafa@google.com> <20251124200811.2942432-3-smostafa@google.com>
 <07434771-3233-4c88-b505-ee02da72c905@linux.intel.com> <aSV-Xi5uMJcMtk1b@google.com>
In-Reply-To: <aSV-Xi5uMJcMtk1b@google.com>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 8 Dec 2025 20:09:38 +0000
X-Gm-Features: AQt7F2rms2NfQ0fmpo7RMgd6BkOwNRHXqeaRPgLhXlJQKJwBB3kdVgcG7LFHRKY
Message-ID: <CAFgf54qGdWNB=Oa=vbU1hRN2XOxQSESGO6K0CiG4Qizv=T3+Qw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gpherfk5j47wmifte76dgnk6iufktgtd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D6218001C
X-HE-Tag: 1765224591-7383
X-HE-Meta: U2FsdGVkX19VtMCo3etxCfG08Jiea8IIYw6AwnCKWlxfyLqxFqQVZslaT9dJs/X3ype8ih6PxAow01LwFTGqnYMi3Yku9xEpQ0sLlYCZQFIHDNEYG9K7uCN/HO0NCosJ/QEtJkEodGRZFWsaHATDC3Z7Ycsr/dX+AT6xFn7+11ecsf+n3yhJyLZiC8YEZj/xn7f9bS7y1wCSxVW6UZWwctiTWey043egitHqgW7Pc3ndEJlRorqlZBeIMvvIrQSLspivDNMah2LVFLWd6BbsKkujof0WWu4rPahsEZ0BCkV4xN3AWfkZcQtaFTWHqdw38yib378Ole1c2Fw/UuRYxekhPLHX7/u4NlV/Ri0QA+/41diPiirT5mbwIxRzuqvCk3DsQ/OwafwsTnhZsXVTQgtWJyq704n1qsTMrY50ANXubQe0xj0xhIacUosFoZPhOjuuizJY6bZtvgwZAvU7AN3iAJWkcGBZyG88Pnep0FuZL26SO2FCsAdpyfad3o2V/V4C90FWhYmlGjZUvYQxyfEGZSD7g7bUX1kVsBajqff15LPw9ANVPBIbmsVh5RwHqbHg4WYHeyHGrSGOc+zdjHPMaZuLamLoscmxV5p3w1bRoNzkGZHQufLsP6/5tpZjeHWnTf6dH9zpbLenkH0ETkpJaXsVkQa/J5W7EnSqbg7uDLXi+duzajcd8j5zV02z5mWd7zj2I2Xlat6xl1lNN38PbqVOUK2Y/EzdWpVdS40LNexOQP1rvTfnitz5dkDrYmYjmyQVTD9wL5vs2jCqvXbyAxCEo1p2zmDFS9AEIVhaIEB7dYoC5EXTRaPChrhSzVC8kfSDGbiWJ7S7V/ZkF6+G9j/xeOWfYrR2eGRaoQlxO8TB689VVTQdKwFko3WiDEMEfvI1l/jaKqnwO9O6R0z9Tbpichzp/TtepMDtLck4/wSUGRj0ugb6JGHQBNJw2UoJv3uod21q2kCDnNt
 QQ/85MH5
 ZJGYl4A+UCqA+LRpo5H+9i7DZY39poJK823Gwikt6nBhh7TxqRM4VPMkaQXTGq4wIR+Y/MmPYu8j5gWfJZoQ09xNlHjM5Zb/liE3z7xvV7JiQKJv65q3FdquIYz0XO3bsN1z8/S8HkO+IZcVYrEBUMnY6AdpbwWO0nHarIyWo7isvEmJyuN1zjOwTYobAuSkJHnIaFPDggHjJiq2GYD7Z/YYykQ+p7Zh+twX/aGhZ/FWhUxC7J1b9M9XNIbrMpb2iOIcmeslr1napTjFUVb171p2176yoVGslfnyHPnCFLGNFHqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 10:01=E2=80=AFAM Mostafa Saleh <smostafa@google.com=
> wrote:
>
> On Tue, Nov 25, 2025 at 03:35:08PM +0800, Baolu Lu wrote:
> > On 11/25/25 04:08, Mostafa Saleh wrote:
> > > Add calls for the new iommu debug config IOMMU_DEBUG_PAGEALLOC:
> > > - iommu_debug_init: Enable the debug mode if configured by the user.
> > > - iommu_debug_map: Track iommu pages mapped, using physical address.
> > > - iommu_debug_unmap_begin: Track start of iommu unmap operation, with
> > >    IOVA and size.
> > > - iommu_debug_unmap_end: Track the end of unmap operation, passing th=
e
> > >    actual unmapped size versus the tracked one at unmap_begin.
> > >
> > > We have to do the unmap_begin/end as once pages are unmapped we lose
> > > the information of the physical address.
> > > This is racy, but the API is racy by construction as it uses refcount=
s
> > > and doesn't attempt to lock/synchronize with the IOMMU API as that wi=
ll
> > > be costly, meaning that possibility of false negative exists.
> > >
> > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > ---
> > >   drivers/iommu/iommu-debug-pagealloc.c | 26 +++++++++++++
> > >   drivers/iommu/iommu.c                 | 12 +++++-
> > >   include/linux/iommu-debug-pagealloc.h | 56 ++++++++++++++++++++++++=
+++
> > >   3 files changed, 92 insertions(+), 2 deletions(-)
> > >
> >
> > Remove "drivers/" from the commit title.
> >
> > $ git log --oneline drivers/iommu/iommu.c
>
> My bad, I will fix it.
>
> >
> > [...]
> > > diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/io=
mmu-debug-pagealloc.h
> > > index 83e64d70bf6c..454303ec09c2 100644
> > > --- a/include/linux/iommu-debug-pagealloc.h
> > > +++ b/include/linux/iommu-debug-pagealloc.h
> > > @@ -8,10 +8,66 @@
> > >   #ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> > >   #define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
> > > +struct iommu_domain;
> > > +
> > >   #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> > > +DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> > > +
> > >   extern struct page_ext_operations page_iommu_debug_ops;
> > > +void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys=
,
> > > +                  size_t size);
> > > +void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> > > +                          unsigned long iova, size_t size);
> > > +void __iommu_debug_unmap_end(struct iommu_domain *domain,
> > > +                        unsigned long iova, size_t size, size_t unma=
pped);
> > > +
> > > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > > +                              phys_addr_t phys, size_t size)
> > > +{
> > > +   if (static_branch_unlikely(&iommu_debug_initialized))
> > > +           __iommu_debug_map(domain, phys, size);
> > > +}
> > > +
> > > +static inline void iommu_debug_unmap_begin(struct iommu_domain *doma=
in,
> > > +                                      unsigned long iova, size_t siz=
e)
> > > +{
> > > +   if (static_branch_unlikely(&iommu_debug_initialized))
> > > +           __iommu_debug_unmap_begin(domain, iova, size);
> > > +}
> > > +
> > > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain=
,
> > > +                                    unsigned long iova, size_t size,
> > > +                                    size_t unmapped)
> > > +{
> > > +   if (static_branch_unlikely(&iommu_debug_initialized))
> > > +           __iommu_debug_unmap_end(domain, iova, size, unmapped);
> > > +}
> > > +
> > > +void iommu_debug_init(void);
> > > +
> > > +#else
> > > +static inline void iommu_debug_map(struct iommu_domain *domain,
> > > +                              phys_addr_t phys, size_t size)
> > > +{
> > > +}
> > > +
> > > +static inline void iommu_debug_unmap_begin(struct iommu_domain *doma=
in,
> > > +                                      unsigned long iova, size_t siz=
e)
> > > +{
> > > +}
> > > +
> > > +static inline void iommu_debug_unmap_end(struct iommu_domain *domain=
,
> > > +                                    unsigned long iova, size_t size,
> > > +                                    size_t unmapped)
> > > +{
> > > +}
> > > +
> > > +static inline void iommu_debug_init(void)
> > > +{
> > > +}
> >
> > I suppose that all these should go to drivers/iommu/iommu-priv.h, as
> > they are for use in other files inside the IOMMU subsystem.
>
> It seemed better to have all the feature functions/declarations in one
> isolated file, as it is included outside of the iommu susbsystem also.
> I have no strong opinion, I can keep them in drivers/iommu/iommu-priv.h
> if you think it's better. But then we will have to include also
> "iommu-debug-pagealloc.h" for the static key to avoid including extra
> files to linux/mm.h.
>
> Thanks,
> Mostafa
>

Hi Baolu,

I plan to post a new version soon. So far, I only have the commit
subject rewrites. Do you have any opinion on the header file split or
the unmap size part?

Thanks,
Mostafa

> >
> > > +
> > >   #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> > >   #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> >
> > Thanks,
> > baolu

