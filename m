Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D558CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2ED6B00A9; Sat, 16 May 2026 14:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A886B00AA; Sat, 16 May 2026 14:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71086B00AB; Sat, 16 May 2026 14:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE89D6B00A9
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 707C61203AC
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:35 +0000 (UTC)
X-FDA: 84774141270.01.82D195B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D94B54000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KH2ctPE3;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OTkTGsTgB4f9JogntidjyQuQUV+cR4HILgQyD5LP3w=;
	b=0nzJBZXmXqdVyzoyUotkYZwKsXS//a7hmqaOX4togdxs7hLWssxfH55U2pn2nm6upBWZGE
	sYWFEV4L9kE7nbaFqsR4kMKPE9dyHNFWlocLk4R69csRi0XPxjGGDxgMu+ameBRu0rUlic
	/n+rMVeD6EiR2uuO9mvpKj2VOuTcMgA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KH2ctPE3;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956653; a=rsa-sha256;
	cv=none;
	b=Q7FF76E/5tAuFAhhxiTN3T90hO46bXYw7YYXVr8mzbQYAOCPd6pNo4gTe3ymEKYjf4iDke
	77JYZrbGSkE2BCvXFte0dzx67WwkokpQaZbfS81wJwkROu2pfvvZRISmheDyajFMFvFekv
	vUDyXDrat9wrB+taP9HyHzi2Jqaf5Xg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A53C6021C;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C360C4AF11;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956653;
	bh=2Ec0kIvSNNzHsY2IUhwcp+UI3Lx0nH8m4xnL8yQciI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH2ctPE3z+F28KIea6irxq3fcBYKl/QSEhQUsM/8PCcQDij7ql6+QWVLIT7XNCHSq
	 HoCsNFgqLv1hiHcDQWck4HKOdDUBfG9Ss6xuNJNwKXgKB8aQgX2GTvJ00dWD6HFBhM
	 WZPqFaMcDauSCO3Ms1U2z+FymCK1cZwua/EBFh9Ek79VkpjsV/i5OM4rZiaLGGmMPD
	 yP1qsEvC64VWmvN4jRothMj+Y7bRgw5KTLLp9a2mCsrbaz3gDWWOvQXl4qk9bo3mt4
	 YusN/dCrmE49HH6Wym/QDLdLSx6Tu/nW8R1hNNrbKEQjwHJdAaVKXh97qRuJmi0i6N
	 DZyoPHUCVjm+Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 22/28] mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Sat, 16 May 2026 11:37:03 -0700
Message-ID: <20260516183712.81393-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D94B54000B
X-Rspam-User: 
X-Stat-Signature: 51i8cysx7wkxg94ag1ykcnc9pfm7kaxq
X-HE-Tag: 1778956653-558660
X-HE-Meta: U2FsdGVkX186NYbhDqELx3Mx75kEcnkUE+8eSPIO7Pa9k5vEjQFxbNBSTZ2csdDwdMJJq4y6QoRUV46hW708VIlByAOUavvD4pIVdqhiPzYCbj2Revr1j0OzxEmasl5XlMMS8Pt87ezkF2wXywY49fJUaq7f03uoFrF5bSu2DSpL7HCzi7JKZh8iSMOWMnEk9wQCUFosMgm7FI1vnuDJN2cNG2bJ0oBIHdLW61/hTdyBrVw7/p/HGKhVqUE6H+T8pW+eWdnFjJ1JmmWRBTusjTcU91Ig2YO0gXRBCdln5RmPq23SYEFZ43ry2XtiA9ewEpe24gomwXAMx89rDPneJtapBbQFK6pOWrXC9YM77yNqSnMWes5qgUV7jMX3gij1i5qPMsE+MR2+c/SSUZIK8XDRStO91ReEJl0R8W1QCPsPdI5+r0erdij2aLE/Njb3GA5F1DHpkq/g9BOWnuwqjA4EwLK7yzAlq+2r4FQ1zvrFRvkiauOjzzmKhwlvo/iSvufClc6NcWyIkgvF3lrtMjuwFSrqdth69y44avEY5OtNAh0q7t8pl/iNF0W4rLrMLBxCOE1FtjFjWDTwTM6B/y8VE8IPMTgaWSSnlc83vCU22R6n08zNhnlbTIpPCn+qB/R8Pe0wU1MFji+CRsuttSFXmJZ48WDi8YQxwDZe/zxVA0TK65HOzj51weYOLjzqhtX/nAOickpGsGRtH+LyGkJEwTri9+EGRYT76Scs33AuZX88X0aQhSKcisrK+Kq9nHF1kkGIlT/EsaV9UvJo/vcU1xEwmDzHXZVWrSRvf2O+dz7oQa0HDN0ccb9pLXxFIZn62of4CyifqOPU9A25jCW2oWklw5aq3fyMrH29Cg6rlM9j/UMcuYDmfz92AkhJk3qNqzIQUiRJZuX/0L+7lDWOZLP3X1OjaNDHknmaYoiRArjtxiK96ZZsRZ2cmBsYhG/lNnKymW3MVd7gsCm
 ++aRzVJY
 uvsCElxo/bKPUXZuTEhIpzZMQpOmVgarykwRw3Igd5AIVliu2Pcf+zihikIa+LpIDxU6wrjqv/4mmq0jlgx7mfVKjqFih+lnwruhKo99tFuTP3FZ5SdVCUHjNOQM8NG9ojLhB3vUzq4FxAbdiyOFeyToRnud5nafL9BHX8dSv0KyosMmcKKuzEc8vSVP+gOAfhDTLd8DL7/bclKJXdWZ3hbpUMlvP/wBXol3Pok/KOwx0axFmJ4BSj2qmwIlfbmLYWy3KrV9sqf3hdLa7tJJ5maOldQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  6 ++++++
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d3b6296700a08..56a76781fde22 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -733,9 +733,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -744,12 +746,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 11b513eb077fe..332d13d9f8603 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1422,6 +1422,13 @@ static void damon_commit_filter(struct damon_filter *dst,
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
@@ -1446,6 +1453,13 @@ static int damon_commit_filters(struct damon_probe *dst,
 				src_filter->matching, src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
+		switch (src_filter->type) {
+		case DAMON_FILTER_TYPE_MEMCG:
+			new_filter->memcg_id = src_filter->memcg_id;
+			break;
+		default:
+			break;
+		}
 		damon_add_filter(dst, new_filter);
 	}
 	return 0;
-- 
2.47.3

