Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7D8D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 02:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2B76B0088; Sun, 21 Dec 2025 21:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7913F6B0089; Sun, 21 Dec 2025 21:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693A46B008A; Sun, 21 Dec 2025 21:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5516B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:43:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC5DC1409BC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:43:47 +0000 (UTC)
X-FDA: 84245561694.05.89A7700
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 17F3920002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:43:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwMgNUx1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766371426; a=rsa-sha256;
	cv=none;
	b=gf9wdXJtsNuKgpeDt+WgrwJhT7MdUNksTLA/ksq3JkuuWneqgyLrDuATFV4NBR9x/Vrnyj
	X9RiI3YAfBleDpv0i4sqScg+nz8kxYVZRKm22hZMIFX2AvpYEOFiG2ce18V5XIzd2+ZQKq
	Pw6wJTW6EPS0q3kVLuDNVrQc0eUTBME=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KwMgNUx1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766371426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1rmnJHJ0LIIKvu4W1FDMChpGkEUx4rv2xP/CM2TZPs=;
	b=WBh8azJzyRKyHAcokyqGIJSIuXehPC0IGau70+2ND/zbtBoQqQUsCUpJCg2YnG4AGrLwAC
	cxesm8ukd/zk2tEQFMK0iQ5FvAwQlva5yHs66VoGXknXVFMhjMkCeCdP6jfaxFjiuukvMz
	oYZ+uWn1hul2It8H5vcjCIv5Ztd3aIs=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso2869867a12.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766371425; x=1766976225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1rmnJHJ0LIIKvu4W1FDMChpGkEUx4rv2xP/CM2TZPs=;
        b=KwMgNUx1t60sZmQ/AmjCsUlYKV+AZmH16vNgijWO1GqcsoKrjjoaAsluSB+xh3zord
         ZcG/WgO+cOxb66m1TgkSbRWDpS5gO4p812PplFhJtSCDsfUp6ATYWmoOI+t/kP1x8wst
         5gazy6C1kVnDVXnu5An3pfOUfLap8qSvuYZa9WZ/D9bYW5C2Rn/T71GHtdWDzJIi+JRp
         hHgKp3+zV+7D1Z8VmmxPxMn2tYTv4i9hF8paDJDBRdMr+RvD3/a/KlRlzM7bg1FdDrA/
         z8bKOoaXX2j6rzVaG/hMjuazNQq9+dTRTlXalKFGElsalBsAA5ue2bC+lGCBt1tZF7gk
         GlgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766371425; x=1766976225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q1rmnJHJ0LIIKvu4W1FDMChpGkEUx4rv2xP/CM2TZPs=;
        b=dbRrhkNX+X0qEP2DOYB+KJPGUFsnu3BqFfiNojfJI8PzAt6hRQBmNVfHasVhSHikaZ
         e93+6YwcZupRrcNfkrtIphVqTtjAyWB6giDIIoSbVYlPwLbzZLXfkIEiGhHqiGdRUUxh
         +CFk5Q1Wm68CS2nMkBuTyV9nGpUBjkzcX2qjIFA/TsUhlBTbDwTZhjcGwEEpabVZP+Sp
         79GysGIdruelZCQX0ATMWjsH+oukTDeUV53R04EPALE81A/5C3UxJfYgxpqgeqpyQWXg
         RIAB02le1QjPMxVEmPTa9tOSqrCJki08IxpCDFYSOMrQDyuie8kLIvQOGIMyk1eFT4xL
         AARg==
X-Gm-Message-State: AOJu0YzhyJbdZMJPaPtHdLxVCqyGj4xC+Y+uKBNcXBHZgkAe6M2lh8VY
	nBhf4kCss9pjCu2R7FNKfL4idD3S+4JWLvvzd/pg4Zucyic41w15bKMECs5tE98QvoDacPILpHr
	EysXS7am5d7vVjhqbIzpmYKCFAUTB1Zs=
X-Gm-Gg: AY/fxX6lHNTkw6iJaYJGhmsQENNqBiZ+4bGiGpSu7FLxZ0kObyUKkHSdMVMAb6DTZnT
	/3unL/M24sHeCdhrh9WMh0prgISuUmoOUqp7y6eBIe72B+fg/44AWB599ZXJZLEevDQBUDg2zYA
	v0IoT8M7C7mG0LrqlrCgNk9IIZIqWs97VU9/4hSh7htzGHf+9cd9Ygx5I6phVwUM9ZpZAUcJlof
	E0HmYN4JaC/BUMjKclQpmiZV7mwrL8KC2B8HJ9LgAX5PrCC/qZ4cZElkSQB7uuj5cx2SJeXvqw6
	IQgbMTGJdrit5mfs8SKcMKNRrSzQ8C0l+YnARg==
X-Google-Smtp-Source: AGHT+IFQefVoDjM6qXm9xXsRKL6C5aCvgURTze+OI7STgiaTEbImwqWU+RexOaZArGYLh6oO0cqE4lk+8QeWmC25uUQ=
X-Received: by 2002:a17:907:da1:b0:b7c:f120:bb23 with SMTP id
 a640c23a62f3a-b80358be994mr1157616166b.30.1766371424269; Sun, 21 Dec 2025
 18:43:44 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com> <aUYfxQtmWO3STLa8@MiWiFi-R3L-srv>
In-Reply-To: <aUYfxQtmWO3STLa8@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 22 Dec 2025 10:43:07 +0800
X-Gm-Features: AQt7F2po-umw4Bfriv3QUkuyjx9oV1Fuo6qEnrjh8W-LWnGbCOhdEYrniOCDIg0
Message-ID: <CAMgjq7A=n=5cOgOYm8i-DmgjxQgYU9om2oq02nBk5vkn7dambA@mail.gmail.com>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 17F3920002
X-Rspamd-Server: rspam10
X-Stat-Signature: 9ebyss9i9pymqgz1b33ygkuersthptfr
X-HE-Tag: 1766371425-220770
X-HE-Meta: U2FsdGVkX1+QG5nwDMDYLyxbNXzvcX0QeF1XXzWmQkRyAVWd/02B4bQmSCSUmvzCBwG89mjo5Iki5UF415g1N/EKQrerywTj6Pm6z0gthBNi2y6lP1JtmqgJhVkx8wa6wEiekYgH7yxwXEUaOjQksCpxN7NIrtM67JWrUtS+Abd11gSIINnsq8rjI6KGpSe15j8pmWOotEtqjyq3Ht/C48xvTSakULCZnrtK+/w1Cbwspx0MWZxtDAKejEqb9vnQCji15OS1CV2IbgTMUO+AAsaE48G7MldnDLdQUyURNwwfsXfFgjbsBns0UieCE+yS8lxQtv/SrJIe9/bYNUYX4ngHjh7XPsMpVvqPcgBWR4vpjHcAD4tLJV5l5tm0MQJQPhKWxwL5ALXNA2z1sI6sScwA45AZYA14+cmLILxqjfit8o4IPD6CfZRDvOmyIHk8yS5l1jFoShxb+zHfUNrNZE8HRPQW9wdM7G9T3FDz+bMlm+RJK9LAaNxTQMS/gsY0VGzn6H/sQ45xIZjM0PVViKJ34ktgeAgjy58MZFMLFcU8aXoAQOVqd0nLrv79z2u9jgYJPv10J8Wt/5h2Py/4bh1piTMD6ghG2d6aYospykneo7X4Ur3Vjxtv98syH5cLi+Okah5/B9rqXMcDItJd+4LTTodlr1PYmebLDuyF//+OVNq+ioF1e15oNO3ayZfxxwnOJ45xviDj6SLncqq9+74eqTRN7uNnqHCWO3kKia+zTzpdCwbEi3VrIMO0E3CdIh8DPCm3eVJnyFgaEI7uzdVJM0RNWhh2FGI3J4vgGuKJmj6ggCnPQzMIqmaXkTchRiuK6tPK2/Cq3QZmbEDbzZH1OyRsGoUuOzDmqmK7MPIZXsbnzqCYUWHkyDUY5Pt4ysvyBov5J8XICQvGbMcvAZn1AHnBDq9VoooZTiUVShck0SiyrM16d45zmWe3c8d7CKCua+x4C+eEdcUdAnt
 3KZ9ffjB
 R/PWXop1JVbmfuXN1LQFidvV1p2V192EcVR/c0h9o1B1Pjy+FSFrxtFFAsrSwChzC4R+qHsqE9/kdAXExQa7UomXB0CtgJ+nxVT7RTj3WoORj97WO6JDBE5mHRO+xAoZP1zUTCy5bnQ4gZn5slIGwOlyubw88h94RF6cNqwQ+yd9l+MhILNbJRlwoPQuUem66n1GJi47B/AxdQAJW177BMEERKG46LW61mMdvqNEPK7dYnC+S+Hda0UfuqrOEncgoDmXe6uiT9BJNU7YW+s9UVUuioUb/5zlRDdu/FaxCGFBGJdRpehIuY/wcQFgnYvniQm00t6zlLv92J+WnY67vNs4KdoleqUKQxeGB8lSng1CAsraR/vxgfBy+DMWN38c6FHsHQgy7wkPvB4vusaH+ehgRQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 12:02=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/20/25 at 03:43am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current swap entry allocation/freeing workflow has never had a clea=
r
> > definition. This makes it hard to debug or add new optimizations.
> >
> > This commit introduces a proper definition of how swap entries would be
> > allocated and freed. Now, most operations are folio based, so they will
> > never exceed one swap cluster, and we now have a cleaner border between
> > swap and the rest of mm, making it much easier to follow and debug,
> > especially with new added sanity checks. Also making more optimization
> > possible.
> >
> > Swap entry will be mostly allocated and free with a folio bound.
>                                           ~~~~
>                                           freed, typo

Ack, nice catch.

> > The folio lock will be useful for resolving many swap ralated races.
> >
> > Now swap allocation (except hibernation) always starts with a folio in
> > the swap cache, and gets duped/freed protected by the folio lock:
> >
> > - folio_alloc_swap() - The only allocation entry point now.
> >   Context: The folio must be locked.
> >   This allocates one or a set of continuous swap slots for a folio and
> >   binds them to the folio by adding the folio to the swap cache. The
> >   swap slots' swap count start with zero value.
> >
> > - folio_dup_swap() - Increase the swap count of one or more entries.
> >   Context: The folio must be locked and in the swap cache. For now, the
> >   caller still has to lock the new swap entry owner (e.g., PTL).
> >   This increases the ref count of swap entries allocated to a folio.
> >   Newly allocated swap slots' count has to be increased by this helper
> >   as the folio got unmapped (and swap entries got installed).
> >
> > - folio_put_swap() - Decrease the swap count of one or more entries.
> >   Context: The folio must be locked and in the swap cache. For now, the
> >   caller still has to lock the new swap entry owner (e.g., PTL).
> >   This decreases the ref count of swap entries allocated to a folio.
> >   Typically, swapin will decrease the swap count as the folio got
> >   installed back and the swap entry got uninstalled
> >
> >   This won't remove the folio from the swap cache and free the
> >   slot. Lazy freeing of swap cache is helpful for reducing IO.
> >   There is already a folio_free_swap() for immediate cache reclaim.
> >   This part could be further optimized later.
> >
> > The above locking constraints could be further relaxed when the swap
> > table if fully implemented. Currently dup still needs the caller
>         ~~ s/if/is/ typo

Ack, Thanks!

>
> > to lock the swap entry container (e.g. PTL), or a concurrent zap
> > may underflow the swap count.
> ......
>
>

