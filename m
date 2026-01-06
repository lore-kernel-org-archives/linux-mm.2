Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C1ECEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA2F6B0005; Tue,  6 Jan 2026 16:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA15B6B0092; Tue,  6 Jan 2026 16:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99DBA6B0093; Tue,  6 Jan 2026 16:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE256B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:18:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBF5113C213
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:18:47 +0000 (UTC)
X-FDA: 84302803494.05.1171654
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 01E4E18000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:18:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dxoHVyBQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767734326; a=rsa-sha256;
	cv=pass;
	b=gzvTTPL2fyK9NOXpzsr/JrH7FtaoE5meFT7Gwf4Wd7Kvat+v3vWZ1G8XbIULVKV5IGcfZZ
	S0Z9wHa8KidQb6RskTKFGyjflCo4s52mzMFwtbw/TMo1x2xe4OYARFywySKmvm/AyX6TEX
	bJyciChSm6YtHBF/w3aPvwP+qcW3VcM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dxoHVyBQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGVuujQe5nx9sEZAaa25hNtXumT1G+7mUeDPEY80VTs=;
	b=8D6MBuGm9Y1YL+Jvfa2uWbVJ9036JQGeTI6heNKO3WLu1mszVT9i/X+CTIDXziyJZf76Fg
	rEymnXN1RcgfCanHJUvZPs2iyWRrCFUHTNPP1IsKz998wCoaLrHxk1bVPwkS5ebr3OdVbN
	kWwfE+k4EWMRYKWB+tmJpuKU43kS9bw=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-121adc0f1e5so1971c88.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 13:18:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767734325; cv=none;
        d=google.com; s=arc-20240605;
        b=hXAkOeiIGsXWJr72iL8B/c4Rx/QoCBvIV9hWyX8WaFxNGRW/DV5jw62vjrhMunK5T2
         oHSA02Q+whjHTCMoGvJMLYRCTSLG21H20VFZNqxrs5v/TPvd+WzQSux4+3oUzXEXbx6t
         ij5qnnRIUDX3fZ29L1TIHke1n64pOehiAuPQg1u5sWlU49Pcw9MZEwaEXO4fmvYlI/pz
         holPnY9oeBMxsebAeYB4drBLTReuG+xyaQVjmKL0CjuJuthsZBa6mMbWifV3ktULmQRK
         ipZQb8OiTd2Mw3dGLq/C2ZYmkP2jAcWRbq2YXKqjUC1COQJXEzP/s0Zhm66UeWygfi8u
         9U7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VGVuujQe5nx9sEZAaa25hNtXumT1G+7mUeDPEY80VTs=;
        fh=OQMuTinT6gLvcT0MMsKyU/xx7WbR9+BLBw5abz+qnfM=;
        b=EKvsg6lfQQ5g2Ucsc6qUcAyJoU+6ewVvNhee6HwtNp5D3A8+JTOXuJ6kBtd8i2NoEe
         yt6rMopyF0xM5Ek0a3NTdel97vPd28QMigLYhjZwxv1OE/c5kH/deeo49arp9eYZXTXT
         RnWjm+TnYmGDt1U7EniPPos1GNgI4U8Q8V97MQ3+Ep95t7kT91AUZvqLzeVsD1W+Osb0
         +aLyPaij1PTIZCnqKW3oZPJXxLeOhAIW04+zqDpM8DJwuuVxPlkV47Pri9GhH4OmUmy0
         BmYL/QHoQyGEJo38Aegb79UmUotXchmpiCNhZ3nX6i35NkPL2i+m2LUAfDXwzw5g7Y+T
         msjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767734325; x=1768339125; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VGVuujQe5nx9sEZAaa25hNtXumT1G+7mUeDPEY80VTs=;
        b=dxoHVyBQOd5zW4+yTEtemxJ+wxHeg/Lvepj8Uo8a3WKRLu+KAhanEtmwvE5R2pHx2E
         ST0CDm+KXCg014v1SgpkLLEh7VEppjZ3GoyGr4J9/hpXmGZr0dYqU87DeJYXie32TbhQ
         ZWpGBuAVcn5u0w0/KyEnJW9JJrd708tTprWRCbP7m1RMHHwlmkmPfQUfqyqyfi5YAGfZ
         ApbvgE4npOy8McjPYPITIYCFR0UMk3GjB/uLGRlz7jBdIICXl9j83Tj3wOG4oUnYDYw5
         ZmTsPDRtOLztpRFnDn3VWx9y4ZKyCkdNEkYzp7J3oneQV/SYHWGRPdVk9Iu1MH5NHwgn
         bMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767734325; x=1768339125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VGVuujQe5nx9sEZAaa25hNtXumT1G+7mUeDPEY80VTs=;
        b=sGeROQ3bi0VbUzPG/bQUtuQhDNd+JoOaMukhs9oB0jRDM26Kfym+BQyS8bjGKu9WEt
         1UMXTTqDrU6xMXxIVsNVVtdds9JrZ69Nojiw8I3kY5F7MIhBM8mctrbCm6gpnqbYBcPB
         htFsA4QcDXsAJSlbvJEPCO2pQ+kCbcm3i/Xthp8PJWST3T5qX9om1C1o+/QbYjYF2lkV
         DmBcmDbCaJUJ9scDwfgHXhpyiQD5kbN0Rkwj6SPDRJNu1JEd+AxXw3Ymix09yDppzq+B
         tCV68dwhFrvYVEf5ksc6AzVDLVdTcCMYdnAvlas308M1TCXk9n10925ypYWPaKtUTcPl
         IGRQ==
X-Gm-Message-State: AOJu0Ywg4bHiZQ4bl291V9W5r18FD8Nr0qRIQfsCLA7MmcNx1r5SrIxw
	z/Suu1gjAwPGN+B3j2mEkQ8Me1CbA141zH6a38vk9JZebeTGPhTVGtLnainlC9btYkeVUutclPe
	UGQHLQhdyFL42RBi1WecX2J6GxQ5eZPTlzLDczYjw
X-Gm-Gg: AY/fxX65L/Sf3rZWmyYCmQUp/olx/eIe/OchMMLc120/VhMxtNIrQRm6QCcSk4zFK1H
	6SY/4sU1bspA+0kTfc26H7hwxE3N/I99mouLKN5ElTFdXJHtt/25PzF0FNStwnsgYaAaJWq2H7/
	ClVBu34J0GoIM7n9jFP2DMdxdXSExNxzeBsvM1EcrfR5sYlSRGl5BsG/oXcz1xrdGdBDemsLjGy
	NVVV9+jgChgO+QaaahTLD3Sd6vK9F8dakQlSkQgVLGKH+ocruB74NW6F6YwwSU1GR4WYPMkxp8d
	Nf1G/tnJD2GZL83t7y3Rc0k=
X-Received: by 2002:a05:7022:49a:b0:11f:25fe:952f with SMTP id
 a92af1059eb24-121f8640d66mr27564c88.8.1767734324206; Tue, 06 Jan 2026
 13:18:44 -0800 (PST)
MIME-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com> <20260106162200.2223655-4-smostafa@google.com>
In-Reply-To: <20260106162200.2223655-4-smostafa@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Tue, 6 Jan 2026 13:18:29 -0800
X-Gm-Features: AQt7F2o1wSEXREnLHU0_pBEPtmmqdHD2M-tusioq9HwIDAwG5VqNr9DDjNwqNyE
Message-ID: <CAAywjhRceyE7WRaFY+Kyy=hGbMjzT9MJDC=+Y4kbXwvOxuDRSA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01E4E18000B
X-Stat-Signature: mq8ydfzfwp5j4ykma9arkzaycsr9qass
X-Rspam-User: 
X-HE-Tag: 1767734325-639905
X-HE-Meta: U2FsdGVkX1+0tl9nYc1G5Tf9kE3oQwYxkeu+eIXeErW7tIZ9o5DuvyFR4PqWLMktAe7MvXSE+afvJatftPXSOMXwbmUWZTtA+PMIE08bfnAxARar5fYo+5NQE1uyEQDgdd+/jQTIha+9UyEP/Q4z5v+idbCQ3YNETVst1DQWaO8zT0/Y/EfhTVyPc20GaOTlcaTOLrC2GByp8MEkUNcS7yGh0ia3ELfu1tQiJpgIXla1LUWAt34PZ6fZvnnKmpN9pkRTTowbA6YNcEvg4OYVqW1S2Uo+k9VsRMynbcBBI5lO9qyDd1iV6iQv6jmWTE8VtA+Xz0cAnswuuHzZGsJyIw+EFc2KLtCvod/x59dBL6wOfUDSE8XMesfjCUzPKT0sdnB2Ox4na1qXnPRvztghGPHxLT7F/Ku+Og4+obHYJEKluxgK8Ejz9WlhalNbugILu9RNOEVYwoSZxpXjEh4ImszQMoZGnBuKkhcNbRdKmv6qG/ASD1e2TZ25Uqyf+Zw7YsSGRQ6G3fzzn7VXyZoCAu66ChexHMc9kvRphOYPYhUk6ZNtGtR4NQxC1ed975rF0TOlE7okVFBtxbmTL1KNES87KUTs4zSaBGS1Y74xcMSoLSLTbicLOOfZwXo/ZdCVOSMDqMFz6U4Wsk3egQZ939Y/YP4IETVpMBlkWkLR+vN2II/oNx419vmvEJlHvslXTBLqdjD24swMMbwr66vwWpxZWGxpPYVziswZmAKOb/RIkOd+s+KroEgT9j93CDU2ZWs2ry1dDGq7/BiMQxRy8CUjRXg7BMInE0anSjf6Ob1VAbRUoLBQ/mkY02/PwAkqjucuAMDzwwN17S+CPgxXlMKYPyf/XUpM1Z9FNHk2TSucWhHTqOwjIz/9yBjQFJ957ncSWExyuvKcT0GyoNMLEQx06iIDLBUKYHy3hLlJtzXZJK6c6P+ROLjHQp+cB4Qen8Z+ptSynWw4QbogbG5
 xrK26JRD
 wpr+sZdaUVU1z/EqeGdlAjCg9lSuk9mL3YiCEfCnVlUj6k8fHI9B3vKTljFDsNSJU5pcSvb7XShDJhvuqE2sR0mNrDK4/Ymz/4//nTSpkY34NIhxdQT2Bgrhrvdvm5eTCrU2Lc/vqmgGPovhygdCaachbJiUvKxZ1q6KwDy+uMqEJ9pyNKbB9RGR9r6ug6TQY12B+V/gU867jgKjtWGH6o6IIEJYo7oSbINzMn8i/1KsmCI39AOJwzIep4FvcGSJ0V8SCENdNOtP3iM/XPtpboFFqJzIPq+ENw9sl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 8:22=E2=80=AFAM Mostafa Saleh <smostafa@google.com> =
wrote:
>
> Using the new calls, use an atomic refcount to track how many times
> a page is mapped in any of the IOMMUs.
>
> For unmap we need to use iova_to_phys() to get the physical address
> of the pages.
>
> We use the smallest supported page size as the granularity of tracking
> per domain.
> This is important as it is possible to map pages and unmap them with
> larger sizes (as in map_sg()) cases.
>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
>
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-=
debug-pagealloc.c
> index 1d343421da98..86ccb310a4a8 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops =3D =
{
>         .need =3D need_iommu_debug,
>  };
>
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +       struct page *page =3D phys_to_page(phys);
> +       struct page_ext *page_ext =3D page_ext_get(page);
> +
> +       return page_ext;
> +}
> +
> +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page=
_ext)
> +{
> +       return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +       struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> +       struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> +
> +       WARN_ON(atomic_inc_return_relaxed(&d->ref) <=3D 0);
> +       page_ext_put(page_ext);
> +}
> +
> +static void iommu_debug_dec_page(phys_addr_t phys)
> +{
> +       struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> +       struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> +
> +       WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> +       page_ext_put(page_ext);
> +}
> +
> +/*
> + * IOMMU page size doesn't have to match the CPU page size. So, we use
> + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> + * That is important as both map and unmap has to use the same page size
> + * to update the refcount to avoid double counting the same page.
> + * And as we can't know from iommu_unmap() what was the original page si=
ze
> + * used for map, we just use the minimum supported one for both.
> + */
> +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> +{
> +       return 1UL << __ffs(domain->pgsize_bitmap);
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, si=
ze_t size)
>  {
> +       size_t off, end;
> +       size_t page_size =3D iommu_debug_page_size(domain);
> +
> +       if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
> +               return;
> +
> +       for (off =3D 0 ; off < size ; off +=3D page_size) {
> +               if (!pfn_valid(__phys_to_pfn(phys + off)))
> +                       continue;
> +               iommu_debug_inc_page(phys + off);
> +       }
> +}
> +
> +static void __iommu_debug_update_iova(struct iommu_domain *domain,
> +                                     unsigned long iova, size_t size, bo=
ol inc)
> +{
> +       size_t off, end;
> +       size_t page_size =3D iommu_debug_page_size(domain);
> +
> +       if (WARN_ON(check_add_overflow(iova, size, &end)))
> +               return;
> +
> +       for (off =3D 0 ; off < size ; off +=3D page_size) {
> +               phys_addr_t phys =3D iommu_iova_to_phys(domain, iova + of=
f);
> +
> +               if (!phys || !pfn_valid(__phys_to_pfn(phys)))
> +                       continue;
> +
> +               if (inc)
> +                       iommu_debug_inc_page(phys);
> +               else
> +                       iommu_debug_dec_page(phys);
> +       }
>  }
>
>  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>                                unsigned long iova, size_t size)
>  {
> +       __iommu_debug_update_iova(domain, iova, size, false);
>  }
>
>  void __iommu_debug_unmap_end(struct iommu_domain *domain,
>                              unsigned long iova, size_t size,
>                              size_t unmapped)
>  {
> +       if (unmapped =3D=3D size)
> +               return;
> +
> +       /*
> +        * If unmap failed, re-increment the refcount, but if it unmapped
> +        * larger size, decrement the extra part.
> +        */
> +       if (unmapped < size)
> +               __iommu_debug_update_iova(domain, iova + unmapped,
> +                                         size - unmapped, true);
> +       else
> +               __iommu_debug_update_iova(domain, iova + size,
> +                                         unmapped - size, false);
>  }
>
>  void iommu_debug_init(void)
> --
> 2.52.0.351.gbe84eed79e-goog
>
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

