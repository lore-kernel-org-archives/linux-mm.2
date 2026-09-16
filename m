Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E575C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59F06B0093; Wed, 16 Sep 2026 02:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07F66B0095; Wed, 16 Sep 2026 02:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A459C6B00AE; Wed, 16 Sep 2026 02:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8776E6B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:50:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C7771A0621
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:50:35 +0000 (UTC)
X-FDA: 85218702030.16.B8A3E71
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51A83C0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:50:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uRiPWqWU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xL98/jtasdgZkBKzQM8Eu1G+T4R39abYMVJxmdXGZg=;
	b=qcDCe0ZVFbmojOddKa+cHLGV/caIT0mZY0stflFnoP6U0/cSFOeWwhpMngovC2z9vzqOui
	7V55i22DwLEy0ZgD+WXYfztBe8S2jy1zOYaVR4BZD0ldGL8zu8bp0BYSN3yKw3cDmjrwSN
	ZJLDRIicJfeC0cZicJC6iAf/gq/PeCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541433;
	b=kxEGIlH1eHOYeAAiccnfJjKacx/++ryh1/Ks91I7Iwy2a3TP9GpbcU7lf2hy7pls4pya1N
	uD1P83kI7M1MP7HbKXYUUCnOBZb1LTlCpZ6hLL0AXzIbp0CoC9GphnlRizVxvMFJKMyGaT
	eJd87dGiD01DKCfi4xLtE/WnngVGbC8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uRiPWqWU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8xL98/jtasdgZkBKzQM8Eu1G+T4R39abYMVJxmdXGZg=;
	b=uRiPWqWU31G2ipkzIXg0fc8jd7rxVP7AsPF4eItTJ5hzz62cIpI56OZxjtv3kvLInd7F/I7m4
	tZOVpkoj4GQDe4dqClW3oifOGdkDeaSbzCvBTv69I2IAps5UVY6OQ4Autznk0dPiwBaIXLX7DR+
	upkt9sgukjxQ0/YwxpwLs3s=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hl8PH0QQ1znTVd;
	Wed, 16 Sep 2026 14:39:15 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 36C1F4055B;
	Wed, 16 Sep 2026 14:50:20 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 16 Sep 2026 14:50:19 +0800
Message-ID: <1ddf7304-70d9-4e35-935a-9d622b022e4f@huawei.com>
Date: Wed, 16 Sep 2026 14:50:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm: mincore: use per-vma lock during page table
 walk
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>
References: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
 <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51A83C0003
X-Stat-Signature: oi78zqmfqiyffx9ue7p1hmxuy98xt3fc
X-HE-Tag: 1789541432-554457
X-HE-Meta: U2FsdGVkX18IM1HlePsWj7SXg3ec0r5wl8UA/C+gh88gOO7bOBI6SfbSPSdVzvVUHhZrRvi8HbM6YqW5JARBXs2C0Q6yfjxnhWYSzfD+x1owxqBI00mRxX2bvrEPh74fmmpoRjdB2HC4TtbWtCBy7og0Z2Q7knkqnoeB0SxRO2g6T2Um3jf8PR74gzp/+cA8mrIcyuhoLvEJaxtmjklvr/9gRr7kLCD6oCGJKZBGMyPMJ1FS/0z1zrI0g3sEVK0W3LeFLFdKsK+KbEEgpNXV/XIE7Q52owpZzOSpOv+h4lu9j8zupMVFPdyeAfI/rgnROhJ86ix/XLSWujTb/fYEG1UfrvKCJzjUZMBUEv9pS9aG7iQW8OzKGCbtufL90cTtu/Rrmw40dAQctRsG7uDiiPduiQqet2cyU5rQ2xS1wNQR2BnIlfghyKPBZe/ITUioMK2XpPyqnk/xHQbyBQ4GGxbd2e8z/vEuC9q90Bsp2AHfCoIlnuUtyeN3Ll8ik2FNkjuwVuOnoQS3mdPUQcMpMibaOKTZpoGxqe60pzVSTwE5pW9LG1WiVV/pQK47BzwutbqkbDHZv89wElvLUsj9iQKMhpYDUTAeme7cKHmT7E1dUNT1agc8SKiyrCcVWCiMePnuUkxVul2ffi8cUDRz9R/m7h3USVXXr0/rCO86r7CQ2SQPdqFa/KpuDgHaoQmBZGHhB8kdH0F/nngTYn6Q4Anar6+0YiLT72EENNB4Hr36GWvli6xzGiQtu3o7neWD4aGEh6J5C/eMBFroNw5W/ybG74oHo3mtkIBIELBdU0wkG0wjEGqKnfX2E+d7lPYbQ92bLtqSPx90SVTWeO/Kaalm/MEDb2hgxv7NZxe6LoZp4q+OvCl8AJWO4HTJ/PrC4uGA3gPSdE207Yr2YnLrJd0n61nwBe1ItPiI8yZZfdpTAmewDHa+QMSOYeeq/w7qdfyUnZ1p4dKzJmHmGMF
 wc5lCnpK
 quqIxo8cXmPIJ2KljaQv2JVDiLBuwE1iO0Nih6u2YkMrxYq8QnrO5FusW4DLLFlfhJ+5pWA0dmP1G5pr+ESrbI1uo324V0Ok7+FN8YdkZyN7BCcrnmxmpPUr0MaMsj7uFlcSXdu6HZCgMRIiaJ9JMOFvRr9JUsxKao8MGD0kNHaDwtKZn3ITrA9TqkgoXC/24ELD4semTZOTTNtAjcPP9uQf+VQTclddavo7WAQyRgsFvUoi2LcgZHM1bjtbRue95Z1UoJ5nGxViR3SuYiA5MdHldnyDpkJ1GVvAaYkpO58WZ21awP2jKCELKGEPoZVKy4THxv5TU5MbZsJnC/K7CllDMyy6pMMZ8MBUsaUWriTkCFGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/16/2026 2:33 PM, David Hildenbrand (Arm) wrote:
> On 9/16/26 06:31, Kefeng Wang wrote:
>> do_mincore() performs a read-only, per-VMA residency query,
>> making it a good candidate for per-VMA locking. Convert it
>> to acquire the per-VMA lock, thereby reducing contention on
>> the per-MM mmap_lock.
>>
>> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>> v3:
>> - add vma_assert_locked, update changelog/comment, per David
> 
> It likely was Lorenzo :)
> 

Oh, I'm completely blind :)

>> - Add RB
>> v2, (RESEND):
>> - using new vma_start_read_unlocked() API, suggestted by Pedro Falcato
>> v1:
>> - https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/
>>
>>   mm/mincore.c | 29 +++++++++++++++++------------
>>   1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/mincore.c b/mm/mincore.c
>> index c086836bc4bc..0fe50f8a7e62 100644
>> --- a/mm/mincore.c
>> +++ b/mm/mincore.c
>> @@ -235,24 +235,22 @@ static const struct mm_walk_ops mincore_walk_ops = {
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
>> + * all the arguments, we hold the VMA read lock: we should
>>    * just return the amount of info we're asked for.
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
>> -	vma = vma_lookup(current->mm, addr);
>> -	if (!vma)
>> -		return -ENOMEM;
>> -	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
>> +	vma_assert_locked(vma);
> 
> I think Lorenzo asked whether we should do that. But the walk_page_vma() further
> below would already verify that due to PGWALK_VMA_RDLOCK_VERIFY (see
> process_vma_walk_lock) so not sure if that's really required here.

I misunderstood Lorenzo's intention, which has already been verified 
through the PGWALK_VMA_RDLOCK_VERIFY check. I don't think it has much 
value, but adding it doesn't do any harm.

> 
> AFAIKS, everything we do in mincore_pte_range() should be compatible with the
> VMA lock, including the swap and pagecache handling.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


