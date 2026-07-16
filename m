Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D86C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6096B015A; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CC36B015C; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A5E6B015B; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA946B0159
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9603580156
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:45:20 +0000 (UTC)
X-FDA: 84994610400.20.F44BF88
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id E47BE18000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:45:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CpVTrgCI;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxWBQiwgJMv8m9ergC38r1JkaLkub3PyBl4jNFNbnUk=;
	b=vqp4aby0Aoltes32l5RV77l314Zj6MYbbb0rrHO+3RnS+1ayBmd3T1f3JKtr7/LxEdJCtF
	Z0LZMflcPlO6bRobbJ98ENr9eRTSHyV5MjefPGIgOasCsioyT0YDA4BbnHb9e9Td3/sa2x
	B8F+34Op8MUb6GBnbQCfmkVEL6uwoBU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CpVTrgCI;
	spf=pass (imf16.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205919;
	b=ZMN6BvR/ss/77y1h6jjeJIhfl3y6kFEbrf3H8JIjXQNk5faT2nYGBy/mxLaNyJPOYsJ3ZB
	S5HGXbrWNDeX9j9JXLXozCbDglwtOjXfdKHdkWIlgedyuLdcYj2CJLM3eUUunIB7sJ2klu
	KimAqSX8oKBeeHheWpE219Y9lkAj8Xg=
Message-ID: <1d9d6fe5-3414-43c6-9073-d4d6508ac6a8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784205914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rxWBQiwgJMv8m9ergC38r1JkaLkub3PyBl4jNFNbnUk=;
	b=CpVTrgCIFahzrsWip7msymPoq5jnFXWdkYRoRtrdbLC8GoAWnGzbHWJ3WweVXX0njIkjUP
	xjfOi9cHO59ZUJ/UDi4vA4BE0NG/8pRNllmBEtTQWBwPb+PE8fj100rlMoq58PVUDSxwAE
	KjJN4FPaDYb6vqNwGTUhb/+LHJqzB6M=
Date: Thu, 16 Jul 2026 20:44:51 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/swap: Fix swap_cluster_lock() !CONFIG_SWAP stub
 signature mismatch
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260716085131.68378-1-hongfu.li@linux.dev>
 <CAMgjq7BRSaueYLXa22Q=OvGj3w0wJKVA9+qF0+Z4MPtnjosw=w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <CAMgjq7BRSaueYLXa22Q=OvGj3w0wJKVA9+qF0+Z4MPtnjosw=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: e94s4mm7h1kw795do4cscpj55e9yaixs
X-Rspamd-Queue-Id: E47BE18000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784205917-486803
X-HE-Meta: U2FsdGVkX18VShSGwpAkIjLmDx84rp6Eo8I5ceEd1z54Dph52EFXQ2PZHzm4kY/6CHP3+NGjp4Y1JCD7mkpVPf26D/3wAxP4GbFIx8YN9D9vRtu1fElnq0fZE/SNRyRBtk4UdJQCPyM9aSO6c/do+Um2O0jVhHUWNwWFrjOZyiIZT82LmqJhmJ9crlvapLgfhTq0/ZztV3f1gtCIgQZ4j2eX1qc0B0zdePqhtBYQfZUJfy4EuAu0+92eoZcGoD6FqOR6miTqfil3m9pZ7/0m1VodPxnUdG2V3yILEf85McK/UvISUdb71WZSwQdq6GAR+QTWXJEINtFcXmmdQzB9nDy490PtwBzkLlVw/b+ATkncps/DaSxE48fBagHs7r/XkV3QG/Agx8hgoNpFTGPGxvQ1sPX8G1hZ8wTeYVvgiylmPn+MRMILZ7iQHdQC0dtvVb560lbRfUC+BB6PaVAKXsZn93DgNOmV+pVzXTCulyPEAtsG05T2+k82a8m0mEiZInXdxCmuY6lw05SIZ5nYnxQx1mZrEE4igzt9qAtu6qE01W2n4Ffa3YtTKU1yU99jkG6d6Lg0MUhZQzIzoST7HUn67DekYknbMnKcWhKDAe6L3WAJq/NdNUyi3bP8Z9Wma/PQ1q8EVro0iUqkgTMOp3H6sxLyIA9QkJ6uq0W/SnMpOEFWGznD8gVuYlQ4gD52x+MwBWji3nAivPjJjRvHwAV3s1eORVgItdDGGF8uELL42YFJFvwdVydE7UfGscJk8/KKB8V3/CVz+6QaAcrBr0sJ+mFs1ml9KY3AVUNxcv+vfDHDojOFArzuSk4d9TKxYrxkbPjJ8bwtuMVXlBBQJXZ5wXJZEK9NmM2+7uQFMP3z45JCmuP/LlqBwefVvgqOWfGLJfJTYz4uHgW9G22wqzIWzVPC8KXBQF4E/r/J3Jw3z7HHEobbL0xkjPCK9lkkJ5egfw52rXDAT6hkAb8
 KZMCGuaX
 MABp09+mfV6hsJ2nSUdbdO9tosMrwd20RiOvjgqlE0XX/BZS+EKiCEnH5BAh9trlKaiTuFZHKTna1nT50bRf9FxwWVPHiHwSwL8ZAvsplERSEX2YQ6pBj14wzjH/fTd1Gq63htElrlJKq+gF0PD8xs2kWozr0Y4LNMLxsp5wt7y9Nt9TR+mDA0wltlPkO0GpN8sW/nAnx8Ew4uSRsIDw4nlVG7P6Xv9oBJVuZTmgO4FmMPajlpAKRd9yzNinfl+9mCGfTyXIH5CGk7OAH3buKxZTe5gVlR3N/2NgNpa1bG7Lf6Ju2JyFmo1HoSlmTu/ob8lx6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/16 17:47, Kairui Song 写道:
> On Thu, Jul 16, 2026 at 4:56 PM Hongfu Li <hongfu.li@linux.dev> wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> The !CONFIG_SWAP stub for swap_cluster_lock() has mismatched prototype:
>> it has an extra unused irq argument and uses pgoff_t instead of unsigned
>> long for offset. All callers are under CONFIG_SWAP so the extra parameter
>> is dead.
>>
>> Sync the stub signature with the real function.
>>
>> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
>> ---
>>   mm/swap.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/swap.h b/mm/swap.h
>> index 77d2d14eda42..2c4667662601 100644
>> --- a/mm/swap.h
>> +++ b/mm/swap.h
>> @@ -337,7 +337,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>>   #else /* CONFIG_SWAP */
>>   struct swap_iocb;
>>   static inline struct swap_cluster_info *swap_cluster_lock(
>> -       struct swap_info_struct *si, pgoff_t offset, bool irq)
>> +               struct swap_info_struct *si, unsigned long offset)
> Thanks, nice catch. I didn't see any build failure report, it seems
> swap_cluster_lock is never used with !CONFIG_SWAP? In that case we can
> just delete this redundant declaration.

Agreed. |swap_cluster_lock| is never referenced under |!CONFIG_SWAP|, so 
this
declaration is redundant. I will drop it in v2.

