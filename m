Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF37CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49E96B0088; Fri, 29 Aug 2025 07:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21B96B0089; Fri, 29 Aug 2025 07:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E866B008A; Fri, 29 Aug 2025 07:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6AE6B0088
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:53:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0534159EB1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:06 +0000 (UTC)
X-FDA: 83829634014.05.A5CB75E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9139420002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=oRWSXUrO2AARNV7eMDfGQOa2bimplrfgLITlQBTA3E8=;
	b=mAE9aGcnUAXY8dr2V3XmQ0XDnrlneBuJUMgfRz+k9coPhuiqI6/w/xIj6DaQPBqs7NfZ9L
	MNnRi04tRUlAh1JONGiJNf4hMm/AA2PzGVBSawQB675Yadolwg+Xl7qXus1iFT02GgzY//
	/c4ktXb4e0fy/LxvSBLwVY33jXq7D5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468385; a=rsa-sha256;
	cv=none;
	b=iZGIxwq+Mk7xmmXlagP21w532jb2i2LdQKfSolIKEqIEONFawE7f/Ek856rC6Jw1Z4pGwe
	2QTn3TDgbrPf/6re6ChxNuZ6er3X08zKcnHpV8OITeIEyOwEzg7Zk+l4MrNjm+WDLV2P47
	ygMBySt+LQDfw2Q2Z0wDMx1h0l2i2AM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A99A19F0;
	Fri, 29 Aug 2025 04:52:56 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 951F53F694;
	Fri, 29 Aug 2025 04:53:02 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 0/6] arm64: support FEAT_BBM level 2 and large block mapping when rodata=full
Date: Fri, 29 Aug 2025 12:52:41 +0100
Message-ID: <20250829115250.2395585-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9139420002
X-Stat-Signature: o7o45pk6fzrs5efzq9ms1bimbqzyyxg4
X-Rspam-User: 
X-HE-Tag: 1756468385-287787
X-HE-Meta: U2FsdGVkX1/+z/1g4CHeayD6G/4CkhLYnvA1d438DF7TPqKN7EagVEpeLul9n+3UXQxTOlhsQJkvqf8tkocL52GQT+leLT/jsoQWn2ODXOfd3AdKVL05PgwsIqwKXRBgaZXJ171/PN35FHj64lWxOXaS5Vfid5YPGdw2QAGLLooX3gFykidkEAtLIBPVDrH4AUvhLqGNc9Y/VxbuEuFCXutIk/TJFFe9Fb1AultAoEc7T++IPRTFbs72J1i00CG8P8TGEuMFm44M082zvs/AxOaVv8WeBtjfzEfBqUuvKfzVChGahwFvnFXm9TN6wCPY58+RzMIij4sAZPY2p8eT23XJtmWW8o71vnfwdzcG6XS+/9HBIx7uivXu+jlp+PRFBEJ6k4CYvziUi65VCzzP+XPyxw1g1YV3MRzB8TVjSWgEweEcw8EwOfLjFR3SXb5rVgZBinut/c3A63rlgscovfxWlfDhJj+jMW50ZNLcFm5g9jGyF+M4M+8bO7C9jY7Wf7/x+pflj4wX0VcI6Rw+SvXU5vJwuHWi106aop/xuTad0AdvkO0YxmqBp5tUz3Fo+5JebMdRWK+7nrtNNkCWqOqYXZSbEhLEiKdj3zNEZOQE+gZOyHUhmESWwq0UihDCEMN9rmAXURrE3nZctcmml2H7KxkpW8x4lO0/puFJ5gzSwKlkA3NOth5eRstVTaSW3D7j7HcyqbDCvDYQQWViEBQ1F9f8RPZvuog5kGLUBQrT+RpfaU0E5vLlMROdXwFetp6iu7ipyaSPMauJ4tFC59hbaUuC2uAP0cecMWzT937kJI6xnGqNBtC2TqhSi1BKc1fOB9g43mG0nsSzTitjkXMbqFfb0nMfpH59+GmRj7EgVLxpeK5mSsfYL9dFRujbTlsZ555uQeE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

This is a new version following on from the v6 RFC at [1] which itself is based
on Yang Shi's work. On systems with BBML2_NOABORT support, it causes the linear
map to be mapped with large blocks, even when rodata=full, and leads to some
nice performance improvements.

I've tested this on an AmpereOne system (a VM with 12G RAM) in all 3 possible
modes by hacking the BBML2 feature detection code:

  - mode 1: All CPUs support BBML2 so the linear map uses large mappings
  - mode 2: Boot CPU does not support BBML2 so linear map uses pte mappings
  - mode 3: Boot CPU supports BBML2 but secondaries do not so linear map
    initially uses large mappings but is then repainted to use pte mappings

In all cases, mm selftests run and no regressions are observed. In all cases,
ptdump of linear map is as expected:

Mode 1:
=======
---[ Linear Mapping start ]---
0xffff000000000000-0xffff000000200000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000000200000-0xffff000000210000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000002550000-0xffff000002600000         704K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000002600000-0xffff000004000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000004000000-0xffff000040000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000040000000-0xffff000140000000           4G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000140000000-0xffff000142000000          32M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000142000000-0xffff000142120000        1152K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142120000-0xffff000142128000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142128000-0xffff000142159000         196K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142159000-0xffff000142160000          28K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142160000-0xffff000142240000         896K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142240000-0xffff00014224e000          56K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff00014224e000-0xffff000142250000           8K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142250000-0xffff000142260000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142260000-0xffff000142280000         128K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142280000-0xffff000142288000          32K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142288000-0xffff000142290000          32K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142290000-0xffff0001422a0000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff0001422a0000-0xffff000142465000        1812K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142465000-0xffff000142470000          44K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000142470000-0xffff000142600000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000142600000-0xffff000144000000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000144000000-0xffff000180000000         960M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff000180000000-0xffff000181a00000          26M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000181a00000-0xffff000181b90000        1600K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181b90000-0xffff000181b9d000          52K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181b9d000-0xffff000181c80000         908K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181c80000-0xffff000181c90000          64K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181c90000-0xffff000181ca0000          64K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181ca0000-0xffff000181dbd000        1140K PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181dbd000-0xffff000181dc0000          12K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181dc0000-0xffff000181e00000         256K PTE       RW NX SHD AF    CON     UXN    MEM/NORMAL-TAGGED
0xffff000181e00000-0xffff000182000000           2M PMD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000182000000-0xffff0001c0000000         992M PMD       RW NX SHD AF    CON BLK UXN    MEM/NORMAL-TAGGED
0xffff0001c0000000-0xffff000300000000           5G PUD       RW NX SHD AF        BLK UXN    MEM/NORMAL-TAGGED
0xffff000300000000-0xffff008000000000         500G PUD
0xffff008000000000-0xffff800000000000      130560G PGD
---[ Linear Mapping end ]---

Mode 3:
=======
---[ Linear Mapping start ]---
0xffff000000000000-0xffff000000210000        2112K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD AF        BLK UXN    MEM/NORMAL
0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD AF            UXN    MEM/NORMAL
0xffff000002550000-0xffff000143a61000     5264452K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000143a61000-0xffff000143c61000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000143c61000-0xffff000181b9a000     1015012K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181b9a000-0xffff000181d9a000           2M PTE       ro NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000181d9a000-0xffff000300000000     6261144K PTE       RW NX SHD AF            UXN    MEM/NORMAL-TAGGED
0xffff000300000000-0xffff008000000000         500G PUD
0xffff008000000000-0xffff800000000000      130560G PGD
---[ Linear Mapping end ]---


Performance Testing
===================

Yang Shi has gathered some compelling results which are detailed in the commit
log for patch #3. Additionally I have run this through a random selection of
benchmarks on AmpereOne. None show any regressions, and various benchmarks show
statistically significant improvement. I'm just showing those improvements here:

+----------------------+----------------------------------------------------------+-------------------------+
| Benchmark            | Result Class                                             | Improvement vs 6.17-rc1 |
+======================+==========================================================+=========================+
| micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |              (I) -9.00% |
|                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.93% |
|                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |              (I) -6.77% |
|                      | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |              (I) -4.63% |
+----------------------+----------------------------------------------------------+-------------------------+
| mmtests/hackbench    | process-sockets-30 (seconds)                             |              (I) -2.96% |
+----------------------+----------------------------------------------------------+-------------------------+
| mmtests/kernbench    | syst-192 (seconds)                                       |             (I) -12.77% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/perl-benchmark   | Test: Interpreter (Seconds)                              |              (I) -4.86% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/pgbench          | Scale: 1 Clients: 1 Read Write (TPS)                     |               (I) 5.07% |
|                      | Scale: 1 Clients: 1 Read Write - Latency (ms)            |              (I) -4.72% |
|                      | Scale: 100 Clients: 1000 Read Write (TPS)                |               (I) 2.58% |
|                      | Scale: 100 Clients: 1000 Read Write - Latency (ms)       |              (I) -2.52% |
+----------------------+----------------------------------------------------------+-------------------------+
| pts/sqlite-speedtest | Timed Time - Size 1,000 (Seconds)                        |              (I) -2.68% |
+----------------------+----------------------------------------------------------+-------------------------+


Changes since v6 [1]
====================

- Patch 1: Minor refactor to implement walk_kernel_page_table_range() in terms
  of walk_kernel_page_table_range_lockless(). Also lead to adding *pmd argument
  to the lockless variant for consistency (per Catalin).
- Misc function/variable renames to improve clarity and consistency.
- Share same syncrhonization flag between idmap_kpti_install_ng_mappings and
  wait_linear_map_split_to_ptes, which allows removal of bbml2_ptes[] to save
  ~20K from kernel image.
- Only take pgtable_split_lock and enter lazy mmu mode once for both splits.
- Only walk the pgtable once for the common "split single page" case.
- Bypass split to contpmd and contpte when spllitting linear map to ptes.


Applies on v6.17-rc3.


[1] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-ryan.roberts@arm.com/

Thanks,
Ryan

Dev Jain (1):
  arm64: Enable permission change on arm64 kernel block mappings

Ryan Roberts (3):
  arm64: mm: Optimize split_kernel_leaf_mapping()
  arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs
  arm64: mm: Optimize linear_map_split_to_ptes()

Yang Shi (2):
  arm64: cpufeature: add AmpereOne to BBML2 allow list
  arm64: mm: support large block mapping when rodata=full

 arch/arm64/include/asm/cpufeature.h |   2 +
 arch/arm64/include/asm/mmu.h        |   3 +
 arch/arm64/include/asm/pgtable.h    |   5 +
 arch/arm64/kernel/cpufeature.c      |  12 +-
 arch/arm64/mm/mmu.c                 | 418 +++++++++++++++++++++++++++-
 arch/arm64/mm/pageattr.c            | 157 ++++++++---
 arch/arm64/mm/proc.S                |  27 +-
 include/linux/pagewalk.h            |   3 +
 mm/pagewalk.c                       |  36 ++-
 9 files changed, 599 insertions(+), 64 deletions(-)

--
2.43.0


