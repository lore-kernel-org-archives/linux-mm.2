Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346BDCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E906B0095; Thu, 21 May 2026 22:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F7B6B0096; Thu, 21 May 2026 22:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3552D6B0098; Thu, 21 May 2026 22:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23B516B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:24:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E312B408C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:24:11 +0000 (UTC)
X-FDA: 84793461102.05.CCC8A94
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id C594580005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:24:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZMZU+Ao;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779416650; a=rsa-sha256;
	cv=none;
	b=QQk3iWHWpAWmipXeGXS2UKw7O03d8U0otDdTVxmgOYLp1B/JcMEHhqRx8otIyVwps9L1xt
	jDXI7cXfrQLIlN8RvXG+IkfQQNBhp+RCFjZMfgZyI1+reEk848wwxtIJf48NOwamOHt+Kz
	Ocay57oDgxDLfEoG8gL/oBSkyTyp/oI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uZMZU+Ao;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779416650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbQIAvOJY9pLyi2McPglRZSeFKk8rXs49yW8pjAXz28=;
	b=slDgB14guwhkjEW2fVBBc9GvaCdbyGZYdWnwbUuUOqd5MMken3eQIwDYiwacdoX0Ph5onb
	0uQ1ebKfoD4Rt70FyVDTjZAEHJR34tPctQz0gPdTZaQv07qiN31XDUxM/yCPzXaFO4zDqX
	/U7E2B5ifTJmkyPhKMSqTaHHtSBOOks=
Message-ID: <3eaa3522-b41f-4e69-a260-ebfd94fad722@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779416646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HbQIAvOJY9pLyi2McPglRZSeFKk8rXs49yW8pjAXz28=;
	b=uZMZU+Aoo7vlKannwgx46GlcQSL2F/RTH5pzZEsYEqWykgwRxE4gNZqt74RlDWAm6osy6F
	bLo2Ip7BZ0E7KU7cgSuPf7rmVGB0VzDpIQoEav/jRZDfpDPxj7XiRQPpMZuOGr6cheBaJ2
	2l45vYcjqlEGnBLjQuuXjIcZl4rx7c0=
Date: Fri, 22 May 2026 10:23:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-3-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260522011908.1669332-3-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C594580005
X-Rspamd-Server: rspam03
X-Stat-Signature: 893dhyyaabwp8yr1kxr5nb5dh3mbnf9e
X-HE-Tag: 1779416649-707456
X-HE-Meta: U2FsdGVkX185xPcMFwPLNvrsndS2s0h2JnE185QMnvWCeTWf0mFH5zeuE5P4Hr3qOPgQ0mpnvuX3PL9LjazhZM5ypl2m8O0eU5XvEXKqarnmotWcE331qusvs9zzfc1j6ltQpxsj/WgOeZKxqQHAyNMNulKHEJ5RRX2Dx6+zTF5wgef8MQp2TP4DDH8laeuPDjZ5uKhyGZdYV4T1LXy2UqmZxke3g4Y6Sxn6k78biR0qiy1fJdncWWWjW1hrGxbE3uKee92diCLZ86RxcHVmBsDWDRlk8NkWsf8ds7g1CSK44o1LeHwtGOyJ8ZzwsEg+/UnjOy+80BoUBI+VrrXLztXtK3uVESt3HkMUmm6p6OUjEwlUbA7G1kb3k4tSglmDmONmiaCyShEB101jDqmQ5cD4fcMbLjyDXye4IJNMJLgfsWHpjaT11CikCOIC/m3fPKoTzynEtHyoGRi9p8kGCLru9Fv34+e1h/kkFgQ+vlNsA9axAdzafjjtlYuI3kILGL4yLI04UGVfxdn9w7uXJCR3meu8HLYTY/yZ1+lIjZkL82lI7oajAgnNVG38Do0HZgHuBP9+NxrMXc0ds8RNdpjHiT5LjLTRoGYJNX+qfewgZIyW0PckWsVy4BLBIf9Ry5SY3dUjnul1mIr/gktdKewn0K1TH2Ki6xeQbRFHuc77ZccJpL7xz1f1Xb2GGVOWJDdSAdQo4moN6I9faX0VFyHdyA6/r2YnW403g7VDSJreFcmv7VuL9rj/fn5sluWetfJq2YKJCKG0oTy18OWVxzzhcH0nmnCpCgHpE6XiulqGedXkztkVDsKKSJjjniwXX13obG6dbF/03AYGgMQDCvrXIx5gqpk3FznuNcmmGYYbSHxcTLrBSs8GY09z0d6vMHYgzVR+EAL2tQEFroZygVwNegikybf3n7znEIC6TM0jUMLhvVZxCUlzx9c4R9wN2QiSTIarUSG9ZDz5DkL
 QvKgbhBg
 H2BiteJdjvfhlfzTr6Ut1YEjY/Zzoa5lLGGApkR4dL3eTzmnNR2dvAg15fCC6adoWNa8YQi+uBXRrqyR79Nepna3UyJVsKP3WRtN9WG61ZBCzzWuGf+zuThvEp+++qMZMLKObyirfb3JVmbVkhb/6A8Q5Gjk8UYw6U0TMicNuQhCCQTrz0nCAeG7oET1IVUyGNee4d1W8dBt/8449mMIULVmFN0O+dFa4QlxFDJ9XL/BeALU4MSxGSd74GuxSYNtnyu6diP807CSPk2YqwpKBIcmqYYRBUGcloqJTIAMuv8Smqr42hV+FCKwouTcihExy6gcg0hsU6JqpMSiiOteNUlQ9x1DtVAF6v38dH5MosUz2JH1fkhX6PXgicw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 9:19 AM, Shakeel Butt wrote:
> Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> shrink the per-CPU cache.
> 
> The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> U16_MAX. The accumulator also needs to stay within uint16_t between
> page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> U16_MAX + 1.
> 
> Accumulate the new total in an 'unsigned int' local, then:
> 
>    1. Flush whenever the accumulator would hit U16_MAX. Together with
>       the existing allow_uncharge flush at PAGE_SIZE, this keeps the
>       uint16_t safe on PAGE_SIZE <= 64KiB.
> 
>    2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
>       powerpc 44x), push any sub-page remainder above U16_MAX into
>       objcg->nr_charged_bytes via atomic_add before storing back, so
>       the store cannot silently truncate. The PAGE_SHIFT > 16 guard
>       folds the branch out at compile time on smaller page sizes.
> 
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> 
> Changes since v1:
> - Collected tags
> - Rearrange fields of obj_stock_pcp (David Laight)
> - Fix comparison operator (Harry)
> 
>   mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
>   1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d7c162946719..e4f00a8159d5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2019,8 +2019,8 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
>   
>   struct obj_stock_pcp {
>   	local_trylock_t lock;
> -	unsigned int nr_bytes;
>   	struct obj_cgroup *cached_objcg;
> +	uint16_t nr_bytes;
>   	int16_t node_id;
>   	int nr_slab_reclaimable_b;
>   	int nr_slab_unreclaimable_b;
> @@ -3331,6 +3331,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   			       bool allow_uncharge)
>   {
>   	unsigned int nr_pages = 0;
> +	unsigned int stock_nr_bytes;
>   
>   	if (!stock) {
>   		nr_pages = nr_bytes >> PAGE_SHIFT;
> @@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>   		goto out;
>   	}
>   
> +	stock_nr_bytes = stock->nr_bytes;
>   	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
>   		drain_obj_stock(stock);
>   		obj_cgroup_get(objcg);
> -		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> +		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
>   				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>   		WRITE_ONCE(stock->cached_objcg, objcg);
>   
>   		allow_uncharge = true;	/* Allow uncharge when objcg changes */
>   	}
> -	stock->nr_bytes += nr_bytes;
> +	stock_nr_bytes += nr_bytes;
> +
> +	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */

                                                            ^

should also be changed to: don't refill > U16_MAX ?

Otherwise:

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

> +	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
> +	    stock_nr_bytes > U16_MAX) {
> +		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
> +		stock_nr_bytes &= (PAGE_SIZE - 1);
> +
> +		/*
> +		 * On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on
> +		 * hexagon and powerpc 44x), the sub-page remainder can
> +		 * still exceed U16_MAX. Push the excess back to
> +		 * objcg->nr_charged_bytes so the store into uint16_t
> +		 * cannot silently truncate; folded out at compile time
> +		 * on smaller page sizes.
> +		 */
> +		if (PAGE_SHIFT > 16 && stock_nr_bytes > U16_MAX) {
> +			unsigned int kept = stock_nr_bytes & U16_MAX;
>   
> -	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
> -		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
> -		stock->nr_bytes &= (PAGE_SIZE - 1);
> +			atomic_add(stock_nr_bytes - kept,
> +				   &objcg->nr_charged_bytes);
> +			stock_nr_bytes = kept;
> +		}
>   	}
> +	stock->nr_bytes = stock_nr_bytes;
>   
>   out:
>   	if (nr_pages)


