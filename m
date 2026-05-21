Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE39ECD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027246B0095; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC2D6B0098; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC8A6B0099; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07CB6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83A32403A8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
X-FDA: 84790058808.08.F3B9585
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5552A0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dLCY/Hon";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	b=fSrUbHvJ5gKQQFkOtRWRWCcJiCF6c34WruzqjRelKNcSJ+IqksXfl0RtgYDLnQf/9e0Ykb
	+ZUgzwEu4bDUAfLumyY70NSHfaBFwOPBMvsDY9uAx+stfVHWJkVdlvfDGPr/N+EobdsRaz
	gTZzluM18Wk3pnCKZQfhvIm1ayOPZgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335643; a=rsa-sha256;
	cv=none;
	b=dXdIxgv/movcIITuOFnaFXlT9UyoPJ6NREpHtaMcklCw7RKIIhX8uEGWibGCy8abb2XBYy
	dskk5Fjv2OzRwnt06JdsgQHCDiBmoHDljjF9E34hLAw0WwFN/SYhMqGAMNBWVQx/v0yDNA
	/fAK5xmxCM6PbOrIKpFtYYZBAUSHRsU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dLCY/Hon";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D39B401C5;
	Thu, 21 May 2026 03:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D775A1F00A3D;
	Thu, 21 May 2026 03:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335642;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLCY/Honses78eLJnMDM5fSxNLintajUZI+ScYIp/brNJWO1IL6WIw5ZQMLY6qT0R
	 ysPNvK+Klte9z/prExDgT4IlT+oEJaB1s/qDiyvcCEZeJSkcTxoNYKoGDyhHqqRECY
	 dJpuH8Z8Hj14EYHrrRTjgYiJOrC7c+5T0gPUR/dXld17O4cl1Xl0xjNifbk0oXMiOT
	 8uEkLU0cOGWh3HmYhCsX61z4RUFeJBXqTg/eon0ZCYHObCZT2BT2zjGcz4+CqBS5L9
	 cFpw/HmEzl1LSPfyJdt6P/kHfK7WP/P0bdAW+UDJumFf6PFZinInxhlYRsIs/IdxKk
	 SDcwx2D1t05pg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/14] mm/damon/core: hide damon_insert_region()
Date: Wed, 20 May 2026 20:53:40 -0700
Message-ID: <20260521035349.87565-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5552A0004
X-Stat-Signature: h7xtd334nw13x8fn4jinc3rehk891uhi
X-Rspam-User: 
X-HE-Tag: 1779335642-264576
X-HE-Meta: U2FsdGVkX1/md3GDpQoGx5SmAJIZu9qBjupxNX4/5VJKtX71uUT1N6Z/LtKLZ/oh0sHv9A7IQXVrpxkW2ZShhSGj05RxaYBATGgpz5t7BGYZ90KiQEuzfrtKUuUzauCRaiqxEaoJVMOueYRYxBGebLqmSOP0d8kxmjiNKq2WKczTfkbirOQGGDtDRAMeg9ae7DIScgRpIj0aaDXLHvUVdCziQtNj1PX2hIDB2jqA/GjVc00mfZlbw27U8q+lu9PpP+XMABvejiYk2P7PKVkfOsx26jMS6iqkUWG0YGhmStJI4NY6UXh+ltHKezUbQwLi52GJDSRjOYCHSddqN1vgbXdz7dPEHn+N7R1fIkNVqdtoBr01e6s9ish6LQR4MFZoPAHQVWNQfwb4HyEnMigfJCuHDgKUJL9tOPCWs9iUGUJo6wFuIX5+4zd+LoOKKVjbejUv7RmiXqcLzQHVKKjASQhttFLHXrGXccuFtOoooAJ7XsYXpFKkFCF+IFpx+DKszirvE7lA9jBnzNxYSxcEg+nAp/71+IU86LByUCGThRzshDWv4Jg+dOb8loDM4I90Jt6QKHh/eJrORhNYi4CYh61aqI2crIGq0GgUhoywNuJgL7iagbn4HW63NDOIr54poC60gaNur16ThcgLSOcdkvky6DbWI5yBBXfaXL/5tInWf/qAt7khyy5zU6wLKDwmXHYd0XzR1MykiuSzgIFsbOqsALMXhlMMIy7859wKKbYRI6olJaYl0g7CwqU/q6t20fS18gNek96HgyAMa4UiqDqpuq4nnBtFfRjySZBJeU5iMcRbNh7mLos2zIEZbzihTKQPUR10yDBhUdkfM96ITzGk1xdRQLlub3NFJVX6SdNJm3PFYhSdxJ+TdhSnr3o9yqYP/QPSbIVyizqD1KXD/POI8vAlckdwCNtwxpQLb9k5GJhmcsTsFX6Zmcg/We5qzr910BrXZ6Xw9nPOgne
 GMQRQ+kD
 d8tQwhVWG1gO1EPG3WBPXBU7GROH0goqsykiVLf9bGKB1y+4wddtHnXOoNxC0dWSb/Iyi1SquoO0yA1z+ezIeioIvpdLhCgVeKEuv3nq5xHR4LVniSJlvvrj3zlU9tvO8aDSvL1TbXXqNeKuZbKgim64b2o31KRoap0bhLC38zW8TG0Tn6DZKyDLxjxnszd4VkZsmPhNtBbJfQgbZQY23XuQFdTWiWe4IjeTVNRp+d9CEaJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_insert_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 11 -----------
 mm/damon/core.c       | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b9370c1779cba..3acca7deb1693 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,17 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-/*
- * Add a region between two other regions
- */
-static inline void damon_insert_region(struct damon_region *r,
-		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t)
-{
-	__list_add(&r->list, &prev->list, &next->list);
-	t->nr_regions++;
-}
-
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7d1de6ff54eba..53b4bdd27b39d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -256,6 +256,17 @@ static void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+/*
+ * Add a region between two other regions
+ */
+static inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next,
+		struct damon_target *t)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+	t->nr_regions++;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_del_region(struct damon_target *t)
 {
-- 
2.47.3

