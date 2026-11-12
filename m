Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DF5606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NDeNazzc
Received: by kanga.kvack.org (Postfix)
	id 2D2D26B05B5; Thu, 12 Nov 2026 02:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283716B05B6; Thu, 12 Nov 2026 02:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172E36B05B7; Thu, 12 Nov 2026 02:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE3E06B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:20:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA82CC050C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:20:46 +0000 (UTC)
X-FDA: 85425619692.10.05733BA
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf27.hostedemail.com (Postfix) with ESMTP id B4AF940008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:20:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDeNazzc;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794468045;
	b=TLOF13WVksmQHVJltcy7ryJZzy4DcAwWjcR05MZ1r7FazFqJWAHdjHZUZyTb8Jyed71YLf
	adKwPzcIJ95pJlGdLK5Vsmhd7vzqcStI5tGSYnSGlkFOWr4kQnbblAgsLVXblHOgIj0u5d
	PAmyczRgQwItiKQwiI+V6EcJo+sk1YU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NDeNazzc;
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794468045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GObAzVicUC769Ed2LFARvtfjPhGbRDsMG32aEyAYQQ=;
	b=BEGPdYtQ4+IhyrslmFn1Gb4l5iCQ7oW3hrqZAfJm0bgrY8HzJI1mW+z34xox6CRFDP4xoz
	CB1IXojOrftDZkQJ5GqnzPxv3kJsAIhXtMCY1azNPIx21WRvG5v97TjZagDfyPPONeB19j
	9YMUsStQy9AOA5fFFdklAB+HvyCCrr4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dkOG8X97iyUWtRioal1Da3kor1MkKGE54K5m2vTuMmA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794468042; v=1; x=1795072842;
 b=NDeNazzc2NYXl5wHgkaQxUQ8AjB919HVNYVIb4QbDNHsxv6amVa2cSA00BbntsYsk5cJpkhG
 OJ2C61F0wX2KXAmZL8ZoveY/bZJb47ZUEf0J457Blm9rK99LD3+KE5jdKJHOps6k3nxE7PEcVJ0
 y4tsagCneKvin0hJCa1mXR8M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 93c8f31eebf66027;
	Thu, 12 Nov 2026 07:20:37 +0000
X-Mizu-Trace-ID: 93c8f31eebf66027
X-Migadu-Flow: FLOW_OUT
Message-ID: <5f5e05bc-fdde-45c0-9034-75ae576ebdc9@linux.dev>
Date: Thu, 12 Nov 2026 15:22:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] mm/vmalloc: BUG_ON() on an unaligned range in
 vmap_pages_range_noflush_walk()
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-5-hao.ge@linux.dev>
 <CAJuCfpGMtHZSUhUra9rp5xGvD+L6reopCMb3qXgRSctQ7wnYFg@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpGMtHZSUhUra9rp5xGvD+L6reopCMb3qXgRSctQ7wnYFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shrpct97z3z7jmodx5cdm8rpsursxcs7
X-Rspamd-Queue-Id: B4AF940008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794468044-37479
X-HE-Meta: U2FsdGVkX19eAQUHfAjCqmVY1e1+PyZoLIKuya4wWJ4GeOmH5q7RF70EQ/rTytrEpfCi20Z6M8oGyzFI++XeRpFdhab53Cqr0sUPa5AM6DzZx2tc/tdVNDkTsdnu3GpuGWo8INMRvb96XPQgnQR11eX0HmASgrPXbnX5mqRywb3/CS4iK+Go7hHFgyVhvJcaUs3ApsMQFgu7PEKGp/U7NtFi2O2sgI3E2TXK4u/+8cRKXDGCk0K0E2CXHrMzcFNUndzeycxhOKnGqNUo7ObPIXCxkJi6IhiTDMXJ/g1ZhBlqcZg7R33C/fzbL/lWzyIuVqEzMqec5JpQP0inLq8PNaztlMFDtCU0x+G25yGORu133GkeuQqhAWMH7yZexyxUw42f4Tg0MX9rLNoc9RC+1LngJiKLBjjfFuCokNqVqIukYkK4qyhHesOUYoiqMSfRcPusFyZ/dhKGG34Yw8s7A/2fzDul6PU6b6lmvcO3cH8L/nScNoj19BuTkRnYQFufJTQZRtDkzrMv6QMbsx/ZsiYDeIx4yf7jngkiGA2xkKn5KufD0A6nb1qiARFH4j415otchw2Qdobvgg1jvdeqI4QKICI6uRB9eMaf4XxI4iOXubuK9tYrVPT8YXsVmYWP9oWSHAwxQH1I04k8ZavFizzOBovK2C5FdtBFRo74VQ5cN87B8+9bkE+L4KAOlzu1por3Ez19PQPR7jmwZ3m+dKDHFUQZK97gomAg2zfrFR8iXoUWmM4WuDS2ZTGE9ufb/jS92fykbhNCiQfe6hKjHPQKxJyEHpLY9kbyn+4ieHd6Slo03jVLPL07gmt+gmRhjOHUYBwo7bk9dy6JAX3o2oy9qQzGEFTh7PBp4OxIDHefObjPSFoYJ+AHu9Gz2lLxsKqbsSOJy2j/V82PkW/KUAqWEEYEjyW5NDLPDaqaNa1E8dpmMErRa9LiE+RUO9hJXcsaosK8TCbsNLpVABt
 HASgJZce
 nkNEZQ1dc29b72zfCcoff++48yrIEAlmkJwx0dqmc2U9BFd8dpKCpqO6Y4A5DRUWJ3ikUZV0mVgyKXYMLJdPKkUd+5szgU0CjzbsvjJ2FLDA/tpEOkJ33VEwwJgikEWyc14nEO6YVF5u515r3UjK4eukYua26o1FVWK/WXwhaU25/tEHyqasYeE85FJ6M9WjtlrZOfShl9aaNA4IRkdoVJCVbNzparJgOCDouPBiHi8swhyeN9CZzF8l7RFJuKx852J8dMkBcqh2ASx9tvwPMwIyXURAGoz/ZwdyiIAreFPSdxHCWQ4kabQsfOukgEj7qQXZdO0smUHP4pFuWspJIUsUsBz/P7J2Qgx3lNLDRf9cJs3Ey8NfB1T3Mhv6mRbvgLGKCsbjxuxDbuIeqDsoktgANvHM2ZHHB3LKM9oOkxKv/Uz26OqSBDbHod/08OPVrQs6S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/12 08:16, Suren Baghdasaryan wrote:
> On Tue, Nov 10, 2026 at 11:24 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> The pte loop of vmap_pages_pte_range() maps whole pages and stops
>> only when addr lands exactly on end.  An unaligned end lets addr
>> jump over it and the loop keeps mapping into whatever follows the
>> range.  An unaligned start maps the page below the range with its
>> first pte.  That corruption is impossible to debug afterwards, so
>> bug out on addr and end at the entry of
>> vmap_pages_range_noflush_walk().
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 27f2674a5556..86fbb1d2b27a 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -698,6 +698,8 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>         pgtbl_mod_mask mask = 0;
>>
>>         BUG_ON(addr >= end);
>> +       BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
> 
> Instead of BUG_ON() here can we error out early in this function's
> callers (with or without a warning)? This is a static function with
> only 2 callers. vmap_pages_range_batched() uses it in a loop but I
> believe if we check the original address alignment then consequent
> calls are guaranteed to have aligned addresses.
>

One thing that worries me about checking in the callers, a new caller
of the walk can simply forget. 

If we take the approach raised after my patch 3, handling the
unaligned range with WARN instead of BUG, I am happy to do the WARN
here. Even the BUG_ON(addr >= end) above it can become WARN, because
it only fails this mapping. If the module is not that important, we
can ignore it and let the system keep going.

Thanks
Best Regards
Hao

>> +
>>         pgd = pgd_offset_k(addr);
>>         do {
>>                 next = pgd_addr_end(addr, end);
>> --
>> 2.25.1
>>

