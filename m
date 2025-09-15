Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9C6CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881B78E001F; Mon, 15 Sep 2025 11:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859248E0001; Mon, 15 Sep 2025 11:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7963A8E001F; Mon, 15 Sep 2025 11:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63D098E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:07:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31682BAAB6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:50 +0000 (UTC)
X-FDA: 83891814300.04.3E503C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17CC012000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DUPYwRGe;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tteVFK+G+4vLgCHuCKPP/CtekfVTjkp1IwcAQI+tCGc=;
	b=FxOwbcyMJSsAAjJxLDYGsL0pF3BsMZMj6uxTOs+eZVxwZdrRzyXdHGDYX8g4eB/T/Jpyf8
	TPrDsnkNwF5cAfi4BvH3k9a0+QsvsneODSQAz9FwrDrNlG1BDL14arD5o5YYtYFEs5M/Zo
	NsgnXFilsPhsApZ6YPOd/gMeErVkj3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948868; a=rsa-sha256;
	cv=none;
	b=hOd0SJiCDNfQbS4yt77oHZ/KW3eAODzpPN0IPvswq9bkmjawjzThs3y4zY+pJV3tM+Q33N
	0NznjbeEOPqTfU5kod979XqIehkqFcSwoB3YZlNDAiUGfVa6gDFF9JCjYo0rVUjYHYJr3n
	naaoBk68BpjTWmTsKRiO06SMXydNKnk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DUPYwRGe;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F185544852
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8376EC16AAE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757948866;
	bh=lbCbHZj7vfmABIBv408giulALA9kMK1IB9J3cmB5oYA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DUPYwRGetiwBtqToVa3mN0ORT3D72xTqd5CkfqrL5OKuXcHrHZPTsPkmgQIk5xvZb
	 8Gbnw7KKoZP++icj/e8mQGBPn3ZaZLvhfLZRnrjQ/rj2SkTIVlC/zs/04r37QsBry1
	 2KhCxGdAao9ZIdXMJ3TXd2Kyog4EqRE9EdbgZt7gl5HMXBEHO0yxR8VpjwF2mKQZdL
	 TGPSLSsynhPsW/KUeC8PG40xlbequa9M7Dhcg7SVRiXWVRqnstM1F5IKFs5k2AGOyI
	 SxTMQD/DDG0zLQWeeybcuFqAGJLcM2if4N4GgNOMUudXl2R/0fHjJaHzj9u+N9Vtea
	 Q+J4jC16iPWEg==
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3eb08d8d9e7so737623f8f.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:07:46 -0700 (PDT)
X-Gm-Message-State: AOJu0YwJN+J257XLJaj+NOhcv+w+u/oDhtDaV1Q0O59WB2g+T4NO/xUB
	VTlrwzFt66VKe4UkEOwIHSK4A0Ut/4zr8wQunreC0irFZkk7Knw/nskBmZf6/l5KulJ9PV8e/Qf
	NIVveK2LGwVIu994kcAnmj+j35r+2Snkt3CjnDUy5tw==
X-Google-Smtp-Source: AGHT+IGhuPmaGbUuWGfTk4lCZHKMHwj2fhjE+kTpWT6mdDBdnrkVFrFl26qtvg+vJOM3dKP52DILM0q3LcZL1isatKE=
X-Received: by 2002:a05:6000:2f81:b0:3e5:5261:9fae with SMTP id
 ffacd0b85a97d-3e75e0fd387mr17332464f8f.12.1757948865195; Mon, 15 Sep 2025
 08:07:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-6-ryncsn@gmail.com>
In-Reply-To: <20250910160833.3464-6-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 15 Sep 2025 08:07:32 -0700
X-Gmail-Original-Message-ID: <CACePvbX4juhR5jry0Bi202qo=nfFVZkztHzo8KxKMW_yKBseyA@mail.gmail.com>
X-Gm-Features: AS18NWBcTBl91C5Xf37GBuC1knYSyNgjXDoI6S9qWcNEbUHt8JHt-T38VvczERs
Message-ID: <CACePvbX4juhR5jry0Bi202qo=nfFVZkztHzo8KxKMW_yKBseyA@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 17CC012000F
X-Stat-Signature: oboz3ofs5fuy5yfgq31qtoarc3dba4de
X-Rspam-User: 
X-HE-Tag: 1757948867-86439
X-HE-Meta: U2FsdGVkX1/uY4l56f/fDtJUYh5NkGVbarJmL0E1BFV3Hj6ioKH5cRhT6z3znsbqjEbktb6WW4j2vJMIjuoobXgpgMAwPGuteFEqyDeeK4VL5ZwYihLWIPytFFEyNoKDIxK597q3A62q/k9rdAQ74YjytLa7GHucMYK9XN7Ddcq26IuY9GJtVTLWm0D+DrTEKHtnmNIjfQxxB1DlkOYKDKIgZndhe3LiuwIxFZ0MMHGT0GszbmmsThvPBHwuMGBUwS0FlpMhfQOrPsj7Bly1iuVfCqU+hsFptDN7z/yOWveHvNgejIoFTq5FWr6xgjTgDQrXM/6jfkCGZAX6wImJjMYtySWlu/X14TiotH8q5BuutZ6h2MV7nu/qMXoPdPETkZGotSI+Kf3u3IkeFlBbIsbaD4ofIx4zJM6hBmF5nTNdmSxgY7RNaq1qIsLViRvSG2Kc0gXpgiHMo0uA7CMFHmB7Ip7RtiQ6apdT84Yp5qu5ee8AOJcjXQbnAYsceXk3viHHZlpbtZzs/H8wvZzLcpSQgvRXTSXlK+slo93Q2vegOTcnp+0w8UyHOeQn6xKevvJp8ey8Kn7sBGCfvJM7fixRYTJoUKgtd1iMhEZVVJC22gve36/uvUHpsSM22dnjdzUHIIZgSHIGJfH7gOHB0fK82sAfZ1dsv1y0CH0s+uMT63fMecK9tXAMYVqW52H/7ZhRQAtH+zIZqUw1ZBgtAGRF0f7ofQzfbQIqmwvWHEcKrJonIBDiOswQSjpxEdgRxzTTPRk21sZqp1tY51TOCwH64u75wjkv3byqMT738nb8Bg3HucjFN2w/T3RRt/PH0t6YkZD5wGn+km3haVJtLS/NKugTCP7DxpZRr3SqvJoj03WT/oL3vZ3GQ1AbbAwNwi3DDAZMtePIchPgGB4ojpfFa0bgjy6EIBUistNQiAx9NvOE8S16YIfzLIjGBmNXMkO9RPEQecXM67lEh60
 e7vEtVph
 5hHIc6FogZdAey1Po8ZLM3qo7exOPM6BITURN39PBOOOH6YQXEhXNoU/o0y9XhOVNKK1w7Ku4SK8pLdehUwTxwYTbPdt0nthBx7S6WM3flncze55VuvdTW5sB6nVOVRHgc8Zk2vXXD5M1TsaRSK/YlkwkTezdkJLpJ/6lWsAfKIMmg8shyJQuJDscS+BgdFPzzLqBhK+yZskryWOZnEDII/IkhT72zDpshPGPwC/9fdKgXr92xnr8Y1lB/1CGQzuaVZn0RpLzUj/F3l4JPLT0ICB/NJW6P3mFM27w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 9:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
> @@ -2004,6 +2002,13 @@ static int unuse_pte(struct vm_area_struct *vma, p=
md_t *pmd,
>         bool hwpoisoned =3D false;
>         int ret =3D 1;
>
> +       /*
> +        * If the folio is removed from swap cache by others, continue to
> +        * unuse other PTEs. try_to_unuse may try again if we missed this=
 one.
> +        */

It took me a while to figure out why we add a
folio_matches_swap_entry() check here but we don't have an existing
check for folio swap entry matching in this function. Can you confirm
that if a race has happened causing the folio swap entry mismatch,
then try_to_usue() MUST try again rather than "may" try again. It
seems to me that it is a MUST rather than "may". I am curious in what
condition the mismatch happens and the try_to_unuse() does not need to
try again.

BTW, this function has three types of return value, 1, 0, and negative
for error. The 0 and 1 are ignored by the caller, the caller only
cares about the negative value. Overall this unuse_pte() and
try_to_unuse() walk feels complicated and maybe a candidate for later
clean up. That is not your patch's fault. I am not requesting a
cleanup in this series.

With that Nitpick,

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> +       if (!folio_matches_swap_entry(folio, entry))
> +               return 0;
> +
>         swapcache =3D folio;
>         folio =3D ksm_might_need_to_copy(folio, vma, addr);
>         if (unlikely(!folio))
> --
> 2.51.0
>

