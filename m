Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7EDCFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E3D6B0088; Wed, 29 Apr 2026 18:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555E76B008A; Wed, 29 Apr 2026 18:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C5B6B008C; Wed, 29 Apr 2026 18:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 314506B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:44:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A23DD1B92F5
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:44:30 +0000 (UTC)
X-FDA: 84713073900.16.5B86535
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A6A40140010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:44:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAHuEQ+c;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777502668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fw3znj4/6hz553jN4hO82HiYCcLXkdCCz+x2C7sqcpg=;
	b=euukexACQ1Qvy/qZh64rDw591S7hiaEJKKsvJNSxvjtXDVEmcvUKmzT7f4lfRrXvpkTcF4
	TxycFQdpCzTEXVKca2MQxGgQjehDcVZy+YSm+HvOwSBs1GqI6NUFSygeLyFwd/BeBuhPcq
	WAFKtGfPy90+ARxvi7DKR3SaX6K8M0Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAHuEQ+c;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777502668; a=rsa-sha256;
	cv=none;
	b=4gkO9aRYvErZSbY/rl+s2CLjVXc3UQ4hNL05ouGnYKEFt1C5qfl40Tub/3ge3qd7ydKk0I
	9Kjsn1RuFueBfbzmdrpvaHc/UEX9jfstuOZzXNCTaLoelO21rwicXBIQMsdAwQEzGgOOCS
	XXLynu65XfkY7LVeglMyP5+mQoOfH/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECAEB60582
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA57C2BCC7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777502667;
	bh=VOCMAkRoJHwievxrF6FKJtCf+0oZEcgrTETYmIWAirY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CAHuEQ+cwJmPgGnEoQdcHL9zahVo9WQ/p5V6DhnFaJeAyD8PgqpJRC59u2eK+Y1ES
	 stNtQxwPhxd9OuDKx6TWErcDhwGknDLKTRxSLlzLZXvLWPAmc+Vqn7pTRk0+EnMpsy
	 jMPfIhfnZoaQaBcgZkxBVG/HURZEhNB3RLC+TtR3ZHW4d6cT1PPrl9AmAJvkcppgNv
	 Qg3X1IJW+GFGKQSeOqifDr1ZCGQR8sMPrQjDG246efAtN/4pE4iPOQX5JWQeisrwFI
	 uQxHJykZCXTHzGPGpcLm/VQsLUlrnU9ZEbMJgPKQhqJMwPFpWKeis1u0LmIbncgn0y
	 mB4iIhPKjZ8Fw==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so43047166b.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:44:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9Ypa5xN1tmfuaNI26wuYG7DfHTKuQIAOB4odVYlsTIyYKR3E4/G/26HtqpdofoZ9ESB+32hptnnw==@kvack.org
X-Gm-Message-State: AOJu0YyijPo1cxzXaN3V1Wf4X+/Qf/V89zAk6nwkZcjMmDh0i54+XI5r
	JZQLKroJQ1A4zNXR3Pm2LHh5o+7kL8EQ1VatMpS/UnU/pFfMAxazjQ1tnf/hKvlH7LbcYfcN/TC
	Ah6v+qgfMiSQlkwEvLtqDAWAuYXPr3hk=
X-Received: by 2002:a17:907:6e89:b0:bb5:8592:b9bb with SMTP id
 a640c23a62f3a-bbac50eab6dmr40470866b.17.1777502666515; Wed, 29 Apr 2026
 15:44:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com> <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
In-Reply-To: <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 29 Apr 2026 15:44:13 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com>
X-Gm-Features: AVHnY4IbBUbhbtmVGPu5-6mOXf4xr_XIz6rkf2s7ZdSXtIMyPqwBlQk_MqqyVNs
Message-ID: <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: A6A40140010
X-Rspamd-Server: rspam06
X-Stat-Signature: esdhpz38g3qxjuogtrz6za9b9wwknu54
X-HE-Tag: 1777502668-373178
X-HE-Meta: U2FsdGVkX18xaeL9NSFe7cV1nO2ImEpi0cU7LtPAKZloBMaXGiBWZ/wOhaj67HYQbHeLAEI1pZEBUX2IxnomnTLnUlfo0QIhxpTV7rQcgah/TPkOC/X9uvMior7MjgJzFjZtM9DWXKm6pBrEPbWCu3+yJ8pizdhjRXNBxRHCPT2UM8tWgNApAAtcVH9hkzDvw+HIUipBygZoPT5qAmatQrdunAYqAnZ2fsv22/hMHAM6vztTWQEzBQZUzVxD+aq4pqjvBcDt1zEv7UBaGcjq1Py0/2k7SAE1o33sBJz4YZW1CD94RIRW38f07wZq1ThYX8Eb+lEoYD8FgT+SIcUHN32hds7QpgUvFESe0UBv9ssrWJB20rsnSbtOZR54WaCjmXnl5MIxx5SvBAmT5u4VIJ5Z92KOCSx1Fka/j2lYxmRck4Hv+8n55kf4PiPIXIkK9MJvGg7jLVrBkGbInX7IF4VNjohAGfkpiMV9D0kcNcp4STPggv0DAVM+ApbDOkJUv5zX4J/IFA/TAY5QPaFRQqzRAXuj9cQscqI0pQfNDHRRon7xvP9z9wkLDyufAAee9qcLSJ+Ytn1WE6+kyUIpgikbWEjXbAtr6QAuS79yhhkPfFGjspbenmv2O2wTVfkc1Not/l4IC0FmW2hMLNatHPHvUu73U9sv0ZtMw1ap3YpfRt+IP/PypUXi4elVfZUWxvklOuGhB9opMib0Mn3gwp0z5ONkcMMsn22bmhKgRpfyAHTeF1tgDGHoUh36MsF5qjWOOsfoxL/iK3etPa20e9EZ2YNjeXI0Z8zZeiHZYg6+JGln5R0jsvQvpeRO4/K8PgRSa1Zwz4J5Jt4yUnQspD1OJ6NHsBGrS90077E+EbnRo+JpUdlPGzsMzy6aqYU+24HEb09JixD0+lfYKVZTgNPbpyE+A5HyllclTrrBuIHpcJxP85cFvGIYngY3/Pvp3jXr7Ng5lRUyDh+0k8D
 OamLmUeU
 we18dRI6iaAoFhayzMYAk7sjtNlP3gIHUDxfhf4YodPP72MT/7YaJ/yNeIOKHP8K6p/BrphgfNHdDjNSGpkgiHdHmDv8TDkJQ4lP14llre6ETEyMeWiEWuzALGihKj6Pn5SlnfpH9W917NEkwF3yDHr84apYC3JtTagBnGO2lk5iiPJSmRWYx3jlnCEEtL1sJfwc4MHHR0/synWaH59iAD4grv8wmlyIv1pQN+NHykoS+TzXPgQKf7f26nDDiBXwPekFyCSMm2r++cSE/0kf2NLY6Fjd+wDYB30SX/vooafdmHyK/I5XyeSzsZ7T8exScVfNvy350QMIkcalcv5d3xwZ5eLoSBJQ/OpOkRJYsHnVeOa8+cHS59FFaB4Ha0TT5b3l4e5Cp9qXVTsePFdjMy4qdlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > How much of the benefit do we get with just these locking improvements
> > without having to defer any of the freeing work?
> >
>
> Hi Yosry,
>
> Thanks for the review. Great question =E2=80=94 we tested exactly this.
>
> With only the class_idx-in-obj encoding (eliminating pool->lock from
> zs_free, no deferred freeing), we measured on two platforms.
>
> Test: each process independently mmap 256MB, write data, madvise
> MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
>
> Raspberry Pi 4B (4-core ARM64 Cortex-A72):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      59.0ms     56.0ms          1.05x
>   multi 2p    94.6ms     66.7ms          1.42x
>   multi 4p    202.9ms    110.6ms         1.83x
>
> x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      11.7ms     9.8ms           1.19x
>   multi 2p    24.1ms     17.2ms          1.40x
>   multi 4p    63.0ms     45.3ms          1.39x
>
> Single-process shows modest improvement. With multiple processes,
> each read_lock/read_unlock atomically modifies the shared rwlock
> reader count, and the cost of these atomic operations increases
> with more CPUs accessing the same cacheline concurrently.
> Eliminating pool->lock removes this overhead entirely.
>
> This only works on 64-bit systems where OBJ_INDEX_BITS has enough
> spare bits to fit class_idx. 32-bit systems don't have the room.
> I'm still working on the compile-time gating to properly enable
> this based on architecture and page size configuration.
>
> > As others have pointed out, I don't want to just defer expensive work
> > without understanding why it's expensive and running into limitations
> > about why it cannot be improved without deferring.
>
> For the deferred freeing part: the class_idx-in-obj optimization
> addresses the multi-process scenario where concurrent atomic
> operations on pool->lock become expensive, but does not help
> single-process munmap. Deferred freeing moves the entire zs_free
> cost (including class->lock and zspage freeing) off the munmap
> hot path, which benefits even single-process workloads. The two
> optimizations are complementary.

What is the extra speedup added by the deferred freeing on top of the
locking improvements? I couldn't immediately tell by looking at this
vs. the cover letter. I wonder what portion of the improvement comes
from the deferred freeing?

