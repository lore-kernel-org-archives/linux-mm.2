Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A72ACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29D26B0092; Wed,  6 May 2026 09:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA2D6B0093; Wed,  6 May 2026 09:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF00F6B0095; Wed,  6 May 2026 09:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9756B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:55:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49B628B463
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:55:28 +0000 (UTC)
X-FDA: 84737142336.29.EC55C97
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4967B40011
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:55:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mo8z5cA1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778075726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNRy0S6L3YSzMl7VPrdeXJU725FCyYdB61hcQ1UpLhI=;
	b=28oD8M9ptG98EwpWG5Hd/nfOdvO7m/1DO/4YsMkxz+InmOm0LhNNrYSXrdLiZ/DCc3YKgC
	mfnSvgVIe0QyTZVujHnonqL0XTb5RMMBGDiRnbs9EMXNldWLJFbH9dmOZy8VHo4LzKux71
	+nCUe2tbVkMI3qinrhRVqjfN/dLyE2w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778075726; a=rsa-sha256;
	cv=pass;
	b=pPSFQ2oQZ5THuKV3lKZq36hsxjEKv/y8+5vXuOFGqtPyIMjJygqrmd5B+0atgfKndPO/Wi
	y3RlfR7X+CqIr2zmIxPhkwS3kYcyLh2PCB88TYJEp0sJ+JxisfAUCPoyCLBxkBYKBnW2QF
	jJuiIZzPXUHlzULi8uyh/PAlcAm0sp4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mo8z5cA1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79a7109f568so71977817b3.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778075725; cv=none;
        d=google.com; s=arc-20240605;
        b=Xwe2fbf8aBGu29QsjFXH3nzd/4msBPMfZvQx67kDy1LeVaUtYJFvnxih7Z2q6yg9kB
         5AA7IKwI1hhaI9bZXDzvL6pxdE27UTYSYjhjhTGrNSKLQEuPfuBoMMAbdNynNo+fYzoK
         7VmIVNs54y+/xNkaX6/B1tbaZZDmeqGrO+4i7dWkkgJy40LwyO0pyFT8hkc0enfKy/5j
         5q93C+vC4mf63L5+1HnxHJCX/lP8YOfl5CYVFrtESeuMyz3angYYiXYTFMp2Fk99pDUz
         W+M/sLNfy5FlYL398E7jB4RCtq5IatmCM0hMx07MeCFC67/xO42mhiBdt8SheIDXrBmh
         mPkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aNRy0S6L3YSzMl7VPrdeXJU725FCyYdB61hcQ1UpLhI=;
        fh=82rOkKhBlbxOgaSdnpDirtgseAkKfZbocehHyWrezfk=;
        b=e+mZ9FxE0PVQacBE6+RyLyN/d9YQ03xyoM4XGVQEzJb90fdZT8Plbu+etuIxyDL7Eq
         SFupnMIj8eixDOWaIuYS0XRgFYLiq0QczBnK2nBOqR2wllMkW9fXcvWTkcZdRuPmjyL7
         Ib2q/Hap79JbjEInQ6WAxVics69RlQuILoxtstrBRj30Lfm9AuIUAGpqFbIAUR3Qr6S/
         9f57bpUX+JtZe81bQOpXVG7Dhi2WQvgkxrXS9NdwjT7mtnJgll0BAWNWu1znK8sVeFMy
         77Pl4sH/EH7ADPRX2WGiTJgnhFLD541+LAiCnPBe5M6gjS0sHCkNkWiq0IUlRuVyCJ8K
         99eA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778075725; x=1778680525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNRy0S6L3YSzMl7VPrdeXJU725FCyYdB61hcQ1UpLhI=;
        b=mo8z5cA16zzwI6fzA2D4Afty250JI5J+Dgpade8W2GzN0tyLL912zTFNfUisPsc+77
         SVRwxDXPvCaiwuZo6iVlnRJtj4BM4tRUSWP7apkYL7vIYfb8JDWpFW9fQqIAYW44C+Xf
         xhjqgDUOD/q0/3ote0PFct0sreeDBzyvb4PcPK2RctIUrhHLUBJ34j2Hlnu+LMMLBOxj
         wA5atKGkWGHC+RYxfVe3sxxrhhyv4Ei6Mw5OO0Wlp7CB0TxY87CSS4+S3kJvgsDNXL8j
         kGz0gogwN6t6on4KN83UHbHzlUXZl6t7VJ1d32VoHrfGJvuQLPZ3/G0K+SabYKMlWphI
         iJUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778075725; x=1778680525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aNRy0S6L3YSzMl7VPrdeXJU725FCyYdB61hcQ1UpLhI=;
        b=cZbDTFbgEqr4nCCGIHKK+KuMIHZdtx3HCTOaH1uT/FOxxsSy30g6/ohwwPSsMgKsEK
         +1DAuXAxit/kXrlreLp/AoyXagoJCV9R76HWb+Mr8+zqcO/6e4Aj+HfwgOFcXNg/9oX3
         zEhWW1gFd89FmwYqanKG4s73BsN+qHRNdaKW4/rgex7H04gCIJveSeMN9wCt4N6LHymA
         i+C7nKeJMaViaDrg20NzI4PM7iKXiJJYxyyDu4LHHf+T/sQ33/9DE9EvUOXQyFwxgdmA
         /W5dm9LRj62u3MB8t+LFmsV7GPTBXsQsOcpqU9bg3GL8oKD1phZvQUZKnKBNVMYb3VVI
         bxgA==
X-Forwarded-Encrypted: i=1; AFNElJ87b6g7lepsTCuOJF3wzJXLIxt6F3AaT2Cn15ft+YUQdEaVYRjoxhYrlISD4dt7jL5+WKV19TGXZw==@kvack.org
X-Gm-Message-State: AOJu0YyCN3jK2hozUiDQv09oaMZl1clvpg9nX++PcTKCrco952DLFqZD
	rl3s+bjv894slo4AyNO23EFO5csSNWeqRh6OzY84v+supKu0CAYu5TabAqJ3XOrCsnwoP0qtXlD
	kt2QsRWT/1cWNzb0OT/mG7o5yC2l3SxQ=
X-Gm-Gg: AeBDiev0aioFhYSCwTySF1L9YO2IBE2NbGPrTZ2ZACxM4oI+9KGxb+Z+g8xwt1Zzs9+
	9JIKlPZxzDrqxiAs+GGHH1VJ4IivoPWQDX0AJBvDEKn/lHpMWtRLUSY6YhPoH18zj6MsK3v7hpW
	nRdlvGzneOTkSOYA99PP+okMvUNP6i0qMKkAjlI2wYY0jdJtzbsyGFsSPZsY+Tkm26WA/+UM/eT
	EjCW+f7yZGGmfx5Ye4RzWxBNz7tbEWNCSrlhs3qF1KMReOg46Nf+8ECJXvLCP3HnUShTfhhg7Ju
	ysYpNNhVR8x3+Q71P2u4BK/vCHmdgg==
X-Received: by 2002:a05:690c:f06:b0:7bd:9ce7:164c with SMTP id
 00721157ae682-7bdf5ef293amr42572997b3.43.1778075725139; Wed, 06 May 2026
 06:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com> <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Wed, 6 May 2026 21:55:14 +0800
X-Gm-Features: AVHnY4LF3aWQo3HGLZrYMNvLGHmAQYHlyMw97GRdhJ_YEuxrndl8XeHVPrQ1D64
Message-ID: <CAOptpSOnRCHo35KK5x3S0f5y9+7+dxfznpjNRH072jZvhYHwww@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4967B40011
X-Stat-Signature: 6jofrho33sr76szp78hhkcw6e5m84ier
X-Rspam-User: 
X-HE-Tag: 1778075726-835737
X-HE-Meta: U2FsdGVkX19hhd3ZSZMEvWqRw8elFCCsV4njGPQSP+0Z1JgEHLu08e/pC/YjrYA2c7ufzLKlTQhqAMYFf0NIbWDExzNkVkFGatdgEq9oLr5gcxkr+Cl8ekKEIqbPjz3IvUtnyITQ31R20P1y8mDnlGLZ1E3Q95RkCHNsjdLiYj9Fi7TxSXwz+rue7dciz0I2mhC7vKg7ebEVq4LOSgO87dpBRVy/+PyGknoZKPGfuj4sHKhyyeiWL85OYP43pnUe5jYsytmnRc5uwtuxGe0CxfuAdyp5KP8lxGDIa/zfZvjg0yOmEvGj614TZywB9Pqm0fCMIaV/J4k5rzeWffy9IcC4RhxTAvmaLwcO/gCE0YicBM21WnDYV7l82lDEZS3yPYm21i12NcFTyLzmuWZs4HD+gyLhEXbjUUjYAUkl/cJmTYr8E7KzcfU25kbJfncO3oaQuAqV57qmvNVxzisx6L9kJ/+0VV/wKvx/dja7iF82E/xHLeVCiSNj5xk48oTGYvOZo/ssHVD5Lrf02ZNd0cBGhys2krWGoL/XzHjWvG0qftw9BerWcGcTSB7Vc7EjIgwHQZznMyvhr6EpIWMw6Uq5JJ+wXcvMEIjFEOBWHRrKufiZVvpB/e5IV5HAPwD8pTiqyQDQ+5myhe1LAWHbl4BGSvkIky6G1EtNXuKGrPbEmtEvLIg5n9yaPiK2zI0ImYYEgUDt2ipW87MKIQ20ihE/qM87I6juVauLCVaaKNggAQWCFXoLoc0wZtxrs3DqrzeFKoMPAEPDcyXxfOUiubvlfgbWqA0uUroiJMHydl3IPlfjKyTR1KJcuw1SLoyIfpvNAjAtCiQelf4c1g2PFx5nXK9VYlvyptl9r3soZasMw8ExWtzRgTf9iQfmbs4ab6cfdBVs1J/teu7WTZvPnLf62ri44y7vifHFiBGtSS1NLXAfhlw/6GBdLz6VWkPqvGeLW02sDjMStqFanZi
 oSqecz8u
 grSxeQYGMDLvdHDG8CONeeCCHJIm+7d3MzSm0wQgpeQ1iAQMXIqu2ov+I81chfczaQeqH8L3Fmq9udPjNPHmCgeoPIS74qdL6uRFNFL530os/lAQRCGA0set/T7yr6bLtgtKXx2UtmQrpIh8CLpD5hfIGwA+/n0U+sSUnp5yP1L3wv7tG9PRp44QL9vufawpvaOOS7dcpZgOuZ8Kr5IuO/Cmw3jbZO5PvRO9cKk82flFZuxhlFvrgTji85R/cDVuRpIf9FvwVQ9Mvf5cbwNKE17wzEHf1J85+z6PZjeGAGvf/AVZFueztyGv/QnNcBXN7tdItLFfHL5CveR1eZ9fcxFPd+a1VBii7uNxSDrExhw/m+TC+yEo04Ejnbxi/syiwRIRkvpP59nj8//5AgTiF1UHSYW3tZfOOiZexK4ZxauReuE8CyXl8nC/FYh09FmHFeFoL1aD0zZPo+grEipfPmlCH1/fkdxBFhox80uzk3X/LaXGnwG3npqJ6gYcf2/AOVsrxsxLwetxz5cgG0LDNfcSjww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 2, 2026 at 3:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
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
>
> Oh man, you are eliminating pool lock here right? This would help my
> other patch series a lot too :)
>
> https://lore.kernel.org/all/CAKEwX=3DM5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf=
1Fe=3Dgzew@mail.gmail.com/
> https://lore.kernel.org/all/CAKEwX=3DPkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BNNA=
8RboOFDQ@mail.gmail.com/
>

Yes, exactly. With class_idx encoded in the obj value,
zs_free() can determine the correct size_class without
any pool-level lock. The lockless read gives a valid
class_idx because it's invariant across migration (only
PFN changes), and we re-read obj under class->lock to
get a stable PFN.

> Well, the deferred freeing would completely move that contention out
> of the way lol. But this would benefit all users, regardless of
> whether we're deferring the free step or not (for instance, this will
> reduce contention between page fault and compaction, IIUC?) I feel
> like you'll get some good numbers testing in a system with compaction
> and THP enabled, with lots of swap activities. Which is... a lot of
> server setup :)
>
> If the deferred freeing is too controversial, this smells like
> something that should be upstreamed independently.
>

Agreed. We're planning to split the series so that the
class_idx encoding + pool->lock elimination can be
reviewed and merged independently of the deferred free
framework. It's a pure win with no behavioral change
=E2=80=94 just less lock contention.

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
>
> /*
> * The pool->lock protects the race with zpage's migration
> * so it's safe to get the page from handle.
> */
> read_lock(&pool->lock);
> obj =3D handle_to_obj(handle);
> obj_to_zpdesc(obj, &f_zpdesc);
> zspage =3D get_zspage(f_zpdesc);
> class =3D zspage_class(pool, zspage);
> spin_lock(&class->lock);
> read_unlock(&pool->lock);
>
> It's basically just this blob right?
>

Yes, that's the blob being replaced. On the
ZS_OBJ_CLASS_IDX path (64-bit systems), it becomes:

    obj =3D handle_to_obj(handle);
    class =3D pool->size_class[obj_to_class_idx(obj)];
    spin_lock(&class->lock);
    obj =3D handle_to_obj(handle); /* re-read for stable PFN */

No pool->lock at all. We've also added compile-time
gating (#if BITS_PER_LONG >=3D 64) since 32-bit systems
lack the spare bits in OBJ_INDEX to fit class_idx. On
32-bit, it falls back to the original pool->lock path.

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
> +1 :)

