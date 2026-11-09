Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0CD606D819
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=qrhop0Mo
Received: by kanga.kvack.org (Postfix)
	id 9A3F66B05C2; Mon,  9 Nov 2026 06:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955176B05C3; Mon,  9 Nov 2026 06:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845276B05C4; Mon,  9 Nov 2026 06:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 511226B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:29:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D612F160638
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:29:22 +0000 (UTC)
X-FDA: 85415359764.18.44BEC5B
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E150120009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:29:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qrhop0Mo;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794223761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNIQPzmiHA+Cn4QbV05J8JBQ0a9SblQ7mMLGrBWZZV8=;
	b=HJZkQbyhCz55EwNvt2+w9q8FJc+PEQyTpVxTFURq/6gQraq00LSSTeOhf7dfjHxhRHE3Dz
	Gp+qeKvufAvHnWwRIFMyqhw9lQ0wDxXWnsIHPyR/WWHBxldavTqfQpbr/geU2JJG72f6eu
	z1cdng9hUJ5k4S7P4JcFg1e3vxTDs/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794223761;
	b=6Mjx9V1LoLi0vWKn1ZlHhoRS6WrIBLdjB7ZabiGtPIv+v0kLMWVd9hjEeDLoaDCgw5YApN
	7e9X4NhBxSMFcXyiDFs3GgBzWsiSCWhRVV3eAydm87K855V7+6M//tCyxQUhbzcthyuZ3d
	H25N+F/LD8s4YM25WDy6te5jJJ63PUY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qrhop0Mo;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iNIQPzmiHA+Cn4QbV05J8JBQ0a9SblQ7mMLGrBWZZV8=;
	b=qrhop0MopnJVqAeskNwKNdYuRqPtbihLXMLRYIvTQfbbKX4d3ZoxmOtC3A3uAe98KjQWlk3yG
	xZLWHWKjPTsN97vIoeLnnNeAN1zOfV7Tvm2k3+yivN1NceqcDzNFEnRup/D6Lq8ZB5U/mnBS8kO
	a72qU2TTcukkQfRT4927994=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jNSGg5qBzz1cySJ;
	Mon,  9 Nov 2026 19:28:59 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 1941F40586;
	Mon,  9 Nov 2026 19:29:14 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 19:29:12 +0800
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Andrew Morton <akpm@linux-foundation.org>, <mt4022@columbia.edu>
CC: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>, Muchun
 Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tz2294@columbia.edu>,
	<stable@vger.kernel.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <20261106143914.16a42b8cdf7436d045b85aa6@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <82a31bee-983e-bd22-a162-7c708c8ad475@huawei.com>
Date: Mon, 9 Nov 2026 19:29:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261106143914.16a42b8cdf7436d045b85aa6@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: uofbtrmx4jsiejo81apir681an6db19k
X-Rspamd-Queue-Id: 5E150120009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794223758-944814
X-HE-Meta: U2FsdGVkX185ONy5OFDfjkoHakSIktHqTIsTTvYZ0dlc8Py/p3g6DttcTgCzBjIug0xv1zm2nXPbqC7sZLu9scaBQMcel+h2YWwpyHNPiEt/Z0D4tPIZwlq/z3Yq0IBNNyuEqOmWZR114CnoHH5+9flM4/TpjoIzAQepMiL8YcxO76Nt2j19fuItrmfxhllpJZ3aD3pZ/D4+AS/qZrWkZyKUhOB2xs3dWI5skHAP8/CMABquvGHC+59osovg9mdKM+EEj4uJTNw2MSWtXXxaJPzu3WL248Fqe2qj0dA+zP9pZ84fShEztb/Lqvz/8HAOoXWP4YmeNPnbxxOdPblnImZRUe9BtEuI/y0qYqcOkb6Muc1ZycbaVrZtFbZMGYXBZNioVEu+LfVmHEIJPdsBuSW2/9Y3TmD7oEujRrVpF+MNZPvXqiTjLTSvORllm0oCSucrDGMZuG55ZFqkIjt8/sOgANXXtDHKX0EBVHmqucO3ht6p1U1gJnpYJcv9VB0cyJJaXwv09M1f3GQ1L5bQGizDuBnpOMgI50rPWeP18JdbLhZ7Ylx9p4wJvQdCTepbKhjGbNx/jOtkfN669urmIdXzMcqltkSEO/HMrl3i4PIN07bQrSyMMrz6Jx1LBl7TgAZTOqVCKpbl0PmZ2aIFNuJCzPfMA4FwMAYNn6gGKsBsLyGpz+2qVL8u+3F3DyfYK+gYOGL82zk9yVZ++pTsb8wostKMPqsFvsnWlid1ox+qK56Vp9Fyfw7Xvwaphdywd6EF5ps8+JmQ28+S/wGMhmH4nIARR18T3LDUjc3b45PJoqa1skyX/XF/pED4w9ZK7YrqdqrGgxV/HNt2xEaWd2k9WF4SY2pT2kULo75dHyJiM/jJUXBsQQs6E/qgkWfAJAQyhViPKt7jAudPyMF7LAc+NeyAlPSiTLmsUwK4Qqshbu4P9zmZQlLjE9Qb6k4om0JJhTDBzDOLnR/vdxG
 p2+Ntril
 VGNWtG1heda9TS4E2JzJUZkq+B38/tD2wB570cukew+Ouus/g5Nz0hp1KX9win4u1FADUICO9kRwhkDrTWLN3OSouSiQ9I8zSGHzS1iCMsu+KBjI87mHebiKen0Ke/BEenltzthxu2WqLlIQ+CFSXrJpjvolqxmLNcnKVN2xUfJ3GK5IodC+NrVVdURS3KpDeKGVj7Npx6ifTkxqAnwJfcUuLcAZDfd3oXMRYfIiJM4ltZ5oDNl2R2sONRBIqACz5cRAAV55uMVkTYV0V9bvjoTPzSMFcwaWGWflXlvyGjlOW+/4vpW3ujT4g95Vi7iugoFlJGhqqhKZgNn6xMJTtLG0GpPvyii2JKWMarJIEUXUq9N/whaTYrYFmIHIOZgGJnFRnoxdh6yxImGi2EOD5FopBkLAsOWEJsf5zjqwByh3N9XopA6dqpz9VencbF7vk1JX9s9BF3doG0BwoWkSNn2jVwlLpzgkKUUc2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/7 6:39, Andrew Morton wrote:
> On Fri, 06 Nov 2026 11:09:50 -0500 Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org> wrote:
> 
>> From: Mani Tofigh <mt4022@columbia.edu>
>>
>> memory_failure() checks under hugetlb_lock that the page isn't part of
>> a hugetlb folio and sets PG_hwpoison only after dropping the lock.  The
>> page can become a tail page of a new hugetlb folio in the meantime.
>> With hugetlb_free_vmemmap=on its struct page then lives in the tail
>> page that all such folios in the zone share, so the flag lands on tail
>> pages of every one of them:
>>
>>   Task A (memory_failure)              Task B (nr_hugepages write)
>>   get_huge_page_for_hwpoison()
>>     /* P not hugetlb */
>>                                        alloc_fresh_hugetlb_folio()
>>                                          /* P becomes a tail page */
>>                                          hugetlb_vmemmap_optimize_folio()
>>                                            /* P's struct page now in
>>                                               the shared tail page */
>>   TestSetPageHWPoison(P)
>>
>> The error on P itself is ignored, while healthy pages of other folios
>> stay marked and are never reused once their folio is freed.  After
>> freeing the pool, /proc/kpageflags shows them as hwpoisoned.
>>
>> This is the allocation side of the race that commit 32c877191e02
>> ("hugetlb: do not clear hugetlb dtor until allocating vmemmap") fixed
>> for freeing.
>>
>> Set the hugetlb flag of a new folio under hugetlb_lock and set
>> PG_hwpoison of a non-hugetlb page inside the locked check, so that the
>> vmemmap can't be optimized in between.  The retry path clears it under
>> the same lock, unless the page has become part of a hugetlb folio in
>> the meantime and its struct page isn't in the first vmemmap page of the
>> folio, which HVO doesn't share.  The retry then knows the flag is its
>> own.  With the fix, no healthy page gets marked anymore.
>>
>> This bug was identified and confirmed with the help of a deterministic
>> hypervisor currently under development.  The C reproducer below however
>> hits it within about 35s.
> 
> Thanks.
> 
> So as I understand it, if a single 4k page turns bad at just the right
> time, we can mark a lot of healthy 4k pages as bad (hence lost until
> reboot) while the bad 4k page remains in use?  But that race is very
> unlikely?
> 
>> Fixes: f41f2ed43ca5 ("mm: hugetlb: free the vmemmap pages associated with each HugeTLB page")
>> Cc: stable@vger.kernel.org
> 
> I'm hoping we don't need to backport, because the race is so unlikely,
> the consequences aren't world-ending and the backporting story is
> messy.
> 
> But I don't think I'll get my hope, because the consequences of this
> race are worse in older kernels:
> 
> In 6.6.162 HVO maps shared tail metadata read-only, so the misplaced
> PG_hwpoison write can cause an oops.
> 
> Also in 6.6.162 memory_failure() still has a ClearPageHWPoison(p) in
> its PageCompound retry block so with HVO enabled and
> CONFIG_TRANSPARENT_HUGEPAGE=n, its compound retry can still reach
> read-only tail metadata.
> 
> Miaohe, wdyt?

Yes, even though the probability is very low, it can still happen, and
it may cause the kernel to crash or something like that, so I guess we
have to backport it.

Thanks both.
.


> 
> .
> 


