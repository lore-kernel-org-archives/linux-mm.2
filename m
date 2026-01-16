Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99FA7C982C9
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9378F6B0089; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF776B0092; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA366B008A; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0106B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6E03C01FD
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:40 +0000 (UTC)
X-FDA: 84338088240.17.FF1FBF0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 754261C0011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W2cXZQcE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQqovt8b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W2cXZQcE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQqovt8b;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D8kSMH2gta+Yma3QMnDCuvguK/0toKW9byQx/lVBXFU=;
	b=0h0rzJmdRwCMdk+OHysInh5xu/OTNCojzkOL1E/jsqfiimTuL7RHX65VgQQ2K9pIWm3n+K
	fnTW+D6sL+s9XHL/ScVRE/UKAAi4X7i56fFr6jetqQ3TM14fgdOai2uUsXos0ei7s8HRDB
	YAhMQJVQerEJP73dUGoHqMxHD7awOh0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W2cXZQcE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQqovt8b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=W2cXZQcE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mQqovt8b;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574438; a=rsa-sha256;
	cv=none;
	b=v/MY5KPUkikSa4b6uLL+rMGLxilXxziSLZhtcMQRlqYqbiq61FcydaLAawPr+M2PR/6HVM
	BjVY4iioB30rViSadvi4zlhH0FmBXO7GiW2CsyrWys6xqAABpIvvgPJNptIPaGDedB96kK
	Nt+TE7fUtPSfNoB1nwhT/Hex3+Hz44s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C65233789;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D8kSMH2gta+Yma3QMnDCuvguK/0toKW9byQx/lVBXFU=;
	b=W2cXZQcEu58tSojqQz9KrhUQuTTHIf2SZB58nYl5bifW0498hXY2R8FUkgVcUCV3D4aHSc
	7Vp96ID2AwEdP+Oq8p6TTHOsU6eNo2KQ9+IKdfqboaDiIF+T37UWYQvfa+Fw7ZGNPduSSj
	wppsJ6GqSXVZEsXbtfGkwnbrK81hX34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D8kSMH2gta+Yma3QMnDCuvguK/0toKW9byQx/lVBXFU=;
	b=mQqovt8blj77FthhSHtvbjI5Mo4ea5I324sOFniBk/DkDhDDHK0u7NoVURt7NmD9/e1Ur1
	KiJ38IwZcc3cRBDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D8kSMH2gta+Yma3QMnDCuvguK/0toKW9byQx/lVBXFU=;
	b=W2cXZQcEu58tSojqQz9KrhUQuTTHIf2SZB58nYl5bifW0498hXY2R8FUkgVcUCV3D4aHSc
	7Vp96ID2AwEdP+Oq8p6TTHOsU6eNo2KQ9+IKdfqboaDiIF+T37UWYQvfa+Fw7ZGNPduSSj
	wppsJ6GqSXVZEsXbtfGkwnbrK81hX34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D8kSMH2gta+Yma3QMnDCuvguK/0toKW9byQx/lVBXFU=;
	b=mQqovt8blj77FthhSHtvbjI5Mo4ea5I324sOFniBk/DkDhDDHK0u7NoVURt7NmD9/e1Ur1
	KiJ38IwZcc3cRBDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46A2D3EA63;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sj7VEORNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:36 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v3 00/21] slab: replace cpu (partial) slabs with sheaves
Date: Fri, 16 Jan 2026 15:40:20 +0100
Message-Id: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANVNamkC/2WOQQ6CMBBFr0K6tqYdKIIr72Fc1GEqTQiQjjYq4
 e4WonHB8k3y3p9JMAVPLI7ZJAJFz37oE+S7TGBr+xtJ3yQWoMBopUBySzYSSzcEabtOVqVFnTd
 YHKwRyRoDOf9ci+dL4tbzfQivdSDq5fptQb5pRS2VLJ2zgHVdaFQnfjDt8S2WUoSfXSqtt59ES
 HZdARh0V6PQ/e15nj//IYhq6gAAAA==
X-Change-ID: 20251002-sheaves-for-all-86ac13dc47a5
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 754261C0011
X-Stat-Signature: tywyg1rj96gacb1n7deorj8msmnc4rhw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768574438-534190
X-HE-Meta: U2FsdGVkX19mbDh+xLX8MJ3+mv/C2MiJB92XLahKprCzJFujbAHaliCH5d9rjAfNYyzEIKVnEzdOdp5tZ+Gg3rPFQLKgydpmycU5l3hycIdC2gtngM9Cjt/KVRzBStvM8lZLtrD4NTVI2Is287qcVFKcRZNtoK1ghkB+EbPESOYdjRnroF9hy0yOWrc1088SmZxoR6rdQGO5DTj/whjJEagx8lxvUSL5BV0FxoYIVKOeTYN+E66seLarvE9SQJbzeslZXd8Glwya5YXJ437nMowyNdHeLOsoDbM8J3I+d5wbYHLM28Fd/XSOCTNiONmJyZ8l/ZcdAemoLIRJNTqtfly+TLXRUPP1QxGE9EUhPLxvNdf7/IMEvQ0hKrZYh6S+23y3fhBlh0sJzXUyz/N9dhxnJx2xfB+GiEJVTu4UWPPHEpTJIM5WY3VHFunMbunlxe8i5bFxzmhk2HUUhpg9OmP+Mm3+g+vmzsxYJgtfML9tWGP1GsrPAdClfO12XJD+vFJP/KUu88V3ZlCd2fJoQDT28Jm/m3fpOEGXwZ0iaF0jE9DUKGlxrDWjkRQL/e7/mL1o/gg0GON4N60fxvXllkG3YRp9vHB/IxwYDrtINe2ui/cGZl07ZOtgJ7Y5skqasfiF47p79p+ztkph5jyNhALeq0OCGrdQkdfUfHn+/T1VBII2mXaCjuTgrBKrQMkGfvxhMIAf0se4GDKRk7rpbHbz9cRnmrKgFDVOEs9dW/27+cuM8arMlX0XcSzP764Jm9YZ5iukLJDLZBPnwAPuG+4xLYJvEevRVmw01Tm5YCzL/4ZaoQmfpyqmtOysIOCdLtsc4o+Bym7vWtVu8gGk6LOKqwHqA5V2c0f6Y6KdPLmK8j4/gmXg2c8ugKQAwt/0H9StcmjuXxX3ZVEZDDBFJFZALnGoRkVHIHdV7nKoUBCCeFThKkVNT9diWhczRer3MEJYRZYNScOZeyLDbkG
 hRJkVX2C
 luluCLd4ucgx5/40wF1L4smxBGwzosfGbyqvH+CVX3Hv6O19GPU6bE1UDekC4Oz75YbQibHnrY8dbJlZ10iUFD+alIfmfS1CQjE+YeHJoBfBRQLwzDEyUC3qs5OLT72sRkGy2GWiFCNLduVnz9D3NxCcXaAYRyd0Y3XGxJRi4l6OxPDbTULGqUGtSkqFdzw2mUAggyZ4Kcx7aZD3FxAuKUG979lxbrqbiq96QqoMhKmufZDNNUM5CNi90H+SaggSxMrkzj9Izv2Ef2auZNH2kdOGP0BkVA/68uUrwdAHHjcX2ZGs0cLaL+L0lUbzq6EbYs2g6uAvaMiMNkKNcjqJ3bjySDXLERoLOniM7ps0mZ1vrk5FiU1/82VK8DZfUYVuUGlo/oyoXN2wZYaNArTVbxR/AHzvH/2L2M446ZSCZFK/E/ZJ9fm1UwxxNEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Percpu sheaves caching was introduced as opt-in but the goal was to
eventually move all caches to them. This is the next step, enabling
sheaves for all caches (except the two bootstrap ones) and then removing
the per cpu (partial) slabs and lots of associated code.

Besides (hopefully) improved performance, this removes the rather
complicated code related to the lockless fastpaths (using
this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
kmalloc_nolock().

The lockless slab freelist+counters update operation using
try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
without repeating the "alien" array flushing of SLUB, and to allow
flushing objects from sheaves to slabs mostly without the node
list_lock.

This v3 is the first non-RFC (for real). I plan to expose the series to
linux-next at this point. Because of the ongoing troubles with
kmalloc_nolock() that are solved with sheaves, I think it's worth aiming
for 7.0 if it passes linux-next testing.

Git branch for the v3
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=sheaves-for-all-v3

Which is a snapshot of:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/sheaves-for-all

Based on:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves
  - includes a sheaves optimization that seemed minor but there was lkp
    test robot result with significant improvements:
    https://lore.kernel.org/all/202512291555.56ce2e53-lkp@intel.com/
    (could be an uncommon corner case workload though)
  - includes the kmalloc_nolock() fix commit a4ae75d1b6a2 that is undone
    as part of this series

Significant (but not critical) remaining TODOs:
- Integration of rcu sheaves handling with kfree_rcu batching.
  - Currently the kfree_rcu batching is almost completely bypassed. I'm
    thinking it could be adjusted to handle rcu sheaves in addition to
    individual objects, to get the best of both.
- Performance evaluation. Petr Tesarik has been doing that on the RFC
  with some promising results (thanks!) and also found a memory leak.

Note that as many things, this caching scheme change is a tradeoff, as
summarized by Christoph:

  https://lore.kernel.org/all/f7c33974-e520-387e-9e2f-1e523bfe1545@gentwo.org/

- Objects allocated from sheaves should have better temporal locality
  (likely recently freed, thus cache hot) but worse spatial locality
  (likely from many different slabs, increasing memory usage and
  possibly TLB pressure on kernel's direct map).

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Changes in v3:
- Rebase to current slab/for-7.0/sheaves which itself is rebased to
  slab/for-next-fixes to include commit a4ae75d1b6a2 ("slab: fix
  kmalloc_nolock() context check for PREEMPT_RT")
- Revert a4ae75d1b6a2 as part of "slab: simplify kmalloc_nolock()" as
  it's no longer necessary.
- Add cache_has_sheaves() helper to test for s->sheaf_capacity, use it
  in more places instead of s->cpu_sheaves tests that were missed
  (Hao Li)
- Fix a bug where kmalloc_nolock() could end up trying to allocate empty
  sheaf (not compatible with !allow_spin) in __pcs_replace_full_main()
  (Hao Li)
- Fix missing inc_slabs_node() in ___slab_alloc() ->
  alloc_from_new_slab() path. (Hao Li)
  - Also a bug where refill_objects() -> alloc_from_new_slab ->
    free_new_slab_nolock() (previously defer_deactivate_slab()) would
    do inc_slabs_node() without matching dec_slabs_node()
- Make __free_slab call free_frozen_pages_nolock() when !allow_spin.
  This was correct in the first RFC. (Hao Li)
- Add patch to make SLAB_CONSISTENCY_CHECKS prevent merging.
- Add tags from sveral people (thanks!)
- Fix checkpatch warnings.
- Link to v2: https://patch.msgid.link/20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz

Changes in v2:
- Rebased to v6.19-rc1+slab.git slab/for-7.0/sheaves
  - Some of the preliminary patches from the RFC went in there.
- Incorporate feedback/reports from many people (thanks!), including:
  - Make caches with sheaves mergeable.
  - Fix a major memory leak.
- Cleanup of stat items.
- Link to v1: https://patch.msgid.link/20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz

---
Vlastimil Babka (21):
      mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
      slab: add SLAB_CONSISTENCY_CHECKS to SLAB_NEVER_MERGE
      mm/slab: move and refactor __kmem_cache_alias()
      mm/slab: make caches with sheaves mergeable
      slab: add sheaves to most caches
      slab: introduce percpu sheaves bootstrap
      slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
      slab: handle kmalloc sheaves bootstrap
      slab: add optimized sheaf refill from partial list
      slab: remove cpu (partial) slabs usage from allocation paths
      slab: remove SLUB_CPU_PARTIAL
      slab: remove the do_slab_free() fastpath
      slab: remove defer_deactivate_slab()
      slab: simplify kmalloc_nolock()
      slab: remove struct kmem_cache_cpu
      slab: remove unused PREEMPT_RT specific macros
      slab: refill sheaves from all nodes
      slab: update overview comments
      slab: remove frozen slab checks from __slab_free()
      mm/slub: remove DEACTIVATE_TO_* stat items
      mm/slub: cleanup and repurpose some stat items

 include/linux/slab.h |    6 -
 mm/Kconfig           |   11 -
 mm/internal.h        |    1 +
 mm/page_alloc.c      |    5 +
 mm/slab.h            |   53 +-
 mm/slab_common.c     |   61 +-
 mm/slub.c            | 2631 +++++++++++++++++---------------------------------
 7 files changed, 972 insertions(+), 1796 deletions(-)
---
base-commit: aa2ab7f1e8dc9d27b9130054e48b0c6accddfcba
change-id: 20251002-sheaves-for-all-86ac13dc47a5

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


