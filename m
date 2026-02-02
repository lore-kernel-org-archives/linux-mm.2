Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463E3D172B0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CE46B0089; Mon,  2 Feb 2026 02:46:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0506B008A; Mon,  2 Feb 2026 02:46:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF016B008C; Mon,  2 Feb 2026 02:46:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 480146B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:46:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED303D5261
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:32 +0000 (UTC)
X-FDA: 84398734224.23.B90FC66
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11A0C160004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wosxrHeY;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770018391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YYvAr2zSKhz9oURt6YezfDRfsalBr4ckW+gKtHKbiDk=;
	b=XF5e1bbl/lwHXcb/f+SxwfyW2XV3U1pO4FPt88Fs4E6nyiMiJ/zNxgM9DZFs7AupUHuBoS
	kZ+VsApClorGyl0F0y9yhRb3mMM2txJUf8T8S2OjF/vkznUu6dUs5vkpfckQUWk5MKDeRw
	Ld3bbkmry3lkhh34PK6K0u5kdF/bdME=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wosxrHeY;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770018391; a=rsa-sha256;
	cv=none;
	b=wouCuQVfS4X4iXlfQyKXzg0bcTZAy9t6ulKrxtdB/mK+NedZwW0+Pte6BOiz323JJX7XGh
	7VWF8CDPSl5cR9OiN6Ht7Tx1kTDcmRhVByXy87YKA6IkmV1qYBzPJ7ZO7RBaZsyy0fIJ39
	cJl5c5qbutLvZf1DE743q3QCcFM3BUY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770018388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YYvAr2zSKhz9oURt6YezfDRfsalBr4ckW+gKtHKbiDk=;
	b=wosxrHeYuzwDZibEFFnXesvD5X7Y36t3WcKsgiDyoJ2SLGHe1hgNHCCdxP+y1kkOmpUxuA
	ne4uNUPl7BldrNTKnxZey7beFJS2CLXaR6wQX3nM0I3kAsyzGEv9vQkbHRFw3xVf7CIkzp
	OkP3H2EUOnHpoEgzNH1DFhkFAlP2nGs=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
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
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com
Subject: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table walkers
Date: Mon,  2 Feb 2026 15:45:54 +0800
Message-ID: <20260202074557.16544-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 11A0C160004
X-Rspamd-Server: rspam07
X-Stat-Signature: sfdnypifhzoy7zob1eo1h9jnqaqq7wj4
X-HE-Tag: 1770018390-686880
X-HE-Meta: U2FsdGVkX18F9FUFzE30dqmlAg2uwe2lcYjaOQlN6COYMPR8UODWYrKt0tVdTT2LbqRlS+vLq3QaaNYV+LoCOnLqY69uf6n4j/k/eVy9JDMmEn8ienIBtrPtk6EsYd9A/kKY5CMBufXZLty7kZYQiwvllxsRVDd7ThykgkA+AWR+cv8ntuPqfareyXlUnl2uNk+j0mYj2fmg7spF5Qtf+8fYEubBH9mdC7RiCUVFDz1rpA0pgProRmusMtvsnv5EMIhKh5mqhSUltwLPidw9RzvVpp+l6drYRpP+1t51v+o55rB6qzsXmll4XyXrITatOUcTkcZ0cEI8lxKZO3o2g6enI3cvTWuP9Gqi2bngikjoNO/H7t/kEaBeQ2fpUvMAADyBmAAvWe6podAGyRkc/hmsA4zfBew24RP6+l7gKLuhAyE94806m1fhPE/hitoDMihj/j7ocqDe+YZNZkQlpWIzlJpF+Jqh5QrEuEcdjjAW8R5GIjWrCIjoDzX+CMA0U4oPmcXqriehfPNW8cyKuZUJJyfYjwbjkSsxB5QaaGTfFKC1Xa64occ0B/OW86aJPk+T7yvyVddYCv2C2EhvyAtpP0ISuJQdT+6lCVbSwWEgWLT5/HW4fpDd0Qlgc27r/rN5FxvKq0El0bNdLhY3M+nZuhzhbq2IVHE7moqWKKRBgHFUXWGte6zzaR9/GWz4sonKkcJe7rI29StfrzjTG15yg8hqGf5R6bpuulKY04VJgqHjyJ4UgVkCOWtk+qDJoMUikrP8WWP6V8xPVouzcCYpc80jzOBJ0uneqGGjZffzz7o/shGeK9bnEUoJdYA/3bAUckBC5SjFuB6SgKYwtwxa3wZCxzIyYUeLLZrlWugGMOiPWZEvmRoeiZ5tRg/Yc2hb09ZoHjt/mcfnGSMPbWykQmE4WyBgxFVjl2eNMBVAHO2PjCM3GBDuqEn19XgzNqnlX3kSRPmM3ZH6BkU
 ya0n2mMk
 oCzsdmkAtmc6CpwmloV6OTI85B+X7C+z3+W4mK3/su4kaBKyQfq+bO+VNelAIMqZwydsf3cU/3fY86OplvQCEvz63N+pyN873RKO75fNiRLGY9Y5XzYFMrLU3qqqyeRDfREl2rcy6mK0LGJYQ4UDsG65wGsWw+O8JXH4mk4di3/DNWtD+J8lkYyUtIujnLg/B6IaaennmMNKAps0Vb6no5r1U8rcnrDx9J10D/OFsJJVxoTaGRfgF27jjrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When freeing or unsharing page tables we send an IPI to synchronize with
concurrent lockless page table walkers (e.g. GUP-fast). Today we broadcast
that IPI to all CPUs, which is costly on large machines and hurts RT
workloads[1].

This series makes those IPIs targeted. We track which CPUs are currently
doing a lockless page table walk for a given mm (per-CPU
active_lockless_pt_walk_mm). When we need to sync, we only IPI those CPUs.
GUP-fast and perf_get_page_size() set/clear the tracker around their walk;
tlb_remove_table_sync_mm() uses it and replaces the previous broadcast in
the free/unshare paths.

On x86, when the TLB flush path already sends IPIs (native without INVLPGB,
or KVM), the extra sync IPI is redundant. We add a property on pv_mmu_ops
so each backend can declare whether its flush_tlb_multi sends real IPIs; if
so, tlb_remove_table_sync_mm() is a no-op. We also have tlb_flush() pass
both freed_tables and unshared_tables so lazy-TLB CPUs get IPIs during
hugetlb unshare.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/

v3 -> v4:
- Rework based on David's two-step direction and per-CPU idea:
  1) Targeted IPIs: per-CPU variable when entering/leaving lockless page
     table walk; tlb_remove_table_sync_mm() IPIs only those CPUs.
  2) On x86, pv_mmu_ops property set at init to skip the extra sync when
     flush_tlb_multi() already sends IPIs.
  https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/
- https://lore.kernel.org/linux-mm/20260106120303.38124-1-lance.yang@linux.dev/

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

Lance Yang (3):
  mm: use targeted IPIs for TLB sync with lockless page table walkers
  mm: switch callers to tlb_remove_table_sync_mm()
  x86/tlb: add architecture-specific TLB IPI optimization support

 arch/x86/hyperv/mmu.c                 |  5 ++
 arch/x86/include/asm/paravirt.h       |  5 ++
 arch/x86/include/asm/paravirt_types.h |  6 +++
 arch/x86/include/asm/tlb.h            | 20 +++++++-
 arch/x86/kernel/kvm.c                 |  6 +++
 arch/x86/kernel/paravirt.c            | 18 +++++++
 arch/x86/kernel/smpboot.c             |  1 +
 arch/x86/xen/mmu_pv.c                 |  2 +
 include/asm-generic/tlb.h             | 28 +++++++++--
 include/linux/mm.h                    | 34 +++++++++++++
 kernel/events/core.c                  |  2 +
 mm/gup.c                              |  2 +
 mm/khugepaged.c                       |  2 +-
 mm/mmu_gather.c                       | 69 ++++++++++++++++++++++++---
 14 files changed, 187 insertions(+), 13 deletions(-)

-- 
2.49.0


