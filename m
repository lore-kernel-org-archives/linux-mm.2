Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8270606A322
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Wph1eiP8
Received: by kanga.kvack.org (Postfix)
	id CB3F56B0610; Wed, 21 Oct 2026 02:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64116B0612; Wed, 21 Oct 2026 02:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2BE26B0613; Wed, 21 Oct 2026 02:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89D9F6B0610
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECD4AC01BE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:21 +0000 (UTC)
X-FDA: 85345596042.12.FD7FC57
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8CF5040002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wph1eiP8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fkDeNsEKQP2qp4cRwqP/yX9WA/UKES9gmaTfQ1sp/cg=;
	b=oHsLIGtX53WDSMzknA76b3HDvAsTMEb2VPtEm7IXJFFcaKXdjFuTc7KDhYL8o9q7XGalf3
	Gw19a/X14r/Q7m4u0uQ3QMMXRv60i5XP4YFxR+bjkRwBhcdYJ+sXo43lWQWvXQdyoSUCOo
	1BALJTMdVO6YsvEWJJIETC754jRXZ20=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wph1eiP8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562719;
	b=JBd9vQmopW2cruZpTbAV0ZoUcPhLLMV5woLe5aLpc0xF1cg5gObEh7CYtrvXWs8BnbK8mu
	WnufEQaFeydpANOccQ4GWMXK5gxinvGmtr46kjolBUd2COVTDjdpvpdcyG3bwOFJqp9Kaf
	JKX2quLrYIAb5LNrrIL9sHK3HWK18EM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fkDeNsEKQP2qp4cRwqP/yX9WA/UKES9gmaTfQ1sp/cg=;
	b=Wph1eiP8k0XYWwnz2YBxvQtcozRLaxEwSlU2KlSy5PmPZPVNcUHfrUVNNNEGM2XJORF7OH
	beiY/vhQpR7Z+8EP5CpcVmr72HG3UpVIVlOh8Pg4Aad2N60ExqfE7ArUGr6hsYh6w0VZfc
	qLjXKPqa+xo2MfbVgUcmqAG4ArR6DLo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-TQ4F7v-cMiOfoiV8owJFbQ-1; Wed, 21 Oct 2026 02:05:17 -0400
X-MC-Unique: TQ4F7v-cMiOfoiV8owJFbQ-1
X-Mimecast-MFC-AGG-ID: TQ4F7v-cMiOfoiV8owJFbQ_1792562716
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48af4046a3bso262999f8f.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562716; x=1793167516;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fkDeNsEKQP2qp4cRwqP/yX9WA/UKES9gmaTfQ1sp/cg=;
        b=wlMihdJ7bVt8CA/ODh/1la7N2UeQUaQ9QEsy0zMwfYBZv9i0xNfGHHkl8WzTVwos+D
         yClboDWuKdsPetCLvTZ6BEGu0Ueh3M8MK2zr4VFqsFUkmSYFKMtZvuwBExB5mwAJeeaP
         JHobFDfqVlSEXRiPqeYaIGj2Q5+H4Cz/HlliyfQWhAU8xSDHxE1I9IfQKp/qtGWNlsVK
         FI+hEXA5IJRW9RehLpefn2hCZ2OLTwgQBNX/iU57KINVOCrH9SbZHke96NEkJLOu+fwr
         k9YqQTuRnE4zprhaeJ83Bdc9TaFUVG+ahfY6lR8JG1N6OqY3tJWEcRWa/EkY3Q8FKKx8
         j3RQ==
X-Gm-Message-State: AFq9FYL93ERIBXH49/6mUGHgj2TtJIOOc1HyoVX0Sy24OuElepyYCUY9
	gqqJ7WUPOlFCxrWQKjL6hCYK15BE7VH2CHfnPghVJM6HrfLYVg1R5DK5oY9NtGvH09UGAN6tjQm
	VsuSiCLFIcqOWJI8g1+NlFp3qjwvIqn1cUZjxJGM22OTMTXywt+HxFaRF2yCO5By+wFnOy93qCz
	oNj4NVlEXiJ+yfY+jMb0pRKfkWWDgaCN+VM98xog==
X-Gm-Gg: AYBFou0ZYi/RKRqzM0VvVBk3PaPDn0nWpOz/yXT5hpGewoBFae8WSuCiPh2vpAHRh1+
	ACoQjaUpTVxLCSUSZ+nHfGMNcyxslZijOyDnZOtQ5mjSMFOZsgQ89S6rG+lpzQBHEm2jJ4ottPD
	RnFMCZSFlZoSoGmF1gdPf2Ray17whjtwxYFLruYE3IAZMDPCPkW1Mmt9Rdx0Y7TpLLcJc4h7zz8
	/EqoM6WwwITsf8k7t10Bv7qd7rORcwUltknW2q4KKTrXjsc8wDh/mQyFj/slx/xNQ7QRiCg1iXs
	1VpY7mVC1VvtgsuzG0GqUbb0wBNWmyqEUR8DDsCDHXPvlujIPC7Bv+P9lAJbN3MGvF72qJ6cdpU
	4YJDpAauJfEiJy3k4TkdJ46SsonQbri11ptWy
X-Received: by 2002:a05:6000:46cc:b0:48e:1b11:7ee5 with SMTP id ffacd0b85a97d-48e264a1fdfmr1118341f8f.11.1792562716080;
        Tue, 20 Oct 2026 23:05:16 -0700 (PDT)
X-Received: by 2002:a05:6000:46cc:b0:48e:1b11:7ee5 with SMTP id ffacd0b85a97d-48e264a1fdfmr1118280f8f.11.1792562715531;
        Tue, 20 Oct 2026 23:05:15 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:14 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 00/12] migrate on fault for device pages
Date: Wed, 21 Oct 2026 09:04:54 +0300
Message-ID: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V941sd2-VCtNYzPyAyUBcTnbxngw7Ik8in3VJ3Q_zbE_1792562716
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CF5040002
X-Stat-Signature: frzp35w7hfii4uyobuqnzsya3go5aogf
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562719-848772
X-HE-Meta: U2FsdGVkX1/LJ7zEUwh7JJ/7HssXJ6ixt8uMrMhFrpXvewwf8pZ0bBsX4EYZ3AslvYbT0ynKBnMivHRcdNy5xHfT6C3S4D0IKGC0Yn6cEegVlSW3jLix98cly/uToPmjILCv+J62WdhGpfdK5mGtChpFKi5iM6SeYZs4Jn3TL9FoDvXfP3BCVeQ4dE0qcYhHPO7hK5wFjSO792o0k5JdwPxZBQGztMJJ+ebAz4dwiZ1Bfu8zLNBmCTsbrwezlKAwjdNZpjwV2FoV4s9DKYgjFtXZults9KD/zb+yL9BiAMTqKxnD4Cd+XPmjHxz7Ay933eBK5ZLyEZMPCflyBBM813GHgA2LZEXJNTO3vmCTCLZaTtb/iKKtBq6L9X9QiFaKnoO1JgeFuZe0eOJy/fVn8+U/DeaVBqhjC1sm/Lqp38GFIXvJVytuxNo4hcg7zs2cNNf30L1WL9jsqBvvMHhLioAs1eHibFR8VFrnUCjPRyxhTYubDE45nWyO+ieGdEakdZjwyjxYLgcbjcLxqCN76ge/XFCBO43HTpWxMgoQWxCYimjPSWFPwT+ILV308nAYuzHtG5QxD6fL6g/tgLEy2Xs6cNBbCu1OQ/JlFAp5fmjdNybVkTGFPcCDKSlFR40yHdZwXaW6WOw/H3t7F/ecwKu/RZ5YXmWzjqp6jBacpxN0oJG+COG0J9oULapvicHroQWxV/dd+5zQcyJej5535A/7OaX7VpN5FIxYyYI/5x+YaSvcFNiP8P/guvm/VeTVtBl0/9dB4zSx6Ol/LbzJJFpyfjiPK3kAaXOeiVfoe37PTiydWw/D6aLzxg0C8OkNHeqpKxGohY9vMLJs7Ozvbah6Bo1A5AnhsneIliL1gI/8A2GK6hbrQubNLvbw+ObkD8iIqD9y2Rt+IX+3eaJ4UT7cetiI3ZT7CBj9C0v7DSk2yf0xwOje0Y8mDgh3tsj8tdUEU8ryutvGrTWDYnJ
 58UDC2xm
 bniUrWKN0MN3Y7Qw4v/1XL8UxE+sVn8/89fzrYal9DjK/Zbpgh9lE1iDTUEDCAMzF7rl+1bBA2EuHnV/SjSGPtIdUWriY5/99KkPN5pHx/lSTc1Go5gcXcUqHVGC5c2ks16ZgojjtPmHS9XUWnoWj46O/AgF3leqLpH7zHLAXImHqqQ0PP0mRrMHO1HvcESoAxou2QDZvRNbnwLlzKeK5jzenAq9LmgmEAfsmmvPBLaEmpJCq9ZXLPGwSIhCDRY/4kMQw2Fasv0tThRQmvuOllfsGqv8g0hBcVFYIEvtA2ycq5qBBcqTwRaDuNwGYP1B9dRmqKmW0MrGAxMCrvBscybBpMoBtNWtVyz+IIldhDlY1VspWCgowG7H5BTomYlC1cwodaLUu9EQ1dXLLA614HDbjw86CFdmbh/zr7yPfa11MnW4HZvhBqfT3V/mMiVwf4KEAIbA7dYFUYfbZ1sKkN2ub1QZcRai3Ms0s2EyVH6OBZTUAElwyexjV0ipZMx7uCTaB2prPF+171PDF335p3QQ+UlJBbUInaERerXbKtgsYru/eNCRmqBuBJ5uBA5EbNCMUGd9CEZZWeb9iL3LhxJeDYYgYsByy+j8sKsA7kAdgaSsKOSjBSlGHMi2+yJtNPDkjEqp9aAFoNn1Spxm3Eaotar4z/KUjUMa5ZTX8W6EfDh4jitR9mxkFUz/gBNxxi3N4VC27YrOE1OdKHgzKbZq3DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

This series avoids the problems in current collecting implementation,
where racing MADV_DONTNEED could make the collecting arrays overflow.
This is achieved mainly by having a rollback mechanism and
populating the collecting array as the last step.

Tested in X86-64 VM with HMM test device, passing the selftests.
The migrate throughput tests from the selftests show similar numbers
(within error margin) as an unmodified kernel, verifying not
regressing with current workloads.

For nouveau migrate-on-fault test harness was : Fedora 44,
Mesa Rusticl, and a fine-grained-system-SVM OpenCL program.
Nouveau SVM is opt-in via Mesa. The OpenCL program passes a plain
malloc pointer (64 pages, array of integers) to the GPU. Increments
each element on GPU, and verifies on the CPU the result. So it drives
both directions of migration. With svm_migrate_on_fault=1, no
migration at bind happens so it's full lazy. The GPU used in testing
was Pascal generation GP102 (selected based on what nouveau
supports for SVM).

Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes in v16:
  - rebased to 7.3.0 (drm-tip)
  - addressed sashiko's concerns
  - added patch 12 - drm/nouveau/svm: add support for migrate on fault

Sashiko's concerns :
https://sashiko.dev/#/patchset/20260924065313.899730-1-mpenttil%40redhat.com

patch 01 mm/Kconfig: changes for migrate on fault for device pages
  Q  "Does selecting HMM_MIRROR under DEVICE_MIGRATION require an explicit
  dependency on MMU?"  
  A   A DEVICE_MIGRATION is def_bool MIGRATION && ZONE_DEVICE,  and MIGRATION depends on MMU,
  which HMM_MIRROR also depends on. DEVICE_MIGRATION is not user selectable, and nothing
  selects it explicitly now. If some config would select it in the future, it should have MMU.

patch 03 mm/hmm: preparations for HMM to participate in migration
  Q  "This is not a bug, but could we add MIGRATE_VMA_SELECT_NONE to this enum
  under CONFIG_MIGRATION?"
  A  Yes, added.

patch 05 mm/hmm: migrate collection in HMM pagewalk - pte level
  Q  "Can this cause a livelock when splitting the folio?"
  A  the ref is taken under ptl before dropping it (no UAF), and the split either succeeds
  (progress) or fails -> HMM_PFN_ERROR + return 0 (termination). No unbounded retry,
  no livelock. The -EAGAIN -> goto again path only re-walks when state actually changed.
  Q  "Does this code operate on uninitialized folio metadata if a driver maps an
  uninitialized compound page to userspace?"
  A  The folio is either from vm_normal_page(), or a device private/coherent page
  and properly initialized so no.
  Q "Can a transient split failure result in valid pages being falsely marked as
  inaccessible?"
  A  a split failure reports HMM_PFN_ERROR for that walk only; the consumer can re-fault
  and a later split can succeed. The page isn't lost or permanently marked.

patch 06 mm/hmm: migrate collection in HMM pagewalk - pmd level
  Q "Can this lead to a use-after-free on an unlocked tail page?"
  A  For that branch, it has to be fault folio. fault_page (of fault folio)
  is always device-private -> the tail new_fault_folio is a ZONE_DEVICE
  page, which reclaim never scans. So not possible.

patch 08 mm/hmm: implement rollback for device page migration in HMM pagewalk
  Q "Will hmm_pfn_rollback_collected() destroy the user's per-PFN request flags?"
  A migration is entirely driven by default_flags, and (HMM_PFN_VALID|HMM_PFN_MIGRATE)
  is used as a sentinel for already pinned and migrate collected pfns. The sentinel
  is safe to be erased from per pfn flags.
  Q "Can this regression lead to memory corruption via an uninitialized PFN
  unlock/put?"
  A  "rollback only unlocks/puts entries carrying the (HMM_PFN_VALID|HMM_PFN_MIGRATE) sentinel
  ,i.e. ones actually collected (locked+ref'd), so no uninitialized pfn is ever unlocked or put
  Q "Is there an infinite loop in hmm_range_fault_locked() when a THP split fails?"
  A yes, fixed in v16. A split failure now fills HMM_PFN_ERROR and returns 0 instead of -EBUSY
  
patch 10 lib/test_hmm: add a new testcase for the migrate on fault
  Q "Will skipping the device page table update here create an inconsistent state
  that migrate_vma_finalize() permanently commits? (in case parallel unmap)"
  A Concurrent unmap is fine. In that case migrate_vma_finalize() frees dst pages,
  and retry migrates on next round. So no ping-pong, it is self-healing.

Link to v15: https://lore.kernel.org/linux-mm/20260924065313.899730-1-mpenttil@redhat.com/

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
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>

Mika Penttilä (12):
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
  drm/nouveau/svm: add support for migrate on fault

 Documentation/mm/hmm.rst               |  39 +
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 281 +++++++-
 drivers/gpu/drm/nouveau/nouveau_dmem.h |  12 +
 drivers/gpu/drm/nouveau/nouveau_svm.c  | 141 ++--
 drivers/gpu/drm/nouveau/nouveau_svm.h  |   5 +
 include/linux/hmm.h                    |  51 +-
 include/linux/migrate.h                |  59 +-
 lib/test_hmm.c                         | 174 ++++-
 lib/test_hmm_uapi.h                    |  21 +-
 mm/Kconfig                             |   1 +
 mm/hmm.c                               | 959 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 617 +++-------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 13 files changed, 1740 insertions(+), 674 deletions(-)

drm-tip
base-commit: b0311e0de50840c3f35aafa2e95c14bf38f4a767
-- 
2.55.0


