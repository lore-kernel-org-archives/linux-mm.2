Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080C1CD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713166B0093; Wed,  3 Jun 2026 22:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAA86B0095; Wed,  3 Jun 2026 22:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600726B0096; Wed,  3 Jun 2026 22:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAC46B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:39:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3B31C2116
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:39:03 +0000 (UTC)
X-FDA: 84840672966.21.F8B7851
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id 108C34000E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:39:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnxUX8lg;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780540742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fY6gm/PYAmXfMCLc0nBMu9O2mOg48yeIOplSmvWr19Y=;
	b=km+SnsOWPdrP0WazGK/NIPSHiYBd3zp+r8L1CrHvSa8boW26jqQHXBpWUMfRiE6PQ1cYdm
	XflhpKwcHCTO0Vm1IX3ISVpxC1oQkd1nQCw5ooFXRRKqgBDz3kfleq26eS0V+rQ6v8uBPn
	UxwSIOQLW+M7q7SQwAabLsGwi4XgxaU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnxUX8lg;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780540742;
	b=U++oCfge3TWeF1+ylzUt2qcYRpifkXCSN9kB/Bj56WWWl0bY6mItoNC6OFKk+Pa7tqKohO
	hOybG2GjFByZbOD5bpzh97sUur+I7rEqwGBOc3tp5YrNdhc+Nidcp99wSgCJklGZXQwQS8
	er3jq6UvezI6oTtdTaY3O2DtfuqyAeo=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso133922a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780540741; x=1781145541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fY6gm/PYAmXfMCLc0nBMu9O2mOg48yeIOplSmvWr19Y=;
        b=gnxUX8lg8MGqsebKOzF89bHE3vXDac5adWJZv86Hlq/7wt4631O6/K1/OpVgx30Dv1
         gtfoXY77Q3unKoiRfzZSz3hdaG42uUmQqjOcSLqxwAO+Wi9NYbDAjs0OPBc4ePrhUJU7
         qhHHBtr2aGyU2jOUNqSxMnYVY0voSICZZ6VtvCMKlXPqGFA57VIG0L0oex0326X9iLbd
         8Apk2XqJI7qJeQ4zXUm8WB2d92UkAUTUcIy34spuQi4QdKeuqCHY3iZy4Oi9OnzRyQ3p
         48PN9ddNlH4gsb3hRzpAO7NtrnUWBkRPJ3G32Ro3eyQOCnfQsqCAMNlGntBuuSDtVy1o
         qD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780540741; x=1781145541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fY6gm/PYAmXfMCLc0nBMu9O2mOg48yeIOplSmvWr19Y=;
        b=Hp9bk6E38kXyp7j1Jow9m4fNNMAKhDEE8FUqocY2AlAyoptHCDWBDUx1lKVHK5qFYb
         cBocVn7xaidnr5+tmzTHunPOaDEi3nZQTzWKjLSqoLufSfLzTq9iKucn1nO1+/W1FdWc
         lhNc/TtK2rvjLRyqBUtzCbDiQiTmjD42EuBHfVqSL3qtzx20e07rqLrS8JA3G4x3HS11
         BMgrlLlxgZpXH23lIoaGSCJ1CXOcsJcjQlAR7DQs0G2EXOJLu5UO1NjWbXnNU5iGar07
         4IsIgAZqXotuZtz+668SMp8TiPfMKLfZAk992Po3D6cPoKx3F0ZrqqddN3uHI5k0SDwD
         eOXA==
X-Gm-Message-State: AOJu0Yw/RB5dla556RHGbgVSiuQ0BQzLGB6ve5ZIKI5fZl1XLHK096iT
	4nb8/ezDO1WKdNrZiho4pHE+TQHgfk/5hZYP17IuLzLRMBM2CWwq2iNbgB5ctATwEFluZw==
X-Gm-Gg: Acq92OECKfk4F0A8UzcoWcuUYykYztn5HEiqKkgK/txy4J5iFgnraCXQBOXPKcxarO7
	LosGzx1Ilp6hMZVEdHmTl/HoQuQmXM+G16Mz3lBMv3Uhhb3YYzNdQhnmwkeNq6a1hFHbpCIPuc2
	4dgcS6XLhU8fEu750mjK6Ggn5xRsZqEcxnLXjSEgHm+fR2/WT9c59gwgCyD4mzSsA/wVC6EuxT8
	CMjjn46WQZ3bGNGdKOQqgIIaHDOMBEPXyCtWUTrAIXerdniFiNJjTx6lm4BRvXrOauVWpgxS9D/
	PNViuvUNj5Un2231QlJguGBpnO4ndtWWsAoij2izj8cbB/y5GfCP5hG0iOr2W0l4LZXK4CHVMiq
	TWQbBxG4m+kpJXg16MkrApo7s3mumhTNMYsVkXQvJg7RSWejvAd0viEFAHLeSMPCFpTIA+dqs3P
	i/jr/TORS5+PB/y9gUjtgSbwRtBD1+7hz/cn/kFyn1BRUfen8=
X-Received: by 2002:a17:90b:4ac7:b0:365:a5f6:4a5c with SMTP id 98e67ed59e1d1-36e3064896cmr5407549a91.1.1780540740997;
        Wed, 03 Jun 2026 19:39:00 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8573sm1253072a91.14.2026.06.03.19.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 19:39:00 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	Alexander.Krabler@kuka.com
Subject: [RFC PATCH 3/3] mm/compaction: respect compact_unevictable_allowed in alloc_contig path
Date: Thu,  4 Jun 2026 10:38:12 +0800
Message-ID: <20260604023812.3700316-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604023812.3700316-1-chenwandun1@gmail.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 108C34000E
X-Stat-Signature: 8zaustpkf9adgntb9digpgm9qmmsi8qb
X-Rspam-User: 
X-HE-Tag: 1780540741-909025
X-HE-Meta: U2FsdGVkX1/NaEZyRQ4b1SlC8XXSxEofn+IBdViBCXodkrUJKlVx5CaNG/ShaD/gV7YbZ+Yqnrn853e63oHY0OoV9BJ4uPchCx86he471tFF0yWC0wgyJbzZugKId7AGqIa3fNYmQhTX1wyzPYBWNcY38iELf8j5XETxJwEP+DAUH6XDsJHUTJtMMhBfMKWOZrEBp8/o7k1FTgZYnbCMbO2CKNetxmif5vpDCTeeMJ6xSA4KHTtVLomKt0GeQY7FgczYpfGNedc+BVhUUY/AUTb9wjWlnx0uh2+RFUYeUCn6uQmnzVwDYfESX46tEAE+n2f4NZxUFk1FlEEy25691RWns7vpWGzzydQeYrx1OlymjUurABuogI/QM4gG72aptihtwsldpYXeZ1VjeFXenY3YNtAfKq8hb8bTTHxC5OpOxoQFsWYpyX+b/lsU37ZxkAJqwUos3Qq8Hp/YcMUzaNguhPkyzpXydCOuVFq+TJem/tTEiVY/p05TOol5A05d9ftxE0gAVjszukeTErPMk+scRDC/zdKRrNkHAHTD7K8W841rHUNrRMttHxSLYsEK6Gn8jz2AvmHy1LpKPe9kpYXd6tO27646M/iqLzsjyzdZrbOV2osEZWIqehqzjGrXGn8zLlBK0Uo1FQLNGqrJ9sH4/YPF88zQ2Dxz+vCUHDnUUKPSt/2G4Fjb6Dh+KXGbXyPF2BGBJpbYRQ6kcY5h7T628jrYv2P7UWGY2mIYxnDHZMueYM9sdF8n4aaNbU/3L3ejQYLzJ5/X6XKTL+K/5OnM98bCs2u/AHqquFlTlxb2+px6mEI8z7gg7c+FjHNNO6xYVQvWgC5HDTaIN6k4yloarSZKgYjFwTeeJ2t8DB9icIPSwBTvlFQV9nEh+GEQxter7c4n222QR4Fp3Su0cTYhm9cu17VNVIsgdUop4qmOlN4hlvemsV90QPM+nOw5RjKpCppid+LlsPfmaBy
 nMn5tQPd
 WTgSGMblX3F/eBkvL7PcXnwbJLcUGRJJCfAaZ61lyCLHqGvyUhbKRthZWiotiIYAWrFfh/Rr8WovseIN7hbyDW6lMwg0vubgJVWVC+Nd/G6EFU+4LevPLOY7uIViGoU0r2GsJbAsK9z/9zWFlOocCF3sQgR0n+TAWKNOmBQbTHexL5DgHJRFbU6JIC/oXE8kz9rTOnC8/Og9zmZt6zshvFQFUPbTNJatYYmaM6skZiFXAPNL2LNRVeTmdVRMtdaTKhGTsO2RHE44dJCg6sjqVgHHJUIhEvQHzqZcCr0Oxyn3savulzVdC8sCd8rFJfcikPX95BS1Prk0I/O/0DiUIV0qBGw1ViwC5wH9QAFEIeQ/fyT12eqDkFSbfHJNuA2UY7Hy4sgoQUB0KyHtjEfqNR3D7QySHWjPziZm9FLpRHVFkP8A4JoUrGZoZFWt73aPYOXO9E9eKH1F4MjfYDvJx3MdusKyOG9Jx2HYoqxja/06zSYbv0+blLt2TOeDevJ8CQdBbUcOxCXelvTY7oRbdRpamLTXsNFOXdMGo4VK+PcoezwabZEuBmZ9keaeLtoHCrBfeLOqZ7c+yGgPBlZf/IGCX4S8Mdw9brX6K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

vm.compact_unevictable_allowed=0 is used to prevent compacting
unevictable pages. However, isolate_migratepages_range() passes
ISOLATE_UNEVICTABLE regardless of this sysctl, so the setting
has no effect in the alloc_contig path.

Fix it by:
  - Keep ISOLATE_UNEVICTABLE for CMA allocation, discussed in [1].
  - Honour sysctl_compact_unevictable_allowed for non-CMA allocation.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/all/25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz/ [1]
---
 include/linux/compaction.h | 6 ++++++
 mm/compaction.c            | 9 +++++++--
 mm/internal.h              | 1 +
 mm/page_alloc.c            | 2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index f29ef0653546..04e60f65b976 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -106,6 +106,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
+extern bool compaction_allow_unevictable(void);
 
 #else
 static inline void reset_isolation_suitable(pg_data_t *pgdat)
@@ -131,6 +132,11 @@ static inline void wakeup_kcompactd(pg_data_t *pgdat,
 {
 }
 
+static inline bool compaction_allow_unevictable(void)
+{
+	return true;
+}
+
 #endif /* CONFIG_COMPACTION */
 
 struct node;
diff --git a/mm/compaction.c b/mm/compaction.c
index 007d5e00a8ae..a10acb273454 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1341,6 +1341,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
 	unsigned long pfn, block_start_pfn, block_end_pfn;
+	isolate_mode_t mode = cc->allow_unevictable ? ISOLATE_UNEVICTABLE : 0;
 	int ret = 0;
 
 	/* Scan block by block. First and last block may be incomplete */
@@ -1360,8 +1361,7 @@ isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 					block_end_pfn, cc->zone))
 			continue;
 
-		ret = isolate_migratepages_block(cc, pfn, block_end_pfn,
-						 ISOLATE_UNEVICTABLE);
+		ret = isolate_migratepages_block(cc, pfn, block_end_pfn, mode);
 
 		if (ret)
 			break;
@@ -1902,6 +1902,11 @@ typedef enum {
  * compactable pages.
  */
 static int sysctl_compact_unevictable_allowed __read_mostly = CONFIG_COMPACT_UNEVICTABLE_DEFAULT;
+
+bool compaction_allow_unevictable(void)
+{
+	return sysctl_compact_unevictable_allowed;
+}
 /*
  * Tunable for proactive compaction. It determines how
  * aggressively the kernel should compact memory in the
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..163f9d6b37f3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1052,6 +1052,7 @@ struct compact_control {
 					 * ensure forward progress.
 					 */
 	bool alloc_contig;		/* alloc_contig_range allocation */
+	bool allow_unevictable;		/* Allow isolation of unevictable folios */
 };
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 81a9d4d1e6c0..1cf9d4a3b14c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7118,6 +7118,8 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		.ignore_skip_hint = true,
 		.no_set_skip_hint = true,
 		.alloc_contig = true,
+		.allow_unevictable = !!(alloc_flags & ACR_FLAGS_CMA) ||
+					     compaction_allow_unevictable(),
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
 	enum pb_isolate_mode mode = (alloc_flags & ACR_FLAGS_CMA) ?
-- 
2.43.0


