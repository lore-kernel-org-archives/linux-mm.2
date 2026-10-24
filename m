Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A42606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RXglNm7P
Received: by kanga.kvack.org (Postfix)
	id 7C50C6B0A8A; Sat, 24 Oct 2026 07:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 775A56B0A8B; Sat, 24 Oct 2026 07:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2DB6B0A8C; Sat, 24 Oct 2026 07:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2CC6B0A8A
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:22:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9274CC02C9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:22:36 +0000 (UTC)
X-FDA: 85357281912.12.AA9459B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D61AFC0003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:22:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXglNm7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792840954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=awFUVFQFl2aokNrGILbfhfi1yrW6BY6+nDPRstEcjbo=;
	b=Dq0SI7h2kzzFx4XxE5a/Ax714UrpHbpVmxlP9IK6GzBFYu4cFaQLi3PDCNRRTzlLl5tNCE
	VJzW7Gtj0dfadWJ4RXYHkIjjZfxsNWA8I8ifR3e3q7/OQx+sqzEn6X4k1QeaX66jJJdMz5
	kQSC9Du/toJL0DYqlJCHPBQ7Uy+f1Dc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RXglNm7P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792840954;
	b=jvbeRuHlE72DvrMvquz/g54Bauxyb4JFnQZJr/h1Wqt9allDzU4AshZ4osntMYbfmVdWyc
	bJ26TYP6UYVxAfKypHlBdOPS7LHFjfymEE7tvFN2q4w+gqOoIiETHI6GueDzNFbAR/F+Nw
	UVEZeCFcu+do+WfwbupBdxAK1JpRhiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2308940347;
	Sat, 24 Oct 2026 11:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD601F01825;
	Sat, 24 Oct 2026 11:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792840953;
	bh=awFUVFQFl2aokNrGILbfhfi1yrW6BY6+nDPRstEcjbo=;
	h=From:To:Cc:Subject:Date;
	b=RXglNm7PSqK+gxnjmBhH6zN9XHL8sHDAwLcyOhjBO1Z/qvEs1vhKvZM6BycKejIBk
	 6fq35rTu9zHyUWxolLBrmCcwDPrgDdW1Nan1++050Mp49dE33VoPdP4WROfkMDxXFB
	 cjqAPxffvvR6+7ewkn8fuHS20Myl4JKrjG/htIfxY0iRHS5rRauVllLbS9iQm+lErm
	 cCoMeFJcHiHRxKbNgf0vH2vBEhYB2F9u2agYLOinlEUDtydeOu56mZkm+zEC9zbdqj
	 8Ri6lNcoms4TPkVJAKHhS4XtIFZKR27KpvdvXRmSfHtAv2SZ+LslzLrzz/6PO6wLMU
	 u7878apONAZvA==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] liveupdate: updates for 7.4-rc1
Date: Sat, 24 Oct 2026 14:22:27 +0300
Message-ID: <20261024112228.3384682-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D61AFC0003
X-Stat-Signature: ipmqidcf66x96cxq5t8jdte9ptza6o9z
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792840953-104856
X-HE-Meta: U2FsdGVkX18aP9D+nubo/A6Tu416yseyxjU2aVjJpe0BdoOH94kj663wQ+EuniT8Cc6DTbEhOa36L5F0q1imH4mdtvl/caCMRxue6c0lZGAEnt/4OjL3z0tMuNT2ynHYKXgEGLdaM7SzbFCl02CYiIMMjYsJ+MpVWcJL4j5ElC0fyHylAM13TJMuXd78y2tkOxux3KVu7ABzGfpFIgb81ufZJkq0w0BMqMr4Nwb7+Lgm9HYrXKGx7ssWzzMlB0hE5c2M9JqStb3p5FN6CxxACwDICZ/wyQvMO2fN0bO1p3EZ8Rwr31yLbh1HfEqAl6M0rMCKJOYP44sWj+/jC2KCsjckEpl4CkwuTg11avwhujVEU/JuaOJVMUtoIXYgvCrZW3pwEjGo0mn0SczTTtDZJU9JGe8Djpc2SAKdtqAc03gcQPH8zY4UfDjToNWhFqSYOmd+Z3JQpM69PiQ0ClZAH5uo4Giyc2eSa4w2eYfxW9qAdq8+D8Qusq+qp5sO3tRCrXD58Rlyk/dJ5ZMGz+1dNt60PTVDf3ZCxi2v3AMSoAV6RdKzLvDphrOp88hjDiF8/oajYgQIFN7yc/XsmIr4IAEFdwE7wquX3xvpCuLHVa6ubtswle5NDQE5kpJsNmI8m3VEUWt5A1RwMDHgcrFSdiXGXHRFfbWEKwPOboxuwzr3WPNqx1B365/gQNJMFCkizUhJAgGNjjfyYAUvwYCsF92Mdvbw1yK2gqIbKPAjc6ZFZeky/QMWvJRA9VDpVqunr3JcO6x8tG44fMcQP4fxhjXFY1xiOdDgI7+4ccuXFZa5IYJ1+/YQ6fp0fYHean0EQWoOEJsWnh45NL+g4kScI6l6Lvj56QeoHm4N9f/xFCuF+jx7mdpgBvMDAOKAZLZGviAbuhpJZQM19VbO9Df0zkdfkDE2dKiWiHoQ5xoY8pd9oh8sQIu8JoNTRPjMiHOm3iydQObyGzwtZu54ARG
 D86+MxyG
 gCfEbZxHCBLqcO7RX0Y/K8tvdfPxpKraFKl5qUr1E0BK/x3lsGEk+zLMPY8t68D6GfABge9ganTCbZzL/UpclHv6r91yzqtt2Owu1e8DzjR6t2VAg80xEq+SgV9Si6Zidghziu1yw9q37lV9DoUhOmAR3i/JLnqfgscPb5CBjJECVfdMoZ6uMmYpvD02798p5Hd0zBE1bfKZ0i47abc6Elx4wNkakPKRXi+6bcHiv/5yaPmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git liveupdate-v7.4-rc1

for you to fetch changes up to 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c:

  kho: do not reserve empty per-node bootmem areas (2026-10-15 11:37:32 +0300)

There is a conflict in mm/memblock.c and mm/mm_init.c and here is how I would
resolve it:

diff --cc mm/memblock.c
index e6fdf95a0534d,f5aaa38cfa313..0000000000000
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@@ -2885,8 -2885,7 +2885,8 @@@ static const char * const flagname[] = 
  	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
- 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+ 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 +	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
  };
  
  static int memblock_debug_show(struct seq_file *m, void *private)
diff --cc mm/mm_init.c
index 2e55be1457385,24a53d5f0893d..0000000000000
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@@ -684,10 -684,10 +684,10 @@@ static __meminit void pageblock_migrate
  	const unsigned long end = pfn + nr_pages;
  
  	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
- 		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
+ 		enum migratetype mt = kho_bootmem_migratetype(pfn, migratetype);
  
 -		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
 -		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 +		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
 +		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
  			cond_resched();
  	}
  }
@@@ -769,12 -757,17 +769,12 @@@ static void __meminit __init_deferred_p
  	if (early_page_initialised(pfn, nid))
  		return;
  
 -	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 -		struct zone *zone = &pgdat->node_zones[zid];
 -
 -		if (zone_spans_pfn(zone, pfn))
 -			break;
 -	}
 -	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 -
 +	zone = pfn_to_zone(pfn, nid);
 +	__init_single_page(pfn_to_page(pfn), pfn,
 +			   zone ? zone_idx(zone) : MAX_NR_ZONES, nid);
  	if (pageblock_aligned(pfn)) {
  		enum migratetype mt =
- 			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
+ 			kho_bootmem_migratetype(pfn, MIGRATE_MOVABLE);
  		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
  	}
  }

----------------------------------------------------------------
liveupdate: updates for 7.4-rc1

* Several small fixes to KHO and LiveUpdate selftest
* A series that renames "KHO scratch" to "KHO bootmem" because this memory is
  way more important in kexec'ed kernels rather than in the original cold
  boot kernel and the new name reflects it.

----------------------------------------------------------------
David Matlack (1):
      selftests/liveupdate: Prefer KVM and HVF over TCG in vmtest.sh

Kamalesh Babulal (1):
      kho: docs: fix scratch_phys debugfs cross-reference

Maxi Saparov (1):
      kho: do not reserve scratch memory in the kdump kernel

Mike Rapoport (Microsoft) (1):
      Merge patch series "kho: rename "scratch" to "bootmem""

Pratyush Yadav (Google) (5):
      memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
      memblock: rename KHO_SCRATCH to KHO_NOPRSRV
      kho: rename KHO scratch to KHO bootmem
      kho: rename kho_scratch= commandline parameter to kho_bootmem=
      kho: do not reserve empty per-node bootmem areas

 Documentation/admin-guide/kernel-parameters.txt |  15 +-
 Documentation/admin-guide/mm/kho.rst            |  18 +-
 Documentation/core-api/kho/index.rst            |  38 +--
 arch/x86/boot/compressed/kaslr.c                |  12 +-
 arch/x86/include/uapi/asm/setup_data.h          |   4 +-
 arch/x86/kernel/e820.c                          |  11 +-
 arch/x86/kernel/kexec-bzimage64.c               |   6 +-
 arch/x86/kernel/setup.c                         |   2 +-
 arch/x86/realmode/init.c                        |   2 +-
 drivers/firmware/efi/efi-init.c                 |   6 +-
 drivers/of/fdt.c                                |   8 +-
 drivers/of/kexec.c                              |  16 +-
 include/asm-generic/kexec_handover.h            |   2 +-
 include/linux/kexec.h                           |   2 +-
 include/linux/kexec_handover.h                  |  16 +-
 include/linux/memblock.h                        |  30 +-
 kernel/kexec_file.c                             |   4 +-
 kernel/liveupdate/Kconfig                       |   1 -
 kernel/liveupdate/kexec_handover.c              | 358 +++++++++++++-----------
 kernel/liveupdate/kexec_handover_debugfs.c      |  24 +-
 kernel/liveupdate/kexec_handover_internal.h     |   4 +-
 mm/Kconfig                                      |   4 -
 mm/memblock.c                                   |  56 ++--
 mm/memfd_luo.c                                  |   3 +-
 mm/mm_init.c                                    |   6 +-
 tools/testing/memblock/internal.h               |   2 +-
 tools/testing/selftests/liveupdate/vmtest.sh    |   2 +-
 27 files changed, 332 insertions(+), 320 deletions(-)

