Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D76FFCB624
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFE96B00A6; Fri,  6 Mar 2026 12:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADF86B00A7; Fri,  6 Mar 2026 12:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FDA6B00A8; Fri,  6 Mar 2026 12:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 964F86B00A6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30DD916064F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:29 +0000 (UTC)
X-FDA: 84516297138.12.0A6050A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F36340013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyJNlXWY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5Vti6GP4y7G/1Zs4JyY3+86MGioRiEb2MHkTYb/M9+c=;
	b=MBhjtPZmW8uaLFAeOjE8PO11erdrw9O8Z/JOs8EuQILT5XvHAZU/K1Z4Ni1pJ4h4VXE3fb
	IQ4A8PFdYYH3tXqnX9gHGwyFlhahJF0Imay/t+i65zkYfzYRazww3s9Fg+YACACbJABHgh
	yMg3oMCqBH5utnSf8W69SRRZP7mhKAk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyJNlXWY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817507; a=rsa-sha256;
	cv=none;
	b=mcQeP6NqQ9pFWsIOGAOYjeZzqHxmTAtsIeArcqY7FhR9a54OCHJJCOtsL3QTT2FSMimlVI
	v5psTACPqAH0GcWSqSukNkSoSbBLkZeIXs5KJMi2czT+/t0jSeJmBIXHlkeh5Rf90ljslu
	cPJbePNROxeGbKZNHGb0uIVfDyqk/Zo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D28242AE7;
	Fri,  6 Mar 2026 17:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA46C4CEF7;
	Fri,  6 Mar 2026 17:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817506;
	bh=v65cD3N8Br5TyxfaG6Wxwe38me5rZ0c7uZMHqtZlcpM=;
	h=From:To:Cc:Subject:Date:From;
	b=iyJNlXWYG+bjR/gJhhrmzh9pBnw8sWL+QBOHdKQNMZ6rpLSb+yHZNoyQoTpLd08NP
	 T714R3BgPR+lSW+R2gPVak0oKSXdaXOf+qvoLvUza23w6LW0j8/TRZAQM+LgY0oBQI
	 Je+u50iWrjpTjKzBCHimbGNyMjofwuXW6pyc7U1w3tGzYba/F6eqwI6Q7r7F9sEEcR
	 AR8U9wY6/xdShFjpFRBmdO5lBXMkhnLYIqyTtzARg+GqetrSO0RDItdFOXx/rS8SGu
	 bxzY6rqPquiMavoVra2BfGwl9agSz1WpMuIr99Fz+d+HLby5uYJ80q59vUwA0FJCdK
	 lKa031garTQdA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 00/15]  mm, kvm: allow uffd support in guest_memfd
Date: Fri,  6 Mar 2026 19:18:00 +0200
Message-ID: <20260306171815.3160826-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F36340013
X-Stat-Signature: 8tapdre7umsjepeshfjmgr1bn55smkec
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772817507-21741
X-HE-Meta: U2FsdGVkX18tb8FNgj6UMbuR50X0Mez/5Hyfu3njubsbZvidyKN7LvOTMvfQ47Eyj1nLpcqiuveILefrR9i/dTE2yfu6TD6vmilGcFP7YBYnZqKmAmi3zU8TaszR2+S6gOP0CfepDanubUfxZxpBmo8MYlTRJuTf4fL5HjuPHSppFjIIs7AA3QtmGMDBg1ruYN6RA/q7GIWeXvn5H5ipcJ5ZBrV3n+tRQ1wGc9y1Bl51OZ2Wez3ZrPwxhv2lhUcIRMkuQn/9ixGSkLOA2lWt6kRix9rpQsZT8Z6JX111L008g1onQkULlcn76K+GAT/yKq2b/1xQWbp5PslTCQxdWQCPP8hsuzAedcREl+o7bIdz0AAJmsf70DPKUGtxni1Jb5DJV/9JipB9xLBvNm7YCERmSpndoDwKuszxt94cUIRf75DxRnn91Q2dmPZY8LL03hneedHZLoL3eNrt+axlnngVGRhqip02R4EFDq8n84HP2SfBERmVmcKRH0HK2NRtVDLoK2bAcsgXT0oFLWNtcJB6OP3Nc6NOvV3ecDD91M6V4q836+ExzG6YTviSQzfSofDhQLmFXmuTE34A7wtLm73IPUVMfk3VAz31BqXMYNqRLayLvwHmU6pUvdLUR5GIa+yfBTaGC7vi1yKD4dNy/cebTRE7i5YoKSRD9hL3G3c4RXxLYXvIjArMM42VgKy2AvPbMwzXAK3rpBzgIihzyJCPWZ+seNFdBrwC8rJH/wCwLpLMz2cimZh1zH9YMOtcheVb3wkudzedc3gOeE8kaH3w31LI6hhF380spYWnxChs6w6EwNMlKhCVk8a53Z6CzHYkKWvqMl8V396sdmXDHHMSAFJLRriUGIxGJpQ4Ne51u9KsK1p/uS2ZKoEhBr7byOgRXv4TJF4fqVx7DD1Vm5VphUR2oxDC89GBuXWJdYWpyS/q/VBvYQwG8d+xsFAryzYjEGQUxSEn9GhIKop
 6gg+rQGO
 O1E5/FZUTiLVF9UI=
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

v1 changes:
* instead of returning uffd-specific values from ->fault() handlers add
  __do_userfault() helper to resolve user faults in __do_fault()
* address comments from Peter
* rebased on v7.0-c1

RFC: https://lore.kernel.org/all/20260127192936.1250096-1-rppt@kernel.org

Mike Rapoport (Microsoft) (11):
  userfaultfd: introduce mfill_copy_folio_locked() helper
  userfaultfd: introduce struct mfill_state
  userfaultfd: introduce mfill_get_pmd() helper.
  userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
  userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
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
 mm/userfaultfd.c                              | 692 ++++++++++--------
 .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
 virt/kvm/guest_memfd.c                        |  84 ++-
 10 files changed, 858 insertions(+), 448 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
--
2.51.0

