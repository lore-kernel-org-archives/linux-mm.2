Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0163FCD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B11B6B00B0; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8358E6B00B1; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660526B00B3; Mon, 18 May 2026 19:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 350006B00B1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0D95A091D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:29 +0000 (UTC)
X-FDA: 84782164698.21.98B271B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A7D716000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RuSV5quI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3liSG0ipqmKK1n5gionglB6GxOeMU/B395uBwpEVKRE=;
	b=rTxbRhUSd9oipYlVMP+q0OMRE8vkOH0y3mQfiqqb7vp/i+GrmIkHgmc/lv3aeONGCWt1DO
	fD7US7Ijs1BFg/ERCkXF28+lF0xD+2fGdE04Q+trwEGzN/RwgXHON7BkJRUB079GJhrKmO
	Bd6nlf+YROfHZ8Fqt8ajH0aoCZFD6Wo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147688; a=rsa-sha256;
	cv=none;
	b=TKjRia8YoG3HVqZQYvzcTAgtdcYMiZnaHW+x5v++XIUl2VPTJFg2417wSYOmyaywso/GNW
	LKtUHT4qBLvVECqS8GN00R1GcZb4Ccdvy5lrpDDHk7fGQw4S+RvF/e0Af8T/CYD0wCxXZs
	oulBn9FL3gKSytyDuNnfgUxzgDMqcAM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RuSV5quI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F326445CE;
	Mon, 18 May 2026 23:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8B4C2BCFD;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147686;
	bh=MsWu2zyYAy4V2rgxAX8KgVIMloArlsZthg7SEALRXSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuSV5quIhV0b64AbZG5woewKGNkdF5ETDSlswFfsQrXoh8vBrZC/rS1nhl7rIA/4u
	 dlPVOA6B5zZ1OCWtsWKXx6dmQAQW2ef27EJCzmKdq2IrxwZaOARkO1prRsk+fd12bp
	 ARTVjTAhqcafa5P14ZMMo6Pt0trdOb7C4OnX8sIxtVCca8nQMDiOLk3oxZI0n/hS2L
	 6Hc9OBqWBMKvCnAU3FDJVXLIjpHg9Sz4s6woapDq/141bGs1Cne8Y8SaHNM61DF7Gi
	 2xi+VYTj4xyuYxlBapN/PhX12FOyQNDvk7rt82N8BeMxo02EZeoWjaAxQ32QcnB/A/
	 PMHCeB/zhxIMA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/28] mm/damon/sysfs: implement probes dir
Date: Mon, 18 May 2026 16:40:57 -0700
Message-ID: <20260518234119.97569-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A7D716000B
X-Stat-Signature: f45kcua4utm84qzhkypd7fee3q9iegzd
X-Rspam-User: 
X-HE-Tag: 1779147688-337375
X-HE-Meta: U2FsdGVkX1+FWQ+Y6v2sVRRznqXzJ2hikTMHmJjvFQcwBmaYc/VXbfRLMfK3AUpsSdZp9H2vSpmeO5OAh+UKiMs/MujQXgHx0pWWTaIPRVkuPxl4XfetQws271osRYmjN9rjFgI56kjxfESJdr/Uj/cvkqE7P+rmHLtEzHcVr9a2z1JcHxyRkaHRjzdVUSsYyzvMlV7jkG1kOzsnjaAjGuf06l7EGmKWF57enRt9z7QRxrsVhfBOEBxgCwNUxf7cgMD5IO+dRQNoOCJnalugnZGoDvmx/Hp44fS7wVXqK+3hXQV2e4bwof5bq2So4A/lAzv2F18HmIk3YyifzgRth5kbk+s1KQ+W/3IEtGjxj4TJuzSMhNbQEdRiwiuEOoY9M4k11a/T+QyBkbast7qkT05yOLJkaRPezLvUZQoL9U2Gg4AL/j7hBgqEipcHEfpL45v89dD/kZ3twjPSrzfhjueeBixqkrv14xvlA6OpowDkB1Dgh1RZbBXmIxbIVFkT6iYrow4utXwcptzQjRMJN7kje9SJRJDr1PxHDXEOHAJx+KDK/aSt8RPnCsLRThpRD5u2XIHHzzGI4dvncXP3+ORY+iETEAQvYvmJ8iSCIOS24iLXlKsvPuzBG1K9uyH98ymcdGwEfRwZm6n1LmhoF6wUGD0CWrLTOXP2GTpmLlmYn9tWCGgKQmOaRgXCgyifvYwdCpLJ1hsz4C5Tm+k8dDFHQroHkdQSJ5d+5xgTLCsVQPFzFBm46EqL3WcOK1AjjUs/KXqny8FbbrHH+TiKPsR5lHK04gx3pviUmBaRPzfoNVYqydh2EhTSgsDmKR+jlelpLJPOzmCxUO3sqHzsAuWU7mtLDJ0t6VahecUu1MvIsY/SzcG5ry7HMGGeUUrAG6Rs64uwucWQpHB8pmA1t0imBRgLxMPaiUx/uKuN749qTvctE2FYmYwnzhiY5psiBbioDfoo2x/FMQD2XLq
 rkQUmbgU
 /sxPmnz5Ke6Q72bkTdkquF9HGu3TrrI/cjFeM5DE4TelWcetYlefUgL2ANNlev2LRrtgDrMfmUDRp4mWXXlsjNgvjMje+zuGsV17WjoBseP2nYZC7KmKDMEnPsgMtqa2ytzdstb/CW8UdkG1mwS7PLv89oncOPZKMhM5nflcEV3pw53SCgHzh6QTM8HIHpRMHBS9Jl7WYVDNx56AX2d1siwzG5BSGPaMeGgMLjqBsiQX3f2k=
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

