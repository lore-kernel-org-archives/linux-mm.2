Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C48CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BC96B008A; Tue, 29 Sep 2026 04:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B7E6B008C; Tue, 29 Sep 2026 04:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579186B0095; Tue, 29 Sep 2026 04:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9736B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:35:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99557140441
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:35:32 +0000 (UTC)
X-FDA: 85266140904.28.0ECEC2C
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 272904000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:35:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0UsD9hpMiIm/RIAtugV78aZWAfXesb7Suqvu53gqeMs=;
	b=YXkUdcti1C3u53lQr+7zoZPRkgfx8SCVgxtDnRGQFFRuPEhqgNMVu0LxT7ZB6TRRMbuaRM
	pqoFgOr3Ho4BvNPczZsW6gVk69X7Px/yldIr+wi6kKqe5ce+aIjEzojZR5pBXZ9xIsYqAV
	kofhP9O0iyNAAvyNufCZCJwC9Yhetzk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670930;
	b=kAgRT4IQS4FFjzF+YslbuBiZ4DpTy+PAUFUHYJLIMuWXSdyufvu8RMpDVWXesx7UdeduY5
	leV4DydpvSBRFp3qVcczoVlYZ7oAZndyuLTHVyxUDdx2NSxbVZGXRsP68UIPs/qMfz5L3l
	RKjUIZjBnaFEsmfNSH6jVAEGGukRDMg=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hvBLj71dtzYQv1c
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:34:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E1B7140579
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 16:35:20 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXdCdGeLtqQxpoCA--.31456S3;
	Tue, 29 Sep 2026 16:35:20 +0800 (CST)
Message-ID: <f05f6de8-121e-4897-9a0f-f9bf9edaae4e@huaweicloud.com>
Date: Tue, 29 Sep 2026 16:35:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] mm/truncate: fix data loss when truncating
 straddling large folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928144901.83cc90357c9a488e94fd6785@linux-foundation.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260928144901.83cc90357c9a488e94fd6785@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXdCdGeLtqQxpoCA--.31456S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4xXF1xXFW5Jr15Kr1DGFg_yoW5ZF1rpF
	W3Was8Kr4kGws7Cr1xZF4UWw1rtay3XrWDAFy5G3Z7CFsagr1IkFWftw10gFWUGrs7Cw10
	9r4jv398u3Z8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jxCztUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Stat-Signature: ku57ngpaypo9qmmfo1epgp5j1q35qgew
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 272904000A
X-HE-Tag: 1790670928-94363
X-HE-Meta: U2FsdGVkX19cE3oeeXATAZUpUjmrzwVeRuWNCn6IQTdGxRs2by3dQKuPdXlkcw5WluMiaxLyPgNV8cblH3eJvsLVZ+drnmtzq2mCcdE1yQZOFIo9Ycsw9DfH78NFJ0RHsCH62c44OvbHtCixBxDWu/XxTGDn+ZIX5/tkS3cE63MO6p2jwBr4RnYcKD2j8qA5hhN84xLOEVjbvB26n2LD4UNnYUCkXXMeqnhC8AtelFLhthIEzIo1ljdPPyrKki/Pv9fhbbkw25KHpWyna/HRaOJKjrSZ7fZfesQy4kk2aSlMSwU2UtkyofiBVHvQ4b+kGu3aPkQ25RBZPByEGeOpjfLm6s2pPOYj9nOii/OpelnhJ0RV6CzI2QtYsOety3s255VJsyjz56JOG0JyKJBb8cQEMa0PmQ+OvDd434xrXAqO+VD9fSYgcE2pxEtT1Dpa4i4vxA0CanP3q7dF4jA9CATEiCF7ExHbjsaDinopM8KCSK28aY7Cc+dKL69rmldqmRuECC5p+eTunEJkbLEGo6NN7gX2UkmSdTaK5jJ/BMY/dmDci+h5tyUz+wS+DbGFpFyc0/YTTDPR/l/nn7Wh6+DJZoFqM1OfCtNxNLG30KEyOBy3V50VlJU9Qw4D6Cf3OQCsidY4nsq80nJfV0OhuhOwFqM/EFrzMdigvD+Y0Z4BfXE05W9JN2r5imwdHIXPikknmAEVd4HbFDRRNEDRfEteRftOpCSKfdrhAhYhILJUdlsncPztPetSMqmy09hpjJ5IeVkjhX6h8LV/YEZhsnHNmJTkEDDJAWBUYf/ZNl/fTFhNu+fuAo3S/wncyPkqweEdzWuss0N+GqGtbOiJhmrhf4gtub+TGbdHWfnW2Q/m2N1s7Y6dhxQY4XJ015izueWz5sedEgE6AgeYX0CNzWPQZrvi78/rf1x646ki2OHmbYnnWG8CL8McsH5Sn3Q5kxkOUFygQlQpFXRue6I
 wcN4ecGs
 yZZzUCjRuXPEcRDx0WUMN4SslSlAnHB7mOuBm+aqOXUbgFAjeGNpINSioU5/k66kNZAnHCQo5Acw86CrwVnXtm46QE1DotUW/NzUhuvNYBILGwNLChYPqiITu6HXwlP9RaczX+CdmSpwf/ISiI/ebqgSm0JWUI2wnmIqXl2GUrmynRBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/2026 5:49 AM, Andrew Morton wrote:
> On Mon, 28 Sep 2026 20:08:29 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:
> 
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> Hello,
>>
>> This is the fifth version fixing data loss when truncating straddling
>> large folios caught on the upcomming ext4 + iomap buffered I/O
>> conversion.
> 
> Thanks.
> 
>> When truncate_inode_pages_range() punches a hole or truncates a file,
>> truncate_inode_partial_folio() splits a large folio so that the caller
>> can drop the in-range sub-folios while keeping the out-of-range tail
>> intact.  This series fixes three distinct problems in that path that
>> can each lose the valid out-of-range tail of a straddling folio, plus a
>> follow-up that clarifies the return value semantics.
>>
>> Patch 01 aligns the truncation boundaries inwards to the mapping minimum
>> folio order in truncate_inode_pages_range().  With a non-zero min_order,
>> folio_split() stops at min_order instead of order 0, so a boundary
>> computed at page granularity can land inside a min-order-aligned
>> sub-folio and the truncate loop drops that whole chunk, valid tail
>> included, causing data loss.
>>
>> Patch 02 looks the end-edge straddler up by its page index through
>> __filemap_get_folio() in truncate_inode_partial_folio().  After the
>> first split the straddler is unlocked and only transiently ref'd in the
>> page cache, so the page pointer derived from the original folio can be
>> freed and reallocated as a different folio in the same mapping, and the
>> mapping check cannot catch it, which may cause incorrect splitting and
>> potential data loss.
>>
>> Patch 03 reworks the contract between truncate_inode_partial_folio() and
>> its callers.  If the second split of the straddler fails, the function
>> reported success unconditionally, and the leftover incorrect end
>> position could cause the truncate loop to drop that valid tail.  After
>> rework, it tells the caller the exact page range safe to discard via new
>> pstart/pend out-parameters, so the truncate loop never touches a
>> straddling folio that still holds valid out-of-range data.
>>
>> Patch 04 clarifies the return value semantics to "at least one split
>> succeeded", which is all the shmem caller needs to decide whether to
>> reset its scan loop.
>>
>> The second patch fixes a pre-existing race issue that is reachable
>> today, so it is Cc'd to stable.  Patches 01 and 03 require a dirty large
>> folio that carries no filesystem private data, so they are not reachable
>> on current filesystems.  They were found while developing the upcoming
>> ext4 iomap buffered I/O path. [1]
> 
> Can you confirm that [2/4] will work correctly when backported into
> -stable kernels?  That is has no dependency on the other three?
> 

I confirmed the 6.18 and 7.2 versions that need to be backport. The 7.2
version applies cleanly, and the 6.18 version also applies smoothly with
only minor adaptation.

From a code analysis perspective, I did not find any obvious issues.
After merging both versions, I ran local xfstests on ext4, LTP, and mm
self tests, and did not find any regressions, so I believe it works
correctly.

Cheers,
Yi.



