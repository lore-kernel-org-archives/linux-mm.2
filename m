Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8A20F3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A946B012C; Mon, 16 Mar 2026 02:24:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D986B012D; Mon, 16 Mar 2026 02:24:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF3F6B012E; Mon, 16 Mar 2026 02:24:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B958A6B012C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 663111A0C37
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:31 +0000 (UTC)
X-FDA: 84550937142.10.652A699
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4119E40005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEVIdu9u;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hrU28509ZSz5FGAd8GCuwk8eJ9M4lgoGSuBnbmBDczk=;
	b=Su38Zwi0/v+v19zVz6QaL35DDazYIqdR0hO9/PuHF1FFR06ktH6RpcRAZdLY/TpXagBEaI
	W+6rbwxx6/WRVtEPWwiP6bppCzeIYf56On4KlIerx8HGFvlY7ZAVvnNMEPpwKhjICVEQ9c
	+eRWDc/pHYe5j0dNcdEJIDAlr633ZB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642269; a=rsa-sha256;
	cv=none;
	b=fUPMJbR/MHRLZ24+yok/S2bgTnreNDQny5S6GoQlBxcQABzZZAwA99v411YbplmnH8Ikwc
	vqYDG/2+S8NE/AmiO/zkJHim6Ft+OgmsYpi52bh8LNIoSVR9xHbtuXS65EmjdMsLhha9cW
	CzldscrZPOkb44TcAG7+IvQj6R48TpA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WEVIdu9u;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hrU28509ZSz5FGAd8GCuwk8eJ9M4lgoGSuBnbmBDczk=;
	b=WEVIdu9uyWx9KoT/zjC0d68THluK0YfWsrO5A+xPfeN7kBdlmfue7rPhCTCPnGQhMAwZYl
	PUyH7gtIGF1xOXC3/pZJny7qFhfzv4vlKHxGGg+4svLwa4+DX+8G6KUCHlCMTlN4N8pm6Z
	JF8J1YunnTVB1k8OHk+lGSi2Q4soq8o=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-KC8KRAj-Ni-YTmHSNMM5GA-1; Mon, 16 Mar 2026 02:24:25 -0400
X-MC-Unique: KC8KRAj-Ni-YTmHSNMM5GA-1
X-Mimecast-MFC-AGG-ID: KC8KRAj-Ni-YTmHSNMM5GA_1773642264
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38a4bad9985so26842081fa.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642264; x=1774247064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrU28509ZSz5FGAd8GCuwk8eJ9M4lgoGSuBnbmBDczk=;
        b=ohhwGE1704HKjv3+UTRKMmSUBM4R7rP6xn1HrCksjVwH0xMgocWQNOH5qJe7S44yvr
         w0ZPkFZxKPEg9qaVzdhtpwJd9gTb7MNIaRJqnMWpq8zZf5G74MfLEwk6yJYMNjE6Wbtw
         ZE6246P7vH9jVuVhxPTJFb+cYFXc2Zl1gbKrL4tsWBjCALIS741kjPIiyperf138ARyn
         sTxuScWf6lsZo0CoL4ZDL/KRt/quZ+CrIJGQyN48pi6bJfSwxmE75XgRf2JMN1HICA6L
         3P8gZFuVc+5DUEcBUAS01p/TU5iOdiwMlJbOkwwe8Vjbun1nNli+g8MMsW9pza4eq9y3
         2uxw==
X-Gm-Message-State: AOJu0YwvaFBA7l+o8RRsG5ZueqA+nCKnHzIrcBSzqld6WxZPT63wgEDh
	z2mK6EHGARJb+XQApkWXgCfwVNiqXvzjmoCJHMe/QHfQ8BzaByLagrLF3mtyHe+/+9dFcLl9fL+
	0wijyUBuP/NoyOXW21pq02iza2bZ/ScTQEcZNRybDoUmeW1ZuO66vozCrAl88b64S55YINL2T98
	o7Oe3JFnsAEoIoJfz/khbIqmxZir+uACc7ynI=
X-Gm-Gg: ATEYQzzxahEdFL6vxGn3iNAadi4FdWLfmzu0w/8TTSWVGdqrCYV8pZA/BZ3NNGfPQyc
	AMWeQKd2teWpRhLOo3GSznM6L5P0bIktUSR1MirG9j1NfD2NlGseSoP1J78O69VZoI1VH1CGWdF
	9N0bFCdwbVmvEC9nlefEXlFMKEaKIswqv4hj2OH8e4bIIennN3ELkyIs7lEYyxDFBcrhza9G1K4
	q8bJ2MUkyhkKNskwIwcRPi6oV3Tdhb+/WjzZXLxyCxKX6SDatS1C29AGkikjgw6oBItu8XLPGRC
	HUGAjm5ze8Bbd7iRrGSGOSMaj5JV1qr3J3OML7JOP4mzpHJSYWWLuBOSzHiHyriuznXOoe/OVjI
	hyQc7C9YrIPF/Zv9/VExwT+aBSFX3RJNC1fys
X-Received: by 2002:ac2:4c55:0:b0:5a1:53a8:fe20 with SMTP id 2adb3069b0e04-5a16254f23amr3771371e87.8.1773642263601;
        Sun, 15 Mar 2026 23:24:23 -0700 (PDT)
X-Received: by 2002:ac2:4c55:0:b0:5a1:53a8:fe20 with SMTP id 2adb3069b0e04-5a16254f23amr3771358e87.8.1773642262993;
        Sun, 15 Mar 2026 23:24:22 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:22 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
Subject: [PATCH v6 0/6] Migrate on fault for device pages
Date: Mon, 16 Mar 2026 08:24:01 +0200
Message-ID: <20260316062407.3354636-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pA0DTlb035gXRslygdEVzL_U0B1sGiycX3IAU-kU1SI_1773642264
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4119E40005
X-Stat-Signature: g3humdsb3ztb9wunt5xgsn4zdoc61xhm
X-HE-Tag: 1773642269-346751
X-HE-Meta: U2FsdGVkX18YwBHVLQ42ciXMnLWW3wLUGW3aJLo7mAmz9MHutEu+353VfptayMREDqAXeDConjjsJksXQCiuOKmC+MjEK27KVmFGsU/K/mpgvLU1roYH7fYaUvtvPALp4FbXnfiywX16SiOvu9odb8mhAZMzXiYr9hkL100zN6yMq4ksRJWGxqJX9nmqr52rHmArdOUDvSSwPw3evbMuhSKZUPARlH8Ks3K676ZPUdtyenx9atkInReTJwkxEJiFNEN2R2hu1cUauHDTBIgGYtfKRbBfARLTb1jX9h0GY93omqu6ASda0vR7WA9rvBAa3kBuMuRlMV870NLoN5iJTCwkinK7pT+hVSKpHRz0drOSKeSmWGlCfb6zCYoiEgGdl0Yp3fckl67o599i5MSKaHRxNRF1d41u1ybyLKC7h9kLP/O3IgAA6cleG5cKGKGLS/oivNCqarRs8WpKCa2aRgQ8e8rCpkvgOTNFF8qKm/Yd/xK/1JjhU8t5pd30E3N7dWjM98WpiyGC4pB7rTNTANlZmTh/R9DtyE0oy+kqhaXHSTAgKGexMWQ6brJYH40gmFMSV1ExABbI5mIvjz3IBvTv9XYqtG3OeVQSEcwrZQPwnQPPACod1HKVN5ZPllxdbZigskba/K46y/AuTaRUE4NSHRMPCqtgJEzG18FTstjOm9mCIeOOb4f7bG++a3LgWH280mHqxp7rn2UdiE8XfY+5IVXZfxbqEYmNhMwe915FozgcNnSOT3PN0dN0T1YDQnhmWoroF90Bkp03XNLm0ri1Ff4Xnu0h7RhJIWzl/7EmGTLLmLnp0T2D4FOw8u/njhqr+1q/I9nbb3fQEY0lhHHsVnoqTvzQh8CZIEkC9vbNIucMHYbuLYJcT2haay3KlONvcnmcrT8QO0mdzlHC9MZauSShK1myb11mGQcOEN9E4EtO9rQrdZyqwjs6APXgzF50mWVr8Ag0SAVlgat
 xUwsFQKn
 LGsBmEmDcRR3Tl+o21Khze+UcuGitG/DerJm96CBcJv1t10QOYeM14lCDu+I5H7c55tsCTs4U8eGWGzgm35Kj/ykNXW6zVaAlgQ/Tni/gCDp/wH1MtH69y6MObfRGxoyqvRP0JlSwws9QHP/+4f5lrSGytEiabxQ0C7LUrJ0ntTkmTgmbkqogMXhxSN8Jw4vst59pAO9FTQ7gXKiJ2HbSZk8QSrYkF4Tk5ZQrOFh1VZIHyBWYYOSKSfs7GdGy6KUx7ffGC3THx6iEmwR+akJqPSbMiASk/3h9MgEPh1SD1Lr6/GGSQ3GMg1EKCZ/yNqQBJeil2PpqQLiydV8KedCRBlv3KZ8wNLA3zz6YlqMgsjNWs26V1FyJnam9bQ+jRvMkzhQ5btiF58hunxKG8g4QfwlMvE49nKmYrYbHBNqPjZw2AedGC91GsKwcEvBw3rq7zCgf
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
 mm/hmm.c                               | 827 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 603 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1064 insertions(+), 585 deletions(-)


base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
-- 
2.50.0


