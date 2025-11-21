Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34DF7CFA459
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 00:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303436B0012; Thu, 20 Nov 2025 19:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAA46B0022; Thu, 20 Nov 2025 19:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F54D6B0023; Thu, 20 Nov 2025 19:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E67E6B0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:55:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A110B619B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:55:37 +0000 (UTC)
X-FDA: 84132796314.12.CB60AF3
Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95DD714000A
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:55:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNqLvNTo;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763686535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHLZzYBe5PNBBbWSU2flf4rsSrKORyD+grDX0snbHt0=;
	b=8C4+wAo0VqXjf2ZrYbjr+Hz91IJk6uRMbMlq7S3WZk1Fv+voaXE7t/S9uaxlBC8CaaRJRL
	yT6HtKgYwVjtNiAv1JPd6af0IIjZ4OpCqRwp/cHwBW9koSN5dMgn3qE+ucuZw8N0drBaYz
	R0+DhVtryojCU9dxeczvPWfq9NiOsv8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNqLvNTo;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763686535; a=rsa-sha256;
	cv=none;
	b=4BYiA41Fe7AQfXsJVbP0QzX1hVTIpz2fz3D9TWGOVfyhDyaOTzeQkiLhNB5zAQhPw+K79j
	3Uyol5vo3GdVl/WfUPY5DZvTNl9o262ngNmY4yqbbQTDx1Rd++nGsWhQ5mp6gWBxs8Bcbh
	Ou9oEiU6GLv1yLqt+Qcs7fC3YSaFrw8=
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-937262a397eso457140241.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763686535; x=1764291335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHLZzYBe5PNBBbWSU2flf4rsSrKORyD+grDX0snbHt0=;
        b=dNqLvNTo1J9E9hqWpemMxOJNwAD+zd44iyq5XDnX48zQe3wim7ETTyD9B6wZGCvQOR
         ARwrjXDDL9ckivAh2cNO/deU86c+K0y4h2W84J9oKJZ9DxVgJqS1Zvbyj+4ZYmziWm4k
         50O7HQrwReRWwMy7rwNeVrxycEnk+k9Ztj+wS98TiD6jePRUJnLbqfhixrKtcSCbEF/R
         OUWKdEmRWhDfLfZula0afgrM6/yBHkpKoAV20W8i2wdgAgWwTBO0HjcD0X0IErrIaLY/
         t8VI1M5FMcnDtebc3Iyjm53AOmd2DNdppoH+Wb8o8MlMs3beiEn2SHzfzboS8Dj7hC0L
         HQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763686535; x=1764291335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kHLZzYBe5PNBBbWSU2flf4rsSrKORyD+grDX0snbHt0=;
        b=Ff+CE6z4nkC2/iK6PaeOako8YslysqLylQt9peKkYOw6fT2dLZlC1La6XTSYrNRZXw
         3Qmkrb34TPwHwvkqig1nHY28itHCsjUje7bQ4jH0i3XXeHQgaj4fFHZ/czkEyOhGkiBm
         vkjw9Obpp0GrOtA/N9lBUu9xVVGdhuo+L+QV5kpkHcx4g7xPmKya3AYeA9oEloZhbSFH
         upU0ipgsUUoSxIlN2WpUt5shACY32Vxb9gMXaxeAUTJtkKjlmjaGbroqUwME3er1Yn0D
         eyUeC3SfzLAnbmaJqpfcU0SKi4KpEVAD0p6GL5YGFvvpV6vJDXlw11oCzWtENG6E8ZRm
         tTcg==
X-Gm-Message-State: AOJu0Yyr6hRnk+mSoDxdesBTp85HmsLUTGt3CVPmzX0sBSY/qcwpLUPS
	jyS3Ai5XnYWl3ZwrbJx9cZmkwufqvmbbu1Rhll64mcbDqokuJWIWPWkb/L6a99+rRyXXWVdqaSA
	eMc3dF10VH+/H0T5F8k7lDLvUeBL69gc=
X-Gm-Gg: ASbGncvLXZSVGXU2WWTKLggGdOe7yGFODbioK65or59sObFrxjyC1/gl6gY0mO4zuEj
	eqv/EiXZkLsv0XD+oRdcjb2NePjm9X+kG6uuoSrxyVfO5n3r9QKvGufnO55CXGHNsEvVBH6zy5n
	gy2qHHfVWsgbBl9zjiVsARgurQ4NjBvmY5PZIenDWqPD9VItstTpnwAYhx7XKf3nm8uNDfTRKQq
	I47E1njgc+1W2B+o1R375VR0mFHCfIoRlr6W5OAq6mPawgZ+HxBvaOvPGVERZKMlaHmUJ+3O3Mb
	CKGg
X-Google-Smtp-Source: AGHT+IHAaoEGZl6XRkd05ASzkTbefE+DNwCwl8/N/u7JtBpbbOs55W62/i12o3MXPTSFTfSA7kO7nFqg7LaE7pGAHAk=
X-Received: by 2002:a05:6102:9d9:b0:5df:c1f6:be44 with SMTP id
 ada2fe7eead31-5e1de18ef7fmr138107137.5.1763686534418; Thu, 20 Nov 2025
 16:55:34 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com> <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-3-37730e6ea6d5@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 21 Nov 2025 08:55:23 +0800
X-Gm-Features: AWmQ_bmbTGjlpcWP0xeiWj_dQjA5xaDW3CLNs0xGRE9GZVk-8bBV_xkAEmiUC8g
Message-ID: <CAGsJ_4zSqQax-Ct-zz3uMZ_dD7vnvTjWZ_BsnXBnMVpVNNDYUA@mail.gmail.com>
Subject: Re: [PATCH v2 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95DD714000A
X-Stat-Signature: imuf5bc7kjgxcpexze6ygxjgywcibiao
X-Rspam-User: 
X-HE-Tag: 1763686535-780641
X-HE-Meta: U2FsdGVkX1/5awipBbtUyDdKo1pYrBxykV9YGb2Jti97mX1y5NjAJ4bglga9bRyp+SDV+fmPRnQgA9oHRVYbUaSVq/U9ARfHZtt6PfE9/I12+h4yZ9YOX1pjckemUqwpwUZKhqmCJUhchm6D41jaoBx0BofOXlaZ3cKeSQMGpbuq6IA7z1wXa2EB6itS8co7u/8lgaQPXEwUlEsTzfn4w2KrCOMPe+S0wZcDuA11mmfAusKy3dLyFa6qPhBZNK1+sBLBI5sSGo46Dj/1yaaui/IrWRvqiAcN1nPMpv7jcrZHsQosNx6vqpUHZ4/siPq75EuvKVLh4HPeRx35icC0X1PneZE+l0bd0G+V/yuGhJj9BRU0gjnzrS5YZ3eo0b5f5Uymd9Pka6EV0reTPKu0h96K9wpxcecgS68bIeJx51t8SvW8EVvadwJGVHeT0RbfXZDZtWWcFRuH51GVoYJsUFwgCCKf7iKTREMg3RUf8s4Mnp1UFi9S3Kduu7gfieLRBvW24O4OzzfcxXIKi/eoCoR3EyXbXLjRiTfoXVv5ng+OR1/PTZ4ti3v8zraCagjJruFh5kXzaVLImYbpwCEM+LFFgqWuxjhiUlHVhCeATkcRCkTRuRB2FetMepEH96GyaEZwbETaBm7y1ruU4Qo0Yk8S7q7acEf9cT/TshRukoksGvpNW0Haicfg/jsR3qFovszFFnvjHeyOTVK8EZoGfBW1rbkT8a2ppPwyRvxV99vtUNlSQZcM8yprKPRTn4K1ZkXvvfhh7L+7rfAAxZLHCVSGGkVZZ7CbHrXjSMEAs7C230JY6cisaDzzKgJ4rOdnWDVqaAJTxMcaMu4KTa24GRVzaXnn9P4qq3JHLGvHEF1tvoUNB5cjBBTABV2fzOgQT9YGqrf2+VkyvY0Wg1TlXsQ9vaJwUc+iVF2sJYVuAGzx9H04iuSJXpjYUz9nkXz8PP81z9vve28YQvk+VNj
 8MnbEQPc
 HcG9LzeVWMEvHEiH8tGm2FDWowKueXnCm4v92SIHQePFM+HnyYZUgk0krVtz32aGvDEVOMymIlgVn+clo8Y046WEarJIOqgfNEOoeMlTiOxAexJC3H/7vbgFCaj/ToU95U3zMVJEDeAqjm5OuYT/pSrtQZZ04Fx/raboy8zIQdJk/88DQmuLhhPgl35P+gTx2U05RkW2poV+jiuTMZDzD0Sj+LBPzXlEut9WfTEFni4KPlRH8ND44TuwWWMm/hlu33XM2eR5cQOcjAB/6E2sgm3kMaOHlSrOBBzDQXEiHIQRR1MSxw41VZso7mUhtXL+dE0E2b2c1b8Hr1LBa2ik4Cxm0fMxBTvCM5b+QffPtJnG6SlVXVX9/byqXSDMCkHKSvgQW+cWhrTU/7KcTfMBlIZfutQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

>
> +       /*
> +        * If a large folio already belongs to anon mapping, then we
> +        * can just go on and map it partially.

this is right.

> +        * If not, with the large swapin check above failing, the page ta=
ble
> +        * have changed, so sub pages might got charged to the wrong cgro=
up,
> +        * or even should be shmem. So we have to free it and fallback.
> +        * Nothing should have touched it, both anon and shmem checks if =
a
> +        * large folio is fully appliable before use.

I'm curious about one case:

- Process 1: nr_pages are in swap.
- Process 2: "nr_pages - m" pages are in swap (with m slots already
  unmapped).

Sequence:

1. Process 1 swap-ins the page, allocates it, and adds it to the
   swapcache =E2=80=94 but the rmap hasn=E2=80=99t been added yet.
2. Process 2 swap-ins the same folio and finds it in the swapcache, but
   it=E2=80=99s not associated with anon_mapping yet.

What will process 2 do in this situation? Does it go to out_nomap? If so,
what happens on the second swapin attempt? Will it keep retrying
indefinitely until Process 1 completes the rmap installation?

> +        *
> +        * This will be removed once we unify folio allocation in the swa=
p cache
> +        * layer, where allocation of a folio stabilizes the swap entries=
.
> +        */
> +       if (!folio_test_anon(folio) && folio_test_large(folio) &&
> +           nr_pages !=3D folio_nr_pages(folio)) {
> +               if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> +                       swap_cache_del_folio(folio);
> +               goto out_nomap;
> +       }
> +
>         /*
>          * Check under PT lock (to protect against concurrent fork() shar=
ing
>          * the swap entry concurrently) for certainly exclusive pages.
>          */
>         if (!folio_test_ksm(folio)) {
> +               /*
> +                * The can_swapin_thp check above ensures all PTE have
> +                * same exclusivenss, only check one PTE is fine.

typos? exclusive=C2=ADness ? Checking just one PTE is fine ?

> +                */
>                 exclusive =3D pte_swp_exclusive(vmf->orig_pte);
> +               if (exclusive)
> +                       check_swap_exclusive(folio, entry, nr_pages);
>                 if (folio !=3D swapcache) {
>                         /*
>                          * We have a fresh page that is not exposed to th=
e
> @@ -4985,18 +4962,16 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         vmf->orig_pte =3D pte_advance_pfn(pte, page_idx);
>
>         /* ksm created a completely new copy */
> -       if (unlikely(folio !=3D swapcache && swapcache)) {
> +       if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
>         } else if (!folio_test_anon(folio)) {
>                 /*
> -                * We currently only expect small !anon folios which are =
either
> -                * fully exclusive or fully shared, or new allocated larg=
e
> -                * folios which are fully exclusive. If we ever get large
> -                * folios within swapcache here, we have to be careful.
> +                * We currently only expect !anon folios that are fully
> +                * mappable. See the comment after can_swapin_thp above.
>                  */
> -               VM_WARN_ON_ONCE(folio_test_large(folio) && folio_test_swa=
pcache(folio));
> -               VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +               VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
> +               VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);

We have this guard to ensure that a large folio is always added to the
rmap in one shot, since we only support partial rmap addition for folios
that have already been mapped before.

It now seems you rely on repeated page faults to ensure the partially
mapped process runs after the fully mapped one, which doesn=E2=80=99t look =
ideal
to me as it may cause priority inversion.

Thanks
Barry

