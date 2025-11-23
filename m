Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A64FCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 10:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3050E6B0006; Sun, 23 Nov 2025 05:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E7B6B000C; Sun, 23 Nov 2025 05:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D1F6B00A4; Sun, 23 Nov 2025 05:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1C396B0006
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:27:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54702C0B90
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:19 +0000 (UTC)
X-FDA: 84141494598.03.ABB1560
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A502B14000E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:27:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miOLm7bo;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763893637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LjtyzGjmWcC5lVhfhDocKKlgPGW9LIlInxxfTZEqHBw=;
	b=q4RcZ5pMOZoG9e2O9wt/P9IwASL9/qUsPaglrFcsRinluP2fBPPLgjdzUUtO+EQwQXKR9C
	cgMCow9BKGoKKRI3kFQmI/NVdQid9RyV0aJLncbNlB42IRvNHhao601io3reKDmYPEQfSy
	Lq+5HDb8hsdQ4sVwt22F3vY+GpyTwtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763893637; a=rsa-sha256;
	cv=none;
	b=q2nvE8ICKbA7XEi7k6HtiknV4Qkx9TqJptcqWz8Tvlg2YIiXPu5i0kCCNbrRUfkPYQfUTZ
	PuAw1Yx+9t6gKaOubWOF3XZUEa/5+8VkjoeDtbde81iLHbraII8eOOzmG6EYAYkG2lnr/b
	Pa84pAW2s5ZAz3tAbWZw6ykR1htuS5w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=miOLm7bo;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E21F4383B;
	Sun, 23 Nov 2025 10:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254B9C113D0;
	Sun, 23 Nov 2025 10:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763893636;
	bh=uQ+XNRc47lHfiREiaIwuPCqXlDMz96Y+Ua7eszfUoWw=;
	h=From:To:Cc:Subject:Date:From;
	b=miOLm7boejNLZkZWl7MecUiBUNqyViv6anj+8bxooagNb3kdikR5sNpE/yUgJ2OeH
	 LOxKOzOxo+XdaqrY81kTYt5phmRtUbIqvbTj8/ytq4XGAu/bwVOtY6iqyr34WINb42
	 rTtculAEvWMXO36PnaApcYiJF4kYrM+LiBbq/y/YHeh5RZ4wvWG4JhZmSPVvZTC/y3
	 JPtMO7WwXssH5azIRYZ+l7z7Nopi7xlVVWLRWXfA9gZU0zAAqq6BbEecaBNL0kJZK4
	 rjSc5qQhpyQkvTVGUuxCC8aRYwVcSOVyei0hy7xwXcU2ht25mTlFMsVaZ0tkQPhMIW
	 r8fJUHurTqBLg==
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
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/5] mm, kvm: add guest_memfd support for uffd minor faults
Date: Sun, 23 Nov 2025 12:27:02 +0200
Message-ID: <20251123102707.559422-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A502B14000E
X-Stat-Signature: ydqnwqn78ydorcwowh66omkyoa9ttajf
X-Rspam-User: 
X-HE-Tag: 1763893637-967540
X-HE-Meta: U2FsdGVkX1+5taO0s6tV35B2CJ+kgxGwX91EyGtMpvPeG50NxOOlryXpArQhkzW6kJGmHuo+OYHXEaGM1PskVxPYD0EbSrpnIfXICUPArXO19LM2eOf3toeLVPb6SKgKKOcsG/lNxJCRowqbJS4PHp+FkwyQA8CQ9VL82uPpuazDk9aTG/JJJuPICgDngGPdBKQPQVhRWk7H+P/+mGhV/Uk1p4GXXec3gL+JRgoy40QNgVM2MpSbt+5nPnPpUa7a3eRenZ/JCMcu9zyaKI4PF1Xf1sOs7nE5pzKa657rGSNBSUBPhCTmx30fbvU7XU+/AJRXXAhflictj2N/9pI5NAATX5tKkh9rZfCOfAMb+wyHaUtprR3NocZKbafUIS73AJLcotgCUEcdgSNARyv9uKU1RhpVTdYRJgShwLNl+G1yO3NruY4UNRv+VJ9QGsbuf6vLtMghIEsDf5YR2awkd4/ombaFHNMZ1qgxwsbaiKiGzpGqfQXmbK219B2B0zhouFqpbo1cPTnyaQvzYIhe0fiMNjgqZ5DqbKzvf3dhQ9UssXrSwR4kc75KWeGYGBOm4yKyClRlVryF9Nr8rCfFbPNTyRa/Az+Khv1C5JADV7+umgeChlV8AnPlngwU+HN3ATtWbS2KHyIxuDRwpeEEzNQMH7dMsogjj8Tgf29AfNklNEU+Fj17xlzoidL3mvCnxeyp4454UnGZ9lKrA52itlc7Ps7e0/We0TJz6h+vz1KZV8NAuI55NNhSzH5wkQvy7b2nC/We19BnPzxzqNyz/jmgPWYdqtFM3wnvkZv+yjVsKaf+ek51L5CvH5GVM2BaWdPFnKIKKo7O6K1Qpz1TZuvpXEpIJaJSuUTeRd6c3w5hQSFnVi/s0Z/WBzxhvLp5TYBQ7KqwBofjoUnfkLHxMPc0pjRaSnu3CSegQuxWfYRQRe1lLBe3csGu5i6PcmuZiuMN6skEVwI/ZPLUK8w
 XkhlUqDA
 Ytn1FxFjkTmApeYAC5H2vlEXlZqwEzDCss4AV3yugAXUIC9FZ4m/4HHY5hkp4zBxC1y/CgKG6AHEOeAvjMonYV/JRgdUgeR7RMzxr0n9Rzl0LqoqVT7FBBuBtC1wTkKu5IyDAos9gcNkCqapZ3HzKi5t0upQ+ReJXY1sZUFyRZKO7olIJS/PYS+OZ16t/jlKdybFkkgsTjyGlssQih4c1V/pTQIKzW6vVTGswGnTqVLToj6w0xUAG9SqxQb6Q/Cty9KKujS9xsJplKE2fnOe5Wxh3NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches allow guest_memfd to notify userspace about minor page
faults using userfaultfd and let userspace to resolve these page faults
using UFFDIO_CONTINUE.

To allow UFFDIO_CONTINUE outside of the core mm I added a get_shmem_folio()
callback to vm_ops that allows an address space backing a VMA to return a
folio that exists in it's page cache (patch 2)

In order for guest_memfd to notify userspace about page faults, there is a
new VM_FAULT_UFFD_MINOR that a ->fault() handler can return to inform the
page fault handler that it needs to call handle_userfault() to complete the
fault (patch 3).
 
Patch 4 plumbs these new goodies into guest_memfd.

This series is the minimal change I've been able to come up with to allow
integration of guest_memfd with uffd and while refactoring uffd and making
mfill_atomic() flow more linear would have been a nice improvement, it's
way out of the scope of enabling uffd with guest_memfd.

v2 changes:
* Introduce VM_FAULF_UFFD_MINOR to avoid exporting handle_userfault()
* Simplify vma_can_mfill_atomic()
* Rename get_pagecache_folio() to get_shared_folio() and use inode
instead of vma as its argument

v1: https://lore.kernel.org/all/20251117114631.2029447-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  userfaultfd: move vma_can_userfault out of line
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  mm: introduce VM_FAULT_UFFD_MINOR fault reason
  guest_memfd: add support for userfaultfd minor mode

Nikita Kalyazin (1):
  KVM: selftests: test userfaultfd minor for guest_memfd

 include/linux/mm.h                            |   9 ++
 include/linux/mm_types.h                      |   3 +
 include/linux/userfaultfd_k.h                 |  36 +-----
 mm/memory.c                                   |   2 +
 mm/shmem.c                                    |  21 +++-
 mm/userfaultfd.c                              |  80 +++++++++++---
 .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
 virt/kvm/guest_memfd.c                        |  29 +++++
 8 files changed, 232 insertions(+), 51 deletions(-)


base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
-- 
2.50.1


