Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC69C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FE76B00AB; Tue, 30 Jun 2026 01:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F8C6B00AC; Tue, 30 Jun 2026 01:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67DD06B00AD; Tue, 30 Jun 2026 01:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB4C6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:11:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFD081C2C1C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:11:52 +0000 (UTC)
X-FDA: 84935406864.07.4F8CC61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 04F6C80009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:11:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnSjygkQ;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782796311;
	b=et/uH2CKrrbnwKE4tjnvS0FI0NpAuz3c3hLqecbpk4BfhZUcbj8sD/hlSSGU235gyoxy2y
	OITn1Zks2E/t43qcWFeVIagUp+WtTQwhBP67OjFwOy16k2bdNCVApnqeVN1rXBNkD7mi9O
	F8oXBTAUc6lFCtX1DqDjQ+fidxV8NNE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782796311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vP04Zj5CVyJaLzf8VO3FeLXIWVNRIyp0CJ7kM8RLPd0=;
	b=Hce8JNOadr9ALLkoaNOmG0NNVJc/ZbUtqnQxq4dnCV01TdvLoGCx/aD+pC3pXVhJ7S6vyF
	wjSOvduk6m4fCBLZn8dp4N6DFB/U5XzQ0Av6GHrJyb8Ix7afoAeG783bDgODJsENVWk4kf
	MGMtRLZ14u7PRKfTRhTOsekb8nq4w8s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LnSjygkQ;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50117600BB;
	Tue, 30 Jun 2026 05:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104EE1F000E9;
	Tue, 30 Jun 2026 05:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782796310;
	bh=vP04Zj5CVyJaLzf8VO3FeLXIWVNRIyp0CJ7kM8RLPd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LnSjygkQujJBqze4waGOIxA4cm+8m4AE1x+c5lBZnG4xJkAtdCyqPk3ibPoNYdEu3
	 MbG+QZXK408/Z5Ck5L5bFZtdaP+g28hsmQadK4UGAZZABvYpyqR9IUK026gk64ypjg
	 dy1dgoldjYp4wmA5bcPqr9budrc/zppCwULkrbMfhZzZzjPw2Om0B/JJktqm9GghJr
	 MYorJCv9kgCI31nohJbJG1xp4u8izyMQZ8fN/lMo5gT3SQZL67B8Gc5AmkXDNqlhgG
	 EXECEmOrDreNwjnqFntAZEM99O11Fo4yTkhyqeNrtqPWDmeRUUoBVjgpRQmdP34e87
	 baS+wv5Fjm4lQ==
Message-ID: <f07168be-23c6-4ff2-bb74-60509454ee01@kernel.org>
Date: Tue, 30 Jun 2026 14:11:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: serve slabobj_ext array from a strictly
 larger kmalloc cache
To: Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>,
 stable@vger.kernel.org
References: <20260630024357.3591304-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260630024357.3591304-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04F6C80009
X-Stat-Signature: ppqr6pzqoiaqb1z7remhnbp46xosdfck
X-HE-Tag: 1782796310-244696
X-HE-Meta: U2FsdGVkX1/b0yA64oi5AV41GFwhNyFHDsKS3093FD6qDY+1ORjZnvwQ7iI3fI3P/C1MLe6nT5pLZLICyuIuea78wZibuLz3XS8Cce9BPTpx80wEhTmz85rbTDIkEZ2kZLvG/zdglqIuLlb1nwb3fhJuGM/M+YeQFFNrZmNpGZri+ZNcJuW58Tkg+izkpjf602TMEUPODwwSQ3AVeSEA7eEgwv2L+tlJWM1zo9W7F+V+6EqE4cs4x3obFgAjOQUg3Jn1xfAK1IZ6moim5G31r0rai7H/SXWl9QmQj8iKHGUYF+ynXixYbqg2MxS4+R1e+Jz1wulwH87ehlZWf8rjoP5y85An3EkWKr4JkoLJchT+/D07UVq/WqEoQJMUeNqTQPjuWWrxojYeNQHEBWADCsHVh/m/bXrJ1rpXCqTTgCTKbq4RpCrtU522BETmGogW/snXTZWsvohVzJmq4BtAGOAGXFMdd+aOkSiMI70S79F3IEHVsy9nzhzvhF2J//820SxXyQk7uJfWghc9wAayiFaVON7HTa6L8eGytGVygVfPximvkpFP/R3RY4ap8qQM2S5vqgkMxnYYjK6KpUcteAbSJeCsAJ8a4oemm9Da0BXoOAqeB+0JH4lnIW0bfyOtzjLz/q8aieLoRq3w3cTp4b4SJ8leOM0ISTAH9YZ8pvScoGYc2Tpl0hYM9PZBNk/SesILY3+Tn8LqQI44pDVY1tDltZrEXkhArSHZCw9cycgp1cynsQptu4xiBKfKZ+lKFEmsTc+6OASw5jLohwj+fQ6KiEs/SYUhOJBmaKtbwUZSYVGwOgxgWQ0flmkH3gQ4C3l1deWImP3E3YUqby1oRvFpN2qzMBYyjztvahTvsmWXLU9kO64Ym5Uzji0RmO4bOMm67ETlhtIlOpCtxvInx+lNcCy5spuK/DO7JJUinbqg5XXky/0BpN6iFEq+3D8EVU5egL19QElefVKi4jH
 2WPSHshi
 i8rG1QGZAZnuUctECSpuFsPyYws1n7qv5HYyzejAuXpAPsqaYA3eYE703EPAgslXRdU6F6CVybb5ayCRfLBp8R2dK+EuxtNStcNrDxsn5e/PRjoV+qUT3e6LVnit+cPX5KakDmhMWomoXFRBhGzVZ5MwLqGO9LbU72SaJq29aUBOtv+07VqoiFBKtnhBiFlbQbEqdhvNaqBBfUOYBHDQrAWmnz8wb1hiunD9NRO0Q3df2LKHAHi8N4JNwLwS8rWi1k+forj0DRbNCY15vcaZcYclcOL1KTACL1eK/ACx+q2fLZ7+JJRIHvrBfw4qhv33PpSiGZH31v6hhZRjgX4NxDjaw8/OlC4iYATQ+phdyJwZhsEv7e2P1NWHmEgBwt4EufnHeGuEsF5YQiaw2Q3/L7vS1qR8N2ifAIdZ9IM7ob5xV2cebfODnb6mwlDMf/NiV9umm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 11:43 AM, Shakeel Butt wrote:
> A production host in the Meta fleet (6.16 kernel, memory allocation
> profiling enabled) panicked with a kernel stack overflow while a kernel
> driver was freeing a resource:
> 
>   BUG: TASK stack guard page was hit
>   Oops: stack guard page
>   RIP: 0010:kfree+0x8/0x5d0
>   Call Trace:
>    __free_slab+0x66/0xc0
>    kfree+0x3f0/0x5d0
>    ... ( ~125x __free_slab <-> kfree ) ...
>    <kernel driver freeing a resource>
>    do_syscall_64
> 
> The crash dump shows a 125-deep __free_slab<->kfree recursion that
> overflowed the 16 KiB kernel stack.
> 
> What happened: a KMALLOC_NORMAL slab's obj_exts array (used by allocation
> profiling / memcg accounting) is itself kmalloc()'d from a KMALLOC_NORMAL
> cache, so the "slab holds another slab's obj_exts array" relation can form
> cycles.  With sizeof(struct slabobj_ext) == 16 and the host's geometry:
> 
>   - kmalloc-512 has 64 objects/slab -> array is 64*16 == 1024 bytes,
>     served from kmalloc-1k;
>   - kmalloc-1k  has 32 objects/slab -> array is 32*16 ==  512 bytes,
>     served from kmalloc-512.
> 
> A kmalloc-512 slab and a kmalloc-1k slab therefore hold each other's
> obj_exts array.  Discarding one frees the other's array, which empties and
> discards that slab, which frees the first's array, and so on:
> __free_slab() -> free_slab_obj_exts() -> kfree() -> discard_slab() ->
> __free_slab() recurses along the cycle until the stack is exhausted.  The
> dump confirms it: the recursion's slabs strictly alternate kmalloc-512
> (obj_exts in kmalloc-1k) and kmalloc-1k (obj_exts in kmalloc-512), and
> mem_alloc_profiling_key was enabled.
> 
> Commit 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from
> its own slab") is not sufficient: it bumps the allocation size only when
> the array would come from the *same* cache (object_size ==).  At the
> geometry above neither cache is self-referential (512 != 1024 and
> 1024 != 512), so the bump never triggers and the kmalloc-512 <-> kmalloc-1k
> cross cycle remains.
> 
> Fix it structurally by removing cycles of every shape: serve the array
> from a cache strictly larger than the one it describes whenever it would
> otherwise come from the same or a smaller cache.  Every reference edge
> then points from a smaller to a larger cache (here kmalloc-1k's array
> moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
> No slab can be self- or cross-pinned, the tear-down recursion is bounded
> by the number of kmalloc size classes (it terminates at the large-kmalloc
> path, which carries no obj_exts), and profiling/accounting coverage is
> unchanged - the array is still allocated, only relocated.
> 
> Reproduced on next-20260623 at the same geometry: churning
> kmalloc-512/kmalloc-1k under vm.mem_profiling and then shrinking leaves
> kmalloc-512 with thousands of unreclaimable objects without this patch
> (8056) and at baseline with it (847).
> 
> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
> Reported-by: Danielle Costantino <dcostantino@meta.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Looks good to me so:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

and it also passed my test suite, so:
Tested-by: Harry Yoo (Oracle) <harry@kernel.org>

Interestingly, Sashiko pointed out one issue [1] that
doesn't sound completely wrong. But that's a pre-existing one
and although Sashiko (presumably) thinks this patch makes it easier
to trigger this, I think the scenario is unreachable.

[1]
https://sashiko.dev/#/patchset/20260630024357.3591304-1-shakeel.butt%40linux.dev

Here's why I don't think anybody would be hitting it:

It says if s->object_size == KMALLOC_MAX_CACHE_SIZE,
alloc_slab_obj_exts() will always fail with SLAB_ALLOC_NOLOCK because
kmalloc_nolock() does not support large kmalloc.

Then a later allocation of slab objects allocates obj_exts array
(with large kmalloc), and freeing of the slab in unknown context tries
to free the obj_exts array, which kfree_nolock() doesn't support and
leaks the obj_exts array.

However, freeing slab in unknown context is done only when trylock
fails after allocating a new slab. So it's unreachable.

-- 
Cheers,
Harry / Hyeonggon

