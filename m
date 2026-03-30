Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B38010D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7E36B0095; Mon, 30 Mar 2026 07:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19C66B0096; Mon, 30 Mar 2026 07:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1D16B0098; Mon, 30 Mar 2026 07:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB216B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:56:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FA5BBA002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:40 +0000 (UTC)
X-FDA: 84602577360.19.8C177D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0506C000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dlv4k/BU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871798; a=rsa-sha256;
	cv=none;
	b=D79OO7dWPSheqlVhzKqgnuaob+OXJ+grvgrO08ZeRG1IjJW83BXoH7PEyDIxzrl8Aig4Ix
	ohUGRVme8DCazuqkXE6hwgnY5m2hLRpZbfFltsRXUDw+WFHnHjDxFMHQKcRQ4OKGoYsokm
	+/2ncUiS3dM2EerF8es0qoiRHmZwm7g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dlv4k/BU";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=99+Ss0uYTsIYKLWmw7UltxGOhAAHJGZHHKb35Rp1Csc=;
	b=BCYuyKOvj0+VctsxxoNxyflcJu6ABxl+0VR/l/QEcq17EI3EOIa4R/5LgRCbsuFaDOJ75o
	j9eS3xa/cyOY+dycD+59RiahLIrz/afxi+y4LLVA2U1rcjYV1InR1WY58qWhnAyxNtJQZu
	Ht/jA/lQ7dqSn94rZEalOQrny3HexnE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=99+Ss0uYTsIYKLWmw7UltxGOhAAHJGZHHKb35Rp1Csc=;
	b=Dlv4k/BUnktJOx4hkvGGD1qnzNqfkAa3iAyiJSjPrAlVZ8+P2dN3VoIYw1Cq3yzNYqP8bB
	zhEBy/axzD/k5mR5UytN5PFRPPBZDPHhQFZjBlYy0Mc7+5+L8LQi+A0QAByFSZu6brzjvx
	yDtOp3Rdud3AnAWJ/66wo1HqijAm5hU=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-iOheTY6pPBiXvhWqabH37g-1; Mon, 30 Mar 2026 07:56:36 -0400
X-MC-Unique: iOheTY6pPBiXvhWqabH37g-1
X-Mimecast-MFC-AGG-ID: iOheTY6pPBiXvhWqabH37g_1774871795
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38bf3edb13fso33130571fa.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871794; x=1775476594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99+Ss0uYTsIYKLWmw7UltxGOhAAHJGZHHKb35Rp1Csc=;
        b=pdHIyQS6bLhudRuPxIi76UucHO0QsYTFnH9T7kOMDlmP6ZYReSHvgttLRWfOklsINU
         APWQ3omaRQ39DMMiGC3ysF8tUP+68+L0sNHc7ZXDkYKo8YcAibrrFgMer6OMEdF+rn6S
         E+Sn38ha2t4SVYBXsOi9carFPTTCrvk6LpUYwnH/rgd5Tm5uGhez9lbVe/qS0FqLaEXv
         iXCYdMaoaxbmbQ0YOKucZpkwxmzuJw7fcZEas/lgWO/Tj+hUwWsa7Q3XSRCLdxPOYfSE
         4EiovpLWX9ansikBa8PLs7czcAgjX9l6qLcqsPu6nH8OodqQ4cuDMf+3UMOU+tWdpihj
         BnNg==
X-Gm-Message-State: AOJu0Ywc0cv2ESIUj/T7KtK6lzNW/2nXntACXwKiHOUYslAHZbc4dGF4
	sMlgCBOTDK/QuJ9sJRTNm2JghyiLTTi1eeP+IrVa91GDXiu/8LMP+gXgH1xru17gWA1ftGyxLOy
	26lS5Thhk6LHHXAU9nidfNGfCJ4ZRgQ3QdwdXCo5wZF8Z/5o5XAQ4I04G3jBKW9o9HZl/J8zgiL
	5mDxu0lKeaeYdAtSmYOhyvJ5+8zDeJzTdEYxcToA==
X-Gm-Gg: ATEYQzyNd7ZMo2uz4rsz8AkdPm3FEs8gxn8W+SiTM/DDF+Q5WkdWW+qJVZ12qoU3Tbp
	QBY78eSe0f6XcPUd2z8/Gv7smvWuY4j8PHaBVPtshvdymyEOnshYbtyI0qkzWL33UUG4EIKmCTC
	T0oiWRhzLp7d/Je8IKuUh5+P2SBa3I8Hq66YBVesAzvraOi9icP+xG6D/RyxmFQLNXYH8zPy3hT
	sZ/zGxFBQILn22AQp6+Ht4SA9V392SDwbEw+HNrV8wwHxxta3+IXJOgc3f1rhkyLAkqDhdZzUDr
	rGcWR/ntObjJaDxhw/+hM3WV78e9HQLKDmVe5vvQ4WfA7Y83Txkgvt1HIEgZWFwegXkcFq5vG6P
	wO8WA0XaaROfZobZOZSNr1BJz7WwM4QxYhiVN
X-Received: by 2002:a2e:3617:0:b0:387:b72:816a with SMTP id 38308e7fff4ca-38c6537b330mr39500401fa.3.1774871793963;
        Mon, 30 Mar 2026 04:56:33 -0700 (PDT)
X-Received: by 2002:a2e:3617:0:b0:387:b72:816a with SMTP id 38308e7fff4ca-38c6537b330mr39500271fa.3.1774871793268;
        Mon, 30 Mar 2026 04:56:33 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838daa4bsm16330071fa.32.2026.03.30.04.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:56:30 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
Subject: [RESEND PATCH v7 0/6] Migrate on fault for device pages
Date: Mon, 30 Mar 2026 14:56:05 +0300
Message-ID: <20260330115611.347988-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IkDRKaQu7cYIO9wBpbdFYXb4K1LxBYV9p0etGqdBbRs_1774871795
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F0506C000F
X-Stat-Signature: zpcoqbi899d5etbqth7tt7upewt7aoi6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774871797-121381
X-HE-Meta: U2FsdGVkX1+4pBpTq/AZUcdPna6kxHd2A+sDB1xvPPhSk5kD5+YbGOix6llLUWVkhuFq4/gc+5ilZrejaOAw2kupVV+jDul/7uZIRtWvxkDHzuXvkBwHZz3D37f961lHdgE3Hsl/nN2/YebqjFXltfGl9zHj8JwgsTcHY2U/vdunW5m1un9EM+tAHwH4tGQgvFmuu6jaeVlvO2yAhIybRyT7jZ/lalsGMvkjC5xdlrK1F7zHAA+Ch//32KNE5tGgIG8mEIIcxG6r+Vft6mQ+N3F935KkyfMEVYZu7AQ6R20+Mo3pXUmx8c1VEuQ+h+vgWANNmpXuNtuS+QLXorWSF4qDy1XNonO0Vx9uR+TebnLyAbQusXJbPKo6zT4ujaFE8qUzTmIHZPDF6aWIWfz+3jEv31CQ5ma9wpASbMu+xGqGfKzewhk18Q7vAkDin5XtPxefdzsm22AeG9UU5HCz+TtcGzqRkyvBnRNHKq/9sXQSXGHHoxoMXEnJ3uTVegJTXzUW+8AJ1BjATg/imQ99WrbeRrbp7CtfCwxY8TgZCX9LXUx5LuYC/8tG5swCQxronkUlaLRynvrI4rnKfJrk4sPIZeYz6IgTQOYlp5zfdI5JUOzg6fgfmWQqqfsXQ669vaPSvGsfHu42p15Y80nASCcUmcAStQYFrtnaKZU8iFdIBI4fkMN8daENwQX6EJU0qGo8CsfnpvULdwkxNWfjp/ehrgaDI4BTBjmRTkkhOVAHgDzF6Q/LRCKtKPgQFrLDISAEWrL/xZI4bp7SlychWHrquZGW+z74S+LOqRge8s3/3NJI1+UPlBee0OcUDVe6b9kOVXUG6ug9VCNuDfwN8F8oKuWLElU3vfzfMJo93hp05tQIp7XdzTXbvkWsTpsuLxgsIAGnKusIRDbAcqrtUE+QbQ+iBwmnKFykd44Dt3PPSez+nMgFcJd5lhRK19Pm0PGRlYSdbAE6a0/IyYu
 2lCadHZA
 6j01YX7oI6zQ3DuWcy7Zvk7/m1UvIqDEmGpb/HnTV+vDGTD18JAwlhAkLrIePUdnIcc6+S0gaSebvqqp2jyzfuQAj0aaProJu9gFfoRxr2NzKdpWG1NYBtf8AYf9BsXHArWAPNTdjMH9CQK7Hm/KCAsWT/OJ4k4JFNbSp06/rW3WD+2QIqPcNGfAQG8XhLF1qxXWDOUrXo0OWJxKBYDjEyeBH1mzsSJ/9qHxuSMa+ZdCmqOchMzNn/JdYLAT7B3n237uJLIdkc9ZufDXSI1zeSd4EZp5TfaSpzSHIZBdS/eRELSTxotueVoGQJ2VDqGRQqxE1LsWQt6VWq8xmWTicAWRbN0adjMWJTlml2pa+ESwF8BhUh1X9HIXTX9QIVXcJoVmpJU3IYmKIdlfVhvyyhoUb7rsx6nE7FltEzO+TEUP2GtCTcMWwZ6munatEEFiLHDFQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Resend due to merge glitch..

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
 include/linux/migrate.h                |  26 +-
 lib/test_hmm.c                         | 101 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 821 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 591 +++---------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1054 insertions(+), 578 deletions(-)


base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.50.0


