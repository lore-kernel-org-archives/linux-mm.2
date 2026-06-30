Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9F7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3596B00DF; Tue, 30 Jun 2026 10:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B258F6B00E0; Tue, 30 Jun 2026 10:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16546B00E1; Tue, 30 Jun 2026 10:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 666B36B00DF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB74EA0537
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:50 +0000 (UTC)
X-FDA: 84936782700.21.22ADA45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47A614000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Le/IDJFZ";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829069;
	b=4WZ5T1T7dLfS4QcCUcL8t1K3h4dQNZnCOVMA30mvYfRco3aCvkhb3YebuSUMtZMVYAjpeJ
	sbzIqXvd56969sgAjoTbkbF15JjpAUuV4yGeXK9vTYnnmw2GvuEAHiL4VyFYtmzPc5rD0i
	IGuG1P26hLuIwBf7bYFahywCAJPTAig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMClHuJCnm03p59Q5WZmdREjq3/bnb9cFWhoj4p+Z3o=;
	b=XJZwbXRmQ3RGqNtLcxiif3ZG5lFTHWtsZ0nmqs1FvNfEA72itRyb8oj5dmITEF/ld9B/FS
	1s3nw1TUQ+OhssbxeYhlEVOEhuzHeTRt6erXl4sNC59q6QBAPmDy958Pfbk4sQqHCptvb3
	hxNYL5iQh0wLNfe4K5YePNFDYzE0h+k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Le/IDJFZ";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C21F0601F4;
	Tue, 30 Jun 2026 14:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B5A1F00A3D;
	Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829068;
	bh=EMClHuJCnm03p59Q5WZmdREjq3/bnb9cFWhoj4p+Z3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le/IDJFZnOKcym8aD6P6r/kdamO4tWO0+9OiqKJkauF9zYuUeZCpK27TfbEyCxWwT
	 w+dT7iH3GYCt+JgqWWBGjO+bwL14MLTCASj2OsJ+KscSvbRqFpLNCgdYBQH0mlsmY8
	 FW9Y8IY6UQ0MIDknDQjI30pPmkMGpA0WcCUcrof1Bzm7G3eOz2ap8tJUPuWICVcJe2
	 9mc2LaNLyOyBD2BkmD8r4TUM/FhKmd+5ryrkNhDe26QQi/9Ioun2FXBfgN8r1DPp9K
	 5q+c455/Rbsg0mC2sUoLqu/nD5m3y8i5prIRqSoc6JRI+wwGeCIjtfV1I0dTvx+CwX
	 M5PHrBnXjyY8w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] mm/damon/sysfs: split probe setup function out
Date: Tue, 30 Jun 2026 07:17:23 -0700
Message-ID: <20260630141726.92246-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xqw7bnunmz3um4g6y55gj9dqpt9h8bk
X-Rspam-User: 
X-Rspamd-Queue-Id: 47A614000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782829069-177944
X-HE-Meta: U2FsdGVkX19DKXwMTEu5F9OTPRBrR5NLHh/TVGSxwJwf0DdMULaL8dXTbQQhBr7t2Jd68kA2T1cnx83wWc7LROLjO5ph9z/6iI3tJGk2RA70MwPW/mYfgXGX8PcMVDrykgDMnhZwnzddlP00hcbB8Z9A/hWoG0JrchGCI4UZkv3N7kYPQglSKhu3VelDOfg+x0ti4aPgLU4GEzNeNUxS5PIL9aoK4VFJoMbjaQaEOUdcGchZPz9YrcIKlV5gOHTqcpLhCxsuyPCANv+0XMWR+/yMK+EhmEDXMQ2iIP/940jCqZcF1pIWNzWugVT31e9D0pUKgzjnhMaGCwymkQZteLubxjgu5zBfL880y64ko0FzD87VUgWOD5Yb/g8CXqIy2GRJBNJPjpF0VRsexHuVIzbi3vRPEc9OE7srav8sCP75IXSo7+icNKLwo4TRbKoR2DfZyeB1CMiwHM0s0u2EqmqX0jtAAKwc7f6h/7KptUwrA1ws4AXecoeFy5s76QVRZt+2prhmHVGU4jPk++1vZFg4gKoGjXXB7dp39U9bNfBOfLelTXn4H0epDF94cG+iIYr9wIP9x+FUxCqTdr90CI58KXgP0NIYitf7/dyOKADO0ntUr0ZuXXgjvlG9llL8EPFp8dyrNbyli0eIUw7O3tqUMx0d/Dgv2X3gBMqIws+QPbfVddkNT121eBZl37/fzXQdXjoizI/q9Kr6mC2UOqTwFYDDXxVbBaNkTWmTFZ95fzVagInNkcT33UG7ePbLCQ8N9+jHsmR60mbZqo+kBVgN8GIwol0//STE9cIeyAus5g+Num5iDJhY2Mornd1mTR41Oxf3R1xmzLsLvVxTn2tVffC7j0gaSGlnA4tBaR8582eCN0gZQl4BN0WXw2+yfraXdIMlktzAoWwpNdaGRfoMPdqdYqVK/mfLIhAvoQj6X2H5gqm/+KB5HAKeHp1165WW/8Ma0IzCVVIuZ+e
 nPgdDtAw
 kxxNS+cdb2Lo3becTNeBZC7SCBeiGmT/YauLcCLdZn4AhlgXDiOYFObUlqxiV8YU4+1FpycNjl5vzni3Vfvoz2G8kNs4sbugr1KqjAwGVtEcAB1e6A+1t7EE9P/x2up49IXVUPJk3pnZEXb3CEIaP6/F07H/bsM/f4Zuj++SHydGUksWehFjGeXmfSb5qz0WP9PdNB7sgrgQ/wjVYEdn9SL+XBsIdWdD+r5y+P+7/go5iOAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probes() function is relatively long.  It has two nested
loop for setting two nested entities, namely probe and filter.  Split
out the probe level setup for readability.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3526a263e205..02afd37b04df4 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1909,47 +1909,59 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probes(struct damon_ctx *ctx,
-		struct damon_sysfs_probes *sys_probes)
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
 {
+	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	for (i = 0; i < sys_probes->nr; i++) {
-		struct damon_sysfs_filters *sys_filters =
-			sys_probes->probes_arr[i]->filters;
-		struct damon_probe *c;
-		int j;
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
 
-		if (!sys_filters)
-			continue;
-		c = damon_new_probe();
-		if (!c)
+	for (i = 0; i < sys_filters->nr; i++) {
+		struct damon_sysfs_filter *sys_filter =
+			sys_filters->filters_arr[i];
+		struct damon_filter *filter;
+
+		filter = damon_new_filter(sys_filter->type,
+				sys_filter->matching,
+				sys_filter->allow);
+		if (!filter)
 			return -ENOMEM;
-		damon_add_probe(ctx, c);
-
-		for (j = 0; j < sys_filters->nr; j++) {
-			struct damon_sysfs_filter *sys_filter =
-				sys_filters->filters_arr[j];
-			struct damon_filter *filter;
-
-			filter = damon_new_filter(sys_filter->type,
-					sys_filter->matching,
-					sys_filter->allow);
-			if (!filter)
-				return -ENOMEM;
-			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
-				int err;
-
-				err = damon_sysfs_memcg_path_to_id(
-						sys_filter->path,
-						&filter->memcg_id);
-				if (err) {
-					damon_destroy_filter(filter);
-					return err;
-				}
+		if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+			int err;
+
+			err = damon_sysfs_memcg_path_to_id(
+					sys_filter->path,
+					&filter->memcg_id);
+			if (err) {
+				damon_destroy_filter(filter);
+				return err;
 			}
-			damon_add_filter(c, filter);
 		}
+		damon_add_filter(probe, filter);
+	}
+	return 0;
+}
+
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i, err;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_probe *sys_probe;
+		struct damon_probe *p;
+
+		p = damon_new_probe();
+		if (!p)
+			return -ENOMEM;
+		damon_add_probe(ctx, p);
+		sys_probe = sys_probes->probes_arr[i];
+		err = damon_sysfs_set_probe(p, sys_probe);
+		if (err)
+			return err;
 	}
 	return 0;
 }
-- 
2.47.3

