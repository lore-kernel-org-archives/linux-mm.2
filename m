Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D3CD46BF0
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 02:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C916E6B0088; Wed, 28 Jan 2026 21:27:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3EE86B0089; Wed, 28 Jan 2026 21:27:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B209C6B008A; Wed, 28 Jan 2026 21:27:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26CE6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:27:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7F01B0FA1
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:27:18 +0000 (UTC)
X-FDA: 84383414556.16.EDA9518
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf10.hostedemail.com (Postfix) with ESMTP id 092EBC0006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:27:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j99Oa7sx;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769653636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb061Q+F4cvQBZq/IQQ6DiA8ZyO7PXBJm0zl3HtzTo4=;
	b=fJ+drpKrZbWHH4kiHrp4XEJR1KXwkXNafQ1ddtR4+K+WOygoU4Kh5CVAcQ5yrQPyuTHdoX
	4sM7H1REkROURKfDz7kq/kzWvcqsxxeATroc3RJVMVV2jqinMTjXpru9IcAzxTqIU8WWJl
	3G5k8A6xGXBmqZbWbHyj2DGxa2InQ54=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j99Oa7sx;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769653636; a=rsa-sha256;
	cv=none;
	b=v3V2hu/rdSAj+6Ib4SVNgTG0RNnKqLR8lkrGvCw28717F2gKup91PumvstrGPNgKOyetyl
	VvNnGrFDfwu8PCSWnRZwK9v5lHqI32D7a+m8EdO8JGbBKV0KO/SctAyjDPrjyj3ZAyMzbn
	1WLzCOORZBVHb7sJis2D2b8ggYxHiZo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769653631; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Vb061Q+F4cvQBZq/IQQ6DiA8ZyO7PXBJm0zl3HtzTo4=;
	b=j99Oa7sxEzZeA6oeOoEbmQrsob1MmXKueEnDd0jLucdOLc/OVzMH7nlH0yOnsh2o7lZeWktY4CLSVzm0KLuFPHe+Cgj3ebBekY5vxQwIxH5yRY1c1YEz0LBlWu6AbcUaBLxp3b1YD9yCzV7PGmHSiCKC6phMyUtlt56RFnfjzZw=
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wy5ZpTV_1769653630 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 10:27:10 +0800
Message-ID: <5db265de-b069-41c0-b8c2-a119dfb83485@linux.alibaba.com>
Date: Thu, 29 Jan 2026 10:27:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem, swap: fix race of truncate and swap entry
 split
To: Kairui Song <ryncsn@gmail.com>, Chris Mason <clm@meta.com>,
 linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20260120-shmem-swap-fix-v3-1-3d33ebfbc057@tencent.com>
 <20260128130336.727049-1-clm@meta.com> <aXo6ltB5iqAKJzY8@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aXo6ltB5iqAKJzY8@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 092EBC0006
X-Stat-Signature: wtmx3678bzuwjqncawjf34nfykpheczn
X-Rspam-User: 
X-HE-Tag: 1769653634-323685
X-HE-Meta: U2FsdGVkX18/V3t7Vi6nbsSRPf3aTHOUROjMylhY0JEgGm6ibbQ8RsqTINtspGiLxxQVrLWarnQyfOni2UvOqdh9IA+YFeoMSFQ3ygADCRcjXykuQrPVYikPwDOFVBRuxrd369LTo/WTSrELIcmNBe+DTnC9x34ooWA2B8OSZkX8IuV3XiyAGd8IHa8XY+WRBoApNMyGtikTcqeifZnnqFqHyFJ2Ft/S/exk7g9cc2yWCd5l0nS9lQVyhOqzwu4vMDb6gsa0ABS1VoNjqwKCTshMUGmsDrCqw0ljKKrreQgU/JsyGaTvrh1P+xZG8MFreJNAX7jzj1k7pmksI6eGx8h8pYm/oDv2a05sVTaQ6Jja9/YuTj452LwhyRKxLun6uZX0kfZg677h+iDsK5GMTeYYQL91/2gcQRMzbLk4BrGecWelckbiVq+6qYVwRGsnpdtcXpk5Bto/79/t+iZr99g/tI1g6DLdbyg6IO2LSJl0TOg5B97R+ePSsE+/hViPTTYXl5NeNMP/fVBFcQqZm2cdegRXA73dcj/hqhjNEhdjnOq1wcjTkP40wYtfkU4ENSVbfMizqHHFrYvN6K46xu2BrRST/xv+smUQSsxUTNVVzGZxx6ck0p57VeLYagEcZOjjKIqZrwrt39GCrasQrjYpUCF+ozZcj/e23fnVgZSNwzDAih/70og2yB3dJmIU/kh9bj9xylEI6orIebF/9kcxsKvBKzDWofqV5jFR1m9naXdH/DgbJ0TFZHQYP4un+gOezojP+0u0I4eRBFXDaCVnOp4HgJXp/7yEkCPfM1deKXiDVIuDSSPonrR614UiEMR+kapaCbQY6XrjDDfI8mIkQpnfVvLFGfJPzi8YCbAxIEGwdanNYQ12nfn20STp6QYep7d4sPB82SrIwzKivMJk9BJEpCI/rRDt17TPxY6U+cVg55SR8G+ARswfdd5ctxVRUV012zs5nTa/AoA
 c18eWCah
 AwSRufPX8wqLvmqT2CWW3A1Ai4AdpXHQUH9e8Dg1vbl0Ex8UuoayV1psZR4HFzGFAfD/N1zIDCFe+eAHb74Wxp+cvCpD/Kq/Hl1OGxtz2h2FyfeEskZE5/zlMSKnB10/So/macHlN7LAYTF+1GjAbXcW3kCKtpNLB1QCy/riZtb5dyCeIESff0tMBz13Qg8BZ/Tp01+VfS4x8Rd43K2gkDeqmidXfD9fLZe383brsYytzcDVHcRNYlGLkLMWidUwF5S6GRqj+g1r7YriUaNhz3Afdb1JR2HpMjG8YoqVMWEK5Yg4ZNe0TZYTl2hKQOP0dEb+sA1YLkTp+C+DI8ChM6TFeihhht7wC0J4Fk0IH4ZeHb35odjWVIHNgR0AwcfaqcZaulWJ3SaDq1n8rEVqFLPY/rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/29/26 12:52 AM, Kairui Song wrote:
> On Wed, Jan 28, 2026 at 05:02:34AM +0800, Chris Mason wrote:
>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>
>> [ ... ]
>>
>>> @@ -1191,12 +1203,23 @@
>>>   		folio = fbatch.folios[i];
>>>
>>>   		if (xa_is_value(folio)) {
>>> +			int order;
>>>   			long swaps_freed;
>>>
>>>   			if (unfalloc)
>>>   				continue;
>>> -			swaps_freed = shmem_free_swap(mapping, indices[i], folio);
>>> +			swaps_freed = shmem_free_swap(mapping, indices[i],
>>> +						      end - 1, folio);
>>>   			if (!swaps_freed) {
>>> +				/*
>>> +				 * If found a large swap entry cross the end border,
>>> +				 * skip it as the truncate_inode_partial_folio above
>>> +				 * should have at least zerod its content once.
>>> +				 */
>>> +				order = shmem_confirm_swap(mapping, indices[i],
>>> +							   radix_to_swp_entry(folio));
>>> +				if (order > 0 && indices[i] + (1 << order) > end)
>>> +					continue;
>>>   				/* Swap was replaced by page: retry */
>>>   				index = indices[i];
>>>   				break;
>>
>> Could this code infinite loop if a large swap entry crosses the START
>> boundary instead of the END boundary?
> 
> Thanks for the review! It's really helpful :)
> 
>> When shmem_free_swap() returns 0, it could be either because:
>> (a) The entry was replaced by a page, or
>> (b) The entry failed the boundary check (base < index ||
>>      base + nr_pages - 1 > end)
>>
>> The boundary check here only handles case (b) for entries crossing the
>> END boundary:
>>
>>      if (order > 0 && indices[i] + (1 << order) > end)
>>          continue;
>>
>> But what happens if the entry crosses the START boundary? If
>> find_get_entries() returns a large swap entry at indices[i] where
>> the entry's base (calculated as indices[i] & ~((1 << order) - 1)) is
>> less than the truncation start point, then shmem_free_swap() will
>> return 0 due to the "base < index" check. The code will then call
>> shmem_confirm_swap(), get the order, check if it crosses the END
>> boundary (which it doesn't), and retry with the same index:
>>
>>      index = indices[i];
>>      break;
>>
>> The next iteration will find the same entry again at the same index,
>> leading to an infinite loop. For example:
>>
>> - Truncating range [18, 30]
>> - Large swap entry at [16, 23] (order 3, 8 pages)
>> - indices[i] = 18
>> - shmem_free_swap() sees base=16 < index=18, returns 0
>> - Check: 18 + 8 > 30 is false (26 <= 30)
>> - Retries with index=18
>> - Loop repeats indefinitely
> 
> I think this is a valid issue. And it's worse than that, during the `while (index < end)` loop a new large entry can land anywhere in the range, if one interaction's starting `index` points to the middle of any large entry, an infinite loop will occur: indices[0] are always equal to the `index` iteration value of that moments, shmem_free_swap will fail because the swap entry's index doesn't match indices[0], and so the `index = indices[i]; break;` keep it loop forever.
> 
> The chance seems very low though.
> 
>> Should the boundary check also handle the START case, perhaps:
>>
>>      if (order > 0) {
>>          pgoff_t base = indices[i] & ~((1UL << order) - 1);
>>          if (base + (1 << order) - 1 > end || base < start)
>>              continue;
>>      }
> 
> This still doesn't cover the case when a new large entry somehow lands in the range during the loop.
> 
>> where 'start' is preserved from before the loop?
> 
> How about following patch:
> 
>  From 863f38c757ee0898b6b7f0f8c695f551a1380ce8 Mon Sep 17 00:00:00 2001
> From: Kairui Song <kasong@tencent.com>
> Date: Thu, 29 Jan 2026 00:19:23 +0800
> Subject: [PATCH] mm, shmem: prevent infinite loop on truncate race
> 
> When truncating a large swap entry, shmem_free_swap() returns 0 when the
> entry's index doesn't match the given index due to lookup alignment. The
> failure fallback path checks if the entry crosses the end border and
> aborts when it happens, so truncate won't erase an unexpected entry or
> range. But one scenario was ignored.
> 
> When `index` points to the middle of a large swap entry, and the large
> swap entry doesn't go across the end border, find_get_entries() will
> return that large swap entry as the first item in the batch with
> `indices[0]` equal to `index`. The entry's base index will be smaller
> than `indices[0]`, so shmem_free_swap() will fail and return 0 due to
> the "base < index" check. The code will then call shmem_confirm_swap(),
> get the order, check if it crosses the END boundary (which it doesn't),
> and retry with the same index.
> 
> The next iteration will find the same entry again at the same index with
> same indices, leading to an infinite loop.
> 
> Fix this by retrying with a round-down index, and abort if the index is
> smaller than the truncate range.
> 
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/linux-mm/20260128130336.727049-1-clm@meta.com/
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Thanks. The fix looks good to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

(BTW, I think we can simplify the logic by moving the boundary 
validation into shmem_free_swap() in the future).

>   mm/shmem.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b9ddd38621a0..fe3719eb5a3c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1211,17 +1211,22 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>   				swaps_freed = shmem_free_swap(mapping, indices[i],
>   							      end - 1, folio);
>   				if (!swaps_freed) {
> -					/*
> -					 * If found a large swap entry cross the end border,
> -					 * skip it as the truncate_inode_partial_folio above
> -					 * should have at least zerod its content once.
> -					 */
> +					pgoff_t base = indices[i];
> +
>   					order = shmem_confirm_swap(mapping, indices[i],
>   								   radix_to_swp_entry(folio));
> -					if (order > 0 && indices[i] + (1 << order) > end)
> -						continue;
> -					/* Swap was replaced by page: retry */
> -					index = indices[i];
> +					/*
> +					 * If found a large swap entry cross the end or start
> +					 * border, skip it as the truncate_inode_partial_folio
> +					 * above should have at least zerod its content once.
> +					 */
> +					if (order > 0) {
> +						base = round_down(base, 1 << order);
> +						if (base < start || base + (1 << order) > end)
> +							continue;
> +					}
> +					/* Swap was replaced by page or extended, retry */
> +					index = base;
>   					break;
>   				}
>   				nr_swaps_freed += swaps_freed;


