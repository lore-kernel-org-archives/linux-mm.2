Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E424DCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321618E000C; Thu, 16 Oct 2025 07:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238AA8E0003; Thu, 16 Oct 2025 07:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1D18E000C; Thu, 16 Oct 2025 07:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDA9B8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:33:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1BD51602D7
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:22 +0000 (UTC)
X-FDA: 84003766644.05.B4FD6BE
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E3A980003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:33:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BWk3T7by;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760614400; a=rsa-sha256;
	cv=none;
	b=Erd+ADJjlDFskLVev70TTpaLHSIdMHw3QM6z2qxmA87UJvjT30kBW/eqsSG9uuKBa4vqsb
	ACUMUWdtQrWLzDD0Fhzkdbqk1YVAdTuiar7UnXG0WiaGCoTxIHGuDTOz6YXomJypCEaWw7
	GpbgpdjFsUp1O0ReA5ZMtvuCOQVIZJI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BWk3T7by;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760614400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0UKd0DgpGQsGYxSRnc1QTa5DFfPy1+JMKOudjICLDX4=;
	b=Po6RTuz2/vPRnU51CmVy+KomULfU5/uylqcOdy7tC90jUfDo25IFCkSBA+37424VBgcZjk
	v4upYs5Ktkctn/sb/ZaPsB2xHWWHaHm0xDV1ZaeUWHaF2JJO5DosI23iRb3OZpd2Yy1G6L
	OHE8wzDiByH3ldkHGkOKwQ8zHzgvvU4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0UKd0DgpGQsGYxSRnc1QTa5DFfPy1+JMKOudjICLDX4=;
	b=BWk3T7by4Gqj6OH9NWVZDbjq67GSZ67jdcwjlCLfysKIlZ6nT28rytCDkXZkicX7CT0rbn/tS
	lubE/MwlGBKZNPisd5GKxP+wJium1FsiwU5ziGQ+MxNI+PuBCfL6WcCFFVJ1Kv5X1ftct8FAuaS
	I+wpLZQc4YLs256mo1Ph1vc=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cnQlw3KzPzcb4M;
	Thu, 16 Oct 2025 19:32:12 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C1772140257;
	Thu, 16 Oct 2025 19:33:12 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 16 Oct
 2025 19:33:11 +0800
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
Subject: [PATCH RFC v2 0/2] mm: add huge pfnmap support for remap_pfn_range()
Date: Thu, 16 Oct 2025 19:27:02 +0800
Message-ID: <20251016112704.179280-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E3A980003
X-Stat-Signature: py8fy3uerqjanuhkqoh5pspjt5ew71eu
X-HE-Tag: 1760614399-113018
X-HE-Meta: U2FsdGVkX18uCVAAvCLzeUMzq+rsoQM6fpAuwCKCfvMy4sKARA0nhiGG9BU7hWborsZRgrVeNj8+p6i0GnoLvmrTuPw6gqIj+hTOJTFZgUyadrkp4YAApeFCOviXrnkPv5X6xV8RpeEeFJ6CNskvLoyjYYsxfTu2jj16H/C9T0VXb7axexlifyEGRPp+mmlKPWoFiuF9B8QutUmkwE+5SnptW7HoB8EAgrcCpStQkaosJv8B/oH0B1+FR3lsgZicmAl5Fq9g8YPI8A7VDAKG2P6oIcRXHdKBWH1lbcwS9E9KijLx2Jr/yw4Cs4AF3k+wXG7UrdeUshyanlSMjGF7/kIEPQxuVd1Uk47ennmZY4rAosXa4/DMDrGy/FwvE8w4QpkmehC68OCCOYfRPcWEf6TNfl+EE8+RqEo+uuzwf8PPaIeeIa42HYVANXt13Vti/2/3ls5SysRGUyd+jrklFih4I1XBcCcTYlAtELaJwjw1xLk1aNm7tuvUnMqLPzxjPR8JBtkDxjLLELXcaWmF7uiarNclJG7AGtS/Dk53HfgJIP9JZ4kbHAxsRw55zSMp5DhuLnYixPH8RcOVC8kUPrS7j9PORVfhqxdBpyfcReBq9OtB/2jK0+rbHMtwJua5K+57hkpnyOt9uuLBdG66mZIwszHQgeGkOVCYutmNTbNBOpfT3T6gs5qlQCuFoQrBdP9GddA1tQv7CAkSCDVkMgdscfehntG2l6LfrKX6xAr3kVc00kxi9KuhRXjf9MKo3+enXPyInRKkmb43ETPbW4JIeXu2WTxvp4oEAuUHggVIjV33YRAxiSTJPVQ8g6077paXHNJzyoQI39zNR30TKnvs2vkUq3qSjsYBDq6qdxIbhabOPamRZqiGL+fJXe1m2nobY60RDaCSb2gWrurrQHc9QEJErqzx8KX7kq56b9doqYgXIZc/iRofM3ODWO26wH1A3dO7px1LoIv3ecf
 BSB4vOwB
 ERCwuCEPHmqm/ZYf/vj8rdEoKhm5qk95GMRaT+an1mIXOFJ6xeuHYwdJvX40wcP7+vk0pwXQA55z0DbukThaB+HvQe43sNsg+iLrN1BChTqZEDcP9hK3TnQgfZsNrVpdVV+L2dz+5C9f7KxS8UFvOkt3hfGSL+VuOo5KMh6k43KlSoFAJuUoh1Rnpz1fwnnU0KpEz4eC7Yn1D18QM6rEIORz4fEWuARfH7DuVIIOEZ6VvCKHYf7HsON4uq6VzdYqRuDxBZTPJcXkGbEvFDvEusuQ6I6wszZkhS1H0S5u+1RGHEV8Y3C60HJmBpJxZqBPQBi+b6UvHsYPWqngiNtUa+1PGtLkIilX3mCgBbL2wQgDcTemA2oj4QiDS6RIVbu9Wlnps
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2:
- remove "nohugepfnmap" boot option and "pfnmap_max_page_shift" variable.
- zap_deposited_table for non-special pmd.
- move set_pmd_at() inside pmd_lock.
- prevent PMD mapping creation when pgtable allocation fails.
- defer the refactor of pte_clrhuge() to a separate patch series. For now,
  add a TODO to track this.

v1: https://lore.kernel.org/linux-mm/20250923133104.926672-1-yintirui@huawei.com/

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
- Refactor pte_clrhuge() and related functions.

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

 arch/arm64/include/asm/pgtable.h |  8 +++++++
 arch/riscv/include/asm/pgtable.h |  5 ++++
 include/linux/pgtable.h          |  6 ++++-
 mm/huge_memory.c                 | 26 +++++++++++++++------
 mm/memory.c                      | 40 ++++++++++++++++++++++++++++++++
 5 files changed, 77 insertions(+), 8 deletions(-)

-- 
2.43.0


