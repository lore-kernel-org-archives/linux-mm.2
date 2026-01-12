Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EBE0C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4C86B00B3; Mon, 12 Jan 2026 10:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EEA6B00B4; Mon, 12 Jan 2026 10:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8D26B00B5; Mon, 12 Jan 2026 10:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1B66B00B3
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:46:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 058111404FA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:57 +0000 (UTC)
X-FDA: 84323740074.09.568A2C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6185540005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768232815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NqYSd/avN/5uFjqfeVsrcXU9Lu1NZTcqlBKSIo90JAo=;
	b=pIus3toBE84JB8b7nHUYLmVen43kRD8PxFqr1tfcvlVmKxxlmb2ziuwHd1aG1CaId4MJgF
	2pfjWBc5LEhP8b3FNXUVBNACSbG1y68ey/aAcZB7JLpDThTZiRgSM4Au2H3iLtqheMt1zs
	xKpn6J8VMVvxvJjD+KlmK9inD6uKjCE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768232815; a=rsa-sha256;
	cv=none;
	b=n1XOr1DOHnTVmFu7mFJWvbwnTsy1nxww3/Yku/CY+sZIn8tuzk/VPSf36RYPcdMInynLPl
	unoVpb+QMjS7/gOYpo7Gso2g4myQd4KyzjcveRD1UzNsIzWM9yzPG76I7xCwUKAGrQJkGP
	a58yQNUeeuQw8LyyeffBpZTKhydLMdY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE5DE1596;
	Mon, 12 Jan 2026 07:46:47 -0800 (PST)
Received: from 010265703453.arm.com (unknown [10.57.48.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1267C3F694;
	Mon, 12 Jan 2026 07:46:51 -0800 (PST)
From: Robin Murphy <robin.murphy@arm.com>
To: m.szyprowski@samsung.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: bhe@redhat.com,
	iommu@lists.linux-foundation.org,
	linux-mm@kvack.org,
	vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: [PATCH 3/3] dma/pool: Avoid allocating redundant pools
Date: Mon, 12 Jan 2026 15:46:38 +0000
Message-Id: <8ab8d8a620dee0109f33f5cb63d6bfeed35aac37.1768230104.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
References: <cover.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: izrmt53n1w5hn917wsmorbefnpk34wur
X-Rspam-User: 
X-Rspamd-Queue-Id: 6185540005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768232815-136948
X-HE-Meta: U2FsdGVkX1/MvomauJSLVRQz5X8d6i5gC/PporPjhJr5IqHWJvZBfmtWiu/7IxOpWUS3Ohomq/sIoSM5fnAzZDih5lDDGGnDj6Fllt7VGPUOXRabWAxF68CsbrMok/bL80oVGepS6edbhYxrW8nOEHQcVdVURljYu1DwdXHtq8ZC84Vv9+LMaHf/jxh0F/9beFSu+DfOso48y/VBKwO7Keokz2OFmSYOHE+8eqYokZYwrkL5AcTfZt+qCAGTHqKJMpBQ9liR3SClsHLjkT/JWEfrDVSlcJLTRsZfANVK52B20U3PVphjXX7pdJHb14bG4kZXA9QoUfRf9s77vlLEM/FyozlY0qoeC63NED/EhUWZwGnM0VGIyRbfisEcYgYBZoYEtlJx5AyRnX1dwrDYBFqIJL+SKsvhBs5gyyczriqD/gl11DHaOYpZ1i/FAVbEsK47MqEBY6MXHAa37YoShMAq4FgkEWqYXk1sFvkvgetcvFYSDAafNQsZe4OZan7X1l+wnnOd0nTxtx9RN8YiRgLnLWQ8AGCTTTNWN4VgXhefHp/fBHMmexFgOXlTFU7DI/mJdXUkxG9X7wyOrQngKEFJhQ82wLRPlhkrtfuebwLvWAsM6SSdzniWyf5kizV3FLJNXiPHMZaFZTRnlrDVS52OmScgDCDtgwsjwLsqqV63ejrXzGIRUjxItiDwS5v4zPrvwwUszhKGNZzWsWOOI663GoUztnqEmQjVHiy6k5C30EjQNxmu/K5/EtvJh3NVnYaN1+T+Y6PJ8tTQZdwjJ81nTwMtI26RtuzKE691QGJYn6u3ls5GIh6TFRhq8aWBo2RzXo72l3b1S9lw33IwfMuc71fI3d5sWy0vgESqDz1nlx0tqxSskykTw6X2z5MdjExydfVeRG+CZRsXSoR2kWmUPhcX4pNVg2pPMOXLq1IGpVI8bdZD6ERiQ9Dhm68fW7iu3YkmH/vTxX0VOJq
 s4k43wZg
 g/9oBwK2pjmtaQgbrs9OQsa9dh7XlS7kceCIX3Og8sJKbuMJUYT79QCnLeSbRWWs1g2IsJX0Oqi/6cHqdkcX5qe8/MuLnzriGevaLiYA/JGBOkBYVO8n/1apoBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On smaller systems, e.g. embedded arm64, it is common for all memory
to end up in ZONE_DMA32 or even ZONE_DMA. In such cases it is redundant
to allocate a nominal pool for an empty higher zone that just ends up
coming from a lower zone that should already have its own pool anyway.
We already have logic to skip allocating a ZONE_DMA pool when that is
empty, so generalise that to save memory in the case of other zones too.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 kernel/dma/pool.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 2645cfb5718b..c5da29ad010c 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -184,6 +184,12 @@ static __init struct gen_pool *__dma_atomic_pool_init(size_t pool_size,
 	return pool;
 }
 
+#ifdef CONFIG_ZONE_DMA32
+#define has_managed_dma32 has_managed_zone(ZONE_DMA32)
+#else
+#define has_managed_dma32 false
+#endif
+
 static int __init dma_atomic_pool_init(void)
 {
 	int ret = 0;
@@ -199,17 +205,20 @@ static int __init dma_atomic_pool_init(void)
 	}
 	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
 
-	atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
+	/* All memory might be in the DMA zone(s) to begin with */
+	if (has_managed_zone(ZONE_NORMAL)) {
+		atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
 						    GFP_KERNEL);
-	if (!atomic_pool_kernel)
-		ret = -ENOMEM;
+		if (!atomic_pool_kernel)
+			ret = -ENOMEM;
+	}
 	if (has_managed_dma()) {
 		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
 						GFP_KERNEL | GFP_DMA);
 		if (!atomic_pool_dma)
 			ret = -ENOMEM;
 	}
-	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
+	if (has_managed_dma32) {
 		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
 						GFP_KERNEL | GFP_DMA32);
 		if (!atomic_pool_dma32)
@@ -228,7 +237,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
 			return atomic_pool_dma ?: atomic_pool_dma32 ?: atomic_pool_kernel;
 		if (gfp & GFP_DMA32)
 			return atomic_pool_dma32 ?: atomic_pool_dma ?: atomic_pool_kernel;
-		return atomic_pool_kernel;
+		return atomic_pool_kernel ?: atomic_pool_dma32 ?: atomic_pool_dma;
 	}
 	if (prev == atomic_pool_kernel)
 		return atomic_pool_dma32 ? atomic_pool_dma32 : atomic_pool_dma;
-- 
2.34.1


