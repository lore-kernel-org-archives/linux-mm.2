Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1DFCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D717A6B008C; Tue, 29 Sep 2026 05:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22AA6B0093; Tue, 29 Sep 2026 05:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C393D6B0095; Tue, 29 Sep 2026 05:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97B946B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:22:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31B488043D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:22:51 +0000 (UTC)
X-FDA: 85266260142.27.B7D0FCB
Received: from mail-ej2-f20.google.com (mail-ej2-f20.google.com [74.125.228.148])
	by imf12.hostedemail.com (Postfix) with ESMTP id 410E24000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:22:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="be/4009a";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.148 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IN0tPSzGH98R2Pd3lnF+txldXvSCDJz1o/eX2B23T/w=;
	b=mQ3bHXZWSgtxZf3ld2m79ssUITzfZbE4oOjTLVIMly9b4yW7qux0F4IxqkZLtYsKG4Iz0o
	TeDgYWj4NEKg/Y7l4uE3jzG/gpIdYx31ulRzzNDQmNNpcN6G/sMwCMhgYWirRIoiVIQ1c7
	bjtsvRLBSLOCiUSFqYrDHmD2dXqcq6Q=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790673769;
	b=RPuy05l+3YrT13gHmdlSYWH9xOVw0mm2UtbSIAwvF3sITyguj61jbdZNI7dhDXLEP8qzDK
	ReQYkhgfTfjZrsV/d/mK7G0yOpSVka0W/tRMjvQmL1uBRWUrsXI1JaAISuj9jKav3SQGSS
	9kvFh3kE76z12eApDMXL1f9srUvrn90=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="be/4009a";
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.148 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej2-f20.google.com with SMTP id a640c23a62f3a-c293c683202so570798966b.3
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:22:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790673768; cv=none;
        d=google.com; s=arc-20260327;
        b=Mt/8e0PKHh68Ci+8jOrwUQKW57O2M3vaLSiD8fkZ5EDLfTFsjQOvQInIQZbG1A9rvQ
         dDFmEQDzVUY6PnOkD13PuHGh1Sbx994GBt1oil0Lowbo1NtlEcEbnhoD83B4FJsnS64S
         3p5UWZsFhyjXxe+0pzJqcMCeS9PbvrGk1wgdj5BJ1rhbCKUtsxwi87+6tUSFWpvnlX8f
         VM8M2dksDLNPjcnV9DCPzB8SMv82QCO6wt3tdmmsHPw9mjMyIcAnXGUQ84j2VTY+CZl7
         po+/PgKPqp8A5EfzVkQv4qrTwFBvfRVMteUJXAiGloq0P87ZMIS6MuLlB2z33ky4y7rR
         835A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IN0tPSzGH98R2Pd3lnF+txldXvSCDJz1o/eX2B23T/w=;
        fh=sV9IRgfHud2HnfcNsIlI8Fh73EXlsOiVM8TeMMYNTz4=;
        b=m5mQ/36B8yUsNgDUpjScjjt8wkZYHA2Q/C84d/eBJc/0DEZ6IggSVHEfpSAK4R5483
         AoQrIO/2PnO2GJrMtoTks8zDVtmzCXBKF/Dw+hs1pi8Q0b3PBtJeRzYB1UVDvAdB9iuR
         WM6E9TdKh9GuKL2DQpqkBROpq8Gq+9oW2QKR8F4pBM1H3SW0sk/+YYm/Sn0nc0/LtT/m
         Gpxb0WBJfP75+iz/RFw3wJbholVmhChNgMBHDPcbWoCXiDKXax8WYxATH+pEOlROuqh0
         v7XAaDkzytmsFBx6LKQjDGXyKnvwbinRmoM4dc0lszH6b1MMEevfwtbHMw8ZP0FzqdtN
         9wQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790673768; x=1791278568; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IN0tPSzGH98R2Pd3lnF+txldXvSCDJz1o/eX2B23T/w=;
        b=be/4009a+QwiNVJNnhmb4KHaijXvY1z6BGSAha+vw5TPExY7QT6g/zNJQopWY55NKD
         6OW7o1wDeDeWVk6TDWHQzib48IUvYoBvsYUH5kLiEt7FBqy9iigaXnq7k/U7/dNYTf0L
         jF/xhP3HvjMkFUuSpDaZExxIOQDOqFBV90BH0dJodOgSi+1EdbAocfUi8Ci1LSg40U1N
         f32a+Nj15njZDg8vCdROgtkaiAjqSUn0tSTefdOEwrPGsVQpcvAS365TFeMIN0zZ2l+g
         RTbfIrIgIZofIQj0E+W4okgSz/FWf/KmNQu0ML3qFApftVhX3+961fJtV0lc0fm31Bvg
         GlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673768; x=1791278568;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IN0tPSzGH98R2Pd3lnF+txldXvSCDJz1o/eX2B23T/w=;
        b=yDDHRyJRjS5oFfeeyd4FDegPY3cvgLFjUIWB1IllSSMMymFPkdEXOF3q7l8F+Ms/2N
         un0Hx72F8IET1+H/iR092AmUpKgzSM5Au9AHBIUD4i2G+Ac7I8Cgh+pHAUiekLMaBFbN
         FTU+RdcS3wE3cYoyM7bHrwe2+KnnuXxZmWbrbyMCw8VM+hTVBAYdd0JIeQUzIXTQel+m
         PSwF87caK4vnk8Mg1hW8sGjtrDfXcvDQGLfvN4R0KeT8cHnAvpUNrJ97LpfwTsbHjE7s
         aMdBa3FGJVXdpcU/XUVIIONVf6RwUm097AdRnDKh7ZEKjnRhTLbbfEx+OaAmoWQzqcYL
         +7HA==
X-Forwarded-Encrypted: i=1; AKwUvByQSr/L/G4Zv5rJVUV2NF3NxsLOO4s09dSNm6NxcRKx7BFmhv57rcFQbkk5q/7dkFqFRuvagHoEMQ==@kvack.org
X-Gm-Message-State: AFuF++m8c2CTqsma1gpwwmy33Hbhk+Jz4raEfvyihR6gUndrirzqmey4
	wdE/ijwB3r8ALTtxNu2N0wWKb3NKTPFgHTmXX0EpAgxOUgtrmSLd1KtjSDTi1Qwxx00JhApphWO
	03sp8EAsmO8dTr6DBjhrNjNJGpuDfd9I=
X-Gm-Gg: AYBFou1PWj6RuxWU6aOyoNrCEA1mSursSBUyGLnWBf8COzFJTwKgeUdAvxVDIURPWAn
	Wwk/6JDKcCCeyKcPSLYuvFYqDuqjCUJ97WfcjNH2KC5ef+LkMEEa/VnAmWHjL91K/0xeKesgHDI
	BakvOL+hr+Y38gMJaodtLlviD7bm58jTxrSHuK0pFtledspKufG2tlQdUKR7f9KP4/Fj77tE3+l
	Mm1dLs5wveqKO2Pwvx0a5qzQe9hNVCbhXJCkR3pQQNHLdHVGixTYjhHtr/cO8Ljz8jhnMn1EKsd
	3VTiJcLt2t6hIitFvcSQY1rATSvKx/bi5gNOROTcYRnmPPe3en8UcWw8M06li+59FgR4N34pjce
	lMwkFTg2xKbw=
X-Received: by 2002:a17:907:e0c7:10b0:c2a:f439:f028 with SMTP id
 a640c23a62f3a-c2af439f86amr589341566b.24.1790673767797; Tue, 29 Sep 2026
 02:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260924131106.1730494-1-dev.jain@arm.com> <20260924131106.1730494-3-dev.jain@arm.com>
In-Reply-To: <20260924131106.1730494-3-dev.jain@arm.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 29 Sep 2026 17:22:11 +0800
X-Gm-Features: AclHuK9DUtu6bTuANbbkm9jbY4Kl0z3X9Vvg3pkwBhg5_AJ3Q_VwlHfCh08tAEA
Message-ID: <CAMgjq7Ab0YwyPU28x+PohS=7ajPC4tguP62NDg748OwnLOx=-Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] mm/swapfile: add batched version of folio_put_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, davem@davemloft.net, andreas@gaisler.com, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, pfalcato@suse.de, jgg@ziepe.ca, thuth@redhat.com, 
	sparclinux@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 410E24000A
X-Stat-Signature: 3dw353d5fkc6ae37dtcqxj8naanjrd93
X-HE-Tag: 1790673769-84918
X-HE-Meta: U2FsdGVkX18a16KSJrWaJmzxxoqexBHxUi/gjoZEQCIR5ikenxmz9CtG9fUnzgWiBXUNfTC5U33yjKb/XiIH7Ta7cq3Y9DVt3u2krZ8T3BoEkw/F6oPIBbT1A+xbQCSuZ3QSKGj7ATXl1tAVkG49rAIb5rXvkBLAeSE6G1guydNO4uCXqq3adx3PqvscccSJIynh5ZH0eCebjx+NHy7cUyC5qqWAqQhfIN0B+UfM+Ctixh0Rj7I7DYG+hav7ZRwZg9aJhlwRNdIxrknUocAtKiGRelb7lpGJ+EMc7k++dEf3FCSVh4ZDtHl7mZXQEswLk93z3Y4E70hUFYxz4Qu8ub2t2eacMi38EcBWQgNMlnUZIrqv6P51fBLXjH1v3T+mgQOPnW6ZeW+xHPugZgDpN5xwWtGuXibDTCX/AJ3QNZbzcnIu5yV1nQ1u9+Lb8MN6uQtt3r3ftC4hvKfHFn+JxedVDKhdE3Vr+9VjfEA8y+woI2xdGYnrfs3x5sq3SvyLO3qR8qNaw/4k9squRwEdgCi7I4Jk3/1weuwHfxgJM4WmwiRPFXtHlHG9mJ0m/TArGMdrrY2yBOpdVtNsYsuSuT9X+6k0QDP/RZFQL5MLrEc8lIbtcAHNhGdmhaF6ObkB2IDoN0IACrgabHQ/2vZ95hjYroWylgXqdfMjfWpm4fI3mMZS5bxWpjmwNzKqCb9PzGaV+aKHn2pArvUZYPPpCWM3pbOx4stuXY71DvzF0cd7PaAeAwkh+Lka6sYwzGVuZRZAmT7B63XOhiuUxVB5a3XM0tMKAKAan7nU/C3BqrNPzTAlZf9/26Ffb6Cys9ZKOsO7KL9E2CTP6y/sS/Zs3gXo+7xX/rMOKc6yPplCXsS4BjHJhoRkjZmBNGvZ4VXKUjn4HepJjblI0aqLZH6SQw+17axHpC13697fjeeCr/c4lo+sVkJOXOdbtctUYo6PZIvxD1icKgcZDyf00S6
 l2Z0bWAo
 +Z8l94iHlEcynH9fw1UeUMWh6PGZIrewZfUVPQWpBIkhQFQwXZnAdcazhcZ7fdPxubYamjji9kWEOnhHACIhU+CZec1SfAMtI5WPofialxHkmLwzMu9atZQDLU47bkjxnRQK7qbI1Vd9zEIAXrHQoyS4GJ/wqVaGB1/EJL+2ziSBB7Na3ai5lSH3s8W67V5jHr9p8X5E/0sFwrPgGbolCLjB1FvjHoiutHc//hLi2mmh7kGVcXJ3XMKVxHfQ3VMXFWNiwogJOfcilOazGaMdMAxDWB3Kg4KYmN4AAa614sX/5bmtcatgu38nE5RFZlTHvYU/c/JB4R6GMClOvI+bV9HGgY9Ppg2cQU9pc2voTG/h/rFMiHDOC5l3/irBrHmrAuHvXfEzAAmwlK8RkediqfO64m4Klk7f48vm/9ptV6IUysDES+e1LJpTLBfwJGLjtgBethYFNcZJbbdoHOHkCWZDhjeVAEVHk4WqOlxUysZDmn4D1UE+wnoHoZ1O+D965ZH5tJNjV0Kgw3cuKQzZwtDs51KEYkEBObpEeTbAr+tnIT5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 9:15=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
> that folio_put_swap already can handle a subset of this: nr_pages =3D=3D =
1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_put_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 and folio_nr_pages()), and invokes folio_put_swap() if it
> wants to operate on the entire folio.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/memory.c   |  6 +++---
>  mm/rmap.c     |  4 ++--
>  mm/shmem.c    |  6 +++---
>  mm/swap.h     | 17 +++++++++++++++--
>  mm/swapfile.c | 21 ++++++++++-----------
>  5 files changed, 33 insertions(+), 21 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 338fce99e7119..a7e979bfc814b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5267,7 +5267,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> -               folio_put_swap(swapcache, NULL);
> +               folio_put_swap(swapcache);
>         } else if (!folio_test_anon(folio)) {
>                 /*
>                  * We currently only expect !anon folios that are fully
> @@ -5276,12 +5276,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> -               folio_put_swap(folio, NULL);
> +               folio_put_swap(folio);
>         } else {
>                 VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, addr=
ess,
>                                          rmap_flags);
> -               folio_put_swap(folio, nr_pages =3D=3D 1 ? page : NULL);
> +               folio_put_swap_pages(folio, page, nr_pages);
>         }
>
>         VM_BUG_ON(!folio_test_anon(folio) ||
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a70dbc8d544e1..fa9fc8374fc26 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2159,13 +2159,13 @@ static bool ttu_anon_swapbacked_folio(struct vm_a=
rea_struct *vma,
>          * so we'll not check/care.
>          */
>         if (arch_unmap_one(mm, vma, address, pteval) < 0) {
> -               folio_put_swap(folio, page);
> +               folio_put_swap_pages(folio, page, 1);
>                 return false;
>         }
>
>         /* See folio_try_share_anon_rmap(): clear PTE first. */
>         if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page))=
 {
> -               folio_put_swap(folio, page);
> +               folio_put_swap_pages(folio, page, 1);
>                 return false;
>         }
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d5bd9506ce500..5f46061c6320c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1935,7 +1935,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct =
folio *folio,
>                 /* Swap entry might be erased by racing shmem_free_swap()=
 */
>                 if (!error) {
>                         shmem_recalc_inode(inode, 0, -nr_pages);
> -                       folio_put_swap(folio, NULL);
> +                       folio_put_swap(folio);
>                 }
>
>                 /*
> @@ -2368,7 +2368,7 @@ static void shmem_set_folio_swapin_error(struct ino=
de *inode, pgoff_t index,
>
>         nr_pages =3D folio_nr_pages(folio);
>         folio_wait_writeback(folio);
> -       folio_put_swap(folio, NULL);
> +       folio_put_swap(folio);
>         swap_cache_del_folio(folio);
>         /*
>          * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
> @@ -2598,7 +2598,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>         if (sgp =3D=3D SGP_WRITE)
>                 folio_mark_accessed(folio);
>
> -       folio_put_swap(folio, NULL);
> +       folio_put_swap(folio);
>         swap_cache_del_folio(folio);
>         folio_mark_dirty(folio);
>         put_swap_device(si);
> diff --git a/mm/swap.h b/mm/swap.h
> index 47290510de264..7ae915f594034 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -246,7 +246,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, =
gfp_t gfp);
>  int folio_alloc_swap(struct folio *folio);
>  int folio_dup_swap_pages(struct folio *folio, struct page *page,
>                 unsigned long nr_pages);
> -void folio_put_swap(struct folio *folio, struct page *page);
> +void folio_put_swap_pages(struct folio *folio, struct page *page,
> +               unsigned long nr_pages);
>
>  /* For internal use */
>  extern void __swap_cluster_free_entries(struct swap_info_struct *si,
> @@ -375,7 +376,8 @@ static inline int folio_dup_swap_pages(struct folio *=
folio, struct page *page,
>         return -EINVAL;
>  }
>
> -static inline void folio_put_swap(struct folio *folio, struct page *page=
)
> +static inline void folio_put_swap_pages(struct folio *folio, struct page=
 *page,
> +               unsigned long nr_pages)
>  {
>  }
>
> @@ -478,6 +480,17 @@ static inline int folio_dup_swap(struct folio *folio=
)
>                                     folio_nr_pages(folio));
>  }
>
> +/**
> + * folio_put_swap() - Decrease swap count of all swap entries of a folio=
.
> + * @folio: folio with swap entries bound.
> + *
> + * See folio_put_swap_pages() for more information.
> + */
> +static inline void folio_put_swap(struct folio *folio)
> +{
> +       folio_put_swap_pages(folio, folio_page(folio, 0), folio_nr_pages(=
folio));
> +}
> +
>  extern const struct swap_ops swap_bdev_ops;
>
>  int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 75167b8580cc0..8b47e7f1e1931 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1831,27 +1831,25 @@ int folio_dup_swap_pages(struct folio *folio, str=
uct page *page,
>  }
>
>  /**
> - * folio_put_swap() - Decrease swap count of swap entries of a folio.
> + * folio_put_swap_pages() - Decrease swap count of swap entries of a fol=
io.
>   * @folio: folio with swap entries bounded, must be in swap cache and lo=
cked.
> - * @page: if not NULL, only decrease the swap count of this page.
> + * @page: the first page in the folio to decrease the swap count for.
> + * @nr_pages: the number of pages in the folio to decrease the swap coun=
t for.
>   *
>   * This won't free the swap slots even if swap count drops to zero, they=
 are
>   * still pinned by the swap cache. User may call folio_free_swap to free=
 them.
>   * Context: Caller must ensure the folio is locked and in the swap cache=
.
>   */
> -void folio_put_swap(struct folio *folio, struct page *page)
> +void folio_put_swap_pages(struct folio *folio, struct page *page,
> +               unsigned long nr_pages)
>  {
> -       swp_entry_t entry =3D folio->swap;
> -       unsigned long nr_pages =3D folio_nr_pages(folio);
> +       swp_entry_t entry =3D folio_page_swap_entry(folio, page);
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> +       unsigned long idx =3D folio_page_idx(folio, page);
>
>         VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -
> -       if (page) {
> -               entry =3D folio_page_swap_entry(folio, page);
> -               nr_pages =3D 1;
> -       }
> +       VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
>
>         swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
>  }
> @@ -2535,7 +2533,8 @@ static int unuse_pte(struct vm_area_struct *vma, pm=
d_t *pmd,
>
>  setpte:
>         set_pte_at(vma->vm_mm, addr, pte, new_pte);
> -       folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(e=
ntry)));
> +       folio_put_swap_pages(swapcache,
> +                            folio_file_page(swapcache, swp_offset(entry)=
), 1);
>  out:
>         if (pte)
>                 pte_unmap_unlock(pte, ptl);
> --
> 2.43.0

Reviewed-by: Kairui Song <kasong@tencent.com>

