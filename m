Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE1DD2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8C06B0005; Tue, 27 Jan 2026 14:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4767D6B0089; Tue, 27 Jan 2026 14:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382786B008A; Tue, 27 Jan 2026 14:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 232B26B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:29:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACE9C16028C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:29:50 +0000 (UTC)
X-FDA: 84378733740.20.D900AFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BAEC418000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:29:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SKv6WAS+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M8gSpq8kWEXUikKZM44JkwlAM1OPA/CSO8Mvg9xzXxM=;
	b=b95FLOFlvZrMK6iz1oMT1fZlFXrOKs8/hhek0XJFOLmFR0XjNmJGQizM70dLKzpr/0cZ+Z
	2i6V5ao0L3Kd2ujSDGLulbl8b2ErkW07TMabgQc3z0VzctZtLExDEtEDvfBs+7y5CjTu70
	zJzrudYbZ+n/QaY7S/6UliokI7aLXPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SKv6WAS+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542188; a=rsa-sha256;
	cv=none;
	b=yHW8yyrolyStbHb6j3uCMWMhurBIKXZvVnlr88i60NeNKI1Ri1zVhygQTN/RWRhX9RZXVt
	PA1ltJPKryyIuZ/dnddHId4+FYd0tC40Jch3ebHLZ/5YRMkrL1G2dUVL/N9oZ0tNhlkfp0
	ZAwU4kZkoBszY2Jv7fDvgXqsBdYwEo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EFB743C32;
	Tue, 27 Jan 2026 19:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDA1C116C6;
	Tue, 27 Jan 2026 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542187;
	bh=mpVeGCYsLiNY/UK6lKg9GGRaTRVOTOvc32/dwDOYLMA=;
	h=From:To:Cc:Subject:Date:From;
	b=SKv6WAS+1yy/6CAdsN6erxvRRsIsbUo+OGhqi4iWXCmDkaR33qEO5lAk4xu5teO2O
	 +J7lknBZban67bcny3JrQNfctgd7R3Lhl4ej+2uTLVXE1PDaxncoEM9TPfXZGXALSZ
	 FDNoZ2b18Z38m9F1hQGvR8xECcIlWnUqmMD1w0f1lK6vuP9rxfFuHYDPSIc8H5OwEs
	 9auA6iIlZNyevSsNBPW+B/2kSH+bmVO40izpG/ivDprGyAGssi1G8I2uFXnyRgSaXg
	 p7FE6FSu6eRBYHJNHa23BPrU5iySD+4/tktqLRfXkiBOyPwPi0OIbQmV4ggh/FhMKz
	 REg8RZsU6xmRg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 00/17] mm, kvm: allow uffd suppot in guest_memfd
Date: Tue, 27 Jan 2026 21:29:19 +0200
Message-ID: <20260127192936.1250096-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAEC418000B
X-Stat-Signature: p45m14aeeub7tnci5kwooqyqpcqhd1e8
X-Rspam-User: 
X-HE-Tag: 1769542188-886710
X-HE-Meta: U2FsdGVkX1+u8DUePLsf1wHKmKIyVXSpCp9J0f2A8q5paiDwnTznNXxbtex8BynM2o5up3829H3sE9PqEXi72DneNBFf35rL9/Hg0dME8/njxlryZFiZ23AuvCNFWu46IxMXrt9tzHOrz0LkM52bGKTJvgACT6LaerB9GL7OrPUqO82I7bZSLDqq6jHfoHI101GxUFMeYjbPS2KXlVI5bTlOy9yWPI5VJfEBdmizNzZdL5/ClqgVGbnQ2OX9TkrTO8x4iNuCjHEiadNy6IYD1ZH1ARRjVIA4LrgsG8b+LfI9ma2/yt+i9vC6PLo2ccoGXHFKEaD3FI6ih7/V8Eu+oRuD+HKyw5LHo8jDhHCTDSpAsnXWC3bB6D6VdDl0isa4Lq2Siat673BaawJ2LeE2LQCrD1tMF6AbyhB3A65D1Bwtg7hWM/GaPeac3MjtrVc38ZYut3JuVkzpMrdTBC+OuSJewRoYaL+21B+sABEpwHiu+rVYmD7w/dTlnXFf2XZNxEMrEd6Wz0YmCh4yWTtAM4HqT81m0uj3cyp8V/PLkfn4Q8bvmzAWnxX/6MOiBP/radqjqJVh7m7+lVpk+yulSzGGTJIUOp7TgTIx4uOENU2Eh1tylf1KgUZRkYkSyIRxXOEk1bLFrUmgMGqCAlXqjj6SP1KUT+RPhdpSuxjzyCJFxMdToW6dx+cldYGJLu3ZchFvrb3Ib5x0yl5ctOc7KI6nRoOUkXY/9nvlPSPtOLPGZoqnqTmReBNf233VSjdb2wuMLyr/h2nahlOa0vllY74KPNDzlsz9lShC3lfWkbhr9nsPPcUYctseXwR4ZvM9e2Tx+E0ugsvY92ds//jFHnJSGBnCVzzeE1oZ29SPnqBXPhYT+N6d3bGIOKcB0RfiOLUo0ZhdLmtP9id3XoaRoTULoqemzH8jYA7RSWA7iz1XOu8OMwMlx0kJeT4PulWRSU+zgmA3Kz2mHjjOrVL
 lQcpnXID
 ReU63Gz9ol+wYC9UNiXfx6VsP9BNRsQotcdZjLGTiYOl2gaP/zTvwhSlceMZm26XUvmlZeM7O8CxeUzutEf0S7aQoheA1YlY2DIkQ1YkRgNgCrOdueTx3g12M+OFf2vmEZQpFh/0iQaiu6m8WkHSWFWIsmgLHu88FYOFomR7d1GeIUdVc54qVunguLx3TwPVz6dcHeGNGpTGiqXLYiy5onrSNMRh6sz0Ogo0rzaP4Dr4Mmu81VBgIt5GAC9/bKrXMBqtcQ1fN09pZycNMZRxPSX3Ciw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches enable support for userfaultfd in guest_memfd.
They are quite different from the latest posting [1] so I'm restarting the
versioning. As there was a lot of tension around the topic, this is an RFC
to get some feedback and see how we can move forward.

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

I deliberately left hugetlb out, at least for the most part.
hugetlb handles acquisition of VMA and more importantly establishing of parent
page table entry differently than PTE-based memory types. This is a different
abstraction level than what vm_uffd_ops provides and people objected to
exposing such low level APIs as a part of VMA operations.

Also, to enable uffd in guest_memfd refactoring of hugetlb is not needed and I
prefer to delay it until the dust settles after the changes in this set.

[1] https://lore.kernel.org/all/20251130111812.699259-1-rppt@kernel.org

Mike Rapoport (Microsoft) (12):
  userfaultfd: introduce mfill_copy_folio_locked() helper
  userfaultfd: introduce struct mfill_state
  userfaultfd: introduce mfill_get_pmd() helper.
  userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
  userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()
  userfaultfd: move vma_can_userfault out of line
  userfaultfd: introduce vm_uffd_ops
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  userfaultfd: introduce vm_uffd_ops->alloc_folio()
  shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops
  userfaultfd: mfill_atomic() remove retry logic
  mm: introduce VM_FAULT_UFFD_MINOR fault reason

Nikita Kalyazin (5):
  mm: introduce VM_FAULT_UFFD_MISSING fault reason
  KVM: guest_memfd: implement userfaultfd minor mode
  KVM: guest_memfd: implement userfaultfd missing mode
  KVM: selftests: test userfaultfd minor for guest_memfd
  KVM: selftests: test userfaultfd missing for guest_memfd

 include/linux/mm.h                            |   5 +
 include/linux/mm_types.h                      |  15 +-
 include/linux/shmem_fs.h                      |  14 -
 include/linux/userfaultfd_k.h                 |  74 +-
 mm/hugetlb.c                                  |  21 +
 mm/memory.c                                   |   8 +-
 mm/shmem.c                                    | 188 +++--
 mm/userfaultfd.c                              | 671 ++++++++++--------
 .../testing/selftests/kvm/guest_memfd_test.c  | 191 +++++
 virt/kvm/guest_memfd.c                        | 134 +++-
 10 files changed, 871 insertions(+), 450 deletions(-)


base-commit: f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
--
2.51.0

