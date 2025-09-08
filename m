Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9025FCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42C08E0008; Mon,  8 Sep 2025 03:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3838E0001; Mon,  8 Sep 2025 03:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09668E0008; Mon,  8 Sep 2025 03:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB15B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:19:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 398751409DE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:19:34 +0000 (UTC)
X-FDA: 83865232668.25.398F731
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4823A100010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:19:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAHEyySx;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757315972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IwgxsMq1tgAp2VqFUxjhXW3Xhestgip8zAuXd8bb+3Y=;
	b=HLaHjSP8PYbLgYpf35fIuuV4dfece0jGfWnf34TFcxILkpZESeqU8Pr59Tr+60yNIkH1Iz
	d14PBKRf/1XywKMO2gFWDXw8MXEIp9JhtMgMLMZ2AoxIBOdqoJZMRRyMPiJWdpRRxowTki
	8LOHBc6KWqAnSNeLFOE++z25X+1E6HE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAHEyySx;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757315972; a=rsa-sha256;
	cv=none;
	b=y6uTjH4G6TyExme1O5F4eeqPi6Oz68B/4Q1e1V6cAEKBpT+Bjy0jxy2/AXcWiTM05TS/z1
	nASBdZAtbzkT4/nDrO8X8i6oCRmwRfM7tOsmy/ooRTNKXi7BVvSmld6iAf/xYh/tBrFG/7
	JnaJ9yegq/FyMMeMoXB2XNizSxFkefo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757315970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IwgxsMq1tgAp2VqFUxjhXW3Xhestgip8zAuXd8bb+3Y=;
	b=LAHEyySxMm2ColIe8xcvSzTEEKu5SetMoSnM2MtL8t2YpBW3s8JKoMwmSDbH9y6U5WdrTk
	+cdcaSuL73nHXBydrN2Y1LTPEiwxyPVmkqqlXs/bJkmAluCWfHAaO6Sv+2sysohu9T1HQ8
	55qPXAM6bBYuHR4o4WcbKHmsUOOBF40=
From: Ye Liu <ye.liu@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slub: Refactor note_cmpxchg_failure for better readability
Date: Mon,  8 Sep 2025 15:19:21 +0800
Message-ID: <20250908071922.1062170-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8ihq9766zgsznjnbwsb56mqbtm37prp8
X-Rspam-User: 
X-Rspamd-Queue-Id: 4823A100010
X-Rspamd-Server: rspam01
X-HE-Tag: 1757315972-818887
X-HE-Meta: U2FsdGVkX1/jriS7VvcakPTGCJxep6v9XEnhV3tjok9kkh9rndF7fFhZk8Q1R4vZVSNC/9RMq5z+/cQiJ1oAS6dUGLAkwZ/miiMd2mO9YhEtWKJjdXZ8Vkeg4GslG2gf14AVg6kQW7aWekCPPw6pAg+mXlJbmRYRpRhobZaanWKrWQp5NzBpQdGjhFGZ6l310SP3xQS73G8ZmMhu9lFJFNukdtAj8AQNqIN/b47xfrkhqC6vB7/ZiaGHqTa3BxL4q+z/o2qFnQmgD8FZYA5yjrYE8hFyZeSTE5bfhfAc2r1cEuwnx7ff48xOQzE8uuLpERbasITuZ2GSpzm+cykYqveRHnyYs2AIpZREnx6TrZJ10p/C9NFshuiZlyO3ee7wTuNcOk4Pttfg4RHniirTAy8P3yUdus9l9Q3ffaXq2kt5ctynq3Xr8z56KjdEB1ADGuGGyw8xs0/t6bmiTzLodszBST1R1G2RtmcId2uAdaNC+mP2IaYnUIhYIeaLKrKk0hLSvHoI8IIVMtNu3bhidT6s2OxEb/BjUgv7NoOo0u8cE4JTRt7Or+sQug83YQXgtYyD9XJ8fJwfKrKhS5joGAf2Sce4E3GL8YLJ1lCzhQENKq9FSRkP5Gc3auLG2M9hcT6A9GtIujP4iI9i9r52UOn3vO++cQFZocoDNLsrB6usHGHEUR+oHrSCC30h+Gwy4ewMDBauCHwFXMreXpBUctb8tV507SNjBCAPmM3nUEbJGR6822jz2RQK47pX1kd2u02Iid6KApiCMF8iWqXHc/GXheSGtHl/1nZ109+5GH5DdOqIw7RoBWloEie0sb9zE9NbaHJlB+O0WEefexJTbCmyHlvzeQtX96MGGG5gPViW55NkLcPaUHDZdPEcpnyh7PRnvcrDqp5w0GKHtMmv4ifuGJTupCon65DnpqgMFppMeAUT7N5zmN2Bpfq3ZB8L5aRtp2PKIOUo/drt3rf
 lG3M1/ZO
 6pP99sbSHJY67ln/nIntBOfhRUPIJJvW1WA5rtvObJLiMLJGZvp1LnCEKkuWbx0YkIFp4Vmvt+Yy09luJ5xtZ1YECJTxlu7RFmbjyw7ZhxWabA3oBQONzasq6ZJCnc4Lv4YFGI2WdgZJh1CufSP0P8U3bdJcOBcFNpZFR2q1UVzX2aVoKAlUc/gXlwHaiZ0S2V64U7AyOIalDStGxeVvDwQUXZKMC1qidh87N9NVaLHT30pCjr6f9am+aRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use IS_ENABLED() and standard if-else to make the code clearer.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/slub.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..34853c0441a6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3064,18 +3064,16 @@ static inline void note_cmpxchg_failure(const char *n,
 
 	pr_info("%s %s: cmpxchg redo ", n, s->name);
 
-#ifdef CONFIG_PREEMPTION
-	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
+	if (IS_ENABLED(CONFIG_PREEMPTION) && tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
 		pr_warn("due to cpu change %d -> %d\n",
 			tid_to_cpu(tid), tid_to_cpu(actual_tid));
-	else
-#endif
-	if (tid_to_event(tid) != tid_to_event(actual_tid))
+	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
 		pr_warn("due to cpu running other code. Event %ld->%ld\n",
 			tid_to_event(tid), tid_to_event(actual_tid));
-	else
+	} else {
 		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
 			actual_tid, tid, next_tid(tid));
+	}
 #endif
 	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
 }
-- 
2.43.0


