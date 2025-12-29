Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D0FD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 08:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70A96B0088; Mon, 29 Dec 2025 03:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48626B0089; Mon, 29 Dec 2025 03:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975926B008A; Mon, 29 Dec 2025 03:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1386B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:26:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DAC95D87C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:26:10 +0000 (UTC)
X-FDA: 84271826100.12.C2E57BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1F4240002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:26:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766996768; a=rsa-sha256;
	cv=none;
	b=7UmWnABuEZgYN91LsM7SUbZNcKpU7f2IStCqM3OxkYibKkARJay1mjjDEJWci3quwg/Pi4
	K0sQLi8M7MV7gelaBE2YJDdXGA1OSqRFWl72h3Ddb/AphoHT8fpCU4txeAujKqgVAysYzl
	7ePIxcp2EehKrqiL2Ds7pDnu2hXcXe8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766996768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lVt+AceWlEdlEPtTHFkxfyy0h/O6liYJEYQ3GX8NhYU=;
	b=5RLIPHebYP3yqNunGOQKK9DvIc2BJBpMWJ/Lsy5lWJawggwxQyXbOfHbG4ufQ9wJmpCDxi
	keiF0YGZe5Ij4duCJznQe6jcWrDD1NDGJ6W6vr1hW7rwO1vkHu6zrrhkiT/b7PTqMUXDNd
	mHBwEqfmGuUj/8ibKvKCS/gSY3lhOuk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 974DB339;
	Mon, 29 Dec 2025 00:25:59 -0800 (PST)
Received: from [10.164.18.62] (unknown [10.164.18.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 924203F63F;
	Mon, 29 Dec 2025 00:26:03 -0800 (PST)
Message-ID: <68ee4ac6-0e7b-4c0b-852e-b3c0f678c39d@arm.com>
Date: Mon, 29 Dec 2025 13:56:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when
 MADV_COLD/MADV_FREE
To: Barry Song <21cnbao@gmail.com>, Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, lance.yang@linux.dev, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-4-yanglincheng@kylinos.cn>
 <CAGsJ_4yLocY3c0oi022b=2Eq2CoxttQMn-XeWuSrjbKPmt5QPA@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yLocY3c0oi022b=2Eq2CoxttQMn-XeWuSrjbKPmt5QPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E1F4240002
X-Stat-Signature: gjkntruoz6amnsr5sdg1rr1oejtpkjy3
X-Rspam-User: 
X-HE-Tag: 1766996767-148687
X-HE-Meta: U2FsdGVkX1/24DdzJSQXCzn8IrUPkksIiuomRgdgT0bQCF1NrGKA9ACazZY6VSHQMqNxeHMrW83uCZxUF/zUc6Kn63Jf4cF5znfFPV98613hqgvij2dD7xa2zklepqUzaYSZ+5XXED5VzL/KSXW5E+Viv3HCG3A8yQNP707YFiN29Gz6MVaxJHrZguGzL8HiyYq19fCTYoo51Palm7+AOt1Mlh5h+KsxmfdNEyHCLbbDjVr7coRQFeckzZ3OquubFni/e9CW56/IIlhZrnB9zj3LWEJ9TiJLw/EFlvq9UZnM5yTWwByKdiKdTPknOQLFSDreo0XbfQvhyVwGjeR850aMmS764cahf+uR/7JHYNL+Yd+fOA51mFfvVM8ByLgJrAdU+UAlcCNagK2o33qCYbOCkb3qQnbj4IVLoN8XeZOGGwCWnQWdS2WmRlRe+Alrm6+61ZcLzTOop3RuBtqbE9M4zZ7C8rUT77DeSpDbLUEYIjEp/TFZp1SS/SpICoOc5GuHug52PcEUWSmZ0PrZfwOoh51ykH1Eu1O2ucsDdPnb8va2bfDg6FKp08r5JQ3N2JgB4dsMtIZ3kKtExIyv1vQj4hBsQKsUquYiX31RwMPHVhrxrc3FnqcprqBKSMuzII+6lFuajwYvFcyGWVU6BPds22WJIZ4RnXqHqnAcy0eMQvHy9naHOxzMr+UQgahf7mk68tHXP3pEsZ2nf4lU3B2RpVQX3GOwncQSF0iebWzKrdVp8wByaoSW0Qsg6UtbVGEHdLg0KwH0AlJVBT57Hhmq6nZIaaBxPdzUzfXDRAg8F1RzRBFRbhLXLXibWp0Hs+jiTFTsiJHpXYTghgYtaWL6sGHykjYgX9F1LQm6X3+zYDAB+5UvMEGYTMKvCrJcWyBz0ef82sjiVL2jh+NLKBRnS0YoA3Yk6tOeJmmWaLXHHdbPxHYNySR6L53J7UnR+LPBJCip9wCeVKEgP1A
 81uw+vhq
 OnqejxE73sXpoGkWEZR/mvAkb59FJemKo5eAb08w1poS2BgLtMi8PFh800Bnv2g5Uk7V5Fi1USEieFKm6FYDnWO3pa2ADhDP5pmoEca4vDzkDJ3iE0Rwzp0AzZZkD6Vhtz1DB1tbtXu/BgVAuS7r+9e2o4GRRKpNOpegnCnRs6IgPZVn0edGIp09gswpdhgKY6aClNdfq47/euvkphXB0WkmK/01TL99tdCBqlGibf0zz3aHDxwGlQMpUsMczg4VXl3y4dPlR+8AAKgN+DbfthFcfdpbYt1IB5G9Uu4vlWHI4t7Pk/jKepi14Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/12/25 1:50 pm, Barry Song wrote:
> On Mon, Dec 29, 2025 at 6:52 PM Vernon Yang <vernon2gm@gmail.com> wrote:
>> For example, create three task: hot1 -> cold -> hot2. After all three
>> task are created, each allocate memory 128MB. the hot1/hot2 task
>> continuously access 128 MB memory, while the cold task only accesses
>> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>> still prioritizes scanning the cold task and only scans the hot2 task
>> after completing the scan of the cold task.
>>
>> So if the user has explicitly informed us via MADV_COLD/FREE that this
>> memory is cold or will be freed, it is appropriate for khugepaged to
>> skip it only, thereby avoiding unnecessary scan and collapse operations
>> to reducing CPU wastage.
>>
>> Here are the performance test results:
>> (Throughput bigger is better, other smaller is better)
>>
>> Testing on x86_64 machine:
>>
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>
>> Testing on qemu-system-x86_64 -enable-kvm:
>>
>> | task hot2           | without patch | with patch    |  delta  |
>> |---------------------|---------------|---------------|---------|
>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>  mm/madvise.c | 17 ++++++++++++-----
>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index b617b1be0f53..3a48d725a3fc 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -1360,11 +1360,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
>>                 return madvise_remove(madv_behavior);
>>         case MADV_WILLNEED:
>>                 return madvise_willneed(madv_behavior);
>> -       case MADV_COLD:
>> -               return madvise_cold(madv_behavior);
>>         case MADV_PAGEOUT:
>>                 return madvise_pageout(madv_behavior);
>> -       case MADV_FREE:
>>         case MADV_DONTNEED:
>>         case MADV_DONTNEED_LOCKED:
>>                 return madvise_dontneed_free(madv_behavior);
>> @@ -1378,6 +1375,18 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
>>
>>         /* The below behaviours update VMAs via madvise_update_vma(). */
>>
>> +       case MADV_COLD:
>> +               error = madvise_cold(madv_behavior);
>> +               if (error)
>> +                       goto out;
>> +               new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
>> +               break;
>> +       case MADV_FREE:
>> +               error = madvise_dontneed_free(madv_behavior);
>> +               if (error)
>> +                       goto out;
>> +               new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
>> +               break;
> I am not convinced this is the right patch for MADV_FREE. Userspace
> heaps may call MADV_FREE on free(), which does not mean they no longer
> want huge pages; it only indicates that the old contents are no longer
> needed. New allocations may still occur in the same region.

+1. Userspace allocators do MADV_DONTNEED/MADV_FREE to prevent overhead
of actually unmapping the memory via munmap.
 

>
> The same concern applies to MADV_COLD. MADV_COLD may only indicate
> that the VMA is cold at the moment and for the near future, but it
> can become hot again. For example, MADV_COLD may be issued when an
> app moves to the background, but the memory can become hot again
> once the app returns to the foreground.
>
> In short, MADV_FREE and MADV_COLD only indicate that the memory is cold
> or may be freed for a period of time; they are not permanent states.
> Changing the VMA flags implies that the VMA is permanently free or
> cold, which is not true in either case.
>
> Your patch also prevents potential per-VMA lock optimizations.
>
> However, if the intent is to treat folios hinted by MADV_FREE or
> MADV_COLD as candidates not to be collapsed, I agree that this makes sense.
>
> For MADV_FREE, could we simply skip the lazy-free folios instead?
> For MADV_COLD, I am not sure how we can determine which folios
> have actually been madvised as cold.
>
> Thanks
> Barry

