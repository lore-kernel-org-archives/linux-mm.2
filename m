Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8630ED7B95
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6156B0088; Tue, 14 Apr 2026 05:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FEF6B008A; Tue, 14 Apr 2026 05:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F77D6B0092; Tue, 14 Apr 2026 05:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6346B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:51:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAB6A1A04DD
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:51:13 +0000 (UTC)
X-FDA: 84656693226.13.471D80B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5050180005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:51:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRrQy0Mm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776160271; a=rsa-sha256;
	cv=none;
	b=LgQDrlE6CAq1ZT4lWVJN+tQfOzIB44Ec0nSVU3WZNvQzBZ4pqghmLdsAOyTKVy/4xIIMbx
	85F02Rre7gWFBtKiJDvPLPvUjFLviioeD508HCv2E4xgu1sQEzpnCH0Vc7zQqbWEv54oWM
	sueU16HagMF3F0LWl1CDMuXu9rDLEbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRrQy0Mm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776160271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhOifuXw5RbcJbG/j+f6jSu+EwnwEvgJH4NurYsFARI=;
	b=L1gKXoeHii5SbvnGim2iXaMBpBSuav+7RL9/dVRWEow1oboklU3fUjLWSC/cdm3Gs/luVW
	xIVE445ND/+z7j86l0SltkaP22ROrF+AspXaKoMw879gyltY1vn8c271BdjCS8WtmuoTmF
	3p4xaKjVPuI3zm0sOJROOmUJZdR9Tds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4996360018;
	Tue, 14 Apr 2026 09:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE048C2BCB5;
	Tue, 14 Apr 2026 09:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776160271;
	bh=50boV389vtA1+fAhY6j7k57/eNUILSasLReQVNKDYe4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nRrQy0Mme0Zu5CmHdzP0kUS4hRX/b17AcEx5OY8UEXG+t6/Lv/c5bBDJCjZ3XOutK
	 WUGiIJJZ9rEgXUikzo18NL0l4sqDdvC4iHxGFC+LILjeFo6+SGbnn29Gwbd8VCVlDL
	 zjmWudHYcVd0j2qG9oi82PfgptpnLdO5ek6Jf4qvdTZOC++n0SVHLzNAetbhaws2pb
	 DE7V1nzK+8FJjhHH03Qxjoo4TFWGxPTOE4ieYMvcBHZ06A1J7iAJuVejSGioFSCPA5
	 3D4jbnpPvh7Jq/PSVB1wHKknH0V4Qnc+KNM/P1Tj37q1RGAZpXaQxnSLCcv/SUG4a2
	 QnXLODj/wCIfg==
Message-ID: <5914d296-934a-4662-b1cf-d0f23757df5b@kernel.org>
Date: Tue, 14 Apr 2026 11:51:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix double unlock and remove dead code
To: Zi Yan <ziy@nvidia.com>
Cc: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Balbir Singh <balbirs@nvidia.com>
References: <20260413130927.13263-1-nueralspacetech@gmail.com>
 <7579105a-1261-45db-90ba-5e660d202b80@kernel.org>
 <6073CBA5-2762-4FE4-98F5-27BC92482531@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6073CBA5-2762-4FE4-98F5-27BC92482531@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E5050180005
X-Stat-Signature: otiojjdcrtb4r4z573bjez1brybuwdrr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776160271-6227
X-HE-Meta: U2FsdGVkX18XzpFtBs/8qdDa+S0d2iMtcAkifbHrEUeynEj3ZmoEVNWGBG0gRCh4iRoX+LsdS/6caheeRTfeAZMUwE+pSeYCg17Z9bRtYoqe2vQ8yvJCU91UPBQCanJnbfeMsbCTP3kdvncqpsywZmLEQG23UukUPQbr2zf5GafX7V50Cqzf68L5KQKxaRIMffvwBGx5n9YFciZkjnkYGfUE9e1/QNhZr0bOx+fDczA8LzHKssQqkHm1s9N2AFoTetCQgyJ0uSnwEtOymkzIQxIZxVprgBme7vACAkBz5UMheYd/GY/kGNRi/N2nbZ/A5XodSsLLbHsXTvLh1lJXKORo29w2SQcc0KKTyEPm0y9UAn8d3FX7Zmi4mPMf/nGOgfI/dK9p+27G2++WFd86Xfe4MtC8IlihxlsqABkvd6VX5QS9sFWGkjuc2zKe+L43lCkbFcybRkCLTTyOmaMd19CfK302M4QTe4vkYzReURHohdj29VN1dCn4Q5GwLHTT2MoZyB39L6w74ETM6pXf3+RP0lCfap4S+J6m1fnbwAOrPrsGVRQ06p9EXEDV9fSERW8kBI/1rsHZcTpMP8E6jB9rGZDT2ii4dE3nBU77z4uCl9+uqNBaLIqRXkZJT2sqiH4/MQAElWS8wsvh73hjStPViEQe0CX/W0h5iNfKbduWqFqCUbVfe/o4AaihlELgrDcF9j4TC6jw0cRXD43hqilkRbhFhQ0NEUhHyw9VVNkec28G+gXpqfrHifeomnQGsDqJdiS4pTTKHRjeiIwoeqgq88+W4PWKwopTtv79gOPfAFFBXPONh56CQaKZO/aIBbiIKTh4nxByZAcXFDdzH99G93+qhSetQBLU+bDmc5RbKjzfvO4F8soA+zMXmvvwSjfTyoK+NX5QVhQbnH02DlRRJ3FU9JCQVvlL8YlHbN70PrAbkOGc+SjLDbIejBOhxa5uJ5Hv5FahB+dsdTe
 y0BJd8HW
 dEmhpYukwAetCI/PnpkL+qRYBjWxm5yn0yteqUb8AaFIjUwrgmoVG/owT3YigTgqRUVRmaQS+1hiQLgWspJm1rAEAfQ1basOuCF/U5l4narjT0g+5EfHcDWf2bi05spcYUj3xx4PbRRVdBUaYrdNAuibwZ8SgAXERA2ire6yj6PGegYyL7DSXBta2uNKlM/B5RQxNHZlGIJoh5484Cc+KJr8IbRP9xGPuoN1uUd5fqKL0CEcGCkz5HB99jtpXqxqhEtsh8e7NgTZaGftfmyK5gbT4uw1YZy0H8SUpGi4bIip3Ua4HWwt+fuWS4j1EothYCEPdjoYZ3BWrTXIjXLdNX7ZbhrIDgAe5faJA4q0DTBhMhVo6s86UTxqIrgNCsdImVSKDw+OuvYmoza5gdQlvYdDqnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 22:03, Zi Yan wrote:
> On 13 Apr 2026, at 15:38, David Hildenbrand (Arm) wrote:
> 
>> On 4/13/26 15:09, Sunny Patel wrote:
>>> Fix two bugs in device migration paths:
>>>
>>> 1) migrate_vma_collect_huge_pmd() calls spin_unlock after
>>>    softleaf_entry_wait_on_locked(), which already releases the ptl.
>>>
>>> 2) migrate_vma_insert_huge_pmd_page() has a dead else-if branch and this
>>>    branch is always unreachable.
>>>
>>
>> Can you move 1) into a separate patch, add a Fixes: tag an CC stable?
>>
>> I think it is
>>
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone
>> device pages")
>>
>> 2) will then be a pure cleanup patch.
>>
>> Thanks!
>>
>>> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
>>> ---
>>>  mm/migrate_device.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>> index 8079676c8f1f..0e005c26ee88 100644
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>>
>>>  		if (softleaf_is_migration(entry)) {
>>>  			softleaf_entry_wait_on_locked(entry, ptl);
>>> -			spin_unlock(ptl);
>>
>>
>> Yes, that looks correct to me.
>>
>>>  			return -EAGAIN;
>>>  		}
>>>
>>> @@ -869,8 +868,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  		if (!is_huge_zero_pmd(*pmdp))
>>>  			goto unlock_abort;
>>>  		flush = true;
>>> -	} else if (!pmd_none(*pmdp))
>>> -		goto unlock_abort;
>>> +	}
>>
>> Huh, how did that happen. I hope that it's not a typo and we wanted to
>> check for something else.
>>
> 
> 
> Looking at the function and trying to figure this out, but find
> VM_WARN_ON_FOLIO(!folio, folio) at the top, where folio is from page_folio(page).
> It is either a nop or a zero dereferencing. It should be removed.

Heh, VM_WARN_ON_FOLIO(!folio, folio) itself is completely odd. Dump NULL
if NULL.

Agreed that this should be removed. Or replaced by a

VM_WARN_ON_ONCE(page);

> 
> VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp)) can be removed
> too, since the above ifs takes !pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp)
> to unlock_abort.

Right, and if that's an unexpected case, we should warn on that path
instead. Like

	if (WARN_ON_ONCE(!is_huge_zero_pmd(*pmdp)))
		goto unlock_abort;

> 
> Back to the above code:
> 
>         if (!pmd_none(*pmdp)) {
>                 if (!is_huge_zero_pmd(*pmdp))
>                         goto unlock_abort;
>                 flush = true;
>         } else if (!pmd_none(*pmdp))
>                 goto unlock_abort;
> 
> It seems to me that the first if should be removed, since if pmdp is
> not pmd_none(), others filled pmd entry before us, so no further
> action should be taken, otherwise, the function will overwrite
> some valid pmd entry.
> 
> OK, look at migrate_vma_insert_page(), which does PTE level work,
> the above code might be intended to do:
> 
>         if (pmd_present(*pmdp)) {
>                 if (!is_huge_zero_pmd(*pmdp))
>                         goto unlock_abort;
>                 flush = true;
>         } else if (!pmd_none(*pmdp))
>                 goto unlock_abort;

Agreed, that makes more sense. Thanks!

-- 
Cheers,

David

