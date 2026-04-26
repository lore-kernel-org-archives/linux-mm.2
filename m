Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE39FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C356B0099; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BEC6B009E; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866C66B009D; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 595E46B0099
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 206EA1B838B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
X-FDA: 84701905680.21.3B3C2B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F6754000B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueKhhBVw;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3liSG0ipqmKK1n5gionglB6GxOeMU/B395uBwpEVKRE=;
	b=3rnqeFExvA1y9FsB32lETLrNUiDF9DUZvHUxrZix8SmTiXPLBQLnEXl/FUbJg1l2KFw8Cb
	h/On16QUPPPMAC9qziv09aSviVh5i36WiEn4EAeMVt1klPtIqV8mvvX347oJMq3pPimSZv
	IGNTL7i7KWQUA8ER0OiF51zKB4NtA4I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236758; a=rsa-sha256;
	cv=none;
	b=1GdZm05QVqo1sBO3BrlDYpKzxt+CZXOja0y4s3UN2VZt3PT+NZJd6KVnZgqgPnYsiDvlcM
	hR67RcowwecB5nqPYpgTU7RGYJm4H1DqVc7hmEUr1zjxpq/AP/G9X4jBZir9L7q7EeaVEU
	cHofnzcpNV/QLoTBfzz4cGRwWdNGbzs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueKhhBVw;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B8846014C;
	Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C31CC2BCB6;
	Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236757;
	bh=MsWu2zyYAy4V2rgxAX8KgVIMloArlsZthg7SEALRXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueKhhBVwMR6jMZ/LjOfl2hzJDOZPBed2629Gzm+zgB5LaZGOehI0gdnBKtA0+zysQ
	 33ZS7ayJPnmmPZQzJjJwPO09V3faxejpoTHFXc7Rhdr4cl8wFI6QUHiHhJZmECpwN2
	 7PSx+FC8sheHDpSo5lVoW6ECe12Adv8nD2QaQHOU/qowWvqpJt9uB8Id4mjt/kMLGy
	 /u6iekceO4NoCKCWW63K+wTdhxwzEjjLae0LyyrVKhxXKCndCrRpq3RORjrthiRfgD
	 qoahDN5BJ9AXJh9A2m2948iD+gpr+7SEhd/vqMOvN9HnfpRQlWt3wSj1uuvrr4cDuB
	 xMss2r93Zyp1w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/19] mm/damon/sysfs: implement probes dir
Date: Sun, 26 Apr 2026 13:52:10 -0700
Message-ID: <20260426205222.93895-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F6754000B
X-Stat-Signature: uzejcfbcztq5n9b6juwi5wgf6b188nyf
X-Rspam-User: 
X-HE-Tag: 1777236758-544745
X-HE-Meta: U2FsdGVkX1/QKNzOVrjijicb+iZyTkTeQ+y5Ci/0hRiCAcAuVLBf0h5M8wL2yBvFkIljRuWwbGKsRWCp+ls+Xk5VZSgszaTqVL8F8ta1113jIc6xEVisja9IYNRyqDPpw1AB0G4pkG5cA7LFHjcRDQXJJRNe6vwO7tcp4BGwFiGY6nckGtNRpf/emnodor+cK1IazfNIvWy4xWck8oV0IrTSShAZ0xT1KWWuSwWXA/xpb1AGRRIbMq+s26/3T6N5Lh9XnZYNTJ7iGsxdbZIBiYrnLDl5SLbASyDCZ6puhK5kHd97wiO73DhSq5eGr+vX9xCQ3NTdDrTAaue17KxtkiXMs6EOsScNBXbcnpPKCExrlzwL/6+y40onzDPFBNNajT96HRBlPWPaEUtT30xjnC8MF7fl4NX4o+QAHqk6hfMj+ld188luEd3TMddrO/2QlP6R5LCuQQn+4CVuxBC5NaKEr7GvocaQ1Dkf4D4wf8VVk+4z07Uu72GLwXGcBGJt+GKL60KyshtmmRCpLqUHp2Cszzeuc69RO1GZe/k6aNXAdpSMZnfq2zEMQm6jTs4EXwGOMzPnFahpVvMsDzQJ26+kcx1NtdtJlLFlrgCVHKLAPYrtBZx701s/qiZj+UNwGGMNrB/xLBeU+ad/dvMBAfmZo/IYTEOmN1/G31mhgYf9oTprKGHJVFYL7VRltiwU7qv869PUeHXZmABZKSz6LG3i2bFt+A+kBoPNaByv3EKCUPY2tt9eoKMMppF4qThYTlQT2zvhVVQFrF55hHAUZnkxSp8QPhWn95NQYZdoADfhiXc8PWKL82q9mr8GHWvdQBS72mZmp2LlAuakNhW6kxAq3oWshXK8wJwNBFtlxI4UbOQN2efQBzMAzI8pgIei51Gg6LpQfMvytvA4K1sY5P6o/Kg1oTq5e8NG48hiclK2lN+zADIotMDVt1jOJNtj/uXhmoXz/XB1NrdIfhS
 T7wwvpyn
 cqakL8V8UWx3vkbZzF03KwQpkv1rMg6/qPTOZ4xwrc3j1J/Lh0yd/P3qZzpthfCEvoCYaOG05vVAtwQByWeht9lDtRKZsHWmAxF5B1oZaBcrhurrvOMT0tbzMY2Ns5zCdmMcNo+3doCCs/ySlHXR6bXKIFDiUwJXHuq1sVPk0r/g8oWiRniKb0XOBsqm0kGIgyDkLAmcolXtprtUPni5rl/7ymnIloOLRLnciMfIgax36GLs=
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
index d5863cc33d230..ccd19fc062f31 100644
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

