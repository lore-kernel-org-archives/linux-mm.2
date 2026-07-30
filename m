Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C81C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E446B0096; Thu, 30 Jul 2026 10:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEC46B00A5; Thu, 30 Jul 2026 10:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BC86B00AF; Thu, 30 Jul 2026 10:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0949A6B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:32:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CD34401CB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:58 +0000 (UTC)
X-FDA: 85045684836.29.3D51D03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1F71120014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQuIWHR+;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/rPOa6qb2Hl55Jp7oWeuPKM83u1LEmbFcYHQoUGj5W4=;
	b=nThWy2VJqCidamSo0X6+RDPnYaKBQaSAlfZdLWFGV/rtoK7pgLcx0vw4Fa7KT9ScAQW9sY
	xzfe2FQhxcxpCjlcFycdL1VO66mDyvU6Jw4GXtb+oS87t7Ychvmv8UoI5nj/pN9RJ+KA0v
	Thy3lk0nPZVPEpB7Jxd+9UAWFUUG7Os=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421977;
	b=MTLEUljtN5rFLHGGGM7MNL7LR0mRVIpt/ziqbgRCYfvICopg2LTvdf8l1WxIsYDUQfLbuz
	CdprTMJQrVjiL9KKe7dLcGr3GHaaGcAigGOtIL/NWMQzkALAzndrXE51hjSHA2ZThtJnmJ
	6Zl98S8vNNPqEdl3Z/2KH9/jB3ztQMI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQuIWHR+;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 248EE413B8;
	Thu, 30 Jul 2026 14:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DE01F00A3A;
	Thu, 30 Jul 2026 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785421976;
	bh=/rPOa6qb2Hl55Jp7oWeuPKM83u1LEmbFcYHQoUGj5W4=;
	h=From:Date:Subject:To:Cc;
	b=hQuIWHR+h9t8EgXjRvXqbFdLLIHthBMA2GC+giXqn7dz67m89ccTw7W6miHiPXDK6
	 yBFuh+5r6HwpJ/u0MWXD9mwh/yaD2k6upDJzslw7FkHB6Oni5bzSMez2686W/MpG+n
	 jtUAoieXaDsrk44GKFJh+nsT0n0K2n9VIC1ckPjJWikim9H3BqwWQ3LKyl20nZFZGR
	 VrySXmlnwJaA9I+NP5lbf7nOqO+iSSiyThiaqM+gvQvSzdcbu8UVKDgNC8U0zVsMC6
	 gWI0ZQOTV3nY56shMkvY4/lWxycP1//RP+I+ztN7NUHB3sha+LQL6gIQSs44jPpVox
	 yHTVoDJ4iaZfQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 30 Jul 2026 16:32:46 +0200
Subject: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAI1ga2oC/yXMQQ5AMBBA0avIrDUpFVJXEQtlyliUzCAScXfF8
 i3+v0CQCQXq5ALGg4SWEJGlCfRTF0ZUNERDrvNSV0arPeC5Lrwp13EsWVRhrDO+tL6yGcRuZfR
 0fs+m/S27m7Hf3hHc9wMGbLXsdQAAAA==
X-Change-ID: 20260730-unexport-barriers-439b3f69f791
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1F71120014
X-Stat-Signature: azj9tfw838tynmi7qa5mh71dfe8f6ego
X-Rspam-User: 
X-HE-Tag: 1785421976-937285
X-HE-Meta: U2FsdGVkX18fszpMyarH05iTq1ZqUXBiBA/nmbVY90+uBpCN0hxchAkfPbh29hq4jXiHjOhEJQRJuDCxBhi+pAsQe5z7qdYj8zWqHJV+79t5/4NOPS9hJ15TeB0HwK1qkxW2h2vL/bvanBW+xG8oEXptvx2BMEN6jnSjcMLKjUmukUcdX2ysZXFI1kglpaEniaqAqc2LFZk8JfNtpMTjp8GLugct6FiKoUG3XgZq3a4dvvYoX6SzPpdSqhINR4gu09RAatxFKDKmkLlaUce302a4q7xqlKKoVrJpM1vQves/IY+32K8xLAD6NaPkygDBT7WNQBYC/Dz8PNvHjovnxKiA8OOEHyKS4tsRVVTItOfRK/THv1nDKBAVooegRIWN07PYXkM2t2cI+MUIddT866BuUCEoNFnJvDi1erUXrsHpNC+VJSPvpGcdmlUkmw5I6Y49zPlPPp0+5M8ufj3yfR9ghk1Izx8F6Padzngjj7o1TOxTrF+295TqU9L71WY7v0nIK7L2A6n8wRjw5cAPj2ycX+1XU2IfxgizJTQw8OnsiePQma9WS/iCq9mlgGSRK9Wyta8bHUjDIOtZhkL+/DXUPCkBPPkwSWe8kcXuaejB883pO6l+xL92pCmzIiTXZp+81BhEbBq734L1HvPwyLY4rGn7Lie9n6fIQ2D2AO45L3Qfw3PDueGjcp3XjpVWl2PoNIF57Xr/ro2eLR5PzqsN7FtByg2oPBMtRO+h46z7XlGQhF0BfCxOkZUIi1h4a8Ns+kTQf5hcTFbEM+sPD7hwYUKrx1wAVwjekpOv9A2BvXAVpTSFSyDppQjG0JRZaKUjGRAtJozwuvNZEBRjA0Jz/fN6HTNwfxgp/g9QGtwlPFiOpnRLwh2XgFzgK4o/edN1IsBlOyun+qyvPimdOm/gWXOyoqIy9/N+OBDAczYCyloF9s0VU2CC6lBKouKY/22T59YFLWFI9BLNGc3
 x59UCAMQ
 ogPqTXe6a2R9+yfAyo+Maj23hkje++iU5xMV8d5HMrR3fO9QVcwxNHuo5G1GMN5SsBqVnrlhbQBWSLPwigFQIBN/rkUsZ5YI5e7tS8D3AZ4gLruwTN8n9pFNqW0e/KGBVRntamqTo4kNEiNqe4iXkQQhmh4wljHiEs/tOue8RV3EB+8j9YNB57BSyBPnBC7XHbAW/+ZI6F4rO3YInc1LKZN7WNYei104AvlK07nM1KXrhAITOM4dxioF3WJjYiuzuecOQO5Jv3Z2dZvFONOZmyCQ6XLnzM2qRrygt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No module code calls these functions directly. Seems it was always the
case. Remove the exports.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Based on slab/for-7.3/kfree_rcu_nolock
---
 mm/slab_common.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 6750dfa27367..cd155ffc2762 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1329,14 +1329,12 @@ void kvfree_rcu_barrier(void)
 	deferred_work_barrier();
 	rcu_barrier();
 }
-EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
 	deferred_work_barrier();
 	rcu_barrier();
 }
-EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
 
 void __init kvfree_rcu_init(void)
 {
@@ -2163,7 +2161,6 @@ void kvfree_rcu_barrier(void)
 	flush_all_rcu_sheaves();
 	__kvfree_rcu_barrier();
 }
-EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 
 /**
  * kvfree_rcu_barrier_on_cache - Wait for in-flight kvfree_rcu() calls on a
@@ -2186,7 +2183,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 	rcu_barrier();
 	__kvfree_rcu_barrier();
 }
-EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
 
 static unsigned long
 kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)

---
base-commit: b01f6ed9ff0c4581fc669044fa5b82a93b4ef144
change-id: 20260730-unexport-barriers-439b3f69f791


