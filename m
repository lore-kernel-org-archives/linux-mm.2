Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52866C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 19:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25706B0096; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBEB6B0098; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11966B0099; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7514C6B0096
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 15:18:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66F9CC04FF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:19 +0000 (UTC)
X-FDA: 85206071118.19.9343318
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CBAE7180007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrI54Zs0;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789240697;
	b=hmm0Xb8ONEC2g7O20uIJ+/DzylOiFctfgZ3OgyDs2OseDERFOqaRCmawYpZAQG4k4pLBMl
	y9cdus5YI/NdhgcZYzMNW8YBRA2f9g3AvPb+l2k71SGNRLcw3KJ9Jv8vZOUzfCbexjVW1s
	qNhKG/VhYfvn6Y0Fl64DCbXs7Ng7Q2c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hrI54Zs0;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789240697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	b=JTSqVjUVJBO8VB1RwQXj/3afTx36v68F/KGhMz8cXyvMBo01ClhlC+PifprY+fZji231oo
	CD3HgxVbvhjZvFsck0qpH45QLZO9MzQ2/TKo5TpNtbl1AzRwLwzQ6CRpDgo1NrPuN8LlIs
	eRSwIZHJ9+CpMs2VEQJheLlcVAmhMfs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CA1F601F0;
	Sat, 12 Sep 2026 19:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D961F0089C;
	Sat, 12 Sep 2026 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789240697;
	bh=SymGB/Aunbf5NpktH/MrAmxXwvCzvOB6NopidPvvPWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrI54Zs0ZHlyuNs81eKuRAMlM85IMUjCFlUF75HLy3CHQEDjXuDocyb4YDK9bd7RP
	 XXV8088K0UCW72zqDqixZ018ccn0C3TVca1VwYtAar8GVcp/9Wk+WqOd5uJovhKCBC
	 B8juJYsoPO5PZY/B2LP+S97g5c2Rx3gD1bxwMqg76MBNOwGZxmAvRTL4t7v3HXznre
	 SdTY3I3TGhLB0revSdscRgpafcNMBFbKIE+/JByjWA6pYnP/nBC7RndrwtxO8usccU
	 cvPAfDkYbxIW9LGScNDVhchTHJHoHhaYcqkZUpHqb5jDJM2U85ZxMJ4AlnMLbRZdyT
	 2xD2GqsAT++7g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/8] mm/damon/sysfs-schemes: drop centralized filter range arg validations
Date: Sat, 12 Sep 2026 12:18:03 -0700
Message-ID: <20260912191807.138502-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912191807.138502-1-sj@kernel.org>
References: <20260912191807.138502-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBAE7180007
X-Stat-Signature: t43nyssoqbto5tmy7peocsshpuei9cke
X-Rspam-User: 
X-HE-Tag: 1789240697-664648
X-HE-Meta: U2FsdGVkX18um5KagkmkSGePK36CLsHFF9q+vnznDfZIr5T3wML4UyJyJ5UyQG9YPxYHi5YWdpGlZpKdJby8cI7M95zsVmOAGx+bfRc/HiD7IiuCefjtVTJ0mlh7XA93zoMFZW5oGjcHnDXO60oqlk5DXSE+3bs7YH7AwxsKGPUtFV6UWyYlKBehrUptJr+b3bIurnfI0LV7NhRm7GUr4elYNIiHJ6Gls3Gp1W7HtpVlMKOPGzqPCholjKAMAoNmcRMmAWfebiYKbPA6W1ob3NJrjoS8l9v3kp1sYKTZHZQBunGbz9/XIG89QHD52FG7BVcxoGrj3q+6Cu3F8mLEP4fsBWf6GNqPwRRC4KYRW1yy9f6gysCWBVJAojUjUL6pe9cGqHhmwBE+fy3yfx4eH2OMNaB1WW3z3ZYSerHxMWUrV/FcVCMLLHbvHv3OZ0j1EPGmECmTr8OR9g8wI8vgB0y3Ng2pSfsyGCImFhWVGRS3Lv2bjyI5qdbQCnByi2OE7IpKsbMZtZPquLX1WwYzytrveou1ZQ6uLFq/P36i9RnbuB5B+n3J9Ve18YypJXN0MyUPc6G+AAYB5j/54DGpiaomLdmYrYNMm8HHIWO2TV+UiMbTd5JwyCohQXSmmJp4iUD5YM9LcelJroh3VgTM5YjMhPVckgyB7zrBZa9Y0BmVUk2kxsP3pB+/x7rE34Wv8B7PpRhB/26wz2RjMj6HowxS5UQNw52Aw1EEvm627Vt0lMV753BQsWIdqanmsD0xL2o1/ZvZJHyFti3ivmthyut/X9VhPYN5DWfW6D4MmJtcnZ7HtmO4U5DxipTj5OrI0oGtdNGH0Gkhmi+F/tbkdARjYjkNES/ZRl7h1weXC0m947zvPQfeJim3yti5dIlASSRhYhfCFihfN5Q7G6D4iiPE/K2R/YOeFS5eqiwe3l2B0rjOuQKQIZK+gcAwkZV3ShWuLX6dD3UBYTFmunU
 g3X+P4fo
 ihS5r9Xz5PTwsDxc1rI3031RdazEv+lyiIp6PQia6KR1GwN9YuP4YgCYCRFecDAs+UhzYwXk326icwJDe9IB8rRbbS1YDvhCx3f0E3l4QENG/7EiFnannNfXJntGYczlUD78GqmRuiYiDHq8sdj1glAbjb3tGUqLp5xUA/JcurA87SW0/wbf7mycPlrDXxh+IQ+33spt5Kfw+K9IAs5LXJP+FExAuLBUvypo+/5cb37suaNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface is validating wrong range arguments for DAMOS
filters.  Now the core layer is doing the same validation.  Drop the
duplicated validation in DAMON sysfs interface.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8c8ab82c8facc..a4ec5d54cfbd1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2832,27 +2832,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
 			filter->addr_range = sysfs_filter->addr_range;
-			if (filter->addr_range.end <
-					filter->addr_range.start) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-			if (filter->range_min > filter->range_max) {
-				damos_destroy_filter(filter);
-				return -EINVAL;
-			}
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

