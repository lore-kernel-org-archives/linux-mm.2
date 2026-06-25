Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5EBCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F086B00A0; Thu, 25 Jun 2026 01:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FF06B00A2; Thu, 25 Jun 2026 01:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23DC6B00A3; Thu, 25 Jun 2026 01:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9CAE6B00A0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A7C0167577
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:28 +0000 (UTC)
X-FDA: 84917254296.09.5A39661
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 985AF4000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MTOpIr0H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364106;
	b=dWACuvd3YstEjEstjBLO+OPp4ThhYudE5ORinqtIot4Rp+xiJNyJdC2fzD2usifvpYEkSx
	/NueUFKs7V++QcK5BxiN67auN/TkmTamvBUdyIeteOFbFRa7jwfIh9faGj1FLjlTDjh54F
	zdxBMDjVnyUsWTquBroMmSsKI5ZgtEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	b=AjYUPxQkhWaaIukmv6QjMc+t6kg9gwcJTI3goDuN16NE7iPK0jz5QS2xTrmwmYqXKKpijn
	OoMTVWypzsY6R+xrXeHiHphsY8+ON2iWYklkqbRs0bmM0do+tIC/fdFk/OSmW5nTM3cm0u
	zzp3ISbOa8YDvljHA0elgm0lco8HYaU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MTOpIr0H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F9B9600C3;
	Thu, 25 Jun 2026 05:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A601F00A3A;
	Thu, 25 Jun 2026 05:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364106;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTOpIr0Hgy75CfGgKJmaPpM/6Mr1aU5CrRL+9S2WaFWZD1UQGeAk+lmJNrA3JyeKT
	 fZIPQ4ikxTdqq7ffEXL9bCfS8jOaXz88siHyyTdwbJN2bhXzHO8H7zrUVKKSG3P3dm
	 gqUo8kss/6kId45tmu6R1MhRQsTyEfjIfMwhF18qDFuM1e8XzMbUF9es3Kn5iO5nRU
	 goEfoayO0bADTHe52YUt7cuj4GafYOk+jr5U7LsMrDONXPA7KK9z6qWluzwbZQrv8n
	 LyIqAggYOANMSsksMYclLc3hEyC15lQyz4hGLCo2cS7mVRIiJuPulVlnI/ivUMzMit
	 yEccVjxv1DFTw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 09/11] mm/damon/sysfs: split probe setup function out
Date: Wed, 24 Jun 2026 22:07:52 -0700
Message-ID: <20260625050756.91115-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 985AF4000B
X-Rspam-User: 
X-Stat-Signature: edojc8mez198wxsuigutbe3ttofzua6r
X-HE-Tag: 1782364106-376641
X-HE-Meta: U2FsdGVkX18wNNIt1Tf/hbfe5Wgbn+053OSzxgfyDJRfxW0w2QLqpa4H3SGRM9w+IpJPZzSSxCYpkADpkbcC3n72XQDJdKHOpM32WiLKIe8YOkh17/AKkCAGMOK6xJWxgX1QkHR8icSkuSu6B+6BSrIUxcHnUs2iTcpdl9GXNdTamVopwWG6G8Z2+XnZw2UCNljTRPlgR1CwrlVHcgmEmNfoC9vjBucd9ZyVsvDD7vMaZ2zmPfSPLnKuerNt/kCQl8L4Ntb4NlByaQ3KHTDSZi951hxEAwtVWAsf3lGw8Jtfw7crJGYOdMbUTvYV65s1lRE3UwpsrIscMfG8t8gEB/UWskK2c8AvU8jUxrWtSPCcoHfpP3S69SRhYVL79kvglSR+WHmU5q50mDjzBVcMp+bahYSy2KIWvx3wBxhVbrdaXMcL7csaU965XVutNTyANM6hZYwnma8Mr+hXkTZx1NRUoIL31cA9RA2oEhteD5CCIgdKW9tTwHTAbdVscRR/MxpybKSfyw5djtvbQmYnwjaecQish/8FMrHvfeHhcgOzg+430iZuBWV4SoJhtaMJtvafyUOJYT+tazMKl9XcdFMgWq7ekNgxWilkvCdx3EOYgORHGFkjwWVgHmb0muqNxeGCWRe7RBHpIgrTVqcK9aJS9b9DbyfOLDTLwfoqIWgYeoCcdXBF2Hj38oLtH9kI5+ioWawkzQJPjs3RwfTKM5JaECNOKtzeFB1ce7aB0zv8GfvthPgpZ+u9pBa72/NlGWZs2ittLZ5clrP8rUFCgeTjIIMfyh3sOke1rngs7wTGMnfncqpfqJmWYtgRfGDHwV0WkvUMsLpjzrCpBJT58Vixg+p1LtXTQEvIK64d2EpM5K/hjdjgO7pHAt5IemDYMb2eQxpbYIf1oKXfRxTJy2RbdkGUI5U6btu7OxL119GGR+Itsz8UMiHO8pYNvNpGhSW3JSddyqrh6XqtBu3
 YkVfQBNY
 t0Dz1+MWa3IgL2zFP4uolZmzPp6GKoaJ/bbchyFWi16sVdLeudD0SNnbq11f+gcK3XQ5g0u+rpzqwpFZEX7pY6stK/+T5+oNKY+vMZvfAOs5b2dNtk9ZlNkStuCc2kwxqgxre4Rz8pVOxidsNt8uzLgOGHs4tGSKws0JqPDq+U9bT1CtjZ1EHQMBI0pC4i6wNh+WAhcFSsbMQkxhd0K3JshCVeHgv8SJwHmHyoIwZCuzNvA4=
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

