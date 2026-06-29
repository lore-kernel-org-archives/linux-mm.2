Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31F6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951866B00F5; Mon, 29 Jun 2026 14:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903376B00F6; Mon, 29 Jun 2026 14:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3D96B00FA; Mon, 29 Jun 2026 14:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 531126B00F5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:09:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA6291674EE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:09:11 +0000 (UTC)
X-FDA: 84933736902.14.1183F3E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id CFA9BC0011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:09:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oLmwSHuu;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782756549;
	b=M8q4u+OahMQiwClhC4zELcvBYOY9hkKWYRLJAcfYCarPIHwANEvzUs6W2rUv3uXXuBENb9
	N0nKl+QfwBoOb5vFH6wTeJmkvMB5wT4TbnzUIfUtB2Naf8DrMFiFoPghU19hyaaym4Hu0q
	ZQzuWUyW6eW/n5dWkVfK8hZudGKgOaU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782756549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5BN39BAWUPL0DXpa9ZBmFsdBxm9Skdfzb7mO2a9Vo8=;
	b=hRRpB1TP30u1IOUWtYJ4qRJoTVT8uBQBaJ2Ka8aarPN6HXe5QUv2lYhPb5cmwbFCcFnu3E
	0KboQfve9+R63pqZoOIrYWTZeKZddgHF63zOZlvhwytR91A5+TJkmPVO+O8FhrBXZBZC0A
	Ne4yxiEmVBzSmakifOtqiN+8YUMlKAI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oLmwSHuu;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so15024185e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782756548; cv=none;
        d=google.com; s=arc-20260327;
        b=HQW2ONAAugtC197MjOfRbpGhTuoXU+IvyBiyZXRwxyIO+wmBMxJUOdpJCOl1cBuNdB
         YBM1Z111CGnUoJsSfTnKHqA/zxBC1vhe8TqL8S95eA+Z1Opc5DyvgxXbZPKGZJxuDwNH
         tiI7siUTY3b9eT6VzrsWtbdl/drXMMstqrQhUdDw6YhZjTDVin4ZM/g5pASySzWl8v/1
         3prM8CxqnaokHtFoAQJeMQWghqI5FJVJTTNyA7DLi6leFc7S0nIiOrDpeIXjImmqmf38
         OijGsJZOQ4W42VLr5hpYMSvDKbZx4q3aX87OxTyhe1KYcNlVIDh0qVrBl9YArJETZHX2
         4PvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C5BN39BAWUPL0DXpa9ZBmFsdBxm9Skdfzb7mO2a9Vo8=;
        fh=6aBMIfXzv6XU6JUX0DStLnFr4tvuBXSWAGlN50LEnO4=;
        b=jL/lq0SrCkxG1vQXTOPWZAIMch3t0eB5OxlOMsSb0oKTWNYkcEoKpSp3lOr8wHrsYh
         yGRfWNSE3IP1Gh3eGo75kzpk33/iV8MycvsbFQKZrWrwO4PiQG1X3gPt2c/ouj3zgXDs
         rGiB4n33MQRjkXvVd30eeCxwZ0pOAW6nwyafdo83sju97OxqB2xzZwwMYAKeO4Fi8fVk
         qOWNpGsRP4A9JPKMSu6noUThWbwg0ZKm4BSkOE9TTcZ+5i8hHcLZ5LY3WwE607u1asJP
         zkX60ihJ/Cu28YMcjKBt2oLHfKXgSqLx0vE50uYnKrbSpmQyICueTHelG8TVUi7QbJ3X
         iLiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782756548; x=1783361348; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5BN39BAWUPL0DXpa9ZBmFsdBxm9Skdfzb7mO2a9Vo8=;
        b=oLmwSHuuihrdJeIhkDdqP+4XL8Bzi5z9MkgRJ3xjtodUGnuyXsZWAxYa/nfCbcZ4kI
         hlN/VUe4mcTC1zrII21g8yxHDufDvCp7GoHsfVqfNBJYutiEH9hu4cB7mECpDtUWSVFA
         Fnrn3F+x1RNks2/o6VsPcEDfSS7dEuKWzeX450EISARq8iIAQ2W5tyWX5Fk7+ELps6Gj
         wWDIIIlm2jmg/zR0g1OEeA5dQ4d6o0KbeITOULi+4+Fkej7IN0Hjr8OBd90np5N3GxqW
         a1lXyuNxmNT8bPndd1I4HMH0govd4k9dUeWecIjQq50e/FGOYpBbyh0tTaknM64UsqRV
         5ojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782756548; x=1783361348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C5BN39BAWUPL0DXpa9ZBmFsdBxm9Skdfzb7mO2a9Vo8=;
        b=e4gqRWZ40pz/4Yg32VQsBQCzUyqL1g5g9L3Vsf5etmmwHwJrZdO43IoCG2LpUX27Va
         P2dG4i6SmkO70JoxcAQU+QRj8/Q9+jyTRwAP8NMajrRFPrNuMUNvzBJ+Z1jvtdLoy9bi
         ysWkJGZvuVzZZoSsm4PX/9jkdreCJYXDOTZreLC9mdPYPTCzvSxgJSWvvTvUGl5rLKPi
         knfkJ/oAPXvbUKqd/IhYl/9vbyrEktOs/O6O0eBbdvjMP5lDjy5Vd83eTpeQ6OWlqiOf
         k+1pmWRrb3nrTomJnUnfvDki8f5wSONakS39ans9+ptCouudB+qxG/2CHNW5W9lqjQRp
         Np9A==
X-Forwarded-Encrypted: i=1; AFNElJ/uXvcsWdvHcAowz6ymfw93v2zPicRwqed2ksDiklf+HVjb6ApXnyotdwOpkcJY0D6ZBrDy7I3pRw==@kvack.org
X-Gm-Message-State: AOJu0YwXDDAHMYu1tSmF0YUFVuu/F6NgFO1C1RtvdG2Fl1LockZFRk7q
	NAXFXM8FrXzWvm45T7/F8biy8fDsmSXw1jDvjsh8p6rO2Fy97Dh21W5JcrrBw02KdzYshbouS1K
	poYJ6bZsPdHeQSODkNMom5cc2ddeSAQ0=
X-Gm-Gg: AfdE7cksOoZYtDNSzH3AhHfGdBZk/UhduUh4HTPGEoj5TSYRt5O2j75OGtlLKA19fei
	LIsJJBgnggR0uaVvHC741Izvch0aJQoD4+KS70B4JAndUmS02XaRPTkNcTYR7it3LlxApTkmfWB
	+euqcjOUYAvtLXyVEsqmYdidd993lwCYxt44xNfF0qLoJ8BOXOv+4Qx3sbfNfrnityyfG0mP3XV
	J5L7N0w76meALwmIEdoVkZMfttHboYAAall+Iy5lsdlk/HFf83l05s3bSzUiV8HOpptggS/zzD8
	TIkrnDKF+wG23tKP7/S/4qgQI0kmSvcrxeqFhTE=
X-Received: by 2002:a05:600c:524e:b0:48f:e230:29f5 with SMTP id
 5b1f17b1804b1-493b8ce540fmr3942665e9.16.1782756548138; Mon, 29 Jun 2026
 11:09:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260626102358.1603618-10-alex@ghiti.fr> <20260626143244.3382853-1-usama.arif@linux.dev>
 <CAKEwX=OKsjtStcuvhQ3WCGYoTJHT6eagBq1mZqX+DdbLm_BFLQ@mail.gmail.com> <044c3a58-7ed0-46f2-88ca-462691fd0b68@ghiti.fr>
In-Reply-To: <044c3a58-7ed0-46f2-88ca-462691fd0b68@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 29 Jun 2026 11:08:56 -0700
X-Gm-Features: AVVi8CcoJQQWpbkl9ynpS5plxoh7g9PlfXUI4G-QNEz9RykW8_jECswu4D7_5Z0
Message-ID: <CAKEwX=NU5W_NzXjEjzty2dHm09xZwLH=7SS1f9J5b8PHV2oZsg@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for zswap/zsmalloc
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>, alexandre@ghiti.fr, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Ben Segall <bsegall@google.com>, cgroups@vger.kernel.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Hildenbrand <david@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Kairui Song <kasong@tencent.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Peter Zijlstra <peterz@infradead.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8iutsh3wa77iu89n9ttprj68tfqaq4fw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFA9BC0011
X-HE-Tag: 1782756549-686838
X-HE-Meta: U2FsdGVkX18O8DS2I8fe9kXsUwYPkuJV4I3pxXDSBaXt2CNvAK0qF1nKcu6Y8EpezIpQEYIM47QkBh4RQWQvlJlDn9RNCbicopRZd3L+dF1LUo4Q7d8bbuJM/IwHiey/XQTP3QpIyC+1Ci+c3TnmrjfxPRCis/+xnnELZuupz/18nBqpzbbxTpm9CTeZC33zyk4A3MQnUtG7oiCZscXCOHcNinBDPaULzZzd+QMoi3nDv4ueq0dPSviwuWJMwVA2hz01Q0dNpbKU8KB6Sg9mBSZO6PMi7dVd5xIotlfmpj/go7ansAHL1uAbvzyezd+GFYusTQCWpf2l58u/JbW/XQ9JWpodUKufZ0u+fHmitJjWxqbn3lGvohaPAMjPdnRufnVBfGyZzW1OKEP2PokECS3AJy8L2J91+EI3ZBxYrVkUdkUpc48jf2qB03Ksitpss7biaJzEkWmQvYhljJboJlLcMSV77OiIf0g+7yWMEtO3OXvCk6lJIG+jYVzW358XgPHBmiz2RG1tGzEGPaSQkrYSLwOuR4lHiliBythJJCdHIcsWk5nC2NjOAG0zui/ZmffknC2nk4mwgEsOsh0jFJ6f8qUOzvAHXpdf1QG+A5y395xbsumIea6prkJ+e0ZjONiQnrsQ711Vp5rpmVz1RbKkhnZXI8vo6DCWye57F7IOdgs4ph9MGpwWxr2Nh5CGHrNu5cxLlq4GLo/ncrsH4bhGoZtaFQlGyxI+VoazRljkhofDemgga8GFtov8N6NncLJgPEqE+NCHj8vjxwwDDoEpSVG2xMtEk+akUKYLWtWIFnZzgCzFwpd3mbc0AoHAt6teADc1OB1aux88HWhRLEoCDgLR265SFh5KDCDnI8mXLRGvsNlZed6GCpJdPuh1bttfZCGTtmLVMBodKzVlE3iMcU7CX6C+jLqUt4eB1ZQCVnRQaClV56HnF/IjFLLy5oEW8luX6iZtZPEl2Sn
 RV+SUBI7
 pBlWnuD7aIlOHBAAGFBFHg5lB4pCbVXUWUcjHXTWljVpW5sod5hW6k1VrXP1fujDp4Gn04lMq3VVZDKmHjRy3TgHAZyab7CbT9q6UpfQIlo9o/1FP4o7/7v0wnvryK9FgIvg/BL6VqC2g55egzVDyHS5+VRstKGac7URK8Z7QXfwt2M/BXTOELWKfeB7C/FqUvB54Fdr6qh8JcVCur6+z4nz6tc1tHprRLn4W61nFq9bOOGRa/0FhBvltu5G3YjSfkFJyy3YeJDMebx9tQ8ZRck8iz4qoo5FEf2W7H70SXhrNWcDBIUqCpxnbSqkxEvlgi0bADYHiSdsI+7dTXhBqyebey5TORTqnyLUvWyhyMLVmXbCVRo6diYqft+CAcsc3uEdQjZ7J1IEF2MmInY34OiKbckV9R1P02LjrIpYO83PsDAJvPLwYq9wxbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 6:38=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Hi Nhat,
>
> On 6/26/26 20:36, Nhat Pham wrote:
> > On Fri, Jun 26, 2026 at 7:32=E2=80=AFAM Usama Arif <usama.arif@linux.de=
v> wrote:
> >> On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wro=
te:
> >>
> >>> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
> >>> accounting, attributing compressed page charges to the correct
> >>> NUMA node.
> >>>
> >>> But actually, this is incomplete because it does not correctly accoun=
t
> >>> for entries that straddle pages, those pages being possibly on 2 diff=
erent
> >>> nodes.
> >>>
> >>> This will be correctly handled by Joshua in a different series [1].
> >>>
> >>> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshu=
a.hahnjy@gmail.com/ [1]
> >>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> >>> ---
> >>>   include/linux/zsmalloc.h |  2 ++
> >>>   mm/zsmalloc.c            | 11 +++++++++++
> >>>   mm/zswap.c               | 19 ++++++++++++++++++-
> >>>   3 files changed, 31 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> >>> index 478410c880b1..30427f3fe232 100644
> >>> --- a/include/linux/zsmalloc.h
> >>> +++ b/include/linux/zsmalloc.h
> >>> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsig=
ned long handle);
> >>>   void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >>>                  void *handle_mem, size_t mem_len);
> >>>
> >>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
> >>> +
> >>>   extern const struct movable_operations zsmalloc_mops;
> >>>
> >>>   #endif
> >>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> >>> index 83f5820c45f9..17f7403ebe77 100644
> >>> --- a/mm/zsmalloc.c
> >>> +++ b/mm/zsmalloc.c
> >>> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned =
long obj)
> >>>        mod_zspage_inuse(zspage, -1);
> >>>   }
> >>>
> >>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
> >>> +{
> >>> +     unsigned long obj;
> >>> +     struct zpdesc *zpdesc;
> >>> +
> >>> +     obj =3D handle_to_obj(handle);
> >>> +     obj_to_zpdesc(obj, &zpdesc);
> >>> +     return page_to_nid(zpdesc_page(zpdesc));
> >>> +}
> >>> +EXPORT_SYMBOL(zs_handle_to_nid);
> >> Does this need the same locking as the other handle-to-zspage paths?
> >> zs_free() takes pool->lock before handle_to_obj() because zspage migra=
tion can
> >> update or move the object behind the handle. This helper does the same=
 decode
> >> without the lock, so zswap's uncharge path can race migration and char=
ge or
> >> uncharge the wrong node, or observe transient zspage state.
> >>
> > Can we just charge it to the page's node for now? Once Joshua's patch
> > series is in, we can correctly charge the node owning the data :)
>
>
> Even if this patch accounting is incorrect, it is close to reality,
> using the original page's node would give results that are really off no?

The current policy is same-node-first, i.e we prefer the same node as
the original page for the compressed data too:

https://github.com/torvalds/linux/commit/56e5a103a721d0ef139bba7ff3d3ada6c8=
217d5b

So the accuracy of this guesstimation depends on how much fallback we
had to do...

>
>
> >
> > FWIW, this is how these zswap entries are organized in the LRU too -
> > following to the OG page's node.
>
>
> Oh, we should do something about that right? Because the compressed data
> is not necessarily on the original page's node.

At initial placement? Yes, it's fixable.

But the bigger problem is on migration of a zsmalloc object. That
requires moving zswap entry from one lru list to another :) I'm not
sure what synchronization method is safe here - at minimum we need to
take the LRU locks, but what about incoming writeback, zswap load,
etc.?

>
> Thanks,
>
> Alex
>

