Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35C1CA5FAD
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C736B0093; Tue, 29 Sep 2026 22:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D8E6B0095; Tue, 29 Sep 2026 22:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C846B0096; Tue, 29 Sep 2026 22:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6406B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:07:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7140BA70BB
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:07:36 +0000 (UTC)
X-FDA: 85268792112.27.A613550
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F5E21A0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:07:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A291hCAa;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790734054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YIukAMEz2ohSrvRnv+nP5qr963OkcMZXbPN8dwVNfg=;
	b=RjFvPqenQJiLGXJLCTPdTjZNq8f36Wi4+Y5wtBLIoXfhzFnBedaYJ9u4wubiJs/6Eu9MUe
	Qny2AWRQuWYe3T3KNGsfM57S9P2d8k/tLb0rx7NT7r1WxuItLi7f+0GpqF7hhDoiZIadVw
	YjVUlqTzl5L5vKU+gDKCXpd+aWe+EEA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A291hCAa;
	spf=pass (imf19.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790734054;
	b=GkfgiRnj9Vr3Rha+JNr54O3POKjoC94vILLT9CQe+ezpDV3QXN6zzHM3vp5GboWnKvYwuY
	bH7+sWEiKjtO7VKwoCzX+RFXPUNtO+nxXA5lRRlEkqKogqnBtUvAwoqHh6mTRru1Wc2ykO
	+hL4ifAq/8+SOp0jGK97sil90+lqXLA=
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672f4b7091dso2545953d50.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790734053; cv=none;
        d=google.com; s=arc-20260327;
        b=jh3IDiA/rn4e3mg8uv/PiDlkO5a28p5hOxgmZUlTOR/vLb+baYSAo24lbuiTUZANdU
         ghWptnJnR6LZMsRxyez2fU5YZ5IxYVB90hoc7qnzaC2kkroWq4KIXrvmQiltsQJdh3Xy
         XovcxQO0VNpfiHIMRBBzB+7OZ0F/zfCWWDWOuHEdZE3c7gSlosPo1J29/SXJpZB2/ruE
         saAVanYaci7Ad+F3ePDNN9r5Yctqwb3Q+Iu/7Qr3r/rWA4/5U/F9+IyJfPk7/92ArMqL
         3VwwCS6HiC/fo2qrl7+fZAeyfwEh5enJiaK87LwAcFeHpqKHjGW7+PbBXy+TUrZa1OUx
         DcZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1YIukAMEz2ohSrvRnv+nP5qr963OkcMZXbPN8dwVNfg=;
        fh=tMPNvcQWDOVP5uaJMsEn7aSynALDhlGsIzkhvyaouc8=;
        b=KHTNTcBIw3/DOT4HwpSXEqEZ9JqqFUNbKKiq/p78ms7daBsjFn5l6MnG87zdtgCM57
         1/Z8GEMtz/SJyC0QKpj0Wy3A9FhlT4KJHzQzH8OLIkORxcMYOuHh7ELzxc8elmTcDW4Q
         v1KSUXZhQYa9LogxEhTck11IBpOBkYglb5oZBqyy844t9dxFBxRaMwWkd0z1GLN9Dnxe
         UpQJ99XO38cBfI0EAVkUJ0HmZJvArkkDGCDBPTiPrqm4px0yK45ypHimaTQ3s4l+wZG9
         HRXR2vmoUb2irbPgd9dk8rFCD5n2Tq2BQ9n/nNJo8JTc1OTe3u//LIG8wZaO3qIrObws
         1PsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790734053; x=1791338853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1YIukAMEz2ohSrvRnv+nP5qr963OkcMZXbPN8dwVNfg=;
        b=A291hCAabqkNPLtV+Fr0+9HmTFjEvzEOv0FLIhiUhJ8GFmgUnK+zE0aLOB2NtyBlFX
         nh6M/VdjxrIpYci8CkIdqhWCVJvPkNOwO+gt+Nk4nhTPFul7e1UaPT4Vd5GuKeDOIDw9
         GkzydtsbDXdTzwwrq7BNXdH+fdv9vXw6rw7tC3L+LaYnLEAUfby8e9xvX2Ul+HKoU6ao
         5S2o1pCvtIrGlWoGsxcbkFcamn9/ZjLON3NAAOqj26qeM4iawxzNCsEjjwSa8QBG/wwB
         8ILHFYko8Y8a6h+OYLYJPeyVVJ2E+TVxqSruoFTSPyfvDUWPBLH/cxNwCvgBuN6yXcUk
         IbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790734053; x=1791338853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YIukAMEz2ohSrvRnv+nP5qr963OkcMZXbPN8dwVNfg=;
        b=IxXJEJ8FL8uBwaSE3dDSzJjYgp5J5N+pPvC07DGrqlDIPvLIRIdCpnKtfukcvHNK67
         WDPfvkClgLSftx0fHA3rWGfwCScErijsIGye2iXHQpNjX49/AAbPxEm3QYw3ZfFMcv/+
         u5B/S1H6ELysGgJInwd6aaZIg0n7tgltBYLtyA90Znvk596uW+yqnuE8Zo+OLqbKPKNn
         4/uN0b1pcYAVLgop9ky9T2WUikX3Bwb2NY20j1NXtf2nB/5VRIsI3CnuDzI98V2/wWOW
         jJByJAYMjypYdKb050MR68O4HK6JAcWed2f06g0sTCYdkjIyMWrFzJPtIux4TteUrHlq
         DXqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxIm5g0i34MCpPoPWSl8eCKqJDb+PQGvRAEGMAWkW/wqTyztbmbEWrSHcP0JaQ+vqyGunLQA20EMQ==@kvack.org
X-Gm-Message-State: AFq9FYL9F3XJsxMaW3FZhSJLWSY5XZoGbrBrbFZ/rj/Sa3fyLVjVE/gA
	tlEbb7HY7/3WyAbqbEdiptzCo8BYXzyzIwnI1qVf2GLL5ocmel1zG+DiOKhEpUICRhmlkJ2l3XS
	AkOG5evmrH1JcgItY9ck6jiUkV3pYIqc=
X-Gm-Gg: AYBFou0S+I6DPBdZhJFBujtOXdbravs8Z9tXChSa0xPc3eNNk3haZiuvbvRNsjb6lJs
	V6Bi6sPmPnkKPYzPsjrQd4ELVOF1oPBewwxQy6wi0RUSJIZ3Z/Li2/G4wV1ezLxasOjlBiYyFwS
	YY6QHz6DTGHwyv2PqLFsj64f4xYe4GyqvLlef76Feu1f8eZksk3TwWAJh8n2oIit0HO/VphBYLp
	DHFqNUBax8h9MFNkTsfmLBwmIziT6eP++G9OsdCHcYbJekO52zSYTB9J2IfTTED26o6gh5/z+rf
	H4vLE9oXuC4FHdF7oZDMqMu8jREmzED3I3rtxYNC//s2ojOcJROj
X-Received: by 2002:a05:690e:140a:b0:66f:c1bc:4052 with SMTP id
 956f58d0204a3-676839284d3mr2660d50.51.1790734053546; Tue, 29 Sep 2026
 19:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260929143707.450805-1-ekffu200098@gmail.com> <arwuOBkR_VpZZ7fI@gmail.com>
In-Reply-To: <arwuOBkR_VpZZ7fI@gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 30 Sep 2026 11:07:21 +0900
X-Gm-Features: AclHuK9Et28a_tY21I97g5vqPPRV4DcB0pgaxOgeSAZTvHdQ-HecAWOCmd5ifUI
Message-ID: <CABFDxMGOi7+ziTB4s3K6wMyBSE34dvBXTR6wVg-BiZ5=NiPPTw@mail.gmail.com>
Subject: Re: [PATCH] mm/memory: remove unused vmf_insert_mixed_mkwrite()
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F5E21A0004
X-Rspam-User: 
X-Stat-Signature: w9jj7g8hi1shmds3wupj85wek1wpur9f
X-HE-Tag: 1790734054-778241
X-HE-Meta: U2FsdGVkX199t15AoPUC9kvaRrBBzDGOnSfwGD2QAdQffvQ2OCT/DORWMl2duZ52Zy2DCuC7++0yGar4gJQ8dHNAYk68xE3i6G/7tMnbdQwVLe4lBqoeYaRhl0HIUvKlBvMWS3C1tpPJ8vF+QhKxssuHPHVYmTso/iohf8JD7GolbUcfH2kKR1mA++zPtNJG/8d67uViOZbwdIZ/qHEw1GEwO3bLzaQpBRS5U5Mz4EqhfABd+sr50uuQkVXPeHmtycNR0yp9KYsxBDvS+zqwJpBZTS+BC2En9ahN0hfMK6MvLSr0WyVDtlUFfyfWfa/OL69K3g20zq9CDC0FbQgBYWTDgU95hF9fvUU11MbvdApINrVrRZmKK7Ib8ez6kEIISQ7khxaIvHXjXA1Psu2oUgbXoKXm1KUXbgYgle5/0MzJcPbaXPppx2CxMgUcTQvB+XM5WdHhbhD0qDfDeLXJqtCrsB4ux5Ycby66uU6LOttLhN0gDzuFZw7RiL3SIJbrn5VHO0TeIG76nfQg6KjiNdhDRSE2LTnr5DxEiDGovjIHFMNdjMfrpYbndYNSd0vy9iFA+ik9uvXfOtqT5E97fx3PtxqEjLylmoq2p8gYB2jT+LmxHfeYm5qt9SCC5BeO/JOqBA/aynqbf28R0f5W6cGipxgxLb8LiPrl2R+v7yUr5TTztSPtZB0EpYAoLYtXtdup9v+gsDKWBnDcZdLQB2dK3wjiD/fab+QnG8/xa9NBJYSKq+YRdazu0kKK6MzswCwIdBYvQkciyLwI6kOCd7+DNujuJEEWNUMkzGn2X2qdwCmA54KzqqwQ0Gfj2xD1noBPmHETVa4BcTQ1Hop5E1GfAUyiBeU8O+GcCtWkmP3c693f8JJcxIsfITE2moKwsc38MT+xIn9PuMpB2R6QuTpxqZOSXEemoUtAmuZ6bFDwebDoJtP3qsRDuri/sqU0cNxYNlmp7m26nXc+v8K
 0YMC+F9U
 fwhkYbdiHc7p2arl4JP9a9afV3Ck1lS+UyUN0wVc/WEAnxCQ6/vFTaS7tFSweC3kru0n5T4yc4o8SJB9/iK3LjNM+VoMYknFSL3dMZ5iwopxakL4M2ix6Jy30SBN5rhMvS8sBed5QbyyNOA78HLtHxRdHukBv5jp9rz9ta8GdklGQ3VJ+5Ey0ReHK8m373+D6JmWsv+TbXb3Q4KgB7KFj8aCSd/9IvvlpqNJsNtIlwFmP4bsEnvWt+APDPzFiN5MASgxA2yR83h1Xolqb9IE12kMvlQr48yK+njuDg53ofGheL0pkUmOrg6d+cfgHd/t05by0fYgoklFUV6OE8sn3vxDvAgPN+X0ttlhGLO/E3PjLDNv+rLIdgiQSamzGhb4g8ANSok5wmFF4P3y34DLjvYxLkQLx+FMmHsiox4ushCcQY0ILX21W3DW+nqWjmBQXN74aZyHcPqI4SK72k5fnrxDwfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jose

2026=EB=85=84 9=EC=9B=94 30=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 6:53, J=
ose A. Perez de Azpillaga <azpijr@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> On Tue, Sep 29, 2026 at 11:37:06PM +0900, Sang-Heon Jeon wrote:
> > Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> > vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
> > __vm_insert_mixed() and insert_pfn() is always false.
> >
> > So remove the function, the mkwrite argument and the unreachable
> > mkwrite branches. Also merge __vm_insert_mixed() into vmf_insert_mixed(=
).
> >
> > No functional change.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  include/linux/mm.h |  2 --
> >  mm/memory.c        | 76 ++++++++++++----------------------------------
> >  2 files changed, 19 insertions(+), 59 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index c038d06825c3..2ac734efd4ec 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_str=
uct *vma, unsigned long addr,
> >                       unsigned long pfn, pgprot_t pgprot);
> >  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> >                       unsigned long pfn);
> > -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn);
> >  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, uns=
igned long len);
> >
> >  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 330cde31bf8b..1f83a26f8733 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm=
_area_struct *vma, pte_t *pte,
> >               if (!mkwrite)
> >                       return -EBUSY;
> >
> > -             /* see insert_pfn(). */
> > +             /*
> > +              * For read faults on private mappings the PFN passed in =
may
> > +              * not match the PFN we have mapped if the mapped PFN is =
a
> > +              * writeable COW page.  In the mkwrite case we are creati=
ng a
> > +              * writable PTE for a shared mapping and we expect the PF=
Ns to
> > +              * match. If they don't match, we are likely racing with =
block
> > +              * allocation and mapping invalidation.
> > +              */
> >               if (pte_pfn(pteval) !=3D page_to_pfn(page)) {
> >                       WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
> >                       return -EFAULT;
> > @@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma,=
 struct page **pages,
> >  EXPORT_SYMBOL(vm_map_pages_zero);
> >
> >  static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long=
 addr,
> > -                     unsigned long pfn, pgprot_t prot, bool mkwrite)
> > +                     unsigned long pfn, pgprot_t prot)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       pte_t *pte, entry;
> > @@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_str=
uct *vma, unsigned long addr,
> >       if (!pte)
> >               return VM_FAULT_OOM;
> >       entry =3D ptep_get(pte);
> > -     if (!pte_none(entry)) {
> > -             if (mkwrite) {
> > -                     /*
> > -                      * For read faults on private mappings the PFN pa=
ssed
> > -                      * in may not match the PFN we have mapped if the
> > -                      * mapped PFN is a writeable COW page.  In the mk=
write
> > -                      * case we are creating a writable PTE for a shar=
ed
> > -                      * mapping and we expect the PFNs to match. If th=
ey
> > -                      * don't match, we are likely racing with block
> > -                      * allocation and mapping invalidation so just sk=
ip the
> > -                      * update.
> > -                      */
> > -                     if (pte_pfn(entry) !=3D pfn) {
> > -                             WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry))=
);
> > -                             goto out_unlock;
> > -                     }
> > -                     entry =3D pte_mkyoung(entry);
> > -                     entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > -                     if (ptep_set_access_flags(vma, addr, pte, entry, =
1))
> > -                             update_mmu_cache(vma, addr, pte);
> > -             }
> > +     if (!pte_none(entry))
> >               goto out_unlock;
> > -     }
> >
> >       /* Ok, finally just insert the thing.. */
> >       entry =3D pte_mkspecial(pfn_pte(pfn, prot));
> >
> > -     if (mkwrite) {
> > -             entry =3D pte_mkyoung(entry);
> > -             entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
> > -     }
> > -
> >       set_pte_at(mm, addr, pte, entry);
> >       update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page=
? */
> >
> > @@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_str=
uct *vma, unsigned long addr,
> >
> >       pfnmap_setup_cachemode_pfn(pfn, &pgprot);
> >
> > -     return insert_pfn(vma, addr, pfn, pgprot, false);
> > +     return insert_pfn(vma, addr, pfn, pgprot);
> >  }
> >  EXPORT_SYMBOL(vmf_insert_pfn_prot);
> >
> > @@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct =
*vma, unsigned long addr,
> >  }
> >  EXPORT_SYMBOL(vmf_insert_pfn);
> >
> > -static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
> > -                     bool mkwrite)
> > +static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
> >  {
> > -     if (unlikely(is_zero_pfn(pfn)) &&
> > -         (mkwrite || !vm_mixed_zeropage_allowed(vma)))
> > +     if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma)=
)
> >               return false;
> >       /* these checks mirror the abort conditions in vm_normal_page */
> >       if (vma->vm_flags & VM_MIXEDMAP)
> > @@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_struct *=
vma, unsigned long pfn,
> >       return false;
> >  }
> >
> > -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn, bool mkwrite)
> > +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> > +             unsigned long pfn)
> >  {
> >       pgprot_t pgprot =3D vma->vm_page_prot;
> >       int err;
> >
> > -     if (!vm_mixed_ok(vma, pfn, mkwrite))
> > +     if (!vm_mixed_ok(vma, pfn))
> >               return VM_FAULT_SIGBUS;
> >
> >       if (addr < vma->vm_start || addr >=3D vma->vm_end)
> > @@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_are=
a_struct *vma,
> >                * result in pfn_t_has_page() =3D=3D false.
> >                */
> >               page =3D pfn_to_page(pfn);
> > -             err =3D insert_page(vma, addr, page, pgprot, mkwrite);
> > +             err =3D insert_page(vma, addr, page, pgprot, false);
> >       } else {
> > -             return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
> > +             return insert_pfn(vma, addr, pfn, pgprot);
> >       }
> >
> >       if (err =3D=3D -ENOMEM)
> > @@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_are=
a_struct *vma,
> >
> >       return VM_FAULT_NOPAGE;
> >  }
> > +EXPORT_SYMBOL(vmf_insert_mixed);
> >
> >  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *=
page,
> >                       bool write)
> > @@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fau=
lt *vmf, struct page *page,
> >  }
> >  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
> >
> > -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long =
addr,
> > -             unsigned long pfn)
> > -{
> > -     return __vm_insert_mixed(vma, addr, pfn, false);
> > -}
> > -EXPORT_SYMBOL(vmf_insert_mixed);
> > -
> > -/*
> > - *  If the insertion of PTE failed because someone else already added =
a
> > - *  different entry in the mean time, we treat that as success as we a=
ssume
> > - *  the same entry was actually inserted.
> > - */
>
> it reads to me like it describes the -EBUSY handling rather than
> vmf_insert_mixed_mkwrite() itself, and that handling is still there in
> __vm_insert_mixed(), which this patch renames to vmf_insert_mixed(). so
> I would have expected it to move above the "if (err < 0 && err !=3D -EBUS=
Y)"
> there rather than go away with the wrapper.
>
> am I missing a reason to drop it? because, if not, moving it would keep
> one explanation we have for why -EBUSY is not treated as an error there.

No, I just missed it. Moving the comment above the -EBUSY check looks
good to me as well. I'll address it in v2.

> > -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> > -             unsigned long addr, unsigned long pfn)
> > -{
> > -     return __vm_insert_mixed(vma, addr, pfn, true);
> > -}
> > -
> >  /*
> >   * maps a range of physical memory into the requested pages. the old
> >   * mappings are removed. any references to nonexistent pages results
> >
> > base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
> > --
> > 2.43.0
> >
> >
>
> overall, looks good to me. but I want to know about the comment.

Thanks for the review :)

> --
> cheers,
> jose a. p-a

Best regards,
Sang-Heon Jeon

