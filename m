Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A55C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 03:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7AE6B00DF; Sun, 10 Aug 2025 23:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98216B00E0; Sun, 10 Aug 2025 23:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87556B00E1; Sun, 10 Aug 2025 23:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 903026B00DF
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:55:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F3BEC05DD
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:55:51 +0000 (UTC)
X-FDA: 83763112902.11.7A750CA
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 37E9140004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:55:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aa6mUAIq;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754884549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gh4o/ThwRa02/v9W2VdfL5emsZEKvd+UE9SPTqW1Qw=;
	b=lvWsyAD/UdKH1ULhsSfvYHZ5gp5bKuiBhXCDOk1j2WDD9H5yfFfnFG4JICK5xkBPnlXx/H
	CGYFpwDTidwc3nYMRj3VCUwnQ32tpt+z4Pv73PD2MP3RSa3p9x8e87/oqDccU/vRhWOLlR
	CK4OB9ioRaywGj3w3frhNi4wCnqjClM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Aa6mUAIq;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754884549; a=rsa-sha256;
	cv=none;
	b=U/cRHUcsY9w1G0m48J6jkObmgjys5DJfu/BLEGY7oj0YVUjmkwNkVe5ti3SPxKYsoBhIGT
	kK7bh5oW62PVEETOLcRNKSo47AZQFhHcaTgFT+/KWDfdIZwGYBCjNRyUW6/LGKyG8qD6A3
	YUXsBGVX/QmyLxdOk6Tp3/ZPIewPHVE=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4fe234cf176so1827696137.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754884548; x=1755489348; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Gh4o/ThwRa02/v9W2VdfL5emsZEKvd+UE9SPTqW1Qw=;
        b=Aa6mUAIqOrrCGJ2ln9uLE8ZOQd4BRT6QlZdbwfJ9jb3pvZwnKp70f/fpLCAY7Fk/xq
         dzvtPfeRHYfK44mj1mP7qNXlWvvP3dZHczWg8jx1q5zk9tLfyagXI8TMAhlxiCNyrZR3
         IsNm869iw7MTJIUfie2jdDSqCsTf0O1SXDfLp8tQTRkyRTaoqmyhJ0Dsys0BCNag9jNC
         CSNPTBqxJt9yNQe4ERZBK00VNSUXHYB3it4zH//oQ0X3nLebWm0woyBSPBdEI1a5ushl
         2VhwMDePINhv7e2JcQgL3ZZtXvSj3IbfnFl2z44zzmV93nYne+KYYrtQ9e778ubg0dva
         hJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754884548; x=1755489348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Gh4o/ThwRa02/v9W2VdfL5emsZEKvd+UE9SPTqW1Qw=;
        b=rUfHvNAvvBLqYOrj9sLUOZYgRI+Vgg7sXRO1fjFMOGXQbP6A8IsWqrauiJ6FAhBqvB
         mFgPm+KeIHq11R2QxjG91Eq/4s+0S7hrfoj5lEehWh2uUKSZoSW9dUnDaOercIs5p/P+
         HRYqwd6j2eCL923DPu66xc1I8XOqh6TkFT9QWEYjF5HT1O1o5PyRtd3nh5FIem7Dcswe
         1iTtLBPOQzoCiQD6kmFSXNy9LyHz7qtvNTW7vpm7cqhwotlScQFs6ja58Be0dSQBdwlB
         7yBVkjS6DB7FJNgMmww6nFq817Q9nXywXHY6CFeSSlQnKpKJjYz6PFWvydcHVEzCTD5U
         x9lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt3336uZSThSDRSkaZyfY8WGkaC9aHmdb4lmDr7dIREJaYzCPRRENM882MdrcGta1sHkTbPdm4nw==@kvack.org
X-Gm-Message-State: AOJu0YwaNCQX8i/+ixrKwJrCi6rzd8yG5MhPMb8b/wTMfC4TZmiWMTT/
	uU4V5SkalwvM5Fson+iUECZFAYRSTTq2s7RVqD7pKTdxZoyKQ5bJ6y5Sjt2FfJcNhpvx8wb4Kt6
	zyXOEhPbaJX0D6+Wif7pVUESruTDvySA=
X-Gm-Gg: ASbGnct6hfiZgOLn+qOf30BofqM/SdoGOudLLMrxuUVM2snnRezZPVdN+OUzd1fpjPo
	rcR4TSvtg5Zyv7f6HXJzHXSDdUM5IOZTTNdZQZ9hwN6HSc33NMlN+w4hRsLF021o12m+1XwnGab
	N3Hx2BcO0lRnfhh4s4Jt5MFLt5ZwaEVAxOOE3CuVhOvSoEdFxC9/q7MRWB+YcluOrVASD00O/Jt
	R6VWLI=
X-Google-Smtp-Source: AGHT+IFuCuY5dTS+gnjZcz8kZyq/PTrA6lRvEfUTYKjHfwC/P//oJLtzXwRySSL/4pDgGVaHOn5dc67+foYoBpF+dJU=
X-Received: by 2002:a05:6102:1516:b0:4ec:c548:e10e with SMTP id
 ada2fe7eead31-5060d9e08d1mr4041717137.3.1754884548093; Sun, 10 Aug 2025
 20:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
In-Reply-To: <20250810062912.1096815-1-lokeshgidra@google.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 11 Aug 2025 11:55:36 +0800
X-Gm-Features: Ac12FXzbJ-_yy5er3Lm57YLRpVrw9PyphF4Al2lvVnCy5IbrGwHuniddeoo8dnA
Message-ID: <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 37E9140004
X-Rspamd-Server: rspam06
X-Stat-Signature: emhxoenqc5hou7zynzo8tzhzqctjsxuh
X-HE-Tag: 1754884549-39599
X-HE-Meta: U2FsdGVkX18dQCEB6PSjvfV9ssi+iiP19qxRvJP0+G5qiWoV4mBjs+UvjK5kEDNX0Kq0rI5gpRNs0qXW2118om/0SKPmMP5QYUCJttIWlA1bkM4MdI7D1c9Mi1WN02OyrTJEwiS19zA56dE9RDfniA+ZTOM2u2sWGdxiH/F6CykYsAjObJzAit08FihQrQB1zJB95F6J92bCiuCEeABOfTqBSK2kLHLkb/Rf5GY3VhNQjk4MMZDHPQfvkmKwYRpdCmkfjeph5N5GNxCrgPlDSEbB2+fjIlmJ8tRizkRlE/NQZeBdKWD1ewzjxSz8XPH7wenwrT9TCfRaDQoLPJ5aKWesCzCrP2UWKwPOe/bKlXVCJ37g+huMcKWLcRicf1NZXLyl7YBRXheW1mqLSmhHZ+WLsMaJWNIcS7N1IIiNQ4qqdK7j7P3AG2v01UjXb6gG+qeduVOTWbWnlGixozH991w5/jcaqmpZXcexvImgPrwipDnAHiE0pu/uXe+ORdW3shrHn++CjVjqHr5HVt07D5HrHazpaw8Sk4+busMp84uvmCBaSF/CX0+bOgjkAc1vCu3GJUunXBpdLGtlOXL8xWpNlJhDEjlgxCY1E3LGDK0RpDMYCLgrdvHovzzFDmae//P5cs5/q01n/A7vuM0FK0yoevW9R37d/C1mgfvWBxDiBeY56KQYipWUUxU3VsW7kpzpt/+uFPNhWCDN/PL5JPoKWkfcaavjcMgsOHNay8+LDQIQtIrIFRg8CfAHkhOv8WXmptGzjds8sBsKUTgARfWkfkBAvAtSIhdLkYiacaJ18rGalIOQyB7XjdpX2J54gyIElj5G9f0USaEiah0guOA9n5MOhLJpaqJqMntx/SGPyOKhp49pWr77H8tA7Y/iFsgo5i6tKFKad1uUpNzwZRvjmlwepdbZ1/xHTNzjZKi2pg1K6Puld07zZ1Pzqs/WnYyR00oMHfBvGux2Xhf
 J/lCWOeX
 0R5snyUi3aA+CC3jbOoTZsYmP2Kxl2laKrpL3lUimvlj4MYV7QDI/oQjYsxDoSspIs8FCKv74b0HQZk9OUQYmybLrn/K5RUdZXVU219G2DuHzLLiV+aDCBOGs8WU4fsTSIOu/D12Zy2Fbd1qhQp9DeHWEPEGCTFO7hZ1zEAqWxA6bO0OaiZw+rgowFsI5CrxENpx/L9UmHUEVzaIIPlqX6iTbFsJaSvB8LxD5yKJnsGQrHU/TRtKE1B8qDFgYs8lOpbXjwaIanox73DIOZq88EA9ayrtVwtqHr49m5SBxG8r4MpKhjyzBg8dnSrPZHy1kDoUYfLsUroZa5KmudAv5ogdQ4GwIBShMA9gkRHcJItd6Jr1v5eZvULUIm4IPwOKy1GbseakolfDoLcl1z3SWtJuhGArbj8TPXnawf1ujfZAp+FwFjW1YMHCc9eyQTwwneO5Yt0VTc02K+lNGQXgCaZz+B5vjwZwvLxVTZNskKReh+o8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lokesh,


On Sun, Aug 10, 2025 at 2:29=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.co=
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
> Changes since v3 [1]
> - Fix unintialized 'step_size' warning, per Dan Carpenter
> - Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
> - Removed flush_cache_range() in zero-page case, per Peter Xu
> - Added comment to explain why folio reference for batched pages is not
>   required, per Peter Xu
> - Use MIN() in calculation of largest extent that can be batched under
>   the same src and dst PTLs, per Peter Xu
> - Release first folio's reference in move_present_ptes(), per Peter Xu
>
> Changes since v2 [2]
> - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> - Added check to ensure all batched pages share the same anon_vma
>
> Changes since v1 [3]
> - Removed flush_tlb_batched_pending(), per Barry Song
> - Unified single and multi page case, per Barry Song
>
> [1] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@goog=
le.com/
> [2] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@goog=
le.com/
> [3] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@googl=
e.com/
>
>  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 127 insertions(+), 51 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index cbed91b09640..39d81d2972db 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *dst=
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
> + * move. If so, then returns pointer to the locked folio. Otherwise, ret=
urns NULL.
> + *
> + * NOTE: folio's reference is not required as the whole operation is wit=
hin
> + * PTL's critical section.
> + */
> +static struct folio *check_ptes_for_batched_move(struct vm_area_struct *=
src_vma,
> +                                                unsigned long src_addr,
> +                                                pte_t *src_pte, pte_t *d=
st_pte,
> +                                                struct anon_vma *src_ano=
n_vma)
> +{
> +       pte_t orig_dst_pte, orig_src_pte;
> +       struct folio *folio;
> +
> +       orig_dst_pte =3D ptep_get(dst_pte);
> +       if (!pte_none(orig_dst_pte))
> +               return NULL;
> +
> +       orig_src_pte =3D ptep_get(src_pte);
> +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pt=
e)))
> +               return NULL;
> +
> +       folio =3D vm_normal_folio(src_vma, src_addr, orig_src_pte);
> +       if (!folio || !folio_trylock(folio))
> +               return NULL;
> +       if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) |=
|
> +           folio_anon_vma(folio) !=3D src_anon_vma) {
> +               folio_unlock(folio);
> +               return NULL;
> +       }
> +       return folio;
> +}
> +

I=E2=80=99m still quite confused by the code. Before move_present_ptes(), w=
e=E2=80=99ve
already performed all the checks=E2=80=94pte_same(), vm_normal_folio(),
folio_trylock(), folio_test_large(), folio_get_anon_vma(),
and anon_vma_lock_write()=E2=80=94at least for the first PTE. Now we=E2=80=
=99re
duplicating them again for all PTEs. Does this mean we=E2=80=99re doing tho=
se
operations for the first PTE twice? It feels like the old non-batch check
code should be removed?

> +static long move_present_ptes(struct mm_struct *mm,
> +                             struct vm_area_struct *dst_vma,
> +                             struct vm_area_struct *src_vma,
> +                             unsigned long dst_addr, unsigned long src_a=
ddr,
> +                             pte_t *dst_pte, pte_t *src_pte,
> +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> +                             struct folio **first_src_folio, unsigned lo=
ng len,
> +                             struct anon_vma *src_anon_vma)
>  {
>         int err =3D 0;
> +       struct folio *src_folio =3D *first_src_folio;
> +       unsigned long src_start =3D src_addr;
> +       unsigned long addr_end;
> +
> +       if (len > PAGE_SIZE) {
> +               addr_end =3D (dst_addr + PMD_SIZE) & PMD_MASK;
> +               len =3D MIN(addr_end - dst_addr, len);
>
> +               addr_end =3D (src_addr + PMD_SIZE) & PMD_MASK;
> +               len =3D MIN(addr_end - src_addr, len);
> +       }

We already have a pmd_addr_end() helper=E2=80=94can we reuse it?

[...]

>         /*
> @@ -1257,7 +1327,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd=
_t *dst_pmd, pmd_t *src_pmd,
>                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
>                         err =3D -ENOENT;
>                 else /* nothing to do to move a hole */
> -                       err =3D 0;
> +                       err =3D PAGE_SIZE;

To be honest, I find `err =3D PAGE_SIZE` quite odd :-) Could we refine the
code to make it more readable?

[...]

> @@ -1857,10 +1930,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, u=
nsigned long dst_start,
>                                 break;
>                         }
>
> -                       err =3D move_pages_pte(mm, dst_pmd, src_pmd,
> -                                            dst_vma, src_vma,
> -                                            dst_addr, src_addr, mode);
> -                       step_size =3D PAGE_SIZE;
> +                       ret =3D move_pages_ptes(mm, dst_pmd, src_pmd,
> +                                             dst_vma, src_vma, dst_addr,
> +                                             src_addr, src_end - src_add=
r, mode);
> +                       if (ret < 0)
> +                               err =3D ret;
> +                       else
> +                               step_size =3D ret;

also looks a bit strange :-)

>                 }
>
>                 cond_resched();
>
> base-commit: 561c80369df0733ba0574882a1635287b20f9de2
> --
> 2.50.1.703.g449372360f-goog
>

Thanks
Barry

