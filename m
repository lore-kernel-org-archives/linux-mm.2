Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88250D41C02
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61656B0005; Thu, 11 Dec 2025 03:17:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11C56B000A; Thu, 11 Dec 2025 03:17:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27F76B000C; Thu, 11 Dec 2025 03:17:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C503F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:17:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65C9F14043C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:16 +0000 (UTC)
X-FDA: 84206485272.18.CBD2389
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id 98C2E40010
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BkXQniJS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765441034; a=rsa-sha256;
	cv=none;
	b=jF6R9g8Vi5jGT5DYQhh5enHb4EcKVDIZ41nC6Vno+YWturOp5dKDnIGyx2xZjoucd0zxS0
	IdVjPUe0mPRyDXoszfRrc9Tqb2aCGy+///VIbT4v1o1YleCO3q07+oJnYmRY2G4a7cofzz
	cTs1789TxCMURx/f9F+zzyQYNssD+kY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BkXQniJS;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765441034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F7ZBUFth2QS91MsUVzia8UnQfPYwaqtJvLrEI1PCTTw=;
	b=J9RVShOrfeMk4+k2R/FrCcCg0JK/I6AYt+1P9/Q9lgwYuISWW1O+9OveHNLy7I7XeuQoeF
	d2C2NTPqubqagqdjbktoJe3galjJYytRKRef2kuBDFhd285um05qDS3H+KGid7H3dkG8GA
	+6O7RlBUb/sPUvZ1Taxzb1YwI3RIP6Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765441031; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=F7ZBUFth2QS91MsUVzia8UnQfPYwaqtJvLrEI1PCTTw=;
	b=BkXQniJSXLcChS265vqghd45l7wNsRgJK6LYS81iEDCPRKxk8cjU1tptEGK1NJ2wzn8e8A8vTySyBPx8AiWqOoGpNTqOPE1p88U0ZWqAhK0yLRsE6gQSXKUxGvYAvPAgmU6aBNPxgDJMRIJMFWcm3i1Xn3FxF8HWYzfjf0h0afQ=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuZl4F4_1765441028 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 16:17:09 +0800
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
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] support batch checking of references and unmapping for large folios
Date: Thu, 11 Dec 2025 16:16:53 +0800
Message-ID: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98C2E40010
X-Rspamd-Server: rspam10
X-Stat-Signature: 1wc5qq655tmxdji34jghng3ru93uimyu
X-HE-Tag: 1765441033-191837
X-HE-Meta: U2FsdGVkX1/8NAipRjAvbdj0bR0P6YqTLZYIOEy1mX6VAn0SbJHuGYSoMwx9ADy1F8o3vy3rKLXXv4Ulw3GBp3sLUqbqX433oQiDvKdYMWiLTAy+rM41UGaEBrC9h4KNgMiM+tEuf31c/fCeh5pe+ztaaaQkwL+uxJFctGEQ7TOa60YqL2+Q1zw9gp1NLrgUEuXtpGxN/NG62ZVzYRGtbl5WabBE9SpV+CGSn7omQr+SmdyCiPh3HgfjbqKpRbmjWBztlaNrzEJlqWsrCCOLlfQnEwtXvR8GJ71u/XWolzXP13ORVzn1CW9WVQOcpLywqdTOkgWzHC84RBUHUlJZl7gzCVoPRmKTEFhtF2Iw+LkpnXWWXwXfh9fTsjB1t0bLr6pjfsI0PeZIkQuIUrGOqiPJ8vYLkUA2TAxk1gXIw4AtczRQnxBaZgG4dogIoUh9M7LBPERTSFQiEFbFx5Vdw3RokyX0sQsSQ0QAmbANdWd+tNqTd/w1q9/7qCKDsM1wQoKNN1ywE5J4aQqmzUerSx4iFHQcw6Sz9b8pOun8QLn0JgD2Moz3x0EJHs1VZOKJesHoubPnZSB2qH0QU4INM/2Op6nH6BbIsmjUo6Zz67vTXFbK8ZHeDSBjzmM+blxU24xKrpa4xuIOEJqMYSuTQZLir3CmY8OIvvoVOJTGbo2//AINkZBbhc7DJLNHhwV8ueBzD5BVoZFRKYHTKqAuxwdhIC9RuCBmFTZNv9Ce+RZUKCcvTh1gTdg2q2qrptqTt4526JKRzo19w0IrTU2NRkvO307Zp8j6PFNeVeg4+7GloU37UW9D1ZZoH23xzSnkQlo03oZw36+UazSWGeT0mGbVQ1WkiX3Tdw10tG3RKyBkT3nLM2S39oUwwMsePG7afjmkW9pfuJcfaERPR6MdPT3CR9vrfqKs5ALQ+0WpDSWZe/QD82abbOwp/U83eEYhiv9MOGRcX1zLNsl9WB/
 /mtEWANn
 efR2y74WUmw9FC31EJCXW5afUbZeY32DjcTA3vkk5lDlLUsDkyN2sREi3q8ZmfYY9GX9XHrW4vf4qYAE0K6ZJ/BFG9UdTcPCssv9Xh7/fJuJdFH068HfW9D1tPL+SbyYaix13jyXiSM+9S7lgQzOy4Fjg0F15TTw3TGN5ZGoRmdpPxrh63AICW88v34++x37X4tSuOSEo3Vxnet88kmp2S0YW9NSesVUx3APn
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

Changes from v1:
 - Add a new patch to support batched unmapping for file large folios.
 - Update the cover letter.

Baolin Wang (3):
  arm64: mm: support batch clearing of the young flag for large folios
  mm: rmap: support batched checks of the references for large folios
  mm: rmap: support batched unmapping for file large folios

 arch/arm64/include/asm/pgtable.h | 23 ++++++++++++-----
 arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
 include/linux/mmu_notifier.h     |  9 ++++---
 include/linux/pgtable.h          | 19 ++++++++++++++
 mm/rmap.c                        | 29 +++++++++++++++++----
 5 files changed, 96 insertions(+), 28 deletions(-)

-- 
2.47.3


