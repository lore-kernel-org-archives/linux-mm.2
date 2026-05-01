Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F42ACD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 13:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92A66B008C; Fri,  1 May 2026 09:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6AAC6B0092; Fri,  1 May 2026 09:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6DC6B0093; Fri,  1 May 2026 09:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7016B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:27:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65E73120798
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:24:54 +0000 (UTC)
X-FDA: 84718921308.05.A95E6AF
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4E4D720015
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:24:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUs6hox7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777641892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRO/682cR26d8aQNXMdR1KpAtOqpz21uS7mp51ZeARY=;
	b=cu1aGwGTOOitEqfXA7T+ijbM2aF0ypo+UPQmC3u/W2uAdIKvNA/ZasAFraili20SYtBgcn
	uJHKN14t4yneWuw+e9lEblwcwFoyKv07UGSTI7HaCVoCnuUTKr4GsioDJfLcIedMFNoXRx
	c5k338fVVKiqz9ULdniwzmt+CQESyKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777641892; a=rsa-sha256;
	cv=none;
	b=nzjBbpxyuXDnftnHx1S1IMDYovBJpSQREgDEncgNaUaZZFfNx+vgkW2NRiciuMWX8mczs1
	3fbQpqyLrtzemLKZwP1ygGKdtHckS3+9yUNga+P/Ll3njlHwPJhsw/ODplgEvPHSiVmrhU
	T15085/nyUNlN7qRp5WfzmqUepQoxyE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUs6hox7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777641889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRO/682cR26d8aQNXMdR1KpAtOqpz21uS7mp51ZeARY=;
	b=QUs6hox7I6BFiUrgYrk85Xowcz9YDKt1u/CsA0LqcvGJ6VVBQ3/vyL31ZLPYsiot0Xclix
	WFxv8I/g158r5+CvFy3oDS1cLHwRFq5sctbgmu6K16EBtUco2fQ4s8A3VGcsAgMLx4uLcX
	g+UIv2rz2l7mmuT8fr7jkQVc5ghv8lg=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com,
	ye.liu@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liuye@kylinos.cn,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Fri,  1 May 2026 21:24:38 +0800
Message-Id: <20260501132438.21298-1-lance.yang@linux.dev>
In-Reply-To: <aed7c1d5-2189-4ee2-b0f3-ce5a3e3c2118@arm.com>
References: <aed7c1d5-2189-4ee2-b0f3-ce5a3e3c2118@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4E4D720015
X-Stat-Signature: 6uoumyp4wzx9x7w4ipsf15wyucftqf93
X-Rspam-User: 
X-HE-Tag: 1777641891-331932
X-HE-Meta: U2FsdGVkX19QDtrqvRStMRtoGmB0byVPIs0n73bU5AvZuTtMDcxFZwWaBiWAMjoHByaB0bBFvNZXFY4ymmIRrOIOqgVN6VamayGd10vM2LgeaKtsGeeZmwLjCjbh0p9C/Q2GAPn2CKGLs4MdvEJpTxSE8viAzgbo9ULP+GbHTuDp3ch381U2NVLtufVPdbpaMZGLglDWH6swHi3g3GQ7rjYC73FSsQMFVzaPvEUAtpUmDy5uPBNXFEvCFvPLDBFC50sWINE4mlNXWCSDStmwSAUhtcfLgZM+MVenqF/hAczQJ3nmasZ51eTBiVptSle8RG0yhw3i2jErkG7yeRcC5q4K8trzN4nw5PFtKUhhLYRw/8LBX8XiI3OVz9nBCN4kNsL8kP/qvAnlj8zLN8axHz4lEzFkDMqg6PbWAu3XMt1/OR0/Hr3FE4aJu2V9tLJDJZ1IK5C0eYv4kpSXUNNyWwf/ylbt+YQlR701D72NFjhMBtqov/vP7UVORfqh7EjwOP5Fx9F1NbDiEJcq4bRiLC0//H+qNC0xDCYKng1qPnLqVrwMa9pICxWGue1WLC7LVFKZSHb+yEsd5mWI7kN/qMNa+Uz/V8jCXX0tYYpEF5OOtUS4UUQc3I5bK4qn4K4flCP5hXITbDo8EAy1/o/JS08ume6HFn2SsqUDEqoS7crwyQYL+cHkHPp5crkJQMIzQdPGf0LYDIsxy/NW+c7n7Jq99tcU2dogCMEirz608yvZ1eBxf5YPn/1RPD8cKb1hmO7lS52mP0jfu4GWVMuSHvHgzSFzGcaj/42t1qTbwLihAQj76vC1xK7FDK4bJcZwoq6z6E+cmRheWJY3+xxzZH2oPBY6t5o9NV6gHaHPbk4FV1GzA4UH0i/+YGDtBbpp+D+t6Wemz9N0a5LN2ICkAbCEJMqsusmB6RZXvtamNjTcHmJ/IZRSH6Bc9NTpDAJAp6ufr8RAN99RnZDrlUD
 +MRsAB/h
 IZjNas8mHbKZMDR3loXcuWE9aqUOm0xK8GjnISxNpvLcE5pbKVSDx3hu1HWMeETVwlxEOOc7aI3ndeOM7iDLskB7yrqNFRLuUHBlDvBWGsxJ+Eu4dDEcQgxWxyaeyg1OFnJVNoQE3gkzk9t1JgibsZ1D25SUsmD7795FFkpgkN+ywHA4UyJPNcZrS5mMPrSNnzQvhc/H6jTeGJcFVKThga5rrZ4FnvjFLA7imCYhTSTGGAwbBsRZqwEtfhRNFONmvpPio
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, May 01, 2026 at 04:10:58PM +0530, Dev Jain wrote:
>
>
>On 01/05/26 1:27 pm, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>> 
>> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>> corresponding mm_slot.  If mm_slot_alloc() fails, the function
>> returns with the flag set but without inserting the mm into the
>> khugepaged tracking structures.
>> 
>> This leaves the mm in an inconsistent state: it is marked as
>> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>> khugepaged.  Future attempts to register the mm are skipped since
>> khugepaged_enter_vma() checks the flag and returns early.
>> 
>> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>> restoring the ability to retry registration later.
>> 
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/khugepaged.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 7d48d4fbd5f3..60ab7c1b61dd 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>>  		return;
>>  
>>  	slot = mm_slot_alloc(mm_slot_cache);
>> -	if (!slot)
>> +	if (!slot) {
>> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>>  		return;
>> +	}
>
>You could just move the test_and_set() after this no?

Yep, that sounds better :)

Just one small thing: if we move the test_and_set(), after
mm_slot_alloc(), we need to free the slot when test_and_set() says that
the flag was already set. Otherwise the racing caller that loses would
leak the slot :)

Something like:

slot = mm_slot_alloc(mm_slot_cache);
if (!slot)
	return;

if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
	mm_slot_free(mm_slot_cache, slot);
	return;
}

>So if slot allocation fails then MMF_VM_HUGEPAGE is never set.
>
>Fixes tag is probably required but not sure about Ccing stable.

Yes, Fixes sounds good. khugepaged collapse is best-effort though,
anyway :)

So I'm also not sure about Ccing stable.

>>  
>>  	spin_lock(&khugepaged_mm_lock);
>>  	mm_slot_insert(mm_slots_hash, mm, slot);

Cheers, Lance

