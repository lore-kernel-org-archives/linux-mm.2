Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0C1FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2606B0092; Wed, 29 Apr 2026 06:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63046B0093; Wed, 29 Apr 2026 06:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A787B6B0095; Wed, 29 Apr 2026 06:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97DB26B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:27:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C2C9C0146
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:27:59 +0000 (UTC)
X-FDA: 84711217878.14.B6574D0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B5454000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:27:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lV3ZV6Rw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qiOMTcGyS8IKVHSdlEM9HXLBl7XABulEr7CELVvqhgE=;
	b=56QvCcms6VYIJ/DxV3G9WPgI9DWirVZB/YTD47USFdYONdZwHoLLsm/n7vnOH8Qm/KviaD
	ZIGG/AOIx86rjRT2GotVk+bF7nzsJ6R3TBWb/KLx5ilcS34Zmcq2w3HM03s+FP+Wlfmxk0
	Ai9YIQ5NcQgWGxUp7hHGTkVZGdl9EWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458477; a=rsa-sha256;
	cv=none;
	b=F2loxx8VluXBwPkWiDFlnGDmE9dWWpDFwYiY1rk2ANokg/qVOkuZfIgMSdhs+HT/By+iWp
	mHAb29ER00kxYkLc7duZo0NZ2ZgdpQPJ2H4eScGVG9NU37qXtWmPyUYf6kFBxCLCKGG5bt
	OUeYcJQqvgnvvusrMxGJH7+FzjMZuis=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lV3ZV6Rw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 624EE2A68;
	Wed, 29 Apr 2026 03:27:50 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C81B3F763;
	Wed, 29 Apr 2026 03:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777458475; bh=UHBT6b3PQsNX4dbp5ITK6cbxzmXlXl+qSx4ZxL4OSG0=;
	h=From:To:Cc:Subject:Date:From;
	b=lV3ZV6RwQkLW3J5x4BqgxmN8ttA6LqRu1seHzAluQ2D86GgFtc5GbI7b9XjDWdz73
	 xkqIUOdvTaSvS973Qpn1PvkS9DSsx8Lbq/E5SIWej91BFGVmRLCOAYh5YR/5PeqSR7
	 z0Vnnh3LgeU5eIZHqFccKERW0haH/xk62312oiHo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	arnd@arndb.de
Cc: Dev Jain <dev.jain@arm.com>,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	tglx@kernel.org,
	usama.anjum@arm.com,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com
Subject: [PATCH v4 0/3] kasan: hw_tags: Disable tagging for stack and page-tables 
Date: Wed, 29 Apr 2026 15:57:01 +0530
Message-Id: <20260429102704.680174-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B5454000D
X-Stat-Signature: w3r6kfz3xzgc9f6uzsqcknh9p73ot4ac
X-Rspam-User: 
X-HE-Tag: 1777458476-648102
X-HE-Meta: U2FsdGVkX194CUshoLFPBnFVUWX2v7dIZsAUuIhZ3AqwVGj9mqZYj+foV47vI0C6Beilii65oEm9nChCKwognpO9UqmbeigZ1PtEotlFcp0fZPikQSAybAx55GzaujufK2dvFCdFlLs1YhpYD/BRK3n9a9PM1IIdSLdHNqwgcQOeTLdGicoVyO3GR0MHDST/xBZemOccCxFvw45cwciUmAbiCBPJi6JvZEgSNSmgCrXAn77Zss/TJPsrNE6YT0AGy6sQVvUOmTtFWJqJMI7echkRcatZILqpqG8pf9qJKrbRzIZEH2+U6aRSqG0v+X5xhKfcJ+vnBMC92QGcs8PBK5BhkvkRhUVOIA+3CQfxlyxLE/b1O9JUCmtKEz+a2G0bWyXXpJ4RgPvUWl1qCav1O/7CZYYLLQFKT6g1ta+qhs5xoja75hHY1f+tKla8Absp2+eByowhWAOuUqY0JkBC7OnnFNsjJtgpm3X1c9XZuVakmW2EULn7lHUdQrb96LftJKFDtD/R///D89RlR8WGRtOopqGjNbc0OJ8ty6r9RdPkqb8DBr6ppMZZs+5evvK8C8EBPFiJKRDv/v5u3cxF4irgnXI5dgeNU/UfyfmHzUy2/Cng745dY9H/fzkgcEGOcvjeVpaj1CJ8vB+nq/XJ+FL6i9R1Ttvtyan+A34Q1NYW5ur3RJWUz/mGxlcuMy64ELC1MDdxhB+6gaA3c4i5lXI2HX1zJIUo4maJTmAzJsEzIK5vVzTvQxihf6dIesRvdG+wLqKhqOUr3QZyF5yyXvHFKYh9IbAuuOGrj8bc8htG705ViZeMVSRk8bKrcBiWypH9iYnCGhf96iFnB1SFEqg0kPoFhb0Zz5rM67I6UJDBp2Qh8Bry19oBXkNAhoVgPFDB3vXWG2mcfMriHKWir1vmR38aLGgahYokR/TJrJXl5dU+SMb6dkzbk66noUUcDdgdi/hlkEm+IdunIKT
 kYsT+CCE
 CcS7224oX9sq1wYTDq44gW1mHWL9sia+SUp4bc7E64xZdro4lBftISPR07CnEAYD1WdShNBwx8Lkqv7EYfvAvLfTFFEtg47SrmA9j3J+vzhhRGfnf7ToHEIJMO7fFiDsAI6vOT61zMoa/CSslvJ37uf2JcASyC11S9NbDaAhM6ovulSKPx5PjT2HyZ2z4/Nx4rs9DM3BUUKVPtfKBnCevKPZ+/faPCbqtn1HY6K5gOfnZL92Pxtr7UUHTpIWUakx4eEdw4PVLIRN9SCxPzf7pRNW99c9Ylu7eHgoz1kKU6K2DjtlwojhY1XAIAkm5a5WwSX6zmyEHUo1O5zvou2PghpGeC02bZwSTwf6+NMpkswH93ZtLMQ/y6GDh1/cIbQzpWqK2EYm3YoPa5riRy2X3KHWAukAXLYL6gdVFae7AbJV5R0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stacks and page tables are always accessed with the match-all tag,
so assigning a new random tag every time at allocation and setting
invalid tag at deallocation time, just adds overhead without improving
the detection.

With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
(match-all tag) is stored in the page flags while keeping the poison tag
in the hardware. The benefit of it is that 256 tag setting instruction
per 4 kB page aren't needed at allocation and deallocation time.

Thus match-all pointers still work, while non-match tags (other than
poison tag) still fault.

__GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
unchanged.

Benchmark:
The benchmark has two modes. In thread mode, the child process forks
and creates N threads. In pgtable mode, the parent maps and faults a
specified memory size and then forks repeatedly with children exiting
immediately.

Thread benchmark:
2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)

The pgtable samples:
- 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)
---
Applies on 7-0-rc1.

Changes since v3->v4:
 - Sashiko noticed: https://sashiko.dev/#/patchset/20260424130157.3163009-1-dev.jain%40arm.com
   Fix this by honouring vmalloc skip via GFP_SKIP_KASAN only in HW tags case,
   to avoid unintended skipping in SW/generic KASAN.
 - Instead of removing and adding GFP_SKIP_KASAN into gfp_flags, simply
   call __get_vm_area_node() without it
 - Update GFP_SKIP_KASAN documentation
 - Put missing SOB by me

v2->v3:
- Directly skip kasan_unpoison_vmalloc() for GFP_SKIP_KASAN in patch 1

v1->v2:
- Update description/title
- Patch 1: Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
- Patch 2: Specify _GFP_SKIP_KASAN in THREADINFO_GFP and GFP_VMAP_STACK

Muhammad Usama Anjum (3):
  vmalloc: add __GFP_SKIP_KASAN support
  kasan: skip HW tagging for all kernel thread stacks
  mm: skip KASAN tagging for page-allocated page tables

 include/asm-generic/pgalloc.h |  2 +-
 include/linux/gfp_types.h     |  6 +++---
 include/linux/thread_info.h   |  2 +-
 kernel/fork.c                 |  5 +++--
 mm/vmalloc.c                  | 13 +++++++++----
 5 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.34.1


