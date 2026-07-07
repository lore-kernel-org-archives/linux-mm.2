Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1642C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6086B00A2; Tue,  7 Jul 2026 02:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D675E6B00A3; Tue,  7 Jul 2026 02:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C556C6B00A4; Tue,  7 Jul 2026 02:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94F526B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:39:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C45D4030B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:39:16 +0000 (UTC)
X-FDA: 84961028712.28.E34369E
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf09.hostedemail.com (Postfix) with ESMTP id B10CA140008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:39:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=bHIN3JX2;
	spf=pass (imf09.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZDJSgUwHqq8jxXQvcm742CwOtIu0SZlIT9GfO+c8Z6k=;
	b=t8RKoLdCBc8sPaiiLZjCf2SSOZ+D8aLhjc9SqMd1EqZDdWsN6w9J7NanV3X58UFWWv6HCZ
	yXyZv2E39I2flIyHpNVwU89L2VerPZQzfQ+94V53TBFiINOg3ldX+3zYHF2FK2WK4kzm3I
	6gUY+NBAD2vswcbVYnDDDbw0358IcHU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=bHIN3JX2;
	spf=pass (imf09.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406354;
	b=ubhTZN0rzvnC21+g0f9QH4XEt7QGe+oBLglb2hyrEYREyFnelOgHKX9jZOdgztOif/LfTT
	LxjEq/HZDKyXCE3E1cHVH2y/ygDKyCq0SIaOtf25qb+2qECGqcFoE8wD0P8PgXrSCB7I0V
	S6MrghULJYiXovcuCff3PB2DAr7+MeI=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ZDJSgUwHqq8jxXQvcm742CwOtIu0SZlIT9GfO+c8Z6k=;
	b=bHIN3JX2VTj6Lgnx1DhVZMbJrkK9eQ0rJDgt52+sZ0u+Tac3apEhlzLov3GZI0+ifhr+3YSKp
	wF4nV43ClFnYyCQQZNeMvX1R9OEGjyYwqysc0jR52XP0ZRMt5SuzdkHgzSY8rTgsbkk51UF09t3
	YWurbrwWeQgOZOmJJFxj5UU=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gvWlv1mxwzYlvpK;
	Tue,  7 Jul 2026 14:39:07 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:39:06 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 7 Jul
 2026 14:39:05 +0800
From: tao <tao.wangtao@honor.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>, <kas@kernel.org>,
	<ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <muchun.song@linux.dev>,
	<baoquan.he@linux.dev>, <nao.horiguchi@gmail.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<pfalcato@suse.de>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <damon@lists.linux.dev>, <shakeel.butt@linux.dev>,
	<ryncsn@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>, tao <tao.wangtao@honor.com>
Subject: [RFC PATCH v2 00/13] mm: rework anon_vma and remove anon_vma_chain
Date: Tue, 7 Jul 2026 14:32:55 +0800
Message-ID: <20260707063308.29176-1-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW002-1.hihonor.com (10.72.0.137) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B10CA140008
X-Stat-Signature: aofpmdk3hxa74uxrktpqgzc3apemi9e6
X-HE-Tag: 1783406353-999538
X-HE-Meta: U2FsdGVkX1/Vf5tpBNOC9RyTAUy0+SSZ8UbUGF+CeLjil5gryFVwCm/GipiXI5dYDjgxvQF1LP/cmC9hTwm98lwvclEEeugGkQP1uBr0LgnLpcSQECGRLnGBmk4/ozKZ9ORmDtsd9EDC4NsLVnY6QgHcSCXDBAwKk/QyceRb74GxNduMlcP6rW9HvmNtIhxni4BLH8dojfRt8SWdteSGAE4DJ/88hSec3MpqzVbAjNpyO/ihkhr3Na6A4okJP/EUYJzuD06BbbIe5Bqiu8N+nD4cpiIFWlGE6QEOlyyj2nr7o/1fIvfZ7rlE5X4DuUDuKlZFXOA6otDueqDs6LVkjIMeP4Q2qsbn57eR16vtY0f+fmUMNEXHQQVGWkKZ0Eci8f1AMoY93BEYH0Nn+iyLEz7sP/cTJeQcZ2jJRgTXv3NniQvcO1oWMydmZKE7ajySgyX2lVFrljtMBH4+TwE53bkonVwM0CSNduWg/FrnIzbxwQXzs6d0epDuO1oobjq09jrH2tqF87fHHXp0o+lJ5+tJGBGs9u+JruTlJFDbsGFSRiLBWKWmEMewPCDZ7nRaYcX3Cnu+DmQeFYNlYcpw8CAOw51tN3wDX33hNIrA2LvirNzzb+xD8UNBxcK3RNwUTGgNLE0xZSX/ka8URiedG1rJiJLEj0CGBEI9rok2x/fHjtjB2nCi50gSk5JmsBqMB07Kg6PwdV2q24DXi2K08bMUOX/H+GbOrUUE7J5XP9O03vVsxnG8gcyZvu8wcseoawBW/4/lSI/mDBJtk97nMaT+wyJ9Wh14cr3o4uke/Jtiv1V5BYkAZ2NXf/f3KCrC+LrmNORviEYaMo8VyrRsGAGEuOFEJk3BWe3Y5ZJFPIdHE8o4QLpIi4LnoP+qegtWn+IvCtDyvEqrmJ5rfpEqHxw5I2EDPWHbwe3T+MB2DTIE0U356nwQIy4wtyNqxi7jmnjP/ioUnh3VxErZIt5
 HYPltFmO
 AuhJ71ENLWQTy4bbYhKKL2pLwFHv6HsgEjl0KY3WuU1c8B9OsjhqimwcY4vZJnttlYWOG4VXC9OGfgLp8KvYKVpd+t8lcBLg9vDUTDP3khbMT7JPU8TpHsoBjLUn4NatlzU0E4xZUBwDrBd1PpxfYVdmwhlu0qkC4aMtDAfrfYjlbHlcHV+XPMeojniOMGoDeNQY4CUi+hZ3MgA+JpVpQqcuxpov7oFYBLnwH7F4Wfn5vR0QZyqGgC/AvzqXmLdAHK6qzYUlmBMm8zwDTSpsaUMY+leZpZ0u1L8bSUhDT6HnoCH21lL1ZWiDbEyGHEkKAGRIeSZzhTrRWgtWfoj/4KSf2+qSEUlfIKC6rXOWaOP0WGHytEpD1afASsd9dFiLi/05O8sFSw6dJZ0O8vceaNvYrVz+dES6GhvTST5J/g3b05giDEkoD+V15fTcsmzm3J/Gg6o95C4zMAVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Since v1 was relatively complex and difficult to extend, this version
adopts a simpler anon_vma implementation approach.


Replace the original anon_vma + anon_vma_chain multiple rbtree
structures with a depth-aware doubly linked list, and remove anon_vma_chain.


During rmap walks, vma_rmap_base(vma) is used to compute the page
address and look up the corresponding VMA from mm_mt:

  vma_rmap_base(vma) = vma->vm_start - vma->vm_pgoff * PAGE_SIZE

  page_address(vma, pgoff)
    = vma->vm_start + (pgoff - vma->vm_pgoff) * PAGE_SIZE
    = vma->vm_start - vma->vm_pgoff * PAGE_SIZE + pgoff * PAGE_SIZE
    = vma_rmap_base(vma) + pgoff * PAGE_SIZE

Since vma_rmap_base(vma) remains invariant across VMA merge and split
operations, VMA updates only need to adjust the VMA count of the
corresponding anon_vma. The anon_vma no longer directly tracks VMAs,
which eliminates the need for anon_vma_chain.

Process fork behaves like a fractal expansion of both tasks and
anon_vmas. A dedicated fractal_list records forked anon_vmas, while
descendant anon_vmas are derived from fork depth during rmap walks.
For this reason, the new design is named ANON_VMA_FRACTAL.

The depth is initialized to 0.
When a child is added, the root depth is set to 1.
A remap child has a depth of parent->depth + 1,
while a fork child has a depth of parent->depth + 2.
For example:
 1) A forks B and C:

	                   (1A)
	                  /    \
	                (3B)---(3C)

 2) B remaps D:

	                   (1A)
	                  /    \
	                (3B)   (3C)
	                /       /
	              (4D)-----o

 3) B forks E and F:

	                   (1A)--o
	                  /       \
	                (3B)      (3C)
	                /         /
	              (4D)       /
	              /         /
	            (5E)------(5F)

 4) C forks G:

	                   (1A)------------o
	                  /                 \
	                (3B)      (3C)       o
	                /         /  \      /
	              (4D)       /    \    /
	              /         /      \  /
	            (5E)------(5F)     (5G)

Only the root node A needs to traverse all descendants; non-root nodes
only traverse their own descendant nodes. For example:
- When rmap-ing A: first process A, then traverse all descendants
  B/D/E/F/C/G. A does not need to be traversed again.
- When rmap-ing B: first process B, then traverse its descendants
  D/E/F. Since C->depth <= B->depth, the rmap walk terminates at C.

The fractal_list remains stable across VMA merge and split operations.
It is updated only when anon_vmas are forked, remapped, or unlinked, and
is traversed during rmap walks.

On an Android device after boot, memory usage of vm_area_struct,
anon_vma, and anon_vma_chain is reduced by about 35 MB.

  struct              base(KB)  patch(KB)  patch_struct      saved(KB)
  --------------------------------------------------------------------
  vm_area_struct        110760     103837  vm_area_struct         6887
  anon_vma               19152       8576  anon_node             10576
  anon_vma_chain         17560          0  NA                    17560
  NA                         0        346  anon_semaphore         -346

lat_proc shows fork performance improves by about 15% at P=10.

Changes since v1:
- anon_vma now stores mm and rmap_base for VMA lookup, and only tracks
  the number of associated VMAs instead of directly tracking VMAs
- Use fractal_list + depth to maintain anon_vma topology and remove
  anon_vma_chain completely
- Keep folio->mapping storing anon_vma
- Preserve existing APIs and external callers unchanged while
  introducing ANON_RMAP_FOREACH_VMA() to unify anonymous rmap traversal
- Use vm_refcnt on leaf VMAs for rmap protection
- Optimize rwsem memory usage with shared semaphores

Patch layout:
  1-2: add CONFIG_ANON_VMA_FRACTAL and basic helpers
  3-7: implement anon_vma fractal infrastructure
  8: implement anonymous folio rmap
  9-10: replace anon_vma with anon_node
  11: use vm_refcnt on leaf VMAs for rmap protection
  12: optimize anon_vma memory usage with shared semaphores

v1:
https://lore.kernel.org/all/20260527110147.17815-1-tao.wangtao@honor.com/

tao (13):
  mm: add CONFIG_ANON_VMA_FRACTAL
  mm: implement helpers for ANON_VMA_FRACTAL
  mm: implement __anon_node_prepare for ANON_VMA_FRACTAL
  mm: implement anon_node_clone for ANON_VMA_FRACTAL
  mm: implement anon_node_fork_with_prev for ANON_VMA_FRACTAL
  mm: implement unlink_anon_nodes for ANON_VMA_FRACTAL
  mm: handle rmap_base changes for ANON_VMA_FRACTAL
  mm: implement anonymous folio rmap for ANON_VMA_FRACTAL
  mm: prepare anon_node replacement for ANON_VMA_FRACTAL
  mm: replace anon_vma with anon_node for ANON_VMA_FRACTAL
  mm: optimize rmap for ANON_VMA_FRACTAL with PVL
  mm: shared semaphores for ANON_VMA_FRACTAL
  mm: Enable CONFIG_ANON_VMA_FRACTAL by default

 include/linux/mm.h       |   2 +
 include/linux/mm_types.h |   2 +
 include/linux/rmap.h     |  56 ++++
 include/linux/rwsem.h    |  10 +
 mm/Kconfig               |  37 +++
 mm/internal.h            | 205 ++++++++++++
 mm/ksm.c                 |  19 +-
 mm/memory-failure.c      |   8 +-
 mm/mmap.c                |   7 +-
 mm/rmap.c                | 686 +++++++++++++++++++++++++++++++++++++--
 mm/vma.c                 |  76 ++++-
 mm/vma_init.c            |   2 +
 12 files changed, 1056 insertions(+), 54 deletions(-)

-- 
2.17.1


