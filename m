Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFBE606A68D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gH3wcqhx
Received: by kanga.kvack.org (Postfix)
	id 31A396B0ABD; Wed, 25 Nov 2026 16:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A51F6B0ABF; Wed, 25 Nov 2026 16:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194456B0AC0; Wed, 25 Nov 2026 16:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E52046B0ABD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:27:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62B22160126
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:35 +0000 (UTC)
X-FDA: 85474928070.22.C9D5ABD
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94BAF100009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gH3wcqhx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642053;
	b=CBaVRa9847QxzMKZZuab/FC6GS75A/Hqzr/vNF+Pcw+D3Qgroerl7HBlrQ8zPz+vykERfv
	gNksoApNkpjBR2BhN2idl851A+l0YpwdxhyFrlp6gjzASZ22PEdDu8Tqh78qpzuf9c29xy
	pAtFSEh733+ThSXy+hvQMgmSFxrBkvg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P54xZ632a0goSgApFUqzFeM5XwZ1Z2Khd/S+FCqrXvo=;
	b=eg60oWP0ZFh/VS4Q7tF0f5xZieA1YBLdHPIIKXCDCS5fCBRFWFMtC5E9BC366CiIkNl7n1
	rHG7c454MWJz/MXmgDMu/Qob2q117YINnSRUSKgxlJkDQZB4nnsKsvu7WOWU99vhYPN0vD
	k+toKQhKiHk+tJUxwB71SoCFFt/gpdI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gH3wcqhx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-86103aaac12so3955864a34.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642052; x=1796246852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P54xZ632a0goSgApFUqzFeM5XwZ1Z2Khd/S+FCqrXvo=;
        b=gH3wcqhxFixj6Gv0A5xW/DKyEBhrdjgJnBMk9Y1+88QbeAx332GrHjViLKuRmZFXN1
         cS9Rih4kih3DoWe/GI1Uts/70byQm6o/RodTdKd18QebRCDIO2upizldWrhdserNv9eO
         u7J6dxAI3zy4bGS+O3ZK6I7KFN0fO3tAVRjnqkmdfDIH1fTs7sqbUaiYTOiooZaxeb9R
         mz0TqiLpTBTq9gEVXxmWbyTFuchyikneBvM74h89Sbmbnieu3WmBX8D0M5xRwPcI+IyG
         95eiYwdzJUwkPK2YdJLIulqVtFoqXR0Z9ML67AJAwGe5BhNSbBA5lwsJtdnAG23chtBS
         Y04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642052; x=1796246852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P54xZ632a0goSgApFUqzFeM5XwZ1Z2Khd/S+FCqrXvo=;
        b=iyFhoFro+XsdsCwnjVqbe9nDVuL3t/Nt3HwAkx9/TVfVzCfkZpH4vl6852Sd+kqW2F
         G0ZbGaBfEPtnddIJm6ZQ4NZrpB9b35pZZZo59qRE5bm8uDL00NHbYdg7LS+O/ImuuzIN
         fdIJS588qgmTDKktg5FZNQoJYnxIKGG4SdX41FhJpOHA+N7J3BGKV7aknL3tsBDr8glN
         r3AvIr2ZaGEdri+v+35IkpEXDb51Nq5788CgQGNTquuoUDIz3nhe7WTcv1r/EwIgVNTL
         jkHsTXKNHn7GKn1MFN0J+rp4J7h3ihf65GUrrwkh7BwkkjCBSLqgByBc/8YqDGA2GGCn
         wwbg==
X-Forwarded-Encrypted: i=1; AL+hErFHa8rECo0OpQPKYogMALWsGvsa3JKtOxlt+PDioH/q2E+/Sb5QPjvJm+GePd+BEgLELoUh516MfQ==@kvack.org
X-Gm-Message-State: APuU4Z+brpeIDfe0MuZcWDebWb/4zT2SVPfVd0E4Hr8gp6cbwGUmyFTs
	QkSxENuga8841qaZ6x1Q98s+NcMkK0ucgB0v5J4a5J20+d+fd3SlQIrU
X-Gm-Gg: AZFdTZcaMRHJtW4gchpjRob3WL3S+JfQd3uPSRPbTVXpHUuzeOjjtN9Xq9LmyMzn7oP
	ftmsPxR1zdtHgfnzzPj7v25Lg+or7rPNVGkQ18tt3zLJhWrx1Hj68vxoS8B44EvTqiQYbC+eark
	fdn6Un4MIZAXCyNvkRg3FhlqGSApKhgt1rsk7jfm8bG7Pen0aNxxocubTnriLI/G83esI9rlXv+
	mIlGklSz1/ZCE2F1OpCMv2N3Wug7mdvmYpMYTFcTotYzVfB0x4NWhoeLALNlyHoYpHeu6cWrg4t
	UrsL/W52+wtO77yCCxsPCMCeYbyyjG9kvD8ruGcfNsNB0FyVN3QMr0WdmQf6woWgyaqn94e+BPR
	Q90gsdMU8ibXO3bWGlrBiajI5hh3OyG6Air2CkCtHqhCvrJXMPU4qoqM5ALQ4DLV6IAAct/jP6r
	40pCt99JrkZH528OBC8w+Br5hItYAOuUC383akzGp5//JyD/Qft+FnC41TgNP/IcVYGDnLUtOls
	6uQEE4UpDBmUNtXdn+DdASHCSxC0JApVxLvQ5uwnqXIa5fPGluX7scWdbWsMRW/4FEpvxgATEKB
	WJfCP32ttcVP7oW9BT9wKDlC66K5Wm+eSwmlXTRQUGYgLD4dt+NkzL4XH2o=
X-Received: by 2002:a05:6830:82ee:b0:862:c9e7:2d9e with SMTP id 46e09a7af769-86309065b65mr14818259a34.2.1795642052609;
        Wed, 25 Nov 2026 13:27:32 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-86316910337sm13375770a34.23.2026.11.25.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:27:32 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 1/3] mm/page_alloc: drop the pcp lock before enabling IRQs after a drain
Date: Wed, 25 Nov 2026 13:27:25 -0800
Message-ID: <20261125212730.1128631-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
References: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94BAF100009
X-Stat-Signature: m4g48b89heanpwymcqpuhn1pmwqexp5w
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795642053-732094
X-HE-Meta: U2FsdGVkX18XLK6RDGFzITnrQGFywqQLfVd2j8ctBDRW021nVhIa2ulBVCNPXTcVtkcOd5tcUafNY4E/rNdjmfX/ZnYc3leDC4n5bG6672gj6JfRRns5YhUo2A9Z3eJcm33zeFhRLgf9MNuTc4XudZdUi1AGejJ+Mn+O2sxgjbR2HTJDfyGDHH+PqMh8YjtBh2p1fgfVLAXpPqzu+J7P9PtSzbrb+MtgLs38CvhM3PaNCTI10kMn7oUFAvt+BbZez7nqy4ym0PMXytqoBXZ9sv3YJKn7clNwZMZ+gpn2MkQ5L/qcemd+gTB65wo+/ibqIy3/B4kfokhTUfvVTEFAtcMH7T6RTo80xay2A7OvSsTGGLfFsQ7lY7qhGGtIIvyR7aNeMdsZhYS0wjeIk/KxEeNktUIByK07xf7+erTcLk9LRITikD1bIYW6t70TLPhEiWa3oEMa/V4mgT08W9ki+RH4OA+S2EbEDQYD3PQyNTffTYTtS7dlK6Gu820qLe5TbboKXxL97rgDHa4VTXzhQHAoHXjtbSNhuoLTvba6D1igHuzYMWBJMgzd2Wpc6EXioTgMff2KR84QgtEpqsiIWT2FJPBAKXTwurgPq/mkQBw0+rhv2iq6oVKPY8YPdJyKX7T0nVA9FuVX8I1PF6sHv9XygddFh/WhvqmQOl9S+g9StIBmyRUos+wYvIGHMptDFkQoq8mXUcaIOSQSI9LIRx9hf/Py73TOyrwEtUcLR/uj74rzgMVRg0rB//aB8epW/iBCmSov4LmqdQpOAhtZxut180tj3+JS9PJzn3JsZ21iKc7hITKNFUTW2n+lHRr3xPxEBLirfv13Ezj7rnN9On4kxfw9Kf38uaKIKeIw52f+x0U/PWi6fB6e2xVqYAirANFpXYrVcD039eXmtWKS/CELQaU2vIxCoUQsYB3J5EnXAYX4X3de0APNNdiJdrdCLioyN4oboVFK4UBxnQH
 9XDmnI3b
 UjLQDAhsvNVs9wT1UbKz4E3DED2Kl6H2MR0EdcVMz1MfxutPhmA3sNDnFOpEFFaq0nbEXRysK66B8PS/8K1oV6CEi2K2ezRAjdjjcap4Cok9fWbhUEnaAQoXEF7IPDQsfQTVilRQFnwwoub2JYDu5d0h0cAf9kvnfHnzMeIxMb90XHGWj93YmDE7WtvbqHWcjiLmvNGfpQRjEPxjB6F3a/y53uow+v9sY0eqBT7V7fy1F1MR/LDNMq85BRtjAftQhlGop3BTCCddCzYyOv4ewmpSjAEhWpBsFZEzexikvhUckNyO01DCoD9mAbQ7LMGpNFunOczFmk0lum0OLvan92loicCeSJOaZMfUSctk7y8VbrYuR2NC45OrIsbuVBLwScZsQ/k1vml1hwfS51OhU+qwSW1DFfKf09rDUP/5WpdIwE1YqmWG1lh2RKzlJtN6+VNyRnqvSpwKz4rtWu8buH1CnkiPwxUG5n9306X9vlV+rMdt4TOl/R58T+IDo0RfE50ehMX89L+j4WzwUMtR2albm2HbzRv6zXI22KFmXJgwF7g4izgYZMikwNmgCo3dsu2p1pOius9fqAiZKK/C4wHGWvx5IQiyRyOCQQSTnsnDxXxAorU7dP8xKVl6PywM4XQ7DviaW4g3odDlj8oDc86S1/rryZpgYhrpUJfZCIOAwwh+8/JqCjM0Nnx779FK0Iv9iRurKHlwQyGLsptaGk7nTEs6FOgUt7paF8mbPwvKRkw6OhoxPWYIehzZ6DWRvc8lvk+SmxFJ06mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 574907741599 ("mm/page_alloc: leave IRQs enabled for per-cpu page
allocations") stopped disabling IRQs under the pcp lock. A softirq that
interrupts the holder always fails pcp_spin_trylock() and falls back to
taking zone->lock for each page, since the pcp lock is still held by the
interrupted process.

This is common when zone->lock is contended. free_pcppages_bulk() spins
on it with IRQs disabled, so an interrupt is often pending when it
unlocks, and happens with the pcp lock still held.

Restore IRQs only after dropping the pcp lock, and return with the pcp
unlocked. PREEMPT_RT keeps IRQs enabled.

With zone->lock contended in a 128-vCPU guest, tlb_remove_table_rcu()
callbacks hitting the fallback went from 93% to 7%, and the average
callback duration dropped from 14ms to 1.5ms. Throughput was unchanged.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aa1ed599c7c6b..bc272f8d8ec75 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -141,6 +141,18 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 	pcpu_task_unpin();						\
 })
 
+/*
+ * Like pcp_spin_unlock(), for callers that disabled IRQs (except on PREEMPT_RT)
+ * before taking zone->lock. An interrupt that arrives in between runs only once
+ * the pcp lock is dropped, so its softirqs can use the pcp lists. Disable IRQs
+ * after taking the pcp lock as other holders may be waiting for an IPI.
+ */
+#define pcp_spin_unlock_irqrestore(ptr, flags)				\
+({									\
+	spin_unlock_irqrestore(&(ptr)->lock, flags);			\
+	pcpu_task_unpin();						\
+})
+
 /*
  * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
  * is not compatible with our locking scheme. However we do not need pcp for
@@ -153,6 +165,9 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 
 #define pcp_spin_unlock(ptr)		\
 		BUG_ON(1)
+
+#define pcp_spin_unlock_irqrestore(ptr, flags)	\
+		BUG_ON(1)
 #endif
 
 /*
@@ -2846,8 +2861,8 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
  * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
  * pcp's watermarks below high.
  *
- * May return a freed pcp, if during page freeing the pcp spinlock cannot be
- * reacquired. Return true if pcp is locked, false otherwise.
+ * May return with the pcp unlocked after freeing pages to the buddy allocator.
+ * Return true if pcp is locked, false otherwise.
  */
 static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
@@ -2904,14 +2919,19 @@ static bool free_frozen_page_commit(struct zone *zone,
 
 	to_free = nr_pcp_free(pcp, batch, high, free_high);
 	while (to_free > 0 && pcp->count > 0) {
+		unsigned long flags = 0;
+
 		to_free_batched = min(to_free, batch);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			local_irq_save(flags);
 		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 		to_free -= to_free_batched;
+		pcp_spin_unlock_irqrestore(pcp, flags);
 
-		if (to_free == 0 || pcp->count == 0)
+		if (!to_free) {
+			ret = false;
 			break;
-
-		pcp_spin_unlock(pcp);
+		}
 
 		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 		if (!pcp) {
-- 
2.53.1-Meta


