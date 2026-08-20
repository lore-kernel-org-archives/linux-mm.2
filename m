Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395AFC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119696B008C; Thu, 20 Aug 2026 02:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA7F6B0092; Thu, 20 Aug 2026 02:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC3C6B0095; Thu, 20 Aug 2026 02:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B86766B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:47:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A88616064B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:47:42 +0000 (UTC)
X-FDA: 85120717164.18.F74FA43
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56D21A0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:47:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LvQMWqQC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787208460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZT953IJ1HUg7d/Ae8psBl3n0+S/WdJEX4U2y3Val+0=;
	b=j+EIqfRKbeW7teTp1Avm1dc71cjJncyRGMW3CddLIRsfMDU1xxz/hiXaf7P9w1GLbEOjDk
	Lzjr/NcqZHWsS/qMBh9tRUopFJjgwO2LfzbHA8vnUL+O3JuqG6o//17JMxZ6anFuwsSfVQ
	obhAtAg03m8UCUZ0pkaE1XNXL8RuZmQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LvQMWqQC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787208460;
	b=06JzOmOLdoJ/alAo30OKIXWexfns2xxaY7oKr9EkfRA2jHWI7PPE+98T95pF/xYUBsmNqL
	MeO6gXE0XkXvWzbg+mXUxw1VnQuw2l/ZvhOHbmIa1dKiZ0iojf8M5a0eCKe73FMvnzAlvs
	CJ9XMLX0IvrBVZXxfISo/ln/ujFLrfI=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c1671ec8692so277747666b.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:47:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787208459; cv=none;
        d=google.com; s=arc-20260327;
        b=rARmpu3r+hKW4JPjNK7ddg5tztAOgFFpsLKLEv+n3rmyCUR1cQx42Psrnp7gG+H/ZS
         CzD2daGZCHKb/rSK9tXoFFpgSrHFVTdtP4KIyFvaxXOwDHLmM/krC4hXhHXECzmNU+6p
         Fz81SJsirj4yafVPZDjMX2se7YHIgAGsobM3KQaeraszcmr0JzaZyczWJ9Pst5TLrHBP
         Ee3Cj1z7IaSe1y2bKfPPZR+UChiA2DGekUaKlu/6z3Zerz1mzNbhK02CdSUlOO5WVYpr
         lQgx6sT+MySq3k4I7Kttvxy6PFCzO70LpwgJbJ+FVWAlq/wjl4lKgqpWu/x+HgSVVjk3
         /ggA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WZT953IJ1HUg7d/Ae8psBl3n0+S/WdJEX4U2y3Val+0=;
        fh=zSqwoe9TDW+vLpRbTLVJT0aySUskQcMP6Rymw9YBM/s=;
        b=cFXwxHNfSUTd689i811DMLc4HgMP5jQJ6ikNHfuWQSCu7dmtz77vx1W8vyPawvu6uC
         dVYoe/j4DUC22hi8GlUOH1Au/lVhU2Xh6uCfRJDcvJbOwbyJIReM3zzQvVAmz4xdQ5CF
         kc4EPvIoSrL+xXAsa+FvmSZrJ9JmxjKgYLaUG94fgkGvt5V3AVEe2WJZV48x7MjUJCo5
         dp00h6HtDBbFLFlGP4OzhCqHaK8ybd0IhXnOxmSCCDc4hzQ8PDnJbf+vsx4tDPWinuzY
         XIEzYajQS989W7hhnSriTzmKArRRqFOyHJi73Duofnc8q7FFZDhnV0tLSTQQFsDJluL4
         SDew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787208459; x=1787813259; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WZT953IJ1HUg7d/Ae8psBl3n0+S/WdJEX4U2y3Val+0=;
        b=LvQMWqQC1BjlQHlyCk/CY6I3Auwzv9+dRfoq5OB7OCSy0GRxnppq0d/JOtjKfaxMP6
         Ltjx4x0S8yBTjq/Y20ZKNBjIa+cuKab5BEa7tnD5/KEBCmk77RL17rvb6bkxhmpTGZ+D
         wd1jNXSRh15OiTLDeKWRA0Y1PFafAlnNbWPjbILbywktgoXdfkf28K9CF0BH4L58aV/V
         mI1C/i9kBY/3srkfFqZcKcAIxT5ce/xuVz95cqVvZcDq1eEaMFG+3FxYzQNvJ13e655l
         aZn3nYJ009DsPB49oJwqP7GfyqqVOCgtUDGMYHRaI8VF3Lb74V19eu7DZrjPTv8im7wO
         9TwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787208459; x=1787813259;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WZT953IJ1HUg7d/Ae8psBl3n0+S/WdJEX4U2y3Val+0=;
        b=TsNR8ke3TwriUmoj4WwdrIlNmlVvvvy0vAHpAwXXh6YSMZrT8C4pzDLyqwqdvQBJFL
         3Np4S1FP/nEG/T+Kv8OX+LJ2ZL4v/LrX1HrG0/lJBEjouorSCgvnommBEMcZyE3YRziX
         MnUWPanHL65NByFhY5XLmgModjH1VEXg+SS+jecAnKBjrBLC4C5SQaHuXSobHqNKe5a2
         K6nP2Ip/hpiE17aOOlUrOd/aDRLaZ1ODxASTEtB/35aV3NWZk7gTEEOy+qpmJhvr4eki
         MkCBn5VHLwmJY4h4gilVvc8o0SCccDkGXvBnx7fwZoDI96+nowi/3R93LePa5XpGtjXG
         Bt8g==
X-Gm-Message-State: AOJu0YyZD/stgDLXeYeW2cBmwWD0NJTVci55FtEECpl8rS6ZnUnpUwUn
	gW4XQdi0OcbAbldQxWwumlUKItx4CLterFg6THyQq5mjUPxOkD49WSp5j/5NjAeIBRdkoGpX4Vx
	+kfOqq/14b5Tkz0Qk7349geE9VjALa3o=
X-Gm-Gg: AR+sD131RlVPIkeeB2QhbELrWnou8+WU1yB6NlQrOw2n+uCf5jwfj93G1lvoQ0qCWa0
	lUVIEJiQox5fM1odZFFili9A8GyxItvKNxKTRj6PKCbaibTNqKr3igxstG/4hFodn5ipig2vNJz
	/PrlO0svNRaNQ9Xh2GJXdq5tpV8D2zHMwqEVFVaV26woMz91Ylg36v7SIE3VClPjG6xXY8vZ5+b
	nBP0HZtt3Kc/Uz5Z56/cD6Muhz8ph+Lr9I1dJkZ6mYN+Y07HOLcnJvDua4infmXPQm6opWtDQu2
	WC00WU8PiU0VSwJYxxt7K4MBZYtpeIX0Juhyg31yfMg9bjTGSlPgw26f0WIdCHAjv8TnTMVI3FI
	scjZ3Qg==
X-Received: by 2002:a17:907:c80f:b0:c19:45e3:2f57 with SMTP id
 a640c23a62f3a-c23f9766ad3mr790220866b.9.1787208458596; Wed, 19 Aug 2026
 23:47:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
 <20260813-swap-thp-cleanup-v2-4-d2ee48c6aa49@tencent.com> <CAMgjq7DD=xZutuKuL8+zVnBAaWMO2DHi9kbvHzXaDPZ4JLqt+Q@mail.gmail.com>
 <DKP62VXU37II.ATZ38Y3PAIE2@nvidia.com>
In-Reply-To: <DKP62VXU37II.ATZ38Y3PAIE2@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 14:47:01 +0800
X-Gm-Features: AcwNN1XsKKWQxykyNaBUKK6Z8AA9vCasWOCLR-Yrc4WvYDrv0F35jYm5N0KSosk
Message-ID: <CAMgjq7B6tQvFkQ1eJPeNFcW+H+QRnGBw+hrtkyhgvcCyos_t1Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: okwwbamtwgea97a1zgf5wqhfgzbk8p6q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56D21A0006
X-HE-Tag: 1787208460-912310
X-HE-Meta: U2FsdGVkX1+fcELTJ39Ux7N37sSu5NerNFD9xNWsODzK+bODBNriOolgjT/GqFYQSaFlwG6cM7eS1AK4FfIIyoPTP0fXnXNooEY4xBgc0eoX6oMXrA6Xs4VVyZtUZi++/cZMhXY7VrYeIIlJSOOhiCupdE/Gu0DDyd2oiYfVhTkBYhelmTrAgMruH+uKGXYFrrZ8/+EXjHlAYHcZoTmsL7g1EiUqWMDsU1KAQaTT+JxKDPNKVO0/QhG/PDDPTzvIi0PkV6kNSMMm3z0esKr/nGhtO/kksvcsG9V05vJTKOGDKmbpe5J5xg22Q2YByu0ekrjxi4c34wXTGvBY4IJ60L/FA5BT3e5NYGyOvBAwRPWQubP7ou8euNzIFqFN8ey/1AUjvJ972O7eTjHXq7NxLgV4Yp9vbAWxmFm/8QlpeFp6q8iPqgsEAqQvlvzzvrehQES/lIF0rbX1lplZnoJo7j0Kf6Mjhst4tP6XaZGd/vIRw0HwHdF6QOvPvYnThk/4CBKHwtYB+KhId7Ob4D1tsOLepFUg5PtuJAEM8GCm1HHTsVsiVm+1jEwFp5wuXJbEvSwxiDyawXLAQIMDW63Sqe2wkEmr2VCa6coRGPmaUNvdn1tMzAYWijHNOSkH5Lz4UzSglvYlJI53vSGVKEQtM68p+gmZYSNsDcIlaFXZAgkorWi9fd3N9Y32qCp7UNw3QoXBJPDmKMdLMkbD133X3YzHahGwGRpPzoqRZWooLNaneVSBl8I5YexQykN7RJHZR3V5/+3Dbs/SjG8K4Y0N5vM4bnh9zX7arrQCHnz5zLSswQDt9+LYSQeKnOmYOOCv+wVaeuTOhZJ2PB1z9dP0e66nYIJbO+dkdGzGAC0tG4ijBZJbikB04LKSAqnpq67rk9WZuROmEI18ObnzP0CyvilOmmjDeR+abTnorv3RpJ2P7MNrtVE7NQcAfcL4OtZxiV5FnFaEWz8GsjvHArN
 9Z41AOuV
 gO6FLuI9Iihd/+QRRb+29dvIEt9km1FfqoPbcwb1K4F8EeZtkbIVAG9F86IB1PjcbmA7C+j5ZbSA7yk1U6Uimq23LI64K2pcrGcT+kf0qMnJBw06c85gMyqzgV2TRdq+LO3/gdFLGUKenChB29LU0t+TCJ2cVbtvJSd0d2riY/2H6UeJkE3TE3KjJsB/oPqjNmev3AltwyZoq96IWMfx45LLjSQL9ajTlMRsm1U9Zmkjt+EqDZZGy6DMz6Lf4qWxUaB/wireK+WUM6qL9W22EbILwyCZc97YT6qX1fw6KJII5c1DTFA7uGo3ETpYQdtH0HPQC1i+DYok4XYyxePnF2IFJAZHBd9q7FHAn8MclO8VyQdOyd62qFzjQdnXO+9Sw7icK+Wc7+v59F1r6jvo4F1C3hHLx7JgZFNvN/JBEeKApdVxXa0nl2b2z7Tq8r2AUAu9qZu10iuUsClfJjnPXjCXypWXSD3vuJ486YcCeroWKZL8dL8xKlgqzvfpVFfm/rWt1B00OWjAF9X/52HxKtu+xYdgUuLvh16jCxzbafmFYnLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 10:37=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Aug 13, 2026 at 2:11 PM EDT, Kairui Song wrote:
> > Sashiko reports (a valid case this time):
> >
> > --- Patch [4]: [PATCH v2 04/17] mm/huge_memory: split the routine for
> > splitting anon and file folio ---
> > commit 249f031b2182770a8cf754edfb3833e148a033df
> > Author: Kairui Song <kasong@tencent.com>
> >
> > mm/huge_memory: split the routine for splitting anon and file folio
> >
> > No functional change intended. Before adding more logic, split
> > __folio_freeze_and_split_unmapped() into an anon and a file variant so
> > each path can evolve independently. The two paths shared little beyond
> > the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> > differed in all other per-folio bookkeeping and routines.
> >
> > While splitting, some cleanups become easy to apply, and helped drop a
> > few now-redundant checks. Also introduce a folio iteration helper to
> > avoid a common pitfall of iterating post-split sub-folios: a sub folio
> > might get freed mid-iteration as pointed out by Zi [1].
> >
> > Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia=
.com/ [1]
> >
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 7fb603ac500f6..7587eeb09e4a6 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >
> > [ ... ]
> >
> >> @@ -3634,6 +3634,18 @@ static bool page_range_has_hwpoisoned(struct pa=
ge *page, long nr_pages)
> >>   return false;
> >>  }
> >>
> >> +/**
> >> + * for_each_folio_safe - iterate over contiguous folios safe against =
folio free
> >> + * @start: the first folio to iterate
> >> + * @end: sentinel, folio_next() of the last folio to iterate
> >> + * @sub_folio: struct folio * to use as the loop cursor
> >> + * @next: struct folio * used as temporary storage
> >> + */
> >> +#define for_each_folio_safe(start, end, sub_folio, next) \
> >> + for (sub_folio =3D (start), next =3D folio_next(sub_folio); \
> >> +     sub_folio !=3D (end); \
> >> +     sub_folio =3D next, next =3D folio_next(next))
> >
> > Does this macro unconditionally dereference the sentinel pointer?
> >
> > When the loop increment step executes, it evaluates both sub_folio =3D =
next
> > and next =3D folio_next(next). If next has reached the end sentinel, ca=
lling
> > folio_next(next) will dereference the sentinel pointer to read its meta=
data.
> >
> > If the split large folio happens to be located at the end of a populate=
d
> > memory section, the sentinel pointer (end) could point to the next sect=
ion's
> > vmemmap. If that next section is unpopulated, this out-of-bounds read w=
ill
> > trigger a fatal kernel page fault.
> >
> > ---
> >
> > Right, I actually hesitated on that but forgot about it midway. I
> > think I'll just change back to the opencoded style, it's easier to
> > understand that way.
>
> Let's open code it. I also tried a similar macro when I was developing
> folio_split(), but got convinced it buys nothing.
>
> If the motivation comes my prior comment on code duplication, feel free
> to ignore that. If we over engineer it, like different function pointers
> for anon/swapcache and file, it might be doable. But that might kill
> readability.

Thanks! Let me just open code it for now. It's like just...  <10 lines
of code duplication after this series? I think that is acceptable to
make the code cleaner and lower stack usage.

