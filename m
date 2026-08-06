Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CDEC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797566B00A3; Wed,  5 Aug 2026 23:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747996B00A7; Wed,  5 Aug 2026 23:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6361A6B00A9; Wed,  5 Aug 2026 23:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7E906B00A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:34:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B415A06A7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:39 +0000 (UTC)
X-FDA: 85069427478.12.A8E872B
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf02.hostedemail.com (Postfix) with ESMTP id F1E7680008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:34:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NcQSVGdx;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785987277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w0e7fE5gawtbSIp2pytOUjBhFgpDkQIh9Ss4Lpx8mFs=;
	b=q3Dxy7WiS/ZR0XR7MV6YBgbUy//is3d5UaeU1Itn499JXmDA/zuFEcRbROfAUuCfxnwf1F
	tECweSMcxmUOmAa0G9jLHfDbXSKDCmjyq6jOrqCOYrzSClfsV2fJMfMNutQgmMokb343di
	/uI0QpXvkqsDPDJY5IIOdY7DOuF2gh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785987277;
	b=RiG5Zf3Ot+UDS2CaWU4WYjeB+yh1nF8JSwBxIQXikCbG9RLoyY1rjSdUCaaiiLDSNCz9oS
	mu6Vnk5hfa+oWMIuXcrVNyRuMjNHX1NzPqET/73sh54+MTN6ywsIBywGke82L6KhCo8o6Z
	L6F2rJER2aooFKwmg7MgzMxvLapGXeo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NcQSVGdx;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785987272; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=w0e7fE5gawtbSIp2pytOUjBhFgpDkQIh9Ss4Lpx8mFs=;
	b=NcQSVGdxgZQ+ABGD6xgCE4F9WNy1RqS/WkLF+f1YVJUXuJ4611BQnEQFWVBm1sKz5x3uly2vPjjmnMHmJR/9l5kLiMCMAcUBPowS1o+WO6NjTFMC0EjNBd2oltXFE9nTGIcurdFJE5dwEkrTu25MRq0wNcD9dazL/qkr6oV0JHk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8SlEJY_1785987270;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SlEJY_1785987270 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 11:34:31 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] add anon mTHP collapse test cases
Date: Thu,  6 Aug 2026 11:34:11 +0800
Message-ID: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1E7680008
X-Stat-Signature: 6kbrbzk8h34q8yjz8s889wrsgdyq9upb
X-Rspam-User: 
X-HE-Tag: 1785987275-249205
X-HE-Meta: U2FsdGVkX18N7mrK8EtfO3u6fXDiyU21hnD+V2ENQobyFFpqXfP/rwztlj4Y/dH1aoAq8cSYMJnuobC/aj6tgf/ImznjxIfdwhvBiDs/X920+Z4D5UZj2bBH3pKVpSZF555qf7oRzTq5JSMObUmHk9TMP7LJVZUFNTbbuzQwxw/gqPlfBgUAmkIbf++7yOIQlMkSQTsWMUhCJ8ev9QNsjx966ZMr98hOb5M0W2bsaNd8b7vxPDemrilZI8Es7aGGCKThhDwtp7SECpkY6g0CWfb3E7E4Hf1oots+F3C6WtdDZgkGnJ4b2XEc4SGQBBlpveQDTsP/BZl3zaKMPFsBbqdvmiPi0w1XrL1l3jamerUWPbIYkFoEsrI8DMoMOtzeF0/DFvlZBva6SzlUaZkwpGO2NCQKLTfXx/6vPyIPngGelKGYOi0wHMbNDSDDq0KWcW6ljzDVDRWPIaijtIMQmPvoDQ/lQnWK92gArYkwNXDnsJPAiAM60wDl5ixz6I1iUuNsS6ieMJaP6h39w5iW5p/X4stRNfG68R5YziW+FZgkWh596FgveVTXPFiix0VXl1jmrT5zXRVvCST/wOHFJs4X9hOzK9GEy+RyUViffgcAd7ZZBCtMAUwqVgcA/od8hjawlk+/mLCTWwFLo2X837CXTu2N1Xl6almnBiBGXHOntk8zyhgHCdWnRHd4uvpBiCCjKCRb8QCT2C4K5h9We6OeC708ZSe5+deb1Zaimqfzd+cpu33F+7Iu4c2mzjamhCP+vmMuM9NhBdTUemzAyN2o0SjkaJA9Rjh29zw9GXKhaFuPUaJKYPblOy63ZvIBZ13zcfdy+vinUqZxUDs2d7Cf9niMaLfM11hstujEb9C+xecwiR15mFSrlp9wDL7wC9MpnjyVEYWMpncAE7mmb6spNq49cIf/2z8zxIbWL13QicCQiMOlXrewVVpgBElAMlyfMH46kIDCQ9ROfKb
 NVtQX6cv
 9KMSxKwRIfeZN0Jnm3s1uG+0t5T0n2OlW6VnhqpF1dVYJ5Av8CpFyuEHm2xRIVvN9yjnqryJmCEY4vwTDqECscWDb+RbwqbBN1tcKxi5yrUC4EJrzvqoFZg576QfNwmuPGcCsR4lgcF/MZG2Jdw4QY9Q0fQKWLvGKhZQ7zzSx4gw2toUiTc1Y58BmBMFtSAcJ5OntgAqu3rwCUm8F8NT6ApIIXhb3X/BXebwS+vOeFunILUQE7aM3zfTDBwXYk5RgOVlPjLnQZup0uBNSokHb9A4OKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is split from the previous shmem mTHP collapse patchset[1],
which only adds anon mTHP collapse selftests. All khugepaged test cases
can pass.

[1] https://lore.kernel.org/all/cover.1781083630.git.baolin.wang@linux.alibaba.com/

Changes from v2:
 - Collect reviewed/tested tags from Nico, Zi and Kiryl. Thanks.
 - Change check_huge_anon/shmem/file()'s parameter type to 'size_t'
   and rename to 'len' (per Zi).
 - Use safe type to calculate the order (per Zi).
 - Check return value for read_pmd_pagesize() (per Zi).
 - Add more usage() info to indicate that mthp_khugepaged currently
   only supports anonymous folios (per Zi).
 - Other minor coding style changes (per Zi).

Changes from v1:
- Add order and hpage_size check (per Sashiko).
- Change to use THP_MADVISE for mTHP collapse (per Sashiko).

Baolin Wang (4):
  selftests: mm: extend the check_huge() to support mTHP check
  selftests: mm: move gather_after_split_folio_orders() into vm_util.c
    file
  selftests: mm: implement the mTHP-sized hugepage check helpers
  selftests: mm: add mTHP collapse test cases

 .../selftests/mm/folio_split_race_test.c      |   2 +-
 tools/testing/selftests/mm/khugepaged.c       | 197 +++++++++++++----
 tools/testing/selftests/mm/pagemap_ioctl.c    |   2 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       | 139 +-----------
 tools/testing/selftests/mm/uffd-common.c      |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 201 +++++++++++++++++-
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 10 files changed, 367 insertions(+), 192 deletions(-)

-- 
2.47.3


