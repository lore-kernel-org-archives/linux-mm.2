Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6956C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6921B6B008A; Mon,  7 Sep 2026 22:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642E16B008C; Mon,  7 Sep 2026 22:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B226B0092; Mon,  7 Sep 2026 22:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 292EC6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:48:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7DDAA037E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:48:40 +0000 (UTC)
X-FDA: 85189062000.26.6E17CDA
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A5CCA0009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:48:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DIh9o1KQ;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788835719;
	b=JS4lp7iUL6yMeL6OAg3qwV7YyhWRoZywcTv2sld/eeAiFYl80U2lm8x1E7zKdCTZUQ/KS0
	7fQuRHHBUz02FIgPQArWX6DOmL29qXGvhxN9O4TdbOgacM2PZMFK9wZhiPlrvPWT+Arc3+
	5MpEseq/hpIyQB171HFqBmiKrSstnhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=DIh9o1KQ;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788835719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zel0aLGbNXWGy5cEP/MPXsaLS2xFVPM02I6KCSXc3AY=;
	b=mHa87Ok6DYH6f0GWYX5tZBWDEzGAEwSl25yWdz5RKk4P3kRaNvUVaJ9+EnYnDju2BpzyWY
	5MrszLK6HNSgmKKLRs5ZZHgNnW+hDdanq76qbvYkAUrEiL8ApuK5q8otoTT/IqWUB6ljob
	FNf5Fui1D4HDC7csF3l/t29pSSo0G6k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Zel0aLGbNXWGy5cEP/MPXsaLS2xFVPM02I6KCSXc3AY=;
	b=DIh9o1KQA+vtOJBnoUDFDhR/2IB0hqZSWIWwVBbdE3alIsQk4A3RLvmBq72sIq7zkjMtjD/Ly
	lPYmfYzVBznAF+yl5eaOvpw1nxQnW49gkABG3Buz3ct8l66LKhnXKTBxlvPI9uZA48neW1toBtr
	+EjgAKA0Su/lj9LY/uE+acQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hf7Pn5Znqz12LHj;
	Tue,  8 Sep 2026 10:37:17 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id BF1BA4056E;
	Tue,  8 Sep 2026 10:48:30 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 8 Sep
 2026 10:48:29 +0800
Message-ID: <cb602c85-ad10-426b-8edd-cf9684c51749@huawei.com>
Date: Tue, 8 Sep 2026 10:48:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <riel@surriel.com>,
	<liam@infradead.org>, <vbabka@kernel.org>, <harry@kernel.org>,
	<jannh@google.com>, <lance.yang@linux.dev>, <minchan.kim@gmail.com>,
	<lwoodman@redhat.com>, <kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <ap6ybQeSg_rrmC95@gremlin>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <ap6ybQeSg_rrmC95@gremlin>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A5CCA0009
X-Stat-Signature: dw561xejg1e1g8m8agrfe3uqwin66zdn
X-Rspam-User: 
X-HE-Tag: 1788835717-100520
X-HE-Meta: U2FsdGVkX18um1njhQHGap57nVgi9FGP9etdKMx34O03tftJjO3uvi1+OipFcJEcwqccutocolI7gBYevbSqFsy59dV0Bt/GpuV/VvNTE2EWCe8i5eV9aB/ut0f841xgUfl7yFsunbfymNDJOq9y/Dq6FrlzJtzJ8Lde4Cmk9Z0i7nc7OFSrXxEOJHBgG1agowT5Os2QKymQYAxH9gJdKrya1gyBy0HzlcomZSC2OgFkhcw6xJsWFFe35jNagcaJo0R3jrPz1yrmCs6aAcSakucqNrUYpvhBZ9GLlYDQrGI59KG2pat0LidLaYQ6lKal9rc3j5hk+KpBTShzaYbE7WtHP7t6H/zsP8B8jki3SOFrlv2H2rxiSSSVvfpz44MyIK1u39wHckfrKTJom6a2VsjoRyd+wcZIyT4aCThmM1LS4ad9L88qAHXc8A7fr99X4qsxa3ltKsA9YGtKxdEd1PXVZtE7mc9jD2an9dWk0uI9onnwNpc6Y1MW55hcJ3dUw8hxVy/kDrkx+nqvDlo9vYFCtToyrWRKPaZb5NVY99x6BacFOQH7a0kjyLZJAr+mZL/xqbABW/V1wyhPy8TQIJ/b6OKorL/RbFl6+6iGG0iMWiHGyC4aC9JvFEBU/Kc0PvNoivhqldqHXQbSHqIThhFT6AmqB8g6wvU+e/7sAayKUIv390mfXLWxZKRgkoSp2nctKo4QpHak9SE5VjprVi5Rk5jCJy6xUzuyvdmxtnnAsQX8EDWa01ry6o3QL9m+pDVEo+6kmvmrd7DY0Aj0a9Q03Hb46ugRRdduKebpHbfN0LN2MOVPAIgViP80R3Laofk4Dbj1NfJDXWdKgsBfhLeROsvV6nsi/ZAmWDADlErEbGe8zXCb2fypyO/uFVLROSaXbRuoIv2tauygQf0ZtJjUWd9oarQ8gzhBnfDdMJkfvHdlwkptUhf5Nl/dhVYHzFeo1J2gPhN97w7nWfQ
 VkuQQL9y
 WLeAMgjqDpYyq2mHCfWsqNrmS+BTzBzKvqlDWrm6ep8LxN0hO/LTLofX+5OPvJA2uB7HoSYdbAJJQYr6NUf/sTM9eUsWk/GSjHzf5cTdq8umvMxT/gAXpYxCGdjH71/fchxs0IwvHqkHZfUm183oo1mat98s6nNsnHvjFKEpCS2ODGfxFHON7qVQzvdevAZ9M1ZvNYunLmDEHuSoKq5c1pV/bL3uJ9O0BqrO2X6ui2ececvB5rNb59LJt35svY5pVPiPm1XTcQKxwEeBFDP3+Qx04K8k2T5/kuoI12Y2Hr7wGS2E3+gPaUVXnBVe6tLzD2ls1L+ueFwK7pbgjbXZmfzWKgmf100tZKLxQWF4faJurCej+TCtf8mPOsKNJm77AftlIUJrKtYTrsClnBRHSPBl8DyOic64vIfy5nZxs+FyYsbV/msvvmG9hg9ccXZQzBQzLleOOPUsMo3t7OnkqfFleGs0ugxKYm1f7PHy53NqHZd1LWhcZxkDGMMpFSD4oRp93
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/7 21:52, Lorenzo Stoakes (ARM) 写道:
> Sorry, I looked at this on the weekend, then thought 'I should really not read
> kernel mail on the weekend' and abandoned my reply. :)
>
> On Sat, Sep 05, 2026 at 02:18:19PM +0800, Jinjiang Tu wrote:
>> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
>> anon_vma->root is stale due to missing memory barrier, leading to
>> lock and unlock two different anon_vma->root, thus leading to a anon_vma
>> will never be unlocked, and another anon_vma couldn't be locked anymore.
>>
>> The race is as follows:
>>
>>      THREAD A                             THREAD B
>> __anon_vma_prepare                __anon_vma_prepare
>>   anon_vma = anon_vma_alloc();
>>   // writes may out of order here
> -> may be.
>
>>   vma->anon_vma = anon_vma;
>>                                     anon_vma = find_mergeable_anon_vma(vma);
>>                                     anon_vma_lock_write(anon_vma);
>>                                       // may still see the old root
>>                                       down_write(&anon_vma->root->rwsem);
>>                                     anon_vma_unlock_write(anon_vma);
>>                                       // see the new root, never unlock old
>>                                       up_write(&anon_vma->root->rwsem);
> The left column is missing a lot of stuff I feel.
>
> I think you need to make it clearer that what's happening is that you have:
>
> 	|-----------||-----------|
> 	|   VMA A   ||   VMA B   |
> 	|-----------||-----------|
>
> Where VMA A and VMA B are merge compatible _except_ for a property that can
> be modified by mprotect() (i.e. fulfills criteria of
> anon_vma_compatible()).
>
> There are racing faults on each.
>
> Now VMA A has already tried calling find_mergeable_anon_vma(), which
> checked VMA B for merge compatbility and found it was not, yet, faulted in.
>
> Since:
>
> static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
> 					  struct vm_area_struct *a,
> 					  struct vm_area_struct *b)
> {
> 	if (anon_vma_compatible(a, b)) {
> 		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
>
> 		if (anon_vma && list_is_singular(&old->anon_vma_chain))
> 			return anon_vma; <---- Other VMA MUST have anon_vma.
> 	}
> 	return NULL;
> }
>
> So, __anon_vma_prepare() for VMA A goes ahead and allocates the anon VMA:
>
> int __anon_vma_prepare(struct vm_area_struct *vma)
> {
> 	...
>
> 	anon_vma = find_mergeable_anon_vma(vma);
> 	allocated = NULL;
> 	if (!anon_vma) {
> 		anon_vma = anon_vma_alloc();
> 		...
> 	}
> 	...
> }
>
> And sets its fields in anon_vma_alloc:
>
> static inline struct anon_vma *anon_vma_alloc(void)
> {
> 	struct anon_vma *anon_vma;
>
> 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> 	if (anon_vma) {
> 		...
> 		anon_vma->root = anon_vma;
> 	}
>
> 	return anon_vma;
> }
>
> Then it assigns vma->anon_vma and observe the classic gotcha with
> acquire/release semantics:
>
> int __anon_vma_prepare(struct vm_area_struct *vma)
> {
> 	...
>
> 	<inlined>
> 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> 	if (anon_vma) {
> 		...
> 		anon_vma->root = anon_vma; ----------| Nothing stops this
> 	}                                            | being reordered
>                                                       | to crit sect
>                                                       |
> 	anon_vma_lock_write(anon_vma); --------------|------------
> 	spin_lock(&mm->page_table_lock);  -----------|------------ Acquire x2
>                                                       |           |
> 	if (likely(!vma->anon_vma)) {                |           v
> 		vma->anon_vma = anon_vma;            |           ^
> 		...                                  v           |
> 	}                                                        |
> 	spin_unlock(&mm->page_table_lock); -----------------------
> 	anon_vma_unlock_write(anon_vma); ------------------------- Release x2
>
> 	...
> }
>
> And so you can end up in the verse situation of a weakly ordered arch
> doing:
>
> 	vma->anon_vma = anon_vma;
> 	anon_vma->root = anon_vma;
>
> And this the problem observed is that Thread/VMA B finds this VMA (it now
> has vma->anon_vma assigned! So reusable_anon_vma() returns fine) and then:
>
> int __anon_vma_prepare(struct vm_area_struct *vma)
> {
> 	...
>
> 	anon_vma = find_mergeable_anon_vma(vma); <--- finds A!
>
> 	...
> 	anon_vma_lock_write(anon_vma); <-- goes to lock vma->anon_vma->root->rwsem
> 					   but... it's not assigned yet.
> }
>
> And guess what:
>
> void __init anon_vma_init(void)
> {
> 	anon_vma_cachep = kmem_cache_create("anon_vma", sizeof(struct anon_vma),
> 			0, SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
> 			anon_vma_ctor); ^----------------  It's
> 	anon_vma_chain_cachep = KMEM_CACHE(anon_vma_chain,    our friend...
> 			SLAB_PANIC|SLAB_ACCOUNT);          SLAB_TYPESAFE_BY_RCU!
> }							   so _very_ easy to UAF.
> 							   Not so much 'stale' just
> 							   a UAF that might still work.
> 							   Or the root might still exist...
>
> How hideous all round.
>
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
> Less so stale, more UAF but you might get away with it...
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
> Well you _have_ to have a barrier of some kind for this to work...
>
>> anon_vma and anon_vma->root have address-dependency. According to
>> Documentation/memory-barriers.txt and some investigations, only Alpha
>> needs address-dependency barriers and it has been handled by READ_ONCE().
> ...yup, because you have an address dependency :)
>
> That works because, revising the memory barrier docs, the address
> dependency works on the LOAD side only, because it has to deref to knoww
> hat it's looking at whereas on the store side things can just live in the
> store buffer.
>
>> This issue needs two adjacent VMAs aren't merged but are compatible for
>> anon_vma. We reproduced this issue in v5.10 with KSM enabled. The kernel
>> doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
>> merging for new VMAs"), so there are many adjacent VMAs that aren't merged
>> but are compatible for anon_vma.
> How I hate the 'mergeable but not merged' terminology around this
> particular part of anon_vma.
>
> Well in any case I am replacing it all (eventually :) but in the meantime
> it's irksome :)
>
>> Without this fix, our production environment could reproduce this issue
>> about 2-5 times each month. After adding a smp_mb() before
>> anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
>> to this patch, this issue hasn't be reproduced for one month.
> I don't see how the smp_mb() would make any difference there, I wonder if
> you just reduced the race window?

When troubleshooting this issue, we suspected it was a memory barrier problem,
so we added a full memory barrier like below.

diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd69938..11203f381beb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -205,6 +205,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
                 allocated = anon_vma;
         }
  
+       smp_mb();
+
         anon_vma_lock_write(anon_vma);
         /* page_table_lock to protect against threads */
         spin_lock(&mm->page_table_lock);


smp_mb() ensures that all prior loads and stores are completed
before any subsequent loads and stores, has stricter semantics
than smp_store_release().

I used the strongest smp_mb() barrier to test in the production
environment to confirm whether the issue was related to memory
barriers, and to avoid falsely concluding that it wasn't a memory
barrier issue due to the incorrect use of a weaker barrier.

>> Cc: stable@vger.kernel.org
>> Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
> I do wonder if something more recent made this at least more possible.
>
> A decade and a half without it being caught before seems... unlikely :)
>
> I wonder if the VMA locks made this more possible by (significantly)
> increasing the ability for racing faults to occur (no mmap read lock
> required).

I mentioned it in the commit message, maybe you missed it.

"We reproduced this issue in v5.10 with KSM enabled. The kernel
doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking
VMA merging for new VMAs"), so there are many adjacent VMAs that
aren't merged but are compatible for anon_vma."

>
> Either that or something increased the race window or this was somehow
> accidentally mitigated somehow.
>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> Very good spot thanks!
>
> I feel the commit message should be reworked a bit to really clarify the
> problem, feel free to steal my
> explain-to-myself-because-memory-barriers-break-my-brain stuff above :)
> also add the stack trace from the subthread.
>
> I also want some changes in comments etc. but broadly I think your solution
> is correct.
>
> See attached patch for what I suggest for fixing that all up.
>
> With everything addressed feel free to add:
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>> ---
>>   mm/rmap.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d1819fd69938..a868e835eadb 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>>   	/* page_table_lock to protect against threads */
>>   	spin_lock(&mm->page_table_lock);
>>   	if (likely(!vma->anon_vma)) {
>> -		vma->anon_vma = anon_vma;
>> +		/*
>> +		 * The fields of anon_vma must be visible before anon_vma
>> +		 * is published to vma->anon_vma.
>> +		 */
> _Everything_ like this needs a 'paired with'.
>
> In this case, paired with the READ_ONCE() in reusable_anon_vma() (and a
> similar comment there please).
>
> Also over there the comment:
>
>   * NOTE! This runs with mmap_lock held for reading, so it is possible that
>   * the anon_vma of 'old' is concurrently in the process of being set up
>   * by another page fault trying to merge _that_. But that's ok: if it
>   * is being set up, that automatically means that it will be a singleton
>   * acceptable for merging, so we can do all of this optimistically. But
>   * we do that READ_ONCE() to make sure that we never re-load the pointe
>
> Will need updating.
>
> Actually, see below, I provide a patch showing what edits I think make
> sense here.
>
> BTW I actually wondered about doing this with a lock instead.
>
> Like:
>
>    scoped_guard(spinlock, &mm->page_table_lock)
>        anon_vma = find_mergeable_anon_vma(vma);
>
> I think that should work across the board as you get the right
> acquire/release semantics in both cases (you should then delete that
> comment above, remove the READ_ONCE() in reusable_anon_vma() etc.)
>
> BUT.
>
> You are then in a weird situation where it's kinda lockless but we get away
> with it because nobody else who touches anon_vma touches fields that might
> exhibit this kind of behaviour.
>
> So the barrier is probably still best.
>
> Anyway, adjust the patch as below on respin and update the commit message
> as requested above and think this is the right way to go.

Thanks for review. Will update the commit message and comments in v2.

>
>
>> +		smp_store_release(&vma->anon_vma, anon_vma);
>>   		anon_vma_chain_assign(vma, avc, anon_vma);
>>   		anon_rmap_tree_insert(avc, anon_vma);
>>   		anon_vma->num_active_vmas++;
>> --
>> 2.43.0
>>
> Cheers, Lorenzo
>
> ----8<----
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..f3b21aaa34ee 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>   	/* page_table_lock to protect against threads */
>   	spin_lock(&mm->page_table_lock);
>   	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		/*
> +		 * Make anon_vma fields visible before anon_vma is published.
> +		 * Paired with an address dependency in reusable_anon_vma().
> +		 */
> +		smp_store_release(&vma->anon_vma, anon_vma);
>   		anon_vma_chain_assign(vma, avc, anon_vma);
>   		anon_rmap_tree_insert(avc, anon_vma);
>   		anon_vma->num_active_vmas++;
> diff --git a/mm/vma.c b/mm/vma.c
> index 35e7a64855fa..ec4101250d71 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2094,6 +2094,13 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
>    * acceptable for merging, so we can do all of this optimistically. But
>    * we do that READ_ONCE() to make sure that we never re-load the pointer.
>    *
> + * The READ_ONCE() establishes an address dependency between anon_vma and
> + * any access to its fields, which pairs with the assignment to
> + * vma->anon_vma performed with release semantics in __anon_vma_prepare().
> + *
> + * This is especially important as anon_vma's are SLAB_TYPESAFE_BY_RCU so
> + * accessing an uninitialised anon_vma's fields may result in a UAF.
> + *
>    * IOW: that the "list_is_singular()" test on the anon_vma_chain only
>    * matters for the 'stable anon_vma' case (ie the thing we want to avoid
>    * is to return an anon_vma that is "complex" due to having gone through
> @@ -2108,6 +2115,7 @@ static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old,
>   					  struct vm_area_struct *b)
>   {
>   	if (anon_vma_compatible(a, b)) {
> +		/* Paired with a memory barrier in __anon_vma_prepare(). */
>   		struct anon_vma *anon_vma = READ_ONCE(old->anon_vma);
>
>   		if (anon_vma && list_is_singular(&old->anon_vma_chain))

