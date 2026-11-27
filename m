Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF0A606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hxdjMDDZ
Received: by kanga.kvack.org (Postfix)
	id 3D3B36B05B0; Fri, 27 Nov 2026 01:03:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386C26B05B1; Fri, 27 Nov 2026 01:03:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2729F6B05B2; Fri, 27 Nov 2026 01:03:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9016B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:03:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DBB180218
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:37 +0000 (UTC)
X-FDA: 85479857274.24.4484107
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3BD4940004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hxdjMDDZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795759415;
	b=DvZbWGoi0H73apIqkB+hjuT5mFXGuZTpCfO2rqc9IoSr8TEXnsJ0hPgko9Aqdckx5vCMAx
	q6Nes/MFRLpd6N5L8N4sNIZdtyHeDqaGUDNTP69Dv4btapInZr17ybrRYFoSfECsVTWrKg
	ifERtaeUuo3zzC9+iyzH7URE/kHUCGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795759415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rhj0D1zFI9ZYfUFht5UxzRtsJ7JBg0GVYmpcdFiTnZo=;
	b=j061+80cFm0+H2Z8GWO6Ju9dsTqLuoD63Qizb5mP2WA8i7OBsUb61wOxgErwH2R2vb4GzE
	DFJniiaV0za3/VACDPIuhNbjDtIQ7QFOelS0tXKdHFmlEdKGe60JOOpM2dbtckgDsCdWH6
	AsWzPIu9PHEZaJ26GJji3eA/U6gRGVQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hxdjMDDZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f2hZ5CxawqEEqnkSG2LQnBvDDLs0cjDfbWjcS5X1j6M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795759413; v=1; x=1796364213;
 b=hxdjMDDZcoWuStXwdACsby8378oWcuait82i9tBrdl6bn1FdiXEBkztnm+mWKWUsAD0M8GIb
 1tn00KvONDv/n1I+WX1Cs60w5nVnH4yOHi9SD54qVlKi6XHwGNJQHeDYEEoLa5FkAynsNA7z+7G
 heP5VgeU/cIZqdZZ1xehgE7I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f5b985bd771a9249;
	Fri, 27 Nov 2026 06:03:33 +0000
X-Mizu-Trace-ID: f5b985bd771a9249
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 0/2] mm/mglru: shorten the lru_lock hold time in scan_folios()
Date: Fri, 27 Nov 2026 14:03:13 +0800
Message-Id: <20261127060315.1119672-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p7w8t5a398uqzsa3ibt339fjpu7jypjs
X-Rspamd-Queue-Id: 3BD4940004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795759415-512869
X-HE-Meta: U2FsdGVkX1/1fQ5oKOaLcNEvaODIbhZlnDv50mQMkvt5l5K3vCcpTEEi0iJYssVAS3VryM3jcrlhMXeJj7FlmcPMnI6LIkXLXpAmxubOk+tADTErba/GWadrNjag2gcsfNaFGi/Otua4El3pAVqhgFKmqS5InbIW6xqt74M8o486nAZ3BTefRMKKDT4bcswGv19KqNjOB6ONz4SVasPZsvhf2unfdNYR4ObImzTwL/rZa6lyKdWUKISnMJGcjA8o4WIdsrLkMtzwbUHz/dOyphBZ6ytfNDEgBGQvp7FCYn/kpL/xnsWDKnXkwQWsYjQnxh0x1KIWh/nK59v/AFbCC32LlJy2UWGATTbQhzsLpN79zBiIShp/G618yFdwsjLn8oKtPye0v7Ufn5kcvPagZJjfVUD0iV4DfysJEgABSk5wnCQxB7o5pxclz7ZBXzyTSJGJHudYn8h1m3TU6EpeDonR3D3EiPqKzpfX3jIGC0cAesRb2vPs5N40Z/e3pp3Ua4tLZILkrOftKkMupr0yY6PvEer0yGutC6++sDixZ8p9h/98cI3Q5FTzWLrS0mxB4AdbO2K4Oy/u0eZrmtrvQ4YrR3TxfD+r/bRVwBXnMuXCEVQH7Ia4jDyBv1rXLE2N41sci3KZ/R8g/L4NmnKDPmAKhLowSj5GSxXWK1tiVoFKrAV4qA6w+HEtT57+iRAw++L4fLFMV2Wkg1Ti86tjFcdqUs+PRLRtg+C3NO96guxkpzMS1eL0vU/qBMN9Owz3tnciNBgnoNW7g7j1MJsX5+0Clcn4lvVBu4VVXV7vzQ8v+2jAJ0siZup03ik4P9SbpJOd0/Lxf2R4KwJwt2ynKa9c7a/fGB5UMmBs7Q81X/gk0rLZhfZcatgV/qEHggNYh6aqL/+V36Eyqug+FJ5RYGOEAiAK40z4EpxucWg04lxH1Yp0wyUWkkKGOP68yM6yZ3sMs4yq4Tid5uEjNsn
 g57+boYi
 ileQBMrrxHBASMc9S3GUujdpp/1v3pseUtUL+b5f4thZfedGPbrEhs/YQVdZ8GNZJ2SyZztIB/BET07XF5FL5l1O/Tnr+PJWImulwEnHUYAT6xNq17A6PfkOqGt7kEqAfXcJmzvWVvIhl2VyA6FBtMFRP8/XboHlDT2YTng2bsieXkHpVeSZ6pMyeTxCfCkqdy1TuD+WO2Sxoz1lyZPTcWE1QlCJklEmQy8BxKGp4C9Qs9p/aC4285DSj5WS7tTdEd/9UTrReUh+tLJzu+WfyfzlinLQ+PD3GV+k14KTzet+f0xCSyTUkZ+OmaJs/2qV7MJoTg/3SI/vrdi5KCXFIk2gPZR/TOqBILkP8VsuNm8qWfphhgHj4uGBLmCDNPpjsGhTXENsq08MMUgsS+my/bp/OYyd69ab2KGCcXm79RkpcG3SrbId4W29iZpDXqIbLBrPxc6vbgb2yBHjs0zA/Ty1IFJUV4C7Mfi6kAQkOGtjCB/vYWJzyHpZhoUVQa5e8XaZ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

When many CPUs reclaim from the same lruvec, they spend most of their
time spinning on lru_lock, and the time scan_folios() holds the lock
limits reclaim throughput. With 24 threads refaulting file pages in one
memcg, about 40% of all cycles went to waiting for lru_lock here.

This series takes per-folio work out of that critical section, along
the lines of what isolate_lru_folios() already does for the classical
LRU:

1. Update the node, memcg and zone LRU sizes once per zone instead of
   once per isolated folio.

2. Prefetch the previous folio, so the cache miss on its flags and list
   pointers is not taken while holding the lock.

Tested on an i7-13700HX (8P+8E, 24 threads), turbo off and the
performance governor. 24 files of 128MiB on ext4 on brd, all threads
in one memcg with memory.max=1G, random 4K pread(), so nearly every
read refaults and every thread ends up in direct reclaim. Reads per
second per CPU, mean of 2 runs, with and without each patch in one
kernel and the runs interleaved:

  CPUs      base    patch 1   patch 2   both
     1    426681     -0.4%     -0.2%    +0.3%
     2    387442     +0.7%     +1.2%    +1.4%
     4    360312     +1.0%     +1.5%    +2.1%
     8    314549     +2.5%     +2.5%    +3.3%
    12    235058     +3.2%     +4.3%    +5.6%
    16    184086     +9.4%     +9.2%   +11.2%
    24    124478    +15.5%    +16.5%   +21.6%

The gain grows with the number of CPUs reclaiming from one lruvec;
with a few CPUs there is little contention and no measurable change.

Ridong Chen (2):
  mm/mglru: update LRU sizes once per zone when isolating folios
  mm/mglru: prefetch the previous folio in scan_folios()

 include/linux/mm_inline.h | 26 ++++++++++++++++++++++++--
 mm/vmscan.c               | 18 +++++++++++++++---
 2 files changed, 39 insertions(+), 5 deletions(-)


base-commit: 3d27e49eb905a5119e78fbe3d3890f376d15c728
-- 
2.34.1


