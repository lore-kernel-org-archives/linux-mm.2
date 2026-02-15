Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADBF6EF586D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 10:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 196676B0088; Sun, 15 Feb 2026 05:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143EF6B008A; Sun, 15 Feb 2026 05:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045DC6B0092; Sun, 15 Feb 2026 05:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74F86B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 05:41:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB41F1A0ABF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:41:45 +0000 (UTC)
X-FDA: 84446350170.10.61166DA
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id C218640003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:41:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnDMIUTZ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771152103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5zqlxMymh8HnDUTEtkdbnJNo81mlSIT2LT41r34kR0=;
	b=hV2zyTEAPKLOtWlsxHhnj002XwxC4iIoQAGsScEEH/tifU7YXK4jtFjopXqIIL+ST9R0Nk
	J0YNfS9uDvFwOiOSIzg5ZzG4K9+kwoXqlWWxEzC6484gfjKUIXMpv1oOLI1AnTCuNv1YbL
	ii1uxYYbe+YgW4y8sbOHIA54zUzs80w=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnDMIUTZ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771152103; a=rsa-sha256;
	cv=pass;
	b=n3NI1bxct4fDqWWmvEMQn/ULgA9kpzcpPVyLqVaO0M8o1BtCHihz+PnIl/V8wx4qmgpR68
	2EAo8eF/b5Jkf3kW4knl7hVab3NgtTfa0sBLivTiGke/xAPl6W8IvitKPHNgPRmBzdUh9Z
	maSS7t3kE2Ez5z68ju7obyuzCoVomDQ=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b88593aa4dcso235062166b.3
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 02:41:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771152102; cv=none;
        d=google.com; s=arc-20240605;
        b=cv8DElX5rw3Ii6K+uavX/fI/AosNmujusXc7RvMkymgiE4/OmBdQluGsPUEAekn/UD
         LoG12yDkrGDoJkRaoitABTgqMPy2dJzhIIi8mFsEP5wN9D330FI3ymD0KrJMW5kRRv06
         hpEu3uen9ZJOuvt6uI+rk6YvGGmgPlwcfj0ukmXjqe8xumNVIB8NQgAGAvIY9XOE5XKL
         dnazfg9XPiW+QWs7VOBu2/86R4O5V2eXgizP8ig1xyFrGVyZ0tAiLRFA0Ote7VE7w0Re
         NiwmN0mFsJI+dMluV7qFYasA0YIjwq7ADxaPJIqvqf5pmj5xBkPsgeoTq6V3M+1HOhh4
         7FXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m5zqlxMymh8HnDUTEtkdbnJNo81mlSIT2LT41r34kR0=;
        fh=oVIQGIsPvQkzGnuKj8NF+tIbeBHcwQRgyjYfsSE8chc=;
        b=GTAiQZqw7iYB2/xSB4tGxgM1/bUnDYKI9DYhoGq4ojYXTFexPBlzDfRye/ZGdUjjWu
         Gc96T1UgezFig4NxYujzX6XM5xFLP1fDdSQfhpAtKAiseqxoTjcgxz2NepIzgEblDGPl
         5XB69RNrfztwVlXCvTnV7V9gamAOygqoy5QKd3DoVFCNk7d7ByZyS6ExEjPK59Xa/faj
         8BVUEwuOEaAP65r4fiVgTA101eIdFahqk8742/nR8x/4oxKY9lQObDZN5zMw/fpnOG2o
         WJFo+B3dPNI/+n9+Qa4qF4gkxK/wk3BLRVUBziN9wUTpw0UANInufN+nMqLQqpPpP+Np
         eCXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771152102; x=1771756902; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5zqlxMymh8HnDUTEtkdbnJNo81mlSIT2LT41r34kR0=;
        b=LnDMIUTZ57cQui6W6vhKGlgGhe0BT4v1IJOODlVDI4/fZxEJ8THNk6st3pA1RYD+g0
         FgjjtLcVYvaDtOt3l+M22rIsYpv6ThmclOazCgo6E3muALUjb2cxFif7fjaoOfxa3LKF
         R71e8KKN2UB7Aq51kH4PhdiTBQ9goyw5m+z1LRCQHWt3NfNEDOBWn6PO6tjQzTbGwehP
         OfUmQDU+g/CSFPK2/f78xnx049CZmHUV8ROiEXMzZw95Gm0Ihss04Vf0cTWmHHd87TWr
         dB/uh/QnXzga1TtjMm91WFPBqiZtxYssYSXPnexSNRDDrML1Q+F5ZXE97ofQ4gind4HH
         mNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771152102; x=1771756902;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m5zqlxMymh8HnDUTEtkdbnJNo81mlSIT2LT41r34kR0=;
        b=TJ1psSr71pJuRDdabznd6nONjuzUlrrC0Zeqt7CnymqlNR5VzlfBsHiijUbnSTAIqT
         //+n2LtsJc2iEoejg8Bw5NirrOtV1JkquIeHcZxHvhF1WUxQqTgqNG+EJjOpY8JAg/KX
         lrAQCqxfv7YdElMG9UVcsSuwN+sRUGo1I0sgLxXBVHRwnUY3GPOxcT2c13RCjyXoDIWa
         UhqMQzN2iKo5s4rNToQ71uyELxNcjH2wQcnuoGZL+vtfs/082q3oMs/ErJ8k+7MP0GVK
         CI9fDZiNvLsK5zf9AnTRTQFP5tiyQmxvdrMot/0Ug2x5cwxXN6pSzkOe7bvwysiS5xRQ
         9Fnw==
X-Gm-Message-State: AOJu0YypbFukSPsJKF0zKWPx0/HsA3AHqZdUPIOKWFSL+tI6hdXzxnzf
	pTtjtCy87z4vLbT3Raup+SIVRm5jiKPYX68Mt8bCPabHD3zHBhitgONUJ5O/VjdEkH3ViBgsV72
	eGzSuZoGwijDbOegyhFH0cEhujwilryagVLXniqs=
X-Gm-Gg: AZuq6aLQf0+T9066f3cIxEjgIgsgsYZl7YxlGV1LxsCppnUR17O0nrzC2Z5aq3N+AUf
	NCB5tlocO+g1s8v0vv/cEt/R8zKia6+gC4HRI9fkcY3+6UuPIQUD4uQMdCImuOJ5F7QvueGq0TO
	dsay4DSPh90U/V6atplJV1MxLXRDTsTAZ0ySnvxGulODgPO+ws4SPOIC+SKEtGQ65woR8NPo2c3
	0MwhJSNbHt8zOBwcmmcljs/W0bUEdACEyFS+u12xFsJScoFK4gx0BckLc/qHWZc/WR/ICmAczYX
	Td0MUSCi9dN6UOfrzr0Tn8z7fIc59jSWRjgv6Kw6HlCrlKaSJIU=
X-Received: by 2002:a17:907:94cb:b0:b87:d255:39ff with SMTP id
 a640c23a62f3a-b8fb449d45emr386598666b.32.1771152101668; Sun, 15 Feb 2026
 02:41:41 -0800 (PST)
MIME-Version: 1.0
References: <20260215-hibernate-perf-v1-0-f55ee9ee67db@tencent.com> <20260215103815.87329-1-ryncsn@gmail.com>
In-Reply-To: <20260215103815.87329-1-ryncsn@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Feb 2026 18:41:05 +0800
X-Gm-Features: AaiRm52TPspBi1E7osxd9j9xFU8IPghna5b4nNAZMVt5OuxIX90GIJkGtnMKEhg
Message-ID: <CAMgjq7C2K5mAVcieX5rUUk9Qu3o7OgHkFqBU86AsvxNQG0uoUw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm, swap: simplify checking if a folio is swapped
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C218640003
X-Stat-Signature: ushmrqa37gomuzaj1swb4ft1zaikgack
X-Rspam-User: 
X-HE-Tag: 1771152103-837447
X-HE-Meta: U2FsdGVkX19a5yrVWmbCx3hzoC09H87CblJ+MRkpTLsgmdYZjux39YzgdxmglE4LlQJ/dcHQfTznXoaySF3xnduzCZjJSv8ZwoMO8Y49+sN16IvCBu8h/wd+HmuRmBvC/ceY6X4GPwUB0Eurq61ov3Iea+Z/M6iGms5fKCQ6XTDAV6i6VqPGmlX8CmLENzzIqqNwo8PnUBH8/ettjp6FIGMJaIppq2qQ4+YVNSOlGyfPoiKD6q29g+ofwMfXwwOS+8ObUEid6FEKPvF4ZKjfssmqnplx8T/QLh9DtOaeTUqgNVOCmqQ/svw96MBYjw3jB+sw6ORGmYM0YRlXJZQG+KdOMCnQNH9klgAFVGEH9pm8q1nlE0bKjTcvb83072YoE4hL+TBsq8d1FpgR82eye116kkByqsuFsfbPJn+8RErAMPFKO6JbLFJjp6t4cWK5zgxqh1briZU+ztl8aLFb0uZuPw9jflIRdlXIvHwvUtbFGQzvDTJVZ/X1E+jad0wgXvI/xTDQQf0TL40XmRrFsrtrJ6FP6mig75VLtP986t3DoN0ehGoFbroPtYiBtjAxl13JKsA/8O6K7NLXthW3S0g/Fkz8OrSRR/9KDuBkXKCixgLD6GzCOTg45tA8uvlXpoQCG1DuBYmp26ptpMz/FaxS9Vpn6E63GHmforVjBfrTJM5ntZuItn7eEGESvmnwNbx/QmudfHweIgPzCXls4JLi44E/WPG3tGLfLS3Oezvm5EeLjQb9B5CpebP+p9xXk+ON4SCA9hpduqcn6SjFqL454OYwfMy+yKy/r28a/TKS6FtU9qMeX82GPckFy+ICitk31xB6HnVAtO7TykLvzjyGZJ2GvFQOudw0aAal1SmdBPcaijY2Il4sFRaGG7yEwdQ2QutJ3sMege5qS9P1RFCgMZoTPjfSBZ5qyem5KyJcK2gMTeF9vKKleuWMJHhMVKbKAbef9dp1VI7skIw
 /RA1rnYZ
 2iG7kk1xYxZSr50Q6RpbFrKBbgCo7wiGX6qRJK7Ao/HkhLATLHp0ncW3v+Cz8A1dFdE0IZWJdWE3g7yFQlorN+hAOBCD1tit+URckRfRnWxVlcMRThfuOE0MDQWQmAPFcvuucDGznSqZgZgwLuzHeyrFdwp4oi851d8XqPEQPcxFqGDlK1Rm+cRuDtFuaPB0vEIZ0i3vHs8p7ba63u5mYS2moJFdq/F/tz3jdlCjMAbQzHlWMnSDcXEWWqtlC2eNsxd2HKKhfDyu71ZWvm7+z+cv1tGIhyndObdPSgcz7pjZfzqJ3U5Qh0PGXUSNoIufcY/iOAZLYs8lDNczxH0yXVFl9GpAmLGpAk+NZxmDT1FKdMtwVQZraRFN2PPv/0M5YOLen7HbIsPDhPG3bwspfpmRjDp0To2/evFsBawDPBHNAI7AaJ+8LI7DI0Wt3NwDZlACk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 6:38=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Clean up and simplify how we check if a folio is swapped. The helper
> already requires the folio to be in swap cache and locked. That's enough
> to pin the swap cluster from being freed, so there is no need to lock
> anything else to avoid UAF.
>
> And besides, we have cleaned up and defined the swap operation to be
> mostly folio based, and now the only place a folio will have any of its
> swap slots' count increased from 0 to 1 is folio_dup_swap, which also
> requires the folio lock. So as we are holding the folio lock here, a
> folio can't change its swap status from not swapped (all swap slots have
> a count of 0) to swapped (any slot has a swap count larger than 0).
>
> So there won't be any false negatives of this helper if we simply depend
> on the folio lock to stabilize the cluster.
>
> We are only using this helper to determine if we can and should release
> the swap cache. So false positives are completely harmless, and also
> already exist before. Depending on the timing, previously, it's also
> possible that a racing thread releases the swap count right after
> releasing the ci lock and before this helper returns. In any case, the
> worst that could happen is we leave a clean swap cache. It will still be
> reclaimed when under pressure just fine.
>
> So, in conclusion, we can simplify and make the check much simpler and
> lockless. Also, rename it to folio_maybe_swapped to reflect the design.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h     |  5 ++--
>  mm/swapfile.c | 82 ++++++++++++++++++++++++++++-----------------------
>  2 files changed, 48 insertions(+), 39 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 9fc5fecdcfdf..3ee761ee8348 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -195,12 +195,13 @@ extern int swap_retry_table_alloc(swp_entry_t entry=
, gfp_t gfp);
>   *
>   * folio_alloc_swap(): the entry point for a folio to be swapped
>   * out. It allocates swap slots and pins the slots with swap cache.
> - * The slots start with a swap count of zero.
> + * The slots start with a swap count of zero. The slots are pinned
> + * by swap cache reference which doesn't contribute to swap count.
>   *
>   * folio_dup_swap(): increases the swap count of a folio, usually
>   * during it gets unmapped and a swap entry is installed to replace
>   * it (e.g., swap entry in page table). A swap slot with swap
> - * count =3D=3D 0 should only be increasd by this helper.
> + * count =3D=3D 0 can only be increased by this helper.
>   *
>   * folio_put_swap(): does the opposite thing of folio_dup_swap().
>   */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9628015fd8cf..cb18960a6089 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1743,7 +1743,11 @@ int folio_alloc_swap(struct folio *folio)
>   * @subpage: if not NULL, only increase the swap count of this subpage.
>   *
>   * Typically called when the folio is unmapped and have its swap entry t=
o
> - * take its palce.
> + * take its place: Swap entries allocated to a folio has count =3D=3D 0 =
and pinned
> + * by swap cache. The swap cache pin doesn't increase the swap count. Th=
is
> + * helper sets the initial count =3D=3D 1 and increases the count as the=
 folio is
> + * unmapped and swap entries referencing the slots are generated to repl=
ace
> + * the folio.
>   *
>   * Context: Caller must ensure the folio is locked and in the swap cache=
.
>   * NOTE: The caller also has to ensure there is no raced call to
> @@ -1944,49 +1948,44 @@ int swp_swapcount(swp_entry_t entry)
>         return count < 0 ? 0 : count;
>  }
>
> -static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
> -                                        swp_entry_t entry, int order)
> +/*
> + * folio_maybe_swapped - Test if a folio covers any swap slot with count=
 > 0.
> + *
> + * Check if a folio is swapped. Holding the folio lock ensures the folio=
 won't
> + * go from not-swapped to swapped because the initial swap count increme=
nt can
> + * only be done by folio_dup_swap, which also locks the folio. But a con=
current
> + * decrease of swap count is possible through swap_put_entries_direct, s=
o this
> + * may return a false positive.
> + *
> + * Context: Caller must ensure the folio is locked and in the swap cache=
.
> + */
> +static bool folio_maybe_swapped(struct folio *folio)
>  {
> +       swp_entry_t entry =3D folio->swap;
>         struct swap_cluster_info *ci;
> -       unsigned int nr_pages =3D 1 << order;
> -       unsigned long roffset =3D swp_offset(entry);
> -       unsigned long offset =3D round_down(roffset, nr_pages);
> -       unsigned int ci_off;
> -       int i;
> +       unsigned int ci_off, ci_end;
>         bool ret =3D false;
>
> -       ci =3D swap_cluster_lock(si, offset);
> -       if (nr_pages =3D=3D 1) {
> -               ci_off =3D roffset % SWAPFILE_CLUSTER;
> -               if (swp_tb_get_count(__swap_table_get(ci, ci_off)))
> -                       ret =3D true;
> -               goto unlock_out;
> -       }
> -       for (i =3D 0; i < nr_pages; i++) {
> -               ci_off =3D (offset + i) % SWAPFILE_CLUSTER;
> -               if (swp_tb_get_count(__swap_table_get(ci, ci_off))) {
> -                       ret =3D true;
> -                       break;
> -               }
> -       }
> -unlock_out:
> -       swap_cluster_unlock(ci);
> -       return ret;
> -}
> -
> -static bool folio_swapped(struct folio *folio)
> -{
> -       swp_entry_t entry =3D folio->swap;
> -       struct swap_info_struct *si;
> -
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
>
> -       si =3D __swap_entry_to_info(entry);
> -       if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(foli=
o)))
> -               return swap_entry_swapped(si, entry);
> +       ci =3D __swap_entry_to_cluster(entry);
> +       ci_off =3D swp_cluster_offset(entry);
> +       ci_end =3D ci_off + folio_nr_pages(folio);
> +       /*
> +        * Extra locking not needed, folio lock ensures its swap entries
> +        * won't be released, the backing data won't be gone either.
> +        */
> +       rcu_read_lock();
> +       do {
> +               if (__swp_tb_get_count(__swap_table_get(ci, ci_off))) {
> +                       ret =3D true;
> +                       break;
> +               }
> +       } while (++ci_off < ci_end);
> +       rcu_read_unlock();
>
> -       return swap_page_trans_huge_swapped(si, entry, folio_order(folio)=
);
> +       return ret;
>  }
>
>  static bool folio_swapcache_freeable(struct folio *folio)
> @@ -2032,7 +2031,7 @@ bool folio_free_swap(struct folio *folio)
>  {
>         if (!folio_swapcache_freeable(folio))
>                 return false;
> -       if (folio_swapped(folio))
> +       if (folio_maybe_swapped(folio))
>                 return false;
>
>         swap_cache_del_folio(folio);
> @@ -3710,6 +3709,8 @@ void si_swapinfo(struct sysinfo *val)
>   *
>   * Context: Caller must ensure there is no race condition on the referen=
ce
>   * owner. e.g., locking the PTL of a PTE containing the entry being incr=
eased.
> + * Also the swap entry must have a count >=3D 1. Otherwise folio_dup_swa=
p should
> + * be used.
>   */
>  int swap_dup_entry_direct(swp_entry_t entry)
>  {
> @@ -3721,6 +3722,13 @@ int swap_dup_entry_direct(swp_entry_t entry)
>                 return -EINVAL;
>         }
>
> +       /*
> +        * The caller must be increasing the swap count from a direct
> +        * reference of the swap slot (e.g. a swap entry in page table).
> +        * So the swap count must be >=3D 1.
> +        */
> +       VM_WARN_ON_ONCE(!swap_entry_swapped(si, entry));
> +
>         return swap_dup_entries_cluster(si, swp_offset(entry), 1);
>  }
>
> --
> 2.52.0
>

Very sorry about this :/, something is wrong with my local branch
so this is the wrong patch.

Please ignore this series, thanks!

