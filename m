Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81402C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789256B0096; Sun, 13 Sep 2026 13:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761526B0098; Sun, 13 Sep 2026 13:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6766A6B0099; Sun, 13 Sep 2026 13:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4486B0096
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90007A08F2
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
X-FDA: 85209380970.01.E9ABCC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0ABE318000B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKMbsFDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319504;
	b=XakK6wTGkFhQNyYK4XHPftGoGF9m1DaU7UlOGGFRWh1H1k9P941Cb4p0ToHm3u/KEG/Tjy
	9cA18db56MO8CXSeaKxS85GMjugAUYt48z5LjzfeJa75x32YFYgw3WCpiNAdnDPYQZgQvH
	TsnmF0Vjxy95zibNXZsWdIsYC54m+QE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GKMbsFDj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	b=3Ji//3zj2UIyXGuygCuDT2lc1PRx1u7QHJiwfcG5Ya91Cw0oP0fnj3nx3jX8V58Dbk0Nfn
	qV3+v9Viu9fWteLbbL99RdWKf+H8o5RaBrPXEXqlqwO+VvayJJOo6QIA3tCxm/XWvAYZ/x
	2B3utuOlm4HaXYOgSUhlGXT26pZQ1h4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A679560E88;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395611F00899;
	Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319503;
	bh=g5VdpOGRYXrXyCrSePa8puxBW/6Uq97itYKIwT0a6WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKMbsFDjsk0u/gctNgobRRhsNbFFlyhomMGdfqv5r6WhRQfy16vAkNgCzshYrdGic
	 YwMbXcfhEwCEUOt2A6dyc1oSTb7Jew697SjPC9FFAVAIT7q6Bv0cDmV1nFQT+hu5TZ
	 Ih0jq27BTVP25eEUy0I58dEiLrpB0iKpM0lnN9YZj2uoOI8CQ3TeLwA68erQ36KQzv
	 KYxAbt38lh8r7In1fxT9VTMZ05hgjJE0affBtB9FHR9g4I0Q1+KgU79UbKOPwsd59g
	 gyzWeGmkBBgMBcr4MH8WQunGxgryZsGqlW1sVaNoUl6c+STZBlGjrrx14Tqs3OJ7WU
	 7lpC0PxLUpocg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/8] mm/damon/sysfs: add min,max files under probe filter directory
Date: Sun, 13 Sep 2026 10:11:26 -0700
Message-ID: <20260913171133.102366-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0ABE318000B
X-Stat-Signature: qrcfgdjenenszpwko7dz1gpjmiwcsuba
X-HE-Tag: 1789319503-29633
X-HE-Meta: U2FsdGVkX1+142Kio+8veq7O8I646ott8aco6VYbfBatNOCpPlT+DtT5/bmCCwaH3JQkHvZVw3KNprUENtSUG4SSC0Urq1gUFvJSlIDT8NRFtSOpc5imllUXLsaOeP7L+rMoBeW3RUtnxIy9X9fG96Ez8IR6L+kDYCYaajqZLIa+YHDWmPbaBDrBacpsnGx4bU2fX3GDayBCVr5jGi/IHgZCs6KUeFcEOX+2SSibL/tvNTg9vPqO5h4OkaMdN+Dxm0uGLf+5WDi+woCATWkdaNxQFjZ9S39SGIskL472ZwRefdFSZc3qa4G+C0NJhHb3LhqtQTmCCcVftBAMeIIq3syvOuxr78PDkzFCVPzsLt7HqgNYlFXfMqsc6mWZazbtdmSkUrfbu9pWeOu6Cz+xALlwF8q0Jwhfe2aBx3W4JEKlTkvMv/Jy5nxoIINDN6lW3CWgHUJLJYWX47iX6AVX1il+/pXhRRXtD+6WhneFRaSpVkCMTK2g58sxCXttUif0p/sa6/i8Yqmc8rICHq6v9Ccyzcy6Ttyvw6GKazI8zd4cLGvltBI3IcTpwMqQl1uAgPLTc81O7h8BW5hXkmgVmVPIVffLZ+E5ZCQ3pTBKo8LnE/+1D1Dr01IiVXw51LCc8Le2ZHoNNlnMzPDH4ObswRgtglcda7Y3LXz4AiM/0EW38qUuU8PK8Ak8QEGJllCIQrZ4JMiI+7cTl1uMrYKeBtQK/fG2IZYvGbGdLfPDFM49Tlky9KWE1JEQ3OK3yVASXCD1aq6CafqPjMWCXosIm8LiNd1QXUe7jGW5z9LkAzuX8XzN6iJAgRVVXFXJBpBUcIuWAgPtPBKg5ZFUevx3g72BFmc0F+Bu7ONMTUl5+YyG4wSu2+R5Qbc6ARA5CwwxDWdjJG9Qc/X/m6hTkrhGfAEg0jxPuIky3eblZSero+QYTs26/5PElROaGYQrvT563/B6hy3ct1fgLOdezXe
 fLZAqJQY
 OsWQL6PQy48LNLGtZSdPsZwyPlQxY+IZNe2yu97y4/elzK5v3SBZ+WhMH4Y6VgWl/5t7gPZF2SoQP3ed589UaTHEU3rBy3WZiEmRDKObE8FbEx5Qi1WiBwyz5TeR45UF3CCnbOVkcapMMuxsDlMt4w3wZF2NhS4Oj/V3+Klmn0S731zAF8+eqpKb0jvgkQOGqBKUDnwJ1MKBvNvQfF/jQ4i9R1sLJ5c52MEnZefcQ9bNlraU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In future, DAMON sysfs interface will support data attribute probe
filter types that have range arguments like the newly added
hugepage_size type filter.  To prepare such supports, add two new DAMON
sysfs files, min and max, under the probe filter directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 51fa506c879b0..8e8d89b8ed981 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -975,6 +975,8 @@ struct damon_sysfs_filter {
 	bool matching;
 	bool allow;
 	char *path;
+	unsigned long range_min;
+	unsigned long range_max;
 };
 
 static struct damon_sysfs_filter *damon_sysfs_filter_alloc(void)
@@ -1127,6 +1129,44 @@ static ssize_t path_store(struct kobject *kobj,
 	return count;
 }
 
+static ssize_t min_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
+}
+
+static ssize_t min_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_min);
+
+	return err ? err : count;
+}
+
+static ssize_t max_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
+}
+
+static ssize_t max_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_filter *filter = container_of(kobj,
+			struct damon_sysfs_filter, kobj);
+	int err = kstrtoul(buf, 0, &filter->range_max);
+
+	return err ? err : count;
+}
+
 static void damon_sysfs_filter_release(struct kobject *kobj)
 {
 	struct damon_sysfs_filter *filter = container_of(kobj,
@@ -1148,11 +1188,19 @@ static struct kobj_attribute damon_sysfs_filter_allow_attr =
 static struct kobj_attribute damon_sysfs_filter_path_attr =
 		__ATTR_RW_MODE(path, 0600);
 
+static struct kobj_attribute damon_sysfs_filter_min_attr =
+		__ATTR_RW_MODE(min, 0600);
+
+static struct kobj_attribute damon_sysfs_filter_max_attr =
+		__ATTR_RW_MODE(max, 0600);
+
 static struct attribute *damon_sysfs_filter_attrs[] = {
 	&damon_sysfs_filter_type_attr.attr,
 	&damon_sysfs_filter_matching_attr.attr,
 	&damon_sysfs_filter_allow_attr.attr,
 	&damon_sysfs_filter_path_attr.attr,
+	&damon_sysfs_filter_min_attr.attr,
+	&damon_sysfs_filter_max_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_filter);
-- 
2.47.3

