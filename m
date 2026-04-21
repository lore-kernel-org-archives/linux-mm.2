Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAF1F8FA90
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95ED76B0005; Tue, 21 Apr 2026 13:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F776B0089; Tue, 21 Apr 2026 13:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FDCB6B008A; Tue, 21 Apr 2026 13:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6463D6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:03:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BA931B9569
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:03:40 +0000 (UTC)
X-FDA: 84683184600.08.C88CE2E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10F1880004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:03:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ei3/iyBY";
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776791018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhj7kC72/ufPnD9jgw5y/w8fCS/UdSYLVH8rDMZ85/I=;
	b=EsxwQ5nAsFjiMiKB2JVlVL8ltVt2Eph11tPicCAbymQy7YGsUufx3OuUN7jdAuxIjsJRXe
	Lqkt+tzUDCLdDVCJF1alAl0BcIszVf9F+O3T+FVCElEo9fwv+NGHBqKaqsoy5cFzwN1qq9
	kd68hh0YPHJHghf+HTavbD0Ch+LMF0Q=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ei3/iyBY";
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776791018; a=rsa-sha256;
	cv=pass;
	b=tO+m43Kg2Ulvifmk/kikM0xlE4EiRVDCLvFhR5k+cKYc9jxLmpin5m8bXXLeZXwa3hexjH
	WeUNIZpOEpHxm4nr+ia4q2aRo62UJHrzcxXf1+GS1ZSeRh89zzRaHq6gnMQls9qxIjeHUO
	G0Sq+y41DWU15PUjAJItZDnVuDwnvuE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so72819855e9.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:03:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776791016; cv=none;
        d=google.com; s=arc-20240605;
        b=JO6N9LD47B2fIyB1NSSrif8e9rKjosD/elIJsZxYEKaTy5ZH0Pn0uiht+Uaa96u1lO
         h+64yH0qnuCYr9QWu8wSiOv3l6JsdqizqbjACeiLFOZcNrFoELTtUHCpASNoqpUD1V+v
         9gQR655uG2GkffJyidbVSe0WJj4uSMMYDFmjHRm0lAiYiXLYQTddEkGnBzY3CsjAFRAa
         9iV//GTpPqDSt4oIufqFEkvIqf9TFQLmV6Y/Ec8flUOrTAa2SnSU/8usiNLWno1GtTXW
         mV2+INlE/+eb/UJVOSNFbNyvLfGAc5p8Th5nra7UOWKpHdfDmADA1cT1sXr0Qjc8KfB7
         p1XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hhj7kC72/ufPnD9jgw5y/w8fCS/UdSYLVH8rDMZ85/I=;
        fh=3FTADVLdW+edbgc6/eO/PqMF8+nPpP5beMdkp2FPBY4=;
        b=bLcgCXdMYY5k1MZigkzMUYBY4Y8YxhcshtBYiHoAtDXdx6rJtrM0KFf+fYaSwQCiy1
         juBW8ke8fyj1TCv4EnxethcP37cI97lxFkffQxKqMN/uDCWgynbfd3DjVRVlyIw5p/mV
         P6hzpwTPtyAaJ8SX1PWMovUggCwbsW1V1vrIJ2yRnf6FIh89tEpQqBtLSBexIRVxG0IS
         pX+sR9yxJ9SUNaMlceMhLm/q/iYGHdMdVyGli365qI9ep+Pm5I+SzarAeGGRsjUH4gtm
         T+ecTyYG7n8yg5Y3wuDBwypyfBzWSw+pebE3wxvipTGBW6vjaKYDvhdeMtWxwgRdbjQy
         cw+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776791016; x=1777395816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhj7kC72/ufPnD9jgw5y/w8fCS/UdSYLVH8rDMZ85/I=;
        b=Ei3/iyBYWNbz67FbXIQ567vuop7RHd1wTkAt2G5sWa7yF9tluUOU3/qvRTI1Pt7P0f
         /k4+QoY5PmTLirVkXlGt5iytWTqUQ+wcXw0s5dQ+kea538ZDBILoNYvjSVwSLF5lQbMG
         zHnNYHbKcqsI0fg7x3Kw3PbCFRVfHlNz01EnsyBqtELbVoJsvuxNAOGbnD0kUIzcKH1W
         CmyfXfR144yalqbR32u32nOCDOE2aJIJ883t6BhNPFaMKjo13/MqfYXrfsoMn+vx9IfF
         iEdKz8HwS2okYCIUWVoLfi3poopR86/8IDab9S84xYdWU+pYVUQ/MQku3IY4KfVKpd+t
         0VTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776791016; x=1777395816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hhj7kC72/ufPnD9jgw5y/w8fCS/UdSYLVH8rDMZ85/I=;
        b=DqOekpHOGJDbft/d86aBExixvoQl9nKTw+1Q/RFAE0PkfC10lAkmMgddMxte1ByEah
         2He4RZqIvjw94+PN4ehlAGw76LwkUbjB60IuIAYMOY9WiHZ+aOye6rNMldhS543fWKVv
         810jZZvyX5S7v/MgACUV2G8B68ZM0BKJjCUH0qoP5+bwLgRBSSDAUVBGBYm/TKgJZT9t
         sE5fS3bYPPNsjdq3MCnnnqvfJPBeQnaPfhBfRcpcPqt6UX/3QFVPHzWqvbppfReS+PGf
         YXuRfznQj6Jb6LMBg2HFNyy6X1y0Xrki5QxO63urWdfYDgqxqelAGfJSgU0E1XvwKmBC
         T6Hw==
X-Forwarded-Encrypted: i=1; AFNElJ+knlupz2P3fhEwxm2TkiEGbQVdzLq5ibkrZONfEVXh5sE8k6kA48eAQqQNCifbjUItrIEyxVb/Sg==@kvack.org
X-Gm-Message-State: AOJu0YzZSP2QSDxHyCZcrmUGTm1QtAGR/556JHM/mKn47WDfib9sGkGJ
	vZbyv7kgks7NKiR90+zrtEkbA0YKeceLLQ+fCfdJVgJPNZMb4mcNdsP3LjR1+IcPmTkBM/8dA7Q
	TnkfJzZYYIiyhkf4+og+/SJhNjPd+Ss8=
X-Gm-Gg: AeBDiev1rpa9NpyyEYA7P+Zpu3fPf4ZB/SnmFRTFB7IjOCyQs3diGmBdzBIEx+jY4Nx
	odYIMS6aBMjejfBgLq/e+kjyKyUEzpC5uaOgz1UhV/rMF2+2bjsZiVPkmIwVZwMw6mltYq0XLHd
	nM/mir+PrGrVlf3vyiKvb1wZOjUmSlNgZ6XlxNtCcZ0WPcEsA4w8wDgCak0XtwTRFCRKeV97Gez
	SI8WVU4N1jCWCxQgOLny9sbOXQGST1/bzI0jfnGqhuBL94jRG+6kgt8fsfTuoLaZN6bakRPbsVY
	poZfAW2lbEh8vJiXZ8oVJrU8dK/Oet2q5oN4xDbh6RyWKzuPHg==
X-Received: by 2002:a05:600c:a314:b0:48a:54a1:38bd with SMTP id
 5b1f17b1804b1-48a54a13b5amr52563555e9.21.1776791016057; Tue, 21 Apr 2026
 10:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com> <20260421121616.3298845-5-haowenchao@xiaomi.com>
In-Reply-To: <20260421121616.3298845-5-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Apr 2026 10:03:24 -0700
X-Gm-Features: AQROBzDF239IHDN0FbLVGZBy-mxj3aW6qMj4rkqOv1Sy_1Rk5OBnxqima7exgRo
Message-ID: <CAKEwX=O484K1KmELVW8Sh8k0iZ0CySPL=BBvjBC24veVCJObGA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm/zswap: defer zs_free() in
 zswap_invalidate() path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5tx833enqaudu4uzg1f9od56e5t7xd8m
X-Rspamd-Queue-Id: 10F1880004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776791017-761884
X-HE-Meta: U2FsdGVkX19hnjZ6ebIbObiXk0nWe91lc9ap0LL7LH1SPmJZYJMxJLBaLXGyQkWq5SucFB1g/RKvJRZ6k5wJ00kmxlRDOzP+GmbRALfH4CK0s4yuzx6T54RpS8Ea/uNNY+EifXyzW7tuoMQW9D4ATzmrMRFhb4BsXKfbs7kj3GEs9QIWw7Jsr0+0cB0+5e5sIZhCfcR1UZIkWuwPOLaDl5LION2TcU5dqv/ZPSdUcyfr/n8kAyiKBzwY4fMWYvqwnuCx75GwhdRMmYNcz0777H95nwjbWsT5w42Yg+0B9dmVLXz5Fz+0ZerGvT/NcjcUlz26KTAcLIp7CDe1n9xflJecOE1fP3EztmHGbsVgTPePhtOK8Xl/sK83uu5KdXYyA1pLMfUmR5GjTZfLNo+5gfxkMfrvV1ZbSOOeCMDyDXKGuorGyXvTf6E60RIxBkTJGKrjYlVQXrdSNYFGDcDliY3rFdsZWrg9PxLmKPNXt9+iJ7XejokH/saiyuZYvrypZTZixq7UMgRmh1GVbGEj4Z0jqzHxkpJt/eOeMU8aItW0xDsSdG/srCyW3NsPQR2LKsHXDweBEOAn5j4IqNXO+LDvfD4JZMH2y0t6VzUe2PTTUEPSeNVqHrytbXwwHe5xinJysk35gaO7mrn59YFFDvzbhHieRXBkjs+cfwFznY3LsUXHPuVDkTimCWZsu5cV3ZLFzxlUk+ksD1tPiR+dL2CLuMnP5UPwejkXHZZOKnOnWlnJxWpTTGfjQx6tKpJLS6NcJh8JKC2TLZR1KDvw8LNJUUKIaIRhoq5jIgDd39wq3JO4Jt0bK1dwSsygz3otHkATk7IuGWs8b7h/D1a+9GboCAOE1LHsHQC8KjrGNQNQaCJmn+ODZwMZMSF7r2r7zHvRX6hJWtUgCeByUoX4T6AEGS+NDlKQUkR9a0ryOg3Q8rXI2LEwjnPd+WR81fwRXssaHHoxxlV1ivk0D0m
 qcX+N9Ru
 vKFXYJkp08ixyvSSuM7qfSi2AK5i7YYjf4srXw6eMuQNyGjQSOpy+6SjT+DOZH8PniIFDfdsVbs0VH16PaMQg6nzgr4VVdKRfRZorZpc+eYMvYhsehD+PSbbYZPrrHnjblTem502fewhaQa0/l7MedCG5Gp31RDTJdLKJmUx+0JEmqClnSTA8Y9KDx9RMlHi0KHZ8qvgMZC3xFhN9eiB1TD1tQZbW2Edamdnf9SclYy097fHErRDZWZTR/PRCKIqtNRtYG+qOPX/xO5bj+XPovqoMcFqwTSrMT7NRbttT4z0AuaxQ98I4c3RfAyAjW6jzy5ykHKCrSitqKc3UjX6nY5h8hAJXDtzX+GNDTihLw3FfbSTJpAxaB0QFkY/Wljcz3nbFJ2gTRTtBnxuZzMD1IBxj0k5KQrZi71ooIUTHjz2hvczxc6fvmHcbi/MfBO+ZFX/MOf8Ru6DUuvFFhmYit8sFI+FnnfvJUt4c828xe4jqiCiiRZahuI5IUpWilVPVjGmZJfs/nYCwz5Ws7/uqRGagz0zU1vZpH2UxhZl2ImyAnWWMjK/ryVxy763VCsvSBHOKT2alSpr0F2qQDnlE3krbUQCvmfg/4/2FifHQhYXY+JElUIlK9pvaHveY3/oojQblTnUVGu/HAS3fWXbvEw71RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> zswap_invalidate() is called on the same process exit path as
> zram_slot_free_notify(). The zswap_entry_free() it calls internally
> performs zs_free() which is expensive due to zsmalloc internal locking.
> Unlike zram which has a trylock fallback, zswap_invalidate() executes
> unconditionally, making the latency impact potentially worse.

Hmmm my understanding is that we don't have contention at this point,
because zswap mainly relies on swap cache to synchronize.

But yeah I can see the effect of slow zsmalloc entry freeing here.

>
> Like zram, the expensive zs_free() here blocks the process exit path,
> delaying overall memory release. Additionally, zswap_entry_free()
> performs extra work beyond zs_free(): list_lru_del() (takes its own
> spinlock), obj_cgroup accounting, and kmem_cache_free for the entry
> itself.
>
> Use zs_free_deferred() in zswap_invalidate() path to defer the
> expensive zsmalloc handle freeing to a workqueue, allowing the exit
> path to release memory faster. All other callers (zswap_load,
> zswap_writeback_entry, zswap_store error paths) run in process context
> and continue to use synchronous zs_free().

I wonder if this approach can speed up zswap_load() (i.e page fault
latency) too?

Code LGTM correctness-wise (assuming zs_free_deferred works) :)

>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
>  mm/zswap.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 0823cadd02b6..7291f6deb5b6 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -713,11 +713,16 @@ static void zswap_entry_cache_free(struct zswap_ent=
ry *entry)
>  /*
>   * Carries out the common pattern of freeing an entry's zsmalloc allocat=
ion,
>   * freeing the entry itself, and decrementing the number of stored pages=
.
> + * When @deferred is true, the zsmalloc handle is queued for async freei=
ng
> + * instead of being freed immediately.
>   */
> -static void zswap_entry_free(struct zswap_entry *entry)
> +static void __zswap_entry_free(struct zswap_entry *entry, bool deferred)
>  {
>         zswap_lru_del(&zswap_list_lru, entry);
> -       zs_free(entry->pool->zs_pool, entry->handle);
> +       if (deferred)
> +               zs_free_deferred(entry->pool->zs_pool, entry->handle);
> +       else
> +               zs_free(entry->pool->zs_pool, entry->handle);
>         zswap_pool_put(entry->pool);
>         if (entry->objcg) {
>                 obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
> @@ -729,6 +734,11 @@ static void zswap_entry_free(struct zswap_entry *ent=
ry)
>         atomic_long_dec(&zswap_stored_pages);
>  }
>
> +static void zswap_entry_free(struct zswap_entry *entry)
> +{
> +       __zswap_entry_free(entry, false);
> +}
> +
>  /*********************************
>  * compressed storage functions
>  **********************************/
> @@ -1655,7 +1665,7 @@ void zswap_invalidate(swp_entry_t swp)
>
>         entry =3D xa_erase(tree, offset);
>         if (entry)
> -               zswap_entry_free(entry);
> +               __zswap_entry_free(entry, true);
>  }
>
>  int zswap_swapon(int type, unsigned long nr_pages)
> --
> 2.34.1
>

