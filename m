Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF03C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5ED6B009D; Mon, 31 Aug 2026 04:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E106B00A1; Mon, 31 Aug 2026 04:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434B36B00A2; Mon, 31 Aug 2026 04:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 118C36B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:53:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A0421A03EC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:53:03 +0000 (UTC)
X-FDA: 85160949846.12.8F1D679
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0FD3E4000D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:52:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fnr4No4J;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZYb7qeuDeUdbF6Gzt4VmWbSRmjddUQtr9AFQa/PBJc=;
	b=lzcTLjpa9xCnTazV+XWdJL+caAa+O50jghM6RdwwIHw8pbKTgdRcxXuY0WJdlMhp8g29YF
	0hP2/WA045BkPUtuE0VJNbLgie/bePb7bXZI7w2yHFqURq9rA6YGf9Svr99kaZf9U07rAE
	68WVQPxtdCa9vM8WQ4btjF3yPMemLJU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Fnr4No4J;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166381;
	b=0ND7xPkKPvK+SS0pJ6Rw9KofDL9Q8VZm/JyaI6YQqz9p86mG6HyqmC17QKG13aRg/eMiQv
	AvfsF4oCRLXKya0XxQZFNTQfLT4n/87XJKdsOPHqG+46AF2cOgeltIbSwqCSd+RPy1iilI
	UYMXRpzLeIsejNyaroRgSt93RKeqFMU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788166377; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TZYb7qeuDeUdbF6Gzt4VmWbSRmjddUQtr9AFQa/PBJc=;
	b=Fnr4No4Js1ojWUx/Fbc0ANQOn9xJtZS99ZFz1wbEBqws2/lRE2VXS04z+shyg+uA+Ia4WfD15ydUMNQrQ1Tl5Z6IeAryQnE4x4XACB6O2CUKm+7qni7mDx0edwH8ZK45yH9xuevXEhmPH80pcPXb4VjXlmuR9P+bDqRrCvkxHoo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X9wFnwG_1788166376;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9wFnwG_1788166376 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 31 Aug 2026 16:52:57 +0800
Message-ID: <8ba99027-7ee0-4459-9eeb-acc15769b2c0@linux.alibaba.com>
Date: Mon, 31 Aug 2026 16:52:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: Kairui Song <ryncsn@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <fbb40ab7-6942-4983-9621-ab8d5d50474f@linux.alibaba.com>
 <apRx-xd0csgBU4sL@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <apRx-xd0csgBU4sL@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: igpocjrzrrawoq5mipn7ym7mkdrs34zh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FD3E4000D
X-Rspam-User: 
X-HE-Tag: 1788166379-544068
X-HE-Meta: U2FsdGVkX1/Al1FuF0fQCzzBcN5qYGbc8UGyPId6iZTSwHA0IvX5AkF29xFaDKV/RWdXMVKdfCtHM3xOnlZZYTFWU9zyK75ZnZOOLIuUxqC38DGBC/zg6OXpBjRdIwcE8WgjaIkfDkbdZDq+CSrcWC2pmwMSQc+oqwMq6vDWP4gat80hv/w5XsHcBoiieqLotcsJwwgGVm7JC/t91PHhq+yfo5YNL+rL4dwmEIpK+U1MWHjxlUWFXglclnwit3Bc3aYvpTlYKfVtE/1WQ1fibYAMH5/t7H4CJmHpdlP1O2TGUnzm4DqfcN8Ei0RUkegV53CaGkXbZpmwTwwHud1S7jj8f1LQBWrcFo4Jsxd1UWsrBORCpBM9HYdaWtKF3sEnX42P21/YnmftwqjNOlb0KcFlw7pn8YXdja00GPUV9+6Q/kxxPli0/hz8P2XNONrjQjCOmsi68m8qAYZiiJ3bnvRm9jPzG6rKMXyO/la7kJ+kwZ7FOD6TOpaRiTKb3pKGcGJ2o4aIYcSSB++Od1S23IOHycvGY5zkd8KI8xQv2KTcMLc/aTLWZXdyqLRhrnFzpw9cwNk3lK9VyRl96Ni0SYPdn5KZkCC9aZATFoeYXu4ablH/s+zotm6Sm/RotiZOzyZZ2T81f+Iu7saeOsLECM/ep7c/iO1B1W5QSUxgW+UOfZQvgJqNAEfNMKg1jxalv5VDxaVwQPCrXOtJkruTY5tumrCYIa/NfMZ4zXcuEjXewdWXPj6nq6PwR44CdxdFaK7UJRHFAVr7kTXCI/o92CSECK23fey33+nfycwp4Xp0dgJvrAZdyIZb8aXpZ3ti892xe1D7hSDNdcil79cf4jkeZ99v7HRMkNy5rhwZmia+AvHONhuw7UcDNFe1cQB3/7iYQ6lRuZMJOzVjokQDM1/zJS/32jJWVmaloI1JmLC9zn1JDu60yctSDMT8xF2SDqHpd3AGhNLs75AC5jq
 jl01c40U
 T5uKYnkLNAUbsDOT4gsuXb3TIJRBGGdyi8Fb3/IfevhDO90ligsyQ579E6wg4Kk+GOnEK6yeurrMt9gXNdwrwTtDhpBiEszRMajx8BPFHucFkK26EElyHM7U35GBfdXun2x0NYM9XW8dzfX0hC9ESnFiZaD1uXhk419R9gPxh10y7DkF8uAC1m+LbOj0st6vRsIJDtYAHswh6B/d5GF76QmiNgVQpBZ2h3Aif/GYivDE9ehHdATtgi0AWFPbmyLycD5YhFz2URP+c3ETTWKBiT4vIYGTJLnFU+Oqyj3TgwvtADPd/zfEZXOrPWoI7MuSBEdkub89gMIHd0ILK0h6OpKOZK87owE+PZq6Pn4aSi7QsIfdnu4h0UihXcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 2:12 AM, Kairui Song wrote:
> On Thu, Aug 27, 2026 at 03:32:18PM +0800, Baolin Wang wrote:
>>
>>
>> On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Instead of doing bit ops on folio->flags.f, introduce helpers for
>>> adjusting a folio's refs and generation info, making the code easier
>>> to debug and understand.
>>>
>>> No functional change is intended: some combined atomic operations are
>>> split into two, which only creates harmless transient states. There is
>>> no measurable performance impact, and some paths even look slightly
>>> better in the generated assembly.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>>>    include/linux/mmzone.h    |  1 +
>>>    mm/folio.c                | 19 +++++++-----
>>>    mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>>>    4 files changed, 114 insertions(+), 43 deletions(-)
>>>
>>> diff --git a/mm/folio.c b/mm/folio.c
>>> index c02dcea9c03c..a932059057ac 100644
>>> --- a/mm/folio.c
>>> +++ b/mm/folio.c
>>> @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
>>>    static void lru_gen_inc_refs(struct folio *folio)
>>>    {
>>> -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
>>> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>>> +	int refs;
>>>    	if (folio_test_unevictable(folio))
>>>    		return;
>>>    	/* see the comment on LRU_REFS_FLAGS */
>>> -	if (!folio_test_referenced(folio)) {
>>> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
>>> +	if (!folio_lru_refs(folio)) {
>>> +		folio_set_lru_refs(folio, 1);
>>>    		return;
>>>    	}
>>>    	do {
>>> -		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
>>> +		new_flags = old_flags;
>>> +		refs = lru_refs_from_flags(old_flags);
>>> +		if (refs == LRU_REFS_MAX) {
>>>    			if (!folio_test_workingset(folio))
>>>    				folio_set_workingset(folio);
>>>    			return;
>>>    		}
>>> -
>>> -		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
>>> -	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>>> +		lru_refs_set_flags(&new_flags, refs + 1);
>>> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>>    }
>>>    static bool lru_gen_clear_refs(struct folio *folio)
>>> @@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
>>>    	if (gen < 0)
>>>    		return true;
>>> -	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
>>> +	folio_set_lru_refs(folio, 0);
>>
>> Actually this clears the folio's refs counter. Would it be more readable to
>> introduce a folio_clear_lru_refs(folio) helper and use it for all the other
>> folio_set_lru_refs(folio, 0) calls too?
> 
> Thanks for the review! And yeah, that's right. But a standalone
> folio_clear_lru_refs seems a bit bloated? I'll add some comment on the
> relationship of refs and PG_referenced for the helpers first, that
> might be helpful enough I guess?

OK, I'm fine with that.

