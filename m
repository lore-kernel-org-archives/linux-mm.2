Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717FDFB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC23C6B0092; Mon, 30 Mar 2026 06:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BB96B0095; Mon, 30 Mar 2026 06:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A696B0096; Mon, 30 Mar 2026 06:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE1326B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:11:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 344041B8A8A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:29 +0000 (UTC)
X-FDA: 84602312298.01.AD23C04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0124160003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oz3RaLZ4;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oz3RaLZ4;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865487; a=rsa-sha256;
	cv=none;
	b=07KcwqefMplmWKAA9Dls98ekw/gns2LHX7x/xiolWDrHyDqmUQtX5H+41JlESDF2Tfi6cN
	fOtUy8uRtsAXZfkJ7nK31cCbl1rF5e4nEwOKjGFlloPZX3e+JXT1p1lAxoDTnreale8WfH
	uxzluYdLCoet25v/mZ48i4II8TL5Kwk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0T2cnc65nQE2tgFt6eRp1tbZ4DwxSTvivMSPY1771hM=;
	b=wvdudYiUQOGd/3s//6A3drkGjpFOjMuoynul6bkHpee0Aljnrzp31pZWs9azOQ9tw2drzh
	9oyQwAfKE+L8pKFeQRLeLO48gWFit3xy/3vH4zrhmwZndYVy0OTOMzfdqm1neOdpUW8MYh
	FVMshM0DyIA0kAKxGMNvbRDbQlnFydw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 320E960126;
	Mon, 30 Mar 2026 10:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05F4C2BCB1;
	Mon, 30 Mar 2026 10:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865486;
	bh=GgKA5DKfE0J6C86Pd58sBvtyWfrHRhL+cDnuFJprFXI=;
	h=From:To:Cc:Subject:Date:From;
	b=oz3RaLZ4XqTIWA/YrlmEslKtMgjjzZUSf4/xnt5q9aPl5HExKWwVBg3skiD1JgDEc
	 CF3Rpp229qlD1QYeyZo3hcEN6wHUVlMny1H+HiOqHCuZIj2lfzkQW4kCE8suuUFC9m
	 +1lDQDpxmPbKzCEZw8l1FsNCAYq+fKRbyjBxu/NMgDFBYTMWx38HfNXla2kPCp4KcC
	 5sz3bn1qyjvp6w+/V7eKKJ1KCz+rrUybjpPdUM2kzPIAWQ9rVfx1uoI84wjSJ0mxFm
	 5FKaKj7HppkUc0triJODgpx/rn6uKvJgtF6w9bU+g9qiD1BkO8LoPN8fZxV8Vjob02
	 SUlzlK9XoqDnA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 00/15] mm, kvm: allow uffd support in guest_memfd
Date: Mon, 30 Mar 2026 13:11:01 +0300
Message-ID: <20260330101116.1117699-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B0124160003
X-Stat-Signature: 5srzx79phjxt7zezcwpzre863db8udf5
X-Rspam-User: 
X-HE-Tag: 1774865487-181673
X-HE-Meta: U2FsdGVkX19SeqScTu+BAsQvL3gPJl5k1HPrZEnTRLOrKlQ/pA1KeGZiTQ0rKrDY5GPcy44xbvVC9wpv9D6iqGbbGKlVmjYYNslaZXqKeNDweBdNx+DkNB+3ewhc8cWMUKNhEDT0GUzVX7EJ3cmP+v9gkICt1N2WM0m4qMvMiJn7uvfqtdmTvkpKzaBrRKFz5uoA8qhW3IyATcP6B4MxALt+7kcYmsaSm1aa0oR7EK74qp9vhH7IPwLvM5I++cNIgO/Mevwfq2Nn5udCh6K/jXRRP6TKz+J6vNXFdtGfUmoJ2M/NBdE/Fc1DbdbbSLVyZheP4RRdlrml+0TYg18xCWsGwA3Vij64Y6NSg+tOcRshi2JUsvb+ko4mw2N5uSeOQy/U9ffo2ioYDhd82eTrt5vsCUUTM/6BySXK661jIawDD+umGAYgq+o7gbGCVKFHlv95Vx2mQrQXtGXvdbqiJnxZ28OWakHGS4ajbVp35QhbCuvRKVFEBHiiIeeUq+xbUDuMVU5mji2qlEpI+vQcXdTmnkCXLH4AUOXM7+5ZQ5+IsoUcQHMQCACWVzlyk13xIfgCu8yp4ONUav2dQB3WZyTqTEJedrGa5pliyguWvYMU/jNP9C8/3MbikVXIyW8yqDiWkUCwpbzg/sxHM/35Cc/Id6HTdYGiwsLEHqGsCSY8va+1JYoxd6lpTJcPFf1lIR+IZaofdXRlAyrJdH1cvHvMu36BDq0/hLCoK22zAnAs+K6kBHyV5Jy1YuqjRnBe/y5mW5XS2bKW6A1nPjI+DLy3e26oZ4MUQE8mIqHW+yFY0POuY6o8AC90DjHBGMNHohHhrs60CGo8t/BUbHqnCILP7/Y8RsCwTXPDb9dNIgdI7PWDaSTyYbs63atJLIeP0aA5rFZdLtDjX8pNmaLOdzOXP2zuQt1wVCnzw1AIzjI4/Ar3H4ZxZuCYq/GilYHOS0m3eQhj/+vsUAcOLyz
 r9SD0QUq
 28aItm++sy3woKfFMoEXVQFQeWyxSuUgVxMZ74znP4/EeQAKb4EbZ7MVuErujFbMhtbYq6qiX+vf0C6phdaqPy9CFewV5S+tKrRdSN9OreNwdZiL52jvGwo8ES2JGVdMREpgPTtR1BL3eGUagL666AIcH41v1UZZtpWCCYb7pUFCACKpTiB1P3+h7mtgoIJd8kp5y4+nHpjFKng4CqXbaTU0pO12TXI/swMzMZAf7XlByucJn223ZceerBSx0Y0Lx4LlGSyK4TIx5fzzIN+kIpVPuTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches enable support for userfaultfd in guest_memfd.

As the ground work I refactored userfaultfd handling of PTE-based memory types
(anonymous and shmem) and converted them to use vm_uffd_ops for allocating a
folio or getting an existing folio from the page cache. shmem also implements
callbacks that add a folio to the page cache after the data passed in
UFFDIO_COPY was copied and remove the folio from the page cache if page table
update fails.

In order for guest_memfd to notify userspace about page faults, there are new
VM_FAULT_UFFD_MINOR and VM_FAULT_UFFD_MISSING that a ->fault() handler can
return to inform the page fault handler that it needs to call
handle_userfault() to complete the fault.

Nikita helped to plumb these new goodies into guest_memfd and provided basic
tests to verify that guest_memfd works with userfaultfd.
The handling of UFFDIO_MISSING in guest_memfd requires ability to remove a
folio from page cache, the best way I could find was exporting
filemap_remove_folio() to KVM.

I deliberately left hugetlb out, at least for the most part.
hugetlb handles acquisition of VMA and more importantly establishing of parent
page table entry differently than PTE-based memory types. This is a different
abstraction level than what vm_uffd_ops provides and people objected to
exposing such low level APIs as a part of VMA operations.

Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
prefer to delay it until the dust settles after the changes in this set.

v3 changes:
* add fixes from Harry and Andrei
* fix handling of WP-only mode for WP_ASYNC contexts in vma_can_userfault()
* address David's comments about mfill_get_pmd() and rename it to
  mfill_establish_pmd()
* add VM_WARN()s for unsupported operations (James)
* update comments using James' suggestions

v2: https://lore.kernel.org/all/20260306171815.3160826-1-rppt@kernel.org
* instead of returning uffd-specific values from ->fault() handlers add
  __do_userfault() helper to resolve user faults in __do_fault()
* address comments from Peter
* rebased on v7.0-c1

RFC: https://lore.kernel.org/all/20260127192936.1250096-1-rppt@kernel.org

Mike Rapoport (Microsoft) (11):
  userfaultfd: introduce mfill_copy_folio_locked() helper
  userfaultfd: introduce struct mfill_state
  userfaultfd: introduce mfill_establish_pmd() helper
  userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
  userfaultfd: retry copying with locks dropped in
    mfill_atomic_pte_copy()
  userfaultfd: move vma_can_userfault out of line
  userfaultfd: introduce vm_uffd_ops
  shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE
  userfaultfd: introduce vm_uffd_ops->alloc_folio()
  shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
  userfaultfd: mfill_atomic(): remove retry logic

Nikita Kalyazin (3):
  KVM: guest_memfd: implement userfaultfd operations
  KVM: selftests: test userfaultfd minor for guest_memfd
  KVM: selftests: test userfaultfd missing for guest_memfd

Peter Xu (1):
  mm: generalize handling of userfaults in __do_fault()

 include/linux/mm.h                            |   5 +
 include/linux/shmem_fs.h                      |  14 -
 include/linux/userfaultfd_k.h                 |  73 +-
 mm/filemap.c                                  |   1 +
 mm/hugetlb.c                                  |  15 +
 mm/memory.c                                   |  43 ++
 mm/shmem.c                                    | 188 ++---
 mm/userfaultfd.c                              | 694 ++++++++++--------
 .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
 virt/kvm/guest_memfd.c                        |  84 ++-
 10 files changed, 860 insertions(+), 448 deletions(-)


base-commit: c369299895a591d96745d6492d4888259b004a9e
--
2.53.0

