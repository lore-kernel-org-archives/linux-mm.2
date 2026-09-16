Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84243C88E7F
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF146B008C; Tue, 15 Sep 2026 20:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F256B0092; Tue, 15 Sep 2026 20:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357B16B0093; Tue, 15 Sep 2026 20:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18C1A6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:44:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A68F71205A7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:44:13 +0000 (UTC)
X-FDA: 85217778786.28.E965912
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id C0D9D1C0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:44:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=srVmd1uk;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789519451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsKHsBOIdCXLAdxuEi12ZuRKcmDXnF4mxA3rIBYLSzE=;
	b=cDQdNpKalykCrTERZlVbaHmDIkXtbfRyPuxvsuD+7BAqeDw2toGpWmZgoRB7lwX9wz/ZdD
	/MFJYEQafMfHZHd79csSJO/yWdrZhPE8s7b02AKsDPM+b9lW8dU03bvB3pa/+OYxutLYD6
	iNNCjId8rocgpChpVy1J5eb4I7282s4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=srVmd1uk;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789519451;
	b=CllZmKPpR6TIpidDvrot8iQ6/152po6VGsYrbVhMCAPG7JoJCqTNvfJXStB7024Nuil7gY
	xQVJXu5CCOtC7f97yKC3dCTsdU+U3FW2jXlcM+xC8GFUho0jusaolPDqnMfBPFmN/Jvmiq
	6XeSrFRdZMdeAZdB5AGzvpE2qwGO1Yw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NsKHsBOIdCXLAdxuEi12ZuRKcmDXnF4mxA3rIBYLSzE=;
	b=srVmd1ukUwLvj3sCL9GG0BGYSdvJbDOW97ezUsa8Q1+3pihrcMbXv8Fq9sUe0SFLljBUlA014
	L1VjwlxWvPaCqr35t2rnHtaPsua16TMDc2+EF1xWjZVrcaBcpRK6X8/2P+rwuopKsYZhxLAzaFQ
	E1G37YnlEgguw2PI+0+/a/4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hl0Gh3L7KzLlX2;
	Wed, 16 Sep 2026 08:33:00 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id DEE4B40563;
	Wed, 16 Sep 2026 08:43:58 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 08:43:58 +0800
Message-ID: <85aed7f5-2524-412d-859e-989ce4f9a830@huawei.com>
Date: Wed, 16 Sep 2026 08:43:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new RESEND] mm: mincore: use per-vma lock during page
 table walk
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
	<jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>
References: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
 <aqllzrP5DpYHfOZx@gremlin>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqllzrP5DpYHfOZx@gremlin>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0D9D1C0004
X-Stat-Signature: gqoy377n1whe3hgxsrsr6m4s8najxmwr
X-Rspam-User: 
X-HE-Tag: 1789519450-861387
X-HE-Meta: U2FsdGVkX1+UG7jDn49voNT+36fFUJDNpyz4gQtqb5ZEabFx+oEcfl1fkp1FPvXw8DzilpleyhgWOOgLDZ3HoomIdtf1VrTV1ThX2ZSwNcAqZOGScpyIuHoUQ38MqlwZJDq7fFSKop/8MU+mzRBCxuZ4cyDbo6ya2Bzy8v3SxkSooLWzIxqS1x7GBnzS5s3I8ZMlgLcm3pRa2KwiW52GMtTZ2akn8GD8eDJGjHF+n2YD0c5Ny/dWjH85Tt1mnQCTPj+py1uYrZqO5JFAadCiXBtbwjB+u4ugesBL+3UK1pTqy1yXZ0v9Mwp78H6gHy3agYYAmdJt350kdM2U0fg/5sJi1iAIpMbXJPuioCEHtaKJaHkIC2b12+wdApHP1EZC2sAoEH0FeWfhq+IoDjsnjN63/smMbs5VQ0PfGpn4mMa1xoCn8baegvYHFSYYnNo4TEllYeY7s+6Z5ygF8H51jucB2FkJmZz+Foml2Z4QlCB169eTizmJUar5uWY9g0aYQy7oKrCqILg/zkWbKtkx35WfMySAkVfs+cz1CGVhF8/FM1iQz1GVnvK78W1OQTozN9V9mXzCNlMV0IkXvgfh7p1FmxdRYi4Og/+eXv2qh0m1opHg9IheCwvlx3uajCWQ+km6AScNDgOT3hXR2x97aXDn1km6W836Aqd0DlxapsfyREns3I/cC3qA1o2Q2bwv7A4v2C8fFyM46vSm0FyKXKTYeUH+Mqz9Dm+M114mkGrO33bRR/NNMct/+E1EUwNm4JWpiBOkEjHS8QGe8XLB0JLMlNuake550dIMnMdU4DKfZiB4zqew1v/sANyJs7g95N4X4ikraUl8USs95ZUi0h9KtQQr7CCqhpgy6NGcCSbJhwqMNt22mj3wxXzzdO7Zd5x/AtnqDJFmJeLNGQbTsD7kyzVFlCn/lkiHqCOBKHfwI9JAQaKaxgzKea0J7N2vPR7WQJxQAMPQK8Yqdxf
 8C10hOD7
 Mh4BnDd/TyuKMICcdA5nA88DyXBeDmU9UV+86zC0IXboG4/YFJ6meF2SuYVWGgWksfwJThDRp2QXXklx1/gjW5+Pd930YOWe6lu19ciK4R5t+1xTbhAnM5SG3CTAVp5CmxM4M1KSfjfS7eLLfrClxMuQOG57wZ6cHbsrTOByS/AKGhupdSRIWF1ZNxnjJKclQT1bPT4O3XRkvwD9mfTf7msHORF6yFqZkWQ7XRJD8pMln7vwQeaCvcywzGXfk0fb1qlhroOTrwHqkkEY7+qy/iQvdOG30nNWplgQpbBcMSii8GNQqZqXWEJfyHJK/yzljWUj0Ibe77TWYHOSTL8GA2VVOejhBuGOQjtFfQGJzDlmWz40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/2026 11:39 PM, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 15, 2026 at 10:31:38PM +0800, Kefeng Wang wrote:
>> do_mincore() performs a read-only, per-VMA residency query,
>> making it a good candidate for per-VMA locking. Convert it
>> to acquire the per-VMA lock, thereby reducing contention on
>> the global mmap_lock.
> 
> NIT: The mmap_lock is not global, it's per-mm.
> 
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>
>> RESEND:
>> - using new vma_start_read_unlocked() API, suggestted by Pedro Falcato
> 
> That's not how resends work :)
> 
> If there's a change, then it's a v2. A 'resend' is identical to its original (or
> at most - rebased).
> 
> This should be labelled a v2.

Get it, thanks for the clarification.

> 
>>
>> v1: https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/
> 
>>
>>   mm/mincore.c | 28 +++++++++++++++-------------
>>   1 file changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index c086836bc4bc..f989e6d1ec18 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -235,24 +235,19 @@ static const struct mm_walk_ops mincore_walk_ops = {
>>   	.pmd_entry		= mincore_pte_range,
>>   	.pte_hole		= mincore_unmapped_range,
>>   	.hugetlb_entry		= mincore_hugetlb,
>> -	.walk_lock		= PGWALK_RDLOCK,
>> +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
>>   };
>>
>>   /*
>>    * Do a chunk of "sys_mincore()". We've already checked
>> - * all the arguments, we hold the mmap semaphore: we should
>> - * just return the amount of info we're asked for.
>> + * all the arguments, just return the amount of info we're asked for.
> 
> The VMA read lock needs to be held here so you should say so in the comment.

ACK.

> 
>>    */
>> -static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
>> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
>> +		unsigned long pages, unsigned char *vec)
>>   {
>> -	struct vm_area_struct *vma;
>> -	unsigned long end;
>> +	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>>   	int err;
>>
> 
> Maybe worth a:
> 
> 	vma_assert_locked(vma);

ACK.

> 
> ?
> 
>> -	vma = vma_lookup(current->mm, addr);
>> -	if (!vma)
>> -		return -ENOMEM;
>> -	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>>   	if (!can_do_mincore(vma)) {
>>   		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
>>   		memset(vec, 1, pages);
>> @@ -319,13 +314,20 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
>>
>>   	retval = 0;
>>   	while (pages) {
>> +		struct vm_area_struct *vma;
>> +
>> +		vma = vma_start_read_unlocked(current->mm, start);
>> +		if (!vma) {
>> +			retval = -ENOMEM;
>> +			break;
>> +		}
>> +
>>   		/*
>>   		 * Do at most PAGE_SIZE entries per iteration, due to
>>   		 * the temporary buffer size.
>>   		 */
>> -		mmap_read_lock(current->mm);
>> -		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
>> -		mmap_read_unlock(current->mm);
>> +		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp);
>> +		vma_end_read(vma);
> 
> The logic looks generally right, just need to address the various bits +
> pieces I raised :)
> 

Thanks for your review, will resend a v3.

>>
>>   		if (retval <= 0)
>>   			break;
>> --
>> 2.55.0
>>
> 
> --
> Cheers, Lorenzo


