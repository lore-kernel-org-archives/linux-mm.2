Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D99DCD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519056B0005; Sat, 13 Jun 2026 15:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9186B008A; Sat, 13 Jun 2026 15:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B93F6B008C; Sat, 13 Jun 2026 15:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25E2F6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:18:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B52718EA7F
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:18:53 +0000 (UTC)
X-FDA: 84875851746.22.EB1469B
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4CF654000D
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:18:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDJpXDBR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781378332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JBe7FbuBZ2+oyRF5a0/aYVn2kgb02KwUrH6h6JKcJ4=;
	b=6NkuK+EzZV+AyUy3T0pbW7phOhO8H8PMmv3L300caSWPqz9OuaPUtZ/OnIJ68f3ZfKPLCi
	5KNlY96Bhrly/FH3dw13b0epz5OnigocyfHzJnDPQUDdWFh7gSwGVBESLlP6Nci/U708OB
	v4pXeEbiE+aJHT+ejlJcnIeF9svD7UA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDJpXDBR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781378332;
	b=Wuk7dRDI/zpTmGZJsQ1jJ9C/r5ExBD8lPKuObMgYBpkce0k0LZmVGW7K0xbeMHv/zmbpUQ
	16a9gMj1tMZULFc7o/fUZGdUGJOHle5I1vjbNZ2Sir31lpUNHThzON9hbdslA3PdQrxmBq
	ErN13oCw0t2ahxBmHK+UYBC4ECESiAg=
Message-ID: <526fdbc0-1944-4328-9ff6-7922d021828d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781378327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JBe7FbuBZ2+oyRF5a0/aYVn2kgb02KwUrH6h6JKcJ4=;
	b=DDJpXDBRiuEzHKe0UUy6T2OiI/Fy/7qXp98iHPc4eIW8sGDNq37aH4re897W5GZBbY94NF
	kWq8PgZtBkiO5619nZZaTqkvc6mLwDRy2181pMQjnmC1MatCcFcZ83/20UJxs3Om5+ygt4
	nFbq5mMW0g6VtfRr5Na9EmsIGSe5vWk=
Date: Sat, 13 Jun 2026 20:18:34 +0100
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Lance Yang <lance.yang@linux.dev>
Cc: david@kernel.org, ying.huang@linux.alibaba.com, baoquan.he@linux.dev,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, ljs@kernel.org, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, liam@infradead.org, ryan.roberts@arm.com,
 chrisl@kernel.org, vbabka@kernel.org, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com,
 kasong@tencent.com, ziy@nvidia.com
References: <680441bf-c878-4a00-8787-63ad8b201bc9@linux.dev>
 <20260613042232.93691-1-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260613042232.93691-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4CF654000D
X-Stat-Signature: rcyeimdp3k41ox9y6hafiidkrdfg3wjm
X-HE-Tag: 1781378331-97841
X-HE-Meta: U2FsdGVkX19W3kx2jayomQ+4dxDDGtLIpJ6rN1EtUUq9926QgtawY+SDuS6juGSDdZo77+6538LC7QqG5NRKYAz1MB6tPEuzK5Xd3VBKMb5GEJdq2Zer0diL19X7Cvzr7NcAJTdBCH+qY5FgUdNQf7qfxK+3OOrBwHGZfpjHJjCeX7NepmR54VvqGnMcfjuMwDmsnbsKAbl3vcGHhJcvz7XmeYAPyut7retkSu2nPie9zCaqi5FSfyLfhKrQVVkudbHkvFft3+l2RwFmmLlxn1SC3fk6c5CUAYPM14IWekI9M1rokwmc5hL8xb5hq1Y4zyMHKNmcU239AKdIMx7WWtQHF+dEldFryisXffmnkKA+rSexQBATnt777FSX+tNmeiFr6KaOPkdaNpYwz9co23v9OD/l3uXoSftBBqZB/6/3k/khhRpnrYkxYIReHz19PP8Z2LEMveCyJUt9nEc109HtlUEspPvTsvPlYmvC78tcJteWstJX58i/+ivR1iSOS9TXyYCdxnBiOOZlIHvJqZzCgLQLtfDNZm5PoXyzDTVa9y3RY/AIQio6O1Gl7XClFKhWvYavDMd1TTyszt8trA3dMebiNGkif1B1lf075Hl9eKoC1Ub4Cml+hVeKMBhVJbUBRPiTRla7WtwOMQT1C9lQwJBVYttIjxdyGPjplEV7eVAdx78FoH2qGNWgl/b+KhrxwnBUqIC/hA8P8rtsfk2CGgA0ltgr9+ckHgLfPR2yPjN9XrAJXG7kOt7/HkmNGmp6vq9rdUfJznvaZ8vLqS0y3VmI2NPpiD/KuX0zTecHs4yP1VaZ2wRHHhFearg2e2fHCl+fcAdCb0dlY0rJNXKPM6LPFurJh65ODx+wJ/cYS13ZbV60Egc/kia+H3Mt+sbpz2xImQgoAOsO9E+i/NnW3sXUYEui3V2c0y96cBN8R7hY4+z7Ah8b3BRH6SgyLpigHvQIGVMa1y0kURO
 9u6cPERh
 1BUtfliIFiFL1SosmvjAABh+gEqYkzQ1IQwKcxSE//R6whH1U6usZ9Yskvcc+gG0mm4ErUsOKY01slKDoXt+9CPa+c+YWO/9tiiYPQjtzDDIyMXnMG1upr7f1e5uHXgoCtxSy9LRFsRug2U9nCHpcGtuP8/E+K9dhPjfyapAS4Ce2uz4KlI+rbEv5rPkltVKDQzOhAqxoFS38TF2pHlwZyuL1M7t9MRVJsJKG/Q1FCc2OZ/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/2026 05:22, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 03:44:32PM +0100, Usama Arif wrote:
>>
>>
>> On 10/06/2026 14:48, David Hildenbrand (Arm) wrote:
>>> On 6/10/26 15:01, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/6/10 20:24, David Hildenbrand (Arm) wrote:
>>>>> On 6/9/26 16:29, Usama Arif wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hello!
>>>>>>
>>>>>> Just following up if there were any reviews/comments on this series!
>>>>>>
>>>>>> I know its a large series but was just checking if there was any
>>>>>> feedback?
>>>>>
>>>>> It shall be reviewed. We just finished the mTHP khugepaged review to get it into
>>>>> 7.2, so we've all been rather busy.
>>>>
>>>> Right, mTHP khugepaged was a rough one. Glad we got it over the line,
>>>> but yeah, there's just been a lot of THP work lately. pretty nonstop ...
>>>>
>>
>> Yeah its definitely a lot. I have set a target of leaving review comments on
>> atleast 2 patches from mm per day myself, but even that can sometimes be
>> difficult! I will try and help out more in reviews.
> 
> Awesome!
> 
>>>>> (I mean, just take a look at the THP-related flood of patches we are fighting
>>>>> with on a daily basis, it's not funny anymore)
>>>>>
>>>>> This is clearly going to be 7.3 material, so there is plenty of time given that
>>>>> the merge window is about to open soon.
>>>>
>>>> Usama, I'll try to make this one a priority too. Looks interesting :P
>>
>> Thanks Lance!
>>
>>>
>>> I have two other bigger series to review, but I should soon get to this as well.
>>>
>>
>> No worries at all! Thanks for the reviews! and yeah definitely 7.3.
>>
>> I will send this out again when 7.3-rc1 opens (rebased), so that the reviews wont be on
>> outdated code which could cause some confusion.
> 
> After skimming through the whole series, probably PMD swap entries need
> one bigger rethink ...
> 
> Emm ... same tricky bit keeps showing up ...
> 
> One PMD swap entry is easy to handle while the swapcache still has one
> PMD-sized folio behind it. Once taht folio got split and reclaimed, the
> 512 swap slots need per-page handling :)
> 
> Maybe worth first pinning down the rule here.
> 
> Is a PMD swap entry supposed to mean "there is, or soon will be, one PMD-
> sized folio behnid it", or is just a compact page-table encoding for
> 512 swap slot?
> 
> Without that rule being very clear, every caller has to guess how much
> it can assume, and it is easy to miss one ...
> 
> So I stopped staring at the details for now, because the same issue keeps
> popping up wearing a slightly different hat :)
> 
> Anyway, no clever answer from me here, not a swap expect :( Just pointing
> out the pattern I keep runing into.
> 

Thanks for the amazing reviews!

For the next revision I’m going to treat a PMD swap entry as just a compact
page-table encoding for 512 ordinary swap slots. It does not mean that the
swapcache still has, or will soon have, one PMD-sized folio behind it.

With that rule, whole-PMD handling is only valid when either:

1. the swapcache still has one PMD-sized folio for the range, or
2. the whole PMD swap range has no cached folios, so the caller can try a
   PMD-sized swapin and still fall back if that is not possible.

If any slot in the range has per-page cache state, the PMD entry has to be
split and the existing PTE paths need to handle the individual slots.

I an reworking the next revision around that. I added a shared helper to
classify the swapcache behind a PMD swap entry as empty, PMD-sized, or
split, then used it in the places where this assumption mattered:
mincore, UFFDIO_MOVE, swapoff, MADV_WILLNEED, and the PMD swap fault path.
UFFDIO_MOVE now checks the whole 512-slot range before moving a PMD swap
entry without a cached folio, and falls back to PTE handling if per-page
cached folios exist.

Thanks!
Usama

