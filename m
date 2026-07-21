Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3953C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C5F6B007B; Tue, 21 Jul 2026 04:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD326B0095; Tue, 21 Jul 2026 04:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBE46B0096; Tue, 21 Jul 2026 04:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6946B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:01:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BE5040410
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:01:08 +0000 (UTC)
X-FDA: 85012038216.03.04CE398
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0ACB8A0015
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:01:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSDQqTuh;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784620866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GenzPzcYbFf+w6RJ/NVkKF8Dt0CNm/M4SQ446MxELY=;
	b=5H9B2jqQSZazDD/ykMjxecdxuIBAH4CcF2h734tKrxhAhCTZXOfSVKACKkjGYkDJdr5U1v
	w3PDZahEH+g90YSff9rylKvn0Hx6YHH151wtG3eodEVKY4m4yYQDgduffWVlnABmxAeHqE
	MEFrAvTBi7FCfN4ZAVm7WTbTRkjCkcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784620866;
	b=kG55SNdMk62rxBiw0058QKEgKgdhJCKW9w2NH0BbeW8NRmBDDcmKUVAnMHuVgkoMy2Gtgw
	IcHIbdTmNBQi40Ex8R7p2PBS/m1TJlNXvWW7ElDtGQf9NuNI2bpirKKnnENvSspOsAiAdu
	Zr4PDmUBSXCdGZU05uDuQTLkzm+c358=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSDQqTuh;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AD1D450D6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D29C1F0155B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620865;
	bh=6GenzPzcYbFf+w6RJ/NVkKF8Dt0CNm/M4SQ446MxELY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oSDQqTuhskefxln0WsyjLF/koPtYsau0RQvIzKsmAFs7XLCPvs5Fi0XTWC46Y2Zos
	 b6fRsfyZBVDc1nEO+ZUBJzQa8Qp52bRJADyZeo4wLsCzdcoybBhpJ8qQ6et5rtUeZo
	 sWyVA3usbberbyHijsBWrMThw6OBBaeSXAUNWEdSPuGNhyvJXK28SNQi/lhcVs/WY8
	 jGUn2t2Z+t8WP01I4r6HewhkXFan9Lx96Bk79vEsMnEXakvZguqP/Bys9zG1BYIYVF
	 XWDRZlfC1RudSUqJ4nqSOYCmbGUAg2lgJ6ETB6OztIrqQXNqDKtyzdC9aEZDUThUXd
	 UkxX12Xjp93Dg==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so86184576d6.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:01:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqRJYHiJJ/oIuM5XxEBkglG7hRjBoBSzHZ4VfYg05/WQs9aic6aDOUKuS+ftEGUaDcgdCWT8UP2Uw==@kvack.org
X-Gm-Message-State: AOJu0Yy9sVd0Nbom5cg3Hd6Mnw38uDOvDj/Pt3aHi7bdRbkNsIKR6b9q
	khFLErkONCTOKW334imdbjhc6FyZ3yrNQZuJhGBTKeJjgdQsKEhZYS947mKcK8v6PWSQhQVUokt
	Kcy9MkREkiG24Kfw5cZFMqL74squCID0=
X-Received: by 2002:a05:620a:1a1b:b0:92e:cd21:447c with SMTP id
 af79cd13be357-930b3f3e243mr1658877285a.38.1784620864331; Tue, 21 Jul 2026
 01:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com> <20260717122514.51514-4-xueyuan.chen21@gmail.com>
In-Reply-To: <20260717122514.51514-4-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 16:00:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yj3dYah2exFWLMwFhUysOz2U9ANyoESgdGKvRL0E_0zw@mail.gmail.com>
X-Gm-Features: AUfX_mzV7chpGdNffqXbImgVBBAcu9kSDaNJlsxvxuv1ZaQiruWokGqb-8_Rtmw
Message-ID: <CAGsJ_4yj3dYah2exFWLMwFhUysOz2U9ANyoESgdGKvRL0E_0zw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baolin.wang@linux.alibaba.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0ACB8A0015
X-Stat-Signature: 8acj7q35fwjpmzyke6m41te9u3z3hdnq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784620865-79634
X-HE-Meta: U2FsdGVkX19hl/+hfPdDTNjMB9YMsQByzgejd+IT4k8PEz1qmOElPs0SYZRz3P0JUVHHz/ASwE/Uzk9WNEqydO6faVflLDdBgnj67XuJTRnhvKJYT0ZSstaIrKUJUnaN764CKUkyT1cCRJm0O/ui1opTUCcLbXJ2S+vjUspjM8MljLGC5ZoWEJviHpxjQQwHg8Q3+XeHclwM/kUMUE4Qco+9cbt4gWiBfJeRcHhoxuzUjcLOvwDNoH+w4HprrdnNDFUhi6CIRfZIuX6mo74SEQrcXQoCUbX87pMhsrqZgoN1yvl5Y8q2PHtoy5Tuz1lTZr/G7cu00sGDYX2Elc0p5NKlF0Ssv5EOFTw+BSQ8gOMOnp/UQOWycoZRCEoJNNUvcFt4AIScNCXwe+NpuxPwMKIpaiNAnjrTJ8CnUfMy5Z6qdNznniCWgpzoYarS07idAy/+tg3bSe/7+wHrE20qugOM3qt7xRu++BR/b79wObhVpe8BhYNqP76IbcZhF8NBDpDEbhIlb7RCZgPmeL7WNeWWYTHpkfdx470lRFi3In4R20GdUnw1xiKrLo5jmHKrN1F+TBXv0KKd0y0NyDym+obvJmoNTF+xx5O0nhh1KaoolJsfKgJUl0uUBv2NRMmij4u+PkbgKgrcKvMgPYkcbwisRfXW7QBIPa/NC4f0KKv8qHmJCgCsMH0Ye2EW/GtMMviwTwkYuAE/H6bRC2ziRcZhYpGXQ96Ia32PpJqekyGwqL+/tmM8Zg4AOJydi4YJgFg778eu/rBNpNm9zKq2Az6Vcf5s4y5xvosszINCcMNY30k0fiiY6CLOW9sy4NVY4qD5Q2h4doZnRvFWcY6aUkMgaXvY/xviLQmHniuI2sNzg9oeTtguj2v3KVazF1aU7cpxTLBmzzXLKJYKCvGZV6MfyHg6eQHQYrHSTN7AWpkcSBM2gTBrvtgCSB4gisOlX00sIW3GdEbVaQyZG5P
 IjD9GWEG
 oTyW+gYxh49SQP3Y5X6EB8qT8nclEFMatAwFxsWaOaopGtPSZt0WstO+fhPyLRYWjMZxLtKaDJGUH3JoeiSjyKSKYyseya6pTlWYZc1ZYb1XGehpzAyW8/6pbuPJNzPuw9PThmG+RkjqtpKG344n4W6MyFz30/fQckXh7KpEFiF7cU/23Yj+vvuEHeAA5oxuuq+5AogUwWO5VsA/c6hapX8knR+Ba5eFMShvdJM3Q+7t1Q9CChGcP4Gp4rUbRaycB1e5M0CwGrroLfLgubqzVSxEZkONcSkt87PxLOSkqdvZin/EAKr38ChAbR8+60xh2IkdA0i8wbdnZvtln15X3qIgiKkkohgVm5Z0dSfqoCJgrvJRs7bshs38QVBqvXiptkD5eygDiKX+c/hyCPXeson/5chavBFbGombGtJALOIooK/BLD8Tz+gIKgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 8:25=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>
> When swap is disabled, exhausted, or unavailable due to memcg swap
> limits, splitting a large anonymous folio cannot make swapout progress.
> The fallback only destroys the large folio and inflates split statistics.
>
> Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
> the folio might allow swapout of smaller pieces. For other allocation
> failures, keep the existing activation path and avoid the split.
>
> This preserves the split fallback for fragmented or partially available
> swap, while avoiding it when there is no backing space for any part of th=
e
> folio.
>
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..40340a88f78e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>                  */
>                 if (folio_test_anon(folio) && folio_test_swapbacked(folio=
) &&
>                                 !folio_test_swapcache(folio)) {
> +                       int ret;
> +
>                         if (!(sc->gfp_mask & __GFP_IO))
>                                 goto keep_locked;
>                         if (folio_maybe_dma_pinned(folio))
> @@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list=
_head *folio_list,
>                                     split_folio_to_list(folio, folio_list=
))
>                                         goto activate_locked;
>                         }
> -                       if (folio_alloc_swap(folio)) {
> +                       ret =3D folio_alloc_swap(folio);
> +                       if (ret) {
>                                 int __maybe_unused order =3D folio_order(=
folio);
>
> -                               if (!folio_test_large(folio))
> +                               if (!folio_test_large(folio) || ret !=3D =
-E2BIG)

I'd rather split it into two checks:

if (!folio_test_large(folio))
         goto activate_locked_split;

if (ret !=3D -E2BIG)
         goto activate_locked_split;

This makes it clear that ret !=3D -E2BIG is only relevant for the large
folio case.


>                                         goto activate_locked_split;
>                                 /* Fallback to swap normal pages */
>                                 if (split_folio_to_list(folio, folio_list=
))
> --
> 2.47.3
>

Best Regards
Barry

