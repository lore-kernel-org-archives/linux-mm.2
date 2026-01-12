Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4BFC9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22746B0088; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBEF06B008A; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C966B00A1; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A721C6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AF56B9AD4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:01 +0000 (UTC)
X-FDA: 84323664642.23.246760B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id EC12F1C0008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QqC/vZ+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L1gEmynj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QqC/vZ+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L1gEmynj;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231019; a=rsa-sha256;
	cv=none;
	b=tN3fU1KvCBttiQIer+4CQKWU8zvWaID5p1fvN3czsAkML4cBhZ4fXuTFOF9HPYbd7bDGRq
	6kH5E2ywTo3ri1p1jp+9CzU2/gF8W48O45hnW9woJctLiUYKwBYdk50GniRCVML6ukUzc1
	l6pSSnrlbL/yOwma6cvG1/KRWzUZYpc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QqC/vZ+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L1gEmynj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="QqC/vZ+P";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L1gEmynj;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+UvoqRnkM3qauOW0euhXUnny67QRfa6cbf3yuk2gvkI=;
	b=tvny3Q/3MV3oBN2ejrqAkPZmlDf2SWlnT//3P/tv5wow1JL8uTbgW8DPocz/DeSLhBhf2f
	Lh8EFHz9jswBzdHPbicqT7X2W/N5RmtY1DZ5G9m1oFKAHwWztOBucCBUBPnXqTWGAD472c
	czGgH2qo5lEjo2sQ1hl1J5960vBjBk8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32B1533686;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UvoqRnkM3qauOW0euhXUnny67QRfa6cbf3yuk2gvkI=;
	b=QqC/vZ+PLHeT2HLyotXpx+p23lALYCNWyWteScnZFjHZlGvmDRoNXy22APzaOaziFreBzx
	K4lwNzI6jZih5MnSwxXLr5rYlLOfyuzQ8iQXNdZMebPg7F74LrvHYKV/v+X4KVb4ro0frx
	JumThh9A8Q6e7DOmSGwpwJrF54GH4CM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UvoqRnkM3qauOW0euhXUnny67QRfa6cbf3yuk2gvkI=;
	b=L1gEmynjpavCJpJLzfeuYsDXc0RPTtdI0iMfYOWUpQBZ0aO7fPWKrjgmp6tYGP13i2wbDO
	1rlJTMpEHOl5LMAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UvoqRnkM3qauOW0euhXUnny67QRfa6cbf3yuk2gvkI=;
	b=QqC/vZ+PLHeT2HLyotXpx+p23lALYCNWyWteScnZFjHZlGvmDRoNXy22APzaOaziFreBzx
	K4lwNzI6jZih5MnSwxXLr5rYlLOfyuzQ8iQXNdZMebPg7F74LrvHYKV/v+X4KVb4ro0frx
	JumThh9A8Q6e7DOmSGwpwJrF54GH4CM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UvoqRnkM3qauOW0euhXUnny67QRfa6cbf3yuk2gvkI=;
	b=L1gEmynjpavCJpJLzfeuYsDXc0RPTtdI0iMfYOWUpQBZ0aO7fPWKrjgmp6tYGP13i2wbDO
	1rlJTMpEHOl5LMAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F034C3EA63;
	Mon, 12 Jan 2026 15:16:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1wH0OWgQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:56 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH RFC v2 00/20] slab: replace cpu (partial) slabs with
 sheaves
Date: Mon, 12 Jan 2026 16:16:54 +0100
Message-Id: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGYQZWkC/2WNzQrCMBCEX6Xs2ZUk/dF6EgQfwKv0ENKNCZRWs
 hrUknc3xKPHb4b5ZgWm4InhUK0QKHr2y5xBbSowTs83Qj9mBiVUK4VQyI50JEa7BNTThPtOG1m
 PptnpFvLqHsj6VzFe4XI+wZBD5/mxhHd5ibJUP6Gq/4RRosDOWq1M3zfSiCM/mbbmA0NK6QuPS
 fcDsQAAAA==
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC12F1C0008
X-Stat-Signature: mr94w9uygkj9irh175hh3nsskprqagb3
X-Rspam-User: 
X-HE-Tag: 1768231018-600505
X-HE-Meta: U2FsdGVkX1+WmxuGRfCkG6wUaeodQT7i5ompePU9LeqFrGDQyA8l2MRQb3hkWyNuOqDEusaI4flSJcBji0UFR7Tjyp6QwkPA3h9JJ4JOsxPDWUeSODE5REutHktR7iPCdQ9UwUp6cOrzANOrUq6/hE7W++scM4lpDg9k/m0a4bexY9HrEw4WTbgmW93gusCfNHBHVNGEHvYP49qZhUGuzIn1d6nS8y4pOt3s4dcfaOlqAvFpyl/l2Hguvip70oTLp0wNmL3q+WpLvNGjqwTL5ZgdEMXcnVOVVWQDKq8OK/Z+lRCOflicvXuzr2k0yjrHoETpeKZMf4SWYhAfmikQHfYp7ESDYLhDPchW6ib8inYkqRnyrXyoR43SVVZYlUpHV6ozRJUBKRH5cDLZkSCo+rWhmimfG04JA1WcI/C7UIi5e9SKubZIHlaRoULrKDSIX4fBn4JiO8KyP2w9VDaB4dPd5tH0z3YpjA4zym6RW4ykjulMCPAfCoKfxhOIooyJG7/ctli30JJw7R7WHizp3Dfhk1Ve/elBiKad8QnBZTJPyD59mhM+XfvyPcnJZPJWyV3QVd4QEpww5gsnrp5dDt6a9MAwgAzEYAgaoglMr6XttHjGWnAwBYSYdsMiq5ANCQSP5gMzU3uz9Fn2UKeP9GMuusIitj8+2MctFyrwCFgQm0NyWPx6cMamKAXX/XGkCjNnXH0mmUJsezbF00ftnL8UQq8A3Krh5VN6yaN9hLfk8ZgWziWY0wLWmRCvCgt3Sre4NfQOO8zJBaILUBUKfj8IrMJEiitLOuFdJm9pXvZADF4NQEdTCoCrpymT26qcsI/n4821TbZoeu/Il06P9OR5we5uVbhYcg20MoBMYZDKSl6743n9IhObtZUYtD9El458r3ZhsCcijcFiap5z/GMEZhXoRpd7IdivlgX8uxhzq8crupm48NACXkontQMIqTyaqIgB8+SsTAvYzXp
 9akl6MIb
 Mx9NoAv6PkZ4aHG/xpzT62O9VV1kK/11U4iIAqjH9nhTf2v0ClQLbGBBgLmrvoXu94qEWW6oUSgJhHsRl8ZcTKauavSr8E3U/R/soVDKgKN9GQqc6wRNeFmiaPaTFoWH8VzQex9WsRNFENTiQLLMNbVhz5vJlGF1aXmM5g2CZ4lVT5MEkU40tW/wTwkxiFuaOShgt44uwYCKd9dAf2B4+z8gtCObrGmcV8wVoA4iNgafoC/DIdO7ETbRK0k6J0i5z89ztuhxIKe9XVTmOm6l7ZXM7v6cVCxva757WEIPjFiij2ukNK1wV5bNQOG4++HjFUKMue2SsUBmOwdkBJ2kCX/9f0lFR+R9ElBLiZj1WU7/RzU31l1XvGVTpz4OBL5mvQ7wMtdy9WZJy+4Nv8KciWJ+ecz6LUwFvyostTCQALVnG8OVSpCOg3bjDRg==
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

This v2 is the first non-RFC. I would consider exposing the series to
linux-next at this point.

Git branch for the v2:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=sheaves-for-all-v2

Based on:
  https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves
  - includes a sheaves optimization that seemed minor but there was lkp
    test robot result with significant improvements:
    https://lore.kernel.org/all/202512291555.56ce2e53-lkp@intel.com/
    (could be an uncommon corner case workload though)

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
Changes in v2:
- Rebased to v6.19-rc1+slab.git slab/for-7.0/sheaves
  - Some of the preliminary patches from the RFC went in there.
- Incorporate feedback/reports from many people (thanks!), including:
  - Make caches with sheaves mergeable.
  - Fix a major memory leak.
- Cleanup of stat items.
- Link to v1: https://patch.msgid.link/20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz

---
Vlastimil Babka (20):
      mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
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
 mm/slab_common.c     |   56 +-
 mm/slub.c            | 2591 +++++++++++++++++---------------------------------
 7 files changed, 950 insertions(+), 1773 deletions(-)
---
base-commit: aff9fb2fffa1175bd5ae3b4630f3d4ae53af450b
change-id: 20251002-sheaves-for-all-86ac13dc47a5

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


