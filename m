Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5679EC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201F26B0088; Wed, 16 Sep 2026 02:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2606B008C; Wed, 16 Sep 2026 02:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A73D6B0092; Wed, 16 Sep 2026 02:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C83356B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:43:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57CCE120623
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:43:54 +0000 (UTC)
X-FDA: 85218685188.14.FAE638F
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 32AF180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:43:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mm9iq9gb;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0LtIEs9A+1i71VGLOsFyci15iFpT6FPKjskDwO0GIQg=;
	b=GLutLBQEuRR8TRfxATRIAaFdg2UcQoDNHO3obllJwt6tfal+a8RpPJatCF2SuZ4KgMbXAp
	DZ6fmfcQNHhSvENy4LSdwNMKEJyU+PYbWX6OfIs/c0GOJwe5XSYVCSM+d4/qJQZHphZI1S
	Zi6FC4L/4sMsyXAxAF77oAawGnjtNdA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mm9iq9gb;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541032;
	b=BKoTMPJke74HdYlEx1HP+fV+ygR5Mc1ySy5SYa9EAG1dLTHbqcVWyLWFa5lbToD9ge+sw+
	lQ+oBrQFsdK+yDfaqSxIhkrjh4cMmjq5qh7vFKmrnugtA20k0/YxzpnhYGtE2ymCL1XM/F
	2UEL2Xh7W4EnqTA/pabuciNDFVFpJJM=
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2dd88a115c1so6141635ad.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541030; x=1790145830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0LtIEs9A+1i71VGLOsFyci15iFpT6FPKjskDwO0GIQg=;
        b=Mm9iq9gbK9FipDoLow9VrBjm1zH0wLQtR0ElE3/kNlstANMoRA/b8aVUGDzQsJa6b/
         qgMjGpgql84RMmRAAjqgV6MIa9aCIpHPJdR4qfYH5GxYtZJqSi8ujv6sEN1lBx80Cv9W
         gufHL02Zo1OGtQYCOPgi2wucA5hxr7DEU9YH3B24jbKNHB4WSMV1znIUn5/kDfR4G/fi
         SFxjY8LZ6SfT6GwK840FtBZ8TUk6DrIE60ZDECGMLNU+T0uAkOM3Qy22fx+X22+JBNq+
         RZ5KC6syMv1zLmRKDUEvSkgcUK2VYr1RvB1pRDdDQ/glTJOUwUuA8bBfT1WpTGDumuCI
         Vwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541030; x=1790145830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0LtIEs9A+1i71VGLOsFyci15iFpT6FPKjskDwO0GIQg=;
        b=R+h3QOya5EugMPstb13VqxEMg0SsVLzVR5kxIj6PJO8DUY/r7ZoaxwbINSBpCp/Z4C
         w7mVg8kILUr7s1DNcoCTFfQR5bnfNu/9RPmONJvZl9YxYPzzxGZyUXP65Oi5Ny1yP8fc
         HLob7YysYTF8Nq4hW3CCu70m52JUYJw2THU61tkSNlH3FLekAFRDp0g5O/YcETAQxLLr
         xrBhOBy49j/B0RIYAf+KXcgOg3XTlfAcCqT9lzMUEIxDZvZ9A8Dy3BCbY5ye3YLDyk0s
         +vOlzmc27XWyvOQDAi21kNFyK32Z8FdbvI7xSSzMqZ/uYk5VlDCx7xvx8h23wy4DCQ+5
         SWzw==
X-Gm-Message-State: AFuF++laLEYl1iLHxY20K2dZeTBmCQPcwBU568GRz3ARMMlC58IWJTHE
	GffmIucJ9wM9lqCLxckzUVAiB+Oyg/w1uJo/huZYePMYCzA5KOL1rdBqHKSVdiD+tPQ=
X-Gm-Gg: AYBFou2IUsDAwtl6rCrSSzbGFz5Dp4+4+KUY7Ci8PQJX8XqqGPGlq4Chuysc9kbs3ho
	1b0O7EH5V36UqI1/MP1wnhzMsgNnBzbYmWEf0LHQL+bs/RkJkQAynKeyZDR9kCcXWpOqo8Yy/vd
	6cbqV5sMgfQNLODFa+n6wqeuHlLcwZSnAbAMzFWIhEyc6uNYCuBHEpi0mVv/figYWi8HcD36XC8
	mTWmKCr4+1A4NUcwsP/1mqtIbaLnqFijGzoU5v4UG0gxkHq/UkS6adN55WYUKM+GtmLFIu+nBo5
	5oSx3t1Dp6X/3tsRAoo7ZFy7DUIk3q/Bk6/aacPYnZQCjPvjoX5yC2Y+a5YxO0G/4+HtVHfmiLU
	A70VDGZIotbUP/fv8N9LHQXq2yXal4y5DFWq3ICZbSgesiG5+knNDeR7IKp+dv3q71rDhplZUHh
	jujy4BNEz+neC3Ojv5PF6cAombMkB3qxF17ZjvojMiARs4B6creT4UJnSV3VRYouIRF2l0gvBn0
	D6ma5mAZ3sBmQDO8LE=
X-Received: by 2002:a17:903:22c2:b0:2d9:3083:a3ac with SMTP id d9443c01a7336-2dd8e52c3aamr26882255ad.15.1789541029585;
        Tue, 15 Sep 2026 23:43:49 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:43:48 -0700 (PDT)
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
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 00/11] mm: Switch device DAX to section-based vmemmap optimization
Date: Wed, 16 Sep 2026 14:43:30 +0800
Message-ID: <20260916064341.1825793-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9h7ktw1mftkbnuq37rzj1uk8sygzcf5m
X-Rspamd-Queue-Id: 32AF180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789541031-635373
X-HE-Meta: U2FsdGVkX1+jIgxrQ+UZhjJoI9VJFbj6sql60UBNGorZulVYozeXr13ke9Xah/y6grlEduQB2A6VQStZKflLS5pAtxOi8KfzGfAiImgZyCfkzLUSs5Ek8acApCwsqMsGKIqkryfZuE6lupz2Ll2gUFew1kvaydc1nsz9su6JNCfxDf9WBgT7woMU8qov52twe0av7zCxbR9p1m/+dbZOp5hMIGVkhuBBHD11L5Np3B9m7MkQvTkt0I1RE2UmbAvB4i6rSlFfsXd9M1xxPCCSpAov8KHVhtCkxNyy+fzJ1AIPnrmMhqGg3kg2Sq0MEb8ltxcUaIeFvQl1YEkoJL1gvYZ+TCTfUA5jdynqVGo146GLl5JilhSIn5Q23BeKXxYGKRrFQzS4VlxetgiRFQsIPUcu74hslr1AGimZnVPgseU1vLHYZ2KiSvgmH9F+36iHJHMv0wc1/g5onbe/kr5b1/LA38t0njx3cznczNTshspvIDG/F2ThsgBZThpFWdeykiRK3OYLcqKkvF16WiWpKl0TtUiVqFHPmkXWhk2ZrCxqcQwHlUXtvx5Ipub7Ttcm3Qh/iVremgP+PGnTW3m4EHzVxA2LdMsaFM+ekEDUqPAo1mYBxdmJcbhnPaOwGBldnK4mz++2BWCxNS9/D4zT2kHr/qzioFQHsGmONSglYtMyabng9AwTWAOuUgxNbNUPiSwD3IeoWAB2LYarBgjiJbQ/ugJBG95v0qGcdTLCg1JlUF4Wi6j3msXLKsvM8D9p2Umr9RwA94+0jPYRzc+iTN2+NnPD4M0+cUKU1PAl+g4+5asuzuab3ESeXDtlhlZIGrmpLg7CSM9/QhS86CuCt6imAdVcm8ZLL9LZxMBZdlZtfgfIDa0/IoO1FwbJEihkfYa1hgEcDx27emtR10Gs/DMdKkO1CiEsoGyj5B6TO9Z3l91MtBrhUB2wFKKGDYTfEGJwsZ/Oe6bac7yYl0D
 huHPFIVp
 b+kfJEGQV63XdBn5WdtyKYP0O4RlEXN9Op0LUwG2l6J+WjCtUS7oYc3wKZ4DC9MTKuxqgEGBm5Z2M1NLVXBVwCM4chWTUdWkalkCuvHzkfxZjj8/bEQ1OG9YWjawMLCUiXKo3SOYFIfKUmKJsBaQkDkC/OEnutnam6MlEJJ24J6R75gHu3szk7remIhIQPusDLSQGy0PdvtS3aTeZf7pIv97EXFkHVo0B9o7WCSwUdJRunJKoH2ey4sPGD/IyQ3FhSRQqJVGJ82ZBTbgUJuKj5MUDxDuphXuREeXd1/6vm7S8ZijEjeZ7sinVUW0HdLecJnlTvXa61IzbFxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

The first patches prepare the shared infrastructure by introducing a
generic CONFIG_VMEMMAP_OPTIMIZATION symbol, factoring out shared tail-page
allocation, and keeping the special shared-tail struct page initialization
local to sparse-vmemmap.

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

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

v4:
- Rename CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION to
  CONFIG_VMEMMAP_OPTIMIZATION (suggested by Mike Rapoport)
- Collect Acked-by tags from Mike Rapoport

v3: https://lore.kernel.org/all/20260911050228.58884-1-songmuchun@bytedance.com/
- Use EOPNOTSUPP for partial additions to sections that already use
  optimized vmemmap mappings
- Move device_zone() after NODE_DATA() to fix non-NUMA builds
- Collect Acked-by tags from David Hildenbrand and Qi Zheng
- Rebase onto mm/mm-new

v2: https://lore.kernel.org/all/20260908030335.96549-1-songmuchun@bytedance.com/
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

v1: https://lore.kernel.org/all/20260831075342.57563-1-songmuchun@bytedance.com/

Muchun Song (11):
  mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
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

 Documentation/arch/powerpc/vmemmap_dedup.rst  |  90 ++-------
 Documentation/mm/vmemmap_dedup.rst            |  32 +--
 MAINTAINERS                                   |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 124 +-----------
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +-
 drivers/dax/Kconfig                           |   2 +
 fs/Kconfig                                    |   1 +
 include/linux/mm.h                            |   6 +-
 include/linux/mmzone.h                        |  23 ++-
 include/linux/page-flags.h                    |   5 +-
 include/linux/vmemmap-optimization.h          |  94 +++++++++
 mm/Kconfig                                    |   4 +
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_vmemmap.c                          |  30 +--
 mm/internal.h                                 |   9 -
 mm/memory_hotplug.c                           |   6 +-
 mm/mm_init.c                                  |  17 +-
 mm/sparse-vmemmap.c                           | 184 ++++++++----------
 mm/sparse.c                                   |   3 +-
 mm/sparse.h                                   |  81 +-------
 20 files changed, 253 insertions(+), 463 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h


base-commit: 48cd55c7cb7b6a674cb94c2d65864088877f9279
-- 
2.54.0


