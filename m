Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385EEF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4668D6B0088; Mon, 20 Apr 2026 22:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4163F6B0089; Mon, 20 Apr 2026 22:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C786B008A; Mon, 20 Apr 2026 22:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 258A86B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ADC385C55D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:12 +0000 (UTC)
X-FDA: 84680960784.14.FCB6B85
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 07419180009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YsxQoOXp;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738070; a=rsa-sha256;
	cv=none;
	b=o5Sx4nRwBJ+zWV4TlMlMSAeZbanQLJtBoWm9OdLr1RvaKYchEHiy+lfD4iXC3FMaHwjS2R
	nDm+XfyNwZmds+0zDKyXgvpMo4HL+i2jpbysuTyco/RaFTjy16gjKgF6B+38tBNsKWv4TH
	glMYEYsRd5LApowulRlXJR/ZspNYEEk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YsxQoOXp;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qcnAylFtx6soM7u98F+sq6AMHsS/6wPy1LO+T0Gz9iU=;
	b=W8I5HIbXVSUJ6w4KzBhql/foGKD22Ipxqs7Juf3M7BiUFZJmxEcbaNXzuY0RZWr5apBsWu
	CUVkc7OuGrXpszTWEKn8xQRyJftthAhmaDH+GAnE/0uye4ISuzdLUDAn42FFQo4rGRAuCr
	yUrdnuaVUZqi7ZCoVvosKUQOigXoOtQ=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c70c112cb61so2474814a12.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776738068; x=1777342868; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qcnAylFtx6soM7u98F+sq6AMHsS/6wPy1LO+T0Gz9iU=;
        b=YsxQoOXpbf73ojIWWHn7ZUtp83VqS5f+tnl1vFPSDXkzN4xpfkBFMd66NnreSM1gHE
         LYM08YwOyR+DSrNAvEpe/0FqONzjKy+fB0SfPuX5onkPV30KdKWLlfAG8vbJAP6uaE0h
         uiOThDLugYxhg2H1o/qLnDc9awyBXRFGKSzjjYitIwgJkByAztIlPYn0W2KHkEILhigt
         gi/zhJCsCji8JJQ5Vvu22jxw3XI0nddWwee2uwzDUGIV98Qy7/cG4h8se3Twzucq2847
         /0XbzdYsuoaor4KvU+KmZxr0yNkC7thDtiP5iEHz7biwYu70ADpTkwWv+MvqTmdnE03L
         BJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738068; x=1777342868;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcnAylFtx6soM7u98F+sq6AMHsS/6wPy1LO+T0Gz9iU=;
        b=OkVfRUKejkGPjdcDOhEDIqv1mV3fm1QlDU0EoTIs7SwhOJDbCyF6iVpSyCBPcCfsQT
         jMc0mh3ZqcNWwM2vfEWrzK/8I8+e1MS2/+xH+UNbfXOtLcLIX5TtaqhRiGy7uJe1Dkp2
         bdRTNTpLlXb7D5Pua+uR11Y5iD63xVftZdlxpIiKbaxD3ZFe0+KFn0sppUaExmHqG0co
         mgBGcubtm9GXnL+3MVCs4eWLwNepExZ1QuMUubpY/J+joiLFOPlVokK2NIOBLIHyvfv2
         kr/G1iRLHS9ocuQD1NczMurIQ1ovckjqxYPX2KtJUdNFRkk+pid0P92gtU9cnLxwVZNX
         6Z7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+EAOOCF9/xl/K7gsX8h+Nhb15xUCgWwSebJdo8pJtB6dBV3F4WEDfyKoubPJskNFgLAppF7Ae5OA==@kvack.org
X-Gm-Message-State: AOJu0YzcTpQRK23MCVZ+iJ46nGzLpWncFCc13Qesn0vNTZI9EEaBSGi3
	c+0MKhgwkTXTNghWE/0q39cSz1/3wnaP+b/Pr8lS07FY3jNPxJerVlnNuIClbwx5KQw=
X-Gm-Gg: AeBDietbHUHY5Vs+91f9N33ZUdj3RreQu0qMhKkUAGK9rGXEAdhs6vhfF79n4lmJ06s
	sJZDYmUHMm+zP/dpbDxBEjeYGCjxfkavuBQ4KrcHtwii5+vt095RJRQHEcneQHN4F+aVqj0W2nC
	3HMX7BbgVUliPsGuog3WGII5J4RSNAS4cb8SObW1L9JnWfcRLXlbUoE5AV+5HOalLk7/OSLsX4L
	IhnM02Zz4Ui6L1hSXEKOZ3aWgGsV495T86eX8FjjyfJgOovFzckBsVzNfwa4tUyEdogdLnEzGp3
	AtzjSYx1eMGHbJgrKSwKh8yhFkoJKXViLtvNHUcqGXcMzTgK6ctbusSM5R+gGkufnuRa4dUdUVT
	OjT0WWonjpCEjzH29x1nC5VjJUH62LMYV104E8DzjnQADjUBTZ3jdVyP7aWkqdwssV0VOBMhtLR
	lMiKiPU4AKLMaxD5Y934AixCH52t0F
X-Received: by 2002:a05:6a20:9191:b0:39f:5671:921 with SMTP id adf61e73a8af0-3a08d6eb3f9mr19080715637.3.1776738068373;
        Mon, 20 Apr 2026 19:21:08 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::340])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f932dabd4sm11538780b3a.51.2026.04.20.19.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:07 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] mm: Fix vmemmap optimization accounting and initialization
Date: Tue, 21 Apr 2026 10:20:40 +0800
Message-Id: <20260421022044.1217503-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 07419180009
X-Stat-Signature: c5jxxisbahnburpicqd6bfbnesw53xma
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776738069-998342
X-HE-Meta: U2FsdGVkX19yR3cxbTEdni5Px6m0Mw38i6mDzopNGfxPAdWOBUkWEjO4wXMwW1RO9zEclOenvVfe4rug3vDxWmQd7ipfp9olexaZmr6pB6EaH1pL0KvCjZ5wItA6NxNvGO9YHz6zFn4horwDuRKM2T6o0tHreN1+9IR6MyiCA4MZcstEzg4kpTAf6bOqmzZI+BochZRLVV0H+cM8Lf1y+CR8jhUtomlMxQy/b5Z9AovVuw9TYiB1hfkku+ZvQExJVTJiVxE8Ha237ga2qIK+qsMOE5cbmBiS0eHVjajgTv46QKWmyR2PaAOQVunErTj/kbVd3rv8gSHxh+CNfc1it1GXdVEsCQ4mV4XIC8D0hQfMpReBtUiVk6Qpzwpbn5eB1lB/p9N82Ab1+raRWSlidfceMyxGbTrei/kVJGT3sPrBkPazOJvteZCgGDBgc5CK9S0KOo0z7oz16X9jbR0eCeianCV/8F+j/Ba6137iupOzUYZi7kN35nbd/sJvf1vcKPx2Q88o5rJNouWZ9T7WTqpD3cvBl5MsPEcjnZLXinCgvdbqRLNd4XpOSOvuFUQWTl66Z/hVKMwPpYwjA8nD+S+sBbVYXElJsxAHTLCPTvGGrr6Mi46LbY9HAKICCN6v8rzQTuHen2BFEZ3nzJ9BzeMYD5T5Vl5VuemV26nFSnTaUC9IcJhxcdud2QdKL2tIgUT/jrq6HSDk2yP1o+9KGvB8RXR9sHJHQQMvb341SI9iRWNGgJPmh2quX/HLyjOxZcs3DDkfJmGWrvJSybya2rb2xg1fh3ECdzp+867lsq23nGiO7p/Axncw8N97QA64P/ayNwhq95LJpQbwrMJc1SlSU2Vzd3gLK9UHPKCdhv6UKy6JvDEgdp6EZ84uuJgdWA+6iDqGZKRJ5WUG6ql1uqfqJyFInUGKWAOraVzDZ/Fr56kFhqukX/Gz9+g7sahqn9kO2b0pJrcRj5emTSr
 dSqWjhKn
 pVqXp1W/TaztkALG2Hf2JQb2+WSKhHn4WVVritIaXvmpSCyeaXGxdmVZXaHCoDCqtzwiLLJiYTCFucqBRT4K8nESYoV+jpdcoaNGXttC8aYrSt7pXbiGOwslgWPKcxGW1SmXpwhz59JX5pHWKAjMJDKhEkQj2HgF8OYBQYaKGkBXKOqDw+GRlj4Wj5D3oHCeJozhm+/B16tbHWl9FulOJZZvetCCJ4HgPRC5HqjWus3OwKwR4Zfanwf/YEEoGVHG3yHf1nfVZMqXBDj/lMiWGElBr8nh4/H0aI+uKhFbEWZBszHJ9CPtoSKRFXnKgHxKica0La1J2tC695GE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series fixes several bugs in vmemmap optimization, mainly about incorrect
page accounting when vmemmap optimization is enabled for DAX and memory
hotplug paths. Also fixes the pageblock migratetype initialization for
ZONE_DEVICE compound pages.

v2 -> v3:
- Drop patch 4 and patch 5 from v2 since the page table sync issue has
  already been fixed by Harry's series.
- [Patch 1]: Remove an unintentionally left line.
- [Patch 4 (previously Patch 6)]: Call cond_resched() every
  PAGES_PER_SECTION instead of every compound page, as suggested by
  Mike Rapoport.
- Collect Acked-by and Reviewed-by tags from Mike Rapoport.

Muchun Song (4):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages

 arch/arm64/mm/mmu.c            |  5 +--
 arch/loongarch/mm/init.c       |  5 +--
 arch/powerpc/mm/mem.c          |  5 +--
 arch/riscv/mm/init.c           |  5 +--
 arch/s390/mm/init.c            |  5 +--
 arch/x86/mm/init_64.c          |  5 +--
 include/linux/memory_hotplug.h |  8 +++--
 mm/memory_hotplug.c            | 12 +++----
 mm/memremap.c                  |  4 +--
 mm/mm_init.c                   | 43 +++++++++++++++---------
 mm/sparse-vmemmap.c            | 61 +++++++++++++++++++++++++---------
 11 files changed, 104 insertions(+), 54 deletions(-)

-- 
2.20.1

