Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3AAC5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C256B009D; Fri, 21 Aug 2026 10:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A236F6B009F; Fri, 21 Aug 2026 10:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A826B00A0; Fri, 21 Aug 2026 10:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8736B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:50:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3DFFA1897
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:07 +0000 (UTC)
X-FDA: 85125561654.16.0E1C213
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 538A9140009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:50:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=igQmwRfF;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787323806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CGzie6Qe/X0/cYKzE/v7Y5d2k3Tc6ZI2rClbmVZ2bdM=;
	b=R0NbHsQ+I1OmmZ2sosX67O57C4n1XV+sKDYVUyZQtcDU6eMyQQlf40OJ5Avq1M3zV6MasR
	0yBGejmUHcjpFohJbthyBSGKSkrWiG+OykikXX8WcCaFu5F8sKhSRFBO/YCnqnHwxNWBMc
	BzZmkNg8anRBVZYbiaYFCZ+o1FUY3iA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=igQmwRfF;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787323806;
	b=4PJlb9tRpsYwfFHa0LEuNbSP/Pw4plXDakKcFFZRR8itFnkELRHDKvjPoN31LCJgqDGetK
	66aqbgxEZWK3tYA/K4G+i5QR4AjZzxWzfIW5lsNdFwy0E4YsJ9eCawJaVUfI9oYjLCaGAy
	E+h4DJPOgkYQrr4ECwohkqjQRsBlQHs=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-936e8bd9caaso75944485a.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787323805; x=1787928605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CGzie6Qe/X0/cYKzE/v7Y5d2k3Tc6ZI2rClbmVZ2bdM=;
        b=igQmwRfFWnko+TFjCB/YcTaSPRW0+q7NDH/OJf4DbaCFOitIbhSYpiy4XR1pODgbt3
         PzOMWCTOTNNbX66RqLCWSLDS0Hx8H2xCjh07b2XAlW/z3tsxfiMLr1SqZVGdr1Ui6zAf
         WzqmC/cdREyWPugDWRTNJww/fBBAAfQZpJcSf2bn38cAz9+X9OTxN0hYgTy4eg9YVYLr
         2vH4gaIG0g2ksCb+0F5t6BYzERqDPwV+zPfrNOkZl5E2JtrUVQO0Q2roIjSyz2e6YVUz
         18PQx0+qLHT/vwrRhk36rOG62IV7Y95NcmnYHoqbtfB4BAqf3dd23tBExdFtzbHWanh7
         psfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787323805; x=1787928605;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CGzie6Qe/X0/cYKzE/v7Y5d2k3Tc6ZI2rClbmVZ2bdM=;
        b=r0jjLJkXvCZbBZltg8Yq6gMhJmhU0urBm5T4OqRSpypocn9x+WU7pe+evviQGIPeG0
         DHHyq6W0eDEZqGP1A0m6LgwKejGc1ZsF3kD11Bccii87jmTnmr6FvZzaCY9IdgPmIL85
         fLIFTen1ibKlsCFIJ7zTk2neY8pG/tsCeTvzEFIG6bLnhltwtkb2BeyhrB2pHDdHBV2e
         KYZAjABSsnuENAZN1v7LAyPBP48/Zd5QLcHv9xHznJxk+hZOgrx9vHvtFnw73BsiNncp
         on62ProbZylWxUUpMk4Nbt7h/LL67vhyL+ljim6Vdq+GLAFevyFJ1TNZQn0qkTHHZDlV
         cELw==
X-Gm-Message-State: AOJu0YyGCl29w/YsOVT8I4sEbn5bNIGsNYO0mwmwjJmriHjWH40VBtAC
	Cq/zSw8gOKy8ev1eeimy0eF333j2L7ypHN/4U38oU5S9fCoz/Enz9O02vBjgUBRkUpKuC32s0oW
	Bs9pa/b0=
X-Gm-Gg: AR+sD10NIoNIMEzkP7OTCSD+AHbPg8oR6+bUxnTlR9GWISHL7O83ZWpjLEjJIne2Bya
	H+eCUbsCPaD6Ou83zQrvb/kvHC1CdgaUuoAt/Hoj9wMgjH6kDaUNG7Qk/DywWtFQyLDs95RJXkQ
	NdJ3NrgZuqBll3wL3XrPi/Vr36Vg/PLOTbgWRccWilfjpcPbdoWPdTUZhbJe/mEzvqFRUc1OiUq
	HgtsFZPR/GjtimXDFIpbhiYfd8lGEdk5s8VA3tgcvibuTac8pv1dNAojfa0HDp5A2nMMdbm4Sfu
	1Ewg9EPgdZJ3VdoMSG7fywmAIcbFoOHMErCb8b9kkwPTULVl+3CznYKqdidEt8w3WG/v/p3pcwt
	jktblY0uN1k94c30/34suPpYOq0nV40QORlFTSCrCV7lOrcdLI7WWqqu/dZ9sYyx1JwxQ9rUwh1
	u9RT3PsVPgksPwuXmEvBwED3Oh05Wxg3YJx8E+2YE1qQ0VeVUWqezmGCPJZCEjpPRd0ItbFmIpM
	e9bBXb6MZGq8/L0j7qd/o0kZVVYjFFgkecwCJ/m+9/1jPxN8g==
X-Received: by 2002:a05:620a:2591:b0:936:d833:6a35 with SMTP id af79cd13be357-937392bd3abmr583820685a.0.1787323805326;
        Fri, 21 Aug 2026 07:50:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93720493f35sm609512385a.9.2026.08.21.07.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 07:50:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH 0/2] mm: stop calling pmd_folio() on special PMDs
Date: Fri, 21 Aug 2026 10:49:45 -0400
Message-ID: <20260821144947.167382-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 538A9140009
X-Rspamd-Server: rspam07
X-Stat-Signature: 7n3uizq53x5joswbrxp8d3ujkar6qjgg
X-HE-Tag: 1787323806-401641
X-HE-Meta: U2FsdGVkX1/6FZbk3opfh+tnFr4HOxntsTA6snqg4O690G7OSfsyefFfKi6VHQ18D98pMupU7hicC0PZxuvE3PeYVUPOm6EkQpNKM1/itcYBqJNP9+61QX6qhavMpRyH6rBeYA1cF0bKnPxqLfyNN7LxnTFd2Qjb91/rMbZ4XRtbQ27qTeLHVbxpqJo9hhzHe4ODCAmZzQIroL1EWY1dRurs2C4FB/csi71AUFmxZmxjhRL850bw6hXdW3Y7L8DxaeDJkLbHSu7AMIpjd8C/Bu/2PzDLfr2O6JKqeK3jh+QXu5yFspkMROEwEBmrrsrqBZl6R/4CYyxk92NODK9HuG93Qzz/DjzAe75CvmTWDWtxgwwnxoCKH3OuujR7U39xC3yWUF4wfRHEC5hLFqvcLK4jkH3AH9v+OypKd9YpcC9un5qaoAVDFrwLZphdBbGvxDN6gT53UHoj9V7mLRS6Edb8IpBr+VKDP23UuV01gzeRDQ1erpMCFa7uwY8qT7tscQ1hSB2/NSPU1w3lK78tlyzE1J0R+SGHgCoo+urXhdwcMdeOwSVxTpBr+UOZ49zbZcVatlOeXgcmfC5RnPvsMvKH8so+xGko0+I9L2paJfBSH5zeBFcgqQAKt2+biP/6vIyYyv9hMfg8JSpX8tIgI4XvnFFFeEh9QAX6+ol4k5py0KnKijo6MVbKhJ7Md0w/KLVbelBnVqGKKXSoX78H753G3E7N+bkAC0kBa+1xdl3ULEQpjLOA6c8o51swv4AbA04Nrrx2tF+idt0/NKeczNBhPjjCjykL6Rr6VU1MeYDgB7XqU8gFUYySqIXFHvXWXAUG9GHd8ibF3hzAjgjjxpXKODMm87j2Uj1V7fuvQtTR6h7LtSTgbmH3azlQ96+2oSEpHbi/9Hf0GxnvCBY8owyeCweS1bc24paLQXDL3JRnhgmoRqs+zITkpDTMFwdonGO4wLzYXEw7i3YFzLP
 wc9ClvcZ
 mkWJnqTbx7GS0ECfQvAuA1NUu77EQ1EOGo9PYDV6B4R76Gbh4wRtTQ14bDG3roigBOIzB/Y1StWVKTMd3/JgNe9/e2x8H9BLWhAOFOlhYE2MBk/wJWh9fJUy5WIjmIMnFzHdAJDdfY6r40p1tVR8W1VN9bakSnIrCQrsrOAwSMewSc4erzLvfoGXe86vPzhdSsFQ6Y3HUHPe0BmdeG4KcaS5BlLb/kr8PbIknGxV8ahmE6CRX68BcgkDliDT+LIo3uiEIyWOicpeYlZnIHF9vjNvlcK8Zj/3mcLmvE2jQetVry65K6b+llhK/oyb9s7QvfTOLzNZvLn/meccm+HRgnfFlHvwHER9Nqu79qtBQmjqbYQxvkGNO9XnpQ2nSCvepTsH4jflNEmJ1K8P9yM/s7wbzk3g2nELo7P/OAsrs73wDIrUq+YxLKq5RXYb4McuFLRdYWPjyNqB8XiViXk+tXr17mE3uxsvsaHS8oF5hzCe610eIIHrWTPS0d2Omr251sE4L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew: the first patch in this series will annoyingly conflict with the
zone device fixes (see Closes tag) where Sashiko found these. Ordering
on backporting is annoying here, not sure of the best approach.

===

Two page table walkers resolve the folio behind a PMD with pmd_folio(),
which is only valid for a PMD mapping a refcounted struct page:

  madvise_cold_or_pageout_pte_range()   mm/madvise.c
  queue_folios_pmd()                    mm/mempolicy.c

vmf_insert_pfn_pmd() installs special PMDs holding a raw pfn that need not
have a memmap entry at all.  Both walkers can reach one and fault on the
first folio field read.  The PTE halves of both already use
vm_normal_folio(); these two patches make the PMD halves match.

The four callers of vmf_insert_pfn_pmd(), and which walker each reaches:

  drivers/vfio/pci/vfio_pci_core.c        VM_PFNMAP     mempolicy
  drivers/gpu/drm/drm_gem_shmem_helper.c  VM_PFNMAP     mempolicy
  drivers/gpu/drm/panthor/panthor_gem.c   VM_PFNMAP     mempolicy
  drivers/hv/mshv_vtl_main.c              VM_MIXEDMAP   both

can_madv_lru_vma() rejects VM_PFNMAP, so only mshv_vtl_low reaches the
madvise walker, and that needs CAP_SYS_ADMIN.  queue_pages_walk_ops
supplies its own ->test_walk, so walk_page_test()'s generic VM_PFNMAP skip
never runs and vfio-pci is reachable by any process holding the device fd.
Hence the different stable tags.

One behaviour change: mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP
region now returns 0 rather than -EIO.  The PTE loop already returned 0
there.  drm_gem_shmem and panthor are where this is observable, since they
PMD map pages that do have a memmap entry and so never faulted.

Reproducer
==========

No hardware needed.  An out of tree module stands in for the drivers above:
three misc devices, each with a ->huge_fault calling vmf_insert_pfn_pmd(),
plus VM_HUGEPAGE so the fault path takes the PMD branch.  

  /dev/pmdspec_mixed    VM_MIXEDMAP, pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_pfnmap   VM_PFNMAP,   pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_real     VM_PFNMAP,   real alloc_pages(PMD_ORDER) on node 0

Userspace maps the device into a PMD aligned window, reads one byte to
fault the PMD in, checks a module parameter to confirm it went in, then
issues the operation.  

  vng --run <bzImage> --user root --memory 4G --verbose \
      --append "numa=fake=2" \
      --exec "insmod pmdspec.ko && ./pmdspec_test <subtest>"

numa=fake=2 gives a node 1 to bind to; the module allocates its real page
on node 0, which is what makes queue_folio_required() true.

  subtest        operation                              parent   series
  --------------------------------------------------------------------
  madv_cold      madvise(MADV_COLD)                     oops     ret=0
  madv_pageout   madvise(MADV_PAGEOUT)                  oops     ret=0
  mbind_mixed    mbind(MPOL_BIND, n1, MPOL_MF_MOVE)     oops     ret=0
  mbind_pfnmap   mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   oops     ret=0
  mbind_real     mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   -EIO     ret=0

Two things the table shows that are easy to miss in the code:

  - mbind_mixed passes only MPOL_MF_MOVE.  MPOL_MF_STRICT is not needed for
    a VM_MIXEDMAP vma: walk_page_test() only skips VM_PFNMAP, and
    vma_migratable() is true for VM_MIXEDMAP.

  - mbind_real demonstrates the user visible change (-EIO -> 0)

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Assisted-by: Claude:claude-opus-5

Gregory Price (2):
  mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
  mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range

 mm/madvise.c   |  4 +++-
 mm/mempolicy.c | 15 +++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

-- 
2.55.0


