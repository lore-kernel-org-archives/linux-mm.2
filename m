Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B286FF493A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB196B0092; Mon, 30 Mar 2026 00:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BFE6B0095; Mon, 30 Mar 2026 00:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A9D6B0096; Mon, 30 Mar 2026 00:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 075966B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:30:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97CE48C2F1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:40 +0000 (UTC)
X-FDA: 84601453440.02.A477A8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 716FE20003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZZ4L/m46";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774845038; a=rsa-sha256;
	cv=none;
	b=Pa02how2JHyTdihzssPOOXhC3TekVtPe8J5HJwqdM6T/TI3kp/Dw/qn5IZaPIE978B9JNd
	oCJ7ymkF0u9Eg14C/sD0XDwzG1ZIu+IgcfBWKAYnlbL0uG+Y/LhSpxTy9e8Fdjowd6VseW
	RYq2qr8BRzR3nObeTUE7cpvvRl3m0UU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZZ4L/m46";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BFa0uOm6NkLHVmG4oyhTKy9ydelbQancYIK5yzqzRE0=;
	b=57Pz4trsSlYdeS7qDhdNkV2bLuBsPCk64LX6KYOBPMbD94Mp+huS10a9zvZaj1/SbRi5Ot
	GAhpyhl7Jew3AfaoXIirQNowNbDk72QarSu4RgmnKi4bry0yiN0mve0Rr6gvT5qVRVR5tT
	nqHqrmbLNNv8qPwDqqP9XqIiSmHlVoU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774845037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BFa0uOm6NkLHVmG4oyhTKy9ydelbQancYIK5yzqzRE0=;
	b=ZZ4L/m46FaWtnPt9y6I70XZq62LjD4xGAJuXxUH9w4gavCuZy3ShtjpRNq9LH7WgHfuFvg
	6kRFj7rEuYB2dnW94LoDdu98sANpb+BfwI5LK2hGPOWIeSOrEnGMwGZcbPMbfcxrWNPjyS
	lngyMgvi6RMlneC0MS9nFikmk3fhXwQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-c7tbmnTtNnaz-2fkQ3pVbA-1; Mon, 30 Mar 2026 00:30:36 -0400
X-MC-Unique: c7tbmnTtNnaz-2fkQ3pVbA-1
X-Mimecast-MFC-AGG-ID: c7tbmnTtNnaz-2fkQ3pVbA_1774845034
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38a33a542bbso22831531fa.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845034; x=1775449834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFa0uOm6NkLHVmG4oyhTKy9ydelbQancYIK5yzqzRE0=;
        b=Wxd/aR/aB5IE6ePE8/VVTMqk+q3BSyG7F9EZPkqFIY9IDVyOpHHTe1IOrxkfEOUK+5
         nHo7D5wjif3L2N8sPG8NxS9BnZPcYL0GC+PRRXZaZyK4vjLmW7OpdYz0xHEtAnMbFoO2
         dm/P1jV7jN5eLzcbBEDvhS49yImsDXRffsmr5o8P6fcEAB359+xTq2s+EvyrLlzO7nYQ
         H0KbAgTbyBy3jryK9YSXdGL6j6BgM4DctvwLlOE4yXM29CIXr/5x8z7SoAkP3MbjI5j7
         1pUvWV2sSot74vSxd/aF8OuUzCjhxeuLxjfBV6GbhhlrKWLKsynlz0F/GvQ9AYMlyyl4
         QmTw==
X-Gm-Message-State: AOJu0Yx24YTldmS3foPeXp1Nxc7WFb+sc+0wKiHEYdsFztS6IlB36QIJ
	hd9dYcLFHcw1xQEUc00c0QToaa3HtQmN2BhXUEmuQOa67iTbpNk5XjpZOR0a95untuohMt/ZIo7
	SEYR7nX+5CRYBlAwMJvuKufJJzt1abOTTac6A4hzJA+G2PbThyMvnmys12d6fkq+Upf55AwCddb
	uEgdBrjd7mMLNICSHmYPG/Vnpxq/YXE0JfB8s=
X-Gm-Gg: ATEYQzz+2U0YczqsbBWsQEdKZrF4N/SyoGHHUxIVjhOXqRxqlVyZ1rSJTlWtI3Kw1w9
	vt30sj9GPvK4KENZitY4b4pPTuGXtxe1KkqNa1qrRj+R9yM0bknf3AOhiUKfRy6i6paAfF+G49p
	DoM0iN67dmEzzZZu4XATiqHl/6XVzF0zElJZFs6vTSAKfAJEdcH4XECmRMtW5CHC7JPC7Uarv63
	8jinmE1LoLLc/EfgwzVZyMu+rT+kO3bAehYwNgFzOgGpQQRw2RMD6afjsefi6AJC5k+97LmO3Kx
	l9pi4kiALSCz93HRe89yCm4SnHrHiUwmL8XVd/kGFzfdd/ReXJiEvmaU4Bo3sAV2AytUj/7GzGh
	H0EZNgKkiCPPVJbi5zK/hE7dYFChe+eEbEXtT
X-Received: by 2002:a05:651c:20cc:10b0:387:e49:cd1d with SMTP id 38308e7fff4ca-38c73248256mr23886001fa.15.1774845033834;
        Sun, 29 Mar 2026 21:30:33 -0700 (PDT)
X-Received: by 2002:a05:651c:20cc:10b0:387:e49:cd1d with SMTP id 38308e7fff4ca-38c73248256mr23885891fa.15.1774845033211;
        Sun, 29 Mar 2026 21:30:33 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c83729522sm12470671fa.14.2026.03.29.21.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:30:32 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
Subject: [PATCH v7 0/6] Migrate on fault for device pages
Date: Mon, 30 Mar 2026 07:30:11 +0300
Message-ID: <20260330043017.251808-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZExuoOG_7ktbHs8qclirhycbBTpXm-k76yJAj3_ahmc_1774845034
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j6fkwap8rxjw3spijwwh4i3xtdwd1gu9
X-Rspamd-Queue-Id: 716FE20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774845038-725493
X-HE-Meta: U2FsdGVkX18xLBhNCoCiKd/89bmLJoCpfS7r8H97nKcRhXjtuTkO3fSQ8p+tfY6CnGQmRau3D1c8nNfvfJNueJCt2jySCWEdMV5x+PlTgsV4ejpjZHk3WXbopcREe+CXdDeFFwpFLlE0UCv5yhCossgu5rrGkJCg/PgKWV21/MXVnNjRaAt1I1Yo8gkqx3Qt0NCQv22E3nLHAc2Pal324e5B7AiNJj/AIl8g9VKsySldvA2klGjf6Gd9G9jveKIatXBEIXrhfxePSB7kzWU3m0njq4cMh5Q2T4vP9+1IGrDKfdYHnjjFxjNKXZdsZ7/4i7dNUnDTstiA/gQ/XMke9lFUgXQkabQl3nPeYSMssqZD3Umrwz3vQWj6gA4nknPtPwzFw+oH6sGgDJb3fPJlhV2OPb8Q6fabMOK54RfFOs+ZZL0Qz2b8B02Bs5RGUmpj3VUWI/UT6bSRRpBrXvwmGECw/XX9eeB2vEm8590sSBWdOyMKbS5pwI4S8oXAvqYVg+MURXEs7DyZbbSE+pjQzib4RG6eOLi0s2YSFZeRXk957OiKAKm3/ZiWuFT4BhNfrUWxmw6Jx21OdG1LRurrGkt7cNLZwubdf/Mm0YZjobkSl67abJrqoo9f56pYCdZEGbp27fYuu+24ZTLh9ordS8NnjFzm3SnGTMvqzozVZPCyTIHX8O49AF+MbMsLHyr4xEqaWKue+WtA3cxblDZgMrtOi+AcpvNDj/60+cSUC4zqb15FvnPCfOiyGpbL038UrVacQhm7R3hKmaUPdqBEByAk2K4CES2D0APHv3KOM/F6Tm+Vgl6dxkKoUha9IVvEeFKlAgmas/iYP4GdW8SHeIGVTjTekpPu1612Wgi19GHlPbSEC4US6MsFViEfienVpRVU2hsUVtOCTybbKgMu27msXyzfKnkHKsFPyYuJjZgCPyx93UJbYSDKbdvMTFRcr467RquyQWqzoG1Q/mL
 GZxisW0g
 odMO9PyGhmsQB2CW1scL0qyDJN2a8vR9vSuJTVxlrgI73tesskzj1ywEjbGp4rdpS2i0w34U1NJQ0/B4Zg+ORjk9UKBHBUdYrkQfcm7AN3NUFcbc2GzaeUCeD7IU2sPVSqO8Ur3/L4FE8gr42h0eIgZzj/Qn+X46GFt30nZnxL/oyF68gGBkOlJ5Iryx2FUsu1Uatnk34VHwMlguAYLUAawkNhwS7qQZOjCWztCfgMfQTms3iFfNerM96OCe7CWO1a39M300DPqaZPHOUGXuIk/fU9raBuJh/+/MAf6dSTTVt5/KNavA1gKTwSAYqKjU/9mhmXsI5DykcHPG7sAm7nYlHiWu/TP5DN8nDuhrlx3XL7xbF1Eqipow2ufulQ/I5+Vv4jPa9PT6abf7RqseccYFwrSTRINNtAbMedevlHbEuXg2HlNcCzenagEUWHU0Q9IW9
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

Changes v6-v7
  - rebase on 7.0.0-rc6
  - added documentation and comments
  - denote to be migrated zero page as HMM_PFN_MIGRATE alone
  - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
  - picked up Acked-By from David for patch 1
  
Changes v5-v6
  - rebase on 7.0.0-rc4
  - use range based TLB flushing while unmapping ptes
  - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
    migrate paths
  - always infer migration flags from migrate->flags only

Changes v4-v5
  - rebase on 6.19
  - fixed David's email address
  - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
  - refactored into smaller commits
  - added more comments to code

Changes v3-v4:
  - rebase on 6.19-rc8
  - fixed issues found by kernel test robot with random configs
  - fixed typos

Changes v2-v3:
  - rebase on 6.19-rc7
  - fixed issues found by kernel test robot
  - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
  - fixes to lock handling (pmd/pte) on errors
  - added assertions for pmd/pte lock states
  - other issues discovered by Matthew, thanks!

Changes v1-v2:
  - rebase on 6.19-rc6
  - fixed issues found by kernel test robot
  - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
    parts if migrating
  - other issues discovered by Matthew, thanks!

Changes RFC-v1:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
  - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
  - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
  - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
  - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/

Mika Penttilä (6):
  mm:/Kconfig changes for migrate on fault for device pages
  mm: Add helper to convert HMM pfn to migrate pfn
  mm/hmm: do the plumbing for HMM to participate in migration
  mm: setup device page migration in HMM pagewalk
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*()

 include/linux/hmm.h                    |  18 +-
 include/linux/migrate.h                |  25 +-
 lib/test_hmm.c                         | 101 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 821 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 591 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1053 insertions(+), 578 deletions(-)


base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.50.0


