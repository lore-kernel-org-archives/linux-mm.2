Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A338606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LUIK3gvM
Received: by kanga.kvack.org (Postfix)
	id 9B0A46B05B0; Sat,  7 Nov 2026 08:50:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961836B05B1; Sat,  7 Nov 2026 08:50:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850296B05B2; Sat,  7 Nov 2026 08:50:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8156B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:50:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA3E91C383F
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:05 +0000 (UTC)
X-FDA: 85408456770.30.5766D97
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A491100008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:50:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LUIK3gvM;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059404;
	b=tpaBPiYlAyQVwV23bSqjJBTtIpbINfl5qaD2fQAdDyjy+atgaWkzXIhvnR778xB5YOi/w8
	s2ltdD7kUc9Qzmojx3o/5d+AJYKLcPL5+ZoE436szQJnjJDHnmU3hS5H9hl2+bwSo76b9/
	48UnM6gFus9eyXvDMAVXZYrHIlIaXQM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LUIK3gvM;
	spf=pass (imf05.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SZiSpxzoKRu3m4OtR5S8aNLPIx1JblGQq3c/+ycjfuU=;
	b=q7pVXj7lB65SGVwlMQoCpu0cyWnnKhWGZbDGFDNwN/StllkMtM72mjBPc3RO5H5MCre5tB
	P48l1R1VTg0MX+XOMC6Hb77kb3mhCdeOz2fjWQeJsRynwCIajMG0OLzFOjOHzWHeFU+1T8
	lUTSc29vwjQJr3vAq1oQDrj0bUl42TY=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso2543654eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059403; x=1794664203; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SZiSpxzoKRu3m4OtR5S8aNLPIx1JblGQq3c/+ycjfuU=;
        b=LUIK3gvMyTNf4LozC2vH1orG1hf/KlHR6wW8lkRj3AAwqtH1tp4HOSyLtzeb4M3ecK
         3UTzL1p1KuPWjp3lkrcQHDx7niw2VSts3xX1Mc679fBud3BT4UcsRkIpU6dORtAjOmRU
         sqhdz8YLnVJ8EdYTiXQd0FMcQd6C1XOo8tF6jUqr6JEbwin3pnJYq6N9i3dTsTi55OUH
         tTjuztP0N11Fy8wsLDqR08LooURVGK9UGmBe1q2Hr/6MSSE+6WLt0ztLMnSE9U6xfnwo
         FaJ6uZD66nVG4wK7ypQ9V/E6KLNtBFo4ZTwuk0I0GspoOF/Vx7EM9pQk5Uq9+V3FXdqt
         tbSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059403; x=1794664203;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SZiSpxzoKRu3m4OtR5S8aNLPIx1JblGQq3c/+ycjfuU=;
        b=WhGRQWHxO86ARA/wpTeSi9gD8N9OJtFwEhzin2bjK9bbk75BE0XPGRtdrzsHlxdlbC
         QKGrxJfgVJUxNg+MN5JmxY/02DLD8UCnJqZ0Q0iQlGErbg/3p3t1M5EmCifQkIA2BQ5W
         j8CvV3UUTSQWUaINjTs65J8RfmUQwbukJ4Fv6VbMOgxjUwfyMdvGmWr28YNaUyChdmjY
         UPSxCoSXND35jkyRVgyPutvo5zcbA1a07wqmrTeLegui7OiPSTobH8Z4FaBonAGZIRR8
         z9wZWpb0cozsCOqGl8SyKIt2dXgLVZ0WqbeBr2PBhVfvBNKW4nfMoFqFsr089eq1iFqN
         Jdng==
X-Forwarded-Encrypted: i=1; AL+hErE1l7Negec8wDJ6WZvcxCPl6clHUEcCbwKAIuJEj3mIXGD135ow/t9smlVyhp/0yhP3haDEwzeUtA==@kvack.org
X-Gm-Message-State: APuU4Z8JUrl8I7UhbwD2PJUO9cSRyDZx9gbkjp11ZduUASqjHfVc5aIN
	P37GZoSFVr19PYhc+CPKlUmJkmGiHE3i/mx3lCiZGPuxpVqg59Li6pG1
X-Gm-Gg: AYBFou0R87L3Ln2tqiUipvyQWRDEPhN1ASusVSRH6R2uXIW6EMwDwYxtU6YURdUFh90
	tj9wTRgWJyTZREQOXQMy7fNhHW3daLb03vwMmIaxCoiLzuCTc9rNR12fbrfKCg11F250jycaa4H
	fTYFLgnaaUXfwyCiE/46vgN+13mTw43C+tYNGILvXXiKYNVD2afBs7LNYpM7QKFE5FFuw9hKKn2
	ptCpRlmVzzUjBzTjS3dngtBRZXfZ51y9jRRYZwL0Tv5RhRgFpLRV71o1Lx7w4LQktZxTHjFaxE+
	+PU9xSOzSxNz1cfE/lyWid0TYz47sm1H1VvpgBqiA7tNd1begqHqzakPnAhpKjI4j3kcKEAczKi
	Eu+sjNflMwAzmp4pv+J+WRkVVjdba2sU4//rqj47+Z2tfcs60Y/ZB28zi2URPGoBDSOotkNDoOj
	Wjdkbh6lO4eyV6OZzYt/VYy/jUdwOCIqUfAQ5KRyIrC29c4hb2fPobqqtmLGCMKZWwciXJYCUIk
	TNFWB7TjGKb71o+TkehpI7vOcPyMnNlFQY4ALTVqcF5crMRuxzXNHPsjM/NeMpjAuRQVFSztffQ
	7V1RoS6lf7CmYGq0fehA8zhG0cJni4nmGxOfSWf1iLr6GZXoKvydMaW4Zw==
X-Received: by 2002:a05:693c:8946:20b0:369:7c:bfce with SMTP id 5a478bee46e88-36f75839375mr8242678eec.14.1794059402392;
        Sat, 07 Nov 2026 05:50:02 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:50:01 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap with contiguous memory
Date: Sat,  7 Nov 2026 21:49:43 +0800
Message-Id: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4on18q4j5etd6er5t8jgpb9m7kuhxy1z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A491100008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794059403-879952
X-HE-Meta: U2FsdGVkX1+4HYNH1+tifO6EFL3KfHlJIgsClgIiVktHHRbXi8zcZtmeqouLVQzzBWZ2knet7Jh+Y4MSbuI4ch0AsJ/dxEHEE94D6mMefM5FqmqdeUL4SwoZ1VAwEY197btFAEo2r6h1bIgNlSMSeDlo4RrK3lOqI66+9VZ1Qm2arEza4G5ljaflHHhzDKZXIs31rRUfar6xHsZfG0BZBWb7gKcUUgExyC2w6huGpnBY4GWniZX5Msf6B3beWHNw+R4YJWBJoC8ZFI58VWfKjqVSXJA4VKQGl7h7PhnawZzmiIGlrnero+OD8M+mmTngq+iNhuqWcPkbioHZxO6K8OjDVyaKPRbPuQcNq1tk4j1b5yuGZFqiBXCJKueX4/RM0h17LyRTzeiYWJ5I2IhpIzh5ZQhQ2l9nrV0iJ26Ghvy6/307ViAPz207Ceqs1s1Uv7ms33ldKyI4alXlj3bccnDd17D3Y0bqzqDuRC+ikHhRydWEpscuerTfrpS1So4ngGHgJv4jK2htW7T3WZlZwMMraY+WMVNi+aZuxITXHsiBwhLUiCvLGIPJ0a4l43t9h4D6gE8clkVGHKKW3HIOt6kZpeOnqHriPhNwIcDVbALYWCwYG19cnRwvYL6R8PRmZavUNuMelrSkIMw711UOSVgGewIF3X3ypC7PgBeOJOCnhrB96/v6kLDWSlYqU5mesLM4n9RhGFyhnYglIsVAveDefMCjBSYdgCCs514KqXFEGzzn00WIpjMvhhpTkch3QKBtmuxH0iXgf6DmfuMeZRcIs98A5Z3/S2vjKYNlPRIpwnCutofPE2tTBtHNd92YU+cxtqhnxCvR/J68cI0w53zx2kzDfa7xoguZ2BrW78XZfXlE6FeW/xwiGB7ptSIna8RvwKPB+H2qHtTQnOz6Pf3i3Izm1BXzylcIV+q3pfFWku92A2qPTNdM2s8GE4tNGL/bl308soSFuro2yry
 TC+chQUk
 LRlQT5iLRY6IfroVFG3vZyaVtpopds514fTm2do/6fKxH5MctnbNcOwaMpR6n6rkMBWwB1oR3TCYwxkxc3d1/8tcZ9nFKVzuxJDyJJGdoibRszLocxgzf1C9Ra2gCnlppzRxXS4ucMcECNVtGmDlgBfBZIatP4lA42PbjjV/VpEwY3uISwDWmIiJszSaRkqdAw+s4u6bEIWoh24q+WL/dNCiRAMjAwlGGcLfE1iBgDgp6DzfYtmDcy3so/FPw+bxOT8Q3XDh34PzMjydh6l8misZYNS6jqXpVapBttAkBCJTj5z8kS++QIF495z6BCkZFUNaW4xDeeQkQmIJm3AOodWc0mXT+YP1bO+71K4sU0z5phKN/ZUrabRRhB+lgxOSq0nWbtUHlsILAuLNYw71OG2vfndK6W9QoSQrgZMGceOQi0Ye81xSrxfDHoQOoh3fqfDJz32HrUIJzWIQGBdvNUl0qEgIWrU7QqOZ0UQdECvy4pMJcDEiH6d4YAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

This patchset accelerates ioremap, vmalloc, and vmap when the memory is
physically fully or partially contiguous. Two techniques are used:

1. Avoid page table rewalk when setting PTEs/PMDs for multiple memory
   segments
2. Use batched mappings wherever possible in both vmalloc and ARM64
   layers

Besides accelerating the mapping path, this also enables large
mappings (PMD and cont-PTE) for vmap, which are currently not
supported.

Patches 1-4 decouple the PTE-level block mapping path from HugeTLB.
Previously vmap_pte_range() installed cont-PTE mappings by reusing
set_huge_pte_at() and huge_ptep_get_and_clear(), which are HugeTLB
helpers gated by CONFIG_HUGETLB_PAGE. This made the feature silently
unavailable on CONFIG_HUGETLB_PAGE=n kernels, and coupled mm/vmalloc.c
to HugeTLB internals. Patches 1 and 2 add the arm64 and powerpc/8xx
implementations of vmap_pte_set_huge()/vmap_pte_clear_huge().
Patch 3 adds the generic fallbacks and converts mm/vmalloc.c over.
Patch 4 then removes the now-dead init_mm special case from
arm64's clear_flush().

Patch 5 extends ARM64 arch_vmap_pte_range_map_size() to batch multiple
CONT_PTE blocks in one call instead of one at a time.

Patch 6 extracts a common helper vmap_set_ptes() that consolidates PTE
mapping logic for the ioremap and vmalloc/vmap paths, handling both
CONT_PTE and regular PTE mappings. This prepares for the next patch.

Patch 7 extends the page table walk path to support page shifts other
than PAGE_SHIFT and eliminates the page table rewalk for huge vmalloc
mappings. The function is renamed from vmap_small_pages_range_noflush()
to vmap_pages_range_noflush_walk().

Patch 8 extracts vm_shift() to consolidate vmalloc mapping shift
selection for reuse in the batching path.

Patches 9-10 add huge vmap support for contiguous pages, including
support for non-compound pages with pfn alignment verification.

On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
the performance CPUfreq policy enabled, benchmark results:

* ioremap(1 MB): 1.35x faster (3407 ns -> 2526 ns)
* vmalloc(1 MB) mapping time (excluding allocation) with
  VM_ALLOW_HUGE_VMAP: 1.42x faster (5.00 us -> 3.53 us)
* vmap(100MB) with order-8 pages: 8.3x faster (1235 us -> 149 us)

Many thanks to Xueyuan Chen for his testing efforts on RK3588 boards.

Large vmap() mappings were also tested by Leo Yan with ARM trace buffer
units, including TRBE and SPE. These units use the CPU page tables for
address translation when writing trace data to DRAM, so using larger
vmap() mapping granules can reduce TLB pressure on the trace writer.

The TRBE test used a 1G CoreSight ETM AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       68.4 -> 59.4 (-13.16%)
* l1d_tlb_refill: 155.8 -> 119.6 (-23.23%)
* l2d_tlb_refill: 161435.8 -> 495.0 (-99.69%)

The SPE test used a 512M ARM SPE AUX buffer. Across five runs on an
isolated CPU, the average results were:

* dtlb_walk:       1710.4 -> 1315.6 (-23.08%)
* l1d_tlb_refill: 16000.0 -> 15950.2 (-0.31%)
* l2d_tlb_refill: 4796.0 -> 2931.2 (-38.88%)

These results show that enabling larger vmap() mappings can materially
reduce page table walks and TLB refills for large trace buffers.

Many thanks to Leo Yan for his testing efforts on ARM trace buffers.

Changes since v11:
- Clamp each PTE-level mapping in vmap_pages_pte_range() to the remainder
  of the current physically contiguous chunk. A PMD boundary splitting a
  coalesced vmap() batch in the middle of a chunk could otherwise map past
  the end of the chunk. (patch 7, reported by Sashiko)
- Set VM_UNINITIALIZED on the vmap() area until the mapping is complete,
  so that vread_iter() skips it while vmap_try_huge_pmd() may replace an
  empty PTE table with a PMD. (patches 9 and 10, reported by Sashiko)
- Patches 7, 9 and 10 changed in code. The existing tags are kept,
  Dev and Uladzislau, please take another look.

Changes since v10:
- Rebase onto v7.4-rc1.
- Rename pte_set_huge()/pte_clear_huge() to vmap_pte_set_huge()/
  vmap_pte_clear_huge() to make clear they are vmap helpers rather than
  HugeTLB helpers. (Dev Jain, Uladzislau Rezki)
- Add "Kernel mappings only" comment and alignment VM_WARN_ON() checks
  to vmap_pte_clear_huge(). (Dev Jain)
- Pick up Reviewed-by tags from Uladzislau Rezki and Dev Jain.

Changes since v9:
- Add a VM_WARN_ON() for pte_valid() in pte_set_huge(). (patch 1)
- Update the comment in arch_vmap_pte_range_map_size() to reflect
  the new batching behavior. (patch5)
- Drop the PMD_SIZE cap in arch_vmap_pte_range_map_size(). (patch 5)
- Rename steps to nr_pages in vmap_pte_range() and
  vmap_pages_pte_range(), and use 1U for the PMD page count.
  (patches 6, 7)
- Rename get_vmap_batch_order() to get_vmap_mapping_order(). (patch 9)

Changes since v8:
- Rebase onto v7.3-rc4.
- Rename new_pte to pte in pte_set_huge(). Add a
  VM_WARN_ON for addr alignment. (patch 1)
- Use BUILD_BUG() instead of WARN_ON_ONCE in the
  generic pte_set_huge()/pte_clear_huge() fallbacks. (patch 3)

Changes since v7:
- v7's patch 1 (which extended the hugetlb helpers in
  arch/arm64/mm/hugetlbpage.c) is replaced by pte_set_huge()/
  pte_clear_huge(), split across patches 1-3 so that the arm64,
  powerpc/8xx and generic changes can be reviewed and acked
  independently: patch 1 is arm64 only, patch 2 is powerpc/8xx only,
  patch 3 is the generic fallbacks plus the mm/vmalloc.c conversion.
  hugetlbpage.c no longer gains the CONT_PTE batching hooks, and patch 4
  additionally removes its now-dead init_mm special case. mm/vmalloc.c
  no longer includes <linux/hugetlb.h>.
- The generic pte_set_huge()/pte_clear_huge() fallbacks WARN_ON_ONCE()
  instead of silently doing nothing. They only exist to keep the build
  working on architectures without PTE-level block mappings, where they
  are unreachable (patch 3).
- Patch 5 (v7 patch 2): use round_down(size, CONT_PTE_SIZE) instead of
  rounddown_pow_of_two(size), since pte_set_huge() takes the size directly
  without an ilog2() roundtrip. This lets a single call span several
  CONT_PTE blocks: a 768K (512K + 256K) ioremap is now 1.25x faster than
  v7.
- Patch 6 (v7 patch 3): vmap_set_ptes() now calls pte_set_huge() instead
  of the hugetlb path.
- Patch 9 (v7 patch 6): get_vmap_batch_order() takes pages+i instead of a
  separate idx argument, and applies pfn alignment limit to scan length
  rather than to the resulting order. Renamed idx/map_addr to
  batch_idx/batch_start. Dropped Dev's Reviewed-by.

Changes since v6:
- Add a clarifying comment about the reuse of hugetlb helpers
  by non-hugetlbfs(vmalloc) mm code (patch 1)
- Expand the arm64/vmalloc commit message and comment to clarify that
  multi-CONT_PTE_SIZE values are vmalloc mapping spans, not HugeTLB
  hstate sizes (patch 2)
- Move the local steps variable change in vmap_pte_range() into the
  vmap_set_ptes() extraction patch (patch 3)
- Propagate vmap_pages_pte_range() errors through the upper
  vmap_pages_*() levels instead of returning -ENOMEM for all failures
  (patch 4)
- Add a preparatory vm_shift() helper patch before the batching patch
  (patch 5)
- Guard the PFN alignment clamp in get_vmap_batch_order() against PFN 0
  before calling __ffs() (patch 6)
- Fix kmsan_vmap_pages_range_noflush() indentation in the batching path
  (patch 6)

Changes since v5:
- No code changes.
- Pick up Reviewed-by and Tested-by tags from Dev, Leo and Uladzislau.
  Many thanks!
- Add TRBE/SPE large vmap() test results from Leo Yan to the cover
  letter.

Changes since v4:
- Move pgsize update before contig_ptes check (patch 1)
- Use rounddown_pow_of_two instead of __fls in
  arch_vmap_pte_range_map_size (patch 2)
- Reword comment to avoid mentioning cont_pte and remove if in
  vmap_set_ptes (patch 3)
- Rename vmap_batched() to vmap_pages_range_batched() (patch 5)
- Use batch_end as the batching cursor to avoid an unused start variable
  (patch 5)
- Check arch_vmap_pmd_supported before PMD mapping (patch 6)

Changes since v3:
- Squash vmap_pte_range() loop variable fix into patch 4 (patch 3, 4)
- Use shift >= PMD_SHIFT and fix *nr increment in
  vmap_pages_pmd_range() (patch 4)
- Pass page_shift directly without capping at PMD_SHIFT (patch 4, 5)
- Add vm_shift() helper and pass pgprot_t to get_vmap_batch_order()
  (patch 5)
- Use min(order, __ffs(pfn)) for graceful pfn alignment degradation,
  replacing IS_ALIGNED check (patch 5)
- Remove irrelevant ioremap_max_page_shift early-exit (patch 5)
- Add __get_vm_area_node_aligned_caller() wrapper, rename to
  vmap_get_aligned_vm_area() (patch 6)

Changes since v2:
- Use __fls instead of fls in arch_vmap_pte_range_map_size (patch 2)
- Add WARN_ON checks in vmap_pages_pmd_range (patch 4)
- Fix flush_cache_vmap to use saved start address instead of the
  already-advanced addr (patch 5)
- Rename __vmap_huge() to vmap_batched() (patch 5)
- Add caller parameter and unroll while(1) loop (patch 5)
- Squash patch 7 into patch 5 (stop scanning for compound pages after
  encountering small pages)

Changes since v1:
- Fix condition order and use PMD_SIZE instead of CONT_PMD_SIZE in
  patch 1 (Dev Jain)
- Squash patch 3+4 and patch 5+7 (Dev Jain)
- Replace "zigzag" with "page table rewalk" in commit messages
  (Dev Jain)
- Rename vmap_small_pages_range_noflush() to
  vmap_pages_range_noflush_walk() (Dev Jain)
- Extract vmap_set_ptes() as a new patch to consolidate PTE mapping
  logic between vmap_pte_range() and vmap_pages_pte_range(), handling
  both CONT_PTE and regular mappings (Mike Rapoport)
- Support non-compound pages in get_vmap_batch_order() by falling
  back to physical contiguity scanning with pfn alignment check
  (Dev Jain, Uladzislau Rezki)
- In get_vmap_batch_order(), filter out orders that the architecture
  cannot batch by checking arch_vmap_pte_supported_shift() directly.
  This avoids overhead for orders 1-3 on ARM64 CONT_PTE with 4K
  pages. (patch 5)

Barry Song (Xiaomi) (4):
  arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple
    CONT_PTE
  mm/vmalloc: extend page table walk to support larger page_shift sizes
    and eliminate page table rewalk
  mm/vmalloc: map contiguous pages in batches for vmap() if possible
  mm/vmalloc: align vm_area so vmap() can batch mappings

Wen Jiang (6):
  arm64/mm: add vmap_pte_set_huge() and vmap_pte_clear_huge()
  powerpc/8xx: add vmap_pte_set_huge()
  mm/vmalloc: use vmap_pte_set_huge()/vmap_pte_clear_huge() for
    PTE-level block mappings
  arm64/hugetlb: drop the init_mm special case in clear_flush()
  mm/vmalloc: extract vmap_set_ptes() to consolidate PTE mapping logic
  mm/vmalloc: extract vm_shift() to consolidate mapping shift selection

 arch/arm64/include/asm/pgtable.h             |   6 +
 arch/arm64/include/asm/vmalloc.h             |  12 +-
 arch/arm64/mm/hugetlbpage.c                  |   5 +-
 arch/arm64/mm/mmu.c                          |  27 ++
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |   4 +
 arch/powerpc/mm/nohash/8xx.c                 |  29 ++
 include/linux/pgtable.h                      |  29 ++
 mm/vmalloc.c                                 | 275 ++++++++++++++-----
 8 files changed, 316 insertions(+), 71 deletions(-)

-- 
2.34.1


