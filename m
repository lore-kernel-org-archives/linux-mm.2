Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B7CC5DF96
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739F86B0093; Wed, 19 Aug 2026 11:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB8F6B0095; Wed, 19 Aug 2026 11:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2866B0098; Wed, 19 Aug 2026 11:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326A46B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:58:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB0C3C02CC
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:58:02 +0000 (UTC)
X-FDA: 85118475204.16.C8DA3CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CDA81140005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:58:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C0fgsA+2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155080;
	b=VX6X4147CAYcPUbkHDlw4hZ/BLfPzTb82oBykv6Tb0TTLv8a9P+lQaGbmtUE6EctPhm9E3
	m/tGkoYkp+/sHEgRAzHZjkbBABR4rAUniPd2XFkD72JehvKqg+5jBAntjQwsl4JgdEv9q/
	8U/XV0Tg2IwNO+wRwILeQm3FESSZHLs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C0fgsA+2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgQJx1AdlduwHjKt1bqT1KprZQI76dNWF4lNFIEKvWk=;
	b=qHB4e4S7IlDyy9XRNeegFm4h9i/8vv4ADTo9B7oAKzGO4NFE+nE5os0DzGUvthWGZeDxLs
	AV20LHFaahIifehbXGbzlb0vzHgCtXb0unHtyYZ0gaeBdUBRKM4BQFk1mJDamaP0rhEjYb
	et7ujt3yMmTNYTcIHWXZs98aKOJHHoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3741413C7;
	Wed, 19 Aug 2026 15:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EA01F00A3D;
	Wed, 19 Aug 2026 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155079;
	bh=pgQJx1AdlduwHjKt1bqT1KprZQI76dNWF4lNFIEKvWk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C0fgsA+2ztb2d9rph6EjHyxIYz1Iz0QdEDMFkrqatm+trbZdkCl61C1tA0EGPVX9M
	 vcSQ5TVgr19KbZMVffQLAXugJVTWq4L33vBRDuLZJB9uas/Nadhwr0OjE3Y8T4JdZ4
	 m/7ThuYfPZHhl2r4gin88rouDtF158cCt1yFM0c05cgryYi6RYwa5WH1bhvfzbEKVp
	 DPwtlzdc8zLWf91dftIY+6n170P1SVIpJfoTkMEtp579rJSMGnmoRrNK0yQdCign+G
	 vKnto5ZVO05M29TCjkrn0mFdEPUGvKDPIXudi1kdB4+8sNq29qRFOP/PmW1hDmzr7P
	 7aIU1KJcGZPMg==
Message-ID: <0a6186b2-0e0c-4d6b-a3e1-c5e5cb75d669@kernel.org>
Date: Wed, 19 Aug 2026 17:57:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
 <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
 <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
 <20260815015532.ei4abygk4erdtlhh@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260815015532.ei4abygk4erdtlhh@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDA81140005
X-Rspam-User: 
X-Stat-Signature: 6d99yz3wk9b8aha1zs4chomw3ahicpzr
X-Rspamd-Server: rspam06
X-HE-Tag: 1787155080-17085
X-HE-Meta: U2FsdGVkX1+TwIG+GxsHBwY9kmlCjdqRlPjVt6euQZtCsVAnIFiROdSj8Z5EfPOOwcbwTYGlntpKI2pixVfcFTYmgvbKOYnRo2ucP/CIBnxunzCejHJQJ9hmP1K4kWIe3MHIfWKnAs0mMUwUuXWQADNyHp48xNwzApD7WB3K+H9GmiTh35urrtM7m1welLg4nDl5nqyYj9c08eNR3ambJ14bDT+Soqoxm1L7Mv55jw/7m45KvdoDAYUU7d0BqL6bfeHLR6yU2MXp0YQuydN3hgZvVJFfjVkhVxU4OaClFNxw4R1MxvRP9X5wnlCg/OEgy7OwVKsYDs2RclXTkK/w6eMQYPRPmo7z2Ej1JNVmSb8jFIl2HjNZhnXpgCg9WY5YT7jlJVgEUcb90fRRQIRB0cbAGog22BiXI8G8uYC2kI1Nnoh5UwuB+OEIFikcjRvwRm7I/J+QIx/nHawdNYhaCdvUpU2b2zdKhfolk9amaRQ1IOWsXAIvU9HPl9qDRPIl9hk+4lAjewNREk97XRL3g+gcEZQTxeAZ202o6VjwVwylqpxypS9CyQmwpXM3/iHOKuVmt7eQO6AkNSzrBFgByV6iSm0ZBOQja6IxKouraNqXlYwAJjwgI6vUu0YoiWhbDgYK0xmLmtXkqXM2SvbW1tN4Sw6DRir3JoioTH9L2bUYu9e4ma8ozo48Q+kXWNCDrZ/Rx9XySXvvlCo3wpm7LZQC8nVLrGmDhjQCtiT4USmLG6KabqHkp+gDV1fvKdbfMemf1f8ISZpmKD/pQar+3uNPxb9o6MDTxGxMF9huUAJ16mYT80s2gV+Vse3/EqLQ8Xn3Y+vR7uIX9Mk6xv9HWYXWRsTefr1tYKUH//Yqveqtb8TaOYY5azM9iugm7StK1vjQEnYBAlgn5REo6w74ov+XM5f7DYQqIvx9U81tkXr9UMqGSc7f/AK3sOsRt3ehhw4xPK2jPhL0qZU0sIp
 iJU242MZ
 8FmUCjW5M1B1glTUtdiV6X3oyT3WNqND24P7pxMDIiP/a+KP/SE8gLNoB0klRvRzfPFG2J468xPJXDpD3EyMb3n/pg3EfgVFl4g6g9K7B0pxsajLDry3reXVlkFDIOi2A646u65dJySagcmRg+/COGSFSiOK3HnBrdAfmxYSTk8KNX9CtK0xcSCpAX4IU37UTjn547U+cF5jjyWrV8vp6s/tHYv5sHyVZX4G0T2PnyWwPJDSF9jbE9TgfbMPppnbS8yCGu3jd3AqBINHLPciE4Uey+ZSnSiibTcqDIHZWd1K53RtYjUnbI4XP3O6alwu3QiZJS4IopwSqiuJXRBQSh+SraIkNIJIKoV/c3ybavUq6z6CGlWzFxlL4IoBcHsjRsDZP/liq03oqFzm3B0DDY5yKuevUwyBn3bqdppoRDKFSO24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/15/26 03:55, Wei Yang wrote:
> On Tue, Aug 11, 2026 at 02:23:18PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/10/26 16:04, David Hildenbrand (Arm) wrote:
>>>
>>> Thanks for reminding me. I think the right direction is to finally clean up the
>>> pfn_valid() handling.
>>>
>>> Let me take a stab at just having pfn_valid() / for_each_valid_pfn() respecting
>>> the subsection map.
>>
>> ... and that turns complicated very quickly. The problem is that we have some users,
>> in particular the buddy, that just assumes that MAX_PAGE_ORDER regions are fully
>> accessible.
>>
>> The fun begins once we have MAX_PAGE_ORDER span multiple subsections. So we'd actually
>> want to initialize the memmap.
>>
>> The pfn_valid() vs. pfn_to_online_page() inconsistency is really nasty :(
>>
> 
> One thing I'd like to confirm.
> 
> pfn_to_online_page() is expected to return an "online page", which is in
> buddy, right?
> 
>> I mean, in init_unavailable_range() we could actually figure out fairly easily
>> whether we are dealing with holes where pfn_to_online_page() would succeed.
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index e9c4204b73adb..54e71e17f2c3c 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -843,11 +843,13 @@ static void __init init_unavailable_range(unsigned long spfn,
>>                                          int zone, int node)
>> {
>>        unsigned long pfn;
>> -       u64 pgcnt = 0;
>> +       u64 pgcnt = 0, online_pgcnt = 0;
>>
>>        for_each_valid_pfn(pfn, spfn, epfn) {
>>                __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>>                __SetPageReserved(pfn_to_page(pfn));
>> +               if (pfn_to_online_page(pfn))
>> +                       online_pgcnt++;
> 
> But a hole in early section could still return a valid page if the hole
> is less than a subsection.
> 
> Is this an expected behavior?

Essentially, pfn_valid() is always true for early sections.

pfn_to_online_page() is only true in only section only for parts marked in the
subsection map.

So if you have a hole that covers a subsection, it is not marked in the
subsection map, pfn_valid() would be true and for_each_valid_pfn() would iterate
it, whereby pfn_to_online_page() will reject it.

Zone shrinking will later simply skip that hole, because !pfn_to_online_page().

-- 
Cheers,

David

