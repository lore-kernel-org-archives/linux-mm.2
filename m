Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9FDCA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 02:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F7E6B000E; Fri,  5 Sep 2025 22:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925D56B0010; Fri,  5 Sep 2025 22:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B476B0011; Fri,  5 Sep 2025 22:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA956B000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:01:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBF1F13ACAC
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:01:09 +0000 (UTC)
X-FDA: 83857172658.05.C9ED251
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BDD34140008
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:01:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrCfJBIZ;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757124067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbJzjV7JOFOU1WmQBFXJ1vl0QZuK2qqR1mpGqeSGirQ=;
	b=R61ii5q9ZSQ9IcRvH4jIWQHegtl+rur/ou3DjCyENbygTQox4zQ0puQYckYQzxIMzvEKYe
	Eh55LGL2xRoCHN3qFYcCsRWgXXzwTW5l2sJGsRbtQpap1U3NFk6Uv1VqQFjl1L5ifoxFTA
	gGVp69SLo5iF6XYP47vM0qtRnhgQWEo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hrCfJBIZ;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757124068; a=rsa-sha256;
	cv=none;
	b=6KKWl9fmvtV9GlqC0SuEKFMj80LFveTR0Icvwy09n5i8W5edPTXwIpteyKSWbw9srUJ5hg
	Lqf/m9eiQGQyItUqd1ch/mPJ5KIdqM8eITkr9rMAhxUiM/IRCa+qxomVlkEL+YfiYzI6Yo
	K7vabfQabhup2SBAj7162fzVf/cEZM8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8B0945056
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9EDC4CEF8
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757124066;
	bh=Bt8M4XzKv+TALs6kSBhqbCJl3uqzCi+K19+0VZxkykI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hrCfJBIZmlutaRS35+CCLj1CEGPeN2PhQIETDaylYH725FTEILLcudUErLxr1hmaa
	 EDnblbg/4pHN7QFbMa1zUTGzPA9u27z/3l6s5B4sDG2xlPSZjktiJegb5YN+V6qv/w
	 5X3vhzV5iSQH1705SNtN5iSD99M/X/+fql1YGKuBOzrosnasQhsvwvASk6/bzfGljV
	 2oY65Ye+EWwsk1kCNc7NQT23nskY3CMgSgaYJ98Ya1qWaae/d6Oz2NNXidbeC1N4Vo
	 qiY0rGPL4UzosbTdt/MY1Ju3ukcgf/BcNTDJj8bU9Tg9Dpj708gNyYy8jMBm/QxQxo
	 otBuc2bq6WRUw==
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45ddca76f22so16425e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 19:01:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YyghyGCHVALDi1GQtpTsOScEM8J7wny/mX9HdUBLq2CtZ5MyYrF
	yDtvoGFxw92YMkVAknAO4mEIh6WNe02leayvPwkIL5aZtHtfwS2fa7bXWFj9pogRvCY1+kZ/0oT
	0fdLvNVH98P6g6ar77/NiFdRMTvjXGbSFmLiP+Mct
X-Google-Smtp-Source: AGHT+IHsU9FY2VqIGXmiq0V+dlQFLizOxn+lEe6yU6xu9+VXWgkhS8wguDgQDnsAddQmW9b7x1YQ9CKtMcWV8PT0B5k=
X-Received: by 2002:a05:600c:35d3:b0:45c:b4fb:f0b3 with SMTP id
 5b1f17b1804b1-45dde171ab0mr286205e9.3.1757124065095; Fri, 05 Sep 2025
 19:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-5-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-5-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 5 Sep 2025 19:00:54 -0700
X-Gmail-Original-Message-ID: <CAF8kJuP=Fm788hcc0oykU1V1ZpyuzVBjXH1XZykASTf==y3OYQ@mail.gmail.com>
X-Gm-Features: Ac12FXxH3yMevmtXiv7sHwQk_WTezUYpP5pTJgnfA9_PbB9gRKPG7JZK6WDqdvI
Message-ID: <CAF8kJuP=Fm788hcc0oykU1V1ZpyuzVBjXH1XZykASTf==y3OYQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/15] mm, swap: check page poison flag after locking it
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r6iymmrszc697atftf9ufubm8hzsimtp
X-Rspam-User: 
X-Rspamd-Queue-Id: BDD34140008
X-Rspamd-Server: rspam05
X-HE-Tag: 1757124067-85251
X-HE-Meta: U2FsdGVkX19xTcb5FHrlf170SFFOJGVKDSk1VdrlXt7O+iWzOBF9g0hC9oVZoAapyj/tokK1sCpx8aiOye3wmSr8r/6Oqr8hZKwa0oZXbM5WBZy2ZABssN7M/BNbyfRTx2EJM+LBsYk4eu6uATISTwaYnJ3frqejloG7XuwOUceqgVJKK1iAseYBQvTh9WwN4Op7dNz3tHWa6sSdsiqpqpoC81qNSPGiQc55iSCYqd9ORGTYYMRDv0D1iBpIUQwJm4PT7Q4YAMAl19wjFYgjlZ23UqGM9m5R0ig9wEu2wcKYT4rMz4BKGcIh//zmgATVpbZ0qa5Gkn3fpIkR4nihuQsl472LqEXMv44QPo/8cJDvhu20WCNMhFj2NV89XFrg/GZsnvkIN3Sm7JSJrDk8gE1h8Ul11n37iMb6FcXYyHyAVIC0cOz0nVcCfWWmlRjWAbdi2Kk7GExQyC5vWQuov89nXRjWh5uOGnEBNceUsSowMZXlRBonPDmxQpj0EakAV+2nSzUY+zaR5Isakvu38gYiXuSmCSvEMybH0XFj/Zqa/Q+XFkEbv/lmw+ZW7O+4nd3WpHtrRNF6RfrHQugvVGQZBI/A7u2Ux3tQ0nDQeS27/+yOKqIHqm2whlLj/tFORk3ywCndmhpsu5jwcq+WARPHiGKtAFZx+7GispeOyCKJA/kvnrfqMtNj8vGM/X+E78LlC66oC6M+Ba/mObhkllqa9yMUrjKa2TySedu6GBAZ3UnNxnMkm3RiOVoVf/MTkDYGd2FDVvNAr7VKAFJrVO4J4K7Ma7mEAQ0LSIEXA8pZOCZNtxVhAeLT0V3CrP5Ap8vbNDRK65Q8tkCUf2WdeTPpmq836RBciGjUl25UDn/SHYyW1NEnu2OyiBqUdT4hVHgscqgUSKLYpDmBQH/xxVOI5MsQWs+6Nb3FA116qmgRrJbgQ60wQ4N0LkILh1O7XIgBAdTNvtQMSnJNh/O
 Fd6KASOw
 ordoc4z1kNVmybYaFRgIsf6XsbGKUig/bXJSWuciYDsTjj0H62EjfbPaiPGcGsRi63P9fmXvpm/+L7Ofb5HvDH8yH7TlwOyrkXV2VrO01HgCQXAUJyTLQqOOhoFWherD3xHHrYdTvE1ZHD85qxxcnxQ5egcoqGpwLmw9eKufLgQk6ehXu8ElUEsFS2lVUyu1QeN1cYYBQ9CoVcOChPtKKC3EPM0/jYwGCJEJSzoYUxQc10o5oalFTwoJsc4SXoC19cCF/yVbySh/XKui0BDi3OWlx+Cao/d/ZRbHEmnr4fHJ9so7Y+yel0VnEiaqzTCaaYYBIyZZsd1ECyyoTZ6ebF84WCGEXYMiqiuHedykofnEJPqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separating this patch out makes it easier to read for me. Thank you.
The last V1 mixed diff is very messy. My last attempt missing the
out_page will unlock the HWPoison page as well. Now it is obviously
correct to me.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of checking the poison flag only in the fast swap cache lookup
> path, always check the poison flags after locking a swap cache folio.
>
> There are two reasons to do so.
>
> The folio is unstable and could be removed from the swap cache anytime,
> so it's totally possible that the folio is no longer the backing folio
> of a swap entry, and could be an irrelevant poisoned folio. We might
> mistakenly kill a faulting process.
>
> And it's totally possible or even common for the slow swap in path
> (swapin_readahead) to bring in a cached folio. The cache folio could be
> poisoned, too. Only checking the poison flag in the fast path will miss
> such folios.
>
> The race window is tiny, so it's very unlikely to happen, though.
> While at it, also add a unlikely prefix.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 10ef528a5f44..94a5928e8ace 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 goto out;
>
>         folio =3D swap_cache_get_folio(entry);
> -       if (folio) {
> +       if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
> -               page =3D folio_file_page(folio, swp_offset(entry));
> -       }
>         swapcache =3D folio;
>
>         if (!folio) {
> @@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 ret =3D VM_FAULT_MAJOR;
>                 count_vm_event(PGMAJFAULT);
>                 count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> -               page =3D folio_file_page(folio, swp_offset(entry));
> -       } else if (PageHWPoison(page)) {
> -               /*
> -                * hwpoisoned dirty swapcache pages are kept for killing
> -                * owner processes (which may be unknown at hwpoison time=
)
> -                */
> -               ret =3D VM_FAULT_HWPOISON;
> -               goto out_release;
>         }
>
>         ret |=3D folio_lock_or_retry(folio, vmf);
>         if (ret & VM_FAULT_RETRY)
>                 goto out_release;
>
> +       page =3D folio_file_page(folio, swp_offset(entry));
>         if (swapcache) {
>                 /*
>                  * Make sure folio_free_swap() or swapoff did not release=
 the
> @@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                              page_swap_entry(page).val !=3D entry.val))
>                         goto out_page;
>
> +               if (unlikely(PageHWPoison(page))) {
> +                       /*
> +                        * hwpoisoned dirty swapcache pages are kept for =
killing
> +                        * owner processes (which may be unknown at hwpoi=
son time)
> +                        */
> +                       ret =3D VM_FAULT_HWPOISON;
> +                       goto out_page;
> +               }
> +
>                 /*
>                  * KSM sometimes has to copy on read faults, for example,=
 if
>                  * folio->index of non-ksm folios would be nonlinear insi=
de the
> --
> 2.51.0
>
>

