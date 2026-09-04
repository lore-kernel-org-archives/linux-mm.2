Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BBEC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32366B0088; Fri,  4 Sep 2026 10:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBF56B008A; Fri,  4 Sep 2026 10:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83B06B008C; Fri,  4 Sep 2026 10:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828956B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:51:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F05101601CD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:51:16 +0000 (UTC)
X-FDA: 85176367752.08.FDC8AA3
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 293AF40002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:51:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lT0+5QON;
	spf=pass (imf12.hostedemail.com: domain of 34dqaagkKCF4P6NQJO6DQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=34dqaagkKCF4P6NQJO6DQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533475;
	b=pTJ209Ta+0WpGGaoIW9R4YiNjv144EIxUWB4OSaQuluEOIG4Y7qcIMAHI0fhsF+DCLJXrD
	PO1EfPxRkx9KYDwVbPwGTEoZkxeoiZx5lnIH0h5Ze/YteHjbBhsrJjGiZqlFK2zOouoQh+
	EG9hBmAtd38vB1DESLj3chXbsDdl5tI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLY/ci2oR2yKic2vb+sEbJUZ8whxHO5esQUdSjd9KzA=;
	b=B2VSXQqogKZvUf489kSwPgT8uxZVvRGJDRPh1N39XGzBEpoAotGlqaEFIQqU0GU0+9ssTH
	oBCP+oDXj68oKkqoMw7wZtEPnH3NTLFnutBXmdUK4KrBO0kW2QRkcIbvgF0rlX8aujgl+b
	O2xAkCgF4KnPgv2b0A48IKMisf7KluU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lT0+5QON;
	spf=pass (imf12.hostedemail.com: domain of 34dqaagkKCF4P6NQJO6DQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=34dqaagkKCF4P6NQJO6DQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a18e266026so1071119a12.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788533473; x=1789138273; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mLY/ci2oR2yKic2vb+sEbJUZ8whxHO5esQUdSjd9KzA=;
        b=lT0+5QONhMHzyq1xLrvoLPVwAb9Yz/6H6p8Yd4Z9W4PfKBJTuKSn2KnZk38uadIAz9
         jIk+WwQ7EnqRZbPUrNDlCxh2tClmOzhl31x8DJBK1xjFL018inhVCa/iFt6ZAMUpW30P
         FE7w1qXoaTZrPhy+QEAePHh3uhQOqmDerjsIWm2dKL22NNs7NWoiBYpRTDKj9L/IJdIb
         br026sNV55GbwkpsmxUDM3NvrLI3OmZn4gTUfjYy955ptqJWwW77YK0WTaZ9QxYwrmPs
         zfQwkrEraCDCeScmw2uHUh2HVfXhv3VWvYHnViQdeq97SHwbqSXXp3P8YBjcSOC6nlQt
         ma/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533473; x=1789138273;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mLY/ci2oR2yKic2vb+sEbJUZ8whxHO5esQUdSjd9KzA=;
        b=eV/OH7/QpL01Gp2KFV2nB41MEyXHvXJPsQETZHVCLYIdaxPRibp9OUI69IwfXX2n57
         T7Kb094cps8BrasvdeOPu44K5tZolc5yHMBNotYxdl1E03Xh9+YDET145708FiVCpvxo
         PPvTq7HzhlXq9O5x5F9X1PhwEnl6VCDVPmafbvJdgW8A21eg74Gmwwdg1z24cVtFzYLQ
         d6wvtGcvQdNOZM7SiYShwPyXJdhJR9lV68PQ/x7gmFh/tcbUraPU1znSVauv8lk1f4ef
         djRqJ1IjNDLqsWTRnIPI/O+G1yeXDZr0PJ7NTOo5HU8N4lfWQVPczAMjSB7PxwLTyVIA
         cjSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWpPdlwzhL/I49coHjuTV5VgwBScDwaxOH3dkI5hptU0RgoCkEwnihFaTaTyi4oiTNH0SjftHUkg==@kvack.org
X-Gm-Message-State: AFuF++kXbAPfbgmlwISYziHa8brf87mNVid8knONhuzwdvAVbR34e+VD
	dC2CAmuKZfaSgd92sT+c7+2SCVc8OunWe+xkvGf92YYTSIlK+P/sjALxzo6vCZkQEvPrulcxTX9
	wEpC/DCah9QSGLxw4zw==
X-Received: from edgi19-n1.prod.google.com ([2002:a05:6402:a593:10b0:6a6:8587:3226])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:52c9:b0:6a6:32f5:5573 with SMTP id 4fb4d7f45d1cf-6a7e8f94ac4mr2595587a12.21.1788533473262;
 Fri, 04 Sep 2026 07:51:13 -0700 (PDT)
Date: Fri, 04 Sep 2026 14:51:12 +0000
In-Reply-To: <5c223d7d-4f7b-420c-8019-d4f343f0f232@oracle.com>
Mime-Version: 1.0
References: <20260903155907.1065681-1-tarunsahu@google.com> <5c223d7d-4f7b-420c-8019-d4f343f0f232@oracle.com>
Message-ID: <9huz7bl1134v.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: Dongli Zhang <dongli.zhang@oracle.com>, dmatlack@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 293AF40002
X-Stat-Signature: 9jiwxumfjoydz7osnfrn88hzus96g5oz
X-HE-Tag: 1788533474-996852
X-HE-Meta: U2FsdGVkX1+Qa5nqVcqoKiWzn6bfEEW5moz+PG500QyUDU0cbVGTrlauHoiDvycazAAwo+xj6Wlns6FwFEf6ID/h8j8Y2h/tE2eTmXgrjOan2mNyL/6lR1Jpw5t4cYaheMA6wUAx5OapfqhAJuSKFSaFAFLmZX8+7xDgl8oe10krrnjH9elJSByNKpy+bypvTHAVoYHaC6oQ9z9ySXq8u94Rk9z2itoIV036NxvA0C0Zjjhg79EHFTD4AT/mH2orYNnhtfRYU9EuPIEiMRR4kW7D0WXJSrsI7troz5MwMlM5ofOAcFqQOY5AJTJ8bdwFxy4lmjj1qDZZHwY4Fog2IW5ybSTHU7aPAoR0zBJwhVgbXXFh12aXZe/yAQqv9YlCYBEPC4LQ8IimzX+VddLVSUF2RaeVyqdrcW/p0pLLNEMqxzi/M32LpyG7XyF6ZMqFRu4U0vHKew7mGc9jdxNcuN0B8OH0xL1yAzEfpoYiQxeXhuJBTXSqnDbptzvFGf7Xrj01mJUmn1E93w/2Ue998sZjK6y8YpP5k5hqibR7mhlyLy7sXktg1fXbYo1hnueE817FmcqWug/1F5YIB9j5zltsoNk45MH6QWTdZT/huGWjwasLPiCKJx1IrwIv7TlzlgxMyDgWM5uP5+khNrn9nf5l5RTPXL5oibCS7OJeJxbifkjbX0pFYcZfK6WjMhqSMwhC7TBagQRxetSR9mY1JLTFtV29VQ0qlm5JofgVs3QVNHicKX09j0j/G0GRG1T1pFzCC5syPdsYk/+DqwU/x4+6xwAfoxsupxgTux/NK8efePcQKfAL0xWE7fayEChF5cQScfZtCDeLn4Jo0SRtvRCb0rNkaBpwB8wQdsxuG5bsXC7TmsigcVsWH/CymoL6BW8Vb/QRHq8+h0uuwx9It3en5UPoS6I7mooHwJMfNmrOiUpIWLFM7B6BvSnREp3NqS0BJnzWYN/LE8Xnv8z
 CvsNp26S
 JNd6x30R6Z9/ZEZN34GaDWNl0chJO6qms7l/WqMZot2KSNy2MNi4ZYxwm92k+fc1CiGiogomwJ07La195yIpIMlnmlPIaXl34RWO+y4BkBxyxvCUKSvw6uWSTRijSlrXXz0FgXL9bDl7fA1fEuasPhKycV0MqRgwoEfeqBIB+YfdqBt3k8mj/KZgu76/ners1lGaOsg2AY15qh9ZUljXebcNb7XsIgyRqbMufzJ80avcwtz8t+PTL+/cTx+ebgun0zWcnQ3JwDL2WSYyuv5x+yyMch9UMhK0KOoqJG3AX3Bm2iO6GnmeXm5Ribx97nQVS8j9tezBLO7FiiJr8j3lhZrFOJ85gi9MieRLfcbRWt0EvyuuLPzmNsW/O4NkXme8V7+YH2Jr8ZGI9tNBo09nU5+yRIDyIWp0fS70Jqm26+lXYm3+sT/k27/p/GD9cAvra6kqRcaBtejhneh/4Lz/HZ3boiI/vm48UDeG20o7c38j7X5bUM+jICPzznRj/U/N8QYtW0pNMcFDhD640oyQXZUC0e+Jw1lxLcoN236I1bCfNEq1sLhWa/jW5gQZLQw5HpEF7uK+l+h+qNrUsuJWOD79yimXeq0vv/Q2K5bDs8bMrUGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dongli Zhang <dongli.zhang@oracle.com> writes:

> On Thu, Sep 3, 2026 8:59:06AM -0700, Tarun Sahu wrote:
>> Use binary search (memblock_bsearch_start) in memblock_add_range() and
>> memblock_isolate_range() to locate candidate regions instead of linearly
>> scanning from index 0.
>> 
>> Under heavy memory fragmentation (such as KHO page preservation registering
>> hundreds of thousands of disjoint folios), scanning from index 0 on every
>> insertion and isolation results in O(N^2) complexity, causing boot-time
>> memory retrieval to take several minutes (~268s for 393k pages).
>> 
>> Using binary search reduces the worst-case complexity to O(N log N)
>> (and O(N) for sequential appends), cutting KHO memory retrieval time
>> from ~268s to ~50ms.
>
> I encountered this issue with my workload. Initially, it was because I forgot to
> set THP to "always", As a result, there were many 4K pages even though they were
> contiguous.
>
> Indeed, I noticed some delays or hiccups with my workload even with THP set to
> "always".
>
> In the past month, I used something like what I attached at the end of my reply
> to reduce the number of memblock_reserve() calls. I never realized the poor
> performance was caused by memblock_reserve() itself.
>
> [    0.231623] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
> --> delay
> [   38.587378] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
>
> With your patch, I ran several rounds of tests with THP set to "never" (4K
> pages) and no longer noticed any hiccups or delays with my workload.
>
> [    0.247746] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
> [    0.512019] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=1
>
>
> Thanks to this patch, I no longer have to put up with the delays or hiccups in
> my workload!
>
> Thank you very much!

Glad to know it helped and thanks for testing this.

>
> Dongli Zhang
>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c4d86daf86d..03e1f914c800 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -67,6 +67,8 @@ union kho_page_info {
>  static_assert(sizeof(union kho_page_info) == sizeof(((struct page *)0)->private));
>
>  static bool kho_enable __ro_after_init =
> IS_ENABLED(CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT);
> +static phys_addr_t kho_preserved_batch_start __initdata;
> +static phys_addr_t kho_preserved_batch_end __initdata;
>
>  bool kho_is_enabled(void)
>  {
> @@ -610,25 +612,58 @@ static struct page *__init
> kho_get_preserved_page(phys_addr_t phys,
>  	return pfn_to_page(pfn);
>  }
>
> +static void __init kho_preserved_memory_batch_flush(void)
> +{
> +	phys_addr_t size;
> +
> +	if (kho_preserved_batch_start == kho_preserved_batch_end)
> +		return;
> +
> +	size = kho_preserved_batch_end - kho_preserved_batch_start;
> +	memblock_reserve(kho_preserved_batch_start, size);
> +	memblock_reserved_mark_noinit(kho_preserved_batch_start, size);
We can also combine these two function. IIUC, kho_preserved_batch_start
does not overlap with other reserved regions so, they will be mutually
exclusives ranges and can directly be marked noinit while adding to
reserved list.

~Tarun

> +
> +	kho_preserved_batch_start = 0;
> +	kho_preserved_batch_end = 0;
> +}
> +
> +static void __init kho_preserved_memory_batch_add(phys_addr_t phys,
> +						  unsigned int order)
> +{
> +	phys_addr_t size = 1ULL << (order + PAGE_SHIFT);
> +	phys_addr_t end = phys + size;
> +
> +	if (kho_preserved_batch_start == kho_preserved_batch_end) {
> +		kho_preserved_batch_start = phys;
> +		kho_preserved_batch_end = end;
> +		return;
> +	}
> +
> +	if (phys == kho_preserved_batch_end) {
> +		kho_preserved_batch_end = end;
> +		return;
> +	}
> +
> +	kho_preserved_memory_batch_flush();
> +	kho_preserved_batch_start = phys;
> +	kho_preserved_batch_end = end;
> +}
> +
>  static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
>  {
>  	union kho_page_info info;
>  	struct page *page;
>  	unsigned int order;
>  	phys_addr_t phys;
> -	u64 sz;
>
>  	phys = kho_decode_radix_key(key, &order);
>
> -	sz = 1UL << (order + PAGE_SHIFT);
>  	page = kho_get_preserved_page(phys, order);
>
> -	/* Reserve the memory preserved in KHO in memblock */
> -	memblock_reserve(phys, sz);
> -	memblock_reserved_mark_noinit(phys, sz);
>  	info.magic = KHO_PAGE_MAGIC;
>  	info.order = order;
>  	page->private = info.page_private;
> +	kho_preserved_memory_batch_add(phys, order);
>
>  	return 0;
>  }
> @@ -1687,8 +1722,13 @@ static void __init kho_mem_retrieve(void)
>  		.leaf = kho_preserved_memory_reserve,
>  	};
>
> -	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL))
> +	kho_preserved_batch_start = 0;
> +	kho_preserved_batch_end = 0;
> +	if (kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL)) {
> +		kho_preserved_memory_batch_flush();
>  		goto err;
> +	}
> +	kho_preserved_memory_batch_flush();
>
>  	return;
>
>> 
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  mm/memblock.c | 38 ++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 36 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 9ce86349a29f..88940474b020 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -160,6 +160,11 @@ static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>>  	     i < memblock_type->cnt;					\
>>  	     i++, rgn = &memblock_type->regions[i])
>>  
>> +#define for_each_memblock_type_from(i, memblock_type, rgn, start)	\
>> +	for (i = (start), rgn = &memblock_type->regions[i];		\
>> +	     i < memblock_type->cnt;					\
>> +	     i++, rgn = &memblock_type->regions[i])
>> +
>>  #define memblock_dbg(fmt, ...)						\
>>  	do {								\
>>  		if (memblock_debug)					\
>> @@ -591,6 +596,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
>>  	type->total_size += size;
>>  }
>>  
>> +/**
>> + * memblock_bsearch_start - Find the first region index where rend > base
>> + * @type: memblock type to search
>> + * @base: base physical address of the candidate range
>> + *
>> + * Returns the first region index that could potentially overlap @base.
>> + */
>> +static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
>> +						  phys_addr_t base)
>> +{
>> +	int mid, low = 0;
>> +	int high = type->cnt;
>> +
>> +	if (type->cnt && base >= type->regions[type->cnt - 1].base +
>> +				 type->regions[type->cnt - 1].size)
>> +		return type->cnt;
>> +
>> +	while (low < high) {
>> +		mid = (low + high) / 2;
>> +		if (type->regions[mid].base + type->regions[mid].size <= base)
>> +			low = mid + 1;
>> +		else
>> +			high = mid;
>> +	}
>> +	return low;
>> +}
>> +
>>  /**
>>   * memblock_add_range - add new memblock region
>>   * @type: memblock type to add new region into
>> @@ -651,7 +683,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	base = obase;
>>  	nr_new = 0;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for_each_memblock_type_from(idx, type, rgn,
>> +				    memblock_bsearch_start(type, base)) {
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -827,7 +860,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  		if (memblock_double_array(type, base, size) < 0)
>>  			return -ENOMEM;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for_each_memblock_type_from(idx, type, rgn,
>> +				    memblock_bsearch_start(type, base)) {
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> -- 
>> 2.55.0.970.g62bdec98f9-goog
>> 
>> 

