Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4102EC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EA26B009B; Thu, 23 Jul 2026 01:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100E76B00A7; Thu, 23 Jul 2026 01:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F466B00AA; Thu, 23 Jul 2026 01:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D51E26B009B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:57:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46CCC1A03DD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:57:27 +0000 (UTC)
X-FDA: 85018984134.23.DFE3D93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2EE1620005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:57:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LOWpAtDo;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784786245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQCv2499vC296j6wAI0cdRxockM48eiGSoiD0g8r61Y=;
	b=E95SH3diYGNJ5Im5HqUEjDOp0H7La0hcbtP1kshDXze7/cq+HU8wqhFUGxcvEPnPivPVVv
	TvWrFZVhxQUVddtiIpSyBqx6B+WuEsaS7RSWoKvVnHPMzzU3bh73s8Qimn7eoyQZnEVGX5
	wNMhRAebiEMJaDTcihIlRHvxHXYtNAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784786245;
	b=ZqC6wZ8lEOmC4FEuXuXSDGrMBgOruRVejiFEBYcc7EnROEBDsIJ12yTh79/MNMWjH2GGEF
	3zOUbG/I08fRN7Gd5JR/ajmujKoCvvpb9UMb8EA6RnOXbORmoXsy/UlAzzR0AdUYnjene6
	RI6FTNBKlIaUxWb4bjpiF3JVP7Vb/TQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LOWpAtDo;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09D3F16F2;
	Wed, 22 Jul 2026 22:57:20 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 879BB3F66F;
	Wed, 22 Jul 2026 22:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784786244; bh=FdNXOOmzFJ56NMNtXW551REGWdO/3itmiVOQUjhNeJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LOWpAtDoTm28o2tE/1stUtYVbc0rRPQchkrnlB7RW/S9U6SE5nUU0Fwcrw4OOJ2K+
	 UHaD7IDWwYQSmFPfnOcf1eWhmM/bJE29QgK2J4WEgNqxJW8XEzaQNhlFk6wJOsnBd8
	 O1ttBL/Yxwa/JKbvG6S2DgbbCRHIYjFfwWgXN3Ko=
Message-ID: <e510fc4a-b3a1-4b7a-b10a-3306e75e8b66@arm.com>
Date: Thu, 23 Jul 2026 11:27:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
To: Kees Cook <kees@kernel.org>
Cc: akpm@linux-foundation.org, gustavoars@kernel.org,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, david@kernel.org, urezki@gmail.com
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <202607222102.E6A5679@keescook>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <202607222102.E6A5679@keescook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EE1620005
X-Stat-Signature: 9perzhpn8ztsp7k4w1jy4iakswq1rgqz
X-Rspam-User: 
X-HE-Tag: 1784786245-341907
X-HE-Meta: U2FsdGVkX185WKBU9xmRp5QX4E/vDZwgSnevt06Ynt+0SurH+TLJQ7bePDUceWGSN2jlqx9bmQMXrs5ZqbCYarne7mDqCs625MOCFkRzchq0cWRQL24PyLr0cUt3Nio8e3l7sMaJPicbnwcRyVJqcb+OF7Shgo/mBluSr8Iflf+qM208mdSSbaaPjD5YDYDDdNZ8VMykuwTh/pluv1guFwd8meo1vZsvi3zPwmqvYzDyYgtSgS9bqFbbjjBe4scLCPR2xGKn6ZJXfmgMIxyh3hYPiUHOHYl+Nfx/rQf0BSZXP8i9GYwtZkBXW/ABmZCLlTP02XaVvZ4293HQZr6sT7Ys2kNthhAYLgQxQoXU5ZDQCwL2P007f57+kXOjd1Wi+4jgK7U/OePFUvd+YpZFR9zSyn4CXKyT/Uwx8O+n8lcCYLWu8cWwnKUbsEwKLrKQJecIb9RIKfVIza7XOobQpLMnNplOz6VfmtIl3N4Q5jwuMFINgb561+IEjHj25AXKYx6so84L6jiuuBWNmWkC1kKPfzLFFEogN5NeF4YHGr+JueJX+q9gYvcZa3d3PQqGt7+uhybpVe5R22EYfoZH/Vz6p9jy8/2JgekfQuMAaRxcbkNrMOaOBCkrnccSQs/yjN82NMwgBQQEsDMVKXpZUecVoejwxgg2PJXMmEkpFIhRBOBuz32ZkhlDj6176P6YXZx7aNBw6BUsh6nRs+GjE9Zlq0E9VDVWq3XYzYa59OjwEmYVL31m9xbWcIIto3h7fGbbCfUx2PcOGGANjbCRrIqxwOi8Y2NxM19EMvvE6N72N784ZqtzykrRi2Er/+JKJYMmiJM/fajY/a6RLWpE/VBNTXHiWqKQ0Rn3gaEkBx+B19saxc8RIvZVC9HGCBY9P4vEKOFMqzd1gaijcfSjWkmec3246yBYw8uThv2+0SsTPcuhJB/pYhVKHmEto+9Ro+qJ6pA1OhrLt9lw5G2
 yD/a67yz
 b3Hqrx5u6ltoHY2s+z1VBkiutq47xdpG9ZXsxs/2zRC28BhBBsNRDvGX+O9qUefWO6GICYshne+ecUyCxllw2A255ttN8xZYf86c4GnVU4kPD4g0lygf8wHK8mmrjl+QaVPWx2Dn2xrxp1lw1VW73XbVV/uoPVtDczNILHbcnFn6fJQqwrZ+/a7HbzT6Ko37oB96eJgBcZeaes0J3jOMkGLd3crsonuJ/E0/iKKSS6iUX3Ic9cNfpBD7Pe9udomTJjAFs0cwpMrCtT0tPYtWCAI39emkwMvIUk7h3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/26 9:33 am, Kees Cook wrote:
> On Wed, Jul 22, 2026 at 02:29:35PM +0000, Dev Jain wrote:
>> The vmalloc allocator stores the actual allocation size inside the
>> vm_struct structure. We can use this bound in usercopy instead of the
>> page-aligned va_end to catch usercopy beyond the actual allocation size.
>>
>> For vmap, the requested_size field is always page-aligned since it maps a
>> certain number of pages. Same for vm_map_ram (alongwith, not even having
>> a vm_struct). So the check is only relevant for vmalloc mappings.
>>
>> Because there are early vm areas registered even before vmalloc_init,
>> requested_size may be zero. So also check whether the requested_size
>> is set.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Looks good to me! Can you update the LKDTM tests to check for this more
> tightened range check with a new vmalloc-based test?

Thanks. I have written the test, I'll send a v2 with it once the mm people
take a look at this.


> 
> If other mm folks can double-check this, I'll happily take this via the
> hardening tree.
> 
> Thanks!
> 
> -Kees
> 
>> ---
>> Applies on mm-new (3d18f3499c48).
>>
>>  mm/usercopy.c | 18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/mm/usercopy.c b/mm/usercopy.c
>> index 5de7a518b1b1c..772681aff8477 100644
>> --- a/mm/usercopy.c
>> +++ b/mm/usercopy.c
>> @@ -176,10 +176,28 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
>>  
>>  	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
>>  		struct vmap_area *area = find_vmap_area(addr);
>> +		struct vm_struct *vm;
>>  
>>  		if (!area)
>>  			usercopy_abort("vmalloc", "no area", to_user, 0, n);
>>  
>> +		vm = area->vm;
>> +		/*
>> +		 * Mappings with a vm_struct track the originally requested
>> +		 * size. Check against that rather than the page-rounded
>> +		 * vmap_area->va_end so copies cannot reach vmalloc tail
>> +		 * padding. vmap mappings are always page aligned.
>> +		 */
>> +		if (vm && (vm->flags & VM_ALLOC) && vm->requested_size) {
>> +			unsigned long size = vm->requested_size;
>> +
>> +			offset = addr - area->va_start;
>> +			if (offset > size || n > size - offset)
>> +				usercopy_abort("vmalloc", NULL, to_user,
>> +					       offset, n);
>> +			return;
>> +		}
>> +
>>  		if (n > area->va_end - addr) {
>>  			offset = addr - area->va_start;
>>  			usercopy_abort("vmalloc", NULL, to_user, offset, n);
>> -- 
>> 2.43.0
>>
> 


