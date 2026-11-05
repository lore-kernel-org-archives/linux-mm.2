Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30AC3606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=A0asIXZI
Received: by kanga.kvack.org (Postfix)
	id 16D126B05B2; Thu,  5 Nov 2026 01:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FDA6B05B3; Thu,  5 Nov 2026 01:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D426B05B4; Thu,  5 Nov 2026 01:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5D196B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:12:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40CE8160956
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:39 +0000 (UTC)
X-FDA: 85400046438.02.498BE45
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5D2DC1C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=A0asIXZI;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=86mQJyKlXA+m+CUFz+gI1B4tAIO9REzBudSQUtfJrm0=;
	b=tZNP4U2yU3pVlAFCcOKcFmuDxDJq2Rn/649yxlG0W+1Vr0Y9FcVcLSPo4gYrketjMQDW5o
	9nTM1ixatOv7Y9ri4XesjMZJ3raThqdBPhiklHFVp+gyDoud9VhjDtpGncWcfhvlch1ogi
	sQLBDTyyFPV8UCY1LiXXdjbXHuZFzZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793859157;
	b=frsUmVSz4EIi/bHVV4o5sw8PKYNyYAvQbFSj5Suj63EQqGXq3ocNjYTGjMaIDA8nOUYFaW
	gnb/xFoxf3hGXALtdd/Y3pYTM12jzCS/b2PoDueJQWAkTtVqoqFPJCAjrYqpMnOnejO2Xa
	gLkbKaqLIxgZCH19asBYrNnGeD8218g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=A0asIXZI;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so1027658a91.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 22:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793859154; x=1794463954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=86mQJyKlXA+m+CUFz+gI1B4tAIO9REzBudSQUtfJrm0=;
        b=A0asIXZI6VDDiMiEeSdQW1eTz6eca3DuS2DhnN6ckcXTp2F4clZS1Jif0IXYo/+Haq
         PPJGwEil8vLtN6RHUg1B7rOdy1K7PGJRjhNDScSlkqB7Um3613e7jsAiQZPieCnnGGIS
         cDbJdrM2HaOkR4U0AxEC0X50vQpSvowYuSXOgXO52ulnARB9ce+B4uQHs0DSna0BtZqE
         MoFuicX+R3bZofCzEiB7PD7EQm6/ijzIkl6Z/bk6Q8FOky6JjdotyoGVCWZLYG97l8fE
         y/Ehio5475rchbngIVPakjRB/IrAEfu6JbVb2uT0ML8jMWUYKnaOfn5hUqbu4GVx1nn5
         DJ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859154; x=1794463954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=86mQJyKlXA+m+CUFz+gI1B4tAIO9REzBudSQUtfJrm0=;
        b=OkgkZSrFMvMkKsTmpO52bQwU4j7tlvPWwNx+B1gX0Ne3Urrlq7RrlSvUkskFZ/QJa+
         i/bOJT6LUe8ZMBfDCMTQh04UoB2fmz+YiEAJVz7eJs6t1aRX5CmAcXrsFJfs8PCCrOye
         tdn2IuFzDggopdb36Bgn6UAF/Y3y3B7ywNQ4wD3JKVrJCviT0u5NESSU+jAiZb89NkDj
         iE8NqsN0tth+4sfCaA+eGPIrKw3Mrh6Sp6A3sM41xlsV52JmI/jRaKl55AqEzPppyoLI
         NC4IJbonNUfjNBXgdeO74TrIhmKyeXGEEu+dlbWRaB/SfNqUSsJV0kWzAHjlW5e+PGkb
         JBrA==
X-Forwarded-Encrypted: i=1; AKwUvBwcSv/SsOx6hPHXLA+wB73UcOja4egguLs8U1F/BF3yfRJ6ZC7cWKcARXlWZ8mLNJXnMWZQRMkfoQ==@kvack.org
X-Gm-Message-State: APuU4Z++HdNDupRb7Cx5bGz4W99qdXhGXLO6YRtiErPj5gulgtB3zfrD
	f3Vj1egnvpRNJsA5Kfwzpm3APtQXKJWjb9dfxnpHNVfN0o6lf4U1RpG+h0VOXj1VlQ8=
X-Gm-Gg: AYBFou24ggCWWR8tiyak0zb/XFTIVQEw3C8PKoaIQYNp88Nz7K04usUeT2IN/E1COAb
	pbzyNuv+GcJgLLnbc+/1nTUvqgUt2pkdlQk8CmR9dUQjfvqbNWbF8aOaqdAlrn7RztcOqhinhvn
	pmkpwBQB/F3phNDxNv4i2A0l5GLgiB+sC65ghIHucvhN2gAhWnYqNBxswFhUsdoFGYuNqhIQ6mk
	5x2Coo+4HzBGi11shXU9VR7fEbW12XGS6WrpC/D6Dzgjfo0kHrQoAr9zmbVxRn/Wp6rGKY1h8aQ
	gIRYVlyMpxqqAjDguoxRcpDDo0jduZCeJq0eiyRyuvC9INBiH+0y6PalmJxHVwH1iWPErG4aKFX
	RtxqPBlNvTCwKspIJ8MBsZarBRKUm9zL7W5sFqPDau+Ro6j0FcncYidefB6+OlTvp2s+yWN5g7b
	xZeYRafSCRse5QhoBlerd3e+WwwG6Xjf260HidUuJa8RWCKFTPrFXFcPg425/9njbTlIAwdbtDj
	0Ikh58tCJDJwvYXU+hMLbMj8mzaHhPCjIENieSQL8rCN0HzE1HLhJLAdC8ycrWzpBUh1RjwAQ5E
	3MKivGo6GUEn2OTKv2khqqXzxiAGilvuXkf5AYVsFAYGWl9S9oz000eM/tjKyJPjaw==
X-Received: by 2002:a17:90b:3844:b0:3ab:36c4:b502 with SMTP id 98e67ed59e1d1-3ae89814e4fmr15532805a91.30.1793859153687;
        Wed, 04 Nov 2026 22:12:33 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm2107528a91.5.2026.11.04.22.12.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 22:12:32 -0800 (PST)
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
Subject: [PATCH v2 0/5] mm: Simplify device DAX vmemmap optimization plumbing
Date: Thu,  5 Nov 2026 14:12:12 +0800
Message-ID: <20261105061217.13302-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D2DC1C0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 53t4zwk7razd9sagfy9ggyaxdc1ur9kx
X-Rspam-User: 
X-HE-Tag: 1793859155-328855
X-HE-Meta: U2FsdGVkX1+gvEK7JVUnBKVkAMAuTgaps7ZYyMYKlh5S+Wy1UnRY/2XsPSVMZq9dGISQpgSucjpjZV1nlB7a32/ZZHsl9N0xqEJh//c5Rl1iNGdOcWbnZyhrTnhmIkO667/uYRCafm0uXyNXbhhk/G62PjUvNAekwIJfjjJUeuc0jGvHHlRmt2SNJaxP9jVLJ6i7SJIVUextYA5DlOopf03NeYt7xjg5md3ItwplcX6ej4M+fKhFHrStPLxeIPXMhZyQqK1BHNPqmR6nDUYzvSD+9pqa1UGtos19pjBBPAmK9MPbZS+/smuD/iYa8QlpVM2a3xZl9HzK4Eg86G5k53UdpMQWHZAjI1cVHdDVfSFTdb5f24/YjZoW8SeWxq8IppznMfroEak9I+aqTitRNh1Ms3Y6dB3Dpp7XzrtnLSwl0yhUYryvOp7zsGW2BRTB+3wtpc4nB2X3NkG1Wim00m+rzDSCdSpS546gRgYsiPQDun8nNgjonYPpjSetEIbqWp/UVRcXIk9aWgpSgD2RHSj4IkX+ESIIYQvrcPkMzjelpMAnxNzhCuoVJq3zLA/FCnvCq2GNRudGw/CB1sUUifLg+YqygPFhVyIJJU0gjTGyW6OlMxwpMEP8tY8s/Yfkw2f7GJha3FlFcCZx32nNBIdxQRHbi8qlccKPs56JNKzrg3LdaNSl+Ki2SfGJQT84HqwlHVyQKmjAQjXnrs0BRxg1isV3gLSbKWEgEf4hxCmTIgjwSaj+18Mc+H8qXRqYa1MIOVxkDpdLHLh9/NSXrQaqANFdmLm7k2gz5l59e0/hUzyfVCpsCcSFJMVYkcMXikQqWePWInMgjFxZR482bvGr2DomOjL85kzO7vUIcMFhCEobxy4HuWEYNpo2rS3Lc1i/SMggvODiLRTx2NewD9JqfKhCzC/FLlYp6mC1Y5MhMLdCtVK4MHjHO5vp7+S6/mfbdbAAb1kANGb3GtA
 gL4Q/ZdN
 vbPPab7r3e734pmlvMD35ng0e3FWu0nEdcy1L1tgkycqEYpsizHNBH4t2hAvr3Zl48tnIesB4fyBHcSp/4g6qGDUYVtmJkru+WrB2iPL80RwWp0O02IgD+lVZORG+PdXmUTvUqGTrO7H7y4BmKf3pPS82MZEdnFjaF+VLS5kDI2TsNxLvH3vi/Nqqujxt7WtSq0YWo7MA2qb6ZbLzkRUVxwEXZNQkM78FwfV4JfXXKMXreLZHsyyrE27lPE3Jz3PsNdmkXJh22YXPYI5RQAeHLoYDPwQPRX3rRyInvwbl1ZvpjUtZH7oC0owsFd9VMhn62DyakX74mC+lzKpxdtTxQYcUDVldt2lmwQHVGYhAod8NvlyqxSJsFB4DwhFtv6nTzbRASPus7TVWGB2dNpnVHFcCaw979zehXgYa
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

v2:
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

 arch/arm64/mm/mmu.c                        |  5 +-
 arch/loongarch/mm/init.c                   |  7 +--
 arch/powerpc/include/asm/book3s/64/radix.h | 12 -----
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 23 +++------
 arch/powerpc/mm/init_64.c                  |  2 +
 arch/powerpc/mm/mem.c                      |  5 +-
 arch/riscv/mm/init.c                       |  5 +-
 arch/s390/mm/init.c                        |  5 +-
 arch/x86/mm/init_64.c                      |  5 +-
 include/linux/memory_hotplug.h             |  8 ++--
 include/linux/mm.h                         | 40 +---------------
 include/linux/vmemmap-optimization.h       | 56 +++++++++++++++++-----
 mm/memory_hotplug.c                        | 16 +++----
 mm/memremap.c                              |  4 +-
 mm/sparse-vmemmap.c                        | 29 ++++++-----
 mm/sparse.c                                |  6 +--
 mm/sparse.h                                |  5 --
 17 files changed, 97 insertions(+), 136 deletions(-)


base-commit: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
-- 
2.54.0


