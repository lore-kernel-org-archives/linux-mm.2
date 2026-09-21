Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EECBC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BD06B00B1; Mon, 21 Sep 2026 09:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612D66B00C3; Mon, 21 Sep 2026 09:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F8E6B00C9; Mon, 21 Sep 2026 09:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 364196B00B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:26:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 324CBA015B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:26:02 +0000 (UTC)
X-FDA: 85237842564.11.CE9DD6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E33AA0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:26:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpJoC3Mz;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789997160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nha8ML1H2R/fcgwZZbQPRhZtrvRZFsoDZhBO+DEOQYU=;
	b=JIwG6MnNheUJIppAA3PLVONST2n56iAgitkg9O4gXpkO967N3Z3a727WIrRxpBZ/mNkldj
	k8Sovth/m7WKzfNqt3HthARAuw/DLP/4Vl6cMcaIqS5ya6S8fqaf/lQ5qdwjRzVWgCd6o/
	b6jJmwwIxSwe8FDTjG/kwlicPXHL3QQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789997160;
	b=NqsJmEjlRIqZTapKO9cG1FpSQRz6JfOslw/akKI+0obIhGHyWEb+Ia4ZUI5xG1YiT/p5ud
	613KtvicMp2MmLMWwlGMKbnVeOkMdP5tR4W6dk0dg+JY8zxKMbfsfoNGEN21HbVnE//Wge
	wt8xJIu4b06MVlG09CnLdsuLVpkslRg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpJoC3Mz;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D815A600C8;
	Mon, 21 Sep 2026 13:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ABF1F000FF;
	Mon, 21 Sep 2026 13:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789997159;
	bh=nha8ML1H2R/fcgwZZbQPRhZtrvRZFsoDZhBO+DEOQYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hpJoC3Mzq7wrz0POCEfSBz/THghFV/1UuOP96ueguC1IWtsaaCw1hl2On2e0gqGZH
	 4cxUib8+dZJEVj76tS8YCx8JopQ7260IhSMfPBpgSoyY/3EbuxVyc1B2PRhlb+zDuC
	 0qLOTQe5MVh39Zd43qG1+7gjkJJkr9/eJHznJlQfYBhf53YilE6Gp4ataI5yLzrntG
	 7BiGtB8EgjOSwmnYtxKW3v0OsA1YsjTN7ubyYEe9ql5crvYSVmOlzbk0zqJUimvOmJ
	 a/EGup8aLynu8hNlSzoRiqa+zAk+pC0nlNzzoDAxmQK0Q/PThNESdnCPbNNHNu+UyA
	 qpDCowVNO0jWw==
Date: Mon, 21 Sep 2026 14:25:57 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Message-ID: <arEvspsSl3bLyYgs@thinkstation>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-6-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-6-kees@kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ug83i61ye1s1oye39d7zu3473x649d91
X-Rspamd-Queue-Id: 8E33AA0005
X-HE-Tag: 1789997160-474454
X-HE-Meta: U2FsdGVkX1+lBFclu/4xJsHUZAnl958z6ofP0H6D6C/fIPlehvUYNVYkSCk1ETxrkHGyo5QMYQxJvKqLzBENH/sAkoOCd++E5KbpPQgI26BIX81S2EGVNiRJ2uJVZ1iPvZoq6mxHnu4QYHJgy7WYk38NV0ODpCHVeaYzW31CK+sb5Hq6xcIa+IF3dmRmII3PFIbuK8XWyte4cG31VwQuK6uzbcZfOQWS23JqDL1hjkbZMpQoRgTKDlHapNTVoFIVBQS8IYzRadCyhGTJ42MnQy4RayK9ME4Wm0VON1ws1CISESlgM8uikcoh/4f/ozk0RjAPdKEASIDkmJGgEBkdLlxZjnZplO4RDw8mOzMAlegCqytyd+xLwG0N6tVlKyXvjUcpkAwYmgX53zVsOJxKAIxDyoM4UPPXruZvtHOHJb7aVWloZeuT0Pcb60L1kZp9mtd8v3TcTISd+uc7VE08QIJyD1ppLvjWKrPF/zPFHYep7MCC4dA1lryYTq+WP7xWcrFICNnZpmZk86F3DrdhbX3SQGpDS2hwpqoFm1CwjkwCEZxzxEbIU6wJXwBxxUHDQOm2d7bBaHuNs0Ri1lCN7zVD6KSwwiSiT02Vv1E649CaI2eWQpoDdQIVxCroulBYNM8DvQJd6tAmb0wLIuMsHv3zeuro5bZYBJLHMNINU6a/DMrQIzolCKrxkdTeCA7pWfk/KzvKkg2PbToZTsLh/ktSpJ7EMHZ46eZN0QQxGsJoi7dHiHzz9VWzU/0Jk1Z6aM6oo0JLm8CP/qbwb7pb4xpzIyw1Pzjq+jlfn8LLr+PzH9jfCxgmQAtM4klzOdgx/EoUqvr/eyF6+EoeVphL9uBH68uIRDJ9NidB5OBddiA4VKnuWIG6BeagN9aIeB7vkTmeTQtpqmMFZ4qu3XJxQicALPtVHqLmBAfW+Pqx83mbRjCY4ag7NmN5CsPxbUMkqyeEK+lEYmd9GWMEC+1
 9t3IUrVd
 5CdiKJWEhFePK0re7kl5PdW1sIfrAJRzbIy5gMYjsjiuEbgGfGdt4NflGOL/RRrCYfTi+DFxdO+f8Letmk79o5heMrMlMk07rDOexd27v7+SuJJ+CrGK3kbMRGjtYnNAK3+BnttpABdgGhEIsMXj/tC3JnTLM1twBwAY90V8uYg4gYGl4O7qEzzIJsV6JVUIYR+vJyq3PyiZD5k7Ajzx0gCE+5R1yqbC2p6caPOzxAHVpC8VM8p+p+iklgNgasr31Oxgrh/falaedstWPa241zQT0y3c5GYGV9aPzOb92RhZagfSEdROUb5YYg2FVVnRgjapD9XaOcGxqVuq/pw4CzR+T0hJLpCQJ6jspXD+JqjlF8gmeaTajEpp5xrKXsVlmxDWHlFI8hqQkI4oMVsPsj0tCoA9HbAeMCfVZK7Iyme0tbEaKxsb/DUU0SZWDlvkVgyAy3fkILz8dCVDzFqiFtOdNbbCJFmkGjmm8fBsZoW51k1pn1tpId50Js7qU8SbQd8iNxhulj8CcsKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:17AM -0700, Kees Cook wrote:
> A bucket set holds one row of caches, cloned from KMALLOC_NORMAL, and an
> allocation of any other kmalloc type falls back to the general caches.
> Extend this to handle __GFP_ACCOUNT, so that a single bucket user can
> isolate either GFP_KERNEL or GFP_KERNEL_ACCOUNT allocations, as is
> needed for skb data, where AF_UNIX uses:
> 
> 	sk->sk_allocation = GFP_KERNEL_ACCOUNT;
> 
> The coverage is selected at bucket creation time:
> 
> 	b = kmem_buckets_create_types(name, flags, 0, INT_MAX, NULL,
> 				      BIT(KMEM_BUCKET_NORMAL) |
> 				      BIT(KMEM_BUCKET_CGROUP));
> 
> The prior kmem_buckets_create() function keeps its name and defaults
> to only KMEM_BUCKET_NORMAL, leaving existing users as-is.
> 
> Only the accounted type is offered. Nothing wants a reclaimable or
> no-obj-ext row, and of the twelve places passing GFP_DMA to an skb
> allocator, all rare hardware: b44, b43legacy, prestera and s390 ctcm.
> 
> The choice is made at creation rather than every set getting every type
> because the rows, when populated, are not free. Each holds 13 caches, and
> a cache is a 1208 byte struct plus an unconditional per-cpu allocation,
> a node struct, and an entry in /proc/slabinfo and under /sys/kernel/slab.
> 
> KMEM_BUCKET_CGROUP collapses to KMEM_BUCKET_NORMAL without CONFIG_MEMCG,
> exactly as KMALLOC_CGROUP does, so NR_KMEM_BUCKET_TYPES is 1 there and a
> bucket set is the same single row it is today. Where the type is asked for
> but the system is not creating caches of it (under "cgroup.memory=nokmem")
> the row is aliased to the normal one, as new_kmalloc_cache() does for the
> general caches, so those allocations stay isolated rather than falling
> back to the general caches.
> 
> Built and tests pass (and skip as expected) on ARCH=x86_64 defconfig
> with GCC 16.2.0 in all combinations of CONFIG_SLAB_BUCKETS=y/n and
> CONFIG_MEMCG=y/n/y+"cgroup.memory=nokmem".
> 
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: <linux-mm@kvack.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Kuniyuki Iwashima <kuniyu@google.com>
> Cc: <linux-hardening@vger.kernel.org>
> ---
>  include/linux/slab.h   |  45 ++++++++++++-
>  mm/slab.h              |  23 ++++++-
>  lib/tests/slub_kunit.c |  65 +++++++++++++++---
>  mm/slab_common.c       | 145 ++++++++++++++++++++++++++++++++---------
>  4 files changed, 235 insertions(+), 43 deletions(-)
> 
> diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
> index 823607e06248..58f800582170 100644
> --- a/lib/tests/slub_kunit.c
> +++ b/lib/tests/slub_kunit.c
> @@ -723,15 +723,63 @@ static void test_kmem_buckets_type_fallback(struct kunit *test)
>  				      "expected a DMA cache, got %s", c->name);
>  	}
>  
> -	/* Nor can one that has to be accounted. */
> -	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {


Didn't take a deeper look at this yet but this is causing an error:

MODPOST Module.symvers
ERROR: modpost: lib/tests/slub_kunit.ko: symbol 'mem_cgroup_kmem_disabled' undefined!
make[3]: *** [../scripts/Makefile.modpost:147: Module.symvers] Error 1
make[2]: *** [/var/lib/jenkins/agent/workspace/harry-linux/ARCH/x86_64/COMPILER/clang/DEBUG/light/PREEMPT/lazy/src/Makefile:2179: modpost] Error 2
make[1]: *** [/var/lib/jenkins/agent/workspace/harry-linux/ARCH/x86_64/COMPILER/clang/DEBUG/light/PREEMPT/lazy/src/Makefile:248: __sub-make] Error 2
make[1]: Leaving directory '/var/lib/jenkins/agent/workspace/harry-linux/ARCH/x86_64/COMPILER/clang/DEBUG/light/PREEMPT/lazy/src/build'
make: *** [Makefile:248: __sub-make] Error 2
Build step 'Execute shell' marked build as failure

-- 
Cheers,
Harry / Hyeonggon

