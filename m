Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F41FFCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF64D6B008A; Tue, 10 Mar 2026 04:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4066B008C; Tue, 10 Mar 2026 04:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BE26B0092; Tue, 10 Mar 2026 04:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A598E6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:29:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52C315932D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:29:49 +0000 (UTC)
X-FDA: 84529480098.13.703DA2F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F8C11C0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:29:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJQBwvn9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koBz8Yfvc2X9VZK8Y0TzSGT8zXiTA2ycRDe6JWxCpSQ=;
	b=Dsp9n+V2Yencm0xWEXSn6bmlgrLwhcKx8wM+s8Cwnq7dq1He8KBTu7/Bxqty/2wyXz7D7C
	B75+r91Fp8vgB0yHj1fyFFWi5lfAFu9GeFfE5NzOfJbJ0wcYgQ0lGm4RpNqJxLqgfsqKEV
	Z5tkM7XagZmpad503w/vJBY6BF7dlq8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773131387; a=rsa-sha256;
	cv=pass;
	b=GKCoh+coiFSsmjpNO5FSOrrdNdGgNWtOkcSNzpwnqxoAQcKXrjZ/gL90QtIFkdV3Z6041a
	8resRUr2vw8YmID76D+JS1rSrwcaeT1jlXgUkTKiw8GzO+Xc7Y+aJum/S8YDlA6Jb/NkvB
	caOo1hMfFseq1lftYdMve4o2bgyLyLs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MJQBwvn9;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6611f41eebcso7585307a12.2
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773131386; cv=none;
        d=google.com; s=arc-20240605;
        b=h98m0w3J35UxxIusLHSqUSZqZs/ESQ0z6F3zVKBcSnvtEAfC9FMF2OkUFuOnSoex9A
         QxVGPN++ZJAYplW1Zyow4s+oLFK3hvb3XuGC0ffI2/gO7rimU6qhw9MwdVC8WP5tG49a
         ZjArpAI+wehosry0xtEnMoFUvP5ufATM8Orb8/AcWLFvGDUhC177CglnkH+5hka1kNLy
         BVQubC8rvbUBW9/Y9iVfOnHxfpOSAy01po/MA85qmtj2fFaUq8t8l4fUMxDDZ3OpKi+h
         hFEus2J/0/CQ0qUbDLTaAXVpLWgZZCe6t0OiF6zomBLQVhqG+4a2SSGRjB4l0hFIstwp
         9hlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=koBz8Yfvc2X9VZK8Y0TzSGT8zXiTA2ycRDe6JWxCpSQ=;
        fh=E+kB3ZOtQAtORLU2aHFyutIHS4CijFEv2yU86XIUwOQ=;
        b=GxsR1nOFoSQ9n7wW980Mqr/4CiM86vKfWan2m47kvbfuQDGNulIAmZGDSYvEwPQ3ZN
         su4KWQDYqHD/S/Y+r7Li1eeKjbcqZW5Mw7D0daw237r08pOaXPNunES4ZxFXAYZijWF2
         X1X5QfhIm7tcdvwwcO8QDAtBS7b7clRh9GAe6eSRtC2C9M2LS6NAA/MLdwdmfBUv0VmM
         t3pr8lyic0jPQOavxyGeLOU+KAfQK3PjpJ9E/Fxxst+46CsPWIJXXqjpVPTXrgAFbklh
         DBy7hqxNhQH9runZvj4iU0O1RnuinChg/uwAwR0Wyg4HA+DAmILVpz4RL9FVzny8F2Gq
         AuFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773131386; x=1773736186; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=koBz8Yfvc2X9VZK8Y0TzSGT8zXiTA2ycRDe6JWxCpSQ=;
        b=MJQBwvn9w4tM0MvR8nv8mbP9ZgdpC+JkIZCGRvCLnLglErh8sZl5GMUinor3f26h0g
         271zxHuYtpr3YTqBIsO0DxGCSe13Ln/tPunoZSQ0nOCnrBKfELz8XivyT+EJdrhCDW0n
         3cw18+MLwrkyWOpIIMG6do57ZMKYSP2Y+hwJqZQMYpHFIT26FjtvgJ4aGYYlF3fVSgkp
         ru/1zDGa2y/C706q7MCC3prG4sxvt6D7fYg1aRpTZCLhu/EgxCnZ9kaEfAMCOJVcWLTw
         J3xjR/ewp3ZQyXwwOaYM1Nv5rfo+lTEPxXLKZL/PAoAytP6zvDs9Z71oGHP+J/LVYjPF
         gsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773131386; x=1773736186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=koBz8Yfvc2X9VZK8Y0TzSGT8zXiTA2ycRDe6JWxCpSQ=;
        b=IbaqNcJapQcdIC9kDwkQQ2b/9Bz3H8gA3p6QRoe5RUu51EbrweAASoaRzNsTq6Ww+O
         eThCwl7gdC5Dzmsz7rfPVnsxtSQXvoMPIzTMRVQaaphdQSJxx612ElHAZAXnNzQd+LVq
         6iKKFMakc9yPNWWK7e6s5g1cPAJkx8an1yoAV+QTt6kh+d5ydlQBpZbXxldBqGlMBXNP
         Z6tBDgAnX2ksLxV6U4im6TBV9tJpT4mfy8DVrvX/LIayVAE2+N4ksG+mkoL+KMQiaiqF
         ehxWBiR2O9PCkKIOnHNsZluymdy5ASZq2EIsThh1cMskGvv6iCJH5DGrdPy7/llaWWF+
         FTHw==
X-Forwarded-Encrypted: i=1; AJvYcCWaD9Tdoj2AU0AW2dhh5nBAnMQZ9Xle1bY6AZBicx1EUATlPHc71SpV7vsFyIvjNZRGCxbutfWJ3Q==@kvack.org
X-Gm-Message-State: AOJu0YzWFNJ8r38l+PNwQUqo0Lpq2vnFXvSi2jkBVgNNyBCnhKaj7dNz
	XUX7xhrQ03sIGwInv0Kj0Y2Wfj5GBFhI+h5JsnvZeVjDJ64tfWD6BsbjIyUfz7/7iW99qauFTcJ
	Fnjfz6IHi0ongORSNTjBfEik0PcE0/vk=
X-Gm-Gg: ATEYQzwNq/Gv0pm2OTERc6nLxg0Oiao1l6JO5kh1fARth986qW4omDa5T/1OKoSkC/L
	UJhpBBnI6ip/udHLg9rBNFtxTeyEeGzk5xPYwWIMLOmuFYp+0ToceuLn2XzS7DDy1APMUVCk8UH
	sDJzBqHoOtV/BGTbLGIQy4cXjuf3WkXqJBpF8M+wEsfItBDX0pJ+Ql2YlrXvoBox6PORL7veEc6
	G9EQD3xszoeQwXlEk4W3lKPkIAAtL1A1p/8mgXFx4yaJV5PBMaOTW6N8PSs9Gpn7Y+b6QPQ54p4
	+iMv+ssMV0eXjdDNpVR2/v146tgf1Sof4XeaGWll
X-Received: by 2002:a05:6402:42c8:b0:660:f1a1:e8dc with SMTP id
 4fb4d7f45d1cf-6619d4e6b14mr8522156a12.25.1773131385560; Tue, 10 Mar 2026
 01:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260310073013.4069309-1-dev.jain@arm.com> <20260310073013.4069309-8-dev.jain@arm.com>
In-Reply-To: <20260310073013.4069309-8-dev.jain@arm.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 10 Mar 2026 16:29:09 +0800
X-Gm-Features: AaiRm51g7bEJzNTMY6wmhd2Lb1aJljzSp1iccGmd1ioD7gxSSZgnmu9BJCqSXRg
Message-ID: <CAMgjq7Dhjvg2tNbESyCqaEo9OrmWhdeTHyXiuyTzoTWcDRX+ag@mail.gmail.com>
Subject: Re: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	david@kernel.org, hughd@google.com, chrisl@kernel.org, weixugc@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, 
	jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yhfd59o9xqgiiphj14idjxjgnhq6eu33
X-Rspamd-Queue-Id: 4F8C11C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1773131387-633179
X-HE-Meta: U2FsdGVkX18eDlMR4NXzwx72HYCDIJxpoUSAk4kiPOlFM1HPSakwXdSpqAFREgIWRMQINDi7qkrM0I1vIYTec/AlyYhXEJVxu/6XyWzpOZHDCIlW8PLQgGqs8OC4//mUNbBuHcvhx8C8mwN+Yg18qV2zumApmVDTHvzZYHHO553oYxEbr6huzJexXPHvi7/p+4J14lOVs8dR8bQ7kRQklOwMdtV6hjNzNFqRRDiwhf4mjtRMjGskwUlKKRI1TpJ7ICDZgRXo9AnqMJNqPWta5lHqBy+WbYhd9s2aLMRQy2A4yjvNinbwJ8Tm06Rlp6OOmKm4DGJmOOfuGLHjIjnUCD7KHMXDMnSr2NUMefvAake2gq5XU1TLECz1flCWV8uAn/xMpJv0Erk3sLVYvzXvEBvkHX7ZZVITd/HEaP9bNPdO2jideN4tMm9sRi9K/AGlHTXcIRqHfm58xu+2M73whNNSZb5SRuaEt94uIieESOYmUrR4FFGteewlCgCt1gewEk1E5KA9+4Pf7lS2wQa7Q5Q+Pr7Gr91bP3i0SGwdT9PKAXjhgKPmWoK6I4BkslrbIrcE0kwrALkXKEBBpHSec3vBIBruJcDl3a/2JDaalgecQCDEXNl6f0JADR+IWFDs3Ki6pmopKmL31woVIgf4DSMFoNwbcaX3oIg65FHS+tC9cMNiKlbK16QbW/g3FfkJViBRI4+NfqQkf4UetJMk7M+A+Ev5nEfzbkH943PEkVflJTslNq1fwGVsjQIKETdYuA4XndfdIpynu+5lLA7pD7HM8/lv0AF2Am4+6FIaNBP4PrqFpfkQguC7zkyJp2KOEiDXmfFafOw02IZOhM1amUtsUCuW7Cc2+KZZwbuPmhB0mbx5IH55b8L7dY0PIXCtVtrdRP+RjDlDnQJgfQx5R+trbSMThSGn1BIcOoZSoxapnBOSxfTfDrU2U2KQ8GI+dnfRgAZmLTQfEByuz4g
 NAykp3Pu
 lbFEuHGacthtHFq0K5AqXcA7XMIsofjW+27nZQLedY7UGHRA3Fd2z3QgHrME07HKPn4a/x/ptLf1eZFYlBmSM7eg5mgLA9NoSLwNfu0UPoqc1kyIpSlWaW7188qyUoZ4dkQFwwQFGiqmj+XpAu3Cyy6twtOFtR8bbappCjl/WF/Mfqhl17fgYZg8sY7yp9czjLX7qmU7MT0wiDLimq8p/YwTmhIELBrDAHGol3VegNPnYzNCakfm0G/eZMolryRYyxzg91/3lqyxuNzIA9HdBEWtrfeMNDVCtGFdxbm/ugLxmFQbtWVZ7rbUPdZVEbdP1ACO7RPx55NJcX99yl/60ddcjIUFOOJQmjbm6GMhVktym2rZy980NiTm6QhEMFbCNPC44P6ecphOlhtEQhLtR5nuJaXfYv3yncU3MeHhvHko1TEa0vt+wIygB0oxurF460OMa7w/A9Zos0UBxoh93fHFOJzFHHLTKrwCwrki8TkjjYTb0rbOqtiMA1GT+BIDjs/cgMLqHDkbQjNarAIYKgxa/6E4uzZHVtb44DJhlwG2sp0RqNuaDtpx16yo9r+LS8OyIRa48IBpVwGOVQe1oDl4PmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 3:47=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Teach folio_put_swap to handle a batch of consecutive pages. Note that
> folio_put_swap already can handle a subset of this: nr_pages =3D=3D 1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection, and explicitly pass subpage !=3D NULL, and the number of
> pages required.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/memory.c   |  6 +++---
>  mm/rmap.c     |  4 ++--
>  mm/shmem.c    |  6 +++---
>  mm/swap.h     |  5 +++--
>  mm/swapfile.c | 13 +++++--------
>  5 files changed, 16 insertions(+), 18 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 768646c0b3b6a..8249a9b7083ab 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5002,7 +5002,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> -               folio_put_swap(swapcache, NULL);
> +               folio_put_swap(swapcache, folio_page(swapcache, 0), folio=
_nr_pages(swapcache));
>         } else if (!folio_test_anon(folio)) {
>                 /*
>                  * We currently only expect !anon folios that are fully
> @@ -5011,12 +5011,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> -               folio_put_swap(folio, NULL);
> +               folio_put_swap(folio, folio_page(folio, 0), folio_nr_page=
s(folio));
>         } else {
>                 VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, addr=
ess,
>                                          rmap_flags);
> -               folio_put_swap(folio, nr_pages =3D=3D 1 ? page : NULL);
> +               folio_put_swap(folio, page, nr_pages);
>         }
>
>         VM_BUG_ON(!folio_test_anon(folio) ||
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f6d5b187cf09b..42f6b00cced01 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2293,7 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                          * so we'll not check/care.
>                          */
>                         if (arch_unmap_one(mm, vma, address, pteval) < 0)=
 {
> -                               folio_put_swap(folio, subpage);
> +                               folio_put_swap(folio, subpage, 1);
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
>                                 goto walk_abort;
>                         }
> @@ -2301,7 +2301,7 @@ static bool try_to_unmap_one(struct folio *folio, s=
truct vm_area_struct *vma,
>                         /* See folio_try_share_anon_rmap(): clear PTE fir=
st. */
>                         if (anon_exclusive &&
>                             folio_try_share_anon_rmap_pte(folio, subpage)=
) {
> -                               folio_put_swap(folio, subpage);
> +                               folio_put_swap(folio, subpage, 1);
>                                 set_pte_at(mm, address, pvmw.pte, pteval)=
;
>                                 goto walk_abort;
>                         }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 86ee34c9b40b3..d9d216ea28ecb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1716,7 +1716,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 /* Swap entry might be erased by racing shmem_free_swap()=
 */
>                 if (!error) {
>                         shmem_recalc_inode(inode, 0, -nr_pages);
> -                       folio_put_swap(folio, NULL);
> +                       folio_put_swap(folio, folio_page(folio, 0), folio=
_nr_pages(folio));

I just realized that we already have a nr_pages variable available
here, maybe you can just use that?

Feel free to ignore this if it might touch more code.

>                 }
>
>                 /*
> @@ -2196,7 +2196,7 @@ static void shmem_set_folio_swapin_error(struct ino=
de *inode, pgoff_t index,
>
>         nr_pages =3D folio_nr_pages(folio);
>         folio_wait_writeback(folio);
> -       folio_put_swap(folio, NULL);
> +       folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio)=
);
>         swap_cache_del_folio(folio);
>         /*
>          * Don't treat swapin error folio as alloced. Otherwise inode->i_=
blocks
> @@ -2426,7 +2426,7 @@ static int shmem_swapin_folio(struct inode *inode, =
pgoff_t index,
>         if (sgp =3D=3D SGP_WRITE)
>                 folio_mark_accessed(folio);
>
> -       folio_put_swap(folio, NULL);
> +       folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio)=
);

Same here, nr_pages seems good enough?

