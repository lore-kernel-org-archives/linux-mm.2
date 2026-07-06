Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C5D5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEECF6B00B9; Mon,  6 Jul 2026 10:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FC36B00BA; Mon,  6 Jul 2026 10:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F3B6B00BC; Mon,  6 Jul 2026 10:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A234A6B00B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:04:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CBA31C7D94
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:04:56 +0000 (UTC)
X-FDA: 84958522992.10.6231A66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22927C0017
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:04:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVRF9RdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HB/QsivMV6qWr9y2CPSHM/Jiflu/9yz1TINj7TpNXM=;
	b=7Dh8NRBrAX+tni5y/UBM55hPP5xQwK/sAiAyvVf4z3A8uWZIjs7oCe8yzkJyDGAt61A9Lf
	qI/m1nXgJI+GJ92Q7SMJkyZNgJd7rF6kIoMDMn6VQ6x6nMWR6l7rl+Nb5V0qct3dpuN/sJ
	dH9P5neRNTzkWlfRiHL+YxHCnCsc9Tg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVRF9RdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346694;
	b=Ty9u+bmZ+hKvXaJ9ACUAuwfHZcAmVTxPLfFMvL1O5NyhrAzvDf5PdQk+mCKkBoLCTlt9Mv
	ECIlf/tB93CjxJ4F6CTZMQ9Iwtt6/zXPCt9kbo1MH4sNG8iMaVrrj6dYplSOtsdadGLYOG
	LWcboyCuC9QJjpV8Tbw3BgRyRi1m4PM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BCC740A20;
	Mon,  6 Jul 2026 14:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC5F1F000E9;
	Mon,  6 Jul 2026 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346693;
	bh=3HB/QsivMV6qWr9y2CPSHM/Jiflu/9yz1TINj7TpNXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LVRF9RdIrTzGO0Bfsx7LCsKDeyf7GKmtw9uAODtySDa9Zd1uxJMLkW1alzCidCpKV
	 VV7j2iriGN1wWGo+cBvGIj4/n/87u54zHGRQHNSzMz/2CcYVOgoEJWl4Sywp5uK19G
	 P+IdwMVkiVejxuPAnRxnc7VtXTlYW6zxRCqiUaY2TF6Bmzlq+QwX3+jzJoka9Zvy8I
	 dOGTFq6y3jwJYOYnj9+CzPPw/kRAnFHlq5xIIhavv9jT/4K0tOKzSDsFUIwVjfF5jd
	 WN8ieiYcggZUjYwWP4/WnvVuQxV+FxBj/BYtoCfxNXnCAfY4PzMoz0ejP4LDX8tynn
	 np2O1anyHPS8A==
Message-ID: <2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org>
Date: Mon, 6 Jul 2026 16:04:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 liam@infradead.org, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
 <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
 <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
 <39a13445-dc6f-4a75-92b8-f4a122c63b89@arm.com>
 <7ac558fd-1081-456b-b997-c7321241cf8c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7ac558fd-1081-456b-b997-c7321241cf8c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o7dp3or8wt8xa6acohirn5ma7jjj5qz5
X-Rspamd-Queue-Id: 22927C0017
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783346693-942798
X-HE-Meta: U2FsdGVkX19hT3UZI//3+n8S0dKhmSa6/jZtuh5PVCPqqnl+t7MyhajlY8z362crGoW8Mu74lweqpWFcLELbsehmsvzqw58ncCUi6Ga4KK1brnCHr+EbNzi4e/fTgdYL3OBOOcUoFaA0oBE9ZkpK1xKYIc7ynAT4hnYeTvTOCBGt2P1n3uO8jL8ZdmLNX6OVw6wkXbcuUjzZVZ6Pj/5vRsFqIBg4IWjwMoaw3L3byqkJ0/b+6Uw/lMlAI/GywtmJlmoqjvmeGgNericXhkfrK9htjQ8ShniE+fZVixIRNZY1V+SyAEqCD0JFDQZJWH5W+ce+caxTrQ9Nj7dY609zQ3TFwWEa8L/41nGjEVFBnKEJDfjeHWAE6rh7TqUefPgoLyl3puRUS6QsC/cSpca2MyRSLmDRA/OuX9ryNHGcudVvJ3cdLkDufNn1/FZxfbJWhl5hxqdjwbrQqSf6e1Z5PFjVxKSwJwhpEuO+plQPj8D8cukgBmVknbuHKEx1P/5T7y9sHMqvREKuBxPtUS2PUMuR0Db+Z9S/PIKCeHZAnGnw+z808+3cTkfGJCsmLYK/IO904jvgdYTYUi5xtAYV2urIZ1oaU0b6sShi3CtZXGtCB0Oyj95aPoCxpqGA8FIXOGMypd77rQngYG7VC23x8DnctVjA3KwBqdSVEyiOOu7RTdxc0alyfg3dm9XnpiHr+BQ3ds1tJBvku9li7jZvN+ns7os9SbhjpSwR3phw0KYPkAYB8eaPdyUWFP0QR4GisPqJwnrRev2OiXGSaLUUmK87UvK1EgJH9bfg5VUJjoJRuAClzz9NQ1IrqvkOAE1afP94r0hqg2SjcGGvHCN7slOVgJiP3RXfnheDnL/RN8IBGXaQDt6X1NfTf7UnV/S9S8Do3CPuV0nNwkXFlesVZiNxHfFqAzZseyEah+0MkKy08kUcR7GYx48V7W1+JGNi4QUyXBvIpFKTJLoyToS
 4fJFGvHx
 ScxAuYL7l7Qj5cY4fbaZ9YuPSY88+OcPaXtmo80u+zLlXIIcwmxQ6hd2e6f8JoWASASJyju5nISOdH6lMnFEK+lUdqsXsj4+8/ZdkuFPUycctoIkYWUNKCmy8bukN1uYqk1gyxM/p4AXTF2OF5AD7VEGTJkAwaXquK+irHDJdxeDv8OjUUqLLKn7a/bPOgNua1y8F17PObeZGmrEFKEAcE3xZT2P94oClO7FiXmENDFKCkEZVGYAWdKl4lMmx0o0w2SW6GfJ98vSgn/d5ZxfKcgOC21EYT8nOG1Bth3ZXn+xslJuKS3QjBTlghZ1A8YJNqN3KX9UECIG98hh9MdTEpLcphMEL9FYOzmkAMbzPuYvMOhZLvKhOFlUIcxgi0T4sDKDQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 12:54, Dev Jain wrote:
> 
> 
> On 06/07/26 4:22 pm, Dev Jain wrote:
>>
>>
>> On 06/07/26 2:15 pm, David Hildenbrand (Arm) wrote:
>>>
>>> Even worse, right? We could walk 128 entries, when we really should just walk 16
>>> (IIRC) entries, possibly reading garbage or even worse, into a memory hole at
>>> the end of memory?
>>
>> Hmm I was thinking that the checks pte_dirty() and pte_young() wouldn't care whether
>> the pte is garbage. But, we could actually dereference a ptep pointer not having
>> backing memory at all.
>>
>> Does the following sound good?
>>
>> "On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
>> excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
>> beyond the PTE table and dereference a garbage ptep pointer to access physical
>> memory we don't own. Since the ptep pointer is a linear map address, we may run off
>> the end of the linear map, dereference a VA not mapped into the kernel pgtables and
>> cause kernel panic."
>>
>> Although I checked on arm64, there is no case in which there is a hole after the
>> linear map, but still that assumption shouldn't be made.
> 
> Oh but we could access a linear map address which corresponds to a DRAM hole, meaning
> there is no entry in the kernel pgtable.

Yes, exactly. With debug-pagealloc and things like that we might have many holes
in the direct map.

-- 
Cheers,

David

