Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9A3FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F406B0005; Sun, 26 Apr 2026 05:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8502B6B008A; Sun, 26 Apr 2026 05:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F1B6B008C; Sun, 26 Apr 2026 05:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 617AD6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 055D81A0530
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:08 +0000 (UTC)
X-FDA: 84700178136.29.74F3506
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id A44A0100006
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aR9P6T8w;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iZUxF2n4jgKeeubqC5qvDAhtO/51+Y+R8j9b6gRv+Wc=;
	b=uwBfKj7IrrxGPtVILTqsorYCsRmXTWqaPrT4J3QO0KU1yTZULXZGwja8kgU4Xlr5yB7o+L
	ySnaDYyZmR8yd6NCq9pK3LQ7wOYBYTyHZDDZ7kUUASQvhXwCsygMm5iBET7X0iyDNR41/8
	EHpxLYVI1BT03lLBJPy4nxiormqv0mM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=aR9P6T8w;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195626; a=rsa-sha256;
	cv=none;
	b=Ld1rMk4tdnZ0bRImcmt8fdHLZBBLaAHZGWbvzGbE0F4R4HMQTzvk/Tk+2/HX9V0UB6PIKF
	3eSf8DBM0J+pmzKINeSvNXft/cRoJXz7xxp3jC7Sm0CZxLqWDGiSQlzbjVG2Reltirr9cS
	pS9Xt1kZYquvs2n7L7RnEqXyDr5+nJ4=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b788a98557so41724835ad.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195624; x=1777800424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iZUxF2n4jgKeeubqC5qvDAhtO/51+Y+R8j9b6gRv+Wc=;
        b=aR9P6T8ws/4/UKWhipcrYXsGdHnRUkyoeToLqK+UTcKOoui+FTbgT1E0NWFV4tlOie
         y0HJrQJuSAdC1TtlyJnM9nw7WmTIOh/7dphun8FkV+2+OAEt0JAi1nJd6gHUIGwUPt5B
         hu/DRK5RB6PGx6j3yjEb5SP5IiPzCmLAdt0YyrPEPS4eoQMtUgPBTIIGQMMIlH/OT8XA
         9GfNRxL/DKA5fpoAFD2hXNokDon4jUJ29t0e027lnWg3+6Xapx00raepw3RbdnCU+P3s
         ETCj28oLucNUulpj4zKcIVNsyCrUlKI+rHTku7dkFcO/SkuuSuUdQSgvVFJqkx3E2wVk
         ZvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195624; x=1777800424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZUxF2n4jgKeeubqC5qvDAhtO/51+Y+R8j9b6gRv+Wc=;
        b=eXOSMDezcFc/dckeOshmiYSYX8BGW8++KTGwjpOoik5Bov3Fnt0HqZajyf1oij6dTd
         m68CVY9n6Q3cZgqqC7oRAa6kFx0ZG7jEboDIayg0pqbmcHmz8NQfURvmrWdUug+pOqim
         T/BJ5cvBWY5Mnf7z3pK++6gzt7GSzRBxeBWP4KpZjesc19B4DpABfmL32q8yChBRtO7r
         wq1ZYeVwbv17nmP6bSUkOG26UMMFpGT0zNdUEH5sphtMniQIWfYrYdNDvjiiX6R9gfa6
         7aNiheQy1CduUhER5Lqd4tPxyN75Md09WilZ8JM9oFEIXRzp8vWFkKAbn1iSzUFcvQde
         lIXw==
X-Forwarded-Encrypted: i=1; AFNElJ/75nTWoFWVn+IELYxkqqo/4m4G3iauMHi6ELjIgJPO/4qtj298tyo32O92/PNqtjAJd+vt2UX3QA==@kvack.org
X-Gm-Message-State: AOJu0YzOejA3i4NCbGpZL+iMkEs3xJ7o+p/25Dd61+jYo47dMxT/MQDs
	BGYY7tFbdYSw8ofHGu+VFfo0+ArPncjj8Aw57/hmbFg6FstZQy7mVxMgJ/NS4yFxTGs=
X-Gm-Gg: AeBDievIwzLI/6OiUrFXD68e4LWvfBptV0mqf+bK+463CCqzLg8w/9hFhG0xymfJ9MB
	X5zwKRkSHsPi6pbm9XPNsFOANgtNFMoENMMYk0faOUcXoN4nuhHxNL17oMDmIVNBx4GJYUY6IJ7
	u8tni1minFyi5h2VswyYkJcknentg7Kpmyao280q8CAFu7Q0ehUiTpUgFPE0dOBIvU1eDjiN5me
	UkffZI0jMSPT7ELhBzzzbHyBXpnBnzjQJ7Aq7KdstD1VsS2+4EAgqCsOLiWTANdJwYTrVEORx0i
	f/7ya8P3CK4oTJM0grqvKp8tTGX/NWVv3PywE4CkwAgVDHjSHu2bp0KWZgQLJozCh6By5QwTv2g
	/e3WC05sL1Ge06pCgfK63qjKaugn4B7CKGe8u7jb0nao7FHxGFHcwvBYk67pTlS9nB4YsaYpotT
	W39Hf3xdz/zXHFIYfKtVjTDJ1DRSs+
X-Received: by 2002:a17:902:f710:b0:2b9:4941:7f6e with SMTP id d9443c01a7336-2b949418316mr52947595ad.2.1777195624237;
        Sun, 26 Apr 2026 02:27:04 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:03 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v7 0/6] mm: Fix vmemmap optimization accounting and initialization
Date: Sun, 26 Apr 2026 17:26:34 +0800
Message-Id: <20260426092640.375967-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x8ttcxh6zec1jfn3eqggqko6b3gxkm96
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A44A0100006
X-Rspam-User: 
X-HE-Tag: 1777195625-968635
X-HE-Meta: U2FsdGVkX18z0eG06UOSb45vyh3kqlxExHvSdVxKuUGUcG1JjpMkIz/UKv/8zbYEXpUssqncQvNzHZzCdAUzKaWkRqDH7X1MM87LHBX9uUMR9qOr+2RuEVLlEqoptvWbLP/Anam+oNWH/CWGm15ahckeuuYOo1sse71ZFGB3d38XIT59YMKXf9M47CEkvG8/1nYWjeQzwXWOVux1x2VgELLIlB+rsQC7UMK9lPMc+/y3+ORto4RAx2up7A9LgAg3LnytOLb6n8iheQIvgPPL069bbkKqvzioUn3UUQBMJeG/MQPJDDPN4uGDaEb3+iZWt4T4ruV4V1nyGy5eUsfjoWnrOxO12Dz31e9R6m84P1gHRYXos/Z3VcX0k6oYA/m7Da8f0ay1+r6jD3WNARUilmbBw+JnlN4NSv8RPxWBqV0DUfwQDYKlzPKZ0gM7MN5EK672UQ5NDbYzdVNh03SfLXxfhxWl08nESW8XTloW5Cmnb2j2lQkpMLTd7AersLsxMWWlPXXVz7b0OH28MPHXjELCxEgCPn0dKAp9nFMZu7xRV3uqXpGryiKf+Mu4j4ARgPl2ECIx95E+v4e2E2RSKdLo7v+OFOKRleffx4vshWbvcMQtM/jCaOUnL0j5CVqH2+YAhXiYit529siXfnW4XmDty+cWMsZRRHxt/gl4r5oZGHW5/PuwtrunDamTwrKmsD916Geq9CtCVkPw2/DTquPUvAE4TuiRi3CnHEeASaGX7p9JNzpsco1w4kGHN1YhvAGWbwVWyXa4PJLHnTzazYFkMXGR7ZkWr71WwogMYde5fJ9QXM08+iDH0LOnLy2bXaDC4I29Z2R811TX7Wgi0MRDaFUJCtZEhc0msy6fazREaplb+JMtNTMdAOD7bJnGEvzuywXpa/us9q4sbv3P4COhoXPLhCw8z5MTtusuzL+D93OQYZ6Fpvlf1WWJjJ1euGgaKjKHASQgRnLuKnV
 Bh8ZL+ip
 zWH0yEw6/4oSiFmfX1Mum0IPGpPoftDZWmJ0jblLreFV+AhUHst0MLKKVdHOH0pasxb/dWrG6PBjLS/TRm4NvaqwMiAJu4kvZM80DM19BW4uy+SoFpIEDHTgNbD3pF99fdQr6ont3Up/Xhyw9gWbZ89ZO3tCzauk/6YqCCyi3iZ1Mqb5Du15twHCQT4nCe7EBG+83uAG07y97gwN5q/KSdMXB8IxwzRvaO6aVBTXbr+7+9mYQ3aMQq3ZYZR+bxh+QmlO2XnmpIF1d0/NToVEo/lsfpesEzLK8y3i1oM7M1gHoZsQBYlCWzzMYSva+K20RIuKY5LOKPJJHoBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths. It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

The first four patches fix vmemmap accounting issues. The first patch
fixes an accounting underflow in the section activation failure path.
The second patch fixes incorrect altmap passing in the error path.
The third patch passes pgmap through memory deactivation paths so the
teardown side can determine whether vmemmap optimization was in effect.
The fourth patch uses that information to account the optimized DAX
vmemmap size correctly.

The last two patches fix initialization issues in mm/mm_init. One makes
sure all pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized. The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.

Changes in v7:
- Split the previous series into a fixes-only series and a follow-up cleanup
  patch per review feedback.
- Drop the altmap-freeing cleanup patch from this bugfix series.
- Make the alignment assertions in section_nr_vmemmap_pages() explicit for
  subsection, compound, and section granularity as suggested by David
  Hildenbrand.
- Collect Acked-by from Mike Rapoport on the ZONE_DEVICE initialization fix.

Muchun Song (6):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/memory_hotplug: Fix incorrect altmap passing in error path
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
  mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE

 arch/arm64/mm/mmu.c            |  5 +--
 arch/loongarch/mm/init.c       |  5 +--
 arch/powerpc/mm/mem.c          |  5 +--
 arch/riscv/mm/init.c           |  5 +--
 arch/s390/mm/init.c            |  5 +--
 arch/x86/mm/init_64.c          |  5 +--
 include/linux/memory_hotplug.h |  8 +++--
 mm/memory_hotplug.c            | 13 ++++----
 mm/memremap.c                  |  4 +--
 mm/mm_init.c                   | 47 ++++++++++++++++-----------
 mm/sparse-vmemmap.c            | 58 ++++++++++++++++++++++++++--------
 11 files changed, 105 insertions(+), 55 deletions(-)


base-commit: 7080e32d3f09d8688c4a87d81bdcc71f7f606b16
-- 
2.20.1


