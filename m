Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0B1FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 04:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE37F6B0088; Sun, 26 Apr 2026 00:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94196B008A; Sun, 26 Apr 2026 00:13:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B826F6B008C; Sun, 26 Apr 2026 00:13:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A61EE6B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 00:13:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0CC811604E5
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:13:17 +0000 (UTC)
X-FDA: 84699387234.08.0CEC778
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 189D780009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:13:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=axLtTPM4;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777176795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EJqe3X+xATXaKTJE8qE0IWMxPmt1lGZbCXxHX7SCDg=;
	b=wjuOwlpbk/n99CVFBhldEwga3FtNc97jzNy9of5oFfucUqg5Gg69h67JNg6PwJu5PctWjl
	D415XKkmOOIN86faKShzzb3O4k1fohinJ5lmyPGkxjrLu6G367kH37sz/I7kiJ05sOoUne
	sIlOVB9QZI/eeWc1y5TQLHOJrfqIVY4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=axLtTPM4;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777176795; a=rsa-sha256;
	cv=pass;
	b=z1mcngDraP0OuwQKZkJ2Fe8VWuY4nykhvtdCXfT0BoCwRmHY65FX+OBc90H++Uf//jnKly
	YRo+2k94jqHLnzutqhzpCjIjRU+k02D59kQ3Q4FfNCI+pEVzEPg0wjbVvCopW3814yXiV5
	a/ER1JtxVwLdyUPpOdC7RPtBFovoVto=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-651bf695701so7562341d50.2
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 21:13:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777176794; cv=none;
        d=google.com; s=arc-20240605;
        b=Imc77fj8uz0qb095wu5BEHE/BaQm+zEVYj5yXlI0jNa4XIVUOkTpwWy9sGlA8J92Br
         /vaNoiOiEwz+PwCDrXfj04tYHs2nh6cvlf1MzXMck9qJh45uVWa4SyUH40xYXtGIQhcB
         EvLIhUY4czevkXcLPW2DDKAzTwgCneCU/UQbAV1VHlEwVyIvLnitGI7UgWvEfmqtgCyM
         wzGH9UXnYXkzBxxMln+sBJUaiyQOmCbDL9/nEqy6H9B4RkLLZ7qOFXIb8SmJyk6YTjle
         DNFT0cNAPmWuodJPzkg0QvttTc9McEzXQ8UsQkL7z/AfxdmW7fpRofcJlHlXLeLUlOdF
         CZ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1EJqe3X+xATXaKTJE8qE0IWMxPmt1lGZbCXxHX7SCDg=;
        fh=NYHUxK7QCA55ylwUllQuROZwXhWyBPLCnn7rlul65+o=;
        b=CpYwzocQtz+yHBTRb1Kldr0m2vEm2cMANySGjhhhrF0kBoXpHuw7XAODuy3v9QLHCo
         86OyFX5eJql5+T0LoGMHuIZFSm02sBrZdxwmOaB/SHfiSoFsukAA/2amwMW6qgqm3mp2
         2HkxqHvzNK2/n9Cj5IeKEmbgGvMbhyAfo7Pi/XqIrsgAGoVaPch761MpbOa7wkTa8Hd+
         QXNW7f8azmVbN8+uKEEPRg9xEIrUvV3E9Wc+pwG3cbJKjDB0D+txEr1n2pdFNk6GpSYl
         wuQT8Oi4MDGs+z3+p4nmRl+bPU+Q/o95Xj8Ktm//AoWQhmyjyEwPqqjbuePz2KBQaRWj
         HnjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777176794; x=1777781594; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EJqe3X+xATXaKTJE8qE0IWMxPmt1lGZbCXxHX7SCDg=;
        b=axLtTPM4eG9twkSZToyT1BhFmorbaEITZ6sLhBjM8xpB0AJradt7+m7d4wb4/m7zdB
         046eMKMnXWgqSPTuDu2V4YWZVVewE+KO1Zx5KVABMrSa6BM6OTLKNXrAYRQut973i9al
         09tQdXFoJkKgwKbafueSwdazdNYHtDxjCHu8sA4/B4h4R/4uO7ume3rrBj4xdRV4BDA6
         0vf7c2vv14jbm9WwrwKwmtH6bcBO6NB6/sI4PV94sC+e/H3yOSoMd6pIBrLN16LRBNN0
         t7/rvsc4sbpug3fmnwgYYy0LNhpvdLz6O8BlUJkt0IY07AnY5LLSkX4I8lzN3LhDfQd4
         y6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777176794; x=1777781594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1EJqe3X+xATXaKTJE8qE0IWMxPmt1lGZbCXxHX7SCDg=;
        b=o0gY9dEerhwO1zFT+i77LvbqbcFwyMXrpxIrwvsnGh8CgfJywIyQdDuyXoGjN54h/7
         lJ9yIqRVjCM6pggqZFd4p977+P5+xt8n5kSe+PAdPo3ejtv66shgUgZxqOuazQ5WbRv6
         +FGC6kilVYsJUuCvwnNU3n075DNyuUXJ42kepVdV8n4ahHQxOn9jTNcrmFgQFoLR38OL
         tdkDT+WofXKPgbyXvFO2OJMl8u16qS3l4Kk2PqwoRv/Nu55/OX02MY/fSMtICbNq7Ti8
         ggBtqAdD/BP7+xx6l0zN4G79sb4gSftAYRvxrctAiJIj69cniP25FEq5bKdLVaI2TZo6
         XM+g==
X-Forwarded-Encrypted: i=1; AFNElJ+e+7TT3KJ6yf3h5R2XHV3yHUQYBM0UswgWANY5w+oJPiPNDJjOvQHoPsKDhHPBAkcnbrT/dhEjPw==@kvack.org
X-Gm-Message-State: AOJu0YwCmbh+6wt9BSYLB5dgspUyO6Sf7A3nJYSj2RPDds0oHN7LG6np
	2ULzK15noGZlHhO8rxZMaRYpOzswb+LQBHJ9/vNwOE4qIfRJJB8tp6VhkxTxACmWYjxc3p5joRa
	yp0XNDymL+h4/+rjrtyIjYVa3TJP3uxo=
X-Gm-Gg: AeBDieuCWbwRpHNzFzdXzCsLR8ErDvwMoSfd46aaOEgj0YCy2nqUyhPPTqLrnS8gAST
	XKtIx/+AgVmluVjzz8Ue+0O6cBKGqs63eBVuT8DGGmcVcNTZGT7K6jAcpV3TLj83hASGKwyQb8t
	VOK7kVl7AX8yNwe5U+6AQ2TdTsODXEI4FZOdPwM4obO4xLI3sr94BTxG64kI/uWnzoIcdkPhY5q
	eEkJn2dPychQurMBC/X0TDCU3R2Bv1RBZD9dHXZS0uuKYeh1aTcynYRqh26IpZu8tQRRI3yGwr3
	3vWnqWtQ/dEskNLX1AE=
X-Received: by 2002:a05:690e:1913:b0:652:55ec:6a2b with SMTP id
 956f58d0204a3-6531086f9a7mr34230037d50.25.1777176793935; Sat, 25 Apr 2026
 21:13:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Sun, 26 Apr 2026 12:13:02 +0800
X-Gm-Features: AVHnY4LfnBuMlVsaZ1GGaeUCV7InFGaYFFvq_d-yN1xzvXSxJKM8ZAXbAn1QiUo
Message-ID: <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hi3on68qfemihi5mgeunz3ixnag7k8o1
X-Rspamd-Queue-Id: 189D780009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777176794-794281
X-HE-Meta: U2FsdGVkX1988A3XzriyM605JUL1JZcRMfrTatYHu/1xCWDlhFaWsXKgYyI6tU19JtQvvwGIA4VOnjLgwK/IWWogTdcI6CASy7gFm1sEKErfkRpzLUJLV5n661R1Uw/qvuGN16WPMS2VJ0cJeaMAwbiqU/tKcU1hJ4Y3DEH0Fl06IWvTHfhsh0iRkV2lKCNSXs2fPUBatmjR0AIXDP/ZPsmdXL8+JCzobwv+SAK+StRT3AGJMBEsG2K2b09vnn/1x0H+vvK21QofotF0WX07jnmiLa5LEVJbrFxEMB+rDXg6YjX4oIl7oCtHOEJ6Afsrbt4dPCLeVW7D/XOD3kEU/JrvQCe6VDXrIXQDZzUFELfiJbKnse5ptqKvLp9ld56bM7Doj6ZfVqCaCo9QH6WSHSNNyjCv5AFwF5n9aZ60y87cmDzimUFoHVQnb8XcHW5V7vlh7oetb/4ZROp9SLOB9iBKwcTqNMftgt/+mQmnDtVg7QVHwvs5lEFXq3+SZwTD9kSAVXxro2rkCrkQNVzq9MzGhM5OkoLgFEndgulNMNHfJv1p8SyfBYcxJQkeaUoUR22bbgQfaRLijLYTsX2SWJWW87lFB/DJ1tZsd6m5zRKt/Rk6k43sf9LgvL5rdfQB7z7fuRVFFG+1oYZ8Dgr9cQpd/5Sf9vxgg5HffFDFpP/rWFI/h7VtnW5Hu32dkSBm1YoPJevZ4Y7ARmJbKjE7M6kScQOjGG399Xy03kyI02ej/3VHPmtpypwgO0ypXiYEtzc/DlNsGRsFgIp+60QN24uHKuLWJq3LiK2YKVQ6FKmLA+vtwfd0JmKovQJUI2dl0txqa7Sgm4ZrMWPmegE8FAm6UcUhVspGnlozzLNd/nhyz0FUjRZsDWm40a/3gIhspeaDMwgN8yYXIVEYkmdwK0RF8aPcZl3eoruG1y+GbChf5A+exmKvkzuTJtB9pdIRyWq4FhPEA/dAhrit+wn
 O23bY9Mh
 GYVIO9/qsZ2N9k+1GOYuGjdjBtI7K0m86fHjJTWhHlE/JpJcuBnhUn8B6aM/NogcfxXjLjyAzS2G/BtPjVQ+ETUaZunSCDm5N1U7FlgHXlAjNMltjkbf2KwZ8eZe3hxKafG3Ov/5CAygw5LUXPpCUXDyWIlmBIg736VJJVwoSlsYKV2qDkZSdV1kAshChIsVfeojhkbccy85vVeTW1BNyryd7LSR/dnSJcL4AgJUzvmeLsfPbNOQU4Iq61mVUeefMrXIbDtboWmy0USOBj4ciMF2EZVrE6ShFY+CsR6OoPED90SiCsXcmC9siXk/YmEx4eWamcMnYBqI/bw9VvIDNkik/oSrMmnozPbN66YQrWNZShiC/6VjciIrMc5yV8PGeBhqYzupmBZKAkzXA+EDLDfgWrFqYOx3l86i2RslTznANW/gCgeJIN2WORwcXIinAAxXsJxwFkeJEme2SUK7cpEiHOXCCscEkr4fTqXY/bZZ3ZNKQd+BzG/XUKIB49bj00RhzV6w+E723CNG0GZhy4UpM6m1xR1r9IhFlyFCDwSJ60a0ZmcboXFuT/6b4m4Bb9/tX/+LWy2VdY7g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> Swap freeing can be expensive when unmapping a VMA containing
> many swap entries. This has been reported to significantly
> delay memory reclamation during Android's low-memory killing,
> especially when multiple processes are terminated to free
> memory, with slot_free() accounting for more than 80% of
> the total cost of freeing swap entries.
>
> Two earlier attempts by Lei and Zhiguo added a new thread in the mm core
> to asynchronously collect and free swap entries [1][2], but the
> design itself is fairly complex.
>
Hi Nhat, Kairui, Barry, Xueyuan,

Thanks for the review. I agree with the direction and have some ideas for
an alternative approach.

My approach: first eliminate pool->lock from zs_free() itself, then defer
free to per-cpu buffers with a lockless handoff, and finally reduce
class->lock overhead during drain by exploiting natural class locality.
Achieving both per-cpu and per-class is difficult, so the class->lock
optimization is a compromise =E2=80=94 but one that works well in practice.

1. Encode class_idx in obj to eliminate pool->lock

OBJ_INDEX_BITS is over-provisioned on 64-bit. For example on arm64
(chain_size=3D8): OBJ_INDEX_BITS=3D24 but only 10 bits are actually needed
for obj_idx, leaving 14 spare bits.
We can split OBJ_INDEX into class_idx + obj_idx:

    obj: [PFN | class_idx (OBJ_CLASS_BITS) | obj_idx (OBJ_IDX_BITS)]

OBJ_CLASS_BITS is computed dynamically as `ilog2(ZS_SIZE_CLASSES - 1) + 1`
(8 bits for 4K pages, 9 for 64K).
Since class_idx is invariant across migration (only PFN changes), zs_free()
can extract class_idx locklessly, then acquire class->lock and re-read obj =
for a
stable PFN. No pool->lock needed.

2. Per-cpu deferred free with lockless buffer swap

Defer zs_free() to per-cpu dynamically-allocated buffers (~2048 entries).
Enqueue: one array write + WRITE_ONCE under preempt_disable =E2=80=94 no lo=
ck,
no atomic. When buffers full, schedule a drain worker; overflow falls back
to sync zs_free().

Drain: allocate a fresh buffer, swap it in, reset count. Since
the producer stops writing at count=3D=3DSIZE, the handoff is
race-free without any lock.

Pseudo-code:

    /* enqueue - hot path */
    def =3D get_cpu_ptr(pool->deferred);
    if (def->count < SIZE) {
        def->handles[def->count] =3D handle;
        WRITE_ONCE(def->count, def->count + 1);
        if (def->count =3D=3D SIZE)
            schedule_work(&pool->drain_work);
    } else {
        zs_free(pool, handle);  /* fallback */
    }
    put_cpu_ptr(pool->deferred);

    /* drain - worker */
    for_each_possible_cpu(cpu) {
        def =3D per_cpu_ptr(pool->deferred, cpu);
        if (def->count < SIZE)
            continue;
        new_buf =3D kvmalloc_array(SIZE, sizeof(long));
        old_buf =3D def->handles;
        old_count =3D def->count;
        def->handles =3D new_buf;
        WRITE_ONCE(def->count, 0);
        /* now drain old_buf[0..old_count-1] */
        ...
        kvfree(old_buf);
    }

3. Consecutive-class batching during drain

The drain worker extracts class_idx from each handle locklessly, and holds
class->lock across consecutive same-class handles.
On the exit path, compressed sizes tend to cluster, so consecutive handles
naturally share the same class =E2=80=94 giving batch-like lock
amortization without sorting.

Pseudo-code:

    cur_cls =3D -1;
    for (i =3D 0; i < count; i++) {
        obj =3D handle_to_obj(handles[i]);
        cls =3D obj_to_class_idx(obj);
        if (cls !=3D cur_cls) {
            if (cur_cls >=3D 0)
                spin_unlock(&pool->size_class[cur_cls]->lock);
            spin_lock(&pool->size_class[cls]->lock);
            cur_cls =3D cls;
        }
        __zs_free(pool, handles[i]);  /* free under lock */
    }
    if (cur_cls >=3D 0)
        spin_unlock(&pool->size_class[cur_cls]->lock);

---

Benefits over current mainline:
- Removes pool->lock from zs_free() entirely
- Deferred free path is nearly zero-cost
- class->lock is amortized across batches instead of acquired per-handle
- Producer-consumer handoff is fully lockless

I've prototyped this on 64-bit and it works. Still need to sort out
32-bit compatibility and Kconfig gating. Does this direction look reasonabl=
e?

Thanks,
Wenchao

