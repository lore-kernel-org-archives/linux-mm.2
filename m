Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9456460A2625
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=pHJ9pM3A
Received: by kanga.kvack.org (Postfix)
	id B747D6B00EF; Mon,  2 Nov 2026 06:30:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25AA6B05B1; Mon,  2 Nov 2026 06:30:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B216B05B4; Mon,  2 Nov 2026 06:30:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3EC6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AC9B80C2D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:31 +0000 (UTC)
X-FDA: 85389961062.09.8A44151
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4170240007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pHJ9pM3A;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=InMeFNFjwhLZQCf3I7xrn9FEQa/179dGH7u0e06Suzo=;
	b=ZJzZS31WlKNZ684KL8Pgh2L/browFk6Us827BNMjAFfP9bjBDDwr0cNygAtF5FBU437jHl
	0uzYRJHdWO2mZz8XIjX+Yhytng7eqiY0BEt4NlARxgXegkz8eqOGdabave2Nfzs8Y4qTAf
	GxAUic2tDSaSRd2FIBVuGWvnkROvRwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619029;
	b=l+HXPeHaP/n0vtM47e5nwkBMUFsRJtO5jDuXU5AHnbiru2ZAQ1gWDTjFMe6uvNQD6AYe2C
	jbkn7ysWeltoqkT2BDmpcvKoTH9JGCHIsjvyJZSAJX59hY+OA/QH0mlPvPEhOjY1a9NYZ3
	eWvBDtA6QdFXWkooDN8QjrIpGOIPWmM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pHJ9pM3A;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 686671691;
	Mon,  2 Nov 2026 03:30:25 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97F1C3F632;
	Mon,  2 Nov 2026 03:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793619028; bh=D3Vf1PsT2DwtrXV9xY5TZ0/AQoE6JjmwaFHA7vLMNzo=;
	h=From:Subject:Date:To:Cc:From;
	b=pHJ9pM3APBFr6bQUnqzxTZjWVOKOX1gu79gJ5/9Fuwjzbx5Q0LTupSjjfEpgwHJBs
	 t6FbePj4JW5hCwqFUIo3vOnbzudfXnxDoK8SLLEg+VK3+GRBz9fyzhsRQYDAUe6uKX
	 zRD7KyRedgu793bFJB3IdfxdrmPsCBNfAQ5Dm89s=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/4] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
Date: Mon, 02 Nov 2026 11:30:15 +0000
Message-Id: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEd06GoC/32Pyw6CMBBFf4V0bU0fmQKu/A9DSClT6IJHWiQaw
 r9bMHGjuLyTe87NLCSgdxjIJVmIx9kFN/QxiFNCTKv7BqmrYyaCCcUZB+rRajMNvmzuY2l1mGg
 FgNJCLmsjSOTGWHGP3XkrYm5diP3nPjHz7frPNnPKqESOFiBVmbJX7buzGbpN/eYEO+KMzVPBc
 10raX5w/IhjDLSW8Q3g8M3Jwz3F0iplErIo/3DFuq4vBujeUFgBAAA=
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3915; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=D3Vf1PsT2DwtrXV9xY5TZ0/AQoE6JjmwaFHA7vLMNzo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HRQWD+A5zA3eTJ38mRGoA6BKnrD69H999el1
 MHyVxSeVZuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauh0UAAKCRBt1cPRWsUx
 M80gDADYr9b8OAg2TMoX4hf6iIaHO7YXrgUNwirzE5g4a4TFYCYVnwwY9CnO2sv5IqfIvNCSISD
 9dnjL29vcgNLXEy1A66vCIqOZsNY/XTeoMGOsXtDO38L2/774YPCZjfA2GnR5AeksySSTL7uI8p
 BsMmkRe3Jrujlu59Nzwvp/Rj5Y+MpFjkKqj0mweas9j2Qv5OrfcWP8W+rckZQPs7S5uyODsR5Hy
 VUb4U1ZhA8q1F8KC9uNOEMBaDh0WQbBUTxZqvRihm0L6SyKNki8rpxqEiQOLbALBxLd/tsBPx/u
 9ZzJJVk10GAAYp2rjhB8Jk15mZN8HebJ772pobuRAXJ4J3Vh2DFOreRAO2Y/XbUuV28H3ySvgUO
 mMzWHjTvtcM9OvFULpBaCnhGNkaUxZeHyDVJ9+rr1AhM7UeENNtkAioVWWEZ67HbRlYgZZyXOvj
 sTYvaJjOqazluzb/wft5tIVA6m4WcAy1Sza8E56E2HO3zP9H639TtwHni3FpDQFzO18Sg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4170240007
X-Stat-Signature: 5iembqts887supbdrz763da1mia8j78e
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793619029-711743
X-HE-Meta: U2FsdGVkX19STgt/vDjWufE4xnBMyQsE8zeEjuJ8bRSsXEvFVv+9P0eGi4it1iFogtHFvkVB+yx2D8bVpPwoZOT2JLE0yZbk2HReaEFnCLSMoKx+Uv4gj1p8owReJDAgeTr2AG7UvwiZJTSXliuUD/YzSnvdM1t41t8Aa8iwoPLXLvIXCm57tRFg65OMRB3fS9cAhmHi3of1UKj7DXoQOWrfysWicTzmKccMOZ618JKf107ZywXMYFEm+Dc8UQ461xleCjPTBRzE88vglACJDJN4DfEy4SMSuu5LKa3R4VvhxtV2B25oM58nbOrQwBxpfm2gjrzJ8I7hSM5S8ot/OXlC1OtWbVDlZ8+ZFER6opw6L7oN4RawHJNCL4bS4kAOzDyexYiHylFYbLtl2XozsmWiXeutynwSxMG8hrGALgPz51993WSk4Cf/Z1MdLyBKiDQJ/mrqKN3tBUgcr6lIvEukrbGGyTI1nOk15xsREsvJq5Prju/qPTXWgnHukJngGVZFIqt38xDB3w0ARKgF4GhZ2bWMEuMDcDdOZihEyGZMjQWiK51DE5+tL7R+TWiqQ0En01+Mp89GkV4qeQp9BblljNMg7awA/huHmma8+9WO9m6AMYeIjPmHlcTZuXHm7+gQNx01LJJwiBhNnNdCjyK3oYP14PCA1oy0DXj+VLmjZmaK5oLbSsM83VYJG3YeMGcRDKiyojjrXIO3wbOBaRKUftUa7uoUMo6PlQXmmWp/ffLmRSecICW2GqbIGydgHUNN9m4dwGetgGZciQOVJfNBKDNEJDP6CZNBnAPL80hOsbDPOIKGUPkjJ7atceoUY0qjsIATl40BZddEjawU/lrhgHoR7iUL0JcQc6SGZaqHIQyNsfs1Oe8mweKcRLgO1/4XGaA3Bh8nVFTQtKBqyxCJiEX4sAv2H7uUXJnBvtk7DadJFCFqICWrVSwcdop28GoaC/1g7IDFFYggz7m
 42ib9mld
 +AOWHtnov0DQA5LAmuRuA7zQkOmHgPtt6vvWUWVaHXnuMHiniha6vRkmu4AdFvrOFbxugbvL4KI57p0uwPyRfu2nVs2umOIz4umogCDE+uwsiQqJ04zAjX8FBXWclaSZcNYRns63aNCh6TPhsU3+rFJh5K9i768ApmYXrRRj4ccBf4B+yN7PUqv/AaJbW1wyQldeXI3Or8yodzE3B8Y41An+FWDrZIoGRopRM+9FgBncGVlzF4P/G0rTXP0ICIWBCpFkhmTAVHijww4Of1r+H6nHK0EoJqBETxChM
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
Changes in v2:
- fix exceptional case for shstk on x86.
- remove redendant check for pmd change in each pte barch.
- Link to v1: https://lore.kernel.org/all/20260917083747.786-1-aa9736195201@gmail.com/

---
Yeoreum Yun (3):
      mm: gup: introduce gup_unshared_pages()
      mm: internal: fix inconsistent in folio_pte_batch_flags() for shadow stack
      mm: gup: batch PTE-mapped large folios in gup_fast_pte_range()

Yuan-Hao Hsu (1):
      mm: internal: introduce FPB_LOCKLESS for folio_pte_batch_flags()

 mm/gup.c      | 113 ++++++++++++++++++++++++++++++++++++++++++++++------------
 mm/internal.h |  70 ++++++++++++++----------------------
 2 files changed, 117 insertions(+), 66 deletions(-)
---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20261015-refactor_gup_fast-b55e3f593dc2

Best regards,
-- 
Sincerely,
Yeoreum Yun


