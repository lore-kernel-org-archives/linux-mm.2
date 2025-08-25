Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84740CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 09:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2768E000C; Mon, 25 Aug 2025 05:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBABB8E0001; Mon, 25 Aug 2025 05:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6D78E000C; Mon, 25 Aug 2025 05:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABEE98E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:46:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59A6A160352
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:46:27 +0000 (UTC)
X-FDA: 83814799614.15.B40D681
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 75ABF1C0006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:46:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YnXlke4o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756115185; a=rsa-sha256;
	cv=none;
	b=RgnO50Wp4rnrz2/UxlIPOu146orVK6TbcD7X4L9X+KtQ4EnKHszED2WuJ7NChPigtEgnHf
	oroZNAoqlnZNzBejjGyREburh5eQNhgg3q7vsTCiO58KLfCIT2X9CeUyD0GtIn8o81wQyh
	ld3hX7BO++2P9G4GC4UUbBxxghZ3D8E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YnXlke4o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756115185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85vlzJV0/y5OBvRtH7AoGcRMx7r7vPAIreX71H+x3bg=;
	b=IWq3A2IZfH8GIaJxuljk2hYDoUbiNYmWu2LTzFjECGNpW4qvS2WNT7sfXlP/7y/3B5Piqv
	z6WExXCLG/83T+17gY1pOlx/zEpaXtT+7L29dKSzf7/SJ/UYNU6GeEi256jj+gI/XJXxPw
	V/i+SeevaOWH+Yf7jVIFUr6/KR5YkuI=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e94fc4de34so36595145ab.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756115184; x=1756719984; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85vlzJV0/y5OBvRtH7AoGcRMx7r7vPAIreX71H+x3bg=;
        b=YnXlke4op9R4HXJwIH4Jg4FoWIDOb8NqQOtlnUWW0t6K2MnFHzvf6MGwBBqXTz5Lm0
         GF+QHfHHP9owMcwPTnw6ONKL0f2mlfYw7c0oCbcYg8ZbH8Uh31aLmdRdURLwKHmN0PWa
         He/Y1Fm9F2Pf7K1EVSHZQmoDxqyQCKa9ID1LygwJLbmSLi+vuX4s25eXQ5ubM31HjcSd
         33W5qdJiJKcwfKGX5VC0/xz4OVC51RHbtPsmMsbWgns8nQWdLIKl0lJ+fqmv6ZntSvAs
         rqj2iGkWNTypNiON80XLBJxX+s6WaAjbU62qFoaQVzc7vQD6GXfPq/bpOgOW4VqBN8yE
         vhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756115184; x=1756719984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=85vlzJV0/y5OBvRtH7AoGcRMx7r7vPAIreX71H+x3bg=;
        b=ADaFAIuKVMIi3Y+vZDTcfebzLUDPMjCe+TIBN7Tdnu6VccnEcdddjKU3DM4BC7YQmt
         QNi8I/vapCaeG0gmhflyKUsdO7tWVKM8kp/ao0aqRkvQHP5OgsmEh0Jh7PPUTn8H+SOK
         1YQxBzKQNVyIySlA0LPhT216sTYb9TQKOnsdOdGy5wmG452aUQOjqtqxO/R2MWvZYtfB
         0AQWeJ8J1I7mAiXnwZwMHvaJBITsIBXPmcESwtiKRB6WTWDB3HLlsfSoKPd9RbX+Dg8M
         FoIK/sW1S6a+/h0mjGtyoGSSm53+Pyaz0nnRKn4ulSp8QZSlFkviyCbuIc/+p/Y/Ol3z
         wsxg==
X-Gm-Message-State: AOJu0YwI9i8D90zKwEQtpcayt+n/9W+9YfHAWt30lEsAuyk/gYdx8C1r
	wSWl2WeY4QJKtSmv/9uWfR9ecmXgqcC9Lm4cVrqKWueztJSUB6sMqyUklveL1YoSHaKoh6fBfH6
	6JIpi41poIG6bcmUiSucZ6TD2jHYQz9Y=
X-Gm-Gg: ASbGncuCJCl00GhIr3fJKUDcUoFU5QOf1oxpSn7j2WStnOqTWv/bcKmYyF+fvhJwT5B
	vh+JKaQpEO4BJLZOy3/DGL/apr4zvrtREsHODbwREFpOTlsI3xKG8vhWf6fQtRfpuqoQ1DyqxUm
	e89dCuAdreIHnpFl8DQMZ/ZcMDUIAwjlzQkLkOjitecIS2rKSLBEwXWTpkO613+0CQZonlbK9CU
	6D5GV0=
X-Google-Smtp-Source: AGHT+IFAikaEYsWSht+/wJX3ArSZEhVcZhprdsD3mK3udXZtsifbgz8EMPUifSFtpWWEExAg/dCHwUQXkLQBVXtvV2I=
X-Received: by 2002:a05:6e02:1988:b0:3e5:3521:46e3 with SMTP id
 e9e14a558f8ab-3e9228e492amr4932105ab.23.1756115184473; Mon, 25 Aug 2025
 02:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-6-ryncsn@gmail.com>
 <0fc6e083-b7be-4144-a50c-d1a7a2e1c3a5@linux.alibaba.com>
In-Reply-To: <0fc6e083-b7be-4144-a50c-d1a7a2e1c3a5@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 25 Aug 2025 17:45:46 +0800
X-Gm-Features: Ac12FXxCEasX7WZXCdIE6kaZfUf7KCWB60OtwzH07oeIYEid6isVhNYOyBR6OGo
Message-ID: <CAMgjq7A7_ZbSWJQj8wjhPb6vt=iLhHc5r=cJdzMeNpog-PcstQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] mm/shmem, swap: remove redundant error handling for
 replacing folio
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 75ABF1C0006
X-Stat-Signature: me9sxoszqpfe5zcefg4ba45d9813z5ru
X-HE-Tag: 1756115185-450717
X-HE-Meta: U2FsdGVkX1+xcur8rU4b4XAbM7Y2STQP1UPiYnFan9x1IWBERgFjsxyakukgUj9UHW2Mg/WyWWfYw/Chzavm5U6M+zxlF80S9mDJVbl+zgzGAtSsW1JxG/gZaDKSFCCJXRtnV72c//h2kyn2HUUNfrurjpaXblGXCjRqnG8M4iM+yjGfaJOsDDGZCawL+eXP9Sfei1lJ9MaqnEI6oWkMcKRQgtYIr//FSmfhpxYiJOpNHyAHjqGTBBT/dFtTVuwVF5O+k04OZoUXsMpBHAA07YmX2C8jZeuVXUDYpeRALT7WuPLg1yhMSdKdXGAx3W+s5n32RZ2vK/f5euxBdR4tyqN4cjfVLIUeULQWdkWU+2DHmPXXPCiEUMSM0Ffj8hQW+ZpEVBs/5KVxeIRdhZ/ms6ByfgdEXJtSe6rjaqDenpPgtgBH+p0vpzDaeU/vFEwQDEsnq0bcg9srxlIbVLeIlQXufQUg8QJbrnKRN2eXsNwnI2SHXIBvAU5dq9PoRhXH8NaMdT2CuWg/dxZNqaH1yXjAxIkBETdhp9p5p43OJuZu2zHR5RKLlLCwn3HQwGFdc+35B0+q/HchqXzp7i2scrNfP/kvukGBYc4d8R9GBhKv4ljbhfwQxVKXeN9QlKLCWAhLwbbRwEDfbbrutxdn11GTnLEkB5dCAalC7R8gaN3h5ElpcmqeDcnRZ0XAYTZvQ1jY0IFEgB1JUhGh6gLr5Alc00ouBeQ7BXxQ/sNnwvJ5cbSq4jzubobl9YrRy2CIg1r8X7y4SQR4rpA0RHhIjJVlTasEREIP8te3tFatDhDo3Af5NFnu8G8PHZE93G+Ivws5waUp/O8DXQv/U87+HPR9U/pMeXa1KuA0vPrOfWaAKTb1D1CeKNQFqASxhwohw+D9QGtqxdrYQOeVKXmdLzoSuOTykgNRZH6gaKO3E9m8fcNIZ16IZVNL8Avx8RaD21/H53kXJBBiaesUXzN
 FXZl4QVz
 6YlCup75KRzjb5HA48Jqb0MlYeDY/htoRtCD0Jt97Xuxt+yeDnazYKZnjCwRx6GJ30EACza284SUgAj/Thy3mhmYuQkCIfiCI0y4Tep47WrGmQLU7GTfy93VgE7opZlIaL/AqpQ6dUxuxhDMd7r9nNl1VX4Rohx4mpmTrZwj5qMIf2iT+UZyAZbxRiwZ1Qd9WtWdxsxEeGA1YfhnlFWgmveFS5i6Qm5FPZ3S1sdwGa9TLFqu5B7EYBpvn5KE0JHKeVEPKZuIHMkFoyTs6TEQ2IbhstSkwurp+M550mMZmajCh3e8koTuSQnN3we+4XvEJjvR7yDCm1FSM0d+D0h04wrvxeHSdDwramRw9PtBgyQS3bbsA/CYQp0wnm2HpWhvdNxlxxU2Tjp83VqNWKPVYqZcvjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 11:09=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2025/8/23 03:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Shmem may replace a folio in the swap cache if the cached one doesn't
> > fit the swapin's GFP zone. When doing so, shmem has already double
> > checked that the swap cache folio is locked, still has the swap cache
> > flag set, and contains the wanted swap entry. So it is impossible to
> > fail due to an Xarray mismatch. There is even a comment for that.
> >
> > Delete the defensive error handling path, and add a WARN_ON instead:
> > if that happened, something has broken the basic principle of how the
> > swap cache works, we should catch and fix that.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/shmem.c | 28 +++-------------------------
> >   1 file changed, 3 insertions(+), 25 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b4d39f2a1e0a..e03793cc5169 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2158,35 +2158,13 @@ static int shmem_replace_folio(struct folio **f=
oliop, gfp_t gfp,
> >       /* Swap cache still stores N entries instead of a high-order entr=
y */
> >       xa_lock_irq(&swap_mapping->i_pages);
> >       for (i =3D 0; i < nr_pages; i++) {
> > -             void *item =3D xas_load(&xas);
> > -
> > -             if (item !=3D old) {
> > -                     error =3D -ENOENT;
> > -                     break;
> > -             }
> > -
> > -             xas_store(&xas, new);
> > +             WARN_ON_ONCE(xas_store(&xas, new));
> >               xas_next(&xas);
> >       }
> > -     if (!error) {
> > -             mem_cgroup_replace_folio(old, new);
> > -             shmem_update_stats(new, nr_pages);
> > -             shmem_update_stats(old, -nr_pages);
> > -     }
>
> It looks like the shmem statistics update was mistakenly deleted?

Ah, you are right, I'll need to add it back. I somehow misread this as
the error handling path. Need to add it back just drop the !error
check.

Thanks for the review.

>
> ( Continue to understand the whole series:) )
>
> >       xa_unlock_irq(&swap_mapping->i_pages);
> >
> > -     if (unlikely(error)) {
> > -             /*
> > -              * Is this possible?  I think not, now that our callers
> > -              * check both the swapcache flag and folio->private
> > -              * after getting the folio lock; but be defensive.
> > -              * Reverse old to newpage for clear and free.
> > -              */
> > -             old =3D new;
> > -     } else {
> > -             folio_add_lru(new);
> > -             *foliop =3D new;
> > -     }
> > +     folio_add_lru(new);
> > +     *foliop =3D new;
> >
> >       folio_clear_swapcache(old);
> >       old->private =3D NULL;
>
>

