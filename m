Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914ADC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864ED6B0088; Fri,  4 Sep 2026 11:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE596B008A; Fri,  4 Sep 2026 11:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6976B0098; Fri,  4 Sep 2026 11:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3522E6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:33:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8074140157
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:33:39 +0000 (UTC)
X-FDA: 85176474558.03.EDB3497
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0410A80007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:33:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VKDjGhcb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 30OSaagkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=30OSaagkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788536018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYO1KvVzPLClFw7IZqRu5rT86PANfLF01lGRYL9GdyA=;
	b=AjChii3mVYMGUJ2kPp5NGqctDjMIotvrHeP3T0IQyl9XhSA121LT/x9adoEAVpugUlrfNt
	Mu4KOKh8OBZ6R1OKL9RrFx09bqbs2XKzsg+8BhO4T+vlJec9Fzp95JrpaX0WA53wu4nqi+
	y9pnVFzeCQ58oC5/0mvgYV7/aqbuw5U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VKDjGhcb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 30OSaagkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=30OSaagkKCGES9QTMR9GTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788536018;
	b=o4bo2PwjG+7Rfj60ozvRCx/Ktl00KCgLv/zkhvl7hlv1YuKRNfICDxbToSHiVeqr6YkMAQ
	kXH+nSJauwspLdvk5pPJb/2GArvUAXb6VIp8bn5sqL79/6hNWrlXOELNK3Lcqis49aBhFM
	7eaqXgtWHuSkKp1CNu0vWctJKJQFdmg=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a6634614cfso1144430a12.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788536017; x=1789140817; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MYO1KvVzPLClFw7IZqRu5rT86PANfLF01lGRYL9GdyA=;
        b=VKDjGhcbHYxlQr7j3mNDsxs4s0Jg78Ge1QlzbM+fkWur9V8uPeTcT+yG/B1ByGZguf
         NBx6UsPLPGUf2AyUCOx7VmUeJVgoH88qaJWgpmxDYoS+O1YiJ3oroPIj4hQhxw5M38VT
         CY0AJ0DPk86k/b8RTcfI1PcS4MXjyx79tSxjQ4KxHWyPguFRiMccFAutVUBc0TMPlr6m
         NwjqoLrPZ+sHpkECINuX3QjwkN4R3OaKmrPuvVHT8zmGtOZcKhRHTGwB9P9eMtriL/wV
         JDbBDvMcOvo9Cl256D1KM1Vc5O66yK6NADEoY/IHGcwEJ2Uw9G9vd1Ib5bOSqs9sY+2i
         Nq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536017; x=1789140817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MYO1KvVzPLClFw7IZqRu5rT86PANfLF01lGRYL9GdyA=;
        b=nxpQv2VhI67goN/FDWHoGisZ0p4kkhN50ahSGLjPL1z8n1oUAI2dRIPQjuvuDO3IYT
         jmmlKRA9y8fw2XEthTNZTAITiCLnsyv3QCeZE9sTgVMV5imUdx6sCw/IJtH2YY2uJqyP
         fQiTlxXb6Oq/n+GGQg0mP3bobu1XBt/rR8iiZniHebV4UqlkterJWvtFEc+QYGNgBosT
         c0ukN9g/66vyXg41NNEJyrbUHWfbEcZHRcYKTABB+voGvkq9dKYqaeBuoI2XtW1YGKYs
         CL9EKrjF3RDsnpB3W0pHmDpnah9NimGGfqFPtgSZLBMG4f5qpFiB33fmV9/IHrDWWToj
         J7mw==
X-Forwarded-Encrypted: i=1; AKwUvBxjbjtpa8QbZtufc8Qk+RMQgRQnT6DeSfpnjiQ6r8kraapryk0P6uHKo73YbPOthfjsDk8u3iHLNg==@kvack.org
X-Gm-Message-State: AFuF++mohdcIhYZpmi/Igl2oruG1cT0Yh+IzI3RGvFvrMdHYmQY1UkO0
	HggbX4LkRwZbm4QGTsnr5+luigaf3lXaeu12VF7goJZC4cz6LtQQ+flUr59UdqJo3fxmTlXTdaf
	8MV1TKG0kxDGIAD3z0Q==
X-Received: from edj28.prod.google.com ([2002:a05:6402:325c:b0:6a7:e24b:5a30])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:f0b:b0:6a7:ee56:815f with SMTP id 4fb4d7f45d1cf-6a7ee568276mr1201539a12.45.1788536016263;
 Fri, 04 Sep 2026 08:33:36 -0700 (PDT)
Date: Fri, 04 Sep 2026 15:33:35 +0000
In-Reply-To: <925c45d9-91dc-406a-9ff5-8c16f3ee0d9f@arm.com>
Mime-Version: 1.0
References: <20260903155907.1065681-1-tarunsahu@google.com> <925c45d9-91dc-406a-9ff5-8c16f3ee0d9f@arm.com>
Message-ID: <9huz4ig51168.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH] memblock: use binary search to locate candidate regions
From: tarunsahu@google.com
To: Dev Jain <dev.jain@arm.com>, dmatlack@google.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0410A80007
X-Stat-Signature: 58htkohusq4ge96sy56zq66aby5f64na
X-Rspam-User: 
X-HE-Tag: 1788536017-743218
X-HE-Meta: U2FsdGVkX19xqw97DtgJgHR2CQZbKK2OCH07sCdh+VwR/yGQPWdCDA4oovusKaPGHjEKxGxe7ZeOluXHeyDCx25nZNQHwp1oKlsbrZjo8WwEvJwuuMwsTcbJdVWPUEEuYnDSQ1DhVRBKlNUB3ZyvgNhsbJODptwRiGZMlFLBb/B3xc3tkESVj08IoM6pXsuMIUtj570S5Hivl+6M1wShHHqKgr8Jx2Md54IF/39Fd0k4XPzWc69ve3LFPqTuge0mj34e2Mm22nt4/fCbo3DaOvzC4L5jKbgGw0fl3ZpecaZGYMFPkTpw6DJ2st+3cszREaXBiCeEcwpQYc2O6IyO3XT5Rzi4tCeqpwrFgxvXs5rba6VJcYG/zvfg7bPak5sfkatgHTO4w26K660wO05E/0vCOGouz+cOGaTjYVRky6NMtXi/SYILaQep3xvFy4oXgxNNkU/G5FoHwjW/BcQpB/v48tdbhDmHiib7VIbOVYsFFuXihf5zLd8Y57ySp+p9ZaZPhDdI67W87KL1Eli34ksuTg73xk8s8hH1u5ng7VYIIGGhWjwisL9oPYdAvr035koOd7o+FBHtCTuc/1RameLhP9igHFXHLXafbp6h2ZSWPNghkTSMqo9kSWO6Ba0ZEGm4kUs6KKLHg2cGxpYX/kpJyFmqmdUWL0Ls9xGwv8f7ov7HOxKc8dnpZ6h7hx8f4H4B/sVO/nu//TUzQ4+zovJ6q2nlYIp/XeAdjzUzFru1eY3Z+MyRzwlJfu0fhnyriaYmV44bBf8Ju2m6CBtkGy87lAzdcKGpNLyAVwOtuAZnyYjAqNLBRhW9+wEthaHSyPnicjg5FR5tje8iopXaOpC9iWutZJjW6TQphRVwzP6HthIQuPNcrW/KcCmtEVPu5a1Z/tghTYukfXaMv/qL2rIMZ8Yx+DgQb52aOGwPRwi+x9nQtDWiDIhSw5Ojd5mihO3dEX0MRCkqHsbgKJE
 jwqfy0g+
 5Zcl6K2YtFRvkGJClNoeMkyf73tRcV6V67HI70si80dpuafIzIHCdZBGrjZyTCV1rI7BS2kmwASvRDNWC6mEfD3/QEgTkLvCssg6192KeytLBi0AGCYLuuOuyl+aXV5SOPwihvs8CHEX2jTolJboupmIHeIu1IOy3jlmdF9gMEGndxJKf9H6GyK94qv5D2hw/XZOwN1C1FzPh5ZJFcRSkyB9ApW4RUHA67r8ABfQtZlBgy2vf15J3Lgkhdyq5j1FrPAb6cSU7aowMBmjzQ7OanT2rsUSJV7zj50mzUBXD/YPdSoELKK/aVpz0ZOlS8AfrqzDu4Rw/aQd/L8vqmPIUwcRyi8ci2Ev1g+iUDAbrpTUARSDbaDPUu11UvelbB8niFl0I6UpyZqhO6m+a2CzounvJK5DrYMX0z1rYYImnYCUQDXq5zAvKzfTv5m6RtyTxMHoEIw+KtdveK9667eFVj19RuReX2dGNJK3xhz0rpx0R/7TH/ElZ+Y3rmTdR0ZXrNxCG/bGwaLc1TOvD6UZq1AiEnWZPWceneUmG/5Hn1tjGudN1YEyAwupi0PlAbJWGNI11Hk023O+7lL6Mtrhusn8jG4Uy/WzWrlgE6wqaXT+I93VI5EkcjBS93v9YDN0uw403TQuQxrT8tAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dev Jain <dev.jain@arm.com> writes:

> On 03/09/26 9:29 pm, Tarun Sahu wrote:
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
>> 
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>
> I recall noticing this 2 years ago : ) but then abandoned because
> I couldn't think of a usecase.
>
> I have forgotten memblock and no idea on KHO, but are you sure
> this patch won't have negative consequence for the usual cases?
> In other words is this something KHO specific, and in the usual
> cases a linear search is more cache/CPU friendly?
>

Linear search on very large list: A very big problem
Linear search on small list (< 100): Good and almost 100% cache hit
because of next memory prediction by CPU.

Binary Search on very large list: very good thing
Binary search on small list (< 100): Algorithm anyway faster (worst case
cycle 3-4 vs 100 in linear search), yes cache miss is problem but IIUC,
To contribute to latency significantly, the quantity of such cache
misses is very less. Binary search uses more instruction per loop than
linear search, so of course linear search is better in this case, But
that micro/nano seconds latency affect is really an issue here? because
memblock is boot time initialization code. (Except memory hotplug) So No
userspace application like HFT or gaming will be affected by this.

So I believe, binary search wins here. Let me know your thoughts?

> Also below I see you have implemented a custom binary search helper.
> I recall a generic one is there in some .h file somewhere in the
> codebase, perhaps that may be useful, just FYI, ignore if already
> tried that.

This one does lower bound serach:  To find the first element where the
addition can be done instead of trying to find the exact match.

This one has a fast-path unlike to general binary search:

+	if (type->cnt && base >= type->regions[type->cnt - 1].base +
+				 type->regions[type->cnt - 1].size)
+		return type->cnt;

Also, I followed what memblock_search already does, Having its own
binary search.

~Tarun

>
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

