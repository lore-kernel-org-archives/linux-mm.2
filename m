Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BEDCA1005
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 02:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63ED06B000E; Tue,  2 Sep 2025 22:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6171C6B0010; Tue,  2 Sep 2025 22:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CFF6B0023; Tue,  2 Sep 2025 22:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4123D6B000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:13:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8E611DE307
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:13:46 +0000 (UTC)
X-FDA: 83846318052.25.A265C63
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id F31DE120006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 02:13:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DoE3LcY4;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756865625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gENk5oy3VPH1iTtwOCQdC87R/NjbhqCM6vXEQKfriYA=;
	b=mmuuUNDe2s4Q/60U2jHawGiMuV09pMllTVsoT+e/fwX64JshRwSSqmvXhdOfVm/3Zmpt5a
	Tk8PC0319PByasB8nMgVYSoLfRklsFBq4GyYHMBBQMxu5IUG+SU9nx2qMKL6R449JNUUbE
	7PYb3RDDeW7+Ce9WaFVyZVdwVjbhk+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756865625; a=rsa-sha256;
	cv=none;
	b=yBXP3UU/1MuuvUPlZlZu8lCj4sDobFegkLKMI8jpqjjUSBCZBl7um4l+2BOxIwapgcM2j4
	A34adMVGndynxppqgAgdwQeq83kL+twC9TZCu/EX7Ajjiifw7wo7UaO6iUQv3NvpMk8GMT
	hoU+cn5jiYVBMdhTECR1JioMMPSBgmE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DoE3LcY4;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61ce9bcc624so6969272a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 19:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756865623; x=1757470423; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gENk5oy3VPH1iTtwOCQdC87R/NjbhqCM6vXEQKfriYA=;
        b=DoE3LcY4uhyynhT59tA2LJtmxRr5AhBhZqx/7xxleSLB4vxr7GLZ1dVoxPzTNqMn+v
         dh3S3FSpW6e00Ip+rUFuS/Xam5R4buEzj2bVY1N9w6IxblnK/EtKZq7Nw8QM9J+EhR2+
         k/vy+a27QePOuHK/fr5/rYl7f92VC97RBPq++80o+NpdDGVuUrl0aQIWXG9+nkWZRJCa
         icD78v8AxwMSglAJbvTFCTdn0znC+SfF+OEwxcvoYp6eOiIz+bdDaOCwSJWNXdolunFF
         TDZn4a9EcUdURMniudadPIUUUh7nPkBPe7gul0AY8l0U1ZZ08ZvXeYQssutuLrjChFji
         mWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756865623; x=1757470423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gENk5oy3VPH1iTtwOCQdC87R/NjbhqCM6vXEQKfriYA=;
        b=GjcFOyBd7jsE+jEYvSMTzJEF2Ea5EjOf/e7ubleNC1Ie15i2rsDQh5NHYb1/Xou65j
         Izxu757PchTb7DkgGuJLG+LAtS0zqmBAy41RrRQEJRvUVkF/TLySPnQ0xstn+JBJvfjj
         HEAekdPFdawoHh9YzYtiB39YzIPzGBCsFGOmFj2bRaXzk08Dn0VC53N2iI1oTSSEkQMv
         GUBlEmjDUXgi9KTn06wwXFyUDQg+XyIUwqTbF5jxRTjU5XfAwLcRyMr/COXfdTgFQyJp
         wcAkMmw1Djc5UHZM9VbOPb5eXFW/yGa1zKR2hHF96WLeat1l3hQUnu1cbPb6agPCRHJf
         u+cA==
X-Forwarded-Encrypted: i=1; AJvYcCX0zoGHQAfB3IHTRgHoTVRZKQoPYP6ZNpjikrM6OOSHLPPPWZ/Sn1Bxzk5C4HNVfugHRlBnL1xMqA==@kvack.org
X-Gm-Message-State: AOJu0YwZs/funHxUbua6sGF1Zps2NYyr91QWe1IoBtwb6QIgGqixUYH4
	QZzjUDcs4FncMRHblYNLRVWUNvAgihujZRkFeaw7JxIC3ux32Sh7DwaNvvzDU32YfZviLz1S47e
	5PbT6cW5bzHVZFSDRy6Grh9z2yuw9Kzubmw+XMrc=
X-Gm-Gg: ASbGnctk7KKfmNcxdFofXTzmyTcRvCHCo+9eoyAL54wL2uGRjCgK/qJLf7/QzLd7Ow5
	Z1ajq+zuzCmXP4b72QWl8WnZ4cUNLEehFtfPJTAYRZ8DYp4NtxA6z09ZEXoalbntoWuMqjwmSMV
	be5q3U9H9KDbRBAPUhLqlTJYnBTManX+em0GJXu6jQpM9gP1CPtTasQJINyzbJq0yQvVItt1i/2
	ulZFVNXvgQ=
X-Google-Smtp-Source: AGHT+IG6d+Qs7jEfLV+2GlfeM2NxgKykyZEZ8CaSTEyS6WNoJKY3VPzhv/tG8RqTorogqedmIV3bT8045r74TvWBm88=
X-Received: by 2002:a05:6402:40ce:b0:61d:cd5:8b6e with SMTP id
 4fb4d7f45d1cf-61d260cc220mr12247397a12.0.1756865623431; Tue, 02 Sep 2025
 19:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-9-ryncsn@gmail.com>
 <CAGsJ_4xON7fYg1VvcjLOsgBb_Wp4ruC+vdA4Q496GH1jXunU1A@mail.gmail.com>
 <CACePvbUVK45uRPVoO3ubDfQHikebSHFNQOsMTMvJ91QQZH2HwQ@mail.gmail.com> <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
In-Reply-To: <CAGsJ_4we4ZfNqJ+v7+=0hjNKLakJ-s8qtRsGo_kp0R_th7Xvkw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Sep 2025 10:13:07 +0800
X-Gm-Features: Ac12FXw1AUa6fSBq5i5DCUWbpe7DiaS0JIvFp0rfOypSx71p22kxXjov0LKnUyI
Message-ID: <CAMgjq7Apnxx2GbTG5_dA+Vy1wGaxMHuS9APp0nny8tNURX8jDA@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm, swap: implement dynamic allocation of swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F31DE120006
X-Stat-Signature: auguk7cocxiipk96xhqmbai88s38kx6s
X-HE-Tag: 1756865624-973527
X-HE-Meta: U2FsdGVkX1+3vkVaOeTbrOeVwRFKNMnt02wExjkjNurYisMYm0JiPQqUyyhmiGEQYasZ4WU4T/OFBl8QjYKFZEWmWZzPDor9p9CitkyPujIKgN5oSlX07iKXFL1TxROlByBeuZ26QitPTTI6ZaJ4tNXJfYDyfZvcLmmzRZSCDtpo0QRVRCkS1xVUykpS1NTNkP9sgkm3h7oUW++1zWLgvn24mvNXdTDQTJ+TYLDHxrc8NCIK6KLO1MwpafefrGGQQf6R//pAPY1ERsR6gtgvkfCwF2RzwEhh0DrH1Z9Xr9Pb7Z31GUEJgKo0KC0wfuCnr9YTC3uW9jHG12E74lSBpJ+L+jYeWUEb+7SMoPAcZKRlfixGmhXwF5ZXB5P5gxiStHc/kHNgljQRo/3uK52jSAHB7Ro0ReL57uQeIc0cFgMnXsJuW6zSN2oByRs3YZ8JcJGirI7MK6YZFDnV6DI2VxYZlG1tUJo64VpVxXBXb2RQDND/Bzx3NDsnsxJFw+5ssAe+p0WHFol8GQGtvpaL7tkYdE8UAV0d3IhBkhw2ZNxtD8viFkk1yTk19VbRoExCzXGKQcnASjiMBkRH6kMfDuqgD3no2Y6dUt8Qmqy97XNPAaXzWw61dGWTHp+krY3Fz71kmLIg3RdijYuQXEXJsp7yW0KrUmoSS54mdwADpu6kO+zJYIRS6KhLNk1r5rbmcd00qaaxheVp6S7uluHXm11E2+HDpmMH5cTvMHFBC4wLIGZC4U8JcR4GRnJLsim3R0lFx+PDWFWoWTLQkhDEsWFTYgAhjt9/gewUtIRTSPHVsAiPQrQk7xqZDeRnP7sEp0/j18NOqv9Q/UwOGGGEBM9zLthXyomozU/SWzhs6ffGCjIvzVxj3keGdLUP1nx6zufLG9XD9wUHp061cadNiIVlMJVvDl29+nb1glni1kKIeQaTIcLDkSDqdjTW4VCP/Xx60mnyd+q3ndtH13w
 /dtC9DPc
 OFRzwq2PVoCX74ia88SL+8fbVpkxugvUS9ZcsWLPlytu9h0DsPB0UC71HUh6vaB//pZN/w/79afDjqNESYTZxpTFpezbduAy1pF2e6t9MGkot9wxRe+jgfTtlLTirEZ1r1MUS8EC4rCyLv2gsZgQCuLXZITdV8Tv+WjUDDU1HW09e5sRUZIE1nqmsWiZ8h1pfv+liru44ncC2CLwUWkuEWRhoOjs52zEWAlshpak8pZbjQq96HiHIf0gTSMHrVVExGzX+9oQFjMQzMn5ISpkDY7gVV2YtywHlFIpLrDJlyxoXmGvlCVc7DHPVHe8/bsiqpRNoYcuwKfIPIDlFr+Q3GWh4x0YPMUIyefFUAqn+jxihLqSYYV+G+dWbyhkrS+tpYGQumDO0i0d4CJxWD9gU9JA3M4tFv8Pe9VbhcoriglGLf1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> =E4=BA=8E 2025=E5=B9=B49=E6=9C=883=E6=97=A5=
=E5=91=A8=E4=B8=89 08:03=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Sep 3, 2025 at 1:17=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
> >
> > On Tue, Sep 2, 2025 at 4:15=E2=80=AFAM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com=
> wrote:
> > > >
> > > > From: Kairui Song <kasong@tencent.com>
> > > >
> > > > Now swap table is cluster based, which means free clusters can free=
 its
> > > > table since no one should modify it.
> > > >
> > > > There could be speculative readers, like swap cache look up, protec=
t
> > > > them by making them RCU safe. All swap table should be filled with =
null
> > > > entries before free, so such readers will either see a NULL pointer=
 or
> > > > a null filled table being lazy freed.
> > > >
> > > > On allocation, allocate the table when a cluster is used by any ord=
er.
> > > >
> > >
> > > Might be a silly question.
> > >
> > > Just curious=E2=80=94what happens if the allocation fails? Does the s=
wap-out
> > > operation also fail? We sometimes encounter strange issues when memor=
y is
> > > very limited, especially if the reclamation path itself needs to allo=
cate
> > > memory.
> > >
> > > Assume a case where we want to swap out a folio using clusterN. We th=
en
> > > attempt to swap out the following folios with the same clusterN. But =
if
> > > the allocation of the swap_table keeps failing, what will happen?
> >
> > I think this is the same behavior as the XArray allocation node with no=
 memory.
> > The swap allocator will fail to isolate this cluster, it gets a NULL
> > ci pointer as return value. The swap allocator will try other cluster
> > lists, e.g. non_full, fragment etc.
>
> What I=E2=80=99m actually concerned about is that we keep iterating on th=
is
> cluster. If we try others, that sounds good.
>
> > If all of them fail, the folio_alloc_swap() will return -ENOMEM. Which
> > will propagate back to the try to swap out, then the shrink folio
> > list. It will put this page back to the LRU.
> >
> > The shrink folio list either free enough memory (happy path) or not
> > able to free enough memory and it will cause an OOM kill.
> >
> > I believe previously XArray will also return -ENOMEM at insert a
> > pointer and not be able to allocate a node to hold that ponter. It has
> > the same error poperation path. We did not change that.
>
> Yes, I agree there was an -ENOMEM, but the difference is that we
> are allocating much larger now :-)
>
> One option is to organize every 4 or 8 swap slots into a group for
> allocating or freeing the swap table. This way, we avoid the worst
> case where a single unfreed slot consumes a whole swap table, and
> the allocation size also becomes smaller. However, it=E2=80=99s unclear
> whether the memory savings justify the added complexity and effort.
>
> Anyway, I=E2=80=99m glad to see the current swap_table moving towards mer=
ge
> and look forward to running it on various devices. This should help
> us see if it causes any real issues.

Thanks for the insightful review.

I do plan to implement a shrinker to compact the swap table of idle /
full clusters when under pressure. It will be done at the very end.
Things will be much cleaner by then so it's easier to do. And
currently it seems the memory usage is quite good already.

>>
> Thanks
> Barry
>

