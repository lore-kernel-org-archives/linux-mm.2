Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D48C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288C66B008A; Fri, 11 Sep 2026 01:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A526B008C; Fri, 11 Sep 2026 01:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14FAB6B0092; Fri, 11 Sep 2026 01:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3BED6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:03:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D4DD806D7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:30 +0000 (UTC)
X-FDA: 85200288180.15.7F2F233
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 38DC580002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:03:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Tw/AqfFb";
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103008;
	b=Fe60XydGKc6laF4ayRs58sY6+mq42EwtJ4MF2GFbchORCEZwNMN2b6Jcg1lkeStJBoPuBQ
	jYzw7fM2u8la2KxMCYA07tZs7uTIkxcKK60CNB0/t8X0Wwd3JuzL1c9EGQPlAyhAvxMl8C
	6HeZgEaWuj40kL2/0BV4bvwGBjxl9Gg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Tw/AqfFb";
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qqQtNE5K5bGF4fAhBmQKuNzeCVlz+kHVYANXwAzhHeA=;
	b=t7W+qPLAPY/n4ORUIPhKYy/lxDReRlmQpwDMLkYPknMH0bYg9TY6U3gQTjXOdDpUv5Blmd
	RBuvUxKuwyq0DeRrZjIg0R4fWAbN4R332QGzFtBXeTeE7tLDf6P5LcLZWY2ZBNDT4lzTfa
	+/iJxRbO636c3FdHSjVU87Xnx2QKgI8=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso471690a91.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103007; x=1789707807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qqQtNE5K5bGF4fAhBmQKuNzeCVlz+kHVYANXwAzhHeA=;
        b=Tw/AqfFb9JmFu4MFtsC5mDZrNASDMX2ccrJcRJRv5GGHzU01QEdSsV5nSK17IdTKLN
         ns8hpO9mD5V5NdgodAv8TNY8DsMxSQ5WLHW6j8aoL0SuxulNc7lLAzjJGHm+JZW6EKAA
         VwFWP/C2pNJZSLcN7q+e5toGC3FrWjiBv6RvWkf+5gJte2wV61LyMIsrNyAIIZXAmavn
         LjH6rkDzpLD4bHENpOH9B7fOaSF1bsUUJJUpXVQk5kcNINkc3kpYT0SnOnsuAuZjJfN6
         Z4LrepWHMXPAw1usHZdl0j6s14Zrst+lQq5abgCwdLQ4XZSg8EIG885kfr3CT7AtffTi
         JN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103007; x=1789707807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qqQtNE5K5bGF4fAhBmQKuNzeCVlz+kHVYANXwAzhHeA=;
        b=MARZNgj4YyfV/2gC76gh91a/ZudXeMUxkvNUIZmy/QrD1qlGGZlZOllqVVrMHYRUvm
         cqNESF0lGPg2J77L7J41muhpF0xuHHEQNGTAkX0J74qD6c/GbPVlbYYTP4gDxfP6quyz
         yRkTnNxv8bgW93FjyUDSU51zwzJpBQqSdbCtRwPryyVNkMyztBSQDJvOg/4k9l2HmNUS
         sHYm+/NpZ7OL1EPU4MYJc79/EaSErRm07JnvGixc3oRlkbe/VGYduC+ujnT4GRvJFDQp
         KfV8pRI1lU6L//od/b61Yj94rYaIOJ56Unp+sblZKp1z1BL+5FIhltoAacKVs75EHLzA
         0Asg==
X-Gm-Message-State: AFuF++kdv3WVX6YDJy0/BSskQCHMxw08XCdpGOlb2ltX4YdMtHobsA0Q
	v/kk9glpyHXrizGUnfxLtQrqsTOa1qZQ1GO5M6iEnRqSG6iouRrOFIf0QI4gLIpJ5bs=
X-Gm-Gg: AYBFou3RKkDr+S1/0TWP6hVia+q95GgJUvcjXvAKxZ6W8WkdUgeDWwrLPx6jK6YjDrk
	m3cM0QsM5ELjZDq3TShChfPN2FR62GBNk8VcTvHJMWVeWR+3s5e+7iIY4orQn/3jpOGe6GcztfO
	CyuKSezzzTJUqJU2kz4hgsc53LI44bxQh+iBUBRUDxI4sr4GLc82EZ1nxwHbea8O5YqEBvcddM3
	/xuaiW4fjBHm1FkzA5JEVEkV7bTmf1SPDxx+qVTBnUYVcvftBA0KvoQ5gQe7daF4zNqQBRQAOy5
	EYIuCOBON+Z3aUb8dd/U7/dsgOSvoAfACUk5szq+C2iNQZO7I0dxHSNAHgkWh2j7rKwkYiQRGmc
	C2yFMx60z6VIh3ixhAUm0Ae5QrWopHU5omtov/nPErntg//22swZj9f+bnhUE05tFoREpl36W7d
	AUgehbQkZpt7nHkfBusHr4lDeIR3zila/rgD+Dolnk6AhIqVrxY6dSAQIJB2A8m9HbONy2KRZh6
	R+qgbFwtJx89tdvVlYdWGuErQYmSxBrUmR1
X-Received: by 2002:a17:90b:1d45:b0:398:9be9:ab8f with SMTP id 98e67ed59e1d1-39d9c21cf40mr3843551a91.20.1789103006582;
        Thu, 10 Sep 2026 22:03:26 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.03.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:03:25 -0700 (PDT)
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
Subject: [PATCH v3 00/11] mm: Switch device DAX to section-based vmemmap optimization
Date: Fri, 11 Sep 2026 13:02:17 +0800
Message-ID: <20260911050228.58884-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38DC580002
X-Stat-Signature: 47bq63ae6dr7jea8m55yhbrsoku3o8k8
X-HE-Tag: 1789103008-615445
X-HE-Meta: U2FsdGVkX1+1L+v5G7F3QSwXUddDIdzhKaXeTJ+JFkZl9mT6gPveZIPKbwQ2wwMxtOlT+vC3NQ6yXXKFamwxQP3YK2VHnu9wwMwBqncfkbrhXf887CA5LnsIZrNEVwzbLeMDWrGiCEFa0BF8B93AYBT3G+8bT8Ru4hhNzLFUeOy22IOsZ12pR/v78hUcaC/MhmiPWWxxLt03nF0u3Q35YEFl2VOS6j3d6YOvrvLBzTn4GRh/ewRtkRFWAPZx4LOUWn23TEPnoGv2z6818K3xmRP114Cjm4mnAiz4X2QE221tllrvhYECBCnioL7jMaXTTmSDE//1G3Sr5+sopusaJm1I0YPfr/zL97LqdyCjDWTplgyJvQNp6hIhhTPWihe5DNvlBPug96RMM3BGjiJH5mLHYwPTATVccvn/W91qM7cPaCqLuoA3TZ0h7a7ypN4Ac36lXXFVbyJ71+6/Z9SAmMaEF1jleUZ+uCn3wKMbEzTH95a0x72bbXu8soUiXWXcfiDJcy4xMjTL/y8d2AlKMF6Fu1zqpB3/4F5KchZiw2Gnmklv+4GUxQXCrlTBNoY8rfMGBHIR/DjgbEOuu1VRkNVtdDS8DGRPRPWdD2HUEV0XNznPgN3AHaalp0NYG26LR8ZnHlZ5WIjbKKuzHuR07kaivXZqT0V7X/7b4TIO9Z0zxbVGBuA+c5b8s9HsTfTVwTY2lCw27VHylebJpeE5Ex/O1ldGupep6OWUhYjrCQQF/yQftv9kOAxIJBHa9WKy9sWG2jpxqrHeDY6GYuB4txkT63khVXnLAxN0bYiOh7u/MyhgRIINrNYVmBx9AKwYdJyXBVa+oqWKxwzR6SYhZ/LYibtBSSAEdzM9z2hWRlRBIR/ymEXs+AqmwerQZuSHYL2J5XPEOYPpE5uLmWWzs4qILlw+r37zvYrmO45SAuW60k+M4SUJlH5VG6QOxVJT0K4SklyiC/1uwb+mvgN
 tHJ9pBo4
 W3HeJa1f4K9jvWGBfsEYl6qG2oJD1ctWo8bLDdE4VK7jwl2Kd4yTLBeMovMJflqjNHATdphRPI01pZIeXDbZMs82jJTkrPawDorf7jGABg7aac3kJiO5CfDqbcJNZ6384qkWej1EKGWyTXVSAABSytv6lL16OSKzleM8HjLJtsIiKjS6LUSYcROXRNq7MRVV91N+ZBZ3YS2Dwf8itYebzIvUPeEJnJDLgeZqlzlwPa0vWVP1mKfvaZFqiI90bq0voQ+mSGHgG3VOrL0KlCwQdNeZ9HYc6F+l1mrKSpQGkVc1fxXl+N4FUIEYyu0YpCeL89ZErzv31Gh5Qotx6lH40A2T+Tg==
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
generic CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION symbol, factoring out
shared tail-page allocation, and keeping the special shared-tail struct
page initialization local to sparse-vmemmap.

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

v3:
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
  mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
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


base-commit: c46036ca3ab7a7628fabe5790aefd917d0858db6
-- 
2.54.0


