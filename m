Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1E7C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 03:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8456B008A; Tue, 22 Sep 2026 23:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FC56B008C; Tue, 22 Sep 2026 23:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6BA6B0096; Tue, 22 Sep 2026 23:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 581FB6B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:48:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E07BEC067C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:48:58 +0000 (UTC)
X-FDA: 85243645956.10.458EE85
Received: from mta1.migadu.com (out-91.mta1.migadu.com [95.215.58.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1FEA40004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:48:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eGGSwrT1;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790135337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwWRc/o9MtTy58JhAX4zKIymI6EPJ9a/8ATDwzpx1Mo=;
	b=YqYkQj5Z2fcwC+Ng2pQ16mLg1NWlH/B8A9IJHWprZewSUIW3hFlQifLyyWXYeKVajoFuRC
	BLtcAlGyOZksS3FP7Vn1fcWc3/whebzUUJOzts+0tawf+HmE9RuHsdDW039gIXfVcH3v/f
	VgHuLo33IJvG4/+cu1r5LOblACopOZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790135337;
	b=AeoyhR9d9zAUZ54ANqqyYjfrTAgiCT+jzSJKzklpeB5+JJdlH8rvANmL3853CTdOFNTDCo
	620T2/hb9XwQ8UZz+kXW9uCsJxPVhM0zxlcarpsuEfpFZwcGu3dg9mG4zCxIceOD9Qyfxb
	4nWS44p46fO7tsPOJwRx1efldY6poCQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eGGSwrT1;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.91 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kwj1dykHmtOFPAs+8qWDVTWLL54NsScLQymUSN+v64I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790135333; v=1; x=1790740133;
 b=eGGSwrT1bfdsDebz6TCRNlnQKa0MDYDXCwWENpPCG1kHQM6ruG3wBZuS1aIYtY4cYC9gCtV7
 1u1XLvwiK1rR4YX+IuWb7mIIHrKa/WKLQbF2+P6IG7KhskfRyjuc8CuCbQ34mVZLxrocAcfefBv
 8u5L4QjGO8BHdCmWUWh1VxPk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09235456071ae306;
	Wed, 23 Sep 2026 03:48:53 +0000
X-Mizu-Trace-ID: 09235456071ae306
X-Migadu-Flow: FLOW_OUT
Message-ID: <97c0aabf-872d-46d7-bc98-ab50ea7035a0@linux.dev>
Date: Wed, 23 Sep 2026 11:48:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc
 addresses
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
 <20260921-vmalloc_dump_obj-v2-3-73fceb3ed1c8@linux.dev>
 <arJw-VKQNxWA0RSc@milan>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <arJw-VKQNxWA0RSc@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1FEA40004
X-Stat-Signature: xsqz96a9ijpyts18goawagf4onang5z1
X-HE-Tag: 1790135336-802649
X-HE-Meta: U2FsdGVkX1+3nB50ro2hOgm8jQZCGzH+TbAs7za2aJj1YC23sa5V47eEBF/K9OfWWfm2laz9+/RFDM1d3+sH+sykcT86bLvNK+ZnTVqTmX8Te3J2k9N/aVl1k4pS5voHoG8QWvRVy77Qml7MG7dWJUki1WR6vVWt5szidtWK1P4Kmysf8AwOD//5q50jL47HKzaldjw8qXOvREFn7iAunidXkTkGsPdN41EbU2BUIYyuFT4NLGgtlfZDBTM24WQ7pfJ19H/S4/hmWn+6RJOigGPI7nTCLGK1gUmsNU457L86mheysB3R75oJYbOtiHNPXMAu3zWHRzrtC0H5WZIIgFMBYLbivgPXginFwuVaywUU9152xuGkm7BBwJPxlnS4EZQMAiK7EDvq3anhF/o+fra6uly5tVyFI68X8Qkxeoaxdj9LjkuySGSCKcFGpQQrZSzFQH0perxEsW1cS7FXy8PpVuqSv7XeCjAaZ9caRFRy1Ivfulke7tGyBl/T5WUYITl0qhgYX6uAcWQxnS8zPGVG54foZsJnjpL+h/2y1H4J5GXjMYJJgYmTxJzUH8BoQIpq1F5d/ALeB7U1R3o9lUqNJBXfuSipTi3ASYo5C4ZtRgGl0LM4qYxSlvvwtSaR1tzeZgoIKYPHUSXkxxVu/Po8G/WCBE71U/xqzF5Q9MjZcqQCvEwJbtQxGjasaHfHvpxB4fFSeeIm1lCuEYODqt8qvJwOmeFGJP8oGZgiyxPrnUqgn3xsmKoRzCJAWPC5NQHy1RxhkDJo/E/dd5srtrCyYjITIPXRyYwks9vbca3uj3JlMeRWUQc03WXT5B7xNfNt7pc+wCmPUPt1wDcgrqQ6TVzUo2UKEfzok5rMS0rQbPYcaaAsbLTN0N6GOBzJbkH72mOiYYvexrWvnVrcOcyNeH+EHoN5wCRBGlp5bz1RaZbR6EBdUXCXngqfVurMuoAIr2uWrqyLKq1UUrO
 8wzX4bWJ
 tsdfDrqU4AGZvp82Q1Fxa9rSsr79rY3NLnVdNpldPBTh5aSY2GPRSwP0albm10yeKI+2zuLyp/UmbMrJEhjw9sGoO+iyL49d64HKpuRAObwZ7889yn2+1CKyCgWaSLIbwbPECLdsPGVn9qhfh/Sr6XTpDJlfd9SDxd1mBVTcktUNX44i1uKlMK2NtJFl1iJsEVx2Y0uqArezwVHt8zi28KYKjewO4bcZ/lKlSAC6RjN0YGSBFC3XyfafsZD+Cxft/BUbl9K0OUTgVbzWb0uMvtBKOYEfYAhZjMRgbgIC8f8yjIShlP0NSCUbzVomiUhWps/b1wGL8BbZP36QS3ErL2ouQaa7lLYWK8EVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/22 20:13, Uladzislau Rezki 写道:
> On Mon, Sep 21, 2026 at 09:17:23PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> vmalloc_dump_obj() unconditionally searches all vmap nodes even when
>> called with a non-vmalloc address (e.g. a slab or stack pointer from
>> mem_dump_obj()).  Add an is_vmalloc_or_module_addr() check at the
>> entry to avoid the unnecessary per-node trylock and rb-tree traversal.
>>
>> Use is_vmalloc_or_module_addr() rather than is_vmalloc_addr() because
>> module, BPF, and execmem allocations reside in MODULES_VADDR..MODULES_END
>> on x86_64, arm64, and riscv -- outside VMALLOC_START..VMALLOC_END -- but
>> are still tracked in the same vmap_nodes rb-tree.
>>
>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  mm/vmalloc.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 30c610f678dc..d8095b558365 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -5277,6 +5277,9 @@ bool vmalloc_dump_obj(void *object)
>>  	unsigned long addr;
>>  	unsigned long nr_pages;
>>  
>> +	if (!is_vmalloc_or_module_addr(object))
>> +		return false;
>> +
>>  	addr = PAGE_ALIGN_DOWN((unsigned long) object);
>>  
>>  	/*
>>
>> -- 
>> 2.25.1
>>
> Do we need this check? If it is not the vmalloc address, we just return
> noting. Another question is why do you want is_vmalloc_or_module_addr()?
> 
> vmalloc_dump_obj() is about VMALLOC_START..VMALLOC_END, IMO.
> 
> There are only two users of it and both rely on the VMALLOC_START..VMALLOC_END
> range:
> 
> <snip>
> *** mm/kasan/report.c:
> print_address_description[403] if (!vmalloc_dump_obj(addr))
> 
> *** mm/util.c:
> mem_dump_obj[1096]             if (vmalloc_dump_obj(object))
> <snip>
> 
> 	if (is_vmalloc_addr(addr)) {
> 		pr_err("The buggy address belongs to a");
> 		if (!vmalloc_dump_obj(addr))
> 			pr_cont(" vmalloc virtual mapping\n");
> 		page = vmalloc_to_page(addr);
> 	}
> 
> and
> 
> <snip>
> 	if (vmalloc_dump_obj(object))
> 		return;
> 
> 	if (is_vmalloc_addr(object))
> 		type = "vmalloc memory";
> <snip>
> 
> --
> Uladzislau Rezki
Hi Uladzislau,                                                        
                                                                      
You're right that the check is not necessary — without it,            
vmalloc_dump_obj() just returns false for non-vmalloc addresses after 
searching the rb-tree, which is fine for a debug path.                
                                                                      
Regarding is_vmalloc_or_module_addr(): the concern was that module/BPF
allocations are also tracked in vmap_nodes rb-tree (they go through   
__vmalloc_node_range with MODULES_VADDR..MODULES_END), so             
is_vmalloc_addr() would filter them out.  But I agree that            
vmalloc_dump_obj() is about VMALLOC_START..VMALLOC_END, and both      
callers already use is_vmalloc_addr() in their logic.                 
                                                                      
I will drop this patch from v3.  The series will be two patches: the  
alignment fix and the cross-zone lookup fix with the shared           
find_vmap_area_lock() helper.                                         

-- 
Thanks,
Ye Liu


