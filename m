Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC05CDC173
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F046B00A3; Tue,  6 Jan 2026 07:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD146B00A4; Tue,  6 Jan 2026 07:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29CD6B00A5; Tue,  6 Jan 2026 07:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C59B86B00A3
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:03:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85A611B82D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:03:17 +0000 (UTC)
X-FDA: 84301403634.11.EF6982F
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id D737C120017
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:03:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdzRBVLv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700996; a=rsa-sha256;
	cv=none;
	b=1iKy1QwfDc6W4HXVyTTM/HYWGuPOFqWdGll4ploL8xtMhu6Pulna62/2UPy2qKVktgvTiF
	up7fnn7ahuaVTuGOoxvrMkJR09nqRoPL3ZfhhzhyV0TpR746LzeO7aFokcgYwKC0lPWPKK
	rA+EKWjtk27+vFrplyFVTR6b5BRcu8I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdzRBVLv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iklw0RInONOSh+e9xelR5uEAOvlruMIvuc7amxeOT2I=;
	b=a7ZSpmV1GOsNakyqG4Y6rXXXLNbQp9KgX3hJT5l75BA9SVmjEkiI37vp1bUjb7PBzJpxrZ
	CxAie8xV1bxdp2eyB17jY1uTLZMiNR4e4LXRox7oNNRJnLcjZJpHNJZNCixjaX3VPw516O
	ZQGB2LP3+oOMvVyWJu0e4n+VvJ+LKX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767700993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iklw0RInONOSh+e9xelR5uEAOvlruMIvuc7amxeOT2I=;
	b=kdzRBVLvNh8jbNQ59PhwNwBz4pfvxAXmnXMGo9B2oaSAsbzuAsrs+BYB75BRamLHGE8OCb
	hf1s5SBgskmqMmdkwiWDDkI1Apoa/QMuMicJOLZ/aSx32ijPVk6KHcwfjBgGnwT8S86Amz
	iUAvdmGMLmr0DxBDKwYjPDSG+VmR+Y8=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com
Subject: [PATCH RESEND v3 0/2] skip redundant TLB sync IPIs
Date: Tue,  6 Jan 2026 20:03:01 +0800
Message-ID: <20260106120303.38124-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D737C120017
X-Rspamd-Server: rspam10
X-Stat-Signature: xo34wo8pwpmpjdkrsu8p5ktnxw1sran7
X-HE-Tag: 1767700995-7843
X-HE-Meta: U2FsdGVkX18m+vFxSsN9MGihnDWlKcjzaW0kFTZkkRWwes5nmAi9a2le0FlDZpkfzQtey4pd/i+R6un0GcH9H6YVCvEfh/OOTi4YxhfPShKSWikwvwjNp4+SD1fc8pyRmkXFaiD5xFOSE0aF+p8BycKP6G5AaM8X+XSWZDU/DxHg5toZrX2fg3eZHKfk5kSICmAu46lVlYk16fXJ92HMFm1Lesxf2MekSmC7wpJ5N6nYVaffhDdHoxbKZAHys6USds6Z//DEoFQJjn0RFYbPLSA7qhjMCDVaC0c1TFdE0kczAcgPyW93Wegaa46ydYXkACBWUCwD1rsi8elmZNxh13+6HVEaGPj6+4jbBce73FFc2RKqo0rNEzc+SOy7xqy5E4uMLoEeBA78qdU2Apgkj1dIJ+X5jX/BEZNAvNfhjpOcMUs5fOhdVLD49RC8kimO8uHxH5Dj6XRoKPdMw4+/5LYR/+6ZCnewiojJzTF47EPdWLvL9NwuTrzAOyXtcAmMlMCIbH4Uht3O8a2ZqGAjQAccawZfP9rYOQVLdNx5G7FOQeIvgjnJSXWUjS2VEsKDipyfNWBpo0PbvNmyt4opSR0zx8rJrIS3u9LKTFnxVwVhoDBuyBvsLoGLC57ye+7n92+iUAaEoP8HgURz4rXitoQ1+Ai8SypLEP1iVzRNCVFv12kthXEIjMOe0DFtn8GTVSnVaHQie6tzrz/T8u6eDX2tc0fnPGm3w1zu+nT//zqpXZJtNIjLC86cHNb9iMLAg68MQ/8QIYRX3BPi1qb35rPtXxra/JNPVdfBsbulk1AB7JbAXUTKagaFfINOwCZu6GoKs6ZGNq/PYidutq6yAf6kTtHOVhgpQKSyngQqpOzek7FM7pU74EGQub2kQkIw3+x9XGcOxOX6K/wXyYlVMoSDWOcuYE2e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

When unsharing hugetlb PMD page tables or collapsing pages in khugepaged,
we send two IPIs: one for TLB invalidation, and another to synchronize
with concurrent GUP-fast walkers. However, if the TLB flush already
reaches all CPUs, the second IPI is redundant. GUP-fast runs with IRQs
disabled, so when the TLB flush IPI completes, any concurrent GUP-fast
must have finished.

We now track whether IPIs were actually sent during TLB flush. We pass
the mmu_gather context through the flush path, and native_flush_tlb_multi()
sets a flag when sending IPIs. Works with PV and INVLPGB since only
native_flush_tlb_multi() sets the flag - no matter what replaces
pv_ops.mmu.flush_tlb_multi or whether INVLPGB is available.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

v2 -> v3:
- Complete rewrite: use dynamic IPI tracking instead of static checks
  (per Dave Hansen, thanks!)
- Track IPIs via mmu_gather: native_flush_tlb_multi() sets flag when
  actually sending IPIs
- Motivation for skipping redundant IPIs explained by David:
  https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
- https://lore.kernel.org/linux-mm/20251229145245.85452-1-lance.yang@linux.dev/

v1 -> v2:
- Fix cover letter encoding to resolve send-email issues. Apologies for
  any email flood caused by the failed send attempts :(

RFC -> v1:
- Use a callback function in pv_mmu_ops instead of comparing function
  pointers (per David)
- Embed the check directly in tlb_remove_table_sync_one() instead of
  requiring every caller to check explicitly (per David)
- Move tlb_table_flush_implies_ipi_broadcast() outside of
  CONFIG_MMU_GATHER_RCU_TABLE_FREE to fix build error on architectures
  that don't enable this config.
  https://lore.kernel.org/oe-kbuild-all/202512142156.cShiu6PU-lkp@intel.com/
- https://lore.kernel.org/linux-mm/20251213080038.10917-1-lance.yang@linux.dev/

Lance Yang (2):
  mm/tlb: skip redundant IPI when TLB flush already synchronized
  mm: introduce pmdp_collapse_flush_sync() to skip redundant IPI

 arch/x86/include/asm/tlb.h      |  3 ++-
 arch/x86/include/asm/tlbflush.h |  9 +++++----
 arch/x86/kernel/alternative.c   |  2 +-
 arch/x86/kernel/ldt.c           |  2 +-
 arch/x86/mm/tlb.c               | 22 +++++++++++++++------
 include/asm-generic/tlb.h       | 14 +++++++++-----
 include/linux/pgtable.h         | 13 +++++++++----
 mm/khugepaged.c                 |  9 +++------
 mm/mmu_gather.c                 | 26 ++++++++++++++++++-------
 mm/pgtable-generic.c            | 34 +++++++++++++++++++++++++++++++++
 10 files changed, 99 insertions(+), 35 deletions(-)

-- 
2.49.0


