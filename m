Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F807C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5347C6B00A0; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5F96B00A2; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FAE46B00A1; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15FBB6B009F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92CECC026E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
X-FDA: 85036864794.23.7F16364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id E72B3C0002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVgUePz9;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yJj2ZFkc+yp+KChpPtjKxUM1furNtj+IkOWlffAhxQ=;
	b=cJzV3s8JqCJKO7JEAYU+mTqnaenvHTdZT8JfuWKfdF0jOqepaCLhnVMXCXRFLs7dZpRU/k
	YtnTVNCDQIJvVBHmtNUQ6Bn8DUsmV3Wxa5ElobzrEn3jU8UZnv4TRN4i/cXZwQSsamUUoJ
	tmqB0tOdxZOBgjXTdHQDIS1tELAb02g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211976;
	b=AxQTRr00oSiHsAE8LpERvH2krA9DgUi8TLvDWNma5aqe/SeEC4Q4bc7dqvAq422Cx/Z8w/
	XyzF8dUXkQFrwwWPMyjoGU5GktiWVlsgJ/WrmYAvgFoMjJ1ClvtnEcH9X8lK1AY+5yRQfV
	JHkJ5Q1JZeNOxGZyCk1JBAjFeee1qm4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KVgUePz9;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D96841618;
	Tue, 28 Jul 2026 04:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073471F00ADB;
	Tue, 28 Jul 2026 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211975;
	bh=2yJj2ZFkc+yp+KChpPtjKxUM1furNtj+IkOWlffAhxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVgUePz96y1L65EFHBLf3cfL0qHfwHwU5csEA6Pc4XEATVh5hbgDQS/+aGKXyqb/Q
	 zdsG4p3QRL8L2pvGOL7KhRTrCJUFj3VvsYgjihI+jpymggk/UKzmTk9SXCqbWE2+OH
	 bsJKpgocozn4wjVAF1prMWPLCYndi9V2nOh+lPk9XL9Fkhdsau+Q7fWsCNK7M8EMKK
	 SNq4uNdtQtcsbuARTEmFkUzUoJiFilxAMvC391+47NccUmDGQ31yX0qWu6S+S6UJuJ
	 R+HxABfoph5askdWN2r7e8suRCsj7svboTsyaL9tzE6hZsgKzWjZOJY0aZ5g31MFqA
	 1kqmTURfYaMNQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 09/17] mm/damon/sysfs: implement preps directory
Date: Mon, 27 Jul 2026 21:12:30 -0700
Message-ID: <20260728041242.187380-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E72B3C0002
X-Stat-Signature: cdpewd75cr3y1mffjo4t5qn993hj9m4j
X-Rspam-User: 
X-HE-Tag: 1785211975-508976
X-HE-Meta: U2FsdGVkX1/5PleBnebmW/TZOzjJe3ymiO8AlnC07n4tnvqsYOuUAui5c8nryzFqtr3hMmJeFqXremStDYki1jadt2ODPSu1nUOzWplUvWnbwYWIZxFNPuTXGSYbCUdRDdztGmIqLdc1JmbF5fKHx5T+SgoMDsel7J9yxJD1c6RA80sJWh0XTKpglMCRAHnIIbpgfpgKKLsbL227NdDss24XYz+S4Iszg/NwZBsQsHPl//AnYsxu7kYFC39PtY9zrO4yTz5QVILzSbac4jKndPwngjKJxLiUUpLPykwcY/KWXiHynRYepDePRiHxnhYllAsrR45tchLMXRyMhdSvRuzibGO8rbbpohGOSAXwGTKFPpLW65tP/LjwU8gsptJ4Ep3IJgpoFS9gx1yrnZHuFVl/1mEn2UQAZgPhu/SsiBxggyrfc+aouF/37IexXn/OcEorW3MbTDtiK09Ia6FBxW6Jte+LMCPtK6X3zW4MlVZa/mr/6kfYGbRcJg5zMKZXDG4O5sjAdsNmzmjlRPF7HQhwZniqPce//VyjwJwDd0eAIoDxj3EZyiGePLkmI3FHrIPOdzLGHaC+1tXe9Bdj/8Gnc7IPPyEDrPBr3Z9mQRPTgu1KqHy8cCVz+AFbopHzKMnQ2sC2ARRsZB9qlNK+iCnw97mGd+8nsm8SLG5dyo9ACF+/Pwd3kXyfX14cU7zWqT/g9kY6KYKZglWZq0LjllkRvKB27Weeok7XPZii9oB9mbM6b5jtoDXIA2Uke+VW53x/s1gjkq15AlT/7QvP6cTDGrnr4Zra77yRdnBMvmi1QfjlZePc827C/3ijfJIl372blJCtNuMZP6ClY+LcLeWzGo2DYesbmTxzGgticbDPdeW7Se9kSdNu+IKlJMomsHZZ0T6gEmjn/fjZzEJ5ggyqXDWJr/ax8CISSYAkX7Fzo2Vkx58nNGac5t+eAyB3mcMhp4uLGXA/L1pjWsI
 pkpJ18DD
 PplQ1KcGRITuJpD/V01SMkhu5ucqYH6ZWy0kt+y3mgnpuH1lnRIg1kSwDCSfXIxnSlt/psd4irg41+7pHcFm+1oIyf7hil3PEGjF/bem4qElt0c4diScbWpHktlT+Uq1uTmSEoaUoDGi6mwBenSiUz40371z13tQDNg9DXGVMTa+vpRde2n9niZtq4bhmviFlluse/7A2EXjbNMw7wW0J5zUBin//fHoHUQMCVtbu6CksCAk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory named 'preps' under the probe directory.  It
will be evolved to be used for specifying probe preps.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 65 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 50ff1c172d746..66a3e7de869a8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * preps directory
+ */
+
+struct damon_sysfs_preps {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_preps);
+}
+
+static void damon_sysfs_preps_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
+}
+
+static struct attribute *damon_sysfs_preps_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_preps);
+
+static const struct kobj_type damon_sysfs_preps_ktype = {
+	.release = damon_sysfs_preps_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_preps_groups,
+};
+
 /*
  * filter directory
  */
@@ -1070,6 +1099,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1080,25 +1110,48 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
 static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 	int err;
 
-	filters = damon_sysfs_filters_alloc();
-	if (!filters)
+	preps = damon_sysfs_preps_alloc();
+	if (!preps)
 		return -ENOMEM;
+	probe->preps = preps;
+
+	err = kobject_init_and_add(&preps->kobj, &damon_sysfs_preps_ktype,
+			&probe->kobj, "preps");
+	if (err)
+		goto put_preps_out;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters) {
+		err = -ENOMEM;
+		goto del_preps_out;
+	}
 	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
 			&probe->kobj, "filters");
-	if (err) {
-		kobject_put(&filters->kobj);
-		probe->filters = NULL;
-	}
+	if (err)
+		goto put_filters_out;
+	return err;
+
+put_filters_out:
+	kobject_put(&filters->kobj);
+	probe->filters = NULL;
+del_preps_out:
+	kobject_del(&preps->kobj);
+put_preps_out:
+	kobject_put(&preps->kobj);
+	probe->preps = NULL;
 	return err;
 }
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
+	if (probe->preps)
+		kobject_put(&probe->preps->kobj);
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

