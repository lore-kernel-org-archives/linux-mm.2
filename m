Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84741106B504
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E793D6B0088; Wed, 25 Mar 2026 16:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51016B0089; Wed, 25 Mar 2026 16:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D662B6B008A; Wed, 25 Mar 2026 16:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5EA56B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:43:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 774F3C186D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:43:09 +0000 (UTC)
X-FDA: 84585760098.03.DB3A1AE
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf10.hostedemail.com (Postfix) with ESMTP id 569CAC000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:43:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NBHrDKPd;
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774471387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DqD0QMQyj/JtA9ctoxv8NCs/SYg/0cI+dhJe9LakKXA=;
	b=v/XffXEGaBe3djN7zNmAqlaFAmlZbo2Y82E56+hIFsbA5ngT0eZ2ngMeih/eim2jJW8teX
	hqMEBoD2SsLKwfSsW5N1V4I61Fob18oNDVLta+rdydGHergdf3O1+JrrJrGkDzg0VioMQ1
	cPeMne+p3+1uFFsxU7sPPCCV20zUjzM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=NBHrDKPd;
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774471387; a=rsa-sha256;
	cv=pass;
	b=2IjrMwGoRgrq5v8LJuX2ly62hHhSJoWwQelV5riZDv2aa9ntGfIm14Ns2OOe91D8I6IjiY
	heUt6DL1b/NtnZ40iGb/aT/YD4r5QA9/HLjwV9EiBd5fvls/8nsks17gKmEzO+yLMCpMB5
	CC6mwqId0KqFcfkJbVLdcoWO5e5Uqrc=
ARC-Seal: i=1; a=rsa-sha256; t=1774471375; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=LPnT5EDHRufeL/fzhJOZs/J8fRx1hwnI/xGglnKq4JbyRPvQcLGgf/H+3TDDHFrsoi9zHBg660/6y/wfHV5sH3bjcDr6h0wYiEfmoQvbml03UNIDDVlphUgtvu+VAvipKJa0irtmsmuFs0FPbWhdcc05eLbG5zlWYeUG0R0hKQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774471375; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=DqD0QMQyj/JtA9ctoxv8NCs/SYg/0cI+dhJe9LakKXA=; 
	b=AfCrwe1CNwN5xdA7lavEEgJJ3bD7nb/fdFrniekGV7uA9nYn6K1nCO/tUx/JlZDh5/PlkXqjVryMImY0AGAXGHUueYo3eqvU9ttjOehzyHctSy8U/ehBQsBdmGXGBXjgerYzq2JaW/yPuPbqybUS6UEYPM9Uf4o8Zv93u9E2E0U=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774471375;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=DqD0QMQyj/JtA9ctoxv8NCs/SYg/0cI+dhJe9LakKXA=;
	b=NBHrDKPdkgx5qRt5+k+/GI/ws4gn1iB/heXIcwWwDVAQqt1T/Jh+l09cxl0ZUuej
	cYufcYRKaDCXKByc0OdUhq3CxKtgjYtEvgEZvD0DPciUhMU6YXxdDoDt+wCLK2HCqTe
	0Pj/OVQbvNq0HWh40WZJvECihdgRkQKjgH8NzFXw=
Received: by mx.zoho.eu with SMTPS id 1774471371990300.90080239564634;
	Wed, 25 Mar 2026 21:42:51 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] mm/damon/core: deduplicate core and ops filter commit functions
Date: Wed, 25 Mar 2026 20:42:50 +0000
Message-Id: <20260325204250.254364-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 569CAC000E
X-Stat-Signature: iiu5q67ftbjnzea85duk544hx6gwygkb
X-Rspamd-Server: rspam06
X-HE-Tag: 1774471387-992020
X-HE-Meta: U2FsdGVkX1+WNB6aOtSIe47vFqxVGxVs9L3Vu8dc9UcR9Uty7al+hfpGGkwBUJlJBjZ1M1qp16mp6YQGY3vz+FjjZz+U0lFfJE81+D1xXNcWYEFsxoxqzsiTrkz13cMygcDWWqs+BnisB6WncVNOBZNUjN03Kbn31eW9OxFS+GRz25Lb86LcdNU3nyCgu1F14SgTYJkDQNej9wiPWdR+YLU6JW3qd1vl8odGRJrtNeqY6HuBNLLfVnfcyCKjJEWDnQ9mGe0o6eFkIlR0pBVoxTK4/uzYzg1lshyJR+zbLS3nKIbpblQ5paa+A9QI5jk8ifUe+T18Cbl+RyvzFNLdLN8YIC7f8bQ9/QUXvHuLMZBRTBDdxkJCWDfMamklBeaylppV/3pbm62mPK8jLFP0341XTQyokF2+XzR0IVH16IwxnkooWkJRYBe8LGYlfez5rDoZMZq3xqNgmWyTt1dSIOj5NWFez+FYgXfNHBMnc2r0bwloBDRZlgXF/roCeXNAOpaygr8xyS9n9fA1idSQgzQnisH8CvextuFujlTZQuj3uMSJCGYGb1w2K1PgqtLFjw4TDNwVNhUfKxvBHVcLN3WSxwL/vkgaGNGSzFFNm1k2/Ye33p21Bhu+X/yJAF0YIaTTtTRLBLb9mfjof2SR0GbV2tFfbkyXfwIfemc/B2Lg3pcN6bP3EOe9TNLCRO6CXLgtYZG2d5U4F5d6Px4GpnFQtAwn4Vio16+R68CyEtdjie809dfqlSNq8qIBe+UruYNNShYJi16Y941Ul/Qsyt2ieJEN7tzfrWQTZUNpzAYiRTK/yedi89CqvyAS5Ep+Tl2Cg7RSdTzEx2sSU5PXe9H/ZLg3sPxr81sqXlqB+5dbEwORcBlJRCKeThFBpICjeWsVTcG6Ssl7JZzsjRxfbL+8Kji513wiKg2il84pmeUFY692tIy5DOSb9nm/j8JMyk5wbgf6cCHYyCjfta1
 Tn3O4GVx
 rbov+I60EJpnm7luIacJhyGOnzt6RdFjCwW2YXzi/w+LG+Czrn4LKdknFP+wBw26aBq42sTW336BvF1gUK78hevp6qGLK+21N47owlZv6bLFEcXK0Hpl7iyNw45Lr/LfIJJY7VAMwReG8rmx+K2GYwOvajznMOcxdwc4kS9WmwNTA7QJyNtGc3wH2pkVd1fwIG14deuaPQnnb67oPay9GgOUQtM0hzxPykPHLGth1wkNLzEywTk4FdvrVEu2AT9xEfIOmvQxoc33aC3DCmk0ry+MvbcHQedse6KPV7EMwwYo/AGPxDDa17K5J/3u4Ui/jZd8wpD9JBXRkV7hSqkQfdRVFxpAd7xJ+Izjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_core_filters() and damos_commit_ops_filters() are
identical except for which filter list they operate on.  The same
duplication exists in damos_nth_core_filter() and
damos_nth_ops_filter().

Unify each pair into a single function that takes the list_head
directly: damos_nth_filter() and damos_commit_filters_of().  This
follows the same pattern already used by damos_filters_default_reject()
in the same file.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/core.c | 61 +++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 48 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b2361dbf78d1..83b0542f4d76 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -919,24 +919,13 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	return 0;
 }
 
-static struct damos_filter *damos_nth_core_filter(int n, struct damos *s)
+static struct damos_filter *damos_nth_filter(int n,
+		struct list_head *filters)
 {
 	struct damos_filter *filter;
 	int i = 0;
 
-	damos_for_each_core_filter(filter, s) {
-		if (i++ == n)
-			return filter;
-	}
-	return NULL;
-}
-
-static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
-{
-	struct damos_filter *filter;
-	int i = 0;
-
-	damos_for_each_ops_filter(filter, s) {
+	list_for_each_entry(filter, filters, list) {
 		if (i++ == n)
 			return filter;
 	}
@@ -973,48 +962,22 @@ static void damos_commit_filter(
 	damos_commit_filter_arg(dst, src);
 }
 
-static int damos_commit_core_filters(struct damos *dst, struct damos *src)
-{
-	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
-
-	damos_for_each_core_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_core_filter(i++, src);
-		if (src_filter)
-			damos_commit_filter(dst_filter, src_filter);
-		else
-			damos_destroy_filter(dst_filter);
-	}
-
-	damos_for_each_core_filter_safe(src_filter, next, src) {
-		if (j++ < i)
-			continue;
-
-		new_filter = damos_new_filter(
-				src_filter->type, src_filter->matching,
-				src_filter->allow);
-		if (!new_filter)
-			return -ENOMEM;
-		damos_commit_filter_arg(new_filter, src_filter);
-		damos_add_filter(dst, new_filter);
-	}
-	return 0;
-}
-
-static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
+static int damos_commit_filters_of(struct damos *dst,
+		struct list_head *dst_filters,
+		struct list_head *src_filters)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
 
-	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_ops_filter(i++, src);
+	list_for_each_entry_safe(dst_filter, next, dst_filters, list) {
+		src_filter = damos_nth_filter(i++, src_filters);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
 			damos_destroy_filter(dst_filter);
 	}
 
-	damos_for_each_ops_filter_safe(src_filter, next, src) {
+	list_for_each_entry_safe(src_filter, next, src_filters, list) {
 		if (j++ < i)
 			continue;
 
@@ -1108,10 +1071,12 @@ static int damos_commit_filters(struct damos *dst, struct damos *src)
 {
 	int err;
 
-	err = damos_commit_core_filters(dst, src);
+	err = damos_commit_filters_of(dst, &dst->core_filters,
+			&src->core_filters);
 	if (err)
 		return err;
-	err = damos_commit_ops_filters(dst, src);
+	err = damos_commit_filters_of(dst, &dst->ops_filters,
+			&src->ops_filters);
 	if (err)
 		return err;
 	damos_set_filters_default_reject(dst);
-- 
2.34.1


