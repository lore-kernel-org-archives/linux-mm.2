Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E9D6CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 21:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8973D6B0007; Sun, 30 Nov 2025 16:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847786B0008; Sun, 30 Nov 2025 16:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736D76B000A; Sun, 30 Nov 2025 16:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61F0E6B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 16:20:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D20C65C704
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:20:39 +0000 (UTC)
X-FDA: 84168542598.29.327C433
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C5C2180007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:20:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ORZiaCTO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JC0dncvb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ORZiaCTO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JC0dncvb;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764537637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+jra0JHaUIrt2J4jLv1VPlTjNYzgozKAbPyEWttXDwE=;
	b=CUaYL3xDkOK55hUz4n33khWmcY9mgI+gdAUwX50PzDeoXi/QuYdjAuxOfh138z+9gM2c4s
	pvfaukyEcGJuWde++DStPDW98T3MhoOkcDvsvSnmHzTvwEauxPfTtktMkMK5KMVscfYPBD
	zN9D+/mfigtFITmX+8H4svc0juqjuv4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ORZiaCTO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JC0dncvb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ORZiaCTO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JC0dncvb;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764537637; a=rsa-sha256;
	cv=none;
	b=pTVTB1dq9glUFwX7rAH9nbCxE7CX1UdEbn2TGy4zSfPyGnS2bJSP6K533DFtHIaIzE+P3a
	gEfTkcoSPb/4u2DirpsWZSoPKxEFexjGeVVyGFiuXWeGDIXENRAEX4omKJXGBQJhNgF512
	aPfJE7IQhWfVihQpZpJkUlQ3/mqU2m8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64FCD5BD2E;
	Sun, 30 Nov 2025 21:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764537635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=+jra0JHaUIrt2J4jLv1VPlTjNYzgozKAbPyEWttXDwE=;
	b=ORZiaCTO+oQMnUH5e2xuUT0fQmepwkRafvxWm/mVVH2WrtgaZ4gr53S0rPdNEbqKub9oc2
	KPWXnKFPxhwd8VSFgnjzoTjbjp03twPHHHV3GPlf8sVi8APIKduY+5Dr7YmthhgrXBksah
	3V5C/u7TvPx2SkKtKxZGqnM6TWsF22Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764537635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=+jra0JHaUIrt2J4jLv1VPlTjNYzgozKAbPyEWttXDwE=;
	b=JC0dncvbhAq9qGqQvH0H2UXJqYKQ/6pgntQExARrGfzZ8lgaWrMiEuQOimEAmKpLMFelhL
	6asWVR9ShcDm2lAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764537635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=+jra0JHaUIrt2J4jLv1VPlTjNYzgozKAbPyEWttXDwE=;
	b=ORZiaCTO+oQMnUH5e2xuUT0fQmepwkRafvxWm/mVVH2WrtgaZ4gr53S0rPdNEbqKub9oc2
	KPWXnKFPxhwd8VSFgnjzoTjbjp03twPHHHV3GPlf8sVi8APIKduY+5Dr7YmthhgrXBksah
	3V5C/u7TvPx2SkKtKxZGqnM6TWsF22Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764537635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=+jra0JHaUIrt2J4jLv1VPlTjNYzgozKAbPyEWttXDwE=;
	b=JC0dncvbhAq9qGqQvH0H2UXJqYKQ/6pgntQExARrGfzZ8lgaWrMiEuQOimEAmKpLMFelhL
	6asWVR9ShcDm2lAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46E773EA63;
	Sun, 30 Nov 2025 21:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id idD1ECO1LGmrUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sun, 30 Nov 2025 21:20:35 +0000
Message-ID: <1444c957-08c6-46f1-bcf7-da5211bfff1a@suse.cz>
Date: Sun, 30 Nov 2025 22:20:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 6.19
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>,
 Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C5C2180007
X-Rspamd-Server: rspam02
X-Stat-Signature: 5pd9zxxiy6hzuc8swqtq4hozkdqfk7jw
X-Rspam-User: 
X-HE-Tag: 1764537637-678488
X-HE-Meta: U2FsdGVkX19BP8dwWzGLpuckE0tnbYBuOERmdDQakQzQC2Tl3YMDDiZ527lpS9qJx2eCWPN+md+odkBW9gF0ij3t8LbIokOEL0bvfquvOhPoq3+7JfId0Qf/HVC5Nah0NCdnk2Mm6Pz4n+G5WwhTzT7ppjaH6xksfJmk0bWiMgQG0kVhn3MMCj/R+Es2gEzm2oZJBpkEmnJHX98/r0EscvngFsSpgPNiKm4yqKVJF7L5gQHaR7GJv0rKuW1RcV2EU/C/S/pJCXJZYBLglvj3xnRG0sOgSLgWgBXenPxlfrhrvZ21NFlzSECIueG3naDR5fL3NN1hUofP7OkqQXRXPvBvYrIhLra6ed2dTj69dTMWQVo7zlPwNldBcb6kd0dtoXzbl1R6Y2wZKyb4mhVZJelCXqdzFR9nklax9RGB9D3e66XgYdSUh5EqXWNtvZ99LqpOUbE9SiZ7pIDRbOrTzkTlKNCOIOivAYtFdGHkXSWYbXvB+vzIe9bLIzVhwjMXjkGXyHnvCjJ0BFmTlcNw3wMJoPKwnQ+dU3PMN5deKHIZcF6W7l5Xq9/1sxZ+XiQ9+cm3cY/s3pVjNrm/MMkqLBLOeB6KfNHmF4ZlD1XCAaoB+/mbUJ7wqrnDyVFVNwkTjxvPJQ35GNZF0KumxYEzkgJjBtjGFKuldmVpSGN10l4DNngGJFpRug10xV757fffTpZDdD5HBpCfB2/OeGYaXAyyr7J0kSJBDLHcnn8ZHiKMGiiT36LTKC7pjjadLsvFk5VsjNk4dpOhwdqdkKzw7Q6xq3fNlCfh+4tYuEYSfrZPQ/2Iv4a8bh2wgn/hQuyc/sLIJSzTqJ+uIOf84ysceHzpGmj5tXfKd2IXB0f2WqKu7AH6lexhynEf7RHEW8KaZ7HYv0XKDZ4+5Bpgo7o9ahUqAjLmCHk4ReS8Sj9gOtWevxmX1vAK857hninB5qDRPTIZq6Uy/MC56kJ2jvp
 XUDKef5v
 wSNvoieNolrhleH4SBMxCxl4P2QrkGCRqlSVq8mpiZ6zJTS1SKEGW4qJtexHbUxv1jmzC9Zyd2L6zOL3Jf4LnkhATnKUrLGymM2ZMwIsEl7gghd1n18UMciVHmaTUJSc9WTdUWC51wikNKNn6dofM0UVUuOAYbAC2BOXDntLOMn5dBxiPbsaLwaNQuy2HkhHmzCq8VtYjKHysW3Ab9PqNCAsNbUS3r/T/g/qn9cHdg+CNz6taJoigAsZBtJDpjbI7Tq2nC4Iamw0aSXiX749GfXft/AIJ54QRe+//DP6a/OilvDjMqVcl2ZiG8eCGTPFLW93C4Oe2LWTSUiAqvVYbbbWwlqyiwXN8L0d3zAMSKj/4WWue/klkHwZJjTHDWJr/vqGG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19

Similarly to the VFS pull, part of the changes here are based on a merge of
the kbuild-ms-extensions-6.19 tag from the kbuild tree, so pulling kbuild
(or VFS) first would avoid pulling those via this PR.

Thanks,
Vlastimil

======================================

- mempool_alloc_bulk() support for upcoming users in the block layer that need
  to allocate multiple objects at once with the mempool's guaranteed progress
  semantics, which is not achievable with an allocation single objects in a
  loop. Along with refactoring and various improvements. (Christoph Hellwig)

- Preparations for the upcoming separation of struct slab from struct page,
  mostly by removing the struct folio layer, as the purpose of struct folio
  has shifted since it became used in slab code. (Matthew Wilcox)

- Modernisation of slab's boot param API usage, which removes some unexpected
  parsing corner cases. (Petr Tesarik)

- Refactoring of freelist_aba_t (now struct freelist_counters) and associated
  functions for double cmpxchg, enabled by -fms-extensions. (Vlastimil Babka)

- Cleanups and improvements related to sheaves caching layer, that were part
  of the full conversion to sheaves, which is planned for the next release.
  (Vlastimil Babka)

----------------------------------------------------------------
Baolin Liu (1):
      mm: simplify list initialization in barn_shrink()

Christoph Hellwig (11):
      fault-inject: make enum fault_flags available unconditionally
      mm: improve kerneldoc comments for __alloc_pages_bulk
      mempool: improve kerneldoc comments
      mempool: add error injection support
      mempool: factor out a mempool_adjust_gfp helper
      mempool: factor out a mempool_alloc_from_pool helper
      mempool: add mempool_{alloc,free}_bulk
      mempool: legitimize the io_schedule_timeout in mempool_alloc_from_pool
      mempool: remove mempool_{init,create}_kvmalloc_pool
      mempool: de-typedef
      mempool: drop the file name in the top of file comment

Matthew Wilcox (Oracle) (17):
      slab: Reimplement page_slab()
      slab: Remove folio references from __ksize()
      slab: Remove folio references in memcg_slab_post_charge()
      slab: Remove folio references in slab alloc/free
      slab: Remove folio references from ___kmalloc_large_node()
      slab: Remove folio references from free_large_kmalloc()
      slab: Remove folio references from kvfree_rcu_cb()
      slab: Remove folio references from kfree()
      slab: Remove folio references from __do_krealloc()
      slab: Remove folio references from build_detached_freelist()
      slab: Remove folio references from kfree_rcu_sheaf()
      slab: Remove folio references from kfree_nolock()
      usercopy: Remove folio references from check_heap_object()
      memcg: Convert mem_cgroup_from_obj_folio() to mem_cgroup_from_obj_slab()
      kasan: Remove references to folio in __kasan_mempool_poison_object()
      slab: Remove references to folios from virt_to_slab()
      slab: Remove unnecessary call to compound_head() in alloc_from_pcs()

Nathan Chancellor (2):
      jfs: Rename _inline to avoid conflict with clang's '-fms-extensions'
      kbuild: Add '-fms-extensions' to areas with dedicated CFLAGS

Petr Tesarik (3):
      slab: constify slab debug strings
      slab: convert setup_slub_debug() to use __core_param_cb()
      slab: use new API for remaining command line parameters

Rasmus Villemoes (1):
      Kbuild: enable -fms-extensions

Thomas Weißschuh (1):
      mempool: clarify behavior of mempool_alloc_preallocated()

Vlastimil Babka (15):
      slab: prevent infinite loop in kmalloc_nolock() with debugging
      slab: move kfence_alloc() out of internal bulk alloc
      slab: handle pfmemalloc slabs properly with sheaves
      slub: remove CONFIG_SLUB_TINY specific code paths
      slab: make __slab_free() more clear
      slab: prevent recursive kmalloc() in alloc_empty_sheaf()
      Merge tag 'kbuild-ms-extensions-6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kbuild/linux into slab/for-6.19/freelist_aba_t_cleanups
      slab: separate struct freelist_tid from kmem_cache_cpu
      slab: turn freelist_aba_t to a struct and fully define counters there
      slab: use struct freelist_counters for local variables instead of struct slab
      slab: use struct freelist_counters as parameters in relevant functions
      Merge branch 'slab/for-6.19/sheaves_cleanups' into slab/for-next
      Merge branch 'slab/for-6.19/memdesc_prep' into slab/for-next
      Merge branch 'slab/for-6.19/freelist_aba_t_cleanups' into slab/for-next
      Merge branch 'slab/for-6.19/mempool_alloc_bulk' into slab/for-next

 Makefile                              |   3 +
 arch/arm64/kernel/vdso32/Makefile     |   3 +-
 arch/loongarch/vdso/Makefile          |   2 +-
 arch/parisc/boot/compressed/Makefile  |   2 +-
 arch/powerpc/boot/Makefile            |   3 +-
 arch/s390/Makefile                    |   3 +-
 arch/s390/purgatory/Makefile          |   3 +-
 arch/x86/Makefile                     |   4 +-
 arch/x86/boot/compressed/Makefile     |   7 +-
 drivers/firmware/efi/libstub/Makefile |   4 +-
 fs/jfs/jfs_incore.h                   |   6 +-
 include/linux/fault-inject.h          |   8 +-
 include/linux/gfp_types.h             |   6 -
 include/linux/mempool.h               |  58 ++-
 include/linux/page-flags.h            |  16 +-
 mm/kasan/common.c                     |  12 +-
 mm/kfence/core.c                      |  14 +-
 mm/memcontrol.c                       |  40 +-
 mm/mempool.c                          | 409 ++++++++++++--------
 mm/page_alloc.c                       |  15 +-
 mm/slab.h                             | 112 +++---
 mm/slab_common.c                      |  29 +-
 mm/slub.c                             | 700 +++++++++++++++++-----------------
 mm/usercopy.c                         |  24 +-
 scripts/Makefile.extrawarn            |   4 +-
 25 files changed, 792 insertions(+), 695 deletions(-)

