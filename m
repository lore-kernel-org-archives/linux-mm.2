Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E957CCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 10:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60DE66B0005; Wed,  6 May 2026 06:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4D36B0088; Wed,  6 May 2026 06:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522116B008A; Wed,  6 May 2026 06:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 402196B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:52:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE88412016B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:52:15 +0000 (UTC)
X-FDA: 84736680630.03.621B6D3
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C50514000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:52:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kRr/BDzP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778064734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMpt19AKtKXEf6HWZe6U2H7Rk78vElmD03to1iCaQW0=;
	b=JNO9zw4TGlay3PqEuNTahuGqFeEJbIcGO4wylb4fiCIPnow0eX+Ac0zUwbRdbh8ry5sHLj
	nNtKvjao6941aroncKCtwDBVmSPm5heNL2AJdbgQaaII7Yu0dOSY4HEe+SgWGifi83xMzD
	Fydtliv3k9LSWc22IGuo5te62zWpAE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778064734; a=rsa-sha256;
	cv=none;
	b=LD3cQpJVxOYxZhPla2TpQBSuR8yeJLNb/RIu3uVqsuDFX9UHIN/tBYM77T/aYRcohoThrh
	OMcx2COD2r++f4a7jiFQFmJs+oxUmVsjlTs9j1FPfvAGhy2Ntb+5UPYqd1Kp3JQP3MKK1Y
	SblloYERNffIGFk1TKUKCTwOWQqF8pg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="kRr/BDzP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778064731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zMpt19AKtKXEf6HWZe6U2H7Rk78vElmD03to1iCaQW0=;
	b=kRr/BDzPfvHOut3Z5oRlb3TEmEcS+FurdMrniRy8OxU1SGMGBeUkPGaSEra56z5HxgJUX6
	F7FR0vRd0mJzuTkApRYf4c2M+51HpXfFqFUomT/CpNHdi1qWExhIVEr+/Mo2QIp+KZLFS/
	FFU/nS6HN5MXx4+fLxmrleTdauY2C7k=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: ye.liu@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	xhao@linux.alibaba.com,
	liuye@kylinos.cn,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foudation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Wed,  6 May 2026 18:51:50 +0800
Message-Id: <20260506105150.21504-1-lance.yang@linux.dev>
In-Reply-To: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
References: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C50514000F
X-Stat-Signature: ptm6p6ksdoy6qqstbg9y764rjsu51i4i
X-Rspam-User: 
X-HE-Tag: 1778064733-438122
X-HE-Meta: U2FsdGVkX18UaFPLu6Qn8jcejU8AaurHKITaUjDSuA8vRXcNAraxpiSeRPOA+0dA+enKgIH9KO2fyyoohYLbZUNRTEjyEK05uB9ZQtzDah5gmbBB6wTlLvC1e0bYq7atMCZMRt9YRAxGpwuLJwUi2mwUiVBcVcsa4lhZ5jVUGHP06gZ4OaS29d1GiazFpboN0yKxjyatQtXmiQOv4CBkefx9Oqa3VN92QwQygI4ysCNmUivbrrMlmN4ZGx//k6KW7xLCYkNhi9KyQiYBtij3rQ/gxLD8NwKK3jHcIwonE7E0rH1JyczfDIbCLW2eJAGQPHua9/TAox2k3Ch+DCcqI8LmRI8mGeVHjXICKf56zlQtuNOmmbqEStSPd4uGr8Jt6wGEOoP6yIzT5GH6A47UYyEFZoB6PElhu1ed7q7gjn0qwBj4ucYrUPxr57AHCOrS+e0f8odZJwzf5HwmEYvcB9T/k2Am3cV9OEvSDDI6Fs7pDGck6jIUYMBC28ONG2DLBoYFZ9ohGXtzBVjfoaNChimOFx9y/eNpfW5t9tqCYpkzBVoS0+ERjGDZF5bUyNHhIwiIuq9ziymsKTy0eeXPqeaq53Att5HWfey/fEBHt33p4PWZlKd7Fc2mFFL3snjBAdMGZ5CVL5OYTHTNPbfG5ZOJ4kpyzdHEtNJMC7mJ/8aF+GIlJJ/vQvrrFlKbujr4YxDU+DYA8QBvvUY0jdKPzcDjs0ogLc1Tjczt2F0yV3ApcbMZh8ECJKhIjNQ0kzwibOZFvGBDbFuGOsInH6uuITIYUubL3lnS6k8/rzhrlY/pxZWOR6a000QLQiJqK4k5Rk4+PSbYk4qGJY6EAbNgQQtt7fybLrvfo2tMjKSiCXwD4kPxDsiDNRNiQvh9x3tjJDLE8zJCu83ZVmn/Z7QwFsh/GW3MCVoWF2bPkX5P/kHpcQ8vBzRTOS6KVd/bQFvtwEDQGrI4GokG/7gPorb
 J6PXop7y
 xK5F6I1NLLtDQhxT0Rgn8m9n+URKznrPAt0VaHIIWrvpunEn9hE7XRkDucPzceyjomY5w+mPiSIqPxp6XulCMUUkVJe4kBnRoUX82az6feP1RYfGBjzSBfn15smktCYKU4il5Ia5Wat8pIkDu59gIoaiOBo6oM4/hnFUynxKx+Y+wtvPzrx9knZWP2Rbq1yVAbgRrJexbMD8T3p0lmaIaVNZ22gx64HSC0UMt0yW0KeB9qsQfB1flYiB5UPQjvx+RLFkj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 06, 2026 at 12:16:35PM +0530, Dev Jain wrote:
>
>
>On 06/05/26 6:51 am, Ye Liu wrote:
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
>> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>> Changes since v1:
>> - Add Fixes tag as suggested by Dev Jain and Lance Yang
>> 
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
>Note that, a racing khugepaged_enter_vma() may back off
>when it sees that MMF_VM_HUGEPAGE is set, but then the above
>clears the flag after slot alloc failure. So we end up not
>registering the mm with khugepaged. But I am sure no one
>cares, we are in much big trouble if slot alloc is failing.

Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
and return, then !slot clears it again. If there is no later
khugepaged_enter_vma(), the mm still wouldn't get registered :)

>Although one could argue the same about this patch, I will
>still say it is important to fix "flag is set but not registered
>with khugepaged" because that just feels wrong.

+1 that is still better then keeping MMF_VM_HUGEPAGE set forever: any
later attempt can retry and install the mm_slot :)

Cheers, Lance

