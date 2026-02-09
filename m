Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DB6E81BCC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398696B0005; Mon,  9 Feb 2026 09:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3366E6B0088; Mon,  9 Feb 2026 09:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CDF6B008C; Mon,  9 Feb 2026 09:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17E276B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9A081B1BCE
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:44 +0000 (UTC)
X-FDA: 84425096448.30.9B77E93
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1DCE6140013
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oRdMfOyh;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=k1HUXViArmspO18Ot//s5xhWbkVXwA17QN0XfFUufik=;
	b=qBUZ//WtrWXM/M4jeAbrFKpku3NmMBKtf8KflSc+1Oc8yjqb86k9Um+p/YA6+cquqyi0h1
	y3eTNLyPJu2FGFBNB7m+YS/5+6+5DQArEOynQuke+twVO/+/n8+wKUFRzO+41ayDFmNS7c
	VD7pljkUPXcUwCpLA67cmcILvNJ9nJ4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oRdMfOyh;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646063; a=rsa-sha256;
	cv=none;
	b=ysHF+SxvDWJBdoTD+XcYPRso0KDGW6ack0eLW7V5CAJli3W6bO8rKWwQDu7tFhG1ntAf30
	SZXQ8UucWKTvFRNLnbWCfOP4R3YJSXnT5giQX3nq8TWkfudMR2SxpP1bB7f8jE/FNW9KLO
	1Nkg4UnTPDcu3i84lLh/nKYzX4Tbgl8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646058; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=k1HUXViArmspO18Ot//s5xhWbkVXwA17QN0XfFUufik=;
	b=oRdMfOyhmrBJ+saGIpSykLoQptpgrG4pXwbC8gPkqsfMcbVfEoJ9tNw3LW+PQAzXMjMTlvErZX/1prABNbApPosjaUApIO6K21xk0cv0pQGfCGIOsuCgd3Nwrt6UYFK8efWzmi4jp3DeiqTzKaWicQCdlIWYzI/DCAn+nrbsXZI=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WytOcor_1770646056 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:37 +0800
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
Subject: [PATCH v6 0/5] support batch checking of references and unmapping for large folios
Date: Mon,  9 Feb 2026 22:07:23 +0800
Message-ID: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1DCE6140013
X-Stat-Signature: jm46ape53w88br1at4webbbz4bhksyuy
X-Rspam-User: 
X-HE-Tag: 1770646061-402281
X-HE-Meta: U2FsdGVkX19Ub3XZhRjqWAKoApnnDACE/U3DjelcUJ/I1Eq4vxdZmpEtL2wdiBLSPGuI7MVW7Jnyn53+AnofhLVviejqGOBKvz2QoqrXOZ2V4j28Z36WbCvTvrk23WSmE/38tUnnrgge50KhnrTy5yN1RbhX9sO+9bNOrSF/azendiiorZdvOe3GiWKuha6eyBWl14XaMGqkGtmElgv/zRQr5mGolc8spFVO4behTe6OR+cv3ekhBx3CSGc2bTv636nsY8HC4uNJx8ZWU+jMYi1druczy01VAgSzASKMWfCmfV4+Bv/6v/jmzs4BozhXA6pLv3lnuFtC41BYNIu0C760Mb/q3cVb+QKZ9rsPMBav0RFlhLyZCS5hJw7bOeuso0qTSUfZkVR3EwW2V4NuDNk33Oi64W3eu61cT1UWcCJKJQi2qkTzW3GlNpDUj1LfHjsP8W/wSpWDfp3TUDAESFCFuUgmun0qTCntBer1diTS5GVZylGfQYsgZ8CpTVfkSgP/NEtWDvAa1MYpTqfjmDX2kYbAu1i0OV4VWXiFdY1Woc9heJm284bJnykufayHIdyAvba5CgMaH1rKia5i4aEVy8/+pE7oQmIkpifLccYUBize5kAFtPHk4pfudqGtxG29k1QcODQ4j/a716v/rd7fI0v+JvpGwIXCfYnUJjJDPT8+mvkHmDucp8RP3HM2LrGz8A42vq8JUAyjjX9UbI9HvO2Hqc8+D1G541TLGoFTcYdG7tovTvNYre6mL6zcHZEWFPEaj7kuBa26zgUgabRAprB8RP1NBG6jWi9bCcsDMlRJG+CMedzmlUCUIHQb5VqfidW85eoxTBJLncB7DbfKFCpMqF7SE7M21tH+GKNpuN3I2bY23noBfvqTQJlwKs9q1HsE3ShQURz2xU8t/pcYVnTCRNJYuBKpXQR8D9d5dab+97VjqhKVLieIpSmQWuQthGjnWkfFlftXplw
 wEAGy0/P
 COVr6qGkcmMzKVsol7sNl31tafmpxcdoiru7yIl0eMcvibU9XQQ2CHqGX7mvWOo8MXIHJgXRN6KSfoNbFP5vWCONlXLLHLPwrS0A5xP5P069Zkr0m01Dc4yyK+mn1WzkhKSM2Cbt/A9xudEhaHpLDjZINQPccrWhxqlSn02CrQo8c0lw6aAObtAJp4WdxwniexEGgvdzs+Geg1tL00FTA5rB1QBVp6cETN6grc/mFQoL6De0+sLCilTO9ITLQb7n34BeYDVYabInuo34=
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

Changes from v5:
 - Collect reviewed tags from Ryan, Harry and David. Thanks.
 - Fix some coding style issues (per David).
 - Skip batched unmapping for uffd case, reported by Dev. Thanks.

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
 include/linux/pgtable.h          | 35 ++++++++++++++++++
 mm/rmap.c                        | 38 ++++++++++++++++----
 5 files changed, 129 insertions(+), 38 deletions(-)

-- 
2.47.3


