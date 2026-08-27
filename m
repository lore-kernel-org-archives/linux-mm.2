Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 329A9C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5745D6B008A; Thu, 27 Aug 2026 04:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B5B6B008C; Thu, 27 Aug 2026 04:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4892C6B0092; Thu, 27 Aug 2026 04:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29A7D6B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:03:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B4D2A034D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:03:49 +0000 (UTC)
X-FDA: 85146310578.04.5D8E0C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F285E40007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:03:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BrcCTXI+;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787817828;
	b=awcevoESybBKbeLg+nLTMBT8rSsNAzXQYrkZbzQjvhNTCknWAFHvnsQL6Oklmhbj/bB1rp
	BjB2b0Rf3ZAwK/VdGDmpm/yYhE+twXeFN6zSq0k2WXZjX7wP0RGNviRKXQiC6vxQEYoOYR
	R0QfE+iFqDlTT/FfcgDW/S0efG9DaAs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BrcCTXI+;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787817828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNLnyWjL8DesrYLjnmrDKChGfbafqlwaKvit0A9aYBs=;
	b=zdoTjfDoBqQwcvqG2AqA6uTIe0sn6clVEkDmjSUv7+yotkY8a7rP58Y0riUPelYMBM1nt8
	b2msCje9YD6FmLO91X9tz5jgU5yecl6nFfv3tvL3LeEVlrmVjmw5em8P7mCfe+g8lhrCBt
	3ntxFrmUA5X9OwYKVh/W+LV6mDsqsEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 933DE600D2;
	Thu, 27 Aug 2026 08:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB5A1F00A3D;
	Thu, 27 Aug 2026 08:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787817827;
	bh=cNLnyWjL8DesrYLjnmrDKChGfbafqlwaKvit0A9aYBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BrcCTXI+b79Ps7jW4U9P8tYTSax/uesrCiFgIHl0hEXor8vyMSZyt72JUBlNLZY/z
	 tD3QOsg1AWjDXs+xXwqaJNoHjhj24PXvr/DA9HqEWFkTjZEHA5eHsMKJNn8D351Guc
	 OLG6IsqlWXAipfDO3+F9RYea9DR/O7AF3RRADIQtKnP7AsdhwA9Y7NkRjaZxppiFJB
	 82qzxp4Zz9w3/oZcc9M7zte4so8a+FD2vpWxbPhCwOvAWPoCt/eqYX4LaOvxOpks7Y
	 h4NCeRUVJz4zc534Fj9W/5hMbZcxBNI9bgMPMQsttAe7eAaGi3NC3+WaXqZCaeTbf1
	 wFqZgMj8O7tvQ==
Message-ID: <78561ffa-d075-4570-aaed-60744f11160f@kernel.org>
Date: Thu, 27 Aug 2026 10:03:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove out-dated document of __GFP_NOFAIL
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baokun Li <libaokun1@huawei.com>
References: <20260827030548.16631-1-richard.weiyang@gmail.com>
 <cbc344a4-77b7-4282-9bdd-004822642ab5@kernel.org>
 <20260827074921.mracnqv2m2cugasb@master>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260827074921.mracnqv2m2cugasb@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: c35dc3sxpbchuiy6xg7a61cqxgjgndsg
X-Rspamd-Queue-Id: F285E40007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787817827-567975
X-HE-Meta: U2FsdGVkX18xTn4PlVd4XXFmncZPFtoz2Vl0PGBAHejMXPYtW/3M2cjgc4iNSfzSpe6Iz5haQOlxZ6fCsM/Q4XnQiis5AvYu2A71uVyz6ay7h+WE4vGwV4ZmsUF7dEROVgOw+eTM/DFz4OHdtIFzoS5goVHjC7x8fIv/4MJ6DzMO7KcGmszNCJLKH64uTNMC0vNsAN2Nvwe2RO/t2Sn0lGAWGzjLaHCrTS/7NCgG4yrPN7eT8S0GFVP3YslppFEhh8XTwtFmdTD8PKr6X/scD2SvzwJO835M6pHQDIpreWp2sLfEVywAjNPddFB7FleG0zL8EcYFycBQEcBULI9QZwCvGUPz+WhenAOh+yrb5XYqZbGl1uUlPIdPEQ392ZrujlbkfqNWV4/A2bAe5k9ImxQgc7D4zJg1Pm/UyCJRsKpFm2lnr6Y2nuspXx2AJJ04QdkdjUXFkU7XYmo7zLFFCsXo6s5fvkSk4jqMEicW47ss7E1X6B7nPANtAsc9DOtYuRDCwD17+RtMAOWJ349/Rw0WKWxgqwsdCx0mHszhONe7MhW5c5SK8GseacR+LduKZ8we0+HteHc0/QXWXljHLU/3nGz8QPry2GmOWyj3xsPQLypErNSvuIo9XHP6u9zotGVkmUBlscN7fIGqE/qplehsv/H4hxMINiBfqSRvS60Ovb5X54WYymn3bUaR4+lgiMdo1numWAhBXN5p0k43YsQ5Ll0UZ3VCdObKHa0LOgqrRxMGVcSEa2neFyzYDxCz5YYM0vxOnFxwaBlIT2Pl2OUfTmyJlpsrPhJY1VO1HoH/K7xsPbSiNdHLlaFPOzHz5kA7M5O7Nk2WhOTnbBXiLVKKxLbX2aBn+xrTqj6EVPDTZSxF1L5SVJqVaGhXrwVJ3pFoOtQ2NDokIvUW5/ArykusHabszb+G2pS9ef1FZ2qq34SgMmqe6J5BfK9yNKJf7N/uCmjr9neFU4PoPsI
 ABxXaKRX
 LhpNvPMJs7wzWZxTn/snuPXNkotCkgHmSS2KpDO3wBEB+C3YKPcDmQEcbej6PvAphw1pDEuAd2VasvmK/p3qMzlGwakMNTlVX2H30xImkufH4c/qSIxSO1Svy0TneP5yACKHBfTxKM6IEyLAYneAw0jaYOUg1ygGqAYo4OPKZ0WJAm6wagg0OGyWlgD8xD+BbLOarSSVmcLfIjNu75hS460J/wV/hFAvkaehrZB1D4GShER8QnnN4Pna+uvaLerwOCpRkpXZ9C//0q+0u4Sir4YggAmY9M5u2RBpcD4H3F82GKRz4gBWG1tbOco/fApwLq8+fRR+HtUznFIJIhjjCoocLZp0z0OnZLTcfFL9Cxxv+AgRr6uCtBeu7AqkcVxlvxeJu9D8WpnMEm5mJwZ4gmhFvEDHQ/GL8rM7pZxMjfYUmuZOQ6VeP+PtMAlNvzd8YsRTCF7iRK7iAnBZ4sCuQPlICJwwlqaw0mXDIOjiCBf6dyNZy86T+YYv4AIla1o1PbeaO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 9:49 AM, Wei Yang wrote:
> On Thu, Aug 27, 2026 at 09:35:26AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 8/27/26 5:05 AM, Wei Yang wrote:
>>> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
>>> with __GFP_NOFAIL") remove a warning on allocating large folio with
>>> __GFP_NOFAIL, which is adjusted by commit 903edea6c53f ("mm: warn about
>>> illegal __GFP_NOFAIL usage in a more appropriate location and manner").
>>
>> "which is adjusted by commit" sounds as 903edea6c53f came later than
>> ee040cbd6e48, but it's the opposite. Maybe say "which was placed there"?
>>
> 
> Got it.
> 
>>> While in that commit, it also documented this behavior which is
>>> out-dated now.
>>>
>>> Adjust the document to align to current code, and adjust the comment
>>> while at it.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Baokun Li <libaokun1@huawei.com>
>>> ---
>>>  include/linux/gfp_types.h | 2 --
>>>  mm/page_alloc.c           | 2 +-
>>>  2 files changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>> index 190191411009..24fde8eb73df 100644
>>> --- a/include/linux/gfp_types.h
>>> +++ b/include/linux/gfp_types.h
>>> @@ -243,8 +243,6 @@ enum {
>>>   * used only when there is no reasonable failure policy) but it is
>>>   * definitely preferable to use the flag rather than opencode endless
>>>   * loop around allocator.
>>> - * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
>>> - * not supported. Please consider using kvmalloc() instead.
>>
>> I'm not sure if we want to simply remove the lines, or rather say it's
>> discouraged (instead of not supported) and still suggest kvmalloc() if
>> possible.
>>
> 
> Reasonable.
> 
> As mentioned in [1], kvmalloc() maybe not suitable for some cases, I would
> suggest below change.
> 
>  * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
>  * discouraged. Please consider using kvmalloc() instead if possible.

Yeah that's great! Thanks.

> Or, you prefer only s/supported/discouraged/ ?
> 
> [1]: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org
> 
>>>   */
>>>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>>>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index ab385bc252cc..146f7e0a9462 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>>  
>>>  	if (unlikely(nofail)) {
>>>  		/*
>>> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>>  		 * otherwise, we may result in lockup.
>>>  		 */
>>>  		WARN_ON_ONCE(!can_direct_reclaim);
> 


