Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABCEC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FF1E6B008C; Thu, 10 Sep 2026 03:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6E86B0092; Thu, 10 Sep 2026 03:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED616B0095; Thu, 10 Sep 2026 03:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3138D6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:01:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0941A0455
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:01:06 +0000 (UTC)
X-FDA: 85196955732.15.25EC37B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08114140008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:01:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FY9LHIQR;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789023665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+Fvkto5qAFozFyaMkrbMhzLbwJwYpEtlaPW8hDl+o0=;
	b=6Nf9KfmG5ilApYfTJCEclg/2emEh24x3mwvnS6KdgjHc+q7f6LdgfB4OyKGh07wChiSQ7b
	dzl6rTbjci4jU51jq8swY6bBTZEETxAHs3MmdUPafLEUMvEy8XPA0qbvg/MQW5T8DxgUco
	+pAHHEfbCN9ILvdmY9EARrbm55JZJrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789023665;
	b=c3iPnhEQuiV5jEf7Xp96HUu1ivod0aHlPGI4MgR8I30F6MVxyOPmkTSyv/4ItSB8hY7hqY
	9cZUSsg6bmPQewQXQFNQHlVlo00gNtCNTzPBrTStGeaJFlA+EUSBfY1vAI6CDFpiZNmeJ7
	CN8cgXBbK3lSo2Cr2jQ3viyljzOpslY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FY9LHIQR;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C233600C8;
	Thu, 10 Sep 2026 07:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EB51F000FF;
	Thu, 10 Sep 2026 07:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789023664;
	bh=A+Fvkto5qAFozFyaMkrbMhzLbwJwYpEtlaPW8hDl+o0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FY9LHIQRUp6sudA89KRTEkiY5idffNFEywi7FthL/xHsXkvV4nt7orzbZrAHuUwSA
	 T4bIgUZI27T2LiJIlgDSvz82rBf2NJaOOHdcKuXsNGwWxJCPDbkcRLP8Pd2/uWpbvU
	 u75B91AzbY/KwPXrmnyiak2iru6wZ76cI2/WF0AJaTzpwyHa3Vta0qePyIsawmzEiL
	 D5ujFipSkoB5uAK7joB7cieTrz0d9Yc5y/4TDGCQmqgmfRFopDhSyZ82baZ7P/cbVZ
	 6GgkQ2zEIeeIz8gSMxtSS9zaNQ72ZLsNL9ozjhQ47DGOk4jnJfTSUAjYgFcXvzAXmC
	 9sBRJe/94VINA==
Message-ID: <0feba0fb-4d23-47b4-ba37-5c272bceafd6@kernel.org>
Date: Thu, 10 Sep 2026 09:00:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, lance.yang@linux.dev, riel@surriel.com,
 liam@infradead.org, harry@kernel.org, jannh@google.com,
 minchan.kim@gmail.com, lwoodman@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260908122924.554373-1-tujinjiang@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260908122924.554373-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xii9xmoodqmbj8yf6a669yggnw93y9id
X-Rspamd-Queue-Id: 08114140008
X-HE-Tag: 1789023664-864258
X-HE-Meta: U2FsdGVkX1/mSf4wPoOCiDTwiWz++d8/5NOFw4Kfv7uA1GZKfb3LTiHjSnQKNOBK6auHTup2c+2+tQM6KX1lYzWSn4kJRQezwyFxE3LMFtlxUzzeHznX92ZekvZxcIUmOdFTKAl2LSPvSkb/5o/9wkWkZKCw6D4NQG4PUNVgHXvjTkT89shACbeLEo2Km3/+BRqP0aXvE8EimfRvTvOFjABg5sCdPmtMAQBY5paK2bMEoMv4hx3LziKwk6S3OS+PDmbb5bNcOWsxt/+XJaaRmhth67oBkPuMclNcPr2jQ1lOYncEUWSuEy6s0KOeTyxpYLcCQZORcyD13l4437zsUBpD2HT32J/g4b5E/6D62UUgbbXa4M6d5Sqc0KkMpgNRk37v48/i2sDuYpfdux3XsVrROgYSCycg48ESvRdsSlm46wV504DV9PFEZT0wYar9YXSmn7jZcfR/zQVDutMz3QjwCgUSH3mU1KOjRtp9cgNbnESNJbfn7vTh+2ebvAcpe1y2816kovVHAyyH+cAQBzipgC/f25k+K3JBqlH/EM5qf0m/Au2beVEXJkBrRsxv5wnClSSsmqEqLfVX94RptqoaYJHjIZ07eqnBEdq3BDBwPlr6nWcdO7I9L0099L+doLtrDxOQp3WYFrbnt14nkpSNiChb/jdMraA8a/xWW7EJI9eRa2UP3qsLBrkTDQzMp7xDkbnUq+9BDUfOiq5EfMfWZgCDWgzXBKRf3JWBMGpNFcbl18zMRVPchJLfth4Tl8fdq/vUIvXGbvUFQEyVjA+f4FFa7z43dnCWPq74kClMyegMDyzL8X/sLn1h/6tSGA9etIIAHHV60Ho0K3HXER71qUFAmQ0eGGJkJn/VJuZwtF3ms//Mt+H4+MusR292+znB3HE4dobqIbDBSiUWK2IhSA8r3WE0shvi8sE5+d73jRpAZqHknrgp+To7dH2h6OHgEAab6O5UfXcLmk+
 P7qRRWlE
 GqtHGmeUYWtYftok9zbznyryxHvbDBAkPy5oyJ8am5LtXJ0WHVewizOiKiFGvvXZSN6UxENpppZWZUTehbKzNRUpsKC2PCSiKZDJTT9Lbt2cAFQ5nWhFejT3uq0sLVthqCGhn2gcpkIG/Ct/Uxoe5mewPmWNzxcXTNZwnTfYC99EuOV2AxYUjw00aC+hyvv3QMrn6sb72M4xJgTERgcoJ85CgMJkF47nglNgdvqDpFqmFly6nQZNar4i1y2JH8RWv/rS/k07M8KZxeLKTRa4vx/Unp9hfCao+J7L+LagXq2dvk94naLaKQP7RcQfHRyFMYM7LbaerJ8Nn2CWFmT0qBiihxOV7S72aTlO0luG07qApo41ac798VOkqbT0zh5NKmHRWuUlmdhRk8N+Kaf060sYLJbYQvxdr20qCbP4ht0CK32E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 14:29, Jinjiang Tu wrote:
> On arm64 server, we find that a task trying to grab the anon_vma lock
> triggers hungtask.
> 
> INFO: task main:2354726 blocked for more than 120 seconds.
>       Tainted: G            E     5.10.0-0021.aarch64 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
> Call trace:
>  __switch_to+0x7c/0xbc
>  __schedule+0x3b4/0x8a0
>  schedule+0x50/0xe0
>  rwsem_down_write_slowpath+0x3cc/0x6cc
>  down_write+0x60/0x260
>  __anon_vma_prepare+0x6c/0x210
>  do_anonymous_page+0x258/0x660
>  handle_pte_fault+0x188/0x214
>  __handle_mm_fault+0x1b0/0x380
>  handle_mm_fault+0xf4/0x284
>  do_page_fault+0x19c/0x494
>  do_translation_fault+0xcc/0xf8
>  do_mem_abort+0x48/0xac
>  el0_da+0x44/0x80
>  el0_sync_handler+0x88/0xb4
>  el0_sync+0x160/0x180
> 
> After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1.
> There is another anon_vma whose anon_vma->root->rwsem.count is 1, the
> anon_vma->root->rwsem.owner shows the lock is held, but the stack of the
> task shows the task doesn't hold the anon_vma lock.
> 
> After adding more debugging info, we found __anon_vma_prepare() reuses
> anon_vma and triggers the UAF of anon_vma->root due to missing memory
> barrier, leading to locking and unlocking two different anon_vma->root,
> thus leading to an anon_vma will never be unlocked, and another anon_vma
> couldn't be locked anymore.
> 
> This race requires two adjacent VMAs that are not merged but are
> anon_vma-compatible (e.g., they differ in VMA_ACCESS_FLAGS that can be
> changed by mprotect()). Two threads fault on each VMA concurrently, both
> calling __anon_vma_prepare() with only mmap_lock held for reading.
> 
>     THREAD A                             THREAD B
> __anon_vma_prepare                __anon_vma_prepare
>  find_mergeable_anon_vma() -> NULL
>  anon_vma = anon_vma_alloc();
>    anon_vma->root = anon_vma;
>  // the two stores may be reordered
>  vma->anon_vma = anon_vma;
>                                    // finds A's anon_vma
>                                    anon_vma = find_mergeable_anon_vma(vma);
>                                    anon_vma_lock_write(anon_vma);
>                                      // may still see the old root
>                                      down_write(&anon_vma->root->rwsem);
>                                    anon_vma_unlock_write(anon_vma);
>                                      // see the new root, never unlock old
>                                      up_write(&anon_vma->root->rwsem);
> 
> thread A triggers page fault and calls __anon_vma_prepare() to prepare
> anon_vma for the faulting vma. __anon_vma_prepare() allocates and
> initializes a new anon_vma, and then publishes it to the vma with a plain
> store. anon_vma_prepare() only requires the mmap_lock to be held for
> reading, so two threads can fault on adjacent VMAs at the same time. While
> thread A publishes a new anon_vma, thread B could find the anon_vma via
> find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.
> 
> The store to anon_vma->root in anon_vma_alloc() and the store to
> vma->anon_vma can be reordered. The anon_vma_lock_write() and spin_lock()
> only provide acquire semantics, which do not prevent prior stores from
> being reordered after them. The release semantics of the corresponding
> spin_unlock() and anon_vma_unlock_write() come too late, the store to
> vma->anon_vma is already published before they take effect. As a result,
> thread B can observe the following order:
> 
>     vma->anon_vma = anon_vma;
>     anon_vma->root = anon_vma;
> 
> The anon_vma slab is SLAB_TYPESAFE_BY_RCU, so a newly allocated anon_vma
> may reuse memory from a previously freed one. The constructor
> (anon_vma_ctor) does not reset anon_vma->root, and __put_anon_vma()
> doesn't clear it either, so the old root value persists until
> anon_vma_alloc() overwrites it. If that store isn't visible, thread B
> reads a root that points to the old anon_vma and locks it.
> 
> As a result, thread B can call anon_vma_lock_write() with the old root,
> and call anon_vma_unlock_write() with the new root, leading to an anon_vma
> will never be unlocked, and another anon_vma couldn't be locked anymore
> (its count is dropped from 0 to -1 due to wrong unlock).
> 
> To fix it, change the plain store `vma->anon_vma = anon_vma` to store
> release, so that the fields of anon_vma are visible before anon_vma is
> published to vma->anon_vma.
> 
> At read side, the load of anon_vma and anon_vma->root have address
> dependency. According to Documentation/memory-barriers.txt and some
> investigations, only Alpha needs address-dependency barriers and it has
> been handled by READ_ONCE() in reusable_anon_vma().
> 
> We reproduced this issue in v5.10 with KSM enabled. The kernel doesn't
> merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA merging for
> new VMAs"), so there are many adjacent VMAs that aren't merged but are
> compatible for anon_vma.
> 
> Without this fix, our production environment could reproduce this issue
> about 2-5 times each month. After adding a smp_mb() before
> anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
> to this patch, this issue hasn't been reproduced for one month.
> 
> Cc: stable@vger.kernel.org
> Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


