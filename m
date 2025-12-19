Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD1CD74956
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50616B0088; Fri, 19 Dec 2025 01:03:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD3D96B0089; Fri, 19 Dec 2025 01:03:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DF966B008A; Fri, 19 Dec 2025 01:03:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD066B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:09 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43FD71A0470
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:09 +0000 (UTC)
X-FDA: 84235177698.23.B9472BD
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id B931BC0011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OhyQfoW0;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BIdqt2wvzbrEXlhFP7v4o3aru+l73IP2t49PU+LeA10=;
	b=R69tET3tELREvUunxWYo2H0mfr3QyJe+6AgtDFH/54OZZRskPX9KnoT3cDq8ub+bwAS+sp
	t9TrOu5Y0KVsz/k16qGSPnRmvMd/n/SGqLr8As7+40srx+ce6Np2noDtsk6Xy2+g+mViFK
	ueydMfIaoTiviykBNzQuRypmpou6y7U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OhyQfoW0;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124187; a=rsa-sha256;
	cv=none;
	b=r5unJYRhTHkvdoHTKH2zmFtZrWfN2eROzIK6whxkcc62o32KbJclWYK3XE3zhwxmjD7SJI
	ss8iTg2lCWGy1Bo5X7JPGIGgaGlzuDlAawTtHYPrmnIVGFzMmpt1Vv36Eax6TaXhmLSiP5
	wFKQBXqfpDp7d/sPfO+nLWbWW9H8SDQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124183; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BIdqt2wvzbrEXlhFP7v4o3aru+l73IP2t49PU+LeA10=;
	b=OhyQfoW08zdlkfieu+gFBJjBUNvrGMrEy9ZXSUB+GE0dUdtA2nejopRSIEXy7Od/s8qufv7zo1yG5JeWXKb9gQbeHLQIYC2FsYN0MK6WhBEx4/SAeGG1Q07w1tCUylXNiUedGYV7aSswLcCmXYftqY4usPGSanmhOM38e3hjjCo=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBZ2Df_1766124181 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:02 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/5] support batch checking of references and unmapping for large folios
Date: Fri, 19 Dec 2025 14:02:50 +0800
Message-ID: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B931BC0011
X-Stat-Signature: kuhcaxxcw3n4he5fhjsib1u1waqh8zf8
X-HE-Tag: 1766124186-632724
X-HE-Meta: U2FsdGVkX1/W0GCgxUhhf03hZmctDSZBoXtM+ZJsHjtYJTvNWOPw20yV0W1J8btIBsmDMl87qli+J/8YSPxIMSv9xvgQXuuhwvXjXeMlxrvDubX5lxjDo/08pdeYri5dM1taTyZONIfAi53CMO23swmt8zfi4US8t2qULjC0VOrOze2GZ6VUCXNnb30ioNSR3WgNHf0+e8kyNzVNiNSeHIjA5pJeQ4A4DxZCkog2qlQMUt0ccWVipWIg8AK9ZK2VaLA0owrceL36d/Yj5cUiqph3W6FkDs+q9BhTDxnEruJgSRoDY/O3IqGRPWeRA7DeGBy9Zn0xvMfbXgy/ENhjEAfigMm8ABwwHM3D1q9sjGzYyun/rkEmHdMqw6cd7HBzk/PNe9yB6x25AIdst0w4JAgXG/OYEVNpOQjhW5kQsbyzo7L/2jFsX69e7QKZSye9Y6r1gM1MLTrsgEt0zszKCsnWH/sl6p5sPPgAnNg0FMTPdc377Zn1uLx9x6TBsOco3dR5K6BJQzEP7/wOwDs5fZZf5ioQDvoWzgjKydzYYobyHEEiyfQywukkjGRWfy5Omusal3+Bf+I/h8rUos30jKbu2ZeQXbS5kcgBtAt6BiolrGJ8+qE7eodKKBhruvuaQn5gygaZwQ9xd6KSOigpJoIUYudNDlYUkF8qH5TtKn8PJ71GAKFao1CqjSs/JvnfaDpax5AVQoMxkcTl8Gd+KcPFS71+TY1ZOJfX1QpD6QqQg8mKx5IP5zFnnh976UnKY7n+vLTLwBgQ1QuGMdL02okLHZqbpB5S8VHIJ+/DcoCn0b7mZchcqT+a2C6IOU4evOauT+yjchIIXk0nQXFeMMe7Z4atQS6/eRUwEbDNnbZFEmnQuEbp7PYdoAbuHwzyuWY9LdEm5QhFkJTvMhcr/e1SVuvJQOdP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

Similar to folio_referenced_one(), we can also apply batched unmapping for large
file folios to optimize the performance of file folio reclamation. By supporting
batched checking of the young flags, flushing TLB entries, and unmapping, I can
observed a significant performance improvements in my performance tests for file
folios reclamation. Please check the performance data in the commit message of
each patch.

Run stress-ng and mm selftests, no issues were found.

Patch 1: Add a new generic batched PTE helper that supports batched checks of
the references for large folios.
Patch 2 - 3: Preparation patches.
patch 4: Implement the Arm64 arch-specific clear_flush_young_ptes().
Patch 5: Support batched unmapping for file large folios.

Changes from v2:
 - Rearrange the patch set (per Ryan).
 - Add pte_cont() check in clear_flush_young_ptes() (per Ryan).
 - Add a helper to do contpte block alignment (per Ryan).
 - Fix some coding style issues (per Lorenzo and Ryan).
 - Add more comments and update the commit message (per Lorenzo and Ryan).
 - Add acked tag from Barry. Thanks. 

Changes from v1:
 - Add a new patch to support batched unmapping for file large folios.
 - Update the cover letter

Baolin Wang (5):
  mm: rmap: support batched checks of the references for large folios
  arm64: mm: factor out the address and ptep alignment into a new helper
  arm64: mm: support batch clearing of the young flag for large folios
  arm64: mm: implement the architecture-specific
    clear_flush_young_ptes()
  mm: rmap: support batched unmapping for file large folios

 arch/arm64/include/asm/pgtable.h | 23 ++++++++----
 arch/arm64/mm/contpte.c          | 62 ++++++++++++++++++++------------
 include/linux/mmu_notifier.h     |  9 ++---
 include/linux/pgtable.h          | 35 ++++++++++++++++++
 mm/rmap.c                        | 36 ++++++++++++++++---
 5 files changed, 128 insertions(+), 37 deletions(-)

-- 
2.47.3


