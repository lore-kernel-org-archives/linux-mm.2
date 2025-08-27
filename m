Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378F2CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064DF6B0368; Wed, 27 Aug 2025 04:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016156B0369; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D346F6B036A; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A83C16B0367
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E7B31A04FF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:39 +0000 (UTC)
X-FDA: 83821856118.12.0CBC2AB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1B9AC100007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="eqvBj/Bz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UwDmNk1l;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="eqvBj/Bz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UwDmNk1l;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yqOg3cMAW/h1lE2EluLGQG8N1B+PEpUkdHxgNhrZTCM=;
	b=lkfK4B9jiMZSECVAJqjXYk80e6d8MGR9OAA3zy+vKGbma8uW9OI3clzDEA+/GyY1fuYKtT
	13DUomagZn0QjFIx9YkMWiiqJ1MnSZpSknANkXqIikeB0N0jb7vew0bvQ1RbLYZAVsK7zD
	GNxjSp1vy5yHEDzxJSo2kPTB/rop8q4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="eqvBj/Bz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UwDmNk1l;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="eqvBj/Bz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UwDmNk1l;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283197; a=rsa-sha256;
	cv=none;
	b=K7xcM1ZprD4wt6gZq8DA0QbDf56FKT5em3iABhtnazjif4IrqzScw6lz6t8ITBeIoI18nf
	q42O5qwC+FHiU+TX6SjR3sXnbshVYZ6LOfP4U+u6iDL+oXGaFe7G5uRYL1N5dX1wpL9UJ2
	FCIcEoSfLAXAbdrDRt/xeUcTEkysDsQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0EA511FF1A;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yqOg3cMAW/h1lE2EluLGQG8N1B+PEpUkdHxgNhrZTCM=;
	b=eqvBj/Bzj27xYrOEPU5VekyOHHs0fysWWd6F4g4fI36Z/NzH2DN0FaeIoOqDVOZ+n0ElHw
	C5wWNbh8p/irxO06+pkDTBK39fa4zktdRmA+2XEQus5oGk6HKRc2lqGYJZLhEYWc2G6Rhv
	34ErF9yJjbJqo6dg3JvayCUwYWXNJpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yqOg3cMAW/h1lE2EluLGQG8N1B+PEpUkdHxgNhrZTCM=;
	b=UwDmNk1llopGOLz0idJFpE9ybHgXHliIm0GmmznpGmeoynFEE4hkedUSQjysILceVRFqD8
	PqYpQIgXwB6mYDDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756283195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yqOg3cMAW/h1lE2EluLGQG8N1B+PEpUkdHxgNhrZTCM=;
	b=eqvBj/Bzj27xYrOEPU5VekyOHHs0fysWWd6F4g4fI36Z/NzH2DN0FaeIoOqDVOZ+n0ElHw
	C5wWNbh8p/irxO06+pkDTBK39fa4zktdRmA+2XEQus5oGk6HKRc2lqGYJZLhEYWc2G6Rhv
	34ErF9yJjbJqo6dg3JvayCUwYWXNJpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756283195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yqOg3cMAW/h1lE2EluLGQG8N1B+PEpUkdHxgNhrZTCM=;
	b=UwDmNk1llopGOLz0idJFpE9ybHgXHliIm0GmmznpGmeoynFEE4hkedUSQjysILceVRFqD8
	PqYpQIgXwB6mYDDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8FA513310;
	Wed, 27 Aug 2025 08:26:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uaCRODrBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:34 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v6 00/10] SLUB percpu sheaves
Date: Wed, 27 Aug 2025 10:26:32 +0200
Message-Id: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADjBrmgC/23Ry07DMBAF0F+pvMaVZ/yI3RX/gVj4MSERtCl2E
 gFV/x2nFUSVsryLObqae2GFck+FHXYXlmnuSz+cajBPOxY7f3oj3qeaGQqUAGh5+ZgCP1OO54l
 HHzsq3CkF1qEASA2rh+dMbf91Q19ea27zcORjl8n/U8KCACMNNnuDwnDH5+DDu38uU6F9/FmYr
 i/jkL9v1WZYsOVUQa2x1WIGLnhKUYQUsSGh/62lw4x/gBYIahPAClirHRIJZ4x/BOQKSGg2AVk
 Bl5y1KtlglHwE1Aoo1JuAWhr4+hdnMSivHgG9Ag3KTUBXIDQOY7JStDqtwPU+TKbPqY483tdhw
 RficTge+/Gws0ht0sZ564RrMYAEJSIEmai+RWpPXgShoWLXX1MJXQw5AgAA
X-Change-ID: 20231128-slub-percpu-caches-9441892011d7
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: 1B9AC100007
X-Rspam-User: 
X-Stat-Signature: qg7dbociqxcmkp699w5m4canwyckgkmk
X-Rspamd-Server: rspam09
X-HE-Tag: 1756283196-857149
X-HE-Meta: U2FsdGVkX1+mHj8QzKXeZYpcVqo0lXu2wicfPexBVJpOsSQ9g5DIyWyzE0lo88Q1YR2xE/Y9NvATsnnbOKSSuTZ/C7ukh3sCG10dofijXugCWb3Wu2dCMCSdYG4gR/cMKKbWo9OkPLLDGNscHAvYddRr0DptNyHri600XQwvNSmGmIjhgtvJ1bkcqa2aILvR/O5J2W2VerO3MdX7TqunXn8HhpTB9s4wtj4TzvIgNDlRQnYuGzsazaKZ9ShffngJLZ9672CZBzvhdJrg2KJ2sSjRNe3aW2e/SGyGZgoIzJlJE6w1kPnL7pZBJKcu/C674bYJNt9T6jhNEOuzL6C/1gqkgJgra8tWfK5ckrtdt9RgjSfq3M1HOXsp6F4f2sUWLD2XYcox29MPQqg3b1IrUzZyh3bU/SurGHbXf0iv+oLN9NfnLJC5H7elPJFyLiPx+lAmJMS7S4JQVa9J+YCRR2U4tM/5sA8KuaNsC/Vq7dKSJR8zS9j/NstRM9KElpcqvLZQBgKC6IjpEunHSV6ZJOkfOeiFzKniDh7WcuR3tnfUDkDWZxFestDL6CI1/MXf5e5vhZlALXxWMVuC4/urbgvGqBCCRSDspSF+kwlePnZr/+JpER4L40q+7FTLHRKEZ839ns0OxWEFOBn4SrbuzpCAAkHT7nezX/T+oaWt8jims71NmIyq30y4HNqFvU2c6MhezoWT5Igvu5yY85+xsrLFremUv7YU234UWlZBXI91ppx5S9UvCZsY+SzusFwaTid/4HVmPnSWtebkr6pM5xHBK2EGrEuUa9GHDtgyC9PXtzM1iyzf2+bEAKwQ0FnzlSXpIE8qSTH8sXAoUX9TtTb2i8pskWHPH+azrV8iV7PGgo4I5ZkQCL0xqLcR0X5IINr9MVrCQDx0f5+waWMrWl/d6OYllZ0oWioHmfGslWo0xFIrSKC6u61dR0tDjUU5NzkgBLs9HknYBNB/YIe
 mPuk+0qQ
 ch42/BhDGYQROJO6DobOO7txHWzQy4Igep4pGFxwGqIjSEaTKCp3kgKUP1mGbkMiKIQ0N3pGNeKRHjOu9QrR9Hvb5gRZKsP1dzOF+T0zTt1A4DWRm/dSvsI5HFelWu6lxyZCSgLQjEmzlEKtk/rJ+EPhC8buXISxo7ZBXd9tw4OLScDvPhDODcDFO38l1JCkbCxL6fIEnCp4OcvK949N+T2KYZuerMfupxZ9+ulaZkQKvpYLjNtMh9yy4X/YAsDJwQQ8aEq9mqmPzrtt87glu4d4phCB7HhKouDmWcyblYH9haG8SCo5U03jQE/GkmjJmtqUSsbgEislBX6YAE4qZ+m8pEOg7t5fC+153
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series adds an opt-in percpu array-based caching layer to SLUB.
It has evolved to a state where kmem caches with sheaves are compatible
with all SLUB features (slub_debug, SLUB_TINY, NUMA locality
considerations). My hope is therefore that it can eventually be enabled
for all kmem caches and replace the cpu (partial) slabs.

This v6 will be now added to slab/for-next and to collect further
reviews and testing/benchmarking. The more involved conversion of maple
tree was removed and will be posted separately after addressing review
feedback and broken self-tests.

Note the name "sheaf" was invented by Matthew Wilcox so we don't call
the arrays magazines like the original Bonwick paper. The per-NUMA-node
cache of sheaves is thus called "barn".

This caching may seem similar to the arrays in SLAB, but there are some
important differences:

- does not distinguish NUMA locality, thus there are no per-node
  "shared" arrays (with possible lock contention) and no "alien" arrays
  that would need periodical flushing
  - NUMA restricted allocations and strict_numa mode is still honoured,
    the percpu sheaves are bypassed for those allocations
  - a later patch (for separate evaluation) makes freeing remote objects
    bypass sheaves so sheaves contain mostly (not strictly) local objects
- improves kfree_rcu() handling by reusing whole sheaves
- there is an API for obtaining a preallocated sheaf that can be used
  for guaranteed and efficient allocations in a restricted context, when
  the upper bound for needed objects is known but rarely reached
- opt-in, not used for every cache (for now)

The motivation comes mainly from the ongoing work related to VMA locking
scalability and the related maple tree operations. This is why VMA and
maple nodes caches are sheaf-enabled in the patchset. In v5 I include
Liam's patches for full maple tree conversion that uses the improved
preallocation API.

A sheaf-enabled cache has the following expected advantages:

- Cheaper fast paths. For allocations, instead of local double cmpxchg,
  thanks to local_trylock() it becomes a preempt_disable() and no atomic
  operations. Same for freeing, which is otherwise a local double cmpxchg
  only for short term allocations (so the same slab is still active on the
  same cpu when freeing the object) and a more costly locked double
  cmpxchg otherwise.

- kfree_rcu() batching and recycling. kfree_rcu() will put objects to a
  separate percpu sheaf and only submit the whole sheaf to call_rcu()
  when full. After the grace period, the sheaf can be used for
  allocations, which is more efficient than freeing and reallocating
  individual slab objects (even with the batching done by kfree_rcu()
  implementation itself). In case only some cpus are allowed to handle rcu
  callbacks, the sheaf can still be made available to other cpus on the
  same node via the shared barn. The maple_node cache uses kfree_rcu() and
  thus can benefit from this.

- Preallocation support. A prefilled sheaf can be privately borrowed to
  perform a short term operation that is not allowed to block in the
  middle and may need to allocate some objects. If an upper bound (worst
  case) for the number of allocations is known, but only much fewer
  allocations actually needed on average, borrowing and returning a sheaf
  is much more efficient then a bulk allocation for the worst case
  followed by a bulk free of the many unused objects. Maple tree write
  operations should benefit from this.

- Compatibility with slub_debug. When slub_debug is enabled for a cache,
  we simply don't create the percpu sheaves so that the debugging hooks
  (at the node partial list slowpaths) are reached as before. The same
  thing is done for CONFIG_SLUB_TINY. Sheaf preallocation still works by
  reusing the (ineffective) paths for requests exceeding the cache's
  sheaf_capacity. This is in line with the existing approach where
  debugging bypasses the fast paths and SLUB_TINY preferes memory
  savings over performance.

GIT TREES:

this series: https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v6r3
It is based on v6.17-rc3.

this series plus a microbenchmark hacked into slub_kunit:
https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v6-benchmarking

It allows evaluating overhead of the added sheaves code, and benefits
for single-threaded allocation/frees of varying batch size. I plan to
look into adding multi-threaded scenarios too.

The last commit there also adds sheaves to every cache to allow
measuring effects on other caches than vma and maple node. Note these
measurements should be compared to slab_nomerge boots without sheaves,
as adding sheaves makes caches unmergeable.

RESULTS:

In order to get some numbers that should be only due to differences in
implementation and no cache layout side-effects in users of the slab
objects etc, I have started with a in-kernel microbenchmark that does
allocating and freeing from a slab cache with or without sheaves and/or
memcg. It's either alternating single object alloc and free, or
allocates 10 objects and frees them, then 100, then 1000
- in order to see the effects of exhausting percpu sheaves or barn, or
(without sheaves) the percpu slabs. The order of objects to free can
be also shuffled instead of FIFO - to stress the non-sheaf freeing
slowpath more.

Measurements done on Ryzen 7 5700, bare metal.

The first question was how just having the sheaves implementation affects
existing no-sheaf caches due to the extra (unused) code. I have experimented
with changing inlining and adding unlikely() to the sheaves case. The
optimum seems is what's currently in the implementation - fast-path sheaves
usage is inlined, any handling of main sheaf empty on alloc/full on free is
a separate function, and the if (s->sheaf_capacity) has neither likely() nor
unlikely(). When I added unlikely() it destroyed the performance of sheaves
completely.

So the result is that with batch size 10, there's 2.4% overhead, and the
other cases are all impacted less than this. Hopefully acceptable with the
plan that eventually there would be sheaves everywhere and the current
cpu (partial) slabs scheme removed.

As for benefits of enabling sheaves (capacity=32) see the results below,
looks all good here. Of course this microbenchmark is not a complete
story though for at least these reasons:

- no kfree_rcu() evaluation
- doesn't show barn spinlock contention effects. In theory shouldn't be
worse than without sheaves because after exhausting cpu (partial) slabs, the
list_lock has to be taken. Sheaf capacity vs capacity of partial slabs is a
matter of tuning.

---------------------------------
 BATCH SIZE: 1 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115660272
 bench: no memcg, sheaves
 average (excl. iter 0): 95734972
 sheaves better by 17.2%
 bench: memcg, no sheaves
 average (excl. iter 0): 163682964
 bench: memcg, sheaves
 average (excl. iter 0): 144792803
 sheaves better by 11.5%

 ---------------------------------
 BATCH SIZE: 10 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115496906
 bench: no memcg, sheaves
 average (excl. iter 0): 97781102
 sheaves better by 15.3%
 bench: memcg, no sheaves
 average (excl. iter 0): 162771491
 bench: memcg, sheaves
 average (excl. iter 0): 144746490
 sheaves better by 11.0%

 ---------------------------------
 BATCH SIZE: 100 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 151796052
 bench: no memcg, sheaves
 average (excl. iter 0): 104641753
 sheaves better by 31.0%
 bench: memcg, no sheaves
 average (excl. iter 0): 200733436
 bench: memcg, sheaves
 average (excl. iter 0): 151340989
 sheaves better by 24.6%

 ---------------------------------
 BATCH SIZE: 1000 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 187623118
 bench: no memcg, sheaves
 average (excl. iter 0): 130914624
 sheaves better by 30.2%
 bench: memcg, no sheaves
 average (excl. iter 0): 240239575
 bench: memcg, sheaves
 average (excl. iter 0): 181474462
 sheaves better by 24.4%

 ---------------------------------
 BATCH SIZE: 10 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115110219
 bench: no memcg, sheaves
 average (excl. iter 0): 100597405
 sheaves better by 12.6%
 bench: memcg, no sheaves
 average (excl. iter 0): 163573377
 bench: memcg, sheaves
 average (excl. iter 0): 144535545
 sheaves better by 11.6%

 ---------------------------------
 BATCH SIZE: 100 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 152457970
 bench: no memcg, sheaves
 average (excl. iter 0): 108720274
 sheaves better by 28.6%
 bench: memcg, no sheaves
 average (excl. iter 0): 203478732
 bench: memcg, sheaves
 average (excl. iter 0): 151241821
 sheaves better by 25.6%

 ---------------------------------
 BATCH SIZE: 1000 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 189950559
 bench: no memcg, sheaves
 average (excl. iter 0): 177934450
 sheaves better by 6.3%
 bench: memcg, no sheaves
 average (excl. iter 0): 242988187
 bench: memcg, sheaves
 average (excl. iter 0): 221609979
 sheaves better by 8.7%

Vlastimil

---
Changes in v6:
- Applied feedback and review tags from Suren and Harry (thanks!)
- Separate patch for init_kmem_cache_nodes() error handling change.
- Removed the more involved maple tree conversion to be posted as a
  separate followup series.
- Link to v5: https://patch.msgid.link/20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz

Changes in v5:
- Apply review tags (Harry, Suren) except where changed too much (first
  patch).
- Handle CONFIG_SLUB_TINY by not creating percpu sheaves (Harry)
- Apply review feedback (typos, comments).
- Extract handling sheaf slow paths to separate non-inline functions
  __pcs_handle_empty() and __pcs_handle_full().
- Fix empty sheaf leak in rcu_free_sheaf() (Suren)
- Add "allow NUMA restricted allocations to use percpu sheaves".
- Add Liam's maple tree full sheaf conversion patches for easier
  evaluation.
- Rebase to v6.16-rc1.
- Link to v4: https://patch.msgid.link/20250425-slub-percpu-caches-v4-0-8a636982b4a4@suse.cz

Changes in v4:
- slub_debug disables sheaves for the cache in order to work properly
- strict_numa mode works as intended
- added a separate patch to make freeing remote objects skip sheaves
- various code refactoring suggested by Suren and Harry
- removed less useful stat counters and added missing ones for barn
  and prefilled sheaf events
- Link to v3: https://lore.kernel.org/r/20250317-slub-percpu-caches-v3-0-9d9884d8b643@suse.cz

Changes in v3:
- Squash localtry_lock conversion so it's used immediately.
- Incorporate feedback and add tags from Suren and Harry - thanks!
  - Mostly adding comments and some refactoring.
  - Fixes for kfree_rcu_sheaf() vmalloc handling, cpu hotremove
    flushing.
  - Fix wrong condition in kmem_cache_return_sheaf() that may have
    affected performance negatively.
  - Refactoring of free_to_pcs()
- Link to v2: https://lore.kernel.org/r/20250214-slub-percpu-caches-v2-0-88592ee0966a@suse.cz

Changes in v2:
- Removed kfree_rcu() destructors support as VMAs will not need it
  anymore after [3] is merged.
- Changed to localtry_lock_t borrowed from [2] instead of an own
  implementation of the same idea.
- Many fixes and improvements thanks to Liam's adoption for maple tree
  nodes.
- Userspace Testing stubs by Liam.
- Reduced limitations/todos - hooking to kfree_rcu() is complete,
  prefilled sheaves can exceed cache's sheaf_capacity.
- Link to v1: https://lore.kernel.org/r/20241112-slub-percpu-caches-v1-0-ddc0bdc27e05@suse.cz

---
Liam R. Howlett (1):
      tools/testing: Add testing support for slab caches with sheaves

Vlastimil Babka (9):
      slab: simplify init_kmem_cache_nodes() error handling
      slab: add opt-in caching layer of percpu sheaves
      slab: add sheaf support for batching kfree_rcu() operations
      slab: sheaf prefilling for guaranteed allocations
      slab: determine barn status racily outside of lock
      slab: skip percpu sheaves for remote object freeing
      slab: allow NUMA restricted allocations to use percpu sheaves
      mm, vma: use percpu sheaves for vm_area_struct cache
      maple_tree: use percpu sheaves for maple_node_cache

 include/linux/slab.h         |   47 ++
 lib/maple_tree.c             |    9 +-
 mm/slab.h                    |    4 +
 mm/slab_common.c             |   32 +-
 mm/slub.c                    | 1669 ++++++++++++++++++++++++++++++++++++++++--
 mm/vma_init.c                |    1 +
 tools/include/linux/slab.h   |   41 +-
 tools/testing/shared/linux.c |   12 +-
 8 files changed, 1753 insertions(+), 62 deletions(-)
---
base-commit: 82efd569a8909f2b13140c1b3de88535aea0b051
change-id: 20231128-slub-percpu-caches-9441892011d7

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


