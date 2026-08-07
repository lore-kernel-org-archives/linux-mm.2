Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A7DC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C28B6B008C; Fri,  7 Aug 2026 16:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588246B0092; Fri,  7 Aug 2026 16:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0F96B0093; Fri,  7 Aug 2026 16:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10E3B6B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C02A160142
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:06 +0000 (UTC)
X-FDA: 85075592532.05.F53DCC7
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0DBF2000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FM/EwKNt";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIJ1lfVFAjreFSGxK42rkml7ixTeVT5CBMzYSJnOvv4=;
	b=Oqx619U69RKSl3BrcnYDZRdR2sROi7RiZMWL9BXCIikEvrzLWtPMLuC99LL2nNRIDQz6oK
	GYaF7cRbvEa/wGbf39W5zeftMA4NJ+PiZfU6YFj5cEgg+m+B+GLUUKJRYQ7YX+v4jZMfYG
	j63Z0NRf6uQrkQbsBu4brw7ch5TOloQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134064;
	b=Y7XBctHElCM3KR4PGhYiaLK3Xtsfznu9Za7YOnNpqlsYKs0rLYzm4AomLNzDvcCb/DW73o
	6uAfN9qaLn/wMtyqhXjq/jlFcoy7ua3SQV1x56Y0nr+Fh3qhb6R10qxahYZePGjDKN1w7V
	F6PuP3uMcCl/d6e28cpMNFyodS7mMQ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FM/EwKNt";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e9fc3de7ceso1930904a34.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134063; x=1786738863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uIJ1lfVFAjreFSGxK42rkml7ixTeVT5CBMzYSJnOvv4=;
        b=FM/EwKNtE8JiisPRWbCXmMzrzSn3MibqeFAE5NeqCV9VJWDq2CB6tw9rnwMMsdAmWr
         UYTG2k6vWxtmEnKYX2ckMzmbE91MUKArSqBs6xNiNnKcVAI31pQzHX/4eURo36Cq2F36
         eVkdeWHugOPD2qDtRxWsRs0Cl1dV/go+QGo/OuPX0dPQXrSo7dev5esJLmZ8M7pDYEn0
         9cRd6qFOlhbxMi1C8tTxBs8zxPqVxDNN2pcxKJYcAkprY+FQYxJ6YzdKTirbz2g5WouJ
         9bz5Su934CJdJa6ec+vXcpizBqOP/D79tveg6PpfeqO4Qf5Kn64oBW+Anva8hqJezIHv
         pVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134063; x=1786738863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uIJ1lfVFAjreFSGxK42rkml7ixTeVT5CBMzYSJnOvv4=;
        b=SaJYsFWVRB2/YF1fRZ5zzVuGoNccgVcQ9Gm+1meZ2TfsfMFUXNOu8YTdH7g49WsXbt
         lZoySn4kFmOIWmEylY00xxl/AmQU9UqHWEmulUiApPgmrDO4/5RV7u1oMvmhmCGc6dDf
         wWC1jp2xuuKdOM5m5hXBrhSNV7ipgZKLUy84JhfpHydN4G5F+UngvAy4kUpAtygbv40e
         e7YsL2rqURtn4ku5ZlcGNu2C5JCV/DyyTtxeMdDp8CupgSkfbP4IoiJ7maVSuKH9Kewz
         F+2p6SWp2obhm1nqPLABclYkVCVKLQNW1V/P4245qqrFE6LEYyPpNO5yxGSn/nHf+7C9
         +KWg==
X-Forwarded-Encrypted: i=1; AHgh+RpMMKpArL6aPt3UG4qSJ57LM1Rk8474VHh2H+7YG/pUTW9FEQNEPYz6eVA3BLcui1/7qBJOppZSQA==@kvack.org
X-Gm-Message-State: AOJu0Yyw85G9kLQHMu1X/CNKtA7tfRPtyu6dM5WX99ZlJTkIM0oGdrUk
	Lo5dwEkWLVxUOlnSndxGyIXDzZfah9pT+0U3T9hJNuXOa2PforYkQE/X
X-Gm-Gg: AR+sD12eZCiyQE3HxPjMsoFWimIXN49mQLsX+P8kasZXnPmjxFCASIVWdVCywPFo571
	M9fZr6Cn8GX9MlarfArZ8CBy6KW/pXoRkT0wQ8tDQCN3i7NBhvyy2VJC/ITcHoJBmSfeVU3jDFs
	xdzqiOlLQUZ2dkh9XWEXD2iFbIc5NMXHkdl/GQtTYjhqDmUqRc9sOUd2PMOEfyLzquC1ys65/Xn
	347h6dQEX768/mwhP1xr9mRO6qh/jNR+eEjEieg83iR/oyDvmNRyrKJj9awMhHDx407j734bbkQ
	bCXlprGAKYTDYy3+/9wFybTVmDtUebuSzulBVYNChYglaWxtu7HA/qIY4O2vf/LDzS0mLzHXYzY
	9pfNT6iO/MRpMjdv4uVC8t9Z0L/Q4LBg1GoduxvQIKxBATJQ34/j6Ws74/LtV3wFdcu99MyNAcX
	XaWIEg1uchXpdRagS2jO0Qki6BAaCclJ7fuOrxRP1uVqJ4AlbYtr0n2elL0za11bwWuVhpA75bl
	mhDki7ndVGkOQNWb48=
X-Received: by 2002:a05:6820:8118:b0:6ae:55f6:2cdb with SMTP id 006d021491bc7-6b041ee0996mr1744079eaf.1.1786134063536;
        Fri, 07 Aug 2026 13:21:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:46::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a76701sm2665817fac.5.2026.08.07.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 02/14] mm/memcontrol: Refactor page_counter charging in try_charge_memcg
Date: Fri,  7 Aug 2026 13:20:45 -0700
Message-ID: <20260807202059.2620949-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0DBF2000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ufu4aofoq7yznr3dkb7bhr7whm5o6kjd
X-HE-Tag: 1786134064-576577
X-HE-Meta: U2FsdGVkX1/+uawo5WklrSXaFtewAb6IahKEWOTYyHWZ6NL/DbRGxeZCteI7g1Znrm4MdfKn+5aVHfsj8oGK44RvXV+LxUfsc5ZQtHNUBUm2sa9L50ST56wUFknbRPyhlL8oESbAOeyREUutBf8aMYLJLQo8ttju1PNB81bDKjYjd4rnieEHhujVCaBDVYmLmieaqmqjUpqvST3D3WVO+lidKcKyxA+VV3AjA3pCQiHqHPCVq2CAJcIYF81e3iURHfavI3LaBdmUzs78rOYGeya9dIXK+vx2b2Qje9XSPeETFl6rblk0+peJlqTGJ67Autg9xdatah8XnYKfWNUIP32k7rnrvN0xKRZnBbGfUEk5lLLfBIEAmwba2pL/hGza2zuoP5TpwajT49m8dKISZz5V6ZpcmRCoz3KNN81SM5f3iYJ/O/fCgIbVQoO+biRNYMeUPev+LgYreJRgTP++JfegF/1S8sKdV8C/lCq/KrQ4X5Bk3T02uG5vdy20bp9+rXlWb4AIDWLgjU2atbJj4gKXnhcvwrg/wa5PB2Mj9jXJM5h7CxO8SJdybBHJr3PTV8OblFgd/5hP6JfgR5wuUH3mZw5C5wJbBgpgjsYiggEj52CuOL+DUgAljNQX8URrQfmqL7guNTHvdFYiO7p3bh3fVOG2KhDEo33TW5frS91Kj9mKZt5O99Z+FSWAARPghSeEiUQBiOr/h8zF8EPyO+8QbKyDSj1s6SUznfKljjlxb8EyTegnjYOGxc0gdwKP9HSEexuVtArmCJ77c3stPD8MRG5wF8LKNAcVNAJzUm02knf+wO5D09lveybxSKka1NQAl3R9bk8ksu2YLjlJO5SvdvQBBLRChtNL6quFvXp//PzaGWK9gNNHDydArvFt80AQwZnPe4g+QQL7B03mtIbOtsq//9dw4cbqMd4annYXzcKhRH/JU9QOjn40FHXHz7M0glavmlQgL6Oqnaz
 79WCEAEi
 pT6yqE0v5E5Ur6i7pn/FFuwZNEbYetjVyyhtVAybwYOX0gjv4PUOxpEXNAiIEL7LszdcVz5KMpU9/OSR/EHbx7d+778aZakgAqQ/zyJ+qLO16TkwgrfRlDk73ncOgPHKcgcbWXa+ESMD5bgXeEAx6sEBAmt4gTfJ3tTdt8JKF53aFr2DuLnXrOtVPFpvILpNIdn9FkQVp1pTv+0HbiowwAWYl8nsjaqRELnXegCNydG+pdH+eU1RJiOiVrwAaOLZC/B1gwp3bEdJkQ/VsB6+e09ZV6Wxopmkz3n0LaU5TwBxZztmgOQxInkzOm4f92p8J8AMjfpgktOs8EQ2cj4kuQr9uOszpUjOSy6QvXbEvIxw8vvjUDXy5XtZiLloNOuTjOyQPYAiXKwJhEMTw1LVZfIpvbBojRZkYJbbxRBEplLkce/pgGI17jzzHKLwwlRvTu/G8fSp3ABvMMXXej4YQ4aBTXs8NZR8dGHTZ8pDD8khm2zEYSnGWIxId1hdTQ/3lYyso+gunUlLUTSA3Tw+607oKXeqW8KkzFd6Bw559LlMWaU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding charging and uncharging of a new page_counter
toptier to try_charge_memcg, refactor the code so that it is easier to
distinguish between the memcg v1/v2 cases.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cefe33b5fd285..ec28512de6a23 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2668,18 +2668,22 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
-	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
-	} else {
+
+	if (do_memsw_account() &&
+	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
+		goto reclaim;
 	}
 
+	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+		goto done_restock;
+
+	if (do_memsw_account())
+		page_counter_uncharge(&memcg->memsw, batch);
+	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+
+reclaim:
 	if (batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
-- 
2.53.0-Meta


