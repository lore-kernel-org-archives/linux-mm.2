Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD28E9E305
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2206A6B0089; Wed, 11 Feb 2026 08:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDE06B008A; Wed, 11 Feb 2026 08:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F44A6B008C; Wed, 11 Feb 2026 08:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3B126B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:43:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 913761603F8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:43:56 +0000 (UTC)
X-FDA: 84432294072.29.17D3DA6
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8017716000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:43:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0XyRy93;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770817434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KLG8bhLyjMsETJH5YfhYwScAEgCa0JqyUBbwWjyXRg=;
	b=uk8o5NZ4XI0pI+008b6XTRZbd4z0fcmWHOXIewa0HIalmM0wkbFrsEzSjfaL/jELTb/fXd
	tyes2djhc39zBxCwSc0FOR7i8Gva09f/T1452YV0ZXptpx57DIiGSq5q1MW1DKQKpI4u8f
	YgzW6xncT+5K0in8jPp2waUHb/wf78g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0XyRy93;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770817434; a=rsa-sha256;
	cv=none;
	b=0PVEZk+Q5rUKizw2OmULPyA7zMlqI/0hKb7JkX+teY+zt7VK2msVqNeSZ2fZQ+Lb5UQ+i9
	ZivS5o61ASAEGGQtmJHS/AQJBDjeLqQVOBU0BJUXLXWYpX9+PT0MTMZ/0q3EMTgTW8RdeN
	xPrGxERUcxtCslfAWmH+9rU2dC1kWXk=
Message-ID: <f7b3b941-ed24-4471-959c-d25601de8366@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770817432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6KLG8bhLyjMsETJH5YfhYwScAEgCa0JqyUBbwWjyXRg=;
	b=R0XyRy93PG9P6ztb9vsQVoBS6kKy/UyrpL6qjba4sBBp5CFvGNouIpkSnL357KckPm0VBB
	tlPYqT5LTLL+2f+uk+kI75+SlHd0nbI5uupX+yuYB1HT7c/vZ39KG3iY5aoEbl0mPA40Vr
	gEn8sSEcKcernfBHMKFoky8ZxkmYq3o=
Date: Wed, 11 Feb 2026 13:43:50 +0000
MIME-Version: 1.0
Subject: Re: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
 <918b5c70-1245-437b-857f-0b202f5bb400@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <918b5c70-1245-437b-857f-0b202f5bb400@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: aruihkyp83dqdtyrh5mk3rashmuznap8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8017716000F
X-HE-Tag: 1770817434-520351
X-HE-Meta: U2FsdGVkX19HkWUW+P/xWwlH0iYtdmeQCLsuoRYR+opmDCmiY8WkTxYGGFDci2Ya/FtxBTPw3U+pWmGezHLxh12MXC9789W1ZxXokh+APy1J2OQdj5pjUyP5CfSNlcLcqF9Bff/vTmWKo7kzDwmpGjtKwNVvMLf6CLLHJLE/wUBRb7C8NGyoGnIqZcoRZi6mP8MK3n6PvlaaL+6+GFDZCDy/M68c1yuXTtYhhqe2J7iMISmfOllXx8bB5J/Oa8rB3MkGuD1axy+vvo0eOuU3eK/i3D71wMY1tQmUY4Ph3+gqREK8ih7Fe2v3X+qWXUk9YZzJADmZAWbT6PQXVDZWP4mU3uFcFkOgaGTG330M50aR8dMcls0TlnC0eagFUWU95BWisDtrwrQmUqz0reS1PnWXhOO+iaBjXpZTrudFc+jxwdi00lrvFo/LdsG5kRuhWkZ9JKGb7VcK3cav9gQVy33MxQ9tPV4dvR5TMiIIy7M3rMiTqwuvOoS2yMjGfLeYEPU0cRP0LaKdGDogFddTXAI/pC/Bg4xwzHHagRcJvjYG28ZudWssDQe9KW4WDFgOjBFg5HQCZOMi9rr9VCqV1Yn9sgNIMA3tTOV9JSm7FWQ1QKlR3TqJFKjBf47AAxpmKlMwRMij9HSef9egG9DRVDnk9FqTdSJJYnDw7r9JNCg3+OblALUIjE1B5sgJW8AIFAX0i0BZ4KqroCkH2Bnnik/wwMJHkjGVGVewpeCqyLoKIjWEb8b4iIk0oN1+Khiv9cATX3beZCnTUZksdjXQWdgS/wu4dNSjot/ihiLitAwDWSggT1A6M1YqQ5vwIOB1XZB1jDy0Rp2oj7vq6pZ9k/5lUergTPEXPFhMrOqWpmUjN1ps4lRiZJ+ynvaQOZRgig/IfymbIGH8TMQKUXjLqGyBHfir5/f/mwwFGe2FRbXhkG4yLi3PcTQuHahLeHfstm5gej9VQ79YVpxQTrs
 I/x78kwY
 Vg7jssyof/kRVPHytWh4C1SRHnM0nGytcrd4BKyeofOULJh2JUPPe1j/I1MuJEe5OIdTaE2mX6d3DIUKYubToA8P+LlmiuflDQeX64JOlcbLuaA7+4ZYgl6bu+QzHbA6EincboLJ5thqtn2SM7l7nHXIxpgWuo35Yuaj6FfPNoO05SGQQBsv935/YdA9cJ7q58chSUwEgv+XMesi2x+0k+rYDa7wYnQiAfbLvIUasIbaHDcSyEScrryRsObi47Loe9LqMoq5A20CGfSyyuk4ONOuI/MHEAAky69MS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/02/2026 13:38, David Hildenbrand (Arm) wrote:
> On 2/11/26 14:31, Usama Arif wrote:
>>
>>
>> On 11/02/2026 13:27, David Hildenbrand (Arm) wrote:
>>> On 2/11/26 13:49, Usama Arif wrote:
>>>> Add a vmstat counter to track PTE allocation failures during PMD split.
>>>> This enables monitoring of split failures due to memory pressure after
>>>> the lazy PTE page table allocation change.
>>>>
>>>> The counter is incremented in three places:
>>>> - __split_huge_pmd(): Main entry point for splitting a PMD
>>>> - try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
>>>> - try_to_migrate_one(): When migration needs to split a PMD-mapped THP
>>>>
>>>> Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>> ---
>>>>    include/linux/vm_event_item.h | 1 +
>>>>    mm/huge_memory.c              | 1 +
>>>>    mm/rmap.c                     | 3 +++
>>>>    mm/vmstat.c                   | 1 +
>>>>    4 files changed, 6 insertions(+)
>>>>
>>>> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
>>>> index 22a139f82d75f..827c9a8c251de 100644
>>>> --- a/include/linux/vm_event_item.h
>>>> +++ b/include/linux/vm_event_item.h
>>>> @@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>>>            THP_DEFERRED_SPLIT_PAGE,
>>>>            THP_UNDERUSED_SPLIT_PAGE,
>>>>            THP_SPLIT_PMD,
>>>> +        THP_SPLIT_PMD_PTE_ALLOC_FAILED,
>>>
>>> Probably sufficient to call this THP_SPLIT_PMD_FAILED and count any (future) failures (if any) as well.
>>>
>>
>> Makes sense. This was just a patch I was using for testing and I wanted to share.
>> It was always 0 as I couldnt get split to fail :) But I can rename it as THP_SPLIT_PMD_FAILED
>> as suggested and we can use for future split failures (hopefully none).
> 
> Btw, you can use the allocation fault injection framework to find weird issues, if you haven't heard of that yet.
> 

This looks very interesting, Thanks! Let me have a look.

