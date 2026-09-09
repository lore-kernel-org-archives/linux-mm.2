Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F83FC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DC46B0099; Wed,  9 Sep 2026 11:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0277A6B009B; Wed,  9 Sep 2026 11:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32A76B009D; Wed,  9 Sep 2026 11:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B265B6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:20:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E691160255
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:20:15 +0000 (UTC)
X-FDA: 85194584790.09.2D0E518
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 765FC140013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:20:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avMVSe0u;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788967213;
	b=48ZWg4HEJhTHHdD6LfTemwUPWvln/KT0H/iPZHAUkT0Wfhoi7hwTKQxYqFCO5ipJQXL3n0
	K7uuKg+IkhNn4ABLOeZavWH18qfgnnNmDQ9IOgmhhtSjqZPkgjEsFTtHOBUAygQewP3tFq
	lpgFzDjwFpfpZl92UPLWGFi1n5ZY3sU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=avMVSe0u;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788967213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BvX+3BC7BhWJJD/fyu2n+tfN2Dx6F/4RSPdT5E4WsA=;
	b=qVTiLLb4dW3bLNOHE5r3/Z1JCkMJOzVSVW9ah2Qwb+4VqtAD3hqZhp9EUSTTo0jsT51q0j
	yFZ4EEJ2z0KOAnUaa/uTHxOiJCwJjGrnsjpNfkr0kaD3lmkgdBzQPuSTAeqdKDREREMovT
	4Pupmn7F+Ms6Uq84J0+TPMO/nR+IxqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE27460204;
	Wed,  9 Sep 2026 15:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8561F00A3A;
	Wed,  9 Sep 2026 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788967212;
	bh=2BvX+3BC7BhWJJD/fyu2n+tfN2Dx6F/4RSPdT5E4WsA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=avMVSe0uW7gID48ZBVOW3eN1A8uAXUgrQ9nnNivCB3ozu2A0WXsG5BdlmE8meXKJU
	 0PlMQY5YpkGVzetv5VWPcFIJFw0TtVIgsCYsiFM10nU5LqOU4Dd0lWNcF1s5Z1oNMk
	 l0nvKZcpMU7TA5v3jdj5A8Ya+CEVgczNQgwkBor6A71BcAf+Pzc7SGRvmEaaEWoy+L
	 7fl0vC6oqRjPf0kKLQaUhklAUCJr3aW/F1ijyf8TpkBKk/+IRFo4SIbFyfqX0nPMew
	 JMC02G6FXvvVzXnxCBNuBmf1w4iLwTB2uAg4jZ4mtinWXHFKSr3R0W+VLsshNgK8+9
	 28YX4smBvp9NA==
Message-ID: <039a9b22-25a1-4515-9538-ef23e0d21157@kernel.org>
Date: Wed, 9 Sep 2026 17:20:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ljs@kernel.org, lance.yang@linux.dev, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 minchan.kim@gmail.com, lwoodman@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260908122924.554373-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908122924.554373-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 765FC140013
X-Stat-Signature: dcmerc7pcxgwwk1h53enruqf6f8c6btn
X-Rspam-User: 
X-HE-Tag: 1788967213-582584
X-HE-Meta: U2FsdGVkX18PGHt+MQrghjWFM1dzifrm7tJBvFDHCcVoB/UKLEB+DowDwvWyHN/AkXmTOtWvu3fVIi2ajKEEpLQhWpe9Z2nIuHFa+cAY/Up7rO/+3qVhDQ6wFSfHok5i+beO2AQn2Bzb5tZsl0+3wAJSBP1eALRzkpsFvD19U+cM5zOSrVPwDn2hVun4TvADy1LwRh7PWWUxsQZTWK4u5ZHkI0dYqD9h669oAJmv2dFFFMH36XvekOXZ9xM8JEqzmPt4AA6HhSmxDhoJqqC47uZp10dtsVlCX4cDRHWM/el0DImwg5+/Letoq2LbeCTZx0peFZIsz+zociTB7ERSgt1T5GFq2yz35oT8OHFMO8uukENtYfSuYz81hIRb/v5h08yhOmaoxzMQ3/Vhe+TAR9RVyplJ2H3gDf1pAo/D0IUzVdZW8luL30yNvwqgBYDyZNhUZlWepzaZduHJQkIJmcb6BUHXdOy3/KJpHUpfZBdTFDRReje4gyz0wvlfJQkV1sf2aBARCyES4rHYVklrKBfhksdW6Jub3Son/OeM7+bRMlR/Ijz2rz137xFTp9JqSfneBvJR90t14ymaN2eicMfZlf5sywWP5IVnk5a8zv6tLh/G31fGGAGY5xfzkzP6fYabHCM8qslyBv5sOpSL4bOmckDihmAUE/f6ZJa9cKic9p8y7hCg9iPi0ON1qQMVZcgpwulpAyyI5s0vKSB2fmvHJIOU+56K5AiwlzxTHlykFOQV63GxskiQiS9uw8/rLQsj1TwHrPsMiTPLgRGEAjRG5/LXRIMa8E7py1DT3hgpTTy2qMH2w1OFPFgyORBFL5LR2WIGjWHAYLlZM3zjCdkpKoSp47rvfyEkWm2OH4apIAEzwgmLECzvhyBoql1Xf/6wGhC5yGXE77U5cR8gn1RKraL9W0LyPuFyokUSFBdOv02K0kywBcz8wLuOrny6fyTRd4fw/bn+/D0b4/b
 sABHy/Iu
 IzIMg9k3NTWqcYs0DLadiVyPEpWDYzyewreSAEzBtxS3yM/PbjxgIrDoc5JZAWetfLv6vUibZYz/Lvg8E7msGNHX/ltnMexAcA9LDRDU9tqpmo/Gm2ZE+ENLEItExiA//QTkr2T1aTCfDGqrKB/8tGzTaJQmjPTmZfoTFcnzEtxRbC10yMB7BYz+dkg+MNqfyRm04cFAgKiBJXgfSxtsyDQm9VHqYBn//74ylpllpY2aa8BZOFeg5tEIyFd5xWJvWE1dppL8LPuwc9IWJ/Fh94wzrrbBMTFkpqUWDj7GZq0CLG3i7Y3Jy5z0Vn1wZPhvR2tAAbz7zYjk3bCygqcC401WsJ91iOXm67pnKTwpOrb5m5l7gS5OdG0jjAwJVIkqh1+J8yJDmR1qn9+Q+7zYogH9sVKPwnzXVABV0/kw6RZeMBmY=
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
> ---
> Change since v1:
>  * correct the fix tag (Lance Yang)
>  * rework commit message and update comment (Lorenzo Stoakes)
>  * collect Reviewed-by
> 
>  mm/rmap.c | 6 +++++-
>  mm/vma.c  | 8 ++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d1819fd69938..f3b21aaa34ee 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		/*
> +		 * Make anon_vma fields visible before anon_vma is published.
> +		 * Paired with an address dependency in reusable_anon_vma().
> +		 */
> +		smp_store_release(&vma->anon_vma, anon_vma);


Makes perfect sense to me, although I am not that familiar with all the nasty
details of anon_vma merging (in contrast to Lorenzo ;) )

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

