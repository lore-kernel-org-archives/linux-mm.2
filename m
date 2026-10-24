Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3A0606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BWeHkD3B
Received: by kanga.kvack.org (Postfix)
	id C7E896B0095; Sat, 24 Oct 2026 07:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F386B0096; Sat, 24 Oct 2026 07:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E8E6B0098; Sat, 24 Oct 2026 07:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1F66B0095
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:21:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BDFD1C37B4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:21:48 +0000 (UTC)
X-FDA: 85357279896.09.7D33B22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96F8F20003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:21:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWeHkD3B;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792840906;
	b=gNLFlFUBwGWGdfoainU2BCepfMG2mUqRc54ZviWgErWKNhU4OKBNL1yvH/DAvKRLGNIbPs
	VXQqZzXP9D1BNkSa0lbsw7dI1voPflzQO8S6C7q6B19aoGFi847lTJYgXIYFzDZxIt+iRg
	V5LOJO6+FE5GzgsqLntV77xTB6N+a8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWeHkD3B;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792840906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iDDeg9qjHmGV6IXYQKG3+nLfuCV82jMJnayxqcQwlbI=;
	b=nzJxqLlKAIKR9RiaBcXn9hlBoaBlp/yHCqdapGkFurxvmuQhV5y/1kVaK07ehEdRQWLDnz
	vcBrhv+03bhjqFnSmLcbKVCRzZgawFN+TqJvQX42rngL00LlSgfptmGgdtdv8xZkusZKen
	k9nt52j84kT07aaKnzXGPjGdqymikfU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09A6D4006B;
	Sat, 24 Oct 2026 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500221F01829;
	Sat, 24 Oct 2026 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792840904;
	bh=iDDeg9qjHmGV6IXYQKG3+nLfuCV82jMJnayxqcQwlbI=;
	h=From:To:Cc:Subject:Date;
	b=BWeHkD3BxXtLiI7xqTS7+XkJgaANCXW93y9p4EzdaFJ1wuLgNj5IJLtyL4UukLqee
	 A1Uk9MK+qPb8qIScenE4BJNTXaFXVx+p8/uRSUPTMTKWFqXGMTzpZIyeb18AFoK61c
	 UZsTxMqJymOvLFCf1FZrl00MIz0/KjWMbgcISrhTf9+t7DtdvK3M1sGPe5FxnAH108
	 SDurcjRm3GtrL0dcNTDFWITE3PdxpKQrEMw3ssB2/D9NF44HvPGJtSScv95UdKbl/H
	 8dkDjQbv6zi4RjdqQ0swEDBJP4TylEJEQI/CQH7LyE8a8lua1amC6mhD+QGIBk9aYF
	 Ys9yKuxnzjsmA==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] memblock: updates for 7.4-rc1
Date: Sat, 24 Oct 2026 14:21:29 +0300
Message-ID: <20261024112131.3384572-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96F8F20003
X-Stat-Signature: gtaejrup8mkmcmb6t1rzb71jxzwyjhjm
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792840906-702913
X-HE-Meta: U2FsdGVkX1+xVI16Dlw+uVQtljoACcCsYnCgXGXUy9sV77EXDZn9SSox+DcBF15pNAC8AX/Y5FB8gVYPR2CrmRswUgFKEVMt5mo6lrfg+W9Mt1XRfztzyMX2/hNuY5YU5aqTGxq33yGHH1TtuXfDxE/9sBrWusedTufFtTL6fb2tX7DmMzCngxKaQMSMiYXIhCa4u+lkY2tYTWEJpoDttS9SellNHW88zAi7teGXa3RuAoD/3FPLgJoqbLBVk+GnPSrtbS7C6B8yzfXupjqeGPw0Jk5kkDYr2oY9M6KVzxK1g3k46vy6NUugeVlEmpGMYpvWoVnFch/AH23dGVzixBSCQ4rrO5WIpckWKXZ0UdKnkvzDRRE8NYA5yq1KFgnlkDcIenWtKDxNBvoUD57LnVd0dCvSy3Oo4Xx4df8ZYKb0tsWaQCT5+hk45gcbKKyXtR2P4Rsyp3NRbgUAfNDKQ28mBSth6f+O+J2K1J+hpcNvDE8mcftJlOycIwkkIShMZccTCWe24Szp0c4FwPTKRCSs83nfedcu1UCLZgmkSVtPU+C/HEnts59d5FrjnAt3v9AqFrdUgMVhO3N73LkQGm0UdHMeDlebtXOe5b6MsKfsIUQxxUlxh+7FZEPLaCrQtCSeAfcwZ+TZ96lpms2y64/aFqr5pAwcoNygZgBvsAE53jVI1U1YW1flzHRzZ9fgEby8ugvYvZeWdMvl4YiKTgnRnqMrb2tfvfqkJpwtCZKJLVfytwYwDFNq6VZF1FkxvBaCBWe8tJ9zw1vf9oyYuaLhnJD4CV7rhd4TAcKUQhyCFY7P3S5GD5lTr24KB8K34mmm9CZ6NZbCmX/WuX9/dXcg5WBYj+IZrM2nkmJ+Fku4vWG5vzXAAVOO8JLUJ6Jn9ErFhIrpbLnAmPZkjYP+ipTE/gIpZTzTyvIxjCBXLpOZh0yztkhVMpJysrPxDuBuHK2w+otf6z/uh3ragoD
 2rPO3SZ8
 yqNrikCpkVuJKNajudJq7qIqfigFBIYXHJ59YQqhku9U62X7XE0aZMysoqhHhavORdaFZbw0hY1ViszF5YBhqfhtkAGzPyrw1ZpvQ1Cz5fUvAjj0OZhPkE3Sar0DRpNKj1fqnl6fYwakyBNEH4cKhRPMw1F4DvbgoYJr93z+E7SMx2ojapYHSsy8m8ihdkQTC0XWQcQigVPuW9xaYtwUp5HVqbb4vKQUhUdlmuOpcf/dt22c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

The following changes since commit 6e33dc90df108c76899dc544a42d17adcba61668:

  MAINTAINERS: update memblock tree URLs (2026-09-09 20:28:14 +0300)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git tags/memblock-v7.4-rc1

for you to fetch changes up to 7933ad3f669670ca5f5f13de2b5cb0f92b91abf5:

  memblock: use binary search to locate candidate regions (2026-10-15 09:39:37 +0300)

There is a conflict in mm/sparse-vmemmap.c and here is how my resolution shows
up with git diff --cc 17bb0e2f6c804  -- mm/sparse-vmemmap.c:

diff --cc mm/sparse-vmemmap.c
index 5a2469fb1838c,23b31bc4bf94a..0000000000000
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@@ -78,8 -62,7 +62,7 @@@ void __ref *vmemmap_alloc_block(unsigne
  		}
  		return NULL;
  	} else
- 		return __earlyonly_bootmem_alloc(node, size, size,
- 				__pa(MAX_DMA_ADDRESS));
 -		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
++		return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node);
  }
  
  static void * __meminit altmap_alloc_block_buf(unsigned long size,

----------------------------------------------------------------
memblock: updates for 7.4-rc1

Performance improvement:

* Use binary search in memblock_add_range() and memblock_isolate_range()

Cleanups:

* Several simplifications in memblock and mm_init that remvove redundand
  code.
* After rework of sparsemem buffer preallocation, memmap_alloc() does not
  require exact_nid parameter. Remove that parameter, drop now unused
  memblock_alloc_exact_nid_raw() and ajust memblock tests accordingly.

memblock test updates:

* add coverage for lowmem allocations
* fix 32-bit build warinings

----------------------------------------------------------------
Kaitao Cheng (3):
      mm: Remove unused exact_nid parameter from memmap_alloc()
      memblock tests: Move exact nid tests to memblock_alloc_range_nid()
      memblock: Remove unused memblock_alloc_exact_nid_raw()

Mike Rapoport (Microsoft) (3):
      Merge patch series "memblock tests: cover low-address allocations"
      Merge patch series "memblock tests: fix BUILD=32 address conversions and warnings"
      Merge patch series "memblock: Remove unused exact nid allocation API"

Sang-Heon Jeon (4):
      memblock: simplify reset_all_zones_managed_pages()
      memblock: remove conditional return with no effect
      mm/mm_init: remove zone_absent_pages_in_node()
      memblock: reject non-page-aligned reserve_mem regions

Tarun Sahu (2):
      memblock: drop for_each_memblock_type() and open code its users
      memblock: use binary search to locate candidate regions

Tianyi Chen (6):
      memblock tests: model the low allocation limit within dummy memory
      memblock tests: cover allocations below the low address limit
      memblock tests: use physical addresses for region removal
      memblock tests: zero-extend simulated memory addresses
      tools: use __pa() in virt_to_phys()
      memblock: initialize the region merge end index

 Documentation/admin-guide/kernel-parameters.txt    |   3 +
 include/linux/memblock.h                           |   4 -
 mm/memblock.c                                      | 127 +++---
 mm/mm_init.c                                       |  38 +-
 mm/mm_init.h                                       |   4 +-
 mm/sparse-vmemmap.c                                |  17 +-
 mm/sparse.c                                        |   2 +-
 tools/include/linux/mm.h                           |   2 +-
 tools/testing/memblock/Makefile                    |   3 +-
 tools/testing/memblock/README                      |  12 +-
 tools/testing/memblock/TODO                        |   5 -
 tools/testing/memblock/asm/dma.h                   |   6 +
 tools/testing/memblock/main.c                      |   2 +
 tools/testing/memblock/tests/alloc_exact_nid_api.c | 454 ++-------------------
 tools/testing/memblock/tests/alloc_low_api.c       | 148 +++++++
 tools/testing/memblock/tests/alloc_low_api.h       |   9 +
 tools/testing/memblock/tests/alloc_nid_api.c       |  20 -
 tools/testing/memblock/tests/alloc_nid_api.h       |   1 -
 tools/testing/memblock/tests/basic_api.c           |  20 +-
 tools/testing/memblock/tests/common.c              |  12 +-
 tools/testing/memblock/tests/common.h              |   2 -
 21 files changed, 294 insertions(+), 597 deletions(-)
 delete mode 100644 tools/testing/memblock/TODO
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.h

