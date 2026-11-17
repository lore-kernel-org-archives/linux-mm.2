Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2AF5606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Fx5C7iqc
Received: by kanga.kvack.org (Postfix)
	id E09A56B05B1; Tue, 17 Nov 2026 02:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1FB6B05B2; Tue, 17 Nov 2026 02:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F976B05B3; Tue, 17 Nov 2026 02:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8DF56B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:01:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4579A0247
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:01:33 +0000 (UTC)
X-FDA: 85443715266.08.8EA3FFB
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6B2A54000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:01:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Fx5C7iqc;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794898892;
	b=hklsGrfSXYZSXYn1qbfBnvkNwMwBD7lpqEFE3v2+Kkc9q6+uHDRNuB6lsGEoXB6PyGRxMh
	t2Ldp3bEQ2M6HMxP1px069LNSoHxOphXTM6SKU+2KgRg+hgat+MVSKRkbbMRtw9XT1ll+f
	vr+UfivPeZ8LzgvIFZ8U4BG+DiP+1dM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794898891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYmHsFilcq9OxcsGtB5MNVtlBGzhtGT9OYVm7nlS3JU=;
	b=hwPTmr2NmGxCzG+ctg2LRZl9UQBjuphWqHvWLbWoyRnsJfuxGqE9IIySGOAbQW09vGkmAo
	b5DZOVCmqS0SwW2p+h2I5MRWwf2DNeIQH6VXTV1q69lYLXWwNEEx/V2gFvJ1zs6rLkroYc
	j5mP2xzNBl2Z4peHbNDqirfPikMSgyA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Fx5C7iqc;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kYmHsFilcq9OxcsGtB5MNVtlBGzhtGT9OYVm7nlS3JU=;
	b=Fx5C7iqca91BH76vbqFt8WHFsDvuTz0sjyHwxcjk/5uq4mW/eEAOTdVa8eivFFBDCI/KnDWeQ
	5CM1XndY4tJRCU+tsqiGa83SwxptJq4BsdWHW1uL4ThsoAxdOw5ibI8nZu9WT0snL8ERAGU7OSf
	5QqTNTAJ7ZZpjrCWO16GJwM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jTFxK5B7SzpStX;
	Tue, 17 Nov 2026 15:00:37 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id A68E640684;
	Tue, 17 Nov 2026 15:01:25 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 15:01:23 +0800
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Mani Tofigh <mt4022@columbia.edu>
CC: David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
 <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
Date: Tue, 17 Nov 2026 15:01:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Queue-Id: 6B2A54000A
X-Rspam-User:
X-Stat-Signature: zdiawrn9a38kk8ciajy4n56mq5q1dnnt
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794898890-369871
X-HE-Meta: U2FsdGVkX19Z84wWkVKQeqoac2SL+Hr8TEMTTUJ+BZ0wAyDzFeOdAO8ZXbguNBy/84KgNrr3x9pLzEbv0WF6LSRCLDg+R8cbQUWoXf+3yV0dTC+5mLMLgKGzhJ4MzpXoFaG3Y3I4hnwE/torNEHFV1gheAzqJUH1ONu7Z6mTTVa/Bp/H7OfxdoF/j61OumSJWaQJG8uNA6uj7FMIKvvQjXCYzT6jFrStfgDOlaOthB9NI/yCDo50A+VL1fPChSfqZtqprrSgktRtDPvbrGc4BCw+SjexzXxKlovw+Q+wXTjPunOOqb5kgDsiXXG77X8I6+e4PDz3sGAS1pNMQRNSh8MSw3hMJoMApmF5GMtVmd2Xzq7CVCQD6Kl5lS+z1TgBAA4utgpMs66XO4/282WV6k8iWS1/MLZ58/G+ixRBLDkdKvNUZz3Y7TQ8idP+M/5hvDxjlgBj1O9LsuIvRbin9dhVxHohrJsxVr4IEQRWLQCJo2Cb4+8MBITxo4dCn0j/YlrtPdlFCbf9cVHCQXk4M0ttCuXTNBUzNPX8hHzskG8p5EStpsHFQqbIPUPclut4F2cOa5uHsYP6NLs1JuiHlOh07SP5Tx0DHPWVKqHkPC5uM80bYvPj8rylVf91ip/STPmSFejohHMmVVyisaudwId+llVaqmi+wRxEEJtoYf9j4Dtn88FUt1JB9fwCSGygdX1q2Nz9Yt6zeKPJt8u6NZ3msqZnT+3i1iir9/nZGmOKKD1dmobizR2Jx7W3s5f0Iqkv7445ZrZyHcN+jYSaxhQM+p9OLsTsRaXxe/l4b6PG7YfYPC35gWHQbZ/eakRu5iKysK6QvCt0g6pvhGnNpiNhj3SNRlnXoqiuYMAsRM4HNA4a5etNpJqgj1NpyK3vXzTs61VjdIDRaE6/XzaHr+YASyYjm8EJG2Uu0RK8H3lxxrRQos3oiV1EhrU1ELrg0KMEwSBHvNCuDwpkc+F
 wGmNt7YD
 NmMhCaALA83XSSB0pOFuVhHGeKfXkMRiy9uymBmGzbqbRj3EUjTZHjJmNqs0fKZAMQfOzQftEbkHAspPZ0amYem+JMTSwK1D4S383G6RtIMDKe1cH0DXlxMYpZm4wVYbdXq9MnRfoGnWnkIYx2ak94/5zKrfFMJh2lZY0v9F1o2BZxWvW2/bffkZjOOD+1vZCniQ/RxgXpHqPdA9lzreCx0wIwmyW/JsOHmeDY+KOvdUnmTzrH2T86rCbKyyGdlbFPvBeYH1cMpVVGY/2Om5wnneSEJF0jiy0Y3rv8E7c1sOJ7C0jCaJDbPSRpWJXTB54nhVBjJ7SrZdvtAGXLJlLRd/M7Dwbq6IS8ycGvOkoUIc7M79rWn9lS3JSJsMh32QmWN7yNe/idoCTdyzCZus5KIK0mDW+7hZ7TLS82J0W0KdZUjW0RnwMiXDFljMlzOiJIj0aU13m5oObGMEOFZ/sqY6x2nGn3oTwjkK6EtOqdVsGISh4GSsjRIhDNzXYETaPXPYcMhnAZS32fR3mYBM8Jm9C2S9P0RHYzd2R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/12 7:21, Mani Tofigh wrote:
> On 11/9/26 2:23 AM, Miaohe Lin wrote:
>> I have no idea why the error on P itself is ignored, could you explain that?
> 
> 
> My bad, I should have explained that.  By then P is part of a hugetlb
> folio that's still free or being set up, so get_hwpoison_page() can't
> take it and we just end with "Ignored".  Nothing marks the folio, so
> the bad page goes back to the pool and gets handed out later.

I see. Thanks for explaining.

> 
> If the folio is already in use it's even worse... it gets split as a
> THP and hangs.  (That's a different race though, I'll send a separate fix for that soon.)
>> I think we should clear the PageHWPoison flag we just set since the retry path expects
>> we have cleared the PageHWPoison flag in the first round.
> 
> 
> Agreed, as long as the page still isn't hugetlb.  Once it is, HVO may
> have remapped its struct page, so the clear either hits the shared tail
> page (read-only on e.g. 6.6) or gets lost while HVO copies the first
> vmemmap page.

In both cases, will the hwpoison flag be lost? If so, would TestClearPageHWPoison work?

> 
> So how about clearing it under hugetlb_lock only if the page still isn't
> hugetlb, and otherwise skipping the retry like the second round does?

If the page becomes hugetlb, should we skip the retry path? try_memory_failure_hugetlb
can't handle this case?

> 
>> I suspect this won’t solve the problem. The below race might still exist:
>>
>>    Task A (memory_failure)              Task B (nr_hugepages write)
>>    get_huge_page_for_hwpoison()         alloc_fresh_hugetlb_folio()
>>      /* P not hugetlb */                  /* P becomes a tail page */
>>    clear_non_hugetlb_hwpoison
>>    goto retry
>>    get_huge_page_for_hwpoison()
>>      /* P not hugetlb */
>>                      __folio_set_hugetlb
>>                                           hugetlb_vmemmap_optimize_folio()
>>                                             /* P's struct page now in
>>                                                the shared tail page */
>>    TestSetPageHWPoison(P)
> 
> 
> I think that one's covered.  With the patch, the "not hugetlb" check and
> TestSetPageHWPoison() are under the same hugetlb_lock, and
> __folio_set_hugetlb() moves under hugetlb_lock too, before HVO.  So A
> either sees P as hugetlb, or the flag lands in P's OWN struct page
> before HVO gets to it.
> 
> Also, with Muchun's vmemmap_remap_rwsem [1] HVO waits for
> get_huge_page_for_hwpoison() anyway, so if his series goes in first the
> hugetlb.c part can go.

Yes, this should fix the race.

Thanks.
.


