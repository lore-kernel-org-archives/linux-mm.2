Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A46E9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3F16B008A; Wed, 11 Feb 2026 08:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EF16B008C; Wed, 11 Feb 2026 08:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047AA6B0092; Wed, 11 Feb 2026 08:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E78676B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:38:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AB488B6EE
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:38:46 +0000 (UTC)
X-FDA: 84432281052.02.3862D93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8CC6340006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:38:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cQO6yu/d";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDvR3ruUEIR2ezvZtC+pPbR8cCnOoo2kAZXZVE42Jg0=;
	b=3LsUp2bllRiDaEpLKpsYLW96/NlWU+QgtBoLPqoUeHtmh8iep9BAMqRaG2rUgTkpruDc3/
	DAs0z4wWZEqR2/v4lfGlBdYJDoJmp5Tz7AxizLBTHB0OZR1gO2ImKOy61P6tLXcWrpuwYd
	776SoWhs18eeESekXNM7Eetj3qZOn3g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cQO6yu/d";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817124; a=rsa-sha256;
	cv=none;
	b=2Wa0rFyUckjDeUC9L6R0mQ9pLv36qATN35zDR91LDJBwrGzF+TjlTdrR4Mou40B6LrWFfF
	JH7gjXiKqgxZuakNaNspix6pfpMCjDLXQDFEakBIMUgg4L1oS8hIKKUKz1ESbYC6AMJijs
	hhSTgknXFkLTrwETs662wLCKY5e/pJo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9805F43CA8;
	Wed, 11 Feb 2026 13:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77283C4CEF7;
	Wed, 11 Feb 2026 13:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817123;
	bh=vxKgrHZVw4JkgOa9AiJj7P6TH5yqtPll/hZN7NcKnYA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cQO6yu/dZV9H8BfFtp+IwK9dNsHkIgzx75i+QlEa9RRVUCKfBMmAICB0dSOxeWzY7
	 SHoCX6X93VE5Z6duovfb76zStlpEL0uIL6WLZjUl3MQL4ayxVDmLZOzndOH5MMo0du
	 igH4+GwTdg2iQ4dJKat7jTS48YBfY4lf9gjkfCssIuZ4QKe5lx1U9UGKjlLR1GHFfG
	 GhNrf9woBCBKitV2JP/Or6YIjF8pVXD5vV17VAmGWP9/VuEOsGuLdvyTpLddePDyRT
	 17oWaDMxzVEyIbzPEsDCnrYx/JgK0TpNiMnpkuZGKQenxHlIXeeYqiyfn4WNi/ioPu
	 mMq19AXKQtNAg==
Message-ID: <918b5c70-1245-437b-857f-0b202f5bb400@kernel.org>
Date: Wed, 11 Feb 2026 14:38:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-3-usama.arif@linux.dev>
 <b980ef1c-2dc2-4853-a873-7338e2d36178@kernel.org>
 <7790f69d-7406-4535-994b-8f4b240269ba@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7790f69d-7406-4535-994b-8f4b240269ba@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CC6340006
X-Stat-Signature: jmxci36kgsi6oxohspkbzuts7zmxb8r4
X-Rspam-User: 
X-HE-Tag: 1770817124-638421
X-HE-Meta: U2FsdGVkX1/r1watorPDQt0OuN/yUyEtLqsALvvyJKSXTBZsW2FkOcFACZlGQgTlOuoS1N3L7/ub7KcbhYjCdkfPTik2ZK6Jhtyj/ii/E/I4Uf5fYCAu2kirDVCKRF5N3OY9h157oV7D6yFmfhtgRD3A6Joxs0/sVAPiHOReVGkHe2qIBxFr5DgyFOnpV+KR2H+7HtOFkJtqCChAym2D8J7eX3YYrHPgkTnUiwAOpcGyTVhTq/33ffIiraos+Coi+21i9HVsSuz8dpbRZ31c0CVUDW3Z/ontzSrMm0YTkkEyuCA7eustzbjMPQywNcRYIDxHoGNLPz8M0Cwir/BNUFdHAtbJW0VLzo9uxgHN664oveLokoHjy+DOIbwQPcHEvt3JcsiGwaHPSCCHYbRle77ft4yZzEptFTt0f0RPCTR6fDP4MvxxEQZS5JHnMdb7GMx52tUCb2pYphnbOib+avArbVbtdEdlSJkKAjZ1nOCHkWhV3SDnReRjbOdBP+VEDt39VBZpewModwbxNwjD81id4FpjgN076MEHFbkxq74jzAmMJRtbRCfxWPGWhLKgA96qRJ1kv8vPMYGlP42yzE9S7XzVSPbNGwuoT+wiBNMqV75SOvEl0OFMPiDj98om6x8fBIQNxGt8CN4m0nmSnz7jenwgK7P5WqPTyuCUIN+P6Pb41rxsPCwJGc16rr43NfDR5s6EvgUiMiTKvhSlSfM0hjA+QDa1J8PSXHkhzXBmJwuxzjpE4HjbJ69Uk9UK4ww4VJVeCwPfuJL9DiK9gs4rs2kzgH8IxNCfFgj9wftWIbFGVSh8q9x6Xo6ud039gJGktaxBLlbL5hyn0h4i4VSEAMB7gKjoVkgBdwDFhUyQ9eq35s9FeW5p0NKCkmVmRtCmr6CajSQGOP8eBiPXebdyZrc6nXAvsg5miVRZl1aVAj2IcRr7yD7HfJIY4XvW1jg8OuK4bSd39X3oDCw
 YXuOS+0C
 8WK4B8QLPD9tstBVP/cqnGOkjFRPl9bCDMgo1mh65rPaKscHDiyMg+28htmldfDJynPzvN7aTwMcCwTnvNS6xbuXToH9sgsiQjgefzSIbi933r9gR5GQJPti3e37fnYRdl7F2DkvL92Rt+YlbmAwnUwlzIycLPCSwemffBriGWnIZoJYw2d/kJnO39assQGVu+MevzyzqcardX/w9hnrR4uzPliO1y6u1o3YJJ3t/M45/n/CyH6TMU/kg+xQAyLL4teVP8FFptCZYM1nB9bMPMVxmffeAwaNwFBT1HHBhbJHCjIGgHy3FIUhMH0PHUWI2w6dGhdKzaMxe6TE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 14:31, Usama Arif wrote:
> 
> 
> On 11/02/2026 13:27, David Hildenbrand (Arm) wrote:
>> On 2/11/26 13:49, Usama Arif wrote:
>>> Add a vmstat counter to track PTE allocation failures during PMD split.
>>> This enables monitoring of split failures due to memory pressure after
>>> the lazy PTE page table allocation change.
>>>
>>> The counter is incremented in three places:
>>> - __split_huge_pmd(): Main entry point for splitting a PMD
>>> - try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
>>> - try_to_migrate_one(): When migration needs to split a PMD-mapped THP
>>>
>>> Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.
>>>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>    include/linux/vm_event_item.h | 1 +
>>>    mm/huge_memory.c              | 1 +
>>>    mm/rmap.c                     | 3 +++
>>>    mm/vmstat.c                   | 1 +
>>>    4 files changed, 6 insertions(+)
>>>
>>> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>>> index 22a139f82d75f..827c9a8c251de 100644
>>> --- a/include/linux/vm_event_item.h
>>> +++ b/include/linux/vm_event_item.h
>>> @@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>>            THP_DEFERRED_SPLIT_PAGE,
>>>            THP_UNDERUSED_SPLIT_PAGE,
>>>            THP_SPLIT_PMD,
>>> +        THP_SPLIT_PMD_PTE_ALLOC_FAILED,
>>
>> Probably sufficient to call this THP_SPLIT_PMD_FAILED and count any (future) failures (if any) as well.
>>
> 
> Makes sense. This was just a patch I was using for testing and I wanted to share.
> It was always 0 as I couldnt get split to fail :) But I can rename it as THP_SPLIT_PMD_FAILED
> as suggested and we can use for future split failures (hopefully none).

Btw, you can use the allocation fault injection framework to find weird 
issues, if you haven't heard of that yet.

-- 
Cheers,

David

