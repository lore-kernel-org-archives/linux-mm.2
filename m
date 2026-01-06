Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4BBACDC166
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D1E6B009E; Tue,  6 Jan 2026 06:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423386B009F; Tue,  6 Jan 2026 06:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE836B00A0; Tue,  6 Jan 2026 06:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 140966B009E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:51:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8E098BF60
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:30 +0000 (UTC)
X-FDA: 84301373940.11.2AB2D2C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id D95A62000A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:51:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e1LM69EH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700289; a=rsa-sha256;
	cv=none;
	b=lhdq7UXrRD1IMm41gswosR4tC3aIJ9Bfk+G2b4AbQMnASVJQoB7k1m49qRb5LAnkl4IpH+
	u4ums/2oNpIB+FgfBEpECRSnGIRgen9wfrSsey+cJDyuuIxvT2zDnjcK8CioayJn2oYqym
	3jJkz+Ii0UurWLOZJRGXD//Qkr9FeJ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e1LM69EH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iklw0RInONOSh+e9xelR5uEAOvlruMIvuc7amxeOT2I=;
	b=a/J1AYhWhAA+GtpZLg4BLRoh1aTVa2wcDQc7SD/OU7Lsp/Kjk1O/WcQ2uR1/YZDCO+cv8I
	uVMkU7v0thTQmS0ebS+9tTooIu/GG/4gpTBVutPJBavXtuLkXa75R+xNhubRrGYg8H5WT8
	RRRko7c9t77A/C/ahwLBFviBNp0/M1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767700286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iklw0RInONOSh+e9xelR5uEAOvlruMIvuc7amxeOT2I=;
	b=e1LM69EHdQpzC3zUSFx18F7ADHBf3b1Hls/i3QoR1He+c2eOrmtGPTw7XCnpLwoyBEEjZ2
	T2OebBCEnpsLQemldztcr1Af3povcEeNa03S8f/agpusP1CwenaOpdY5ODQzmvCFvjIkm5
	pzp5LKhTFWROjxnbIIWVIXpmQInyeJk=
From: lance.yang@linux.dev
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
Subject: [PATCH v3 0/2] skip redundant TLB sync IPIs
Date: Tue,  6 Jan 2026 19:50:51 +0800
Message-ID: <20260106115053.32328-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D95A62000A
X-Stat-Signature: a5ft549aajj6xgrw1u6t6chmc7wpmog4
X-Rspam-User: 
X-HE-Tag: 1767700288-59035
X-HE-Meta: U2FsdGVkX18t7uo95hvc3KWfu3oKlYWqaSzYP5deCMuzEIWIFdveYf5UkXpn5bQu2UsnNUZ1mhbCWScMNYz6NEZ18iWVooRceyLQppI+gCaghaCE9AjvPgogxfVoeUHnBM0Aco+vVu+2A/oL0zP/ke3txOGzMoAct5SBx/VA+ucJefqQ/CPUmdRvUfCOpYlgfamhvTNe5wW4HW2GFhSxP5X7eKgIjzcYsT1+9wVFdv9EBUnnRackxkt5qSzhyHhOIPWMpzjbSqZl2/ssDyI9wfnxZc/frHcYyqT+u4HkgLMzs6M1P1PT6i3vBPBqxnZVf4b8EORF51/0vc6zX/wnhHGwp1KqGSV4Kx5/Cf1OaIAL+hb5QRIeBZMgGTV8XMkWi6gJgL1kHDJv3/HH1ijrwD9W00nI5c+9g4C0Dw8d4NYSW1qLp8FqlZRw7Xes5EEk8m48oYChzfdirfKGnuOQph+g2ac4GRBJ0lTWcXKqDWtv2+iDZR+BlhJWq63xMPcGsqZRz9JC2Z5aMYYOfI4QoD6wBVGgT3u/6wtHTIOSmx/APZuK3tqMYJS5qt7j3XU8wB4wtyryDr37lwN4VMuA14JIXXNk09ofARLSVxGgfr9cu3dPp/ijcd6gyr0VisGlwukuPFWmlq6hQXJ1Dd4uRJ+bhG837zKrv22Zso47EAFLFsKekH3Iq3MHrSiQxqfz4F4ihImJCifC7vWZ23WUf0P6yMGPexTp+7qeNWMaAJAMPc0fO/lO9T4rIFbE1siO1nMRF/d+t0NXC1NTgK7hpsy0W8xkSvGeKQzHFnWiNGZhW8iPIGSUtlQ6tfSsyGeGXgq7NQ3Z4Ee6PULAjVf5c55M2DV/EMA/r6G/K6p7oFbQrCy6n5jcegiwqQIHGGxQ4BddLsdHDWnV4vara8fR8HTR8IVgYoJiu4/fPcZbs0csZsxFYlx6we+/tCt1M0w4ulq4IytH7f6yhorZRBo
 OQmPCEAh
 AHhvPrRIOq1d8pioOxpswzNQakkCTSq/J6BeblGGhBwgbX9b4g30HN+/ATljB3OgNHxO9L1SrDEUC4whLZ3uxPa//I9WYkUisFq97B1GcDXLOPt2zSvl6Sdu9WWbN+V26/0bavzWlcibLgRloch5hzOtSKz/UDoTHdk+l7doO0pvJ2tC4/8h5DRIIW+nG63ciRKmlALmHl3XJlyjsWSj3Y8cZimBF26Z1Rr2YFgcAZmsjNlNrechkgWDpCA==
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


