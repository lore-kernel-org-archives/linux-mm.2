Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979B51061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 03:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B80996B008C; Mon, 30 Mar 2026 23:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57D06B0095; Mon, 30 Mar 2026 23:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D896B0096; Mon, 30 Mar 2026 23:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 961646B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:16:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 338A7E0BD4
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:16:49 +0000 (UTC)
X-FDA: 84604896138.14.52683ED
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id E23884000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:16:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XG46W5zC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774927007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjkCSJGTx0kYz2G9Pyleds319xKwqsILqbgvz8ReooQ=;
	b=fmseQvvKvXkoSnSyvvSkk63Yj6m53/f/0+9cRE/C7W4oCk8NOzpYnc5W22gVhjRCKNFzN3
	DPUBsoNZf3w27x2CSqy2YRgKWnN7kH8n3iQ9ry9TzGYOnP9r3AbTYrnYtUijMlGK8ZnIe+
	ndNAtewW7KdkqYG9dXtskXaLhxB5FYE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774927007; a=rsa-sha256;
	cv=pass;
	b=PmtuQ08yahZKx9zR6PtMGE+mQxzW+YInN/zhmiBqg1EJ+NDPCb4/ohMbGW1+WuKyIx0JVS
	jBAHgxS6E3Pd7D7e/lf4vWQOUSPc92bEojHu4A8hjBTRN2Shxw4zOm4uTZZb0A3yfQzZ+z
	9NNCLEzxXCyr7DIiSl0B1oaxPYRJtWA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XG46W5zC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82985f42664so2891753b3a.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:16:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774927006; cv=none;
        d=google.com; s=arc-20240605;
        b=N6yLBdb8TQYSDbiD/dZsBSkElwmfEvgyZgljuMG7VIGioYzzTsLnZ39BbpXc5AX0kH
         SDV1p5EVKjSEB+E/UWHfULSzuWS1WA24CR18W5hOfJYc6ZBOVSka6+o78l4zhhsMwU5C
         tkuc7SsCFMXR7TqE/3nmFWZcWuNW8N+vebK8YFH596QMxrkRhX2g61aHQp54OU8M5R+3
         T5bPtqNsJrdtqkQTlvg8S7r5znsnEvmVN/XDB0AknYOHoYMcJ5fz0YWq1q0y8YvijHDc
         S8WD3+vipCP6umLKjYVBJjKBoL6zKz5vdz4EQvrQaOUguerjtvV9Uk//JlkEHWaHRHRM
         4dWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jjkCSJGTx0kYz2G9Pyleds319xKwqsILqbgvz8ReooQ=;
        fh=8shDcp8PBoddi8R+IYx4+Vuvc6Tx90dCdmzY7dLWKwk=;
        b=Tt/e5B1h3XUI/mz55izNwTiqeNANKMn2ddR5m2/BkL693T3y29gqwApGdLDWBw3DGV
         C5Hqu5mWC/7etubUEt60LFutcZCIft5lgsTfpZRsqyzVQ3POEYky6agm95qTRSGDQioT
         DFTydNYUJjIBVhDkS/H3CL1kuqHgXOJdiXlMlO3nh4r6Ou+fF3t6RSBBt5Cwmee+R5i3
         +81JMmhN98XC49CgYyV0KGzxc3qCIOfquYTJTuhW+QsvXn1YzrgeVIRZuvcpU90OdgeF
         FYjmfHjoWrojASBt6sxwL6FOC3bvGvCDB5V+hhC5adBtwXf+730WR1aGCla8HkOXwYtS
         v5ow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774927006; x=1775531806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jjkCSJGTx0kYz2G9Pyleds319xKwqsILqbgvz8ReooQ=;
        b=XG46W5zCf9fzMb2Usx5wXExFISOGtV0ehwP9/vXxytGOzsPN1hP6MnSqxDHzTeJrBn
         BaCoFrv5t7b5Lh1hVYccGESfJQMq27+Z3cMj7C3PlUDHE2g/zkmp7mueLEB79rdscx2J
         xqbPxjIR4uW9liW5f+bM/vKFrGAe27lg8Q+O0QzxiY30BFngx0b1DAq7q8RZJAioCy1t
         vj0S2UGlVDoo3HaaEY/TNLRZE/ukqNeJc8rKSL86B/FQHV/WtuNy9ApzP25zg3e34/OZ
         StVqN6sYT3HJ9CXjcblH4ByvWXAvka6FKocFNeHxB5S2gerpg/ka101GKb9DABe6MbkH
         9ikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774927006; x=1775531806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jjkCSJGTx0kYz2G9Pyleds319xKwqsILqbgvz8ReooQ=;
        b=nfJI82wKliGMA/zl/ZLV/CIldGAnk91qAkWUWAOS9MsYq7jEl9Wq1yC8QOzGXAlNpR
         4W8APMsFLeZEH6ZkdWezleFz5DkovDUkkStXEl0p/XSJ0t4Gz7tYDFJqucrUxVwz9ApB
         wbpiGGpFa/N/4sLOVTyz2SvxKs7bKtbfNlVHh5asnwHdAACnMPmPmr71fOjB2s8hZ9J4
         ldDXeVAgze9K/wYD1uyuQ4xqCaHWPUChS/p4Xxtv0f5/9iCOQ8DDGdRiRpOoKD11NMWl
         /CCooSur07vXZ4VUtinoKtSf655myoPOxMcLbiVJWHNHuryzKryCTf9Wd+U9kBYGJcOI
         BJpQ==
X-Gm-Message-State: AOJu0Yzv1g9Dap+TlC2o7z2EmmQK+COYcpFT7k8Ylvg0BhvAMFJJPyhG
	uEk34J3PL9L+ojI2U2ZM1q8ZYB0MhhgK5/JfQyiiWmpTFWcq0RAIawOGP7zQfSZCQQHSY9EwDO3
	uKIc2UjI0wvrFo/zcLk/qrb2l6PdJ/P2qqt+7
X-Gm-Gg: ATEYQzwvxs1YwOhdHQxDvjcdPoERLlr1MBS1OSZMz7PDbkqoIlDvoWRCsoTUuKA2iDw
	0Tvm10NxxTgq2bQpmGa1woyud3rOsSsdpxwWMVfrosJwKVu3Rc35Lwi5vtFp8wyRILKOVn+eNjg
	aMfVvlnF0TFUl2qL1Bte1m4PPOjbLr16UdnmoDxbfVCN6CTnvKRkmv3XJ7+b3J/EFjlDkXYf9cT
	Wmhw9Wf2/qJJriAwxZnXPQOPu4rv1f+C+4zi0P2GQXS69z0IVdvY0ZoZe5220AYvEG+kED6je5g
	49P1jxGJlivJw7ZU
X-Received: by 2002:a05:6a00:3699:b0:82a:6167:b1ae with SMTP id
 d2e1a72fcca58-82c95d465c0mr13377941b3a.24.1774927005577; Mon, 30 Mar 2026
 20:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260201063532.44807-1-pilgrimtao@gmail.com> <20260201063532.44807-3-pilgrimtao@gmail.com>
In-Reply-To: <20260201063532.44807-3-pilgrimtao@gmail.com>
From: Chengkaitao <pilgrimtao@gmail.com>
Date: Tue, 31 Mar 2026 11:16:33 +0800
X-Gm-Features: AQROBzBAxGIDAH3ts6Ui9lBm3gfklFisQpwjANMscsN6aLMHkfss2YVM3lRECS8
Message-ID: <CAAWJmAaOL_NUtJZfHguSdPUsNVCSU0U=GWnTeVAKhnGgwSKeEg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] mm: Convert vmemmap_p?d_populate() to static functions
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, "David Hildenbrand (Red Hat)" <david@kernel.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E23884000A
X-Stat-Signature: 8pqzsqordasqb85pt3377t3abciyq76b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774927006-458311
X-HE-Meta: U2FsdGVkX188QqG/NyFe1Qo+irnELiQRHDRu37rP9wiErGVcXrOuvBcmdcmGV81uVFV8cQQHlPOp6jJrt/FTbg+wCccbX7S7RsXuvRhHQh0I5Wa6gsYHgI9D9FHCS0YBI8wyAN/x+I73AdZ6wIrRGx347N4gBYYzVHbocCcQcEGJs/nbv9wOMGKUfJ/qTmviA/lWAEAjnE5Tu/zoU72+PGJuQQMwFi0pPXROwxGBQeJv9Ft59QjgxhMIBbkb7R/j5HxNxG44ik1XKtPQq9/Asa+lad0AswwyPzI62aHp1ot2Se+rY9GNubDZDFDqLGlY19qKwKrA8wMzkFdpKpWoxnehWxCIqZJ5UCDrN6iUtkqRqdkqaVcaVZQpc3fb43pE+yckOfRWGeTtZXPKB0aA3FqrRkjb1TJXNLqh73dA+2iZjQVWW5aE1JvpKRv6prqi0kSriBzMI9ezRaICeUGwG1k1DLFx2DLvZyUWSDlPlNDJ+stDrrpyjK6qJFE/lV9Qqxwetma8ZP7b+uZ1wBTCfupb1MsMzhflmNpvwNPMGF0G2F5HjX7LWfw2S1WHiTF8/TRsrYq37Q7rjexl5Iu/LiqlY70ozMcoNLyAjMWoKOKSa2Fj++4ce1H8388h9EbUal5aJXCqPL6553I5cDhVYrET1ovGmOHYCpdR2oPXvOzR0iwkm6muhkQAoF1nxppnWz57w1gltEH+XfOMejkILuJlkd61me8pJhScr7nTI8euDhQ0FTPpVWP/r4oDdCfJFiF5CLLveYMfEjyiCREXavl4Zt7o1FxNNaacuAVc4tHzOhl4WNURuM3DH3bCNTW8dcx6iXcSbR3LvNOHCVuTzW3i63mXEDdN98H+WwZhXZ4az5bF1i9FNFsF1xkz8XQInK9H+50Wy05cKvtpQ8ucWCqgA9ZF5IlX9CprH6eDQaZJTwzZUncU0l9luYFnX2vz5YxRdZb7RzfcUrbdrK2
 r2SgKqOD
 Y1akm8r/7IwUsBDo+Eku6fhYbMGiDc0bjUSvOiee13m8uP604n7rRhp892kTncVnO4lQBqnLEhiCl3FpbbwFwq6pSRZfsZ1PSVnDDMqTdtu1Z5VSaCFRkNSB8t1KffWynZvXyscHpO+Jwdx13F0oewhYL6rkRZU8gy0m9smS7Jv9Fg3b1ct5iTO6Vb/Kh4+F0Km7uWDLXJABoIbsZGcbdi+IFZ4UUCgb5zcLCbBaQz+Q98fUIN1rTJuJ3rFfK0MAqlvQqcXOeteKmVJutPEe9Cee7A+Zjj5kFq51474Da1wwOOuzWy+RS5dgPBKcJ0mwGR2mXcSUzSz/K5wlHGre/g7iB+B5NUOFZbsNXHehPO37CG/iKdUPI/v8riPs+N9uIWi55GfZYrKpjQVet650oMeeMzmWO8b4DLNCVBQg3z+425XbvPRcf1nCzQgQB/MiEKUzsUaED76fwP2HfxlljFGnkmTpLjLjEeksLF4Y2mOM323CDxZWQ3HMzkhhH6NOivo+swJVt0LRq0FvQb3sl5qNvv0nPaWBBDCWffJ263B1mOmvJt7HUhtvP4gLFl6bsGYCJKLJM7a88c6SznLdcMy3TLinQwtbnIQYs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew Morton=EF=BC=8C

I noticed this patch was dropped; the failure report is here:
https://lore.kernel.org/all/202603251338.grra8xt7-lkp@intel.com/#R

Could this be a false positive? The series has two patches: the first
one already removed references to vmemmap_p?d_populate() on sparc; see:
https://lore.kernel.org/all/20260201063532.44807-3-pilgrimtao@gmail.com/T/#=
mefaa36aeff173d08f0508cd44be46e830c067fe9

Might the build error be because only the second patch was applied,
without the first?

On Sun, Feb 1, 2026 at 2:35=E2=80=AFPM chengkaitao <pilgrimtao@gmail.com> w=
rote:
>
> From: Chengkaitao <chengkaitao@kylinos.cn>
>
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.
>
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>  include/linux/mm.h  |  7 -------
>  mm/sparse-vmemmap.c | 10 +++++-----
>  2 files changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f0d5be9dc736..10a0664b4ce2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4238,13 +4238,6 @@ unsigned long section_map_size(void);
>  struct page * __populate_section_memmap(unsigned long pfn,
>                 unsigned long nr_pages, int nid, struct vmem_altmap *altm=
ap,
>                 struct dev_pagemap *pgmap);
> -pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
> -p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
> -pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> -pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -                           struct vmem_altmap *altmap, unsigned long ptp=
fn,
> -                           unsigned long flags);
>  void *vmemmap_alloc_block(unsigned long size, int node);
>  struct vmem_altmap;
>  void *vmemmap_alloc_block_buf(unsigned long size, int node,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 37522d6cb398..67f9a08c2376 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -151,7 +151,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>                         start, end - 1);
>  }
>
> -pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, i=
nt node,
> +static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long =
addr, int node,
>                                        struct vmem_altmap *altmap,
>                                        unsigned long ptpfn, unsigned long=
 flags)
>  {
> @@ -195,7 +195,7 @@ static void * __meminit vmemmap_alloc_block_zero(unsi=
gned long size, int node)
>         return p;
>  }
>
> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, i=
nt node)
> +static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long =
addr, int node)
>  {
>         pmd_t *pmd =3D pmd_offset(pud, addr);
>         if (pmd_none(*pmd)) {
> @@ -208,7 +208,7 @@ pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, un=
signed long addr, int node)
>         return pmd;
>  }
>
> -pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, i=
nt node)
> +static pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, unsigned long =
addr, int node)
>  {
>         pud_t *pud =3D pud_offset(p4d, addr);
>         if (pud_none(*pud)) {
> @@ -221,7 +221,7 @@ pud_t * __meminit vmemmap_pud_populate(p4d_t *p4d, un=
signed long addr, int node)
>         return pud;
>  }
>
> -p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, i=
nt node)
> +static p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long =
addr, int node)
>  {
>         p4d_t *p4d =3D p4d_offset(pgd, addr);
>         if (p4d_none(*p4d)) {
> @@ -234,7 +234,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, un=
signed long addr, int node)
>         return p4d;
>  }
>
> -pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
> +static pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int no=
de)
>  {
>         pgd_t *pgd =3D pgd_offset_k(addr);
>         if (pgd_none(*pgd)) {
> --
> 2.50.1 (Apple Git-155)
>

--=20
Yours,
Chengkaitao

