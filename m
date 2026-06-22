Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B446CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB4F6B009B; Mon, 22 Jun 2026 04:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3596B009D; Mon, 22 Jun 2026 04:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2ABB6B009E; Mon, 22 Jun 2026 04:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B74936B009B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:35:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B0518FD4F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:35:54 +0000 (UTC)
X-FDA: 84906890628.01.B159D2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 74D8F20004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:35:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eo4CN7+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782117352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amRTvQzQVD5FHX0htql5S27IXzS9YOYREeyXPs8q6G4=;
	b=AkKaJP/xW/gwx4WDXyi9+8KR3KdKUUiA3x8SkHsBcrrm5RrXkrKfLdvyJvcxAsp9hd3RsW
	nWDRUAjzFbCXn6unpPs6XkzeHnQwAsxyYbZl4kpqhDsb88zwQUnl9RRR9J87ge/P2mV4NK
	PJfTdzHnIBcQyPginYhABAjG32U2VAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782117352;
	b=Df03DTpg6/asQ+z9B+Kpxi2ArkDoh/GfSdTSmwONhvpdwiPwFkGF02OMkHLL/Mx7j2aU8O
	Ae6OgdCjHZAAsXt7cRoDJNtLtmhPhZpH0EzsqO07mAJ7kFf4C4o7Om0QJgs3WtMUFBfkWg
	iKPh5AqX4LnNjS5Pdt9uEKj69o7irRU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eo4CN7+C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0BFA431F8;
	Mon, 22 Jun 2026 08:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AE41F00ACA;
	Mon, 22 Jun 2026 08:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782117351;
	bh=amRTvQzQVD5FHX0htql5S27IXzS9YOYREeyXPs8q6G4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eo4CN7+CxDxlR5UNaPjqkaq9G5Lb4Su963s5J0ghqJJqfvzpzilg0Iv4Wl/ZOY2m/
	 cgi20xIFEI9WO2bJXDJPZ+Ti084DsqUMctYkst3nZd/FAE2op408qe14IvLQPaVl3S
	 qTEDHeLHXodqwdKQeL6k72RAI6YLKr1R3+wSsu+3bgmEjD/YcJ1OPnNW4+V6e07E31
	 3uf5P+iB3zbQ+fEJkh2q5CVN8AGHfKtkoU2Ae1L6EQjIW1q3fVPiYtxLo6GwUGOL/Y
	 pKaYgvPV1ttum9q1wGGi4Yb8Mh4hp+3Gli7v6t7MBWxONy9DsFA1hCM+PJ9h+5q3JX
	 eXFsiQNPk4wuA==
Message-ID: <c8ab2147-c6aa-480f-bfe2-55f095b55add@kernel.org>
Date: Mon, 22 Jun 2026 10:35:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Content-Language: en-US
To: Jiaqi Yan <jiaqiyan@google.com>, Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, harry.yoo@oracle.com,
 osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com,
 hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org,
 william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org,
 osalvador@kernel.org, willy@infradead.org
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com>
 <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com>
 <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
 <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
 <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74D8F20004
X-Rspam-User: 
X-Stat-Signature: bitye97r3j1oc9g47gc95pct7czpx3sp
X-HE-Tag: 1782117352-682313
X-HE-Meta: U2FsdGVkX19Hn2UQqVmOTi2UL6ZnUL3keVs4dChJa+KuvYwOeX0VmRI5Fu3zygA5TqG851yV4WoS+dh9sB95uMpaF5YI0Pr9aqt31tN3wO9h5CrBnAHeJU1VCimV+JftlvTrphW4FJ1WnMVNnaTIvMeu/vhts1SELMkoVuBLKVYT9B1nXKjtyzZMaqZxW94tV9XVXTywkN0CJCzmvQrL6csSFQGBIcXlhyNs9MpIPix7c/BL0G3Jb0bsY3mz8jjWKiPiZThccLdXSA9Tiu4gAhdsyxqas3YGoBAvo1Lmst7nVglaEbe1vax90S9re2CvYX/4TZvn4xHlTVzEcuOtCoREyGGE1MwNSL5uZSl6VO6upziMLh/WswXut1zEOyd9OQY6YveL3Uu63LORPWtzHay2lx5QuMdgSTJeTnfp1TgVhjhf88Bi8aLJnH3TmCfwPVo9+o5pVQjrkFyXP6fsc+5f9IlwDgajek8QuRmdjvUZADUp/8mBE1kRNl1D0a5xucCODK5N7BgOy6q6BJPEXa7vgvyXdFpXFEOITlH3taM0qB3q0JAlP7Bo6X393Lt51MzWhq1N1UaXGTsWaZOfH45g7yl6ugRgGLfUUcYREdIGo8nAfcvM9vhkHcgz3fxWxA8xCUE+oSgUo0vEpTnpuqDbrWU5Pvy97tZ4dRedpOH8dibc0H49BKd26kRlp19lm5N25MRQOJdgG1RXJHnXxYwWxDP+gikSOn4NihUkmx9MvXyMzQDkjS3fSDdz4Quu3SKvij6SejkElXifpbs+feYhwOYTYr8JMjnFe7gGgB0jNrPGPGg75FUUa/uq6JjkDbivhwhSAB+f9xkgG6SDrIMhZIRfjw9Cr06Tpba/Qn2XSG65gjM7Efqb19lL9g6N3smRW8TP0xcA0mfJ/PGfX+6od8HR2s0G/MPdOruQHOwfpGXSxHuP/SvojKQ416kqxCmjWDCec3LZAkqUkgA
 +J9HnfRh
 3+0nxfvK3bZl4sT+pPy7C7UVxA0BrihC9gJXV1Gcm7V5KxlbIWyBkrYnNXDIMZIxVUpnzVFISh7XGuuLoWwJ52FkYBqozhYRU1tYRWZsitCt9OUS32ujoTOdmk+CyQ5pNVhuRYf3zfVo0s5yl+UBNNlaK1o3AtZRRL+cwyWMxf36e8pw+AeVo5tguTVuE4SAiTz1U2CKWh9pkfrL9DjTiO4t37VajTx+2sK+VeNj+j0OooKc9sqc4UF5yhuKjTC+hnAbTZcjkpTrCTzStvEaPBFCjyzyLfSigBF1UDbvqpb7NV7xNqaJae9HtqApwAC/ZSceu8ASJlQEiThu0IzK6fv90NzcR6M1WyMGT9dvBMuytgh3WFqFbklIlAtERgXJowtXeQeymVAIX3hJBupNI6aS8+GQlW5O5p31WaAI0EGF1PFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 03:13, Jiaqi Yan wrote:
> On Thu, Jun 18, 2026 at 9:04 AM Zi Yan <ziy@nvidia.com> wrote:
>> >> when copy fails with EHWPOISON), the next list_add() is going to cause
>> >
>> > I think we should fix compaction_free() (as a separate patch preceding this
>> > one) to not proceed if prepare returns false. It could in theory already
>> > happen before this patch due to a random memory corruption of struct page
>> > causing some of the existing checks to fail.
>>
>> Something like below should do the job, plus
>> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memory compaction.")
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index b776f35ad0200..b2104cbe63477 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *dst, unsigned long data)
>>         struct page *page = &dst->page;
>>
>>         if (folio_put_testzero(dst)) {
>> -               free_pages_prepare(page, order);
>> +               if (!free_pages_prepare(page, order))
> 
> ... for other cases that free_pages_prepare() fails, this is
> absolutely necessary for correctness. Do you mind sending it out for
> formal review (I will be happy to help review).

I think it would be faster if you just added it to your series with a
Suggested-by: or something? Unless Zi objects. The change is straightforward.

I'd perhaps do just a

if (folio_put_testzero(dst) && free_pages_prepare(page, order))

to avoid the goto?

>> +                       goto skip;
>>                 list_add(&dst->lru, &cc->freepages[order]);
>>                 cc->nr_freepages += 1 << order;
>>         }
>> +skip:
>>         cc->nr_migratepages += 1 << order;
>>         /*
>>          * someone else has referenced the page, we cannot take it back to our

Maybe in the comment here add also the possibility that _prepare failed().

>>
>> >
>> >> trouble. Or you can rename the function to
>> >> __free_pages_prepare_and_free_has_hwpoison()? At least, caller knows the
>> >> potential side effect.
>> >
>> > Uh that's long. All callers are from PAGE ALLOCATOR mm-subsystem, it's not a
>> > driver API so we'll know what we're doing (famous last words :)
>>
>> The name above is a half joke. :)
>>
>> BTW, I do not even trust myself sometimes. ;) Just look at the
>> compaction_free() issue I introduced myself. But I do not want to be too
>> pedantic here. So a comment above __free_pages_prepare() should be
>> sufficient.
> 
> There is already a comment about the possible freeing case.
> 
>>
>> --
>> Best Regards,
>> Yan, Zi
>>


