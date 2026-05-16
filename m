Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D6E2CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC9F6B0099; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CC26B009F; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83256B009D; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B11B96B009E
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A4C81403E4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
X-FDA: 84774141060.06.1B17F7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA11F40011
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGYojE+s;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOCOUXrrGOmkIShfzA+sqGvb/yyciinb78vwJg3AWMM=;
	b=QXeQbNYUGO82oTYQXKHB18O9vST6VJM61jmZ1CbzdUIx+6NHinsX0De9gacWFwGNw36NNS
	bxTpsrgyrN/3qtBs3Yg1wmyZOyYpw3NS1gtr2KDMWKiHLl9PM/nrDD0FStE+IGd+Sh9l/9
	ShU81gZSowWnvNsKHlyThINNu32fhQE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hGYojE+s;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956648; a=rsa-sha256;
	cv=none;
	b=aJBL04VZSWY1eHv+UTLXcrwBNVWdlsQa3yazIFMJCDT5n7Kkfddf9zPM5DR9UOS/BHbmrt
	Pfhpz5gXt5/B9zytyGO4Khl32nbNbjZSHyBN5niF8MchwNvXJJG/eDlVCgrX15nm3SCH7G
	3XYrCmS2Rj8ksVAnRPs7lr00aKqTjOg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBE69445FA;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A7C19425;
	Sat, 16 May 2026 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956647;
	bh=iRZBRbnhuMWGPc47mimwPtAfnZSCPltTg9pBo2Ew2oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGYojE+shBdtvikrnxOfsrT13b1eW4VMwiFxQ17DjbE9RTrpRNiUYBW/ItmCHLxZf
	 8vbHrJ9JMniWgT88pKw9bErJFBu0oR+x6KbKek2PUZD23r6BC4YgY/N9t6IQYISKk8
	 TLomoYIVsPz4nVsw+I7+7arQ2y8l2/MLM/kuQpflJbNYy8C+4tvLcQTViY+eu5p8yK
	 rSCVpCHjQ0M6j0TAUGtN+8OTQihDSO7/JZj1wyol/PgcT8nUoP3ZrzGoXixLtzJwFX
	 IJcnqNWrKShJLSqFfuUIVNcIDcJM+l3acjpfqXcEiRoExOieJwDhOZRhI05caqF+ZN
	 v7O8gBKKB6rLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 09/28] mm/damon/sysfs: implement probes dir
Date: Sat, 16 May 2026 11:36:50 -0700
Message-ID: <20260516183712.81393-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA11F40011
X-Stat-Signature: x8n6wj4qduo5ctzupx8kjfgagk7g8715
X-HE-Tag: 1778956648-915225
X-HE-Meta: U2FsdGVkX1/qYLN697gqtm3OSQNLTYuDktIHaxsXFv5217Gf+x0IkzVFRETL5g4Wk/xgjv/N4Dsvsp47PRt5qCC34bICbfjuMLbocukl1ZuxDXsawYxwGCOSNaGsfmDyVjB2xrcKQ7MESQirQjazuUubAIgjhlUPACIO9TreGPI6DSWoSkHO1rxd+MzBOCRW5aZnYMGjgIWTzdP01Xhe7ARegDZC/B0qohpqy4zXgaMHMQ9avXKzXtl/H1HA+jqj9QlrNCgRtApHw7nnc57bdd2CWq1r4KzV51QVItwLg4F+ELDfUKOG6KF5pwsyJVOcnvFx48oRaDobO4XnMe5GY1axIWWaszhCzPPNkSbZxX9nQHBeSfiLjHiVZ6M7+IBJx54SrHxozychpetbdOkRAltwVLETavlH/bei+VZ68TJngrYqUco5ZzniDRO4JGjBWbxKeBm4+Rooq0k+vr1aUnTSGeA24Hn3sg8p+GYxZGG4hwh2AHiPPbVlJKSKL8quFC2WiH1nLszBYRYSdL6V+49wPNxJjXpMprI2zVkre1dHs4Sx+VltnvG45N1EDvin8ERh83YHFSA3H5199bz7kOSEwdlZWOflUUBSD2DRYlvKZWE614MA/+9ze/UCOJH+4aUwaBQilQoOe3g3Iu4Y8CPnroVimeUp633hbuhZ6Eo8cdBt+o/vzBbXMNLdFiQD96dYsYXgH791rok0k4JLiH5Or0ehNRxSzDr+rFMVRlalMrd5dfAw9fNadkRvVHz13c+Kq/Tiv1O9o2AmEppAJpfQIjwlcAyO8NYfC/5QqTSlAI83Ri1QNTRqyDwYeN+I4JSK1NNlCqtJkZJfElAb9k6wUdmMIo0x+ilgGYKFDul48ApbxxfZg/i5k5LK8DwXmy9/dR8uc+7gNCXIS8nS+fgbL2WvGrp0mHXos/3M2BQSKipNRQx+plPRRs/Mb5LwZ4jRP0kE6/iMMqZkf6u
 aXoOOzQt
 /kcNu+D0oZZalN+cUACxwbiitPbnqLueh65MUTbNE/CdjqoGxzPMw1qVzDKGi/HnFqIhbysoKDEfYjT0z1coXYa6BFQWsFs88iVXvySOmVG5omWL6XgMWgNO65ISKVQZDmWCeGaC4d4hfacbKQfaKQXXaKpAGhEWvkCYZhgS6oqHyoD7kM+dW4SKfp7lPTA0Zsf6J9U8Gdnt64LEE0yqpAltVZ8dKf+MgdrpsujaTuCHUVqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement sysfs directory that can be used by the users to install data
probes.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index eefa959aa30ae..5f3b253f50ebf 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -747,6 +747,35 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * probes directory
+ */
+
+struct damon_sysfs_probes {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_probes *damon_sysfs_probes_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_probes);
+}
+
+static void damon_sysfs_probes_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_probes, kobj));
+}
+
+static struct attribute *damon_sysfs_probes_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_probes);
+
+static const struct kobj_type damon_sysfs_probes_ktype = {
+	.release = damon_sysfs_probes_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_probes_groups,
+};
+
 /*
  * monitoring_attrs directory
  */
@@ -755,6 +784,7 @@ struct damon_sysfs_attrs {
 	struct kobject kobj;
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 };
 
 static struct damon_sysfs_attrs *damon_sysfs_attrs_alloc(void)
@@ -771,6 +801,7 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 {
 	struct damon_sysfs_intervals *intervals;
 	struct damon_sysfs_ul_range *nr_regions_range;
+	struct damon_sysfs_probes *probes;
 	int err;
 
 	intervals = damon_sysfs_intervals_alloc(5000, 100000, 60000000);
@@ -799,8 +830,22 @@ static int damon_sysfs_attrs_add_dirs(struct damon_sysfs_attrs *attrs)
 	if (err)
 		goto put_nr_regions_intervals_out;
 	attrs->nr_regions_range = nr_regions_range;
+
+	probes = damon_sysfs_probes_alloc();
+	if (!probes) {
+		err = -ENOMEM;
+		goto put_nr_regions_intervals_out;
+	}
+	err = kobject_init_and_add(&probes->kobj,
+			&damon_sysfs_probes_ktype, &attrs->kobj, "probes");
+	if (err)
+		goto put_probes_out;
+	attrs->probes = probes;
 	return 0;
 
+put_probes_out:
+	kobject_put(&probes->kobj);
+	attrs->probes = NULL;
 put_nr_regions_intervals_out:
 	kobject_put(&nr_regions_range->kobj);
 	attrs->nr_regions_range = NULL;
@@ -817,6 +862,7 @@ static void damon_sysfs_attrs_rm_dirs(struct damon_sysfs_attrs *attrs)
 	kobject_put(&attrs->nr_regions_range->kobj);
 	damon_sysfs_intervals_rm_dirs(attrs->intervals);
 	kobject_put(&attrs->intervals->kobj);
+	kobject_put(&attrs->probes->kobj);
 }
 
 static void damon_sysfs_attrs_release(struct kobject *kobj)
-- 
2.47.3

