Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDD2D625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8DD6B03F4; Fri, 23 Jan 2026 01:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1935C6B03F5; Fri, 23 Jan 2026 01:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A37B6B03F7; Fri, 23 Jan 2026 01:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E67886B03F5
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75B7D56AE0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:14 +0000 (UTC)
X-FDA: 84362311908.06.BD1F1AD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 29AE8180003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgvEHHPy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gHQhmfuW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ToZZ/BfT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K6pbeq4M;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xHBC7+XIDKcDoXobVjIIeaJAGTBPlExl+xM4MpgZv40=;
	b=OnmdgMUpI7rdjniBPWEJuIDGfcGP0gQdQoYFsOB53M54m57YhMVe/UKSwrHN13kAwZyKDl
	dEWrtrPF+vwaJxS+48Ek/VJ9P8TzG22xZ/31V3jskecOpZNm85eAzWt6HF8cH2f+Ow1/88
	trfmFeswz/sBC5P2XBeAxgB4biulGWE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zgvEHHPy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gHQhmfuW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ToZZ/BfT";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=K6pbeq4M;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151192; a=rsa-sha256;
	cv=none;
	b=rm2+o2aOkLDZ4+5oFFZM9c23DCsZh7pkjoH+eOtd+A41HvZXEKHcHLYFDRrB6XPO1n6RhO
	ge0vpryyMUnjgFDUl8zeJCywgWX/7T+22K0oHg4plGU6H5ks6pTn+mR3/oeV1aLS5yJMAI
	yeI1MzbKlip0kjgYckEy0tiwmfbL848=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3953C33768;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHBC7+XIDKcDoXobVjIIeaJAGTBPlExl+xM4MpgZv40=;
	b=zgvEHHPy66Pe3rtCqtFAlD/T0SFtfIkyxHp/2jGbNuWivkgsODJS+GB3rTyJNdBQHar97c
	sVm/AXjAPZ5uQPERzlxQuVNOH7cVpTMu5hBAdgpBzT2vGeTkd+bMle170/98KuVYb/J+cW
	oDALmTnPKb+gF1t00DYBWfwm/XjlF6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHBC7+XIDKcDoXobVjIIeaJAGTBPlExl+xM4MpgZv40=;
	b=gHQhmfuWotNYLJuejhYX3dxwwfRYJvYYMhnYv7Laye0/yDAzbmLXYqCYnjP4I1LEQZHmCG
	A1ZPbR8VaFf+GeCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHBC7+XIDKcDoXobVjIIeaJAGTBPlExl+xM4MpgZv40=;
	b=ToZZ/BfTv62as/fot31mnxaZmixLhnkGocIYQRRAdYgnwsl7CsXu4WojwsA5SXTDgZ+Dz4
	m2EtAaA982iGbCPhmEdr+UvakVto6xCGIYXWgknW7KUguIi/6AOE+7QqOMrCbu7j36Tiqn
	1vNp+dBhgA5BoJk1Q/nawV2GLF4BLsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHBC7+XIDKcDoXobVjIIeaJAGTBPlExl+xM4MpgZv40=;
	b=K6pbeq4MyJ0jv8OvZFU821QP3Qr9O0rFmSjHF2nLtGR8Lgx/18gnDuZZGw8wx0o2fvg3t4
	jn59EWj4p1ZIHjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06A8B1395E;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +aDbANUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v4 00/22] slab: replace cpu (partial) slabs with sheaves
Date: Fri, 23 Jan 2026 07:52:38 +0100
Message-Id: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALYac2kC/2XOTQ7CIBCG4as0rMUMQ+mPK+9hXNApWJLGGlCiN
 r27tNGo6fIjed5hZMF4ZwLbZSPzJrrghnMa+SZj1OnzyXDXps0QUAkA5KEzOprA7eC57nteFZq
 EbCkvtWJJXbyx7r4UD8e0Oxeug38sB6KYX98tlKtWFBx4Ya1GqutcEOzDLZgtPdlcivjRBQix/
 knEpOsKUZFtFJD91/JXF2stk1aqVtQAQFniV0/T9AKIqE+lKAEAAA==
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
 stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 29AE8180003
X-Stat-Signature: qy4f7spnnzj6auinz43ir4rrs1ydmft1
X-Rspam-User: 
X-HE-Tag: 1769151191-541347
X-HE-Meta: U2FsdGVkX19W3y94/3NhThFa873g0kwRXGk+kqvC6heQyWR/JOqQgy7sRYhGeS8Df0dwKH1J+j/e2KZsYgLrlYZpTIgugqlNCVtUoF8ZOF5CDbL8URwbQxwqDlKNtZ7MapwCknuFKVCm1KVAet1sue5A98iaT4I6l3RAvQgus4v8gaXq3aO48TDAg6AUJlsHcdxruE8QZmT+3kilOhKQ/qxSjlcEe8QxNDEZ6QF3kJ2B1RTGn3Ne1eVecPXy9Bj2VSC49z2Fud7g+Wj9kxnITdTcm2ZqENTMcJNbiN1auTEgW6EiFlFyjO9VTVvF9EJXAfE9Zbs8KKR174D1n/TS6utMszmIlEr3TyZBVsmBi+RCcSxanjTlpqogBBVCpn8qPuuhyul6cAmLq27LTU/VVmL43lRvCTWmPBotH+6lBCDaHaoiJKGAlrN9yUZJ1Wm1Nr4Pl6H5f0n8fOJF76lOStofShxF9M54fjx7Ey4xsdyZ2sxuab/V+4XABy3EiS+6huaSWWL7LaNlyaQpzeqx3vgkyXd7BYlJSFCpHc2WXq+Drr4kkxrj1giZXcnb/8+q/BbEReyE4zo5RnB1lcOSReRu5U4FDYopup6Aj3yWD4S8N3+vfNrifB1Tn0DJzdJzqtSRBe0EZk9BFSpIjwG/+P4KwFej438mUfAZRk5awRB0gt5ppEaiUeWQQKxvRBeSJjGF52TlY5c20mNY/UbsRlOn/REXB8ewWhphTGZWcZuu76EacIjVy64rxqCqNxu+sEAO4bl2q0qIJrnTuzsTKbgGU1eqRN8lz3j0hgJ4XWE6uD+qQv9Cmz95TzBS85v6AFtsAG1GvfUhqczrNJyAr5dk4pNhdnoci1rIPpOH1LYKDRCSyestiIqWqVRonlIg6tOrHGBlC46PS5n7fsbkfWBtk1yhWfZYIsIedVUKmsK6xurNrvp7xSEmPUg06WHgcaktp8mVvS/t/5djAY7
 M4t/xUqJ
 wJMHaztljUwwj0wci7sojIgJDMkw/1S9UNIxXeFOCuHu0sbd4OduGTL2KeVFSscPzonral4jgfQIoZG2YIfUPFkKCUtxKN1O8UecKOw66s+b0p9dr32CK7qrMDDogX2QRaWp6QdyvAtgx49e+2wcaRqqwY3+FFZJ0bNcxiG74/tpXf7OVJAME9PrIEh8fXNoXaY3Zn/S9Cpk0UmblT4hsP6xGIj2g40AiHTu9cINxJi92xpAQ7YIZypZ5dmsUTcoZR2/nOp4r6rR5PFuPyCyql8aRFpqrFW13NOZBDmJ56QF7nuHXuKmiTIedWfXtr6fBqP+hw3w8wwdX0hcJIm9jP2Otl61aUSUIEl5KaPiy7Vr2TeUAa9UZOUsv1XSrt00SS3nqBlwnPqbpo84p1JnNgLN8ZFqTKvZWOuc+VkhWyrQZqjanzFB+gdmvJw==
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

Sending this v4 because various changes accumulated in the branch due to
review and -next exposure (see the list below). Thanks for all the
reviews!

Git branch for the v4
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=sheaves-for-all-v4

Which is a snapshot of:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/sheaves-for-all

Based on:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves-base
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
Changes in v4:
- Fix up both missing and spurious r-b tags from v3, and add new ones
  (big thanks to Hao Li, Harry, and Suren!)
- Fix infinite recursion with kmemleak (Breno Leitao)
- Use cache_has_sheaves() in pcs_destroy() (Suren)
- Use cache_has_sheaves() in kvfree_rcu_barrier_on_cache() (Hao Li)
- Bypass sheaf for remote object free also in kfree_nolock() (Harry)
- WRITE_ONCE slab->counters in __update_freelist_slow() so
  get_partial_node_bulk() can stop being paranoid (Harry)
- Tweak conditions in alloc_from_new_slab() (Hao Li, Suren)
- Rename get_partial*() functions to get_from_partial*() (Suren)
- Rename variable freelist to object in ___slab_alloc() (Suren)
- Separate struct partial_bulk_context instead of extending.
- Rename flush_cpu_slab() to flush_cpu_sheaves() (Hao Li)
- Add "mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()" from
  Harry.
- Add counting of FREE_SLOWPATH stat to some missing places (Suren, Hao
  Li)
- Link to v3: https://patch.msgid.link/20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz

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
Harry Yoo (1):
      mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()

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
 mm/slab.h            |   65 +-
 mm/slab_common.c     |   61 +-
 mm/slub.c            | 2689 ++++++++++++++++++--------------------------------
 7 files changed, 1031 insertions(+), 1807 deletions(-)
---
base-commit: a66f9c0f1ba2dd05fa994c800ebc63f265155f91
change-id: 20251002-sheaves-for-all-86ac13dc47a5

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


