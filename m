Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B84CD98E0
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 08:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481DA6B008A; Mon, 15 Jun 2026 04:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432EE6B008C; Mon, 15 Jun 2026 04:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3214F6B0092; Mon, 15 Jun 2026 04:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 220926B008A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:45:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB50D1C3038
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:45:37 +0000 (UTC)
X-FDA: 84881513514.06.25CF1F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id ED98E1C0008
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:45:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=biJIXRTF;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781513136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tiW8D0e/EjERwLG+vfr9CQQgu67WuB4fGpBfPHlvrJQ=;
	b=ZIO19GqO9Yy5R95YI9f5XgNfGuIstvVmayRBQcC6N4PRcvBUk4tIPrG1RBSk3qUs2eDqGC
	iwHNLD4Jtu5eGl/5miv7PJWAh5xQ5sLLCRLrb25oFpDckMu9LiTi3bBrjpKgcV+yQw8B/+
	oiXfP3ulC/NAEIPGx/OuD+4K1UyW+l0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=biJIXRTF;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781513136;
	b=Y7D/TdlyEBEkfeRt19RrGeUtmPvCEAvjBu8NKVUDB8BooZs/QKhz4LYeCzfg94oblgqoc2
	BRyfS1nGMSNuUUNI+uQe+9lvQfX455IYWYjsCy8NimntWT2II3mMigACmdh1nSx4tqWqO2
	KSpDSxBl/24freaD/h/hA3YhdiBOFGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E531140E47;
	Mon, 15 Jun 2026 08:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A08C1F00A3A;
	Mon, 15 Jun 2026 08:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781513134;
	bh=tiW8D0e/EjERwLG+vfr9CQQgu67WuB4fGpBfPHlvrJQ=;
	h=Date:From:Subject:To:Cc;
	b=biJIXRTFjuNKjNTmQa7cMJmvBa8VHwMk54DkF+9w7tiDP6PlMz/fQ+sGmi+vVnI2b
	 RFq9haZltVXRR8+lslqHWvQ1dTL2N6tDZAbn0vLHWJTZ6dWsVV74PbCp5dYTEFkALD
	 bn/w2lY7mOdP+Bm/MbUNZVrfE1nBp/p8u7TlIH15uJ/EI8ptmMKeYu5bRW+oXRcuqY
	 dvbyD514XAcFQKP3uNYFJRx+LiQsBOEhKlExQyHCkXD+nkE7AMV/FDZTH+zVpKTOqy
	 PXcL14VM6IDWf86UAH8YSS1VUheSzlbReiGD/syetvTuRcDKHfEZDIpRaFFkfB0mEE
	 kWDFMwR5pOKUQ==
Message-ID: <fa60be45-ffdd-43f6-b1c0-4a8ed1d5c4cc@kernel.org>
Date: Mon, 15 Jun 2026 10:45:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab updates for 7.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Marco Elver <elver@google.com>,
 Kees Cook <kees@kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ED98E1C0008
X-Stat-Signature: encr6jr51ecwzsw135fm67nc8r193qgt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781513135-542835
X-HE-Meta: U2FsdGVkX19pcNElj8dSAVYsrxWj0tPllDxd7cdJOB74tlD7atMDae4cdKqCzm/7Ay2z7CrYAzLqA2okgwaPM7fiWxTMFKsDiK86nSF9YgArfTO739cjDokK/hF4ZjQRPOrp/OrJ4fmsNFUZPPYjIXXi42ATKwr3nF7uMSX4LiXKRfWcCwCrlzoeUQJQgwOhMPE3GH8QwOscGhvKb4e1qg/lpvODAufQW29jALmhLy0uPcm1Tdi+UsMZsVBeQCsXOHatkJ/k3E9xKywPxO/SN0HDuul7/vWRNtL3bm88tNeQ6H5kKzlYi0f7+XoS0DrVAXbT3zlDSKlQgKdsHwZNxnYO/8S0b/NV3LV0SDPSV2S/UJBWLlmQC0KEKfI8/uLXRhHb3aYw497YBxn6IfQeNR8RAX1fldaWeBuIw57XBakTpuk2ZitkGoIKH8rKLR8+QjkO7pg6nE8FKaA1zq39sLSNN1KaB3V1b/CDS0KSfBOytGJ3e1q2xpXs531gK+iK8GYERZJjnF+EsaMXlcbcEEA4vFsQv+OgEos6QdST5GXEp58XkuJ2RQKrHX6S5MU2LVmzdcZuGtSnjz5pzmAT51ANTFxJtj7n51aC/9LxMvHk6oRTw58w4zzTVcZ0PB8XXzQt3rnX2kaG8ruZeLmYdmH8Q+5uoVxhvMFbF/0rm6sxa+kVkCf+emPTBTIKslOu6N6u1a/PRx/VJ56C4GVskpaRvbkzu1D84dHCVZRh+K46f45S9G6ck37VAdZV6cP/5XE/ks3xHjA4hNMALXlHTPs6wc29t6jfUWM+iN9e5062l2Qq1huRHFKUiJAWuGOIRpIwwevIRmFxet/7ZHlO+dQYLRJS+R5EbwJ3APCDY4D3TERRsHjD0Wpg8TXKygmzvUjgQKiUxAIASrY5xCzqj//c4ok+nlPwRPpGhBUoZP4M9V3ArZQpmpswqQBHAtxSx1ZbRjWYNOWxs0QTpv7
 6xePUrDI
 6WSDKdMxbur8E3XHGZ5rH0rJ3HQhjEK2Mo2soMc/fGOU1D90DD09XDUndTpqEIbasHZyaccoavcuezJug7VuEuIeNhm3Ckyh18D9Ej9kmg3TGnv5GrV0fqZ+HeSH3VzCy6Pz6Zx6a7g3yLxTKFeLswrmzylrM7R0ikxbQoQZK8doMRFhNKuhDfth2tcnbaYwvpvEshjSAjPRvTk3z1MkxRVbJHbdXAcanILVId4MgpBsc1jy79k/AcHklc9B8N6pz5U7qdiikVWF6rMoQS45TZdHelb/MFBebe9iCJF5gBUAprag+WufgAgGjj6cvzrIIglXTCQPVVjuK+Xoycho/AoDJXQuz4IlyFFj2qD12M3jLH53/cTY3byrcIA888sW3gETI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2

One conflict was reported with the drm tree. The kmem_cache_alloc_bulk() call
we adjust has moved to a different function there:

https://lore.kernel.org/all/ahoZ7OCzxTAbGMtO@sirena.org.uk/

Thanks,
Vlastimil

======================================

- Support for "allocation tokens" (currently available in Clang 22+) for
  smarter partitioning of kmalloc caches based on the allocated object type,
  which can be enabled instead of the "random" per-caller-address-hash
  partitioning. It should be able to deterministically separate types containing
  a pointer from those that do not. (Marco Elver)

- Improvements and simplification of the kmem_cache_alloc_bulk() and
  mempool_alloc_bulk() API. This includes adaptation of callers.
  (Christoph Hellwig)

- Performance improvements and cleanups related mostly to sheaves refill.
  (Hao Li, Shengming Hu, Vlastimil Babka)

- Several fixups for the slabinfo tool. (Xuewen Wang)

----------------------------------------------------------------
The following changes since commit 5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2

for you to fetch changes up to dfdfd58cce1c3f5df8733b64595448996c08e424:

  Merge branch 'slab/for-7.2/alloc_token' into slab/for-next (2026-06-12 11:25:12 +0200)

----------------------------------------------------------------
slab changes for 7.2

----------------------------------------------------------------
Christoph Hellwig (2):
      mm/slab: improve kmem_cache_alloc_bulk
      mm: simplify the mempool_alloc_bulk API

Hao Li (2):
      mm/slub: introduce helpers for node partial slab state
      mm/slub: detach and reattach partial slabs in batch

Marco Elver (3):
      slab: support for compiler-assisted type-based slab cache partitioning
      slab: improve KMALLOC_PARTITION_RANDOM randomness
      slab: fix kernel-docs for mm-api

Shengming Hu (3):
      mm/slub: defer freelist construction until after bulk allocation from a new slab
      mm/slub: use empty sheaf helpers for oversized sheaves
      mm/slub: preserve original size in _kmalloc_nolock_noprof retry path

Vlastimil Babka (SUSE) (7):
      mm, slab: add an optimistic __slab_try_return_freelist()
      mm, slab: simplify returning slab in __refill_objects_node()
      MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
      mm/slab: do not limit zeroing to orig_size when only red zoning is enabled
      Merge branch 'slab/for-7.2/tools' into slab/for-next
      Merge branch 'slab/for-7.2/alloc_bulk' into slab/for-next
      Merge branch 'slab/for-7.2/alloc_token' into slab/for-next

Wilson Zeng (1):
      mm/slub: fix typo in sheaves comment

Xuewen Wang (3):
      tools/mm/slabinfo: Fix trace disable logic inversion
      tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
      tools/mm/slabinfo: remove redundant slab->partial assignment

 MAINTAINERS                           |   6 +
 Makefile                              |   5 +
 block/blk-crypto-fallback.c           |   9 +-
 drivers/gpu/drm/msm/msm_iommu.c       |  13 +-
 drivers/gpu/drm/panthor/panthor_mmu.c |  13 +-
 include/linux/instruction_pointer.h   |  24 ++
 include/linux/mempool.h               |   2 +-
 include/linux/percpu.h                |   2 +-
 include/linux/slab.h                  | 324 ++++++++++++----
 init/Kconfig                          |   3 +
 io_uring/io_uring.c                   |  23 +-
 kernel/configs/hardening.config       |   2 +-
 lib/test_meminit.c                    |  23 +-
 mm/Kconfig                            |  73 +++-
 mm/kasan/kasan_test_c.c               |   5 +-
 mm/kfence/kfence_test.c               |  13 +-
 mm/mempool.c                          |  27 +-
 mm/slab.h                             |   4 +-
 mm/slab_common.c                      |  52 +--
 mm/slub.c                             | 680 ++++++++++++++++------------------
 net/bpf/test_run.c                    |   7 +-
 net/core/skbuff.c                     |  24 +-
 tools/include/linux/slab.h            |   2 +-
 tools/mm/slabinfo.c                   |   8 +-
 tools/testing/shared/linux.c          |  19 +-
 25 files changed, 788 insertions(+), 575 deletions(-)

