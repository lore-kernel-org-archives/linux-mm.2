Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62F4C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7BC6B00A5; Fri, 21 Aug 2026 04:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DBB6B00A6; Fri, 21 Aug 2026 04:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4186B00A7; Fri, 21 Aug 2026 04:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 842176B00A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10F821A035E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:31 +0000 (UTC)
X-FDA: 85124574822.09.F17E770
Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2EF2D20006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hJDuNPG/";
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSGHMZ5hGxLV9vjBlL5IJRAgW0SFuLyCaDcStCkrc7I=;
	b=67F6Xj2j/sktpJWVimjSivxB8ifgeYygpw09xYVoJpbmjYfuc7mmkgAtvtraP7dzII124R
	QS9LMS8e9ovtDDblrkfXOqekXIzK65XlnOfpJejoFJUiHBpOUkAAMS8PYLwI94DiesJdrG
	efc8ktmYcF7BAQ471JIUJjPC4hYbJdg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300309;
	b=8CnmZQC7SABQuat6SeJUj3fq3pKmac1RRuHYBTD5cW5KxJeGXHhEjHnB8t8XckgN3FAWQD
	cOW8OC97IX/z1a1IBQaLnJSoAIgHxsdqkaCQsL2COSJsi9AuGgvho4+hqNROyQ1DMNuetx
	eVEE22DkiORiBV7zWxxAMj5/g+uq3hc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hJDuNPG/";
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZAscUiHq/rYEWDhnt5RfykoKmzATq1btSoHBcxnZeVk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300308; v=1; x=1787905108;
 b=hJDuNPG/aIrW3VicCgnYHMPfZFZcSKAzqkrKsTLse2VIpQ+LXI0Lc8Z/t8Kt9/MNARyi+lAO
 zJxztGQe2GX1ukUqyOoRSYY3f4hvV8TDVqCR2+VZoqYhdeuolzlyU01k5+Aj+nszdlDwxKMx/Ku
 nPmZFeepM4GaB5y5mUn7Ahk0=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 9be2503217972ce1;
	Fri, 21 Aug 2026 08:18:27 +0000
X-Mizu-Trace-ID: 9be2503217972ce1
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 3/4] mm/vmscan: drop the combined limit gate in __node_reclaim()
Date: Fri, 21 Aug 2026 16:17:40 +0800
Message-Id: <20260821081741.1340277-4-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821081741.1340277-1-ridong.chen@linux.dev>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m4q5onpqtxpzyna8zkio4j3cgiw9ttfa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2EF2D20006
X-HE-Tag: 1787300308-780346
X-HE-Meta: U2FsdGVkX18yT+FEBbDXjU64UqeRoiWmuDSJdOG49EhgNu/Xf3UeAVV5o5Ij7wd7HWNBGjBTI61BRfqadqpy7rN748kV0rArMjC16ChzGJYZ+ct9tFoUNoc/YJDv2Wu71nubLTVN5C/4dOl4QvMIxcYymIYj6TMfnsFWYVHL7ReDpTctj3REG5rtKh4io3/cvzWmA7ulCdmh63v0aEaFax7Xd+XAC1jXVYJDBDiGmNgN1+rv2WUeZlWIuyRVC6B6V8WrctFDs9ECYaLljlg8KaFBIr1w40JD52r+w521ve19r1iYBXYKIBW3Kq3dEAMv/qdvcWl6FoNoblS3XKYK8reqNkkgZohsOYx+hVqB5FI35qQHlJzVIcjRafeQEuMrpexoSzb0UhuAvFOU+UvGQTRMvpfXzV76lH0u0SFdp0Nhm7up++cIPFpxUas4+03OyMW9z5v+iv2TNfZPk2BuHMUzT/RVUyI2z+ftPj6lCBR+lBqfrlRDprqxg1AOK/X7SnjgpOpUedGrfM+ggQfl67/LMIq/DZ/Ks50ToVN0CtubBVAynSuiOagoh63TlWcb/Ca1Elmxx3KN/ZWD3+IMIdpYiCP7DFZs8rJzg9Tsh1v0jqQ5XbxuAYzMs/c9mdqn65ue6nyhGKqnBWcWv0o6pb2pNUDIhyM7bkkQ5bch4E1+7TUrsub3Y8CxQ8glpVjjhzQdWx2vsXaHLQ32VXLeMj1xkd1B4+ReHk0i7ZhCnPEI7rQZn6Y4IHeBRIhhDfSDcqfjqp9JmM86ZKtwxBcyoTKcMqiW6WDQsGeDYhFQ6imZZIsMXg9oMS4i/NxMTzSJgblWjd4IcaG/dgcenUbvjwS/ztJjMkMBEi/xbR165H9LtkjDw0XXTAKuQi0uxrbz+W8VSdXaMka5vw3srLbxtJmvDybLz5SlGij75n4sYkJth6LK2RBef6NDPXKuKG1Gb3ndnkG+Y4Vb90GXK9C
 uh6i9Xvb
 l068IBZRB36wTdQ1Ef8ThX4/IgQg2bBxTh2xAwiC6D8jvCnnNqxdBtiauwP6ST91UVNdBZj+oIq/4HlyXOrN4aBYJePqBCsxCJJDlJfDIdnOacWNe5HLjgtZzwW81S/bH+5efxDQxRzZDbYJe/gjQHawFcsCCFWabhhRUPNK1B9Rm3sodiTOgCHJd53aNffiKy3GcNobCjzEgicge4sZ9EbooVTT6uh5hUbYPd5KjXg+mBFr/0p+yRJFb/uiNVOoVj/aQeMe03S1jKaOxC4MKNiSNXwG3UtIyDtM3oKyIRS48Dbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

__node_reclaim() only ran shrink_node() when unmapped page cache was
over min_unmapped_pages OR reclaimable slab was over min_slab_pages.

With slab and file reclaim now gated per type by sc->skip_slab_reclaim and
sc->skip_file_reclaim, this combined gate is either redundant or harmful:

 - for the NUMA node reclaim caller it is always true, since
   node_reclaim() only calls in when at least one limit is exceeded;

 - for the per-node proactive reclaim caller (which does not go through
   node_reclaim()'s checks) it wrongly suppressed all reclaim -- anon
   included -- whenever both page cache and slab happened to sit at or
   below their limits, even with plenty of reclaimable anon present.

Drop the gate and let the per-type flags decide what to reclaim.  The
node reclaim path is unchanged; the proactive path can now reclaim anon
as requested.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1e56973ceb73..5a3f67b3ba32 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	noreclaim_flag = memalloc_noreclaim_save();
 	set_task_reclaim_state(p, &sc->reclaim_state);
 
-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
-		/*
-		 * Free memory by calling shrink node with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		do {
-			shrink_node(pgdat, sc);
-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
-	}
+	/*
+	 * Free memory by calling shrink node with increasing
+	 * priorities until we have enough memory freed.
+	 *
+	 * What to reclaim is gated per type by sc->skip_slab_reclaim and
+	 * sc->skip_file_reclaim.
+	 */
+	do {
+		shrink_node(pgdat, sc);
+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
 
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
-- 
2.34.1


