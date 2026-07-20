Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB165C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734806B0088; Mon, 20 Jul 2026 10:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C8D6B008A; Mon, 20 Jul 2026 10:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAEF6B008C; Mon, 20 Jul 2026 10:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29F516B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C019C01D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:31 +0000 (UTC)
X-FDA: 85009355382.06.E245DB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF629C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6fHflev;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rLtF0K+0TYJPvPF55k16nUXQBhEpGr25ARgvZmkoWNY=;
	b=SOrqk/zT0f8IdM0fafH8w2xMGTob59Fh/YAASoaZfwB3OVSz0/VhZgp0aqFGPPcVM59M7Y
	gYGHMTI101trEBPiFzifiq/1PV1S6bQFL04JJJj1xe5vxiMciWaTWf7KXG/4bC4PUjwsyE
	YrW/hmBfn/RU3XnTt09ZCGquurc9oJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556989;
	b=ab3Rl8Y9dvW0ux44EHylvniKPjUrOpcHf9vvfPOQ2rzXmyi3hF4lw6r8OmYKqjOcaonUvS
	PATgtYDWv9pwkcEeJerZS5lspmvrd0+VoXmDU2hvNoKFndOZlR25NlrtFBd+i6J9Ku7LW3
	z3yDVHj5EBcaxW+KFJmBTAPm3XoB7RU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z6fHflev;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E50F601DE;
	Mon, 20 Jul 2026 14:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C21F00A3F;
	Mon, 20 Jul 2026 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556988;
	bh=rLtF0K+0TYJPvPF55k16nUXQBhEpGr25ARgvZmkoWNY=;
	h=From:Subject:Date:To:Cc;
	b=Z6fHflevYEGSDO7qqj7ml46G/+2s89a916N6PqXn3//NnfakNR9A4HXzSo2WoqySI
	 pf5ukJw+Viacz8Wjh4kGhkseq4taWOBAXzlc1DDo099zbKQXGIotR5FGYyhExXXaeh
	 kE7lvpoFst9pBqyp8d8L/Vr4gUrpk8bNtGjlrIO454uAOXaYPONlhshgu0OGdIUcNW
	 ft36YvRYoMxmj6cvKTNVSzCxmuWDclvz3pTZb8dVBl1l95p6bxXBRhIjFawjqtpS7I
	 bMvaxxtREhRa2uuwXbUmYPR8O9sz53ObNi2PQotO2U6nGFTYhrtdyobDSRQ6Wqf5MV
	 f/UilygrDyMFQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2 00/13] mm/slab, alloc_tag: reduce obj_ext memory waste
Date: Mon, 20 Jul 2026 16:16:14 +0200
Message-Id: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAK4tXmoC/2WNwQ6CMBAFf4Xs2RpaC4gn/8MQA2WBVdKStjYYw
 r9bMJ48TjJv3gIOLaGDS7KAxUCOjI4gDgmoodY9Mmojg0hFnhZcskYy0zxw9nc3jeRZW5+FFLn
 IijaDuJosdjTvxVv1ZfeKA+W3zGYM5Lyx7/0y8M371bO/euAsZWUtSyWV6qQ6XZ9oNY5HY3uo1
 nX9AH7vk0jBAAAA
X-Change-ID: 20260714-b4-objext_split-da82426257d5
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF629C0002
X-Stat-Signature: du5cswkswpgkw4tzrcxptr7jdirjwoxa
X-Rspam-User: 
X-HE-Tag: 1784556989-232680
X-HE-Meta: U2FsdGVkX19yu3iEVweYeZFodDHbwg4C46y9mdXrrA3ErxrJre9ed7zqs+ATP8zjE1YUivceG6SwybWCtAw7TnuvDtV5d7qVtyDmtqpFakxaGYdpsdPcLarQ53zVlyv2lXhRV/n1lOuX0rLxOq6zDc9ewbVvrOnnGP2xKoF9cxDFpwywjDmqw3BbNx9Db+H4v+f0WAeS++67mVlrWQVr6+wQA0xws9KvM24zZWxcrA+yiW8kbdPw6+FFgqYHIkDxEzM0rqH3bCsd0omwC+sXx22lDJpzjVnylr8cTAptUf346dQdfM4pMxGZicaIw4t8yng3OYpwOUl4W9EkQdmV3UMP6OgfOfMLcMThzhn9UFQO0QiVhCaInKNisZHQgMpAT1nCKrO1c/XgQ+kJRsFynYKDb38uak72wgpWaafjPHqVhw+qbw+3Bpd2oo9pxibVIz3B0hZVLSUecFtJVXYU7eTf5b0octTJ3M6dfZ2KA8YbtfCRRqdoyn4YYCz8I6S67CeBTiBeFgsD8ExibfjE4Sv3kpwgOaJhd3ToxPmZONpgqfueMPkIy9A+iG+FWUThdPoGA5ZpRoxiWcv8iDPoYqtyU5RvveWs5nxk3evNWwqaoiagfcxPFtatTonNMOBe4qMcnMrlAXoJAjZIfCqVi8bHPYMINi0Lt0QkriONC0+Z2xz6cGzB/P1wKg9UvT6DgVF+b8xPAs09kpa8ZPKLOF6quJim1hVTQC/p4DpEUknaeIJruvYbtxzbrvrvQDNRxG/dQAzn7r5HRoKjHo1dfsRJB449pVq17N7LKTPJGI8hWkPLS9Lx3J8ccDgiBBWLByEIf73CXzlQLvruwoXahJdK5JPYxgVequrxcMdhcTmrL5Pab4S8cvanqyaNU+BaqjlOHUltzIigVlalIPo4ofWS3TljnTIInLTbfzKxiQDpOYjOQjVnCe2h6O9Jr5qVBUcvNGJxi6q14lGoAbi
 VyHXFooF
 MjVhn3uybOnkzHVxoEMKAu2ieGzFa5BbPuUMM14fbNPTw19s4nf+p3eGpnoje4qXTtgfWBuACwD9d0/jC3Z9A2Zosl2fq/CZSShnReFKr+cCfvzC5iGQkQ2lnZNxrqeLvs3zt46jRaCWjGIXq7jCWa39cdqszYMMPlOwNhgNzrgUUFC4Tx+E3Wfs/HWGlr1L9MTDrDTJ7kgIhusP83uZArcomXIKM4CiqnJF00P7/LG7MJ2lEkcihwFhZJFiUD95eFn/bFuy22/b2sR4P+57dCg4+JY49mmbzsfTmQOzOUDKoqczIvt0XF9lfRc8JQkgdomjIWI5voPc8h8ayZKEKtOVB5tgeKBbG6CFh9Tv/MNykoXs++22c7oe1Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The recent fixes for objext array handling inspired me to look into this
finally. It's been bothering me that the memory usage of struct
slabobj_ext depend only on config options and not whether the fields are
actually used. So with both CONFIG_MEMCG=y and
CONFIG_MEM_ALLOC_PROFILING=y there is always objcg field and codetag_ref
field. And thus:

1) Having memory allocation profiling config-enabled but not
   boot-enabled means wasted memory on unused codetag_refs. This makes
   it less suitable for a general distro config and the page allocator
   side doesn't suffer from this, only slab and percpu.

2) Complementary, with memory allocation profiling enabled, there are
   caches/slabs that don't need the objcg field, so memory is wasted on
   those.

This series should solve the point 1) fully for slab, pcpuobj_ext
handling can be perhaps improved similarly, haven't looked into that.

For 2) it avoids allocating objcg fields for KMALLOC_NORMAL caches where
we know they are not necessary because kmalloc() with __GFP_ACCOUNT will
pick a KMALLOC_CGROUP type.

The named kmem_caches are tricky. They can be created with SLAB_ACCOUNT
and then we know objcg fields are always needed. But also they can be
created without SLAB_ACCOUNT and then some allocations have
__GFP_ACCOUNT and some not and we don't know that in advance.

This series introduces a SLAB_MAY_ACCOUNT flag that's currently internal
only and is applied to all caches (unless kmem accounting is disabled)
except KMALLOC_NORMAL (unless that aliases KMALLOC_RECLAIM).

As a followup we can make SLAB_MAY_ACCOUNT explicit and add it to to
caches where we know __GFP_ACCOUNT is used. Then we could only honour
__GFP_ACCOUNT for those, while warning for an unexpected usage
elsewhere.

Only lightly tested, need to run at least some microbenchmarks to see if
the now somewhat more complicated access to objcg is visible or not.

Based on slab/for-next-fixes

Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/objext_split

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v2:
- Apply Suren's R-b:, thanks!
- Expanded explanation about no longer accounting KFENCE objects (Suren)
  - Also skip them in in mark_obj_codetag_empty() (sashiko)
- Update slab_obj_ext() comments (sashiko)
- Separate slab_obj_ext_objcg() and slab_obj_ext_set_objcg() (Suren)
- Add SLAB_MAY_ACCOUNT internal flag instead of relying on
  is_kmalloc_normal(); also handle mem_cgroup_kmem_disabled()
  - Also fix the SLUB_TINY kmalloc aliasing handling, per Harry.
- Link to v1: https://patch.msgid.link/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org

---
Vlastimil Babka (SUSE) (13):
      mm/slab: skip kfence objects in allocation profiling
      mm/slub: skip handle_failed_objexts_alloc() with profiling disabled
      mm/slab: remove objs_per_slab()
      mm: move struct slabobj_ext to mm/slab.h
      mm/slab: make slab_obj_ext() determine object index
      mm/slab: abstract slabobj_ext.objcg access
      mm/slab: abstract slabobj_ext.ref access
      mm/slab: replace slab.stride with obj_exts_in_object
      mm/slab: change struct slabobj_ext to a union
      mm/slab: introduce slab_obj_ext_has_codetag()
      mm/slab: reduce slabobj_ext memory with allocation profiling disabled
      mm/slab: add cache_ and slab_needs_objcg() helpers
      mm/slab: stop allocating objcg pointers when unnecessary

 Documentation/mm/allocation-profiling.rst |   7 ++
 include/linux/memcontrol.h                |  13 ---
 include/linux/slab.h                      |   3 +
 mm/kfence/core.c                          |   5 +-
 mm/kfence/kfence_test.c                   |   2 +-
 mm/memcontrol.c                           |  32 +++---
 mm/slab.h                                 | 185 ++++++++++++++++++++++++------
 mm/slab_common.c                          |  25 +++-
 mm/slub.c                                 | 173 ++++++++++++++++++----------
 9 files changed, 314 insertions(+), 131 deletions(-)
---
base-commit: d9e6a7623938968e3752b67e37eaff097e559a54
change-id: 20260714-b4-objext_split-da82426257d5


