Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1325C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A366B00A3; Tue,  7 Jul 2026 16:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61C16B00A7; Tue,  7 Jul 2026 16:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77206B00AA; Tue,  7 Jul 2026 16:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD2566B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:18:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C84DA0584
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:42 +0000 (UTC)
X-FDA: 84963093684.03.3177806
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F75B18000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:18:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iW1CSJsu;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ptZsy+Ouyw1+sLnXic7jdaEgqiA6NfImBhqfXckaQ+Y=;
	b=Cqk6QWUfPlD8bYLhKckdO10iFjPWizLwcnTDwxLK/klX20HRpq4e/M44/0aHZpDexhyGHi
	j39cxLsGqtrdCB2gh/N2ADms3ZFlJVfnUUb2Vk3vZ8ucNVrVC8SIthq9aB3pk3IZv65cNw
	3xbqhJBp6wwDdnkTD5j6xUdded9Yo3g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iW1CSJsu;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783455520;
	b=ozOMwj0AWurqs8yDJCC6De+5ohKOOJvPCzK+xDfqQQ4mmHrRaV6n1hN/2FxH72QVMVS0O9
	atlA1Cbtt2yi4KAsw8fCQnzburdNsL0HxZo47Xk37znQUJmy3CSAZ5myeU10480R7r2MVH
	7tOBCUltJdOLip+ZJCA+CbZdo122wDY=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a1905287a4so2607962eaf.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 13:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783455519; x=1784060319; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ptZsy+Ouyw1+sLnXic7jdaEgqiA6NfImBhqfXckaQ+Y=;
        b=iW1CSJsuLbfAErL/Tq1JgWxH9oWmLe0butWt3QwhRhpX8xvEckmOgw2hB32Y3xViLc
         94lR5NP2CxiwyhoYZK0+IOYRz7fJLPSo+2R5+T4xTTdThipPy1Q7/+ajkGCm2otA4die
         vsjqeieenJOwkOjMvlyg+Q4xosDE/EfzGbp5dYl2B6HB2W5xzgCI8FhmaIU/Hu8Wkgxx
         BdHTA5yBSIcqTsei9opn6x16lCILvBC5xtLzjehScCgzAsimDaJVkbGoqBSdhB0xfVNW
         K7zd30YhcFmc6WRhPe9u1ZB1iD14apC131BZE1tyo05tLxULWeTLkMIktqAbCyYTmgJW
         BFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783455519; x=1784060319;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ptZsy+Ouyw1+sLnXic7jdaEgqiA6NfImBhqfXckaQ+Y=;
        b=qqFEGhzuOqf26xTYHB+zUqqecyfUY9Nx0o++1BIeP13Oqj8mE28OcjHlZdRwZt4QjU
         9u2HYnnQysXFJSt0Y6fb4xr0sezcu6cQnfDZTEVFyLcrO68NW+0m4eXDgI7mDJxr3d8P
         S/I4jLZPr1TNTTGN8dCFMFpItLFRYhvOAvdgyViQj/VOqmhW2ZKxuwVx6BWC1/id2sq0
         F4+vwdDBlQhd6A9y+Vo+ufxjLcwUQx+420Q8QrqdnFhfffBC1IXkmQnNCBQu9H9OMAAB
         rK/gGTm76Ok4uiXq+WUSy3BNQf9U3CGM/KB3QvtNzoZlZ1NyrEQNjg6t5jCf7NpK8Jv4
         PBCQ==
X-Forwarded-Encrypted: i=1; AFNElJ8ednsxZMdbFXLAhI9+09UGVYM4VvoBq6M+zVNviaGLa1n/c1hjeFRWyz7Lt+4EmCADwyOjabz9mg==@kvack.org
X-Gm-Message-State: AOJu0YwfMM15qCfmdrFvZnUSdyM16O8tEscNbVHTxTuU/o3j3Ab6xvzB
	0WKcYiBqnN20IrUD7VKCh5kkQNkyqGmxNVdIJ2GfEgzjjXP/VnZTnhrN
X-Gm-Gg: AfdE7clJblTaqvUK4Ov+3bQXKXyomnRMTXtcg8CBBfowyCMlIBfXZ26HUCYxLeulblu
	zJQA1UQhqkJayX2V1U4woOyKPfVpfNbveJ5L8yD6cSrK6Yrl4xWVjteT6yj5QdOseejBz5w3LbI
	5sitaOGJ5dNUEEgxP7lV7DBAg1JB5/3Rzx4jvVA2hjcWoML7t/h78HqvKe8jywj8t+/XoxIktNT
	6qyIzNTQ2r9ksfOroSpcY3vr13Jjr7hSoqzORwuQh+PQd1k5kElbUQedmnplZSLb0YzI6cVCt/5
	sXDyLp/EMNIHy2eUIJiZVHkuHXM6iDrHzCkgJkeB7086tpBmFefKTD0c1XhTq78x9tn0v2bfbWr
	nrBft41Huc4lepAihBAbvx345efYvKusKBv1SSOdIgcyB+GAYMYNjhL95C+uvjO1DLIPCRzxN+k
	Grr7Pirbc0L0ncfxgetGGTvq8mfzPBZitY4Djf/UN/AINi32eJTd7E+W2riShCfts=
X-Received: by 2002:a05:6820:1f13:b0:6a1:97ab:9e0d with SMTP id 006d021491bc7-6a3556e6eafmr4248321eaf.68.1783455519275;
        Tue, 07 Jul 2026 13:18:39 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a36a3b0d60sm370193eaf.0.2026.07.07.13.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 13:18:38 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 0/2] mm: split underused anonymous mTHP folios
Date: Tue,  7 Jul 2026 13:17:33 -0700
Message-ID: <20260707201735.4113107-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F75B18000A
X-Stat-Signature: y7uqhfmwysanwmd63kksjoq8kzk3k4s8
X-HE-Tag: 1783455520-893833
X-HE-Meta: U2FsdGVkX1+5ZsnzozwwEIARQOjWioSxpWqhVMaUg+rbJnlv66iGgrrMmnWnBgEAXglCLOFLbUnD2x6EFLkVsZkkZA0rvLKvnAMBh3mJ+YEM4TCqY8UxSXEPgSuHrXhVCOlFFI9JkrrYB5lkYcBOUotHMfaqUY6SThzBTYjErL9yMx+nqVRyCrnZG97DatJjZuV0RqSDcCcI0kAnH3Ih6hjzV9YaTWez2bkjGEIj4jQcEEr2WyUf1/SL6ZvTEp5ziJA0WdUedUKyUYO8sy1L4XjArOPuGsTmnhmUC605ndM8zef2Fljhe7EOnrLyqYKAoxLhCo1z0nBb63Y/ZBZZKVGJ58SUMNYuNIgs7ztz71rtszKRHNZqsvf9HXJl3JjnYP1DDAZov8xgOM0nlaTQ3l1c3YOfUSomvn8o0J2/9r1IbD21M+LMfXCiVGJCe619bCWbc7KbuLsFz202e4c1WTBKK/21fuzPuJbFn1ZYEXLZ0jjUScA6aa+O3E5lHma+YX+3LS5w5Mqj+AzV769nv+Li78Mof4RczqJVay9uK8F9jWZwYHqHkDR3aHNPVEVOFBh+owg1t+cY1AeQRW/uruLnoQ8tbJAH7nv5r0AuZkezsOXeEiXEGE+UhO9OgXiG39AhTLmJLd7kNea9s0NpRihsGWhFAEYCME156novRwgQ/bGix39OlLoTfGsv7cYGoc3whqVxqLs7PyAs2qyjxQ1Z7t1+V8DmRbl39YZhiUuldjC1oCV3x4YntgvDP6FsolDrYsVh4JskX+9fAcDjSg1qOIrSjLuXmHqeVv2vs4uqQqeeRfQ0FPIdtdlp8v0IilAV5mR+t2d5QGiD8GsqQmZoH0SWEZSpUL6g0tnuwlV9ZICYzY9a2cLh9XTzP/qXYOqDnbV2kvfRD32w5JyEPvI3fQLzYCAz9fQqacfxVxZRYcndVgv0/E+nURkJnW9Crt5iujPzXhhmn+C1ZSL
 iPFSm7By
 SSaM+rot/qQh5XIZNuq1V83d3lZ18UrALHJn1jbNe7MKjISUjTTh79PrWlgNUEudcPD268E5qO/vAL0tvryjr6zshLhtS/7e1wOcwF8MYLtbiIEPNBB3s/oRc1tw0KV+yWISe1yI+kuC1/fSp2bhy/hGywv0sEREAZp9WdjEwMk7KpFhoZBBZp52ZR1w2ivLkrlRpSIuBPx32qT0bhf6AM3M6SKitkWm8mV+E+GHZlLlOf0D/1gbqIHfaWUxRUmgfa+aLmoEZjjOEusw+u4Nn7Dics0y7VCFhCqrlaWATWzN6+gENCGAEhPq5RD8r6mF0wwd5ai9LGijUNY1f2gOyCpaXYp3VG+h4vVBbm1vfTVFFtxheEh6OphYjmKo3erBovutQWCtccnorahSdnwoYS+qs8et1cBoolGrWQbCC/Y1ZjIPnOiaohAqdHREC1B1Q8SlkSfVPc6noJNWukjnLgyF+AuANqPOk08dfuN4z5kpr0aQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PMD-sized THPs that are mostly zero-filled are reclaimed under memory pressure
by the deferred split shrinker, but this is not done for mTHP folios. At Meta,
we would like to deploy 2M THP=always on ARM (with 64k base pages), as 2M
provides contpte benefits and 512M is too big. However, 2M THP=always will
result in a memory regression unless the extra unused portions of THPs can be
broken down and reclaimed.

This series has two patches:
Patch 1 - makes thp_underused() work for non-PMD-sized folios by scaling
khugepaged_max_ptes_none proportionally to the folio size and using that
as the threshold for how many zero-filled pages a folio can contain before
it's considered underused. This is compatible with the mTHP collapse threshold
at both of the values mTHP collapse supports (0 and
KHUGEPAGED_MAX_PTES_LIMIT). If/when collapse supports intermediate values in
the future, the thresholds can be unified. There is no functional change for
PMD-sized folios.

Patch 2 - adds anonymous mTHP folios to the deferred split list from the
anonymous fault / collapse path so the shrinker can find and split them. This
is the same mechanism PMD THPs use, extended to mTHP. It places more folios
on the shrinker's list, but a folio that the shrinker determines is not
underused gets removed from the list and doesn't get rescanned in the future
unless the folio later becomes partially mapped. The logic to determine
whether a folio is underused or not (thp_underused()) is bounded work that
does a memcmp on at most nr_pages subpages, and runs only if shrink_underused
is on.

Testing:
This was sanity-checked by running a VM with 64K mTHP enabled (PMD THP
disabled, shrink_underused = 1, khugepaged/max_ptes_none=0) and having a
process fault in 256MB of mapped mostly zero-filled 64K mTHP inside a cgroup
with swap disabled, and then triggering reclaim (via memory.reclaim).
  - /sys/kernel/mm/transparent_hugepage/hugepages-64kB/stats/anon_fault_alloc
    showed that the mTHP were allocated during fault handling
  - /sys/kernel/mm/transparent_hugepage/hugepages-64kB/stats/split and
    /proc/vmstat's thp_underused_split_page each increased by 4096
  - the process's resident set size stat (/proc/<pid>/status) showed a drop
    from 257 MB to 17 MB

The scanning in patch 2 was checked on the same setup with 256 MB of fully
populated 64k mTHP folios. All 4096 folios were processed by the deferred
split shrinker only once and did not reappear on the list in future scans.

Joanne Koong (2):
  mm/huge_memory: extend thp_underused() to mTHP folios
  mm/memory: add anonymous mTHP folios to deferred split list

 mm/huge_memory.c | 12 ++++++++----
 mm/memory.c      |  2 ++
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.52.0


