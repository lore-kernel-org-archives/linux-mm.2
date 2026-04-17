Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B16F4368A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 10:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709D56B00D8; Fri, 17 Apr 2026 06:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BAE26B00D9; Fri, 17 Apr 2026 06:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0AE6B00DA; Fri, 17 Apr 2026 06:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6DA6B00D8
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:53:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF0641A0BF2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:43 +0000 (UTC)
X-FDA: 84667737126.13.3BBF1FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C2D88000B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwF55n+N;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776423222; a=rsa-sha256;
	cv=none;
	b=LXAW5og0laxXvATYeNrfNgzpAceJJeRdPYX+75qp5NevMfaeTnh3poftrAuA69Q5sy0W7E
	W0qG+CLYz+/7DW/wvUAWd19Aa2yK1x9YEgPpPu3mMCRZ1ece2ktlehZdoUHr1OduWcmnRW
	8zIhnY/TJZls5+mPFxFq75WyWIXW8rk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwF55n+N;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776423222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CPRHzCVwZczzL1L2osDY1EF9Zif9uojBvaIubrLVew=;
	b=rO3W7IJMag4RZondUU3bHW3yffgHnK//kNAUnworOO3zcJVfm9WabWgzyaqq93ZZ+0ATcS
	ucNhWtH+MYlCkNypqEscZY9NVY8RClSJfIEJYh114tpuL9HSZjMEIHu1ySNN/M87qhNjnD
	tdUHp46jToYwljBCRRe/sf4PQes7qQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B7FE6012A;
	Fri, 17 Apr 2026 10:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A6FC19425;
	Fri, 17 Apr 2026 10:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776423220;
	bh=GFbjUd1khvq4RnoviERnXv4yABv1GtkT6p3RCxu6mVQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AwF55n+NYWhqDkXh3qykURtFUF8XHsPX0OL003qZFlT19ogtoQwiywSg2GGfqHB8V
	 Sf48qlgJ/YyOLmXW5Qak3jdeqdOJBQYmWuQnM5Q40NltkVJs9Y3gC60qgbq4RL/oNx
	 cw9xbKTCZNkj/V+lIEhmVy49zIFze2FdTZYJG5/WG6cRCYkepNYM1s453DAnO9+pti
	 5b5YZmTlAPbaV1TsMOpnRW+8JXz2t9z+KOAzXqzje4jib0HAVgBGmo6gScSN3qw5W/
	 3bnLZ7LgE8fEQpoPAWxQI06/d6Yl/4vxY+11nfz53Pi+uys1b3JngJup7MioL9TZ6x
	 qP7ts5Bpbel1A==
Message-ID: <f8171c41-3e42-4268-9717-9b07cc931f4d@kernel.org>
Date: Fri, 17 Apr 2026 12:53:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] mm/slub: defer freelist construction until after bulk
 allocation from a new slab
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, xu.xin16@zte.com.cn, yang.tao172@zte.com.cn,
 yang.yang29@zte.com.cn
References: <20260415165255601BBSSoil3iPkco33RXFtU2@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260415165255601BBSSoil3iPkco33RXFtU2@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C2D88000B
X-Stat-Signature: iwj1co4n6w3wnun6dnorm6pzn3fxzbsw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776423222-906450
X-HE-Meta: U2FsdGVkX19Kv9WHV7Oa9UHisavHlIc/AzR8caRifV6SmRAGJVpihymbrmVigMkbXxpe93Gr2ISIxx1by4IyFFduUh922zyNRfPVVdUZjIzIYjxo/Fmm6UO5YhNTinn/UW3K+vOFz5YitQYjJsn/PruSSYdbjTHb3uQwCqFY/zpsSBjTmB3uplozmaFh0ORLhcIP/dcL01jVKhvyHBgul1XZDB3rdEU4gXObrxzXnbDIHZzl1VlP6FCyEJ4d+Math/wxPdMyYg03BEpoxikz1/gzarTiMOwFV7An6ceQ67PaT3cnQJR9C2uPMHkXR4k10yaBeyLpPXwrKwyIdcfmFtzzFxsicyNR85S9Ky4C8EhDedpGO3b1lisKliuQ+IrWvKnmZEdo44EB1+Mq5Fe/FKIYG+UZFwBM8xr/UBe9faz6+U9jS52WP+cjQWmTwCSOST6jS79S1itygUH8iI1yXQpcETexXPIoUb01CvH4+C2mI8wv+ETuWxE5MOQDD7EyKHAqWT/rGVySsf45kWwjDtKugvxTZy0j+GVIlNtfF6IZDWfS0eplU5wd1+Ku2BW4kLs0axtPGb9MXvjIOGnh6EYUbBqjvUJb8mqeNAe9dv91/9Obro2VVrivHHlDxaDoUYyJkzKZDUtRxdzmHWlAY91L2fgxG+Mo6zCm5BZ75bzHXro2Kv4l6REf8l2rhdDLLa6ZIJHoh3T/nWGVa3YcNW7lCBuOzOAkA/crxwdaxz3dknGSpzoBaXpwOEg2Eobv4NnbYIfqXJUoaqna/O3nC4rek1FIiRXGZDM9VQSYgSHRuxcQ/NPxQYqqfglS37BoFh8g8UI3AIzmI49/gq0N+FxGmH0FDhw+ayoqZviBQAyOOZvCeeypgaTSi+F8CeLO7GJKF5Bi7MfdG33Z2UAHmQaLkpm1eaHoiByRu/mK/YqNq0Mife6zxvDg5FdvpK34FLonny4b6Z6PEDAf+kE
 EYDWF8A7
 7XhuhUhYB2mRl2BrnF64S7H1IeCeN20m85uYJniLhckSbOiahaQtabgXCQnYy3OrTvNqK2Mx0naRWkuCijjuo8zTrC8e8+6y5UbepwCrBUynO7a6yqXDVO1i/DNQDny4SqVT3XQGKQWDQ6qilqsScE46AM7YdwjXusFXbLRCAKHPF1NO4VQ5SMp2nRSX6TNpVJSY/4PDO1vVZ4I9NVtiQkUQ4r9ua55zsyblZMO19aYh6StbwVtiRxWghBrRApOCGFJ0I7gTF9mZkbVuAhtVnnt8mDjU0yi6QrAnMWUz+NRPM0jJ78j0nXqkjNU1ZT5+TICl780WlY0iPJs3g9zyVm9oVdsxb/EI9AR7JQsBS2y7CUyGW7peE/P11PIiSd9VKWul3deYEYkRNL+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 10:52, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> Allocations from a fresh slab can consume all of its objects, and the
> freelist built during slab allocation is discarded immediately as a result.
> 
> Instead of special-casing the whole-slab bulk refill case, defer freelist
> construction until after objects are emitted from a fresh slab.
> new_slab() now only allocates the slab and initializes its metadata.
> refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
> emit objects directly, building a freelist only for the objects left
> unallocated; the same change is applied to alloc_single_from_new_slab().
> 
> To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
> small iterator abstraction for walking free objects in allocation order.
> The iterator is used both for filling the sheaf and for building the
> freelist of the remaining objects.
> 
> Also mark setup_object() inline. After this optimization, the compiler no
> longer consistently inlines this helper in the hot path, which can hurt
> performance. Explicitly marking it inline restores the expected code
> generation.
> 
> This reduces per-object overhead when allocating from a fresh slab.
> The most direct benefit is in the paths that allocate objects first and
> only build a freelist for the remainder afterward: bulk allocation from
> a new slab in refill_objects(), single-object allocation from a new slab
> in ___slab_alloc(), and the corresponding early-boot paths that now use
> the same deferred-freelist scheme. Since refill_objects() is also used to
> refill sheaves, the optimization is not limited to the small set of
> kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
> workloads may benefit as well when they refill from a fresh slab.
> 
> In slub_bulk_bench, the time per object drops by about 32% to 70% with
> CONFIG_SLAB_FREELIST_RANDOM=n, and by about 58% to 70% with
> CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
> cost removed by this change: each iteration allocates exactly
> slab->objects from a fresh slab. That makes it a near best-case scenario
> for deferred freelist construction, because the old path still built a
> full freelist even when no objects remained, while the new path avoids
> that work. Realistic workloads may see smaller end-to-end gains depending
> on how often allocations reach this fresh-slab refill path.
> 
> Benchmark results (slub_bulk_bench):
> Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
> Kernel: Linux 7.0.0-rc7-next-20260407
> Config: x86_64_defconfig
> Cpu: 0
> Rounds: 20
> Total: 256MB
> 
> - CONFIG_SLAB_FREELIST_RANDOM=n -
> 
> obj_size=16, batch=256:
> before: 4.85 +- 0.08 ns/object
> after: 3.30 +- 0.20 ns/object
> delta: -31.9%
> 
> obj_size=32, batch=128:
> before: 6.89 +- 0.07 ns/object
> after: 3.74 +- 0.06 ns/object
> delta: -45.7%
> 
> obj_size=64, batch=64:
> before: 10.70 +- 0.17 ns/object
> after: 4.60 +- 0.12 ns/object
> delta: -57.0%
> 
> obj_size=128, batch=32:
> before: 18.69 +- 0.26 ns/object
> after: 6.54 +- 1.30 ns/object
> delta: -65.0%
> 
> obj_size=256, batch=32:
> before: 22.36 +- 0.24 ns/object
> after: 6.61 +- 0.09 ns/object
> delta: -70.5%
> 
> obj_size=512, batch=32:
> before: 20.59 +- 0.36 ns/object
> after: 6.90 +- 0.15 ns/object
> delta: -66.5%
> 
> - CONFIG_SLAB_FREELIST_RANDOM=y -
> 
> obj_size=16, batch=256:
> before: 8.77 +- 0.11 ns/object
> after: 3.63 +- 0.09 ns/object
> delta: -58.6%
> 
> obj_size=32, batch=128:
> before: 11.59 +- 0.31 ns/object
> after: 4.24 +- 0.12 ns/object
> delta: -63.4%
> 
> obj_size=64, batch=64:
> before: 15.58 +- 0.51 ns/object
> after: 5.32 +- 0.11 ns/object
> delta: -65.9%
> 
> obj_size=128, batch=32:
> before: 22.13 +- 0.63 ns/object
> after: 7.39 +- 0.20 ns/object
> delta: -66.6%
> 
> obj_size=256, batch=32:
> before: 27.12 +- 0.74 ns/object
> after: 7.92 +- 0.08 ns/object
> delta: -70.8%
> 
> obj_size=512, batch=32:
> before: 26.92 +- 0.32 ns/object
> after: 8.28 +- 0.26 ns/object
> delta: -69.2%
> 
> Link: https://github.com/HSM6236/slub_bulk_test.git
> Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Tested-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks, LGTM. Will pick up to slab/for-next after 7.1-rc1 is released.


