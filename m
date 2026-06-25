Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BC6CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2DA36B009E; Thu, 25 Jun 2026 10:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04CE6B009F; Thu, 25 Jun 2026 10:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7556B00A0; Thu, 25 Jun 2026 10:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8A76B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D502120150
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:55 +0000 (UTC)
X-FDA: 84918656550.29.F73FFD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80818120003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX6h3onx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397493;
	b=VPjC7FoupBqh9DcxHYriU9/FBNGD2xPSmoKQeliu2o73zSi2CFs8E9ljZ1ZjpMuaXRxMDj
	iE3/MjfHJgljDudZpAUnOdjZBl05FmiSh6gA6wACWcHB7LtpyM+IPEgUb1GawBn8W1+BQu
	f6wuLCe8huh7sLF6GmlLMRVjTqBCpNk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	b=cFn5ZqkE5ehEZ+IMBJwTUnCje1CTTWheHfkbR622dhXMcLc598Xj8FUclAnlwqR8GzaSnb
	kA3iA0LCGoRz6sngaq0vAI5jU9BgPFuDnDX3AvFsigtbv0mY6JQwBIGbeC/kEMHUeVP/2J
	ydbx3xjn90CT4gtBS8aaAhpGqsyIsd0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX6h3onx;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28D7A60123;
	Thu, 25 Jun 2026 14:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1391F00A3A;
	Thu, 25 Jun 2026 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397492;
	bh=rt+skPoflDd8ZOfYhc/MuTewnEe5bpXk/xs4uU5zeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bX6h3onxlEPGQYf3PNZ2j6wn2PBhLPtbrlz7+2QYO4tIjFYsRBZdRhINQOUiue6Jc
	 qHbXiLxUNAQ/5efM6gM1ViuqNaYAp+yTEWlF7ED28r1vRTuNh9vYEWUwNfPfe1mP5L
	 ucmdbBsz0FvwS6l12z8b6vMLMF8TTHmFk8axWIuB8XCV2JUiCRC3YdQ0gYxq25Av6f
	 U6jwbOFbtqhCdOTaUGckvY0P6JrerlrkwV2WQ52XmDZCacXw5VPHIH/LFBRf5DlwEy
	 3JGgty2p7/6Zz40inUICEuardN9dBWESYxM9cGsG6L2f/sU1vHPPWO/BpxI+dnvVv8
	 LrBm9ImAXP/Wg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 09/11] mm/damon/sysfs: split probe setup function out
Date: Thu, 25 Jun 2026 07:23:54 -0700
Message-ID: <20260625142357.103500-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6y8e3ayhi95sjux3xrk9dgbo4gzr77e7
X-Rspamd-Queue-Id: 80818120003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782397493-413581
X-HE-Meta: U2FsdGVkX1/e69KxSMhAJjRyPIHaz4Rhvi/t2XTIufIdyNOFYHcjDmouic76KxYBRKVJB67kodXkmRA6pOz5Uy38CMS+5cHax/FXenMioU7I7weVTuGACCDkRnmQGbuOHX+tzp7gsnjVP3DmcN3mJgh79ETy5TKnE7wuXuEObF1ioLuzi/LDtY97ypWK8Q/+J849hsEKaBL91fUZQvif+kfT2V3Ad2A6tz8XvuzQjHCwSo2//S5HFjzvGqS2rzCdO3zX7LsQQxhpAv5JgXqJxnnyyGWGGhnxqqM9J8FuvysbcZlE7Ymj4Z8sWHAlMu3frBR1DerqZaeSvUXTClko3mv+9PMW06ta/jlh4pvCkSEK2gezwf3K/qKK+i/4rIeAILIr00AKqZKERUL9uP+r9265H8qTmHjFEIipMVbPkJXSf2HvTfIHmbm6w8imD2vj7yI+Zl/qCzBC2QDIXPJV/WZZc2kPoR1JvfmxE8pzkYFPQ29AXa6lacoSvDY16bux7vtwkRP8NjIkziiH1c3gwwDfMMCvSe6ucMyu0uice3glqDbIhEAFGXNVo9GcBrMYNR3DSI5bo9KxBhrrAv7QddGyzDzUqyaDb+AQHlpsqAtgkl3cTbi9F9QFpr3b3WOzxeQDzfMk0qSoLfwKX8MUmk+FJw7a7BaTbXToTqad1CtJGGgRwKiozwQ9RzYew9J6huxHJLqzz9FPRox/97UjK+oxvkuhihPYxe/P1hxXu4ootyZ20xh27Zqp2p+e5xlN1Sh8b4SxJtIOIxlibnubxhW4oED1YS3bJi3WqAnuDCcQQkF4eaJ1q75fEQu7OZqFbRJAZpiSO5ApWerHgdUDJDCgR7kfGrpyRuU3N5GgcxXAg02noYLB76ZJ3SraXGYiQ9MBoU0XHFpAgKNlUDwE2SKvTNCOsLsTiX5B0X+VE6XswV1AI8J5+Oi6KNwjkARN5UimrjwS0yPdtXIHJiJ
 jufvXsG0
 Nq1RABZLsTleJezDoQCcsdwcN7rziP2Dl5sMSjcutH49/xfNo/L8h0mdtPwGkhlyPNju+Ynms7FbfshjCkleN/pZgr/QXjSG5p8Isa+SfjNVAP1WIPgiWM7TrvwhiGuba+NMhuKqZyT7w2f9bXITKfDl80ui0dwS5RYxhFOGLIJvvP57lYOARa5XGH/EtfNNmocEVPKyEuqIRAp3blOccP6+23MrPoIWrwOFIYs9VWaD2mJ8=
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

