Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF44CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 15:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0F18E0005; Sun, 12 Oct 2025 11:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371058E0002; Sun, 12 Oct 2025 11:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2603E8E0005; Sun, 12 Oct 2025 11:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B02C8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 11:47:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D3461DBCF1
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:47:30 +0000 (UTC)
X-FDA: 83989891860.03.848C8F0
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8DEA71C000D
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 15:47:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eIyNhTXV;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760284048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Jx1siiS1fIaEuoSsnbHqhfsPiky05Z0AF/a/E5n05I=;
	b=Og9Y0LwTla5bo1zW8jffcwKhcQvKgG9eY+hGPYeX+LOgT0ywvBnxinsSsOlpbd6cIxNzHa
	eKWjOcG5CVfV4preZPfCDhRKuidpzHfGL2nGa25gwfZdDekKk/NpBGfulNMqJ8rGKuaaKC
	IpTbQSl1PJCWXThHidbGFXNEXZj4JwA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eIyNhTXV;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760284048; a=rsa-sha256;
	cv=none;
	b=qdQpTQ1OdyqFOUOlK8AyqzT5IQswq89ROshy8het+Fvvrk1zUIqtMzGnSau6NZRrUUitd9
	6W/Asair99U5wWkNLswsgjb8SWTCu+SMGcLFcV7lvY6DTmFrYagRkzV2Kgmfszose7g5qI
	c5/n/kVV76DM0MJcBXzGc9oTUlfFZlo=
X-Forwarded-Encrypted: i=1; AJvYcCUZJbnGzpNRVsapXTxma18gK16Lz8He2SmNnC3DYT1W8zfXvNglmFmXPQHD8NlpUANcPJKBnE+rTA==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760284045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Jx1siiS1fIaEuoSsnbHqhfsPiky05Z0AF/a/E5n05I=;
	b=eIyNhTXV+VxPqAwIKgaC0uydQO2myo+VjMQzwk1eWdkgFhf7NuHMTDEegu94qDfGLtUUDO
	q06U1b3FtyqCknK3uQiPNNPxaUl4WjKXUIajddo+b4NNKqi1OrE/zWA/oXmsLMmLOPP9Yn
	/Fo4l58Y3BkJWQKlHD+sVMU0MlZBKMU=
X-Gm-Message-State: AOJu0YyGl1qKUdnCulR4h9FILTVmKalbuzqHEZV/z6Nl1fIJHrI8XtT9
	VBFdtyQZ3ud6SW/7UOOCW/jdxc6thMQzp0pjB1TgOrIcVFM3ej5RgZGYuMvc2SFUysDPnnqdbCu
	Wvp4jg3vzINl+wAWZ/7BbquGlk+6ol/g=
X-Google-Smtp-Source: AGHT+IGU4is0tfGyAf+Y4eW/H1uhqTUANrqoJRsnGW1pXXpN0gbGnn4Uzr/64CQuR05MJPbhXZu3PZbIRbRVL68AkiE=
X-Received: by 2002:a05:6214:2121:b0:782:3caf:668e with SMTP id
 6a1803df08f44-87b2efa9a8fmr222378096d6.40.1760284037401; Sun, 12 Oct 2025
 08:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251001065707.920170-1-balbirs@nvidia.com> <20251001065707.920170-4-balbirs@nvidia.com>
In-Reply-To: <20251001065707.920170-4-balbirs@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sun, 12 Oct 2025 23:46:39 +0800
X-Gmail-Original-Message-ID: <CABzRoyYg1o8Oyjx1AQ8or-Vxm94zQXeAx7mWco2qs7=w4mBcMw@mail.gmail.com>
X-Gm-Features: AS18NWAW-r80P4VIv9gONLI57HYmyaK4SvQH1hgWyVYA6Kk8PKp1BoVJHXMPTaE
Message-ID: <CABzRoyYg1o8Oyjx1AQ8or-Vxm94zQXeAx7mWco2qs7=w4mBcMw@mail.gmail.com>
Subject: Re: [v7 03/16] mm/huge_memory: add device-private THP support to PMD operations
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
	Matthew Brost <matthew.brost@intel.com>, Francois Dugast <francois.dugast@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DEA71C000D
X-Stat-Signature: xh469eoatm1gyus59jk6jczduz3tybbx
X-Rspam-User: 
X-HE-Tag: 1760284048-504494
X-HE-Meta: U2FsdGVkX1/3u/YtB3Q9WhGRaVai4D2GrZpebTAzwV6vavHEIK2yagwJOAaP3Cym4jGp4CzokKOWwwMqef3Mqo3JvVJPKaS3LbLTraJ0Xs9+wZvSrLwgwbK2bdMLC/huwW2vxuwZfc/5O4j2C14j2GyvpPg9SlWTkuU6GXFRUAlmwpRhOYpM/Frf7B5WOnKvV80ea1qfVBDh4YUKn4vCvuKABv2eg7X7Td8jPXXghfRfQ+A+iiulH7VZoE8w9yGAUOsSONFFacdc+4WCmq9L7sDOJPolwObp03PeNLtV7jKRhcA/QQLLhqiakBRSDLFwr1DVDyf7vuBcM/bLCOLIggRVZdPMK0ApSFHmN+e62F/jF1e3GGsiaIz+t2OBTCgSkobcnuIyxC/RDBL4FbwsiWHOCgCLqfoPU+SBSBw4K7BrmLdiDtDi6bNGnMXK9yJy6Sd0AlfCcIJlWXqjsLvE5ZiRc6KsAW28cJYe7kYkqmI4knw7nKQagBjK5Wj48/75cwkrzYTa9ddOMqzxKp3XXFtecTTtV8I3ro8T6HVj3UQt2Yzy+KwQl2XVrDMlwD8GCfFdRO5GyFlCEE5/zW/UAIDzsBwin1XB72CPXbPk52B5vM18FG+U99Moh4l13TL7/EKpsVIbpB4GMbjC6qtSRWdHL3dHDHkylqQwGWoa3hK5psaQZ+ZaehXAVeoNTYKzf/wlwxzvaixuI8t5NoDSkeAloBd9NcJPjoZTL+m5CoAxkROy/5heJFL2ufUkBoWmVcqBixVzd2x9+PBoYPNcjTrZwdii9EPOmJxAbCy1xZjZXjKs3M/0/jbiKajdvtfuwXOG5BJjF4Ts/GJkf18Mkq9XB+Ixs1+z4e3kx85xErvaUiZSOK1iarLh92Q3TtgoABganl/rp3vh0OE7sGGoTNyYD0wKeIungLevWzsrIgkjtX5N4oTLwxzd4f7moqclqK2pLDi/LlNE/0+2Dk/
 8rt1LI/J
 P6RiCrMHc15q6JMNGAHPB38Vnq3Kl/4ly91XOOXGKoOFtWd1EA1YIZdUbEcCJTGbXN8/h9Q5WN+l0agViT1kAo90Rr5dCj9qKEHYzEdCdIF3/2zQljKV1NdNC0hsSvwa7WY+AxdtFPA1LqbPsULh31s3frU/j9prfhs+GWgiw4F397pXOE3BqOTyexdw3aGsoJj4riqhMjVvQbgVkZGPr7FJYgAO7cbhsLhvziLiasBPpFRQ19Fmr422YDqjpf3XBU/+mO+QLs5p+yYpa0V5Z/2GfDwJmgByZ58WO3wNCjIGgbG9PI+04R14r6jj8XLPf97VXWPZqcA0zhiqu+K9hasRsC7R8qF23reQyUpAyS1sUdmSp8+DyOOOkffV5FrvsGhZzq2NviEQT7Xgp2NMLU3d4D8SocqOnTHYHrN6mY03fDnv9j9lBOMjDZLhAIx4LjF2BYEbLuJD0vmXMPjBsMEaBCny+qXV0P5SQ6KLMCELIE9eadD+j3chMySjJhch3CdtwkY9Z80QtNJhF1KX8duCk3BrlAlhYJe62vP0HUK/eRzKziC8JjKBNCJvs1TGy/rpn6Y0uaOL8fws+USiHAn+0dYGfLIJ59U5bEZcxlLU1IZA134HX9PnyRk8694Qr6JjGnL63sd8kkrCrnK4XTD+aIm5TiaEazC5XFjl9NNzztUjKe9MlQ7clmif1ttIRKpl2GYrhfjKA+/0ddFOvl/Apew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 1, 2025 at 4:20=E2=80=AFPM Balbir Singh <balbirs@nvidia.com> wr=
ote:
>
> Extend core huge page management functions to handle device-private THP
> entries.  This enables proper handling of large device-private folios in
> fundamental MM operations.
>
> The following functions have been updated:
>
> - copy_huge_pmd(): Handle device-private entries during fork/clone
> - zap_huge_pmd(): Properly free device-private THP during munmap
> - change_huge_pmd(): Support protection changes on device-private THP
> - __pte_offset_map(): Add device-private entry awareness
>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/swapops.h | 32 +++++++++++++++++++++++
>  mm/huge_memory.c        | 56 ++++++++++++++++++++++++++++++++++-------
>  mm/pgtable-generic.c    |  2 +-
>  3 files changed, 80 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 64ea151a7ae3..2687928a8146 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -594,10 +594,42 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>
> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRAT=
ION)
> +
> +/**
> + * is_pmd_device_private_entry() - Check if PMD contains a device privat=
e swap entry
> + * @pmd: The PMD to check
> + *
> + * Returns true if the PMD contains a swap entry that represents a devic=
e private
> + * page mapping. This is used for zone device private pages that have be=
en
> + * swapped out but still need special handling during various memory man=
agement
> + * operations.
> + *
> + * Return: 1 if PMD contains device private entry, 0 otherwise
> + */
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +       return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_ent=
ry(pmd));
> +}
> +
> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +       return 0;
> +}
> +
> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
>  static inline int non_swap_entry(swp_entry_t entry)
>  {
>         return swp_type(entry) >=3D MAX_SWAPFILES;
>  }
>
> +static inline int is_pmd_non_present_folio_entry(pmd_t pmd)
> +{
> +       return is_pmd_migration_entry(pmd) || is_pmd_device_private_entry=
(pmd);
> +}
> +
>  #endif /* CONFIG_MMU */
>  #endif /* _LINUX_SWAPOPS_H */
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..8e0a1747762d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1703,17 +1703,45 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struc=
t mm_struct *src_mm,
>         if (unlikely(is_swap_pmd(pmd))) {
>                 swp_entry_t entry =3D pmd_to_swp_entry(pmd);
>
> -               VM_BUG_ON(!is_pmd_migration_entry(pmd));
> -               if (!is_readable_migration_entry(entry)) {
> -                       entry =3D make_readable_migration_entry(
> -                                                       swp_offset(entry)=
);
> +               VM_WARN_ON(!is_pmd_non_present_folio_entry(pmd));
> +
> +               if (is_writable_migration_entry(entry) ||
> +                   is_readable_exclusive_migration_entry(entry)) {
> +                       entry =3D make_readable_migration_entry(swp_offse=
t(entry));
>                         pmd =3D swp_entry_to_pmd(entry);
>                         if (pmd_swp_soft_dirty(*src_pmd))
>                                 pmd =3D pmd_swp_mksoft_dirty(pmd);
>                         if (pmd_swp_uffd_wp(*src_pmd))
>                                 pmd =3D pmd_swp_mkuffd_wp(pmd);
>                         set_pmd_at(src_mm, addr, src_pmd, pmd);
> +               } else if (is_device_private_entry(entry)) {
> +                       /*
> +                        * For device private entries, since there are no
> +                        * read exclusive entries, writable =3D !readable
> +                        */
> +                       if (is_writable_device_private_entry(entry)) {
> +                               entry =3D make_readable_device_private_en=
try(swp_offset(entry));
> +                               pmd =3D swp_entry_to_pmd(entry);
> +
> +                               if (pmd_swp_soft_dirty(*src_pmd))
> +                                       pmd =3D pmd_swp_mksoft_dirty(pmd)=
;
> +                               if (pmd_swp_uffd_wp(*src_pmd))
> +                                       pmd =3D pmd_swp_mkuffd_wp(pmd);
> +                               set_pmd_at(src_mm, addr, src_pmd, pmd);
> +                       }
> +
> +                       src_folio =3D pfn_swap_entry_folio(entry);
> +                       VM_WARN_ON(!folio_test_large(src_folio));
> +
> +                       folio_get(src_folio);
> +                       /*
> +                        * folio_try_dup_anon_rmap_pmd does not fail for
> +                        * device private entries.
> +                        */
> +                       folio_try_dup_anon_rmap_pmd(src_folio, &src_folio=
->page,
> +                                                       dst_vma, src_vma)=
;
>                 }
> +
>                 add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>                 mm_inc_nr_ptes(dst_mm);
>                 pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> @@ -2211,15 +2239,16 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct v=
m_area_struct *vma,
>                         folio_remove_rmap_pmd(folio, page, vma);
>                         WARN_ON_ONCE(folio_mapcount(folio) < 0);
>                         VM_BUG_ON_PAGE(!PageHead(page), page);
> -               } else if (thp_migration_supported()) {
> +               } else if (is_pmd_non_present_folio_entry(orig_pmd)) {
>                         swp_entry_t entry;
>
> -                       VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>                         entry =3D pmd_to_swp_entry(orig_pmd);
>                         folio =3D pfn_swap_entry_folio(entry);
>                         flush_needed =3D 0;
> -               } else
> -                       WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
> +
> +                       if (!thp_migration_supported())
> +                               WARN_ONCE(1, "Non present huge pmd withou=
t pmd migration enabled!");
> +               }
>
>                 if (folio_test_anon(folio)) {
>                         zap_deposited_table(tlb->mm, pmd);
> @@ -2239,6 +2268,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>                                 folio_mark_accessed(folio);
>                 }
>
> +               if (folio_is_device_private(folio)) {
> +                       folio_remove_rmap_pmd(folio, &folio->page, vma);
> +                       WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +                       folio_put(folio);
> +               }

IIUC, a device-private THP is always anonymous, right? would it make sense
to move this folio_is_device_private() block inside the folio_test_anon()
check above?

> +
>                 spin_unlock(ptl);
>                 if (flush_needed)
>                         tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD=
_SIZE);
> @@ -2367,7 +2402,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                 struct folio *folio =3D pfn_swap_entry_folio(entry);
>                 pmd_t newpmd;
>
> -               VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> +               VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
>                 if (is_writable_migration_entry(entry)) {
>                         /*
>                          * A protection check is difficult so
> @@ -2380,6 +2415,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>                         newpmd =3D swp_entry_to_pmd(entry);
>                         if (pmd_swp_soft_dirty(*pmd))
>                                 newpmd =3D pmd_swp_mksoft_dirty(newpmd);
> +               } else if (is_writable_device_private_entry(entry)) {
> +                       entry =3D make_readable_device_private_entry(swp_=
offset(entry));
> +                       newpmd =3D swp_entry_to_pmd(entry);
>                 } else {
>                         newpmd =3D *pmd;
>                 }
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..0c847cdf4fd3 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long ad=
dr, pmd_t *pmdvalp)
>
>         if (pmdvalp)
>                 *pmdvalp =3D pmdval;
> -       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
> +       if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
>                 goto nomap;
>         if (unlikely(pmd_trans_huge(pmdval)))
>                 goto nomap;
> --
> 2.51.0
>
>

