Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AAECC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA6C6B0096; Wed, 14 Oct 2026 11:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB846B0098; Wed, 14 Oct 2026 11:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C18C6B0099; Wed, 14 Oct 2026 11:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7009F6B0096
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:28:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FC4E4041A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:28:18 +0000 (UTC)
X-FDA: 85321613076.15.6ECB2C6
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61CD3140008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:28:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d2d6+Q/W";
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791991696;
	b=WY2KT0NAH15UkQKkM9LXQgzQ+1aYK+y3U9ibPxMvTx3QkjIq7BFErHMEYFX+CmZvX8l3SM
	l8qsJcoPp2/b1QTG36bIUD5iTZvzmmJKm3SDzh9X8JTCI2x5ZQ7MUXINlC1NY5nBqM1c+s
	TzgE96kRnNhEExmyEtHNZoMbWiFdVEI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d2d6+Q/W";
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dJYuLJEcfs84KY9PmVVqiI3meMH/2vzqF0uyrJ0GjuE=;
	b=ZkoyFwckGQZjfHntT9997nocJ0gVwu918gsP2xqI3QgI02JOeyw6IJJUggSP0l6ihxD9K7
	JPyZH1Tj8fuRE/ZOOw/I2zfAIkTFPSJMk5ObpJPsOQO4kA1wQc63ryctggWN9LqQjgKMgY
	8IdqJSh7XWpd37QlOBJ87VvCn0Dx6o8=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ccca948203aso1715170a12.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791991695; x=1792596495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dJYuLJEcfs84KY9PmVVqiI3meMH/2vzqF0uyrJ0GjuE=;
        b=d2d6+Q/W1baZBNlB6DFKAOe2p8EsK1QMd65MORUfdHakop+flT5ooqJpscCal+aHSJ
         bLqsrHd5MWBH98qLwr6IFliEYwl+r25RLkET1tKK34zF/SKL9TCDWVGJpEwR938Z8n5Q
         UfG8NDQI42ARCpEsc7dTEqyczP4oQSjsbUvCbKOnEQK7p3b/NKuGUfHN3zkQTf6olEMa
         HacZqPPV+12DqnqaYY0rivCFArWFJeydedInJk4SqRlp8ZRV1weE76faS+zGRslS8QQT
         BDGyPSk8fEBO4Ty3XTdVKs0aPYxraIACvpaXQ+Oq1qY5ggwqtyRRhIG8g+bLKbpCNEk8
         ed7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991695; x=1792596495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dJYuLJEcfs84KY9PmVVqiI3meMH/2vzqF0uyrJ0GjuE=;
        b=d5u2D9a2BFy7IBVDylV8vGmf5By2JVfbVM1bxTNTJNN/qjRJmkBsW5PMgvcX1f2Rf2
         kigeQ/dgNH8TH6KsWkpAn6G4i0M+Oov1mwpGfNA4Flf606I6grrgNgroMUkmON/3/iq7
         EQu2fZIk69y+UzCKiZeRi7/eLQmhB5g28BySlSasAby5uenIE04jt6Llaq9dNQRkZw1h
         UHC2LjuVD0dDAv0NO4o0X0D3zScfY+x4cYO9TRB6r+uJSvnqQpQo2NevT7gDTMBmI7Ox
         kWJ+xNjY12Q6gddjmGTchL5ynOU1eqjQsP0deoaifK1CuRQleQBsWC/jFROBKLU5ciZn
         8nVA==
X-Gm-Message-State: AFq9FYKWdBPObQ0tlbMJWaHC7XmziEkfnZI+Z7wJ12QIZzKr5cia3Pe8
	tkydmrQVl4SOLetVzTOM57+e6eLUuN1qOIJ7AQhib/CT7K+xF33UbaJL4sGSZA==
X-Gm-Gg: AYBFou1ZUa0rjepWBPndEbJHl3eA/a9NMcq/g3lZKlntwzCjGgBB3UbosX99nIHJTGT
	F0msLnyrvZu2m78ON4k9bgX8sZdLOJfA1ZBKqphEKFj509FfK0r7IYnGYi4bKNG7hp8KmVWtnpG
	o0h6HI3f92vg4VUq3vXHuxi8g9rHyVRhg9qdMabyH5tTA4IQaylwMCqR1SNUOmU6Bqw2Ixqir1E
	dxfu6eT0IQISOl8fseb5SxYBZ5iow4S55SlH4rckezTi5KzMg0y6VQ9uTnzafAxfdEQ0LPjXSkv
	ijdRBdbeqZF1gJNLGbubtgr8H7e4YhkntFEUCHKgyZICCp8KYMUToP3Fq0xSrjh0gTD5bEihNhQ
	cG2eVXSNivzmhu9yDaNc708Bg7Im8WylHAaIkqp0Cj1mL/aGuFSi5LyG5txuZhjwBk/pFwXzmed
	L9S9MuVmZ/93OgACx3myMa0IFBiDw33niPe8cPCmp+uurwmtHMqrESXtI/PddUoLVXeKwDiFaxB
	8lM9v/QIoGgqR7srorkIKs2VjAYdHfwcPZB
X-Received: by 2002:a05:6a20:a10a:b0:3de:3f4d:f2e8 with SMTP id adf61e73a8af0-3e16be0520bmr13151970637.25.1791991694919;
        Wed, 14 Oct 2026 08:28:14 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e3dafesm6874910a12.20.2026.10.14.08.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:28:14 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] arch_numa: remove setup_node_data()
Date: Thu, 15 Oct 2026 00:28:01 +0900
Message-ID: <20261014152803.740376-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61CD3140008
X-Rspam-User: 
X-Stat-Signature: n1mmu7bzf5u5yk3z5w5bmurtu6y8cdb3
X-HE-Tag: 1791991696-677495
X-HE-Meta: U2FsdGVkX18yH2vQ+jglUoPKbiLf92x2vhKmdO+xbmR/7Wk4svIe72o3+kpsHKsjGVYY9rU4hhl4uODUH6OnuZP5uFxCzUBTGf9teOHWJCTKkqtdFuVH/3Nd+c4wJvVWenlLjRTTdIZLRbA2/vDP7OuE30s2e/ALYDPAVV5Yve5aMrwyRUeBrBaFg7xqkkCKJ6aDJ8T++Oo9qINc//CEQMsa9uFTSUfYHwOp6g+fQZ+EQe/HbdisjRfZxV7kRODEHu/REj4ozP5V9gOuXS6CWFiWLsaQK0lfmGoCwwVbgKq7bHjxOC4a4pBXNKL6TUKwJ68HKRwc3RWOE1iwemzmaTxd58osgMpzjs5jR0IJlM32k5BOGZF0X+Evz9Aa0PxBBEL5eTrZqFniN21ksZKkMo5zBFtS/7+EbXLomeKM9sslhKGTPLwD4G/sJcgAUovCsGknQ5/FZYq/PBhv7MeUhzV5o3mIQL388VSyaxK/qjAPL6ycDpQzfyxASjZzA0ed8UuZeLLO8N7atMXsYN9sFVbknHKtRIyFACRXvlr9EswvY9ga5Y7GzUmOpigDyGhOTKIrWX02JCfwR+/wrIiiSxZHwEPNRb8AfGrL1i5WGYThSqW+ov5KgvsNSNJXCSoiXmIw2YepDPJ1BltFGeuib10pOC+yCRlRExT6AkYmOnCYPq7toBGYLIgRdZ9dNXf0atQsYAzYuslXoFhlTl+RosPp8kuV0NTWjQqjxgxwZwtg0Ug+a/S+2x4Zd40Mjajfr8KibFaLZb8bqexcPyj0KhcoLZcxp4ono4HyRJfQuQw6zj5gP+xO8m9CsTjBnTNaY7an2Jd53vTgDMaDpGuE0itMEwI6GKOR9Y6fXqO84ekcf76BrtkFBKvZEiEpfo5sTD85Pn+/EIE4CljTxqXnjkvDcAFcEAL2ox27KuLtq/Zk6QXbb5kAbJMo/ogZLis2bfnDnXOi04HInCsbZlX
 e0jOuGG3
 TE2f//myeybxJjYJ+3Je3QczW7rZ6SEG9JINMbXBQwD4FJkvBZ3klOVZerZU3ZE9T+yUf0rsepa5ZXZyka19U+uDV9pE7DOvh1cKC5xFaPPG9A/IIRnJF+mbxbGxUUuX120REEV+Vm7GLAIB2pG9SrBEuXx42W8lI2asXrosgzwOChq1Bk+8BFeIFmIxGAfraaFbz3MQjVNrXebgClxTK4xW7H6CA1Uvz/rDUxFeflZRP2c1pOySZAhR+UrTgqhVgYLfzpEZX9uDuSnTGxpDFegEkuzd3YR1VBi/cCdRKaHwK0YA4Lj1cp+HadH48qj5JnfbKPQE6AB7XVqSRVmM437GB7b4X/9Z7cCdjQxuMCzUAL2aSI9XHuFaLdkIGHlf+ZY6dDwvzO2a8pd3UYpItpxtGgqOyZUJ2aOH9k8Wz6rEa2sZoe8Ul4RRW9h4xFGabQj9KvOhlRUZL6q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_node_data() sets node_id, node_start_pfn and node_spanned_pages
of the node data it allocates. free_area_init_node() sets these fields
again in mm_core_init_early(), and nothing reads them in between.

So remove setup_node_data() and call alloc_node_data() directly. Also
remove the log for memoryless nodes, because free_area_init_node()
prints the same information.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/arch_numa.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/arch_numa.c b/mm/arch_numa.c
index a4b1732274fa..c88a323a34fd 100644
--- a/mm/arch_numa.c
+++ b/mm/arch_numa.c
@@ -201,21 +201,6 @@ void __init setup_per_cpu_areas(void)
 }
 #endif
 
-/*
- * Initialize NODE_DATA for a node on the local memory
- */
-static void __init setup_node_data(int nid, u64 start_pfn, u64 end_pfn)
-{
-	if (start_pfn >= end_pfn)
-		pr_info("Initmem setup node %d [<memory-less node>]\n", nid);
-
-	alloc_node_data(nid);
-
-	NODE_DATA(nid)->node_id = nid;
-	NODE_DATA(nid)->node_start_pfn = start_pfn;
-	NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
-}
-
 static int __init numa_register_nodes(void)
 {
 	int nid;
@@ -226,10 +211,7 @@ static int __init numa_register_nodes(void)
 
 	/* Finally register nodes. */
 	for_each_node_mask(nid, numa_nodes_parsed) {
-		unsigned long start_pfn, end_pfn;
-
-		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-		setup_node_data(nid, start_pfn, end_pfn);
+		alloc_node_data(nid);
 		node_set_online(nid);
 	}
 
-- 
2.43.0


