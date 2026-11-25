Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23DE606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oeF+83ri
Received: by kanga.kvack.org (Postfix)
	id D97C26B0AF1; Wed, 25 Nov 2026 17:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F9C6B0AF3; Wed, 25 Nov 2026 17:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FA86B0AF4; Wed, 25 Nov 2026 17:33:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97CF96B0AF1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:33:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2520280188
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:33:30 +0000 (UTC)
X-FDA: 85475094180.07.47F0EF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A2864000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:33:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeF+83ri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646008;
	b=v2C+SjsG1FLJ9YKbEH5VYp15AJJdM4+esbUng0nGvD1l8TxVtloFh8ClkfrKn5lb4YSKqA
	jnzwRI3O+qDgRILFpNbbKTjkoBLFrlb/IAPhrvn/7kCdImB5P4UpdbEKwed5L3MMKKxdLd
	AtPormuNfUnN47voypz6TCLQbxw3HP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tzn+by+k8G1JwXk+S/E0tJAgmy0jLDfOi0f5NcqA/MY=;
	b=pn6tZxdHx06+Zy1ZNbKyFFvbo9CF2Yg+8kVsj4V8Dvs0oh0AmQPNkHZclwWXsxY0IRMiYX
	LEZsXVS0xic6GWci36aoYWfIyBjX4fDQSO5n9fyaf80mYQtLmLyLqibjCl7+kNIdIhOUzx
	5girTncP3715wkluQcFa2kET5heWK4Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeF+83ri;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A737E415D7;
	Wed, 25 Nov 2026 22:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655D71F000C0;
	Wed, 25 Nov 2026 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646006;
	bh=tzn+by+k8G1JwXk+S/E0tJAgmy0jLDfOi0f5NcqA/MY=;
	h=From:Subject:Date:To:Cc;
	b=oeF+83ripG+YMJQ6SibQuirzvfqlLreGg2dU0N4iBw6J9SwMfGbEdiYCtiUZLOpMd
	 JYqiF79Vytug9G0B2DkzFLIWoipJtdH+XMvOxqN0DGGpyctPV9W9zPh95DOEF2Z+QY
	 Xceo8UU5pO3BjrUwnu0S1uUp8LqLqgTugPbAVmqe/LCUO1oXZ7psZ5qitBlKCivcYb
	 cJwxUd3Rj2XwgOzgIRdtbB/JU+sW9VMX6ByXF7MliTP9djs6rMrE08LzryKnJqRfcE
	 PzisQMZIlNmWvvo++RWg05A5YHf7BJGoQffk2A7bJcTCTSBVSYYhY9OhGmH+h5669x
	 28AaXAPpZrf/Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 00/21] mm/hugetlb: various fixes (2)
Date: Wed, 25 Nov 2026 23:32:58 +0100
Message-Id: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMUQqDMBBF0a0M79uAGRIp2UopoumoU4otGS0Fc
 e9i+3k5cDeYFBVDog1FPmr6mpHIV4Q8dfMoTu9IBK658Z5rN62jLM++HfQr1rLjJsSY4yUMQVA
 R3kV+hETX279t7R+Sl3ODfT8AsQh4LHMAAAA=
X-Change-ID: 20261120-hugetlb_fixes_2-26455c584f4e
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3106; i=david@kernel.org;
 h=from:subject:message-id; bh=nzCzOz26eddU4SO7rlRqgKmrjP0kTfGyA8Ecr2EgmCo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk5TjVFYV1bZe5k5Juf3u5oJJF15cifxTFhJhcLJqq
 bD0jE2KHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExk40aG/zULo7sKr5Xeb15i
 yrPhVfhsTYlSt3trHn7f/fipxO+MF84Mf7iiPeLe3jxfdNmWL429a9eJRb0vt/byrv3/cI5p6+N
 fbnwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User:
X-Stat-Signature: yw9fz6dwmychm66pxg875ib7duuzy48h
X-Rspamd-Queue-Id: 3A2864000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646008-990737
X-HE-Meta: U2FsdGVkX1+UnDizOl0SLqCEJ5df8JMiWSyyZIhzOGXlQhtoIDRm6rXoC2VZ5ETYuUEFLAykNh3hnxj1vm0jTq5jbJnDL4tYImSCdvTbr4whlLa9DuYTjEnZLNx9G5ZbWpaj6yVd/BT7orFcx96qR3LxBvQ13Z1o0p/DXyLEYSkkAW2o4SuPHqs8+3xppOX3AwRqcJWP4j2DW14bla2eWCnwqTYSSReqqKuVMzZgpG/B4tYhN3TJWdDrT7EKnijYujEMdJfM4jNPbxQNO66gDeGNHTXKF6K0VjuEdACfxnpr4W9YOXofjaqI0/cAYI3zDvKxtpaiqpYvAXLtCyq2QPnsl/qQPEgd4uroQjqIEdY11yzXWOhHrAyIsRXr6/wNoRh30ICBz9ucI779T7ggrZVRvTkGgsgbTwwOAQc0AZWtFgUFzzNylKiglMLsTZX6moR7oHT53MegUcAtIBHWAurxN3AQLRmaYR32rcmzE0/RgnY4iMJru1csDvkb5FTaTOpciWRc4nH9u8fboUCbxphdfgukm3jeBKwGIyiBw82x2aAWb9JDtgC7QL5CzbO0QRlqlufy+Vk36i2LZ6dGkTwGcu+g2nx0GNQcbTOlk/5COc4j6vrztvgXo40lFIf0I7dGsZqNLAKdNA3ulZ6/xj3mzjEPe41Lz89E7dDfyz1TWB5jldTaDbz2qIn8tUVMF57y6g7RK+g9/P9Q5GID1DNSGoKi9Y3XV108V1tkPp22KAk/FfP8edHQOfokaIWUSETmqhUj3Cn83wKK8/4Kgwd4shDXEeYOrzilNJ7gAVSxftDHSLpbwlz7YXHkP+ru85XU9lR1Pb+7IVYGcJK0byH1uMesa7rfYcFlU3VCYnKwa0qz2KWFionJEDZ53XaRsvXDxiT3soruA0TFWW9v8OjjflcvW8nIEIwc0E4JT4ullURdawuyspN7LKqsFVWsYCRyjxjmm7yHuQNacw9
 aVAnmCuP
 /M6QiSKcVEaPEI2ImY2H0PzdfR8Q1hL8dyr3dkygF7EejEtmti2pxxouLkaQjdrKK3nvmCNNPw6PJ0CTAT2Udqv9jdgplOzvHxuQ4jDowMVkJBxuRV0qIeCzkM7aqYBKwHKuPXCEbK38TeiOoteKeaUBw+QBILAkuczvK3WDMxG+w14/T+H/7jT8SkKGoH9nyupRVHIdFQiD7WSJYOILDwQtK5sB4CkityTcCImpRVT6caUAn0bIn/ctYbPOAW5LJhFmp3EJg4mgEoWSBT13DZPxAauCaR36hn+nPrW+VfpfV50GzRUIuLHZssCQq8bVMXMLmg5tZGBhr8cvq0ezj6zcV4qN/MLNHuGawMqowIz2qjXd4KS0FAmXd/w1xtIUZk+dTcGMNeicutoWxJt9e33vYf1rre4IaOdwSs06DoODpbD61Vqlk0VpayS+L9dcbUxAQWQurtKvXAxrtyu7/SGLG+nX2SJESclUrTjh5uX50kZGp2uWvQJ9J/H+WMbOfzfP7C6LLj4yB9lAkbEVjwEPrBei3ccU30b3lewyPNk1dISc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

some more hugetlb fixes, this time not as horrible and confusing stuff as
last time:

 - Patch #1: a hotfix for v7.4
 - Patch #2 - #18: a bunch of non-urgent fixes
 - Patch #19 - #20: two related improvements
 - Patch #21: an RFC for a hugetlb cgroup fix

I think patch #21 is the right thing to do, but I am not really a cgroup
expert.

Patch #19 deserves a closer look from our VMA locking experts :)

Patch #1 should go into v7.4, the rest can wait for the next merge
window.

Tested with hugetlb selftests and some targeted tests that reproduce
some of these issues.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Chris Mason (8):
      mm/hugetlb: fix truncated copy result in UFFDIO_COPY
      hugetlbfs: fix deadlock between hole punching and memory failure
      hugetlbfs: recheck the vma range after the lock wait
      mm/hugetlb: don't zap non-present entries when unmapping a folio
      mm/hugetlb: unshare PMDs of a split VMA if allocating its lock fails
      mm/hugetlb_cgroup: track in-use folios per cgroup
      hugetlbfs: seal SHM_HUGETLB files against growth
      mm/hugetlb: resolve protnone faults without a uffd bit

David Hildenbrand (Arm) (13):
      mm/hugetlb: charge the copy made at fork to the parent
      mm/hugetlb: always mark new page cache folios migratable
      mm/memfd: mark new hugetlb folios migratable
      mm/hugetlb: free surplus folios of other nodes on free
      hugetlbfs: don't zero poisoned pages in a hole punch
      mm/hugetlb: only check PMD table sharing for PMD-sized folios
      mm/migrate: check hugetlb PMD sharing in move_pages()
      mm/hugetlb: don't share page tables of a VMA during mprotect()
      mm/hugetlb: count migration entries at fork and unmap
      mm/hugetlb: stop accounting HugetlbPages once PMD tables were shared
      fs/proc/task_mmu: don't clear VM_SOFTDIRTY on hugetlb VMAs
      mm/hugetlb: use the VMA lock to stabilize flags for PMD sharing
      RFC: mm/hugetlb_cgroup: charge faults to mm->owner

 Documentation/filesystems/proc.rst |   3 +-
 fs/hugetlbfs/inode.c               |  22 +++--
 fs/proc/task_mmu.c                 |   9 +-
 include/linux/hugetlb.h            |  22 ++++-
 include/linux/hugetlb_cgroup.h     |  30 +++++--
 include/linux/leafops.h            |  11 +++
 include/linux/mmap_lock.h          |   1 +
 mm/hugetlb.c                       | 174 ++++++++++++++++++++++++++-----------
 mm/hugetlb_cgroup.c                |  64 ++++++++------
 mm/memfd.c                         |   1 +
 mm/mempolicy.c                     |   2 +-
 mm/migrate.c                       |  23 +++--
 mm/mmap_lock.c                     |  78 +++++++++++------
 mm/rmap.c                          |   4 +-
 mm/vma.c                           |   2 +-
 tools/testing/vma/include/stubs.h  |   3 +-
 16 files changed, 314 insertions(+), 135 deletions(-)
---
base-commit: c8117bff684306f5c1f959d055cc2b24dd67b1eb
change-id: 20261120-hugetlb_fixes_2-26455c584f4e

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


