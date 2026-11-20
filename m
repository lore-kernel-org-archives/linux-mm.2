Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C87606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Vx1KOFSa
Received: by kanga.kvack.org (Postfix)
	id 117D26B05B0; Fri, 20 Nov 2026 05:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEBB6B05B2; Fri, 20 Nov 2026 05:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005716B05B4; Fri, 20 Nov 2026 05:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB6956B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 663901A0D42
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:16 +0000 (UTC)
X-FDA: 85455074712.30.1701D3C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2E6441C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Vx1KOFSa;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169354;
	b=IEWrFS3ojWo4/bpI82IyhGY3/b3tj1B5fO79Iqzk36mWXqvP1gvk6biQtc7dioRt3g4Jvs
	PAzsyJ2xlWeGQhjtkIaSm2EHX3YNCQLoOnPHSXsqv5C6x/wiK4EQVm25JHh8BYl4CFOMe5
	HtmfgToRoiiMUs6FH7e/HpBKnhCuFSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tP5tP1XsZQUtWMsij03mPLEQkw2o32O/Ohqtn1xKgnQ=;
	b=JdB38O5nwmGa+d7aH6IoJ8Fa7z4qgGuu9VmQW3aA4HrLbtVTdh2Kd9noYwkeKYlT3PzA8U
	9AU9Fvd5AARr1Bih/s+z9d8yTN6hnOw+kUsd7PFQSBhZ9uHkjA/6xVZ0/xzubuc5AMFnYQ
	bL9IB465GYDkoF+WgqBrNm8QwgKBT1c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Vx1KOFSa;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b40470fdd8so366524a91.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169352; x=1795774152; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tP5tP1XsZQUtWMsij03mPLEQkw2o32O/Ohqtn1xKgnQ=;
        b=Vx1KOFSaRJEvcCNuf52fC63l+6GC/JKW75U0xYEPJs62GXP3ui1PlbAe7TlPJOwWfm
         yY/g1HGvdEQd320acgDC2Ise5iJEYt67i4jrae09RftpmkGz52TPZAvFxRUqNybqnVVD
         w4oTwrju9B68NzL0jqoftayy0enDTJQGa5dIoaxWNQyPtXuNuRErYKPjvyub1Wg8Oxa6
         4MF9oxbuQHu3XpwTu2hYNyf5xwCZuHF3URZiXqW2MQDC80w0MHSeh+2gTv3Exmjx/XZz
         DTmXvgRzLjsawvPq1WoOHGEcr2fefMZK84OO38uSFiYOOYL6D6PUq4awVWoFmh7EcJFp
         nZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169352; x=1795774152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tP5tP1XsZQUtWMsij03mPLEQkw2o32O/Ohqtn1xKgnQ=;
        b=QtavH1V0cfuYvcYvw2MDaprfU3QdNFmzYSPXxxk08uspcTOya4QpkpiT6GDyZiswV/
         CL+6bIyooGB+mWXdZHgJy7PPeT1JtBZlM9H/DuRzuHOdBFl7tveBdCetXw/d9BCKDZCW
         qMmPR37G9+61yNvWvoZWHSiE22WFoY9Qc7VZ62SfK0oMvNBBae1g0UEOrErkdwjzmowg
         P8kAvsWR3CaIYnvimIzQY4h0jpN7wUW/CWwbbCdZjm2yWewL64IynMecbsQJ6if1cUD8
         B5mNIP2svo24BKT1Le39pAtTZS6UpIXVfZNWerN6kcaj0B82/Wg8h5KCWLrE7SUbe/Df
         B34Q==
X-Forwarded-Encrypted: i=1; AL+hErGZtJ//ONgBLurhwHrKpR8bPtveu+G1tjLKFME/qYzVveAhRW+eRR2VcdOkpX0Ph+AeV9MAHWRkVw==@kvack.org
X-Gm-Message-State: APuU4Z+2i3HyyYUevP/oMdir14gNQsl9YmljLxqL8nCblTd1m4juytLC
	YF0rHRZZsmGUklFaAUgWQNKfoa4xagsTabfhgISs9epamy3bfUmbs3ZcJEZBNcjvkE1A6on7oV/
	wtSPm
X-Gm-Gg: AZFdTZfvm7shYQjJiFW4uD6F/EbLdc3GZbxZwM5zBa+MYs0pK0auoTXfwfbc/BuvR0q
	nV0MIhs9uOo8cSjVG8V+Gs+uBCkPLWMh6RlyiB0WB0j9Eq535A1D6xW5aTpa+YWFgUdCxCJ13hV
	UfvQHCqt8usmc4S1YecVQJ6aT49reVl/vyn7U4itV89C7bWS+ST6/R68CyFHBMrz9PIFs/EDY9j
	m1BYzoS3F2Wswz92EMSEWNuXI5l8L3N+7v5A2sT487cfsdzWSf9FcUt8jT3iAy2vf/nLsqR1a+0
	P8ZhUhJMtOpE0U50wtMlj/hMCi0AXwS7/EeeXmkkgTFAeXHaQYPbywnUGy8/fJjVXtQW/ucjQO5
	8PhgVmxCyAxa+oNOvOw1pmZZzzqtdQ2Rlw+nxyQLOczWP0f59zAKWBbzGyK14IMBltaFKrsohlx
	9gfpnXeI1dlfz0madFoFk3zQqNzFru3ujJGuih2uwLKOZA1nLvmUyixCZZxUmuxCm8yg0ZnEHo+
	6ki1TXdIuRjdI3i5w5atx8KAse7GfYrBZTCz3N3bDSkl56X9gyPLO9VI1RQ6dS3AHrJdrO0MOoK
	GOnh5LnBk78lHsW6PD87Xe94qFXUL2AtXCa9jXq8mHk0rB+62fKcscJ9wdLnKpFPQ1Lw0Q==
X-Received: by 2002:a17:90b:2f8f:b0:3b3:ba43:54c0 with SMTP id 98e67ed59e1d1-3b41c98a338mr2073390a91.15.1795169351488;
        Fri, 20 Nov 2026 02:09:11 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:10 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 00/11] mm: Unify memmap initialization for compound pages
Date: Fri, 20 Nov 2026 18:08:45 +0800
Message-ID: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E6441C0007
X-Stat-Signature: 4w919pim37zodiexwpjkmu1qou7w6rxq
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795169353-92982
X-HE-Meta: U2FsdGVkX1/Z6XzHz0sHOCibvthRZReQYHyY35cZ20i2k/1DmWx9WV0ji4RT2Z2FCQx53sEkig6/Ku7zaOrDsPgf4ltjEEax/3SduUL2jKUe2tlqJUQuRKgc5JkDv2hqyWOqTvKX6uBLAcICaYScS0W+bb6rqr3v+0wzwXWvu+M96d99rxfV9RM8kiA/icJ/SPksVyNZeIWHp2a5C8XbJMYSIqgQm2GGxUh0/hM3PJN4Ou+RZW2wh6C1DCtyUyY44iOIozQuKim5CNL595bc+o0LXC6swFuN0CJZEdxa+yAUkjS96v+GkkfVU1QqOCFW2VENFLFGK1jXf1pnQilGKNgLezn8GTBnF5oRwDOA8awvdkT7IR0RneOLVMWpC5y6skOdzOpXIiPLQQQEOlBWENyi8lDQJCC2vmmV0nS9C6ry0OhqCcJQrbc8vHRMWgr6Ytl6CZ0q1HQCuI1Fg6EepN1mpMNS+tHEMlFOccfDQQ9D0WhqY3sieExe3TI8NcFCScFgbL3SGu/MwOUjMGl3/DI+UdjEVzGFGSRQu9kjA4qZ/aPWsxk00cmgQJAPXwnDY/yIZ8dXgPWjXU4EEXU1HJJE1PdcpyhDUgNDcIDJN/TuBl1BwPlQj/P0EdUKkzmS6CpooRJqnlwsjnE1p8aYNiJKjPjUoDE6gLhrR6CHesk9xM8+lFBdRwnhmqUc+2YrrqH1IE3VnSXSv7jro0J/AeGYBiYoOn5UXcOPw7UwwlO8f9p7HKsTQ0Yb3OeGOtlwheVfp5T1dOZQ2vnx+Ma5NY/Q9gD9ynwdqpXx2rZI231l7W1pGyR+56cmdTOoL7Z2q3DToaTQ+2ai9uPqjUED/S+xd/44i8g9kWYrw6sMAikHYD6Bn0ycd3iG6FQU+PvDhxK+qsbGmx9Qn6ggLOKG8Kinp9g0pgaRjlcF25edqf1LmbkpUg941ZckxHhaC06druniXx4er/tu+Xw3pK8
 dbUe3pC6
 qeHPPQf4+hcH7N1khmKhqx6ggycXuAo1qGNYdGwb2A5EK1WGgLKfHauPtp0DLEhqf8BjGv1wkKQrQYPNKf10eH29Plo1URIvZ1HBwhFy3qMHIysWvM5hHQTB7ceKWiHPhjzX1yuglGy+evFujyFtxAQbOfI/PSoQEGAkI/Q5aR89E23AoF58TO/vXc1HVdo8CS+ylgAnLmIOXQSzDlCRr8S/4zvBzkX2okhjZRsN+v5zMtiO8cwHnvEuJoIGjkXPyu7E0cyRC1GvJkIUgVsc1RpUWSa8VVNW9IPxTS7OJ58T+X/OEzy04EsuoiO9ZTtNSyUkZTEoVvB/zzKg9d3mVMS3Vk9E8tLnzjh5t1StNbEIJHcznF1b5x8OiK0KtfDQpZ/Aya7GXQAog3zxQFGHzOaIPZrSeZot92+KZFsuFoySswG+ws84oNI5Rq8aPo9rxlbNORsMpL1zgU4g/NhOq1AnPCDyf+zsTCZmJxP3vznOh4E4oqD3IEbufZQQBVh8kE1HNfJKPAk+DNy5VGMuu8BcPZRK9TmeXgLLWQB4sKWsvi3xxAhgOhO6k8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This v3 is based on the mm-new branch at commit 15f114dac9a7.

This series is split out from the earlier, larger series
"mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
generalized vmemmap optimization across HugeTLB and device DAX. One
remaining piece is the separate compound struct page initialization used
by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.

In v3, Li Zhe's template-copy work is integrated directly into the
generic compound-page initialization changes instead of being stacked as
two prerequisite patches. The shared memmap_init_compound_page() helper
now covers both compound ZONE_DEVICE ranges and boot-time gigantic
HugeTLB folios. ZONE_DEVICE retains memcpy_nontemporal(), while normal
memory uses memcpy().

The first four patches make the generic memmap initialization code
suitable for sharing. They add zone-consistency verification, factor the
PFN-independent page state, simplify ZONE_DEVICE template setup, and
introduce the common compound-page initialization helper.

The next four patches remove the boot-time HugeTLB HVO special handling,
initialize all bootmem hugepage struct pages in one place, switch HugeTLB
to the common helper, and make the now-local page initializer static.

The final three patches centralize early CMA pageblock setup and move
MIGRATE_MOVABLE pageblock initialization into the shared memmap helpers.

After this series, boot-time HugeTLB and compound ZONE_DEVICE ranges,
including device DAX, use the same helpers for compound-page and
pageblock initialization.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/
[2] https://lore.kernel.org/20261112112816.55095-1-lizhe.67@bytedance.com/

v3:
- Integrate Li Zhe's template-copy work into the common compound-page
  helper and drop the standalone prerequisite patches (suggested by Mike
  Rapoport)
- Apply the helper naming cleanups and remove duplicate ZONE_DEVICE
  reserved-page initialization (suggested by Mike Rapoport)
- Update the HugeTLB performance results for the integrated
  implementation (measured by Li Zhe)
- Restore managed-page accounting after CMA activation failure
  (reported by Sashiko)
- Correct [2] to refer to Li Zhe's v3 (reported by Lance Yang)
- Collect Reviewed-by from Lance Yang

v2: https://lore.kernel.org/20261113033442.62970-1-songmuchun@bytedance.com/
- Fold in Li Zhe's memmap template helper series, based on its v2 [2].
- Remove __meminit from memmap_init_page_common().
- Add a cleanup to make memmap_init_page_from_template() static.
- Collect Reviewed-by from Mike Rapoport.
- Fix the helper name in the final commit message.

v1: https://lore.kernel.org/20261109095807.41547-1-songmuchun@bytedance.com/

Muchun Song (11):
  mm/mm_init: verify zones for template-initialized pages
  mm/mm_init: factor out common struct page initialization
  mm/mm_init: simplify zone device page initialization
  mm/mm_init: factor out compound page initialization
  mm/hugetlb: drop boot-time HVO handling for gigantic folios
  mm/hugetlb: initialize all struct pages for bootmem hugepages
  mm/hugetlb: use common compound page initialization helper
  mm/mm_init: make __init_single_page() static
  mm/cma: centralize CMA pageblock initialization
  mm/cma: localize init_cma_pageblock() to cma.c
  mm/mm_init: move pageblock migratetype init to memmap helpers

 include/linux/mm.h   |   8 --
 mm/cma.c             |  38 +++++--
 mm/hugetlb.c         | 111 ++----------------
 mm/hugetlb_vmemmap.c |  19 +---
 mm/mm_init.c         | 261 +++++++++++++++++--------------------------
 mm/mm_init.h         |  13 +--
 mm/sparse-vmemmap.c  |   7 +-
 7 files changed, 140 insertions(+), 317 deletions(-)


base-commit: 15f114dac9a7bde1796f0e54e22726fd31cfa8a5
-- 
2.54.0


