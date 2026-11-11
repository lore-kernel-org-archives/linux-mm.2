Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846CB606A89D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=onpncTKU
Received: by kanga.kvack.org (Postfix)
	id A02DA6B05B1; Wed, 11 Nov 2026 07:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0446B05B2; Wed, 11 Nov 2026 07:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6C66B05B3; Wed, 11 Nov 2026 07:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7409B6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:56:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D6D71C1347
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:54 +0000 (UTC)
X-FDA: 85422837948.09.0271003
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1296C1C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=onpncTKU;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794401812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3oWe+9OurKGZHeVfPxCUVowplTdJf5Yg0iJZsnEMIJg=;
	b=RE2HyrlhePvYs+xJSMPF5U/OX4UUHl/RdptxHqJR38qLahR9kyfmpNvehxa8XbYvNGzS9G
	4ZxnxaWYBamZ788cUb/m5kMFFkXJiuyYDFa/yhRMLKJQH7ONnMZwGp+/HDheWwyNAyhF6z
	3XBcSqV/rzppOm6oRBKpFCqGtc17uTE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=onpncTKU;
	spf=pass (imf21.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794401812;
	b=4UHjpdD9i7KAO9rH/DfDW5yv4w0//H7z/wuuHoL+5RVmKFlkyYi7lizHpTyXbGUIXvJdja
	XKgW7K5S83/wBFyad5jYDIPNMqUVm9PLolCLAUqzYzVHw/RZ9KB22s2PkXXQbXB0YfMhVv
	ctVtE7/80goXBUpnJbDrDfDA340sX3g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ccPpTzutagVeIujYiF+PHwu2InfZpHYdEFtz32EU+hM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794401810; v=1; x=1795006610;
 b=onpncTKUjSpfN3RLoZgu+ZZWIwhpM9hUHjI0hhKh0edlbLFmRGy315eGXNAY6ovEUc7seC6i
 OWpY2cJTWK99QMNU3bAYHS2eKlsEx3qrSNDkVUfV91W0DC8uC9rU0CmRvrIIQZ4jeyA/CYpLB13
 tvYqljFrQELeqdtcJ3GIX8iY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b1405ec9a21693fa;
	Wed, 11 Nov 2026 12:56:50 +0000
X-Mizu-Trace-ID: b1405ec9a21693fa
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm/slab: don't set SLAB_MAY_ACCOUNT for KMALLOC_PARTITION_CACHES
Date: Wed, 11 Nov 2026 20:49:10 +0800
Message-ID: <20261111125628.375624-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i4rjrpdwwawisycasug79h93geq6m1jq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1296C1C0005
X-HE-Tag: 1794401811-434021
X-HE-Meta: U2FsdGVkX1+ehFVOIV0v12YPrdKdVH1vtHu2P6+qFsO0oLaBrEhfuU2TACr/D4aBR2sr8C/5M9TTQh54ikDgs+lEeuzdg1znWGA83kfl7XYzt4ZOEPjwqVVmvmqAUsDXRCYeDJ/CppfbPNqgwbra9whe19X3eEwB8IiY91XwpF665zaGR90uNzEOiitoLm/XGdXWG6T6q0qDiIHIrWvMA5ptJV23DuVlVM/gguYZjRHpIN8ZUn6mXa8gK3jcm8TVRigUAhp1371a59zSoIN5wuwv5PpXv1m/d0PtnGPZiP39iclFDdq4QWOsMMukqJGkM3lirZfreovmi1tn3blCKqf30Y1//sEgHgllzfR+8ugrG2amrsx3mHj2D5ucn/hw/znkHNHDPCaa4iq6AsOgxhukOFqaAsK8LXCCcM87zKWKyZxQGGMDGetmQsyicdQuNwLNsOAQYZcvE5Gg7PJ8IjBz8GFvfDQxbAf8mZeUK+u9IvT3mvA/+MLp0kyCn0CHF2cOA7XONj5+3AdWeD9pLR+F1iYfyM7XR+29ZtvQhncmqD5uy3H8MqUDQjJ6VGTTpN4aQLnk3nZimwegwPxJYSzFftk+QRoTc6tnBLalc+paeXVLwX8h8WC/Tpo22wQfvUCIXFA2enJe5016aRwE2zVPnb7odDa92GGkMPc6d8NU2dJ7NBsu6JfL+N97iujioE5WcNOZdiUEl4dSU2FzbNrl9G/JpDZhAH/PgPRwAex+ZFphzhqkEdZipXuLz1zmRuC22YsOQq51+wGuMgYkCRcN3/KJyRTqB3+xiTah6n2D9z3Chy56jYRte/5u6834F2qrQk9qk2VRPJkWxJ9V1QG4Yuz98aBIxYO1t0Y0sqjpsNUxxYt9jmLPSaWB56yvwUGi/OXXuIqnNP80/2vAVW4iaefKSe9f8yqk8Xs/tKRIQA4psSEGC2O3/H3qbuYm7GQDvskYlk0cxuMOJ3D
 Oa0OkDjR
 U0nqwFq9JeZtqhkrVJzRcdGeFXcgjrXQ6kJ968+8xco9ygUyTs3PimneWOzmtjOQ0Ywcn0t9CG+eh8rr6c6WMzAtpTCAMdR9582lWfr1vcyDFblMatBnavqYU0edzt/jcsulpJX1HTNphv/JqoG9EQercNm0BBbotRNhUrC01xSmhx5tMSIMtmCd757uqSIqnSmJl5LWe5Saa/Ku80GO3u21SYMCOReCIhIPcqVIWad5BSD4ppx0rUVaHJ+41RcDEnzXuWrjOEGEXCPNaYmmrhm4zkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An allocation with __GFP_ACCOUNT set (without __GFP_DMA or
__GFP_RECLAIMABLE) is redirected to KMALLOC_CGROUP and will never hit
KMALLOC_NORMAL or KMALLOC_PARTITION_CACHES. Consequently, neither of
these caches requires objcg slots in obj_exts.

While KMALLOC_NORMAL already skips setting SLAB_MAY_ACCOUNT,
KMALLOC_PARTITION_CACHES still carries it unnecessarily.

Extend the check to skip KMALLOC_PARTITION_CACHES as well, saving
unnecessary objcg slots in obj_exts.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
This doesn't seem like a real bug to me, just a small waste of memory, so I
didn't add a Fixes tag.
---
 mm/slab_common.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2befd24b4d09..f0ea1fa178e7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1000,16 +1000,18 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 #endif
 
 	/*
-	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
-	 * aliased with any other type, make sure it's never merged with any other
-	 * cache.
+	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL or
+	 * KMALLOC_PARTITION_CACHES cache and not aliased with any other type,
+	 * make sure it's never merged with any other cache.
 	 *
 	 * In other cases the kmalloc cache may end up being used for a
 	 * __GFP_ACCOUNT allocation so mark it as such. The exception is a
 	 * KMALLOC_NO_OBJ_EXT cache.
 	 */
 	if (!mem_cgroup_kmem_disabled()) {
-		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+		if (type >= KMALLOC_PARTITION_START &&
+		    type <= KMALLOC_PARTITION_END &&
+		    KMALLOC_RECLAIM != KMALLOC_NORMAL)
 			flags |= SLAB_NO_MERGE;
 		else if (!(flags & SLAB_NO_OBJ_EXT))
 			flags |= SLAB_MAY_ACCOUNT;
-- 
2.55.0


