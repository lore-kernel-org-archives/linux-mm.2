Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFCECAC592
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86308E000A; Wed, 10 Sep 2025 04:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36748E0002; Wed, 10 Sep 2025 04:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF5C8E000A; Wed, 10 Sep 2025 04:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B71C18E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5E87D1DF5D1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:23 +0000 (UTC)
X-FDA: 83872595646.25.8148EBA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 310F94000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HFDUviSa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qFYAXkHo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AOHFTY2I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1QB5D7Pb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DfNSZoRQUEbIZ919Q3tmHajYzGdlCD0YabiFVazjaCA=;
	b=TpbsKMirwVE7Dp8/njHE81rafoHJ1YJ0W1QfUpvCcZkFX5gdd1OUB4I2+RkIv04D2rpa8l
	Z9Gl8zmK6qvi4DYcjzuvPtnxoHKKgLso80wmp4r+gwBnSuoAp353OFGj9peva9L7y5IpYy
	x1MQfrE82CFIf6Mh0raq4TenXQoqCYQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HFDUviSa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qFYAXkHo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AOHFTY2I;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1QB5D7Pb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491281; a=rsa-sha256;
	cv=none;
	b=lYmrLC2Z7uuNy46u3zWTDi/1gJy9/xbi/cBPK/0TmCkyhcnCJPotw6l6x+0yUKrhBEjmhG
	DJeVAgb4K7BTR6MGJLE+0rDaPXSfSObBGrpc7oY5D6BMcD7lbJdq63lxb2YLUGGh5yexaa
	1kqRM8VbXW0ty3kL/eV3glVEQTwJFZo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B26235C9FD;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DfNSZoRQUEbIZ919Q3tmHajYzGdlCD0YabiFVazjaCA=;
	b=HFDUviSaaEB7145nwYvujVa4toZ/FGTQeJsQFLztwiRWqfte9eyVou7RBsdycxuFkRnnDD
	u3w1hvF2p6hsbPVd683nrorZpRBFaMb86KlfwnIYUh1hmYPPZPsxYMATesS7ArEOBe+Wma
	c2rwpGSHgC7mvszjpQtW1bfO+RW1nhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DfNSZoRQUEbIZ919Q3tmHajYzGdlCD0YabiFVazjaCA=;
	b=qFYAXkHo0xtf3gTUTS2bLSzWcKd/st7Cwvm15OiduRP9RC0yO05Md2itQCyMsgERQmdEWr
	MmAzdpasMQFjnHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491265; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DfNSZoRQUEbIZ919Q3tmHajYzGdlCD0YabiFVazjaCA=;
	b=AOHFTY2IWBGwZJjuOj6MGYON90SeSvIjajxJy1swBBnszUAN+mPUytuqdsHjdIx9v8Z+56
	V7iRWWtW8jUYyHt+iLn7GQXEaMnHPNu/bBclhXknNqHsPk4oowmFNOo+hc3qYng3/cm+qu
	hZjEXzVjV+YID1zlOs3eYYcSPGVdnFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491265;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DfNSZoRQUEbIZ919Q3tmHajYzGdlCD0YabiFVazjaCA=;
	b=1QB5D7PbpyUceyIO+BSAW0ELuFpVpigTyK/vurxdHVNcKX+oRMgEKfenPSeY9ouMhXCcqS
	bBxY0meqRkRDhhAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AFE313310;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xl+dIUEwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:05 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v8 00/23] SLUB percpu sheaves
Date: Wed, 10 Sep 2025 10:01:02 +0200
Message-Id: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD8wwWgC/23Sy07DMBAF0F9BWWM0M36z4j8QCz/GNII2JW4jH
 uLfcahoiJTlLObojn2/uspjz7W7v/nqRp762g+HNrjbmy7twuGZRZ/b3BGQRCQn6us5iiOP6Xg
 WKaQdV+GVQucJELPt2uJx5NK//6KPT20u47AXp93I4UqBQ0AjDdk7Q2CEF1MM8SU81HPlu/Q5M
 7u+nobx4zfahDM2rypsMbZSTChA5Jwg5kSWQV+tOcNEf4AGQrUJUAOc056YwRsT1oBcAIl2E5A
 N8Nk7p7KLRsk1oBZAkd4E1JwgtHfxjqIKag3oBbAkNwHdgGg9pewkFJ3XgFkAR9snmAYUKNbqI
 IuVZQ3YBfCwncA2wGJCVClz4X/A96UaI7+dW81Ol350MVQWadjv+1OrHXHJ2vjgPPhCESUqSBh
 l5vYxUgcOEEFjw75/ABCCUPy7AgAA
X-Change-ID: 20231128-slub-percpu-caches-9441892011d7
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 Alexei Starovoitov <ast@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
 Qianfeng Rong <rongqianfeng@vivo.com>, Wei Yang <richard.weiyang@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 WangYuli <wangyuli@uniontech.com>, Jann Horn <jannh@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 310F94000A
X-Stat-Signature: tprcem4pz7srxeneherrgwyu9b4n4pfr
X-HE-Tag: 1757491280-555139
X-HE-Meta: U2FsdGVkX19zajKuQuH93VVhlcy3hoOGyLcb4fb4QyRn2TE1l+PgRPzfppUaNjFP4i1Z1y1OoyhuKseAyt5oj8fr5uz67MjSxdxafllb2j5DFzj1L/WXSfy7lSeB5H6r5q57xJUyAvvoKau1qEkVoRYtn+nt5J2+HNyYts4D4hfpeaGZOJC5XmNq+huXOpxC7Aha0L3107dKs96iaQUEpR9jDaQkSMTek76Nrt8z4n1nbugjc/H+9HUKmt1mlzQxVW683QpZzhSCBAlDM1xFZf2RESHErFj2ZDO/EnFn7wNV+WteqpLIYEnvLSAN/t4yblwIFNVEZknBkjMRx3jFKDqyWcYEQ2c/GbXRw9roZSg+pc/gzSeaGBNvWRF4NZrfnWAtlgL9dH7V45INf9KYMDWcYKiyNrT7/Rnu1Tp9nnpgrCHviTPAT2e20YUXMA98AYUp5iaSoMGIsIul3TeLqC+ev0O3zBYSp4NPoA71RH0Yx+ygBrQbXUGDjsdKdjAqpeYt7zUX+VEB50PFylZmmf9PPJCQBH9ssO09NnSoX3C5mHI4a10RBZGHvHiYjB0QRbMv+XUbQ1X6Svg5+v+hGIcWkeVDDURz4B1dKeOwV4brUtaYudGKZNfQv9aXtNVOyQmVt8KuEuqAvGHZ/jPIA14zjZMyNSHo9IIFPJIO2JXpmeBywER8PyK62nPeodIF5fhaIytZTDe2bhm6vSFZF49P1n4NPLIfv4+Oc2UUQYADGkhwbqr2rxH3DbbFFJ4372FgQv7/uvurs11u3EZ4UeEzWu8iUlDCdQoY6o7Ama2JO9NpcSWE5ECoIYEWu5mZs+R9udScef3PCqkwYcfbbzV+CXTwzoJKZ8iquCFk0bRr4G0B9OTvSkwJvDWB+Iy4GdEO9j9W3d0+M5AwcZ8vMMX5tZNaoByoCOhuUsz/Q1ZmlVROSvPar9ze+Vt6m358Wh1MEB0FKlFouCNDC0F
 v6W8+szK
 NjDNU4jja6zW7iNOq0cFil2SnWVMoInEHF364cCDP7m3Xdakm4COCsL49cEcXEfsd/MW27mrFtbUUy+WM/D/oRFx0O1g3pZnbcIKWwXDYmW6Ju9NgvgqEGy9fbUryRiCNxMXZUGlnzR2USk0g54Xz3boRi0MCS36/PiAr4xLo1I06IOvkg72mbYBZ/S23bSAdMhZCtQXmUHGXxSSVkSKsqgAtp74BMy8SGseRxTN79SpyKHrXAnwwTbGrPHka/pu97e6+R1N6pVruaIdD5AUIbNqmprqIrePFhkfZoTnvVdsv8YbrRtXrmILGDuTiSy3OE4lcr/uelacxK7lLEGKU2HIoMTPkT65iLvOL2Zaah/sZlkMSCNYUqh3iw6NHs6TJ6i32c2omxU1rXHImV9vagihML/CXtqCYAzepGeXcWMPCSsIQcsqcBndcs9z4FRGSGUR3R+nM4kyOUb5OTNUKPlsOhG7il4PPcsuh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I'm sending full v8 due to more changes in the middle of the series that
resulted in later patches being fixed up due to conflicts (details in
the changelog below).
The v8 will replace+extend the v7 in slab/for-next.

===

This series adds an opt-in percpu array-based caching layer to SLUB.
It has evolved to a state where kmem caches with sheaves are compatible
with all SLUB features (slub_debug, SLUB_TINY, NUMA locality
considerations). My hope is therefore that it can eventually be enabled
for all kmem caches and replace the cpu (partial) slabs.

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
  Note: this path is currently limited to !PREEMPT_RT

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

this series: https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v8r2
It is based on v6.17-rc3.

this series plus a microbenchmark hacked into slub_kunit:
https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v8-benchmarking

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
Changes in v8:
- Liam provided a new patch "maple_tree: Drop bulk insert support" as
  the bulk insert was broken in v7 (not used anywhere but broke its
  internal tests) This has changed the context for later patches somewhat.
- Fix issues with "slab: add sheaf support for batching kfree_rcu()
  operations" reported by Ulad:
  - obtaining empty sheaf from kfree_rcu() is potentially dangerous on
    PREEMPT_RT - disable using rcu_free sheaves there for now
  - kvfree_rcu_barrier() must flush all rcu_free sheaves
  - dropped R-b's from Suren and Harry due to these changes being
    nontrivial
  - Added some R-b's
- Incorporated two patches originally in mm tree to avoid conflicts:
  - "maple_tree: remove redundant __GFP_NOWARN"
  - "tools/testing/vma: clean up stubs in vma_internal.h"
- Link to v7: https://patch.msgid.link/20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz

Changes in v7:
- Incorporate Alexei's patch for local_trylock_t to fix
  lockdep_assert_held() on RT, reported by Thorsten.
  Patch: https://lore.kernel.org/all/20250718021646.73353-2-alexei.starovoitov@gmail.com/
- Remove pcs->barn pointer to fix boot failures reported by Venkat:
  https://lore.kernel.org/all/866d7f30-7cde-4c88-87ba-bdad16075433@linux.ibm.com/
  This was because initializing it for all possible cpus can get bogus
  nid values from cpu_to_mem() for non-online cpus.
  Instead introduce get_barn() to obtain it from node, the fast paths
  are not affected anyway. Otherwise cpu hotplug online callback would
  be necessary and I haven't found a cpuhp state that would satisfy all
  the constraints (including being safe to take slab_mutex).
  The draft fix patch from the bug report thread is effectively squashed
  into several of the sheaves patches.
- Incorporate maple tree patches posted separately here:
  https://lore.kernel.org/all/20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz/
  Everything is reordered so that vma and maple userspace tests compile
  and pass at every step (fixes a broken vma test report from Lorenzo).
  Add tags from Sid for two of the patches there.
- Link to v6: https://patch.msgid.link/20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz

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
Alexei Starovoitov (1):
      locking/local_lock: Expose dep_map in local_trylock_t.

Liam R. Howlett (8):
      maple_tree: Drop bulk insert support
      tools/testing/vma: Implement vm_refcnt reset
      tools/testing: Add support for changes to slab for sheaves
      testing/radix-tree/maple: Hack around kfree_rcu not existing
      tools/testing: Add support for prefilled slab sheafs
      maple_tree: Prefilled sheaf conversion and testing
      maple_tree: Add single node allocation support to maple state
      maple_tree: Convert forking to use the sheaf interface

Lorenzo Stoakes (1):
      tools/testing/vma: clean up stubs in vma_internal.h

Pedro Falcato (2):
      maple_tree: Use kfree_rcu in ma_free_rcu
      maple_tree: Replace mt_free_one() with kfree()

Qianfeng Rong (1):
      maple_tree: remove redundant __GFP_NOWARN

Vlastimil Babka (10):
      slab: simplify init_kmem_cache_nodes() error handling
      slab: add opt-in caching layer of percpu sheaves
      slab: add sheaf support for batching kfree_rcu() operations
      slab: sheaf prefilling for guaranteed allocations
      slab: determine barn status racily outside of lock
      slab: skip percpu sheaves for remote object freeing
      slab: allow NUMA restricted allocations to use percpu sheaves
      mm, vma: use percpu sheaves for vm_area_struct cache
      maple_tree: use percpu sheaves for maple_node_cache
      tools/testing: include maple-shim.c in maple.c

 include/linux/local_lock_internal.h |    9 +-
 include/linux/maple_tree.h          |    6 +-
 include/linux/slab.h                |   47 +
 lib/maple_tree.c                    |  667 +++----------
 lib/test_maple_tree.c               |  137 ---
 mm/slab.h                           |    5 +
 mm/slab_common.c                    |   34 +-
 mm/slub.c                           | 1761 +++++++++++++++++++++++++++++++++--
 mm/vma_init.c                       |    1 +
 tools/include/linux/slab.h          |  165 +++-
 tools/testing/radix-tree/maple.c    |  514 +---------
 tools/testing/shared/linux.c        |  120 ++-
 tools/testing/shared/maple-shared.h |   11 +
 tools/testing/shared/maple-shim.c   |    7 +
 tools/testing/vma/vma_internal.h    |  259 ++----
 15 files changed, 2282 insertions(+), 1461 deletions(-)
---
base-commit: 82efd569a8909f2b13140c1b3de88535aea0b051
change-id: 20231128-slub-percpu-caches-9441892011d7

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


