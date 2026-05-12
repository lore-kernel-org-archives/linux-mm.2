Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B83CCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12B86B0093; Tue, 12 May 2026 09:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAB96B0095; Tue, 12 May 2026 09:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27346B0096; Tue, 12 May 2026 09:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D08096B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:59:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0AB940500
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:59:39 +0000 (UTC)
X-FDA: 84758925678.17.4602AED
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04846140006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:59:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BZh00c5k;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjBHpnrtr7TLQ5ApPzHZqIHU3mdRNFOc4hxIvr8BBVw=;
	b=dNYq4Y75gyeU7p7L3tr3smYxx+Mcqd4NGyYt6F6jxqsJF6Iwr3LInz7IA2rCcd0OZqawhS
	Pi617dCN7m7YBi4tHEJT8upM10G53tfwvZEMpGK8JvUIAdYirstO3rEZeaGan8rFMjM592
	uon8NGdePwsFdNBJmzSoHuA/N5KKc4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594378; a=rsa-sha256;
	cv=none;
	b=OX2p+y++xWURUxaZA9gQIeQjbZXiql/BiJXHSi5s7ixCoy4aktbL9kRzMTOja24n2CCmxq
	FtqL6NRy7ITeqERLox9yNcjIpiSY+7eQ+wFkw2poo8lT3c3BrPoXdEc41MT+3w3HNuMp2w
	Xc60QHepunQi1dnjJQL05NqzGh+Do+4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BZh00c5k;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xjBHpnrtr7TLQ5ApPzHZqIHU3mdRNFOc4hxIvr8BBVw=;
	b=BZh00c5kQpek7iEJf+pa1l7R5vnaN0BHDZahQdoGUW2q8mJtx42R7I4CAjy3+YKGirlEmmH4I
	tem5nRl57aI+6No+0FGmkRDT2Q7zyI58mNmxRswVrE7OvmwTpw3DweyoNcdDsX0xTZX6f876k1N
	sEeCR90d1G6g1/V8mZfCZK0=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gFJ1n0nHnzpStD;
	Tue, 12 May 2026 21:52:29 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D04D40561;
	Tue, 12 May 2026 21:59:29 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 21:59:28 +0800
Message-ID: <618380f2-ea7b-4855-9dc5-d655dc30d5a7@huawei.com>
Date: Tue, 12 May 2026 21:59:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/vaddr: attempt per-vma lock during page table
 walk
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <sunnanyong@huawei.com>
References: <20260512013116.80435-1-sj@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260512013116.80435-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04846140006
X-Stat-Signature: ho3indcobxyo9jgsbno8ke63jojutyoe
X-Rspam-User: 
X-HE-Tag: 1778594376-100476
X-HE-Meta: U2FsdGVkX180vEPGnL2iR8+1baSQrtNglSfUZioHoRAgbvh7KVdma0F4ZoaIEsJVaC8FCsWYdqjre7yHWDQzEKD4mSwdUCTOG2HrPu5t/13aOR8QrBnVRJoDKWsXXULdKeG/pi+rxUSXXXwXJNaHLRIUcKlFofE4ktSOlPKKMbeJ/BkkDHKy/FnUuGBlROnNbel0a5twnp0aND7/f3VxFJg19giPAvkNLu7EdV5rIj7x/WP4v4+S7L1EhEljocf0i5A2WaaalPF4cFaeKNOT3woYSjxBZjtx0+He3FV3PMfsJ8PYxLaF7he0YfpTzKzXASor9O7gvDS4SVKZEM0m9ayZXq4e0hgkpQwJQEnRPkXoKQ8DtjVOq+wD2AqIkN0nSum/foTAVeTTTrj+WKGFRr+IBEdga/qBseDGceELDbvQROBmutcaH/VYFS2pCGAYRY0cj83+sD51DXhWtaJ7YT7IOIqdoaM8A4YYxATZEl5w0s2V57q0ADYqVLwihko93+1G3ziWSYfAKSSqIHX03Lrmhx0BIIm8gjaJepW/ThSKJvHQAzWsRRNs9OUj3xMKOOepGfpiXe0f/VvfHmB7B82ZsyrsqwYt6MiYdFxIZSRVpdczPk/E26pl37AZbdP7Hm77FFWyzhr+KoTYiSBl5txkwGl8R0EiLvT52BAP4l4NhFsWAZnpaz/+w0nJ9HcP9oJG0zcGJLaDjZ/tqvZ7pbJYWDSJsk2O5yrEuJwNHjSN6nFP0lagXYD9pa4Ivlnr63bE8up+RLdH56p+8wDsi07ljTfd6gSVMECZj+HWLz/r7SM/9iLbHNt1M9xiyneGBDBeI0jf2ou4xu+mN7vFrFA3MutcwMRcy9caIOqndFaAOVWiPE3OkudCPtDTqoxZbCGxDKtGc6+nm/nbVHmvMUi5wqoE9j7380G1WXPI/0G0tDG4o5i8TZKoy3sauQEGJLPkT0wZXOAcQ8h0/nj
 wUqJYSbF
 do/US0UUQQo+LA8KmwyTKadbX2Cl5gblH+/t5KYL4yAUcbrJHRhlQlV32nRbtze7ZOkb6mMKpYNK0Bo3pGSQ4Gw0M21uMf5BnqRIf2mHyR3054/1JpYUpTumT1l4POtlI1AHJ6HiE2vwgRIb3DXZQl6ETnKlbgQT7BPAJbzRCSuyfxJdMKCtW1UHR4QB8VHT81pgLkuMHN2Ed8MYudnn3dbMMly9P9yCTR0fBjmuLWdvE2/wTqoGgWWczUSbuMrTpSZYJM9esq9Mm8e6ODpZSb2tScvLsiFWWx5wA/HacrM2SOfLA5gQXMZ5JMlyK6eBkLktDYKDi14zpAYS3HYjmS9SwCcDpsiMWbhg0Pd6LzNvLgryRH3aV3/oy9J2+Q5rvJXKZxZFAmD8mpaiXcNV7DAamhajX3ABrbrzKCn88IPR3RcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/12/2026 9:31 AM, SeongJae Park wrote:
> On Mon, 11 May 2026 21:25:46 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
>> Currently, DAMON virtual address operations use mmap_read_lock
>> during page table walks, which can cause unnecessary contention
>> under high concurrency.
>>
>> Introduce damon_va_walk_page_range() to first attempt acquiring a
>> per-vma lock. If the VMA is found and the range is fully contained
>> within it, the page table walk proceeds with the per-vma lock
>> instead of mmap_read_lock.
>>
>> This optimization is particularly effective for damon_va_young()
>> and damon_va_mkold(), which are frequently called and typically
>> operate within a single VMA.
> 
> Makes sense.  Do you have some measurements?

In fact, I do not have performance-related tests.

> 
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Looks good to me.  Nonetheless, because I'm not familiar with per-vma locking,
> I'd like to wait for Sashiko review.
> 

Sashiko review reports a issue about handling VMAs with the VM_PFNMAP
flag inconsistently[1]，We indeed do not need to handle the vma of
VM_PFNMAP for damon, so a quick fix is as follows,

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index eed2ae132a58..d27147603564 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -251,8 +251,11 @@ static void damon_va_walk_page_range(struct 
mm_struct *mm, unsigned long start,
                 goto lock_mmap;
         }

-       ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
-       walk_page_range_vma(vma, start, end, ops, private);
+       if (!(vma->vm_flags & VM_PFNMAP)) {
+               ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
+               walk_page_range_vma(vma, start, end, ops, private);
+       }
+
         vma_end_read(vma);
         return;

Any more comments?

Thanks.

[1] 
https://sashiko.dev/#/patchset/20260511132546.1973270-1-wangkefeng.wang@huawei.com?part=1
> 
> Thanks,
> SJ
> 
> [...]
> 


