Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CAFD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614426B00B1; Tue, 25 Nov 2025 13:38:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB986B00B3; Tue, 25 Nov 2025 13:38:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528486B00B4; Tue, 25 Nov 2025 13:38:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 406CF6B00B1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:38:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91AC28880E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:38:52 +0000 (UTC)
X-FDA: 84149990904.24.DF3833D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CFC5118000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:38:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFbfUd4W;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B/99vZF+GMdvy0ZqFYt81dpEeF+6FiIdzo5WIXI0QFk=;
	b=TLV6fwQiYcZXRZLd9hMjcJXeBYIun8TE5IwFQOHc/l4ZQmnU2rEloMzVdrDiomMSdyjDrY
	4CUcdVHX80Wma6OY4Ji/kqWAuq8jbRtKSTjZbD+A/mYUMD6Kxl3sJZhVn0icxSouUB/1N7
	KVOy/lOf7zRfl+5BZy/l42nh9NLwOUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095931; a=rsa-sha256;
	cv=none;
	b=T0t3ene2EEm496DNl79noLb3W0QqvC1icbtUDIxY6+GzYfz5nJHRrAQ3Adrr4jlYMgJmn1
	5oWbu9+xzUXlj7btFfej9wXKiR0QVn6FCUQP2X/unOAPwQtHf90Snjt6ldSs9bLKAGW/Ez
	8bm6w+f3CHcXowJ1fAQ4dg94Mowwsh8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFbfUd4W;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0EBD43DF0;
	Tue, 25 Nov 2025 18:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75691C4CEF1;
	Tue, 25 Nov 2025 18:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095929;
	bh=rWudt7B1tB5QYi97/yII2g+5R+2VjlqdXJtZwSgAGQc=;
	h=From:To:Cc:Subject:Date:From;
	b=eFbfUd4W8t5SYla89AonVE6qfu9YF5+7CRm35LEhJB4Ikan/rfMCWcR7mhNLJeBDN
	 0C/ul7ZztYy+gyI2m2WGHvgGtWSUlxyGEXnR11maVQjbyVWPK63NuqZ/qCel8GTR3L
	 lQsCIRYMVVDYF37ETz7+Znh4pQq/oNO4n8xcHeF4h17fvJk+DWbeO4x2cr/YeFzjIz
	 JJn/f+MbzgDHOPJ+4PLtMm/c0sCSfW8dCXiKT83+1T3jX7FF0RHN2aoOxz3/LSAmCY
	 eAd82I2/jODtfeYzxfIqf6qd8rINpJuRO9UZPXKjG7MQomeUyiZMZIWMxvNRp27/fX
	 nEIbnvbJ7TE6w==
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
Subject: [PATCH v2 0/5] mm, kvm: add guest_memfd support for uffd minor faults
Date: Tue, 25 Nov 2025 20:38:35 +0200
Message-ID: <20251125183840.2368510-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CFC5118000B
X-Stat-Signature: upr8r9hi533dk1cc5wwmkxta8yb3o39a
X-HE-Tag: 1764095930-286094
X-HE-Meta: U2FsdGVkX1+f5z//NUoMYSkoPZqkp6cTYNnKXX6GmubQ5cSq759Z4EG4S2caTnyn/AUYmm1qIFKLa2hO4BpsvVTkZ9tXItq93dBc6yL9IUBHqfFACMsaAg1XnHJj1MniaHxVGQtk8eDivtRpzKPzN5XqQJZsmdonW8r4affwW85VrHm2jCcvJ+blwHGVAr4zAV4ltRpzMLiLJqRQUirDUiJ22P+8VzSzUzwrAoK3+MAEm5skHD2I/QA0WvDDiksjL9eBVoVOK/FOCww7MZwrpzdpLvW90e+ymRNbPriZ9yXZeZPB1KRuw7QN+SWqQclpVtmF6mRGWORIqdzKNNAMgUtqiRKck0qIwYxm+o19wwi7DDrYde/zAnkWAhEDfeSgQ7kent4GoZxyZN5Ns4UzVpFnL7eN5wsQSjBAZdFThjGlPOQN3Sb58k2MkIA2srtND+FNy21D4t6QRN0xYqXodq/x2dEuDHic81xdPesNa5LAuWAXotT18voe891x/KZeQrjSCnWcbYlYRSAwoiHEDtesK+t4EJTztWoqtSJZb4V+Z9LJ8/QSLoMhuF+NDE3regTWU97i9pQtT06HQzZEL4PMqTSyH+KXRAjF5E+PprxXb0X3uTzBZHJ4oifXOkPMqLaNszedqAXym4x5Q38rx1fHBSP9yOHDTrt5It44P0LqSwc6mDBGBBcpHB6Yp3Q5flQI5u3Kc0tNn44A1ImdZ7m2okKyFLfI+yelIvWlbNZ3sG35Lxlu44ACTSqQEdF4IRR73QSYkMZu+gwmzMXb7eLZjJSlgc0+uB7A7FNJYUxOsg2xclcj84jqdYAPevG3a90q3/dxelBoXWCPLldTzTKzhCmM9Na+xQIOQDRDPgnTHWqr+QPm7ldqcFbTkUuzUzUy3ny9wObP6eRu/UK0cYnTmHUmtadAsU8x+DZnFtC/NlaUkwKUHOnLBNBnLR2YjmCt5VOKuyZeUnQhYjV
 TUI4wbBj
 uv69DtMLZ1b/Q1Y4v1NMglaQnAIAs4vdU0nqK1U9WIn+mIJQpgOgKjcuXOg7JNhKX969mDUPcNKn8Nn5vK02nYZTpyX3aXUb/dIbKoo7naVpBhhmijeSgvNxxY74Lgm8QCckVzMfGH4aJ55Kk9BO25MqLNzh1XHyYyrX0+DIp7a7iz8IoIn8LCONSXm4gecxcal51djOq5196vf385ITVa3THT6ZbkIOB5FPaihRdJWFk5Llt70iOrT3EZI9BcjDzE+tqhk/oPG10vWh2E/k7m3qigtVh9KlWDPLOcPuiQ/L7fa7uyAC/Li88ropijMXLSkDf0rfvM35W9crtzeKWN0FiDnJPUPACTexvuWUCa79ymz8=
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
* rename ->get_shared_folio() to ->get_folio()
* hardwire VM_FAULF_UFFD_MINOR to 0 when CONFIG_USERFAULTFD=n

v1: https://patch.msgid.link/20251123102707.559422-1-rppt@kernel.org
* Introduce VM_FAULF_UFFD_MINOR to avoid exporting handle_userfault()
* Simplify vma_can_mfill_atomic()
* Rename get_pagecache_folio() to get_shared_folio() and use inode
  instead of vma as its argument

rfc: https://patch.msgid.link/20251117114631.2029447-1-rppt@kernel.org

Mike Rapoport (Microsoft) (4):
  userfaultfd: move vma_can_userfault out of line
  userfaultfd, shmem: use a VMA callback to handle UFFDIO_CONTINUE
  mm: introduce VM_FAULT_UFFD_MINOR fault reason
  guest_memfd: add support for userfaultfd minor mode

Nikita Kalyazin (1):
  KVM: selftests: test userfaultfd minor for guest_memfd

 include/linux/mm.h                            |   9 ++
 include/linux/mm_types.h                      |  10 +-
 include/linux/userfaultfd_k.h                 |  36 +-----
 mm/memory.c                                   |   2 +
 mm/shmem.c                                    |  20 +++-
 mm/userfaultfd.c                              |  80 +++++++++++---
 .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
 virt/kvm/guest_memfd.c                        |  28 +++++
 8 files changed, 236 insertions(+), 52 deletions(-)


base-commit: 6a23ae0a96a600d1d12557add110e0bb6e32730c
-- 
2.50.1


