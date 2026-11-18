Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855F2606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rfZ0hfVU
Received: by kanga.kvack.org (Postfix)
	id AE86E6B05B9; Wed, 18 Nov 2026 05:14:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF746B05BA; Wed, 18 Nov 2026 05:14:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5496B05BB; Wed, 18 Nov 2026 05:14:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8520F6B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:14:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FE181606D1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:14:00 +0000 (UTC)
X-FDA: 85447829040.17.E978BF4
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDE1F140002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:13:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rfZ0hfVU;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794996838;
	b=EnDwHd3wW9dEwSq8j641StE7QKVkYOzOCn3qbDssbP9ZVtgAP5h5g2G4pTUGCECSQBA2Az
	5fNlk9nwW7j67XZ846Q5237Cb5FXcIwbQeVi203klZ67NVSruXRgLiXe3iTq0aWZ+GWZzY
	HpBEpBs75gd3Mm2ObZ4BtYyPlbtlJbw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rfZ0hfVU;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794996838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gt+mGhyacKtik+zhBd0qIAApd6LUeQdQWtl+tJU7pFQ=;
	b=GPlz3TExybqVb2ri403MYD0tXXvZYLYGEtvG+yAWkGAxvlCbZzoNQ2PQPH4WASJtpnCpRa
	3Zf3+AAiW6gX0sgvM1wwE6AH7DGL1kFGw6/FbHWxAfOlX78c/EK4ciHS39fY9Y126nr5Zu
	j7CK/iDV4eQy5/p0Nq6QGiCCTktI4MU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794996832; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gt+mGhyacKtik+zhBd0qIAApd6LUeQdQWtl+tJU7pFQ=;
	b=rfZ0hfVU4wDJPmcqh7zASCYp2T8O+3h8mhB3LNJ7HHhUkhEe6Cp/iPUfZiVfvkJUifaawSx64Z1pkeCtOJ9rQ9DADNteOiM406F6K9wgh3q+nzC2pOVqVVReS4aZC/mJldwdvjrQyohHzZzbNCw7icdwQK7MZKBrp3Mrwc2MNsE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XF0Q23H_1794996831;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XF0Q23H_1794996831 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 18:13:52 +0800
Message-ID: <62b07884-afca-4f81-9b22-b4f890ed68c6@linux.alibaba.com>
Date: Wed, 18 Nov 2026 18:13:51 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: limit forced anonymous shmem huge orders to
 MAX_PAGECACHE_ORDER
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jingyi Sun <1045704958@qq.com>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>
References: <tencent_FCBAE9157D42FFF00E681A2D5EA72CEEDF08@qq.com>
 <29bca989-c3ce-4995-ab1f-1e2c49b93e48@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <29bca989-c3ce-4995-ab1f-1e2c49b93e48@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDE1F140002
X-Stat-Signature: hwywnu9itq6h847iaiinpj37p8yp744c
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794996836-876757
X-HE-Meta: U2FsdGVkX18vpDInBggYDTUyIVK1UHLK2q6dS06eG9bs64AQumzxuNyOIQb1jXhef3fRR2JBkLq7Hm2gPGcSMAjzNVGWfm2Ir1zDyKd194oGjBzDr/8jvoJzpQNku4zUV6KoGY70KCDjIZIHB7P+HJZyex+ygvdR5wUHHbl8nMcw/U7LqGKxMgHI7m4AKje+45duZ6ADz6ep5caLvIy9b1YUkQA1/eteyrrwhE4Y6xwzV1isf9zujZnt7Re/IUnEB2Tvvl56YkZkGUiwDUwmizWvjS7ueYL8YMxwrpr6LgPHRxO1fPOiJcW+E/3YmTTEttxu7u1rNWcgmUloERNY5Or/1FNAojkj3cXVW5xjxCYwmADbsUL8wXj3rtGziiVfErsw5O9n5Bi1yx2/Lpy8N/73ku0DFarhPcc4xjO8gtVBY6U90z3HhHdzujb9bKq3D8vRn8GGjExSUwWMFfpP80413UHuh0asbX6Mg9KKw0Dv9bCqvJGeeBd4tp24i6jtD2mxKIQif9x2pvBVuY5Y6sqMSVOnj66f6yUW16hSmVu05F7fUIFasbVhfTpux8/4SBUyxVGZ1rpj2a4f9wDLb3wvIqKAWR7LyO0RuTkCUcjt0YnSDznsilvGkDOJHa4Dy+So7fwGQVAQ5LeolgwZOp44IY/PvKd0Euo/hR3LqwdG0/KuEAohxhRg2c+U7YaZRqmUQcwg81q2qAKWA8mGRFXkrhHYZ2XwmKm8gA4HZ9Jid+FH1XWtYOozZb4gzTcl9wles0NZoe389JtPQ8Oz6sE3rA42enry2Il09jsYlAUIvJBh6yb+F1mBc5fzHSnXDnco29F6chfhNlVAAih4tosmmazJUtWw6+q0B5MVps0Mzwrjbp8f5GOAHEFi/FhEjLjcw04K0bu6YattgdWnwoZRUnm+7aXaKf+1SRzx3EbMSQRjZ6GzdTGSvFso0nW/Tg/WHj23lpf2G3dD7sK
 V5mzVp2q
 9Q7EWyz+n7mkVnAMvPtqwm5Go3BmdEZPP2ZGLLfKxzA+2XOlburKvdd+y/SbZDNgu90/nysPzhxt5DuFN3IojucGm+N+2cX+uaEk5l7y0/WSfIOfOqGW9R2FlGvlFePXO7/RTaw7AJzl3mXiQtvE4VfYXAn9H09Hw2xHGWilmuZFnEDiaZFaLNJ7xa/+IievyXcI5CUly8aGXUxrv77WcIJEo2Lm1aptNP1DznP3lalaznNqfVdpjytGZiB/l7LRGfwI5I1oCiey3vVGgMAjl4Mud6cXA0yXJCRSg0O3XGkRttKOkOnhaoLWoyR77S3fLOsc2nery75isMffMOLYj4/vhhYSMF3vpJpdu8/40DbWFiuliS/lapucLtkaXdU430BztQOOZnbl6u0dtsamlVd76gW5CbMb2D1bA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/18/26 5:31 PM, David Hildenbrand (Arm) wrote:
> On 11/18/26 03:45, Jingyi Sun wrote:
>> When the top-level shmem_enabled knob is set to "force",
>> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
>> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
>> unlike the other return path at the end of the same function.
>>
>> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
>> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
>> is 11 because of the xarray split limit. With shmem_enabled=force, an
>> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
>> in the page cache. Splitting it later, e.g. on swap-out from
>> shmem_writeout(), triggers
>>
>>    WARNING: lib/xarray.c:1051 at xas_split_alloc
>>
>> and the split fails, so the folio can never be swapped out.
>>
>> This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
>> PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
>> avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
>> fixed for the other paths; the force branch was left out. Mask it with
>> THP_ORDERS_ALL_FILE_DEFAULT as well.
>>
>> Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
>> 4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
>> MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
>> PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
>> triggered the warning above in 3/3 runs. With this change: 0/3.
>> shmem_enabled=always and 4K pages did not show the warning. The code is
>> unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
>> re-run on those trees.
>>
>> The issue was found with a research static analyzer for
>> cross-architecture dependency bugs and confirmed with the QEMU
>> reproducer described above.
>>
>> Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
>> Cc: stable@vger.kernel.org
>> Cc: Luiz Capitulino <luizcap@redhat.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Jingyi Sun <1045704958@qq.com>
>> ---
>> Changes in v2:
>> - Dropped the Assisted-by tag (Baolin).
>> - Collected Reviewed-by from Baolin.
>> - Dropped the note about the overlap with Luiz's mTHP series; Luiz
>>    confirmed his series will land after this patch.
>>
>> v1: https://lore.kernel.org/all/20261117121626.1058-1-1045704958@qq.com/
>>
>>   mm/shmem.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 10cef89b00b0..41bb3f2c6b63 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2114,7 +2114,8 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>>   	 */
>>   	if (shmem_huge == SHMEM_HUGE_FORCE)
>> -		return READ_ONCE(huge_shmem_orders_inherit);
>> +		return THP_ORDERS_ALL_FILE_DEFAULT &
>> +		       READ_ONCE(huge_shmem_orders_inherit);
> 
> could we instead set
> 
> 	mask = READ_ONCE(huge_shmem_orders_inherit);
> 
> And sue a goto to the end of the function  where we have
> 
> 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
> 
> Avoiding the goto means more churn I guess.

Yes. This fix seems more simple, but no strong opinion on this:) .

