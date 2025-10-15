Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EFACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 04:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8FDB8E0005; Wed, 15 Oct 2025 00:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41018E0003; Wed, 15 Oct 2025 00:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56AC8E0005; Wed, 15 Oct 2025 00:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3C5C8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:49:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A9ECC0B29
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:49:48 +0000 (UTC)
X-FDA: 83999120856.11.922175D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 642551A0006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:49:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EZ2qVHvF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760503786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygDjvocgrySJ816q1hlB757s4pG93J0anp2ldxVExNw=;
	b=V66xpOPVXJ8rjeZ39eTa4lxaKMcie3gjVyP+Bpeus88panT0VcGMJ7IN8EpiFp8B0C0Bdc
	rExLCbqs1HBGFu5Cq2g80QE5m6JfWsAzT9KuV1+4SymfHyHTIgP2Q6HsA+1yZh83O6Ge3k
	WwI2iLglDoa7rHiYVWZ/FiAJ/Mbvch0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760503786; a=rsa-sha256;
	cv=none;
	b=64BgJvlTw6jeYeVmbYSoxl3lGnlW/Qhfoov74V/vo4CQEtQotsO5ZhyutaP7rgkrQmbIGO
	SW+n6xtGKTmHt4/ZM2+GLRjErA8WNJHY08gaEjeL3Slwvr4kUt2SY7qvBCijv0y+nwXVC8
	sz2I9oU0lfzOeib1mRF4rkzXqjv1ElU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EZ2qVHvF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <80771030-0d8d-4f65-803a-f89da3b59796@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760503783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygDjvocgrySJ816q1hlB757s4pG93J0anp2ldxVExNw=;
	b=EZ2qVHvFYwYzxX+uULJSA7sCrdOmUs6JY/QrAORm+zvi+iwUX02arVUPk2aOEXOzKbuR2D
	C4ObtDFndbyBJbZH1PsNEsulxhfdOrVUBcD3h0GpmMIdS8fFEm3eZ1hnSuc+fcyyFEqUYU
	WrrPZrrDaH1G2y0C7hxW90gL8+nlHRw=
Date: Wed, 15 Oct 2025 12:49:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 richard.weiyang@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-2-lance.yang@linux.dev>
 <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
 <cfbd4f48-69a0-4ba9-bce8-f578d9602125@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <cfbd4f48-69a0-4ba9-bce8-f578d9602125@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: gc8gctsnipzozezjt7j9dhiodcu4oyok
X-Rspam-User: 
X-Rspamd-Queue-Id: 642551A0006
X-HE-Tag: 1760503786-911479
X-HE-Meta: U2FsdGVkX19g2EEsRJEp47+9/14iNb+c1i+MAIybcwuzBuWQoKDbz37PzdQ8Pe2fdsWAmKKLQRejCo3WYSKGftHItehvPz3NUvq1iBYguKIiuAeidZweyEd3eID1mTW2PafDO23DZBbqWBpdSmJXYIpZkHYo2O2VDkwbT5jKC8E52b2kUWCEf7TRCiT54pkPruVm4qGU3F4uF6WJuKmfn48ROQ0IbpT8reTsJFmilKW1tSqoOLokRxSF0ZXSfKBrjLOHU0WFjVH9T1wyDGNItrEdP0mk+R1WTFWF/EITh3EkniPgYZG//4IDW8/Lmz6A9j4nc8dgb4+GluMWefsw8GBqlhyMcfPxPREpvwADs07HXJEfgDAMx4KOCfmoy68zrYww9JQXmtR6if7k1DxK7OImYG8TRjS3iZ+mNe6KEtaE5DdO32VGluwIF/Td3Nyasy71kRTXedr6SUyS6baWuo9pB8Y1iS69NCS2pWbCTkfG/TlDp0goGjyq3YsZWafo5qwWGuGR88es2RpXK/hWtHjgpAIf9UEST48G57XEJKJ9zib+iYpjpBQrov1635PUIxbjAkFVfh++KhuP6ZvTl/p4ArgmToC0oOREdPhil33vZdTaVOKqpHJVmD1qTwQLZrnOAQHS5S1GZ6JevFWTzcyez5+C1wH059MGUoYIAeo7qp0YrnIbyeAwPsOCruTdqIgGVKLrigUkEa0Dhh0l4Doqwq8KivUHNmxpwcppJIHu0YHzSWJXjQzHD8L9AJVd+GqE2hMVyVL0faV+KHq9HhBWQqu7ydm+efJrpJvpgxLKV4Q2EQ1I79ZFppdvGndlVg3pMf/Ru+MSL88Gbkj+dTXL4i2hHmlCQqSDPlAnacgRutiZX5VZdQBe1SHTr/a+fjzCBbXLz510tmUFtgdG63t9t44/krXFCH557vJQWFUt8tehhzk3O2VtRAyTMI5/adO71r3/22jN3SHCfI8
 gmbj9n9z
 GA9Y95vzgTYrC6w/KLSQYXrJLM8b8TSZ9MjoEXy4woGu/yrvqlmGzWR0Fkh9JxrzqqrXhPPE9HQcNGy/7bfb9YKEDONRSZHejtsRQW+ArcuuBKbBAB5JyC9RfjO3KfqjIIIKAxDLShP3Xe9MDiuVG/E+S8XWN7CKMXyGR6VC3BDXWuk2bk4hB2qxU76xr7emzLSwH0QSINXYeeChdBeKTeA0u0Z6fjyz6RskY0y176+eRmU9zDh47e5Jw98f/O4AC/05RHmlTz5K7xUIA+Byq11VPrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 20:27, David Hildenbrand wrote:
> On 14.10.25 14:17, Lorenzo Stoakes wrote:
>> On Wed, Oct 08, 2025 at 12:37:46PM +0800, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> As pointed out by Dev, the PTE checks for disjoint conditions in the
>>> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
>>> and pte_uffd_wp are mutually exclusive.
>>
>> But you're not using is_swap_pte anywhere :) This comes back to my review
>> quesiotn on the series this is dependent upon.
>>
>>>
>>> This patch refactors the loops in both __collapse_huge_page_isolate() 
>>> and
>>> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
>>> instead of separate if blocks. While at it, the redundant pte_present()
>>> check before is_zero_pfn() is also removed.
>>
>> I mean see review below, I don't see why you're doing this and I am
>> unconvinced by how redundant that check is.

Ah, good catch! Lorenzo, thanks!!!

>>
>> Also this just feels like it should be part of the series where you 
>> change
>> these? I'm not sure why this is separate?
> 
> I think Lance is trying to unify both scanning functions to look alike, 
> such that when he refactors them out in patch #3 it looks more straight 
> forward.
> 
> The missing pte_present() check in hpage_collapse_scan_pmd() is interesting

Yep, indeed ;)

> 
> Likely there is one such check missing there?

I think the risk is exactly how pte_pfn() would handle a swap PTE ...

A swap PTE contains completely different data(swap type and offset).
pte_pfn() doesn't know this, so if we feed a swap entry to it, it will
spit out a junk PFN :)

What if that junk PFN happens to match the zeropage's PFN by sheer
chance? IHMO, it's really unlikely, but it would be really bad if it did.

Clearly, pte_present() prevents this ;)

By the way, I noticed there are other places in khugepaged.c that
call pte_pfn() without being under a pte_present() check.

Perhaps those should all be fixed as well in a separate patch?

