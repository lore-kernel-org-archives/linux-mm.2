Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167A9FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 03:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC386B0005; Sun, 26 Apr 2026 23:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CE66B0088; Sun, 26 Apr 2026 23:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3A86B008A; Sun, 26 Apr 2026 23:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF396B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:35:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EDC11606F6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:35:17 +0000 (UTC)
X-FDA: 84702920274.08.4DBBB67
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 573C3A0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:35:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RiX+CxxK;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777260915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZyE1SZctZFUZEjn39pcjfbhX1FfFnz6sHZ3o5/6Vu8g=;
	b=sRePBYEd8rTnlyIXpJDaeJLVUFyskX4CGHykBb6Otp2o8I51S9WcDOOl3P8AHti8LOEfGn
	E6A1FdDZDsQoY2l4ofDWDeYeR8jHLBBfe8y8pYNn8L/0UWtmfXslqfZ8vjpZRvFPfsWAyN
	xGThHjgi2Gu/Bo9vb2DYLvMx/7Z2PSw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RiX+CxxK;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777260915; a=rsa-sha256;
	cv=none;
	b=VgAoRxdenJ5sSxyBhZPd+Bm0riwvEj0O1Yh6rxULRx5kX6tzqxuQB1JoRQCcdlB6Z7uChJ
	4sfWmshVqwHHn0hUKpz4HbuPNlCQeBu8AKgiyGRsv9hIn6j/zPTYs8Q/b8/tsG1yywXOZk
	H7NXLJINGvbW14pzlgwcbt6FPckp7vw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B42651684;
	Sun, 26 Apr 2026 20:35:08 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77A683F763;
	Sun, 26 Apr 2026 20:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777260914; bh=dpoz9Br5gfXY9p/k+gIvqj33uh1nKLNMMWdZZ4iAm60=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RiX+CxxKVDl7Rb4MNf49jz/6t05hRkytgOqO+xc2+t+f11crdaEumCECCXRTd43AY
	 InZMBcZiQG5/XIcJ0kZTkNqYfxbik2UHF3kkTr13zeAtpwslDXRvplwYLq0o1Dg2My
	 K2YzBzVjMSVn65AogUa5fm3mwX0rf4mgaQhjGojE=
Message-ID: <91e38f4d-652a-486f-aeff-6b955b43c193@arm.com>
Date: Mon, 27 Apr 2026 09:04:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org,
 akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, tglx@kernel.org, usama.anjum@arm.com,
 mathieu.desnoyers@efficios.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-2-dev.jain@arm.com> <aeu3LU2X2P-Ue9ut@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aeu3LU2X2P-Ue9ut@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 573C3A0002
X-Stat-Signature: fpajsx6y3it5p8iu6xetite3p3xtjxjj
X-HE-Tag: 1777260915-643650
X-HE-Meta: U2FsdGVkX199+KeLBm3N7E9y9u8xP5MeM02vikBDwpdJ8vdFv+kvErvUy3Y53wE+wPKLcGP8qrOdjqQuRSMihB/4Czof8gu8Tzf6rx0qAUYjpb/kkt55zrQjfx0nu2/RrqpbbP6agi1JJcq2YJAYS95WNbJPBORkfaSY/EyubTNFExwbPEKg1IPJZcH2UuakIRcH7q7+vIgGMKhq4Yyiw2G8Sv4fiBWKFvnxZ5zI1Tk3oinLOs9idtfGwELQed5Us3usUpqHHSQY6+NAccC587+nxX4+0mAjfyVDxvd656XDtFbBSDqyT0qkSGQfa9CaKR0ejvIdcKCftzUPsHz7FoC2TQxgC8OFf67g5Pz/yUiG0xhJbrAsYYD0nKuKGmvfkTF07qyjUPvJS5NobkIFoVQjY3S9YqB+z8fH6qU1xslZVxE50NUPdJKNOo5/VXv0dcguKA/t4qpO7PAkReke7PVpoEyJ9URXeohvo5HBPUs8DaLVhiKwKpWGQD2NDHZJiRfkywBB3wQit5ZLaL+2Oo0woDj0uk3BNB0mlz8gx1kmLFnstDf0D7pKAKa2/SMxs/FAn5rK/8Zj3XUUmouwP66F1AE2TrblebaeGgZOE1zrXiHI/lGIutS+I1kTgxLD0Jy8PT/2s93D272d0xwmN8vkDoYn7ilSa1bTPozQ3TrNj1E6tRhLXxomWVrnm3oJlYgxNakkCHsUhSuRRIwV7TLlI6Q2haHwCFV4bJ5+BzLvucuTEtY9OIzN2nVIXd4MnsV84tji0SJ1jSUOgkF4wsf/XMglVFVbhO6AKsXCHOPrPQINwU1mai+nBIGuN3SdVXlsQy48mnBS2GF2uIx9abHzWVwkqfs6PKwh4KsBrFTTZzjMVETXVx/lHX7cGdTjQWYwzGuPvWP/qb6UBHn4Pw98fHjMJwv2M1N9fprsw/wy02DQy5YZpSXaDMejN+5hTwnCGVQHzS3NKVMg2Vp
 bD2mlE/q
 ugP/InaYvxXchtBL6TYa06L3KRIMRqapIRG+auXcp5GQv+lTS2lyyNMRCTzVYo+CcKIGfeql5sDZmWTjQ82PaWjD4zLy65dMuZpG/QfUFdcNFfkSprUsyrnWBaZxqhXOAe24pKvcBP4kyvzzNtLNSEaftkIoj0qPwHboEYo85QvvqcuN2KtbszZ/OUi1EI420a6tmU9Cdt3dqvQ12ta2haPdMnjpWDD34C0vDL5+fowUatj9C+2YYYbqnomKQCpOhyqgfWHpQqyGk53Ozu0V/nPaW5F8tICrfx9Wm4nv2bHGeElM5iQhbxr0h12t677luNjZMFCtRdpuMp2rCYXVp+E/4JSyHp9lG/JXsPdt+v4Rg2+mBcYfbaVtL59vtkk9Pg/6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/04/26 12:02 am, Catalin Marinas wrote:
> On Fri, Apr 24, 2026 at 06:31:55PM +0530, Dev Jain wrote:
>> From: Muhammad Usama Anjum <usama.anjum@arm.com>
>>
>> For allocations that will be accessed only with match-all pointers
>> (e.g., kernel stacks), setting tags is wasted work. If the caller
>> already set __GFP_SKIP_KASAN, skip tag setting of vmalloc pages.
>>
>> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
>> APIs. So it wasn't being checked. Now its being checked and acted
>> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
>> defined there.
>>
>> This is a preparatory patch for optimizing kernel stack allocations.
>>
>> Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> Co-developers need to sign off as well. See submitting-patches.rst. Same
> comment about your SoB as on patch 3.

oops I forgot, I'll do that.
> 
>> ---
>>  mm/vmalloc.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index b31b208f6ecb3..c94fcb2725b6b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>>  				__GFP_NOFAIL | __GFP_ZERO |\
>>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>> -				GFP_USER | __GFP_NOLOCKDEP)
>> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>>  
>>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>>  {
>> @@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>>   *
>>   * %__GFP_NOWARN can be used to suppress failure messages.
>>   *
>> + * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
>> + * (when prot=%PAGE_KERNEL).
>> + *
>>   * Can not be called from interrupt nor NMI contexts.
>>   * Return: the address of the area or %NULL on failure
>>   */
>> @@ -3993,6 +3996,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
>>  	unsigned long original_align = align;
>>  	unsigned int shift = PAGE_SHIFT;
>> +	bool skip_vmalloc_kasan = gfp_mask & __GFP_SKIP_KASAN;
>> +
>> +	/* Don't skip metadata kasan unpoisoning */
>> +	gfp_mask &= ~__GFP_SKIP_KASAN;
>>  
>>  	if (WARN_ON_ONCE(!size))
>>  		return NULL;
>> @@ -4041,7 +4048,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  	 * kasan_unpoison_vmalloc().
>>  	 */
>>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
>> -		if (kasan_hw_tags_enabled()) {
>> +		if (kasan_hw_tags_enabled() && !skip_vmalloc_kasan) {
>>  			/*
>>  			 * Modify protection bits to allow tagging.
>>  			 * This must be done before mapping.
>> @@ -4054,6 +4061,12 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  			 * poisoned and zeroed by kasan_unpoison_vmalloc().
>>  			 */
>>  			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
>> +		} else if (skip_vmalloc_kasan) {
>> +			/*
>> +			 * Skip page_alloc unpoisoning physical pages backing
>> +			 * VM_ALLOC mapping, as requested by caller.
>> +			 */
>> +			gfp_mask |= __GFP_SKIP_KASAN;
>>  		}
> 
> This playing around with some of the GFP flags meant for metadata and
> the actual page allocation gets confusing. You remove __GFP_SKIP_KASAN
> early from gfp_mask, add it back here. You might as well just remove it
> when calling __get_vm_area_node() and we won't have to figure out why
> it's added back above.

Okay I'll do this.
> 
> The __GFP_SKIP_ZERO flag is meant for the page allocator and used in
> this function later to actually tell kasan to initialise the memory (not
> skip this). __GFP_SKIP_KASAN, OTOH, is used to actually tell both
> vmalloc() and the underlying page allocator to avoid tagging. I wonder
> whether it would be better to have a VM_SKIP_KASAN flag instead and
> leave the GFP flags alone.

Lemme reply on the other reply

> 


