Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 802C1D30CF8
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D716A6B0005; Wed, 14 Jan 2026 05:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F9F6B0088; Wed, 14 Jan 2026 05:25:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FB56B0089; Wed, 14 Jan 2026 05:25:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B25916B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:25:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A0ADC1CB9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:25:03 +0000 (UTC)
X-FDA: 84330186486.14.F9213ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95574100006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:25:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7HDROVN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768386301; a=rsa-sha256;
	cv=none;
	b=lJbscy1jlyh1qFzR8fQ7CMkpkWvoTggWI5Rp6MUtgNNNNw+V/Zfw2SL4qTQIGISW++TEFo
	aiR76Sko28pLLZcjfU4eQ69KeWs0M2x26Nfbg04C+ML7oMtBD2RMIO5O6M2Gkc4ut99qwG
	85dOQzobVnxQEUTLuASohC8J1ZdC93E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7HDROVN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768386301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJaUPuwHUqEgA5DBbQOka0VD5S6WEnklhoJk7zxt78w=;
	b=dNleqs1T23dyf7PBmd4cVLVXGgOFbkoIqK/eO3fULxxLky4IcHtT8oUJ7aTFjcPvQSNdIm
	t8XDZ/fyRdq/F0wAux+k9xBjqTtj7Rw9m92kqGRM3sqnHKaRHus8RCcDuuNhqnrscufshD
	ZXcnyxeVxOJx3x7OjlgMNFVRhmx7jf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A28CF43D7B;
	Wed, 14 Jan 2026 10:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8529AC4CEF7;
	Wed, 14 Jan 2026 10:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768386300;
	bh=GuHpF+6RmdzfwSAF7TH1se1OHKCtKDO93WP3i/0TrS0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=u7HDROVNmg4kf/SpiPZyAdk0G3o+oWovgIZGE52LqzNXQJo+94l2+faabdjcUbbuO
	 WRFJsce/I32G9huyKT9rZy9ZuZRgUDu1IK/1TjmT0Ye7JkBpCWZM7UR8oD/ayluVqU
	 QQZyGYtpF6Xomrg1T5udaMiQ09QlC8P8Qe7AsBSBT6bJoBdT5I83+mHrxXXPxCu3sF
	 n0Q7vwnQoU6nr0a22PbdDOgWKVsvXqVjxsYC32meVt+p9AQL89N4AbXQW35SQJkXdx
	 Xa7db9GQ3G4fYoXsN/y/Odbkk6ydnH1p7il5P4uKPF2jV/bdyO4bXPkXhP417b8kCi
	 vJNo3UIVTniCg==
Message-ID: <baef0334-02ea-4732-aa0f-029098879cbd@kernel.org>
Date: Wed, 14 Jan 2026 11:24:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Rik van Riel <riel@surriel.com>
References: <202601141040594302w9Pnbc3vzQLMkh8bQ80D@zte.com.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <202601141040594302w9Pnbc3vzQLMkh8bQ80D@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95574100006
X-Stat-Signature: hyrd9nxj6fhuyeg7bhmqqwfu4ej7747k
X-Rspam-User: 
X-HE-Tag: 1768386301-830908
X-HE-Meta: U2FsdGVkX1/ZdRJLpy3g2nezYhvH9D9tNi1M2pyKKOM1plAtgi6OthQ0cWqwhUDyOrTmDEYRU/IyBvC5VpmQRtDx2btgDsbiVma94YD176Mp63ZzqgqPGs85dnA49a1u/d0yIlnIKmxk8/i44zn7llUukRpwVD9336KeanFFC+KFQOF6Bn2yMCyDVJfnVPMbko1GbDhagdQuIvUaw3E/UfvAzsSlSK36bKhrJpR3bdoo7I4xK/hVIEBrvT0Ydv2zEmNOhM0uonpC1mJP5SALiYJl08jc/EidwfrXHCqGGQZxBdswMtrtqWRIZPwSSHewM9nVfqt7NvDw9H7jE/em9usSRTpBpdQeTgUufu7w8VXEmUdwOtSpVX4TbKGgrQOm4LFWtLS5SI2+e0XpSipRKGw36GE4163DoH+UJf1AstYdVHZfFQs2o/bdl6acr6TnHk1RMf/zjYF2c2SaKYKo5YqBbD5HqVgqfr1r2LHB9YNngKtvvNtGPjvmnHWQ1kKq8w2q2Laj5DuBYeZuG3X8EaZ6C/5WCeiDXShI6NSq9Een04gE8lshmWXO+yc1bijkNuMPTlHwibE18UeauJJDJPOGAJl4witI/m8npXw2zlf+j8WwWY/xOSqkxTrq0QAt4Z3GibU8bIk7kJsagtf1dq5/3yoTVwwg5ahX7tpppV4IO4Z247ESCSf55EMY024TWPe+cIKbluvlY7zJpfqBdiZoUOhmSiPJbvmD/j1TDuivDXILukpYhFE0HnytLfZBbedGDrzlJIwo7CwTuG+LBxbdyDvmldoZeag4Bf7ulKJV5CQyfAO1CFa6UgyxcWXdaUBkHAYjsNNpfW0FFg+T/YzVUomj03yXuqweTR0oLVMZnuGS2qDLUX8IpW6dmQJa6+beiXAzeld/tzrKO1B/ZIhkz5lpjV9RjuBpBkwZz26kwK++22TxSz2NYQ251JHUaUnBSkdaPlXnTJEgQf9
 +DkHrgHl
 qnKRXTqFAEJTqsVukNRN0nvtw+sajj7dzhg4bOV79QX+/99FIKtg6ybDgmfOXDRqt7vEyy7OncEXrQILiFUCWg9+Zec3duaB3pE7MKEBG1UuvIYoQxAcPqA1gWBtsYY7z3ShgslRfjpi3D37IduFpvlM2Uiuck3rL0F1PqLdGsVL/9kbj/6fp8IRk52RZX3DA8Xm0QMgEyHc4UOxbMRqsakOqxG2f0HoY7FY4oVnzdjGpfQd0MIhH1jV2ya+jaiBKPTLlD3K7kbTjZA2+OESzShY8mfAIQPPeEgq80crpUkp2pjRsDXnPnBcjDur+ge94TEyqW6xwQBj8B9vJhyjFOjhPB1kegg5Q21TIyEMTSAlTV1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 03:40, xu.xin16@zte.com.cn wrote:
>>> Solution
>>> ========
>>> In fact, we can significantly improve performance by passing a more precise
>>> range based on the given addr. Since the original pages merged by KSM
>>> correspond to anonymous VMAs, the page offset can be calculated as
>>> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
>>> defining:
>>>
>>> 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
>>> 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
>>>
>>> Performance
>>> ===========
>>> In our real embedded Linux environment, the measured metrcis were as follows:
>>>
>>> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
>>> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
>>> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>>>               and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
>>> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>>>               in a loop of anon_vma_interval_tree_foreach.
>>>
>>> The result is as follows:
>>>
>>>                    Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
>>> Before patched:  228.65       22169                 22168                    0
>>> After pacthed:   0.396        3                     0                        2
>>
>> Nice improvement.
>>
>> Can you make your reproducer available?
> 
> I'll do my best to try it. The original test data was derived from real business scenarios,
> but it's quite complex. I'll try to simplify this high-latency scenario into a more
> understandable demo as a reproduction program.

Ah, I thought it was some benchmark ran on an embedded environment.

How did you end up measuring these numbers?

> 
>>
>>>
>>> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>> ---
>>>    mm/ksm.c | 6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/ksm.c b/mm/ksm.c
>>> index 335e7151e4a1..0a074ad8e867 100644
>>> --- a/mm/ksm.c
>>> +++ b/mm/ksm.c
>>> @@ -3172,6 +3172,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>>    		struct anon_vma_chain *vmac;
>>>    		struct vm_area_struct *vma;
>>>    		unsigned long addr;
>>> +		pgoff_t pgoff_start, pgoff_end;
>>>
>>>    		cond_resched();
>>>    		if (!anon_vma_trylock_read(anon_vma)) {
>>> @@ -3185,8 +3186,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>>>    		/* Ignore the stable/unstable/sqnr flags */
>>>    		addr = rmap_item->address & PAGE_MASK;
>>>
>>> +		pgoff_start = rmap_item->address >> PAGE_SHIFT;
>>> +		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
>>
>> KSM folios are always order-0, so you can keep it simple and hard-code
>> PAGE_SIZE here.
>>
>> You can also initialize both values directly and make them const.
> 
> Yes, I'll do it in v2.

To me, this looks reasonable, but getting some eyes from people more 
familiar with KSM+interval-tree handling would be great. (CCing also Rik)

-- 
Cheers

David

