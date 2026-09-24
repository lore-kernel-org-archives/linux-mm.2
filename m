Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8C6C98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6046D6B008A; Thu, 24 Sep 2026 02:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B49F6B008C; Thu, 24 Sep 2026 02:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A61D6B0092; Thu, 24 Sep 2026 02:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1A86B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:53:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 834EA8026B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:34 +0000 (UTC)
X-FDA: 85247739948.09.E1C01A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E2391C0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiqhQ+bG;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=18Iz/H3HTqpxzrpyaB+gzd+ZartbUyA8DZtWBuWw8Ao=;
	b=kuwEf5pouSSOuhGpr57SwdEmnkAUMbn+oOKyFPjE2g7YI6/m1TcWlkvG+uZXI94vW18EJ9
	D0PZGWX9cbFg+7OSmdX2mE5rcZ7MF0aCBzigBJQQVLrZmiuARGgmEYGapLOHrmdjV44rAd
	GCt8iwF3/deyKH0jBkV+/gKxDSQV1xY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232812;
	b=amjYaHFIHU4acCG/MlUre1B0MME3OUKlzXESzvGiPlFwjhTD82RXOR4mCBpmamnwBU5TrP
	e2IuN1wj6q46w032MlrDFRgxXmg3BWaKOiUmwQ9MfK3QvDTm7q0J/K1kH0dWTzKTgdHk4/
	aT0kHdZ7BsGO22FhESiqG3t+WexWe48=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiqhQ+bG;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=18Iz/H3HTqpxzrpyaB+gzd+ZartbUyA8DZtWBuWw8Ao=;
	b=TiqhQ+bGnbBBNxjsfW5FhICYyQAggLpa5GunyFKdtvkFIzL7XxL6y3UL7JKey/5pkLZxN+
	czKlqe4+j1Y3epvHmGk+ikamQ0g6VB/0qfEOLpYw60x+DiCvsvTxyocFIaxtu+ySMn0l0x
	gLZbq3B3Gs+1xc79YGKdgbuzoNeRmgw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-eMKy4_NYP9ywSjEQ6ujm1A-1; Thu, 24 Sep 2026 02:53:30 -0400
X-MC-Unique: eMKy4_NYP9ywSjEQ6ujm1A-1
X-Mimecast-MFC-AGG-ID: eMKy4_NYP9ywSjEQ6ujm1A_1790232809
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a592e1e17cso8956891fa.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232809; x=1790837609;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=18Iz/H3HTqpxzrpyaB+gzd+ZartbUyA8DZtWBuWw8Ao=;
        b=YPBRM94pHxafgUV69/QOsT10QGqq0QBsTbK8qubiGljcWGXUu7pYQ7HNo0KsUn2NEe
         kNoiUwHFJf9ipo5mIyHtiRWKN5DV8h6Fea9gLKK/nZ+GyYcNxIvIKxdiKsMZPq6MZO+5
         k3w4hC0Ir6cZfhoZLFpohOpE3+NKtOsGOOpwYMdilz9sHctBtH9U7AX3oFwq4c0+WElk
         8ZGCA+cncnImoWWlhUyECJfE90AuWRPvz49WwjhdY6Po874rokJ7VKVEIY0xNFm/sFk2
         jy6VO7qzYXjcfqBSN+sJZ3um5ni5w98M3mklpscvMUH2UlbWy6AhYU4hA1ss31VKR79r
         +FfA==
X-Gm-Message-State: AFuF++k+TWmzcbcrfrCJGeP1Fm0LKD+wq1iN1xlbKyRMcCki0OTFZ7V2
	0tfIUYcXHbzKhweYq4FaJ5cM7Rf388S5BygjBQcErmAOkrVIrYkTFvHHuTPjE/oizumMUHoKkve
	83noFTJD5Boe3m5lg1JyVjKJltC4Iu9bD6aXnfwdPFdldLWjkxBUpI/WM6O+mauvVUOMnqS7qPk
	TfFhSbTGfYX4per/dwlhYGFjh5VCJZ8Q8fkZwcaw==
X-Gm-Gg: AYBFou3T0s2KiJ5SKyDaMr8Y3pRLIKQZWk06uqgplQD3QAKQYgLk+yTaEWj3DIxLFX+
	k0u4f4Av+aUnK8TIMG83lYS9JnjEkxm2hOb6fj0VdCnOvBzpko4/hlcdRs6c3JGZyEeJqnucGBL
	eaA7U7ihwkdQVfhnxL2eZwuc7Z0P/ZFLzuq10De7XLRsEUW3/hYOOJOpOnyIs5YfwN5hvRCDIx6
	jarGuEqdohpzvuQZOmq/k0PegIPk4lyqBBF8MC4RF2WTGdkSgsEj8sxY8K4dc+EAsVZi+8FDiSn
	WHwL7EgFO/Vlb4d091lGpA9J6eCwxYdpcSzQIds1l6YBTOLXx9aJHaasdprC+Uzlc0ScNJVdmVZ
	6TRR92AyQQfMtEtvr8Ctj
X-Received: by 2002:a2e:bea6:0:b0:3a3:74b9:8a78 with SMTP id 38308e7fff4ca-3a63c30cd55mr3506601fa.17.1790232808568;
        Wed, 23 Sep 2026 23:53:28 -0700 (PDT)
X-Received: by 2002:a2e:bea6:0:b0:3a3:74b9:8a78 with SMTP id 38308e7fff4ca-3a63c30cd55mr3506391fa.17.1790232807841;
        Wed, 23 Sep 2026 23:53:27 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:26 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v15 00/11] migrate on fault for device pages
Date: Thu, 24 Sep 2026 09:53:02 +0300
Message-ID: <20260924065313.899730-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kx_aN2iL_PJeOBIYmgYFn8ITdlvnTmweixG7--CGIwQ_1790232809
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E2391C0004
X-Stat-Signature: pwe53f5jjghbisc8npaas1jebj77rqwy
X-Rspam-User: 
X-HE-Tag: 1790232812-566715
X-HE-Meta: U2FsdGVkX1+B9qxnmlDb1SIGCOIoz+7R260Y/7xZO1dVMkC4nvyUVherA0X6V3bIDP1mAz4FwNn71llqiyjJAMZRyTU+3HFd2GAu/Z9d4AumRnyZlsVpNTl3eTo5w2/p32b9wmGqZxHa1lh6Dbsj0/fX3u453/kE5m+pQ0jlzM8qp/5MHpUe2mREaGaGWAM6PbKIuTvc95MjFJAWpyaoy60mhFcg0MRwKNnuBzwB/xh+T6PMPzJyhN3QbM2Veaep/nIjHgDl+kiqu6ZwshN9e0iiiRsrDVCqrSoPilFx7ESkeszv9odd8DLva7l1V4RldRpH0mFXdBjC4SoqH30p8uFA6F35E0HoL8LV89I7If/om6nkuN7mWSc0Zc78qzKXMmGKZisZF4aAdmu3/SUjd9Aob/q0ET/qBF/T6+wFSQ8Q9Aqul6MBg2Ip0BbIE2zBLwEnu0Ybe8X/YzJcWfGFx9pqP9QMEqusGAHZhxKhLUlzwAKwDl7zNcyNBE5jPQt3uUwE8wYPgFlEk5WEW0yjk0RVgW+DU+ZI8a4I20lQtrzeS6ZPRuqcvHWAR4lCBhIThAWme3BmY4NWmXprMiL1EQgn02ivtgENbEqH33iwaPAeQ1ELCGxQ17TWrXJRt621GmBL18K4hYR6a4FM6rsC4NK7bjcNsSBarSBjU8BnpXR+ky6HqXNojJVPe7mogr7wjFOmjyn35ttzsGgs7E8SnAiJ0W8WqQ0YtuYqfOWAPMNcBPUnUlKhtxYSreJQu/QbJvIMoJDNny71xZ0fDq2qJ+7Cy3POeJsZsOey1qAyyYwfONAKiKnFo9wzIFFqn+c+1kwHMuRo1DfPsUeUxVlPSdf4jDbZRVXHeRUjJdcWYT5q2bhYRvzyRCQ3FNsgrnu1HklfQ3druURQ2d6JpVEFcJxwKTWlyMqaqmJl2Ct42524jCALSwNzQIYKUWD98yvpwPUzEED02SmpoY8i0Md
 JufrV3nS
 NCVTpmI/Z3omRh4K2KeTrCSLyD7QMHDz5sxRO6UD7PCo6hX2gut2pAOG370pRktElmxNGGweb2sqzMtmHS9DX8hfCCXx1eEuJo8uRjJP2vVx+aBRUTKLTeQ+v+UTTSAXJSd0wnWeSBQV/t6G3pLxM/8qPj6mzyXeXe4HQhvVS6F0cduP7bjpAVt93R1aiWWltHpFDRxFavBsrUoBr6EhA/ailLl2ABncBTiegy3k4tammsk43xOeA1QVDwazvSu/jIBRI7/odiXXlCl/VwCfjKCVmKMXrR+KSkuDkwtmkdC9/W6SLl+41m25w+IVPBxNwGD4H8x23wK6tmqmz3CeAwoSNzqF52FxA6I5pUI7e7AMRRBHi2qsHW7xVKDHfQnoFMKy5grcaLL1euQI8o3OIp4mE6W5FEW75OdC0L4vZRsMnktlItXWe8QVpv6wJT1pBMZHbERsAiriGqu7/oCiY1+t6JmK92O/JIrQXHR09qZ6FIrVpMgEZ5c/JB6opsgF0P3kBaBM/x0JVJLaoMxEP8RHOS46+j7QuxMKB7WORatQ+7roG/P5vw2Cddie3HZIObgTPAdGvPCwMzBU4+zd1S0vobfL7WLYKAcGhiA6ktUxOJOdLPI/PKTM4crRR3ulSbtdiGXo3wc/MqE+q5mYRd/MzctEyt9ECloKhABNu1TVaqBMLaug2KMjIhDmhSXQc5j/nZp2jlaOpdFMUZAq6RTCs/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

A quick respin to address Sashiko's concerns..

Currently, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It is also tricky to code correctly. One page table walk
could costs over 1000 cpu cycles on X86-64, which is a significant hit.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
For the migrate_vma_setup() call paths, new flags, MIGRATE_VMA_FAULT,
and MIGRATE_VMA_WRITE are added to tell to add fault handling to migrate.

An extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

This series avoids the problems in current collecting implementation,
where racing MADV_DONTNEED could make the collecting arrays overflow.
This is achieved mainly by having a rollback mechanism and
populating the collecting array as the last step.

Tested in X86-64 VM with HMM test device, passing the selftests.
For performance, the migrate throughput tests from the selftests
show similar numbers (within error margin) as unmodified kernel.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes in v15:
  - addressed Sashiko's concerns
  - collected Balbir's ack for patch 01
  
Sashiko's concerns :
https://sashiko.dev/#/patchset/20260922053421.4092027-1-mpenttil%40redhat.com
Concerns and responses, patch numbering refers to v14 series:

patch 01 mm/Kconfig: changes for migrate on fault for device pages
  Q "Does this regression violate Kconfig dependency rules by selecting HMM_MIRROR
  without inheriting its dependencies?"
  A DEVICE_MIGRATION is def_bool MIGRATION && ZONE_DEVICE, and MIGRATION depends on MMU,
  which HMM_MIRROR also depends on. DEVICE_MIGRATION is not user selectable, and nothing
  selects it explicitly now. If some config would select it in the future, it should have MMU.

patch 03 mm/hmm: preparations for HMM to participate in migration
 Q "Is the tracked start address unconditionally overwritten on every walk restart?"
 A yes, fixed
 Q "Could using the owner field as an initialization flag be problematic here?"
 A yes fixed,  range->dev_private_owner not used as sentinel anymore
 Q "How does this API change affect hmm_range_fault_unlocked_timeout()?"
 A migrate on fault and migrate_vma call hmm_range_fault()

patch 04 mm/hmm: do the plumbing for HMM to participate in migration
  Q "Does this mmu_notifier_invalidate_range_start() become unbalanced if the
  fault path is interrupted?"
  A HMM_FAULT_UNLOCKED can not happen with hmm_range_fault() + migration, however
  made the exit path flow thru hmm_vma_post_range_fault() in these cases also
  even though it is nop.
  Q "Can this early return bypass the TLB flush for pages unmapped in previous
  iterations?"
  A yes, fixed

patch 05 mm/hmm: implement folio split for migrate needs in HMM pagewalk
  Q "Does this create a livelock under contention?"
  Q "Will this spuriously fail migration if the folio is split concurrently?"
  Q "Does this correctly handle cases where fault_page was a tail page?"
  A this helper is removed in v15

patch 06 mm/hmm: migrate collection in HMM pagewalk - pte level
  Q "Does taking the reference via folio_get() before blocking on folio_lock()
  create a livelock when multiple threads fault on the same large folio?"
  A The ref has to be taken before dropping ptl lock. That mirrors current
  implementation. That can be improved on with later patch if wanted
  Q "Can this split_folio() crash if a driver mapped a raw compound page into the
  VMA using vm_insert_page()?"
  A The  folio is either from vm_normal_page(), or a device private/coherent page
  Q "Does this error path unconditionally unlock a folio that the caller might hold
  the lock for?"
  A yes, fixed

patch 07 mm/hmm: migrate collection in HMM pagewalk - pmd level
  Q "Does this code handle non-present PMD leaf entries correctly?"
  Q "Is this branch actually reachable for device-private PMDs?"
  A  PMD size device pages are not present swap like entries

  Q "Will this use the correct subpage for folios larger than 2MB?"
  A only PMD sized THP pages are supported

patch 08 mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
  Q Does this skip a necessary TLB flush on the error path during migration?
  A yes, fixed, same concern as for patch 04

patch 10 mm: enable device page migration from HMM pagewalk
  Q "Does this code cause a permanent MMU notifier imbalance when args->pgmap_owner
  is NULL?"
  A yes, this is same concern as for patch 03. fixed

patch 11 lib/test_hmm: add a new testcase for the migrate on fault
  Q "Does skipping the page table update here leave us vulnerable to concurrently
  unmaps during migration?"
  Q "Can this sequence lead to a use-after-free of device pages if a concurrent
  unmap occurs after we dropped the mutex in dmirror_range_fault()?"
  A yes, the sequence is fixed in v15

Link to v14: https://lore.kernel.org/linux-mm/20260922053421.4092027-1-mpenttil@redhat.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

Mika Penttilä (11):
  mm/Kconfig: changes for migrate on fault for device pages
  mm: add helper to convert HMM pfn to migrate pfn
  mm/hmm: preparations for HMM to participate in migration
  mm/hmm: do the plumbing for HMM to participate in migration
  mm/hmm: migrate collection in HMM pagewalk - pte level
  mm/hmm: migrate collection in HMM pagewalk - pmd level
  mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
  mm/hmm: implement rollback for device page migration in HMM pagewalk
  mm: enable device page migration from HMM pagewalk
  lib/test_hmm: add a new testcase for the migrate on fault
  Documentation/mm/hmm: document migration through hmm_range_fault()

 Documentation/mm/hmm.rst               |  39 +
 include/linux/hmm.h                    |  51 +-
 include/linux/migrate.h                |  58 +-
 lib/test_hmm.c                         | 174 ++++-
 lib/test_hmm_uapi.h                    |  21 +-
 mm/Kconfig                             |   1 +
 mm/hmm.c                               | 956 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 617 +++-------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 9 files changed, 1352 insertions(+), 619 deletions(-)

drm-tip
base-commit: dfe5a8188de9aaddd4e46b0f2410d0bccd5c1c04
-- 
2.55.0


