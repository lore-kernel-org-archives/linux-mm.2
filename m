Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22992C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 04:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7EB6B0005; Sun, 28 Jun 2026 00:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A0E6B0088; Sun, 28 Jun 2026 00:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991216B008A; Sun, 28 Jun 2026 00:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5D06B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:36:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D35711A0317
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:36:03 +0000 (UTC)
X-FDA: 84928059006.07.6FCB346
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EE2A18000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 04:36:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LhHpJH0r;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782621362;
	b=y3S21u27eUgch+ECDdUhrVcTKcdUClbWDhPd5/rqDhVXfbc9bQHI8P1H3Ig+Twyq8MWVhr
	Syt1j9LzokyyS9nIpD7qSYRtarwlNjIWi0OkoB7atNbdYH3fe4f5Pyxs6hsTXBIbp0xV0F
	A7Q9pwHhuD5etjer2PGDjf0UfSfLxVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782621362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Wjl+dxNDyYjsMYaLZcgEdyYxld6KBRJroBN1TfCk0w=;
	b=HQDrrQ9EQVs026CTbZggfPyRvy1z/5FbjIh3UEIgVsMu5unnKw+IcKhef72lzN9zCD20ry
	5LLyQpWngyHB/2NWciwrrbJIpUuzbF05eHArumpKlG9RJ4ROFtLdjcbjzC9gLW9afkZbt3
	s8JaQbQ5HIyDKpDAUp+LaGxWr/2WXlM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LhHpJH0r;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AA8F40705;
	Sun, 28 Jun 2026 04:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA291F000E9;
	Sun, 28 Jun 2026 04:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782621360;
	bh=/Wjl+dxNDyYjsMYaLZcgEdyYxld6KBRJroBN1TfCk0w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LhHpJH0rvmw3IgvaFZDaHqDd7tyjuwuh6THoTUFV0BGWlmbT6aWUi7YHoOEBCCKgD
	 zCWuLWmpntHhB0m9hCcyMkMH2n9aMcm8MZwdhDiIj4kaBtpe1RADMuILAKz/7xyYvr
	 e4lj7rY5w7ix/b2csStP3rSoTvdWEhkPKzHMRB8Q=
Date: Sat, 27 Jun 2026 21:36:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat
 Pham <nphamcs@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Barry Song
 <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Subject: Re: [PATCH v6 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Message-Id: <20260627213600.eb072ba84382807a8242efc9@linux-foundation.org>
In-Reply-To: <20260626015003.2965881-1-haowenchao22@gmail.com>
References: <20260626015003.2965881-1-haowenchao22@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gjsaz64hg5fd9q9bcw8n4um9mpdtwbmf
X-Rspamd-Queue-Id: 1EE2A18000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782621361-918387
X-HE-Meta: U2FsdGVkX1+likidKmAQOMN45ad8oiNwxNOUfuHqWHQ06TRqWNczuhSOdFYyLCAJdQc5b4hJQQceg0DE9TWhKN2F+fAlY/bs9KujhIoKm4MnHf1ZZTi7NccrUTb5vE1h+67M/cYx9em5QFq4ZYi1fEl8wPkglQ/M1B1KaIWSpzpVDmIbcd8rAC6n3Sd93l4gGPNKT6TmbGSjplYM6v5mo3iGBZCd32etPfA3bjzTz7tsHSioOMM9YNerRGv+G5pedgReuI8iduXHcDfdrcPAKzImjT8Xu40EbFnn4Y5KuP8iuKbH61YuiZQjavm8iDmx0nVals3bsRhnuBtI3mL8k36Ni6BXBucFg/XfuRyI106UubbABKF8Ib2IrsLp2CyrZIknRqyPYsTiwtr4eKKKmOcbBRif5N8V7Kkes8RT38J6O5KarhehXrWO48h7eDwC4tLZ1tKDpXGAImyQfllkwkZpvk8TcgS+wpsH4V662YGDPAnoTxBCAr7H5mQ6HtmqC1kY/V5wXYmMIWoJOR5fy4dqPozd7rMsuqKKkFhI0aGV6wl5b9nKF6bYNfuqLAe/T3XfgmMjHyNCk3uuuf/jvdkoIhqnvpy4dJEHuVbgCORbIrftvyZgsb8ngRjxlZP2vf0p2V7fCBS33ZgR9RdSYn4HJtAqfdtGzJgGgrw8vUYpDaR23JmrL/alXr3MSAv88TyYhRbPy4n6r/+DjtTWQSKN9+exsE1HiG0JQWlfEddPTScgNhiGG7pXp8ciiEBkm4v5Cc8E4fW2eVygCzXR0huT41Rb2wPnCgBLrpP4yqGi7J8ejJ88pMnMYbS7+qJyLICd66SyuJIWAywt1uxikNbg7armnMGrqUH0gQWcVDqJC6/kP8BHu27RZkeSwJI3QuTYHuUajsuyNnragA1IKe4GR2xrvLP3pkDFozfO5Z9DmIxctJ8Mw5GcV1K0hD0h0vwWWCtTEvGi045Bk32
 6fjQlnU4
 3y7Y34izPZsob7NR4T+Eot9jNKzSuXiRODYnivTzRON7TiWm2mXSeDkuc8rgBzumAs2Xq4Bq+6hvdOGIReck8trj6g/ajZqIJu1oRQKaov9AWV661wp3mRsw+OpE9HdjS/Qxh/eL67Qvdbve5j+eQ90I43Y/+WEtouj5mIkMqiJudb82EWBpeRZpG5m/lEZ5WWN+h1EgPA/w9FpMRb+xcCVdEWR6aIxfjVyZ/k0MqzeqJ4nuP9xooy9/ESEXqp+Ky3G7Lhj2Ni6udgxyl57FVlX8kY3JWzVe0gRKc/4IED2J6g0PcGh24ZGaheGp7lG5YQaiwrehsFPxWbIZvwu7Tqkvlu3ca+mjEikdqpSEp9KnnRuzoBlllHX9f/bP/UH8FpHbwHXfrmEaT6YvBgscB+3ltZ3THYaUIuePq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 09:49:59 +0800 Wenchao Hao <haowenchao22@gmail.com> wrote:

> From: Wenchao Hao <haowenchao@xiaomi.com>
> 
> This series reduces lock contention in zs_free(), which dominates the
> unmap path under memory pressure on Android (LMK kills) and on x86
> servers running zswap-heavy workloads.
> 
> The current zs_free() takes pool->lock (rwlock, read side) just to
> look up the size_class for a handle, then takes class->lock and holds
> it across __free_zspage() which can call into the buddy allocator and
> acquire zone->lock.  Two costs follow:
> 
>   * pool->lock reader-counter cacheline bouncing among concurrent
>     zs_free() callers.
>   * class->lock held across folio_put(), so any zone->lock wait
>     fans out to every other zs_free() on the same class.
> 
> The series tackles both:
> 
>   Patch 1: encode size_class index into obj alongside PFN and obj_idx,
>            so zs_free() can locate the class without pool->lock.
>   Patch 2: drop pool->lock from zs_free() on 64-bit; 32-bit unchanged.
>   Patch 3: move zspage page-freeing out of class->lock.
>   Patch 4: document the three free_zspage helper variants that result
>            from the split in patch 3.
> 
> Performance results:
> 
> Test: each process independently mmap 256MB, write data, madvise
> MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
> 
> Raspberry Pi 4B (4-core ARM64 Cortex-A72):
> 
>   mode        Base       Patched     Speedup
>   single      59.0ms     56.0ms      1.05x
>   multi 2p    94.6ms     66.7ms      1.42x
>   multi 4p    202.9ms    110.6ms     1.83x
> 
> x86 (20-core Intel i7-12700, 16 concurrent processes):
> 
>   mode        Base       Patched     Speedup
>   single      11.7ms     9.8ms       1.19x
>   multi 2p    24.1ms     17.2ms      1.40x
>   multi 4p    63.0ms     45.3ms      1.39x

Well that's a nice result.

Sashiko AI review said ....  nothing.  I don't recall seeing that
before ;)

I'll add this series to mm.git for the next step, thanks.

