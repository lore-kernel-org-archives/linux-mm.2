Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E89860A2602
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CNcaCASB
Received: by kanga.kvack.org (Postfix)
	id 9DDD66B05B4; Thu, 29 Oct 2026 16:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F396B05B5; Thu, 29 Oct 2026 16:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856D36B05B6; Thu, 29 Oct 2026 16:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE0A6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:33:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB5151C3B7F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:33:33 +0000 (UTC)
X-FDA: 85376814306.23.FC04C23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D82A64000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:33:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNcaCASB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=17oxeHm4MUFXx8oUnMg2RFZzsT/fdDnqLdZR64DpZFo=;
	b=P2Ab0QKyelt6AzIjOntVfjCopdUQQUNF2AXlG0kC7Eh01UFBt7WDsaPK3Rb6O89QUdv5Qa
	e9hJlQolecYo5whrn3n0HCV6BzRfhOgcvC/D65GNENS1Bv9KtYwXiKwIgIGmw1kG047wRe
	F4v31O/V4ZryAniHZ5fuaWyRcsbMb2Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CNcaCASB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306012;
	b=lyOrXnF+jwT+EbGdkrmfCl8VL79LsrNdkfjYIkkbuTyasb/PWZym0MkSNxFkcPvNc41UZQ
	6w7cCVDx+FxVWQXNVN6vbZPzMSaEQP35YgOnrKgSie72tSZlyvcSCfXlNSLJrJ03paz5lp
	MIABFoQV5uJXE8k3L7s16eJ74aNhoA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 385D543F00;
	Thu, 29 Oct 2026 20:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FAB1F01816;
	Thu, 29 Oct 2026 20:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306010;
	bh=17oxeHm4MUFXx8oUnMg2RFZzsT/fdDnqLdZR64DpZFo=;
	h=From:Subject:Date:To:Cc;
	b=CNcaCASBkr58BkeV5FzL0HNWxoVf1d7Rlajv79gTSCyzTkE8UVWkZWDPi59dKuXSW
	 tWfLF5byrXEIpUod1i7TmvAQrkDvnZIO8uC3fwEZiU19cxoq6PjqXRCIQUWyYVJMmR
	 3f3VeRic4DZCtZoT2rZwcT8OKgjKALj4Va6fiVeF0s2liIDTHEUsosMuXu+ebxh9eP
	 XKtThH4+3G61SbynruUTIxI4Y3GDMDDoOnZXAzDMFS6EXvBjLU74Enzg21lax2P+xB
	 n3IUmfliGEAzxoPxrHihHpIEGdSLCRYA3KavBEzvEvIu9U1pjyEGX9blFs8OsTZh30
	 VWwR7B9C577mQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 00/47] mm: various (urgent?) fixes
Date: Thu, 29 Oct 2026 21:32:55 +0100
Message-Id: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHet42oC/02NQQ6CMBBFr0JmbU1bFNSV9zDEtGUKVdKaKRIN6
 d0tGBOXL/P+mxkiksMIp2IGwslFF3wGuSnA9Mp3yFybGSSXleBSMOteGK8mEDLd2qo8WGW5LCE
 PHoTrNfuX5svxqW9oxqWwGL2LY6D3+m0Si/cL1//hSTDOKlvvNJqj2mt9viN5HLaBOmhSSh9Rf
 FwQtwAAAA==
X-Change-ID: 20261021-fixes_core-bdf638faf023
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
 Mani Tofigh <mt4022@columbia.edu>, Samiullah Khawaja <skhawaja@google.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5939; i=david@kernel.org;
 h=from:subject:message-id; bh=cGtcVx8+Zxqn025k2zdD4rFE67pcocOs1hUqk8Z4pYg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer63lutW86ETmr4pGiRuTg2c/XsmStPHZeYP33AvDX
 z4/yBnO3lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEzJsZ/nAvcHbjOWt1P8rv
 oLzhlrKSH1esZfhSEm59EAhUYb31vRyoojiz+6yxg2Nj2W/18INnPfMDTe7w3nowg929pVxpsR0
 3AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D82A64000B
X-Stat-Signature: 3uw75ok13ukztwwb43rfhmmnc4mreood
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306011-277554
X-HE-Meta: U2FsdGVkX18FeJ4DR52w87xjxGU5AvxQaLeVnq7pS5hw94+75Fzn8oj3JnEBwO3rGuUOihGxFrtjV7uoEpx5fG0CqKVr5AJ/WlJIKn3Yr9OlaGeI7PlSDUmHuT1nAZV4GTI/NFRGJBUwtoQbQPiifue0vAylY3V9VFo8f2GFHWFkltzxcDkC4Efpkj3cRE7v2Ky1UBhKg49eazsuaoBP3Smw/6zqskTn7QcKVgq8lBPEBIyypJ5C9M1JB/K0eEH+gInhQxjcKW1C7/bU/YSSyROtolSCGiUhgolv/b2DEKco8sItDFSlrTxSi4v/npDt/2qwKPp6Pn7tdRnPzhEheyIcO/ocdSlpZvMS7M+XCNkdTrQNc5b9vtrT9RroxTFzKVTKwDcoezymBn+zsIHkmzFfJyGknDnxrGP/JgCmbnnl5LgGOolxnBZbMmu10m9tdP72tIHrKdzQedD4/NnnpxER0rVVVmZLs/cn/Yq4yziWw8fp5yh2YJ9a/kC+XsZwTslB6vKi5wp9EfNHVAlu5lVDGYTjzp+nZwiXbcKfMyhjg33ihXqo6XU9STp3I3X0gX2Ur+9kwTCB1Au9+jIMEh+QgmyeIpxpp7pnaBKggTcXiN6bMyRjB9St8UiYdT5tWc+zuwKIM5rH8dBgbNRcNqIXPG58kmXDt7d7EXykOgV2bLg/PFQweLggC03eBW0jOdq2f2q7ko6xI3hQs6plBYpGP7+on7wAh/dmVypAc/GH0wx/MwTiCWFkqcwhScVG9KHVokz8iFgXFoPEr1YjVmifqAyS00L2mSZgJKDwHz2LAiEQ1y/Y0Y6B4u99rjcc8cfIf1uljdl7P6jMKRvNXW9tR1AK639c18LmSgVpQumQAxIWCf62JOA36eXj0B3VScZQoniy5uMQnIg8aLfFB2ICMnVVTuD0NDOSM41x3fnXnGej0W/NnhadxWhAhn7fsraKHFTqNEtCjMIEgXu
 dPktyi10
 2tooginw+uwB48F8Ov74uQugJrfB1FaOa5+fXdwnrmR+Hvdpj1JS3tttN00cuTZ+w3/RRIp1yi8zzwR3KF+3apPfRfc1vR294aOB8dEsL9hjhqoY671Xl+wHBwcQRp/xiYh49/e6yeMpB2HNGIXCd+XZqJMD+yRuAj+hyHDSL4XpP32QVNZJw9MfWAZw2GwsbQzCF5JgPtnCdeyPZEWIJnkQWqgCVnk/90uKRIUTaT6XVrIIaVVm2UWUtLOqmpmsJXUeveuYfWN0iopazJfBrSEkhcOvwT8X6BHJQ1hHFCjg1DNFbHBI+iwpRyuS3Cdn9aJIME2ovo7IqDQaH54Nw9wY3wDxh2SmP6C9oqh5AJzRbtKLp+HCpODSmMKiyopFZlR1aXFi9XABAvDPOFHK1T0BDyQO9Cia5XdSWIepRRrxSL/1yol1EmqHjGFDt+veDx7F0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

See v1 on details. TL;DR various fixes :)

Thanks to everyone for the review! Hoping I can get some more? :)

I am planning on picking these myself, moving them to linux-next fairly
soon through mm/core.git.

---
Changes in v2:
- "mm/memfd: check for real shmem inodes before accessing shmem state"
 - Call it inode_is_shmem
- "mm/truncate: look again if a folio left the mapping"
 - Different fix for truncate_inode_pages_range
 - Adjust description
- "mm/huge_memory: fix zapping migration entries for device-private THPs"
 - Move handling in zap_deposited_table
- "mm/mmu_gather: fix flushing ranges with 4 GiB or larger"
 - Adjust description"
- "mm/huge_memory: split huge PUDs when adjusting VMA boundaries"
 - Drop split_pud check
- Link to v1: https://patch.msgid.link/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org

---

Chris Mason (11):
      mm/huge_memory: fix truncate racing with PMD zapping
      mm/huge_memory: fix zapping migration entries for device-private THPs
      mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs
      mm/gup: fix clearing folios in memfd_pin_folios()
      mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast
      mm/mmu_notifier: set ->mm only after mmgrab()
      mm/memory: reject remote COW faults on PFN mappings
      mm: fix unkillable fault loop on MAP_DROPPABLE memory
      mm: fix deadlock of mremap() against UFFDIO_MOVE
      mm/ksm: check large swap-cache folios before mapping them
      mm/vma: call ->may_split() before a partial merge

David Hildenbrand (Arm) (20):
      fork: take mmap_lock before copying mm_struct
      mm/memfd: check for real shmem inodes before accessing shmem state
      mm/truncate: look again if a folio left the mapping
      mm/filemap: finish fault cleanup before dropping the fault lock
      mm/rmap: handle device-exclusive entries in folio_referenced_one()
      mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
      mm/huge_memory: properly handle refcounted PUD mappings on fork
      mm/khugepaged: check if PTE table is empty in try_collapse_pte_mapped_thp()
      mm/gup: recheck the PUD under PTL in follow_pud_mask()
      mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
      mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
      mm/userfaultfd: wake waiters when registration modes are removed
      mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
      mm/mremap: recheck PUDs under the page table lock
      mm/madvise: fix data loss from MADV_FREE on a KSM page
      mm/ksm: reset the unstable trees of all nodes
      mm/ksm: fix use of a freed anon_vma at swap-in
      mm/huge_memory: split huge PUDs when adjusting VMA boundaries
      mm/vma: don't leak the charge for stack growth
      mm/memory-tiers: unregister empty tiers outside memory_tier_lock

Gregory Price (1):
      mm/userfaultfd: compare exact registration modes before skipping

Josef Bacik (14):
      mm/mglru: don't use stack pointers when walking PUD and PMD tables
      mm/memfd: make f_pos accesses atomic
      mm/filemap: read mapping->a_ops->free_folio under i_lock
      mm/filemap: don't lose a folio lock wakeup to a signal
      mm/huge_memory: fix livelock on device private folio
      mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()
      mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()
      mm/userfaultfd: wake all waiters on unregister
      mm/mmu_gather: fix flushing ranges with 4 GiB or larger
      mm/mmu_notifier: finish non-blocking interval invalidation on error
      mm/mremap: fix moving PUD leaves
      mm/memory_hotplug: avoid races in pfn_to_online_page() with dying pgmap
      mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
      fs/proc/task_mmu: refuse addresses beyond 32 bits on 32bit

Rik van Riel (1):
      mm/cma: don't release CMA pages still in use

 fs/proc/task_mmu.c            |   6 ++
 include/asm-generic/tlb.h     |   3 +-
 include/linux/huge_mm.h       |   5 +-
 include/linux/ksm.h           |   6 +-
 include/linux/memremap.h      |   6 ++
 include/linux/mmu_notifier.h  |   3 +-
 include/linux/shmem_fs.h      |   6 ++
 include/linux/userfaultfd_k.h |   2 -
 kernel/fork.c                 |  20 ++++--
 mm/cma.c                      |  10 ++-
 mm/filemap.c                  |  88 ++++++++++++-------------
 mm/gup.c                      |  53 ++++++++++-----
 mm/huge_memory.c              | 146 +++++++++++++++++++++++++++++++-----------
 mm/hugetlb.c                  |  14 +---
 mm/internal.h                 |  28 ++++++++
 mm/khugepaged.c               |  77 +++++++++++-----------
 mm/ksm.c                      |  56 ++++++++++++----
 mm/madvise.c                  |   9 +++
 mm/memfd.c                    |  10 ++-
 mm/memfd_luo.c                |   2 +-
 mm/memory-tiers.c             |  29 ++++-----
 mm/memory.c                   |  30 ++++++---
 mm/memory_hotplug.c           |  13 ++--
 mm/memremap.c                 |  13 ++++
 mm/mmap.c                     |   8 +--
 mm/mmu_notifier.c             |  24 +++++--
 mm/mremap.c                   | 103 +++++++++++++----------------
 mm/nommu.c                    |   2 +-
 mm/rmap.c                     |  23 +++++--
 mm/shmem.c                    |   5 ++
 mm/swapfile.c                 |   3 +-
 mm/truncate.c                 |  13 +++-
 mm/userfaultfd.c              |  75 ++++++++++------------
 mm/util.c                     |  13 ++++
 mm/vma.c                      |  24 +++++--
 mm/vmscan.c                   |   4 +-
 36 files changed, 585 insertions(+), 347 deletions(-)

---

base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d

change-id: 20261021-fixes_core-bdf638faf023

--

Cheers,

David


