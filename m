Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E51E9E308
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55E46B0089; Wed, 11 Feb 2026 08:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00746B008A; Wed, 11 Feb 2026 08:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD87F6B008C; Wed, 11 Feb 2026 08:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBBC6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:36:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63F4C58B04
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:36:15 +0000 (UTC)
X-FDA: 84432274710.28.28AB109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A614740007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:36:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NL8Ph1h/";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770816973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34ki+gq+WCz+6s4Lq089pQ1254A1zHt45sThwYDN9R0=;
	b=npeKixvFwA6Q/yZ9Nkuc3hpyzDRICTqdqVKRtXF3GTbK2eObqdd3BYS+JeRjGWJIO5KXk+
	MT8t7BvYPbS/yZT1mzVHxORG5Ro6d7aOLDX1ACr5seaNp7RRdCrJS8AZtmUX+mzj6v84B0
	+5cSs6k5MLUpyTSKfHgLBcORoF5FGeY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NL8Ph1h/";
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770816973; a=rsa-sha256;
	cv=none;
	b=7UV6SIZAmg7J73QeDUqpJxkTAVTQHVM8Yggg/TVe0E7Inqozn/RgC3cG62XdkYKXcrdEz1
	png6XOieui/YofFneRjShIRtnFt44kpWwVgFvMB06URpgqYemPrvmcpmAdpZ4D0IYEBmwN
	WXn5QCm0KtSrmjq2xZaAy0VHMY8SGAc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2580D600AD;
	Wed, 11 Feb 2026 13:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76ADC4CEF7;
	Wed, 11 Feb 2026 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770816972;
	bh=0Ym0hGHwyYREYAxpyb20DRuFrXKGqb5/4e4ZWTYOYb4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NL8Ph1h/nd6o6Th4kstHHReripYkXBnzHR7cR/3q40TCywhZupykGsqLNvWUtE8Se
	 9wQB649shMlU+RzKtw5VCTwmEXDGHvc0BGGKJ/lCDSOT+OXOidSXTDGU1FwzZGkDYW
	 f1px/JVS3AnO1q+3+rl3H+W4p3JgzThbjLt+SEavTHvFkvv7oDX59Uax2Ixd0M505R
	 gLcisyUs4m4B4at4WVF2IX27tfUFstOtsWzcnOlC03on9VHPtqqd1f9HCg19RwlEKD
	 uGtJFWMfici6d36yIWVAoi0hmmAnVdcx5HhyY+70HRJ6ZVAWKOqaILtqHuWVRlDVB9
	 kWNk5rj7nd8zw==
Message-ID: <c722e14f-a16f-439c-92f0-1318fae2cf4c@kernel.org>
Date: Wed, 11 Feb 2026 14:36:03 +0100
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
X-Rspamd-Server: rspam11
X-Stat-Signature: ixh6ttu4xmw5uchgk9kbt95fp33etiw6
X-Rspam-User: 
X-Rspamd-Queue-Id: A614740007
X-HE-Tag: 1770816973-431093
X-HE-Meta: U2FsdGVkX192mGFp9ytE/B+A2/LaQT66ZxOBKil+SZxIkiZi3tcymOzVIZyubDCOwj8J6iS6adHMRgUHLAqjDGsbS5kg9/XVC90jIT8Iu9U7axkUFuZS7J2dQUITji8yuDYKGqlGVlIr7Skq2NXLmQq7qZCjVDMeN5g/cNZc+We3JNzxhu9lh56+xwT/LueeoLR0TNlfldO5n2Qtzrv59/YW2mgr92CGofSK0P7OPKoLAJ267TH2Oj5thDIqw6zC2/q2fGwRjyOXtR23iXL+58GOfzaXChVmYie0w2nIFfcae1zGmGstk70I6CSBgj0uiny90/AkPziCo1e+aX3HGKoc+v3wvsinBH2HKLQ91H5JxtRgEHXZlPBOclZFhTD2xsUf/BOXLHvr9TxkeFezOLQaW0RSzvfmPhwZKt4l24eesrRunc5HTfIrf65X/PykH/4a0vLcTLgMMjeVJgkY47J1YV0TTRtHYHI0OQnm0OOYFuv7DRezmz1633KRbwKp0Eiep06WuG/KyU5yov6FLOzjbgJmHUKrCiJLRGKtuw1JBUs5rC9/JBrjcANNYV57CORBGvhfDY/KJ3scQcQtd/Abx+7YUDFUftD4Rr4QgoKQ+4ccCnaLYbNukimhC0Rmkp9LysfUMnjdan2lQ6YeCFBnareRjaYwoTrE7eiyWT0DuVgmBzFsckhIEGYZJ3T3VsI0dLrEOjzDAtFbshdM5rGwr2yQ3FWdMm3vEy8voTxfU0EVHKq5GXSJbE3Se+0fwxSK26MXrLDNeSgCIdA+e9PzJ5Md3801SyGCPwuTXcA1HWKWgChnmeoeWlXGw9VMaLnK5ffjPAT1tzlqGARYOlZ87BdoJImvFdq0UJMeavwYcwmmP4dV3owNMxseFGB0QMXxVzLrYJGrdrR+ml+ecCghQcQdVQGcrJ2UZP8kRR0WWu3YJrh5KeS6wQzRImYGdX+e4HQvqKK0+YSJvM4
 BgcDRNdq
 ALuoAgD2rJ+SM8HvuKNoPu7uWxiTjAQXU6eudpaLIVXH9N7UbntrgFzs+WfCXrPwuy2GR5ANKVPqY1IGJwqTwxrKb9xX/JUBzR5lR+jNH6Ug0NYl0hIhuHi5Qm8O/si6VckN9v/6oN2VVVxxSv6seA40SwfQ/its/xciX527QR/p/HyLfBYq16PJWzAgZOJAZyK9r4R33IwGBwG9pezrXPCoyWXnlXbdYWltMIIVqtfbAJUkIAOai/ko5ATwTAbxIXPKRTHTDqByKhV8PsxU36Zs9opY/0kNdfK6qGbVys5X5Rg2eVvY8C30iZ3lsq/6sYxndIDXWntIDUgM=
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

I guess it might be reasonable to have because I am sure it will fail at 
some point and maybe provoke weird issues we didn't think of. In that 
case, having an indication that splitting failed at some point might be 
reasonable.

-- 
Cheers,

David

