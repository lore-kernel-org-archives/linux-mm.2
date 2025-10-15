Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288B9CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680D08E0008; Wed, 15 Oct 2025 05:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659038E0002; Wed, 15 Oct 2025 05:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5960D8E0008; Wed, 15 Oct 2025 05:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4448F8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:31:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA0B91A0B70
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:31:31 +0000 (UTC)
X-FDA: 83999830782.13.6E32825
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id DDFB4120008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:31:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTr6NNWa;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760520690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDWnb6HM59m53HWWkDZ7wJOQ8divhA+pm6fAx1aM0zU=;
	b=rj67fj4/pDa8dUgi/levuiJuenDwWGiyT57KxgNTj2XJgO35ufvddisbCJuMC8YKO+KVc5
	BJnkZQDDjvq3lOWqrbEGdrUs6Nnv1wkHmrGb0ZterZLvv1QZwDMguoPeHTfcNfTUzKyVRu
	0keocyb4bJW0tA06BaSbTEN5OmdklAQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTr6NNWa;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760520690; a=rsa-sha256;
	cv=none;
	b=oPljZWI+Ib+8fpfD+GdUfxvZAPf+zPCXtY7e+t+II1N6Wt9IRRxkxzaBFM/eBNXJ55b2nw
	vc4iVzSep6iAytvbKyGwbQaGXOnkwySiHnltctZen5YO/5E6qqXKTCWWd+0UcrsfmD9SQI
	ohrRCc5MSyXZkn1hprAi8EYmumSedQs=
Message-ID: <8dd76501-9e19-4471-86e2-6c4254fd8d42@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760520687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDWnb6HM59m53HWWkDZ7wJOQ8divhA+pm6fAx1aM0zU=;
	b=JTr6NNWa2wIWtUi5kh6m5VAdhCS9RvVGDXyapvf1sQp+ucujZtSQPW5m9p6vRvoFuHGulp
	93WF7vRxhitiV+c5szfeRiVd/W11D3M9UhKVdaTC8pG9DxIhJKJmLm38UDy17jFHfufNNn
	JVlqIV7/wuygPyJnbY5dSLdV0brBj4A=
Date: Wed, 15 Oct 2025 17:31:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-2-lance.yang@linux.dev>
 <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
 <cfbd4f48-69a0-4ba9-bce8-f578d9602125@redhat.com>
 <80771030-0d8d-4f65-803a-f89da3b59796@linux.dev>
 <cc998aee-2a98-45ae-875a-9712d4c29240@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <cc998aee-2a98-45ae-875a-9712d4c29240@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: peyg8thu99d4kej1hascaimquwp5stz6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDFB4120008
X-HE-Tag: 1760520689-858466
X-HE-Meta: U2FsdGVkX19hqHKwq2T7sW9gwBZlE9bBq//n2T1OkYS4S6H2n1wtsRtg30wqea/fP4jK8EtPie5a9emI/BvCX9Hi3FfRz1Gr9JEfqe0hpSHTnZCIjicYRf0CkOczZ8BKCBxZ5LGhkeWs3tfid10A6v8NReZ/ZbvKa5AIg+H7YG6tHdmvYuCod5Wz4PbWmlRNIdN08TUE33F1ppvUf03UrGmYLOxqd0JzjQmOv5dks+IBxf1uecNBfY+n5EHGp482kSi7b1XLJZLQy4NepxRdZFNb28zCy8iOjZFej/opgGrAkMuTsloaha+G6j+f1mt26uiZs+fF9TrN64yxm3jRZvSymPDlVjH1djqVQ+9GpAh2Q/QLePbm2v7C9d0niqHu7rhBNrTHck9M2rZVWOSkg/wNeJI0fl8AEIvlwsz+ZW1eb0Xkh5Ul+lVYV2lWJoyMAgBt1JGItwL2tb89YU7XID5ioLVYsi9diJOwmLqSJBJiNbVLiDgAQi/zDvCqE1k5itHLYKXHycsw/4oTUDtPhrRUCx6yOg8bMG6rvc8uTXD7SwAv1h+lF2BD1EMC9qg6MKy8w+Uf7NB+WPGfRQO4lls9YwzPZDBScPC2lGJAo5R/Iuxc+59pXC51IN0cKyQ1qLHaLobbuqhhVRXscV8Byb10JN+xdSGiiD4DGrecFz3mBldTVz1+yYF61kYuhLAbIF2fd1h1uNj00PpQfZGXfgfgjMWMDtt4RcKafmt4g8m2pXgRQA2pVBtYKwIzk/Algje/qZe9jhlLyXCFLxlQYPyVFoiOsd3w53P2+QN8+zzp1bqGbJWcBUo6k/ZxCJquK6eMCPE8Watt0zfcWVn1N6hXqUpyInR9MD0X3qogB80xktO6tG4DpuFmdiLKoU3611jL8f1btYHmSEGHfZpXEieY75T2ngGGRveY/E4/pLiE0lmQVtdepOIdecWAnmwg5Kj/KAFCj6APH/kXgWN
 u+GUZoqF
 uklLX/tSNoO3Sn+dau0SsMnPfYpZN8y8JDwUeHNKE4mjGHOLxARiGReMu3FMtSLP25wmKzhf1+2svYQyT4l7fju9GvCguijn2nwwyDaFm3ESCmeO1mGG9FYO6gTSDmiZ0wFr8k3KbGbmUnKHSMllQCUFW7LRoQHwhFsroTrx+LtvU6iEgUlkMkdlPQSTW1KLKuZ1j18S3jWQNVvtsPgKppRn9mSxkU37po/hojZ1C3tTNtE6QQlw/VoXghj018mLJJ+POVeL6QlWoNgyC87jJSjZ7/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 17:16, Lorenzo Stoakes wrote:
> On Wed, Oct 15, 2025 at 12:49:26PM +0800, Lance Yang wrote:
>>
>>
>> On 2025/10/14 20:27, David Hildenbrand wrote:
>>> On 14.10.25 14:17, Lorenzo Stoakes wrote:
>>>> On Wed, Oct 08, 2025 at 12:37:46PM +0800, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> As pointed out by Dev, the PTE checks for disjoint conditions in the
>>>>> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
>>>>> and pte_uffd_wp are mutually exclusive.
>>>>
>>>> But you're not using is_swap_pte anywhere :) This comes back to my review
>>>> quesiotn on the series this is dependent upon.
>>>>
>>>>>
>>>>> This patch refactors the loops in both
>>>>> __collapse_huge_page_isolate() and
>>>>> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
>>>>> instead of separate if blocks. While at it, the redundant pte_present()
>>>>> check before is_zero_pfn() is also removed.
>>>>
>>>> I mean see review below, I don't see why you're doing this and I am
>>>> unconvinced by how redundant that check is.
>>
>> Ah, good catch! Lorenzo, thanks!!!
>>
>>>>
>>>> Also this just feels like it should be part of the series where you
>>>> change
>>>> these? I'm not sure why this is separate?
>>>
>>> I think Lance is trying to unify both scanning functions to look alike,
>>> such that when he refactors them out in patch #3 it looks more straight
>>> forward.
>>>
>>> The missing pte_present() check in hpage_collapse_scan_pmd() is interesting
>>
>> Yep, indeed ;)
>>
>>>
>>> Likely there is one such check missing there?
>>
>> I think the risk is exactly how pte_pfn() would handle a swap PTE ...
>>
>> A swap PTE contains completely different data(swap type and offset).
>> pte_pfn() doesn't know this, so if we feed a swap entry to it, it will
>> spit out a junk PFN :)
>>
>> What if that junk PFN happens to match the zeropage's PFN by sheer
>> chance? IHMO, it's really unlikely, but it would be really bad if it did.
>>
>> Clearly, pte_present() prevents this ;)
> 
> Yeah, not so clearly kinda the whole point I'm making here. I mean all this code
> sucks because we have deeply nested conditions and you have to keep in your mind
> that 'oh we already checked for X so we can do Y'.

I see :)

> 
> But the THP code is horrible in general.

Yep, you'll get no argument from me on that one ;p

The code is indeed tricky ...

> 
> Anyway let's stay focused (so I can stand a chance of catching up with my
> post-vacation backlog :), I will check the respin once you send!

Cheers!

This series has been dropped from mm-new. I'm going to take a bit to
rethink the approach based on the feedback.

> 
>>
>> By the way, I noticed there are other places in khugepaged.c that
>> call pte_pfn() without being under a pte_present() check.
>>
>> Perhaps those should all be fixed as well in a separate patch?
> 
> Yeah I'm not surprised and sure indeed.
> 
> Thanks, Lorenzo

In the meantime, I'll send up a separate patch for the missing
pte_present() checks first ;)

Thanks,
Lance

