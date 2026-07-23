Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D83C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426576B00E5; Thu, 23 Jul 2026 04:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 388DD6B00E8; Thu, 23 Jul 2026 04:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250CA6B00E9; Thu, 23 Jul 2026 04:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E77486B00E5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:57:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A4481A0414
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:57:49 +0000 (UTC)
X-FDA: 85019438658.19.D1D8EC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DF6BA0011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:57:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784797067;
	b=2NQtAZiG4jKhnLuxSTUCSrKJw9TFKWdWw+clFqELYAGZ0XZXWfyjXMVfCCZhrX2OB0Tl+5
	LczdvmmTuaCqmxx+9RJBgYTZHnyKPtpDgLnx8UlrBX7916aJiDU/uercr/jbSwePx7fhkl
	dXDUYmC1V9D22RIFf7UK32kiZGzVW/w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784797067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oklOSaboSPhMpluJoBZeVgBHDXjeGvg5S3e8nTsOgHg=;
	b=Bt45vmfCdHvY+4lhaLmkLYXw4YJ7b8tAdcgiv6G0mM7TBInWJWmivmU/ImBSBUmbjJrQch
	N9pVECEz2brUDxWOXjvRGt3v2sQ9edm6Ufn3HwlM1DBKTE3HlXA5ErwT1RDAhtf/CqYmh9
	iBaixhvBqu8VId+l5X38Xqctjy5dWOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C96E4170D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CFC1F000E9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:57:46 +0000 (UTC)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92edb12cdf2so24297085a.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpLqZBG3PhiS6mqBNMn0SQOL0DBY4uEZKcnGyuAL26s44fYbKtnPNCrroBPMkKFUn4d0JKzH6vAsQ==@kvack.org
X-Gm-Message-State: AOJu0YwgOIW5J/rfvmxDrSoyyNbIx6bLucFEvc+La1d2o30bhwyRQBU9
	kz2OaYjs8xy8uF2E6HJfDHYiE7ORjW/4iwdHJa2lEi2SVlDK1nPizZe7wUmklqFAQWQYwKoMQbu
	t094Lccw2uvfWxDXbUl0ibWFQtkegDJA=
X-Received: by 2002:a05:620a:2403:10b0:92e:cad9:3540 with SMTP id
 af79cd13be357-93103728103mr151218885a.70.1784797064796; Thu, 23 Jul 2026
 01:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260723045718.2052070-1-ridong.chen@linux.dev> <20260723045718.2052070-5-ridong.chen@linux.dev>
In-Reply-To: <20260723045718.2052070-5-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 23 Jul 2026 16:57:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wtcP87bTPmm+aQ3pxn4eLW7KqU-0DJhBF639Muc2xzjg@mail.gmail.com>
X-Gm-Features: AUfX_mwtuedh3AEXtY8PTrINLkSRxzHjvjpJJ30sQ1NdQRnQUsc53XGyeAvtqc0
Message-ID: <CAGsJ_4wtcP87bTPmm+aQ3pxn4eLW7KqU-0DJhBF639Muc2xzjg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8DF6BA0011
X-Stat-Signature: uhatrnk9siir7ntmkt5jydqeax5khoin
X-Rspam-User: 
X-HE-Tag: 1784797067-759795
X-HE-Meta: U2FsdGVkX19+X6XaKggQt6ZLSnQ5yDwEvUB6AIXDGpofYy7F7oLVtNQMpUhAkFqDaXDrkIm4FpiKrNyCJrGvKQYaEY7CwZM4UzOf27lMltWiAa6IJreUt8zi4CsIsUbUKaMCHEXtkA00BADE5hm2f3806/z8GsOkrrRy3r1w391eQpwgwhG16zf6PxGJjY0flQkUkm+yLNV4rEI9cc/sKy8C9jE0jDo7UuP21QSvZqt/jeRxS/6C+DGsMa3YkrRuR5EQY2Wt+WWtg0vBgc8ZvUH+Se+UgYiccksdzBV0wJDz+SFbGC+jMEG/RItsmJOcP5K/1tePZzJM058Ra7kiWcYFh+5KrfzpIUJx+v0AiaDigf8LKKzS6K+1uIjsszj9y9JzR9Qo2L1eL6jD9hO7O9/LuNp0ys1jLCEyVTZcPam2qIuw1yP5YoXeHtcjfCTG2cwVMqw/vR3uK4OLG/+fsSGkgDMqt9wd++fvoQunGKBv4nQp5IeWYx5dtKqFbQKWeqNC3wRgF/QzVZcK6ybD2qSSBjrVjXQ6OPh7EbJyS+vtK0JKj8hm0S3CL4DrbiGnVAhK4slF2nVS86HkOko0awAcUTGwSPO84x3HB13ZU2VPUcmubm06NvmkJM304ZTll2Iyua71r0UUeM2Xu2t4kcC8yU1/bpjDU5MOLU6uaaGwXvzpZVEWqv71IhLmXvnuVRRdAkQqtD8vnbw8IvS4wj8WsQMZppRZQrpLUo0l4ynClwmOr/8s/cSmdTEeKS2AA1utLngZ09sWse22UUT1VB8AY9F6mwjS8AGp0kbGoMnr2C55+YfjTe3dsmWv9C0qk49IWcX7/8Gr9OrED6SEZh9s/QSOSVABgN7NG3+7/BDCcBFIglhDXFuyBdWSojBt+R6dGPY6cJfnL0f8s47doJfK5DcYLEhbQU/cXUTg9wzbIyzDacjB/aVfMooq6tYLGW7Z27gUuK6ry7Pzl9I
 CpoQZFvg
 Gy/rDh+9BGVk6WIkC700I7BcSkmPp4RjPrOeGeucWbeCo9qiUgW17HqUdjaHFjtrrIIg8UOKUO69jWaLeY1iEf1n9dCUgAuiUD30V1YVoa/xKMalf65oj614tndn2500jQJdgtA3gpqv8DDS5htSwlTLLkgltv6bDL4wRmnMGklvAqTY4UZgQgJ4rpI6GiChpH1sYfZqetbhIiE8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 12:58=E2=80=AFPM Ridong <ridong.chen@linux.dev> wro=
te:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The previous patch fixed this issue for the traditional LRU. The same
> problem exists in MGLRU [1]: when swappiness=3Dmax (SWAPPINESS_ANON_ONLY)
> is set, reclaim is expected to evict anonymous pages exclusively, but
> file pages can still be reclaimed when anonymous pages cannot be
> reclaimed (e.g. no swap and no demotion target).
>
> With SWAPPINESS_ANON_ONLY, get_type_to_scan() always returns
> LRU_GEN_ANON and for_each_evictable_type() only iterates the anon type.
> But if get_nr_to_scan() does not bail out, evict_folios() still runs and
> isolate_folios() falls back to scanning file pages in the !scanned case:
>
>   shrink_one
>     try_to_shrink_lruvec
>       get_swappiness   // returns SWAPPINESS_ANON_ONLY for swappiness=3Dm=
ax
>       get_nr_to_scan
>       evict_folios
>         isolate_folios // falls back to file type when !scanned
>

I am not convinced this is correct. Although we do have `type =3D !type`,
when `swappiness =3D=3D 201`, `for_each_evictable_type()` stops iterating
after trying a single type, so there is no opportunity to fall back.

#define for_each_evictable_type(type, swappiness)                       \
        for ((type) =3D min_type(swappiness); (type) <=3D
max_type(swappiness); (type)++)

So I'm really curious what's happening here.

static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
                          struct scan_control *sc, int swappiness,
                          struct list_head *list, int *isolated,
                          int *isolate_type, int *isolate_scanned)
{
        int i;
        int total_scanned =3D 0;
        int type =3D get_type_to_scan(lruvec, swappiness);

        for_each_evictable_type(i, swappiness) {
                int scanned;
                int tier =3D get_tier_idx(lruvec, type);

                scanned =3D scan_folios(nr_to_scan, lruvec, sc,
                                      type, tier, list, isolated);

                ...
                if (!scanned)
                        type =3D !type;
        }

        return total_scanned;
}

since both min and max types are anon:
#define min_type(swappiness) (!(swappiness))
#define max_type(swappiness) ((swappiness) < SWAPPINESS_ANON_ONLY)

I guess the real problem only occurs when `may_swap` is false?

Thanks
barry

