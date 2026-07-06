Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B557EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF406B00A1; Mon,  6 Jul 2026 08:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FF56B00A2; Mon,  6 Jul 2026 08:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5D86B00A3; Mon,  6 Jul 2026 08:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5055A6B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:23:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAF7B168AD9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:23:39 +0000 (UTC)
X-FDA: 84958267758.15.AA23E12
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id D294610000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:23:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMW3Piaf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783340618;
	b=VOUjCRyUlajvBrAQafVdm/0b7pbwOzGi7ZONUpkMcTXOcGbyqYUBUWQ0WpMrOU9NhXUBb9
	PGsmlWmiJyb/EG+y7J3t1vO0RDNdjAUz6nk805llQswlw7rzLVf0cpBzCotiEiIrm85KC/
	28Rnn+BBZ3mjQLCcH12xGIdX/EnBlsU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rMW3Piaf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783340618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9j0GOdBfYeLx2CUbyWxmjGIwhc/AnYvsLCc56GZQxMQ=;
	b=8BpImyjH/jqcXRMdJ3cXrdGhI5g/May8ymymjYIHCbVJuY4k8Ar7+C3tSPIeSsR9xNs9o5
	+NTfv9mRLLxABZee3hIXfZvBU3U7bfI/TUSa9jU8KdBKhconQpI3nCox69FQ8qiobZNP3v
	s8BEEvu7i9MKOynWiVgA9a2vR3zkT6A=
Message-ID: <642efd6d-7366-4641-a999-2d419fd38f8d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783340615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9j0GOdBfYeLx2CUbyWxmjGIwhc/AnYvsLCc56GZQxMQ=;
	b=rMW3PiafInDZbNyrGZzU42E3W5uKNLvaWtlr2sGsIt7yxxWMILZr6otgwwFAl3pihY9pY/
	+VvnCec0pE9JQcAA03fmlFPA/Qzuzj9Zxt6XPDWrAJRZDjZc1f4b7U4mUNCew2UYcNy//X
	CovhfrR5+XhKWfIuDPt6qqW8VfnsTbY=
Date: Mon, 6 Jul 2026 13:23:29 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/6] mm: extract mm_prepare_for_swap_entries() helper
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com
References: <20260706114320.1643046-1-usama.arif@linux.dev>
 <20260706114320.1643046-3-usama.arif@linux.dev>
 <akuXgognmAW0QhOX@thinkstation>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akuXgognmAW0QhOX@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D294610000F
X-Rspam-User: 
X-Stat-Signature: f8kihqnjzwfxbc77o8xgenirqmjz4hoh
X-Rspamd-Server: rspam03
X-HE-Tag: 1783340617-665225
X-HE-Meta: U2FsdGVkX194IaPFdzqBqRg9kcCpTf2qeNxUVK/9YYpkjcAcZ/4lPvIcGK2sOuN7/6EUZWGAi0p2DJvdVNCLrWpzEUGmO9snoFexpufGQcRBum+U1btmKOzd50cBpOPs6TVfpycuF/eHhm9+qHsRmYF72/UB5rOSk6PFzp/EhdWHqU3cZNJFMQaYvV5meBTgoEVj+DzMa5oh6SQqq2VNNP/DZtErt9DSkkR1t8bbN6Zpub495lw2Bfg1EPXOoyCIZ0hwcXlYjizE3GuRjimfu4oa+hRFvnXzC2XyHQw718NqIvU5iRJKV5pW5D6byFACTzXvkCMpOiuelG70973HkRgYQM6WIo5zXIO5ppJ5OEJMWHFS4oMIFG1GhOp6CElDXQk+490YdgxND1ExF6T8GheKK0i90bA6PjQNlxNkY2YHhqSe3YAT/YnBk3GVAZ2XIxNGWbPl7RZyQUUGRYwvlEgqQgra4e9mjRGPsuW1lCtiQU6n0uV0KXGPb1+d4nZCHZ3LPorq1Iusb/Q965e7D2/RitGdJ6uoWOFtPlHg9EFnwnuNa9BwBOSOhJ+XVt7nANGGXfnBug3Iv2bQu7kfeScRzojAbEa7UhDkEVnwNj0rKir8ANIlnS4nT2bBDey43REqK1yrUATkVkhPzDUU8QkuPeGLehqHiuArvQEavORk3my7ZRJzAzlMmSrJVqDpiKTdjE44dSvQaMKJ0DotyrUpoenFeUwzB2ThUJ6GWZLR5SiRA5LWlBWwHXN5JAx2IMtJafXAijOQU7ZJRtECnnVSgR4ufEWg5BkszXRLjGVatwuWehMeD7ZKC9al5g1WR0vAr78Te+x4qYI2Sd81tRsBay3e1mVZw9T9p4wAa7HuJ0W5m/5YqaTO96MGNol1+Qr9lXQZhUkPmy4CTB2B6Wx2MlvK9OFFcdJpUi0mhGX/s+5cMQuoqPuKiJsWFrmO57X6QjzRD8z952FCOpr
 dHHieKpW
 4uv5GK3ohc3m7mAzsafkOowb5oxDXw9SK4oT/r/p5K2fX8VdWxD9YeJIfdfahqmiWWMrnk8NBQOSNb6DW7KOP7YyKr3KZsRAZqYUy+RjzgyGRX63r+XlYlgTn6mDjadvxUy54+wZZoeko02smTqP0GyRNfNIsnTc0BVBQeFg+E/l/lfKjCo2vPvBfvXdpUjc53x3RM0NGPmM/dTO2CCQknbT7SI8Hq5XNsK/HP3kW2S2RvFz8/YCQqfhqkgSyya41uPjo2wKnuOSF75eImmzwvr9LgDA6mFLBlHjO1I6f98K/6EtWWW3Jj9qruvxNukhZuEjPFKoWZR+uCZbY6OA6TxwpD+I/DXfs7naqGmQOcBSTDwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/2026 13:01, Kiryl Shutsemau wrote:
> On Mon, Jul 06, 2026 at 04:42:04AM -0700, Usama Arif wrote:
>> When a swap entry is installed in a page table, the mm must be added
>> to init_mm.mmlist so that swapoff can find and unuse its swap entries.
>> This double-checked locking pattern is currently open-coded in
>> try_to_unmap_one() and copy_nonpresent_pte().
>>
>> Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
>> both callers so it can be reused by upcoming PMD-level swap entry code
>> paths that also need to register the mm with swapoff.
>>
>> copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
>> than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
>> is a circular list and swapoff walks it entirely from init_mm.mmlist,
>> so only membership matters, not position.
>>
>> Reviewed-by: Dev Jain <dev.jain@arm.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/internal.h | 10 ++++++++++
>>  mm/memory.c   |  9 +--------
>>  mm/rmap.c     |  7 +------
>>  3 files changed, 12 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 430aa72a4575..0360648e5726 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_count(void)
>>  bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
>>  		   unsigned long npages);
>>  
>> +static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
>> +{
>> +	if (list_empty(&mm->mmlist)) {
>> +		spin_lock(&mmlist_lock);
>> +		if (list_empty(&mm->mmlist))
>> +			list_add(&mm->mmlist, &init_mm.mmlist);
> 
> The patch is fine, but the name of the field is awful. Seeing mmlist I
> assumed it listed all mm_structs. It has to have "swap" somewhere in the
> field name.
> 

I can send a separate patch once this is replaced to replace mmlist with
swap_mmlist if that sounds better?

Thanks
Usama

