Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47377CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDEC6B008C; Tue, 23 Jun 2026 06:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B71D6B0092; Tue, 23 Jun 2026 06:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CEA46B0093; Tue, 23 Jun 2026 06:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 063EA6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:01:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A15B8DE8B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:01:17 +0000 (UTC)
X-FDA: 84910734594.16.84A53BE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50DBD140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:01:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O9UNZuuX;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782208875;
	b=ZEi2YvG0FP3LrKeqt/KvlxzrA8fh5s1ofHmrgXYy88xRGTQ/fG5STMc/toI6FhwYoLBMoN
	s32mjwpY3RHR0QPx4QAfyGVrBsgUetqaw2VqF/mEAgOJlsgzV4vPrsl2aUllQ7OHUbLwOr
	OA6fKGD/NVR291AzYVCokdsp+ZXSWoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782208875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtTaDI+6L6cK7pAN6pfdMFBfawMBtcYb6fjhCBZGnw8=;
	b=dCLbcmtjQtXaNZ2eE0TIzzrHzYqfGMfs9ty7fonRocr7Y8Ou2pDgWzsJbjjQ7vO+kiWHlV
	0Bac8jxZRLi+T9TwpFlu5Hjpzo8yJHbAouX0xioSrhSKipFefGmLL6CVAGHkNKNwymcYaC
	Qa9fmWaO7fO7ORzYmm6rrOBo/YSR1hA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O9UNZuuX;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51A151A25;
	Tue, 23 Jun 2026 03:01:09 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69BFC3F62B;
	Tue, 23 Jun 2026 03:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782208873; bh=QssQ3X75aCKMuuN/Bl2WLW7c+ks6QkBQHUfIQL/PJF4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9UNZuuX24DFwpJHUI1a0hPd4j3c6Il2S23sHHX82IZjgGUkk2gO4w7np0CzUh4sJ
	 i/DVZ3/0pBa+MIDakGjwPobFD07nVtPAcd9xtsqhdb5avace5qOXKG3ZdCNgz3Umr+
	 o4F8nElCEKvwtiSdC7hPyN4dNn9JetgS95I2rZgM=
Message-ID: <562addc1-b334-4258-b0d2-0154ffed061b@arm.com>
Date: Tue, 23 Jun 2026 15:31:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] mm/memory: Batch set uffd-wp markers during
 zapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-5-dev.jain@arm.com>
 <a9483db7-5b13-40ff-8d45-12f40dc97c77@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a9483db7-5b13-40ff-8d45-12f40dc97c77@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 50DBD140002
X-Stat-Signature: f4xsgixkft8f4rbja6yboiy34dcg8gj5
X-HE-Tag: 1782208875-819369
X-HE-Meta: U2FsdGVkX1/LSRWT7AMwku2pKgI3MBhkV2zrfrUgYoUmstniulJNhdJ7pgR0EjSnOHVjmMZaSbwWXul1/3tJgG+kjPW919uhQdeXjk3UL/Y6oTmaW2prHibRKRiIGHcT6jSBldvzvrwgBIFhhObNcqQjvCHq+CoemZsgrpym7x/E0beQSYfJvBxaZYR5qQBPmB401QC4D4DpqhvimSoaR8W7t6MOeoavpu3lwakL/NqyuaKx4xpxDNUugbupGzHdCVo6IeWAut2W0yUefwgwpuLc9qV4wtVb0wAwwQZh9MGS/IOYk+flWBVIR/Jm60rJn8hqERwNL8ZwDAygjwY530Kl7BVB8HHpK0ZCSqq+bVJya7slSu8Un/yFNVAFlfp8ohBidTBu78e/DVVWCfPzW8T62gnTkJFEM8r5ADnO9YL8lYCG/R5dODneV/wCGj9PN0wRXA7ODgaOAkzLN2uzu9kx3j0QTvhgGc8ABfMjbbb6yMxhDdoxlOpmebjZu33AFWhXKPdxYgQn4b4WzPeMjIyj8272t/7OWkxmViUOjjzY5sFbR+rStMs9lVO5NKcSlxTT1VciuwKuubljbY2rW2j8RyZTBDvLytQwi6qVJ2uQ7ywIO/+y91+Gf7Jhtdjsdx3gbDEkGjpM0kQ2VIaWfjXELEj9j+cgFhBqJxuEkSBgmfQ93phxp6Fq7OvMH/OCap95Dr0vxYhJC5H3d4sK/fIgQ9pM9ynNOq/GhM2eiQJSeQf0VkSTtx1FmqKu3YYngSnT2mX06gIht051MsKdSUNTFES4vnhI78QLoY3mMgBHw8k7ghzzrkM1JB+Kj504e4MIGqHx2uH3UKiGHXQos+u7ANKS7O15B/mkuHeYqCnmPaqgH32a2+20Zgqcxi4ZIcR5X9SZKEJJBOvOI3GTZqaO1YFQt+yFZYwTOBNbzIsxQMGZ1cyNY75z3/Wxm972u/jh6/4Y1cPFAiiaelE
 zEtiF5HU
 J3tqn4UJPyCrckEhlDRMHQnnCcZIoKLNSwEpf4F8P8zZ5GmefYjx6Xw3mDRX/BZ/JOBtuS0FDNcn+XJsCEIHHxgVugccditB2z8CLrWmH06eONshkebl1QB9+h11Yn+c7ZuOqgeU/JaIGrYB33rXkPxVmMFex5KWARHghaSihDSY472xBHk8RAsivJVHalqDxoVWAu+0KSAW3v6mE88HCMIcEbAZFao1hcR778GcHViitVJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/06/26 7:13 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> In preparation for the next patch, enable batch setting of uffd-wp ptes.
> 
> Avoid talking about "next patch". Phrase it as "In preparation for batching...".
> 
>>
>> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
>> that nr through either folio_pte_batch or swap_pte_batch, therefore
>> batching is correct:
>>
>> 1) all ptes belong to the same type of VMA (anonymous or non-anonymous,
>>    wp-armed or non-wp-armed)
>>
>> 2) all ptes being marked with uffd-wp or all being not marked (same is the
>>    case with the pte_swp_uffd_wp_any check)
>>
>> 3) uffd_supports_wp_marker() is independent of the function parameters
>>
>> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
>> since the latter cannot handle present->non-present conversion for
>> nr_pages > 1.
> 
> Below you have
> 
>> +	/* The current status of the pte should be "cleared" before calling */
>> +	WARN_ON_ONCE(!pte_none(ptep_get(ptep)));
> 
> Could we easily extend set_ptes() to allow for non-present -> non-present with
> nr > 1?

We could have a set_nonpresent_ptes() in general, but then for some non-present
configs like in this patch, we don't need to change the pfn, while in some
configs like setting swp ptes in one go (like I do in later patches) we have
an underlying pfn. So I don't see an obvious simplification with a common
helper for non-present -> non-present for nr > 1.
> 
>>
>> Rename the function to cond_install_uffd_wp_ptes, and convert the
>> documentation to kerneldoc format.
>>
>> Move the function to memory.c since this has grown too long to be kept
>> in mm_inline.h, while retaining the inline hint.
> 
> Well, for functions in the header you really need "static inline", so it's not a
> hint and I would just drop that comment.

Ok.

> 
> However, the move while modifying a larger function is rather suboptimal for
> reviewing (more like "spot the difference between these two pictures"). I'd
> suggest moving it in one patch, and thenb modifying it in a second (this) patch
> instead. You can perform the rename already while moving I think.

So I'll move the function, do the renaming of pte and pteval, do the kerneldoc conversion
change in one patch. Then batch and rename in the next.

> 
> 
> Nothing else jumped at me.
> 


