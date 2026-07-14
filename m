Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDF2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1EC6B0088; Tue, 14 Jul 2026 04:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B936C6B008A; Tue, 14 Jul 2026 04:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A827A6B008C; Tue, 14 Jul 2026 04:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 796E76B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:35:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01086A02E8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:35:36 +0000 (UTC)
X-FDA: 84986723514.21.4FAA60E
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1B3D2C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:35:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5Tpgprx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784018135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/iDrBzzYdL3wUdhDHt5agevBzDHJ4IgYfqYHGNXII8=;
	b=DNxII+iQbhcHb3gm05tke7UCpCnE2qnZ1DTIhVdO/XXq9Mwo7gthMzXUZvelOM7VaNMBFz
	jYuJByD0Ehqa5ixF5omzvoDezfSluZ5HNN+CdkYQ/W3TeX3afY6pz4rjEspxntgvaYpqju
	t5kTHEt58mCrb6mGKQ0sADdueh/TDuE=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5Tpgprx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784018135;
	b=i9+F4xKIXyaXeiD+xLh2eEPdVuGl67OPAm7RlaB46qjC7bndQR5Ork/ew74clCA69XwzVA
	ugNL2brY4wzi1Yss4V/Cnn7mejsPeT0o4VtSvqvcvIbDIpg7gxPr//mYpeP7M4q2C0NmOb
	5cDcywfd/jcDaJicceBEHB0BAr5fKbo=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f3e6cc44aso1737477f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:35:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784018134; cv=none;
        d=google.com; s=arc-20260327;
        b=fEpAORYKCs8eUtqccKqJTwngE8o0MwecVSqPsj9zrQBBK8Q4mcxoWSmA7ikzRbwMms
         O5zTiJhPJVV/Nrx24uPP1h96n8NZCq8snIYCxwZqCRevP4kPi99v1Nqya9L1VjcW+Qgn
         Ytk8pLq+ULHgJPUlerp6XA4K0XVuIQPbR8o54VY0Za/IeAjsgHne9qZCZpSqQTEAxWO4
         2rsHJM2mdvsFz5GbEKu3mnmgzrSpZOiPVHVNae5out0BVA0jzIbvaA0rEioLKMV4tRuC
         JfJ+YzYKKb7tvSPaw1uo5m/rP6cxtjjBRC/O7gC65LvKYw999XFbMsxCIWnNRev97JZO
         HXng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D/iDrBzzYdL3wUdhDHt5agevBzDHJ4IgYfqYHGNXII8=;
        fh=CQIaIUClu5MBhkZc7jBgxfHSH3hAapdPch/DWemEGsY=;
        b=eP3mD9L7qbap297kOMKccCrsLXiMsSDuRrrsCsS+q60safCJf0iWnJqMQjGClpLgHp
         i0cfZQqO1tlUkHWNOIBz6Fdoif8cxEdmfaMt6XGADcH51jFNeys0AU0YBjjOhsxJc/m7
         GlUaHiPyGSzjKXsDqUPDR8ADCr8+ruGwWuawD7bLDqAFMANQ1sGGTukeAEUCVb299XKR
         A8UPQSzrL7xvoeutphJpWkebHdor/55DFEE6by2adIyoOQxNHsVFCLbCAjTKG7ScYQ8i
         rFOCsLXiloxaD6GOh3aZP+Rjyrg4sVIyJMvTzrPAd5pMgJTK2dc+c/ssK3Zj/FqfDP3K
         Y0Cg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784018134; x=1784622934; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D/iDrBzzYdL3wUdhDHt5agevBzDHJ4IgYfqYHGNXII8=;
        b=X5Tpgprx77eDtyC1eVvQim3pSIkoctKyji+VttivkMIMb+AgUbCIV+2ZfeWaNyGUcm
         rUNooizPqAiHuwVui0eVzHFUMRDaG2RTa0/oHauG+Uf7WmeJHfs+CqKyoAEX0cF7xNRf
         yHbVKa2SJw+ujALUOAFriRHDRBQ1jTisGyyRd3enchHoVDUao2iZ0mwMF45guOjFVmVi
         mpN4qmTKR4+tG5lObnbtEQvr1F7k4NeVcnDTP5awYwf4dtUlpk5TMfwaANr6bxWRM7I+
         n7JstvPaMez3aftTsTVr/JpHDmTrzB7UTEtIU6Iq1ZPW3tz1U6cf9dTyjnrdjRDUaEjp
         dO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784018134; x=1784622934;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D/iDrBzzYdL3wUdhDHt5agevBzDHJ4IgYfqYHGNXII8=;
        b=Bo4LGUTUtxDdcziCd9CMx4pah4oJUYNx2Fi9+hOr3Kns8Trt/GnZirnDdr3H1WA+24
         lQGyzCFSsq9AFQ3z25WM8OZMzuJJg82+Deq6kpzDBLZO5EhwM/TnaLSeA0H2Seln/sMO
         g17Asdvxgnqoe74xDQYrsfOWkiO6/jSrdt0K9RcfHz8fcrvdGJzeb4RkHHJgV9hOUfVq
         dDzdcSYTBhud9QvhK2dPwhTYQjjHbmPQECJ4+agKHtG/Xz65Uf8UFFmSkr1LVMeyZPOU
         SpsQepD+owjL6YE7uwQsR7jC87RMsJGTm5qqY+ptniWyUENK4dGYxVIT6N0nAI67gUN1
         cJpg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1NC2oSleuBAFp1Ym1LCIVzLmr1IFQgW/2c0Az8h1QHS92fq5Dg9m6Zn7xSQQnLKZ4UQMebNj8FQ==@kvack.org
X-Gm-Message-State: AOJu0Yzg5BpCrL1x76GmqemyBjZaz2gRC/p8uKfEnNZKjGbX1LDG4rFO
	Qol8zwSDL7pdxaDR9iQT41qcKpI2MjnS/m+lFy2mg+yMTkIYt7TxLuFGvcPlcBTZlYt0zigICvm
	8P89ZGstY1RDlNn6RwY3SoW4bFOLBfbU=
X-Gm-Gg: AfdE7ckM2OKgVqE2lfzgDiYJuRhLFUoSjFCNPdMmQLUY16lNCow5JEjBlj4XanT5Siu
	YvINXEL0EzZntFhwmZbHQrGrXU4pNam+e5jmR6496ePe/igKgtoK4cc++jX9kcDzx4qoHJCSkQs
	G51EhjRs0Xyn35ImxD9t2w8NSCoLEy2ulhlQuMgguUpq/hjUf6Uy/NVV5ZnBca3qeZFpERs/2ki
	wdZbOAO9FHd4avDeCljjgCnNmUZAPRB0M5Dd0nrUIvh84S3Zx2uCLZqsJSvkMqs71v7HBcMVCo3
	HNkEN6kd56xXw9/LDYI=
X-Received: by 2002:a05:6000:250c:b0:475:a4ae:e630 with SMTP id
 ffacd0b85a97d-47f48891d9dmr1757470f8f.37.1784018133298; Tue, 14 Jul 2026
 01:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709073823.6643-2-jiangwen6@xiaomi.com>
 <4b3c1d3f-853d-46dc-bb15-37273fb07f61@arm.com>
In-Reply-To: <4b3c1d3f-853d-46dc-bb15-37273fb07f61@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 14 Jul 2026 16:35:21 +0800
X-Gm-Features: AUfX_mws3EZK8Zkz_kXisjnQFFFt4F_ceV7hPDYpct8AJTxd5OPwxVMDfFEFO0Y
Message-ID: <CAHKocdHTzqdMnmjLnXLfc5GxhP1sPcGqZ64Wghr7xPtUqXGdgQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>, 
	Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B3D2C0004
X-Stat-Signature: h9m6qy15gzoq5cfmt6wt4twy7d8eyw97
X-Rspam-User: 
X-HE-Tag: 1784018134-851279
X-HE-Meta: U2FsdGVkX1/1koNPjldSbV3K7QkrYYb6f5vpRgJ0GXr1VfOwN9hJiYfO1bSErJo05kqGv4zct8AnBgqye7/jWptEh/Y14z0piPYCjFa3gOofBGdcQ+8JtyiVsrCBGy1/DbXeFT7cEWr4lzAauGUfSEyhDMStWPgWDa6+b2Ze9wylrsRiitgD8FTPY+BCtc1Ze10R+0gX7DgYbPs7aHgZ7myvk2HqCpdxGjvN2vKK4JFOWBHhTliUMg8uAdS7b7EBuC4rU5Rokgi2t876034DSso+opzN+WN5OwirGXuMnrEPmV7Wn02LPX5Nfl2KSteicibvgVFNs8Ik7KHJRbMlufeSO6CB6djc7+4sZUer3bXfKsjKGBUhJoDAcBPglP/3R4f3YGKWSyVsIVAnlVOH0A0/k6nKmZnbp16nHXhCW9b0fmvS+nUYHeIPpcJrP3eyUsp2dsEDaYCsekcxJLvCqP6/6d/HBj4yDfRBHVhQsnlLUBbKzqSugYo05DK11+saACqbPtw/Rg+CreVg7YgQhVtQhfpnX0nsWxI+JLq/UZvwhi64aRkdOa82irNOmS4BcrlLbudclwahVkD4h3LCb9tde+74Xib0L0DKuaP5yddL9nY+be/IH+M8Dh7WEQ9pyuK6rBxlfDB5jb+wz/Wd20pXjWH+NWROK6zGOVOANHHcFKZcNd7fuW6UA9lTpVnqVEYZW3wWo22DRjoc8os9T4q54AG1Pw2QsgCRfbAGFqk/setvWc5LoqG2+hXqeHLUGL2XpW9f+oRQO1Uu9HlfbpYF8bnFtD2ZfIB7T2Ezx98Y4nvavTjObszU6pBoX3VNkUJS6T0mB9yeiiJ3agLev102fUByAHM/POm4YU4WcBS61wm92pvYeoOQTuSvHYpFEh6u85jxQrHYi8sbR59sncmwmLBgAyqFixBCzXUQaaNp6zErixYfnO0n5SwKQReLdCAYM7xZv34ueCo11DR
 t+F/LJMG
 kLy2P9SK2EnJrd32KWqh7gGJXsxCP4f7hQecR9lC2NH9EXfUu+wo3/hZtCd4YSBRBqbKocAOAX87tHJ6hsZ6stycZzAW4zzvLr7oUhFbGleELdWfjX0C7EXu9ojaLSwDnijinIVWfZGRF7mCTSspcW/XDfn9/sFckoI6wc7rUvC3GIJgDX6G2kBH565dJPRoN79qMhVWbEJCSXpL8gRKj3uEB7PBFsqxYaK+7MUJZ9zjwxfDnRS65EbH3Wse4AYk2FLE9xiybkKK77q5YsahTUUMxO4CTdmaNOzonMsHFcsbGDx8QBhqsHvawVDaJcH/IPTQPLXFSSMTDEHd+uAvwHlkuuc2GqkW/wvLsEf49cFCcIUW2MKCXxJjfIbWxpQNLM1QrLNKWLMQEYAxLgTbsWSihyANL3zSSaz0pMjLV+Qy2/UX3qXg3OsrNuKOwiN8PQeoT+sU7Ih8y3UduSe1CTWhg7dBeGXiuW8FQKtpHVK+Yfb6jC8McP2nZqfenC4fCSpVxE12n3tFsgODIxyjJemj95EOm88DS4soahTRQZQg77Kx6ja4iHYMdYWzs+DNErTCklxd6OoGJ8os46OjF5OhvZe50TxkaLCHi2D8vmvGW9uc2TJQECWjOokk0cplJL9U4Ww82J4nOEIGcsyfW6XggWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 at 14:54, Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On 09/07/26 1:08 PM, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> > we can handle CONT_PTE_SIZE groups together.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index a42c05cf56408..0da746f729388 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
> >               contig_ptes = CONT_PTES;
> >               break;
> >       default:
> > +             if (size > 0 && size < PMD_SIZE &&
>
> Is there a possibility for size <= 0 ? If not then
> the above conditional check might be redundant.

Hi Anshuman,

The "size > 0" check is to guard against size == 0.

> > +                             IS_ALIGNED(size, CONT_PTE_SIZE)) {
> > +                     *pgsize = PAGE_SIZE;
> > +                     contig_ptes = size >> PAGE_SHIFT;
> > +                     break;
> > +             }
> >               WARN_ON(!__hugetlb_valid_size(size));
>
> Would not these CONT_PTE_SIZE aligned sizes upto PMD_SIZE
> trigger warning here because __hugetlb_valid_size() still
> does not enumerate them ?

The intermediate CONT_PTE_SIZE-aligned sizes will not hit the WARN_ON(),
as they are handled by the new branch and break before the
__hugetlb_valid_size() check. They are accepted here for vmalloc's partial
contiguous-PTE mappings.

Thanks,
Wen
> >       }
> >
> > @@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
> >       case CONT_PTE_SIZE:
> >               return pte_mkcont(entry);
> >       default:
> > +             if (pagesize > 0 && pagesize < PMD_SIZE &&
> > +                             IS_ALIGNED(pagesize, CONT_PTE_SIZE))
> > +                     return pte_mkcont(entry);
> > +
> >               break;
> >       }
> >       pr_warn("%s: unrecognized huge page size 0x%lx\n",
>

