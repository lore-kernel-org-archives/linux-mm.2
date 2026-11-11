Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6329606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=jLw1kKQn
Received: by kanga.kvack.org (Postfix)
	id CDB3F6B05C7; Wed, 11 Nov 2026 03:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB42E6B05C8; Wed, 11 Nov 2026 03:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB966B05C9; Wed, 11 Nov 2026 03:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4A46B05C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:42:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41073A025D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:13 +0000 (UTC)
X-FDA: 85422196146.24.635585F
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC863180003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=jLw1kKQn;
	spf=pass (imf16.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6ne6roaEV/RhWN6heK6JAW4EAyY6eRh4+UTmgKxS2xQ=;
	b=gB3VcXZKFOlQbfaOdwfCBLopGhXa2A3M5+ntlX2T8Ntd242QVIH8zjEAkb/wzIaGjBGwA6
	s82xwlbDwT9LL0p3FRd4psLC5AOIG0/slOybulV0uxR5bBf/xMJOczUxARxaEpi+CToMid
	464q3F3sI1mM7UJzDD811735X/IMWOA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386531;
	b=DFXZ+dV2F3kcxlG+MX0O1MLN7mtD71AdCi6jSnMfaXgs6khqG7/VZoahgilPLubGV93LTr
	DAkPXoLXHfWsNu4ZK2Yz1Qrr0Ht6ZX04TaAaawMYPLb2dKYluiVMT34XE3pBqdgO9AtuDS
	p0u1Hk7CE/zZ9BOdhTFdASu+p8XJkqI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=jLw1kKQn;
	spf=pass (imf16.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=jLw1kKQnWdtnbsc3Lag6qkbq3XK5BwnAzRiy1q0o6KojkCVMtM+iXGfqBvIx2wWv0u1mBmhCG5kYg
	 X2tqaTRUpnsWQbZIVVxhqapEErI/TdVQALTRx6bayDL8M1KYYJl3S6Kj9Q7Mrzd95QHXL1s+kkmHA3
	 6TCc/IIS/Ci0mRlM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86af42a5ea02-76b89;
	Wed, 11 Nov 2026 16:42:07 +0800 (CST)
X-RM-TRANSID:2ee86af42a5ea02-76b89
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6af42a5c326-d5536;
	Wed, 11 Nov 2026 16:42:07 +0800 (CST)
X-RM-TRANSID:2eea6af42a5c326-d5536
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: vbabka@kernel.org,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+212c2d1f47994035cf7f@syzkaller.appspotmail.com,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] mm/compaction: Mark concurrent compact_considered accesses
Date: Wed, 11 Nov 2026 16:42:05 +0800
Message-ID: <20261111084205.80997-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC863180003
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xc318xz9qx5wf1jwat99gyfayubwbkjg
X-Rspam-User: 
X-HE-Tag: 1794386529-75128
X-HE-Meta: U2FsdGVkX1/dEPo/IWe+5D2y4yesNaKD9ZaJ6UTRABGqWKptvekmrx12fIaX2IXVwEeirhkSIan3iZTxsZaRjwwELP+dMnKJR3B+9hgPnuctT8hKEioekKFJkNYncV3TM69JpAXNsJF2zwbDrFAXt2XROiLXtUve9B5Ikt2uZHBM6zpYIGZAU0r6Kn17MAn0X2fri2t58bhkNebEZ3ZH/3yuz4tadGlHdlux2anLw71ojJyPDvES2u4miG+AKquIUztUpHXKA3ANk0DpIEsjOu4zRp3kKDlxscJ4Mf+/AFyRlsC62dFbh2Acp64Tz9bv20gRDyTB3qxIGXyxvyJEfteR5wXAn0SbTWZPyn24MPLG/VfWVWzvV8WuJ6exIOOWank9XDX8V+Ljm9p9nLHU4iSMFNhmmTtxw6P6vLL90NiD4AcXcup/cTBeIAhmXV3yu19nhf4jQlzMz8N/wIrkZ1jsGXT6gKHqfviNnMd64ptTod9ZMm0EQe0EAhMYsZMpgOrAq2n6ruCawcmV1RhsAC3ggW0Xm/qewZe75ACKpwBB3CXapDHk+dqyYgF61qayXsvyi0G/OcXn6COmx2zyaH95n2KxmI8KZbmao2bU9tnHEeLDcXCnPRYznJxNnQ5FYNl+AjsdfWLsagBKdxOuaMqkCFFs7oVKX9OtctiPtlaVI9am5E0CVFlXl/58rbhrnIBX9cTpYP6n+ukgJa7WtHunCUE9NgaeqnrPSXjIEOVhgm6C3DXPc7dG+NWnIalHZAMpT+TUkgVe/OPyHW3lwPSDfPXZe4jBkGZJ5Agry6N3wIHppmTjGeIDw0kBrq31GzJblNRejAN+4t6+7CNS8NOTXllJNYKVhuE9bB9h82gmHlfBa9gq/BjRSsuXfz4Iztsod7BBH2KI/3EeGzcRg7jmpXo1z2z6UZ1PTPkrSfpMAi5o7G+r4eEtW/68/Cozfqeps2EHFI4gFV/5iLE
 cU/Ld8V2
 id/YZQKqp0K6UdPihNXi6bAI5e8lhhhwu+BNMqRQzlYGhfwTZ6yduLw10rx/toa8XYgHvmFbNpxkcGipsZd77UyDZ5R/aRGdRRESk5ik5y5suoKGZLL4QO1wa8+seysu8HATZixNKtl3ceVXDwVm8TO924rnfBOJwlgqWtGpXBmkT+Qri7DHpIVT5mWXlhuxffyD3RnZfZzb9P2uRSX3VgmkJOFjL0kZ1rH06umC30Sb6Nrl7LTyqRSmVaxxvxIyYrTuUEgx2cTxVUXZVmeNm9goPZ69/llpqNyn52cDix5E3QyTGeW485zk0rzQFwlizw90RH1nT46FAxNQpCOUareC+9KTCLFhBD/raENqaMA/BueKyypvUCDTHrmMDHq2ApT1DjPd8G6Jcob/s/VwTH1cT/ntzPw1sh9X6OREBDy9g3VzXGnpgQnA88xqLBZPp7pDV9coG/2gbGZGHfCWARG5y/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Direct compaction and kcompactd update compact_considered without a
common lock. KCSAN reports the plain increment racing with a reset.
This counter is an approximate backoff heuristic and already permits
concurrent increments to be lost.

Use a local snapshot for the saturating increment and mark all shared
loads and stores, including the tracepoint snapshot. Preserve the
existing saturation limit and deferral decisions.

Fixes: 4f92e2586b43 ("mm: compaction: defer compaction using an exponential backoff when compaction fails")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 include/trace/events/compaction.h |  2 +-
 mm/compaction.c                   | 15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index d05759d18538..42303a4835f5 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -255,7 +255,7 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_template,
 		__entry->nid = zone_to_nid(zone);
 		__entry->idx = zone_idx(zone);
 		__entry->order = order;
-		__entry->considered = zone->compact_considered;
+		__entry->considered = READ_ONCE(zone->compact_considered);
 		__entry->defer_shift = zone->compact_defer_shift;
 		__entry->order_failed = zone->compact_order_failed;
 	),
diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..04b93d3545af 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -126,7 +126,7 @@ static unsigned long release_free_list(struct list_head *freepages)
  */
 static void defer_compaction(struct zone *zone, int order)
 {
-	zone->compact_considered = 0;
+	WRITE_ONCE(zone->compact_considered, 0);
 	zone->compact_defer_shift++;
 
 	if (order < zone->compact_order_failed)
@@ -142,15 +142,16 @@ static void defer_compaction(struct zone *zone, int order)
 static bool compaction_deferred(struct zone *zone, int order)
 {
 	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
+	unsigned long considered;
 
 	if (order < zone->compact_order_failed)
 		return false;
 
-	/* Avoid possible overflow */
-	if (++zone->compact_considered >= defer_limit) {
-		zone->compact_considered = defer_limit;
+	/* This is a heuristic; concurrent updates may be lost. */
+	considered = READ_ONCE(zone->compact_considered) + 1;
+	WRITE_ONCE(zone->compact_considered, min(considered, defer_limit));
+	if (considered >= defer_limit)
 		return false;
-	}
 
 	trace_mm_compaction_deferred(zone, order);
 
@@ -166,7 +167,7 @@ void compaction_defer_reset(struct zone *zone, int order,
 		bool alloc_success)
 {
 	if (alloc_success) {
-		zone->compact_considered = 0;
+		WRITE_ONCE(zone->compact_considered, 0);
 		zone->compact_defer_shift = 0;
 	}
 	if (order >= zone->compact_order_failed)
@@ -182,7 +183,7 @@ static bool compaction_restarting(struct zone *zone, int order)
 		return false;
 
 	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
-		zone->compact_considered >= 1UL << zone->compact_defer_shift;
+		READ_ONCE(zone->compact_considered) >= 1UL << zone->compact_defer_shift;
 }
 
 /* Returns true if the pageblock should be scanned for pages to isolate. */
-- 
2.51.0




