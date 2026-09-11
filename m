Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17D3C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3A66B0098; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A276B009B; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7D36B009D; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D79A46B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5CDA1C1B0A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
X-FDA: 85201628442.15.0097E08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5E71A2000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnxXKJyl;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134920;
	b=KCGqfywYOeXCKNOUpm22jDvNxy3FNzv5723RkhEukBNX8t/k+Ml1DFOJHENyqMM2uvXdpE
	KsdqEeS6bOOPiXqqJXQ93tgqc7cdWlm5YQYmHmAcSBDAnvXVtW7jIDDJN3gwilvPQN99d/
	BFpkBdr/oznDbfOZqdvF+Wt9qVh8738=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnxXKJyl;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	b=dJCT+lp/CnQ56lTJHI6qm4z9N/t9pK1yQOqReoY3SkQyS2y/ATde2CSZmW4ftleJ+rMLF4
	5qKlUw+6zgVgGGYoQC0vaT8KSZh+EEDrh5HWfv7GF7uIrxCQeL4Yb3jL/LmGq4jcuSG52A
	v8Pqos/2NHztoIi+ZGIMvWF0XOIkTXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F09F86025A;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBF91F00899;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134919;
	bh=b57SpIkbZ6AMBsE6RM4G3dlGWMR1DXMsNf+oP0yvVfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnxXKJyl5okYWsrJhnqQEEBR9G8H3GRrfqpJUyQQgtxJDYX9QWY5qajMHsnjOFdXz
	 4nwiKhr96HV4iMtCX9a7Z7NukPanS6dkcRWjrOla2EPvF3JuspFqZ0Uv8rL5TyzsrX
	 3+SK7mBxkmNxqsCrUCYYO9jX0FqPOYBEQh9RpTHjLDfjUqkoK+tgOfLXSi5I1tPfvR
	 fkhmoEMXqOtO93NEp37Nk2EfNuZom0GvVyWrW2HlSPan77enuGebbBxV8HLZiLHNDy
	 4r9nhSHYiPZfdqFPX40447510SWhWgILFZcCEgWCaITW9UdR67uPv3PJmVGulvbiU1
	 /lBYDRCJosivA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/7] mm/damon/core: support probe_hits_wsum damos core filter
Date: Fri, 11 Sep 2026 06:55:05 -0700
Message-ID: <20260911135510.96914-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E71A2000B
X-Rspam-User: 
X-Stat-Signature: qs4xizugtm8togwan4eyjjqcccntidjn
X-HE-Tag: 1789134920-563332
X-HE-Meta: U2FsdGVkX19pieaeOFZTUj/0j1qgjx512rfgkmdyOvIU4VhBZZdxH9w3d924JkM/ROC4/Vp+0kYR0HqwMRdZWQLSOmmIwzefVdkIaHTpCigyY2FVh3iF5vp4f53QDxNiaGjjZHfEhEThMw0Fok3KP1UoGkxoZk469PF/Ad+jRHIDb8j0Pu2kOMxAyFfCbMngd0ciF5M3znsQrZ6ul9+DFb+hMqGGLtpLja7pI1VIFdQjqXaMHafM9Z56oDCjsh/YG+OpVieMb/G7/wRij84PuiXuehn05xaSSZvUMZD5jioEPyTJ5KqZt7N0U57zTRWIuQZI88QELSRz9gedXkuxY8SMIisJfV5jv4KdJjKAVaawPrwC5GnitWW17M1XEc8b9JjbYpurXAz2+lNJDPTNOM7BMOkE8ugHVhtKoHwGhGffMd9VhtXjV11w4IxlSfBixZ3Y0QSQ6Y35HHa0pMHzV4+yQF4ek5yAWBl/6tSOWNptjb/cKauxEvlCKd7//WXloP/WVUR77ug3bhX2grl4rhDMJmx7M55lgfoTw92Yfm/cIYf62bj/qni1IiLvZdBb9OeKDMbr3MKPvvjzexCy+PnGxarUxkI4zTnBLU4xEqD+7NVj+EWabHpVEYSbbGUDdof2fn3O4dw3Hd2N4jhZAvjyOkKS8eRDsKtBW/ai0EaOP33a9+DNmQuxBsE6Rf+3tdwfNIOWhlVqxCFO6ybyWcv7CVuj3iA/4gxB/wZ33t0CwMAKBT8nRxVKVK5WiyuT3acmfnHAsNc83u1E6vAqtMNkijRidvizv4bbyQl+Y3dYjx58uVCkE7x/TKcqjlHO2GfObUB0ZhtFfPjdoFDG11v/rilw+lU8H3DBy2aF80g//L5SA0k7P38gF/HdbCbgF6dhDsEMlZeL+nZtUZGBZgtx4wz64OePiyezTE0PfzNw/yiYpbQrIypLB+oDHMSrGV+wyQNmuU3zFs3/xYI
 GagIYAap
 5RiBYiJz6frdVMfIeQEzDdi6KXqdPDhsOQQbdojgbXmNbO+gkAoINmX785OCwpufYfEbXw7FK6QF1ik7VN2kQWbetc6E6MEY0n+7Cf7W1uPYmV93ih80ViHG2Y45j7G8YisI5NwIdNOi6umvorfZnTX/o3a3QiSOokwQGemwuyHDwF9G1Q2WncLufMD73GOBAlD6qqn2I6qDtgt5HCbbFmnnMuw7HRupHaxtOux93RHU/HO28z85HmB0QprB7wzatB5zCbmPq9cpAncXV/aixUjavdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement probe_hits_wsum DAMOS core filter support in the core layer.
Make three small changes for the support.  First, update
damos_filter_for_ops() to treat probe_hits_wsum filter as core filter.
Second, Update destination damos_filter->range_{min,max} for
probe_hits_wsum type damos filter commits.  Third, extend
damos_filter_match() to handle probe_hits_wsum type filter. Calculate
the weighted sum of the given region and compare it with the given
filter's target weighted sum range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 50e0f9407db2b..0c98f7e267d07 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -658,6 +658,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	switch (type) {
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 		return false;
 	default:
 		break;
@@ -1332,6 +1333,10 @@ static void damos_commit_filter_arg(
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 		dst->sz_range = src->sz_range;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
@@ -2510,7 +2515,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end;
+	unsigned long start, end, wsum;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
@@ -2545,6 +2550,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		wsum = damon_probe_hits_wsum(r, false, true, ctx);
+		matched = filter->range_min <= wsum &&
+			wsum <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

