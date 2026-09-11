Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E50C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762386B0099; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7121A6B009D; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B53F6B009B; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28AAC6B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4116C1A026F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
X-FDA: 85201628442.27.60C1FFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id ADFEF1C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMUgkNxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134919;
	b=qVvWdAZhjg6KP1561GY05VnYa+SY+/Wra2iv1Tu6gsvBP46c1wVl2dTNbCtf0EEhzjRsTt
	wj7s1u+QZQTtDEUw0uPFdsU2kan/iaDpOYqUMQ557iHr28RyqgCj2YM1VtQCD+zoSGPo8n
	DwRxKV4a0FAZHGUi83Lly5v133Y4BvI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMUgkNxf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMIWiALSFrn/d/Ne4UrnEpuxkZ1ESBf36wruD1e+2pE=;
	b=6CjEkrAV7nAAXC9Cx0hQdiMn2zxjY/URm03QgC1l5y4qOiXAYdGfzHPyYMO8wKprOFZ30f
	AJF9LpxZ7y/M6/UtInJcF8lLnrfQCLimGOg771D13JIdPWDUomMs+OOP/zZhOxjdz1AvJR
	piOC08dj8GqA5WCsO4bQRCq2CiiPcm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4EF6060A5E;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16CE1F00898;
	Fri, 11 Sep 2026 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134919;
	bh=kMIWiALSFrn/d/Ne4UrnEpuxkZ1ESBf36wruD1e+2pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WMUgkNxfjifF94LFMFYVhaCi84XVweVc7zQ66jg6AZ6H0gDuYkPI8eP3fRGR5miwf
	 SuRj/CA1VhZFx+2Yp+MOd6bTF0fyg2ByVLOpaQzKPNTCGYqc98A9ZEaCG3KqJx4YRB
	 sdaXP47joRJ7ie786UeULCNAzz2mZ/R4GcogsGoe9kPHnh9HCnrYxZL+Roa0o4EngB
	 ceMNfCE0kRSMiPxjEkqqlL2v3hjNvusV1vqtqpIzkHhcMXt+JEDHR+/g/I9Kp3Rqma
	 pjb28j7PD4HPuyEVdJ+YufORVOhPtW3Vx5AL8023OM1GOtyD0cMzg7BiBAAU0DlIfl
	 98PtWpmtM8Y+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Fri, 11 Sep 2026 06:55:03 -0700
Message-ID: <20260911135510.96914-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADFEF1C0006
X-Stat-Signature: t6suwggcycyindhdcg5yw5ok1g1w5rrs
X-HE-Tag: 1789134919-170548
X-HE-Meta: U2FsdGVkX19z7L11mpu4Khgrxw8HuOmLaIi8Wxt1oqTg4HHrzoC9xyseJHWDQ5Ns5VnQpBl3ndMAfDglXoHNAKBVZFYtnsB+/NjFs+YlXmvwj+oUYd5n1D0fTbUI/tS3zfEEIuGI7LAgg7akaQEq2OEqAskVyRYv0IKcP0F7aaoqjByUC0vqGATGqmIsylON3McVioMZNM9tOqygGVNBVfctULzpe4w32qLBlXmkUnYMzSUw7GYQEDAq9bK/NHn8Crw2EKbFit46hkbu46urp1lOyHYQcVKD8qPqVKinLI6ib1LFnGakyfz4CJLfWpd8bc/EJQcnTjSNd8tRYWfiiIqOrS8is3fywKQj5SwLY6ksHQkzzFZEUDxl/dVJqo5878ENkzpfhtHhs25+ODIpSYTOOhodigQrPLmDiLR4+Gp/h2CiR3f6x82XN4u3+GmvO3x1p9AMI0Lpyz+7hwgwzKtNtRMYCJ95nO4YlGGZuv8Dbw5Kfg2k/7IrXrvkFrh2mqNkWFkKaEH8b0x89MiEWOHro9NplWWyYh9MVo3GAbCMN4fht41861sLDS8JPZxIostXX38COjSZBYdmNdtMP7mREAIMBj6USGETHt3m3V8q89eFlRXInGa/P4J9DIM93O/tAvUXsabed4DjTsimjq0bg4switJuWlhTDgzsO+TW9UDTdtT1icXWsPgZrh2aua0rM+OcoDsIF1/SgO8uPmd4Ifp52QyqsuF+JVs1L7qY1StN1QrDqPVYAgpdxnaPi2ZhZx6wKuoRisKzhupeoxuVThUvCFghC7GdXqZ0Vi2MFBwiL67o9GutmqE7cuXA0jHZ+A98JLB03dI8isYY21hsQbRvvSPDxIWKOnaES1ljQ2RdRcM3XgVZO2ABPVAUb1AWAJpdWVNuVZfMNWip2cntr7rNbKadjjIMPpXb1lw/Ho683LBiksl06PjwkyOZx6a4KrkoUhbA8F8WxNO
 AoFnrkwF
 Exsto/8uUyQzfzv6WbTLglhZAekGK+NuM0gvZhTXmn8x+V7RvlmUxecFtIcpS4UYN5zXfF0M2zXvPyIeDuHwWocZ+Dv7ZV6dX1CUZzLvYX11x9zl8zpg7a1E8GiKEZ3hFayZffWZCR44GSKL9hzXpEAJnK7VGKW3scyN+LSwJxQi9QCokq2q26y21PuHGa0PGVetH18ia/bRiWHVHa+mvigaUhPx1mdUfvk8WM/m411SsyXfdeMvVWHQcZvNr2kUzFfGOIU64htjoIR49HDxUXlvKxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON kernel API to introduce new DAMOS core filter type,
PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
target regions based on their probe_hits weighted sum.  For describing
the filtering target weighted sum range, add two type-dependent union
fields to damos_filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 16800b3dc379b..9e84bdeb5616d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -399,14 +399,15 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
+ * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
- * are handled by the underlying &struct damon_operations as a part of scheme
- * action trying, and therefore accounted as 'tried'.  In contrast,
- * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
- * by the core layer before trying of the action, and therefore not accounted
- * as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
+ * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
+ * damon_operations as a part of scheme action trying, and therefore accounted
+ * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR and
+ * &DAMOS_FILTER_TYPE_TARGET filters are handled by the core layer before
+ * trying of the action, and therefore not accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
@@ -420,6 +421,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
+	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -434,6 +436,8 @@ enum damos_filter_type {
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
  * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * byte of the region matches to this given condition and avoid applying the
@@ -450,6 +454,10 @@ struct damos_filter {
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* List head for siblings. */
-- 
2.47.3

