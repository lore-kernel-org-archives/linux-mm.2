Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52535EE57C2
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 22:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71BE6B0089; Tue, 30 Dec 2025 17:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B536A6B008A; Tue, 30 Dec 2025 17:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1ED36B008C; Tue, 30 Dec 2025 17:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 911036B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 17:02:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A9A616038E
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:02:44 +0000 (UTC)
X-FDA: 84277512648.13.E2FA8FD
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 14FEA100003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:02:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B99gJspz;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767132162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJ/l/wlWS+0kxIZklYFazzTNR6Pw7JlS9BZA/0ah4k4=;
	b=akBv3EtXnweJhRHXe470MPCvHelCxZiHwqYTYMyYI59GmSijs1tFrwzyNktlb8XocTF2NC
	BDeIDP6g97pmOIqluss/VYWLFocNjhhWOAQkL+5xYRThdbNLC33LmCzlM7gzm2YdlQkE2R
	oLhrGCzM4sBjW5utYJC4r/+jrDKifeM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=B99gJspz;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767132162; a=rsa-sha256;
	cv=pass;
	b=7ewI4bAHPxh75TCpVJCmHgYign6OZXW4F7lIEvB3LbjWT7hDgZNv6ynDUTqyDym6Vwf5+y
	JgYPQizPjZ4RatkHmb7VjLsMRXvtqHLaiRMLcDpLpkp5zUeAGqdmgRvjsyU7GlG4SJEBj+
	6ErH8xUSaSlediaSD2Gju242kbfKlL4=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4f34f257a1bso72581cf.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767132161; cv=none;
        d=google.com; s=arc-20240605;
        b=Wi9Ylw1pS1lh946aTvm+zC7nLt2QkMX1DIyQcFtkrfTIqmD+qWObifSm4oAiKIrq34
         eJpyUE9zv3c7c1A510o5S+LjhNc8DsWHE/g/TvxvphDvFyZ4GIZ7nlDBXQopYrPQsla/
         fB930tsYHgSt3nma9gAGF5GGw1JDkuCpgiMNW3j1VNHvS+7dScCoNrb+BF0e2SbQLyr3
         BxktT0mm8HK5pRv4MCBUOGT0FKJAdrU1Q+qlSXMkjICPLFuHkEUDajsCLWkcT4oIW0Qf
         QhsIduJWPOryYde8D/L/AOjX6CQuYNKXubPbdFEQj2cHNgN96XyxnGm/vylGbuJB6cTd
         OAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJ/l/wlWS+0kxIZklYFazzTNR6Pw7JlS9BZA/0ah4k4=;
        fh=X37/J/dARL5ICCrHSHNFlVdgJWDJlo6kC6Jyb9Ddu+s=;
        b=ZOHXVau434jmmyDNBzfPfKbduCJ464puAcPE/7Y7yTEwbrsHdtO2WpXu+9mdOZfdWw
         /Pd6CeFKc7FLORnZ5PC7f0q82bczkna8DkTjtp2pgPo10PF5Aomrd/UPUW6jLKMEsEtS
         O8j5tR4yxZGH2QvdCvZ0KF4sewCBa0/OmyP/F7E8QHm4BdQtmFRQ9ROdGUtTTHmxLkYX
         QWNa+HLNuUR/c+gqnmSrn/VIeRjnRYzPT2hBEQGUA3X3+pAjAlLBUdpyNqjfOwYoi8ek
         ZX7DywszgNhJqoQjv4SyhYoFUy/MWpnlRHXClF16RHHOZ0TlvBvVozya8HaHn4B61HmA
         MdJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767132161; x=1767736961; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJ/l/wlWS+0kxIZklYFazzTNR6Pw7JlS9BZA/0ah4k4=;
        b=B99gJspzF5s3pYOt+56t3gYgz3Mcwcx+cdBcNbEkfXLKzFH4BDmu88KTcumo4oyCQ8
         PgUt6yGoQHDsTH6USLOeIhJR903HDgmR3g3rZC9c/G9nmTRxNeLhrody0wuR6eRl7sRx
         AwvkR5AfQQ3+1fPmPeSr+2C53L6xctoxJelGa9q4CvewuD+gdwRZEl4t5Ou3aN5cdVpg
         QVaZxgtEHXKrx3rgS4n0hUj6V4j6c1li1UNCkMCus8Kg93Yum401vS9/bFVmonp9yCiq
         J/bZ8zcdzFhsdBGqEsjImbHfp++1O83GoRILjf+xFl+iBnuG/cXhwz8XU3ZLozz+opTo
         EQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767132161; x=1767736961;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UJ/l/wlWS+0kxIZklYFazzTNR6Pw7JlS9BZA/0ah4k4=;
        b=TNpr2JWZIuAY0vJDAxqkXUDfzrr2I7Hax+9HAeQO6APrAVb59jhbQzQmcw8oADHhuU
         XZcOX3V82gbEpIacpvD8vCYzHuz5alMeC70/rqu8hoeHlGJx8nAXsuH4tALCDTXQcyzz
         HLozZ/NkwMZlWoshQJu+fMJSnwC3yURVhVjtZ8M3Kg9n/ulaxL42JnJ05lpmfOP7c4PR
         BdF8wJyGtZG7d0Fjx18+4/DZOLR8vXWy7V5hx4Sc/NPGPcYZN18TyesSLkr17yd16q5Q
         Cj+YLleoRQf+nFZuOfbtTVrkNfOS5Myoza+nUGYzmPFpGDQKI7LN63QeixqhQ2hS+tQz
         ky3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBS6iLZHh4q9wjOX6mFo8DwVPtx3B8BZVz9glGO9MHDjUCf0c+miwHjXMCvjNO0poooVBUsz2Jtg==@kvack.org
X-Gm-Message-State: AOJu0YwKiL63DgZIVpzlmx+0dXs59pX80qgDYuB2yhpFlTzKpIdctm5W
	80otIK38OwiUC7PjnTt835OGW94Bpw5uQHkp/vXMiTDw+uVYNj2R0I5cFjGmhvxCSF4yMb7gYuF
	a0g5UNrqLluqEFHJScDPkXL/LJYbg07G+mlq1u0+U
X-Gm-Gg: AY/fxX6clHOlspo8J/K0QALWatJaI6hMXnNAMjntxDGBqzA/4780QMUs6nR4W/seM3s
	DU56wAzZTRAE8PrzvozBIZNjUYyMOY20fpuSUTwfmi+tU/hwNVpJgr0L+U5WfgwRKbzrqOX/0yG
	IgmdIaRYqd1HcKQqgyanorDhTrsQPIDoTwvVERjFcKqC8fMWwtXCcK4RaKu9mdAetHvxz5Gcx3Q
	J5eFpRtHJQLeCILRe2zo1HVRRB4Tx0P9uvKIc6OqWVyyvpifIDGDpvZQPxf8ysJw6322mOm7iZG
	td/J5dS1XjrwDZ4Nk+c3A4hmNg==
X-Google-Smtp-Source: AGHT+IHcJZ/CgiBHI0uw3DSz+NboPPhVZGtuPXH9XLcSTcwODP7wlUTGlCPNy0f5CgxzPfgnhOKBCbAeqVJLjnM6sGQ=
X-Received: by 2002:a05:622a:2cc:b0:4eb:7681:d90 with SMTP id
 d75a77b69052e-4fbb2bd2056mr2322591cf.16.1767132160807; Tue, 30 Dec 2025
 14:02:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com> <175d29b48f7e49ce9a1b19e3a6c72cc80c0c5bb4.1765970117.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <175d29b48f7e49ce9a1b19e3a6c72cc80c0c5bb4.1765970117.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 14:02:29 -0800
X-Gm-Features: AQt7F2o-b0QytHXeqjdwnTIdqHnMF2MMdjSfLexXHgFPCLAqMIi-zxt2R1Y0MNc
Message-ID: <CAJuCfpG=D_MbZyauk2WJZ4evvoUQ0XEXwhwYpqS8rXqCGfVEng@mail.gmail.com>
Subject: Re: [PATCH 8/8] mm/rmap: separate out fork-only logic on anon_vma_clone()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: i7u74g8rcgpi3a7z3zkud7zzkk6paa7o
X-Rspam-User: 
X-Rspamd-Queue-Id: 14FEA100003
X-HE-Tag: 1767132161-896685
X-HE-Meta: U2FsdGVkX1/qdnl8c4+UbQjIkDA0sS2xJcTWDgtQeNHu4ljTj5isaQg2B3crR1aDl2ny04Y721MLS8WEf3/ZHWotQHH1yOR3+Ls7BcTf4nY//AoFjJ18Hpac0wmFOTXjV+uvKeGMwJ32E4dClXtdJTlXjNUMm4vWR6qjUNR/GklSmLPWG/+uhcMfIDXTETXHq3tLHDYseNCQmkJPp7+jpcKNJd0OR86VEH1vA9dRLj95Hi9dgshUq/3SG4GgWhFq0MJcI2rsTNbZtcWCLu56CCvfH532R6Pvr9Qbjpb6r9VaG18VCHJBpwPuadUHtqKJFggYEsZ8CZrc8bEmLAwjPxRtdVWHAqGPmVHVdAFmIKh9RVPLxR0O4LK2zy+JvCTyMP/lvH7ucjns5utFamVX+Dbzv3/UhTCsjvFpdOAjsIV2wpvHD1xgX99Et7xfBkUETCU7oxo9ySfKntkhcF/EQK3ohKqM9Nj37n+WB6GCqJoKFboFiUMLSCcz+aIabsiY4Lp1uAV2zL/bZW8JYysrEZUldigN1Gt+GORUDIr87CZTYnJK0xW/yS2rNmVGa3LaX+vCc1bduNHSHUvvmN/2oLeiuqqu0NS+GlsRG5RZKbUrhl5m72SK8LnZbTyI9AQHFdM/zvZfDIdvfviM4ljHAwi2ltfxIl0C+JFKcSjwOMeJWx6xmnvWLTdzeHDoLQhnVWpW5Ck43JCpLXhZwNj9icknDoGcjdx+7WSRJQrLMly7qVeuzcwjGMo8mLC51dW3fffzOqQxe+HufREPXp0BLvea7pWEkqikexEAQGSwsHE9ZQpTNkrwPsm82q3NoBv5laRko3ruIT83ZPS8/w+Ke8ljaDEwjODhA2BLN002/l3FefO0IfdkQ67zyAp6BJAC1USjMG0MvoObq6KXN13viCsAbK47YNGs8/itm67oMwIj495zN+D+h7OmKeYPgrbgm4Mc8l0r9W/JIxZyPZw
 Aq7Y9EBn
 WAmEHcsUZY2ZYaeE2r5EF8UG7Q1wOc4/CqIl149yZLwL7nlg/tuxTja7BYKxet+x330LP60g6K0xxKBvi9ykGfN9lKC/bqOONoCPEUhWcYD4yaiRBN3j+tkE/5B3LSywtnQ5RKW3h8NQUNhnkxHEt8AGjfKFf3mW7gikzdfkqkrOfsjh1ApVBgs01U1iE8W7L9fgYwZDjYxDoog0ZwFgLF7aVZqfHcfSe3M2Y3T/0e4NiY3tW/6+2No0dU7Aoj80pRs2uJEO6AULV6Ua81KhD61vwpaTRFMeb0Jsb6KxEp+puRvSYI8MJHjE3dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 4:27=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Specify which operation is being performed to anon_vma_clone(), which
> allows us to do checks specific to each operation type, as well as to
> separate out and make clear that the anon_vma reuse logic is absolutely
> specific to fork only.
>
> This opens the door to further refactorings and refinements later as we
> have more information to work with.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/internal.h                    | 11 +++++-
>  mm/rmap.c                        | 67 ++++++++++++++++++++++----------
>  mm/vma.c                         |  6 +--
>  tools/testing/vma/vma_internal.h | 11 +++++-
>  4 files changed, 69 insertions(+), 26 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 469d4ef1ccc5..b4d4bca0f9a7 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_=
vma *anon_vma)
>
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>
> -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c);
> +/* Operations which modify VMAs. */
> +enum vma_operation {
> +       VMA_OP_SPLIT,
> +       VMA_OP_MERGE_UNFAULTED,
> +       VMA_OP_REMAP,
> +       VMA_OP_FORK,
> +};
> +
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c,
> +       enum vma_operation operation);
>  int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvm=
a);
>  int  __anon_vma_prepare(struct vm_area_struct *vma);
>  void unlink_anon_vmas(struct vm_area_struct *vma);
> diff --git a/mm/rmap.c b/mm/rmap.c
> index de9de6d71c23..f08e6bc57379 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -232,12 +232,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  }
>
>  static void check_anon_vma_clone(struct vm_area_struct *dst,
> -                                struct vm_area_struct *src)
> +                                struct vm_area_struct *src,
> +                                enum vma_operation operation)
>  {
>         /* The write lock must be held. */
>         mmap_assert_write_locked(src->vm_mm);
> -       /* If not a fork (implied by dst->anon_vma) then must be on same =
mm. */
> -       VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> +       /* If not a fork then must be on same mm. */
> +       VM_WARN_ON_ONCE(operation !=3D VMA_OP_FORK && dst->vm_mm !=3D src=
->vm_mm);
>
>         /* No source anon_vma is a no-op. */
>         VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chai=
n));
> @@ -249,6 +250,35 @@ static void check_anon_vma_clone(struct vm_area_stru=
ct *dst,
>          * must be the same across dst and src.
>          */
>         VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon_vma=
);
> +
> +       /* For the anon_vma to be compatible, it can only be singular. */
> +       VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
> +                       !list_is_singular(&src->anon_vma_chain));
> +#ifdef CONFIG_PER_VMA_LOCK
> +       /* Only merging an unfaulted VMA leaves the destination attached.=
 */

Do you mean to say that for all other operations dst should not be yet
attached? If so, "leaves the destination attached" is a bit confusing
choice of words to indicate that attaching the VMA in other cases has
not yet happened. Maybe reword as: "For cases other than merging an
unfaulted VMA, the VMA should not be attached yet."

> +       VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
> +                       vma_is_attached(dst));
> +#endif
> +}
> +
> +static void find_reusable_anon_vma(struct vm_area_struct *vma,
> +                                  struct anon_vma *anon_vma)

Naming is hard but a function that assigns vma->anon_vma and
increments num_active_vmas should not be called
"find_reusable_anon_vma". I would suggest keeping the name but making
it return the anon_vma (or NULL if it's not reusable), letting the
caller do the assignment and the increment.

> +{
> +       /* If already populated, nothing to do.*/
> +       if (vma->anon_vma)
> +               return;
> +
> +       /*
> +        * We reuse an anon_vma if any linking VMAs were unmapped and it =
has
> +        * only a single child at most.
> +        */
> +       if (anon_vma->num_active_vmas > 0)
> +               return;
> +       if (anon_vma->num_children > 1)
> +               return;
> +
> +       vma->anon_vma =3D anon_vma;
> +       anon_vma->num_active_vmas++;

You moved num_active_vmas++ here to fix the accounting later... Sneaky
but correct AFAICT :)

>  }
>
>  /**
> @@ -256,6 +286,7 @@ static void check_anon_vma_clone(struct vm_area_struc=
t *dst,
>   * all of the anon_vma objects contained within @src anon_vma_chain's.
>   * @dst: The destination VMA with an empty anon_vma_chain.
>   * @src: The source VMA we wish to duplicate.
> + * @operation: The type of operation which resulted in the clone.
>   *
>   * This is the heart of the VMA side of the anon_vma implementation - we=
 invoke
>   * this function whenever we need to set up a new VMA's anon_vma state.
> @@ -278,14 +309,16 @@ static void check_anon_vma_clone(struct vm_area_str=
uct *dst,
>   *
>   * Returns: 0 on success, -ENOMEM on failure.
>   */
> -int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c)
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *sr=
c,
> +                  enum vma_operation operation)
>  {
>         struct anon_vma_chain *avc, *pavc;
> +       struct anon_vma *active_anon_vma =3D src->anon_vma;
>
> -       if (!src->anon_vma)
> +       if (!active_anon_vma)
>                 return 0;
>
> -       check_anon_vma_clone(dst, src);
> +       check_anon_vma_clone(dst, src, operation);
>
>         /*
>          * Allocate AVCs. We don't need an anon_vma lock for this as we
> @@ -309,22 +342,14 @@ int anon_vma_clone(struct vm_area_struct *dst, stru=
ct vm_area_struct *src)
>                 struct anon_vma *anon_vma =3D avc->anon_vma;
>
>                 anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> -
> -               /*
> -                * Reuse existing anon_vma if it has no vma and only one
> -                * anon_vma child.
> -                *
> -                * Root anon_vma is never reused:
> -                * it has self-parent reference and at least one child.
> -                */
> -               if (!dst->anon_vma && src->anon_vma &&
> -                   anon_vma->num_children < 2 &&
> -                   anon_vma->num_active_vmas =3D=3D 0)
> -                       dst->anon_vma =3D anon_vma;
> +               if (operation =3D=3D VMA_OP_FORK)
> +                       find_reusable_anon_vma(dst, anon_vma);
>         }
> -       if (dst->anon_vma)
> +
> +       if (operation !=3D VMA_OP_FORK)
>                 dst->anon_vma->num_active_vmas++;
> -       anon_vma_unlock_write(src->anon_vma);
> +
> +       anon_vma_unlock_write(active_anon_vma);
>         return 0;
>
>   enomem_failure:
> @@ -361,7 +386,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct =
vm_area_struct *pvma)
>          * First, attach the new VMA to the parent VMA's anon_vmas,
>          * so rmap can find non-COWed pages in child processes.
>          */
> -       error =3D anon_vma_clone(vma, pvma);
> +       error =3D anon_vma_clone(vma, pvma, VMA_OP_FORK);
>         if (error)
>                 return error;
>
> diff --git a/mm/vma.c b/mm/vma.c
> index feb4bbd3b259..e297c3a94133 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -525,7 +525,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_=
struct *vma,
>         if (err)
>                 goto out_free_vmi;
>
> -       err =3D anon_vma_clone(new, vma);
> +       err =3D anon_vma_clone(new, vma, VMA_OP_SPLIT);
>         if (err)
>                 goto out_free_mpol;
>
> @@ -623,7 +623,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
>
>                 vma_assert_write_locked(dst);
>                 dst->anon_vma =3D src->anon_vma;
> -               ret =3D anon_vma_clone(dst, src);
> +               ret =3D anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
>                 if (ret)
>                         return ret;
>
> @@ -1862,7 +1862,7 @@ struct vm_area_struct *copy_vma(struct vm_area_stru=
ct **vmap,
>                 vma_set_range(new_vma, addr, addr + len, pgoff);
>                 if (vma_dup_policy(vma, new_vma))
>                         goto out_free_vma;
> -               if (anon_vma_clone(new_vma, vma))
> +               if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
>                         goto out_free_mempol;
>                 if (new_vma->vm_file)
>                         get_file(new_vma->vm_file);
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 93e5792306d9..7fa56dcc53a6 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -600,6 +600,14 @@ struct mmap_action {
>         bool hide_from_rmap_until_complete :1;
>  };
>
> +/* Operations which modify VMAs. */
> +enum vma_operation {
> +       VMA_OP_SPLIT,
> +       VMA_OP_MERGE_UNFAULTED,
> +       VMA_OP_REMAP,
> +       VMA_OP_FORK,
> +};
> +
>  /*
>   * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
>   * manipulate mutable fields which will cause those fields to be updated=
 in the
> @@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_str=
uct *src, struct vm_area_stru
>         return 0;
>  }
>
> -static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_a=
rea_struct *src)
> +static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_a=
rea_struct *src,
> +                                enum vma_operation operation)
>  {
>         /* For testing purposes. We indicate that an anon_vma has been cl=
oned. */
>         if (src->anon_vma !=3D NULL) {
> --
> 2.52.0
>

