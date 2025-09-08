Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A661CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890518E000D; Mon,  8 Sep 2025 11:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819AD8E0001; Mon,  8 Sep 2025 11:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709398E000D; Mon,  8 Sep 2025 11:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2A28E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:39:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F12D113929A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:39:25 +0000 (UTC)
X-FDA: 83866492290.25.DACECD2
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1B4161C0013
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:39:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XT+R7YJO;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzjRY7OCEhANtHRWQB+PpwrfD3gB0K9s93cny8H02tg=;
	b=PlIlSQIaAgsPAe6wdBMvG2c93RlEke9j7V37Z6s+4E+jBEm8WSE/lfJo7viLX/fBaHb9zA
	1jSrybPOHTiQto4C70esBnz0Eibhtz/snqKWt0lyXyE+pb5/hOoVXaWEcNgglIGGENlkpL
	9fGFp/a7n6wcsDzj38Cbgnel9kyEfMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345964; a=rsa-sha256;
	cv=none;
	b=TzphP/KfFbLvrUvaOHUSy6Ue5rSbRi9wNxFMPD2VZ4xcDg4cjXt4EZJvJwotEfjG1+/6ZK
	sh2HurGV/k3vKVf7Svw/seesL2zkbIxrgSrGzZE9g6KwDm7oZl/Eq0UHgp/ghZUhzQCU5V
	Y9N2g2SlvduY2VeVInBbWxUkQPXcAPY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XT+R7YJO;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad681so6166834a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757345962; x=1757950762; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzjRY7OCEhANtHRWQB+PpwrfD3gB0K9s93cny8H02tg=;
        b=XT+R7YJOTZJa3xyUFRRMipYyxsN3P//t/X2DkH5hrUOQAdjgbMUIIjyt06u7ldV7jn
         uNHR5hh31StrgiKKyxo7TsYu87y35bojpPwyJUZmeeFkzJWlQ+/IYlDpoKMfK0mVB1ka
         DzmuimdZagyERP7RSuT5DhCeqoLZfogR87tgIrewBmRBFProLYIf4mmuZZh8dzdFZmzq
         6f/xK8F3XlM8iv6HCQ1TgcUB7iaVR4okdFNAnCjZkbgsjQLReZg3Iq2sYkwc7wCOUzD5
         M6V8B7jwVjwYRbuQgjE2siQyAGjpIao+26Z/p9dTPFV2fVLUigNNFH5Tg9mtzcyQFMqT
         3Pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345962; x=1757950762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lzjRY7OCEhANtHRWQB+PpwrfD3gB0K9s93cny8H02tg=;
        b=RjTNodnIQ/79O/AuokB2dFnucoj/xH3scHDyuiMbczv2ZNxJ18nKREojgnFLOOkn9e
         22Ur/TaZLF/tyaZ9671+tCdSi4TT40w0e6gb3bb1x0txiDYfzQ/TlJIG8l+kxsGvt+YA
         wo50WV/vjJ4BxQhDFj+uRoFw8/W89+8BYjSNRdONIxyKL8gYU0pre1qVLR6KYMRqEVOR
         fkdDSodSJQUWGmsNpjfKdYQLtRvwzdov85gU5eWcjtIAwy8fcgU71giYkNhY/plbxQxB
         pJX7OHtHXsh37Jc847IIUz2KbEN/3xNyeQL9Hes5uPmwjXO3uKQIj6XUDwNu8K0lvp/1
         skMQ==
X-Gm-Message-State: AOJu0YzXTpxz0o7esO2ElS4w4NiDeIT68QhzhNRyCiYkh1ZsZtA0ovzh
	8O3UH17X8R/KTtOU24SEY/Da5lDhinj/W+nPhDOPf1aQNWRcPQedn+ddP5XqJr+7yYb8HaUVRAF
	gOSHDAbH1WjPRZBLWYDzsOVKCerswAZrVXdZvE4b8VQ==
X-Gm-Gg: ASbGncvZgoBDTeLJoAzKlJ3PAqeNQ5XaEywuG+1l1AaMKt8T4WmLq72z6UvwgfQEojk
	g5oikIWK1Yk9yo/9/RXUcYT3aRwUfN7yB7iK9v4ZsL61fJE6iYEcbPGPOjMooMpS1baSK6Tw1/r
	GGijM1EgShksRB6JYkGku1RCN2exnVvs/C8G2JY7oxJbUwjaQ5HneTmFNskbff/XvUgQiD79rAY
	ISXLly+Ml6FIBsqOWwc7w==
X-Google-Smtp-Source: AGHT+IE6vIcWEitB/WEHH3m91SXOReU2BzV1xyn5fSZTas3gakszgk+FTNuCFOHNNE7e1L+wE/DVue/0/y5UWyLKzfI=
X-Received: by 2002:a05:6402:4416:b0:626:d96d:c0bb with SMTP id
 4fb4d7f45d1cf-626d96dc3e8mr5927847a12.9.1757345962344; Mon, 08 Sep 2025
 08:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-12-ryncsn@gmail.com>
 <CAF8kJuPJU78Dw7iFXK1avk1CCwaRSskK6yPgib0984MjhM3ptQ@mail.gmail.com>
In-Reply-To: <CAF8kJuPJU78Dw7iFXK1avk1CCwaRSskK6yPgib0984MjhM3ptQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 23:38:46 +0800
X-Gm-Features: AS18NWBmxiajmfScv2n3P7by4ia3vaKho37OVplgg0Syg1odlI9ln-a46gnuIlg
Message-ID: <CAMgjq7AxBa6Y8vi1Fbj1Lua6ODfDwfqfGHTjhGtn24LBjManuA@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Chris Li <chrisl@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B4161C0013
X-Stat-Signature: 8o7grn8bx71bgia9twi9eyfhf4bt3oty
X-Rspam-User: 
X-HE-Tag: 1757345963-906980
X-HE-Meta: U2FsdGVkX19ydnlceNVH6ayp9azZvmXHLq1wB9mpmU6IgdqkAh5q17ONWgHrVbYtsfCB1sVTDU9xSwN5ODLAYiu6lLGLJRnfcA3emUg2tf1VYEQRydfbG1ztIgpGM6DTMz65EQIa/qMTFurVH67InJ9s9L7upASgGt1AKrvFWo4Q3qlpPWS20QUTbJVm8p6ERgAcqPS8zIl/HM1T7wkp1/ZtVqhF4E1pg8fnU5Mu/I3Hu8II8faawEt3r0RgCWmWMzhZhSZEJ5A8Y9BiZ+NnSppt5CTQOXUC/TLOwnb7QL8oJq6J3/LM0raUc6DDMFBkuKYUfVAMYcmCcp+G8y5i+76RIhc7pXItxjJWkfICzCN8cMuyUqDVoAE2sq5BOFGtdZYx7J/1YERZH09cQuaojIC2aYUi1ASQpi6RNiQ8x1HMTDRWkL95irKq3zwV4uUI7AxfMJ2ui0tcxxyPsYapXf3ROsXKp9vZ8qgKOB3KiF2AoyAKz/FcRYHIkBwG7aSdUWQfFrY0aWfSeTwMMF8/0xpEww5pCCdOquRiQNgT70FWNqmSW9s0tn5dgfXmpGS0p9qUDVwTnerUFuHHlBaT1LBuNYKuQ2DGRl2Kw9dgYxtkmdX5AEOeAnhcclUKFTD2e3VbhDgn1EyQiWCeDP9TaS1Z+8YetpCYN7dGjUdgC2EfSuQyR0ck0FBDdPmtTedpmWfB2Ybfh3HVXRBF/s2HEQYM7Ep8Fk0FzenFZSQnQ/OaIOXzzdPlhhhAWkFf5H+UTprn9tpFxtizAlFC/EDuABvF1Vg3dErzwD0YwlQ7iq3+e2jH8Rae5RJ/QmjXnZqtPGUGPtcin7SzbrdYbjUtZeNhSZNo7CZwK6YLudqFNC11v9fq66vhogSoe+0KOlJ6iTiujuo/nFEMRHyOws/sCovdALwaCIHxTtb6w+lfc0/30xGjzmtaQI3dBHUYUEO3wfA/iCxCagIr/+DiSrN
 Cjf3QQOA
 KUiRTFpO7l2WbhKHnV8sFAEC4XSQqz5uGqk5W7OUKxplcWOl1EmLlifGtaKLCKxqZKFxr4Qz3SRWtlLVa/INgh0CMs9wyqCT4mVe0AM+adsfmFlUN/bOXLRNBSGxazOi0IiVVGL5OjSzNuREVUnN49lldDJPLuwZdOCZud/FGa0cvdKNmzjMPSbYKgkdTLVwLpslQW4aDvQfUul7oI+nlOkgjacps2s7BOMWHgTCDzjy7ILCY+8hKzVukElU3hRt71ipWJuOgoAwZ7YEDYPsuBLbuZyvLZagjrm3IqDMM10jJEF7yUpnfLELV7LwPbFMvgnio/22O+oxPbsC1i9WF0RQD4rZTTdspFJ+rtecz+KiHPxExla7rF7LZwflFIz/6reUsXgxkkoDznSeA9heScNf27xfV1hiRsFpa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 11:35=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> Some nitpick follows.
>
> Chris

Thanks!

> > +
> > +/*
> > + * swap_cluster_lock_by_folio - Locks the cluster that holds a folio's=
 entries.
> > + * @folio: The folio.
> > + *
> > + * This locks the swap cluster that contains a folio's swap entries. T=
he
> > + * swap entries of a folio are always in one single cluster, and a loc=
ked
> > + * swap cache folio is enough to stabilize the entries and the swap de=
vice.
>
> I was wondering if we have a better word than stabilize, we haven't
> defined what does stabilize mean. I assume it means protecting from
> racing access to the swap cache entry. If we describe what it protects
> or what it prevents, that would give more detailed meaning than
> stabilize.

Right, I used to use the word "pin". What it means here is: locking
the folio will ensure folio->swap won't change so the folio will have
a stable bind with the swap cluster its folio->swap points to. Also
the swap device can't be swapped off so there is no risk of UAF.

How about:

 * This locks the swap cluster that contains a folio's swap entries. The
 * swap entries of a folio are always in one single cluster. The folio has
 * to be locked so its swap entries won't change and the cluster is binded
 * to the folio.

...

> > @@ -123,57 +136,45 @@ void *swap_cache_get_shadow(swp_entry_t entry)
> >   * SWAP_HAS_CACHE to avoid race or conflict.
> >   * Return: Returns 0 on success, error code otherwise.
> >   */
> > -int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
> > -                        gfp_t gfp, void **shadowp)
> > +void swap_cache_add_folio(struct folio *folio, swp_entry_t entry, void=
 **shadowp)
> >  {
> > -       struct address_space *address_space =3D swap_address_space(entr=
y);
> > -       pgoff_t idx =3D swap_cache_index(entry);
> > -       XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(f=
olio));
> > -       unsigned long i, nr =3D folio_nr_pages(folio);
> > -       void *old;
> > -
> > -       xas_set_update(&xas, workingset_update_node);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > -       VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> > -       VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
> > +       void *shadow =3D NULL;
> > +       unsigned long swp_tb, exist;
> > +       struct swap_cluster_info *ci;
> > +       unsigned int ci_start, ci_off, ci_end;
> > +       unsigned long nr_pages =3D folio_nr_pages(folio);
> > +
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(folio_test_swapcache(folio), folio);
> > +       VM_WARN_ON_ONCE_FOLIO(!folio_test_swapbacked(folio), folio);
> > +
> > +       swp_tb =3D folio_to_swp_tb(folio);
> > +       ci_start =3D swp_cluster_offset(entry);
> > +       ci_end =3D ci_start + nr_pages;
> > +       ci_off =3D ci_start;
> > +       ci =3D swap_cluster_lock(__swap_entry_to_info(entry), swp_offse=
t(entry));
> > +       do {
> > +               exist =3D __swap_table_xchg(ci, ci_off, swp_tb);
>
> Thanks for changing it to xchg. I understand that by "exist" you mean
> the previous existing swap table entry. However after it was taken out
> from the swap table, is it still considered an "existing entry"? I am
> considering "old" or "prior" might be a better name. Just nitpicks
> anyway. If we use "old", we can rename "swp_tb" to "new_tb" to make it
> obvious what we are replacing with.

Good suggestion.

>
> Also I saw this kind of for loop repeat a few places.
> Maybe considering some for loop macro to do:
>
> for_each_folio_offset(folio, ci, ci_off) {
>       exist =3D __swap_table_xchg(ci, ci_off, swp_tb);
>       ...
> } end_for_each_folio_offset();
>
> The kernel has a lot of similar for loop macros.
>

There seem to be only a few users like this, but I can have a try.
Will use this style if it helps to reduce LOC or make it easier.
Thanks!

