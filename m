Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A84DC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678036B008C; Fri, 11 Sep 2026 05:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F806B009E; Fri, 11 Sep 2026 05:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565686B009F; Fri, 11 Sep 2026 05:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24E666B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:26:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A00BB4017B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:26:41 +0000 (UTC)
X-FDA: 85200951402.17.21DE0C3
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3A3794000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:26:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789118799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5sOXD4hajZcuR2cWxiu5Bs+KZV4SmEW/kTg35wzvpj8=;
	b=fN7xIdB5UpkEjW8NyOVuYXRv22MZwUop5gGqZXVGX6kBNEJYDxyMTSKRK5ZC3sWlEgYKXY
	0tpHRBCkhmgFDaXgeF6juJVE32e1xL1pLiuQdLzdcmoLInlS+UrTS2j/RLhyfyYp5nVE2G
	qTGcOJl74KJlB0EIon/8+nyGLJI/CZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789118799;
	b=L3RQtjZhtC/yZHQwrytd1tHBbsItTkPK11lwWC5YRKI7oliA+OizxAGtALV3ueC5A1rssL
	G5MoyZKIrwY9r7yQ2xreXjjsadYYgAd2+pT3JISkEKBhefw/BYh2L2iUPwVXXhFxx244ku
	IiaxW8YCGClloJ25k2ARID7aj1EUiz4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hh8LT30wNzKHMQS
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:26:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 64E754058F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:26:31 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBnUAtFyaNqHzI8Bg--.45614S3;
	Fri, 11 Sep 2026 17:26:31 +0800 (CST)
Message-ID: <4fe4a9df-7e1f-4dc5-a3db-8d2ccc4b924f@huaweicloud.com>
Date: Fri, 11 Sep 2026 17:26:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <6F18C9FE-3599-4C6E-99F9-767BD7AC8E3B@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <6F18C9FE-3599-4C6E-99F9-767BD7AC8E3B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBnUAtFyaNqHzI8Bg--.45614S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWFyrZw4xKFW5GFW5Ww1xXwb_yoWrur43pF
	W2gasIyFZ7J3yvkr4vva18Xw1Fqay7Xa1UAF93G392k3Z0qr1IkFy7t3W8u398Krn7Jw10
	q3WjvFWDW3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	4xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8mb3hnckr79kj3jc6s8siejq34wcn5uy
X-Rspamd-Queue-Id: 3A3794000A
X-HE-Tag: 1789118797-229946
X-HE-Meta: U2FsdGVkX1/n9TYoFU7vwFlYER+5npCn+gZZdG56mL4U0QO7cUMlBgKICgGcpIuQlr4UlOjqIhSuPoovINQnH0ynKpTcHQz8JRHOg44cZgDjN2kFK8GpMKGTwxC50wc4qORIHPMsDk5gNRGzYz4V4XoNnvflNAszR5nYpHLy/D3VW5aLEZDLECgB6/AyaaVm3U9D8ijmIl7MjGve2Nub/tU9w66M49w6dG50ZoKTa0nhOkwyWHYXlc66nI4alBg5IjsrTucMteQOIYjuuPvLzsET14823pIojfO2iBQavohNlfhv+KNJIOm7Sr2DZWQMat1NJs46z963MliGKoCSccE5g1NR22skp2WQYXqP33t3VSuoGVT+ni8GgluZPKFRNvhZ3BLH1E8pFgJGS8Y0p0gxYJKzti4OH5nvidg8IZzylDiTnNLbJ2prEpCpA17yuJ2ZGbItvpH/jFNCizREScQ3hANFrh6XZpCpslXug2/ydCAEAhjiH0OlsjwxeclMd8eIkNfCKHP37KaU3NwwCR1jMjqvZqTJMwz9chIIw4CLxtrEg+RI4mE/Y0xT4XlG7L++wqNM59UU3GTr+hy83yDsKPNveXcsIUZtir0bXYL8tMmvrinMnpWGgY/8o15ViJC3WhrpZ5sYAsvpkrL66PnVUnDpnRuzPjse0M7t6rhuJvQNnH3IVjcgcdWq/0gGFitrsfiX8cJH3ppw/zYccnHrPn8/2qtMVGwf03VHR798CcQ3t4yga/sb2nS6j3k7z5GYUwcenypkc2biwYw/cdapeJmxDQzv8z+9km4xcJe0ZzKxkZrBCh/38rPJcipQzCLjCc5dLMkSmQVF1S4ABMhYGHZQMW31Wo0duUsANyMtzq5pFlKO2jQ7rMfx/4ER5UabRl/nNraWZtyKE0Zwms8gVLwO6I20H4J3MTYuui7pJnw3q6NsquI/09A3kKE9glllGxCKjIIKPwPhIED
 UC4O1Tvm
 epKutMamw6uv8GNFCvPdrxpcay0Gg++kZLwngo358vfp/QcWoT7mZ6aL3K2NzyRKaRQCqg1jm51c/eu/beoKTgRAwT2hlfl1p3eZM3VW3/fYF38A7CDBOERcH4g4wRdO1zxoijRlEolSuzEqJDyuE9r+bYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/2026 3:18 AM, Zi Yan wrote:
> On 9 Sep 2026, at 2:23, Zhang Yi wrote:
> 
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio == true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end = 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
> 
> Thank you for fixing it.
> 
>>
>> In addition, even when both splits succeed, data can still be lost when
>> the mapping's minimum folio order (min_order) is non-zero. folio_split()
>> stops at min_order instead of order 0, so the sub-folio containing a
>> split point stays aligned to 1 << min_order rather than to a page. The
>> original success path left start at the page-aligned head of the range
>> and set end to the exact page index of the end edge, neither of which is
>> a folio boundary in general. Either one could land inside the large
>> folio at its edge, and the truncate loop would drop that straddling
>> folio together with its valid out-of-range tail.
>>
>> For example, a 64K (order-4) folio with min_order = 2 punched from
>> offset 0 to 36K:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()        # same_folio == true
>>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>>       end = p9                           # BUG: p9 inside [p8-p11]
>>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
> 
> Should min_order > 0 fix come as a separate patch first? min_order>0
> was introduced by commit e220917fa5077 ("mm: split a folio in minimum
> folio order chunks") and it is before folio_split(). The old
> split_huge_page_to_list_to_order() can cause a similar issue?
> 

Indeed, the min_order issue is a separate problem, and we should fix
it in a separate patch.

> 
> <snip>
> 
>>     i.e. the pages wholly within the range and safe to discard. They are
>>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>>     order so they always fall on a folio boundary.
> 
> Basically, to fix min_order issue alone, truncate_inode_partial_folio()
> needs to align pstart and pend to 1UL << min_order?
> 
> 

Yes, fixing the min_order issue separately amounts to aligning pstart
and pend to 1UL << min_order, so they need to be exported first.
Otherwise the same alignment would have to be done in the two callers,
truncate_inode_pages_range() / shmem_undo_range(). I can rework
truncate_inode_partial_folio() to export these two parameters first, and
then split out a separate patch for the min_order fix.

Thanks,
Yi.





