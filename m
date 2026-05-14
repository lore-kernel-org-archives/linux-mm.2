Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 263D4CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325E26B00A0; Thu, 14 May 2026 10:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0EC6B00A2; Thu, 14 May 2026 10:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0905C6B00A1; Thu, 14 May 2026 10:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5B6D6B009F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ED6C1A01BB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
X-FDA: 84766207848.09.1715314
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id C161D10000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NwcUFGlq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOW0LT6+toGfbl3Yy8g9HLidMaXBdN4qVHviztm60B8=;
	b=qCTfl1xRrHgU5XOgRXR0muR9/+AqEHN4yUk06RveisOwDlBEMjVLuTetBEfmBF7YzWf9rU
	skAV8OPxj8KxkXyVCV2jJ8r7ovMVqLk0PPfJupCbiF1EcnsSPP4D534vfvJEepK2LH91Ql
	f6qMmKZ84r3UzswZFcrDXAu8TXYMuqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NwcUFGlq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767762; a=rsa-sha256;
	cv=none;
	b=VKnXcaR0woDXSUHsiBmLlhKsQSjtpqAMNq3Ld10eBHM+Im/wp+Quzz2YXV2K9zY6D5b4P6
	TlxXJGpxRC611WmTzHnZXqbzZ80fiWMrl79JYJKCuwwo0noDYlJsuNK0FBtmUlAj0ldGKd
	7UvaWMCYtFARiRsY6QTcA4wXN85TZHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED8B4444DB;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB51AC2BCC9;
	Thu, 14 May 2026 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767761;
	bh=1X/9elsFEwb1GaGkMj7npSZAXZWCxyW00t9PKZHBG7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwcUFGlqryDv+Q9M4b8hX7Oi1fYRpiej+2W7dpKn824hAro6cx/vFWe43FKa70dCD
	 BElJLdPJQRXzNCGRLqrdl6wyBZ5UOewx7XIualHe5/0gieI23uGcMsUtjy2DV+0tsG
	 /zqblc/nvivcXbQpTfXFJo4yJ2tj/w21kVKDI9BMzjwWi+QyaV7ZLkF+MuueBiFwOR
	 +Jqc66Ry0TTBu/ZfcTF9m/v8it08OVlGmHt/N5LpUp6f1/2ENNXPZOp7xy/v1DN/Ox
	 IW1x/NEJxZHZ2G4YhUMhCL8NQR5wFFgl39e7saTWPQVKQX2anT3Okm/6d3neVdlzL4
	 oFY9D9pv1nIyQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 11/28] mm/damon/sysfs: implement filters directory
Date: Thu, 14 May 2026 07:08:44 -0700
Message-ID: <20260514140904.119781-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 83fq15twbeijzragdumcn5gchjuzaick
X-Rspamd-Queue-Id: C161D10000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778767762-529404
X-HE-Meta: U2FsdGVkX1/akPbxzOH87BZ7UbLFlmxivbJTe3V9165EmsZIrJLy8uHwB5/MQ4E8+NbSZIUZlYpA7jnyJecBJpgtE8tfpzjKSrRmSvgWTuvJZwLp3oh3ZTilZTo/d7G2wzeN/u0ad9JcI0AT5dG7QIWZA+byfOUyvJGyuxFBOIKiRUNLUIXYuU8KN68ygx9jAMlq12HVZprMbvzI0+m8OuyoVaFGGdt4+ePEMxqmC8qpXJSmGcLRtN+lKLVVLitAnZeS+R6BEwcfqOog9HHkLfN7D+is1CXp3yuQNo99TxpbVbuBxT7OwcxfYktWrCkDw65z2g/kUpd+LlgUDALBthMK7kCH2H+Seegj09HnBom5jNEOwEmgAtR8pSI1XAnO8klVHBqMej/Q7luH77LLRCSaJVJXKGEsS3x7n7GGlqUcgaKvA0MwAHafR79e2h+47zloTBn4C6Fz2v+6U8XrUojRPwM5o3qjQfM6v+4z8fiQb/vKiwfLMnM1VcTz8n0EeZuTuve+rK2GEkfbzYIQtKwRxWDGMBB5KZhfM7G4SO5ZSUHEnMvipndfLwAswRiS4/xcQ5iwWSo8sKk8MFhi0PhNF3zm3N9zWzcjGxKKq7vUftSBChXvJXEL+tWFoG1yEPOXkhoAc5Po0Xo9ehieap0/JOsfpwne0khN+7c4SqKT1WdGWW2R5N73Cwrf8ePGHDsuO1GdYGLpPG4V1kS9F4tT4DsN2eGGs52GA+VcSUK3UjmTt9ChR2obh7rJKKbxR5HH9PzfAERlhDrQ5rkMIFnoasz+LfNctS576MyDRHcYS7ZWRfk7dDEcrEekmbbATvhbE5EE0aChlaRY5rGG05aR0Z1a2KbuSHJv79w1QY3pD7MSu3kqYkcYNYT5PVyDzPVg/aPNXUia0tkboUTdsCHTDdICXkWwPw5Tbz0LclNci0xjp7S5TPg9UMhIzB1egDVYJvVr4/0YgoG6myc
 P1uV3roG
 nvZz7qzSi1eImGaDP3IYH05n+oUzaV5x2PWtK2tfA/15Omt4JlWIhZMq3veYP56pO6CRzcIfGaA3itGgA5CD8Q4nYqGN9JCxRU/zwLhGV8b+0ZffKWl1RV6v8SSC4p0ZNzyDeh0oLS3HvU9ywXgjKdwjd3yheVLD86Zf5fcIOWs+1jkWErmCtukkAIK+rTxuJhq0lL3WgqcMbuadax5cifeqpE/3IKRAVGsfxrLvvXqny/bI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a directory for letting users to install data probe filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index fac4e37aa2851..250208d3de21b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,12 +747,42 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * filters directory
+ */
+
+struct damon_sysfs_filters {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_filters *damon_sysfs_filters_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_filters);
+}
+
+static void damon_sysfs_filters_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_filters, kobj));
+}
+
+static struct attribute *damon_sysfs_filters_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_filters);
+
+static const struct kobj_type damon_sysfs_filters_ktype = {
+	.release = damon_sysfs_filters_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_filters_groups,
+};
+
 /*
  * probe directory
  */
 
 struct damon_sysfs_probe {
 	struct kobject kobj;
+	struct damon_sysfs_filters *filters;
 };
 
 static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
@@ -760,6 +790,30 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+{
+	struct damon_sysfs_filters *filters;
+	int err;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters)
+		return -ENOMEM;
+	attr->filters = filters;
+
+	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
+			&attr->kobj, "filters");
+	if (err) {
+		kobject_put(&filters->kobj);
+		attr->filters = NULL;
+	}
+	return err;
+}
+
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+{
+	kobject_put(&attr->filters->kobj);
+}
+
 static void damon_sysfs_probe_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_probe, kobj));
@@ -797,8 +851,10 @@ static void damon_sysfs_probes_rm_dirs(
 	struct damon_sysfs_probe **probes_arr = probes->probes_arr;
 	int i;
 
-	for (i = 0; i < probes->nr; i++)
+	for (i = 0; i < probes->nr; i++) {
+		damon_sysfs_probe_rm_dirs(probes_arr[i]);
 		kobject_put(&probes_arr[i]->kobj);
+	}
 	probes->nr = 0;
 	kfree(probes_arr);
 	probes->probes_arr = NULL;
@@ -836,6 +892,13 @@ static int damon_sysfs_probes_add_dirs(
 			return err;
 		}
 
+		err = damon_sysfs_probe_add_dirs(probe);
+		if (err) {
+			kobject_put(&probe->kobj);
+			damon_sysfs_probes_rm_dirs(probes);
+			return err;
+		}
+
 		probes_arr[i] = probe;
 		probes->nr++;
 	}
-- 
2.47.3

