Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E366FC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 04:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AC96B009E; Tue,  5 Aug 2025 00:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BE86B009F; Tue,  5 Aug 2025 00:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AA46B00A1; Tue,  5 Aug 2025 00:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 337706B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 00:35:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF8191DDDC3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:35:53 +0000 (UTC)
X-FDA: 83741440986.12.9F43AE3
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9A1C140007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:35:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LhZuSzVU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754368552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrVxzJX4t1BltjWBEp2/n51TWEMkIY0NHFDZNcU8IC0=;
	b=u6SM42pC2y06aHEeqA3CLf4S23fcbrh/9QPllxm4hqpjwsGvccGDN1QoovhuiG1Tr4zGPF
	A6r55VHTyjjSQGRfdvWfOOxo+rWY5G3P5Z/HiecXcRl6U5ygF/nTbDteReBk89cpeUqO56
	bMY02Xmc6qKz1+JezE3InEGOCP2hl8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754368552; a=rsa-sha256;
	cv=none;
	b=mRWB4KMR9q+RD2p6afoY1AaoNpnT3uxyviMYbFjnb75T9sUNe7qsrH1KQxV7ppNOn9RchY
	1MxShGMD9uaAd075lyroRL5O3XGVhxrb6vG5FwWnHEsJE+N+5/08uSu32rJVnmJaPS+kKq
	QQK7gquHumRlTdSjHHwKqb83L1NhT4k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LhZuSzVU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4fce686dd78so1464586137.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 21:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754368551; x=1754973351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrVxzJX4t1BltjWBEp2/n51TWEMkIY0NHFDZNcU8IC0=;
        b=LhZuSzVUMMm8e8hy6AKf2Bw3zfgnI+DatKwGKSlE4KAui6m/Vc0OIG2K34dSU8GHBh
         LUUTDbqOKXi2AFKWKITqTGPF+8ybZzZXtrGZgFNcDFx+xynz3qUj+3CwSoPKKqCFyb2V
         SwXfn8qAhLiVXnS/ZWoJhrc/Hv6cNnBp/Q4e6OlcsAjS8Y9dPcCfXjZ9xllvYduj2X+q
         BQRZ5zPyn0O5v+CnJYojI0cmaEbQ73nnPpGo+GDMWfacraZanmIt7PiDLQa5Vx7RKvYN
         x6RBSCtSCli8Z+9OzL4kORy0aT9F2pb812j1nCHL0+HO7rrehLEt8BO7HpnkGFtx9wvs
         VOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754368551; x=1754973351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrVxzJX4t1BltjWBEp2/n51TWEMkIY0NHFDZNcU8IC0=;
        b=OijfNsgGENlP2AgpWwjPdCZQPPl/Veh1VPogLvTyxQJ/grQrcoE4sfAiYEPeapb51P
         tW2ivoUKk2eDt6UdDJ4akV9vHDpvjp0T1wEJUimt6dUSjUXCZXRT8r8eglSUKN5BVA22
         nAb//Q0VCOyWR4j+fPKiEbP06gg6iA0Vy+5Wdr8vPA2StAekIFHQD4qCVBztaj+2QzSJ
         bi6EyAV+CJrFvciTNNX8q6EXbS4U0ZTtOBTCYt3NLUnn0VRqSQEXucgVGo2ucMJleVHe
         rXDVO3AaKxJPoWbfUhm7+Oi7ztFJvjupfKv+iZkKZri9wh9Reo6x6xOwKMADLDIHguyj
         LT/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUa7ZKnua5XxaDqOlhyto7GzkSzk/qNUVUx58Q7XLEXa+k/u5eZLID6Zs5LGBGv/EPEAdoRGkirsQ==@kvack.org
X-Gm-Message-State: AOJu0YwlzVcLms2oew2zqT7E10OU4nJjBse1kbojTcvhkbKZeW+v9DkG
	bwdd7LBOVdeSYPOkLT1hH6mYeVDEhoILE33evovACOMsFGxSq3rSCqMUXYAOSkwelR/THtPQJ/1
	4TWpDq52Wiwz7Fi9KzcRTPU6AqxZ9dJc=
X-Gm-Gg: ASbGncsqTz5082Hc+l64DdBdx1l1r8dImJy4wi2W/ysM4qzN2WJANCTft79z5E4ZxEL
	Gi8e4PP7JIGMhVV8g4MU5Al/778zkkmZd7my5+EO4BlYA+b1v+TttD364Hprrz1Ui7NBhJz52vk
	0lzcX16dfHp+nfHLHkpRJSsMssoJoepxdfSmwQyWVimIIPSruqNyju2FJMpGY1PdxURjvtNJoVA
	LbSZTk=
X-Google-Smtp-Source: AGHT+IFkvdFOCiNIJbthzi6nYhoUdCEQi014JIFL6hmsWzhgV/SedYlYwX1OXPH7HE8mkUUR2rDIVdiqkBNFtJt2wi4=
X-Received: by 2002:a05:6102:800c:b0:4ec:c548:e10e with SMTP id
 ada2fe7eead31-4fdc1954e12mr5531645137.3.1754368550800; Mon, 04 Aug 2025
 21:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250731104726.103071-1-lokeshgidra@google.com>
In-Reply-To: <20250731104726.103071-1-lokeshgidra@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 5 Aug 2025 12:35:39 +0800
X-Gm-Features: Ac12FXymlTMYwPCxmyr6leqj8wZSHxW3roj7vV4cwZ9AAUBxFtkVExOdqRVGi5c
Message-ID: <CAGsJ_4yJ5mtk_mp3r=PsMZOnHdtEk2Q_UTDjwy=4cmV8mcz+mg@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E9A1C140007
X-Stat-Signature: bcpiqgtea8thqyrdgis1ff39rhpuneq1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754368551-766777
X-HE-Meta: U2FsdGVkX1/8xopKXT36P+BJcXC7H7mXiZle7bdfe2YYu5yT4wQZr11nORLGeTL4P4LW30FPpX02zjKsBVkJQJRNPTDF+hAuUMc5yC6C0Ki93C1ANxcd9wqNHUHPou7m3usyAH0CIxsuOlQdPbqp7iOek8tv03duHA1gS41nCf+U8rcBGbbTrcQrPC7h//SMJszYikHCOOudGvMLbB9KfCL4ylL6HtnKPo8GLXCtkj0ZUY3LBAJO16C7y0/a858042jiFR0J9R2F2d4/Tgup7RCCeEAhBVyqzBfjqnY0sR17k5uCnYP8BpanAdguYL+6AT5UyroRsNJHYGQHE6tv5xEvc+pIhz1p0XTyZ9xxJAvFwmlaQlVQXqdEAzBZvJzO2n61NLOV+uc+FJNhC86glZK5FHBjgbtq4+lm8ym720lMgMVK1YmYbmABel7DxBU9RgfEQ//dGdlqjAROMEYDr46PXvZ+ljaYZhZUe2gmAqfxgzDxnAs68F8vXbyjyfeTdwq8k0Xcy9QtG+O8biBukZA22L3CgM/LwQfiiqbWfjgW1xjZKLLbDuZirrfdYIZNQhltQgrFmruHiam5M0r3lgz/rnZLKitcLJlRldQYVNwgrKL6EsMpjutQv8rHIaHF0aF59i3ya7T6AbQBqIYQBrco309ooJ7mnzCiL+ebq37l2NvD+V61ymV2wAza5BXeeLEru4CcWS7J21bQZrqDp4tzsyK6ZQwI5oK5AcTP5wR2RL056hwaQtSsv1WWs2S4DPwzy1hUPutfkVXwcH1isuuyA5/d6DQ3y0G66yoXE01zdn0QY/kfyJa9wtNm9foRPd54tAerEX2J/s1LTtlF9SuvSuSUQ1LRFFkjnEt+BE46dsvHNPpFTOdvO5bLuOF80QI5gMcZs5a3/YD5niUSkY8fWxUXSTPqe3oQrEvaf+teZasd49b5cX0KHFwcB4WbPWZ1sBlNLpAa/yBEqlb
 T6D+z3NB
 vBXRRvTGlVs8ncXeBZCY1NkwQ6mtTLANYETNtmGMSygtH2nK6YhB/CMyZx3E58Cc/8CXEf6iiJ7o2zv7eMGOdrUgYRgK/jOIsTKg1rQKYJ/iRp0XQc2KtwkZn3QaaDTGHJzvuFMiYx64Kwcy+VBDrsUSiLWXPAzToBvow7DYkKjK0iEgO4e33NnQiaZqEhILrpq6nPkhADm5vygOhc8MBR97s2Xn6yRyBstNpCd3OmlstMmsngIOHSTuSXZDYekXbfDRgxQaUyNs/0fAz3Pjh9N6/xUeic6XsMiExEKS7pxNkOsZlxT/QX0pdpyCXFKmxc3qTgxtKFh5Yxjk80Bvt1fnzPdlYolWbdu7m9B759qDq6YN7ltJiGVQuc3a9q+EVwtZqYepVLpinxrbNg5204OuFyVEwsgdeBF1Q7HnObzQRZRFQWmENd3JVx4IIk5f/A7XrlW+gJlc3KiM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 6:47=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.co=
m> wrote:
>
> MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> for moving present pages. Mitigate this cost by opportunistically
> batching present contiguous pages for TLB flushing.
>
> Without batching, in our testing on an arm64 Android device with UFFD GC,
> which uses MOVE ioctl for compaction, we observed that out of the total
> time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> ~20% in vm_normal_folio().
>
> With batching, the proportion of vm_normal_folio() increases to over
> 70% of move_pages_pte() without any changes to vm_normal_folio().
> Furthermore, time spent within move_pages_pte() is only ~20%, which
> includes TLB-flush overhead.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kalesh Singh <kaleshsingh@google.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
>  mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 127 insertions(+), 52 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 8253978ee0fb..2465fb234671 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1026,18 +1026,62 @@ static inline bool is_pte_pages_stable(pte_t *dst=
_pte, pte_t *src_pte,
>                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
>  }
>
> -static int move_present_pte(struct mm_struct *mm,
> -                           struct vm_area_struct *dst_vma,
> -                           struct vm_area_struct *src_vma,
> -                           unsigned long dst_addr, unsigned long src_add=
r,
> -                           pte_t *dst_pte, pte_t *src_pte,
> -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> -                           struct folio *src_folio)
> +/*
> + * Checks if the two ptes and the corresponding folio are eligible for b=
atched
> + * move. If so, then returns pointer to the folio, after locking it. Oth=
erwise,
> + * returns NULL.
> + */
> +static struct folio *check_ptes_for_batched_move(struct vm_area_struct *=
src_vma,
> +                                                unsigned long src_addr,
> +                                                pte_t *src_pte, pte_t *d=
st_pte)
> +{
> +       pte_t orig_dst_pte, orig_src_pte;
> +       struct folio *folio;
> +
> +       orig_dst_pte =3D ptep_get(dst_pte);
> +       if (!pte_none(orig_dst_pte))
> +               return NULL;
> +
> +       orig_src_pte =3D ptep_get(src_pte);
> +       if (pte_none(orig_src_pte))
> +               return NULL;
> +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pt=
e)))
> +               return NULL;
> +
> +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> +       if (!folio || !folio_trylock(folio))
> +               return NULL;
> +       if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) =
{
> +               folio_unlock(folio);
> +               return NULL;
> +       }
> +       return folio;
> +}
> +
> +static long move_present_ptes(struct mm_struct *mm,
> +                             struct vm_area_struct *dst_vma,
> +                             struct vm_area_struct *src_vma,
> +                             unsigned long dst_addr, unsigned long src_a=
ddr,
> +                             pte_t *dst_pte, pte_t *src_pte,
> +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> +                             struct folio *src_folio, unsigned long len)
>  {
>         int err =3D 0;
> +       unsigned long src_start =3D src_addr;
> +       unsigned long addr_end;
> +
> +       if (len > PAGE_SIZE) {
> +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> +               if (dst_addr + len > addr_end)
> +                       len =3D addr_end - dst_addr;
>
> +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> +               if (src_addr + len > addr_end)
> +                       len =3D addr_end - src_addr;
> +       }
> +       flush_cache_range(src_vma, src_addr, src_addr + len);
>         double_pt_lock(dst_ptl, src_ptl);
>
>         if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src=
_pte,
> @@ -1051,31 +1095,60 @@ static int move_present_pte(struct mm_struct *mm,
>                 err =3D -EBUSY;
>                 goto out;
>         }
> +       /* Avoid batching overhead for single page case */
> +       if (len > PAGE_SIZE) {
> +               flush_tlb_batched_pending(mm);

What=E2=80=99s confusing to me is that they track the unmapping of multiple
consecutive PTEs and defer TLB invalidation until later.
In contrast, you=E2=80=99re not tracking anything and instead call
flush_tlb_range() directly, which triggers the flush immediately.

It seems you might be combining two different batching approaches.
From what I can tell, you're essentially using flush_range
as a replacement for flushing each entry individually.

> +               arch_enter_lazy_mmu_mode();
> +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_pte=
);
> +       } else
> +               orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_=
pte);
> +
> +       addr_end =3D src_start + len;
> +       do {
> +               /* Folio got pinned from under us. Put it back and fail t=
he move. */
> +               if (folio_maybe_dma_pinned(src_folio)) {
> +                       set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> +                       err =3D -EBUSY;
> +                       break;
> +               }
>
> -       orig_src_pte =3D ptep_clear_flush(src_vma, src_addr, src_pte);
> -       /* Folio got pinned from under us. Put it back and fail the move.=
 */
> -       if (folio_maybe_dma_pinned(src_folio)) {
> -               set_pte_at(mm, src_addr, src_pte, orig_src_pte);
> -               err =3D -EBUSY;
> -               goto out;
> -       }
> -
> -       folio_move_anon_rmap(src_folio, dst_vma);
> -       src_folio->index =3D linear_page_index(dst_vma, dst_addr);
> +               folio_move_anon_rmap(src_folio, dst_vma);
> +               src_folio->index =3D linear_page_index(dst_vma, dst_addr)=
;
>
> -       orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page_prot);
> -       /* Set soft dirty bit so userspace can notice the pte was moved *=
/
> +               orig_dst_pte =3D folio_mk_pte(src_folio, dst_vma->vm_page=
_prot);
> +               /* Set soft dirty bit so userspace can notice the pte was=
 moved */
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -       orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
> +               orig_dst_pte =3D pte_mksoft_dirty(orig_dst_pte);
>  #endif
> -       if (pte_dirty(orig_src_pte))
> -               orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> -       orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> +               if (pte_dirty(orig_src_pte))
> +                       orig_dst_pte =3D pte_mkdirty(orig_dst_pte);
> +               orig_dst_pte =3D pte_mkwrite(orig_dst_pte, dst_vma);
> +               set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> +
> +               src_addr +=3D PAGE_SIZE;
> +               if (src_addr =3D=3D addr_end)
> +                       break;
> +               src_pte++;
> +               dst_pte++;
>
> -       set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> +               folio_unlock(src_folio);
> +               src_folio =3D check_ptes_for_batched_move(src_vma, src_ad=
dr, src_pte, dst_pte);
> +               if (!src_folio)
> +                       break;
> +               orig_src_pte =3D ptep_get_and_clear(mm, src_addr, src_pte=
);
> +               dst_addr +=3D PAGE_SIZE;
> +       } while (true);
> +
> +       if (len > PAGE_SIZE) {
> +               arch_leave_lazy_mmu_mode();
> +               if (src_addr > src_start)
> +                       flush_tlb_range(src_vma, src_start, src_addr);
> +       }

Can't we just remove the `if (len > PAGE_SIZE)` check and unify the
handling for both single-page and multi-page cases?


Thanks
Barry

