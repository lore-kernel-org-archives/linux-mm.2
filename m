Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA525EC1113
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3F66B008A; Mon, 23 Feb 2026 12:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F67B6B008C; Mon, 23 Feb 2026 12:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF09D6B0092; Mon, 23 Feb 2026 12:39:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75F36B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:39:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 959861C111
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:50 +0000 (UTC)
X-FDA: 84476434140.23.4F545F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C96EB40005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:39:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHTL20es;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771868389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yxGWjE4hxhhkXfMqHbwfsKCmiOpw5w0sNqOn4K6gLg=;
	b=GEehS3xLcpFx7k0pcuQ+jMakZBXJOnjY/scgwHwZUqYDqha//uW0x6kemKhOW/X5QYHRYh
	ameGMQPvzrgHuNQXi6pPVJ4uhsmeRjzZGop2+/k/LYHVLZ1oakHPrTo64rOZBckP8DwsNu
	cFHBl3TeGeTi8J2oln0s8U/CxG0BuOQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHTL20es;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771868389; a=rsa-sha256;
	cv=none;
	b=cvZklGf+zjPbLZ60qWL/HX7uMrPs4ow15/a97kGAZWW2kQRxi5IKrpPjSrlVV5Y+DhEr7l
	lC2st5vYoI+ws16nUqODbLzjugmoqRqQ8NZQkvw/2F7LdjJnkP8j/5rgH1/7cDIlCh94VK
	AxYzdydraBR1/9G3Hnu+liBZ+GT9QEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B99A044546;
	Mon, 23 Feb 2026 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCABC19421;
	Mon, 23 Feb 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771868387;
	bh=NkcemZpJG7TCrHsvZICKpUMsr7YdyLPMVXVEcANIaKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHTL20es9YL5TdCn2/GZoN52kB9d1BjQa4LXiqBfKeudVn+ehx8Yfqm1hXMnuKye7
	 inc8mYiLyi+w677wZMOPLtBnhSE86TqylTRKxVANwNQsqae+Evb0hRxJD1g8x41bTh
	 8/sTpvSYR9niPAD5TLbMKm7yIGMcmJTgSJOHAdj/jEjCgql2smOs7EGVJ0U7jb2sJE
	 qa02Mm3EFfOQeGuVqRgIZ2Nr7ZWmW47qGTcLdCHFP/9S2KtaPyPfsUBgJgKU/HE4Tt
	 hwRr0ONDc4y3rQJRvZ3qpfxmM4GInWPkN8c7l3R4OT8k9hqAYxPH6swiwbCSM1rn5b
	 TDDyFJ4/yotAw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH 2/2] mm: memfd_luo: always dirty all folios
Date: Mon, 23 Feb 2026 18:39:29 +0100
Message-ID: <20260223173931.2221759-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223173931.2221759-1-pratyush@kernel.org>
References: <20260223173931.2221759-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C96EB40005
X-Rspamd-Server: rspam02
X-Stat-Signature: i36tdqm1e5w7angxt7gs6kx6ra7baoeu
X-HE-Tag: 1771868388-578162
X-HE-Meta: U2FsdGVkX18nrfsMN5RypTfuPjwQbY9sgYNSLbjVeEHTy+vogCuqas2zXSiZSx+EazWVwebMW9T80EEFP35npHeUMbtx8MYIKv66KtgEXLmclzXBvTziQ40ooy/XZLto6vHxhwW2S/e4yURpFUtdN9WQ5eBxPXhUIr7P3MjivPVparFq/vcltNLs07Pp2bO1IdDsb1Ty2IOx2XmiYZak4ZJPkuaQQAhL/RAKbdXq1wNe1k+UawGkk1K/hEw2mezWDGjDtC3HOZUrbZfHu0R8y5axXo6NYJyFMogrF/2Rt4Ktw0yzTqF6ALlNnpczLA/3W+3XioCU8M7u6m7F1EHcohhJ7hXbhpPQIdfPq6F/yMW21IDodW1uvhn3+3KCbj8+DSIp/YDHrfHh1Ch9ebvFcb5PA+93cUyRLyfc7Yyo39KybwA4Lu72ZkjHD97PLJfNrZQHvD81lODrAD/JQlvDqNLoC2Dz7dIyYjzvJ+8Re+rKjeqCNenrE46MV+8fbwvEHd0ouXbR2IuPE0Br27RNId73nyuy9FlRQVHBVg1DGuKSdcr7JSBhmkDdttHDMrs2Yo+a5bGe255AcXREyctnBk57+rONndY1GWWUzCJTuwaImIIVpod0MtCwtlx/sQtr1E0Ke+FVtNild6yrpC/JNjtB8bq37pZJ/ImSCsUFGMQOsUxv6SHxRx+KsLptxS8GLAvckVPohQxEj3umw8wNs3NI18o9UU1VTWnhhjchS9IZw7hh1EYSWPmV+xJmwPOJeZVgx1tctQZhV/e+qlsIQzMO3HMHbdNzjwThV/X5P6hw4nd84mAZUdwRym72gevrCpS5ZisPqfwUM4tbOK01X5XP5Lj9CiFj4syPfUBSmPSRbPT3pHUI4BvqCLpc20cyaJQk2pbrQA+Mkr7O01IbCM81bSMIDKrXxS5C0eA3JuC7JH4bFBLX1VwOkVjgUzF9Yg6+pE3sAgjNc8Kay+d
 EiFrK0Be
 3sA070xLIVtL79AQQrwgO0SzGI7/AkWdSSWb3kuCyvqqauuwD2NROjvEMcRfF2STvNUk/G5FyoYqsdL3IAX8aZn0uJI4lnFu41k0ruMnfUfZI5tEr62GelUd/RlNv90NK2Ag0zmeXBbNAh9n+UO/BLk70bWMimSBpTJAiqo19uPr6j3a5VCnPU1hEwUZG4+3WKMxCQXytYFAthFqGPH/xeOUeeWClIDcjUGpw8ERdPORzQoCUeu8upoSJHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A dirty folio is one which has been written to. A clean folio is its
opposite. Since a clean folio has no user data, it can be freed under
memory pressure.

memfd preservation with LUO saves the flag at preserve(). This is
problematic. The folio might get dirtied later. Saving it at freeze()
also doesn't work, since the dirty bit from PTE is normally synced at
unmap and there might still be mappings of the file at freeze().

To see why this is a problem, say a folio is clean at preserve, but gets
dirtied later. The serialized state of the folio will mark it as clean.
After retrieve, the next kernel will see the folio as clean and might
try to reclaim it under memory pressure. This will result in losing user
data.

Mark all folios of the file as dirty, and always set the
MEMFD_LUO_FOLIO_DIRTY flag. This comes with the side effect of making
all clean folios un-reclaimable. This is a cost that has to be paid for
participants of live update. It is not expected to be a common use case
to preserve a lot of clean folios anyway.

Since the value of pfolio->flags is a constant now, drop the flags
variable and set it directly.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index ccbf1337f650..9eac02d06b5a 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -146,7 +146,6 @@ static int memfd_luo_preserve_folios(struct file *file,
 	for (i = 0; i < nr_folios; i++) {
 		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		struct folio *folio = folios[i];
-		unsigned int flags = 0;
 
 		err = kho_preserve_folio(folio);
 		if (err)
@@ -154,8 +153,26 @@ static int memfd_luo_preserve_folios(struct file *file,
 
 		folio_lock(folio);
 
-		if (folio_test_dirty(folio))
-			flags |= MEMFD_LUO_FOLIO_DIRTY;
+		/*
+		 * A dirty folio is one which has been written to. A clean folio
+		 * is its opposite. Since a clean folio does not carry user
+		 * data, it can be freed by page reclaim under memory pressure.
+		 *
+		 * Saving the dirty flag at prepare() time doesn't work since it
+		 * can change later. Saving it at freeze() also won't work
+		 * because the dirty bit is normally synced at unmap and there
+		 * might still be a mapping of the file at freeze().
+		 *
+		 * To see why this is a problem, say a folio is clean at
+		 * preserve, but gets dirtied later. The pfolio flags will mark
+		 * it as clean. After retrieve, the next kernel might try to
+		 * reclaim this folio under memory pressure, losing user data.
+		 *
+		 * Unconditionally mark it dirty to avoid this problem. This
+		 * comes at the cost of making clean folios un-reclaimable after
+		 * live update.
+		 */
+		folio_mark_dirty(folio);
 
 		/*
 		 * If the folio is not uptodate, it was fallocated but never
@@ -174,12 +191,11 @@ static int memfd_luo_preserve_folios(struct file *file,
 			flush_dcache_folio(folio);
 			folio_mark_uptodate(folio);
 		}
-		flags |= MEMFD_LUO_FOLIO_UPTODATE;
 
 		folio_unlock(folio);
 
 		pfolio->pfn = folio_pfn(folio);
-		pfolio->flags = flags;
+		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
 		pfolio->index = folio->index;
 	}
 
-- 
2.53.0.371.g1d285c8824-goog


