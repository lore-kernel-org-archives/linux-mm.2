Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942E3F41990
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3E46B0095; Wed, 15 Apr 2026 07:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984A06B0096; Wed, 15 Apr 2026 07:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89AB46B0098; Wed, 15 Apr 2026 07:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9E96B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:14:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60F948B746
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:24 +0000 (UTC)
X-FDA: 84660531648.02.A076199
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 028B520008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J2oVc8Qo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Hg37UlEcW10cmklaT0P772ahobtvEU06guOHNmMT8sw=;
	b=AVRlxWTuGasa/ncGKeT4GSG2UUxtTsbXpESvIpru5GDtcJQTMNhH7UcFSmvkH8RXQaI18F
	w4ujunuL/ZL58sygq1s9J4+R2ApwphiFfCt9gieDs48ndoC8SQ0AorE1k3pZciP3UF9oAz
	6Nl0MxSDz4KnHQRHG6rW/N5R0mmArtg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251662; a=rsa-sha256;
	cv=none;
	b=Z+571+/bBbixcoQMUEQaOFNWM4hd2SuwQbSXTvf1u72T4VrWsWi8ZOV1L7pGkDWG+Mpec/
	xQ1nkYFq+nn+enghKmIe8pNN/1ay4trpTP2aqI2m2cfllwcy+IsZk4s3SqacjWWtyYyewn
	3u8HI17G6m6ak4BIGk8eoNatD1dA2Gk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=J2oVc8Qo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b2ea1b3962so21602665ad.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251661; x=1776856461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hg37UlEcW10cmklaT0P772ahobtvEU06guOHNmMT8sw=;
        b=J2oVc8Qor5PeElrauMuDv3kNgkVLkgtN34M0/6ADPxAeZOEZySyRrZce8pypurYGVC
         y+XN99nDrhf5/jJiBCQJhCCO8R1iAEETcmpvbc0DigCBAQ0EjW73bpIJZV8vAeLa+G8X
         zxbHs6E8S10bFVPiws+Ua150W0GhXM2M5+CSFzgRF1/06AwT4RBvC2rjyMCS/GQGXBgK
         3MmPwZkM2jCf8HHU7kgAJJMY9Xq3EgtqQ1oND+YnGhXBuS4hLGnv1yf/PL/gYDeH0+Ex
         jX8Y9wTKMHz11VM86+Xn+jGeGNU2ixVn8JrKmG9x5wefU7wyH6v0s20Ex9NV2wGIM/f6
         i80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251661; x=1776856461;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hg37UlEcW10cmklaT0P772ahobtvEU06guOHNmMT8sw=;
        b=riE7XAgO8Z4GSyepD9GnDUOpIPFP/sMwKEyIGp7LXLw5pnP7zTvhElDMtb1vice5VL
         qkl0Yk/MDt9fwQS2iDUBe4L7ZKgbdGSy8aGuAXSpviU0PI/uKsCQJseWGA7MR/kCcQj9
         92mVJNscgHmBE2BEoyFcWw7AU5RqzGDsAeQypyziYKxZIJV6vdHTON1NbGUcU3LdxW3V
         +D7YXqHonFJLbiMCOgb8zL/3nA6tRbQLWXwpKIUPpygraLNYgh6I7IEm3p6FbFp2nepc
         d0i1H51hWXO6f6OEaIS1oPYkAlTswYeXlwFomVOh8i8BEiUCRI93ghRV+jWqBDndk91A
         6/lQ==
X-Forwarded-Encrypted: i=1; AFNElJ/yUSUVXiMJsADosb//ibiIcpdzc3gob+mYXjRlOpr/vXSg9n9qjsQfv9r+kkm7CLin2N1VxcTe1A==@kvack.org
X-Gm-Message-State: AOJu0Yx9jzwklK1ZVblKB3RpMh1CUCDY7QVwBGA8SXetjlYfj2TKkU7n
	IBnhLsSeWp1Q9Ho1cLcrdsqAGG2yckfknQC2lQqEw3XvZUKqiMDEig1CdJLEpXBZykU=
X-Gm-Gg: AeBDietJD/E8dkXN/1ceJ0vw6+tEsei64m5kxsVCkIX0enXBX/GZ3GPiXay4YzGgmdx
	RU7W6j9WWzo1dSAEnp4y40x/2UtsvmI9tLV2tTdDBaNCwE4JTva7xZByKf3sVeT2LG+YRBKNlxT
	KdeyFC74W9GJ4ZqyQaCivPup+XWxeqDp8utO0T6voQHQwnbnt2jilsA+AMLGmjPTTK3pKFjIb60
	43RsqXhqje5HBs+rIkbTXyNjzOru7AruMuKyT/nITu6Z222t7yKVNG5jO4Y8eTTS+P/HH2EIij0
	oG3MLO3HwQL1WYRTkaWEbjLtaWDFWdk6mCVr1NZrqPhmZdR58wCEcGCw9xLtzfoWKG/qRwhdwJ3
	tSDfEib+uyezwpaxc/kmB6alcGv0NXTGq+AC56jDGadBqxwXHgwwTZb0eGxhLSvp+3f27r1TAYi
	+mXqLJQfOEW6H/YGHW1KUTFAmXyiQmbfqDi4kkF4Sot2c=
X-Received: by 2002:a17:903:5cd:b0:2b2:42f8:1a45 with SMTP id d9443c01a7336-2b2d5a8ebc5mr145530325ad.39.1776251660541;
        Wed, 15 Apr 2026 04:14:20 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:19 -0700 (PDT)
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
Subject: [PATCH v2 0/6] mm: Fix vmemmap optimization accounting and initialization
Date: Wed, 15 Apr 2026 19:14:06 +0800
Message-Id: <20260415111412.1003526-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 028B520008
X-Stat-Signature: 54yrkuazfknoitgw9p4nfwn5nomq8u9q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776251661-283213
X-HE-Meta: U2FsdGVkX19Ig7l4uwBSQ1idn5Zul2UZ6LkJp90JMIquUhHbA/i4Fy5CxFzF5SwDliwH8IUOrQ8qhWRfik4taFcczA8tuWYROgWQm1cuYTO/dat/xOzpd5kiaje6XsSO1nW9uvRNGJCrtscTe3bkZS8fY4CgkpfnigIttbcpIsFnGN+OyhBrsc7zv7qSQT3qupCw3YX2JBzb6il48eZ5rG0yejdgcjxEXpknWaoEppxQ7/jjilsmhR81gzsL4KLQzLabkqBfAbYEUibXNOF3UXWJx6LFUEHQazPLuQnem+khZq31Al+pIO2xtSwo68GQw/tajuJjzzp+vhi6DugN3VusLg7LLAwzdSXUIQr1AB/lBz8T1ILJ49rwEE6L2IQNh3oShK2TwK7TMzLMkDdN3kqz41SV7QuT3ULjNH68I+T7du7lyeuMv2dxRSjot6UbFQjtFakYwruXEdAjRBOx7/ev9OuZd4g30GDxGg4Wvk0SvVFiERudrHmQMS64nKmrFC2gm/BoP+EgFGK9H456AduZtX53I5F6JtGzqe/HyOHvBUToehZVpPQgO0Gpp7/+Z05VeOpAU858afXG5Jfj2CM7KcEblGzB0gbepsSCE2MxqiqagIlIe9tG1nJ/nLR+lljkY6q/DshD5grbTkwRNUjufTonNofEQ9TrAphvQL15h1cyht6z9XMd4g90KR9wQ3f3Z1S35OmwK2I3yRPmZYK3T8tw9spNr7umjceIjlF8YvoA+DmbCiyhXYtfmyjQGe/xrbxVrei6JwUjXQynG2J8E1QWQESGiltHqdKk8LvzriRhOt+0Cwa20Q32Kp0ee9GyZk3IVd128If7l2NkCZprI7nY0M6ytpD968gUmkikP/OujgQiKnoi3lfOpnIKWheAwxHd9K0LSWsOGvMMPj8rWyR7+4xxPzj9QugxgcQF6+mJf2nqxfFC8hGsRa5JMifcZy+gFbEpN3JE9XF
 Q1DohnqR
 2GDuucUtWtJTCgrB0mceOE5VFJNY0gY0VSRTtuXJMDSZjrMjgg9Uop8jaKqKvx8KSUjXAHzFpCs2joPpme8rh74BrC8LugJ7+Dm5sQiMtrhIrvIqGXex/gQhDDd/0egdjRZLeApDLnUaamHQfE5I6ZnakiEi+2MNoXClTwcyRHJ2yp64UUJ39xtCjSadIXsT6CZuUWVAJz/J28k7h/5TPukLzWQ8lDGzIZHfBt5dTsDdSFa1ecnWk+U9FJDMU4kxD2sLyIIhXqQ0qakMf5q+y2D3h7FZ1oUpW5OFCrmwwZwhl3XkdE8tPK1IHuHyF1Q+IxyldU4ju8lvVGCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series fixes a number of issues related to vmemmap optimization
for compound pages (e.g., DAX), including incorrect page accounting and
missing architecture-specific initialization steps.

The series addresses these issues through the following steps:
- Patch 1: Fixes a vmemmap accounting underflow in error paths.
- Patch 2-3: Fixes DAX vmemmap accounting by plumbing the pgmap
  argument through memory deactivation paths.
- Patch 4-5: Fixes missing architecture-specific page table syncs by
  plumbing the pgmap argument through vmemmap_populate APIs.
- Patch 6: Fixes pageblock migratetype initialization for large
  compound ZONE_DEVICE pages.

Changelog:
v1 -> v2:
- Moved vmemmap accounting to populate_section_memmap() /
  depopulate_section_memmap() to fix accounting underflow,
  suggested by Mike.
- Replaced VM_BUG_ON with VM_WARN_ON_ONCE as requested by David.
- Reduced frequency of calling cond_resched() in pageblock_migratetype_init_range()
  based on feedback from David and Mike.
- Extracted all bugfix patches from a larger patchset
  (https://lore.kernel.org/linux-mm/20260405125240.2558577-1-songmuchun@bytedance.com/)
  into this separate patchset, suggested by David.

Muchun Song (6):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/sparse-vmemmap: Pass @pgmap argument to arch vmemmap_populate()
  mm/sparse-vmemmap: Fix missing architecture-specific page table sync
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages

 arch/arm64/mm/mmu.c                        | 11 +--
 arch/loongarch/mm/init.c                   | 12 +--
 arch/powerpc/include/asm/book3s/64/radix.h |  9 +--
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 18 +++--
 arch/powerpc/mm/init_64.c                  |  4 +-
 arch/powerpc/mm/mem.c                      |  5 +-
 arch/riscv/mm/init.c                       |  9 ++-
 arch/s390/mm/init.c                        |  5 +-
 arch/s390/mm/vmem.c                        |  2 +-
 arch/sparc/mm/init_64.c                    |  5 +-
 arch/x86/mm/init_64.c                      | 13 +--
 include/linux/memory_hotplug.h             |  8 +-
 include/linux/mm.h                         |  8 +-
 mm/hugetlb_vmemmap.c                       |  4 +-
 mm/memory_hotplug.c                        | 12 +--
 mm/memremap.c                              |  4 +-
 mm/mm_init.c                               | 42 ++++++----
 mm/sparse-vmemmap.c                        | 93 ++++++++++++++--------
 18 files changed, 160 insertions(+), 104 deletions(-)

-- 
2.20.1


