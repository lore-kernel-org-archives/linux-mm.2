Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B3F606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=PLJx5l0t
Received: by kanga.kvack.org (Postfix)
	id C7C4A6B00EF; Tue, 10 Nov 2026 17:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C9A6B05B0; Tue, 10 Nov 2026 17:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B434D6B05B1; Tue, 10 Nov 2026 17:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD696B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:53:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9056C0180
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:14 +0000 (UTC)
X-FDA: 85420711908.30.F4B93CE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C1CDB10000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:53:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PLJx5l0t;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794351193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vk+N/BR3oq3dOLJw2HOby4lRjZ68GbiZNocZF2b8xsM=;
	b=uOWjWOb1Gcyo+sVouoLFIPP3/7V9uzarrFX2Ynz/MOedRBn2/qKk7wMAx896gTCKRuz8Q3
	0l0anyPuTzH6w/OWfcuYjj31z2T/vDMh98PxoqVy6P/Du2LvBRrlo3WlijpQH+SKIj6EcG
	wQVhN5a36usoA2SrI1KfVWCHZAcTXU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794351193;
	b=sjw7eaADvLRW9cI7lJpNnpsh+oYryqrf7tyPG4NIs0g2trk1BRVwfEfdx3DH4eW+c+egNf
	W5//uVirdfVCVRP/0Py525vC75SSXeT71PK6B2f4ksDse1uogVguABGrjVtNgkX+T1AXK6
	kSQ11JlXFTZYhINKEFje3vrfJx4K3V4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PLJx5l0t;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D0A51477;
	Tue, 10 Nov 2026 14:53:08 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4406F3F85F;
	Tue, 10 Nov 2026 14:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794351191; bh=QOvNQt7N495bFF4N6iQj4KiaBeii7WdXwg+ytvNzrWw=;
	h=From:Subject:Date:To:Cc:From;
	b=PLJx5l0tOqXX0R0L7sLJugk1Cw7QKcW5WN8nKQkRpIp332VdWteDv9BHVxJ9e7HDm
	 TJtio1zYRZUtbVw7xOhZnSqQ38AwDVy4fEDobpDbZKd8oWibr5W3WfctpbSgoFJad9
	 XNwEko7cmSOSeO4nYBZkT+57PJp1AhVftjuvdCks=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v4 0/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Date: Tue, 10 Nov 2026 22:52:50 +0000
Message-Id: <20261110-refactor_gup_fast-v4-0-e779a7674274@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEKg82oC/33PwU7DMAwG4FeZcibITua05cR7IDS5qbPlsHVqR
 gWa+u64Q2IgWo5O/P3WfzVFhizFPG2uZpAxl9yfdNg+bEw88GkvNnc6GwcuICDZQRLHSz/s9m/
 nXeJysS2R+ESN76Iz6s66kt9vmS+vOh9y0f2P24kR59f/0ka0YL2gJKIq1CE983B8jP1xjv5yD
 tZcTE3lsOEu+LjgcM0BELPXGoT01/nVewGqtgJPtYZ/u7nz6O499W/JO/VtRI6Adaz99rf3P32
 z5L16xywJXJdA8O6nafoEqEgWxNgBAAA=
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4597; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=QOvNQt7N495bFF4N6iQj4KiaBeii7WdXwg+ytvNzrWw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq86BR1knAjC59wruT++kV/bxr6upRF/f2+ltxo
 RrraiQUjkWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavOgUQAKCRBt1cPRWsUx
 M5x0DAC/qwxIFe5vjUZkBHSXyu0tm2VuSW1bcyDPWN3fAFQmAYSz7Zl95yoXv53Wpuvf+/TcPH2
 VRF/P2yqrfp3Cu5PoqI8fBD3tx5fhOURvp0c+fzVo5NW58v31+iLxpscD8lbAwu23QABBrFKzIV
 EonpsO6m8rLfj+DjmfcjdVh0zRqgcAZ69GzbscuAoKtHo5A7fZPilIiteAY16WmGBxjCJ4oZY7t
 Br0I3vE/WprrRsxCi4Fby2i5hJN214MpAc/zKxNqrywdRSN6okV7eyTC9+1ID3XrFnt1+jYN92q
 XzwpQMrPNtjHHKrHHpAXTjq8FJB8RVXL0Hh27D+evRa3o0gbB3XyIqhf3bt9K9ri/I+QgkfCZ4k
 5ZG9DbessJ5uqwuh4R6m5xTGe4AAWPsH309H6DxkoXQ+we432Iz46CD9qOF7ZPCOgmSFbU9Zpgf
 xfs7wPQd4EWbYskMa9Z5KOeVS8opojMr23HYasBD8MwtULT9MCY4KQ+BXk6onWwh+LAzE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: m9icedafxh5si5ffopsd9gaiprufyart
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1CDB10000C
X-HE-Tag: 1794351192-280600
X-HE-Meta: U2FsdGVkX191p6rWpvQc5fKqmQp/lUaYwDih0CohKgjElAtGQGanwoRubN3eItjNL3jpfV/HT5R0gGLfdD7rdE5AqeLUv/hxNeFcBSyQcGTD0+G/0WpYNJPeCIeiSxTKWIWy13+3GpJjucgzeBTOBpz0D9rEOn/DYsqcwl/30M7AGQ5Nn5eFC9JU775V/MUWHOaYA6/m22Yery6yJwP2Ae1mZLl8ysc0zgrnIVlKmY4MTLbdLm3uJim3v1qqPGmAMpbv8F6Go+lI1WqdqZifVWYItHpKfhwlkdvqnWBezniwEm4PquKYou4dlBFzubQGq2vWzXJFNy65F54imkN++2aCztRNNt4V8gq9yImrXKwkXOYhaHTz5XmnpEjpeEh6gMEw5AGxbiF7cpO1+jzNGyHE5LLJ4l/mnw5OuDPdGWQe/POuxREG1k/FOnFGRAZtG4ULA1f8rUwrUJlz00u6DEoEKXEKxUpdk17Q2l7vOcSy396Ty0iukRNC6u7EWWh+XpER8bv+iarvjpX6OyuTCI8MrneOiwBtytd9XlWjx7REb2/WEY1Vg0y7CPlTmIlTmIvF6/zjF7ROaA3HqgRwieefzG/J2E7DORpuzvWaAhxcxmEX1PoDusgeXmVAoLPN3OgvPOX69ZY1ff3URENANl4xKsX/7YxmU6qenGQOIQpAQfCVymIH9eg50kLGztmadWyVrS2ixmiIQsZfoCvk9wKvOVl6ZZOttDtWMAC/wNVgca1T/ul5cfCh/ZDiEH7aDVXXyBQWv5bSJgll7UnGsqHWm1vKHp/sgSE3In3blbKUdmneluxOReFI8kD8IaTEoTK9rs0knZVVNQu0smKY6wQiZD9JQ+CzFybe/bPqsOmxEXKw1fpamsbYWCQbBBA7Gm2yoyoYUA7m9G31GzmbB8m7M3emqtvzQwJrA1VNe3C/aOmtv2GckVetMBq2LLT9/Vzff/Ydrv5/IycX4sH
 ZCg0zGrV
 eXxsAk0kB66AlJ/v5sA08O/PHmaqDqIeNkYS0SmFO6kSlDFDEa2zO+v/C85OYaVoMHxXPiW3Vn+/a7eDEv/6hH6duufhqbikSPO/7MSxjbPWgsESnJvHdvk9iaFT7T6izLayCb9cg4ovzzXh2aEhQijScyW5+I9juEsP41qmu4okN6+Qj6tXjpMxBDvma4Qaz4Nlv5szJ0f0Br2pNX9mJchdO0A0IiTFa6j/PNR90j3JWqMtuAWd9vrJTPsIdP6x6Tidg0mBg1bTFcUgcqG7S6Yq+TUbn+x4qwKf5isH4plCCx1Ilbsw1UHwCMpdbDvfEwcEUyxv9kS2aZ2ULsaBIZBpZyCjLxqG9VBF2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
atomic, a full barrier and a node stat update for FOLL_PIN), a
gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
pays sixteen of each and a PTE-mapped 2 MB THP pays 512.

The users are the hot ones: iov_iter_extract_user_pages() pins every
O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
buffers through it, and so does RDMA memory registration.
With mTHP those buffers are PTE-mapped large folios.

After the head page has been grabbed and verified, extend the run to the
following PTEs that map the next pages of the same folio with the
same protection bits, take the remaining references for the
run with try_grab_folio(), and fill pages[] from the run.
The PTEs of the run are read while the reference on the folio is held,
so the folio can neither be collapsed, freed nor split underneath the scan.

A read-only run of an anonymous folio stops at the first page that
gup_must_unshare() rejects, so the per-page exclusivity guarantee for FOLL_PIN
is kept.

folio_pte_batch_flags() does the scan.  It reads the entries with
ptep_get(), which is not safe without the page table lock on
CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
site, so the other callers do not change.

The order-0 path keeps its instruction sequence.  The folio flags are
tested before folio_set_referenced() on purpose: a load of the flags
right after that locked instruction cost about 25% on order-0 pages in
the gup_test benchmark below, and reading them first brings that path
back to the baseline.

gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
per call, median of 15 runs, two baseline boots / one patched boot, on
an x86-64 VM:

                       get_user_pages_fast()   pin_user_pages_fast()
                       before       after      before       after
  4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
  64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
  1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
  2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
  2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us

fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
buffer in 64 kB mTHP, median of 15 five-second runs:

  bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
  bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
  bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s

IORING_REGISTER_BUFFERS of 1 GB, median of 15:

64 kB mTHP           6179/5998 us  ->  1599 us
  1 MB mTHP            5790/5801 us  ->   893 us
  4 kB pages           7173/6741 us  ->  6763 us

---
Changes in v4:
- add r-b / a-b tags.
- rename gup_unshared_page() to gup_pages_not_requiring_unshare()
- Link to v3: https://lore.kernel.org/r/20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com

Changes in v3:
- move gup_must_unshare() and INTERNAL_GUP_FLAGS from internal.h to gup.c
- drop the folio_pte_batch_flags() patch for shadow-stack.
- ignore VM_HUGEPAGE for shadow-stack via madvise().
- add r-b / a-b tags.
- Link to v2: https://lore.kernel.org/r/20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com

Changes in v2:
- fix exceptional case for shstk on x86.
- remove redendant check for pmd change in each pte barch.
- Link to v1: https://lore.kernel.org/all/20260917083747.786-1-aa9736195201@gmail.com/

---
Yeoreum Yun (5):
      mm: khugepaged: ignore MADV_HUGEPAGE for shadow stacks
      mm: gup: clarify a reason to check pte/pmd in gup_fast_pte_range()
      mm: gup: move gup_must_unshare() and INTERNAL_GUP_FLAGS to gup.c
      mm: gup: introduce gup_pages_not_requiring_unshare()
      mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()

Yuan-Hao Hsu (1):
      mm: internal: introduce FPB_LOCKLESS for folio_pte_batch_flags()

 mm/gup.c        | 185 +++++++++++++++++++++++++++++++++++++++++++++-----------
 mm/internal.h   |  78 +++---------------------
 mm/khugepaged.c |   3 +
 3 files changed, 159 insertions(+), 107 deletions(-)
---
base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
change-id: 20261015-refactor_gup_fast-b55e3f593dc2

Best regards,
-- 
Sincerely,
Yeoreum Yun


