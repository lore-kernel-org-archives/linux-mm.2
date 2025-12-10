Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAEDCD2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 07:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2936B0006; Wed, 10 Dec 2025 02:06:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA546B0007; Wed, 10 Dec 2025 02:06:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F75C6B0008; Wed, 10 Dec 2025 02:06:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 713626B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:06:07 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E061013492C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:06:06 +0000 (UTC)
X-FDA: 84202677132.20.E427986
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id E0B6F18000D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 07:06:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eNOJDpT5;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765350365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3q5pyCB1YAl49x/+AJ0QKDE2yC1eVd9dXTt+B+QxS28=;
	b=qK1C+GyKYVhROAVQ8Z/1a9W7nOvZUHEqfTiwSHlXIBQh/iEKxs9pc/uuNHw4P9CCsHRsrL
	8vP780mHHEhVQ3lyQpBIq2Zb1IBCI6mHV945l6FCl3DEZ4Jtn4QRbajldHo4zrYOJJ6jmJ
	GSqfLskrcYGBb1fpEANTriM9ICbLHAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765350365; a=rsa-sha256;
	cv=none;
	b=2ZtbMk/qYlIzUusGpXn4yRtcjG31GCQmVPSwBv6azizh+4WX//OBn3UTxQpDK2RJFeu1Dn
	fpj9pFwdPeNY8wFP1GEKz+aZd7FAKx0nVrP33UWIqKkNZUFxEf3gVEQuUVd5MXVK5FKq/V
	pkNExz1AUlHVgVd/6XiTU+DsVpP0w4I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eNOJDpT5;
	spf=pass (imf16.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42e2e52cc04so2317294f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 23:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765350363; x=1765955163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3q5pyCB1YAl49x/+AJ0QKDE2yC1eVd9dXTt+B+QxS28=;
        b=eNOJDpT5+djkOaJalRS6bhvY1W7gw14guiodWa9evekRWf88DIWTtK/XOT9AvkRTie
         niuxgcYpIcS9BHTgqadxU13S3wL718xBeyFZZDnkzaeAfMChJ8EgGZKsurSQ+QFtA6Tc
         VHHCSTuhCaiGxoflAy2tw1dnKdqDJwRmqPx9VOiImWP4ol1UcQiTLBWD9YScm+MbhayH
         4fz4s74xJSkwRrHwuFKwBKzn/WuCD5hTgx642W64fzHaOHBOYVlXVqHzZ7Co+yjuxkEG
         zBqtlx/wZ+pWhF2M/c/2yzLswmjw1ZTJ4Q1ylTVWXmhTuDqpDMesU6urmv/AbmoC59nd
         VJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765350363; x=1765955163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3q5pyCB1YAl49x/+AJ0QKDE2yC1eVd9dXTt+B+QxS28=;
        b=wkDNig7a0zJLFdBp2FkJa41bG4VVPW+QSAxJdkKCzAFr7CLRXjWKCIIgTJkm/LLI7K
         JexpLIaXLsRod7L0YGARaoIuWcUXGJ9tsG7nRGPFsP6yeH8HxvxyyxqIiziNhRAOyS/T
         0AdhQ6Z3QLo7ytk//mzMbYLNR9RhqFKxMi259QJroLC/K5gaKIBSnlme8PJfaqxh5BQT
         UFt5FCyMbYv8Rei9YsyX+u40ly21VH+95ejmLXLIT2rkwG9UXCd9caPxm/6xAcDGiwPz
         2pmSJU01ysCL/uEA6ueUKn9wCJtifX2Q0uACqJDYmjLP/KXnHLBopPmHtM+lbYE1+xfI
         Oa4g==
X-Forwarded-Encrypted: i=1; AJvYcCVnAo4RtLwREKIoP382Hyuqk4pWK0m8W2a1JtWZ0sCgvskr6ArjLY10JO4qFseHsU8B8Mmg5ubNbg==@kvack.org
X-Gm-Message-State: AOJu0YykVbYUjv0OszJX2QNKnjMYR01AN6rXUn7sly3qHTtO1tt5yOst
	eqVq++r5uJ3OhUs69xMG3nrNfiJAhTmDf2SVEL7WcZ0ky23rOxiwH7SgR/tdStJOZ0rWEa7OGTL
	9UTcMzzgcOnuj13DTxr+IKY1qkNIXwoE=
X-Gm-Gg: AY/fxX7Rg/cHesYoWKhrJx0mUyR14UC9Nc66bCQY96bq6OsFFZEHpJC4kWDJ+uRq3q8
	l8RVfy91wJe2y6RFTh0da6z5/XWUzW8E6N9OJLD1OoLOkYJFoo9Yhpx/S95If6TZrieQE7W4Zoo
	5M2l1e7w22prUwWMEjSJlocVeD49DAtoIrB0YVHK+ATTbXZDv9R4WMKzLvomMOMF966bdHVGuTk
	5S5N7Ik+KKtGIHu1HI0kPPuEmPeqTmdDdtTaUYQx+3phBYc984BZB6bRN5Gr/qJInxCyQ8m
X-Google-Smtp-Source: AGHT+IFNuofYkt/xOtW7wXiUCQcf0/SlkM7pvVXk2IWMuyZrA+pgaKc/hWdLmNtf4AUbGfmW5f2StLFIz8C3F5F8fHM=
X-Received: by 2002:a05:6000:2892:b0:3ec:dd12:54d3 with SMTP id
 ffacd0b85a97d-42fa3afd499mr1436752f8f.35.1765350363084; Tue, 09 Dec 2025
 23:06:03 -0800 (PST)
MIME-Version: 1.0
References: <20251210022024.3255826-1-kartikey406@gmail.com>
In-Reply-To: <20251210022024.3255826-1-kartikey406@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 10 Dec 2025 16:05:52 +0900
X-Gm-Features: AQt7F2psMb6xxXf3GnQm9t3MP71E8p1_MPJjx1ZxbXEM5Jglku_brHLBirqOKbg
Message-ID: <CAADnVQKzPyWo0GvFymxNSmMV63ZRtKGoFaUPvZCE59q0HbV=8A@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: reset KASAN tag in defer_free() before accessing
 freed memory
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E0B6F18000D
X-Stat-Signature: ss6wzq7qs9skiwo6337iqadpnasrydwh
X-Rspam-User: 
X-HE-Tag: 1765350364-683189
X-HE-Meta: U2FsdGVkX18JeA8MXOcVPiSp1O9Zsmh6i5trjZtslopI002YX7YtxysRXLrMOIIURloJDFLczOnJ7N1EPi+LJqUtHFoZqGjhiliYQ4PiCQ9g5aayinR51qsMp1luw+c6/NzbTqk3260G+RtKE9Cfk9FM9hJ/S97hDu33StVTv5/qi6oseBUvXdyQjUoEL5BfQtOl5kV8gplvIjEa0pNWDC5qsFIq20GC/DngDoIJVc5cOVIyLn/VlAbXR4tIUDeGfiL7VYhKyMPiRI+aT/E47Dc6XFm5LtT0iDrOTtDg/2jhZaURJbJ3au3moA5+GBBEjHh7taJ8tOtXFo090AM6SMOWog1Gdd3s9cCcUsBNLyLj/GzEKjKP9CY5k8vGSsATOCggKUFjrangbrz1pFOlrRunB4NPSDWb+p/uKO12V2IdjxG2EeC5/Ao6hmIKgcoCsy3Bfge+uv3P+fvc8FqI1hqAhigs4T384BgoGEGnp0UPszZaCfofwSi9CUpuPXs4RWubXDMwgP+lQs3Xm2pfSqlVnub5iCr27p1C3GHmuKaddJL621TYfcdu1xwfTgiT4QymsIGhqXqO31Rff3whrPa96bTD3U6EC6GstLEm6jE1lFEhhZzvgG3aEy45/1wPxnaxR5512IhSekjARUKXgzTmWoGPkxOH354MjbqDfm1H6Ozzekdz2kqXv6KeNYk+Fen7yaPIaHA3WAHnGx7y/EIJRyVoIK+XjXLwnRL5sN9S2f/dQfS8iF+tHw2hZ7rd02a4mvICrkFWPzbeArqYOA6OA5xbUs509bYS5F4C7xpsoCdjWOyN88XHO0jHTpdDfsRx9xA0hqiMx23dXNHF19O9Ei+v+Np+eDXSD5cZOAcrEcYByHfnKYwou1h6FoBwa4gvEkjRQFFUUiAk9kurkfHj4HkWGj3v1voMWn2DQEYFriugfvsBpHzKmxfZgPAhp4XTjtm3Gm3YG+lPVZt
 MQvWKtNw
 89qRgsG7kEq2HX/lbdZdKQ82H9vhqx00psMDs/kGsG2S9IZOTs/UTcEpGOG3T3WxvuzxibAgjEEqj6T6dPN2NwbnGNHwvPlrc0Am3H97Ev/HFOhsYEayVKAlIUi+3PMuj4ywmvJO6yl2vs0WU4dn6HCwTl7TQ3ztIayaRTWwauwqHaQ413g8/ahbcNrKFbOT/g3zyE+iEzVxcVu4lH0q+a0bMQ6v4xkse2Yk9YLLThPdyle9bUYTR4OSH/8UomrhDO5WQn38HXReQDN3Dws5osqgJfo74Qxg0IeEO+JOi/ulut+vAtkz6tf/sxwVL9ZaydTmxwRjeNvDBmDGRa71KB+aM7IYTJRGA9pKO7OgzjfZMZkb3/8KEKGrekrd0QXhiwS/ZDt0q9Q+FKP8b/wc4nEJeisF93klQhrKsNNB0GQg8PlioQd0O+sohgvDNeBcaT0Sp2oboXe+KPCtLl+3IPku0jI4G+u5A4ZeVj5Ew6eeABmHYVUovz4TimoQDMTE0qkWax05uJ4IJ/Xgonbvx9TrAXKH5DPHxdrozk+9kE4YKlbeDH5TS+Jsvo66obz1BBfwrqkX43dAGDl+7QG7sfbN6c/j7bAuUeglG67i73pB4OGz/9vGuYdOJibCIuust69cN4UgVNpcIOBRAX9rH1cds6d6W+n4nSgip5jdzZ1IuEWPSFbnE/2xyhN15Gug8ekwQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 11:20=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> When CONFIG_SLUB_TINY is enabled, kfree_nolock() calls kasan_slab_free()
> before defer_free(). On ARM64 with MTE (Memory Tagging Extension),
> kasan_slab_free() poisons the memory and changes the tag from the
> original (e.g., 0xf3) to a poison tag (0xfe).
>
> When defer_free() then tries to write to the freed object to build the
> deferred free list via llist_add(), the pointer still has the old tag,
> causing a tag mismatch and triggering a KASAN use-after-free report:
>
>   BUG: KASAN: slab-use-after-free in defer_free+0x3c/0xbc mm/slub.c:6537
>   Write at addr f3f000000854f020 by task kworker/u8:6/983
>   Pointer tag: [f3], memory tag: [fe]
>
> Fix this by calling kasan_reset_tag() before accessing the freed memory.
> This is safe because defer_free() is part of the allocator itself and is
> expected to manipulate freed memory for bookkeeping purposes.
>
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()=
.")
> Reported-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7a25305a76d872abcfa1
> Tested-by: syzbot+7a25305a76d872abcfa1@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/slub.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index e6a330e24145..46959c6da2cf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6534,6 +6534,8 @@ static void defer_free(struct kmem_cache *s, void *=
head)
>
>         guard(preempt)();
>
> +       head =3D kasan_reset_tag(head);
> +
>         df =3D this_cpu_ptr(&defer_free_objects);
>         if (llist_add(head + s->offset, &df->objects))
>                 irq_work_queue(&df->work);

makes sense to me.
Acked-by: Alexei Starovoitov <ast@kernel.org>

