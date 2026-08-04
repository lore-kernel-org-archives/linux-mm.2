Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC6DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0A46B0088; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C746B0092; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863CE6B0093; Tue,  4 Aug 2026 00:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEA4A6B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:26:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA441A08CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:26:55 +0000 (UTC)
X-FDA: 85062301590.28.0873D4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7DD24180008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:26:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DJVRRDsC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NA4GkWrTTacC5SlKbIYSTdyMjm/Le+vBS1p2iRoL4e4=;
	b=d1y0fB7miIEJeSbYbnODpnwR0sY9QPzOrDkkgmwB0MCSLBNQW/+wO5MlZepL3fjJFtsrJ2
	r0TQpMmhpMOn438DuOEtrFxQdfcwbMA1RuCTTuQ1qFQQOQwcz4MfYstStCDKdBeJQQaKFE
	Mzt/9k+BEDGqcE+YtO/ObvIucP6Owi4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DJVRRDsC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817613;
	b=t1G428uVwoOZLqKPijlLWCwfskoSAHt5O6g6scTrcC6VVia1wfsSjpB6ow5HOjGRpskOBx
	xn4sOQbZr0Lqfhpl4dGa2UC/6ax/8sVWTePGs2fqfdM0y8z182xIL8uhg/J7riAwnL8rl0
	XDK1KF4wOZKlkJ0Wbl32d1/EjY0zIt4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NA4GkWrTTacC5SlKbIYSTdyMjm/Le+vBS1p2iRoL4e4=;
	b=DJVRRDsC8g7x/eGLKJ28dMuUTIUtLj0Uynoab7GFw5/PW77GXnsIiegJ7ODlHUpsWt8Xz1
	LHHXA/rAwGMWEHrOpU0t90t94OqRthIStVlNCb+EGbmeQlBkLqZyIo1YHkz7bl8xTXTs7Y
	Tfqzhq6Mre1hetXDARhQ5odjfvl0Drg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-pk3V4o5VMxejCi9ZK137Gw-1; Tue, 04 Aug 2026 00:26:46 -0400
X-MC-Unique: pk3V4o5VMxejCi9ZK137Gw-1
X-Mimecast-MFC-AGG-ID: pk3V4o5VMxejCi9ZK137Gw_1785817605
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aebb33d6b8so2747780e87.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:26:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817605; x=1786422405;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NA4GkWrTTacC5SlKbIYSTdyMjm/Le+vBS1p2iRoL4e4=;
        b=f5mRvY/bG1p3efwQLRaoE5fJa2bGlcml+zyh8Zvt+Y9wwjF97722LGKo6BpLN2dn8b
         z1LYQOgJ+CgSUUnBdqy73t29HZBjA5/7BJQgAwFa8yMsS0RqDVg3qMU03viTRMD4jjYJ
         gOdXVxeRcwrGH8jOT1y2VCRz3OXpOZaKcjWS47k2+CbLXoqt3zTCn9z2X5CntJTHz26T
         QHyuH497QjI3gvHzl/OzW0ymZxGys+AJRK+JQVwA+Z5kn6XQr3ch+BGaSso04Grck9za
         cM2POBd95uiidh026NoCyJzYpT5/1l008Me2tUMyxTh8MNOC5znLm9nCK7wbGKvORyWY
         O5Dg==
X-Gm-Message-State: AOJu0YzqtTBTjP3DEwQVc01HNjmgRdS9Lm8W9skVE1nqpCUDj7y8IfUe
	IhTNvYEjS3/I3/jOxX2LCzUBAQxDfKysrpRG/YT6o+KA2sVU/TJR3SAIUv9CtZ8rOSmixhmQJqu
	tS9dYejo5Z86WOXL/tERzxstbySzIHmJWabLErIplwWljfEl3wD90S9iaqQK7NUVVS4jsJVd+7+
	IkNcQFfLgBn1DkgC15pt5rA+WU6CSRe6irOW9HoQ==
X-Gm-Gg: AR+sD117/bqTZqcLU6QPJvvPDrb9NdKn6sHZXsg35AmR8TFtqeTmlwG/NussNCzdbFg
	wK+k4AO47Xrp4lSDI4kfGYRyejQ5r0To3PtLNxVBSQFAz1fwKp1bBFU5Gek1SHmfT3T/sQOYvcb
	zlAUFhl7uXcH9cnjEaUA12cDUX1ZnoGfxwmvChMgA8GYYwVbIvhF5qBiKSueAnLSnU9Xam5LoWh
	hEplVjwmPvsKhWKovv6pBvpIb4oRwoeYGahk4NPv2IvTkFdsh0hkxwh/DwsQ4179t2Wbt20uTD+
	+gtr0bw1YHVpSP4uikgfV2uI0AorB4oJCEz3IV00XOuIbU1gWfjuA17AU/NTdROJjliZPY2rJzK
	DPLWCgzZKEj0wx9lo
X-Received: by 2002:a05:6512:31d4:b0:5b2:ebd0:8d10 with SMTP id 2adb3069b0e04-5b2ebd08e4bmr1109600e87.42.1785817604931;
        Mon, 03 Aug 2026 21:26:44 -0700 (PDT)
X-Received: by 2002:a05:6512:31d4:b0:5b2:ebd0:8d10 with SMTP id 2adb3069b0e04-5b2ebd08e4bmr1109576e87.42.1785817604342;
        Mon, 03 Aug 2026 21:26:44 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:26:42 -0700 (PDT)
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
Subject: [PATCH v13 00/11] migrate on fault for device pages
Date: Tue,  4 Aug 2026 07:26:20 +0300
Message-ID: <20260804042631.2175585-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: d9ErVTABdfXA67QBfSqh1FoJxsEi8RmelVpjTa-u7t8_1785817605
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6tkh8pgwezjr9m89enqnwfrb7561kt4n
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7DD24180008
X-Rspam-User: 
X-HE-Tag: 1785817613-779665
X-HE-Meta: U2FsdGVkX19EcDmMaGVonO9EkzlxQJdIXniVmyK1aLZ8X6azrBYW6ubFdYSeTl4DDjRAdlCGCb9Wma1bi/AVvaLGjlBhkODG9aM+IxqH/fBdc6mWKFIExFqJ7XTDE1/8G4mIYKkvkZWtqf2u7kJBAKXq/tLkbQf2lIjhmnwkzR7h6d2gv0CAw9X7rklS3UkroDearmAKrBSkOTfjX9Q+Xpkaf0hDN1VyWL1i1Jj2Wdo5hKwrIRS/1nS8U3TMBReJYR+ZVk7cO9zK9s57G2Locymk6u511d+Nq+KcdQ5cBPsuR9Q4/15czJfW49rBOKWhkZh3h5+X8+PuKzz4dxmR5NwW9diY9kY2/pY9QqzWCJxrzA57g2lPe8+ZgNXfnNRYKmv+JFPth9+2DardmXAg7oRDQKUaSc1E6lefy5RYrYUKqgpRLe54cGJqSyEePKU+EawoTcHG/0eUXq+RTVz0ORKoqyfcxDOEUhPqdNcGI7WAuShKJcpaFdG+ql78u0ywZgCqgeLl8G0PP183dCdWvxjL098hZNaUOKyJ8Urg6kfO6udK+mMu/my/4FZ8rmNVHrXMUp2jCIz72mRH4EjifjLGcfH6p2nMqn+ncmkfnTCIzTCHO1y07wKMCyt2hQC+DaY91PEoYfYypoLbQClMg0othqSA/0/7eS5mYxCm0ogHL17uF+la3hjAB5JzbqLxry09Bh8j9wMx6LxXU6CeP8fcPw4moysrPeLWOy50cQOLfojS2vdhnZ04enQviH5lq0GYzGH5b1nbMX3e3U0lYEWy3s2oGtpplT3ecTqe7K5jxiQsGloG1miQa4hY9BKVLskmV/lBXmjHVo29svSoWOYDCEfAb+YBBHMzypUIFv4+qgjmvUupNzE3gJxYcZosZ43FVDcPk6I04VevmQBntpjx8DtPMFkKOGmjoVicpxqk4ISno0nOsEdSsix+ts+MFguqb1khKDrdQbA/pGk
 EomCyt35
 DqmTFEX28zpiKTPEBcfDZhw1obwPKl1F2QBs8UaHuwDkO+93asStfXFmj+LFlfmIxFqPaoEmyQ1s1BlV06YiVJNYSIZK7mlntX86lgbUCVpNK0jHnaGP2Zvhdgrr82DWQk1oeF0XA1kiHZMqn6d4sV0Z0pw9WnelaVZzo3jfkrvANtI3G0ug8G5L32YdXPiZw999sC0Y6xZRgJOQmgRSfHtG3IC/AEVk/C9XXGNlXi8LUz2KBJWBohU/YJ/rIJrAE+mwXevia+hpm36C4UZZKBYXHYyNCm16qz0JtqRktzSv/Gwkf98J10jH3byaXIqWNoRSziMeGmEZyqsrP5nFo6n63QXtUDL6rCh5pDRfz7lShLaZEK9EZZXmIQcBsNHmDn1zQwrnEECr5U7uJwNbTmAogruTAWurZvkpVAJzm2FtxtFko+PalJA7FuDFlbcKPHA+UlqnkuWDofJAHQ8IMowrq1EPnEQj6usoJvnww8wlKT+7R2hGGBoeGkNCnE6AaP5uN05ZHf8pTadocOSaT5PL/FLwDRbmEm60Wu5TN70kWUgmPZXoaVmhd3zOuRM0cEILMuiMztB4aKjcCwBbk0Arse3oJcLVX6FBNC/SK+YVM82+fzE/8KWvjR5oNIgIsPCJnRO/OMvYoawZEyxrIYSosfA==
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
Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

One extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

Tested in X86-64 VM with HMM test device, passing the selftests.
For performance, the migrate throughput tests from the selftests
show similar numbers (within error margin) as unmodified kernel.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes since v12:
  - fixed Lorenzo's mail address
  - made hmm_pfns_fill() check for PMD size region for hole migration
  - added lazy mmu mode for migrate
  - check pte_present() before flush_cache_page() an folio_mark_dirty()
  - allowed the normal migration path to specify write access (fault)
  - split and refactored the series more. Also reduced ifdeffery in hmm.c
    with static inline functions
  - handled rollback for cases where the page table has been cleared and/or
    replaced with something else like PMD leaf

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
  - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
  - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
  - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
  - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
  - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
  - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
  - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/
  - v10: https://lore.kernel.org/linux-mm/20260505184421.2324798-1-mpenttil@redhat.com/
  - v11: https://lore.kernel.org/linux-mm/20260525050830.100254-1-mpenttil@redhat.com/
  - v12: https://lore.kernel.org/linux-mm/20260525084524.139868-1-mpenttil@redhat.com/

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
  mm/hmm: implement folio split for migrate needs in HMM pagewalk
  mm/hmm: migrate collection in HMM pagewalk - pte level
  mm/hmm: migrate collection in HMM pagewalk - pmd level
  mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
  mm/hmm: implement rollback for device page migration in HMM pagewalk
  mm: enable device page migration from HMM pagewalk
  lib/test_hmm: add a new testcase for the migrate on fault

 include/linux/hmm.h                    |  41 +-
 include/linux/migrate.h                |  54 +-
 lib/test_hmm.c                         | 132 +++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 950 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 588 +++------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1260 insertions(+), 580 deletions(-)

drm-tip
base-commit: c2d24e2eda55d74743f0d99a98805bf0b596beef
-- 
2.55.0


