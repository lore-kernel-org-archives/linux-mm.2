Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04458606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ki0jOakd
Received: by kanga.kvack.org (Postfix)
	id 2218F6B05B8; Thu, 26 Nov 2026 09:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9A56B05BA; Thu, 26 Nov 2026 09:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1376E6B05BB; Thu, 26 Nov 2026 09:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2A066B05B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:37:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4916640488
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:37:04 +0000 (UTC)
X-FDA: 85477522368.01.8764449
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 75A46C0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:37:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ki0jOakd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703822;
	b=xxJmaNxI7OUZ8ybKO1qZv4ygbAwp3FtallCS+vEgMr/MSyXCWzbhYqjznZNhbKVj3GLJk3
	ZIbPjFRHKZXlBSB1Zzohxev6i2k9NORxVwRZfyFz4ObWK2nviXBpLLqrN3/ImmYfsc5roJ
	ZKXkfrhAOuZVx6de0ZIULcZNF8kpcrQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIY/cZ2ZGAVUM/6AhJkgxHUgyfzR1EyOHoWRylAwhN4=;
	b=HrtC4CVXpcBVKF1ifP0N+x+4CcENmzPDaAWs37xN+z3SRmt8PkR28A0v1Ze60756nJyNk+
	bj4xwJmGghDWIqL25aLH7GxNznExi6uLkuJRV5Ym3GVyYCkXJ1xyQNoqdlYdLZ1olK+Pmh
	VldbEwibJeEOgDT+ySf2hyjiC7e4sMA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ki0jOakd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01D316359C;
	Thu, 26 Nov 2026 14:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50E31F000C4;
	Thu, 26 Nov 2026 14:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703821;
	bh=eIY/cZ2ZGAVUM/6AhJkgxHUgyfzR1EyOHoWRylAwhN4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ki0jOakdQF1iXDy3TJX0E5xo6LK+YbuXi9dIEhripoCQV4WV+xvA3OH/LZnpD25Iu
	 6Q8lo7zG+0bQeKTw8/Pco5KhC5QGkIFkRfOCwFA/csCSjM83l9y0KpVadXvFn6Dtpj
	 ybdJ3va/vE8aJNaJl1OU2hEiOJ/ubkS/HjnplrjFzPvPvE0VDSLV3WY3JRFgU9w+3W
	 NtuYybHzbdE/C9dzEkRnh/rt9x/3x+G68hdO1MaDjHzW1Q+f9N6xz+9TNBBTcwuY/s
	 NdM3KPYV8e1F2dJMD4cORPeLfC2TPMY539WYCvqH4SBtcOTEbBMy78vj4+kAzMwSPr
	 J4ALFHaT4fQFA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 26 Nov 2026 14:36:22 +0000
Subject: [PATCH v4 4/4] mm/huge_memory: only compare PFNs of huge entries
 on huge fault insert
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-huge-pfnmap-fault-races-v4-4-feecd58bb14f@kernel.org>
References: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
In-Reply-To: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3097; i=ljs@kernel.org;
 h=from:subject:message-id; bh=K+RR+33UGV2GmJYO6SEBtAFdDaiBsoC1Eii+CMY/7o0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5nF/IrZx1jPHhnx2cyyMaez4vXfb3m1dBFL+f+11x5
 ZYbj76e7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEtk5i+KfM7WTMG/mZjc9+
 plpR9oe730P9c02m9e1h2zR/T5RV0nKGf2rh61mrRWdF5S2LsWovDDqS1LKj/vZq9v+RdtMEl6u
 fYAUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75A46C0009
X-Stat-Signature: zhrreruk6s4pherwbrr7qgp31mqbecgz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795703822-418138
X-HE-Meta: U2FsdGVkX1+ldBXpWZOD7U3wZaelp37Lu7f7cnDnaQwQnnHOxiQh66bGyBx9pTsv6UOZp8tXOuk0UerPAw3oCGb0x49fsLqiL/2a3bMGuHVBZcTHMT8276lEq707M/GyDuETPPH4WO+e9//8LhRlAbL/3c2FUBmQ2k83/LzV/mL248Skl/HA7n4wDvOL2aX9xPwhu/GNojdMLZ7wONiZJUPLQBRouIakMmBoJsSOLzfqcdmr3nGwre5Icv5YsXJYPSL8Eb36M0zMxZomEfcX4rjpiadCfe3KdUsXqhM7eQE2N9EFBkJx8bHi/ZVYiZNNKG+Vt0LDYnDmaWp4SGKb/wv/K2wSXW8dXKV3Rx5kFL4NrOaf6w/D3TZgUFJ9mKBVKiDJBMT0mzkBkyKKl9DCjbPCQ2Jmg7koDAEt1ZfJAHCQ/3m0LsqjVSwDLc51NqChFEYrg0OC6vHmplwn/09boqQRYCgSpHU9HZqq6x4GJeiBKpjA3CqXdWeWLYXCpHdKVT3R2oc1LaSS+KpAIOTQteH9KmIG+Y22c1665y3De9kX4W5qmaPcuirUjxWHU0dT6RIjNjDY/01sMgKMuz40sP3eG4peC2l0zcpSPB5MIhRh79JrUYwaG01Pf/EPh7XPIEvBu/sBBTdsjDv02z6OM1fpTBezH53x1yuaJy8HVW0Jm2F3q64s4lVIcueffP8C/y5TgTI9dcARepC1th52kIKpWkEkm4b+Asxa/Ny2z2NBe1IzQdfYzoRQY+8b4njzUA09MNLNLtMH9mU7MosUhoomf1+NsJEnpLg74gElomir+4LwcozHwhmEZq1vt7T4k/y0d/YQ9Xg1L/B+rZixj2/hou/LZuUqFMHByJQ9R92LIgB5p/aD2Wa84qE4glU3dfMZnpLlZ+BvZVhXSItVBlHQ0Sf87HKkezqju3Nm8EVagv1PvSjnnxJ3xzNVyj6Zg6rLHBthXarfD+xd+30
 wiDpu5ZN
 SjQzOVSvE6DA+g9c/5Rw8C97P3Jx6ZeZFGGbPtwlWGSLiBZdyO732CAHzyAv3ghgBrEa42Ev/F3SxJFLaim8pw5WLLz2wt/Zf8Je9My0oZmRHe21zKIXcFtoPqafoaNUgdWov9MVXzJiqC/5rgLRWHVf2+YLXbMtNpGa6OO6h664x0GhZvsxzn1aLx1Pg0nLSUYpXklgJHpdBGJdlp4cqPm6zhhQinKvhL9qZTWFpv2K6dYcvQ03UTQttssIHRy42Hw9Y77b6zi0l6LZztHa80ZCuXfG9BN14jwaYblYU0Ezt6G838H5mpbnbVlLjF4II5050Kf7roYc0a2fy0oNOPV2TM7tpJ7Htzca5j05qpRqe+m3f1R2XjQ1r8J/O2+YRs8QOnX8evWEt2b7YuJxqhrTygQy6DUm+k1NfIFjQSttkwlpe7+rXSFqo+84sz8l7DTaI+K/Z+GOg1YfF3cbyN3h9TxrCyVlVYafe6BNEBEr0BJUa9n/y9PW/Ut5bAR5DmfJmWkoKI9HOzwtGpGM4QzdCvj4knsf8gfA/XXvU/n99jUWEyzdjt8jTCkDBta435WEoDlk4ldnRNBAR2R8i5M2RhtoZtNtoNrzL+q6G+XN6BLWUini332z0nvMG7zaRQoo0cz3uoraNj2h39tZBetrCBBCipTxV7V8aBOmHzNWQ7UKEQql1si+VaSjMC8tpxuIs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A driver that implements both ->fault and ->huge_fault must anticipate
concurrent use of both.

This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
concurrent with faulting, as that only holds the mmap write lock and thus
does not exclude faulting threads stabilised by VMA lock.

insert_pmd() and insert_pud() have issues with this as they both assume
that, if the page table entry being populated is not empty, it must be a
present huge entry.

This is problematic as if it is a write fault, it compares its PFN against
the one being inserted, warning if they differ, on the assumption that the
entry is a huge leaf.

Since the entry may be a page table, this is invalid and can result in
spurious warnings.

Equally, the entry might be non-present. Nothing can install such an entry
in the VMAs that reach this code today, but there is no reason to rely upon
that.

Therefore only examine the PFN if the entry is both present and huge, and
otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
at the appropriate level.

This is what already happens for a read fault, for which the existing entry
is not examined at all.

Target the commit which introduced the first driver which both mixes fault
orders and passes the write flag for the fix (since this commit, both
drm_gem_shmem and panthor are prey to this issue).

Reported-by: Eliav Farber <farbere@amazon.com>
Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Naman Jain <namjain@linux.microsoft.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ca9ca39d2768..b15e5b22b180 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1644,6 +1644,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pmd_present(*pmd) || !pmd_leaf(*pmd))
+			goto out_unlock;
+
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
@@ -1775,6 +1779,10 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
 
+		/* We may have raced a fault which installed a page table. */
+		if (!pud_present(*pud) || !pud_leaf(*pud))
+			goto out_unlock;
+
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
 				goto out_unlock;

-- 
2.56.1


