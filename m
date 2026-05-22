Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1BFCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA086B00A7; Fri, 22 May 2026 11:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0C66B00A5; Fri, 22 May 2026 11:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7186B00A5; Fri, 22 May 2026 11:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36D6A6B00A9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 012821A0AC6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
X-FDA: 84795468156.03.57B996D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F52D80007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ0C630G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	b=7WCX5Bqr6qiH0jP1KoLs3EzfM05HvDG9x4FI+wFcsIkxpwYB8z3G3AOOoZUVhq/xyQWNp2
	b9+f6qKofWN0TIALDvggKsjuBZpp8/IJSRzGjZVomE7cEgUYkpKwMl8DsqctrPcKeEuMD2
	m8ugFyGfgD0h27+pjeyxqEATdF9bMMw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IZ0C630G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464436; a=rsa-sha256;
	cv=none;
	b=PUy8rDTFfY7i6gz6yN92a1YOPOBWiKvZXis1OEjPTy4LXqwPpw/knvEqUc8xYQlVs2q9VU
	M2ZIJmRczvzrnQf62+Xg7EcCpMhaPmUJWBm9x2rIQ4OeudKxcT8AUmACGxVbQgODV+6GI4
	vrsJwrDDudyWOC16CJQmw8UR1NPnS/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0F03419CF;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED111F0155C;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464435;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZ0C630GPvB3v3POgTGLrg8mKTcpDrl8Ln0Jsh8n9en4eZykTjRHOcgUAad78+7/I
	 2Fm8MJDfV3AzlEvvZvzeVVz380qaYjGY4/D0+LmNbdPFVwMihzlI6KzxZl+5pSqmHN
	 UzbLs6kx0NZhuUHL9ksz/uh2pDICzmeEX/Kw7YW88qX1yJcYK6Enfeeq/YR25hnyJs
	 1OKVehV0IY8jI5ejbhlM5+at1ew7csIx1WOWq9Uw3UL+w2ljH7OlxWiuy6wbDHvkqx
	 z1255h8aZrJ83WWbUT4oEbp3o91FInhEn1QTsF2GlfVGKXTuLYeZFxguFkEo2av3ck
	 CifIVrvKfBMpQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/14] samples/damon/mtier: replace damon_add_region() with damon_set_regions()
Date: Fri, 22 May 2026 08:40:14 -0700
Message-ID: <20260522154026.80546-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rhwok5r1kzht8zso8q1788tio55uifry
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F52D80007
X-Rspam-User: 
X-HE-Tag: 1779464436-39579
X-HE-Meta: U2FsdGVkX18r8Zw/VJvOTBHyJD0Wnq4O28hmLkY8OWmPPqN0748370QtJ92zTTkjh5W0NP0gj/Z9AnYpy4jyH/qNpjFFoe+NiQGpistZfOktDRV9NHxQ4NstddMD3J0i9GZYXpcaJEuiluG/vjiAlMoT1Y1FXOfdVi7zsRu+yT42KTlikOviSh+OQTUZNyXPfPHshvBKJRVcYx4MCHVfc2fV2iLL8NsUa0ypc/FB/lhUPfGK+qV8Wq9OTnM2rG6Y9BzLYXZrB16zBuPN1p9rvxbcNkXsGSFYYJrkzd8CKtKxZfbjynsrRVNYAOqpkbE+4Ddp0CKj3K3CcWPxGRcknkCnDtXJO7LeVj6o/QsKAAldnvgMQtdwDuBRnzZnY8+C4dCyHopQFAjiWsgCrumcv8CJb7g68W3JhLwVGIEsvaQ8/MjSnZ3thXX02+pfaUeXfbChw4PhwSZtE+TlwK8cx8s0FEfl5sT02mge3jHmvTs11gWucVh1s9j7Ro0pmqvgzZeMyUgS9aCZoFjvq+dXJq9bYLWUt4Dxet7S2t7uUqUuFI9yMKtDaJ8/oFogFL/cvrNSmh75IBYOCXOBa1N4l4CsFa4rdyHtvo3T/5tSi3pUpu7x/LnxWVdsx81JuAKRa7JfL5kr//MAm2/92m6AI8Cqep6FnKb9oJh5ZYonHSNT5+ndeecsNn96tSO9injeUzNsxALhAiVOci/arWr7lKf1B/GAxARAXqjSNT0E8VGh/z3r/Pl+l9fZZztU2411kQCaAxkXjuUTKD1qFbdGMpucdiprma3JNZxssD7vmQexeWw1RGFP4opBPM0O4muCjNxEHnGHEQyjHB7T5olZ5HvAnnYmV0i8uMHtT+HOl3bCgPdPMsECuk0xxOazPhUllWQKJNu44wipRY0EVroL3og1SX1uA6ifL2i+O4NNGZufWt5IQ0uI87N1vb/LT6z9Qfdif5TJNjf35PVzvVj
 0Xdb9JQC
 EMUBYNhHShwd/KA6ZHkPSyi/ApJq+CM5MG+eZV6nk6G4+REOMQOFaLpuKSh4pRkU8YiFJFOosqZW0d2RdjozrAW0zk0KWXWvW9WuLWrQXBLoKiOXlo/CjdP6X/OW4ruMl2MOkFM2MkPsOcRDYhSABNYXgkN8o/xh8CGM0XKAO6p4YEzlAqLACs4PzufuYSczV8Dsmjco1VYkdLTwUNfQjFKgUUsxUeADC7GDJym35s49N2SOT0AVjfJHZ8qd2rBQ1IIPTeO39RC5tR/XVgIgA8ZXBJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mtier DAMON sample module and DAMON virtual address operation set
(vaddr) unit tests are using damon_add_region() for setup of DAMON
monitoring target region boundaries setup.  But, damon_set_regions() is
designed for exactly the purpose.  All other DAMON API callers use the
function for the purpose.  Replace damon_add_region() usage in mtier
sample module with damon_set_regions(), for unifying the use case and
reducing the maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d935..eb1143de8df17 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -75,11 +75,11 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	struct damon_region *region;
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
 	struct region_range addr;
+	struct damon_addr_range range;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -120,10 +120,12 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
-	region = damon_new_region(addr.start, addr.end);
-	if (!region)
+	range.start = addr.start;
+	range.end = addr.end;
+
+	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	if (ret)
 		goto free_out;
-	damon_add_region(region, target);
 
 	scheme = damon_new_scheme(
 			/* access pattern */
-- 
2.47.3

