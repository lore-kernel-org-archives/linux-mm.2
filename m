Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3B3C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11806B00AF; Mon, 12 Jan 2026 10:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86E66B00B2; Mon, 12 Jan 2026 10:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0046B00AF; Mon, 12 Jan 2026 10:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C596D6B00AF
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:46:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DA531A04AA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:51 +0000 (UTC)
X-FDA: 84323739822.02.D79C3D2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id DFD7FC000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768232810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/Jy9OnP0hnLUOGn2moJ38DojQTZO4zn6hqXywrhkNc=;
	b=1fEtwcmZfKAYdc/D92o7URsvlcH72zGUVEoFDxPLzITNgy9EbhhHa9e4kc7b+ZiqsZS8jx
	KoSjJ04atFpsUboVq50cqR9rUW8tG2pdal3YUVUJdZIb/CXAYGIHgrjot+Q+vNZpEquV7G
	dpoXGtyI4EhibpTem350vfh5L2JUR30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768232810; a=rsa-sha256;
	cv=none;
	b=1/Nk3B8Q3UmNPlbAt5LrPmdLv8MryzR/NwagH9ggxSC5fM+hTLn2gcRqB9U5oTP8e0zGIk
	dnXXa1dNR3cwqlu1SzCKYQ0YJnKX6mBt/cflE13DdB4bUDKpNU0P36Gzmfxk1B3+HnwyEr
	53PPqI+0fNppqVqrHI3cxYmdHZ0aMUU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43C981516;
	Mon, 12 Jan 2026 07:46:42 -0800 (PST)
Received: from 010265703453.arm.com (unknown [10.57.48.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8CA563F694;
	Mon, 12 Jan 2026 07:46:46 -0800 (PST)
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
Subject: [PATCH 1/3] dma/pool: Improve pool lookup
Date: Mon, 12 Jan 2026 15:46:36 +0000
Message-Id: <c846b1a2f43295cac926c7af2ce907f62baec518.1768230104.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1768230104.git.robin.murphy@arm.com>
References: <cover.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFD7FC000D
X-Rspam-User: 
X-Stat-Signature: jd4n9a4xzd87ht34tqqyb8ho1zki5okq
X-HE-Tag: 1768232809-54934
X-HE-Meta: U2FsdGVkX1/RnVfG+h3Fl/nyb+Naz2TY6d1nZP0MkzoC4yVn9cz86L0JgtCGk+BsUCzIzX39uGgmxUEMgUzwKwgXefhHPegooefQRDKFOD/KoIqHhKVlFn9nRSww5aGmZp1cja8gSI+WhMyPiLyz0124D2t9kM0icUDGnBzL7iarKMxoLmP4hWrgYgcyzJOX889seQPbPFX9zzwWpdZc4gBAlw8nwVC+Rkhp913/BLSeQN9V7kI6Sbwz6Iz/AXNzjGWfWUIU5W+SBsOFlVwTCAgrWLc4EEXuaFr/t6y9YICF86zXNnXOVT9c33O2K+UrChKGgvKN91a9gfJQ5TD6ublTYgXyoApN9D1xesZBA44IGFonqul0J8oWoT3btdGHT6EmWJcWVV/5v7O6fRc3/DFnX2luneMiqNsYRLX06mCeT2dxiVwS3RSORS9BgcWNRVDlUT89+iBqv7kpOdHBqkOSAYL6S/6zQHiP+n4S84hrlZnTXUN2m32B0RWS4wbXTQs/mmbCbnZeriaQLOkDSyrMLoOx20JQ+nQxr/WDF7pWjUhbMZtD01wMaD43jK1zIqtMHKQBJ8dz6oG2OK9lZ3OjqLz4YkW+UXsjKIA4igCtOOetEWHCOLovXwpY9fbZ69nu4qDVhBI8QWDqh7rAIHUKkC4I4Hb3RpdCu8CPGvRJu9cKk8Zk2RDdCJiztHrq0sAa034NTr3ga2LuUVyx/dl4Dsob3kaSLVbUSdmweFq4PA0ihaPADihIvMLxHwvnAPG3iwo+kxo0ue/ILE1se0siPjq8MjMU4VuV+hgfaZfjOz+45KL3y5zoyk7bIIW8xNGH9U5FwUwyLCnJd5jSk+fXW4jmpkn7LhveF3BpGlQhJLUcyl7P6xYZnFlZUHLQ8IIfP+ZhCX7KRjL4C42WNdS9esFIjN40/37hgfDh/LMufGnEDkTPsveVENnWFeVxAPzQ6I6HQLkDsIQdgHb
 bw8grhvZ
 92dtG1iNlEqTQcWajOD2gJVlgpfe+gNNYbyijcs92XUg/r/yHsyA4DT0sE6Z/n//EJy2fQqu99qsiyH0IMz5jkS3uC2sDeXIP7aJTVk2Q6qGjWu5EXctbCPawwKdCxJCjKhjzLNo4ypG22K/aY/8kgpOOhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If CONFIG_ZONE_DMA32 is enabled, but we have not allocated the
corresponding atomic_pool_dma32, dma_guess_pool() may return the NULL
value of that and fail a GFP_DMA32 allocation without trying to fall
back to other pools which may exist. Furthermore, if no GFP_DMA pool
exists, it is preferable to try GFP_DMA32 rather than immediately fall
back to GFP_KERNEL with even less chance of success. Improve matters
by encoding an explicit order of pool preference for each flag.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 kernel/dma/pool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 26392badc36b..2645cfb5718b 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -224,10 +224,10 @@ postcore_initcall(dma_atomic_pool_init);
 static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
 {
 	if (prev == NULL) {
-		if (IS_ENABLED(CONFIG_ZONE_DMA32) && (gfp & GFP_DMA32))
-			return atomic_pool_dma32;
-		if (atomic_pool_dma && (gfp & GFP_DMA))
-			return atomic_pool_dma;
+		if (gfp & GFP_DMA)
+			return atomic_pool_dma ?: atomic_pool_dma32 ?: atomic_pool_kernel;
+		if (gfp & GFP_DMA32)
+			return atomic_pool_dma32 ?: atomic_pool_dma ?: atomic_pool_kernel;
 		return atomic_pool_kernel;
 	}
 	if (prev == atomic_pool_kernel)
-- 
2.34.1


