Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F02FE8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A3C6B0089; Fri, 26 Dec 2025 01:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D4A6B008A; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F2F6B0092; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1C916B0089
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87AFD1A0B5C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:14 +0000 (UTC)
X-FDA: 84260592108.27.50455EB
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4316B80010
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hApe8sxZ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729293; a=rsa-sha256;
	cv=none;
	b=L+mr0dzxd4jpCAXG3yB7eC7G2H6sh1pz0mC2/BHD7smHtIvWFsod9Y8V4RpZ8EtyC6Z2Pd
	mwScFZ35Dz0yZRNVrEtvLGu9Bi2qAEY8O+EGwK8KNDGICc45ymO3Ggf08XqdNHQeWH+j5P
	MOroNiZXU2leYKhd5Skc/jqjjtcOBRo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hApe8sxZ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2dDam6/A7wKLN/SEOzZ9mYQr/Agu3pyZVWIzX0An9W4=;
	b=u76UVC0w7X0fbkXjOpHsgBfiPmOL3NyU7FBT5NfjcWBijh/4vHmpmkIqDwJFTyrXGgoAu7
	Rmztmb/JBFYbK6KbvLhKNmd3tMKByppE0XHG/yRLkoRDrIOUyI5FATlqhMK8+DkWH+fH/2
	iwAFhmP6nFMPyczMRXVd6g0n9RlvLSU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729288; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=2dDam6/A7wKLN/SEOzZ9mYQr/Agu3pyZVWIzX0An9W4=;
	b=hApe8sxZw20wfr7EDf5qRJ5qaAPA9yO45g2ygo/oA1KmYMojB2B+4RP3EIsukyY6m5xyw/6mtftNxzbR2asDf5vEQMBkfufh9izcZIFn7OjArGCpq4KGkJGSy59xTLAX5Ief8cX6bh5vRuU/tu/YjwYg5EykGzbuF0ajcEcF/nM=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvgaV-U_1766729284 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:05 +0800
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
Subject: [PATCH v5 0/5] support batch checking of references and unmapping for large folios
Date: Fri, 26 Dec 2025 14:07:54 +0800
Message-ID: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4316B80010
X-Rspamd-Server: rspam10
X-Stat-Signature: x8dzoic91jhwnrawqiwnthi3uihbwprx
X-HE-Tag: 1766729291-925454
X-HE-Meta: U2FsdGVkX1+8yfXJCZRN+41XnZZLaG+ITOYzOHwval/THdYMlBf6N4zY5wUfmsEQF1JNWpXixX8XJsjwEszy/L/6eZpgeTyRL0QwYYCXx+L0vBM0WElKpp8iFHjT8n4KIx6COF+XVlp4EDTdoW/8wXQZCf8ig13OZQvbM+Dr2jTCHXVmgchcjztDwMY3AAgi+rSZxqOmBHVg565hpRf750T9fKIOccOUMvXHJl5lyCIBm6/pfOHuzzlNGf+fydMU25UBufrHjMrmte9n19bHqtYggeDeu0EuaCGCZhYDKKcaH54g6ofMOQHlJr8UY8XhtS1hWDGiq9Qwb22kc9czPmqNzTAmlenBD3DGfrU1QkxfmP6rdtlY8ZourMnpYfyKHQMAEgsqaajqJJnP0HqQq01ARlDXwkrKaBpWHPU4fOIu8zzSI/6hRrofbuRvLHwRNrEbmBUnEfgVtkyuhoiJnK+Mi609e/YdavbZyd1QT49qufcH3rVm4948OJN4T0bsK1K+AmR5qQzIurz8S/yBJCAT3j56yGulR8Y1u0Uw8NSb4yWSIU+pEBpOdQkxcXFia5OD+3yu8waXNKkjwJ4Ve6Hrp+1b7e2ST2CpywiNB1WC/JW6FNLxf6/TKty2jvcLMxnA7z+Ljmb9JPBG6ukoIB7xqYRD/TerwEUo9yjGLs3oBlF3g55V7N5utUlxzysySmwJI07PGuxgMzz/tTf/d6LWuT/fpeHsfa+w+Fdo0IMKhKNx2qqcAgWxpsOm4t7pLkygv5PLOAGWSoq9lL2PVf+8FH0k+5/2Axzqp99I7FyZqV09vqXS3r0Vm2KjStR81gijoIloUJOJBfenMcy4CkP/2l45ersVE/UmtGifIuj03vA3dldWeMwS76vich+NOdIRiHrziLiE3MUhj2QMNS3XoO8Tw7agjEkzKPhwoIsUZ/CA6VgQzGRFzGyYNU7LyEzUmxircb0LJ/AKThf
 +bGI0Z1a
 ftEX+RJD6fNc42yg56/4d3E4sfRybziv1++MaQ4THaXxDGhvfDfoyI0bvB86cWunNnZ+E15AS3RR2rQAiywdyOlTr+pXCM9rVAJh4RgcfXwAXZNi6/RdOr2udoHF7sTdyK6UA6GZiLf2rvMtwtmZcInTsR+FT5g+kSbpZeEpbdMKkHnzyWWQeaP8mSQV6M36fSU2uDxpHfFqDBUGzVgYd0XGKf0GLF9PA6LucTtGwctEoSQ7p19YUP3oAfWOwSOK2TEMtklP/pjgUkS0=
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

Changes from v4:
 - Fix passing the incorrect 'CONT_PTES' for non-batched APIs.
 - Rename ptep_clear_flush_young_notify() to clear_flush_young_ptes_notify() (per Ryan).
 - Fix some coding style issues (per Ryan).
 - Add reviewed tag from Ryan. Thanks.

Changes from v3:
 - Fix using an incorrect parameter in ptep_clear_flush_young_notify()
   (per Liam).

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
 include/linux/pgtable.h          | 31 ++++++++++++++++
 mm/rmap.c                        | 38 ++++++++++++++++----
 5 files changed, 125 insertions(+), 38 deletions(-)

-- 
2.47.3


