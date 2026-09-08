Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F2EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E826A6B008A; Mon,  7 Sep 2026 22:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33266B008C; Mon,  7 Sep 2026 22:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48E46B0092; Mon,  7 Sep 2026 22:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B28046B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:07:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F55D8032C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:07:53 +0000 (UTC)
X-FDA: 85188959226.27.CE42D31
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7000040004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:07:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NEZsYN91;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788833271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6nLMZobpXuVKchXUNS23tGum4icRsXSVQvTC7oxSsEU=;
	b=lK6KRA7D+68azFQWi/yelnPaJSfbxvpbYfLNibIRCaLSRA/mgQcSQncxWcNeQ9wdzj4Lpd
	jLNudCCHJjhLYYF7TOExBSLA1U/I7sJchIIO7buKS1iY/OK48RBYvzz/vrecjFC8BNt6j+
	B3AlXSQnUl6K8nrTfCevQbGVHasbllo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NEZsYN91;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788833271;
	b=PmWC7zN2Fe0JNdZSBz1eR1f5H17onRoA8FhjoBLIa3OYaxPU+CQvSQ0mgDpOWXrWXORLvN
	A/b6EcFvNvOy//fZtAWWqEj+rFjLRUZFl+zfjgt6EJMrvES4+m+eRfh1h5VpyCT2Jxga5H
	fU+jkFV0gd2uCWM/4m/ckEGfMCZ0edU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6nLMZobpXuVKchXUNS23tGum4icRsXSVQvTC7oxSsEU=;
	b=NEZsYN917BiDC536e8wdcQUPC9LwKbcgFNEjQZnbzbIrckER8WkPsIObcIFkefleC2rcFZ9hg
	TLFyCk8XRDA0cRTtVZ5vceRT7RlqpupsX7oTz6gqky6+00vYhDamkzCpavhkT0lg0OfTMDssR6a
	m7kiKkCAWtBzmoIvcoIVrmc=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hf6W214wrzmV7C;
	Tue,  8 Sep 2026 09:56:46 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id D257F40572;
	Tue,  8 Sep 2026 10:07:39 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 8 Sep
 2026 10:07:38 +0800
Message-ID: <d5f6aab7-3901-4615-a237-c60cb4730244@huawei.com>
Date: Tue, 8 Sep 2026 10:07:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Lance Yang <lance.yang@linux.dev>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<riel@surriel.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<harry@kernel.org>, <jannh@google.com>, <minchan.kim@gmail.com>,
	<lwoodman@redhat.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <20260907124341.81999-1-lance.yang@linux.dev>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260907124341.81999-1-lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: qq169gyfz96o9cjwtzuw91xfew59htk3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7000040004
X-Rspam-User: 
X-HE-Tag: 1788833269-770139
X-HE-Meta: U2FsdGVkX1+fFa7ZcAQrj8CXNNi1tUISSPfZP4YzBB746xa/aCbmYNw1I1FzggthPaH+NbX2D8X/OOUOzPOJ2AahFIcNraBXPird6eNVk2UEv3li5weXW4CYWGB6sqSJBuzlAQJqlL/ScBK3FXIPZ1kxTDbK8CWY6kYPJzuue4ybwYnEprUGhbdzhdLPQ+/At2u3j4it7TRAPh0NAom0JS1DLNdMsbMVhmz0kWflOI8Dhofaxt+ECXmSY4XNDbGz1hTeaC51yz+L1INDsBw0LRLsKv1juzgWr4etHzQHO5T+T16AxmDunHj+NDqqBuUYsvjK6Dd/5mdgFofKreadKJC1PlivjJh3bWJ5lC/dWP3Svd2prFgmW65czi/bxL4UsGSBkNh4mQNoty4etAnBkerpjPd8hdrMLxOdkZlHyhlE3Z4lreY5U+yRZbJnAAozMAfF9mfjFIjJ/Xf5CWwmDqb7yCfK6YBN4WdPZD2BrUtQ8LNF1vlurtgrDlgCSKnpxDTl8Li7kQV9z2JgGfn2c+OdDmJWZn8fR5m/W3krrrONEdUpPvmmKTueMWwXd0pCr8STtN842tHoKEpOMI0mKX3FUp60HuSXpYr70qEmf1wEeKlB7bgcLBb3lQXdFJwsYqaHfyxPQVuDIpwnKLcJCDjrzVu3JjOvLGMc4GNbfFU8p/O33k25W8vn7FlESHHWY0arOC1BvYM/D541rDQ3Q5H0axHKO9gLtspNs8jBdTY4yOILjepAB0NIaqQYM+TBxAnEUR2rUyRb9sHVYEzAmhLgT/SBA8q3wSWkIVGS4+9PCswBv+MmlzpmNVLYy9nuv4X1Z6NYZDcLXqjnpftD98t6ASgFin0/IyTjbufdqPRNCGg68rx+APPAtMJq7i+e9tPxfAtHqhc4I9RIWZjQxYMqYSmuHt2tpbTx6T8j4ATFEviD9PloxGd3RCjzk6YpID14yWHPRE/f+B1BSRa
 ThW/fO+B
 0iYRaZVlB9tEBTFhV0ZCRUI/Q6zD5tLJXINU8Rd9pGOvPImUyni673UMq7Vq6J+gGjr4km4E0S8iXDl9FD+YPgHhftmcbFcb0Rvt8PPuLGGSxINTWnaBazFMCL9maEXd0MOD3chroZu5/fr46eKff73NhT2IkFrBZ33LpXZmSELDa3t2mka8cmbwOm68NRuUXotu6qclGGOzvQEin7wtNT/27gAdSwkUzj0Z6pmIMeNouTeDqTzRt10n7Z96+zASrmBikiOMYisLAfU7qs0M5pERrMyW3prWcyfSnZcTJSQBQocc90Tmy2KHUwSYclXHL5T7tSMhA3x6/uGLnjMKWNz1l3YQhoQ5HG43pgpDF1Uv9CJSjywv48PKQzmZzONnS3PEA9DNMJUzYx7LImpsyKl1M2fpE0di/NNO+Z73CeSkBTceHGqeaJKiN3J0qyWdjYOUoa32M9HaGSSCTJye4nTX6yTLAgpV0iyuY6EWIUjB1/EDyfMzgLcSr5HZD45pSptWx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/7 20:43, Lance Yang 写道:
> On Sat, Sep 05, 2026 at 02:18:19PM +0800, Jinjiang Tu wrote:
>> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
>> anon_vma->root is stale due to missing memory barrier, leading to
>> lock and unlock two different anon_vma->root, thus leading to a anon_vma
>> will never be unlocked, and another anon_vma couldn't be locked anymore.
>>
>> The race is as follows:
>>
>>     THREAD A                             THREAD B
>> __anon_vma_prepare                __anon_vma_prepare
>> anon_vma = anon_vma_alloc();
>> // writes may out of order here
>> vma->anon_vma = anon_vma;
>>                                    anon_vma = find_mergeable_anon_vma(vma);
>>                                    anon_vma_lock_write(anon_vma);
>>                                      // may still see the old root
>>                                      down_write(&anon_vma->root->rwsem);
>>                                    anon_vma_unlock_write(anon_vma);
>>                                      // see the new root, never unlock old
>>                                      up_write(&anon_vma->root->rwsem);
>>
>> thread A triggers page fault and calls __anon_vma_prepare() to prepare
>> anon_vma for the faulting vma. __anon_vma_prepare() allocates and
>> initializes a new anon_vma, and then publishes it to the vma with a plain
>> store. anon_vma_prepare() only requires the mmap_lock to be held for
>> reading, so two threads can fault on adjacent VMAs at the same time. While
>> thread A publishes a new anon_vma, thread B could finds the anon_vma via
>> find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.
>>
>> However, due to missing barrier, thread B can observe the published pointer
>> but a stale anon_vma->root because the stores from anon_vma_alloc() aren't
>> yet visible. What's the value of the stale anon_vma->root? __put_anon_vma()
>> doesn't clear anon_vma->root, so the root of the new allocated anon_vma
>> may point to a valid anon_vma.
>>
>> As a result, thread B can call anon_vma_lock_write() with the old root,
>> and call anon_vma_unlock_write() with the new root, leading to a anon_vma
>> will never be unlocked, and another anon_vma couldn't be locked anymore
>> (it's count is dropped from 0 to -1 due to wrong unlock).
>>
>> To fix it, change the plain store `vma->anon_vma = anon_vma` to store
>> release, so that the fields of anon_vma are visible before anon_vma is
>> published to vma->anon_vma.
>>
>> We don't need a read barrier at read side for thread B. The load of
>> anon_vma and anon_vma->root have address-dependency. According to
>> Documentation/memory-barriers.txt and some investigations, only Alpha
>> needs address-dependency barriers and it has been handled by READ_ONCE().
>>
>> This issue needs two adjacent VMAs aren't merged but are compatible for
>> anon_vma. We reproduced this issue in v5.10 with KSM enabled. The kernel
>> doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
>> merging for new VMAs"), so there are many adjacent VMAs that aren't merged
>> but are compatible for anon_vma.
>>
>> Without this fix, our production environment could reproduce this issue
>> about 2-5 times each month. After adding a smp_mb() before
>> anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
>> to this patch, this issue hasn't be reproduced for one month.
> Good catch, thanks!
>
>> Cc: stable@vger.kernel.org
>> Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
> Shouldn't the tag point to the following ?
>
> Fixes: 012f18004da3 ("mm: always lock the root (oldest) anon_vma")
>
> 5c341ee1dfc8 introduced anon_vma->root, but 012f18004da3 made the lock
> helpers dereference it. Before that, anon_vma_lock() used anon_vma->lock
> directly, so a stale root could not cause this lock/unlock mismatch.

Indeed, will update it in v2.

>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
> Hmm ... no luck reproducing this locally ... Still, AFAICT the race is
> real.
>
> For the read side, no extra barrier needed because the anon_vma->root
> dereference is address-dependent on the READ_ONCE() load, IIUC :)
>
>> mm/rmap.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d1819fd69938..a868e835eadb 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>> 	/* page_table_lock to protect against threads */
>> 	spin_lock(&mm->page_table_lock);
>> 	if (likely(!vma->anon_vma)) {
>> -		vma->anon_vma = anon_vma;
>> +		/*
>> +		 * The fields of anon_vma must be visible before anon_vma
>> +		 * is published to vma->anon_vma.
>> +		 */
> Maybe be more specific:
>
> /*
>   * Publish anon_vma only after ->root is visible, otherwise a
>   * concurrent fault may dereference a stale ->root when taking
>   * the rwsem.
>   */

Although other stale fields of anon_vma might not introduce issues,
the stale values are fragile anyway, so I teed not to emphasize ->root here.

> Otherwise, LGTM.
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks for review.

>
> Cheers, Lance

