Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E68FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DE66B00B2; Mon, 27 Apr 2026 14:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165366B00B3; Mon, 27 Apr 2026 14:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2C86B00B5; Mon, 27 Apr 2026 14:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0A046B00B2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:17:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CFA2120255
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:17:36 +0000 (UTC)
X-FDA: 84705143712.14.6167392
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7522310000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:17:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SkHTm9+Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4rc2QEolUfipG8l1VsxC6NAPaWQr7ALhmrqEkOLGvA=;
	b=XWQx6nuai2gQVbi3lubiyLbJeLVpj1I1Q1QUkB1eDGAYKOV0r4KVNOzAWhBoyf1PfZ0U/+
	Ltv8I8/UzXGFhbH5wANyzEM9mu63X7X9Kuv9uyzLDt8uviiOlOCqOItjMZ+T9GUq/MI8r6
	K24IcC4aPOnF2/EHX3ebvhAPphyINTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313854; a=rsa-sha256;
	cv=none;
	b=H459DKhktEUOsD2V5GUAO66a6wrZLRnDx70ZP0pkfKkAshPaS9+gHjKonHKwtu3ru4mvXE
	pFbGjJ+dXXYQ6zPJrtK5EYOQfqZ0JACVuPZmFMkKMJ9gqIoK3IGhv1eLWeBpkFgL8O4xCZ
	NbZqqtJtM16Gduz3gJ+Aw6vzXFCxq2I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SkHTm9+Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D5C044768
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89573C2BCB9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313848;
	bh=FsvLa0WQ+ppWSL2ZBwu07rxJb0VFpJsdirmzSrdOFVw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SkHTm9+YjDbbZVDp5ZuhGykXVSnv8mnZhzMp4lRHTlUB6GdE1cRztG6Ni7bdn41Eu
	 f2uVqfgSLTGpvGv83QE4MIao3JMkjfXXVDTxy/6Ort+DBKR721YH12zmBOlF04AnM9
	 UeivVBVFnr7CKqktHdfi9hHlsbHqswZHA8fRmVz1nySVEW02sNBSdCGDiRuPKETIxU
	 Zihezih6dhde/++xQ1ichw+SBu7uXJLxCTBys3OWD88PBx+4f2Ssaq6TU7zS2wnarm
	 n5guPMFIOaAtlLpyZdDXF5+rhmBJzIZS5MvmGifiY5x/qmPP+ISs9SC6oKAVEYgU/U
	 v3PNcft2kMrUw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9358dd7f79so675744566b.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:17:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/W1KHmZKBhk8qN6bauoHMOLrEPv8MxaRboLMR4vKC3J9P8vpEKbHCfHqujHKgBqNbRSmhYUhyEJg==@kvack.org
X-Gm-Message-State: AOJu0Yyv3ZjDGq0K91aVJyiIu2xZbLt8KeVx9tirdRqcnEh/zzD0tB5a
	PxfmxBaQd4VHIE2EDzpBnqUtvaQ7rnGXbLG1DeG09ByyfcQHLKAGiEqzLhoRhvqwKjJPKb+Ei16
	LSMq47giPZVxL7aPc76WtbQl3rEy6Z8s=
X-Received: by 2002:a17:907:6c10:b0:bb2:71a9:37d7 with SMTP id
 a640c23a62f3a-bb7fc6b329amr331966b.39.1777313847341; Mon, 27 Apr 2026
 11:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com> <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
In-Reply-To: <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Apr 2026 11:17:13 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
X-Gm-Features: AVHnY4LkdWo7aosvwMF_0ub38leF0QqpBslIr0st4sctLN5j8Y2EyELEuoMI2nU
Message-ID: <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7522310000C
X-Stat-Signature: yfdwqwka5tdc4xao8yuamkai3dnezdtp
X-Rspam-User: 
X-HE-Tag: 1777313854-240239
X-HE-Meta: U2FsdGVkX18GBsSvYe8PVEoUNNfKYiX4J7yDlP/KHD/G8n7abKLGz2p3rApFWcQxpmF+94ojmuoHCgGhw7vVixmbUTIPHv7DEcMi/4N+T+XoOre4MYFPyvnKqvs+QBL0Jd9X8lb8ArrfPPYrMGvJOE38wvl9nRmFjGlm1YwoYqMNUEmv1cngfn7HJLz9PC7C71GNg1BM3lNCJvZGbzkyb9S6f88fFgKeKg/QPTpRizDZ5zYs3prqoz6G+tCXBuAtFWJS9mnzr7aUVeq7CiFZMcKTMmTJcp4P7NyorGORTHM0eE4Tw1poyBYzdxgPXy5lElzNQgeLrprW7g8pW2cRXuR0kAu3t7SgD9dNXL9tPHkEnyKaOGqLz9gH2/pJ4vyr55b/nxIaGiTpub/av3IZ7ZkIWGC2hszUYTeOtzeyh7nSZckySzB2hP57IGSQviVgZerwPL1gXHuxJw6u1Rs9wlD3hXxymMbglC69fXmkzyeTcWf6Z2fcNqr1Q/iOmc5V8X9hriQ/3FR6S3SPDiZg1hZqTbDJXnIkAmX2Js2P0pICpi3U02rhBQVIaGc5Gat4nGTFfZ3o+EgbfHSFxfzDkTAQEkq/C8d3/wFAOAPoK8aUHeOpydmOwAoy0IX6k3vJCfXYjJCEPNvpZJXRcW1L+vimdFTFfj4vP1oFQ+J64uO+gQ7ZiMvYlnEhvwZ6JvJGS84IBIO2ml2WC0U++AXPtcgxowXuglySwk5coHjKvYbv8Tl8UagJ6U0z3LiPpPDWQpAKfZFRIaqavw+V1MluKdm1O7MNPwTNGakQNTbLLo6CDH6V5CuM/zG+i7qSFSEx1fcL/AHNq73x4JiwXKlZWl4fV2t2UU+CD5uguamR8a2kZpH9W3Z9xK8vPNhO3u6H8nXJysJ64TQ+12deKG/DuUCYyL93CNTDXmuynU1YinzF+AU2mIynkkVBId3IN4jIqfsE0lKrBj4f+HGYrvb
 vtZGF6VT
 hbik3dsnRh3XRzFDn2yYhess2yg/oOqF9yNSJXomKmogaHgMLK2HdBHUBgRHrfLRTWqkLwGiOK+hoqzO6P5fLvQeGGYmwCa4rNuwDyVRgUB1SjUkmMfgy4VNATOz5sx7NRp9LgkVdh4Zwk/EgOfyPcfXlmtzglVkadO7PKCfIA78/2gW3KMNpKPebzNWe//N1/lOiSPPge32zIQI7TN8kzaFiBbi3VMPWZSNKL/8hfex9Qy38BxJ28J10KA8EswPwNeMEQkY9m4X42lUopsudmeo2vZzD6JSd/eSsFSpu+DKc9ubN9sJcK9c0/yQMnWpcG1E7Tsty56gOEHMGf2GbnYB3wggVDn0Hh9HEhs6mWSPYl44XN247PMQdK5Zxf9T8fCmz3OIjLE+dBu7HeUrpZu+cvTziRc9CoJhmZyAeyVXXuuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 9:13=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> On Tue, Apr 21, 2026 at 8:16=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > Swap freeing can be expensive when unmapping a VMA containing
> > many swap entries. This has been reported to significantly
> > delay memory reclamation during Android's low-memory killing,
> > especially when multiple processes are terminated to free
> > memory, with slot_free() accounting for more than 80% of
> > the total cost of freeing swap entries.
> >
> > Two earlier attempts by Lei and Zhiguo added a new thread in the mm cor=
e
> > to asynchronously collect and free swap entries [1][2], but the
> > design itself is fairly complex.
> >
> Hi Nhat, Kairui, Barry, Xueyuan,
>
> Thanks for the review. I agree with the direction and have some ideas for
> an alternative approach.
>
> My approach: first eliminate pool->lock from zs_free() itself, then defer
> free to per-cpu buffers with a lockless handoff, and finally reduce
> class->lock overhead during drain by exploiting natural class locality.
> Achieving both per-cpu and per-class is difficult, so the class->lock
> optimization is a compromise =E2=80=94 but one that works well in practic=
e.
>
> 1. Encode class_idx in obj to eliminate pool->lock
>
> OBJ_INDEX_BITS is over-provisioned on 64-bit. For example on arm64
> (chain_size=3D8): OBJ_INDEX_BITS=3D24 but only 10 bits are actually neede=
d
> for obj_idx, leaving 14 spare bits.
> We can split OBJ_INDEX into class_idx + obj_idx:
>
>     obj: [PFN | class_idx (OBJ_CLASS_BITS) | obj_idx (OBJ_IDX_BITS)]
>
> OBJ_CLASS_BITS is computed dynamically as `ilog2(ZS_SIZE_CLASSES - 1) + 1=
`
> (8 bits for 4K pages, 9 for 64K).
> Since class_idx is invariant across migration (only PFN changes), zs_free=
()
> can extract class_idx locklessly, then acquire class->lock and re-read ob=
j for a
> stable PFN. No pool->lock needed.

How much of the benefit do we get with just these locking improvements
without having to defer any of the freeing work?

As others have pointed out, I don't want to just defer expensive work
without understanding why it's expensive and running into limitations
about why it cannot be improved without deferring.

