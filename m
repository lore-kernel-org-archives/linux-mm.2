Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF27B606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=FJ53MHc7
Received: by kanga.kvack.org (Postfix)
	id 860596B05B1; Tue, 27 Oct 2026 00:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8114F6B05B3; Tue, 27 Oct 2026 00:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700376B05B4; Tue, 27 Oct 2026 00:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46A6C6B05B1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C62B5A059F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:14 +0000 (UTC)
X-FDA: 85367108988.15.5C0C9CB
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29C11180007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FJ53MHc7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fubOaxOgmofN/3iFYwSrZzfn2/O9nYxlfixW+9HNaRE=;
	b=sOcRuq6ASCTsvRKYpuF0FFOtb+V7xv9VOSkuc8+ps5wUzdMpdFB+YJ3wBy6wMMHHDgKpcO
	jBr7UFThWGeA2vcAHry5LEznV/+OixWLjTWW0OqbKO4CM7W9++eWBcHPu+IL0Ocxmtr6yW
	UZ6Ydkt1ZKzLhLW7FSRl3GSqnRRGFkM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FJ53MHc7;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074933;
	b=gXpI7OuwLROOpYruQbMYctDK9R9yiPChpuaPUwChYrregvly4wAsisExvkef98i7Q4THj7
	9wGurfJkk2VQ9DlL3g1FVvOqcM9bUJ2+aCS8szxCLJcyYpx9asvWWio3E7hu3rEfhx17uE
	Y2MOqxJzVCveDXtFfXXoFJs/cF6n0kg=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91befbcad6dso63770616d6.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074932; x=1793679732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fubOaxOgmofN/3iFYwSrZzfn2/O9nYxlfixW+9HNaRE=;
        b=FJ53MHc71B8Wick3JGLMRkiA10LINxXn6IzgBspbfpEXEwL2qwnRthcXqHjLjzGATO
         /EdJo2Tl81xgd2vS/aAJEkTyC6VTKVjdYPvZs/rfQeYbv4DAKsY50H38cgmNc7xTgn84
         MgEYQo1UpkGQVxKuGDr8Zri8ResHIqJGgGjSGBjBtrQ0EENYPB6IrppP1YZ73EpkSeXC
         NhZtJEVLNcqq7VrtM6dhnTtMnER/3TNp4P9BTQdMQqWkZSpesJumkndgbYEaTeclcgBr
         RE6PTmEapoO2P1bUFRMiwgKYbNXe/UbcDyLczn7cUX/DZpKLN+mVaTODDXM8ie5sDGNa
         0sWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074932; x=1793679732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fubOaxOgmofN/3iFYwSrZzfn2/O9nYxlfixW+9HNaRE=;
        b=TVLG0GaSJ8RApKiZFpoqEmluLNz5KVSuvwjgdBWd7d/4jnomIlmEBBCpVdZAJsGkzS
         6Gwu0ZCD97fq+vlNm/20mSSMurExyE9A+7JZrlDG6RNrkN97Sj97waqujUtLWnbjFM69
         M/CaFzu2UfofhHg/XY7ESJVfZwiZAAgUN/EPGzNbqGSvdcLjw4C8MrfgzVOFkeWJSAfS
         8T43iN7iE/OPUrtrR4dzeqQkbSwMZyZ8Bi/GW8K7eHYqudfUf4fqeoseqnVSQfF5wLyt
         WrrnjBdgGdijpbakUzhdIhsFo7vZhSxRXHqCqQs50szQWtQMRHQnQ+8yVoM/c6SaG8R8
         bw2w==
X-Gm-Message-State: AFq9FYK+tbV996HVmWWtxVdRH8L82yfQIk7ICryN/alY4HUHLMcaMGuJ
	GdufuO2PKa19qKyCr8GJ1pPgTROW4vLxYuEoinOI4MhMSzmZ3qualYyqqVEvOvgBl/6x2DvKZxn
	O3qgQbtU=
X-Gm-Gg: AYBFou06kSSO9tjwhcHqP+cM51/jA7ItSjxIyIQI96BrONNF01qPv/HDjGAtSmr117r
	A/Z4SjquAg6yWW6jbVBCoRNknfiBQIhB5RpQ5irTbl3/2a3cyf3XZPCWzswGbWiQ+6UI9d/SJlb
	okpNcrqBcjGNF74vfIUjhk6Med5rj1vB9hyI7NBIN//hz/N1O/j8jHf8DYcOwbZLpUHXeZMMydz
	LaOVL17nHn578IuCWE12ur6QnfKW0VtbbTo+nNxwKl5FlQokJuSResZW1rEMPxCAGCkssb4VZiQ
	wrHhxNa+1wVmOTwvzfwJfgxPvHhrQFMIUwiN32iYdosN+zuhOJpxhIKBLjsUz1x97b7sTf2HIN9
	VgbkLaS9eyEvVj711krgLnl3HEsH/LjoU03qm6xpHp3sePGTPpQoEpvEAO6C2zWJcs84GWWnxhC
	BHA4Ew05I4grcAHL7PnxpyjWDzf/qqrRGkJRnpTHtF2bFGjyAKW0LZRyphnk+lFWTYKREN8IYrQ
	BIYYWuEU0Qx4eFDatY2YEU8iEORsehcEXXPVuGPL6qjVOqFhqT4P0fcA5t3buVFsL93tDvF7Azz
	rE3AJhKmBHIEH1z7nIMfAwd+PoNeFu1HEVncpgaXfA==
X-Received: by 2002:a05:6214:29ed:b0:91c:65d0:1d78 with SMTP id 6a1803df08f44-91c65d0312dmr64203956d6.50.1793074932283;
        Mon, 26 Oct 2026 21:22:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:11 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com
Subject: [PATCH 0/6] mm: fix pfn walker races with memory offline
Date: Tue, 27 Oct 2026 00:21:58 -0400
Message-ID: <20261027042204.3741307-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29C11180007
X-Stat-Signature: snccdhdxyztg5d96fp5fauhp5j9tue6p
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793074933-119907
X-HE-Meta: U2FsdGVkX1/F3/T+/1igCWwKRHqCdP1cRVoI5zQtCdXUqK5pvT7tjE05VogNiBifkIdoHN55R4ko78YkyWhCb3PT7iTAsRhBzNg5Rev1uX/PEPiWX7mU0NXeS+eq5hxEEqCoMVp62etxXc+A2NRiq2triKdC09mpbIlKRXMUerBSO9tuy4oWRI2FUJelkW27Uy56/dH9jzdLTn9lD9h54xE14PEnlTs+5zoclWYHO7f0k/iMsJx4Ba2ZXtrXZZ+AGpV3wCBd73uIRjBNdvrXI4fGGDAaC38758M/9PYpP+nYLpXJA5UHqCnHW7aphCLjjqMwPa2qVwXnN7K0eLFgOPtbMybTV0UUimWNWPLDAN08UPsn+tXZdfIPm1nliIAb+rxlD7ESsueo3eUyM8APb7KdIMYNEfoC+foo/UonJPMkrbT66p/zNOd1xbprfr26RooehdojcK/mCEhdDmi7hurx0JmXStWEp3qffsCl8gJJklCmcV3OwxGCJNlxjr2neMIJmsxUd2FPLx3bQ6pHhn2CuxsWlkI1nAW/xYLiISuktNiqPKsV1bF/7DqCKHRKrcro+Tr8arG/YJXdXGiLg3BTuRFl85IKNiG3E5uyKvOrD/9rx4m2sdamTzVwa0BLiF3IxE32kIIDPRkclhjdjRXDPkdOPhMilp2tqCq7JwmCQMSzHacwC9J26sNHUSQkOiyIOrR3raqX/EPs4ah/Gia2zIQbkMLcSAfMLV6nCSyhuP27OTQTLldUK/00Yr4bMwK8DUlZwE9L3snHV8mJ3WNiFh89kPLqxz88s0VjP7X4H7Ijy7LlxNAagw7qBgi1WaOQlW+m50q66xOGDLx9IKzhpEDzD+rfvuKzFjqGqhJgO6lkkEGCexKbry61q/f7gySmWCvQetIQvHFWvZDaf46lYJOP7W/BAHP+Cs9nsZ+oStQOOFGybOnRWM+pQ1yUp0l00bf8XiYJFw5iMuQ
 wnuY1OfN
 Wp2SjGXeYxZ+QQZhQSA/GbT8cp55L6IbR5w7bvpJ58rZ7bo87F8x/ZkeqCBMEeOx4M1UYwmb0R+FxDrHzRjvbNARa0OeKc3yROzqjyDnSYR3bbmnxYe0k2T31jAGk08SiSq++tz5vGSOy+nL/xe+y65WH+vakdzSZjP4RpjTTTLpVo/qMxin3Xw2YqYro7H2AWlkHwWKMn/jMjzIhDtdPF03n/uTRRVxB4C/KOG1GfWmtbNz9dijQtf/dTwtkx/m0XeNBPqku8SSFQ5R9oJdNwOAuCJ3DXJoc7+8wztfubZgVOxEiOf2gALCFOoOfWcl0H3XV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several pfn walkers check that a struct page is online, then use it
after memory offline has poisoned it (CONFIG_DEBUG_VM) or removal has
freed the vmemmap.  Five of the races crash the kernel; the sixth leaves
an offline spinning with the device hotplug lock held.

Patch 1 adds pfn_walk, an SRCU-fast read section that offline waits for
before poisoning the memmap.  Patches 2 and 5 use it; patches 3 and 6
hold get_online_mems() instead.

  1. compaction scanners
  2. page_owner reads
  3. memory_failure(), soft_offline_page(), unpoison_memory()
  4. alloc_contig_range() undoing another caller's isolation
  5. alloc_contig_pages() isolating a range that went offline
  6. the hwpoison-inject filter

All six are for stable.
  Patches 2 and 5 need patch 1
  patch 5 builds on patch 4
  patch 6 builds on patch 3

Testing
=======

Each race was reproduced on unmodified source in a QEMU guest with three
NUMA nodes and a pc-dimm left offline at boot (DEBUG_VM, KASAN,
lockdep).  A test module holds one task inside the window while the
offline or eject runs, then releases it.

         base                           this series
  patch  outcome                 runs   outcome                 runs
  -----  ----------------------  -----  ----------------------  -----
  1      GPF                     3/3    offline waits, clean    3/3
  2      GPF or #PF              6/6    offline waits, clean    6/6
  3      GPF, or unpoison of a   9/9    blocks, -EIO/-ENXIO     9/9
         poisoned page
  4      offline still looping   4/4    offline completes       3/3
         after 30s
  5      GPF                     3/3    offline waits, clean    6/6
  6      #PF                     3/3    eject waits, -ENXIO     3/3

Without forcing the window, offline/online cycling under compaction
faulted in 8 of 24 runs on base and 0 of 12 with patch 1.

Cost
====
I was unable to measure a discernable cost beyond noise, stddev of
walkers and scanners runtimes on real hardware was wildly inconsistent.
Leads me to believe this change is largely imperceivable.

Gregory Price (Meta) (6):
  mm/compaction: wait for pfn walkers before poisoning offlined memmap
  mm/page_owner: hold off memory offline while a page is read
  mm/memory-failure: keep the page online while handling it
  mm/page_alloc: don't undo another isolation in alloc_contig_range
  mm/page_alloc: keep the range online while alloc_contig isolates it
  mm/hwpoison-inject: keep the page online while filtering it

 mm/compaction.c      |  8 +++++++
 mm/hwpoison-inject.c | 55 +++++++++++++++++++++++++++++---------------
 mm/internal.h        | 41 +++++++++++++++++++++++++++++++++
 mm/memory-failure.c  | 31 +++++++++++++++++--------
 mm/memory_hotplug.c  | 16 +++++++++++--
 mm/mm_init.c         |  4 ++--
 mm/page_alloc.c      | 35 +++++++++++++++++++++++++---
 mm/page_alloc.h      |  7 +++++-
 mm/page_owner.c      | 45 +++++++++++++++++++-----------------
 9 files changed, 186 insertions(+), 56 deletions(-)

-- 
2.53.0-Meta


