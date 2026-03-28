Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766ED10F3DF9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B3E6B00AF; Sat, 28 Mar 2026 15:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5286B00B1; Sat, 28 Mar 2026 15:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD006B00B2; Sat, 28 Mar 2026 15:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A844E6B00AF
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:54:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40793139B6F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:54:52 +0000 (UTC)
X-FDA: 84596524824.04.C32CED9
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47FF740010
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:54:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=COpR6MdL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSKx6JXbhORIwZf66NfAwmgqe5Ds34riezs2vNMTqS4=;
	b=0jSFtX0HEpD+SZql0PwGvvMO9vY+Ul7PI9kJbP2Mn5glfunIh/NntaxdzERksch7MvLbAx
	c19k0qSmlacvDNMgJ3rpWpA2aEIUaUGZsnt1SGYZpQJpoLfII0qeMKvinqh566iMz/uymd
	pmntfXktWMLOsGC+FXeIoqftNzngGRs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774727690; a=rsa-sha256;
	cv=pass;
	b=LVUmuWGlCUQcG1TVz88v2ORMeRXTeXee7TN9o2+QSGNBAGeVN1osLDU9bRy3aTJQRV1LLf
	6OlQgNMPwUUpQWjXu6lA2ixb/FDI3g3+cBkQ/odxdjGLhtOw98JF+1S0tPm8P1a/35b4sx
	+Met+LY+c11+R4VqVmhPJ0Bw4i68KgQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=COpR6MdL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-509062d829dso444281cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:54:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774727689; cv=none;
        d=google.com; s=arc-20240605;
        b=d3C1BsaG1grSXjr8NJKaTXLaTvTRTjS/uSh+hzqv/edATqX70RoVS49E5Z7qO4U7/S
         ittgPc8kb9lxFD7upJiZdsy+SYppL5K5PU9Gf/7VSDGBx/FKE+4BnlAC3r7DDc4g07Gu
         R214LlLc8CK7byT0xIxW/OBSHu7Y6w0QxWAE4G9GgFkCB+MOHE/yEINfzf9QD81/tEi+
         MJc7001jIyP5vICCVFI7Cvc5TtH1LwylA8kvk7+gnsumWcZYCt1v2ZUNxZNFmPK40uNI
         SNIGBArI9uSFC7MmJxswC4rrmmwzxKwCs9X6qZOI8ZMXCikwL/4PIyLkSNTDJns6u22R
         1e8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oSKx6JXbhORIwZf66NfAwmgqe5Ds34riezs2vNMTqS4=;
        fh=EDwbUoSio9RG5CHV4NfQ5k6wefiUnzjTNzstcQoM9+4=;
        b=hfVkiRykEI+BREuTLVEym4FnvIzVZHTg0PnWbY/8s6nsSheGJpCQY0SX9eQ4ACSrJC
         xoIcPz6HYpD/hy9i9yj2IkTeite5nOOjz44FlaisUIzsXBOn5p+YZdPvOsLuKfpB6FEm
         CLtR/Hga9oj/zG+YBpNJq21U5Z2WSSpSnaIcNu4rxY0H+mtBADa4FpKPqY4I068icLpX
         07ygHh+d9DLv+SlH79kxPp60EIf3sj3nSFkUBbUrQPJilWnPuwTMLs/GVSDl/1X5tqg8
         P0Km2HOVRpUe6GC5zy28VCGVjpF3Iya9pWleF3X2+76M78p6Nz6tjGcPOJiwy9+zukO6
         W4Lg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774727689; x=1775332489; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSKx6JXbhORIwZf66NfAwmgqe5Ds34riezs2vNMTqS4=;
        b=COpR6MdL6J39eW/mRjUY82E/8mPB0fDwFVFCqvH/dpeLs3gmGSrsHfoSEDW7r3hGMb
         u2ilm38YmSxOU2p0rn1CFdvqZJburH/wAFviGidr+gKGY2yYwozHfVjsY7EMLBPg4flm
         NKbWJCNODmfOg7sqhhD7SomkveGc6H6gxuAbkmlBvXKbb9N26gfrZofaRQDdVMojvtrv
         Oq/p1dMvD3JUZbt5s+kqljXCoNQN9SJgwk/JmsdVyjRZtRSH/4f94toOwuS0NqDArdwJ
         ShM6q2fiQe85IC97uQ5xebfEe3OC5w5JLLgVl3OW7VmilU7WdD8+hE8x/0N9aAneGuVZ
         Fv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774727689; x=1775332489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oSKx6JXbhORIwZf66NfAwmgqe5Ds34riezs2vNMTqS4=;
        b=IxFSLaXhMAirORUPRzDpim0PpPh/0iKLrrA4Q7Y/i+sTfwpHwT2jbqEP9vavUCYV+R
         pEMZbxoboQ7c1QbhPX5V0odDieQCh3KEQRaD/eeBH+cG/2vGNd8/6KesH1yKJNaNQVCg
         FkCIbJvWNt98Y0GeSNvXYZsH8UGSiezTHVP+7KEJ49cOpqLOzdyIQfJxm1S6xE+6dWo4
         2KGbnedZO7MBGDPZuMkSYAUVopQ2jGfrVDLgJB5agnz6+L5cHvs2YEB7u4AF/L7/XmzB
         Ua6QNgcAoJHNj7OIuJcf8gAbPPD4zs4lsSzHutFp/bcT4LE82bIimqgPqqak3igqIYTn
         gfPA==
X-Forwarded-Encrypted: i=1; AJvYcCW87JoUj/mGMCPlP7wBMYMRDied6XhxLfbqSMoWkVfXmtnb2rPqWX+MhSUISNPo+2vOFlMABxSw+g==@kvack.org
X-Gm-Message-State: AOJu0YwjfZARln4C8GlQdxr/cBiZZ0D2KILZEyHd093ERsX0+roEMI10
	Z0LHjinGX4YznvFyk+uYsC8x8Dxbnu0xrVt/MnlPK5QyBGHvn6x4sO9yWkuslPUaA2ypgpyKbDv
	khui1VwKDCEr64DNCPo+tlj08qtv6WGCZN8+V2Yjq
X-Gm-Gg: ATEYQzyNIzMukh0torK6qFCrhdUjkvY7JAM62LORrmGaHSJwTNdDLdz8UDuIm62KHBD
	1LziiGSW54Mb3Q3hAmRTRmx0ZYXCyDl86Emv6wrFw5HSgvw2XKdrABwXeDW51Ma/gvdm7vA2eSv
	UqgPPbVtHqYWx5ZHsyV1OMnPfUryrppeHEWFoAT1xWeEV7jy7T9Z3I9MJOj0qsHhwbxHgfE6wO7
	srxbml0CrEUtPYcI4Lp3EJ8k67jx6yJGfuQ+JdwWvpHApjpkCOp1TTl+N2Nc7UyOGweLJ4LI12o
	xXUMew==
X-Received: by 2002:ac8:7f90:0:b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-50bb3d40d81mr10514791cf.7.1774727688888; Sat, 28 Mar 2026
 12:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <97a35411-3482-42d5-b0ea-31a5994956b2@lucifer.local> <0a917f80-902f-49b0-a75f-1bbaf23d7f94@lucifer.local>
In-Reply-To: <0a917f80-902f-49b0-a75f-1bbaf23d7f94@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:54:38 -0700
X-Gm-Features: AQROBzAA3LyJIWixUkc7gDku3V3tlSz_r89FgC4oXlFH-sUQPhOIFQnYXWfZhnY
Message-ID: <CAJuCfpGe1TQ1Cv_ZtjQhjgQD-6bxk9uirJeDAZwhrSX=NqEw=A@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use has_deposited_pgtable()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 47FF740010
X-Stat-Signature: 7cta3cyq6e1i5a7tbc1w1pqyym649moy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774727690-36544
X-HE-Meta: U2FsdGVkX19ry9pFqxI2wLcOd0d4cw19N4NzdtVaw1lxb0D0JDnttx6z3zqq2SetDs58cT8ifWrw7ZhmhJ2tQx5o5YyXsh/ed7gU5HpyjfxtxJI7RqShmLc46E9mK2tp4G88zDTJ6b0nx8Y9/0gJO1fxbivM0RZLjvF5UlJ//tG/TCqdWMFWBq/jiUWOmCzzQ8Skgvc4AXpxyqqiLeI3igMhsKLBfDEm+BvS48QnsykdgN69XgLpXIFnOp0hoQkXyLIUHJHrXhHKAsIKdXNtB1gS1x3g2f6l5UqEduaeTE3hzgtcWL/bTTUO9zYsgvHVQjE8YyZ85fh1xa7Vdtppifjp1mBwDD81uWx7sXAiduqbSVMdeUPfT2mcsf+AH2YhZYiQQSO3p9+tybh/qtRfrloABxVXmP3YU19zoTrekrDxz/IpeqVbTGDofEOUtyoLmRqpTJ0DYt27TOBLxRGvl02Lk2+oG7VkkPsKe13Pk/sBeIUaZ8eY1LabVqTZdzpSR9CZzrVV3NwTMRwJkVT1MlNDus2eckh0nR6E/qLIUiQ+AFlT51SadKdB1MVErLEoJomyXXWfauCIcDQkzuna2Mv3UvZpk1S2uYEGUwnlW2Uzr5vh9rnSsVDU5kfK02Ht9215K8GLB26f7Jvey4u9MgzKqioqGaEQrAKv4xuQGy6JROCnAlCb2IVoXOkotYFgOWrashpMdFndVmWLEpe11gousjZWJk3fMlGu2Bsp2QCp/z/+BNlBVDc08UNPsqFJJvjDJT6eXnAlmNQ2pLOWZ+vlqI7BFG8fp1jeRdhvhhe5UxSXhP001eyTwWGF6+g61wCQEvEHnj708B7UekUj4SzaAw2xmxysaqbSuAjskBVsnYtyGrYa54dXyMq707Uuuc+JIGfl8SDp/55pPSC/qb8eIhxYlnBV0y4efekdU10hhH4uCE/zPZ91vtnixpiNiRbMrvp/754TlpmZ9NS
 H8wBXEt1
 S67dcXXM4ARMK2NoTzftE58iOH/+v5Co2d7Fxt6PMHSSiLbbMRvyDZxu72DTdpEBZlZLbrSaSuMndJsItjMFOmiTH1TGzNOQuvj0yqbUDwxZQPmO53WIStL+qu/FbdD7REi0nw6mLyjGOlzvHilHIu23fD4XvXKc2AqLuLfuOg3pwr90vu+Plvtckpi4e0MQ69jAY+mlLxu280BtEAjdimPz1MAxFQiA7ffbL4/taUb9QX5eg9S9rzQ5RA5lUfe/6cQ+/BvohE/dCrIugYLjMPaB5WyFO58/zlXNIlL5tugL5Qmt7SJpjxf2391Tnk30kISjq9UxV1S48BsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 5:25=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Mon, Mar 23, 2026 at 11:45:23AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Hi Andrew,
> >
> > Could you apply the below fix-patch to resolve an issue with us perform=
ing
> > folio_put() on a folio before checking it again to see if a table was
> > deposited, as per Sashiko.
> >
> > This patch resolves the issue by storing whether or not this is the cas=
e in
> > a has_deposit local variable (as used previously) before invoking
> > zap_huge_pmd_folio(), then using this boolean to determine whether or n=
ot
> > to zap any deposited table.
>
> Oops this is wrong...!
>
> Please apply the below instead :)
>
> Thanks, Lorenzo

With the fix LGTM. Overall very nice cleanup making the code much more
readable. Thanks Lorenzo!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> ----8<----
> From e6d58747d00dd954c605201e97f8b769b2ba8cf8 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Mon, 23 Mar 2026 11:42:01 +0000
> Subject: [PATCH] fix
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 610a6184e92c..b2a6060b3c20 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2397,6 +2397,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm=
_area_struct *vma,
>         struct mm_struct *mm =3D tlb->mm;
>         struct folio *folio =3D NULL;
>         bool is_present =3D false;
> +       bool has_deposit;
>         spinlock_t *ptl;
>         pmd_t orig_pmd;
>
> @@ -2418,10 +2419,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct =
vm_area_struct *vma,
>
>         is_present =3D pmd_present(orig_pmd);
>         folio =3D normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_pr=
esent);
> +       has_deposit =3D has_deposited_pgtable(vma, orig_pmd, folio);
>         if (folio)
>                 zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
> -
> -       if (has_deposited_pgtable(vma, orig_pmd, folio))
> +       if (has_deposit)
>                 zap_deposited_table(mm, pmd);
>
>         spin_unlock(ptl);
> --
> 2.53.0

