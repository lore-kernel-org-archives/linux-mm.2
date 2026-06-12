Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF49CCD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5DD6B0005; Thu, 11 Jun 2026 22:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC336B0088; Thu, 11 Jun 2026 22:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E28F6B008C; Thu, 11 Jun 2026 22:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5386B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:27:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2128EC28BC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:43 +0000 (UTC)
X-FDA: 84869674806.11.E634573
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3ECCA4000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iSnqPrUF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781231261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+nAVk0jQ1WR0TlwOtqmpPD5IZTU0EEVKPj44RNkLO9w=;
	b=eVRFG9g+hCvnKwyRrkpdEVRPfMvSWPyEMLdbOskYsf6qZPkNChcs1jiLcNnJYH1GadOype
	DPqvuMKCpXyxkil4kgGbM9NJ/8RVvtTqIshv2G3Jo40geaZ/pWcqdj1xZAB3xxMvb3zyLD
	iSLPpz3qENj6sxxuYL7mNXCbAZxM+nE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iSnqPrUF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781231261;
	b=ksDQ+Ndii/YXYnpvROdAL5nOby+AGvVHUaYCiCL8TO1mzUAreoNh5Lyp7hWubeg+FYrXXy
	f/u+f54ZYMa3AGGvH7SmLPF6tQR3gBCWG8RAeoJFqdbSMFtVKQ+dymw6cTLkRJtqitaYAU
	Bol+ccHVD1jRlWHMcF5yi7HkBdhvCIE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781231255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+nAVk0jQ1WR0TlwOtqmpPD5IZTU0EEVKPj44RNkLO9w=;
	b=iSnqPrUF9ghIgpxs/l4X1ShSfdiHvbdH1Oa+EgfCBF/zhnHGkViQhRuhb3IwqSJm0Q8ZJ2
	okR5zm7DUKFPBLMVfoLI/YXfzQHGKCAZwLl2UY1fl/GU72mqvOT5yoQiV/84RRek/H3ImU
	ho8+9IDfs5/h+nlfBufGwmYHM8aqOUo=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	chengkaitao <chengkaitao@kylinos.cn>
Subject: [PATCH v3 0/3] mm/percpu: Fix possible NOFS/NOIO reclaim recursion
Date: Fri, 12 Jun 2026 10:26:45 +0800
Message-ID: <20260612022648.13008-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3ECCA4000C
X-Stat-Signature: xt3ms5seea5tfonznked6k8qerkpwccz
X-Rspam-User: 
X-HE-Tag: 1781231259-334811
X-HE-Meta: U2FsdGVkX1/NpPg7iBXnAfuH6drB2CvCDpb2F/zxcgeHcljBoFhzzhhF4Xo96zKFR8WngaAKgI1E6XGGKlU4c5c8T7BxnERAXNxbXSOltGhrGYu/ThlVz223VASBuYaC85xyCUt/mWh0WK/bvDFtta7pH3HJ5Rk/8rTu9UV6buVDMywzMFfSMt6n5ibJXuS4PDa/aie9Qv7nUdMS3EDlx6nVO2XujqU1VHqKebWmiYDUieevvhIvN5J2oqpgmckKiNQ6LpQHdoLIfWzCc/6aa7Q+zA+rm5yPKQ/DQ68XixMNAJzXBLRviMnNr4dy/DcweGJklIPbzqceihBMnmYHCmqnQW9D7VbGXTvF9QFrkhpQNJB3t7FOEKKLZm0HWIuIbniADi3VWIFLzuRo2NEavLFOCgNpOemBZr7ntmdO423ba0xKTzzAc5dDxKoWPBJ5SMWBCFC6HMvGTYVXwGtOHY2trdDXGfkNtFmzps5mYHlO+f7sQZ42vZBwVqtsg+dysH75CoDtwzx95JhvB7k3gH3rsPOtm1uW8BjEsdiH6VQ/C96RPV5lyay9erw9UizZUxOQwtIKpx5aZGhcmaUE5nvDVTz0MryykzM1+MDmmvX0tSmDFy2TmWSRhxv6Zg4xxTnEa9vhqjYEQscY2eYgcIEeX3ct/LC6Ig1Uq5yaZFau4Otark+f29V1HVApP/Cbo1BU6mABstVLWomfPAB4UOwv1Cbs94wEO+piZI5a2G++azVlC+KqUCbmkiD+ONE5i0Z85nQ2JS1schvG3B08IVDHEimEjNUavy7G24PJIgoZZiehbetLYOtF+u1hWsAToqigMa//IGSC4INRk/Gv97WeHZG8dwoPKK8k7wZ2q6C8PjlIAvWwhmhG6eMMi3AdULhcCarGeKf1AeR/ogSH+8C87wHPoy8M7WgaTXcp8EjhsrYaiTHTXRNvmsgUrzfixKq6XJJeoRdr9yVCH7A
 hdhD1+sq
 ISVLDbu8MyQ4Cn2170CPwCfO+S7xZO+LLCUE0NgwnRV/FBgaxaIwgIoopSaGxVNV4VhpKrRGl4+/cqIpIkMgjIc1hyG7HR+zbu+FNFKvv7W0YBdb/eNfiw2y00LJOwN+DadpbItw4PXfVCH8K0oNVVat3NIi+rc62Knkw5T0mQbVrBrYOvANuRAl+ltIVlNGaOt1teUpZ1dfphzRse9CesDro4smZ+g256N0A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: chengkaitao <chengkaitao@kylinos.cn>

Hi all,

After v1 was posted, there were many different opinions, mainly around
optimizing pcpu_alloc_mutex. This v3 is intended to describe the existing
problems more clearly and provide a conventional fix approach.

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations
atomic") allowed GFP_NOFS and GFP_NOIO percpu allocations to use
pcpu_alloc_mutex and the chunk creation slow path. This restored the
allocation capability that was lost when those constrained allocations
were treated as atomic, but it also makes the percpu slow path visible
to callers from constrained reclaim contexts.

There are two related problems.

First, the create and populate slow paths do not fully preserve the
caller's allocation constraints. pcpu_alloc_noprof() derives pcpu_gfp from
the caller supplied GFP mask and passes it down to the percpu backing page
allocator. However, chunk creation calls pcpu_get_vm_areas(), and chunk
population can allocate temporary metadata or vmalloc page tables while
mapping backing pages. Those internal allocations can still use GFP_KERNEL,
so a caller using GFP_NOFS or GFP_NOIO can enter unconstrained FS or IO
reclaim while holding pcpu_alloc_mutex.

One possible case is blk-cgroup after commit 5d726c4dbeed
("blk-cgroup: fix possible deadlock while configuring policy").
blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
q->blkcg_mutex, and blkg_alloc() uses GFP_NOIO because queue freeze and IO
reclaim dependencies can otherwise deadlock. If the percpu slow path loses
that GFP_NOIO context, direct reclaim or writeback can issue IO to a frozen
queue while q->blkcg_mutex is held.

Second, allowing sleepable GFP_NOFS/GFP_NOIO allocations to take
pcpu_alloc_mutex means that unconstrained backing allocations made under
the mutex can create an FS/IO reclaim dependency against a constrained
caller which already holds an FS or IO lock and then waits for
pcpu_alloc_mutex.

This series fixes those issues in three steps:

  - pass the caller supplied GFP mask into pcpu_get_vm_areas() and use it
    for vmalloc metadata and KASAN shadow allocations;
  - pass the GFP mask through the chunk population path, including the
    temporary pages array and vmalloc page table allocation scope;
  - restrict percpu backing allocations performed while holding
    pcpu_alloc_mutex to GFP_NOIO, so they cannot recurse into IO or FS
    reclaim.

This keeps sleepable GFP_NOFS/GFP_NOIO percpu allocations working, while
avoiding the reclaim recursion risks introduced by making those allocations
eligible for the mutex-protected slow path.

Changes in v3:
Allow @gfp to pass __GFP_NOFAIL through. (Andrew Morton)

Changes in v2:
  - split the previous first patch into vmalloc-area creation and chunk
    population changes; (Pedro Falcato)
  - pass the GFP mask explicitly to pcpu_get_vm_areas(); (Pedro Falcato)
  - apply the corresponding memalloc scope around vmalloc page table
    allocation during chunk population;
  - replace the reclaim recursion avoidance with a GFP_NOIO backing
    allocation mask instead of only rejecting nested reclaim.
    (Michal Hocko)

Link to v2:
https://lore.kernel.org/all/20260604113101.89510-1-kaitao.cheng@linux.dev/

Link to v1:
https://lore.kernel.org/all/20260528132917.81123-1-kaitao.cheng@linux.dev/

Kaitao Cheng (3):
  mm/vmalloc: honor GFP constraints in pcpu_get_vm_areas()
  mm/percpu: honor GFP constraints when populating chunks
  mm/percpu: Avoid IO/FS reclaim in backing allocations

 include/linux/vmalloc.h |  4 ++--
 mm/percpu-vm.c          | 40 +++++++++++++++++++++++++++-------------
 mm/percpu.c             | 18 ++++++++++++------
 mm/vmalloc.c            | 23 ++++++++++++-----------
 4 files changed, 53 insertions(+), 32 deletions(-)

-- 
2.43.0


