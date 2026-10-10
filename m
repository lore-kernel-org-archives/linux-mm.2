Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56F2CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D996B008A; Sat, 10 Oct 2026 03:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E5A6B008C; Sat, 10 Oct 2026 03:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E446B0095; Sat, 10 Oct 2026 03:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117456B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:58:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8BCF1402BD
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:26 +0000 (UTC)
X-FDA: 85305964212.28.7CB6BD9
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6EDAA40004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:58:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Lopdc+Lx;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791619105;
	b=Qq1V3b5l89Vvuer7/M20LNlY/qLK03mamRg3DcdNZpbVKjGABMf7VuD4xT8FrmWzFl2ncq
	iWgb5FJjQZKk9t/LO255noMIlHf/JGGa0lPSamM1pLq5bzyy0sTetgOEd6glKqapN2VrZ2
	f74cLaddo7GHSwyDe4nA41Da8/xkEf4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Lopdc+Lx;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791619105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s931g07PMq4Bu75kY5DuvEAvn6osmlRZp6J1l7oOErg=;
	b=iIUfK9E1WrNHVcPt5gToZxB2Ba0vvVppKMAGEIlymHlsts1UoioA4CSgOywmX+FYucWjmZ
	s2PsF4v3DWKd3XsUggk+UIiuVT4k39A+MCggTsDcj0ofv3dMCDdPhD/z9r+P6UJzywmBoV
	j9VN8EHs8lNYhlzXssz3NPAxUi/EJmo=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc7cc8aafe6so146027a12.3
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791619103; x=1792223903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s931g07PMq4Bu75kY5DuvEAvn6osmlRZp6J1l7oOErg=;
        b=Lopdc+Lx5sp+4/u/9sWCEeEGuEOaS3wtYO9WaI3N3msAccR7TVI1x1yIAfq7Ka6gfd
         ubIpo31WVxD8A9Kw9KYI6/XAk8Zb+5bjLpYOwvWsIiVINTutqD+eHh4rQR+VSXWyEs1K
         smGgJZOhkYDEnn9uAFbSO2RvQXsYSqvvjxk6uN8ST7kFE1oHmIme7KkmA17ZeYsBH4BO
         k+3mOBpADDP2PjX8z17TDNRhe0UnUTC4jo7U1vfswfSdDZb9Tk4oMOD1FDLulbxk9HGR
         kN/iVq1D92X+r1FtBh6Hmj+fkFtNBKnT+BsyyqIhuqjur2jbK/7YrufMirBT05V5V/HT
         7I1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791619103; x=1792223903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s931g07PMq4Bu75kY5DuvEAvn6osmlRZp6J1l7oOErg=;
        b=nuKlj+Gze0E6xBigfC3ducUHFhUzyfktqOK+q/lzPqXkM7SOpWHtVdDuCQz1QjWFzh
         RnCjyTSBtiVNXwdELafQnNHcbf1TyQ7MoHrTonLph4pJJsTC9PeRK/gvIew6q9eUmjlQ
         2JerR5ViaNKZdCRoOCDNTqkr6w1XNTBz1SpnlaY2iMlEFK8XsTfuFZNOHZYQHXFc7svz
         k2/WULi9m/El1q3An5PiWf3++HcKruyf5fgEcQEEoCZqTh1gVCY0Mn2ozhWhrNMHB2cH
         K+u5rsn66T/pLNQr6prCC02Z7OGWodDnkyp99nwBrpwwUeiqEr2G2/Uz60ANywpl5ILG
         cQbA==
X-Forwarded-Encrypted: i=1; AKwUvBxfhlmVQgmFLMl6DBR2TUPCiMPpgc85jjZeZtoJdzIgWyBCx3qksSwIKQ670lzu2lvos9GSPmDYbQ==@kvack.org
X-Gm-Message-State: AFq9FYLo286jufLY6HGZqXTsTmNJ+Dl1Y3vNDeT+dc/ZPtJTq1th86n8
	JGjvuroi14vsO3eONv2i85TmzDt96MK6aw2OUf2kDAk2b2sY8GJCakbwgKkDHpsiC2o=
X-Gm-Gg: AYBFou3p6PgN4oS90wfYHUoB3FP253NXU8o4t+Dabpqtdjxkkmgu2uS+1B7NhdLME3d
	3yCja0DK38VF/6hCs/Oic7oVPvUofoqM32EeNIWHDHXOFcnNv8D5RvVrqY7GTAWfZkn1PQHUOrv
	nPzEUPvu5hXZTg5NIAVUtB2HmOMnzyH4peQzkfh2X92BNmbNi0Mmi1eQGIaWuDFXo4eTBVYdXzS
	4Y3y1zQdi2CcIechz3RZtHDqOD7b84dGKuM31SLm8joXhE5ImTgCbrVQF+5WQT5h1etFLJCg8IG
	kJamqjYGtqDjXcskgcaTVFLDDHLvXihkFkGSn12+2vx1DQG0gRZ0W3DS5z0ZnVE2k1ILnIJUUBd
	8HVsuex0fBQp+nJ0SnGVHIAPWAdYuyT440gRC2ZLuFbxQvqTsULe3GEp20+3UKmOthLkofwdhYI
	lBRCJztVOFg19u6idywXTG/q4rOuI5RXxNTLHXl1AH0iI8ircB3GsgGSjh8WOKxeRVzLB9lch0X
	ldJTz1UaY9Nvs+Df5vQY3y1xR81O4GIWg/rkg==
X-Received: by 2002:a17:90b:4b:b0:3aa:f2c4:12ea with SMTP id 98e67ed59e1d1-3ab3ab5e193mr3041362a91.20.1791619102741;
        Sat, 10 Oct 2026 00:58:22 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([139.177.225.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab57c05724sm3473569a91.4.2026.10.10.00.58.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Oct 2026 00:58:21 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v4 0/6] mm: Unify device DAX and HugeTLB vmemmap population paths
Date: Sat, 10 Oct 2026 15:57:49 +0800
Message-ID: <20261010075755.83339-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p5pbswu35wuxk9tmgiusunu9igtmdc1h
X-Rspamd-Queue-Id: 6EDAA40004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791619104-501620
X-HE-Meta: U2FsdGVkX18FEsTEIHEPShNeOngyeX3w8KwCyfrEuOfZoPDdpFhhTEiDJADBiCQpZoFIQMCKvIfPjV1v0WYhHNIQG7UKBIfs1X84n7VU8yjKJH0TDvmuhJxIk6hVY8lfVlxUA2VkfEn+g8XuZNnerl8m+K6w52qzn72qcEqGt0TD3ROT4gV+V5WnQcJin7uKenb8/uGiJkBXUs7IvOLm9xZgEwUitIUHrVMJnxvdTGW5CMxvP33kFSA+0jrY1kdNOWC1pM1fqR/8qmRHGWGA6UZmgNmL3K/w6qkhpD4Jzv5JZ2BbBR1wcAXITFcvIQBAwUsmNSCUYZN7VDQcwPEalR8bcDrvwS61w5GqLCE3Axxw4R83WVeITOz8ZNkvk6EPCIwf4Gee99nD+V64Oh+JcgVS53qBEE9jaA2v7m4sFzYl00ASfwbs3GZ8r9gmuLfnqMterU9Q2TB+t/JfRn2JvkPE90AmWtakHoTts8PkvhDtTPn5HwlbUbBvHlJQEF6aYbsGUdMP0Q9Hs9NKUIXkKSpVSaq9/WAfuoWIt0QRomXP8pbVxz6zOFtmmndNGgX2+vUjxOmPiiRwMR0YBYoHdieCyor3sne2S5TZ7sqAWeRwLKd74FiuGE9kexCdAxULoqxAkppsHIWf+r+n0MIuCel0VQ77bUS/imoAXEJNmAGLmGgq0ng5rhxcM1JoJj1nRhB3ckbdKacT8V+acGg2xUTFZacJZu0S6HRJL8xSUNc78CDM7vTnqELh/jiSwySvVfdKDHj25svLDkGJu4B0gw2dplxSOTLwu7+kmFW3zsOPfE5QaHgWIFvPW3OgFzFF7VIJPrLHz2Qz6C9vvR3G+xva0NusWypjpNGviQUEj3X3ATvmQu6ID1TzCtIWj5ZgIZTH+soKmZU4WEixLzuQXAn+nS9FU9Mik6domuYJgN/bcRMUSdyNFmRN1oQMsJ+EO6H0ZxzcmTGwwxsFWoT
 MXa8mIYG
 mkPDAP1dvJ6MNQLH4WKxzXhvxnk+I1v92rPDl1M/EAkvcK59vL2RGfjuaaEJkYIudCGu2Y00pNdGmuwXgsJIsib7u33ozUa6sZYuSNCTsQ9JbkPqo9GCpsdb5VQWXfq2M713Dwa4b1EZIUvFygUDzEZU1Zmys9rwKbhYvvpKHRMdKfkyjF//6E3DvXja811G1+Wg8wQmUArZFyNIMS3K31S++wvirSjOxkZqep2Mz3dU6BJ1GAZ6HTTpPfPO8qvDG+SUuAJj9+wWGcHO38DjFRiUmxNkqQt7f2gHEiCoiLbfVNRQ+SclA3U6dDrrnSXr8466wSsjORKtKaawqGfUTfIC4qwBc1OZxG8f+iHx8YGfR8yxR5eLMQvi+z2qbXtHBl/96SrNfjwSj+GWbjJ8R5PvhwOKZpzOGmdsO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This v4 is based on mm-new commit d5207c6d152c, which contains v6 of
"mm: Switch device DAX to section-based vmemmap optimization" [1].

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [2]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: unifying their vmemmap population paths.

After the preceding Device DAX conversion, both HugeTLB and Device DAX
describe optimized vmemmap mappings through memory-section metadata and
use per-zone shared tail vmemmap pages. The generic code, however, still
carries a Device DAX-specific population flag and compound-page population
path, along with arguments and helpers needed only by that path.

This series first removes VMEMMAP_POPULATE_DAX and moves selection and
reference handling for the shared tail page into the common vmemmap
population path. It then removes the generic Device DAX-specific
compound-page population path and routes section vmemmap population
through vmemmap_populate(). The powerpc radix path continues to use its
architecture-specific compound-page population implementation for
optimizable sections.

The remaining patches remove the unused ptpfn argument, open-code
vmemmap_populate_address() now that no caller needs its returned PTE, and
add a warning for inconsistent zone initialization of shared tail vmemmap
pages.

This is the fourth smaller step toward the broader HVO generalization.
After this series, HugeTLB and Device DAX use the same population model
instead of parallel generic paths, while powerpc keeps its
architecture-specific implementation.

[1] https://lore.kernel.org/20260930140627.57431-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

v4:
- Rebase onto mm-new commit d5207c6d152c, which contains v6 of the Device
  DAX section-based vmemmap series.
- Factor the zone mismatch check into a local helper as suggested by Mike
  Rapoport.
- Collect Reviewed-by tags from Lance Yang.

v3: https://lore.kernel.org/20260929053231.66085-1-songmuchun@bytedance.com/
- Rebase onto mm-new commit 2ddb90ee544a, which contains v5 of the Device
  DAX section-based vmemmap series.
- Document the exact dependency order as suggested by David Hildenbrand
  and Ritesh Harjani.
- Use the public order-based optimization predicate in the powerpc path.
- Collect Acked-by tags from Qi Zheng.

v2: https://lore.kernel.org/20260924075259.2013039-1-songmuchun@bytedance.com/
- Expand the comments around the slab initialization boundary as suggested
  by Qi Zheng.
- Collect Acked-by tags from Qi Zheng.
- Defer the patch making vmemmap_populate_compound_pages() static to a
  follow-up series that cleans up the powerpc vmemmap population code.
- Add a new patch to warn about mismatched zone IDs between a page and its
  shared tail vmemmap page.

v1: https://lore.kernel.org/20260913083734.86802-1-songmuchun@bytedance.com/

Muchun Song (6):
  mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
  mm/sparse-vmemmap: support device DAX in common vmemmap path
  mm/sparse-vmemmap: drop Device DAX-specific population path
  mm/sparse-vmemmap: remove the unused ptpfn argument
  mm/sparse-vmemmap: open-code vmemmap_populate_address()
  mm/mm_init: add zone mismatch warning during page init

 arch/powerpc/mm/book3s64/radix_pgtable.c |   3 +
 mm/mm_init.c                             |  12 +-
 mm/sparse-vmemmap.c                      | 208 ++++++-----------------
 3 files changed, 70 insertions(+), 153 deletions(-)


base-commit: d5207c6d152c88761f604ca461e67d6b0fe7402e
-- 
2.54.0


