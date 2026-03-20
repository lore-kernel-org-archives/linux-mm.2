Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC4C109319C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7DE6B0363; Fri, 20 Mar 2026 05:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8D06B0366; Fri, 20 Mar 2026 05:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96F76B0368; Fri, 20 Mar 2026 05:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9590F6B0363
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:20:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C94A1A0890
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:20:16 +0000 (UTC)
X-FDA: 84565895232.09.A53044E
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3BAE680014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:20:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQNE7bD0;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773998414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZuGZ391DUfS6FpPdQqJz0ZnNZFZyHq8nHxd9XEXSXvE=;
	b=IFvTUpvR9I+++Cl4rvDNM9BQhA2e8Mw+0DvxE2jyyRGzroJ1xo8IMAm1nNBMqRsAOM+bMo
	HRjzZh/KG0lcYXP4InRqg7RDLNwai4W8ZX1H8Y9kXW1vRcsc/B1t1tb0BHSO2XvpqTVIJH
	TmFTSO7MSH25Xr0neSdXCdilHBOOYjU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hQNE7bD0;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773998414; a=rsa-sha256;
	cv=pass;
	b=rlhrQu/lrcaWJVEj1dG7oroOPkdH85IJAZjcUvv7E71KG3zXi0Y634v4vIw05QNcqx9FN3
	Uiyvw936/1k2eOS3YeMxlL7QFXp3aN08HkGBKQIuDKzjkwKwQb3jiALrXUbGv8r3mrERXx
	KtZJbbDviFr+gebI/9eExsD/BI9xLrE=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-667acaeae82so2537261a12.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773998412; cv=none;
        d=google.com; s=arc-20240605;
        b=VESK23548QZfDKUPnl3yxdCqKQUWPy62Ruq/EzYNX3XRE7lOdKo2qufw4G/MjX+tV6
         xYndIZ1+yc77HJawb9d69PDJnPyeCJmu0yePJcb060eIRwAuXhHDWiCI0Bql+e2EotVU
         +HTdO1bXOG61u/qWItOfJ9sN0S04DRdhM+wfiue9d728OKOY7oPV58PRNkgwzkwMa/FJ
         QXEW2QGORkZbmjyqvlGHBYX0tpxs6Lab62tXriGhZkU7oMmiQN4tT7OjbAifx1EMxT8k
         lRzmzVHXWc7lBmtXHJKQZG16AvT+IRcZdCSBOAlbQkjxzlRto9rWIXiO8m2McicTNkCV
         3vEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZuGZ391DUfS6FpPdQqJz0ZnNZFZyHq8nHxd9XEXSXvE=;
        fh=KuOtfIO5nB0+DWA4HPDvV4WdmSwsE/IPlCAuKGarC5Y=;
        b=E9cFLcB21wOwkhLhPGkjHXmc+v3BXNrILtdZr0liwTrQIDDM+zQdSoJOJAsxm71NDT
         WLldNbU/UZl0ts26mSiH6mO+3JURnq8qcdZ9nc7YKUS29HATMcNpAiFEYp90lxF26cWE
         1H/aphOEUP5na+VC/BqXcL5ISYs376higlojUSjMBY+NWZVG4iYkEiBmqBTpalGaZNkr
         w9N6LWD4iwXGwRdp/Eer3o5yw+qDEPtk+mTJKodmRUI3wX6TjCMjpoHFqJq1ykQLw2j/
         28EP6PLl6i7meOfjfe7qLLlC8idVYeWc8EVBrxruUrhLt1yomqeJUPNQ1s/h+FElywSF
         wuPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773998412; x=1774603212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZuGZ391DUfS6FpPdQqJz0ZnNZFZyHq8nHxd9XEXSXvE=;
        b=hQNE7bD0GXfqzJRCas24uax5vWfVM+NEOLwRIZnz4ZNUKLQwPzLf4/Mqj02yfBczfL
         fRhwGko1uZtxYFvDj/dMPtYab+xgt9vR7ej9RdUCta8Ze12FiZVukhw0qIEVk+fUSmRD
         Ug0mV9yT44uCZJBSLiwPnRhNV7hJAxV6HqGbhyk1epSKQwSMuGadB6CtB3glq+BypBqx
         m9+jIbUUPdNCLwD43PJS8KxoXREJgYg9v+hXHJ1udbnijMv2nUsiNx579BOWPXcpIBQQ
         P8CqBphImCaaw1xMj3nHEO0CLuCyeJ2SPiYTnb0rAAuE+ouho3+0FvyAu5IOxXmjDEjT
         Kjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773998412; x=1774603212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZuGZ391DUfS6FpPdQqJz0ZnNZFZyHq8nHxd9XEXSXvE=;
        b=C7YsJQ6JFPLiTDCI2ui3s8BNk/9J+Z0Vq51vD0UwRKNMtkssw5i21zjvKG3tvsIz08
         UImLpqqGRF9qGEnbh6iq+Uqa9nkIrDS3esjlP3V0ggyjPiaVXZTYvtzD5bMuB2aCf2+z
         w5fztbTyzlzs7T/ycOWUVZ+eMqbNZ2Qglx1PnSLw7Xi3vynqBqOubIBB7uZIe+gEV9YG
         jTTt7KtiB4svD4LE65IDbbpghfVkLSA4lemrCBtGq1vATbQmW50clvPQQ9QmhQxSpfaO
         6/vR4Pju//XwPIRCXU5BkkNv/83TYYuDs/fmlqiQMiCYuPdUbbtRoMFbw7zTBuf1e3k/
         2T1A==
X-Forwarded-Encrypted: i=1; AJvYcCU8Ny1R/Zimp0S1vXhTVV8D3bTFuJKO6snAfyuOrTYkU6IEU1EmQqzacq6nwjZ40u/nHAe5AAB4tQ==@kvack.org
X-Gm-Message-State: AOJu0YwYt2Lc8DD22+GQ+TUhw5JjDefpRWPjngZpB1B8SRJEdCz8lTgN
	2eXDe97xuAi2ZTtzjq+TWZYjktlvX3nOtNMGWMX/B3GlbmSQcZyhur3ItQwwoZ2SnRK9KPdBHDD
	NyqBYwLCJZzscYlbvQRQaBNKDGWyIbfU=
X-Gm-Gg: ATEYQzwh//i42RlRxvC5/xi4v/3F5po5N7bdG+3RhDogNbVKBdrZhGgitYnVOna3FLr
	WqvU83aC/zln4WrBkWqF7ooKZHn7iqms+UGV4u3AqepSYrDd8qFU8mWGuQZQwbex7fdrk/sbHbp
	XEj41Y5wyQsfb3fDxlsTEAEf+uoyJqMXdcdOU9AbxfYhgjc+/YyhFwSvfUAcgkGU8CSEF2rv6lT
	E9rE6XJLmxYA2MfhBzGvtUwRH2WrSj0fds2QXoycuz/pU1lqWWSxWChiFfr+ckgD7pqJz/y1JqP
	ZGDqoUzN2pmD4vGxoEwDXub3+DlCyQHlOeeAwd6L
X-Received: by 2002:a05:6402:146a:b0:65c:23f0:a80d with SMTP id
 4fb4d7f45d1cf-668c9719556mr1755407a12.19.1773998412057; Fri, 20 Mar 2026
 02:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Mar 2026 17:19:35 +0800
X-Gm-Features: AaiRm50TXmHjr5UV1R6hdQXy4kq_kWcX4tukg6-iJ1Y7wv2OOm_lmvSeJnnWPYs
Message-ID: <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com>
Subject: Re: [PATCH] mm: skip dirty file folios during isolation of legacy LRU
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BAE680014
X-Rspamd-Server: rspam08
X-Stat-Signature: 84ozk6phnu9u5an959t1co45uqga8crm
X-HE-Tag: 1773998414-448111
X-HE-Meta: U2FsdGVkX1+LhMr5wp0ExbPcLNLyXO6OTRHDuZZO/JJEqnIrGbBy+BQxgpi5Lxi8KCMUHo4S4Lxw6wp6QBnOTDj8i8Swo6IYc4xMYYBCTjMEIfqAoftHbmAfQ/XND7eJT7MBXu5nu6HfsAnl9AgyWNSq7AAWt3mYfvMY2WWvvRTW//J6vgpuDWLJtROYN3jiadfQ1jzIQfxwGrqhntKF7RBxEJqDhIRaxrVc7wGzNBe7noiMaYiZX1d43v4uru9HI6+WDs1cIrxBNUP+JbyhDeJru+xNdxY7k73z2IWqZX3gOzkiF8y2hz84oP/PUfc8Xiy5SYf7ZqqLEx2Gj6nnV1z9HoyS8UiufAHj/d+wFt1gjgaZHHsJIULyOojLSmb94tARxgKJ1ZEBT9PZXSRaSai3LXtKbuoqjAeEgKF31BKDdbs7/Vw9tYJwfNbUoNt67iPs4kUSEDrlONU1AxyFygND6sXX9reUduspzXf9ThnMd3FtX6hHh4zhIk6nd2jO9SxVoKNNOcTLtdywp7f6zBV+xYFe4M3YjAVNDk21KA1Me8C91ZiSZ7RGFnZofpKONo1pNH/p9mNVdN96Hvvtw56noq3agO+qqu3CW1xv9spKXo5URd0+rIcE+l5cdYPhgsZ5v4M2eDuUtoQMjERP6UwY7HrxyEaVAg4p2LKGV15CbWeu8mj30yhVXN3b2jZQy1mhdxn/GLNta81tsll4QziS8Z0kyk3y5zKanrWKy3xXzr9Tw0wGLaCE0LmG49fAW6On9mRrg+rZLWWBg4up8zhHY9GZ9ACKlbFovDXqlfiN+Mt7rNTvqDzAQ1Dp04x/XT57wJNCUoedvTI7yV9sN+BW9tuWtdvw/VzXeA0Z99xyUcAEaGKMhi17Nh6cEihYB0aAm+yuqVK/6OAw/8NpC+L8hLyAJd4HKFrmzOnpSO3N8UqnSzQIMbJaVZUpLN7XShvnJcvjNSB8IChd8/B
 j3rM4pT7
 g05ojU3MimhVjJw9x2wvQ7qpX+bJCQw4oHnyHk8Akt6sL70PtQ2tJRAHDe9pq0dYdQgvjm7jidP5cbBxG7C9p3GBVPYgm41xFDVC+gf8hycA36/1MBspF8gzK2Jerzmsj7aeUoTO9P17JfPxcgNtSoSUNJwLz2phViWNI8s57vA1g1m9enJMJo8LwS4dZ3AMZAQl14UrfJcHGCXO+IdJd+a6+AP6ag94PoJf9w8Xc25Tvl2J4v1QPns2EjvhjEUW9NLU5iPjsPpo/xO8EvopuEO3IeFXA3BzkBPhyOxR0Rf9Mu85y1a/RwiqC79Y+kGw2jOr29NyjQJFVcb2EpovuHdsMAO2KSt+zadArQcGEG7GTrF7R9GXuPIAeW8jCw38hWEGs4md/k98TZGRKMcGcLFAFxcZ5I6V0gOIqvLlKhF4lFJuaUxQy4OS19caKjiE1F8u6agEh+9NEg1qWFzHU8Wm09Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 4:34=E2=80=AFPM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Hi Zhaoyang,

> Since dirty file folios are no longer writeout in reclaiming after
> 'commit 84798514db50 ("mm: Remove swap_writepage() and
> shmem_writepage()")', there is no need to isolate them which could help
> to improve the scan efficiency and decrease the unnecessary TLB flush.

But you are still isolating them with this patch, you just adjusted
where the statistical update happens.

And this is kind of opposite thing to what I'm trying to do here:
https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@t=
encent.com/

> This commit would like to bring the dirty file folios detection forward
> to isolation phase as well as the statistics which could affect wakeup
> the flusher thread under legacy LRU. In terms of MGLRU, the dirty file
> folios have been brought to younger gen when sort_folios.

If you really just skip isolating them, it could cause a regression:
skipping the isolate and put it back will cause some ping pong effect
on writeback / dirty folios as they will be stuck at inactive list. It
will instead decrease scan efficiency.

Currently shrink_folio_list will reactivate them and set the
PG_reclaim flag. They will be deactivated by writeback callback.
Simply changing that and the flusher wakeup logic could be a bad idea.
You can check the link above and see the benchmark result.

And for under writeback folios, there is no IPI flush or unmap as it
was returned early. For dirty file folios they are unmapped indeed,
but following flush should reclaim them anyway.

It might be a good idea to skip the unmmap part for dirty file folio?
Maybe, some benchmark is needed.

>         while (scan < nr_to_scan && !list_empty(src)) {
>                 struct list_head *move_to =3D src;
> +               bool dirty, writeback;
>                 struct folio *folio;
>
>                 folio =3D lru_to_folio(src);
> @@ -1749,6 +1731,30 @@ static unsigned long isolate_lru_folios(unsigned l=
ong nr_to_scan,
>                  */
>                 scan +=3D nr_pages;
>
> +               if (!folio_trylock(folio))
> +                       goto move;
> +               /*
> +                * The number of dirty pages determines if a node is mark=
ed
> +                * reclaim_congested. kswapd will stall and start writing
> +                * folios if the tail of the LRU is all dirty unqueued fo=
lios.
> +                */
> +               folio_check_dirty_writeback(folio, &dirty, &writeback);
> +               folio_unlock(folio);

For LRU contention, to force active you always have to take it off the
LRU first, folio_activate will take them off and touch LRU lock
anyway. And now here, there is more work under lruvec lock and it is
also trying to lock the folio under the lruvec lock. The LRU
contention might get worse.

And the wakeup below seems very wrong, you just can't throttle or wait
or sleep under LRU lock.

