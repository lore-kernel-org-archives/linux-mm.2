Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D32CFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 07:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598086B0010; Sat, 29 Nov 2025 02:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5487A6B0011; Sat, 29 Nov 2025 02:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485AA6B0012; Sat, 29 Nov 2025 02:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396CC6B0010
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:55:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02AB7160903
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:55:34 +0000 (UTC)
X-FDA: 84162885030.15.9428AD5
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14C30140014
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:55:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bGVHKO/t";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764402933; a=rsa-sha256;
	cv=none;
	b=r/rzD+kcdQcGrP8IqkpKWuA7CS/v6lccwnEYDkUTz1QGoBbhO8IS8hUtPjAlWNW3umXndH
	o0WjJCNXK+krLqLcQchm0mgoi9vg4eVTRspyUP7A7Cm6YbsPEAA2yAcGDnXatCDfQ+SXus
	trlK+4R5L1trieLm0LwSSVNCAeEiq0Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bGVHKO/t";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764402933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBQqhmHJTs/pOM3JdYt2pHx71Fify0w3s6d6Jrxssck=;
	b=DCt1FwqQfG8kY6vzYxOdJJb2lwGS4wrLAjGUUuCyabVge94PJlCcKWGsRd/LsHns83MDzD
	eML5a76OM7J+iirN614XTMKiH2hAsxNis6eERGhmTIs4X57PrEuCXY5vlx/QyuON6wBcCm
	O6t+TYvvohfaoBaFlnzUymtpKbDDda4=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88267973e5cso13416996d6.3
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 23:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764402932; x=1765007732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBQqhmHJTs/pOM3JdYt2pHx71Fify0w3s6d6Jrxssck=;
        b=bGVHKO/tK/2B6Ptc5W4oGabiYSVbxNMJrjUxTVmbq75euwBNJuJ43oZcZvzhE1+sds
         zQLlXvR8dBDAUec/+mcfoWhQHeo8oekFqHmdPQkSbiW5cEnKiw64upqia43ZF2kj5L24
         N54IPH3ckqhKieWhKdDYXzDvEZFnoos7ZvO4nZgQYDALqeNXr8XzCzb3TPZ9XzT742QO
         /FuDzqip2RdXHm++Byfk3VLTBVTuZLRYmzYQRONKTvwStyfL8PLmjS0ox02dy1WlwJiV
         r6LO2+fS6HsWut88/3gPufinNYhznGF2ICT9zwao4Psej5r+boRdjlfUle5z1CRsksLA
         BqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764402932; x=1765007732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dBQqhmHJTs/pOM3JdYt2pHx71Fify0w3s6d6Jrxssck=;
        b=jSaf2TuTA5veoXFOr+8iFZM9xVbCyhwJA8r0AQHKSa9aKiEx/gzu68pQyQrOonr2b4
         uRvxuj+Glun+hiCvhKK1rtImv+InR1JVYvW7SOgheUoTX4iRjawtLA42msp3md13MXcJ
         r/6gxchhwClDAHfscuN6yJk8D4/LbrDmkQlD8+BKe8DcK25d0Uv3uWXN3vPeYQaH+Q9l
         nVOmoyKkp+5Af6O5FSR2sBzf+mZye6s+WHN0q4F40MwVd8VhyZ7GME7U7xC1qNkWOzcI
         EFc8SutYhrI9jMbPHJ+dwTiDOAxBimqfu2F5BiqgkEIzFgKHKWYZUGD0unNvkBYbdNnu
         /jYA==
X-Forwarded-Encrypted: i=1; AJvYcCXgtUxTH5qFnRvzc8YcWcoyBr+QIPXKB/NJHJ/DqzrgAbEO1q45G3FZ5HWTfFLiGPtqBRQWlj4mvg==@kvack.org
X-Gm-Message-State: AOJu0YzgpdxqXzIRhG6VCL5R70QqRf0p2eXTTWAK/du4zkRWjVDtwujy
	0G5fgGF5U0xLs6sw2uijJ/LBpebsBA9LDJuu/VoWiPOzHlRguy0BVVd+IgEVFqnaLrdW7V9HaVr
	eu/4jY5w3sfGPK08IQIKO3nS9DtQEZKs=
X-Gm-Gg: ASbGncsz4f2KU//lMjtAgJyS/fIHJe+rIgjDLbsmI0mT7GChgLQKUHPS+/UuqfyNHKf
	EJVvx9GQRqWiqGfGxqAveTi5zXFjMepRylDLFayUT9s9zLh49sGJU83fMcYtWGHvjSvFYHC+pLl
	g64drG7Go/xxBtRezcZvdoB8plhzTX60y6eHdL4Ew6G/ldLCYErNR9Hn5GIe7T/3HxEPaTS9ZZm
	geVEu6K84dzod30qxB2sWQiqe9WARw1Obe0NkgSgP3YJHfAFdnUnksduUJhWaX/Usahiw==
X-Google-Smtp-Source: AGHT+IF+I6xjfJf5oC9VEUgTTZRGw6jVmXFbWq8tWof1c5G/X0Mj9hLXrXNYKmY0glTfocJC+wEi3S35EQjmmA8b/7Q=
X-Received: by 2002:a05:6214:2aa5:b0:880:54eb:f66d with SMTP id
 6a1803df08f44-8863af04b55mr288372676d6.30.1764402931841; Fri, 28 Nov 2025
 23:55:31 -0800 (PST)
MIME-Version: 1.0
References: <780ded63aca04eb513d6e7e2c8862e6972b84b45.1764297987.git.zhanghongru@xiaomi.com>
 <20251128120328.8693-1-zhongjinji@honor.com> <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
In-Reply-To: <CAGsJ_4xtc7ipFKYNQkGa-dSn7C8S7-J8LURqYrehfgenfPT=+w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 15:55:19 +0800
X-Gm-Features: AWmQ_bmpHriWyn0rWPjwHIUpliLe1HkWR9zvYLmN9RWhtFo3ARY4Kb9MeFNyeHg
Message-ID: <CAGsJ_4wUQdQyB_3y0Buf3uG34hvgpMAP3qHHwJM3=R01RJOuvw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/vmstat: get fragmentation statistics from
 per-migragetype count
To: zhongjinji <zhongjinji@honor.com>
Cc: zhanghongru06@gmail.com, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, jackmanb@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	rppt@kernel.org, surenb@google.com, vbabka@suse.cz, weixugc@google.com, 
	yuanchu@google.com, zhanghongru@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14C30140014
X-Stat-Signature: csd6yks9umek58tu3gygqidjwz7w1yr8
X-Rspam-User: 
X-HE-Tag: 1764402932-272843
X-HE-Meta: U2FsdGVkX182HCmKaSkhhfYeDYwgRFfZdEIgOEoKy5iS5A8OA+shYsO019clfe/l1Ug0ybMgJAFK/rABRPNwxhxgn5po1VgfqrziOYM8HmpiMKE5+6Yr+fJ8hWMKkFrSJhlNqbHMzporvELh4e2Otur1KNTyFMnjQDwP0MOT3XLQVwG6J6jt26qZG31x3M0giBlbo7LORN2vf82jOl5+JYPW+0Lrip7c6pSHGgAyB4qoX+dHAQK/Gck1Jvr/EnDX5+FQrClaK1QxB6ACwCEJy90gyc7WJciKfrnkx3gdEBlJIoZEeu3U128SqyrDzgHAs1cIQTZ/GpBmFhrWIJlkZ0fkIl6XOUUEP4Y5VFZWWw4FAEY+GXfHByN9CTPJOJXXkbJQwnm+HizFFPjv1RMe7iGkqigshD0D6Y0kfnIsqh10QgqT8/q/T0hkO7leQh6mg7iVePWyXaYnKdY0HCJD3hK4hL5PQO9s2JRVrJWilc6ynKuceY3IIJIWH1SyXnMdzLAfoe4We6GJDA3zRSZsX+6qbRLwO8laW/Se0H9sYXgVoqyxDvusDClTmDRKkgvmz8XwcV26cO/UbLqTSim8nObXmCMg1xDVzRnTVw+lh/OwJqsirA6egVPDO4Y7EdZfROHFJYB2KTWXpHFHiP1/2X5r9N6W6Ny71/hl6uryecP9N+FCyHaiLSOpZ8g5Df6bkYnUIPMZR0xfSzTZ1jX2mmVNzJoLwQt5FOE+8f9FulVjk9Xkt5mTg/mhFtm826FUidL4AW4EKElXej8nwongZd6mBnbXyD7ys8d1Fad+qRenS3ZebqRkPnI2gsi96xK5yCL+41I52kXQgiK7Ok5dW8fFIJxGqshNggBITWCtRc9VKSSbXDLtjVm+9l2hGGFGPac3dHJzvoyTAjQM0y3NG667eKQzvzaVQiR860stxZgT+g2WVsh3tHYVeUu57DTU/jM028BK6KheDm48qhW
 7YK47Z22
 JD0otqZa/7pr8EL8WyQ9ejP1zVKHXznv76d8y3YYeTKGEZHXb7f2+0/Ac7wUZaxy3S8Epxe9bo3LZjfm13ow/sw66P+G4Bnco4Bm9gsMU1rZuIOzVLYS2BDqTdiQcvMrqJGWthSZi5mbjdDv2/r7OXp4HBW/7Z25RDUMXg5iSgD3sXzlfgfJCZMy4QUpqK1jkk169wcz81CtqYM/DNTQNRURfbJtDLQgt/fV2Jv0IJIwaPVOdZek+gZXnGSfkehIlheCZU57ptDpBmySqakDF0COLQRNLQq2T3C4fWfWZeTvCDq7MB8HVPp9PY9ZN9g7RcH+lp5+pidCmxbmGLlhBVaruCMOD1jdrs2KE5UB/XhpamZNOkW5x4CjWtTgZPOL1SUlrqJ6lGjS9ZVJUm2hhbZR+r5zXC8op3FSJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 8:00=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > >       if (order >=3D pageblock_order && !is_migrate_isolate(migratety=
pe))
> > >               __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_p=
ages);
> > > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > > index bb09c032eecf..9334bbbe1e16 100644
> > > --- a/mm/vmstat.c
> > > +++ b/mm/vmstat.c
> > > @@ -1590,32 +1590,16 @@ static void pagetypeinfo_showfree_print(struc=
t seq_file *m,
> > >                                       zone->name,
> > >                                       migratetype_names[mtype]);
> > >               for (order =3D 0; order < NR_PAGE_ORDERS; ++order) {
> > > -                     unsigned long freecount =3D 0;
> > > -                     struct free_area *area;
> > > -                     struct list_head *curr;
> > > +                     unsigned long freecount;
> > >                       bool overflow =3D false;
> > >
> > > -                     area =3D &(zone->free_area[order]);
> > > -
> > > -                     list_for_each(curr, &area->free_list[mtype]) {
> > > -                             /*
> > > -                              * Cap the free_list iteration because =
it might
> > > -                              * be really large and we are under a s=
pinlock
> > > -                              * so a long time spent here could trig=
ger a
> > > -                              * hard lockup detector. Anyway this is=
 a
> > > -                              * debugging tool so knowing there is a=
 handful
> > > -                              * of pages of this order should be mor=
e than
> > > -                              * sufficient.
> > > -                              */
> > > -                             if (++freecount >=3D 100000) {
> > > -                                     overflow =3D true;
> > > -                                     break;
> > > -                             }
> > > +                     /* Keep the same output format for user-space t=
ools compatibility */
> > > +                     freecount =3D READ_ONCE(zone->free_area[order].=
mt_nr_free[mtype]);
> >
> > I think it might be better for using an array of size NR_PAGE_ORDERS to=
 store
> > the free count for each order. Like the code below.
>
> Right. If we want the freecount to accurately reflect the current system
> state, we still need to take the zone lock.
>
> Multiple independent WRITE_ONCE and READ_ONCE operations do not guarantee
> correctness. They may ensure single-copy atomicity per access, but not fo=
r the
> overall result.

On second thought, the original code releases and re-acquires the spinlock
for each order, so cross-variable consistency may not be a real issue.
Adding data_race() to silence KCSAN warnings should be sufficient=EF=BC=9F
I mean something like the following.

@@ -843,8 +842,8 @@ static inline void move_to_free_list(struct page
*page, struct zone *zone,
                     get_pageblock_migratetype(page), old_mt, nr_pages);

        list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
-       WRITE_ONCE(area->mt_nr_free[old_mt], area->mt_nr_free[old_mt] - 1);
-       WRITE_ONCE(area->mt_nr_free[new_mt], area->mt_nr_free[new_mt] + 1);
+       area->mt_nr_free[old_mt]--;
+       area->mt_nr_free[new_mt]++;

        account_freepages(zone, -nr_pages, old_mt);
        account_freepages(zone, nr_pages, new_mt);
@@ -875,8 +874,7 @@ static inline void
__del_page_from_free_list(struct page *page, struct zone *zon
        __ClearPageBuddy(page);
        set_page_private(page, 0);
        area->nr_free--;
-       WRITE_ONCE(area->mt_nr_free[migratetype],
-               area->mt_nr_free[migratetype] - 1);
+       area->mt_nr_free[migratetype]--;

        if (order >=3D pageblock_order && !is_migrate_isolate(migratetype))
                __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages=
);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7e1e931eb209..d74004eb8c4d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1599,7 +1599,7 @@ static void pagetypeinfo_showfree_print(struct
seq_file *m,
                        bool overflow =3D false;

                        /* Keep the same output format for user-space
tools compatibility */
-                       freecount =3D
READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);
+                       freecount =3D
data_race(zone->free_area[order].mt_nr_free[mtype]);
                        if (freecount >=3D 100000) {
                                overflow =3D true;
                                freecount =3D 100000;

Thanks
Barry

