Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4353C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA206B0088; Fri, 10 Jul 2026 06:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BA16B009E; Fri, 10 Jul 2026 06:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8366B009F; Fri, 10 Jul 2026 06:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5B1F6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:50:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 345CF40414
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:50:30 +0000 (UTC)
X-FDA: 84972548220.09.20B7147
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5BBBA140008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:50:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvNpz50O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WJEZw+9x/jEd5nomnZiXByrKMCRFDaAVRo5p+ehSw4E=;
	b=RlqBRUESss5L11D7+43XTYq5658F24sU4TbjMjJjVMtz+IR/9kRpLVKGTZ0ZyBKxqul5EY
	/uLD0RTMCTagal5tl0eaqi67az0nzNR68ZdKgWqDLnagjW08wOn+W9CiLG/tF2flHBmxkS
	mF37ms78Y9CTAsQoPrcEaMlIyTRGr7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvNpz50O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680628;
	b=2WewbkEJyXvSaJTnKlCV9bnTT/YeRIGz8m5uzNPtvcy2AGmT4+KuHLoH2P/dlKqMUYHoq4
	9FkC4pGHUC6JnjU4WkNnFjg8PRnp81hU3wNHHVLU3tvug0FVuTd0txuDkLg8l34WDhdKI+
	9qJ6RfDBiyBDP6XwTAjMwGKiTnKqFFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 413B5437D3;
	Fri, 10 Jul 2026 10:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FA71F00A3A;
	Fri, 10 Jul 2026 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783680627;
	bh=WJEZw+9x/jEd5nomnZiXByrKMCRFDaAVRo5p+ehSw4E=;
	h=From:Subject:Date:To:Cc;
	b=jvNpz50O/5E2VXWt/YbRjL36y/6Uv4nqe2F2So4M00tY+kTpB6dZNZkDq88So/9h7
	 FPEmtTLnn8oYAQpoLO0Oee5Eb3WAFx2uBZueusrF/5we/ZFruxxDunLOcuwj/IHNZ2
	 KAGj5goKudawqSj8Fli2LxVn5j8lF6FdckW70IiVErJjcE4WlprTAiTdKTSpgGmtIK
	 pH3kqAvywiNCrHLO2BtowqPcnIu6wYvsIoXDZ1RwCZr8IBHKzELYjxqKedIzGqgOdn
	 ZQGLPXonzu9vG7riMj81A3NqmUOkNauNDsaMyDQT8/2EQAsW4FfEgTm/RDmc4NS02J
	 Hv6p0I5VEI75A==
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Date: Fri, 10 Jul 2026 11:49:17 +0100
Message-Id: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC3OUGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDc0MDXYh63bLcxALdosTkVN20zApdo0ST5MRkSwsLS2MLJaDWgqJUoDD
 Y2OhYCL+4NCkrNbkEZJZSbS0A/Km8rngAAAA=
X-Change-ID: 20260710-series-vmap-race-fix-2a4cac988938
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Dev Jain <dev.jain@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 Lorenzo Stoakes <ljs@kernel.org>, stable@vger.kernel.org, 
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3435; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sMz40sYlXTtliml43cNKfdXOdD7XpzaddnUQc2wMyQY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICzqWfedV9ys7mTqWo11PRvSdz91c+qs7fd+Lw5Gy2R
 1+V/ZyUOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRJTMZGSYnzTsRodv6btXm
 qltSArffHelo5mkK9vC0jvync44ripeRYX73dpt3y0znvXRKL4271rq+bqqB1pTemgh/wYL6/Ct
 FvAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BBBA140008
X-Stat-Signature: i8wtmecbzrjp6jbpii6cbbqmwbrfcgas
X-HE-Tag: 1783680628-301398
X-HE-Meta: U2FsdGVkX18l/UNAlZJQlsDGj7XFx/8FWk/sz6PS4cyXdB8LkrhL5SPWY6+hsLRjX9wdk5RRIH7wO2IOmz/97gjdexzKyCrjp4EkzHkUHpdZLyCLWTL3kpelclrQLnxbvwyxCbV07V5GfePsSE7mnrVEXHSWvaR1FLxmaHv/QOe4uNJzHyG/Txft4VJ8CK2eHhKY0QWf4gfT1C2u6hQcfEtk5xc4pAT1v9UNs4+K3+cVoNMk8/ys4rX2dbhoRgrjqWR1/3G0uC3cKylEorJnLRmrk/4TNvYVwV0Sr58eL9mdS6jn4HmrYiPM8HdIKthlGOobt9qoMgP4bbMY3FAOx2o3PSjkoqDxPbFU82/6TOrly0hzjBrpc23Zgtk+HKY2SoPmagcdhSkt/bIcSyoUwJDg9Ci+oVOnX4mVD+a7bImQA3uTzmFgXbNokiBWBwHeCjnD8vritXBMFKMo1QzqSvt2gkdkvp7d5kRM0eHjhaMN5v8M6jTj3jm8nTMwiCeFEYxl9koYFmEf/J2ubWZEFWjuXQNJcnjGYcavwKt4r24pa5cEzv9GLg5zrmXPW/tdRweAzHzuYdox2IbF1l8j57ea7kcKXmJFTyPJahf/zjQlklw8GK/UMnhBXOI6w6RqJ7b0THxDpwfhNLmZRzHa1OXEyjNHJJovH2In6z2yhNdZp3ccrwdmu7KpQgn/s2oPdcioL4vJFi9Kok1Ih72SrGecr5UhB8ra2C/Vgm0kDObypESlQ6BBt+ioekDz1t8Kl2J8ybx2eIhmKMVS/om8eO8398RFY3R0PG+w2Vj/8vfVxfpcleUT0mOdU/48vvSpEzoelLtq7pt//i6vuOo86oh+ja5vypjkZhjav0fKyuQWDb/BHight3g/ZwZKFQgWXhBulhASvEfvXNrniEmdooXCAlEUhKCM0v6wCuA5ld9kFqf5ikD3DNFNgT4pJzJAyb/cbTUy9skV3kuHpFh
 2hqFLYUI
 Q3GtVTZopTBz9ozhLv8r1z7/XZPcIPzw1BYYBx79xhXrz7pZ662TtZTpIVtImlc0v3tyYMz2GERuRg/FOwdw+vULFFD6m67Vum54biXQYUBcm4/w3aOf70+XMpv8uwaR2BMQzK5r3jxhTuz/hCxV8yucNxgW+d1HCKlZzPqE/RtzvNgTuehIfnFUW8fz2AwpcPvZqNOmdWQIsUmwQkKItl1Ag62tJDHtKuncaMtEYGNpRWJOtjnWR2ZohxAHo47CV5bfmedp0e61Q+iLr6HybV8gZfSGzvxGjIPZxjHpPSkCO/Pg0SJqJlE1J96xIqGp4CFvjn1PleLDLC/k4Uk6odgS+rCC0s7cFBapLudDxOb+k+rm84dzCQAww1sXbAV4VifOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel page table walkers fall into two broad categories - those ranges
where no exclusion is required via walk_kernel_page_table_range_lockless()
and those where exclusion is required via walk_kernel_page_table_range()
or walk_page_range_debug().

The former category is used only by arm64 arch code operating on ranges it
both wholly owns and does not concurrently write.

The latter category consists of kernel page table walkers operating on
ranges that are wholly owned (but which need exclusion against concurrent
writers).

The lock used for exclusion is the mmap lock, and for kernel ranges this
the mmap lock on init_mm.

ptdump is a special case being both the only user of
walk_page_range_debug(), and the only case in which it walks ranges it does
not own.

This presents a problem, as page tables may be freed under ptdump. And
indeed there is a use-after-free bug in the kernel as a result, which this
series addresses.

vmap promotes page tables to huge leaf entries where possible, freeing the
lower leaf page table when it does. It does this with no meaningful locks
held against concurrent ptdump walks.

As a result, use-after-free can currently occur. This series addresses the
issue by having the vmap huge promotion logic acquire the mmap read lock
while both setting the huge page table entry and freeing the prior leaf
page table.

The ptdump code already acquires the mmap write lock, so by doing so we
ensure that the ptdump walker only ever observes either the huge page table
entry or the existing page table entry, and nothing is freed underneath it.

A mitigation for this issue was already applied for arm64 in commit
a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), which this series
has to deal with carefully.

This mitigation resolves the issue by acquiring the mmap read lock on
init_mm on vmap page table free if a ptdump is in progress.

However the fix in this series would cause a deadlock if we were to simply
apply it for arm64 without also reverting the change.

This is because vmap may acquire the read lock before ptdump attempts to
acquire the write lock, which then gets queued, and rwsem starvation rules
mean that the (unacknowledged) nested mmap read lock in the arm64 code
would also block, meaning the original read lock is never released and thus
deadlock.

This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
lock in vmap logic, then partially reverting commit
a93b45fd397 ("arm64: Enable vmalloc-huge with ptdump"), keeping the
enablement of huge vmap support, and removing the ifdeffery with the
partial revert patch.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
Lorenzo Stoakes (2):
      mm/vmalloc: acquire init_mm read lock on huge vmap promotion
      Revert "arm64: Enable vmalloc-huge with ptdump"

 arch/arm64/include/asm/ptdump.h |  2 --
 arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
 arch/arm64/mm/ptdump.c          | 11 ++---------
 include/linux/mmap_lock.h       |  1 +
 mm/pagewalk.c                   | 22 +++++++++++----------
 mm/vmalloc.c                    | 41 ++++++++++++++++++++++++++++++---------
 6 files changed, 51 insertions(+), 69 deletions(-)
---
base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
change-id: 20260710-series-vmap-race-fix-2a4cac988938

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


