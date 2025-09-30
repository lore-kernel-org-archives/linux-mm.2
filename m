Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D54FCCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1109E8E0006; Tue, 30 Sep 2025 02:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8DD8E0002; Tue, 30 Sep 2025 02:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40508E0006; Tue, 30 Sep 2025 02:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E21EF8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:29:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80E3559C91
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:29:43 +0000 (UTC)
X-FDA: 83944940646.25.95C8AD1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34FDFC0003
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:29:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f7xMPfnb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ShD/p6qE";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wiVh9eOe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aT5ul2I3;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759213781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RT4ikoPiu1GKw0GJ4C6YZ+YgJFJplSow/rFnnKpuRBU=;
	b=pUYexut5hObr950XFM7vi9qJFTW+hHQCsdfpQqF18ksHbZ6UEl9sag2VAB5Bn0bbpQyaXz
	nKVoe2mUvD4uyKv7s3VmJLguqiZmSjWTXYaNxly3OttJD/9R/FckMV1/ZoY/Bgi3//5mf5
	tnPQb1X2TX7zS9xMsfttH3jrduiZ8vE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=f7xMPfnb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ShD/p6qE";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wiVh9eOe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aT5ul2I3;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759213781; a=rsa-sha256;
	cv=none;
	b=Ny8MCuqG4Y/Ee14G7xOUikMuwl+n9b/ouW0vBqDxMSrv6tPV682Kc6aFc7ZQBCEeW9N0WL
	euLo1S1KW9BVlfJ+kAlJo5xnzvia4SEJuLH9N5T/PeIHpjPwzUKozFzSFsSQ5Xn4r7TrR0
	sfLUO9V45yW8IYIwtFgxjDy8TaTwNak=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E997E1F7A1;
	Tue, 30 Sep 2025 06:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759213779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=RT4ikoPiu1GKw0GJ4C6YZ+YgJFJplSow/rFnnKpuRBU=;
	b=f7xMPfnbjqcvMj6LlQytfOthTDuFpR/ot/ELVqkimj7eXymHafXV3IUG/h2MPrxNtYWEPY
	TOnKnyDPwXxSi+3odlct4ivdV3McVd3+EBodYq4+Weg6+LIbenJtUrYTZreC2Ro6WIUbtV
	PAK8v3+4w43PBQU+yV5bZ1roWSytWL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759213779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=RT4ikoPiu1GKw0GJ4C6YZ+YgJFJplSow/rFnnKpuRBU=;
	b=ShD/p6qEp/oh0BzeyBnLuXM1Y+ISEze8vQYkoT1p3MFn2SS9y8O1QKHh+UbsQ+BssBd14Y
	34vszcbAaujo2pCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759213778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=RT4ikoPiu1GKw0GJ4C6YZ+YgJFJplSow/rFnnKpuRBU=;
	b=wiVh9eOeSv+2Id1HE2L5yvPYsEq9XeunqIXLoIIiQ7kJ8/VUajfQLHO+mOILdyROlKP5ig
	wPgzTEL3zXO/K3cB3Aab9aM3gRkp0dq2if88MhLOFWZsCN+h9f2RvpcNv+u6R3u4UlfdJu
	nP/qjUijED6TTfjHZbsOuMF4ue2iKzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759213778;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=RT4ikoPiu1GKw0GJ4C6YZ+YgJFJplSow/rFnnKpuRBU=;
	b=aT5ul2I3PLxGMJagsOHM+BaJcKZNvJZclkZiu8a8tit1uy5C9oWaYW877ZC1ks5nT+avGS
	vuvggWFQDxBF+7Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE8E213A3F;
	Tue, 30 Sep 2025 06:29:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MVANMtJ422gHPQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 30 Sep 2025 06:29:38 +0000
Message-ID: <5dc1b53d-29fb-42f6-9fff-d6b42da17a7f@suse.cz>
Date: Tue, 30 Sep 2025 08:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 6.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Pedro Falcato <pfalcato@suse.de>, Alexei Starovoitov <ast@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34FDFC0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: w6t4i7dqy94o3qtds8s9wur3grad8gur
X-HE-Tag: 1759213780-94134
X-HE-Meta: U2FsdGVkX19jO2f8ryKL922feHaTk3gYSAeBnKcEf9MJh4WGU+Wb5cXVn/8cN+IjFgmPqob8jX3EtEFTJlb5Nc2L/hy9C8Vr/2OgFWjA9NDM4En8imiKWabDitMlPsAe9s7O3cSkEOtKTfDQ8keDPQYcNbRkVelMa4RqL+69leD2q1lORIJr6rGTSStf+cFPt3AQCYlWK4xm4u9d/l+B2dq3UBcWKoq42/DMhqMvs4uFVhZprN8e8D3JC0GPUSMQ5DLxtyviPFc8n+22xhvq8ISFQ7Gj0b5t15ATU+k/VNspaR05GgDe/Vk+BdHOGcy55pIt2rZlR4ibtCMFgPyfX/9Njt/PgiQmh9k1xSwS7Cjxrd2Fwq7nht6A4M9bP6oVIBDcR0yW2EvNC3zWOKMxcUFf+8bHU7how+QsYtk4yI+AdjThMS7j6tZVutxxlUI4qGgpElsznlzTg/BrdsTYoW9b8+f9JLjtVp+ixg75xrum7VDk82fCFcG6nQYubEeHip+XBUf8htXzYWCrLSA/gp0gU7D+NxOs+qYfV6kUt62+DUz8zNa4RjI13DIIxajBWX3xC8Xg34JVSigb9lJsS+M3geke0BAZc5ngPM8BWSoZ7zzOYwchlGIuq7r8o6qscZbevovtB2RVOuiU4l60lN4f6oJRQIiGnfc0xtDehWJ/LTDKhPncNC/muXwX5+CPTzBMRecb0s4QJVVzRGQpfiooxRcLHc4773TmH8RcZf+HnmaA3UzPge2KDmVV2klyCUUffZZxlnBkf7NQzrgZA0wWljpySqyuMT5CsiBw0CCfd66J6Bd4jtWfDIINHvhyYGvpHUmsQoy3bTO7kPoBINH/lTPzj3DuWxinjiy68JvygLAz+lqxS41SQ3lWrMMhhOcs2z2We7dA6IsZUmO5oZH9RObtNPBewKzWDw6MvFPhHW6hq7Z52FwfCMCEvlbKueB/oHR9PJg2BHzmFN/
 kEyHPwYU
 MzuxDpbBNdcIS9G9w6KJKZt5ltChkBq7W0HXncWsQWNu52i6FOazMbAfvcxM7Lo3DGsYhm3va2MoD5M0veQ4LVpjEhiPqwH8Q+cipmfB3hcKInAYFCoEcm2ock1s9EcWOmGHgw1FHmhXJI8tC1aZCYSxev8sGnCKDpyULZnnohKzAi5yQ3pCfLc3CvsK3td6nBx/S3Qu69KjSu5Qyj1H2JfUSXJzMQu8IBR178kz0TpavckKviKDd0FOONniazhLBCTrSr4AI3PVl69EQQUQ8o7TIGEmZBlLcaLOYzK82F7jpB6bDZ4/yql2acDBk5/4rHRC3dIwd6ZQaaGAL1unFIGXa1eVfGa95Pdu+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18

This time we have two rather large features - a new percpu caching scheme and
re-entrant kmalloc_nolock(), along with the usual fixes and cleanups.

To avoid conflicts with mm tree, the patches from Lorenzo and Qianfeng are part
of this pull although normally they would be in mm tree. There should be no
conflicts.

Thanks,
Vlastimil

======================================

* A new layer for caching objects for allocation and free via percpu arrays
  called sheaves. The aim is to combine the good parts of SLAB (lower-overhead
  and simpler percpu caching, compared to SLUB) without the past issues with
  arrays for freeing remote NUMA node objects and their flushing. It also
  allows more efficient kfree_rcu(), and cheaper object preallocations for
  cases where the exact number of objects is unknown, but an upper bound is.

  Currently VMAs and maple nodes are using this new caching, with a plan to
  enable it for all caches and remove the complex SLUB fastpath based on cpu
  (partial) slabs and this_cpu_cmpxchg_double(). (Vlastimil Babka, with Liam
  Howlett and Pedro Falcato for the maple tree changes)

* Re-entrant kmalloc_nolock(), which allows opportunistic allocations from NMI
  and tracing/kprobe contexts. Building on prior page allocator and memcg
  changes, it will result in removing BPF-specific caches on top of slab.
  (Alexei Starovoitov)

* Various fixes and cleanups. (Kuan-Wei Chiu, Matthew Wilcox, Suren
  Baghdasaryan, Ye Liu)

----------------------------------------------------------------
Alexei Starovoitov (7):
      locking/local_lock: Expose dep_map in local_trylock_t.
      locking/local_lock: Introduce local_lock_is_locked().
      mm: Allow GFP_ACCOUNT to be used in alloc_pages_nolock().
      mm: Introduce alloc_frozen_pages_nolock()
      slab: Make slub local_(try)lock more precise for LOCKDEP
      slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
      slab: Introduce kmalloc_nolock() and kfree_nolock().

Kuan-Wei Chiu (2):
      mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
      mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting

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

Matthew Wilcox (Oracle) (1):
      slab: Remove dead code in free_consistency_checks()

Pedro Falcato (2):
      maple_tree: Use kfree_rcu in ma_free_rcu
      maple_tree: Replace mt_free_one() with kfree()

Qianfeng Rong (1):
      maple_tree: remove redundant __GFP_NOWARN

Suren Baghdasaryan (2):
      slab: prevent warnings when slab obj_exts vector allocation fails
      slab: mark slab->obj_exts allocation failures unconditionally

Vlastimil Babka (17):
      slab: wrap debug slab validation in validate_slab_ptr()
      slab: move validate_slab_ptr() from check_slab() to its callers
      slab: move validate_slab_ptr() from alloc_consistency_checks() to its caller
      slab: validate slab before using it in alloc_single_from_partial()
      slab: don't validate slab pointer in free_debug_processing()
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
      Merge series "SLUB percpu sheaves"
      Merge series "slab: Re-entrant kmalloc_nolock()"

Ye Liu (1):
      mm/slub: Refactor note_cmpxchg_failure for better readability

 include/linux/gfp.h                 |    2 +-
 include/linux/kasan.h               |   13 +-
 include/linux/local_lock.h          |    2 +
 include/linux/local_lock_internal.h |   16 +-
 include/linux/maple_tree.h          |    6 +-
 include/linux/memcontrol.h          |   12 +-
 include/linux/rtmutex.h             |   10 +
 include/linux/slab.h                |   51 +
 kernel/bpf/stream.c                 |    2 +-
 kernel/bpf/syscall.c                |    2 +-
 kernel/locking/rtmutex_common.h     |    9 -
 lib/maple_tree.c                    |  667 +----
 lib/test_maple_tree.c               |  137 -
 mm/Kconfig                          |    1 +
 mm/internal.h                       |    4 +
 mm/kasan/common.c                   |    5 +-
 mm/page_alloc.c                     |   55 +-
 mm/slab.h                           |   20 +-
 mm/slab_common.c                    |   37 +-
 mm/slub.c                           | 5479 ++++++++++++++++++++++++-----------
 mm/vma_init.c                       |    1 +
 tools/include/linux/slab.h          |  165 +-
 tools/testing/radix-tree/maple.c    |  514 +---
 tools/testing/shared/linux.c        |  120 +-
 tools/testing/shared/maple-shared.h |   11 +
 tools/testing/shared/maple-shim.c   |    7 +
 tools/testing/vma/vma_internal.h    |  259 +-
 27 files changed, 4462 insertions(+), 3145 deletions(-)

