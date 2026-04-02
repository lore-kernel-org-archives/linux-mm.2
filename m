Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C03B0CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5976B0088; Thu,  2 Apr 2026 00:12:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCFE6B0089; Thu,  2 Apr 2026 00:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B146B008A; Thu,  2 Apr 2026 00:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132206B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C69FFC1A2E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:08 +0000 (UTC)
X-FDA: 84612293136.18.C6F5113
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49BB2160007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKKUf4pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103127; a=rsa-sha256;
	cv=none;
	b=zIQMs12zdin1buLOijEbYt+2nK8PrLi+iySa0wGrQAm/cU4blGggBR2a8oXwyVHRb2nHRM
	XLiSQTV08cVIihLyVXm4axiAeQiQC/1k/fgUuQrzrPPuCxaCgNAVktGGIqpZfzVNb8jq8/
	UUvcONyWQPsLlWtszTvr+j2MI/7cG48=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKKUf4pb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZUjOEYGOyw5rN5aeGue+UwUoCyCMHaOj5VyNrKWZCx8=;
	b=LOaL6UMTQcFIcgh708gp5AZvjG9Dn4W0zKtH7mV0NFnUtIPoKJDGx2/4vEB1eWaRd9dncp
	AO4TU1skCS0lILylrHpmt4WX3B888bUnZiqBEz9DG/tWyI9UnNzSC44LoRQG0vcUCVJt0q
	EOkiURVSgcr/9dr0Wra+HWd3QzhBlUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DF346185D;
	Thu,  2 Apr 2026 04:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092F6C19423;
	Thu,  2 Apr 2026 04:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103126;
	bh=YdxT9Os1hSGPmZw1lQ6CLN+t2WtiDCHbfZPu8SvWeQE=;
	h=From:To:Cc:Subject:Date:From;
	b=pKKUf4pbTEdGa00km9nLhdXKDDyJ1GVwXsRXfO8pRSh8eybncdhP7eo0EZ/127FMi
	 cy5KaxCS6/LgeFl9S4PzmWt9v5lLwwZA04l+DCqOSrUjn4IzVt6Y8h3fd9aB653PRn
	 dxbrdEgvgfXRoK7quOVCuCTXSlC1N0eYzfSDGRJZ2LL4xuswYT+2mJylXarNQSUthO
	 ODpK6qi84Au/3YWwX6Obs6dnjC0v1fGTECSqcljzY4IwZWRyAHSoCt2iAxoZ4Ys2Ig
	 /2pNBiAC4x+a+K/zpycRgg8P2tSKQ2TIkX60sAlg/yA5xUjV50/Y4M6Tnk0tt6uB0q
	 8838NCi68y7lg==
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
Subject: [PATCH v4 00/15] mm, kvm: allow uffd support in guest_memfd
Date: Thu,  2 Apr 2026 07:11:41 +0300
Message-ID: <20260402041156.1377214-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bsmjdhwcr1t7acdijkmxm1rgnox9wijd
X-Rspamd-Queue-Id: 49BB2160007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775103127-730028
X-HE-Meta: U2FsdGVkX19IqXXcdjwreCnsHEZDa6vkMSiSFMC/JOT3Qm8sKc9wSbtH7UcaZWMt/WA5P0pBLebz41JScFuDz8LhlPN8Tp8DqzvMsCFt0cxxLE13IZLQA+PXrH0fb0UlKLAKr2q1mI9q+donLQzgpaKhISjrgb//m5/5gp4BG65YrH3WLnpK0qcYixB+brEo6cR+g8itbCAlmA98iPy7L8HMNN38yo9Ff4U8Jnt7WuXTTvKLLHQU9qhvMJteSH0N9c3n281KrJ0jaQkpaTFivi3JVh5CDMI/HtGsPl2OAMqBkahXDgG+p+BGQHwJmk3Q++3uTFss7ehAIuCobntF/QOSDq3BNPqRdgxnoCy8BdsAEoJ36YZUXW3dLldDu3tqYlZLgs6P32UcyoP32ViytxLlM+dytBIf4Lf3XXHvkSGQqgrK3pH8axy4td8oi0uzIBsUht1oHgGH5sDQ56AcZL/pKO2JMdiq3LbLiA6bYd5mUl0oy8yp/Ld7KzSSp9UYZyzhuTu2+Dl59SsUD+DIjPQdof1uvurf3heNunbwrIc0Bficu3+LtYbplh33kvBVBWybxw1xWhK/bj1Lx+MBWz7BVAYnehFpvtH8GIB9e8aK3mhQuHPQVJqfzKadPOtdKwIKOH0zL+HB4fteh2e1IcWWZo15epJ1smg8EcOgdTwZiG6IrovTtIoJalRhDvdJPDPoH64JauLWtLWQFVI5YvwCwy6GOPlSqs+KYHVkjLPnenlvdXYq5ab/IPwUgkdrK83zR5Z1YbJGGaL83/AIOcmEYIOhIOPQNduH19/1nLXMNQ0O/vU0X/2Vc0314uzclZarTzjPZIeVtFOYeC5MEC+27fIPXv0u4kbDPSfMv2A/mlULAYcZAYD/jsLDHNqmSMmRhXu2UWGjXlnwZtc10binXpdG8g38x0kwK/tVsisr+YPbXM+ML62wKDvej6whcoz8jrAUczQJCH8m/Z3
 JkmsXizb
 0W1zORzuuPxH/MrDU7Vn5ySu9/Jxai07ejpSjEgBwZhaXYJ59Bq3ktYwvyO1UR9Ps2rH2Ki6N4eis0I6PE1np9S0iOwHuQBF64C7p9p2zURksl5Nn8bkKXlpJRqQ9Ee2Q8xgK6ibdIpFa2oxX1cz78wqdWsd+oDstRJo4FKiwPqqJzZ4JlDPfpprw7gySLmQHZDUpec1rknBijhKR1zzHv8Pfq77CP/AznE/duYkaZPOuhjcPZRzM1ro8JI1dYWHqZ3CQJR/rc1gzd/Ol/6vbPcQ2rA==
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

v4 changes:
* fix lock leak not only in patch 4, but also in patch 2, thanks Harry

v3: https://lore.kernel.org/all/20260330101116.1117699-1-rppt@kernel.org
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

