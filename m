Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1E6D31A2E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE636B0005; Wed, 14 Jan 2026 04:19:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C796B0088; Wed, 14 Jan 2026 04:19:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD066B0089; Wed, 14 Jan 2026 04:19:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5E936B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:19:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8553D1A040C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:19:52 +0000 (UTC)
X-FDA: 84330022224.15.3348B3D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48613A0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:19:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eh3GaKWc;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768382390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G9SVdNqjRAtTrnCSKMEAUtKcyXA7FAEWs6RSUFgfDUM=;
	b=XPdyAGvQ2WEmLuGHlpXcSCNuPXWSzf/D7u01HWqUMCWxz3rB++N99TLhDjapQ9RledwPHJ
	m3UZZQ0PhdYnE4gXvh8BaDzbb47n8TVfTTRb0JPLSHfnzYActnXTqaxtCLhk0LVxntpjPF
	DYpUVl7CLyGwsO9hhj80qJN2sHx5n7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eh3GaKWc;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768382390; a=rsa-sha256;
	cv=none;
	b=pw1T8YoiGlBxb3tzOs2+8S0QOHwGp49vpt5j4s8N66UJuiaKKQ/vv9QXC8qXuLWcoU9MOX
	N8y1vn9ik067/WrN/dOQJVUlcXkNfdLGl0XZht13FIRVAlTO6VMdWfwmlUau+JYJyIsO4b
	8LIlPY9UaGK0bymc602POX1UVADW/As=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768382389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G9SVdNqjRAtTrnCSKMEAUtKcyXA7FAEWs6RSUFgfDUM=;
	b=eh3GaKWcXAuUbnsbcaX8Rkuw5jV+wG3V3o7qYtRgQqHzenePjmRBAt1MVmEw5VUqKsZv1y
	yDNvGV5WXlj4119MV0JmIf7dOqEz1z77mKcPDpnn34ymLLCxld/brYm4usCjt75HXussLG
	P/Je2UMBf/DtaMRtAt32kcH6ymC2VUU=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-axvXbqjBOUyE0I1KQN8axg-1; Wed, 14 Jan 2026 04:19:48 -0500
X-MC-Unique: axvXbqjBOUyE0I1KQN8axg-1
X-Mimecast-MFC-AGG-ID: axvXbqjBOUyE0I1KQN8axg_1768382387
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-59b6849824dso6483223e87.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768382386; x=1768987186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G9SVdNqjRAtTrnCSKMEAUtKcyXA7FAEWs6RSUFgfDUM=;
        b=jjFPd7SnaaVibcb7dICoXDzbi4aSCcDiUnVPwF6ziyGRlTl1REKbJKWKQ/IqEU7QhE
         LIk5243oYi2gfOWWhw7Ogd2y8FOkRzKI63Z4FnaDPloNUa7klPQMSl4E06fPzA4pWXSN
         STyCvWzVIrR9k5mgaaEw8WgS+igZ3+IriMT3+udXJwXQh7xB58jo3I0EwXrLWL503C/V
         coC4Ijs90MR8oO5lHEp68BssxHeJAerA3JxEghCJv3fhWfHvQ7FZZ/tr6QraQilhFrxo
         aAPtrnHp2J8kwRBtD9MIicHvjLdmP+K6LGwu5ZQeX8OuSygQUyD1M8f0FwbmtUJu7PI+
         XKmQ==
X-Gm-Message-State: AOJu0Yy7kffD3K3TCSjPeAhZEGPx8ZumxyTbRvhsvC67cby5nGsFjmiz
	0XXHF3AfQPJ6By811y+UOzMN5YukwcPdpD1JgnOGex5F4sQwpGT4js/8agHkzqNAssjP6P2KM87
	060rn5Usevgr7TUsGzY3axmi7DwLcYP7QZ0EZPOSq4zOCTFtlF7OcsVV98ItDqfbrkoFNvG5BR8
	j+p6wCyQljXqSXu/2IAT6CJaY8JnwrSdNJ1ec=
X-Gm-Gg: AY/fxX6nC/2BzqlKhvs8Xktxd2HYI2qdqwKSnKpgItokoFUqBLdeYv1nL9FXHNEU9cO
	uRCeRDPFOoVofJszl69myrrWUZhl5EifJwPy45koZ6ecK3zsqyEqWf01tbo2BtKlCGkXMrBr9EE
	6syjIrHFbB4uSZ/Uw2dGt90GD/sPqLx40mlVtKjIlsoj+5WtIsYViKtw4iTgj987FlASaxlVCjw
	EtSpGrycPKql2ijz0qtn22+aENmXnIN05epEg0JFizow9cNZKg6dvuq+7aQ8UPhW0LaBhsVqMOC
	S+bdYZSBQtnweDSZwyD4A6do1w6wAuAJaGwCJ2mRH2ETGux2+ISoTfRMAH/96/UhoMkj++uag0B
	DEu6TXHRUY2w+a8U0m8R/sH0M
X-Received: by 2002:a05:6512:3194:b0:59b:7c23:c637 with SMTP id 2adb3069b0e04-59ba0f6b15fmr618339e87.22.1768382386399;
        Wed, 14 Jan 2026 01:19:46 -0800 (PST)
X-Received: by 2002:a05:6512:3194:b0:59b:7c23:c637 with SMTP id 2adb3069b0e04-59ba0f6b15fmr618318e87.22.1768382385864;
        Wed, 14 Jan 2026 01:19:45 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59ba1045be2sm513898e87.81.2026.01.14.01.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 01:19:45 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 0/3] Migrate on fault for device pages
Date: Wed, 14 Jan 2026 11:19:20 +0200
Message-ID: <20260114091923.3950465-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ctv9czeelvXzR8dv1SpLhJ5q7mgpzca4FG7slyCZ-q8_1768382387
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48613A0005
X-Stat-Signature: 3bjwjzwpz46tbk8xhwbzkdo7jidsfpzw
X-HE-Tag: 1768382390-55501
X-HE-Meta: U2FsdGVkX1/ipFbOPhQyBsrztsS/Cdy3H35b+JHtdymx5gRfEW0sE6wFjwsTiXan2RRF3hdfg3EeKG0okD84WK08OZ41uimr5jse/bFAzGNtQ/7kIMbf7EwnH67Ge5DBIPQp9W2eNsVG9qeXNvEbHLDZrbXBtfJ3jWfCS08H6CB6q5uH0V7cnqCSpHvZ22hsND28bbE0r9DdMtMT3QgNctQdgfykpPYfWPjn5UW/u4jG2js7Yp6R3rHn6FR7LANrlBWuf3pcqlPfn8GW4djSyChjP15tgKt9V+IxZbGWWB6dYHMX4nBnP7T9j39TZ7WQ+D5g4poyOe5tZw9UWKB41hFFPOg1QrNFpJH84GFC9+hl+4DDjo18LvjS/JQXIHbIX5XuXYzJi/GhdgMaihYPJfeNCYKDDnkh9uKEBizRemi0UpPJi+326XLCGA0IvjJKD8UwoxRAWDSkTtPqQnJ1//J2oMNZWDZ6fMTu5LuddJeQtwBh006qfOcwuGyGtzTD8E1Ehmz+DrWgN9GpYxmRSsnE4TCSCQ67yrPXTIL+e4m83VJXvItmuPIGZZCYOVidXNW/AKEUsyh2XviNQO6cUx8P95Zj6/lq+SmUIkEKWdbr0XHHxFmY5XW21mzhfI17CElc9oCkYkUaNzsX1YLv8VpRDdKlmQrGxvyQJKSZdW31ZbcJ4nwfbtFq/mcJTRCvo3ikrzqaMQRqK2CA9UJ4AX+IKlrAjr+vE+l/M6oaTjnv54l3zkY4aOJ4ChUBabX8ZmIqfxrBxuZEuPAkKpBvc7oLd0LWmqGPqDdO8QAnkQKZm8krUDYS1hx0CtwP+MnStu95j2MIDHgG4VUQhK8JSPxyCqFOo7qpNQO0/qYQXmUVxK8ppi9tA4QtR9YFzQ2faSPMpIMSvZsvYDhNWr/LxFlLS14dcrm2k6MEvLRO0iMapZqQ4ejrmNkRfp635RvUMt5IGMO1rGwoaSrTSk3
 W/lr0oE3
 O+/FKpOFUVQEZ+KHIcK08F1JLpp1d0GyIHjNw2BicGCD+/zRQAugtV2YHC9/+VrKov26GYjqohWNx1mfg3MiGpQQ4D3217/vqfeGmNJu3iEvKTyRwUvjaxilSVvmyz3ItSmLmLiX1XDjV8DYO30NQlxemvbq9kxO/GY3UL5jcspB5AFqIOkBfAQCzFCySfCc0htqpVcgQ64+wTz3RWMdeMtyJSds0LLY088tfD/d0OwJ09XKj1Ud5SKOp8LFFO6UAyGlqmengfAD+fw7spPmdq0gS8SS2Pgr24JVRnMZ/BHW+ROYdZETg+KqOJIbzWFm98hdairYRyUZmzUeS9snJ0NOrzB01c2xxex0D2hARjpkr6yn1NebldpevP64TMWvxM1OWMV6GQUUnu2E7qmKGeZOLfHbPyxwKVlKz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

Tested in X86-64 VM with HMM test device, passing the selftests.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260107091823.68974-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes from RFC:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>

Mika Penttilä (3):
  mm: unified hmm fault and migrate device pagewalk paths
  mm: add new testcase for the migrate on fault case
  mm:/migrate_device.c: remove migrate_vma_collect_*() functions

 include/linux/hmm.h                    |  17 +-
 include/linux/migrate.h                |   6 +-
 lib/test_hmm.c                         | 100 +++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/hmm.c                               | 657 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 589 +++-------------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 7 files changed, 869 insertions(+), 573 deletions(-)

-- 
2.50.0


