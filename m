Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9CCC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE4E6B0088; Mon, 24 Aug 2026 09:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5FB6B0095; Mon, 24 Aug 2026 09:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94856B0096; Mon, 24 Aug 2026 09:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B81896B0088
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:57:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E77FC0176
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:57:58 +0000 (UTC)
X-FDA: 85136316636.16.2636213
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 75E0340005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:57:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDzywXpG;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NNp4UNhd1NOiyGzJQCdsou/sBAaBs1VLWrMHz+JJOrk=;
	b=bKR7XYeQ5hI+TsegbdjpxmkN9W1+48yGji9GXBKxeVV9uD9EnD3SVennu3EcxVrWoWsf0h
	5+dAnQWLLTy1E5kU+V3SJMjXfkys/ErhxmANIS7BQ4d0oTPXZ0RhPT34FyGVb+j1sgsuhx
	4EajHrkDvkEj8vBBgeLb0gyiNDE/qQE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDzywXpG;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579876;
	b=NiiToElPHk9HZtmIsrg1VY3A2LUVc+0aZr+X5hKWkCtIie4omaqbIMJr9Rjm7dWllPgbR8
	bdCsK+F5FRqt2ToYcXv+4Da2DzRyZZ1nEK6C4PP9VsftJnV7KpQSW4B+nNFwImkPERE3aB
	nLIeqV5bUGQjIDlXPe1dtbPMJZZEbjU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72F626020E;
	Mon, 24 Aug 2026 13:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303ED1F00A3A;
	Mon, 24 Aug 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787579875;
	bh=NNp4UNhd1NOiyGzJQCdsou/sBAaBs1VLWrMHz+JJOrk=;
	h=Date:From:Subject:To:Cc;
	b=HDzywXpGTZQHjQMlj83diff96BPieK+4YF/2KDJ1pJr3FLqbBvyHzFN1MCaYSyFHQ
	 QoyX5Gyl/AgIFeX9SJTDF7m9y/wXQ2/bI4XaiBfWygQ3llMCQmNTSr+q1LaVTTVz+h
	 hF4Ino48FpBuMTJ01qRmmE8C94B93CLhkzW0yzJYuVvRAOulfV8JIM5BjCHf6HE/Kn
	 Nmw170dft3tX3tkBbr1nKPFgeBI83LpQqou7Cz4aczCzS9dvjPMX1lV6HNENUt+iIy
	 GXG0INjbuQT8Pw30Vl5ecorae8+8Gk5MUAxwlFF1pn53hP+qpqfg/MMT56MoAU15Qv
	 7WzZqHpMpflwg==
Message-ID: <321f40c8-c694-4cc6-a4cb-df0c9b3d3fcd@kernel.org>
Date: Mon, 24 Aug 2026 15:57:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab updates for 7.3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75E0340005
X-Stat-Signature: wk1b9s77gi9enhqyj917zhhyyu89rrok
X-Rspam-User: 
X-HE-Tag: 1787579876-118079
X-HE-Meta: U2FsdGVkX19OQlAF+Zn0Q/CYVREbCBNOpGiEaHg3MDjakN/X3669E5RhUME/tedTVjBJV5KxPdUPEJESx6rwSt5YK1iNss2W/teQPFOQEWVOlPWGVMoP2K9F2pXvXTFIxfudhwaq/Tw7o/b8p+tpgoQXTwlb663sLxFvBZEUf9zwXdu6/GHcMZDIOVJAarCI277zFpm8lyzVYFUEGUuJ25du93pWxd2BWI3yzqoHcyUSUE7QzxM9buJeJbfSFIuCKOZQY6O95L2vx0LUDuhslnHYCCP4bCBnepOHJx7uatfOaQC6u7Ue/NzpF58ZKJP5EvApj//+Z+38t1oXVmd7NHQY8ojXNkc63s6qLrRh2R3QPy8AGKhLDaGe8ByDCF6NNLgd90+JORlY1YINrQYgrJ05zei8z4Xemk3MP37NwThbVQxzqVtlh5wGY6AOj40JXiddwQ1bEa3t58ESmOMBvkQkicZkjDdq2l0lEMsZpdDaCD48/SBU+sI/AZ2rN7zUlewgF/1vcKMsXy9h2BeWelimBw3s4SIoktytuCVQH6rWet8WusfgzuolL9EtnA0UAzs2P/N3ccmGM/ur+KI7BAX8z9W/kCZL7CMtIv0DhColx7OgeBEetilIRkQbwImYSXyfeO6k6YCeAU8pA1wbvsGeFHJ5r38YFC3CMcTorGahkSC5d4BroqHdIdfBLDCUHFJ5PlHWYHWOELrN5aEx16Ggi8OJ00GQ/n+Pqnj3gXXeaKR+tuZv+hHouUFv5cI2CqrFZHk/g0+8X0ur5EG/VfMeaO52ewTeEGLfHaFNrlmHYKJxN6/nB8hqRQq89UP8Qm0E/yXIo+FcRNaFxSBrAwu/0Njeq8jx21sRbHOWH91HX4LY6rIEX5Iv6TOKggPjEpTRzabxEfY/rkTIlYQwR9ixRiNb/qLbl6mGGEN6fK32xDusWS5v/rfhiQsSXFvtEEMQ/AzHU/8NNw5ag1b
 xP3klDce
 uiy5ID7r5WJGCDTCXbVcBDzOw8TiqrrmWt8YjWpONkjdJ8Z/WYSMychgI56F1ZfNpmxFuMDNDKJWuq/DwX7vu6O0l6Vef2nMGVaI8BVClY6fSGSlnAzKK+OhENa2Mnwe4YFwVvAjdCa43pavqyM52hy2YLeu38MrQ6CXoWA4GMlN0d2vK1043CBlfIhOBjuDSL7TNLuAoqZ0FO/bOWfhi/hJFrnH3pn63CeJ6E3CfPESFlUUpK7YhzkkFF3FNNNKoEz5tLq6Z+JoslAqlC72SsRAsIweKPzSsXxoyJjJ5utqXprwU5dCvYK0Vxss71yGQLEvt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.3

There's a semantic conflict with changes in char-misc that will break Rust
build due to a change of kvfree_call_rcu() parameter type. In linux-next this
was solved by this fixup applied as part of the merge commit of whichever of the
trees is merged later:

https://lore.kernel.org/all/20260805-slab-rust-fix-v1-1-c4d4c1b69de2@kernel.org/

Thanks,
Vlastimil

======================================

- Addition of kfree_rcu_nolock() that can be used from contexts where spinning
  on a lock might be unsafe, such as a BPF program attached to an arbitrary
  function, or in NMI context. This complements the existing kfree_nolock()
  support. (Harry Yoo)

- Runtime instead of compile-time slabobj_ext sizing. Avoids wasting memory
  when memory allocation profiling is compiled but not enabled, with initial
  partial support to also avoid wasting memory for objcg pointers when those
  are not needed, while profiling is enabled. (Vlastimil Babka)

- Various non-urgent fixes, cleanups and optimizations. (Hao Li, Hongling Zeng,
  Li RongQing, Li Xiasong, Seongjun Hong, Shengming Hu)

----------------------------------------------------------------
The following changes since commit 5ff172f6c94d282d83cb88bdfec5f647ad9c6105:

  slab: silence sparse warning with type-based partitioning (2026-07-21 11:28:21 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.3

for you to fetch changes up to 564ed40708ebc60a78f280944799cbe8e3401816:

  Merge branch 'slab/for-7.3/kfree_rcu_nolock' into slab/for-next (2026-08-24 15:01:27 +0200)

----------------------------------------------------------------
slab changes for 7.3

----------------------------------------------------------------
Hao Li (1):
      mm/slub: deduplicate NUMA policy calculation in allocation paths

Harry Yoo (Oracle) (8):
      mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
      mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
      mm/slab: use call_rcu() in unknown context if irqs are enabled
      mm/slab: extend deferred free mechanism to handle rcu sheaves
      mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
      mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
      mm/slab: introduce kfree_rcu_nolock()
      slub_kunit: extend the test for kfree_rcu_nolock()

Hongling Zeng (1):
      mm/slub: add comment explaining intentional kobject handling in sysfs_slab_add

Li RongQing (1):
      mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and switch to static key

Li Xiasong (1):
      mm/slub: fix missing debugfs entries for caches created before sysfs init

Seongjun Hong (2):
      slab: remove unused SL_CPU slab_stat_type
      docs: ABI: sysfs-kernel-slab: mark cpu_partial attributes deprecated

Shengming Hu (1):
      mm/slub: prevent pfmemalloc objects from entering the barn

Vlastimil Babka (SUSE) (18):
      mm/slab: extract __free_to_pcs_batch() from free_to_pcs_bulk()
      mm/slab: simplify freeing remote objects in free_to_pcs_bulk()
      mm/slab: skip kfence objects in allocation profiling
      mm/slab: remove objs_per_slab()
      mm: move struct slabobj_ext to mm/slab.h
      mm/slab: make slab_obj_ext() determine object index
      mm/slab: abstract slabobj_ext.objcg access
      mm/slab: abstract slabobj_ext.ref access
      mm/slab: replace slab.stride with obj_exts_in_object
      mm/slab: change struct slabobj_ext to a union
      mm/slab: introduce slab_obj_ext_has_codetag()
      mm/slab: reduce slabobj_ext memory with allocation profiling disabled
      mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
      mm/slab: add cache_ and slab_needs_objcg() helpers
      mm/slab: stop allocating objcg pointers when unnecessary
      mm/slab, kfence, memcg: completely remove obj_ext for kfence objects
      Merge branch 'slab/for-7.3/objext_split' into slab/for-next
      Merge branch 'slab/for-7.3/kfree_rcu_nolock' into slab/for-next

 Documentation/ABI/testing/sysfs-kernel-slab     |  18 +-
 Documentation/admin-guide/kernel-parameters.txt |   5 +
 Documentation/mm/allocation-profiling.rst       |   7 +
 include/linux/memcontrol.h                      |  13 -
 include/linux/rcupdate.h                        |  32 +-
 include/linux/slab.h                            |  19 +-
 include/linux/types.h                           |  10 +
 include/trace/events/rcu.h                      |   2 +-
 lib/tests/slub_kunit.c                          | 190 +++++--
 mm/kfence/core.c                                |  12 -
 mm/kfence/kfence.h                              |   3 -
 mm/kfence/kfence_test.c                         |   2 +-
 mm/memcontrol.c                                 |  37 +-
 mm/mempool.c                                    |  35 +-
 mm/slab.h                                       | 245 +++++++--
 mm/slab_common.c                                | 111 +++-
 mm/slub.c                                       | 660 ++++++++++++++----------
 17 files changed, 940 insertions(+), 461 deletions(-)


