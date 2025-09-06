Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1192CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 15:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10EA78E0002; Sat,  6 Sep 2025 11:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6948E0001; Sat,  6 Sep 2025 11:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16FC8E0002; Sat,  6 Sep 2025 11:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF51D8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:35:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85F9B1A054E
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:35:47 +0000 (UTC)
X-FDA: 83859225534.16.E100632
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B608740002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:35:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzPvyuK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757172945; a=rsa-sha256;
	cv=none;
	b=GL4Rr6PkRrocSuYCbZeKLHYFUzcSeXuOTQVQ39l3vQ364GWLGVMeoY3ZqTzribJ/8/BcQ1
	Z21mb0SZnJHKtkjCOchi5YMRSMq68UJG+C6zcW/7yewpbq0Ey10V8d6JhLXUdUwDGqHVYf
	OhJ9UFOwb8B/YxptGdW2Q0iX5Hqtxjc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WzPvyuK1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757172945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3EJq6MnBxJ0NDViIpXO7a4sZwMdsj5O1xjq0wEBle4=;
	b=4yWYLHvF4qSEXHuW5AUjHo9agFA57IVqLJBbm/SiLUSMl52EhScKF/xtcI+reoNbvKtMqY
	965f1KgEa7MvkDuOQBKxgMLCvQZS7G9Fxc0K9UfOlrfw2Fz0RfkhLiOwCtK8laszZcu/Fw
	SHktX3UVYo8bQ9rmna2ZAy0SuqpdkmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 138F360322
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66B9C4CEE7
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 15:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757172944;
	bh=GBGyGZ83IzgHSiMHPRhSPDRnDEIaxEHa54IZeElVbxw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WzPvyuK1fvu1OEkpppnrhXOtxkvEe5b6W+5YAJrXHpaOHZVGEcgSxgLo+n3DYqy5u
	 FTfIxs+58/27e8jsMqeiYWAi+0eqTive1X535G50Ox0awHQLPjt0SRpgiksAlK+0Yr
	 WWFvtkTTkXje0YEKkPXVXAR0JkyZGwpzfEmhOhcgZqc7doOvPFaiF357c+4ApgZMOV
	 jAdwYCHslgAjviFZPpWx3rjjFpTpeuBkWMzXn5Pb5k9lvzTcgcRNpsL5tJJJcS6+p7
	 ZvwR4r0ZpW2m7atXA9kC1IP3w6WrLEU/iUPkCH1vKLCBb32kbMPapdBnacGeYqvtYC
	 ebmMxI1Hka72Q==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45de2856648so2335e9.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 08:35:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YzXdD4Y4w3V1g79Ljx9cPJf/snFr6A4P7UxXFNHi9KRrycQlJYX
	OjLJ8uiXTZAs1heY1Mruq3fHqLxjWIhKMAW4uOT7K1KgKlHoDK0K0Vn+++rHRepsCxwCiIjGDCa
	Q4oH8T3xBudiGh5YVoOwTQrJBhKqhv4kStIDud0vC
X-Google-Smtp-Source: AGHT+IFGBgIATgkVR2bj8AG1tHGEdgxOuaKhDRAoAnJP89DZx+8H7BkDADRRZMhx6H30ttjtzwBupCLEPUlPDvohzNc=
X-Received: by 2002:a05:600c:3ba3:b0:45d:cfca:a92d with SMTP id
 5b1f17b1804b1-45ddda4e7e5mr1104625e9.2.1757172942634; Sat, 06 Sep 2025
 08:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-13-ryncsn@gmail.com>
In-Reply-To: <20250905191357.78298-13-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 6 Sep 2025 08:35:31 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPLVp6s0iYm24tLf-h+sTmD2m-NOcw6xMPcL4HtoDnxxw@mail.gmail.com>
X-Gm-Features: AS18NWATS45oj3V_s48PvNhNF43MTf4ynWGLQEQ_CC_ieg7uOOQRpzNNblI4-BI
Message-ID: <CAF8kJuPLVp6s0iYm24tLf-h+sTmD2m-NOcw6xMPcL4HtoDnxxw@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] mm, swap: mark swap address space ro and add
 context debug check
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
X-Rspamd-Queue-Id: B608740002
X-Stat-Signature: nsg9pghh9udcscn3w6zjpj41smtua7za
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757172945-877663
X-HE-Meta: U2FsdGVkX1/xIJFKwpRsQ09pDXz09TMjzsKai/een7F2k5iFEs8pqdnHMJoJy94UqZNInj4uV8LWhZFwOzF4r9A3oE2hsGRLmXz9GL+8x9FLQNnHvbJed7faRixXNoCCjIXK0VquyWzi3hcO4yUs3dwFn1H2MhriINaZR32PF997OIvKRUkHh5qcRc11RDTGt5mD2KS31++0qPtH5vibIBHgVr4PQZPRqyxMpHIA19IItscUcWEjwmC81T5PXaG6igazpuhfznaRph0S6JUT+6dVXNvy0jAZfl+D41G3/EMATotgt0wQ2IzfDJ4MahebFnYb1uQ1flBVrF5LO0ACjwKidThe8+ultSL32rkobHjRJOBtMPP/2PkVnrXjJFaQ1M5YOfytDTtIt+Zmd0moRIi7ZRaGAtimGvJMvOUgtGHR1UTEbmhjyb4j/5hSw+Isn4fgXEERfxYRpgr2eKDbEB0YkF/efoCbcKpFwU9eVw8fuo/3smozrKnrhTF9AYoar1hlWuoNy6lhKBiqxEZ+PbWg9cAXvQqbO/GyLlPI6Meer0gNYwFLA/8trf5jWCNrb77Hh0CYC8GV/zjD1E1rrrW1wNcrdgORCP5oHELWZU4BMLW0B2mUZvO7fO5uPIljkwv7gxCv3J671K/mxrAHzEDvkbtK7cKBvueVE2XT46geUa+XarjCpN/Vw4mzJ0E7pZD6ktoEVNixpkXl/exDqY7eoeVVFtUvtc9jL3e/5qNqJGOytJJ/PA80981/9cFhItFNSxUVTRdfjF31SkvDd4bP0lKb5h7tyaxgqd+BPDE2TrtDue4hRjyLZm/i+Y+kfvCgpzmsGnBrM3/onRCirxZ/YmPcvFl8GrysPB4/wqXGjTygUEK58cgPSkWUjGxyEy7YC89CFxO0k6HIR+AOh4fuy3ymMp9B93BCRPFyxlcTqXqrpbOXzGoLK1zdfrpoLiTDgjMAB9NUwjgD2m/
 veUKAnVU
 onZa0iE4+OcO5MkqmVT1jv/4YYIzBW9ZIHf7E3AkVVOzFqCBCWEB4k4HE1JIkOGuyqaJ9CKHDGGSWGwi+6we3tPkZHjdfDqYYmqT2ba2TgUQlpPbaarFEGJ7AZqCPHOwzGOU6Nb9miM95zY0nAhZOGV2Zl/U1ucXZB0BwSfPk6lmReUgX9BeYEJRWAFjKUuk31NJw+CqhHIIDsIJkmFSzL/5Y2KuIged1jAPoBNzbak1mKHJjAWegIxPw07M61BsGEBa7TgaX3N4fdMq9CS5wncafV7ZtDh089tZ7Vv5MnGXf/T0+EVixH779a1euKGeMwC2TkPHRReDRr3OrTruBZapaq4OowCXOjQyF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think adding one more check is fine.

I don't think there are exceptions but I am not 100% sure either. If
there are any violations we can catch it now that is a good thing.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

On Fri, Sep 5, 2025 at 12:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Swap cache is now backed by swap table, and the address space is not
> holding any mutable data anymore. And swap cache is now protected by
> the swap cluster lock, instead of the XArray lock. All access to swap
> cache are wrapped by swap cache helpers. Locking is mostly handled
> internally by swap cache helpers, only a few __swap_cache_* helpers
> require the caller to lock the cluster by themselves.
>
> Worth noting that, unlike XArray, the cluster lock is not IRQ safe.
> The swap cache was very different compared to filemap, and now it's
> completely separated from filemap. Nothing wants to mark or change
> anything or do a writeback callback in IRQ.
>
> So explicitly document this and add a debug check to avoid further
> potential misuse. And mark the swap cache space as read-only to avoid
> any user wrongly mixing unexpected filemap helpers with swap cache.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swap.h       | 12 +++++++++++-
>  mm/swap_state.c |  3 ++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index bf4e54f1f6b6..e48431a26f89 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -99,6 +99,16 @@ static __always_inline struct swap_cluster_info *__swa=
p_cluster_lock(
>  {
>         struct swap_cluster_info *ci =3D __swap_offset_to_cluster(si, off=
set);
>
> +       /*
> +        * Nothing modifies swap cache in an IRQ context. All access to
> +        * swap cache is wrapped by swap_cache_* helpers, and swap cache
> +        * writeback is handled outside of IRQs. Swapin or swapout never
> +        * occurs in IRQ, and neither does in-place split or replace.
> +        *
> +        * Besides, modifying swap cache requires synchronization with
> +        * swap_map, which was never IRQ safe.
> +        */
> +       VM_WARN_ON_ONCE(!in_task());
>         VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
>         if (irq)
>                 spin_lock_irq(&ci->lock);
> @@ -191,7 +201,7 @@ void __swap_writepage(struct folio *folio, struct swa=
p_iocb **swap_plug);
>  #define SWAP_ADDRESS_SPACE_SHIFT       14
>  #define SWAP_ADDRESS_SPACE_PAGES       (1 << SWAP_ADDRESS_SPACE_SHIFT)
>  #define SWAP_ADDRESS_SPACE_MASK                (SWAP_ADDRESS_SPACE_PAGES=
 - 1)
> -extern struct address_space swap_space;
> +extern struct address_space swap_space __ro_after_init;
>  static inline struct address_space *swap_address_space(swp_entry_t entry=
)
>  {
>         return &swap_space;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 7147b390745f..209d5e9e8d90 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -37,7 +37,8 @@ static const struct address_space_operations swap_aops =
=3D {
>  #endif
>  };
>
> -struct address_space swap_space __read_mostly =3D {
> +/* Set swap_space as read only as swap cache is handled by swap table */
> +struct address_space swap_space __ro_after_init =3D {
>         .a_ops =3D &swap_aops,
>  };
>
> --
> 2.51.0
>
>

