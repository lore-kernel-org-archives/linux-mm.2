Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B764FCD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265856B02CF; Fri,  8 May 2026 20:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215C86B02D1; Fri,  8 May 2026 20:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6096B02D2; Fri,  8 May 2026 20:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E86DA6B02CF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:30:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D0E2A0452
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:30:01 +0000 (UTC)
X-FDA: 84745999002.07.2FB6106
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6B4B1180007
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:29:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEgIzF54;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778286599; a=rsa-sha256;
	cv=pass;
	b=t/foed7lR0reMEyVSQQDfQgsKScWFsAJyYfqGCsTLsK9mSkW7RzM79S4BBFh3LCXCejmaU
	wChvmAzngBL0ZBw4n5smL/092evg8H4Ezua8Q97VnG4qaMZ1eIsp1NdpOqLungiopA9y5E
	xrNTRJhrODDNtvjYLRqBXmwWF1d6akg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MEgIzF54;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778286599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0G3a8pDIQfohQ9aEjyLWVBL5s8318IMIlNp3JjCVu/8=;
	b=egaeimwwsQTRy0GFw82kQfhZwU+Svyfwn5Ro945PrUap2ruj8urNpyU9jX8C0TQ5tDiTdY
	qRo7uvbnCjqKm5bEXdVsMk1u7YOY5tBV3cuFSjBhbOOg9fuV7Li1HU3nxFPFWYE63UBD/9
	8j2le8LRPUqxDZBF6xxMI2EKbG0MRwU=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d734223e4so1634581f8f.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 17:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778286598; cv=none;
        d=google.com; s=arc-20240605;
        b=RIOcEqBGu5SSY4InDvz6rCoMm2t8WlU7CkMWo4hhm2AeQ5A8YONXuN3mWYTGOlMhYz
         ST3VcJ9lFQyMLzMWtDpbobgfqf/ZRXw1dAm1uk5BWdTcFb67j4grF7BMHGHph6YyXk0M
         7Vi1barcDEeQvg9ULDvEaBw3jyJKkjmwBdLDGbBmeVXzi92PLdPzHDHSu8i2A87/3v0g
         +eFwtFcFSsuUWD0Tm8wociFsae1e9AbXDIl6hEUuxBhr+xkZ/XiGK7W40lCkQWt0AyuQ
         zlpUDDYlFUN0WDA2Mm36rY4LwN4s7m+Mg70TuFEflNbGpBU3gP6ayupQMvmsaSpH3a+p
         zLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0G3a8pDIQfohQ9aEjyLWVBL5s8318IMIlNp3JjCVu/8=;
        fh=rFCdUwJPFkqHxXrTWp3tq5yTbvOGhY3waxsw3Rs+kr0=;
        b=IZqQfNQ1lSL0wQ2tv0M6ZsSN02HjdIuUGLUq2GFoQqfwvEcCZGSsP0iAcWbyCbmh4v
         iryt8ugcz3mdNOVX9cUEBPDDkCy50+0aMTrD3EEO6Vf1VKOO77bze5ZhI9/bkPWspX0u
         D9ydBGYLWWr6ACT7jS5OR5hihwurVhb76rN24vB1yjv0cX8FsdBLhHSsozseKK0dYtPk
         JCwVvA8k+9/kwkC/++WBrbmBpcWnovSQtb6W+znjcm+t7hq2yn50LrW9hDrGl5cGqvS6
         MyeBbNn/ezMWvjSern7uS7l+DI4+gBz1G0sKzY/C7kU35ZT1salY7y4ft1crT1LCpWDg
         m0wQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778286598; x=1778891398; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0G3a8pDIQfohQ9aEjyLWVBL5s8318IMIlNp3JjCVu/8=;
        b=MEgIzF54AhzFnIlotlqlDlRjycutXLeglVYBxlFi6ulNcLFeIaRFQfKuWS5nj/L/ZQ
         BtfdLvGrJCPTAQOupv3yTzJLdKTzgduS+nvc95ZNyPwXxg0LUAuQXj2mqOAjUK3AIHwo
         hAj7rjwNzwe9ubM7yvcXKL5Q8sw/yj+ZDr29dsO1i+bX65jTKcJmqbz9BTD9y6cMJn+h
         HblA1cqXCtJBFawFqcIe9ggpGct883OC6Kn4Oxq4sUnKFdzenKZq6fbC50njEnGweWS0
         Pz4Ab9Dd8esX7f/dkgDbxR+WlpexlCInnwmt5kJI3fJEiZB+/fk02aSg4yV5t53cFK+f
         abPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778286598; x=1778891398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0G3a8pDIQfohQ9aEjyLWVBL5s8318IMIlNp3JjCVu/8=;
        b=p+8sMcqWjQomyy/CmVtGQ+u5TSbSOGe8IUjYNZq7JmNqDnz6V33koUAsYisO9iXhds
         1Pa6yN7j67TEhjMAhufoJ4DRvGFFoLvfpEE9CmFaHRBBE7ioLvWjk4m2viTN1Vpbz/wE
         Vj3kf8fGab51k8ejwMaQqFZ3PnjHTppyC/nWLDH9ky/SC/zpyLGzBAMpIu4wL9wP3wTE
         3wAefGe90OZTx93GmUhCwT/z5ngsOkQxoCWr8riDFoiRMDb1Q+edWHV+x4BV8kfjOWPf
         n/gGR7ekQepC13fr3gXOirG9bdLS4LEYAbUHNqVzMplHU8V11oCSizE4dYpqDloDvtyZ
         SmZg==
X-Forwarded-Encrypted: i=1; AFNElJ+TMtfgCRyOnJ1MCHkz3/gz8HlcCT+e2j8fZ5zol2vsznaZHqz77xrm/OXm69MRL9CzQhPG58TJpw==@kvack.org
X-Gm-Message-State: AOJu0YxkglnkN1CFqMZtrpxql1B3qQAymyMy5SLiDss2e8LKeBSHW5Qd
	wVrHBiA87XXInavrmKBkNJTYBxT6ZJWMG/46NnUQ67+5VESBbtCUUlkT2T5oP7kVXiRNShiS3jW
	O8df8KrTgCtZBYyQMxsWfU4yO/IwLanI=
X-Gm-Gg: Acq92OFb9odiGdBm7TFD5NHSltpTIJwCgq3H4RMdBUJ1IH62jD90V6DPQ7Kr1kTfVXG
	Qwe/L/WikOPfUwFi3oShPfkcG9I9PxxcuTKB7FeTtB+1c8pU6HmRVP0ZlTmSKMejnYKpF/ui5wx
	GUt4L6AelAcZmXholqNOXs2V+1c1L7QSv+IsUJb9a9+7jgb57apkOgSsj7IevO2WCKZUGA1WA0g
	TRa8MlyKhCHTE7sTvctJ9Fsgy4ggQ0ymEhBprh34wFVUugjxmamh14tIOCWYvmCc4ch4CW+6j7h
	RzLAMO7qM4FDo9KoC2Rk6BZdilZFpu9KKharlxngo81fuCdc9K41m669MzQ=
X-Received: by 2002:adf:e6c4:0:b0:446:708e:1e8d with SMTP id
 ffacd0b85a97d-452ea742ea7mr9621915f8f.30.1778286597751; Fri, 08 May 2026
 17:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com> <20260508060724.3810904-2-haowenchao@xiaomi.com>
In-Reply-To: <20260508060724.3810904-2-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 8 May 2026 17:29:45 -0700
X-Gm-Features: AVHnY4KP3V33whk3hf4lfJjbsavyCuPedc3dt7_hzKzLAbMLN3db3L4C4L4lMuY
Message-ID: <CAKEwX=MzLKTF2uQRaJU8UK5B9UeW-Sh-LE_8fdmo7y-MPPbwyg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/4] mm/zsmalloc: introduce deferred free framework
 with callback ops
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pyobfx7ftn14d4f9da9crskfg1ross6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B4B1180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778286599-877591
X-HE-Meta: U2FsdGVkX18SBOCPZ9etXsBPeDEGQiC84SZZjUaOFOkCfC8oalVBw2LWh+Doy5RFKyXf5LBTZbqWp8Gc8cc2gJRiHXFtvlvJDuy6yBybFflrxxcfw2NK3SWuzmFo271ufBc8ddZudBV9taNetnL5MANpFyTmzixj5iQCNWF8O3lTqTc8bMhVa+L+NdtlataXAo113j6DNp3I9ecViak/ppZaKIRk7olEMWKupva8nw6wcGGesvhFIIXmhtVKpJXAWMANQ5B1PjxifOAAgSIYLGDJ+/MEYQ1Uj5jUHMazCV/LN0VRleEv72Fk8WmhDN3gVftVFAMHdnvWcQ6IWbRnwQxgw9OfZoUA6a5GuoNC0GXldJIeoqPcs4ER2Mn2E/RWodv0cVUh1wwpTVH0XZ6shkfoVDxmEV7pASWzbcOdwWUg0HXj0EYWRVF7fuKCRAG1MunKj/q67ET9C/V1aZHwUAWw4tXNwU8UR9W5XU0ps1bYZN/2dk720s75tS/MoRewpgBXWcrKj0NJWRU3UbFdzuNgtRtf2yWO9ooOQd1ZVgRZPL/eOw5u4FPdFT9CrNHR4Xk1n4uSjoz3y9ifORjUDnqNhqclHKnD7mXvUCbPn+Uf7pKZlH8qeXJ2/1rX+V6VEqU9wLs/HhJjRwdOOZ1bxBByNHFbJtpdQPd7uKSsnYtc1i84FUSHQOvg8squwAbPaYSLdfndx94kzoHUNc3Mp0CxcQiVwMk/qS3t1aMEYr+L3rX17tbpz9pTd4RW0+a3GHeUoXt/Yctx9T3r8dgKUBDp6v7k0vywXEqH9RjAF4BAehjF9//ipdIMzwRnoWC71NlcnNB3qJxo+rVJeIR5bLJzjrlrCryj6TFPPw1fWcrGHe0JrlKsO4UhNjDIXardoJI1+qXzQT6tSkTaoiXRdo/fRhr5Hv+6kGdaqEsztjjiEqVrH39zHpQAU6w3ToO/X1u2BcSJAmA/iZXXoOB
 5/WTHixV
 dUp+7XYkaW8SHuX7Gvs28FzKQZOWP4IY+bTesLuFvgtjsMvj1uGLBtuHb7r/bn2THNnN17USO19iIOZwslL8yFGY9NRXKFKbnUF6Wa6yi78+9Mh333ZJ0mEfQXEunOF5Z/9L/dVhf/KZwsCKQBTk0nFVUxHo8i4f2DUbcQCuNkcAF4ws0pHpmCjx8RljeKTognGs80jB0w1uXNTFc1amgTQ7S8N56d6lHLBa694ZfV4RWCb4jG9kwAFS1jayI5Kle1SWrZYdpmb0XzqKyaHr8auS4Ao0i5vjdPxKLOBREYPyZtIw+MwJzsSZy9+qjTA80ifso2wGkhk3QC+aviRwb+Nk6lb1NdIOmDanV+y/FlrwA3VkX79rTLGfWPzOkYCYShGeUXHx51ppPedNG/DUqn5cc6ncHV6yLqORkI3s8j8ndOayWCjYpYTbCuCkTLi5W9Z7q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 7, 2026 at 11:08=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Add a per-cpu deferred free mechanism to zsmalloc with a callback
> interface that lets callers (zram, zswap) customize push and drain
> behavior.
>
> Each CPU owns a single-page buffer. The hot path (zs_free_deferred)
> writes a value into the current CPU's buffer via the push callback
> with preemption disabled =E2=80=94 no locks, no atomics. When the buffer
> fills, it is swapped with a fresh page from a pre-allocated page
> pool and the full page is queued to a WQ_UNBOUND worker for drain.
>
> The drain worker invokes the drain callback which performs the actual
> expensive work (zs_free, slot_free, etc.) in batch, away from the
> original hot path.
>
> Page pool management:
>   - Pool is pre-allocated at enable time (ZS_DEFERRED_POOL_SIZE pages)
>   - Full buffers are drained and returned to the pool
>   - If no free page is available when buffer is full, the push falls
>     back to synchronous processing by the caller
>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
> +#define ZS_DEFERRED_POOL_SIZE  (256 * 1024 / PAGE_SIZE)

Seems oddly specific? :) And this doesn't quite scale with number of
CPUs, or memory size?

> +
> +struct zs_deferred_percpu {
> +       unsigned int count;
> +       void *buf;
> +};
> +
>  struct zs_pool {
>         const char *name;
>
> @@ -217,6 +224,18 @@ struct zs_pool {
>         /* protect zspage migration/compaction */
>         rwlock_t lock;
>         atomic_t compaction_in_progress;
> +
> +       /* per-cpu deferred free */
> +       const struct zs_deferred_ops *deferred_ops;
> +       void *deferred_private;
> +       struct zs_deferred_percpu __percpu *deferred;
> +       struct work_struct deferred_work;
> +       struct workqueue_struct *deferred_wq;
> +       struct list_head deferred_pool;
> +       unsigned int deferred_pool_count;
> +       spinlock_t deferred_pool_lock;
> +       struct list_head deferred_drain_list;
> +       spinlock_t deferred_drain_lock;
>  };
>
>  static inline void zpdesc_set_first(struct zpdesc *zpdesc)
> @@ -1416,6 +1435,171 @@ void zs_free(struct zs_pool *pool, unsigned long =
handle)
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
>
> +static struct page *deferred_pool_get(struct zs_pool *pool)
> +{
> +       struct page *page =3D NULL;
> +
> +       spin_lock(&pool->deferred_pool_lock);
> +       if (!list_empty(&pool->deferred_pool)) {
> +               page =3D list_first_entry(&pool->deferred_pool, struct pa=
ge, lru);
> +               list_del(&page->lru);
> +               pool->deferred_pool_count--;
> +       }
> +       spin_unlock(&pool->deferred_pool_lock);
> +       return page;
> +}
> +
> +static void deferred_pool_put(struct zfs_pool *pool, struct page *page)
> +{
> +       spin_lock(&pool->deferred_pool_lock);
> +       list_add_tail(&page->lru, &pool->deferred_pool);
> +       pool->deferred_pool_count++;
> +       spin_unlock(&pool->deferred_pool_lock);
> +}
> +
> +static void zs_deferred_work_fn(struct work_struct *work)
> +{
> +       struct zs_pool *pool =3D container_of(work, struct zs_pool, defer=
red_work);
> +       struct page *page;
> +
> +       while (true) {
> +               unsigned int count;
> +
> +               spin_lock(&pool->deferred_drain_lock);
> +               if (list_empty(&pool->deferred_drain_list)) {
> +                       spin_unlock(&pool->deferred_drain_lock);
> +                       break;
> +               }
> +               page =3D list_first_entry(&pool->deferred_drain_list,
> +                                       struct page, lru);
> +               list_del(&page->lru);
> +               count =3D page_private(page);
> +               spin_unlock(&pool->deferred_drain_lock);
> +
> +               pool->deferred_ops->drain(pool->deferred_private,
> +                                         page_address(page), count);
> +               deferred_pool_put(pool, page);
> +               cond_resched();
> +       }
> +}
> +
> +bool zs_free_deferred(struct zs_pool *pool, unsigned long value)
> +{
> +       struct zs_deferred_percpu *def;
> +       struct page *new_page, *full_page;
> +       enum zs_push_ret ret;
> +
> +       if (!pool->deferred)
> +               return false;
> +
> +       def =3D get_cpu_ptr(pool->deferred);
> +
> +       ret =3D pool->deferred_ops->push(def->buf, def->count, value);
> +       if (ret =3D=3D ZS_PUSH_OK) {
> +               def->count++;
> +               put_cpu_ptr(pool->deferred);
> +               return true;
> +       }
> +
> +       if (ret =3D=3D ZS_PUSH_FULL_QUEUED)
> +               def->count++;
> +
> +       new_page =3D deferred_pool_get(pool);
> +       if (new_page) {
> +               full_page =3D virt_to_page(def->buf);
> +               set_page_private(full_page, def->count);
> +               def->buf =3D page_address(new_page);
> +               def->count =3D 0;
> +
> +               if (ret =3D=3D ZS_PUSH_FULL) {
> +                       pool->deferred_ops->push(def->buf, 0, value);
> +                       def->count =3D 1;
> +               }
> +               put_cpu_ptr(pool->deferred);
> +
> +               spin_lock(&pool->deferred_drain_lock);
> +               list_add_tail(&full_page->lru, &pool->deferred_drain_list=
);
> +               spin_unlock(&pool->deferred_drain_lock);
> +               queue_work(pool->deferred_wq, &pool->deferred_work);
> +               return true;
> +       }
> +       put_cpu_ptr(pool->deferred);
> +
> +       /* ret=3D=3D2: value already queued, will be drained eventually *=
/
> +       if (ret =3D=3D 2)

=3D=3D 2? :)

> +               return true;
> +
> +       /* ret=3D=3D1: value not queued, caller must fallback */
> +       return false;
> +}
> +EXPORT_SYMBOL_GPL(zs_free_deferred);

