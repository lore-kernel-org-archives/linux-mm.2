Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D26CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5B76B0088; Mon, 25 May 2026 04:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76B46B008C; Mon, 25 May 2026 04:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CFA6B0093; Mon, 25 May 2026 04:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52C06B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:15:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 415171C0036
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:15:43 +0000 (UTC)
X-FDA: 84805233366.06.57C134A
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1EDE1100009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:15:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ORW8XnXQ;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779696941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZcOAXzhq3cI3XWIfG5s5cOD4qHUIgWC2naRLxKB3PY=;
	b=srlaP64IhPyTNpxiiJDtICwm7IQBMcu6oR3/024Bi7MPWw0bGWrDbE7DLVDzcX4bK/O80i
	+i0fg5gVwnyqQ3SNYR3myZdTf1lPqRvJYKsGhcrfARaHZ2PMQO1Mr3Fh1SGx3jTgKofEIp
	+x5VN67qZpURYhlnscaR8fxY+36qgd0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ORW8XnXQ;
	spf=pass (imf14.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779696941; a=rsa-sha256;
	cv=none;
	b=XN3M1VQfwnTMdIVnf6k8wTj2fbELx1cyCOxMsgtHMfJ62G+migUiszalKNRsOUBt6TZOlZ
	tG9Qm6dYDF7n8iNcG/cJnHbsgSCZg8Nz7msotScr5z6Z0933dfTgFtVGCtJt2Wn+U6F01u
	SlU7IPuuxGwGkp3w5ikdgT9qasfk3S4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=mZcOAXzhq3cI3XWIfG5s5cOD4qHUIgWC2naRLxKB3PY=;
	b=ORW8XnXQ78h6t1ovXEQmoqHsib1bGONWt9cvu5j3gV3DFlhSJf7GjpCuumaLuh
	Qv/5xuoPvDkljMvGXprfJdCiU9LtpP3DLFY5CjfrpDNrF4j5QhIjB3gqCwTNnnyH
	3VVyyVw80c59aOk8B22Q+rVCMfDK9ewnMv5A+hZp0wwhk=
Received: from [10.42.0.218] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wBXh6_0BBRqVw7SDA--.11722S2;
	Mon, 25 May 2026 16:14:46 +0800 (CST)
Message-ID: <87efc5ef-9fef-4cfb-a129-bf8ca373683d@163.com>
Date: Mon, 25 May 2026 16:14:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/5] mm/shmem: make SGP_NOALLOC succeed on hole like
 SGP_READ
To: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20260520101538.58745-1-chizhiling@163.com>
 <20260520101538.58745-4-chizhiling@163.com>
 <772f7bcb-eb78-4439-b94b-1a096a01dc51@linux.alibaba.com>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <772f7bcb-eb78-4439-b94b-1a096a01dc51@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXh6_0BBRqVw7SDA--.11722S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1kuw18ZFWkWFWxKryrXrb_yoWruw43pF
	WxGas7KrZYgryUCFnrZws7ZF15Wws5KryUKFySq34YvFn0yF1vkr17Aw1j9F1rArW8Ca1F
	qF4qka9xua1DX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UZNVgUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3Bbde2oUBPZJ-gAA3X
X-Stat-Signature: 79kgwwebynwi6bxzn6kk6zmicgz7gpmz
X-Rspamd-Queue-Id: 1EDE1100009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779696939-366153
X-HE-Meta: U2FsdGVkX18Z6Htp1WZq09v5PXTkCI+bzS7qH9iYlD08ijCVdsn7tsacwAAPqg0c/zHAs0AgjO3OB5a5TfrwgnRx564eUCohhTqHHX1I2GfGlpVreGWWhoYomSuaRwB7bMza+yqQ+pEcQeqhAe8urHdhnWAg/FMEry5SXeKKYZMyERfoR5mEqWJ3njPw/QwCYGA9y+8ZVPeB0oOjt/yIgAjfVSf7hB9rcwMquL3qjrZcvEwLPqGw2X4RNn6WQBC4NGmMJ+TxPVpNt/uVcsWndDS4HvaDLMudVSyty03jEah6K008fMPB2DM6JqB5IiAWLX211X1HMS99QL4I3QQqLH+KvvHbjBnLXtHWebdArDYS41R/vIpnkXKDhOfrMS5c6WJo1rKZurJahMlEqEZkbc36TBbm3HrMFRtFUskJxlFRFkGZreGIbiIj+ZdNMn8MpeV1bL5HjxUm2yHsIQSxkoDSn+bH6UVW7yAwIUfbOUSX+q8jBLQ9eVS7A+UCWOGK6pHoooXAOHI00e5wXOxUJPhe+G6kC3lA2g5gdkpKofUl6XVr0w/ckiRAKrwpNfEoaLjYXVqcXL4LCCn8kUfVWroNxnIEy7dHPFPkFUQuTuL1NDfuaVKZngt83XFUdzGUnsB0t1vfNacDFXzZlOyA4l8/4kXOmtxdUPbeXp7aiV3lalbNVR/dhmq+GYg4IJfVrrkD7/E0v1vKdfUfR7axDEKdfiSo5NrafgcG77BfzDEjYMjNm6uh6YMBS/UWivPqSUisJqQG7pfJBaOywueRFol+gu44qnX9eyYhMI/1tJDpJKHZZrbl5mQUeB+4g/eqpBB+7PoVTU5YqU00MVUevowpOzDzx2tIE+OeTj5bn9cW5RzpcCME7/H8t3CYG2vIe3aUKle/U0dkCDKNFN6PQIKuHvlA7OTG/GtC0iUimW1SR/FnQt01JhY7IsWvKyl38UUqS65w5IvwBM2jga/
 O9bN5Cwr
 UW8PDx1xmVZydkCjticKET1p3eQWdQZjrRRf8KWMoyqEqQJhIfvHHUor/Qcp+HXjZmrxaM2FjLPlSMH6oqGqFbEKwtuA9DP6rPrjPCISvHjHJAxDRWzicLPA2FYqLnBVEyMI8vx/F88cKS29WFIAIrsy3S3mZx97RcbrTa6/Zq6hbjJ5D6STwxV5wDd9zATZdiyksJZ668PxCGoGnao2GOUVN1OQ25KPkMoRMBNLYXbqytwGpAlMxv5+4bSyCcS2FuLSQ9czr6T8iZmXkOQYiI2X7/uWo2gfDfvvxkRQ5SgY48DYFUm6Pz/6HLrIQUOE6IdmnQEcOwrnQ6/rmdDvKeOJIxQ9I4UhJyhxQT6Ezzuf4v4PnrgV2woAyUZNV+7yHk8O0FXoxq8YY0aRGbt7LYDyNWJyVZEKMS3sedyhz9yT3aHvfyjvuVj6VQlBZ9xpcbkIzwmPVw+/LlJk7xEjpgGOKbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 3:10 PM, Baolin Wang wrote:
> On 5/20/26 6:15 PM, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Change SGP_NOALLOC to return 0 with NULL folio on hole, matching
>> SGP_READ behavior. This simplifies the sgp_type handling by unifying
>> hole semantics across these types.
>>
>> Previously, SGP_NOALLOC returned -ENOENT on hole, while SGP_READ
>> returned 0. This inconsistency required special handling in callers
>> like khugepaged and userfaultfd.
> 
> This patch doesn't seem to be a performance optimization, and I'm not 
> convinced.

Hi, baolin

This is not an optimization patch, and it is not related to this patch 
series either.

> 
>> After this change:
>> - khugepaged: behavior unchanged (checks both error and NULL folio)
> 
> But this adds an extra check to khugepaged, and I'm not sure it's worth it.

You are right, I will drop this patch in v2.

> 
>> - userfaultfd: behavior unchanged (both -ENOENT and NULL are converted
>>    to -EFAULT before returning to userspace)
> 
> No, this will break userfaultfd, cause userfaultfd currently returns an 
> error code directly in this case (please update to the latest 
> codebase.). See:
> 
> static struct folio *shmem_get_folio_noalloc(struct inode *inode, 
> pgoff_t pgoff)
> {
>      struct folio *folio;
>      int err;
> 
>      err = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
>      if (err)
>          return ERR_PTR(err);
> 
>      return folio;
> }

The return value of shmem_get_folio_noalloc() will change, but it seems 
this does not affect the logic in mfill_atomic_pte_continue().

```
	folio = ops->get_folio_noalloc(inode, pgoff);
	/* Our caller expects us to return -EFAULT if we failed to find folio */
	if (IS_ERR_OR_NULL(folio))
		return -EFAULT;
```

No matter whether get_folio_noalloc() returns an error or NULL, the 
error code is converted to -EFAULT here, and mfill_atomic_pte_continue() 
is currently the only caller of get_folio_noalloc().

Did I miss something?


Thanks,

> 
>> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
>> ---
>>   include/linux/shmem_fs.h | 2 +-
>>   mm/khugepaged.c          | 2 +-
>>   mm/shmem.c               | 9 +++------
>>   3 files changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index 93a0ba872ebe..d461713c095b 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -165,7 +165,7 @@ extern unsigned long 
>> shmem_partial_swap_usage(struct address_space *mapping,
>>   /* Flag allocation requirements to shmem_get_folio */
>>   enum sgp_type {
>>       SGP_READ,    /* don't exceed i_size, don't allocate page */
>> -    SGP_NOALLOC,    /* similar, but fail on hole or use fallocated 
>> page */
>> +    SGP_NOALLOC,    /* like SGP_READ, but accept fallocated page */
>>       SGP_CACHE,    /* don't exceed i_size, may allocate page */
>>       SGP_WRITE,    /* may exceed i_size, may allocate !Uptodate page */
>>       SGP_FALLOC,    /* like SGP_WRITE, but make existing page 
>> Uptodate */
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..3309d1c094df 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1950,7 +1950,7 @@ static enum scan_result collapse_file(struct 
>> mm_struct *mm, unsigned long addr,
>>                   xas_unlock_irq(&xas);
>>                   /* swap in or instantiate fallocated page */
>>                   if (shmem_get_folio(mapping->host, index, 0,
>> -                        &folio, SGP_NOALLOC)) {
>> +                        &folio, SGP_NOALLOC) || !folio) {
>>                       result = SCAN_FAIL;
>>                       goto xa_unlocked;
>>                   }
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..458853c506ea 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2524,14 +2524,11 @@ static int shmem_get_folio_gfp(struct inode 
>> *inode, pgoff_t index,
>>       }
>>       /*
>> -     * SGP_READ: succeed on hole, with NULL folio, letting caller zero.
>> -     * SGP_NOALLOC: fail on hole, with NULL folio, letting caller fail.
>> +     * SGP_READ/SGP_NOALLOC: succeed on hole, with NULL folio.
>>        */
>>       *foliop = NULL;
>> -    if (sgp == SGP_READ)
>> +    if (sgp <= SGP_NOALLOC)
>>           return 0;
>> -    if (sgp == SGP_NOALLOC)
>> -        return -ENOENT;
>>       /*
>>        * Fast cache lookup and swap lookup did not find it: allocate.
>> @@ -2657,7 +2654,7 @@ static int shmem_get_folio_gfp(struct inode 
>> *inode, pgoff_t index,
>>    *
>>    * When no folio is found, the behavior depends on @sgp:
>>    *  - for SGP_READ, *@foliop is %NULL and 0 is returned
>> - *  - for SGP_NOALLOC, *@foliop is %NULL and -ENOENT is returned
>> + *  - for SGP_NOALLOC, *@foliop is %NULL and 0 is returned
>>    *  - for all other flags a new folio is allocated, inserted into the
>>    *    page cache and returned locked in @foliop.
>>    *


