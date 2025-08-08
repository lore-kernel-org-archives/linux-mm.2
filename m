Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE79C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 00:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA428E0002; Thu,  7 Aug 2025 20:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1D98E0001; Thu,  7 Aug 2025 20:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE198E0002; Thu,  7 Aug 2025 20:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6D08E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:56:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AC951A0FD5
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 00:56:33 +0000 (UTC)
X-FDA: 83751774666.08.07D1150
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB22C20005
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 00:56:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754614591; a=rsa-sha256;
	cv=none;
	b=KPGmscF2nnPB41gdociVitnk0nPvaReh7Icz5pXT6wvnBXJ288LP6C3BP/zu9xfqhpEno+
	k0jJqqtW+rXoIyTC460PkQzwTsbNMId9JQY2BPRvmIIExgbsUgQC4XJ0oh6yKDGhjemukM
	DhHVwwN1msS+bOL6BgSbwwYMzBOMdCc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754614591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kCZBFlur45rh/0+1jLyvk4IAtL0bXX3eE8Ydug7QVQE=;
	b=MinbDZuqVi9QRVF9cpi7SAg2bg5GDaGAv0xv39rJYUGTq4z68vkwXPwgeN0A1/nX05zrL5
	LR89oHw5rneIEYDg6LV8FfBWf2gN7DxKAnDTbj86OH/uSXxEGhcu8vo+gZ3z1M0GIyn8Tx
	5j4Y4qDEaeCQ1qrhfNy/qCZ5ru/X05A=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bylqD4gz4zLpqS;
	Fri,  8 Aug 2025 08:52:08 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 18378180080;
	Fri,  8 Aug 2025 08:56:26 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 8 Aug
 2025 08:56:25 +0800
Message-ID: <eacf887c-7259-4827-8bdb-8a938f01dc0c@huawei.com>
Date: Fri, 8 Aug 2025 08:56:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: Fix possible deadlock in console_trylock_spinning
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
	<linux-mm@kvack.org>, Waiman Long <llong@redhat.com>, Breno Leitao
	<leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu Jialin
	<lujialin4@huawei.com>
References: <20250807091444.1999938-1-gubowen5@huawei.com>
 <aJTCGrkg69Ytg-CC@arm.com>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <aJTCGrkg69Ytg-CC@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Queue-Id: AB22C20005
X-Stat-Signature: xgxh6zkkfftacdrccqfo173jb3sjph4a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754614590-571847
X-HE-Meta: U2FsdGVkX1+QQoUfQU8pfu/Rwyh/wMLLCHT3+hMC/4IVeBgOX6uvqacgdAa1MmQNTyAKGeLKd1fcCdTh8DOXqLyz36tscd+o0XBISEjTuG3/HH6CqPwhch/mImHaawB3dxAddwcqY5hBi8v4AQpN3AkKlInQmq83yq2fIzDRpC1drF5+4GEHoup3ETnEIU9cYnvYkAD72fvI5LRu3RZdDu/+bcYaNrsCGx0uSPrSbfyKGxERW2JweFhDG32sZTZ9P6E+CXGmSTXdtF+V09Jg+Mq9NshOYoAJ3EwhIFDVxY7hWASAWxb9znOF1zo8TgRkx6GoWe+AeiQJo/tUz5GeudR+Y7s4bu2CumptvK1OA1TLEyeMj8rOQ3jH6hJPFm4lNiSpKmGXDRL1HOtlpFKpg7kaqLjQwwkICQVJgo4Qq+jwLYU0+QFbnBPxba95KI4YXEMCal8NdTqlX55m9ecJ5g1p5rYtHIr90Q7qiRnNVdgSuKuUeUU2m4q7sRIcPVtaPhUURzljuZ2Hw3SW25fvJbDl0yP/zIdzqRM7ZhKwIe0C9X83Y4EmX7ClZo712A1t9vDefy1tS+CqCp1F9nU3XFt6nGdofPeqIso0gC3ZT9OKVKASI5q3gDxCIZtQZvCG8fx6HjwRm3CPBlvz0DqT8uZBJdP+Ar++s9JaxUHV3IJ2MJ1z3s/k1wXDNJakIp6mg/wZ9VKWimQ/EpQ4p8T7lPZU3yVTu2FDx9fpKUv9vciVO7W6oaFk9TKE++6wwsAK9RrtZiPyiK+p8h8C7Q2xNwI2Sf/7eXkaBpvaERccn2doO/i2uZnsOk7kElxydxWmzZase2VWTRCkT+7a/fP0j/b1hxw8ob4PKzcVUW2molCFMvJ9ILQSg4MtCfW/bOH0nwkWSe/0HCEOIjrjH7zSy6r7T9k5cdXP2jYZtAbTejpNeudkqt6F5+Ne7UKzu9/9b87+li0Yf+eFzbCpifc
 h2idHHn2
 ZAtaLfW5KicLu1gk9VAJlRtmRi8xsmUe8nZ+oarsIB18oIYGQOh4CHfeH4hxRScBGfUUTjDLIW4rkd2s4QUhF83aXnJ6zdvrsAXB2EvMIl5xgm/DqC1n4bQqLwVlf5I+4oiTtRaqh/VCws8atvEkFrEwKEaht0QKak676Yx6ei24ETSXBYN7rFiQtCxRxc4UogM0511WeNmVQiU1i25yIuGpNGHF43uAP0uaKV/TZXxsIBiMmPmJkF4MKbu/qiw+cW/Vd6C9IIBd0z3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/2025 11:11 PM, Catalin Marinas wrote:
> 
>> @@ -433,8 +439,15 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
>>   		list_del(&object->object_list);
>>   	else if (mem_pool_free_count)
>>   		object = &mem_pool[--mem_pool_free_count];
>> -	else
>> +	else {
>> +		/*
>> +		 * Printk deferring due to the kmemleak_lock held.
>> +		 * This is done to avoid deadlock.
>> +		 */
>> +		printk_deferred_enter();
>>   		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
>> +		printk_deferred_exit();
>> +	}
>>   	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
> 
> I wouldn't bother with printk deferring here, just set a bool warn
> variable and report it after unlocking. We recently merged another patch
> that does this.
> 

That's fine, I will send another patch that does not include this part.

>>   
>>   	return object;
>> @@ -632,6 +645,11 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>>   		else if (parent->pointer + parent->size <= ptr)
>>   			link = &parent->rb_node.rb_right;
>>   		else {
>> +			/*
>> +			 * Printk deferring due to the kmemleak_lock held.
>> +			 * This is done to avoid deadlock.
>> +			 */
>> +			printk_deferred_enter();
>>   			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
>>   				      ptr);
>>   			/*
>> @@ -639,6 +657,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>>   			 * be freed while the kmemleak_lock is held.
>>   			 */
>>   			dump_object_info(parent);
>> +			printk_deferred_exit();
> 
> This is part of __link_object(), called with the lock held, so easier to
> defer the printing as above.
> 
> BTW, the function names in the diff don't match mainline. Which kernel
> version is this patch based on?
> 
The kernel version of this patch is stable-5.10. This part of the code 
exists in function __link_object() in the mainline.

