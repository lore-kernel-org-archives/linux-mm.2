Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B69A4C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736E46B009B; Fri, 21 Aug 2026 05:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D7D6B009D; Fri, 21 Aug 2026 05:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DCB6B009F; Fri, 21 Aug 2026 05:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 320416B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:32:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE8D31C17B6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:32:20 +0000 (UTC)
X-FDA: 85124760840.15.7A8850F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EF138100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:32:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrUtN3Fi;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787304739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhFDMwjisFQlmA53RTr6EmbhwCInFJVNArYz9R9qOUQ=;
	b=o5WTdzFFyOgtrtGQ+SMDtdNm7nSgz+arInQHwqtDW+Ws8hlpRyU7UmMlJMqf79Z7z5E+a7
	J3BKZYZ4rjH1brLxBy19SMJbjqvLsC7UUQAy8Wrr1+Eki+omYoAs2NWEFiNyVX2tSSbwRG
	LhU/JoVPsy82gwerXP4uNxoMGK3soxI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CrUtN3Fi;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787304739;
	b=g+BU2UBtioP+PbXtS+W+D9dkmT+6CVSAzo97IxIB+Tq/wtYg8CPTErlpdADtw4QO0z3KI6
	gYx8gJinJ5DCt9FRjeBIA3sgc5JrfihIy38RlH2IZ/1P87v1SiEM+XfODTtIhBXgeTlPc+
	+Ie/DqpRmdYde7wB3a3K2lDnz9+LDk8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF5DD42B00;
	Fri, 21 Aug 2026 09:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779721F000E9;
	Fri, 21 Aug 2026 09:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787304737;
	bh=FhFDMwjisFQlmA53RTr6EmbhwCInFJVNArYz9R9qOUQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CrUtN3FivWiRmuwK4pcrEznRzh4JuAN8BFS8RElvfSQtHfOHcf2NtiZ0F8mwaBMjx
	 BnSqoWrVgE9x0mJR5jzwBU3De2TaOArD3l6lcJNlHmoriW3pp0p7F4qfIMRknEZOfO
	 Cm1spU+sKk/vZz4oNh3jPqLT/BYGxUI6YPcnOia8bY/KRxpx1PsJilmhLsp9ZGyPP/
	 oMXQnXnsv04vpHilaHmfIYd7Q+IXNDovrb6+NYJqJc6lFFv9QBbQ2t6sfBAd1D6hAM
	 OogdwQbZ2KzYMn8zTdolQywifgNeOrx5LSal05zTVdZSdttiGdkMHZNPbnOjDU8miP
	 FZQdJXT4phKgA==
Message-ID: <f8a06140-7cda-4fc3-a121-75e4745d6182@kernel.org>
Date: Fri, 21 Aug 2026 11:32:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more
 robust
To: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-2-yuan1.liu@intel.com>
 <20260821031427.qq6mb3j2zqtzdl3n@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821031427.qq6mb3j2zqtzdl3n@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF138100005
X-Stat-Signature: frpwm1us5feiikfxuw3cw3m9pfm8to9k
X-Rspam-User: 
X-HE-Tag: 1787304738-33740
X-HE-Meta: U2FsdGVkX19pWBKu9TqMcoGE0NRHUPwD16zpfXlkUiib1T2eh/S5RCXnGMoW0gfgJggvWA7BUkxi6EzAt2s1x2kpf2AB68MD+aApZ7EInHrM0Zl++pEM7DxO2vDDZCPYzNAIos9XZkvqXZ7xarryUdtZ5fPui/Mt1Hh0amd7MsgA5TmUbswU6MsUMVRdGdYlXilzBecGEgddwGpmNYEcmF45/QCoFozEXfpq1T6qUyReL5ZrX2rx5xjggVi1n5ARq/+RjindiQhe9pUGpE3uS1hTzWGynaee30T7tfZq7FUx0hTaXMWtW5WXrIzxCeLcy0BN5axHRUF96KHmc3jUEKX/kUws9D9Pr897Pfypy7vVBQYQ/2stq80R9q1F1xLxySqcresAiVpjsRnb7aMyubAIeL8vX/kssUMxWiS3kSunW7GtKxUf6KCO+f7gSHMQI/Bcit36lPLf2bjipiV1NJjCyapLX31Dapib6r7FO+0+hntbIyV1Z/eodqABcR3XdGs/cEbYGmmFYASYoDUweY4PNoT6IvzmQgdqTWEMhWHLrD84U1LbFpXJJJdQUbk6DhIYM71ITtZNCZav1/InwkOIkg1dbsdPgsO+NbN/9i4jEyEE/Zd2HXqWN7pDyH9ofv/Xk1MY0CeRBa8zpeNPVRWr3pZJ+rlOCBMtEktZtDcfNhTA500eFpKgBUEAASjJhw1ch9RE9UBFXe8GGLcdOyp8PU42NTbwcjXvv2G9Tz8jU9AyxRBerje0FVQ5VMbXMAbPf6ycpTw80Ro6AeLA3rJSxFbifuCeGH1u9lKWkTQS/1AsZfEcMYFfJzG4kSo0WT1QkhKarlLnjQuScdbxgztgjyOhsZPBCAIpveM3ULjJ+3YPjv+JCxnAsnZZatworRxVml6tzXG4v0aXTdIBc8Kwjt1pDqjZhr6PB2qJEh5ymfKvfs0IduxkQ0Fzjz3TyjHfldgczdYH0eFSfER
 296z0A5D
 TWHk48eiWK3gJF/nqz2HzP8NvTLG15k5dHmrsWfh2REACtCnPdVcmpsXby0ICFzUU4aYOHOBGoWzzfPK1xl8NBoJrlkrwyngOiPBVs1Qf6Jh1N3J7IaEoqrFuRsZuWJ0wUDfOsrmEY1y4WA543NkTKn3iA7PbZszJ48MvOg52E46JNqNn0WPCBGkxNjgFXrC7KU/xm6rvLJPYJS1v6UwYq5mPAtPNy0DeS00m5MODsqxAIM3LEJUPI0GCz3R2cRtgRkBANotOYvQUz85CyIFKbpre+ifFb7lHxaAgCe6JNY3FXLosqJgojIGwcktzPAr3+kzkW4pZEwnStykxvziVe7MSvyBaCMPM5sIIMQTDx+Ls4FdPALxPLIWKo/pUyjsEcHvXWvwDT/KMTrAmFTnpt3FWoGOPolWV0VXTJ9BmnJ/+UTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 05:14, Wei Yang wrote:
> On Tue, Aug 18, 2026 at 04:57:01AM -0400, Yuan Liu wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> Let's make shrink_zone_span() more robust by checking in
>> find_smallest_section_pfn() / find_biggest_section_pfn() that the
>> start and end PFNs of the subsection are within the zone.
>>
>> While at it, clean up the function by factoring the core check out
>> into subsection_overlaps_zone().
>>
>> There likely is no need to check the nid first. We require
>> SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
>> pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
>> So let's just drop that for now.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> ---
>> mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
>> 1 file changed, 24 insertions(+), 35 deletions(-)
>>
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 7ac19fab2263..cd82e79f0782 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -422,49 +422,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>> 	return err;
>> }
>>
>> -/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>> -static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>> -				     unsigned long start_pfn,
>> -				     unsigned long end_pfn)
>> +static bool subsection_overlaps_zone(unsigned long pfn, struct zone *zone)
>> {
>> -	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>> -		if (unlikely(!pfn_to_online_page(start_pfn)))
>> -			continue;
>> +	const unsigned long start_pfn = ALIGN_DOWN(pfn, PAGES_PER_SUBSECTION);
>> +	const unsigned long end_pfn = start_pfn + PAGES_PER_SUBSECTION - 1;
>>
>> -		if (unlikely(pfn_to_nid(start_pfn) != nid))
>> -			continue;
> 
> Would we have a memory layout with node interleave?

I think core-mm is not prepared for actual overlapping zone ranges during boot.

-- 
Cheers,

David

