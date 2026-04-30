Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F7FCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ACF76B0088; Thu, 30 Apr 2026 03:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DF66B008A; Thu, 30 Apr 2026 03:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C996B008C; Thu, 30 Apr 2026 03:38:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 032CF6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:38:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B30A81A0498
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:38:57 +0000 (UTC)
X-FDA: 84714420714.20.FD3B734
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id C38C2140002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:38:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLv0Ot8X;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777534735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXP0rjq6f9ivjYP+86z3oZz11J3Z1DaKAvZEEb/Awds=;
	b=FbWDfnFGA7EABXqteqYQPJ4ZlRjlP4QBWjKhN+x6lAhnHlChiTqklfC+N8Mi8L7I2QObw0
	COFGcdL55wVfaGj7uFiJ1oWdRIv2w8L8zEXQTyG961yce3+cITtUDfHKX+fyxlkYpdhgIW
	dQ+hQ9HaWMbx4dQ1UvgMvMVY4trUSQs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bLv0Ot8X;
	spf=pass (imf26.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777534735; a=rsa-sha256;
	cv=pass;
	b=T3IAPJK+KKfln6XeQf0mZ1/lodmDP3WT6USO5UDjHa7mNzamMopPnx3Jou4cholFrF2WPH
	z5gvGU9Kx7aMAzD3Kylv/9Xyg8S1EB1r8VXUX1Te3gl+z2GPFXJ7MMdthGSGpjDBbc/cFW
	jkvQIx280FAsDfjLTo+P9w49H2Co1Lc=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7982c3b7dfcso6040457b3.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:38:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777534735; cv=none;
        d=google.com; s=arc-20240605;
        b=kXcLatw8uBmtaN7mJAsQpvGws+EunOdkzGMzN2h0mPb2h8LIoso89lM3uJg/1k41Wr
         80xS3liN2uLL1+ZHnRdaaaPJGqdqz9rT2Y67P4TFU5qfltbSHllwNnLnbwkTFfnyo1bA
         ZQP09mfUUBDsQ3G4k63WD1DwUj9uDs1NPvbGzCSqe0JQg+RPcGaVkj53iWArRU2rVIWB
         3RFyepL3R7IL5mXCFSzPy/AZ460NE/vrd8Jfnl/zg0qMxu/vexe/h11kiAgp+kDGtB1t
         o29ZWJzlho4A3xdtThPrE9a+H+/+ppUcMNJHVYTUixXu/cxtGUIH/GroynhiNS6kErgd
         c+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXP0rjq6f9ivjYP+86z3oZz11J3Z1DaKAvZEEb/Awds=;
        fh=IWsbPRsGDOq5DByMAzEdMl/HCiH93HiMbh0iHwn4a30=;
        b=O9Ms5T5+jRCa73fcCZFFKGWU5sigpaieLoidMTJJoHX7ym/ZiDYuf4ZVtB6AubTwmx
         nfYQD0jEKZAK4sxqBwWmmD4OpeckzAugX1/otDaK6oYmx9cAF+fsQUGci9ninwTJX1ld
         bk7c1RyOQZfuUxzWrOecGV+ZQg/vrJSPgABUAE89nkoIRIhLIx5vyriQKBkjqRzUpHb/
         Aqa0h8vj+/lMYB3h75o19ccP/8+hCJQvU7SMoAbpuwOqMm0FMD+LnN4vxR9O6GBBrZiu
         eipw/+d6QofKiEWpLYFRnEb4jc/vv9GfQNfituWMeD8Mrilw6GPsVuzzeoRZgppxgr7W
         8ENQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777534735; x=1778139535; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXP0rjq6f9ivjYP+86z3oZz11J3Z1DaKAvZEEb/Awds=;
        b=bLv0Ot8XVSTsWVFlP5I4iDXinC+YrwYTqAHqHJ0X7QzPhpna5FGwGi9MDVq9SQFNAX
         9LWlqw6CfKBYU/emOM7IMkpgKXW8h7R3DIujFRadEtVRzZtShVVDu5gVUvpHkgL7soAX
         np2HD+BOcfOjhA/+13OmBsBDFvAN8eu/lQ32sjw5vBmJT1pJUvn9Fpfll2WGkDgrfQBD
         OSYvDg7zq3OdJvc6+2uLzT5iyRmrf+R4/t584hHbrb1Qi7bAXvZyl2+uiWzfCPhMvK2Y
         WJCl2wHJfD1bjFY3KeYdBshkp4wa4GshaC0tt1FPCge939rRMSgMSz3afu9TdmUqMjH4
         9//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777534735; x=1778139535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXP0rjq6f9ivjYP+86z3oZz11J3Z1DaKAvZEEb/Awds=;
        b=mEwETS1OVCzYm0hWO6uhhMXtx7eRyDQ374E1vRxwt9DydoJXbx6JUV8uAZ9+4RRLDp
         N1bC4ZOh0WrnJxXnEel3CE3RjHfP1QsjbxYmXYLvveqDRkfaQjUw8c08rkJMTFZdZm+D
         Fp31bgJuwoXzuE3q+0dWT38MtJrUSIMwLoHO2xiWklo7OdGKyOvEQeRWqWU/zcBmwTh6
         kFLxrKpMv2sTDp831GhHjy0TUKpfNV65VKHh5MhLVwvQLuTyKbWmXdyia4pdBAcYen9v
         p8ZC3Xze/LprooshTMqLKaKbgZ5y92cqy76LTbX9pHPZzBW6+J7D79zajdBq5ZucWct0
         feyg==
X-Forwarded-Encrypted: i=1; AFNElJ/1Z0bR/E57wNdbnOCvd/j675igQu615dLYajQ0PTiIkP33K/PsQk3lky7yHs4yw3gGuQ0BKYnGdQ==@kvack.org
X-Gm-Message-State: AOJu0YzY5hAYzOP3prQm6iRhgCxtHWtNsrn/2/SnHjBs12Y98Y6HbWfa
	arw1a4+3xcOp2P3caMkIo3yNG8qESdhW3ql39mpUx3wJ376I7pw4/OdrqnzPHNLB+VOkj8hH1K+
	DQiUw+NbjA5pbqR2rm5s/pEyHrjZYrPs=
X-Gm-Gg: AeBDieuh5IkYhA+PlScXv4UnXbtSADWa2/BlzaaOhMsAoPB9tVXPFM3g55OIgcYPPAM
	B9DgqIq52ZYAZCYc+srLeI+5ir8n/G3gYQ2OEON4duMaW59GbJML/hOdLgi047V8Yo5Xw53EgHG
	mcIaDZp2T+rJ+ATOEGt0RsPpBonrwcaUcOBCvySBlmUGue7JxH4IREO6d6iXdJqOoqZRgf4PUJH
	Ip3Z0U2gC0XTd2BT8VDKA6o4PgXRQRJOuDGE1bJQYRpNcGZk7CQnIke7vgQ2yGXSmMXEoCAX7kk
	aomQQaNuDribR+9hECE=
X-Received: by 2002:a05:690c:86:b0:7b8:8474:1a7f with SMTP id
 00721157ae682-7bd52a648b3mr16570207b3.37.1777534734687; Thu, 30 Apr 2026
 00:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com> <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com>
In-Reply-To: <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 30 Apr 2026 15:38:43 +0800
X-Gm-Features: AVHnY4KrPoCOU1mZFCP1DSbJ1ZSteeXm91jd02ADS1dVFQY0nqpw-GDhCwDxV_A
Message-ID: <CAOptpSMLLz0yzg99nkAp7rxO5RphTDU3Cdqd8020mysijN_Bvg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C38C2140002
X-Rspamd-Server: rspam06
X-Stat-Signature: p7e61j73zqcnmsfbos3q4ycm79u5yqsm
X-HE-Tag: 1777534735-403175
X-HE-Meta: U2FsdGVkX18J4n6nG5kM+cITHHQzvfs1Q526dNWwQ1/uPwve9sta1mdmwd2yUskn4bQTi81/IMqOVyiAJOVSQzwvzrqtuJIXOvEuu2RiwIW308fJo+s+JbmTMEZNYFIQBpJZd1L/CejOYMVwDH7Q+xvEMgLOTGK1a/tCZcDwq4oijGmO6YHcw0vLwaCBbXQaVi3cU5DY3nW44Gjk1yEiInlNShVOlkvY1JrQcoW8cPuo9LiKBdIJ3yu6eCScDCsFj3DMwrDAPL+4vJRDn6L7p8gZj5veB/2ipdVwXTJVnNo2SF0x8Oo9QAaz6i+ttXe0cb8iRmkUIEYF+V4R/SfmJJfRjI8quSU4ncqYN8S650fJolYXbAAFL23lsVaoFXca7gXhTlizkrmiEVPjPfK55MEw6PVx6QmaglAMsiETP4jZqsk6jV3Mr+QP4VvWLErgLqKXtXTRhO5nZZo0f80glv/QckR3GVBU4cDFhN3uNB/YBrAgtoOOsBCA9ep/ErtCpxhkHgf05O0T4t/oG/sfuAnwWCkHZH5CkWidaX3UgnnQBJrNRuV/op14bqjbq/APSJACZuJ1Qr+dYmhQr+wHtREupaTGzBOZOq1fkH+HIVfnZMsirUs4/p9S8ifZiZF8WQI2rxDmQwOOWOfEL7C/fnR7nHrg/VgsXsWuV4AqO7/rgdagqRU565NyCpQau5dETRiEVQu+WVJcdVbvSTSCF7uPZgJfxXpqjImsXpHE5Bup3JZ8vAvct568YA/8HIteznYUxqM9gLkrLV2t51BcS50YbWbst9BEL54bPjDCxo3H9IX4M1Hu79HkojZlFeZNiFRwXLpBFx3dbYxLrpaueGcCNXOGkARIDswfhjtwo9qa7dZD7JTnR/oUinBDKcpL9fEU7uGoit/nGQeJUZNtZm5gH0CIAWUknuuljv7a4f652WRf13N9/DZqSeFajqg4pGd9F4msd9/upMbtgd8
 E75kKFd2
 4wZtBnYZB5Oe5OTi0BB/48eyXD5PvBAWQOM0udi2kleXf+qTzMtEO4Vm8v9qvGF0xItSYy4XtmlN2RVBkgRPL/t2815/e5syerlb1mpZJnZQctETX8vDy+igmzO3/Lhy3yTFxzakI5hMjpseHb00bj+mgEYLXc9kKqJ5UhGzP8dBH6wdh1X1w1anCEwcf/VsUSfAE8P55+H429EpBM0PjCyXFHbi8MCPZ0tNIQt/HQV3b1IzS1dSkcWjG54XOx0s0jVTc76UEu+t2Tbc9YLhpk4xoHueNLp7i1WTYAmg4IRGIEdJ63nVcl1K7wpXGFQhHHDeUMmmDhu27US41P2jcQlJyWYB0aUVUpCrolCpYNwqWN81+Wm6bMX+zskYXbT6n04N85awrnqVTrXM5n4SY8bfNXxdK654MMF08UmXOMYK3HAKI6caSQtv6pKQjCaicH+z/yN1btBj3E+JW0H/L1aOrqVDcACpLTXaNph8grKJO/EPAmunoPNKIHVL/ALDF6yGgl59oLhhP0j3bwwxTzlbSoQ6LsCgvRZSG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 6:44=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > How much of the benefit do we get with just these locking improvement=
s
> > > without having to defer any of the freeing work?
> > >
> >
> > Hi Yosry,
> >
> > Thanks for the review. Great question =E2=80=94 we tested exactly this.
> >
> > With only the class_idx-in-obj encoding (eliminating pool->lock from
> > zs_free, no deferred freeing), we measured on two platforms.
> >
> > Test: each process independently mmap 256MB, write data, madvise
> > MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
> >
> > Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> >
> >   mode        Base       ClassIdx-only   Speedup
> >   single      59.0ms     56.0ms          1.05x
> >   multi 2p    94.6ms     66.7ms          1.42x
> >   multi 4p    202.9ms    110.6ms         1.83x
> >
> > x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):
> >
> >   mode        Base       ClassIdx-only   Speedup
> >   single      11.7ms     9.8ms           1.19x
> >   multi 2p    24.1ms     17.2ms          1.40x
> >   multi 4p    63.0ms     45.3ms          1.39x
> >
> > Single-process shows modest improvement. With multiple processes,
> > each read_lock/read_unlock atomically modifies the shared rwlock
> > reader count, and the cost of these atomic operations increases
> > with more CPUs accessing the same cacheline concurrently.
> > Eliminating pool->lock removes this overhead entirely.
> >
> > This only works on 64-bit systems where OBJ_INDEX_BITS has enough
> > spare bits to fit class_idx. 32-bit systems don't have the room.
> > I'm still working on the compile-time gating to properly enable
> > this based on architecture and page size configuration.
> >
> > > As others have pointed out, I don't want to just defer expensive work
> > > without understanding why it's expensive and running into limitations
> > > about why it cannot be improved without deferring.
> >
> > For the deferred freeing part: the class_idx-in-obj optimization
> > addresses the multi-process scenario where concurrent atomic
> > operations on pool->lock become expensive, but does not help
> > single-process munmap. Deferred freeing moves the entire zs_free
> > cost (including class->lock and zspage freeing) off the munmap
> > hot path, which benefits even single-process workloads. The two
> > optimizations are complementary.
>
> What is the extra speedup added by the deferred freeing
> on top of the locking improvements?

The data I shared earlier was class_idx-in-obj only =E2=80=94 no
deferred freeing at all.

> I couldn't immediately tell by looking at this vs. the cover letter.  I w=
onder
> what portion of the improvement comes from the deferred freeing?

On top of that, we added deferred freeing in the zsmalloc
layer (per-cpu page-pool based buffer swap + WQ_UNBOUND
drain worker). With both class_idx + deferred:

Test 1: concurrent munmap (256MB/process, RPi 4B):

  mode      Base       Deferred    Speedup
  single    56.2ms     17.2ms      3.27x
  multi 3p  153.2ms    51.5ms      2.97x

Test 2: single process munmap (various sizes):

  size      Base       Deferred    Speedup
  64MB      15.0ms     4.3ms       3.47x
  128MB     28.7ms     8.5ms       3.37x
  192MB     43.2ms     13.0ms      3.32x
  256MB     57.0ms     17.3ms      3.30x
  512MB     114.4ms    38.5ms      2.97x

However, this is not the ceiling. Profiling with perf
shows that after deferred zs_free, zram_slot_free_notify
still accounts for ~65% of munmap time =E2=80=94 mostly
slot_trylock/unlock and slot metadata operations.

To understand the theoretical limit, I tested an extreme
version that removes slot_trylock from the hot path
entirely (not safe for production, just benchmarking):

  size    Base     Deferred   No-lock    Speedup
  64MB    15.0ms   4.3ms      2.3ms      6.50x
  128MB   28.7ms   8.5ms      4.7ms      6.14x
  192MB   43.2ms   13.0ms     6.8ms      6.31x
  256MB   57.0ms   17.3ms     9.0ms      6.30x
  512MB   114.4ms  38.5ms     33.0ms     3.46x

I'm exploring ways to further reduce or eliminate the lock
from this path, any suggestions on how to approach this
would be appreciated.

Unless otherwise noted, all data is from Raspberry Pi 4B
(4-core ARM64 Cortex-A72, 8GB RAM, zram 2GB, lzo-rle).
Test: mmap + fill + madvise(MADV_PAGEOUT) to swap out
via zram, then measure munmap time.

Thanks,
Wenchao

