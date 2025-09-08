Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDA8CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F568E0007; Mon,  8 Sep 2025 05:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFBE8E0001; Mon,  8 Sep 2025 05:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C7D8E0007; Mon,  8 Sep 2025 05:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20B0A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:43:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB5E813C05D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:43:02 +0000 (UTC)
X-FDA: 83865594204.09.8077E2D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf01.hostedemail.com (Postfix) with ESMTP id 21CDF40007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:43:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OXaAfLhA;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757324581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g8brv8Bfza3R1KuSBek60li89MoffBE0eSq7KMm0i8w=;
	b=cJdSO1waWPutpEXAJiQcdnp1LLmO91/2xrxdF/c8qA1d3gIlRfciajugaxtGhvaWi7tIme
	CfDBM6fTHRi2cBS8MEzDhJ8zWLYjIYQGnXhCC4ACsMiayKcjRUQH8bRp2qB9Kqh9zfMMZ+
	qMmgMM6Hdhkh1xakXIgtwGQltTWPH3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OXaAfLhA;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757324581; a=rsa-sha256;
	cv=none;
	b=7G5onWpjcv+p6KVsjmozM7yVaVV40PEoH2JzeMBdvrSSCT17QXIfdkJ2dy5ZU100Esw5J3
	ppayfWGQpfB/RRAEwDMMUJu6lDII/TIXv/ZlbCazDB61RevkwBsf5RllHXn+AjDbXgiZOw
	fkj4XrIUDR/QnfyFnNpDVH8Fk/fQVww=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757324578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g8brv8Bfza3R1KuSBek60li89MoffBE0eSq7KMm0i8w=;
	b=OXaAfLhAiiYm9lTf6d+u5S8yKXqSBlH3/3z0i/pqxpv9iH7ZjPDYKrdm7FtU3p6gIAptQU
	1X6oIBdxLjYh30HhIKwP8pO4pO7/JPCrfCHDCMlWtgZjOIWTE4nuG1FrIxO8dd/vWiQgcE
	8PlXmTnE4NUNXLqDIzFCEBaJcqyEayM=
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
Subject: [PATCH v2] mm/slub: Refactor note_cmpxchg_failure for better readability
Date: Mon,  8 Sep 2025 17:42:51 +0800
Message-ID: <20250908094251.1080646-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 21CDF40007
X-Rspam-User: 
X-Stat-Signature: z4b7cbokzhtrjwex3awsoddwmt1et7ib
X-Rspamd-Server: rspam09
X-HE-Tag: 1757324580-130003
X-HE-Meta: U2FsdGVkX19tW8Ge9Z5buuWKMfect0uFnVzyu/lfxYppgEIksBIicCiPLZLbfJ2X/B+fXZWNWJ7nCi8mqp8MJRwBJh2Y7j+cNJJry4FTtChCO2f7xdwkGJjjeXIXDltQCCXbBlQai16kdLsOzdUUjsuG2ItvOZhSCpAXn2Z1hDwxrOaKP9OK7ojAShM/gxYEnwJeiIWAp17UAJkzsEjO0CaBdnTaYyQdj18ySLt8039rz+fQ7pCyz+rRWnHuWSW0Bsf/1/XL3sIx92BxFNw/ORf7huQwxC2miLxYOcWfN06DqgThlaLSFHoJCwBQw8jFkw4ccUWu8bQPtdUkfKxxEhoC1JhTKiSKNSSF4qVGTwFkfixl/jU/b9yIv/XxQ/aZ+GEv1X1CKz8fGG7rKV8kguzrN9Ft9n13IfoyKMMEFMZMFN+jj91cFD0aQoPYB68q99qVe4cnH3YDq8CcDawuAv7L8lTJ5gVeIZhTbj366zcbi0jNhcC2cGEHlHdibtS37uSZnkJqJreyLcKaYH5zxf5N1JIKYP0QOR8QHmd/Ae0EJb9DPsNKfdA/Hs+wIASuQXICmrQrxwSveeVIUJ/A2DCad2quiR3kQqXlINr6z7MlwRHHP1grRWZFYWgopP1MS2RlBUHiPfnONX01FETEZkhzp6BnE6ThOi9OIabUopR/iouZUMcPv8lx1REfZdTz0Lhjw9tTii1FdGtIj+Ur9FlJ7MAIZVTY0sorLPNDCCx5WQN1VBmMwWbhprDiFUSIfwHpfBJxP3SAlNoCJ0kMD1a4Zs8FVX69C2dFY8/iKnP7I59TFmTYTNzGBiuKDHHqBue10JUTDFUqoCrXwm+OHlOhdJEBVNRYn3etnhIrH+rszoi21c6Fyh2igJv/Spe6CX6JaoIf8E0oxoTaMJ8h4JljNEPJgNn7c6oFdRSOPTArk8Q6k/GvFzFdQ/S34Q6Qgs2gfcvREJ29smzL8OQ
 Oj7HrSoR
 2L4mrs/S9TH8IqL6R/qDtd8CVy1wlYJ6C6RjaJ0tkEWscAN5SX2c8XNjS+Ou07qH4JNNrUbopR0mY9nORZ0p5A9n+tcS36b4guBGpiYNwHLxzKFxn6Sq6grxu14LthjPa4wgE/wqeoCMqNdIN5OpA9tHngWvBCbAEmnt3mEa5HqzP2rVqWYVAWejtBbOAINqviK8ZGWcK2/23GUA=
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

Changes in v2:
- Insert newline after && as it's more than 80 columns.
---
 mm/slub.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..5711d6d29a3f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3064,18 +3064,17 @@ static inline void note_cmpxchg_failure(const char *n,
 
 	pr_info("%s %s: cmpxchg redo ", n, s->name);
 
-#ifdef CONFIG_PREEMPTION
-	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
+	if (IS_ENABLED(CONFIG_PREEMPTION) &&
+	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
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


