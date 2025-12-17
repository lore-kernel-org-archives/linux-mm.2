Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8A7D66B81
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572506B009B; Wed, 17 Dec 2025 13:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528DD6B009D; Wed, 17 Dec 2025 13:30:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451C76B009E; Wed, 17 Dec 2025 13:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 328956B009B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:30:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5EDD60A75
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:30:42 +0000 (UTC)
X-FDA: 84229803924.17.DBC9EDD
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id B9D7940014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:30:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARUaDjU+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765996240; a=rsa-sha256;
	cv=none;
	b=0JrSSScZ8xEMOfrd7vWzPdRx0y6WfuaUrbI2fscqPcHZlHM5FKiCckf5ZkfeJd1YlLL9WI
	XSk8hC03vbXr+pbuVQeIPcsD9bD1KzfPyZWKt5DS4Zy+x58TqwKcg8qw2WeUKLYk1RZ9Ge
	8oHdb2oXRdXL1oaFloSWhwpHnQMMvHs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARUaDjU+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765996240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1buhmUPjbOGX8r4QI/9iXCbU44ejW/6DARhRE4VyVi4=;
	b=a+BUDpL3oBVZ7JvVcijxEk8ID+n8BGP43+MUNAtV+j7mw/5Mls0MPRXBe4DY2heSI0l+CA
	UvYc1xa90V+tqqiGJy0RnYsY66dLW02zEAXZiVhVikS++kkL9DrhyzLHZ5GPJlBCgAeSzn
	BWFqqQ+weUmD6Aas861i5g/T4jCcbNI=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7636c96b9aso1028332866b.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765996239; x=1766601039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1buhmUPjbOGX8r4QI/9iXCbU44ejW/6DARhRE4VyVi4=;
        b=ARUaDjU+JARQ1XZ3Q7ZL1mcwQAcLC20QaNjaWOEFYjgpXETbx5O4uVIHbrp095lpkF
         cPmETJeBZCRNnQXKb7/s4PmIBzIoZDq9IwXdGTk9CBWUbzfnADIgOaF8abQsDAB6boh/
         9694klHDfn6tqBkHmdEZMIVhZ10IQDorusMupiClkA8dPw9MNgxIkkuzsG5XHvXJZpmv
         nA5Pvu4j5btZ+dJKwlj+urE2I43cw93sJMxO6F0PH/46BEP+JpF4jX234dQGqO5Jt2cb
         XwrdGXsZ6bf0RJRhMo8Cpciu6qCwJbluPZgkyDxjCKqJOK+lQrHBzF6y9NpIPboVrYRh
         ZC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765996239; x=1766601039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1buhmUPjbOGX8r4QI/9iXCbU44ejW/6DARhRE4VyVi4=;
        b=aEH8pTGrCA4LiLXbO6nhLhWEVefcSZCD7gSfw/UuVqpOuzigxTPPjODcyyWTg4lKvo
         7gHFMVlGgjMl9YjdmwAXUJX3jK7VD9gjsJ6qzAR+By0hbfxfDlqZqfH5bFgvqFs38xc5
         oOcyA6/T4+Ffy9o750+0EmUvYBZyCP7Gg2f1PRsfwmxQZBrPhhRbnWdkJkQ3JodgafDM
         cdlw3mn8oLoUeZzQEZObrbjaTYw5sGRe+mWbRpzOLRGHWx6DDEyyLq5Xw9U5asieWhtK
         aT3ajsOfBX3u0TXLhFEDT9xraxOHo+gU+z2C4q37gF5JVL/Gw31mEUSRcnKKbVnYX56C
         xCHA==
X-Gm-Message-State: AOJu0Yzh/07TxwlNIuNvEld4ZvbosAhOoGOovIQ3JdoLv768mBI4D5En
	DYeikjfOl1jO31pansEEV5oqtOg3HRpGwM4MWcdfve83qo2YZ4JTtpMI275jLlvqPRyoqduL+cV
	YVQX8aN6pSz96gvJHG1DZGDb/R14vkmY=
X-Gm-Gg: AY/fxX4ZgPnd7TfjY3D2o+UEBBcvQHNqJ7qQTdomFB+ueaKO5BDh6jtCkt7IjouWTzV
	W1yWu/l+3gc9aEUsDtYaua27zNF8S5/hVi3zDV34Hj9hYHn+4qju4E0+vRMLW7yt93X6GP0m66T
	cdA2VEv4WWKg27w888LhzZFsnDx+n+3M5xey1ZJRi2YucDtZfsKisZhvlOLptjJm+7+As8yKWfY
	QPEkKxWRWkWmCGAzq3ClWf7N9yQBzgbK19j29dig3fgmnrMme0/ruWBcmox+L3d+AQb+uTlsvJZ
	QRFnTm09vTHwhBIQoLPf6Hquq5Vx1keCeUS5Og==
X-Google-Smtp-Source: AGHT+IFW/pYtmmcQQaOZxFqibgVR/ccCriZPwTGuHo07YhcPgpCxbBcPA0t8qfLXeMxIZ/xyVwaB0o31/yhWgB39Shs=
X-Received: by 2002:a17:907:2d0a:b0:b73:6f8c:6127 with SMTP id
 a640c23a62f3a-b7d2356b67amr1980761766b.12.1765996238768; Wed, 17 Dec 2025
 10:30:38 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com> <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
 <CAMgjq7AKe09wKEeD9uf5_EuLBLMRoV=Rt+Vp0PU9-b5Jmp+1TQ@mail.gmail.com> <aUKQ7dke3uf9ud6W@MiWiFi-R3L-srv>
In-Reply-To: <aUKQ7dke3uf9ud6W@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 18 Dec 2025 02:30:01 +0800
X-Gm-Features: AQt7F2p7T17qCo9oAb_ne1A0Os6ZSj-oyGR-WnmwcPfe8P85nG0YOyDn8UaFxgc
Message-ID: <CAMgjq7D4xa+UpGfwP-Ji1HEoxB1=iaPzypGHL+hozwPW6v6tPQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/19] mm, swap: consolidate cluster reclaim and
 usability check
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9D7940014
X-Stat-Signature: 163raafnqhxe8oqsbwh1mfef1y8ufynq
X-Rspam-User: 
X-HE-Tag: 1765996240-595605
X-HE-Meta: U2FsdGVkX1+NSxZRAtW0XIVcOxm+blxm3/sa/AIVxBnS6BObpLAnxEmxkzasZ37zOY9yJ9Kvf/0sngVzdUkkAZmqaKxiLPbf6eJp8LH5bCKDLAu+CMT6J1a8QFK7vZ+KLXOD4K9afKEqbWKKZqHssCKvbBpYbciisoitKfAgXvD3FxTOvgzjK0+iG6S9AieOFH6oxrYzq9bF+cfiqEb8pl4OuVlWiLx3c/cJLjPXo7liK1TsKKLEDpfAmyjk08XzNZXtewEGs642Gb7j7TLtCg3l437WjQifx/57MxGTyxgqNDxLOIvqxVL0ns8Dn/aCRVXw36XZpnguSLtJfTcVAjA9f2W1rH25NORMToVGFUavzJzpR+4Fh0sw1oM7fglhzm7aGR97mxZgv2TdnB68Zm5qN2GzfWiKFACE8j9z6AJrt/qb8poN71IGV3j0TG1cNggAg3NBeMFbF8v/y0j6RKBLgJVA9yrEE2tMbmLOTob9rBhWhe4+4fuyRiz+fu2pnXdsBVXkKzRrnZW6mu5tFURlvoB/BlNex2vo1OpGwUQ6beNkrVtaiYQFFXAW+DEBA49diOWTf7dTXwL3yLsND7WFi9GQ50bw4ociuY3eXnplWZFryhLMv4wWBxpcKULOj0DFGf0umwfa/DFHpIghVy0Ua1P3wDlc4VbXUfYy6RLsgkWUHZo7r69gANhSydayPA4aa7wRXx/zjujiwCg+LHAFBs7u9QsKBRqvwkfyvl/zOgDQrKa4JeGW/SmdhTSTopKYDYx6LzT+Lm7dK0cntZBl7eBEzjW3kydIlJSjcHHd2M/yTb8QhzuGCFNc1J2x88btKA+COtqM4p/5VkAyeUbH9D38U02CuatK/8QwOx25oOnh1z47Eg6RYmcn3LwqiDz6Wfi90VuU/XCU6mPRy5doahdKhEqGlR/tlFx4G2em224ZuKliTae8XaIGJ1l5rUGUbPSsWCIofueTBW2
 g3DNPuQ6
 ZAO0kwCZEc5sM6QwUJmhk5jPoLRhIUIMoOhlbUO/HmbQfDGlw7e2qa3TtIjf9jk0aGgNcsMAEzgN9TfKzKX26WQPxglucSa1b0xRzzE8F1j045aRlmaOYHslXa0MU6RPF+gJdsOFCfXgHWtzWCkyEUWB19nV6cewmOZGqHmFlR2AkUxr4LwnzKvfxl8hb/DPF9BARsdE7i9/bhXsEM8bBrgZjveAeqzLUVzC7/EndFGni9C5YZs929sNXVdQ148i/+wcGFhcUH+Et3jNWi2+7ykcPT0cp8daOT7y0q0PHJ3iGflnCpzoL3avfA9086h/jqaUUbGbvC62GjNVdrw9hkHv40thzPawic4BzIamb0Ge/hJwJfjQ7gDpyxAuXqje4stcYYoYgrudp/IjKdLFVg3d4JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 7:16=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/15/25 at 12:38pm, Kairui Song wrote:
> > On Mon, Dec 15, 2025 at 12:13=E2=80=AFPM Baoquan He <bhe@redhat.com> wr=
ote:
> > >
> > > On 12/05/25 at 03:29am, Kairui Song wrote:
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > Swap cluster cache reclaim requires releasing the lock, so the clus=
ter
> > > > may become unusable after the reclaim. To prepare for checking swap
> > > > cache using the swap table directly, consolidate the swap cluster
> > > > reclaim and the check logic.
> > > >
> > > > We will want to avoid touching the cluster's data completely with t=
he
> > >      ~~~~~~~~
> > >     'want to' means 'will'?
> >
> > Sorry about my english, I mean in the following commit, we need to
> > avoid accessing the cluster's table (ci->table)  when the cluster is
> > empty, so the reclaim helper need to check cluster status before
> > accessing it.
>
> Got it, I could be wrong. Please ignore this nit pick unless any english
> native speaker raise concern on this.
>
> >
> > >
> > > > swap table, to avoid RCU overhead here. And by moving the cluster u=
sable
> > > > check into the reclaim helper, it will also help avoid a redundant =
scan of
> > > > the slots if the cluster is no longer usable, and we will want to a=
void
> > >                                                        ~~~~~~~~~~~~
> > >                                                         this place to=
o.
> > > > touching the cluster.
> > > >
> > > > Also, adjust it very slightly while at it: always scan the whole re=
gion
> > > > during reclaim, don't skip slots covered by a reclaimed folio. Beca=
use
> > > > the reclaim is lockless, it's possible that new cache lands at any =
time.
> > > > And for allocation, we want all caches to be reclaimed to avoid
> > > > fragmentation. Besides, if the scan offset is not aligned with the =
size
> > > > of the reclaimed folio, we might skip some existing cache and fail =
the
> > > > reclaim unexpectedly.
> > > >
> > > > There should be no observable behavior change. It might slightly im=
prove
> > > > the fragmentation issue or performance.
> > > >
> > > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > > ---
> > > >  mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
> > > >  1 file changed, 29 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index 5a766d4fcaa5..2703dfafc632 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct=
 swap_cluster_info *cluster_info,
> > > >       return 0;
> > > >  }
> > > >
> > > > +/*
> > > > + * Reclaim drops the ci lock, so the cluster may become unusable (=
freed or
> > > > + * stolen by a lower order). @usable will be set to false if that =
happens.
> > > > + */
> > > >  static bool cluster_reclaim_range(struct swap_info_struct *si,
> > > >                                 struct swap_cluster_info *ci,
> > > > -                               unsigned long start, unsigned long =
end)
> > > > +                               unsigned long start, unsigned int o=
rder,
> > > > +                               bool *usable)
> > > >  {
> > > > +     unsigned int nr_pages =3D 1 << order;
> > > > +     unsigned long offset =3D start, end =3D start + nr_pages;
> > > >       unsigned char *map =3D si->swap_map;
> > > > -     unsigned long offset =3D start;
> > > >       int nr_reclaim;
> > > >
> > > >       spin_unlock(&ci->lock);
> > > >       do {
> > > >               switch (READ_ONCE(map[offset])) {
> > > >               case 0:
> > > > -                     offset++;
> > > >                       break;
> > > >               case SWAP_HAS_CACHE:
> > > >                       nr_reclaim =3D __try_to_reclaim_swap(si, offs=
et, TTRS_ANYWAY);
> > > > -                     if (nr_reclaim > 0)
> > > > -                             offset +=3D nr_reclaim;
> > > > -                     else
> > > > +                     if (nr_reclaim < 0)
> > > >                               goto out;
> > > >                       break;
> > > >               default:
> > > >                       goto out;
> > > >               }
> > > > -     } while (offset < end);
> > > > +     } while (++offset < end);
> > >                  ~~~~~ '++offset' is conflicting with nr_reclaim
> > >                  returned from __try_to_reclaim_swap(). can you expla=
in?
> >
> > What do you mean conflicting? If (nr_reclaim < 0), reclaim failed,
> > this loop ends. If (nr_reclaim =3D=3D 0), the slot is likely concurrent=
ly
> > freed so the loop should just continue to iterate & reclaim to ensure
> > all slots are freed. If nr_reclaim > 0, the reclaim just freed a folio
> > of nr_reclaim pages. We can round up by nr_reclaim to skip the slots
> > that were occupied by the folio, but note here we are not locking the
> > ci so there could be new folios landing in that range. Just keep
> > iterating the reclaim seems still a good option and that makes the
> > code simpler, and in practice maybe faster as there are less branches
> > and calculations involved.
>
> I see now. The 'conflicting' may be not precise. I didn't understand
> this because __try_to_reclaim_swap() is called in several places, and
> all of them have the same situation about lock releasing and retaking
> on ci->lock around __try_to_reclaim_swap(). As you said, we may need
> refactor __try_to_reclaim_swap() and make change in all those places.

It's a bit different, other callers of __try_to_reclaim_swap are just
best effort try to reclaim a slot's swap cache, because ultimately the
allocator will reclaim the slot if needed anyway. But here, it is the
allocator doing the reclaim, so we want precisely every slot to be
cleaned.

Avoid the align /round_up also make the code a bit cleaner.

