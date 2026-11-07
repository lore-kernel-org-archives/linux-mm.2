Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6CC606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=T1KILbAP
Received: by kanga.kvack.org (Postfix)
	id 6D5456B05B0; Fri,  6 Nov 2026 23:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65EC06B05B1; Fri,  6 Nov 2026 23:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574DF6B05B2; Fri,  6 Nov 2026 23:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 213926B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FB2612029D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:01 +0000 (UTC)
X-FDA: 85407050442.05.32502AD
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id E5F1A40007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:31:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T1KILbAP;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tMJYIXC5HK/L92Fsjcvgr4iGfrMwtNzZGIshDMxf8u0=;
	b=kyVQSX1/eSdiZxzY3ECWpNpFYMsQp7vn4/qWD7juG/aIQaNn5q3IgYfic5/14CblyRWSrE
	jeRHSkITLM4M1WuotMztobFa6nwLjNIxr6WAmH+G4rvk2FxsMoiKf0XfUoVzQDtO0w3zIy
	IkAPzQ261NDT6YLOSU5JNPS9g/eUBKg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T1KILbAP;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025919;
	b=TvZ+ZriAa4nEcmrp3q7TTY/usO3JEBeEYS2CUkH5wS1m7LIj0mPBt8qBqNiq5KW3jFZKWl
	S/1fX4etY3+7E7WLVK3DblFyI4NuA7UCpdIddYfujcCtkEtGR2BOFAOACyuqnqLOrr3j5D
	DprySCjFJNawfZZVcF86o7MOPjdNCOM=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc147d86bebso163423a12.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025917; x=1794630717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMJYIXC5HK/L92Fsjcvgr4iGfrMwtNzZGIshDMxf8u0=;
        b=T1KILbAPrYRhWVGvFxX19QTxGT4q4U5vKaRgHBQudhSvvlbrSPf0k+LnIVeqEhbmR/
         YAlyXxRgvDbG00yHZQ1hsi7e0mix/L3c7gtOfFSJinGADN6XHcw0kvYQAGr5DFngW/hU
         ObDHaK8EX45wMxxpwjNEWrWaPDFOObaNRZomq90PCspFI8zjVbqAjhYw0+sLVTP3FN1X
         kOKy19pG0VZ1jTCGIzT4uxMO1XqNpQwPeWRZiazWjqs7FJCplRKxdV/6AF4Hs3SY1URP
         snxfMEILY9t+xHvlcZpFp4Oa5eIThWOAHD/JCEV/1ASPsORPZ6Rd8+kuvTrUnhtWw5T0
         0xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025917; x=1794630717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tMJYIXC5HK/L92Fsjcvgr4iGfrMwtNzZGIshDMxf8u0=;
        b=JDwWlUIx8fdkUBKB58cUzEUFE/Aw+ss06atrmkV2ptescTZc30I7APqLXY204jbTSH
         f9irSWLm6ZvNQWpULIqlJ3q2eIqNqQHMgg1f/WcHk+RYFmD0fI3hY6KJnu/z0btFaQ0k
         CB2zIHiE9e+QNmMK1eRDjsYA6qQCR1wAV/KqKrdkYiPST2ezesowxhHaqudQtGEu39j9
         rXzIPx9ULRhawt5Y4giTeC9ujBgv81ZS4dQipzFAzMYfOGciqknwSBjV2URXHYI5mvH0
         UVRrTiTEVoWjuOqcPKFZ/qMuTvX3DW/mToWX7ZEcHAqYqDvYOEFgcHtIt4127Az//97v
         qFGQ==
X-Forwarded-Encrypted: i=1; AL+hErH796xDwtkEhUG2vpVPWwh+2FkOAQQFHkeAL2cygcLrTCajATSRLk7EcTeqe1kjCZw/vsOXoSQy0Q==@kvack.org
X-Gm-Message-State: APuU4Z+CyaaRQfWnlpE0mtGyApvVlt86Z9huvu0xfcHoHCiWYBWX8jZi
	sJbclD52dw9jDOW5pj86ZyZE3TaKPpRvLWMJlg1o6BMeoY9yYk58enPI+sx0NjIJMBs=
X-Gm-Gg: AYBFou2m+2XA7ES+8fMS8irMaKt38U3zGhpizda5uZlhRanqFL8EGgLcOYVk5lZTCT2
	fz9D/bYvx4KkFtDOfrvU0kcVhu5IDpONWFZxKbCcy+W+OzD4nSmTUlSxdv3Hv0eqbo6tTvBqLai
	9Eh8aXdxA6nL890Zq6RzHEz8yUBO52TtTcE0OIQi4P4LzAyQCqpiRBfgOhgjPRx98tNiZ1sUaem
	nKvTrPDwAluHeSoyCDwKUX3YBE8OnfqXOq6NjUxL0jHXWABnBWp37kYpp+KP0fCAX21aJ3iI/jC
	JFcBYTOqt1o1PCiHDt0uUTUwiHg5C/lAgHxT+bV9x61ZW8k1c9vJfAB2pt+nrKS4Nq1cQ15Fhin
	VKAHYBt4NnUyImgUtK0C5a98AfaMBT/VTPFZ+apykEihMVsip+VlXouSohW89NAitqizzLaIc/X
	AmRv1YIA/8nWfQpKici1VpyLBHxMav3JPhi23SG0KoVxWzuWAfuDnDFaMneHRkg7s3Vf1WE2gfU
	8bFraWAKSug0wlfXLlFUVnS4mX0rO8nfEMuvEhuhYtgWpyAFmHEZcnfaAS7klgCoonA7mN3K8TW
	WHT1OqggzuMyd9i8UFv4xL5e075O3Ha9CKTEPRaRJxIuH6pak7ShZX1epHLE
X-Received: by 2002:a17:90b:3c0a:b0:3a0:eec6:b065 with SMTP id 98e67ed59e1d1-3b1060a6be4mr758538a91.13.1794025917280;
        Fri, 06 Nov 2026 20:31:57 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.31.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:31:56 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 0/5] mm: Simplify device DAX vmemmap optimization plumbing
Date: Sat,  7 Nov 2026 12:31:17 +0800
Message-ID: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bnx9647qpsdu67xp59uskuyopmxxqssk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E5F1A40007
X-HE-Tag: 1794025918-423611
X-HE-Meta: U2FsdGVkX18PnM6v/zwMhpuMcTaV0c6kY5iwjInp/1MZb7DWzt2LRrE9p0R6/Al/Su3V2LtYLR5wVDUUZQPOJBnlF1R5lbioDo8HlXQXLYbItnGk6P+ii+zUgYQTz+YIx3cnQj4JJGMx/6dFjK12SKw5SRoYqYAlFVl0WJ3keNweKuvq0NeBUpCxGFh6IkRkTBCP4Y3zBPCY4fIgDvQRj5XAuT7/NezZWiKDyXrzd8y0LWu4h/B2mZEBRxN8/IRk4UbDcE3IyLXqMtMHlsXIyZ9jqSyu9934PsMjEn4YMeec9jEbF35dZGn6WXstuABDOh+IDuf9ldbEkxjansaauoFV6XXi9Qn/HD2AZXj1wiKxTY2u9TyxQn9fVugMeyJ2DGfxEpZuZ5c6BgkCqzqnc/ZLt/HcqIbtNWRp8tjNTHzyRxfcQI8L1uzuZfxsYF83lW541KcDMOY5Gk86D/FX9j4mqh1waF2AACvZiiaXQtNCSykL69oKpLb4wpinocY3rzmgCUr8ZkX+4gsy9176V0qrc31beVoFpOMb3XqikIrGPPgK0HoIVjRMyQIQzL1asoIs7sT4XLDJetKjWFZsHbLqwdk9uD+p5DPmRkkVlsQNM+Puc+Q9nEmTfCtdNPDDwMFZNBYOYBR79USetO0KFprdv+AcKt4eQH407wQNFnjQP95Gf3dNTKUaMcHoFHycu38cxmebnUlg07jAiqf33WzsM3Ti/M6jvYlSmWFIdJWejwJaoQVpOdRFyGTPHjCJKQS4aHZniOEE84iNpuzFLhUyFvMBLf6bo05C6Z16U2vqQ97bfyIHxDhdrMBz7WR8PhNathLGQBpCIG19NDUqHdqKUztp5yRNwAsaYYXxEufamUOuHzk/stiSVTV7ePvarvIxdEbWhrcPadneV7mbqbFugoPg+06nZsG+m9TCwpbZSa8YfC9Bs1mGwVNacd2WBqO9tbZnPNU92Gix0Gm
 dZ8PC0rV
 GKw74RC8Yn2KvEZf2MFhjJJcImG7s2ItDCsBHd2GdtXLC+Lw3iI7Z2QR/hdof8wlWP1KUjSwfRqorSI9qVg5RnukeRaIlS9+88G4EayoxEdJgFX4hAN55FlMXX5NNWhPGCXhJoWhs0Y9SwhSH9KRF3B4ARP2mbfc+b20yiIlDokYzuLtpgz2eTPVSB895+ok4MS5AwK87Gxzio52uuvF+EjyDdAqZeyMq18FfiMKNgGzqnCtO9EU/XhZhRNJZADCIFj49x/iqPN9hpqAcSjF/yLhh/3c9DXR1Vmv1V0d6rF9MonoxmN5FYxC9Pfle2DqmNMHmtC3BmK8eLBd625lG1FHFpnLlVSmWrAmfYvLF+U8P038h69MUyVYw5mxAgDpGm6bqx3hv138Nr5kP+2atsq8V9cvRaZ7Kbg3E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: simplifying the device DAX vmemmap
optimization plumbing.

After device DAX was converted to section-based vmemmap optimization,
whether a mapping can be optimized is carried in mem_section, and the
architecture-specific population path can handle any remaining fallback.
The code still retains the DAX-specific vmemmap_can_optimize() helper, a
PowerPC override, and @pgmap arguments threaded through lower-level
vmemmap population and memory-removal interfaces. These duplicate the
section-order policy and keep otherwise generic paths coupled to
dev_pagemap.

This series removes that obsolete plumbing by consolidating the
optimization policy around memory-section metadata and simplifying the
generic and architecture-specific population paths. This also eliminates
dependencies that are no longer needed once the optimization state is
carried by the memory section.

This leaves the section compound order as the single source of truth for
vmemmap optimization and decouples the generic sparse-vmemmap and
memory-hotplug paths from device DAX.

This is another smaller step toward the broader HVO generalization.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

v3:
- Rebase onto mm-new at 684242af7090.
- Move section_vmemmap_optimization_disable() out of line to fix the
  LoongArch header-order build failure (reported by Sashiko and the
  kernel test robot).
- Keep section_vmemmap_optimizable() in mm/sparse.h and leave the
  vmemmap_optimizable_order() relocation in patch 4.
- Tighten the disable helper checks to require one aligned memory
  section.
- Collect Reviewed-by from Lance Yang.

v2: https://lore.kernel.org/20261105061217.13302-1-songmuchun@bytedance.com/
- Rebase onto mm-new at dba8aba0a9a0
- Add section_vmemmap_optimization_disable() and use it for PowerPC,
  LoongArch, and altmap fallbacks.
- Add a LoongArch patch that keeps device DAX vmemmap optimization
  disabled while leaving HugeTLB HVO unchanged.
- Ignore section compound orders that cannot be optimized.
- Add direct vmemmap-optimization.h includes for architecture users.

v1: https://lore.kernel.org/20261030140720.1256062-1-songmuchun@bytedance.com/

Muchun Song (5):
  powerpc/mm: make vmemmap_populate_compound_pages() static
  powerpc/mm: drop powerpc vmemmap_can_optimize()
  loongarch/mm: disable device DAX vmemmap optimization
  mm/sparse-vmemmap: drop vmemmap_can_optimize()
  mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs

 arch/arm64/mm/mmu.c                        |  5 +--
 arch/loongarch/mm/init.c                   |  7 ++--
 arch/powerpc/include/asm/book3s/64/radix.h | 12 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 23 ++++-------
 arch/powerpc/mm/init_64.c                  |  2 +
 arch/powerpc/mm/mem.c                      |  5 +--
 arch/riscv/mm/init.c                       |  5 +--
 arch/s390/mm/init.c                        |  5 +--
 arch/x86/mm/init_64.c                      |  5 +--
 include/linux/memory_hotplug.h             |  8 ++--
 include/linux/mm.h                         | 40 +------------------
 include/linux/vmemmap-optimization.h       | 31 +++++++++------
 mm/memory_hotplug.c                        | 16 ++++----
 mm/memremap.c                              |  4 +-
 mm/sparse-vmemmap.c                        | 46 +++++++++++++++-------
 mm/sparse.c                                |  6 +--
 16 files changed, 89 insertions(+), 131 deletions(-)


base-commit: 684242af7090928ada5e48fd40a0f3a539b3fd5b
-- 
2.54.0


