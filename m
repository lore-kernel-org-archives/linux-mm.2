Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEFCE6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 20:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A965A6B0005; Tue, 23 Dec 2025 15:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A442C6B0089; Tue, 23 Dec 2025 15:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942C26B008A; Tue, 23 Dec 2025 15:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81A956B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 15:50:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C73C413B09E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:50:57 +0000 (UTC)
X-FDA: 84251930154.05.33F1223
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C3DB20002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:50:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/yCeJNk";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766523056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vAZ3gYg73FG+tcs0YaSRZAMdGepo+xXMwgP8jqqEJao=;
	b=Nx3don8deQDphkj4sGY/v5rGtqHRuRHZ+QE4qGPTmk0NDxtjK1jopDxL9eM9YRz41Yes0d
	NHbzPJzEdxtL3ykuWntUI0LqlYxwVM8Z2546ulyvUlFcA0hMI9DjUfERsuLXWDqf2W6APN
	SSqpU7JRvcm1sVPrLN40ikD1XA1MjOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766523056; a=rsa-sha256;
	cv=none;
	b=aAMa6ujgIb5F/HqkdfB4RYt6L1ZLDzwa2949DMLFwrrkcGNKsQdSLnJTE6fKIuIxVWkVp2
	lgyOwkohkmC6sKEPVXjuHQobCN9yi+CU6u/Sc8nu+tajJXKiGu/jl6bjSZQlGCDPMLzV3e
	kZTT87oJVSV8VRamRZOQ2bRakAM9vKY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/yCeJNk";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4406C60123;
	Tue, 23 Dec 2025 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F60DC113D0;
	Tue, 23 Dec 2025 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766523054;
	bh=trDSBTaA6WTrHmc9KKJcMvZl6ePTGpic7B6VeAAp59I=;
	h=From:To:Cc:Subject:Date:From;
	b=Q/yCeJNkMbsOr6ih8Ct52pGmKB3UNVAXspjyUHpkYkQYhmv/wN/vQqUO8B4aSVb43
	 lt4I+mitTdqcYGg20h5Pip1pBa04LihhstYsrW1UM4yUmJQJ9CnwEyADdkPOJ2/V3H
	 my76A0uDLn9HTkHIU/TX900oHCMUfofNYOF0E25WSqCOGrSR6CuTJgR9bhG8l1ETNU
	 hRJD1PIKka/M/a065jPYoCDNzUBcGVNPt7bji9JeljOrdPC8okMOZdVyARn9zRN4zV
	 xqv4o6EIaUaTqr2QODVqnH37YcRYFYC5YDMfa7OGzR41w/ax/vCctSIJD9XCIcjy7T
	 W/jfF7R/I59Ag==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH v3 0/3] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Tue, 23 Dec 2025 21:50:43 +0100
Message-ID: <20251223205046.565162-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ptdon31oam333fmpdcqz46cpnp4a9m6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C3DB20002
X-Rspam-User: 
X-HE-Tag: 1766523056-336109
X-HE-Meta: U2FsdGVkX183eYN1gA42FLJM12C9/llh7cDeQmcvjbWRYUSEIazdrGkuAH3k/OYWh4db5h0/4/ZsxgqPVwAtWQ3sUXVfxasLLo2p2sHD3LjXAq+AN5v1s+t9gI1fLucxC382yoORV3FnNdHOj57ZJnI4m1GKYybc6WYm0Bn7BaJWX9Bjr7CU/1a6RUZ3YsSuROQ8dFO/do5VV59Igvi7CteIawDgh38l6x1jbY15x37sYTxtWnkYYp20m+sjMwHEZN/5c+oR8SCRQ0Dl8UA0olI38M280s1jBQD2KAHUb64cF7yswLUszL1VetrdEcsY06T/3bmpyIn5nDEATv02eR5bpMk2AE3/nFwzbuCyE8WmR1267aPQt8F5rWG8SiLjnXn4KqRjFe5JazCCX5fLmhMoXzHgZCgXTY5oOhPVMvqlRZ52s6bq6hN5L/xteSB7TxPb+F17jCAJD6FgOv8yhoW86spX9m3ly11/iNRe8qwrLxWN1Mgca585gq2HHiifs+7lbMIskVc/RJMQxdvIvSpP11yuH+XKEmyfsiJZ177JePvooW0NDY+l9uLa3WSKf5AJV3CY+oWlejoGVX2prm8bfn0l1cS5I3W2b2nxPg4rjLnd/XgEy3vIDUAvW3/13hWVaEXRdH0oOGQ/01kABKSPAIMZwO+fd868/8nl5IBdnbI4m2PQIfDpG3NO0BpPT5VWYiLg9R+WKWYRD8ugsr/myXvqZboM3SebxmbeTKFPTPkHh/hYKBqqRlawMioEYRGDincEc8/AMUQgFZUb4wTDtjoFBTvq6HmXe/0cXYmJPiMZ/hm1mwHCkFmg/y/AVWNmVOPvJChp9NJBxORVqf9/djXj33l8fEXQH8sCCohDErE98lbW60SINVOs38z5/6pg8Vn1PlCy7K6gC8KUS4RHbtShznZ0bn+HHCD+HVi4GwP8oOG299v0AxCy+lmOFNa8HyHlYnm9O86L4uy
 9PWh6uxf
 Z/KpEBokVR6KNkREE1uD32OYgdlTGpGXOnAO+eZkmI1JTqe2WtGV8zgBAcD3d3PiRM84AEDAcmdUjTp3WVnk2OqlHY4D/tmqQ0Gz4R+WKhLCIxR1BkTC5olH1Fmy+KRr/lirE5Oq82vyJWFdR9pncCCQFAN4jhKuvnQwXKEUsGX6EnmlK55u00t7rh1Oa2V1hDnJA9Vb2E40dvBbD4XCH6iI1HgDJKQJEiDURfHlOLRU1D6YqibQm8cwvxA78i0EdiH6Ql1exOWmkPaIPsM+Vr4anKBwC68cBNK4+En/hKKOIOoYJxyQP75OUb2nW8GVM6ImvP/f4+EhUtMr/UvYHsDcfwT+IguspmX9fjlyZjENhjUzYfNkcdzuAvuKLeoy7+wt5Do7GiN2vZ0o+NIpwmKQiklmeaLhdAd4S7mv3m3XdMTpQk2OlQCEKeercGtUebqNUh4Gp9w0IsY9lxoLtCsx6GEc85Gvbwf/mXuq5X5Hc+GS53ROOhmjBMNhfzhyspiwDHIUqP66+BC1AIHKj7n2SYEO83s3HKHskhRhjrF70N3xZUZXofdb9GI0DUKv4tqZvP6hwatBZYeDgheH61zaNsyhfYE94niHAEuUaAWfsIdRvfRFifiQDkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

I added as much comments + description that I possibly could, and I am
hoping for review from Jann.

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Compile tested on plenty of architectures.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

[1] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
[2] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/

--

v2 -> v3:
* Rebased to 6.19-rc2 and retested on x86
* Changes on last patch:
 * Introduce and use tlb_gather_mmu_vma() for properly setting up mmu_gather
   for hugetlb -- thanks to Harry for pointing me once again at the nasty
   hugetlb integration in mmu_gather
 * Move tlb_remove_huge_tlb_entry() after move_huge_pte()
 * For consistency, always call tlb_gather_mmu_vma() after
   flush_cache_range()
 * Don't pass mmu_gather to hugetlb_change_protection(), simply use
   a local one for now. (avoids messing with tlb_start_vma() /
   tlb_start_end())
 * Dropped Lorenzo's RB due to the changes

v1 -> v2:
* Picked RB's/ACK's, hopefully I didn't miss any
* Added the initialization of fully_unshared_tables in __tlb_gather_mmu()
  (Thanks Nadav!)
* Refined some comments based on Lorenzo's feedback.

Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>

David Hildenbrand (Red Hat) (3):
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

 include/asm-generic/tlb.h |  77 +++++++++++++++++++++-
 include/linux/hugetlb.h   |  15 +++--
 include/linux/mm_types.h  |   1 +
 mm/hugetlb.c              | 131 +++++++++++++++++++++-----------------
 mm/mmu_gather.c           |  33 ++++++++++
 mm/rmap.c                 |  45 ++++++-------
 6 files changed, 212 insertions(+), 90 deletions(-)

-- 
2.52.0


