Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF99CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16106B00EC; Thu, 25 Jun 2026 20:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7076B00EE; Thu, 25 Jun 2026 20:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968606B00EF; Thu, 25 Jun 2026 20:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FACC6B00EC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3AA8A02D1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:15 +0000 (UTC)
X-FDA: 84920149230.17.FE5F17E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E057C0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfICE3kp;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433034;
	b=1sqpELUwIl5y4e2ztQyK8ka9WFNbVGWcypxAQtylKoCr48GzkOg/v0TsUUtL/WMwjw65qQ
	8xvTTZzIFzYyX+eNGsgTa8BgPutO4s7oGz+8vpgWMbB5VC6ucN+732p4EYk+JLLhKh7L0A
	U9I6FBXmnbAyhDAaY6ZE2RoZObTd/SE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	b=5m1XwFcf3iyhO7XX7BklgezbYo//EOR4TvgbrUf6WSDIuRb2m4UEjxbfGgLkN1GfSZYF1N
	0BJyWLXY+uLQm5Y+6ey3tbYFQ2jF4C0ZYYOtGAfmHt78gn2D7UpfV7cyF1tind4WPcpkTX
	/d3wAmUXzWcTGLdhrStOQI0Yspu1FyY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KfICE3kp;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83348443C0;
	Fri, 26 Jun 2026 00:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF5F1F000E9;
	Fri, 26 Jun 2026 00:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433033;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfICE3kp1MAmkg3sO4IPg+CEhVM5iqAwq/8P7b0D0kwAwI0wynL1K6Z0cHm/E9u2R
	 MaBxBpzG0LlLPTRiDBlJ7cT1NSFjSABK2RNe2IQ02GB6InNbvDzl0TCkZuWEnCqsP3
	 jEkZBgFN72CvCXsFo7NK+nQhEZpBrcvAvZLnovCOPXjygf2+yzEYrRRJNW2IFwk62v
	 GaZ4t8R//wd7rBXe5LSbuNF0S9bktlscdzw7JPZ0JQvMaB2uvEHl7XJQ8ixj0QW7ZO
	 bkpwlGQiZsWLnENtyNVqve0VjP7Jr8tXXOcx7BCVQxGQAihtWStFd7fpNNDPXHpyUd
	 AI7P+UuwUUpRA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 09/11] mm/damon/sysfs: split probe setup function out
Date: Thu, 25 Jun 2026 17:16:40 -0700
Message-ID: <20260626001644.85825-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nrstb3jq95fd77cswfjqemtdf3uu17u9
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E057C0007
X-HE-Tag: 1782433034-695953
X-HE-Meta: U2FsdGVkX1+xJfW8/oR1AqI6lgVAlTVFbPDhaZ0QFhf7FmlUvSP267liOJy+Ma5qCXkR2DXyLRQVzZI/wzCcyPixzp4njh739cJQOjiupIc+gZnGuQ3lqy94+GTHQmavy8IEoeYdIsaWHGn+UzW9Z3zUESho5d2pagkEP/mJWbTqaOhwlg/RbJ5cmqJV8hhqJgjQPEhZPgeDuuJ8odbVziRCW2SkBeaKMiS7un73VBFkPunJbZl8Et+uVKilRisIYGtbYQ9alRGMFfX8+UrfQpME3KxrzqAvFcHKOKA6yTQIpetZ2p8PRzCjuQgtOUSjJombrPS2JBb0Vkj/Hsug8QRazYlOjiAa5ItMSl69vNVGoPVU3+iJgka3IdH1+cIYQhkAdkwibRSWKMYUFEXDQeV+YONjK9mywGTq5ExTmAVE5HI9l/54HYy867m7C4HVRbecEY/3r0sAoxtajqkxIiYJ9BOGOGbxaoPG4BayFWzUgbcbgOLJ2r4zxAcUMu1DNzNByxJsQgtUSkniKtkRsqAA/cpjD2gET938A8xoQzLCc+XhjLzN+vxRzbqFG5e8qKp86IWmLEJUVqYYFnExB5wu6+Ajlv0y/DYrCncYa2G+q4o8UM4spf4Mm+yxFVZmT2wKEwyP1Y4/UXwx+8zSSUAfKTJGJKDkLtMBOZ/p2A+M9/r3ONGR2otbqc3WmmAMyYLdO7O5OkH2wuaDmgT5Nz3o/8aTC+/OtrP8whxFmpWRKV4ZMWbQ+NeC5GG68FYo3q3j4pqdhniA0x20YSEjdU7ZstcoKjEcqo9xObSvnAvkNpb5EkKGoM21vQcQi+JbhybaaYiAk2YAsSQtnlVJnLNq72E8cNFik+MrLu+vXnZ82YvCzRYWe6IyLYag4ivDuYCOnHwxThXXtagvmZpxQ0ahcBDBT2w6mCFNSSc2EU+P+/6rCip4mpxL+Hn4qg5hT5Kiqi3J23cW9XcDmeP
 jp3DNGwQ
 O6ycB8IWXYxyX48uixnPtzqNNwQxDwtVX5bt/9cAHOEegt3KB5L6JqOmqrEUfskR1jO+CyyzXvzEpL4dWEybhyRAc207xCW9GJ8Q5lrzS28s2s/P0muS9F1z1VV3ZpEBYwBQ407q5Dfnat1pTudJpuFLuc8mXNq+nyxNT4VaC1iYp5i018Bit/E4wU86fh9AKUy5z0m+R+TIQ2Dx2hiAfrIWSROAth5s+4YWcOZdNULeLJz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probes() function is relatively long.  It has two nested
loop for setting two nested entities, namely probe and filter.  Split
out the probe level setup for readability.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 ++++++++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2e95e3bac774d..982d824f63c21 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1899,47 +1899,59 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
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

