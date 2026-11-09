Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A03C3606D813
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jVUw9NIZ
Received: by kanga.kvack.org (Postfix)
	id CB01C6B05CD; Mon,  9 Nov 2026 07:32:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60746B05CE; Mon,  9 Nov 2026 07:32:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77306B05CF; Mon,  9 Nov 2026 07:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90FF96B05CD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A4121C3FDF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:37 +0000 (UTC)
X-FDA: 85415519154.26.563076F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 106F580004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jVUw9NIZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=udxm0MTbbrdZXwgUGf8nDE4esUDzC+N90hU7KZ64eOw=;
	b=yKZzMSAeXVCIz8Ycj5PdQhYlPcNQ1WJu5+6SNVh9p8zxnlormQWz7br8Ijbl1FoxMGszd9
	EGLMoklfvHD/LB7CzVf+gx+z9RYrCKHPNPmfRieQ9tqIvWIIJnyCBnk8xWikSh0syEEKXs
	dGLWwKem4n6ShMjuiZA2NTYJEmlbbSM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jVUw9NIZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227555;
	b=kSn6iNU1jj268pAUbcnOlXmYBHR37TMSvldcOZZKO+A9tyurb6bu1UkyGjHFpB9IlcF/qz
	XMSn5H62fgjTa9DuYQ2pIwmSU9OqtIQh2gogvqO69+LW5hQ7Qf4TGvitWrjgx+Y09Tsz1L
	iaWvre6iHddcetd0u2mr/2y9OFYLTlI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6E7F1516;
	Mon,  9 Nov 2026 04:32:30 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D685A3F632;
	Mon,  9 Nov 2026 04:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227553; bh=QEIH/LF9UuKjHrGluytD0ntXd7KX++xnyDqOTz3eQxg=;
	h=From:Subject:Date:To:Cc:From;
	b=jVUw9NIZJQgWxyUNHKdc5Exo6aZc4V67EokCep5T4IuCtIkIYUkyvE6/dwyws9SRF
	 F4Q+MlU9oCT1yg6ZcQGut0uAj7EhqwWgdpFhM6VtJlZ3BIij13jiAL63Wbv4OXw2rw
	 BPaAPIpdz+wt4M2bhue6a4U2/Fwh4lMLlKexi9OQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v3 0/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Date: Mon, 09 Nov 2026 12:32:24 +0000
Message-Id: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFi98WoC/33PwU7DMAwG4FeZcibIjnHa7sR7IDSlbrLlsHVKR
 gWa+u64Q2IHVo5O/P3WfzU1lhyr2W6upsQp1zyedKCnjZFDOO2jzYPOxoHzCMi2xBTkMpbd/uO
 8S6FebM8cKXFHgzij7qwr+fOW+fau8yFX3f+6nZhwef0vbUILliLGxNz41qfXUI7PMh6X6B/nY
 M1J6hqHXRg8yQOHaw6AQyCtwch/Ha3e89D0DRC3Gv7rls6Tu/fUv0feqe8FgwC20tLL3c/z/A3
 MG92wmAEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4382; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=QEIH/LF9UuKjHrGluytD0ntXd7KX++xnyDqOTz3eQxg=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1cwMlPTqUm+x5Hxjglzdl5JcKEFbgfCrTWS
 TJh461BZ/GJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XAAKCRBt1cPRWsUx
 M9Y3C/4/1RLK0kmQkgFGc/uX6lWK1ZEh6vA4r9A2qySbAcekJskXN3a0cqbYnYyZK6R/OWWD6uu
 56YEDOfgDN0kDoeNB2wrJjqUTis7CG1JdPT7Ab1Eeen4/M0XDlTHB8hmume5z+p/NWKWFEoCBMp
 0BaN0G45miLkLN58dHZk8xzeye/VLwmm7+KAkLfx3HvNDk/kQqoYrkSugMwQdvT0sFLf0mh5yFQ
 66Z5j5c5gZKnE3vSawjpSWJtkmsofclWDmfCn2gg7y0FnJLMMX8pESvnjpCJv9ZxevUVQVaUD+6
 uH6OoVZbyhZK7sHzA4HY8iM4iAnCttvb07jLW/XTlXIrz2OmemCuCkXOJlgspqrq7DPBgHGf9xd
 g3GAu5p0EAJjOU/LF19RLBIg5c+QlVNtky0OM8AKx7H9x7BCHb8Ppe5l5hViDX5UAxvc7dl0ybB
 yiF/kQbTOqnqo6gZ6zfwEwjdRteIBD1o71IFlwpedaWPrhU4S97zCqrxO/VI916q5CgCQ=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 106F580004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: s94dmbxe5ejgr3xr1cthzbsrcrayywsr
X-HE-Tag: 1794227554-476167
X-HE-Meta: U2FsdGVkX1+eHZmkY8tRafmEPpkTPp2yBo1JGQqgDtaOUtB0TvJjkmEzkBJOw26B2oobm7eZihjG2XTiT0ypnadqd6xGraP+SpdEJX+bYCIJxgbXHr12lxBXw/KoDJS2xjW6N9j7F55oYdLGAAGNwGUOjAApW2zwoaZKVJlEoOgXb75SHN+ye7rUkPeXfLsOTFM0FiImCHbD8VelWa5TB27Vs82OGtm2gqbmjGqo9Onq6Ll/eykv+tgaQ2rkQT3JLM3UaXlKKet2N7Bx1H7mr8ZKDVYKGkmB9/AG7c6MwnsPM87wGoare7mOk9un9YxatIW4nP0AdwYgiTYOkwLylQQ05b9VVr5N8WCUx1BniE5PDsPbDx18vKacGOoF64UVa2dxqZn6Xi33ldcgNnCVhkD+ZXLLaomri///Fw+AmggtihIaRhnHSLXioD0w2E3Zp/LguBpG+4QdK4VaftyE7+bPFXnKn17LIQQom2m3fQhQPB5XnxI90LcBzH+Zvu7ENrx6SiVVLddEtXAntTnL7gb5b4VsGqR/1+4y5tNdr+xolqS0tCH1zLTDvlLOmIGd/esX3V2da/rYgivhvOzWmtv6qsGfUop79VLVH+1ZM72+OQI55ZkX2BwLUejgxn6pshBORtv0MFVQ/HidArVim+Bu6QiJfv118cXWy2HvToYFMxPksS/NwHG8ACS7WAbnRfOxB2uS4OeIEzuyAeu/vhWb5FJJarkUwBW2ai+cfUq6cvo7A5hUWtNLitjB4+m35pHAAZsPJJBwv1ig/+xq3SWR6sPiokHuDk0YJgotBGamBzG7ykFMFGKEXHoVewXZDExnsQmkZhON8DD/FgjmznG7FJxTOJMsow04mOMmXdXs6VChHHa4FIms6JRmmxNNTsysc0VwAoFc3rVywt/E7EgaOLJj1OrpBPnbER9DIQko7439tbmzGGwIZd8Bh0rCVl/mpR0923N995KTbXy
 TTCpdNme
 6YIrX+bMOfcYoPh4ULPal8kvXep2HKgFvVqmQcB3DfTCW2L6JKqSQuSh7V7IOD3hixNvF7b3cFePaW7cPLxj+JN7WyE1N2anQyxOJdI4DwpSUFq7pSymiEEkLcRhkYNpnMez8GESkvuc/DLwyDhGk+2vb6DJk+6wJwE7rWDUIwngovetEHtOWvb50fLGYUvlAv5Y9c0s4ou9Py2O6cU4hYb2gP6FGO+GbkIrg/x5sEZFs2PEi0NkuT8rtFjtThPO/S26KvzfTHatbI02h6nS0w1Hr33zekrII+9fZtRxGC4whhOEGPXmmpGOSHB3TIZIZUrrE9AcXPE8413aIe9guUWWaKQzwN9pCkfOF
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
      mm: gup: introduce gup_unshared_pages()
      mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()

Yuan-Hao Hsu (1):
      mm: internal: introduce FPB_LOCKLESS for folio_pte_batch_flags()

 mm/gup.c        | 185 +++++++++++++++++++++++++++++++++++++++++++++-----------
 mm/internal.h   |  78 +++---------------------
 mm/khugepaged.c |   3 +
 3 files changed, 159 insertions(+), 107 deletions(-)
---
base-commit: b3710a1d0f145a4f6f1d44fdaff56a6af8cffe89
change-id: 20261015-refactor_gup_fast-b55e3f593dc2

Best regards,
-- 
Sincerely,
Yeoreum Yun


