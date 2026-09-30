Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC1B2CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1813E6B0092; Wed, 30 Sep 2026 10:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159786B0093; Wed, 30 Sep 2026 10:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F3B6B0095; Wed, 30 Sep 2026 10:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4F0A6B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:07:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3B53120822
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:18 +0000 (UTC)
X-FDA: 85270605756.21.9BD9411
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id B4407140010
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:07:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z2X8t5XI;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6e1W9oGdmTQ/Tr5KCupwBGHorLPAMWe6GyMMJhNYhVc=;
	b=ZYmNT5q80EEs3gkrmJ91vpa5P5WdBkSCZQ78C8fMxT6Bb+TkoHGKSsnNwImQlFTfnCnWiy
	RZYSla5aPV3+llcKOM0qhakWrA4lczJYFUC545vhWXMGpkbO772zoqG3eBB1bHaMFga+LO
	Jmx1vLKHJMYA+rswntp8AyiSEJdgklY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z2X8t5XI;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777237;
	b=UyK4eapZWLQy66wFApueuFiTCA+ZzjVKlaEWzebdXzLBG/oyzVf3ZhYLrb2mjgGHnVcjB9
	TElwAk7waUEXsgj7GPv+r8Rrm9NEMWySR+k9BqUF3dj/QRkv+P1Yit3UqeRAU4J+C45RPB
	LGeoqSzN4M/C+9pWcZMDIhMH4ZGPUbE=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so3576450a91.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777235; x=1791382035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6e1W9oGdmTQ/Tr5KCupwBGHorLPAMWe6GyMMJhNYhVc=;
        b=Z2X8t5XInTSEntPVVPN9WrctnokTVY7trNLGnHWclL/HEmOy29stvpIjsYWkInUOjb
         L19Yfb7J2DYeJy65GYzbfoNN30p19+KaisF1I8HbMm5MaqL41dRVPfGknbU9fMIPOomU
         99vr8qaDIs/LfMaFujLZaLML3mUyPitjpq8FRzZL1vYP3eBSI70oTOiUw+9gYPPAXJZ2
         43UhSbpuB5c+4t425Q3oWhfHQ+3S/MPmN0OXcltcsv6EMqfqcZS2Ngi05Sh4OCdYLQGu
         vrhaWBbvyoB+/zffkN9Wy5oDWKxsptosWYrkPQwFgi2gu5KXUeWaJ2DFMDRh9e6+XMKr
         9eDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777235; x=1791382035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6e1W9oGdmTQ/Tr5KCupwBGHorLPAMWe6GyMMJhNYhVc=;
        b=pmY+3bbynEOKsbFPgMPRAqndoAYoJBllAQjmsFpeJCafkw6FK9zmijzruGSMFrLgUK
         zRwqnfXFzNy2weYYjXEmqFLjJdGaaYHIKZ8fGzc6lFnohhqp5syHdxWjzT7grBwsdQ78
         FFGZjvYmRkJFM0dQzU9eDWIjW3e/iBJmDRS4xovhOXBZBj5wHJ+MmBpZu9n9yUN1Xm3c
         borpOmtsgxo/ZO4xjV4fGxU8H5MVzjtARKvilkWdXiw0gOmbvWWd4N/b7hSgOWf24BHm
         /B02CaiKXacONGm2I20HlPBB7EVzushb7J+eY+4x47tWt3Lu5KjEXd3Q/cIHINV9wizY
         b64g==
X-Gm-Message-State: AFq9FYKD8UxSOBRx6OLSUSB2UA8l6VswzivUGNNY/1GTlbXE1SvK409g
	in8BNgA2WRKeMW/TM2gbOWLqSI3AnGaKxoyRPniIXqcKXhZoZPKRdNNecpNFbTatZfo=
X-Gm-Gg: AYBFou0scbEbwhTQgWkDIZXju2vP1J5MUyF9lMPcU2Ejz0RFi7Bj4XdVmECoDPEy1lO
	UInSmC77R8exQKud6FlwImIAQNWb/PSHR2QSQvwIsmsGOZlbttBeWYjjzAjHpwy8rBLgRy7lY7t
	eaIqy2D52ngaLH2Wo2W8W01bJ326J2Tm1WysFYQWKd+JnL5C+q6HNdggYZKqCecW2Q7Mse/hCvf
	wNLvBHP8ZkKh3W/7aZuMO2/ok+0fF0Djtfw6jI4+2ZY4iaZRsK/R3ZrXo3DBzO0hZNiXfD1UGzu
	LslxUuNkd9OabGL57CmR6juUp8WnfWPqNqQGk5V0oJCEEhXPBG25Zp39ethRbbdn/DwDvMq/yE9
	DHH9uOQakgw8AEy/ZSLJFGEDEcyZ7PtE2IVQHjkQ5DGa8fhc10NeKH4RE3giO5xCkYQitrcrXWV
	Yk1I5hUkW5ZZrv3lmLfMC+M1KniQJcP8OJrx7oiGwq+pgQd/Zg63avsekWFjA9nzZia97NEZVVu
	5E6cLxVdq4eQQ==
X-Received: by 2002:a17:90b:2684:b0:39d:84af:a0b3 with SMTP id 98e67ed59e1d1-3a4d151ef73mr1140780a91.18.1790777235209;
        Wed, 30 Sep 2026 07:07:15 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:07:14 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 00/12] mm: Switch device DAX to section-based vmemmap optimization
Date: Wed, 30 Sep 2026 22:06:15 +0800
Message-ID: <20260930140627.57431-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4407140010
X-Rspam-User: 
X-Stat-Signature: x67dgfk38aiw9sbc7bknno5ffmqx8d8r
X-HE-Tag: 1790777236-407078
X-HE-Meta: U2FsdGVkX19P1YaSsLvXdRhgAYXwe3caXoWx0p5FA6tEIksvPr4iOSTXEI9iXpQPH1Hm10twNeLrOHQ6JQeCQ9nANqXOwTCDSIpdEM+qiky2FS/WQe0Cpdmqs+Fz5WTSHOne9DeU9izwNcY0F4J7gpvG6LpA3RUIG6Si3hJSRGU1sXsc09wM2moIkAhqL0ovxtNZvFqA0jSfaKyY2OcVpvXYrxCKbl3XEhAhi1IFragZflnXBPCmzaMYtzIKbtCMuFhW8Mf7nxOwZYISJLfpKVnoMNOHD2n7PKGJhCg30zq/5adUADSwwUQd8/2PWIM3LiOg5DHJgqeIaAE/RklLPD/MUKPpFdPaZ20UIvA46mfG7+4ntWR0bETQrFTSVXV8vHk1TG1dqiDIn9wH6v7bdzppSpj9E5NjhvilXwgc4LelmUkQjvl9ybNCSYTdiZElQCKPFJucJySQsxQvrpYfPfX7TA9cqSzCKW0jxfMauDOC+VfCx6sJKQCb/Vu390W24eSux9oOn3w477LLJh8yFGs/c+8rdYjZGca6AyrdcbDXCPYLXWa0omna1HSdzMArLvODtVHIkGeDCDtI+8ERAlbioDmgZMjn5eTwaG8/bYC4pWJmrHObqwwHwKFUU+O6+zXVCCipuFX3W7FlI/N9M+085pl55pFTOJ54wbH53CuoqIKCmsZE6N9R+kqUXJqchivoZO2DMdV/+asZHRzuo2D2zijmksHkM3lnQyIkedxq0a6/lCKCTDU0q2xOkcmQhU1xyeQZGdSzqtfqTqeUf23std1liCogLPETxTvvqF6JygjY8rwflZQWuxuqg3pNiAjraf9dKP4yZHtzG+MpCjUv9t0Bl/uWWRrHR2p2TRqD3UAvR6SfazYCzRYsRQt4/hy7tprHoH2sb78FH//KGPKe1WtYuWCcBKNfvYkx/nN3WZofzUS1oWZXzEMPIF1wKh716ekj5ivKh2skvTc
 M+9vaM9/
 yp3YyVQUvjnp9TWH5EByhULBwRWVSBgMqBVPGhPNFaoBq1g1HbJgiEJw48dRlMHeVWC1n/SMDA1Sz/ArMehfrHUIe+LE06yRMUxuV/ZWC1i9x3b05UHx9LJyLOAGwcz1EqSzJVRlCTDCjmFXa2yAEidH7qhwlLhVrnUC8L1FuCxD5NkmgumRrl/jRpHl7c5aquIOywYN8Gz/9YU0Ev3hchYk/T8LY11PNy9k7+N7GO5Pom4GZkbTJiSMCMpSEKDcP6otBwzsfcV2wmNOlqKsqSGKn3P+bz27Va1tlR0vjEXPVBFukd7x//j2w82HKbSGCjW/8mY7WJyklbeBo8VscYqxsqRClmL54h7vphNnJ1ef93JcpVQDifiRyQiTMepvT8qmaRHmAaVGrFyfRyrYZAHzDuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This version is based on mm-new commit a878c908dc92.

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: switching device DAX to the section-based
sparse-vmemmap optimization infrastructure introduced for HugeTLB.

After the HugeTLB conversion, optimized vmemmap state is described by
the memory section and the sparse-vmemmap population path can allocate or
reuse shared tail vmemmap pages based on that metadata. Device DAX still
uses the older DAX-specific population model, including a separate tail
vmemmap page reservation and architecture-specific logic to locate or
populate reusable tail pages.

This series makes device DAX use the same section-based model. Device DAX
records the compound page order from pgmap->vmemmap_shift in section
metadata before vmemmap population, uses the common per-zone shared tail
vmemmap page, and drops the extra reserved tail page. The powerpc radix
path is updated to use the same shared tail-page helper, so the generic
and powerpc DAX paths follow the same reservation model.

The first patches prepare the shared infrastructure by factoring out
shared tail-page allocation, allocating the per-zone shared tail-page
array dynamically, and introducing a generic
CONFIG_VMEMMAP_OPTIMIZATION symbol.

The middle patches move device DAX onto that infrastructure by recording
the device DAX compound page order in memory-section metadata, using that
metadata to back generic device DAX mappings with the common per-zone
shared tail page, exposing the shared helpers so the powerpc radix path
can use the same model, and dropping the extra DAX-only tail page
reservation and the now-unused section accounting arguments.

The final patch updates the documentation for the new DAX layout.

This is intended to be the third smaller step toward the broader HVO
generalization. The wider HVO consolidation between HugeTLB and device
DAX is left for follow-up series.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

v6:
- Use try_get_page() to prevent the shared device DAX tail-page
  reference count from overflowing (suggested by Andrew Morton,
  reported by Sashiko)
- Move constant declarations to the top of their functions and fold
  the shared tail-page array lookup into vmemmap_tails() (suggested by
  David Hildenbrand)
- Clarify the DAX population flag description and why optimized tail
  pages must not be poisoned (suggested by David Hildenbrand)
- Collect Acked-by tags from David Hildenbrand
- Rebase onto mm/mm-new

v5: https://lore.kernel.org/20260927025441.741633-1-songmuchun@bytedance.com/
- Move the shared tail-page factoring before introducing
  CONFIG_VMEMMAP_OPTIMIZATION
- Add a new patch to allocate the per-zone shared tail-page array
  dynamically and fix the RISC-V build failure reported by the kernel
  test robot
- Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX so
  MSHV_VTL cannot set vmemmap_shift while leaving the optimization
  disabled (reported by Sashiko)
- Move the vmemmap optimization macros and MAX_FOLIO_VMEMMAP_ALIGN from
  mmzone.h to vmemmap-optimization.h

v4: https://lore.kernel.org/20260916064341.1825793-1-songmuchun@bytedance.com/
- Rename CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION to
  CONFIG_VMEMMAP_OPTIMIZATION (suggested by Mike Rapoport)
- Collect Acked-by tags from Mike Rapoport

v3: https://lore.kernel.org/20260911050228.58884-1-songmuchun@bytedance.com/
- Use EOPNOTSUPP for partial additions to sections that already use
  optimized vmemmap mappings
- Move device_zone() after NODE_DATA() to fix non-NUMA builds
- Collect Acked-by tags from David Hildenbrand and Qi Zheng
- Rebase onto mm/mm-new

v2: https://lore.kernel.org/20260908030335.96549-1-songmuchun@bytedance.com/
- Add a missing SPARSEMEM_VMEMMAP dependency (suggested by Qi Zheng,
  reported by Sashiko)
- Add an explicit ZONE_DEVICE dependency for DEV_DAX
- Add missing dependencies to the new public header
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Explain why sharing tail vmemmap pages is safe for DEV-DAX (suggested
  by Qi Zheng)
- Clarify the removal of duplicated 4K PUD calculations from the docs
  (reported by Sashiko)
- Collect Acked-by tags from Qi Zheng

v1: https://lore.kernel.org/20260831075342.57563-1-songmuchun@bytedance.com/

Muchun Song (12):
  mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
  mm/sparse-vmemmap: allocate shared tail page array dynamically
  mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: open-code init_compound_tail()
  mm/sparse-vmemmap: prepare DAX vmemmap population for compound page
    orders
  mm/sparse-vmemmap: set compound page order for device DAX
  mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: move vmemmap optimization helpers to a public
    header
  powerpc/mm: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: drop the extra tail page from device DAX
    reservation
  mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
  Documentation/mm: update DAX vmemmap deduplication docs

 Documentation/arch/powerpc/vmemmap_dedup.rst  |  90 ++-----
 Documentation/mm/vmemmap_dedup.rst            |  32 +--
 MAINTAINERS                                   |   1 +
 arch/loongarch/include/asm/pgtable.h          |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 124 +---------
 arch/riscv/mm/init.c                          |   1 +
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +-
 fs/Kconfig                                    |   1 +
 include/linux/mm.h                            |   7 +-
 include/linux/mmzone.h                        |  38 +--
 include/linux/page-flags.h                    |   5 +-
 include/linux/vmemmap-optimization.h          | 115 +++++++++
 mm/Kconfig                                    |   5 +
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_vmemmap.c                          |  31 +--
 mm/internal.h                                 |   9 -
 mm/memory_hotplug.c                           |   6 +-
 mm/mm_init.c                                  |  17 +-
 mm/sparse-vmemmap.c                           | 227 +++++++++---------
 mm/sparse.c                                   |   3 +-
 mm/sparse.h                                   |  81 +------
 21 files changed, 313 insertions(+), 485 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h


base-commit: a878c908dc928cfe8b3be0f33d3e60d1af437cb9
-- 
2.54.0


