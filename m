Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B35FCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 13:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690C28E0007; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619F38E0001; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2768E0007; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 317528E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:37:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A62DE140504
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:34 +0000 (UTC)
X-FDA: 83920617228.15.6941087
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1883A40010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:37:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758634653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=j5P5jHQTWMWJkiZaH4CCcRdICdkNrF4W+wHUuVS6e3U=;
	b=Q0bWrDCVJ6ZOCWBaIODTpHyY872NF2Y3VQHJ38wTp39DVf9zuzdz/ZxA15ASF86LEXUH1A
	VGfNRCLWHLStUmUuinnWQR6gwM7p2apa/KCrbCNn57Um5/ASjFV8iSiJMv94EO9GLto+vp
	No4OPtP+f1zpjs5JW2YSHOWsVHLM1nI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758634653; a=rsa-sha256;
	cv=none;
	b=XBWI512QaegOG1QqwlWWvKC237AH2wqWUV2bLgBhAZdpGOrCHpJ+eRkJK7i2MLa6e6bcuC
	UrXTt2WIcxlWkbxuJl+LpuFr4aOIOTNWZaI1WVeNg2l7/0AhzWinTC+/abuwrz2OW457WI
	1JOeUadJmppzFQTerM82LEOOIEhau0E=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cWLXv3hftz2RW50;
	Tue, 23 Sep 2025 21:33:51 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 5788A1A016C;
	Tue, 23 Sep 2025 21:37:24 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 21:37:22 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <willy@infradead.org>,
	<apopple@nvidia.com>, <samuel.holland@sifive.com>,
	<luxu.kernel@bytedance.com>, <abrestic@rivosinc.com>,
	<yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH RFC 0/2] mm: add huge pfnmap support for remap_pfn_range()
Date: Tue, 23 Sep 2025 21:31:02 +0800
Message-ID: <20250923133104.926672-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 1883A40010
X-Stat-Signature: 4iq86dtdi3he1gcrfm6myytiurte7zd3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758634650-473352
X-HE-Meta: U2FsdGVkX18lic9SNsfQADMXiP0ug7ul7dKV2BDx8s8KebdrB8plqGDZYi4HOAvV6886910Doq9ScGuO653R9NHq2BVJH15BmlT40AmMoiS/gRAe5IH6cjQGyWgdtkqUu8MUlyxTPGCdAiQYBwfx6vO690tBld1JmSic0wr6yhN+FJGoZCm16wlo8arxxb0ew7tkDlNCW0WkBnQVZ06HxdO+AQ3rsmv9p5s5FlGuW72YsuPu7HUc5jCPvTFvnpshocuZZECXanGtNLlMvN57pPoup/syppIrwf+j6f5tple8otxMh86PfsYESb6PyA4Yyj9cfGXYIEvKDExcNmuGST7uxqZQXdb9UjcmE0JZimoGqpSOpMmKA4W+muur4J0Bje1onywsFy+y5HOvNPn3njVMGRlV2zLcVWhc+0DAhG4fr0bTofpWh/IRFLa3fQJwCvwxaLJuXbgV5R2YQliWakYbtt+dr9F63/tMGUZ7eo6Rvn7naN2p7jS6VPny74YGcHViofWXcuKMrpMl84noFmgyVOmm3jfA/IzQBAoAOM8lb+erNRHquEcDO57tLyk4/vVgOBxLBryWG1UYGYl/bpn/Dp8bXrGmzSV0GlsM7XI0jN3Nre2BwfKKFgEmTBhcV0rmNsBg9xc8MEBEBrDxyzrMdPz93RblXPNjfuTcoKS7iyrOK/NHJt/QXqDfsS2SQk4vATYpuW1myYfNMMpTN3RyhDb9ygSK71XeOQu1RygV5RJKSD7uNZtQOR7WGDm3gXqoDxf1HTADomQUO2PQOwSMpeo10myGTmE7BK65cNaB1DboHgB+YDM/A4ie4CkXPoIkXNtMHMGsWCVlR7R9fSUl4z3kHOy/SF1qqYqKlB6/nT7RK+kfiKbHhLpU7tkVFN6Qnk/iPBMvMuwo7E9gsJqT6vsV+Ca2gUcM5MveFtPY6VevwLJZ+uQ3xGUHXtB8Vf6W/ofRYsHMd3iHlZU
 +QWzo4nN
 MDLIo8tcG99+mfUnB9nxwTjPL4t5iwDWzlRhGyn/wBFJnxHjY5fpsAB0R3Os/FLQ+kUz0Tye9nEMhsFd1oln7PnWWSzVh2ohctFpsgaotuedZUhpAcJCu1sKFaP/AzuttYbIF7qiAqipDyGID+V0+8SBNlPlBqgRLT6LDTqwGIkV2Ol/EfyMxhOPtgAsAoLnAu4WExtaZfzil226+W69mgAlXW9drcoV0eBkLqz3dwFq/+pr9JP2SGje/NHAq2pF3duV7ahk6hsvDLGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overview
========
This patch series adds huge page support for remap_pfn_range(),
automatically creating huge mappings when prerequisites are satisfied
(size, alignment, architecture support, etc.) and falling back to
normal page mappings otherwise.

This work builds on Peter Xu's previous efforts on huge pfnmap
support [0].

TODO
====
- Add PUD-level huge page support. Currently, only PMD-level huge
pages are supported.
- Consider the logic related to vmap_page_range and extract
reusable common code.

Tests Done
==========
- Cross-build tests.
- Performance tests with custom device driver implementing mmap()
  with remap_pfn_range():
    - lat_mem_rd benchmark modified to use mmap(device_fd) instead of
      malloc() shows around 40% improvement in memory access latency with
      huge page support compared to normal page mappings.

      numactl -C 0 lat_mem_rd -t 4096M (stride=64)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      64.00               148.858 ns           100.780 ns        32.3%
      128.00              164.745 ns           103.537 ns        37.2%
      256.00              169.907 ns           103.179 ns        39.3%
      512.00              171.285 ns           103.072 ns        39.8%
      1024.00             173.054 ns           103.055 ns        40.4%
      2048.00             172.820 ns           103.091 ns        40.3%
      4096.00             172.877 ns           103.115 ns        40.4%

    - Custom memory copy operations on mmap(device_fd) show around 18% performance 
      improvement with huge page support compared to normal page mappings.

      numactl -C 0 memcpy_test (memory copy performance test)
      Memory Size (MB)    Without Huge Mapping With Huge Mapping Improvement
      ----------------    -----------------    --------------    -----------
      1024.00             95.76 ms             77.91 ms          18.6%
      2048.00             190.87 ms            155.64 ms         18.5%
      4096.00             380.84 ms            311.45 ms         18.2%

[0] https://lore.kernel.org/all/20240826204353.2228736-2-peterx@redhat.com/T/#u

Yin Tirui (2):
  pgtable: add pte_clrhuge() implementation for arm64 and riscv
  mm: add PMD-level huge page support for remap_pfn_range()

 arch/arm64/include/asm/pgtable.h |  8 ++++
 arch/riscv/include/asm/pgtable.h |  5 +++
 include/linux/pgtable.h          |  6 ++-
 mm/huge_memory.c                 | 22 +++++++---
 mm/memory.c                      | 74 ++++++++++++++++++++++++++++----
 5 files changed, 98 insertions(+), 17 deletions(-)

-- 
2.43.0


