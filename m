Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8AEEC982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A846B00A1; Tue, 22 Sep 2026 01:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341966B00A2; Tue, 22 Sep 2026 01:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257DC6B00A4; Tue, 22 Sep 2026 01:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E639B6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:34:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED2F0A03CE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:44 +0000 (UTC)
X-FDA: 85240283688.18.A44A952
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FFAA180007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+Xn5T0J;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ExYdezdvpHVo92DuelngyydogrRLZoYOU57jNd3LbOI=;
	b=6YdrwGoZFXnVMOK5M0zE+sv8/dUZYFYqw4HtDZ5OLKb2e81BXyjxAiYaYNnaR5pJ6ajXAk
	9fQqEqPlM4FnP9Us0TQErSJgnMMiXjmvPet0zYNRcMFKcvBn+jOpzg7ZGRSJNTZxP3fycV
	Zjyoaey1Ovn16rHSxW2rs+zYQ1dOhDc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+Xn5T0J;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055282;
	b=PzUYr0dU9ycmB+TdnirgPhMioKHhTRJ5PSl3jokBdbRhK+6BbQ/WzrjUqdI1po1/+bhYVE
	A1hY8hMXN6bpo3Eq3QZodnGKsTjpnjHEfOkD1AX+TK8e+0Nkmy5FLU5Z3yGFT4KVOw8Z2f
	8c4rC0Y+m1D5f2KJ+Eb6fdFLX98SlWk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ExYdezdvpHVo92DuelngyydogrRLZoYOU57jNd3LbOI=;
	b=X+Xn5T0JNiVq1508pdUq9oKyLH3X/VUDC8PeumratnR/fhWq18jX8VhlUoJAeElRxd1yUH
	KSsOJ7sjpTFgmPhhmJdyHOOMffeo/lwDtJ+w9kk9gc8B79sknC1yJX3DppYlieazjt+ofw
	d7uafXcIXgLwefJh+rFBBDXMTCJ8Z8Y=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-vvd7AoMgP5GF_L99wH8XuA-1; Tue, 22 Sep 2026 01:34:40 -0400
X-MC-Unique: vvd7AoMgP5GF_L99wH8XuA-1
X-Mimecast-MFC-AGG-ID: vvd7AoMgP5GF_L99wH8XuA_1790055279
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b8b53dbb3eso2109872e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055279; x=1790660079;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ExYdezdvpHVo92DuelngyydogrRLZoYOU57jNd3LbOI=;
        b=OLGYQbyZZCdGU7VjMnIjhKDwtvp9xV6Zp4stGvMJP4m1isuSVvLBH79lIbgS7/fW3D
         nETwO1XqKggYikQRz+pLuY/xn6ma1WHrreGFIDwM3esNcxChtm7wOQAjJF6/XIfE4oXu
         7mgh30ZT3bSSDhMsgXHaicJazOrTiSqFqJvES9JRZ2OUw2GW4hbGwmMQERNh8xwABB7U
         GLTxQ/AwmA9QS6pLNK5Wo7Jjs6IhF2UGTwlEU8g0e1SQmM10v1935pZP9dAVfDjAYMDQ
         2tpDOlbMPSaX4cTPTMoLST5ZNSjiUdal1Zwze6UumGng1NuaRTuxwuACt6eSQiCmiB3Z
         ctuQ==
X-Gm-Message-State: AFuF++ni6Cv4q7BTxrODLHevj4mpCAAo3si0Av4pxN1q5WvpEAlhkSVu
	p9gnDxmrv+KBQzcE1DPvj/3IPrTvVmOmQYWDkpouJ7s3qDv1BIkNuYAnaNl0XxRk9Nzk1+RPCU0
	IXKcnSgx0BULfkKtx5gy1petFWhYMPlZiwQq/W/rQtxVdJqGdmlLK5iI04Scgn/nQ99EkszKIqd
	DFRndEXUL3hPycX/NuQwSgjLSTl6IMr8oqNjCbcg==
X-Gm-Gg: AYBFou1ulZKhyJZDp7kEOSTCZ9VZbLmfPrJzqQ/BXFlxIltMvCzJGaRjm9KNAgBfS9x
	oD98qYwYxWEstK0HJ2y7/iNCzD1Y5OSvQGqHJPhP1lrpYqjN0hJFDn0I1QEaagWJSZgDg5VmXdJ
	2IAXibNTgCEcwDT61MvH3gOQkQ5OHEoe5Q/A7+Jja9GUE2I1G6FYkwwRJkjdtxnGIe6jKEGGBk/
	4esD+XAfPx4DkDi/eS+V7XoEUSTR7DS4sL9sINYxCeg4x0gM9t9QIjqzkyzZKx7Y2cm9Z2QkAI1
	bSepzUV52ftBsUXZHLn3qRZWW6pdeRnQEfUcKWtz59DFy0LW6jN1nICL6v/b7BGvpjvGseDey2/
	8Mf41MzJetry/vPKr1YpP
X-Received: by 2002:a05:6512:3345:b0:5b4:ac27:6bb0 with SMTP id 2adb3069b0e04-5b8c1833167mr4016917e87.25.1790055278679;
        Mon, 21 Sep 2026 22:34:38 -0700 (PDT)
X-Received: by 2002:a05:6512:3345:b0:5b4:ac27:6bb0 with SMTP id 2adb3069b0e04-5b8c1833167mr4016894e87.25.1790055278113;
        Mon, 21 Sep 2026 22:34:38 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:37 -0700 (PDT)
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
Subject: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device pages
Date: Tue, 22 Sep 2026 08:34:09 +0300
Message-ID: <20260922053421.4092027-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dgs30JrtJrZF-fkUT-u3lyDrsMcGMywpBrFG9jxjpBA_1790055279
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8FFAA180007
X-Stat-Signature: 5w1casgcrttuwya6eg4knht8wik47zxr
X-Rspam-User: 
X-HE-Tag: 1790055282-765458
X-HE-Meta: U2FsdGVkX1/b+9fwU4MUbj5OUhhVEEbxYVrphh2tewcl0E1LpP4do/nXg4ZfZ303Lw53Y1R1iHc9l19T+YydIaeZZyHjucqLVphUv74segqdPeg/jRWPz8+9C+6cUkXOaJZxLjQ+1DeAa9f2QJ1hs9czKwKJ0+WNgqHUwzWtY41kLB8DD/0E9XMkbUfX7HhKa248N4VepAj0oGZnCq7PloGZQNC7+QicgKDJ4MOomq6QENEKXTGomO3rj/MItlBse+9Qc1EAEomVZYpMATY+9ZmIOwYHP5PA3ZT5Hzm8Ae1MsGwIK8WGMgX61xez/ogXCTRtVpq/ifKJeSV3X1PtkRjxYcDzYLMxCrfgJvgYOWBtHYshzZQsy4i5IOgAUs9ipuTfzJaoB5+skzH3ZGmqMEpdjeXxtsz9LEv7SPt/wvrYDXXDkfNt2blO4sDezQGgjpjxSoMYI/sgrerBdzvhPB/Y/ZDDwvNkDcUtYiCIphYReviJjuqVVWYW90bREEH1TT6uLZQncV9KiAsutHgH5SR6NQjCiZ9wNnJb3wYdSJXVv0AlCU7ulXGJrRIxYoqoibKZVCqSNCBseAcEooj50qGUuevFmWvZWHWP4FLDJ41ieNEXsnlXTn9lLKXMkcAm3vQ0zwo+QNsbxAT3fSxOARYpqpZtPj/21QLXuM3uZxdB2x9LEWVVQqgCahiFc3kp6LMO3ZlzQ7LO/tBXcmJ6Q/TJ25/5fOJw2g6v5O4Uj6Nx/y+QRNO3Nlof69NA+JNNvLq76kLLZzHElzdBTZA6/Ar+3PwdJH4WSqz3dh2H7V1qHXDkJ73v/gDp13oyA7ein0l0dFK8BJWkhSN6gW7yzaFAj03OSfZ0aRNKGKTTeRsobubJezUasdYZ1sdqWMgBo0XkT8kfsor+fS9mS/mFcUygSRejwY30Tnm6itPffHC/4gRNmQ+35lzBX1x/QhPr4ppBpYaeA9113YqN7sn
 pOA5jAr6
 J/0XBF801lJ3J3srArJUZ2wmrAmITy4lAl2SgmMGwKSOrWAIuec/KYwl4nSo/y/o1mpj2BULFpURFg9D10jMH5a3BIFK+3HUei5wrbvi6CKeOtK9llGop0yQycTxazP+g6ADWogwfXf4tGCZzHy3Ptrbbw91Ug1RmsymzVoWtRlw4xl6vwYK/X9uJwOH0BJg9WVrutv3Ml7cCxtq5xLZuYLzumgZ6Cser7rYUHNHNgBYA5OSuqx/dKieb2nHXyNAij52lTy99pdstzgdMM+3kjy9UGRaQxy6VYPJQ9csH6jjC9Ys6j/0eoWJqM0MLzYXd+bikjDi6vwgvoh15OzAUdgiPfxdlgwOx3skpDyh3h1cXXMD6PMa4YxE3G8cjfZws317duE6ief1pffkTX6VIU30p3f3s0UzgflAEvfyqqIq9ITbn7gexN5C7G93paXZnDPJTKAgp/ipYERVGMCADa2vChirjg9yEPCI8rpOXnUYEehvjslk+rY8c6Y931q+K17sUgVMcWlj8pL6OGY9JKXxTdrLsJeIHS9CbKg4PWi0TvtNr7Xo7D+p/5tk580GIBiUQyFZefr8iH4iiDBkakw4PiJqXtHoC3N9s2gIB0a5jA4oGv6aTXFkMbqK26O1ncBntQFdy4ap0vPkCArGZTlTyXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

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

Tested in X86-64 VM with HMM test device, passing the selftests.
For performance, the migrate throughput tests from the selftests
show similar numbers (within error margin) as unmodified kernel.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes since v13:
  - rebased on v7.3-rc
  - fix compile error in !CONFIG_MMU_NOTIFIER kernel configs
  - added patch 12/12 for Documentation/mm/hmm updates
  - document the semantics of new flags for migrate_vma_setup()
  - fix error handling after migrate_vma_split_folio() failure
  - comment and style fixes

Link to v13: https://lore.kernel.org/linux-mm/20260804042631.2175585-1-mpenttil@redhat.com/

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

Mika Penttilä (12):
  mm/Kconfig: changes for migrate on fault for device pages
  mm: add helper to convert HMM pfn to migrate pfn
  mm/hmm: preparations for HMM to participate in migration
  mm/hmm: do the plumbing for HMM to participate in migration
  mm/hmm: implement folio split for migrate needs in HMM pagewalk
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
 lib/test_hmm.c                         | 132 +++-
 lib/test_hmm_uapi.h                    |  21 +-
 mm/Kconfig                             |   1 +
 mm/hmm.c                               | 977 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 617 +++-------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 9 files changed, 1341 insertions(+), 609 deletions(-)

drm-tip
base-commit: dfe5a8188de9aaddd4e46b0f2410d0bccd5c1c04
-- 
2.55.0


