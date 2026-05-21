Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403D0CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264FA6B00C5; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFAA6B00C6; Thu, 21 May 2026 10:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068B06B00C7; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3CA56B00C6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EE05C2186
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
X-FDA: 84791673204.23.F726D26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0B4134001B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bb2iZK2U;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374081; a=rsa-sha256;
	cv=none;
	b=uloNrlj9Q7Dp1CY4iWRc+VkWh19JCrvweOmImR+V81Xx/da3eJESDSkb00GRgp2DQn1CJ2
	1US6QU0NY/NifthF6Xu+QKdftVX1JluMQpdS3pcVzTY8T8qJ9D1rHUFFoQNDpuCpDPlOJO
	UOntEe+UpgIGI0tGmKfCEPJ4PlLY3Do=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bb2iZK2U;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	b=MEQgtTbQbry0mse2b8nwJISh2AdbDE6C1cNFT2UkwPFuxQuSGScZ8uKCg6HZIbuh23hWGF
	HGhhUHN3PqOy0J84LyabeAHLiHNJNAO5K21RGVrOIYZpzyjB9b8OqfrMICkSHrAsPn+WIV
	cRN8qWRJyn2dGzRwZjd0GxUCPBLSBU8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54FB344421;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9E11F00ADF;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374080;
	bh=3LRLg3Pzb74v2r5bZtbtebH98gpHkUBcEoBkx4Qaj+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb2iZK2UMHiPZv8SKKL/yoDF4gv8vV5A+pgyEOKT1pwH7/K2ISRcbS9rmfnlwFFSS
	 Qeh47d11YXvF2i+D6xsPQrl4PGnpgZ0rwTV833Q7YfQQptks5u7cLK8Mueg8eOTw7C
	 l0LCo3rK5EEJYloplfrCstp6bHJUYi6hPsLoLhzFtKKMXnLVimskDW6LGFxAHkRu27
	 VMHlfbBOESc2DBlpx5iyRZ78CMfrPvJ3553IjAtZqnWIpwATMVo4/5NYd9fZF5UU64
	 ZTq/ywC0GDdL7Ax0FPP1Qfg3IzFi2NzbcnZk2zLjOebkOA2GgIlyufEoK7MybQxAsZ
	 87/oVhc7J9rxg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 08/14] mm/damon/core: add kdamond_call() debug_sanity check
Date: Thu, 21 May 2026 07:34:18 -0700
Message-ID: <20260521143428.83157-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B4134001B
X-Rspamd-Server: rspam03
X-Stat-Signature: 4c9agqj3xjwoeymi5w4hj69jzgmx585y
X-HE-Tag: 1779374080-835344
X-HE-Meta: U2FsdGVkX18pSR4h9MBW7t3MjcrWzsC5IekzdGhnFk41Rw3mmUlBo7eE1/wUeAUgzsMduFtA9yCrApy1D1zkp91JKsio+2NcgtCp2djbFgRDHxqr9p7QETltIATqVJqsTFAdBR+lHm77jIsIJLizK/7QdCojWut58XRCp+G9yICOVPfWmZ/b0C+gybUDyAmDxy4UASrpK7YvBddwYMrEbUyQyehFDPMovUv3iYlXxSpL5GCzg99dka//L15uQTcTdtAyGhV5nhNDVAg/NdWjAEGNniLq1qh06rq8N1EK1AAHfXmo2Vmv4lRxAIVU9sllvm9X998deRaAyjjJlioJflGfaGSbNO5xSWvKa/dJlkkmKKN93AVOC/izrc8ObRNP4DJ/A4p5EnmzdGKDRR5cFarlceZOV1NBmsZ1kLfDw84PydsApMfrAD9Sp3tO9HezOAlIIMSiYj6rpR6EEupogqtIS/01c2J+9xNGa2KO/IHUbajOM+U7+WE/ISWwz5bS16QHg78a6SqVFzqCunwQS3Qq0/aivQQ/icSCRFpgKhzRkV8em4SUM2KpEONugcWUC5B7PhNRhsHFskIVob8W9rD9mH196//KYJh0TX2H2ybhe9pV3cEqAb7ADWYUfEp1/iGNfQf+eckv97mv2PerXYM5TUnm7H2XAnRwka7mwzxd/4OQH54XSWBVg9dRw/Ut9zwmbhsEzvn/gGocdVLsk9AAWHutarl1SSBxNoh1412gZNGYEccNHmZAo0kpWZureJG2ZjuYvSmgowozBruSxrPp9FojF++1uG6z2+mfp/I1JJWvNE8Wsg/ZXnmKYs4eARDUmRrXyuQ0KOy4wjsos+ETP3mL2tjZqdNP4yG2bjVXU+FJhK/FGOgyXAsPuiqhEQHx1iEIEALCqfnLNQT5p+sSqoyF8z1danhw98gXfA674fLDIPFZ07ySecC1PuTJ9Roz30na2IWx7NHMp6w
 ERCIazz3
 trYWPkSOpjJO1URqcZlRBQ8pyz+++ghJLzU50ZiUr+fu3kSXjxrmo7Px6GAzfhM/+JxKc217e6UOIIfUREc6tlgXr1aDc4lz0MMrKn/b1b/HDJ+sTiI9ogX+BOPV887fLiydymRP8ibeM3JcRIlLveHJe0Il8IL1kSSUle2mlLWUld8uC28oEu+cxyndFbvAb6XfUk9zBla8+1Be/8yDBhlKOIdDaTy49RP6sEYGiXynfp0KZvQRKejWYa3ljm7S2Bz/nxLvIbRPuoL6RraN0Qesmsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_call() is the place where DAMON API callers are allowed to
access the DAMON context's public internal state including the
monitoring results. Hence it is important to ensure it is called with
the expected DAMON context state.  Do the check under
DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8a9202937781c..9cde5b47b9585 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3331,6 +3331,37 @@ static void kdamond_usleep(unsigned long usecs)
 		usleep_range_idle(usecs, usecs + 1);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *prev_r = NULL;
+		unsigned int nr_regions = 0;
+
+		damon_for_each_region(r, t) {
+			WARN_ONCE(r->ar.start >= r->ar.end,
+					"region start (%lu) >= end (%lu)\n",
+					r->ar.start, r->ar.end);
+			WARN_ONCE(prev_r && prev_r->ar.end > r->ar.start,
+					"region overlap (%lu > %lu)\n",
+					prev_r->ar.end, r->ar.start);
+			prev_r = r;
+			nr_regions++;
+		}
+		WARN_ONCE(damon_nr_regions(t) != nr_regions,
+				"nr_regions mismatch: %u != %u\n",
+				damon_nr_regions(t), nr_regions);
+	}
+}
+#else
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+}
+#endif
+
 /*
  * kdamond_call() - handle damon_call_control objects.
  * @ctx:	The &struct damon_ctx of the kdamond.
@@ -3346,6 +3377,8 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 	struct damon_call_control *control, *next;
 	LIST_HEAD(controls);
 
+	damon_verify_ctx(ctx);
+
 	mutex_lock(&ctx->call_controls_lock);
 	list_splice_tail_init(&ctx->call_controls, &controls);
 	mutex_unlock(&ctx->call_controls_lock);
-- 
2.47.3

