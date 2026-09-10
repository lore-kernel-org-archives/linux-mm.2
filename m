Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FD2C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8496B00A0; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162956B00A1; Thu, 10 Sep 2026 10:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89CF6B00A3; Thu, 10 Sep 2026 10:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B86A16B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E15440516
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:03 +0000 (UTC)
X-FDA: 85198059366.17.3E3951B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 716C520002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcrDdV2O;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8SWQuWvWu2mDr3ZPa1cO5y8fbw9Oppo9ANwQ11kECE=;
	b=w2p5IxWgE11EI+Kjd69UH9fQtS3n8rLgAGn4VF/LhPY129pwY6d3Q6P8UMSidHd2hQT9Kc
	FHSwo4GkiVJSDLks5a+dcNxABGfqdS2uPcB74TwFIUinrrKZXV1IWPO3pRrDr+pXN4NZCB
	HetFwT7BFXTK51CpxB1shYtHNltqRNs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DcrDdV2O;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049941;
	b=XGCseWsU2xXrSMnA2UA1clYUu4xBAmOEIiWQjJAXe8M82+wiKvuSUv/h7DpHGSW2FtvSsN
	ulV9CiiWUnXrNanUY4dkbywx4eL5M8SjdeLrEGIz5KFA/8CdWZApNvxDeWMO4wkVkpPXYX
	E2PqMaOUtpygd2eCxmCYq4mIABTLi70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8B4343D6F;
	Thu, 10 Sep 2026 14:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755CB1F000FF;
	Thu, 10 Sep 2026 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049940;
	bh=j8SWQuWvWu2mDr3ZPa1cO5y8fbw9Oppo9ANwQ11kECE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DcrDdV2OuRczE/ZW01khn6Ch9zyR3ESaeUpagDfMSI2MQIro4saeKfS41yfx4KyGB
	 iTHZvtRAZNMsDC3NgX6oljEhhaMzFTZvrXKXx2aF/NDTOr9mP+pkyRwd0UZuTxQDCT
	 jiiIcFVXeV5lbVVI0HXhz6XLI7YuxqoqeGH42A7mPEOdCwe4ZTD2r6C3rkBGw2Rmix
	 Iin+VoK8BZsup+gJ7Ztbvox5N4vfCEZXh4WfvCGsT4Og2ha48qhvoKgEnVFaC5oH8Q
	 7UYIDJzbV39+W/nE2v1zSPRA1OiEy4+rRSOZ06UXDdGhKNT9aSu5k1J8V76uT/xyxc
	 nx6g4XHB7NoNw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Thu, 10 Sep 2026 07:18:41 -0700
Message-ID: <20260910141849.170896-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910141849.170896-1-sj@kernel.org>
References: <20260910141849.170896-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 78f3r3ksrnr8m1gos3zqtgtcctr8gao4
X-Rspamd-Queue-Id: 716C520002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789049941-864957
X-HE-Meta: U2FsdGVkX1+CJ4CrzkvAppvPCtB9pwxuINIcbwnAK8Jth9KpqDmARuvqIRMKZUhe+GSOSy3FT6SkLpbWPPpIlR6/m+buzCqbAR5JLTv5pXk8eySfW6+/GkEvZzHF+0U/HyRvSxVBtC/hLzjFvdQnw3OtUHf0WwCc0bYQ6ZkMqVfwtCvtcedaAcwrGwcfZ3eIUDUIGsRwrPzfIUUY/LKp9f9fVcR2UVUpEF6KZDrCo2j8J+MhyXA7f0wlqZWytKpbp9Gsxax8VhVE0Lc0ukhw69b9BNHFRN0zFoQ0fCN2vszyqFVZbMy8UXwI20nQbc5BTTKF+NmpTzgIsi0wJmP3AzGlix1GmnMY8t5Y2zwJR66nx5aLFsr8Cr4D6J1EQUQ43UXGUKeXcDMGond+dG3jEhpOLMA7xnwMZRoZ+mlOPEWSUzLqtNdhpqyKgVTC7lvAssHBxRpPJ9fntbzTZLG/uK4SxddJ8y3gdCZOTlRhHqTVuAQJrFzHAYaX9lCa5ddlRdBxyzSGbmxoHTFtpLdSFv35mW/PaGL14YeH2c4pRDFDxuzeHmnXpzLA+KBn2XQfZ+GTFa0RQFJ6GsGIK+qm9dcg5+D4qcZyRoPkVG8mOIgcOEiQkq9wzPmrYfOVk5FekouW/Ha7L3MjVG8XNwl6kF1U41mxdS1Yt5scticq7y5LSwEYWMqZQUxcoVXFryfkSXa6/KNRz+Zmgf7chvX/lUBAlT+d1NGlqOa5U5hrVWUSikqnpsDUrktDobSpfIZjqNuuSO5Awu+NNOUr5i/0uauKLBQVl6FQUDBMhZvsh83qUO1kFhh2im8i3bqluib4wUNrklvajDa0DNGE+hYyZ+J/ZQBIU9lh/D+Ky20wqHvGBkFfAUo3Ej154RpDg0SGbg26Zgt7+qEC7MLXZf53w6jyqvG/YllXdajBYja2Vu03zdMYwG8t5VomaCWxFc7AnvMJgiRdzFblTim4KD+
 4QL2BFi9
 2IoykoYDz+v4fxNsHDIFVTWVMcNOa4cb0zrKIHRNcSpB/uwI383RwsIs3HqiiCl/ploc9ASQLT73mmNKxPcwzzF0onzeYVi9/zztXRLJvvgujLdFcfemj1eqk1u/CXsWsdsWHUJ7hfIvfOEET4xpV5mGuVjJV93F3gNE8Uvh5k2xV5otPaUrpOePXl10Y4kg5FYrRYTvVOctsOyyzFyeqgraz95cTfdOhSrG7sCAwA41U+a+N8/VS32gPQcpBH7ELi9ysuXRsuIqRdIKEqiSunNQ9oQ==
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
index 871d26adf6ae5..ef99ff778ae10 100644
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

